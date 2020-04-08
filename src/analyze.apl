⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

∇z←pkg⍙has_prefix id
 ⍝ If identifier has a prefix followed by a break character,
 ⍝ return the length of the prefix. Otherwise return 0.
  z←(⎕io+z=⍴id)⌷1 0\z←¯1+⌊/id⍳pkg⍙idX
∇

∇z←new pkg⍙replace_prefix id;w
 ⍝ Replace identifier's prefix.
  w←pkg⍙has_prefix id
  z←((w≠0)/new),w↓id
∇

∇z←pkg⍙get_prefix id
 ⍝ Return identifier's prefix.
  z←(pkg⍙has_prefix id)↑id
  →(0≠⍴z)/0
  z←id
∇

∇z←prefix pkg⍙check_prefix id
 ⍝ Return true if id has a prefix matching the given prefix.
  z←prefix≡pkg⍙get_prefix id
∇

∇z←prefixes pkg⍙rewrite_prefix text;old;new;parsed;len;i;t
 ⍝ Given a list of old and new prefixes, rewrite program text
 ⍝ replacing prefixes.
  z←''
  (old new)←prefixes
  parsed←pkg⍙parse text
  len←⍴parsed
  i←1
 more:
  →(i>len)/0
  t←i⊃parsed
  →(~pkg⍙is_id t)/next
  →(~old pkg⍙check_prefix t)/next
  t←new pkg⍙replace_prefix t
 next:
  z←z,t
  i←i+1
  →more
∇

∇z←(pred pkg⍙filter1) list
 ⍝ Filter items of list according to unary predicate.
  z←(,⊃pred¨list)/list
∇

∇z←arg (pred pkg⍙filter2) list
 ⍝ Filter items of list according to binary predicate.
  →(2>⍴list)/direct
  z←(,⊃(⊂arg) pred¨list)/list
  →0
 direct:
  z←(arg pred ↑list)/list
∇

∇z←arg (fn pkg⍙map2) list
 ⍝ Map binary function over list.
  →(2>⍴list)/direct
  z←(⊂arg) fn¨list
  →0
 direct:
  z←arg fn ↑list
∇

∇z←prefix pkg⍙check_not_prefix id
 ⍝ Return true if id does not have a prefix matching the given prefix.
  z←~(prefix≡id)∨(prefix≡pkg⍙get_prefix id)
∇

∇z←pkg⍙strip_comment text
 ⍝ Strip an APL comment from text.
  z←(~∨\(text='⍝')>≠\text='''')/text
∇

∇z←pkg⍙empty_string text;m
 ⍝ Remove content from quoted string, leaving only a pair of quotes.
 ⍝ This is useful to hide quoted text from analysis.
  z←((¯1⌽m)∨m←~≠\text='''')/text
  z←(~2↓(m,0 0)∧(0 0,m←z=''''))/z
∇

∇z←prefix pkg⍙misnamed_function func
 ⍝ Return true if function (expressed as a list of lines) doesn't
 ⍝ belong in package named by prefix.
  z←prefix pkg⍙check_not_prefix ↑pkg⍙header_info pkg⍙parse 1⊃func
∇

∇z←pkg⍙deparen tokens;rp;lp;dm;pm;im;lm
 ⍝ Given a fully-tokenized list, remove superflous parens. We use this
 ⍝ to simplify identification of strand assignment.
  im←∊~(rp∨lp)∧pm←0≠dm←+\(lp←(⊂,'(')≡¨tokens)-(rp←(⊂,')')≡¨tokens)
  lm←1↓(¯1⌽0=0,∊pm)∧(1=0,∊pm)
  z←(lm∨im)/tokens
∇

∇z←pkg⍙deindex tokens;rp;lp;pm
 ⍝ Given a fully-tokenized list, remove index expressions leaving only
 ⍝ ident[]. We use this to simplify identification of indexed assignment.
  pm←0≠+\(lp←(⊂,'[')≡¨tokens)-(rp←(⊂,']')≡¨tokens)
  z←(~(¯1⌽pm)∧pm)/tokens
∇

∇z←pkg⍙assigned_idents tokens;at;ap;ts;idl;m
 ⍝ Given a fully-tokenized line, return a list of identifiers subject
 ⍝ to assignment. We recognize simple, indexed and strand assignment,
 ⍝ individually or in combination.
 ⍝
 ⍝   NOTE: () and [] may be nested.
 ⍝   (ident ...)←...
 ⍝   ident[...]←...
 ⍝   (ident)[...]←...
 ⍝   ident←...
 ⍝   (fn ident)←...
  z←⍬
 more: →(0=⍴tokens)/filter
  at←tokens⍳⊂,'←'
  ap←at↑tokens
  →(~(,'←')≡1⊃⌽ap)/filter
  →((∧/¨'])'=¨⊂↑¯2↑ap),1)/index,strand,ident
 ident:
  z←z,⊂2⊃⌽ap
  →next
 index:
  ap←pkg⍙deindex ap
  →((,')')≡4⊃⌽ap)/strand
  z←z,⊂4⊃⌽ap
  →next
 strand:
  ts←pkg⍙deparen ap
  idl←(∊(¯1⌽m)∧m←(∨\(⊂,'(')≡¨ts)⍲(∨\(⊂,')')≡¨ts))/ts
  z←z,idl
 next:
  tokens←at↓tokens
  →more
 filter:
  z←pkg⍙is_id pkg⍙filter1 z
∇

⍝ These are the only system variables which may be globally assigned.
'pkg⍙globally_assignable_sys_vars' pkg⍙constant (,'⎕') (,'⍞') '⎕sve' '⎕SVE'

∇z←info pkg⍙invalid_assign tokens;prefix;locals;ids
 ⍝ Given info (a list of package prefix and optional local variables)
 ⍝ return true if tokens contains an assignment that doesn't match
 ⍝ prefix and isn't shadowed by locals.
  z←1
  (prefix locals)←info
  locals←locals,pkg⍙globally_assignable_sys_vars
  ids←pkg⍙assigned_idents tokens
  ids←ids~locals
  →(0=⍴ids)/ok
  →(∨/(⊂prefix) pkg⍙check_not_prefix¨ids)/0
 ok:
  z←0
∇

∇z←prefix pkg⍙analyze_function func;labels;name;locals;tokens;ids
 ⍝ For a function expressed as a list of lines, return a list of all
 ⍝ nonlocal names having a prefix which does not match the given
 ⍝ prefix. This is the list of external references. In the event that
 ⍝ the function name doesn't match the given prefix, return only the
 ⍝ function name enclosed in brackets.
  z←labels←⍬
  (name locals)←pkg⍙header_info pkg⍙parse 1⊃func
  →(~prefix pkg⍙check_prefix name)/fail
 more:
  func←1↓func
  →(0=⍴func)/done
  tokens←pkg⍙parse pkg⍙empty_string pkg⍙strip_comment 1⊃func
  ids←pkg⍙is_id pkg⍙filter1 tokens
  ids←(~ids∊locals)/ids
  labels←labels,pkg⍙label tokens
  z←z,prefix pkg⍙check_not_prefix pkg⍙filter2 ids
  →more
 done:
  z←∪z~labels
  →0
 fail:
  z←'[',name,']'
∇

∇z←pkg⍙function_refs func;labels;name;locals;tokens;ids
 ⍝ For a function expressed as a list of lines, return a list of all
 ⍝ nonlocal names used in the function.
  z←labels←⍬
  (name locals)←pkg⍙header_info pkg⍙parse 1⊃func
 more:
  func←1↓func
  →(0=⍴func)/done
  tokens←pkg⍙parse pkg⍙empty_string pkg⍙strip_comment 1⊃func
  ids←pkg⍙is_id pkg⍙filter1 tokens
  ids←(~ids∊locals)/ids
  labels←labels,pkg⍙label tokens
  z←z,ids
  →more
 done:
  z←∪z~labels
∇

⍝ Function reference cache.
⍝ Each entry is ⊂((⊂name) (⊂timestamp) (⊂reference_list)).
pkg⍙⍙fn_refs_cache←⍬

∇pkg⍙refresh_fn_refs;ft;all;outdated;fdef;times;fn;fns;names;i;entry;new;refs
 ⍝ Refresh pkg⍙⍙fn_refs_cache.
  ft←0=⍴pkg⍙⍙fn_refs_cache
  ⍎(ft)/'⎕←⊂''Building complete function references cache...'''
  all←pkg⍙⍙strip_trailing_blanks¨⊂[2]⎕nl 3 4
  →(0=⍴pkg⍙⍙fn_refs_cache)/add_new
 ⍝ Remove deleted
  pkg⍙⍙fn_refs_cache←(~(1⊃¨pkg⍙⍙fn_refs_cache)∊⊂¨all)/pkg⍙⍙fn_refs_cache
 ⍝ Update changed
  →(0=⍴pkg⍙⍙fn_refs_cache)/add_new
  outdated←⍬
  names←1⊃¨pkg⍙⍙fn_refs_cache
  times←2⊃¨pkg⍙⍙fn_refs_cache
  fns←all
 more1: →(0=⍴fns)/update
  fn←↑fns
  fns←1↓fns
  i←names⍳⊂fn
  →(i>⍴names)/more1
  →(times[i]≡⊂2 ⎕at fn)/more1
  outdated←outdated,⊂fn
  →more1
 update:
  names←1⊃¨pkg⍙⍙fn_refs_cache
  pkg⍙⍙fn_refs_cache←(~names∊outdated)/pkg⍙⍙fn_refs_cache
 more2: →(0=⍴outdated)/add_new
  fn←↑outdated
  outdated←1↓outdated
  fdef←⊂[2]⎕cr fn
  →(0=⍴fdef)/more2  
  entry←⊂(fn) (2 ⎕at fn) ((⊂⍋⊃refs)⌷refs←pkg⍙function_refs fdef)
  pkg⍙⍙fn_refs_cache←pkg⍙⍙fn_refs_cache,entry
  →more2
 ⍝ Add new
 add_new:
  new←all
  →(0=⍴pkg⍙⍙fn_refs_cache)/more3
  new←(~all∊1⊃¨pkg⍙⍙fn_refs_cache)/all
 more3: →(0=⍴new)/done
  fn←↑new
  new←1↓new
  fdef←⊂[2]⎕cr fn
  →(0=⍴fdef)/more3  
  entry←⊂(fn) (2 ⎕at fn) ((⊂⍋⊃refs)⌷refs←pkg⍙function_refs fdef)
  pkg⍙⍙fn_refs_cache←pkg⍙⍙fn_refs_cache,entry
  →more3
 done:
  ⍎(ft)/'⎕←⊂''Done. Updates will be done incrementally.'' ◊ ⎕←'''''
∇

∇control pkg⍙_ref_tree name;depth;visited;nc;isdef;ol;fn;m;refs;i
 ⍝ Build a display of references from name.
 ⍝ Caller defines _output and _expanded, both initialized to ⍬.
 ⍝ Caller defines _depth_limit; 0 is unlimited.
 ⍝ Caller passes (0 ⍬) as control argument.
 ⍝ Caller prints _output.
  (depth visited)←control
  →((0<_limit)∧(_limit<depth))/0
  nc←⎕nc name
  isdef←∨/3 4=nc
  ol←' *'[⎕io+(⊂name)∊visited],'-~LVFOvf'[1+⎕io+nc],'| '
  ol←' ^'[⎕io+((⊂name)∊_expanded)∧isdef],ol,((2×depth)⍴'. '),name
  _output←_output,⊂ol
  visited←visited,⊂name
  →(0=⍴_expanded)/lookup
  →((⊂name)∊_expanded)/0
 lookup:
  _expanded←_expanded,⊂name
  →(~isdef)/0
  i←_funs⍳⊂name
  →(i>⍴_funs)/0
  refs←↑_refs[i]
  →(0=⍴refs)/0
  (⊂((depth + 1) visited)) pkg⍙_ref_tree¨refs
∇

∇z←depth_limit pkg⍙ref_tree name;_funs;_refs;_limit;_output;_expanded;legend
 ⍝ Return a display, including legend, of the reference tree starting
 ⍝ at name. Limit to depth levels; 0 is unlimited.
  pkg⍙refresh_fn_refs
  _funs←1⊃¨pkg⍙⍙fn_refs_cache
  _refs←3⊃¨pkg⍙⍙fn_refs_cache
  _limit←depth_limit
  _output←_expanded←⍬
  (0 ⍬) pkg⍙_ref_tree name
  legend←       ⊂'     ^: expanded above; *: recursive; -: other; ~: dynamic;'
  legend←legend,⊂'     V: variable; F: defined function; O: defined operator;'
  legend←legend,⊂'___  v: system variable; f: system function'
  z←⍪legend,_output
∇

∇z←pkg⍙who_refs name;names;fns;cached_funs;cached_refs;fn;i;refs;fname
 ⍝ Return a list of functions and operators that reference name.
  pkg⍙refresh_fn_refs
  names←⍬
  fns←pkg⍙⍙strip_trailing_blanks¨⊂[2]⎕nl 3 4
  cached_funs←1⊃¨pkg⍙⍙fn_refs_cache
  cached_refs←3⊃¨pkg⍙⍙fn_refs_cache
 more: →(0=⍴fns)/done
  fname←↑fns
  fns←1↓fns
  i←cached_funs⍳⊂fname
  →(i>⍴pkg⍙⍙fn_refs_cache)/more
  refs←↑cached_refs[i]
  →(~(⊂name)∊refs)/more
  names←∪names,⊂fname
  →more
 done:
  z←(⊂⍋⊃names)⌷names
∇

∇z←pkg⍙all_fns
 ⍝ Return a list of all function names.
  pkg⍙refresh_fn_refs
  z←1⊃¨pkg⍙⍙fn_refs_cache
∇

∇z←pkg⍙all_fn_refs
 ⍝ Return a list of all functions referenced.
  pkg⍙refresh_fn_refs
  z←∪↑,/3⊃¨pkg⍙⍙fn_refs_cache
∇

∇z←pkg⍙all_vars
 ⍝ Return a list of all defined global variables.
  z←pkg⍙⍙strip_trailing_blanks¨⊂[2]⎕nl 2
∇

∇z←pkg⍙time exp;_b;_c;_t;_r;_m
 ⍝ Execute expression and report elapsed time.
  z←1
  _b←⎕ts
  (_c _t _r)←⎕ec exp
  _m←(24 60 60 1000⊥3↓⎕ts)-24 60 60 1000⊥3↓_b
  ⎕←_r
  ⎕←'Elapsed:' (⍕_m),'ms'
∇
