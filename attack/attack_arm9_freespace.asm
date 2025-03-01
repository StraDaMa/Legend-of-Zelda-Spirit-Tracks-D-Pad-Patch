dpad_check_attack:
	stmfd r13!, r5-r7, r14
	rbl 0x02088834, 0x02088854;overwritten opcode
	bl util_get_keys_pressed
	tst r6, GBAKEY_B
	movne r4, 0x02
	beq @@endroutine
	bl util_get_keys_held
	tst r6, GBAKEY_DIRECTION
	movne r4, 0x03
@@endroutine:
	ldmfd r13!, r5-r7, r15

dpad_check_spin:
	stmfd r13!, r3-r7, r14
	push r0-r2
	rbl 0x0218321C, 0x0218323C
	pop r0-r2
	bl util_get_keys_held
	ldr r7, =GBAKEY_B | DSKEY_Y
	ands r6, r6, r7
	cmp r7, r6
	moveq r3, 0x05
	streq r3, [r0, 0x58];write 5 here to do spin attack
@@endroutine:
	ldmfd r13!, r3-r7, r15

dpad_check_roll:
	stmfd r13!, r0-r7, r14
	strh r12,[r7, 0x4C];overwritten opcode
	bl util_get_keys_held
	tst r6, GBAKEY_A
	beq @@endroutine
	tstne r6, 0xF0
	orrne r12, r12, 0x02
	strneh r12, [r7, 0x4C]
	movne r0, 0x00
	strne r0, [r7, 0x1C]
	@@endroutine:
	ldmfd r13!, r0-r7, r15

dpad_check_blow_mic:
	stmfd r13!, r1-r7, r14
	ldrb r0, [r0, 0x05]
	cmp r0, 0x00
	rldrne r0, 0x020B52E0, 0x020B5300
	ldrneb r0, [r0, 0x28]
	cmp r0, 0x00
	bleq util_get_keys_held
	andeq r6, 0x01
	moveq r0, 0x5F
	muleq r0, r0, r6
	ldmfd r13!, r1-r7, r15
;eof