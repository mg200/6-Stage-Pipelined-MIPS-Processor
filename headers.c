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
