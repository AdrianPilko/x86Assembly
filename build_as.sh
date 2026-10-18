#!/bin/sh
#


if [ -z "$1.s" ]; then
   echo "error no file given"
   echo "Usage: $0 <source file without extenasion"
   exit 1
fi

SOURCE_FILE=$1.s
OBJ_FILE=$1.o
EXE_FILE=$1

if [ -f "$SOURCE_FILE" ]; then
   echo "Found file: $SOURCE_FILE starting build"

   # 1. Compile into an object module file using the GNU Assembler (as)
   if as --64 $SOURCE_FILE -o $OBJ_FILE; then
      echo "assembled to object file $OBJ_FILE"
   else
      echo "assembly failed"
      exit 1
   fi

   # 2. Link into an executable binary using the GNU Linker (ld)
   if  ld -m elf_x86_64 $OBJ_FILE -o $EXE_FILE; then
      echo "linked successful"
   else
      echo "failed link"
      exit 1
   fi
else
   echo "File not found $SOURCE_FILE"
   exit 2
fi

