.386
STACK  SEGMENT USE16 STACK
       DB 200 DUP(0)
STACK  ENDS
DATA   SEGMENT USE16
INPUT  DB 20                               ;输入缓冲区
       DB 0 
       DB 20 DUP(' ')
BUF    DB 'xuebayu',0DH,'  ',100,85,80,0   ; 平均成绩还未计算
       DB 'xuebashu',0DH,' ',80,100,70,0
       DB 'xueba',0DH,'    ',85,85,100,0
	     DB 'xue1',0DH,'     ',70,80,50,0
	     DB 'xue2',0DH,'     ',50,60,30,0
       DB 100 DUP(10 DUP(' '),0,0,0,0)
MES1   DB 0AH,0DH,'Please input a name(input q for exit):$'
MES2   DB 'No this name!$'
MES3   DB 0AH,0DH,'$'
DATA   ENDS
CODE   SEGMENT USE16
       ASSUME CS:CODE,DS:DATA,SS:STACK

START: MOV AX,DATA
       MOV DS,AX
       LEA DX,MES1
       MOV AH,9
       INT 21H
       LEA DX,INPUT
       MOV AH,10
       INT 21H
       LEA DX,MES3
       MOV AH,9
       INT 21H
       MOV SI,OFFSET INPUT
       ADD SI,2
       MOV BX,0
       MOV CX,10
       MOV AL,[SI]
       CMP AL,71H                 ;判断输入是否等于q
       JE  PART1     

LOPA:  MOV AL,[SI]                ;循环比较姓名
       MOV DI,SI
       SUB DI,2
       CMP AL,BUF[BX][DI]
       JNE PART2                  ;不相等，跳出
       INC SI
       DEC CX
       JZ  LOPB                   ;查找结束，已找到
       JMP LOPA

PART1: INC SI                     ;判断是否需要退出
       MOV AL,[SI]
	     CMP AL,0DH
       JE END2
       DEC SI
       JMP LOPA
PART2: ADD BX,14                  ;跳转到下一条学生信息
       MOV SI,OFFSET INPUT
	   ADD SI,2
       MOV CX,10
       MOV AL,BUF[BX]             ;判断学生信息是否比较完
	   CMP AL,20H
       JE  PART3
       JMP LOPA
PART3: LEA DX,MES2               ;查找结束，未找到，跳转至开始
       MOV AH,9
       INT 21H
       JMP END1

LOPB:  MOV DI,10                    ;求平均成绩
       MOV AL,BUF[BX][DI]           
       MOV AH,0
       IMUL CX,AX,2                 ;语文成绩乘2
	   INC DI
       MOV AL,BUF[BX][DI]
       ADD CX,AX
       INC DI
       MOV AL,BUF[BX][DI]
       MOV DL,2
       IDIV DL                      ;英语成绩除以2
	   MOV AH,0
       ADD CX,AX                    ;CX储存加权总成绩
       IMUL AX,CX,2                 ;加权总成绩乘2                   
       MOV DL,7
       DIV DL                       ;除以7
	   INC DI
       MOV BUF[BX][DI],AL      ;平均成绩存入数据段中（未考虑余数）       
       CMP CX,315              ;计算等级，(CX)中存放的是加权成绩总和
       JAE LA
       CMP CX,280
       JAE LB       
       CMP CX,245
       JAE LC
       CMP CX,210
       JAE LD 
       JMP LF

LA:    MOV DL,41H            ;等级A
       MOV AH,2
       INT 21H
       JMP END1
LB:    MOV DL,42H            ;等级B
       MOV AH,2
       INT 21H
       JMP END1
LC:    MOV DL,43H            ;等级C
       MOV AH,2
       INT 21H
       JMP END1
LD:    MOV DL,44H            ;等级D
       MOV AH,2
       INT 21H
       JMP END1
LF:    MOV DL,46H            ;等级F
       MOV AH,2
       INT 21H
       JMP END1

END1:  MOV SI,2                   ;清空输入缓冲区
LOP:   MOV INPUT[SI],20H             
	   INC SI
	   CMP SI,22
	   JB  LOP
       JMP START
END2:  MOV AH,4CH
       INT 21H

CODE   ENDS
       END START  
