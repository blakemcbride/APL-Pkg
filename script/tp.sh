#! /bin/sh
# Copyright (c) 2014 David B. Lamkins
# Licensed under the MIT License
# See the LICENSE file included with this software.

# Wrapper for tput-based formatting takes a list of short codes:
#    <bgcolor> <fgcolor> - see colors array for codes
#    bd                  - bold
#    ul                  - underline
#    pl                  - plain
#    end                 - reset

# First argument must be one of `bd`, `ul`, `pl` or end. If there are
# a total of two arguments, the second is taken as fgcolor. If there
# are three arguments, the second and third are taken as bgcolor and
# fgcolor, respectively.

# Automatically disabled if sourced by a script whose output is not a
# terminal.

if test -t 1; then
    tp () {
        # Colors for tput setab and tput setaf
        #   black red green yellow blue magenta cyan white
        #     0    1    2    3      4      5     6     7     dark
        #     8    9   10   11     12     13    14    15    light
        colors="\
            bk=0     d_rd=1   d_gn=2   d_yl=3 \
            d_bl=4   d_mg=5   d_cy=6   l_gy=7 \
            d_gy=8   l_rd=9   l_gn=10  l_yl=11 \
            l_bl=12  l_mg=13  l_cy=14  wh=15 \
            "

        vc () {
            if [ -n "$1" ]; then
                for ce in $colors; do
                    c=`echo $ce | cut -d= -f1`
                    if [ $c = $1 ]; then
                        true
                        return
                    fi
                done
            fi
            false
        }

        gc () {
            if [ -n "$1" ]; then
                for ce in $colors; do
                    c=`echo $ce | cut -d= -f1`
                    if [ $c = $1 ]; then
                        v=`echo $ce | cut -d= -f2`
                        echo $v
                        return
                    fi
                done
            fi
            false
        }

        if [ $# -gt 0 ]; then
            case $1 in
                bd) tput bold ;;
                ul) tput smul ;; # underline
                pl) tput rmul ;; # plain
                end) tput sgr0 ;;
                *)
            esac
            shift
            if [ $# -gt 1 ] && `vc $1`; then
                tput setab `gc $1`
                shift
            fi
            if `vc $1`; then
                tput setaf `gc $1`
                shift
            fi
            tp $*
        fi
    }
else
    tp () {
        :
    }
fi

# Helpers for common cases. Invoke as:
#   echo `xx Some text...`
# where xx is one of the below-named functions.
pc () {
    # prompt color
    echo `tp bd l_bl`$*`tp end`
}

ec () {
    # error color
    echo `tp bd d_gy l_rd`$*`tp end`
}

ic () {
    # information color
    echo `tp pl d_gy l_gn`$*`tp end`
}

wc () {
    # warning color
    echo `tp bd d_gy l_yl`$*`tp end`
}

dc () {
    # default input color
    echo `tp pl d_gy`$*`tp end`
}

fc () {
    # file color
    echo `tp bd d_gy`$*`tp end`
}

ul () {
    # underline
    echo `tp ul`$*`tp pl`
}

em () {
    # emphasize
    echo `tp bd`$*`tp end`
}
