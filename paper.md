---
title: 'DAMMmodel: A Julia package to estimate respiration'
tags:
  - Julia
  - land-atmosphere exchanges
  - ecosystem and soil respiration
  - land surface modeling
  - earth system modeling
authors:
  - name: Alexandre A. Renchon^[co-first author]
    orcid: 0000-0002-9521-5092
    affiliation: 1
affiliations:
 - name: Environmental Science Division (EVS), Argonne National Laboratory, Lemont, IL, USA
   index: 1
date: 28 December 2021
bibliography: paper.bib

---

# Summary

Climate change is the result of increasing atmospheric greenhouse gases 
concentration, particularly carbon dioxide (CO2). The land has been absorbing 
about a third of anthropogenic CO2 emissions, but this may change. Earth System
Models attempts to predict future climate, accounting for all sorts of feedbacks, 
including how the land will respond. The Dual Arrhenius and Michaelis-Menten
(DAMM) kinetics model is a semi-mechanistic model of heterotrophic respiration
response to soil temperature and soil moisture. This model can be applied at
various scales by empiricists and modelers to better understand respiration. 

# Statement of need

`DAMMmodel` is a Julia package providing functions to use, visualize, and fit
the DAMM model parameters to data. Julia is particularly adequate, as empiricists 
require simple synthax, and modelers require speed. `DAMMmodel` may be directly 
used from Earth System Models as a module, and by empiricists to parameterise 
and visualize their data of respiration response to soil temperature and soil
moisture. It may also be used for teaching. 

# Mathematics

Single dollars ($) are required for inline mathematics e.g. $f(x) = e^{\pi/x}$

Double dollars make self-standing equations:

$$\Theta(x) = \left\{\begin{array}{l}
0\textrm{ if } x < 0\cr
1\textrm{ else}
\end{array}\right.$$

You can also use plain \LaTeX for equations
\begin{equation}\label{eq:fourier}
\hat f(\omega) = \int_{-\infty}^{\infty} f(x) e^{i\omega x} dx
\end{equation}
and refer to \autoref{eq:fourier} from text.

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Figures

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png)
and referenced from text using \autoref{fig:example}.

Figure sizes can be customized by adding an optional second parameter:
![Caption for example figure.](figure.png){ width=20% }

# Acknowledgements

We acknowledge contributions from Brigitta Sipocz, Syrtis Major, and Semyeong
Oh, and support from Kathryn Johnston during the genesis of this project.

# References
