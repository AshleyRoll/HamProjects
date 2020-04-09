;*******************************************************************************
; Amateur Radio Licence Badge
; ---------------------------
;
; This code generates a periodic morse code signal sending the configured
; call sign.
;
; The PIC is left in sleep for most of the time, and we use the Watch Dog to wake
; us to move to the next state. Eventually we stop sending the Morse and sleep
; forever. The user will need to reset (pushbutton) the PIC to begin the
; sending process again.
;
; The Morse signalling will be on RA2, High (1) = On, Low (0) = Off
;
; NOTE:
;   Run on A4 or higher hardware revision of the PIC10LF322 or the power
;   consumption will be higher than documented. (see Errata)
;
; Morse Code timing and generation
; --------------------------------
;
; Morse words per minute is calculated off the PARIS word, resulting in
; 50 periods (dit times) per word. at 5 wpm, that is 250 periods per minute
; or 250/60 = 240ms per period.
;
; We have to use the WDT to allow for sleeping, this has a nominal
; period of between 1 millisecond and 256 seconds, with a doubling
; each setting (powers of 2).
;
; We can choose 128ms for about 10 WPM or 256ms for about 5WPM
;
; Ashley Roll. VK4ASH. 2020-04-09
;
;*******************************************************************************
	list r=dec
	#include <p10lf322.inc>
	#include <morsecode.inc>

	; number of times to send the call sign
	constant CallSignRepeatCountBeforeShutdown = 5

	; watchdog period prescaler
	;
	; 10010  = 1:8388608 (223) (Interval 256s nominal)
	; 10001  = 1:4194304 (222) (Interval 128s nominal)
	; 10000  = 1:2097152 (221) (Interval 64s nominal)
	; 01111  = 1:1048576 (220) (Interval 32s nominal)
	; 01110  = 1:524288 (219) (Interval 16s nominal)
	; 01101  = 1:262144 (218) (Interval 8s nominal)
	; 01100  = 1:131072 (217) (Interval 4s nominal)
	; 01011  = 1:65536  (Interval 2s nominal) (Reset value)
	; 01010  = 1:32768 (Interval 1s nominal)
	; 01001  = 1:16384 (Interval 512 ms nominal)
	; 01000  = 1:8192 (Interval 256 ms nominal)
	; 00111  = 1:4096 (Interval 128 ms nominal)
	; 00110  = 1:2048 (Interval 64 ms nominal)
	; 00101  = 1:1024 (Interval 32 ms nominal)
	; 00100  = 1:512 (Interval 16 ms nominal)
	; 00011  = 1:256 (Interval 8 ms nominal)
	; 00010  = 1:128 (Interval 4 ms nominal)
	; 00001  = 1:64 (Interval 2 ms nominal)
	; 00000  = 1:32 (Interval 1 ms nominal)
	;
	; NOTE: bit 0 is SW ENABLE bit and must be zero
	;       which is why we left shift

	constant WDTPrescaleMorse = b'00111' << 1			; 128ms ~10PWM
	constant WDTPrescaleSendDelay = b'01011' << 1		; 2s
	constant WDTPrescaleForeverSleep = b'10000' << 1	; 64s


;*******************************************************************************
; Call Sign
; ---------
;
; Define the Call sign or message here. One symbol per line to keep the
; macro assembler happy. This macro is then used in the main loop
;
; Letters and Numbers: _A, _B, ... _0, _1, _2, ...
;
; Symbols:
;	_Space _Period _Comma _QuestionMark _Slash
;	_Plus _Minus _DoubleDash
;
;*******************************************************************************
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
 __CONFIG _FOSC_INTOSC & _BOREN_OFF & _WDTE_SWDTEN & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _LVP_ON & _LPBOR_OFF & _BORV_LO & _WRT_OFF

;*******************************************************************************
; MAIN DATA (Variables)
;*******************************************************************************
MAIN_DATA UDATA		; let linker place main RAM data

Repeats RES 1		; The number of times to send the callsign before
					; sleeping forever

PeriodCount	RES 1	; temp storage for counting the number of
					; WDT loops for the current symbol


;*******************************************************************************
; Reset Vector
;*******************************************************************************
RES_VECT	CODE	0x0000			; processor reset vector
	GOTO    START					; go to beginning of program

;*******************************************************************************
; Interrupt Vector - currently not in use, but if it is hit, we disable interrupts
;*******************************************************************************
ISR			CODE	0x0004			; interrupt vector location
	RETURN							; leave interrupts disabled.

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
	; 31KHz LFINTOSC clock mode seems to need more current than using the
	; HFINTOSC and dividing it down. Chosen the slowest HF divider output
	; to minimise the power consumption while awake
	MOVLW	b'00010000'			; 250KHz divided HFINTOSC
	MOVWF	OSCCON

	; Power config
	BSF     VREGCON,VREGPM1		; Put voltage regulator in Power Save mode
								; for lowest sleep current

	; make all pins digital outputs (MCLR is configured input by config bits)
	; Note that MCLR is enabled and therefore it has its weak pullup enabled by config
	CLRF	ANSELA
	CLRF	LATA
	CLRF	TRISA
	CLRF	INTCON				; Disable all interrupts and clear flags

	; And now start the main loop
	GOTO	MAIN




;
; Main Code
;
MAIN
	MOVLW	CallSignRepeatCountBeforeShutdown
	MOVWF	Repeats

Loop
	;
	; Set the Watch dog timer prescaller, this controls the morse code
	; sending rate
	CLRWDT
	MOVLW	WDTPrescaleMorse
	MOVWF	WDTCON

	; Send call sign
	CALL_SIGN

	; Long delay between sending callsign
	; we do this by extending the WDT delay and using the
	; Morse delay to wait for that to expire once
	CLRWDT
	MOVLW	WDTPrescaleSendDelay
	MOVWF	WDTCON
	MOVLW	1
	CALL	WaitMorsePeriods

	DECFSZ	Repeats,F			; Loop until Repeats is zero
	GOTO	Loop

	; sleep here forever, we have finished sending the callsign, so
	; now we wait to be reset forever

	; Prepare for eternal sleep by setting the slow WDT
	CLRWDT
	MOVLW	WDTPrescaleForeverSleep
	MOVWF	WDTCON

Forever
	SLEEP
	NOP
	GOTO	Forever

; Sleep for the number of morse periods in the W register
; This uses Watchdog timer expiration to time things so speed is controlled by
; its prescaller
WaitMorsePeriods
	MOVWF	PeriodCount			; Save the count
	BSF		WDTCON, SWDTEN		; Enable WDT

_MorseTimerLoop
	SLEEP	; Wait for WDT expiry
	NOP

	DECFSZ	PeriodCount, F	   ; Loop until we exhaust the loop count
	    GOTO _MorseTimerLoop

	BCF	WDTCON, SWDTEN	; Disable WDT
	RETLW 0

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

	; End of file
	END
