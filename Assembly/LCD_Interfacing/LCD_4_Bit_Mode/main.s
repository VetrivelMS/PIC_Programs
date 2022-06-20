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

  

// PORTB - Data Lines
// PORTD - RD0,RD1,RD2 are Command Lines RS,RW,E Respectively
  
  
R1 EQU 0X00
R2 EQU 0X01
TEMP_REG EQU 0X03
  
  
psect   RSTVect,class=CODE,reloc=2 ; PIC18
RSTVect:
    goto MAIN
    
psect   INTVect,class=CODE,reloc=2 ; PIC18
    RETFIE
    
MAIN:
    MOVLW 0X0F				;WE ARE ONLY USING 4 PINS FOR DATA LINES SO SET RB7-RB4 AS OUTPUT PINS
    MOVWF TRISB
    BCF TRISD,0				;SET RS RW E PINS AS OUTPUT
    BCF TRISD,1
    BCF TRISD,2
    
    MOVLW LOW(MYCOMMAND)		;DATA TABLE POINTER LOWER BYTE OF ADDRESS BYTE
    MOVWF TBLPTRL
    MOVLW HIGH(MYCOMMAND)		;DATA TABLE POINTER HIGHER BYTE OF ADDRESS BYTE
    MOVWF TBLPTRH
    
M1: TBLRD*+				;TABLE READ CALL COMMAND ONE BY ONE
    MOVF TABLAT,W
    BZ NEXT1
    RCALL COMMAND
    BRA M1
    
NEXT1:
    MOVLW LOW(MESS1)
    MOVWF TBLPTRL
    MOVLW HIGH(MESS1)
    MOVWF TBLPTRH
    
M2: TBLRD*+
    MOVF TABLAT,W
    BZ NEXT2
    RCALL DATAWRITE
    BRA M2

NEXT2:
    MOVLW 0XC0
    RCALL COMMAND
 
    
    MOVLW LOW(MESS2)
    MOVWF TBLPTRL
    MOVLW HIGH(MESS2)
    MOVWF TBLPTRH
    
M3: TBLRD*+
    MOVF TABLAT,W
    BZ NEXT3
    RCALL DATAWRITE
    BRA M3
    
NEXT3:
    BRA $
    
COMMAND:					;COMMAND SUBROUTINE FOR 4 BIT MODE
    MOVWF TEMP_REG  
    
    ANDLW 0XF0					;SEND UPPER NIBBLE FIRST
    MOVWF PORTB
    
    BCF PORTD,0					;LATCH THE DATA
    BCF PORTD,1
    BSF PORTD,2
    RCALL DELAY
    BCF PORTD,2
    
    MOVF TEMP_REG,W				;AFTER LATCHING UPPER NIBBLE SEND LOWER NIBBLE
    
    ANDLW 0X0F					;MASK UPPER NIBBLE AND SWAP LOWER NIBBLE AND SEND IT
    SWAPF WREG,F
    MOVWF PORTB
    
    BCF PORTD,0					;LATCH THE LOWER NIBBLE TO THE LCD DATA LINE
    BCF PORTD,1
    BSF PORTD,2
    RCALL DELAY
    BCF PORTD,2
    
    RETURN
    
DATAWRITE:					;DATAWRITE SUBROUTINE FOR 4 BIT MODE - SAME PRINCIPLE AS COMMAND SUBRPOUTINE
    MOVWF TEMP_REG				;ONLY CHANGE IS SET RS = 1
    
    ANDLW 0XF0
    MOVWF PORTB
    
    BSF PORTD,0
    BCF PORTD,1
    BSF PORTD,2
    RCALL DELAY
    BCF PORTD,2
    
    MOVF TEMP_REG,W
    
    ANDLW 0X0F
    SWAPF WREG,F
    MOVWF PORTB
    
    BSF PORTD,0
    BCF PORTD,1
    BSF PORTD,2
    RCALL DELAY
    BCF PORTD,2
    
    RETURN

DELAY:						;DELAY PROGRAM TO GIVE LCD SOME TIME BETWEEN WRITE
    MOVLW 0XFF
    MOVWF R1
L2: MOVLW 0XFF
    MOVWF R2
L1: DECF R2,F
    BNZ L1
    DECF R1,F
    BNZ L2
    RETURN
    
    
MYCOMMAND: DB 0x02,0X28,0X01,0X06,0X0F,0X80,0	;DEFINE BYTES FOR THE COMMAND  (0X02 AND 0X28 COMMANDS IS A MUST FOR 4 BIT MODE OTHERWISE IT WON'T WORK)
MESS1: DB "Hello World!!!",0			;DEFINE BYTES FOR THE MESSAGE TO BE PRINTED ON LINE 1
MESS2: DB "4 BIT MODE WORKS",0			;DEFINE BYTES FOR THE MESSAGE TO BE PRINTED ON LINE 2

END RSTVect