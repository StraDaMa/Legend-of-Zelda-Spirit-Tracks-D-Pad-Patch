dpad_check_interact:
	stmfd r13!, r2-r7, r14
	mov r8, r0;overwritten opcode
	sub r13, r13, 0x10

;Check A to check interactions
	bl util_get_keys_pressed
	tst r6, GBAKEY_A
	beq @@endroutine
	mov r0, r8
	add r1, r13, 0x00
	mov r2, r5
	mov r3, r6
	rbl 0x01FFD43C, 0x01FFD43C;write x,y positions to r1
	;r13 now has the x,y positions of link
	ldrh r6, [r13, 0x00]
	ldrh r7, [r13, 0x02]
	ldrh r1, [r4, 0x44];get angle youre facing

	mov r0, r8
	rbl 0x02078678, 0x02078698;gets map angle?
	add r1, r0, r1;add map angle to current angle

	asr r1, r1, 0x04
	rldr r2, 0x0203E93C, 0x0203E964;trig table
	add r2, r2, r1, lsl 0x02
	ldrsh r0, [r2, 0x02]
	ldrsh r1, [r2, 0x00]
	add r6, r6, r1, asr 0x07
	add r7, r7, r0, asr 0x07
	mov r1, 0x1
	strb r1, [r4, 0x0C]
	strh r6, [r4, 0x0E]
	strh r7, [r4, 0x10]
	; ldr r1, =0xFFFF
	; strh r1, [r4, 0x14]
	; strh r1, [r4, 0x16]
	mov r0, r4
	mov r1, 0x02
	rbl 0x02014230, 0x02014230;seems to be required for input
@@endroutine:
	add r13, r13, 0x10
	mov r0, r8
	ldrb r1, [r4, 0x0C];overwritten opcode
	ldmfd r13!, r2-r7, r15
;eof
