dpad_movement:
stmfd r13!,r0-r7,r14
bl util_get_keys_held
tst r6,GBAKEY_SELECT
;If select is pressed no movement
bne @@endroutine
ands r1,r6,0xF0
mov r3,0x07*0x04;7 entries 2*2 bytes each
ldr r2, =@@dpad_movement_angle_pool
@@key_lookup_start:
ldrh r5, [r2,r3]
cmp r5,r1
beq @@keyfound
subs r3,0x04
bge @@key_lookup_start
b @@endroutine
@@keyfound:
mov r0,0x5F0000
tst r6,DSKEY_Y
movne r0,0x060000
str r0, [r4,0x3C]
add r3,0x02
ldrh r1, [r2,r3];get angle for direction

mov r0,r8
bl 0x02078678;gets map angle?
add r1,r0,r1

strh r1, [r4,0x44]
mov r2,0x00
strh r2, [r4,0x40]
strh r2, [r4,0x5C]
strh r1, [r4,0x46]
ldmfd r13!,r0-r7,r15
@@endroutine:
bl 0x02096AD4;opcode being overwritten
@@end2:
ldmfd r13!,r0-r7,r15

@@dpad_movement_angle_pool:
.halfword (GBAKEY_UP),0x8000;up
.halfword (GBAKEY_DOWN),0x0000;down
.halfword (GBAKEY_LEFT),0xC000;left
.halfword (GBAKEY_RIGHT),0x4000;right
.halfword (GBAKEY_UP | GBAKEY_RIGHT),0x6000;upright
.halfword (GBAKEY_DOWN | GBAKEY_RIGHT),0x2000;downright
.halfword (GBAKEY_UP | GBAKEY_LEFT),0xA000;upleft
.halfword (GBAKEY_DOWN | GBAKEY_LEFT),0xE000;downleft

quickmenu_check_buttons:
ands r0,r0,GBAKEY_RIGHT|GBAKEY_SELECT
cmp r0,GBAKEY_RIGHT|GBAKEY_SELECT
mov r15,r14

quickmap_check_buttons:
ands r0,r0,GBAKEY_DOWN|GBAKEY_SELECT
cmp r0,GBAKEY_DOWN|GBAKEY_SELECT
mov r15,r14

quickstatus_check_buttons:
ands r0,r0,GBAKEY_UP|GBAKEY_SELECT
cmp r0,GBAKEY_UP|GBAKEY_SELECT
mov r15,r14

phantom_zelda_check_buttons:
ldr r1,=(GBAKEY_LEFT<<0x10)|(GBAKEY_SELECT)
ands r0,r0,r1
cmp r0,r1
mov r15,r14

;eof