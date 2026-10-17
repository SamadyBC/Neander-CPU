#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p sim/build
iverilog -Wall -g2005 -s individual_programs_tb -o sim/build/individual_programs.vvp rtl/*.v testbenches/individual_programs_tb.v 2>sim/build/individual_programs.compile.log
vvp sim/build/individual_programs.vvp | tee sim/build/individual_programs.log
# Verilog $finish does not report assertion failures as a shell exit code.
# Require the bench's final success message as well as a successful simulation.
grep -qx 'PASS: all seven programs' sim/build/individual_programs.log
