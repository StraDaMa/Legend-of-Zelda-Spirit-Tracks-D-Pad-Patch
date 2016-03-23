.org 0x0217600C;replace pressing left for zelda controls
ldr r0, [r0,0x00]
bl phantom_zelda_check_buttons
bne 0x0217603C
;eof
