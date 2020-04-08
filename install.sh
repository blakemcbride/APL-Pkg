#! /bin/sh
# Copyright (c) 2014 David B. Lamkins
# Licensed under the MIT License
# See the LICENSE file included with this software.

# ----------------------------------------------------------------
# Install the APL Package Manager for GNU APL on a Linux system.
# ----------------------------------------------------------------

PACKAGE_NAME=apl-pkg

( [ -n "${EMACS}" ] && cat || less -MXe ) <<EOF
This is the installer for the APL Package Manager.

The APL Package Manager supports loading of APL code from a local
repository. The repository holds packages which bundle one or more
files of code together with metadata and installation scripts.

A package's code is normally written in APL. APL files are encoded as
UTF-8, translated upon loading to your APL's internal character set.

Because APL has a flat namespace, each package of APL code uses its
own prefix for top-level names. In this way, multiple packages may be
loaded into your APL workspace without conflict.

In addition to APL code, a package may also contain code written in
other languages. Such code may (as supported by your APL interpreter)
be called from your APL program, installed to support the APL
interpreter, or installed to provide a service upon which your APL
program depends.


We're now ready to begin installation of the APL Package Manager.
You'll be asked for

 1. the location in which to create the local APL package repository.
    You may specify either an existing directory or a to-be-created
    child of an existing directory, and

 2. the location(s) in which you store APL workspace files.

The installer will

 1. create the local APL package repository directory (if needed),

 2. install the APL package manager in the local APL package
    repository,

 3. create a link to the package manager's bootstrap in each APL
    workspaces directory you name, and

 4. create (or update) a ~/.apl-pkg file containing the location of
    the local APL package repository.

 5. build akt (the APL Keyboard Translator; see extra/akt) and
    install a link to the executable in the ~/bin directory (which
    will be created if it doesn't already exist).

 6. link a script named awe into the ~/bin directory; this is a
    convenience wrapper to invoke GNU APL with akt and apl-pkg.
    Run $ awe -h for further details.

 7. link a keyboard1.txt file into the ~/.gnu-apl directory. This
    file represents the APL keyboard layout implemented by akt.
    You can make GNU APL's ]KEYB command display this file in an
    APL session; add the following line to your ~/.gnu-apl/preferences
    file:

    KEYBOARD_LAYOUT_FILE /path/to/user/home/.gnu-apl/keyboard1.txt

 8. install an APL font suitable for use in the Linux console.
EOF

# For now, this is specific to GNU APL on Linux.

PLATFORM=gnu-apl-linux

# As other APL interpreters and platforms are supported, this script
# will probably need to handle installation on a case-by-case basis.

HERE=`( cd $(dirname $0) && pwd )`

. ${HERE}/script/ask.sh
. ${HERE}/script/tp.sh
. ${HERE}/script/default.sh; LOCAL_REPO_DEFAULT=${DEFAULT}
LOCAL_REPO_TARGET=

CONFIG=${HOME}/.apl-pkg

if [ -f ${CONFIG} ]; then Action=Updated; else Action=Wrote; fi

cat <<EOF

`ul Beginning installation`

EOF

until [ -n "$LOCAL_REPO_TARGET" ]; do
    ask "`pc APL package repository location` [`dc $LOCAL_REPO_DEFAULT`]? " \
        || { echo; continue; }
    if [ -n "$REPLY" ]; then
        eval REPLY=${REPLY%/}
        if [ "`echo ${REPLY} | cut -c 1`" != "/" ]; then
            echo `ec Please specify an absolute path`
            continue
        fi
        if [ -d $REPLY ] && [ -w $REPLY ]; then
            LOCAL_REPO_TARGET=$REPLY
        else
            echo $REPLY: `ec not a valid location`
        fi
    else
        if [ -d "$LOCAL_REPO_DEFAULT" ] && [ -w "$LOCAL_REPO_DEFAULT" ]; then
            LOCAL_REPO_TARGET=$LOCAL_REPO_DEFAULT
        else
            echo $LOCAL_REPO_DEFAULT: `ec not a valid location`
        fi
    fi
done

INSTALL_ROOT=${LOCAL_REPO_TARGET}/${PACKAGE_NAME}

if [ ${INSTALL_ROOT} != ${HERE} ]; then
    if [ -d ${INSTALL_ROOT} ]; then
        ask "`pc Previous installation found. Replace` [`dc Y/n`]? " YORN \
            || echo
        if [ "$YORN" != "n" ] && [ "$YORN" != "N" ]; then
            rm -rf ${INSTALL_ROOT}
            echo `ic Removed previous installation`
        else
            echo `ic Previous installation unchanged`
            exit
        fi
    fi
    mkdir -p ${INSTALL_ROOT}
    (
        cd ${HERE}
        find . -name '.?*' -prune -o -type d ! -name . -print | \
            xargs -I{} install -d ${INSTALL_ROOT}/{}
    )
    echo `ic Created directory structure`
    (
        cd ${HERE}
        find . -name '.?*' -prune -o -type f -print | \
            xargs -I{} cp -p {} ${INSTALL_ROOT}/{}
    )
    echo `ic Copied files`
else
    echo `ic Installed in-place`
fi

if [ $Action = 'Updated' ]; then
	tf=`mktemp`
	grep -v '^\(#\|packages_directory\|$\)' ${CONFIG} > $tf
fi

cat > ${CONFIG} <<EOF
# This file contains configuration information for the APL package
# manager.

packages_directory: ${LOCAL_REPO_TARGET}
EOF

if [ $Action = 'Updated' ]; then
	cat $tf >> ${CONFIG}
	rm -f $tf
fi

echo `ic $Action configuration file` `fc ${CONFIG}`

GNU_APL_PREFS=" \
$HOME/.gnu-apl/preferences \
$HOME/.config/gnu-apl/preferences \
/etc/gnu-apl.d/preferences \
/usr/local/etc/gnu-apl.d/preferences \
"

GNU_APL_PREF_FILE=
for f in ${GNU_APL_PREFS}; do
    if [ -f $f ]; then
        GNU_APL_PREF_FILE=$f
        break
    fi
done

if [ -n "${GNU_APL_PREF_FILE}" ]; then
    echo `ic Found GNU APL preferences` `fc ${GNU_APL_PREF_FILE}`
    CONFIG_WSDIRS=`awk '/^ *LIBREF-[0-2]/ { print $2 }' ${GNU_APL_PREF_FILE}`
else
    echo `wc No GNU APL preferences found`
    echo `wc Please be sure to provide your workspace directory when requested`
    CONFIG_WSDIRS=
fi

if [ -n "${CONFIG_WSDIRS}" ]; then
    cat <<EOF

Now we'll create a link to the package manager in each of your
configured APL workspace directories.

EOF

    for ws in ${CONFIG_WSDIRS}; do
        if [ -d $ws ] && [ -w $ws ]; then
            ln -nsf ${INSTALL_ROOT}/boot/${PLATFORM}.apl \
                $ws/pkg.apl
            WSDIRS="$WSDIRS $ws"
            echo `ic Created link in` `fc $ws`
        fi
    done
fi

PKGAPL_FILES=`locate pkg.apl`

CONFIG_WSDIRS_TMPFILE=/tmp/$$-config-wsdirs
for ws in ${CONFIG_WSDIRS}; do echo $ws; done > $CONFIG_WSDIRS_TMPFILE
EXTRA_WSDIRS=$(
    for slf in ${PKGAPL_FILES}; do
        if [ -L $slf ]; then
            slt=`readlink $slf`
            if [ $(basename $(dirname $slt)) = "boot" ]; then
                echo $slf
            fi
        fi
    done | xargs -r dirname | \
        grep -v -Ff $CONFIG_WSDIRS_TMPFILE
    )
rm -f $CONFIG_WSDIRS_TMPFILE

if [ -n "${EXTRA_WSDIRS}" ]; then
    cat <<EOF

Links to the package manager were also found here:
EOF
    for ws in ${EXTRA_WSDIRS}; do
        echo "  $ws"
    done
    ask "`pc Refresh these` [`dc Y/n`]? " YORN
    if [ "$YORN" != "n" ] && [ "$YORN" != "N" ]; then
        for ws in ${EXTRA_WSDIRS}; do
            ln -nsf ${INSTALL_ROOT}/boot/${PLATFORM}.apl \
                $ws/pkg.apl
            WSDIRS="$WSDIRS $ws"
        done
    fi
fi

if [ -n "${WSDIRS}" ]; then
    cat <<EOF

Next we'll create a link to the package manager in as many additional
workspace directories as you need.

You may type ^D (control-D) to cancel at this point if you have no
need of additional links.

EOF
else
    cat <<EOF

Now we'll create a link to the package manager in as many workspace
directories as you need. These links are required for APL to load
the package manager from within your workspace directories.

EOF
fi

WS_DIR_SEARCH=" \
${HOME}/workspaces \
${HOME}/wslib1 \
${HOME}/wslib2 \
${HOME}/wslib2 \
`pwd`/workspaces \
`pwd`/wslib1 \
`pwd`/wslib2 \
`pwd`/wslib3 \
"

WS_DIR_DEFAULT=
for d in ${WS_DIR_SEARCH}; do
    if [ -d $f ]; then
        WS_DIR_DEFAULT=$d
        break
    fi
done

WS_DIR_TARGET=

while true; do
    until [ -n "$WS_DIR_TARGET" ]; do
        ask "`pc Additional APL workspace directory` [`dc $WS_DIR_DEFAULT`]? " \
            || { echo; break 2; }
        if [ -z "$REPLY" ]; then
            if [ -z "${WS_DIR_DEFAULT}" ]; then
                break
            fi
            REPLY=${WS_DIR_DEFAULT}
        fi
        eval REPLY=${REPLY%/}
        if [ "`echo ${REPLY} | cut -c -f1`" != "/" ]; then
            echo `ec Please specify an absolute path`
            continue
        fi
        if [ -d $REPLY ] && [ -w $REPLY ]; then
            WS_DIR_TARGET=$REPLY
            ln -nsf ${INSTALL_ROOT}/boot/${PLATFORM}.apl \
                ${WS_DIR_TARGET}/pkg.apl
            WSDIRS="${WSDIRS} ${WS_DIR_TARGET}"
            WS_DIR_DEFAULT=${WS_DIR_TARGET}
            echo `ic OK`
        else
            echo $REPLY: `ec not a writeable directory`
        fi
    done
    ask "`pc More` [`dc y/N`]? " YORN || { echo; break; }
    if [ "${YORN}" != "y" ] && [ "${YORN}" != "Y" ]; then
        break
    fi
    WS_DIR_TARGET=
done

cat <<EOF

`ul akt and awe`

Now we'll build and install akt (the APL Keyboard Translator)
and awe (a wrapper to run the APL Workspace Environment).

EOF

EXTRA_DIR=${INSTALL_ROOT}/extra
AKT_DIR=${EXTRA_DIR}/akt

(
    cd ${AKT_DIR}
    make akt
) && {
    if [ ! -d ~/bin ]; then
        mkdir ~/bin && echo `ic Created directory` `fc ~/bin`
    else
        echo "`ic Found directory` `fc ~/bin`"
    fi
    ln -nsf ${AKT_DIR}/akt ~/bin && \
    echo "`ic Created link` `fc ~/bin/akt`"
    ln -nsf ${EXTRA_DIR}/awe ~/bin && \
    echo "`ic Created link` `fc ~/bin/awe`"

    if ( echo ":$PATH:" | grep -q -e ':~/bin:' -e ':$HOME/bin:' \
         -e ":$HOME/bin:" ); then
        echo "`ic Found` `fc ~/bin` `ic on` `fc \\$PATH`"
    else
        echo "`ec Please put ~/bin on` `fc \\$PATH`"
    fi
} || echo "`ec Failed to build or install` `fc akt` or `fc awe`."

cat <<EOF

`ul Console Tools`

Install tools for using APL in a Linux console.

EOF

# The Unifont-APL8x16 font is not part of the GNU unifont package.
# Note that the Unifont-APL8x16 font stands alone; it does not require
# the unifont package.
UNIFONT_VERSION=7.0.06
UNIFONT_SERVER=http://unifoundry.com/
UNIFONT_SERVER_DIR=pub/unifont-${UNIFONT_VERSION}/font-builds
UNIFONT_FONT_NAME=Unifont-APL8x16-${UNIFONT_VERSION}
UNIFONT_PSF_FILE=${UNIFONT_FONT_NAME}.psf
UNIFONT_GZ_FILE=${UNIFONT_PSF_FILE}.gz
CFD=/usr/lib/kbd/consolefonts
if [ ! -f ${CFD}/${UNIFONT_GZ_FILE} ] ; then
    cat <<EOF
We're about to download and install a console font with APL glyphs.
You'll be asked to provide your password for sudo to install the
font in ${CFD}.

EOF
    wget -P /tmp ${UNIFONT_SERVER}${UNIFONT_SERVER_DIR}/${UNIFONT_GZ_FILE}
    sudo install -m 644 /tmp/${UNIFONT_GZ_FILE} ${CFD}
    rm -f /tmp/${UNIFONT_GZ_FILE}
    sudo ln -nsf ${CFD}/${UNIFONT_GZ_FILE} ${CFD}/apl.psf.gz
fi

CONSOLE_DIR=${EXTRA_DIR}/console

if [ ! -d ~/bin ]; then
    mkdir ~/bin && echo `ic Created directory` `fc ~/bin`
else
    echo "`ic Found directory` `fc ~/bin`"
fi

cat <<EOF

`ul Keyboard Layout`

Install keyboard layout file matching akt.
See instructions in summary for use of this file.

EOF

[ -d $HOME/.gnu-apl ] || mkdir $HOME/.gnu-apl
ln -nsf ${EXTRA_DIR}/keyboard1.txt ~/.gnu-apl && \
echo "`ic Created link` `fc ~/.gnu-apl/keyboard1.txt`"

cat <<EOF

`ul Removing obsolete links`

EOF

[ -L ~/bin/console-apl ] && [ ! -f ~/bin/console-apl ] && \
    rm -v ~/bin/console-apl
[ -L ~/.gnu-apl/aplkeymap.map ] && [ ! -f ~/.gnu-apl/aplkeymap.map ] && \
    rm -v ~/.gnu-apl/aplkeymap.map

cat <<EOF

`ul Installation Summary`

1. The APL Package Manager is installed at:
     `fc ${INSTALL_ROOT}`

2. The APL packages local repository is:
     `fc ${LOCAL_REPO_TARGET}`
EOF

if [ -n "${#WSDIRS}" ]; then
    cat <<EOF

3. In your APL session, load the APL Package Manager using
         `em \)LOAD pkg`
   or
         `em \)COPY pkg`
   in any of these workspace directories:
EOF

    for ws in ${WSDIRS}; do
        echo "     `fc $ws`"
    done
    cat <<EOF
   or in another workspace directory in which you have already created
   a link to the package manager.
EOF

    if [ -x ~/bin/akt ] && [ -x ~/bin/awe ]; then
        cat <<EOF

4. You may use the `em \$ awe` command to launch the "APL Workbench
   Environment". Use `em \$ awe -h` for further details.

5. You may add the following line to your ~/.gnu-apl/preferences file
   to have GNU APL's `em ]KEYB` command display the keyboard as mapped
   by `em akt`:

   `ic KEYBOARD_LAYOUT_FILE ~/.gnu-apl/keyboard1.txt`

   We recommend that you add this line, as the keyboard layout is
   slightly different from GNU APL's default. The line is not added
   by the installer.
EOF
    fi
else
    cat <<EOF

3. No workspaces found or specified.

`wc NOTICE:` If you have not previously created package manager links in
your APL workspace directories, please reinstall and provide workspace
directory paths when requested.
EOF
fi
