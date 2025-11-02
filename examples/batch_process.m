% Batch Process Images with Selective Search
% This script runs selective search on all images in a directory

clc; clear all;

% Add paths to source files
addpath('../src');
addpath('../src/Dependencies');

% Configuration
dirName = {'./images'};  % Directory containing images to process
outputDir = './output';  % Directory for output files

% Algorithm parameters
theK = 200;
para_size = 1;
para_fill = 2;
para_color = 1;
para_texture = 1;

% Create output directory if it doesn't exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

fprintf('Batch Processing Images with Selective Search\n');
fprintf('==============================================\n\n');

% Process each directory
for j = 1:length(dirName)
    theDir = dir(fullfile(dirName{j}, '*.jpg'));
    
    fprintf('Processing directory: %s\n', dirName{j});
    fprintf('Found %d images\n\n', length(theDir));
    
    for i = 1:length(theDir)
        if ~theDir(i).isdir
            % Construct full path
            imagePath = fullfile(dirName{j}, theDir(i).name);
            
            fprintf('[%d/%d] Processing: %s\n', i, length(theDir), theDir(i).name);
            
            try
                % Run selective search
                [boxes, height, width] = selectiveSearch(imagePath, theK, para_size, para_fill, para_color, para_texture);
                
                % Generate output filename
                [~, baseName, ~] = fileparts(theDir(i).name);
                outputFileName = fullfile(outputDir, [baseName '.txt']);
                
                % Save bounding boxes to text file
                fileID = fopen(outputFileName, 'w');
                fprintf(fileID, '%d %d\n', height, width);
                fprintf(fileID, '%d %d %d %d\n', boxes');
                fclose(fileID);
                
                % Draw bounding boxes on image and save
                theImage = imread(imagePath);
                theImage = drawRectangleOnImage(theImage, boxes);
                outputImagePath = fullfile(outputDir, [baseName '_boxes.jpg']);
                imwrite(theImage, outputImagePath);
                
                fprintf('  Generated %d proposals\n', size(boxes, 1));
                fprintf('  Saved to: %s\n\n', outputFileName);
                
            catch ME
                fprintf('  ERROR: %s\n\n', ME.message);
            end
        end
    end
end

fprintf('Batch processing complete!\n');

