# Usage Guide

## Getting Started

### First Time Setup

1. Navigate to the examples directory:
```matlab
cd examples
```

2. Run the demo (this will compile MEX files automatically):
```matlab
demo
```

## Function Reference

### selectiveSearch

Main function to perform selective search on an image.

**Syntax:**
```matlab
[boxes, height, width] = selectiveSearch(imageName, theK, para_size, para_fill, para_color, para_texture)
```

**Inputs:**
- `imageName` (string): Path to the input image
- `theK` (numeric): Segmentation parameter controlling initial segment size (default: 200)
- `para_size` (numeric): Weight for size similarity (default: 1)
- `para_fill` (numeric): Weight for fill similarity (default: 2)
- `para_color` (numeric): Weight for color similarity (default: 1)
- `para_texture` (numeric): Weight for texture similarity (default: 1)

**Outputs:**
- `boxes` (Nx4 matrix): Bounding boxes in format [x1, y1, x2, y2]
- `height` (numeric): Height of the input image
- `width` (numeric): Width of the input image

**Example:**
```matlab
[boxes, h, w] = selectiveSearch('image.jpg', 200, 1, 2, 1, 1);
```

## Common Use Cases

### 1. Object Detection Pipeline

```matlab
% Load image
img = imread('myimage.jpg');

% Generate proposals
[boxes, ~, ~] = selectiveSearch('myimage.jpg', 200, 1, 2, 1, 1);

% Filter by size (optional)
areas = (boxes(:,3) - boxes(:,1)) .* (boxes(:,4) - boxes(:,2));
boxes = boxes(areas > 1000, :);  % Keep boxes larger than 1000 pixels

% Use boxes for object detection
% ... your detection code here ...
```

### 2. Adjusting Number of Proposals

```matlab
% More proposals (smaller segments)
[boxes_many, ~, ~] = selectiveSearch('image.jpg', 50, 1, 2, 1, 1);

% Fewer proposals (larger segments)
[boxes_few, ~, ~] = selectiveSearch('image.jpg', 500, 1, 2, 1, 1);

fprintf('Small k (50): %d proposals\n', size(boxes_many, 1));
fprintf('Large k (500): %d proposals\n', size(boxes_few, 1));
```

### 3. Color-Based Segmentation

For images where color is the most important feature:

```matlab
% Emphasize color similarity
[boxes, ~, ~] = selectiveSearch('image.jpg', 200, 0.5, 0.5, 5, 0.5);
```

### 4. Texture-Based Segmentation

For images with strong texture patterns:

```matlab
% Emphasize texture similarity
[boxes, ~, ~] = selectiveSearch('image.jpg', 200, 0.5, 0.5, 0.5, 5);
```

## Visualization

### Display All Proposals

```matlab
addpath('../src/Dependencies');

% Get proposals
[boxes, ~, ~] = selectiveSearch('image.jpg', 200, 1, 2, 1, 1);

% Read image
img = imread('image.jpg');

% Draw all boxes
img_with_boxes = drawRectangleOnImage(img, boxes);
imshow(img_with_boxes);
```

### Display Grid of Proposals

```matlab
% Show proposals in a grid
ShowRectsWithinImage(boxes, 5, 5, img);  % 5x5 grid
```

### Display Top N Proposals

```matlab
% Show only first 100 proposals
drawRectangleOnDifferentImage(img, boxes(1:100, :), 4);
```

## Parameter Tuning Guide

### k Parameter (Segmentation)

- **k = 50-100**: Very fine segmentation, many small proposals
  - Use for: Small object detection, detailed analysis
  - Pros: Won't miss small objects
  - Cons: Many proposals, slower processing

- **k = 200-300**: Balanced segmentation (recommended)
  - Use for: General purpose object detection
  - Pros: Good balance of speed and coverage
  - Cons: None significant

- **k = 500-1000**: Coarse segmentation, fewer large proposals
  - Use for: Large object detection, fast processing
  - Pros: Fast, fewer proposals to process
  - Cons: May miss small objects

### Similarity Weights

The weights determine how regions are merged:

- **para_size**: Encourages merging small regions first
  - Increase to prioritize small region merging
  - Decrease to allow small regions to persist longer

- **para_fill**: Encourages merging regions that fit well together
  - Increase for more compact proposals
  - Decrease for more irregular shapes

- **para_color**: Encourages merging similar colored regions
  - Increase for color-based segmentation
  - Decrease if color is not important

- **para_texture**: Encourages merging similar textured regions
  - Increase for texture-based segmentation
  - Decrease if texture is not important

### Recommended Presets

**General Purpose:**
```matlab
k=200, para_size=1, para_fill=2, para_color=1, para_texture=1
```

**Color-Dominant Images:**
```matlab
k=200, para_size=1, para_fill=1, para_color=5, para_texture=0.5
```

**Texture-Dominant Images:**
```matlab
k=200, para_size=1, para_fill=1, para_color=0.5, para_texture=5
```

**Fast Processing (Fewer Proposals):**
```matlab
k=500, para_size=2, para_fill=3, para_color=1, para_texture=1
```

## Troubleshooting

### MEX Files Not Compiling

**Problem:** MEX compilation fails

**Solutions:**
1. Ensure you have a C++ compiler installed
2. Run `mex -setup` in MATLAB to configure compiler
3. Check MATLAB version compatibility

### Out of Memory Errors

**Problem:** MATLAB runs out of memory on large images

**Solutions:**
1. Resize image before processing:
```matlab
img = imread('large_image.jpg');
img_small = imresize(img, 0.5);  % Resize to 50%
imwrite(img_small, 'temp_image.jpg');
[boxes, ~, ~] = selectiveSearch('temp_image.jpg', 200, 1, 2, 1, 1);
% Scale boxes back up
boxes = boxes * 2;
```

2. Increase k parameter to reduce number of initial segments
3. Increase MATLAB memory allocation

### Too Many/Few Proposals

**Problem:** Getting too many or too few proposals

**Solutions:**
- Too many: Increase k parameter (e.g., 500)
- Too few: Decrease k parameter (e.g., 100)
- Adjust similarity weights to control merging behavior

### Slow Performance

**Problem:** Processing takes too long

**Solutions:**
1. Increase k parameter for fewer initial segments
2. Resize images to smaller dimensions
3. Adjust weights to encourage faster merging (increase para_size and para_fill)

## Best Practices

1. **Start with defaults**: Use k=200 and equal weights (1,2,1,1)
2. **Preprocess images**: Resize very large images before processing
3. **Filter results**: Remove very small or very large boxes based on your application
4. **Batch processing**: Use the batch_process.m script for multiple images
5. **Save results**: Save bounding boxes to files for later use

## Performance Tips

1. **Image size**: Keep images under 800x600 for best performance
2. **Parallel processing**: Process multiple images in parallel using MATLAB's parallel toolbox
3. **Caching**: Save results to avoid recomputing for the same image
4. **MEX files**: Ensure MEX files are compiled for optimal performance

