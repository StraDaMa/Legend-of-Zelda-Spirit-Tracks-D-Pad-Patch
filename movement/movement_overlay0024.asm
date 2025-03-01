.rorg 0x020C5980, 0x020C59A0;replace pressing right for quick menu
	ldrh r0, [r0, 0x20]
	bl quickmenu_check_buttons
	rbeq 0x020C5994, 0x020C59B4

.rorg 0x020C5A04, 0x020C5A24;replace pressing down to bring map down
	ldrh r0, [r0, 0x20]
	bl quickmap_check_buttons
	rbeq 0x020C5A18, 0x020C5A38

.rorg 0x020C5B18, 0x020C5B38;replace pressing up to check status
	ldrh r0, [r0, 0x20]
	bl quickstatus_check_buttons
	rbne 0x020C5BC4, 0x020C5BE4
;eof