.386
READ	MACRO A				;10号DOS调用
		LEA DX,A
		MOV AH,10
		INT 21H
		ENDM
OUT1 	MACRO A
		MOV DL,A
		MOV AH,2
		INT 21H
		ENDM
		
STACK   SEGMENT USE16 STACK
        DB 200 DUP(0)
STACK   ENDS
DATA    SEGMENT USE16
INPUT 	DB 15
		DB 0
		DB 15 DUP(' ')
DATA    ENDS
CODE    SEGMENT USE16
        ASSUME CS:CODE,DS:DATA,SS:STACK
	   
START:	MOV AX,DATA
		MOV DS,AX
LOP: 
		READ INPUT
		OUT1 0AH
		CMP INPUT[2],0DH
		JE QUIT
		OUT1 0DH
		JMP LOP

QUIT:	MOV AH,4CH
		INT 21H
CODE	ENDS

END START
