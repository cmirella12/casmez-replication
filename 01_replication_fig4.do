* --- Replicate Figure 4 (CSV-only)

	set more off

* --- Load data
	import delimited using "$DATA/casmez_replication.csv", clear

* --- Ensure numeric (safe even if already numeric)
	cap destring year km casmez index_stateint segm3 codprov_istat codistat, replace force

* --- RD package
	cap which rdrobust
	if _rc ssc install rdrobust, replace

* --- Bandwidth = 47km (paper baseline)
	local bw = 47

* --- Top panel: pooled 1994–2018
	rdplot index_stateint km if inrange(year,1994,2018) & abs(km)<100, ///
		c(0) p(1) h(`bw' `bw') kernel(tri) ///
		graph_options(name(stateint9418, replace) nodraw) ///
		title("1994–2018")

* --- Bottom panel: 2013 only
	rdplot index_stateint km if year==2013 & abs(km)<100, ///
		c(0) p(1) h(`bw' `bw') kernel(tri) ///
		graph_options(name(stateint2013, replace) nodraw) ///
		title("2013")

* --- Combine and export
	graph combine stateint9418 stateint2013, rows(2) graphregion(color(white))
	graph export "$FIG/Fig4_MWE.pdf", replace
