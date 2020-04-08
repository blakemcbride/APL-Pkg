External Editor Support
=======================

The APL Package Manager supports editing of APL source code via the
`]pkg edit <function-name>` command. This command opens the source file
in an external editor, positioned (if supported by the editor) to the
header line of the function. Note that the source code must have been
read in from a file by the package manager; the external editor is not
used to define new functions in the APL workspace.

Because the external editor must be run in its own terminal, there needs
to be a way to display that terminal. There are three distinct cases,
depending upon your computing environment:

- Under windowing systems, the terminal simply opens in a new window.

- If the package manager's APL is running inside an XEmbed container
  such as `tabbed`, the external editor's terminal opens inside that
  container.

- If the package manager's APL is running inside the `dvtm` terminal
  multiplexer, the external editor's terminal opens as a new `dvtm`
  window. Note that you must have started `dvtm` with the `-c <fifo>`
  flag; see dvtm(1) for further details.

In the first two cases, APL waits for you to exit the editor before
you can interact with APL. If the modification time of the edited file
has changed when you exit the external editor, the package manager
automatically reloads the file (unless it is a source file for the
package manager).

In the third case, where the external editor opens inside a new `dvtm`
window, control returns immediately to the APL prompt; the package
manager does not automatically reload a modified file.

Both the terminal and editor programs used for the external editor must
be Unicode-aware. Furthermore, the terminal must use a font capable of
rendering the APL glyphs; I've had the best results with the `GNU Free
Mono` font.

The terminal must also implement the "meta sends escape" protocol, in
which any key sent with the meta (a.k.a. Alt under normal keyboard
mappings) key depressed is sent as the ESC character followed
immediately by the typed character. The `akt` program translates
meta-as-escape sequences to APL Unicode characters and pipes these
to the input of the editor. As such, the editor must be capable of
accepting editing commands via standard input; this is true of `nano`,
`vim`, `vis` and probably others.

You can specify the external programs to use by adding entries to the
`~/.apl-pkg` configuration file. The defaults are:

```
terminal: xterm
shell: sh
editor: vi
```

NOTE: The vi command is assumed to alias to vim. To the best of my
knowledge, the original vi does not support Unicode.

The terminal must accept a command-line switch to set the title. The
default is:

```
title_option: -T
```

To place the terminal inside an XEmbed container, the package manager
must pass the container ID on the terminal command line. This is
configured using:

```
embed_option: -w
embed_env_var: XEMBED
```

These defaults are compatible with the `tabbed` program; other XEmbed
containers may need different options.

Please refer to `doc/PREFERENCES.md` for further details regarding
package manager configuration.

References
----------

1. [vis](https://github.com/martanne/vis.git)
2. [dvtm](http://www.brain-dump.org/projects/dvtm/)
3. [abduco](http://www.brain-dump.org/projects/abduco/)
4. [tabbed](http://tools.suckless.org/tabbed/)
5. [st](http://st.suckless.org/)
