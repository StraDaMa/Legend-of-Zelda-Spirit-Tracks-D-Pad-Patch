.nds
.relativeinclude on

;edit the ARM9
.open "arm9_original.bin","arm9_compressed.bin", 0x02004000
.include macros.asm

;end of ARM9 freespace
.org 0x02044B00
	.area 0x288
		.include util.asm
		.include movement/movement_arm9_freespace.asm
		.include interact/interact_arm9_freespace.asm
		.include attack/attack_arm9_freespace.asm
		.pool
	.endarea
.close

;edit the overlay0000 (contains code for sword attacks)
;uncompressed size: 0x633E0
.open "overlay_0000_original.bin","overlay_0000_compressed.bin",0x02051AC0
.include attack/attack_overlay0000.asm
.close

;edit the overlay0017 (contains code for movement from pressing on the screen)
;uncompressed size: 0x8900
.open "overlay_0017_original.bin","overlay_0017_compressed.bin",0x020BB640
.include movement/movement_overlay0017.asm
.include interact/interact_overlay0017.asm
.include attack/attack_overlay0017.asm
.close

;edit the overlay0024 (contains code for pressing directions to do UI functions during gameplay)
;uncompressed size: 0x13E20
.open "overlay_0024_original.bin","overlay_0024_compressed.bin",0x020C4820
.include movement/movement_overlay0024.asm
.close

;edit the overlay0093 (contains code for pressing directions for zelda phantom)
;uncompressed size: 0x134C0
.open "overlay_0093_original.bin","overlay_0093_compressed.bin",0x02165880
.include movement/movement_overlay0093.asm
.close
;eof
