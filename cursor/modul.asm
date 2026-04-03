
MODUL	= $d800
PLAYER	= $c400

	org MODUL

	rmt_relocator 'music.rmt' *

	run $0600

	opt l-
	icl 'rmt_relocator.mac'