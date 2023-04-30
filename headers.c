#include <stdio.h>      //if you don't use scanf/printf change this include
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/file.h>
// #include <sys/ipc.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include<stdbool.h>
#include<ctype.h>
#define FILENAME_SIZE 1024 
#define MAX_LINE 2048

void converttoUpper(char *msg, int size) {
int i;
for (i=0; i<size; ++i)
if (islower(msg[i]))
msg[i] = toupper(msg[i]);
}

//auxillary functions 
void Parse(FILE*writeto,char*string);
void cleanString(char*string);
void trimleadingandTrailing(char *s);
void ParseOperands(FILE*writeto,char*buffer,int type);//1 R-type, 2 I-type, 3 J-type
void WriteRegisters(FILE*writeto,char tempStr[2]);
void handleOrg(FILE*,char*,long,long,int*);
void ParseOpRType(FILE*,char*,int notOR);
void ParseOpIType(FILE*writeto,char*string,int);//int is 0 when normal, 4 STD
void ParseOpJType(FILE*writeto,char*string,int);
void LDM_Handle(FILE*,char*);
void HextoBin(FILE*,char*);
int HextoDec(char*hex);
void PrintNumber(FILE*handle,char*buffer);
void TrimWhiteSpaces(char*string);
char*DigitConverter(char*start,int size,int req_digits,char*buffer){
    //to use safely, buffer should have a size of req_digits+1, and start's size must be at least its number of digits+1
    for(int i=0;i<req_digits+1;i++)buffer[i]='\0';
size_t len=strlen(start);
// printf("length of buffer is %zu",len);
for(int i=0;i<(int)len;i++)if(!((start[i]>=48&&start[i]<=57)||(start[i]>=65&&start[i]<=70)||(start[i]>=97&&start[i]<=102)))start[i]='\0';
char c; int i=0;
c=start[0];
    while(c!='\0'){
    // printf("at i=%d c=%c\n",i,c);
    buffer[i]=c;
    c=start[0+(++i)];
}
// printf("buffer is for LDM %s and buffer[0]=%c and i=%d\n",buffer,buffer[0],i);
int k=0;
for(int m=i;m<req_digits;m++,k++)
    for(int j=i;j>0;j--)buffer[j+k]=buffer[j+k-1];
for(int l=0;l<req_digits-i;l++)buffer[l]='0';
// printf("%s\n",buffer);
}
char *getline2(char *buf, int size, FILE *fp)
{
    char *result;
    do {
        result = fgets(buf, size, fp);
    } while( result != NULL && buf[0] == '\n' );
    return result;
}
