# Replication of "Government Transfers and Votes for State Intervention"

**Author:** Mirella Charros  
**Course:** ECO 726 – Policy Evaluation  
**Original paper:** Albanese, de Blasio, and Incoronato (2024), *AEJ: Economic Policy*

## Overview
This repository replicates key results from *Government Transfers and Votes for State Intervention* using a spatial regression discontinuity design. The replication reproduces the main RD figures and baseline estimates and extends the analysis by examining heterogeneity in treatment effects by municipality type.

## Data
The analysis uses a simplified version of the original dataset provided by the authors:
- `data/casmez_replication.csv`

## Code
All analysis is run through a single master file:

```stata
00_master_replication.do
