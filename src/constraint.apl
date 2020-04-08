⍝ Copyright (c) 2016 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

'pkg⍙⍙constraint_tags' pkg⍙constant '_<!'

∇z←pkg⍙parse_constraints txt;p;l;cl;ce;cc;pv;cv
 ⍝ Parse txt and return its list of package version constraints.
  p←1⌽pkg⍙⍙constraint_tags⍳txt
  l←p⊂txt
  cl←⍬
 more: →(0=⍴l)/finish
  ce←↑l
  l←1↓l
  cc←↑ce
  →(~cc∊pkg⍙⍙constraint_tags)/more
  pv←pkg⍙parse_version 1↓ce
  →(⍬≡pv)/more
  cv←pkg⍙encode_version pv
  cl←cl,⊂cc,cv
  →more
 finish: z←cl
∇

∇z←pkg⍙mix_constraints cl;h;l;x;ce;v
 ⍝ Combine constraints in list. Minimize the `<` constraints, maximize the `_`
 ⍝ constraints, and collect the `!` constraints. Return a list of two lists: the
 ⍝ low and high bounds and the exclusions.
  h←pkg⍙⍙max_encoded_version
  l←0
  x←⍬
 more:
  →(0=⍴cl)/finish
  ce←↑cl
  cl←1↓cl
  v←1↓ce
  →(pkg⍙⍙constraint_tags=↑ce)/base,less,exclude
  →more
 base:
  →(v≤l)/more
  l←v
  →more
 less:
  →(v≥h)/more
  h←v
  →more
 exclude:
  x←x,v
  →more
 finish:
  z←(⊂l,h),⊂x
∇

∇z←versions pkg⍙constrain_versions mix;l;h;x
 ⍝ Return all versions selected by mix, where mix is a list of the `_` and `>`
 ⍝ constraints and a list of the `!` constraints.
  l←1↑∊1↑mix
  h←¯1↑∊1↑mix
  x←∊¯1↑mix
  z←x~⍨((versions≥l)∧(versions<h))/versions
∇
