# How do I use this?

In order to use the code for your own system, the easiest thing to do is to copy the `int2d` files and adapt them for your own system.

* `compute_beta.m`
* `compute_gram_matrix.m`
* `compute_value_functions_int2d.m`
* `generate_samples_int2d.m`
* `run_terminal_hitting_int2d.m`

Many of the parameters and coefficients are hard-coded, meaning if you want to
change the code to suit your purposes, you will need to change the code
manually. However, where possible, the functions have several name/value
arguments that can be passed at runtime which are documented for each function.
Use the Matlab `help <function>` command for more information. For example,
`help run_terminal_hitting_int2d`.

## Samples

The samples (or observations) that are used to compute the safety probabilities
directly affect the quality of the approximation. Make sure to choose
input/output (X/Y) samples that are located in the target set, safe set, and
potentially choose samples just outside of the target/safe set boundaries. If
there are no _output_ samples that are located inside the target set, the code
may produce unexpected results, due to the fact that the value function is
computed to be `0` everywhere.

The input/output samples should follow the form `Y ~ Q(.|X)`.

Note that the systems can be linear, nonlinear, or the functional relationship
can be unknown. The system disturbance is arbitrary.

The number of samples used to build the approximation also affects the quality
of the approximation. However, the number of samples increases the memory and
computational costs associated with the algorithm and is generally `O(M^3)`,
where `M` is the number of samples. Make sure to choose samples which
characterize the region of the state space you wish to approximate in every
dimension to ensure good results.

## Control Inputs

Note that in the code, the systems do not incorporate a control input term in
the norm calculation. This does not affect the results for the systems presented
in the code. The integrator system assumes `0` input, and the CWH system has
input/output samples which incorporate the control input.

In order to adapt the code for a control input, the norm calculation needs to
include an additive linear term which computes the pairwise norm of the inputs.

## Test Points

The test (or evaluation) points are the initial conditions `x0` where you wish
to evaluate the algorithm. These should be chosen close to the regions where you
have input samples. The approximation is only valid in this region. In regions
where there are no input samples nearby, the method tends to `0` for the
approximation.

This also means that you can choose samples in a localized region of the state
space in order to create a sufficient approximation. For high-dimensional
systems, you can restrict the samples used to build the approximation to a local
region in order to achieve better performance.

## Algorithm Steps

See the `run_timed_int2d.mat` file for code steps used to compute the safety
probabilities. This generally provides a good template for adapting the method
for your own system.

1. Compute samples.
2. Compute the Gram matrix for your input samples.
3. Compute the weight matrix.
4. Compute the value functions for your output samples.
5. Compute the beta coefficients for a test point with the input samples.
6. Compute the safety probabilities.
