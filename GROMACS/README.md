# GROMACS benchmarks

This directory contains general information regarding the GROMACS
code, installation, and benchmarking considerations.  Information
specific to the GROMACS benchmark suite are to be found in the
subdirectories [navm-awh](./navm-awh) and
[stmv_gmx_v2](./stmv_gmx_v2).

Gromacs is a highly efficient and optimized code for Molecular
Dynamics simulations. The software requires a compiler which complies
with the C++14 standard and supports many hardware specific extensions
such as AVX and SVE. The code can make efficient use of GPUs as well.
An FFT library is the only required external library. The GROMACS build system is
able to compile FFTW for CPUs on demand, and a range of 
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
GROMACS source code. Specifically, the winning tender must provide
any modifications formatted to follow the [GROMACS contribution
guidelines](http://manual.gromacs.org/documentation/current/dev-manual/contribute.html).
The contributions must be made available before acceptance benchmark runs on the delivered system
under the same license as that used by GROMACS.

## Installation guide

For a detailed guide on prerequisites, how to configure and install
the software, see the [official GROMACS installation
guide](http://manual.gromacs.org/documentation/current/install-guide/index.html).

For best performance, it is recommended to use a recent compiler
toolchain. Particular care should be taken to ensure that the [right
SIMD instruction
set](http://manual.gromacs.org/documentation/current/install-guide/index.html#simd-support)
is enabled at configure time.

Note that if the official source distribution is altered we recommend that in such cases a custom version
string suffix is used (passed to cmake using `-DGMX_VERSION_STRING_OF_FORK=`).

### Validating a build

All binary builds/installations used for benchmarks must be validated
on the relevant range of resource counts. Specifically, the integration and regression must be also run multi-node.
The validation run outputs must be submitted with the benchmark report.
For the details on how to run validation follow the instruction at
[GROMACS for correctness](http://manual.gromacs.org/documentation/current/install-guide/index.html#testing-gromacs-for-correctness).

## Performance considerations

GROMACS supports running on a wide range of hardware and targets
multiple levels of hardware parallelism.  For inter-node
parallelization MPI is used both SPMD and
[MPMD](http://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html#).
Intra-node parallelization is done using SIMD compiler intrinsics,
OpenMP multi-threading as well as CUDA and SYCL for heterogeneous
parallelization using GPU acceleration.
Note that the recommended production GPU backends are CUDA for NVIDIA GPUs and
SYCL for Intel (DPC++) and AMD (ACPP), for details see 
[the GROMACS installation guide](https://manual.gromacs.org/documentation/current/install-guide/index.html#gpu-support).

For details on how to obtain the best performance, the reader is
recommended to consult the [relevant section of the GROMACS user
guide](http://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html#).

## Benchmark cases

The benchmark suite includes two GROMACS benchmark cases:

- [ensemble benchmark](./navm-awh)
- [strong scaling benchmark](./stmv_gmx_v2)

Further information about these benchmark cases is provided in README
files the respective subdirectories.


### Running the benchmark cases

For general instructions on how to execute the GROMACS ``mdrun``
simulation tool, see related instructions, examples and performance
checklist included in the [GROMACS performance
guide](http://manual.gromacs.org/documentation/current/user-guide/mdrun-performance.html#running-mdrun-within-a-single-node).

### Minimum performance

The ensemble benchmark will be evaluated based on sustained throughput benchmark
performance and requires a minimum performance to be met, [see](./navm-awh/readme.md).
The strong scaling benchmark will be evaluated based on the sustained peak performance
and requires the following minimum performance to be met, [see](./stmv_gmx_v2).

### Obtaining benchmark results

All benchmarks must be done using mixed-precision builds of GROMACS.

"ns/day", the simulation throughput expressed as simulated nanosecond per 24 hours
is the figure of merit (FOM) required to be entered in the in the benchmark
evaluation sheet.
The ``mdrun`` simulation tool prints a performance report at the end
of the log output which includes the (post-counter reset) wall-time and "ns/day".

Benchmark performance must be reported for at least 15 minutes runtime.
Recording performance must be done such that the initial 
until factors external to the simulation (e.g. component temperatures and clock frequencies)
as well as internal to simulation (e.g. load-balancer) reach a
sufficiently stable state that represents a production run.
Therefore, it is strongly recommended to exclude such initial "warm-up"
phase by extending the benchmark run to a sufficient total length
and excluding the initial part using the `mdrun` internal timer resetting options
`-resethway` or `-resetstep N`.
Simulation length can be specified using either:
- as the simulation wall-time in hours using ``-nsteps -1 -maxh T`` (run length will be `T*0.99` hours) or
- as the total number of iterations with ``-nsteps N``.
