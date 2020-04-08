API for APL Package Manager
===========================

Overview
--------

This document describes the public API for programming packages to
install using the APL Package Manager.

There are four aspects to this API:

1. file and directory naming conventions
2. restrictions on APL code
3. functions exported by the package manager
4. metadata definitions

Files and Directories
---------------------

An APL package is entirely contained in a single directory. The
directory name **should** be related to the package name.

The directory name may indicate other properties of the package. For
example, when the package manager supports multiple versions of the
same library, each version will be in its own directory.

In order to be recognized as an APL package, a directory **must**
contain two files:

1. `_control_.apl`
2. `_metadata_`

The control file contains APL code. This code may be the entirety of
the library's code. Most often, though, the control file will copy
other files of APL code into the workspace.

The control file **must** be encoded in UTF-8.

The package manager provides functions that will be useful in
selectively loading code according to platform requirements. These
functions **should** be called from the control file.

A control file is intended to be loaded only by the package manager
and not by the APL `)LOAD` command. A control file **should** begin
with a guard to stop loading unless the package manger is present:

```
⍎(0=⎕nc'pkg∆manager')/'''Load using the APL Package Manager.'' ◊ →'
```

The value of `pkg∆manager` is unimportant. Only its presence (or
absence) matters. Likewise, the message may be different, but **should**
indicate the nature of the problem.

Note that the above guard does not prevent loading the control file
with the APL `)LOAD` command. The guard only prevents loading when the
package manager is not present. This is important since the control
file is likely to use functions in the package manager's API.

The metadata file contains information about the package. Each piece
of information is tagged with a keyword. Some metadata (e.g.
dependency information) is used directly by the package manager. Other
metadata (e.g. package description) is purely informational.

The metadata file **must** be encoded in ISO-8859-1.

Load-Time vs. Run-Time
----------------------

APL code may be executed during loading of a package or during
execution of a package. Different restrictions apply depending upon
when the code executes. In general, code executed at load-time is
restricted while code executed at run-time is unrestricted except for
naming conventions.

Restrictions on APL Code
------------------------

The package manager coordinates the loading of APL code created by
multiple independent developers. Additionally, the package manager
intends to accommodate multiple APL interpreters. Consequently, the
package manager takes steps to ensure that packages:
- will not interfere with one another, and
- will load successfully under multiple APL interpreters.

As a result, you **must** obey a few conventions when packaging your
APL code.

The first convention is that *every* global name **must** begin with a
package prefix. This is essential since APL has only a single
namespace.

The prefix **should** be short and related to the package. For
example, the package manager's own prefix is `pkg`.

Global names in the package **must** have a break character separating
the prefix from the rest of the name. The valid break characters are:

| Character   | Name           |
| :---------: | :------------: |
| ∆           | del            |
| ⍙           | del-underbar   |
| ¯           | overbar        |
| _           | underbar       |

You may establish your own conventions for the portion of the name
following the prefix and break character.

A package **must** use only one prefix.

A package **must not** use `S` or `T` (uppercase letters s and t) as a
prefix. These are reserved for use as *stop* and *trace* control (as
`S∆` and `T∆`) in IBM APL 2.

> Local names, i.e. names localized in the header of a defined
> function, need not (and for readability, shouldn't) use a package
> prefix.

A package **should not** encode metadata in its prefix. For example,
don't include a version number (not even a major version) in a prefix.
On the other hand, it is acceptable to include ordinal numbers in a
prefix, e.g. for a series of similar or related packages.

The second convention is that your code **must not** assign to
unlocalized system variables. Doing so would be likely to create
conflicts among packages. For example, if one package globally set
`⎕io←1` and another set `⎕io←0`, the two packages could not be loaded
into the same workspace without conflict.

Note that this restriction applies only to global assignment of system
variables. You may freely assign to system variables localized inside
a defined function.

> Three system variables may be assigned without restriction. These
  are `⎕`, `⍞` and `⎕SVE` (also spelled `⎕sve`).

The third convention is that your APL code **must not** invoke system
commands. The standard APL commands `)CONTINUE`, `)LOAD`, `)COPY`,
`)PCOPY`, `)IN`, `)PIN`, `)CLEAR`, `)WSID`, `)SIC`, `)ERASE`,
`)RESET`, `)SAVE`, `)DROP` etc. are disallowed because of their
potential to conflict with the package manager's loader. The remaining
*)-commands* are disallowed because they're not especially useful
during package loading.

> The loader allows implementation-specific extended APL session
  commands (i.e. those having the form `]...`) offered by some
  systems. At present, all such commands are allowed. In the future,
  the loader may restrict the set of allowed *]-commands*.

> In the GNU APL implementation of the package manager, the `]USERCMD`
  command will always be allowed. Use other *]-commands* at your own
  risk.

The fourth convention is that APL code to be executed during loading by
the package manager **should not** invoke ⎕ES to signal an error; the
package manager *may* rewrite the error type or message.

The fifth convention is that APL code **must not** assign to global
or dynamic variables in other packages.

Loading of Packages
-------------------

The package manager's notion of loading a package is closer to APL's
`)copy` command than it is to the `)load` command. Loading a package
does not alter the result of `)wsid`, nor does it clear the workspace
before loading.

When requested to load a package, the package manager loads a package
and all of its dependent packages. The package manager does not
specify an order in which packages load.

The package manager may or may not reload a requested or dependent
package if that package is already loaded into the workspace.

Functions Exported by the Package Manager
-----------------------------------------

The package manager defines a number of functions for use in loading a
package.

> APL provides no controls over access to names. Your package **should
> not** access package manager names not on the *exported* list.

| Function            | Use                                   | Phase |
| ------------------- | ------------------------------------- | :---: |
| pkg∆manager         | package manager release               | Q     |
| pkg∆platform_family | host platform kind                    | R     |
| pkg∆os_type         | host OS identification                | R     |
| pkg∆os_distribution | host OS identification                | R     |
| pkg∆os_version      | host OS identification                | R     |
| pkg∆apl_type        | APL system identification             | R     |
| pkg∆apl_version     | APL system identification             | R     |
| pkg∆shell_type      | host shell identification             | R     |
| pkg∆shell_version   | host shell identification             | R     |
| pkg∆case            | select alternatives functions         | L     |
| pkg∆compare_version | test relation between version numbers | L     |
| pkg∆shell           | run host shell command                | L     |
| pkg∆copy            | copy APL code into workspace          | L     |
| pkg∆file            | query host filesystem objects         | L     |
| pkg∆alias           | alias a defined function or operator  | L [1] |

There are three phases referenced in the table.

1. **Q**: Query - Determine the presence of the package manager via
   `0≠⎕nc 'pkg∆manager'`.
2. **L**: Load-time - These functions may only be called during package
   loading. [1] The pkg∆alias function must not be invoked when loading
   a package from a manifest.
3. **R**: Run-time - These functions may be called at package run time
   if guarded by a query for package manager presence. These functions
   may also be called during package loading.

### pkg∆manager

`z←pkg∆manager`

The return value is a string used to identify the release of the
package manager. This serves as a broad indicator of the package
manager's functionality (see `ROADMAP.md`).

### pkg∆platform_family

`z←pkg∆platform_family`

The return value is a string indicating the host platform's family.

Currently, the only value is `unix`; future releases may extend this
to include, e.g. `apple` and `windows`.

### pkg∆os_type

`z←pkg∆os_type`

The return value is a string indicating the host platform's OS type.

At present, this is determined on Unix platforms by examining the
output of `uname -s`. The only value so far is `linux`.

### pkg∆os_distribution

`z←pkg∆os_distribution`

The return value is a string indicating the host platform's OS
distribution.

At present, this is determined on Linux platforms by examining the
contents of `etc/os-release`. Values include `fedora`, `ubuntu` and
`debian`.

If a value is unable to be determined by the probes, the value is
`unknown`.

### pkg∆os_version

`z←pkg∆os_version`

The return value is a numeric vector indicating the host platform's OS
version. Note that this is the version of the OS distribution, not the
kernel.

At present, this is determined on Linux platforms by parsing
`/etc/os-release`. The number of version components will depend on the
OS distribution.

If a value is unable to be determined by the probes, the value is
`unknown`.

### pkg∆apl_type

`z←pkg∆apl_type`

The return value is a string indicating the APL interpreter's type.

In general, this is determined by probing for functions, variables or
behaviors (separately or in combination) believed specific to a
particular APL interpreter. The only value so far is `gnu`.

If a value is unable to be determined by the probes, the value is
`unknown`.

### pkg∆apl_version

`z←pkg∆apl_version`

The return value is a numeric vector indicating the APL interpreter's
version.

This is determined in a manner particular to the interpreter. At
present, GNU APL is supported.

If a value is unable to be determined by the probes, the value is
`unknown`.

### pkg∆shell_type

`z←pkg∆shell_type`

The return value is a string indicating the user's shell command
processor.

At present, this is determined on Linux platforms by examining the
`SHELL` environment value. Values include `bash`, `dash` and `ksh`.

If a value is unable to be determined by the probes, the value is
`unknown`.

### pkg∆case

`selector pkg∆case choices`

This is case-like control construct to help simplify the writing
platform-specific logic.

- selector is one of the platform definition values (see above).
- choices is a list of pairs of values to be matched and
  expressions to be executed. One pair may have an empty match
  value; this is the default choice.

Example:

`pkg∆os_type pkg∆case ('linux' 'fn1') ('osx 'fn2') ('' 'fn3')`

### pkg∆compare_version

`z←a (relation pkg∆compare_version) b`

Return true if relation holds for version numbers. Versions a and b
are vectors of up to four integers. Omitted trailing components are
assumed zero. The four components may have three, four, five and six
decimal digits, respectively.

### pkg∆shell

`z←pkg∆shell command`

Execute shell command after setting working directory to package
directory. May be used only while loading a package. Return shell
output.

### pkg∆copy

`z←pkg∆copy path`

Copy APL file on package-relative path into workspace. May be used
only while loading a package. Return forms count report and full path.

The path argument is restricted. It **must** be a relative path
containing no spaces and no parent components.

### pkg∆file

`z←noerror pkg∆file path`

Return info for the host filesystem object at path:

- file type
- size
- modification time
- creation time
- access bits (rwx)

File type is one of the strings:

- `socket`
- `symbolic link`
- `regular file`
- `block device`
- `directory`
- `character device`
- `FIFO`

Times are in `⎕ts` format.

A left argument, if present and not zero, suppresses a signaled error
and instead causes the function to return a scalar error code.

### pkg∆alias

`z←pkg∆alias name alias`

Alias `name`, which must be a defined function or operator, such that it
can be invoked using the (usually shorter) `alias`. The `alias` must not
conflict with a name in a loaded package.

The arguments are returned upon success. Failure terminates loading and
reports an error.

Metadata Definitions
--------------------

The package manager uses a metadata file to define attributes of a package.

The metadata file defines keyword/value pairs. A keyword is the first
word on a line, followed by a `:` character. The keyword may be
preceded by spaces. There **must not** be whitespace between the word
and the `:` delimiter. The delimiter **must** be followed by at least
one space.

The value is the remaining text on the line (following the keyword and
`:` character) after stripping leading and trailing spaces.

A value may be extended across multiple lines. Each non-comment line
which contains non-empty text is appended to the value. The
platform-specific newline is preserved. The usual rule about stripping
leading and trailing blanks applies even on continuation lines.

Do not use tabs in a metadata file; use spaces. (This limitation
probably won't be lifted. Tabs simply aren't worth the trouble from
the standpoint of presenting a tabbed text in other contexts.)

The encoding of a metadata file **must** be ISO-8859-1.

### Reserved Metadata

| Name             | Format        | Multi | Required |
| :--------------- | :------------ | :---: | :------: |
| package_name     | ident         | N     | Y        |
| package_prefix   | alphanum      | N     | [2]      |
| package_version  | version       | N     | N        |
| date             | date          | N     | N        |
| depends_on       | ident vconstr | Y     | N        |
| keyword          | text          | Y     | N        |
| author           | text          | [1]   | N        |
| email            | email         | [1]   | N        |
| organization     | text          | [1]   | N        |
| author-#         | text          | [1]   | N        |
| email-#          | email         | [1]   | N        |
| organization-#   | text          | [1]   | N        |
| license          | multiline     | Y     | N        |
| description      | multiline     | N     | N        |
| document_file    | path [3]      | [1]   | N        |
| document_name    | text          | [1]   | N        |
| document_file-#  | path [3]      | [1]   | N        |
| document_name-#  | text          | [1]   | N        |
| home_repository  | url           | Y     | N        |

The listed metadata names are reserved to the package manager. Other
names may be used for purposes internal to the package. A package's
private metadata **should** be named beginning with `x-` or `x_`.

All of a package's metadata may be queried using the `pkg∆metadata`
function.

Here's how to interpret entries in the above table:

| Legend    | Interpretation                                |
| --------- | --------------------------------------------- |
| alphanum  | alpha, digits (alpha first)                   |
| date      | ISO 8601 date, e.g. 2014-06-08 (YYYY-MM-DD)   |
| email     | RFC 5322 email address                        |
| ident     | lowercase alpha, `_`, `-` (alpha first)       |
| multiline | ISO-8859-1 text w/line breaks; no empty lines |
| text      | ISO-8859-1 text; no line breaks               |
| url       | RFC 3986 URL                                  |
| version   | 1 to 4 numbers (0-999 0-999 0-99999 0-99999)  |
| vconstr   | version constraint(s); see description below  |
| [1]       | append -<number> for additional instances     |
| [2]       | if present, must match package's prefix       |
| [3]       | relative, space-separated components          |

The package manager disables all prefix checks for that package if the
package's metadata file specifies an empty package prefix (note [2] in
the above table); any prefix is permitted, both in defined function
names and in assignments. (Assignment to unlocalized system variables
remains prohibited, regardless.)

This empty-prefix feature may be useful during *system development* in
case you need to *temporarily* patch other packages, overriding some
of their definitions and assignments with your own. Your system must
explicitly load (either in its `_control_.apl` file or in its
manifest) your patch package(s); a package without a declared
prefix is *never* displayed in the `]pkg packages` report.

A package having an empty prefix **must not** have any dependencies.
Given its role as a patch device, such a package should remain outside
the dependency tree.

You **must not** distribute a package having an empty package prefix.
Doing so could break the contract provided by other package's APIs,
causing misbehavior and confusion.

Some keys (marked with [1] in the above table) may have multiple
distinct instances with sequential numeric suffixes. The first key in
a series (or the only key if there is no series) has no suffix. These
sequential keys are used only for keys that must be grouped, as is the
case with `author`, `email` and `organization`. Sequential keys **must
not** be used for keys in which the multiples form a set, as is the
case with `keyword` and `depends_on`.

The metadata lookup API provides special behaviors to deal with series
of sequential keys; see `pkg∆metadata`.

The `depends_on` key identifies the name of another package upon which
this package depends. A package may specify multiple `depends_on` keys
in any order. The package manager ensures that all dependencies are
loaded (recursively). The package manager does not specify the order
in which it loads dependent packages.

Circular or mutual dependencies are allowed. The package manager
automatically breaks cycles in the dependency graph during loading.

The `depends_on` package identifier is followed by zero or more
version constraints. A version constraint is one of the characters
`_` (base), `<` (less) or `!` (exclude) followed by a space and a
version number. Multiple `base` constraints are maximized; multiple
`less` constraints are minimized; exclude constraints are collected.
The absence of constraints is equivalent to the constraints
`_ 0 < 999 9999 99999 999999` which accepts any version.

The `date` metadata **should** be the package creation date.

The `home_repository` metadata **should** be the package's home page.
A home page typically presents human-readable information about the
package, plus references to the package's dependencies.
