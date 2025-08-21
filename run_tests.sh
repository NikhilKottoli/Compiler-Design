#!/bin/bash

# Script to run scanner.l on all C test files and generate outputs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCANNER_FILE="$SCRIPT_DIR/scanner.l"
TEST_INPUT_DIR="$SCRIPT_DIR/tests/scanner"
OUTPUT_DIR="$SCRIPT_DIR/test_outputs/scanner"
SCANNER_EXECUTABLE="$SCRIPT_DIR/scanner"

if [ ! -f "$SCANNER_FILE" ]; then
    exit 1
fi

if [ ! -d "$TEST_INPUT_DIR" ]; then
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

cd "$SCRIPT_DIR"

flex scanner.l
if [ $? -ne 0 ]; then
    exit 1
fi

gcc -o scanner lex.yy.c

processed_count=0
success_count=0
error_count=0

for test_file in "$TEST_INPUT_DIR"/*.c; do
    if [ -f "$test_file" ]; then
        filename=$(basename "$test_file")
        basename_no_ext="${filename%.*}"
        cp "$test_file" input.c
        if ./scanner; then
            if [ -f "output.md" ]; then
                output_file="$OUTPUT_DIR/${basename_no_ext}_output.md"
                mv output.md "$output_file"
                ((success_count++))
            else
                ((error_count++))
            fi
        else
            ((error_count++))
        fi
        rm -f input.c
        ((processed_count++))
    fi
done


rm -f lex.yy.c scanner
