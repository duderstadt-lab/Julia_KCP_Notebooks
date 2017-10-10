# Julia_KCP_Notebooks
* src folder: Julia v0.6 code for kinetic changepoint method.
* examples folder: A Jupyter notebook file explaining the usage of the change point functions, along with example data.
* SimulationsandFigures folder: Juptyer Notebook files containing trajectory simulations, change point analysis and plotting. These require Python 3, Julia 0.6 and R kernels for the Jupyter notebook. Each uses a specified random seed which will allow the analysis and figures in the JCP paper to be precisely reproduced.

To run everything, including the simulations and analysis, you will need the following installed:

* Anaconda, with Python 3.x, this will include Jupyter notebooks.https://www.anaconda.com/download/
* Julia v 0.6. https://julialang.org/
* R. https://www.r-project.org/

These will also require Jupyter kernels installed for the following:
* IJulia kernel: https://github.com/JuliaLang/IJulia.jl.
* R kernel: https://github.com/IRkernel/IRkernel

Within Julia you will need to run the following code once before you can run the change points code:
* Roots package: Pkg.add("Roots").

In R, you will need to run the following commands once before you can run the analysis notebooks:
* install.packages("tidyverse")
* install.packages("svglite")

Otherwise, if you just want to run the change point functions, you minimally only need Julia with the roots package installed. You can then either run the Julia code in the Julia REPL, or in a notebook if you also have Anaconda and the Julia kernel.
