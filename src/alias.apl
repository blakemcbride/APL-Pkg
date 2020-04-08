⍝ Copyright (c) 2015 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←old_name pkg⍙make_alias_fn_header alias;pi;pa;ln;sig;ps;mi
 ⍝ Return a function's header with a new name, eliding the local
 ⍝ variable declarations. Return ⍬ if there is no defined function
 ⍝ of old_name.
  z←⍬
  pi←pkg⍙fdef_info old_name
  →(⍬≡pi)/0
  (pa ln sig)←pi
  ps←pkg⍙parse sig
  mi←(ps≡¨⊂old_name)/⍳⍴ps
  ps[mi]←⊂,alias
  z←∊ps
∇

⍝ Alias db is a list of <alias, signature> pairs.
pkg⍙⍙alias_db←,⊂⍬ ⍬

∇z←old_name pkg⍙define_alias alias;hdr;pa;ln;sig
 ⍝ Define an alias function. Return 1 on success; 0 on failure.
  z←1
  hdr←old_name pkg⍙make_alias_fn_header alias
  →(⍬≡hdr)/not_found
  (pa ln sig)←pkg⍙fdef_info old_name
  pkg⍙sink ⎕fx ⊃(⊂hdr),(⊂'⍝ alias'),⊂sig
  pkg⍙⍙alias_db←pkg⍙⍙alias_db,⊂alias sig
  →0
 not_found: z←0
∇

∇z←pkg⍙alias_exists alias
 ⍝ Return true if the named alias exists.
  z←(⊂,alias)∊1⊃¨pkg⍙⍙alias_db
∇

∇z←pkg⍙remove_alias alias
 ⍝ Remove an alias definition. Return 1 if the alias existed;
 ⍝ 0 otherwise.
  z←1
  →(~pkg⍙alias_exists alias)/not_found
  pkg⍙sink ⎕ex alias
  pkg⍙⍙alias_db←(~(1⊃¨pkg⍙⍙alias_db)∊⊂,alias)/pkg⍙⍙alias_db
  →0
 not_found: z←0
∇

∇z←old_name pkg⍙make_alias alias
 ⍝ Make or replace a function alias. Return 1 on success; 0 otherwise.
  pkg⍙sink pkg⍙remove_alias alias
  z←old_name pkg⍙define_alias alias
∇

∇z←pkg⍙valid_alias_name alias
 ⍝ Return 0 if given name is an alias or bears the same prefix as a loaded
 ⍝ package. Otherwise return 1.
  z←1
  →(pkg⍙alias_exists alias)/invalid
  →((⊂pkg⍙get_prefix alias)∊1⊃¨pkg⍙⍙loaded_packages)/invalid
  →0
 invalid: z←0
∇

⍝ This section supports load-time aliases. Alias definitions are collected
⍝ until all loads have completed, then are executed all at once. This ensures
⍝ that we catch any collisions between alias names and package prefixes. We
⍝ are also stricter about alias names; we won't allow redefinition of an alias
⍝ at load time. This facility is intended for use only when loading one package
⍝ and its dependencies; its use is explicitly disallowed when loading packages
⍝ from a manifest.

∇pkg⍙finalize_load_aliases;name;alias
 ⍝ Process load-time aliases in a batch. Disallow alias redefinition.
 ⍝ Report each error. No return value.
 more:
  →(0=⍴pkg⍙load_aliases)/0
  (name alias)←↑pkg⍙load_aliases
  pkg⍙load_aliases←1↓pkg⍙load_aliases
  →(~pkg⍙valid_alias_name alias)/error
  →(pkg⍙alias_exists alias)/error
  →(~name pkg⍙define_alias alias)/error
  →more
 error: ⎕←' ALIAS ERROR: ',(∊name),' ',(∊alias)
  →more
∇
