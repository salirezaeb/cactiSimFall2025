!/bin/bash
# ==========================================================
# CACTI AUTOMATION SCRIPT
# Author: Alireza Ebrahimian
# Description:
#   1. Generates all desired cache configurations from base cfg
#   2. Runs CACTI simulations for each config
#   3. Saves full text reports (*.cfg.out) like native CACTI output
# ==========================================================

CACTI_EXEC="./cacti"
BASE_CFG="ddr3_cache.cfg"

# List of configurations: SIZE(Bytes)  WAY  TECH(nm)  LABEL
declare -a CONFIGS=(
  "32768 4 22 32KB_4Way_22nm"
  "32768 4 45 32KB_4Way_45nm"
  "32768 4 90 32KB_4Way_90nm"
  "1048576 8 22 1MB_8Way_22nm"
  "1048576 8 45 1MB_8Way_45nm"
  "1048576 8 90 1MB_8Way_90nm"
)

# ==========================================================
# 1️⃣  Initial Checks
# ==========================================================
if [ ! -x "$CACTI_EXEC" ]; then
  echo "❌ ERROR: CACTI executable not found or not executable."
  exit 1
fi

if [ ! -f "$BASE_CFG" ]; then
  echo "❌ ERROR: Base configuration file '$BASE_CFG' not found."
  exit 1
fi

# ==========================================================
# 2️⃣  Simulation Loop
# ==========================================================
echo "🚀 Starting CACTI simulations..."
echo "-----------------------------------------"

for cfg in "${CONFIGS[@]}"; do
  read SIZE WAY TECH LABEL <<< "$cfg"
  NEWCFG="${LABEL}.cfg"
  OUTFILE="${LABEL}.cfg.out"

  echo "⚙️  Generating config: $LABEL"

  # Copy base config and modify parameters
  cp "$BASE_CFG" "$NEWCFG"
  sed -i "s/^-size (bytes).*/-size (bytes) $SIZE/" "$NEWCFG"
  sed -i "s/^-associativity.*/-associativity $WAY/" "$NEWCFG"
  sed -i "s/^-technology (u).*/-technology (u) 0.0${TECH}/" "$NEWCFG"

  # Run simulation
  echo "▶️  Running CACTI for $LABEL ..."
  "$CACTI_EXEC" -infile "$NEWCFG" > "$OUTFILE" 2> /dev/null

  # Verify result
  if grep -q "Access time (ns)" "$OUTFILE"; then
    echo "✅ Simulation complete: $OUTFILE"
  else
    echo "⚠️  Warning: Possible crash or missing data for $LABEL"
  fi

  echo "-----------------------------------------"
done

# ==========================================================
# 3️⃣  Final Summary
# ==========================================================
echo "✅ All simulations finished!"
echo "📁 Generated files:"
ls -1 *.cfg.out
echo "-----------------------------------------"
echo "Each .cfg.out contains full CACTI report including:"
echo "   • Time Components"
echo "   • Power Components"
echo "   • Area Components"
echo "   • Wire Properties"
echo "==========================================================="

