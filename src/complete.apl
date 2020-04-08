⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←__ context;⎕io;cw;ic;l;n
 ⍝ Package manager tab-completion for aplwrap. Note that many apl-pkg
 ⍝ functions assume origin-1, but tab-completion may call us in
 ⍝ origin-0.
  ⎕io←1
  cw←pkg⍙split context
  →(0=⍴cw)/default
  ic←(,']') (,')')
  ic←ic, ']pkg' ')erase' ')copy' ')drop' ')in' ')load' ')pcopy' ')pin' 
  →(ic∈⊂↑cw)/ucmd,acmd,pkg,era,6⍴wsf
  →default
 ucmd:
  →('BAD COMMAND'≡∈l←⍎']usercmd')/none
  l←1↓¨↑¨pkg⍙split¨l
  →sort
 acmd:
  l←'check' 'clear' 'continue' 'copy' 'drop' 'dump' 'erase' 'fns' 'help' 'host'
  l←l, 'in' 'libs' 'lib' 'load' 'more' 'nms' 'off' 'ops' 'out' 'pcopy' 'pin'
  l←l, 'reset' 'save' 'sic' 'sinl' 'sis' 'si' 'symbols' 'values' 'vars' 'wsid'
  →sort
 era:
  z←⎕nl 2 3 4
  →0  
 wsf:
  l←↑¨¯1↑¨pkg⍙unpack_path¨pkg⍙ls pkg⍙ws ⍎'0',↑1↓cw
  →sort
 pkg:
  n←'__',(1↓↑cw),∈'_',¨1↓cw
  →(3=⎕nc n)/out
  n←('__',(1↓↑cw),∈'_',¨1↓¯1↓cw),'_⍙'
  →(3=⎕nc n)↓default,out
 out:
  l←⍎n
 sort:
  z←⊃(⊂⍋⊃l)⌷l
  →0
 none:
  z←''
  →0
 default:
  z←⎕nl 2 3 4 5 6
∇

∇z←__pkg
  z←'help' 'ident' 'packages' 'read' 'depends' 'metadata' 'load' 'disable'
  z←z,'enable' 'expunge' 'unload' 'new' 'sh' 'init' 'rescan' 'names' 'apropos'
  z←z,'locate' 'edit' 'refs' 'uses' 'undefs' 'unrefs' 'pager' 'debug' 'unload'
  z←z,'alias' 'unalias' 'stats' 'script'
∇

∇z←__pkg_help
  z←__pkg
∇

∇z←__pkg_read
  z←pkg⍙local_package_names
∇

∇z←__pkg_depends
  z←pkg⍙local_package_names
∇

∇z←__pkg_metadata
  z←pkg⍙local_package_names
∇

∇z←__pkg_load
  z←pkg⍙local_package_names
∇

∇z←__pkg_disable
  z←pkg⍙local_package_names
∇

∇z←__pkg_enable
  z←(⊂,'*'),pkg⍙local_package_names
∇

∇z←__pkg_expunge
  z←pkg⍙local_package_names
∇

∇z←__pkg_unload
  z←pkg⍙local_package_names
∇

∇z←__pkg_sh
  z←pkg⍙local_package_names
∇

∇z←__pkg_init;ls;ad;npd
  z←pkg⍙non_pkg_directories
∇

∇z←__pkg_names
  z←1⊃¨pkg⍙⍙loaded_packages
∇

∇z←__pkg_names_⍙
  z←'fns' 'vars' 'ops'
∇

∇z←__pkg_locate
  z←⊂[2]⎕nl 3 4
∇

∇z←__pkg_locate_⍙
  z←'show'
∇

∇z←__pkg_edit
  z←⊂[2]⎕nl 3 4
∇

∇z←__pkg_refs
  z←⊂[2]⎕nl 3 4
∇

∇z←__pkg_uses
  z←⊂[2]⎕nl 2 3 4 5 6
∇

∇z←__pkg_undefs
  z←⊂[2]⎕nl 2 3 4 5 6
∇

∇z←__pkg_pager
  z←'on' 'off' 'automatic' 'manual'
∇

∇z←__pkg_debug
  z←'on' 'off'
∇

∇z←__pkg_unload
  z←pkg⍙⍙load_requests
∇

∇z←__pkg_alias
  z←⊂[2]⎕nl 3 4
∇

∇z←__pkg_unalias
  z←1↓1⊃¨pkg⍙⍙alias_db
∇
