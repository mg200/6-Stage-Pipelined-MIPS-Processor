#include "headers.c"

int main(int argc, char*argv[]){
    
FILE*inputfile;
FILE*samplefile;
FILE*outputfile;
inputfile=fopen("output.txt","r");
     samplefile=fopen("asm3.mem","r");
     outputfile=fopen("final.mem","w");
    //  fseek(file, 0, SEEK_SET);
    // fscanf(ofile, "%*[^\n]"); // skip first line
    // fscanf(ofile, "%*[^\n]"); // skip first line
    // fscanf(ofile, "%*[^\n]"); // skip first line
    // fscanf(ofile, "%*[^\n]"); // skip first line
// fprintf(ofile,"00000\n");
static char header[100];
char buffer[25];
for(int i=0;i<3;i++){
    fgets(header,100,samplefile);
    printf("%s",header);
    fprintf(outputfile,"%s",header);
}
char instruction[17];
int num_of_instructions=0;
while(fscanf(inputfile, "%s", instruction) != EOF){
num_of_instructions++;
// printf("%s\n",instruction);
}

     fseek(inputfile, 0, SEEK_SET);//reset the file pointer to the beginning

     int mod4counter=0;
    int offset=0;

char array[74];
int firsttime=0;
for(int i=0;i<num_of_instructions;i++){
    // fgets(instruction,16,inputfile);
    fscanf(inputfile,"%s",instruction);
    printf("instruction %s\n",instruction);
fgets(buffer,25,samplefile);
int j=0;
for(int i=6;i<22;i++){
    buffer[i]=instruction[j];
    j++;
}
fprintf(outputfile,"%s",buffer);
}

// return 0;
for(int i=0;i<1024-num_of_instructions;i++){
fgets(buffer,25,samplefile);
    fprintf(outputfile,"%s",buffer);
}

}