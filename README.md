# stochastic-reachability-kme

Stochastic reachability using kernel mean embeddings.

## How is the code organized?

### Plots

The plots for the paper are generated using the four main plotting functions:

* `plot_main_figure.m`
* `plot_cwh_figure.m`
* `plot_samples_vs_error.m`
* `plot_dimensionality_vs_time.m`

Note that the last two take a significant amount of time to generate.

Generated (and cleaned) plots are located in the `plots` folder, with Matlab
figures and EPS images.

Some functions used to ensure consistent plotting and formatting are located in
the `helpers` folder.

### Code

The code used for the algorithm is located in the `code` folder.

There are two functions used internally to compute the Gaussian kernel function
and compute the Gram matrix (`compute_gram_matrix.m`) and the beta coefficients
(`compute_beta.m`). These use a slightly optimized form to compute the pairwise
norm between the samples, and then the Gaussian kernel function evaluation.

There are 3 systems demonstrated here:

* Double integrator (`int2d`)
* N-D integrator (`intnd`)
* CWH system (`cwh`)

Each system has corresponding files used to generate system matrices, generate
samples, compute value functions, and to run the algorithm, both for output and
for timing purposes.

1. System matrices are generated using the appropriate `generate_dynamics_x.m`
files, where `x` is the name of the system. The system matrices for the N-D integrator system and the CWH system are precomputed and stored in `dynamics_cwh.mat` and `dynamics_intnd.mat`. More details about computing the CWH dynamics can be found here: [HSCL](https://hscl.unm.edu/software/code/) ([Download Lesser_CDC13.zip](https://hscl.unm.edu/wp-content/uploads/Lesser_CDC13.zip)). See the following paper for more information:
> K. Lesser, M. Oishi, and R.S. Erwin In the Proceedings of the IEEE Conference
> on Decision and Control, Florence, Italy, December 2013, p. 4705-4712.

2. Samples for the systems are generated using `generate_samples_x.m`. Note that
the CWH system uses samples generated using a `chance-affine` controller from
[SReachTools](https://sreachtools.github.io). These samples take a significant
amount of time to generate, but a precomputed set of samples are stored in the
`samples_cwh.mat` file.

3. The code used to compute the value functions is located in the
`compute_value_functions_x.m` files. These are called by the algorithm during
runtime.

4. The algorithms are run using `run_terminal_hitting_x.m`. These are the
functions used in the plotting functions to generate the safety probabilities.

5. The functions used for timing are located in the `run_timed_x.m` files. These
are a stripped-down version of the algorithms that require the
samples to be computed beforehand and passed in as parameters.

## How do I use this?

In order to use the code for your own system, follow the instructions in the
`README.md` file located in the `code` folder.
