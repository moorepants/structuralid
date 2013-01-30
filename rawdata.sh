#!/usr/bin/bash

filename="structuralid_data.tar.bz2"
mv data/$filename data/~$filename
tar -cvjf $filename data/jason_*.mat data/adapt_hard.mat data/initial_parameters.csv
mv $filename data/$filename
