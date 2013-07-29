These files attempt to identify the gains in the structural human operator
control model for simple line tracking tasks with different plants.

Dependencies
------------

I wrote the software with these versions, but older versions may work too.

- Matlab 8.1.0.604 (R2013a)
- Control System Toolbox Version 9.5 (R2013a)
- Matlab System Identification Toolbox Version 8.2 (R2013a)

Use
---

To run, download the code:

$ git clone git://github.com/moorepants/structuralid.git
$ cd structuralid

Then get the data and extract it to the data directory:

$ wget http://files.figshare.com/1134580/structuralid_data.tar.bz2
$ tar -xjf structuralid-data.tar.bz2

Now open Matlab and execute `run.m` to run the basic identification.

>> run([1, 2, 3, 4, 7, 8], 'all', 'both')

The plots are generated in the `plots` directory and the results are printed to
the terminal.

Also, the `fit_adadpt.m` and `fit_adapt_linear.m` can be run to attempt to
identify the time varying dynamics. `fit_adapt.m` currenlty does not home in on
any results.

TODO
----

- Identify the controller without the plant so that the noise matrix is smaller.
- Identify ARMAX models of the controller.
