# GROMACS strong scaling benchmark

For a description of this case please see the [benchmark README file](./inputs/README)

## Input files

### Benchmark input files

- the main simulation input file is [topol.tpr](./inputs/topol.tpr.gz)
- the above input file can re-generated using the ``gmx grompp`` as the full set of original input files is included in the [input directory](./inputs/)

## Performance aspects

# TODO update
# GPUs / CPUs

The simulation system used for this benchmark consists of 1.06 million atoms.
When domain-decomposed inhomegeneous work distribution across domains poses a challenge
for strong scaling. Additionally, at high scale wider MPI ranks and tuning of
separate PME ranks is required in order to balance the PP-PME load.


## How to quantify benchmark performance

Benchmark performance FOM is ns/day and must be measured in
a simulation (post counter reset) of at least least 15 minutes wall-time.

Performance should be measured in a strong scaling study, that is 
the benchmark must be run on the smallest number of nodes on which the
benchmark can be executed (expected to be one) increasing the
number of nodes until the peak performance is reached and the
absolute performance (in ns/day) stops improving. It will be assumed that any results using a larger
number of nodes than is provided will not give improved performance.

Enough intermediate data points between the largest run and the
smallest run must also be given so that the expected performance on
any number of nodes on which the job could be run can be inferred
through interpolation with reasonable confidence.  

The measured peak performance needs to be a *suitained* performance under full
machine load, that is N_jobs equal sized jobs should be execute simultaneously,
where N_jobs = N_nodes_tot / num_nodes_used with
* N_nodes_tot the total number of nodes in the respective module
* num_nodes_used the total number of nodes used for the benchmark run.

Only the performance of the lowest performing of the N_jobs concurrent jobs
must be entered into the benchmark evaluation spreadsheet.
Results for each strong scaling data point together with mdrun log outputs
files must be provided with the  benchmark report.

It is not necessary to fully populate the nodes if it gives superior
performance, but this must be clearly explained in the benchmark
report.

Vendors may make a free choice of the number of PME nodes that can
affect performance.
