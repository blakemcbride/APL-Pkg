⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ Here's a really simple user interface. Its main use is to save you
⍝ from having to remember a bunch of commands.

⍝ For displays that should match the actual terminal width...
∇z←pkg⍙⍙wide_display;c
 ⍝ Return the actual terminal width if available; otherwise 200.
  z←200
  →(~pkg⍙have_tput)/0
  c←⍎'0',∊pkg⍙sh 'tput cols'
  →(0=c)/0
  z←c
∇

∇z←pkg_cmd_info
 ⍝ List commands and argument descriptions.
  z←⍬
  z←z, ⊂('help' '[<command>]' '')
  z←z, ⊂('ident' '[platform|configuration|environment]' '')
  z←z, ⊂('packages' '' '')
  z←z, ⊂('read' '<package-name>' '[<document-id>]')
  z←z, ⊂('depends' '<package-name>' '')
  z←z, ⊂('metadata' '<package-name>' '')
  z←z, ⊂('load' '<package-name>' '')
  z←z, ⊂('disable' '[<package-name>]' '')
  z←z, ⊂('enable' '<package-name>|*' '')
  z←z, ⊂('expunge' '<package-name>' '')
  z←z, ⊂('unload' '<package-name>' '')
  z←z, ⊂('reload' '<package-name>' '')
  z←z, ⊂('new' '<package-name>' '')
  z←z, ⊂('sh' '<package-name>' '<shell-command>')
  z←z, ⊂('init' '<directory>' '')
  z←z, ⊂('rescan' '' '')
  z←z, ⊂('names' '<prefix>' '[fns|vars|ops]')
  z←z, ⊂('apropos' '<substring>' '')
  z←z, ⊂('locate' '<function-name>' '[header|show]')
  z←z, ⊂('inspect' '<variable-name>' '')
  z←z, ⊂('alias' '[<function-name>' '<alias-name>]')
  z←z, ⊂('unalias' '<alias-name>' '')
  z←z, ⊂('edit' '<function-name>')
  z←z, ⊂('refs' '<function-name>' '[<depth>]')
  z←z, ⊂('uses' '<object-name>' '')
  z←z, ⊂('undefs' '[<object-name>]' '')
  z←z, ⊂('unrefs' '' '')
  z←z, ⊂('stats' '' '')
  z←z, ⊂('pager' '[on|off|automatic|manual]' '')
  z←z, ⊂('setpw' '' '')
  z←z, ⊂('script' '<file>' '[<wsid>]')
  z←z, ⊂('time' '<expression>' '')
  z←z, ⊂('debug' '[on|off]' '')
∇

∇ucmd_args pkg args;⎕io;_cmd_info;_verbs;verb;action;rc;pm
 ⍝ This is the APL Package Manager's top-level command dispatcher.
  ⎕io←1
  ⍎(0≠⎕nc 'ucmd_args')/'args←1↓ucmd_args'
  ⍎(1=≡args)/'args←⊂args'
  _cmd_info←pkg_cmd_info
  _verbs←1⊃¨_cmd_info
  verb←_verbs pkg⍙prefix_match 1↑args
  action←(_verbs∊verb)/_verbs
  →(0=⍴action)/unmatched
  args←1↓args
  rc←⍎'pkg⍙cmd_',(↑action),' args'
  →rc/0
 usage:
  ⎕←'usage:',((1⊃¨_cmd_info)⍳action)⊃_cmd_info
  →0
 unmatched:
  →(0=⍴⍴args)/show
  ⎕←⊂'Unrecognized command'
  pm←_verbs pkg⍙prefix_matches 1↑args
  →(0=⍴pm)/0
  ⎕←'Possibly:',pm
  →0
 show:
  pkg⍙sink pkg⍙cmd_help ''
∇

⍝ ----------------
⍝ Command Handlers
⍝
⍝ Args:
⍝  string or
⍝  list of strings
⍝ Return value:
⍝  1 if OK
⍝  0 if error
⍝ ----------------

∇z←pkg⍙cmd_help args;text;ht;cmd;sv
 ⍝ Provide a brief help text for all commands or for named command.
  z←1
  →(1=⍴args)/help_1
  →(1<⍴args)/error
  text←⍕'Commands:',⊂_verbs,[1.5]1↓¨_cmd_info
  pkg⍙PAGER text⍪(¯1↑⍴text)↑' Command names and keywords may be abbreviated.'
  →0
 help_1:
  ht←⍬
  ht←ht,⊂('help' 'Show a list of commands or a brief description of command.')
  ht←ht,⊂('ident' 'Identify the package manager by release name.')
  ht←ht,⊂('packages' 'List package name and directory of each local package.')
  ht←ht,⊂('read' 'Read package documentation.')
  ht←ht,⊂('depends' 'List all packages that must be loaded for given package.')
  ht←ht,⊂('metadata' 'List all metadata of given package.')
  ht←ht,⊂('load' 'Load named package and all of its dependent packages.')
  ht←ht,⊂('disable' 'Disable named package. Without name, list all disabled.')
  ht←ht,⊂('enable' 'Enable named package. Specify * to enable all packages.')
  ht←ht,⊂('expunge' 'Expunge only the named package; dependents remain.')
  ht←ht,⊂('unload' 'Expunge the named package and orphaned dependents.')
  ht←ht,⊂('reload' 'Reload only the named package; not its dependents.')
  ht←ht,⊂('new' 'Create a new empty package.')
  ht←ht,⊂('sh' 'Run a shell command in a package directory.')
  ht←ht,⊂('init' 'Add skeletal package files to an existing directory.')
  ht←ht,⊂('rescan' 'Rescan metadata from local repository.')
  ht←ht,⊂('names' 'List all names starting with given prefix.')
  ht←ht,⊂('apropos' 'List all names containing given substring.')
  ht←ht,⊂('locate' 'Tell where named function was loaded by package manager.')
  ht←ht,⊂('inspect' 'Interactively inspect a variable.')
  ht←ht,⊂('alias' 'Create an alias to a function. Without args, list aliases.')
  ht←ht,⊂('unalias' 'Remove a function alias.')
  ht←ht,⊂('edit' 'Edit named function in an external editor; reload file.')
  ht←ht,⊂('refs' 'List external references of defined function or operator.')
  ht←ht,⊂('uses' 'List uses of global object (function, operator or variable).')
  ht←ht,⊂('undefs' 'List all undefined objects. With name, list referers.')
  ht←ht,⊂('unrefs' 'List all unreferenced functions and operators.')
  ht←ht,⊂('stats' 'Show loaded package statistics.')
  ht←ht,⊂('pager' 'Turn pager on or off. Adjust page length.')
  ht←ht,⊂('setpw' 'Set ⎕PW to detected terminal width.')
  ht←ht,⊂('script' 'Execute an APL script advanced using Enter key.')
  ht←ht,⊂('time' 'Execute an APL expression and report execution time.')
  ht←ht,⊂('debug' 'Turn debug on or off.')
  cmd←(1⊃¨ht) pkg⍙prefix_match args
  sv←(1⊃¨ht)∊cmd
  →(∨/sv)/help_2
  ⎕←⊂'No such command'
  →0
 help_2: ⎕←⊂1 2⊃sv/ht
  →0
 error: z←0
∇

∇z←pkg⍙cmd_ident args;opt;k;v;el
 ⍝ Print the identity of the APL Package Manager. Optionally show
 ⍝ platform information.
  z←1
  →(0=⍴args)/ident
  →(1≠⍴args)/error
  opt←'platform' 'configuration' 'environment'
  →((opt pkg⍙prefix_match ↑args)⍷opt)/platform configuration environment
  →error
 ident:
  ⎕←pkg∆manager pkg⍙version
  →0
 platform:
  k←'platform_family' 'os_type' 'os_distribution' 'os_version'
  k←k,'shell_type' 'shell_version' 'apl_type' 'apl_version'
  v←pkg∆platform_family pkg∆os_type pkg∆os_distribution pkg∆os_version
  v←v,pkg∆shell_type pkg∆shell_version pkg∆apl_type pkg∆apl_version
  ⎕←k,⍪v
  →0
 configuration:
  ⎕←⊃¨⊃(~(⊂⍬)⍷1⊃¨pkg⍙⍙config_db)/pkg⍙⍙config_db
  →0
 environment:
  el←('have_akt' pkg⍙have_akt) ('have_tput' pkg⍙have_tput)
  el←el,('in_dvtm' pkg⍙in_dvtm) ('in_wm' pkg⍙in_wm) ('in_embed' pkg⍙in_embed)
  ⎕←⊃el
  →0
 error: z←0
∇

∇z←pkg⍙cmd_sh args;pn;pp;cmd;out;⎕pw
 ⍝ Run a shell command in a package directory.  
  z←1
  →(2>⍴args)/error
  pn←↑args  
  pp←↑pkg⍙lookup_path pn
  →(0=⍴pp)/no_pkg
  cmd←'( umask ',pkg⍙shell_umask,' && cd ',pp,' &&',(∊' ',¨∊¨1↓args),' )'
  out←1↓[2]⊃' ',¨pkg⍙sh cmd
  →(0=⍴out)/no_out  
  ⍎(⎕pw≤1↓⍴out)/'out←⎕pw↑[2]out'
  ⎕←out
  →0
 no_pkg:
  ⎕←⊂'No such package: ',pn
  →0
 no_out:
  ⎕←⊂'No output'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_alias args;name;alias;h1;h2
 ⍝ Create a function alias or list all aliases.
  z←1
  →(~(⍴args)∊0 2)/error
  →(0=⍴args)/list
  name←∊1↑args
  alias←∊1↓args
  →(~pkg⍙valid_alias_name alias)/invalid_alias
  →(~name pkg⍙make_alias alias)/fail
  ⎕←⊂'OK'
  →0
 invalid_alias:
  ⎕←⊂'Invalid alias name'
  →0
 fail:
  →((0 0≡⍴⎕cr name)∧3=⎕nc name)/native
  ⎕←⊂'Not a function or operator defined by a package'
  →0
 native:
  ⎕←⊂'No header available for native function'
  →0
 list:
  →((,⊂⍬ ⍬)≡pkg⍙⍙alias_db)/no_aliases
  h1←'Alias' 'Function'
  h2←'-----' '--------'
  pkg⍙PAGER ⍕h1⍪h2⍪⊃(⊂⍋⊃1⊃¨1↓pkg⍙⍙alias_db)⌷1↓pkg⍙⍙alias_db
  →0
 no_aliases:
  ⎕←⊂'No aliases'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_unalias args;alias
 ⍝ Remove a function alias.
  z←1
  →(1≠⍴args)/error
  alias←∊1↑args
  →(~pkg⍙remove_alias alias)/not_alias
  ⎕←⊂'OK'
  →0
 not_alias:
  ⎕←⊂'Not an alias'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_edit args;fn;info;labels;⎕pw
 ⍝ Edit a function in an external editor
  z←1
  →(1≠⍴args)/error
  fn←∊1↑args
  →(~∨/3 4∊⎕nc fn)/class
  info←pkg⍙fdef_info fn
  →(⍬≡info)/none
  pkg⍙sink pkg⍙edit_file info
  →0
 class:
  ⎕←⊂'Not a defined function or operator'
  →0
 none:
  ⎕←⊂'No file information'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_pager args;match;mask;lencmds;inp
 ⍝ Turn pager on or off. Set page length.
  z←1
  →(0=⍴args)/show
  →(1≠⍴args)/error
  match←'on' 'On' 'ON' 'off' 'Off' 'OFF'
  mask←1 1 1 0 0 0
  →(∨/((2,⍴mask)⍴mask,⌽mask)∧[2](⊂,⊃args)≡¨match)/on,off
  →((lencmds pkg⍙prefix_match ↑args)⍷lencmds←'manual' 'automatic')/man,auto
  →error
 cancelled:
  ⎕←' Cancelled'  
 show:
  →(0=pkg⍙pager_lines)/show_off
  ⎕←' ',(⍕pkg⍙pager_lines),' lines'
  →0
 show_off:
  ⎕←' Pager is off'
  →0  
 on: 'pkg_pager_enable' pkg⍙constant 1
  →show
 off: 'pkg_pager_enable' pkg⍙constant 0
  →show
 range:
  ⎕←' Must be in range ','55 to 55'⍕pkg⍙pager_length_bounds
  ⍞←' Press Return '
  pkg⍙sink ⍞
 man:
  ⎕←⍪⌽1↓⍳¯1↑pkg⍙pager_length_bounds
  ⍞←' What is the topmost visible number? '
  inp←(' '≠inp)/inp←⍞
  →(~∧/inp∊'0123456789')/range
  →(0=⍴inp)/cancelled
  inp←⍎inp
  →(0<×/×pkg⍙pager_length_bounds-inp)/range
  'pkg_pager_override' pkg⍙constant inp
  →show
  →0
 auto:
  'pkg_pager_override' pkg⍙constant ⍬
  →show
  →0  
 error: z←0
∇

∇z←pkg⍙cmd_setpw args
 ⍝ Conform ⎕PW to detected terminal width.
  z←1
  →(0≠⍴args)/error
  ⎕pw←⍎pkg⍙tput 'cols'
  ⎕←'⎕PW is now' ⎕pw
  →0
 error: z←0
∇

∇z←pkg⍙cmd_script args;⎕pr;name;ws;wsid;wspath;path;h;r;l
 ⍝ Execute APL script, advanced using Enter key.
  z←1
  →(∧/1 2≠⍴args)/error
  name←∊1↑args
  ws←0
  →(1=⍴args)/go
  wsid←2⊃args
  →(~∧/wsid∊'0123456789')/error
  ws←⍎wsid
 go:
  wspath←pkg⍙ws ws
  →(0=⍴wspath)/no_ws
  path←pkg⍙concatenate_paths wspath name
  h←⎕fio[3] path
  →(h<0)/no_file
  ⎕pr←''
  ⎕←⊂'Press Enter to recall the next line of the script.'
  ⎕←⊂'To stop, replace script expression or command with ''→''.'
 more: →(⎕fio[11] h)/file_error
  pkg⍙sink ⍞
  →(⎕fio[10] h)/end
  r←⎕fio[8] h
  →(32≤¯1↑r)/encode
  r←¯1↓r
 encode: l←pkg⍙utf_to_ucs r
  l←(~∧\' '=l)/l
  →(0=⍴l)/more
  ⍞←'      ',l
  ⍎⍞
  →more
 file_error: ⎕←⊂'ERROR: ',⎕fio[2] (⎕fio[1] ⍬)
  →(h<0)/0
 end:
  ⎕←⊂'Script "',name,'" is finished.'
  pkg⍙sink (⎕fio[4] h)
  →0
 no_file:
  ⎕←⊂'No file ',name
  →0
 no_ws:
  ⎕←⊂'No WS ',wsid
  →0
 error: z←0
∇

∇z←pkg⍙cmd_debug args;match;mask
 ⍝ Turn debug on or off.
  z←1
  →(0=⍴args)/show
  →(1≠⍴args)/error
  match←'on' 'On' 'ON' 'off' 'Off' 'OFF'
  mask←1 1 1 0 0 0
  →(∨/((2,⍴mask)⍴mask,⌽mask)∧[2](⊂,⊃args)≡¨match)/on,off
  →error
 show:
  →(1≡pkg_debug)/is_on
  ⎕←⊂'Off: Load-time errors will return to APL''s top level'
  →0
 is_on:
  ⎕←⊂'On: Load-time errors will suspend APL at the point of error'
  →0
 on: 'pkg_debug' pkg⍙constant 1
  →show
 off: 'pkg_debug' pkg⍙constant 0
  →show
 error: z←0
∇
