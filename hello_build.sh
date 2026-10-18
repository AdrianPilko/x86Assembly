# call assembler as
as -o hello.o hello.s
# call gcc to link
gcc -o hello hello.o -nostdlib -static
