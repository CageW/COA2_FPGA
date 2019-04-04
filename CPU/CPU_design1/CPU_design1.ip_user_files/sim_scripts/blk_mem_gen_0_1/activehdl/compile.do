vlib work
vlib activehdl

vlib activehdl/blk_mem_gen_v8_4_1
vlib activehdl/xil_defaultlib

vmap blk_mem_gen_v8_4_1 activehdl/blk_mem_gen_v8_4_1
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work blk_mem_gen_v8_4_1  -v2k5 \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../CPU_design1.srcs/sources_1/ip/blk_mem_gen_0_1/sim/blk_mem_gen_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

