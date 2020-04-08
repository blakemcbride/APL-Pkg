⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇pkg⍙check_apl;ok;pkg⍙loading_path
  ok←pkg∆apl_version ≥ pkg⍙compare_version 1 5
  ⍎(~ok)/'⎕←'' WARNING: Your GNU APL is older than the recommended version.'''
∇

pkg⍙check_apl
