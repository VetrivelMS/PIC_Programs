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
COL EQU 0X02
  
psect   RSTVect,class=CODE,reloc=2 ; PIC18
RSTVect:
    goto MAIN
    
psect   INTVect,class=CODE,reloc=2 ; PIC18
INTVect:
    BTFSC INTCON,0
    GOTO KEY_ISR
    RETFIE
    
MAIN:
    CLRF TRISD
    BCF INTCON2,7
    MOVLW 0XF0
    MOVWF TRISB
    MOVWF PORTB
    
CHECK_KEY_OPEN:
    CPFSEQ PORTB
    BRA CHECK_KEY_OPEN
    
    MOVLW HIGH(KCODE0)
    MOVWF TBLPTRH
    
    BSF INTCON,7
    BSF INTCON,3
    
    BRA $
    
    
KEY_ISR:
    CALL DELAY
    MOVFF PORTB,COL
    MOVLW 0XFE
    MOVWF PORTB
    CPFSEQ PORTB
    BRA ROW0
    MOVLW 0XFD
    MOVWF PORTB
    CPFSEQ PORTB
    BRA ROW1
    MOVLW 0XFB
    MOVWF PORTB
    CPFSEQ PORTB
    BRA ROW2
    MOVLW 0XF7
    MOVWF PORTB
    CPFSEQ PORTB
    BRA ROW3
    GOTO BAD_RBIF
    
    
ROW0:
    MOVLW LOW(KCODE0)
    BRA FIND
    
ROW1:
    MOVLW LOW(KCODE1)
    BRA FIND

ROW2:
    MOVLW LOW(KCODE2)
    BRA FIND
    
ROW3:
    MOVLW LOW(KCODE3)
    
FIND:
    MOVWF TBLPTRL
    MOVLW 0XF0
    XORWF COL
    SWAPF COL,F
L1: RRCF COL,F
    BC FOUND
    INCF TBLPTRL,F
    BRA L1

FOUND:
    TBLRD*
    MOVFF TABLAT,PORTD
    COMF PORTD,F
    
WAIT:
    MOVLW 0XF0
    MOVWF PORTB
    CPFSEQ PORTB
    BRA WAIT
    BCF INTCON,0
    RETFIE

BAD_RBIF:
    MOVLW 0X00
    MOVWF PORTD
    GOTO WAIT

DELAY:
    MOVLW 0X10
    MOVWF R1
D2: MOVLW 0XFF
    MOVWF R2
D1: DECF R2,F
    BNZ D1
    DECF R1,F
    BNZ D2
    RETURN

KCODE0: DB '1','2','3','A'
KCODE1: DB '4','5','6','B'
KCODE2: DB '7','8','9','C'
KCODE3: DB '*','0','#','D'

    
END RSTVect