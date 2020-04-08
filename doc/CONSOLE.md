Working in the console
======================

This document describes how to use the Package Manager in a `console`,
often referred to as a `virtual terminal`. To be clear, the `console`
is *not* a terminal window that you open within a graphical environment.

In Linux, the `console` is part of the kernel. You'll see a herald line
that advertises the `console` as, for example, `tty1`. The `console`
binds the keyboard such that you can switch to other `consoles` using
`Alt+F<number>`, where `<number>` is normally in the range `1` to
`6`. When you open a fresh `console`, you'll be required to present your
login credentials; after logging in, you'll see a shell command prompt.

The `console` is not as full-featured as most terminal emulators. In
particular, the `console` is limited in the number of distinct glyphs
that it is able to display; the full Unicode range is never available
in the `console`.

The Package Manager's `awe` script may be run in a `console` shell. Among
other tasks, `awe` in the `console` changes the console font to one
having all of the glyphs used by GNU APL and interposes `akt` to remap
most `Alt+<keystroke>` combinations to the Unicode code points of APL
characters.

The Package Manager also needs to be able to spawn an editor in a
separate process and window. Since the `console` does not directly support
programmatic creation of new windows, the Package Manager expects `dvtm`
to be available. The `awe` command starts APL under `dvtm` and provides a
pipe through which the Package Manager may run an editor in a new window.

Note that setting the `console` font is supported only for `/dev/tty#`
devices. If you attempt to run `awe` in a screen manager (such as `dvtm`,
`screen` or `tmux`), `awe` will be unable to set the proper console font
for APL.
