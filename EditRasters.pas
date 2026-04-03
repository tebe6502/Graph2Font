
// tablica RASTER

// $00, $XX   NOP ($XX-1)

// $01, $XX   LDA #$XX
// $02, $XX   LDX #$XX
// $03, $XX   LDY #$XX

// $41, $XX   LDA0 $XX
// $42, $XX   LDX0 $XX
// $43, $XX   LDY0 $XX

// $61, $XX   LDA $XX
// $62, $XX   LDX $XX
// $63, $XX   LDY $XX

// $81, REG   STA REG          $d0xx
// $82, REG   STX REG
// $83, REG   STY REG


unit EditRasters;

interface

uses
  Windows, Graphics, Controls, Forms, StdCtrls, Buttons, Classes, SysUtils,
  ExtCtrls, Main, BMDSpinEdit, LineRange, Menus, ComCtrls;

type
  TFEditRasters = class(TForm)
    Panel2: TPanel;
    LineOfsetLabel: TLabel;
    LineOfsetRadioButton: TRadioButton;
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ScrollBox1: TScrollBox;
    Panel3: TPanel;
    GTIARegisterList: TComboBox;
    Label24: TLabel;
    Label7: TLabel;
    Panel4: TPanel;
    Apply: TButton;
    frameLineRange1: TframeLineRange;
    Panel5: TPanel;
    GlobalOfset: TTrackBar;
    seValue: TBMDSpinEdit;
    seNop: TBMDSpinEdit;
    procedure RadioButtonClick(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GTIARegisterListChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseForm12;
    procedure ComboBoxEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ZakresRastra;
    procedure RasterLinia;
    procedure ButtonClick(Sender: TObject);
    procedure GTIARegisterListDblClick(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure GlobalOfsetChange(Sender: TObject);
    procedure SaveTGtia(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure frameLineRange1seLineChange(Sender: TObject);
    procedure frameLineRange1seRangeChange(Sender: TObject);
    procedure frameLineRange1bGetClick(Sender: TObject);
    procedure LineChange;
    procedure ValLabelClick(Sender: TObject);
    procedure LabelSelectColor(Sender: TObject);
    procedure GTIARegisterListCloseUp(Sender: TObject);
    procedure seValueChange(Sender: TObject);
    procedure seNopChange(Sender: TObject);
    procedure SelectAll;
    procedure Copy;
    procedure Paste;
    procedure Delete;
    procedure seNopContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);


  private
    { Private declarations }
   old_raster_ofset: integer;

   gti_label: array [0..31] of TBMDSpinEdit;

   val_combo: array [0..31] of TComboBox;
   rad_buton: array [0..31] of TRadioButton;
   val_label: array [0..31] of TLabel;

   BlokujZapistGtia: Boolean;

   _nop: integer;

  public
    { Public declarations }
  end;

var
  FEditRasters: TFEditRasters;
  idx, idx2: byte;
  raster_temp_ofset, raster_bufor_o: tRaster;
  raster_bufor, raster_temp, temp: tARaster;

//  buforR: array [0..$120] of byte;


implementation

{$R *.dfm}

uses EditPMG, SelectColor, EditColors;


function GetLineValue: integer;
begin
 Result:=FEditRasters.frameLineRange1.seLine.Position;
end;


function GetRangeValue: integer;
begin
 Result:=FEditRasters.frameLineRange1.seRange.Position;
end;


procedure UstawScrollBar;
var i: integer;
begin

if AktywnyRaster=0 then begin

 case raster_temp_ofset.cod of
         0: begin
             FEditRasters.seNOP.Position := raster_temp_ofset.arg;
            end;

  $41..$43, 1..3:
            begin
             FEditRasters.seValue.Position := raster_temp_ofset.arg;
            end;
 end;

end else begin

 i:=AktywnyRaster-1;

 case raster_temp[i].cod of
         0: begin
             FEditRasters.seNOP.Position := raster_temp[i].arg;
            end;

  $41..$43, $61..$63, 1..3:
            begin
             FEditRasters.seValue.Position := raster_temp[i].arg;
            end;

  $81..$83: begin
             FEditRasters.GTIARegisterList.ItemIndex:=raster_temp[i].arg;
            end;
 end;

end;

end;


procedure TFEditRasters.LabelSelectColor(Sender: TObject);
var t,l: integer;
begin

 if seValue.Visible then begin

 if not(FSelectColor.Visible) then begin

  form1.SetFormPos('FSelectColor', t, l);
  FSelectColor.Top:=t;
  FSelectColor.Left:=l;

 end;

 FSelectColor.Caption:='Select Color';
 FSelectColor.Visible:=true;
 Ofset:=0;

 FSelectColor.initKolor(AtariPal[seValue.Position]);

 end;

end;


procedure TFEditRasters.ValLabelClick(Sender: TObject);
var a: integer;
begin
 a:=TLabel(Sender).Tag;

 AktywnyRaster := TLabel(Sender).Tag;

 rad_buton[AktywnyRaster].Checked:=true;

 seNOP.Visible:=false;
 seValue.Visible:=false;

 UstawScrollBar;

 GTIARegisterList.Visible:=false;


 if AktywnyRaster=0 then begin

  case Bajt of
   32: if val_combo[AktywnyRaster].ItemIndex>3 then begin
        seValue.Left:=val_label[a].Left;
        seValue.Top:=val_label[a].Top+val_label[a].Height;

        seValue.Visible:=true;
       end;

   40: if val_combo[AktywnyRaster].ItemIndex>1 then begin
        seValue.Left:=val_label[a].Left;
        seValue.Top:=val_label[a].Top+val_label[a].Height;

        seValue.Visible:=true;
       end;
  end;

 end else

 case raster_temp[a-1].cod of

  $81,$82,$83:
       begin
        GTIARegisterList.Left:=val_label[a].Left-8;
        GTIARegisterList.Top:=val_label[a].Top+val_label[a].Height;

        GTIARegisterList.Visible:=true;
        GTIARegisterList.DroppedDown:=true;
       end;

  $01,$02,$03,$41,$42,$43,$61,$62,$63:
       begin
        seValue.Left:=val_label[a].Left;
        seValue.Top:=val_label[a].Top+val_label[a].Height;

        seValue.Visible:=true;
       end;

  $00: begin
        seNOP.Left:=val_label[a].Left;
        seNOP.Top:=val_label[a].Top+val_label[a].Height;

        seNOP.Visible:=true;
       end;

 end;

 if seValue.Visible and FSelectColor.Visible then FSelectColor.initKolor(AtariPal[seValue.Position]);

end;


procedure TFEditRasters.RasterLinia;
var i, j: integer;
begin
 i:=GetLineValue;
 j:=GetRangeValue;

 form1.Sprawdz_Zaznaczenia(i,j);

 frameLineRange1.seLine.Position:=i;    // !!! koniecznie przez TEXT, POSITION nie aktualizuje pola TEXT
 frameLineRange1.seRange.Position:=j;

 form1.Ustaw_Button2_7(i,j);
 form1.Ustaw_Button4_5(i,j,-1,-1);
end;


procedure RozmiarRastra(var i,j:integer; a,b:integer);
begin

if a>44 then a:=44;
if b>44 then b:=44;
if a<-24 then a:=-24;
if b<-24 then b:=-24;

case UseChar of
  true: case Bajt of
         32: begin

              if (a-6 + ord(t_mode(form1.SelectMode.ItemIndex)=m_piccolo)*4) < -14 then
               i:=edge32_2[-14]
              else
               i:=edge32_2[a-6 + ord(t_mode(form1.SelectMode.ItemIndex)=m_piccolo)*4];

              if (b-6 + ord(t_mode(form1.SelectMode.ItemIndex)=m_piccolo)*4) < -14 then
               j:=edge32_2[-14]
              else
               j:=edge32_2[b-6 + ord(t_mode(form1.SelectMode.ItemIndex)=m_piccolo)*4];

             end;
         40: begin
              i:=edge40_2[a - (ord(t_mode(form1.SelectMode.ItemIndex) = m_piccolo)*11)];
              j:=edge40_2[b - (ord(t_mode(form1.SelectMode.ItemIndex) = m_piccolo)*11)];
             end;
        end;

 false: case Bajt of
         32: begin
              i:=edge32_gfx[a];
              j:=edge32_gfx[b];
             end;

         40: begin
              i:=edge40_gfx[a - (ord(t_mode(form1.SelectMode.ItemIndex) = m_pgr)*7)];
              j:=edge40_gfx[b - (ord(t_mode(form1.SelectMode.ItemIndex) = m_pgr)*7)];
             end;
        end;
end;

end;


function ObliczOfset: integer;
begin

 Result:=0;

 if t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr, m_piccolo] then
  case Bajt of
   32: case FEditRasters.val_combo[0].ItemIndex of
        1,4,5,6: Result:=2;
        2,7,8,9: Result:=3;
        3: Result:=5;
       end;

   40: case FEditRasters.val_combo[0].ItemIndex of
        1..4: Result:=3;
       end;
  end;

end;


procedure TFEditRasters.ZakresRastra;
var i, j, a, b, y: integer;
    tcycles: array [0..31] of byte;
begin

 fillchar(tcycles, sizeof(tcycles), 0);

 y:=GetLineValue;

 b:=ObliczOfset;

 for i:=0 to RLimitInst-1 do begin

  tcycles[i]:=b;

  case raster_temp[i].cod of
          0: inc(b, raster_temp[i].arg);
       1..3: inc(b, 2);
   $41..$43: inc(b, 3);
   $61..$63: inc(b, 4);
   $81..$83: inc(b, 4);
  end;

 end;

 a:=0;
 b:=0;

 if AktywnyRaster>0 then begin
  a:=tcycles[AktywnyRaster-1]+raster_ofset;
  b:=tcycles[AktywnyRaster]+raster_ofset;
 end;

 RozmiarRastra(i,j,a,b);

 if gfxMode[y shr 3]<>0 then
  a:=gfxMode[y shr 3]
 else
  a:=Pixel;

 form1.Ustaw_Button4_5(-1,-1,i+pozX,j+pozX);

 RasterLinia;

 i:=(i-CzarnyPas) div a; if i<0 then i:=0;
 j:=(j-CzarnyPas) div a; if j<0 then j:=0;

 if j<i+1 then j:=i+1;

 FEditRasters.StatusBar1.Panels[2].Text:='Pixels: '+IntToStr(i+1)+' - '+IntToStr(j);

end;


function Ustal(const i: byte):integer;
// ustalenie pozycji w ComboBox-ie
var v: byte;
begin

 v:=raster_temp[i-1].cod;

 case v of
         0: Ustal := 12;
      1..3: Ustal := v-1;
  $41..$43: Ustal := (v and 3)+2;     // lda0
  $61..$63: Ustal := (v and 3)+5;     // lda 
  $81..$83: Ustal := (v and 3)+8;     // sta
 else
  Ustal:=0;
 end;

end;


function getVal(const i: integer): string;
// i - numer rastra, a to tryb zapisu loa, sav, nop (0..2)
var v, v2: byte;
    zm: string;
begin

zm:='';

v:=raster_temp[i-1].cod;

if idx<3 then
 case v of
  $41..$43, $61..$63, 1..2: begin {buforR[idx]:=raster_temp[i-1].arg;} inc(idx) end;
 end;

if idx2<3 then
 case v of
  $81..$82: begin {buforR[$100+idx2]:=raster_temp[i-1].arg;} inc(idx2) end;
 end;

 case v of
         0: begin                           // NOP
             v2:=raster_temp[i-1].arg;

             if v2=1 then v2:=2;

             raster_temp[i-1].arg:=v2;

             FEditRasters.val_combo[i].ItemIndex:=12;

             zm:=form1.Hex(raster_temp[i-1].arg,2);
            end;

  $41..$43, $61..$63, 1..3: zm:=form1.Hex(raster_temp[i-1].arg,2);

  $81..$83: zm:=AnsiUpperCase(form1.registry_label($d000+raster_temp[i-1].arg)); //zm:=form1.Hex($d000+raster_temp[i-1].arg,4);
 end;

 getVal:=zm;

end;


procedure ObliczCykle;
var err: byte;
    tmp: integer;
    txt: string;
begin

// liczymy cykle ktore ustawil user w okienku, a nie w linii

 cycle:=ObliczOfset;

 for err:=1 to RLimitInst do
  case FEditRasters.val_combo[err].ItemIndex of
     0..2: inc(cycle, 2);
     3..5: inc(cycle, 3);
     6..8: inc(cycle, 4);
    9..11: inc(cycle, 4);
       12: inc(cycle, raster_temp[err-1].arg);
  end;

 if not (t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo]) then inc(cycle, AddCycle);


 tmp:=LimitCycle;

 if (t_mode(form1.SelectMode.ItemIndex) = m_piccolo) and (GetLineValue mod 8=0) then
  case Bajt of
   32: LimitCycle:=42;
   40 :LimitCycle:=27;
  end;


 txt:='Cycles: '+IntToStr(cycle)+' / '+IntToStr(LimitCycle);

 if form1.RasterDisabled(GetLineValue) then txt:=txt+' --- badline';

 FEditRasters.StatusBar1.Panels[1].Text:=txt;

 if (Cycle=LimitCycle) or (LimitCycle-Cycle>1) then
  FEditRasters.StatusBar1.Color:=clBtnFace
 else
  FEditRasters.StatusBar1.Color:=clRed;

 LimitCycle := tmp;

end;


procedure lbColor(var l:TLabel; const v: byte);
begin

 if v<2 then
  l.Font.Color:=clWhite
 else
  l.Font.Color:=clBlack;

 l.Color:=AtariPal[v];

end;


procedure Aktualizuj;
// ustalamy ItemIndex dla ComboBox i Caption dla Label
var a,x,y, v: byte;
    i: integer;
begin

 i:=GetLineValue;

 a:=rKolor[i, 10];
 x:=rKolor[i, 11];
 y:=rKolor[i, 12];


 idx:=0; idx2:=0; v:=0;

 if t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr, m_piccolo] then begin

  FEditRasters.LineOfsetLabel.Caption:=form1.Hex(raster_temp_ofset.arg,2);

  case Bajt  of
   32: case raster_temp_ofset.cod of
        0: case raster_temp_ofset.arg of
            0: FEditRasters.val_combo[0].ItemIndex:=0;
            2: FEditRasters.val_combo[0].ItemIndex:=1;
            3: FEditRasters.val_combo[0].ItemIndex:=2;
            5: FEditRasters.val_combo[0].ItemIndex:=3;
           end;

          1: FEditRasters.val_combo[0].ItemIndex:=4;
          2: FEditRasters.val_combo[0].ItemIndex:=5;
          3: FEditRasters.val_combo[0].ItemIndex:=6;
        $41: FEditRasters.val_combo[0].ItemIndex:=7;
        $42: FEditRasters.val_combo[0].ItemIndex:=8;
        $43: FEditRasters.val_combo[0].ItemIndex:=9;
       end;

   40: case raster_temp_ofset.cod of
        0: case raster_temp_ofset.arg of
            0: FEditRasters.val_combo[0].ItemIndex:=0;
            3: FEditRasters.val_combo[0].ItemIndex:=1;
           end;

        $41: FEditRasters.val_combo[0].ItemIndex:=2;
        $42: FEditRasters.val_combo[0].ItemIndex:=3;
        $43: FEditRasters.val_combo[0].ItemIndex:=4;
       end;
  end;

  if raster_temp_ofset.cod=0 then FEditRasters.val_combo[0].Hint:=IntToStr(raster_temp_ofset.arg)+' cycles' else
   if raster_temp_ofset.cod in [1..3] then FEditRasters.val_combo[0].Hint:='2 cycles' else
    if raster_temp_ofset.cod in [$41..$43] then FEditRasters.val_combo[0].Hint:='3 cycles';

  with FEditRasters do
  case raster_temp_ofset.cod of
     0: begin v:=raster_temp_ofset.arg; val_label[0].Color:=clMenu; val_label[0].Font.Color:=clBlack end;      // nop

     1: begin v:=2; a:=raster_temp_ofset.arg; lbColor(val_label[0], a) end;  // lda #
     2: begin v:=2; x:=raster_temp_ofset.arg; lbColor(val_label[0], x) end;  // ldx #
     3: begin v:=2; y:=raster_temp_ofset.arg; lbColor(val_label[0], y) end;  // ldy #

   $41: begin v:=3; a:=raster_temp_ofset.arg; lbColor(val_label[0], a) end;  // lda z
   $42: begin v:=3; x:=raster_temp_ofset.arg; lbColor(val_label[0], x) end;  // ldx z
   $43: begin v:=3; y:=raster_temp_ofset.arg; lbColor(val_label[0], y) end;  // ldy z
  end;

  FEditRasters.val_combo[0].Hint:=IntToStr(v)+' cycles';
  FEditRasters.val_label[0].Hint:=FEditRasters.val_label[0].Caption;

 end;


with FEditRasters do
for i:=1 to RLimitInst do begin
 val_combo[i].ItemIndex := Ustal(i);
 val_label[i].Caption   := getVal(i);
 val_label[i].Hint      := val_label[i].Caption;

 case val_combo[i].ItemIndex of
   0: begin v:=2; a:=raster_temp[i-1].arg; lbColor(val_label[i], a) end;     // lda #
   1: begin v:=2; x:=raster_temp[i-1].arg; lbColor(val_label[i], x) end;     // ldx #
   2: begin v:=2; y:=raster_temp[i-1].arg; lbColor(val_label[i], y) end;     // ldy #

   3: begin v:=3; a:=raster_temp[i-1].arg; lbColor(val_label[i], a) end;     // lda z
   4: begin v:=3; x:=raster_temp[i-1].arg; lbColor(val_label[i], x) end;     // ldx z
   5: begin v:=3; y:=raster_temp[i-1].arg; lbColor(val_label[i], y) end;     // ldy z

   6: begin v:=4; a:=raster_temp[i-1].arg; lbColor(val_label[i], a) end;     // lda q
   7: begin v:=4; x:=raster_temp[i-1].arg; lbColor(val_label[i], x) end;     // ldx q
   8: begin v:=4; y:=raster_temp[i-1].arg; lbColor(val_label[i], y) end;     // ldy q

   9: begin v:=4; lbColor(val_label[i], a) end;
  10: begin v:=4; lbColor(val_label[i], x) end;
  11: begin v:=4; lbColor(val_label[i], y) end;

  12: begin v:=raster_temp[i-1].arg; val_label[i].Color:=clMenu; val_label[i].Font.Color:=clBlack end;
 end;

 val_combo[i].Hint:=IntToStr(v)+' cycles';

end;

ObliczCykle;

end;


procedure TFEditRasters.RadioButtonClick(Sender: TObject);
begin
 FEditRasters.seNOP.Visible:=false;
 FEditRasters.seValue.Visible:=false;

 GTIARegisterList.Visible:=false;

 AktywnyRaster := TRadioButton(Sender).Tag;

 ZakresRastra;

 UstawScrollBar;
end;


procedure Zapisz(const i,j: integer);
var v, n, a: byte;
begin

 a:=FEditRasters.GTIARegisterList.ItemIndex;

 v:=FEditRasters.seValue.Position;

 n:=FEditRasters.seNOP.Position;

 
// tutaj bawimy siê z LINE OFFSET
 if j=0 then begin

  case Bajt of
   32: case i of
        0: begin raster_temp_ofset.cod:=0; raster_temp_ofset.arg:=0 end;   // nop0
        1: begin raster_temp_ofset.cod:=0; raster_temp_ofset.arg:=2 end;   // nop2
        2: begin raster_temp_ofset.cod:=0; raster_temp_ofset.arg:=3 end;   // nop3
        3: begin raster_temp_ofset.cod:=0; raster_temp_ofset.arg:=5 end;   // nop5
        4: begin raster_temp_ofset.cod:=1; raster_temp_ofset.arg:=v end;   // lda#
        5: begin raster_temp_ofset.cod:=2; raster_temp_ofset.arg:=v end;   // ldx#
        6: begin raster_temp_ofset.cod:=3; raster_temp_ofset.arg:=v end;   // ldz#
        7: begin raster_temp_ofset.cod:=$41; raster_temp_ofset.arg:=v end; // lda0
        8: begin raster_temp_ofset.cod:=$42; raster_temp_ofset.arg:=v end; // ldx0
        9: begin raster_temp_ofset.cod:=$43; raster_temp_ofset.arg:=v end; // ldy0
       end;

   40: case i of
        0: begin raster_temp_ofset.cod:=0; raster_temp_ofset.arg:=0 end;   // nop0
        1: begin raster_temp_ofset.cod:=0; raster_temp_ofset.arg:=3 end;   // nop3
        2: begin raster_temp_ofset.cod:=$41; raster_temp_ofset.arg:=v end; // lda0
        3: begin raster_temp_ofset.cod:=$42; raster_temp_ofset.arg:=v end; // ldx0
        4: begin raster_temp_ofset.cod:=$43; raster_temp_ofset.arg:=v end; // ldy0
       end;
  end;


 end else

// w zaleznosci ktory element jest wybrany w ComboBox
 case i of
   0: begin raster_temp[j-1].cod:=1; raster_temp[j-1].arg:=v end;         // lda #
   1: begin raster_temp[j-1].cod:=2; raster_temp[j-1].arg:=v end;         // ldx #
   2: begin raster_temp[j-1].cod:=3; raster_temp[j-1].arg:=v end;         // ldy #

   3: begin raster_temp[j-1].cod:=$41; raster_temp[j-1].arg:=v end;       // lda0
   4: begin raster_temp[j-1].cod:=$42; raster_temp[j-1].arg:=v end;       // ldx0
   5: begin raster_temp[j-1].cod:=$43; raster_temp[j-1].arg:=v end;       // ldy0

   6: begin raster_temp[j-1].cod:=$61; raster_temp[j-1].arg:=v end;       // lda
   7: begin raster_temp[j-1].cod:=$62; raster_temp[j-1].arg:=v end;       // ldx
   8: begin raster_temp[j-1].cod:=$63; raster_temp[j-1].arg:=v end;       // ldy

   9: begin raster_temp[j-1].cod:=$81; raster_temp[j-1].arg:=a end;       // sta
  10: begin raster_temp[j-1].cod:=$82; raster_temp[j-1].arg:=a end;       // stx
  11: begin raster_temp[j-1].cod:=$83; raster_temp[j-1].arg:=a end;       // sty

  12: begin raster_temp[j-1].cod:=0; raster_temp[j-1].arg:=n end;         // nop
 end;

 Aktualizuj;
end;


procedure TFEditRasters.ComboBoxChange(Sender: TObject);
begin
 FEditRasters.seNOP.Visible:=false;
 FEditRasters.seValue.Visible:=false;

 AktywnyRaster := TComboBox(Sender).Tag;

 rad_buton[AktywnyRaster].Checked:=true;

 BitBtn1Click(FEditRasters);

 ObliczCykle;

 ZakresRastra;

 UstawScrollBar;
end;


procedure TFEditRasters.BitBtn1Click(Sender: TObject);
// naciskam przycisk "APPLY", potwierdzamy zmiany
begin

 Zapisz(val_combo[AktywnyRaster].ItemIndex, AktywnyRaster);

 RasterLinia; Aktualizuj;

 ObliczCykle;

end;


procedure TFEditRasters.ApplyClick(Sender: TObject);
// APPLY
var i, j, a: integer;
begin

 Self.ActiveControl:=nil;

 old_raster_ofset := raster_ofset;

// usuwamy nop-y z konca programu rastra

 i:=high(tARaster);
 while (i>=0) and (raster_temp[i].cod=0) do begin
  raster_temp[i].arg:=0;
  dec(i);
 end;

// usuwamy STA $D01E z konca programu rastra

 i:=high(tARaster);
 while (i>=0) and (raster_temp[i].cod=$81) and (raster_temp[i].arg=$1e) do begin
  raster_temp[i].cod:=0;
  raster_temp[i].arg:=0;
  dec(i);
 end;


 ObliczCykle;


if (Cycle=LimitCycle) or (LimitCycle-Cycle>1) then begin

 SaveAfterExit:=true;

 form1.ZapiszUndo;

 i:=GetLineValue;
 j:=GetRangeValue;

 for a:=i to i+j do begin
  move(raster_temp, raster[a], sizeof(raster_temp));
  move(raster_temp_ofset, raster_line_ofset[a], sizeof(raster_temp_ofset));
 end;

 form1.OdswiezObraz;

end else
 Application.MessageBox('Cycles = Limit', 'Change Rasters',MB_ICONEXCLAMATION);


 ZakresRastra;

 RasterLinia; Aktualizuj;

 ObliczCykle;

 form1.OdswiezObraz;         // !!! koniecznie !!! dla testRaster

end;


procedure TFEditRasters.LineChange;
begin

 seNOP.Visible:=false;
 seValue.Visible:=false;

 move(raster[GetLineValue], raster_temp, sizeof(raster_temp));
 move(raster_line_ofset[GetLineValue], raster_temp_ofset, sizeof(raster_temp_ofset));

// raster_temp:=raster[GetLineValue];
// raster_temp_ofset:=raster_line_ofset[GetLineValue];

 FEditRasters.RasterLinia;

 Aktualizuj;

 UstawScrollBar;

 frameLineRange1.seLineChange(self);

end;


procedure TFEditRasters.frameLineRange1seLineChange(Sender: TObject);
// LINE
begin
 LineChange;
end;


procedure TFEditRasters.frameLineRange1seRangeChange(Sender: TObject);
// RANGE
begin
 RasterLinia;
end;


procedure TFEditRasters.CloseForm12;
begin
 form1.EditRasters.Checked:=false;

 if not(FEditColors.Visible) and not(FEditPMG.Visible) then form1.Usun_Zaznaczenia(false);

 form1.Zamknij(f_SelectColor);           // zamykamy okienko z paleta kolorow
 form1.Zamknij(f_SelectValue);

end;


procedure TFEditRasters.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FEditRasters', top, left);

 GlobalOfset.Position:=old_raster_ofset;

 CloseForm12;
end;


procedure TFEditRasters.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(Key)=27 then
  form1.Zamknij(f_EditRasters);
end;


procedure TFEditRasters.GTIARegisterListChange(Sender: TObject);
begin
 BitBtn1Click(FEditRasters);
end;


procedure TFEditRasters.GTIARegisterListCloseUp(Sender: TObject);
begin
 GTIARegisterList.Visible:=false;
end;


procedure TFEditRasters.frameLineRange1bGetClick(Sender: TObject);
// GET
var i, err, min, max: integer;
    l0: cardinal;
    v: byte;
    rasCRC: array [-1..240] of cardinal;
begin

Self.ActiveControl:=nil;

LineChange;

//obliczenie CRC dla kazdej linii zmiany z rastrem
for v:=0 to 239 do rasCRC[v]:=form1.LiczCRCRaster(v);

i:=GetLineValue;

l0:=rasCRC[i]; //min:=i; max:=i;

// znajdz maksimum
 err:=i;
 while (rasCRC[err]=l0) and (err<240) do inc(err);
 max:=err-1;

// znajdz minimum
 err:=i; while (rasCRC[err]=l0) and (err>-1) do dec(err);
 min:=err+1;

 frameLineRange1.seLine.Position:=min;
 frameLineRange1.seRange.Position:=max-min;

 ZakresRastra;

 Aktualizuj;
end;


procedure TFEditRasters.SaveTGtia(Sender: TObject);
begin

 if BlokujZapistGtia then exit;

 TBMDSpinEdit(Sender).Hint:=form1.Hex(TBMDSpinEdit(Sender).Position,2);


 with tgtia do
  case TBMDSpinEdit(Sender).Tag of

  0: hposp0:=gti_label[0].Position;
  1: hposp1:=gti_label[1].Position;
  2: hposp2:=gti_label[2].Position;
  3: hposp3:=gti_label[3].Position;

  4: hposm0:=gti_label[4].Position;
  5: hposm1:=gti_label[5].Position;
  6: hposm2:=gti_label[6].Position;
  7: hposm3:=gti_label[7].Position;

  8: sizep0:=gti_label[8].Position;
  9: sizep1:=gti_label[9].Position;
  10: sizep2:=gti_label[10].Position;
  11: sizep3:=gti_label[11].Position;

  12: sizem:=gti_label[12].Position;

  13: grafp0:=gti_label[13].Position;
  14: grafp1:=gti_label[14].Position;
  15: grafp2:=gti_label[15].Position;
  16: grafp3:=gti_label[16].Position;

  17: grafm:=gti_label[17].Position;

  18: colpm0:=gti_label[18].Position;
  19: colpm1:=gti_label[19].Position;
  20: colpm2:=gti_label[20].Position;
  21: colpm3:=gti_label[21].Position;

  22: color0:=gti_label[22].Position;
  23: color1:=gti_label[23].Position;
  24: color2:=gti_label[24].Position;
  25: color3:=gti_label[25].Position;
  26: colbak:=gti_label[26].Position;

  27: gtictl:=gti_label[27].Position;
  28: pmcntl:=gti_label[28].Position;

  29: rega:=gti_label[29].Position;
  30: regx:=gti_label[30].Position;
  31: regy:=gti_label[31].Position;

 end;

 form1.OdswiezObraz;

end;


procedure tgtiaShow;
var i: integer;
begin

 with FEditRasters do
 with tgtia do begin

  BlokujZapistGtia:=true;

  gti_label[0].Position:=hposp0;
  gti_label[1].Position:=hposp1;
  gti_label[2].Position:=hposp2;
  gti_label[3].Position:=hposp3;

  gti_label[4].Position:=hposm0;
  gti_label[5].Position:=hposm1;
  gti_label[6].Position:=hposm2;
  gti_label[7].Position:=hposm3;

  gti_label[8].Position:=sizep0;
  gti_label[9].Position:=sizep1;
  gti_label[10].Position:=sizep2;
  gti_label[11].Position:=sizep3;

  gti_label[12].Position:=sizem;

  gti_label[13].Position:=grafp0;
  gti_label[14].Position:=grafp1;
  gti_label[15].Position:=grafp2;
  gti_label[16].Position:=grafp3;

  gti_label[17].Position:=grafm;

  gti_label[18].Position:=colpm0;
  gti_label[19].Position:=colpm1;
  gti_label[20].Position:=colpm2;
  gti_label[21].Position:=colpm3;

  gti_label[22].Position:=color0;
  gti_label[23].Position:=color1;
  gti_label[24].Position:=color2;
  gti_label[25].Position:=color3;
  gti_label[26].Position:=colbak;

  gti_label[27].Position:=gtictl;
  gti_label[28].Position:=pmcntl;

  gti_label[29].Position:=rega;
  gti_label[30].Position:=regx;
  gti_label[31].Position:=regy;

  for i := 0 to 31 do
   gti_label[i].Hint := form1.Hex(gti_label[i].Position,2);


  BlokujZapistGtia:=false;

 end;

end;


procedure TFEditRasters.FormShow(Sender: TObject);
var i: integer;
begin

 for i:=0 to ComponentCount-1 do                 // button przy prawej krawedzi okna
  if (Components[i] is TButton) then
   if Components[i].Tag = 11 then begin
    TButton(Components[i]).Visible:=t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_piccolo];
    Break;
   end;

   
 GlobalOfset.Position:=raster_ofset;
 GlobalOfsetChange(self);
 

 val_combo[0].Items.Clear;
 val_combo[0].Items.Add('nop0');

 if t_mode(form1.SelectMode.ItemIndex) in [m_gedm, m_pgr, m_piccolo] then      // GED--
  case Bajt of
   32: begin
        val_combo[0].Items.Add('nop2');
        val_combo[0].Items.Add('nop3');
        val_combo[0].Items.Add('nop5');
        val_combo[0].Items.Add('lda#');
        val_combo[0].Items.Add('ldx#');
        val_combo[0].Items.Add('ldy#');
        val_combo[0].Items.Add('lda0');
        val_combo[0].Items.Add('ldx0');
        val_combo[0].Items.Add('ldy0');
       end;

   40: begin
        val_combo[0].Items.Add('nop3');
        val_combo[0].Items.Add('lda0');
        val_combo[0].Items.Add('ldx0');
        val_combo[0].Items.Add('ldy0');
       end;
  end;

 val_combo[0].ItemIndex:=0;
 val_combo[0].Enabled:=t_mode(form1.SelectMode.ItemIndex)=m_gedm;

 LineOfsetRadioButton.Enabled := val_combo[0].Enabled;
 LineOfsetLabel.Enabled       := val_combo[0].Enabled;

 tgtiaShow;

 frameLineRange1bGetClick(self);

 old_raster_ofset := raster_ofset;

end;


procedure TFEditRasters.GlobalOfsetChange(Sender: TObject);
begin

 raster_ofset := GlobalOfset.Position;

 SaveAfterExit:=true;

 ZakresRastra;

 rad_buton[AktywnyRaster].Checked:=true;
 UstawScrollBar;

 StatusBar1.Panels[0].Text:='Global cycle offset: '+IntToStr(raster_ofset);

end;


procedure TFEditRasters.PageControl1Change(Sender: TObject);
begin
 if PageControl1.ActivePageIndex=1 then Aktualizuj;
end;


procedure TFEditRasters.Panel3Click(Sender: TObject);
begin
 form1.Zamknij(f_SelectValue);
end;



procedure TFEditRasters.ComboBoxEnter(Sender: TObject);
begin
 FEditRasters.seNOP.Visible:=false;
 FEditRasters.seValue.Visible:=false;

 GTIARegisterList.Visible:=false;

 AktywnyRaster := TComboBox(Sender).Tag;

 rad_buton[AktywnyRaster].Checked:=true;
end;


procedure TFEditRasters.ButtonClick(Sender: TObject);
// SWAP COMMANDS
var a: integer;
begin
 a:=TComboBox(Sender).Tag;

 move(raster_temp, temp, sizeof(raster_temp));

// temp:=raster_temp;

 raster_temp[a]:=temp[a+1];
 raster_temp[a+1]:=temp[a];

 Aktualizuj;

 FEditRasters.ZakresRastra;

 seValue.Visible:=false;
end;


procedure TFEditRasters.FormCreate(Sender: TObject);
var i, x, y: integer;

const
    skp = 60;

begin

(*----------------------------------------------------------------------------*)
(* GTIA - INIT - PGR                                                          *)
(*----------------------------------------------------------------------------*)

 x:=0;
 y:=0;

 for i:=0 to 31 do begin

  with TBMDSpinEdit.Create(self) do begin
   Width:=54;

   Left:=2+x*skp;
   Top:=20+y*50;

   if x>4  then Left:=Left-skp div 2-3;
   if x>10 then Left:=Left-skp div 2-3;
   if x>16 then Left:=Left-skp div 2-3;
   if x>18 then Left:=Left-skp div 2-3;

   MinValue:=0;
   MaxValue:=255;

   LabelPosition:=lpAbove;
   EditLabel.Font:=LineOfsetLabel.Font;
   EditLabel.Height:=LineOfsetLabel.Height;

   case i of
    28: EditLabel.Caption:='PMCNTL';
    29: EditLabel.Caption:='LDA #';
    30: EditLabel.Caption:='LDX #';
    31: EditLabel.Caption:='LDY #';
   else
    EditLabel.Caption:=AnsiUpperCase(form1.registry_label($d000+i));
   end;

   GaugeBeginColor:=clHighlight;
   GaugeEndColor:=clHighlight;

   AutoSize:=false;
   Font:=LineOfsetLabel.Font;
   Tag:=i;

   ShowHint:=true;

   Value:=i;
   Precision:=0;
   Parent:=Panel3;
   TrackBarEnabled:=false;
   Visible:=True;

   OnChange:=SaveTgtia;
   OnContextPopup:=seNopContextPopup;
  end;

  inc(x);

  case i of
    3: begin x:=0; y:=1 end;
    7: begin x:=5; y:=0 end;
   12: begin x:=5; y:=1 end;
   17: begin x:=11; y:=0 end;
   21: begin x:=11; y:=1 end;
   26: begin x:=17; y:=0 end;
   27: begin x:=17; y:=1 end;
   28: begin x:=19; y:=0 end;
   29: begin x:=20; y:=0 end;
   30: begin x:=21; y:=0 end;
  end;

 end;


 for i:=0 to ComponentCount-1 do
  if (Components[i] is TBMDSpinEdit) then
   if Components[i].Tag in [0..31] then
    gti_label[FEditRasters.Components[i].Tag]:=TBMDSpinEdit(FEditRasters.Components[i]);


(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)

 for i:=0 to high(tARaster)-1 do
  with TButton.Create(self) do begin
   Width:=32;
   Height:=19;
   Left:=101+i*skp;
   Top:=3;
   Caption:='< >';
   ShowHint:=true;
   Cursor:=crHandPoint;
   Hint:='Swap commands';
   Font.Style:=[fsBold];
   Tag:=i;
   Parent:=Panel2;
   Visible:=True;
   OnClick:=ButtonClick; // dodaj tê liniê
  end;


 for i:=0 to high(tARaster) do
  with TRadioButton.Create(self) do begin
   Width:=14;
   Height:=16;
   Left:=81+i*skp;
   Top:=5;
   Tag:=i+1;
   Parent:=Panel2;
   Visible:=True;
   OnClick:=RadioButtonClick; // dodaj tê liniê
  end;

 for i:=0 to ComponentCount-1 do
  if (Components[i] is TRadioButton) then
   if Components[i].Tag in [1..high(tARaster)+1] then
    rad_buton[FEditRasters.Components[i].Tag]:=TRadioButton(FEditRasters.Components[i]);


 for i:=0 to high(tARaster) do
  with TLabel.Create(self) do begin
   Width:=LineOfsetLabel.Width;
   Height:=LineOfsetLabel.Height;
   Left:=skp+i*skp;
   Top:=50;
   Tag:=i+1;
//   Color:=clYellow;
   Cursor:=crHandPoint;
   AutoSize:=false;
   Alignment:=taCenter;
//   Font.Name:='Arial';
//   Font.Size:=LineOfsetLabel.Font.Size;
   Font:=LineOfsetLabel.Font;
//   Font.Style:=[fsBold];
   ShowHint:=true;
   Transparent:=false;
   Parent:=Panel2;
   Visible:=True;
   OnClick:=ValLabelClick;
   OnDblClick:=LabelSelectColor;
  end;


 for i:=0 to ComponentCount-1 do
  if (Components[i] is TLabel) then
   if Components[i].Tag in [1..high(tARaster)+1] then
    val_label[Components[i].Tag]:=TLabel(Components[i]);


 for i:=0 to high(tARaster)+1 do
  with TComboBox.Create(self) do begin

   Width:=LineOfsetLabel.Width;
   Height:=21;

   Left:=0+i*skp;

   Top:=26;
   Tag:=i+1;
   Parent:=Panel2;
   Visible:=True;
   OnEnter:=ComboBoxEnter;
   OnChange:=ComboBoxChange;
   Style:=csDropDownList;
   ShowHint:=true;
   DropDownCount:=13;         // i tak musi byc SENDMESSAGE zeby zadzialalo

   if i>0 then begin
    Items.Add('lda#');
    Items.Add('ldx#');
    Items.Add('ldy#');
    Items.Add('lda0');
    Items.Add('ldx0');
    Items.Add('ldy0');
    Items.Add('lda');
    Items.Add('ldx');
    Items.Add('ldy');
    Items.Add('sta');
    Items.Add('stx');
    Items.Add('sty');
    Items.Add('nop');
    ItemIndex:=0;
   end;
  end;

 for i:=0 to ComponentCount-1 do
  if (Components[i] is TComboBox) then
   if Components[i].Tag>0 then
    val_combo[Components[i].Tag-1]:=TComboBox(Components[i]);

 GTIARegisterList.ItemIndex:=0;

 for i := 0 to high(tARaster)+1 do val_combo[i].Tag:=i;

// val_combo[0]:=LineOfset;
 rad_buton[0]:=LineOfsetRadioButton;
 val_label[0]:=LineOfsetLabel;

 LineOfsetRadioButton.Top:=rad_buton[1].Top;

 LineOfsetLabel.Top:=val_label[1].Top;
 LineOfsetLabel.Left:=val_combo[0].Left;
 LineOfsetLabel.Width:=val_combo[0].Width;

 GTIARegisterList.Parent:=Panel2;
 seValue.Parent:=Panel2;

 SendMessage(GTIARegisterList.Handle, $1701, 13, 0);

// caption:=inttostr(LOW(tablica_sprite));
end;


procedure TFEditRasters.GTIARegisterListDblClick(Sender: TObject);
begin
 BitBtn1Click(FEditRasters);
end;


procedure TFEditRasters.seNopChange(Sender: TObject);
var dir: integer;
begin

 dir:=seNOP.Position-_nop;

 if seNOP.Position=1 then
  if dir>0 then
   seNOP.Position:=2
  else
   seNOP.Position:=0;

 _nop:=seNOP.Position;

 BitBtn1Click(FEditRasters);

 ObliczCykle;

 ZakresRastra;
end;


procedure TFEditRasters.seNopContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled:=true;
end;

procedure TFEditRasters.seValueChange(Sender: TObject);
begin
 BitBtn1Click(FEditRasters);
end;


procedure TFEditRasters.FormMouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;

       

procedure TFEditRasters.Copy;
// COPY
begin
 move(raster_temp, raster_bufor, sizeof(raster_temp));
 move(raster_temp_ofset, raster_bufor_o, sizeof(raster_temp_ofset));
end;


procedure TFEditRasters.Paste;
// PASTE
begin
 move(raster_bufor, raster_temp, sizeof(raster_temp));
 move(raster_bufor_o, raster_temp_ofset, sizeof(raster_temp_ofset));

 Aktualizuj;
end;


procedure TFEditRasters.Delete;
// DELETE
var i: integer;
begin

 SaveAfterExit:=true;

 form1.ZapiszUndo;

 for i:=0 to high(tARaster) do begin
  raster_temp[i].cod:=0;
  raster_temp[i].arg:=0;
 end;

 raster_temp_ofset.cod:=0;
 raster_temp_ofset.arg:=0;

 RasterLinia; Aktualizuj;
end;


procedure TFEditRasters.SelectAll;
begin
 frameLineRange1.seLine.Position:=0;
 frameLineRange1.seRange.Position:=239;
end;


end.
