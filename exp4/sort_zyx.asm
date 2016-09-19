INCLUDE MYLIB.LIB
PUBLIC   SORT
EXTRN  RANK:BYTE,F2T10:NEAR,PP:BYTE

;子程序名字：SORT
;子程序功能：将学生平均成绩排名，按照名次顺序将学生编号存储于RANK内,并输出排序
;入口参数：  SI    学生信息地址
;所用变量：  RANK：按名次存放学生编号，GRADE：存放学生平均成绩
;            PP：向子函数F2T10传递进制
;出口参数：  无
;所用寄存器：AX,BX,CX,DI,BP
;            CX：控制循环次数 BX：变址寻址，控制循环次数 AX：常用作中间变量 
;            DI：变址寻址，在输出时存放每个学生信息首地址   BP：变址寻址
;本段代码提供者：张雅昕
;同组成员：尹丹丽，华苗
.386
DATA  SEGMENT USE16 PARA PUBLIC 'DATA'
GRADE DB 5 DUP(0)
DATA  ENDS

CODE  SEGMENT USE16 PARA PUBLIC 'CODE'
	  ASSUME CS:CODE,DS:DATA
	
SORT 	PROC NEAR
		PUSH AX                  ;保护现场
		PUSH CX
		PUSH DI
		PUSH BX
		PUSH BP
		
		MOV CX,5               ;学生平均成绩拷贝次数
		MOV DI,0
		MOV BX,0
STE1:	MOV AL,15[BX][SI]
		MOV GRADE[DI],AL        ;将学生平均成绩拷贝至GRADE
		MOV AX,DI
		MOV RANK[DI],AL         ;RANK存放学生次序0-4
		ADD BX,16
		INC DI
		LOOP STE1               ;循环5人
		MOV CX,4                ;冒泡排序第一轮次数
		MOV DI,0
		
STE2:	MOV AL,GRADE[DI]		
		MOV AH,GRADE[DI+1]
		CMP AL,AH               ;比较顺次两人平均成绩
		JB  STE3                ;若前者小于后者则交换 
		DEC CX
		INC DI
		CMP CX,0
		JE STE4
		JMP STE2

STE3:	MOV AL,GRADE[DI]
		XCHG GRADE[DI+1],AL
		XCHG AL,GRADE[DI]       ;交换平均成绩
        MOV AL,RANK[DI]
		XCHG RANK[DI+1],AL
        XCHG AL,RANK[DI]        ;交换学生次序
		DEC CX
		INC DI
		CMP CX,0
		JE STE4
		JMP STE2
STE4:	CMP DI,1                ;判断冒泡排序是否结束
		JE STE5
		MOV CX,DI               ;开始下一轮冒泡排序
		DEC CX
		MOV DI,0
		JMP STE2
		
STE5：	MOV BX,0
STE6:	MOV AL,RANK[BX]         ;取出RANK中相应名次对应的学生次序
		CBW
		MOV DI,SI
		MOV CX,AX
H1:		CMP CX,0                ;移动DI使DI指向当前名次的学生信息段首
		JE H2
		ADD DI,16
		DEC CX
		JMP H1
		
H2:		MOV CL,[DI+1]          ;CL存放姓名长度
		CMP CL,0
		JE STE8
		MOV CH,0
		MOV BP,2
STE7:	OUT1 DS:[DI+BP]       ;输出姓名
		INC BP
		LOOP STE7
		OUT1 20H
H3:		OUT1 20H
		INC BP
		CMP BP,12
		JB H3

		CMP BX,0              ;判断名次
		JE R1
		CMP BX,1
		JE R2
		CMP BX,2
		JE R3
		CMP BX,3
		JE R4
		CMP BX,4
		JE R5
		
R1:		OUT1 31H              ;输出名次
		JMP RR
R2:		OUT1 32H
		JMP RR
R3:		OUT1 33H
		JMP RR
R4:		OUT1 34H
		JMP RR
R5:		OUT1 35H
		JMP RR
		
RR:		OUT1 0DH               ;回车换行
		OUT1 0AH
STE8:	INC BX
		CMP BX,5
		JNE STE6               ;跳回输出下一个名次的学生

OK:		POP BP
		POP BX
		POP DI
		POP CX
		POP AX
		RET
SORT	ENDP
CODE    ENDS
	    END
