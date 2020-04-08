Maintainer scripts
==================

This directory has documentation and scripts are for the maintainer of
the APL Package Manager.

The purpose of each script is summarized below.

check-apl
---------

Using the `version-info` file for reference, `check-apl` reports
whether the current GNU APL version is older than, the same as or
newer than the version used at the time of the most recent package
manager commit.

check-system
------------

The `check-system` script reports the presence of tools and fonts that
may be used by `awe` and the package manager.

commit
------

The `commit` script does a number of important checks before invoking
a `git` commit of updates to the package manager repo. The script also
updates the package manager's version number in the `../_metadata_`
file.

files-check
-----------

The `files-check` script reports files that have overlong lines or
unwanted whitespace characters.

install-git-hooks
-----------------

The `install-git-hooks` script tells git to use hooks found in the
`git-hooks` directory.

The `pre-commit` hook causes git to remind you to use the `commit`
script rather than invoking `git commit` directly.

printable-files
---------------

The `printable-files` script prints a list of all the files which are
suitable for printing. This may be handy when used with a print
command, for example:

```
$ lpr `./maint/printable-files`
```

stats
-----

The `stats` script prints simple line counts of all of the package
manager's source code files, grouped by category.

wip
---

The `wip` command scans all of the package manager's APL files for the
words `FIX`, `TODO`, `FINISH` and `REMOVE` and prints each occurrence
with file and line identification and a bit of surrounding context. The
matched words mark unfinished work in the package manager's code.
