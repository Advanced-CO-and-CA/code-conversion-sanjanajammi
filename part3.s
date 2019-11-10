


/******************************************************************************
* File: part3.s
* Author: Sanjana Jammi
* Roll number: CS18M522
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Assignment 5 
  PART 3 - Convert a 8 digit packed BCD number to 32 bit hex number
  Algorithm used - 
  Input represents the given number in hex format which are 8 digits of packed BCD number (4 bits for each digit)
  Shift right by 4 each time and obtain the lower 4 bits each time
  Find output by multiplying by 1,10, 100, 1000.. starting from the least significant nibble and accumulating the result  
  */

  @ BSS section
      .bss

  
  @ DATA SECTION
	.data
	Input:	
		BCDNUM:	   .word 0x92529679	@ 8 digit packed BCD number
	Output:	
		NUMBER:    .word 0x00
		
  @ TEXT section
      .text

.globl _main


_main:
	        EOR r0, r0, r0;         @ Register r0 to hold result, initialized to 0   
	        EOR r1, r1, r1;         @ Register r1 to hold Intermediate result, initialized to 0
			
			LDR r4, =BCDNUM; 		@ Load address of the BCDNUM input
			LDR r2, [r4];           @ Load BCD number into r2
			
			MOV r3, #1;				@ Initialize r3 to 1 initially, this holds the number to multiply each nibble
			MOV r4, #10;			@ Register r4 always contains the value 10
			
loop:		AND r1, r2, #0x0F;		@ Obtain lower 4 bits by this operation
			MUL r1, r1, r3;			@ Multiply these 4 bits by the appropritate power of 10
			ADD r0, r0, r1;			@ Accumulate the result in r0
			MUL r3, r3, r4;			@ Increase the multiplicand by a factor of 10 each time
			MOV r2, r2, LSR #4;		@ Shift the number right by 4 bits to get the next nibble in lower 4 bits
			CMP r2, #0;				@ Check if all the bits have been shifted
			BNE loop;				@ Continue until all bits are read
			
			
done:       LDR r4, =NUMBER;        @ Load address of output NUMBER 
            STR r0, [r4];			@ Store the value in memory
            SWI 0x11;				@ Interrupt