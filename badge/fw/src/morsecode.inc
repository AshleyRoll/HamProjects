;
; Define the interface to morse code generator and macros
;
; Each character is sent using the Dit and Dah routines that
; insert a single morse period delay between symbols.
;
; At the end of each letter, we need a 3 period space, but
; will have already had a 1 period delay, so wait 2 more

; used internally
__EndSymbol	macro
	MOVLW	2		; Inter character pause = 3 (2 + 1 from previous symbol)
	CALL	WaitMorsePeriods
	endm

; Symbols

_Space macro
	MOVLW	4		; Inter word pause = 7 (4 + 3 from previous character)
	CALL	WaitMorsePeriods
	endm

_Period macro
	CALL	Dit
	CALL	Dah
	CALL	Dit
	CALL	Dah
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_Comma macro
	CALL	Dah
	CALL	Dah
	CALL	Dit
	CALL	Dit
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_QuestionMark macro
	CALL	Dit
	CALL	Dit
	CALL	Dah
	CALL	Dah
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_Slash macro
	CALL	Dah
	CALL	Dit
	CALL	Dit
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm

_Plus macro
	CALL	Dit
	CALL	Dah
	CALL	Dit
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm

_Minus macro
	CALL	Dah
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_DoubleDash macro
	CALL	Dah
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

; Numbers

_0 macro
	CALL	Dah
	CALL	Dah
	CALL	Dah
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_1 macro
	CALL	Dit
	CALL	Dah
	CALL	Dah
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_2 macro
	CALL	Dit
	CALL	Dit
	CALL	Dah
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_3 macro
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_4 macro
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_5 macro
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_6 macro
	CALL	Dah
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_7 macro
	CALL	Dah
	CALL	Dah
	CALL	Dit
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_8 macro
	CALL	Dah
	CALL	Dah
	CALL	Dah
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_9 macro
	CALL	Dah
	CALL	Dah
	CALL	Dah
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm


; Letters


_A macro
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_B macro
	CALL	Dah
	CALL	Dit
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_C macro
	CALL	Dah
	CALL	Dit
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm

_D macro
	CALL	Dah
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_E macro
	CALL	Dit
	__EndSymbol
	endm

_F macro
	CALL	Dit
	CALL	Dit
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm

_G macro
	CALL	Dah
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm

_H macro
	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_I macro
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_J macro
	CALL	Dit
	CALL	Dah
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_K macro
 	CALL	Dah
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_L macro
	CALL	Dit
	CALL	Dah
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_M macro
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_N macro
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm

_O macro
	CALL	Dah
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_P macro
	CALL	Dit
	CALL	Dah
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm

_Q macro
	CALL	Dah
	CALL	Dah
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_R macro
	CALL	Dit
	CALL	Dah
	CALL	Dit
	__EndSymbol
	endm

_S macro
	CALL	Dit
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

_T macro
	CALL	Dah
	__EndSymbol
	endm

_U macro
	CALL	Dit
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_V macro
 	CALL	Dit
	CALL	Dit
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_W macro
 	CALL	Dit
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_X macro
 	CALL	Dah
	CALL	Dit
	CALL	Dit
	CALL	Dah
	__EndSymbol
	endm

_Y macro
 	CALL	Dah
	CALL	Dit
	CALL	Dah
	CALL	Dah
	__EndSymbol
	endm

_Z macro
 	CALL	Dah
	CALL	Dah
	CALL	Dit
	CALL	Dit
	__EndSymbol
	endm

















