⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙⍙strip_trailing_blanks v
 ⍝ Strip trailing blanks from a string.
  v←∊v
  z←(~⌽∧\' '=⌽⊃v)/⊃v
∇

∇z←pkg⍙⍙strip_leading_blanks v
 ⍝ Strip leading blanks from a string.
  v←∊v
  z←(~∧\' '=⊃v)/⊃v
∇

∇z←pkg⍙⍙trim_blanks v
 ⍝ Trim leading and trailing blanks from a string.
  z←pkg⍙⍙strip_trailing_blanks pkg⍙⍙strip_leading_blanks v
∇

∇z←pkg⍙split v;l;w
 ⍝ Split a string at blanks. Return a list of words.
  z←''
 more:
  v←(+/∧\v∊' ')↓v
  →(0=⍴v)/0
  l←+/∧\~v∊' '
  w←⊂l↑v
  v←l↓v
  z←z,w
  →more
∇

∇z←pkg⍙split_lines v;l;w
 ⍝ Split a string at newlines. Return a list of lines.
  z←''
 more:
  v←(+/∧\v∊pkg⍙⍙newline)↓v
  →(0=⍴v)/0
  l←+/∧\~v∊pkg⍙⍙newline
  w←⊂l↑v
  v←l↓v
  z←z,w
  →more
∇

∇z←w pkg⍙wrap_lines v;bp;wm;wp
 ⍝ Return a list of lines wrapped to (approximately) a given width.
  z←v
  z[(z∊pkg⍙⍙newline)/⍳⍴z]←' '
  bp←(z∊' ')/⍳⍴z
  wm←(1⌽wm)<wm←w|bp
  wp←wm/bp
  z[wp]←pkg⍙⍙newline
∇

∇z←pkg⍙stringify v
 ⍝ Wrap a vector in quotes, doubling each internal quote.
  z←'''',(⊃,/(1+''''=v)⍴¨v),''''
∇

∇z←names pkg⍙prefix_match string;mv
 ⍝ Given a list of full tokens and a string, return the one token
 ⍝ which matches the string. The string may be either the full token
 ⍝ or a unique prefix matching one token. If no match is found, return
 ⍝ the string unchanged. Both the string and the return value are
 ⍝ scalar (enclosed) strings.
  z←string
  mv←↑¨(⊂,∊string)⍷¨names
  →(1≠+/mv)/0
  z←⊂,∊mv/names
∇

∇z←names pkg⍙prefix_matches string;mv
 ⍝ Given a list of full tokens and a string, return all the tokens
 ⍝ which match the string. Both the string and the return value are
 ⍝ scalar (enclosed) strings.
  z←''
  mv←↑¨(⊂,∊string)⍷¨names
  z←mv/names
∇
