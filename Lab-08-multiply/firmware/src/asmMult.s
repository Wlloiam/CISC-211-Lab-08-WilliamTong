/*** asmMult.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global a_Multiplicand,b_Multiplier,rng_Error,a_Sign,b_Sign,prod_Is_Neg,a_Abs,b_Abs,init_Product,final_Product
.type a_Multiplicand,%gnu_unique_object
.type b_Multiplier,%gnu_unique_object
.type rng_Error,%gnu_unique_object
.type a_Sign,%gnu_unique_object
.type b_Sign,%gnu_unique_object
.type prod_Is_Neg,%gnu_unique_object
.type a_Abs,%gnu_unique_object
.type b_Abs,%gnu_unique_object
.type init_Product,%gnu_unique_object
.type final_Product,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmMult gets called, you must set
 * them to 0 at the start of your code!
 */
a_Multiplicand:  .word     0  
b_Multiplier:    .word     0  
rng_Error:       .word     0  
a_Sign:          .word     0  
b_Sign:          .word     0 
prod_Is_Neg:     .word     0  
a_Abs:           .word     0  
b_Abs:           .word     0 
init_Product:    .word     0
final_Product:   .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmMult
function description:
     output = asmMult ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmMult
.type asmMult,%function
asmMult:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmMult.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 8 Multiply
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    mov r10,0			  //storing 0 in r10 to modify the outputs later
    mov r11,1			  //storing 1 in r11 to modify the outputs later
    .equ maximum_value_16bits, 32767	/**This is to check whether the input multiplicand and multiplier excced the maximum
					range of signed 16 bits**/
    .equ minimum_value_16bits, -32768	/**This is to check whether the input multiplicand and multiplier excced the minimum
					range of signed 16 bits**/
   /**Initializing all variables to 0**/
    ldr r5,=a_Multiplicand		/**storing the memory location of a_Multiplicand in r5 **/
    str r10,[r5]			/**storing 0 in meomry location of  a_Multiplicand**/
    ldr r5,=b_Multiplier		/**storing the memory location of b_Multiplier in r5 **/
    str r10,[r5]			/**storing 0 in meomry location of b_Multiplier**/
    ldr r5,=rng_Error			/**storing the memory location of rng_Error in r5 **/
    str r10,[r5]			/**storing 0 meomry location of in meomry location of rng_Error**/
    ldr r5,=a_Sign			/**storing the memory location of a_Sign in r5 **/
    str r10,[r5]			/**storing 0 meomry location of in a_Sign**/
    ldr r5,=b_Sign			/**storing the memory location of b_Sign in r5 **/
    str r10,[r5]			/**storing 0 meomry location of in b_Sign**/
    ldr r5,=prod_Is_Neg			/**storing the memory location of prod_Is_Neg in r5 **/
    str r10,[r5]			/**storing 0 meomry location of in prod_Is_Neg**/
    ldr r5,=a_Abs			/**storing the memory location of a_Abs in r5 **/
    str r10,[r5]			/**storing 0 meomry location of in a_Abs**/
    ldr r5,=b_Abs			/**storing the memory location of b_Abs in r5 **/
    str r10,[r5]			/**storing 0 meomry location of in b_Abs**/
    ldr r5,=init_Product		/**storing the memory location of init_Product in r5 **/
    str r10,[r5]			/**storing 0 meomry location of in init_Product**/
    ldr r5,=final_Product		/**storing the memory location of final_Product in r5 **/
    str r10,[r5]			/**storing 0 meomry location of in final_Product**/
    
    /**storing inputs in memory location of a_Multiplicand and b_Multiplier respectively**/
    ldr r5,=a_Multiplicand		/**storing the memory location of a_Multiplicand in r5 **/
    str r0,[r5]				/**storing input r0,multiplicand from C code, in meomry location of a_Multiplicand**/
    ldr r5,=b_Multiplier		/**storing the memory location of b_Multiplier in r5 **/
    str r1,[r5]				/**storing input r1,multiplier from C code, in meomry location of b_Multiplier**/
    
    /**This branch is to check the sign of the Multiplicand**/
    checking_a_sign:
	adds r0,r0,0			/**adding r0 to 0 and store the result in r0, and update the flags, to check the Multiplicand
					is positive or negative**/
	bmi  negative_a			/**if negative flag is set, the program will direct to the negative_a branch **/
	/** if the negative flag is not set, store 0 to a_sign and store the r0 in a_Abs**/
	ldr r5,=a_Sign			/**storing the memory location of a_Sign in r5 **/
	str r10,[r5]			/**storing 0 in memory location of a_Sign **/
	ldr r5,=a_Abs			/**storing the memory location of a_Abs in r5**/
	str r0,[r5]			/**storing input r0,multiplicand from C code, in memory location of a_Abs **/
	b checking_b_sign		/**directing to the checking_b_sign branch**/ 
    /**This branch is for the negative value of the Multiplicand**/
    negative_a:
	ldr r5,=a_Sign			/**storing the memory location of a_Sign in r5**/
	str r11,[r5]			/**storing 1 in the memory location of a_Sign**/
	mvn r6,r0			/**flipping the bits of r0, or doing 1'Complement operation of r0, and store it in r6**/
	add r6,r6,1			/**adding 1 to r6, and store the result in r6 **/
	ldr r5,=a_Abs			/**storing the memory location of a_Abs in r5**/
	str r6,[r5]			/**storing the value of r6,result of 2'complement value of Multiplicand in the
					memory location of a_Abs**/
    /**This branch is to check the sign of the Multiplier**/
    checking_b_sign:
	adds r1,r1,0			/**adding r1 to 0 and store the result in r1, and update the flags, to check the Multiplier
					is positive or negative**/
	bmi  negative_b			/**if negative flag is set, the program will direct to the negative_b branch **/
	/** if the negative flag is not set, store 0 to a_sign and store the r1 in a_Abs**/
	ldr r5,=b_Sign			/**storing the memory location of b_Sign in r5 **/
	str r10,[r5]			/**storing 0 in memory location of b_Sign **/
	ldr r5,=b_Abs			/**storing the memory location of b_Abs in r5**/
	str r1,[r5]			/**storing input r1,the Multiplier from C code, in memory location of b_Abs **/
	/**This part is to check the the product will be negative or positive. Since the multiplier is postive, the product will be
	    negative if and only if the multuplicand sign is negative. **/
	ldr r5,=a_Sign			/**storing the memory location of a_Sign in r5**/
	ldr r6,[r5]			/**storing the value of a_Sign in r6**/
	cmp r6,r11			/**comparing the value of a_Sign with r11 which value is 1 to check the sign of multuplicand**/
	beq product_negative		/**if the value of a_Sign is equal to 1,the program will direct to product_negative branch**/
	/**if the multiplicand sign is positive, or a_Sign is not equal to 1, the program will direct to the product_negative branch**/
	b mulitiplication_process	/**directing to the mulitiplication_process branch**/
    /**This branch is for the negative value of the Multiplier**/
    negative_b:
	ldr r5,=b_Sign			/**storing the memory location of b_Sign in r5**/
	str r11,[r5]			/**storing 1 in the memory location of b_Sign**/
	mvn r6,r1			/**flipping the bits of r1, or doing 1'Complement operation of r0, and store it in r6**/
	add r6,r6,1			/**adding 1 to r6, and store the result in r6 **/
	ldr r5,=b_Abs			/**storing the memory location of b_Abs in r5**/
	str r6,[r5]			/**storing the value of r6,result of 2'complement value of Multiplier in the
					memory location of b_Abs**/
	/**This part is to check the the product will be negative or positive. Since the multiplier is negative, the product will be
	   negative is if and only if the multuplicand sign is positive**/
	ldr r5,=a_Sign			/**storing the memory location of a_Sign in r5**/	
	ldr r6,[r5]			/**storing the value of a_Sign in r6**/
	cmp r6,r10			/**comparing the value of a_Sign with r10 which value is 0 to check the sign of multuplicand**/
	beq product_negative		/**if the value of a_Sign is equal to 0,the program will direct to product_negative branch**/
	/**if the multiplicand sign is negative, or a_Sign is not equal to 0, the program will direct to the product_negative branch**/
	b mulitiplication_process	/**directing to the mulitiplication_process branch**/
    
    /**This branch is for negative product, setting 1 to memory location of prod_Is_Neg**/
    product_negative:
	ldr r5,=prod_Is_Neg		/**storing the memory location of prod_Is_Neg in r5**/
	str r11,[r5]			/**storing 1 in memory location of prod_Is_Neg**/
	
    /**checking whether the inputs, Multiplicand and Multiplier, exceed the range of signed 16 bits**/
    ldr r5,=maximum_value_16bits	/**storing maximum_value_16bits in r5**/
    ldr r6,=minimum_value_16bits	/**storing minimum_value_16bits in r6**/
    cmp r0,r5				/**comparing input r0, Multiplicand, with maximum_value_16bits**/
    bgt error_case			/**if the input r0, Multiplicand, is greater than maximum_value_16bits, the program will direct
					to the error_case branch**/
    cmp r0,r6				/**comparing input r0, Multiplicand, with minimum_value_16bits**/
    blt error_case			/**if the input r0, Multiplicand, is lesser than minimum_value_16bits, the program will direct
					to the error_case branch**/
    cmp r1,r5				/**comparing input r1, Multiplier, with maximum_value_16bits**/
    bgt error_case			/**if the input r1, Multiplier, is greater than maximum_value_16bits, the program will direct
					to the error_case branch**/
    cmp r1,r6				/**comparing input r1, Multiplier, with minimum_value_16bits**/
    blt error_case			/**if the input r1, Multiplier, is lesser than minimum_value_16bits, the program will direct
					to the error_case branch**/
    
    /**This branch is to multiply the absolute values of r0 multiplicand, and r1 Multiplier. Since I use the abosult values of the multiplicand
       and Multiplier, we will get the abosulte value of the product.**/
    mulitiplication_process:
   
    mov r8,0				/**storing 0 in r8 to store absolute value of the result of the multiplication**/
    ldr r2,=a_Abs			/**storing the memory location of a_Abs in r2**/
    ldr r2,[r2]				/**storing the value of a_Abs, absolute value of multiplicand in r2**/
    ldr r3,=b_Abs			/**stroing the memory location of b_Abs in r3**/
    ldr r3,[r3]				/**storing the value of b_Abs, absolute value of multiplier in r3**/
    
    /**checking either the absolute value of multiplicand or multiplier is equal to 0, if either one is equal to 0, direct to 
       zero_store branch**/
    cmp r2,0				/**comparing the absolute value of the multiplicand with 0**/
    beq zero_store			/**if the absolute value of the multiplicand is equal to 0, the program will direct to
					zero_store branch**/
    cmp r3,0				/**comparing the absolute value of the multiplier with 0**/
    beq zero_store			/**if the absolute value of the multiplier is equal to 0, the program will direct to
					zero_store branch**/
    
    /**This branch will perform as a loop until the absolute value of the multiplier equal to 0**/
    iterate:
	cmp r3,0			/**comparing the absolute value of the multiplier with 0**/
	beq store			/**when the the absolute value of the multiplier with 0, the program will direct to the store 
					    branch to store the result of the multiplication**/
	ands r7,r3,r11			/**using logical operator AND, and update the flag to know the least siginificant bit of r3 is 0 or 1**/
	bne add				/** if the result is 1, the program will direct to the add branch**/
    /**This branch will shift the multiplier right by 1 bit and multiplicand left by 1 bit**/
    shifting:
	lsr r3,r3,1			/**using logical shift right operation to shift the multiplier right by 1 bit**/
	lsl r2,r2,1			/**using logical shift left operation to shift the multiplicand left by 1 bit**/
	b iterate			/**directing to the iterate branch**/
    /**This branch will add the abosulte value of multiplicand to r8**/
    add:
	add r8,r8,r2			/**adding r8 to the abosulte value of multiplicand, and sotre it in r8**/
	b shifting			/**directing to the shifting branch**/
    
    /**This branch is for either the absolute value of multipler or multiplicand equals to 0. If either one is equals to 0, set the 
       value of prod_Is_Neg to 0**/
    zero_store:
	ldr r5,=prod_Is_Neg		/**storing the memory location of prod_Is_Neg in r5**/
	str r10,[r5]			/**storing 0 in prod_Is_Neg**/

    /**This branch is to store the init_Product, and the result of the final product and to check the the product is negative or positive.
	if prod_Is_Neg is 1, do the 2 complement opertation to get the final value of the multiplication.**/ 
    store:
	ldr r7,=init_Product		/**storing the memory location of init_Product in r7**/
	str r8,[r7]			/**storing the absolute value of the result of the multiplication in init_Product**/ 
	ldr r5,=prod_Is_Neg		/**storing the memory location of prod_Is_Neg in r5**/
	ldr r5,[r5]			/**stroing the value of prod_Is_Neg in r5**/
	cmp r5,r11			/**comparing the value of prod_Is_Neg with r11 which is 1**/
	beq product_Is_Negative		/**if prod_Is_Neg is equal to 1, it means final product is negative, so the program will direct
					    to the product_Is_Negative branch**/
	/**If prod_Is_Neg is not equal to 1, the final prodcut is positive, and will store in the memory location of final_Product**/
	ldr r7,=final_Product		/**storing the memory location of final_Product in r7**/
	str r8,[r7]			/**storing the absoulte value of the product in memory location of final_Product**/
	mov r0,r8			/**storing the absoulte value of the product in r0**/
	b done				/**directing to the done branch**/
    /**This branch is for the negative of the product. It will do the 2s complement operation to get the negative value of the product
	and store it in final product and r0**/
    product_Is_Negative:
	mvn r8,r8			/**flipping the bits of r8, or doing 1s complement of r8, and store the result in r8**/
	add r8,r8,1			/**add the result, r8, to 1 to get the negative value of the product**/
	ldr r7,=final_Product		/**storing the memory location of the final_Product in r7**/
	str r8,[r7]			/**storing the negative value of the final product in memory location of final_Product**/
	mov r0,r8			/**storing the negative value of the final product in r0**/
	b done				/**directring to the done branch**/
    /**This branch is for either the absolute value of the multiplicand or multiplier exceed the range of signed 16 bits value. If either
	one exceed the limit, set the rng_Error to 1, and 0 to r0.**/
    error_case:
	ldr r5,=rng_Error		/**storing memory location of the rng_Error in r5**/
	str r11,[r5]			/**storing 1 in memory location of rng_Error**/
	mov r0,0			/**storing 0 in  r0**/
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmMult return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




