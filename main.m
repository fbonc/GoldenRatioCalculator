clear, clc, close all


%% Eyes Detector

% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector('EyePairBig');

% Read a video frame and run the face detector.
videoReader = VideoReader(['FinnianFelon.mp4']);
videoFrame      = readFrame(videoReader);
bbox            = step(faceDetector, videoFrame)

% Draw the returned bounding box around the det ected face.
videoFrame = insertShape(videoFrame, 'Rectangle', bbox);
figure; imshow(videoFrame); title('Detected face');


figure
eyesImage = imcrop(videoFrame,bbox);
bwEyesImage = imcomplement(im2bw(eyesImage));
imshow(bwEyesImage)

% COPIED

[ y, x] = find( bwEyesImage);
points = [ x y];
[d,idx] = pdist2( points, points, 'euclidean', 'Largest', 1);
idx1 = idx( d==max(d));
[~,idx2] = find(d==max( d));

p={};
for i=1:length(idx1)
   p{end+1} = [ points(idx1(i),1), points(idx1(i),2), points(idx2(i),1), points(idx2(i),2)];
end

figure; 
imshow( bwEyesImage);
hold on;
for i=1:numel(p)
    line( [ p{i}(1), p{i}(3)], [p{i}(2), p{i}(4)]);
    hdl = get(gca,'Children');
    set( hdl(1),'LineWidth',2);
    set( hdl(1),'color',[1 0 0]);
end
hold off;

% END OF COPIED

EyesWidth = p{1}
distanceEyes = sqrt((EyesWidth(1) - EyesWidth(3))^2 + (EyesWidth(2) - EyesWidth(4))^2)


%{

% Face Detector
faceDetector = vision.CascadeObjectDetector();
FaceHeight = bbox(1,4)



eyesDetector = vision.CascadeObjectDetector('EyePairBig');


%}
