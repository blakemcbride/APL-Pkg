⍝ Copyright (c) 2015 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙orphaned_packages;rpd;lpv;pnl
 ⍝ Run this after expunging a package. Returns a list
 ⍝ packages that are no longer needed.
 ⍝ Any packages that are loaded but not requested or required
 ⍝ are orphans.
  (rpd lpv pnl)←pkg⍙⍙required_loaded
  z←(lpv∧~rpd)/pnl
∇

∇z←pkg⍙expunge_package pn;pp;me;pre
 ⍝ Expunge named package. Dependencies are not considered.
 ⍝ Return ⍬ on success; otherwise return an error text.
  z←⍬
  pp←↑pkg⍙lookup_path pn
  →(0=⍴pp)/expunge_1
  me←pkg⍙⍙local_metadata_entry pp
  pre←2⊃↑'package_prefix' pkg⍙lookup_metadata_entry me
  →((0=⍴pre),('pkg'≡pre))/expunge_2,expunge_3
  pkg⍙sink ⎕ex ⊃pkg⍙names pre
  pkg⍙⍙loaded_packages←(~(⊂pre)⍷1⊃¨pkg⍙⍙loaded_packages)/pkg⍙⍙loaded_packages
  →0
 expunge_1: 
  z←'No such package'
  →0
 expunge_2: 
  z←'Package doesn''t have package_prefix metadata'
  →0
 expunge_3:
  z←'The package manager can''t expunge itself'
∇

∇z←pkg⍙expunge_package_verbose pn;em
 ⍝ Print name of package as it is unloaded. Return 1 on
 ⍝ success; otherwise 0.
  z←1
  ⎕←⊂'UNLOADING ',pn
  em←pkg⍙expunge_package pn
  →(⍬≡em)/0
  ⎕←⊂em
  z←0
∇
