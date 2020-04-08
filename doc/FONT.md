APL Font
========

For terminal emulators (e.g. `xterm`, `urxvt` or `st`), I recommend
using the GNU FreeMono font. This font has all of the glyphs that may
be used by APL.

You may also try the DejaVu Sans Mono font. This has better-looking glyphs
than GNU FreeMono. Depending upon your OS distribution and version, DejaVu
Sans Mono may not be complete with respect to the glyphs used by APL.

xterm Configuration
-------------------

Assuming your `xterm` is configured to use TrueType (FreeType) fonts,
you can make the terminal use the GNU FreeMono font by passing the
command-line option `-fa FreeMono` or by adding a line to your
`~/.Xresources` file:

```
XTerm*faceName: FreeMono
```

The font size may be selected as:

```
XTerm*faceSize: <size>
```

or with the `-fs <size>` command-line option.

Alternatively, you may set both font and size with the same
`~/.Xresources` entry:

XTerm*faceName: FreeMono:size=<size>

Your `xterm` must be able to handle UTF-8 characters. You can enable
UTF-8 by passing `-u8` on the command line or by adding a line to your
`~/.Xresources` file:

```
XTerm*utf8: 2
```

urxvt Configuration
-------------------

The corresponding `~/.Xresources` configuration is slightly different
for the `urxvt` terminal:

```
URxvt.font: xft:FreeMono:size=<size>
```

There is no entry to force UTF-8 recognition since `urxvt` handles
Unicode by design.

If you prefer, the font may be specified with the `urxvt` command-line
option `-fn`, as `-fn "xft:FreeMono:size=<size>"`.

.Xresources Changes
-------------------

To make the X server recognize changes in your `~/.Xresources` file,
run:

```
xrdb ~/.Xresources
```

st Changes
----------

The `st` terminal is configured via recompilation. I use the following
line in `config.def.h` to select the FreeMono font:

```
static char font[] = "FreeMono-14:antialias=false:autohint=false";
```

If you prefer to use a packaged version of `st`, you can specify the
font using the `-f <font>` option. One way to make `st` always use
the GNU FreeMono font is to put a wrapper script in a directory on
$PATH, such that the script's directory precedes the $PATH entry in
which the actual `st` executable is found. For example, the following
script may be used:

```
#! /bin/bash

/usr/bin/st -f \
 FreeMono-14:antialias=false:autohint=true:hintstyle=hintslight:dpi=96 \
 "$@"
```

Other Terminal Emulators
------------------------

If your terminal emulator has a preferences dialog, use that to 
choose the FreeMono font and size.

If your terminal emulator supports shortcut keys that use the `Alt`
key as a modifier, these must be disabled in order to avoid conflict
with APL character bindings. The means to do this varies with each
emulator, but is normally found in the terminal's preferences dialog.

Linux Console
-------------

To run APL in a Linux console with a proper keyboard map and font,
use the `awe` command. There's only one option for an APL console font;
this is installed by the APL Package Manager's installer.
