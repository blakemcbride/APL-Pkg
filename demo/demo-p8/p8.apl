
'package 8'

∇z←d8⍙read_file path;h;r;l
 z←⍬
 h←⎕fio[3] path
 →(h<0)/error
 more: →(⎕fio[11] h)/error
 →(⎕fio[10] h)/end
 r←⎕fio[8] h
 →(32≤¯1↑r)/encode
 r←¯1↓r
 encode: l←⎕av[⎕io+r]
 z←z,⊂l
 →more
 error: 'd8∆read_file ERROR: ',(⎕fio[2] (⎕fio[1] ⍬)),' ',path
 end: 0 0⍴(⎕fio[4] h)
∇

⍪¨d8⍙read_file¨pkg∆shell 'find `pwd`/src -name ''c8.[ch]'''
