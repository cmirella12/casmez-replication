* Master dofile for all graphs and extensions
* Author: Mirella Charros 
* ECO726 Final Paper Code 

	clear all
	set more off


* --- Root directory (repo root). Run Stata from repo root or set cd before running.
	global ROOT "."

* --- Project folders
	global DO   "$ROOT/do"
	global DATA "$ROOT/data"
	global OUT  "$ROOT/output"
	global FIG  "$OUT/fig"
	global TAB  "$OUT/tab"
	global LOG  "$OUT/log"

* --- Create output folders 
	cap mkdir "$OUT"
	cap mkdir "$FIG"
	cap mkdir "$TAB"
	cap mkdir "$LOG"

* --- Log
	cap log close
	log using "$LOG/master.log", replace text

* --- Required packages
	cap which rdrobust
	if _rc ssc install rdrobust, replace

	cap which texdoc
	if _rc ssc install texdoc, replace

	cap which esttab
	if _rc ssc install estout, replace

* --- Run replication 
	do "$DO/01_replication_fig4.do"
	do "$DO/02_replication_table2.do"


* --- Run extension 
	do "$DO/03_extension.do"

	log close
