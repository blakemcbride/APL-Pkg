⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙abs_path components
 ⍝ Turn pathname components into an absolute filesystem path.
  ⍎(1=≡components)/'components←⊂components'
  z←¯1↓⊃,/⊃¨,pkg⍙⍙path_separator,[1.5]components,⊂⍬
∇

∇z←pkg⍙rel_path components
 ⍝ Turn pathname components into a relative filesystem path.
  ⍎(1=≡components)/'components←⊂components'
  z←1↓¯1↓⊃,/⊃¨,pkg⍙⍙path_separator,[1.5]components,⊂⍬
∇

∇z←pkg⍙restricted_path path;ps;sl;pp;pl;rvs;rv
 ⍝ True if path contains no spaces or parent components and no leading
 ⍝ path separator.
  z←1
  path←∊path
  ps←pkg⍙⍙path_separator
  sl←⍴,ps
  pp←pkg⍙⍙path_parent
  pl←⍴,pp
  rvs←(-⎕io)+⍳sl+pl
  rv←(-⎕io)+⍳pl
  →(∨/∧⌿rvs⌽(ps,pp)∘.=path,(sl+pl)⍴' ')/0
  →(∨/∧⌿rvs⌽(pp,ps)∘.=path,(sl+pl)⍴' ')/0
  →((pl=⍴path)∧(∨/∧⌿rv⌽pp∘.=path,pl⍴' '))/0
  →((∨/' '=path)∨(ps=↑path))/0
  z←0
∇ 

∇z←m pkg⍙_unpack_path_helper v
 ⍝ Helper for pkg⍙unpack_path.
  z←m/v
∇

∇z←pkg⍙unpack_path path;v;m
 ⍝ Unpack path components into a list.
  m←~pkg⍙⍙path_separator=¨v←(pkg⍙⍙path_separator⍳path)⊂path
  z←m pkg⍙_unpack_path_helper¨v
∇
