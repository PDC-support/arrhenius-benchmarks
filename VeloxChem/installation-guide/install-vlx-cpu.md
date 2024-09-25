# Installing VeloxChem CPU version

## Prerequisites

- C++ compiler with C++17 standard and OpenMP support
- Linear algebra libraries implementing the BLAS and LAPACK interfaces (e.g. Intel MKL, OpenBLAS or Cray LibSci)
- MPI library
- Python (>=3.8)
- CMake
- [Libxc](https://libxc.gitlab.io/)

## Set VLXHOME

```bash
git clone -b cpu-bench https://github.com/VeloxChem/VeloxChem.git VeloxChem.cpu

cd VeloxChem.cpu
export VLXHOME=$(pwd)
```

## Install Python packages

VeloxChem CPU version depends on the following Python packages:

- `numpy`
- `h5py`
- `pybind11-global`
- `cmake`
- `scikit-build`
- `ninja`
- `pytest`
- `psutil`
- `geometric`
- `mpi4py`

It is recommended to install these packages and VeloxChem in a Python virtual environment such as `$VLXHOME/vlxenv`.

Please note that `mpi4py` should be compiled from source using the same compiler and MPI library as for compiling VeloxChem. 

Please also note that VeloxChem CPU version uses `numpy` for matrix diagonalization, and it is important to make sure that
the installed `numpy` has good performance.

## Install Libxc

Please follow the [Libxc installation](https://libxc.gitlab.io/installation/) page. It is recommended to install Libxc using CMake.

## Install VeloxChem CPU version

```bash
source $VLXHOME/vlxenv/bin/activate

# Note: replace <math_library> by the actual library (MKL, OpenBLAS or Cray)
#       replace <mpi_compiler> by e.g. mpicxx
export SKBUILD_CONFIGURE_OPTIONS="-DVLX_LA_VENDOR=<math_library> -DCMAKE_CXX_COMPILER=<mpi_cxx_compiler>"

# If you use OpenBLAS
export PKG_CONFIG_PATH=/path/to/openblas/lib/pkgconfig:$PKG_CONFIG_PATH

# Libxc is needed
export PKG_CONFIG_PATH=/path/to/libxc/lib/pkgconfig:$PKG_CONFIG_PATH

python3 -m pip install .
```

## Test VeloxChem CPU version

It is recommended to run VeloxChem CPU version with one MPI process per NUMA domain.

```bash
cd $VLXHOME

# If you use OpenBLAS
export LD_LIBRARY_PATH=/path/to/openblas/lib:$LD_LIBRARY_PATH

# Libxc is needed
export LD_LIBRARY_PATH=/path/to/libxc/lib:$LD_LIBRARY_PATH

source $VLXHOME/vlxenv/bin/activate

# Note: Update OMP_NUM_THREADS to the number of physical cores per NUMA domain
export OMP_NUM_THREADS=16
export OMP_PLACES=cores

python3 -m pytest -v -s -x python_tests/test_scf_*
```

## Run VeloxChem CPU version

- VeloxChem CPU version uses one MPI process per NUMA domain, which means that you may
  need to run multiple MPI processes per compute node.
- It is recommended to set `OMP_NUM_THREADS` to the number of physical cores per NUMA domain.
- It is recommended to set `OMP_PLACES` to `cores`.
- When using slurm on machines with hyperthreading or simultaneous multithreading enabled,
  one may need to set ``--cpus-per-task`` to twice `OMP_NUM_THREADS`.
- The following lines are needed in the job script. Note that `VLXHOME` and `LD_LIBRARY_PATH` should be updated to the actual paths.
  - `export LD_LIBRARY_PATH=/path/to/openblas/lib:$LD_LIBRARY_PATH`  (if you use OpenBLAS)
  - `export LD_LIBRARY_PATH=/path/to/libxc/lib:$LD_LIBRARY_PATH`
  - `export VLXHOME=/path/to/VeloxChem.cpu`
  - `source $VLXHOME/vlxenv/bin/activate`
- You can use the `vlx` entry script to run the benchmark calculation, for example
  - `srun vlx g-quad-neutral.inp g-quad-neutral.out`
