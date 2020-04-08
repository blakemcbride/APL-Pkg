⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ Here's the mechanism we use to copy a file of APL code into the
⍝ current workspace in GNU APL. This is the similar to a ⎕copy system
⍝ function on some platforms. Note that there's no facility to protect
⍝ against redefinition.

∇z←op pkg⍙⍙apl_check code;tokens;name;locals
 ⍝ Check to make sure that code isn't violating namespace rules. The
 ⍝ checks performed depends on op code: 1=function; 2=expression.
 ⍝ Return 0 if all names in code conform to namespace rules; >0
 ⍝ otherwise. Currently loading package prefix is obtained via
 ⍝ pkg⍙loading_prefix. Checks are disabled when pkg⍙loading_prefix is
 ⍝ empty.
  z←0
  →(0=⍴pkg⍙loading_prefix)/0
  →(1 2∊op)/check_func,check_expr
  →0
 check_func:
 ⍝ Return 1 if function is defined in a foreign namespace.
 ⍝ Return 2 if function will make assignments in a foreign namespace.
  tokens←pkg⍙parse2 pkg⍙parse 1⊃code
  (name locals)←pkg⍙header_info tokens
  →(pkg⍙loading_prefix pkg⍙check_not_prefix name)/fail1
  code←1↓code
  z←0
 more: →(0=⍴code)/0
  tokens←pkg⍙parse2 pkg⍙parse 1⊃code
  →((pkg⍙loading_prefix locals) pkg⍙invalid_assign tokens)/fail2
  code←1↓code
  →more
 fail1:
  z←1
  →0
 fail2:
  z←2
  →0  
 ⍝ Return 1 if expression contains an assignment to a system name or a
 ⍝ foreign namespace.
 check_expr:
  tokens←⊂pkg⍙parse2 pkg⍙parse code
  z←(pkg⍙loading_prefix '') pkg⍙invalid_assign ↑tokens
∇

⍝ This is the core of the package manager. Given a package name,
⍝ load that package and all of its dependencies.

⍝ Remember that dependent packages are loaded in an unspecified
⍝ order. Any top-level expression in a package's control file 
⍝ must be able to be executed correctly regardless of package
⍝ load order.

⍝ Variable keeps track of package load requests. Add an entry for each
⍝ top-level load (but not its dependencies). Remove an entry for each
⍝ completed top-level unload.
pkg⍙⍙load_requests←⊂'apl-packager'

⍝ Variable keeps track of loaded packages. Expand at load; contract at
⍝ expunge. Each entry consists of loaded package prefix and version.
⍝ Note that the package manager is not permitted to load itself, therefore
⍝ there's no reason to record its version here.
pkg⍙⍙loaded_packages←⊂'pkg' ⍬

∇z←pkg⍙load_one_package path;pkg⍙loading_path;me;pkg⍙loading_prefix;deps;fp;ppv
 ⍝ Load the package on path. Bind pkg⍙loading_path (from caller) and
 ⍝ pkg⍙loading_prefix (from metadata) for reference. Return a count of
 ⍝ definitions and top-level expressions loaded from the package's
 ⍝ control file. Return ⍬ upon failure. If the package has already been
 ⍝ loaded, skip loading and return ¯1 ¯1.
  pkg⍙loading_path←path
  me←pkg⍙get_metadata_entry pkg⍙loading_path
  →(0≠⍴'.version_path' pkg⍙lookup_metadata_entry me)/versioned
  pkg⍙loading_prefix←∊2⊃↑'package_prefix' pkg⍙lookup_metadata_entry me
  →((⊂pkg⍙loading_prefix)∊1⊃¨pkg⍙⍙loaded_packages)/loaded
  →(0≠⍴pkg⍙loading_prefix)/finish_load
  ⎕←pkg⍙⍙newline,' ',(1⊃⌽pkg⍙unpack_path path),' IS A PATCH PACKAGE'
  deps←pkg⍙⍙collect_values 'depends_on' pkg⍙lookup_metadata_entry me
  →(~∧/pkg⍙⍙visually_empty¨deps)/init_has_deps
 finish_load:
  fp←pkg⍙concatenate_paths pkg⍙loading_path pkg⍙⍙control_file
  z←pkg⍙⍙apl_check pkg⍙import_apl fp
  ppv←⊂1 2⊃'package_prefix' pkg⍙lookup_metadata_entry me
  ppv←ppv,⊂↑pkg⍙⍙collect_values 'package_version' pkg⍙lookup_metadata_entry me
  pkg⍙⍙loaded_packages←∪pkg⍙⍙loaded_packages,⊂ppv
  →0
 loaded:
  ⎕←⊂path, ' ALREADY LOADED'
  z←¯1 ¯1
  →0
 versioned:
  ⍝ FINISH: Load a versioned package.
  ⎕←'VERSIONED DIRECTORIES NOT YET SUPPORTED'
  z←⍬
  →0
 init_has_deps:
  ⎕←(⊂'Dependencies:'),⊂⊃deps
  ⎕←⊂'ERROR: A PATCH PACKAGE MUST NOT HAVE DEPENDENT PACKAGES'
  ⍎')OFF'
∇

⍝ Presentation for number of functions and expressions imported from
⍝ an APL file. See pkg∆copy and pkg⍙load.
'pkg⍙⍙import_report_format' pkg⍙constant '5555 5555'

∇pkg⍙load name;ppl;mn;rp;xm;cm;forms;m;tbl;h1;h2;rv
 ⍝ Load the named package and all of its dependencies. A package loads
 ⍝ by having its control file loaded. Any subsidiary components within
 ⍝ a package's directory tree must be loaded by the control file.
 ⍝ During loading, a package's directory path is bound to pkg⍙loading_path.
 ⍝ Print an abbreviated report showing (for each package) the number
 ⍝ of functions loaded, the number of top-level expressions executed,
 ⍝ and the filesystem path of the package directory.
 ⍝ FINISH: pkg⍙get_load_paths should also return constrained versions.
  (ppl mn)←pkg⍙get_load_paths name
  →(⍬≢mn)/missing
  →(∨/~pkg⍙directory_is_package¨⊃ppl)/sync
  rp←2⊃¨↑¨(,pkg⍙get_metadata_entry¨⊃ppl) pkg⍙collect_metadata 'package_prefix'
  xm←∨⌿(,¨'ST')∘.≡rp
  →(∨/xm)/res_prefix
  cm←rp∊pkg⍙duplicate_prefixes
  →(∨/cm)/dup_prefix
 load:
  pkg⍙⍙load_requests←∪pkg⍙⍙load_requests,⊂name
  forms←pkg⍙load_one_package¨⊃ppl
  →(∨/pkg⍙⍙visually_empty¨forms)/load_error
  m←,~(⊂¯1 ¯1)≡¨forms
  →(0=+/m)/0
  tbl←m⌿forms,ppl
  tbl←(⍪(⊂pkg⍙⍙import_report_format) ⍕¨,1⊃¨⍪⊂[2]tbl), ↑¨2⊃¨⍪⊂[2]tbl
  h1←'Func/Expr' 'Package'
  h2←'---------' '-------'
  ⎕←' '⍪h1⍪h2⍪tbl
  →0
 res_prefix: ⎕←'RESERVED PREFIXES:' (⊃xm/rp)
  →0
 dup_prefix:
 ⍝ We have multiple packages with the same prefix. We must first check for
 ⍝ consistency and uniqueness of version metadata:
 ⍝  - check presence of package_version metadata
 ⍝    - if all have a package_version, then
 ⍝      - if all versions are unique, then
 ⍝        - if version specified, then
 ⍝          - load given version (via pkg⍙get_load_paths)
 ⍝        - else
 ⍝          - load highest version
 ⍝      - else
 ⍝        - report "duplicate version metadata"
 ⍝    - else
 ⍝      - report "duplicate prefixes or inconsistent version metadata"
  rv←,2⊃¨⊃(,pkg⍙get_metadata_entry¨⊃ppl) pkg⍙collect_metadata 'package_version'
  →(∨/0=∊⍴¨rv)/inconsistent
  →(~∧/((2⍴⍴rv)⍴1,(⍴rv)⍴0)=rv∘.≡rv)/dup_version
 ⍝ We have multiple packages with the same prefix and different versions.
 ⍝ FINISH: Edit ppl to retain only required versions.
  ⎕←'MULTIPLE VERSIONS NOT YET SUPPORTED'
  ⎕←(,⊃ppl),[1.5]rv
  →0
  →load
 load_error:
  ⎕←'ERROR DURING LOADING; PACKAGE STATE IS LIKELY INCONSISTENT'
  →0
 inconsistent:
  ⎕←'DUPLICATE PREFIXES OR INCONSISTENT VERSION METADATA:' (⊃∪cm/rp)
  →0
 dup_version:
  ⎕←'DUPLICATE VERSION METADATA:' (⊃∪cm/rp)
  →0
 missing: ⎕←'MISSING PACKAGES:' (⊃mn)
  →0
 sync: ⎕←⊂'Some packages in the database are no longer in the filesystem.'
  ⎕←⊂'Please rescan to update the database.'
∇

∇z←pkg⍙read_manifest name;path
 ⍝ Return a list of package names read from a manifest file found in
 ⍝ the local package repository.
  path←pkg⍙concatenate_paths pkg⍙local_repository name
  z←pkg⍙⍙trim_blanks¨pkg⍙split_lines (⎕fio[26] path)
  →(0≠↑0⍴z)/0
  ⎕es 'ERROR READING MANIFEST: ',(⎕fio[2] -↑z),' ',path
∇

∇pkg⍙load_from_manifest name
 ⍝ Load a list of packages from a manifest file.
  ⎕←⊂('Loading packages from manifest file ',name),[0.5]'='
  ⎕←''
  pkg⍙load¨pkg⍙read_manifest name
∇
