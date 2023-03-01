#!/bin/bash
nasm -Wall -f elf64 -o fizzbuzz.o fizzbuzz.S
ld -o fizzbuzz fizzbuzz.o
strip ./numbers
