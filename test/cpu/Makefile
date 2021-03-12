all: cpu_tb.fv cpu_tb.out

%.out: %.fv
	./$< > $<.out

%.fv: cpu_tb.v
	iverilog -o $@ $< -I../../

clean:
	rm -r *.fv
	rm -r *.fv.out