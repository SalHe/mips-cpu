TBS = $(shell ls *_tb.v | sed -e 's/.v/.fv/')
OUTS = $(shell echo $(TBS) | sed -e 's/.fv/.fv.out/')


all: $(TBS) $(OUTS)

%_tb.fv: %_tb.v
	iverilog -o $@ $< -I../../

%_tb.fv.out: %_tb.fv
	./$< > ./$<.out

.PHONY:clean
clean:
	rm -f *.fv
	rm -f *.fv.out