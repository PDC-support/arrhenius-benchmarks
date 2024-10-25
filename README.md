# Procurement benchmarks for Arrhenius

This repository contains the application benchmark suite used in the procurement of the new EuroHPC system "Arrhenius" in 2024.

The benchmark suite consists of jobs using the software:

* [Neko](https://neko.cfd/) (1 job)
* [Gromacs](https://www.gromacs.org/) (2 jobs, one ensemble benchmark, and one strong-scaling benchmark)
* [Veloxchem](https://veloxchem.org/docs/intro.html) (1 job)
* "BERT-large" language model from [MLPerf Training v4.0](https://mlcommons.org/benchmarks/training/)

The benchmark numbers for Neko, Gromacs and Veloxchem should be committed for both Module 1 ("CPU partition") and Module 2 ("GPU partition"). The BERT benchmark only applies to Module 2.

The application benchmarks are either of a throughput or strong-scaling type, which differ in how they should be run and in reported. A detailed description of how the figures of merit for each type of benchmark should be obtained can be found in the README files for each benchmark in sub-directories.

A benchmark report should accompany each tender describing how the benchmark numbers were obtained. A list of requirements on the benchmark report can be found in the Tender document Chapter 4.1.

## Figure-of-merits (FOM)

The figure-of-merits (FOM) that should be reported for the different benchmarks are:

* for Neko, `GDoF/s` of one time-step, computed based on the average time per time step for the last 200 time steps.
* for Gromacs, `ns/day`, the simulation throughput expressed as simulated nanosecond per 24 hours)
* for Veloxchem, the wall-time in seconds of the benchmark
* for BERT, the Latency (in seconds)

These FOMs must be supplied in the spreadsheet in Appendix 2. In this spreadsheet, the FOMs are translated to a score, which is used in the evaluation of the tenders.

## How the benchmarks are evaluated

The Arrhenius tenders are scored on `P_tot`, which is the total aggregated projected throughput of the benchmark suite using an entire module (the CPU or the GPU partition). This number is a rate (or frequency), expressed as "the number of times that the entire benchmark suite can be run in the partition in 1 hour". A higher number is better than a lower number. `P_tot` is calculated from the vendor-committed FOMs for each individual benchmark component and the vendor-committed sizes (i.e. number of servers) of the Module 1 and Module 2 (see Appendix 2 Benchmark Evaluation Sheet).

The formula for calculating `P_tot` (as implemented in Appendix 2) can be described as the weighted harmonic mean of the projected throughputs of the benchmark jobs in a specific module. The weights of the harmonic mean is the number of benchmark jobs of a certain type in the benchmark suite.

Consider a series of benchmark jobs indexed by i = 1,2,3,.. with weights `w_i`, that were completed with run-times `t_i`, on a certain number of compute nodes `n_i`. If the total number of compute nodes in the module is `N`, then `P_tot` for that module becomes: 

    P_tot = 3600 seconds / Sum((w_i * t_i* n_i)/N)

The FOMs for the different benchmarks are translated into run-times using the following formulas:

* Neko `tgv` CPU-version (for Module 1): ((1073741824/(1000000000*[GDoF/s]))*200)
* Neko `tgv` GPU-version (for Module 2): ((8589934592/(1000000000*[GDoF/s]))*200)
* GROMACS `navm-aw` benchmark: 1000*172.8016/[ns/day]
* GROMACS `stmv_gmx_v2` benchmark: 1000*172.8016/[ns/day]
* Veloxchem `g-quad-neutral`, the run-time in seconds is used directly in the Ptot formula.
* BERT, the run-time in seconds is used directly in the Ptot formula.

The `P_tot` value for Module 1 must exceed 1.2 and the `P_tot` value for Module 2 must exceed 1.82. The performance of Module 1 is not used for scoring, it must only exceed the minimum value of 1.2. The performance of Module 2 is scored in proportion to the minimum `P_tot` performance of 1.82, which is worth 40 points. For example, if the Module 2 delivers a `P_tot` value of 3.64, it receives 40 * 3.64/1.82 = 80 points.

## Running conditions during acceptance testing

The vendors are advised to keep the following in mind when committing the FOMs:

* When demonstrating the FOM of a benchmark, the Module must be filled with multiple copies of the job which execute simultaneously, each using the tendered number of servers for the benchmark per individual job. Every server must run at least one job. If this cannot be achieved in one session (for example, for large benchmarks spanning more than 50% of the module), the vendor is required to run several sessions that in combination includes every server in the module.
* The FOM of the slowest job across all sessions is used for evaluating the performance.

## Contact info
Questions regarding the benchmark(s) must be posted via the "question and answer function" in Visma TendSign.
