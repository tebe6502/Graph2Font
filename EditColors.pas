unit EditColors;

interface

uses
  Windows, Graphics, Controls, Forms, StdCtrls, Classes, ComCtrls, ExtCtrls,
  Menus, Buttons, LineRange, Main, BMDSpinEdit, AddSkip, SysUtils,
  UnitButtonMenu;

type
  TFEditColors = class(TForm)
    Panel1: TPanel;
    bChange: TButton;
    Bevel2: TBevel;
    PopupMenu1: TPopupMenu;
    fColor: TMenuItem;
    fSaturation: TMenuItem;
    fLock: TMenuItem;
    Shape1: TShape;
    Panel2: TPanel;
    frameLineRange1: TframeLineRange;
    frameAddSkip1: TframeAddSkip;
    bFill: TButtonMenu;
    procedure PanelClick(Sender: TObject);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bFillClick(Sender: TObject);
    procedure ecolors_lineClick(Sender: TObject; Button: TUDBtnType);
    procedure bChangeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SetColLine(const i: integer; const lupaON: Boolean = false);
    procedure Ustaw_Reszte_Kolorow_Paneli(const i:integer);
    procedure FormCreate(Sender: TObject);
    procedure combo_default;
    function  GetLineValue:integer;
    function  GetRangeValue:integer;
    procedure Ustaw_Panele(const a: Boolean);
    procedure init_edit_colors(var j: integer; const v: byte);
    procedure SetKolor;
    procedure ChangeColors(const yS,yE: byte; const v0,v1,v2,v3,v4: byte);
    procedure zapisz_palete(const i: integer);
    procedure LineChange;
    procedure FormMouseEnter(Sender: TObject);
    procedure frameLineRange1bGetClick(Sender: TObject);
    procedure frameLineRange1seLineChange(Sender: TObject);
    procedure KoloryInit(const g: t_gtia);
    procedure ChangeInit(const g: t_gtia);
    procedure SelectAll;
    procedure Copy;
    procedure Paste;
    procedure Delete;
    procedure bFillMenuButtonClick(Sender: TObject);

  private
    { Private declarations }

  cBMPColor: byte;

  col_bibtn: array [0..8] of TBitBtn;
  col_panel: array [0..15] of TPanel;
  t_cmb: array [1..17] of TComboBox;
  t_edt: array [1..17] of TEdit;

  public
    { Public declarations }
  end;

var
  FEditColors: TFEditColors;

implementation

uses Zoom, EditPMG, EditCharset, EditRasters, MoveCopyPaste, EditColorsMap, SelectColor;

{$R *.dfm}


procedure TFEditColors.SetColLine(const i: integer; const lupaON: Boolean = false);
var a, x: byte;
    cl: TColor;
begin

 if lupaON or ((gfxMode[i shr 3]=4) and (t_gtia(form1.SelectGTIA.ItemIndex)=gr10)) and (t_video(form1.SelectVideo.ItemIndex)=vgtia) then begin

  with form1.image6.Canvas do
   for a:=0 to 8 do begin

    if t_mode(form1.SelectMode.ItemIndex)=m_pgr then
     cl:=AtariPal[form1.tgtia2PenColor(a)]
    else
     cl:=AtariPal[TabKolor[i+a shl 8]];

    for x := 0 to 4 do form1.SetPixel(bmpPal, a*5+x, i, cl);
   end;

 end else
 with form1.image6.Canvas do
  for a:=0 to 4 do begin

   if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin

    case gfxMode[i shr 3] of
     1,4: cl:=AtariPal[byte( cmap[CzarnyPas div cmap_cellW, i div cmap_cellH].c[a and 1] )];
       2: if (a in [1..3]) then
           cl:=AtariPal[byte( cmap[CzarnyPas div cmap_cellW, i div cmap_cellH].c[a-1] )]
          else
           cl:=AtariPal[TabKolor[i]];
    end;

   end else
    if t_mode(form1.SelectMode.ItemIndex)=m_pgr then
     cl:=AtariPal[form1.tgtia2PenColor(a)]
    else
     cl:=AtariPal[TabKolor[i+a shl 8]];

   for x := 0 to 8 do form1.SetPixel(bmpPal, a*9+x, i, cl);
  end;

  form1.Image6.Picture.Graphic:=bmpPal;
end;


procedure TFEditColors.Ustaw_Panele(const a: Boolean);
begin
 panel1.Visible:=not(a);
 bChange.Visible:=not(a);

 fLock.Visible:=a;
end;


procedure WskazKolor(var i,j: integer);
// przesuw lini pokazujacej linie na obrazku
begin
  form1.Ustaw_Button2_7(i,j);
//  FEditColors.SetColLine(i);
end;


procedure TFEditColors.Ustaw_Reszte_Kolorow_Paneli(const i: integer);
var a, x: byte;
begin

 if (form1.ChangeColors.Checked) and (gfxMode[i shr 3]=4) and (t_gtia(form1.SelectGTIA.ItemIndex) in [gr9,gr11]) then begin

  for x:=0 to 15 do
   col_panel[x].Hint := form1.Hex(x,2);

 end else

  for x:=1 to 8 do begin
   a                 := TabKolor[x shl 8+i];
   pal[PalOfset+x]   := AtariPal[a];
   col_panel[x].Hint := form1.Hex(a,2);
  end;

// !!! panel powinien pokazywac wartosc dla rejestru a nie wartosc zmiksowana !!!

{ if gfxMode[i div 8]=1 then begin
  a                 := TabKolor[$300+i] and $f0+TabKolor[$200+i] and $0f;
  pal[PalOfset+2]   := AtariPal[a];
  col_panel[2].Hint := form1.Hex(a,2);
 end;
}
end;


function TFEditColors.GetLineValue: integer;
begin
 Result:=frameLineRange1.seLine.Position;
end;

function TFEditColors.GetRangeValue: integer;
begin
 Result:=frameLineRange1.seRange.Position;
end;


procedure TFEditColors.zapisz_palete(const i: integer);
var a, x: byte;
begin
PalOfset:=26;

with form1 do begin

 a:=TabKolor[i];

 pal[PalOfset]:=AtariPal[a];

 col_panel[0].Hint:=form1.Hex(a,2);

 for x:=0 to 15 do pal[x]:=AtariPal[form1.gr9col(a,x, t_gtia(form1.SelectGTIA.ItemIndex))];

 Ustaw_Reszte_Kolorow_Paneli(i);

 FEditPMG.Ustaw_Reszte_Kolorow_Duchow(i);

 x:=16;                            // paleta 4 kolorow
 pal[x]   := pal[PalOfset];
 pal[x+1] := pal[PalOfset+1];
 pal[x+2] := pal[PalOfset+2];
 pal[x+3] := pal[PalOfset+3];

 x:=20;                            // paleta 2 kolorow
 pal[x]   := pal[PalOfset+3];
 pal[x+1] := pal[PalOfset+2];

 x:=22;                            // paleta 4 kolorow z 5-tym
 pal[x]   := pal[PalOfset];
 pal[x+1] := pal[PalOfset+1];
 pal[x+2] := pal[PalOfset+2];
 pal[x+3] := pal[PalOfset+4];

 if (gfxMode[i shr 3]=4) and (t_gtia(form1.SelectGTIA.ItemIndex) in [gr9,gr11]) then
  for x:=0 to 15 do col_panel[x].Color:=pal[x]
 else
  for x:=0 to 15 do col_panel[x].Color:=pal[PalOfset+x];

end;

end;


procedure TFEditColors.SetKolor;
var i: integer;
begin
 i:=GetLineValue;

 zapisz_palete(i);

 SetColLine(i);
end;


procedure TFEditColors.LineChange;
var i, j: integer;
    c: byte;
    d: Boolean;
begin

 i:=FEditColors.GetLineValue;
 j:=FEditColors.GetRangeValue;

 form1.Sprawdz_Zaznaczenia(i,j);

 frameLineRange1.seLine.Position:=i;
 frameLineRange1.seRange.Position:=j;

 if t_video(form1.SelectVideo.ItemIndex)=vbxe then begin
  col_panel[1].Enabled:=false;
  col_panel[2].Enabled:=false;
  col_panel[3].Enabled:=false;

  col_bibtn[1].Enabled:=false;
  col_bibtn[2].Enabled:=false;
  col_bibtn[3].Enabled:=false;
 end else begin
  col_panel[1].Enabled:=true;
  col_panel[2].Enabled:=true;
  col_panel[3].Enabled:=true;

  col_bibtn[1].Enabled:=true;
  col_bibtn[2].Enabled:=true;
  col_bibtn[3].Enabled:=true;
 end;

 col_bibtn[0].Enabled:=true;
// col_bibtn[1].Enabled:=true;
// col_bibtn[2].Enabled:=true;
// col_bibtn[3].Enabled:=true;
 col_bibtn[4].Enabled:=true;

 case gfxMode[i shr 3] of
  1: begin
      col_bibtn[0].Enabled:=false;
      col_bibtn[1].Enabled:=false;
      col_bibtn[4].Enabled:=false;
     end;

  4: if t_gtia(form1.SelectGTIA.ItemIndex)<>gr10 then begin
      col_bibtn[1].Enabled:=false;
      col_bibtn[2].Enabled:=false;
      col_bibtn[3].Enabled:=false;
      col_bibtn[4].Enabled:=false;
     end;
 end;


 if form1.EditColors.Checked then
 if gfxMode[i shr 3]=4 then
  KoloryInit(t_gtia(form1.SelectGTIA.ItemIndex))
 else
  KoloryInit(no_gtia);


 for j := 0 to 4 do begin
  col_bibtn[j].Glyph:=nil;
  if locKolor[j shl 8+i] then form1.ImageList2.GetBitmap(17, col_bibtn[j].Glyph);
 end;


 d := (dostepne[i]=0);

 FEditColors.bFill.Enabled:=d;

 if not(form1.ChangeColors.Checked) then FEditColors.Ustaw_Panele(d);

 c:=TabKolor[i+$000]; pal[PalOfset+0]:=AtariPal[c];
 col_panel[0].Hint:=form1.Hex(c,2);

 FEditColors.Ustaw_Reszte_Kolorow_Paneli(i);

 j:=FEditColors.GetRangeValue;

 WskazKolor(i,j);

 FEditColors.setKolor;

 frameLineRange1.seLineChange(self);

end;


procedure UstawWskaznik;
begin

 FEditColors.Shape1.Top:=FEditColors.col_panel[AktywnyKolor].Top-2;

end;


procedure shKolor(const p: TColor);
begin
 FSelectColor.initKolor(p);

 UstawWskaznik;
end;


procedure TFEditColors.PanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
begin

 if Button=mbRight then begin
  FSelectColor.Visible:=false;

  AktywnyKolor := TForm(Sender).Tag;
  UstawWskaznik;
 end;

end;


procedure TFEditColors.PanelClick(Sender: TObject);
var i: byte;
    zm: string;
    t,l: integer;
begin

 i:=TForm(Sender).Tag;

 if not(form1.ChangeColors.Checked) then begin

  if (Pixel=4) and (t_gtia(form1.SelectGTIA.ItemIndex)=gr10) then begin
   case i of
    0..3: zm:='COLPM'+IntToStr(i);
    4..7: zm:='COLOR'+IntToStr(i-4);
       8: zm:='COLBAK';
   end;
  end else
   if i=0 then zm:='COLBAK' else zm:='COLOR'+IntToStr(i-1);

  if not(FSelectColor.Visible) then begin

   form1.SetFormPos('FSelectColor', t, l);
   FSelectColor.Top:=t;
   FSelectColor.Left:=l;

  end;

  FSelectColor.Caption:='Select '+zm;
  FSelectColor.Visible:=true;
 end;

 Ofset:=i shl 8;
 AktywnyKolor:=i;

 form1.Zamknij(f_Zoom);

 shKolor(col_panel[i].Color);
end;


procedure TFEditColors.bFillClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* FILL COLORS                                                                *)
(*----------------------------------------------------------------------------*)
var k, c, old_c, l, r: byte;
    i, j, x, skip: integer;
    add, kol: real;
begin

Self.ActiveControl:=nil;

i:=GetLineValue;
j:=GetRangeValue;

if SpecialStr[___doublescan].val then begin
 i:=(i div 2)*2;
 j:=(j div 2)*2+1;

 frameLineRange1.seLine.Position:=i;
 frameLineRange1.seRange.Position:=j;
end;

SaveAfterExit:=true; form1.ZapiszUndo;

add:=frameAddSkip1.seAdd.Value;

skip:=frameAddSkip1.seSkip.Position;

k:=StrToInt(col_panel[AktywnyKolor].Hint);

form1.Zamknij(f_EditCharset);

kol:=k;

x:=i;
while x<=j+i do begin

 k:=byte(round(kol));

 if gfxMode[x shr 3]<>4 then k:=k and $fe;

 old_c:=TabKolor[AktywnyKolor shl 8+x];

 l:=k and $f0; r:=k and $0f;

 if not(fColor.Checked) then l:=old_c and $f0;
 if not(fSaturation.Checked) then r:=old_c and $0f;

 c := l or r;

 locKolor[AktywnyKolor shl 8+x]:=fLock.Checked;

 TabKolor[AktywnyKolor shl 8+x]:=c;
 SetColLine(x);

{ if add<>0 then
  if k in [0..15] then begin
   inc(k,16);
   kol:=kol+16;
  end; }

 kol:=kol+add;

 inc(x, skip);
end;

LineChange;

setKolor;

form1.ZamienGrafike;

FEditPMG.check_refresh;

form1.OdswiezObraz;         // !!! koniecznie !!! dla testRaster
end;


procedure TFEditColors.bFillMenuButtonClick(Sender: TObject);
begin
  Self.ActiveControl:=nil;
  
  bFill.MenuButtonClick(Sender);
end;


procedure TFEditColors.ecolors_lineClick(Sender: TObject; Button: TUDBtnType);
begin
 form1.Zamknij(f_SelectColor);
end;


procedure TFEditColors.combo_default;
// ustawienie wartosci poczatkowych dla ComboBox-ow w Change Colors
var i: byte;
begin
 for i:=1 to 16 do t_cmb[i].ItemIndex:=i-1;
end;


procedure TFEditColors.ChangeColors(const yS,yE: byte; const v0,v1,v2,v3,v4: byte);
// CHANGE COLORS
var chg: array [0..15] of byte;
    p: array [0..7] of byte;
    ofs, v, y, inv, i, x: byte;
begin

move(tabKolor, bufor, sizeof(tabKolor));

ofs:=CzarnyPas shr 3;

case Pixel of
  
 4: begin

 for i := 1 to 16 do chg[i-1]:=t_cmb[i].ItemIndex;

 if t_gtia(form1.SelectGTIA.ItemIndex)=gr10 then
  for i:=0 to 8 do move(bufor[i shl 8+yS],tabKolor[chg[i] shl 8+yS],yE+1);

 for y:=yS to yS+yE do
  for x:=0 to Bajt-1 do begin
   v:=tab[ofs+x+tmul48[y]];

   p[0]:=(v and $f0) shr 4;
   p[1]:=v and $0f;

   p[0]:=chg[p[0]];
   p[1]:=chg[p[1]];

   tab[ofs+x+tmul48[y]]:=(p[0] shl 4) or p[1];
  end;

 end;

 1: begin

 chg[0]:=v2;  // kolor 709 na v2
 chg[1]:=v3;  // kolor 710 na v3

 for i:=0 to 1 do move(bufor[$200+i shl 8+yS],tabKolor[$200+chg[i] shl 8+yS],yE+1);

for y:=yS to yS+yE do
 for x:=0 to Bajt-1 do begin
  v:=tab[ofs+x+tmul48[y]];

//  inv:=0; if invers[ofs+x+tmul48[y shr 3]]>127 then inv:=1;

  p[0]:=(v and $80) shr 7;
  p[1]:=(v and $40) shr 6;
  p[2]:=(v and $20) shr 5;
  p[3]:=(v and $10) shr 4;
  p[4]:=(v and $08) shr 3;
  p[5]:=(v and $04) shr 2;
  p[6]:=(v and $02) shr 1;
  p[7]:=(v and $01) shr 0;

//  for i:=0 to 3 do
//   if (inv>0) and (p[i]=3) then p[i]:=4;

  p[0]:=chg[p[0]];
  p[1]:=chg[p[1]];
  p[2]:=chg[p[2]];
  p[3]:=chg[p[3]];
  p[4]:=chg[p[4]];
  p[5]:=chg[p[5]];
  p[6]:=chg[p[6]];
  p[7]:=chg[p[7]];

//  for i:=0 to 3 do if p[i]>3 then begin inv:=1; p[i]:=3; end;
//  invers[ofs+x+tmul48[y shr 3]]:=$80*inv;

  tab[ofs+x+tmul48[y]]:=(p[0] shl 7) or (p[1] shl 6) or (p[2] shl 5) or (p[3] shl 4) or (p[4] shl 3) or (p[5] shl 2) or (p[6] shl 1) or p[7];
 end;
 end;

 2: begin

 chg[0]:=v0;  // kolor 712 na v0
 chg[1]:=v1;  // kolor 708 na v1
 chg[2]:=v2;  // kolor 709 na v2
 chg[3]:=v3;  // kolor 710 na v3
 chg[4]:=v4;  // kolor 711 na v4

for i:=0 to 4 do move(bufor[i shl 8+yS],tabKolor[chg[i] shl 8+yS],yE+1);

for y:=yS to yS+yE do
 for x:=0 to Bajt-1 do begin
  v:=tab[ofs+x+tmul48[y]];

  inv:=0; if invers[ofs+x+tmul48[y shr 3]]>127 then inv:=1;

  p[0]:=(v and $c0) shr 6;
  p[1]:=(v and $30) shr 4;
  p[2]:=(v and $0c) shr 2;
  p[3]:=v and 3;

  for i:=0 to 3 do
   if (inv>0) and (p[i]=3) then p[i]:=4;

  p[0]:=chg[p[0]];
  p[1]:=chg[p[1]];
  p[2]:=chg[p[2]];
  p[3]:=chg[p[3]];

  for i:=0 to 3 do if p[i]>3 then begin inv:=1; p[i]:=3; end;
  invers[ofs+x+tmul48[y shr 3]]:=$80*inv;

  tab[ofs+x+tmul48[y]]:=(p[0] shl 6) or (p[1] shl 4) or (p[2] shl 2) or p[3];
 end;

end;


end;

end;


procedure TFEditColors.bChangeClick(Sender: TObject);
// CHANGE COLORS, BIT
var yS, yE: byte;
begin
 yS:=GetLineValue;
 yE:=GetRangeValue;

 SaveAfterExit:=true;
 form1.ZapiszUndo;

 ChangeColors(yS,yE, t_cmb[1].ItemIndex, t_cmb[2].ItemIndex, t_cmb[3].ItemIndex, t_cmb[4].ItemIndex, t_cmb[5].ItemIndex);

 combo_default;

 form1.set_pf_colors;

 form1.ZamienGrafike;

 SetKolor;

 FEditPMG.check_refresh; 
end;


procedure TFEditColors.init_edit_colors(var j: integer; const v: byte);
begin

 AktywnyKolor:=v;

 UstawWskaznik;

 frameLineRange1.seLine.Position:=0;
 frameLineRange1.seLine.Position:=j;
end;


procedure TFEditColors.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FEditColors', top, left);

 form1.EditColors.Checked:=false;
 form1.ChangeColors.Checked:=false;

 form1.tbEditColors.Down:=false;
                    
 if not(FEditRasters.visible) then
  form1.Usun_Zaznaczenia(false)
 else begin
  form1.Usun_Zaznaczenia(true);
  FEditRasters.RasterLinia;
 end;

 form1.set_pf_colors;
 form1.Refresh;

 Ustaw_Panele(true); //panel3.Visible:=true;
 Height:=303;

 form1.Zamknij(f_SelectColor);
end;


procedure TFEditColors.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#27 then form1.Zamknij(f_EditColors);
end;


procedure TFEditColors.FormShow(Sender: TObject);
begin
 form1.Zamknij(f_Move);

 UstawWskaznik;

 LineChange;
end;


procedure TFEditColors.frameLineRange1bGetClick(Sender: TObject);
// GET COLORS
var y, i, start, koniec: integer;
    b: Boolean;
    c, g: byte;
begin
 y:=FEditColors.GetLineValue;

 c:=TabKolor[AktywnyKolor shl 8+y];
 b:=locKolor[AktywnyKolor shl 8+y];
 g:=gfxMode[y shr 3];

 start:=y; koniec:=y;

 for i:=y downto 0 do
  if (c=TabKolor[AktywnyKolor shl 8+i]) and (b=locKolor[AktywnyKolor shl 8+i]) and
     (g=gfxMode[i shr 3]) then start:=i else Break;

 for i:=y to Wysokosc-1 do
  if (c=TabKolor[AktywnyKolor shl 8+i]) and (b=locKolor[AktywnyKolor shl 8+i]) and
     (g=gfxMode[i shr 3]) then koniec:=i else Break;

 frameLineRange1.seLine.Position:=start;
 frameLineRange1.seRange.Position:=koniec-start;

 FEditColors.LineChange;

 Panel2.SetFocus;
end;


procedure TFEditColors.FormCreate(Sender: TObject);
var i: integer;
begin
 doublebuffered:=true;

 for i:=0 to 15 do begin

  with TEdit.Create(self) do begin    // ComboBox-y z rejestrami kolorow
   Width:=54;
//   Height:=20;
   Left:=2;
   Top:=2+i*32;
   Tag:=i+1;
   Enabled:=false;
   Parent:=Panel1;
//   Style:=csDropDownList;
//   Text:=('COLOR'+IntToStr(i));
//   Itemindex:=0;
//   Visible:=True;
  end;

  with TComboBox.Create(self) do begin    // wybor rejestru koloru z ComboBox-ow
   Width:=72;
   Height:=21;
   Left:=69;
   Top:=2+i*32;
   Tag:=i+1;
   Parent:=Panel1;
   Style:=csDropDownList;
//   for x:=0 to 15 do Items.Add('COLOR'+IntToStr(x));
//   Visible:=True;
  end;


  with TLabel.Create(self) do begin       // Labels '>'
   Width:=11;
   Height:=16;
   Left:=58;
   Top:=4+i*32;
   Caption:='>';
//   Font.Name:='Arial';
   Font.Size:=9;
   Font.Style:=[fsBold];
   Parent:=Panel1;
   Transparent:=false;
  end;


  with TPanel.Create(self) do begin       // Panele symbolizujace kolor
   Width:=25;
   Height:=26;
   Left:=4;
   Top:=8+i*32;
   Tag:=i+1;
   ShowHint:=true;
   Cursor:=crHandPoint;
   BevelInner:=bvNone;
   BevelOuter:=bvNone;
   BevelKind:=bkFlat;
   BorderStyle:=bsNone;
   Parent:=self;
   OnClick:=PanelClick;
   OnMouseDown:=PanelMouseDown;
   ParentBackground:=false;
//   Visible:=True;
  end;

 end;


 for i:=0 to 8 do
  with TBitBtn.Create(self) do begin       // BitButony symbolizujace kolor
   Width:=141;
   Height:=26;
   Left:=32;
   Top:=8+i*32;
   Tag:=i+30;
//   ShowHint:=false;

   Caption:='';

   case i of
    0..3: Caption:='COLPM'+IntToStr(i);
    4..7: Caption:='COLOR'+IntToStr(i-4);
       8: Caption:='COLBAK';
   end;

   Caption:=Caption+' - '+form1.Hex($d012+i,2)+' - '+IntToStr(704+i);

   Layout:=blGlyphRight;
   Cursor:=crHandPoint;
   Parent:=self;
   OnClick:=PanelClick;
   OnMouseDown:=PanelMouseDown;
//   Visible:=True;
  end;   


for i:=0 to ComponentCount-1 do
 if (Components[i] is TEdit) then begin
  if Components[i].Tag in [1..17] then t_edt[Components[i].Tag] := TEdit(Components[i])
 end else
  if (Components[i] is TComboBox) then begin
   if Components[i].Tag in [1..17] then t_cmb[Components[i].Tag] := TComboBox(Components[i]);
  end else if (Components[i] is TBitBtn) then begin
   if Components[i].Tag in [30..39] then begin
    col_bibtn[Components[i].Tag-30] := TBitBtn(Components[i]);
    col_bibtn[Components[i].Tag-30].Tag := Components[i].Tag-30;
   end;
  end
   else if (Components[i] is TPanel) then
    if Components[i].Tag in [1..16] then begin
     col_panel[Components[i].Tag-1] := TPanel(Components[i]);
     col_panel[Components[i].Tag-1].tag := Components[i].Tag-1;
    end;


 Panel1.BringToFront;
 Panel2.BringToFront;

end;


procedure TFEditColors.frameLineRange1seLineChange(Sender: TObject);
begin
 LineChange;
end;


procedure TFEditColors.FormMouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;


procedure TFEditColors.ChangeInit(const g: t_gtia);
var cap: string;
    t, l: byte;
begin

   t_cmb[1].Enabled:=true;
   t_cmb[2].Enabled:=true;
   t_cmb[5].Enabled:=true;

   Caption:='Change Colors';
   Ustaw_Panele(false);

   cap:='';

   if (Pixel=4) then begin

    case g of

     gr9,gr11:
           begin
            Height:=620;
            Panel2.Top:=520;

            for t := 1 to 16 do begin
             t_edt[t].Text:='COLOR'+IntToStr(t-1);

            t_cmb[t].Clear;
            for l:= 0 to 15 do
             t_cmb[t].Items.Add('COLOR'+IntToStr(l));

             t_cmb[t].ItemIndex:=t-1;
            end;

           end;

     gr10: begin
            Height:=396;
            Panel2.Top:=296;

            for t := 1 to 9 do begin
             case t of
              1..4: t_edt[t].Text:='COLPM'+IntToStr(t-1);
              5..8: t_edt[t].Text:='COLOR'+IntToStr(t-5);
                 9: t_edt[t].Text:='COLBAK';
             end;

            t_cmb[t].Clear;
            for l:= 0 to 8 do
             case l of
              0..3: t_cmb[t].Items.Add('COLPM'+IntToStr(l));
              4..7: t_cmb[t].Items.Add('COLOR'+IntToStr(l-4));
                 8: t_cmb[t].Items.Add('COLBAK');
             end;

             t_cmb[t].ItemIndex:=t-1;
            end;

           end;
    end;

   end else begin

    Height:=268;
    Panel2.Top:=168;

    if Pixel=1 then begin

    for t := 1 to 5 do begin
     if t=1 then
      t_edt[t].Text:='COLBAK'
     else
      t_edt[t].Text:='COLOR'+IntToStr(t-2);

     t_cmb[t].Clear;
     for l:= 1 to 2 do
       t_cmb[t].Items.Add('COLOR'+IntToStr(l));

     t_cmb[t].ItemIndex:=(t xor 1) and 1;
    end;

    t_cmb[1].Enabled:=false;
    t_cmb[2].Enabled:=false;
    t_cmb[5].Enabled:=false;

    end else begin

    for t := 1 to 5 do begin
     if t=1 then
      t_edt[t].Text:='COLBAK'
     else
      t_edt[t].Text:='COLOR'+IntToStr(t-2);

     t_cmb[t].Clear;
     for l:= 0 to 4 do
      if l=0 then
       t_cmb[t].Items.Add('COLBAK')
      else
       t_cmb[t].Items.Add('COLOR'+IntToStr(l-1));

     t_cmb[t].ItemIndex:=t-1;
    end;

    end;

   end;

   LineChange;

   combo_default;

   FEditColors.ClientHeight := FEditColors.Bevel2.Top + FEditColors.Bevel2.Height + FEditColors.Panel2.Top;

end;


procedure TFEditColors.KoloryInit(const g: t_gtia);
var t: byte;
    cap: string;
begin

 with FEditColors do begin
  Caption:='Edit Colors';
  Ustaw_Panele(true);

  cap:='';

  if (Pixel=4) and (g=gr10) then begin
   Height:=432;
   Panel2.Top:=296;

   for t := 0 to 4 do begin
    case t of
     0..3: Cap:='COLPM'+IntToStr(t);
     4..7: Cap:='COLOR'+IntToStr(t-4);
        8: Cap:='COLBAK';
    end;

    Cap:=Cap+' - '+form1.Hex($d012+t,2)+' - '+IntToStr(704+t);

    FEditColors.col_bibtn[t].Caption:=cap;
   end;

  end else begin
   Height:=304;
   Panel2.Top:=168;

   for t := 0 to 4 do begin
    case t of
        0: cap:='COLBAK - $D01A - 712';
     1..4: cap:='COLOR'+IntToStr(t-1)+' - '+form1.Hex($d015+t,2)+' - '+IntToStr(707+t);
    end;

    col_bibtn[t].Caption:=cap;
   end;

  end;

  FEditColors.ClientHeight := FEditColors.Bevel2.Top + FEditColors.Bevel2.Height + FEditColors.Panel2.Top;

 end;

end;



procedure TFEditColors.Copy;
begin
 cBMPColor:=StrToInt(col_panel[AktywnyKolor].Hint);
end;


procedure PasteColor(const a: byte);
var old_c: byte;
    j: integer;
begin

 SaveAfterExit:=true;

 form1.ZapiszUndo;

 Ofset:=AktywnyKolor shl 8;

 j:=FEditColors.GetLineValue;

 old_c := TabKolor[Ofset+j];

 TabKolor[Ofset+j] := a;
 FEditColors.zapisz_palete(j);

 TabKolor[Ofset+j] := old_c;

end;


procedure TFEditColors.Delete;
begin

 PasteColor(0);

end;


procedure TFEditColors.Paste;
begin

 PasteColor(cBMPColor);

end;


procedure TFEditColors.SelectAll;
begin
 frameLineRange1.seLine.Position:=0;
 frameLineRange1.seRange.Position:=239;
end;

end.

