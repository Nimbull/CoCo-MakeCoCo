#!/bin/bash
#
# NAME: makecoco.sh
#
# VERSION: 1.0
#
# DESCRIPTION: Nimbull's CoCo assembler script.
#
# AUTHOR: Nimbull
#
# CHANGE LOG
#
# 1.0 (10/11/2020 SPD) - Initial version.
#

#
# Setup variables.
#
FILE="$1"
FILE_S="./$FILE.asm"
FILE_C="./${FILE^^}.BIN"
FILE_D="./${FILE^^}.DSK"

#
# Compile.
#
echo "Compiling source file(s)..."
lwasm $FILE_S --6809 --list --symbols --6800compat --output=$FILE_C --format=decb
if [ $? -ne 0 ]; then
    echo "Completed with compiler errors!"
    exit
else
    echo "No errors on compile!"
fi

#
# Make CoCo disk.
#
if [ -f "$FILE_D" ]; then
    echo "Backing up previous disk $FILE_D to $FILE_D.bak ..."
    mv -f $FILE_D $FILE_D.bak
    rm -rf $FILE_D
fi
echo "Creating new disk $FILE_D ..."
decb dskini $FILE_D -3
if [ $? -eq 0 ]; then
    echo "Copying compiled binary $FILE_C to new CoCo disk $FILE_D ..."
    decb copy -2 -b $FILE_C -r $FILE_D,${FILE^^}.BIN
    if [ $? -eq 0 ]; then
        echo "Compiled code copied to CoCo disk $FILE_D!"
    else
        echo "Unable to copy compiled code to CoCo disk $FILE_D!"
    fi
else
    echo "Unable to create COCO disk $FILE_D for program!"
fi

#
# Done.
#
echo "Done!"
exit
