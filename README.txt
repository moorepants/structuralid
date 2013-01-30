These files attempt to identify the gains in the structural human operator
control model for simple line tracking tasks.

Dependencies
------------

I wrote the software with these versions, but older versions may work too.

- Matlab 7.10.0.499 (R2010a)
- Control System Toolbox Version 8.5 (R2010a)
- Matlab System Identification Toolbox Version 7.4 (R2010a)

Use
---

To run, download the code:

$ git clone git://github.com/moorepants/structuralid.git
$ cd structuralid

Then get the data and extract it to the data directory:

$ wget http://figshare.com/media/download/98814/100241 -O structuralid-data.tar.bz2
$ tar -xjf structuralid-data.tar.bz2

Now open Matlab and execute `run_all.m` to run the basic identification.

>> run_all

The plots are generated in the `plots` directory and the results are printed to
the terminal.
