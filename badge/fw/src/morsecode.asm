;*******************************************************************************
; Morse Code timing and generation
; --------------------------------
;
; Morse words per minute is calculated off the PARIS word, resulting in
; 50 periods (dit times) per word. at 5 wpm, that is 250 periods per minute
; or 250/60 = 240ms per period.
;
; Timer0 Configuration
;
; If we allow up to 7 (0b00000111) time periods for the delay routine
; we have 256/7 = ~36 clocks per period we can allow per period without 
; overflowing the counter. lets make it 32 clocks per 240ms to be safe.
;
; 240ms / 32 = 7.5ms, so the overall divider change needs to be about 133.3Hz
; into the counter.
; 
; We are clocking the oscillator at 31KHz, and an instruction clock (Fosc/4) of
; 7,750Hz so various prescalers give:
;	256:1 - 30.27Hz
;	128:1 - 60.55Hz
;	 64:1 - 121.01Hz
;    32:1 - 242.18Hz
;
; Lets choose 64:1, 121Hz. 240ms / 121Hz = 29 ticks per period.
; We can make it smaller to go faster, or larger (up to 32) to go slower
;
;*******************************************************************************
	#include <p10lf322.inc>
	list r=dec
	

	constant TicksPerPeriod = 29

;
; Macro to create out lookup Table for period -> counter value
; 
_Generate_CounterTable macro numEntries, increment
	local c
	ADDWF	PCL
c = 0
	while c < numEntries
		RETLW	0xFF - (increment * c)
c += 1
	endw
	endm
	

;MORSE_DATA	UDATA
;PeriodTemp	RES 1				; temp storage for computing timer0 count
	
MORSE_CODE	CODE
	
	global	InitialiseTimer0
	global	Dit
	global	Dah
	global	WaitMorsePeriods
	
; Send a Morse "Dit"
Dit
	BSF		LATA, LATA2			; On
	MOVLW	1					; Delay 1 period
	CALL WaitMorsePeriods		
	BCF		LATA, LATA2			; Off
	MOVLW	1					; Delay 1 period for intra-symbol delay
	CALL WaitMorsePeriods
	RETLW 0

; Send a Morse "Dah"
Dah
	BSF		LATA, LATA2			; On
	MOVLW	3					; Delay 1 period
	CALL WaitMorsePeriods		
	BCF		LATA, LATA2			; Off
	MOVLW	1					; Delay 1 period for intra-symbol delay
	CALL WaitMorsePeriods
	RETLW 0

;
; Precomputed counter values for the 0-7 period delays
;
_CounterLookup
	_Generate_CounterTable 8, TicksPerPeriod


; Sleep for the number of morse periods in the W register. 
WaitMorsePeriods
	; Truncate to max 7 periods
	ANDLW	b'00000111'
	; lookup the correct timer value, and set the timer0 register
	CALL	_CounterLookup	
	BCF		INTCON, TMR0IF		; clear timer interrupt
	MOVWF	TMR0
	BSF		INTCON, TMR0IE		; Enable interrupt
	
	SLEEP						; Power down until overflow
	NOP
	BCF		INTCON, TMR0IE		; Disable interrupt
	RETLW 0
	
	
InitialiseTimer0
	MOVLW	b'11010101'			; TIMER0 clock is FCYC, Prescaler 1:64, assigned to Timer0
	MOVWF	OPTION_REG
	RETLW 0


	END