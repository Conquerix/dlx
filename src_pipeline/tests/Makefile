.PHONY : clean all simu compile

TB = DE1_SoC_tb

all: compile simu

simu:
	vsim -debugDB $(TB)

compile:
	../../dlxasm ../../tests_asm/code2.asm ../../rom/rom_data.txt
	vlog +acc +define+SIMULATION $(TB).sv ../*.sv

work:
	vlib work

# nettoyage 
clean : 
	rm -rf work *~
	rm -f transcript vsim.wlf
