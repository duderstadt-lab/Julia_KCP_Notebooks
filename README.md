# Julia_KCP_Notebooks
This repository contains the following folders:
* src folder: Julia v0.6 code for kinetic changepoint method.
* examples folder: A Jupyter notebook file explaining the usage of the change point functions, along with example data.
* SimulationsandFigures folder: In an effort to support reproducible research, we have included Juptyer Notebook files containing trajectory simulations, change point analysis and plotting. These require Python 3, Julia 0.6 and R kernels for the Jupyter notebook. Each uses a specified random seed which will allow the analysis and figures in the JCP paper to be precisely reproduced.

To run everything, including the simulations and analysis, you will need the following installed:

* Anaconda, with Python 3.x, this will include Jupyter notebooks.https://www.anaconda.com/download/
* Julia v 0.6. https://julialang.org/
* R. https://www.r-project.org/

These will also require Jupyter kernels installed for the following:
* IJulia kernel: https://github.com/JuliaLang/IJulia.jl.
* R kernel: https://github.com/IRkernel/IRkernel

Within Julia you will need to install the Roots package once before you can run the change points code:
* Pkg.add("Roots")

In R, you will need to run the following commands once before you can run the analysis notebooks:
* install.packages("tidyverse")
* install.packages("svglite")

If you wish to reproduce our analysis, download the repository and navigate to the SimulationsandFigures folder. In a terminal/command prompt, type 'jupyter notebook' to launch the Jupyter notebook home page in your web browser. You can then click on the desired notebook from the SimulationsandFigures folder, to open it in a new tab. Choose the Python kernel and run the Python cells in sequence, then once those have finished running (it will take some time to produce the simulated data) switch to the Julia kernel to run the Julia commands, followed by R etc. The simulated trajectories are large datasets, and for this reason have not been included in this repository, however, the use of a defined random seed in the notebooks means that you can reproduce the same datasets that we have used in our analysis.

Otherwise, if you just want to run the change point functions, you minimally only need Julia with the roots package installed. You can then either run the Julia code in the Julia REPL, or in a notebook if you also have Anaconda and the Julia kernel.
