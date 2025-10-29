# [CACTI](https://github.com/HewlettPackard/cacti) simulation for MemTech course (AUT)

## Overview

This repository contains the setup, execution, and analysis of various cache configurations using CACTI tool. CACTI is a widely-used tool for evaluating cache memory architectures, providing detailed insights into critical parameters such as power consumption, area, and timing. The primary objective of this study is to evaluate and optimize cache configurations under different system parameters, focusing on configurations with varying cache sizes, associativities, block sizes, and port counts.

## Simulation Setup

### 1. Base Configuration

A foundational CACTI configuration file was created to model a cache system with a specific set of parameters. This base configuration includes the following parameters:
- **Technology Size**: Defines the manufacturing process, affecting performance, power, and area.
- **Associativity**: Defines the number of ways in which cache lines are associated with a set.
- **Cache Size**: Total capacity of the cache, which can be varied to study performance vs. size trade-offs.
- **Block Size**: Size of a cache block, which impacts the cache hit rate and memory bandwidth utilization.

This initial configuration serves as a template for generating variations across different cache setups.

### 2. Automated Configuration Generation

A shell script `generateAndSimulateConfigs.sh` was developed to facilitate the exploration of multiple cache configurations. The script automates the following tasks:

- **Cache Configuration Generation**: The script reads the base configuration and dynamically adjusts the key parameters (cache size, block size, associativity, number of ports, etc.) to generate multiple unique cache configuration files. 
- **Simulation Execution**: After generating the configuration files, the script runs **CACTI** for each configuration file. CACTI performs simulations and writes the output to `.out` files, capturing critical data such as access times, dynamic power consumption, leakage power, and area efficiency.

### 3. Simulation Outputs

The simulation generates output files containing the following parameters for each cache configuration:

- **Access Time (ns)**: The time it takes for the cache to perform a read or write operation.
- **Dynamic Read/Write Energy (nJ)**: The energy consumed during read and write operations, crucial for energy-efficient designs.
- **Leakage Power (mW)**: The idle power consumption of the cache, representing the power lost when the cache is not actively being accessed.
- **Area Efficiency (%)**: The efficiency of the cache's memory usage, indicating how well the physical area is utilized by memory cells.

### 4. Results Storage

All generated output files are stored in the `result` directory. Each output file corresponds to a specific cache configuration, and provides a comprehensive set of performance metrics that can be analyzed and compared for optimization.

## Objective and Impact

The primary goal of this project is to assess the trade-offs between cache performance, power consumption, and area. By varying cache configurations and analyzing the resulting data, we aim to identify configurations that offer the best balance of speed, energy efficiency, and spatial utilization. These findings can be applied to the design of efficient memory systems for embedded systems, high-performance processors, and other hardware applications.

## Future Directions

In future iterations, the following improvements and analyses will be considered:

- **Port Configuration Optimization**: Further experiments to evaluate the impact of varying the number of read/write ports on cache performance and power.
- **Advanced Cache Architectures**: Simulation of advanced cache designs like non-uniform cache access (NUCA) and multi-level caches.
- **Integration with McPAT and gem5**: Incorporating CACTI's results into system-level simulations (e.g., McPAT and gem5) for a comprehensive evaluation of cache performance in real-world applications.

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/HewlettPackard/cacti.git
   cd cacti
   make
2. Automated Configuration Generation and Test:
   ```bash
   cd ..
   git clone https://github.com/salirezaeb/cactiSimFall2025
   mv generateAndSimulateConfigs.sh ./cacti
   cd ./cacti
   chmod 755 generateAndSimulateConfigs
   ./generateAndSimulateConfigs

Results and Analysis:

After completing the above steps, the simulation results are stored in .out files corresponding to each configuration simulated. These output files contain detailed performance data, including access times, energy consumption, and other important metrics for different cache configurations.

Additionally, a summary of the overall results, including key performance indicators and trends observed from the simulations, is documented in the result.txt file. This file provides a comprehensive analysis of the different configurations tested, highlighting the impact of varying parameters such as cache size, block size, and associativity on the performance and power efficiency of the cache model.
