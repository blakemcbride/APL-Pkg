⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙ls path;h
 ⍝ Return a list of directory entries.
  z←⍬
  h←⎕fio[24] 'ls ',path
 more: →(⎕fio[11] h)/error
  →(⎕fio[10] h)/end
  z←z,⊂⎕av[⎕io+¯1↓(⎕fio[8] h)]
  →more
 end: ⊣ (⎕fio[25] h)
  z←¯1↓,/(⊂path,pkg⍙⍙path_separator),[1.5]z
  →0
 error: ⎕←'pkg⍙ls ERROR ',(⎕fio[2] (⎕fio[1] ⍬)),' ',path
∇

∇z←pkg⍙sh command;h;l
 ⍝ Returns a list of shell output lines from the given command.
 ⍝ Terminating newlines are stripped.
  z←⍬
  h←⎕fio[24] command
 more: →(⎕fio[11] h)/error
  →(⎕fio[10] h)/end
  l←⎕fio[8] h
  →(0=⍴l)/end
  ⍎(32>¯1↑l)/'l←¯1↓l'
  z←z,⊂pkg⍙utf_to_ucs l
  →more
 end: ⊣ (⎕fio[25] h)
  →0
 error: ⎕←'pkg⍙sh ERROR: ',(⎕fio[2] (⎕fio[1] ⍬)),' ',command
∇

∇z←noerror pkg⍙file_info path;h;s;m;a
 ⍝ Get information regarding a file. Returns:
 ⍝  file_type user_mode_bits group_mode_bits other_mode_bits
 ⍝   owner_uid owner_gid size modification_time creation_time
 ⍝   access_bits
 ⍝ Times are in seconds since the Unix epoch.
 ⍝ Access bits are rwx given current uid/gid.
 ⍝ If the left argument is present and not 0, errors cause
 ⍝ return of a scalar error code rather than reporting an error.
  h←⎕fio[3] path
  →(h<0)/error
  →(⎕fio[11] h)/error
 ⍝ fstat returns:
 ⍝  st_dev st_ino st_mode st_nlink st_uid st_gid st_rdev st_size
 ⍝  st_blksize st_blocks st_atime st_mtime st_ctime
  s←⎕fio[18] h
  m←pkg⍙parse_st_mode 3⊃s
  a←⊂((pkg⍙user_uid=5⊃s)∧2⊃m)∨((pkg⍙user_gid=6⊃s)∧3⊃m)∨(4⊃m)
  z←m,(5⊃s),(6⊃s),(8⊃s),(12⊃s),(13⊃s),a
  →close
 error:
  →(0=⎕nc 'noerror')/report
  →(0=noerror)/report
  z←⎕fio[1] ⍬
  →0
 report: 'pkg⍙file_info ERROR ',(⎕fio[2] (⎕fio[1] ⍬)),' ',path
 close: ⊣ (⎕fio[4] h)
∇

∇z←pkg⍙env name;ea
 ⍝ Lookup name in the environment.
  ea←⎕env name
  z←∊(((,⍳↑⍴ea) 1 ⌷ ea)∊⊂name)/(,⍳↑⍴ea) 2 ⌷ ea
∇

∇z←pkg⍙get_cmdline
 ⍝ Return a list of command-line options and arguments intended for
 ⍝ the application.
  z←(⎕arg ⍳ ⊂'--')↓⎕arg
∇
