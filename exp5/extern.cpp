#include<stdio.h>
#include<string.h>
#define LEN 14

unsigned char student[LEN*4];
unsigned char s[11];


extern "C" int average(unsigned char *,unsigned char *);


int main(void){
	short op;
	int len;
	strcpy((char *)(student+0*LEN),"wang");        //储存学生信息
	*(student+10)= 90;
	*(student+11)= 80;
	*(student+12)= 70;

	strcpy((char *)(student+1*LEN),"zhang");
	student[1*LEN+10]= 95;
	student[1*LEN+11]= 90;
	student[1*LEN+12]= 80;

	strcpy((char *)(student+2*LEN),"li");
	student[2*LEN+10]= 70;
	student[2*LEN+11]= 90;
	student[2*LEN+12]= 60;
	
	strcpy((char *)(student+3*LEN),"xiaoming");
	student[3*LEN+10]= 77;
	student[3*LEN+11]= 95;
	student[3*LEN+12]= 89;


	do{
		printf("\n--Input the student name you want to search(q for exit):");
		scanf("%s",s);
		len = strlen((const char *)s);
		if(*(s+0) == 'q' && len == 1) return 0;
		
		op = average(student,s);
		if(op == 4)
			printf("\n     no this student!\n");
		else
			printf("\n     %s Chinese:%d Math:%d English:%d Ave:%d\n",s,student[op*LEN+10],student[op*LEN+11],student[op*LEN+12],student[op*LEN+13]);
	}while(1);
}
