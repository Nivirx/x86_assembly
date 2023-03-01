#!/bin/bash
nasm -Wall -f elf64 -g -F dwarf test.S -o test.o
ld -o test test.o
