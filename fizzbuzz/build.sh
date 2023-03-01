#!/bin/bash
nasm -Wall -f elf64 -g -F dwarf -o fizzbuzz.o fizzbuzz.S
ld -o fizzbuzz fizzbuzz.o
