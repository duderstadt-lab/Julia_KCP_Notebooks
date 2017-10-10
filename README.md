# Julia_KCP_Notebooks
Julia v0.6 code for kinetic changepoint method is found in the src folder.
A Jupyter notebook file explaining its usage is in the examples folder.
Juptyer Notebook files containing trajectory simulations, change point analysis and plotting are in the SimulationsandFigures folder. These require Python 3, Julia 0.6 and R kernels for the Jupyter notebook.

In Julia, the change point script requires the Roots package: Pkg.add("Roots").

To run it as a Jupyter Notebook as I have done in the example requires the IJulia kernel: https://github.com/JuliaLang/IJulia.jl, otherwise change point analysis can just be run in the Julia REPL.
