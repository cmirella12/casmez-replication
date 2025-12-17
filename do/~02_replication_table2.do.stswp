* Table 2 - Baseline RD Estimates (CSV-only, bw=47)
* Replicator: Mirella Charros

	set more off

* --- Settings
	local bw = 47
	global covs_reg "i.segm3 i.codprov_istat"

* --- Load CSV
	import delimited using "$DATA/casmez_replication.csv", clear
	cap destring year km casmez index_stateint segm3 codprov_istat codistat, replace force

* --- Drop any existing dummy vars
	cap drop seg_*
	cap drop prov_*
	cap drop yr_*

* --- Build dummy covariates for rdrobust (NO factor vars allowed)


	* Segment dummies: seg_1 seg_2 seg_3
	quietly tab segm3, gen(seg_)

	* Province dummies: prov_1 ... prov_K
	quietly tab codprov_istat, gen(prov_)

	* Base covariates list for rdrobust:
	global covs_rb ""

	cap confirm variable seg_2
	if !_rc global covs_rb "$covs_rb seg_2"
	cap confirm variable seg_3
	if !_rc global covs_rb "$covs_rb seg_3"

	* Add all prov_* except prov_1 (robustly)
	cap unab provlist : prov_*
	if !_rc {
		local provlist "`provlist'"
		cap confirm variable prov_1
		if !_rc local provlist : list provlist - prov_1
		global covs_rb "$covs_rb `provlist'"
}


* --- (2) 2013 only

	* Parametric (linear) RD
	qui reg index_stateint casmez c.km $covs_reg if year==2013 & abs(km)<`bw', robust
	local b2013p  : display %10.2f _b[casmez]
	local se2013p : display %10.2f _se[casmez]

	* Nonparametric RD (rdrobust)
	qui rdrobust index_stateint km if year==2013 & abs(km)<`bw', ///
		c(0) p(1) h(`bw' `bw') kernel(tri) ///
		covs($covs_rb)
	local b2013np  : display %10.2f e(tau_bc)
	local se2013np : display %10.2f e(se_tau_rb)

	* Summary stats
	qui sum index_stateint if year==2013 & abs(km)<`bw'
	local mean2013 : display %10.2f r(mean)
	local sd2013   : display %10.2f r(sd)
	local n2013    : display %10.0f r(N)

* --- (1) pooled 1994–2018

	* Parametric pooled RD (with year FE)
	qui reg index_stateint casmez c.km $covs_reg i.year ///
		if inrange(year,1994,2018) & abs(km)<`bw', robust
	local bpoolp  : display %10.2f _b[casmez]
	local sepoolp : display %10.2f _se[casmez]

	* Year dummies for rdrobust (no i.year allowed)
	quietly tab year if inrange(year,1994,2018), gen(yr_)

	cap unab yrlist : yr_*
	if _rc local yrlist ""
	else {
		cap confirm variable yr_1
		if !_rc local yrlist : list yrlist - yr_1
}

	qui rdrobust index_stateint km if inrange(year,1994,2018) & abs(km)<`bw', ///
		c(0) p(1) h(`bw' `bw') kernel(tri) ///
		covs($covs_rb `yrlist')
	local bpoolnp  : display %10.2f e(tau_bc)
	local sepoolnp : display %10.2f e(se_tau_rb)

	* Summary stats pooled (within estimation window)
	qui sum index_stateint if inrange(year,1994,2018) & abs(km)<`bw'
	local meanpool : display %10.2f r(mean)
	local sdpool   : display %10.2f r(sd)
	local npool    : display %10.0f r(N)


* --- Export LaTeX table (texdoc)

	cap which texdoc
	if _rc ssc install texdoc, replace

texdoc init "$TAB/Tab2_replication.tex", replace force

tex \begin{tabular}{lcc}
tex \hline\hline
tex \textit{Outcome variable:} & \multicolumn{1}{c}{All elections 1994--2018} & \multicolumn{1}{c}{2013 election} \\
tex \textit{Support for state intervention} & \multicolumn{1}{c}{(1)} & \multicolumn{1}{c}{(2)} \\
tex \hline\hline
tex \\
tex \multicolumn{3}{l}{\textit{Panel (a): Parametric (linear) estimates}} \\
tex RD estimate & `bpoolp' & `b2013p' \\
tex            & (`sepoolp') & (`se2013p') \\
tex \\
tex \multicolumn{3}{l}{\textit{Panel (b): Non-parametric estimates}} \\
tex RD estimate & `bpoolnp' & `b2013np' \\
tex            & (`sepoolnp') & (`se2013np') \\
tex \hline
tex Bandwidth (km) & `bw' & `bw' \\
tex Observations   & `npool' & `n2013' \\
tex Mean           & `meanpool' & `mean2013' \\
tex Standard deviation & `sdpool' & `sd2013' \\
tex \hline\hline
tex \end{tabular}

texdoc close

di as txt "Saved: $TAB/Tab2_replication.tex"
