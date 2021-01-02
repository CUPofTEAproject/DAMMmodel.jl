# DAMMmodel

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://AlexisRenchon.github.io/DAMMmodel.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://AlexisRenchon.github.io/DAMMmodel.jl/dev)
[![Build Status](https://github.com/AlexisRenchon/DAMMmodel.jl/workflows/CI/badge.svg)](https://github.com/AlexisRenchon/DAMMmodel.jl/actions)
[![Coverage](https://codecov.io/gh/AlexisRenchon/DAMMmodel.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/AlexisRenchon/DAMMmodel.jl)

The Dual Arrhenius Michaelis Menten model 
Davidson, E. A., and S. Samanta. "A Dual Arrhenius and Michaelis-Menten (DAMM) Kinetics Model of Soil Organic Matter Decomposition." AGUFM 2008 (2008): B11E-04.

was built for heterotrophic respiration. 

It has been applied to soil respiration 
Drake, John E., et al. "Three years of soil respiration in a mature eucalypt woodland exposed to atmospheric CO 2 enrichment." Biogeochemistry 139.1 (2018): 85-101.

and ecosystem respiration (REF). 

This package contains scripts to visualize the model and fit it to data. 

For example, it can be used to:
gap-fill and partition flux tower (eddy-covariance) or soil respiration datasets
estimate parameters, e.g. to investigate how they vary in space and time, or by soil and biome
gap-fill soil respiration datasets
estimate parameters of soil incubation

It can also be used to produce publication ready figures. 
