
proc	= $0400
loaFnt	= $2000

;---
	org	proc
;---

alloc	dta $d8,$dc,$e0,$e4,$e8,$ec,$f0,$f4,$f8,$c0,$c4,$c8,$cc
	dta $bc,$b8,$b4,$b0,$ac,$a8,$a4,$a0,$9c,$98,$94,$90,$8c
	dta $88,$84,$80,$7c,$78,$74,$70,$6c,$68,$64,$60,$5c,$58
	dta $54,$50,$4c,$48,$44,$40,$3c,$38,$34

putFnt
	lda:cmp:req 20

	sei
	lda	#0
	sta	$d40e
	sta	$d400
	sta	559

	mva	#$fe	$d301

	ldy	#0
put	equ	*-1
	lda	alloc,y
	sta	dst+1

	mva	>loaFnt	src+1

	ldx	#4
	ldy	#0
mov
	lda	$ff00,y
src	equ	*-2
	sta	$ff00,y
dst	equ	*-2
	iny
	bne	mov
	inc	src+1
	inc	dst+1
	dex
	bne	mov

	inc	put

	mva	#$ff	$d301
	mva	#$40	$d40e
	cli
	rts