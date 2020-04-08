Coding Standards
================

The APL Package Manager is composed of source code. This file
documents the coding standards in use for the project.

APL source code
---------------

APL code in the `boot/` directory will have a file for each supported
interpreter. These files may depend upon non-standard APL features and
semantics. All code in the `boot` directory should be written using
Unicode UTF-8 encoding.

APL code in the `src/` directory (except for the `platform/` subdirectory;
see below) *must be* written using only ISO 13751 and IBM APL2 language
features and semantics.

The `src/platform/` directory has a subdirectory for each supported APL
platform. APL code in `src/platform/*` may rely on features and semantics
specific to a particular APL platform.

The `src/os/` directory has a subdirectory for each supported OS. Code in
these directories provides abstracts access to the underlying filesystem,
process and networking facilities of the OS.

APL source code in the `src/`, `src/os/`, and `src/platform/` directories
*must be* written using Unicode UTF-8 encoding.

> The APL Package Manager's loader should map the code points of
  similar glyphs in a manner that's acceptable to the APL system.

APL source files should not contain lines longer than 80 characters.

APL source files *must not* contain tab characters.

APL source code is indented as follows:

* Every line outside of a function definition aligns flush left.
* The ∇s used to open and close a function definition align flush left.
* The function header begins immediately after the opening ∇.
* Comment-only lines within a function are indented by 1 space.
* Labeled lines within a function are indented by 1 space.
* Other lines within a function are indented by 2 spaces.
* Empty lines consist of nothing but a newline.

The **APL Package Manager** imposes constraints upon identifier names
and use of certain language features; see `API.md` for details.

Metadata files
--------------

Package metadata files (i.e. `_metadata_`) *must* be written in
ISO-8859-1 encoding and *must not* contain tab characters.

See `API.md` for additional details.

Shell scripts
-------------

Shell scripts, while not part of the package manager proper, are used
for installation and administrative tasks.

Shell scripts are written assuming a POSIX-compliant shell (e.g. dash).
*Do not use Bash-isms in scripts!*

Indentation should be in four-space increments.

Scripts *must not* contain tab characters.

The first line of every script must be a hash-bang line to identify
the shell:

```
#! /bin/sh
```

We assume that `/bin/sh` will invoke a POSIX-compliant shell. Do not
explicitly name a different shell.

Editor metadata
---------------

Some editors (emacs and vim) allow a source file to contain metadata to
control editor settings (e.g. indentation and tab expansion).

APL Package Manager source files (including scripts and documentation)
should not contain such metadata. Instead, program your editor to apply
settings based upon the file extension.
