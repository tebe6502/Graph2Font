unit Zoom;

interface

uses
  Windows, Messages, Graphics, Controls, Forms, Menus, StdCtrls, Classes,
  ExtCtrls, Buttons, ComCtrls, SysUtils, ToolWin, BMDSpinEdit, ActnList,
  AtariPalette, System.Actions, GR32, GR32_Image, GR32_Layers;

type
  TFZoom = class(TForm)
    MainMenu1: TMainMenu;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    HotKeys1: TMenuItem;
    penq1: TMenuItem;
    penw1: TMenuItem;
    putSpr1: TMenuItem;
    oldCol1: TMenuItem;
    KoloryPMG: TPanel;
    pParameter: TPanel;
    Label5: TLabel;
    rbLayerALL: TRadioButton;
    rbLayerBMP: TRadioButton;
    rbLayerPMG: TRadioButton;
    getSpr1: TMenuItem;
    Panel3: TPanel;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    help2: TMenuItem;
    seZoomFactor: TBMDSpinEdit;
    seBrushWidth: TBMDSpinEdit;
    seGridWidth: TBMDSpinEdit;
    seGridHeight: TBMDSpinEdit;
    ToolButton4: TToolButton;
    Panel4: TPanel;
    rbPreviewPMG: TRadioButton;
    rbPreviewBMP: TRadioButton;
    rbPreviewALL: TRadioButton;
    Label1: TLabel;
    ToolButton6: TToolButton;
    ToolButton2: TToolButton;
    Panel5: TPanel;
    frameAtariPalette1: TframeAtariPalette;
    KoloryPF: TPanel;
    ActionList2: TActionList;
    aGrid: TAction;
    aColors: TAction;
    aMarker: TAction;
    PMGAND: TAction;
    PMGORA: TAction;
    Image1: TImgView32;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure UstawPisak;
    procedure UstawAct;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Grid;
    procedure SetFactor(const WheelDelta: integer);
    procedure penq1Click(Sender: TObject);
    procedure penw1Click(Sender: TObject);
    procedure putSpr1Click(Sender: TObject);
    procedure oldCol1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PanelPMGClick(Sender: TObject);
    procedure seZoomFactorChange(Sender: TObject);
    procedure seGridWidthChange(Sender: TObject);
    procedure seGridHeightChange(Sender: TObject);
    procedure seBrushWidthChange(Sender: TObject);
    procedure rbLayerALLClick(Sender: TObject);
    procedure rbLayerBMPClick(Sender: TObject);
    procedure rbLayerPMGClick(Sender: TObject);
    procedure getSpr1Click(Sender: TObject);
    procedure SetZoomPisPalette;
    procedure help2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure aGridExecute(Sender: TObject);
    procedure aColorsExecute(Sender: TObject);
    procedure aMarkerExecute(Sender: TObject);
    procedure rbPreviewPMGClick(Sender: TObject);
    procedure rbPreviewBMPClick(Sender: TObject);
    procedure rbPreviewALLClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PMGANDExecute(Sender: TObject);
    procedure PMGORAExecute(Sender: TObject);
    procedure FormKeyDown(var MousePos: TPoint);
    procedure AddInvers;
    procedure Image1Click(Sender: TObject);
    procedure frameAtariPalette1PenColorsClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);


  private
    { Private declarations }
    lp, old_lp: TPoint;

    GridImage: TBitmapLayer;

    PaletteDirect: Boolean;

    OldScrollProc: TWndMethod;
    procedure ScrollWindowProc(var Message: TMessage);

  public
    { Public declarations }
  end;

var
  FZoom: TFZoom;
  klik, moveBMP: Boolean;
  undo, old_Pixel: byte;
  bMarquee: Boolean;
  pedzel_bt: Boolean = false;
  ptOrigin, ptMove : TPoint;
  old_col: integer;

  ZoomPalette, CursorMarker: TBitmapLayer;

  act_label: array [0..7] of TLabel;
  spr_panel: array [1..8] of TPanel;

  pisBrush: array [0..7, 0..7] of byte;

  factor : byte = 4;

  grd_wid: byte = 1;
  grd_hig: byte = 1;

  grd_col: Boolean = true;

implementation

uses Main, SelectColor, EditPMG;

{$R *.dfm}


procedure GridPosition;
var mul_w, mul_h: integer;
    x, s: real;
begin

 mul_w := (grd_wid*8*factor);

 if Fox1 then
  mul_h := (grd_hig shl 2) * factor
 else
  mul_h := (grd_hig shl 3) * factor;

// x:=FZoom.Image1.Left * ord(FZoom.ScrollBox1.ClientWidth > FZoom.Image1.Width) + (FZoom.Image1.Left mod mul_w) * ord(FZoom.ScrollBox1.ClientWidth <= FZoom.Image1.Width)+(FZoom.HorzScrollBar.Position div mul_w)*mul_w;
// y:=FZoom.Image1.Top * ord(FZoom.ScrollBox1.ClientHeight > FZoom.Image1.Height) + (FZoom.Image1.Top mod mul_h) * ord(FZoom.ScrollBox1.ClientHeight <= FZoom.Image1.Height)+(FZoom.VertScrollBar.Position div mul_h)*mul_h;

 FZoom.GridImage.Location:=FloatRect(0,0, 48*mul_w, 30*mul_h);

// FZoom.GridImage.Left:=FZoom.Image1.Left * ord(FZoom.ScrollBox1.ClientWidth > FZoom.Image1.Width) + (FZoom.Image1.Left mod mul_w) * ord(FZoom.ScrollBox1.ClientWidth <= FZoom.Image1.Width)+(FZoom.HorzScrollBar.Position div mul_w)*mul_w;
// FZoom.GridImage.Top:=FZoom.Image1.Top * ord(FZoom.ScrollBox1.ClientHeight > FZoom.Image1.Height) + (FZoom.Image1.Top mod mul_h) * ord(FZoom.ScrollBox1.ClientHeight <= FZoom.Image1.Height)+(FZoom.VertScrollBar.Position div mul_h)*mul_h;

 if ini_zom.p then begin


  s:=(45*factor * 0.25);

  if FZoom.PaletteDirect then begin

    if FZoom.ClientWidth > FZoom.image1.Width then
      x := FZoom.image1.Width - s
    else
      x := FZoom.ClientWidth +  FZoom.ScrollBox1.HorzScrollBar.Position - s;

  end else begin

    if FZoom.ClientWidth > FZoom.image1.Width then
      x := 0
    else
      x := FZoom.ScrollBox1.HorzScrollBar.Position;

  end;

  ZoomPalette.Location:=FloatRect(x, 0, x + s, 30*mul_h);

//  FZoom.Caption:=format('x: %d, y: %d, hit: %d',[ FZoom.lp.X, Fzoom.lp.Y, ord( ZoomPalette.HitTest(FZoom.lp.x, FZoom.lp.y )) ]  ) ;

// {ord( PtInRect( Rect(round(x),0, round(x+s),30*mul_h), FZoom.lp )) ]
 end;

end;


procedure TFZoom.Grid;
var mul_w, mul_h: integer;
    y: byte;
    g: TBitmap32;
begin

if aGrid.Checked then begin

 mul_w := (grd_wid shl 3) * factor;

 if Fox1 then
  mul_h := (grd_hig shl 2) * factor
 else
  mul_h := (grd_hig shl 3) * factor;

 g:=TBitmap32.Create;
 with g do begin
  BeginUpdate;

  SetSize(48*mul_w, 30*mul_h);

  OuterColor:=Color32(transCol);
  Clear(Color32(transCol));
  DrawMode := dmTransparent;
  CombineMode := cmBlend;

  SetStipple([{clWhite32} clLightGray32, 0]);
  StippleStep:=0.5;

  for y:=47 downto 0 do VertLineTSP(y * mul_w, 0, 30*mul_h);

  for y:=29+(30*ord(fox1)) downto 0 do HorzLineTSP(0, y*mul_h, 48*mul_w);

  EndUpdate;
 end;

 GridImage.Bitmap := g;

 g.Free;

 GridPosition;

end;

end;


procedure TFZoom.help2Click(Sender: TObject);
begin
 Application.MessageBox('TAB'#9#9'swap PenColor BAK-COL0..15'#13#10+
                        'SPACE'#9#9'set pixel'#13#10+
                        'ENTER'#9#9'get value of pixel under mouse cursor'#13#10+
                        'others key'#9#9'invers char (add 5-th color if Pixel=2)'#13#10+
                        '''Q'', ''W'''#9#9'select PenColor'#13#10+
                        '''1''..''8'''#9#9'activate/deactivate PMG object'#13#10+
                        '''O'', ''D'''#9#9'PMG draw mode'#13#10+
                        '''A'', ''E'''#9#9'PMG erase mode'#13#10+
                        '''`'''#9#9'switch layer'#13#10+
                        'WheelUp/Down'#9'change zoom factor'#13#10+
                        '+'#9#9'zoom factor up'#13#10+
                        '-'#9#9'zoom factor down'#13#10#13#10+
                        'Alt+P'#9#9'EDIT PMG Enabled'#13#10+
                        '''S'''#9#9'put selected PMG object on screen'#13#10+
                        '''G'''#9#9'get parameters of selected PMG object'#13#10,
                        'Help',MB_ICONINFORMATION);
end;


procedure TFZoom.rbLayerALLClick(Sender: TObject);
// Layer ALL
begin
 ini_zom.layer:=LayerALL;

 StatusBar1.Panels[5-1].Text:='Layer ALL';

 ScrollBox1.SetFocus;
end;


procedure TFZoom.rbLayerBMPClick(Sender: TObject);
// Layer BMP
begin
 ini_zom.layer:=LayerBMP;

 StatusBar1.Panels[5-1].Text:='Layer BMP';

 ScrollBox1.SetFocus;
end;


procedure TFZoom.rbLayerPMGClick(Sender: TObject);
// Layer PMG
begin
 ini_zom.layer:=LayerPMG;

 StatusBar1.Panels[5-1].Text:='Layer PMG';

 ScrollBox1.SetFocus;
end;


procedure TFZoom.seGridWidthChange(Sender: TObject);
// GRID WIDTH
begin
 grd_wid:=seGridWidth.Position;
 grid;

 ScrollBox1.SetFocus;
end;


procedure TFZoom.seGridHeightChange(Sender: TObject);
// GRID HEIGHT
begin
 grd_hig:=seGridHeight.Position;
 grid;

 ScrollBox1.SetFocus;
end;


procedure TFZoom.ScrollWindowProc(var Message: TMessage);
begin

 OldScrollProc(Message);

// ShowScrollBar(ScrollBox2.Handle, SB_VERT, False);
// ShowScrollBar(ScrollBox3.Handle, SB_VERT, False);

 if (Message.Msg = WM_VSCROLL) or (Message.Msg = WM_HSCROLL) then begin
  GridPosition;
//  ScrollBox2.VertScrollBar.Position:=ScrollBox1.VertScrollBar.Position;
//  ScrollBox3.VertScrollBar.Position:=ScrollBox1.VertScrollBar.Position;
 end;

end;


procedure zapisz_parametry_zooma;
begin

 with FZoom do begin
  ini_zom.w := Width;
  ini_zom.h := Height;
  ini_zom.t := Top;
  ini_zom.l := Left;
  ini_zom.s := WindowState;
  ini_zom.g := aGrid.Checked;

  ini_zom.c := aMarker.Checked;

  ini_zom.f := factor;

  ini_zom.hs := ScrollBox1.HorzScrollBar.Position;
  ini_zom.vs := ScrollBox1.VertScrollBar.Position;
 end;

end;


procedure TFZoom.UstawPisak;
begin

 frameAtariPalette1.UstawPalete;

 StatusBar1.Panels[6-1].Text:=format('Pen Color: %d', [ pisCol[0] ]);

end;


procedure TFZoom.seZoomFactorChange(Sender: TObject);
// ZOOM FACTOR
begin
 SetFactor(0);

 ScrollBox1.SetFocus;
end;


procedure TFZoom.PMGANDExecute(Sender: TObject);
// PMG AND PIXEL - ERASER
begin
 PMGORA.Checked:=false;
 PMGAND.Checked:=true;

 FilSpr:=2;
 StatusBar1.Panels[4-1].Text:='PMG Eraser';
end;


procedure TFZoom.PMGORAExecute(Sender: TObject);
// PMG ORA PIXEL
begin
 PMGORA.Checked:=true;
 PMGAND.Checked:=false;

 FilSpr:=1;
 StatusBar1.Panels[4-1].Text:='PMG Brush';
end;


procedure TFZoom.SetZoomPisPalette;
begin

 if Pixel<>old_Pixel then begin
  old_Pixel:=Pixel;
//  frameAtariPalette1.UstawPalete;
 end;

end;


procedure SetZoomPisBrush;
var bmp: TBitmap;
    a,b, i: byte;
begin

   bmp:=TBitmap.Create;
   form1.ImageList4.GetBitmap(pisPat, bmp);

   for b := 0 to 7 do                       // Brush
    for a := 0 to 7 do
     PisBrush[a,b] := ord(bmp.Canvas.Pixels[a, b] <> 0);

   bmp.Free;

end;


procedure setMarker(cir: Boolean);
var mul_w, mul_h: integer;
    y: byte;
    g: TBitmap32;
    r: TFloatRect;


procedure MarkerCircle(x,y, r: word);
(*
@description:

 https://atariwiki.org/wiki/Wiki.jsp?page=Super%20fast%20circle%20routine

 REM *******************************
 REM PROGRAM  : FAST CIRCLE DRAWING
 REM AUTHOR   : ZLATKO BLEHA
 REM PUBLISHER: MOJ MIKRO MAGAZINE
 REM ISSUE NO.: 1989, NO.3, PAGE 29
 REM *******************************

*)
var a: smallint;
    b, c: byte;
begin

 if r < 2 then exit;

 b:=r;
 a:=r-1;
 c:=0;

while (b >= c) do begin

 while (a >= 0) and (b >= c) do begin

  g.SetPixelTS (x+C,Y+B, clWhite32);
  g.SetPixelTS (x+C,Y-B, clWhite32);
  g.SetPixelTS (x-C,Y-B, clWhite32);
  g.SetPixelTS (x-C,Y+B, clWhite32);
  g.SetPixelTS (x+B,Y+C, clWhite32);
  g.SetPixelTS (x+B,Y-C, clWhite32);
  g.SetPixelTS (x-B,Y-C, clWhite32);
  g.SetPixelTS (x-B,Y+C, clWhite32);

  inc(c);

  inc(a);
  dec(a, c);
  dec(a, c);

 end;

 dec(b);

 inc(a, b);
 inc(a, b);

end;

end;


begin

if FZoom.aMarker.Checked then begin

 mul_w := Pixel * factor;
 mul_h :=  factor;

 r:=CursorMarker.Location;

 g:=TBitmap32.Create;
 with g do begin
  BeginUpdate;

  SetSize(round(r.Right-r.Left), round(r.Bottom-r.Top));

  OuterColor:=Color32(transCol);
  Clear(Color32(transCol));
  DrawMode := dmTransparent;
  CombineMode := cmBlend;

  SetStipple([clWhite32, 0]);
  StippleStep:=0.5;


  if cir then begin

   MarkerCircle(round(r.Right-r.Left) div 2, round(r.Bottom-r.Top) div 2, FZoom.seBrushWidth.Position*factor-2)   ;

   //fzoom.Caption:=inttostr(FZoom.seBrushWidth.Position*factor*8);

   end

  else begin

    VertLineTSP(0, 0, mul_h);
    VertLineTSP(mul_w-1, 0, mul_h);

    HorzLineTSP(0, 0, mul_w);
    HorzLineTSP(0, mul_h-1, mul_w);

  end;

  EndUpdate;
 end;

 CursorMarker.Bitmap := g;

 g.Free;

end;

end;


procedure Set_Pedzel;
var s, pmg_penW: byte;
    w: integer;
    r: TFloatRect;
begin

 w:=0;

 if FEditPMG.Visible then begin

  pmg_penW:=FEditPMG.get_pmg_size;

  s:=(pmg_penW + ord(pmg_penW=0)) shl 4;

  w:=(s*factor) div pmg_div;

 end else
  case prev of
   ___PMG: w:=factor shl 1;
   ___BMP: w:=Pixel*factor;

   ___ALL:{ if Pixel=4 then
            w:=factor shl 1
           else}
            w:=Pixel*factor;
  end;


//  FZoom.Shape1.Width:=FZoom.seBrushWidth.Position*factor*8;
//  FZoom.Shape1.Width:=FZoom.Height;

 r := CursorMarker.location;

// CursorMarker.Location := FloatRect(r.Left, r.Top, r.Left + FZoom.seBrushWidth.Position*factor*8, r.Top + FZoom.Height);


 if (PenS=1) or FEditPMG.Visible then begin
  //FZoom.Shape1.Shape:=stRectangle;

  //FZoom.Shape1.Width:=w;
  //FZoom.Shape1.Height:=factor;

   CursorMarker.Location := FloatRect(r.Left, r.Top, r.Left + w, r.Top + factor);

   setMarker(false);

 end else begin
  //FZoom.Shape1.Shape:=stCircle;

  //FZoom.Shape1.Width:=FZoom.seBrushWidth.Position*w;
//  FZoom.Shape1.Height:=FZoom.seBrushWidth.Position*w;

   CursorMarker.Location := FloatRect(r.Left, r.Top, r.Left + FZoom.seBrushWidth.Position*w, r.Top + FZoom.seBrushWidth.Position*w);

   setMarker(true);

 end;

 SetZoomPisBrush;

end;


procedure TFZoom.SetFactor(const WheelDelta: integer);
begin

 if (WheelDelta<0) and (seZoomFactor.Position>0) then seZoomFactor.Position:=seZoomFactor.Position - 1 else
  if (WheelDelta>0) and (seZoomFactor.Position<seZoomFactor.MaxValue) then seZoomFactor.Position:=seZoomFactor.Position + 1;

 if (factor<>seZoomFactor.Position) or (WheelDelta=0) then begin

  factor:=seZoomFactor.Position;

  Image1.Width:=384*factor;
  Image1.Height:=240*factor;


  scrollbox1.HorzScrollBar.Range:=image1.Width;
  scrollbox1.VertScrollBar.Range:=image1.Height;

  ScrollBox1.HorzScrollBar.Position:=0;
  ScrollBox1.VertScrollBar.Position:=0;

  if ScrollBox1.ClientWidth>Image1.Width then
   Image1.Left:=ScrollBox1.ClientWidth div 2-Image1.Width div 2
  else
   Image1.Left:=0;

  if ScrollBox1.ClientHeight>Image1.Height then
   Image1.Top:=ScrollBox1.ClientHeight div 2-Image1.Height div 2
  else
   Image1.Top:=0;


  Set_Pedzel;

//  Shape1.Visible:=aMarker.Checked;

  Grid;

//  ScrollBox1.HorzScrollBar.Position:=lp.x - ScrollBox1.ClientWidth div 2;
//  ScrollBox1.VertScrollBar.Position:=lp.y - ScrollBox1.ClientHeight div 2;

 end;

end;


function testX(const a: integer): integer;
begin
 Result:=a;

 if Result<0 then Result:=0 else
  if Result>383 then Result:=383;
end;


function testY(const a: integer): integer;
begin
 Result:=a;

 if Result<0 then Result:=0 else
  if Result>239 then Result:=239;
end;


function GetPen: smallint;
var x, y, i: integer;
begin

 x:=(FZoom.lp.x div factor) div Pixel;
 y:=testY(FZoom.lp.y div factor);

 i:=(x*Pixel) shr 3 + tmul48[y];

 Result:=form1.locate(tab[i], x);

end;


function piksel(const a,b,c: byte):Boolean;
(*----------------------------------------------------------------------------*)
(*  a  - bit z tablicy obecnosci spritow                                      *)
(*  b  - kod sprita $80-$83, sprite i pocisk maja ten sam kod                 *)
(*  c  - numer obiektu od 0-7                                                 *)
(* pik - wartosc piksla grafiki                                               *)
(*----------------------------------------------------------------------------*)
var m1, m2, i: byte;
    nowy: Boolean;
begin
 Result:=false;

 nowy:=false; m1:=$ff; m2:=$ff;

 for i:=0 to 9 do begin
  if pik=tprior[i] then m1:=i;
  if b=tprior[i] then m2:=i;
 end;

if m2<=m1 then begin nowy:=true; pik:=b end;

if nowy and (a>0) and (act[c]>0) then Result:=true;

end;


procedure testPixel(var a:cardinal; const c,s:byte);
(*----------------------------------------------------------------------------*)
(* liczymy kolor piksla ducha na grafice gr8                                  *)
(*----------------------------------------------------------------------------*)
var inv: byte;
    hlp: integer;
    tmpCol: TColor;
begin

 if prev=___PMG then
  inv:=0
 else begin
  hlp:=a shr 3+tmul48[crY];

  inv:=(tab[hlp] and twyt1[a mod 8]) shr (7-(a mod 8));
 end;

 tmpCol := form1.testPixel(crX-CzarnyPas, c,s, inv, s);

 form1.Scan_Pixel(zomek_linia , integer(a) , tmpCol);

end;


procedure testPixel4(var x:cardinal; const c,s:byte);
(*----------------------------------------------------------------------------*)
(* stawiamy piksla ducha na grafice gr9                                       *)
(*----------------------------------------------------------------------------*)
var v, p: byte;
    w: integer;
    tmpCol: TColor;
begin

 w:=c shl 8+$500;
 if ply5 and (s and 1>0) then w:=$400;

 v:=tabKolor[w+crY];
// k:=v and $f0;          //kolor PMG

 p:=tab[x shr 3 + tmul48[crY]];

 if x and 7<4 then
  p:=p shr 4
 else
  p:=p and $0f;

 if ply5 and (prev>___PMG) and (s and 1>0) then
  tmpCol:=AtariPal[v and $f0+p]
 else
  tmpCol:=AtariPal[v];

 form1.scan_pixel(zomek_linia , x , tmpCol);
end;


procedure PixSpr(const ad, spr:integer);
var c: byte;
    pomoc, adr: cardinal;
    tmpCol: TColor;
begin

c:=(byte(spr shr 8)) shr 1;

pomoc:=ad shl 1;

// with zomek.canvas do begin
  case Pixel of
   1: begin
       testPixel(pomoc,c, byte(spr shr 8));

       inc(pomoc);

       testPixel(pomoc,c, byte(spr shr 8));
      end;

// jesli obiekt PMG to pocisk i jest ustawiony 5-y gracz to ustaw kolor 711
   2: begin

       adr:=(ad*Pixel) shr 3 + tmul48[crY];
       c:=form1.locate(tab[adr], integer(ad));

       adr:=(ad*Pixel) shr 3 + tmul48[crY shr 3];

       if Fox1 and (crY and 7>3) then begin

        if invers2[adr]>127 then inc(c);

       end else
        if invers[adr]>127 then inc(c);


       px:=ad*Pixel - CzarnyPas;      // dla testPixel2 wymagana jest zmienna PX           

       adr:=ad+crY*290;
       tmpCol:=form1.testPixel2(adr, byte(spr shr 8), c, crY);

       form1.Rysuj(zomek_linia , pomoc , tmpCol);
      end;

   4: begin
       testPixel4(pomoc,c, byte(spr shr 8));

       inc(pomoc);
       testPixel4(pomoc,c, byte(spr shr 8));
      end;

   end;
   
end;


procedure PixelAtari(const ofsX,ofsY: byte);
var x, y, hlp, hlp2: integer;
begin
  x:=crX+ofsX; y:=testY(crY+ofsY);

  hlp:=(x*Pixel) shr 3+tmul48[y];

  hlp2:=(x*Pixel) shr 3+tmul48[y shr 3];

  if gfxMode[y shr 3]=2 then
   case pisCol[0 xor PrawyPrzycisk] of

    3: if Fox1 and (y and 7>3) then
        invers2[hlp2]:=invers2[hlp2] and $7f
       else
        invers[hlp2]:=invers[hlp2] and $7f;

    4: if Fox1 and (y and 7>3) then
        invers2[hlp2]:=invers2[hlp2] or $80
       else
        invers[hlp2]:=invers[hlp2] or $80;

   end;

  tab[hlp]:=form1.Bajt_Obrazu(tab[hlp],x, pisCol[pisBrush[crX mod 8, crY mod 8] xor PrawyPrzycisk]);
end;


procedure UstawTabliceKolor(const _crX,_crY:integer);
var i, w: byte;
begin

 i:=0;

// invers w 'i'
 if UseChar then
  if Fox1 and (_crY and 7>3) then begin

   if (invers2[tmul48[_crY shr 3]+(_crX*Pixel) shr 3]>127) then i:=1;

  end else
   if (invers[tmul48[_crY shr 3]+(_crX*Pixel) shr 3]>127) then i:=1;


 with FZoom do begin

  case Pixel of
   1: begin
       palCol[2+0]:=form1.TestRaster(_crX,_crY,0,0);
       palCol[2+1]:=form1.TestRaster(_crX,_crY,0,1);
      end;

   2: begin
       palCol[2+0]:=form1.TestRaster(_crX shl 1,_crY,0,0);
       palCol[2+1]:=form1.TestRaster(_crX shl 1,_crY,0,1);
       palCol[2+2]:=form1.TestRaster(_crX shl 1,_crY,0,2);
       palCol[2+3]:=form1.TestRaster(_crX shl 1,_crY,0,3);
       palCol[2+4]:=form1.TestRaster(_crX shl 1,_crY,0,4);
      end;

   4: begin
       if t_gtia(form1.SelectGTIA.ItemIndex)=gr10 then begin

        palCol[2+0]:=form1.TestRaster(_crX shl 1,_crY,0,0);
        palCol[2+1]:=form1.TestRaster(_crX shl 1,_crY,0,1);
        palCol[2+2]:=form1.TestRaster(_crX shl 1,_crY,0,2);
        palCol[2+3]:=form1.TestRaster(_crX shl 1,_crY,0,3);
        palCol[2+4]:=form1.TestRaster(_crX shl 1,_crY,0,4);
        palCol[2+5]:=form1.TestRaster(_crX shl 1,_crY,0,5);
        palCol[2+6]:=form1.TestRaster(_crX shl 1,_crY,0,6);
        palCol[2+7]:=form1.TestRaster(_crX shl 1,_crY,0,7);
        palCol[2+8]:=form1.TestRaster(_crX shl 1,_crY,0,8);

       end else begin

        gr15gtia40[3]:=2;
        gr15gtia40[7]:=2;
        gr15gtia40[11]:=6;
        gr15gtia40[12]:=8;
        gr15gtia40[13]:=8;
        gr15gtia40[14]:=9;
        gr15gtia40[15]:=10;

        for w:=15 downto 0 do
         if gfxMode[_crY shr 3] in [1,4] then

          palCol[2+w]:=form1.gr9col(TabKolor[_crY],w, t_gtia(form1.SelectGTIA.ItemIndex))

         else begin

          if i>0 then begin
           gr15gtia40[3]:=3;
           gr15gtia40[7]:=3;
           gr15gtia40[11]:=7;
           gr15gtia40[12]:=12;
           gr15gtia40[13]:=12;
           gr15gtia40[14]:=13;
           gr15gtia40[15]:=15;
          end;

          palCol[2+w]:=form1.gr9col(TabKolor[_crY], gr15gtia40[w], t_gtia(form1.SelectGTIA.ItemIndex));

         end;

       end;

//       for w:=5 to 15 do pis_panel[w].Color := Kolor[w];

      end;

  end;

//  for w:=4 downto 0 do pis_panel[w].Color := Kolor[w];

 end;

 FZoom.frameAtariPalette1.UstawPalete;
end;


procedure Punkt(const x,y: integer);
var i, j, v, v2, k, idx, tx, r,g,b: byte;
    hlp, s, mulX, pom_mul, pmx, ty: integer;
    old_crX, old_crY, pixel_tmp, pom: integer;
begin

try

// pozycja kursora z uwzglednieniem proporcji pixla
crX:=testX(x div factor) div Pixel;
crY:=testY(y div factor);

zomek_linia:=zomek.ScanLine[crY];

if gfxMode[crY shr 3]=0 then exit;


if (x>=0) and (y>=0) then begin

  old_crX:=crX; old_crY:=crY;

  Prior:=form1.TestRasterPrior(crX, crY);

  if (gfxMode[crY shr 3]=1) and (Prior=4) then Prior:=2;

  FEditPMG.SetPrior(Prior,false);

  FEditPMG.GetPlayer5Value(crY,false);  // ustawienie ply5
  FEditPMG.GetMLCValue(crY,false);      // ustawienie MLC

  hlp:=(crX*Pixel) shr 3 + tmul48[crY];

  if prev=___PMG then
   pik:=0
  else
   pik:=form1.locate(tab[hlp], old_crX);

  pixel_tmp:=-1;

  i:=$ff; hlp:=0; s:=0;

//  w:=8;
//  tx:=0; ty:=-32;

  pmx:=0;

 if {(Pixel<>4) and} (prev<>___BMP) then begin

// ustalamy ktory duch jest na wierzchu

 if Pixel=4 then
  pmx:=(x div factor) div 2
 else
  pmx:=crX div (2 div Pixel);


 v:=Sprajt[crY, pmx];

 if (v>0) and (prev<>___BMP) then begin

 if ply5 then begin
// gdy jest wlaczony 5-y gracz
  for idx:=9 downto 0 do
   case tprior[idx] of
    $80: if piksel(v and $01,$80,0) then begin i:=$01; s:=$000; hlp:=spr0[crY]; {w:=8} end;
    $81: if piksel(v and $04,$81,1) then begin i:=$04; s:=$200; hlp:=spr1[crY]; {w:=8} end;
    $82: if piksel(v and $10,$82,2) then begin i:=$10; s:=$400; hlp:=spr2[crY]; {w:=8} end;
    $83: if piksel(v and $40,$83,3) then begin i:=$40; s:=$600; hlp:=spr3[crY]; {w:=8} end;
    $84: if FEditPMG.GetPrior(crY)=3 then begin      // prior = 8

           if SprajtX[crY, pmx] and $55=0 then begin
            if piksel(v and $02,$84,4) then begin i:=$02; s:=$100; hlp:=mis0[crY]; {w:=2} end;
            if piksel(v and $08,$84,5) then begin i:=$08; s:=$300; hlp:=mis1[crY]; {w:=2} end;
            if piksel(v and $20,$84,6) then begin i:=$20; s:=$500; hlp:=mis2[crY]; {w:=2} end;
            if piksel(v and $80,$84,7) then begin i:=$80; s:=$700; hlp:=mis3[crY]; {w:=2} end;
           end;

          end else begin

           if piksel(v and $02,$84,4) then begin i:=$02; s:=$100; hlp:=mis0[crY]; {w:=2} end;
           if piksel(v and $08,$84,5) then begin i:=$08; s:=$300; hlp:=mis1[crY]; {w:=2} end;
           if piksel(v and $20,$84,6) then begin i:=$20; s:=$500; hlp:=mis2[crY]; {w:=2} end;
           if piksel(v and $80,$84,7) then begin i:=$80; s:=$700; hlp:=mis3[crY]; {w:=2} end;
         end;

   end;

 end else begin
// bez 5-go gracza
  for idx:=9 downto 0 do
   case tprior[idx] of
    $80: begin
          if piksel(v and $01,$80,0) then begin i:=$01; s:=$000; hlp:=spr0[crY]; {w:=8} end;
          if piksel(v and $02,$80,4) then begin i:=$02; s:=$100; hlp:=mis0[crY]; {w:=2} end;
         end;
    $81: begin
          if piksel(v and $04,$81,1) then begin i:=$04; s:=$200; hlp:=spr1[crY]; {w:=8} end;
          if piksel(v and $08,$81,5) then begin i:=$08; s:=$300; hlp:=mis1[crY]; {w:=2} end;
         end;
    $82: begin
          if piksel(v and $10,$82,2) then begin i:=$10; s:=$400; hlp:=spr2[crY]; {w:=8} end;
          if piksel(v and $20,$82,6) then begin i:=$20; s:=$500; hlp:=mis2[crY]; {w:=2} end;
         end;
    $83: begin
          if piksel(v and $40,$83,3) then begin i:=$40; s:=$600; hlp:=spr3[crY]; {w:=8} end;
          if piksel(v and $80,$83,7) then begin i:=$80; s:=$700; hlp:=mis3[crY]; {w:=2} end;
         end;
   end;

 end;

 end;
 end;


 if t_mode(form1.SelectMode.ItemIndex) in [m_pgr, m_gedm, m_gedp] then begin

  tx:=1;
  ty:=-32;

  case i of
   $02: begin tx:=RasterLine[pmx shl 1].m0s+1; ty:=RasterLine[pmx shl 1].m0x-32 end;
   $08: begin tx:=RasterLine[pmx shl 1].m1s+1; ty:=RasterLine[pmx shl 1].m1x-32 end;
   $20: begin tx:=RasterLine[pmx shl 1].m2s+1; ty:=RasterLine[pmx shl 1].m2x-32 end;
   $80: begin tx:=RasterLine[pmx shl 1].m3s+1; ty:=RasterLine[pmx shl 1].m3x-32 end;

   $01: begin tx:=RasterLine[pmx shl 1].p0s+1; ty:=RasterLine[pmx shl 1].p0x-32 end;
   $04: begin tx:=RasterLine[pmx shl 1].p1s+1; ty:=RasterLine[pmx shl 1].p1x-32 end;
   $10: begin tx:=RasterLine[pmx shl 1].p2s+1; ty:=RasterLine[pmx shl 1].p2x-32 end;
   $40: begin tx:=RasterLine[pmx shl 1].p3s+1; ty:=RasterLine[pmx shl 1].p3x-32 end;
  end;

 end else begin
  tx:=hlp shr 8;           // zdekodowanie szerokosci ducha
  ty:=hlp and $00ff;       // zdekodowanie pozycji poziomej ducha

  tx:=tx and $f; if tx=0 then tx:=1;
 end;


// dla PIXEL=4 duchy zas³aniaj¹ grafikê, najpierw wylacz ducha/pocisk
// potem stawiaj pixle

// modyfikacja tylko gdy sprite jest na wierzchu
if (i<>$ff) and (ini_zom.layer<>LayerBMP) then begin
 pixel_tmp:=1;

 if Pixel=4 then
  pom:=(((x div factor) shr 1)-ty) div tx
 else
  pom:=((crX div (2 div Pixel))-ty) div tx;

 if not(pom in [0..7]) then exit;

// wyliczenie pixla i jego EOR, v to numer bitu 0-7

 case FilSpr of
//   0: Smask[s+crY]:=Smask[s+crY] xor twyt1[v];   //xor
  1: Smask[s+crY]:=Smask[s+crY] or twyt1[pom];    //or
  2: Smask[s+crY]:=Smask[s+crY] and tand1[pom];   //and
 end;

{
  for k:=0 to w-1 do begin

   v2:=Smask[s+crY] and twyt1[k];

   pom:=ty+k*tx;

   for j:=0 to tx-1 do
    if v2>0 then
     SprajtX[crY, pom+j]:=(SprajtX[crY, pom+j] or i)
    else
     SprajtX[crY, pom+j]:=(SprajtX[crY, pom+j] and (i xor $ff));

  end;
}

// pobranie koloru sprita
 pmx:=ty+pom*tx;
end;

// wypelnia pixlami pod duchami - robi dziure
// pixel_tmp = 1 gdy trafiamy w piksel PMG

//  form1.scan_pixel(zomek_linia , mulX , clRed);

if pixel_tmp=1 then begin

// mulX:=pmx shl 1;                 // ta wersja wstawia cale bajty tego samego koloru !!! zleeeeeeeeeeeeeee
{
 if FilSpr=1 then begin
//  r:=GetRValue(AtariPal[rKolor[crY, 5+s div $200]]);
//  g:=GetGValue(AtariPal[rKolor[crY, 5+s div $200]]);
//  b:=GetBValue(AtariPal[rKolor[crY, 5+s div $200]]);

  r:=GetRValue(AtariPal[RasterLine[mulX].kolor[5+s div $200] ]);
  g:=GetGValue(AtariPal[RasterLine[mulX].kolor[5+s div $200] ]);
  b:=GetBValue(AtariPal[RasterLine[mulX].kolor[5+s div $200] ]);
 end else begin

  if Pixel=1 then begin                          // gdy PMG ERASER rysujemy kolorem tla
   r:=GetRValue(AtariPal[RasterLine[mulX].kolor[3]]);
   g:=GetGValue(AtariPal[RasterLine[mulX].kolor[3]]);
   b:=GetBValue(AtariPal[RasterLine[mulX].kolor[3]]);
  end else begin
   r:=GetRValue(AtariPal[RasterLine[mulX].kolor[0]]);
   g:=GetGValue(AtariPal[RasterLine[mulX].kolor[0]]);
   b:=GetBValue(AtariPal[RasterLine[mulX].kolor[0]]);
  end;

 end;

 for i:=0 to (tx shl 1)-1 do begin        // odtworzenie piksli bajtu obrazu
  pom_mul:=(mulX+i) shl 2;

  zomek_linia[pom_mul+2] := r;
  zomek_linia[pom_mul+1] := g;
  zomek_linia[pom_mul]   := b;
 end;
}

//  form1.scan_pixel(zomek_linia , mulX , clRed);


end else begin                       // pixel_tmp=-1 modyfikujemy piksle bitmapy

 if Pixel=4 then
  pmx:=(x div factor) shr 1
 else
  pmx:=crX div (2 div Pixel);


 if ini_zom.layer<>LayerPMG then                 // !!! konieczny warunek !!!

 case prev of
 ___PMG:
     if crX<(384 div Pixel) then begin
      mulX:=crX*Pixel;

      form1.Rysuj(zomek_linia , mulX , 0);
     end;

 ___ALL, ___BMP:
     if crX<(384 div Pixel) then begin
      mulX:=crX*Pixel;

      form1.Rysuj(zomek_linia , mulX , AtariPal[palCol[2+pisCol[pisBrush[crX mod 8, crY mod 8] xor PrawyPrzycisk]]]);

      PixelAtari(0,0);
    end;

 end;

end;


// teraz stawiamy piksel w kolorze PMG
// bez ponizszej procki bedzie stawiac czarne piksle az do momentu puszczenia przycisku myszki

if prev<>___BMP then begin

// TX to aktualna szerokosc ducha TX=[1,2,4]
// tworzymy TX pixli

 for i:=0 to tx-1 do begin

  pom:=pmx+i;

  v2:=SprajtX[crY, pom];

  hlp:=(pom*Pixel) shr 3 + tmul48[crY];

  if prev=___PMG then
   pik:=0
  else
   pik:=form1.locate(tab[hlp], integer(pom));


 if ply5 then begin
// gdy jest 5-y gracz
  for idx:=9 downto 0 do
   case tprior[idx] of
    $80: if piksel(v2 and $01,$80,0) then PixSpr(pom,$000);
    $81: if piksel(v2 and $04,$81,1) then PixSpr(pom,$200);
    $82: if piksel(v2 and $10,$82,2) then PixSpr(pom,$400);
    $83: if piksel(v2 and $40,$83,3) then PixSpr(pom,$600);
    $84: if FEditPMG.GetPrior(crY)=3 then begin      // prior = 8

           if v2 and $55=0 then begin
            if piksel(v2 and $02,$84,4) then PixSpr(pom,$100);
            if piksel(v2 and $08,$84,5) then PixSpr(pom,$300);
            if piksel(v2 and $20,$84,6) then PixSpr(pom,$500);
            if piksel(v2 and $80,$84,7) then PixSpr(pom,$700);
           end;

          end else begin

           if piksel(v2 and $02,$84,4) then PixSpr(pom,$100);
           if piksel(v2 and $08,$84,5) then PixSpr(pom,$300);
           if piksel(v2 and $20,$84,6) then PixSpr(pom,$500);
           if piksel(v2 and $80,$84,7) then PixSpr(pom,$700);
         end;
   end;

 end else begin

// gdy brak 5-go gracza
  for idx:=9 downto 0 do
   case tprior[idx] of
    $80: begin
          if piksel(v2 and $01,$80,0) then PixSpr(pom,$000);
          if piksel(v2 and $02,$80,4) then PixSpr(pom,$100);
         end;
    $81: begin
          if piksel(v2 and $04,$81,1) then PixSpr(pom,$200);
          if piksel(v2 and $08,$81,5) then PixSpr(pom,$300);
         end;
    $82: begin
          if piksel(v2 and $10,$82,2) then PixSpr(pom,$400);
          if piksel(v2 and $20,$82,6) then PixSpr(pom,$500);
         end;
    $83: begin
          if piksel(v2 and $40,$83,3) then PixSpr(pom,$600);
          if piksel(v2 and $80,$83,7) then PixSpr(pom,$700);
         end;
   end;
 end;

 end;
end;

end;

except
// Application.MessageBox('Cos poszlo nie tak','Debug',MB_ICONEXCLAMATION);

end;

end;


procedure BresenhamCircle(const ks,ws: integer; r: byte);
var x,y,mo,og,ou, px: integer;
begin

 y:=0;

 x:=r*factor-factor;

 px:=Pixel*factor;


 if Pixel=4 then
  x:=x shl 1
 else
  x:=x div (2 div Pixel);

 mo:=0;

while x>=y do begin

 Punkt(ks+x , ws+y);
 Punkt(ks-x , ws+y);
 Punkt(ks+x , ws-y);
 Punkt(ks-x , ws-y);
 Punkt(ks+y , ws+x);
 Punkt(ks+y , ws-x);
 Punkt(ks-y , ws+x);
 Punkt(ks-y , ws-x);

 og:=mo + y + y + px;
 ou:=og - x - x + px;

 inc(y);
 mo:=og;

 if abs(ou) < abs(og) then begin
  dec(x);
  mo:=ou;
 end;

end;

end;


procedure putPunkt(x,y: integer; const Solid: Boolean = true);
var p, r: byte;
begin

p:=Pixel;                        // szybszy i krotszy kod dla lokalnej zmiennej

if p<>0 then begin

 if SpecialStr[___doublescan].val then
  y:=((y div factor) and form1.GetScanRatio((y div factor) shr 3))*factor;

 x:=(x div (factor*p))*factor*p;

 r:=PenS;

 if r>1 then begin

  if Solid then
   while r>1 do begin BresenhamCircle(x,y, r); dec(r) end
  else
   BresenhamCircle(x,y, PenS)

 end else
  Punkt(x,y);

 FZoom.Image1.Bitmap.Assign(zomek);

end;

end;



procedure Bresenham(const x1,y1,x2,y2: integer);
var i, deltax, deltay, numpixels,
    d, dinc1, dinc2,
    x, xinc1, xinc2,
    y, yinc1, yinc2 : integer;
begin

  { Calculate deltax and deltay for initialisation }
  deltax := abs(x2 - x1);
  deltay := abs(y2 - y1);

  { Initialize all vars based on which is the independent variable }
  if deltax >= deltay then
    begin

      { x is independent variable }
      numpixels := deltax + 1;
      dinc1 := deltay Shl 1;
      d := dinc1 - deltax;
      dinc2 := (deltay - deltax) shl 1;
      xinc1 := 1;
      xinc2 := 1;
      yinc1 := 0;
      yinc2 := 1;
    end
  else
    begin

      { y is independent variable }
      numpixels := deltay + 1;
      dinc1 := deltax Shl 1;
      d := dinc1 - deltay;
      dinc2 := (deltax - deltay) shl 1;
      xinc1 := 0;
      xinc2 := 1;
      yinc1 := 1;
      yinc2 := 1;
    end;

  { Make sure x and y move in the right directions }
  if x1 > x2 then
    begin
      xinc1 := - xinc1;
      xinc2 := - xinc2;
    end;
  if y1 > y2 then
    begin
      yinc1 := - yinc1;
      yinc2 := - yinc2;
    end;

  { Start drawing at <x1, y1> }
  x := x1;
  y := y1;

  { Draw the pixels }
  for i := 1 to numpixels do
    begin

      putPunkt(x,y, false);

      if d < 0 then
        begin
          d := d + dinc1;
          x := x + xinc1;
          y := y + yinc1;
        end
      else
        begin
          d := d + dinc2;
          x := x + xinc2;
          y := y + yinc2;
        end;
    end;
end;


procedure TFZoom.UstawAct;
var i: byte;
begin

 for i:=7 downto 0 do act_label[i].Color:=clRed;

 for i:=7 downto 0 do
  if act[i]=0 then act_label[i].Color:=clBtnFace;

end;


procedure Show_CharInfo(const y: integer);
var t: String[128];
begin
 t:='Charsets used: ';
 if UseChar then t:=t+IntToStr(zestaw+1) else t:=t+'?';
 FZoom.StatusBar1.Panels[2-1].Text:=t;

 t:='Current charset fill: ';
 if UseChar then t:=t+IntToStr(chFill[table[y shr 3]]) else t:=t+'?';
 FZoom.StatusBar1.Panels[3-1].Text:=t;
end;


procedure image1Reload;
var _Pixel: byte;
    tmpPis: t_pis;
begin

   tmpPis := pisCol;
   _Pixel := Pixel;

   zapisz_parametry_zooma;
   form1.OdswiezObraz;    //odswiez obraz

   Pixel := _Pixel;
   pisCol:= tmpPis;

end;


procedure TFZoom.AddInvers;
var x,y, i: integer;
    v: byte;
begin

              x:=FZoom.lp.x div factor;
              y:=testY(FZoom.lp.y div factor);

              SaveAfterExit:=true;
              Form1.ZapiszUndo;

              case gfxMode[y shr 3] of

                 2: begin
                     i:=x shr 3 + tmul48[y shr 3];

                     if Fox1 and (y and 7>3) then
                      invers2[i]:=invers2[i] xor $80
                     else
                      invers[i]:=invers[i] xor $80;

                    end;

               1,4: begin
                     i:=x shr 3 + tmul48[y and $f8];

                     for v := 7 downto 0 do begin
                      tab[i]:=tab[i] xor $ff;
                      inc(i, 48);
                     end;

                    end;
              end;

              image1Reload;

              StatusBar1.Panels[1-1].Text:=form1.StatusXY(crX,crY, Pixel);

end;


procedure TFZoom.FormKeyPress(Sender: TObject; var Key: Char);
var v: byte;
begin

 if ShiftCtrl then exit;
 

 if key=#27 then form1.Zamknij(f_Zoom);


 if key=#43 then begin
  SetFactor(1);
  GridPosition;
  exit;
 end;

 if key=#45 then begin
  SetFactor(-1);
  GridPosition;
  exit;
 end;


 if not(klik) and (prev=___ALL) then
  case UpCase(Key) of

        '`': begin

              if rbLayerALL.Checked then begin
               rbLayerALL.Checked:=false;
               rbLayerBMP.Checked:=true;
              end else
               if rbLayerBMP.Checked then begin
                rbLayerBMP.Checked:=false;
                rbLayerPMG.Checked:=true;
               end else
                if rbLayerPMG.Checked then begin
                 rbLayerPMG.Checked:=false;
                 rbLayerALL.Checked:=true;
                end;

             end;
  end;


 if prev<>___BMP then begin
  case UpCase(Key) of

   '1'..'8': if not(klik) then begin
              v:=ord(Key); v:=v-ord('1');

              act[v]:=act[v] xor $ff;
              UstawAct;

              image1Reload;
              Grid;

              exit;
             end;
  end;

 end else
       case UpCase(Key) of
        '0'..'9': begin pisCol[0]:=ord(Key)-ord('0'); UstawPisak; exit end;
        'A'..'F': begin piscol[0]:=ord(UpCase(Key))-ord('A')+10; UstawPisak; exit end;
       end;


 if prev<>___PMG then
  case UpCase(Key) of
        ' ': begin
              SaveAfterExit:=true; form1.ZapiszUndo;

              klik:=true;
              putPunkt(lp.x, lp.y);

              klik:=false;
              image1Reload;
             end;

    chr(13): begin
              pisCol[0]:=GetPen;

              UstawPisak;
             end;
  else
    AddInvers                        // kazdy inny klawisz doda inwers
  end;


end;


procedure TFZoom.FormKeyDown(var MousePos: TPoint);
begin

  if KeyMove in [vk_left, vk_right, vk_up, vk_down] then begin

    image1.OnMouseMove(image1,[], MousePos.x, MousePos.y, nil);

    klik:=false;

  end;
      
end;


procedure TFZoom.Image1Click(Sender: TObject);
begin
 if klik then putPunkt(lp.x, lp.y);
end;


procedure Pedzel;
// pokazuje zaznaczenie piksla
var sy, p, tmp, x, y: integer;
    r: TFloatRect;
    w, h: single;
begin

  if prev=___PMG then
   p:=factor shl 1
  else
   p:=Pixel*factor;

{  if FEditPMG.Visible then
   k:=1
  else
   k:=PenS;
}

  r := CursorMarker.location;
  w := r.Right - r.Left;
  h := r.Bottom - r.Top;


  if (FZoom.seBrushWidth.Position > 1) and not(FEditPMG.Visible) then begin

//   FZoom.Shape1.Left := (FZoom.lp.x div p)*p + FZoom.Image1.Left - (FZoom.seBrushWidth.Position * p) shr 1;

   x := (FZoom.lp.x div p)*p {+ FZoom.Image1.Left} - (FZoom.seBrushWidth.Position * p) shr 1;

   sy:=(FZoom.lp.y div factor)*factor {+ FZoom.Image1.Top};

   tmp:=FZoom.seBrushWidth.Position * factor;

   case Pixel of
    1: y := sy - tmp shr 1;
    2: y := sy - tmp;
    4: y := sy - tmp shl 1;
   end;

   CursorMarker.Location := FloatRect (x, y, x+w, y+h);

  end else begin

   x := (FZoom.lp.x div p)*p {+ FZoom.Image1.Left};
   y := (FZoom.lp.y div factor)*factor {+ FZoom.Image1.Top};

   CursorMarker.Location := FloatRect (x, y, x+w, y+h);

  end;

end;


procedure TFZoom.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin

 old_lp:=Point(x,y);

 if Button <> mbMiddle then begin

   klik:=true;

   PrawyPrzycisk:=ord(Button=mbRight);

   SaveAfterExit:=true;
   Form1.ZapiszUndo;

 end else
  moveBMP:=true;

end;


procedure TFZoom.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
// na podstawie pozycji myszki ustawiamy palete kolorow itp.
var v, j, w, nr_pm: byte;
    pisColTmp: array [0..7] of byte;
    bufor: array [0..15] of byte;
    c: string;

const
     tord: array [0..7] of byte = (8,4,7,3,6,2,5,1);

begin

 if FEditPMG.Visible then FZoom.ScrollBox1.SetFocus;         // !!! koniecznie jesli wlaczony EDITPMG


 if ZoomPalette.HitTest(X,Y) then begin PaletteDirect:=not(PaletteDirect); GridPosition end;


 if moveBMP then begin

  ScrollBox1.HorzScrollBar.Position:=ScrollBox1.HorzScrollBar.Position - (X - old_lp.X);
  ScrollBox1.VertScrollBar.Position:=ScrollBox1.VertScrollBar.Position - (Y - old_lp.Y);

  //  GridPosition;

  exit;
 end;



 if KeyMove>0 then begin
//  GetCursorPos(MousePos);

//  MousePos.X:=(MousePos.X div Pixel)*Pixel;
//  MousePos.Y:=(MousePos.Y shr 1) shl 1;

  case KeyMove of
    vk_left: dec(X, Pixel*factor);
   vk_right: inc(X, Pixel*factor);
      vk_up: dec(Y, factor);
    vk_down: inc(Y, factor);
  end;

  KeyMove:=0;

  SetCursorPos(X, Y);
 end;


// jesli pusty wiersz to wyjdz
 crY:=testY(y div factor);


 if FEditPMG.Visible and SpecialStr[___AlignPMG].val then begin
  w:=FEditPMG.get_pmg_size*2;
  if w>0 then x:=(x div (w*factor))*w*factor;
 end;


 lp:=Point(x,y);


 if gfxMode[crY shr 3]=0 then begin
  if prev<>___PMG then KoloryPF.Visible:=false;
  exit;
 end else
  if prev<>___PMG then KoloryPF.Visible:=true;


 Pedzel;


if (x>=0) and (y>=0) then begin

// pozycja kursora z uwzglednieniem proporcji pixla
crX:=(x div factor) div Pixel;

// nowa wartosc Pixel z tablicy gfxMode i modeLine

pisColTmp[Pixel]:=pisCol[0];                    // !!! zapamietamy numer pisaka dla kazdego trybu

Pixel:=gfxMode[crY shr 3];                      // ustawiamy Pixel na podstawie poczatku wiersza

form1.GetPikselMode(testX(X div factor),crY,0); // uaktualniamy informacje z programu rastra

pisCol[0]:=pisColTmp[Pixel];


FEditPMG.GetPlayer5Value(crY,false);       // ustawienie ply5
FEditPMG.GetMLCValue(crY,false);           // ustawienie MLC

SetZoomPisPalette;                         // ustawienie palety kolorow zaleznie od trybu

UstawTabliceKolor(crX,crY);


if (crX<>crXold) or (crY<>crYold) then begin

 StatusBar1.Panels[1-1].Text:=form1.StatusXY(crX,crY, Pixel);

 Show_CharInfo(crY);

 if FEditPMG.Visible then begin
  FEditPMG.frameLineRange1.seRange.Position:=0;
  FEditPMG.frameLineRange1.seLine.Position:=crY;
 end;

//  Set_Pedzel;


  Application.CancelHint;


  fillchar(bufor,16,0);

  v:=0;

  case Pixel of
  1,2: v:=Sprajt[crY, crX div (2 div Pixel)];
    4: v:=Sprajt[crY, (x div factor) shr 1];
  end;


  if v>0 then
   for w:=0 to 7 do if (v and twyt1[w])>0 then bufor[8-w]:=tord[w];

 // skasuj sprity wg tablicy SPR_PANEL [1..8] !!!
  for j:=1 to 8 do begin
   spr_panel[j].BevelInner:=bvNone;
   spr_panel[j].BevelOuter:=bvNone;
//   spr_panel[j].BevelKind:=bkFlat;
   spr_panel[j].BevelWidth:=1;
  end;

  nr_pm:=0;

 // zaznacz panel sprita
  for j:=8 downto 1 do
   if bufor[j]>0 then begin
    spr_panel[bufor[j]].BevelInner:=bvSpace;
    spr_panel[bufor[j]].BevelOuter:=bvSpace;
//    spr_panel[bufor[j]].BevelKind:=bkTile;
    spr_panel[bufor[j]].BevelWidth:=2;

    nr_pm:=j;
   end;

   c:='';

   if nr_pm>0 then
    if nr_pm in [1,3,5,7] then
     c:='P'+IntToStr(nr_pm shr 1)
    else
     c:='M'+IntToStr(nr_pm shr 1-1);

   if prev<>___PMG then begin

    if c<>'' then c:=c+#13#10;

    v:=GetPen;

    if v=0 then
     c:=c+'BAK'
    else
     c:=c+'C'+IntToStr(v);

   end;

   FZoom.Hint:=c;


 with FZoom do begin
// kolory spritow w linii
  for j:=1 to 4 do spr_panel[j].Color:=AtariPal[TabKolor[(j+4) shl 8+crY]];

// kolory pociskow w linii, z uwzglednieniem 5-go gracza
  if not(ply5) then begin
   spr_panel[5].Color:=spr_panel[1].Color;
   spr_panel[6].Color:=spr_panel[2].Color;
   spr_panel[7].Color:=spr_panel[3].Color;
   spr_panel[8].Color:=spr_panel[4].Color;
  end else begin
   spr_panel[5].Color:=AtariPal[TabKolor[$400+crY]];
   spr_panel[6].Color:=spr_panel[5].Color;
   spr_panel[7].Color:=spr_panel[5].Color;
   spr_panel[8].Color:=spr_panel[5].Color;
  end;
 end;

//end;
 crXold:=crX; crYold:=crY;
end;

 if klik then begin
  Bresenham(old_lp.x, old_lp.y, lp.x, lp.y);

  old_lp:=lp;
 end;

end;

end;


procedure TFZoom.Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin

 moveBMP:=false;

 if klik then begin

   klik:=false;

   image1Reload;

//   UstawTabliceKolor(lp.x div factor, testY(lp.y div factor));

   if UseChar then begin
    form1.CharsFill;

    Show_CharInfo(testY(y div factor));
   end;

 end;

end;


procedure TFZoom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// form1.Refresh;

 form1.Zoom.Checked:=false;

 zapisz_parametry_zooma;

 move(act_tmp,act,sizeof(act));

 form1.ZamienGrafike;
end;


procedure TFZoom.FormCreate(Sender: TObject);
var i: integer;

const
    p: array [0..1] of ShortString = ('Player ','Missile ');

begin
 DoubleBuffered:=true;

 Application.HintHidePause:=100000;     //aby Hinty nie znikaly zbyt szybko

// DoubleBuffered:=true;

// w tej kolejnosci nie zepsuje wysokosci !!!
// GaugeHeight:=0
// TrackBarEnabled:=false;

 seZoomFactor.GaugeHeight:=-1;
 seZoomFactor.UpDownOrientation:=udHorizontal;
 seZoomFactor.TrackBarEnabled:=false;

 seBrushWidth.GaugeHeight:=-1;
 seBrushWidth.UpDownOrientation:=udHorizontal;
 seBrushWidth.TrackBarEnabled:=false;

 seGridWidth.GaugeHeight:=-1;
 seGridWidth.UpDownOrientation:=udHorizontal;
 seGridWidth.TrackBarEnabled:=false;

 seGridHeight.GaugeHeight:=-1;
 seGridHeight.TrackBarEnabled:=false;
// seGridHeight.UpDownOrientation:=udHorizontal;


 OldScrollProc:=ScrollBox1.WindowProc;
 ScrollBox1.WindowProc:=ScrollWindowProc;

// GridImage.Picture.Bitmap.PixelFormat:=pf32bit;
// image1.Picture.Bitmap.PixelFormat:=pf32bit;

 GridImage := TBitmapLayer.Create(Image1.Layers);
 GridImage.Scaled := False;
 with GridImage.Bitmap do begin
  BeginUpdate;
  SetSize(384,240);
  OuterColor:=Color32(transCol);
  CombineMode := cmBlend;
  DrawMode := dmTransparent;
  EndUpdate;
 end;
 GridImage.Location := FloatRect(0, 0, 384, 240);


 ZoomPalette := TBitmapLayer.Create(Image1.Layers);
 ZoomPalette.Scaled := False;
 with ZoomPalette.Bitmap do begin
  BeginUpdate;
  SetSize(45,240);
  OuterColor:=Color32(transCol);
  CombineMode := cmBlend;
  DrawMode := dmTransparent;
  EndUpdate;
 end;
 ZoomPalette.Location := FloatRect(0, 0, 45*factor, 240);


 CursorMarker := TBitmapLayer.Create(Image1.Layers);
 CursorMarker.Scaled := False;
 with CursorMarker.Bitmap do begin
  BeginUpdate;
  SetSize(128,128);
  OuterColor:=Color32(transCol);
  CombineMode := cmBlend;
  DrawMode := dmTransparent;
  EndUpdate;
 end;
 CursorMarker.Location := FloatRect(0, 0, 128, 128);


// image1.Layers.MouseEvents:=false;


 {Pisak:=0;} old_Pixel:=$ff;

 for i:=0 to 7 do begin

  with TPanel.Create(self) do begin      // panele PMG
   Width:=25;
   Height:=25;
   Left:=2+i*31+ord(i>3)*8;
   Top:=2;
   Tag:=i+1;
   ShowHint:=true;
   Hint:=p[i shr 2]+IntToStr(i and 3)+' (Press key '''+IntToStr(i+1)+''')';

   Cursor:=5;

   ParentBackground:=false;

   Caption:=IntToStr(Tag);

   BevelInner:=bvNone;
   BevelOuter:=bvNone;
   BevelKind:=bkFlat;
   BorderStyle:=bsNone;

   Parent:=KoloryPMG;
//   Visible:=True;

   OnClick:=PanelPMGClick;
  end;


  with TLabel.Create(self) do begin
   Width:=28;
   Height:=10;
   Left:=i*31+ord(i>3)*8;;
   Top:=30;
   Tag:=i+10;
   ShowHint:=true;
   Hint:=p[i shr 2]+IntToStr(i and 3)+' (Press key '''+IntToStr(i+1)+''')';

   Transparent:=false;

   AutoSize:=false;
   Alignment:=taCenter;
   Color:=clBtnFace;
//   Font.Name:='MS Serif';
   Font.Height:=-9;

   Cursor:=5;

   if i<4 then
    Caption:='P '+IntToStr(i)
   else
    Caption:='M '+IntToStr(i and 3);

   Parent:=KoloryPMG;
//   Visible:=True;

   OnClick:=PanelPMGClick;
  end;

 end;


 for i:=0 to ComponentCount-1 do
  if (Components[i] is TPanel) then
   case Components[i].Tag of
        1..8: begin
               spr_panel[Components[i].Tag]:=TPanel(Components[i]);
               spr_panel[Components[i].Tag].Tag:=Components[i].Tag-1;
              end;
   end
  else if (Components[i] is TLabel) then
   case Components[i].Tag of
    10..17: begin
             act_label[Components[i].Tag-10]:=TLabel(Components[i]);
             act_label[Components[i].Tag-10].Tag:=Components[i].Tag-10;
            end;

  end;

end;


procedure TFZoom.seBrushWidthChange(Sender: TObject);
// PEN SIZE
begin
 PenS:=seBrushWidth.Position;

 Set_Pedzel;

 ScrollBox1.SetFocus;
end;


procedure TFZoom.penq1Click(Sender: TObject);
// 'Q' - zmiana koloru pisaka
begin
 if prev>___PMG then begin
  if pisCol[0]>0 then dec(pisCol[0]);
  UstawPisak;
 end;
end;


procedure TFZoom.penw1Click(Sender: TObject);
// 'W' - zmiana koloru pisaka
begin
 if prev>___PMG then begin
  inc(pisCol[0]);
  UstawPisak;
 end;
end;


procedure TFZoom.getSpr1Click(Sender: TObject);
// 'G' - pobranie parametrow ducha pod ZOOM'em
begin

 if FEditPMG.Visible then FEditPMG.AktualizujSprity;

end;


procedure TFZoom.putSpr1Click(Sender: TObject);
// 'S' - postawienie ducha pod ZOOM'em
var px, py: integer;
begin
 if FEditPMG.Visible then begin

   px:=(lp.x div factor) div Pixel;

   py:=testY(lp.y div factor);

   FEditPMG.SetPosSprite((px*Pixel){-CzarnyPas},py);
   FEditPMG.frameLineRange1.seRange.Position:=0;
   FEditPMG.frameLineRange1.seLine.Position:=py;

   zapisz_parametry_zooma;

   Form1.ZapiszUndo;
   FEditPMG.ChangeButton;

   SaveAfterExit:=true;

   image1Reload;
   Grid;
 end;
end;


procedure TFZoom.oldCol1Click(Sender: TObject);
// TAB
begin

 frameAtariPalette1.SwapColors;
 
end;


procedure TFZoom.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
 SetFactor(WheelDelta);
 GridPosition;

 Handled:=true;
end;


procedure TFZoom.FormResize(Sender: TObject);
begin
 SetFactor(0);

 Grid;
end;


procedure TFZoom.FormShow(Sender: TObject);
begin
 ScrollBox1.SetFocus;

 CursorMarker.Visible:=aMarker.Checked;

 frameAtariPalette1.UstawPalete;

end;


procedure TFZoom.frameAtariPalette1PenColorsClick(Sender: TObject);
begin

  frameAtariPalette1.PenColorsClick(Sender);

end;


procedure TFZoom.PanelPMGClick(Sender: TObject);
begin
 act[TForm(Sender).Tag]:=act[TForm(Sender).Tag] xor $ff;
 UstawAct;

 image1Reload;
 Grid;
end;


procedure TFZoom.aColorsExecute(Sender: TObject);
begin
 ini_zom.p:=aColors.Checked;

 ZoomPalette.Visible:=ini_zom.p;

 GridPosition;
end;


procedure TFZoom.aGridExecute(Sender: TObject);
// Grid ON/OFF
begin

 if aGrid.Checked then begin
  FZoom.Grid;
  FZoom.GridImage.Visible:=true;
 end else
  FZoom.GridImage.Visible:=false;

end;


procedure TFZoom.aMarkerExecute(Sender: TObject);
begin
 CursorMarker.Visible:=aMarker.Checked;
end;


procedure SetPreview;
begin
 zapisz_parametry_zooma;

 form1.SelectPreview.ItemIndex:=ord(prev);

 image1Reload;

 FZoom.ScrollBox1.SetFocus;
end;

procedure TFZoom.rbPreviewPMGClick(Sender: TObject);
begin
 prev:=___PMG;
 SetPreview;
end;

procedure TFZoom.rbPreviewBMPClick(Sender: TObject);
begin
 prev:=___BMP;
 SetPreview;
end;

procedure TFZoom.rbPreviewALLClick(Sender: TObject);
begin
 prev:=___ALL;
 SetPreview;
end;


end.

