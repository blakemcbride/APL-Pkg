⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙cmd_packages args;pl;vd;rpd;lpv;nl;mpf;nlf;lpp;plf;lf;r;h0;w;d;mn;⎕pw
 ⍝ Display all local packages.
  z←1
  →(0≠⍴args)/error
  pl←,2⊃¨⊃pkg⍙local_metadata pkg⍙collect_metadata 'package_prefix'
  vd←⍴¨pkg⍙local_metadata pkg⍙collect_metadata '.version_path'
  (rpd lpv nl)←pkg⍙⍙required_loaded
  mpf←4×rpd∧~lpv
  nlf←2×(⍴,pkg⍙⍙load_requests)≥pkg⍙⍙load_requests⍳nl
  lpp←1⊃¨pkg⍙⍙loaded_packages
  plf←⎕io+(⍴,lpp)≥lpp⍳pl
  lf←' +**----'[mpf+nlf+plf]
  r←('----' '-' '-' '------' '----')
  r←r⍪(∊0≠⍴¨pl)⌿nl,lf,vd,pl,[1.5]pkg⍙local_packages
  r←⍕('' '_' '' '' '')⍪('Name' 'L' 'V' 'Prefix' 'Path')⍪r
  h0←' *: top-level load; +: loaded dependency; -: expunged dependency'
  w←1↑w[⍒w←(⍴h0),1↓⍴r]
  ⎕pw←pkg⍙⍙wide_display
  pkg⍙PAGER ((1,w)⍴w↑h0)⍪w↑[2]r
  mn←pkg⍙⍙visually_empty¨pkg⍙local_metadata pkg⍙collect_metadata 'package_name'
  →(~∨/mn)/0
  ⎕←'No package name:',⊂⊃⊃mn/1⊃¨pkg⍙local_metadata
  →0
 error: z←0
∇

∇z←pkg⍙cmd_read args;pn;pp;kl;dl;h1;h2;h3;c1;c2;c3;paths;dn;dp;h;doc;r;l;⎕pw
 ⍝ List a package's documents, as listed in metadata, or read a document.
  z←1
  →(~(⍴,args)∊1 2)/error
  pn←↑args
  pp←↑pkg⍙lookup_path pn
  →(0=⍴pp)/no_package
  kl←'document_name*' 'document_file*'
  dl←kl pkg⍙lookup_metadata_entry pkg⍙⍙local_metadata_entry pp
  →(0=⍴dl)/no_documents
  h1←⊃(,'#') (,'-')
  h2←⊃'Title' '-----'
  h3←⊃'Path' '----'
  c1←⍳.5×⍴dl
  c2←⍪(2⊃¨dl)[(((⍴dl)⍴0 1)/⍳⍴dl)]
  c3←⍪paths←(2⊃¨dl)[(((⍴dl)⍴1 0)/⍳⍴dl)]
  →(2=⍴args)/read
  ⎕pw←pkg⍙⍙wide_display
  ⎕←(h1 h2 h3)⍪c1,c2,c3
  →0
 read: dn←'0' ⎕ea 2⊃args
  →((dn<1)∨(dn>⍴paths))/error
  dp←dn⊃paths
  →(0=⍴dp)/error
  h←⎕fio[3] pkg⍙concatenate_paths (⊂pp),pkg⍙split dp
  →(h<0)/file_error
  doc←⍬
 more: →(⎕fio[11] h)/file_error
  →(⎕fio[10] h)/ready
  r←⎕fio[8] h
  →(32≤¯1↑r)/encode
  r←¯1↓r
  →(0≠⍴r)/encode
  r←,32
 encode: l←pkg⍙utf_to_ucs r
  doc←doc,⊂l
  →more
 ready: pkg⍙sink (⎕fio[4] h)
  ⎕pw←pkg⍙⍙wide_display
  pkg⍙PAGER doc
  →0
 no_package:
  ⎕←⊂'No such package'
  →0
 no_documents:
  ⎕←⊂'No documents'
  →0
 file_error: ⎕←⎕fio[2] (⎕fio[1] ⍬)
  pkg⍙sink (⎕fio[4] h)
 error: z←0
∇

∇z←pkg⍙cmd_depends args;pn;mn;text
 ⍝ Display depencies of named package.
  z←1
  →(1≠⍴args)/error
  (pn mn)←pkg⍙local_dependencies pkg⍙compute_dependencies ↑args
  text←(⊂'Dependencies:'),⊂⊃pn
  →(⍬≡mn)/display
  text←text,'--' ''
  text←text,(⊂'Missing:     '),⊂⊃mn
 display:
  text←⍕(2,⍨2÷⍨⍴text)⍴text
  ⍎(1=⍴⍴text)/'text←(1,⍴text)⍴text'
  pkg⍙PAGER text
  →0
 error: z←0
∇

∇z←pkg⍙cmd_metadata args;path;md;n;c;text;me;k;v;vl;⎕pw
 ⍝ Display metadata of named package.
  z←1
  →(1≠⍴args)/error
  path←↑pkg⍙lookup_path ↑args
  →(0=⍴path)/none
  md←pkg⍙parse_metadata pkg⍙read_metadata path
  n←⍴md
  c←1
  text←⍬
 more: →(c>n)/display
  me←c⊃md
  k←∊1⊃me
  v←∊2⊃me
  vl←pkg⍙split_lines v
  text←text,k (↑vl)
 cont: vl←1↓vl
  →(0=⍴vl)/next
  text←text,'' (↑vl)
  →cont
 next:
  c←c+1
  →more
 display:
  text←⍕(2,⍨2÷⍨⍴text)⍴text
  ⎕pw←pkg⍙⍙wide_display
  pkg⍙PAGER text
  →0
 none:
  ⎕←⊂'No such package'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_load args;pkg⍙load_aliases
 ⍝ Load named package and all of its dependencies.
  z←1
  →(1≠⍴args)/error
  pkg⍙load_aliases←⍬
  pkg⍙load ↑args
  pkg⍙finalize_load_aliases
  →0
 error: z←0
∇

∇z←pkg⍙cmd_disable args;disabled;path;md;pre
 ⍝ Disable named package. Without name, list disabled.
  z←1
  →(1 0=⍴args)/disable,list
  →error
 disable:
  path←↑pkg⍙lookup_path ↑args
  →(0=⍴path)/not_found
  md←pkg⍙⍙local_metadata_entry path
  pre←pkg⍙⍙collect_values 'package_prefix' pkg⍙lookup_metadata_entry md
  →(pre∊1⊃¨pkg⍙⍙loaded_packages)/loaded
  pkg⍙disable_package ↑args
  ⎕←⊂'OK'
  →0
 not_found: ⎕←⊂'No such package'
  →0
 loaded: ⎕←⊂'Not disabling loaded package'
  →0
 list: disabled←pkg⍙disabled_packages
  →(0=⍴disabled)/none
  ⎕←⍪disabled
  →0
 none: ⎕←⊂'All packages enabled'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_enable args
 ⍝ Enable named package.
  z←1
  →(1≠⍴args)/error
  →((,'*')≡↑args)/all
  pkg⍙enable_package ↑args
  ⎕←⊂'OK'
  →0
 all: pkg⍙enable_all_packages
  ⎕←⊂'OK'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_expunge args;pn;rpd;lpv;pnl;em
 ⍝ Expunge a package. Dependencies are not considered.
  z←1
  →(1≠⍴args)/error
  pn←↑args
  (rpd lpv pnl)←pkg⍙⍙required_loaded
  →(~(⊂pn)∊lpv/pnl)/not_loaded
  em←pkg⍙expunge_package pn
  →(⍬≡em)/ok
  ⎕←⊂em
 error: z←0
  →0
 not_loaded:
  ⎕←⊂'Not loaded'
  →0
 ok:
  ⎕←⊂'Package ',pn,' is expunged'
  ⎕←⊂'NOTE: ',pn,'''s dependencies, if any, remain loaded'
∇

∇z←pkg⍙cmd_unload args;pn;rpd;lpv;pnl
 ⍝ Unload a package. Only valid for package loaded at top-level.
 ⍝ Dependencies are unloaded if unused. Package is retained if a
 ⍝ dependent of some other package.
  z←1
  →(1≠⍴args)/error
  pn←↑args
  →(pn≡'apl-packager')/disallowed
  →(~(⊂pn)∊pkg⍙⍙load_requests)/dependent
  (rpd lpv pnl)←pkg⍙⍙required_loaded
  →(∨/rpd∧(⊂pn)≡¨pnl)/update_requests
  →(~pkg⍙expunge_package_verbose pn)/fail
 update_requests:
  pkg⍙⍙load_requests←pkg⍙⍙load_requests~⊂pn
  →(~∧/pkg⍙expunge_package_verbose¨pkg⍙orphaned_packages)/fail
  →0
 disallowed:
  ⎕←⊂'The package manager can''t be unloaded'
  →0
 dependent:
  ⎕←⊂'Not a top-level load'
  →0
 fail:
  ⎕←⊂'The package state may be inconsistent'
  →0
 error: z←0
  →0
∇

∇z←pkg⍙cmd_reload args;pn;rpd;lpv;pnl
 ⍝ Reload a package without affecting its dependencies.
  z←1
  →(1≠⍴args)/error
  pn←↑args
  →(pn≡'apl-packager')/disallowed
  (rpd lpv pnl)←pkg⍙⍙required_loaded
  →(~(⊂pn)∊lpv/pnl)/not_loaded
  pkg⍙sink pkg⍙expunge_package pn
  pkg⍙sink pkg⍙load_one_package ∊pkg⍙lookup_path pn
  →0
 disallowed:
  ⎕←⊂'The package manager can''t be reloaded'
  →0
 not_loaded:
  ⎕←⊂'Not loaded'
  →0
 error:
  z←0
∇

∇pkg⍙⍙new_package_instructions;pp
  pp←↑pkg⍙lookup_path 'apl-packager'
  ⎕←⊂'Done. Edit ',pkg⍙⍙control_file,' and ',pkg⍙⍙metadata_file,' as needed'
  ⎕←⊂'Refer to ',pp,'/API.md for guidance'
∇

∇z←pkg⍙cmd_new args;pn;tp;cp;mp;rp;mf
 ⍝ Create a new package from the template.
  z←1
  →(1≠⍴args)/error
  pn←↑args
  tp←pkg⍙concatenate_paths (↑pkg⍙lookup_path 'apl-packager') 'template'
  cp←pkg⍙concatenate_paths tp pkg⍙⍙control_file
  mp←pkg⍙concatenate_paths tp pkg⍙⍙metadata_file
  rp←pkg⍙concatenate_paths pkg⍙local_repository pn
  mf←pkg⍙concatenate_paths rp pkg⍙⍙metadata_file
  →(2=≡1 pkg⍙file_info rp)/exists
  pkg⍙sink pkg⍙sh 'mkdir ',rp
  pkg⍙sink pkg⍙sh 'chmod 755 ',rp
  pkg⍙sink pkg⍙sh 'cp ',cp,' ',rp
  pkg⍙sink pkg⍙sh 'cp ',mp,' ',rp
  pkg⍙sink pkg⍙sh 'sed -i "/^package_name: /s/ / ',pn,'/" ',mf
  pkg⍙load_local_metadata
  pkg⍙⍙new_package_instructions
  →0
 exists:
  ⎕←⊂'Can''t: ',rp,' exists'
  →0
 error: z←0
∇

∇z←pkg⍙cmd_init args;pn;pp;tp;cp;mp;rp;mf;cf;fi
 ⍝ Add package files to an existing directory.
  z←1
  →(1≠⍴args)/error
  pn←↑args
  pp←↑pkg⍙lookup_path 'apl-packager'
  tp←pkg⍙concatenate_paths pp 'template'
  cp←pkg⍙concatenate_paths tp pkg⍙⍙control_file
  mp←pkg⍙concatenate_paths tp pkg⍙⍙metadata_file
  rp←pkg⍙concatenate_paths pkg⍙local_repository pn
  mf←pkg⍙concatenate_paths rp pkg⍙⍙metadata_file
  cf←pkg⍙concatenate_paths rp pkg⍙⍙control_file
  fi←1 pkg⍙file_info rp
  →(¯2≡fi)/no_such_dir
  →(0=≡fi)/unexpected_error
  →(~'directory'≡1⊃fi)/no_such_dir
  →(~1 1 1≡10⊃fi)/no_access
  →((2=≡1 pkg⍙file_info mf)∨(2=≡1 pkg⍙file_info cf))/prior_init
  pkg⍙sink pkg⍙sh 'cp ',cp,' ',rp
  pkg⍙sink pkg⍙sh 'cp ',mp,' ',rp
  pkg⍙sink pkg⍙sh 'sed -i "/^package_name: /s/ / ',pn,'/" ',mf
  pkg⍙load_local_metadata
  pkg⍙⍙new_package_instructions
  →0
 no_such_dir:
  ⎕←⊂'Can''t: ',rp,' is not a directory'
  →0
 no_access:
  ⎕←⊂'Can''t: ',rp,' can not be accessed for update'
  →0
 prior_init:
  ⎕←⊂'Can''t: control or metadata file already exists'
  →0
 unexpected_error:
  ⎕←⊂'Can''t: unexpected error ',⍕fi
  →0
 error: z←0
∇

∇z←pkg⍙cmd_rescan args
 ⍝ Rescan local packages to update cached metadata.
  z←1
  →(0≠⍴args)/error
  pkg⍙load_local_metadata
  ⎕←⊂'OK'
  →0
 error: z←0
∇

∇_z←pkg⍙cmd_names _args;_c;_o;_p;_n;_k;_h1;_h2;⎕pw
 ⍝ Display all workspace names for given package prefix.
  _z←1
  →(~(⍴,_args)∊1 2)/error
  _c←2 3 4
  →(2≠⍴_args)/names
  _o←'vars' 'fns' 'ops'
  _c←1+_o⍳_o pkg⍙prefix_match 1↓_args
 names:
  _p←↑_args
  →((_p∊'ST')∧1=⍴,_p)/reserved
  →(~pkg⍙valid_prefix _p)/invalid
  _n←_c pkg⍙names _p
  →(0=⍴_n)/none
  _k←⎕nc¨_n
  _n←(0≠_k)/_n
  _k←(0≠_k)/_k
  _h1←('Kind' 'Name')
  _h2←('----' '----')
  ⎕pw←pkg⍙⍙wide_display
  pkg⍙PAGER ⍕_h1⍪_h2⍪(⊂[2](5 3⍴'???LBLVARFUNOPR')[_k+⎕io;]),[1.5]_n
  →0
 none:
  ⎕←⊂'None'
  →0
 reserved:
  ⎕←⊂'Reserved prefix'
  →0
 invalid:
  ⎕←⊂'Not a valid prefix'
  →0
 error: _z←0
∇
