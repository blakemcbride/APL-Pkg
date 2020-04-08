⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ A package is decribed by a metadata file. This module deals with
⍝ extracting and querying metadata.

∇z←pkg⍙read_metadata package_path;rp;pp;vpm
 ⍝ Read the metadata file under package_path. Versioned packages
 ⍝ get special handling in which the only the package_prefix
 ⍝ (which must be the same across versions of a package) is
 ⍝ recorded along with a list of versioned directories.
  →(pkg⍙directory_is_versioned_package package_path)/versioned
  rp←pkg⍙concatenate_paths package_path pkg⍙⍙metadata_file
  z←pkg⍙read_key_value_file rp
  →0
 versioned:
  pp←pkg⍙versioned_package_paths package_path
  vpm←pkg⍙read_key_value_file pkg⍙concatenate_paths (∊1↑pp) pkg⍙⍙metadata_file
  z←(∊1↑¨(⊂'package_name:')⍷¨vpm)/vpm
  z←z,(∊1↑¨(⊂'package_prefix:')⍷¨vpm)/vpm
  z←z,(⊂'.version_path: '),¨pp
∇

∇z←pkg⍙get_metadata_entry package_path
 ⍝ Return a metadata entry for the package on path.
  z←↑((1⊃¨pkg⍙⍙metadata_db)∊⊂package_path)/pkg⍙⍙metadata_db
∇

∇z←pkg⍙⍙local_metadata_entry path
 ⍝ Return a metadata entry for the given path.
 ⍝ A metadata entry is a list of path and the metadata for the
 ⍝ package on that path.
  z←path (pkg⍙parse_metadata pkg⍙read_metadata path)
∇

⍝ We cache the medatadata db.
⍝ Internal use only.
pkg⍙⍙metadata_db←⍬

∇z←pkg⍙local_metadata
 ⍝ Returns a list of metadata entries for all local packages.
  →(~⍬≡pkg⍙⍙metadata_db)/ready
  pkg⍙load_local_metadata
 ready: z←pkg⍙⍙metadata_db
∇

∇pkg⍙load_local_metadata
 ⍝ Load local metadata from local repository.
  pkg⍙load_local_package_list ⍝ package list must be current
  pkg⍙⍙metadata_db←pkg⍙⍙local_metadata_entry¨pkg⍙local_packages
∇

'pkg⍙wild_key_limit' pkg⍙constant 10

∇z←pkg⍙wild_keys keylist;wc;lim;suf;nk;exp;ek;i
 ⍝ For each key having names ending with a wildcard character, expand
 ⍝ to a list of keys in which the wildcard character is replaced with
 ⍝ '', '-1', '-2', '-3' and so on. In the case where every key in
 ⍝ keylist ends with the wildcard character, create a new list in
 ⍝ which the expanded keys are interleaved in order. In the case where
 ⍝ keys in keylist are a mix of plain keys and wildcard keys, expand
 ⍝ the wildcard keys in place. For example (enclosing '' omitted for
 ⍝ brevity):
 ⍝
 ⍝ keylist           output
 ⍝ ----------        ---------------------------------------------
 ⍝ a b c d           a b c d
 ⍝ a* b* c*          a b c a-1 b-1 c-1 a-2 b-2 c2 a-3 b-3 c-3 ...
 ⍝ a* b c* d         a a-1 a-2 a3 ... b c c-1 c-2 c-3 ... d
 ⍝ 
 ⍝ The number of replacements is limited. The limit applies to all
 ⍝ wilcard expansions.
 ⍝ 
 ⍝ The function returns a list two values: a boolean indicating
 ⍝ whether the result list is interleaved, and the result list itself.
  wc←'*'
  lim←pkg⍙wild_key_limit
  suf←(⊂''),'-',¨1 0⍕⍳9⌊lim+¯1
  nk←⍴keylist
  →(1<nk)/multi
 single:
  exp←wc=¯1↑,⊃keylist
  →exp/expand_single
  z←0 keylist
  →0
 expand_single: z←0 ((⊂¯1↓↑keylist),¨suf)
  →0
 multi:
  exp←,⊃wc=¯1↑¨keylist
  ek←exp⍀(exp/¯1↓¨keylist)∘.,suf
  →(∧/exp)/interleave
  z←''
  i←1
 more:
  →(1=exp[i])/expand
  z←z,keylist[i]
  →next
 expand:
  z←z,ek[i;]
 next:
  i←i+1
  →(i≤nk)/more
  z←0 z
  →0
 interleave:
  z←1 (,⍉ek)
∇

∇z←keys pkg⍙lookup_metadata_entry metadata_entry;il;mk;mm;nr;nc;kp;qi;ov
 ⍝ Return a list of all key/value pairs for the given keys in 
 ⍝ a metadata entry. Wildcard keys are expanded by pkg⍙wild_keys.
 ⍝ If all keys are wildcards, they're assumed related; the result
 ⍝ will be grouped. Otherwise the result will be in the same order
 ⍝ as the metadata_entry.
  ⍎(1=≡keys)/'keys←⊂keys'
  (il keys)←pkg⍙wild_keys keys
  →(~1=⍴2⊃metadata_entry)/lookup
  metadata_entry←(1⊃metadata_entry) ((⊂((⊂⍬) (⊂⍬))), 2⊃metadata_entry)
 lookup:
 ⍝ Get existing matches.
  mk←1⊃¨2⊃metadata_entry
  z←(mk∊keys)/2⊃metadata_entry
 ⍝ If there's only one key, we're done.
  →(1=⍴,keys)/0
 ⍝ Generate metadata positions vs. key positions.
  mm←⍉mk∘.≡keys
  ⍎(1=⍴⍴mm)/'mm←(1,⍴mm)⍴mm'
  (nr nc)←⍴mm
 ⍝ Remember which keys are matched.
  kp←∨/[2]mm
 ⍝ Remove rows for unmatched keys.
  mm←kp/[1]mm
 ⍝ Skip reordering if results are interleaved.
  →il/0
 ⍝ Order result as queries.
  qi←(0≠qi)/qi←+⌿mm×(⍴mm)⍴⍳nc
  ov←⍋qi
  z←z[ov]
∇

∇z←v (f pkg⍙map) l
 ⍝ Map v f over l
  z←⍬
 more: →(0=⍴l)/0
  z←z,⊂v f ↑l
  l←1↓l
  →more
∇

∇z←metadata pkg⍙collect_metadata keys
 ⍝ Return a list of lists of key/value pairs for the given
 ⍝ keys in the list of metadata entries.
  z←keys pkg⍙lookup_metadata_entry pkg⍙map metadata
∇

∇z←pkg⍙⍙collect_values lkv
 ⍝ Collect a list of values from a list of key/value pairs.
  z←⊂''
  →(0=↑⍴lkv)/0
  z←2⊃¨lkv
∇

∇z←pkg⍙lookup_path name;md;nl;mv
 ⍝ Returns the package path given its name.
 ⍝ The package's name is determined by the value
 ⍝ associated with the package's package_name: keyword.
  ⍎(1=≡name)/'name←⊂name'
  md←pkg⍙local_metadata
  nl←,2⊃¨⊃md pkg⍙collect_metadata 'package_name'
  mv←nl∊name
  →(0=∨/mv)/empty
  z←mv/↑¨md
  →0
 empty:
  z←⊂''
∇

∇z←pkg⍙local_dependencies;md;nl;dl;c;n
 ⍝ Returns dependency info for the local repository.
  md←pkg⍙local_metadata
  nl←,2⊃¨⊃md pkg⍙collect_metadata 'package_name'
  dl←pkg⍙⍙collect_values¨md pkg⍙collect_metadata 'depends_on'
  z←⍬
  n←⍴nl
  c←1
 more: →(c>n)/0
  z←z,⊂(c⌷nl),(c⌷dl)
  c←c+1
  →more
∇

∇z←pkg⍙duplicate_prefixes;l;g
 ⍝ Return a list of duplicate package prefixes found in the local
 ⍝ package metadata.
  l←(⊂⍋⊃l)⌷l←2⊃¨1⊃¨pkg⍙local_metadata pkg⍙collect_metadata 'package_prefix'
  l←(~(⊂'')≡¨l)/l
  g←((⊃¨l)⍳l)⊂l
  z←∊¨↑¨(1<∊⍴¨g)/g
∇

∇z←pkg⍙local_package_names
 ⍝ Return a list of package names from the local repository.
  z←pkg⍙⍙collect_values ↑¨pkg⍙⍙metadata_db pkg⍙collect_metadata 'package_name'
∇
