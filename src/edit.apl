⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ Functions to select and invoke external editors.

⍝ Here are definitions for terminal, shell and editor.
⍝ Requirements:
⍝  - terminal must accept -e `command` option.
⍝  - shell must accept -c `command` option.
⍝  - editor must be able to accept input via stdin.
⍝  - editor must accept +<lineno> option.
⍝  - terminal and editor must support UTF-8.
⍝  - akt must be on $PATH.
⍝ Additionally, terminal may accept an XEmbed option.
'pkg⍙terminal' pkg⍙constant 'terminal' pkg⍙get_config 'xterm'
'pkg⍙shell' pkg⍙constant 'shell' pkg⍙get_config 'sh'
'pkg⍙editor' pkg⍙constant 'editor' pkg⍙get_config 'vi'
'pkg⍙embed_option' pkg⍙constant 'embed_option' pkg⍙get_config '-into'
'pkg⍙title_option' pkg⍙constant 'title_option' pkg⍙get_config '-T'
'pkg⍙embed_env_var' pkg⍙constant 'embed_env_var' pkg⍙get_config 'XEMBED'
⍝ NOTE: vi is assumed to alias to vim. To the best of my knowledge, the
⍝ original vi was never made Unicode-aware.

∇z←pkg⍙edit_file where;path;line;sig;finfo;mtime;pkg⍙loading_prefix
 ⍝ Edit a function's on-file definition using a configured editor, given a
 ⍝ list of (path line function_name). If the file's modification time
 ⍝ changes upon exiting the editor, reload the file.
  z←1
  (path line sig)←where
  finfo←1 pkg⍙file_info path
  →(0=⍴finfo)/file_fail
  mtime←7⊃finfo
  pkg⍙sink pkg⍙sh line pkg⍙edit_cmd path
  finfo←1 pkg⍙file_info path
  →(0=⍴finfo)/file_fail
  →(mtime=7⊃finfo)/0
  pkg⍙loading_prefix←pkg⍙get_prefix ↑pkg⍙header_info pkg⍙parse sig
  →('pkg'≡pkg⍙loading_prefix)/ignored
  ⎕←⊂'Reloading ',path
  pkg⍙sink pkg⍙⍙apl_check pkg⍙import_apl path
  →0
 file_fail:
  ⎕←⊂'Couldn''t read file info'
  z←0
 ignored:
  ⎕←⊂'Edited file ',path
  ⎕←⊂'The package manager doesn''t reload its own edited files.'
  ⎕←⊂'Restart your APL environment or )LOAD pkg to pick up changes.'
∇

∇z←line pkg⍙edit_cmd path;sync;cmd
 ⍝ Generate external editor depending upon environment.
  →(~pkg⍙have_akt)/no_akt
  →(pkg⍙in_dvtm pkg⍙in_wm)/dvtm x11
  z←'echo "Can''t edit in this environment. Consider running dvtm."'
  →0
 dvtm: (sync cmd)←line pkg⍙edit_cmd_dvtm path
  →finish
 x11: (sync cmd)←line pkg⍙edit_cmd_X path
  →finish
 no_akt:
  z←'echo "akt is not on $PATH"'
  →0
 finish:
  z←cmd
  ⎕←(⎕io+sync)⌷'File is opened for editing' 'Exit editor to continue'
∇

∇z←line pkg⍙edit_cmd_dvtm path;cmd
 ⍝ Build a command line to edit a file in a dvtm window.
  cmd←∊'create "''akt -z ' pkg⍙editor ' +' (⍕line) ' ' path '''"'
  z←0 ('echo ',cmd,' >',pkg⍙env 'DVTM_CMD_FIFO')
∇

∇z←line pkg⍙edit_cmd_X path;cmd
 ⍝ Build a command line to edit a file in an external X terminal.
  cmd←pkg⍙terminal ' ' pkg⍙title_option ' '']pkg edit ' path ''' '
  cmd←cmd,pkg⍙embed ' -e '
  cmd←cmd,pkg⍙shell ' -c '
  cmd←cmd,'''akt -z ' pkg⍙editor ' +' (⍕line) ' ' path ''''
  z←1 (∊cmd)
∇

∇z←pkg⍙embed
 ⍝ Return proper embed option for terminal.
  z←''
  →(''≡pkg⍙env pkg⍙embed_env_var)/0
  z←∊pkg⍙embed_option ' $',pkg⍙embed_env_var
∇

∇z←pkg⍙in_embed
 ⍝ Return true if running in an Xembed container.
  z←0≠⍴pkg⍙env pkg⍙embed_env_var
∇
