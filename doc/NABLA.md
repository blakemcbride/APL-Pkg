Nabla Editor
------------

GNU APL, like APLs of old, offers a way to edit functions inside APL.
The "nabla" editor starts using the ∇ character for which the editor
is named. (Actually, the nabla editor offered the *only* means of
editing APL functions until Unicode offered APL character support.)

The nabla editor, which always displays the number of the current
line, accepts commands as shown below. Exit the editor using the ∇
character to save your edits or the ⍫ command to save your edits and
lock the function. (In GNU APL, the lock affects only execution
properties, not visibility.)

All edits take effect immediately. There is no way for the nabla
editor to abandon an edit and revert the function to its unedited
state.

Note that you may specify fractional line numbers while editing; this
is how you insert lines. Deleted lines leave gaps in the line numbers
while editing. The next time you edit the function, the line numbers
will be consecutive integers.

Commands may be stacked on the same line. For example,

```
  [∆18] [15⎕20] [16.1] x←0
```

deletes line 18, shows lines 15 through 20 and inserts (or changes)
line 16.1 with the text `x←0`.

The nabla editor is primarily useful if you keep your code in an APL
workspace file (an XML file in GNU APL).

```
Invocation
  ∇FUN                                   (open FUN to edit)
  ∇FUN[⎕]                                (list FUN and open to edit)
  ∇FUN[⎕]∇                               (list FUN)

Commands
  [⎕] [n⎕] [⎕m] [n⎕m] [⎕n-m]             (show: all, from, to, range)
  [n∆] [∆m] [n∆m] [∆n-m] [∆n1 n2 ...]    (delete: one, range, set)
  [→]                                    (wipe all lines except 0)
  [n]                                    (set current line number)
  text                                   (replace text on line)
  ∇                                      (save function)
  ⍫                                      (save and lock function)
```
