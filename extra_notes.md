Assembled unmodified code fails to run well in Exodus emulator, even if it's
assembled with vasm, though it runs well in Kega Fusion.

clownassembler fails to assemble the unmodified code.

-----

# Debugging bit diffing

## byte at 423d (1afh) diffs

0:000001A4 00200000 24: 	dc.l RomEnd	; address of ROM end

should be:
    00000000
but is:
    01100110

whole instruction should be encoded as:
    00000000
    00100000
    00000000
    00000000

but is:
    00000000
    00100000
    00000000
    01100110 ; diffing!

suspected reason for diffing:
    In vasm a label preceeding an org gets the address that the org sets.
    Not so in fasm68k.

## ~~bytes at 558d and 559d (22eh, 22fh) diffs~~

00:0000022A 41F90000B39A 31: lea (VDPInitDataStart),a0 ; load the address of the VDP init data to a0

whole instruction should be encoded as:
    01000001
    11111001
    00000000
    00000000
    10110011
    10011010

but is:
    01000001
    11111001
    00000000
    00000000
    10101111 ; diffs!
    11011010 ; diffs!

suspected reason for diffs:
    The label VDPInitDataStart seems to be at the incorrect address.
    Likely because there are too many of two few bytes before it is defined.

## ~~missning bytes starting from 0x2C6~~

These are instructions that seem to produce no bytes at all:

002C6: 02B900000000FFFF	    23: 	and.l	#$00000000,(MEM_GLOBAL_EVENT_FLAGS)	; clear event flags
002CE: 009E
002D0: 02B900000000FFFF	    24: 	and.l	#$00000000,(MEM_DAY_EVENT_FLAGS)	; clear event flags
002D8: 00A2
002DA: 02B900000000FFFF	    25: 	and.l	#$00000000,(MEM_MISSION_EVENT_FLAGS)	; clear mission flags
002E2: 00A6
002E4: 02B900000000FFFF	    26: 	and.l	#$00000000,(MEM_SCENE_BGM)	; clear BGM
002EC: 019E

## ~~bytes at 888d and 889d (378h, 379h) diffs~~

00378: DCBC00060000    	    80: add.l #$00060000, d6 ; move to x-coordinate

This is actually due to a bug in vasm it seems. The diff does not mean fasm68k
does anything wrong.

## ~~bytes at 1074d and 1075d (432h, 433h) diffs~~

0432 C27C0666   43: and.w #%0000011001100110, d1 ; prevent color overflow

Probably and to andi vasm bug too.

## ~~bytes at 1748 and 1749 (6d4h, 6d5h) diffs~~

06D4: DE7C0118  281: add.w #$0118, d7 ; starting y-coordinate

Probably add to addi vasm bug too.

## 2 bytes at 3080 (C08h) diffs

0C08: DE7C00F8  59: add.w #$00F8, d7 ; first row is F8

## 2 bytes at 3168 (C60) diffs

0C5C 41F90011264F   20: lea StatusScreenEmptySave,a0 ; use text for empty save slot

prolly label is wrong because of too many or toow few bytes before it.

## some bytes at 3204 (C84) diffs

0C84: 9C7C0020  35: sub.w #$20,d6 ; subtract 32 to get the character index
0C88: DC7C8090  36: add.w #DIALOG_BASE_TILE_LOW+%1000000000000000,d6 ; add the base tile


-------------------

## some bytes at 1050370d (100702h) diffs


-------------------

## some bytes at 2096947d (1FFF33h) diffs

02:001FFF33 0E              	   194:     dcb.b   4, $0E
02:001FFF34 *
02:001FFF37 0D              	   195:     dcb.b   4, $0D
02:001FFF38 *
02:001FFF3B 0C              	   196:     dcb.b   4, $0C
02:001FFF3C *
02:001FFF3F 0B              	   197:     dcb.b   4, $0B