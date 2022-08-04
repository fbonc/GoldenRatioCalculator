clear, clc, close all
%eyes
[eyesWidth, eyesHeight] = getSizeOfGrayscaleFeature('EyePairBig', false)

%mouth
[mouthWidth, mouthHeight] = getSizeOfGrayscaleFeature('Mouth', true)

%nose
[noseWidth, noseHeight] = getSizeOfGrayscaleFeature('Nose', false)

%face width and height
videoReader = VideoReader('testvideos/video1.mp4');
videoFrame      = readFrame(videoReader);


faceNoseDetector = vision.CascadeObjectDetector("ClassificationModel",'Nose',"MaxSize",[50 50]);
bboxNose            = step(faceNoseDetector, videoFrame);


% Draw the returned bounding box around the det ected face.
videoFrameNose = insertShape(videoFrame, 'Rectangle', bboxNose);



bwFace = im2bw(videoFrameNose);
figure
subplot(3,1,1)
imshow(bwFace);
featureImage = imcrop(videoFrameNose,bboxNose);
subplot(3,1,2)
imshow(featureImage)


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

%face height
faceDetector = vision.CascadeObjectDetector();

bboxFace = step(faceDetector, videoFrame);

videoFrame = insertShape(videoFrame, 'Rectangle', bboxFace);
subplot(3,1,3)
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

%face width

faceWidth = rightEdge(1) - leftEdge(1) 





function [widthOfFeature, heightOfFeature] = getSizeOfGrayscaleFeature(feature, mergeThresholdBool)
    % Select a certain facial feature.
    if mergeThresholdBool
        faceDetector = vision.CascadeObjectDetector(feature, 'MergeThreshold', 300);
    else
        faceDetector = vision.CascadeObjectDetector(feature);
    end
    
    % Read a video frame and run the face detector.
    videoReader = VideoReader('testvideos/video1.mp4');
    videoFrame = readFrame(videoReader);
    bbox = step(faceDetector, videoFrame);
    featureImage = imcrop(videoFrame,bbox);
    figure
    subplot(2, 1, 1)
    imshow(featureImage)
    bwImage = bwareaopen(imcomplement(im2bw(featureImage)), 50);
    subplot(2, 1, 2)
    imshow(bwImage)
    
    % Get width of feature in pixels.
    
    [LeftY, LeftX] = find(bwImage, 1, 'first');
    [RightY, RightX] = find(bwImage, 1, 'last');
    
    widthOfFeature = RightX - LeftX;

    x = LeftX:1:RightX;

    yMidpoint = height(bwImage) / 2;
    y = yMidpoint .* ones(1, length(x));
    line(x, y, 'Color', 'red', 'LineWidth', 4)
    
    % Searches for the y value of the vertically-first pixel
    for i = [1,2]
        pixelRow = 1;
            pixelFound = false;
        while ~pixelFound
            for j = 1:1:width(bwImage)
                if bwImage(pixelRow, j) == 1
                    yVals(1, i) = pixelRow;
                    pixelFound = true;
                    break
                end
            end
            pixelRow = pixelRow + 1;
        end
        bwImage = flip(bwImage);
    end

    bwImage = flip(bwImage);
    yVals(1, 2) = (height(bwImage) - yVals(1, 2));
    heightOfFeature = yVals(1, 2) - yVals(1, 1);

    y = yVals(1, 1):1:yVals(1, 2);
    xMidpoint = width(bwImage) / 2;
    x = xMidpoint .* ones(1, length(y));
    
    line(x, y, 'Color', 'red', 'LineWidth', 4)
end
