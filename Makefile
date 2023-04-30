
# clean:

compile: 
	gcc Assembler.c -lm -o Assembler.out
	gcc InitializeFiles.c -o InitializeFiles.out
	gcc TxtToMem.c -o TxtToMem.out

run1:
	./InitializeFiles.out 	

run2: 
	./Assembler.out program.txt		

run3:
	./TxtToMem.out 

