#include<stdio.h>
#include<string.h>
#define LEN 14

int main(void){
	unsigned char student[LEN*4];
	unsigned char s[11];
	unsigned char mark[4];
	short i;
	short op = 0;
	int len;
	strcpy((char *)(student+0*LEN),"wang");        //储存学生信息
	student[10]= 90;
	student[11]= 80;
	student[12]= 70;

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

	for(i=0;i<4;i++){                    //计算平均成绩
		mark[0]=student[i*LEN+10];
		mark[1]=student[i*LEN+11];
		mark[2]=student[i*LEN+12];
		asm push ax
		asm push bx
		asm mov al,byte ptr mark[0]
		asm mov ah,0
		asm sal ax,1
		asm mov bx,ax
		asm mov al,byte ptr mark[1]
		asm mov ah,0
		asm add bx,ax
		asm sal bx,1
		asm mov al,byte ptr mark[2]
		asm mov ah,0
		asm add ax,bx
		asm mov bl,7
		asm div bl
		asm mov byte ptr mark[3],al
		asm pop bx
		asm pop ax
		student[i*LEN+13] = mark[3];
	}
	
	printf("\n--The average grades are calculated successfully!\n");
	do{
		printf("\n--Input the student name you want to search(q for exit):");
		scanf("%s",s);
		len = strlen(s);
		if(s[0] == 'q' && len == 1) return 0;
			asm push ax                  //查找学生
			asm push bx
			asm push cx
			asm push si
			asm mov op,0
			asm mov cx,4
			asm lea bx,student
			asm mov si,0
		lopa:
			asm mov al,byte ptr s[si]
			asm mov ah,byte ptr [bx+si]
			asm cmp ah,al                   //比较
			asm jne part2
			asm cmp ah,0
			asm je lopb
			asm inc si
			asm cmp si,10
			asm je lopb
			asm jmp lopa	
		part2:
			asm add bx,14                  //下一个学生
			asm mov si,0
			asm dec cx
			asm jz lopc
			asm jmp lopa
		lopb:
			asm mov op,1                    //已找到
			asm mov i,cx
		lopc:
			asm pop si                      //结束
			asm pop cx
			asm pop bx
			asm pop ax
		i = 4-i;
		if(op == 1)
			printf("\n     %s Chinese:%d Math:%d English:%d Ave:%d\n",s,student[i*LEN+10],student[i*LEN+11],student[i*LEN+12],student[i*LEN+13]);
		else
			printf("\n     no this student!\n");
	}while(1);
	return 0;
}
