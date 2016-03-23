.org 0x020C5980;replace pressing right for quick menu
ldrh r0, [r0,0x20]
bl quickmenu_check_buttons
beq 0x020C5994

.org 0x020C5A04;replace pressing down to bring map down
ldrh r0, [r0,0x20]
bl quickmap_check_buttons
beq 0x020C5A18

.org 0x020C5B18;replace pressing up to check status
ldrh r0, [r0,0x20]
bl quickstatus_check_buttons
bne 0x020C5BC4
;eof
