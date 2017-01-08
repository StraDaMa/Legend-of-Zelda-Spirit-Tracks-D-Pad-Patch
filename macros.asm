;Regions
REGION_US equ 0
REGION_EU equ 1

;KeyPad Macros
GBAKEY_A equ 1<<0;0x01
GBAKEY_B equ 1<<1;0x02
GBAKEY_SELECT equ 1<<2;0x04
GBAKEY_START equ 1<<3;0x08
GBAKEY_RIGHT equ 1<<4;0x10
GBAKEY_LEFT equ 1<<5;0x20
GBAKEY_UP equ 1<<6;0x40
GBAKEY_DOWN equ 1<<7;0x80
GBAKEY_DIRECTION equ 0xF0;
GBAKEY_R equ 1<<8;0x100
GBAKEY_L equ 1<<9;0x200
DSKEY_X equ 1<<10;0x400
DSKEY_Y equ 1<<11;0x800

;Sets the output pointer depending on the game region
.macro .rorg,us_offset,eu_offset
	.if current_region == REGION_US
		.org us_offset
	.elseif current_region == REGION_EU
		.org eu_offset
	.endif
.endmacro

;Open depending on the game region
.macro .ropen,original_file,output_file,us_offset,eu_offset
	.if current_region == REGION_US
		.open original_file,output_file,us_offset
	.elseif current_region == REGION_EU
		.open original_file,output_file,eu_offset
	.endif
.endmacro

;Branches depending on game region
.macro rbl,us_offset,eu_offset
	.if current_region == REGION_US
		bl us_offset
	.elseif current_region == REGION_EU
		bl eu_offset
	.endif
.endmacro

;Branches depending on game region
.macro rbne,us_offset,eu_offset
	.if current_region == REGION_US
		bne us_offset
	.elseif current_region == REGION_EU
		bne eu_offset
	.endif
.endmacro

;Branches depending on game region
.macro rbeq,us_offset,eu_offset
	.if current_region == REGION_US
		beq us_offset
	.elseif current_region == REGION_EU
		beq eu_offset
	.endif
.endmacro

;loads value to register depending on game region
.macro rldr,reg,us_offset,eu_offset
	.if current_region == REGION_US
		ldr reg,=us_offset
	.elseif current_region == REGION_EU
		ldr reg,=eu_offset
	.endif
.endmacro

;loads value to register depending on game region
.macro rldrne,reg,us_offset,eu_offset
	.if current_region == REGION_US
		ldrne reg,=us_offset
	.elseif current_region == REGION_EU
		ldrne reg,=eu_offset
	.endif
.endmacro

;eof
