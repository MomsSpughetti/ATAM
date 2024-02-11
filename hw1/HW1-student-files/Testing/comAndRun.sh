#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <asm_file_1> <asm_file_2>"
    exit 1
fi

# Extract the filenames from the arguments
asm_file=$1
testSample=$2

# Compile the assembly files using as
as "$asm_file" "$testSample" -o merg.o
if [ $? -ne 0 ]; then
    echo "Error compiling assembly files"
    exit 1
fi

# Link the object file
ld merg.o -o prog.out
if [ $? -ne 0 ]; then
    echo "Error linking object files"
    exit 1
fi

# Make the resulting executable executable
chmod +x prog.out
if [ $? -ne 0 ]; then
    echo "Error setting execute permissions on prog.out"
    exit 1
fi

# Run the resulting executable
./prog.out

