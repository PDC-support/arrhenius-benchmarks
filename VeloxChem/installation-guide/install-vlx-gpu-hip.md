# Installing VeloxChem GPU-HIP version

## Prerequisites

- C++ compiler with C++17 standard and OpenMP support
- MPI library
- ROCm (>=5.7.0)
- Python (>=3.8)

Note: If you use GNU compiler for host C++ code, please make sure that it is only linked with LLVM OpenMP runtime library (`libomp`).

## Set VLXHOME

```bash
git clone -b benchmark-gpu-hip https://github.com/VeloxChem/VeloxChem.git veloxchem.gpu-hip

cd VeloxChem.gpu-hip
export VLXHOME=$(pwd)
```

## Install MAGMA

VeloxChem GPU-HIP version uses [MAGMA](https://bitbucket.org/icl/magma/downloads/?tab=tags) for efficient matrix diagonalization. 
Below is an example of installing MAGMA with OpenBLAS backend. Note that you need to edit MAGMA's `make.inc` file and update `OPENBLASDIR`, 
`ROCM_PATH`, `FORT` and `GPU_TARGET` therein.

```bash
export MAGMAHOME=$VLXHOME/dependencies/magma
mkdir -p $MAGMAHOME/src
cd $MAGMAHOME/src
curl -LO https://bitbucket.org/icl/magma/get/06368d9b817710566f654b96114549216f8cee70.tar.gz
tar xf 06368d9b817710566f654b96114549216f8cee70.tar.gz
cd icl-magma-06368d9b8177/
cp make.inc-examples/make.inc.hip-gcc-openblas make.inc
# Edit make.inc
# Update OPENBLASDIR, ROCM_PATH, FORT and GPU_TARGET
# FORT should point to flang under rocm's llvm/bin
make -f make.gen.hipMAGMA -j 128
make lib/libmagma.so -j 128
cp -RP include $MAGMAHOME/
cp -RP lib $MAGMAHOME/
```

## Install Python packages

VeloxChem GPU-HIP version depends on the following Python packages:

- `numpy`
- `pybind11`
- `pytest`
- `mpi4py`

It is recommended to install these packages and VeloxChem in a Python virtual environment such as `$VLXHOME/vlxenv`.

Please note that `mpi4py` should be compiled from source using the same compiler and MPI library as for compiling VeloxChem. Below
is an example of installing mpi4py from source using user-defined `CC` and `MPICC` compilers.

```bash
export CC=...
export MPICC=...
python3 -m pip install --no-deps --no-binary=mpi4py --no-cache-dir --no-cache -v mpi4py
```

## Install VeloxChem GPU-HIP version

Please update `HIPCC_COMPILE_FLAGS_APPEND` with MPI include folder 

```bash
export HIPCC_COMPILE_FLAGS_APPEND="-I/path/to/mpi/include"
```

Then edit VeloxChem's `src/Makefile.setup` file and update the following

- `MAGMA_HOME`: where `MAGMA` is installed.
- `CXX`: The MPI compiler wrapper for host C++ code.
- `DEVCC`: The HIP compiler for device code. `--offload-arch` is also specified in this line. 

Then compile VeloxChem using `make`

```bash
cd $VLXHOME
make -C src -j 64
```

## Test VeloxChem GPU-HIP version

```
cd $VLXHOME

# Note: Update OPENBLASHOME and MAGMAHOME to actual paths
export OPENBLASHOME=...
export MAGMAHOME=...

export LD_LIBRARY_PATH=$OPENBLASHOME/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$MAGMAHOME/lib:$LD_LIBRARY_PATH

source $VLXHOME/vlxenv/bin/activate
export PYTHONPATH=$VLXHOME/build/python:$PYTHONPATH
export PATH=$VLXHOME/build/bin:$PATH

# Note: Update OMP_NUM_THREADS to the number of physical cores per node
export OMP_NUM_THREADS=64
export OMP_PLACES=cores

python3 -m pytest -v -s -x tests/
```

## Running VeloxChem GPU-HIP version

- VeloxChem GPU-HIP version uses one MPI process per compute node.
- It is recommended to set `OMP_NUM_THREADS` to the number of physical cores per node.
- You can try different `OMP_PLACES` settings but normally setting `OMP_PLACES` to `cores` should suffice.
- The following lines are needed in the job script. Note that `OPENBLASHOME`, `MAGMAHOME` and `VLXHOME` should be updated to the actual path.
  - `export OPENBLASHOME=...`
  - `export MAGMAHOME=...`
  - `export LD_LIBRARY_PATH=$MAGMAHOME/lib:$OPENBLASHOME/lib:$LD_LIBRARY_PATH`
  - `export VLXHOME=...`
  - `source $VLXHOME/vlxenv/bin/activate`
  - `export PYTHONPATH=$VLXHOME/build/python:$PYTHONPATH`
  - `export PATH=$VLXHOME/build/bin:$PATH`
- You can use the `vlx` entry script to run the benchmark calculation, for example
  - `srun vlx g-quad-neutral.inp g-quad-neutral.out`
