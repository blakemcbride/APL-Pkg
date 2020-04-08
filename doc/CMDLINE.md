Command-line Options
====================

The package manager can, if the hosting APL system supports access to
its command line arguments, read and process command line options
during startup.

The supported options are:

* `--pkg-load`
* `--pkg-manifest`
* `--pkg-disable`

Load one package
----------------

The option `--pkg-load` *package-name* loads one package. This option
may be specified multiple times if needed.

Load multiple packages
----------------------

The option `--pkg-manifest` *manifest-name* loads all packages listed
in a manifest file. The manifest file is located in the local package
repository directory. This option may be specified multiple times if
needed.

The manifest file contains one package name per line. Extra newlines
are ignored. Blanks before and after the package name are ignored. Do
not use tab characters in a manifest file.

Disable named package
---------------------

The option `--pkg-disable` *package-name* disables only the named
package; not its dependencies. This is useful to disable a package
which has a prefix that's identical to the prefix of another package.
This option may be specified multiple times if needed.
