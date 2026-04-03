;VBXE CORE FX rev. 1.21+
;support file for MADS

VBASE           equ     0  ;for indirect addresing
;VBASE          equ     0xd600
;VBASE          equ     0xd700

FX_VIDEO_CONTROL equ    VBASE+0x40
FX_VC            equ    FX_VIDEO_CONTROL
VC_XDL_ENABLED  equ     1
VC_XCOLOR       equ     2
VC_NTR          equ     4
VC_NO_TRANS     equ     VC_NTR
VC_TRANS15      equ     8

; XDL Address
FX_XDL_ADR0     equ     VBASE+0x41
FX_XDL_ADR1     equ     VBASE+0x42
FX_XDL_ADR2     equ     VBASE+0x43

; Palette registers
FX_CSEL         equ     VBASE+0x44
FX_PSEL         equ     VBASE+0x45
FX_CR           equ     VBASE+0x46
FX_CG           equ     VBASE+0x47
FX_CB           equ     VBASE+0x48

; Raster collision detection
FX_COLMASK      equ     VBASE+0x49
FX_COLCLR       equ     VBASE+0x4a
FX_COLDETECT    equ     VBASE+0x4a

; XDLC bits
XDLC_TMON       equ     1
XDLC_GMON       equ     2
XDLC_OVOFF      equ     4
XDLC_MAPON      equ     8
XDLC_MAPOFF     equ     0x10
XDLC_RPTL       equ     0x20
XDLC_OVADR      equ     0x40
XDLC_OVSCRL     equ     0x80
XDLC_CHBASE     equ     0x100
XDLC_MAPADR     equ     0x200
XDLC_MAPPAR     equ     0x400
XDLC_OVATT      equ     0x800
XDLC_ATT        equ     0x800
XDLC_HR         equ     0x1000
XDLC_LR         equ     0x2000
XDLC_END        equ     0x8000

; MEMAC-A / MEMAC-B registers
FX_MEMAC_B_CONTROL equ     VBASE+0x5d
FX_MEMB            equ     FX_MEMAC_B_CONTROL
FX_MEMAC_CONTROL   equ     VBASE+0x5e
FX_MEMC            equ     FX_MEMAC_CONTROL
FX_MEMAC_BANK_SEL  equ     VBASE+0x5f
FX_MEMS            equ     FX_MEMAC_BANK_SEL

; MEMAC-A control bits (in MEMC)
MCE             equ     8
MAE             equ     4
M4K             equ     0
M8K             equ     1
M16K            equ     2
M32K            equ     3
; MEMAC-A global enable (in MEMS)
MGE             equ     $80
; MEMAC-B control bits (in MEMB)
MBCE            equ     $80
MBAE            equ     $40
; MEMAC-B fixed window address
MEMAC_B_WINDOW  equ     $4000

; Blitter registers
FX_BL_ADR0       equ   VBASE+0x50
FX_BL_ADR1       equ   VBASE+0x51
FX_BL_ADR2       equ   VBASE+0x52
FX_BLITTER_START equ   VBASE+0x53
FX_BLT_COL_CODE  equ   VBASE+0x50
FX_BLT_COLLISION_CODE equ FX_BLT_COL_CODE
FX_BLITTER_BUSY   equ   VBASE+0x53

; Blitter IRQ
FX_IRQ_CONTROL   equ   VBASE+0x54
FX_IRQ_STATUS    equ   VBASE+0x54

; Info registers (read only)
FX_CORE_VERSION   equ   VBASE+0x40
FX_MINOR_REVISION equ   VBASE+0x41

; Priority registers
FX_P0           equ     VBASE+0x55
FX_P1           equ     VBASE+0x56
FX_P2           equ     VBASE+0x57
FX_P3           equ     VBASE+0x58

FX_CORE_RESET   equ     0xD080


        .zpvar fxptr .word
        .zpvar fxysav .byte

FX_PROPER_CORE_VERSION = 0x10
FX_PROPER_MINOR_REVISION = 0x20

; fx core detection
; exit: Z=1 -> fx core 1.10 found

DetectCore .macro

        mwa     #0xd600 fxptr
        jsr     fxd
        jeq     ex
        inc     fxptr+1
        jsr     fxd
        jmp     ex
fxd     fxla    FX_CORE_VERSION
        cmp     #FX_PROPER_CORE_VERSION
        jne     nf
        fxla    FX_MINOR_REVISION
        and     #$70
        cmp     #FX_PROPER_MINOR_REVISION
nf      rts
ex

        .endm

ResetCore .macro

        ;FX core reset
        mva     #0 FX_CORE_RESET   ;reset & resync
        ;reset all fx core registers
        ldy     #0x40
r2      sta     (fxptr),y
        iny
        bpl     r2
        ;restore default palette 0
        fxsa    FX_CSEL
        fxsa    FX_PSEL
        tax
r1      lda     fx_default_palette0,x
        asl     @
        fxsa    FX_CR
        lda     fx_default_palette0+256,x
        asl     @
        fxsa    FX_CG
        lda     fx_default_palette0+512,x
        asl     @
        fxsa    FX_CB
        inx
        bne     r1
        ;clear default palette 1, 2, 3
        fxs     #1 FX_PSEL
        jsr     c0
        fxs     #2 FX_PSEL
        jsr     c0
        fxs     #3 FX_PSEL
        jsr     c0
        fxsa    FX_PSEL  ;leave PSEL=0 when done
        jmp     ex
c0      ldx     #0
        txa
c1      fxsa    FX_CR
        fxsa    FX_CG
        fxsa    FX_CB
        inx
        bne     c1
        jmp     ex

fx_default_palette0

        icl     'fxpal.asm'

ex

        .endm


; store value in fx register (via accumulator)
fxs     .macro

        lda     :1
        ldy     #:2
        sta     (fxptr),y

        .endm

; store accumulator in fx register
fxsa    .macro

        ldy     #:1
        sta     (fxptr),y

        .endm

; load fx register value to accumulator
fxla    .macro

        ldy     #:1
        lda     (fxptr),y

        .endm

; store value in fx register (via accumulator) protect y
fxsp    .macro

        sty     fxysav
        lda     :1
        ldy     #:2
        sta     (fxptr),y
        ldy     fxysav

        .endm

; store accumulator in fx register protect y
fxsap   .macro

        sty     fxysav
        ldy     #:1
        sta     (fxptr),y
        ldy     fxysav

        .endm

; load fx register value to accumulator protect y
fxlap   .macro

        sty     fxysav
        ldy     #:1
        lda     (fxptr),y
        ldy     fxysav

        .endm
