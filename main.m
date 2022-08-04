clear, clc, close all

videoFilename = 'testvideos/video1.mp4';

% Data for Eyes, Mouth, Nose
[eyesWidth, eyesHeight, eyesLocation] = getSizeOfGrayscaleFeature('EyePairBig', videoFilename, false)
[mouthWidth, mouthHeight, mouthLocation] = getSizeOfGrayscaleFeature('Mouth', videoFilename, true)
[noseWidth, noseHeight, noseLocation] = getSizeOfGrayscaleFeature('Nose', videoFilename, false)

[faceWidth, faceHeight, bboxFace, bboxNose] = getFacialDimensions(videoFilename);
