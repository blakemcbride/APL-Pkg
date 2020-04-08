#! /bin/sh
# Copyright (c) 2014 David B. Lamkins
# Licensed under the MIT License
# See the LICENSE file included with this software.

files () {
    (
        cd ${1:-.}
        find . -name '.?*' -prune -o -type f -print | grep -v '~$' | sort -k 2
    )
}

run_filter () {
    xargs -n 1 -i bash -c "$1 \$@" _ {}
}

filter_text='( file $1 | grep -q text ) && echo $1'
filter_no_makefile='( file $1 | grep -v makefile | grep -q text ) && echo $1'
filter_makefile='( file $1 | grep -q makefile ) && echo $1'

apl_files () {
    grep -v -e '/_' | grep '\.apl$' | grep -v -e 'demo'
}

package_files () {
    grep -e '/_' | grep -v -e 'demo'
}

demo_apl_files () {
    grep -v -e '/_' | grep '\.apl$' | grep -e 'demo'
}

demo_package_files () {
    grep -e '/_' | grep -e 'demo'
}

doc_files () {
    grep -e '\.md$' -e '\.txt$' -e 'NOTES' -e 'README'
}

script_files () {
    grep -e '/admin' -e '/scripts' -e '\.sh$'
}
