unit EditPalette;

interface

uses
  Windows, Graphics, Controls, Forms, ExtCtrls, ComCtrls, StdCtrls, Classes, LineRange;

type
  TFEditPalette = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Bevel1: TBevel;
    Apply: TButton;
    frameLineRange1: TframeLineRange;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplyClick(Sender: TObject);
    procedure showPalPic;
    procedure FormMouseEnter(Sender: TObject);
    procedure getPal;
    procedure setPal;
    procedure frameLineRange1bGetClick(Sender: TObject);
    procedure frameLineRange1seLineChange(Sender: TObject);
    procedure LineChange;
    procedure SelectAll;
    procedure HLineHeader(var bmp: TBitmap; const s: byte);
    procedure VLineHeader(var bmp: TBitmap);
    procedure DrawPalette(var bmp: TBitmap; const s: byte);
    
  private
    { Private declarations }
  ppos, opos: TPoint;

  public
    { Public declarations }
  end;

var
  FEditPalette: TFEditPalette;

  lenUPal, upal_idx: integer;

implementation

uses Main, EditRasters, SelectColor, EditColorsMap;

{$R *.dfm}


procedure TFEditPalette.HLineHeader(var bmp: TBitmap; const s: byte);
(*----------------------------------------------------------------------------*)
(* poziomy wiersz z naglowkiem palety kolorow                                 *)
(*----------------------------------------------------------------------------*)
var i,b: byte;
begin

 form1.ClrRect(bmp);

 for i:=0 to bmp.Width div 16-1 do begin
  b:=i shl s+16+7*ord(i shl s>9);

  form1.print(bmp, b, 0, i shl 4, 0);
 end;

end;


procedure TFEditPalette.VLineHeader(var bmp: TBitmap);
(*----------------------------------------------------------------------------*)
(* poziomy wiersz z naglowkiem palety kolorow                                 *)
(*----------------------------------------------------------------------------*)
var i,b: byte;
begin

 form1.ClrRect(bmp);

 for i:=0 to bmp.Height div 8-1 do begin
  b:=i+16+7*ord(i>9);

  form1.print(bmp, b, i shl 3, 0, 0);
 end;

end;


procedure TFEditPalette.DrawPalette(var bmp: TBitmap; const s:byte);
(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)
var tmp1, tmp2, cnt: byte;
begin

 form1.ClrRect(bmp);

 cnt:=0;

 for tmp2:=0 to bmp.Height div 15-1 do
  for tmp1:=0 to bmp.Width div 15-1 do
   with bmp.Canvas do begin
    Pen.Color:=0;

    if s<2 then
     Brush.Color:=AtariPal[tmp1 shl s+tmp2 shl 4]
    else
     Brush.Color:=AtariPal[upal[cnt].ata];

    Brush.Style:=bsSolid;
    Rectangle(1+tmp1 shl 4+1,1+tmp2*15+1,1+tmp1 shl 4+16-2,1+tmp2*15+15-2);

    inc(cnt);
   end;

end;


procedure TFEditPalette.SelectAll;
begin
 frameLineRange1.seLine.Position:=0;
 frameLineRange1.seRange.Position:=239;
end;


procedure GetLineRangeValue(out i,j:integer);
begin
 i:=FEditPalette.frameLineRange1.seLine.Position;
 j:=FEditPalette.frameLineRange1.seRange.Position;
end;


procedure LINIA;
var i, j: integer;
begin

 GetLineRangeValue(i,j);

 form1.Sprawdz_Zaznaczenia(i,j);

 FEditPalette.frameLineRange1.seLine.Position:=i;
 FEditPalette.frameLineRange1.seRange.Position:=j;

 form1.Ustaw_Button2_7(i,j);

end;


procedure SetMarker;
begin

 with FEditPalette do
  with image1.Canvas do begin
   Brush.Color:=clBtnFace;               // kasuj poprzednie zaznaczenie
   FrameRect(Rect(opos.x shl 4, opos.Y*15, opos.x shl 4+17, opos.y*15+16));

   Brush.Color:=0;                       // tworz nowe zaznaczenie
   FrameRect(Rect(ppos.x shl 4, ppos.Y*15, ppos.x shl 4+17, ppos.y*15+16));

   opos:=ppos;
  end;

end;


procedure TFEditPalette.showPalPic;
var bmp: TBitmap;
begin

 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(image1.Width,image1.Height);

 DrawPalette(bmp, $ff);

 image1.Picture.Graphic:=bmp;

 bmp.Free;

 ppos:=opos;
 SetMarker;
 
end;


procedure TFEditPalette.getPal;
var use: array [0..255] of byte;
    tmp1, tmp2, max, i, j, ofs: integer;
    ra, rx, ry, v: byte;
begin

 GetLineRangeValue(i,j);

 fillchar(use, sizeof(use), $ff);


 if form1.SelectVideo.ItemIndex=1 then begin        // VBXE

  ofs:=CzarnyPas div cmap_cellW;

  for tmp1:=i to i+j do use[TabKolor[tmp1]]:=0;

  for tmp1:=i to i+j do
   for tmp2 := 0 to (Szerokosc div cmap_cellW)-1 do begin
    use[cmap[ofs+tmp2, tmp1].c[0]]:=0;
    use[cmap[ofs+tmp2, tmp1].c[1]]:=0;
    use[cmap[ofs+tmp2, tmp1].c[2]]:=0;
   end;

 end else begin

 // sprawdzamy jaki kolor wystepuje w zadanym przedziale
  for tmp2:=0 to 8 do
   for tmp1:=i to i+j do use[TabKolor[tmp2 shl 8+tmp1]]:=0;

  if t_mode(form1.SelectMode.ItemIndex)=m_pgr then begin

   if tgtia.colpm0>0 then use[tgtia.colpm0]:=0;
   if tgtia.colpm1>0 then use[tgtia.colpm1]:=0;
   if tgtia.colpm2>0 then use[tgtia.colpm2]:=0;
   if tgtia.colpm3>0 then use[tgtia.colpm3]:=0;

   if tgtia.color0>0 then use[tgtia.color0]:=0;
   if tgtia.color1>0 then use[tgtia.color1]:=0;
   if tgtia.color2>0 then use[tgtia.color2]:=0;
   if tgtia.color3>0 then use[tgtia.color3]:=0;

   if tgtia.colbak>0 then use[tgtia.colbak]:=0;

   ra:=tgtia.regA;
   rx:=tgtia.regX;
   ry:=tgtia.regY;

  end else begin
   ra:=0;
   rx:=0;
   ry:=0;
  end;

 for tmp1:=0 to Wysokosc-1 do begin

   v:=raster_line_ofset[tmp1].arg;

   case raster_line_ofset[tmp1].cod of
    1: ra:=v;
    2: rx:=v;
    3: ry:=v;
   end;

  for tmp2:=0 to RLimitInst-1 do begin

   v:=raster[tmp1, tmp2].arg;

   case raster[tmp1, tmp2].cod of
    1: ra:=v;
    2: rx:=v;
    3: ry:=v;
   end;

   if tmp1 in [i..i+j] then

   if raster[tmp1, tmp2].cod in [$81,$82,$83] then
    if raster[tmp1, tmp2].arg in [13..21] then      // $d012..$d01a
     case raster[tmp1, tmp2].cod of
      $81: use[ra]:=0;
      $82: use[rx]:=0;
      $83: use[ry]:=0;
     end;

  end;

 end;

 end;

 // czyscimy UPAL
 for tmp1:=0 to 255 do begin
  upal[tmp1].old:=0;
  upal[tmp1].ata:=0;
 end;


 // wypelniamy tablice PAL aktywnymi kolorami, w MAX liczba kolorów
 max:=0;
 for tmp1:=0 to 255 do
  if use[tmp1]=0 then begin
   upal[max].ata:=tmp1;
   upal[max].old:=tmp1;
   inc(max);
  end;

 lenUPal:=max;

 FEditPalette.showPalpic;
end;


procedure TFEditPalette.setPal;
var k, i, j, c, y, ad: integer;
begin

 GetLineRangeValue(i,j);

 for k:=0 to lenUPal-1 do
 if form1.SelectVideo.ItemIndex=1 then begin     // VBXE

  ad:=CzarnyPas div cmap_cellW;

  for y:=i to i+j do
   if TabKolor[y]=upal[k].old then TabKolor[y]:=upal[k].ata;

  for y:=i to i+j do
   for c := 0 to (Szerokosc div cmap_cellW)-1 do begin

    if cmap[ad+c,y].c[0]=upal[k].old then cmap[ad+c,y].c[0]:=upal[k].ata;
    if cmap[ad+c,y].c[1]=upal[k].old then cmap[ad+c,y].c[1]:=upal[k].ata;
    if cmap[ad+c,y].c[2]=upal[k].old then cmap[ad+c,y].c[2]:=upal[k].ata;

   end;

 end else begin

  if (t_mode(form1.SelectMode.ItemIndex)=m_pgr) and (i=0) then begin

   if tgtia.colpm0=upal[k].old then tgtia.colpm0:=upal[k].ata;
   if tgtia.colpm1=upal[k].old then tgtia.colpm1:=upal[k].ata;
   if tgtia.colpm2=upal[k].old then tgtia.colpm2:=upal[k].ata;
   if tgtia.colpm3=upal[k].old then tgtia.colpm3:=upal[k].ata;

   if tgtia.color0=upal[k].old then tgtia.color0:=upal[k].ata;
   if tgtia.color1=upal[k].old then tgtia.color1:=upal[k].ata;
   if tgtia.color2=upal[k].old then tgtia.color2:=upal[k].ata;
   if tgtia.color3=upal[k].old then tgtia.color3:=upal[k].ata;

   if tgtia.colbak=upal[k].old then tgtia.colbak:=upal[k].ata;
  end;


  for c:=0 to 8 do
   for y:=i to i+j do
    if TabKolor[c shl 8+y]=upal[k].old then TabKolor[c shl 8+y]:=upal[k].ata;

  for y:=i to i+j do begin

   if raster_line_ofset[y].cod in [1..3, $41..$43, $61..$63] then
    if raster_line_ofset[y].arg=upal[k].old then raster_line_ofset[y].arg:=upal[k].ata;

   for c:=0 to RLimitInst-1 do begin

    if raster[y, c].cod in [1..3, $41..$43, $61..$63] then
     if raster[y, c].arg=upal[k].old then raster[y, c].arg:=upal[k].ata;

   end;

  end;

 end;

 form1.set_pf_colors;
 form1.UstawKolory;
 form1.OdswiezObraz;

end;


procedure TFEditPalette.FormShow(Sender: TObject);
begin

 form1.Shape1.Visible:=false;
 form1.Shape2.Visible:=false;

 FSelectColor.Caption:='Select Color';

 ppos:=Point(0,0);
 upal_idx:=0;

// LINIA;
 LineChange;

 getPal;

 SetMarker;

end;


procedure TFEditPalette.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 ppos:=Point(x shr 4, y div 15);

 if ppos.x>(image1.width shr 4)-1 then ppos.x:=image1.Width shr 4-1;
 if ppos.y>15 then ppos.y:=15;

 klikEdit:=false;
end;


procedure TFEditPalette.Image1Click(Sender: TObject);
var a, x, y: integer;
    ss: TShiftState;
begin

 SetMarker;

 upal_idx:=ppos.X + ppos.Y * 11;

 a:=upal[upal_idx].ata;

 getCol:=true;

 if form1.SelectVideo.ItemIndex=1 then begin
  x:=(a and $0f) shl 4;
  y:=(a shr 4) * 15;

  FSelectColor.Visible:=true;
  FSelectColor.Image1MouseMove(FEditPalette,ss, x,y);

 end else begin
 // wymuszamy klikniecie kursora myszki na obszarze palety
  x:=((a and $0f) shr 1) shl 4;
  y:=(a shr 4) * 15;

  FSelectColor.Visible:=true;
  FSelectColor.Image1MouseMove(FEditPalette, ss, x,y);
 end;
 
end;


procedure TFEditPalette.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then form1.Zamknij(f_EditPalette);
end;


procedure TFEditPalette.LineChange;
var i,j: integer;
    a: byte;
begin

 a:=upal[upal_idx].ata;

 SetMarker;

 LINIA;

 FEditPalette.getPal;

 for j := 0 to 15 do
  for i := 0 to 10 do
   if upal[i+j*11].ata = a then begin
    ppos:=Point(i,j);
    upal_idx:=i+j*11;
    SetMarker;
    Break;
   end;

 frameLineRange1.seLineChange(self);
end;


procedure TFEditPalette.frameLineRange1seLineChange(Sender: TObject);
begin
 LineChange;
end;


procedure TFEditPalette.ApplyClick(Sender: TObject);
// APPLY
var i, j: integer;
    old: byte;
begin
 form1.ZapiszUndo; SaveAfterExit:=true;

 old:=upal[upal_idx].ata;

 setPal;

 getPal;

 for j := 15 downto 0 do
  for i := 10 downto 0 do
   if upal[i+j*11].ata = old then begin
    ppos:=Point(i,j);
    upal_idx:=i+j*11;
    SetMarker;
//    Break;
   end;

end;


procedure TFEditPalette.frameLineRange1bGetClick(Sender: TObject);
// GET
var min, max, i, j: integer;
    a: byte;
begin

 a:=upal[upal_idx].ata;

 min:=$ff;

 for j:=0 to 8 do
  for i:=239 downto 0 do
   if (TabKolor[j shl 8+i]=a) and (i<min) then min:=i;

 max:=0;

 for j:=0 to 8 do
  for i:=0 to 239 do
   if (TabKolor[j shl 8+i]=a) and (i>max) then max:=i;

 frameLineRange1.seLine.Position:=min;
 frameLineRange1.seRange.Position:=max-min;

 for j := 0 to 15 do
  for i := 0 to 10 do
   if upal[i+j*11].ata = a then begin
    ppos:=Point(i,j);
    upal_idx:=i+j*11;
    SetMarker;
    Break;
   end;

end;


procedure CloseForm16;
begin
 form1.Zamknij(f_SelectColor);

 form1.EditPalette.Checked:=false;

 if not(FEditRasters.visible) then
  form1.Usun_Zaznaczenia(false)
 else begin
  form1.Usun_Zaznaczenia(true);
  FEditRasters.RasterLinia;
 end;

 form1.set_pf_colors;
 form1.Refresh;
end;


procedure TFEditPalette.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FEditPalette', top, left);

 CloseForm16;
end;


procedure TFEditPalette.FormMouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;


end.
