# GROMACS strong scaling benchmark

For a description of this case please see the [benchmark README file](./inputs/README)

## Input files

### Benchmark input files

- the main simulation input file is [topol.tpr](./inputs/topol.tpr.gz)
- the above input file can re-generated using the ``gmx grompp`` as the full set of original input files is included in the [input directory](./inputs/)

## Performance aspects

The simulation system used for this benchmark consists of 1.06 million atoms.
When domain-decomposed inhomegeneous work distribution across domains poses a challenge
for strong scaling. Additionally, at high scale wider MPI ranks and tuning of
separate PME ranks is required in order to balance the PP-PME load.
The limiting factor to strong scaling at peak is 3D-FFT scalability on both
CPU-only and heterogeneous machines. In particular for the latter,
since unlike in the CPU case GROMACS does not implement the FFT parallelization,
a scalable 3D-FFT library is critical.


## How to quantify benchmark performance

Benchmark performance FOM is ns/day and must be measured in
a simulation (post counter reset) of at least least 15 minutes wall-time.

Performance must be measured in a strong scaling study, that is 
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
machine load, that is N_jobs equal sized jobs are executed simultaneously,
where N_jobs = N_nodes_tot / num_nodes_used with
* N_nodes_tot the total number of nodes in the respective module
* num_nodes_used the total number of nodes used for the benchmark run.

Only the performance of the lowest performing of the N_jobs concurrent jobs
must be entered as the FOM into the benchmark evaluation spreadsheet.
Results for each strong scaling data point together with mdrun log outputs
files must be provided with the benchmark report.

It is not necessary to fully populate the nodes if it gives superior
performance, but this must be clearly explained in the benchmark
report.

## Minimum required performance

* Module 1: 221 ns/day
* Module 2: 110 ns/day

## Reference performance

* Module 1: 221 ns/day using 96 nodes on a Cray EX235 with 2 x AMD EPYC 7742;
* Module 2: 107 ns/day using 1 node on a Cray EX235a with 4 x AMD MI250X;
