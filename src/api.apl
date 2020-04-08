⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ Here's the external API to be used by package implementers.

⍝ The existence of this constant is the canonical way to determine the
⍝ presence of the package manager. The value is a name which broadly
⍝ denotes a feature release.
'pkg∆manager' pkg⍙constant 'Percy-devel'

∇pkg⍙FAIL_UNLESS_LOADING
 ⍝ Report an INVALID USE error unless the package manager is in its
 ⍝ loading phase.
  →(0≠⎕nc 'pkg⍙loading_path')/0
  ⎕←'INVALID USE of package manager API at run-time'
  →
∇ 

∇selector pkg∆case choices;keys
 ⍝ A case-like control construct to help simplify writing platform-
 ⍝ specific logic.
 ⍝  - selector is one of the platform definition values.
 ⍝  - choices is a list of pairs of values to be matched and
 ⍝    expressions to be executed. One pair may have an empty match
 ⍝    value; this is the default choice.
 ⍝ Example:
 ⍝ pkg∆os_type pkg∆case ('linux' 'fn1') ('osx 'fn2') ('' 'fn3')
  pkg⍙FAIL_UNLESS_LOADING
  ⍎2⊃,⊃((keys∊⊂selector)∨(keys←1⊃¨choices)∊⊂⍬)/choices
∇

∇z←a (relation pkg∆compare_version) b
 ⍝ Return true if relation holds for version numbers. Versions a and b
 ⍝ are numeric vectors. The constant functions pkg⍙⍙version_components
 ⍝ and pkg⍙⍙version_component_limits determine the limits on the
 ⍝ length of the version vector and the upper limit (exclusive) of
 ⍝ each component.
  pkg⍙FAIL_UNLESS_LOADING
  z←a pkg⍙compare_version b
∇

⍝ The umask to be used for the shell command.
'pkg⍙shell_umask' pkg⍙constant '0022'

∇z←pkg∆shell command;cmd
 ⍝ Execute shell command after setting working directory to 
 ⍝ package directory. May be used only while loading a package.
 ⍝ Return shell output.
  pkg⍙FAIL_UNLESS_LOADING
  cmd←'( umask ',pkg⍙shell_umask,' && cd ',pkg⍙loading_path,' && ',command,' )'
  z←⍪pkg⍙sh cmd
∇

∇z←pkg∆copy path;fp;forms
 ⍝ Copy APL file on package-relative path into workspace. May be used
 ⍝ only while loading a package. Return forms report (in same format
 ⍝ as presented by pkg⍙load) and absolute path. Clear SI upon error.
 ⍝ Reports an error if the path is restricted.
  pkg⍙FAIL_UNLESS_LOADING
  ⍎(1=≡path)/'path←⊂path'
  →(∨/pkg⍙restricted_path¨path)/restricted
  fp←pkg⍙concatenate_paths (⊂pkg⍙loading_path),path
  forms←pkg⍙⍙apl_check pkg⍙import_apl fp
  ⍎(⍬≡forms)/'→'
  z←(pkg⍙⍙import_report_format⍕forms) fp
  →0
 restricted: ⎕←' RESTRICTED PATH (pkg∆copy): ',∊path
  →
∇

∇z←pkg∆file path;fi;tm;tc
 ⍝ Return info for path:
 ⍝  file type, size, modification time, creation time, access bits (rwx)
 ⍝ Times are in ⎕ts format.
  pkg⍙FAIL_UNLESS_LOADING
  fi←1 pkg⍙file_info path
  →(0=≡fi)/error
  tm←pkg⍙unix_to_apl_time 8⊃fi
  tc←pkg⍙unix_to_apl_time 9⊃fi
  z←(⊂1⊃fi),(⊂7⊃fi),(⊂tm),(⊂tc),(⊂10⊃fi)
  →0
 error: z←fi
∇

∇z←pkg∆alias name_and_alias
 ⍝ Create an alias to a defined function or operator. The alias may not bear the
 ⍝ prefix of a loaded package. This function simply collects alias definitions
 ⍝ to be processed after all packages have been loaded.
  pkg⍙FAIL_UNLESS_LOADING
  →(0=⎕nc 'pkg⍙load_aliases')/invalid
  →((2≠⍴name_and_alias)∨(2≠≡name_and_alias))/error
  pkg⍙load_aliases←pkg⍙load_aliases,⊂name_and_alias
  z←name_and_alias
  →0
 invalid: ⎕←' ALIAS DEFINITION DISALLOWED WHEN LOADING FROM MANIFEST'
  →
 error: ⎕←' ERROR: ',(⍕name_and_alias),' (pkg∆alias)'
  →
∇
