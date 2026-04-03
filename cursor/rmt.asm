
	.ifdef	PLAYER
		icl "music.feat"
		icl 'rmtplayer.asm'
	els
		org MODUL
		rmt_relocator 'music.rmt' *
		icl 'rmt_relocator.mac'
	eif

	run $0600	; bez RUN-a Exomizer nie spakuje
