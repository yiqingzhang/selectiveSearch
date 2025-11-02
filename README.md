# Selective Search for Object Recognition

A MATLAB implementation of the Selective Search algorithm for generating object proposals in images. This implementation is based on the paper "Selective Search for Object Recognition" by J.R.R. Uijlings et al. (IJCV 2013).

## Overview

Selective Search is a region proposal algorithm used in object detection. It combines the strength of both exhaustive search and segmentation, generating high-quality object location proposals that can be used as input for object recognition systems.

### Key Features

- **Hierarchical Grouping**: Uses a bottom-up approach to merge similar regions
- **Multiple Similarity Measures**: Combines color, texture, size, and fill similarities
- **Efficient Implementation**: Fast C++ MEX implementations for critical components
- **Flexible Parameters**: Adjustable weights for different similarity measures

## Installation

### Prerequisites

- MATLAB (tested on R2014a and later)
- C++ compiler for MEX files (e.g., GCC, MSVC, Xcode)

### Setup

1. Clone this repository:
```bash
git clone https://github.com/yourusername/selectiveSearch.git
cd selectiveSearch
```

2. Compile MEX files by running the demo (it will auto-compile on first run):
```matlab
cd examples
demo
```

## Usage

### Quick Start

Run the demo script to see selective search in action:

```matlab
cd examples
demo
```

This will:
1. Compile necessary MEX files (first run only)
2. Run selective search on a sample image
3. Display and save the results

### Basic Usage

```matlab
% Add source directory to path
addpath('src');
addpath('src/Dependencies');

% Set parameters
imagePath = 'path/to/your/image.jpg';
k = 200;              % Segmentation parameter (larger = bigger initial segments)
para_size = 1;        % Size similarity weight
para_fill = 2;        % Fill similarity weight
para_color = 1;       % Color similarity weight
para_texture = 1;     % Texture similarity weight

% Run selective search
[boxes, height, width] = selectiveSearch(imagePath, k, para_size, para_fill, para_color, para_texture);

% boxes is an Nx4 matrix where each row is [x1, y1, x2, y2]
fprintf('Generated %d region proposals\n', size(boxes, 1));
```

### Batch Processing

Process multiple images in a directory:

```matlab
cd examples
% Edit batch_process.m to set your input directory
batch_process
```

## Parameters

### Segmentation Parameters

- **k**: Controls the size of initial segments (default: 200)
  - Larger values → larger initial segments → fewer proposals
  - Smaller values → smaller initial segments → more proposals
  
- **sigma**: Gaussian smoothing parameter (default: 0.8)
  - Used to smooth the image before segmentation

### Similarity Weights

- **para_size**: Weight for size similarity (default: 1)
  - Encourages merging of smaller regions
  
- **para_fill**: Weight for fill similarity (default: 2)
  - Encourages merging regions that fit well into each other
  
- **para_color**: Weight for color similarity (default: 1)
  - Encourages merging regions with similar colors
  
- **para_texture**: Weight for texture similarity (default: 1)
  - Encourages merging regions with similar textures

## Project Structure

```
selectiveSearch/
├── README.md                 # This file
├── LICENSE                   # License information
├── src/                      # Source code
│   ├── selectiveSearch.m     # Main algorithm
│   ├── selectiveSearchWithLab.m
│   ├── selectiveSearchWithrgb.m
│   ├── deduplicate.m         # Remove duplicate boxes
│   ├── getHistMatrix.m       # Color histogram features
│   ├── getTextureMatrix.m    # Texture features
│   ├── getSizeMatrix.m       # Size features
│   ├── getInitialSimilarM_*.m # Initialize similarity matrices
│   ├── merge*.m              # Merge operations
│   ├── update*.m             # Update similarity matrices
│   └── Dependencies/         # External dependencies
│       ├── FelzenSegment/    # Felzenszwalb segmentation
│       ├── anigaussm/        # Anisotropic Gaussian filter
│       ├── ShowImageCell.m
│       ├── ShowRectsWithinImage.m
│       └── draw*.m           # Visualization utilities
├── examples/                 # Example scripts
│   ├── demo.m               # Main demo
│   ├── batch_process.m      # Batch processing
│   └── images/              # Sample images
└── docs/                    # Documentation
```

## Algorithm Overview

The selective search algorithm works in three main steps:

1. **Initial Segmentation**: Uses Felzenszwalb's graph-based segmentation to create initial regions
2. **Hierarchical Grouping**: Iteratively merges the most similar neighboring regions based on:
   - Color similarity (histogram intersection)
   - Texture similarity (Gaussian derivatives)
   - Size similarity (encourages merging small regions)
   - Fill similarity (how well regions fit together)
3. **Deduplication**: Removes duplicate or highly overlapping proposals

## Output Format

The main function returns bounding boxes in the format:
```
[x1, y1, x2, y2]
```
where:
- `(x1, y1)` is the top-left corner
- `(x2, y2)` is the bottom-right corner

## Examples

### Example 1: Single Image

```matlab
addpath('src');
addpath('src/Dependencies');

[boxes, h, w] = selectiveSearch('examples/images/099.jpg', 200, 1, 2, 1, 1);
fprintf('Generated %d proposals for %dx%d image\n', size(boxes,1), h, w);
```

### Example 2: Custom Parameters

```matlab
% More proposals (smaller k)
[boxes1, ~, ~] = selectiveSearch('image.jpg', 50, 1, 2, 1, 1);

% Fewer proposals (larger k)
[boxes2, ~, ~] = selectiveSearch('image.jpg', 500, 1, 2, 1, 1);

fprintf('Small k: %d proposals\n', size(boxes1, 1));
fprintf('Large k: %d proposals\n', size(boxes2, 1));
```

### Example 3: Emphasize Color

```matlab
% Emphasize color similarity
[boxes, ~, ~] = selectiveSearch('image.jpg', 200, 1, 1, 5, 1);
```

## Performance Tips

1. **Image Size**: Resize large images before processing to improve speed
2. **Parameter k**: Start with k=200 and adjust based on your needs
3. **Memory**: For very large images, increase MATLAB's memory allocation

## Citation

If you use this code in your research, please cite:

```bibtex
@article{uijlings2013selective,
  title={Selective search for object recognition},
  author={Uijlings, Jasper RR and Van De Sande, Koen EA and Gevers, Theo and Smeulders, Arnold WM},
  journal={International Journal of Computer Vision},
  volume={104},
  number={2},
  pages={154--171},
  year={2013},
  publisher={Springer}
}
```

## References

- [Original Paper](http://www.huppelen.nl/publications/selectiveSearchDraft.pdf)
- [Felzenszwalb Segmentation](http://people.cs.uchicago.edu/~pff/segment/)
- [Original Implementation](http://huppelen.nl/publications/SelectiveSearchCodeIJCV.zip) (partially encrypted)

## Acknowledgments

This implementation uses:
- Felzenszwalb and Huttenlocher's graph-based segmentation algorithm (IJCV 2004)
- Anisotropic Gaussian filtering for texture features

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Issues

If you encounter any problems or have suggestions, please open an issue on GitHub.

## Author

Implementation by Yiqing

## Changelog

### Version 1.0.0
- Initial release
- Cleaned up codebase for open source
- Improved documentation
- Reorganized project structure
