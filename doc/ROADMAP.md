Release Roadmap for APL Package Manager
=======================================

This is a roadmap for APL Package Manager releases. This is subject to
change on a whim. It's here mainly to give you an idea of what's in
store and in what order new features and functionality are likely to
appear.

### Releases

| Name        | Version | Features                       | Platforms        |
| ----------- | ------- | ------------------------------ | ---------------- |
| placeholder | 0 0 0   | prerelease work                | GNU APL on Linux |
| Netochka    | 0 1 0   | basic package loading          | GNU APL on Linux |
| Wibble      | 0 2 0   | package prefix clash avoidance | GNU APL on Linux |
|             |         | program analysis tools         |                  |
| Evey        | 0 3 0   | selective loading              | GNU APL on Linux |
|             |         | recursive unloading            |                  |
| Percy       | 0 4 0   | versioned packaging            | GNU APL on Linux |
| Booberry    | 0 5 0   | local search path              | GNU APL on Linux |
| Lily        | 0 6 0   | extended platform support      | TBD              |
| Spencer     | TBD     | remote repository support      | TBD              |
| Boogieman   | TBD     | non-Unicode APL support        | TBD              |
| Mia         | TBD     | TBD                            | TBD              |

### Audience

| Name        |  # D | # O | # C | # P | Coordination |
| ----------- |  :-: | :-: | :-: | :-: | :----------: |
| placeholder |  1   | 0   | 0   | 1   | N/A          |
| Netochka    |  >1  | 1   | 1   | 1   | local        |
| Wibble      |  >1  | >1  | 1   | 1   | manual       |
| Evey        |  >1  | >1  | 1   | 1   | manual       |
| Percy       |  >1  | >1  | >1  | 1   | manual       |
| Booberry    |  >1  | >1  | >1  | 1   | manual       |
| Lily        |  >1  | >1  | >1  | >1  | manual       |
| Spencer     |  >1  | >1  | >1  | >1  | distributed  |
| Boogieman   |  >1  | >1  | >1  | >1  | distributed  |
| Mia         |  >1  | >1  | >1  | >1  | distributed  |

The release name appears as the value of `pkg∆manager` when the
package manager is loaded.

The version is the first release version of the series having the
indicated features. The version is in the package manager's metadata
as `package_version`.

The audience for the package manager is defined as the combination of
four factors:

1. **# D**: Number of Developers - where a developer is a programmer
   creating and using packages.
2. **# O**: Number of Organizations - where an organization is a
   collection of developers working in close conjunction. An
   organization is not necessarily physically colocated.
3. **# C**: Number of Communities - where a community is a collection
   of developers and organization focused on the shared development
   of a package.
4. **# P**: Number of Platforms - where a platform is a combination of
   host environment and APL environment.

The anticipated coordination style is one of:

1. **local** - Developers are in close contact with one another (not
   necessarily physically colocated) to ensure interoperability among
   packages.
2. **manual** - Developers have a bit more independence as the
   platform manager evolves to provide tools to mitigate some of the
   close coordination needed to ensure interoperability among
   packages.
3. **distributed** - The now-mature package manager supports fully
   distributed collaboration with a minimum of tedious housekeeping.

### Dates

| Name        | Date       |
| ----------- | ---------- |
| placeholder | 2014-04-27 |
| Netochka    | 2014-08-09 |
| Wibble      | 2015-04-01 |
| Evey        | 2015-10-06 |
| Percy       |            |
| Booberry    |            |
| Lily        |            |
| Spencer     |            |
| Boogieman   |            |
| Mia         |            |
