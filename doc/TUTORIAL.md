Tutorial for APL Package Manager
================================

Overview
--------

This document is an introduction to using the APL Package Manager.

You'll learn:

* the difference between a package and a workspace,
* the prerequisites necessary to use the package manager,
* where to find help to install and use the package manager,
* how to download and install the package manager,
* how the package manager directories are laid out,
* how to start and use the package manager from within APL,
* how to add packages to the package manager's repository,
* how to create your own package from scratch,
* how to turn existing APL code into a package,
* how to locate code and edit loaded by the package manager,
* how to invoke a shell command in a package directory,
* how to display references and uses information for programs,
* how to show a report of function, variable and operator counts,
* how to disable a package to eliminate a conflicting prefix,
* how to run an APL script line-by-line, e.g. for presentations, and
* how to use function aliases to streamline application development.

> The sections on creating packages are necessarily short in order to
  not overwhelm the first-time reader with too much ancillary detail.
  Package creators and maintainers are strongly encouraged to read
  `API.md` after having familiarized yourself with this tutorial.

Applicability
-------------

This tutorial applies to the APL Package Manager release named
`Percy`. (Use the `]pkg ident` command; see below.)

What is a package?
------------------

A package is a structured collection of code plus information about
that code. A package differs from the traditional APL workspace:

1. A package is designed to be used with other packages. The included
   information about a package helps the package manager to automate
   certain tasks, including:
   - loading related packages as required for proper function,
   - ensuring that global names don't conflict among multiple packages,
   - optionally compiling and loading code written in other languages,
   - conditionally loading code according to platform requirements, and
   - translating the APL program's character set as needed.

2. A package's code and information is written using Unicode. This
   allows the use of conventional tools to create edit, print, inspect
   and store the components of a package. Contrast this to an APL
   workspace, which is usually readable only by a specific APL system,
   or to an APL interchange-format file (such as created by an `)out`
   command) which is not readily readable or modifiable outside of APL.

Prerequisites
-------------

The tutorial assumes that you're running GNU APL on a Linux host. The
package manager will advise you at startup if your version of GNU APL
is older than expected. If you're running a copy of the package
manager from the `git` repository you may need to build your own GNU
APL from its `SVN` repository.

The tutorial assumes that `$HOME/workspaces` is your APL workspaces
directory and that you tell the installer to create the package
repository directory as `$HOME/apl-pkg/repo`. If you use different
directories, adjust the tutorial instructions accordingly.

You may want to have `gcc` and `gmake` installed; these are used by
the `demo-p8` package to illustrate how an APL package can compile and
execute a C program during the package's installation. If you don't
have these tools installed, the `demo-p8` package won't work; nothing
in the package manager depends on `gcc` or `gmake`.

Resources
---------

If you get stuck, please join `bug-apl` and ask questions.

Downloading
-----------

The package manager should be downloaded as a zip file, then unzipped
in a convenient temporary location.

Installation
------------

The installation script should be run after you download the package
manager.

```
$ cd .../apl-pkg
$ ./install.sh
```

You'll provide the name of a directory for the local package
repository. The package manager will be installed into this directory.
You'll also add new packages into the local package repository
directory.

> It is permissible to manually copy the package manager into the
  local package repository. You'll still need to run the installer.

You'll be asked to provide paths to directories (other than those
already configured in `~/.gnu-apl/preferences`) in which you keep your
APL workspaces.

If you feel that you've made a mistake during installation, you can
rerun the installer at any time.

> Note that the installer only copies files and creates symbolic
  links. There's no reason that you can't do this manually or write
  your own script. Be aware that if you change existing paths, you'll
  need to update the package manager's configuration file and symbolic
  links.

Next, you should install the demonstration packages.

```
$ cd .../apl-pkg/demo
$ ./install.sh
```

Choose the same package repository directory that you named during
installation.

Once installation is finished you can remove the zip file and (unless
you've unzipped the package manager directly into the local package
repository) its expanded directory.

Directory Layout
----------------

This is an abbreviated listing of how the package manager appears in
the filesystem, as well as its relationship to your workspaces
directory.

Please remember that this layout matches the tutorial; you may have
chosen other directories.

```
~/apl-pkg-repo [repository directory]
  |-- apl-pkg  [package manager's package]
  |   |-- _control_.apl
  |   |-- _metadata_
  |   |-- boot
  |   |   |-- gnu-apl-linux.apl <----\
  |   |   `...                        |
  |   |-- demo                        |
  |   |   |-- demo-p1                 |
  |   |   |   |-- _control_.apl       |
  |   |   |   |-- _metadata_          |
  |   |   |   `-- p1.apl              |
  |   |   |-- demo-p2                 |
  |   |   |   |-- _control_.apl       |
  |   |   |   |-- _metadata_          |
  |   |   |   `-- p2.apl              |
  .   .   .                           |
  |   |   |-- install.sh              |
  |   |   `...                        |
  |   |-- doc                         |
  |   |   |-- API.md                  |
  |   |   |-- CMDLINE.md              |
  |   |   |-- ROADMAP.md              |
  |   |   `-- TUTORIAL.md             |
  |   |-- install.sh                  |
  |   |-- LICENSE                     |
  |   |-- maint                       |
  |       `...                        |
  .   .                               |
  |   |-- README.md                   |
  |   |-- script                      |
  |       `...                        |
  .   .                               | [symbolic link]
  |   |-- src                         |
  |       `...                        |
  .   .                               |
  |   |-- stress                      |
  |   |   `-- test.sh                 |
  |   `-- template                    |
  |       |-- _control_.apl           |
  |       |- _metadata_               |
  |       `...                        |
  |-- demo-p1                         |
  |   |-- _control_.apl               |
  |   |-- _metadata_                  |
  |   `-- p1.apl                      |
  |-- demo-p2                         |
  |   |-- _control_.apl               |
  |   |-- _metadata_                  |
  |   `-- p2.apl                      |
  .                                   |
  |-- package-dir-1  [a package]      |
  |   `...                            |
  |-- package-dir-2  [a package]      |
  |   `...                            |
  ...                                 |
                                      |
~/workspaces   [APL's WS directory]   |
  |-- workspace-file-1  [a WS]        |
  |-- workspace-file-2  [a WS]        |
  `-- pkg.apl -----------------------/
```

The package manager expects packages to be in a repository directory.
Throughout this tutorial the directory `~/apl-pkg-repo` will be the
repository directory. (You may choose a different directory at
installation time.)

The package manager (`apl-pkg`) is itself a package located in the
repository.

A package (e.g. `demo-p1` and `demo-p2`) contains code written in APL.
(A package may optionally contain code written in other languages. See
`demo-p8` for an example.)

For convenience, a symbolic link is located in APL's workspace
directories (in this case, `~/workspaces`) so you can load the package
manager using the APL `)load pkg` command.

Start APL
---------

Start GNU APL.

```
$ apl
```

Load the Package Manager
------------------------

In the APL session, you'll see the cursor indented by six spaces. This
lets you know that APL is ready for your input.

Load the package manager into APL with this command:

```
      )load pkg
```

APL will respond:

```
loading )DUMP file /home/dlamkins/workspaces/pkg.apl...
    User-defined command ]pkg installed.
```

> You may want to set an appropriate workspace name using the `)wsid
  <name>` command.

> Alternatively, you may use `)copy pkg`; this will not change the
  current workspace name.

If this step fails, make sure that you've run the installer.

Run the Package Manager
-----------------------

Still in the APL session where you've loaded the package manager, run
the `]pkg` command.

```
      ]pkg
```

The package manager will respond:

```
 Commands:    help       [<command>]
              ident      [platform|configuration|environment]
              packages
              read       <package-name> [<document-id>]
              depends    <package-name>
              metadata   <package-name>
              load       <package-name>
              disable    [<package-name>]
              enable     <package-name>|*
              expunge    <package-name>
              unload     <package-name>
              reload     <package-name>
              new        <package-name>
              sh         <package-name> <shell-command>
              init       <directory>
              rescan
              names      <prefix> [fns|vars|ops]
              apropos    <substring>
              locate     <function-name> [header|show]
              inspect    <variable-name>
              alias      [<function-name> <alias-name>]
              unalias    <alias-name>
              edit       <function-name>
              refs       <function-name> [<depth>]
              uses       <object-name>
              undefs     [<object-name>]
              unrefs
              stats
              pager      [on|off|automatic|manual]
              setpw
              script     <file> [<wsid>]
              time       <expression>
              debug      [on|off]
 Command names and keywords may be abbreviated.
```

This is a quick reminder of all of the commands recognized by the
package manager. For example `]pkg help` will print the same message,
while `]pkg help packages` will print a brief description of what the
packages subcommand does.

Package manager releases are named according to the implemented
functionality. If you ever need to learn the identity of the package
manager's release, use:

```
      ]pkg ident
```

Next, list the packages in your workspace.

```
      ]pkg packages
```

The package manager should show you its own entry plus all of the
demonstration packages you installed previously.

```
 Name         L Prefix Path
 ----         - ------ ----
 apl-packager * pkg    /home/dlamkins/apl-pkg-repo/apl-pkg
 demo-p1        d1     /home/dlamkins/apl-pkg-repo/demo-p1
 demo-p2        d2     /home/dlamkins/apl-pkg-repo/demo-p2
 demo-p3        d3     /home/dlamkins/apl-pkg-repo/demo-p3
 demo-p4        d4     /home/dlamkins/apl-pkg-repo/demo-p4
 demo-p5        d5     /home/dlamkins/apl-pkg-repo/demo-p5
 demo-p6        d6     /home/dlamkins/apl-pkg-repo/demo-p6
 demo-p7        d7     /home/dlamkins/apl-pkg-repo/demo-p7
 demo-p8        d8     /home/dlamkins/apl-pkg-repo/demo-p8
 demo-p9        d9     /home/dlamkins/apl-pkg-repo/demo-p9
```

Your paths, of course, will be different.

This table shows the name of each package along with its prefix (to be
described later) and path. The important thing to know right now is
that you'll always refer to the package by its name.

A package should come with documentation. The package manager can list
a package's documentation using the `]pkg read <name>` command. For
example, we can list the documentation provided for the package
manager, which is itself a package:

```
      ]pkg read apl-packager
```

You'll see a list of documents something like this:

```
  #  Title                                       Path
  -  -----                                       ----
  1  APL Package Manager                         README.md
  2  Tutorial for APL Package Manager            doc TUTORIAL.md
  3  API for APL Package Manager                 doc API.md
  4  Command-line Options                        doc CMDLINE.md
  5  Release Roadmap for APL Package Manager     doc ROADMAP.md
  6  APL Package Manager demonstration packages  demo README.md
  7  The MIT License (MIT)                       LICENSE
```

The `#` column provides the document ID to use for reading a
particular document. For example,

```
      ]pkg read apl-packager 2
```

would display the tutorial on your screen.

Package Loading and Dependencies
--------------------------------

You can load any package with the `]pkg load <name>` command; the
package manager will *do the right thing*, loading the package and any
other packages that are needed by the package you named. These other
packages are called *dependencies*. Dependencies are described by the
package itself.

The package manager will not load a package unless all of its
dependencies are present. This saves you from loading a system that
won't be able to run.

You can display a package's dependencies using the `]pkg depends
<name>` command. This shows all dependencies, both direct (specified
by the named package itself) and indirect (specified by dependent
packages).

For example:

```
      ]pkg depends demo-p1
```

Might respond:

```
 Dependencies:  demo-p1
                demo-p2
                demo-p3
                demo-p5
                demo-p4
```

This shows that several other packages are required to support the
`demo-p1` package.

Or:

```
      ]pkg depends demo-p8
```

Might respond:

```
 Dependencies:  demo-p8 
```

This shows that the `demo-p8` package stands alone.

When you load a package, for example:

```
      ]pkg load demo-p1
```

the package manager displays whatever's printed by the packages during
loading, then provides a report of the packages loaded.

```
    1    1 /home/dlamkins/apl-pkg-repo/demo-p1/p1.apl
    2    1 /home/dlamkins/apl-pkg-repo/demo-p2/p2.apl
    3    1 /home/dlamkins/apl-pkg-repo/demo-p3/p3.apl
NOTE: Execute d5⍙mut <n>
    1    1 /home/dlamkins/apl-pkg-repo/demo-p5/p5.apl
NOTE: Execute d4⍙mut <n>
    1    1 /home/dlamkins/apl-pkg-repo/demo-p4/p4.apl
    3    1 /home/dlamkins/apl-pkg-repo/demo-p4/p4a.apl
    3    1 /home/dlamkins/apl-pkg-repo/demo-p4/p4b.apl

 Func/Expr Package
 --------- -------
    0    2 /home/dlamkins/apl-pkg-repo/demo-p1
    0    2 /home/dlamkins/apl-pkg-repo/demo-p2
    0    2 /home/dlamkins/apl-pkg-repo/demo-p3
    0    2 /home/dlamkins/apl-pkg-repo/demo-p5
    0    4 /home/dlamkins/apl-pkg-repo/demo-p4
```

Note the lines printed by the file loader; these display the full path
to each loaded file. The first two numbers on the line aren't
important to understand at this point.

Missing Packages
----------------

You'll see an error message if you attempt to load when a package is
missing. For example:

```
      ]pkg load no-such-package
 MISSING PACKAGES:  no-such-package
```

You can use the `]pkg depends <name>` command to run a *preflight
check* before loading a package.

```
      ]pkg depends demo-p6
```

This shows you the names of all packages that should be loaded, as
well as the names of any needed packages that are missing.

```
 Dependencies:  demo-p6
                demo-p8
                no-such-package
 --
 Missing:       no-such-package
```

APL Session
-----------

From this point on, I'll dispense with the *you type* and *APL (or
package manager) responds* commentary. Remember that inputs to the APL
session are indented.

Adding New Packages
-------------------

To add a new package, simply copy it into your `~/apl-pkg-repo`
directory.

If you add a package after having loaded the package manager, you'll
need to inform the package manager of the change by issuing a `]pkg
rescan` command.

```
      ]pkg rescan
 OK
```

You should also do this if you remove a package after having loaded
the package manager.

Package Information
-------------------

A package carries information about itself. The package's name and
dependencies (if any) are present for every package.

A package's author may choose to include addition information. To view
this information, use the `pkg metadata <name>` command.

For example, the package manager's own metadata might look something
like this:

```
      ]pkg metadata apl-packager
 author          David B. Lamkins
 email           david@lamkins.net
 organization    Just some guy at home
 license         The MIT License (MIT); See the LICENSE file
 description     Package Manager for APL, based upon a concept by
                 David Lamkins. This is a preliminary implementation
                 to facilitate validation of the concepts and to
                 spark discussion of the approach.
 keyword         package manager
 keyword         dependencies
 keyword         multiplatform
 keyword         multilanguage
 keyword         analysis
 date            2015-10-06
 depends_on
 package_name    apl-packager
 package_version 0 3 0 836
 package_prefix  pkg
 document_file   README.md
 document_name   APL Package Manager
 document_file-1 doc TUTORIAL.md
 document_name-1 Tutorial for APL Package Manager
 document_file-2 doc API.md
 document_name-2 API for APL Package Manager
 document_file-3 doc CMDLINE.md
 document_name-3 Command-line Options
 document_file-4 doc ROADMAP.md
 document_name-4 Release Roadmap for APL Package Manager
 document_file-5 demo README.md
 document_name-5 APL Package Manager demonstration packages
 document_file-6 doc EDITOR.md
 document_name-6 Editor support
 document_file-7 doc PREFERENCES.md
 document_name-7 APL Package Manager preference file
 document_file-8 doc CHANGES.md
 document_name-8 APL Package Manager changes by release
 document_file-9 LICENSE
 document_name-9 The MIT License (MIT)
 home_repository https://github.com/TieDyedDevil/apl-pkg
```

Package Prefixes
----------------

The APL notation dates back to the late 1950s, with the first language
implementations appearing over the following decade. There wasn't a
lot of thought given to *programming-in-the-large* aside from vague
advice to make sure that you don't use the same identifier names as
other programmers working with you on different parts of the same
project. The modern notion of *namespaces* had yet to be formalized,
much less implemented in a programming language.

APL (at least the variants close to ISO 13751 and IBM APL 2) still has
only a single namespace. This is a challenge that we need to address
by convention when writing packages for APL. Our approach is to use a
distinctive prefix for every top-level name in a package. Note that
local variable names don't need to (and, for brevity, shouldn't) use
the package prefix.

Take a look at the source code for the package manager itself: the
name of every top-level defined function, variable and operator in the
package manager code begins with the `pkg` prefix. You'll see similar
use of package prefixes in the demo packages.

A package carries information about its prefix. You see this in the
report generated using `]pkg packages`. A package prefix should be
short and evocative of the package's purpose or identity.

When writing your own package, you'd be well advised to choose a
prefix not already taken by another package. In particular, you should
never create top-level names having the `pkg` prefix. Doing so would
open up the possibility of conflicts between your code and the package
manager's code.

There are a limited number of short prefixes. Eventually two
programmers working independently will decide that some prefix (say,
`foo`) is *perfect* for their own package. Now we're right back where
we started: the two packages can't coexist because of (potential or
actual) naming collisions.

There are two ways of dealing with such prefix collisions. The first
approach, which has been successfully employed for decades by Emacs
Lisp programmers, is to avoid such collisions in the first place. In
the short term, this is the approach that APL package creators will
need to follow.

Longer term, we can anticipate help from the package manager by way of
rewriting APL code as it's being loaded. This feature (*not yet
implemented*) will depend upon the package prefix information.

It should be noted that a package may have *only one* prefix.

Finally, there's the matter of overlapping prefixes. Imagine two
packages where one uses the prefix `foo` and the other the prefix
`foonly`. The former is itself a prefix of the latter. In order to
avoid package `foo` colliding with package `foonly`, we require that
names in a package are either the prefix itself (the package manager,
for example, has the package prefix `pkg` and a function named `pkg`)
or the prefix followed by a break character (i.e. a character that's
valid in an APL name, but not an alphabetic or numeric character. The
break characters are `¯`, `_`, `∆` and `⍙`.

Finding Code
------------

When you have multiple packages loaded into your APL workspace, you
might have some difficulty using the native APL commands `)fns`,
`)vars` and `)ops` effectively. These commands will show you every
name from every loaded package, including the package manager itself.

The package manager offers help in the form of the `]pkg names
<prefix>` command. This command shows all of the names (of all kinds)
having a specific prefix.

For example, to see all of (and only) the names in use by the package
manager:

```
      ]pkg names pkg
 Kind Name
 ---- ----
 FUN  pkg
 FUN  pkg∆case
 OPR  pkg∆compare_version
 FUN  pkg∆copy
 VAR  pkg∆manager
 FUN  pkg∆shell
 ...  ...
```

Let's say I've loaded the demonstration package `demo-p1`. This
required loading additional dependencies. Now we have multiple
packages loaded. Referring to the output of `]pkg packages` for the
package prefixes, I can list the names in each package individually.

```
      ]pkg names d1
 Kind Name
 ---- ----
 FUN  d1⍙f
 VAR  d1⍙v
      ]pkg names d2
 Kind Name
 ---- ----
 FUN  d2⍙f1
 FUN  d2⍙f2
 VAR  d2⍙v
      ]pkg names d3
 Kind Name
 ---- ----
 FUN  d3⍙f1
 FUN  d3⍙f2
 FUN  d3⍙f3
 VAR  d3⍙v
```

You may optionally filter the returned names according to whether they
are function, variables or operators by passing an optional keyword
`fns`, `vars` or `ops` as the second argument of the `]pkg names`
command.

Alternatively, you may want to find an object based upon some part of
its name, regardless of the package. The `]pkg apropos` command does
this:

```
      ]pkg apropos load
 Kind Name
 ---- ----
 FUN  pkg⍙cmd_load
 FUN  pkg⍙get_load_paths
 FUN  pkg⍙load
 FUN  pkg⍙load_from_manifest
 FUN  pkg⍙load_local_metadata
 FUN  pkg⍙load_local_package_list
 FUN  pkg⍙load_one_package
 VAR  pkg⍙⍙loaded_packages
```

Expunging a Package
-------------------

You may expunge a package using the `]pkg expunge <name>` command. The
package manager erases from the APL workspace every defined function,
variable and operator that has a name beginning with the given
package's prefix.

The expunge command expunges *only* the named package. Dependencies are
not considered.

**The expunge command is an advanced and dangerous operation. It can
  break a loaded package by removing dependencies. You are advised to
  use the expunge command only in the case where you fully understand
  the consequences.**

The `]pkg unload <name>` command expunges not only the named package,
but also any of its dependents that are not needed by some other
package. The command recognizes only packages that were loaded by the
`]pkg load` command.

Reloading a Package
-------------------

The package manager normally avoids reloading an already-loaded
package. You can force the package manager to reload a package using
the `]pkg reload <name>` command.

What's in a Package?
--------------------

Thus far we've treated packages as closed boxes. Let's look inside.

A package is a directory containing two required files: `_metadata_`
and `_control_.apl`.

The `_metadata_` file contains information about the package. This
includes

1. the package name
2. the package's dependencies (if any), and
3. the package prefix.

The `_control_.apl` file is a file of APL code written in a Unicode
UTF-8 encoding. The package manager loads and executes this file and
only this file. The `_control_.apl` file may be the only APL file in
the package, or it may use the package manager API to load other APL
files and run shell commands on the host (e.g. to compile and/or
install programs written in other languages).

Because the package manager is intended to load packages into a
variety of APL interpreters on a variety of host platforms, it is
imperative that the `_control_.apl` file is written using a common
dialect of APL without any vendor-specific extensions or enhancements.

> The package manager API will be extended to include functions 
> useful in differentiating platform characteristics.

Apart from the `_metadata_` and `_control_.apl` files, a package may
contain anything that's useful to the package. Also, source- and
version-control information is allowed and treated as invisible to the
package.

A package may not reach outside of its containing directory. The
exception is that platform tools (compilers, for example), files
(libraries and headers, for example) and locations (installation
directories, for example) may be used if adequately qualified by
probes to find the proper entities on different platforms.

> Again, the API to support this is not yet fully-developed. Be aware
  that you'll probably need to retrofit the associated controls into
  packages that you develop now.

Package Metadata
----------------

The `_metadata_` file contains entries that are either informational
or declarative. Informational entries are for the reader; they're not
interpreted by the package manager. Declarative entries say something
about the package that may be used by the package manager.

The `author`, `keyword` and `description` entries, for example, are
informational.

The `package_name`, `package_prefix` and `depends` fields are
declarative.

Additional fields will be used declaratively in future releases of the
package manager. These fields include `package_version`, `date` and
`home_repository`.

Declarative fields must conform to certain standards. These fields
will be will be validated in future releases of the package manager.
For now, follow the examples established by the `template/_metadata_`
file.

Creating a Package
------------------

We're close to the end of the tutorial. In this section, we'll create
a very simple package from scratch.

> Refer to the demonstration packages for additional examples.

A package is identified by its name. This name may be, but is not
required to be, the same as the package's directory name.

The package manager's `]pgk new <name>` command creates an empty
package in your `~/apl-pkg-repo` directory. The command creates a
directory having the same name as the package. Try it:

```
      ]pkg new tut-1
 OK 
```

You can list the new directory to see what just happened:

```
$ ls -R ~/apl-pkg-repo/tut-1
/home/dlamkins/apl-pkg-repo/tut-1:
_control_.apl  _metadata_
```

That's an empty package: a directory, a control file and a metadata
file.

Now take a look at the `_metadata_` file. You'll see that the
`package_name` field has been filled in for you, but the
`package_prefix` is empty.

```
...
# A package name must contain only lowercase alphabetic characters
# plus (optionally) '_' and '-'. The first character of a package name
# must be alphabetic.
#
package_name: tut-1

# The package manager confirms that prefixes won't collide when
# loading multiple packages into the APL workspace. A prefix must
# begin with an alphabetic character and be composed entirely of
# alphabetic and numeric characters. Refer to API.md for additional
# rules about the use of prefixes in APL programs to be loaded by
# the package manager.
#
package_prefix: 
...
```

We need to pick a prefix. Let's keep it short.

```
package_prefix: t1
```

Remember that the directory name, package name and prefix may all be
different. Feel free to change any of these at this point. While you're
editing the metadata, you may as well fill in any other fields you'd
like.

After you've edited and saved the metadata, tell the package manager.

```
      ]pkg rescan
 OK
```

> If you see a `tut-1 IS A PATCH PACKAGE` message, then you've
  forgotten to do the rescan.

Now you can see the package manager's view of the metadata.

```
      ]pkg metadata tut-1
 package_name    tut-1
 package_prefix  t1
 package_version
 depends_on
 date
 keyword
 author
 email
 organization
 license
 description
 document_file
 document_name
 home_repository
```

You'll notice that I left most fields empty. This is perfectly
acceptable for a package that you don't intend to share. You can
always go back and fill in missing fields later.

Now in the `tut-1` directory, create an APL file. Let's say that,
after extensive consideration, we've decided to call this file
`foo.apl`. This file will, in your case, contain a perfect gem of an
APL program. Mine is a bit less ambitious:

```
⍝ foo.apl

t1∆my_msg←'This is my first package.'

∇t1∆hello
 ⎕←t1∆my_msg
∇
```

Remember earlier that we learned that `_control_.apl` is the only file
actually loaded by the package manager. How, then, do we load
`foo.apl`? The answer is simple: we have `_control_.apl` load `foo.apl`.

Add the following expression to the bottom of your package's
`_control_.apl` file:

```
pkg∆copy 'foo.apl'
```

This is a call to the package manager's API. It has the same effect as
APL's own `)copy` command.

> Don't use `)copy`! I won't burden you with the reasons. Suffice it
  to say that you should *never* use an APL *)-command* in your
  `_control_.apl` file.

Now your package is ready to load. Go ahead:

```
      ]pkg load tut-1
    1    1 /home/dlamkins/apl-pkg-repo/tut-1/foo.apl

 Func/Expr Package
 --------- -------
    0    2 /home/dlamkins/apl-pkg-repo/tut-1
```

The first line is the report from the `pkg⍙copy` command in your
`foo.apl` file, telling you the path to the file (your path will
differ, of course) and that the loaded file defined one function and
executed one expression.

The following report says that the package manager loaded your
package. The `0` and `2` refer to the number of functions created and
top-level expressions evaluated by the `_control_.apl` file.

Now that the package is loaded, we can see what it defined in our
workspace.

```
      ]pkg names t1
 Kind Name
 ---- ----
 FUN  t1∆hello
 VAR  t1∆my_msg
```

And finally...

```
      t1∆hello
This is my first package.
```

Congratulations! You've written your first APL package.

Locating and Editing Functions
------------------------------

When you're working with a larger package, it can be useful to quickly
locate where a function was defined. The package manager lets you
locate the file and line number of any function loaded by the package
manager. For example:

```
      ]pkg locate t1∆hello
 File path:    /home/dlamkins/apl-pkg-repo/tut-1/foo.apl
 Line number:  5
 Signature:    t1∆hello
```

You may optionally follow the `]pkg locate` command with the keyword
`show` to display the function's definition.

If you simply want to edit a function in its file and don't need to
know where the file is located, use the `]pkg edit` command.

Shell Command
-------------

You can execute shell commands without leaving your session. For
example:

```
      ]pkg sh apl-packager ls -l
total 40
drwxr-xr-x.  2 dlamkins dlamkins    45 Jun 26 12:08 boot
-rw-r--r--.  1 dlamkins dlamkins   719 Jun 24 17:26 _control_.apl
drwxr-xr-x. 11 dlamkins dlamkins   252 Jun 24 17:33 demo
drwxr-xr-x.  2 dlamkins dlamkins  4096 Jun 26 12:28 doc
drwxr-xr-x.  3 dlamkins dlamkins    63 Jun 24 17:33 extra
-rwxr-xr-x.  1 dlamkins dlamkins 11870 Jun 24 17:33 install.sh
-rw-r--r--.  1 dlamkins dlamkins  1083 Jun 24 17:26 LICENSE
drwxr-xr-x.  4 dlamkins dlamkins  4096 Jun 26 12:04 maint
-rw-r--r--.  1 dlamkins dlamkins  1444 Jun 26 12:29 _metadata_
-rw-r--r--.  1 dlamkins dlamkins  3616 Jun 24 17:26 README.md
drwxr-xr-x.  2 dlamkins dlamkins    67 Jun 24 17:33 script
drwxr-xr-x.  3 dlamkins dlamkins  4096 Jun 26 12:23 src
drwxr-xr-x.  2 dlamkins dlamkins    38 Jun 24 17:33 stress
drwxr-xr-x.  2 dlamkins dlamkins    98 Jun 24 17:33 template
```

The package name sets the working directory for the shell command.

Reference Tree
--------------

Given the name of a defined function or operator, you may display all
non-local references. For example:

```
      ]pkg refs pkg
      ^: expanded above; *: recursive; -: other; ~: dynamic;
      V: variable; F: defined function; O: defined operator;
 ___  v: system variable; f: system function
   F| pkg
   F| . pkg⍙cmd_help
   V| . . _cmd_info
   V| . . _verbs
   F| . . pkg⍙PAGER
   F| . . . pkg⍙pager_lines
   F| . . . . pkg_pager_enable
   V| . . . . pkg_pager_override
   F| . . . . pkg⍙in_emacs
   F| . . . . . pkg⍙env
   f| . . . . . . ⎕env
   F| . . . . pkg⍙pager_length_bounds
   F| . . . . pkg⍙tput
   F| . . . . . pkg⍙have_tput
   F| . . . . . . pkg⍙have_command
   F| . . . . . . . pkg⍙sh
   F| . . . . . . . . pkg⍙utf_to_ucs
   f| . . . . . . . . . ⎕ucs
   v| . . . . . . . . ⎕
   f| . . . . . . . . ⎕fio
   F| . . . . . . . pkg⍙⍙path_separator
 ^ F| . . . . . pkg⍙sh
   v| . . . ⎕
   f| . . . ⎕nc
   F| . . pkg⍙prefix_match
   v| . . ⎕
 ^ F| . pkg⍙prefix_match
   v| . ⎕
   f| . ⎕nc
```

References are followed recursively. If you prefer to limit the depth
of the reference tree, specify the maximum depth as follows:

```
      ]pkg refs pkg 1
      ^: expanded above; *: recursive; -: other; ~: dynamic;
      V: variable; F: defined function; O: defined operator;
 ___  v: system variable; f: system function
   F| pkg
   F| . pkg⍙cmd_help
   F| . pkg⍙prefix_match
   -| . ⎕
   f| . ⎕nc
```

Callers List
------------

Given the name of a function, operator or variable, you may list all
defined functions and operators which refer to the name. For example:

```
      ]pkg uses pkg⍙FAIL_UNLESS_LOADING
 pkg∆case
 pkg∆compare_version
 pkg∆copy
 pkg∆file
 pkg∆shell
```

Undefined and Unreferenced
--------------------------

The `]pkg undefs` command lists all undefined objects. This is a list
of APL identifiers which appear in a defined function or operator but
are not otherwise defined in the current workspace.

Objects listed by `]pkg undefs` may be defined by other mechanisms not
detected by the package manager. In general though, it's good practice
to investigate the reported undefined objects as it's possible that
these represent identifiers that are unintentionally omitted from a
defined function's list of localized names.

To find out where an undefined object is referenced, run `]pkg undefs`
with the object name. (Unlike `]pkg uses`, `]pkg undefs` doesn't
require the object to be defined.)

The `]pkg unrefs` command lists all functions and operators which are
defined but not referenced by any defined function or operator in the
workspace.

Functions listed by `]pkg unrefs` are either top-level functions (i.e.
part of a program's public API) or functions or functions that you
have defined by not used.

It's useful to invent naming conventions to help you visually identify
the role of names reported by `]pkg undefs` and `]pkg unrefs`. Such
conventions may make the unexpected appearance of names easier to
spot.

Function References Cache
-------------------------

The `]pkg refs`, `]pkg callers`, `]pkg undefs` and `]pkg unrefs`
commands all use a function references cache for speed. It may take
several seconds up to a few tens of seconds to build the cache the
first time it is used. While the cache is being built you'll see this
message:
  
```
 Building complete function references cache...
```
  
Once the initial cache build completes, you'll see:
  
```
 Done. Updates will be done incrementally.

```

The cache is updated as needed when defined functions and operators
are added, deleted or redefined. No notice is given during cache
updates.

Package Statistics
------------------

Use the `]pkg stats` command to display the count of defined functions,
variables and operators for all loaded packages.

Conflicting Package Prefixes
----------------------------

The package manager declines to load a package if it, or any dependent
package, has a prefix that's the same as that of another package. This
might happen, for example, if you have alternative packages which use
the same package prefix because they implement the same functionality
in different ways.

In order to load a package that has a conflicting prefix, you must
disable all other packages which have the same prefix. Use the `]pkg
disable <name>` command:

```
      ]pkg disable package-1
 OK
```

Currently disabled packages may be listed using `]pkg disable` without
a package name.

A disabled package may be enabled using the `]pkg enable <name>` command:

```
      ]pkg enable package-1
 OK
```

All packages may be enabled using the `]pkg enable *` command.

Note that the disabled package list is reset each time you load the
package manager.

Packaging Existing Code
-----------------------

If you have a directory of existing code that you'd like to turn into
a package, you can add the `_control_.apl` and `_metadata_` files
using the `]pkg init <directory>` command.

This command does the same thing as the `]pkg new <package>` command,
but for an already-existing directory in the packages directory. You
remain responsible for assuring that the metadata and control files
are properly completed and that your existing code meets the
requirements summarized in `API.md`

Running a Script Line-By-Line
-----------------------------

When giving a live presentation, it can be useful to execute APL from
a script but execute each line on command. The `]pkg script <name>
[<wsid>]` command reads a Unicode APL file from a workspace directory,
presenting each line individually. The line may be edited before pressing
the Return key to execute the expression. The Return key must be pressed
once more to call up the next expression from the script.

A script file does not require indentation of APL expressions. Empty
lines in the script are skipped. The script file, like all other APL
files read by the package manager, must not contain tab characters.

Using Function Aliases
----------------------

The package manager enforces distinct package namespaces. This
facilitates the use and sharing of independently-developed packages.
However, the fully-qualified names (including the package prefix) can
be cumbersome to type. Since a package typically contains a large
number of internal functions and a smaller number of functions intended
for use by applications, and applications often use only a subset of
those functions, it can be practical and convenient to alias those
functions with shorter, more convenient names. (I say "functions", but
this discussion also applies to defined operators.)

Define an alias using the `]pkg alias <function-name> <alias-name>`
command. For example:

```
      ]pkg alias CF_OPEN open
      ]pkg alias CF_APPEND append
      ]pkg alias CF_TRANSACTION_BEGIN begin
      ]pkg alias CF_TRANSACTION_COMMIT commit
      ]pkg alias CF_TRANSACTION_ABORT abort
      ]pkg alias CF_CLOSE close
```

This creates aliases that you'd use to write an application using
component files. (The `iso-apl-cf` package is available from the 
same location in which you found the package manager.)

You can list all defined aliases using the `]pkg alias` command
(i.e.  without names) and remove a defined alias using `]pkg unalias
<alias-name>` command.

Aliases may be used to good effect in building an APL workspace
around specific packages. Extending the above example, we could
create a workspace file, say `my-ws.apl`, containing:

```
⍝!
)copy pkg
]pkg load iso-apl-cf
⍝ load other packages here...
]pkg alias CF_OPEN open
]pkg alias CF_APPEND append
]pkg alias CF_TRANSACTION_BEGIN begin
]pkg alias CF_TRANSACTION_COMMIT commit
]pkg alias CF_TRANSACTION_ABORT abort
]pkg alias CF_CLOSE close
⍝ create other aliases here...
⍝ your application code goes here...
```

Then you can load your application using the command:

```
      )load my-ws
```

The above approach is specific to GNU APL because of the `]pkg` user
command. If you prefer an approach that will be portable to other APL
systems (anticipating the day when the package manager supports other APL
systems), you should use the package manager's API to define aliases. You
might do this in your package's `_control_.apl` file, like this:

```
⍝ File: mypackage/_control_.apl
pkg∆load 'iso-apl-cf'
⍝ load other packages here...
pkg∆alias 'CF_OPEN' 'open'
pkg∆alias 'CF_APPEND' 'append'
pkg∆alias 'CF_TRANSACTION_BEGIN' 'begin'
pkg∆alias 'CF_TRANSACTION_COMMIT' 'commit'
pkg∆alias 'CF_TRANSACTION_ABORT' 'abort'
pkg∆alias 'CF_CLOSE' 'close'
⍝ create other aliases here...
```

Alternatively, you could collect all of the `pkg∆alias` definitions
into a separate file and load that as part of your package. The only
restrictions are that `pkg∆alias` may only be invoked while loading a
package and must not be used in any package loaded via a manifest.

Additional Information
----------------------

This concludes the tutorial. Please look at the demonstration packages
for additional inspiration. The demonstration packages will introduce
you to dependent packages and to using shell commands to compile and
run programs in other languages.

Read `API.md` for a full description of the package API, including
rules for constructing metadata and APL code.

Read `CMDLINE.md` for a description of command line options that may
be passed to the package manager.

References
----------

1. [GNU APL](http://www.gnu.org/software/apl/)
2. [bug-apl](https://lists.gnu.org/mailman/listinfo/bug-apl)
