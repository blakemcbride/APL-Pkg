#! /bin/sh
# Copyright (c) 2016 David B. Lamkins
# Licensed under the MIT License
# See the LICENSE file included with this software.

HERE=`( cd $(dirname $0) && pwd )`

. ${HERE}/../script/ask.sh
. ${HERE}/../script/default.sh
TARGET=

until [ -n "$TARGET" ]; do
    ask "Packages repository directory [$DEFAULT]? "
    if [ -n "$REPLY" ]; then
        if [ -d $REPLY ] && [ -w $REPLY ]; then
            TARGET=`( cd $REPLY && pwd )`
        fi
    else
        TARGET=$DEFAULT
    fi
done

rm -rvf ${TARGET}/vtest-*
