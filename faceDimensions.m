clear, clc, close all


%Nose Detector

% Create a cascade detector object.
%
faceNoseDetector = vision.CascadeObjectDetector("ClassificationModel",'Nose',"MaxSize",[50 50]);

% Read a video frame and run the face detector.
videoReader = VideoReader('testvideos/video1.mp4');
videoFrame      = readFrame(videoReader);
bboxNose            = step(faceNoseDetector, videoFrame);

% Draw the returned bounding box around the det ected face.
videoFrameNose = insertShape(videoFrame, 'Rectangle', bboxNose);



bwFace = im2bw(videoFrameNose);
figure
subplot(2,1,1)
imshow(bwFace);
featureImage = imcrop(videoFrameNose,bboxNose);
subplot(2,1,2)
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

%Face Length
faceDetector = vision.CascadeObjectDetector();

bboxFace = step(faceDetector, videoFrame);

videoFrame = insertShape(videoFrame, 'Rectangle', bboxFace);
figure; imshow(videoFrame); title('Detected face');

faceHeight = bboxFace(4)


if ~exist("leftEdge")
    disp(bboxNose)
    leftEdge = [bboxFace(1),noseLeft(2)];
end
if ~exist("rightEdge")
    disp(bboxNose)
    rightEdge = [bboxFace(1) + bboxFace(3) ,noseRight(2)];
end

faceWidth = rightEdge(1) - leftEdge(1) 






    