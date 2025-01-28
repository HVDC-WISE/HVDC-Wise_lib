---
layout: page 
title: HVDC MMC - Emergency Power Control (EPC)
tags: ["Multiterminal", "HVDC", "CIM", "RMS", "EPC"] 
date: 18/10/2024 
last-updated: 18/10/2024
authors: Said Cosic (TTG)
reviewers: 
---

## Context

Emergency Power Control according to TenneT TSO GmbH specification .

## Model use, assumptions, validity domain and limitations

The model can be used for transient stability analysis and carrying out fundamental investigations on generic network models, as well as to assess potential network expansions with multi-terminal HVDC systems with regard to the electrical behavior.

**Assumptions and limitations:**

 - The rated power Sr of the HVDC converter must be entered.
 - To start EPC functions 5, 6 and 7, the corresponding EPC signals must be present for at least the configurable time period T_delay.
 
## Model description 

The model consists of the following parameters:

| Parameter      | Unit | Description |
| --------------------------------| ----------------------------------- | ---------------------------------------------------- |
|	dP_epc	|	p.u.	|	Additional active power by EPC	|
|	dP_EPC2	|	MW/s	|	Max. power limitation gradient (EPC2)	|
|	dP_EPC3	|	MW/s	|	Max. power limitation gradient (EPC3)	|
|	dP_EPC5	|	MW/s	|	Maximum power gradient (EPC5)	|
|	dP_epc5	|	p.u.	|	Additional active power by EPC Function 5	|
|	dP_EPC6	|	MW/s	|	Maximum power gradient (EPC6)	|
|	dP_epc6	|	p.u.	|	Additional active power by EPC Function 6	|
|	dP_EPC7	|	MW/s	|	Maximum power gradient (EPC7)	|
|	dP_epc7	|	p.u.	|	Additional active power by EPC Function 7	|
|	EPC_Blocking_A	|		|	Emergency Power Control Blocking Signal A	|
|	EPC_Blocking_B	|		|	Emergency Power Control Blocking Signal B	|
|	EPC_flag	|		|	General EPC activation flag	|
|	EPC1	|		|	Trigger Emergency Power Control Function 1	|
|	EPC2	|		|	Trigger Emergency Power Control Function 2	|
|	EPC3	|		|	Trigger Emergency Power Control Function 3	|
|	EPC4	|		|	Trigger Emergency Power Control Function 4	|
|	EPC5	|		|	Trigger Emergency Power Control Function 5	|
|	EPC6	|		|	Trigger Emergency Power Control Function 6	|
|	EPC7	|		|	Trigger Emergency Power Control Function 7	|
|	EPC8	|		|	Trigger Emergency Power Control Function 8	|
|	ori_block_A	|		|	Orientation Blocking A: 0=rectifier, 1=inverter	|
|	P	|	p.u.	|	Active power	|
|	P_EPC5	|	MW	|	Additional active power (EPC5)	|
|	P_EPC6	|	MW	|	Additional active power (EPC6)	|
|	P_EPC7	|	MW	|	Additional active power (EPC7)	|
|	P_incA	|	p.u.	|	Active power flow at beginning of Blocking A	|
|	P_incB	|	p.u.	|	Active power flow at beginning of Blocking B	|
|	Pmax_epc	|	p.u.	|	Maximum power limitation by EPC	|
|	Pmax_epc1	|	p.u.	|	Maximum power limitation by EPC function 1	|
|	Pmax_epc2	|	p.u.	|	Maximum power limitation by EPC function 2	|
|	Pmax_epc3	|	p.u.	|	Maximum power limitation by EPC function 3	|
|	Pmax_inc	|	p.u.	|	Maximum power limitation without EPC	|
|	Pmin_epc	|	p.u.	|	Minimum power limitation by EPC	|
|	Pmin_epc1	|	p.u.	|	Minimum power limitation by EPC function 1	|
|	Pmin_epc2	|	p.u.	|	Minimum power limitation by EPC function 2	|
|	Pmin_epc3	|	p.u.	|	Minimum power limitation by EPC function 3	|
|	Pmin_inc	|	p.u.	|	Minimum power limitation without EPC	|
|	Sr	|	MVA	|	Rated power of converter	|
|	T_delay	|	s	|	Time delay for starting EPC functions 5 - 7	|
|	T_hold	|	s	|	Minimum time delay between EPC5 - EPC7	|

Emergency Power Control (EPC) sets EPC functions 1 through 8 according to TenneT's internal specifications. 
The EPC functions are controlled via the binary input signals EPC1 to EPC8. The blocking of EPC functions is also activated via the binary input signals EPC_Blocking_A (blocking function A) and EPC_Blocking_B (blocking function B).  Some of the characteristics of the EPC functions are hardcoded
according to the specifications or can otherwise be set using the parameters dP_EPC2, dP_EPC3, P_EPC5, dP_EPC5, P_EPC6, dP_EPC6, P_EPC7 and dP_EPC7.
The EPC functions 5, 6 and 7 start with a corresponding time delay of T_delay. Between the fully deploying an EPC function 5, 6 or 7 and starting another EPC function 5,6 or 7, a time delay of T_hold can be specified. 
The orientation of the blocking function A (rectifier or inverter operation) is set via the parameter ori_block_A.

## Model exchange

The dynamic model is serialized in [CIM xml file](https://supergridinstitute.sharepoint.com/:f:/r/sites/HVDC-WISE/Documents%20partages/WP4%20-%20Enabling%20technologies/D4.3/HVDC-Wise_lib_internal/Artifacts_%26_equations/HVDC_MMC/DMC_EPC.xml) using DetailedModelConfigurationProfile of IEC 61970-457:2024 ([[1]](#1)), as well as Modelica code.
The CIM model includes classes needed to exchange the dynamic model configuration, i.e. the structure and connectivity of a detailed model, whereas the Modelica model includes equations which explicitly describe the model dynamics.


## Table of references & license

<a id="1">[1]</a>  International Electrotechnical Commission TC 57, “[Energy management system application program interface (EMS-API) - Part 457: Dynamics profile](https://webstore.iec.ch/en/publication/68910),” IEC, 2024.
