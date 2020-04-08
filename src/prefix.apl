⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙valid_prefix p
  z←((1↑p)∊pkg⍙alp)∧∧/(1↓p)∊pkg⍙alp,pkg⍙dig
∇

∇z←p pkg⍙filter_prefixes nl;m
 ⍝ Filter name list to contain only names which match prefix.
  m←(⊂p) pkg⍙match_prefix¨nl
  z←m/nl
∇

∇z←p pkg⍙match_prefix n;b
 ⍝ True if either prefix is same as name or prefix followed by a
 ⍝ break character matches prefix of name.
  b←'∆⍙¯_'
  ⍎(1=≡p)/'p←⊂p'
  ⍎(1=≡n)/'n←⊂n'
  z←((,p)≡n)∨(p≡n)∨((⊂(1+⍴↑p)⍴↑n)∊p,¨b)
∇

∇_z←_c pkg⍙names _p;_n;_m
 ⍝ Return a list of names having prefix _p. If _c is present, it's
 ⍝ used as the class of names to be returned.
  ⍎(0=⎕nc '_c')/'_c←2 3 4'
  _n←⎕nl _c
  _m←∧/(⍴∊_p)↑[2]((1↓⍴_n)↑_p)=[2]_n
  ⍎(0=∨/_m)/'_z←⍬ ◊ →0'
  _z←_p pkg⍙filter_prefixes pkg⍙⍙strip_trailing_blanks¨⊂[2]_m⌿_n
∇
