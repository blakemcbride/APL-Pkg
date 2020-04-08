⍝! Bootstrap the APL Package Manager using GNU APL on Linux.

⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ Except for names prefixed pkg⍙BOOT_, definitions in this file should
⍝ be assumed used by the rest of the package manager.

⍝ Establish the environmental value(s) upon which we depend.
⎕io←1

∇z←where pkg⍙fio_error what;etxt
 ⍝ Report file I/O error.
  etxt←' ERROR (',where,'): ',(⎕fio[2] (⎕fio[1] ⍬)),':'
  ⎕←⊃etxt ('       ',what)
∇

⍝ These will be redefined later as constant functions.
⊣ ⎕ex 'pkg⍙⍙path_separator'
pkg⍙⍙path_separator←'/'
⊣ ⎕ex 'pkg⍙⍙newline'
pkg⍙⍙newline←⎕av[10+⎕io]

∇z←pkg⍙concatenate_paths paths
 ⍝ Concatenate a list of paths.
  z←1↓¯1↓⊃,/⊃¨,pkg⍙⍙path_separator,[1.5]paths,⊂⍬
∇

∇z←pkg⍙utf_to_ucs bytes;c;b0;l;m;cp
 ⍝ Convert UTF-1 unsigned byte sequence to a Unicode string.
 ⍝ NOTE: ⎕ucs is specific to IBM APL and GNU APL. It converts
 ⍝ a vector of code points to a Unicode string.
  z←⍬
  c←1
 more: →(c>⍴bytes)/0
  b0←bytes[c]
  l←+/b0≥0 192 224 240 248 252
  m←l⊃(128) (32 64) (16 64 64) (8 64 64 64) (4 64 64 64 64) (2 64 64 64 64 64)
  cp←m⊥m|bytes[¯1+c+⍳l]
  z←z,⎕ucs cp
  c←c+l
  →more
∇

∇z←op pkg⍙false v
 ⍝ Always return false.
  z←0
∇

∇z←pkg⍙error_extract em;l1;l2
 ⍝ Given a ⎕EM-formatted array, return a string containing the content
 ⍝ of the first and second rows after removing extraneous blanks.
  l1←,1 0 0⌿em
  l2←,0 1 0⌿em
  z←((~⌽∧\⌽' '=l1)/l1),5↓((~⌽∧\⌽' '=l2)/l2)
∇

⍝ Debug flag.
⍝ This will be redefined later as a constant function.
⍝
⍝ Set to 1, this will cause the loader to suspend rather than print
⍝ a message and return to toplevel. This is appropriate for loading
⍝ the package manager itself, which should not error during loading.
⍝ In the case that loading fails, you may enter the following APL
⍝ expression to identify the file and source line which caused the
⍝ error:
⍝       path lc
⊣ ⎕ex 'pkg_debug'
pkg_debug←1

⍝ Function location database. The lookup is defined in src/fndb.apl .
pkg⍙⍙fn_location_db←⍬

∇pkg⍙fdef_invalidate_file path
 ⍝ Invalidate all of a file's entries in the function location
 ⍝ database. We call this before reloading a file so as to not have
 ⍝ duplicated or outdated entries in the database.
  →(0=⍴pkg⍙⍙fn_location_db)/0
  pkg⍙⍙fn_location_db←(~(⊂path)≡¨1⊃¨pkg⍙⍙fn_location_db)/pkg⍙⍙fn_location_db
∇

∇pkg⍙fdef_insert info
 ⍝ Insert function definition info into the function location
 ⍝ database. The info is a list of path, line and signature.
  pkg⍙⍙fn_location_db←pkg⍙⍙fn_location_db,info
∇

∇z←(check_fn pkg⍙import_apl) path;defn;expr;h;r;lc;l;lf;d;fnl;nd;ec;et;er;ne;sm
 ⍝ Read a Unicode file and execute it as APL (expressions and
 ⍝ definitions). Silently ignore commands, comments and empty lines.
 ⍝ Return a vector containing the count of definitions and the count
 ⍝ of top-level expressions. Return ⍬ upon error.
 ⍝
 ⍝ NOTE 1: Comments and empty lines are preserved within function
 ⍝ definitions.
 ⍝
 ⍝ NOTE 2: Implementation-specific commands (i.e. commands beginning
 ⍝ with `]` rather than `)`) are permitted. In the future, the set of
 ⍝ allowed ]-commands may be restricted.
  z←0 0
  defn←expr←⍬
  lc←nd←ne←0
  h←⎕fio[3] path
  →(h<0)/error
  pkg⍙fdef_invalidate_file path
 more: →(⎕fio[11] h)/error
  →(⎕fio[10] h)/end
  r←⎕fio[8] h
  →(32≤¯1↑r)/encode
  r←¯1↓r
 encode: l←pkg⍙utf_to_ucs r
  lc←lc+1
  l←((~∧\' '=l)∧(~⌽∧\⌽' '=l))/l
  →((~defn≡⍬)∧(0=⍴l))/bel
  →(0=⍴l)/more
  →((defn≡⍬)∧('⍝'=↑l)∨('#'=1↑l)∨(')'=1↑l))/more
  →((defn≡⍬)∧(']'=1↑l))/simple_exec
  →((defn≡⍬)∧('∇'≠1↑l)∧('⍫'≠1↑l))/exec
  →((~defn≡⍬)∧(('∇'=1↑l)∨('⍫'=1↑l)))/fix
  →(~defn≡⍬)/body
  lf←'⍫'=↑l
  defn←⊂1↓l
  →more
 bel: l←''
 body: defn←defn,⊂l
  →more
 fix:
  fnl←(~∨\';'=1⊃defn)/1⊃defn
  →(1 2=1 check_fn defn)/defn_namespace,defn_assign
  lf←lf∨'⍫'=↑l
  d←lf (path,':',⍕lc-⍴defn) ⎕fx defn
  →((0⍴0)≡0⍴d)/defn_error
  pkg⍙fdef_insert ⊂path (lc-⍴defn) fnl
  nd←nd+1
  defn←⍬
  →more
 exec:
  →(2 check_fn l)/assign_error
  →pkg_debug/simple_exec
  (ec et er)←⎕ec l
  →(ec=0)/expr_error
  →(ec∊4 5)/branch_error
  ⍎(ec=1)/'⎕←er'
  →next
 simple_exec: ⍎l
 next:
  ne←ne+1
  →more
 defn_error:
  sm←'ERROR IN ',fnl,' AT FN LINE ',(⍕d),', SRC LINE ',⍕lc-⍴defn
  →stop
 defn_namespace:
  sm←'FUNCTION "',fnl,'" IN WRONG NAMESPACE AT SRC LINE ',⍕lc-⍴defn
  →stop
 defn_assign:
  sm←'FUNCTION "',fnl,'" AT SRC LINE ',(⍕lc-⍴defn),': DISALLOWED ASSIGNMENT'
  →stop2
 assign_error:
  sm←'DISALLOWED ASSIGNMENT AT SRC LINE ',⍕lc-⍴defn
  →stop2
 expr_error: sm←(pkg⍙error_extract er),' AT SRC LINE ',⍕lc
  →stop
 branch_error: sm←'BRANCH NOT ALLOWED AT SRC LINE ',⍕lc
  →stop
 end: ⊣ (⎕fio[4] h)
  z←nd ne
  →0
 stop:
  ⎕←⊃'LOAD FAILED' ('IN ',path) sm
  →clean
 stop2:
  ⎕←⊃'LOAD FAILED' ('IN ',path) sm
  ⎕←'ONE OF:'
  ⎕←' ASSIGNMENT TO SYSTEM VARIABLE'
  ⎕←' ASSIGNMENT TO WRONG NAMESPACE'
  →clean
 error:
  'pkg⍙import_apl' pkg⍙fio_error path
  →(h<0)/fail
  →close
 clean:
  →(3≠⎕nc 'pkg⍙names')/close
  ⊣ ⎕ex ⊃pkg⍙names pkg⍙loading_prefix
  ⎕←'ERASED ALL NAMES HAVING PREFIX ',pkg⍙loading_prefix
 close:
  ⊣ (⎕fio[4] h)
 fail:
  z←⍬
∇

∇z←pkg⍙read_key_value_file path;h;r;l
 ⍝ Read the key/value file on path. Remove comment lines (beginning
 ⍝ with #) and empty lines. (Note that trailing comments are not
 ⍝ allowed.) Remove leading and trailing whitespace from remaining
 ⍝ lines. Return a list of lines.
  z←⍬
  h←⎕fio[3] path
  →(h<0)/error
 more: →(⎕fio[11] h)/error
  →(⎕fio[10] h)/end
  r←⎕fio[8] h
  →(32≤¯1↑r)/encode
  r←¯1↓r
 encode: l←⎕av[⎕io+r]
  l←((~∧\' '=l)∧(~⌽∧\⌽' '=l))/l
  →(('#'=↑l)∨(0=⍴l))/more
  z←z,⊂l
  →more
 error:
  'pkg⍙read_key_value_file' pkg⍙fio_error path
  →(h<0)/0
 end:
  ⊣ (⎕fio[4] h)
∇

∇z←pkg⍙parse_metadata text;n;c;l;k;v
 ⍝ Parse the package metadata into a list of key/value pairs.
  z←k←v←⍬
  n←↑⍴text
  c←1
 more: →(c>n)/end
  l←c⊃text
  →(~(l⍳':')=¯1+l⍳' ')/cont
  →(⍬≡k)/parse
  z←z,⊂((,k) (,v))
 parse:
  k←(∧\':'≠l)/l
  v←(~∧\' '=v)/v←(∨\' '=l)/l
  →next
 cont: v←v,pkg⍙⍙newline,l
 next: c←c+1
  →more
 end:
  z←z,⊂((,k) (,v))
∇

∇z←pkg⍙user_home
 ⍝ Return a path to the current user's home directory.
  z←2⊃,⎕env 'HOME'
∇

⍝ The package manager's optional configuration file is on this path.
⍝ This will be redefined later as a constant function.
⊣ ⎕ex 'pkg⍙config_path'
pkg⍙config_path←pkg⍙concatenate_paths pkg⍙user_home '.apl-pkg'

∇z←pkg⍙BOOT_REPOSITORY;h;kvl;m
 ⍝ Return a path to the local repository.
  →(¯1=h←⎕fio[3] pkg⍙config_path)/default
  ⊣ (⎕fio[4] h)
  kvl←(⊂⍬ ⍬),pkg⍙parse_metadata pkg⍙read_key_value_file pkg⍙config_path
  m←(⊂'packages_directory')≡¨↑¨kvl
  →(~∨/m)/default
  z←∊1 2⊃m/kvl
  →0
 default:
  z←pkg⍙concatenate_paths pkg⍙user_home 'workspaces'
∇

⍝ Don't change the package manager's directory name!
pkg⍙BOOT_ROOT←'apl-pkg'

⍝ Track success of boot loader.
pkg⍙BOOT_FAILED←0

∇pkg⍙BOOT_LOAD path_components;fpc;rc
 ⍝ Load APL file specified by components of path.
  →pkg⍙BOOT_FAILED/0
  ⍎(1=≡path_components)/'path_components←⊂path_components'
  fpc←(⊂pkg⍙BOOT_REPOSITORY),(⊂pkg⍙BOOT_ROOT),path_components
  rc←pkg⍙false pkg⍙import_apl pkg⍙concatenate_paths fpc
  pkg⍙BOOT_FAILED←pkg⍙BOOT_FAILED∨⍬≡rc
∇

⍝ Load the package manager.
pkg⍙BOOT_LOAD 'src' 'LOADER.apl'

⍝ Dispose of the boot-time definitions.
⊣ ⎕ex¨'pkg⍙BOOT_REPOSITORY' 'pkg⍙BOOT_ROOT' 'pkg⍙BOOT_LOAD'

⍝ Report boot failure.
⍎pkg⍙BOOT_FAILED/'⎕←'' APL Package Manager: BOOT FAILED - CHECK INSTALLATION'''

⍝ Define a ]usercmd to simplify interaction with the package manager.
⍎(~pkg⍙BOOT_FAILED)/']usercmd ]pkg pkg 1'

⍝ Process the package manager's command-line options.
⍎(~pkg⍙BOOT_FAILED)/'pkg⍙process_cmdline pkg⍙get_cmdline'

⍝ Final cleanup.
⊣ ⎕ex 'pkg⍙BOOT_FAILED'
