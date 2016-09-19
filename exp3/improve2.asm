.386
STACK  SEGMENT USE16 STACK
       DB 200 DUP(0)
STACK  ENDS

DATA   SEGMENT USE16
INPUT  DB 20                          ;输入缓冲区
       DB 0
       DB 20 DUP(' ')
BUF    DB 1000 DUP(10 DUP(' '),100,85,80,0)
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
       MOV ESI,OFFSET INPUT
       MOV EBP,0
       MOV AL,2[ESI]
	   CMP AL,71H                 ;判断输入是否等于q
       JE  PART1
	   MOV ECX,1000               ;大循环次数
       CALL disptime
	   MOV AH,10                  ;姓名比较循环次数
  
LOPA:  MOV AL,2[ESI]              ;循环比较姓名
	   CMP AL,BUF[EBP][ESI]
       JNE PART2                  ;不相等，跳出
       INC ESI
       DEC AH
       JZ  LOPB                   ;查找结束，已找到
       JMP LOPA
LOPB:  MOV AL,BUF[EBP+10]         ;计算平均成绩
       MOV AH,0
	   SAL AX,1                   ;语文成绩右移1
	   MOV BX,AX
       MOV AL,BUF[EBP+11]
	   MOV AH,0
       ADD BX,AX                  
	   SAL BX,1                    ;语文数学成绩和右移1
       MOV AL,BUF[EBP+12]
	   MOV AH,0
       ADD AX,BX                   ;AX储存加权总成绩
       MOV DL,7
       DIV DL                      ;除以7
       MOV BUF[EBP+13],AL          ;平均成绩存入数据段中（未考虑余数）          
	   PUSH AX                     ;因disptime对AX有影响，故移出平均成绩，方便后续等级比较
	   MOV ESI,OFFSET INPUT        ;大循环初始量的重定义
       MOV EBP,0
       MOV AH,10
	   LOOP LOPA
	   
	   CALL disptime

	   POP AX
	   CMP AL,90                    ;计算等级
       JAE LA
       CMP AL,80
       JAE LB       
       CMP AL,70
       JAE LC
       CMP AL,60
       JAE LD 
       JMP LF

PART1: INC ESI                     ;判断是否需要退出
       MOV AL,2[ESI]
	   CMP AL,0DH
       JE END1
       DEC ESI
       JMP LOPA 

PART2: MOV AL,BUF[EBP+10]           ;姓名匹配不成功，跳出计算平均成绩
       MOV AH,0                     ;计算代码与上LOPB相同
	   SAL AX,1
	   MOV BX,AX
       MOV AL,BUF[EBP+11]
	   MOV AH,0
       ADD BX,AX
	   SAL BX,1
       MOV AL,BUF[EBP+12]
	   MOV AH,0
       ADD AX,BX           
       MOV DL,7
       DIV DL
       MOV BUF[EBP+13],AL           ;平均成绩存入数据段中（未考虑余数）           
	   ADD EBP,14                  ;跳转到下一条学生信息
       MOV ESI,OFFSET INPUT
       MOV AH,10
       MOV AL,BUF[EBP]             ;判断学生信息是否比较完
	   CMP AL,'!'
       JE  PART3	   
	   JMP LOPA

PART3: LEA DX,MES2               ;查找结束，未找到，跳转至开始
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





