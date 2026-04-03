
_txt	= $0700
_tab	= _txt+size	; obszar _tab musi wystepowac zaraz po _txt
_txt2	= $1000
_tab2	= _txt2+size	; obszar _tab2 musi wystepowac zaraz po _txt2
_free	= _tab2+height	; wolny obszar <_free..loafnt>

	org	$80

regA	.ds 1
regY	.ds 1
frm	.ds 1
inp	.ds 2
out	.ds 2
lst	.ds 2

; ---
; ---	LET'S GO
; ---
	org	putFnt

; ---
; ---	ANTIC
; ---
ant
;	dta d'ppp'
	dta $80,$40+$80+pixel
ant_adr	dta a(_txt)
	:height-1 dta $80+pixel
	dta $41,a(ant)

animation
	lda:cmp:req 20

	sei
	mva	#0	$d40e

	mva	#$fe	$d301

	mwa	#nmi	$fffa

	mva	#$c0	$d40e

	ldx	#1
	jsr	wait

;---

start	mwa	#plylst	lst

nxtpos	ldy	#0
 	mva	(lst),y	cnt

 	iny
 	mva	(lst),y	frame

repeat	ldy	#0
frame	equ	*-1
 	mva	lfrm,y	inp
 	mva	hfrm,y	inp+1

loop	lda	#0
	eor	#1
	sta	loop+1
	bne	faza2
faza1
	lda	<_tab2		; pokazuj drugi bufor
	sta	tab_adr
	sta	iy

	lda	>_tab2
	sta	tab_adr+1
	sta	iy+1

	mwa	#_txt2	ant_adr

	mwa	#_txt	out	; rysuj w pierwszym buforze
	jmp	_sh
faza2
	lda	<_tab		; pokazuj pierwszy bufor
	sta	tab_adr
	sta	iy

	lda	>_tab
	sta	tab_adr+1
	sta	iy+1

	mwa	#_txt	ant_adr
	mwa	tab_adr	iy

	mwa	#_txt2	out	; rysuj w drugim buforze

_sh	jsr	depack

gate	lda:req	#0
	mva	#0	gate+1

_skp	dec	cnt
	bne	repeat

	adw	lst #2

	ldy	#0
	lda	(lst),y
	cmp	#$ff
	seq
	jmp	nxtpos
	
	jmp	start

cnt	brk

; ---
; ---	WAIT
; ---
wait	lda	#0
clock	equ	*-1
	cmp	clock
	req
	dex
	bne	wait
	rts


; ---
; ---	NMI
; ---
nmi	bit	$d40f
	bpl	vbl

dli	sta	regA
	sty	regY

	ldy	$ffff
iy	equ	*-2
	lda	alloc,y
	sta	$d40a
	sta	$d409

	inw	iy

	lda	regA
	ldy	regY
	rti

; ---	VBL
vbl	sta	regA
	sta	$d40f

	inc	clock

	mwa	#ant	$d402

	ift	width=32
	lda #%00100001
	eli	width=40
	lda #%00100010
	els
	lda #%00100011
	eif

	sta	$d400

	ift	gtia=4
	lda #$40
	els
	lda #0
	eif

	sta	$d01b

	mva	#BAK	$d01a
	mva	#PF0	$d016
	mva	#PF1	$d017
	mva	#PF2	$d018
	mva	#PF3	$d019

	mwa	tab_adr	iy

	lda	#0
fps	equ	*-1
	cmp	#delay
	bne	vblQ

	lda	#$ff
	sta	fps
	sta	gate+1

vblQ	inc	fps

	lda	regA
	rti

tab_adr	dta a(_tab)
out_tmp	dta a(_txt)


; ---
; ---	DEPACK
; ---
depack	ldy	#0
	lda	(inp),y

	cmp	#$c0
	bcs	_sto
	cmp	#$80
	bcs	_rle
	cmp	#$40
	bcs	_inc

	inw	inp
	rts

_sto	inw	inp

	and	#$3f
	tay
	tax
_sto_l
	lda	(inp),y
	sta	(out),y
	dey
	bpl	_sto_l

	txa
	jsr	add_out
	txa
	jsr	add_inp
	jmp	depack

_inc	tax
	iny
	lda	(inp),y
	sta	tmp_

	txa
	and	#$3f
	tay
	tax

	sec
	lda	#0
tmp_	equ	*-1
_inc_l
	sta	(out),y
	sbc	#1
	dey
	bpl	_inc_l

	txa
	jsr	add_out
	lda	#1
	jsr	add_inp
	jmp	depack

_rle	tax
	iny
	lda	(inp),y
	sta	_tmp

	txa
	and	#$3f
	tay
	tax

	lda	#0
_tmp	equ	*-1
_rle_l
	sta	(out),y
	dey
	bpl	_rle_l

	txa
	jsr	add_out
	lda	#1
	jsr	add_inp
	jmp	depack

add_inp
	sec
	adc	inp
	sta	inp
	scc
	inc	inp+1
	rts

add_out
	sec
	adc	out
	sta	out
	scc
	inc	out+1
	rts


; ---
; ---	FILES
; ---
	org	loaFnt
