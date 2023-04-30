#include "headers.c"


int main(int argc, char*argv[]){
FILE*templatefile,*outputfile;
// templatefile=fopen("zerotemplate.txt","r");
outputfile=fopen("output.txt","w");
// read the zeroes and place them in the output file
// do{
// char buffer[17];
// fgets(buffer, MAX_LINE,templatefile);
// fprintf(outputfile,"%s",buffer);
// }while(!feof(templatefile));

for(int i=0;i<1024;i++){
    fprintf(outputfile,"0000000000000000\n");
}
// int r=execl("Assembler.out","Assembler.out","prog1.txt",NULL);
// if(r!=1)printf("failed\n");
// int r2=execl("TxtToMem.out","TxtToMem.out",1,NULL);
// printf("---------r2 is %d",r2);
}