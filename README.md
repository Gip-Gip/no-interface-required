# No Interface Required (NIR)

This is the GitHub page for the esoteric programming language and compiler, No Interface Required (NIR for short, pronounced near). Inspired by another esoteric language, Brainfuck, the goals for NIR are simple: make the smallest possible compiler that is turing-complete (for the Altair 8080).

***The Commands***

These are the ten commands that NIR describes:

 CHARACTER | FUNCTION 
---|---
 / | sets the pointer to the address 0 
 * | sets the value at the pointer to 0 
 > | increment the pointer 
 + | increment the value at the pointer 
 < | decrement the pointer 
 - | decrement the value at the pointer 
 ? | jump to the last return point if the pointer is not zero 
 ! | jump to the last return point if the pointer is zero 
 @ | return mark
&#124; | end of code 

***Assembling The Code***

For those looking for a working 8080 assembler, here's a project on GitHub you can check out: [https://github.com/dolgarev/asm8080](https://github.com/dolgarev/asm8080)
