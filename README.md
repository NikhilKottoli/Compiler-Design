# Compiler Design Lab

A compiler implementation project for learning the phases of compilation. This project is being developed as part of a Compiler Design course.

## What's Currently Implemented

### Lexical Analyzer (Scanner)

- **File**: `scanner.l`
- **Language**: Flex/Lex
- **Features**:
  - Token recognition for C language constructs
  - Symbol table generation with frequency tracking
  - Constant table for literals and preprocessor macros
  - Support for various token types:
    - Keywords
    - Identifiers and function names
    - Numbers
    - String and character literals
    - Operators and punctuation
    - Preprocessor directives
  - Error detection for invalid tokens
  - Function parameter tracking
  - Array dimension detection
  - Comment handling (single-line and multi-line)

### Output

The scanner generates detailed analysis including:

- Recognized tokens with line numbers
- Symbol table with variable types, dimensions, and frequencies
- Constant table with all literals and their types
- Function signatures with parameter lists

## How to Run Tests

### Running All Tests

```bash
./run_tests.sh
```

### Manual Testing

1. Compile the scanner:

   ```bash
   flex scanner.l
   gcc -o scanner lex.yy.c
   ```

2. Create an input file named `input.c` with C code to analyze

3. Run the scanner:

   ```bash
   ./scanner
   ```

4. Check the generated `output.md` file for results

### Test Files

Test cases are located in `tests/scanner/`:

- `basic_tokens.c` - Basic variable declarations and assignments
- `operators.c` - Various C operators
- `functions.c` - Function declarations and calls
- `array_pointers.c` - Arrays and pointer operations
- `comments.c` - Comment handling
- `preprocessor.c` - Preprocessor directives
- `errors.c` - Error detection scenarios

Test outputs are automatically generated in `test_outputs/scanner/`.

## Project Structure

```
├── scanner.l              # Lexical analyzer specification
├── run_tests.sh           # Test runner script
├── tests/scanner/         # Test input files
└── test_outputs/scanner/  # Generated test outputs
```

## Authors

- Nikhil Kottoli
- Mohnish
- Pal Patel
