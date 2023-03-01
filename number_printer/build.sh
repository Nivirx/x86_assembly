#!/bin/bash
nasm -Wall -f elf64 -g -F dwarf numbers.S -o numbers.o
ld -o numbers numbers.o
