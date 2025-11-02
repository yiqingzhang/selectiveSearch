# Contributing to Selective Search

Thank you for your interest in contributing to this project! This document provides guidelines for contributing.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the problem
- Expected behavior
- Actual behavior
- MATLAB version and operating system
- Sample code or images (if applicable)

### Suggesting Enhancements

Enhancement suggestions are welcome! Please open an issue with:
- A clear description of the enhancement
- Why this enhancement would be useful
- Example use cases

### Pull Requests

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Test your changes thoroughly
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin feature/your-feature-name`)
7. Open a Pull Request

## Development Guidelines

### Code Style

- Use clear, descriptive variable names
- Add comments for complex logic
- Follow MATLAB naming conventions:
  - Functions: camelCase (e.g., `selectiveSearch`)
  - Variables: camelCase (e.g., `blobBoxes`)
  - Constants: UPPER_CASE (e.g., `DEFAULT_K`)

### Documentation

- Add function documentation in MATLAB format:
```matlab
function output = myFunction(input)
% myFunction - Brief description
%
% Syntax: output = myFunction(input)
%
% Inputs:
%   input - Description of input
%
% Outputs:
%   output - Description of output
%
% Example:
%   result = myFunction(data);
```

### Testing

- Test your changes with various images
- Verify MEX files compile on different platforms (if modified)
- Check for memory leaks with large images

## Project Structure

Please maintain the existing structure:
- `src/` - Core algorithm implementation
- `src/Dependencies/` - External dependencies
- `examples/` - Example scripts and sample images
- `docs/` - Documentation

## Questions?

Feel free to open an issue for any questions about contributing.

