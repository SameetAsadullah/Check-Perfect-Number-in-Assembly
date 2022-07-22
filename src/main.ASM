dosseg
.model small
.stack 100h
.data
	str1 db "Enter Number: $"
	num db 0
	str2 db "It is a perfect number$"
	str3 db "It is not a perfect number$"
	str4 db "Factors are: $"
.code
main proc
	mov ax,@data
	mov ds,ax
	
	LEA dx, str1		;Printing string
	mov ah,09h
	int 21h
	
	J1:
		mov ah,01h		;Taking two digit number as an input
		int 21h
		
		CMP al,13
		JE checkNum
		sub al,48
		JNE twoDigitNo
		
	JMP J1
		
	twoDigitNo:			;Storing two digit number
		mov dl,al
		
		mov ah,0
		mov al,num
		mov bl,10
		MUL bl

		mov num,al

		add num,dl
		
		JMP J1

	checkNum:			;Checking number if it is perfect or not
		CMP num,1
		JE notPerfectNo
	
		mov dx,0
		mov dl,num
		
		mov ax,0
		PUSH ax
		
		CALL perfect	;Calling func to check
		
		POP ax
		
		CMP ax,1
		JE perfectNo
		JNE notPerfectNo
		
	perfectNo:			;Printing if it is a perfect number
		mov ah,02h
		mov dl,10
		int 21h
		
		LEA dx, str2
		mov ah,09h
		int 21h
		JMP endPrograme
		
	notPerfectNo:		;Printing if it is not a perfect number
		LEA dx, str3
		mov ah,09h
		int 21h

	endPrograme:
		mov ah,04ch
		int 21h

main ENDP

;=======Procedure to check if it is a perfect number or not========;

perfect proc

	mov bx,0
	mov bl,1
	J2:					;Calculating factors of the number
		CMP bl,dl
		JE calSum
	
		mov ah,0
		mov al,dl
		DIV bl
		
		CMP ah,0
		JE pushStack
		
		INC bx
	JMP J2
	
	pushStack:			;Pushing factors to stack
		PUSH bx
		INC bx
		JMP J2
	
	calSum:				;Calculating sum of factors of the number
		mov bp,sp
		mov ax,0
		J3:
			add ax, [bp]
			mov cx, [bp]
			add bp,2
			CMP cx,1
			JE checkPerfect
		JNE J3
		
	JMP return
		
	checkPerfect:		;Checking if the sum of factors of the number is equal to the number itself or not
		CMP al,dl
		JNE popValues
		JE printFactors
		
	popValues:			;Popping factors of the number
		J5:
			POP ax
			CMP ax,1
			JE return
		JNE J5
		
	printFactors:		;Printing factors if its a perfect number
		LEA dx, str4
		mov ah,09h
		int 21h
		
		mov bp,sp
		J4:
			mov dx,[bp]
			CMP dx,9
			JA printTwoDigitNo
			
			mov ah,02h
			mov dx,[bp]
			add dx,48
			int 21h
			
			continue:
			mov cx, [bp]
			add bp,2
			CMP cx,1
			JE indicateTrue
			
			mov ah,02h
			mov dl,44
			int 21h
			
		JNE J4
		
	indicateTrue:		;Returns value 1 in the stack if its a perfect number otherwise 0
		add bp,2
		mov cx,1
		mov [bp],cx
		JMP popValues
		
	printTwoDigitNo:	;Printing two digit number
		mov ax,dx
		mov bl,10
		DIV bl
		
		mov dh,ah
		
		mov ah,02h
		mov dl,al
		add dl,48
		int 21h
		
		mov ah,02h
		mov dl,dh
		add dl,48
		int 21h
		
		JMP continue
		
	return:			;Returning from function
		
		RET

perfect ENDP

end main
