#!/bin/bash

# these are assmbled using gcc (before found yasm as an alternative)
gcc -no-pie echo.s -o echo -z noexecstack
gcc -no-pie echoUsingScanf.s -o echoS -z noexecstack
