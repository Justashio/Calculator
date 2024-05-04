; Justin Kopp
; 5/2/2024
; Includes the following functions 
; _addition()								prints the sum
; _subtract()								prints the difference
; _multiplication()							prints the product
; _devision()								prints the quotient
; _printEq(var1, var2, opperatorHandle)		constructs an equation to be printed to console


.386

.model flat

extern _charCount: near
extern _writeline: near
extern _getInt: near
extern _writeInt: near
extern _stringToInt: near

.data
datOne	dword	?
datTwo	dword	?
varOne	dword	?
varTwo	dword	?
prntOne	byte	"Enter 1st Var: ", 0
prntTwo byte	"Enter 2nd Var: ", 0
plus	byte	" +"
minus	byte	" -"
mult	byte	" *"
divi	byte	" /"
equal	byte	" ="
zeroPrompt byte	"ha! you cant do that. Try again.", 10, 0
.code

addition PROC C
_addition:
	push offset prntOne				; Pirnt first var prompt
	call _charCount
	push eax
	push offset prntOne
	call _writeline

	call _getInt					; get Int and move to varOne
	mov varOne, eax

	push offset prntTwo				; print second var prompt
	call _charCount
	push eax
	push offset prntTwo
	call _writeline

	call _getInt					; get Int and move to varTwo
	mov varTwo, eax
	
	push 1							; Print left half of equation
	push varTwo
	push varOne
	call printEq

	mov eax, varOne					; Reinstate variables to registers
	mov ebx, varTwo	

	add eax, ebx					; Add variable registers
	push eax						
	call _writeInt
	ret
addition ENDP

subtract PROC C
_subtract:
	push offset prntOne				; Pirnt first var prompt
	call _charCount
	push eax
	push offset prntOne
	call _writeline

	call _getInt					; get Int and move to varOne
	mov varOne, eax

	push offset prntTwo				; print second var prompt
	call _charCount
	push eax
	push offset prntTwo
	call _writeline

	call _getInt					; get Int and move to varTwo
	mov varTwo, eax
	
	push 2							; Print left half of equation
	push varTwo
	push varOne
	call printEq

	mov eax, varOne					; Reinstate variables to registers
	mov ebx, varTwo	

	cmp eax, ebx					; Determine if result will be negative
	jl _negative

	sub eax, ebx					;subtracts variable registers
	push eax
	call _writeInt
	ret
_negative:							; When the result will be negative
	sub ebx, eax					; subtracts var1 from var2
	push 2
	push offset minus				; puts a negative sign infront of result
	call _writeline
	push ebx
	call _writeint
	ret
subtract ENDP

multiply PROC C
_multiply:
	push offset prntOne				; Pirnt first var prompt
	call _charCount
	push eax
	push offset prntOne
	call _writeline

	call _getInt					; get Int and move to varOne
	mov varOne, eax

	push offset prntTwo				; print second var prompt
	call _charCount
	push eax
	push offset prntTwo
	call _writeline

	call _getInt					; get Int and move to varTwo
	mov varTwo, eax
	
	push 3							; Print left half of equation
	push varTwo
	push varOne
	call printEq

	mov eax, varOne					; Reinstate variables to registers
	mov ebx, varTwo	

	imul eax, ebx					; multiply variable registers
	push eax						
	call _writeInt
	ret
multiply ENDP

divide PROC C
_divide:
	push offset prntOne				; Pirnt first var prompt
	call _charCount
	push eax
	push offset prntOne
	call _writeline

	call _getInt					; get Int and move to varOne
	mov varOne, eax

	push offset prntTwo				; print second var prompt
	call _charCount
	push eax
	push offset prntTwo
	call _writeline

	call _getInt					; get Int and move to varTwo
	mov varTwo, eax
	
	cmp varTwo, 0
	je _div_by_zero

	push 4							; Print left half of equation
	push varTwo
	push varOne
	call printEq

	mov eax, varOne					; Reinstate variables to registers
	mov ebx, varTwo	

	cdq								; sign extend eax into edx:eax
	idiv ebx						; divide variable registers
	push eax						
	call _writeInt
	ret

_div_by_zero:
	push offset zeroPrompt
	call _charCount
	push eax
	push offset zeroPrompt
	call _writeline
	jmp _divide
divide ENDP

printEq PROC C						; _printEq(var1, var2, opperatorHandle)
_printEq:							; operator Handles: (1 = + , 2 = - , 3 = * , 4 = / )
	pop edx							; pop return address
	pop datOne						; pop var1
	pop datTwo						; pop var2
	pop ecx							; pop operator Handle
	push edx						; restore return address
_opHandle:							; compute operator Handle
	cmp ecx, 1						
	je _add
	cmp ecx, 2
	je _sub
	cmp ecx, 3
	je _mul
	cmp ecx, 4
	je _div
_add:								; below construct detected equation 
	push datOne
	call _writeInt
	push 2
	push offset plus
	call _writeline
	push datTwo
	call _writeInt
	push 2
	push offset equal
	call _writeline
	ret
_sub:
	push datOne
	call _writeInt
	push 2
	push offset minus
	call _writeline
	push datTwo
	call _writeInt
	push 2
	push offset equal
	call _writeline
	ret
_mul:
	push datOne
	call _writeInt
	push 2
	push offset mult
	call _writeline
	push datTwo
	call _writeInt
	push 2
	push offset equal
	call _writeline
	ret
_div:
	push datOne
	call _writeInt
	push 2
	push offset divi
	call _writeline
	push datTwo
	call _writeInt
	push 2
	push offset equal
	call _writeline
	ret
printEq ENDP
END