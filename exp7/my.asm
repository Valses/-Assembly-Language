.386
STACK SEGMENT USE16 STACK
      DB 200 DUP(0)
STACK ENDS

DATA 	SEGMENT USE16

D1   	DB 0DH,0AH,'Please input the student name(tap enter for exit):$'
D2   	DB 0DH,0AH,'--Chinese score:$'
D3   	DB 0DH,0AH,'--Math score:$'
D4   	DB 0DH,0AH,'--English score:$'
IN_NAME DB 11
        DB ?
		DB 11 DUP(0)
RADX 	DB 10
BUF  	DB 'z'XOR'S','h'XOR'K','a'XOR'Y','n'XOR'S','g'XOR'K','y'XOR'Y','x'XOR'S',0,0,0
		DB 95 XOR'S',90 XOR'K',90 XOR'Y',?
		DB 'y'XOR'S','i'XOR'K','n'XOR'Y','g'XOR'S',6 DUP(0)
		DB 90 XOR'S',80 XOR'K',88 XOR'Y',?
		DB 's'XOR'S','h'XOR'K','u'XOR'Y',7 DUP(0)
		DB 80 XOR'S',70 XOR'K',80 XOR'Y',?
		DB '!'

PWD 	DB  3 XOR 'M'       
		DB  ('S' -37H)*2    ;采用函数(X-37H)*2对保存的密码进行编码。
		DB  ('K' -37H)*2
		DB  ('Y' -37H)*2    
		DB  49H,03H,4DH     ;用随机数填充密码区到6个字符，防止破解者猜到密码长度

IN_PWD  DB 7                ;使用者输入的密码区，最大长度6个字符
        DB ?
        DB 7 DUP(0)
STR1 	DB 0DH,0AH,'PLEASE ENTER PASSWORD:$'
P1      DW PASS1
DATA	ENDS

CODE 	SEGMENT USE16
		ASSUME CS:CODE,DS:DATA,SS:STACK

START:	MOV AX,DATA
		MOV DS,AX
		LEA DX,STR1
        MOV AH,9
        INT 21H
        LEA DX,IN_PWD               ;输入密码字符串
        MOV AH,10
        INT 21H
		
		cli                         ;开始 
        mov  ah,2ch 
        int  21h
        push dx                     ;保存获取的秒和百分秒
		
		MOV CL,IN_PWD+1             ;比较输入的串长与密码长度是否一样
		XOR CL,'M'
		SUB CL,PWD
		cmp CL,0
		jne over   
		
		mov  ah,2ch                 ;获取第二次
        int  21h
        sti
        cmp  dx,[esp]               
        pop  dx
        jz   PASS1                  ;如果计时相同，通过本次计时反跟踪   
        jmp  OVER
		pop   ax
		and   ax,ax
		inc   si
		push  ax

PASS1:  MOVZX CX,IN_PWD+1
        MOV  SI,0
        MOV  DL,2
		
PASS2:  MOVZX  AX,IN_PWD+2[SI]    ;比较密码是否相同。把输入的串变成密文，与保存的密文比较
        SUB  AX,37H
        MUL  DL
        CMP  AL,PWD+1[SI]
        JNZ  OVER
        INC  SI
        LOOP PASS2
		
PASS4: 
	   LEA DX,D1
	   MOV AH,9
	   INT 21H
	   LEA DX,IN_NAME
	   MOV AH,10
	   INT 21H
	   CMP IN_NAME[1],0
	   JE  OVER
NEXT:  	   
       MOV BX,0
	   MOV CX,0
       MOV SI,0 
	   MOV DI,0							;取模之后可以保证循环使用密码串）
NEXT2: MOV DL,IN_NAME+2[SI]
       XOR DL,IN_PWD+2[DI]
	   CMP DL,BUF+[BX]
	   JE  OP
	   JMP OP2	   
OP:    CMP BUF+1[BX],0
	   JE SCORE
       INC SI 
	   INC BX
	   INC DI
	   MOV AX,DI
	   DIV IN_PWD+1
	   MOVZX DI,AH
       JMP NEXT2

OP2:   INC CX
	   ADD BX,14
	   MOV SI,0 
	   MOV DI,0
	   CMP BUF+[BX],'!'
	   JE  PASS4
	   JMP NEXT2
   
	   
SCORE: LEA DX,D2                ;显示三科成绩
       MOV AH,9
       INT 21H    
       MOV SI,0
	   IMUL BX,CX,14
       
	   MOV AL,BUF+10[BX]
       XOR AL,IN_PWD+2[SI]     
       MOV AH,0
       DIV RADX               ;这里假设成绩最大为99，所以只除一次10
       
	   ADD AX,3030H
       PUSH AX
       MOV DL,AL                   
       MOV AH,2
       INT 21H 
       POP AX
       MOV DL,AH
       MOV AH,2
       INT 21H 
       
	   INC SI 
 
       LEA DX,D3
       MOV AH,9
       INT 21H
       MOV AL,BUF+11[BX]
       XOR AL,IN_PWD+2[SI]
       MOV AH,0
       DIV RADX
       ADD AX,3030H
       PUSH AX
       MOV DL,AL
       MOV AH,2
       INT 21H
       POP AX
       MOV DL,AH
       MOV AH,2
       INT 21H
       INC SI 

       LEA DX,D4
       MOV AH,9
       INT 21H    
       MOV AL,BUF+12[BX]
       XOR AL,IN_PWD+2[SI]
       MOV AH,0
       DIV RADX
       ADD AX,3030H
       PUSH AX
       MOV DL,AL                   
       MOV AH,2
       INT 21H 
       POP AX
       MOV DL,AH
       MOV AH,2
       INT 21H 
	   
	   JMP PASS4

OVER:  MOV AH,4CH
       INT 21H
CODE   ENDS
       END START
