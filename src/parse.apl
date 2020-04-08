⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ This is the start of a program analyzer for the package manager.

⍝ We'll use these functions to (a) extract lists of external names,
⍝ (b) detect function and operator definitions having prefixes that
⍝ don't match the prefix of their package, (c) rewrite prefixes found
⍝ in program text, (d) confirm that external dependencies are
⍝ satisfied by loaded packages and (e) identify packages having no
⍝ external dependencies.

⍝ Other useful tools can be based upon these functions, such as (a)
⍝ use/def analysis, (b) static call-graph construction and (c)
⍝ implementing meta-dot capability inside APL.

∇z←pkg⍙parse text;c;i;n;f
 ⍝ Parse text into a list of identifiers and interstital text. Note
 ⍝ that the interstitial text preserves blanks; this is useful when we
 ⍝ want to rewrite the identifiers in a text without changing the
 ⍝ layout.
  z←c←⍬
  i←n←0
 more:
  →(0=⍴text)/done
  f←1↑text
  text←1↓text
  →((f∊pkg⍙nuX,pkg⍙dig)∧(n=1))/accum
  →(((f∊pkg⍙idX,pkg⍙alp,pkg⍙dig)∧(i=1))∨((f∊pkg⍙nuX,pkg⍙dig)∧(n=1)))/accum
  →((f∊pkg⍙id1,pkg⍙alp)∧(i=0))/start_id
  →((f∊pkg⍙nu1,pkg⍙dig)∧(i=0)∧(n=0))/start_num
  ⍎((0≠⍴c)∧(i=1)∨(n=1))/'z←z,⊂c ◊ c←⍬'
  i←n←0
  →accum
 start_id:
  i←1
  →flush
 start_num:
  n←1
 flush:
  ⍎(0≠⍴c)/'z←z,⊂c ◊ c←⍬'
 accum:
  c←c,f 
  →more
 done:
  z←z,⊂c
∇

∇z←pkg⍙remove_blanks text
 ⍝ Remove all blanks from text.
  z←(' '≠text)/text
∇

∇z←pkg⍙remove_empty_elements list
 ⍝ Remove empty elements from list.
  z←⍬
 more: →(0=⍴list)/0
  →(0=⍴↑list)/next
  z←z,⊂↑list
 next: list←1↓list
  →more
∇

∇z←pkg⍙split_non_idents list
 ⍝ Given a list, split non-identifiers into individual characters.
  z←⍬
 more: →(0=⍴list)/0
  →(pkg⍙is_id ↑list)/id
  z←z,∊¨↑list
  →next
 id: z←z,⊂↑list
 next: list←1↓list
  →more
∇

∇z←pkg⍙parse2 pt
 ⍝ Finish tokenizing the output of pkg⍙parse, removing whitespace and
 ⍝ separating non-identifier characters into individual tokens. Note
 ⍝ that blanks are not preserved. This transformation is useful for
 ⍝ program analysis in which adjacency of tokens, irrespective of
 ⍝ intervening whitespace, is important.
  z←pkg⍙split_non_idents pkg⍙remove_empty_elements pkg⍙remove_blanks¨pt
∇

∇z←pkg⍙is_id token
 ⍝ Return true if token is a valid identifier.
  z←((1↑,token)∊pkg⍙id1,pkg⍙alp)∧(∧/(1↓,token)∊pkg⍙idX,pkg⍙alp,pkg⍙dig)
∇

∇z←pkg⍙header_info tokens;queue;locals;t;op;name
 ⍝ Given a parsed function or operator header line, return the
 ⍝ function or operator name and a list of local variable names.
 ⍝
 ⍝ z←foo;locals
 ⍝ z←foo b;locals
 ⍝ z←a foo b;locals
 ⍝ z←(x foo);locals
 ⍝ z←(x foo) b;locals
 ⍝ z←(x foo y);locals
 ⍝ z←(x foo y) b;locals
 ⍝ z←a (x foo) b;locals
 ⍝ z←a (x foo y) b;locals
  queue←locals←name←⍬
  op←0
 more:
  →(0=⍴tokens)/end
  t←1⊃tokens
  tokens←1↓tokens
  →('←'∊t)/assign
  →('('∊t)/op_start
  →((')'∊t)∧(op=1))/op_end
  →(';'∊t)/locals_list
  ⍎(pkg⍙is_id t)/'queue←queue,⊂t'
  →more
 assign:
  locals←locals,queue
  queue←⍬
  →more
 op_start:
  locals←locals,queue
  queue←⍬
  op←1
  →more
 op_end:
  locals←locals,⊂1⊃queue
  name←2⊃queue
  ⍎(3=⍴queue)/'locals←locals,⊂3⊃queue'
  queue←⍬
  →more
 locals_list:
  ⍎(pkg⍙is_id t)/'locals←locals,⊂t'
  →(0=⍴tokens)/end
  t←1⊃tokens
  tokens←1↓tokens
  →locals_list 
 end:
  →(0≠⍴name)/out
  ⍎(1=⍴queue)/'name←1⊃queue ◊ queue←⍬'
  ⍎(2=⍴queue)/'name←1⊃queue ◊ queue←1↓queue'
  ⍎(3=⍴queue)/'name←2⊃queue ◊ queue←1 0 1/queue'
 out:
  z←name (locals,queue)
∇

∇z←pkg⍙label tokens
 ⍝ Given a parsed function line, return the name of a label which
 ⍝ appears on that line.
  z←(1⌽∨/¨':'=¨tokens)/tokens
∇
