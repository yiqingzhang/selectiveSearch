# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-02

### Added
- Initial open source release
- Comprehensive README.md with detailed documentation
- Quick start guide (QUICKSTART.md)
- Usage guide (docs/USAGE.md)
- Contributing guidelines (CONTRIBUTING.md)
- MIT License
- Setup script for easy installation
- Batch processing example
- .gitignore file

### Changed
- Reorganized project structure:
  - Moved core algorithm files to `src/` directory
  - Moved example scripts to `examples/` directory
  - Moved sample images to `examples/images/`
  - Created `docs/` directory for documentation
- Improved code documentation and comments
- Cleaned up demo.m with better structure and comments
- Enhanced selectiveSearch.m with detailed function documentation

### Removed
- Deleted temporary test files (test.m, commented.m)
- Removed parameter testing files (testWithPara.m, testWithDiffParas.m, paraTest.ods)
- Removed dataset-specific Python scripts (generateMine.py, generateMineForNewGT.py)
- Removed personal backup script (evaluateAndBackupFiles.sh)
- Cleaned up example images from FelzenSegment directory

### Fixed
- Updated file paths in demo and example scripts
- Improved path handling in selectiveSearch.m to work from any directory
- Standardized code formatting and spacing

## [Pre-1.0.0] - Before 2025-11-02

### Initial Implementation
- Core selective search algorithm
- Felzenszwalb segmentation integration
- Color, texture, size, and fill similarity measures
- Hierarchical region merging
- Bounding box deduplication
- Visualization utilities

