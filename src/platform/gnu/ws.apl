⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙ws num;ll;cl;wl
 ⍝ Given a workspace number, return its path.
  wl←(⊃(∨/¨(⊂'0123456789')∈¨↑¨cl)/cl←(4=∈⍴¨ll)/ll←pkg⍙split¨⍎')LIBS')[;1 3]
  z←,(num=⍎¨(⍳↑⍴wl) 1⌷wl)⌿wl
  →(0=⍴z)/0
  z←∈1↓z
∇
