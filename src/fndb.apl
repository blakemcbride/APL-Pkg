⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙fdef_info name;sigs;vbv;ln;pos;bv;sp;ep
 ⍝ Return function definition info for name. The function definition
 ⍝ info is a list of source file path, source file line number and
 ⍝ function signature. Return ⍬ if name is not matched in function
 ⍝ location database.
  z←⍬
  sigs←' ',¨' ',⍨¨3⊃¨pkg⍙⍙fn_location_db
  vbv←(⊂,name)⍷¨sigs
  ln←⍴,name
  bv←×pos←+/¨vbv×¨⍳¨⍴¨vbv
  sp←1⌈(¯1+pos)⌊⍴¨sigs
  ep←(ln+pos)⌊⍴¨sigs
  bv←bv∧((ep⌷¨sigs)∊' [)')∧((sp⌷¨sigs)∊' ←)')
  →((1<+/bv)∨(~∨/bv))/0
  z←,⊃bv/pkg⍙⍙fn_location_db
∇
