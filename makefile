DATADIR = data
DATAFILENAME = structuralid_data
PLOTDIR = plots
RESULTSFILENAME = structuralid_results

package-data:
	mv data/$(DATAFILENAME).tar.bz2 data/~$(DATAFILENAME).tar.bz2
	tar -cvjf $(DATAFILENAME).tar.bz2 data/plant_*.mat data/adapt_hard.mat data/initial_parameters.csv
	mv $(DATAFILENAME).tar.bz2 data/$(DATAFILENAME).tar.bz2

package-results-zip:
	zip -r $(RESULTSFILENAME).zip $(PLOTDIR)/plant_0* results.csv

package-results-bzip:
	tar -cvjf $(RESULTSFILENAME).tar.bz2 $(PLOTDIR)/plant_0* results.csv
