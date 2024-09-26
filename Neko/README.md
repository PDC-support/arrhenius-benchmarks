# Neko benchmarks

This directory contains general information regarding the Neko code, installation and benchmarking considerations.

Neko is a portable framework for high-order spectral element flow simulations. Written in modern Fortran, Neko adopts an object-oriented approach, allowing multi-tier abstractions of the solver stack and facilitating various hardware backends ranging from general-purpose processors, CUDA and HIP enabled accelerators to SX-Aurora vector processors. Neko has its roots in the spectral element code Nek5000 from UChicago/ANL, from where many of the namings, code structure and numerical methods are adopted.

## Source code

### Obtaining the source code

The official Neko releases are distributed through source packages and can be obtained from the [release webpage](https://github.com/ExtremeFLOW/neko/releases).

**For the benchmarks the Neko v0.9.0 release or more recent must be used.** 

### Guidelines for Porting and Modifying the Source Code

A limited amount of modifications to the Neko source code are acceptable as long as these
modifications, for example new compute kernels or optimizations to
existing kernels, must be made available for integration in the
Neko source code.  Specifically, the winning tender must provide
any modifications formatted to follow the [Neko contribution
guidelines](https://neko.cfd/docs/release/d1/d5a/contributing.html).
The contributions must be made available before the
before acceptance benchmark runs on the delivered system.

## Installation guide 
To build Neko, you will need a Fortran compiler supporting the Fortran-08 standard, autotools, pkg-config, a working MPI installation supporting the Fortran 2008 bindings (`mpi_f08`), BLAS/LAPACK and JSON-Fortran. Detailed installation instructions can be found in the [Neko manual](https://neko.cfd/docs/release/d5/dfc/installation.html)

**GPU support:**
To compile Neko with GPU support, please follow either the instructions in the manual ([Compiling Neko for NVIDIA GPUs](https://neko.cfd/docs/release/d5/dfc/installation.html#autotoc_md45) and [Compiling Neko for AMD GPUs](https://neko.cfd/docs/release/d5/dfc/installation.html#autotoc_md46)).

**Note:** 
A Neko installation can only support one backend. Thus, to run both module 1 and module 2 benchmarks, two different builds and installations are necessary. 

## Benchmark cases

The benchmark suite includes two Neko strong scaling benchmark cases:

- [Module 1](./tgv/module1)

- [Module 2](./tgv/module2)

Both cases simulates the three-dimensional Taylor-Green vortex in a cubical box of size $2\pi$ in each direction. During the simulation, the total kinetic energy and enstrophy are computed for verification.


### Running the benchmark cases

To run a benchmark case:

* Install neko
* Decompress the provided input meshes (`*.nmsh.gz`)
* Build the case using `makeneko`
```console
> /path/to/neko/installation/bin/makeneko tgv.f90
```
* The resulting `neko` binary can run the case as
``` console
> ./neko inputfile.case
```

**Note:** For multiple GPUs per node, Neko assumes that each MPI rank has its own device and that this is provided via the environment or jobscript. 

 Vendors should run the benchmark using an increasing number of MPI ranks until no improvement in performance is observed.

#### Validation of results
It is important to check that results from Neko are scientifically valid. Vendors can check the results by executing `grep POST <logfile>`, and check that the last output of `Ekin` and `enst` is around `0.12499` and `0.375` respectively.

### Minimum performance

The required minimum performance for both cases is 18 GDoF/s for module 1 and 118 GDoF/s for module 2.

#### Reference performance numbers
- Module 1: 13.86 GDoF/s on 512 nodes of a Cray EX235a with 2 x AMD EPYC 7742
- Module 2: 64.89 GDoF/s on 128 nodes of a Cray EX235a with 4 x AMD MI250X

Reference strong scaling characteristics can be found in the following [open-access publication](https://doi.org/10.1145/3581784.3627039)

### Obtaining benchmark results

The figure of merit (FOM) used to evaluate the benchmark is the performance measured in throughput (GDoF/s) of one time-step, computed based on the average time per time step for the last 200 time steps. To extract it, use the provided awk script [neko_fom.awk](./tgv/neko_fom.awk) on the log file e.g: `awk -f neko_fom.awk logfile`.

**Note:**  All reported results must be obtained from a double precision floating point build of Neko.

Information on which compiler was used (vendor and version number) must also be provided as additional information in the benchmark report.
