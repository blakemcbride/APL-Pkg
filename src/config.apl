⍝ Copyright (c) 2015 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ I'm establishing a distinction between local and remote
⍝ repositories early on even though the first implementation does
⍝ not support remote repositories.

⍝ Also not yet implemented is the ability to handle multiple
⍝ local repositories.

⍝ The package manager's optional configuration file is on this path.
'pkg⍙config_path' pkg⍙constant pkg⍙concatenate_paths pkg⍙user_home '.apl-pkg'

∇pkg⍙load_config;kv_lines
 ⍝ Load the configuration file
  pkg⍙⍙config_db←⍬
  →(0=≡1 pkg⍙file_info pkg⍙config_path)/0
  kv_lines←pkg⍙read_key_value_file pkg⍙config_path
  pkg⍙⍙config_db←(⊂⍬ ⍬),pkg⍙parse_metadata kv_lines
∇

∇z←key pkg⍙get_config default;m
 ⍝ Look up a configuration value
  ⍎(0=⎕nc 'pkg⍙⍙config_db')/'pkg⍙load_config'
  m←(⊂key)≡¨↑¨pkg⍙⍙config_db
  →(~∨/m)/missing
  z←∊1 2⊃m/pkg⍙⍙config_db
  →0
 missing:
  z←default
∇
