⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ Define limits on version numbers. The component limits range from 0
⍝ to the expressed limit, inclusive. The combined number of digits
⍝ must be less than or equal to 18 in order to be encoded into an
⍝ 64-bit integer value.
'pkg⍙⍙version_components' pkg⍙constant 4
'pkg⍙⍙version_component_limits' pkg⍙constant 999 9999 99999 999999
'pkg⍙⍙max_encoded_version' pkg⍙constant 999999999999999999

∇z←pkg⍙encode_version v
 ⍝ Encode a numeric vector into a scalar version number suitable for
 ⍝ comparison. Return 0 if passed an empty vector.
  z←(1+pkg⍙⍙version_component_limits) ⊥ pkg⍙⍙version_components↑v
∇

∇z←pkg⍙parse_version s;v;l;m
 ⍝ Check that all elements of string denote integers, that the count of
 ⍝ integers does not exceed pkg⍙⍙version_components and that the integers
 ⍝ are all positive and less than the per-component limits set by
 ⍝ pkg⍙⍙version_component_limits. If all of these tests pass, return a
 ⍝ corresponding numeric vector; otherwise return ⍬.
  l←pkg⍙⍙version_components
  m←1+pkg⍙⍙version_component_limits
  →((∧/s∊' ')∨(0=⍴s))/err
  →(~∧/s∊' 0123456789')/err
  v←⍎s
  →(l<⍴v)/err
  →(∨/0>l↑v)/err
  →(∨/m≤l↑v)/err
  z←v
  →0
 err:
  z←⍬
∇

∇z←pkg⍙⍙read_package_manager_version;pmd;ver
 ⍝ Return the package manager's version (from metadata) as a numeric
 ⍝ vector.
  pmd←pkg⍙⍙local_metadata_entry ↑pkg⍙lookup_path 'apl-packager'
  ver←1 2⊃'package_version' pkg⍙lookup_metadata_entry pmd
  z←pkg⍙parse_version ver
∇

∇z←a (relation pkg⍙compare_version) b
 ⍝ Apply relation to version numbers.
  z←(pkg⍙encode_version a) relation pkg⍙encode_version b
∇
