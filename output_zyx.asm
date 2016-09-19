INCLUDE MYLIB.LIB
PUBLIC   OUTPUT

EXTRN  RANK:BYTE,F2T10:NEAR,BUF:BYTE,PP:WORD

;子程序名字：OUTPUT
;子程序功能：将学生姓名与成绩按排序输出
;入口参数：  SI    学生信息地址
;所用变量：  RANK：按名次存放学生编号，MES：表头信息，MES2：排版使用空格
;出口参数：  无
;所用寄存器：AX,BX,CX,BP,DI
;            BX：控制循环次数同时变址寻址 AX：中间变量  CX：控制循环次数
;            BP：变址寻址  DI：存放每个学生信息首地址
;本段代码提供者：张雅昕
;同组成员：尹丹丽，华苗
.386
DATA  SEGMENT USE16 PARA PUBLIC 'DATA'
MES   DB 'Name      Chinese Math English  Ave',0DH,0AH,'$'
MES2  DB '     $'
DATA  ENDS

CODE  SEGMENT USE16 PARA PUBLIC 'CODE'
	  ASSUME CS:CODE

OUTPUT  PROC NEAR
		PUSH AX             ;保护现场
		PUSH BX
		PUSH CX
		PUSH DI
		PUSH BP
        WRITE MES
		MOV BX,0
STE0:	MOV AL,RANK[BX]     ;取出RANK中相应名次对应的学生次序
		CBW
		MOV DI,SI
		MOV CX,AX
H1:		CMP CX,0
		JE H2
		ADD DI,16           ;移动DI使DI指向当前名次的学生信息段首
		DEC CX
		JMP H1		
H2:		MOV CL,[DI+1]	    ;CL存放姓名长度
		CMP CL,0
		JE STE3
		MOV CH,0
		MOV BP,2
STE1:	OUT1 DS:[DI+BP]     ;输出姓名
		INC BP
		LOOP STE1
		OUT1 20H
H3:		OUT1 20H             ;输出空格，对齐
		INC BP
		CMP BP,12
		JB H3
STE2:	MOV AL,DS:[DI+BP]
		CBW
		MOV PP[0],10         ;输出十进制分
		CALL F2T10
		WRITE MES2
		INC BP
		CMP BP,16
		JB STE2
		OUT1 0DH             ;回车换行
		OUT1 0AH
STE3:	INC BX
		CMP BX,5
		JB STE0
OK:		POP BP
		POP DI
		POP CX
		POP BX
		POP AX
		RET
OUTPUT  ENDP
CODE    ENDS
	    END
