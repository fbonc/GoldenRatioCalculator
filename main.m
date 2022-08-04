clear, clc, close all

videoFilename = 'testvideos/video1.mp4';

% Data for Eyes, Mouth, Nose
[eyesWidth, eyesHeight, eyesLocation] = getSizeOfGrayscaleFeature('EyePairBig', videoFilename, false);
[mouthWidth, mouthHeight, mouthLocation] = getSizeOfGrayscaleFeature('Mouth', videoFilename, true);
[noseWidth, noseHeight, noseLocation] = getSizeOfGrayscaleFeature('Nose', videoFilename, false);

[faceWidth, faceHeight, bboxFace, bboxNose, chinLocation] = getFacialDimensions(videoFilename);

% Final distance values
pupilToLip = mouthLocation(2) - eyesLocation(2);
noseToChin = chinLocation - noseLocation(2);
lipsToChin = chinLocation - mouthLocation(2);
pupilToNose = noseLocation(2) - eyesLocation(2);
noseToLips = mouthLocation(2) - noseLocation(2);
hairlineToPupil = eyesLocation(2) -  bboxFace(2);

overallValue = ((noseToChin / lipsToChin)+(noseToChin / pupilToNose)+(noseWidth / noseToLips)+(eyesWidth / hairlineToPupil)+(mouthHeight / noseWidth)) / 5;
goldenRatioConstant = (1 + sqrt(5)) / 2;
round(overallValue / goldenRatioConstant * 10, 1)
