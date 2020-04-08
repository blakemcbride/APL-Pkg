Completion
==========

*I no longer actively support APLwrap. Patches are welcomed.*

This document describes tab completion functionality available only
when the APL Package Manager is run under APLwrap [1].

Command Completion
------------------

The APL Package Manager implements the APLwrap command-completion
protocol. This means that package manager commands may be completed
using the Tab key.

Proper operation of this functionality requires APLwrap 2.2 or later.

Command completion may be used for most portions of a package manager
command line *after* the `]pkg` token. You must type one or more
leading characters of the next token before pressing the Tab key; tab
completion never works on an empty prefix.

Completion of command options depends upon a fully-expanded context.
This means that completion will not function if you have abbreviated
any portion of the context.

Identifier Completion
---------------------

Tab completion may be used when entering APL code in the APLwrap
transcript window. You must type a prefix of the desired identifier
before pressing the Tab key. Repeatedly pressing the Tab key cycles
through all identifiers which begin with the prefix.

Additional Information
----------------------

Please refer to the APLwrap documentation for additional information
regarding tab completion.

References
----------

1. [APLwrap](https://github.com/ChrisMoller/aplwrap/)
