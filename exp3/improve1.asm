.386
STACK  SEGMENT USE16 STACK
       DB 200 DUP(0)
STACK  ENDS

DATA   SEGMENT USE16
INPUT  DB 20                          ;输入缓冲区
       DB 0 
       DB 20 DUP(' ')
BUF    DB 1000 DUP(10 DUP(' '),0,0,0,0)
	   DB 'xueba_yu10',100,85,80,0
       DB 'xueba_shu0',80,100,70,0
       DB 'xueba_yin0',85,85,100,0
       DB '!'                          ;学生信息结束标志
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
       MOV BP,0  
       MOV AL,[SI]
	   CMP AL,71H                 ;判断输入是否等于q
       JE  PART1
	   MOV ECX,1000               ;大循环次数
       CALL disptime
	   MOV AH,10                  ;循环比较姓名次数
  
LOPA:  MOV AL,[SI]                ;循环比较姓名
	   MOV DI,SI
	   SUB DI,2
	   CMP AL,BUF[BP][DI]
       JNE PART2                  ;不相等，跳出
       INC SI
       DEC AH
       JZ  LOPB                   ;查找结束，已找到
       JMP LOPA

LOPB:  MOV DI,10                  ;求平均成绩
       MOV AL,BUF[BP][DI]           
       MOV AH,0
       IMUL BX,AX,2                ;语文成绩乘2
	   INC DI
       MOV AL,BUF[BP][DI]
       ADD BX,AX
       INC DI
       MOV AL,BUF[BP][DI]
       MOV DL,2
       IDIV DL                      ;英语成绩除以2
	   MOV AH,0
       ADD BX,AX                    ;BX储存加权总成绩
       IMUL DX,BX,2                 ;加权总成绩乘2,并保存在DX中
       MOV AX,DX                    
       MOV DL,7
       DIV DL                       ;除以7
	   INC DI
       MOV BUF[BP][DI],AL           ;平均成绩存入数据段中（未考虑余数）       	   
	
   	   MOV SI,OFFSET INPUT          ;大循环初始量重定义
	   ADD SI,2
       MOV BP,0
       MOV AH,10	   
	   LOOP LOPA
	   
	   CALL disptime
	   CMP BX,315                  ;计算等级，(BX)中存放的是加权成绩总和
       JAE LA
       CMP BX,280
       JAE LB       
       CMP BX,245
       JAE LC
       CMP BX,210
       JAE LD 
       JMP LF

PART2: MOV DI,10                    ;姓名不匹配跳出，计算平均成绩
       MOV AL,BUF[BP][DI]           
       MOV AH,0
       IMUL BX,AX,2                 ;语文成绩乘2
	   INC DI
       MOV AL,BUF[BP][DI]
       ADD BX,AX
       INC DI
       MOV AL,BUF[BP][DI]
       MOV DL,2
       IDIV DL                      ;英语成绩除以2
	   MOV AH,0
       ADD BX,AX                    ;BX储存加权总成绩
       IMUL DX,BX,2                 ;加权总成绩乘2,并保存在DX中
       MOV AX,DX                    
       MOV DL,7
       DIV DL                       ;除以7
	   INC DI
       MOV BUF[BP][DI],AL           ;平均成绩存入数据段中（未考虑余数）  

	   ADD BP,14                    ;跳转到下一条学生信息
       MOV SI,OFFSET INPUT
	   ADD SI,2
       MOV AH,10
       MOV AL,BUF[BP]               ;判断学生信息是否比较完
	   CMP AL,'!'
       JE  PART3
       JMP LOPA

PART1: INC SI                     ;判断是否需要退出
       MOV AL,[SI]
	   CMP AL,0DH
       JE END1
       DEC SI
       JMP LOPA

PART3: LEA DX,MES2             ;查找结束，未找到，跳转至开始
       MOV AH,9
       INT 21H
       JMP START

LA:    MOV DL,41H            ;等级A
       MOV AH,2
       INT 21H
       JMP START
LB:    MOV DL,42H            ;等级B
       MOV AH,2
       INT 21H
       JMP START
LC:    MOV DL,43H            ;等级C
       MOV AH,2
       INT 21H
       JMP START
LD:    MOV DL,44H            ;等级D
       MOV AH,2
       INT 21H
       JMP START
LF:    MOV DL,46H            ;等级F
       MOV AH,2
       INT 21H
       JMP START

disptime proc        ;显示秒和百分秒，精度为55ms。(未保护ax寄存器)
         local timestr[8]:byte     ;0,0,'"',0,0,0dh,0ah,'$'
         push cx
         push dx         
         push ds
         push ss
         pop  ds
         mov  ah,2ch 
         int  21h
         xor  ax,ax
         mov  al,dh
         mov  cl,10
         div  cl
         add  ax,3030h
         mov  word ptr timestr,ax
         mov  timestr+2,'"'
         xor  ax,ax
         mov  al,dl
         div  cl
         add  ax,3030h
         mov  word ptr timestr+3,ax
         mov  word ptr timestr+5,0a0dh
         mov  timestr+7,'$'    
         lea  dx,timestr  
         mov  ah,9
         int  21h    
         pop  ds 
         pop  dx
         pop  cx
         ret
disptime endp

END1:  MOV AH,4CH
       INT 21H

CODE   ENDS
       END START  





