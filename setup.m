% Setup Script for Selective Search
% Run this script to compile MEX files and verify installation

fprintf('Selective Search Setup\n');
fprintf('=====================\n\n');

% Get the directory of this script
setupDir = fileparts(mfilename('fullpath'));

% Add paths
fprintf('Adding paths...\n');
addpath(fullfile(setupDir, 'src'));
addpath(fullfile(setupDir, 'src', 'Dependencies'));
fprintf('  [OK] Paths added\n\n');

% Change to src directory for compilation
cd(fullfile(setupDir, 'src', 'Dependencies'));

% Compile anisotropic Gaussian filter
fprintf('Compiling anisotropic Gaussian filter...\n');
try
    if ~exist('anigauss', 'file')
        mex anigaussm/anigauss_mex.c anigaussm/anigauss.c -output anigauss
        fprintf('  [OK] anigauss compiled successfully\n\n');
    else
        fprintf('  [SKIP] anigauss already exists\n\n');
    end
catch ME
    fprintf('  [ERROR] Failed to compile anigauss: %s\n\n', ME.message);
end

% Compile word counting function
fprintf('Compiling word counting function...\n');
try
    if ~exist('mexCountWordsIndex', 'file')
        mex mexCountWordsIndex.cpp
        fprintf('  [OK] mexCountWordsIndex compiled successfully\n\n');
    else
        fprintf('  [SKIP] mexCountWordsIndex already exists\n\n');
    end
catch ME
    fprintf('  [ERROR] Failed to compile mexCountWordsIndex: %s\n\n', ME.message);
end

% Compile Felzenszwalb segmentation
fprintf('Compiling Felzenszwalb segmentation algorithm...\n');
try
    if ~exist('mexFelzenSegmentIndex', 'file')
        mex FelzenSegment/mexFelzenSegmentIndex.cpp -output mexFelzenSegmentIndex
        fprintf('  [OK] mexFelzenSegmentIndex compiled successfully\n\n');
    else
        fprintf('  [SKIP] mexFelzenSegmentIndex already exists\n\n');
    end
catch ME
    fprintf('  [ERROR] Failed to compile mexFelzenSegmentIndex: %s\n\n', ME.message);
end

% Return to original directory
cd(setupDir);

% Test installation
fprintf('Testing installation...\n');
try
    % Check if all required files exist
    requiredFiles = {
        fullfile('src', 'selectiveSearch.m'),
        fullfile('src', 'deduplicate.m'),
        fullfile('src', 'getHistMatrix.m'),
        fullfile('examples', 'demo.m')
    };
    
    allFilesExist = true;
    for i = 1:length(requiredFiles)
        if ~exist(fullfile(setupDir, requiredFiles{i}), 'file')
            fprintf('  [ERROR] Missing file: %s\n', requiredFiles{i});
            allFilesExist = false;
        end
    end
    
    if allFilesExist
        fprintf('  [OK] All required files found\n');
    end
    
    % Check if MEX files are compiled
    cd(fullfile(setupDir, 'src', 'Dependencies'));
    mexFiles = {'anigauss', 'mexCountWordsIndex', 'mexFelzenSegmentIndex'};
    allMexCompiled = true;
    
    for i = 1:length(mexFiles)
        if ~exist(mexFiles{i}, 'file')
            fprintf('  [WARNING] MEX file not compiled: %s\n', mexFiles{i});
            allMexCompiled = false;
        end
    end
    
    if allMexCompiled
        fprintf('  [OK] All MEX files compiled\n');
    end
    
    cd(setupDir);
    
    fprintf('\n');
    if allFilesExist && allMexCompiled
        fprintf('Setup completed successfully!\n\n');
        fprintf('Next steps:\n');
        fprintf('  1. Run the demo: cd examples; demo\n');
        fprintf('  2. Read the documentation: open README.md\n');
        fprintf('  3. Check usage guide: open docs/USAGE.md\n');
    else
        fprintf('Setup completed with warnings.\n');
        fprintf('Some MEX files may need manual compilation.\n');
        fprintf('Please check the error messages above.\n');
    end
    
catch ME
    fprintf('  [ERROR] Test failed: %s\n', ME.message);
end

fprintf('\n');

