⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ The shortest and longest allowable page lengths.
'pkg⍙pager_length_bounds' pkg⍙constant 16 66

⍝ Turn the pager on or off, except in cases where the line count is
⍝ provided as an explicit argument.
'pkg_pager_enable' pkg⍙constant ~pkg⍙in_dvtm

⍝ Override the pager's automatic line count. Useful for when the
⍝ terminfo database is wrong.
pkg_pager_override←⍬

∇z←pkg⍙pager_lines
 ⍝ Query the environment to return an appropriate number of lines per
 ⍝ page.
  ⍎(~pkg_pager_enable)/'z←0 ◊ →0'
  ⍎(~⍬≡pkg_pager_override)/'z←pkg_pager_override ◊ →0'
  ⍎(pkg⍙in_emacs)/'z←0 ◊ →0'
  z←⍎pkg⍙tput 'lines'
  →(⍬≡0⍴z)/0
  z←↑pkg⍙pager_length_bounds
∇

∇lines pkg⍙PAGER doc;total;cl;len;nd;unread;lc;at_end;nums;prompt1;in
 ⍝ Display a document (a list of lines or a character matrix) by page.
 ⍝ Optional left argument sets number of lines per page; 0 for no paging.
 ⍝ If number of lines per page is unspecified, ask pkg⍙pager_lines.
  →(0≠⎕nc 'lines')/init
  lines←0⌈pkg⍙pager_lines-1
 init:
  total←↑⍴doc
 top:
  cl←0
  →position
 back:
  len←↑(0≠len)/len←(lines|cl),lines
  cl←0⌈cl-lines+len
 position:
  unread←doc
  ⍎(2=⍴⍴unread)/'unread←⊂[2]unread'
  nd←⌈10⍟1+⍴unread
  unread←cl↓unread
  lc←0
 more:
  ⎕←↑unread
  unread←1↓unread
  lc←lc+1
  cl←cl+1
  at_end←0=⍴unread
  →at_end/prompt
  →((0=lines)∨(lc<lines))/more
 prompt:
  →((0=lines)∨(0≠lines)∧(lines≥↑⍴doc))/0
  nums←'[',(3 0⍕⌊100×cl÷total),'% ',((nd,0)⍕1+cl-lc),'-',((nd,0)⍕cl),'] '
  prompt1←(1+at_end)⊃'Enter: more' 'Enter: quit'
  ⍞←nums,prompt1,'; b-Enter: back; t-Enter: top; q-Enter: quit > '
  in←⍞
  →('q'∊in)/0
  →('b'∊in)/back
  →('t'∊in)/top
  →at_end/0
  lc←0
  →more
∇
