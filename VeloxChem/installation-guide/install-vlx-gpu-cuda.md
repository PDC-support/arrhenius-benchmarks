# Installing VeloxChem GPU-CUDA version

## Prerequisites

- C++ compiler with C++17 standard and OpenMP support
- MPI library
- CUDA (>=11.7.0)
- Python (>=3.8)

## Set VLXHOME

```bash
git clone -b benchmark-gpu-cuda https://github.com/VeloxChem/VeloxChem.git veloxchem.gpu-cuda

cd VeloxChem.gpu-cuda
export VLXHOME=$(pwd)
```

## Install Python packages

VeloxChem GPU-CUDA version depends on the following Python packages:

- `numpy`
- `pybind11`
- `pytest`
- `mpi4py`

It is recommended to install these packages and VeloxChem in a Python virtual environment such as `$VLXHOME/vlxenv`.

Please note that `mpi4py` should be compiled from source using the same compiler and MPI library as for compiling VeloxChem. Below
is an example of installing mpi4py using `gcc`.

```bash
export CC=gcc
export MPICC=mpicc
python3 -m pip install --no-deps --no-binary=mpi4py --no-cache-dir --no-cache -v mpi4py
```

## Install VeloxChem GPU-CUDA version

Please edit VeloxChem's `src/Makefile.setup` file and update the following

- `CUDA_LIB_DIR`: where `libcudart`, `libcublas` and `libcusolver` can be found. If these files are in different folders,
  you can manually add them in the `DEVICE_LIB` line in `src/Makefile.setup`
- `MPI_INC_DIR`: where the MPI header files can be found.
- `CXX`: The MPI compiler wrapper for host C++ code.
- `DEVCC`: The CUDA compiler for device code. The compute capability is also specified in this line. 

Then compile VeloxChem using `make`

```bash
cd $VLXHOME
make -C src -j 64
```

## Test VeloxChem GPU-CUDA version

```bash
cd $VLXHOME

source $VLXHOME/vlxenv/bin/activate
export PYTHONPATH=$VLXHOME/build/python:$PYTHONPATH
export PATH=$VLXHOME/build/bin:$PATH

# Note: Update OMP_NUM_THREADS to the number of physical cores per node
export OMP_NUM_THREADS=64
export OMP_PLACES=cores

python3 -m pytest -v -s -x tests/
```

## Run VeloxChem GPU-CUDA version

- VeloxChem GPU-CUDA version uses one MPI process per compute node.
- It is recommended to set `OMP_NUM_THREADS` to the number of physical cores per node.
- You can try different `OMP_PLACES` settings but normally setting `OMP_PLACES` to `cores` should suffice.
- The following lines are needed in the job script. Note that `VLXHOME` should be updated to the actual path.
  - `export VLXHOME=/path/to/VeloxChem.gpu-cuda`
  - `source $VLXHOME/vlxenv/bin/activate`
  - `export PYTHONPATH=$VLXHOME/build/python:$PYTHONPATH`
  - `export PATH=$VLXHOME/build/bin:$PATH`
- You can use the `vlx` entry script to run the benchmark calculation, for example
  - `srun vlx g-quad-neutral.inp g-quad-neutral.out`
