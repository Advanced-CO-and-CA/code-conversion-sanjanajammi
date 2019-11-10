


/******************************************************************************
* File: part2.s
* Author: Sanjana Jammi
* Roll number: CS18M522
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Assignment 5 
  PART 2 - Convert a given eight ASCII characters to an 8-bit binary number
  If the length of string is less than 8, the program throws error. If length is greater than 8, consider only the first 8 ASCII characters given.
  If any digit other than 30h or 31h is present, throw error
  */

  @ BSS section
      .bss

  
  @ DATA SECTION
	.data
	Input:	
		STRING:	.word 0x31
				.word 0x31
				.word 0x30
				.word 0x31
				.word 0x30
				.word 0x30
				.word 0x31
				.word 0x31
				.word 0x30
	Output:	
		NUMBER: .word 0x00
		ERROR:  .word 0x00
		
	Length_string: .word(NUMBER - STRING) /4    @length of STRING
		
  @ TEXT section
      .text

.globl _main


_main:
	        EOR r0, r0, r0;         @ Register r0 to hold output number, initialized to 0  
			EOR r1, r1, r1;         @ Register r1 to hold output error, initialized to 0  			
	   
			LDR r4, =Length_string; @ Load length of string address
			LDR r2, [r4];           @ Storing string length
	   
			CMP r2, #8;             @ Compare length with 8
			BLT error;				@ If value is less than 8, error
	   
			MOV r5, #8;             @ Using r5 as a counter, store value 8
			LDR r4, =STRING;        @ Load starting address of string into register r4
			
loop:         					    @ Looping through all characters of the string
			LDR r3, [r4], #4;       @ Fetching characters one by one
			CMP r3, #0x30;          @ Compare digit with 30h
			BLT error;			    @ If value is less than 30h, throw error
	   
			CMP r3, #0x31;		    @ Compare digit with 31h
			BGT error;              @ If value is greater than 31h, throw error
	   
			AND r3, r3, #0x0F;      @ Else, value is either 30h or 31h, extract the digit 0 or 1
			MOV r0, r0, LSL #1;     @ Left shift the result r0
			ORR r0, r0, r3;         @ Perform logical OR with the obtained bit 0/1
	   
			SUBS r5, r5, #1;        @ Decrement loop counter each time
			BNE loop;				@ Continue if 0 is not reached
			BEQ done;				@ Reading input string complete, store results


error:      MOV r1, #0xFF;          @ If error occurred, store 0xFF as Error
			EOR r0, r0, r0;         @ Clear the value of number

done:       LDR r4, =NUMBER;        @ Load address of NUMBER
			STR r0, [r4];		    @ Store the value in memory
			LDR r4, =ERROR;         @ Load address of ERROR
			STR r1, [r4];			@ Store the value in memory
			SWI 0x11;				@ Interrupt