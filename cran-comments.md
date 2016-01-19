## Test environments
* Windows 7 x64, R 3.2.2
* ubuntu 12.04, R 3.2.2

### R CMD check results

## Second submission changes

* Add xml2 to SUGGESTS to fix failing unit test

There were 0 ERRORs, 0 WARNINGS, 1 NOTE:

* checking installed package size ... NOTE
  installed size is 15.1Mb
  sub-directories of 1Mb or more:
    data  data  15.0Mb

  The package is a pure data package, and has been compressed with "xz", as
  recommended by tools::checkRdaFiles(). It contains no additional
  documentation.

### Changes in version 0.2:

* Updated data
* Added unit tests