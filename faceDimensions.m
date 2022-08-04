clear, clc, close all


%Nose Detector

% Create a cascade detector object.
%
faceNoseDetector = vision.CascadeObjectDetector('Nose');

% Read a video frame and run the face detector.
videoReader = VideoReader('testvideos/video4.mp4');
videoFrame      = readFrame(videoReader);
bboxNose            = step(faceNoseDetector, videoFrame);

% Draw the returned bounding box around the det ected face.
videoFrameNose = insertShape(videoFrame, 'Rectangle', bboxNose);
figure; imshow(videoFrameNose); title('Detected face');


bwFace = im2bw(videoFrameNose);
imshow(bwFace);

noseLeft = [bboxNose(1) bboxNose(2)];
noseRight = [(bboxNose(1)+bboxNose(3)) bboxNose(2)];


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

faceWidth = rightEdge(1) - leftEdge(1) + bboxNose(3)


%Face Length
faceDetector = vision.CascadeObjectDetector();
bboxFace = step(faceDetector, videoFrame);

videoFrameFace = insertShape(videoFrame, 'Rectangle', bboxFace);
figure; imshow(videoFrameFace); title('Detected face');

faceHeight = bboxFace(4)


    