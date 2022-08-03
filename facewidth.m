clear, clc, close all


%Nose Detector

% Create a cascade detector object.
%
faceDetector = vision.CascadeObjectDetector('Nose');

% Read a video frame and run the face detector.
videoReader = VideoReader(['FinnianFelon.mp4']);
videoFrame      = readFrame(videoReader);
bbox            = step(faceDetector, videoFrame);

% Draw the returned bounding box around the det ected face.
videoFrame = insertShape(videoFrame, 'Rectangle', bbox);
figure; imshow(videoFrame); title('Detected face');


bwFace = im2bw(videoFrame);
imshow(bwFace)

noseLeft = [bbox(1) bbox(2)];
noseRight = [(bbox(1)+bbox(3)) bbox(2)];


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

faceWidth = rightEdge(1) - leftEdge(1) + bbox(3)
    