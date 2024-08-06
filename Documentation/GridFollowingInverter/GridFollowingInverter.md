---
layout: page 
title: Grid-following inverter
tags: ["Three-phase", "CIM", "EMT", "Modelica","C++","DPsim"] 
date: 09/06/2024 
last-updated: 09/06/2024
authors: Georgii Tishenin (RWTH)
---

## Context

An electromagnetic transient (EMT) average value grid-following inverter model, described in [[1]](#1) was developed and implemented in [ModPowerSystems](https://git.rwth-aachen.de/acs/public/simulation/modpowersystems) and in [DPsim](https://github.com/sogno-platform/dpsim) by RWTH Aachen. The EMT model was developed to serve as a benchmark in studies to compare simulation accuracy, numerical stability and performance against DP (dynamic phasor) model in large-scale grid simulations.

## Model use, assumptions, validity domain and limitations

The model can be used for transient stability analysis and for testing frequency control techniques.

**Assumptions:**
 - Average value model. The voltage source interface of the model does not allow to represent switching harmonics.
 - Positive sequence model. The control architecture of the model contains only one phase-locked-loop (PLL) and only can correctly track the voltage angle in simulations of symmetric grids. 

## Model description (mandatory)

_This section gives the full description of the different model's component._

For each component, is given: a brief explanation about the functioning of the component (how it works, what it is made of, which implementation choices are made) and the component equations or control diagram. The author can also point to another component page if the component is already explained in another page. In such case, he clearly needs to make coherence is achieved with the rest of the model in terms of notation, convention, and connection aspects.

- **For the equation system / algorithm :** the author can use Latex language, which is fully compatible with markdown. For example: ```$$ x_{j}^{i} $$```. He can also use numbered equations. The variables and parameters should be clearly specified, as well as their type (complex, real, etc.), unit (MW, MVA, etc), and meaning (phase to neutral voltage for the output terminal A). The notation should follow scientific standards.

- **Images can be added** for clarity with: ```<img src="{{'pages/templates/gaussian.png' | relative_url}}" alt="Normalized Gaussian curves"``` **The image must be of good quality and more preferably in .svg format**.

- **Electric/Electronic/Control/Phasor diagrams:** they can be used instead of equations system to describe the component. We invite the author to use the [draw.io](https://www.drawio.com/) plugin for github allowing you to make your own diagram easily. The diagram is fully editable with github commit using a graphical interface, and allowing multiple format outputs (for more details, see: [draw.io github](https://app.diagrams.net/)). if the diagram includes common control block, you can use the already available drawio library in pages/models/controlBlocks/ . For each block a corresponding page is provided describing the block itself, it diagram representation and the corresponding equations/algorithm.

- **Initial equations/boundary conditions:** when initial equations or boundary conditions are necessary to fully described the system, a subsection dedicated to those aspects can be added in this section.


## Open source implementations

This model has been successfully implemented in :

| Software      | URL | Language | Open-Source License | Last consulted date | Comments |
| --------------| --- | --------- | ------------------- |------------------- | -------- |
| ModPowerSystems | [ModPowerSystems on GitHub](https://github.com/ModPowerSystems/ModPowerSystems), [ModPowerSystems on GitLab](https://git.rwth-aachen.de/acs/public/simulation/modpowersystems)  | Modelica | [Modelica License 2](https://modelica.org/licenses/ModelicaLicense2)  | 08/06/2024 | - |
| DPsim | [DPsim](https://github.com/sogno-platform/dpsim)  | C++ | [MPL v2.0](https://www.mozilla.org/en-US/MPL/2.0/)  | 08/06/2024 | - |

## Table of references
<a id="1">[1]</a>  M. Mirz, J. Dinkelbach, A. Monti, “[DPsim — Advancements in Power Electronics Modelling Using Shifted Frequency Analysis and in Real-Time Simulation Capability by Parallelization](https://www.mdpi.com/1996-1073/13/15/3879),” Energies, 2020.
