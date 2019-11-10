


/******************************************************************************
* File: part1.s
* Author: Sanjana Jammi
* Roll number: CS18M522
* TA: G S Nitesh Narayana
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Assignment 5 
  PART 1 - Convert an ASCII digit(given in hex format) to hex digit
  The program gives stores the output hex digit if the input ASCII is in the valid hex digit range - works for 30h-39h (numbers 0-9), 41h-46h (A-F), 61h-66h(a-f)
  In case a number outside this range is given as input, the output is 0xFF (ERROR)
  */

  @ BSS section
      .bss

  
  @ DATA SECTION
	.data
	Input:	
		A_DIGIT:	.word 0x43	@ ASCII digit in hex format
	Output:	
		H_DIGIT:    .word 0x00
		
  @ TEXT section
      .text

.globl _main


_main:
	        EOR r0, r0, r0;         @ Register r0 to hold result, initialized to 0   
	   
			LDR r4, =A_DIGIT;       @ Load input ASCII digit
			LDR r1, [r4];           @ Storing digit in r1
	   
			CMP r1, #0x30;          @ Compare digit with 30h
			BLT error;				@ If value is less than 30h, error
	   
			CMP r1, #0x66;			@ Compare digit with 66h
			BGT error;	   	        @ If value is greater than 66h, error
	   
			CMP r1, #0x39;          @ Comparing digit with 39h
			BGT check1;             @ If value is greater than 39h, go for further checks
	   
			B extract_num;          @ Else, value is in the range 30h - 39h, extract the number


check1:    CMP r1, #0x41;          @ Comparing digit with 41h
			BLT error;              @ If value is greater than 39h and less than 41h, error
	   
			CMP r1, #0x61;          @ Else, value is greater than 41h, so compare with 61h
			BLT check2;				@ if value is less than 61h, go for further checks
			B non_numeric_digit;    @ Else, value is in the range 61h - 66h, proceed to extract the result

check2:    CMP r1, #0x46;          @ Value is in the range 41h - 61h, Comparing digit with 46h
			BGT error;				@ If value is greater than 46h, error, else it is in the range 41h - 46h, proceed to extract the result				
	   
non_numeric_digit:SUB r1, r1, #7;   @ Subtract 7 if the value is in the range 41h - 46h or 61h - 66h
	   
extract_num: AND r0, r1, #0x0F;     @ perform and operation to get the output hex digit
			 B done;	            @ complete the execution

error:      MOV r0, #0xFF;          @ if error occurred, store 0xFF

done:       LDR r4, =H_DIGIT;       @ Load output address
            STR r0, [r4];			@ Store the value in memory
            SWI 0x11;				@ Interrupt