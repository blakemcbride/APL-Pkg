⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ This is the start of a platform probe.

⍝ All code in this section must be compatible with ISO 13751 APL. All
⍝ potential errors must be trapped.

⍝ This code must run to completion on all platforms supported by the
⍝ package manager.

⍝ This is preliminary; we expect to be running in GNU APL on Linux.
⍝ To implement multiplatform support, we must guard tests according
⍝ to the platform actually in use; that platform must in turn be
⍝ detected by the probes.

⍝ Return true if we think we're running under GNU APL.
∇z←pkg⍙⍙probe_gnu_apl_type
  z←(5=⎕nc '⎕syl')∧(6=⎕nc '⎕env')
∇

⍝ Return true if we think we're running under Linux.
∇z←pkg⍙⍙probe_linux_os_type
  z←'Linux'≡↑pkg⍙sh 'uname -s'
∇

⍝ Return true if we think the shell is bash.
∇z←pkg⍙⍙probe_bash_shell_type
  z←'bash'≡¯4↑pkg⍙env 'SHELL'
∇

⍝ Return true if we think the shell is dash.
∇z←pkg⍙⍙probe_dash_shell_type
  z←'dash'≡¯4↑pkg⍙env 'SHELL'
∇

⍝ Return true if we think the shell is fish.
∇z←pkg⍙⍙probe_fish_shell_type
  z←'fish'≡¯4↑pkg⍙env 'SHELL'
∇

⍝ Return true if we think the shell is ksh.
∇z←pkg⍙⍙probe_ksh_shell_type
  z←'ksh'≡¯3↑pkg⍙env 'SHELL'
∇

⍝ Return true if we think the shell is yash.
∇z←pkg⍙⍙probe_yash_shell_type
  z←'yash'≡¯4↑pkg⍙env 'SHELL'
∇

⍝ Return true if we think the shell is zsh.
∇z←pkg⍙⍙probe_zsh_shell_type
  z←'zsh'≡¯4↑pkg⍙env 'SHELL'
∇

⍝ Return true if we think the OS distribution is Fedora.
∇z←pkg⍙⍙probe_fedora_os_distribution
  z←'yes'≡↑pkg⍙sh 'grep fedora /etc/os-release > /dev/null && echo yes'
∇

⍝ Return true if we think the OS distribution is Ubuntu.
∇z←pkg⍙⍙probe_ubuntu_os_distribution
  z←'yes'≡↑pkg⍙sh 'grep ubuntu /etc/os-release > /dev/null && echo yes'
∇

⍝ Return true if we think the OS distribution is Debian.
∇z←pkg⍙⍙probe_debian_os_distribution
  z←'yes'≡↑pkg⍙sh 'grep debian /etc/os-release > /dev/null && echo yes'
∇

∇pkg⍙⍙run_probe args;probe_name;new_value;cfn;tfn;tr
 ⍝ Given a probe name <n> and a new value <v>:
 ⍝  if the value of executing pkg∆<n> is 'unknown', then
 ⍝    execute pkg⍙⍙probe_<v>_<n>
 ⍝    if execution succeeds and returns true, then
 ⍝     define a constant function pkg∆<n> which returns <v> .
 ⍝ NOTE: <n> and <v> must be valid as part of an APL identifier.
  (probe_name new_value)←args
  cfn←'pkg∆',probe_name
  tfn←'pkg⍙⍙probe_',new_value,'_',probe_name
  →(~'unknown'≡⍎cfn)/0
  tr←'0' ⎕ea tfn
  →(~tr)/0
  cfn pkg⍙constant new_value
∇

⍝ Here's an example of using platform probes.
pkg⍙⍙run_probe 'apl_type' 'gnu'
pkg⍙⍙run_probe 'os_type' 'linux'
pkg⍙⍙run_probe 'shell_type' 'bash'
pkg⍙⍙run_probe 'shell_type' 'dash'
pkg⍙⍙run_probe 'shell_type' 'fish'
pkg⍙⍙run_probe 'shell_type' 'ksh'
pkg⍙⍙run_probe 'shell_type' 'yash'
pkg⍙⍙run_probe 'shell_type' 'zsh'
pkg⍙⍙run_probe 'os_distribution' 'fedora'
pkg⍙⍙run_probe 'os_distribution' 'ubuntu'
pkg⍙⍙run_probe 'os_distribution' 'debian'

∇z←pkg⍙parse_external_version v;dig;sep;flg;b
 ⍝ Parse a version number. The number is assumed to have decimal
 ⍝ components separated by certain non-digit characters. If the
 ⍝ assumptions are not met, return 'not-parsed'. Otherwise, return a
 ⍝ string in which the numeric components are separated by spaces.
  z←'not-parsed'
  dig←'1234567890'
  sep←'.-;,/: '
  flg←'MPS' ⍝ flags: treat as separator
  →(~∧/v∊dig,sep,flg)/0
  z←v
  z[(z∊sep,flg)/⍳⍴z]←' '
  z←(~(1⌽b)∧b←z∊' ')/z
∇

⍝ We might also extract information without a probe.

∇z←pkg⍙extract_version text
 ⍝ Given a textual version string, extract the version as a numeric vector.
  z←pkg⍙parse_version pkg⍙parse_external_version text
∇

∇z←pkg⍙isolate_version text;dig;sep;head
 ⍝ Given a line of text that may contain a version string, isolate the 
 ⍝ first substring that looks like a dotted version number.
  dig←'1234567890'
  sep←'.'
  head←(∨\text∊dig,sep)/text
  z←(∧\head∊dig,sep)/head
∇

∇z←pkg⍙sh_cmd_version cmd
 ⍝ Extract a version number from a shell command, typically <cmd> -v
 ⍝ or cmd --version. The version number is assumed to be the first
 ⍝ dotted number on the first line of the command's response.
  z←pkg⍙extract_version pkg⍙isolate_version 1⌷[1]⊃pkg⍙sh cmd
∇

⍎pkg⍙⍙probe_bash_shell_type/'pkg_←pkg⍙sh_cmd_version ''bash --version'''
⍎pkg⍙⍙probe_fish_shell_type/'pkg_←pkg⍙sh_cmd_version ''fish --version'''
⍎pkg⍙⍙probe_yash_shell_type/'pkg_←pkg⍙sh_cmd_version ''yash --version'''
⍎(0=⎕nc 'pkg_')/'pkg_←''unknown'''
'pkg∆shell_version' pkg⍙constant pkg_
pkg⍙sink ⎕ex 'pkg_'

⍝ When we support other platforms, these *must be* guarded.
pkg_←'awk -F= ''/^VERSION_ID/ { print $2 }'' < /etc/os-release'
'pkg∆os_version' pkg⍙constant pkg⍙extract_version ↑pkg⍙sh pkg_
pkg⍙sink ⎕ex 'pkg_'
pkg_←'apl -v 2>/dev/null | awk ''/Version/ { print gensub (/^.*: /, "", 1) }'''
'pkg∆apl_version' pkg⍙constant pkg⍙extract_version ↑pkg⍙sh pkg_
pkg⍙sink ⎕ex 'pkg_'
