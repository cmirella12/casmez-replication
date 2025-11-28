* Import CSV and replicate main RD graph 

    clear all
    set more off 

	global PATH "~/Documents/ECO726/out"
    import delimited using "$PATH/casmez_replication.csv", clear 
	
* Install RD package 
    cap which rdrobust 
	if _rc ssc install rdrobust, replace 
	
* set bandwidth = 47km (paper baseline)
   local bw = 47 
   

* Top panel: pooled 1994–2018
rdplot index_stateint km if inrange(year,1994,2018) & abs(km)<100, ///
    c(0) p(1) h(`bw' `bw') kernel(tri) ///
	graph_options(name(stateint9418, replace) nodraw) ///
    title("1994–2018")
graph describe stateint9418

* Bottom panel: 2013
rdplot index_stateint km if year==2013 & abs(km)<100, ///
    c(0) p(1) h(`bw' `bw') kernel(tri) ///
    title("2013") ///
	graph_options(name(stateint2013, replace) nodraw) 
	
	graph describe stateint2013

gr combine stateint9418 stateint2013, rows(2) graphregion(color(white))
graph export "$PATH/Fig4_MWE.pdf", replace

