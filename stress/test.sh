#! /bin/sh
# Copyright (c) 2014 David B. Lamkins
# Licensed under the MIT License
# See the LICENSE file included with this software.

# Generate fake packages to stress-test the dependency-management code.
# ---------------------------------------------------------------------

usage () {
    cat <<EOF
usage: `basename $0` <count>
  Generate <count> test packages.
  <count> must be no greater than 10000.
usage: `basename $0` clean
  Remove test packages.
EOF
    exit 1
}

aset () {
	eval ${1}${2}="${3}"
}

aref () {
	v=${1}${2}
	echo `eval "echo \\$${v}"`
}

substring () {
	if [ -n "$3" ]; then
		echo "$1" | awk "{ print substr(\$0, $(($2+1)), $3); }"
	else
		echo "$1" | awk "{ print substr(\$0, $(($2+1))); }"
	fi
}

random () {
	hexdump -n 2 -e '/2 "%u"' /dev/urandom
}

# Provide a clue when invoked with the wrong number of arguments.

if [ $# -eq 0 ] || [ $# -gt 1 ]; then
    usage
fi

# Parse the argument.

YES=1
NO=0

numre='^[0-9]\+$'

case $1 in
    clean) CLEAN=${YES} ;;
    *)
        ( echo $1 | grep -q $numre ) || usage
        CLEAN=${NO}
        LIMIT=$1
        if   [ $LIMIT -le 10    ]; then DIGITS=1
        elif [ $LIMIT -le 100   ]; then DIGITS=2
        elif [ $LIMIT -le 1000  ]; then DIGITS=3
        elif [ $LIMIT -le 10000 ]; then DIGITS=4
        else usage
        fi
        ;;
esac

# Get the target directory.

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

BASE=$TARGET/stress-

# Create an array of package prefixes; one per package.

make_prefixes () {
    #   0123456789
    cv="cumberland"
    n=0
    while [ $n -lt $LIMIT ]; do
        num=`printf "%0${DIGITS}d" $n`
        pre=
        i=0
        while [ $i -lt ${DIGITS} ]; do
            idx=`substring $num $i 1`
            pre=$pre`substring $cv $idx 1`
            i=$(($i+1))
        done
        aset prefixes $n ST$pre
        n=$(($n+1))
    done
}

# Create an array of package names; one per package.

make_names () {
    n=0
    while [ $n -lt $LIMIT ]; do
        aset names $n `printf "s-%0${DIGITS}d" $n`
        n=$(($n+1))
    done
}

# Generate a random list of dependencies, possibly with duplicates.

generate_requires () {
    lim=3
    slices=$(( $DIGITS * $DIGITS + 1 ))
    n=$(( `random` % $lim ))
    rangesize=$(( $LIMIT / $slices ))
    rangebase=$(( `random` % $slices * $rangesize ))
    i=0
    while [ $i -lt $n ]; do
        id=$(( `random` % $rangesize + $rangebase ))
        echo `aref names $id`
        i=$(($i+1))
    done
}

# Filter and write the dependency entries.

fake_requires() {
    reqs=`generate_requires | grep -v $1 | sort | uniq`
    for r in $reqs; do
        echo depends_on: $r
    done
}

# Create the text of a package's metadata.

fake_metadata () {
    cat <<EOF
# This is a generated test package
package_name: `aref names $1`
package_prefix: `aref prefixes $1`
`fake_requires $1`
EOF
}

################

# Start fresh.

rm -rf ${BASE}*

# We're done if `clean` was requested.

[ ${CLEAN} -eq ${YES} ] && echo Stress tests removed && exit 0

# Create packages.

make_names
make_prefixes

i=0
while [ $i -lt $LIMIT ]; do
    id=`printf "%0${DIGITS}d" $i`
    pkg=${BASE}${id}
    mkdir $pkg
    cat > $pkg/_control_.apl <<EOF
⍝ This is a generated test package

'package ${i}'

∇z←`aref prefixes $i`∆f_${id} n
 z←${i}=n
∇

`aref prefixes $i`∆v_${id}←${i}
EOF
    fake_metadata $i > $pkg/_metadata_
    i=$(($i+1))
done

# Tell about what we've done.

cat <<EOF
Created test packages
 ${BASE}`printf "%0${DIGITS}d" 0`
through
 ${BASE}`printf "%0${DIGITS}d" $(( $LIMIT - 1 ))`
EOF
