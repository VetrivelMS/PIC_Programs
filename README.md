# PIC_Programs

This repository contains all my code on programming PIC microcontrollers from basic addressing modes and LED Blinking to interfacing GPRS MNodule and OLED Displays. Make sure to read the below _disclaimer_ before proceeding to check my code.

## _DISCLAIMER!!_

- All my code is applicable only for **PIC18F4550** Microcontroller. If you are using a different family or different chip of the same family, the code may not work properly.

- My code is for **reference** purpose only. My intention of posting my code in public is for my reference in future and for my colleagues reference only. Other poeple can also use this code as a reference.

- It should be noted that all my code is for learning and development purposes only.

- All the softwares and IDE's I use are licenced and free. I am using **XC8 Compiler** for compiling embedded C programs and **pic-as** Assembler for compiling assembly language programs.

- My code is in no way perfect. There might be bugs and there might be much more efficient way than my code. If you have any suggestions please contribute to the code. I will check the code and I will commit your suggestions in the code. This way we both can learn.

- I am in no way an expert in Assembly Language or PIC programming. I am a beginner and this repository is a timeline of me learning to code PIC Microcontrollers.

## Assembly Folder

```
 Assembler : pic-as
 IDE Software : MPLAB IDE
 Programmer/Debugger: PicKit 3
 Microcontroller Chipset: PIC18F4550
```

Assembly Folder contains all my code written in PIC18 Instruction Set for PIC18F4550 specifically.

I have organised my code based on Category (Eg.. LCD Interface, SPI, I2C,etc..).
Inside each category you will find a particular project and inside that project folder you will find the Assembly code.
The project folder will also contain a ready to burn hex file. People can use the hex file directly and burn it to their chip directly if they want to.

I will try to comment all my code. But in some cases, due to time constraints, I may not comment my code. Forgive me!!. But if you want comments for such files, then DM me or make a request, I will look into it.

## Embedded C Folder

```
 Assembler : XC8 Compiler
 IDE Software : MPLAB IDE
 Programmer/Debugger: PicKit 3
 Microcontroller Chipset: PIC18F4550
```

Embedded C folder contains all my projects and interfacing written in embedded C language.

I have organised my code just like Assembly folderbased on Categories and projects.
Inside each category, you will find a particular project and inside that project folder you will find the embedded C code for PIC18F4550

Just like Assembly Folder, this folder will also contain a ready to burn hex file compiled by XC8 Compiler. NOTE: This file will always be larger when compared to Assembly language counterpart, because Assembly language is much more efficient than Embedded C. But embedded C has a lot of features that Asssembly language cannot provide and also the coding in embedded C is much more easy and fluent.

## Software and Tools Used:

- MPLAB IDE
- MPLAB IPE
- XC8 Compiler
- pic-as Assembler
- PicKit 3 Programmer/Debugger
- KiCad 6.0

## Reference:

- PIC Microcontrollers and Embedded Systems: Using Assembly and C for PIC18
- PIC18F4550 Datasheet
