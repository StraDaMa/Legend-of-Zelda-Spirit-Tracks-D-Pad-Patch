;check if B is pressed to use sword
.rorg 0x02088960,0x02088980
bl dpad_check_attack

.rorg 0x02070128,0x02070148
stmfd r13!,r1-r7,r14
bl dpad_check_blow_mic
ldmfd r13!,r1-r7,r15
;eof
