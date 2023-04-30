#include "headers.c"



int main(int argc, char*argv[]){
// char a[100]="110201923";
// char buffer1[17];
// DigitConverter(a,strlen(a),16,buffer1);
//     return 0;
FILE*file;
FILE*outputfile;
char*FileName=argv[1];
char*outputFileName="output.txt";
outputfile=fopen(outputFileName,"wr");
char buffer[MAX_LINE];
// for(int i=0;i<100;i++)buffer[i]='\t';
file=fopen(FileName,"r");//input file, open for reading
if(file==NULL){
    perror("Error in opening file\n");
return 0;
}
long previousPosition=0,currentPosition=0;
int currentinputline=1,currentoutputline=1;
do{
previousPosition=ftell(file);//the cursor position of the line that after this line will be stored in buffer
fgets(buffer,MAX_LINE,file);
currentPosition=ftell(file);//the cursor position now(the start of the line after what's now in buffer)
currentinputline++;//update the current line of the cursor
char *p = buffer;
while (isspace((unsigned char )*p)) ++p;
if ( *p != '\0' )  /* the string is empty */ //check that the string is not empty  
{
    // currentoutputline++;//original place
    converttoUpper(buffer,sizeof(buffer));//converting all to upper case
    trimleadingandTrailing(buffer);//trimming leading and trailing white space
    cleanString(buffer);
    //at this point the string is clean, we now need to do two more checks
    //1. that it's not a commented line
if (buffer[0]=='#')continue;
// 2. that it's not .org X
if(buffer[0]=='.' &&
buffer[1]=='O'&&
buffer[2]=='R'&&
buffer[3]=='G'){
    handleOrg(outputfile,buffer,previousPosition,currentPosition,&currentoutputline);
    continue;
};
printf("%s",buffer);
// printf("%d",buffer[3]);
Parse(outputfile,buffer);
currentoutputline++;
}
}while(!feof(file));
  
}


void Parse(FILE*writeto,char*string){
    // printf("at parse begin 1%s size is %ld ",string);
char instructionString[4];
if(string[0]=='N'&&string[1]=='O'&&string[2]=='P'){
    fprintf(writeto,"0000000000000000\n");
    return;
}else if(string[0]=='R'&&string[1]=='E'&&string[2]=='T'){
fprintf(writeto,"0110100000000000\n");
    return;
}else if (string[0]=='R'&&string[1]=='T'&&string[2]=='I'){//RTI
    fprintf(writeto,"0111000000000000\n");
    return;
}
else if (string[3]!=' '&&string[4]==' '&&string[0]!='I'&&string[0]!='O'){//push or CALL
TrimWhiteSpaces(string+5);
if(string[0]=='P'){//push instruction 
fprintf(writeto,"01010");
// printf("hello");
}
else if(string[3]=='L'){//call instruction
fprintf(writeto,"01100");
}
    ParseOpIType(writeto,string,5);
}else if(string[3]=='C'){
    
    if(string[0]=='S'){//SETC
    fprintf(writeto,"1111000000000000\n");
    }else if(string[0]=='C'){
    fprintf(writeto,"0010000000000000\n");
    }
return;
}else if(string[3]=='D'){//IADD
    TrimWhiteSpaces(string+5);
printf("Full Trim %s\n",string);
fprintf(writeto,"10010");
    ParseOpIType(writeto,string,6);
    char hex[5];
    hex[0]='0';
    hex[1]='0';
    hex[2]='0';
    hex[3]='0';
    hex[4]='\0';

 
//  int i=3,j=14;
//     while(j>10){

//    if(string[j]!='\n' &&string[j]!='\0'&&string[j]!=' '&&string[j]!='\t')
//  {
//      hex[i]=string[j];
//   --i;
// }
//   --j;
// }
// printf("\nhex value for IADD is %s\n",hex);
    printf("length of buffer is %zu and what's in buffer %s",strlen(string),string);
for(int o=11;o<15;o++)if(string[o]<48||string[o]>57)string[o]='\0';
char c; int i=0;
c=string[11];
int counterlen=7;
    while(c!='\0'){
    printf("at i=%d c=%c\n",i,c);
    hex[i]=c;
    i++;
    c=string[11+i];
}

printf("hex is for iadd %s and hex[0]=%c and i=%d\n",hex,hex[0],i);
int k=0;
for(int m=i;m<4;m++,k++)
    for(int j=i;j>0;j--)hex[j+k]=hex[j+k-1];
for(int l=0;l<4-i;l++)hex[l]='0';
printf("%s",hex);

    HextoBin(writeto,hex);
    return;
}
else if(string[3]==' '){
TrimWhiteSpaces(string+4);
printf("Full Trim %s\n",string);
for(int i=0;i<4;i++)instructionString[i]=string[i];
if(strcmp(instructionString,"LDD ")==0){//strcmp returns 0 when equal
fprintf(writeto,"00110");
    ParseOpIType(writeto,string,0);
}
else if (strcmp(instructionString,"POP ")==0){
fprintf(writeto,"01011");
    ParseOpIType(writeto,string,3);    
}
else if(strcmp(instructionString,"STD ")==0){
fprintf(writeto,"00101");
ParseOpIType(writeto,string,4);
}
else if(strcmp(instructionString,"MOV ")==0){
fprintf(writeto,"01111");
ParseOpIType(writeto,string,0);
}
else if(strcmp(instructionString,"ADD ")==0){
    fprintf(writeto,"10000");
    ParseOpRType(writeto,string,1);
}
else if(strcmp(instructionString,"AND ")==0){
    fprintf(writeto,"10011");
    ParseOpRType(writeto,string,1);
}
else if(strcmp(instructionString,"INC ")==0){
    fprintf(writeto,"00001");
    ParseOpIType(writeto,string,0);
}
else if(strcmp(instructionString,"DEC ")==0){
    fprintf(writeto,"00011");
    ParseOpIType(writeto,string,0);
}
else if(strcmp(instructionString,"NOT ")==0){
    fprintf(writeto,"10101");
    ParseOpIType(writeto,string,0);
}
else if(strcmp(instructionString,"SUB ")==0){
    fprintf(writeto,"10001");
    ParseOpRType(writeto,string,1);
}
else if(strcmp(instructionString,"OUT ")==0){
    fprintf(writeto,"00111");
    ParseOpIType(writeto,string,2);
}
else if(strcmp(instructionString,"LDM ")==0){//VERY SPECIAL CASE
    fprintf(writeto,"10011");
    LDM_Handle(writeto,string);
    PrintNumber(writeto,string);
    return;
}
else if(strcmp(instructionString,"JMP ")==0){
    fprintf(writeto,"11011");
    ParseOpJType(writeto,string,1);
}
}
else if(string[2]==' '&&string[3]!=' ')
{
TrimWhiteSpaces(string+3);
printf("Full Trim %s\n",string);
for(int i=0;i<3;i++)instructionString[i]=string[i];
 if(strcmp(instructionString,"OR ")==0){
    fprintf(writeto,"10100");
    ParseOpRType(writeto,string,0);
}
else if(strcmp(instructionString,"IN ")==0){
    fprintf(writeto,"01000");
    ParseOpIType(writeto,string,1);
}
else if(strcmp(instructionString,"JZ ")==0){
    fprintf(writeto,"11000");
    ParseOpJType(writeto,string,0);
}
else if(strcmp(instructionString,"JC ")==0){
    fprintf(writeto,"11001");
    ParseOpJType(writeto,string,0);
}
}

}


void ParseOpRType(FILE*writeto,char*buffer,int notOR){
//for simplicity we will assume all registers will not be spaced e.g. ADD R1,R2,R3
char tempStr[2];
if(notOR==1){
tempStr[0]=buffer[7];
tempStr[1]=buffer[8];
WriteRegisters(writeto,tempStr);
tempStr[0]=buffer[10];
tempStr[1]=buffer[11];
WriteRegisters(writeto,tempStr);
tempStr[0]=buffer[4];
tempStr[1]=buffer[5];
WriteRegisters(writeto,tempStr);
fprintf(writeto,"00\n");
}
else{
  tempStr[0]=buffer[6];
tempStr[1]=buffer[7];
WriteRegisters(writeto,tempStr);
tempStr[0]=buffer[9];
tempStr[1]=buffer[10];
WriteRegisters(writeto,tempStr);
tempStr[0]=buffer[3];
tempStr[1]=buffer[4];
WriteRegisters(writeto,tempStr);
fprintf(writeto,"00\n");  
}
}

void ParseOpIType(FILE*writeto,char*buffer,int type)
{
char tempStr[2];

 if (type==0){
    //normal 0 I type, MOV, INC, DEC, LDD
tempStr[0]=buffer[7];
tempStr[1]=buffer[8];
WriteRegisters(writeto,tempStr);
tempStr[0]=buffer[4];
tempStr[1]=buffer[5];
WriteRegisters(writeto,tempStr);
    }
    else if(type==4){//STD
tempStr[0]=buffer[4];
tempStr[1]=buffer[5];
WriteRegisters(writeto,tempStr);
tempStr[0]=buffer[7];
tempStr[1]=buffer[8];
WriteRegisters(writeto,tempStr);
    }else if (type==1){//IN 
    fprintf(writeto,"000000");//actually R type
    tempStr[0]=buffer[3];
    tempStr[1]=buffer[4];
    WriteRegisters(writeto,tempStr);
    fprintf(writeto,"00\n");//actually R type
    return;
    }else if (type==2){//OUT, actually R type 
    fprintf(writeto,"000000");
    tempStr[0]=buffer[4];
    tempStr[1]=buffer[5];
    WriteRegisters(writeto,tempStr);
    fprintf(writeto,"00\n");//actually R type
    return;
    }else if (type==3){
        //pop instruction
        fprintf(writeto,"000");
        tempStr[0]=buffer[4];
tempStr[1]=buffer[5];
WriteRegisters(writeto,tempStr);
    }
    else if (type==5){
        fprintf(writeto,"000");
            tempStr[0]=buffer[5];
tempStr[1]=buffer[6];
WriteRegisters(writeto,tempStr);
    }else if (type==6){//IADD
        tempStr[0]=buffer[8];
tempStr[1]=buffer[9];
WriteRegisters(writeto,tempStr);
tempStr[0]=buffer[5];
tempStr[1]=buffer[6];
WriteRegisters(writeto,tempStr);
    }
fprintf(writeto,"00000\n");
// }
}
void ParseOpJType(FILE*writeto,char*buffer,int type)
{
    char tempStr[2];
switch(type)
{
    case 0:
    tempStr[0]=buffer[3];
    tempStr[1]=buffer[4];
    break;
    case 1: 
    tempStr[0]=buffer[4];
    tempStr[1]=buffer[5];
    break;
}
    WriteRegisters(writeto,tempStr);
    fprintf(writeto,"00000000\n");

}


void WriteRegisters(FILE*writeto,char tempStr[2])
{
    if(strcmp(tempStr,"R0")==0){
fprintf(writeto,"000");
}
else if(strcmp(tempStr,"R1")==0){
fprintf(writeto,"001");
}
else if(strcmp(tempStr,"R2")==0){
fprintf(writeto,"010");
}
else if(strcmp(tempStr,"R3")==0){
fprintf(writeto,"011");
}
else if(strcmp(tempStr,"R4")==0){
fprintf(writeto,"100");
}
else if(strcmp(tempStr,"R5")==0){
fprintf(writeto,"101");
// printf("from WriteReg5");
}
else if(strcmp(tempStr,"R6")==0){
fprintf(writeto,"110");
// printf("from WriteReg6");
}
else if(strcmp(tempStr,"R7")==0){
fprintf(writeto,"111");
}
}

void handleOrg(FILE*file,char*buffer,long prev,long current,int* currentline){

    printf("currentline is %d\n",*currentline);
char tempStr[5]="0000\0";
int i=0,j=8;
for(i=3;i>=0&&j>4;j--){
    if(buffer[j]!='\n' &&buffer[j]!='\0'&&buffer[j]!=' '&&buffer[j]!='\t')
    {
    tempStr[i]=buffer[j];
    i--;
    }
}
    // printf("in handleOrg: tempStr is %s\n",tempStr);
    int num=HextoDec(tempStr);
    if(num>*currentline){
    int counter=*currentline;
        fseek(file,0,SEEK_CUR);
    while(counter<num){
        fprintf(file,"0000000000000000\n");
    counter++;
    // *++currentline;
    // printf("inside loop:current line is %d\n",*currentline);
    // if (*currentline==32){
    // long f=ftell(file);
    // printf("line is 32 and pos is %ld",f);
    // }
    }
    *currentline=num;    
    }else{
printf("num %d < currentline %d",num,*currentline);
        printf("-------HELLOS-----,current lines is %d and file pointer at %ld--\n",*currentline,ftell(file));
        int counter=0;
        long currentPosition=0;//=currentline;
        fseek(file,0,SEEK_SET);
        // *currentline=0;
        char uselessbuffer[17];
        while(counter<num){
            fgets(uselessbuffer,MAX_LINE,file);
            // fscanf(file,"%s",uselessbuffer);
            getline2(uselessbuffer,20,file);
            printf("uselessbuffer: %s\n",uselessbuffer);
            static char dataRead[1000]={0};
            fread(dataRead,1000,1,file);
        counter++;
        currentPosition=ftell(file);
        printf("currentpos is %ld\n",currentPosition);
        }
        *currentline=num;
        fseek(file,17*(num-1),SEEK_SET);
        /*why fseek(file,17*(num-1),SEEK_SET);
        each line in the file(the output file I'm now in) is 16 bits, so the pointer is incremented 17 at each line
        (it now stands at the next line)
        and if I want to position myself at, say, line 10 from the beginning I can use fseek with SEEK_SET and the position
        is 17 (the value the pointer's incremented each step) multiplied by (the line I want to reach -1) 
        why -1? because the fseek considers numbering from 0, while most text editors (like VSCode) start numbering from 1*/ 
    }
// printf("\n%d\n",num);
}

void LDM_Handle(FILE*writeto,char*buffer)
{ 
    
    fprintf(writeto,"000");
    char tempStr[2];
    tempStr[0]=buffer[4];
    tempStr[1]=buffer[5];
    WriteRegisters(writeto,tempStr);
fprintf(writeto,"00000\n");
return;//no idea why, but when the code written in PrintNumber function from down here and without the return
//it wasn't working, and the "00000" were overwriting the number writen by WriteRegisters function  
}
void PrintNumber(FILE*handle,char*buffer){
    char hex[5]="0000\0";
printf("length of buffer is %zu",strlen(buffer));
for(int o=7;o<11;o++)if(buffer[o]<48||buffer[o]>57)buffer[o]='\0';
char c; int i=0;
c=buffer[7];
int counterlen=7;
// while(counterlen<strlen(buffer)){
    while(c!='\0'){
    printf("at i=%d c=%c\n",i,c);
    hex[i]=c;
    i++;
    c=buffer[7+i];
}
printf("hex is for LDM %s and hex[0]=%c and i=%d\n",hex,hex[0],i);
int k=0;
for(int m=i;m<4;m++,k++)
    for(int j=i;j>0;j--)hex[j+k]=hex[j+k-1];
for(int l=0;l<4-i;l++)hex[l]='0';
printf("%s",hex);
HextoBin(handle,hex);    
}

void HextoBin(FILE*writeto,char hexString[4])
{
    for(int i=0;i<4;++i){
        switch (hexString[i])
        {
        case '0':
            fprintf(writeto,"0000");
             break;
        case '1':
            fprintf(writeto,"0001"); break;
        case '2':
            fprintf(writeto,"0010"); break;
        case '3':
            fprintf(writeto,"0011"); break;
        case '4':
            fprintf(writeto,"0100"); break;
        case '5':
            fprintf(writeto,"0101"); break;
        case '6':
            fprintf(writeto,"0110"); break;
        case '7':
            fprintf(writeto,"0111"); break;
        case '8':
            fprintf(writeto,"1000"); break;
        case '9':
            fprintf(writeto,"1001"); break;
        case 'A':
            fprintf(writeto,"1010"); break;
        case 'B':
            fprintf(writeto,"1011"); break;
        case 'C':
            fprintf(writeto,"1100"); break;
        case 'D':
            fprintf(writeto,"1101"); break;
        case 'E':
            fprintf(writeto,"1110"); break;
        case 'F':
            fprintf(writeto,"1111"); break;
        case 'a':
            fprintf(writeto,"1010"); break;
        case 'b':
            fprintf(writeto,"1011"); break;
        case 'c':
            fprintf(writeto,"1100"); break;
        case 'd':
            fprintf(writeto,"1101"); break;
        case 'e':
            fprintf(writeto,"1110"); break;
        case 'f':
            fprintf(writeto,"1111"); break;
        default:
            printf("\n Invalid hexa digit %c ", hexString[i]);
            // return 0;
        }
    }
    // printf("in here");
    fprintf(writeto,"\n");
}
void trimleadingandTrailing(char *s)
{
	int  i,j;
 
	for(i=0;s[i]==' '||s[i]=='\t';i++);
		
	for(j=0;s[i];i++)
	{
		s[j++]=s[i];
	}
	s[j]='\0';
	for(i=0;s[i]!='\0';i++)
	{
		if(s[i]!=' '&& s[i]!='\t')
				j=i;
	}
	s[j+1]='\0';
}


void cleanString(char*string){
    int i,j;
    int len = strlen(string);
   for(i=0; i<len; i++) {
      if(string[0]==' ') {
         for(i=0; i<(len-1); i++)
         string[i] = string[i+1];
         string[i] = '\0';
         len--;
         i = -1;
         continue;
      }
      if(string[i]==' ' && string[i+1]==' ') {
         for(j=i; j<(len-1); j++) {
            string[j] = string[j+1];
         }
         string[j] = '\0';
         len--;
         i--;
      }
   }
}

int HextoDec(char*hex){


        // printf("%s",hex);
    // fflush(stdin);
    // fgets(hex,ARRAY_SIZE,stdin);
     int decimal = 0;
     long long base = 1;
    int i = 0, value, length;
     length = strlen(hex);
    for(int i = length--; i >= 0; i--)
    {
        if(hex[i] >= '0' && hex[i] <= '9')
        {
            decimal += (hex[i] - 48) * base;
            base *= 16;
        }
        else if(hex[i] >= 'A' && hex[i] <= 'F')
        {
            decimal += (hex[i] - 55) * base;
            base *= 16;
        }
        else if(hex[i] >= 'a' && hex[i] <= 'f')
        {
            decimal += (hex[i] - 87) * base;
            base *= 16;
        }
    }
    // printf("%lld\n",decimal);
    return decimal;
}


void TrimWhiteSpaces(char*str){
        int i, len = 0,j;  
    // char str[] = "Remove white spaces";  
      int firsttime=1;
    //Calculating length of the array  
    len = sizeof(str)/sizeof(str[0]);  
      
    //Checks for space character in array if its there then ignores it and swap str[i] to str[i+1];  
        i=0;
        while(str[i]!='\0'&&str[i]!='\t'&&str[i]!='\n'){
        if(str[i] == ' '&&firsttime!=0){  
            int j=i;
            while(str[j]!='\0'&&str[j]!='\n'){
                str[j]=str[j+1];
                j++;
            }
        // if(str[i]==' '&&firsttime==0)firsttime=1;
        }  
        i++;
        }
    // printf("String after removing all the white spaces : %s", str);  
    return;  
}  
