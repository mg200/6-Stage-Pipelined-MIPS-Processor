# TO RUN THE CODE YOU FIRST COPY PASTE YOUR PROGRAM IN A FILE PROGRAM.TXT (IT ALREADY HAS THE SAMPLE TESTCASES UPLOADED ON BLACKBOARD)
# ---------------On a Linux system-------------------- 
To compile, type make
then to run (the final output will be in final.mem)
type in order
1) make run1
2) make run2
3) make run3
The final output would now be in final.mem file


# -----------------On a Windows System--------------------
# To compile, type 
	gcc Assembler.c -lm -o Assembler.out
	gcc InitializeFiles.c -o InitializeFiles.out
	gcc TxtToMem.c -o TxtToMem.out

# To run, type in order
./InitializeFiles.out 	
./Assembler.out program.txt		
./TxtToMem.out 
