	device zxspectrum48

	org	$6000

	INCLUDE "..\..\Constants.asm"
	INCLUDE "..\..\Macros.asm"
	INCLUDE "..\..\TestData.asm"
	INCLUDE "..\..\TestFunctions.asm"

Start:
	call StartTest

    ; Set ULA over Layer2 over sprites, with sprites not visible.
    NEXTREG_nn SPRITE_CONTROL_NR_15, %00010100
    ; keep INK mask NR$42 at default value (should be 15 = 0..15 INK, 0..15 PAPER)
    ; this INK mask 15 for default attribute $38 = INK 8, PAPER 3
    NEXTREG_nn PALETTE_CONTROL_NR_43, 1     ; select first-ULA palette + enable ULANext
    ; palette[ULA][0][131] change (paper 3 colour to $E300)
    NEXTREG_nn PALETTE_INDEX_NR_40, 128+3   ; Change paper 3
    NEXTREG_nn PALETTE_VALUE_9BIT_NR_44, $E3
    NEXTREG_nn PALETTE_VALUE_9BIT_NR_44, $00; Set to default "pink" transparent colour.
    ; bright cyan as transparency fallback
    NEXTREG_nn TRANSPARENCY_FALLBACK_COL_NR_4A, $1F
    ; border is still 7 = offset 128+7 = should be by default white? Or is it UB?

	call FillLayer2WithTestData

	call EndTest

	savesna "CPalTrV2.sna", Start
