
# clean:

compile: 
		gcc Assembler.c -lm -o Assembler.out

run: 
	./Assembler.out prog1.txt		
rcompile:
	gcc TxtToMem.c -o TxtToMem.out

run2:
	./TxtToMem.out 

