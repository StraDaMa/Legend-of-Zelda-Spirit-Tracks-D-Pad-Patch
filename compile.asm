.nds
.relativeinclude on

.include "macros.asm"

;edit the ARM9
;uncompressed sizes: 0x48DD8, 0x048DF8
.ropen "arm9/arm9.bin", "temp/arm9.bin", 0x02004000, 0x02004000
;end of ARM9 freespace
.rorg 0x02044B00, 0x02044AD0
	.area 0x288
		.include "util.asm"
		.include "movement/movement_arm9_freespace.asm"
		.include "interact/interact_arm9_freespace.asm"
		.include "attack/attack_arm9_freespace.asm"
		.pool
	.endarea
.close

;edit the overlay0000 (contains code for sword attacks)
;uncompressed sizes: 0x633E0, 0x633E0
.ropen "arm9/overlay_0000.bin", "temp/overlay_0000.bin", 0x02051AC0, 0x02051AE0
	.include "attack/attack_overlay0000.asm"
.close

;edit the overlay0017 (contains code for movement from pressing on the screen)
;uncompressed sizes: 0x8900, 0x8900
.ropen "arm9/overlay_0017.bin", "temp/overlay_0017.bin", 0x020BB640, 0x020BB660
	.include "movement/movement_overlay0017.asm"
	.include "interact/interact_overlay0017.asm"
	.include "attack/attack_overlay0017.asm"
.close

;edit the overlay0024 (contains code for pressing directions to do UI functions during gameplay)
;uncompressed sizes: 0x13E20, 0x13E20
.ropen "arm9/overlay_0024.bin", "temp/overlay_0024.bin", 0x020C4820, 0x020C4840
	.include "movement/movement_overlay0024.asm"
.close

;edit the overlay0093 (contains code for pressing directions for zelda phantom)
;uncompressed sizes: 0x134C0
.ropen "arm9/overlay_0093.bin", "temp/overlay_0093.bin", 0x02165880, 0x021658A0
	.include "movement/movement_overlay0093.asm"
.close
;eof
