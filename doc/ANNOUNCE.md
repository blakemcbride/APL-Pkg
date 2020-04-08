Date:    xxxx-xx-xx
Contact: [David B. Lamkins](mailto:david@lamkins.net)

Announcing the 4th Release of APL Package Manager
=================================================

The **APL Package Manager** is a tool to manage the development and deployment
of APL software built from a collection of packages.

In its fourth release, named *Percy*, the **APL Package Manager** supports GNU
APL version 1.5 or later on GNU/Linux hosts. This release introduces package
version numbers and a mechanism to load a set of packages that all satisfy
the version constraints described by their metadata.

See `doc/CHANGES` for further details regarding these and other changes.

About the APL Package Manager
-----------------------------

Although APL is very good for interactive programming based upon structured
datasets, the ISO/IBM version of the language lacks modern facilities for
programming-in-the-large. This historical limitation fosters a culture of
reinvention rather than reuse. Large software systems were built using APL in
the days of top-down software management. Those days are gone.

The **APL Package Manager** defines and checks a set of conventions to support
reuse of code among far-flung and self-managed APLers.

The central shared artifact of the **APL Package Manager** is a package. A
package collects one or more cohesive APL source code files together with
descriptive metadata, optional documentation and data files, optional source
code files in other languages (e.g. for building helper applications and
interfaces), plus a control file to load the package; these are all located
within a single directory that may be distributed as an archive file or a
source code repository.

Packages may be used alongside traditional APL workspace files or source code
files. APL source code files are easily packaged with help from the **APL
Package Manager**.

The **APL Package Manager** supports deployment of completed systems.

Future releases of the **APL Package Manager** will implement additional tools
and features, version management, and remote repositories.

The **APL Package Manager** is designed to support additional APL interpreters
and host platforms.

The **APL Package Manager** is open source software distributed under the MIT
License.

References
----------

1. [APL Package Manager](https://github.com/TieDyedDevil/apl-pkg)
2. [GNU APL](http://www.gnu.org/software/apl/)
