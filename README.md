APL Package Manager
===================

Note: This package was created by David B. Lamkins.  It has been moved here with his permission.

Overview
--------

This is a package manager for APL, providing support for independent
development of modular APL code. A package contains one or more source
code files plus a metadata file and a control file. Source code files
are normally APL files encoded in UTF-8; the package manager loads these
directly. A package may also build and use code written in languages
other than APL.

The package manager analyzes dependencies expressed in the package
metadata and automatically handles loading of dependent packages.

The package manager also provides tools to analyze APL programs and
workspaces.

See `doc/ANNOUNCE.md` for further details about the current release.

Target Platform
---------------

The package manager runs under GNU APL on Linux. The design of the
package manager anticipates other platforms (both APL and OS).

Note that I build GNU APL from the SVN head. You should, too. GNU APL
versioned releases (e.g. 1.5, 1.6, ...) are intended only as a quick
way for prospective users to evaluate the program.

Installation
------------

Run `./install.sh`. Follow the instructions.

You'll be asked to specify a location for the local APL packages
repository. You'll also be asked to specify the location of directories
(other than those already configured in `~/.gnu-apl/preferences`) where
you have workspaces.

Additional Programs and Environments
------------------------------------

The `awe` script provides a convenient way to start the APL Package
Manager. See `doc/AWE.md` for details.

External editor support requires additional programs. See `doc/EDITOR.md`
for a description of the external editor behaviors and a list of the
default programs. The defaults may be changed by entries in `~/.apl-pkg`;
the details are in `doc/PREFERENCES.md`.

See `doc/EMACS.md` for a description of how to use the APL Package
Manager inside Emacs with Elias Mårtenson's `gnu-apl-mode`.

In a Linux console, APL Package Manager should be run from within `dvtm`
or Emacs (see `extra/README`). The `awe` script automatically invokes
`dvtm` when run from within a Linux console.

See `doc/APLWRAP.md` for a description of and reference to Chris Moller's
`APLwrap` shell and `doc/COMPLETION.md` for a description of how `APLwrap`
provides tab-completion for package manager commands.

See `doc/VIS.md` for an introduction to `vis`, a lightweight vi-like editor
with built-in support for APL syntax.

See `doc/VIM.md` for packages to make `vim` aware of APL syntax.

What can I do with this today?
------------------------------

See `doc/TUTORIAL.md` for a detailed walkthrough.

Sample Packages
---------------

The `demo` directory contains some sample packages. See that directory's
README file for instructions.

Programmer Documentation
------------------------

The public API is documented in `doc/API.md`. Also see `doc/TUTORIAL.md`,
the `demo` directory and code comments.

Release Roadmap
---------------

See `doc/ROADMAP.md` for a brief outline of anticipated functionality
to be introduced in future releases.

Relation to "APL Library Guidelines"
------------------------------------

The "*APL Library Guidelines*" provides a set of conventions to aid in
creating portable libraries of APL code using only APL 2 facilities. No
package manager is used.

The APL Package Manager provides tools to support package management.
It does not implement the "*APL Library Guidelines*".

Feedback
--------

Please share your thoughts on *bug-apl*. For an overview of the support
you may expect, please read `doc/SUPPORT.md`.

References
----------

1. [GNU APL](http://www.gnu.org/software/apl/)
2. [bug-apl](https://lists.gnu.org/mailman/listinfo/bug-apl)
3. [APL Library Guidelines][3]

[3]: http://www.gnu.org/software/apl/Library-Guidelines.html
