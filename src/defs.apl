⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇pkg⍙sink value
 ⍝ Discard given value.
∇

∇name pkg⍙constant value
 ⍝ Define a constant function.
  →(2≠⎕nc name)/define
  pkg⍙sink ⎕ex name
  →(0≠⎕nc name)/error
 define:
  →(∨/(⎕av⍳value)<⎕av⍳' ')/control
  →(''≡0⍴value)/text
  →(⍬≡0⍴value)/numeric
  →((2=≡value)∧(∧/pkg⍙is_text¨value))/list
  →error
 control: pkg⍙sink ⎕fx ('z←',name) ('z←⎕av[',(⍕⎕av⍳value),']')
  →0
 text: pkg⍙sink ⎕fx ('z←',name) ('z←''',⍕value,'''')
  →0
 numeric:
  →(0=⍴value)/empty
  pkg⍙sink ⎕fx ('z←',name) ('z←',⍕value)
  →0
 empty: pkg⍙sink ⎕fx ('z←',name) ('z←⍬')
  →0
 list: pkg⍙sink ⎕fx ('z←',name) ('z←',⍕pkg⍙_format_list_element¨value)
  →0
 error:
  ⎕ES 'DOMAIN ERROR'
∇

⍝ Token constituents
'pkg⍙alp' pkg⍙constant 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
'pkg⍙dig' pkg⍙constant '1234567890'
'pkg⍙id1' pkg⍙constant '⎕∆⍙_'
'pkg⍙idX' pkg⍙constant '∆⍙_¯'
'pkg⍙nu1' pkg⍙constant '¯'
'pkg⍙nuX' pkg⍙constant 'JE¯.'

∇z←pkg⍙_format_list_element text
 ⍝ Wrap element of a text list.
  z←'(,''',text,''')'
∇

∇z←pkg⍙is_text v
 ⍝ Return true if value is a string.
  z←(''≡0⍴v)∧(2>≡v)
∇

⍝ First we define the platform. For now we'll assume a Unix-family
⍝ platform. Later, probes will replace a few of these constant
⍝ functions and leave others returning 'unknown'. Full implementation
⍝ of these constant functions won't be done until we implement
⍝ multiplatform support.

⍝ These definitions are a part of the public API.
'pkg∆platform_family' pkg⍙constant 'unix'
'pkg∆os_type' pkg⍙constant 'unknown'
'pkg∆os_distribution' pkg⍙constant 'unknown'
'pkg∆os_version' pkg⍙constant 'unknown'
'pkg∆apl_type' pkg⍙constant 'unknown'
'pkg∆apl_version' pkg⍙constant 'unknown'
'pkg∆shell_type' pkg⍙constant 'unknown'
'pkg∆shell_version' pkg⍙constant 'unknown'

⍝ Here are some definitions specific to the package manager.
⍝ These must be stable over the lifetime of this software.
⍝ Don't change these.
'pkg⍙⍙control_file' pkg⍙constant '_control_.apl'
'pkg⍙⍙metadata_file' pkg⍙constant '_metadata_'
