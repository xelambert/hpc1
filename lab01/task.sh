#!/bin/bash

# Read the input from a file
input=$(cat input.txt)

# Extract the two input values
xmin=$(echo $input | awk '{print $1}')
xmax=$(echo $input | awk '{print $2}')

# Call the integral function
result=$(./a.out $xmin $xmax)

# Print the result to the console
echo $result > output.txt