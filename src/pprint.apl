⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙is_labeled_line text;idc
 ⍝ True if left-flush define function line is a labeled line.
  idc←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789∆⍙_¯'
  z←(text⍳':')=1++/∧\text∊idc
∇

∇z←pkg⍙is_comment_line text
 ⍝ True if left-flush define function line is a comment line.
  z←'⍝'=↑text
∇

∇z←fc pkg⍙pprint fn;lock;fli;lc;ln0;ln1;ln;pad;del;flo;cl;ic
 ⍝ Format named function according to control vector.
 ⍝ ↑fc     display line numbers [1]
 ⍝ ↑1↓fc   number of spaces to indent header [0]
 ⍝ ↑2↓fc   number of spaces to indent comment line [1]
 ⍝ ↑3↓fc   number of spaces to indent labeled line [1]
 ⍝ ↑4↓fc   number of spaces to indent other lines [2]
  ⍎(0=⎕nc 'fc')/'fc←1 0 1 1 2'
  lock←↑3 ⎕at fn
  fli←⊂[2]⎕cr fn
  lc←⍴fli
  ln0←((2+lc),0)⍴''
  ln1←' ',⍨'[',[2](⍕(lc,1)⍴(-⎕io)+⍳lc),[2]']'
  pad←((¯1↑⍴ln1)⍴' ')
  ln1←pad⍪ln1⍪pad
  ln←↑(0 1=fc[⎕io+0])/ln0 ln1
  del←⊂,(⎕io+lock)⊃'∇' '⍫'
  flo←del
  flo←flo,⊂(fc[⎕io+1]⍴' '),↑fli
 more:
  fli←1↓fli
  →(0=⍴fli)/numbers
  cl←↑fli
  ic←↑((pkg⍙is_comment_line cl),(pkg⍙is_labeled_line cl), 1)/⎕io+2 3 4
  flo←flo,⊂(fc[ic]⍴' '),cl
  →more
 numbers:
  flo←flo,del
  z←ln,[2]⊃flo
∇

∇z←fc pkg⍙pprint_header fn;lock;fli;del;flo;fli;cl;lc;ln0;ln1;ln;pad
 ⍝ Format according to control vector only the header of named function.
 ⍝ ↑fc     display line numbers [1]
 ⍝ ↑1↓fc   number of spaces to indent header [0]
 ⍝ ↑2↓fc   number of spaces to indent comment line [1]
  ⍎(0=⎕nc 'fc')/'fc←1 0 1'
  lock←↑3 ⎕at fn
  fli←⊂[2]⎕cr fn
  del←⊂,(⎕io+lock)⊃'∇' '⍫'
  flo←del
  flo←flo,⊂(fc[⎕io+1]⍴' '),↑fli
 more:
  fli←1↓fli
  →(0=⍴fli)/numbers
  cl←↑fli
  →(~pkg⍙is_comment_line cl)/numbers
  flo←flo,⊂(fc[⎕io+2]⍴' '),cl
  →more
 numbers:
  lc←¯1+⍴flo
  ln0←((2+lc),0)⍴''
  ln1←' ',⍨'[',[2](⍕(lc,1)⍴(-⎕io)+⍳lc),[2]']'
  pad←((¯1↑⍴ln1)⍴' ')
  ln1←pad⍪ln1⍪pad
  ln←↑(0 1=fc[⎕io+0])/ln0 ln1
  flo←flo,'⋮'
  z←((⍴flo)↑[1]ln),[2]⊃flo
∇
