⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇pkg⍙process_cmdline cmdline;opts;opt;oi;ignore;fn;argc
 ⍝ Process a list of command-line options.
  opts←⍬
  opts←opts,⊂'--pkg-load' 'pkg⍙load' 1
  opts←opts,⊂'--pkg-manifest' 'pkg⍙load_from_manifest' 1
  opts←opts,⊂'--pkg-disable' 'pkg⍙disable' 1
 more:
  →(0=⍴cmdline)/0
  opt←⊂↑cmdline
  cmdline←1↓cmdline
  oi←(1⊃¨opts)⍳opt
  →(oi>⍴opts)/error
  (ignore fn argc)←oi⊃opts
  '→' ⎕ea ∊fn,pkg⍙stringify¨argc↑cmdline
  cmdline←argc↓cmdline
  →more
 error: 'Unrecognized option: ',opt
  →more
∇
