⍝! APL Package Manager

⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ This is a stub file used to identify the package manager as a
⍝ package. The package manager doesn't load like a normal package, but
⍝ bootstraps via a platform-specific file in the boot directory.
'You have attemped either to have the package manager load itself or to'
'manually load the package manager''s control file. Neither approach works.'
''
'The installer will have placed a link in your workspaces directory(ies)'
'to facilitate loading using either `)LOAD pkg` or `)COPY pkg`. These'
'commands are the proper way to load the package manager.'
