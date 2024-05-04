; Justin Kopp
; 5/2/2024
; This program allows the user to select an operation
; It the asks for two variables and performs the requested operation
; the program will loop until the user selects exit->

.386P

.model flat

extern _ExitProcess@4: near

extern _charCount: near
extern _writeline: near
extern _getInt: near
extern _dispMenu: near
extern _addition: near
extern _subtract: near
extern _multiply: near
extern _divide: near

.data

selected	dword	?
invalid		byte	"Invalid Input. Try again"	

.code

main PROC near
_main:
	call _dispMenu				; display the menu and take selection from user
	call _getInt
	mov selected, eax
	
	cmp selected, 1				; dictate which option the user chose
	je _sum
	cmp selected, 2
	je _subtraction
	cmp selected, 3
	je _multiplication
	cmp selected, 4
	je _division
	cmp selected, 5				; detects if the user wants to exit the program
	je _exit					
	push offset invalid
	call _charCount
	push eax
	push offset invalid
	call _writeline
	jmp _main					; if input was invalid will jump back to main to try again

_sum:							; calls operation function and jumps back to main when complete
	call _addition
	jmp _main
_subtraction:
	call _subtract
	jmp _main
_multiplication:
	call _multiply
	jmp _main
_division:
	call _divide
	jmp _main


_exit:
	push 0
	call _ExitProcess@4

main ENDP

END