APL Workbench Environment
=========================

The `apl-pkg` installer compiles a small C program, `akt`, and links
`akt` into the `~/bin` directory (first creating the directory if
needed). The installer also links a script named `awe`.

The `awe` script invokes GNU APL with input from `akt`, then loads the
`apl-pkg` files. This is a convenient way to run APL; the `akt` program
maps your keyboard to produce APL characters using the Alt key.

See `extra/README` for additional details.

You'll need to install a Unicode font that includes APL characters.
Please see `FONT.md` for more information.
