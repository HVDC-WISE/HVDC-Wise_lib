---
layout: page 
title: Grid-following inverter
tags: ["Three-phase", "CIM", "EMT", "Modelica","C++","DPsim"] 
date: 09/06/2024 
last-updated: 09/06/2024
authors: Georgii Tishenin (RWTH)
---

## Context
An electromagnetic transient (EMT) average value grid-following inverter model, described in [[1]](#1), was developed and implemented in [ModPowerSystems](https://git.rwth-aachen.de/acs/public/simulation/modpowersystems) and in [DPsim](https://github.com/sogno-platform/dpsim) by RWTH Aachen University, Germany. The EMT model was developed to serve as a benchmark in studies to compare simulation accuracy, numerical stability and performance against DP (dynamic phasor) model in large-scale grid simulations. According to the classification given in [[2]](#2), the model corresponds to Type 6 computational model. 

## Model use, assumptions, validity domain and limitations

The model can be used for transient stability analysis and for testing frequency control techniques.

**Assumptions and limitations:**
 - Average value model. The voltage source interface of the model does not allow to represent switching harmonics.
 - Positive sequence model. The control architecture of the model contains only one phase-locked-loop (PLL) and only can correctly track the voltage angle in simulations of symmetric grids.
 - Infinite power model. No primary energy source or storage is modelled, the output power of the model is not limited by physical constraints.

## Model description

The EMT average value grid-following inverter model includes: electrical circuit, control system and interface connecting the former two, as shown in [Figure 1](#fig_grid_following_inverter). 

<span id="fig_grid_following_inverter"></span>
**Figure 1:** Grid-following inverter diagram

![Grid-following inverter diagram](Resources/Images/average_grid_following_inverter.svg "Grid-following inverter diagram")

**Electrical circuit**

The EMT model electrical circuit is described with time-domain differential equations in *abc* stationary reference frame and includes:
 - A controlled voltage source. The controlled voltage source represents the inverter’s output based on an averaged switching model.
 - An LC filter (as an output filter), which is composed of two resistors, an inductor and a capacitor.
 - (Optionally) a step-up transformer.

 Electrical circuit parameters: 

 | Parameter       | Units    | Example value | Comment                                                        |
|-----------------|----------|---------------|----------------------------------------------------------------|
| $R_1$              | Ohms     | 0.1           |-|
| $L_1$              | Henries  | 2e-3          |-|
| $C$               | Farads   | 789.3e-6      |-|
| $R_2$              | Ohms     | 0.1           |-|
| $n$               | -        | 1             |-|
| $L_{transformer}$   | Henries  | 928.3e-3      |-|


 **Control system**

The control system of a grid-following inverter is designed to deliver active and reactive power according to specified reference values $P_{ref}$ and $Q_{ref}$ to an energized grid. The equations of the control system are in the inverter's local *dq* reference frame. The control system includes:
- A PLL. The purpose of the PLL is to synchronize the rotation speed of the inverter's local *dq* reference frame with the frequency of the measured voltage $V_{Cabc}$ and align the axes of this *dq* reference frame with the angle of $V_{Cabc}$. The PLL includes a PI controller, that drives the $q$ component of the $V_{Cdq}$ voltage to zero using a feedback control loop. The loop is formed by PLL and Park transformation in the *abc <-> dq* interface. 
- A power control. The power control involves power calculation from $I_{R2dq}$, $V_{Cdq}$ and a PI controller, regulating $I_d$ and $I_q$ to meet the specified reference values $P_{ref}$ and $Q_{ref}$.
- A current control. The current includes a PI controller, regulating the setpoint $V_{Sdq}$ for the controlled voltage source in accordance with the reference currents $I_d$ and $I_q$, provided by the power control.

PLL parameters:
| Parameter  | Units | Default value | Comment                                                                 |
|------------|-------|---------------|-------------------------------------------------------------------------|
| $\omega_{nom}$  | rad/s | -             | Nominal angular frequency. Value depends on the system frequency; no default value is given. |
| $K_P$    | -     | 0.25          | PLL proportional gain.                                                   |
| $K_I$    | -     | 2.0           | PLL integral gain.                                                       |
| $K_D$    | -     | 1.0           | PLL derivative gain .                                                    |

Power control parameters:

| Parameter  | Units | Default value | Comment                                                                 |
|------------|-------|---------------|-------------------------------------------------------------------------|
| $P_{ref}$      | Watt  | -             | Reference active power. Value depends on the inverter size; no default value is given. |
| $Q_{ref}$      | VAr   | -             | Reference reactive power. Value depends on the inverter size; no default value is given. |
| $\omega_{nom}$   | rad/s | -             | Nominal angular frequency. Value depends on the system frequency; no default value is given. |
| $K_{Pvd}$      | -     | 0.001         | D-axis proportional gain.                                               |
| $K_{Ivd}$   | -     | 0.08          | D-axis integral gain.                                                   |
| $K_{Pvq}$      | -     | 0.001         | Q-axis proportional gain.                                               |
| $K_{Ivq}$      | -     | 0.08          | Q-axis integral gain.                                                   |
 
 Current control parameters:

| Parameter  | Units | Default value | Comment                                                                 |
|------------|-------|---------------|-------------------------------------------------------------------------|
|  $K_{Icd}$    | -     | 1400          | D-axis integral gain.                                                   |
| $K_{Pcd}$    | -     | 3.77          | D-axis proportional gain.                                               |
| $K_{Icq}$    | -     | 1400          | Q-axis integral gain.                                                   |
| $K_{Pcq}$    | -     | 3.77          | Q-axis proportional gain.                                               |
 
**Interface**

Transformation of signals between the EMT grid-following inverter's electrical circuit in *abc* reference frame and control system in *dq* reference frames is done with Park and inverse Park transformations, using the angle $\Theta_{PLL}$.

## Model exchange

### Static part
Static part of the grid-following inverter model includes the electrical circuit, that can be mapped to `EquivalentInjection` in CIM and does not require extensions to CIM.

### Dynamic part
Dynamic part of the grid-following inverter model includes the control system and the interface. The dynamic part of the model is serialized in [CIM xml file](../../../Artifacts_&_equations/Grid_following_inverter/DMC_GridFollowingInverter.xml) using the `DetailedModelConfigurationProfile` of IEC 61970-457:2024 ([[3]](#3)), as well as Modelica code. The CIM model includes classes needed to exchange the dynamic model configuration, i.e. the structure and connectivity of a detailed model, whereas the Modelica code includes equations which explicitly describe the model dynamics.

## Open source implementations

This model has been implemented in:

| Software      | URL | Language | Open-Source License | Last consulted date | Comments |
| --------------| --- | --------- | ------------------- |------------------- | -------- |
| ModPowerSystems | [ModPowerSystems on GitHub](https://github.com/ModPowerSystems/ModPowerSystems), [ModPowerSystems on GitLab](https://git.rwth-aachen.de/acs/public/simulation/modpowersystems)  | Modelica | [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2)  | 08/06/2024 | Electrical circuit in this implementation of the model does not include resistor $R_2$ and step-up transformer.|
| DPsim | [DPsim](https://github.com/sogno-platform/dpsim)  | C++ | [MPL v2.0](https://www.mozilla.org/en-US/MPL/2.0/)  | 08/06/2024 | - |

## Table of references
<a id="1">[1]</a>  M. Mirz, J. Dinkelbach, A. Monti, “[DPsim — Advancements in Power Electronics Modelling Using Shifted Frequency Analysis and in Real-Time Simulation Capability by Parallelization](https://www.mdpi.com/1996-1073/13/15/3879),” Energies, 2020.

<a id="2">[2]</a> CIGRE Working Group B4.57, "CIGRE Brochure 269: Guide for the Development of Models for HVDC Converters in a HVDC Grid," CIGRE, Paris, 2014.

<a id="3">[3]</a>  International Electrotechnical Commission TC 57, “[Energy management system application program interface (EMS-API) - Part 457: Dynamics profile](https://webstore.iec.ch/en/publication/68910),” IEC, 2024.
