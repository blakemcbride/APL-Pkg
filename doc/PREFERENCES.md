Preferences
===========

The APL Package Manager gets its preference settings from the `~/.apl-pkg`
file. This file, as created by the installer, contains only an entry for
the location of the package repository directory. Additional options may be
provided to alter some of the behaviors of the package manager.

The supported options are:

Packages Directory
------------------

```
packages_directory: <path>
```

This is the only option set by the installer.

Terminal Program
----------------

```
terminal: <program>
```

This names the command used by the `]pkg edit` command to spawn a terminal.
The default is `xterm`. The named command must appear on `$PATH`.

The named terminal must accept the `-e <command>` option to execute the
given command.

The named terminal must correctly handle UTF-8 encoding.

Shell Program
-------------

This names the command used by the `]pkg edit` command to spawn a shell.
The default is `sh`. The named command must appear on `$PATH`.

The named shell must accept the `-c <command>` option to execute the given
command.

Editor Program
--------------

```
editor: <program>
```

This names the command used by the `]pkg edit` command to edit an APL source
file. The default is `vi`. The named command must appear on `$PATH`.

The package manager expects the `vi` command to alias to `vim`, as is common
on some Linux distributions. The classic `vi` editor is not capable of handling
the UTF-8 encoding found in APL source files.

The named editor must be able to accept keyboard input via stdin, must
recognize the `+<line-number>` option to set the initial cursor position on the
specified line number of the edited file and must correctly handle UTF-8.

Embed Option
------------

```
embed_option: <flag>
```

This denotes the option flag used by the terminal program to embed itself into
an XEmbed container, such as `tabbed`. The flag is always passed with the
container's window ID. The flag defaults to `-into` for compatibility with
`xterm`.

Other useful flags are `-embed` for `urxvt` and `-w` for `st`.

The package manager does not invoke the container program, but recognizes when
a container is in use. The normal case is to embed your favorite terminal in
your XEmbed container, then run `awe` from that terminal. When you use the
`]pkg edit` command, the package manager will run the editor inside a new
terminal within the same XEmbed container.

Embed Environment Variable
--------------------------

```
embed_env_var: <name>
```

This names the environment variable that your XEmbed container uses to pass
its ID to other programs. The default, `XEMBED`, is the correct name for
compatibility with the `tabbed` container program.

The package manager uses the presence of this environment variable to infer
that it is running inside an XEmbed container.
