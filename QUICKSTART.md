# Quick Start Guide

Get up and running with Selective Search in 5 minutes!

## Step 1: Setup (First Time Only)

Open MATLAB and run the setup script:

```matlab
cd /path/to/selectiveSearch
setup
```

This will:
- Compile necessary MEX files
- Verify installation
- Add required paths

## Step 2: Run the Demo

```matlab
cd examples
demo
```

This will:
- Process a sample image
- Display region proposals
- Save results to `resultImage.jpg`

## Step 3: Try Your Own Image

```matlab
% Add paths
addpath('../src');
addpath('../src/Dependencies');

% Run selective search on your image
[boxes, h, w] = selectiveSearch('path/to/your/image.jpg', 200, 1, 2, 1, 1);

% Display results
fprintf('Generated %d proposals for %dx%d image\n', size(boxes,1), h, w);

% Visualize
img = imread('path/to/your/image.jpg');
img_with_boxes = drawRectangleOnImage(img, boxes);
imshow(img_with_boxes);
```

## Parameters Explained

```matlab
[boxes, h, w] = selectiveSearch(imagePath, k, para_size, para_fill, para_color, para_texture);
```

- **k** (200): Initial segment size - larger = fewer, bigger segments
- **para_size** (1): Weight for size similarity
- **para_fill** (2): Weight for fill similarity  
- **para_color** (1): Weight for color similarity
- **para_texture** (1): Weight for texture similarity

## Common Adjustments

### Get More Proposals
```matlab
[boxes, ~, ~] = selectiveSearch('image.jpg', 100, 1, 2, 1, 1);  % Smaller k
```

### Get Fewer Proposals
```matlab
[boxes, ~, ~] = selectiveSearch('image.jpg', 500, 1, 2, 1, 1);  % Larger k
```

### Emphasize Color
```matlab
[boxes, ~, ~] = selectiveSearch('image.jpg', 200, 1, 1, 5, 1);  % Higher para_color
```

## Next Steps

- Read the full [README.md](README.md) for detailed information
- Check [docs/USAGE.md](docs/USAGE.md) for advanced usage
- Try [examples/batch_process.m](examples/batch_process.m) for multiple images

## Troubleshooting

### MEX files won't compile?
1. Run `mex -setup` in MATLAB
2. Install a C++ compiler (GCC, MSVC, or Xcode)
3. Restart MATLAB and run `setup` again

### Out of memory?
Resize your image first:
```matlab
img = imread('large.jpg');
img_small = imresize(img, 0.5);
imwrite(img_small, 'temp.jpg');
[boxes, ~, ~] = selectiveSearch('temp.jpg', 200, 1, 2, 1, 1);
boxes = boxes * 2;  % Scale boxes back up
```

### Need help?
Open an issue on GitHub with:
- Your MATLAB version
- Operating system
- Error message
- Sample code

Happy searching! 🔍

