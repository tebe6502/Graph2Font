unit SelectColor;

interface

uses
  Windows, Graphics, Controls, Forms, StdCtrls, Classes, ExtCtrls, ComCtrls;

type
  TFSelectColor = class(TForm)
    Image1: TImage;
    Image2: TImage;
    StatusBar1: TStatusBar;
    Image3: TImage;
    Image4: TImage;
    procedure Image1Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseEnter(Sender: TObject);
    procedure initKolor(const p: TColor);

  private
    { Private declarations }
    spal, old_spal, phint: TPoint;
  public
    { Public declarations }
  end;

var
  FSelectColor: TFSelectColor;

implementation

uses Main, EditColors, EditPMG, EditRasters, EditPalette, EditBMP,
  EditColorsMap;

{$R *.dfm}


procedure TFSelectColor.Image1Click(Sender: TObject);
begin
 getCol:=true;
end;


procedure TFSelectColor.initKolor(const p: TColor);
var ss: TShiftState;
    a, x, y: integer;
begin

 // szukamy w aktualnej palecie AtariPal koloru P
 a:=0;
 for x:=0 to 255 do
  if AtariPal[x]=p then begin a:=x; Break end;

 x:=((a and $0f) shr 1) shl 4;
 y:=(a shr 4) * 15;

 // wymuszamy klikniecie kursora myszki na obszarze palety
 getCol:=true;

 Image1MouseMove(FEditColors, ss, x,y);

end;


function IntToStr(const a: integer): string;
begin
 str(a, Result);
end;


function ColorStatus(const p: TPoint; const j: integer; var c: byte): string;
var cl: TColor;
    zm: string;
    x: integer;
begin

 x:=p.x shl 1+p.y shl 4;

 if x>255 then
  c:=255
 else
  c:=x;

 case gfxMode[j shr 3] of
  1: if Ofset=$200 then c:=c and $0f;
//  4: if Ofset=$000 then c:=c and $f0;
 end;

 cl:=AtariPal[c];

 zm:=IntToStr(c);
 while length(zm)<3 do zm:='0'+zm;

 Result:='RGB('+IntToStr(getRValue(cl))+','+IntToStr(getGValue(cl))+','+IntToStr(getBValue(cl))+') = '+form1.Hex(c,2)+' ('+zm+')';

end;


procedure TFSelectColor.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var j: integer;
    c, old_c: byte;
begin

 j:=0;
 if FEditColors.Visible then j:=FEditColors.GetLineValue else
  if FEditPMG.Visible then j:=FEditPMG.GetLineValue;


 spal:=Point(x shr 4 , y div 15);

 if spal.x>(image1.width shr 4)-1 then spal.x:=image1.Width shr 4-1; 
 if spal.y>15 then spal.y:=15;


 if (x shr 4<>phint.x) or (y div 15<>phint.y) then begin

  phint:=spal;

  Application.CancelHint;

  Image1.Hint:=ColorStatus(spal, j, c);
 end;


if getCol {and form5.Button4.Enabled and form8.BitBtn1.Enabled} then begin

 with image1.Canvas do begin
  Brush.Color:=clBtnFace;              // usuniecie poprzedniego zaznaczenia
  FrameRect(Rect(old_spal.x shl 4, old_spal.Y*15, old_spal.x shl 4+17, old_spal.y*15+16));

  Brush.Color:=0;                      // nowe zaznaczenie koloru w palecie
  FrameRect(Rect(spal.x shl 4, spal.Y*15, spal.x shl 4+17, spal.y*15+16));
 end;


 old_spal:=spal;

 getCol:=false;

 StatusBar1.Panels[0].Text:=ColorStatus(spal, j, c);


 with image2.Canvas do begin
  Pen.Color:=0; Brush.Color:=AtariPal[c];
  Rectangle(0,0,image2.width,image2.height);
 end;


 if FEditColors.visible or FEditPMG.Visible then begin   // EDIT COLORS, EDIT PMG
  old_c := TabKolor[Ofset+j];

  TabKolor[Ofset+j] := c;
  FEditColors.zapisz_palete(j);

  TabKolor[Ofset+j] := old_c;
 end else
  if FEditRasters.Visible then begin           // EDIT RASTERS
   FEditRasters.seValue.Value  := c;
  end else
   if FEditBmp.visible then begin
    palCol[pisCol[0]+2]:=c;
    FEditBmp.frameAtariPalette1.UstawPalete;
   end;


 if FEditColorsMap.visible then begin

  select_cmap_cell_color[select_cmap_color]:=c;

  FEditColorsMap.show_cell_colors;
  FEditColorsMap.FillCellColors;

 end;


 if FEditPalette.visible then begin           // EDIT PALETTE
  upal[upal_idx].ata:=c;
  FEditPalette.showPalPic;
 end;


end;

end;


procedure TFSelectColor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FSelectColor', top, left);

 if FEditColors.Visible then FEditColors.LineChange else
  if FEditPMG.Visible then FEditPMG.Ustaw_Reszte_Kolorow_Duchow(FEditPMG.GetLineValue);
 
end;


procedure TFSelectColor.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then form1.Zamknij(f_SelectColor);
end;


procedure TFSelectColor.FormShow(Sender: TObject);
var bmp: TBitmap;
    s: byte;
    w: integer;
begin

 if FEditColorsMap.visible then begin
  w:=256;
  s:=0;
 end else begin
  w:=128;
  s:=1;
 end;

 FSelectColor.Image4.Width:=w;
 FSelectColor.Image1.Width:=w+1;
 FSelectColor.Image2.Left:=FSelectColor.Image1.Left+FSelectColor.Image1.Width+7;
 FSelectColor.Width:=FSelectColor.Image2.Left+42;


 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(8,128);

 FEditPalette.VLineHeader(bmp);
 image3.Picture.Graphic:=bmp;

 bmp.SetSize(image4.Width,8);
 FEditPalette.HLineHeader(bmp, s);
 image4.Picture.Graphic:=bmp;

 bmp.SetSize(image1.Width, image1.Height);
 FEditPalette.DrawPalette(bmp, s);
 image1.Picture.Graphic:=bmp;

 Bmp.Free;

end;


procedure TFSelectColor.FormMouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;

end.
