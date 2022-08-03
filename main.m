clear, clc, close all

getWidthOfGrayscaleFeature('EyePairBig', false);
getWidthOfGrayscaleFeature('Mouth', true);

function width = getWidthOfGrayscaleFeature(feature, mergeThresholdBool)
    % Select a certain facial feature.
    if mergeThresholdBool
        faceDetector = vision.CascadeObjectDetector(feature, 'MergeThreshold', 300);
    else
        faceDetector = vision.CascadeObjectDetector(feature);
    end
    
    % Read a video frame and run the face detector.
    videoReader = VideoReader('FinnianFelon.mp4');
    videoFrame = readFrame(videoReader);
    bbox = step(faceDetector, videoFrame);
    featureImage = imcrop(videoFrame,bbox);
    figure
    subplot(2, 1, 1)
    imshow(featureImage)
    bwImage = imcomplement(im2bw(featureImage));
    subplot(2, 1, 2)
    imshow(bwImage)
    
    % Get width of feature in pixels.
    
    [LeftY, LeftX] = find(bwImage, 1, 'first');
    [RightY, RightX] = find(bwImage, 1, 'last');
    
    width = RightX - LeftX;

    x = LeftX:1:RightX;

    yMidpoint = height(bwImage) / 2;
    y = yMidpoint .* ones(1, length(x));
    line(x, y, 'Color', 'red', 'LineWidth', 4)
end
