# Julia_KCP_Notebooks
*src folder: Julia v0.6 code for kinetic changepoint method.
*examples folder: A Jupyter notebook file explaining the usage of the change point functions, along with example data.
*SimulationsandFigures folder: Juptyer Notebook files containing trajectory simulations, change point analysis and plotting. These require Python 3, Julia 0.6 and R kernels for the Jupyter notebook. Each uses a specified random seed which will allow the analysis and figures in the JCP paper to be precisely reproduced.

In Julia, the change point script requires the Roots package: Pkg.add("Roots").

To run it as a Jupyter Notebook as I have done in the example requires the IJulia kernel: https://github.com/JuliaLang/IJulia.jl, otherwise change point analysis can just be run in the Julia REPL.
