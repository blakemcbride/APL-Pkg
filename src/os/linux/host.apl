⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ Definitions:
'pkg⍙⍙path_separator' pkg⍙constant '/'
'pkg⍙⍙path_parent' pkg⍙constant '..'
'pkg⍙⍙newline' pkg⍙constant ⎕av[10+⎕io]

∇z←pkg⍙⍙octal_to_bv32 octal
 ⍝ Internal use only. Convert an integer denoting an octal number
 ⍝ into a corresponding vector of 32 bits.
 ⍝ For example:
 ⍝   34002100005 becomes
 ⍝   1 1 1 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1
  z←(32⍴2)⊤(11⍴8)⊥(11⍴10)⊤octal
∇

∇z←pkg⍙parse_st_mode mode;fm;ff;nm;mb;ft;um;gm;om
 ⍝ Given an fstat() mode field, return a list denoting the
 ⍝ file type and the three access masks.
  fm←pkg⍙⍙octal_to_bv32 0170000
  ff←pkg⍙⍙octal_to_bv32¨0140000 0120000 0100000 0060000 0040000 0020000 0010000
  nm←'socket' 'symbolic link' 'regular file' 'block device' 'directory'
  nm←nm,'character device' 'FIFO'
  mb←(32⍴2)⊤mode
  ft←(∧/¨(⊂mb∧fm)=¨ff)/nm
  um←(pkg⍙⍙octal_to_bv32 00700)/mb
  gm←(pkg⍙⍙octal_to_bv32 00070)/mb
  om←(pkg⍙⍙octal_to_bv32 00007)/mb
  z←ft,um gm om
∇

∇z←pkg⍙unix_to_apl_time ts
 ⍝ Convert a Unix timestamp to ⎕ts form.
  z←⍎↑pkg⍙sh 'date "+%Y %m %d %H %M %S 0" --date="@',(⍕ts),'"'
∇

∇z←pkg⍙user_uid
 ⍝ Return the current user's uid.
  z←⍎↑pkg⍙sh 'id -u'
∇

∇z←pkg⍙user_gid
 ⍝ Return the current user's gid.
  z←⍎↑pkg⍙sh 'id -g'
∇

∇z←pkg⍙have_command cmd
 ⍝ True if host has the given command.
  z←pkg⍙⍙path_separator=↑,⊃pkg⍙sh 'which ',cmd,' 2>/dev/null'
∇

∇z←pkg⍙have_tput
 ⍝ True if host has the tput command.
  z←pkg⍙have_command 'tput'
∇

∇z←pkg⍙tput code
 ⍝ Get terminal control codes from tput.
  z←''
  →(~pkg⍙have_tput)/0
  z←∊pkg⍙sh 'tput ',code
∇

∇z←pkg⍙in_emacs
 ⍝ True if we're running inside Emacs.
  z←0≠↑⍴pkg⍙env 'EMACS'
∇

∇z←pkg⍙in_wm
 ⍝ True if we're running inside a window manager.
  z←0≠↑⍴pkg⍙env 'DISPLAY'
∇

∇z←pkg⍙in_dvtm
 ⍝ True if we're running inside dvtm.
  z←0≠↑⍴pkg⍙env 'DVTM_CMD_FIFO'
∇

∇z←pkg⍙have_akt
 ⍝ True if host has the akt command.
  z←pkg⍙have_command 'akt'
∇
