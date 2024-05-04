; Justin Kopp
; 5/2/2024
; This handles all console related functions

.386P

.model flat

extern _GetStdHandle@4: near
extern _WriteConsoleA@20: near
extern _ReadConsoleA@20: near
extern _ExitProcess@4: near

.data

results				byte	"You typed: ", 0
outputHandle		dword   ?						; Storage the the handle for input and output. uninitslized
written				dword   ?
selectPrompt byte	"Enter Answer: ", 0
eko		byte	"You Entered : ", 0

prompt		byte	10, "Select an operation to compute", 10, "---------------------------------", 10, "[1] Addition", 10, "[2] Subtraction", 10, "[3] Multiplication", 10, "[4] Division", 10, "[5] Exit->", 10, 0


readBuffer			byte	1024		DUP(00h)
numCharsToRead		dword	1024
numCharsRead		dword	?
inputHandle			dword   ?
writeBuffer         byte    1024        DUP(00h)
count               dword   0
wBIndex             dword   ?
countDown           dword   ?

.code

getInput PROC C
_getInput:
    call readline
    mov eax, offset readBuffer
    ret
getInput ENDP


dispMenu PROC C
_dispMenu:
	push offset prompt
	call charCount
	push eax
	push offset prompt
	call writeline
	push offset selectPrompt
	call charCount
	push eax
	push offset selectPrompt
	call writeline
	ret
dispMenu ENDP

selection PROC C
_selection:
	push -10
	call _GetStdHandle@4
	mov inputHandle, eax
	call readline
_convert:
    push offset readBuffer
    call stringToInt                
	ret                             ;returns with selected int in EAX
selection ENDP

getInt PROC C
_getInt:
    call readline
    push offset readBuffer
    call stringToInt
    ret
getInt EndP

;intiger and console manipulation
;---------------------------------------------------------------------------------------------------------------------------------

writeInt PROC C
_writeInt:
    pop ebx                 ; Save the return address
    pop eax                 ; Save first number to convert in register EAX
    push ebx                ; Restore return address, this frees up EBX for use here.
    mov count, 0            ; Reset count
_convertLoop:
    ; Find the remainder and put on stack
    ; The choices are div for 8-bit division and idiv for 64-bit division. To use full registers, I had to use 64-bit division
    mov  edx, 0             ; idiv starts with a 64-bit number in registers edx:eax, therefore I zero out edx.
    mov  ebx, 10            ; Divide by 10.
    idiv ebx
    add  edx,'0'            ; Make remainder into a character
    push edx                ; Put in on the stack for printing this digit
    inc  count
    cmp  eax, 0
    jg   _convertLoop        ; Go back if there are more characters
    mov  wBIndex, offset writeBuffer
    mov     ebx, wBIndex
    mov  byte ptr [ebx], ' '; Add starting blank space
    inc  ebx            ; Go to next byte location
    mov     ecx, count    ; EBX is being reloading each divide, so I can use it here to
    mov     countDown, ecx   ; transfer value to set up counter to go through all numbers
_fillString:
    pop     eax                ; Remove the first stacked digit
    mov  [ebx], al            ; Write it in the array
    dec     countDown
    inc  ebx                ; Go to next byte location
    cmp     countDown, 0
    jg   _fillString
    mov  byte ptr[ebx], 0        ;Add end zero
    inc  count                ; Take into account extra space
    push count                ; How many characters to print
    push offset writeBuffer ; And the buffer itself
    call writeline

    ret                        ; And return
writeInt ENDP

writeline PROC C                    ;_writeline(#Chars, prompt)
_writeline:
	pop		eax						; pop the top element of the stack into eax
	pop		edx
	pop		ecx						; Pop top of stack and put into ECX
	push	eax						; Push content of EAX onto the top of the stack.
	push    -11
    call    _GetStdHandle@4
    mov     outputHandle, eax
                                    ; WriteConsole(handle, &msg[0], numCharsToWrite, &written, 0)
    push    0
    push    offset written
    push    ecx						; return ecx to the stack for the call to _WriteConsoleA@20 (20 is how many bits are in the call stack)
    push    edx
    push    outputHandle
    call    _WriteConsoleA@20
	ret
writeline ENDP

readline PROC C
_readline: 
	; ReadConsole(handle, &buffer, numCharToRead, numCharsRead, null

	push -10
	call _GetStdHandle@4
	mov inputHandle, eax      
    
    push	0
	push	offset numCharsRead
	push	numCharsToRead
	push	offset readBuffer
	push	inputHandle
	call	_ReadConsoleA@20
	ret
readline ENDP

charCount PROC C
_charCount:
    pop edx                 ;Save return address
    pop ebx                 ;Save offset/address of string
    push edx                ;Put return address back on to stack
    mov eax,0               ;load counter to 0
    mov ecx,0               ;Clear ecx register
_countLoop:
    mov cl,[ebx]            ;Look at the character in the string
    cmp ecx,0               ;Check for end of string
    je _endCount            
    inc eax                 ; Up the count by one
    inc ebx                 ; go the the next character
    jmp _countLoop
_endCount:
    ret                     ; Returns with the char count in eax
charCount ENDP

stringToInt PROC C
_stringToInt:
    ; Save the need information
    pop edx                     ; Save the current stack pointer
    pop ecx                     ; Save the address of the buffer with the number string
    push edx                    ; Restore stack pointer to the top of the stack.

    ; Take what was read and convert to a number
    mov   eax, 0                ; Initialize the number
    mov   ebx, 0                ; Make sure upper bits are all zero.
    
_findNumberLoop:
    mov   bl, [ecx]      ; Load the low byte of the EBX reg with the next ASCII character.
    cmp   bl, '9'               ; Make sure it is not too high
    jg   _endNumberLoop
    sub   bl, '0'               
    cmp   bl, 0                 ; or too low
    jl    _endNumberLoop
    mov   edx, 10              ; save multiplier for later need
    mul   edx
    add   eax, ebx
    inc   ecx                   ; Go to next location in number
    jmp   _findNumberLoop

 _endNumberLoop:
    ret                         ; EAX has the new integer when the code completes. And ) if no digits found.
stringToInt ENDP
END