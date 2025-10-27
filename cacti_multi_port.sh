#!/bin/bash
BASE_CFG="ddr3_cache.cfg"
OUTPUT="ports_results.csv"
echo "Ports,Access_time(ns),Cycle_time(ns),Read_energy(nJ),Write_energy(nJ),Leakage_power(mW),Area(mm2)" > $OUTPUT
for PORTS in 1 2 4 8; do
    CFG_FILE="port_${PORTS}.cfg"
    sed -e "s/-read-write port .*/-read-write port ${PORTS}/" \
        -e "s/-size (bytes) .*/-size (bytes) 32768/" \
        -e "s/-associativity .*/-associativity 4/" \
        -e "s/-technology (u) .*/-technology (u) 0.045/" \
        "$BASE_CFG" > "$CFG_FILE"
    ./cacti -infile "$CFG_FILE" > "port_${PORTS}.out" 2>/dev/null
    if grep -q "Access time (ns)" "port_${PORTS}.out"; then
        access=$(grep "Access time (ns)" "port_${PORTS}.out" | awk '{print $4}')
        cycle=$(grep "Cycle time (ns)" "port_${PORTS}.out" | awk '{print $4}')
        readE=$(grep "Total dynamic read energy per access" "port_${PORTS}.out" | awk '{print $8}')
        writeE=$(grep "Total dynamic write energy per access" "port_${PORTS}.out" | awk '{print $8}')
        leak=$(grep "Total leakage power of a bank (mW)" "port_${PORTS}.out" | head -1 | awk '{print $8}')
        area=$(grep "Cache height x width" "port_${PORTS}.out" | awk '{print $6*$8}')
        echo "${PORTS},${access},${cycle},${readE},${writeE},${leak},${area}" >> $OUTPUT
    else
        echo "${PORTS},ERROR,ERROR,ERROR,ERROR,ERROR,ERROR" >> $OUTPUT
    fi
done
echo "done"

