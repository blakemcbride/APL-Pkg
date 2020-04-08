⍝ This is a package control file.

⍝ Decline to load this file unless the package manager is present.
⍎(0=⎕nc'pkg∆manager')/'''Load using the APL Package Manager.'' ◊ →'

⍝ ================================================================

pkg∆copy 'p8.apl'
pkg∆shell 'cd src && make c8 2>&1'
pkg∆shell 'src/c8'
pkg∆shell 'rm -f src/c8'
