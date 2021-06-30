all: rom_data.mif
clean:
	rm -f ../rom/rom_data.txt

rom_data.txt: ../tests_asm/prog.asm
	../dlxasm ../tests_asm/prog.asm ../rom/rom_data.txt

rom_data.mif: rom_data.txt
	srec_cat $< -Vmem -output $@ -mif 32
