.global read_input
.global read_input_sz
.set lr, r14

read_input:
STMFD   SP!, {R4-R8,LR}
MOV     R5, R1
MRC     p15, 0, R4,c13,c0, 3
MOV     R1, #0x10000
STR     R1, [R4,#0x80]!
LDR     R0, [R0]
SVC     0x32
ANDS    R1, R0, #0x80000000
BMI     .ret
push {r3}
ldr r3, =0x10df08
LDRD    R0, [R4,#8]
STRD    R0, [R3, #8]
LDRD	r0, [R3]
STRD	r0,	[R5]
LDR     R0, [R4,#4]
pop {r3}

@buttons init
ldr r0, =0x10df20
ldr r1, =0xFFF
str r1, [r0]

@touch init
ldr r0, =0x10df24
ldr r1, =0x2000000
str r1, [r0]

@cpad init
ldr r0, =0x10df28
ldr r1, =0x800800
str r1, [r0]

@perform mappings, skip if no buttons pressed (it can be a lot of code)
ldr r0, =0x1ec46000
ldr r1, =0xFFF
ldr r0, [r0]
cmp r0, r1
blne .swap

@buttons copy
ldr r0, =0x10df20
ldr r1, =0xFFFF
ldr r2, =0x1ec46000
ldr r3, =0x10df00
bl .copy

@touch copy
ldr r0, =0x10df24
ldr r1, =0x2000000
ldr r2, =0x10df10
ldr r3, =0x10df08
bl .copy

@cpad copy
ldr r0, =0x10df28
ldr r1, =0x800800
ldr r2, =0x10df14
ldr r3, =0x10df0c
bl .copy

.ret:
LDMFD   SP!, {R4-R8,PC}

.copy:
ldr r4, [r0]
cmp r4, r1
ldreq r4, [r2]
str r4, [r3]
mov pc, r14

@=======================================@
.swap:                                  @
@ DO NOT MODIFY R0                      @
@ R0 = Actual HID value                 @
@ R1 = Button check register            @
@ R2 = Modified HID value               @
@ R3 = Button Mask                      @
@ R4 = XOR mask                         @
@ R5 = Arguments for functions          @
@=======================================@
@ Initialization                        @
push {r14}                              @
ldr r0, =0x1ec46000                     @
ldr r2, [r0]                            @
ldr r0, [r0]                            @
@=======================================@

@====================================@
@              BUTTONS               @
@====================================@
@          Mapping syntax            @
@ ldr r3, =[button mask]             @
@ ldr r4, =[XOR mask]                @
@ bl .single for one button trigger  @
@            --- OR ---              @
@ bl .combo for multi-button trigger @
@====================================@

@ Add mappings here


@=============================@
@         TOUCHSCREEN         @
@=============================@
@ Mapping syntax              @
@ ldr r3, =[button mask]      @
@ ldr r5, =[touchscreen data] @
@ bl .touch                   @
@=============================@
ldr r4, =0x2000000            @
@=============================@

@ Add mappings here


@=================@
.tp_end:          @
ldr r1, =0x10df24 @
str r4, [r1]      @
@=================@

@========================@
@          CPAD          @
@========================@
@     Mapping syntax     @
@ ldr r3, =[button mask] @
@ ldr r5, =[cpad value]  @
@ bl .touch              @
@========================@
@    Some C-pad values   @
@ Left  = 0x000800       @
@ Right = 0x0007FF       @
@ Up    = 0x7FF000       @
@ Down  = 0x800000       @
@========================@
ldr r4, =0x800800        @
@========================@

@ Add mappings here


@=================@
ldr r1, =0x10df28 @
str r4, [r1]      @
@=================@

@============================================@
@ load our HID memory with final button data @
ldr r1, =0x10df20                            @
str r2, [r1]                                 @
@============================================@

@===========@
@ return    @
pop {pc}    @
@===========@

@====================@
@ Swapping functions @
@====================@
.single:             @
and r1, r0, r3       @
cmp r1, r3           @
eorne r2, r0, r4     @
bx r14               @
                     @
.combo:              @
and r1, r0, r3       @
cmp r1, #0           @
eoreq r2, r0, r4     @
bx r14               @
                     @
.touch:              @
and r1, r3, r0       @
cmp r1, #0           @
moveq r4, r5         @
eoreq r2, r2, r3     @
beq .tp_end          @
bxne r14             @
                     @
.cpad:               @
and r1, r3, r0       @
cmp r1, #0           @
eoreq r4, r5         @
eoreq r2, r2, r3     @
bx r14               @
@====================@

.LTORG # assembles literal pool

read_input_sz:
.4byte .-read_input

@====================@
@ DEVELOPER USE ONLY @
@====================@
.crash:
@ Use for viewing HID states via Luma3DS
ldr r6, =0x10df20
ldr r6, [r6]
ldr r7, =0x10df24
ldr r7, [r7]
ldr r8, =0x10df28
ldr r8, [r8]
bkpt #0