#! /bin/bash
# Copyright (c) 2014 David B. Lamkins
# Licensed under the MIT License
# See the LICENSE file included with this software.

if [ -f ~/.apl-pkg ]; then
    DEFAULT=`awk -F' ' '/packages_directory:/ { print $2 }' < ~/.apl-pkg`
fi

if [ -z "${DEFAULT}" ]; then
    DEFAULT=${HOME}/apl-pkg-repo
fi
