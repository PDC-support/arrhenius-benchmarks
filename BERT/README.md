# BERT benchmark


This directory contains general information regarding the MLPerf training benchmarks for BERT. 

BERT (Bidirectional Encoder Representations from Transformers) is a deep learning model developed by Google that has revolutionized natural language processing (NLP). 

MLPerf is a widely recognized benchmarking suite designed to evaluate the performance of machine learning (ML) hardware, software, and algorithms. It provides standardized tests that measure how effectively systems can handle various ML tasks.

## Source code


### Obtaining the source code

The BERT benchmark source code is part of the [MLPerf Training](https://github.com/mlcommons/training) repository. You can obtain the latest version of the source code from their official GitHub page at MLPerf Training. Specifically, the BERT implementation used for benchmarking can be found under the `language_model/tensorflow/bert` directory.

To download the source code, use the following command:

```
git clone https://github.com/mlcommons/training.git
cd mlcommons/training/tree/master/language_model/tensorflow/bert
```


### License

The BERT benchmark source code and associated assets are distributed under the Apache License 2.0. This is an open-source license that allows for modification, redistribution, and commercial use, provided that the license terms are maintained.

For more details, please review the license file included in the repository or visit the Apache License 2.0 page.

### Guidelines for Porting and Modifying the Source Code

The [MLPerf Training](https://github.com/mlcommons/training) repository is a reference implementation of BERT for the MLPerf training benchmarks. The implementation serves as a reference for benchmark purposes but may not be fully optimized for measuring the real-world performance of specific software frameworks or hardware. 

Modifications may be necessary to optimize it for NVIDIA or AMD hardwares. Vendors are responsible for implementing their own optimizations using their platforms to achieve the best possible performance.

Key optimization areas for NVIDIA hardware:

- **Use Latest CUDA and cuDNN Versions:** Ensure that the latest versions of **CUDA** and **cuDNN** are installed and configured correctly. cuDNN provides highly optimized implementations for deep learning primitives such as convolutions and matrix multiplications.
  
- **Multi-GPU Scaling with NCCL:** For multi-GPU systems, use **NCCL** (NVIDIA Collective Communication Library) to optimize inter-GPU communication. NCCL is designed to scale efficiently across multiple GPUs in the same system in a distributed setup.
  
- **Mixed Precision Training with Tensor Cores:** Leverage **Tensor Cores** available on NVIDIA GPUs (starting with the Volta architecture) to accelerate mixed precision training. NVIDIA’s **Automatic Mixed Precision (AMP)** can be used to achieve significant speedups while maintaining accuracy.
  
<!-- - **Optimize Data Pipeline with DALI:** Integrate **NVIDIA DALI (Data Loading Library)** to efficiently handle data preprocessing. DALI helps reduce bottlenecks in the input pipeline, ensuring that the GPUs are consistently fed with data for optimal training performance. -->

<!-- - **Custom Kernel Tuning:** For highly customized workloads, consider using **CUDA kernel tuning** to further optimize performance-critical operations. However, for most vendors, the pre-optimized deep learning libraries will provide significant performance out of the box. -->

Here are the key guidelines for AMD hardware:
- **Use ROCm ML Libraries:** Utilize AMD’s ROCm ML libraries (e.g., MIOpen for deep learning primitives) to optimize performance.
- **Multi-GPU Scaling:** Implement support for multi-GPU setups using RCCL, AMD’s library equivalent to NVIDIA's NCCL for scalable inter-GPU communication.
- **Custom Optimizations:** Develop and integrate custom optimizations for specific AMD hardware. Ensure that BERT operations like matrix multiplications, tensor contractions, and activation functions are optimized to take full advantage of the GPU architecture.


Please read NVIDIA's submission to [MLPerf Training v4.0](https://github.com/mlcommons/training_results_v4.0/tree/main/NVIDIA/benchmarks/bert/implementations/eos_ngc23.04_pytorch) as a reference implementation.

<!-- ## Installation guide

We recommend using Apptainer, a container platform optimized for high-performance computing (HPC) environments. Apptainer ensures consistent, portable, and reproducible environments across diverse systems, making it an ideal choice for running the BERT benchmark. -->

<!-- Before implementing the BERT benchmark, ensure the following software and hardware prerequisites are met:

- **Apptainer:** Apptainer is a container platform similar to Docker but optimized for high-performance computing (HPC) environments. Ensure that Apptainer is installed on your system. -->
  
<!-- - **SLURM Workload Manager:** Ensure SLURM is installed and configured for job scheduling and resource management.

- **For NVIDIA GPUs:**
  - Ensure you have NVIDIA drivers compatible with the selected container.
  - Use the official **NGC PyTorch container** from NVIDIA’s NGC (NVIDIA GPU Cloud).

- **For AMD GPUs:**
  - Install AMD ROCm drivers.
  - Use the official **ROCm PyTorch container**. -->

<!-- For multi-GPU setups, Apptainer can be used in combination with MPI or other communication libraries (such as NCCL for NVIDIA or RCCL for AMD). Make sure that your environment supports inter-node communication, and configure the container accordingly. -->

## Performance considerations

To achieve optimal performance when running the BERT benchmark, consider the following:

- Batch Size: Larger batch sizes typically increase throughput but require more GPU memory. Vendors should adjust batch size based on available GPU memory and system capabilities.

- Mixed Precision Training: Mixed precision can significantly accelerate training. NVIDIA GPUs support AMP (Automatic Mixed Precision), which allows floating-point 16-bit (FP16) calculations while maintaining model accuracy. For AMD, check if the ROCm version supports mixed precision.

- Dataset Preparation: Vendors should use the Wikipedia datasets as outlined in the MLPerf guidelines. Ensure datasets are pre-processed and formatted correctly before running the benchmark.

- Data Preprocessing: Preprocessing large datasets efficiently is essential. Utilize frameworks like NVIDIA DALI or ROCm’s alternatives to accelerate data loading and augment data pipelines.

<!-- - Distributed Training: For large-scale benchmarks, utilizing multiple GPUs or nodes is necessary. Ensure that the communication between GPUs is optimized using NCCL (for NVIDIA) or RCCL (for AMD). -->
- Distributed Training: For large-scale benchmarks, utilizing multiple GPUs is necessary. Ensure that the communication between GPUs is optimized using NCCL (for NVIDIA) or RCCL (for AMD).



## Benchmark case

In MLPerf, the main performance metric for the BERT training benchmark is **time-to-train**, which refers to the total time taken to achieve a specific [accuracy threshold](https://github.com/mlcommons/training/tree/master/language_model/tensorflow/bert). The accuracy target is typically defined as the minimum model accuracy on the evaluation set required by the benchmark rules.

For BERT training, the following performance criteria apply:

- **Accuracy Threshold:** The model must achieve a target accuracy of **72%** on the Masked Language Model (MLM) task on the evaluation set.
  
- **Time-to-Train:** The benchmark measures how long it takes for the model to reach this accuracy on the evaluation dataset. This includes the full duration from the start of training until the accuracy threshold is met, and it is expressed in hours or minutes depending on the system’s capability.

### Running the benchmark case

Generally, a benchmark can be run with the following steps:

- Download and format the input data and any required checkpoints.
- Prepare the environment (e.g., build a container if needed or set up dependencies manually).
- Source the appropriate config_*.sh file.
- Run the benchmark job.

### Minimum performance

Key Considerations:

- **Vendor Benchmark Submissions:** Both NVIDIA and AMD systems should achieve the accuracy threshold in **25 minutes or less** on a single node with **8 GPUs**. The benchmark submission must include time-to-train data as the primary metric.
  
<!-- - **Performance on Multiple GPUs:** The time-to-train metric should scale efficiently with the number of GPUs. Vendors should demonstrate strong scaling across multiple GPUs and nodes, where applicable. -->
- **Performance on Multiple GPUs:** The time-to-train metric should scale efficiently with the number of GPUs. Vendors should demonstrate strong scaling across multiple GPUs, where applicable.

- **Mixed Precision and Optimizations:** To meet the 25-minute time-to-train target, vendors may use mixed precision training (e.g., NVIDIA Tensor Cores or AMD ROCm optimizations) and other hardware-specific accelerations to reduce time-to-train.

By achieving the 25-minute target on an 8-GPU node, vendors ensure that their systems are aligned with high-performance standards required for modern AI/ML workloads.


### Obtaining benchmark results

Log files are generated during the training process. Ensure that key metrics like training loss, throughput, and validation accuracy are captured. These log files should be submitted together with the benchmark report for full transparency and verification.

To account for the substantial variance in ML training times, final results are obtained by measuring the benchmark a benchmark-specific number of times, discarding the lowest and highest results, and averaging the remaining results. 

### Reference benchmark performance

The table below shows the results of the MLPerf Training Benchmarks , conducted using NVIDIA H100 and A100 GPUs.

| MLPerf Version | Hardware             | Number of Nodes | Number of GPUs | Latency (Minutes) |
|----------------|----------------------|-----------------|----------------|-------------------|
| 4.0            | NVIDIA-H100-SXM5-80GB | 1               | 8              | 5.469             |
| 2.0            | NVIDIA-A100-SXM-80GB  | 1               | 8              | 18.442            |


## Contact

Questions regarding the benchmark(s) must be posted via the "question and answer function" in Visma TendSign.

