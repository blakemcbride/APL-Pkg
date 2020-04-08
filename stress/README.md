APL Package Manager stress test
===============================

This directory contains a simple stress test for the package manager.

Run `./test.sh` to create of a number of test packages in your local
repository. Dependencies among these packages are selected at random.

You can create a large number of packages (up to 10,000) to explore
the performance limits of the package manager's repository scan.

With a smaller number of random packages, you can compare the package
manager's dependency reporting against the dependencies expressed in
the test package metadata.
