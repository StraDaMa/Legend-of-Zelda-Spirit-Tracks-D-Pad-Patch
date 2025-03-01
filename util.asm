;returns keys held in r6
util_get_keys_held:
	rldr r6, 0x0204A0F0, 0x0204A110
	ldr r6, [r6, 0xDEC]
	ldr r6, [r6, 0x120]
	bx r14
;returns keys pressed in r6
util_get_keys_pressed:
	rldr r6, 0x0204A0F0, 0x0204A110
	ldr r6, [r6, 0xDEC]
	add r6, r6, 0x100
	ldrh r6, [r6, 0x22]
	bx r14
;eof
