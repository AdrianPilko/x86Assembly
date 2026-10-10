#!/bin/bash

gcc -no-pie echo.s -o echo -z noexecstack
gcc -no-pie echoUsingScanf.s -o echoS -z noexecstack
