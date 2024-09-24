# GROMACS benchmarks

This directory contains general information regarding the GROMACS
code, installation, and benchmarking considerations.  Information
specific to the GROMACS benchmark suite are to be found in the
subdirectories [navm-awh](./navm-awh) and
[stmv_gmx_v2](./stmv_gmx_v2).

Gromacs is a highly efficient and optimized code for Molecular
Dynamics simulations. The software requires a compiler which complies
with the C++14 standard and supports many hardware specific extensions
such as AVX ans SVE. The code can make efficient use of GPUs as well.
An FFT library is the only required external library. The GROMACS build system is
able to compile FFTW for CPUs it on demand, a range of 
CPU and GPU libraries is supported.

## Source code

### Obtaining the source code

The official GROMACS releases are distributed through source
packages and can be obtained from the [releases
webpage](http://manual.gromacs.org) with the most recent release under
the ["Latest releases
section"](http://manual.gromacs.org/#latest-releases).

**For the benchmarks the official GROMACS 2025 or a more recent version must be used.**

### License

GROMACS is free software, distributed under the GNU Lesser General
Public License (LGPL) Version 2.1; for further details see the
``COPYING`` file in the root of the source distribution.

### Guidelines for Porting and Modifying the Source Code

A limited amount of modifications to the GROMACS source code are acceptable as long as these
modifications, for example new compute kernels or optimizations to
existing kernels, must be made available for integration in the
GROMACS source code.  Specifically, the winning tender must provide
any modifications formatted to follow the [GROMACS contribution
guidelines](http://manual.gromacs.org/documentation/current/dev-manual/contribute.html).
The contributions must be made available before the
before acceptance benchmark runs on the delivered system.

## Installation guide

For a detailed guide on prerequisites, how to configure and install
the software, see the [official GROMACS installation
guide](http://manual.gromacs.org/documentation/current/install-guide/index.html).

For best performance, it is recommended to use a recent compiler
toolchain. Particular care should be taken to ensure that the [right
SIMD instruction
set](http://manual.gromacs.org/documentation/current/install-guide/index.html#simd-support)
is enabled at configure time.

The binary installations used for benchmarks must be validated
(on a relevant range of resource counts when applicable)
and the validation run outputs submitted with the documentation.
For the details on how to run validation follow the instruction at
[GROMACS for
correctness](http://manual.gromacs.org/documentation/current/install-guide/index.html#testing-gromacs-for-correctness).


Note that if the official source distribution is altered we recommend that in such cases [a custom version
string suffix is
used](http://manual.gromacs.org/documentation/current/install-guide/index.html#validating-gromacs-for-source-code-modifications).

## Performance considerations

GROMACS supports running on a wide range of hardware and targets
multiple levels of hardware parallelism.  For inter-node
parallelization MPI is used both SPMD and
[MPMD](http://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html#).
Intra-node parallelization is done using SIMD compiler intrinsics,
OpenMP multi-threading as well as CUDA and OpenCL for heterogeneous
parallelization using GPU acceleration. Note that starting with the
current release, in single-GPU throughput runs the GPU acceleration
supports a fully-GPU resident loop for the force-compute steps in
CUDA.

For details on how to obtain the best performance, the reader is
recommended to consult the [relevant section of the GROMACS user
guide](http://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html#).

## Benchmark cases

The PDC procurement benchmark suite includes two GROMACS benchmark
cases:

- [ensemble benchmark](./navm-awh)
- [strong scaling benchmark](./stmv_gmx_v2)

Further information about these benchmark cases is provided in README
files provided in the subdirectories.


### Running the benchmark cases

For general instructions on how to execute the GROMACS ``mdrun``
simulation tool, see related instructions, examples and performance
checklist included in the [GROMACS performance
guide](http://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html#running-mdrun-within-a-single-node).

### Minimum performance

The ensemble benchmark will be evaluated as a sustained throughput benchmark
and requires a minimum performance to be met:

- On the Module 1 the performance of an individual run must not be less than 180 ns/day.
- On the Module 2, the performance of an individual run must not be less than 160 ns/day.

The strong scaling benchmark will be evaluated as based on the sustained peak performance
and requires the following minimum performance to be met:
- On the Module 1 the peak performance required to be no less than 200 ns/day.
- On the Module 2, the performance of an individual run must not be less than 100 ns/day.

### Obtaining benchmark results

The ``mdrun`` simulation tool prints a performance report at the end
of its log output.  This includes both wall-time and "ns/day" (the
simulation throughput expressed as simulated nanosecond per 24 hours).
The latter is the FOM metric required to be entered in the in the benchmark
evaluation sheet.
This number can be easily parsed from the second first column of the
row starting with "Performance:" at the end of the ``mdrun`` log.

The simulation length can be specified using either:
- as the number of iterations with the ``-nsteps N`` option or
- as the simulation wall-time in hours using ``-nsteps -1 -maxh T``.
Note that benchmarks measurements must be done over at least 15 minutes runtime
with easurements eliminting both factors external (e.g. processor temperature and clock
throttle) as well as internal to simulation (e.g. load-balancer) reach
a stable state.  Therefore, it is strongly recommended to exclude the initial "warm-up"
phase by extending the runs to a sufficient total length (e.g. 2\*15 minutes if using `-resethway`)
and resetting the internal timers using `-resethway` or `-resetstep N` options.

## Contact
# TODO
Questions regarding the benchmark(s) must be posted via 
