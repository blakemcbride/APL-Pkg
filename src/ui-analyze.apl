⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙cmd_apropos args;n;k;h1;h2;⎕pw
 ⍝ Display all workspace names for given package prefix.
  z←1
  →(0=⍴args)/error
  n←(∨/¨(⊂↑args)⋸¨n)/n←pkg⍙⍙strip_trailing_blanks¨⊂[2]⎕nl 2 3 4
  →(0=⍴n)/none
  k←⎕nc¨n
  n←(0≠k)/n
  k←(0≠k)/k
  h1←('Kind' 'Name')
  h2←('----' '----')
  ⎕pw←pkg⍙⍙wide_display
  pkg⍙PAGER ⍕h1⍪h2⍪(⊂[2](5 3⍴'???LBLVARFUNOPR')[k+⎕io;]),[1.5]n
  →0
 none:
  ⎕←⊂'None'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_inspect args;vn
 ⍝ Interactively inspect a variable.
  z←1
  →(1≠⍴args)/error
  vn←∊1↑args
  →(2≠⎕nc vn)/class
  pkg⍙inspect vn
  →0
 class:
  ⎕←⊂'Not a defined variable'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_locate args;fn;info;tophdr;labels;opts;report;⎕pw
 ⍝ Tell where function was defined.
  z←1
  →(∧/1 2≠⍴args)/error
  fn←∊1↑args
  →(~∨/3 4∊⎕nc fn)/class
  info←pkg⍙fdef_info fn
  →(⍬≢info)/build_header
  tophdr←' No file information'
  →display
 build_header:
  labels←'File path:' 'Line number:' 'Signature:'
  tophdr←⍕labels,[2]⍪∊¨info
 display:
  →((⍬≡info)∧0 0≡⍴⎕cr fn)/native_or_locked
  →(2≠⍴args)/info_only
  →((opts pkg⍙prefix_match 1↓args)⍷opts←'show' 'header')/show,header
  →error
 show:
  report←⊃(⊂[2](¯2↑1,⍴tophdr)⍴tophdr)⍪⊂[2]pkg⍙pprint fn
  →finish
 header:
  report←⊃(⊂[2](¯2↑1,⍴tophdr)⍴tophdr)⍪⊂[2]pkg⍙pprint_header fn
 finish:
  ⎕pw←pkg⍙⍙wide_display
  pkg⍙PAGER report
  →0
 native_or_locked:
  tophdr←tophdr,'; native or locked function'
 info_only:
  ⎕←tophdr
  →0
 class:
  ⎕←⊂'Not a defined function or operator'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_refs args;name;ds
 ⍝ List external references of a defined function or operator.
  z←1
  →(∧/1 2≠⍴args)/error
  name←∊1↑args
  →(~∨/3 4∊⎕nc name)/class
  ds←'0'
  →(1=⍴args)/go
  ds←2⊃args
  →(~∧/ds∊'0123456789')/error  
 go:
  pkg⍙PAGER (⍎ds) pkg⍙ref_tree name
  →0
 class:
  ⎕←⊂'Not a defined function or operator'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_uses args;name;callers
 ⍝ List uses of global object.
  z←1
  →(1≠⍴args)/error
  name←∊1↑args
  →(~∨/2 3 4∊⎕nc name)/class
  callers←pkg⍙who_refs name
  →(0=⍴callers)/none
  pkg⍙PAGER ⍪callers
  →0
 class:
  ⎕←⊂'No such object'
  →0
 none:
  ⎕←⊂'No callers'
  →0  
 error: z←0
∇

∇z←pkg⍙cmd_undefs args;l;name
 ⍝ List all undefined objects.
  z←1
  →(∧/0 1≠⍴args)/error
  →(1=⍴args)/finder
  l←pkg⍙all_fn_refs~pkg⍙all_fns,pkg⍙all_vars
  l←(~(∊1↑¨l)∊'⎕⍞')/l
  pkg⍙PAGER ⍪(⊂⍋⊃l)⌷l
  →0
 finder:
  name←∊1↑args
  pkg⍙PAGER ⍪pkg⍙who_refs name
  →0
 error: z←0
∇

∇z←pkg⍙cmd_unrefs args;l
 ⍝ List all unreferenced functions and operators.
  z←1
  →(0≠⍴args)/error
  pkg⍙PAGER ⍪(⊂⍋⊃l)⌷l←pkg⍙all_fns~pkg⍙all_fn_refs
  →0
 error: z←0
∇

∇z←pkg⍙cmd_stats args;h1;h2;tbl;pl;pv;pp;vv;vc;fc;oc
 ⍝ Show loaded package statistics.
  z←1
  →(0≠⍴args)/error
  h1←'Prefix' 'Version' 'Functions' 'Variables' 'Operators'
  h2←'------' '-------' '---------' '---------' '---------'
  tbl←⍬
  pl←,1⊃¨pkg⍙⍙loaded_packages
  pv←,2⊃¨pkg⍙⍙loaded_packages
 next:
  →(0=⍴pl)/finish
  pp←1⊃pl
  pl←1↓pl
  vv←1⊃pv
  pv←1↓pv
  →(0=⍴pp)/next
  vc←+/1⌷[2]pp⍷⎕nl 2
  fc←+/1⌷[2]pp⍷⎕nl 3
  oc←+/1⌷[2]pp⍷⎕nl 4
  tbl←tbl,⊂pp vv fc vc oc
  →next
 finish:
  pkg⍙PAGER ⍕h1⍪h2⍪⊃(⊂⍋⊃1↑¨tbl)⌷tbl
  →0
 error: z←0
∇

∇z←pkg⍙cmd_time args
 ⍝ Execute an expression and report elapsed time.
  →(0=⍴args)/error
  z←pkg⍙time ⍕args
 →0
 error: z←0
∇
