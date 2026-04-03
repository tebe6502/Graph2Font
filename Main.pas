
(*----------------------------------------------------------------------------*)
(*  Graph2Font by Tomasz Biela (Tebe/Madteam)                                 *)
(*  last changes: 2026-01-04                                                  *)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
(* SelectMode musi odwolywac sie do konkretnych trybow, aby byla mozliwosc    *)
(* w przyszlosci poprawienia go bez potrzeby poprawiania wszystkich odwolan   *)
(* np. t_mode(SelectMode.Itemindex)=m_gedp                                    *)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
(* Program rastra dla GED koniecznie najpierw musi inicjowaæ rejestry         *)
(* lda #0\ ldx #0\ ldy #0                                                     *)
(* inaczej widaæ zmiany koloru na prawej krawedzi obrazu                      *)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
(* aby mozna bylo skalowac dla innych DPI                                     *)
(* koniecznie uzywaæ czcionek TTF np. Arial                                   *)
(* wlasciwosc form SCALED=FALSE                                               *)
(* pozwolic dziedziczyc wlasciwosci, nie wymuszac czcionki przy CREATE        *)
(* PixelFormat koniecznie przed Width, Height (SetSize)                       *)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
(* mozna calkowicie wylaczyc zapis plikow UNDO dodajac do pliku INI           *)
(* [UndoRedo]                                                                 *)
(* enabled=false                                                              *)
(*----------------------------------------------------------------------------*)


// DLI+ zadzia³a gdy usuniemy ostatnie STA WSYNC sprzed DLINEW


unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Buttons, Menus, ExtCtrls, ComCtrls, ToolWin, ImgList,
  IniFiles, ZlibEx, ExtDlgs, GifImg, PngImage, JPEG, ShlObj, Clipbrd,
  ActnList, StdActns, ShellApi, BMDSpinEdit, Math, TB2Item, TB2Dock, TB2Toolbar,
  SpTBXItem, SpTBXMDIMRU, g2futils, System.Actions, System.ImageList, System.Types,
  System.AnsiStrings;

type
  tCharCompres = (ccNul, ccStandard, ccOptymizing, ccJgp1, ccJgp2);

  tLayers = (LayerALL, LayerBMP, LayerPMG);

  tGradientType = (gtLinear, gtReflected, gtDiamond, gtRadial);

  tdrawMode = (zero=0, nul=-1, Select=1, FDraw=2, Line=3, Dropper=4, Rec=5,
               Fill=7, RRec=9, Lines=10, Spray=11, SPaste=12, Tekst=13, BezierLine=14,
               RColor=15, Elipse=16, SelectAlign=17, FShape=20, Bezier=21,
               TekstAtari=22 );

  t_Forms = (f_Special=0, f_Main=1, f_Zoom=2, f_PaletteOptions=3, f_SelectColor=4, f_EditColors=5, f_EditCharset=6,
            f_Move=7, f_EditPMG=8, f_Bmp2Pmg=9, f_CharsFill=10, f_Check=11, f_EditRasters=12, f_About=13,
            f_ExportAs=14, f_SelectFolder=15, f_EditPalette=16, f_SelectValue=17, f_EditColorsMap=18,
            {f_SelectVBXEColor=19,} f_LoadScreens=21, f_EditBMP=24, f_ImportBMP=25);

  t_mode = (m_gedp, m_dli, m_gedm, m_pgr, m_piccolo);

  t_gtia = (gr9, gr10, gr11, no_gtia);

  t_video = (vgtia, vbxe);

  t_preview = ( ___PMG, ___BMP, ___ALL);

  t_pis = array [0..1] of byte;

  type_old_zestaw= array [0..8,0..8] of record
                                          inv: Boolean;
                                         inv2: Boolean;
                                           tb: array [0..7] of byte;
                                        end;

{  tRBG=class(tRadioGroup)
  protected
    procedure Paint; Override;
  end;
}

  TMyRG = class(TRadioGroup);
  TRadioGroup = class(TMyRG)
    public xCaption : string;
    protected procedure WndProc(var msg : TMessage); override;
  end;

  TForm1 = class(TForm)
    Image1: TImage;
    Image3: TImage;
    Image6: TImage;
    Image4: TImage;
    Shape1: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape2: TShape;
    ToolBar1: TToolBar;
    tbSaveData: TToolButton;
    tbSaveASM: TToolButton;
    ImageList1: TImageList;
    tbShowChars: TToolButton;
    tbEditColors: TToolButton;
    tbEditPMG: TToolButton;
    tbZoom: TToolButton;
    Timer1: TTimer;
    Timer2: TTimer;
    PopupMenu1: TPopupMenu;
    Next1: TMenuItem;
    Previous1: TMenuItem;
    tbShowColorsMap: TToolButton;
    Timer3: TTimer;
    tbSwap: TToolButton;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Image2: TImage;
    PopupMenu2: TPopupMenu;
    FillUp1: TMenuItem;
    FillDown1: TMenuItem;
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditDelete1: TEditDelete;
    EditSelectNone1: TAction;
    ImageList2: TImageList;
    EditUndo1: TAction;
    EditRedo1: TAction;
    SelectScreen: TRadioGroup;
    SelectPixel: TRadioGroup;
    SelectMode: TRadioGroup;
    SelectPreview: TRadioGroup;
    SelectVideo: TRadioGroup;
    EditCut1: TAction;
    Shape5: TShape;
    Image5: TImage;
    SelectGTIA: TRadioGroup;
    tbEditPalette: TToolButton;
    tbEditRasters: TToolButton;
    tbEditCharset: TToolButton;
    EditRasters: TAction;
    ShowChars1: TAction;
    EditColors: TAction;
    EditColorsMap: TAction;
    ShowColorsMap1: TAction;
    EditCharset: TAction;
    SaveData1: TAction;
    SaveASM1: TAction;
    EditPalette: TAction;
    EditPMG: TAction;
    EditBitmap: TAction;
    Zoom: TAction;
    Swap1: TAction;
    Check1: TAction;
    tbEditBitmap: TToolButton;
    ImageList3: TImageList;
    Image7: TImage;
    GridImage: TImage;
    SpTBXDock1: TSpTBXDock;
    SpTBXToolbar1: TSpTBXToolbar;
    MenuHotKeys: TTBSubmenuItem;
    bmp1: TTBItem;
    g2f2: TTBItem;
    mic3: TTBItem;
    col5: TTBItem;
    xex1: TTBItem;
    pmg6: TTBItem;
    jgp7: TTBItem;
    zom1: TTBItem;
    preview1: TTBItem;
    MenuFile: TTBSubmenuItem;
    New1: TTBItem;
    Load1: TTBItem;
    Save1: TTBItem;
    SaveAs1: TTBItem;
    CloseScreen: TTBItem;
    N7: TTBSeparatorItem;
    Exoirtas1: TTBItem;
    Koniec1: TTBItem;
    MenuEdit: TTBSubmenuItem;
    Undo1: TTBItem;
    Redo1: TTBItem;
    N5: TTBSeparatorItem;
    Cut1: TTBItem;
    Copy1: TTBItem;
    Paste1: TTBItem;
    Delete1: TTBItem;
    SelectAll1: TTBItem;
    SelectNone1: TTBItem;
    N1: TTBSeparatorItem;
    EBitmap: TTBItem;
    EColors: TTBItem;
    EPalette: TTBItem;
    EColorsMap: TTBItem;
    EPMG: TTBItem;
    ECharset: TTBItem;
    ERasters: TTBItem;
    MenuOptions: TTBSubmenuItem;
    Normal1: TTBItem;
    JGP1: TTBItem;
    JGP2: TTBSubmenuItem;
    Charsetx2: TTBItem;
    Charsetx3: TTBItem;
    Charsetx4: TTBItem;
    Charsetx5: TTBItem;
    Charsetx6: TTBItem;
    Charsetx7: TTBItem;
    Charsetx8: TTBItem;
    N2: TTBSeparatorItem;
    Optymizing1: TTBItem;
    BMPLimitations1: TTBItem;
    N8: TTBSeparatorItem;
    oCheck: TTBItem;
    Charsfill1: TTBItem;
    oChars: TTBItem;
    oColorsMap: TTBItem;
    MenuScreen: TTBSubmenuItem;
    RotateRight: TTBItem;
    RotateLeft: TTBItem;
    VerticalFlip: TTBItem;
    HorizontalFlip: TTBItem;
    NegativeImage: TTBItem;
    N6: TTBSeparatorItem;
    ConverttoGrayscale1: TTBItem;
    BMP2ATASCII1: TTBItem;
    BMP2PMG: TTBItem;
    N9: TTBSeparatorItem;
    ChangeColors: TTBItem;
    ChangePMG: TTBItem;
    MoveCopyPaste: TTBItem;
    N4: TTBSeparatorItem;
    Info: TTBItem;
    MenuView: TTBSubmenuItem;
    Palette1: TTBItem;
    MenuSpecial: TTBItem;
    MenuAbout: TTBItem;
    Bevel1: TBevel;
    RecentFile: TSpTBXMRUListItem;
    reopen: TTBSubmenuItem;
    TBSeparatorItem1: TTBSeparatorItem;
    ClearRecent: TAction;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    SpTBXItem1: TSpTBXItem;
    TBSeparatorItem2: TTBSeparatorItem;
    ImageList4: TImageList;
    Information: TAction;
    HalSizeV: TTBItem;
    NegativeAct: TAction;
    HalfSizeVertically: TAction;
    procedure FormCreate(Sender: TObject);
    procedure SelectScreenClick(Sender: TObject);
    procedure SelectPixelClick(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure Optymizing1Click(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure Charsfill1Click(Sender: TObject);
    procedure CloseScreenClick(Sender: TObject);
    procedure NegativeImageClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure SelectPreviewClick(Sender: TObject);
    procedure SaveG2F1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ChangeColorsClick(Sender: TObject);
    procedure MoveCopyPasteClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ChangePMGClick(Sender: TObject);
    procedure SaveXEX1Click(Sender: TObject);
    procedure SaveMIC1Click(Sender: TObject);
    procedure SelectModeClick(Sender: TObject);
    procedure OdswiezObraz;
    function  TestRaster(const _x,_y,pas:integer; const q:byte): byte;
    procedure MoveX;
    procedure MoveY;
    procedure SaveAs1Click(Sender: TObject);
    procedure bmp1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure GetPikselMode(const x,y:integer;CP:byte);
    procedure Koniec1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PokazCharset;
    procedure showMIC(sb: Boolean = true);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseDown;
    function Fnt(const wx:integer):cardinal;
    function Test(const v:cardinal; const wx:integer; var znak:byte; const charset: byte): byte;
    procedure ZnakCheck(const cc: tCharCompres);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure ZapiszUndo;
    procedure Cnv;
    procedure ZamienGrafike;
    procedure SaveChanges;
    procedure New1Click(Sender: TObject);
    procedure PutChar(const a: byte);
    function  Hex(const a,b: integer): AnsiString;
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure fCRC(var crc_:cardinal; const v:byte);
    function LiczCRCRaster(const y: integer):cardinal;
    procedure DepackRES(const a,b:string);
    procedure ShowChars(const min,max:byte; const yes:Boolean);
    function StatusXY(x: integer; const y, g:integer): string;
    function Bajt_Obrazu(const hlp:byte; const x:integer; p:byte):byte;
    function Str2Float(const a: string): real;
    function  Float2Str(a: real): string;
    procedure Rysuj(var P: PRGBQuad; const x:integer; const Value:TColor);
    procedure Scan_Pixel(P: PRGBQuad; const x:integer; const Value:TColor);
    procedure Ustaw_Button2_7(var i,j: integer);
    procedure Ustaw_Button4_5(const s,d,i,j: integer);
    procedure Usun_Zaznaczenia(const a: Boolean);
    procedure Sprawdz_Zaznaczenia(var i,j:integer);
    procedure UstawKolory;
    procedure set_pm_colors;
    procedure set_pf_colors;
    procedure Zamknij(const f: t_Forms);
    procedure Timer1Timer(Sender: TObject);
    procedure Shape9Enable(const a: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure ZaznaczAktualnyZnak(const x,y: byte);
    procedure kafelek(const przepisz: Boolean);
    procedure PrzepiszShape9NaZnaki;
    procedure create_yellow_cursor;
    function Sofs(const x: byte; const y: integer): integer;
    procedure JGP1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function  CharsFill: string;
    procedure Depack_Zlib(fn, dst: string);
    procedure Pack_Zlib(fn, dst: string);
    procedure Label7Click(Sender: TObject);
    function testPixel(x:integer; const c,s,p,pm:byte): TColor;
    function testPixel2(const pmx:integer; const s,v: byte; const y:integer): TColor;
    procedure BMP2PMGClick(Sender: TObject);
    procedure Palette1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure czytaj_vsc;
    procedure SaveAsmDLI;
    function reg_label(w: integer): AnsiString;
    function ObliczPiorytet(const px: integer): byte;
    procedure RemoveUnusedPMGByte;
    procedure PasteClick(Sender: TObject);
    procedure Next1Click(Sender: TObject);
    procedure Previous1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Charsetx2Click(Sender: TObject);
    function  locate(const v:byte; const x: integer): byte;
    procedure SelectVideoClick(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    function  nazwa: string;
    procedure Exoirtas1Click(Sender: TObject);
    procedure pliki_danych(nam: string);
    procedure SaveASM_Routine;
    procedure Execute(const _file, _direc, _param: string; const show: Boolean);
    function  GetUndoName(const a: string): string;
    procedure Image6MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure CustomMessage(const zm: string; const info: PWideChar);
    procedure ClickPreviewBMP;
    procedure ClearAll;
    procedure MenuSpecialClick(Sender: TObject);
    function SpecialVal(const a, value: integer): Boolean;
    procedure save_zerop_variables;
    procedure NewFormPos(const a: string; const t,l: integer);
    procedure SetFormPos(const a: string; var t,l: integer);
    procedure screen32Click(Sender: TObject);
    procedure screen40Click(Sender: TObject);
    procedure screen48Click(Sender: TObject);
    procedure GTIA1Click(Sender: TObject);
    procedure VBXE1Click(Sender: TObject);
    procedure Preview_PMGClick(Sender: TObject);
    procedure Preview_BMPClick(Sender: TObject);
    procedure Preview_ALLClick(Sender: TObject);
    procedure PutDraw(const x,y: integer);
    procedure Select_OFF(const a: Boolean);
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure Shape3_4Enable(const a: Boolean);
    procedure PreviewButton;
    function snazwa: string;
    procedure ReadUndoStream(var lStream: TMemoryStream);
    procedure WriteUndoStream(var lStream: TMemoryStream);
    procedure print(var bmp: TBitmap; const b: byte; const row, column: integer; const _xor: byte);
    procedure UstawMemo;
    procedure VerticalFlipClick(Sender: TObject);
    procedure RotateRightClick(Sender: TObject);
    function gr9col(const c,i: byte; const typ:t_gtia): byte;
    procedure PobierzPalete(const x,y: integer);
    procedure BMPLimitations1Click(Sender: TObject);
    procedure FillUp1Click(Sender: TObject);
    procedure FillDown1Click(Sender: TObject);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure StatusBar1MouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure StatusBar1MouseLeave(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditSelectNone1Execute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure EditDelete1Execute(Sender: TObject);
    procedure preview1Click(Sender: TObject);
    procedure EditCut1Execute(Sender: TObject);
    procedure optymizing(maks: integer; nr: byte; reset: Boolean = true);
    procedure Save1Click(Sender: TObject);
    procedure Image3MouseEnter(Sender: TObject);
    procedure Image3MouseLeave(Sender: TObject);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image5Click(Sender: TObject);
    procedure Image5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SelectGTIAClick(Sender: TObject);
    function SetGTIAValue(const g: byte): byte;
    procedure ClrTable;
    procedure ConverttoGrayscale1Click(Sender: TObject);
    procedure ctrlv1Click(Sender: TObject);
    function registry_label(const w: integer): AnsiString;
    function TestRasterPrior(const x,y: integer): byte;
    function tgtia2PenColor(const a: byte): byte;
    procedure GetChars;
    procedure PutChars;
    procedure SaveChange(const pr:byte);
    procedure EditRastersExecute(Sender: TObject);
    procedure ShowChars1Execute(Sender: TObject);
    procedure EditColorsExecute(Sender: TObject);
    procedure EditColorsMapExecute(Sender: TObject);
    procedure ShowColorsMap1Execute(Sender: TObject);
    procedure EditCharsetExecute(Sender: TObject);
    procedure SaveData1Execute(Sender: TObject);
    procedure SaveASM1Execute(Sender: TObject);
    procedure EditPaletteExecute(Sender: TObject);
    procedure EditBitmapExecute(Sender: TObject);
    procedure EditPMGExecute(Sender: TObject);
    procedure ZoomExecute(Sender: TObject);
    procedure Swap1Execute(Sender: TObject);
    function GetScanRatio(const y: byte): byte;
    procedure Check1Execute(Sender: TObject);
    procedure BMP2ATASCII1Click(Sender: TObject);
    procedure StatusPreview;
    procedure Image4ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ClrShape9;
    procedure EditDelete1Update(Sender: TObject);
    procedure DeletePMG(const a,lf,s: integer);
    procedure SaveHCol;
    function RasterDisabled(const y: integer): Boolean;
    procedure Image7MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image7Click(Sender: TObject);
    function GetPixel(aBitmap: TBitmap; const X, Y: Integer): TColor;
    procedure SetPixel(aBitmap: TBitmap; const X, Y: Integer; const Value: TColor);
    procedure ClrRect(var bmp: TBitmap; const cl: TColor = clBtnFace; const ofs: integer = 0);
    procedure ClrRectImage(var img: TImage; const cl: TColor);
    procedure DisableDrawMode;
    procedure FormDestroy(Sender: TObject);
    procedure RecentFileClick(Sender: TObject; const Filename: String);
    procedure FormKeyDown(var MousePos: TPoint);
    procedure ClearRecentExecute(Sender: TObject);
    procedure InitShape3_4;
    procedure InfoClick(Sender: TObject);
    procedure SavePasFull;
    procedure SavePMG_PAS;
    procedure SavePMG_ASM;
    procedure HalSizeVClick(Sender: TObject);

  private
    { Private declarations }

    FOldClipViewHwnd: HWND;

    procedure TestKeyDown(Var Msg:TMsg;var Handled:Boolean);

  protected

    procedure WMDrawClipboard(var Msg: TWMDrawClipBoard);
      message WM_DRAWCLIPBOARD;
    procedure WMChangeCBChain(var Msg: TWMChangeCBChain);
      message WM_CHANGECBCHAIN;

  end;

type
  tablica_font   = array [0..1023] of byte;
  tablica_fontow = array [0..128*1024] of byte;
  tablica_sprite = array [-32..290] of byte;
  tablica_obrazu = array [0..256*48] of byte;
  tablica_znakow = array [0..40*48] of byte;
  tablica_row    = array [0..30] of byte;
  trow           = array [0..47] of byte;

  tab_tcol256    = array [0..255] of TColor;
  tab_bool256    = array [0..255] of Boolean;
  tab_byte256    = array [0..255] of byte;
  tab_word256    = array [0..255] of word;
  tab_int256     = array [0..255] of integer;
  tab_card256    = array [0..255] of cardinal;
  tab_byte2K     = array [0..$800] of byte;

  tCloseApp      = array [0..31] of record
                                     app, par:Boolean;
                                    end;

  type_RasterLine= array [-1..512+32] of record
                                      kolor: array [0..15] of byte;
                                      p0s, p1s, p2s, p3s: byte;
                                      m0s, m1s, m2s, m3s: byte;
                                      p0x, p1x, p2x, p3x: byte;
                                      m0x, m1x, m2x, m3x: byte;
                                      gtia: byte;
                                     end;


  tPunkt         = record
                    x,y : real;
                   end;

  tRaster        = record
                    cod, arg: byte;
                   end;

  tARaster       = array [0..27] of tRaster;

  type_check     = record
                    lin: byte;
                    nam: string [16];
                   end;

  bmp_check      = record
                    col:array [0..5] of Boolean;
                   end;

  __upal         = record
                    ata: byte;
                    old: byte;
                   end;

  color_map      = record
                    i: byte;
                    c: array [0..3] of smallint;
                    status: byte;
                   end;

  tBGRAPixel     = record
                    red, green, blue, alpha: byte;
                   end;

  tPointF        = record x,y: single; end;

  tYUV           = record
                    y,u,v: double;
                   end;

  PPixelRec = ^TPixelRec;
  TPixelRec = record
               B: Byte;
               G: Byte;
               R: Byte;
               A: Byte;
              end;

var
// kompilator zawsze zeruje globalne zmienne
  Form1: TForm1;

  lastDraw: TRect;

  swap_filename: array [0..1] of record
                                   txt, sav: string;
                                end;


  tInfo: array [1..16] of string;

  keyMove: word;

  crcRasterDefault: cardinal;

  ShiftCtrl: Boolean;

  mrugaj_duchami: Boolean = false;

  zpRaster, c4Raster: tab_int256;

  SelectArea: record
               Left, Top, Width, Height: integer;
              end;

  pozX, pozY, mnemo, undo_index, undo_index_max, BMP_used, color_nr, color_vbl: integer;
  InvOld, wsync, edX, edY, edX_old,  edY_old, posx_nr, offset_ants: integer;
  curT, curL, hig, size_nr, TekstWidth, TekstHeight: integer;
  tmp1, tmp2, old_m, px, py: integer;
  fnt_len, scr_len, ant_len, znak_X, znak_Y, Ofset: integer;

  drawMode, oldBmpTool: tdrawMode;
  drawMode_old: tdrawMode = nul;

  raster_ofset: integer = -5;
  AddCycle    : integer = 24;
  Cycle       : integer = 60;
  LimitCycle  : integer = 60;
  RLimitInst  : integer = 12;

  Wysokosc    : integer = 240;
  Szerokosc   : integer = 384; // ostroznie uzywac w innych procedurach
                               // bo wiekszosc operuje na ekranie szerokim = 384

  crX, crY, crXold, crYold: word;

  points: array [0..2] of TPoint;

  ini_zom: record
            layer: tLayers;
            g,c,p: Boolean;
            w,h,t,l,hs,vs: integer;
            f: byte;
            s: TWindowState;
           end =
           (layer:LayerALL;
           g:false; c:false; p:false;
           w:0; h:0; t:0; l:0; hs:0; vs:0;
           f:4;
           s:wsNormal);

  prev           : t_preview = ___ALL;

  CzarnyPas, PalOfset, zestaw, pik: byte;
  inv, charset, pmg_div, PrawyPrzycisk: byte;
  AktywnyKolor, dli_nr, filSpr, Prior, gtia: byte;
  newChar, oldChar, tryb, gate, done: byte;
  AktualnaWartoscPixla, GrabPMG: byte;

  fade_special_char : byte = 127;
  
  JGPplusCharset : byte = 2;
  pal_b          : byte = 0;
  pal_w          : byte = 240;
  pal_s          : byte = 100;
  pal_c          : byte = 30;
  yel_wid        : byte = 1;
  yel_hig        : byte = 1;
  AktywnyRaster  : byte = 1;
  PenS           : byte = 1;
  Pixel          : byte = 2;
  Bajt           : byte = 48;
  min_znakow     : byte = 0;
  ile_znakow     : byte = 127;
  AktLine        : byte = 255;
  charset_old    : byte = 255;
  Prior_old      : byte = 255;
  row_limit      : byte = 255;

  edit, editDraw, klikEdit, pupa, getCol, BlokujDraw, AsmError, undo_redo: Boolean;
  resetujFonty, oldGfx_use, hscrol, fox1: Boolean;

  asm_slideshow: Boolean = false;
  showCharset  : Boolean = false;
  BlokadaRastra: Boolean = false;
  psRight      : Boolean = false;
  first_save   : Boolean = false;

  mbRightUse   : Boolean = false;

  Ustaw        : Boolean = false;
  pal_extr     : Boolean = true;
  MLCpmg       : Boolean = false;   // multicolor PMG
  SaveAfterExit: Boolean = false;
  Blokada      : Boolean = false;
  ply5         : Boolean = true;    // Player 4
  eol_         : Boolean = true;
  PoprawBMP    : Boolean = true;
  UseChar      : Boolean = true;

  path, mapa_path, current_filename, palette_path, charset_path, edit2text: string;
  mads_path, exomizer_path, edit3text, edit4text, edit8text: string;

  edit5text: string = 'a000';
  edit6text: string = '9000';
  edit7text: string = '8000';

  mapa_plik : string = '';
  pomoc_mapa: string = '';

  dane, fvsc, fhtab, fhscr, fhinv: integer;

  zomek, img1, draw, atasciiChar, wycinek, bmpChar, bmpPal: TBitmap;

  bmpPen: TBitmap;

  MyPen  : TPen;
  lb     : TLogBrush;

  penStyle: integer = PS_GEOMETRIC or PS_ENDCAP_ROUND or PS_SOLID;

  ptOrigin, ptMove, pSel, pDraw, lDraw, movePix, mOfset, drawSelect, labColor: TPoint;
  pMark, pPat, lMark, psOriginal, psOriginal2, cur, curShp, old_bmpzoom: TPoint;
  linia, zomek_linia, zomek2_linia: PRGBQuad;

  pal: array [0..41] of TColor = (
// paleta dla 16 odcieni szarosci                  // 00
   $00000000,$00101010,$00202020,$00303030,
   $00404040,$00505050,$00606060,$00707070,
   $00808080,$00909090,$00a0a0a0,$00b0b0b0,
   $00c0c0c0,$00d0d0d0,$00e0e0e0,$00f0f0f0,

// paleta dla 4 kolorow
   $00000000,$00404040,$00808080,$00c0c0c0,        // 16

// paleta dla 2 kolorow
   $00000000,$00f0f0f0,                            // 20

// paleta dla 4 kolorow z 5-tym kolorem
   $00000000,$00404040,$00808080,$00f0f0f0,        // 22

// paleta dla 5 kolorow  do edycji
   $00000000,$00404040,$00808080,$00c0c0c0,        // 26
   $00f0f0f0,$00000000,$00000000,$00000000,
   $00000000,$00000000,$00000000,$00000000,
   $00000000,$00000000,$00000000,$00000000);


  cmap_cellH: byte = 8;        // 1..32
  cmap_cellW: byte = 8;        // 8,16,32
   
  palBMP: tab_int256;

  pisPat: integer;
  act, act_tmp: array [0..7] of byte;
  palCol: array [0..17] of byte;
  selMod, pisCol: t_pis;
  tprior: array [0..9] of byte;
  tmp: array [0..$500] of smallint;              // bufor zapamietujacy wykorzystane adresy rejestrow
  Dostepne, Changes, wsyncTab, temp: tab_byte256;
  Smask: tab_byte2K;
  locKolor: array [0..$900] of Boolean;
  SmaskX, tabKolor: array [0..$900] of byte;     // tablica kolorow
  Spr0, Spr1, Spr2, Spr3, Mis0, Mis1, Mis2, Mis3, _tmpPMG: tab_word256;  //ksztalt spritow

  gr15gtia40: array [0..15] of byte = (0,0,1,2,0,0,1,2,4,4,5,6,8,8,9,10);

  tUndo: array [0..127] of byte;                 // tablica z numerami pikow UNDO

  rKolor: array [0..241, 0..28] of byte;

  treg: array [0..2] of AnsiChar;

  bufor: array [0..240*sizeof(tablica_sprite)] of byte;             // koniecznie 240*290

  select_cmap: array [0..47, 0..239] of Boolean;

  chlimit: array [0..255] of Boolean;

  bmp_limit: array [0..47 , 0..29] of Boolean;

  select_cmap_color: byte;
  select_cmap_cell_color: array [0..3] of byte;

  cmap: array [0..47, 0..239] of color_map;

  fonty, fonty_tmp: tablica_fontow;
  Sprajt, SprajtX: array [0..239] of tablica_sprite;   // Sprajt  PMG enabled/disabled
                                                       // SprajtX PMG pixels on / off
  old_zestaw: type_old_zestaw;

  RasterLine: type_RasterLine;

  tcrc32: tab_card256;

  tmul48: tab_int256;

  tab, copy_tab, temp_tab: tablica_obrazu;

  scren, invers, invers2: tablica_znakow;

  tgtia: record
          hposp0, hposp1, hposp2, hposp3: byte;
          hposm0, hposm1, hposm2, hposm3: byte;
          sizep0, sizep1, sizep2, sizep3: byte;
          sizem: byte;
          grafp0, grafp1, grafp2, grafp3: byte;
          grafm: byte;
          colpm0, colpm1, colpm2, colpm3: byte;
          color0, color1, color2, color3: byte;
          colbak: byte;
          gtictl: byte;
          pmcntl: byte;
          regA, regX, regY: byte;
         end;

  FormPos: array [0..18] of record
           nam: string;
           top, left: integer;
           width, height: integer;
           end =
  (
  (nam:'FMain'; top:130; left:278; width:526; height:453),
  (nam:'FSelectColor'; top:369; left:61; width:222; height:284),
  (nam:'FEditCharset'; top:479; left:212; width:612; height:239),
  (nam:'FEditColors'; top:127; left:74; width:180; height:304),
  (nam:'FEditPMG'; top:154; left:37; width:243; height:464),
  (nam:'FEditRasters'; top:538; left:183; width:699; height:189),
  (nam:'FMove'; top:122; left:84; width:171; height:190),
  (nam:'FEditPalette'; top:194; left:57; width:189; height:347),
  (nam:'FSpecial'; top:115; left:73; width:219; height:439),
  (nam:'FCheck'; top:130; left:80; width:194; height:542),
  (nam:'FImportBMP'; top:130; left:200; width:446; height:132),
  (nam:'FEditBMP'; top:130; left:200; width:298; height:119),
  (nam:'FCharsFill'; top:130; left:200; width:131; height:426),
  (nam:'FBMP2PMG'; top:130; left:200; width:195; height:304),
  (nam:'FEditColorsMap'; top:130; left:200; width:192; height:218),
  (nam:'FAbout'; top:130; left:200; width:390; height:465),
  (nam:'FExportAs'; top:100; left:64; width:631; height:377),
  (nam:'FLoadScreens'; top:100; left:64; width:636; height:463),
  (nam:'FPaletteOptions'; top:100; left:64; width:309; height:256)
  );


 SpecialStr: array [0..25] of record
              nam: string;
              val: Boolean;
             end= (
 (nam:'View>Flashing selections'; val:true),             // 0
 (nam:'Edit PMG>Flashing PMG pixels'; val:false),        // 1
 (nam:'Edit PMG>Align PMG pixels to char'; val:true),    // 2
 (nam:'ASM file>Labels with constant'; val:false),       // 3
 (nam:'G2F file>Compress'; val:true),                    // 4
 (nam:'G2F file>Save with XEX file'; val:false),         // 5
 (nam:'XEX file>Compress'; val:false),                   // 6
 (nam:'GED-->Fade effect'; val:false),                   // 7
 (nam:'DLI>Fade effect'; val:false),                     // 8
 (nam:'Mode>DLI'; val:true),                             // 9
 (nam:'Mode>DLI+'; val:false),                           // 10
 (nam:'GED-->ANTIC LMS per line'; val:false),            // 11
 (nam:'GED-->DLI changes into rasters'; val:false),      // 12
 (nam:'Mode>disable badlines'; val:false),               // 13
 (nam:'GED+>Fade effect'; val:false),                    // 14
 (nam:'DLI>COLORS'; val:true),                           // 15
 (nam:'DLI>BOX'; val:false),                             // 16
 (nam:'ASM file>RUN'; val:true),                         // 17
 (nam:'ASM file>INI'; val:false),                        // 18
 (nam:'View>Borders'; val:false),                        // 19
 (nam:'Pixel>Proportional'; val:false),                  // 20
 (nam:'DLI>RANDOM BOX'; val:false),                      // 21
 (nam:'DLI>LEFT/RIGHT'; val:false),                      // 22
 (nam:'DLI>PLASMA'; val:false),                          // 23
 (nam:'View>Grid'; val:false),                           // 24
 (nam:'XEX file>Save with G2F file'; val:false)          // 25

 );


  table, table2, chFill, gfxMode, old_gfxMode, newFnt, startCharset, chrctl, chrctl_edit: tablica_row;

  inv_nbl: trow;

  newPal, tb: array [0..15] of byte;

  raster: array [0..239] of tARaster;           //240* tARaster
  raster_line_ofset: array [0..239] of tRaster;

  kpal: Hpalette;
  kpal_mem: array [0..767] of byte;

  check_bmp: array [0..255] of bmp_check;

  upal: array [0..255] of __upal;

  check_list: array of type_check;

  AtariPal: tab_tcol256;

  EditBmpFnt: tablica_font;

  BMPLimitBuf: array of word;

  cfill: record
          c0: TColor;
          c1: TColor;
         end;

  vscrol: record
           nam,pth: string;
           use: Boolean;
           pos: smallint;
           max: smallint;
          end;

  kosz: array of AnsiString;
  tval: array of AnsiString;
  tadr: array of AnsiString;

const

 twyt1: array [0..7] of byte = ($80,$40,$20,$10,8,4,2,1);
 twyt2: array [0..3] of byte = ($c0,$30,$c,$3);
 twyt4: array [0..1] of byte = ($f0,$0f);

 tcol1: array [0..1] of byte = (0,$ff);
 tcol2: array [0..4] of byte = (0,$55,$aa,$ff,$ff);
 tcol4: array [0..15] of byte =(0,$11,$22,$33,$44,$55,$66,$77,$88,$99,$aa,$bb,$cc,$dd,$ee,$ff);

 tand1: array [0..7] of byte = ($7f,$bf,$df,$ef,$f7,$fb,$fd,$fe);
 tand2: array [0..3] of byte = ($3f,$cf,$f3,$fc);
 tand4: array [0..1] of byte = ($0f,$f0);

 tand_pmg: array [0..8] of byte = ($ff,1,2,4,8,$10,$20,$40,$80);

// tablica przeliczenia cykl->pixel, cykl=2..36
 edge40_2: array [-44..60] of word =
 (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1,17,33,49,65,81,97,113,129,145,161,177,185,193,201,209,217,225,233,241,249,
  257,265,273,281,289,297,305,313,321,329,337,341,345,349,353,357,361,365,369,373,377,381,385,389,
  393,397,401,405,409,413,417,421,425,429,433,437,441,445,449,453);

 edge32_2: array [-44..60] of word =
 (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,17,33,
  49,65,81,97,113,129,145,161,177,185,193,201,209,217,225,233,241,249,
  257,265,273,281,289,297,305,309,313,317,321,325,329,333,337,341,345,349,353,357,361,365,369,373,377,381,385,389,
  393,397,401,405,409,413,417,421,425,429,433,437,441,445,449);

 edge32_gfx: array [-44..60] of word =
 (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,5,9,13,
  17,21,25,29,33,41,45,61,77,93,109,125,141,157,173,181,189,197,205,213,
  221,229,237,245,253,261,269,277,285,293,301,305,309,313,317,321,325,329,333,337,341,345,349,353,369,
  369,369,369,369,369,369,369,369,
  369,369,369,369,369,369,369,369);

 edge40_gfx: array [-44..60] of word =
 (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,29,45,61,77,93,109,125,141,157,173,181,189,197,205,213,221,229,
  237,245,253,261,269,277,285,293,301,309,317,325,333,337,341,345,349,353,357,361,365,369,369,369,369,369,
  369,369,369,369,369,369,369,369,
  369,369,369,369,369,369,369,369);


 defPal: tab_tcol256 =
 ($00000000, $003B3B3B, $00494949, $00575757,
 $00656565, $00737373, $00818181, $008F8F8F,
 $009D9D9D, $00ABABAB, $00B9B9B9, $00C7C7C7,
 $00D5D5D5, $00E3E3E3, $00F1F1F1, $00FFFFFF,
 $0000235C, $0000316A, $00003F78, $000A4D86,
 $00185B94, $002669A2, $003477B0, $004285BE,
 $005093CC, $005EA1DA, $006CAFE8, $007ABDF6,
 $0088CBFF, $0096D9FF, $00A4E7FF, $00B2F5FF,
 $00091469, $00172277, $00253085, $00333E93,
 $00414CA1, $004F5AAF, $005D68BD, $006B76CB,
 $007984D9, $008792E7, $0095A0F5, $00A3AEFF,
 $00B1BCFF, $00BFCAFF, $00CDD8FF, $00DBE6FF,
 $00380A6C, $0046187A, $00542688, $00623496,
 $007042A4, $007E50B2, $008C5EC0, $009A6CCE,
 $00A87ADC, $00B688EA, $00C496F8, $00D2A4FF,
 $00E0B2FF, $00EEC0FF, $00FCCEFF, $00FFDCFF,
 $00650564, $00731372, $00812180, $008F2F8E,
 $009D3D9C, $00AB4BAA, $00B959B8, $00C767C6,
 $00D575D4, $00E383E2, $00F191F0, $00FF9FFE,
 $00FFADFF, $00FFBBFF, $00FFC9FF, $00FFD7FF,
 $00890752, $00971560, $00A5236E, $00B3317C,
 $00C13F8A, $00CF4D98, $00DD5BA6, $00EB69B4,
 $00F977C2, $00FF85D0, $00FF93DE, $00FFA1EC,
 $00FFAFFA, $00FFBDFF, $00FFCBFF, $00FFD9FF,
 $009C103A, $00AA1E48, $00B82C56, $00C63A64,
 $00D44872, $00E25680, $00F0648E, $00FE729C,
 $00FF80AA, $00FF8EB8, $00FF9CC6, $00FFAAD4,
 $00FFB8E2, $00FFC6F0, $00FFD4FE, $00FFE2FF,
 $009C1E1F, $00AA2C2D, $00B83A3B, $00C64849,
 $00D45657, $00E26465, $00F07273, $00FE8081,
 $00FF8E8F, $00FF9C9D, $00FFAAAB, $00FFB8B9,
 $00FFC6C7, $00FFD4D5, $00FFE2E3, $00FFF0F1,
 $00892E07, $00973C15, $00A54A23, $00B35831,
 $00C1663F, $00CF744D, $00DD825B, $00EB9069,
 $00F99E77, $00FFAC85, $00FFBA93, $00FFC8A1,
 $00FFD6AF, $00FFE4BD, $00FFF2CB, $00FFFFD9,
 $00653E00, $00734C03, $00815A11, $008F681F,
 $009D762D, $00AB843B, $00B99249, $00C7A057,
 $00D5AE65, $00E3BC73, $00F1CA81, $00FFD88F,
 $00FFE69D, $00FFF4AB, $00FFFFB9, $00FFFFC7,
 $00384B00, $00465900, $00546709, $00627517,
 $00708325, $007E9133, $008C9F41, $009AAD4F,
 $00A8BB5D, $00B6C96B, $00C4D779, $00D2E587,
 $00E0F395, $00EEFFA3, $00FCFFB1, $00FFFFBF,
 $00095200, $00176000, $00256E0C, $00337C1A,
 $00418A28, $004F9836, $005DA644, $006BB452,
 $0079C260, $0087D06E, $0095DE7C, $00A3EC8A,
 $00B1FA98, $00BFFFA6, $00CDFFB4, $00DBFFC2,
 $00005300, $0000610B, $00006F19, $000A7D27,
 $00188B35, $00269943, $0034A751, $0042B55F,
 $0050C36D, $005ED17B, $006CDF89, $007AED97,
 $0088FBA5, $0096FFB3, $00A4FFC1, $00B2FFCF,
 $00004E13, $00005C21, $00006A2F, $0000783D,
 $0000864B, $000B9459, $0019A267, $0027B075,
 $0035BE83, $0043CC91, $0051DA9F, $005FE8AD,
 $006DF6BB, $007BFFC9, $0089FFD7, $0097FFE5,
 $0000432D, $0000513B, $00005F49, $00006D57,
 $00007B65, $00018973, $000F9781, $001DA58F,
 $002BB39D, $0039C1AB, $0047CFB9, $0055DDC7,
 $0063EBD5, $0071F9E3, $007FFFF1, $008DFFFF,
 $00003346, $00004154, $00004F62, $00005D70,
 $00006B7E, $000B798C, $0019879A, $002795A8,
 $0035A3B6, $0043B1C4, $0051BFD2, $005FCDE0,
 $006DDBEE, $007BE9FC, $0089F7FF, $0097FFFF);

 AtariFnt: array [0..1023] of byte =
 ($00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$18,$18,$18,$00,$18,$00,$00,$66,$66,$66,$00,$00,$00,$00,$00,$66,$FF,$66,$66,$FF,$66,$00,
 $18,$3E,$60,$3C,$06,$7C,$18,$00,$00,$66,$6C,$18,$30,$66,$46,$00,$1C,$36,$1C,$38,$6F,$66,$3B,$00,$00,$18,$18,$18,$00,$00,$00,$00,
 $00,$0E,$1C,$18,$18,$1C,$0E,$00,$00,$70,$38,$18,$18,$38,$70,$00,$00,$66,$3C,$FF,$3C,$66,$00,$00,$00,$18,$18,$7E,$18,$18,$00,$00,
 $00,$00,$00,$00,$00,$18,$18,$30,$00,$00,$00,$7E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$18,$00,$00,$06,$0C,$18,$30,$60,$40,$00,
 $00,$3C,$66,$6E,$76,$66,$3C,$00,$00,$18,$38,$18,$18,$18,$7E,$00,$00,$3C,$66,$0C,$18,$30,$7E,$00,$00,$7E,$0C,$18,$0C,$66,$3C,$00,
 $00,$0C,$1C,$3C,$6C,$7E,$0C,$00,$00,$7E,$60,$7C,$06,$66,$3C,$00,$00,$3C,$60,$7C,$66,$66,$3C,$00,$00,$7E,$06,$0C,$18,$30,$30,$00,
 $00,$3C,$66,$3C,$66,$66,$3C,$00,$00,$3C,$66,$3E,$06,$0C,$38,$00,$00,$00,$18,$18,$00,$18,$18,$00,$00,$00,$18,$18,$00,$18,$18,$30,
 $06,$0C,$18,$30,$18,$0C,$06,$00,$00,$00,$7E,$00,$00,$7E,$00,$00,$60,$30,$18,$0C,$18,$30,$60,$00,$00,$3C,$66,$0C,$18,$00,$18,$00,
 $00,$3C,$66,$6E,$6E,$60,$3E,$00,$00,$18,$3C,$66,$66,$7E,$66,$00,$00,$7C,$66,$7C,$66,$66,$7C,$00,$00,$3C,$66,$60,$60,$66,$3C,$00,
 $00,$78,$6C,$66,$66,$6C,$78,$00,$00,$7E,$60,$7C,$60,$60,$7E,$00,$00,$7E,$60,$7C,$60,$60,$60,$00,$00,$3E,$60,$60,$6E,$66,$3E,$00,
 $00,$66,$66,$7E,$66,$66,$66,$00,$00,$7E,$18,$18,$18,$18,$7E,$00,$00,$06,$06,$06,$06,$66,$3C,$00,$00,$66,$6C,$78,$78,$6C,$66,$00,
 $00,$60,$60,$60,$60,$60,$7E,$00,$00,$63,$77,$7F,$6B,$63,$63,$00,$00,$66,$76,$7E,$7E,$6E,$66,$00,$00,$3C,$66,$66,$66,$66,$3C,$00,
 $00,$7C,$66,$66,$7C,$60,$60,$00,$00,$3C,$66,$66,$66,$6C,$36,$00,$00,$7C,$66,$66,$7C,$6C,$66,$00,$00,$3C,$60,$3C,$06,$06,$3C,$00,
 $00,$7E,$18,$18,$18,$18,$18,$00,$00,$66,$66,$66,$66,$66,$7E,$00,$00,$66,$66,$66,$66,$3C,$18,$00,$00,$63,$63,$6B,$7F,$77,$63,$00,
 $00,$66,$66,$3C,$3C,$66,$66,$00,$00,$66,$66,$3C,$18,$18,$18,$00,$00,$7E,$0C,$18,$30,$60,$7E,$00,$00,$1E,$18,$18,$18,$18,$1E,$00,
 $00,$40,$60,$30,$18,$0C,$06,$00,$00,$78,$18,$18,$18,$18,$78,$00,$00,$08,$1C,$36,$63,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$00,
 $00,$36,$7F,$7F,$3E,$1C,$08,$00,$18,$18,$18,$1F,$1F,$18,$18,$18,$03,$03,$03,$03,$03,$03,$03,$03,$18,$18,$18,$F8,$F8,$00,$00,$00,
 $18,$18,$18,$F8,$F8,$18,$18,$18,$00,$00,$00,$F8,$F8,$18,$18,$18,$03,$07,$0E,$1C,$38,$70,$E0,$C0,$C0,$E0,$70,$38,$1C,$0E,$07,$03,
 $01,$03,$07,$0F,$1F,$3F,$7F,$FF,$00,$00,$00,$00,$0F,$0F,$0F,$0F,$80,$C0,$E0,$F0,$F8,$FC,$FE,$FF,$0F,$0F,$0F,$0F,$00,$00,$00,$00,
 $F0,$F0,$F0,$F0,$00,$00,$00,$00,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,$00,$00,$00,$F0,$F0,$F0,$F0,
 $00,$1C,$1C,$77,$77,$08,$1C,$00,$00,$00,$00,$1F,$1F,$18,$18,$18,$00,$00,$00,$FF,$FF,$00,$00,$00,$18,$18,$18,$FF,$FF,$18,$18,$18,
 $00,$00,$3C,$7E,$7E,$7E,$3C,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$00,$00,$00,$FF,$FF,$18,$18,$18,
 $18,$18,$18,$FF,$FF,$00,$00,$00,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$18,$18,$18,$1F,$1F,$00,$00,$00,$78,$60,$78,$60,$7E,$18,$1E,$00,
 $00,$18,$3C,$7E,$18,$18,$18,$00,$00,$18,$18,$18,$7E,$3C,$18,$00,$00,$18,$30,$7E,$30,$18,$00,$00,$00,$18,$0C,$7E,$0C,$18,$00,$00,
 $00,$18,$3C,$7E,$7E,$3C,$18,$00,$00,$00,$3C,$06,$3E,$66,$3E,$00,$00,$60,$60,$7C,$66,$66,$7C,$00,$00,$00,$3C,$60,$60,$60,$3C,$00,
 $00,$06,$06,$3E,$66,$66,$3E,$00,$00,$00,$3C,$66,$7E,$60,$3C,$00,$00,$0E,$18,$3E,$18,$18,$18,$00,$00,$00,$3E,$66,$66,$3E,$06,$7C,
 $00,$60,$60,$7C,$66,$66,$66,$00,$00,$18,$00,$38,$18,$18,$3C,$00,$00,$06,$00,$06,$06,$06,$06,$3C,$00,$60,$60,$6C,$78,$6C,$66,$00,
 $00,$38,$18,$18,$18,$18,$3C,$00,$00,$00,$66,$7F,$7F,$6B,$63,$00,$00,$00,$7C,$66,$66,$66,$66,$00,$00,$00,$3C,$66,$66,$66,$3C,$00,
 $00,$00,$7C,$66,$66,$7C,$60,$60,$00,$00,$3E,$66,$66,$3E,$06,$06,$00,$00,$7C,$66,$60,$60,$60,$00,$00,$00,$3E,$60,$3C,$06,$7C,$00,
 $00,$18,$7E,$18,$18,$18,$0E,$00,$00,$00,$66,$66,$66,$66,$3E,$00,$00,$00,$66,$66,$66,$3C,$18,$00,$00,$00,$63,$6B,$7F,$3E,$36,$00,
 $00,$00,$66,$3C,$18,$3C,$66,$00,$00,$00,$66,$66,$66,$3E,$0C,$78,$00,$00,$7E,$0C,$18,$30,$7E,$00,$00,$18,$3C,$7E,$7E,$18,$3C,$00,
 $18,$18,$18,$18,$18,$18,$18,$18,$00,$7E,$78,$7C,$6E,$66,$06,$00,$08,$18,$38,$78,$38,$18,$08,$00,$10,$18,$1C,$1E,$1C,$18,$10,$00);

// tablice piorytetow dla obiektow PMG
// $80..$83 - pmg, $84 - piaty gracz, 0..3 - grafika
 pr2: array [0..9] of byte = ($80,$81,$82,$83,$84,1,2,3,4,0);  // Preview = All
 pr1: array [0..9] of byte = ($80,$81,$84,1,2,3,4,$82,$83,0);
 pr0: array [0..9] of byte = ($84,1,2,3,4,$80,$81,$82,$83,0);
 pr3: array [0..9] of byte = ($84,1,2,$80,$81,$82,$83,3,4,0);  // prior = 8
 pr4: array [0..9] of byte = ($80,$81,$84,1,2,$82,$83,3,4,0);  // prior = 0

 pr2_null: array [0..9] of byte = ($80,$81,$82,$83,$84,1,2,3,4,0);  // Preview = PMG
 pr1_null: array [0..9] of byte = ($80,$81,$84,$82,$83,1,2,3,4,0);
 pr0_null: array [0..9] of byte = ($84,$80,$81,$82,$83,1,2,3,4,0);

 _tPrior: array [0..4] of AnsiString =
 ('P4-PF0-PF1-PF2-PF3-PM0-PM1-PM2-PM3-BAK',   // 0    prior = 4
  'PM0-PM1-P4-PF0-PF1-PF2-PF3-PM2-PM3-BAK',   // -1   prior = 2
  'PM0-PM1-PM2-PM3-P4-PF0-PF1-PF2-PF3-BAK',   // -2   prior = 1
  'P4-PF0-PF1-PM0-PM1-PM2-PM3-PF2-PF3-BAK',   // 1    prior = 8
  'PM0-PM1-P4-PF0-PF1-PM2-PM3-PF2-PF3-BAK');  // -3   prior = 0

// tkod:array [0..9] of string[3]=
// ('$D01A','$D016','709','710','711','BAK','PF0','PF1','PF2','PF3');

// na podstawie SaveDialog

//  1 - BMP Windows Bitmap (*.bmp)
//  2 - G2F Graph2Font file (*.g2f)
//  3 - MIC Micropaint (*.mic)
//  4 - XEX Atari Executable (*.xex)
//  5 - COL Colors (*.col)
//  6 - PMG Player-Missile Graphics (*.pmg)
//  7 - JGP Jet Graphics Planner (*.jgp)
//  8 - ASM Assembler file (*.asm)
//  9 - VSC Vertical Scroll (*.vsc)
// 10 - PNG Portable Net (*.png)
// 11 - MCH (*.mch)
// 12 - GIF Compuserve GIF (*.gif)
// 13 - DAT All data (*.dat)
// 14 - ASM All data (*.asm)
// 15 - LMT Optymizing limitations (*.lmt)
// 16 - RAS Raster program (*.ras)
// 17 - PAS Simple Pascal program (*.pas)
// 18 - PAS Full Pascal program (*.pas)
// 19 - PAS Player-Missile Graphics (*.pas)
// 20 - ASM Player-Missile Graphics (*.asm)

 file_ext: array [1..20] of AnsiString =
 ('.BMP','.G2F','.MIC','.XEX','.COL','.PMG','.JGP','.ASM','.VSC',
  '.PNG','.MCH','.GIF','.DAT','.ASM','.LMT','.RAS', '.PAS', '.PAS', '.PAS', '.ASM');

// zamiana pozycji z ComboBox na odpowiadajacy jej rejestr Atari (ZACHOWANE DLA WSTECZNEJ KOMPATYBILNOSCI)
// !!! aktualnie nie uzywane, zapisywany jest mlodszy nibbl i to wystarcza !!!
 CnvAdr: array [0..23] of AnsiString =
 ('$D000','$D001','$D002','$D003','$D004','$D005','$D006','$D007','$D008',
  '$D009','$D00A','$D00B','$D00C','$D012','$D013','$D014','$D015','$D016',
  '$D017','$D018','$D019','$D01A','$D01E','$D01B');

 NOP: array [0..13] of AnsiString =
 ('nop','cmp 0',':2 nop','cmp 0\ nop','cmp (0,x)','pha:pla',
  'cmp (0,x)\ nop','nop\ pha:pla','cmp (0,x)\ cmp 0,x','cmp 0,x\ pha:pla',
  'jsr _rts','cmp (0,x)\ pha:pla','jsr _rts\ nop','jsr _rts\ cmp 0');

 g2fzlib_hea: array [0..6] of AnsiChar = ('G','2','F','Z','L','I','B');

 brkLine = '// -----------------------------------------------------------';
 brkTab  = '; ---';

 transCol=$00313131;

 copypaste='copy&paste.dat';

 TVIS_CHECKED  = $2000;
 TVIS_UNCHECKED= $1000;

 ___Mrugajace         = 0;
 ___VisiblePMG        = 1;
 ___AlignPMG          = 2;
 ___ShortLabels       = 3;
 ___PackG2FFile       = 4;
 ___SaveG2FandXEX     = 5;
 ___PackXEXFile       = 6;
 ___FadeGED           = 7;
 ___FadeDLI           = 8;
 ___ModeDLI           = 9;
 ___ModeDLIplus       = 10;
 ___LMSperline        = 11;
 ___DLIchangesIn      = 12;
 ___nobadlines        = 13;
 ___FadeGEDplus       = 14;
 ___FadeDLICOLORS     = 15;
 ___FadeDLIBOX        = 16;
 ___asmRUN            = 17;
 ___asmINI            = 18;
 ___borders           = 19;
 ___doublescan        = 20;
 ___FadeDLIRND        = 21;
 ___FadeDLI_LR        = 22;
 ___FadeDLI_Plasma    = 23;
 ___Grid              = 24;
 ___SaveXEXandG2F     = 25;


implementation

uses Zoom, EditCharset, MoveCopyPaste, EditColors, EditPMG, EditRasters,
     EditPalette, ExportAs, Bmp2Pmg, About, CharsFill, Check,
     EditColorsMap, PaletteOptions, Special, EditBMP, ImportBMP,
     Piccolo2MCH;

{$R *.DFM}



procedure TForm1.WMDrawClipboard(var Msg: TWMDrawClipBoard);
// ta procedura obs³ugi komunikatu zastêpuje nam cykaj¹c¹
// czêsto procedurkê obs³ugi zdarzenia OnTimer komponentu Timer :)
begin
  EditPaste1.Enabled := Clipboard.HasFormat(CF_BITMAP); // np.
  // odes³anie komunikatu do nastêpnego okna w kolejce przegl¹dowej
  SendMessage(FOldClipViewHwnd, WM_DRAWCLIPBOARD, 0, 0);
end;


procedure TForm1.WMChangeCBChain(var Msg: TWMChangeCBChain);
begin
  if Msg.Remove = FOldClipViewHwnd then
    // w przypadku, gdy okno znajduj¹ce siê na nastêpnej pozycji w kolejce
    // zostaje usuniête, do zmiennej FOldClipViewHwnd przypisujemy uchwyt
    // nastêpnego okna w kolejce przegl¹dowej
    FOldClipViewHwnd := Msg.Next
  else
    // w przeciwnym wypadku odsy³amy komunikat do nastêpnego okna
    // w kolejce przegl¹dowej
    SendMessage(FOldClipViewHwnd, WM_CHANGECBCHAIN, Msg.Remove, Msg.Next);

  Msg.Result := 0;
end;


function TForm1.GetPixel(aBitmap: TBitmap; const X, Y: Integer): TColor;
var
  P: PRGBQuad;
begin
  if (Y < 0) or (X < 0) or (Y >= aBitmap.Height) or (X >= aBitmap.Width) then
  begin
    Result := clBlack;
    Exit;
  end;
  P := aBitmap.ScanLine[Y];
  Inc(P, X);
  Result := (P^.rgbBlue shl 16) or (P^.rgbGreen shl 8) or P^.rgbRed;
end;


procedure TForm1.SetPixel(aBitmap: TBitmap; const X, Y: Integer; const Value: TColor);
var
  P: PRGBQuad;
begin
  if (Y < 0) or (X < 0) or (Y >= aBitmap.Height) or (X >= aBitmap.Width) then
    Exit;
  P := aBitmap.ScanLine[Y];
  Inc(P, X);
  P^.rgbBlue := (Value and $FF0000) shr 16;
  P^.rgbGreen := (Value and $00FF00) shr 8;
  P^.rgbRed := Value and $0000FF;
end;


procedure calc_crc;
var x, y: byte;
    crc_: Int64;
begin

for x:=0 to 255 do begin

 crc_ := x shl 8;

 for y:=1 to 8 do begin
  crc_ := crc_ shr 1;

  if (crc_ and $80) > 0 then crc_ := crc_ xor $edb8832000;
 end;

 tcrc32[x] := cardinal(crc_ shr 8);
end;
end;


function TForm1.tgtia2PenColor(const a: byte): byte;
begin

 Result:=0;

 case a of
  0: Result:=tgtia.colbak;
  1: Result:=tgtia.color0;
  2: Result:=tgtia.color1;
  3: Result:=tgtia.color2;
  4: Result:=tgtia.color3;
  5: Result:=tgtia.colpm0;
  6: Result:=tgtia.colpm1;
  7: Result:=tgtia.colpm2;
  8: Result:=tgtia.colpm3;
 end;

end;


procedure TForm1.ClrRectImage(var img: TImage; const cl: TColor);
begin

 img.Canvas.Brush.Color:=cl;
 img.Canvas.FillRect(Rect(0,0, img.Width, img.Height));

end;


procedure TForm1.ClrRect(var bmp: TBitmap; const cl: TColor = clBtnFace; const ofs: integer = 0);
begin

 bmp.Canvas.Brush.Color:=cl;

 if ofs>0 then
  bmp.Canvas.FillRect(Rect(0,0, ofs, bmp.Height))
 else
  bmp.Canvas.FillRect(Rect(0,0, bmp.Width, bmp.Height));

end;


procedure Grid(a: Boolean);
var mul_w, mul_h, hlp: integer;
    y: byte;
    g: TBitmap;
begin

if a then begin

 mul_w := 8*2;

 if Fox1 then
  mul_h := 4*2
 else
  mul_h := 8*2;

 g:=TBitmap.Create;
 g.PixelFormat:=pf32bit;
 g.SetSize(form1.GridImage.Width, form1.GridImage.Height);
 g.TransparentColor:=transCol;

with g.Canvas do begin

 form1.ClrRect(g, transCol);

 Pen.Color:=clGray;

 Pen.Style:=psDot; Pen.Mode:=pmMerge;
 Brush.Style:=bsClear;

 hlp:=0;
 for y:=47 downto 0 do begin
  moveto(hlp,240*2); lineto(hlp,0);
  inc(hlp, mul_w);
 end;

 hlp:=0;
 for y:=29+(30*ord(fox1)) downto 0 do begin
  moveto(0,hlp); lineto(384*2,hlp);
  inc(hlp, mul_h);
 end;

 form1.GridImage.Picture.Graphic:=g;

end;

 g.Free;

end;

form1.GridImage.Visible:=a;

end;


procedure TForm1.RecentFileClick(Sender: TObject; const Filename: String);
begin

 current_filename:=Filename;

 OpenDialog1.FileName:=ExtractFileName(current_filename);
 SaveDialog1.FileName:=current_filename;

 OpenDialog1.InitialDir:=ExtractFileDir(current_filename);
 SaveDialog1.InitialDir:=OpenDialog1.InitialDir;

 form1.PreviewButton;

 SaveAfterExit:=false;
end;


procedure CloseRestoreApp(const a: Boolean; var closeApp: tCloseApp);
begin

 if a then begin

  closeApp[ord(F_EditPMG)].app:=FEditPMG.Visible;
  closeApp[ord(F_EditPMG)].par:=form1.ChangePMG.Checked;

  closeApp[ord(F_EditColors)].app:=FEditColors.Visible;
  closeApp[ord(F_EditColors)].par:=form1.ChangeColors.Checked;

  closeApp[ord(F_Move)].app:=FMove.Visible;
  closeApp[ord(F_EditCharset)].app:=FEditCharset.Visible;
  closeApp[ord(F_EditBMP)].app:=FEditBMP.Visible;
  closeApp[ord(F_EditRasters)].app:=FEditRasters.Visible;
  closeApp[ord(F_EditPalette)].app:=FEditPalette.Visible;
  closeApp[ord(F_EditColorsMap)].app:=FEditColorsMap.Visible;

  form1.Zamknij(F_EditPMG);
  form1.Zamknij(F_EditColors);
  form1.Zamknij(F_Move);
  form1.Zamknij(F_EditCharset);
  form1.Zamknij(F_EditBMP);
  form1.Zamknij(F_EditRasters);
  form1.Zamknij(F_EditPalette);
  form1.Zamknij(F_EditColorsMap);

 end else begin

  if closeApp[ord(F_EditPMG)].app then
   if closeApp[ord(F_EditPMG)].par then begin
    if form1.ChangePMG.Enabled then form1.ChangePMGClick(form1)
   end else
    if form1.EditPMG.Enabled then form1.EditPMGExecute(form1);

  if closeApp[ord(F_EditColors)].app then
   if closeApp[ord(F_EditColors)].par then begin
    if form1.ChangeColors.Enabled then form1.ChangeColorsClick(form1)
   end else
    if form1.EditColors.Enabled then form1.EditColorsExecute(form1);

  if closeApp[ord(F_EditBMP)].app then form1.EditBitmapExecute(form1);
  if closeApp[ord(F_Move)].app then form1.MoveCopyPasteClick(form1);
  if closeApp[ord(F_EditCharset)].app then form1.EditCharsetExecute(form1);
  if closeApp[ord(F_EditRasters)].app then form1.EditRastersExecute(form1);
  if closeApp[ord(F_EditPalette)].app then form1.EditPaletteExecute(form1);
  if closeApp[ord(F_EditColorsMap)].app then form1.EditColorsMapExecute(form1);

 end;

end;


procedure TRadioGroup.WndProc(var msg : TMessage);
var
  ps : tagPaintStruct;
begin
if msg.Msg = wm_paint then begin
  if caption <> '' then xCaption := caption;     // !!! koniecznie inaczej minimalizacja okna usunie caption
  caption := '';
  inherited;
  BeginPaint(handle, ps);
  with canvas do begin

    Brush.Color := {clBlack;} self.Color;

    Brush.Style:=bsSolid;

    Font.Style:=[fsBold];
//    Font.Color:=clWhite;

    TextOut((width - TextWidth(xCaption)) shr 1, 0, xCaption);
  end;
  EndPaint(handle, ps);
end else begin
  inherited;
end;
end;


procedure TForm1.Execute(const _file, _direc, _param: string; const show: Boolean);
(*----------------------------------------------------------------------------*)
(* http://delphi.about.com/od/windowsshellapi/a/executeprogram.htm            *)
(*----------------------------------------------------------------------------*)
var SEInfo: TShellExecuteInfo;
    ExitCode: DWORD;
begin

 //FillChar(SEInfo, SizeOf(SEInfo), 0) ;
 ZeroMemory(@SEInfo, SizeOf(SEInfo));
 SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;


   with SEInfo do begin
     fMask := SEE_MASK_NOCLOSEPROCESS;
     Wnd := Application.Handle;
     lpVerb := nil;

     lpFile := PWideChar(_file) ;

     lpParameters := PWideChar(_param) ;   // ParamString can contain the application parameters

     if _direc<>'' then
      lpDirectory := PWideChar(_direc) ;   // StartInString specifies the name of the working directory.
                                           // If ommited, the current directory is used.
     if show then nShow := SW_SHOWNORMAL;

   end;


   if ShellExecuteEx(@SEInfo) then begin
     repeat
       Application.ProcessMessages;
       GetExitCodeProcess(SEInfo.hProcess, ExitCode);
     until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
   end;


end;


procedure TForm1.SetFormPos(const a: string; var t,l: integer);
var i: integer;
begin

 for i:=0 to length(FormPos)-1 do
  if FormPos[i].nam=a then begin
   t:=FormPos[i].top; if t<0 then t:=0;
   l:=FormPos[i].left; if l<0 then l:=0;

   if t+FormPos[i].height>Screen.Height then t:=Screen.Height-FormPos[i].height;
   if l+FormPos[i].width>Screen.Width then l:=Screen.Width-FormPos[i].width;

   Break;
  end;

end;


procedure TForm1.NewFormPos(const a: string; const t,l: integer);
var i: integer;
begin

 for i:=0 to length(FormPos)-1 do
  if FormPos[i].nam=a then begin
   FormPos[i].top:=t;
   FormPos[i].left:=l;
   Break;
  end;

end;


function TForm1.SpecialVal(const a,value: integer): Boolean;
var i: integer;
    BoolResult:boolean;
    tn : TTreeNode;
    group, subgroup: string;
//    tt: textfile;
begin

 Result:=false;

// assignfile(tt, 'test.txt'); rewrite(tt);

 for i:=0 to FSpecial.TreeView1.Items.Count-1 do begin

  tn := FSpecial.TreeView1.Items.Item[i];

  if tn.StateIndex=-1 then begin
   group:=tn.Text;
   subgroup:='';
  end else
   if tn.StateIndex in [cFlatChecked,cFlatUnCheck,cFlatRadioChecked,cFlatRadioUnCheck] then begin
    BoolResult := tn.StateIndex in [cFlatChecked,cFlatRadioChecked];

//                     writeln(tt, group+subgroup + '>' + tn.Text);

    if AnsiUpperCase(group+subgroup + '>' + tn.Text)=AnsiUpperCase(SpecialStr[a].nam) then begin

     if value<0 then
      Result:=BoolResult
     else
      if tn.StateIndex in [cFlatChecked,cFlatUnCheck] then
       tn.StateIndex:=value
      else
       tn.StateIndex:=value+2;

     Break;
    end;

   end;

 end;
//           closefile(tt);
end;


procedure TForm1.print(var bmp: TBitmap; const b: byte; const row,column: integer; const _xor: byte);
(*----------------------------------------------------------------------------*)
(* b       numer znaku w zestawie                                             *)
(* row     wiersz                                                             *)
(* column  kolumna                                                            *)
(* _xor    wartosc eor-a                                                      *)
(*----------------------------------------------------------------------------*)
var
  a,x,w: byte;
  K: PRGBQuad;
begin

  for x:=0 to 7 do begin

   K:=bmp.ScanLine[row+x];

   a:=AtariFnt[b shl 3+x] xor _xor;

   for w:=0 to 7 do
    scan_pixel(K, column+w, ord(a and twyt1[w]=0) * GetSysColor(COLOR_BTNFACE));

  end;

end;


procedure TForm1.ClrShape9;
begin

 ClrRect(wycinek, transCol);

end;


procedure ustawStartCharset(const y: byte);
var bmp: TBitmap;
    i: integer;
begin

 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(31*24+8, 8);

 form1.ClrRect(bmp);

 form1.print(bmp, 13, 0,8, ord(startCharset[y]*24=0)*$ff);
 form1.print(bmp, 13, 0,16, ord(startCharset[y]*24=0)*$ff);

 for I := 0 to 29 do begin
  form1.print(bmp, i div 10+16, 0,i*24+32, ord(startCharset[y]*24=i*24+24)*$ff);
  form1.print(bmp, i mod 10+16, 0,i*24+40, ord(startCharset[y]*24=i*24+24)*$ff);
 end;

 form1.image5.Picture.Graphic:=bmp;

 bmp.Free;

end;


procedure TForm1.UstawMemo;
var i: integer;
    b: byte;
    bmp: TBitmap;
    sChar: array [-1..30] of byte;
begin

 sChar[-1]:=0;
 for i := 0 to 29 do
  sChar[i]:=StartCharset[i];


 if t_mode(SelectMode.ItemIndex) in [m_gedm, m_pgr, m_piccolo] then begin

  psRight:=false;

  image5.Visible:=psRight;
 end;


 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(16, 240);

 ClrRect(bmp, clBtnFace, 16);

(*------------------------ CHARSET Information -------------------------------*)
 if not(psRight) then begin

//  if UseChar then
   for i:=0 to 29 do begin

    if UseChar then
     b:=table[i] div 10+16
    else
     b:=13;

    print(bmp, b, i*8, 0, newFnt[i]);

    if UseChar then
     b:=table[i] mod 10+16
    else
     b:=13;

    print(bmp, b, i*8, 8, newFnt[i]);
   end;

 end else
 for i:=0 to 29 do begin                        // START CHARSET Information

  if sChar[i]=0 then
   b:=13
  else
   b:=(sChar[i]-1) div 10+16;

  print(bmp, b, i*8, 0, newFnt[i]);

  if sChar[i]=0 then
   b:=13
  else
   b:=(sChar[i]-1) mod 10+16;

  print(bmp, b, i*8, 8, newFnt[i]);
 end;


 image3.Picture.Graphic:=bmp;


(*-------------------------- PIXEL Information -------------------------------*)

 bmp.Width:=8;

 ClrRect(bmp);

 for i:=0 to 29 do begin
  b:=gfxMode[i];

  if b>9 then
   inc(b,23)
  else
   inc(b,16);

  print(bmp, b, i*8, 0, 0);
 end;

 image2.Picture.Graphic:=bmp;


(*-------------------------- CHRCTL Information ------------------------------*)

 bmp.SetSize(8, 240);

 ClrRect(bmp);

 for i:=0 to 29 do begin
  b:=chrctl[i];

  if b>9 then
   inc(b,23)
  else
   inc(b,16);

//  print(bmp, ord('|'), i*8, 0, 0);

  if UseChar then
   print(bmp, b, i*8, 0, 0)
  else
   print(bmp, 13, i*8, 0, 0);

 end;

 image7.Picture.Graphic:=bmp;

 bmp.Free;

end;


procedure WlaczZnaki(const a: Boolean);
begin
//form7.Button2.Enabled:=a;
 UseChar:=a;

 with form1 do begin
  Optymizing1.Enabled:=a;
  BMPLimitations1.Enabled:=a;
  Normal1.Enabled:=a;
  jgp1.Enabled:=a; jgp2.Enabled:=a;
  Charsfill1.Enabled:=a; Showchars1.Enabled:=a;
 end;

 if a then
  form1.Cnv
 else
  form1.UstawMemo;

end;


procedure StatusCharsets(const a: integer);
begin

 form1.StatusBar1.Panels[1].Text:=format('Charsets: %d', [a*ord(t_mode(form1.SelectMode.ItemIndex) in [m_gedp,m_dli, m_piccolo])]);

end;


function TForm1.RasterDisabled(const y: integer): Boolean;
begin

 //if t_mode(form1.SelectMode.ItemIndex) = m_piccolo then
 // Result:=(y and 7 = 0)
 //else
  Result:=(t_mode(form1.SelectMode.ItemIndex)=m_dli) or ((y and 7=0) and (t_mode(form1.SelectMode.ItemIndex)=m_gedp) and not(SpecialStr[___nobadlines].val));

end;


function NoBadLines: Boolean;
begin

 Result:=SpecialStr[___nobadlines].val and (t_mode(form1.SelectMode.ItemIndex)=m_gedp);

end;


function DLItoRaster: Boolean;
begin

 Result:=SpecialStr[___DLIchangesIn].val and (t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr, m_piccolo]);

end;


procedure UstawMode;
begin

 if NoBadLines then begin

  if (FSpecial.seLastChar.Position-FSpecial.seFirstChar.Position) <> Bajt then begin
   FSpecial.seFirstChar.Position:=0;
   FSpecial.seLastChar.Position:=Bajt;
  end;

  form1.ZnakCheck(ccStandard);
  WlaczZnaki(false);
  UseChar:=true;
 end else

// jesli ged- to nie beda uzywane znaki
 WlaczZnaki(t_mode(form1.SelectMode.ItemIndex) in [m_gedp,m_dli, m_piccolo]);

 form1.ustawMemo;

 StatusCharsets(zestaw+1);
end;


procedure resolution_info;
var c,r,p: string;
    ln: integer;
begin

 r:='WIDE';

 case form1.SelectScreen.ItemIndex of
  0: r:='NARROW';
  1: r:='NORMAL';
 end;

 if UseChar then
  r:=r+' / CHAR'
 else
  r:=r+' / BITMAP';

 ln:=bajt*Wysokosc;

 if t_video(form1.SelectVideo.ItemIndex)=vgtia then
  c:='GTIA'
 else begin
  c:='VBXE';

  inc(ln, (Bajt div (cmap_cellW shr 3))*(Wysokosc div cmap_cellH));
 end;

 p:='16';
 case Pixel of
  1: p:='2';
  2: p:='4';
 end;
 
 if t_video(form1.SelectVideo.ItemIndex)=vbxe then p:=p+' : '+IntToStr(cmap_cellW)+' x '+IntToStr(cmap_cellH);

 if Pixel > 0 then
   form1.StatusBar1.Panels[4].Text:='Image ('+c+' / '+r+'): '+IntToStr(Szerokosc div Pixel)+' x '+IntToStr(Wysokosc)+' x '+p+' ('+IntToStr(ln)+' bytes)';

 if t_video(form1.SelectVideo.ItemIndex)=vgtia then form1.StatusBar1.Panels[4].Text:=form1.StatusBar1.Panels[4].Text; //+' : '+IntToStr(hig);

end;


procedure StatusMode;
var a: string;
begin

 with form1 do begin

  case t_mode(SelectMode.ItemIndex) of

   m_gedp: if SpecialStr[___nobadlines].val then
            a:='GED + (DB)'
           else
            a:='GED +';

   m_gedm: a:='GED -';

    m_pgr: a:='PGR';

    m_piccolo: a:='PGR +';

    m_dli:
       if SpecialStr[___ModeDli].val then
        a:='DLI'
       else
        a:='DLI +';

  end;

  StatusBar1.Panels[2].Text:='Mode: '+a;
 end;

end;


procedure TForm1.StatusPreview;
var a: string;
begin

  prev:=t_preview(form1.SelectPreview.ItemIndex);

  case prev of
   ___PMG: begin
            a:='PMG';
            ini_zom.layer:=LayerPMG;
           end;

   ___BMP: begin
            a:='BMP';
            ini_zom.layer:=LayerBMP;
           end;

   ___ALL: begin
            a:='ALL';
            ini_zom.layer:=LayerALL;
           end;
  end;

  form1.StatusBar1.Panels[3].Text:='Preview: '+a;

end;


procedure ShowPixelHint;
begin

 if t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr] then
  form1.SelectPixel.Hint:='Pixel:'#13#10'1x1 = GRAPHICS 8   (OS)'#13#10+form1.SelectPixel.Items.Strings[1]+' = GRAPHICS 15 (OS)'#13#10+form1.SelectPixel.Items.Strings[2]+' = GTIA'
 else
  form1.SelectPixel.Hint:='Pixel:'#13#10'1x1 = GRAPHICS 2   (OS)'#13#10+form1.SelectPixel.Items.Strings[1]+' = GRAPHICS 12 (OS)'#13#10+form1.SelectPixel.Items.Strings[2]+' = GTIA';

end;


procedure SetMode;
begin

  form1.zamknij(f_Check);

  if SpecialStr[___ModeDli].val then begin
   form1.SelectMode.Items.Strings[1]:='DLI';
   Fox1:=false;
  end else begin
   form1.SelectMode.Items.Strings[1]:='DLI+';
   Fox1:=(t_mode(form1.SelectMode.ItemIndex)=m_dli);
  end;

  if SpecialStr[___doublescan].val then begin
   form1.SelectPixel.Items.Strings[1]:='2x2';
   form1.SelectPixel.Items.Strings[2]:='4x4';
  end else begin
   form1.SelectPixel.Items.Strings[1]:='2x1';
   form1.SelectPixel.Items.Strings[2]:='4x1';
  end;

  ShowPixelHint;

  form1.OdswiezObraz;
  form1.UstawKolory;

  StatusMode;

end;


procedure ClearMIC;
(*----------------------------------------------------------------------------*)
(* czysc obrazek                                                              *)
(*----------------------------------------------------------------------------*)
begin

 form1.ClrRect(img1, 0);

end;


procedure SpecialUpdate;
var t: integer;
begin

  form1.SelectScreenClick(nil);

  FSpecial.seFirstChar.Position := min_znakow;
  FSpecial.seLastChar.Position  := ile_znakow;

  if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin
   form1.SpecialVal(___ModeDLIplus, 1);   // DLI+ OFF
   form1.SpecialVal(___ModeDLI, 2);       // DLI  ON
  end;

  for t:=0 to length(SpecialStr)-1 do SpecialStr[t].val:=form1.SpecialVal(t, -1);

  if not(SpecialStr[___VisiblePMG].val) then form1.image4.Visible:=false;

  Grid( SpecialStr[___Grid].val );

  SetMode;

  if (gate>0) and not(Blokada) then begin
   ClearMic; form1.ShowMic; form1.Cnv
  end;

end;


procedure ZamknijBMPLimitations;
begin

 if form1.BMPLimitations1.Checked then
  with form1 do begin

   zamknij(f_EditBMP);

   Image4.Stretch:=true;
   Image4.Visible:=false;
   image4.Enabled:=true;

   image4.Width:=768;
   image4.Height:=480;

   image1.Cursor:=crDefault;

   BMPLimitations1.Checked:=false;

   ClrRectImage(image4, transCol);

   OdswiezObraz;

  end;

end;


procedure TForm1.MenuSpecialClick(Sender: TObject);
var t,l: integer;
    cApp: tCloseApp;
begin

 CloseRestoreApp(true, cApp);

 ZamknijBMPLimitations;

 SetFormPos('FSpecial', t,l);
 FSpecial.top:=t;
 FSpecial.left:=l;

 FSpecial.PageControl1.TabIndex:=0;

 for t := 0 to 7 do
  FSpecial.CheckListBox1.Checked[t] := row_limit and twyt1[t]<>0;

 if FSpecial.ShowModal=mrCancel then SpecialUpdate;

 UstawMode;
 OdswiezObraz;

 CloseRestoreApp(false, cApp);

end;


procedure TForm1.Sprawdz_Zaznaczenia(var i,j:integer);
begin
 if i+j>Wysokosc-1 then j:=Wysokosc-1-i;

 if i>Wysokosc-1 then i:=Wysokosc-1;
end;


procedure TForm1.Shape3_4Enable(const a: Boolean);
begin
 form1.Shape3.Visible:=a; form1.Shape4.Visible:=a;
 form1.Timer2.Enabled:=a;
end;


procedure TForm1.Usun_Zaznaczenia(const a: Boolean);
begin
 Shape1.Visible:=a; Shape2.Visible:=a;

 Shape3_4Enable(a);

 if not(a) then begin
  Shape1.Top:=pozY; Shape1.Left:=pozX; Shape1.Height:=0;
 end;

end;


procedure TForm1.Ustaw_Button2_7(var i,j: integer);
begin
 Shape3.Top:=i shl 1+pozY; Shape4.Top:=Shape3.Top+j shl 1;
end;


procedure TForm1.Ustaw_Button4_5(const s,d,i,j: integer);
begin

 if s>=0 then begin
  Shape1.Top:=s shl 1+pozY; Shape1.Height:=d shl 1+1;
  Shape2.Top:=s shl 1+pozY; Shape2.Height:=d shl 1+1;
 end;

 if i>=0 then begin
  Shape1.left:=i shl 1-pozX;
  Shape2.Left:=j shl 1-pozX;
 end;

end;


function TForm1.Str2Float(const a: string): real;
begin
 Result:=StrToFloat(a);
end;


procedure TForm1.FillDown1Click(Sender: TObject);
var i: integer;
    v: byte;
begin
 SaveAfterExit:=true; ZapiszUndo;

 v:=gfxMode[psOriginal.y shr 3];

 for i := psOriginal.y shr 3 to 29 do gfxMode[i]:=v;

 ustawMemo; OdswiezObraz;
end;


procedure TForm1.FillUp1Click(Sender: TObject);
var i: integer;
    v: byte;
begin
 SaveAfterExit:=true; ZapiszUndo;

 v:=gfxMode[psOriginal.y shr 3];

 for i := psOriginal.y shr 3 downto 0 do gfxMode[i]:=v;

 ustawMemo; OdswiezObraz;
end;
         

function TForm1.Float2Str(a: real): string;
begin
 Result:=FloatToStr(a);
end;


procedure TForm1.Zamknij(const f: t_Forms);
var i: integer;
begin

 for i:=0 to Screen.FormCount-1 do
  if (Screen.Forms[i].Tag=ord(f)) and (Screen.Forms[i].Visible) then begin
   Screen.Forms[i].Close;
   Break;
  end;

end;


function reg_labelR(const w: integer): AnsiString;
begin

 Result:=form1.Hex(w,4);

 if SpecialStr[___ShortLabels].val then exit;

 case w of
         $D010: Result:='trig0';        // stan przycisku joysticka 0 (O)
         $D011:	Result:='trig1';        // stan przycisku joysticka 1 (O)
 end;

end;


function TForm1.registry_label(const w: integer): AnsiString;
begin

 Result:='';

 case w of
  $d000..$d003: Result:='hposp'+AnsiString(IntToStr(w-$d000));
  $d004..$d007: Result:='hposm'+AnsiString(IntToStr(w-$d004));
  $d008..$d00b: Result:='sizep'+AnsiString(IntToStr(w-$d008));
         $d00c: Result:='sizem';
  $d00d..$d010: Result:='grafp'+AnsiString(IntToStr(w-$d00d));
         $d011: Result:='grafm';
  $d012..$d015: Result:='colpm'+AnsiString(IntToStr(w-$d012));
  $d016..$d019: Result:='color'+AnsiString(IntToStr(w-$d016));
         $d01a: Result:='colbak';
         $d01b: Result:='gtictl';
         $d01c: Result:='vdelay';
         $d01d: Result:='pmcntl';
         $d01e: Result:='hitclr';
         $d01f: Result:='consol';       // wyjatek dla CONSOL

         $d020: Result:='chrctl';

         $d20f: Result:='skctl';

         $d301: Result:='portb';

         $d400: Result:='dmactl';
         $d401: Result:='chrctl';
         $d402: Result:='dlptr';
         $d405: Result:='vscrol';
         $d407: Result:='pmbase';
         $d409: Result:='chbase';
         $d40a: Result:='wsync';
         $d40b: Result:='vcount';
         $d40e: Result:='nmien';
         $d40f: Result:='nmist';
 end;

end;


function TForm1.reg_label(w: integer): AnsiString;
begin

 if w=$d020 then w:=$d401;              // wyjatek dla CHRCTL

 if SpecialStr[___ShortLabels].val then
  Result:=Hex(w,4)
 else
  Result:=registry_label(w);

end;


function GED_reg_label(const a: integer): AnsiString;
begin
 Result:=form1.reg_label($d000+a);
end;


function TForm1.StatusXY(x: integer; const y, g: integer): string;
var v: byte;
begin

 if (g > 0) and (Pixel > 0) then begin

  dec(x, CzarnyPas div Pixel);

  if (x>=0) and (x < Szerokosc div Pixel) then begin
   Result:='(x: '+IntToStr((x*Pixel) div g)+'  y: '+IntToStr(y)+')  (c: '+IntToStr((x*Pixel) shr 3)+'  r: '+IntToStr(y shr 3)+')';

   v:=scren[CzarnyPas shr 3+(x*Pixel) shr 3+tmul48[y shr 3]];

   if UseChar then begin
    Result:=Result+'  #'+IntToStr(v and $7f);

    if v>127 then Result:=Result+'+128';
   end;

  end else
   Result:='(y: '+IntToStr(y)+')  (r: '+IntToStr(y shr 3)+')';

 end;

end;

{
function IntToStr(X: Integer; Width: Integer = 0): AnsiString;
begin
   Str(X: Width, Result);
end;
}


function TForm1.Hex(const a,b: integer): AnsiString;
begin
 Result:='$'+AnsiString(IntToHex(a,b));
end;


procedure TForm1.WriteUndoStream(var lStream: TMemoryStream);
var tmp: byte;
begin

 tmp:=ord(form1.tbSwap.Down);
 lStream.Write(tmp, sizeof(tmp));

 lStream.Write(gfxMode, sizeof(gfxMode));
 lStream.Write(newFnt, sizeof(newFnt));

 lStream.Write(tab, sizeof(tab));
 lStream.Write(old_zestaw,sizeof(old_zestaw));
 lStream.Write(fonty,sizeof(fonty));
 lStream.Write(tabKolor,sizeof(tabKolor));

 lStream.Write(Sprajt,sizeof(Sprajt));
 lStream.Write(SprajtX,sizeof(SprajtX));

 lStream.Write(Spr0,sizeof(Spr0));
 lStream.Write(Spr1,sizeof(Spr1));
 lStream.Write(Spr2,sizeof(Spr2));
 lStream.Write(Spr3,sizeof(Spr3));
 lStream.Write(Mis0,sizeof(Mis0));
 lStream.Write(Mis1,sizeof(Mis1));
 lStream.Write(Mis2,sizeof(Mis2));
 lStream.Write(Mis3,sizeof(Mis3));

 lStream.Write(Smask,sizeof(Smask));

 lStream.Write(raster,sizeof(raster));
 lStream.Write(raster_line_ofset,sizeof(raster_line_ofset));

 lStream.Write(scren,sizeof(scren));
 lStream.Write(locKolor,sizeof(locKolor));
 lStream.Write(invers,sizeof(invers));
 lStream.Write(invers2,sizeof(invers2));
 lStream.Write(bmp_limit,sizeof(bmp_limit));

 lStream.Write(tgtia,sizeof(tgtia));

 lStream.Write(upal,sizeof(upal));

 lStream.Write(rKolor,sizeof(rKolor));

 lStream.Write(cmap,sizeof(cmap));

 lStream.Write(chrctl_edit, sizeof(chrctl_edit));

 img1.SaveToStream(lStream);

end;


procedure TForm1.ReadUndoStream(var lStream: TMemoryStream);
var tmp: byte;
begin

 lStream.Read(tmp, sizeof(tmp));
 form1.tbSwap.Down:=(tmp=1);

 lStream.Read(gfxMode, sizeof(gfxMode));
 lStream.Read(newFnt, sizeof(newFnt));

 lStream.Read(tab,sizeof(tab));
 lStream.Read(old_zestaw,sizeof(old_zestaw));
 lStream.Read(fonty,sizeof(fonty));
 lStream.Read(tabKolor,sizeof(tabKolor));

 lStream.Read(Sprajt,sizeof(Sprajt));
 lStream.Read(SprajtX,sizeof(SprajtX));

 lStream.Read(Spr0,sizeof(Spr0));
 lStream.Read(Spr1,sizeof(Spr1));
 lStream.Read(Spr2,sizeof(Spr2));
 lStream.Read(Spr3,sizeof(Spr3));
 lStream.Read(Mis0,sizeof(Mis0));
 lStream.Read(Mis1,sizeof(Mis1));
 lStream.Read(Mis2,sizeof(Mis2));
 lStream.Read(Mis3,sizeof(Mis3));

 lStream.Read(Smask,sizeof(Smask));

 lStream.Read(raster,sizeof(raster));
 lStream.Read(raster_line_ofset,sizeof(raster_line_ofset));

 lStream.Read(scren,sizeof(scren));
 lStream.Read(locKolor,sizeof(locKolor));
 lStream.Read(invers,sizeof(invers));
 lStream.Read(invers2,sizeof(invers2));
 lStream.Read(bmp_limit,sizeof(bmp_limit));

 lStream.Read(tgtia,sizeof(tgtia));

 lStream.Read(upal,sizeof(upal));

 lStream.Read(rKolor,sizeof(rKolor));

 lStream.Read(cmap,sizeof(cmap));

 lStream.Read(chrctl_edit, sizeof(chrctl_edit));

 zomek.LoadFromStream(lStream);

end;


procedure addUndo;
var a, i: byte;
begin
 inc(undo_index);

 if undo_index>length(tUndo)-1 then begin

  a:=tUndo[0];

  for i := 0 to length(tUndo) - 2 do tUndo[i]:=tUndo[i+1];

  tUndo[length(tUndo)-1]:=a;

  undo_index:=length(tUndo)-1;
 end;

end;


procedure TForm1.ZapiszUndo;
var lStream: TmemoryStream;
begin

 if undo_redo then begin

  lStream := TMemoryStream.Create;

  WriteUndoStream(lStream);

  lStream.SaveToFile(GetUndoName('g2fundo'+IntToStr(tUndo[undo_index])+'.dat'));

  addUndo; // inc(undo_index);

  undo_index_max:=undo_index;

  EditRedo1.Enabled:=undo_index<undo_index_max;

  lStream.Free;

  EditUndo1.Enabled:=true;

 end;

end;


procedure CzytajUndo;
var lStream: TmemoryStream;
begin

 if undo_redo then begin

  if undo_index=0 then exit;

  dec(undo_index);

  lStream := TMemoryStream.Create;

  if FileExists(form1.GetUndoName('g2fundo'+IntToStr(tUndo[undo_index])+'.dat')) then
   lStream.LoadFromFile(form1.GetUndoName('g2fundo'+IntToStr(tUndo[undo_index])+'.dat'));

  if undo_index=0 then form1.EditUndo1.Enabled:=false;

  form1.EditRedo1.Enabled:=undo_index<undo_index_max;

  if undo_index=undo_index_max then form1.EditRedo1.Enabled:=false;    // !!! REDO wylaczalo niepotrzebnie

  form1.ReadUndoStream(lStream);

  lStream.Free;

 end;

end;


procedure ZapiszPath(const zm: string);
var INI:TINIFile;
    a: string;
    i, t,l: integer;
begin
 INI := TINIFile.Create(path+'g2f.ini');

// INI.WriteString('MADS','Path',MADS_PATH);
// INI.WriteString('EXOMIZER','Path',EXOMIZER_PATH);

 if ExtractFilePath(zm)<>'' then INI.WriteString('LastPath','Path','"'+zm+'"');

 if ExtractFilePath(palette_path)<>'' then INI.WriteString('Palette','Path','"'+palette_path+'"');

 if ExtractFilePath(mapa_path)<>'' then INI.WriteString('Maps','Path','"'+mapa_path+'"');

 if ExtractFilePath(charset_path)<>'' then INI.WriteString('Charset','Path','"'+charset_path+'"');

 INI.WriteInteger('Main','Screen', form1.SelectScreen.ItemIndex);
 INI.WriteInteger('Main','Mode', form1.SelectMode.ItemIndex);
 INI.WriteInteger('Main','Pixel', form1.SelectPixel.ItemIndex);
 INI.WriteInteger('Main','GTIA', form1.SelectGTIA.ItemIndex);
 INI.WriteInteger('Main','Video', form1.SelectVideo.ItemIndex);

 INI.WriteInteger('Palette','BlackLevel' ,pal_b);
 INI.WriteInteger('Palette','WhiteLevel' ,pal_w);
 INI.WriteInteger('Palette','Saturation' ,pal_s);
 INI.WriteInteger('Palette','ColorShift' ,pal_c);
 INI.WriteBool   ('Palette','Apply'      ,pal_extr);

 for i:=0 to length(SpecialStr)-1 do
  INI.WriteBool('Special', SpecialStr[i].nam, form1.SpecialVal(i, -1));

 INI.WriteInteger('Zoom','Width' ,ini_zom.w);
 INI.WriteInteger('Zoom','Height',ini_zom.h);
 INI.WriteInteger('Zoom','Top'   ,ini_zom.t);
 INI.WriteInteger('Zoom','Left'  ,ini_zom.l);
 INI.WriteInteger('Zoom','Factor',ini_zom.f);

 INI.WriteInteger('Zoom','hsPos',ini_zom.hs);
 INI.WriteInteger('Zoom','vsPos',ini_zom.vs);

 INI.WriteInteger('Zoom','FilSpr',FilSpr);
 INI.WriteInteger('Zoom','Pen',pisCol[0]);

 a:='n';  if ini_zom.s=wsMaximized then a:='m';
 INI.WriteString('Zoom','WindowState',a);

 INI.WriteBool    ('Zoom','Crosshair',ini_zom.c);

 INI.WriteBool    ('Zoom','GridEnabled',ini_zom.g);
 INI.WriteInteger ('Zoom','GridWidth'  ,grd_wid);
 INI.WriteInteger ('Zoom','GridHeight' ,grd_hig);
 INI.WriteBool    ('Zoom','GridColor' ,grd_col);

 INI.WriteBool    ('Zoom','Palette' ,ini_zom.p);

 INI.WriteInteger ('Zoom','PenSize'  ,PenS);

 INI.WriteInteger ('Zoom','Layer'  ,ord(ini_zom.layer));

 INI.WriteInteger('EditScreen','ycWidth' ,yel_wid);
 INI.WriteInteger('EditScreen','ycHeight',yel_hig);

 INI.WriteInteger('ColorsMap','cellWidth' ,cmap_cellW);
 INI.WriteInteger('ColorsMap','cellHeight',cmap_cellH);

 form1.RecentFile.SaveToIni(INI, 'Recent');

 INI.WriteBool('PMGFile', 'G2F', FSpecial.PmgG2f.Checked);
 INI.WriteBool('PMGFile', 'Atari', FSpecial.PmgAtari.Checked);
 INI.WriteBool('PMGFile','All' ,FSpecial.All.Checked);

 for i := 0 to length(lpmg_checkbox)-1 do
  INI.WriteBool   ('PMGFile', 'Checkbox'+IntToStr(i) , lpmg_checkbox[i].Checked);

 INI.WriteBool    ('AllFile', 'Missiles' , FSpecial.Missiles.Checked);
 INI.WriteBool    ('AllFile', 'ColBak'   , FSpecial.Colbak.Checked);
 INI.WriteBool    ('AllFile', 'Charsets' , FSpecial.Charsets.Checked);

 for i := 0 to length(sdat_checkbox)-1 do
  INI.WriteBool   ('AllFile', 'Checkbox'+IntToStr(i) , sdat_checkbox[i].Checked);

 for i:=0 to length(FormPos)-1 do begin
  form1.SetFormPos(FormPos[i].nam, t,l);

  INI.WriteInteger(FormPos[i].nam,'Top' , t);
  INI.WriteInteger(FormPos[i].nam,'Left', l);
 end;

 INI.Free;
end;


function tstPos(x,y: integer): TPoint;
begin

 if x<0 then x:=0;
  if x>CzarnyPas+Szerokosc then x:=CzarnyPas+Szerokosc;

 if y<0 then y:=0;
 if y>Wysokosc-1 then y:=Wysokosc-1;

 tstPos:=Point(x,y);
end;


function NormalizeYPos(y: integer): integer;
var i,j, k: integer;
    ok: Boolean;
begin

 i:=y shr 3;
 j:=y mod 8;

 ok:=false;

 for k := j to 7 do
  if row_limit and twyt1[k]<>0 then begin ok:=true; Break end;

 if not(ok) then
  for k := j downto 0 do
   if row_limit and twyt1[k]<>0 then Break;

 Result := i shl 3 + k;
 
end;


procedure DrawMarquee(var mStart, mStop: TPoint);
(*----------------------------------------------------------------------------*)
(* zaznaczamy obszar LINE:RANGE                                               *)
(*----------------------------------------------------------------------------*)
var a, i, j: integer;
    start, stop: integer;
begin

 if not(mStop.Y>=mStart.Y) then mStop.Y:=mStart.Y;

 start:=mStart.Y;
  stop:=mStop.Y-mStart.Y;

 if form1.BMPLimitations1.Checked then begin


 end;

 if FMove.Visible then begin
  i:=(mStart.X{+CzarnyPas}) shr 3;
  j:=(mStop.X{+CzarnyPas}) shr 3;

  if not(j>i) then begin a:=i; i:=j-1; j:=a end;
  if i<(CzarnyPas shr 3) then i:=CzarnyPas shr 3;

   with FMove do begin
    frameLineRange1.seLine.Position:=start;
    frameLineRange1.seRange.Position:=stop;

    udLeft.Position:=i;
    udRight.Position:=j;
   end;

  end;

  if FEditColors.Visible then begin
   FEditColors.frameLineRange1.seLine.Position:=NormalizeYPos(start);
   FEditColors.frameLineRange1.seRange.Position:=stop;
  end;

  if FEditPMG.Visible then begin
   FEditPMG.frameLineRange1.seLine.Position:=NormalizeYPos(start);
   FEditPMG.frameLineRange1.seRange.Position:=stop;
  end;

  if FEditRasters.Visible then begin
   FEditRasters.frameLineRange1.seLine.Position:=NormalizeYPos(start);
   FEditRasters.frameLineRange1.seRange.Position:=stop;
  end;

  if FEditPalette.Visible then begin
   FEditPalette.frameLineRange1.seLine.Position:=NormalizeYPos(start);
   FEditPalette.frameLineRange1.seRange.Position:=stop;
  end;

  if FEditCharset.Visible then form1.image1.Refresh;       // !!! koniecznie aby bylo widac stawiane znaki
end;


procedure TForm1.set_pf_colors;
var i: byte;
begin
 for i:=Wysokosc-1 downto 0 do FEditColors.SetColLine(i);
end;


procedure TForm1.set_pm_colors;
var i: byte;
begin
 for i:=Wysokosc-1 downto 0 do FEditPMG.SetColLineSpr(i);
end;


procedure TForm1.UstawKolory;
begin

 if FEditPMG.Visible then
  set_pm_colors
 else
  if FEditColors.Visible then
   set_pf_colors
  else
   if prev=___pmg then set_pm_colors else set_pf_colors;
   
end;


procedure ClearKolor;
var i, j: integer;
begin

 if form1.SelectPixel.ItemIndex=0 then begin
  fillchar(tabKolor[$000],256,$00);
  fillchar(tabKolor[$100],256,$00);
  fillchar(tabKolor[$200],256,$0e);
  fillchar(tabKolor[$300],256,$00);
  fillchar(tabKolor[$400],256,$00);
 end else begin
  fillchar(tabKolor[$000],256,$00);
  fillchar(tabKolor[$100],256,$04);
  fillchar(tabKolor[$200],256,$06);
  fillchar(tabKolor[$300],256,$08);
  fillchar(tabKolor[$400],256,$0e);
 end;

 fillchar(tabKolor[$500],256,$04);
 fillchar(tabKolor[$600],256,$06);
 fillchar(tabKolor[$700],256,$08);
 fillchar(tabKolor[$800],256,$0e);


 for j := 0 to 239 do
  for i := 0 to 47 do begin
   cmap[i,j].c[0]:=tabKolor[$100];
   cmap[i,j].c[1]:=tabKolor[$200];
   cmap[i,j].c[2]:=tabKolor[$300];
   cmap[i,j].status:=0;
   cmap[i,j].i:=0;
  end;

 form1.ClrRectImage(form1.image6, clBtnFace);

 form1.set_pf_colors;
end;


procedure UstawPixel;
begin

  case form1.SelectPixel.ItemIndex of
   0: Pixel:=1;
   1: Pixel:=2;
   2: Pixel:=4;
  end;

end;


procedure UstawGfxMode(const a: byte);
begin
 fillchar(gfxMode,sizeof(gfxMode),a);

// if UseChar then gfxMode[29]:=2;

 form1.ustawMemo;
end;


procedure SetTable;
var f, i, x, y, ze, ofs: byte;
    hlp: integer;
begin

// sprawdz czy TABLE zawiera wartosci
i:=$ff; for x:=29 downto 0 do i:=i and table[x];

if i=$ff then begin

// tutaj domyslne wartosci dla STANDARD

 ze:=0; f:=0;
 for y:=0 to 29 do begin
  table[y]:=ze;

  inc(f,Bajt);
  inc(ze,ord(f>127));
  f:=f and $7f;
 end;

end;


form1.UstawMemo;


ofs:=CzarnyPas shr 3;
for y:=0 to 29 do begin
ze:=table[y];
 for x:=0 to bajt-1 do begin
  f:=0;

//  if _skp then
   if (invers[ofs+x+tmul48[y]]>127) and (gfxMode[y]<>2) then begin
    f:=$ff;
    hlp:=ofs+x+tmul48[y];
    invers[hlp]:=invers[hlp] xor $80;
    scren[hlp]:=scren[hlp] and $7f;
   end;

  for i:=0 to 7 do tab[ofs+x+tmul48[i+y shl 3]]:=fonty[ze shl 10+(scren[ofs+x+tmul48[y]] and $7f) shl 3+i] xor f;
 end;
end;

StatusCharsets(ze+1);

zestaw:=ze;
end;


procedure TForm1.ClrTable;
begin
 fillchar(table,sizeof(table),$ff);        // !!! koniecznie wartosc $FF !!!
end;


procedure UstawScreen;
var i, j, k: byte;
begin

 form1.ClrTable;
 SetTable;

 k:=0;

 for j:=0 to 29 do
  for i:=0 to Bajt-1 do begin
   scren[CzarnyPas shr 3+i+tmul48[j]]:=k;
   inc(k); k:=k and $7f;
  end;

 move(scren,invers,sizeof(scren));
end;


procedure TForm1.ZamienGrafike;
begin
 cnv;
 OdswiezObraz;
end;


procedure TForm1.ShowChars(const min,max:byte; const yes:Boolean);
(*----------------------------------------------------------------------------*)
(* wyswietla wiersze ekranu z przedzialu <MIN..MAX>                           *)
(*----------------------------------------------------------------------------*)
var x, y, i, w: integer;
    a, b, maska, maska2: byte;
    K: PRGBQuad;
begin

cnv;

if not(showchars1.Checked) then begin

 if yes then begin
  OdswiezObraz;
  exit;
 end;

end else begin

with img1.Canvas do
 for y:=min to max do begin

  for i:=0 to 47 do begin
   maska:=0;
   maska2:=0;

   b:=scren[i+tmul48[y]];

   if b>127 then begin b:=b and $7f; maska:=$ff; end;
   if invers2[i+tmul48[y]]>127 then maska2:=$ff;

   for x:=0 to 7 do begin

    K:=img1.ScanLine[x+y*8];

    if (x>3) and Fox1 then
     a:=AtariFnt[b shl 3+x] xor Maska2
    else
     a:=AtariFnt[b shl 3+x] xor Maska;

    for w:=0 to 7 do
     scan_pixel(K, w+i*8, ord(a and twyt1[w]=0) * GetSysColor(COLOR_BTNFACE) * ord(gfxMode[y]<>0) );

   end;

  end;

 end;

// image1.Picture.Bitmap:=img1;
// image1.Canvas.Draw(0,0,img1);
 image1.Picture.Graphic:=img1;

end;

end;


procedure TForm1.fCRC(var crc_:cardinal; const v:byte);
var l: cardinal;
    b: byte;
begin
 b:=(crc_ and $ff) xor v;
 l:=(crc_ shr 8) and $00ffffff;
 crc_:=tcrc32[b] xor l;
end;


function TForm1.Sofs(const x: byte; const y: integer): integer;
(*----------------------------------------------------------------------------*)
(* liczymy ofset do tablicy                                                   *)
(*----------------------------------------------------------------------------*)
begin
 Result := CzarnyPas shr 3 + X + Y;
end;


function TForm1.GetScanRatio(const y: byte): byte;
begin

 Result:=$ff;

  if SpecialStr[___doublescan].val then
   case gfxMode[y] of
    2: Result:=$fe;
    4: Result:=$fc;
   end;

end;


function CharAllowed(znak, zestaw: byte): Boolean;
var i: integer;
    a: word;
begin

 Result:=true;

 a:=znak + zestaw shl 8;

 for i := High(BMPLimitBuf)-1 downto 0 do
  if BMPLimitBuf[i] = a then begin Result:=false; Break end;   

end;


function TForm1.Test(const v:cardinal; const wx:integer; var znak:byte; const charset:byte): byte;
(*----------------------------------------------------------------------------*)
(* sprawdza czy znak jest w zestawie znakow                                   *)
(*----------------------------------------------------------------------------*)
var x, j, k: integer;
    crc: cardinal;
    hit, bitInv: Boolean;
    _and, i: byte;
begin

x:=Sofs(wx mod bajt , tmul48[wx div bajt] shl 3);

while not(chlimit[znak]) and (znak<=ile_znakow) do inc(znak);

Result:=znak;

hit:=false;           //czy znalazl identyczny znak
BitInv:=false;        //znak z inversem

//tryb 0 to Normal
//tryb 1 to Optymizing

//znak bez inversu

if tryb=1 then
// if znak>0 then
  for j:=min_znakow to znak-1 do
  if CharAllowed(j, charset) then begin
   crc:=$ffffffff;

   for i:=0 to 7 do fCRC(crc, fonty[charset shl 10+j shl 3+i]);

   if v=crc then begin Result:=j; hit:=true; Break end;
  end;

if not(hit) and (gfxMode[wx div bajt]<>2) then begin

 if tryb=1 then
// if znak>0 then
  for j:=min_znakow to znak-1 do
  if CharAllowed(j, charset) then begin

   crc:=$ffffffff;

   for i:=0 to 7 do fCRC(crc, fonty[charset shl 10+j shl 3+i] xor $ff);

   if v=crc then begin Result:=j; hit:=true; bitInv:=true; Break end;
  end;

end;


 if bmp_limit[Sofs(wx mod bajt,0), wx div bajt] then begin

  k:=High(BMPLimitBuf);
  BMPLimitBuf[k] := znak + charset shl 8;

  SetLength(BMPLimitBuf, k+2);

  hit:=false; bitInv:=false;
 end;


// wstaw nieznany znak A do zestawu znakow
 if not(hit) then begin
  Result:=znak;

  _and:=GetScanRatio(wx div Bajt);

  if not(bitInv) then begin
   if znak<128 then
    for i:=0 to 7 do fonty[charset shl 10+Znak shl 3+i]:=tab[x+tmul48[i and _and]];

   inc(znak);

   while not(chlimit[znak]) and (znak<=ile_znakow) do inc(znak);

  end;

 end;

 inv:=0;
 if bitInv then
  inv:=$80
 else
  if invers[Sofs(wx mod bajt, tmul48[wx div bajt])]>127 then inv:=$80;

end;


function TForm1.Fnt(const wx: integer): cardinal;
(*----------------------------------------------------------------------------*)
(* konwersja grafiki na zestaw znakow Atari                                   *)
(*----------------------------------------------------------------------------*)
var x: integer;
    crc: cardinal;
    _and, i: byte;
begin
 x:=Sofs(wx mod bajt , tmul48[wx div bajt] shl 3);

 crc:=$ffffffff;

 _and:=GetScanRatio(wx div Bajt);

 for i:=0 to 7 do fCRC(crc, tab[x+tmul48[i and _and]]);

 Result:=crc;
end;


procedure ClearCnv;
begin
// fillchar(invers,sizeof(invers),0);
// fillchar(invers2,sizeof(invers2),0);

 fillchar(fonty, sizeof(fonty), 0);
 fillchar(scren, sizeof(scren), 0);
 form1.ClrTable;
end;


procedure PoKonwersji;
begin

with form1 do begin

 if t_mode(SelectMode.ItemIndex) in [m_gedp,m_dli, m_piccolo] then begin
  EditCharset.Enabled:=true;
  charsfill1.Enabled:=true;
  showchars1.Enabled:=true;
 end;

 SaveData1.Enabled:=true;
 SaveASM1.Enabled:=true;
 Zoom.Enabled:=true;
 SelectMode.Enabled:=true;

// ChangeColors.Enabled:=true;
// showchars1.Checked:=false;
 charsfill1.Checked:=false;

end;

end;


function ileFnt(const zest: byte): smallint;
(*----------------------------------------------------------------------------*)
(* zlicza znaki w zestawie                                                    *)
(*----------------------------------------------------------------------------*)
var poz, x,y, a: integer;
begin
 Result:=-1;

 for y:=0 to 29 do
  if table[y]=zest then
   for x:=0 to bajt-1 do begin
    poz:=form1.Sofs(x,tmul48[y]);
    a:=scren[poz] and $7f;
    if a>Result then Result:=a;
   end;

 if Result<0 then
  Result:=0
 else
  inc(Result);

end;


function TForm1.CharsFill: string;
(*----------------------------------------------------------------------------*)
(* pokaz ile znakow zostalo uzytych w zestawie                                *)
(*----------------------------------------------------------------------------*)
var x, a: byte;
    txt, zm: string;
begin

if resetujFonty then begin
 form1.cnv;

 form1.zamknij(f_ExportAs);

 FExportAs.Button4.Caption:='Export (0)';
 FExportAs.Button4.Hint:='0 charsets';
end;

Result:='';

if done>0 then begin

 for x:=0 to 29 do begin
  a:=ileFnt(x);

//  if (a>0) then inc(a);  // zwieksz o 1 aby wynik byl prawidlowy

  chFill[x]:=a;

  str(a,zm);
  while length(zm)<3 do zm:='0'+zm;

  str(x,txt);
  while length(txt)<2 do txt:='0'+txt;

  Result:=Result+' Charset #'+txt+'   '+zm;
  if x<>29 then Result:=Result+#13#10;
 end;

end;

end;


procedure TForm1.ShowChars1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* Show chars                                                                 *)
(*----------------------------------------------------------------------------*)
begin

//if done>0 then
 form1.SelectPreview.ItemIndex:=ord(___ALL);

 ShowColorsMap1.Checked:=false;

 with form1 do
  if not(Showchars1.Checked) then begin

   ZamknijBMPLimitations;

   Showchars1.Checked:=true;
   ShowChars(0,29,false);
  end else
   OdswiezObraz;

end;


procedure TForm1.ShowColorsMap1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* SHOW COLORS MAP                                                            *)
(*----------------------------------------------------------------------------*)
var i, j, ofs: integer;
begin

 with form1 do
  if not(ShowColorsMap1.Checked) then begin
   ShowColorsMap1.Checked:=true;

   ofs:=CzarnyPas div cmap_cellW;

   for j := 0 to (Wysokosc div cmap_cellH)-1 do
    for i := 0 to (Szerokosc div cmap_cellW)-1 do
     with img1.Canvas do begin
      Brush.Color:=AtariPal[cmap[i+ofs,j].c[select_cmap_color]];
      FillRect(Rect((i+ofs)*cmap_cellW, j*cmap_cellH, (i+ofs)*cmap_cellW+cmap_cellW, j*cmap_cellH+cmap_cellH));
     end;

   image1.Picture.Graphic:=img1;

  end else begin
   OdswiezObraz;
   ShowColorsMap1.Checked:=false;
  end;

end;


procedure fnt2buf;
var b, a2, i: byte;
    vx: integer;
begin
// fonty na grafike, jesli ktos cos dorysowal to zmazemy to
 for b:=0 to 29 do begin
  vx:=table[b] shl 10;
  for a2:=0 to  bajt-1 do
   for i:=0 to 7 do tab[form1.Sofs(a2,tmul48[i+b shl 3])] := fonty[vx+(scren[form1.Sofs(a2,tmul48[b])] and $7f) shl 3+i];
 end;

end;


procedure TForm1.optymizing(maks: integer; nr: byte; reset: Boolean = true);
var vx, row, col: integer;
    v, znak, charset: byte;
    cntCharset: array [0..255] of Boolean;
begin

if reset then zestaw:=0;

SetLength(BMPLimitBuf, 1);

if maks=0 then
 case bajt of
  40: maks:=1200;
  48: maks:=1440;
 else
  maks:=960;
 end;

 fillchar(cntCharset, sizeof(cntCharset), false);

vx:=0;

while vx<maks do begin

col:=vx mod Bajt;
row:=vx div Bajt;

 if col=0 then              // sprawdz czy ma wystapic wymuszenie nowego zestawu
  if newFnt[row]<>0 then begin

   if row>0 then
    nr:=table[row-1]+1
   else
    nr:=table[row]+1;

  end else
   if startCharset[row]>0 then nr:=startCharset[row]-1;


 charset:=nr;

 znak:=ileFnt(charset); if znak=0 then znak:=min_znakow;

 while charset<128 do begin

   v:=form1.test(form1.fnt(vx) ,vx, znak, charset);

   scren[form1.Sofs(vx mod Bajt, tmul48[row])]:=v or inv;
   table[row]:=charset;

   if not(cntCharset[charset]) then begin
    cntCharset[charset]:=true;
    inc(zestaw);
   end;

   inc(vx);

   if v>ile_znakow then begin
    vx:=(row*bajt);

    inc(charset);
    znak:=ileFnt(charset); if znak=0 then znak:=min_znakow;

   end else
    if vx mod Bajt=0 then Break;

   if charset>127 then begin
    Application.MessageBox('Invalid charset limitations parameters','Optymizing',MB_ICONEXCLAMATION);
    FSpecial.seFirstChar.Position:=0;
    FSpecial.seLastChar.Position:=127;
    fillchar(chlimit, sizeof(chlimit), true);
    exit;
   end;

   if FSpecial.ChrOpty.ItemIndex=0 then
    nr:=charset;                                // Optymizing Normal
//   else
//    nr:=0;

 end;

end;

end;


procedure JGPpCharset(const nr: byte);
var i: byte;
begin

  move(temp_tab, tab, sizeof(tab)); // przywracamy bufor obrazu

  for i:=0 to 29 do
   if i mod JGPplusCharset <> nr then move(bufor, tab[i*384], 384);

  form1.optymizing(0,0);

end;


procedure ClrJGPplusCharsetCheck;
begin

 form1.JGP2.Checked := false;

 form1.Charsetx2.Checked:=false;
 form1.Charsetx3.Checked:=false;
 form1.Charsetx4.Checked:=false;
 form1.Charsetx5.Checked:=false;
 form1.Charsetx6.Checked:=false;
 form1.Charsetx7.Checked:=false;
 form1.Charsetx8.Checked:=false;

end;


procedure TForm1.Cnv;
var a, crc: cardinal;
    vx, ad, ze: integer;
    tmp: string;
    tst, i, b, j, ix, v: byte;
    chkCharset: array [0..128] of cardinal;
    chkRow: array [0..47] of cardinal;
    chkChar: array [0..47] of byte;
    tjgp: array [0..2047] of byte;
begin

if FEditCharset.Focused then exit;

// musi byc wybrany jeden z nich
tryb:=$ff;

if Showchars1.Checked then
 if FEditBMP.Visible then ShowChars1Execute(self);

if Normal1.Checked then tryb:=0 else
 if Optymizing1.Checked then tryb:=1 else
//  if Original1.Checked then tryb:=2 else
   if Jgp1.Checked then tryb:=3 else
    if Jgp2.Checked then tryb:=4;

zamknij(f_CharsFill);


(*----------------------------------------------------------------------------*)
(* JGP +                                                                      *)
(*                                                                            *)
(* dwa zestawy znakow przelaczane co wiersz w wersji OPTYMIZING               *)
(*----------------------------------------------------------------------------*)

if tryb=4 then begin

  PoKonwersji; ClearCnv;

  fillchar(bufor, sizeof(bufor), 0);

  move(tab, temp_tab, sizeof(tab));
  

  for v:=0 to JGPplusCharset-1 do begin

   tryb:=1;

   fillchar(scren, sizeof(scren), 0);      // koniecznie, aby ileFNT dzialalo

   JGPpCharset(v);

   move(fonty, fonty_tmp[v*1024], 1024);
   move(scren, fonty_tmp[8192+v*1440], 1440);

  end;


  if zestaw > JGPplusCharset-1 then begin
    Application.MessageBox('Conversion of bitmap into JGP+ failed.','JGP+',MB_ICONEXCLAMATION);

    ClrJGPplusCharsetCheck;

    move(temp_tab, tab, sizeof(tab)); // przywracamy bufor obrazu
    ZnakCheck(ccOptymizing);

    v:=0;
  end;


  if v=JGPplusCharset then begin

    move(fonty_tmp, fonty, v*1024);

    for j:=0 to v-1 do
     for i:=0 to 29 do
      if (i mod JGPplusCharset) = j then move(fonty_tmp[8192+j*1440+tmul48[i]], scren[tmul48[i]], 48);


    for j:=0 to 29 do                 // uzupelniamy SCREN o invers
     for i:=0 to 47 do begin
      ad:=i+tmul48[j];
      if invers[ad]>$7f then scren[ad]:=scren[ad] or $80;
     end;

    for i:=0 to 29 do table[i]:=i mod JGPplusCharset;

    move(temp_tab, tab, sizeof(tab)); // przywracamy bufor obrazu

    zestaw:=JGPplusCharset-1;

    tryb:=4;                          // koniecznie przywracamy TRYB=4

  end;

end;


(*----------------------------------------------------------------------------*)
(* J-et G-raphics P-lanner                                                    *)
(*                                                                            *)
(* uzywane sa tylko dwa zestawy znakow, znak w JGP sklada sie z 4-ech znakow  *)
(* 2 w poziomie w linii pierwszej i 2 w poziomie w linii drugiej              *)
(* kody znakow w linii pierwszej i drugiej sa identyczne, pierwszy znak ma    *)
(* wartosc parzysta                                                           *)
(*----------------------------------------------------------------------------*)

if tryb=3 then begin

PoKonwersji; ClearCnv;

 v:=0;

 for j:=0 to 14 do begin

  ad:=tmul48[j shl 1] shl 3;

  for b:=0 to (Bajt shr 1)-1 do begin
   crc:=$ffffffff;
   for i:=0 to 15 do fCRC(crc,tab[CzarnyPas shr 3+b shl 1+ad+tmul48[i]]);
   for i:=0 to 15 do fCRC(crc,tab[CzarnyPas shr 3+b shl 1+1+ad+tmul48[i]]);

   tst:=$FF;
   if v>0 then
    for i:=0 to v-1 do
     if chkCharset[i]=crc then begin tst:=i; Break end;

   if tst=$FF then begin
    chkCharset[v]:=crc;

    for i:=0 to 15 do begin
     tjgp[v shl 5+i]:=tab[CzarnyPas shr 3+b shl 1+ad+tmul48[i]];
     tjgp[v shl 5+16+i]:=tab[CzarnyPas shr 3+b shl 1+1+ad+tmul48[i]];
    end;

    scren[CzarnyPas shr 3+b shl 1+tmul48[j shl 1]]:=v shl 1;
    scren[CzarnyPas shr 3+b shl 1+1+tmul48[j shl 1]]:=v shl 1+1;
    scren[CzarnyPas shr 3+b shl 1+tmul48[j shl 1]+48]:=v shl 1;
    scren[CzarnyPas shr 3+b shl 1+1+tmul48[j shl 1]+48]:=v shl 1+1;

    for i:=0 to 7 do begin
     fonty[v shl 4+i]:=tjgp[v shl 5+i];
     fonty[v shl 4+8+i]:=tjgp[v shl 5+16+i];

     fonty[1024+v shl 4+i]:=tjgp[v shl 5+8+i];
     fonty[1024+v shl 4+8+i]:=tjgp[v shl 5+24+i];
    end;

    inc(v);
   end else begin
    scren[CzarnyPas shr 3+b shl 1+tmul48[j shl 1]]:=tst shl 1;
    scren[CzarnyPas shr 3+b shl 1+1+tmul48[j shl 1]]:=tst shl 1+1;
    scren[CzarnyPas shr 3+b shl 1+tmul48[j shl 1]+48]:=tst shl 1;
    scren[CzarnyPas shr 3+b shl 1+1+tmul48[j shl 1]+48]:=tst shl 1+1;

    for i:=0 to 7 do begin
     fonty[tst shl 4+i]:=tjgp[tst shl 5+i];
     fonty[tst shl 4+8+i]:=tjgp[tst shl 5+16+i];

     fonty[1024+tst shl 4+i]:=tjgp[tst shl 5+8+i];
     fonty[1024+tst shl 4+8+i]:=tjgp[tst shl 5+24+i];
    end;

   end;

  end;

  if v>63 then Break;
 end;

 if v>63 then begin
  Application.MessageBox('Conversion of bitmap into JGP failed.','JGP',MB_ICONEXCLAMATION);

  ZnakCheck(ccOptymizing);
  tryb:=1;                    // wymuszamy OPTYMIZING
 end else begin

  for j:=0 to 29 do           // uzupelniamy SCREN o invers
   for i:=0 to 47 do begin
    ad:=i+tmul48[j];
    if invers[ad]>$7f then scren[ad]:=scren[ad] or $80;
   end;

  for i:=0 to 29 do table[i]:=i and 1;

  zestaw:=1;
 end;

end;


(*----------------------------------------------------------------------------*)
(* ORIGINAL                                                                   *)
(*                                                                            *)
(* kazdy znak jest oryginalny, znak przyjmuje ostatnio zdefiniowany ksztalt   *)
(*----------------------------------------------------------------------------*)
{
if tryb=2 then begin

// zamieniamy grafike na odpowiednie znaki, zestawy znakow sa zablokowane
// dla modyfikacji (ORIGINAL)

 for j:=0 to 29 do begin

 ze:=table[j] shl 10;

 for b:=0 to 127 do begin
  crc:=$ffffffff;
  for i:=0 to 7 do fCRC(crc,fonty[ze + b shl 3+i]);
  chkCharset[b]:=crc;
 end;

// teraz sprawdzamy wiersz ekranu i zamieniamy go na znaki
 for b:=0 to Bajt-1 do begin
  crc:=$ffffffff;
  for i:=0 to 7 do fCRC(crc,tab[Sofs(b,tmul48[i+j shl 3])]);

  for v:=0 to 127 do if crc=chkCharset[v] then Break;

  if crc=chkCharset[v] then begin
   ad:=Sofs(b,tmul48[j]);

   scren[ad]:=v or (invers[ad] and $80);
  end;

 end;

 end;

 fnt2buf;

 ShowMic;


(*----------------------------------------------------------------------------*)
(* OPTYMIZING, STANDARD                                                       *)
(*----------------------------------------------------------------------------*)

end else} if tryb<2 then begin          // OPTYMIZING, STANDARD

 PoKonwersji; ClearCnv;

 optymizing(0,0);

end;


// ile zestawow zostalo uzytych, musimy to zrobic, inaczej zostanie zapisana
// niewlasciwa liczba fontow do pliku G2F
zestaw:=0;
for vx:=0 to 29 do if table[vx]>zestaw then zestaw:=table[vx];


if UseChar then StatusCharsets(zestaw+1);

done:=1; ustawMemo;
end;


function piksel(const b: byte):Boolean;
var m1, m2, i: byte;
begin

piksel:=false; m1:=$ff; m2:=$ff;

for i:=0 to 9 do begin
 if pik=tprior[i] then m1:=i;
 if b=tprior[i] then m2:=i;
end;

if m2<=m1 then begin piksel:=true; pik:=b; end;
end;


function tPM(const pmx,pmy: integer; const a: byte): Boolean;
begin

 Result := (Sprajt[pmy, pmx] and a=a) and (SprajtX[pmy, pmx] and a=a);

end;


procedure testMLC(const pmx,pmy: integer; const s: byte; var cl:byte);
// s = 0,2,4,6 - players
// s = 1,3,5,7 - missiles
begin

        case s of
         0..3:
           begin
                                                                  // P0 + P1
            if tPM(pmx,pmy, $05) then cl:=tb[5] or tb[6];

            if not(ply5) then                                     // M0 + M1
             if tPM(pmx,pmy, $0a) or tPM(pmx,pmy, $09) or tPM(pmx,pmy, $06) then
              cl:=tb[5] or tb[6];

           end;

        4..7:
           begin
                                                                  // P2 + P3
            if tPM(pmx,pmy, $50) then cl:=tb[7] or tb[8];

            if not(ply5) then                                     // M2 + M3
             if tPM(pmx,pmy, $a0) or tPM(pmx,pmy, $90) or tPM(pmx,pmy, $60) then
              cl:=tb[7] or tb[8];

           end;

        end;

end;


procedure NewColorTab(const x,y: integer);
var w: byte;
begin

 if (t_mode(form1.SelectMode.ItemIndex)=m_dli) or ((t_mode(form1.SelectMode.ItemIndex) in [m_gedp, m_piccolo]) and (y and 7=0)) then begin
  tb[0]:=rKolor[y, 0];
  tb[1]:=rKolor[y, 1];
  tb[2]:=rKolor[y, 2];
  tb[3]:=rKolor[y, 3];
  tb[4]:=rKolor[y, 4];
  tb[5]:=rKolor[y, 5];
  tb[6]:=rKolor[y, 6];
  tb[7]:=rKolor[y, 7];
  tb[8]:=rKolor[y, 8];

  tb[9]:=rKolor[y, 9];

 end else begin
  for w := 0 to 8 do tb[w]:=RasterLine[x].kolor[w];

  tb[9]:=RasterLine[x].gtia;
 end;

end;


function TForm1.testPixel(x:integer; const c,s,p, pm:byte): TColor;
(*----------------------------------------------------------------------------*)
(* liczymy kolor piksla ducha na grafice HiRes                                *)
(* informacja o wartosci piksla P=0..1                                        *)
(*----------------------------------------------------------------------------*)
var k, v: byte;
    w: integer;
begin

 inc(x,CzarnyPas);

 NewColorTab(x,py);

 w:=c+5;
 if ply5 and (s>3) then w:=4; //w:=$400;

 v:=tb[w];

 k:=v and $f0;          //kolor PMG
// j:=v and $0f;          //jasnosc PMG


 if MLCpmg then begin
  testMLC(x shr 1, py, pm, v);
  k:=v and $f0;
 end;


 if prev>___PMG then begin
 // piksel PMG zgaszony (710)
  temp[0]:=v;

 // piksel PMG zapalony (709)
  if (t_mode(form1.SelectMode.ItemIndex)=m_dli) {or ((t_mode(form1.SelectMode.ItemIndex)=m_gedp) and (py and 7=0))} then
   temp[1]:=k or (tabKolor[$200+py] and $0f)
  else
   temp[1]:=k or (RasterLine[x].kolor[1] and $0f);

 end else begin
  temp[0]:=v;
  temp[1]:=v;
 end;


// 0,1,2,3 - players
// 4,5,6,7 - missiles
 if (FEditPMG.GetPrior(py)=4) and (s in [2,3, 6,7]) and not(ply5 and (s>3)) then begin          // priority=0
  temp[0]:=temp[0] or (tb[3] and $0f);
  temp[1]:=temp[1] or (tb[2] and $0f);
 end;

 Result:=AtariPal[temp[p]];

end;


function TForm1.testPixel2(const pmx: integer; const s,v: byte; const y:integer): TColor;
(*----------------------------------------------------------------------------*)
(* liczymy kolor piksla ducha na grafice LoRes                                *)
(* !!! V = aktualna wartosc pixla [0..15] !!!                                 *)
(*----------------------------------------------------------------------------*)
var w: integer;
    c, p: byte;
begin

 NewColorTab(px+CzarnyPas,y);               // !!! globalna zmienna PX !!!

 p:=FEditPMG.GetPrior(y);

 c:=s shr 1;          // s = 0,2,4,6 - players
                      // s = 1,3,5,7 - missiles

 w:=c+5;

// jesli jest player5 to pociski przyjma kolor 711
 if ply5 and (s and 1>0) then w:=4; //w:=$400;

 c:=tb[w];

 if MLCpmg then
  testMLC(pmx,y, s, c);


 if p=4 then begin         // w terminologi G2F to PRIOR=0

        case s of
         0: if v in [1,2] then                         // P=0
             c:=c or tb[v] or tb[5];

         1: if not(ply5) then
             if v in [1,2] then                        // M=0
              c:=c or tb[v] or tb[5];

         2: if v in [1,2] then                         // P=1
             c:=c or tb[v] or tb[6];

         3: if not(ply5) then
             if v in [1,2] then                        // M=1
              c:=c or tb[v] or tb[6];


         4: if v in [3,4] then                       // P=2
             if mlcPMG and (v=4) then
              c:=c or 0
             else
              c:=c or tb[v] or tb[7];

         5: if not(ply5) then
             if v in [3,4] then                        // M=2
              c:=c or tb[v] or tb[7];

         6: if v in [3,4] then                       // P=3
             c:=c or tb[v] or tb[8];

         7: if not(ply5) then
             if v in [3,4] then                        // M=3
              c:=c or tb[v] or tb[8];
        end;


        if ply5 and (Sprajt[y, pmx] and $aa<>0) and (SprajtX[y, pmx] and $aa<>0) then begin

         if v in [0,3,4] then
          if tPM(pmx,y, $12) or tPM(pmx,y, $30) or tPM(pmx,y, $18) or tPM(pmx,y, $90) then c:=tb[4] or tb[7];    // MO+P2, M2+P2, M1+P2, M3+P2

        end;

 end;

 Result:=AtariPal[c];

end;


function GetGTIAType(const a: byte): t_gtia;
begin

 Result:=no_gtia;

 case a and $c0 of
  $40: Result:=gr9;
  $80: Result:=gr10;
  $c0: Result:=gr11;
 end;

end;


procedure testPixel4(x: integer; const c,s, pm:byte);
// liczymy kolor piksla ducha na grafice gr9
var v: byte;
    w: integer;
    tmpCol: TColor;
begin

 inc(x, CzarnyPas);

 NewColorTab(x,py);

 w:=c+5;
 if ply5 and (s>3) then w:=4; //w:=$400;

 v:=tb[w];


 if MLCpmg then
  testMLC(x shr 1,py, pm, v);


 if ply5 and (prev>___PMG) and (s>3) then

   tmpCol:=AtariPal[form1.gr9col(v, AktualnaWartoscPixla, GetGTIAType(tb[9]))]

//  tmpCol:=AtariPal[form1.gr9col(v,AktualnaWartoscPixla, t_gtia(form1.SelectGTIA.ItemIndex))]

 else
  tmpCol:=AtariPal[v];

 form1.scan_pixel(linia , x , tmpCol);
 form1.scan_pixel(linia , x+1 , tmpCol);
end;


procedure PixSpr(const pmx:integer; const q:cardinal);
(*----------------------------------------------------------------------------*)
(* liczymy kolor pixla PMG                                                    *)
(*----------------------------------------------------------------------------*)
var p, c, i, s, tst: byte;
    tmpCol: TColor;
begin

c := byte(q shr 24);           // 0,1,2,3 - colors
i := byte(q shr 16);
s := byte(q shr 8);            // 0,2,4,6 - players, 1,3,5,7 - missiles

tst := byte(q and $ff);

p:=c; if (Pixel=4) or (ply5 and (tst>3)) then p:=4;

if piksel(p{c} or $80) then
  if (SprajtX[py, pmx] and i)>0 then
   case Pixel of
    1: begin
        tmpCol := form1.testPixel(px,c, tst, inv, s);
        form1.scan_pixel(linia , CzarnyPas+px , tmpCol);
       end;

    2: begin
        tmpCol := form1.testPixel2(pmx, s, AktualnaWartoscPixla, py);
        form1.Rysuj(linia , CzarnyPas+px , tmpCol);
       end;

    4: testPixel4(px,c,tst, s);
   end;

end;


procedure testKol(const y: integer; const v,c: byte);
begin

 if (gfxMode[y shr 3]=gfxMode[(y+1) shr 3]) or (gfxMode[(y+1) shr 3]=0) then
  if (tabKolor[c shl 8+y]=tabKolor[c shl 8+y+1]) and not(locKolor[c shl 8+y]) then rKolor[y+1,c]:=v;

end;


function TForm1.gr9col(const c,i: byte; const typ:t_gtia): byte;
// kolor dla trybu GRAPHICS 9 (16 odcieni) i GRAPHICS 11 (16 kolorow)
begin

 Result:=0;

 case typ of
   gr9: Result:=c and $f0 or ( (c and $0f) or (i and $0f) );

  gr10: case i of
           0..8: Result:=i;
          9..11: Result:=8;
         12..15: Result:=i-8;
        end;

  gr11: if i=0 then
         Result:=c and $f0
        else
         Result:=(i or c shr 4)*16+c and $0f;

 end;

end;


function PMG_hpos(const v:word): byte;
var x: byte;
begin

 x:=v shr 8; Result:=v and $00ff;

 if x and $80>0 then
  Result:=0
 else
  Result:=byte(Result+32);

end;


function PMG_size(const v:word): byte;
var x: byte;
begin

x:=v shr 8;

Result:=x and $0f;      // 0,1,2,4

if Result>0 then dec(Result);
end;


function mchPMGSize(const a: byte): byte;
begin
 Result:=a and $03;
 
 if Result=2 then Result:=0;

 if Result>0 then inc(Result);
end;


function PMGSize(const a: byte): byte;
begin
 Result:=a and $03;
 if Result=2 then Result:=0;
end;


procedure PMGUpdate(var a:word; const x,s:byte);
begin

 a:=(a and $ff00) or x;

 a:=(a and $f0ff) or ((s+1) shl 8);

end;


function TForm1.SetGTIAValue(const g: byte): byte;
begin

 Result:=0;

 if g=4 then
  case t_gtia(SelectGTIA.ItemIndex) of
    gr9: Result:=$40;
   gr10: Result:=$80;
   gr11: Result:=$c0;
  end;

end;


function TForm1.TestRaster(const _x,_y,pas:integer; const q:byte): byte;
var cyk, cyk_old, i, j, min: integer;
    k ,a, x, y, v, v_, war, gtictl, old_gtia, tmp: byte;
    kolor: array [0..24] of byte;
    shift: Boolean;
    sx, sy: string;
    old_PMGChangeMode: tPMGChange;
begin

 cyk:=0; cyk_old:=0;


if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin  // VBXE
 i:=Pas+_x;

 Pixel:=gfxMode[_y shr 3]; if Pixel=0 then Pixel:=2;

 if cmap[i div cmap_cellW, _y div cmap_cellH].status and 4>0 then Pixel:=1;

 case Pixel of

  1,4:
     begin
      Result:=byte( cmap[i div cmap_cellW, _y div cmap_cellH].c[2-q and 1] );
      exit
     end;

  2: if (q in [1..3]) then begin
      Result:=byte( cmap[i div cmap_cellW, _y div cmap_cellH].c[q-1] );
      exit
     end;

 end;

end;


// wg tablicy Raster zmieniamy 5 rejestrow koloru PF0-PF3 i BAK
// rozbijamy linie ze zmianami rastra

// jesli jest 8 linia znaku lub Mode=DLI to niesprawdzamy rastra

Result:=0;  // default

if RasterDisabled(_y) then begin

 case Pixel of
  1: case q of
      0: Result:=rKolor[_y,3]; //AtariPal[TabKolor[_y+$300]];
      1: Result:=(rKolor[_y,3] and $f0) or (rKolor[_y,2] and $0f); //AtariPal[(TabKolor[_y+$300] and $f0) or (TabKolor[_y+$200] and $0f)];
     end;

  2: Result:=rKolor[_y,q];

  4: case rKolor[_y, 9] and $c0 of
      $40: Result:=gr9col(rKolor[_y, 0], q, gr9);        //gr9
      $80: Result:=rKolor[_y, gr9col(0,q, gr10)];        //gr10
      $c0: Result:=gr9col(rKolor[_y, 0], q, gr11);       //gr11
     end;

 end;

 testKol(_y, rKolor[_y,0], 0);
 testKol(_y, rKolor[_y,1], 1);
 testKol(_y, rKolor[_y,2], 2);
 testKol(_y, rKolor[_y,3], 3);
 testKol(_y, rKolor[_y,4], 4);

 testKol(_y, rKolor[_y,5], 5);
 testKol(_y, rKolor[_y,6], 6);
 testKol(_y, rKolor[_y,7], 7);
 testKol(_y, rKolor[_y,8], 8);

 a:=rKolor[_y, 10];
 x:=rKolor[_y, 11];
 y:=rKolor[_y, 12];

 rKolor[_y+1, 10]:=a;
 rKolor[_y+1, 11]:=x;
 rKolor[_y+1, 12]:=y;

end else begin

if AktLine<>_y then begin                   // AktLine aby wyeliminowac wielokrotne wykonanie w ramach tej samej linii

 Pixel:=gfxMode[_y shr 3]; if Pixel=0 then Pixel:=2;

 AktLine:=_y;

 cyk:=0; cyk_old:=0;

 a:=rKolor[_y, 10];
 x:=rKolor[_y, 11];
 y:=rKolor[_y, 12];

//ustaw kolory z poczatku linii
 kolor[0]:=rKolor[_y,0]; // !!! koniecznie
 kolor[1]:=rKolor[_y,1]; // !!! koniecznie

 kolor[2]:=rKolor[_y,2];
 kolor[3]:=rKolor[_y,3];
 kolor[4]:=rKolor[_y,4];

 kolor[5]:=rKolor[_y,5];
 kolor[6]:=rKolor[_y,6];
 kolor[7]:=rKolor[_y,7];
 kolor[8]:=rKolor[_y,8];

 kolor[9]:=rKolor[_y,13];   // hpos players 0..3
 kolor[10]:=rKolor[_y,14];
 kolor[11]:=rKolor[_y,15];
 kolor[12]:=rKolor[_y,16];

 kolor[13]:=rKolor[_y,17];  // hpos missiles 0..3
 kolor[14]:=rKolor[_y,18];
 kolor[15]:=rKolor[_y,19];
 kolor[16]:=rKolor[_y,20];

 kolor[17]:=rKolor[_y,21];  // size players 0..3
 kolor[18]:=rKolor[_y,22];
 kolor[19]:=rKolor[_y,23];
 kolor[20]:=rKolor[_y,24];

 kolor[21]:=rKolor[_y,25];  // size missiles 0..3
 kolor[22]:=rKolor[_y,26];
 kolor[23]:=rKolor[_y,27];
 kolor[24]:=rKolor[_y,28];

(*----------------------------------------------------------------------------*)
// !!!  nie mozna tutaj modyfikowac koloru bo zmiana trybu w rastrze bedzie zle interpretowac palete kolorow !!!
{
 case Pixel of
     1: begin
         kolor[0]:=kolor[3];
         kolor[1]:=(kolor[0] and $f0) or (kolor[2] and $0f);
        end;

 0,2,4: begin
         kolor[0]:=rKolor[_y,0]; //tabKolor[$000+_y];
         kolor[1]:=rKolor[_y,1]; //tabKolor[$100+_y];
        end;
 end;
}
(*----------------------------------------------------------------------------*)

 old_gtia:=rKolor[_y, 9];

 gtictl := old_gtia and $3f;

 gtia   := old_gtia and $c0;


// fillchar(Sprajt[_y], sizeof(tablica_sprite), 0);     !!! nie bedzie widac PMG
// fillchar(SprajtX[_y], sizeof(tablica_sprite), 0);

// wypelnia 'RasterLine' wartosciami z poczatku
 for i:=0 to High(RasterLine) do begin
  move(kolor, RasterLine[i].kolor,9);
  RasterLine[i].gtia:=old_gtia;

  RasterLine[i].p0x:=kolor[9];
  RasterLine[i].p1x:=kolor[10];
  RasterLine[i].p2x:=kolor[11];
  RasterLine[i].p3x:=kolor[12];

  RasterLine[i].m0x:=kolor[13];
  RasterLine[i].m1x:=kolor[14];
  RasterLine[i].m2x:=kolor[15];
  RasterLine[i].m3x:=kolor[16];

  RasterLine[i].p0s:=kolor[17];
  RasterLine[i].p1s:=kolor[18];
  RasterLine[i].p2s:=kolor[19];
  RasterLine[i].p3s:=kolor[20];

  RasterLine[i].m0s:=kolor[21];
  RasterLine[i].m1s:=kolor[22];
  RasterLine[i].m2s:=kolor[23];
  RasterLine[i].m3s:=kolor[24];

 end;

 shift:=false;


 if t_mode(SelectMode.ItemIndex) in [m_gedm{, m_pgr}] then begin       // RASTER_LINE_OFSET tylko dla GED--

  v_:=raster_line_ofset[_y].arg;

  case raster_line_ofset[_y].cod of
     0: begin inc(cyk, v_); end;
     1: begin a:=v_; inc(cyk,2); end;
     2: begin x:=v_; inc(cyk,2); end;
     3: begin y:=v_; inc(cyk,2); end;
   $41: begin a:=v_; inc(cyk,3); end;
   $42: begin x:=v_; inc(cyk,3); end;
   $43: begin y:=v_; inc(cyk,3); end;
  end;

 end;


i:=0;
while (i < RLimitInst) and (cyk < High(edge40_2)) do begin

 v:=raster[_y, i].cod;

 v_:=raster[_y, i].arg;

 case v of
    0: begin inc(cyk, v_); end;
    1: begin a:=v_; inc(cyk,2); end;
    2: begin x:=v_; inc(cyk,2); end;
    3: begin y:=v_; inc(cyk,2); end;
  $41: begin a:=v_; inc(cyk,3); end;
  $42: begin x:=v_; inc(cyk,3); end;
  $43: begin y:=v_; inc(cyk,3); end;
  $61: begin a:=v_; inc(cyk,4); end;
  $62: begin x:=v_; inc(cyk,4); end;
  $63: begin y:=v_; inc(cyk,4); end;
 end;

// zakres rastra min..
 min:=0;

 case UseChar of
   true: case Bajt of
          32: min:=edge32_2[cyk_old+raster_ofset-6 + (ord(t_mode(SelectMode.ItemIndex)=m_piccolo)*4)];
          40: min:=edge40_2[cyk_old+raster_ofset - (ord(t_mode(SelectMode.ItemIndex)=m_piccolo)*11)];
         end;

  false: case Bajt of
          32: min:=edge32_gfx[cyk_old+raster_ofset];
          40: min:=edge40_gfx[cyk_old+raster_ofset-(ord(t_mode(SelectMode.ItemIndex)=m_pgr)*7)];
         end;
 end;

 if min>383 then min:=383;

// odczytaj STA, STX, STY i wartosc rejestru
 if v>$80 then begin

  case v of
   $81: war:=a;
   $82: war:=x;
   $83: war:=y;
  else
   war:=0;
  end;

  inc(cyk,4);

  case v_ of

   $00: kolor[9]:=war;
   $01: kolor[10]:=war;
   $02: kolor[11]:=war;
   $03: kolor[12]:=war;

   $04: kolor[13]:=war;
   $05: kolor[14]:=war;
   $06: kolor[15]:=war;
   $07: kolor[16]:=war;

   $08: kolor[17]:=PMGSize(war);
   $09: kolor[18]:=PMGSize(war);
   $0a: kolor[19]:=PMGSize(war);
   $0b: kolor[20]:=PMGSize(war);

   $0c: begin

         kolor[21]:=PMGSize( war );
         kolor[22]:=PMGSize( war shr 2 );
         kolor[23]:=PMGSize( war shr 4 );
         kolor[24]:=PMGSize( war shr 6 );

        end;

//   $0d: Smask[$000+_y]:=war;
//   $0e: Smask[$200+_y]:=war;
//   $0f: Smask[$400+_y]:=war;
//   $10: Smask[$600+_y]:=war;


   $12: kolor[5{-ord(shift)}]:=war and ($fe+ord(SelectVideo.ItemIndex=1));
   $13: kolor[6{-ord(shift)}]:=war and ($fe+ord(SelectVideo.ItemIndex=1));
   $14: kolor[7{-ord(shift)}]:=war and ($fe+ord(SelectVideo.ItemIndex=1));
   $15: kolor[8{-ord(shift)}]:=war and ($fe+ord(SelectVideo.ItemIndex=1));

   $16: kolor[1-ord(shift)]:=war and ($fe+ord(SelectVideo.ItemIndex=1));
   $17: kolor[2-ord(shift)]:=war and ($fe+ord(SelectVideo.ItemIndex=1));
   $18: kolor[3-ord(shift)]:=war and ($fe+ord(SelectVideo.ItemIndex=1));
   $19: kolor[4-ord(shift)]:=war and ($fe+ord(SelectVideo.ItemIndex=1));
   $1a: kolor[0+ord(shift) shl 2]:=war and ($fe+ord(SelectVideo.ItemIndex=1));

   $1b: begin
        gtictl:=war and $3f;

        gtia:=war and $c0;        // nowo wpisana wartosc do GTIA

        Pixel:=gfxMode[_y shr 3]; // tryb ustawiony na poczatku linii
        if Pixel=0 then Pixel:=2;

        tmp:=0;                     // wczesniejsza wartosc GTIA w linii
        for j:=0 to min do
         if RasterLine[j].gtia and $c0>0 then tmp:=RasterLine[j].gtia and $c0;

        if gtia>0 then Pixel:=4;

       // jesli GTIA bylo juz ustawione, a teraz wpisujemy do GTIA wartosc 0
       // i ustawiony w linii tryb grafiki <> 2
        if (tmp>0) and (gtia=0) and (gfxMode[_y shr 3] in [1,2,4]) then begin

//         gtictl:=gtictl and $3f;

         case gfxMode[_y shr 3] of

         1,4: begin
             Pixel:=2; // przejscie do trybu pixel=2, paleta kolorow ulega przesunieciu

             shift:=true;

             kolor[0] := kolor[1];
             kolor[1] := kolor[2];
             kolor[2] := kolor[3];
             kolor[3] := kolor[4];
            end;

         2: begin

            end;

         end;

        end else begin

        // przywracamy kolory
         if shift then for j:=0 to 4 do kolor[j]:=rKolor[_y,j]; //tabKolor[j shl 8+_y];

        end;

//        gtia:=war and $c0;
       end;

   $20: for j:=_y shr 3 to 29 do chrctl[j] := war;

  end;

 end;


// przenosimy zmieniony kolor do linii nastepnej
 if shift then begin
  testKol(_y,rKolor[_y,0],0);
  testKol(_y,rKolor[_y,1],1);
//   testKol(_y,rKolor[_y,2],2);
//   testKol(_y,rKolor[_y,3],3);
  testKol(_y,rKolor[_y,4],4);
 end else begin
  testKol(_y, kolor[0],0);
  testKol(_y, kolor[1],1);
  testKol(_y, kolor[2],2);
  testKol(_y, kolor[3],3);
  testKol(_y, kolor[4],4);
 end;


 old_gtia:=gtictl or gtia;

(*----------------------------------------------------------------------------*)

// przenosimy wartoœci rejestrów A,X,Y do nowej linii
  rKolor[_y+1, 10]:=a;
  rKolor[_y+1, 11]:=x;
  rKolor[_y+1, 12]:=y;

// wypelniamy tablice RasterLine nowo zmienionym kolorem
  for j:=min to High(RasterLine) do begin

   RasterLine[j].kolor[0]:=kolor[0];
   RasterLine[j].kolor[1]:=kolor[1];

   RasterLine[j].kolor[2]:=kolor[2];
   RasterLine[j].kolor[3]:=kolor[3];
   RasterLine[j].kolor[4]:=kolor[4];

   RasterLine[j].kolor[5]:=kolor[5];
   RasterLine[j].kolor[6]:=kolor[6];
   RasterLine[j].kolor[7]:=kolor[7];
   RasterLine[j].kolor[8]:=kolor[8];

   RasterLine[j].gtia:=gtictl or gtia;

   RasterLine[j].p0x:=kolor[9];
   RasterLine[j].p1x:=kolor[10];
   RasterLine[j].p2x:=kolor[11];
   RasterLine[j].p3x:=kolor[12];

   RasterLine[j].m0x:=kolor[13];
   RasterLine[j].m1x:=kolor[14];
   RasterLine[j].m2x:=kolor[15];
   RasterLine[j].m3x:=kolor[16];

   RasterLine[j].p0s:=kolor[17];
   RasterLine[j].p1s:=kolor[18];
   RasterLine[j].p2s:=kolor[19];
   RasterLine[j].p3s:=kolor[20];

   RasterLine[j].m0s:=kolor[21];
   RasterLine[j].m1s:=kolor[22];
   RasterLine[j].m2s:=kolor[23];
   RasterLine[j].m3s:=kolor[24];

   case Pixel of
       1: begin
           RasterLine[j].kolor[0]:=kolor[3];
           RasterLine[j].kolor[1]:=(kolor[3] and $f0) or (kolor[2] and $0f);
          end;

   0,2,4: begin
           RasterLine[j].kolor[0]:=kolor[0];
           RasterLine[j].kolor[1]:=kolor[1];
          end;
   end;

  end;

(*----------------------------------------------------------------------------*)

 cyk_old:=cyk;

 inc(i);
end;

(*----------------------------------------------------------------------------*)

 for j := _y+1 to Wysokosc-1 do begin

  if rKolor[_y,9]=rKolor[j,9] then rKolor[j,9]:=gtictl or gtia;

  if rKolor[_y,5]=rKolor[j,5] then rKolor[j,5]:=kolor[5];
  if rKolor[_y,6]=rKolor[j,6] then rKolor[j,6]:=kolor[6];
  if rKolor[_y,7]=rKolor[j,7] then rKolor[j,7]:=kolor[7];
  if rKolor[_y,8]=rKolor[j,8] then rKolor[j,8]:=kolor[8];

  if rKolor[_y,13]=rKolor[j,13] then rKolor[j,13]:=kolor[9];
  if rKolor[_y,14]=rKolor[j,14] then rKolor[j,14]:=kolor[10];
  if rKolor[_y,15]=rKolor[j,15] then rKolor[j,15]:=kolor[11];
  if rKolor[_y,16]=rKolor[j,16] then rKolor[j,16]:=kolor[12];

  if rKolor[_y,17]=rKolor[j,17] then rKolor[j,17]:=kolor[13];
  if rKolor[_y,18]=rKolor[j,18] then rKolor[j,18]:=kolor[14];
  if rKolor[_y,19]=rKolor[j,19] then rKolor[j,19]:=kolor[15];
  if rKolor[_y,20]=rKolor[j,20] then rKolor[j,20]:=kolor[16];

  if rKolor[_y,21]=rKolor[j,21] then rKolor[j,21]:=kolor[17];
  if rKolor[_y,22]=rKolor[j,22] then rKolor[j,22]:=kolor[18];
  if rKolor[_y,23]=rKolor[j,23] then rKolor[j,23]:=kolor[19];
  if rKolor[_y,24]=rKolor[j,24] then rKolor[j,24]:=kolor[20];

  if rKolor[_y,25]=rKolor[j,25] then rKolor[j,25]:=kolor[21];
  if rKolor[_y,26]=rKolor[j,26] then rKolor[j,26]:=kolor[22];
  if rKolor[_y,27]=rKolor[j,27] then rKolor[j,27]:=kolor[23];
  if rKolor[_y,28]=rKolor[j,28] then rKolor[j,28]:=kolor[24];

 end;

 old_PMGChangeMode:=PMGChangeMode;
 PMGChangeMode:=bChange;

 Ustaw:=true;

 for j := 0 to 192 do begin

   k:=RasterLine[j shl 1].p0x; if k>0 then begin FEditPMG.Line($00010000, RasterLine[k shl 1+8].p0s+1, k-32,_y) end;
   k:=RasterLine[j shl 1].p1x; if k>0 then begin FEditPMG.Line($00040200, RasterLine[k shl 1+8].p1s+1, k-32,_y) end;
   k:=RasterLine[j shl 1].p2x; if k>0 then begin FEditPMG.Line($00100400, RasterLine[k shl 1+8].p2s+1, k-32,_y) end;
   k:=RasterLine[j shl 1].p3x; if k>0 then begin FEditPMG.Line($00400600, RasterLine[k shl 1+8].p3s+1, k-32,_y) end;

   k:=RasterLine[j shl 1].m0x; if k>0 then begin FEditPMG.Line($80020100, RasterLine[k shl 1+2].m0s+1, k-32,_y) end;
   k:=RasterLine[j shl 1].m1x; if k>0 then begin FEditPMG.Line($80080300, RasterLine[k shl 1+2].m1s+1, k-32,_y) end;
   k:=RasterLine[j shl 1].m2x; if k>0 then begin FEditPMG.Line($80200500, RasterLine[k shl 1+2].m2s+1, k-32,_y) end;
   k:=RasterLine[j shl 1].m3x; if k>0 then begin FEditPMG.Line($80800700, RasterLine[k shl 1+2].m3s+1, k-32,_y) end;

 end;

 Ustaw:=false;

 PMGChangeMode:=old_PMGChangeMode;

(*----------------------------------------------------------------------------*)


 Pixel:=gfxMode[_y shr 3]; if Pixel=0 then Pixel:=2;

end;


i:=Pas+_x;        //pozycja pixla na ekranie, ktorego testujemy
if i>384 then i:=384;

if Pixel=1 then dec(i);

 if Pixel<>4 then
  Result:=RasterLine[i].kolor[q]
 else
  if gfxMode[_y shr 3]=2 then
   Result:=RasterLine[i].kolor[0] and $f0+gr15gtia40[q]
  else
   case gtia and $c0 of
    $40: Result:=gr9col(RasterLine[i].kolor[0], q, gr9);        //gr9
    $80: Result:=RasterLine[i].kolor[gr9col(0,q, gr10)];        //gr10
    $c0: Result:=gr9col(RasterLine[i].kolor[0], q, gr11);       //gr11
   end;

end;

end;


procedure TForm1.Scan_Pixel(P:PRGBQuad; const x:integer; const Value:TColor);
begin

  Inc(P, X);

  P^.rgbBlue  := (Value and $FF0000) shr 16;
  P^.rgbGreen := (Value and $00FF00) shr 8;
  P^.rgbRed   := Value and $0000FF;

end;


procedure AtariPixel(P: PRGBQuad; const x:integer; const Value:TColor);
var i: byte;
begin

  for i:=0 to Pixel-1 do form1.Scan_Pixel(P, x+i, Value);

end;


procedure TForm1.Rysuj(var P: PRGBQuad; const x:integer; const Value:TColor);
begin

 if Pixel>0 then
  if x mod Pixel=0 then AtariPixel(P, x, Value);

end;


procedure TForm1.screen32Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* narrow                                                                     *)
(*----------------------------------------------------------------------------*)
begin
 SelectScreen.ItemIndex:=0;
end;

procedure TForm1.screen40Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* standard                                                                   *)
(*----------------------------------------------------------------------------*)
begin
 SelectScreen.ItemIndex:=1;
end;

procedure TForm1.screen48Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* wide                                                                       *)
(*----------------------------------------------------------------------------*)
begin
 SelectScreen.ItemIndex:=2;
end;


function TForm1.TestRasterPrior(const x,y: integer): byte;
begin

// ten sam test co w TESTRASTER
 if RasterDisabled(y) then

// ustawienie piorytetow dla spritow i test 5-go gracza
  Result:=FEditPMG.GetPrior(y)

 else

  case RasterLine[x].gtia and $0f of
   0: Result:=4;
   1: Result:=2;
   2: Result:=1;
   4: Result:=0;
   8: Result:=3;
  else
   Result:=0
  end;

end;


procedure put(pix: byte);
(*----------------------------------------------------------------------------*)
(* wyswietlamy PIXEL grafiki uwzgledniajac raster i PMG                       *)
(*----------------------------------------------------------------------------*)
var v, w: byte;
    old_py, err, pmx: integer;
    tmpCol: TColor;
    K: PRGBQuad;
begin

if ShowCharset then begin

 old_py:=py;

{ py:=crY;

 py:=py shl 3+add_py;}

py:=CurShp.Y shl 3;

form1.PobierzPalete(CurShp.X shl 3, py);

for err := 0 to 15 do pal[err]:=AtariPal[palCol[2+err]];

pal[16]:=pal[0];  pal[20]:=pal[0];  pal[22]:=pal[0];  pal[26]:=pal[0];
pal[17]:=pal[1];  pal[21]:=pal[1];  pal[23]:=pal[1];  pal[27]:=pal[1];
pal[18]:=pal[2];                    pal[24]:=pal[2];  pal[28]:=pal[2];
pal[19]:=pal[3];                    pal[25]:=pal[4];  pal[29]:=pal[3];
                                                      pal[30]:=pal[4];

case PalOfset of
//  0: for err:=15 downto 0 do pal[err]:=AtariPal[form1.gr9col(TabKolor[py], err)];   // gr9

// 20: begin
//      err:=20; // paleta 2 kolorow
//      pal[err]:=AtariPal[TabKolor[py+$300]];
//      pal[err+1]:=AtariPal[(TabKolor[py+$300] and $f0) or (TabKolor[py+$200] and $0f)];
//     end;

 22: begin
      err:=22; // paleta 4 kolorow z 5-tym
//      pal[err]:=AtariPal[TabKolor[py]];

      if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin   // VBXE
       pal[err+1]:=cmap[px div cmap_cellW, py div cmap_cellH].c[0];
       pal[err+2]:=cmap[px div cmap_cellW, py div cmap_cellH].c[1];
       pal[err+3]:=cmap[px div cmap_cellW, py div cmap_cellH].c[2];
//      end else begin
//       pal[err+1]:=AtariPal[TabKolor[py+$100]];     // GTIA
//       pal[err+2]:=AtariPal[TabKolor[py+$200]];
//       pal[err+3]:=AtariPal[TabKolor[py+$300]];
      end;

//      pal[err+4]:=AtariPal[TabKolor[py+$400]];
     end;
end;

 py:=old_py;                            // koniecznie musi zostac !!!

 K:=bmpChar.ScanLine[py];

 AtariPixel(K, px, pal[pix+PalOfset]);

end else begin

 tmpCol:=AtariPal[form1.TestRaster(px,py,CzarnyPas,pix)];

 v:=form1.TestRasterPrior(px, py);

 if (gfxMode[py shr 3]=1) and (v=4) then v:=2;    // priority=0 dla Hires zamieñ na priority=1

 FEditPMG.SetPrior(v,false);

 FEditPMG.GetPlayer5Value(py,false);
 FEditPMG.GetMLCValue(py,false);

// ply5:=RasterLine[px].gtia and $10<>0;
// mlcPMG:=RasterLine[px].gtia and $20<>0;

 if prev>___PMG then
  form1.Rysuj(linia,CzarnyPas+px,tmpCol)
 else
  form1.Rysuj(linia,CzarnyPas+px,AtariPal[TabKolor[py]]);


// jesli Pixel=2 lub 1 tzn ze sa tez sprity
// odczytaj nibla reprezentujacego pixel sprita
//  if Pixel<4 then begin

   pmx:=(px+CzarnyPas) shr 1;

   v:=Sprajt[py, pmx];

  if (v>0) and (prev<>___BMP) then begin      // PREV = 2 BITMAP
   pik:=pix; inv:=pix;

// dekodowanie ktory to obiekt PMG
// przegladam tablice PIORYTETOW od tylu do poczatku
  if ply5 then begin
// gdy 5-y gracz jest wlaczony
   for w:=9 downto 0 do
    case tprior[w] of
     $80: if (v and $01>0) and (act[0]>0) then PixSpr(pmx, $00010000);
     $81: if (v and $04>0) and (act[1]>0) then PixSpr(pmx, $01040201);
     $82: if (v and $10>0) and (act[2]>0) then PixSpr(pmx, $02100402);
     $83: if (v and $40>0) and (act[3]>0) then PixSpr(pmx, $03400603);
     $84: if FEditPMG.GetPrior(py)=3 then begin      // prior = 8

            if SprajtX[py, pmx] and $55=0 then begin
             if (v and $02>0) and (act[4]>0) then PixSpr(pmx, $00020104);
             if (v and $08>0) and (act[5]>0) then PixSpr(pmx, $01080305);
             if (v and $20>0) and (act[6]>0) then PixSpr(pmx, $02200506);
             if (v and $80>0) and (act[7]>0) then PixSpr(pmx, $03800707);
            end;

          end else begin

           if (v and $02>0) and (act[4]>0) then PixSpr(pmx, $00020104);
           if (v and $08>0) and (act[5]>0) then PixSpr(pmx, $01080305);
           if (v and $20>0) and (act[6]>0) then PixSpr(pmx, $02200506);
           if (v and $80>0) and (act[7]>0) then PixSpr(pmx, $03800707);
          end;
    end;

  end else begin
// gdy brak 5-go gracza
    for w:=9 downto 0 do
    case tprior[w] of
     $80: begin
           if (v and $01>0) and (act[0]>0) then PixSpr(pmx, $00010000);
           if (v and $02>0) and (act[4]>0) then PixSpr(pmx, $00020104);
          end;
     $81: begin
           if (v and $04>0) and (act[1]>0) then PixSpr(pmx, $01040201);
           if (v and $08>0) and (act[5]>0) then PixSpr(pmx, $01080305);
          end;
     $82: begin
           if (v and $10>0) and (act[2]>0) then PixSpr(pmx, $02100402);
           if (v and $20>0) and (act[6]>0) then PixSpr(pmx, $02200506);
          end;
     $83: begin
           if (v and $40>0) and (act[3]>0) then PixSpr(pmx, $03400603);
           if (v and $80>0) and (act[7]>0) then PixSpr(pmx, $03800707);
          end;
    end;

  end;

    end;

end;


if Pixel=4 then begin

 if ShowCharset then
  inc(px, 4)
 else
  inc(px,2);

end else
 inc(px, Pixel);

end;


procedure TForm1.GetPikselMode(const x,y:integer; CP:byte);
var mode: byte;
//    tcl: TColor;
    i: integer;
begin

 if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin   // VBXE
  Pixel:=gfxMode[y shr 3]; if Pixel=0 then Pixel:=2;

  if cmap[(x+CP) div cmap_cellW, y div cmap_cellH].status and 4>0 then Pixel:=1;
  exit;
 end;


if t_mode(form1.SelectMode.ItemIndex) in [m_gedp, m_gedm, m_pgr, m_piccolo] then begin

 if not(UseChar) or (UseChar and (y and 7<>0)) then begin

   form1.TestRaster(x,y,CP,0);

   mode:=0;

 // sprawdzamy jaki jest tryb grafiki przed pozycja X
   for i:=0 to x-1 do
    if RasterLine[i].gtia and $c0>0 then mode:=RasterLine[i].gtia and $c0;

   gtia:=RasterLine[x+CP].gtia and $c0;

   if (gtia>0) {and (Pixel<>0)} then Pixel:=4;

   if mode>0 then
    if (gtia=0) and (gfxMode[y shr 3]<>2) then Pixel:=2

 end;

end;

end;


procedure ShowPixel(val, i: byte);
var a: byte;
begin
 Pixel:=gfxMode[py shr 3];

 form1.GetPikselMode(px,py,CzarnyPas);

   case Pixel of
    0:begin
       PalOfset:=22;

       Pixel:=2;

       AktualnaWartoscPixla:=0;
       put(0);
       put(0);
       put(0);
       put(0);
      end;

    1:begin
       PalOfset:=20; if i>127 then val:=val xor $ff;

       put((val shr 7) and 1); put((val shr 6) and 1);
       put((val shr 5) and 1); put((val shr 4) and 1);
       put((val shr 3) and 1); put((val shr 2) and 1);
       put((val shr 1) and 1); put(val and 1);
      end;

    2:begin
       PalOfset:=22;
       temp[0]:=(val shr 6) and 3; temp[1]:=(val shr 4) and 3;
       temp[2]:=(val shr 2) and 3; temp[3]:=val and 3;

       if (i>127) and UseChar then
        for a:=0 to 3 do if temp[a]=3 then temp[a]:=4;

       AktualnaWartoscPixla:=temp[0]; put(temp[0]);
       AktualnaWartoscPixla:=temp[1]; put(temp[1]);
       AktualnaWartoscPixla:=temp[2]; put(temp[2]);
       AktualnaWartoscPixla:=temp[3]; put(temp[3]);
      end;

    4:begin
       PalOfset:=0;

       gr15gtia40[3]:=2;
       gr15gtia40[7]:=2;
       gr15gtia40[11]:=6;
       gr15gtia40[12]:=8;
       gr15gtia40[13]:=8;
       gr15gtia40[14]:=9;
       gr15gtia40[15]:=10;

       if i>127 then
        case gfxMode[py shr 3] of
         1: val:=val xor $ff;
         2: if UseChar then begin
             gr15gtia40[3]:=3;
             gr15gtia40[7]:=3;
             gr15gtia40[11]:=7;
             gr15gtia40[12]:=12;
             gr15gtia40[13]:=12;
             gr15gtia40[14]:=13;
             gr15gtia40[15]:=15;
            end;
        end;

       AktualnaWartoscPixla:=(val shr 4) and $f;
       put(AktualnaWartoscPixla);
       put(AktualnaWartoscPixla);

       AktualnaWartoscPixla:=val and $f;
       put(AktualnaWartoscPixla);
       put(AktualnaWartoscPixla);

      end;

    end;

end;


procedure TForm1.PutChar(const a: byte);
(*----------------------------------------------------------------------------*)
(* znak ATASCII przedstawiony graficznie                                      *)
(*----------------------------------------------------------------------------*)
var c, i, w: byte;
    K: PRGBQuad;
begin

for i:=0 to 7 do
 with atasciiChar.Canvas do begin

  K:=atasciiChar.ScanLine[i];

  c:=AtariFnt[(a and $7f) shl 3+i];

  for w:=0 to 7 do
   scan_pixel(K, w, (ord(c and twyt1[w]=0) * clSkyBlue) xor (ord(a>127) * clSkyBlue) );

 end;

end;


procedure SzerokoscObrazu;
begin
 case form1.SelectScreen.ItemIndex of
  0: bajt:=32;
  1: bajt:=40;
  2: bajt:=48;
 end;

if ile_znakow+1<Bajt then ile_znakow:=Bajt;
end;


procedure ShowBorders;
begin

 // wizualizacja ramki obrazu, bitmapa i PMG przeswituja za zakreskowanym obszarem
 if SpecialStr[___borders].val then
  with img1.Canvas do begin
   Pen.Color:=clBtnFace;

   Brush.Style:=bsFDiagonal;
   Brush.Color:=clBtnFace;
   Rectangle(0,0,CzarnyPas,Wysokosc);
   Brush.Style:=bsBDiagonal;
   Rectangle(CzarnyPas+Szerokosc,0,CzarnyPas shl 1+Szerokosc,Wysokosc);

   Brush.Color:=clRed;
   Brush.Style:=bsFDiagonal;
   Rectangle(0,0,CzarnyPas-(CzarnyPas shr 3-3) shl 3,Wysokosc);
   Brush.Style:=bsBDiagonal;
   Rectangle(CzarnyPas+Szerokosc+(CzarnyPas shr 3-3) shl 3,0,CzarnyPas shl 1+Szerokosc,Wysokosc);

   Brush.Style:=bsSolid;
  end;

end;


procedure mic_line(const y, newY, pas: byte);
var hlp, hlp2: integer;
    b, v, m: byte;
    _chrctl: Boolean;
begin

  px:=0;
  py:=newY and form1.GetScanRatio(newY shr 3);

  hlp:=tmul48[py];

  hlp2:=tmul48[py shr 3];

  linia:=img1.scanline[y];

  _chrctl :=  UseChar and (gfxMode[y shr 3]<>2) and (chrctl_edit[y shr 3] and 7 in [1,3]);


  for b:=0 to 47 do begin

   if (b<pas) or (b>=pas+Bajt) then
    v:=0
   else
    v:=tab[b+hlp];

   if NoBadLines then
    m:=inv_nbl[b]
   else
    if Fox1 and (py and 7>3) then
     m:=invers2[b+hlp2]
    else
     m:=(invers[b+hlp2] and $80);

   py:=y;

   if _chrctl and (scren[b+hlp2]>127) then
    case chrctl_edit[y shr 3] and 7 of
     1: begin v:=0; m:=0 end;
     3: begin v:=$ff; m:=0 end;
    end;

   ShowPixel(v , m);

  end;

end;


procedure TForm1.ShowMIC(sb: Boolean = true);
(*----------------------------------------------------------------------------*)
(* procedura pokazujaca grafike Atari z bufora TAB                            *)
(*----------------------------------------------------------------------------*)
var pas, b, y, j: byte;
    old_PMGChangeMode: tPMGChange;
begin

 image1.Picture.Bitmap:=nil;

 AktLine:=255;

 BlokadaRastra:=true;

 fillchar(Sprajt, sizeof(Sprajt), 0);
 fillchar(SprajtX, sizeof(SprajtX), 0);

 move(chrctl_edit, chrctl, sizeof(chrctl));

 if t_mode(SelectMode.ItemIndex) in [m_pgr, m_piccolo] then begin

  fillchar(rKolor, sizeof(rKolor), 0);

  for y := 0 to Wysokosc-1 do begin
   rKolor[y,0]:=tgtia.colbak and $fe;
   rKolor[y,1]:=tgtia.color0 and $fe;
   rKolor[y,2]:=tgtia.color1 and $fe;
   rKolor[y,3]:=tgtia.color2 and $fe;
   rKolor[y,4]:=tgtia.color3 and $fe;
   rKolor[y,5]:=tgtia.colpm0 and $fe;
   rKolor[y,6]:=tgtia.colpm1 and $fe;
   rKolor[y,7]:=tgtia.colpm2 and $fe;
   rKolor[y,8]:=tgtia.colpm3 and $fe;

   rKolor[y,13]:=tgtia.hposp0;  // hpos players 0..3
   rKolor[y,14]:=tgtia.hposp1;
   rKolor[y,15]:=tgtia.hposp2;
   rKolor[y,16]:=tgtia.hposp3;

   rKolor[y,17]:=tgtia.hposm0;  // hpos missiles 0..3
   rKolor[y,18]:=tgtia.hposm1;
   rKolor[y,19]:=tgtia.hposm2;
   rKolor[y,20]:=tgtia.hposm3;

   rKolor[y,21]:=PMGSize(tgtia.sizep0);    // size players 0..3
   rKolor[y,22]:=PMGSize(tgtia.sizep1);
   rKolor[y,23]:=PMGSize(tgtia.sizep2);
   rKolor[y,24]:=PMGSize(tgtia.sizep3);

   rKolor[y,25]:=PMGSize(tgtia.sizem);
   rKolor[y,26]:=PMGSize(tgtia.sizem shr 2);
   rKolor[y,27]:=PMGSize(tgtia.sizem shr 4);
   rKolor[y,28]:=PMGSize(tgtia.sizem shr 6);

   rKolor[y,9]  := tgtia.gtictl;
  end;

 end else

 // wypelniamy tablice pomocnicza rKolor dla zmian w rastrze
 for y:=Wysokosc-1 downto 0 do begin

  rKolor[y,0]:=tabKolor[$000+y] and ($fe+ord(SelectVideo.ItemIndex=1));
  rKolor[y,1]:=tabKolor[$100+y] and ($fe+ord(SelectVideo.ItemIndex=1));
  rKolor[y,2]:=tabKolor[$200+y] and ($fe+ord(SelectVideo.ItemIndex=1));
  rKolor[y,3]:=tabKolor[$300+y] and ($fe+ord(SelectVideo.ItemIndex=1));
  rKolor[y,4]:=tabKolor[$400+y] and ($fe+ord(SelectVideo.ItemIndex=1));

  rKolor[y,5]:=tabKolor[$500+y];
  rKolor[y,6]:=tabKolor[$600+y];
  rKolor[y,7]:=tabKolor[$700+y];
  rKolor[y,8]:=tabKolor[$800+y];

  rKolor[y,9]:=ObliczPiorytet(y) or SetGTIAValue(gfxMode[y shr 3]);

  rKolor[y,13]:=PMG_hpos(Spr0[y]);  // hpos players 0..3
  rKolor[y,14]:=PMG_hpos(Spr1[y]);
  rKolor[y,15]:=PMG_hpos(Spr2[y]);
  rKolor[y,16]:=PMG_hpos(Spr3[y]);

  rKolor[y,17]:=PMG_hpos(Mis0[y]);  // hpos missiles 0..3
  rKolor[y,18]:=PMG_hpos(Mis1[y]);
  rKolor[y,19]:=PMG_hpos(Mis2[y]);
  rKolor[y,20]:=PMG_hpos(Mis3[y]);

  rKolor[y,21]:=PMG_size(Spr0[y]);    // size players 0..3
  rKolor[y,22]:=PMG_size(Spr1[y]);
  rKolor[y,23]:=PMG_size(Spr2[y]);
  rKolor[y,24]:=PMG_size(Spr3[y]);

  rKolor[y,25]:=PMG_size(Mis0[y]);
  rKolor[y,26]:=PMG_size(Mis1[y]);
  rKolor[y,27]:=PMG_size(Mis2[y]);
  rKolor[y,28]:=PMG_size(Mis3[y]);

  if RasterDisabled(y) then begin

   old_PMGChangeMode:=PMGChangeMode;
   PMGChangeMode:=bChange;

   Ustaw:=true;

   if rKolor[y,13]>0 then FEditPMG.Line($00010000,rKolor[y,21]+1, rKolor[y,13]-32,y);
   if rKolor[y,14]>0 then FEditPMG.Line($00040200,rKolor[y,22]+1, rKolor[y,14]-32,y);
   if rKolor[y,15]>0 then FEditPMG.Line($00100400,rKolor[y,23]+1, rKolor[y,15]-32,y);
   if rKolor[y,16]>0 then FEditPMG.Line($00400600,rKolor[y,24]+1, rKolor[y,16]-32,y);

   if rKolor[y,17]>0 then FEditPMG.Line($80020100,rKolor[y,25]+1, rKolor[y,17]-32,y);
   if rKolor[y,18]>0 then FEditPMG.Line($80080300,rKolor[y,26]+1, rKolor[y,18]-32,y);
   if rKolor[y,19]>0 then FEditPMG.Line($80200500,rKolor[y,27]+1, rKolor[y,19]-32,y);
   if rKolor[y,20]>0 then FEditPMG.Line($80800700,rKolor[y,28]+1, rKolor[y,20]-32,y);

   Ustaw:=false;

   PMGChangeMode:=old_PMGChangeMode;
  end;

 end;

 rKolor[0, 10]:=tgtia.regA;      // regA
 rKolor[0, 11]:=tgtia.regX;      // regX
 rKolor[0, 12]:=tgtia.regY;      // regY

 BlokadaRastra:=false;


 // liczymy invers dla ged+ "no bad lines"
 fillchar(inv_nbl, sizeof(inv_nbl), 0);

 for y := 0 to 29 do
  for b := 0 to 47 do
   inv_nbl[b]:=inv_nbl[b] or (invers[b+tmul48[y]] and $80);

 pas:=CzarnyPas shr 3;

 CzarnyPas:=0;

 y:=0;

 while y<Wysokosc do begin    // Y koniecznie w kolejnosci rosnacej 0,1,2...

  if UseChar and (y mod 8=0) and (chrctl[y shr 3] and 4<>0) then begin

   mic_line(y+7, y+0, pas);
   mic_line(y+6, y+1, pas);
   mic_line(y+5, y+2, pas);
   mic_line(y+4, y+3, pas);
   mic_line(y+3, y+4, pas);
   mic_line(y+2, y+5, pas);
   mic_line(y+1, y+6, pas);
   mic_line(y+0, y+7, pas);

   inc(y, 8);

  end else begin
   mic_line(y, y, pas);

   inc(y);
  end;

 end;


 if BMPLimitations1.Checked then
  for y := 0 to 29 do
   for j := 0 to 47 do
    if bmp_limit[j,y] then
     with img1.Canvas do begin
      Brush.Color:=clTeal;
      FillRect(Rect(j*8,y*8,j*8+4,y*8+4));
      FillRect(Rect(j*8+4,y*8+4,j*8+8,y*8+8));

      Brush.Color:=clSkyBlue;
      FillRect(Rect(j*8+4,y*8,j*8+8,y*8+4));
      FillRect(Rect(j*8,y*8+4,j*8+4,y*8+8));
     end;


 case SelectScreen.ItemIndex of
  0: CzarnyPas:=64;
  1: CzarnyPas:=32;
  2: CzarnyPas:=0;
 end;

 if sb then ShowBorders;

 image1.Picture.Graphic:=img1;

 UstawPixel;
end;


procedure ClearActiveColor(const a: byte);
begin
 fillchar(act,sizeof(act),a);
end;


procedure TForm1.DisableDrawMode;
begin

 drawMode:=nul;

 pMark:=Point(CzarnyPas,0);
 lMark:=Point(CzarnyPas+Szerokosc,Wysokosc);

end;


procedure TForm1.Shape9Enable(const a: Boolean);
begin

 image4.Picture.Bitmap:=nil;

 image4.Width:=768;
 image4.Height:=480;

 wycinek.SetSize(768+1, 480+1);

 image1.Cursor:=crDefault;

 ClrShape9;

 image4.Visible:=a;
 image4.Stretch:=not(a);
 image4.Enabled:=not(a);

 form1.Timer1.Enabled:=a;

 if a then
  drawMode:=SelectAlign
 else
  drawMode:=nul;

end;


procedure Lupa;
(*----------------------------------------------------------------------------*)
(* ZOOM                                                                       *)
(*----------------------------------------------------------------------------*)
var i: t_preview;
begin

 if form1.ShowColorsMap1.Checked then begin
  form1.OdswiezObraz;
  form1.ShowColorsMap1.Checked:=false;
 end;

if {(not(form14.Visible)) and} (gate>0) and
   (form1.normal1.Checked or form1.Optymizing1.Checked or form1.jgp1.Checked or form1.jgp2.Checked) then begin

 if form1.Showchars1.Checked then begin
  form1.Showchars1.Checked:=false; form1.ShowMic
 end;

 i:=prev;

 form1.Zamknij(f_EditBMP);
 form1.zamknij(f_EditCharset);
 form1.zamknij(f_Move);
 form1.zamknij(f_EditRasters);

 form1.SelectPreview.ItemIndex:=ord(i);

// przepisanie obrazu bez spritow do zomek2
// zomek2 - pomoc, obraz bez spritow
// image1 - obraz ktory widzimy
// zomek  - obraz na ktorym rysujemy 384x240

with form1 do begin
// Options.Enabled:=true; About2.Enabled:=true;
 MenuFile.Enabled:=true;
 MenuScreen.Visible:=true;

 Shape9Enable(false);
end;

zomek.Canvas.Draw(0,0,img1);

with FZoom do begin
 image1.Width:=384*factor; image1.Height:=Wysokosc*factor;
// Image1.Picture.Bitmap:=zomek;
 Image1.Bitmap.Assign(zomek);

 if not(Visible) then begin
  move(act,act_tmp,sizeof(act));
 end;

 visible:=true;

 old_Pixel:=$ff;
// SetZoomPisPalette;            // !!! zmienia aktualny kolor pisaka gdy rozne tryby w wierszach !!!

 FZoom.aGrid.Checked:=ini_zom.g;
 FZoom.aColors.Checked:=ini_zom.p;
 FZoom.aMarker.Checked:=ini_zom.c;

 ZoomPalette.Visible:=ini_zom.p;
 CursorMarker.Visible:=ini_zom.c;

 if ini_zom.s=wsMaximized then
  WindowState:=ini_zom.s
 else begin

  WindowState:=wsNormal;

  Width  := ini_zom.w;
  Height := ini_zom.h;
  Top    := ini_zom.t;
  Left   := ini_zom.l;
 end;

 seZoomFactor.Position:=ini_zom.f;
// SetFactor(0);

 seGridWidth.Position:=grd_wid;
 seGridHeight.Position:=grd_hig;

 seBrushWidth.Position:=PenS;

 scrollbox1.HorzScrollBar.Range:=image1.Width;
 scrollbox1.VertScrollBar.Range:=image1.Height;

 PMGORA.Visible:=true;
 PMGAND.Visible:=true;

case prev of
 ___PMG:
    begin
     rbLayerALL.Enabled:=false;
     rbLayerBMP.Enabled:=false;
     rbLayerPMG.Enabled:=true;

     KoloryPMG.Visible:=true;
     KoloryPF.Visible:=false;

     pisCol[0]:=0;   // koniecznie PISAK=0 inaczej nie bedzie mozna pixlowac PMG

     rbPreviewPMG.Checked:=true;
    end;

 ___BMP:
    begin
     rbLayerALL.Enabled:=false;
     rbLayerBMP.Enabled:=true;
     rbLayerPMG.Enabled:=false;

     KoloryPMG.Visible:=false;
     KoloryPF.Visible:=true;

     PMGORA.Visible:=false;
     PMGAND.Visible:=false;

     rbPreviewBMP.Checked:=true;
    end;

 ___ALL:
    begin
     rbLayerALL.Enabled:=true;
     rbLayerBMP.Enabled:=true;
     rbLayerPMG.Enabled:=true;

     KoloryPMG.Visible:=true;
     KoloryPF.Visible:=true;

     rbPreviewALL.Checked:=true;
    end;
end;


case ini_zom.layer of
 LayerALL: rbLayerALL.Checked:=true;
 LayerBMP: rbLayerBMP.Checked:=true;
 LayerPMG: rbLayerPMG.Checked:=true;
end;


if FilSpr=1 then
 PMGORAExecute(nil)
else
 PMGANDExecute(nil);



//Caption:='Zoom '+zm;
StatusBar1.Panels[7-1].Text:=current_filename;

UstawPisak;

form1.CharsFill;

ScrollBox1.HorzScrollBar.Position := ini_zom.hs;
ScrollBox1.VertScrollBar.Position := ini_zom.vs;

SCrollBox1.SetFocus;

Grid;

UstawAct;
end;

end;
end;


procedure TForm1.OdswiezObraz;
begin

 if (gate>0) and not(Blokada) then begin
  Showchars1.Checked:=false;

  ShowColorsMap1.checked:=false;

  ClearMic; ShowMic; Cnv;
 end;

 if FZoom.Visible then Lupa;

end;


procedure TForm1.ZnakCheck(const cc: tCharCompres);
begin

 normal1.Checked:=false;
 optymizing1.Checked:=false;
 jgp1.Checked:=false;
 jgp2.Checked:=false;

 case cc of
     ccStandard: normal1.Checked:=true;
   ccOptymizing: optymizing1.Checked:=true;
         ccJgp1: jgp1.Checked:=true;
         ccJgp2: jgp2.Checked:=true;
 end;

 BMPLimitations1.Enabled := optymizing1.Checked;

 if not(BMPLimitations1.Enabled) and (BMPLimitations1.Checked) then ZamknijBMPLimitations;

end;


procedure ClrCharsetTryb;
begin

 with form1 do begin
  SaveData1.Enabled:=false;
  StatusCharsets(0); EditCharset.Enabled:=false;
  charsfill1.Enabled:=false; showchars1.Enabled:=false;

  ZnakCheck(ccNul);
 end;

 form1.UstawMemo;
end;


procedure ClearRaster;
var x, y: byte;
begin

// init tablicy Raster
 for y:=Wysokosc-1 downto 0 do begin

  raster_line_ofset[y].cod:=0;
  raster_line_ofset[y].arg:=0;

  for x:=0 to High(tARaster) do begin
   raster[y, x].cod:=0; raster[y, x].arg:=0;
  end;

  if (t_mode(form1.SelectMode.ItemIndex) = m_piccolo) and (y mod 24 = 0) then begin
   raster[y, 0].cod:=$01;  // lda #
   raster[y, 0].arg:=y div 24;

   raster[y, 1].cod:=$81;  // sta
   raster[y, 1].arg:=$1e;  // -> CHBASE
  end;

 end;

end;


procedure ClearNewFnt;
begin
 fillchar(newFnt,sizeof(newFnt),0);
end;


procedure ClearPMG;
var i: byte;
begin

 fillchar(Sprajt,sizeof(Sprajt),0);      //pozycje spritow
 fillchar(SprajtX,sizeof(SprajtX),0);    //ksztalt spritow

 fillchar(Smask,sizeof(Smask),$ff);      //staly ksztalt spritow

 for i := 0 to 255 do begin
  spr0[i]:=$8000;
  spr1[i]:=$8000;
  spr2[i]:=$8000;
  spr3[i]:=$8000;

  mis0[i]:=$8000;
  mis1[i]:=$8000;
  mis2[i]:=$8000;
  mis3[i]:=$8000;

  if Pixel = 1 then Spr0[i]:=(Spr0[i] and $8fff) or ((2 shl 12) and $7000);

 end;

end;


procedure TForm1.ClearAll;
begin
 fillchar(bmp_limit, sizeof(bmp_limit), false);
 fillchar(tgtia, sizeof(tgtia), 0);
 fillchar(chrctl_edit, sizeof(chrctl_edit), 2);

 Pixel:=2;

 tgtia.pmcntl:=3;
 tgtia.gtictl:=4;

 tgtia.colpm0:=4;
 tgtia.colpm1:=6;
 tgtia.colpm2:=8;
 tgtia.colpm3:=$0e;

 tgtia.color0:=4;
 tgtia.color1:=6;
 tgtia.color2:=8;
 tgtia.color3:=$0e;

 tgtia.colbak:=0;

 with form1 do begin
  Image4.Stretch:=true;
  Image4.Visible:=false;
  image4.Enabled:=true;

  image4.Width:=768;
  image4.Height:=480;

  image1.Cursor:=crDefault;

  BMPLimitations1.Checked:=false;

  ClrRectImage(image4, transCol);
 end;

ClrCharsetTryb; ClearNewFnt;

fillchar(fonty,sizeof(fonty),0);

fillchar(locKolor,sizeof(locKolor),false);

fillchar(dostepne,sizeof(dostepne),0);

ClearPMG;

fillchar(selCol,sizeof(selCol),true);   //aktywny kolor BMP'y

UstawPixel; ustawGfxMode(Pixel);

if vscrol.use then FileClose(fvsc);

vscrol.use:=false; hscrol:=false;

ClearMIC;
ClearCnv;
ClearRaster;
ClearKolor;

Shape3_4Enable(false);

BMP_used:=0;

gate:=0;
blokada:=true;

fillchar(tab,sizeof(tab),0);
fillchar(invers,sizeof(invers),0);
fillchar(invers2,sizeof(invers2),0);

fillchar(startCharset, sizeof(startCharset), 0);

form1.showMIC; done:=0; tryb:=0; //hig:=0;

with form1 do begin

 ShowColorsMap1.Checked:=false;
 EditColorsMap.Enabled:=false;
 EditColorsMap.Checked:=false;

 SelectPreview.Enabled:=false;

 EditUndo1.Enabled:=false;
 EditRedo1.Enabled:=false;

// SelectPixel.Enabled:=true;

// SelectMode.ItemIndex:=ord(m_dli);
 SelectPreview.ItemIndex:=ord(___ALL);

 Zoom.Enabled:=false;
 SaveASM1.Enabled:=false;
 SelectMode.Enabled:=false;

 normal1.Enabled:=false; optymizing1.Enabled:=false;
 jgp1.Enabled:=false; jgp2.Enabled:=false;
 Check1.Enabled:=false;

 edit:=false;
 klikEdit:=false;
 bMarquee:=false;

 Shape9Enable(false);
 
 MenuScreen.Visible:=false;
 MenuScreen.Enabled:=false;

 EditPMG.Enabled:=false;
 Swap1.Enabled:=false;

// Original1.Enabled:=false;
 SaveAs1.Enabled:=false;

 MenuOptions.Visible:=false;
 MenuOptions.Enabled:=false;

 MenuEdit.Visible:=false;
 MenuEdit.Enabled:=false;
 EditCharset.Checked:=false;

 ShowColorsMap1.Enabled:=false;

// EditBitmap.Enabled:=false;    // Edit Bitmap
// EditColors.Enabled:=false;    // Edit Colors
// EditCharset.Enabled:=false;   // Edit Charset
// EditPalette.Enabled:=false;   // Edit Palette
// EditPMG.Enabled:=false;       // Edit PMG
 EditRasters.Enabled:=false;   // Edit Rasters

 MoveCopyPaste.Checked:=false;

 zamknij(f_EditPMG);
 zamknij(f_ImportBMP);

 refresh;


 image1.Enabled:=false;

 form1.StatusBar1.Panels[0].Text:=StatusXY(0,0, Pixel);

 Edit2Text:=''; Edit3Text:=''; Edit4Text:=''; Edit8Text:='';
end;

form1.set_pf_colors;

resolution_info;

EditPaste1.Enabled:=FileExists(GetUndoName(copypaste));

end;


procedure TForm1.ClearRecentExecute(Sender: TObject);
begin
 RecentFile.Clear;
 reopen.Enabled:=false;
end;


procedure SetHig;
begin
// if hig>Wysokosc-1 then form1.ClearAll;
end;


procedure ZwiekszHig(const a: integer);
begin
// inc(hig,a); if hig>Wysokosc then hig:=Wysokosc;

 resolution_info;
end;


procedure UstawKompresje;
(*----------------------------------------------------------------------------*)
(* ustaw kompresje Standard jesli nie ma zadnej                               *)
(*----------------------------------------------------------------------------*)
begin

 with form1 do
  if not(optymizing1.Checked) and not(normal1.Checked) then begin
   ZnakCheck(ccStandard);
   cnv;
  end;

end;


function mchPrior(const a: byte): byte;
begin

 case a and $0f of
  0: Result:=$40;
  1: Result:=$20;
  2: Result:=$10;
  4: Result:=$00;
  8: Result:=$30;
 else
  Result:=$00;
 end;

end;


procedure LoadMCH;
(*----------------------------------------------------------------------------*)
(* MCH                                                                        *)
(* 3 mo¿liwe d³ugoœci pliku dla ka¿dej rozdzielczoœci                         *)
(* 1 - znaki, kolory $d01a, $d016..$d019                                      *)
(* 2 - znaki, kolory PF, kolory PMG, pozycje, szerokoœci, prior, dane PMG     *)
(* 3 - tak jak wersja '2' + dane rastra 29*2*240 + gtis                       *)
(*----------------------------------------------------------------------------*)
var x, y, i,j, plik, hlp: integer;
    v: byte;
    old_PMGChangeMode: tPMGChange;
    dliplus: Boolean;
begin
 form1.ClearAll;

 form1.SelectGTIA.ItemIndex:=0;

 plik:= FileOpen(current_filename, fmOpenRead);
 y:=FileSeek(plik, 0, 2);

 case y of
  32*30*9+5*240+4*240+8*240+3*240+5*256, 32*30*9+5*240+4*240+8*240+3*240+5*256+29*2*240+1+32, 32*30*9+5*240 : form1.SelectScreen.ItemIndex:=0;   // 32bytes
  40*30*9+5*240+4*240+8*240+3*240+5*256, 40*30*9+5*240+4*240+8*240+3*240+5*256+29*2*240+1+32, 40*30*9+5*240 : form1.SelectScreen.ItemIndex:=1;   // 40bytes
  48*30*9+5*240+4*240+8*240+3*240+5*256, 48*30*9+5*240+4*240+8*240+3*240+5*256+29*2*240+1+32, 48*30*9+5*240 : form1.SelectScreen.ItemIndex:=2;   // 48bytes
 end;

 FileSeek(plik, 0, 0);

 FileRead(plik, v, 1);

 form1.SpecialVal(___ModeDLIplus, cFlatUnCheck);
 form1.SpecialVal(___ModeDLI, cFlatChecked);

 SpecialUpdate;


 form1.SelectMode.ItemIndex := v and 3;

 case v shr 2 and 3 of
  0: form1.SelectPixel.ItemIndex:=0;
  1: form1.SelectPixel.ItemIndex:=1;
  2: form1.SelectPixel.ItemIndex:=2;
 end;

 case v shr 4 and 3 of
  0: form1.SelectGTIA.ItemIndex:=0;
  1: form1.SelectGTIA.ItemIndex:=1;
  2: form1.SelectGTIA.ItemIndex:=2;
 end;


 dliplus:=false;

 FileSeek(plik, 0, 0);

 for x:=0 to 30-1 do
  for i:=0 to Bajt-1 do begin

   FileRead(plik, v, 1);

   if v and $80<>0 then invers[form1.Sofs(i, tmul48[x])]:=$80;
   if v and $40<>0 then begin invers2[form1.Sofs(i, tmul48[x])]:=$80; dliplus:=true end;

   for j:=0 to 7 do FileRead(plik, tab[form1.Sofs(i,tmul48[x shl 3+j])], 1);
  end;


 // COLBAK, COLOR0...COLOR3, COLPM0..COLPM3
 for j:=0 to 8 do FileRead(plik, tabKolor[j shl 8], 240);


 fillchar(bufor, sizeof(bufor), 0);
 FileRead(plik, bufor, 8*240);

 for j := 0 to 239 do begin
  v:=bufor[240*0+j]; if v<32 then Spr0[j+0]:=$8000 else Spr0[j+0]:=v-32;
  v:=bufor[240*1+j]; if v<32 then Spr1[j+0]:=$8000 else Spr1[j+0]:=v-32;
  v:=bufor[240*2+j]; if v<32 then Spr2[j+0]:=$8000 else Spr2[j+0]:=v-32;
  v:=bufor[240*3+j]; if v<32 then Spr3[j+0]:=$8000 else Spr3[j+0]:=v-32;

  v:=bufor[240*4+j]; if v<32 then Mis0[j+0]:=$8000 else Mis0[j+0]:=v-32;
  v:=bufor[240*5+j]; if v<32 then Mis1[j+0]:=$8000 else Mis1[j+0]:=v-32;
  v:=bufor[240*6+j]; if v<32 then Mis2[j+0]:=$8000 else Mis2[j+0]:=v-32;
  v:=bufor[240*7+j]; if v<32 then Mis3[j+0]:=$8000 else Mis3[j+0]:=v-32;
 end;

 fillchar(bufor, sizeof(bufor), 0);     // Players Sizez, Missiles Sizes (2 bity)
 FileRead(plik, bufor, 3*240);          // prior

 for j := 0 to 239 do begin
  Spr0[j]:=Spr0[j] or (mchPMGSize(bufor[j]) shl 8) or (mchPrior(bufor[240*2+j]) shl 8) ;
  Spr1[j]:=Spr1[j] or (mchPMGSize(bufor[j] shr 2) shl 8) or ((bufor[240*2+j] and $70) shl 8);
  Spr2[j]:=Spr2[j] or (mchPMGSize(bufor[j] shr 4) shl 8);
  Spr3[j]:=Spr3[j] or (mchPMGSize(bufor[j] shr 6) shl 8);

  Mis0[j]:=Mis0[j] or (mchPMGSize(bufor[240+j]) shl 8);
  Mis1[j]:=Mis1[j] or (mchPMGSize(bufor[240+j] shr 2) shl 8);
  Mis2[j]:=Mis2[j] or (mchPMGSize(bufor[240+j] shr 4) shl 8);
  Mis3[j]:=Mis3[j] or (mchPMGSize(bufor[240+j] shr 6) shl 8);
 end;


 fillchar(bufor, sizeof(bufor), 0);     // Players, Missiles Shapes
 FileRead(plik, bufor, 5*256);

 for j:=0 to 255 do begin
  Smask[$000+j]:=bufor[$100+j];
  Smask[$200+j]:=bufor[$200+j];
  Smask[$400+j]:=bufor[$300+j];
  Smask[$600+j]:=bufor[$400+j];

  Smask[$100+j]:=(bufor[$000+j] and 3) shl 6;
  Smask[$300+j]:=((bufor[$000+j] shr 2) and 3) shl 6;
  Smask[$500+j]:=((bufor[$000+j] shr 4) and 3) shl 6;
  Smask[$700+j]:=((bufor[$000+j] shr 6) and 3) shl 6;
 end;


 fillchar(bufor, sizeof(bufor), 0);     // Raster

 for j := 0 to 239 do begin
  FileRead(plik, bufor, 2);

  raster_line_ofset[j].cod := bufor[0];
  raster_line_ofset[j].arg := bufor[1];

  FileRead(plik, raster[j], sizeof(tARaster));
 end;

 bufor[0]:=-5+24;
 FileRead(plik, bufor, 1);

 raster_ofset:=bufor[0]-24;

 FEditRasters.GlobalOfset.Position:=raster_ofset;


 fillchar(bufor, sizeof(bufor), 0);     // tgtia

 FileRead(plik, tgtia, sizeof(tgtia));


 fillchar(bufor, 5, 0);                 // LocKolor
 FileRead(plik, bufor, 5);          

 for j := 0 to 4 do
  if bufor[j] <> 0 then fillchar(LocKolor[j shl 8], 256, true);

 FileClose(plik);

 
 if dliplus then begin
  form1.SpecialVal(___ModeDLIplus, cFlatChecked);
  form1.SpecialVal(___ModeDLI, cFlatUnCheck);
  form1.SelectMode.ItemIndex:=1;

  SpecialUpdate;
 end;


 form1.set_pf_colors;

 gate:=1; Done:=0;
 UstawKompresje; form1.showMIC;

 SaveAfterExit:=false;
 
end;


procedure SaveMCH;
(*----------------------------------------------------------------------------*)
(* SAVE MIC CHAR                                                              *)
(*----------------------------------------------------------------------------*)
var i, j, k, f: integer;
    zm: string;
    v: byte;
    head: Boolean;
begin
 zm:=form1.Savedialog1.FileName;
 zm:=ChangeFileExt(zm, '.mch');

 f:=FileCreate(zm);


 head:=false;

 for i:=0 to 29 do
  for k:=0 to Bajt-1 do begin

   v:=0;
   if invers[form1.Sofs(k,tmul48[i])]>127 then v:=$80;
   if SpecialStr[___ModeDliplus].val then if invers2[form1.Sofs(k,tmul48[i])]>127 then v:=v or $40;

   if not(head) then begin

    v:=v or form1.SelectMode.ItemIndex;

    v:=v or (form1.SelectPixel.ItemIndex shl 2) or (form1.SelectGTIA.ItemIndex shl 4);

    head:=true;
   end;

   FileWrite(f, v, 1);

   for j:=0 to 7 do FileWrite(f,tab[tmul48[i*8+j]+CzarnyPas shr 3+k],1);

  end;


 for i:=0 to 8 do FileWrite(f,tabKolor[i shl 8],240);


 for j := 0 to 239 do begin
  if Spr0[j+0] and $8000<>0 then bufor[240*0+j]:=0 else bufor[240*0+j]:=(Spr0[j+0] and $ff)+32;
  if Spr1[j+0] and $8000<>0 then bufor[240*1+j]:=0 else bufor[240*1+j]:=(Spr1[j+0] and $ff)+32;
  if Spr2[j+0] and $8000<>0 then bufor[240*2+j]:=0 else bufor[240*2+j]:=(Spr2[j+0] and $ff)+32;
  if Spr3[j+0] and $8000<>0 then bufor[240*3+j]:=0 else bufor[240*3+j]:=(Spr3[j+0] and $ff)+32;

  if Mis0[j+0] and $8000<>0 then bufor[240*4+j]:=0 else bufor[240*4+j]:=(Mis0[j+0] and $ff)+32;
  if Mis1[j+0] and $8000<>0 then bufor[240*5+j]:=0 else bufor[240*5+j]:=(Mis1[j+0] and $ff)+32;
  if Mis2[j+0] and $8000<>0 then bufor[240*6+j]:=0 else bufor[240*6+j]:=(Mis2[j+0] and $ff)+32;
  if Mis3[j+0] and $8000<>0 then bufor[240*7+j]:=0 else bufor[240*7+j]:=(Mis3[j+0] and $ff)+32;
 end;

 FileWrite(f, bufor, 240*8);


 for j := 0 to 239 do begin
  bufor[j]:=PMG_size(Spr0[j]) or (PMG_size(Spr1[j]) shl 2) or (PMG_size(Spr2[j]) shl 4) or (PMG_size(Spr3[j]) shl 6);
  bufor[240+j]:=PMG_size(Mis0[j]) or (PMG_size(Mis1[j]) shl 2) or (PMG_size(Mis2[j]) shl 4) or (PMG_size(Mis3[j]) shl 6);

  v:=0;
  case (Spr0[j] shr 8) and $70 of
   $40: v:=0;
   $20: v:=1;
   $10: v:=2;
   $00: v:=4;
   $30: v:=8;
  end;

  bufor[240*2+j]:=v or ((Spr1[j] shr 8) and $70);

 end;

 FileWrite(f, bufor, 240*3);


 for j:=0 to 255 do begin
  bufor[$100+j] := Smask[$000+j];
  bufor[$200+j] := Smask[$200+j];
  bufor[$300+j] := Smask[$400+j];
  bufor[$400+j] := Smask[$600+j];

  bufor[j]:=(Smask[$100+j] and $c0 shr 6) or (Smask[$300+j] and $c0 shr 4) or (Smask[$500+j] and $c0 shr 2) or (Smask[$700+j] and $c0);
 end;

 FileWrite(f, bufor, $500);


 for j := 0 to 239 do begin
  bufor[0] := raster_line_ofset[j].cod;
  bufor[1] := raster_line_ofset[j].arg;

  FileWrite(f, bufor, 2);

  FileWrite(f, raster[j], sizeof(tARaster));
 end;

 v:=FEditRasters.GlobalOfset.Position+24;

 FileWrite(f, v, 1);

 FileWrite(f, tgtia, sizeof(tgtia));

 FileClose(f);
end;


procedure LoadMIC;
var x, y, plik, tmp1, tmp2: integer;
begin
 SaveAfterExit:=false;

 setHig;

 plik:= FileOpen(current_filename, fmOpenRead);
 y:=FileSeek(plik, 0, 2);

 FileSeek(plik, 0, 0);

 tmp1:=y div bajt; if tmp1>Wysokosc-hig then tmp1:=Wysokosc-hig;
 tmp2:=CzarnyPas shr 3;

 for x:=0 to tmp1-1 do FileRead(plik, tab[tmp2+tmul48[x+hig]], bajt);

 if t_gtia(form1.SelectGTIA.ItemIndex) in [gr10] then begin

 // odczytaj 9 bajty kolorow
 if y=(y div bajt)*bajt+9 then begin
  FileSeek(plik, y-9, 0);
  FileRead(plik, temp, 9);

  for x:=0 to 8 do fillchar(tabKolor[x shl 8+hig],$100-hig,temp[x]);

  form1.set_pf_colors;
 end;

 end else begin

 // odczytaj 4 bajty kolorow
 if y=(y div bajt)*bajt+4 then begin
  FileSeek(plik, y-4, 0);
  FileRead(plik, temp, 4);

  for x:=0 to 3 do fillchar(tabKolor[x shl 8+hig],$100-hig,temp[x]);

  form1.set_pf_colors;
 end;

 end;

 FileClose(plik);

 ZwiekszHig(tmp1); gate:=1; Done:=0;
 UstawKompresje; form1.showMIC;

end;


procedure LoadG10;
var x, y, plik, tmp1, tmp2: integer;
begin
 SaveAfterExit:=false;

 setHig;

 form1.SelectGTIA.ItemIndex:=ord(gr10);

 plik:= FileOpen(current_filename, fmOpenRead);
 y:=FileSeek(plik, 0, 2);

 FileSeek(plik, 0, 0);

 tmp1:=y div bajt; if tmp1>Wysokosc-hig then tmp1:=Wysokosc-hig;
 tmp2:=CzarnyPas shr 3;
 for x:=0 to tmp1-1 do FileRead(plik, tab[tmp2+tmul48[x+hig]], bajt);

 // odczytaj 4 bajty kolorow
 if y=(y div bajt)*bajt+9 then begin
  FileSeek(plik, y-9, 0);
  FileRead(plik, temp, 9);

  for x:=0 to 8 do fillchar(tabKolor[x shl 8+hig],$100-hig,temp[x]);

  form1.set_pf_colors;
 end;

 FileClose(plik);

 ZwiekszHig(tmp1); gate:=1; Done:=0;
 UstawKompresje; form1.showMIC;
end;


function RGBtoYUV(const cl: TColor): tYUV;
var r,g,b: byte;
begin

 r:=GetRValue(cl);
 g:=GetGValue(cl);
 b:=GetBValue(cl);

 Result.y := 0.299*r + 0.587*g + 0.114*b;
 Result.u := 0.565*(b - Result.y);
 Result.v := 0.713*(r - Result.y);

end;


function rgbRead(const cl: TColor): byte;
var a,b: tYUV;
    i: byte;
    x,p: double;
begin

 Result:=0;

 a:=RGBtoYUV(cl);

 x:=$ff*$ff+$ff*$ff+$ff*$ff;
// x:=sqr(a.y)+sqr(a.u)+sqr(a.v);

 for i:=0 to 255 do begin

   b:=RGBtoYUV(AtariPal[i]);

   p := Sqr(b.y - a.y) + Sqr(b.u - a.u) + Sqr(b.v - a.v);

   if x>p then begin x:=p; Result:=i end;

  end;

end;


procedure NewKolUstaw(const ad:integer; const cl:TColor);
var x, y: byte;
begin

 if PoprawBMP then begin

  y:=(rgbRead(cl)) and $fe;

  if (ad=$200) and (Pixel=1) then y:=y and $f;

  for x:=hig to 255 do TabKolor[ad+x]:=y;

 end;

end;


procedure TForm1.Optymizing1Click(Sender: TObject);
begin
 if gate>0 then begin
  ClrJGPplusCharsetCheck;
  ZnakCheck(ccOptymizing);
  form1.zamknij(f_EditCharset);

  tryb:=1; cnv;
  ShowChars(0,29,false);
 end;
end;


procedure ShowBMP(var mx,my:integer; var bitmap:TBitmap);
(*----------------------------------------------------------------------------*)
(* zamieniamy BMP na grafike Atari                                            *)
(*----------------------------------------------------------------------------*)
var x, y, ofs, wys, i, ad: integer;
    czyInvers: Boolean;
    P: PByteArray;
    v, w: byte;
    temp: array [0..4] of byte;
begin

// if bitmap.PixelFormat<>pf24bit then halt;
 

 fillchar(tab, sizeof(tab), 0);

 ofs:=CzarnyPas shr 3; czyInvers:=false;
 wys:=my; if my>Wysokosc-hig then wys:=Wysokosc-hig;

    for y := 0 to wys-1 do begin
      P := bitmap.ScanLine[y];

      i:=0;

      ad:=ofs+tmul48[(y+hig) shr 3];

      if y mod 8=0 then for x:=0 to Bajt-1 do scren[ad+x]:=scren[ad+x] and $7f;

      for x:=0 to ((mx+8) div (8 div Pixel))-1 do
      if i<mx then begin

       case Pixel of
        1:begin
           v:=0;
           for w:=0 to 7 do
            if bufor[P[i+w]]>0 then v:=v or twyt1[w];

            tab[ofs+x+tmul48[y+hig]] := v;
            inc(i,8);
           end;

        2:begin
         // invers wykasuj tylko na pierwszej pozycji nowej kolumny
            if i mod 4=0 then czyInvers:=false;

            temp[0]:=bufor[P[i]]; temp[1]:=bufor[P[i+1]];
            temp[2]:=bufor[P[i+2]]; temp[3]:=bufor[P[i+3]];

            for w:=0 to 3 do if temp[w]=4 then begin temp[w]:=3; czyInvers:=true end;
            w:=scren[ad+x];
            if czyInvers then w:=w or $80{ else w:=w and $7f};
            scren[ad+x]:=w; invers[ad+x]:=w;

            v:=(temp[0] and 3 shl 6) or (temp[1] and 3 shl 4) or (temp[2] and 3 shl 2) or (temp[3] and 3);

            tab[ofs+x+tmul48[y+hig]] := v;
            inc(i,4);
          end;

        4:begin

           if t_gtia(form1.SelectGTIA.ItemIndex) in [gr9,gr11] then
             tab[ofs+x+tmul48[y+hig]] := P[i*3] and $f0 + P[(i+1)*3] shr 4
           else
             tab[ofs+x+tmul48[y+hig]] := (bufor[P[i]] shl 4) or (bufor[P[i+1]] and $0f);

           inc(i,2);
          end;

       end;
      end;
    end;

P := bitmap.ScanLine[0];

case Pixel of
 1: begin
     P[0]:=palBmp[0]; NewKolUstaw($300, form1.GetPixel(bitmap, 0,0) );
     P[0]:=palBmp[1]; NewKolUstaw($200, form1.GetPixel(bitmap, 0,0) );
    end;

 2: for w:=0 to 4 do begin
     P[0]:=palBmp[w]; NewKolUstaw(w shl 8, form1.GetPixel(bitmap, 0,0) );
    end;

 4: if t_gtia(form1.SelectGTIA.ItemIndex)=gr10 then
     for w:=0 to 8 do begin
      P[0]:=palBmp[w]; NewKolUstaw(w shl 8, form1.GetPixel(bitmap, 0,0) );
     end;

end;

end;


function TForm1.GetUndoName(const a: string): string;
begin
 Result:=path+a;
end;


procedure TForm1.GTIA1Click(Sender: TObject);
begin
 SelectVideo.ItemIndex:=0;
end;

procedure TForm1.VBXE1Click(Sender: TObject);
begin
 SelectVideo.ItemIndex:=1;
end;


procedure optymalizacja_mapy_kolorow; // (ox, oy: integer);
var x, y, sx, sy, k: integer;
    tmp: tab_bool256;
    ok: Boolean;
// dodatkowe sortowanie palet kolorow
// wyszukujemy palety z tymi samymi kolorami jednak na roznych pozycjach
// i przyporzadkowujemy im wspolna pozycje
begin

 for y := 1 to (wysokosc div cmap_cellH)-2 do
  for x := 1 to 41 do
   if (cmap[3+x,y].i>0) and (cmap[3+x,y+1].i>0) then begin

    sx:=x; sy:=y+1;

    fillchar(tmp, sizeof(tmp), false);

    for k:=0 to cmap[3+x,y].i-1 do tmp[cmap[3+x,y].c[k+1]]:=true;

    case cmap[3+sx,sy].i of
     1: ok:= tmp[cmap[3+sx,sy].c[1]];
     2: ok:= tmp[cmap[3+sx,sy].c[1]] and tmp[cmap[3+sx,sy].c[2]];
    else
     ok:= tmp[cmap[3+sx,sy].c[1]] and tmp[cmap[3+sx,sy].c[2]] and tmp[cmap[3+sx,sy].c[3]];
    end;

    if ok then cmap[3+sx,sy]:=cmap[3+x,y];
   end;

end;


procedure KonwersjaNaMapeKolorow(const nam: string);
type
  tmpPal = array [0..3] of smallint;

var x, y, p, brak, liczba_kolorow, background, Pik: integer;
    szerokosc, wysokosc, ofs, sx, sy: integer;
    f: file;
    v, k, i: byte;
    ok: Boolean;
    bmpkol: array [0..7, 0..511] of byte;
    tmp: tab_bool256;
    kolory: tab_int256;
    buf, paleta_kolorow: tab_byte256;

//    t: textfile;

    Byt: PByteArray;
    cl: TColor;

    tPal: tmpPal;
    bmp: TBitmap;

const
  bits: array [0..3] of byte = ($00,$55,$aa,$ff);
  bits8: array [0..3] of byte = ($ff,$00,0,0);

  _and: array [0..3] of byte = ($c0,$30,$0c,$03);
  _and8: array [0..7] of byte = ($80,$40,$20,$10,8,4,2,1);
  
begin

 bmp:=TBitmap.Create;
 bmp.LoadFromFile(nam);

 bmp.PixelFormat:=pf24bit;

 szerokosc:=bmp.Width;
 if szerokosc>Bajt*8 then szerokosc:=Bajt*8;

 wysokosc:=bmp.Height;
 if wysokosc>240 then wysokosc:=240;


 ofs:=CzarnyPas div cmap_cellW;

 Pik:=Pixel;

 fillchar(tab, sizeof(tab), 0);

 for y:=0 to 239 do
  for x:=0 to 47 do begin
   cmap[x,y].i:=0;

   cmap[x,y].c[0]:=-1;
   cmap[x,y].c[1]:=-1;
   cmap[x,y].c[2]:=-1;
   cmap[x,y].c[3]:=-1;
  end;

 for y:=0 to 7 do
  for x:=0 to 383 do bmpkol[y,x]:=0;

// paleta kolorów
 for x:=0 to 255 do kolory[x]:=0;

 fillchar(paleta_kolorow, sizeof(paleta_kolorow), 0);

 for y:=0 to wysokosc-1 do begin
  Byt:=bmp.ScanLine[y];

  for x:=0 to (szerokosc div Pik)-1 do begin
   cl:=Byt[(x*Pik)*3+2]+Byt[(x*Pik)*3+1] shl 8+Byt[(x*Pik)*3] shl 16;
   inc(kolory[rgbRead(cl)]);
  end;

 end;


 liczba_kolorow:=0;
 for i:=0 to 255 do
  if kolory[i]>0 then begin paleta_kolorow[liczba_kolorow]:=i; inc(liczba_kolorow) end;



 form1.ProgressBar1.Max:=liczba_kolorow*(Wysokosc div cmap_cellH)+Wysokosc;
 form1.ProgressBar1.Step:=1;
 form1.ProgressBar1.Position:=0;
 form1.ProgressBar1.Visible:=true;


 for p:=0 to liczba_kolorow-1 do
 for y:=0 to (Wysokosc div cmap_cellH)-1 do begin
  form1.ProgressBar1.StepIt;

 // zamiana pixli 8 linii na kolory Atari
  for x:=0 to (szerokosc div Pik)-1 do
   for i:=0 to cmap_cellH-1 do begin
    Byt:=bmp.ScanLine[y*cmap_cellH+i];

    cl:=Byt[(x*Pik)*3+2]+Byt[(x*Pik)*3+1] shl 8+Byt[(x*Pik)*3] shl 16;
    bmpkol[i,x]:=rgbRead(cl);
   end;

  for x:=0 to (szerokosc div cmap_cellW)-1 do begin

   fillchar(tmp, sizeof(tmp), false);   // zaznaczam uzyte kolory w CELL

   for k:=0 to cmap_cellH-1 do
    for i:=0 to (cmap_cellW div Pik)-1 do tmp[bmpkol[k, x*(cmap_cellW div Pik)+i]]:=true;

   if tmp[paleta_kolorow[p]] then begin // zaznacz uzycie koloru w CMAP
    if cmap[x+ofs,y].i<4 then cmap[x+ofs,y].c[cmap[x+ofs,y].i]:=paleta_kolorow[p];
    if cmap[x+ofs,y].i<255 then inc(cmap[x+ofs,y].i);
   end;

  end;

 end;


 for x:=0 to 255 do kolory[x]:=0;
 P:=0;
 brak:=0;

 for y:=0 to (wysokosc div cmap_cellH)-1 do
  for x:=0 to (szerokosc div cmap_cellW)-1 do
   if cmap[x+ofs,y].i>3 then begin

    if cmap[x+ofs,y].i>pik shl 1 then inc(brak);

    inc(P);
    if cmap[x+ofs,y].c[0]>=0 then inc(kolory[cmap[x+ofs,y].c[0]]);
    if cmap[x+ofs,y].c[1]>=0 then inc(kolory[cmap[x+ofs,y].c[1]]);
    if cmap[x+ofs,y].c[2]>=0 then inc(kolory[cmap[x+ofs,y].c[2]]);
    if cmap[x+ofs,y].c[3]>=0 then inc(kolory[cmap[x+ofs,y].c[3]]);
   end;


 background:=-1;

 for i:=0 to 255 do
  if kolory[i]=P then begin background:=i; Break end;

 if not(background>=0) then begin

  P:=0;
  for i:=0 to 255 do
   if kolory[i]>P then begin P:=kolory[i]; background:=i end;

 end;

// usuwamy z CMAP kolor tla

 if background>=0 then begin

 for y:=0 to (wysokosc div cmap_cellH)-1 do
   for x:=0 to (szerokosc div cmap_cellW)-1 do

    if Pik=2 then begin

      tPal[0]:=-1;
      tPal[1]:=-1;
      tPal[2]:=-1;
      tPal[3]:=-1;

      i:=0;
      for k:=0 to 3 do
       if (cmap[x+ofs, y].c[k]<>background) and (cmap[x+ofs,y].c[k]>=0) then begin
        tPal[i]:=cmap[x+ofs, y].c[k];
        inc(i);
       end;

      cmap[x+ofs,y].c[0]:=background;

      if tPal[0]>=0 then
       cmap[x+ofs,y].c[1]:=tPal[0]
      else
       cmap[x+ofs,y].c[1]:=background;

      if tPal[1]>=0 then
       cmap[x+ofs,y].c[2]:=tPal[1]
      else
       cmap[x+ofs,y].c[2]:=background;

      if tPal[2]>=0 then
       cmap[x+ofs,y].c[3]:=tPal[2]
      else
       cmap[x+ofs,y].c[3]:=background;

      cmap[x+ofs,y].i:=0;

      if cmap[x+ofs,y].c[1]<>background then inc(cmap[x+ofs,y].i);
      if cmap[x+ofs,y].c[2]<>background then inc(cmap[x+ofs,y].i);
      if cmap[x+ofs,y].c[3]<>background then inc(cmap[x+ofs,y].i);

    end else begin

       if cmap[x+ofs,y].i=1 then begin
        tPal[1]:=cmap[x+ofs,y].c[0];
        tPal[2]:=cmap[x+ofs,y].c[0];
       end else begin
        tPal[1]:=cmap[x+ofs,y].c[1];
        tPal[2]:=cmap[x+ofs,y].c[0];
       end;

       cmap[x+ofs,y].c[0]:=0;
       cmap[x+ofs,y].c[1]:=0;

       if tPal[1]>=0 then
        cmap[x+ofs,y].c[2]:=tPal[1]
       else
        cmap[x+ofs,y].c[2]:=0;

       if tPal[2]>=0 then
        cmap[x+ofs,y].c[3]:=tPal[2]
       else
        cmap[x+ofs,y].c[3]:=0;

    end;


 for y:=0 to 239 do
   for x:=0 to 47 do
    for k := 0 to 3 do
     if cmap[x+ofs,y].c[k]<0 then cmap[x+ofs,y].c[k]:=background;

 end;

 if pik=2 then optymalizacja_mapy_kolorow;


 for y:=0 to wysokosc-1 do begin
  form1.ProgressBar1.StepIt;

  Byt:=bmp.ScanLine[y];

  for x:=0 to (szerokosc div Pik)-1 do begin
   cl:=Byt[(x*Pik)*3+2]+Byt[(x*Pik)*3+1] shl 8+Byt[(x*Pik)*3] shl 16;
   bmpkol[0,x]:=rgbRead(cl);
  end;

   for x:=0 to (szerokosc div cmap_cellW)-1 do begin

      v:=0;

      if pik=2 then begin

      for p:=0 to (cmap_CellW div Pik)-1 do
       if bmpkol[0,x*(cmap_cellW div Pik)+p]<>background then begin
        k:=1;
        while (bmpkol[0,x*(cmap_cellW div Pik)+p]<>cmap[x+ofs,y div cmap_cellH].c[k]) and (k<4) do inc(k);

        v:=v or (bits[k] and _and[p]);
       end;

       end else begin

       for p:=0 to (cmap_CellW div Pik)-1 do begin

        if (bmpkol[0,x*(cmap_cellW div Pik)+p]=cmap[x+ofs,y div cmap_cellH].c[2]) then
         k:=0
        else
         k:=1;

        v:=v or (bits8[k] and _and8[p]);
       end;

       end;

      tab[CzarnyPas shr 3+x+tmul48[y]]:=v;
     end;
 end;


 for y := 0 to 239 do   // G2F korzysta z pierwszych 3-ech wpisow
  for x := 0 to 47 do begin
   cmap[x,y].c[0]:=cmap[x,y].c[1];
   cmap[x,y].c[1]:=cmap[x,y].c[2];
   cmap[x,y].c[2]:=cmap[x,y].c[3];
  end;

fillchar(TabKolor,256, byte(background));

form1.set_pf_colors;

bmp.Free;

form1.ProgressBar1.Visible:=false;

end;


(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)

function clip(const a: integer): byte;
begin

 if a>255 then
  Result:=255
 else
  Result:=a;

end;


function findNearest(const cl: TColor; const o,colors,y: byte): byte;
var w,d: double;
    k: byte;
    a,b: tYUV;
begin

 Result:=0;

 d:=$ff*$ff+$ff*$ff+$ff*$ff;

 a:=RGBtoYUV( rgb(clip(GetRValue(cl)+o), clip(GetGValue(cl)+o), clip(GetBValue(cl)+o) ));

 for k:=0 to colors-1 do begin

  b:=RGBtoYUV( AtariPal[TabKolor[k shl 8+y]] );

  w := Sqr(b.y - a.y) + Sqr(b.u - a.u) + Sqr(b.v - a.v);

  if d>w then begin d:=w; Result:=k end;

 end;

end;


procedure Dither(var bmp: TBitmap);
type
    _buf = array [0..240*384] of byte;
    _inv = array [0..240*384] of Boolean;

    pbuf = ^_buf;
    pinv = ^_inv;

var i,j, k, x,y, _w,_h, cell_w, cell_h: integer;
    v, h: byte;
    p: array [0..4] of integer;
    buf4, buf5: pbuf;
    inv: pinv;

    o : array [0..7, 0..7] of byte;
begin

 fillchar(o, sizeof(o), 0);

 case FImportBMP.DitherMatrix.ItemIndex of
  0: begin
      o[0,0]:=0; o[1,0]:=2;
      o[0,1]:=3; o[1,1]:=1;
      cell_w := 2;
      cell_h := 2;
     end;

  1: begin
      o[0,0]:=1;  o[1,0]:=9;  o[2,0]:=3;  o[3,0]:=11;
      o[0,1]:=13; o[1,1]:=5;  o[2,1]:=15; o[3,1]:=7;
      o[0,2]:=4;  o[1,2]:=12; o[2,2]:=2;  o[3,2]:=10;
      o[0,3]:=16; o[1,3]:=8;  o[2,3]:=14; o[3,3]:=6;
      cell_w := 4;
      cell_h := 4;
     end;

  else
     begin
      o[0,0]:=1;  o[1,0]:=49;  o[2,0]:=13;  o[3,0]:=61; o[4,0]:=4;  o[5,0]:=52; o[6,0]:=16; o[7,0]:=64;
      o[0,1]:=33; o[1,1]:=17;  o[2,1]:=45;  o[3,1]:=29; o[4,1]:=36; o[5,1]:=20; o[6,1]:=48; o[7,1]:=32;
      o[0,2]:=9;  o[1,2]:=57;  o[2,2]:=5;   o[3,2]:=53; o[4,2]:=12; o[5,2]:=60; o[6,2]:=8;  o[7,2]:=56;
      o[0,3]:=41; o[1,3]:=25;  o[2,3]:=37;  o[3,3]:=21; o[4,3]:=44; o[5,3]:=28; o[6,3]:=40; o[7,3]:=24;
      o[0,4]:=3;  o[1,4]:=51;  o[2,4]:=15;  o[3,4]:=63; o[4,4]:=2;  o[5,4]:=50; o[6,4]:=14; o[7,4]:=62;
      o[0,5]:=35; o[1,5]:=19;  o[2,5]:=47;  o[3,5]:=31; o[4,5]:=34; o[5,5]:=18; o[6,5]:=46; o[7,5]:=30;
      o[0,6]:=11; o[1,6]:=59;  o[2,6]:=7;   o[3,6]:=55; o[4,6]:=10; o[5,6]:=58; o[6,6]:=6;  o[7,6]:=54;
      o[0,7]:=43; o[1,7]:=27;  o[2,7]:=39;  o[3,7]:=23; o[4,7]:=42; o[5,7]:=26; o[6,7]:=38; o[7,7]:=22;
      cell_w := 8;
      cell_h := 8;
     end;
 end;


 _w:=bmp.Width; //if _w>384 then _w:=384;
 _h:=bmp.Height; //if _h>240 then _h:=240;

 New(buf4);
 New(buf5);
 New(inv);

 fillchar(buf4^, sizeof(buf4^), 0);
 fillchar(buf5^, sizeof(buf5^), 0);

 fillchar(inv^, sizeof(inv^), false);


 for j:=0 to _h-1 do
  for i:=0 to _w-1 do
   buf5^[i+j*384]:=findNearest(bmp.Canvas.Pixels[i,j], o[i mod cell_w, j mod cell_h], 5,j);

 for j:=0 to _h-1 do
  for i:=0 to _w-1 do
   buf4^[i+j*384]:=findNearest(bmp.Canvas.Pixels[i,j], o[i mod cell_w, j mod cell_h], 4,j);


 if not(FImportBMP.FifthColors.Checked) then move(buf4^, buf5^, sizeof(buf4^));


// czy mamy kolor 710 i 711
 for j:=0 to 29 do
  for i:=0 to (_w shr 2)-1 do begin

   p[0]:=0;
   p[1]:=0;
   p[2]:=0;
   p[3]:=0;
   p[4]:=0;

   for y:=0 to 7 do
    for x:=0 to 3 do
     inc(p[buf5^[i*4+x+j*(8*384)+y*384]]);

   if (p[4]>0) and (p[3]>0) then begin

    for y:=0 to 7 do
     for x:=0 to 3 do
      buf5^[i*4+x+j*(8*384)+y*384]:=buf4^[i*4+x+j*(8*384)+y*384];

   end;

  end;


 for j:=0 to _h-1 do
  for i:=0 to Bajt-1 do begin

   for k:=0 to 3 do begin
    h:=buf5^[i*4+k+j*384];

    if h>3 then begin h:=3; inv^[i*4+k+j*384]:=true end;

    p[k]:=h;
   end;

   v:=p[0] shl 6+
      p[1] shl 4+
      p[2] shl 2+
      p[3];

   tab[CzarnyPas shr 3+i+tmul48[j]]:=v;
  end;


 for j:=0 to 29 do
  for i:=0 to Bajt-1 do begin

   k:=0;

   for y:=0 to 7 do
    for x:=0 to 3 do
     inc(k, ord(inv^[i shl 2+x+j*(384*8)+y*384]));

   invers[CzarnyPas shr 3+i+tmul48[j]]:=ord(k>0)*$80;

  end;

 Dispose(buf4);
 Dispose(buf5);
 Dispose(inv);
end;


function GetGrayColor (const Color: TColor): TColor;
const RConst = 77;
      GConst = 150;
      BConst = 29;
var Index: byte;
begin
//  Index := Byte (Longint (Word (GetRValue (Color)) * RConst +
//                 Word (GetGValue (Color)) * GConst +
//                 Word( GetBValue(Color)) * BConst) shr 8);

 Index := byte((GetRValue(Color)*RConst + GetGValue(Color)*GConst + GetBValue(Color)*BConst) shr 8);

 Result := RGB (Index, Index, Index);
end;


procedure LoadBMP;
(*----------------------------------------------------------------------------*)
(* wczytujemy zawsze BMP o maksymalnej wysokosci 240 linii                    *)
(* ale pokazujemy tylko ten fragment ktory miesci sie na ekranie              *)
(*----------------------------------------------------------------------------*)
type
    _tb = array [0..384, 0..240] of byte;
    ptb = ^_tb;

var x, y, i, j, ofs, mx, my, wys, ad, plik, t,l: integer;
    P, P2: PByteArray;
    tmpV: tab_int256;
    cl: TColor;
    de: array [0..15] of byte;
    ko, kol, tmp_kol: array [0..4] of byte;
    tst: cardinal;
    v, w, a, b, k, k_default, iC: byte;
    z, fsource: string;
    bitmap, skaluj, tmp: TBitmap;
    czyInvers, ok, bbmp, bgif, bpng, bjpg: Boolean;
    gif: TGifImage;
    lpng: TPngOBject;
    lJpg: TJPEGImage;
    bmp: TBitmap;

    img: TImage;
    lStreamLoaded: boolean;
    lStream: TmemoryStream;

    pal: TMaxLogPalette;

    tb: ptb;
        
    LABEL quit;

const
 kod: array [0..4] of byte=($00,$55,$aa,$ff,$ff);

begin

New(tb);

move(tab,temp_tab,sizeof(tab));
move(invers,copy_tab,sizeof(invers));
move(TabKolor,copy_tab[$0800],$0500);

fsource:=current_filename;

// sprawdzenie czy plik to BMP
plik:= FileOpen(current_filename, fmOpenRead);
FileSeek(plik, 0, 0);
FileRead(plik,temp,16);
FileClose(plik);

z:='';
for i := 0 to 15 do z:=z+chr(temp[i]);

bbmp:=false;
bgif:=false;
bpng:=false;
bjpg:=false;

if pos('BM',z)>0 then bbmp:=true else
 if pos('GIF',z)>0 then bgif:=true else
  if pos('PNG',z)>0 then bpng:=true else
   if pos('JFIF',z)>0 then bjpg:=true;


if (bbmp or bgif or bpng or bjpg) and (hig<=Wysokosc) then begin
 fillchar(temp,sizeof(temp),0);
 setHig;

// if form1.panel2.Visible=false then hig_old:=hig;
// if PoprawBMP then hig_old:=hig;


 FImportBMP.ZaznaczKoloryBMP;
// ClrCharsetTryb;


 if bgif then begin
  gif:=TGifImage.Create;
  gif.LoadFromFile(current_filename);

  fsource:=GetTempName;
  gif.Bitmap.SaveToFile(fsource);
  gif.Free;
 end else


 if bpng then begin

          lPNG := TPNGObject.Create;
          bmp := TBitmap.Create;
          {In case something goes wrong, free booth PNG and Bitmap}
          try
           lPNG.LoadFromFile(current_filename);
           bmp.Assign(lPNG);    //Convert data into bitmap

           fsource:=GetTempName;

           bmp.SaveToFile(fsource);
          finally
           lPNG.Free;
           bmp.Free;
          end;

 end else

 if bjpg then begin

           lStreamLoaded := true;
           lStream := TMemoryStream.Create;
           try
              lStream.LoadFromFile(current_filename);
              lStream.Seek(0, soFromBeginning);
              lJpg := TJPEGImage.Create;
              try
                 lJpg.LoadFromStream(lStream);
                 lStream.Free;
                 lStreamLoaded := false;

                 img:=TImage.Create(form1);

                 img.Picture.Bitmap.PixelFormat := pf24bit;
                 img.Picture.Bitmap.SetSize(lJpg.Width, lJpg.Height);
                 img.Canvas.Draw(0,0,lJpg);

                 fsource:=GetTempName;
                 img.Picture.Bitmap.SaveToFile(fsource);
                 img.Free;
              finally
                     lJPG.Free;
              end;
           finally
                  if lStreamLoaded then lStream.Free;
           end; //try..finally

 end;{ else
  if bbmp then begin

   bitmap:=TBitmap.create;
   bitmap.LoadFromFile(current_filename);
   bitmap.PixelFormat:=pf24bit;

   fsource:=GetTempName;

   bitmap.SaveToFile(fsource);

   bitmap.Free;
  end;}


 skaluj:=TBitmap.Create;
 bitmap:=TBitmap.create;

 skaluj.LoadFromFile(fsource);

// if skaluj.PixelFormat=pf4bit then skaluj.PixelFormat:=pf8bit;

 skaluj.PixelFormat:=pf32bit;
 bitmap.PixelFormat:=pf32bit;

 mx:=skaluj.Width; my:=skaluj.Height;

 if mx>Bajt*8 then mx:=Bajt*8;
 if my>Wysokosc then my:=Wysokosc;
// mx:=(mx and $fffe);


 v:=0;
 if FImportBMP.AutoresizeBMP1.Checked then
  case Pixel of
   2: v:=1;
   4: v:=2;
  end;

 mx:=mx shr v;

 bitmap.SetSize(mx, my);
 skaluj.Height:=my;


 x:=hig;
 y:=hig+my; if y>239 then y:=239;
 dec(y,hig);

 form1.Ustaw_Button2_7(x,y);
 form1.Shape3_4Enable(true);

 form1.ClrRect(bitmap,0);

 for j:=0 to my-1 do
  for i:=0 to mx-1 do begin

//   cl:=skaluj.Canvas.Pixels[i shl v,j];
   cl:=form1.GetPixel(skaluj, i shl v, j);

   if FImportBMP.Grayscale.Checked then cl:=GetGrayColor(cl);

//   bitmap.Canvas.Pixels[i,j]:=cl;
   form1.SetPixel(bitmap, i,j, cl);
  end;

 bitmap.SaveToFile(form1.GetUndoName('bmp_tmp.$$$'));
 skaluj.Free;

 FImportBMP.Refresh;

 bitmap.LoadFromFile(form1.GetUndoName('bmp_tmp.$$$'));

 if (form1.SelectPixel.ItemIndex=2) and (t_gtia(form1.SelectGTIA.ItemIndex) in [gr9,gr11]) then
  bitmap.PixelFormat:=pf24bit           // !!! gr9, gr11
 else
  bitmap.PixelFormat:=pf8bit;

  UstawPixel;

 if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin   //VBXE

  KonwersjaNaMapeKolorow(form1.GetUndoName('bmp_tmp.$$$'));

  form1.Shape3_4Enable(false);
  goto quit;
 end;


 if not(FImportBMP.Visible) then begin
  form1.SetFormPos('FImportBMP', t,l);
  FImportBMP.top:=t;
  FImportBMP.left:=l;

  FImportBMP.Visible:=true; //Pixel<>4;
 end;

// FImportBMP.SmartColors.Enabled := ((Pixel=2) and not(FImportBMP.Dither.Checked));
 FImportBMP.FifthColors.Enabled := (Pixel=2);
 FImportBMP.AutoresizeBMP1.Enabled := (Pixel<>1);
 FImportBMP.Dither.Enabled := (Pixel<>4);

 if Pixel=4 then begin
  FImportBMP.FifthColors.Checked :=false;
  FImportBMP.Dither.Checked :=false;
 end;

 FImportBMP.CountColors.Enabled := not((Pixel=4) and (t_gtia(form1.SelectGTIA.ItemIndex) in [gr9,gr11]));

 FImportBMP.Image5.Visible := (Pixel<>4);

 for i:=0 to 15 do box_combo[i].Visible := (Pixel<>4);

 if Pixel<>2 then FImportBMP.SmartColors.Checked:=false;

 mx:=bitmap.Width; ofs:=(Bajt shl 3) div Pixel; if mx>ofs then mx:=ofs;
// my:=bitmap.Height; if my>Wysokosc then my:=Wysokosc;

// policzenie kolorow
 fillchar(tmpV,sizeof(tmpV),0);
 fillchar(bufor,sizeof(bufor),0);

 for i:=0 to 255 do palBMP[i]:=-1;  // aby wiedziec ktory wylaczony


 for y := 0 to my-1 do begin
  P := bitmap.ScanLine[y];
  if (Pixel=4) and (t_gtia(form1.SelectGTIA.ItemIndex)<>gr10) then
   for x := 0 to mx-1 do tmpV[P[x*3]]:=256-P[x*3]
  else
   for x := 0 to mx-1 do inc(tmpV[P[x]]);
 end;


// usuwamy z palety kolory powtarzajace sie

 if (Pixel=2) or ((Pixel=4) and (t_gtia(form1.SelectGTIA.ItemIndex)=gr10)) then begin

  GetPaletteEntries(bitmap.Palette, 0, 256, pal.palPalEntry);

  for x:=0 to 255 do
   if tmpV[x]>0 then
    for y:=0 to 255 do
     if y<>x then
      if rgbRead(rgb(pal.palPalEntry[y].peRed,pal.palPalEntry[y].peGreen,pal.palPalEntry[y].peBlue)) and $fe=
         rgbRead(rgb(pal.palPalEntry[x].peRed,pal.palPalEntry[x].peGreen,pal.palPalEntry[x].peBlue)) and $fe then begin

         for j:=0 to bitmap.Height-1 do begin

          P:=bitmap.ScanLine[j];
          for i:=0 to bitmap.Width-1 do
           if P[i]=y then P[i]:=x;

         end;
           
         inc(tmpV[x], tmpV[y]);
         tmpV[y]:=0;
      end;
 end;

// ile kolorow
// wybierz pierwsze ktore wystapily i wstaw do palBmp

 iC:=0;

 if FImportBMP.CountColors.Checked then begin

  for j:=0 to 255 do begin

   i:=0;
   x:=0;
   for y:=0 to 255 do
    if tmpV[y]>0 then
     if tmpV[y]>x then begin x:=tmpV[y]; i:=y end;

   if tmpV[i]>0 then      // wstawiamy od najczestszych do najrzadszych
    if iC<16 then begin
     palBmp[iC]:=i;
     bufor[i]:=iC;
     inc(iC);

     tmpV[i]:=0;
    end;

  end;

 end else
  for i:=0 to 255 do      // wstawiamy kolejne kolory palety
   if tmpV[i]>0 then
    if iC<16 then begin
     palBmp[iC]:=i;
     bufor[i]:=iC;
     inc(iC);
    end;


 for i:=0 to 255 do
  if palBMP[i]<0 then palBMP[i]:=palBMP[0];


// ustawiamy rejestry Atari reprezentujace kolory palety bitmapy
 for i:=0 to 255 do
  case Pixel of
   1: if bufor[i]>0 then bufor[i]:=1;
   2: bufor[i]:=bufor[i] mod (4+ord(FImportBMP.FifthColors.Checked));
   4: bufor[i]:=bufor[i] mod 9;
  end;


// jesli =false tzn ze nacisnal PREVIEW dla modyfikacji kolorow
 if not(PoprawBMP) then for i:=15 downto 0 do bufor[palBmp[i]]:=newPal[i];

// w palBmp znajduje sie 16 najczesciej wystepujacych
// ofsetow do koloru
// czytamy BMP'e i zapamietujemy tylko kolory = palBMP
if (FImportBMP.SmartColors.Checked) {and (Pixel=2)} then begin

if PoprawBMP then for i:=15 downto 0 do newPal[i]:=bufor[palBmp[i]];

// wypelnienie tablicy 4 kolorow KO, pierwszymi aktywnymi kolorami BMP
 j:=0;
 fillchar(ko,sizeof(ko),0);
 fillchar(kol,sizeof(kol),0);

 for i:=0 to 15 do
  if selCol[i] and (j<(4+ord(FImportBMP.FifthColors.Checked))) then begin
   kol[j]:=bufor[palBmp[i]];
   ko[j]:=kod[kol[j]];
   inc(j);
  end;

 fillchar(tb^,sizeof(tb^),0);

 for y:=0 to my-1 do begin
  P := bitmap.ScanLine[y];
  for x:=0 to mx-1 do begin
   v:=$ff;
   for i:=0 to iC-1 do if palBmp[i]=P[x] then v:=i;
   if v<>$ff then tb^[x,y]:=v;
  end;
 end;


fillchar(tab,sizeof(tab),0);
fillchar(invers,sizeof(invers),0);
fillchar(invers2,sizeof(invers2),0);

// czyscimy kolory bitmapy
{
fillchar(tabKolor[$000],256,0);
fillchar(tabKolor[$100],256,4);
fillchar(tabKolor[$200],256,6);
fillchar(tabKolor[$300],256,8);
fillchar(tabKolor[$400],256,$e);   }


a:=0; y:=0; k_default:=0; k:=k_default;

// zamiana kolorow z palBmp na kolory Atari
P:=bitmap.ScanLine[0];
for i:=0 to iC-1 do begin
 P[0]:=palBmp[i];
 de[i]:=(rgbRead(bitmap.Canvas.Pixels[0,0])) and $fe;
end;

// petla, w ktorej nastepuje konwersja na kolory Atari
while (a<(4+ord(FImportBMP.FifthColors.Checked))) do begin

 if k>iC-1 then begin
  inc(y); k:=k_default;
  if y>Wysokosc-1 then begin y:=0; inc(a) end;
 end;

 ok:=false;
 for x:=0 to mx-1 do
  if (tb^[x,y]=k) and (selCol[k]) then begin   // znalazl w linii Y kolor K
   tb^[x,y]:=$f0+kol[a]; ok:=true;
  end;


 if ok then begin
  TabKolor[kol[a] shl 8+y]:=de[k];

  inc(y); k:=k_default;
  if y>Wysokosc-1 then begin y:=0; inc(a) end;
 end else
  inc(k);

end;

// sprawdz ktore kolory zostaly i zaznacz je na czerwono
fillchar(temp,sizeof(temp),0);

for y:=0 to my-1 do
 for x:=0 to mx-1 do
  if tb^[x,y]<$f0 then temp[tb^[x,y]]:=$ff;

FImportBMP.ZaznaczKoloryBMP;

// --------------- SMART COLORS ------------------

// zamien pozostale kolory wg ustawionej tabeli palBmp na kod $f0+kolor
// a tam gdzie kolor $f4 wstaw invers znaku
for y:=0 to my-1 do
 for x:=0 to mx-1 do
  if tb^[x,y]<$f0 then begin

   if selCol[tb^[x,y]] then
    tb^[x,y]:=$f0+bufor[palBmp[tb^[x,y]]]
   else
    tb^[x,y]:=$f0;

  end;

// teraz zamien to na grafike Atari
for y:=0 to my-1 do
 for x:=0 to mx-1 do begin
  ofs:=form1.Sofs(x shr 2,tmul48[y]);
  v:=kod[tb^[x,y]-$f0] and twyt2[x and 3];

  tab[ofs]:=tab[ofs] or v;

  if tb^[x,y]=$f4 then invers[form1.Sofs(x shr 2,tmul48[y shr 3])]:=$80;
 end;


// porzadkowanie palety kolorow
 if (4+ord(FImportBMP.FifthColors.Checked))=5 then
  v:=2
 else
  v:=3;

 for i:=0 to v do tmp_kol[i]:=TabKolor[i shl 8];  // initialize KOL (712,708,709,[710])

 for y:=1 to my-1 do begin
  for i:=0 to v do
   for x:=0 to v do
    if x<>i then
     if TabKolor[i shl 8+y]=tmp_kol[x] then
      case i of
       0: case x of
           1: FEditColors.ChangeColors(y,0,1,0,2,3,4);
           2: FEditColors.ChangeColors(y,0,2,1,0,3,4);
           3: FEditColors.ChangeColors(y,0,3,1,2,0,4);
          end;

       1: case x of
           0: FEditColors.ChangeColors(y,0,1,0,2,3,4);
           2: FEditColors.ChangeColors(y,0,0,2,1,3,4);
           3: FEditColors.ChangeColors(y,0,0,3,2,1,4);
          end;

       2: case x of
           0: FEditColors.ChangeColors(y,0,2,1,0,3,4);
           1: FEditColors.ChangeColors(y,0,0,2,1,3,4);
           3: FEditColors.ChangeColors(y,0,0,1,3,2,4);
          end;

       3: case x of
           0: FEditColors.ChangeColors(y,0,3,1,2,0,4);
           1: FEditColors.ChangeColors(y,0,0,3,2,1,4);
           2: FEditColors.ChangeColors(y,0,0,1,3,2,4);
          end;
      end;

  for i:=0 to v do tmp_kol[i]:=TabKolor[i shl 8+y];
 end;


// kopiowanie palety we wlasciwy obszar
 for y:=0 to my-1 do
  if hig+y<240 then begin
   move(tab[tmul48[y]],temp_tab[tmul48[hig+y]],48);
   move(invers[tmul48[y shr 3]],copy_tab[tmul48[(hig+y) shr 3]],48);
   copy_tab[$000+$800+hig+y] := TabKolor[$000+y];
   copy_tab[$100+$800+hig+y] := TabKolor[$100+y];
   copy_tab[$200+$800+hig+y] := TabKolor[$200+y];
   copy_tab[$300+$800+hig+y] := TabKolor[$300+y];
   copy_tab[$400+$800+hig+y] := TabKolor[$400+y];
  end;

 move(temp_tab,tab,sizeof(tab));
 move(copy_tab,invers,sizeof(invers));
 move(copy_tab[$800],TabKolor,$500);

end else begin

// ---------------- NO SMART COLORS ----------------

 ShowBMP(mx,my,bitmap);
 form1.Shape3_4Enable(false);

 if PoprawBMP then
  for i:=15 downto 0 do newPal[i]:=bufor[palBmp[i]];

end;


 v:=0; i:=0;  if Pixel=1 then begin v:=1; i:=2; end;


 for x:=0 to iC-1 do begin
  w:=box_combo[x].Tag;
  box_combo[x].ItemIndex:=bufor[palBmp[w]] xor v+i;
 end;


if (Pixel=2) and FImportBMP.Dither.checked then begin

 for i:=0 to 15 do
  if selCol[i] and (box_combo[i].ItemIndex in [0..4]) then
   fillchar(TabKolor[box_combo[i].ItemIndex shl 8], 256, rgbRead(rgb(pal.palPalEntry[palBMP[i]].peRed, pal.palPalEntry[palBMP[i]].peGreen, pal.palPalEntry[palBMP[i]].peBlue)) and $fe);

 Dither(bitmap);

end;


(*----------------------------------------------------------------------------*)

 FImportBMP.ShowImportPalette(bitmap, iC);

 if Pixel<>4 then for i:=0 to 15 do box_combo[i].Visible:=i<iC;

(*----------------------------------------------------------------------------*)

 BMP_used:=my;

 form1.set_pf_colors;

quit:

 bitmap.free;

 gate:=1; Done:=1;

 UstawKompresje;
 form1.Cnv;

 if SpecialStr[___borders].val then begin
  form1.SpecialVal(___borders, cFlatUnCheck);
  form1.showMic;
  form1.SpecialVal(___borders, cFlatChecked);
 end;

 form1.showMic;

end;

Dispose(tb);
end;


procedure Ustaw_Znacznik_Kompresji_Znakow(const ze: byte);
var v: Boolean;
    i: byte;
begin

v:=true;
for i:=0 to 29 do
 if table[i]<>(i and 1) then begin v:=false; Break end;

if v then begin form1.ZnakCheck(ccJgp1); exit end;

v:=false;

case Bajt of
 32: v := (ze=8);
 40: v := (ze=10);
 48: v := (ze=15);
end;

if v then
 form1.ZnakCheck(ccStandard)
else
 form1.ZnakCheck(ccOptymizing);
 
end;


procedure Original;
begin
 if gate>0 then begin
  form1.ZnakCheck(ccNul);
  form1.cnv;
 end;
end;


procedure LoadCOL;
(*----------------------------------------------------------------------------*)
(* informacja o kolorach, 5x 256b                                             *)
(*----------------------------------------------------------------------------*)
var plik: integer;
begin

if not(done>0) then form1.New1Click(form1); 

if gate>0 then begin
 Blokada:=false;

 plik:= FileOpen(current_filename, fmOpenRead);
 FileSeek(plik, 0, 0);

 FileRead(plik, TabKolor, 5*$100);
 FileClose(plik);

 form1.set_pf_colors;

 FEditColors.frameLineRange1.seRange.Position:=239;
 FEditColors.SetKolor;

 Form1.OdswiezObraz; Blokada:=true;
end;

end;


procedure save(const a: AnsiString);
var i, len: integer;
    tmp: array [0..255] of byte;
begin

 ZeroMemory(@tmp, sizeof(tmp));

 if (px>0) or (pupa) then begin

  len:=length(a);
  if len > 255 then len:=255;

  for i := 1 to len do
   tmp[i-1] := byte(AnsiChar(a[i]));

  if len>0 then FileWrite(dane,tmp,len);

//  len:=$0a0d;
  tmp[0]:=$0d;
  tmp[1]:=$0a;
  if eol_ then FileWrite(dane,tmp,2);
 end;

end;


function PMGbits(v: byte): byte;
begin

 if not(lpmg_checkbox[0].Checked) then v:=v and $fe;
 if not(lpmg_checkbox[1].Checked) then v:=v and $fb;
 if not(lpmg_checkbox[2].Checked) then v:=v and $ef;
 if not(lpmg_checkbox[3].Checked) then v:=v and $bf;

 if not(lpmg_checkbox[4].Checked) then v:=v and $fd;
 if not(lpmg_checkbox[5].Checked) then v:=v and $f7;
 if not(lpmg_checkbox[6].Checked) then v:=v and $df;
 if not(lpmg_checkbox[7].Checked) then v:=v and $7f;

 Result:=v;
end;


procedure LoadPMG;
(*----------------------------------------------------------------------------*)
(* grafika PMG dla programu G2F lub zrzut pamieci PMG                         *)
(*----------------------------------------------------------------------------*)
var i, x, y, f: integer;
    v: byte;
begin

if not(done>0) then form1.New1Click(form1);

if gate>0 then begin

 Blokada:=false;

 f:= FileOpen(current_filename, fmOpenRead);
 FileSeek(f, 0, 0);

 if FSpecial.PmgAtari.Checked then begin          // ATARI

//  fillchar(Smask, sizeof(Smask), 0);

  FileRead(f, bufor, $100+8);          // missiles0

  for i := 0 to 256-8-1 do begin
   if lpmg_checkbox[4].Checked then Smask[$100+i]:=bufor[i+8] shl 6;
   if lpmg_checkbox[5].Checked then Smask[$300+i]:=(bufor[i+8] and $0c) shl 4;
   if lpmg_checkbox[6].Checked then Smask[$500+i]:=(bufor[i+8] and $30) shl 2;
   if lpmg_checkbox[7].Checked then Smask[$700+i]:=(bufor[i+8] and $c0);
  end;

  FileRead(f, bufor, $100); if lpmg_checkbox[0].Checked then move(bufor, Smask[$000], $100);      // player0
  FileRead(f, bufor, $100); if lpmg_checkbox[1].Checked then move(bufor, Smask[$200], $100);      // player1
  FileRead(f, bufor, $100); if lpmg_checkbox[2].Checked then move(bufor, Smask[$400], $100);      // player2
  FileRead(f, bufor, $100); if lpmg_checkbox[3].Checked then move(bufor, Smask[$600], $100);      // player3

 end else begin                                   // G2F

 FileRead(f,TabKolor[$500],4*$100);

 FileRead(f, _tmpPMG, sizeof(Spr0)); if lpmg_checkbox[0].Checked then move(_tmpPMG, Spr0, sizeof(Spr0));
 FileRead(f, _tmpPMG, sizeof(Mis0)); if lpmg_checkbox[4].Checked then move(_tmpPMG, Mis0, sizeof(Mis0));

 FileRead(f, _tmpPMG, sizeof(Spr1)); if lpmg_checkbox[1].Checked then move(_tmpPMG, Spr1, sizeof(Spr1));
 FileRead(f, _tmpPMG, sizeof(Mis1)); if lpmg_checkbox[5].Checked then move(_tmpPMG, Mis1, sizeof(Mis1));

 FileRead(f, _tmpPMG, sizeof(Spr2)); if lpmg_checkbox[2].Checked then move(_tmpPMG, Spr2, sizeof(Spr2));
 FileRead(f, _tmpPMG, sizeof(Mis2)); if lpmg_checkbox[6].Checked then move(_tmpPMG, Mis2, sizeof(Mis2));

 FileRead(f, _tmpPMG, sizeof(Spr3)); if lpmg_checkbox[3].Checked then move(_tmpPMG, Spr3, sizeof(Spr3));
 FileRead(f, _tmpPMG, sizeof(Mis3)); if lpmg_checkbox[7].Checked then move(_tmpPMG, Mis3, sizeof(Mis3));


 FileRead(f, bufor, $100); if lpmg_checkbox[0].Checked then move(bufor, Smask[$000], $100);
 FileRead(f, bufor, $100); if lpmg_checkbox[4].Checked then move(bufor, Smask[$100], $100);

 FileRead(f, bufor, $100); if lpmg_checkbox[1].Checked then move(bufor, Smask[$200], $100);
 FileRead(f, bufor, $100); if lpmg_checkbox[5].Checked then move(bufor, Smask[$300], $100);

 FileRead(f, bufor, $100); if lpmg_checkbox[2].Checked then move(bufor, Smask[$400], $100);
 FileRead(f, bufor, $100); if lpmg_checkbox[6].Checked then move(bufor, Smask[$500], $100);

 FileRead(f, bufor, $100); if lpmg_checkbox[3].Checked then move(bufor, Smask[$600], $100);
 FileRead(f, bufor, $100); if lpmg_checkbox[7].Checked then move(bufor, Smask[$700], $100);

 FileRead(f, bufor, 1);    // nadmiarowy bajt

 FileRead(f,Sprajt,sizeof(Sprajt));      // pamiec obrazu dla PMG
 FileRead(f,SprajtX,sizeof(SprajtX));    // pamiec obrazu dla PMG

 for y:=0 to Wysokosc-1 do
  for x:=0 to 289 do begin

   v:=Sprajt[y, x]; Sprajt[y, x]:=PMGbits(v);
   v:=SprajtX[y, x]; SprajtX[y, x]:=PMGbits(v);

  end;

 FileRead(f,TabKolor[$400],$100);

 end;
 
 FileClose(f);

 if FEditPMG.Visible then begin
  AktywnyWskaznik:=1;
  FEditPMG.AktualizujSprity;
  FEditPMG.frameLineRange1.seRange.Position:=239;
 end;

 Form1.OdswiezObraz; Blokada:=true;
end;

end;


procedure Load64C;
(*----------------------------------------------------------------------------*)
(* pliki z fontami dla C64                                                    *)
(*----------------------------------------------------------------------------*)
var f: integer;
begin
 form1.ClearAll;

 UstawScreen;

 f:= FileOpen(current_filename, fmOpenRead);
 FileSeek(f, 2, 0);

 FileRead(f,fonty,2048);

 FileClose(f);

 Ustaw_Znacznik_Kompresji_Znakow(2); SetTable;
 form1.ZnakCheck(ccStandard);

 form1.showMIC; done:=1; gate:=1; form1.cnv; PoKonwersji;
end;


function TForm1.nazwa: string;
begin
 Result:=ChangeFileExt(ExtractFileName(form1.OpenDialog1.FileName), '');
end;

function TForm1.snazwa: string;
begin
 Result:=ChangeFileExt({ExtractFileName}(form1.SaveDialog1.FileName), '');
end;

function sama_nazwa: string;
begin
 Result:=ChangeFileExt(ExtractFileName(form1.SaveDialog1.FileName), '');
end;


procedure LoadFNT_Piccolo(ras: Boolean);
(*----------------------------------------------------------------------------*)
(* Load Piccolo files                                                         *)
(*----------------------------------------------------------------------------*)
var fn: string;
begin

 fn:=Piccolo(current_filename, ras);

 if fn <> '' then begin

  current_filename := fn;
  LoadMCH;

  if ras then begin
   form1.SelectMode.ItemIndex:=4;   // PGR+
   UstawKompresje; form1.showMIC;
  end;
  
 end;

end;


procedure LoadFNT;
(*----------------------------------------------------------------------------*)
(* pliki FNT (1024 b)                                                         *)
(*----------------------------------------------------------------------------*)
var plik, ln: integer;
begin

 ClrCharsetTryb;

 plik:= FileOpen(current_filename, fmOpenRead);
 ln:=FileSeek(plik, 0, 2);
 FileSeek(plik, 0, 0);

 ln:=(ln shr 10) shl 10;

 if ln>length(fonty) then ln:=length(fonty);

 fillchar(tab,sizeof(tab),0);
 fillchar(fonty,sizeof(fonty),0);
 form1.ClrTable;

 fillchar(chFill,sizeof(chFill),96);

 clearMIC;
 FileRead(plik,fonty,ln); //if (ln shr 10)=1 then Original;
 FileClose(plik);

 Ustaw_Znacznik_Kompresji_Znakow(ln shr 10);

 if FileExists(ChangeFileExt(current_filename,'.tab')) then begin

  plik:= FileOpen(ChangeFileExt(current_filename,'.tab'), fmOpenRead);
  FileSeek(plik, 0, 0);
  FileRead(plik,table,sizeof(table));
  FileClose(plik);

  plik:= FileOpen(current_filename, fmOpenRead);
  FileSeek(plik, 0, 0);
  FileRead(plik,fonty,sizeof(fonty));
  FileClose(plik);

 end else begin

  ClearKolor;
  UstawScreen;

  plik:= FileOpen(current_filename, fmOpenRead);
  FileSeek(plik, 0, 0);
  FileRead(plik,fonty, ln);
  FileClose(plik);

  Ustaw_Znacznik_Kompresji_Znakow(2); SetTable;
  form1.ZnakCheck(ccStandard);

 end;

SetTable;

form1.zamknij(f_CharsFill);

form1.showMIC; done:=1; gate:=1; form1.cnv;
end;


procedure LoadINV;
(*----------------------------------------------------------------------------*)
(* pliki z informacja o inwersie znakow                                       *)
(*----------------------------------------------------------------------------*)
var f: integer;
    i: word;
    x, y: byte;
    inv: tablica_znakow;
begin
// fillchar(inv,sizeof(inv),0);

 f:= FileOpen(current_filename, fmOpenRead);
 FileSeek(f, 0, 0);

 for i:=0 to 29 do FileRead(f,inv[CzarnyPas shr 3+tmul48[i]],Bajt);
 FileClose(f);

 for y:=0 to 29 do
  for x:=0 to Bajt-1 do
   if gfxMode[y]=2 then move(inv[tmul48[y]],invers[tmul48[y]],48);

 form1.cnv;

 gate:=1; blokada:=false;
 form1.OdswiezObraz;
end;


procedure LoadSCR;
(*----------------------------------------------------------------------------*)
(* pliki z pamiecia obrazu SCR                                                *)
(*----------------------------------------------------------------------------*)
var plik: integer;
    i: byte;
//    ln: cardinal;
begin
fillchar(scren,sizeof(scren),0);

plik:= FileOpen(current_filename, fmOpenRead);
FileSeek(plik, 0, 0);

{
ln:=FileSize(plik); i:=$ff;
case ln of
 960: i:=0;
1200: i:=1;
1440: i:=2;
end;
if i<>$ff then form1.RadioGroup1.ItemIndex:=i;
}

for i:=0 to 29 do FileRead(plik,scren[form1.Sofs(0,tmul48[i])],bajt);

FileClose(plik);

move(scren,invers,sizeof(scren));

// zamien SCR na grafike bitmapy
fnt2buf;

ClearMic; form1.ShowMic;

with form1 do
 if not(optymizing1.Checked) and not(normal1.Checked) and not(jgp1.Checked) then begin
  form1.ZnakCheck(ccStandard);
 end;

UstawKompresje;
end;


procedure LoadLMT;
var plik: integer;
begin

 plik:= FileOpen(current_filename, fmOpenRead);
 FileSeek(plik, 0, 0);

 FileRead(plik, bmp_limit, sizeof(bmp_limit));

 FileClose(plik);

 form1.ShowMIC;
end;


procedure LoadPGR;
(*----------------------------------------------------------------------------*)
(* PGR (Power Graphics)                                                       *)
(*----------------------------------------------------------------------------*)
var i,x, plik, ln, skp:integer;
    ok, gfx: Boolean;
    ad: word;
    v, b, cyk: byte;
    nop: Boolean;

    label skip;

const
   hpgr = 'PowerGFX';

begin
 form1.ClearAll;

 form1.SelectMode.ItemIndex:=ord(m_pgr);    // PGR

 raster_ofset:=-12;
 FEditRasters.GlobalOfset.Position:=raster_ofset;

 plik:= FileOpen(current_filename, fmOpenRead);
 FileSeek(plik, 0, 0);

 FileRead(plik, bufor, 16);

 gfx:=false;

 ok:=true;

 for i := 1 to 8 do
  if byte(hpgr[i])<>bufor[7+i] then begin ok:=false; Break end;

 if ok then begin

 // $8300-$87FF - Grafika PMG.
  FileSeek(plik, $8300-$8206+6, 0);

  FileRead(plik, bufor, $100+8);            // missiles0

  for i := 0 to 256-8-1 do begin
   Smask[$100+i]:=byte(bufor[i+8] shl 6);
   Smask[$300+i]:=byte((bufor[i+8] and $0c) shl 4);
   Smask[$500+i]:=byte((bufor[i+8] and $30) shl 2);
   Smask[$700+i]:=(bufor[i+8] and $c0);
  end;

  FileRead(plik, Smask[$000], $100);      // player0
  FileRead(plik, Smask[$200], $100);      // player1
  FileRead(plik, Smask[$400], $100);      // player2
  FileRead(plik, Smask[$600], $100-8);    // player3

 // $83F8-$8405 - Zawartoœæ rejestrów GTIA $D000-$D00D na pocz¹tku ramki.
  FileSeek(plik, $83f8-$8206+6, 0);
  FileRead(plik, bufor, 13);

  with tgtia do begin
   hposp0:=bufor[0];
   hposp1:=bufor[1];
   hposp2:=bufor[2];
   hposp3:=bufor[3];

   hposm0:=bufor[4];
   hposm1:=bufor[5];
   hposm2:=bufor[6];
   hposm3:=bufor[7];

   sizep0:=bufor[8];
   sizep1:=bufor[9];
   sizep2:=bufor[10];
   sizep3:=bufor[11];

   sizem:=bufor[12];
  end;


 // $84F8-$8505 - Zawartoœæ rejestrów GTIA $D00E-$D01B na pocz¹tku ramki.
 // $8506 - Zawartoœæ rejestru DMACTL. Bity 2 i 3 s¹ te¿ wpisywane do bitów 0 i 1 rejestru GRACTL.
  FileSeek(plik, $84f8-$8206+6, 0);
  FileRead(plik, bufor, 15);

  with tgtia do begin
   colpm0:=bufor[4];
   colpm1:=bufor[5];
   colpm2:=bufor[6];
   colpm3:=bufor[7];

   color0:=bufor[8];
   color1:=bufor[9];
   color2:=bufor[10];
   color3:=bufor[11];
   colbak:=bufor[12];

   pmcntl:=3;
   gtictl:=bufor[13];
  end;


  fillchar(TabKolor[$500], 256, tgtia.colpm0);        // $d012
  fillchar(TabKolor[$600], 256, tgtia.colpm1);        // $d013
  fillchar(TabKolor[$700], 256, tgtia.colpm2);        // $d014
  fillchar(TabKolor[$800], 256, tgtia.colpm3);        // $d015

  fillchar(TabKolor[$100], 256, tgtia.color0);        // $d016
  fillchar(TabKolor[$200], 256, tgtia.color1);        // $d017
  fillchar(TabKolor[$300], 256, tgtia.color2);        // $d018
  fillchar(TabKolor[$400], 256, tgtia.color3);        // $d019
  fillchar(TabKolor[$000], 256, tgtia.colbak);        // $d01a


  if bufor[13]>=$40 then begin
   form1.SelectPixel.ItemIndex:=2;
   gfx:=true;
  end;

  case bufor[14] and 3 of
   1: form1.SelectScreen.ItemIndex:=0;   // NARROW
//   2: form1.SelectScreen.ItemIndex:=1;   // NORMAL
   3: form1.SelectScreen.ItemIndex:=2;   // WIDE
  else
   form1.SelectScreen.ItemIndex:=1;   // NORMAL
  end;


  FileSeek(plik, $8210-$8206+6, 0);
  FileRead(plik, bufor, sizeof(bufor));

  fillchar(tab, sizeof(tab), 0);

  skp:=0;

  i:=0;

  while (bufor[i]<>$41) and (i<240) do begin

 // liczymy puste linie obrazu
  while (bufor[i]=0) and (i<240) do begin inc(i); inc(skp) end;

 // znajdujemy LMS i odczytujemy adres danych obrazu
  while not(bufor[i] in [$4e, $4f]) and (i<240) do inc(i);

  if bufor[i] in [$4e, $4f] then begin
   ad:=bufor[i+1]+bufor[i+2] shl 8;

   if not(gfx) then begin
    if bufor[i]=$4f then form1.SelectPixel.ItemIndex:=0;
    if bufor[i]=$4e then form1.SelectPixel.ItemIndex:=1;

    gfx:=true;
   end;

   inc(i,3);

   FileSeek(plik, ad-$8206+6, 0);

   ln:=0;
   while (bufor[i] and $f0<>$40) and (i<240) do begin

    case bufor[i] of
     $00: begin fillchar(tab[tmul48[skp+ln]], 48,0); inc(ln) end;
     $0e: begin
           if gfxmode[i shr 3]<>2 then gfxmode[i shr 3]:=2;
           FileRead(plik, tab[tmul48[skp+ln]+CzarnyPas shr 3], Bajt);
           inc(skp);
          end;
     $0f: begin
           if not(gfxmode[i shr 3] in [1,4]) then gfxmode[i shr 3]:=1;
           FileRead(plik, tab[tmul48[skp+ln]+CzarnyPas shr 3], Bajt);
           inc(skp);
          end;
    end;

    inc(i);
   end;

  end;

  end;


 // program zmian rastra
  fillchar(fonty, sizeof(fonty), $3c);

  FileRead(plik, fonty, sizeof(fonty));

  ln:=0;
  i:=0;
  x:=0;
  cyk:=0;
  nop:=false;

 while fonty[i]<>$1c do inc(i);      //??????????????????????

  while ln<240 do begin
    v:=fonty[i];

    if v and $20<>0 then begin                                          // LDA #
//     if (x<12) and (cyk+2<=36) then begin
      raster[ln, x].cod:=1;
      raster[ln, x].arg:=fonty[i+1];
//      inc(cyk,2);
//     end;

     inc(x);
     inc(i);
    end;

    if (v and $1f>=$1c) then begin        // NOP

     b:=ord(v and $40<>0)+ord(v and $80<>0) shl 1+ord(v and 1<>0) shl 2+ord(v and 2<>0) shl 3;

     if b=0 then begin
      inc(ln);
      x:=0;
      cyk:=0;
      nop:=false;

      goto skip;
     end;

//     if not(nop) then
//      if b-7<0 then b:=0 else dec(b,7);

//     if (x<12) and (cyk+b*2<=36) then begin
      raster[ln, x].cod:=0;
      raster[ln, x].arg:=b shl 1;
//      inc(cyk,b*2);
//     end;

     inc(x);
//     nop:=true;

     goto skip;
    end;


    if v and $40<>0 then begin           // nop*1

//      if (x<12) and (cyk+2<=36) then begin
       raster[ln, x].cod:=0;
       raster[ln, x].arg:=2;
//       inc(cyk,2);
//      end;

      inc(x);
//      nop:=true;
    end;


//     if (x<12) and (cyk+4<=36) then begin
      raster[ln, x].cod:=$81;
      raster[ln, x].arg:=v and $1f;
//      inc(cyk,4);
//     end;

     inc(x);


     if v and $80<>0 then begin
      inc(ln);
      x:=0;
      cyk:=0;
      nop:=false;
     end;


skip:

   inc(i);
  end;

  FileClose(plik);

  SaveAfterExit:=false;

  form1.set_pf_colors;
  Done:=0; gate:=1; UstawKompresje; form1.ShowMic;

 end else begin
  FileClose(plik);
  Application.MessageBox('Incorrect header for this file type.','Load PGR',MB_ICONERROR);
 end;

end;


procedure LoadGED;
(*----------------------------------------------------------------------------*)
(* GED                                                                        *)
(*----------------------------------------------------------------------------*)
var i, plik:integer;
    v:byte;
begin
form1.ClearAll;

//musi byc Pixel=2, Bajt=40
form1.SelectScreen.ItemIndex:=1;

form1.SelectMode.ItemIndex:=0;

plik:= FileOpen(current_filename, fmOpenRead);
FileSeek(plik, 0, 0);

FileRead(plik,bufor,6);            // ominiecie naglowka $FF $FF ...
FileRead(plik,bufor,2000);         // 8 tablic po 200 bajtow i dodatkowe tb0, tb1

FileRead(plik,Smask,1280);         // dane spritow

FileRead(plik,temp,16);            // 16 bajtow z wartosciami poczatkowymi
for i:=0 to 3 do fillchar(tabKolor[$500+i shl 8],$100,temp[i]);
fillchar(tabKolor[$400],200,temp[7]);    //kolor pociskow $d019
fillchar(tabKolor,200,temp[8]);          //kolor tla

// odczyt obrazka
for i:=0 to 101 do FileRead(plik,tab[4+tmul48[i]],40);
//blockread(dane,temp,6,err);
for i:=0 to 81 do FileRead(plik,tab[4+102*48+tmul48[i]],40);
FileClose(plik);

// przepisanie kolorow
move(bufor[400],TabKolor[$100],200);
move(bufor[600],TabKolor[$200],200);
move(bufor[800],TabKolor[$300],200);

// dekodowanie tablic tb0, tb1
// tb1 mlodszy bajt rejestru do modyfikacji, starszy bajt = $d0
// tb0 wartosc, ktora nalezy wpisac do rejestru
for i:=0 to 199 do begin
v:=bufor[i];
 case bufor[200+i] of
  $1a: tabKolor[i]:=v;
//  $12: tabKolor[$500+i]:=v;
//  $13: tabKolor[$600+i]:=v;
//  $14: tabKolor[$700+i]:=v;
//  $15: tabKolor[$800+i]:=v;
 end;
end;

form1.set_pf_colors;
Done:=0; gate:=1; UstawKompresje; form1.ShowMic;
end;


procedure show_title(const a: string);
begin

  form1.caption:=a;

end;


procedure LoadJGP;
(*----------------------------------------------------------------------------*)
(* Jet Graphics Planner                                                       *)
(*----------------------------------------------------------------------------*)
var i, f: integer;
begin

 form1.ClearAll;
 form1.SelectScreen.ItemIndex:=0;
 form1.SelectPixel.ItemIndex:=1;

// ustawia table na 0,1,0,1,0,1,0,1,0,1,...
for i:=0 to 29 do table[i]:=i and 1;

fillchar(scren,sizeof(scren),0);
for i:=0 to 31 do begin
 scren[i+8]:=i;        scren[i+48+8]:=i;
 scren[i+96+8]:=i+32;  scren[i+144+8]:=i+32;
 scren[i+192+8]:=i+64; scren[i+240+8]:=i+64;
 scren[i+288+8]:=i+96; scren[i+336+8]:=i+96;
end;
move(scren,invers,sizeof(scren));

f:= FileOpen(current_filename, fmOpenRead);
FileSeek(f, 6, 0);
FileRead(f,fonty,2048);
FileClose(f);

Ustaw_Znacznik_Kompresji_Znakow(2);

SetTable;

form1.ZnakCheck(ccJgp1);

form1.showMIC; done:=1; gate:=1; form1.cnv; PoKonwersji;
end;


//----------------------------------------------------------------------------//
// KOALA                                                                      //
//----------------------------------------------------------------------------//

procedure PutPic(a:byte; sze,wys:word; var tmp1,tmp2: integer);
// odpowiednie rozmieszczanie zdekodowanych danych w pamieci obrazu TAB
var i: integer;
begin

// w TMP2 jest wartosc typcprs
case tmp2 of
 1: begin
     bufor[tmp1]:=a; if px<48 then inc(tmp1);
     if tmp1=wys then begin
      tmp1:=0;
      for i:=0 to (wys shr 1)-1 do begin
       tab[px+i*96]:=bufor[i];
       tab[px+i*96+48]:=bufor[wys shr 1+i];
      end;
      inc(px);
     end;
    end;

 2: begin
     bufor[tmp1]:=a; if py<wys then inc(tmp1);
     if tmp1=sze then begin
      tmp1:=0; for i:=0 to sze-1 do tab[px+i+tmul48[py]]:=bufor[i];
      inc(py);
     end;
    end;
end;
end;


procedure LoadPIC;
(*----------------------------------------------------------------------------*)
(* odczyt plików KOALI (*.PIC)                                                *)
(*----------------------------------------------------------------------------*)
var v: byte;
    ln, ile, i: word;
    all: cardinal;
    id: cardinal;    // bajty naglowka PIC'a
    headln: word;
    revision: byte;
    typcprs: byte;
    antic: byte;
    scrwidth: word;
    scrheight: word;
    colors: array [0..4] of byte;
    picln: word;
    unused: word;
    plik, tmp1,tmp2: integer;
begin
form1.ClearAll;

fillchar(bufor,sizeof(bufor),0);

plik:= FileOpen(current_filename, fmOpenRead);
FileSeek(plik, 0, 0);

// czytamy naglowek PIC'a
FileRead(plik,id,sizeof(id));
FileRead(plik,headln,sizeof(headln));
FileRead(plik,revision,sizeof(revision));
FileRead(plik,typcprs,sizeof(typcprs));
FileRead(plik,antic,sizeof(antic));
FileRead(plik,i,sizeof(i)); scrwidth:=byte(i and $ff) shl 8+byte(i shr 8);
FileRead(plik,i,sizeof(i)); scrheight:=byte(i and $ff) shl 8+byte(i shr 8);
FileRead(plik,colors,sizeof(colors));
FileRead(plik,picln,sizeof(picln));
FileRead(plik,unused,sizeof(unused));

if id=$c7c980ff then begin

case scrwidth of
 40: i:=1;
 48: i:=2;
else
 i:=0
end;

form1.SelectScreen.ItemIndex:=i;

ln:=headln; if (ln=0) or (ln>1024) then ln:=26;
FileRead(plik,bufor,ln-21);    // naglowek ma 21 bajtow

// zaladowanie danych obrazka
all:=FileRead(plik,fonty,sizeof(fonty));

FileClose(plik);

ln:=0; {ile:=0;} tmp1:=0; tmp2:=typcprs; px:=CzarnyPas shr 3; py:=0;

// dekompresja, wg 'typcprs'
case typcprs of
 1,2: while ln<=all do begin
      case (fonty[ln] and $80) of
       $00: begin                   // z kompresja
             ile:=fonty[ln]; inc(ln);
             if ile=0 then begin    // wiekszy blok
              ile:=fonty[ln+1]+fonty[ln] shl 8;
              inc(ln,2);
             end;
             v:=fonty[ln]; inc(ln);
             for i:=0 to ile-1 do putPic(v,scrwidth,scrheight, tmp1,tmp2);
            end;

       $80: begin                   // bez kompresji
             ile:=fonty[ln] and $7f; inc(ln);
             if ile=0 then begin    // wiekszy blok danych
              ile:=fonty[ln+1]+fonty[ln] shl 8;
              inc(ln,2);
             end;
             for i:=0 to ile-1 do putPic(fonty[ln+i],scrwidth,scrheight, tmp1,tmp2);
             inc(ln,ile);
            end;
     end;
    end;
end;

fillchar(TabKolor[$100],$100,colors[0]);  //708
fillchar(TabKolor[$200],$100,colors[1]);  //709
fillchar(TabKolor[$300],$100,colors[2]);  //710
fillchar(TabKolor[$400],$100,colors[3]);  //711
fillchar(TabKolor[$000],$100,colors[4]);  //712

form1.set_pf_colors;

gate:=1; Done:=0; ZwiekszHig(scrheight);
UstawKompresje; form1.showMIC;

SaveAfterExit:=false;

end else begin
 FileClose(plik);
 Application.MessageBox('Incorrect header for this file type.','Load PIC',MB_ICONERROR);
end;

end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//


procedure zapisz_vsc(const ofs: integer);
var mul, x, tb, pm, i: integer;
begin

 tb:=48*8;
 pm:=sizeof(tablica_sprite)*8;
 //rs:=24*8;

 mul:= 48 + 48 + 48*8 + sizeof(tablica_sprite)*8 + sizeof(tablica_sprite)*8 + 16*8 + 8*8 + 24*8 + 1 + 9*8;

for i:=0 to 29 do begin

 x:=ofs + i;

 FileSeek(fvsc, x*mul, 0);

 FileWrite(fvsc,scren[tmul48[i]],48);         // 48 b
 FileWrite(fvsc,invers[tmul48[i]],48);        // 48 b

 FileWrite(fvsc,tab[i*tb],tb);                // 48*8 b

 FileWrite(fvsc,Sprajt  [i*8] , pm);         // 290*8 b
 FileWrite(fvsc,SprajtX [i*8] , pm);         // 290*8 b

 FileWrite(fvsc , Spr0 [i shl 3] , 16);       // 16*8 b
 FileWrite(fvsc , Spr1 [i shl 3] , 16);
 FileWrite(fvsc , Spr2 [i shl 3] , 16);
 FileWrite(fvsc , Spr3 [i shl 3] , 16);
 FileWrite(fvsc , Mis0 [i shl 3] , 16);
 FileWrite(fvsc , Mis1 [i shl 3] , 16);
 FileWrite(fvsc , Mis2 [i shl 3] , 16);
 FileWrite(fvsc , Mis3 [i shl 3] , 16);

 FileWrite(fvsc,Smask[$000 + i shl 3],8);     // 8*8 b
 FileWrite(fvsc,Smask[$100 + i shl 3],8);
 FileWrite(fvsc,Smask[$200 + i shl 3],8);
 FileWrite(fvsc,Smask[$300 + i shl 3],8);
 FileWrite(fvsc,Smask[$400 + i shl 3],8);
 FileWrite(fvsc,Smask[$500 + i shl 3],8);
 FileWrite(fvsc,Smask[$600 + i shl 3],8);
 FileWrite(fvsc,Smask[$700 + i shl 3],8);

// FileWrite(fvsc,raster[i*rs],rs);             // 24*8+1 b
 FileWrite(fvsc,gfxMode[i],1);

 FileWrite(fvsc,TabKolor[$000 + i shl 3],8);  // 9*8 b
 FileWrite(fvsc,TabKolor[$100 + i shl 3],8);
 FileWrite(fvsc,TabKolor[$200 + i shl 3],8);
 FileWrite(fvsc,TabKolor[$300 + i shl 3],8);
 FileWrite(fvsc,TabKolor[$400 + i shl 3],8);
 FileWrite(fvsc,TabKolor[$500 + i shl 3],8);
 FileWrite(fvsc,TabKolor[$600 + i shl 3],8);
 FileWrite(fvsc,TabKolor[$700 + i shl 3],8);
 FileWrite(fvsc,TabKolor[$800 + i shl 3],8);

end;

end;


procedure LoadOK;
(*----------------------------------------------------------------------------*)
(* LOAD OK                                                                    *)
(*----------------------------------------------------------------------------*)
begin

  with form1 do begin
   SelectPreview.Enabled:=true;

//   SelectPixel.Enabled:=false;

   MenuScreen.Visible:=true;
   MenuScreen.Enabled:=true;

   Check1.Enabled:=true;

   Swap1.Enabled:=true;
   EditPMG.Enabled:=true;

   SaveAs1.Enabled:=true;

   MenuOptions.Visible:=true;
   MenuOptions.Enabled:=true;

   MenuEdit.Visible:=true;
   MenuEdit.Enabled:=true;

//   EditBitmap.Enabled:=true;        // Edit Bitmap
//   EditColors.Enabled:=true;        // Edit Colors
//   EditCharset.Enabled:=true;       // Edit Charset
//   EditPalette.Enabled:=true;       // Edit Palette
//   EditPMG.Enabled:=true;           // Edit PMG

   SelectModeClick(form1);

   if t_mode(SelectMode.ItemIndex)<>m_dli then
    EditRasters.Enabled:=true;      // Edit Rasters

   if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin
    EditColorsMap.Enabled:=true;       // Edit Colors Map
    ShowColorsMap1.Enabled:=true;
   end;

   image1.Enabled:=true;

  end;

 form1.pobierzPalete(0,0);

 palCol[0]:=palCol[2];
 palCol[1]:=palCol[2];

 pisCol[0]:=0;
 pisCol[1]:=0;

 Blokada:=false;

end;


procedure LoadVSC;
(*----------------------------------------------------------------------------*)
(* Load Vertical Scroll                                                       *)
(*----------------------------------------------------------------------------*)
var t: textfile;
    a, txt, pth: string;
begin

 if vscrol.use then FileClose(fvsc);

 pth:=ExtractFilePath(form1.OpenDialog1.InitialDir);

 fvsc:=FileCreate(form1.GetUndoName('###vsc.dat'));

 vscrol.pos:=0;
 vscrol.max:=0;
 vscrol.nam:=current_filename;
 vscrol.pth:=pth;

 assignfile(t,current_filename); FileMode:=0; reset(t);
 while not eof(t) do begin
  readln(t,a);

  if (ExtractFilePath(a)='') and (pth<>'') then a:=pth+'/'+a;

  if FileExists(a) then begin
   txt:=current_filename;

   current_filename:=a;
   form1.PreviewButton;
   current_filename:=txt;

   SaveAfterExit:=false;

   form1.Normal1Click(form1);
  end;

  zapisz_vsc(vscrol.max);

  inc(vscrol.max,30);
 end;

 closefile(t);

 vscrol.use:=true;

 form1.czytaj_vsc;

 form1.OdswiezObraz;

end;


procedure sblk(var src,dst: integer; const ile:integer);
var i: integer;
begin

 for i:=0 to (ile shr 8) do begin
  FileRead(src,bufor,256);
  FileWrite(dst,bufor,256);
 end;

end;


procedure czytaj_hsc;
var ofs: integer;
    i, j: byte;
begin

 ofs:=vscrol.pos;

 FileSeek(fhtab, ofs*240, 0);
 for i:=0 to 47 do
  for j:=0 to 239 do
   FileRead(fhtab,tab[i+tmul48[j]],1);

 FileSeek(fhscr, ofs*30, 0);
 for i:=0 to 47 do
  for j:=0 to 29 do
   FileRead(fhscr,scren[i+tmul48[j]],1);

 FileSeek(fhinv, ofs*30, 0);
 for i:=0 to 47 do
  for j:=0 to 29 do
   FileRead(fhinv,invers[i+tmul48[j]],1);

end;


procedure zapisz_hsc(const ofs: integer);
var i, j: byte;
begin

 FileSeek(fhtab, ofs*240, 0);
 for i:=0 to 47 do
  for j:=0 to 239 do
   FileWrite(fhtab,tab[i+tmul48[j]],1);

 FileSeek(fhscr, ofs*30, 0);
 for i:=0 to 47 do
  for j:=0 to 29 do
   FileWrite(fhscr,scren[i+tmul48[j]],1);

 FileSeek(fhinv, ofs*30, 0);
 for i:=0 to 47 do
  for j:=0 to 29 do
   FileWrite(fhinv,invers[i+tmul48[j]],1);

end;


procedure TForm1.PobierzPalete(const x,y: integer);
var i: integer;
begin

 if (t_mode(form1.SelectMode.ItemIndex)<>m_dli) {or ((t_mode(form1.SelectMode.ItemIndex)=m_gedp) and (y and 7=0))} then begin

  form1.TestRaster(x,y,0,0);

 end else
  for i:=0 to 384 do begin
   RasterLine[i].kolor[0]:=TabKolor[$000+y];
   RasterLine[i].kolor[1]:=TabKolor[$100+y];
   RasterLine[i].kolor[2]:=TabKolor[$200+y];
   RasterLine[i].kolor[3]:=TabKolor[$300+y];
   RasterLine[i].kolor[4]:=TabKolor[$400+y];

   RasterLine[i].kolor[5]:=TabKolor[$500+y];
   RasterLine[i].kolor[6]:=TabKolor[$600+y];
   RasterLine[i].kolor[7]:=TabKolor[$700+y];
   RasterLine[i].kolor[8]:=TabKolor[$800+y];

   RasterLine[i].gtia:=rKolor[y, 9];
  end;

 case Pixel of
  1: begin
      palCol[2]:=RasterLine[x].kolor[3];
      palCol[3]:=RasterLine[x].kolor[2];

      if old_gfxMode[y shr 3]=2 then palCol[3]:=RasterLine[x].kolor[3] and $f0+RasterLine[x].kolor[2] and $0f;

//      palCol[2]:=RasterLine[x].kolor[3];
//      palCol[3]:=RasterLine[x].kolor[3] and $f0+RasterLine[x].kolor[2] and $0f;
//      if old_gfxMode[y shr 3]=2 then palCol[3]:=RasterLine[x].kolor[3] and $f0+RasterLine[x].kolor[2] and $0f;
     end;

  2: begin
      palCol[2]:=RasterLine[x].kolor[0];
      palCol[3]:=RasterLine[x].kolor[1];
      palCol[4]:=RasterLine[x].kolor[2];
      palCol[5]:=RasterLine[x].kolor[3];
      palCol[6]:=RasterLine[x].kolor[3];
     end;

  4: if {GetGTIAType(rKolor[y, 9])=gr10} t_gtia(form1.SelectGTIA.ItemIndex)=gr10 then
      for i:=0 to 8 do palCol[2+i]:=RasterLine[x].kolor[i]                      //gr10
     else
      for i:=0 to 15 do palCol[2+i]:=form1.gr9col(RasterLine[x].kolor[0], i, {GetGTIAType(rKolor[y, 9])} t_gtia(form1.SelectGTIA.ItemIndex));   //gr9,gr11

 end;

 palCol[0]:=palCol[pisCol[0]+2];
 palCol[1]:=palCol[pisCol[1]+2];
end;


procedure LoadRAS;
(*----------------------------------------------------------------------------*)
(* LOAD Raster program                                                        *)
(*----------------------------------------------------------------------------*)
var f, j: integer;
begin

 f:= FileOpen(current_filename, fmOpenRead);
 FileSeek(f, 0, 0);

 fillchar(bufor, sizeof(bufor), 0);     // Raster

 for j := 0 to 239 do begin
  FileRead(f, bufor, 2);

  raster_line_ofset[j].cod := bufor[0];
  raster_line_ofset[j].arg := bufor[1];

  FileRead(f, raster[j], sizeof(tARaster));
 end;

 bufor[0]:=-5+24;
 FileRead(f, bufor, 1);

 raster_ofset:=bufor[0]-24;

 FEditRasters.GlobalOfset.Position:=raster_ofset;


 fillchar(bufor, sizeof(bufor), 0);     // tgtia

 FileRead(f, tgtia, sizeof(tgtia));

 FileClose(f);


 if tgtia.gtictl=0 then begin
  tgtia.gtictl:=4;
  tgtia.pmcntl:=3;
 end;

 form1.OdswiezObraz;
end;


procedure SaveRAS;
(*----------------------------------------------------------------------------*)
(* SAVE Raster program                                                        *)
(*----------------------------------------------------------------------------*)
var f, j: integer;
    zm: string;
    v: byte;
begin

 zm:=form1.Savedialog1.FileName;
 zm:=ChangeFileExt(zm, '.ras');

 f:=FileCreate(zm);

 for j := 0 to 239 do begin
  bufor[0] := raster_line_ofset[j].cod;
  bufor[1] := raster_line_ofset[j].arg;

  FileWrite(f, bufor, 2);

  FileWrite(f, raster[j], sizeof(tARaster));
 end;

 v:=FEditRasters.GlobalOfset.Position+24;

 FileWrite(f, v, 1);

 FileWrite(f, tgtia, sizeof(tgtia));

 FileClose(f);
end;


procedure LoadG2F;
(*----------------------------------------------------------------------------*)
(* ladowanie, dekompresja pliku G2F                                           *)
(*----------------------------------------------------------------------------*)
var v, ze, kompresja_znakow, _g: byte;
    i, err, siku, plik, plik2: integer;
    hea: array [0..6] of byte;
    pack, depack: string;
    old_cnvadr, old_ofset: Boolean;
begin

form1.ClearAll;                               // !!! koniecznie

min_znakow:=0; ile_znakow:=127;
fillchar(chlimit, sizeof(chlimit), true);

fillchar(bufor, sizeof(bufor), 0);

vscrol.use:=false;  hscrol:=false;

//ClearRaster;
blokada:=true;

form1.SelectMode.ItemIndex:=ord(m_dli);

plik:=FileOpen(current_filename, fmOpenRead);
FileSeek(plik, 0, 0);

// sprawdzamy czy nie jest spakowany
fillchar(hea,sizeof(hea),0);

FileRead(plik,hea,sizeof(hea));

v:=$ff;
for i:=0 to sizeof(g2fzlib_hea)-1 do
 if hea[i]<>byte(g2fzlib_hea[i]) then begin v:=0; Break end;

if v=$ff then begin
 FileClose(plik);

 pack:=GetTempName;
 depack:=GetTempName;

 plik:=FileOpen(current_filename, fmOpenRead);
 siku:=FileSeek(plik, 0, 2);
 FileSeek(plik, 7, 0);

 plik2:=FileCreate(pack);

 err:=7;
 while err<siku do begin
  i:=FileRead(plik, bufor, sizeof(bufor));
  FileWrite(plik2, bufor, i);
  inc(err, i);
 end;

 FileClose(plik);
 FileClose(plik2);

 form1.Depack_Zlib(pack, depack);

 plik:=FileOpen(depack, fmOpenRead);

end;

siku:=0;

FileSeek(plik, 0, 0);

form1.zamknij(f_Zoom);
form1.zamknij(f_SelectColor);
form1.zamknij(f_Move);
form1.zamknij(f_CharsFill);

ClearMic;
fillchar(scren,sizeof(scren),0);
fillchar(tab,sizeof(tab),0);
fillchar(chFill,sizeof(chFill),96);

inc(siku, FileRead(plik,bufor,3));
Bajt:=bufor[0] and $7f;

old_ofset:=bufor[0]<128;


Pixel:=bufor[1] and 7;
_g:=0;

if Pixel >= 4 then begin
 _g:=Pixel-4;
 Pixel:=4;
end;


kompresja_znakow:=bufor[1] and $f8;

zestaw:=bufor[2] and $7f; ze:=zestaw+1;

old_cnvadr:=bufor[2]<128;                     // jesli OLD_CNVADR=TRUE zamien program rastra na nowy

if (bajt in [32,40,48]) and (pixel in [1,2,4]) then begin

case Bajt of
 40: v:=1;
 48: v:=2;
else
 v:=0
end;

form1.SelectScreen.ItemIndex:=v;
form1.SelectPixel.ItemIndex:=Pixel shr 1;

ustawGfxMode(Pixel);

form1.SelectGTIA.ItemIndex:=_g;

// load screens
for i:=0 to 29 do inc(siku, FileRead(plik, scren[form1.Sofs(0,tmul48[i])], bajt));
move(scren,invers,sizeof(scren));

move(invers,invers2,sizeof(invers));

// load fonts
form1.ZnakCheck(ccNul);
inc(siku, FileRead(plik, fonty, ze shl 10));
ClrCharsetTryb;

// load table
inc(siku, FileRead(plik, table, 30));
move(table, table2, sizeof(table));

ClrJGPplusCharsetCheck;

if kompresja_znakow=0 then
 Ustaw_Znacznik_Kompresji_Znakow(ze)
else begin

 if kompresja_znakow and $80<>0 then form1.ZnakCheck(ccStandard);
 if kompresja_znakow and $40<>0 then begin form1.ZnakCheck(ccOptymizing); FSpecial.ChrOpty.ItemIndex:=0 end;  // Optymizing Normal
 if kompresja_znakow and $20<>0 then begin form1.ZnakCheck(ccOptymizing); FSpecial.ChrOpty.ItemIndex:=1 end;  // Optymizing Maximum
 if kompresja_znakow and $10<>0 then form1.ZnakCheck(ccJgp1);
 if kompresja_znakow and $08<>0 then begin
  form1.ZnakCheck(ccJgp2);

  case ze of
   2: form1.Charsetx2.Checked:=true;
   3: form1.Charsetx3.Checked:=true;
   4: form1.Charsetx4.Checked:=true;
   5: form1.Charsetx5.Checked:=true;
   6: form1.Charsetx6.Checked:=true;
   7: form1.Charsetx7.Checked:=true;
   8: form1.Charsetx8.Checked:=true;
  end;

  JGPplusCharset:=ze;

 end;

end;

//if form1.Optymizing1.Checked then form1.Original1.Enabled:=true;

// odczytaj z table informacje o wymuszaniu zestawow
for i:=0 to 29 do begin
 if table[i]>$7f then newFnt[i]:=$FF else newFnt[i]:=0;
 table[i]:=table[i] and $7f;
end;

FileSeek(plik, siku+153664, 0);

// gfxMode
FileRead(plik, bufor, 30);

err:=$ff;
for i:=0 to 29 do
 case
  bufor[i] of 0,3,5..254: err:=0;
 end;


if err<>0 then begin
 for i:=0 to 29 do
  if bufor[i]=$FF then bufor[i]:=0;

 move(bufor,gfxMode,sizeof(gfxMode));

 form1.ustawMemo;
end;

SetTable;

FileSeek(plik, siku, 0);


// load colors
FileRead(plik,TabKolor,5*$100);

// load sprites
FileRead(plik,TabKolor[$500],4*$100);

FileRead(plik,Spr0,$200); FileRead(plik,Mis0,$200);
FileRead(plik,Spr1,$200); FileRead(plik,Mis1,$200);
FileRead(plik,Spr2,$200); FileRead(plik,Mis2,$200);
FileRead(plik,Spr3,$200); FileRead(plik,Mis3,$200);

FileRead(plik,Smask,$800);

for i := 0 to 239 do FileRead(plik,Sprajt[i,0],290);
for i := 0 to 239 do FileRead(plik,SprajtX[i,0],290);

fillchar(bufor,256,0); FileRead(plik,bufor,256);


// dla Pixel=1 konwersja PRIOR na =1 jesli inny niz [0,1]

for i := 0 to 239 do
 if gfxMode[i shr 3] = 1 then
  if (Spr0[i] shr 12) and 7 = 0 then Spr0[i]:=(Spr0[i] and $8fff) or ((2 shl 12) and $7000);


//znacznik Mode (GED+, DLI)
 if not(bufor[1] in [0..5]) then bufor[1]:=2;

 i:=bufor[1];

 if i>0 then
  form1.SelectMode.ItemIndex:=i-1
 else
  form1.SelectMode.ItemIndex:=ord(m_dli);


 form1.SpecialVal(___nobadlines, cFlatUnCheck+ord(bufor[1] and $80<>0));

 if bufor[1] and $40=0 then begin
  form1.SpecialVal(___ModeDLIplus, cFlatUnCheck);
  form1.SpecialVal(___ModeDLI, cFlatChecked);
 end else begin
  form1.SpecialVal(___ModeDLIplus, cFlatChecked);
  form1.SpecialVal(___ModeDLI, cFlatUnCheck);
 end;

 form1.SpecialVal(___LMSperline, cFlatUnCheck+ord(bufor[2] and $80<>0));
 form1.SpecialVal(___DLIchangesIn, cFlatUnCheck+ord(bufor[2] and $40<>0));
 form1.SpecialVal(___doublescan, cFlatUnCheck+ord(bufor[2] and $20<>0));

 FileRead(plik,bufor,240*24);

 ClearRaster;

 if old_cnvadr then                   // konwersja do nowego sposobu zapisu - tak powinno byc od poczatku
  for i := 0 to (240*24 div 2)-1 do
   if bufor[i shl 1] in [$81..$83] then bufor[i shl 1+1]:=StrToInt(CnvAdr[bufor[i shl 1+1]]) and $1f;

 for i:=0 to 239 do
  for err := 0 to 11 do begin
   raster[i, err].cod := bufor[i*24+err shl 1];
   raster[i, err].arg := bufor[i*24+err shl 1+1];
  end;


// gfxMode, wczytaj do tablicy jesli wartosci sa <>0
FileRead(plik,bufor,30);


{
err:=$ff;
for i:=0 to 29 do
 case
  bufor[i] of 0,3,5..254: err:=0;
 end;


if err<>0 then begin
 for i:=0 to 29 do
  if bufor[i]=$FF then bufor[i]:=0;

 move(bufor,gfxMode,sizeof(gfxMode));
 ustawMemo;
end;       }


FileRead(plik,bufor,240-30); //tutaj byl UsedRaster ale wypadl :)

FileRead(plik,bufor,16);

if old_ofset then
 i:=bufor[0]-8
else
 i:=bufor[0]-24;

raster_ofset:=i;

FEditRasters.GlobalOfset.Position:=raster_ofset;

bufor[0]:=127; FileRead(plik, bufor,1);
if bufor[0]>127 then bufor[0]:=127;
ile_znakow:=bufor[0];

// odczyt informacji na temat zablokowanych zmian kolorow
FileRead(plik, locKolor, $500);

// odczyt informacji o ANTIC+ ??? i mapy kolorow
bufor[0]:=0;
bufor[1]:=8;
bufor[2]:=8;

FileRead(plik, bufor, 3);


if not (bufor[0] in [0..1]) then bufor[0]:=0;           // 0 = GTIA, 1 = VBXE
form1.SelectVideo.ItemIndex:=bufor[0];


if bufor[0]>0 then begin
 form1.EditColorsMap.Enabled:=true;
 form1.ShowColorsMap1.Enabled:=true;
end;

cmap_cellW:=bufor[1]; if cmap_cellW<8 then cmap_cellW:=8;                      
cmap_cellH:=bufor[2]; if cmap_cellH<1 then cmap_cellH:=1;                      

FileRead(plik, cmap, sizeof(cmap));


bufor[0]:=0;
FileRead(plik, bufor, 1);
if bufor[0]>127 then bufor[0]:=0;
min_znakow:=bufor[0];

for i:=0 to 29 do FileRead(plik, invers2[form1.Sofs(0,tmul48[i])], bajt);

FileRead(plik, table2, 30);

FileRead(plik, chlimit, 128);

fillchar(raster_line_ofset, sizeof(raster_line_ofset), 0);
FileRead(plik, raster_line_ofset, sizeof(raster_line_ofset));

{
fillchar(bufor, sizeof(bufor), 0);

FileRead(plik, bufor, sizeof(raster_line_ofset));

for i := 0 to 239 do begin
 raster_line_ofset[i].cod:=bufor[i*2+1];
 raster_line_ofset[i].arg:=bufor[i*2];
end;
}


fillchar(bufor, sizeof(bufor), 1);
FileRead(plik, bufor, 5);

FSpecial.ged_a.Checked:=bufor[0]<>0;
FSpecial.ged_x.Checked:=bufor[1]<>0;
FSpecial.ged_y.Checked:=bufor[2]<>0;

FSpecial.chk_players.Checked:=bufor[3]<>0;
FSpecial.chk_missiles.Checked:=bufor[4]<>0;

FileRead(plik, bufor, 14);

fillchar(bmp_limit, sizeof(bmp_limit), false);
FileRead(plik, bmp_limit, sizeof(bmp_limit));

fillchar(startCharset, sizeof(startCharset), 0);
FileRead(plik, startCharset, sizeof(startCharset));

FileRead(plik, raster, sizeof(raster));

FileRead(plik, tgtia, sizeof(tgtia));

FileRead(plik, locKolor, sizeof(locKolor));

bufor[0]:=$ff;
FileRead(plik, bufor, 1);

row_limit:=bufor[0];

for i := 0 to 7 do
 FSpecial.CheckListBox1.Checked[i] := row_limit and twyt1[i]<>0;

fillchar(chrctl_edit, sizeof(chrctl_edit), 2);
FileRead(plik, chrctl_edit, sizeof(chrctl_edit));

for i := 0 to 29 do 
 if chrctl_edit[i]=0 then chrctl_edit[i]:=2;


blokada:=false; done:=1; gate:=1; form1.ShowMic;

form1.cnv;

end;


form1.set_pf_colors;

FileClose(plik);

resolution_info;

SaveAfterExit:=false;

SpecialUpdate;

end;


procedure Preview;
(*----------------------------------------------------------------------------*)
(* PREVIEW                                                                    *)
(*----------------------------------------------------------------------------*)
var tst, tmpString: string;
begin

tmpString:=current_filename;

if FileExists(current_filename) then begin

 undo_index:=0;

 tryb:=0; Blokada:=true;  vscrol.use:=false;  hscrol:=false;

 form1.SelectPreview.ItemIndex:=ord(___ALL);
 charset:=0; charset_old:=$ff; showCharset:=false;

 form1.zamknij(f_EditPMG);
 form1.zamknij(f_EditColors);
 form1.zamknij(f_EditCharset);
 form1.zamknij(f_CharsFill);
 form1.zamknij(f_Check);
 form1.zamknij(f_EditPalette);
 form1.zamknij(f_EditColorsMap);
 form1.zamknij(f_Bmp2Pmg);
 form1.zamknij(f_PaletteOptions);

 form1.Refresh;

 PoprawBmp:=true; AsmError:=true;

 ClearNewFnt;

 ClearActiveColor($ff);

 show_title(current_filename);

 with form1 do begin
  EditColors.Checked:=false;
  EditPMG.Checked:=false;

  EditUndo1.Enabled:=false;
  EditRedo1.Enabled:=false;

  zamknij(f_EditPMG);
  zamknij(f_ImportBMP);

  showchars1.Checked:=false;
  Usun_Zaznaczenia(false);

  image2.Enabled:=true;
  image3.Enabled:=true;
  image7.Enabled:=true;

  refresh;
 end;

    tst:=AnsiUpperCase(ExtractFileExt(current_filename));

    if (tst='.MIC') or (tst='.DAT') then LoadMIC;
    if (tst='.BMP') or (tst='.GIF') or (tst='.PNG') or (tst='.JPG') then LoadBMP;

    if tst='.CHSET' then LoadFNT_Piccolo(false);
    if tst='.CHNAME' then LoadFNT_Piccolo(false);
    if tst='.KERNEL' then LoadFNT_Piccolo(true);

    if tst='.FNT' then LoadFNT;
    if tst='.GED' then LoadGED;
    if tst='.INV' then LoadINV;
    if tst='.JGP' then LoadJGP;
    if tst='.SCR' then LoadSCR;
    if tst='.COL' then LoadCOL;
    if tst='.PGR' then LoadPGR;

    if tst='.LMT' then LoadLMT;
    if tst='.RAS' then LoadRAS;

    if tst='.PMG' then LoadPMG;

    if tst='.G2F' then LoadG2F;

    if tst='.PIC' then LoadPIC;
    if tst='.VSC' then LoadVSC;
    if tst='.64C' then Load64C;

    if tst='.MCH' then LoadMCH;
    if tst='.G10' then LoadG10;

 if (tst<>'.INV') and (tst<>'.SCR') and (tst<>'.COL') then begin
  LoadOK;
  UstawMode;
 end else
  Blokada:=false;

end;

current_filename:=tmpString;
end;


procedure ClearScreen;
begin
 if Application.MessageBox('Are you sure ?','Close',mb_YESNO+MB_ICONQUESTION)=6 then if gate>0 then
  begin
   form1.ClearALL;

   form1.zamknij(f_Move);
   form1.zamknij(f_EditCharset);
   form1.zamknij(f_Zoom);
   form1.zamknij(f_EditPMG);
   form1.zamknij(f_EditColors);
   form1.zamknij(f_CharsFill);
   form1.zamknij(f_Check);
   form1.zamknij(f_EditPalette);
   form1.zamknij(f_EditColorsMap);
   form1.zamknij(f_Bmp2Pmg);
   form1.zamknij(f_PaletteOptions);

   form1.Image2.Enabled:=false;
   form1.image3.Enabled:=false;
   form1.image7.Enabled:=false;
  end;
end;


procedure TForm1.czytaj_vsc;
var mul, x, tb, pm, rs, i: integer;
begin

 tb:=48*8;
 pm:=sizeof(tablica_sprite)*8;
 rs:=24*8;

 mul:= 48 + 48 + 48*8 + sizeof(tablica_sprite)*8 + sizeof(tablica_sprite)*8 + 16*8 + 8*8 + 24*8 + 1 + 9*8;

for i:=0 to 29 do begin

 x:=vscrol.pos + i;

 FileSeek(fvsc, x*mul, 0);

 FileRead(fvsc,scren[tmul48[i]],48);
 FileRead(fvsc,invers[tmul48[i]],48);

 FileRead(fvsc,tab[i*tb],tb);

 FileRead(fvsc,Sprajt  [i*8] , pm);
 FileRead(fvsc,SprajtX [i*8] , pm);

 FileRead(fvsc , Spr0 [i shl 3] , 16);
 FileRead(fvsc , Spr1 [i shl 3] , 16);
 FileRead(fvsc , Spr2 [i shl 3] , 16);
 FileRead(fvsc , Spr3 [i shl 3] , 16);
 FileRead(fvsc , Mis0 [i shl 3] , 16);
 FileRead(fvsc , Mis1 [i shl 3] , 16);
 FileRead(fvsc , Mis2 [i shl 3] , 16);
 FileRead(fvsc , Mis3 [i shl 3] , 16);

 FileRead(fvsc , Smask [$000 + i shl 3] , 8);
 FileRead(fvsc , Smask [$100 + i shl 3] , 8);
 FileRead(fvsc , Smask [$200 + i shl 3] , 8);
 FileRead(fvsc , Smask [$300 + i shl 3] , 8);
 FileRead(fvsc , Smask [$400 + i shl 3] , 8);
 FileRead(fvsc , Smask [$500 + i shl 3] , 8);
 FileRead(fvsc , Smask [$600 + i shl 3] , 8);
 FileRead(fvsc , Smask [$700 + i shl 3] , 8);

// FileRead(fvsc,raster[i*rs],rs);
 FileRead(fvsc,gfxMode[i],1);

 FileRead(fvsc , TabKolor [$000 + i shl 3] , 8);
 FileRead(fvsc , TabKolor [$100 + i shl 3] , 8);
 FileRead(fvsc , TabKolor [$200 + i shl 3] , 8);
 FileRead(fvsc , TabKolor [$300 + i shl 3] , 8);
 FileRead(fvsc , TabKolor [$400 + i shl 3] , 8);
 FileRead(fvsc , TabKolor [$500 + i shl 3] , 8);
 FileRead(fvsc , TabKolor [$600 + i shl 3] , 8);
 FileRead(fvsc , TabKolor [$700 + i shl 3] , 8);
 FileRead(fvsc , TabKolor [$800 + i shl 3] , 8);

end;

end;


procedure apend(var src,dst: integer; const len: integer);
var i, j: integer;
begin

 j:=0;

 while j<len do begin
  i:=FileRead(src,bufor,sizeof(bufor));
  FileWrite(dst,bufor,i);
  inc(j, i);
 end;

 FileClose(src);
end;


procedure SaveHSC;
(*----------------------------------------------------------------------------*)
(* zapis Horizontal Scroll  - aktualnie nie dziala                            *)
(*----------------------------------------------------------------------------*)
var f, g, len: integer;
    x: byte;
    zm: string;
begin

 zm:=form1.Savedialog1.FileName;
 zm:=ChangeFileExt(zm,'.hsc');

 SaveAfterExit:=false;

// scalenie plikow TAB, SCR, INV w plik HSC
 g:=FileCreate(zm);

 f:= FileOpen(form1.GetUndoName('$$$hscrol_tab.$$$'), fmOpenRead);
 len:=FileSeek(f, 0, 2);
 FileSeek(f, 0, 0);
 apend(f,g, len);

 f:= FileOpen(form1.GetUndoName('$$$hscrol_scr.$$$'), fmOpenRead);
 len:=FileSeek(f, 0, 2);
 FileSeek(f, 0, 0);
 apend(f,g, len);

 f:= FileOpen(form1.GetUndoName('$$$hscrol_inv.$$$'), fmOpenRead);
 len:=FileSeek(f, 0, 2);
 FileSeek(f, 0, 0);
 apend(f,g, len);

 FileWrite(g,TabKolor,5*$100);

// dorzuc do 'table' informacje o wymuszaniu zmiany zestawu
 move(table,bufor,sizeof(table));
 for x:=0 to 29 do
  if newFnt[x]>0 then bufor[x]:=bufor[x] or $80;
 FileWrite(g,bufor,30);

// zastap 0 w 'gfxMode' wartoscia $FF
 move(gfxMode,bufor,sizeof(gfxMode));
 for x:=0 to 29 do
  if bufor[x]=0 then bufor[x]:=$FF;
 FileWrite(g,bufor,30);

 FileWrite(g,fonty,sizeof(fonty));

 FileWrite(g,zestaw,1);

 bufor[0]:=ord(form1.Normal1.checked);
 bufor[1]:=ord(form1.Optymizing1.checked);
// bufor[2]:=ord(form1.Original1.checked);
 bufor[3]:=ord(form1.JGP1.checked);

 FileWrite(g,bufor,4);

 FileClose(g);
end;


procedure SaveVSC;
(*----------------------------------------------------------------------------*)
(* zapis Vertical Scroll                                                      *)
(*----------------------------------------------------------------------------*)
var i, j: smallint;
    t: textfile;
    a, txt: string;
begin
 if vscrol.use then begin

  j:=vscrol.pos;

  zapisz_vsc(vscrol.pos);

  vscrol.pos:=0;

  assignfile(t,vscrol.nam); FileMode:=0; reset(t);

  for i:=0 to (vscrol.max div 30)-1 do begin

   vscrol.pos:=i*30;  form1.czytaj_vsc;

   form1.OdswiezObraz;
   form1.Refresh;

   readln(t,a);

 // zapis pliku G2F pod nowa nazwa
   txt:=form1.Savedialog1.FileName;
   form1.Savedialog1.FileName:=a;

   form1.SaveG2F1Click(form1);
   form1.Savedialog1.FileName:=txt;

   form1.Refresh;

  end;

  closefile(t);

  vscrol.pos:=j;  form1.czytaj_vsc;

  form1.OdswiezObraz;
  form1.UstawKolory;
 end;
end;


procedure TForm1.pliki_danych(nam: string);
begin

 nam:=ChangeFileExt(nam, '');

 with form1 do begin
  Edit2Text:=nam+'.fnt'; Edit3Text:=nam+'.scr';
  Edit4Text:=nam+'.tab'; Edit8Text:=nam+'.all';
 end;
 
end;


procedure TForm1.PreviewButton;
begin
 if current_filename='' then exit;
                          
 if BMP_used>0 then begin ZwiekszHig(BMP_used); BMP_used:=0 end;

 SaveChanges;
 Preview;

 pliki_danych(current_filename);

 SaveAfterExit:=not(FImportBMP.Visible);

end;


procedure UstawPGR;
begin

 if t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo] then begin
  RLimitInst:=28;
  AddCycle:=0;

  form1.Zamknij(f_EditColors);
  form1.Zamknij(f_EditPMG);

  form1.EditCharset.Enabled:=false;
  form1.Check1.Enabled:=false;
  form1.EditColors.Enabled:=false;
  form1.EditPMG.Enabled:=false;

  form1.ChangePMG.Enabled:=false;
  form1.ChangeColors.Enabled:=false;

 end else begin
  RLimitInst:=12;

  form1.EditCharset.Enabled:=true;
  form1.Check1.Enabled:=true;
  form1.EditColors.Enabled:=true;
  form1.EditPMG.Enabled:=true;

  form1.ChangePMG.Enabled:=true;
  form1.ChangeColors.Enabled:=true;

 end;

end;


procedure TForm1.SelectScreenClick(Sender: TObject);
begin
 zamknij(f_Check);
 zamknij(f_EditRasters);

 if SelectScreen.Enabled then SelectScreen.SetFocus;

 SzerokoscObrazu;

 case SelectScreen.ItemIndex of
  0: begin Szerokosc:=256; CzarnyPas:=64 end;
  1: begin Szerokosc:=320; CzarnyPas:=32 end;
  2: begin Szerokosc:=384; CzarnyPas:=0 end;
 end;

 Cur:=Point(CzarnyPas shr 3,0);
 CurShp:=Cur;

// Image1.Width:=384*2; Image1.Left:=pozX;//+CzarnyPas*2;
// image4.Width:=384*2; image4.Left:=pozX;//+CzarnyPas*2;

 cnv; resolution_info; ustawMemo; showchars1.Checked:=false;


 if not(Blokada) then begin OdswiezObraz; Refresh end;

// GED--
// screen 32: 67 cykli co linie, 65 cykli co 8-a linie
// screen 40: 65 cykli co linie, 63 cykle co 8-a linie

// GED+
// screen 32: 68 cykli co linie, 42 cykle co 8-a linie
// scrren 40: 60 cykli co linie, 27 cykle co 8-a linie

 case Bajt of
  32: begin LimitCycle:=68; AddCycle:=32 end;

  40: if UseChar then begin
       LimitCycle:=60; AddCycle:=24
      end else begin
       LimitCycle:=54; AddCycle:=18
      end;
 end;

 if not(FSpecial.chk_players.Checked) then inc(LimitCycle, 4);

 if not(FSpecial.chk_players.Checked) and not(FSpecial.chk_missiles.Checked) then inc(LimitCycle, 1);

 UstawPGR;

 if t_mode(SelectMode.ItemIndex)=m_dli then zamknij(f_EditRasters);

 if FBmp2Pmg.Visible then begin
//  FBmp2Pmg.current_filename:=0;
  FBmp2Pmg.Edit1Change;
  FBmp2Pmg.PokazOrder;
 end;

// tylko 42 kolumny sa widziane na TV
{ if not(message_48bytes) and (Szerokosc=384) then begin
  Application.MessageBox('There are only 42 visible columns on a TV screen.'#13#10#13#10'Both the first and last three columns will be invisible.','Screen 48 byte',MB_ICONEXCLAMATION);
  message_48bytes:=true;
 end;
}
 if FImportBMP.Visible then ClickPreviewBMP;

end;


procedure TForm1.SelectPixelClick(Sender: TObject);
var cApp: tCloseApp;
begin

 if SelectPixel.Enabled then SelectPixel.SetFocus;

 CloseRestoreApp(true, cApp);

 UstawPixel;

 resolution_info;

 UstawGfxMode(Pixel);

// New1Click(Sender);

 SelectModeClick(nil);

 CloseRestoreApp(false, cApp);

// SelectGTIA.Enabled:=SelectPixel.ItemIndex=2;

end;


procedure TForm1.SelectGTIAClick(Sender: TObject);
begin

{ if SelectPixel.ItemIndex=2 then        // !!! bez tego inaczej nie bedzie mozna ustawic SelectPixel !!!
  SelectPixelClick(self)
 else
  SelectPixel.ItemIndex:=2;}

 OdswiezObraz;
 UstawKolory;

 if SelectGTIA.Enabled then SelectGTIA.SetFocus;
 
end;


procedure TForm1.Normal1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* OPTIONS -> STANDARD                                                        *)
(*----------------------------------------------------------------------------*)
begin
 if gate>0 then begin
  ClrJGPplusCharsetCheck;
  ClearNewFnt;
  ZnakCheck(ccStandard);

  form1.zamknij(f_EditCharset);
  tryb:=0; cnv;
  ShowChars(0,29,false);
 end;
end;


procedure TForm1.JGP1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* OPTIONS -> JGP                                                             *)
(*----------------------------------------------------------------------------*)
begin
 if gate>0 then begin
  ClrJGPplusCharsetCheck;
  ZnakCheck(ccJgp1);
  form1.zamknij(f_EditCharset);

  tryb:=1; cnv;
  ShowChars(0,29,false);
 end;
end;


procedure TForm1.Charsetx2Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* OPTIONS -> JGP+                                                            *)
(*----------------------------------------------------------------------------*)
begin

 JGP1.Checked := false;
 JGP2.Checked := true;

 JGPplusCharset:=TMenuItem(Sender).Tag;

 if gate>0 then begin
  form1.ZnakCheck(ccJgp2);
  form1.zamknij(f_EditCharset);

  tryb:=1; form1.cnv;
  form1.ShowChars(0,29,false);
 end;
 
end;


procedure TForm1.MenuAboutClick(Sender: TObject);
var t,l: integer;
begin

 SetFormPos('FAbout', t, l);
 FAbout.Top:=t;
 FAbout.Left:=l;

 if FAbout.ShowModal=mrOK then begin end;
end;


procedure AtariSave(var f:integer; dst,hex:string; stan:boolean);
(*----------------------------------------------------------------------------*)
(* zapis plikow FNT, SCR, ALL                                                 *)
(*----------------------------------------------------------------------------*)
var a, dlug, plik, dest, i, len: integer;
begin
 hex:='$'+hex;

 plik:=FileOpen(form1.GetUndoName('temp.$$$'), fmOpenRead);
 len:=FileSeek(plik, 0, 2);
 FileSeek(plik, 0, 0);

 a:=StrToInt(hex);

 temp[0]:=$ff;   temp[1]:=$ff;                     //naglowek ffff
 temp[2]:=byte(a and $ff); temp[3]:=byte(a shr 8); //start adres
 a:=a+len-1;                                       //start+lenght-1
 temp[4]:=byte(a and $ff); temp[5]:=byte(a shr 8);

 dest:=FileCreate(dst);

 if (stan) and (eol_=false) then begin
  FileWrite(dest,temp,6);
  if eol_=false then FileWrite(f,temp,6);
 end;

 i:=0;
 while i<len do begin
  dlug:=FileRead(plik,bufor,sizeof(bufor));
  FileWrite(dest,bufor,dlug);
  if eol_=false then FileWrite(f,bufor,dlug);

  inc(i, dlug);
 end;

FileClose(plik);
FileClose(dest);
end;


procedure save_pm(var t: textfile; var pmg: tab_word256; var siz: byte);
var i: integer;
    a,b: byte;
    pm: word;
begin

 for i := 0 to 239 do begin

  pm:=pmg[i];

  if i mod 16=0 then write(t, #13#10#9'.he');

  a:=pm shr 8;
  b:=pm and $ff;

  if a>127 then
   write(t, ' 00')
  else begin
   a:=a and $f;

   write(t, ' ',inttohex(b+32,2));

   if (a=2) and (b and 1<>0) then write(t, '&$fe');
   if (a=4) and (b and 3<>0) then write(t, '&$fc');
  end;

 end;

end;


procedure save_pm_siz (var pm: word; var siz: byte);
var a: byte;
begin

  a:=pm shr 8;

  if a<128 then begin
   a:=a and $f;

   if a=2 then a:=1;
   if a=4 then a:=3;
 
   siz:=siz or a;
  end;

end;


procedure SaveAll;
var x, i, j, v, plik, fatari: integer;
    a: string;
    mapa: tablica_row;
    puste, nobad: trow;
    test: array [0..3] of Boolean;
    lastrow: array [0..48*8] of byte;
begin
// wyczysc koncowke zestawu, znaki nieuzywane

form1.SaveDialog1.FileName:=current_filename;

if (t_mode(form1.SelectMode.ItemIndex) in [m_gedp, m_dli, m_piccolo]) and (gfxMode[29] in [1,4]) then begin
 move(tab[232*48], lastrow, 48*8);
// move(lastrow, tab[233*48], 48*7);

 if SpecialStr[___doublescan].val then begin
{
   case gfxMode[29] of
    2: move(lastrow, tab[(232+2)*48], 48*7);
    4: move(lastrow, tab[(232+4)*48], 48*7);
   end;
}
 end else
   move(lastrow, tab[233*48], 48*7);

 form1.cnv;

 move(lastrow, tab[232*48], 48*8);
end;

form1.charsfill;

fillchar(test,sizeof(test),true);

fillchar(mapa, sizeof(mapa), 0);


if test[0] then begin
// nagraj tylko uzywane zestawy fontow
 if eol_=false then begin
  fatari:=FileCreate(edit8text);  //fonts
 end;

 fillchar(temp,sizeof(temp),$ff);
 for x:=0 to 29 do temp[table[x]]:=0;

 plik:=FileCreate(form1.GetUndoName('temp.$$$'));
 for x:=0 to 29 do begin

  fillchar(bufor, 1024, 0);            // czyscimy nieuzywane znaki
  i:=ileFnt(x); 
  move(fonty[x shl 10], bufor, i*8);

  if temp[x]=0 then
   if Fox1 or NoBadLines then begin

    for i:=0 to 127 do begin
     FileWrite(plik, bufor[i shl 3+4], 4);
     FileWrite(plik, bufor[i shl 3], 4);
    end;

   end else
    FileWrite(plik,bufor,1024);

 end;

 FileClose(plik);

 atarisave(fatari, edit2Text, edit5text, false);
end;


// SCR

if test[1] then begin

 for x:=0 to 29 do if gfxMode[x]=0 then mapa[x]:=$ff;

 plik:=FileCreate(form1.GetUndoName('temp.$$$'));


// w pierwszym wierszu bedzie inwers znakow na podstawie pozosta³ych wierszy

 if NoBadLines then begin

  fillchar(nobad, sizeof(nobad), 0);

  for j := 0 to 29 do
   for x := 0 to Bajt-1 do
    if scren[CzarnyPas shr 3+x+tmul48[j]]>127 then nobad[x]:=$80;

  move(scren[form1.Sofs(0,tmul48[0])], puste, bajt);
  for i := 0 to Bajt-1 do puste[i]:=puste[i] or nobad[i];

  FileWrite(plik, puste, bajt);

 end else

 for x:=0 to 29 do
  if mapa[x]=0 then begin

   FileWrite(plik,scren[form1.Sofs(0,tmul48[x])],bajt);

   if Fox1 then begin

    move(scren[form1.Sofs(0,tmul48[x])], puste, bajt);
    for i:=0 to Bajt-1 do puste[i]:=(puste[i] and $7f) or (invers2[form1.Sofs(0,tmul48[x])+i] and $80);

    FileWrite(plik, puste, bajt);

   end;

  end else begin

   for i := 0 to 127 do begin
    v:=0;

    if table[x] in [0..127] then for j:=0 to 7 do v:=v or fonty[table[x] shl 10+i shl 3+j];

    if v=0 then Break;
   end;

   fillchar(puste,sizeof(puste), byte(i));    // pusty znak

   if t_mode(form1.SelectMode.ItemIndex) in [m_gedp, m_piccolo] then FileWrite(plik,puste,bajt);

  end;

 FileClose(plik);

 atarisave(fatari, edit3Text, edit6text, false);
end;


if test[2] then begin
if (zestaw>0) and (eol_=false) then begin

 plik:=FileCreate(form1.GetUndoName('temp.$$$'));
 for x:=0 to 29 do begin
  if mapa[x]=0 then FileWrite(plik,table[x],1);
 end;
 FileClose(plik);
 atarisave(fatari, edit4Text, edit7text, false);
end;

end;

if eol_=false then FileClose(fatari);

if not(test[3]) then DeleteFile(edit8text);


// mapa kolorow VBXE

if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin

 case Bajt of
  32: begin v:=8; x:=32 end;
  40: begin v:=4; x:=40 end;
 else
  begin v:=3; x:=42 end;
 end;

 a:=ChangeFileExt(edit4Text, '.cmp');

 plik:=FileCreate(a);

 for j:=0 to (Wysokosc div cmap_cellH)-1 do
  for i := 0 to x-1 do begin
   bufor[0]:=byte(cmap[v+i, j].c[0]);
   bufor[1]:=byte(cmap[v+i, j].c[1]);
   bufor[2]:=byte(cmap[v+i, j].c[2]);
   bufor[3]:=cmap[v+i, j].status;

   FileWrite(plik, bufor, 4);
  end;

 FileClose(plik);

end;

form1.Cnv;
end;


procedure copy_tmp(var f: integer; y2: integer; const ln: integer);
var i, j: integer;
begin
 FileWrite(f,tab[tmul48[y2]],tmul48[ln]);                        // grafika
 FileWrite(f,invers[tmul48[y2 shr 3]],tmul48[ln shr 3]);         // invers znakow
 FileWrite(f,Sprajt[y2], sizeof(tablica_sprite)*ln);
 FileWrite(f,SprajtX[y2], sizeof(tablica_sprite)*ln);
 FileWrite(f,Spr0[y2],ln shl 1); FileWrite(f,Spr1[y2],ln shl 1); // gracze
 FileWrite(f,Spr2[y2],ln shl 1); FileWrite(f,Spr3[y2],ln shl 1);
 FileWrite(f,Mis0[y2],ln shl 1); FileWrite(f,Mis1[y2],ln shl 1); // pociski
 FileWrite(f,Mis2[y2],ln shl 1); FileWrite(f,Mis3[y2],ln shl 1);
 FileWrite(f,Raster[y2],sizeof(tARaster)*ln);                    // raster
 FileWrite(f,raster_line_ofset[y2], ln shl 1);

 for j:=0 to 8 do FileWrite(f,TabKolor[j shl 8+y2],ln);
 for j:=0 to 7 do FileWrite(f,Smask[j shl 8+y2],ln);

 y2:=y2 div cmap_cellH;

 for j := 0 to (ln div cmap_cellH)-1 do
  for i := 0 to 47 do begin
   bufor[0]:=byte(cmap[i,y2+j].c[0]);
   bufor[1]:=byte(cmap[i,y2+j].c[1]);
   bufor[2]:=byte(cmap[i,y2+j].c[2]);
   bufor[3]:=cmap[i,y2+j].status;

   FileWrite(f, bufor, 4);
  end;

end;


procedure SavePASMini;
var t: textfile;
    fn, rc: string;
    FntSiz, cnt, i, k, ffnt: integer;
    f: file;
    yes, com: Boolean;
    v: byte;

 procedure writeTemp;
 var i: byte;
 begin

 com:=false;
 for i := 0 to 29 do begin

  if (i>0) and (i mod 8=0) then begin

   if com then
     writeln(t, ',')
   else
     writeln(t);

   com:=false;
  end;


  if com then
   write(t, ',')
  else
   write(t, #9#9);

  write(t, '$',IntToHex(temp[i], 2));
  com:=true;

 end;

 writeln(t);
 writeln(t, #9');');
 writeln(t);

 end;


begin

 eol_:=false; SaveAll;


 assign(f, edit2text); reset(f,1);
 FntSiz := FileSize(f);

 cnt:=FntSiz div 1024;

 fn:=ChangeFileExt(Form1.SaveDialog1.FileName, '.pas');
 rc:=ChangeFileExt(ExtractFileName(fn),'.rc');


 for i := 0 to cnt - 1 do begin

  blockread(f, bufor, 1024);

  ffnt:=FileCreate(ChangeFileExt(fn, format('.f%.2d', [i])), fmOpenWrite);
  FileWrite(ffnt, bufor, 1024);
  FileClose(ffnt);
 end;

 closefile(f);


 assign(t, ChangeFileExt(fn, '.rc')); rewrite(t);
 for i := 0 to cnt - 1 do writeln(t, 'fnt',i,#9'rcdata ',ChangeFileExt(rc, format('.f%.2d', [i])) );
 writeln(t, 'scr'#9'rcdata ',ChangeFileExt(rc, '.scr') );

 flush(t);
 closefile(t);


 assign(t, fn); rewrite(t);

 Writeln(t, '// Simplified PASCAL file writing for G2F:DLI mode');
 Writeln(t, '// -----------------------------------------------');
 Writeln(t, '// * GTIA register changes only every 8 lines');
 Writeln(t, '// * no information about PMG graphics');
 writeln(t);
 

 writeln(t, 'uses crt,atari;');
 writeln(t);
 writeln(t, '{$r ',rc,'}');
 writeln(t);
 writeln(t, 'const');

 k:=$bc00-FntSiz;
 i:=k-$600;

 if (i and $f000) <> (k and $f000) then i:=k and $f000 - $600;

 writeln(t, #9'scr = $',IntToHex(i, 4),';');
 writeln(t);

 for i := 0 to cnt - 1 do
  writeln(t, #9'fnt',i,' = $',IntToHex($bc00-FntSiz+i*$400, 4),';');

 writeln(t);


 k:=0;
 yes:=false;
 for i := 0 to 29 do
  case gfxMode[i] of
   0: inc(k);

   1,2,4: if yes=false then begin
            inc(k, 3);
            yes:=true;
          end else
            inc(k);
  end;

 inc(k, 3);

 writeln(t, #9'dlist: array [0..',k-1,'] of byte = (');

 yes:=false;
 com:=false;

 for i := 0 to 29 do begin

  case gfxMode[i] of
   0: begin

       if com then
         write(t, ',')
       else
         write(t, #9#9);

       write(t, '$00');
       com:=true;

      end;

   1,2,4: begin

           case gfxMode[i] of
            1,4: v:=2;
            2: v:=4;
           end;

           if i<>29 then v:=v or $80;

          if yes=false then begin

            if com then writeln(t, ',');

            writeln(t, #9#9'$',IntToHex(v or $40,2),',lo(scr),hi(scr),');
            yes:=true;
            com:=false;
          end else begin

            if com then
             write(t, ',')
            else
             write(t, #9#9);

            write(t, '$',IntToHex(v, 2) );
            com:=true;
          end;


         end;


  end;

  if (i>0) and (i mod 8=0) then begin

   if com then
     writeln(t, ',')
   else
     writeln(t);

   com:=false;
  end;

 end;


 if com then
   writeln(t, ',')
 else
   writeln(t);

 writeln(t, #9#9'$41,lo(word(@dlist)),hi(word(@dlist))' );
 writeln(t, #9');');

 writeln(t);

// -----------------------------------------------------------------------------

 assign(f, edit4text); reset(f,1);
 blockread(f, temp, 30);
 closefile(f);

 writeln(t, #9'fntTable: array [0..29] of byte = (');

 com:=false;
 for i := 0 to 29 do begin

  if (i>0) and (i mod 8=0) then begin

   if com then
     writeln(t, ',')
   else
     writeln(t);

   com:=false;
  end;


  if com then
   write(t, ',')
  else
   write(t, #9#9);

  if temp[i] > 127 then
   write(t, 'hi(fnt0)')
  else
   write(t, 'hi(fnt',temp[i],')');

  com:=true;

 end;

 writeln(t);
 writeln(t, #9');');
 writeln(t);

// -----------------------------------------------------------------------------

 writeln(t, #9'c0Table: array [0..29] of byte = (');
 for i := 0 to 29 do temp[i] := tabKolor[$100+i shl 3];
 writeTemp;

// -----------------------------------------------------------------------------

 writeln(t, #9'c1Table: array [0..29] of byte = (');
 for i := 0 to 29 do temp[i] := tabKolor[$200+i shl 3];
 writeTemp;

// -----------------------------------------------------------------------------

 writeln(t, #9'c2Table: array [0..29] of byte = (');
 for i := 0 to 29 do temp[i] := tabKolor[$300+i shl 3];
 writeTemp;

// -----------------------------------------------------------------------------

 writeln(t, #9'c3Table: array [0..29] of byte = (');
 for i := 0 to 29 do temp[i] := tabKolor[$400+i shl 3];
 writeTemp;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

 writeln(t,'var');
 writeln(t, #9'old_dli, old_vbl: pointer;');
 writeln(t);

// -----------------------------------------------------------------------------

 writeln(t);
 writeln(t, 'procedure vbl; assembler; interrupt;');
 writeln(t, 'asm');
 writeln(t, '{');
 writeln(t, #9'mva #1 dli.cnt');
 writeln(t);

 writeln(t, #9'mva adr.fntTable chbase');
 writeln(t, #9'mva adr.fntTable+1 dli.chbs');
 writeln(t);

 writeln(t, #9'mva adr.c0Table color0');
 writeln(t, #9'mva adr.c0Table+1 dli.col0');
 writeln(t, #9'mva adr.c1Table color1');
 writeln(t, #9'mva adr.c1Table+1 dli.col1');
 writeln(t, #9'mva adr.c2Table color2');
 writeln(t, #9'mva adr.c2Table+1 dli.col2');
 writeln(t, #9'mva adr.c3Table color3');
 writeln(t, #9'mva adr.c3Table+1 dli.col3');
 writeln(t);

 writeln(t, #9'mva #$',IntToHex(TabKolor[0], 2),' colbak');
 writeln(t);

 writeln(t, #9'jmp xitvbv');
 writeln(t, '};');
 writeln(t, 'end;');
 writeln(t);

// -----------------------------------------------------------------------------

 writeln(t);
 writeln(t, 'procedure dli; assembler; interrupt;');
 writeln(t, 'asm');
 writeln(t, '{');
 writeln(t, #9'sta rA');
 writeln(t, #9'stx rX');
 writeln(t, #9'sty rY');
 writeln(t);

 writeln(t, #9'lda #0');
 writeln(t, 'chbs'#9'equ *-1');
 writeln(t);

 writeln(t, #9'ldx #0');
 writeln(t, 'col0'#9'equ *-1');
 writeln(t);

 writeln(t, #9'ldy #0');
 writeln(t, 'col1'#9'equ *-1');
 writeln(t);

 writeln(t, #9';sta wsync');
 writeln(t);

 writeln(t, #9'sta chbase');
 writeln(t, #9'lda #0');
 writeln(t, 'col2'#9'equ *-1');
 writeln(t, #9'stx color0');
 writeln(t, #9'ldx #0');
 writeln(t, 'col3'#9'equ *-1');
 writeln(t, #9'sty color1');
 writeln(t, #9'sta color2');
 writeln(t, #9'stx color3');
 writeln(t);

 writeln(t, #9'inc cnt');
 writeln(t);

 writeln(t, #9'ldx #0');
 writeln(t, 'cnt'#9'equ *-1');
 writeln(t);

 writeln(t, #9'lda adr.fntTable,x');
 writeln(t, #9'sta chbs');
 writeln(t);

 writeln(t, #9'lda adr.c0Table,x');
 writeln(t, #9'sta col0');
 writeln(t);

 writeln(t, #9'lda adr.c1Table,x');
 writeln(t, #9'sta col1');
 writeln(t);

 writeln(t, #9'lda adr.c2Table,x');
 writeln(t, #9'sta col2');
 writeln(t);

 writeln(t, #9'lda adr.c3Table,x');
 writeln(t, #9'sta col3');
 writeln(t);

 writeln(t, #9'lda #0');
 writeln(t, 'rA'#9'equ *-1');
 writeln(t, #9'ldx #0');
 writeln(t, 'rX'#9'equ *-1');
 writeln(t, #9'ldy #0');
 writeln(t, 'rY'#9'equ *-1');
 writeln(t, '};');
 writeln(t, #9'end;');
 writeln(t);
 writeln(t);

// -----------------------------------------------------------------------------

 writeln(t, 'begin');
 writeln(t);

 writeln(t, ' GetIntVec(iVBL, old_vbl);');
 writeln(t, ' GetIntVec(iDLI, old_dli);');
 writeln(t);

 case Bajt of
  32: writeln(t, ' sdmctl := byte(narrow or enable or missiles or players or oneline);');
  40: writeln(t, ' sdmctl := byte(normal or enable or missiles or players or oneline);');
  48: writeln(t, ' sdmctl := byte(wide or enable or missiles or players or oneline);');
 end;

 writeln(t, ' sdlstl := word(@dlist);',#9'// ($230) = @dlist, New DLIST Program');
 
 writeln(t);

 writeln(t, ' SetIntVec(iVBL, @vbl);');
 writeln(t, ' SetIntVec(iDLI, @dli);');
 writeln(t);

 writeln(t, ' nmien := $c0;',#9#9#9'// $D40E = $C0, Enable DLI');
 writeln(t);

 writeln(t, ' repeat');
 writeln(t, ' until keypressed;');
 writeln(t);

 writeln(t, ' SetIntVec(iVBL, old_vbl);');
 writeln(t, ' SetIntVec(iDLI, old_dli);');
 writeln(t);

 writeln(t, 'end.');

 flush(t);
 closefile(t);

end;



procedure paste_tmp(var f: integer; y2: integer; const ln: integer);
var i,j: integer;
begin
 FileRead(f,tab[tmul48[y2]],tmul48[ln]);                       // grafika
 FileRead(f,invers[tmul48[y2 shr 3]],tmul48[ln shr 3]);        // invers znakow
 FileRead(f,Sprajt[y2], sizeof(tablica_sprite)*ln);
 FileRead(f,SprajtX[y2], sizeof(tablica_sprite)*ln);
 FileRead(f,Spr0[y2],ln shl 1); FileRead(f,Spr1[y2],ln shl 1); // gracze
 FileRead(f,Spr2[y2],ln shl 1); FileRead(f,Spr3[y2],ln shl 1);
 FileRead(f,Mis0[y2],ln shl 1); FileRead(f,Mis1[y2],ln shl 1); // pociski
 FileRead(f,Mis2[y2],ln shl 1); FileRead(f,Mis3[y2],ln shl 1);
 FileRead(f,Raster[y2],sizeof(tARaster)*ln);                   // raster
 FileRead(f,raster_line_ofset[y2], ln shl 1);

 for j:=0 to 8 do FileRead(f,TabKolor[j shl 8+y2],ln);
 for j:=0 to 7 do FileRead(f,Smask[j shl 8+y2],ln);

 y2:=y2 div cmap_cellH;

 for j := 0 to (ln div cmap_cellH)-1 do
  for i := 0 to 47 do begin
   FileRead(f, bufor, 4);

   cmap[i,y2+j].c[0]:=bufor[0];
   cmap[i,y2+j].c[1]:=bufor[1];
   cmap[i,y2+j].c[2]:=bufor[2];
   cmap[i,y2+j].status:=bufor[3];
  end;

end;


procedure SprMovX(const a:byte; s: integer; const min,max:integer);
var v: word;
    x, y, i: integer;
begin

 s:=s div 2;               // !!! dla wartosci ze znakiem SHR nie przejdzie

 for i:=min to min+max do begin

  case a of
   0: v:=Spr0[i];
   1: v:=Mis0[i];
   2: v:=Spr1[i];
   3: v:=Mis1[i];
   4: v:=Spr2[i];
   5: v:=Mis2[i];
   6: v:=Spr3[i];
   7: v:=Mis3[i];
  end;

  x:=v shr 8;

  if x<128 then begin
   y:=(v and $00ff)+s; if (y<0) or (y>220) then y:=0;
   v:=(x shl 8) or y;
  end;

  case a of
   0: Spr0[i]:=v;
   1: Mis0[i]:=v;
   2: Spr1[i]:=v;
   3: Mis1[i]:=v;
   4: Spr2[i]:=v;
   5: Mis2[i]:=v;
   6: Spr3[i]:=v;
   7: Mis3[i]:=v;
  end;

end;

end;


procedure SaveMove;
// zapisujemy grafike
var f: integer;
begin

 f:=FileCreate(form1.GetUndoName('move_bmp.$$$'));
 FileWrite(f, tab, tmul48[Wysokosc]);
 FileWrite(f, scren, sizeof(scren));
 FileClose(f);

end;


procedure RestoreMove;
// przywracamy grafike z lewej/prawej
var f, i, j: integer;
begin

 f:= FileOpen(form1.GetUndoName('move_bmp.$$$'), fmOpenRead);
 FileSeek(f, 0, 0);

 for i := 0 to Wysokosc-1 do begin
  FileRead(f, bufor, 48);
  move(bufor, tab[tmul48[i]], FMove.udLeft.Position);
  move(bufor[FMove.udRight.Position], tab[tmul48[i]+FMove.udRight.Position], 48-FMove.udRight.Position);
 end;

 for i := 0 to 29 do begin
  FileRead(f, bufor, 48);
//  move(bufor, invers[i*48], FMove.udLeft.Position);
//  move(bufor[FMove.udRight.Position], invers[i*48+FMove.udRight.Position], 48-FMove.udRight.Position);

  for j := 0 to 47 do
   if (j<FMove.udLeft.Position) or (j>=FMove.udRight.Position) then begin
    scren[tmul48[i]+j]:=(scren[tmul48[i]+j] and $7f) or (bufor[j] and $80);
    invers[tmul48[i]+j]:=scren[tmul48[i]+j] and $80;
   end;

 end;

 FileClose(f);
end;


procedure TForm1.MoveX;
(*----------------------------------------------------------------------------*)
(* MOVE X - przesuniecie danych w poziomie                                    *)
(*----------------------------------------------------------------------------*)
var x, y, i, j, w, p, t, min, max: integer;
    v, r: byte;

    lcm: array [0..255] of color_map;
begin
x:=FMove.seMoveX.Position;

SaveMove;

if x>Bajt*Pixel then x:=Bajt*Pixel else
 if x<-(Bajt*Pixel) then x:=-(Bajt*Pixel);

y:=abs(x);

FMove.seMoveX.SetFocus;

if y<>0 then begin
fillchar(fonty,sizeof(fonty),0);       //czysc fonty

FMove.GetLineRangeValue(min,max);

if FMove.MoveBitmap.Checked then begin
// przesuwamy invers w poziomie
 move(invers,bufor,sizeof(invers));
 for w:=min to min+max do
  if (w mod 8)=0 then begin
   i:=y shr 3; if x<0 then i:=-i;
   fillchar(bufor,sizeof(bufor),0);
   move(invers[tmul48[w shr 3]],bufor[$100],48);
   move(bufor[$100-i],invers[tmul48[w shr 3]],48);
  end;

 move(invers2,bufor,sizeof(invers2));
 for w:=min to min+max do
  if (w mod 8)=0 then begin
   i:=y shr 3; if x<0 then i:=-i;
   fillchar(bufor,sizeof(bufor),0);
   move(invers2[tmul48[w shr 3]],bufor[$100],48);
   move(bufor[$100-i],invers2[tmul48[w shr 3]],48);
  end;

end;


if FMove.MoveColors.Checked then begin
// przesuwamy mape kolorow
 for w:=min to min+max do
  if (w mod cmap_cellH)=0 then begin
   i:=y div cmap_cellW;

   if x<0 then i:=-i;

   for t := 0 to 47 do lcm[64+t]:=cmap[t,w div cmap_cellH];
   for t := 0 to 47 do cmap[t,w div cmap_cellH]:=lcm[64+t-i];

  end;
end;


if FMove.MovePMG.Checked then begin
// przesuwamy sprity w poziomie
 for w:=0 to 7 do SprMovX(w,x,min,max);


// przesun w poziomie tablice Sprajt i SprajtX
 p:= x div 2;

 for w:=min to min+max do begin
  fillchar(bufor,sizeof(bufor),0);
  move(Sprajt[w],bufor[$200],sizeof(tablica_sprite));
  move(bufor[$200-p],Sprajt[w],sizeof(tablica_sprite));
  fillchar(bufor,sizeof(bufor),0);
  move(SprajtX[w],bufor[$200],sizeof(tablica_sprite));
  move(bufor[$200-p],SprajtX[w],sizeof(tablica_sprite));
 end;
end;


if FMove.MoveBitmap.Checked then begin
// przesuwamy grafike w poziomie
for w:=min to min+max do begin
fillchar(bufor,sizeof(bufor),0); j:=x;
 for p:=0 to 47 do begin
  v:=tab[p+tmul48[w]];

  for r:=0 to 7 do bufor[p shl 3+r+j+64]:=v and twyt1[r];

 end;

 for p:=0 to 47 do begin
  v:=0;

  for r:=0 to 7 do if bufor[p shl 3+r+64]<>0 then v:=v or twyt1[r];

  tab[p+tmul48[w]]:=v;
 end;
end;
end;


RestoreMove;

form1.OdswiezObraz;
end;
end;


procedure TForm1.MoveY;
(*----------------------------------------------------------------------------*)
(* MOVE Y                                                                     *)
(* 1. zapamietujemy wszystkie dane obrazu                                     *)
(* 2. przesuwamy caly obraz w pionie                                          *)
(* 3. przywracamy poprzednia zawartosc ekranu nad gornym i dolnym zaznaczeniem*)
(* 4. przywracamy poprzednia zawartosc ekranu z lewej i prawej strony zazna...*)
(*----------------------------------------------------------------------------*)
var x, y, mul, y1, y2, ln, len, cnt: integer;
    f,g, i,j: integer;
    tmp: cardinal;
    bufm: array [0..$300] of word;
begin

 FMove.GetLineRangeValue(y1,y2);

//y1:=StrToInt(form7.edit24.Text);
//y2:=y1+StrToInt(form7.Edit2.Text);

 inc(y2,y1);
 ln:=239-y2;

// zaczynamy FMove w pionie
 x:=FMove.seMoveY.Position*-1;

 y:=abs(x);
 

// zapamietujemy gorny i dolny fragment obrazu
 SaveMove;

 f:=FileCreate(GetUndoName('movey_tmp.$$$'));

 if y1>0 then
  if x>0 then
   copy_tmp(f,0,y1+x)
  else
   copy_tmp(f,0,y1);

 if y2<239 then copy_tmp(f,y2,ln);

 FileClose(f);


 FMove.seMoveY.SetFocus;

 if y<>0 then begin
  fillchar(fonty,sizeof(fonty),0);        //czysc fonty
  fillchar(bufor,sizeof(bufor),0);

  mul:=240*48; i:=mul-tmul48[y]; done:=0;   if i<0 then i:=0;

  if x>0 then begin     // -DOWN-

   if FMove.MoveBitmap.Checked then begin
    move(tab,fonty,mul);              //przepisz do fonty
    fillchar(tab,sizeof(tab),0);      //czysc TAB
    move(fonty,tab[tmul48[y]],i);

    move(invers,bufor,sizeof(invers));
    fillchar(invers,sizeof(invers),0);
    move(bufor,invers[tmul48[y shr 3]],tmul48[30-(y shr 3)]);

    move(invers2,bufor,sizeof(invers2));
    fillchar(invers2,sizeof(invers2),0);
    move(bufor,invers2[tmul48[y shr 3]],tmul48[30-(y shr 3)]);
   end;

  end else begin        // -UP-

   if FMove.MoveBitmap.Checked then begin
    move(tab[tmul48[y]],fonty,i);     //przepisz do fonty
    fillchar(tab,sizeof(tab),0);      //czysc TAB
    move(fonty,tab,i);

    move(invers[tmul48[y shr 3]],bufor,tmul48[30-(y shr 3)]);
    fillchar(invers,sizeof(invers),0);
    move(bufor,invers,sizeof(invers));

    move(invers2[tmul48[y shr 3]],bufor,tmul48[30-(y shr 3)]);
    fillchar(invers2,sizeof(invers2),0);
    move(bufor,invers2,sizeof(invers2));
   end;

  end;


if FMove.MoveColors.Checked then begin
// przemiesc kolory grafiki i obiektow PMG (MOVE COLORS)
 for j:=0 to 8 do begin
  fillchar(bufor[$100-239],239,tabKolor[j shl 8]);              //czyscimy BUFOR
  fillchar(bufor[$100+239],239,tabKolor[j shl 8+239]);
  move(tabKolor[j shl 8],bufor[$100],239);     //kopiujemy do BUFOR+256 kolory
  move(bufor[$100-x],tabKolor[j shl 8],239);   //teraz przepisz z przeunieciem X
 end;

 f:=FileCreate(GetUndoName('dump$.$$$'));

   for j := 0 to 239 do
   for i := 0 to 47 do begin
    bufor[0]:=byte(cmap[i,j].c[0]);
    bufor[1]:=byte(cmap[i,j].c[1]);
    bufor[2]:=byte(cmap[i,j].c[2]);
    bufor[3]:=cmap[i,j].status;

    FileWrite(f, bufor, 4);
   end;
 FileClose(f);


 f:= FileOpen(GetUndoName('dump$.$$$'), fmOpenRead);
 len:=FileSeek(f, 0, 2);
 FileSeek(f, 0, 0);

 if x>0 then begin              // w dol
  mul:=y div cmap_cellH;
  tmp:=240-mul;

  for j := 0 to tmp-1 do
   for i := 0 to 47 do begin
    FileRead(f, bufor, 4);

    cmap[i,j+mul].c[0]:=bufor[0];
    cmap[i,j+mul].c[1]:=bufor[1];
    cmap[i,j+mul].c[2]:=bufor[2];
    cmap[i,j+mul].status:=bufor[3];
   end;
  FileClose(f);

 end else begin                 // w gore
  tmp:=y div cmap_cellH;

  FileSeek(f, tmp*4*48, 0);

  for j := 0 to 239 do
   for i := 0 to 47 do begin
    cmap[i,j].c[0]:=tabKolor[$100];
    cmap[i,j].c[1]:=tabKolor[$200];
    cmap[i,j].c[2]:=tabKolor[$300];
    cmap[i,j].status:=0;
   end;

  cnt:=tmp*4*48;

  j:=0;
  while cnt<len do begin

   for i := 0 to 47 do begin
    inc(cnt, FileRead(f, bufor, 4));

    cmap[i,j].c[0]:=bufor[0];
    cmap[i,j].c[1]:=bufor[1];
    cmap[i,j].c[2]:=bufor[2];
    cmap[i,j].status:=bufor[3];
   end;

   inc(j);
  end;
  FileClose(f);

 end;

 UstawKolory;                                  //odswiez kolory
end;


if FMove.MovePMG.Checked then begin
// przemiesc tablice Sprajt (MOVE PMG)
 f:=FileCreate(GetUndoName('dump$.$$$'));
 FileWrite(f,Sprajt,sizeof(Sprajt));
 FileClose(f);

 fillchar(Sprajt,sizeof(Sprajt),0);               //czysc Sprajt

 f:= FileOpen(GetUndoName('dump$.$$$'), fmOpenRead);
 FileSeek(f, 0, 0);

 if x>0 then begin              // w dol
  tmp:=(240-y)*sizeof(tablica_sprite);
  FileRead(f,Sprajt[y],tmp);
 end else begin                 // w gore
  tmp:=y*sizeof(tablica_sprite);
  FileRead(f,Sprajt,tmp);
  fillchar(Sprajt,sizeof(Sprajt),0);
  FileRead(f,Sprajt,sizeof(Sprajt));
 end;
 FileClose(f);

// przemiesc tablice SprajtX
 f:=FileCreate(GetUndoName('dump$.$$$'));
 FileWrite(f,SprajtX,sizeof(SprajtX));
 FileClose(f);

 fillchar(SprajtX,sizeof(SprajtX),0);             //czysc SprajtX

 f:= FileOpen(GetUndoName('dump$.$$$'), fmOpenRead);
 FileSeek(f, 0, 0);

 if x>0 then begin              // w dol
  tmp:=(240-y)*sizeof(tablica_sprite);
  FileRead(f,SprajtX[y],tmp);
 end else begin                 // w gore
  tmp:=y*sizeof(tablica_sprite);
  FileRead(f,SprajtX,tmp);
  fillchar(SprajtX,sizeof(SprajtX),0);
  FileRead(f,SprajtX,sizeof(SprajtX));
 end;
 FileClose(f);

// przemiesc tablice ksztaltow
 fillchar(bufm,sizeof(bufm),$0080);
 move(Spr0,bufm[$100],$200); move(bufm[$100-x],Spr0,$200);
 fillchar(bufm,sizeof(bufm),$0080);
 move(Spr1,bufm[$100],$200); move(bufm[$100-x],Spr1,$200);
 fillchar(bufm,sizeof(bufm),$0080);
 move(Spr2,bufm[$100],$200); move(bufm[$100-x],Spr2,$200);
 fillchar(bufm,sizeof(bufm),$0080);
 move(Spr3,bufm[$100],$200); move(bufm[$100-x],Spr3,$200);

 fillchar(bufm,sizeof(bufm),$0080);
 move(Mis0,bufm[$100],$200); move(bufm[$100-x],Mis0,$200);
 fillchar(bufm,sizeof(bufm),$0080);
 move(Mis1,bufm[$100],$200); move(bufm[$100-x],Mis1,$200);
 fillchar(bufm,sizeof(bufm),$0080);
 move(Mis2,bufm[$100],$200); move(bufm[$100-x],Mis2,$200);
 fillchar(bufm,sizeof(bufm),$0080);
 move(Mis3,bufm[$100],$200); move(bufm[$100-x],Mis3,$200);

// przemiesc staly ksztalt spritow SMASK
 for j:=0 to 7 do begin
  fillchar(bufor,sizeof(bufor),$ff);         //czyscimy BUFOR
  move(Smask[j shl 8],bufor[$100],$100);     //kopiujemy do BUFOR+256 kolory
  move(bufor[$100-x],Smask[j shl 8],$100);   //teraz przepisz z przeunieciem X
 end;
end;


if FMove.MoveColors.Checked then begin
// przemiesc tablice Raster
 f:=FileCreate(GetUndoName('dump$raster.$$$'));
 FileWrite(f,Raster,sizeof(raster));
 FileClose(f);

 g:=FileCreate(GetUndoName('dump$rasterlo.$$$'));
 FileWrite(g,raster_line_ofset,sizeof(raster_line_ofset));
 FileClose(g);

 ClearRaster;                   //czysc Raster
 f:=FileOpen(GetUndoName('dump$raster.$$$'), fmOpenRead);
 FileSeek(f,0,0);

 g:=FileOpen(GetUndoName('dump$rasterlo.$$$'), fmOpenRead);
 FileSeek(g,0,0);

 i:=(240-y)*sizeof(tARaster);
 j:=(240-y)*sizeof(tRaster);

 if x>0 then begin                              // w dol
  FileRead(f, raster[y], i);
  FileRead(g, raster_line_ofset[y], j);
 end else begin                                 // w gore
  FileRead(f, raster, y*sizeof(tARaster));      // omijamy Y*sizeof bajtow
  FileRead(g, raster_line_ofset, y*sizeof(tRaster));
  ClearRaster;
  FileRead(f,raster,i);
  FileRead(g, raster_line_ofset, j);
 end;

 FileClose(f);
 FileClose(g);

end;


// oddajemy gorny i dolny fragment obrazu
 f:= FileOpen(GetUndoName('movey_tmp.$$$'), fmOpenRead);
 FileSeek(f, 0, 0);

 if y1>0 then
  if x>0 then
   paste_tmp(f,0,y1+x)
  else
   paste_tmp(f,0,y1);

 if y2<239 then paste_tmp(f,y2,ln);

 FileClose(f);

end;

 RestoreMove;           // przywracamy grafike z lewej/prawej strony zaznaczenia


 if Showchars1.Checked then
  ShowChars(0,29,false)
 else
  if ShowColorsMap1.Checked then
   ShowColorsMap1Execute(self)
  else
   form1.OdswiezObraz;


 if FCheck.Visible then FEditPMG.check_refresh;

end;


procedure TForm1.Preview_PMGClick(Sender: TObject);
begin
 SelectPreview.ItemIndex:=ord(___PMG);
end;

procedure TForm1.Preview_BMPClick(Sender: TObject);
begin
 SelectPreview.ItemIndex:=ord(___BMP);
end;

procedure TForm1.Preview_ALLClick(Sender: TObject);
begin
 SelectPreview.ItemIndex:=ord(___ALL);
end;


procedure char_pixel(const val: byte);
begin

  case Pixel of
    1:begin
       PalOfset:=20;

       put((val shr 7) and 1); put((val shr 6) and 1);
       put((val shr 5) and 1); put((val shr 4) and 1);
       put((val shr 3) and 1); put((val shr 2) and 1);
       put((val shr 1) and 1); put(val and 1)
      end;

    2:begin
       PalOfset:=22;

       put((val shr 6) and 3);
       put((val shr 4) and 3);
       put((val shr 2) and 3);
       put(val and 3);
      end;

    4:begin
       PalOfset:=0;

       put((val shr 4) and $f); put(val and $f);
      end;

  end;

end;


procedure TForm1.PokazCharset;
// przedstawia graficznie zestaw znakow w okienku FORM6
var i, j, k, val, x, y: byte;
    ok: Boolean;
    lStream: TFileStream;
begin

 charset_old:=charset;

 showCharset:=true;

 bmpChar.SetSize(145, 72 + 1);

 ClrRect(bmpChar);

 if FEditCharset.ComboCharset.ItemIndex=0 then
  move(fonty[charset shl 10], bufor, 1024)
 else begin
  lStream:=TFileStream.Create(GetUndoName(__echar), fmOpenRead);
  lStream.Position:=(FEditCharset.ComboCharset.ItemIndex-1) * sizeof(tcharset) + 33;
  lStream.ReadBuffer(bufor, 1024);
  lStream.Free;
 end;          

for k:=0 to 7 do
 for i:=0 to 15 do begin

 if FEditCharset.ComboCharset.ItemIndex=0 then begin

 // pokazujemy znaki ktore sa wykorzystane na ekranie
  ok:=false;
  for y:=0 to 29 do
   if table[y]=charset then begin

    for x:=0 to Bajt-1 do
     if scren[Sofs(x,tmul48[y])] and $7f = i+k shl 4 then begin
      ok:=true;
      Break;
     end;

   end;

 end else
  ok:=true;

  if ok then
  for j:=0 to 7 do begin
  px:=i*9 + 1; py:=j+k*9 + 1;

  val:=bufor[(i+k shl 4) shl 3+j];

  if gfxMode[cur.Y]<>0 then
   Pixel:=gfxMode[cur.Y]
  else
   UstawPixel;

  char_pixel(val);

  end;

 end;

//FEditCharset.Image1.Picture.Graphic:=bmpChar;
FEditCharset.Image1.Bitmap.Assign(bmpChar);

ShowCharset:=false;

FEditCharset.PutChar(AktywnyZnak);

UstawPixel;
end;


procedure ZaznaczAktualnyZnakNaMatrycy;
begin
 FEditCharset.SetShape1(shp.x*16, shp.y*16);
end;

procedure TForm1.ZaznaczAktualnyZnak(const x,y: byte);
begin
 FEditCharset.SetShape2 (x*18, y*18);

 ZaznaczAktualnyZnakNaMatrycy;
end;


procedure TForm1.PrzepiszShape9NaZnaki;
var i, x, y, ofs, tmp: integer;
begin

if FEditCharset.Visible then begin

 showCharset:=true;

 UstawPixel;

 bmpChar.SetSize(72+2,72+2);

 ClrRect(bmpChar);

 ofs:=CurShp.X+tmul48[CurShp.Y] shl 3;

 for y:=0 to yel_hig-1 do
  for x:=0 to yel_wid-1 do begin
   tmp:=ofs+x+tmul48[y] shl 3;

   for i:=0 to 7 do begin
    px:=x shl 3 + 1;
    py:=y shl 3+i + 1;

    char_pixel( tab[tmp+tmul48[i]] );
   end;

  end;

 FEditCharset.Image3.Bitmap.Assign(bmpChar);

 showCharset:=false;

 FEditCharset.yellow_char_status;

end;

end;


procedure MarchingAnts(x,y: integer; lpData: lParam); stdcall;
var cord: integer;
    cl: TColor;
begin

 case lpData of
  AL_RIGHT: cord:=x;
   AL_DOWN: cord:=y;
   AL_LEFT: cord:=SelectArea.Width-x;
     AL_UP: cord:=SelectArea.Height-y;
 end;

 if (cord shr 1) mod 4 = Offset_ants and 3 then
  cl:=clBlack
 else
  cl:=clWhite;

 SetPixelV(wycinek.Canvas.Handle, x,y, cl);

 case lpData of
  AL_RIGHT: SetPixelV(wycinek.Canvas.Handle, x,y+1, cl);
   AL_DOWN: SetPixelV(wycinek.Canvas.Handle, x-1,y, cl);
   AL_LEFT: SetPixelV(wycinek.Canvas.Handle, x,y-1, cl);
     AL_UP: SetPixelV(wycinek.Canvas.Handle, x+1,y, cl);
 end;

end;


procedure DrawSelectMarker;
var Width, Height: integer;
begin

 Width:=SelectArea.Left+SelectArea.Width-1;
 Height:=SelectArea.Top+SelectArea.Height-1;

 LineDDA(SelectArea.Left,SelectArea.Top,Width,SelectArea.Top,   @MarchingAnts, AL_RIGHT);

 if SelectArea.Height>0 then begin
  LineDDA(Width,SelectArea.Top,Width,Height,           @MarchingAnts, AL_DOWN);
  LineDDA(SelectArea.Left,Height,Width,Height,         @MarchingAnts, AL_LEFT);
  LineDDA(SelectArea.Left,Height,SelectArea.Left,SelectArea.Top, @MarchingAnts, AL_UP);
 end;

 form1.Image4.Picture.Graphic:=wycinek;
end;


procedure TForm1.kafelek(const przepisz: Boolean);
var x, y, val, i, j, c: integer;
    zm: string;
begin

x := Cur.X;
y := Cur.Y;

charset:=table[y];

val:=AktywnyZnak;

zm:='';

if FEditCharset.ComboCharset.ItemIndex=0 then begin

 val:=scren[x+tmul48[y]];

 zm:=format('Charset #%d  (char #%d',[charset, val and $7f]);

 if val>127 then zm:=zm+' with invers';

 C:=0;
 for j := 0 to 29 do
  for i := 0 to Bajt - 1 do
   if table[j]=charset then
    if scren[CzarnyPas shr 3+i+tmul48[j]]=val then inc(c);


 zm:=zm+' is used '+IntToStr(c)+' times in the screen)';


 if FEditCharset.Visible then begin
  PokazCharset;
  ZaznaczAktualnyZnak((val and $7f) and $0f , (val and $7f) shr 4);
 end;

end;

 FEditCharset.PutChar(val);

 FEditCharset.StatusBar1.Panels[3].Text:=zm;


if przepisz then begin

 SelectArea.Left := CurShp.X shl 4;
 SelectArea.Top  := CurShp.Y shl 4;

 pMark:=Point(CurShp.X shl 3, CurShp.Y shl 3);
 lMark:=Point(pMark.X+yel_wid shl 3, pMark.Y+yel_hig shl 3);

 ClrShape9;

 PrzepiszShape9NaZnaki;

end;

end;


procedure TForm1.create_yellow_cursor;
begin
 if (CurShp.X+yel_wid)>48 then dec(yel_wid);
 if (CurShp.Y+yel_hig)>30 then dec(yel_hig);

 SelectArea.Width  := yel_wid shl 4;
 SelectArea.Height := yel_hig shl 4;

 pMark:=Point(CurShp.X shl 3, CurShp.Y shl 3);
 lMark:=Point(pMark.X+yel_wid shl 3, pMark.Y+yel_hig shl 3);

 ClrShape9;

 PrzepiszShape9NaZnaki;

 ZaznaczAktualnyZnakNaMatrycy;
end;


procedure TForm1.Charsfill1Click(Sender: TObject);
var t,l: integer;
begin

 if done>0 then begin

  SetFormPos('FCharsFill', t,l);
  FCharsFill.top:=t;
  FCharsFill.left:=l;

  FCharsFill.Memo1.Height:=canvas.TextHeight('A')*30;
  FCharsFill.Memo1.Text:=CharsFill;

  if FCharsFill.ShowModal=mrCancel then begin end;

 end;

end;


procedure TForm1.CloseScreenClick(Sender: TObject);
begin
 if MenuScreen.Visible then ClearScreen;
end;


procedure TForm1.Select_OFF(const a: Boolean);
begin

 Shape1.Cursor:=crDefault;
 Shape1.Visible:=a;
 Shape1.Height:=0;
 Shape1.Width:=2;
 Shape1.Left:=pozX; Shape2.Left:=pozX;
 Shape1.Top:=pozY; Shape2.Top:=pozY;

end;


procedure init_mrugania_duchow;
begin
                  
 with form1.image4.Canvas do begin
  brush.Color:=transCol; 
  FillRect(Rect(0,0, form1.image4.Width, form1.image4.Height));
  brush.Color:=clRed; pen.Color:=clRed;
 end;

end;


procedure TForm1.EditPMGExecute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* EDIT PMG                                                                   *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin

 ZamknijBMPLimitations;

 UstawPixel;

 zamknij(f_EditBMP);
 zamknij(f_EditRasters);
 zamknij(f_SelectColor);
 zamknij(f_EditColors);
 zamknij(f_EditPalette);
 zamknij(f_EditColorsMap);

 init_mrugania_duchow;

//if not(form5.Visible) then begin

 if prev<>___pmg then SelectPreview.ItemIndex:=ord(___ALL);


 with FEditPMG do begin
  Caption:='Edit PMG';

  ClientHeight := Bevel2.Top + Bevel2.Height;

  //Height:=447;
//  Label4.Visible:=true;
  Panel5.Visible:=false;
  Panel6.Visible:=false;

  FImportBMP.Enabled:=true;
 end;

{
 case Pixel of
  1: FEditPMG.udPrior.Max:=-2;                // priority = 0,1
  4: FEditPMG.udPrior.Max:=-3;                // priority = 1
 else
  FEditPMG.udPrior.Max:=1;
 end;
}

 if not(form1.EditPMG.Checked) then begin

  form1.zamknij(f_EditCharset);
  form1.zamknij(f_Bmp2Pmg);

  SetFormPos('FEditPMG', t,l);
  FEditPMG.top:=t;
  FEditPMG.left:=l;

  FEditPMG.Visible:=true;

  UstawKolory;         // wywolanie UstawKolory zadziala gdy forma jest widoczna

  EditPMG.Checked:=true;
  ChangePMG.Checked:=false;

  Shape1.Visible:=false;
  Shape2.Visible:=false;

  if not(FEditRasters.Visible) then begin
   Select_off(true);
   form1.Usun_Zaznaczenia(true);
  end;

  FEditPMG.WskazLinie;

  if FZoom.Visible then begin
   FEditPMG.frameLineRange1.seRange.Position:=0;
   FEditPMG.frameLineRange1.seLine.Position:=crY;
  end else
   FEditPMG.AktualizujSprity;

 end else
  form1.zamknij(f_EditPMG);

//end;


// image4.Visible:=true;
 image4.Enabled:=false;

end;


procedure TForm1.EditColorsExecute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* EDIT COLORS                                                                *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin

 ZamknijBMPLimitations;

 zamknij(f_SelectColor);
 zamknij(f_EditBMP); 
 zamknij(f_EditPMG);
 zamknij(f_Bmp2Pmg);
 zamknij(f_EditPalette);
 zamknij(f_EditColorsMap);
 zamknij(f_EditCharset);

 UstawPixel;

 SelectPreview.ItemIndex:=ord(___ALL);

 FEditColors.KoloryInit(t_gtia(form1.SelectGTIA.ItemIndex));

 if not(EditColors.checked) then begin

  if not(FEditColors.Visible) then begin
   SetFormPos('FEditColors', t, l);
   FEditColors.Top:=t;
   FEditColors.Left:=l;

   FEditColors.Visible:=true;
  end;

  UstawKolory;                               // zadziala gdy forma jest widoczna

  FEditColors.LineChange;

  EditColors.Checked:=true;
  ChangeColors.Checked:=false;

  form1.Usun_Zaznaczenia(false);

  Shape3_4Enable(true);

  FEditColors.ClientHeight := FEditColors.Bevel2.Top + FEditColors.Bevel2.Height + FEditColors.Panel2.Top;

  if FZoom.Visible then FEditColors.frameLineRange1.seLine.Position:=NormalizeYPos(crY);

 end else
  form1.zamknij(f_EditColors);

end;


function TForm1.LiczCRCRaster(const y: integer): cardinal;
var i: integer;
    crc: cardinal;
begin

 crc:=$ffffffff;

 if not(DLItoRaster) then begin

  for i:=0 to RLimitInst-1 do begin
   fCRC(crc, raster[y, i].cod);
   fCRC(crc, raster[y, i].arg);
  end;

  fCRC(crc, raster_line_ofset[y].cod);
  fCRC(crc, raster_line_ofset[y].arg);

 end;

 Result:=crc;

end;


function get_tval(const a: word): AnsiString;
var i: integer;
begin
 Result:=' ';
 if a<=High(tval) then Result:=tval[a];

 if DLItoRaster then begin
  i:=AnsiPos(AnsiString('#'), Result);
  if i>0 then Result[i]:='=';

  i:=AnsiPos(AnsiString('ld'), Result);
  if i>0 then insert('?',Result,i);
 end;

end;


function get_tadr(const a: word): AnsiString;
var i: integer;
begin
 Result:=' ';
 if a <= High(tadr) then Result:=tadr[a];

 if DLItoRaster then begin
  i:=AnsiPos(AnsiString(' '), Result);
  if i>0 then Result[i]:='=';

  i:=AnsiPos(AnsiString('st'), Result);
  if i>0 then insert('?',Result,i);
 end;

end;


procedure SGedVal(const a: AnsiString);
var i: integer;
begin
 if px>0 then begin
  i:=High(tval);
  tval[i]:=a;

  SetLength(tval,i+2);
 end;
end;


procedure SGedAdr(const a: AnsiString);
var i: integer;
begin
 if px>0 then begin
  i:=High(tadr);
  tadr[i]:=a;

  SetLength(tadr,i+2);
 end;
end;


function color_label(const a: word): AnsiString;
begin
 Result:='';

 if (px>0) or (pupa) then
  if (a>=$d012) and (a<=$d01a) then begin
   Result:='c'+AnsiString(IntToStr(color_nr));
   inc(color_nr)
  end else
   if (a>=$d000) and (a<=$d007) then begin
    Result:='x'+AnsiString(IntToStr(posx_nr));
    inc(posx_nr)
   end else
    if (a>=$d008) and (a<=$d00c) then begin
     Result:='s'+AnsiString(IntToStr(size_nr));
     inc(size_nr)
    end;

end;


procedure sav(const a:byte; const w:integer);
var zm1, zm2, tx, dl, zm: AnsiString;
    rej: AnsiChar;
    i, j: integer;
begin

 zm1:=AnsiString(IntToHex(a,2));

 zm2:=form1.Hex(w,4);

 tx:=form1.reg_label(w);
 if tx<>'' then zm2:=tx;


 tx:='#$';
 if w=$d409 then begin

  if Fox1 and (px>7) and (table[px shr 3]=table[(px-8) shr 3]) then begin
   tx:='>_fnt';
//   if px>0 then Changes[px-1]:=0;   // !!! nie wyswietli liczby zmian w linii - CHECK -
  end else

  if px mod 8=0 then
   tx:='>fnt+$400*$'
  else
   tx:='>_fnt';

  tmp1:=-200;
 end;


 if a<>tmp[w-$d000] then begin

// if px=0 then dec(adres,5);

  if not(t_mode(form1.SelectMode.ItemIndex)=m_dli) then tmp1:=-100;

// czy ta wartosc jest rozna od poprzedniej
  if a<>tmp1 then begin
   dl:='';
   if (w=$d409) and (px>0) and ( (Changes[px-1]=0) or Fox1) then begin

    if pupa=false then begin
     str(dli_nr,dl); dl:='dli'+dl;

     if dli_nr=2 then begin
      save(';XXX');
//      save(' mwa #null null+1');
//      save(' jmp null');
     end else save(#9'DLINEW '+dl);

     save(''); save(dl);
     inc(dli_nr); bufor[px shr 3]:=$ff;
    end;

    wsync:=0; mnemo:=0;

   end else if (px>0) and (wsync>0) then begin

    for i:=0 to wsync-1 do begin
     str((px-wsync+1)+i,zm);
     if pupa=false then save(#9'sta '+form1.reg_label($d40a)+#9#9';line='+zm);
    end;
    wsync:=0; mnemo:=0;

   end;

    if (tx[1]='#') and (px>0) and (pupa=false) then inc(mnemo);

    if (tx[1]='#') and (px>0) and (mnemo>0) and (mnemo<4) then begin
     wsyncTab[px]:=mnemo; rej:=' ';
     case mnemo of
      1: rej:='a';
      2: rej:='x';
      3: rej:='y';
     end;

     if mnemo in [1..3] then begin
      j:=High(kosz);

      kosz[j]:=color_label(w)+#9'ld'+rej+' '+tx+zm1;
      sGedVal(kosz[j]); //color_label(w)+' ld'+rej+' '+tx+zm1);

      SetLength(kosz,j+2);
     end;


    end else
      if (tx[1]='>') and (px>0) then begin
       j:=High(kosz);                    // lda >fnt+$400*

       if pos('_fnt',tx)>0 then begin
        kosz[j]:=';ble';
        mnemo:=0;
       end else begin
        kosz[j]:=color_label(w)+#9'lda '+tx+zm1;
        sGedVal(kosz[j]); //color_label(w)+' lda '+tx+zm1);
        SetLength(kosz,j+2);

        mnemo:=1;
       end;

       {mnemo:=1;} wsyncTab[px]:=mnemo;
      end else begin
       zm:=color_label(w)+#9'lda '+tx+zm1;
       save(zm);
       sGedVal(zm)
      end;

   if (px>0) and (w=$d409) then begin
    str(px,zm); if pupa=false then save(#9'sta '+form1.reg_label($d40a)+#9#9';line='+zm);
    dec(wsync);            //mnemo:=0;
   end;
  end;


   if (mnemo=1) and (w=$d405) then save(#9'nop');

   if (tx[1]='#') and (px>0) and (mnemo>0) and (mnemo<4) then begin

    rej:=' ';
    case mnemo of
     1: rej:='a';
     2: rej:='x';
     3: rej:='y';
    end;

    if mnemo in [1..3] then begin
     save(#9'st' + rej + ' ' + zm2);
     SGedAdr(#9'st' + rej + ' ' + zm2);
     inc(changes[px])
    end;

   end else begin

    if AnsiPos(AnsiString('_fnt'),tx)=0 then begin

    save(#9'sta '+zm2);
    SGedAdr(#9'sta '+zm2);

    inc(changes[px]);
    end;

   end;

   inc(tmp2);
   tmp[w-$d000]:=a; tmp1:=a;

  if (tmp2>4) and (px>0) then begin
//   if pupa=false then save(';--'); // too many changes in this line');
   tmp2:=0;
  end;

 end;
end;


function TForm1.ObliczPiorytet(const px: integer): byte;
var pr, player5, mlc, v: byte;
begin
 v:=FEditPMG.GetPrior(px);

 pr:=1;

 case v of
//  2: pr:=1;
  1: pr:=2;
  0: pr:=4;
  3: pr:=8;
  4: pr:=0;
 end;

 player5:=FEditPMG.GetPlayer5Value(px,false);
 if player5>0 then pr:=pr or $10;

 mlc:=FEditPMG.GetMLCValue(px,false);
 if mlc>0 then pr:=pr or $20;

 Result:=pr;
end;


function testPMr(const a: word; const y: integer): Boolean;
var i: integer;
begin

 Result:=false;

 if t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo] then

  Result:=true

 else

  for i := Low(tablica_sprite) to High(tablica_sprite) do
   case a of
    $800: if SprajtX[y,i] and $aa<>0 then begin Result:=true; exit end;

    $000: if SprajtX[y,i] and 1<>0 then begin Result:=true; exit end;
    $200: if SprajtX[y,i] and 4<>0 then begin Result:=true; exit end;
    $400: if SprajtX[y,i] and 16<>0 then begin Result:=true; exit end;
    $600: if SprajtX[y,i] and 64<>0 then begin Result:=true; exit end;

    $100: if SprajtX[y,i] and 2<>0 then begin Result:=true; exit end;
    $300: if SprajtX[y,i] and 8<>0 then begin Result:=true; exit end;
    $500: if SprajtX[y,i] and 32<>0 then begin Result:=true; exit end;
    $700: if SprajtX[y,i] and 128<>0 then begin Result:=true; exit end;
   end;

end;


function testPM(const a: word): Boolean;
var i: integer;
begin
 Result:=false;

 for i:=0 to Wysokosc-1 do
  if SmaskX[a+i]<>0 then begin Result:=true; exit end;

 for i := 0 to Wysokosc-1 do
  if testPMr(a, i) then begin Result:=true; Break end;

end;


procedure PutData(const ile: byte; clear: Boolean = false);
var x, y: byte;
begin
 px:=$ff;

 if clear then fillchar(bufor, 256, 0);

 for y:=0 to ile-1 do begin
  eol_:=false; save(#9'.he');
  for x:=0 to 15 do save(' '+AnsiString(IntToHex(bufor[x+y*16], 2)));
  eol_:=true; save('');
 end;

end;


procedure save_pmg_data(const m,p0,p1,p2,p3, _asm: Boolean);
var y0, y1, y2, y3, i: byte;
begin

// tworzenia danych pociskow
for i:=0 to 255 do begin
 y0:=(SmaskX[$100+i] and $c0) shr 6;
 y1:=(SmaskX[$300+i] and $c0) shr 4;
 y2:=(SmaskX[$500+i] and $c0) shr 2;
 y3:=SmaskX[$700+i] and $c0;

 SmaskX[$800+i]:=y0 or y1 or y2 or y3;
end;

// jesli grafika PMG jest pusta, nie zawiera zadnych ksztaltow
// i jesli nie ma zadnych odwolan do takiego ducha wowczas nie zapisujemy
// jego danych


if m then begin

 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$800],bufor[8],256-16);

 if not(_asm) then
  FileWrite(dane, bufor, 256)
 else begin
  save('missiles');

  if testPM($800) then
   PutData(16)
  else
   PutData(16, true);
 end;

end;


if p0 then begin

 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$000],bufor[8],256-16);

 if not(_asm) then
  FileWrite(dane, bufor, 256)
 else begin
  save('player0');

  if testPM($000) then
   PutData(16)
  else
   PutData(16, true);
 end;

end;


if p1 then begin

 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$200],bufor[8],256-16);

 if not(_asm) then
  FileWrite(dane, bufor, 256)
 else begin
  save('player1');

  if testPM($200) then
   PutData(16)
  else
   PutData(16, true);
 end;

end;


if p2 then begin

 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$400],bufor[8],256-16);

 if not(_asm) then
  FileWrite(dane, bufor, 256)
 else begin
  save('player2');

  if testPM($400) then
   PutData(16)
  else
   PutData(16, true);
 end;

end;


if p3 then begin

 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$600],bufor[8],256-16);

 if not(_asm) then
  FileWrite(dane, bufor, 256)
 else begin
  save('player3');

  if testPM($600) then
   PutData(16)
  else
   PutData(16, true);
 end;

end;

end;


procedure initPMGData;
(*----------------------------------------------------------------------------*)
(* zapisanie zmian rejestrów , PMG  co linie                                  *)
(*----------------------------------------------------------------------------*)
var pr: byte;
    _x: integer;
begin

move(Smask,SmaskX,$800);


dane:=FileCreate(form1.GetUndoName('nul.dat'));


tmp2:=0; dli_nr:=2; wsync:=1;

 for _x:=0 to Wysokosc-1 do begin

  px := _x;

//  pr:=form1.ObliczPiorytet(px);
//  gtia:=form1.SetGTIAValue(gfxMode[px shr 3]);

  gtia:=rKolor[px, 9] and $c0;
  pr:=rKolor[px, 9] and $3f;

  if UseChar then
  if fox1 then begin
   if (px mod 4=0) then begin
    tmp[$409]:=-100;
    sav(table[px shr 3],$d409);
   end;
  end else
   sav(table[px shr 3],$d409);

  tmp1:=-200;
  if px>0 then begin inc(wsync); tmp2:=0; end;

  form1.SaveChange(pr);
 end;

 FileClose(dane);
end;


procedure SavePMG(atari: Boolean = false; fnam: string = '');
(*----------------------------------------------------------------------------*)
(* SAVE SPRITES                                                               *)
(*----------------------------------------------------------------------------*)
var zm: string;
begin

 if atari then
  zm:=fnam
 else begin
  zm:=form1.Savedialog1.FileName;
  zm:=ChangeFileExt(zm, '.pmg');
 end;

 if FSpecial.PmgAtari.Checked or atari then begin          // ATARI

  initPMGdata;

  dane:=FileCreate(zm);

  save_pmg_data(true,true,true,true,true, false);

 end else begin                                            // G2F

  dane:=FileCreate(zm);

  FileWrite(dane,TabKolor[$500],4*$100);

  FileWrite(dane,Spr0,sizeof(Spr0)); FileWrite(dane,Mis0,sizeof(Mis0));
  FileWrite(dane,Spr1,sizeof(Spr1)); FileWrite(dane,Mis1,sizeof(Mis1));
  FileWrite(dane,Spr2,sizeof(Spr2)); FileWrite(dane,Mis2,sizeof(Mis2));
  FileWrite(dane,Spr3,sizeof(Spr3)); FileWrite(dane,Mis3,sizeof(Mis3));

  FileWrite(dane,Smask,sizeof(Smask));

  FileWrite(dane,Sprajt,sizeof(Sprajt));
  FileWrite(dane,SprajtX,sizeof(SprajtX));

  FileWrite(dane,TabKolor[$400],$100);

 end;

 FileClose(dane);
end;



procedure SaveVBL;
var x, y, pr: byte;
    v, _x: word;
    y0, y1, y2, y3: smallint;
    my0, my1, my2, my3: smallint;
    mx0, mx1, mx2, mx3: byte;
    m0, m1, m2, m3: byte;
    i: integer;
begin

 for i := 0 to High(tmp) - 1 do tmp[i] := -100;

 dane:=FileCreate(form1.GetUndoName('temp.$$$'));

 pupa:=true; eol_:=true; old_m:=0; tmp2:=0;

{
if t_mode(form1.SelectMode.ItemIndex)=m_pgr then
 with tgtia do begin

   if hposp0-32>0 then begin sav(hposp0, $d000); sav(TabKolor[$500], $d012); sav(sizep0, $d008) end;
   if hposp1-32>0 then begin sav(hposp1, $d001); sav(TabKolor[$600], $d013); sav(sizep1, $d009) end;
   if hposp2-32>0 then begin sav(hposp2, $d002); sav(TabKolor[$700], $d014); sav(sizep2, $d00a) end;
   if hposp3-32>0 then begin sav(hposp3, $d003); sav(TabKolor[$800], $d015); sav(sizep3, $d00b) end;

   if hposm0-32>0 then begin sav(hposm0, $d004); sav(TabKolor[$500], $d012); sav(sizem, $d00c) end;
   if hposm1-32>0 then begin sav(hposm1, $d005); sav(TabKolor[$600], $d013); sav(sizem, $d00c) end;
   if hposm2-32>0 then begin sav(hposm2, $d006); sav(TabKolor[$700], $d014); sav(sizem, $d00c) end;
   if hposm3-32>0 then begin sav(hposm3, $d007); sav(TabKolor[$800], $d015); sav(sizem, $d00c) end;

 end;
}


if t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr] then tmp[$409]:=0;

for _x:=0 to Wysokosc-1 do begin

px := _x;

gtia:=form1.SetGTIAValue(gfxMode[px shr 3]);

pr:=form1.ObliczPiorytet(px);

//gtia:=rKolor[px, 9] and $c0;
//pr:=rKolor[px, 9] and $3f;

if tmp[$409]<0 then begin sav(table[px shr 3],$d409); tmp1:=-200; end;

if fox1 then
 if tmp[$405]<0 then begin sav(4,$d405); tmp[$405]:=3 end;

if NoBadLines then
 if tmp[$405]<0 then begin sav(4,$d405); tmp[$405]:=12 end;


if (pr or gtia) and $f0=$80 then begin
 if tmp[$012]<0 then sav(tabKolor[px+$000],$d012);       //704
 if tmp[$013]<0 then sav(tabKolor[px+$100],$d013);       //705
 if tmp[$014]<0 then sav(tabKolor[px+$200],$d014);       //706
 if tmp[$015]<0 then sav(tabKolor[px+$300],$d015);       //707
 if tmp[$016]<0 then sav(tabKolor[px+$400],$d016);       //708
 if tmp[$017]<0 then sav(tabKolor[px+$500],$d017);       //709
 if tmp[$018]<0 then sav(tabKolor[px+$600],$d018);       //710
 if tmp[$019]<0 then sav(tabKolor[px+$700],$d019);       //711
 if tmp[$01a]<0 then sav(tabKolor[px+$800],$d01a);       //712
end else
 case gfxMode[px shr 3] of
    0: if tmp[$01a]<0 then sav(tabKolor[px+$000],$d01a);  //712

    4: begin
        if tmp[$01a]<0 then sav(tabKolor[px+$000],$d01a); //712
        if tmp[$019]<0 then sav(tabKolor[px+$400],$d019); //711
       end;

    1: begin
        if tmp[$01a]<0 then sav(tabKolor[px+$000],$d01a); //712
        if tmp[$017]<0 then sav(tabKolor[px+$200],$d017); //709
        if tmp[$018]<0 then sav(tabKolor[px+$300],$d018); //710
        if tmp[$019]<0 then sav(tabKolor[px+$400],$d019); //711
       end;

  else

   begin
    if tmp[$01a]<0 then sav(tabKolor[px+$000],$d01a);     //712
    if tmp[$016]<0 then sav(tabKolor[px+$100],$d016);     //708
    if tmp[$017]<0 then sav(tabKolor[px+$200],$d017);     //709
    if tmp[$018]<0 then sav(tabKolor[px+$300],$d018);     //710
    if tmp[$019]<0 then sav(tabKolor[px+$400],$d019);     //711
   end;

 end;

if tmp[$401]<0 then sav(chrctl[px shr 3],$d401);

if tmp[$01b]<0 then sav(pr or gtia,$d01b);

v:=Spr0[px]; x:=v shr 8; y0:=(v and $00ff)+32;
if x>127 then y0:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$008]<0 then sav(x,$d008); end;

v:=Spr1[px]; x:=v shr 8; y1:=(v and $00ff)+32;
if x>127 then y1:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$009]<0 then sav(x,$d009); end;

v:=Spr2[px]; x:=v shr 8; y2:=(v and $00ff)+32;
if x>127 then y2:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$00a]<0 then sav(x,$d00a); end;

v:=Spr3[px]; x:=v shr 8; y3:=(v and $00ff)+32;
if x>127 then y3:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$00b]<0 then sav(x,$d00b); end;

v:=Mis0[px]; mx0:=v shr 8; my0:=(v and $00ff)+32;
v:=Mis1[px]; mx1:=v shr 8; my1:=(v and $00ff)+32;
v:=Mis2[px]; mx2:=v shr 8; my2:=(v and $00ff)+32;
v:=Mis3[px]; mx3:=v shr 8; my3:=(v and $00ff)+32;


// X to nowy rozmiar, Y to maska dla operacji AND
// dzieki temu jednoznacznie stwierdzimy czy rozmiar sie zmienil
x:=0; y:=0;
if mx0<128 then begin m0:=mx0 and $f; if m0>0 then dec(m0); x:=m0; y:=y or $03 end;
if mx1<128 then begin m1:=mx1 and $f; if m1>0 then dec(m1); x:=x or (m1 shl 2); y:=y or $0c end;
if mx2<128 then begin m2:=mx2 and $f; if m2>0 then dec(m2); x:=x or (m2 shl 4); y:=y or $30 end;
if mx3<128 then begin m3:=mx3 and $f; if m3>0 then dec(m3); x:=x or (m3 shl 6); y:=y or $c0 end;

if (tmp[$00c]<0) and ((old_m and y)<>x) then begin old_m:=x; sav(x,$d00c) end;

if (tmp[$000]<0) and ((y0>0) or testPMr($000,px)) then sav(y0,$d000);
if (tmp[$001]<0) and ((y1>0) or testPMr($200,px)) then sav(y1,$d001);
if (tmp[$002]<0) and ((y2>0) or testPMr($400,px)) then sav(y2,$d002);
if (tmp[$003]<0) and ((y3>0) or testPMr($600,px)) then sav(y3,$d003);

if (tmp[$004]<0) and ((mx0<128) or testPMr($100,px)) then sav(my0,$d004);
if (tmp[$005]<0) and ((mx1<128) or testPMr($300,px)) then sav(my1,$d005);
if (tmp[$006]<0) and ((mx2<128) or testPMr($500,px)) then sav(my2,$d006);
if (tmp[$007]<0) and ((mx3<128) or testPMr($700,px)) then sav(my3,$d007);

if (tmp[$012]<0) and ((y0>0) or (mx0<128) or testPMr($000, px) or testPMr($100, px)) then sav(tabKolor[px+$500],$d012);
if (tmp[$013]<0) and ((y1>0) or (mx1<128) or testPMr($200, px) or testPMr($300, px)) then sav(tabKolor[px+$600],$d013);
if (tmp[$014]<0) and ((y2>0) or (mx2<128) or testPMr($400, px) or testPMr($500, px)) then sav(tabKolor[px+$700],$d014);
if (tmp[$015]<0) and ((y3>0) or (mx3<128) or testPMr($600, px) or testPMr($700, px)) then sav(tabKolor[px+$800],$d015);

end;


// tutaj wymuszamy zapis rejestrow D000..D007 aby program inicjalizacji zawieral min 16 rozkazow lda#/sta

for x := 0 to 32-5 do
 if not(x in [$0d..$11]) then                 // pomijamy grafp0..3, grafm
  if tmp[x]<0 then sav(0, $d000+x);

FileClose(dane);

color_vbl := color_nr;
end;


procedure TForm1.SaveChange(const pr:byte);
var x, y: byte;
    v: word;
    y0, y1, y2, y3: byte;
    mx0, mx1, mx2, mx3, my0, my1, my2, my3: byte;
    m0, m1, m2, m3: byte;
begin

if fox1 then
 if (px mod 4=0) then sav(tmp[$405] xor 7, $d405);

if NoBadLines then
 if (px mod 8=0) then sav(tmp[$405] xor 8, $d405);


if (pr or gtia) and $f0=$80 then begin
 sav(tabKolor[px+$000],$d012); if locKolor[px+$000] then tmp[$12]:=-100;
 sav(tabKolor[px+$100],$d013); if locKolor[px+$100] then tmp[$13]:=-100;
 sav(tabKolor[px+$200],$d014); if locKolor[px+$200] then tmp[$14]:=-100;
 sav(tabKolor[px+$300],$d015); if locKolor[px+$300] then tmp[$15]:=-100;
 sav(tabKolor[px+$400],$d016); if locKolor[px+$400] then tmp[$16]:=-100;
 sav(tabKolor[px+$500],$d017); if locKolor[px+$500] then tmp[$17]:=-100;
 sav(tabKolor[px+$600],$d018); if locKolor[px+$600] then tmp[$18]:=-100;
 sav(tabKolor[px+$700],$d019); if locKolor[px+$700] then tmp[$19]:=-100;
 sav(tabKolor[px+$800],$d01a); if locKolor[px+$800] then tmp[$1a]:=-100;
end else
 if gfxMode[px shr 3]=0 then begin

  sav(tabKolor[px+$000],$d01a); if locKolor[px+$000] then tmp[$1a]:=-100;

 end else begin

  sav(tabKolor[px+$000],$d01a); if locKolor[px+$000] then tmp[$1a]:=-100;   // !!! koniecznie $d016..$d01a !!!
  sav(tabKolor[px+$100],$d016); if locKolor[px+$100] then tmp[$16]:=-100;   // inaczej nie zadziala GRUNWALD.g2f
  sav(tabKolor[px+$200],$d017); if locKolor[px+$200] then tmp[$17]:=-100;
  sav(tabKolor[px+$300],$d018); if locKolor[px+$300] then tmp[$18]:=-100;
  sav(tabKolor[px+$400],$d019); if locKolor[px+$400] then tmp[$19]:=-100;

 end;

sav(chrctl[px shr 3],$d401);

sav(pr or gtia,$d01b);

v:=Spr0[px]; x:=v shr 8; y0:=byte((v and $00ff)+32);
if x>127 then y0:=0 else begin x:=x and $f;
if x>0 then dec(x); sav(x,$d008); end;

v:=Spr1[px]; x:=v shr 8; y1:=byte((v and $00ff)+32);
if x>127 then y1:=0 else begin x:=x and $f;
if x>0 then dec(x); sav(x,$d009); end;

v:=Spr2[px]; x:=v shr 8; y2:=byte((v and $00ff)+32);
if x>127 then y2:=0 else begin x:=x and $f;
if x>0 then dec(x); sav(x,$d00a); end;

v:=Spr3[px]; x:=v shr 8; y3:=byte((v and $00ff)+32);
if x>127 then y3:=0 else begin x:=x and $f;
if x>0 then dec(x); sav(x,$d00b); end;

v:=Mis0[px]; mx0:=v shr 8; my0:=byte((v and $00ff)+32);
v:=Mis1[px]; mx1:=v shr 8; my1:=byte((v and $00ff)+32);
v:=Mis2[px]; mx2:=v shr 8; my2:=byte((v and $00ff)+32);
v:=Mis3[px]; mx3:=v shr 8; my3:=byte((v and $00ff)+32);

x:=0; y:=0;
if mx0<128 then begin m0:=mx0 and $f; if m0>0 then dec(m0); x:=m0; y:=3; end;
if mx1<128 then begin m1:=mx1 and $f; if m1>0 then dec(m1); x:=x or (m1 shl 2); y:=y or $0c; end;
if mx2<128 then begin m2:=mx2 and $f; if m2>0 then dec(m2); x:=x or (m2 shl 4); y:=y or $30; end;
if mx3<128 then begin m3:=mx3 and $f; if m3>0 then dec(m3); x:=x or (m3 shl 6); y:=y or $c0; end;

if ((old_m and y)<>x) then begin sav(x,$d00c); old_m:=x end;

if y0>0 then sav(y0,$d000) else if not(testPMr($000,px)) then SmaskX[$000+px]:=0;
if y1>0 then sav(y1,$d001) else if not(testPMr($200,px)) then SmaskX[$200+px]:=0;
if y2>0 then sav(y2,$d002) else if not(testPMr($400,px)) then SmaskX[$400+px]:=0;
if y3>0 then sav(y3,$d003) else if not(testPMr($600,px)) then SmaskX[$600+px]:=0;

if mx0<128 then sav(my0,$d004) else if not(testPMr($100,px)) then SmaskX[$100+px]:=0;
if mx1<128 then sav(my1,$d005) else if not(testPMr($300,px)) then SmaskX[$300+px]:=0;
if mx2<128 then sav(my2,$d006) else if not(testPMr($500,px)) then SmaskX[$500+px]:=0;
if mx3<128 then sav(my3,$d007) else if not(testPMr($700,px)) then SmaskX[$700+px]:=0;

if (y0>0) or (mx0<128) or testPMr($000,px) or testPMr($100,px) then sav(tabKolor[px+$500],$d012);
if (y1>0) or (mx1<128) or testPMr($200,px) or testPMr($300,px) then sav(tabKolor[px+$600],$d013);
if (y2>0) or (mx2<128) or testPMr($400,px) or testPMr($500,px) then sav(tabKolor[px+$700],$d014);
if (y3>0) or (mx3<128) or testPMr($600,px) or testPMr($700,px) then sav(tabKolor[px+$800],$d015);
end;


procedure TForm1.save_zerop_variables;
begin

 if t_mode(form1.SelectMode.ItemIndex) in [m_gedp, m_gedm, m_pgr, m_piccolo] then begin
  save(#9'org $00'#13#10);
  save('zc'#9'.ds ZCOLORS'#13#10);
 end;

 save(#9'org $f0'#13#10);
 save('fcnt'#9'.ds 2');
 save('fadr'#9'.ds 2');
 save('fhlp'#9'.ds 2');
 save('cloc'#9'.ds 1');
 save('regA'#9'.ds 1');
 save('regX'#9'.ds 1');
 save('regY'#9'.ds 1');

 if asm_slideshow then begin
  save(#13#10'old_dli'#9'= $204');
  save('old_nmi'#9'= $206');
 end;

 save(#13#10'WIDTH'#9'= '+AnsiString(IntToStr(Bajt)));

 if Fox1 then
  save('HEIGHT'#9'= 60')
 else
  save('HEIGHT'#9'= 30');

end;


procedure Etykiety;
var a: string;
    i,k: byte;
begin

//if SpecialStr[___ShortLabels].val then begin
// save(#13#10'scr48'#9'= %00111111	;screen 48b');
// save('scr40'#9'= %00111110	;screen 40b');
// save('scr32'#9'= %00111101	;screen 32b');
 form1.DepackRES('ATARIH', form1.snazwa+'.h');

 save(#13#10#9'icl "'+AnsiString(sama_nazwa)+'.h"');
//end;

 save('');

// Etykiety_zakres($d000,$d40f);

 form1.save_zerop_variables;

 save(#13#10+brkTab+#9'BASIC switch OFF');

 if asm_slideshow then
  save(#9'opt f+')
 else
  if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin

   form1.DepackRES('PRINTF', form1.GetUndoName('printf.obx'));
   form1.DepackRES('VBXE', form1.snazwa+'.vbx');

   save(#9'icl "'+AnsiString(sama_nazwa)+'.vbx"'#13#10);

   save(#9'org $2000'#13#10);
   save(#9'.zpvar'#9'= $f0'#13#10);
   save('detect'#9'DetectCore');
   save(#9'bcs ok');
   save(#9'jsr printf');
   save(#9'dta $9b');
   save(#9'dta c''Core revision < 1.20'',$9b,0'#13#10);
   save(#9'pla');
   save(#9'pla');
   save(#9'rts'#13#10);
   save('ok'#9'rts'#13#10);
   save(#9'.link ''printf.obx'''#13#10);
   save(#9'ini detect'#13#10);

  end else
   save(#9'org $2000\ mva #$ff '+form1.reg_label($d301)+'\ rts\ ini $2000');


if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin

 form1.DepackRES('VBXE', form1.snazwa+'.vbx');

 save(brkTab+#9'VBXE XDLIST, COLORS MAP'#13#10);

 save(#9'org $0600');
 save('vbxe_bank_on');

 save(#9'fxs vbxe_bank FX_MEMB'#9#9';enable VBXE BANK #0 MEM = $4000..$7FFF');
 save(#9'inc vbxe_bank');
 save(#9'rts');
 save('vbxe_bank'#9'dta $80'#13#10);

 save('vbxe_bank_off');
 save(#9'fxs #$00 FX_MEMB'#9#9';disable VBXE BANK #0 MEM = $4000..$7FFF');
 save(#9'rts'#13#10);

 save(#9'ini vbxe_bank_on'#13#10);

 save(#9'org MEMAC_B_WINDOW');
 save('xdlist	equ *');

// save(#9';XDLC');
// save(#9';24 puste linie od góry ekranu ...');
// save(#9'.word   XDLC_RPTL');
// save(#9'.byte'#9'3*8-1');

 save(#9';XDLC');
 save(#9';w³¹czam mapê koloru pokrywaj¹c¹ 240 linii');
 save(#9';jednoczeœnie jest to koniec XDL (XDLC_END)');
 save(#9'.word'#9'XDLC_END|XDLC_RPTL|XDLC_MAPON|XDLC_MAPADR|XDLC_MAPPAR|XDLC_OVATT'#13#10);

 save(#9';XDLC_RPTL');
 save(#9';razem 240 linii z map¹ koloru');
 save(#9'.byte'#9'240-1'#13#10);

 save(#9';XDLC_MAPADR');
 save(#9';adres mapy koloru bezpoœrednio za XDL w pamiêci VBXE');
 save(#9'.long'#9'$4000'#13#10);

 save(#9';krok adresu mapy');

 if Bajt=48 then
  save(#9'.word'#9'42*4'#13#10)
 else
  save(#9'.word'#9+AnsiString(IntToStr(Bajt))+'*4'#13#10);

 save(#9';XDLC_MAPPAR');
 save(#9'.byte'#9'0 ;hscroll mapy');
 save(#9'.byte'#9'0 ;vscroll mapy');
 save(#9'.byte'#9+AnsiString(IntToStr(cmap_cellW))+'-1 ;szerokoœæ pola');
 save(#9'.byte'#9+AnsiString(IntToStr(cmap_cellH))+'-1 ;wysokoœæ pola'#13#10);

 save(#9';XDLC_OVATT');
 case Bajt of
  32: save(#9'.byte 0'#9'; screen 32 bytes');
  40: save(#9'.byte 1'#9'; screen 40 bytes');
  48: save(#9'.byte 2'#9'; screen 48 bytes');
 end;
 save(#9'.byte 0'#13#10);

 save(#9'ini vbxe_bank_on'#13#10#13#10);


 a:=ChangeFileExt(edit4Text, '.cmp');

 save(#9'?l=.len "'+AnsiString(a)+'"');
 save(#9'.rept [?l/16384]+[[?l%16384]<>0]'#13#10);

 save(#9'org MEMAC_B_WINDOW');
 save(#9'ift ?l>=16384');
 save(#9'ins "'+AnsiString(a)+'",#*16384,16384');
 save(#9'els');
 save(#9'ins "'+AnsiString(a)+'",#*16384,?l');
 save(#9'eif'#13#10);
 save(#9'?l-=16384');
 save(#9'ini vbxe_bank_on');
 save(#9'.endr'#13#10);

 save(#9'ini vbxe_bank_off'#13#10);
end;

save(#13#10+brkTab+#9'MAIN PROGRAM');


 if asm_slideshow then
  save(#9'org $0600')
 else
//  if (t_mode(form1.SelectMode.ItemIndex)=m_gedm) and (SpecialStr[___LMSperline].val) then
//   save(#9'org $2010')
//  else
   if NoBadLines then
    save(#9'org $1000')
   else
    save(#9'org $2000');


if UseChar then begin

 save('ant'#9'ANTIC_PROGRAM scr,ant'#13#10);

 if NoBadLines then
  save('scr'#9':2 ins "'+AnsiString(sama_nazwa)+'.scr",0,'+AnsiString(IntToStr(Bajt))+#13#10)
 else begin
  save('scr'#9'ins "'+AnsiString(sama_nazwa)+'.scr"'#13#10);

  k:=0;
  for i := 0 to 29 do
   if gfxMode[i]<>0 then inc(k);

  save(#9'.ds '+AnsiString(IntToStr(30-k))+'*40'#13#10);

 end;



 save(#9'.ALIGN $0400');
 save('fnt'#9'ins "'+AnsiString(sama_nazwa)+'.fnt"'#13#10);
end else begin
 save('scr'#9'ins "'+AnsiString(sama_nazwa)+'.raw"'#13#10);

 save(#9'.ifdef nil_used');
 save('nil'#9':8*'+AnsiString(IntToStr(Bajt))+' brk');
 save(#9'eif'#13#10);

 save(#9'.ALIGN $0400');
 save('ant'#9'ANTIC_PROGRAM scr,ant'#13#10);
 save('fnt'#13#10);
end;

save(#9'ift USESPRITES');
save(#9'.ALIGN $0800');

{ if NoBadLines then
  save(#9'.ds $0300-4')
 else}
  save('pmg'#9'.ds $0300');

 save(#9'ift FADECHR = 0');
 save(#9'SPRITES');
 save(#9'els');
 save(#9'.ds $500');
 save(#9'eif');
 save(#9'eif'#13#10);

save('main');
save(brkTab+#9'init PMG'#13#10);

save(#9'ift USESPRITES');
save(#9'mva >pmg '+form1.reg_label($d407)+#9#9';missiles and players data address');
save(#9'mva #$03 '+form1.reg_label($d01d)+#9#9';enable players and missiles');
save(#9'eif'#13#10);

end;


procedure ObiektyPMG;
var ok: Boolean;
begin

if SpecialStr[___asmRUN].val then
 save(#9'run main')
else
 save(#9'ini main');

save(brkTab+#13#10);
save(#9'opt l-'#13#10);

save('.MACRO'#9'SPRITES');

save_pmg_data(true,true,true,true,true, true);

save('.ENDM'#13#10);

ok:=testPM($000) or testPM($200) or testPM($400) or testPM($600) or testPM($800);

save('USESPRITES = '+AnsiString(IntToStr(ord(ok)))+#13#10);

if t_mode(form1.SelectMode.ItemIndex)=m_dli then begin

 if asm_slideshow then begin

  save('.MACRO'#9'DLINEW');
  save(#9'mva <:1 $200');
  save(#9'ift [>?old_dli]<>[>:1]');
  save(#9'mva >:1 $201');
  save(#9'eif'#13#10);

{  save(#9'lda regA');
  save(#9'ldx regX');
  save(#9'ldy regY');
  save(#9'rti'#13#10);

  save(#9'.def ?old_dli = *');
  save('.ENDM'#13#10);
}
 end else begin

  save('.MACRO'#9'DLINEW');
  save(#9'mva <:1 NMI.dliv');
  save(#9'ift [>?old_dli]<>[>:1]');
  save(#9'mva >:1 NMI.dliv+1');
  save(#9'eif'#13#10);

 end;

	save(#9'ift :2');
	save(#9'lda regA');
	save(#9'eif'#13#10);

	save(#9'ift :3');
	save(#9'ldx regX');
	save(#9'eif'#13#10);

	save(#9'ift :4');
	save(#9'ldy regY');
	save(#9'eif'#13#10);

	save(#9'rti'#13#10);

  save(#9'.def ?old_dli = *');
  save('.ENDM'#13#10);

 end;

end;


function szer_ekran: AnsiString;
var v: byte;    
begin
 Result:='';

{
     %00000000				blank
     %00000001				narrow
     %00000010				standard
     %00000011				wide
     %00000100				missiles
     %00001000				players
     %00010000				lineX1
     %00000000				lineX2
     %00100000				dma
}

 if not(SpecialStr[___ShortLabels].val) then begin

  Result:='@dmactl(';

  case bajt of
   32: Result:=Result+'narrow|dma|lineX1';
   40: Result:=Result+'standard|dma|lineX1';
   48: Result:=Result+'wide|dma|lineX1';
  end;

  if FSpecial.chk_players.Checked then Result:=Result+'|players';
  if FSpecial.chk_missiles.Checked then Result:=Result+'|missiles';

  Result:=Result+')';

 end else begin

  v:=48;

  case bajt of
   32: v:=v or 1;
   40: v:=v or 2;
   48: v:=v or 3;
  end;

  if FSpecial.chk_players.Checked then v:=v or 8;
  if FSpecial.chk_missiles.Checked then v:=v or 4;

  Result := form1.Hex(v, 2);
 end;

end;


procedure TForm1.RemoveUnusedPMGByte;
var k: byte;
    w: word;
begin
   for k:=0 to 255 do begin
    w:=Mis0[k]; if w shr 8>127 then SmaskX[$100+k]:=0;
    w:=Mis1[k]; if w shr 8>127 then SmaskX[$300+k]:=0;
    w:=Mis2[k]; if w shr 8>127 then SmaskX[$500+k]:=0;
    w:=Mis3[k]; if w shr 8>127 then SmaskX[$700+k]:=0;

    w:=Spr0[k]; if w shr 8>127 then SmaskX[$000+k]:=0;
    w:=Spr1[k]; if w shr 8>127 then SmaskX[$200+k]:=0;
    w:=Spr2[k]; if w shr 8>127 then SmaskX[$400+k]:=0;
    w:=Spr3[k]; if w shr 8>127 then SmaskX[$600+k]:=0;
   end;
end;


procedure TForm1.SavePMG_ASM;
var a, i, j: byte;
    zm: string;
begin

 initPMGdata;

 zm:=form1.Savedialog1.FileName;
 zm:=ChangeFileExt(zm, '.asm');

 dane:=FileCreate(zm);

// kasujemy pixle PMG w wierszach z pustymi liniami
 for a:=0 to 29 do
  if gfxMode[a]=0 then
   for i:=0 to 7 do
    for j:=0 to 7 do SmaskX[i shl 8+a shl 3+j]:=0;

 save_pmg_data(true,true,true,true,true, true);

 FileClose(dane);

end;


procedure TForm1.SavePMG_PAS;
var a, i, j: byte;
    zm: string;


procedure x00(comma: Boolean = true);
var i,j: byte;
begin

 for j := 0 to 15 do begin

  eol_:=false; save('    ');

  for i := 0 to 15 do begin
   if i > 0 then save(',');
   save('$00');
  end;

  if comma then save(',');

  eol_:=true; save('');

 end;

 if comma then save('');

end;


procedure xPM(comma: Boolean = true);
var x, y: byte;
begin
// px:=$ff;

 for y:=0 to 15 do begin
  eol_:=false; save('    ');

  for x:=0 to 15 do begin
   if x>0 then save(',');
   save('$' + AnsiString(IntToHex(bufor[x+y*16], 2)));
  end;

  if comma then save(',');

  eol_:=true; save('');
 end;

 if comma then save('');

end;



procedure save_pmg_data;
var y0, y1, y2, y3, i: byte;
begin

// tworzenia danych pociskow
for i:=0 to 255 do begin
 y0:=(SmaskX[$100+i] and $c0) shr 6;
 y1:=(SmaskX[$300+i] and $c0) shr 4;
 y2:=(SmaskX[$500+i] and $c0) shr 2;
 y3:=SmaskX[$700+i] and $c0;

 SmaskX[$800+i]:=y0 or y1 or y2 or y3;
end;

// jesli grafika PMG jest pusta, nie zawiera zadnych ksztaltow
// i jesli nie ma zadnych odwolan do takiego ducha wowczas nie zapisujemy
// jego danych


 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$800],bufor[8],256-16);

 save('    pm_array: array [0..1279] of byte =');
 save('    (');

 save('    // missiles');

 if testPM($800) then
   xPM
 else
   x00;


 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$000],bufor[8],256-16);

 save('    // player0');

 if testPM($000) then
   xPM
 else
   x00;


 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$200],bufor[8],256-16);

 save('    // player1');

 if testPM($200) then
   xPM
 else
   x00;


 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$400],bufor[8],256-16);

 save('    // player2');

 if testPM($400) then
   xPM
 else
   x00;


 fillchar(bufor,sizeof(bufor),0);
 move(SmaskX[$600],bufor[8],256-16);

 save('    // player3');

 if testPM($600) then
   xPM(false)
 else
   x00(false);

 save('    );');

end;



begin

 initPMGdata;

 zm:=form1.Savedialog1.FileName;
 zm:=ChangeFileExt(zm, '.pas');

 dane:=FileCreate(zm);

// kasujemy pixle PMG w wierszach z pustymi liniami
 for a:=0 to 29 do
  if gfxMode[a]=0 then
   for i:=0 to 7 do
    for j:=0 to 7 do SmaskX[i shl 8+a shl 3+j]:=0;

 save_pmg_data;

 FileClose(dane);

 form1.showMIC; cnv;

end;


procedure czytaj_listing;
(*----------------------------------------------------------------------------*)
(* czytamy listing z programem i wypelniamy tablice CHECK_LIST                *)
(* dodatkowo analizujemy bitmape na wystapienia kolorow w linii               *)
(* i wypelniamy CHECK_BMP                                                     *)
(*----------------------------------------------------------------------------*)
var src: TextFile;
    zm, zm2: string;
    skp, skp2: Boolean;
    i: byte;
    x, y: integer;
    c, v, a: byte;
begin

SetLength(check_list,1);

assignfile(src, form1.GetUndoName('asm$$$.$$$'));
 FileMode:=0;
 reset(src);

for i:=0 to 239 do begin

str(i,zm);

zm:='line='+zm; zm2:='';

skp:=False; skp2:=true;

if changes[i]>0 then begin

 FileMode:=0;
 reset(src);
 while not eof(src) do begin
  readln(src, zm2);

  if (pos('line',zm2)>0) or (pos('jmp',zm2)>0) or (pos('--',zm2)>0) or
     (pos('rti',zm2)>0) or (pos('<',zm2)>0) or (pos('XXX',zm2)>0) or
     (pos('mwa',zm2)>0) or (pos('DLINEW',zm2)>0) then skp:=false;

  if (pos(zm,zm2)>0) and skp2 then begin skp:=true; skp2:=false; end;

  if skp then begin

   if pos('st',zm2)>0 then delete(zm2,pos('st',zm2),4);

   if pos('lda ',zm2)<1 then begin

//    if (pos('hpos',zm2)>0) or (pos('colpm',zm2)>0) or
//       (pos('sizep',zm2)>0) or (pos('color',zm2)>0) then begin

     x:=High(check_list);

     check_list[x].lin:=i;
     check_list[x].nam:=AnsiString(zm2);

     SetLength(check_list,x+2);
//    end;

   end;

  end;

 end;

end;

end;

closefile(src);

// sprawdzamy jakie kolory sa uzyte w bitmapie

for y:=0 to Wysokosc-1 do begin

 check_bmp[y].col[0]:=false;
 check_bmp[y].col[1]:=false;
 check_bmp[y].col[2]:=false;
 check_bmp[y].col[3]:=false;
 check_bmp[y].col[4]:=false;

 for x:=0 to Bajt-1 do begin
  c:=tab [ form1.Sofs(x,tmul48[y]) ];

  v:=invers [ form1.Sofs(x,tmul48[y shr 3]) ];

  for i:=0 to 3 do begin
   a:=c and 3;
   if (v>$7f) and (a=3) then a:=4;
   check_bmp[y].col[a]:=true;
   c:=c shr 2;
  end;

 end;

end;

end;


procedure Analyzing;
var zm, zm2, zm3: string;
    ListItem: TListItem;
    i, war, err, tmp1: integer;
    skp: Boolean;
    oldname: string;
begin

oldname:=current_filename;
current_filename:=form1.GetUndoName('$$$check$$$.g2f');
form1.pliki_danych(current_filename);
form1.SaveDialog1.FileName:=current_filename;


skp:=true; AsmError:=true;
if (t_mode(form1.SelectMode.ItemIndex)=m_gedp) and (Bajt=48) then skp:=false;

if skp then begin
 FCheck.ListView1.Clear;

// jesli na grafice to usun znaki z tablicy
if not(UseChar) then form1.ClrTable;

eol_:=true; SaveAll; form1.SaveAsmDLI; war:=0; err:=0;

// limit zmian dla znakow i grafiki
i:=4; if not(UseChar) and (Bajt=40) then i:=3;

if t_mode(form1.SelectMode.ItemIndex)=m_dli then
 case Bajt of
  32: if Pixel=2 then i:=6 else i:=4;
  40: if Pixel=2 then i:=4 else i:=3;
  48: i:=1;// if Pixel=2 then i:=3 else i:=1;
 end;

FCheck.lLimit.Caption:=format('Limit: %d', [ i ]);

check_limit:=i;

with FCheck.ListView1 do begin
 for tmp1:=0 to Wysokosc-1 do begin
  str(Changes[tmp1], zm2); if zm2='0' then zm2:='';
  str(tmp1, zm); zm3:='OK';

 case tmp1 of
     0..9: zm:=' 00'+zm;
   10..99: zm:=' 0'+zm;
 100..300: zm:=' '+zm;
 end;

 if t_mode(form1.SelectMode.ItemIndex)=m_dli  then begin

  if Changes[tmp1]=i+1 then begin inc(war); zm3:='WARNING' end;
  if Changes[tmp1]>i+1 then begin inc(err); zm3:='ERROR' end;

  if fox1 then
   if tmp1 and 7 in [3,7] then begin

    if Changes[tmp1]>1 then begin
     inc(err); zm3:='ERROR'
    end else
    if (Changes[tmp1-1]>0) or (Changes[tmp1-2]>0) then begin      // jesli dwie poprzedzajace linie maja zmiany

     if (Changes[tmp1-3]>=i+1) or (Changes[tmp1-2]=i+1) or (Changes[tmp1-1]=i+1) then begin
      inc(err); zm3:='ERROR L'+IntToStr(tmp1-3);
     end;

     if ((Changes[tmp1]>0) or (Changes[tmp1-1]>0)) and ((Changes[tmp1-3]>=3) or (Changes[tmp1-2]>=3) or (Changes[tmp1-1]>=3)) then begin
      inc(err); zm3:='ERROR L';

      if Changes[tmp1-3]>=3 then zm3:=zm3+IntToStr(tmp1-3) else
       if Changes[tmp1-2]>=3 then zm3:=zm3+IntToStr(tmp1-2) else
        if Changes[tmp1-1]>=3 then zm3:=zm3+IntToStr(tmp1-1);

     end;

    end;

   end;

  if Changes[tmp1]>=i+2 then begin
   if zm3='ERROR' then dec(err);
   inc(err); zm3:='!!! ERROR !!!'
  end;

 end else if Changes[tmp1]>i then begin inc(err); zm3:='!!! ERROR !!!' end;

  ListItem := Items.Add;
  ListItem.Caption := zm;
  ListItem.SubItems.Add(zm2); ListItem.SubItems.Add(zm3);
 end;

end;

if err>0 then AsmError:=false;

FCheck.lWarnings.Caption:=format('Warnings: %d', [ war ]);
FCheck.lErrors.Caption:=format('Errors: %d', [ err ]);

czytaj_listing;

end else Application.MessageBox('GED+ works only in Pixel=32 and Pixel=40 mode','Asm GED+',MB_ICONEXCLAMATION);

current_filename:=oldname;
form1.pliki_danych(current_filename);
form1.SaveDialog1.FileName:=current_filename;
end;


function FadeFx: Boolean;
begin

 Result := SpecialStr[___FadeDLIBOX].val or SpecialStr[___FadeDLIRND].val or SpecialStr[___FadeDLI_LR].val or SpecialStr[___FadeDLI_Plasma].val;
  
end;


procedure TForm1.SaveAsmDLI;
var pr, m: byte;
    i, j, a, new_dli, v, _x: integer;
    zm, _dli, tx: AnsiString;
    src, plik: TextFile;
    test, opty, dli_start, dli_begin, lms_used, ra, rx, ry, savedli: Boolean;
    tchg: tab_byte256;
    dliprg: array of AnsiString;
begin

if gate>0 then begin

ra:=false;
rx:=false;
ry:=false;

//Analyzing;

//if not(AsmError) then Application.MessageBox('Only 3..4 changes allowed per line'+#13#13+'use OPTIONS -> CHECK to find errors','Asm GED+',MB_ICONEXCLAMATION);

move(Smask,SmaskX,$800);

// kasujemy pixle PMG w wierszach z pustymi liniami
for a:=0 to 29 do
 if gfxMode[a]=0 then
  for i:=0 to 7 do
   for j:=0 to 7 do SmaskX[i shl 8+a shl 3+j]:=0;


pupa:=false; eol_:=true; mnemo:=0; SetLength(kosz,1);
SaveVBL;
pupa:=false; eol_:=true; mnemo:=0; SetLength(kosz,1);


fillchar(wsyncTab,sizeof(wsyncTab), 0);
fillchar(bufor,sizeof(bufor),0);

fillchar(changes,sizeof(changes), 0);

SetLength(tval,1); SetLength(tadr,1);

dane:=FileCreate(GetUndoName('asm$$$.$$$'));

save('/***************************************/');
save('/*  Use MADS http://mads.atari8.info/  */');

if t_video(form1.SelectVideo.ItemIndex)=vbxe then
 save('/*  Mode: VBXE                         */')
else
 save('/*  Mode: DLI (char mode)              */');

save('/***************************************/');

Etykiety;

if (t_video(form1.SelectVideo.ItemIndex)=vgtia) and (SpecialStr[___FadeDLI].val) and SpecialStr[___FadeDLICOLORS].val then begin
 save(#9'ift CHANGES'#9#9';if label CHANGES defined');
 save(#9'jsr save_color'#9#9';then save all colors and set value 0 for all colors');
 save(#9'eif'#13#10);
end;


if asm_slideshow then begin

 save(#9'lda:cmp:req cloc'#9';wait 1 frame');
 save(#9'mwa	#DLI.dli_start'#9'$200');
 save(#9'mwa	#nmi'#9#9'$202'#13#10);

end else begin

 save(#9'lda:cmp:req $14'#9#9';wait 1 frame'#13#10);

 save(#9'sei'#9#9#9';stop IRQ interrupts');
 save(#9'mva #$00 '+form1.reg_label($d40e)+#9#9';stop NMI interrupts');
 save(#9'sta '+form1.reg_label($d400));
 save(#9'mva #$fe '+form1.reg_label($d301)+#9#9';switch off ROM to get 16k more ram'#13#10);

 save(#9'mwa #NMI $fffa'#9#9';new NMI handler'#13#10);

 if SpecialStr[___FadeDLI].val and FadeFx then
  save(#9'.ifdef FADE_CHARS\ jsr fade_chars.init\ eif'#13#10);

 if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin

  save(#9'lda #$00');
  save(#9'fxsa FX_XDL_ADR0'#9#9'; XDLIST PROGRAM ADDRES = $000000');
  save(#9'fxsa FX_XDL_ADR1');
  save(#9'fxsa FX_XDL_ADR2'#13#10);

  save(#9'lda #VC_XDL_ENABLED|VC_XCOLOR');
  save(#9'fxsa FX_VIDEO_CONTROL'#13#10);
 end;

 if (t_mode(form1.SelectMode.ItemIndex) in [m_gedp,m_dli, m_piccolo]) and (gfxMode[29] in [1,4]) then save(#9'mva #1 vscrol'#13#10);

// save(#9'mwa #ant '+form1.reg_label($d402)+#9#9';ANTIC address program');
// save(#9'lda:rne '+form1.reg_label($d40b)+#13#10);

 save(#9'mva #$c0 '+form1.reg_label($d40e)+#9#9';switch on NMI+DLI again'#13#10);

end;


if t_video(form1.SelectVideo.ItemIndex)=vgtia then begin

 save(#9'ift CHANGES'#9#9';if label CHANGES defined'#13#10);

 if SpecialStr[___FadeDLI].val then begin

  if SpecialStr[___FadeDLICOLORS].val then
   save(#9'jsr fade_in'#9#9';fade in colors'#13#10);

  if FadeFx then
   save(#9'.ifdef FADE_CHARS\ lda #1\ jsr fade_chars\ eif'#13#10);

 end;

 save('_lp'#9'lda '+reg_labelR($d010)+#9#9'; FIRE #0');
 save(#9'beq stop'#13#10);

 save(#9'lda '+reg_labelR($d011)+#9#9'; FIRE #1');
 save(#9'beq stop'#13#10);

 save(#9'lda '+form1.reg_label($d01f)+#9#9'; START');
 save(#9'and #1');
 save(#9'beq stop'#13#10);

 save(#9'lda '+form1.reg_label($d20f));
 save(#9'and #$04');
 save(#9'bne _lp'#9#9#9';wait to press any key; here you can put any own routine'#13#10);

 if SpecialStr[___FadeDLI].val then begin

  if SpecialStr[___FadeDLICOLORS].val then
   save(#9'jsr fade_out'#9#9';fade out colors'#13#10);

 end;


 save(#9'els'#13#10);

 save('null'#9'jmp DLI.dli1'#9#9';CPU is busy here, so no more routines allowed'#13#10);

 save(#9'eif'#13#10#13#10);
end else
 save(#9'jmp *'#9#9';CPU is busy here, so no more routines allowed'#13#10);


  if asm_slideshow then begin

   save('stop'#9'lda:cmp:req cloc');
   save(#9'mva #$00'#9+form1.reg_label($d400)+#13#10);
   save(#9'mwa old_dli'#9'$200');
   save(#9'mwa old_nmi'#9'$202');
   save(#9'rts'#13#10);

  end else begin

  save('stop');

  if FadeFx then
   save(#9'.ifdef FADE_CHARS\ lda #0\ jsr fade_chars\ eif'#13#10);

  save(#9'mva #$00 '+form1.reg_label($d01d)+#9#9';PMG disabled');
  save(#9'tax');
  save(#9'sta:rne '+form1.reg_label($d000)+',x+'#13#10);

  save(#9'mva #$ff '+form1.reg_label($d301)+#9#9';ROM switch on');
  save(#9'mva #$40 '+form1.reg_label($d40e)+#9#9';only NMI interrupts, DLI disabled');
  save(#9'cli'#9#9#9';IRQ enabled'#13#10);

  save(#9'rts'#9#9#9';return to ... DOS'#13#10);
 end;


save(brkTab+#9'DLI PROGRAM'#13#10);

save('.local'#9'DLI'#13#10);

save(#9'?old_dli = *'#13#10);

// if form1.SelectVideo.ItemIndex=0 then begin

  save(#9'ift !CHANGES'#13#10);

  save('dli1'#9'lda '+reg_labelR($d010)+#9#9'; FIRE #0');
  save(#9'beq stop'#13#10);

  save(#9'lda '+reg_labelR($d011)+#9#9'; FIRE #1');
  save(#9'beq stop'#13#10);

  save(#9'lda '+form1.reg_label($d01f)+#9#9'; START');
  save(#9'and #1');
  save(#9'beq stop'#13#10);

  save(#9'lda '+form1.reg_label($d20f));
  save(#9'and #$04');
	save(#9'beq stop'#13#10);

  save(#9'lda '+form1.reg_label($d40b));
  save(#9'cmp #$02');
  save(#9'bne dli1'#13#10);

  save(#9':3 sta '+form1.reg_label($d40a)+#13#10);

// end;


tmp2:=0; dli_nr:=2; wsync:=1;

 for _x:=0 to Wysokosc-1 do begin

  px := _x;

//  pr:=ObliczPiorytet(px);
//  gtia:=SetGTIAValue(gfxMode[px shr 3]);

  gtia:=rKolor[px, 9] and $c0;
  pr:=rKolor[px, 9] and $3f;

  if UseChar then
   if fox1 then begin

    if (px mod 4=0) then begin
     tmp[$409]:=-100;
     sav(table[px shr 3],$d409);
    end;

   end else
    sav(table[px shr 3],$d409);

   tmp1:=-200;
   if px>0 then begin inc(wsync); tmp2:=0; end;

   SaveChange(pr);
 end;


if changes[0]>0 then dec(changes[0]);


opty:=true;
for i:=0 to 7 do
 if wsyncTab[i]<>0 then opty:=false;

 if dli_nr>2 then
  save(#9'jmp NMI.quit')
 else
  save(';XXX');


save('');

save('.endl'#13#10);

save(brkTab+#13#10);

if dli_nr>2 then _dli:='DLI.dli2' else _dli:='DLI.dli1';

 if opty then begin
  _dli:='DLI.dli_start';

  save('CHANGES = '+AnsiString(IntToStr(ord(form1.SelectVideo.ItemIndex=0))));

  if SpecialStr[___FadeDLI].val then begin

   if SpecialStr[___FadeDLIBOX].val then save('FADECHR'#9'= 1') else
    if SpecialStr[___FadeDLIRND].val then save('FADECHR'#9'= 2') else
     if SpecialStr[___FadeDLI_LR].val then save('FADECHR'#9'= 3') else
      if SpecialStr[___FadeDLI_Plasma].val then save('FADECHR'#9'= 4') else
       save('FADECHR'#9'= 0');

  end else
   save('FADECHR'#9'= 0');

  save('');
 end else
  save('CHANGES'#9'= 0'#13#10'FADECHR'#9'= 0'#13#10);

save('SCHR'#9'= '+AnsiString(IntToStr(fade_special_char))+#13#10);

save(brkTab+#13#10);

save('.proc'#9'NMI'#13#10);

SzerokoscObrazu;

zm:=szer_ekran;


if asm_slideshow then begin

 save(#9'mwa #ant '+form1.reg_label($d402)+#9#9';ANTIC address program');
 save(#9'mva #'+zm+' '+form1.reg_label($d400)+#9';set new screen width'#13#10);

end else begin

{ save(#9'sta regA');
 save(#9'stx regX');
 save(#9'sty regY'+#13#10);      }

 save(#9'bit '+form1.reg_label($d40f));
 save(#9'bpl VBL'#13#10);

 save(#9'jmp '+_dli);
 save('dliv'#9'equ *-2'#13#10);

 save('VBL');

 save(#9'sta regA');
 save(#9'stx regX');
 save(#9'sty regY'#13#10);      

 save(#9'sta '+form1.reg_label($d40f)+#9#9';reset NMI flag'#13#10);

 save(#9'mwa #ant '+form1.reg_label($d402)+#9#9';ANTIC address program'#13#10);
 save(#9'mva #'+zm+' '+form1.reg_label($d400)+#9';set new screen width'#13#10);

 save(#9'inc cloc'#9#9';little timer'#13#10);

end;

save('; Initial values'#13#10);

// przepisz VBL do pliku wynikowego
assignfile(plik,GetUndoName('temp.$$$')); FileMode:=0; reset(plik);
while not eof(plik) do begin readln(plik,zm); save(zm); end;
closefile(plik);

save('');


if asm_slideshow then begin

 save(#9'mwa #DLI.dli_start $200'#9';set the first address of DLI interrupt');

 if not(opty) then
  save(#9'mwa #DLI.dli1 null+1'#9';synchronization for the first screen line');

 save(#9'plr');
 save(#9'rti'#13#10);

end else begin

 if (dli_nr>2) or opty then
  save(#9'mwa #'+_dli+' dliv'#9';set the first address of DLI interrupt');

 if not(opty) then
  save(#9'mwa #DLI.dli1 null+1'#9';synchronization for the first screen line');

 save(#13#10';this area is for yours routines'#13#10);

 save('quit');

 save(#9'lda regA');
 save(#9'ldx regX');
 save(#9'ldy regY');
 save(#9'rti'#13#10);

end;

 save('.endp'#13#10);

 save(brkTab);


move(bufor,tchg,sizeof(tchg));

if (t_video(form1.SelectVideo.ItemIndex)=vgtia) and SpecialStr[___FadeDLI].val then begin
 save(#9'ift CHANGES');
 save(#9#9'ift FADECHR = 0');
 {if opty then }save(#9#9'icl '''+AnsiString(sama_nazwa)+'.fad''');

 if FadeFx then begin
  save(#9#9'els');

  save (#9#9'icl '''+AnsiString(sama_nazwa)+'.hcl''');
  save (#9#9'icl '''+AnsiString(sama_nazwa)+'.pmf''');
 end;

 save(#9#9'eif');

 save(#9'eif'#13#10);
end;

ObiektyPMG;

FileClose(dane);


assignfile(src,GetUndoName('asm$$$.$$$')); FileMode:=0; reset(src);
assignfile(plik,GetUndoName('tmp$$$.$$$')); rewrite(plik);

tmp1:=0; a:=0;
dli_start:=false; _dli:='DLI.dli1'; new_dli:=dli_nr+1;

while not eof(src) do begin
 readln(src,zm);

 i:=AnsiPos(AnsiString(';XXX'),zm);
 if i>0 then begin

  if opty then begin

   if dli_nr>2 then begin
    _dli:='DLI.dli2';
    writeln(plik,#9'DLINEW ',_dli);
   end else begin

    if asm_slideshow then begin

     writeln(plik,#9'lda regA');
     writeln(plik,#9'ldx regX');
     writeln(plik,#9'ldy regY');
     writeln(plik,#9'rti'#13#10);

    end else
     writeln(plik,#9'jmp NMI.quit');

   end;

   if not(dli_start) then begin
    writeln(plik,#9'eif'#13#10);

    writeln(plik,'dli_start');
    dli_start:=true;
   end;

  end else begin
   writeln(plik,#9'mwa #null null+1');
   writeln(plik,#9'jmp null'#13#10);

   writeln(plik,#9'eif');

   writeln(plik,'dli_start');
   opty:=true;
   dli_start:=true;
  end;

  zm:='';
 end;

 i:=AnsiPos(AnsiString('dli'),zm);
 if i=1 then begin
  while (i<=length(zm)) and not(zm[i] in [#0,' ']) do inc(i);
  _dli:=copy(zm,1,i);
 end;

 i:=AnsiPos(AnsiString(';line='),zm);

 test:=false;
 if i>0 then begin
  tx:=copy(zm,i,length(zm)-i+1);
  i:=AnsiPos(AnsiString('='),tx); tx:=copy(tx,i+1,length(zm)-i); a:=StrToInt(string(tx));
  test:=true;
 end;

 if test then
  if wsyncTab[a]<>0 then begin
   for i:=0 to wsyncTab[a]-1 do begin
    tx:=kosz[tmp1]; writeln(plik,tx); inc(tmp1);
   end;

   test:=false;
  end;

 if test and opty then begin
  for i:=a to 239 do
   if wsyncTab[i]<>0 then Break;

  v:=(i-0) shr 3;
  j:=((i-0) and $f8)-a;  dec(j);

 // CATABALL nie wyrabial sie z przerwaniem DLI gdy
 // przerwa pomiedzy wywolaniem przerwania DLI byla 2 liniowa

  if (j>=0) and (wsyncTab[v shl 3-1]=0) and (wsyncTab[v shl 3-2]=0) then begin
   for i:=0 to j-1 do readln(src);

    tchg[v]:=$ff;

    inc(new_dli); _dli:='dli'+AnsiString(IntToStr(new_dli));

    writeln(plik,#9'DLINEW ',_dli,#13#10);

    if not(dli_start) then begin
     writeln(plik,#9'eif');

     writeln(plik,'dli_start');
     dli_start:=true;
    end;

    writeln(plik,_dli);

    zm:='';
  end;

 end;

 writeln(plik,zm);
end;


flush(src);
flush(plik);

closefile(src); closefile(plik);


// optymalizacja dla DLINEW, sprawdzamy które rejestry u¿ywa DLI

assignfile(src,GetUndoName('tmp$$$.$$$')); FileMode:=0; reset(src);
assignfile(plik,snazwa+'.asm'); rewrite(plik);

dli_start:=false;
dli_begin:=false;

savedli:=true;

SetLength(dliprg, 1);

while not eof(src) do begin
 readln(src, zm);


 if AnsiPos(AnsiString('ANTIC_PROGRAM'), zm)>0 then begin

 lms_used:=false;

 write(plik,'ant'#9'dta ');

if Fox1 then begin

 for v:=0 to 59-1 do begin
  m:=0;

  if v<>59-1 then
  if tchg[(v+1) shr 1]>0 then inc(m,$80);

  case gfxMode[v shr 1] of
     0: inc(m,$70);
   1,4: inc(m,2);
     2: inc(m,4);
  end;

  if v<>59-1 then
  if v and 1=0 then m:=m or $20;

  if not(lms_used) and (m and 7>0) then begin
   write(plik, form1.hex(m+$40,2),',a(scr)');
   lms_used:=true; m:=0;
  end;

  if m>0 then write(plik, form1.hex(m,2));

  if v mod 16=0 then begin
   writeln(plik); write(plik,#9'dta ');
  end else
   if v<>59-1 then write(plik,',');

 end;

end else begin

 for v:=0 to 29 do begin
  m:=0;
  if tchg[v+1]>0 then inc(m,$80);

  case gfxMode[v] of
     0: inc(m,$70);
   1,4: begin
         inc(m,2);
         if v=29 then inc(m, $20);        // scroll pionowy
        end;
     2: inc(m,4);
  end;

  if not(lms_used) and (m and 7>0) then begin
   write(plik, form1.hex(m+$40,2),',a(scr)');
   lms_used:=true; m:=0;
  end;

  if m>0 then write(plik, form1.hex(m,2));

  if v mod 16=0 then begin
   writeln(plik); write(plik,#9'dta ');
  end else
   if v<>29 then write(plik,',');

 end;

end;

 write(plik,#13#10#9'dta $41,a(ant)');
 zm:='';
 end;


 if AnsiPos(AnsiString('DLI PROGRAM'), zm)>0 then dli_begin:=true;    // DLI PROGRAM

 if dli_begin and (AnsiPos(AnsiString('dli_start'), zm)>0) then dli_start:=true;

 if dli_start then begin

  if AnsiPos(AnsiString('dli'), zm)=1 then begin
   ra:=false;
   rx:=false;
   ry:=false;

   SetLength(dliprg, 1);

   writeln(plik);
  end else begin

   i:=High(dliprg);
   dliprg[i]:=zm;
   SetLength(dliprg, i+2);

   savedli:=false;
  end;


  if AnsiPos(AnsiString('lda'), zm)>0 then ra:=true;
  if AnsiPos(AnsiString('ldx'), zm)>0 then rx:=true;
  if AnsiPos(AnsiString('ldy'), zm)>0 then ry:=true;


  if AnsiPos(AnsiString('DLINEW'), zm)>0 then begin

   savedli:=true;

   if ra then writeln(plik, #9'sta regA');
   if rx then writeln(plik, #9'stx regX');
   if ry then writeln(plik, #9'sty regY');
//   writeln(plik);

   for i:=0 to High(dliprg)-2 do
    writeln(plik, dliprg[i]);

   zm:=zm+' '+AnsiString(inttostr(ord(ra)))+' '+AnsiString(inttostr(ord(rx)))+' '+AnsiString(inttostr(ord(ry)));
  end;


  if AnsiPos(AnsiString('.proc'),zm)>0 then begin      // brak przerwania DLI
   savedli:=true;
   dli_start:=false;
   dli_begin:=false;

   for i:=0 to High(dliprg)-2 do
    writeln(plik, dliprg[i]);

  end;


  if AnsiPos(AnsiString('NMI.'), zm)>0 then begin
   savedli:=true;
   dli_start:=false;
   dli_begin:=false;

   if ra then writeln(plik, #9'sta regA');
   if rx then writeln(plik, #9'stx regX');
   if ry then writeln(plik, #9'sty regY');
//   writeln(plik);

   for i:=0 to High(dliprg)-2 do
    writeln(plik, dliprg[i]);

   writeln(plik);

   if ra then writeln(plik, #9'lda regA');
   if rx then writeln(plik, #9'ldx regX');
   if ry then writeln(plik, #9'ldy regY');
   write(plik, #9'rti');
   zm:='';
  end;

 end;

 if savedli then writeln(plik, zm);
 savedli:=true;
end;


flush(src);
flush(plik);

closefile(src); closefile(plik);

//if opty then Application.MessageBox('FAD file disabled','Save ASM',MB_ICONINFORMATION);

end;

end;


procedure TForm1.SavePasFull;
var pr, m: byte;
    i, j, a, new_dli, v, _x: integer;
    zm, _dli, tx: AnsiString;
    src, plik: TextFile;
    test, opty, dli_start, dli_begin, lms_used, ra, rx, ry, savedli: Boolean;
    tchg: tab_byte256;
    dliprg: array of AnsiString;
begin

if gate>0 then begin

ra:=false;
rx:=false;
ry:=false;

//Analyzing;

//if not(AsmError) then Application.MessageBox('Only 3..4 changes allowed per line'+#13#13+'use OPTIONS -> CHECK to find errors','Asm GED+',MB_ICONEXCLAMATION);

move(Smask,SmaskX,$800);

// kasujemy pixle PMG w wierszach z pustymi liniami
for a:=0 to 29 do
 if gfxMode[a]=0 then
  for i:=0 to 7 do
   for j:=0 to 7 do SmaskX[i shl 8+a shl 3+j]:=0;


pupa:=false; eol_:=true; mnemo:=0; SetLength(kosz,1);
SaveVBL;
pupa:=false; eol_:=true; mnemo:=0; SetLength(kosz,1);


fillchar(wsyncTab,sizeof(wsyncTab), 0);
fillchar(bufor,sizeof(bufor),0);

fillchar(changes,sizeof(changes), 0);

SetLength(tval,1); SetLength(tadr,1);

dane:=FileCreate(GetUndoName('asm$$$.$$$'));

save('/***************************************/');
save('/*  Use MADS http://mads.atari8.info/  */');

if t_video(form1.SelectVideo.ItemIndex)=vbxe then
 save('/*  Mode: VBXE                         */')
else
 save('/*  Mode: DLI (char mode)              */');

save('/***************************************/');

Etykiety;

if (t_video(form1.SelectVideo.ItemIndex)=vgtia) and (SpecialStr[___FadeDLI].val) and SpecialStr[___FadeDLICOLORS].val then begin
 save(#9'ift CHANGES'#9#9';if label CHANGES defined');
 save(#9'jsr save_color'#9#9';then save all colors and set value 0 for all colors');
 save(#9'eif'#13#10);
end;


if asm_slideshow then begin

 save(#9'lda:cmp:req cloc'#9';wait 1 frame');
 save(#9'mwa	#DLI.dli_start'#9'$200');
 save(#9'mwa	#nmi'#9#9'$202'#13#10);

end else begin

 save(#9'lda:cmp:req $14'#9#9';wait 1 frame'#13#10);

 save(#9'sei'#9#9#9';stop IRQ interrupts');
 save(#9'mva #$00 '+form1.reg_label($d40e)+#9#9';stop NMI interrupts');
 save(#9'sta '+form1.reg_label($d400));
 save(#9'mva #$fe '+form1.reg_label($d301)+#9#9';switch off ROM to get 16k more ram'#13#10);

 save(#9'mwa #NMI $fffa'#9#9';new NMI handler'#13#10);

 if SpecialStr[___FadeDLI].val and FadeFx then
  save(#9'.ifdef FADE_CHARS\ jsr fade_chars.init\ eif'#13#10);

 if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin

  save(#9'lda #$00');
  save(#9'fxsa FX_XDL_ADR0'#9#9'; XDLIST PROGRAM ADDRES = $000000');
  save(#9'fxsa FX_XDL_ADR1');
  save(#9'fxsa FX_XDL_ADR2'#13#10);

  save(#9'lda #VC_XDL_ENABLED|VC_XCOLOR');
  save(#9'fxsa FX_VIDEO_CONTROL'#13#10);
 end;

 if (t_mode(form1.SelectMode.ItemIndex) in [m_gedp,m_dli, m_piccolo]) and (gfxMode[29] in [1,4]) then save(#9'mva #1 vscrol'#13#10);

// save(#9'mwa #ant '+form1.reg_label($d402)+#9#9';ANTIC address program');
// save(#9'lda:rne '+form1.reg_label($d40b)+#13#10);

 save(#9'mva #$c0 '+form1.reg_label($d40e)+#9#9';switch on NMI+DLI again'#13#10);

end;


if t_video(form1.SelectVideo.ItemIndex)=vgtia then begin

 save(#9'ift CHANGES'#9#9';if label CHANGES defined'#13#10);

 if SpecialStr[___FadeDLI].val then begin

  if SpecialStr[___FadeDLICOLORS].val then
   save(#9'jsr fade_in'#9#9';fade in colors'#13#10);

  if FadeFx then
   save(#9'.ifdef FADE_CHARS\ lda #1\ jsr fade_chars\ eif'#13#10);

 end;

 save('_lp'#9'lda '+reg_labelR($d010)+#9#9'; FIRE #0');
 save(#9'beq stop'#13#10);

 save(#9'lda '+reg_labelR($d011)+#9#9'; FIRE #1');
 save(#9'beq stop'#13#10);

 save(#9'lda '+form1.reg_label($d01f)+#9#9'; START');
 save(#9'and #1');
 save(#9'beq stop'#13#10);

 save(#9'lda '+form1.reg_label($d20f));
 save(#9'and #$04');
 save(#9'bne _lp'#9#9#9';wait to press any key; here you can put any own routine'#13#10);

 if SpecialStr[___FadeDLI].val then begin

  if SpecialStr[___FadeDLICOLORS].val then
   save(#9'jsr fade_out'#9#9';fade out colors'#13#10);

 end;


 save(#9'els'#13#10);

 save('null'#9'jmp DLI.dli1'#9#9';CPU is busy here, so no more routines allowed'#13#10);

 save(#9'eif'#13#10#13#10);
end else
 save(#9'jmp *'#9#9';CPU is busy here, so no more routines allowed'#13#10);


  if asm_slideshow then begin

   save('stop'#9'lda:cmp:req cloc');
   save(#9'mva #$00'#9+form1.reg_label($d400)+#13#10);
   save(#9'mwa old_dli'#9'$200');
   save(#9'mwa old_nmi'#9'$202');
   save(#9'rts'#13#10);

  end else begin

  save('stop');

  if FadeFx then
   save(#9'.ifdef FADE_CHARS\ lda #0\ jsr fade_chars\ eif'#13#10);

  save(#9'mva #$00 '+form1.reg_label($d01d)+#9#9';PMG disabled');
  save(#9'tax');
  save(#9'sta:rne '+form1.reg_label($d000)+',x+'#13#10);

  save(#9'mva #$ff '+form1.reg_label($d301)+#9#9';ROM switch on');
  save(#9'mva #$40 '+form1.reg_label($d40e)+#9#9';only NMI interrupts, DLI disabled');
  save(#9'cli'#9#9#9';IRQ enabled'#13#10);

  save(#9'rts'#9#9#9';return to ... DOS'#13#10);
 end;


save(brkTab+#9'DLI PROGRAM'#13#10);

save('.local'#9'DLI'#13#10);

save(#9'?old_dli = *'#13#10);

// if form1.SelectVideo.ItemIndex=0 then begin

  save(#9'ift !CHANGES'#13#10);

  save('dli1'#9'lda '+reg_labelR($d010)+#9#9'; FIRE #0');
  save(#9'beq stop'#13#10);

  save(#9'lda '+reg_labelR($d011)+#9#9'; FIRE #1');
  save(#9'beq stop'#13#10);

  save(#9'lda '+form1.reg_label($d01f)+#9#9'; START');
  save(#9'and #1');
  save(#9'beq stop'#13#10);

  save(#9'lda '+form1.reg_label($d20f));
  save(#9'and #$04');
	save(#9'beq stop'#13#10);

  save(#9'lda '+form1.reg_label($d40b));
  save(#9'cmp #$02');
  save(#9'bne dli1'#13#10);

  save(#9':3 sta '+form1.reg_label($d40a)+#13#10);

// end;


tmp2:=0; dli_nr:=2; wsync:=1;

 for _x:=0 to Wysokosc-1 do begin

  px := _x;

//  pr:=ObliczPiorytet(px);
//  gtia:=SetGTIAValue(gfxMode[px shr 3]);

  gtia:=rKolor[px, 9] and $c0;
  pr:=rKolor[px, 9] and $3f;

  if UseChar then
   if fox1 then begin

    if (px mod 4=0) then begin
     tmp[$409]:=-100;
     sav(table[px shr 3],$d409);
    end;

   end else
    sav(table[px shr 3],$d409);

   tmp1:=-200;
   if px>0 then begin inc(wsync); tmp2:=0; end;

   SaveChange(pr);
 end;


if changes[0]>0 then dec(changes[0]);


opty:=true;
for i:=0 to 7 do
 if wsyncTab[i]<>0 then opty:=false;

 if dli_nr>2 then
  save(#9'jmp NMI.quit')
 else
  save(';XXX');


save('');

save('.endl'#13#10);

save(brkTab+#13#10);

if dli_nr>2 then _dli:='DLI.dli2' else _dli:='DLI.dli1';

 if opty then begin
  _dli:='DLI.dli_start';

  save('CHANGES = '+AnsiString(IntToStr(ord(form1.SelectVideo.ItemIndex=0))));

  if SpecialStr[___FadeDLI].val then begin

   if SpecialStr[___FadeDLIBOX].val then save('FADECHR'#9'= 1') else
    if SpecialStr[___FadeDLIRND].val then save('FADECHR'#9'= 2') else
     if SpecialStr[___FadeDLI_LR].val then save('FADECHR'#9'= 3') else
      if SpecialStr[___FadeDLI_Plasma].val then save('FADECHR'#9'= 4') else
       save('FADECHR'#9'= 0');

  end else
   save('FADECHR'#9'= 0');

  save('');
 end else
  save('CHANGES'#9'= 0'#13#10'FADECHR'#9'= 0'#13#10);

save('SCHR'#9'= '+AnsiString(IntToStr(fade_special_char)+#13#10));

save(brkTab+#13#10);

save('.proc'#9'NMI'#13#10);

SzerokoscObrazu;

zm:=szer_ekran;


if asm_slideshow then begin

 save(#9'mwa #ant '+form1.reg_label($d402)+#9#9';ANTIC address program');
 save(#9'mva #'+zm+' '+form1.reg_label($d400)+#9';set new screen width'#13#10);

end else begin

{ save(#9'sta regA');
 save(#9'stx regX');
 save(#9'sty regY'+#13#10);      }

 save(#9'bit '+form1.reg_label($d40f));
 save(#9'bpl VBL'#13#10);

 save(#9'jmp '+_dli);
 save('dliv'#9'equ *-2'#13#10);

 save('VBL');

 save(#9'sta regA');
 save(#9'stx regX');
 save(#9'sty regY'#13#10);

 save(#9'sta '+form1.reg_label($d40f)+#9#9';reset NMI flag'#13#10);

 save(#9'mwa #ant '+form1.reg_label($d402)+#9#9';ANTIC address program'#13#10);
 save(#9'mva #'+zm+' '+form1.reg_label($d400)+#9';set new screen width'#13#10);

 save(#9'inc cloc'#9#9';little timer'#13#10);

end;

save('; Initial values'#13#10);

// przepisz VBL do pliku wynikowego
assignfile(plik,GetUndoName('temp.$$$')); FileMode:=0; reset(plik);
while not eof(plik) do begin readln(plik,zm); save(zm); end;
closefile(plik);

save('');


if asm_slideshow then begin

 save(#9'mwa #DLI.dli_start $200'#9';set the first address of DLI interrupt');

 if not(opty) then
  save(#9'mwa #DLI.dli1 null+1'#9';synchronization for the first screen line');

 save(#9'plr');
 save(#9'rti'#13#10);

end else begin

 if (dli_nr>2) or opty then
  save(#9'mwa #'+_dli+' dliv'#9';set the first address of DLI interrupt');

 if not(opty) then
  save(#9'mwa #DLI.dli1 null+1'#9';synchronization for the first screen line');

 save(#13#10';this area is for yours routines'#13#10);

 save('quit');

 save(#9'lda regA');
 save(#9'ldx regX');
 save(#9'ldy regY');
 save(#9'rti'#13#10);

end;

 save('.endp'#13#10);

 save(brkTab);


move(bufor,tchg,sizeof(tchg));

if (t_video(form1.SelectVideo.ItemIndex)=vgtia) and SpecialStr[___FadeDLI].val then begin
 save(#9'ift CHANGES');
 save(#9#9'ift FADECHR = 0');
 {if opty then }save(#9#9'icl '''+AnsiString(sama_nazwa)+'.fad''');

 if FadeFx then begin
  save(#9#9'els');

  save (#9#9'icl '''+AnsiString(sama_nazwa)+'.hcl''');
  save (#9#9'icl '''+AnsiString(sama_nazwa)+'.pmf''');
 end;

 save(#9#9'eif');

 save(#9'eif'#13#10);
end;

ObiektyPMG;

FileClose(dane);


assignfile(src,GetUndoName('asm$$$.$$$')); FileMode:=0; reset(src);
assignfile(plik,GetUndoName('tmp$$$.$$$')); rewrite(plik);

tmp1:=0; a:=0;
dli_start:=false; _dli:='DLI.dli1'; new_dli:=dli_nr+1;

while not eof(src) do begin
 readln(src,zm);

 i:=AnsiPos(AnsiString(';XXX'),zm);
 if i>0 then begin

  if opty then begin

   if dli_nr>2 then begin
    _dli:='DLI.dli2';
    writeln(plik,#9'DLINEW ',_dli);
   end else begin

    if asm_slideshow then begin

     writeln(plik,#9'lda regA');
     writeln(plik,#9'ldx regX');
     writeln(plik,#9'ldy regY');
     writeln(plik,#9'rti'#13#10);

    end else
     writeln(plik,#9'jmp NMI.quit');

   end;

   if not(dli_start) then begin
    writeln(plik,#9'eif'#13#10);

    writeln(plik,'dli_start');
    dli_start:=true;
   end;

  end else begin
   writeln(plik,#9'mwa #null null+1');
   writeln(plik,#9'jmp null'#13#10);

   writeln(plik,#9'eif');

   writeln(plik,'dli_start');
   opty:=true;
   dli_start:=true;
  end;

  zm:='';
 end;

 i:=AnsiPos(AnsiString('dli'),zm);
 if i=1 then begin
  while (i<=length(zm)) and not(zm[i] in [#0,' ']) do inc(i);
  _dli:=copy(zm,1,i);
 end;

 i:=AnsiPos(AnsiString(';line='),zm);

 test:=false;
 if i>0 then begin
  tx:=copy(zm,i,length(zm)-i+1);
  i:=AnsiPos(AnsiString('='),tx); tx:=copy(tx,i+1,length(zm)-i); a:=StrToInt(string(tx));
  test:=true;
 end;

 if test then
  if wsyncTab[a]<>0 then begin
   for i:=0 to wsyncTab[a]-1 do begin
    tx:=kosz[tmp1]; writeln(plik,tx); inc(tmp1);
   end;

   test:=false;
  end;

 if test and opty then begin
  for i:=a to 239 do
   if wsyncTab[i]<>0 then Break;

  v:=(i-0) shr 3;
  j:=((i-0) and $f8)-a;  dec(j);

 // CATABALL nie wyrabial sie z przerwaniem DLI gdy
 // przerwa pomiedzy wywolaniem przerwania DLI byla 2 liniowa

  if (j>=0) and (wsyncTab[v shl 3-1]=0) and (wsyncTab[v shl 3-2]=0) then begin
   for i:=0 to j-1 do readln(src);

    tchg[v]:=$ff;

    inc(new_dli); _dli:='dli'+AnsiString(IntToStr(new_dli));

    writeln(plik,#9'DLINEW ',_dli,#13#10);

    if not(dli_start) then begin
     writeln(plik,#9'eif');

     writeln(plik,'dli_start');
     dli_start:=true;
    end;

    writeln(plik,_dli);

    zm:='';
  end;

 end;

 writeln(plik,zm);
end;


flush(src);
flush(plik);

closefile(src); closefile(plik);


// optymalizacja dla DLINEW, sprawdzamy które rejestry u¿ywa DLI

assignfile(src,GetUndoName('tmp$$$.$$$')); FileMode:=0; reset(src);
assignfile(plik,snazwa+'.asm'); rewrite(plik);

dli_start:=false;
dli_begin:=false;

savedli:=true;

SetLength(dliprg, 1);

while not eof(src) do begin
 readln(src, zm);


 if AnsiPos(AnsiString('ANTIC_PROGRAM'), zm)>0 then begin

 lms_used:=false;

 write(plik,'ant'#9'dta ');

if Fox1 then begin

 for v:=0 to 59-1 do begin
  m:=0;

  if v<>59-1 then
  if tchg[(v+1) shr 1]>0 then inc(m,$80);

  case gfxMode[v shr 1] of
     0: inc(m,$70);
   1,4: inc(m,2);
     2: inc(m,4);
  end;

  if v<>59-1 then
  if v and 1=0 then m:=m or $20;

  if not(lms_used) and (m and 7>0) then begin
   write(plik, form1.hex(m+$40,2),',a(scr)');
   lms_used:=true; m:=0;
  end;

  if m>0 then write(plik, form1.hex(m,2));

  if v mod 16=0 then begin
   writeln(plik); write(plik,#9'dta ');
  end else
   if v<>59-1 then write(plik,',');

 end;

end else begin

 for v:=0 to 29 do begin
  m:=0;
  if tchg[v+1]>0 then inc(m,$80);

  case gfxMode[v] of
     0: inc(m,$70);
   1,4: begin
         inc(m,2);
         if v=29 then inc(m, $20);        // scroll pionowy
        end;
     2: inc(m,4);
  end;

  if not(lms_used) and (m and 7>0) then begin
   write(plik, form1.hex(m+$40,2),',a(scr)');
   lms_used:=true; m:=0;
  end;

  if m>0 then write(plik, form1.hex(m,2));

  if v mod 16=0 then begin
   writeln(plik); write(plik,#9'dta ');
  end else
   if v<>29 then write(plik,',');

 end;

end;

 write(plik,#13#10#9'dta $41,a(ant)');
 zm:='';
 end;


 if AnsiPos(AnsiString('DLI PROGRAM'), zm)>0 then dli_begin:=true;    // DLI PROGRAM

 if dli_begin and (AnsiPos(AnsiString('dli_start'), zm)>0) then dli_start:=true;

 if dli_start then begin

  if AnsiPos(AnsiString('dli'), zm)=1 then begin
   ra:=false;
   rx:=false;
   ry:=false;

   SetLength(dliprg, 1);

   writeln(plik);
  end else begin

   i:=High(dliprg);
   dliprg[i]:=zm;
   SetLength(dliprg, i+2);

   savedli:=false;
  end;


  if AnsiPos(AnsiString('lda'), zm)>0 then ra:=true;
  if AnsiPos(AnsiString('ldx'), zm)>0 then rx:=true;
  if AnsiPos(AnsiString('ldy'), zm)>0 then ry:=true;


  if AnsiPos(AnsiString('DLINEW'), zm)>0 then begin

   savedli:=true;

   if ra then writeln(plik, #9'sta regA');
   if rx then writeln(plik, #9'stx regX');
   if ry then writeln(plik, #9'sty regY');
//   writeln(plik);

   for i:=0 to High(dliprg)-2 do
    writeln(plik, dliprg[i]);

   zm:=zm+' '+AnsiString(IntToStr(ord(ra)))+' '+AnsiString(IntToStr(ord(rx)))+' '+AnsiString(IntToStr(ord(ry)));
  end;


  if AnsiPos(AnsiString('.proc'),zm)>0 then begin      // brak przerwania DLI
   savedli:=true;
   dli_start:=false;
   dli_begin:=false;

   for i:=0 to High(dliprg)-2 do
    writeln(plik, dliprg[i]);

  end;


  if AnsiPos(AnsiString('NMI.'), zm)>0 then begin
   savedli:=true;
   dli_start:=false;
   dli_begin:=false;

   if ra then writeln(plik, #9'sta regA');
   if rx then writeln(plik, #9'stx regX');
   if ry then writeln(plik, #9'sty regY');
//   writeln(plik);

   for i:=0 to High(dliprg)-2 do
    writeln(plik, dliprg[i]);

   writeln(plik);

   if ra then writeln(plik, #9'lda regA');
   if rx then writeln(plik, #9'ldx regX');
   if ry then writeln(plik, #9'ldy regY');
   write(plik, #9'rti');
   zm:='';
  end;

 end;

 if savedli then writeln(plik, zm);
 savedli:=true;
end;


flush(src);
flush(plik);

closefile(src); closefile(plik);

//if opty then Application.MessageBox('FAD file disabled','Save ASM',MB_ICONINFORMATION);

end;

end;


procedure save_cycle(i: byte);
begin
 while i>=14 do begin save(#9'jsr _rts'); dec(i,12) end;

 if i>=2 then save(#9+NOP[i-2]);
end;


function c4RasterGet(const a: byte): integer;
var i: integer;
begin

 Result:=-1;

 for i:=0 to 255 do
  if c4Raster[i]=a then begin Result:=i; Break end;

 if Result<0 then
  for i:=0 to 255 do
   if c4Raster[i]<0 then begin c4Raster[i]:=a; Result:=i; Break end;

end;


function ZPRasterGet(const a: byte): integer;
var i: integer;
begin

 Result:=-1;

 for i:=0 to 255 do
  if zpRaster[i]=a then begin Result:=i; Break end;

 if Result<0 then
  for i:=0 to 255 do
   if zpRaster[i]<0 then begin zpRaster[i]:=a; Result:=i; Break end;

end;


procedure ZapiszGED(const i: integer; c:integer; const czy24:Boolean);
(*----------------------------------------------------------------------------*)
(* i      to linia z tablicy RASTER                                           *)
(* czy24  pozwala lub zabrania zapisania 24 cykli                             *)
(*----------------------------------------------------------------------------*)
var a, err: integer;
    v, v2: byte;
    ra, rx, ry: word;
    test: array [0..High(tARaster)] of Boolean;
    lab, zm: AnsiString;
begin

// test linii z rastrem, czy zawiera Default Values
if form1.LiczCRCRaster(i)=crcRasterDefault then begin

// tylko dla szerokosci 40 i trybu graficznego jest mniej cykli
 case czy24 of

   true: case UseChar of
           true: if Bajt=32 then begin
                  save(#9'jsr wait60cycle');
                  inc(c, 60);
                 end else begin
                  save(#9'jsr wait60cycle');
                  inc(c, 60);
                 end;

          false: if Bajt=32 then begin
                  save(#9'jsr wait60cycle');
                  inc(c, 60);
                 end else begin
                  save(#9'jsr wait54cycle');
                  inc(c, 54);
                 end;
         end;

  false: begin
          save(#9'jsr wait36cycle');
          inc(c, 36);
         end;

//        case UseChar of
//           true: if Bajt=32 then save(' jsr wait36cycle') else save(' jsr wait36cycle');
//          false: if Bajt=32 then save(' jsr wait36cycle') else save(' jsr wait36cycle');
//         end;
 end;

end else begin

  if czy24 and (not (t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo]) ) then begin

   if not(UseChar) and (Bajt=40) then begin
    save(#9'jsr wait18cycle');
    inc(c, 18);
   end else begin
    save(#9'jsr wait24cycle');
    inc(c, 24);
   end;

  end;


 if t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr] then begin       // GED--

  err:=raster_line_ofset[i].arg;

  case raster_line_ofset[i].cod of
   0: begin save_cycle(err); inc(c, err) end;
   1: begin save(color_label($d012)+#9'lda #'+form1.Hex(err ,2)); inc(c,2) end;
   2: begin save(color_label($d012)+#9'ldx #'+form1.Hex(err ,2)); inc(c,2) end;
   3: begin save(color_label($d012)+#9'ldy #'+form1.Hex(err ,2)); inc(c,2) end;
   $41: begin save(#9'lda zc+'+AnsiString(IntToStr(ZPRasterGet(err)))); inc(c, 3) end;
   $42: begin save(#9'ldx zc+'+AnsiString(IntToStr(ZPRasterGet(err)))); inc(c, 3) end;
   $43: begin save(#9'ldy zc+'+AnsiString(IntToStr(ZPRasterGet(err)))); inc(c, 3) end;
  end;

 end;


// zamiana 24 bajtow z tablicy RASTER na odpowiadajace im rozkazy
// razem 36 cykli

// ustal ktore wartosci modyfikuja rejestry koloru
 ra:=$d01e;
 rx:=$d01e;
 ry:=$d01e;

 fillchar(test,sizeof(test),false);

for a:=RLimitInst-1 downto 0 do begin
 v:=raster[i,a].cod;
 v2:=raster[i,a].arg;

 case v of
  1, $41, $61: if (ra>=$d012) and (ra<=$d01a) then test[a]:=true;
  2, $42, $62: if (rx>=$d012) and (rx<=$d01a) then test[a]:=true;
  3, $43, $63: if (ry>=$d012) and (ry<=$d01a) then test[a]:=true;

  $81: ra:=v2;
  $82: rx:=v2;
  $83: ry:=v2;
 end;
 
end;

// na grafice raster jest wolniejszy

//c:=AddCycle;

for a:=0 to RLimitInst-1 do begin


 if (t_mode(form1.SelectMode.ItemIndex) = m_piccolo) and (i > 0) and (i mod 24=0) and (a in [0,1]) then begin

  if a=0 then begin
   save(#9'lda >fnt+' + AnsiString(IntToStr(i div 24)) + '*1024');
   Inc(c, 2);
  end else begin
   save(#9'sta chbase');
   Inc(c, 4);
  end;


 end else begin


 v:=raster[i,a].cod;
 v2:=raster[i,a].arg;

 zm:=AnsiString(IntToHex(v2,2));

 if test[a] then lab:=color_label($d012) else lab:='';

 case v of
  0: if v2<>0 then begin save_cycle(v2); inc(c, v2) end;

  1: begin
      if DLItoRaster then
       save(lab+#9'lda #?lda')
      else
       save(lab+#9'lda #$'+zm);

      inc(c, 2);
     end;

  2: begin
      if DLItoRaster then
       save(lab+#9'ldx #?ldx')
      else
       save(lab+#9'ldx #$'+zm);

      inc(c, 2);
     end;

  3: begin
      if DLItoRaster then
       save(lab+#9'ldy #?ldy')
      else
       save(lab+#9'ldy #$'+zm);

      inc(c, 2);
     end;

  $41: begin save(#9'lda zc+'+AnsiString(IntToStr(ZPRasterGet(v2)))); inc(c, 3) end;
  $42: begin save(#9'ldx zc+'+AnsiString(IntToStr(ZPRasterGet(v2)))); inc(c, 3) end;
  $43: begin save(#9'ldy zc+'+AnsiString(IntToStr(ZPRasterGet(v2)))); inc(c, 3) end;

  $61: begin save(#9'lda cl+'+AnsiString(IntToStr(c4RasterGet(v2)))); inc(c, 4) end;
  $62: begin save(#9'ldx cl+'+AnsiString(IntToStr(c4RasterGet(v2)))); inc(c, 4) end;
  $63: begin save(#9'ldy cl+'+AnsiString(IntToStr(c4RasterGet(v2)))); inc(c, 4) end;

  $81: begin
        if DLItoRaster then
         save(#9'sta ?sta')
        else
         save(#9'sta '+GED_reg_label(v2));

        inc(c, 4);
       end;

  $82: begin
        if DLItoRaster then
         save(#9'stx ?stx')
        else
         save(#9'stx '+GED_reg_label(v2));

        inc(c, 4);
       end;

  $83: begin
        if DLItoRaster then
         save(#9'sty ?sty')
        else
         save(#9'sty '+GED_reg_label(v2));

        inc(c, 4);
       end;
 end;

 end; // if piccolo

end;
end;

c:=LimitCycle-c;


// tutaj dodatkowe docyklowanie dla linii

case Bajt of

 32: case UseChar of
//       true: save(#9+NOP[8-2+c]);

      false: if bufor[i]<>0 then
              dec(c,3)
             else
              dec(c);
     end;

 40: case UseChar of
//       true: if c>1 then save(#9+NOP[c-2]);

      false: if bufor[i]<>0 then
              inc(c,3)
             else
              inc(c,5);
     end;
end;


if c>1 then save_cycle(c);

end;


function addReg(a: AnsiString; const reg: AnsiChar): AnsiString;
var i: integer;
begin

 Result:=a;

 i:=AnsiPos(AnsiString('ld'), a);
 if i>0 then Result[i+2]:=reg;

 i:=AnsiPos(AnsiString('st'), a);
 if i>0 then Result[i+2]:=reg;

end;


procedure save_3_changes(var v: integer; const ireg: byte);
begin

       case ireg of
        1: begin
            save(addReg(get_tval(v),treg[0])); save(addReg(get_tadr(v),treg[0]));
            save(addReg(get_tval(v+1),treg[0])); save(addReg(get_tadr(v+1),treg[0]));
            save(addReg(get_tval(v+2),treg[0])); save(addReg(get_tadr(v+2),treg[0]));
           end;

        2: begin
            save(addReg(get_tval(v),treg[0])); save(addReg(get_tval(v+1),treg[1]));
            save(addReg(get_tadr(v),treg[0])); save(addReg(get_tadr(v+1),treg[1]));
            save(addReg(get_tval(v+2),treg[0])); save(addReg(get_tadr(v+2),treg[0]));
           end;

        else begin
         save(addReg(get_tval(v),treg[0])); save(addReg(get_tval(v+1),treg[1])); save(addReg(get_tval(v+2),treg[2]));
         save(addReg(get_tadr(v),treg[0])); save(addReg(get_tadr(v+1),treg[1])); save(addReg(get_tadr(v+2),treg[2]));
        end;

       end;

end;


procedure SaveAsm;
(*----------------------------------------------------------------------------*)
(* procedure Save GED                                                         *)
(*----------------------------------------------------------------------------*)
var i, err, j, c, zp, f, v: integer;
    plik: Textfile;
    ireg: byte;
    tabLine: tab_byte256;
    pusta_linia: Boolean;
    zm: AnsiString;
begin
Analyzing;

if (gate>0) and AsmError then begin

fillchar(bufor,sizeof(bufor),0);

// czy w obrazku wylaczylismy linie ?
pusta_linia:=false;
for i:=0 to 29 do
 if gfxMode[i]=0 then begin pusta_linia:=true; Break end;


// zapisz plik RAW
if UseChar=false then begin
v:=0; err:=0;

f:=FileCreate(form1.snazwa+'.raw');

{if SpecialStr[___LMSperline].val then begin

 for i:=0 to 29 do
 if gfxMode[i]>0 then
  for j:=0 to 7 do FileWrite(f, tab[tmul48[i shl 3+j]+CzarnyPas shr 3], Bajt);

end else
}


 for i:=0 to 29 do
 if gfxMode[i]>0 then begin
  for j:=0 to 7 do FileWrite(f,tab[tmul48[i shl 3+j]+CzarnyPas shr 3],Bajt);
  inc(err,Bajt shl 3); inc(v,Bajt shl 3);

  if ((err+Bajt shl 3)>4096) and (byte(err+Bajt shl 3)>0) then begin
   j:=word(v+Bajt shl 3) and $ff00; FileWrite(f,bufor,j-v);
   v:=word(v+Bajt shl 3) and $ff00; err:=(err+Bajt shl 3) mod 4096;
  end;
 end;


FileClose(f);
end;

// tablica bad lines dla trybu znakowego
fillchar(bufor,sizeof(bufor),0);
fillchar(tabLine,sizeof(tabLine),0);  v:=8;

case UseChar of
  true: if NoBadLines then
         tabLine[4]:=$ff
        else
         for i:=0 to 30 do begin tabLine[v-8]:=$ff; inc(v,8) end;

 false: for i:=0 to 30 do begin bufor[v-1]:=$ff; inc(v,8) end;
end;

if SpecialStr[___LMSperline].val then fillchar(bufor, 256, $ff);

// zapisz plik ASQ
dane:=FileCreate(form1.snazwa+'.asq');

save('/***************************************/');
save('/*  Use MADS http://mads.atari8.info/  */');

 case t_mode(form1.SelectMode.ItemIndex) of
      m_gedp: save('/*  Mode: GED+ (char mode)             */');
      m_gedm: save('/*  Mode: GED- (bitmap mode)           */');
       m_pgr: save('/*  Mode: PGR  (bitmap mode)           */');
   m_piccolo: save('/*  Mode: PGR+ (char mode)             */');
 end;

save('/***************************************/');

Etykiety;

save(#9'lda:cmp:req $14'#9#9';wait 1 frame'#13#10);

save(#9'sei'#9#9#9';stop interrups');
save(#9'mva #$00 '+form1.reg_label($d40e)+#9#9';stop all interrupts');
save(#9'mva #$fe '+form1.reg_label($d301)+#9#9';switch off ROM to get 16k more ram'#13#10);


SzerokoscObrazu;

zm:=szer_ekran;

if UseChar then save(#9'mva #1 vscrol'#13#10);

save(#9'ZPINIT'#13#10);

if (SpecialStr[___FadeGED].val and (t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr])) or
   (SpecialStr[___FadeGEDplus].val and (t_mode(form1.SelectMode.ItemIndex)=m_gedp)) then begin
 save(#9'mva #0 fcnt');
 save(#9'jsr line'#13#10);
end;

save('////////////////////');
save('// RASTER PROGRAM //');
save('////////////////////'#13#10);

save(#9'jmp raster_program_end'#13#10);

save('LOOP'#9'lda '+form1.reg_label($d40b)+#9#9';synchronization for the first screen line');
save(#9'cmp #$02');
save(#9'bne LOOP'#13#10);

save(#9'mva #'+zm+' '+form1.reg_label($d400)+#9';set new screen width');
save(#9'mva <ant '+form1.reg_label($d402));
save(#9'mva >ant '+form1.reg_label($d402)+'+1'#13#10);

 save('; Initial values'#13#10);

if t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo] then begin

 save(#9'mva #'+form1.Hex(tgtia.hposp0,2)+' '+form1.reg_label($d000));
 save(#9'mva #'+form1.Hex(tgtia.hposp1,2)+' '+form1.reg_label($d001));
 save(#9'mva #'+form1.Hex(tgtia.hposp2,2)+' '+form1.reg_label($d002));
 save(#9'mva #'+form1.Hex(tgtia.hposp3,2)+' '+form1.reg_label($d003));

 save(#9'mva #'+form1.Hex(tgtia.hposm0,2)+' '+form1.reg_label($d004));
 save(#9'mva #'+form1.Hex(tgtia.hposm1,2)+' '+form1.reg_label($d005));
 save(#9'mva #'+form1.Hex(tgtia.hposm2,2)+' '+form1.reg_label($d006));
 save(#9'mva #'+form1.Hex(tgtia.hposm3,2)+' '+form1.reg_label($d007));

 save(#9'mva #'+form1.Hex(tgtia.sizep0,2)+' '+form1.reg_label($d008));
 save(#9'mva #'+form1.Hex(tgtia.sizep1,2)+' '+form1.reg_label($d009));
 save(#9'mva #'+form1.Hex(tgtia.sizep2,2)+' '+form1.reg_label($d00a));
 save(#9'mva #'+form1.Hex(tgtia.sizep3,2)+' '+form1.reg_label($d00b));

 save(#9'mva #'+form1.Hex(tgtia.sizem,2)+' '+form1.reg_label($d00c));

 save(#9'mva #'+form1.Hex(tgtia.grafp0,2)+' '+form1.reg_label($d00d));
 save(#9'mva #'+form1.Hex(tgtia.grafp1,2)+' '+form1.reg_label($d00e));
 save(#9'mva #'+form1.Hex(tgtia.grafp2,2)+' '+form1.reg_label($d00f));
 save(#9'mva #'+form1.Hex(tgtia.grafp3,2)+' '+form1.reg_label($d010));

 save(#9'mva #'+form1.Hex(tgtia.grafm,2)+' '+form1.reg_label($d011));

 save(#9'mva #'+form1.Hex(tgtia.colpm0,2)+' '+form1.reg_label($d012));
 save(#9'mva #'+form1.Hex(tgtia.colpm1,2)+' '+form1.reg_label($d013));
 save(#9'mva #'+form1.Hex(tgtia.colpm2,2)+' '+form1.reg_label($d014));
 save(#9'mva #'+form1.Hex(tgtia.colpm3,2)+' '+form1.reg_label($d015));

 save(#9'mva #'+form1.Hex(tgtia.color0,2)+' '+form1.reg_label($d016));
 save(#9'mva #'+form1.Hex(tgtia.color1,2)+' '+form1.reg_label($d017));
 save(#9'mva #'+form1.Hex(tgtia.color2,2)+' '+form1.reg_label($d018));
 save(#9'mva #'+form1.Hex(tgtia.color3,2)+' '+form1.reg_label($d019));
 save(#9'mva #'+form1.Hex(tgtia.colbak,2)+' '+form1.reg_label($d01a));

 save(#9'lda #'+form1.Hex(tgtia.regA,2));
 save(#9'ldx #'+form1.Hex(tgtia.regX,2));
 save(#9'ldy #'+form1.Hex(tgtia.regY,2));

end else begin

 assignfile(plik, form1.GetUndoName('temp.$$$')); FileMode:=0; reset(plik);
 while not eof(plik) do begin readln(plik,zm); save(zm); end;
 closefile(plik);

end;

save(#13#10#9':2 sta '+form1.reg_label($d40a));


v:=0;
case UseChar of
  true: if Bajt=40 then v:=44+33+2-6 else v:=52+26+2-6;
 false: if Bajt=40 then v:=22+2-6 else v:=8+2-6;
end;

 if not(NoBadLines) or (t_mode(form1.SelectMode.ItemIndex) = m_piccolo) then begin

  if t_mode(form1.SelectMode.ItemIndex) = m_piccolo then
   case Bajt of
    32: Dec(v, 40);
    40: inc(v, 13);
   end;

  save(#13#10+brkTab+#9+'wait '+AnsiString(IntToStr(v))+' cycles');
  save_cycle(v);
 end else begin

  if Bajt=40 then v:=36+2-6+8 else v:=36+2-6+16;

  save(#13#10+brkTab+#9+'wait '+AnsiString(IntToStr(v))+' cycles');
  save_cycle(v);
 end;


//wyliczenie globalnego ofsetu
i:=FEditRasters.GlobalOfset.Position; inc(i,24);

save(#13#10+brkTab+#9'set global offset ('+AnsiString(IntToStr(i+4))+' cycles)');

save_cycle(i+4);


v:=0; changes[0]:=0;

// jesli raster na grafice to dodaj 1 pusta linie
if not(UseChar) then begin
 save(#13#10+brkTab+#9+'empty line');

 case Bajt of
  32: begin save(#9'jsr wait60cycle'); save_cycle(8 + 4 - ord(FSpecial.chk_players.Checked)*4 + ord(not(FSpecial.chk_players.Checked) and not(FSpecial.chk_missiles.Checked)) ) end;
  40: begin save(#9'jsr wait54cycle'); save_cycle(5 + 4 - ord(FSpecial.chk_players.Checked)*4 + ord(not(FSpecial.chk_players.Checked) and not(FSpecial.chk_missiles.Checked)) ) end;
 end;

 save(#13#10);

 if t_mode(form1.SelectMode.ItemIndex) = m_pgr then
  case Bajt of
   32: save_cycle(24);
   40: save_cycle(11);
  end;

end;


for i:=0 to 255 do begin zpRaster[i]:=-1; c4Raster[i]:=-1 end;

ireg:=0;

if FSpecial.ged_a.Checked then begin treg[ireg]:='a'; inc(ireg) end;
if FSpecial.ged_x.Checked then begin treg[ireg]:='x'; inc(ireg) end;
if FSpecial.ged_y.Checked then begin treg[ireg]:='y'; inc(ireg) end;

//save('; reg | '+inttostr(ireg)+' | '+treg[0]+','+treg[1]+','+treg[2]);
//for f := 0 to 5 do save(treg[f mod ireg]);

if t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo] then fillchar(changes, sizeof(changes), 0);


for i:=0 to Wysokosc-1 do begin
str(i,zm); zm:='line'+zm; save(''); save(zm);

 c:=0;

 if (Changes[i]>0) and not(DLItoRaster) then begin

  case Changes[i] of

   1: begin
       save(addReg(get_tval(v),treg[0])); save(addReg(get_tadr(v),treg[0]));
       save_cycle(12);

       inc(c, 18);

       if not(not(UseChar) and (Bajt=40)) then begin
        save_cycle(6);
        inc(c, 6);
       end;

       inc(v);
      end;

   2: begin

       if ireg=1 then begin
        save(addReg(get_tval(v),treg[0])); save(addReg(get_tadr(v),treg[0]));
        save(addReg(get_tval(v+1),treg[0])); save(addReg(get_tadr(v+1),treg[0]));
       end else begin
        save(addReg(get_tval(v),treg[0])); save(addReg(get_tval(v+1),treg[1]));
        save(addReg(get_tadr(v),treg[0])); save(addReg(get_tadr(v+1),treg[1]));
       end;

       save_cycle(6);

       inc(c, 18);

       if not(not(UseChar) and (Bajt=40)) then begin
        save_cycle(6);
        inc(c, 6);
       end;

       inc(v,2);
      end;

   3: begin

       save_3_changes(v,ireg);

       inc(c, 18);

       if not(not(UseChar) and (Bajt=40)) then begin
        save_cycle(6);
        inc(c, 6);
       end;

       inc(v,3);
      end;

   4: begin

       save_3_changes(v,ireg);

       inc(c, 18);

       if not(not(UseChar) and (Bajt=40)) then begin

        save(addReg(get_tval(v+3),treg[0])); save(addReg(get_tadr(v+3),treg[0]));

        inc(c, 6);
       end;

       inc(v,4);
      end;

  end;


 // tutaj tylko koncowka, 36 cykle
  if tabLine[i]=0 then
   ZapiszGED(i,c, false)
  else
   if Bajt=40 then
    save_cycle(3)
   else
    save_cycle(18);


 end else begin

  if DLItoRaster then
   case Changes[i] of
    0: begin
        save(#9'?lda=0');
        save(#9'?ldx=0');
        save(#9'?ldy=0');
        save(#9'?sta=$d01e');
        save(#9'?stx=$d01e');
        save(#9'?sty=$d01e');
       end;

    1: begin
        save(get_tval(v));
        save(#9'?ldx=0');
        save(#9'?ldy=0');
        save(get_tadr(v));
        save(#9'?stx=$d01e');
        save(#9'?sty=$d01e');
        inc(v);
       end;

    2: begin
        save(get_tval(v));
        save(get_tval(v+1));
        save(#9'?ldy=0');
        save(get_tadr(v));
        save(get_tadr(v+1));
        save(#9'?sty=$d01e');
        inc(v,2);
       end;

    3: begin
        save(get_tval(v));
        save(get_tval(v+1));
        save(get_tval(v+2));
        save(get_tadr(v));
        save(get_tadr(v+1));
        save(get_tadr(v+2));
        inc(v,3);
       end;
   end;

 // tutaj pelne 60 cykli
  if tabLine[i]=0 then
   ZapiszGED(i,c, true )
  else begin
// tutaj 8-a linia bez rastra

   if t_mode(form1.SelectMode.ItemIndex) = m_piccolo then begin

    case Bajt of
     32: inc(c, 18+8);          // 42 cykle
     40: inc(c, 33);          // 27 cykle
    end;

    ZapiszGED(i,c, false);

   end else begin

   save(#9'jsr wait24cycle');

   if Bajt=40 then
    save_cycle(3)
   else
    save_cycle(18);

   end;

  end;

 end;

end;

save('');

save('raster_program_end'#13#10);


save(#9'lda #$00');
for i := 0 to 8 do save(#9'sta '+form1.reg_label($d012+i));

if t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo] then begin

 save(#9'mva #'+form1.Hex(tgtia.pmcntl,2)+' '+form1.reg_label($d01d));
 save(#9'mva #'+form1.Hex(tgtia.gtictl,2)+' '+form1.reg_label($d01b));

 save(#9'mva >fnt chbase'#13#10);

end;

save('');


save(brkLine);
save('//	EXIT');
save(brkLine+#13#10);

save(#9'lda '+reg_labelR($d010)+#9#9'; FIRE #0');
save(#9'beq stop'#13#10);

save(#9'lda '+reg_labelR($d011)+#9#9'; FIRE #1');
save(#9'beq stop'#13#10);

save(#9'lda '+form1.reg_label($d01f)+#9#9'; START');
save(#9'and #1');
save(#9'beq stop'#13#10);

save(#9'lda '+form1.reg_label($d20f)+#9#9'; ANY KEY');
save(#9'and #$04');
save(#9'bne skp'#13#10);

save('stop'#9'mva #$00 '+form1.reg_label($d01d)+#9#9';PMG disabled');
save(#9'tax');
save(#9'sta:rne '+form1.reg_label($d000)+',x+'#13#10);

save(#9'mva #$ff '+form1.reg_label($d301)+#9#9';ROM switch on');
save(#9'mva #$40 '+form1.reg_label($d40e)+#9#9';only NMI interrupts, DLI disabled');
save(#9'cli'#9#9#9';IRQ enabled'#13#10);

save(#9'rts'#9#9#9';return to ... DOS');

save('skp'#13#10);

save(brkLine+#13#10);

save(#9'jmp LOOP');
save('');
save(brkTab);
save('');

if not(UseChar) and (Bajt=40) then begin
 save('wait54cycle');
 save(#9'cmp (0,x)\ cmp 0,x');
 save('wait44cycle');
 save(#9'cmp (0,x)');
 save(#9'nop');
 save('wait36cycle');
 save(#9'cmp (0,x)');
 save(#9'jsr _rts');
 save('wait18cycle');
 save(#9'cmp (0,x)');
 save('_rts'#9'rts');

end else begin

 save('wait60cycle');
 save(#9'jsr _rts');
 save(#9'cmp 0,x');
 save('wait44cycle');
 save(#9'cmp (0,x)');
 save(#9'nop');
 save('wait36cycle');
 save(#9'jsr _rts');
 save('wait24cycle');
 save(#9'jsr _rts');
 save('_rts'#9'rts');
end;

 save(#13#10+brkTab+#13#10);

// tutaj zmiany rastra na grafice, bez znakow
if UseChar=false then begin

// jesli istnieja puste linie to potrzeba nam pustych danych
if pusta_linia then save('nil_used'#13#10);

// tutaj reszta grafiki zapisana do pliku *.RAW
{save('.MACRO'#9'SCREEN_DATA');
save(#9+'ins '''+ snazwa+'.raw''');
save('.ENDM'#13#10);}

save('.MACRO'#9'ANTIC_PROGRAM');
v:=0; err:=0;
for i:=0 to 29 do begin
zm:=form1.Hex(v,4);

 case gfxMode[i] of
    0: if SpecialStr[___LMSperline].val then
        save(#9':+8 dta $4e,a(nil)')
       else
        save(#9'dta $4e,a(nil),$e,$e,$e,$e,$e,$e,$e');

  1,4: if i<>29 then begin

        if SpecialStr[___LMSperline].val then
         save(#9':+8 dta $4f,a(:1+'+form1.Hex(v,4)+'+#*'+AnsiString(IntToStr(Bajt))+')')
        else
         save(#9'dta $4f,a(:1+'+zm+'),$f,$f,$f,$f,$f,$f,$f')

       end else
        if SpecialStr[___LMSperline].val then
         save(#9':+7 dta $4f,a(:1+'+form1.Hex(v,4)+'+#*'+AnsiString(IntToStr(Bajt))+')')
        else
         save(#9'dta $4f,a(:1+'+zm+'),$f,$f,$f,$f,$f,$f');

    2: if SpecialStr[___LMSperline].val then
         save(#9':+8 dta $4e,a(:1+'+form1.Hex(v,4)+'+#*'+AnsiString(IntToStr(Bajt))+')')
       else
        save(#9'dta $4e,a(:1+'+zm+'),$e,$e,$e,$e,$e,$e,$e');
 end;

 if gfxMode[i]>0 then begin
  inc(err,Bajt shl 3); inc(v,Bajt shl 3);

  if ((err+Bajt shl 3)>4096) and (byte(err+Bajt shl 3)>0) then begin
   err:=(err+Bajt shl 3) mod 4096;
   v:=word(v+Bajt shl 3) and $ff00;
  end;

 end;

end;

save(#9'dta $41,a(:2)');
save('.ENDM'#13#10);

// tutaj zmiany rastra na znakach
end else begin

{save('.MACRO'#9'SCREEN_DATA');
save(#9'ins '''+ snazwa+'.scr''');
save('.ENDM');}

save(#13#10'.MACRO'#9'ANTIC_PROGRAM');

 if gfxMode[0] in [0,2] then zm:='4' else zm:='2';

 if NoBadLines then

  save(#9'dta $4'+zm+'|$20,a(:1),'+zm)

 else begin

  save(#9'dta $4'+zm+',a(:1)');

  eol_:=false;

  save(#9'dta ');

  for i:=0 to 28 do begin

   case gfxMode[i+1] of
    0,2: zm:='4';
    1,4: begin
          zm:='2';
          if i=28 then zm:='$22';
         end;
   end;

// if NoBadLines then
//  if i and 1<>0 then zm:=zm+'|$20';

   save(zm);

   if i<>28 then save(',');
  end;


  eol_:=true;
  save('');
  save(#9'dta $41,a(:2)');

 end;

save('.ENDM'#13#10);

{
save('.MACRO'#9'FONTS');
save(#9'ins '''+ snazwa+'.fnt''');
save('.ENDM'#13#10);    }

save(brkTab+#13#10);

end;


save('CL');
for i:=0 to 255 do
 if c4Raster[i]>=0 then begin
  save(#9'.he '+AnsiString(IntToHex(c4Raster[i],2)));
 end;


zp:=0;

save(#13#10'.MACRO'#9'ZPINIT');
for i:=0 to 255 do
 if zpRaster[i]>=0 then begin
  save(#9'mva'#9'#'+form1.Hex(zpRaster[i],2)+#9'zc+'+AnsiString(IntToStr(i)));
  inc(zp);
 end;
save('.ENDM'#13#10);

save('ZCOLORS'#9'= '+AnsiString(IntToStr(zp))+#13#10);
save('FADECHR'#9'= 0');

if (SpecialStr[___FadeGED].val and (t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr])) or
   (SpecialStr[___FadeGEDplus].val and (t_mode(form1.SelectMode.ItemIndex)=m_gedp)) then begin

save('.local'#9'line'#13#10);

save(#9'ldy fcnt');
save(#9'mva ladr,y fadr');
save(#9'mva hadr,y fadr+1'#13#10);

save(#9'ldy #2');
save(#9'mva:rpl (fadr),y temp,y-'#13#10);

save(#9'ldy #0');
save(#9'mva #{jmp} (fadr),y+');
save(#9'mwa #next (fadr),y');
save(#9'rts'#13#10);

save('next'#9'ldy #2');
save(#9'mva:rpl temp,y (fadr),y-'#13#10);

save(#9'inc fcnt');
save(#9'lda fcnt');
save(#9'cmp #239');
save(#9'seq');
save(#9'jsr line'#13#10);

save(#9'jmp raster_program_end'#13#10);

save('temp'#9':3 brk'#13#10);

save('ladr'#9':240 dta l(line:1)');
save('hadr'#9':240 dta h(line:1)');
save('.endl'#13#10);

end;

save(brkTab);


ObiektyPMG;
FileClose(dane);

form1.cnv;

// skasuj niepotrzebne pliki SCR, FNT, ASM
 deletefile(form1.snazwa+'.asm');

if t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr] then begin
 deletefile(form1.snazwa+'.scr');
 deletefile(form1.snazwa+'.fnt');
end;

end else Application.MessageBox('Only 3..4 changes allowed per line'#13#13'use OPTIONS -> CHECK to find errors','Asm GED',MB_ICONERROR);
end;


procedure TForm1.Image1Click(Sender: TObject);
begin

 if FEditColors.Visible or FEditCharset.Visible or FMove.Visible or FEditPMG.Visible or FBmp2Pmg.Visible or FEditRasters.Visible or FEditPalette.Visible {or FEditColorsMap.Visible} then editDraw:=true;

end;


procedure showCUR;
begin

 if FEditCharset.Visible then
  if CurShp.X<48 then form1.kafelek(true);

end;


procedure ShowSelectCMapCell;
var i, j, x, y, ofs, cellW, cellH: integer;
    bmp: TBitmap;
begin

  cellW:=cmap_cellW shl 1;
  cellH:=cmap_cellH shl 1;

  bmp:=TBitmap.Create;

  bmp.SetSize(form1.Image4.Width, form1.Image4.Height);

  with bmp.canvas do begin
   Pen.Style:=psSolid; Brush.Style:=bsSolid;

   form1.ClrRect(bmp, transCol);

   Pen.Color := clAqua; //clSilver; // clTeal;
   Pen.Width := 1;
   Brush.Style := bsClear;

   Pen.Mode:=pmNotXor;
  end;


 ofs:=0; //CzarnyPas div cmap_cellW;

 for j := 0 to (Wysokosc*2 div cellH)-1 do
  for i := 0 to (Szerokosc*2 div cellW)-1 do

   with bmp.Canvas do
    if select_cmap[i+ofs, j] then begin

     if (i=0) or not(select_cmap[i+ofs-1, j]) then begin
      bmp.Canvas.MoveTo(i*cellW, j*cellH);
      bmp.Canvas.LineTo(i*cellW, j*cellH+cellH);
     end;

     if (j=0) or not(select_cmap[i+ofs, j-1]) then begin
      bmp.Canvas.MoveTo(i*cellW, j*cellH);
      bmp.Canvas.LineTo(i*cellW+cellW, j*cellH);
     end;

     if (i*cellW+cellW>=Szerokosc*2) or not(select_cmap[i+ofs+1, j]) then begin
      x:=i*cellW+cellW;
      if x>=Szerokosc*2 then x:=Szerokosc*2-1;

      y:=j*cellH+cellH;
      if y>=Wysokosc*2 then y:=Wysokosc*2-1;

      bmp.Canvas.MoveTo(x, j*cellH);
      bmp.Canvas.LineTo(x, y);
     end;

     if (j*cellH+cellH>=Wysokosc*2) or not(select_cmap[i+ofs, j+1]) then begin
      x:=i*cellW+cellW;
      if x>=Szerokosc*2 then x:=Szerokosc*2-1;

      y:=j*cellH+cellH;
      if y>=Wysokosc*2 then y:=Wysokosc*2-1;

      bmp.Canvas.MoveTo(i*cellW, y);
      bmp.Canvas.LineTo(x, y);
     end;

    end;

 form1.Image4.Picture.Graphic:=bmp;

 bmp.Free;
end;


procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i, j, ofs, fx, fy, lx, ly: integer;
    c0, c1, c2, s: byte;
    MousePos: TPoint;
begin

 if Pixel = 0 then exit;


 if KeyMove>0 then begin
  GetCursorPos(MousePos);

  MousePos.X:=(MousePos.X div Pixel)*Pixel;
  MousePos.Y:=(MousePos.Y shr 1) shl 1;

  case KeyMove of
    vk_left: dec(MousePos.X, Pixel shl 1);
   vk_right: inc(MousePos.X, Pixel shl 1);
      vk_up: dec(MousePos.Y, 2);
    vk_down: inc(MousePos.Y, 2);
  end;

  KeyMove:=0;

  SetCursorPos(MousePos.X, MousePos.Y);
 end;


 x:=x div 2;    // !!! DIV
 y:=y div 2;    // !!! DIV


 if y in [0..Wysokosc-1] then
  form1.StatusBar1.Panels[0].Text := StatusXY(x div Pixel,y, gfxMode[y shr 3]);

 pSel:=Point(x,y);

 if klikEdit then begin
  DrawMarquee(ptOrigin, ptMove);   // gdy zaznaczamy obszar z wcisnietym PRAWYM klawiszem myszki
  ptMove := tstPos(x,y);
 end;
              
if edit then begin                 // edit=true (EditCharset, MoveCopyPAste)

 if editDraw or klikEdit then begin
  CurShp:=Point(X shr 3 , Y shr 3);

  if jgp1.Checked then begin
   CurShp.X:=(CurShp.X shr 1) shl 1;
   CurShp.Y:=(CurShp.Y shr 1) shl 1;
  end;

  Shp:=Point(0,0);
  Cur:=CurShp;
//  Cur:=Point(CurShp.X+Shp.X , CurShp.Y+Shp.Y);

  if CurShp.X+yel_wid>48 then CurShp.X:=48-yel_wid;
  if CurShp.Y+yel_hig>30 then CurShp.Y:=30-yel_hig;

  ShowCur;

  DrawSelectMarker;           // nowa pozycja zaznaczenia 9x9 znakow

 end;

 if editDraw then begin
  editDraw:=false;
  if FEditCharset.Visible then FEditCharset.UstawPaleteKolorow;
  exit
 end;

 if klikEdit then begin
  PutChars;
  exit;
 end;

end;


 if editDraw and FEditPMG.Visible then begin
  FEditPMG.SetPosSprite(x,y);
  exit;
 end;


// zaznaczamy obszar mapy kolorow dla NEW
if FEditColorsMap.Visible and (FEditColorsMap.RadioGroup1.ItemIndex=0) and bMarquee then begin

 ofs:=0; //CzarnyPas div cmap_cellW;

 fx:=lDraw.X;
 fy:=lDraw.Y;
 lx:=x div cmap_cellW;
 ly:=y div cmap_cellH;

 if fx>lx then begin
  fx:=lx;
  lx:=lDraw.x;
 end;

 if fy>ly then begin
  fy:=ly;
  ly:=lDraw.y;
 end;

 for j := fy to ly do
  for i := fx to lx do
   select_cmap[ofs+i,j]:=true;

 ShowSelectCMapCell;

 editDraw:=false;
 exit;
end;


if editDraw and (FEditColors.Visible or FMove.Visible or FBmp2Pmg.Visible or FEditRasters.Visible or FEditPalette.Visible or FEditColorsMap.Visible) then begin

 editDraw:=false;

 if FBmp2Pmg.visible then begin
  FBmp2Pmg.slidePMG((x-CzarnyPas) shr 3);
  exit;
 end;


 if FEditColorsMap.Visible then
  if FEditColorsMap.RadioGroup1.ItemIndex=1 then begin         // EDIT Color Map
   ofs:=CzarnyPas div cmap_cellW;

   c0:=cmap[ofs+x div cmap_cellW, y div cmap_cellH].c[0];
   c1:=cmap[ofs+x div cmap_cellW, y div cmap_cellH].c[1];
   c2:=cmap[ofs+x div cmap_cellW, y div cmap_cellH].c[2];
   s:=cmap[ofs+x div cmap_cellW, y div cmap_cellH].status;

   select_cmap_cell_color[0]:=c0;
   select_cmap_cell_color[1]:=c1;
   select_cmap_cell_color[2]:=c2;
   select_cmap_cell_color[3]:=s;

   FEditColorsMap.show_cell_colors;
   FEditColorsMap.image4cmap_init;

   for j:=0 to (Wysokosc div cmap_cellH)-1 do
    for i := 0 to ((Bajt*8) div cmap_cellW)-1 do
     if (cmap[i+ofs, j].c[0]=c0) and
        (cmap[i+ofs, j].c[1]=c1) and
        (cmap[i+ofs, j].c[2]=c2) and
        (cmap[i+ofs, j].status=s) then select_cmap[i+ofs,j]:=true;

   ShowSelectCMapCell;
   //exit;
  end else begin

   ofs:=(CzarnyPas+x) div cmap_cellW;

   select_cmap[ofs, y div cmap_cellH]:=not(select_cmap[ofs, y div cmap_cellH]);

   if select_cmap[ofs, y div cmap_cellH] then begin
    c0:=cmap[ofs, y div cmap_cellH].c[0];
    c1:=cmap[ofs, y div cmap_cellH].c[1];
    c2:=cmap[ofs, y div cmap_cellH].c[2];
    s:=cmap[ofs, y div cmap_cellH].status;

    select_cmap_cell_color[0]:=c0;
    select_cmap_cell_color[1]:=c1;
    select_cmap_cell_color[2]:=c2;
    select_cmap_cell_color[3]:=s;

    FEditColorsMap.show_cell_colors;
   end;

   ShowSelectCMapCell;
  end;


 if FEditColors.Visible then begin
  FEditColors.frameLineRange1.seLine.Position:=NormalizeYPos(y);

  if Shape1.Visible then begin        // wylaczamy pionowe zaznaczenia
   Shape1.Visible:=false; Shape2.Visible:=false;
  end;

  exit;
 end;


 if FEditRasters.Visible then begin
  FEditRasters.frameLineRange1.seLine.Position:=NormalizeYPos(y);
  exit;
 end;

 if FEditPalette.Visible then begin
  FEditPalette.frameLineRange1.seLine.Position:=NormalizeYPos(y);
  exit;
 end;

 if FMove.Visible then begin
  j:=abs(FMove.udRight.Position-FMove.udLeft.Position);
  i:=x shr 3;
  if i+j>48 then i:=48-j;
  FMove.udRight.Position:=i+j;
  FMove.udLeft.Position:=i;

  FMove.frameLineRange1.seLine.Position:=y;
  exit;
 end;

end;     // editDraw

end;


procedure TForm1.SaveChanges;
begin

 if FExportAs.Visible=false then

 if SaveAfterExit {and (gate>0) and (done>0)} then begin

  case Application.MessageBox('Save changes to file G2F?','G2F',mb_YESNO+MB_ICONQUESTION) of
   idYes: begin
           SaveDialog1.FilterIndex:=2;
           SaveAs1Click(form1);
          end;

    idNo: SaveAfterExit:=false;
  end;

  SaveAfterExit:=false;
 end;

end;


procedure TForm1.SaveDialog1TypeChange(Sender: TObject);
begin
// !!! zmiana rozszerzenia nie dziala w locie, ale bez tego wogole nie bedzie zapisywal plikow

{
var
  s: string;
begin
  if SaveDialog1.FilterIndex = 1 then
    s := 'txt'
  else
    s := 'pt3';
end;
  SaveDialog1.DefaultExt := s
}

end;


procedure TForm1.Load1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* OPEN...                                                                    *)
(*----------------------------------------------------------------------------*)
var nam, ext: string;
    zm: string;
    i: integer;
begin

 SaveChanges;

 zamknij(f_Check);

// zm:=ChangeFileExt(ExtractFileName(SaveDialog1.FileName),'');
// OpenDialog1.FileName:=zm;

if OpenDialog1.Execute then begin

 zm:=OpenDialog1.FileName;

 current_filename:=zm;

 OpenDialog1.InitialDir:=zm;
 SaveDialog1.InitialDir:=zm;

 nam:=ExtractFileName(zm);
 ext:=AnsiUpperCase(ExtractFileExt(nam));

 for i:=1 to length(file_ext) do
  if ext=file_ext[i] then begin
   SaveDialog1.FilterIndex:=i;
   Break;
  end;

 OpenDialog1.FileName:=nam;
 SaveDialog1.FileName:=nam;

 RecentFile.MRUAdd(zm);
 reopen.Enabled:=true;
 
 ZapiszPath(zm);

 Refresh;

 Preview;

 if jgp1.Checked then begin
  yel_wid:=2; yel_hig:=2;
//  create_yellow_cursor
 end;

 pliki_danych(current_filename);

 first_save:=true;

// SaveAfterExit:=true;
end;

end;


procedure save_color(var f:textfile; const znk:Char);
var l, i: integer;
    a: string;
begin
 l:=0;
 for i:=0 to color_nr-1 do begin

  if l=0 then write(f,#9'dta '+znk+'(');

  a:='c'+IntToStr(i);

//  if t_mode(form1.SelectMode.ItemIndex)=m_dli then
//   if i<color_vbl then a:='NMI.'+a;

  write(f,a);

  if (l<>9) and (i<>color_nr-1) then write(f,',') else begin
   writeln(f,')');
   l:=-1;
  end;

  inc(l);
 end;

end;


procedure TForm1.DepackRES(const a,b:string);
var Res: TResourceStream;
    fn: string;
begin
 Res := TResourceStream.Create(hInstance,a,RT_RCDATA); // wyci¹gnij plik

 fn:=GetUndoName('$pack.def');

 Res.SaveToFile(fn);
 Res.Free;                                             // zwolnij zmienn¹

 form1.Depack_Zlib(fn, b);
end;


procedure TForm1.SaveASM_Routine;
var f, g: textfile;
    zm: string;
begin

 if (gate>0) then begin

  if SpecialStr[___FadeDLI].val then
   if FadeFx then
    if (FSpecial.seFirstChar.Position=0) and (FSpecial.seLastChar.Position=127) then begin
     ile_znakow:=126;
     FSpecial.seLastChar.Position:=126;
     ClearMic; form1.ShowMic; form1.Cnv;

     fade_special_char := 127;
    end else
     if FSpecial.seFirstChar.Position>0 then
      fade_special_char := FSpecial.seFirstChar.Position - 1
     else
      fade_special_char := FSpecial.seLastChar.Position + 1;


  eol_:=true; SaveAll;
  color_nr:=0;
  posx_nr:=0;
  size_nr:=0;

  if t_mode(form1.SelectMode.ItemIndex)=m_dli then begin
   form1.SaveAsmDLI;
   if SpecialStr[___FadeDLI].val and FadeFX then form1.SaveHCol;
  end else
   SaveASM;

 end;


 if t_video(form1.SelectVideo.ItemIndex)=vgtia then begin       // GTIA

 form1.DepackRES('FADING',GetUndoName('fade.$$$'));

 form1.DepackRES('FADECHR', form1.snazwa+'.pmf');

 assignfile(g,GetUndoName('fade.$$$')); FileMode:=0; reset(g);
 assignfile(f,snazwa+'.fad'); rewrite(f);

// writeln(f,'color_nr = '+IntToStr(color_nr));

 while not eof(g) do begin
  readln(g,zm);
  writeln(f,zm);
 end;

 closefile(g);

 writeln(f,#13#10#9'.use DLI,NMI');

 writeln(f,'tcol');
 save_color(f,'t');

 writeln(f,#9'dta t(0)');

 flush(f);
 closefile(f);

 end;

end;


procedure TForm1.Swap1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* SWAP WORKING AREA                                                          *)
(* tbSwap -> Style -> tbsCheck  !!! koniecznie !!!                            *)
(*----------------------------------------------------------------------------*)
var fnam, fwrk, tmp: string;
    _undo, _redo: Boolean;
    cApp: tCloseApp;
begin

 form1.zamknij(f_Zoom);

 CloseRestoreApp(true, cApp);

 swap_filename[ord(not form1.tbSwap.Down)].txt:=current_filename;
 swap_filename[ord(not form1.tbSwap.Down)].sav:=form1.SaveDialog1.FileName;

 current_filename:=swap_filename[ord(form1.tbSwap.Down)].txt;
 form1.SaveDialog1.FileName:=swap_filename[ord(form1.tbSwap.Down)].sav;


 _undo:=form1.EditUndo1.Enabled;
 _redo:=form1.EditRedo1.Enabled;

 form1.SelectPreview.ItemIndex:=ord(___ALL);

 fnam:=form1.GetUndoName('$tempbuffer$.g2f');
 fwrk:=form1.GetUndoName('$workbuffer$.g2f');

 if form1.tbSwap.Down then begin

   tmp:=form1.SaveDialog1.FileName;
   form1.SaveDialog1.FileName:=fwrk;
   form1.SaveG2F1Click(form1);
   form1.SaveDialog1.FileName:=tmp;

  if not(FileExists(fnam)) then begin
   form1.New1Click(form1);             // !!! konieczne inaczej przy braku pliku $tempbuffer$ skopiuje obrazek glowny

   tmp:=form1.SaveDialog1.FileName;
   form1.SaveDialog1.FileName:=fnam;
   form1.SaveG2F1Click(form1);
   form1.SaveDialog1.FileName:=tmp;
  end else begin

   tmp:=current_filename;
   current_filename:=fnam;
   form1.PreviewButton;
   current_filename:=tmp;
  end;

 end else begin

  tmp:=form1.SaveDialog1.FileName;
  form1.SaveDialog1.FileName:=fnam;
  form1.SaveG2F1Click(form1);
  form1.SaveDialog1.FileName:=tmp;

  tmp:=current_filename;
  current_filename:=fwrk;
  form1.PreviewButton;
  current_filename:=tmp;

  form1.pliki_danych(current_filename);
 end;

 form1.EditUndo1.Enabled:=_undo;
 form1.EditRedo1.Enabled:=_redo;

 show_title(current_filename);

 CloseRestoreApp(false, cApp);

end;


procedure TForm1.PutDraw(const x,y: integer);
begin
// form1.Image4.Picture.Bitmap:=draw;
 form1.Image4.Picture.Bitmap.Assign(draw);

 lDraw:=Point(x,y);
end;


procedure TForm1.SelectPreviewClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* PREVIEW: PMG, BMP, ALL                                                     *)
(*----------------------------------------------------------------------------*)
begin

 ZamknijBMPLimitations;

 form1.zamknij(f_EditRasters);
 form1.zamknij(f_EditColorsMap);
 form1.zamknij(f_EditBMP);

 StatusPreview;

 if FEditColors.Visible and (prev=___pmg) then zamknij(f_EditColors);

 image4.Visible:=false; image4.Cursor:=crDefault;

 ShowColorsMap1.Checked:=false;

 Prior_old:=$ff; OdswiezObraz; drawMode:=zero;

 UstawKolory;

 OdswiezObraz;

 if SelectPreview.Enabled then SelectPreview.SetFocus;

end;


procedure TForm1.SaveG2F1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* 2 bajty - Bajt, Pixel                                                      *)
(* fonty, scr, colors, sprites                                                *)
(*----------------------------------------------------------------------------*)
var x, i,j, len, plik, plik2: integer;
    zm: string;
    mapa: tablica_row;
begin
if (gate>0) and (done>0) then begin

zm:=form1.Savedialog1.FileName;
zm:=ChangeFileExt(zm, '.g2f');

plik:=FileCreate(zm);

bufor[0]:=Bajt or $80;

bufor[1]:=Pixel and 7;

if Pixel=4 then inc(bufor[1], SelectGTIA.ItemIndex);   // tryby GTIA

bufor[1]:=bufor[1] and 7;

if Normal1.Checked then bufor[1]:=bufor[1] or $80;
if Optymizing1.Checked and (FSpecial.ChrOpty.ItemIndex=0) then bufor[1]:=bufor[1] or $40;    // Optymizing Normal
if Optymizing1.Checked and (FSpecial.ChrOpty.ItemIndex=1) then bufor[1]:=bufor[1] or $20;    // Optymizing Maximum
if JGP1.Checked then bufor[1]:=bufor[1] or $10;
if JGP2.Checked then bufor[1]:=bufor[1] or $08;

bufor[2]:=Zestaw or $80;              // tablica CNVADR nie jest u¿ywana gdy bit7=1
FileWrite(plik,bufor,3);

fillchar(mapa, sizeof(mapa), 0);

// zapisz scren
for x:=0 to 29 do
 if mapa[x]=0 then FileWrite(plik,scren[Sofs(0,tmul48[x])],bajt);

fillchar(temp,sizeof(temp),$ff);
for x:=0 to 29 do
 if mapa[x]=0 then temp[table[x]]:=0;

for x:=0 to 29 do
 if temp[x]=0 then FileWrite(plik,fonty[x shl 10],1024);

// dorzuc do 'table' informacje o wymuszaniu zmiany zestawu
move(table,bufor,sizeof(table));
for x:=0 to 29 do
 if newFnt[x]>0 then bufor[x]:=bufor[x] or $80;

// zapisz table
FileWrite(plik,bufor,30);

// zapisz colors
FileWrite(plik,TabKolor,5*$100);

// zapisz sprites
FileWrite(plik,TabKolor[$500],4*$100);

FileWrite(plik,Spr0,$200); FileWrite(plik,Mis0,$200);
FileWrite(plik,Spr1,$200); FileWrite(plik,Mis1,$200);
FileWrite(plik,Spr2,$200); FileWrite(plik,Mis2,$200);
FileWrite(plik,Spr3,$200); FileWrite(plik,Mis3,$200);

FileWrite(plik,Smask,$800);

FileWrite(plik,Sprajt,240*290);
FileWrite(plik,SprajtX,240*290);

// 256 bajtow do wykorzystania
fillchar(bufor,256,0);

bufor[1]:=form1.SelectMode.ItemIndex+1;    // GED+, DLI, GED-

bufor[1]:=bufor[1] or (ord(SpecialStr[___nobadlines].val)*$80) or (ord(SpecialStr[___ModeDLIplus].val)*$40);

bufor[2]:=ord(SpecialStr[___LMSperline].val)*$80 or ord(SpecialStr[___DLIchangesIn].val)*$40 or ord(SpecialStr[___doublescan].val)*$20;


FileWrite(plik,bufor,256);

for j := 0 to Wysokosc-1 do
 for i := 0 to 11 do begin
  bufor[j*24+i*2]:=raster[j,i].cod;
  bufor[j*24+i*2+1]:=raster[j,i].arg;
 end;

FileWrite(plik,bufor,240*24);

// zastap 0 w 'gfxMode' wartoscia $FF
move(gfxMode,bufor,sizeof(gfxmode));

for x:=0 to 29 do
 if bufor[x]=0 then bufor[x]:=$FF;

FileWrite(plik,bufor,30);    //gfxMode

FileWrite(plik,bufor,240-30);

i:=FEditRasters.GlobalOfset.Position;

bufor[0]:=i+24;

FileWrite(plik,bufor,16);

FileWrite(plik,ile_znakow,1);

// zapisujemy informacje na temat zablokowanych zmian kolorow
FileWrite(plik, locKolor, $500);

// zapisujemy informacje ANTIC+ ???
bufor[0]:=SelectVideo.ItemIndex;
bufor[1]:=cmap_cellW;
bufor[2]:=cmap_cellH;

FileWrite(plik,bufor,3);

// zapisujemy mape kolorow dla VBXE
FileWrite(plik,cmap,sizeof(cmap));


bufor[0]:=min_znakow;
FileWrite(plik,bufor,1);

// zapisz invers2
for x:=0 to 29 do
 if mapa[x]=0 then FileWrite(plik,invers2[Sofs(0,tmul48[x])],bajt);

FileWrite(plik, table2, 30);

FileWrite(plik, chlimit, 128);

FileWrite(plik, raster_line_ofset, sizeof(raster_line_ofset));

bufor[0]:=ord(FSpecial.ged_a.Checked);
bufor[1]:=ord(FSpecial.ged_x.Checked);
bufor[2]:=ord(FSpecial.ged_y.Checked);

bufor[3]:=ord(FSpecial.chk_players.Checked);
bufor[4]:=ord(FSpecial.chk_missiles.Checked);

FileWrite(plik, bufor, 5);

FileWrite(plik, bufor, 14);

FileWrite(plik, bmp_limit, sizeof(bmp_limit));

FileWrite(plik, startCharset, sizeof(startCharset));


FileWrite(plik, raster, sizeof(raster));

FileWrite(plik, tgtia, sizeof(tgtia));

FileWrite(plik, locKolor, sizeof(locKolor));

bufor[0]:=row_limit;
FileWrite(plik, bufor, 1);

FileWrite(plik, chrctl_edit, sizeof(chrctl_edit));


FileClose(plik);

SaveAfterExit:=false;

end;// else PokazHelp;


if SpecialStr[___PackG2FFile].val then begin
 Pack_Zlib(zm,GetUndoName('$$$packg2f.$$$'));

 plik:= FileOpen(GetUndoName('$$$packg2f.$$$'), fmOpenRead);
 len:=FileSeek(plik, 0, 2);
 FileSeek(plik, 0, 0);

 plik2:=FileCreate(zm);

 FileWrite(plik2, g2fzlib_hea, sizeof(g2fzlib_hea));

 j:=0;
 while j<len do begin
  i:=FileRead(plik,bufor,sizeof(bufor));
  FileWrite(plik2, bufor, i);
  inc(j, i);
 end;

 FileClose(plik);
 FileClose(plik2);
end;

end;


procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var lowerleft: TPoint;
begin

 x:=x div 2;
 y:=y div 2;

 if BMPLimitations1.Checked then begin

  mbRightUse := (Button=mbRight);

  klikEdit := True;
 
  ptOrigin := tstPos(x,y);       // punkt startowy
  ptMove := ptOrigin;            // punkt koñcowy na pocz¹tku równy startowemu

 end else begin

 if FEditColorsMap.Visible and (button=mbLeft) then begin   // gdy zaznaczamy mape kolorow VBXE
  bMarquee:=true;

  lDraw:=Point(x div cmap_cellW, y div cmap_cellH);
  exit;
 end;


 if (button=mbMiddle) and FEditPMG.Visible then begin   // wlacz/wylacz mruganie duchami
  mrugaj_duchami:=not(mrugaj_duchami);

  image4.Enabled:=false;//not(mrugaj_duchami);
  image4.Visible:=mrugaj_duchami;
 end;


 if Button=mbRight then begin

  if (hscrol or vscrol.use) and (SelectPreview.ItemIndex=ord(___ALL)) then begin
   lowerLeft := Point(x*2+image1.left, y*2+image1.Top);
   lowerLeft := ClientToScreen(lowerLeft);

   PopupMenu1.Popup(lowerLeft.X, lowerLeft.Y);
   exit;
  end;

  klikEdit := True;

  if FEditCharset.Visible then begin

   form1.ZapiszUndo; SaveAfterExit:=true;

   PutChars;
   exit;
  end;

  ptOrigin := tstPos(x,y);       // punkt startowy
  ptMove := ptOrigin;            // punkt koñcowy na pocz¹tku równy startowemu
  DrawMarquee(ptOrigin,ptMove);  // gdy zaczynamy zaznaczac obszar z wcisnietym PRAWYM klawiszem myszki (EditColors itp.);

 end;

 end;

end;


procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j, k: integer;
begin

 if BMPLimitations1.Checked then begin
  ZapiszUndo; SaveAfterExit:=true;

  if ptOrigin.y > ptMove.y then begin
   k:=ptOrigin.y;
   ptOrigin.Y:=ptMove.y;
   ptMove.y:=k;
  end;

  if ptOrigin.x > ptMove.x then begin
   k:=ptOrigin.x;
   ptOrigin.x:=ptMove.x;
   ptMove.x:=k;
  end;

  for j := ptOrigin.y shr 3 to ptMove.y shr 3 do
   for i := ptOrigin.x shr 3 to ptMove.X shr 3 do
    if mbRightUse then    
     bmp_limit[i, j]:=not(bmp_limit[i, j])
    else
     bmp_limit[i, j] := true;

  OdswiezObraz;

  exit;
 end;


 if FEditColorsMap.Visible and (button=mbLeft) then begin
  bMarquee:=false;
  exit;
 end;

 if Button=mbRight then begin
  klikEdit:=false; Cnv;

  if FMove.Visible then FMove.ShowMarker;

 end;
 
end;


procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var lowerLeft: TPoint;
begin

 if Button=mbRight then begin

  lowerLeft := Point(x+image2.left, y+image2.Top);
  lowerLeft := ClientToScreen(lowerLeft);

  PopupMenu2.Popup(lowerLeft.X, lowerLeft.Y);

 end;

end;


procedure TForm1.ChangeColorsClick(Sender: TObject);
begin

 ZamknijBMPLimitations;

 zamknij(f_SelectColor);
 zamknij(f_EditBMP);
 zamknij(f_EditPMG);
 zamknij(f_Bmp2Pmg);
 zamknij(f_EditPalette);
 zamknij(f_EditColorsMap);
 zamknij(f_EditCharset);
 zamknij(f_Zoom);


 if not(ChangeColors.Checked) then begin

  Usun_Zaznaczenia(true);

  ChangeColors.Checked:=true;
  EditColors.Checked:=false;

  FEditColors.ChangeInit(t_gtia(form1.SelectGTIA.ItemIndex));

  form1.Usun_Zaznaczenia(false);

  Shape3_4Enable(true);

  FEditColors.ClientHeight := FEditColors.frameAddSkip1.Top + FEditColors.Panel2.Top;

  FEditColors.Visible:=true;

 end else
   form1.zamknij(f_EditColors);

end;


procedure TForm1.MoveCopyPasteClick(Sender: TObject);
var t,l: integer;
begin

if MoveCopyPaste.Checked then
 zamknij(f_Move)
else begin

 ZamknijBMPLimitations;

 zamknij(f_EditBMP);
 zamknij(f_Zoom);
 zamknij(f_EditColors);
 zamknij(f_EditCharset);
 zamknij(f_EditPMG);
 zamknij(f_Bmp2Pmg);
 zamknij(f_EditRasters);
 zamknij(f_EditColorsMap);

 FMove.LineChange;

 MoveCopyPaste.Checked:=true;

{
 form1.Shape1.Pen.Style:=psSolid;

 form1.Shape1.Height:=0;
 form1.Shape1.Width:=2;

 form1.Shape1.Visible:=false;
 form1.Shape2.Visible:=false;
}

 with FMove do begin
  ShowMarker;         // odswiezenie zaznaczenia

  SetFormPos('FMove', t,l);
  FMove.Top:=t;
  FMove.Left:=l;

  Visible:=true;

  seMoveX.Increment:=pixel;
  seMoveX.Position:=0;
 end;

 if prev=___bmp then SelectPreview.ItemIndex:=ord(___ALL);

 Usun_Zaznaczenia(false);
 Shape9Enable(true);

 drawMode:=SelectAlign;

end;

end;


procedure Select_pokaz(const p:TPoint; x,y:integer);
var _pdx, _pdy, i, j: integer;
begin

 x:=x*2;
 y:=y*2;

_pdx := p.X*2 * Pixel;
_pdy := p.Y*2;

i:=_pdx; j:=x;
if i>j then begin
 _pdx:=j; x:=i;
end;


i:=_pdy; j:=y;
if i>j then begin
 _pdy:=j; y:=i;
end;


 with form1 do begin
  Shape1.Left:=pozX+_pdx; //+CzarnyPas;
  Shape1.Top:=pozY+_pdy;

  Shape1.Width:=x-_pdx;
  Shape1.Height:=y-_pdy;
 end;

end;


procedure CopyBMP;
(*----------------------------------------------------------------------------*)
(* CTRL+C                                                                     *)
(*----------------------------------------------------------------------------*)
var lStream: TMemoryStream;
begin

  lStream := TMemoryStream.Create;

  lStream.Write(pMark, sizeof(pMark));
  lStream.Write(lMark, sizeof(lMark));

  form1.image1.Picture.Bitmap.SaveToStream(lStream);

  move(tab,copy_tab,sizeof(tab));

  lStream.Write(copy_tab, sizeof(copy_tab));

  lStream.SaveToFile(form1.GetUndoName(copypaste));

  lStream.Free;

end;


procedure SelectNone;
(*----------------------------------------------------------------------------*)
(* CTRL+D                                                                     *)
(*----------------------------------------------------------------------------*)
begin

   klikEdit:=false;
   bMarquee:=false;

   if drawMode=SPaste then begin
    form1.image4MouseDown(form1.image4,mbleft,[],0,0);
//    form1.image4Click(form1.image4);
    form1.image4MouseUp(form1.image4,mbleft,[],0,0);

    drawMode:=Select;
   end;

   case drawMode of
         Select, SelectAlign: begin form1.Select_OFF(false); FEditBMP.ToolSelectClick(FEditBMP.ToolSelect) end;
//    SelectAlign: begin form1.Select_OFF(false); FEditBMP.ToolSelectClick(FEditBMP.ToolSelectAlign) end;
   end;

end;


procedure SelectAll;
(*----------------------------------------------------------------------------*)
(* CTRL+A                                                                     *)
(*----------------------------------------------------------------------------*)
begin

  if drawMode<>Select then begin form1.Select_OFF(false); FEditBMP.ToolSelectClick(FEditBMP.ToolSelect) end;

  pDraw:=Point(CzarnyPas div Pixel,0);
  Select_pokaz(pDraw,CzarnyPas+Szerokosc,Wysokosc);

  pMark:=Point(CzarnyPas,0);
  lMark:=Point(CzarnyPas+Szerokosc,Wysokosc);

end;


procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin

 if FEditCharset.Visible then
  if Key=' ' then FMove.Button8Click(form1);

 if not(FEditBMP.Visible) then exit;

// ESC konczy SPaste i wraca do Select
 if (key=#27) and (drawMode=SPaste) then begin

  klikEdit:=false;
  bMarquee:=false;

  Select_OFF(false);
  FEditBMP.ToolSelectClick(FEditBMP.ToolSelect);
 end;

end;


procedure TForm1.ChangePMGClick(Sender: TObject);
begin

 ZamknijBMPLimitations;

 form1.zamknij(f_EditColors);
 form1.zamknij(f_Zoom);
 form1.zamknij(f_EditCharset);
 form1.zamknij(f_Bmp2Pmg);
 form1.zamknij(f_EditRasters);

 init_mrugania_duchow;


 if not(ChangePMG.Checked) then begin

  Usun_Zaznaczenia(true);

  ChangePMG.Checked:=true;
  EditPMG.Checked:=false;

  with FEditPMG do begin
   Caption:='Change PMG';
   Panel5.Visible:=true; panel6.Visible:=true;
   //Height:=327;

   ClientHeight := Bevel3.Top + Bevel3.Height;

   visible:=true;

   FEditPMG.ChangeDefault;
  end;

 end else
  form1.zamknij(f_EditPMG);

// image4.Visible:=true;
// image4.Enabled:=false;

end;


procedure addPal(var pal: tab_tcol256; var nc: integer; cl: TColor);
var hit: Boolean;
    x: integer;
begin

  hit:=false;

  for x:=0 to nc-1 do
   if pal[x]=cl then begin hit:=true; Break end;

  if nc<256 then
   if not(hit) then begin
    pal[nc]:=cl;
    inc(nc);
   end;

end;


procedure SaveBMP;
(*----------------------------------------------------------------------------*)
(* SAVE BMP (indexed 8bit per pixel)                                          *)
(*----------------------------------------------------------------------------*)
type
  ___bmpHeader = packed record
                    bftype:word;
                    bfsize:longint;
                    bfreserv1:word;
                    bfreserv2:word;
                    bfoffbits:longint;

                    bisize:longint;
                    biwidth:longint;
                    biheight:longint;
                    biplanes:word;
                    bibitcount:word;
                    bicompress:longint;
                    bisizeimage:longint;
                    biXPelsPerMeter:longint;
                    biYPelsPerMeter:longint;
                    biClrUsed:longint;
                    biClrImportant:longint;
                 end;

var i,j, x, nc, FileHandle: integer;
    bmpheader: ___bmpHeader;
    temp: array [0..511] of byte;
    pal: tab_tcol256;
    v: byte;
    cl: TColor;
    fnam: string;
begin

 form1.ShowMic(false);

 with bmpheader do begin
  bftype:=256*ord('M')+ord('B');
  bisize:=40;
  biwidth:=Bajt shl 3;              { szerokosc w pixlach }
  biheight:=Wysokosc;               { wysokosc }
  bfoffbits:=14+bisize+1024;
  bisizeimage:=biwidth*biheight;
  bfsize:=bfoffbits+bisizeimage;

  biClrUsed:=$100;         { liczba kolorow = max 256 }
  biClrImportant:=0;
  biXPelsPerMeter:=0;
  biYPelsPerMeter:=0;
  bfreserv1:=0;
  bfreserv2:=0;
  bicompress:=0;
  biplanes:=1;
  bibitcount:=8;           { liczba bitow na pixel }
 end;


 nc:=0;

 for i:=0 to 255 do pal[i]:=0;     // init palety

 addPal(pal, nc, AtariPal[TabKolor[$000]]);
 addPal(pal, nc, AtariPal[TabKolor[$100]]);
 addPal(pal, nc, AtariPal[TabKolor[$200]]);
 addPal(pal, nc, AtariPal[TabKolor[$300]]);
 addPal(pal, nc, AtariPal[TabKolor[$400]]);

{
pal[0]:=AtariPal[TabKolor[$000]];
pal[1]:=AtariPal[TabKolor[$100]];
pal[2]:=AtariPal[TabKolor[$200]];
pal[3]:=AtariPal[TabKolor[$300]];
pal[4]:=AtariPal[TabKolor[$400]];
}

for j:=0 to Wysokosc-1 do
 for i:=0 to (Bajt shl 3)-1 do
  addPal(pal, nc, form1.image1.Canvas.Pixels[i+CzarnyPas,j] );


 fnam:=ChangeFileExt(form1.Savedialog1.FileName, '.bmp');

 FileHandle := FileCreate(fnam);
 try

 FileWrite(FileHandle, bmpheader, sizeof(bmpheader));

 for i:=0 to 255 do begin
  temp[0]:=GetBValue(pal[i]);
  temp[1]:=GetGValue(pal[i]);
  temp[2]:=GetRValue(pal[i]);
  temp[3]:=0;

  FileWrite(FileHandle, temp,4);
 end;

 for j:=Wysokosc-1 downto 0 do begin
  for i:=0 to (Bajt shl 3)-1 do begin

   cl:=form1.image1.Canvas.Pixels[i+CzarnyPas,j];

   v:=0;
   for x:=0 to nc-1 do
    if pal[x]=cl then begin v:=x; Break end;

   temp[i]:=v;
  end;

  FileWrite(FileHandle, temp, Bajt shl 3);
 end;

 finally
  FileClose(FileHandle);
 end;

 form1.ShowMic;
end;


procedure SavePNG;
(*----------------------------------------------------------------------------*)
(* SAVE PNG (indexed 8bit per pixel)                                          *)
(*----------------------------------------------------------------------------*)
var bmp: TBitmap;
    PNG: TPNGObject;
    temp: string;
begin
 temp:=form1.Savedialog1.FileName;

 form1.Savedialog1.FileName:=GetTempName;

 SaveBMP;

 bmp:=TBitmap.Create;
 form1.Savedialog1.FileName:=ChangeFileExt(form1.Savedialog1.FileName, '.bmp');
 bmp.LoadFromFile(form1.Savedialog1.FileName);

 form1.Savedialog1.FileName:=temp;

 temp:=ChangeFileExt(temp, '.png');

 PNG := TPNGObject.Create;
  {In case something goes wrong, free booth Bitmap and PNG}
 try
   PNG.Assign(bmp);    //Convert data into png
   PNG.SaveToFile(temp);
 finally
   bmp.Free;
   PNG.Free;
 end;

end;


procedure SaveGIF;
(*----------------------------------------------------------------------------*)
(* SAVE GIF (indexed 8bit per pixel)                                          *)
(*----------------------------------------------------------------------------*)
var bmp: TBitmap;
    gif: TGIFImage;
    temp, zm: string;
begin
 temp:=form1.Savedialog1.FileName;

 form1.Savedialog1.FileName:=GetTempName;
 form1.Savedialog1.FileName:=ChangeFileExt(form1.Savedialog1.FileName, '.bmp');

 SaveBMP;

  gif := TGifImage.Create;
  try
    bmp := TBitmap.Create;
    try
      bmp.LoadFromFile(form1.Savedialog1.FileName);
      gif.Assign(bmp);
    finally
      bmp.Free;
    end;
    form1.Savedialog1.FileName:=temp;

    zm:=ChangeFileExt(temp, '.gif');

    gif.SaveToFile(zm);
  finally
    gif.Free;
  end;

 form1.Savedialog1.FileName:=temp;

end;


procedure SaveCOL;
(*----------------------------------------------------------------------------*)
(* SAVE COLORS                                                                *)
(*----------------------------------------------------------------------------*)
var f: integer;
    zm: string;
begin
 zm:=form1.Savedialog1.FileName;
 zm:=ChangeFileExt(zm, '.col');

 f:=FileCreate(zm);
 FileWrite(f,TabKolor,5*$100);
 FileClose(f);
end;


procedure SaveJGP;
var i, j: word;
    f: integer;
    zm: string;
begin
i:=StrToInt('$'+Edit5Text);
j:=i+$800-1;

bufor[0]:=$ff; bufor[1]:=$ff;
bufor[2]:=byte(i and $ff); bufor[3]:=byte(i shr 8);
bufor[4]:=byte(j and $ff); bufor[5]:=byte(j shr 8);

zm:=form1.Savedialog1.FileName;
zm:=ChangeFileExt(zm, '.jgp');

form1.ZnakCheck(ccJgp1);
form1.cnv;

if not(form1.JGP1.Checked) then exit;

f:=FileCreate(zm);
FileWrite(f,bufor,6);

i:=ileFnt(0);
fillchar(bufor,1024,0);
move(fonty,bufor,i shl 3);
FileWrite(f,bufor,1024);

i:=ileFnt(1);
fillchar(bufor,1024,0);
move(fonty[1024],bufor,i shl 3);
FileWrite(f,bufor,1024);

FileClose(f);

SaveAfterExit:=false;
end;


procedure TForm1.SaveXEX1Click(Sender: TObject);
var roz, tmp, plik: string;
begin

if gate>0 then begin

 plik:=snazwa;

 tmp:=current_filename;
 SaveDialog1.FileName:=GetUndoName('$$$xex$$$');
 current_filename:=SaveDialog1.FileName;
 pliki_danych(current_filename);

 SaveASM_Routine;

 if t_mode(SelectMode.ItemIndex)=m_dli then roz:='.asm' else roz:='.asq';

 DepackRES('ATARIH', GetUndoName('atari.h'));
 DepackRES('MADS', GetUndoName('mads.exe'));
 DepackRES('EXOM', GetUndoName('exomizer.exe'));

 form1.Caption:='Please wait...';

 if SpecialStr[___PackXEXFile].val and (t_video(form1.SelectVideo.ItemIndex)=vgtia) then begin
  Execute('mads.exe', GetUndoName(''), '"'+snazwa+roz+'" -o:exo$$$.obx -xi:"'+GetUndoName('')+'"', false);
  Execute('exomizer.exe', GetUndoName(''), 'sfx sys -t 168 -Di_table_addr=0x0600 -q -x "sty $d017" exo$$$.obx -o "'+plik+'.xex"', false);
 end else
  Execute('mads.exe', GetUndoName(''), '"'+snazwa+roz+'" -o:"'+plik+'.xex'+'" -xi:"'+GetUndoName('')+'"', false);


{ deletefile(snazwa+'.tab');
 deletefile(snazwa+'.all');
 deletefile(snazwa+'.lab');
 deletefile(snazwa+'.lst');
 deletefile(snazwa+'.asm');
 deletefile(snazwa+'.asq');
 deletefile(snazwa+'.scr');
 deletefile(snazwa+'.fnt');
 deletefile(snazwa+'.raw');
 deletefile(snazwa+'.fad');
 deletefile(snazwa+'.pmf');
 deletefile(snazwa+'.cmp');
 deletefile(snazwa+'.h');
 deletefile(snazwa+'.vbx');
}

 SaveDialog1.FileName:=tmp;
 current_filename:=tmp;
 pliki_danych(current_filename);

 show_title(current_filename);

 form1.Refresh;

end;

end;


procedure SaveLMT;
(*----------------------------------------------------------------------------*)
(* SAVE Optymizing Limitations                                                *)
(*----------------------------------------------------------------------------*)
var f: integer;
    zm: string;
begin

 zm:=form1.Savedialog1.FileName;
 zm:=ChangeFileExt(zm, '.lmt');

 f:=FileCreate(zm);

 FileWrite(f, bmp_limit, sizeof(bmp_limit));

 FileClose(f);
end;


procedure TForm1.SaveMIC1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* SAVE MIC                                                                   *)
(*----------------------------------------------------------------------------*)
var i, j, f: integer;
    zm: string;
begin
 zm:=form1.Savedialog1.FileName;
 zm:=ChangeFileExt(zm, '.mic');

 f:=FileCreate(zm);

 for i:=0 to 29 do
  if gfxMode[i]<>0 then
   for j:=0 to 7 do FileWrite(f,tab[tmul48[i*8+j]+CzarnyPas shr 3],Bajt);


 if t_gtia(form1.SelectGTIA.ItemIndex) in [gr10] then begin

  for i := 0 to 8 do FileWrite(f,tabKolor[i * $100],1);

 end else
  for i := 0 to 3 do FileWrite(f,tabKolor[i * $100],1);

 FileClose(f);
end;


procedure TForm1.Check1Execute(Sender: TObject);
var t,l: integer;
begin

 if Check1.Checked then
  form1.zamknij(f_Check)
 else begin

  form1.Zamknij(f_EditCharset);

  Shape9Enable(true);

  drawMode:=nul;

  SelectArea.Top:=0;
  SelectArea.Height:=0;
  SelectArea.Left:=0;
  SelectArea.Width:=768+1;

  SetFormPos('FCheck', t,l);
  FCheck.top:=t;
  FCheck.left:=l;

  FCheck.ListBox1.Clear;
  FCheck.Visible:=true;
  Check1.Checked:=true;

  Analyzing;
  cnv;
 end;

end;


procedure TForm1.SelectModeClick(Sender: TObject);
(*-----------------------------------------------------------------------------*)
(* Select Mode (Ged+, Dli, Ged-)                                               *)
(*-----------------------------------------------------------------------------*)
var i{, j}: integer;
//    a, b: byte;
begin

// SelectPreview.ItemIndex:=ord(___ALL);

 form1.zamknij(f_Check);

 UstawMode;

 StatusMode;


 i:=SelectScreen.ItemIndex;
 SelectScreen.Items.Clear;
 SelectScreen.Items.Add('Narrow'); SelectScreen.Items.Add('Normal');


 case t_mode(SelectMode.ItemIndex) of

  m_dli:
       begin                                        // DLI
        form1.zamknij(f_EditRasters);

        EditRasters.Enabled:=false;

        EditCharset.Enabled:=true;

//        i:=SelectScreen.ItemIndex;
//        SelectScreen.Items.Clear;
//        SelectScreen.Items.Add('32 byte'); SelectScreen.Items.Add('40 byte');
        SelectScreen.Items.Add('Wide');
        SelectScreen.ItemIndex:=i;

        if SpecialStr[___ModeDliplus].val then fox1:=true;

       end;

  m_gedp, m_gedm, m_pgr, m_piccolo:
       begin                                        // GED+, GED--
        EditRasters.Enabled:=true; //charset2.Enabled:=false;

        if t_mode(SelectMode.ItemIndex) = m_piccolo then ZnakCheck(ccStandard);

//        i:=SelectScreen.ItemIndex;
//        SelectScreen.Items.Clear;
//        SelectScreen.Items.Add('32 byte'); SelectScreen.Items.Add('40 byte');
        if i>1 then i:=1; SelectScreen.ItemIndex:=i;

        fox1:=false;
       end;

 end;

 UstawPGR;

// if t_mode(SelectMode.ItemIndex)=m_gedm then
//  SelectPixel.Items.Strings[1]:='2-4Col'
// else
//  SelectPixel.Items.Strings[1]:='2-5Col';

 OdswiezObraz;
 UstawKolory;

 ShowPixelHint;

 if SelectMode.Enabled then SelectMode.SetFocus;
end;


procedure TForm1.SelectVideoClick(Sender: TObject);
begin

 form1.zamknij(f_EditColors);
 form1.zamknij(f_EditColorsMap);

 case t_video(SelectVideo.ItemIndex)  of
  vgtia:
     begin                             // ANTIC+GTIA
      if MenuEdit.Visible then SelectMode.Enabled:=true;

      if done>0 then begin
       EditColorsMap.Enabled:=false;
       ShowColorsMap1.Enabled:=false;
      end;

     end;

  vbxe:
     begin                             // ANTIC+VBXE
      SelectMode.ItemIndex:=ord(m_dli);

      SelectMode.Enabled:=false;

      SpecialUpdate;

      if done>0 then begin
       EditColorsMap.Enabled:=true;
       ShowColorsMap1.Enabled:=true;
      end;

     end;

 end;

OdswiezObraz;
UstawKolory;

resolution_info;
end;


procedure TForm1.EditRastersExecute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* EDIT RASTERS                                                               *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin

 if not(t_mode(SelectMode.ItemIndex)=m_dli) then
  if not(EditRasters.Checked) then begin

    ZamknijBMPLimitations;

    zamknij(f_Zoom);
    zamknij(f_SelectColor);
    zamknij(f_EditCharset);
    zamknij(f_Move);
    zamknij(f_EditPMG);
    zamknij(f_Bmp2Pmg);
    zamknij(f_EditPalette);

    fillchar(bufor,256,0);
    fillchar(bufor[$100],256,22);

    EditRasters.Checked:=true;

    SetFormPos('FEditRasters', t,l);
    FEditRasters.top:=t;
    FEditRasters.left:=l;

    with FEditRasters do
    if t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo] then begin
     Panel2.Width:=29*60;
     Width:=17*60+12+168;
     ScrollBox1.Width:=Width-168-16;

     FEditRasters.TabSheet1.TabVisible:=true;

     FEditRasters.PageControl1.TabIndex:=1;

    end else begin
     Panel2.Width:=13*60-2;
     Width:=13*60+168+14;
     ScrollBox1.Width:=Width;

     FEditRasters.TabSheet1.TabVisible:=false;

     FEditRasters.PageControl1.TabIndex:=0;
    end;


    FEditRasters.PageControl1.Width:=FEditRasters.Width;

    FEditRasters.visible:=true;
    
    Usun_Zaznaczenia(true);

    UstawKolory;

    SaveAfterExit:=false;

  end else form1.zamknij(f_EditRasters);

end;


procedure SaveDAT(const _asm: Boolean);
var i: integer;
    zm: string;
begin

 initPMGData;

 zm:=form1.Savedialog1.FileName;

 if _asm then
  zm:=ChangeFileExt(zm, '.asm')
 else
  zm:=ChangeFileExt(zm, '.dat');

 dane:=FileCreate(zm);

// move(Smask,SmaskX,$800);

 if FSpecial.Colbak.Checked then begin

  move(TabKolor,bufor,256);
  if _asm then begin
   save('colbak');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[16].Checked then begin

  move(TabKolor[$100],bufor,256);
  if _asm then begin
   save('colpf0');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[17].Checked then begin

  move(TabKolor[$200],bufor,256);
  if _asm then begin
   save('colpf1');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[18].Checked then begin

  move(TabKolor[$300],bufor,256);
  if _asm then begin
   save('colpf2');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[19].Checked then begin

  move(TabKolor[$400],bufor,256);
  if _asm then begin
   save('colpf3');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[0].Checked then begin

  for I := 0 to 239 do bufor[i]:=PMG_hpos(Spr0[i]);
  if _asm then begin
   save('hposp0');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[1].Checked then begin

  for I := 0 to 239 do bufor[i]:=PMG_hpos(Spr1[i]);
  if _asm then begin
   save('hposp1');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[2].Checked then begin

  for I := 0 to 239 do bufor[i]:=PMG_hpos(Spr2[i]);
  if _asm then begin
   save('hposp2');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[3].Checked then begin

  for I := 0 to 239 do bufor[i]:=PMG_hpos(Spr3[i]);
  if _asm then begin
   save('hposp3');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[4].Checked then begin

  for I := 0 to 239 do bufor[i]:=PMG_hpos(Mis0[i]);
  if _asm then begin
   save('hposm0');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[5].Checked then begin

  for I := 0 to 239 do bufor[i]:=PMG_hpos(Mis1[i]);
  if _asm then begin
   save('hposm1');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[6].Checked then begin

  for I := 0 to 239 do bufor[i]:=PMG_hpos(Mis2[i]);
  if _asm then begin
   save('hposm2');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[7].Checked then begin

  for I := 0 to 239 do bufor[i]:=PMG_hpos(Mis3[i]);
  if _asm then begin
   save('hposm3');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[8].Checked then begin

  move(TabKolor[$500],bufor,256);
  if _asm then begin
   save('colpm0');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[9].Checked then begin

  move(TabKolor[$600],bufor,256);
  if _asm then begin
   save('colpm1');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[10].Checked then begin

  move(TabKolor[$700],bufor,256);
  if _asm then begin
   save('colpm2');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 if sdat_checkbox[11].Checked then begin

  move(TabKolor[$800],bufor,256);
  if _asm then begin
   save('colpm3');
   PutData(15);
   save('');
  end else
   FileWrite(dane, bufor, 240);

 end;


 save_pmg_data(FSpecial.Missiles.Checked, sdat_checkbox[12].Checked, sdat_checkbox[13].Checked, sdat_checkbox[14].Checked, sdat_checkbox[15].Checked, _asm);


 if FSpecial.Charsets.Checked then begin

  save('');

  fillchar(temp, sizeof(temp), $ff);

  for i:=0 to 29 do temp[table[i]]:=0;

  for i := 0 to 127 do
   if temp[i]=0 then begin

    move(fonty[temp[i] shl 10],bufor,1024);
    if _asm then begin
     save('charset'+AnsiString(IntToStr(temp[i])));
     PutData(64);
     save('');
    end else
     FileWrite(dane, bufor, 1024);

   end;

 end;

 FileClose(dane);

end;


procedure SaveFile;
//  1 - BMP Windows Bitmap (*.bmp)
//  2 - G2F Graph2Font file (*.g2f)
//  3 - MIC Micropaint (*.mic)
//  4 - XEX Atari Executable (*.xex)
//  5 - COL Colors (*.col)
//  6 - PMG Player-Missile Graphics (*.pmg)
//  7 - JGP Jet Graphics Planner (*.jgp)
//  8 - ASM Assembler file (*.asm)
//  9 - VSC Vertical Scroll (*.vsc)
// 10 - PNG Portable Net (*.png)
// 11 - MCH (*.mch)
// 12 - GIF Compuserve GIF (*.gif)
// 13 - DAT All data (*.dat)
// 14 - ASM All data (*.asm)
// 15 - LMT Optymizing limitations (*.lmt)
// 16 - RAS Raster program (*.ras)
// 17 - PAS Simple Pascal program (*.pas)
// 18 - PAS Full Pascal program (*.pas)
// 19 - PAS Player-Missile Graphics (*.pas)
// 20 - ASM Player-Missile Graphics (*.asm)

begin


 case form1.SaveDialog1.FilterIndex of

  1: SaveBMP;

  2: begin
      form1.pliki_danych(form1.SaveDialog1.FileName);

      form1.SaveG2F1Click(form1);

      if SpecialStr[___SaveG2FandXEX].val then form1.SaveXEX1Click(form1);
     end;

  3: form1.SaveMIC1Click(form1);

  4: begin
//      pliki_danych(SaveDialog1.FileName);

      form1.SaveXEX1Click(form1);

      if SpecialStr[___SaveXEXandG2F].val then form1.SaveG2F1Click(form1);
     end;

  5: SaveCOL;
  6: SavePMG;
  7: SaveJGP;

  8: begin
      form1.pliki_danych(form1.SaveDialog1.FileName);
      form1.SaveASM_Routine;
     end;

  9: SaveVSC;
 10: SavePNG;
 11: SaveMCH;
 12: SaveGIF;

 13: SaveDAT(false);
 14: SaveDAT(true);

 15: SaveLMT;

 16: SaveRAS;

 17: begin
      form1.pliki_danych(form1.SaveDialog1.FileName);

      SavePASMini;
     end;

 18: begin
      form1.pliki_danych(form1.SaveDialog1.FileName);

      form1.SavePASFull;
     end;

 19: begin
      form1.pliki_danych(form1.SaveDialog1.FileName);

      form1.SavePMG_PAS;
     end;

 20: begin
      form1.pliki_danych(form1.SaveDialog1.FileName);

      form1.SavePMG_ASM;
     end;

 end;

 current_filename:=ChangeFileExt(current_filename, '.g2f');

 form1.SaveDialog1.FileName:=current_filename;
 form1.SaveDialog1.InitialDir:=form1.SaveDialog1.FileName;
 form1.SaveDialog1.FilterIndex:=2;

 form1.pliki_danych(current_filename);

 show_title(current_filename);

end;


procedure TForm1.Save1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* SAVE (CTRL+S)                                                              *)
(*----------------------------------------------------------------------------*)
begin

 if not(first_save) then begin
  form1.SaveDialog1.FilterIndex:=2;
  SaveAs1Click(self);
 end else begin
  SaveDialog1.FileName:=current_filename;
  SaveDialog1.InitialDir:=SaveDialog1.FileName;
  SaveFile;
  SaveAfterExit:=false;
 end;

end;


procedure TForm1.SaveAs1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* SAVE AS...                                                                 *)
(*----------------------------------------------------------------------------*)
var zm: string;
begin

 zamknij(f_Check);

 zm:=ChangeFileExt(ExtractFileName(SaveDialog1.FileName),'');
 SaveDialog1.FileName:=zm;

 SaveDialog1.DefaultExt:=AnsiLowerCase(copy(file_ext[SaveDialog1.FilterIndex],2,3));


 if SaveDialog1.Execute then begin

  current_filename:=SaveDialog1.FileName;          // !!! koniecznie

  SaveDialog1.InitialDir:=SaveDialog1.FileName;

  show_title(SaveDialog1.FileName);

 // ZapiszPath(SaveDialog1.FileName);

  SaveFile;

  first_save:=true;

 end;

 form1.refresh;
end;


procedure SetLabelColor(const i:integer);
var s: string;
begin

  Application.CancelHint;

  if t_mode(form1.SelectMode.ItemIndex) in [m_gedp,m_dli, m_piccolo] then begin
   s:=IntToStr(table[i]);
   while length(s)<2 do s:='0'+s;

   form1.image2.Hint:='Pixel = '+IntToStr(gfxMode[i]);
   form1.image3.Hint:='Charset #'+s;
   form1.image7.Hint:='CHRCTL = '+IntToStr(chrctl[i]);
  end else begin
   form1.image2.Hint:='';
   form1.image3.Hint:='';
   form1.Image7.Hint:='';
  end;

end;


procedure TForm1.Image3Click(Sender: TObject);
var y: integer;
    v: byte;
begin

if MenuScreen.Visible then begin

 y:=psOriginal.y shr 3;

 SaveAfterExit:=true; ZapiszUndo;

 case TImage(Sender).Tag of
  0:

  if psRight then begin
   startCharset[y]:=psOriginal2.Y;
   ustawStartCharset(y);

   ShowChars(0,29, false);
  end else

  if t_mode(SelectMode.ItemIndex) in [m_gedp,m_dli] then begin
   newFnt[y]:=newFnt[y] xor $ff;
//   cnv;
   ShowChars(0,29, false);
  end;

  1:
  begin

   v:=gfxMode[y];

   case v of
     0: v:=1;
     1: v:=2;
     2: v:=4;
     4: v:=0;
   end;

   form1.zamknij(f_Zoom);

   gfxMode[y]:=v;

   ustawMemo;

   ShowChars(0,29, true);
//   OdswiezObraz;

   if (y=cur.Y) and (FEditCharset.Visible) then FEditCharset.UstawPaleteKolorow;

   UstawKolory;

   if FEditColors.Visible then FEditColors.LineChange;
   if FEditPMG.Visible then FEditPMG.LineChange;
   if FEditRasters.Visible then begin FEditRasters.LineChange; FEditRasters.ZakresRastra end;

  end;

 end;

 SetLabelColor(y);

end;

end;


procedure TForm1.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 if UseChar then begin

  if Button=mbRight then psRight:=not(psRight);

  UstawMemo;

  image5.Visible:=psRight;

 end;

end;


procedure TForm1.Image3MouseEnter(Sender: TObject);
begin
 shape5.Visible:=true;
end;

procedure TForm1.Image3MouseLeave(Sender: TObject);
begin
 shape5.Visible:=false;
end;


procedure TForm1.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i: integer;
begin

 y:=y shr 1;

 form1.StatusBar1.Panels[0].Text:=form1.StatusXY(0,y,1);

 i:=y shr 3;

 if i<>(psOriginal.Y shr 3) then SetLabelColor(i);

 psOriginal:=Point(0,y);

 if shape5.Visible then shape5.Top:=pozY+i shl 4;
 if image5.Visible then image5.Top:=pozY+i shl 4;

end;


procedure Wyjscie;
begin
 SaveAfterExit:=false;

 img1.Free;
 draw.Free;
 wycinek.Free;
 zomek.Free;
 atasciiChar.Free;
 bmpChar.Free;
 bmpPal.Free;

 bmpPen.Free;

 form1.Close;

end;


procedure TForm1.Koniec1Click(Sender: TObject);
var i: integer;
begin
 if SaveAfterExit and (gate>0) and (done>0) then begin
  i:=Application.MessageBox('Save changes to file G2F?','Exit',mb_YESNO+MB_ICONQUESTION);
  case i of
   idYes: begin
           form1.SaveDialog1.FilterIndex:=2;
           Form1.SaveAs1Click(form1); wyjscie;
          end;
    idNo: wyjscie;
   end;
 end else wyjscie;
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var i: integer;
begin
 if SaveAfterExit and (gate>0) and (done>0) then begin
  i:=Application.MessageBox('Save changes to file G2F?','Exit',mb_YESNOcancel+MB_ICONQUESTION);
  case i of
   idYes: begin
           form1.SaveDialog1.FilterIndex:=2;
           Form1.SaveAs1Click(form1); img1.free;

           if vscrol.use then FileClose(fvsc);

           if hscrol then begin
            FileClose(fhtab);
            FileClose(fhscr);
            FileClose(fhinv);
           end;

           CanClose:=true;
          end;
    idNo: CanClose:=true;
    idCancel: CanClose:=false;
   end;
 end else CanClose:=true;
end;


procedure TForm1.Image6MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 y:=y shr 1;

 StatusBar1.Panels[0].Text:=form1.StatusXY(0,y,1);

 if x div 9<>labColor.X then begin

  labColor:=Point(x div 9,y);

  Application.CancelHint;

  if FEditPMG.Visible then begin

   if labColor.X=4 then
    Image6.Hint:='Color3'
   else
    Image6.Hint:=format('ColPM%d', [labColor.X]);

  end else
   if labColor.X=0 then
    Image6.Hint:='Colbak'
   else
    Image6.Hint:=format('Color%d', [labColor.X - 1]);

 end;

end;


procedure TForm1.Image7Click(Sender: TObject);
// CHRCTL
var v, y, i, old: byte;
begin

 if UseChar then begin

 Zamknij(f_Zoom);

 y:=psOriginal.y shr 3;

 SaveAfterExit:=true; ZapiszUndo;

 v:=chrctl_edit[y];
 old:=v;

 case v of
  1: v:=2;
  2: v:=3;
  3: v:=4;
  4: v:=1;
 end;

 for i:=y to 29 do
  if chrctl_edit[i]=old then
   chrctl_edit[i]:=v
  else
   Break;

 ustawMemo;
 ShowChars(0,29, true);

 SetLabelColor(y);
 end;

end;


procedure TForm1.Image7MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i: integer;
begin
 i:=y shr 4;

 psOriginal:=Point(0,y shr 1);

 if shape5.Visible then shape5.Top:=pozY+i shl 4;
 if image5.Visible then image5.Top:=pozY+i shl 4;

end;


procedure TForm1.ClickPreviewBMP;
begin
 PoprawBmp:=false;
// hig:=hig_old;
 LoadBmp;
end;


function GetPointOnCurve(t: Single): TPointF;
// CubicBezierCurve
var s: single;
begin

  s := 1 - t;
  
  Result.x := Points[0].x*S*S*S +
              Points[1].x*3*S*S*t +
              Points[1].x*3*S*t*t +
              Points[2].x*t*t*t;

  Result.y := Points[0].y*S*S*S +
              Points[1].y*3*S*S*t +
              Points[1].y*3*S*t*t +
              Points[2].y*t*t*t;
end;


procedure DrawBezier(const c: TCanvas);
var Pt: TPointF;
    i: byte;
    k: integer;
    tPoly: array of TPoint;

const
 ASegments = 20;

begin

   //Get first point
    Pt := GetPointOnCurve(0.0);

    SetLength(tPoly, 2);

    tPoly[0]:=Point( Round(Pt.x), Round(Pt.y) );

    lastDraw:=Rect(0,Round(Pt.y),0,Round(Pt.y));

    for I := 0 to ASegments - 1 do begin
     Pt := GetPointOnCurve( (I+1) / ASegments );

     k:=High(tPoly);
     tPoly[k]:=Point( Round(Pt.x), Round(Pt.y) );
     SetLength(tPoly, k+2);

     lastDraw.Top:=Min(lastDraw.Top, Round(Pt.y));
     lastDraw.Bottom:=Max(lastDraw.Bottom, Round(Pt.y));

    end;

    SetLength(tPoly, High(tPoly));

    c.Polyline(tPoly);

end;


procedure SetPenBitmap;
var a,b, i: byte;
    bmp: TBitmap;
    P: PPixelRec;
    cl: TColor;
begin

  bmpPen.SetSize(8,8);                           // domyslny rozmiar dla PEN-a
{
  if PrawyPrzycisk=1 then begin

   for b := 0 to 7 do begin                      // Solid
    P:=bmpPen.ScanLine[b];

    cl:=AtariPal[palCol[0 xor PrawyPrzycisk]];

    for a := 0 to 7 do begin

     P^.R:=GetRValue(cl);
     P^.G:=GetGValue(cl);
     P^.B:=GetBValue(cl);

     inc(P);
    end;
   end;

  end else begin
}
   bmp:=TBitmap.Create;
   form1.ImageList4.GetBitmap(pisPat, bmp);

   for b := 0 to 7 do begin                      // Brush

    P:=bmpPen.ScanLine[b];

    for a := 0 to 7 do begin
     i:=ord(bmp.Canvas.Pixels[a,b]<>0);
     cl:=AtariPal[palCol[0 xor PrawyPrzycisk xor i]];

     P^.R:=GetRValue(cl);
     P^.G:=GetGValue(cl);
     P^.B:=GetBValue(cl);

     inc(P);
    end;
   end;

   bmp.Free;

//  end;


      with draw.Canvas do begin
//        Pen.Style:=psClear;

        lb.lbStyle:=BS_SOLID or BS_PATTERN;

        lb.lbHatch:=bmpPen.Handle;

        MyPen.Handle:=ExtCreatePen(penStyle,selMod[0]+1,lb,0,nil);
        Pen.Assign(MyPen);

//        Brush.Style:=bsClear;      // !!! koniecznie aby wyzerowac fillowanie
//        Brush.Color:=clNone;
      end;

end;


procedure TForm1.Image4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var i, j, RadiusOfCircle: integer;
    MyRect, MyOther: TRect;
    rad, a: Single;
    MousePos: TPoint;
    eor: integer;
begin

 if Pixel = 0 then exit;


 if (FEditBMP.Visible) and (KeyMove>0) then begin
  GetCursorPos(MousePos);
  MousePos.X:=(MousePos.X div Pixel)*Pixel;
  MousePos.Y:=(MousePos.Y div 2)*2;

  eor:=ord(drawMode=SelectAlign)*6;

  case KeyMove of
    vk_left: dec(MousePos.X,Pixel*2+eor);
   vk_right: inc(MousePos.X,Pixel*2+eor);
      vk_up: dec(MousePos.Y,2+eor);
    vk_down: inc(MousePos.Y,2+eor);
  end;

  KeyMove:=0;

  SetCursorPos(MousePos.X, MousePos.Y);
 end;


 Shape3.Top:=y+form1.image1.top;
 Shape4.Left:=x+form1.image1.Left;


 x:=x div 2;      // !!! DIV
 y:=y div 2;      // !!! DIV

 if ssShift in Shift then begin
  x:=(x shr 3) shl 3;
  y:=(y shr 3) shl 3;
 end;


 if y in [0..Wysokosc-1] then
  form1.StatusBar1.Panels[0].Text := StatusXY(x div Pixel, y, gfxMode[y shr 3]);

 movePix:=Point(x,y);


 if y<drawSelect.x then drawSelect.x:=y;
 if y>drawSelect.y then drawSelect.y:=y;


 if drawMode=SPaste then begin         // przemieszczamy zaznaczony fragment grafiki

  FEditBMP.ClrDraw(true);

  PutDraw(0,0);

  i:=wycinek.Width;
  j:=wycinek.Height;

  x:=(x-mOfset.x) div Pixel;
  y:=y-mOfset.y;

  MyRect := Rect(X,Y,X+i div Pixel,Y+j);
  MyOther := Rect(0,0,i,j);

  Select_OFF(false);
  //select_pokaz(Point(x,y), x*Pixel+i, Y+j);

  image4.Canvas.CopyRect(MyRect,wycinek.Canvas,MyOther);
  exit;
 end;


 if drawMode in [Tekst, TekstAtari] then begin
  Shape1.Left  := movePix.X shl 1+pozX;
  Shape1.Top   := movePix.Y shl 1+pozY;

  Shape1.Width := TekstWidth shl 1;
  Shape1.Height:= TekstHeight shl 1;

  exit;
 end;


if bMarquee then begin

 px:=x div Pixel;

 case drawMode of

  Select, SelectAlign:
     begin
      FEditBMP.ClrDraw(true);

      PutDraw(0,0);

      X:=(X div Pixel)*Pixel;

      if ssShift in Shift then begin       // ALIGN TO CHAR
       eor:=((8 div Pixel)-1) xor $ff + $ff00;

       pDraw.X:=pDraw.X and eor;
       pDraw.Y:=pDraw.Y and $fff8;
       x:=x and $fff8;
       y:=y and $fff8;
       px:=px and eor;
      end;

      Select_pokaz(pDraw,x,y);

      pMark:=Point({CzarnyPas+}pDraw.X*Pixel,pDraw.Y);
      lMark:=Point({CzarnyPas+}pX*Pixel,Y);

     end;

  FDraw:
     begin
      FEditBMP.ClrDraw(false);

      SetPenBitmap;

      draw.Canvas.Polyline([pDraw, Point(pX,Y)]);

      PutDraw(px,y);
      pDraw:=Point(px,y);
      SaveAfterExit:=true;
     end;

  RColor:
     begin
      FEditBMP.ClrDraw(false);

      draw.Canvas.Polyline([pDraw, Point(pX,Y)]);

      PutDraw(px,y);
      pDraw:=Point(px,y);
      SaveAfterExit:=true;
     end;


  Bezier:
     begin
      FEditBMP.ClrDraw(true);

  // Control points

      points[1] := Point(px, y);

     // draw.Canvas.PolyBezier([Points[0],Points[1],Points[1],Points[2]]);

      SetPenBitmap;

      DrawBezier(draw.Canvas);

      PutDraw(px,y);
      SaveAfterExit:=true;

     end;

  BezierLine:
     begin
      FEditBMP.ClrDraw(true);

  // Initial point

      points[0] := pDraw;

  // Final point

      points[2] := Point(pX,y);

  // Control points

      SetPenBitmap;

      draw.Canvas.PolyLine([Points[0],Points[2]]);

      PutDraw(px,y);
      SaveAfterExit:=true;

     end;

  Line:
     begin
    // LINE
      FEditBMP.ClrDraw(true);

      SetPenBitmap;

      draw.Canvas.Polyline([pDraw, Point(pX,Y)]);

      PutDraw(px,y);
      SaveAfterExit:=true;
     end;

 { Gradient:
     begin
    // Gradient
      FEditBMP.ClrDraw(true);

      draw.Canvas.Rectangle(pDraw.X,pDraw.Y,px,y);

      PutDraw(px,y);
      SaveAfterExit:=true;
     end;
}

(*----------------------------------------------------------------------------*)
(* RECTANGLE, ROUNDED RECTANGLE                                               *)
(*----------------------------------------------------------------------------*)
  Rec, RRec:
     begin
      FEditBMP.ClrDraw(true);

      if ssShift in Shift then begin       // SQUARE

       RadiusOfCircle:=round(sqrt ( sqr(pDraw.X-px) + sqr(pDraw.Y-y) ));

       MyRect.Top := pDraw.Y;
       MyRect.Left := pDraw.X;
       MyRect.Bottom := pDraw.Y + RadiusOfCircle*Pixel;
       MyRect.Right := pDraw.X + RadiusOfCircle;

      end else begin                       // RECTANGLE

       MyRect.Top := pDraw.Y;
       MyRect.Left := pDraw.X;
       MyRect.Bottom := y;
       MyRect.Right := px;

      end;

      SetPenBitmap;

      if drawMode=RRec then
       draw.Canvas.RoundRect(MyRect.Left, MyRect.Top, MyRect.Right, MyRect.Bottom,abs(MyRect.Left-MyRect.Right) shr 1,abs(MyRect.Top-MyRect.Bottom) shr 1)
      else
       draw.Canvas.Rectangle(MyRect.Left, MyRect.Top, MyRect.Right, MyRect.Bottom);

      lastDraw:=MyRect;

      PutDraw(px,y);
      SaveAfterExit:=true;
     end;

(*----------------------------------------------------------------------------*)
(* ELLIPSE, CIRCLE                                                            *)
(*----------------------------------------------------------------------------*)
  Elipse:
     begin
      FEditBMP.ClrDraw(true);

      if ssShift in Shift then begin       // CIRCLE

       RadiusOfCircle:=round(sqrt ( sqr(pDraw.X-px) + sqr(pDraw.Y-y) ));

       MyRect.Top := pDraw.Y - RadiusOfCircle*Pixel;
       MyRect.Left := pDraw.X - RadiusOfCircle;
       MyRect.Bottom := pDraw.Y + RadiusOfCircle*Pixel;
       MyRect.Right := pDraw.X + RadiusOfCircle;

      end else begin                       // ELLIPSE

       i:=abs(px-pDraw.x);
       j:=abs(y-pDraw.Y);

       MyRect.Top := pDraw.Y - j;
       MyRect.Left := pDraw.X - i;
       MyRect.Bottom := pDraw.Y + j;
       MyRect.Right := pDraw.X + i;

      end;

      SetPenBitmap;

      draw.Canvas.Ellipse(MyRect);

      lastDraw:=MyRect;

      PutDraw(px,y);
      SaveAfterExit:=true;
     end;

 Lines:
     begin
      FEditBMP.ClrDraw(true);

      BlokujDraw:=true;

      SetPenBitmap;
      
      draw.Canvas.Polyline([pDraw, Point(pX,Y)]);

      PutDraw(px,y);
      SaveAfterExit:=true;
     end;

 Spray:
     begin
      FEditBMP.ClrDraw(false);

      RadiusOfCircle:=4;

//      randomize;

      for j := 0 to RadiusOfCircle do begin
        a   := Random * 2 * pi;
        rad := Random * RadiusOfCircle;
        form1.SetPixel(draw, lDraw.X + Round(rad * Cos(a)), lDraw.Y + Round(rad * Sin(a)), AtariPal[palCol[Random(2)]] );
      end;

      PutDraw(px,y);
      SaveAfterExit:=true;
     end;

 end;
end;

end;


function TForm1.locate(const v:byte; const x: integer): byte;
begin
   case Pixel of
    1: Result:=(v and twyt1[x mod 8]) shr (7-(x mod 8));
    2: Result:=(v and twyt2[x mod 4]) shr (6-(x mod 4) shl 1);
    4: Result:=(v and twyt4[x mod 2]) shr (4-(x mod 2) shl 2);
   else
    Result:=0;
   end;
end;


function PobierzPiksel(const x,y: integer): byte;
var hlp: integer;
begin

 Result:=0;

 if (x>=CzarnyPas div Pixel) and (x<(Szerokosc+CzarnyPas) div Pixel) and (y>=0) and (y<Wysokosc) then begin

  hlp:={form1.Sofs}(x div (8 div Pixel)+tmul48[y]);

  Result:=form1.locate(copy_tab[hlp], x);

 end;

end;


function PobierzPiksel_pat(x,y: integer): byte;
var hlp: integer;
begin

 x:=(pPat.X{-CzarnyPas}) div Pixel + (x mod (wycinek.Width div Pixel));
 y:=pPat.Y + (y mod wycinek.Height);

 hlp:={form1.Sofs}(X div (8 div Pixel)+tmul48[Y]);

 Result:=form1.locate(copy_tab[hlp], x);

end;


function TForm1.Bajt_Obrazu(const hlp:byte; const x:integer; P:byte): byte;
var i, v: byte;
begin
  v:=hlp; i:=0;

  case Pixel of
   1: begin
       p:=p and 1;

       v:=v and tand1[X mod 8];
       i:=tcol1[P] and twyt1[X mod 8];
      end;

   2: begin
       p:=p mod 5;

       v:=v and tand2[X mod 4];
       i:=tcol2[P] and twyt2[X mod 4];
      end;

   4: begin
       p:=p and $0f;

       v:=v and tand4[X mod 2];                                 
       i:=tcol4[P] and twyt4[X mod 2];
      end;
   end;

 Result := v or i;
end;


procedure ZapalPiksel_pat(const x,y:integer; const P:byte);
var hlp: integer;
begin
  hlp:={form1.Sofs}(x div (8 div Pixel)+tmul48[y]);

  temp_tab[hlp]:=form1.bajt_obrazu(temp_tab[hlp],x,p);
end;


procedure ZapalPiksel(const x,y:integer; const P:byte);
var hlp: integer;
    mcol: byte;
begin

 if (x>=CzarnyPas div Pixel) and (x<(Szerokosc+CzarnyPas) div Pixel) and (y>=0) and (y<Wysokosc) then begin

  case Pixel of
   2: mcol:=3;
   4: mcol:=15;
  else
   mcol:=1;
  end;

  hlp:={form1.Sofs}x div (8 div Pixel)+tmul48[y];

  tab[hlp]:=form1.Bajt_Obrazu(tab[hlp],x, p and mcol);

 end;

end;


procedure TForm1.Image4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, j, s, e: integer;
    r, r1, r2: TColor;
    p, _and: byte;
    kol: array [0..1] of cardinal;
begin

 s:=0;
 e:=0;

 x:=x shr 1;
 y:=y shr 1;

 klik:=false;

// automatycznie uzupelni informacje o kolorach w uzytym zakresie obrazu

 if FEditBMP.AutoDLI.Checked then
 if drawMode in [FDraw, Line, Lines, Rec, RRec, Elipse, Spray, Bezier, Tekst, TekstAtari] then begin

  case drawMode of
                       FDraw: begin s:=drawSelect.X; e:=drawSelect.Y+1 end;
                 Line, Lines: begin s:=pDraw.Y; e:=lDraw.Y end;
   Rec, RRec, Elipse, Bezier: begin s:=lastDraw.Top; e:=lastDraw.Bottom+ord(drawMode=Bezier) end;
                       Spray: begin s:=drawSelect.X-4; e:=drawSelect.Y+4 end;
           Tekst, TekstAtari: begin s:=drawSelect.X; e:=drawSelect.X+TekstHeight end;
  end;


  if s >= e then begin
   i:=s;
   s:=e;
   e:=i;
  end;


  if selMod[0]>1 then begin
   dec(s,2);
   inc(e);
  end;

  if s<0 then s:=0;
  if e>239 then e:=239;

  if Pixel=1 then begin

   case pisCol[0 xor PrawyPrzycisk] of
    0: fillchar(TabKolor[$300+s], abs(e-s), palCol[2]);
    1: fillchar(TabKolor[$200+s], abs(e-s), palCol[3] and $0f);
   end;

  end else
   fillchar(TabKolor[pisCol[0 xor PrawyPrzycisk] shl 8+s], abs(e-s), palCol[2+pisCol[0 xor PrawyPrzycisk]]);

   UstawKolory;

 end;


// jesli Circle to wylaczaj SELECT
 if drawMode in [Elipse] then Select_OFF(true);

 if drawMode=BezierLine then begin drawMode:=Bezier; exit end;

 if drawMode=Bezier then drawMode:=Bezierline;


 if bMarquee then begin
  klikEdit:=false;
  bMarquee:=false;

  pDraw:=Point(x div Pixel,y);  

{  if drawMode=Gradient then begin
   o1.x:=32;
   o1.y:=0;

   o2.x:=100;
   o2.y:=100;

   cl:=AtariPal[0];
   c1.red:=GetRValue(cl);
   c1.green:=GetGValue(cl);
   c1.blue:=GetBValue(cl);
   c1.alpha:=128;

   cl:=AtariPal[15];
   c2.red:=GetRValue(cl);
   c2.green:=GetGValue(cl);
   c2.blue:=GetBValue(cl);
   c2.alpha:=64;

//   GradientFill(movePix.X, movePix.Y, pDraw.X, pDraw.Y, c1,c2, gtLinear, o1,o2);
   GradientFill(32, 0, 100, 100, c1,c2, gtRadial, o1,o2);

   form1.showMIC; cnv;

   FEditBMP.ClrDraw(true);

   putDraw(0,0);

  end else }

 if not(drawMode in [Dropper, Fill, Tekst, TekstAtari, Select, SelectAlign]) then begin

  r1:=AtariPal[palCol[0]];
  r2:=AtariPal[palCol[1]];

  kol[0]:=r1;
  kol[1]:=r2;

// zmodyfikuj grafike Atari
  for j:=0 to draw.Height-1 do begin

   _and:=GetScanRatio(j shr 3);

   for i:=0 to draw.Width-1 do begin

    r:=form1.GetPixel(draw, i,j);

    if drawMode=RColor then begin

     if r=kol[PrawyPrzycisk] then begin
      p:=form1.locate(tab[i div (8 div Pixel)+tmul48[j]], i);
      if p=pisCol[1 xor PrawyPrzycisk] then ZapalPiksel(i,j,pisCol[0 xor PrawyPrzycisk]);
     end;

    end else begin
     if r=r1 then ZapalPiksel(i,j and _and,pisCol[0]);
     if r=r2 then ZapalPiksel(i,j and _and,pisCol[1]);
    end;

   end;
   
  end;

  form1.showMIC; cnv;

  FEditBMP.ClrDraw(true);

  putDraw(0,0);
  end;

 end;

end;


procedure TForm1.Image5Click(Sender: TObject);
begin
 psOriginal2.Y:=psOriginal2.X;

 startCharset[psOriginal.Y shr 3]:=psOriginal2.Y;
 ustawMemo;
 ustawStartCharset(psOriginal.Y shr 3);

 ShowChars(0,29, false);
end;


procedure TForm1.Image5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 psOriginal2:=Point((x-8) div 24, psOriginal2.Y);
end;


procedure TForm1.Image4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

 if (drawMode in [Select, SelectAlign, SPaste]) and (Button=mbRight) then exit;   // SELECT tylko lewym klawiszem myszki

 if not(drawMode in [Select, SelectAlign, SPaste, Dropper]) then begin ZapiszUndo; SaveAfterExit:=true end;

 x:=x shr 1;
 y:=y shr 1;

 if Button=mbRight then
  PrawyPrzycisk:=1
 else
  PrawyPrzycisk:=0;

 if not(BlokujDraw) then begin          // zaznaczanie SELECT, SELECT ALIGN TO CHAR
  pDraw:=Point(x div Pixel,y);

//  if drawMode in [Select, SelectAlign] then pDraw:=Point(x div Pixel , y);
 end;

 lDraw:=Point(x div Pixel,y);
 bMarquee:=true;

 drawSelect.x:=lDraw.y;
 drawSelect.y:=lDraw.y;

 ImageMouseDown;
end;


procedure copyDRAWtoBUF;
var x,y: integer;
begin

  for y:=0 to Wysokosc-1 do
   for x:=0 to draw.Width-1 do
    if form1.GetPixel(draw, x, y)=transCol then ZapalPiksel(x,y,pisCol[0 xor PrawyPrzycisk]);

end;


procedure copyIMG1toDRAW;
var SRC, DST: PRGBQuad;
    x, y: integer;
begin

      for y:=0 to Wysokosc-1 do begin
       SRC:=img1.ScanLine[y];
       DST:=draw.ScanLine[y];

       for x:=0 to draw.Width-1 do begin
        DST^.rgbBlue  := SRC^.rgbBlue;
        DST^.rgbGreen := SRC^.rgbGreen;
        DST^.rgbRed   := SRC^.rgbRed;

        Inc(DST);
        Inc(SRC, Pixel);
       end;

      end;
end;



procedure TForm1.Image4ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin

// Image4Click(self);

 klik:=false;

end;


function ata2int(const a: byte): byte;
(*----------------------------------------------------------------------------*)
(*  zamiana znakow ATASCII na INTERNAL                                        *)
(*----------------------------------------------------------------------------*)
begin
 Result:=a;

 case (a and $7f) of
    0..31: inc(Result,64);
   32..95: dec(Result,32);
 end;

end;


procedure TForm1.ImageMouseDown;
var i,j, x, y, mx, my: integer;
    p: byte;
    txt: string;
//    clip: HRGN;
begin

// y:=0;

 case drawMode of

  FDraw:                             // PLOT
     begin
      FEditBMP.ClrDraw(false);

      draw.Canvas.Polyline([pDraw, Point(pDraw.X+1, pDraw.Y)]);

      PutDraw(px,y);
      SaveAfterExit:=true;

     end;

  Dropper:
     begin
      PobierzPalete(movePix.X, movePix.Y);
      FEditBMP.frameAtariPalette1.ustawPalete;
     end;

// Tekst
 Tekst:
     begin
      Image4MouseUp(self, mbLeft, [], movePix.x, movePix.y);

      copyIMG1toDRAW;

      draw.canvas.Brush.Style:=bsSolid;
      
      draw.Canvas.Font.Color:=transCol;
      draw.Canvas.Brush.Color:=clRed;

//      clip:= CreateRectRgn(10, 20, 100, 150);
//      SelectClipRgn(draw.canvas.Handle, clip);

      y:=movePix.Y;
      for i := 0 to FEditBMP.Memo1.Lines.Count-1 do begin

//       DrawText(draw.Canvas.Handle, S, length(S), R, DT_WORDBREAK);

       draw.Canvas.TextOut(movePix.X div Pixel, y, FEditBMP.Memo1.Lines.Strings[i]);
       inc(y, draw.Canvas.TextHeight(FEditBMP.Memo1.Lines.Strings[i]));
      end;

      copyDRAWtoBUF;

      showMic; cnv;
      SaveAfterExit:=true;

      FEditBMP.ClrDraw(true);
      putDraw(0,0);
     end;

// Tekst
 TekstAtari:
     begin
      Image4MouseUp(self, mbLeft, [], movePix.x, movePix.y);

      copyIMG1toDRAW;

      draw.Canvas.Font.Color:=transCol;
      draw.Canvas.Brush.Color:=clRed;

      y:=movePix.Y;
      for i := 0 to FEditBMP.Memo1.Lines.Count-1 do begin
       txt:=FEditBMP.Memo1.Lines.Strings[i];

       x:=movePix.X div Pixel;
       for j := 1 to length(txt) do begin

        for my:=0 to 7 do begin
         p:=EditBmpFnt[ata2int(ord(txt[j]))*8+my];

         for mx:=0 to 7 do
          if p and twyt1[mx]<>0 then
           case Pixel of
            1: form1.SetPixel(draw, x+mx, y+my, transCol);
            2: begin
                form1.SetPixel(draw, x+mx, y+my*2, transCol);
                form1.SetPixel(draw, x+mx, y+my*2+1, transCol);
               end;
            4: begin
                form1.SetPixel(draw, x+mx, y+my*4,   transCol);
                form1.SetPixel(draw, x+mx, y+my*4+1, transCol);
                form1.SetPixel(draw, x+mx, y+my*4+2, transCol);
                form1.SetPixel(draw, x+mx, y+my*4+3, transCol);
               end;
           end;

        end;

        inc(x,8);
       end;

       case Pixel of
        1: inc(y, 8);
        2: inc(y, 16);
        4: inc(y, 32);
       end;

      end;

      copyDRAWtoBUF;

      showMic; cnv;
      SaveAfterExit:=true;

      FEditBMP.ClrDraw(true);
      putDraw(0,0);
     end;

// FILL
  Fill:
     begin
      copyIMG1toDRAW;

      draw.Canvas.Brush.Color:=transCol;
      draw.Canvas.FloodFill(movePix.X div Pixel, movePix.Y, form1.GetPixel(draw, movePix.X div Pixel, movePix.Y), fsSurface);

      copyDRAWtoBUF;

      showMic; cnv;
      SaveAfterExit:=true;
     end;

// PUT SELECTED AREA
 SPaste:
     begin
      ZapiszUndo; SaveAfterExit:=true;

      mx:=(movePix.X-mOfset.x) div Pixel;
      my:=movePix.Y-mOfset.y;

//      m:=pMark.Y;
//      i:=pMark.X;

      for y:=0 to wycinek.Height-1 do
       for x:=0 to (wycinek.Width div Pixel)-1 do begin
//        if (my+y in [0..239]) and (m+y in [0..239]) then
//         if (mx+x>=0) and (mx+x<384 div Pixel) and (i+x>=0) and (i+x<384 div Pixel) then begin
          p:=PobierzPiksel_pat(x,y);
          ZapalPiksel(mx+x, my+y, p);
         end;
     end;

// FILL PATTERN
 FShape:
     begin
      move(tab,temp_tab,sizeof(temp_tab));

      copyIMG1toDRAW;

      draw.Canvas.Brush.Color:=transCol;
      draw.Canvas.FloodFill(movePix.X div Pixel, movePix.Y, form1.GetPixel(draw, movePix.X div Pixel, movePix.Y), fsSurface);

      for y:=0 to Wysokosc-1 do
       for x:=0 to draw.Width-1 do
        if form1.GetPixel(draw, x, y)=transCol then ZapalPiksel_pat(x,y,PobierzPiksel_pat(x,y));

      move(temp_tab,tab,sizeof(temp_tab));
      showMic; cnv;
      SaveAfterExit:=true;
     end;

 else

  if drawMode=Spray then Image4MouseMove(self,[], movePix.X shl 1, movePix.Y shl 1);

 end;

end;


procedure TForm1.Undo1Click(Sender: TObject);
// UNDO
begin

 if undo_index=undo_index_max then begin
  ZapiszUndo;
  dec(undo_index);
  dec(undo_index_max);
 end;


 CzytajUndo;

 UstawKolory;

 ShowMic;

 cnv;


 if FEditCharset.Visible then FEditCharset.PrzepiszZnaki;

 if FEditColors.Visible then begin
  FEditColors.SetKolor;
  FEditColors.LineChange;
 end;

 if FEditPMG.Visible then begin
  FEditPMG.Ustaw_Reszte_Kolorow_Duchow(FEditPMG.GetLineValue);
  FEditPMG.AktualizujSprity;
 end;

 if FZoom.Visible then begin
  FZoom.Image1.Bitmap.Assign(zomek);

  klik:=false;
  Fzoom.Grid;
 end;

 if FEditRasters.Visible then FEditRasters.LineChange;

 if FEditPalette.Visible then FEditPalette.LineChange;

 FEditPMG.check_refresh;

end;


procedure TForm1.Redo1Click(Sender: TObject);
// REDO
begin

 addUndo; addUndo; // inc(undo_index, 2);

 CzytajUndo;

 UstawKolory;

 ShowMic;

 cnv;


 if FEditCharset.Visible then FEditCharset.PrzepiszZnaki;
 if FEditColors.Visible then FEditColors.SetKolor;
 if FEditPMG.Visible then FEditPMG.Ustaw_Reszte_Kolorow_Duchow(FEditPMG.GetLineValue);
 if FEditPalette.Visible then FEditPalette.LineChange;

 if FZoom.Visible then begin
  FZoom.Image1.Bitmap.Assign(zomek);

  klik:=false;
  Fzoom.Grid;
 end;

 FEditPMG.check_refresh;

 form1.EditUndo1.Enabled:=true;

end;


procedure TForm1.New1Click(Sender: TObject);
var i: integer;
begin

  SaveChanges;

  for i:=2 to 20 do Zamknij(t_Forms(i));   // zamknij wszystkie okna

  ClearAll;

  ZnakCheck(ccOptymizing);
  WlaczZnaki(true);
  LoadOK;

  image2.Enabled:=true;
  image3.Enabled:=true;
  image7.Enabled:=true;

  current_filename:='no_name.g2f';
  SaveDialog1.FileName:=current_filename;
  pliki_danych(current_filename);

  SaveAfterExit:=false;

  done:=1; gate:=1; ShowMic; cnv;

  show_title(SaveDialog1.FileName);

  resolution_info;

  first_save:=false;
end;


procedure TForm1.CustomMessage(const zm: string; const info: PWideChar);
begin

 Application.MessageBox(PWideChar(zm),info, MB_ICONINFORMATION);

end;


procedure TForm1.InfoClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* INFORMATION                                                                *)
(*----------------------------------------------------------------------------*)
type
    Ptc_ = ^tab_card256;

var i, x, y, tmp, l: integer;
    tc__: cardinal;
    jest: Boolean;
    bmp: TBitmap;

    tc_: Ptc_;

begin

 ShowMic(false);

 New(tc_);

 zamknij(f_Zoom);

 tmp:=Bajt shl 3;

 for i:=0 to 255 do tc_^[i]:=transCol;

 l:=0;

 image1.Picture.Bitmap.SaveToFile(GetUndoName('info$$$.$$$'));

 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(image1.Width, image1.Height);

 bmp.LoadFromFile(GetUndoName('info$$$.$$$'));

 for y:=0 to Wysokosc-1 do begin

  for x:=0 to tmp-1 do begin

   tc__:=form1.GetPixel(bmp, x,y);

   jest:=false;
   for i:=0 to 255 do
    if tc_^[i]=tc__ then jest:=true;

   if not(jest) then begin
    tc_^[l]:=tc__;
    inc(l);
   end;

  end;
 end;

 bmp.Free;

 ShowMic;
 
 CustomMessage('The number of unique colors used in this image is '+IntToStr(l)+'.', 'Information');

 Dispose(tc_);
end;


procedure TForm1.Button12Click(Sender: TObject);
begin
 Undo1Click(form1);
end;


procedure TForm1.Button13Click(Sender: TObject);
begin
 Redo1Click(form1);
end;


procedure NormalizeMark;
var i,j: integer;
begin
       i:=pMark.X; j:=lMark.X;
       if i>j then begin
        pMark.X:=j; lMark.X:=i;
       end;

       i:=pMark.Y; j:=lMark.Y;
       if i>j then begin
        pMark.Y:=j; lMark.Y:=i;
       end;

       lMark.X := (lMark.X div Pixel)*Pixel;
//       lMark.Y := lMark.Y;

       wycinek.Width:=lMark.X-pMark.X;
       wycinek.Height:=lMark.Y-pMark.Y;
end;


procedure Paste(cans: TCanvas);
var MyRect, MyOther: TRect;
begin
       NormalizeMark;

       MyRect := Rect(0,0,wycinek.Width,wycinek.Height);
       MyOther := Rect(pMark.X,pMark.Y,lMark.X,lMark.Y);

       wycinek.Canvas.CopyRect(MyRect, cans, MyOther);

       FEditBMP.ClrDraw(true);

       form1.PutDraw(0,0);

//       move(tab,copy_tab,sizeof(tab));

       drawMode:=SPaste;

//       Select_OFF(false);

       pPat := pMark;

       FEditBMP.ToolFShape.Enabled:=true;
end;


procedure TForm1.EditBitmapExecute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* EDIT BITMAP                                                                *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin

 EditBitmap.Checked:=not(EditBitmap.Checked);

 if EditBitmap.Checked then begin

  ZamknijBMPLimitations;

  SelectPreview.ItemIndex:=ord(___BMP);         // BMP

  move(gfxMode,old_gfxMode,sizeof(gfxMode));
  oldGfx_use:=true;

  image2.Enabled:=false;
  image3.Enabled:=false;
  image7.Enabled:=false;

  Shape1.Pen.Style:=psDot;

  UstawPixel; UstawGfxMode(Pixel); form1.showMIC;

  zamknij(f_Zoom);
  zamknij(f_EditCharset);
  zamknij(f_Move);
  zamknij(f_EditColors);
  zamknij(f_EditPMG);
  zamknij(f_ImportBMP);

  SetFormPos('FEditBMP', t,l);
  FEditBMP.top:=t;
  FEditBMP.left:=l;

  if (form1.SelectPixel.ItemIndex=2) and (t_gtia(form1.SelectGTIA.ItemIndex) in [gr9,gr11]) then begin
   FEditBMP.AutoDLI.Checked:=false;
   FEditBMP.AutoDLI.Enabled:=false;
  end else
   FEditBMP.AutoDLI.Enabled:=true;

  FEditBMP.Visible:=true;

  pDraw:=Point(0,0);

  pobierzPalete(0,0);
  FEditBMP.frameAtariPalette1.ustawPalete;

  image4.Visible:=true;

  EditBitmap.Checked:=true;

  FEditBMP.ToolFShape.Enabled:=false;

  Usun_Zaznaczenia(false);

  draw.Width:=384 div Pixel;

  draw.Canvas.pen.Color:=clYellow;
  draw.Canvas.Brush.Color:=0;

  image4.Enabled:=true;

  Shape3.Visible:=true;              // kursor krzyzakowy
  Shape4.Visible:=true;

  Shape3.Width:=image1.Width;
  Shape3.Height:=2;
  shape3.Left:=image1.Left;

  Shape4.Height:=image1.Height;
  Shape4.Width:=2;
  Shape4.Top:=image1.Top;

  Shape3.Pen.Mode:=pmXor;
  Shape4.Pen.Mode:=pmXor;


  FEditBMP.ClrDraw(true);

  PutDraw(0,0);

  SelectScreen.Enabled:=false;
//  SelectPixel.Enabled:=false;

//  EditCut1.Enabled:=true;
//  EditCopy1.Enabled:=true;
//  EditDelete1.Enabled:=true;
//  EditSelectAll1.Enabled:=true;
//  EditSelectNone1.Enabled:=true;

  EditPaste1.Enabled:=FileExists(GetUndoName(copypaste));

end else
 Zamknij(f_EditBMP);

end;


function GetSpecialFolderPath(const Folder: Integer): string;
var
  Path: array[0..MAX_PATH] of Char;
begin
  SHGetSpecialFolderPath(0, Path, Folder , False);
  Result := Path;
end;


procedure TForm1.InitShape3_4;
begin

 Shape3.Left:=Image6.Left;
 Shape4.Left:=Shape3.Left;

 Shape3.Width:=Image2.Width+Image2.Left-Image6.Left;
 Shape4.Width:=Shape3.Width;

 Shape3.Height:=2;
 Shape4.Height:=2;

 Shape3.Pen.Mode:=pmMergePenNot;
 Shape4.Pen.Mode:=pmMergePenNot;

end;


procedure TForm1.FormCreate(Sender: TObject);
var x: integer;
begin

// ReportMemoryLeaksOnShutdown := True;

 doublebuffered:=true;                  //aby nie szarpalo obrazem

 FOldClipViewHwnd := SetClipBoardViewer(Handle);

 Application.OnMessage:=TestKeyDown;

 Application.HintHidePause:=100000;     //aby Hinty nie znikaly zbyt szybko

 FormatSettings.DecimalSeparator := '.';

 // [Current User]\My Documents      CSIDL_PERSONAL
 // All Users\Application Data       CSIDL_COMMON_APPDATA;
 // [User Specific]\Application Data CSIDL_LOCAL_APPDATA;
 // Program Files                    CSIDL_PROGRAM_FILES;
 // All Users\Documents              CSIDL_COMMON_DOCUMENTS;

 path:=GetSpecialFolderPath(CSIDL_APPDATA);            // [USER]/Application Data/
 if not(path[length(path)] in ['/','\']) then path:=path+'\';

 palette_path:=ExtractFilePath(Application.ExeName);
 if not(palette_path[length(palette_path)] in ['/','\']) then palette_path:=palette_path+'\';

 if path='' then
  path:=ExtractFilePath(Application.ExeName) //skad zostal uruchomiony program
 else begin
  path:=path+'graph2font\';
  if not(SysUtils.DirectoryExists(path)) then CreateDir(path);
 end;

// if not(DirectoryExists(path+'Undo')) then CreateDir(path+'Undo');
// if not(DirectoryExists(path+'Maps')) then CreateDir(path+'Maps');

// kasujemy pliki UNDO
 x:=0;
 while FileExists(GetUndoName('g2fundo'+IntToStr(x)+'.dat')) do begin
  DeleteFile(GetUndoName('g2fundo'+IntToStr(x)+'.dat'));
  inc(x);
 end;

 x:=FileCreate(GetUndoName(copypaste));
 FileClose(x);


 for x := 0 to length(tUndo)-1 do tUndo[x]:=x;


 if not FileExists(GetUndoName(__echar)) then begin
  x:=FileCreate(GetUndoName(__echar));
  FileClose(x);
 end;


 fillchar(chlimit, sizeof(chlimit), true);

 move(defPal,AtariPal,sizeof(AtariPal));

 caption:=title_name;

 Screen.Cursors[1] := LoadCursor(hInstance, 'ID_CUR2');
 Screen.Cursors[2] := LoadCursor(hInstance, 'ID_CUR3');
 Screen.Cursors[3] := LoadCursor(hInstance, 'ID_CUR4');
 Screen.Cursors[4] := LoadCursor(hInstance, 'ID_CUR5');
 Screen.Cursors[5] := LoadCursor(hInstance, 'ID_CUR6');

 Screen.Cursors[6] := LoadCursor(hInstance, 'ID_CUR7');
 Screen.Cursors[7] := LoadCursor(hInstance, 'ID_CUR8');
 Screen.Cursors[8] := LoadCursor(hInstance, 'ID_CUR9');
 Screen.Cursors[9] := LoadCursor(hInstance, 'ID_CUR10');
 Screen.Cursors[10] := LoadCursor(hInstance, 'ID_CUR11');
 Screen.Cursors[11] := LoadCursor(hInstance, 'ID_CUR12');
 Screen.Cursors[12] := LoadCursor(hInstance, 'ID_CUR1');
 Screen.Cursors[13] := LoadCursor(hInstance, 'ID_CUR13');


 for x:=0 to 255 do tmul48[x]:=x*48;   // init tablicy mnozen

 img1        := TBitmap.Create;
 draw        := TBitmap.Create;
 wycinek     := TBitmap.Create;
 zomek       := TBitmap.Create;
 atasciiChar := TBitmap.Create;
 bmpChar     := TBitmap.Create;
 bmpPal      := TBitmap.Create;

 image1.Picture.Bitmap.PixelFormat:=pf32bit;
 image2.Picture.Bitmap.PixelFormat:=pf32bit;
 image3.Picture.Bitmap.PixelFormat:=pf32bit;
 image4.Picture.Bitmap.PixelFormat:=pf32bit;
 image6.Picture.Bitmap.PixelFormat:=pf32bit;
 image7.Picture.Bitmap.PixelFormat:=pf32bit;

 GridImage.Picture.Bitmap.PixelFormat:=pf32bit;

 zomek.PixelFormat:=pf32bit;
 atasciiChar.PixelFormat:=pf32bit;
 img1.PixelFormat:=pf32bit;
 draw.PixelFormat:=pf32bit;
 wycinek.PixelFormat:=pf32bit;
 bmpChar.PixelFormat:=pf32bit;
 bmpPal.PixelFormat:=pf32bit;

 zomek.SetSize   (384, Wysokosc);
 img1.SetSize    (384, Wysokosc);
 draw.SetSize    (384, Wysokosc);

 bmpPal.SetSize(image6.Width, Wysokosc);
 atasciiChar.SetSize(8,8);

 draw.TransparentColor:=transCol;
 draw.TransparentMode:=tmFixed;


 bmpPen:=TBitmap.Create;
 bmpPen.PixelFormat:=pf32bit;
 bmpPen.SetSize(8,8);

 MyPen:=TPen.Create;

 FillChar(lb,SizeOf(lb),0);
 lb.lbStyle:=BS_SOLID or BS_PATTERN;

 lb.lbHatch:=NativeInt(bmpPen.Handle);
 

 ClearActiveColor($ff);

 calc_crc;

// mapa_path:=path+'Maps';

 pozY:=form1.Image1.Top;
 pozX:=form1.Image1.Left;

 curL:=pozX; curT:=pozY;

 InitShape3_4;

 ptMove.X:=0; ptMove.Y:=Wysokosc-1;
 ClearAll;

 ustawMemo;

 crcRasterDefault:=LiczCRCRaster(0);

// init tablicy z piorytetami obiektow PMG
 move(pr0,tprior,sizeof(tprior));

 SetLength(tval,1);
 SetLength(tadr,1);
 SetLength(kosz,1);

 SelectVideo.Hint:='Chipset:'#13#10'ANTIC+GTIA standard video possibilites'#13#10'ANTIC+VBXE enhanced video possibilites';
 SelectMode.Hint:='Mode:'#13#10'GED+ (char mode, rasters)'#13#10'DLI     (char mode, display list interrupt)'#13#10'GED-  (bitmap mode, rasters)'#13#10'PGR    (bitmap mode, full rasters)'#13#10'PGR+  (char mode, full rasters)';
 SelectPreview.Hint:='Preview:'#13#10'PMG - Players Missiles Graphics'#13#10'BMP - bitmap graphics'#13#10'ALL  - bitmap and PMG graphics';
 SelectScreen.Hint:='Screen:'#13#10'32 byte - NARROW'#13#10'40 byte - NORMAL'#13#10'48 byte - WIDE';
 SelectGTIA.Hint:='GTIA:'#13#10'16G = GRAPHICS 9   (OS)'#13#10'9C   = GRAPHICS 10 (OS)'#13#10'16C = GRAPHICS 11 (OS)';

 ShowPixelHint;

 image2.Enabled:=false;
 image3.Enabled:=false;
 image7.Enabled:=false;

 StatusPreview;
 StatusMode;

 ProgressBar1.Top:=Image6.Top;
 ProgressBar1.Left:=Image6.Left;
 ProgressBar1.Height:=Image6.Height;

 ustawStartCharset(0);

 DisableDrawMode;

// tInfo[ord(moveP)]:='Move Selected Pixels: Drag the selection to move.';// Drag the nubs to scale. Drag with right mouse button to rotate.';
// tInfo[ord(moveS)]:='Move Selection: Drag the selection to move.';// Drag the nubs to scale. Drag with right mouse button to rotate.';
// tInfo[ord(paintb)]:='Paintbrush: Left click to draw with primary color, right click to draw with secondary color.';

 tInfo[ord(Select)]:='Select: Left click to select region. Hold Shift: Align selection to char.';
 tInfo[ord(FDraw)]:='Draw: Left click to draw freeform with primary color, right click to use secondary color.';
 tInfo[ord(dropper)]:='Color Picker: Left click to set palette colors.';
 tInfo[ord(rColor)]:='Recolor: Left click to replace the secondary color with primary color.';
 tInfo[ord(rec)]:='Rectangle: Click and drag to draw a rectangle (right click for secondary color). Hold shift to constrain to a square.';
 tInfo[ord(elipse)]:='Ellipse: Click and drag to draw an ellipse (right click for secondary color). Hold shift to constrain to a circle.';
 tInfo[ord(fill)]:='Floodfill: Left click to fill region with primary color, right click to fill with the secondary color.';
 tInfo[ord(tekst)]:='Text: Left click to drawn text with the primary color, right click to use secondary color.';
 tInfo[ord(line)]:='Line: Left click to draw with primary color, right click to use secondary color.';
 tInfo[ord(BezierLine)]:='Curve: Left click to draw with primary color, right click to use secondary color.';
 tInfo[ord(spray)]:='Spray: Left click to draw with primary color, right click to use secondary color.';
// tInfo[ord(zoomt)]:='Zoom: Left click to zoom in, right click to zoom out.';
// tInfo[ord(freeform)]:='Freeform Shape: Left click to draw a freeform shape with the primary color, right click to use the secondary color.';
 
 
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
 ChangeClipBoardChain(Handle, FOldClipViewHwnd);
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
 inc(Offset_ants);

 DrawSelectMarker;
end;


procedure TForm1.Timer2Timer(Sender: TObject);
begin

 if FEditPMG.Visible then
  if mrugaj_duchami or SpecialStr[___VisiblePMG].val then image4.Visible:=not(image4.Visible);


 if SpecialStr[___Mrugajace].val then begin

  case Shape3.Pen.Mode of
   pmMergePenNot: begin Shape3.Pen.Mode:=pmXor; Shape4.Pen.Mode:=pmXor end;
           pmXor: begin Shape3.Pen.Mode:=pmMergePenNot; Shape4.Pen.Mode:=pmMergePenNot end;
  end;

 end else begin
  Shape3.Pen.Mode:=pmMergePenNot; Shape4.Pen.Mode:=pmMergePenNot;
 end;

 if Shape1.Visible then
  if SpecialStr[___Mrugajace].val then begin
   case Shape1.Pen.Mode of
    pmMergePenNot: begin Shape1.Pen.Mode:=pmXor; Shape2.Pen.Mode:=pmXor end;
            pmXor: begin Shape1.Pen.Mode:=pmMergePenNot; Shape2.Pen.Mode:=pmMergePenNot end;
   end;

  end else begin
   Shape1.Pen.Mode:=pmMergePenNot; Shape2.Pen.Mode:=pmMergePenNot
  end;

end;


procedure TForm1.Timer3Timer(Sender: TObject);
begin
             
 if FEditColorsMap.visible then

  if SpecialStr[___Mrugajace].val then
   image4.Visible:=not(image4.Visible)
  else
   image4.Visible:=true;

end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
begin
 NewFormPos('FMain', top, left);

 for i:=2 to Screen.FormCount do Zamknij(t_Forms(i));
 
 ZapiszPath(form1.OpenDialog1.FileName);

{
 RemoveFontResource(PChar(GetUndoName('micross.ttf')));
 SendMessage (HWND_BROADCAST,WM_FONTCHANGE,0,0);

 RemoveFontResource(PChar(GetUndoName('tahoma.ttf')));
 SendMessage (HWND_BROADCAST,WM_FONTCHANGE,0,0);
}
end;


procedure TForm1.EditCharsetExecute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* EDIT CHARSET                                                               *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin
 EditCharset.Checked:=not(EditCharset.Checked);

 if EditCharset.Checked then begin

  ZamknijBMPLimitations;

  form1.zamknij(f_Check);
  form1.zamknij(f_EditPMG);
  form1.zamknij(f_EditRasters);
  form1.zamknij(f_EditColors);
  form1.zamknij(f_Move);
  form1.zamknij(f_EditPMG);
  form1.zamknij(f_Zoom);

  SelectPreview.ItemIndex:=ord(___ALL);     // zmienia sie SetFocus na SelectPreview

  Usun_Zaznaczenia(false);

  Cur:=Point(CzarnyPas shr 3,0);
  CurShp:=Cur;

  edit:=true;

  Shape9Enable(true);
  create_yellow_cursor;
  kafelek(true);

  ZaznaczAktualnyZnak(0,0);

  pMark:=Point(CurShp.X shl 3, CurShp.Y shl 3);
  lMark:=Point(pMark.X+yel_wid shl 3, pMark.Y+yel_hig shl 3);

  with FEditCharset do begin
   SetFormPos('FEditCharset', t,l);
   FEditCharset.Top:=t;
   FEditCharset.Left:=l;

   Visible:=true;
  end;

  PokazCharset;

 end else
  zamknij(f_EditCharset);

end;


procedure TForm1.Pack_Zlib(fn, dst: string);
var CompressStr : TZCompressionStream ;
    OutStr : TFileStream;
    Size, f: integer;
    Buffer: PChar;
begin

 f:= FileOpen(fn, fmOpenRead);
 Size:=FileSeek(f, 0, 2);

 FileSeek(f, 0, 0);

  try
    GetMem(Buffer, Size);
    try
      FileRead(F, Buffer^, Size);
    finally
     OutStr := TFileStream.Create(dst, fmCreate) ;

     CompressStr := TZCompressionStream.Create(OutStr , zcMax ) ;

     CompressStr.Write(Buffer^ , Size) ;

     FreeMem(Buffer);

     CompressStr.Free ;
     OutStr.Free ;
    end;
  finally
    FileClose(F);
  end;

end;


procedure TForm1.Depack_Zlib(fn, dst: string);
var DecompressStr : TZDecompressionStream ;
    OutStr : TFileStream;
    Size, f: integer;
    Buffer: PChar;
begin
 OutStr := TFileStream.Create(fn, fmOpenRead) ;
 DecompressStr := TZDecompressionStream.Create(OutStr) ;

  try
    Size := DecompressStr.Size;
    GetMem(Buffer, Size);
    try
      DecompressStr.Read(Buffer^ , Size) ;
    finally
      f:=FileCreate(dst);
      FileWrite(f,Buffer^,Size);
      FileClose(f);

      FreeMem(Buffer);
    end;
  finally
//    CloseFile(F);
  end;

 DecompressStr.Free ;
 OutStr.Free ;
end;


procedure TForm1.Label7Click(Sender: TObject);
begin
 TLabel(Sender).Color:=TLabel(Sender).Color xor (clBtnFace xor clLime);
end;


procedure TForm1.BMP2ATASCII1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* Convert bitmap to ATASCII                                                  *)
(*----------------------------------------------------------------------------*)
var bmp: TBitmap;
    i, j, f: integer;
    x,y, r, inv, ile: byte;
    v,s: cardinal;
    chr: array [0..7, 0..7] of integer;
    tc: array [0..255] of Boolean;
    tv: array [0..255] of integer;
    dv: real;
begin

 SaveAfterExit:=true; ZapiszUndo;

 ShowMic(false);          // !!! koniecznie w tym miejscu
 
 bmp:=TBitmap.Create;
 bmp.Assign(img1);

 SelectPixel.ItemIndex:=0;

 ClearPMG;
 ClearKolor;

// liczymy kolory Grayscale
 fillchar(tc, sizeof(tc), false);
 fillchar(tv, sizeof(tv), 0);

 for j := 0 to bmp.Height do
  for i := 0 to bmp.Width do tc[GetRValue(GetGrayColor(bmp.Canvas.Pixels[i, j]))]:=true;

 ile:=0;
 for i := 0 to 255 do
  if tc[i] then inc(ile);

 dv:=256 / (ile-1);
 x:=round(dv);

 for i := 0 to 255 do
  if tc[i] then begin
   tv[i]:=x;

   x:=round(x+dv);
  end;


 for j := 0 to (bmp.Height shr 3)-1 do
  for i := 0 to (bmp.Width shr 3)-1 do begin

   v:=$FFFFFFFF;

   for y := 0 to 7 do
    for x := 0 to 7 do chr[x,y]:=tv[GetRValue(GetGrayColor(bmp.Canvas.Pixels[i shl 3+x, j shl 3+y]))];

   r:=0;
   for f := 0 to 255 do begin

    if f<128 then
     inv:=0
    else
     inv:=255;

    s:=0;
    for y := 0 to 7 do
     for x := 0 to 7 do s:=s+sqr(chr[x,y] - ord((AtariFnt[(f and $7f) shl 3+y] xor inv) and twyt1[x]<>0)*$ff);

    if v>s then begin v:=s; r:=f end;

   end;

   invers[i+tmul48[j]]:=r and $80;

   for y := 0 to 7 do tab[i+tmul48[j shl 3+y]]:=AtariFnt[(r and $7f) shl 3+y];

  end;

 bmp.Free;

 form1.UstawKolory;
 form1.OdswiezObraz
end;


procedure TForm1.BMP2PMGClick(Sender: TObject);
var t,l: integer;
begin

 BMP2PMG.Checked:=not(BMP2PMG.Checked);

 if BMP2PMG.Checked then begin

  ZamknijBMPLimitations;

  form1.zamknij(f_EditRasters);
  form1.zamknij(f_EditColors);
  form1.zamknij(f_Move);
  form1.zamknij(f_EditPMG);

  SetFormPos('FBMP2PMG', t,l);
  FBMP2PMG.top:=t;
  FBMP2PMG.left:=l;

  FBMP2PMG.Visible:=true;
  FBMP2PMG.Edit1Change;
  FBMP2PMG.RadioGroup1.ItemIndex:=0;

 end else
  zamknij(f_Bmp2Pmg);
 
end;


procedure TForm1.BMPLimitations1Click(Sender: TObject);
begin

// BMPLimitations1.Checked:=not(BMPLimitations1.Checked);

 if not BMPLimitations1.Checked then begin

  zamknij(f_Move);
  zamknij(f_EditCharset);
  zamknij(f_Bmp2Pmg);
  zamknij(f_EditBMP);
  zamknij(f_EditRasters);
  zamknij(f_SelectColor);
  zamknij(f_EditColors);
  zamknij(f_EditPalette);
  zamknij(f_EditColorsMap);
  zamknij(f_EditPMG);

  BMPLimitations1.Checked:=true;

  image4.Picture.Bitmap:=nil;

  image4.Visible:=true;
  image4.Stretch:=false;
  image4.Enabled:=false;

  image1.Cursor:=crHandPoint;

  image4.Width:=768;
  image4.Height:=480;

  ClrRectImage(image4, transCol);

  Grid(true);

  OdswiezObraz;

 end else begin
  ZamknijBMPLimitations;
  OdswiezObraz;

  Grid( SpecialStr[___Grid].val );
 end;

end;


procedure TForm1.Palette1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* PALETTE OPTIONS                                                            *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin
 zamknij(f_EditColors);
 zamknij(f_EditPMG);

 SetFormPos('FPaletteOptions', t, l);
 FPaletteOptions.Top:=t;
 FPaletteOptions.Left:=l;

 if FPaletteOptions.ShowModal=mrOK then begin   // przepisujemy palete do AtariPal
  FPaletteOptions.movePal;

  pal_b := tspin[0].Position;
  pal_w := tspin[1].Position;
  pal_s := tspin[2].Position;
  pal_c := tspin[3].Position;

  pal_extr := FPaletteOptions.UseExternal.Checked;

  form1.OdswiezObraz;
  form1.UstawKolory;
 end else begin

  FPaletteOptions.Edit5.Text:=old_palette_path;
  palette_path:=old_palette_path;

  FPaletteOptions.PokazPalete(false);
 end;

end;


procedure scroll(const WheelDelta: integer);
var j: integer;
begin

  j:=vscrol.pos;

  if WheelDelta<>0 then
   if WheelDelta<0 then inc(vscrol.pos) else dec(vscrol.pos);

  if vscrol.pos<0 then vscrol.pos:=0 else
   if vscrol.pos>vscrol.max-30 then vscrol.pos:=vscrol.max-30;

  if vscrol.use then begin
   if WheelDelta<>0 then
    if j<>vscrol.pos then zapisz_vsc(j);
   form1.czytaj_vsc;
  end else begin
   if WheelDelta<>0 then
    if j<>vscrol.pos then zapisz_hsc(j);
   czytaj_hsc;
  end;

  form1.OdswiezObraz;
  form1.UstawKolory;
end;


procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin

 if vscrol.use or hscrol then scroll(WheelDelta);

 Handled:=true;

end;


procedure TForm1.Next1Click(Sender: TObject);
begin
 if vscrol.use then zapisz_vsc(vscrol.pos) else zapisz_hsc(vscrol.pos);
 inc(vscrol.pos, Bajt);
 scroll(0);
end;

procedure TForm1.Previous1Click(Sender: TObject);
begin
 if vscrol.use then zapisz_vsc(vscrol.pos) else zapisz_hsc(vscrol.pos);
 dec(vscrol.pos, Bajt);
 scroll(0);
end;


procedure TForm1.EditPaletteExecute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* EDIT PALETTE                                                               *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin

 EditPalette.Checked:=not(EditPalette.Checked);

 if EditPalette.Checked then begin

  ZamknijBMPLimitations;

  zamknij(f_SelectColor);
  zamknij(f_EditColors);
  zamknij(f_EditCharset);
  zamknij(f_EditPMG);
  zamknij(f_Bmp2Pmg);
  zamknij(f_EditRasters);

  SetFormPos('FEditPalette', t,l);
  FEditPalette.top:=t;
  FEditPalette.left:=l;

  FEditPalette.visible:=true;

  form1.Usun_Zaznaczenia(false);
  Shape3_4Enable(true);

 end else
  form1.zamknij(f_EditPalette);

end;


procedure TForm1.Exoirtas1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* Export As...                                                               *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin

 form1.zamknij(f_Zoom);
 form1.zamknij(f_EditPMG);
 form1.zamknij(f_EditColors);

 SetFormPos('FExportAs', t, l);
 FExportAs.Top:=t;
 FExportAs.Left:=l;

 FExportAs.visible:=true;

end;


procedure TForm1.FormShow(Sender: TObject);
var nam, ext, a, zm: string;
    i, t,l: integer;
    INI: TINIFile;
begin

 FSpecial.seFirstChar.Position:=0;
 FSpecial.seLastChar.Position:=127;

 SelectScreen.ItemIndex:=1;

 INI := TINIFile.Create(path+'g2f.ini');

 zm:=INI.ReadString('LastPath','Path',path);

 if not(FileExists(zm)) then zm:=ExtractFilePath(Application.ExeName);

 OpenDialog1.InitialDir := ExtractFileDir(zm);
 OpenDialog1.FileName   := ExtractFileName(zm);

 SaveDialog1.InitialDir := OpenDialog1.InitialDir;
 SaveDialog1.FileName   := OpenDialog1.FileName ;

 mapa_path:=INI.ReadString('Maps','Path',zm);

 charset_path := INI.ReadString('Charset', 'Path', zm);

 palette_path:=INI.ReadString('Palette','Path',zm);
 old_palette_path:=palette_path;

{
 form1.SelectGTIA.ItemIndex:=0;
 form1.SelectMode.ItemIndex:=1;
 form1.SelectVideo.ItemIndex:=0;
 form1.SelectScreen.ItemIndex:=2;
 form1.SelectPixel.ItemIndex:=1; }

 form1.SelectGTIA.ItemIndex   := INI.ReadInteger('Main','GTIA', 0);
 form1.SelectMode.ItemIndex   := INI.ReadInteger('Main','Mode', 1);
 form1.SelectVideo.ItemIndex  := INI.ReadInteger('Main','Video', 0);
 form1.SelectScreen.ItemIndex := INI.ReadInteger('Main','Screen', 2);
 form1.SelectPixel.ItemIndex  := INI.ReadInteger('Main','Pixel', 1);


 pal_b := INI.ReadInteger('Palette','BlackLevel' ,0);
 pal_w := INI.ReadInteger('Palette','WhiteLevel' ,240);
 pal_s := INI.ReadInteger('Palette','Saturation' ,100);
 pal_c := INI.ReadInteger('Palette','ColorShift' ,30);
 pal_extr := INI.ReadBool('Palette','Apply'    ,true);

 undo_redo:=INI.ReadBool('UndoRedo','Enabled', true);

 for i:=0 to length(SpecialStr)-1 do
  SpecialVal(i, ord(INI.ReadBool('Special' , SpecialStr[i].nam, SpecialStr[i].val))+1);

 for i:=0 to length(SpecialStr)-1 do
  SpecialStr[i].val:=SpecialVal(i, -1);

 if not( SpecialStr[___asmRUN].val or SpecialStr[___asmINI].val ) then SpecialVal(___asmRUN, cFlatChecked);

 if not( SpecialStr[___FadeDLICOLORS].val or FadeFx ) then SpecialVal(___FadeDLICOLORS, cFlatChecked);

 if not( SpecialStr[___ModeDLI].val or SpecialStr[___ModeDLIplus].val ) then SpecialVal(___ModeDLI, 2);

 ini_zom.w := INI.ReadInteger('Zoom','Width' ,549);
 ini_zom.h := INI.ReadInteger('Zoom','Height',387);
 ini_zom.t := INI.ReadInteger('Zoom','Top'   ,148);
 ini_zom.l := INI.ReadInteger('Zoom','Left'  ,318);
 ini_zom.f := INI.ReadInteger('Zoom','Factor',4);

 FilSpr   := INI.ReadInteger('Zoom','FilSpr',0);
 pisCol[0]:= INI.ReadInteger('Zoom','Pen',0);

 ini_zom.hs := INI.ReadInteger('Zoom','hsPos',0);
 ini_zom.vs := INI.ReadInteger('Zoom','vsPos',0);

 ini_zom.layer := tLayers (INI.ReadInteger('Zoom','Layer',0));

 zm := INI.ReadString('Zoom','WindowState','n');
 if zm='m' then ini_zom.s:=wsMaximized else ini_zom.s:=wsNormal;

 ini_zom.c := INI.ReadBool ('Zoom','Crosshair',true);

 ini_zom.g := INI.ReadBool ('Zoom','GridEnabled',false);
 grd_wid := INI.ReadInteger('Zoom','GridWidth' ,1);
 grd_hig := INI.ReadInteger('Zoom','GridHeight',1);
 grd_col := INI.ReadBool('Zoom','GridColor',true);

 ini_zom.p := INI.ReadBool('Zoom','Palette' ,true);

 PenS := INI.ReadInteger('Zoom','PenSize' ,1);

 yel_wid := INI.ReadInteger('EditScreen','ycWidth',1);
 yel_hig := INI.ReadInteger('EditScreen','ycHeight',1);

 if yel_wid>9 then yel_wid:=9;
 if yel_hig>9 then yel_hig:=9;

 cmap_cellW := INI.ReadInteger('ColorsMap','cellWidth' ,8); if cmap_cellW<8 then cmap_cellW:=8;
 cmap_cellH := INI.ReadInteger('ColorsMap','cellHeight',8); if cmap_cellH<1 then cmap_cellH:=1;

 for i:=0 to length(FormPos)-1 do begin

  t := INI.ReadInteger(FormPos[i].nam, 'Top', FormPos[i].top);
  l := INI.ReadInteger(FormPos[i].nam, 'Left', FormPos[i].left);

  NewFormPos(FormPos[i].nam, t,l);
 end;

 RecentFile.LoadFromIni(INI, 'Recent');

 FSpecial.PmgG2f.Checked:=INI.ReadBool('PMGFile', 'G2F', true);
 FSpecial.PmgAtari.Checked:=INI.ReadBool('PMGFile', 'Atari', false);
 FSpecial.All.Checked := INI.ReadBool('PMGFile','All' , true);

 for i := 0 to length(lpmg_checkbox)-1 do
   lpmg_checkbox[i].Checked := INI.ReadBool('PMGFile', 'Checkbox'+IntToStr(i) , true);

 FSpecial.Missiles.Checked := INI.ReadBool('AllFile', 'Missiles' , true);
 FSpecial.Colbak.Checked   := INI.ReadBool('AllFile', 'ColBak' , true);
 FSpecial.Charsets.Checked := INI.ReadBool('AllFile', 'Charsets' , true);

 for i := 0 to length(sdat_checkbox)-1 do
  sdat_checkbox[i].Checked := INI.ReadBool('AllFile', 'Checkbox'+IntToStr(i) , true);


 INI.Free;

 SetFormPos('FMain', t,l);
 form1.Top:=t;
 form1.Left:=l;


 if ParamCount>0 then begin
   a:=ParamStr(1);

   if FileExists(a) then begin

    OpenDialog1.InitialDir:=ExtractFilePath(a);
    SaveDialog1.InitialDir:=ExtractFilePath(a);

    nam:=ExtractFileName(a);

    OpenDialog1.FileName:=nam;
    SaveDialog1.FileName:=nam;

    RecentFile.MRUAdd(a);

    ext:=AnsiUpperCase(ExtractFileExt(nam));
    nam:=ChangeFileExt(nam,'');

    for i:=1 to length(file_ext) do
     if ext = file_ext[i] then begin
      SaveDialog1.FilterIndex:=i; Break
     end;

    current_filename:=a;

    ZapiszPath(a);

    Preview;

    pliki_danych(a);

    first_save:=true;

//    SaveAfterExit:=true;
   end;

 end else
  New1Click(Sender);

 FPaletteOptions.LoadPal(palette_path);
 if not pal_extr then FPaletteOptions.Palette_Format(pal_b, pal_w, pal_s);
 FPaletteOptions.movePal;

 form1.OdswiezObraz;
 form1.UstawKolory;

 SetMode;

 SpecialUpdate;

 reopen.Enabled:=(RecentFile.Count>0);

end;


procedure TForm1.EditColorsMapExecute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* EDIT COLORS MAP                                                            *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin
 form1.EditColorsMap.Checked:=not(form1.EditColorsMap.Checked);

 ZamknijBMPLimitations;

 form1.zamknij(f_EditColors);
 form1.zamknij(f_EditPMG);

 if form1.EditColorsMap.Checked then begin

  form1.SetFormPos('FEditColorsMap', t,l);
  FEditColorsMap.top:=t;
  FEditColorsMap.left:=l;

  FEditColorsMap.visible:=true;

  form1.Image4.Visible:=true; form1.Image4.Cursor:=crDefault;
  form1.Image4.Enabled:=false;

  bMarquee:=false;

  FEditColorsMap.image4cmap_init;

  form1.Timer3.Enabled:=true;

 end else
  form1.zamknij(f_EditColorsMap);

end;


procedure SelectAreaUpdate;
begin

 if FEditCharset.Visible or FMove.Visible then begin

  Form1.Shape9Enable(true);
  DrawSelectMarker;

 end;

end;


procedure TForm1.ConverttoGrayscale1Click(Sender: TObject);
var i: integer;
begin

 ZapiszUndo; SaveAfterExit:=true;

 FEditPalette.frameLineRange1.seLine.Position:=0;
 FEditPalette.frameLineRange1.seRange.Position:=239;

 FEditPalette.getPal;

 for i := 0 to lenUPal-1 do upal[i].ata:=upal[i].ata and $0f;

 FEditPalette.setPal;

end;


procedure Negative;
var mx, my, x, y: integer;
begin
      NormalizeMark;

      form1.ZapiszUndo; SaveAfterExit:=true;

      mx:=pMark.X div Pixel;
      my:=pMark.Y;

      move(tab,copy_tab,sizeof(copy_tab));

      for y:=0 to wycinek.Height-1 do
       for x:=0 to (wycinek.Width div Pixel)-1 do
//        if my+y in [0..239] then
//         if (mx+x>=0) and (mx+x<384 div Pixel) then
           ZapalPiksel(mx+x, my+y, PobierzPiksel(mx+x,my+y) xor $ff);

      form1.showMic;
      form1.cnv;

      SelectAreaUpdate;
end;


procedure rotate(mode: byte);
var src, dst: array [0..400, 0..400] of byte;
    mx, my, x, y, w,h: integer;
    c: TPoint;
begin
      NormalizeMark;

      fillchar(src, sizeof(src), 0);
      fillchar(dst, sizeof(dst), 0);

      mx:=pMark.X div Pixel;
      my:=pMark.Y;

      w:=wycinek.Width;
      h:=wycinek.Height;

      for y:=0 to h-1 do
       for x:=0 to w div Pixel-1 do
        src[x,y]:=PobierzPiksel(mx+x,my+y);

       for y:=0 to w div Pixel-1 do
        for x:=0 to h-1 do
         case mode of
          0: dst[x,y]:=src[y,h-1-x];                    // ROTATE RIGHT
          1: dst[h-1-x,w div Pixel-1-y]:=src[y,h-1-x];  // ROTATE LEFT
         end;

       c.x:=mx*Pixel+w shr 1;
       c.y:=my+h shr 1;

       dec(c.x, (h*Pixel) shr 1); c.x:=c.x div Pixel;
       dec(c.y, (w div Pixel) shr 1);

       for y:=0 to w div Pixel-1 do
        for x:=0 to h-1 do
          ZapalPiksel(c.x+x, c.y+y, dst[x,y]);

       pDraw:=c;
       Select_pokaz(pDraw, (pDraw.X+h)*Pixel, pDraw.Y+w div Pixel );

       pMark.X:=pDraw.X*Pixel;
       pMark.Y:=pDraw.Y;
       lMark:=Point(pMark.X+h*Pixel, pMark.Y+w div Pixel );

       SelectAreaUpdate;
end;


procedure RotateFlip(const mode: byte);
var mx, my, x, y: integer;
begin
      NormalizeMark;

      form1.ZapiszUndo; SaveAfterExit:=true;

      mx:=pMark.X div Pixel;
      my:=pMark.Y;

      move(tab,copy_tab,sizeof(copy_tab));

      if mode in [0,1] then
       rotate(mode)
      else

      for y:=0 to wycinek.Height-1 do
       for x:=0 to (wycinek.Width div Pixel)-1 do
//        if my+y in [0..239] then
//         if (mx+x>=0) and (mx+x<384 div Pixel) then
          case mode of
           2: ZapalPiksel(mx+x, my+y, PobierzPiksel(mx+(wycinek.Width div Pixel-1)-x,my+y));  // HORIZONTAL FLIP
           3: ZapalPiksel(mx+x, my+(wycinek.Height-1)-y, PobierzPiksel(mx+x,my+y));           // VERTICAL FLIP

           4: ZapalPiksel(mx+x, my+(wycinek.Height-1)-y, pisCol[0]);                          // CLEAR
          end;

      form1.showMic;
      form1.cnv;

      SelectAreaUpdate;
end;


procedure TForm1.VerticalFlipClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* VERTICAL/HORIZONTAL FLIP                                                   *)
(*----------------------------------------------------------------------------*)
var mode: byte;
begin

 if form1.BMPLimitations1.Checked then ZamknijBMPLimitations;

 mode:=TMainMenu(Sender).Tag;

// if FEditBMP.Visible then
  case drawMode of
   Select, SelectAlign: begin RotateFlip(mode+2); exit end;
  end;

 pDraw:=Point(CzarnyPas div Pixel,0);
 pMark:=Point(CzarnyPas,0);
 lMark:=Point(CzarnyPas+Szerokosc,Wysokosc);

 RotateFlip(mode+2);

 form1.showMic;
 form1.cnv;

 SelectAreaUpdate;
end;


procedure DeleteSelect;
(*----------------------------------------------------------------------------*)
(* DELETE - FILL COLORS                                                       *)
(*----------------------------------------------------------------------------*)
begin

 if form1.BMPLimitations1.Checked then ZamknijBMPLimitations;

// if FEditBMP.Visible then
  case drawMode of
   Select, SelectAlign: begin RotateFlip(4); exit end;
  end;

 pDraw:=Point(CzarnyPas div Pixel,0);
 pMark:=Point(CzarnyPas,0);
 lMark:=Point(CzarnyPas+Szerokosc,Wysokosc);

 RotateFlip(4);

 SelectAreaUpdate;
end;


procedure TForm1.HalSizeVClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* Half size vertically                                                       *)
(*----------------------------------------------------------------------------*)
var y: byte;
begin
      form1.ZapiszUndo; SaveAfterExit:=true;

      move(tab,copy_tab,sizeof(copy_tab));
      fillchar(tab, sizeof(tab), 0);

      for y:=0 to 119 do
       move(copy_tab[y*96], tab[y*48], 48);

      move(tabKolor, bufor, sizeof(tabKolor));
      fillchar(tabKolor, sizeof(tabKolor), 0);

      for y:=0 to 119 do begin
       move(bufor[$000+y*2], tabKolor[$000+y], 1);
       move(bufor[$100+y*2], tabKolor[$100+y], 1);
       move(bufor[$200+y*2], tabKolor[$200+y], 1);
       move(bufor[$300+y*2], tabKolor[$300+y], 1);
       move(bufor[$400+y*2], tabKolor[$400+y], 1);
//       move(bufor[$500+y*2], tabKolor[$500+y], 1);
//       move(bufor[$600+y*2], tabKolor[$600+y], 1);
//       move(bufor[$700+y*2], tabKolor[$700+y], 1);
//       move(bufor[$800+y*2], tabKolor[$800+y], 1);
      end;

{
      move(SmaskX, bufor, sizeof(SmaskX));
      fillchar(SmaskX, sizeof(SmaskX), 0);

      for y:=0 to 119 do begin
       move(bufor[$000+y*2], SmaskX[$000+y], 1);
       move(bufor[$100+y*2], SmaskX[$100+y], 1);
       move(bufor[$200+y*2], SmaskX[$200+y], 1);
       move(bufor[$300+y*2], SmaskX[$300+y], 1);
       move(bufor[$400+y*2], SmaskX[$400+y], 1);
       move(bufor[$500+y*2], SmaskX[$500+y], 1);
       move(bufor[$600+y*2], SmaskX[$600+y], 1);
       move(bufor[$700+y*2], SmaskX[$700+y], 1);
       move(bufor[$800+y*2], SmaskX[$800+y], 1);
      end;

      move(Spr0, bufor, sizeof(Spr0));
      fillchar(Spr0, sizeof(Spr0), 0);
      for y:=0 to 119 do begin
       move(bufor[y*4], Spr0[y], 2);
      end;

      move(Spr1, bufor, sizeof(Spr1));
      fillchar(Spr1, sizeof(Spr1), 0);
      for y:=0 to 119 do begin
       move(bufor[y*4], Spr1[y], 2);
      end;

      move(Spr2, bufor, sizeof(Spr2));
      fillchar(Spr2, sizeof(Spr2), 0);
      for y:=0 to 119 do begin
       move(bufor[y*4], Spr2[y], 2);
      end;

      move(Spr3, bufor, sizeof(Spr3));
      fillchar(Spr3, sizeof(Spr3), 0);
      for y:=0 to 119 do begin
       move(bufor[y*4], Spr3[y], 2);
      end;

      move(mis0, bufor, sizeof(mis0));
      fillchar(mis0, sizeof(mis0), 0);
      for y:=0 to 119 do begin
       move(bufor[y*4], mis0[y], 2);
      end;

      move(mis1, bufor, sizeof(mis1));
      fillchar(mis1, sizeof(mis1), 0);
      for y:=0 to 119 do begin
       move(bufor[y*4], mis1[y], 2);
      end;

      move(mis2, bufor, sizeof(mis2));
      fillchar(mis2, sizeof(mis2), 0);
      for y:=0 to 119 do begin
       move(bufor[y*4], mis2[y], 2);
      end;

      move(mis3, bufor, sizeof(mis3));
      fillchar(mis3, sizeof(mis3), 0);
      for y:=0 to 119 do begin
       move(bufor[y*4], mis3[y], 2);
      end;


      move(Sprajt, bufor, sizeof(Sprajt));
      fillchar(Sprajt, sizeof(Sprajt), 0);

      for y:=0 to 119 do
       move(bufor[y*sizeof(tablica_sprite)*2], Sprajt[y][0], sizeof(tablica_sprite));


      move(SprajtX, bufor, sizeof(SprajtX));
      fillchar(SprajtX, sizeof(SprajtX), 0);

      for y:=0 to 119 do
       move(bufor[y*sizeof(tablica_sprite)*2], SprajtX[y][0], sizeof(tablica_sprite));
}

      UstawKolory;

      form1.showMic;
      form1.cnv;

end;


procedure TForm1.NegativeImageClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* BITMAP INVERS                                                              *)
(*----------------------------------------------------------------------------*)
begin

 if form1.BMPLimitations1.Checked then ZamknijBMPLimitations;

//  if FEditBMP.Visible then
  case drawMode of
   Select, SelectAlign: begin Negative; exit end;
  end;

 pDraw:=Point(CzarnyPas div Pixel,0);
 pMark:=Point(CzarnyPas,0);
 lMark:=Point(CzarnyPas+Szerokosc,Wysokosc);

 Negative;

 SelectAreaUpdate;
end;


procedure TForm1.RotateRightClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* ROTATE RIGHT/LEFT                                                          *)
(*----------------------------------------------------------------------------*)
var mode: byte;
begin

 if form1.BMPLimitations1.Checked then ZamknijBMPLimitations;

 mode:=TMainMenu(Sender).Tag;

// if FEditBMP.Visible then
  case drawMode of
   Select, SelectAlign: begin RotateFlip(mode); exit end;
  end;

 pDraw:=Point(CzarnyPas div Pixel,0);
 pMark:=Point(CzarnyPas,0);
 lMark:=Point(CzarnyPas+Szerokosc,Wysokosc);

 RotateFlip(mode);

 SelectAreaUpdate;
end;


procedure TForm1.FormKeyDown(var MousePos: TPoint);
begin

// if FEditBMP.Visible then begin

  if KeyMove in [vk_left, vk_right, vk_up, vk_down] then begin

   if FEditBMP.Visible then
    image4.OnMouseMove(image4,[],MousePos.X,MousePos.Y)
   else
    image1.OnMouseMove(image1,[],MousePos.X,MousePos.Y);

  end;

  if FEditBMP.Visible then FEditBMP.FormKeyUp(self, KeyMove, []);

// end;


 if edit then
  case KeyMove of
   vk_NUMPAD4: if yel_wid>1 then begin dec(yel_wid); create_yellow_cursor; Shp:=Point(0,0) end;
   vk_NUMPAD6: if yel_wid<9 then begin inc(yel_wid); create_yellow_cursor; Shp:=Point(0,0) end;
   vk_NUMPAD8: if yel_hig>1 then begin dec(yel_hig); create_yellow_cursor; Shp:=Point(0,0) end;
   vk_NUMPAD2: if yel_hig<9 then begin inc(yel_hig); create_yellow_cursor; Shp:=Point(0,0) end;

      vk_left: begin if CurShp.X>0            then dec(CurShp.X); Cur:=CurShp; showCur end;
     vk_right: begin if CurShp.X+yel_wid<48   then inc(CurShp.X); Cur:=CurShp; showCur end;
        vk_up: begin if CurShp.Y>0            then dec(CurShp.Y); Cur:=CurShp; showCur end;
      vk_down: begin if CurShp.Y+yel_hig<30   then inc(CurShp.Y); Cur:=CurShp; showCur end;

//     vk_space: FMove.Button8Click(form1);
  end;

end;


procedure TForm1.TestKeyDown(Var Msg:TMsg; var Handled:Boolean);
var MousePos: TPoint;
begin

 if Msg.message=WM_KEYUP then
  if (Msg.wParam in [VK_SHIFT, VK_CONTROL]) then begin

   ShiftCtrl:=false

  end;


 if Msg.message=WM_KEYDOWN then

 if (Msg.wParam in [VK_SHIFT, VK_CONTROL]) then begin

  ShiftCtrl:=true;

 end else

 if (Msg.wParam in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, vk_NUMPAD2, vk_NUMPAD4, vk_NUMPAD6, vk_NUMPAD8{, vk_SPACE}]) then begin

//  and
// ((Msg.hwnd=FZoom.ScrollBox1.Handle) or (Msg.hwnd=Form1.Image1.Picture.Bitmap.Handle)) then
//   begin

    GetCursorPos(MousePos);

    KeyMove:=Msg.wParam;

    if FZoom.Visible then
     FZoom.FormKeyDown(MousePos)
    else
     FormKeyDown(MousePos);

  end;

end;


procedure TForm1.ctrlv1Click(Sender: TObject);
begin
 PasteClick(Sender);
end;


procedure TForm1.EditCopy1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CTRL + C                                                                   *)
(*----------------------------------------------------------------------------*)
begin

 EditPaste1.Enabled:=true;

 if FEditRasters.Visible then FEditRasters.Copy else
 if FMove.Visible then FMove.Copy else
 if FEditColors.Visible then FEditColors.Copy else
 if FEditPMG.Visible then FEditPMG.Copy else
 if FEditCharset.Visible then GetChars else

 if FEditBMP.Visible then 
 if drawMode<>SPaste then begin

  if form1.BMPLimitations1.Checked then ZamknijBMPLimitations;

  if FEditBMP.Visible then
   case drawMode of
    Select, SelectAlign: begin CopyBMP; exit end;
   end;

  pDraw:=Point(CzarnyPas div Pixel,0);
  pMark:=Point(CzarnyPas,0);
  lMark:=Point(CzarnyPas+Szerokosc,Wysokosc);

  CopyBMP;

 end;

end;


procedure TForm1.PasteClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CTRL + V  (PASTE from ClipBoard)                                           *)
(*----------------------------------------------------------------------------*)
var bmp: TBitmap;
    lStream: TMemoryStream;
    mPos: TPoint;
begin

 if FEditRasters.Visible then FEditRasters.Paste else
 if FMove.Visible then FMove.Paste else
 if FEditColors.Visible then FEditColors.Paste else
 if FEditPMG.Visible then FEditPMG.Paste else
 if FEditCharset.Visible then begin form1.ZapiszUndo; SaveAfterExit:=true; PutChars end else

 if FEditBMP.Visible then begin

  if not(drawMode in [Select, SelectAlign, SPaste]) then begin
   Select_OFF(false); FEditBMP.ToolSelectClick(FEditBMP.ToolSelect);
  end;

  mOfset:=Point(0,0);

  lStream := TMemoryStream.Create;

  lStream.LoadFromFile(GetUndoName(copypaste));

  lStream.Read(pMark, sizeof(pMark));
  lStream.Read(lMark, sizeof(lMark));

  bmp:=TBitmap.Create;
  bmp.LoadFromStream(lStream);

  lStream.Read(copy_tab, sizeof(copy_tab));

  lStream.Free;

  Paste(bmp.Canvas);

  bmp.Free;

  GetCursorPos(mPos);
  SetCursorPos(mPos.x, mPos.y);

//  Image4MouseMove(self, [], MousePos.X, MousePos.Y);
 end else
  if ClipBoard.HasFormat(CF_BITMAP) then begin

   bmp:=TBitmap.Create;
   bmp.LoadFromClipboardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0);

   current_filename:=GetUndoName('clipboard.bmp');
   bmp.SaveToFile(current_filename);
   bmp.Free;

   LoadBMP;
   
  end;

end;


procedure TForm1.EditSelectAll1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CTRL + A                                                                   *)
(*----------------------------------------------------------------------------*)
begin

 if FEditBMP.Visible then SelectAll else
 if FEditColors.Visible then FEditColors.SelectAll else
 if FEditPMG.Visible then FEditPMG.SelectAll else
 if FEditPalette.Visible then FEditPalette.SelectAll else
 if FEditRasters.Visible then FEditRasters.SelectAll else
 if FMove.Visible then FMove.SelectAll;
 
end;


procedure TForm1.EditSelectNone1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CTRL+D                                                                     *)
(*----------------------------------------------------------------------------*)
begin
 if FEditBMP.Visible then SelectNone;
end;


procedure TForm1.bmp1Click(Sender: TObject);
// SHORTCUT's
begin

 if done>0 then begin
  SaveDialog1.FilterIndex := TForm(Sender).Tag;
  Form1.SaveAs1Click(form1);
 end;

end;


procedure TForm1.EditCut1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CTRL + X                                                                   *)
(*----------------------------------------------------------------------------*)
begin

 if FEditBMP.Visible or FEditCharset.Visible then begin
  EditCopy1Execute(Sender); DeleteSelect;
 end else
  if done>0 then begin
   SaveDialog1.FilterIndex := 4;
   Form1.SaveAs1Click(form1);
  end;

end;


procedure TForm1.EditDelete1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CTRL + Del                                                                 *)
(*----------------------------------------------------------------------------*)
begin

 if FEditCharset.Visible then FEditCharset.Fill1Click(self) else 
 if FMove.Visible then FMove.Delete else
 if FEditPMG.Visible then FEditPMG.Delete else
 if FEditColors.Visible then FEditColors.Delete else 
 if FEditBMP.Visible then DeleteSelect else
 if FEditRasters.Visible then FEditRasters.Delete;
  
end;


procedure TForm1.EditDelete1Update(Sender: TObject);
begin
 EditDelete1.Enabled:=true;      // potrafi je wylaczyc !!! nie znam przyczyny !!!
 EditCopy1.Enabled:=true;
end;


procedure TForm1.preview1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CTRL + R                                                                   *)
(*----------------------------------------------------------------------------*)
begin
 PreviewButton;

 SaveAfterExit:=false;
end;


procedure mysz_poza;
begin

 if FEditBMP.Visible then
  exit
 else begin
  klikEdit:=false;
  bMarquee:=false;
 end;

end;


procedure TForm1.StatusBar1MouseEnter(Sender: TObject);
begin
 mysz_poza;
end;

procedure TForm1.StatusBar1MouseLeave(Sender: TObject);
begin
 mysz_poza;
end;

procedure TForm1.FormMouseEnter(Sender: TObject);
begin
 mysz_poza;
end;

procedure TForm1.FormMouseLeave(Sender: TObject);
begin
 mysz_poza;
end;


procedure TForm1.GetChars;
(*----------------------------------------------------------------------------*)
(* CTRL + C                                                                   *)
(* zapamietanie w buforze (zaznaczonego zoltym kursorem) obszaru              *)
(*----------------------------------------------------------------------------*)
var x, y, i: byte;
    ofs, tmp: integer;
begin
 form1.SetFocus;

 ofs:=CurShp.X+tmul48[CurShp.Y] shl 3;

 for y:=0 to yel_hig-1 do
  for x:=0 to yel_wid-1 do begin
   tmp:=ofs+x+tmul48[y] shl 3;

   if (CurShp.X+x<48) and (CurShp.Y+y<30) then begin
    old_zestaw[x,y].inv:=scren[{form1.Sofs}CurShp.X+x+tmul48[CurShp.Y+y]]>127;

    if gfxMode[CurShp.Y+y] in [1,4] then
     for i:=0 to 7 do old_zestaw[x,y].tb[i]:=tab[tmp+tmul48[i]] xor ($FF*ord(old_zestaw[x,y].inv))   // !!! koniecznie dla HiRes
    else
     for i:=0 to 7 do old_zestaw[x,y].tb[i]:=tab[tmp+tmul48[i]];

    old_zestaw[x,y].inv2:=invers2[{form1.Sofs}CurShp.X+x+tmul48[CurShp.Y+y]]>127;
   end;

  end;

end;


procedure TForm1.PutChars;
(*----------------------------------------------------------------------------*)
(* wypelniamy obszar ograniczony zoltym kursorem zapamietana grafika          *)
(*----------------------------------------------------------------------------*)
var ofs, mul: integer;
    a, x, y, i: byte;
begin

ofs:=CurShp.X+tmul48[CurShp.Y] shl 3;

for y:=0 to yel_hig-1 do
 for x:=0 to yel_wid-1 do begin

  mul:=ofs+x+tmul48[y] shl 3;

  if (CurShp.X+x<48) and (CurShp.Y+y<30) then begin
   for i:=0 to 7 do tab[mul+tmul48[i]]:=old_zestaw[x,y].tb[i];
   invers[{Sofs}CurShp.X+x+tmul48[CurShp.Y+y]]:=ord(old_zestaw[x,y].inv)*$80;
   invers2[{Sofs}CurShp.X+x+tmul48[CurShp.Y+y]]:=ord(old_zestaw[x,y].inv2)*$80;
  end;

 end;

 ShowChars(0,29,true);

 a:=scren[Sofs(CurShp.X,tmul48[CurShp.Y])];

 PutChar(a);

 showCur;
end;


procedure TForm1.SaveData1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* SAVE ALL DATA FILES                                                        *)
(*----------------------------------------------------------------------------*)
begin
 eol_:=false; SaveAll;
end;


procedure TForm1.SaveASM1Execute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* SAVE ASM FILE                                                              *)
(*----------------------------------------------------------------------------*)
begin
 SaveDialog1.FilterIndex:=8;
 SaveAs1Click(self);
end;


procedure TForm1.ZoomExecute(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* ZOOM                                                                       *)
(*----------------------------------------------------------------------------*)
var i: byte;
begin

 if FZoom.Visible then
  form1.zamknij(f_Zoom)
 else begin
  Zoom.Checked:=true;

  for i := 0 to Wysokosc-1 do FEditColors.SetColLine(i, true);

  ZoomPalette.Bitmap.Assign(image6.Picture.Bitmap);

  set_pf_colors;

  Lupa;
 end;

end;


(*----------------------------------------------------------------------------*)
(* FADE LEFT/RIGHT                                                            *)
(*----------------------------------------------------------------------------*)

procedure TForm1.DeletePMG(const a,lf,s: integer);
// okreslenie pozycji piksli PMG i ich skasowanie
// lf - lewa krawedz
// s  - szerokosc zaznaczenia

var x, i, k: integer;
    v: byte;
begin

 for x := lf to lf+s-1 do begin

  v:=Sprajt[a, x];

  i:=PMG_hpos(Spr0[a]) - 32;
  k:=(x-i) div (PMG_size(Spr0[a]) + 1);
  if v and $01<>0 then Smask[$000+a]:=Smask[$000+a] and tand1[k];   // Spr0

//  form1.Caption:=inttostr(k)+','+inttostr(i)+','+inttostr(x);

  i:=PMG_hpos(Mis0[a]) - 32;
  k:=(x-i) div (PMG_size(Mis0[a]) + 1);
  if v and $02<>0 then Smask[$100+a]:=Smask[$100+a] and tand1[k];   // Mis0

  i:=PMG_hpos(Spr1[a]) - 32;
  k:=(x-i) div (PMG_size(Spr1[a]) + 1);
  if v and $04<>0 then Smask[$200+a]:=Smask[$200+a] and tand1[k];   // Spr1

  i:=PMG_hpos(Mis1[a]) - 32;
  k:=(x-i) div (PMG_size(Mis1[a]) + 1);
  if v and $08<>0 then Smask[$300+a]:=Smask[$300+a] and tand1[k];   // Mis1

  i:=PMG_hpos(Spr2[a]) - 32;
  k:=(x-i) div (PMG_size(Spr2[a]) + 1);
  if v and $10<>0 then Smask[$400+a]:=Smask[$400+a] and tand1[k];   // Spr2

  i:=PMG_hpos(Mis2[a]) - 32;
  k:=(x-i) div (PMG_size(Mis2[a]) + 1);
  if v and $20<>0 then Smask[$500+a]:=Smask[$500+a] and tand1[k];   // Mis2

  i:=PMG_hpos(Spr3[a]) - 32;
  k:=(x-i) div (PMG_size(Spr3[a]) + 1);
  if v and $40<>0 then Smask[$600+a]:=Smask[$600+a] and tand1[k];   // Spr3

  i:=PMG_hpos(Mis3[a]) - 32;
  k:=(x-i) div (PMG_size(Mis3[a]) + 1);
  if v and $80<>0 then Smask[$700+a]:=Smask[$700+a] and tand1[k];   // Mis3

 end;

end;


procedure FADE_HSCROL;
(*----------------------------------------------------------------------------*)
(* zapisze kolejne kolumny z grafika PMG                                      *)
(*----------------------------------------------------------------------------*)
var i,j,k: integer;
    lStream: TMemoryStream;
    t: string;
begin

 Screen.Cursor:=crHourGlass;

 lStream := TMemoryStream.Create;
 form1.WriteUndoStream(lStream);

 for k := 0 to Bajt-1 do begin

  lStream.Position:=0;
  form1.ReadUndoStream(lStream);

  for i:=0 to Bajt-1 do begin

   if i<>k then
    for j := 0 to Wysokosc-1 do form1.DeletePMG(j, (i+CzarnyPas shr 3) shl 2, 4);

  end;

  t:=inttostr(k);
  if k<10 then t:='0'+t;

  SavePMG(true, form1.GetUndoName('hfade'+t+'.pmg'));

 end;

 lStream.Position:=0;
 form1.ReadUndoStream(lStream);
 lStream.Free;

 form1.showMIC;

 Screen.Cursor:=crDefault;

end;


procedure FADE_HCOL(k: integer; var f: textfile);
var t: string;
    i, y, rh: integer;
    v: byte;
begin

 t:=inttostr(k);
 if k<10 then t:='0'+t;

 if Fox1 then
  rh:=4
 else
  rh:=8;

 writeln(f, #13#10'; ------------'#9'column #',k,#13#10);

 for i := 0 to (Wysokosc div rh)-1 do begin

  write(f, 'c',k,'r',i);

  v:=0;

  for y := 0 to rh-1 do if bufor[$000+i*rh+y]<>0 then begin v:=v or $80; Break end;
  for y := 0 to rh-1 do if bufor[$100+i*rh+y]<>0 then begin v:=v or $40; Break end;
  for y := 0 to rh-1 do if bufor[$200+i*rh+y]<>0 then begin v:=v or $20; Break end;
  for y := 0 to rh-1 do if bufor[$300+i*rh+y]<>0 then begin v:=v or $10; Break end;
  for y := 0 to rh-1 do if bufor[$400+i*rh+y]<>0 then begin v:=v or $08; Break end;

  writeln(f); write(f, #9,'.he ', IntToHex(v,2));

  if v and $80<>0 then begin
   writeln(f); write(f, #9,'.he');
   for y := 0 to rh-1 do write(f, ' ',IntToHex(bufor[$000+i*rh+y],2) );
  end;

  if v and $40<>0 then begin
   writeln(f); write(f, #9,'.he');
   for y := 0 to rh-1 do write(f, ' ',IntToHex(bufor[$100+i*rh+y],2) );
  end;

  if v and $20<>0 then begin
   writeln(f); write(f, #9,'.he');
   for y := 0 to rh-1 do write(f, ' ',IntToHex(bufor[$200+i*rh+y],2) );
  end;

  if v and $10<>0 then begin
   writeln(f); write(f, #9,'.he');
   for y := 0 to rh-1 do write(f, ' ',IntToHex(bufor[$300+i*rh+y],2) );
  end;

  if v and $08<>0 then begin
   writeln(f); write(f, #9,'.he');
   for y := 0 to rh-1 do write(f, ' ',IntToHex(bufor[$400+i*rh+y],2) );
  end;

  writeln(f);
 end;

end;


procedure TForm1.SaveHCol;
var k, f: integer;
    t: string;
    txt: textfile;
begin

 FADE_HSCROL;

// odczytamy kolejne pliki HFADE...PMG i zapiszemy jako 30 wierszy

 assignfile(txt, form1.snazwa+'.hcl'); rewrite(txt);

 for k := 0 to Bajt-1 do begin

  t:=inttostr(k);
  if k<10 then t:='0'+t;

  f:=FileOpen(GetUndoName('hfade'+t+'.pmg'), fmOpenRead );
  FileRead(f, bufor, 8);
  FileRead(f, bufor, sizeof(bufor));
  FileClose(f);

  FADE_HCOL(k, txt);
 end;

 flush(txt);
 closefile(txt);

end;


end.
