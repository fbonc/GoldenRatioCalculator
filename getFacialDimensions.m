function [faceWidth, faceHeight, bboxFace, bboxNose] = getFacialDimensions(videoFilename)
    videoReader = VideoReader(videoFilename);
    videoFrame = readFrame(videoReader);
    
    faceNoseDetector = vision.CascadeObjectDetector("ClassificationModel", 'Nose', "MaxSize", [50 50]);
    bboxNose = step(faceNoseDetector, videoFrame);
    
    % Draw the returned bounding box around the detected face.
    videoFrameNose = insertShape(videoFrame, 'Rectangle', bboxNose);
    
    bwFace = bwareaopen(imcomplement(im2bw(videoFrameNose)), 50);
    figure
    subplot(2,1,1)
    imshow(bwFace);
    
    noseLeft = [bboxNose(1) , bboxNose(2)];
    noseRight = [(bboxNose(1)+bboxNose(3)) , bboxNose(2)];
    
    for i=noseLeft(1):-1:1
        if bwFace(noseLeft(2), i) == 0
            leftEdge = [i,noseLeft(2)];
            break
        end
    end
    
    sizeFace = size(bwFace);
    for i=noseRight(1):sizeFace(2)
        if bwFace(noseRight(2),i) == 0
            rightEdge = [i,noseRight(2)];
            break
        end
    end
    
    % Face height
    faceDetector = vision.CascadeObjectDetector();
    
    bboxFace = step(faceDetector, videoFrame);
    
    videoFrame = insertShape(videoFrame, 'Rectangle', bboxFace);
    subplot(2,1,2)
    imshow(videoFrame); title('Detected face');
    
    faceHeight = bboxFace(4)
    
    if ~exist("leftEdge")
        disp(bboxNose)
        leftEdge = [bboxFace(1),noseLeft(2)];
    end
    
    if ~exist("rightEdge")
        disp(bboxNose)
        rightEdge = [bboxFace(1) + bboxFace(3) ,noseRight(2)];
    end
    
    % Face width
    faceWidth = rightEdge(1) - leftEdge(1)
end
