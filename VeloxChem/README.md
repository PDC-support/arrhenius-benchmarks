# VeloxChem benchmark

This directory contains documentation and input files for the 
VeloxChem benchmark. 

VeloxChem (https://veloxchem.org/) is a Python-based open-source quantum chemistry software 
developed for the calculation of molecular properties and simulation 
of a variety of spectroscopies. It features interactive program access 
through Jupyter notebooks as well as large-scale calculations in 
contemporary high-performance computing (HPC) environments. 

## Source code

### Obtaining the source code

Three versions (CPU, GPU-CUDA and GPU-HIP) of the VeloxChem code are provided for the benchmark.

- CPU version (for module 1):
  - https://github.com/VeloxChem/VeloxChem/releases/tag/cpu-bench
- GPU version (for module 2):
  - GPU-CUDA version:
    - https://github.com/VeloxChem/VeloxChem/releases/tag/cuda-bench
  - GPU-HIP version:
    - https://github.com/VeloxChem/VeloxChem/releases/tag/hip-bench

### Guidelines for modifying the source code

A limited amount of modifications to the VeloxChem source code are acceptable as long as these
modifications, for example new compute kernels or optimizations to
existing kernels, must be made available for integration in the
VeloxChem source code. The contributions must be made available before the
acceptance benchmark runs on the delivered system.

## Installation guide

### CPU version

The CPU version of VeloxChem has been tested with Intel, GNU and Clang
compilers. 

See [installation-guide/install-vlx-cpu.md](installation-guide/install-vlx-cpu.md) for detailed instructions for installing VeloxChem CPU version.

### GPU version

#### GPU-CUDA version

The GPU-CUDA version of VeloxChem has been tested with the GNU compiler for the
host and the `nvcc` compiler for the device.

See [installation-guide/install-vlx-gpu-cuda.md](installation-guide/install-vlx-gpu-cuda.md) for detailed instructions for installing VeloxChem GPU-CUDA version.

#### GPU-HIP version

The GPU-HIP version of VeloxChem has been tested with the Clang compiler for the
host and the `hipcc` compiler for the device.

See [installation-guide/install-vlx-gpu-hip.md](installation-guide/install-vlx-gpu-hip.md) for detailed instructions for installing VeloxChem GPU-HIP version.

## Benchmark case

The test case (in subfolder [g-quad-neutral/](g-quad-neutral/)) is self-consistent field 
calculation of G-quadruplex. It contains 736 atoms and 7949 basis functions 
(using the `def2-SVP` basis set).

### Running the benchmark

- The benchmark must be run on at least two compute nodes.

### Minimum performance

- On module 1 (CPU version), the total walltime to complete the benchmark must not exceed 3200 seconds.
- On module 2 (GPU version), the total walltime to complete the benchmark must not exceed 1200 seconds.

### Validation of results

- Check the number of iterations by executing `cat
g-quad-neutral.out | grep "SCF converged"`, and make sure that the
benchmark uses exactly 11 iterations.

- Check the total energy by executing `cat
g-quad-neutral.out | grep "Total Energy"`, and make sure that the
result matches the  reference value below

  - On module 1 (CPU version), the total energy must match `-30517.3986526537 a.u.` with at least 12 significant digits.
  - On module 2 (GPU version), the total energy must match `-30517.3986504616 a.u.` with at least 12 significant digits.

### Obtaining benchmark results

- The total walltime spent in the benchmark can be obtained by executing `cat
g-quad-neutral.out | grep "Total execution time"`

- Reference benchmark timing
  - CPU version on [Dardel](https://www.pdc.kth.se/hpc-services/computing-systems/about-the-dardel-hpc-system-1.1053338): 3194 seconds on 8 Dardel-CPU nodes
  - GPU-HIP version on [Dardel](https://www.pdc.kth.se/hpc-services/computing-systems/about-the-dardel-hpc-system-1.1053338): 882 seconds on 4 Dardel-GPU nodes
