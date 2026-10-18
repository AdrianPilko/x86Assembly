as -g --64 ls_file.s -o ls_file.o
as -g --64 printByte.s -o printByte.o
ld -g -m elf_x86_64 ls_file.o printByte.o -o ls_file
