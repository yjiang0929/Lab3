#!/bin/bash
#Make the approrpriate files
iverilog -o alutest alu.t.v
iverilog -o decodertest decoder.t.v
iverilog -o muxtest mux.t.v
iverilog -o regfiletest regfile.t.v
iverilog -o signExttest signExt.t.v
iverilog -o cputest cpu.t.v


#Run the appropriate tests
echo "Running tests with quiet outputs unless incorrect."
./alutest
./decodertest
./muxtest
./regfiletest
./signExttest
echo "Running tests with verbose outputs (testing entire cpu)."
./scripted_tests.sh

echo "Removing test files."
rm alutest decodertest muxtest regfiletest signExttest cputest
