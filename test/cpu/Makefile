AS = mips-linux-gnu-as
GCC = mips-linux-gnu-gcc
OBJCOPY = mips-linux-gnu-objcopy

OBJS = $(shell ls tb*.asm | sed -e 's/.asm/.elf/')
HEXS = $(shell ls tb*.asm | sed -e 's/.asm/.hex/')
OUTS = $(shell ls tb*.asm | sed -e 's/.asm/.out/')
VSRC = $(shell ls ../../*.v)

all: $(OBJS) $(HEXS) $(OUTS)

# %.out: %.fv
# 	./$< > $<.out

# %.fv: cpu_tb.v
# 	iverilog -o $@ $< -I../../
.PRECIOUS: %.elf %.text %.fv

bin2hex: bin2hex.c
	gcc -o $@ $<

%.elf: %.asm
	$(AS) -O0 -mips32 -o $@ $<

%.text: %.elf
	$(OBJCOPY) -O binary --only-section=.text $< $@

%.hex: %.text bin2hex
	./bin2hex $< $@

%.out: %.fv
	# ./$< > $@
	./$<

%.fv: %.hex cpu_tb.v $(VSRC)
	iverilog -I../../				\
		-DIM_DATA_FILE=\"$<\"		\
		-DDEBUG_CPU					\
		-DDUMP_FILE="\"$@.vcd\""	\
		-g2005						\
		-o $@ 						\
		cpu_tb.v

clean:
	-rm -r *.fv
	-rm -r *.out
	-rm -r *.hex
	-rm -r *.elf
	-rm -r *.text