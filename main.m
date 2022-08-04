clear, clc, close all

[eyesWidth, eyesHeight] = getSizeOfGrayscaleFeature('EyePairBig', false)
[mouthWidth, mouthHeight] = getSizeOfGrayscaleFeature('Mouth', true)
[noseWidth, noseHeight] = getSizeOfGrayscaleFeature('Nose', true)

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
    heightOfFeature = yVals(1, 1) - yVals(1, 2);

    y = yVals(1, 1):1:yVals(1, 2);
    xMidpoint = width(bwImage) / 2;
    x = xMidpoint .* ones(1, length(y));
    
    line(x, y, 'Color', 'red', 'LineWidth', 4)
end
