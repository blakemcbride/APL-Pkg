The maint/commit git wrapper
============================

Commits should be made using the `maint/commit` script. The script checks
file content, updates the version number in the package metadata, records
the extant GNU APL version, checks for unindexed files and prompts for
inclusion of unstaged files.

The git commit hook is used to provide a gentle reminder to use
`maint/commit` rather than `git commit`; install the hook using the
`maint/install-git-hooks` script.

The `maint/commit` script has two required parameters: a version option
and a commit message.

The version option is one of `-maj`, `-min`, `-fix` or `-git` (or
their synonyms: `-1` through `-4`). The first three correspond to the
components of a semantic version number. Specifying one of these options
will increment that specific version number and reset the less significant
numbers in the group.

For example, specifying `-fix` increments the third component of the
version number; the leading components are unaffected. Specifying `-min`
increments the second component of the version number and resets the
third to zero.

In all cases, the fourth component of the version number is incremented;
this component corresponds to the count of git commits, which is always
nondecreasing. The `-git` option may be used when committing changes
that will not be seen by users or to amend an immediately preceding
commit to add forgotten changes (again: assuming that users have not
already seen the previously committed version).

The second required parameter is the commit message, which should be
concise and descriptive. Although remaining arguments on the command
line will by collected to form the commit message, this parameter
should normally be quoted to avoid unexpected interpretation of shell
metacharacters.
