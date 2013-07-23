
PLOTDIR = plots
RESULTSFILENAME = results

package-results-zip:
	zip -r $(RESULTSFILENAME).zip $(PLOTDIR)/plant_0*

package-results-bzip:
	tar -cvjf $(RESULTSFILENAME).tar.bz2 $(PLOTDIR)
