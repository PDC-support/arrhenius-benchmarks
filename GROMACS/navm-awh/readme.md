# GROMACS navm-awh ensemble benchmark

For a description of this case please see the [benchmark README
file](./inputs//README)

## Input files

### Benchmark input files

- The main simulation input file is [topol.tpr](./inputs/topol.tpr)
- The full set of original input files is included in the 
  [input directory](./inputs/) and the ``topol.tpr`` input file can
  re-generated using the ``gmx grompp`` tool;
- Ensemble setup directory tree is provided in the
  [ensemble_64-SIM.tar.gz archive](./inputs/ensemble_64-SIM.tar.gz)

### Generating the inputs for the ensemble run

For this benchmark an ensemble, called multi-simulation in GROMACS, is used.
This is a coupled ensemble using the accelerated weight histogram (AWH) method.
The supplied simluation case uses a 64 member ensemble, and
this is the number of ensemble members that must be used. The
ensemble simulation mode of the ``mdrun`` tool requires one directory
per ensemble member simulation. As the AWH algorithm employed uses
identical input files, a single tpr input can be created and symlinked
in each of the output directories.

The (bash) shell script code below shows the steps to re-create
the 64 inputs which are provided with the inputs.
```
gmx grompp -n index.ndx -r conf.gro -o topol.tpr
for i in $(seq -f "%02g" 1 64); do
  dirname=repl_${i}
  ( mkdir $dirname && cd $dirname && ln -s ../topol.tpr topol.tpr; )
done
```

## How to run the ensemble benchmarks

To run the ensemble benchmark, launch a total of `N*64` ranks and pass
the 64 output directories to the mdrun ``-multidir`` option. As a
result, N ranks per simulation will be used (ranks assigned
sequentially).  Set a run length as a maximum wall-time (`-maxh`) and it is
strongly recommended to use counter resetting (`-resethway`) to 
record performance excluding any load balancing phase or hardware warm-up.

An example command for a 64-rank run (i.e. one rank per simulation) with reported
performance for the latter 15 minutes of the 30 minutes run:
`mpirun -np 64 gmx_mpi mdrun -multidir sim_* -nsteps -1 -maxh 0.5 -resethway`

Note that each member simulation will have its performance
reported in its own log file.

## Performance aspects

The simulation system used for this benchmark consists of
approximately 200000 atoms.  When domain-decomposed a significant
challenge is the inhomogeneous work distribution across domains.

The ensemble run is scheduled as a single job submission, but it is
composed of coarsely communicating members (every 1000 iterations)
which in turn have significantly latency-sensitive communication
internally within a simulation.  This poses the challenges to node
allocation as ensemble member simulations greatly benefit from being
assigned their ranks to a "compact" set of nodes whereas nodes
assigned to different simulations can be further apart.  In
addition, because simulations communicate at fixed iteration
intervals, the slowest of the simulations will limit the performance
of the entire run.  Therefore, to avoid such imbalance it is advisable
to minimize bottlenecks that can cause systematic discrepancies in
simulation throughput across the ensemble.

## How to quantify benchmark performance

Benchmark performance FOM is the average ns/day across all ensemble members,
and must be measured in a simulation (post counter reset) of at least least 15 minutes wall-time.

The benchmark can be run on any amount of resources which satisfies 
the minimum performance constraints described in the next section.

The measured peak ensemble throughput needs to be a *suitained* performance under full
machine load, that is N_jobs equal sized ensemble jobs are executed simultaneously,
where N_jobs = N_nodes_tot / num_nodes_used with
* N_nodes_tot the total number of nodes in the respective module
* num_nodes_used the total number of nodes used for the benchmark run.

Only the performance of the lowest performing of the N_jobs concurrent jobs
must be entered into the benchmark evaluation spreadsheet.

The mdrun log outputs files must be provided with the benchmark report.

It is not necessary to fully populate the nodes if it gives superior
performance, but this must be clearly explained in the benchmark
report.

## Minimum required performance

* Module 1: 170 ns/day
* Module 2: 180 ns/day

## Reference performance

* Module 1: 167 ns/day using 512 nodes on a Cray EX235 with 2 x AMD EPYC 7742
* Module 2: 160 ns/day using 32 nodes on a Cray EX235a with 4 x AMD MI250X
