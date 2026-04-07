#!/bin/bash
cd ./SCPU-RISCV/sources_1/new && iverilog -o sim.out *.v && vvp sim.out > output.txt 2>&1