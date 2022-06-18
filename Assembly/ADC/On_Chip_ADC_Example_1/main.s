; psect   barfunc,local,class=CODE,reloc=2 ; PIC18


; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1L
  CONFIG  PLLDIV = 5            ; PLL Prescaler Selection bits (Divide by 5 (20 MHz oscillator input))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 2            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes from the 96 MHz PLL divided by 2)

; CONFIG1H
  CONFIG  FOSC = HSPLL_HS       ; Oscillator Selection bits (HS oscillator, PLL enabled (HSPLL))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOR = ON              ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)

// config statements should precede project file includes.
#include <xc.inc>

  
// THIS PROGRAM CONVERTS THE ANALOG DATA ON AN0 PIN AND SEND IT TO OUR PC VIA SERIAL COM PORT....
// PIN CONNECTIONS: ANALOG VOLTAGE TO AN0 PIN. SERIAL PORT TO COM PORT OF PC
  
R1 EQU 0X00
R2 EQU 0X01
MYNUM EQU 0X02
MYDEN EQU 0X03
QUO EQU 0X04
D0 EQU 0X05
D1 EQU 0X06
D2 EQU 0X07
HEX1 EQU 0X08
HEX2 EQU 0X09
HEX3 EQU 0X10
  
psect   RSTVect,class=CODE,reloc=2 ; PIC18
RSTVect:
    goto MAIN
    
psect   INTVect,class=CODE,reloc=2 ; PIC18
INTVect:
    RETFIE
    
MAIN:
    CALL SERIAL_INIT
    BSF TRISA,0			;SET ANALOG CHANNEL 0 PIN AS INPPUT
    SETF PORTD
    
    MOVLW 0X01
    MOVWF ADCON0		;ADC ON, SELECT CHANNEL 0
    
    MOVLW 0X0E
    MOVWF ADCON1		;VREF+ = VDD, VREF- = VSS, CONFIGURE CHANNEL 0 AS THE ONLY CHANNEL FOR ADC
    MOVLW 0X16
    MOVWF ADCON2		;LEFT JUSTIFIED, TAQ = 4 TAD, CLOCK SELECT = FOSC/64
    
AGAIN:				;DATA ACQUISTION DELAY
    RCALL DELAY
    BSF ADCON0,1		;SEND START OF CONVERSION SIGNAL
L1: BTFSC ADCON0,1		;MONITOR END OF CONVERSION SIGNAL. LOOP UNTIL DONE(BAR) BIT BECOMES 0
    BRA L1
    
    MOVLW LOW(MESS1)
    MOVWF TBLPTRL
    MOVLW HIGH(MESS1)
    MOVWF TBLPTRH
    
H1: TBLRD*+
    MOVF TABLAT,W
    BZ NEXT1
    RCALL SENDDATA
    BRA H1
    
NEXT1:
    MOVF ADRESH,W		;CONVERTED RESULT IS STORED IN WREG
    RCALL HEX_TO_ASCII		;CONVERTED DATA IS SENT TO THE SUBROUTINE TO CONVERT THE DATA FROM HEX TO ASCII
    MOVF HEX3,W			;GET THE ASCII VALUES STORED IN GPR LOCATIONS HEX3,HEX2,HEX1 AND SEND IT THROUGH THE COM PORT TO GET THE RESULT ON PC
    CALL SENDDATA
    MOVF HEX2,W
    CALL SENDDATA
    MOVF HEX1,W
    CALL SENDDATA
    MOVLW 0X0D
    CALL SENDDATA
    BRA AGAIN

HEX_TO_ASCII:			;PROGRAM TO CONVERT HEX VALUE TO ASCII VALUE. FIRST CONVERT HEXA TO DECIMAL. THEN CONVERT IT TO ASCII BY ORING THE DECIMAL BIT WITH X030
				;RESULTS ARE STORED ON GPR LOCATION HEX1,HEX2,HEX3
    MOVWF MYNUM			;HEX NUMBER TO BE CONVERTED IS STORED ON MYNUM REG
    MOVLW 10			;WREG HAS VALUE 10 FOR CONVERTION OPERATION
    CLRF QUO			;CLEAR QUO BEFORE CONVERTING, THIS CONTAINS THE QUOTIENT OF CONVERSION
    
G1: INCF QUO,F			;INCREMENT QUOTIENT UNTIL NUM BECOMES NEGATIVE
    SUBWF MYNUM,F		;THIS METHOD IS CALLED REPEATED SUBTRACTION SO WE GET A DIVISION OPERATION
    BC G1
	    
    DECF QUO,F			;DECREMENT QUO BY 1 BECAUSE 1 EXTRA QUO AFTER CONVERSION
    ADDWF MYNUM,F		;ADD DENOMINATOR TO THE NEGATIVE VALUE TO GET REMAINDER
    MOVFF MYNUM,D0		;STORE THE REMAINDER ON D0 GPR LOCATION (D0 - 0 BIT OF DECIMAL EQUIVALENT)
    
    MOVFF QUO,MYNUM		;THE QUOTIENT IS THE NEW NUMERATOR
    CLRF QUO			;CLEAR QUO
    
G2: INCF QUO,F			
    SUBWF MYNUM,F
    BC G2
    
    DECF QUO,F
    ADDWF MYNUM,F		
    MOVFF MYNUM,D1		;AFTER DIVISION, REMAINDER IS IN MYNUM GPR IS BIT1 OF THE DECIMAL EQUIVALENT
				;SAVE IT IN D1 REG
    MOVFF QUO,D2		;AFTER DIVISION, QUO IS BIT2 OF THE DECIMAL EQUIVALENT
				;SAVE IT IN D2 REG
    
    MOVLW 0X30			; OR ALL THE DECIMAL EQUIVALENT BITS WITH 0X30 TO GET ASCII VALUES OF THE DECIMAL BITS
    IORWF D0,W			
    MOVWF HEX1
    
    MOVLW 0X30
    IORWF D1,W
    MOVWF HEX2
    
    MOVLW 0X30
    IORWF D2,W
    MOVWF HEX3
    
    RETURN
    
    
DELAY:				;DATA ACQUISITION DELAY
    MOVLW 0X10
    MOVWF R1
Q2: MOVLW 0XFF
    MOVWF R2
Q1: DECF R2,F
    BNZ Q1
    DECF R1,F
    BNZ Q2
    RETURN
    

SERIAL_INIT:			;INITALISE SERIAL MONITOR SUBROUTINE
    
    BCF TRISC,6	
    
    MOVLW 77			;BAUD RATE VALUE 77 FOR 9600 BAUD RATE. CLOCK FREQUENCY = 48MHZ
    MOVWF SPBRG
    
    MOVLW 0X20			;TRANSMIT ENABLE
    MOVWF TXSTA
	    
    BSF RCSTA,7			;ENABLE SERIAL PORT
    RETURN
    
    
SENDDATA:
				;SEND THE DATA IN WREG REGISTER
F1: BTFSS PIR1,4
    BRA F1
    MOVWF TXREG
    RETURN
 
MESS1: DB 'CONVERTED DIGITAL DATA: ',0	;MESSAGE TO BE DISPLAYED IN SERIAL MONITOR
    
END RSTVect