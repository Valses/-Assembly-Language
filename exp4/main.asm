.386
;程序名字：4

;程序功能：完成5个学生姓名成绩的录入，平均成绩的计算，名词的排序，平均成绩的输出
;主程序采用两个宏定义完成9号与10号DOS调用
;调用了五个near类型的子程序分别为F2T10，F10T2，AVERAGE,SORT,OUTPUT

;本模块代码提供者：尹丹丽
;同组成员：张雅昕，华苗


INCLUDE  MYLIB.LIB
EXTRN    F10T2:NEAR,F2T10:NEAR,AVERAGE:NEAR,SORT:NEAR,OUTPUT:NEAR
PUBLIC   BUF,PP,RANK

READ	MACRO A				;10号DOS调用
		LEA DX,A
		MOV AH,10
		INT 21H
		ENDM
WRITE	MACRO A				;9号DOS调用
		LEA DX,A
		MOV AH,9
		INT 21H
		ENDM
		
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
in_information	DB 16,0,10 DUP(0),0,0,0,0
				DB 16,0,10 DUP(0),0,0,0,0
				DB 16,0,10 DUP(0),0,0,0,0
				DB 16,0,10 DUP(0),0,0,0,0	;存五个学生的姓名和成绩
				DB 16,0,10 DUP(0),0,0,0,0	;用于存放名字和成绩
in_mark DB 10
		DB 0
		DB 10 DUP(0)						;用于成绩的进制转换
BUF DB 10 DUP(0)							;数字串存储区	
PP  DW 0									;要转的进制	
RANK DB 5 DUP(0)                            ;排序储存
;系统提示的成绩单
MENU	DB '*****************************************************************',0AH,0DH
		DB 'Choose 1--5 to realize function:',0AH,0DH
		DB '1:Input name and mark of a student	2:Calculate average mark',0AH,0DH
		DB '3:Output the the ranking list		4:Output the average mark',0AH,0DH
		DB '5:Quit this system',0AH,0DH
		DB '*****************************************************************',0AH,0DH,'$'
COUT1	DB'Illegal input!',0AH,0DH,'$'
COUT_CHOOSE	DB 'Choose the number of the student to input:',0AH,0DH,'$'
COUT2	DB'The information you input now is the student of NO.','$'
COUT_NAME	DB 'Input the name of the student:',0AH,0DH,'$'
COUT_MATH	DB 'Input the mark of math:',0AH,0DH,'$'
COUT_CHINESE	DB 'Input the mark of Chinese:',0AH,0DH,'$'
COUT_ENGLISH	DB 'Input the mark of English:',0AH,0DH,'$'
COUT_INPUT_FINISH	DB'Input completed',0AH,0DH,'$'
COUT_COUNT_FINISH	DB'Calculate completed!',0AH,0DH,'$'
COUT_RANK_FINISH	DB'Rank completed!',0AH,0DH,'$'
COUT_OUTPUT_FINISH	DB'Output completed!',0AH,0DH,'$'
COUT_COUNT_ERROR	DB 'ERROR!',0AH,0DH,'$'
CLR		DB 0AH,0DH,'$'
DATA ENDS

STACK SEGMENT USE16 STACK
	DB 200 DUP(0)
STACK ENDS

CODE SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK

START:	MOV AX,DATA
		MOV DS,AX
		WRITE MENU
		XOR EAX,EAX
		MOV AH,1				;1--5号功能选择
		INT 21H
		WRITE CLR
		CMP AL,49
		JE F1
		CMP AL,50
		JE F2
		CMP AL,51
		JE F3
		CMP AL,52
		JE F4
		CMP AL,53
		JE F5
		WRITE COUT1
		WRITE CLR
		JMP START
		
;输入名字与成绩		
F1:		WRITE COUT_CHOOSE
		LEA BX,in_information	;BX指向in_information的首址
		MOV AH,1
		INT 21H
		CMP AL,36H
		JA ERR
		CMP AL,31H
		JE L1
		CMP AL,32H
		JE L2
		CMP AL,33H
		JE L3
		CMP AL,34H
		JE L4
		CMP AL,35H
		JE L5
L6:		WRITE CLR
		WRITE COUT2
		MOV DL,AL				;显示录入第几个学生的信息
		MOV AH,2
		INT 21H
		WRITE CLR
		WRITE COUT_NAME			;输入学生信息
		READ [BX]
		WRITE CLR
		WRITE COUT_CHINESE		;存入语文成绩
		LEA DX,in_mark			;缓冲区清零且输入成绩
		MOV AH,0CH
		MOV AL,0AH
		INT 21H
		LEA SI,in_mark
		MOVZX CX,in_mark+1
		ADD SI,2
		CALL F10T2
		ADD BX,12
		MOV [BX],AX
		WRITE CLR
		WRITE COUT_MATH			;存如数学成绩
		LEA DX,in_mark
		MOV AH,0CH
		MOV AL,0AH
		INT 21H
		LEA SI,in_mark
		MOVZX CX,in_mark+1
		ADD SI,2
		CALL F10T2
		INC BX
		MOV [BX],AX
		WRITE CLR
		WRITE COUT_ENGLISH		;存入英语成绩
		LEA DX,in_mark
		MOV AH,0CH
		MOV AL,0AH
		INT 21H
		LEA SI,in_mark
		MOVZX CX,in_mark+1
		ADD SI,2
		CALL F10T2
		INC BX
		MOV [BX],AX
		WRITE CLR
		WRITE COUT_INPUT_FINISH	;显示输入完成
		JMP START
L1:		JMP L6
L2:		ADD BX,16
		JMP L6
L3:		ADD BX,32
		JMP L6
L4:		ADD BX,48
		JMP L6
L5:		ADD BX,64
		JMP L6
		
;计算平均分
F2:		LEA SI,in_information
		CALL AVERAGE
		CMP SI,-1
		JE ERR
		WRITE COUT_COUNT_FINISH
		JMP START
ERR:	WRITE COUT_COUNT_ERROR
		JMP START
;平均分排序		
F3:     LEA SI,in_information
        CALL SORT
		CMP SI,-1
		JE ERR
		WRITE COUT_RANK_FINISH
		JMP START
;按照排序输出姓名和平均分		
F4:		LEA SI,in_information
		CALL OUTPUT
		CMP SI,-1
		JE ERR
		WRITE COUT_OUTPUT_FINISH
		JMP START

;键入5则退出程序
F5:		MOV AH,4CH
		INT 21H
		
	
CODE 	ENDS
		END START
