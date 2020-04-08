⍝ Copyright (c) 2014 David B. Lamkins
⍝ Licensed under the MIT License
⍝ See the LICENSE file included with this software.

⍝ This is the core of APL package dependency management. A package, A,
⍝ is said to depend on another package, B, if A uses functions,
⍝ operators or variables from B. We allow the dependency graph to have
⍝ cycles.

⍝ No package may depend upon the order in which packages in the
⍝ dependency graph are loaded.

∇z←db pkg⍙compute_dependencies start;m;q;v;x;c;d
 ⍝ Returns a two element list containing all dependencies of start and
 ⍝ dependencies of start not present in the db.
 ⍝ IMPLEMENTATION DETAILS:
 ⍝ The dependency database (db) is a list of pairs. Each pair consists
 ⍝ of a package name and that package's list of dependencies.
 ⍝  n 2 ⊃ db   gives list of dependencies for nth package
 ⍝  use ,      to join lists (as in queue and visited)
 ⍝  use ↑      to take first element of list
 ⍝  use 1↓     to drop first element of list
 ⍝  use 0=↑⍴   to check for empty list
  m←↑¨db
  q←v←x←⍬
  c←⊂,start
 more:
  ⍎(~c∊m)/'x←x,c ◊ →missing'
  d←1 2⊃(m∊c)/db
  d←(~d∊q,v)/d
  q←q,d
 missing:
  →(''≡↑c)/none
  v←v,c
 none:
  →(0=↑⍴q)/done
  c←⊂↑q
  q←1↓q
  →more
 done:
  ⍎(pkg⍙⍙visually_empty x)/'x←⍬'
  z←v x
∇

∇z←pkg⍙⍙visually_empty v
 ⍝ True for values that don't print anything (except maybe blanks).
  ⍎(1=≡v)/'z←0=×/⍴v ◊ →0'
  ⍎(2=≡v)/'z←∧/0=×/¨,¨⍴¨v ◊ →0'
  z←0
∇

∇z←pkg⍙get_load_paths name;pn;mn
 ⍝ Return a list of package directory paths for named package and its
 ⍝ dependencies and a list of missing packages.
  (pn mn)←pkg⍙local_dependencies pkg⍙compute_dependencies name
  z←(pkg⍙lookup_path¨pn) mn
  →0
∇

∇z←pkg⍙⍙required_loaded;pnl;pdl;pc;dm;i;dl;di;im;rpi;rpd;ppl;lpv
 ⍝ Return three vectors: required package bitmap, loaded
 ⍝ package bitmap and package names.
  pnl←1⊃¨pkg⍙local_dependencies
  pdl←2⊃¨pkg⍙local_dependencies
  pc←⍴pnl
  dm←(2⍴pc)⍴0
  i←1
 ⍝ Initialize the dependency matrix.
 more:
  →(i>pc)/finish
  dl←i⊃pdl
  →(0=×/∊⍴¨dl)/next
  di←(di≤pc)/di←pnl⍳dl
  dm[i;di]←1
 next:
  i←i+1
  →more
 finish:
 ⍝ Compute the transitive closure of the dependency matrix.
  →(∨/,(dm←dm∨dm∨.∧dm)≠dm)↑⎕lc
 ⍝ Generate a vector of packages loaded by request and those
 ⍝ required as dependencies of the requested loads.
  im←(2⍴pc)⍴1,pc⍴0
  rpd←∨⌿(dm∨im)[rpi←pnl⍳pkg⍙⍙load_requests;]
 ⍝ Generate a vector of loaded packages.
  ppl←,2⊃¨⊃pkg⍙local_metadata pkg⍙collect_metadata 'package_prefix'
  lpv←pc⍴0 ◊ lpv[ppl⍳1⊃¨pkg⍙⍙loaded_packages]←1
 ⍝ Return the three listsi
  z←rpd lpv pnl
∇
