---
layout: page 
title: Grid-following inverter
tags: ["Three-phase", "CIM", "EMT", "Modelica","C++","DPsim"] 
date: 09/06/2024 
last-updated: 09/06/2024
authors: Georgii Tishenin (RWTH)
---

## Context
An electromagnetic transient (EMT) average value grid-following inverter model, described in [[1]](#1), was developed and implemented in [ModPowerSystems](https://git.rwth-aachen.de/acs/public/simulation/modpowersystems) and in [DPsim](https://github.com/sogno-platform/dpsim) by RWTH Aachen University, Germany. The EMT model was developed to serve as a benchmark in studies to compare simulation accuracy, numerical stability and performance against DP (dynamic phasor) model in large-scale grid simulations.

## Model use, assumptions, validity domain and limitations

The model can be used for transient stability analysis and for testing frequency control techniques.

**Assumptions and limitations:**
 - Average value model. The voltage source interface of the model does not allow to represent switching harmonics.
 - Positive sequence model. The control architecture of the model contains only one phase-locked-loop (PLL) and only can correctly track the voltage angle in simulations of symmetric grids.
 - Infinite power model. No primary energy source or storage is modelled, the output power of the model is not limited by physical constraints.

## Model description

The EMT average value grid-following inverter model includes: electrical circuit, controls and interface connecting the former two, as shown in [Figure 1](#fig_grid_following_inverter). The EMT model electrical circuit is described with time-domain differential equations in *abc* stationary reference frame and includes:
 - A controlled voltage source. The controlled voltage source represents the inverter’s output based on an averaged switching model.
 - An LC filter (as an output filter), which is composed of two resistors, an inductor and a capacitor.
 - (Optionally) a step-up transformer.

Transformation between *abc* and *dq* reference frames is done with Park transform.

<span id="fig_grid_following_inverter"></span>
**Figure 1:** Grid-following inverter diagram

![Grid-following inverter diagram](Resources/Images/average_grid_following_inverter.svg "Grid-following inverter diagram")


## Model exchange
static part, dynamic part


## Open source implementations

This model has been implemented in:

| Software      | URL | Language | Open-Source License | Last consulted date | Comments |
| --------------| --- | --------- | ------------------- |------------------- | -------- |
| ModPowerSystems | [ModPowerSystems on GitHub](https://github.com/ModPowerSystems/ModPowerSystems), [ModPowerSystems on GitLab](https://git.rwth-aachen.de/acs/public/simulation/modpowersystems)  | Modelica | [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2)  | 08/06/2024 | Electrical circuit in this implementation of the model does not include resistor $R_2$ and step-up transformer.|
| DPsim | [DPsim](https://github.com/sogno-platform/dpsim)  | C++ | [MPL v2.0](https://www.mozilla.org/en-US/MPL/2.0/)  | 08/06/2024 | - |

## Table of references
<a id="1">[1]</a>  M. Mirz, J. Dinkelbach, A. Monti, “[DPsim — Advancements in Power Electronics Modelling Using Shifted Frequency Analysis and in Real-Time Simulation Capability by Parallelization](https://www.mdpi.com/1996-1073/13/15/3879),” Energies, 2020.
