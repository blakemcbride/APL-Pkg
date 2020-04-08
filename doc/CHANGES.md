Changes from Evey release to Percy release
==========================================

API Changes
-----------

- The `depends_on` metadata now accepts version constraint specifications.
  See `doc/API.md` for details.

- The `pkg∆shell_type` API adds `fish` to the list of recognized shells.

Features
--------

- The `]pkg inspect <variable-name>` command runs an interactive inspector.
  The inspector shows attributes of the variable and provides commands to
  navigate through the data. Use the inspector's `h` command to list available
  commands.

- The `]pkg time <expression>` command executes the expression and displays
  its execution time.

- The `]pkg ident platform` command displays information about the platform
  upon which the package manager runs.

- The `]pkg ident environment` command displays information about the
  runtime environment.

- The `]pkg ident configuration` command displays the APL Packager's
  configuration settings.

- The `]pkg setpw` command updates ⎕PW to match the detected terminal width.

- The `]pkg locate <function-name> header` command displays the function's
  information plus its header line and header comments (i.e. all of the
  full-line comments immediately following the header line, up to the first
  line that's not a comment).

- The `]pkg help` command's display brackets metasyntactic variables to
  distinguish them from literal keywords.

- The `]pkg names <prefix>` command rejects an invalid prefix.

- The `]pkg packages` command displays a legend for the flags in the `L`
  column.

- The `awe` command confirms that `apl.pkg` in APL's LIB 0 is a symlink.
  This is a check against both inadvertent removal and replacement by a
  file (e.g. a )DUMP file).

- The `awe` command accepts option `-x <container>` to specify the
  container (one of `wm` [window manager; default], `tabbed` or `dvtm`),
  in which the package manager presents an editor.

- The `awe` command accepts option `-i #` to set the shared variable
  processor ID.

- The `awe` command checks for the presence of `dvtm` when invoked from
  the Linux console.

- Displays now wrap at the terminal's actual width if the `tput` command
  is available.

- The command dispatcher now displays a usage message, rather than a list
  of all commands and their syntax, for an ill-formed command.

- The command dispatcher now displays a list of commands having a matching
  prefix when presented with an ambiguous prefix.

Bug Fixes
---------

- Fixed failure to initialize when shell type doesn't match probes.

- Corrected misuse of APL `enclose`; GNU APL changed to no longer
  tolerate the misuse.

- The `]pkg alias` command now reports `No aliases` rather than an empty
  table in the case where all defined aliases have been deleted.

- The `]pkg names <prefix>` command no longer detects a localized variable
  as a valid name.

- Corrected some code that relied on incorrect APL semantics that were
  fixed starting with GNU APL svn 739.

- Eliminated uses of `⊣` in portable code.

- Eliminated spurious empty-array displays when `]BOXING ...` is enabled.

Compatibility
-------------

- Use title_option configuration (default: -T) to specify option flag
  for terminal title.

- Adopt GNU APL's ⎕FIO as a replacement for binding lib_file_io.

- Added a probe for zsh shell.

- Installer removes obsolete links.

- The `akt` utility was rewritten to run a given command under a pty.
  Instead of `akt | apl`, you must now invoke `akt apl`. The slave pty's
  terminal size updates to follow changes in the master's size. The new
  `akt` has no command-line option flags.

Deprecation
-----------

- Neither APLwrap nor Emacs integration are actively supported. Patches
  are welcomed.

Changes from Wibble release to Evey release
===========================================

API Changes
-----------

- The `pkg∆metadata` public API has been removed.

- The `pkg∆shell_type` API adds `yash` to the list of recognized shells.

- The `pkg∆shell_version` API reports the version of `bash` and `yash`.

- The new `pkg∆alias` API creates an alias for a defined function or
  operator. See the `]pkg alias [<function-name> <alias-name>]` command
  (below) and `doc/API.md` for further details.

Features
--------

- The new `]pkg unload` command, which accepts the name of a package
  which has been loaded using the `]pkg load` command, removes the
  specified package and any dependent packages that are no longer required.

- The new `]pkg stats` command shows a count of defined functions,
  variables and operators for each loaded package.

- The new `]pkg script <name> [<wsid>]` command executes a Unicode APL
  script a line at a time, e.g. for use during presentations. A line read
  from the script may be edited before pressing Enter to execute the
  expression. Pressing Enter once more calls up the next line from the
  script.

- The new `]pkg alias [<function-name> <alias-name>]` command creates an
  alias of a defined function or operator. Aliases can be convenient during 
  creation of prototypes and applications where the fully-qualified names
  (including a package prefix) may be too cumbersome. The `]pkg alias`
  command, without names, lists all defined aliases. A function (or operator)
  may have multiple aliases, but an alias may not have an alias.

- The new `]pkg unalias <alias-name>` command removes an alias.

- The `]pkg read` command shows lines only for existing documents. (Early
  versions of the package manager showed placeholders in the case that the
  package had fewer than ten documents. The limit remains at ten.) In the
  case that there are no documents in the package, the command displays a
  message in place of the header line.

- The `]pkg load` command skips loading already-loaded packages, reporting
  each package that has been skipped.

- The new `]pkg reload` command forces the package manager to reload an
  already-loaded packages. This command does not reload the package's
  dependents.

- The `]pkg packages` command uses a `+` to mark a package that has been
  loaded as a dependency.

- The `]pkg packages` command uses a `-` to mark an expunged package that
  is still required.

- The `]pkg expunge` command notes an attempt to expunge a package which
  has not been loaded.

- The optional argument of the `]pkg locate` command is `show` in order to
  list the APL code of the located function. This is equivalent to the
  optional `apl` argument of earlier releases. The `]pkg locate` command
  no longer supports external viewers.

- The `]pkg edit` command no longer accepts an optional argument to choose
  the editor.

- The external programs used to support the `]pkg edit` command may be
  configured using the `~/.apl-pkg` file. See `doc/EDITOR.md` for details.

- The `akt` program supports an optional flag used by the external editor
  support code.

- The `awe` script defaults to the first profile found in the GNU APL
  preferences file. Specify `-p mono` to ignore profiles and disable colors.

- The `awe` script has a new `-M` flag to suppress manifest loading.

- The `awe` script has a new `-c` flag to display the full command used to
  invoke APL.

- With the removal of `tmux` integration (see Compatibility, below), the `awe`
  script no longer accepts the `-s` flag.

- Debug mode is set while loading the package manager. If a fault happens
  while loading the package manager, execution will suspend at the point of
  failure. The file and source line number of the fault may be examined
  using the APL expression `path lc`. Debug mode is reset as soon as the
  package manager has finished loading.

- The `]pkg debug` messages explicitly report the current state.

- The `]pkg names` command accepts an optional keyword to filter the output
  by functions, variables or operators.

- The loader now enforces the requirement that an init package not have
  dependencies. The loader will report the names of the dependent packages
  and exit APL.

Bug Fixes
---------

- Selective assignment, e.g. `(n↑x)←...`, is no longer rejected as invalid
  by the `]pkg load` loader.

- The `]pkg locate <function> show` command includes the header line(s) in
  its paged output.

- The `]pkg locate <function>` command reports a native function.

- The `]pkg disable <name>` command now refuses to disable a loaded package.

- The `awe` script no longer attempts to load the toolkit with a missing
  default manifest.

Compatibility
-------------

- The support for `tmux` has been removed. In its place, you may use either
  `tabbed` (an XEmbed container) or `dvtm` (a virtual terminal multiplexer).
  The pager is disabled under `dvtm`; scrollback is provided by `dvtm`.

- The `akt` keyboard translator is now required.

- The console support files `extra/console/console-apl` and `.../aplkeymap.map`
  have been removed. Their functionality is now integrated into `awe`.

- The `awe` script works in the Linux console. It runs APL inside `dvtm` in
  order to support the `]pkg edit` command.

Changes from Netochka release to Wibble release
===============================================

Compatibility
-------------

- Warn at startup if the GNU APL version is less than 1.5.

Features
--------

- The `]pkg sh` command runs a shell command in a package directory.

- The `]pkg refs` command displays external references of a defined function or
  operator.

- The `]pkg uses` command displays the defined functions and operators that
  refer to a given global name.

- The `]pkg undefs` command displays all the undefined objects referenced by
  defined functions and operators. With an optional object-name argument,
  `]pkg undefs` displays the functions and operator which reference the
  undefined name.

- The `]pkg unrefs` command displays all unreferenced functions and operators.

- The `]pkg disable` command disables a named package, but not its dependents.
  Use this command to hide a package that has a duplicated prefix. Without a
  package name, this command lists all disabled packages.

- The `]pkg enable` command reverses the effect of `]pkg disable` for a named
  package. Use `*` instead of package name to enable all packages.

- The `]pkg edit` command allows use of an external editor to edit a function
  in its defining file.

- The `]pkg apropos` command lists names containing a given substring.

- The `]pkg pager` command turns the display pager on and off and adjusts the
  page length.

- With APLwrap by Chris Moller, tab completion may be used for commands and
  arguments. See `doc/APLWRAP.md` and `doc/COMPLETION.md` for details.

- Added the akt (APL Keyboard Translator) program to the distribution and
  installation.

- Added files to integrate GNU APL, akt and apl-pkg, creating the "APL
  Workbench Environment". See the `extra` directory and `doc/AWE.md` for
  details.

- If the `akt` executable is on `$PATH`, it is automatically invoked to give
  the `]pkg locate` viewers and `]pkg edit` editors (except for Emacs, which
  has its own input method) a natural APL input method using the Alt key to
  access APL characters.

- `]pkg locate` invokes `vim` in read-only mode.

- Viewers and editors for `]pkg locate` and `]pkg edit` are limited to those
  which accept keyboard input from stdin (making them compatible with `akt`)
  and require no configuration apart from font selection: `less` and `vim`.
  (Emacs may use `gnu-apl-mode` by Elias Mårtenson.)

- When running inside tmux, the `]pkg locate` and `pkg edit` editors open in a
  new tmux window. The `akt` program is required for tmux support. A tmux
  version of at least 1.8 is required.

Bug Fixes
---------

- The `]pkg load` command declines to load a package if the package or any of
  its dependents have a prefix which is duplicated in the local repository.

- The `]pkg load` command declines to load a package if the package or any of
  its dependents have the prefix `S` or `T`; these prefixes are reserved for
  APL stop and trace control.

- The rules restricting system assignment are now consistent for functions and
  top-level expressions. Assignment to global system variables `⎕`, `⍞` and
  `⎕SVE` (also spelled `⎕sve`) is always permitted. All other system variables
  may only be assigned after localization within a function.

- A failed load no longer leaves a partial footprint in the workspace.

- The `]pkg package` command does not fail when only the package manager is
  loaded.

- The `--pkg-load` command-line option is now spelled correctly.

- The `]pkg locate` command shows the function definition even when no file
  information has been recorded.
