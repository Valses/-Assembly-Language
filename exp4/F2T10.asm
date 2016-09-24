
INCLUDE MYLIB.LIB

PUBLIC   F2T10

EXTRN  BUF:BYTE,PP:WORD

;子程序名字：F2T10

;子程序功能：将AX中的二进制数码按用户输入转换成10进制或16进制输出
;入口参数：  ax    存放待输出的二进制数
;所用变量：  buf：转换以后ascii码存放的地方
;出口参数：  si：  指向buf最后一个ascii码的下一个字节
;所用寄存器：  cx： 数字的长度
;	       edx: 按除法指令时用到的


.386
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME CS:CODE
F2T10 PROC NEAR
	PUSH EBX
	PUSH SI 
	LEA SI,BUF
	MOVSX EAX,AX
	OR EAX,EAX
	JNS PLUS
	NEG EAX
	MOV BYTE PTR [SI],'-'
	INC SI 
PLUS:	MOV EBX,DWORD PTR PP
	AND EBX,00FFH
	PUSH CX
	PUSH EDX
	XOR CX,CX
LOP1:	XOR EDX,EDX
	DIV EBX
	PUSH DX
	INC CX
	OR EAX,EAX
	JNZ LOP1
LOP2:	POP AX
	CMP AL,10
	JB LL1
	ADD AL,7
LL1: 	ADD AL,30H
	MOV [SI],AL
	INC SI 
	LOOP LOP2
	POP EDX
	POP CX
	CMP PP,10
	JE KK
	MOV BYTE PTR [SI],'H'
	INC SI
KK:	MOV BYTE PTR [SI],'$'
	WRITE BUF
	POP SI 
	POP EBX
	RET
F2T10 ENDP
CODE ENDS
	END