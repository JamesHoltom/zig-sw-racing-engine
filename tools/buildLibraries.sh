#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

zig translate-c \
-isystem /usr/include \
-isystem /usr/include/x86_64-linux-gnu \
${SCRIPT_DIR}/libs/raylib/src/raylib.h \
> ${SCRIPT_DIR}/libs/raylib.zig

zig translate-c \
-isystem /usr/include \
-isystem /usr/include/x86_64-linux-gnu \
-I${SCRIPT_DIR}/libs/raylib/src \
-DRAYGUI_IMPLEMENTATION="" \
${SCRIPT_DIR}/libs/raygui/src/raygui.h \
> ${SCRIPT_DIR}/libs/raygui.zig
