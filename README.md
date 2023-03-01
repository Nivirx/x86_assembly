# Collection of AMD64 assembly toys
This repo contains a few assembly programs I wrote for fun
all examples use NASM and were tested on GNU/Linux unless specified otherwise and generally can be assembled with
'nasm -Wall -f elf64 -o [output.o] [input source]' and linking to libc if required (most do not rely on libc)

# Fizzbuzz
An example of a fizzbuzz in assembly without any libc calls. An example is also provided in C for comparison.

# helloworld_testing
prints a string and also was used to experiment with structures and copying strings.

# number_printer
takes the number 0xffffffff and displays the ascii representation in decimal, only supports up to UINT32_MAX, not designed for negitive numbers.