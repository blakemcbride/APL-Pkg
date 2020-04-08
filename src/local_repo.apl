⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ I'm establishing a distinction between local and remote
⍝ repositories early on even though the first implementation does
⍝ not support remote repositories.

⍝ Also not yet implemented is the ability to handle multiple
⍝ local repositories.

∇z←pkg⍙local_repository;default
 ⍝ Return a path to the local repository.
  default←pkg⍙concatenate_paths pkg⍙user_home 'workspaces'
  z←'packages_directory' pkg⍙get_config default
∇

∇z←pkg⍙directory_is_package path;h1;h2;u
 ⍝ Return true if path specifies a package directory.
  h1←⎕fio[3] pkg⍙concatenate_paths path pkg⍙⍙control_file
  h2←⎕fio[3] pkg⍙concatenate_paths path pkg⍙⍙metadata_file
  u←(h1≥0)∧(h2≥0)
  ⍎(h1≥0)/'pkg⍙sink (⎕fio[4] h1)'
  ⍎(h2≥0)/'pkg⍙sink (⎕fio[4] h2)'
  z←u≠pkg⍙directory_is_versioned_package path
∇

∇z←pkg⍙versioned_package_paths package_path;dl;d
 ⍝ Return paths to all versions under package_path.
  z←⍬
  dl←⎕fio[29] package_path
 more:
  →(0=⍴dl)/0
  d←,⊃1↑dl
  dl←1↓dl
  z←z,⊂pkg⍙concatenate_paths package_path d
  →more 
∇

∇z←pkg⍙directory_is_versioned_package path
 ⍝ Return true if path specifies a versioned package directory.
  z←⍬⍴0≠⍴pkg⍙get_version_paths path
∇

∇z←pkg⍙get_version_paths path;nl;n;fp;fh
 ⍝ Return a list of paths to version directories, given a package's path.
 ⍝ Return ⍬ if path is not valid. Unreadable directories are ignored.
  z←⍬
  nl←⎕fio[29] path
  →(0=⍴⍴nl)/0
 more:
  →(0=⍴nl)/0
  n←1↑nl
  nl←1↓nl
  fp←path,pkg⍙⍙path_separator,∊n
  fh←⎕fio[3] fp
  →(fh<0)/more
  →('directory'≢∊1↑pkg⍙parse_st_mode 3⊃(⎕fio[18] fh))/close
  ⍎('_version_.'≡10↑∊¯1↑pkg⍙unpack_path fp)/'z←z,⊂fp'
 close:
  pkg⍙sink (⎕fio[4] fh)
  →more
∇

⍝ We cache the local package list.
⍝ Internal use only.
pkg⍙⍙local_packages_db←⍬

⍝ A disabled package is ignored when we rebuild the package list.
⍝ Each entry is a tuple of package path and package prefix.
pkg⍙⍙disabled_packages←⍬

∇pkg⍙load_local_package_list;entries;ignore;directories
 ⍝ Load package list from local repository.
  entries←pkg⍙ls pkg⍙local_repository
  →(0=⍴pkg⍙⍙disabled_packages)/check_entries
  ignore←1⊃¨pkg⍙⍙disabled_packages
  entries←entries~ignore
 check_entries:
  →(0=⍴entries)/fail
  directories←((1⊃¨pkg⍙file_info¨entries)∊⊂'directory')/entries
  pkg⍙⍙local_packages_db←(pkg⍙directory_is_package¨directories)/directories
  →0
 fail: ⎕←'NO PACKAGES - CHECK INSTALLATION'
  →
∇

∇z←pkg⍙local_packages
 ⍝ Return a list of paths to all packages in the local repository.
  →(~⍬≡pkg⍙⍙local_packages_db)/ready
  pkg⍙load_local_package_list
 ready: z←pkg⍙⍙local_packages_db
∇

∇pkg⍙disable_package name;path
 ⍝ Disable named package.
  path←pkg⍙lookup_path name
  →(path≡⊂'')/0
  →(0=⍴pkg⍙⍙disabled_packages)/append
  →(∨/(⊂name)≡¨2⊃¨pkg⍙⍙disabled_packages)/0
 append:
  pkg⍙⍙disabled_packages←pkg⍙⍙disabled_packages,⊂(↑path) name
  pkg⍙load_local_metadata
∇

∇z←pkg⍙disabled_packages
 ⍝ Return a list of disabled package names.
  ⍎(0=⍴pkg⍙⍙disabled_packages)/'z←⍬ ◊ →0'
  z←2⊃¨pkg⍙⍙disabled_packages
∇

∇pkg⍙enable_package name;m
 ⍝ Enable named package.
  →(0=⍴pkg⍙⍙disabled_packages)/0
  m←~(⊂name)≡¨2⊃¨pkg⍙⍙disabled_packages
  pkg⍙⍙disabled_packages←m/pkg⍙⍙disabled_packages
  pkg⍙load_local_metadata
∇

∇pkg⍙enable_all_packages
 ⍝ Enable all packages.
  pkg⍙⍙disabled_packages←⍬
  pkg⍙load_local_metadata
∇

∇z←pkg⍙non_pkg_directories;ls;ad;npd
 ⍝ List all non-package directories in local repository.
  ls←pkg⍙ls pkg⍙local_repository
  ad←(⊂'directory')≡¨↑¨pkg⍙file_info¨ls
  npd←~pkg⍙directory_is_package¨ad/ls
  z←↑¨¯1↑¨pkg⍙unpack_path¨npd/ad/ls
∇
