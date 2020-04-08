⍝ This is a package control file.

⍝ Decline to load this file unless the package manager is present.
⍎(0=⎕nc'pkg∆manager')/'''Load using the APL Package Manager.'' ◊ →'

⍝ ================================================================

pkg∆copy 'p4.apl'
pkg∆copy 'p4a.apl'
pkg∆copy 'p4b.apl'
