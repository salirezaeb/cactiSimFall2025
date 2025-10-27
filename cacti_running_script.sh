#!/bin/bash

BASE="ddr3_cache.cfg"
CACTI_EXEC="./cacti"
OUTCSV="results.csv"

if [ ! -f "$BASE" ]; then
    echo "Base file $BASE not found!"
    exit 1
fi

if [ ! -x "$CACTI_EXEC" ]; then
    echo "Cacti executable not found or not executable!"
    exit 1
fi

echo "Config,Access_time(ns),Cycle_time(ns),Read_energy(nJ),Write_energy(nJ),Leakage_power(mW),Area(mm2)" > $OUTCSV

make_cfg() {
    SIZE_BYTES=$1
    WAYS=$2
    TECH=$3
    LABEL=$4
    OUTFILE="${LABEL}.cfg"

    cp "$BASE" "$OUTFILE"
    sed -i "s/^-size (bytes).*/-size (bytes) $SIZE_BYTES/" "$OUTFILE"
    sed -i "s/^-associativity.*/-associativity $WAYS/" "$OUTFILE"
    sed -i "s/^-technology (u).*/-technology (u) 0.${TECH}/" "$OUTFILE"

    RESULT=$($CACTI_EXEC -infile "$OUTFILE" 2>/dev/null)

    ACCESS=$(echo "$RESULT" | grep "Access time (ns)" | awk '{print $4}')
    CYCLE=$(echo "$RESULT" | grep "Cycle time (ns)" | awk '{print $4}')
    READ=$(echo "$RESULT" | grep "Total dynamic read energy per access" | awk '{print $8}')
    WRITE=$(echo "$RESULT" | grep "Total dynamic write energy per access" | awk '{print $8}')
    LEAK=$(echo "$RESULT" | grep "Total leakage power of a bank" | head -1 | awk '{print $8}')
    AREA=$(echo "$RESULT" | grep "Cache height x width" | awk '{print $8}')

    echo "$LABEL,$ACCESS,$CYCLE,$READ,$WRITE,$LEAK,$AREA" >> $OUTCSV
    echo "✅ Done: $LABEL"
}

make_cfg 32768 4 045 32KB_4way_45nm
make_cfg 1048576 8 045 1MB_8way_45nm
make_cfg 32768 4 090 32KB_4way_90nm
make_cfg 1048576 8 090 1MB_8way_90nm
make_cfg 32768 4 022 32KB_4way_22nm
make_cfg 1048576 8 022 1MB_8way_22nm

echo "------------------------------------------"
echo "All done! Results saved in: $OUTCSV"
cat $OUTCSV
