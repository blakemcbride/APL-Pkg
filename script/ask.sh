#! /bin/sh
# Copyright (c) 2014 David B. Lamkins
# Licensed under the MIT License
# See the LICENSE file included with this software.

ask () {
    # Read with prompt; first ask() argument must be a prompt.
    printf "$1"
    shift
    if [ $# -eq 0 ]; then
        read REPLY
    else
        read "$@"
    fi
}
