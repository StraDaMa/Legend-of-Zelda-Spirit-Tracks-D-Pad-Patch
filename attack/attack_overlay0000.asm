;check if B is pressed to use sword
.org 0x02088960
bl dpad_check_attack

.org 0x02070128
stmfd r13!,r1-r7,r14
bl dpad_check_blow_mic
ldmfd r13!,r1-r7,r15
;eof
