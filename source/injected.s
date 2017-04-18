.global read_input
.global read_input_sz
.set lr, r14

read_input:
stmfd   SP!, {R4-R8,LR}
mov     R5, R1
mrc     p15, 0, R4,c13,c0, 3
mov     R1, #0x10000
str     R1, [R4,#0x80]!
ldr     R0, [R0]
svc     0x32
ands    R1, R0, #0x80000000
bmi     .ret
push    {r3}
ldr     r3, =0x10df08
ldrd    R0, [R4,#8]
strd    R0, [R3, #8]
ldrd	  r0, [R3]
strd	  r0,	[R5]
ldr     R0, [R4,#4]
pop     {r3}

@buttons init
ldr     r0, =0x10df20
ldr     r1, =0xFFF
str     r1, [r0]

@touch init
ldr     r0, =0x10df24
ldr     r1, =0x2000000
str     r1, [r0]

@cpad init
ldr     r0, =0x10df28
ldr     r1, =0x800800
str     r1, [r0]

@perform mappings, skip if no buttons pressed (it can be a lot of code)
ldr     r0, =0x1ec46000
ldr     r1, =0xFFF
ldr     r0, [r0]
cmp     r0, r1
blne    .swap

@buttons copy
ldr     r0, =0x10df20
ldr     r1, =0xFFFF
ldr     r2, =0x1ec46000
ldr     r3, =0x10df00
bl      .copy

@touch copy
ldr     r0, =0x10df24
ldr     r1, =0x2000000
ldr     r2, =0x10df10
ldr     r3, =0x10df08
bl      .copy

@cpad copy
ldr     r0, =0x10df28
ldr     r1, =0x800800
ldr     r2, =0x10df14
ldr     r3, =0x10df0c
bl      .copy

.ret:
ldmfd   SP!, {R4-R8,PC}

.copy:
ldr     r4, [r0]
cmp     r4, r1
ldreq   r4, [r2]
str     r4, [r3]
mov     pc, r14

@=======================================@
.swap:                                  @
@ DO NOT MODIFY R0                      @
@ R0 = Actual HID value                 @
@ R1 = Button check register            @
@ R2 = Press HID Register               @
@ R3 = Unpress HID Register             @
@ R4 = Button mask                      @
@ R5 = Press mask                       @
@ R6 = Arguments for functions          @
@=======================================@
@ Initialization                        @
push    {r14}                           @
ldr     r0, =0x1ec46000                 @
ldr     r0, [r0]                        @
mov     r2, #0                          @
mov     r3, #0                          @
@=======================================@

@====================================@
@              BUTTONS               @
@====================================@
@          Mapping syntax            @
@ ldr r4, =[button mask]             @
@ ldr r5, =[press mask]              @
@ bl .button                         @
@====================================@

@ Add mappings here

@=============================@
@         TOUCHSCREEN         @
@=============================@
@ Mapping syntax              @
@ ldr r4, =[button mask]      @
@ ldr r6, =[touchscreen data] @
@ bl .touch                   @
@=============================@
ldr     r5, =0x2000000        @
@=============================@

@ Add mappings here

@=================@
.tp_end:          @
ldr r1, =0x10df24 @
str r5, [r1]      @
@=================@

@========================@
@          CPAD          @
@========================@
@     Mapping syntax     @
@ ldr r4, =[button mask] @
@ ldr r6, =[cpad value]  @
@ bl .cpad               @
@========================@
@    Some C-pad values   @
@ Left  = 0x000800       @
@ Right = 0x0007FF       @
@ Up    = 0x7FF000       @
@ Down  = 0x800000       @
@========================@
ldr     r5, =0x80080     @
@========================@

@ Add mappings here

@=====================@
ldr     r1, =0x10df28 @
str     r5, [r1]      @
@=====================@

@============================================@
@ load our HID memory with final button data @
ldr     r1, =0x10df20                        @
orr     r0, r0, r3                           @
orr     r0, r0, r2                           @
sub     r0, r0, r2                           @
str     r0, [r1]                             @
@============================================@

@============@
@ return     @
pop     {pc} @
@============@

@====================@
@ Swapping functions @
@====================@
.button:             @
and     r1, r0, r4   @ Extract button values
cmp     r1, #0       @ Check if all buttons are pressed
orreq   r2, r2, r5   @ If so, add press register to + HID
orreq   r3, r3, r4   @ And add button mask to - HID to unpress trigger buttons
bx      r14          @
                     @
.touch:              @
and     r1, r4, r0   @ Extract buttons
cmp     r1, #0       @ Check if all buttons are pressed
moveq   r5, r6       @ Move touchscreen data to register
orreq   r3, r3, r4   @ Un-press buttons
beq     .tp_end      @
bxne    r14          @
                     @
.cpad:               @
and     r1, r4, r0   @ Extract buttons
cmp     r1, #0       @ Check if all buttons are pressed
eoreq   r5, r7       @ Move c-pad data to register
orreq   r3, r3, r4   @ Un-press buttons
bx      r14          @
@====================@

.LTORG # assembles literal pool

read_input_sz:
.4byte .-read_input

@====================@
@ DEVELOPER USE ONLY @
@====================@
.crash:
@ Use for viewing HID states via Luma3DS
ldr     r6, =0x10df20
ldr     r6, [r6]
ldr     r7, =0x10df24
ldr     r7, [r7]
ldr     r8, =0x10df28
ldr     r8, [r8]
bkpt    #0
