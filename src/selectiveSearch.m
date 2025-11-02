function [combinedResult, height, width] = selectiveSearch(imageName, theK, para_size, para_fill, para_color, para_texture)
% selectiveSearch - Performs selective search algorithm on an image
%
% Syntax: [combinedResult, height, width] = selectiveSearch(imageName, theK, para_size, para_fill, para_color, para_texture)
%
% Inputs:
%   imageName - Path to the input image
%   theK - Controls size of segments in initial segmentation (default: 200)
%   para_size - Weight for size similarity (default: 1)
%   para_fill - Weight for fill similarity (default: 2)
%   para_color - Weight for color similarity (default: 1)
%   para_texture - Weight for texture similarity (default: 1)
%
% Outputs:
%   combinedResult - Matrix of bounding boxes [x1 y1 x2 y2]
%   height - Height of the input image
%   width - Width of the input image
%
% Reference:
%   J. R. R. Uijlings et al., "Selective Search for Object Recognition"
%   International Journal of Computer Vision, 2013

% Get the directory of this script
scriptDir = fileparts(mfilename('fullpath'));
addpath(fullfile(scriptDir, 'Dependencies'));


% Parameters for Felzenszwalb and Huttenlocher segmentation algorithm
k = theK;                   % Controls size of segments of initial segmentation
minSize = k;
sigma = 0.8;
histSize_color = 25;        % Number of bins in color histogram
histSize_texture = 25;      % Number of bins in texture histogram

% Load and process image
im = imread(imageName);

% Convert image to HSV color space
colourIm = rgb2hsv(im);
imageHeight = size(colourIm, 1);
imageWidth = size(colourIm, 2);
imageToSegment = uint8(colourIm * 255);
    
% Get initial segmentation, boxes, and neighbouring blobs
[blobIndIm, blobBoxes, neighbours] = mexFelzenSegmentIndex(imageToSegment, sigma, k, minSize);
originalBoxes = blobBoxes;  % Save original boxes from segmentation

% Initialize feature matrices
sizeM = getSizeMatrix(blobIndIm, neighbours);
histM = getHistMatrix(blobIndIm, neighbours, colourIm, histSize_color);
textureM = getTextureMatrix(colourIm, blobBoxes, neighbours, histSize_texture);
height = size(blobIndIm, 1);
width = size(blobIndIm, 2);
totalSize = size(blobIndIm, 1) * size(blobIndIm, 2);

% Initialize similarity matrices
similarM_size = getInitialSimilarM_size(neighbours, sizeM, totalSize);
similarM_fill = getInitialSimilarM_fill(neighbours, sizeM, totalSize, blobBoxes);
similarM_color = getInitialSimilarM_color(neighbours, histM);
similarM_texture = getInitialSimilarM_texture(neighbours, textureM);

% Combine parameters
parameter_suite = [para_size, para_fill, para_color, para_texture];

% Hierarchical grouping
resultBoundingBox = zeros(length(similarM_size) - 2, 4);
index = 1;

while length(similarM_size) > 2
    % Find most similar regions
    [firstBlob, secondBlob] = mergeSimilarMAndFindMaxPos(similarM_size, similarM_fill, similarM_color, similarM_texture, parameter_suite);
    
    % Merge features (order matters!)
    histM = mergeHistM(histM, sizeM, firstBlob, secondBlob);
    textureM = mergeTextureM(textureM, blobBoxes, firstBlob, secondBlob);
    sizeM = mergeSizeM(sizeM, firstBlob, secondBlob);
    blobBoxes = mergeBoudingBox(blobBoxes, firstBlob, secondBlob);
    
    % Store merged bounding box
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

end

