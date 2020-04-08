⍝ Copyright (c) 2016 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←prompt pkg⍙ask_index size;⎕pr;in
 ⍝ Prompt for an index ranging over size, accounting for ⎕IO.
  ⍎(0=⎕nc 'prompt')/'prompt←'' index? '''
  ⎕pr←' '
 again:
  ⍞←prompt
  in←pkg⍙⍙trim_blanks ⍞
  →(~∧/in∊pkg⍙dig)/not_digits
  z←⍎in
  →((z<⎕io)∨(z>size+⎕io-1))/range
  →0
 not_digits:
  ⎕←⊂'enter a number'
  →again
 range:
  ⎕←⊂'not in range'
  →again
∇

∇z←pkg⍙⍙combine_picks s;v;p;t
 ⍝ Given a string containing ⊃ and ⌷ with indices, where each
 ⍝ ⊃ has a single index, combine consecutive ⊃ and consolidate
 ⍝ their indices. The ⌷ are passed unaltered.
  z←''
  v←''
  p←⌽pkg⍙parse s
 next:
  →(0=⍴p)/0
  t←∊1↑p
  p←1↓p
  →(t≡,'⊃')/pick
  z←t,z
  →next
 pick:
  →(0=⍴p)/0
  t←∊1↑p
  p←1↓p
  →(t≡,'⌷')/combine
  →(t≡,'⊃')/pick
  v←v,' ',t
  →(0≠⍴p)/pick
 combine:
  z←(1↓v),'⊃',z
  ⍎(0≠⍴p)/'z←t,z'
  v←''
  →next
∇

∇pkg⍙inspect _vname;⎕io;⎕pr;_code;_h;_f;_d;_r;_rr;_dc;_cmd;_l;⎕pw;_i;_ri;_m;_v
 ⍝ Interactively inspect a named variable.
  ⎕io←1
  ⎕pr←' '
  _code←''
  _h←⍬,'p' 'print'
  _h←_h,'b' 'box'
  _h←_h,'d' 'down'
  _h←_h,'r' 'ref'
  _h←_h,'u' 'up'
  _h←_h,'t' 'top'
  _h←_h,'h' 'help'
  _h←_h,'x' 'exit'
  _h←((0.5×⍴_h),2)⍴_h
  →_first
 _again:
  ⎕←''
 _first:
  ⎕←_vname ('≡:',⍕⍎'≡',_vname) ('⍴:',⍕⍎'⍴',_vname) ('⍴⍴:',⍕⍎'⍴⍴',_vname)
  _f←⍎_code,_vname
  _d←≡_f
  _r←⍴_f
  _rr←⍴⍴_f
  →(''≡_code)/_prompt
  _dc←pkg⍙⍙combine_picks _code
  ⎕←⊂(_dc,_vname) ('≡:',⍕_d) ('⍴:',⍕_r) ('⍴⍴:',⍕_rr)
 _prompt:
  ⍞←' inspect> '
  _cmd←pkg⍙⍙trim_blanks ⍞
  →(1≠⍴_cmd)/_what
  _l←∊((_h[;1])∊_cmd)/_h[;2]
  ⍎(0≠⍴_l)/'⎕←⊂_l ◊ →⍎''∆∆'',_l'
 _what:
  ⎕←⊂'what?'
  →_again
 ∆∆print:
  ⎕←'--'
  ⎕←_f
  ⎕←'--'
  →_again
 ∆∆box:
  ⎕pw←pkg⍙⍙wide_display
  ⎕←pkg⍙box _f
  →_again
 ∆∆down:
  →(_d<2)/_no
  _i←pkg⍙ask_index _r
  _code←(⍕_i),'⊃',_code
  →_again
 ∆∆ref:
  →(_d≠1)/_no
  _i←⍬
  _ri←1
 _next_index:
  _i←_i,pkg⍙ask_index _ri⌷_r
  _ri←_ri+1
  →(_ri≤_rr)/_next_index
  _code←(⍕_i),'⌷',_code
  →_again
 ∆∆up:
  _m←0,¯1↓∨\_code∊'⊃⌷'
  →(_m≡,0)/_no
  _code←_m/_code
  →_again
 ∆∆top:
  _code←''
  →_again
 ∆∆help:
  ⎕←_h
  →_again
 ∆∆exit: →0
 _no:
  ⎕←⊂'not here'
  →_again
∇
