PUBLIC average
.386
.model flat,C
.data
op dw 0
.code

average PROC NEAR C
	push ebx
	push esi
	push edi
	mov esi,esp
	mov edi,[esi+20]    ;s首地址
	mov ebx,[esi+16]    ;student首地址
	mov ecx,4
	mov esi,0

lop:                    ;计算平均成绩
	mov al,[ebx+esi+10]
	mov ah,0
	sal ax,1
	mov dx,ax
	mov al,[ebx+esi+11]
	add dx,ax
	sal dx,1
	mov al,[ebx+esi+12]
	add ax,dx
	mov dl,7
	div dl
	mov byte ptr [ebx+esi+13],al
	add esi,14
	loop lop

	mov word ptr op,0
	mov dx,0
	mov esi,0
lopa:
	mov al,byte ptr [edi+esi]
	mov ah,byte ptr [ebx+esi]
	cmp ah,al                   ;比较
	jne part2
	cmp ah,0
	je lopb
	inc esi
	cmp esi,10
	je lopb
	jmp lopa	
part2:
	add ebx,14                  ;下一个学生
	mov esi,0
	inc dx
	jmp lopa
lopb:
	mov ax,dx
	pop edi
	pop esi                      ;结束 
	pop ebx
	ret
average ENDP
END
