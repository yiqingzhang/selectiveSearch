% Selective Search Algorithm Demo
% This script demonstrates the selective search algorithm on a sample image

clear; clc;

% Add paths to source files
addpath('../src');
addpath('../src/Dependencies');

fprintf('Selective Search Algorithm Demo\n');
fprintf('================================\n\n');

% Compile MEX files if needed
if(~exist('anigauss', 'file'))
    fprintf('Compiling anisotropic Gaussian filter...\n');
    mex ../src/Dependencies/anigaussm/anigauss_mex.c ../src/Dependencies/anigaussm/anigauss.c -output anigauss
end

if(~exist('mexCountWordsIndex', 'file'))
    fprintf('Compiling word counting function...\n');
    mex ../src/Dependencies/mexCountWordsIndex.cpp
end

if(~exist('mexFelzenSegmentIndex', 'file'))
    fprintf('Compiling Felzenszwalb segmentation algorithm...\n');
    mex ../src/Dependencies/FelzenSegment/mexFelzenSegmentIndex.cpp -output mexFelzenSegmentIndex;
end

fprintf('\nRunning selective search on sample image...\n');

% Parameters for the Felzenszwalb and Huttenlocher segmentation algorithm
% Note that by default, we set minSize = k, and sigma = 0.8
k = 200;                    % Controls size of segments of initial segmentation
minSize = k;
sigma = 0.8;
histSize_color = 25;        % Number of bins to use in a color histogram
histSize_texture = 25;      % Number of bins to use in a single texture histogram

% Load sample image
imagePath = 'images/099.jpg';
im = imread(imagePath);

% Convert image to HSV color space
colourIm = rgb2hsv(im);
imageHeight = size(colourIm, 1);
imageWidth = size(colourIm, 2);
imageToSegment = uint8(colourIm * 255);
    
% Get initial segmentation, boxes, and neighbouring blobs
[blobIndIm, blobBoxes, neighbours] = mexFelzenSegmentIndex(imageToSegment, sigma, k, minSize);
originalBoxes = blobBoxes;

% Initialize similarity matrices
sizeM = getSizeMatrix(blobIndIm, neighbours);
histM = getHistMatrix(blobIndIm, neighbours, colourIm, histSize_color);
textureM = getTextureMatrix(colourIm, blobBoxes, neighbours, histSize_texture);
totalSize = size(blobIndIm, 1) * size(blobIndIm, 2);

similarM_size = getInitialSimilarM_size(neighbours, sizeM, totalSize);
similarM_fill = getInitialSimilarM_fill(neighbours, sizeM, totalSize, blobBoxes);
similarM_color = getInitialSimilarM_color(neighbours, histM);
similarM_texture = getInitialSimilarM_texture(neighbours, textureM);

% Similarity parameters (weights for different features)
para_size = 1;
para_fill = 2;
para_color = 1;
para_texture = 1;
parameter_suite = [para_size, para_fill, para_color, para_texture];

% Hierarchical grouping
resultBoundingBox = zeros(length(similarM_size) - 2, 4);
index = 1;

fprintf('Performing hierarchical grouping...\n');
while(length(similarM_size) > 2)
    % Find most similar regions and merge them
    [firstBlob, secondBlob] = mergeSimilarMAndFindMaxPos(similarM_size, similarM_fill, similarM_color, similarM_texture, parameter_suite);
    
    % Update matrices (order matters!)
    histM = mergeHistM(histM, sizeM, firstBlob, secondBlob);
    textureM = mergeTextureM(textureM, blobBoxes, firstBlob, secondBlob);
    sizeM = mergeSizeM(sizeM, firstBlob, secondBlob);
    blobBoxes = mergeBoudingBox(blobBoxes, firstBlob, secondBlob);
    
    % Store result
    resultBoundingBox(index, :) = blobBoxes(firstBlob, :);
    
    % Update similarity matrices
    [similarM_size, similarM_fill, similarM_color, similarM_texture] = mergeSimilarityMatrixes(similarM_size, similarM_fill, similarM_color, similarM_texture, firstBlob, secondBlob);
    similarM_size = updateSimilarityM_size(similarM_size, firstBlob, sizeM, totalSize);
    similarM_fill = updateSimilarityM_fill(similarM_fill, blobBoxes, firstBlob, sizeM, totalSize);
    similarM_color = updateSimilarityM_color(similarM_color, histM, firstBlob);
    similarM_texture = updateSimilarityM_texture(similarM_texture, textureM, firstBlob);
    
    index = index + 1;
end

% Combine original boxes with hierarchical grouping results
combinedResult = [originalBoxes; resultBoundingBox];

% Remove duplicate boxes
duplicateThreshold = 0.01;
combinedResult = deduplicate(combinedResult, imageHeight * duplicateThreshold, imageWidth * duplicateThreshold);

fprintf('Generated %d region proposals\n\n', size(combinedResult, 1));

% Visualize results
fprintf('Displaying results...\n');
ShowRectsWithinImage(combinedResult, 5, 5, im);

% Draw all bounding boxes on the image
imWithBoxes = drawRectangleOnImage(im, combinedResult);
imwrite(imWithBoxes, 'resultImage.jpg');
figure;
imshow(imWithBoxes);
title('Selective Search Results - All Proposals');

% Draw a subset of bounding boxes
drawRectangleOnDifferentImage(im, combinedResult, 4);

fprintf('Demo complete! Results saved to resultImage.jpg\n');
