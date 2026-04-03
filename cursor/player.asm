STEREOMODE = 1

MODUL	= $d800
PLAYER	= $c400

	icl "music.feat"

	icl 'rmtplayer.asm'

	run $0600
