#! /bin/sh
# Copyright (c) 2014 David B. Lamkins
# Licensed under the MIT License
# See the LICENSE file included with this software.

HERE=`( cd $(dirname $0) && pwd )`

. ${HERE}/../script/ask.sh
. ${HERE}/../script/default.sh
TARGET=

until [ -n "$TARGET" ]; do
    ask "Package repository directory [$DEFAULT]? "
    if [ -n "$REPLY" ]; then
        eval REPLY=$REPLY
        if [ -d $REPLY ] && [ -w $REPLY ]; then
            TARGET=`( cd $REPLY && pwd )`
        fi
    else
        TARGET=$DEFAULT
    fi
done

cp -av ${HERE}/demo-* $TARGET
