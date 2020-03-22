;*******************************************************************************
; Amateur Radio Licence Badge
; ---------------------------
;
; This code generates a periodic morse code signal sending the configured
; call sign. 
;	
; RUN on A4 or higher hardware revision or the power consumption will be higher 
; than documented. (see Errata)
;
; The PIC is left in sleep for most of the time, and we use interrupts to wake
; us to move to the next state. Eventually we stop sending the Morse and sleep
; forever. The user will need to reset (pushbutton) the PIC to begin the 
; sending process again.
;
; The Morse signalling will be on RA2, High (1) = On, Low (0) = Off
;
;*******************************************************************************
	list r=dec
	#include <p10lf322.inc>
	#include <morsecode.inc>

	
	constant CallSignRepeatCountBeforeShutdown = 5
	
;
; Define the Call sign or message here. One symbol per line to keep the 
; macro assembler happy
;
; Letters and Numbers: _A, _B, ... _0, _1, _2, ...
;
; Symbols:
;	_Space
;	_Period
;	_Comma
;	_QuestionMark
;	_Slash
;	_Plus
;	_Minus
;	_DoubleDash
;
CALL_SIGN	macro
	;------------------------
	_V
	_K
	_4
	_A
	_S
	_H
	;------------------------
	endm	
	
; CONFIG
 __CONFIG _FOSC_INTOSC & _BOREN_OFF & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _LVP_ON & _LPBOR_OFF & _BORV_LO & _WRT_OFF

;*******************************************************************************
; MAIN DATA
;*******************************************************************************
MAIN_DATA UDATA						; let linker place main RAM data
Repeats RES 1
 


;*******************************************************************************
; Reset Vector
;*******************************************************************************
RES_VECT	CODE	0x0000			; processor reset vector
	GOTO    START					; go to beginning of program

;*******************************************************************************
; Interrupt Vector - currently not in use, but if it is hit, we disable interrupts
;*******************************************************************************
ISR			CODE	0x0004			; interrupt vector location
	RETURN				; leave interrupts disabled. 
	
;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************
MAIN_PROG CODE					; let linker place main program

 
;
; Power on reset
;
; Initialise hardware
;
START
	CLRF	OSCCON				; 31KHz operation
	; make all pins digital outputs (MCLR is configured input by config bits)
	; Note that MCLR is enabled and therefore it has its weak pullup enabled by config
	CLRF	ANSELA
	CLRF	LATA
	CLRF	TRISA
	; Power config
	BSF     VREGCON,VREGPM1		; Put voltage regulator in Power Save mocde
	CALL	InitialiseTimer0
	CLRF	INTCON				; Disable all interrupts and clear flags
	GOTO	MAIN




;
; Main Code
;
MAIN
	MOVLW	CallSignRepeatCountBeforeShutdown
	MOVWF	Repeats

Loop
	; Reset timer0 configuration for morse
	CALL	InitialiseTimer0
	; Send call sign
	CALL_SIGN
	
	; Long delay between
	MOVLW	MaxMorsePeriods		; 7
	CALL	WaitMorsePeriods
	
	DECFSZ	Repeats,F			; Loop until Repeats is zero
	GOTO	Loop

	; sleep here forever, we have finished sending the callsign for now.
	; we enter 
	SLEEP
	GOTO	$-1
	
	END