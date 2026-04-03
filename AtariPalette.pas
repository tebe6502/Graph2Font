unit AtariPalette;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, TB2Item,
  SpTBXItem, TB2Dock, TB2Toolbar, System.Types;

type
  TframeAtariPalette = class(TFrame)
    Image1: TImage;
    PenColors: TImage;
    SpTBXToolbar1: TSpTBXToolbar;
    SpTBXLabelItem1: TSpTBXLabelItem;
    fTool: TSpTBXSubmenuItem;
    SpTBXToolPalette1: TSpTBXToolPalette;
    procedure PenColorsClick(Sender: TObject);
    procedure PenColorsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure UstawPalete;
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure SwapColors;
    procedure PenColorsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PenColorsContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure SpTBXToolPalette1CellClick(Sender: TObject; ACol, ARow: Integer; var Allow: Boolean);
  private
    { Private declarations }
   wsp, wspCol, pwsp: TPoint;

   mButton: byte;

  public
    { Public declarations }
  end;

implementation

uses Main;

{$R *.dfm}


procedure TframeAtariPalette.UstawPalete;
var i, j: integer;
begin

 with PenColors.Canvas do begin
  brush.Style:=bsSolid;

  brush.Color:=clBtnFace;
  FillRect(REct(0,0,PenColors.Width,PenColors.Height));

  j:=2;
  case Pixel of
   2: j:=4+1;
   4: if t_gtia(form1.SelectGTIA.ItemIndex)=gr10 then
       j:=9
      else
       j:=16;
  end;

//   PenShapes.Visible:=false;
//   PenColors.Top:=14;

  if pisCol[0]>j-1 then pisCol[0]:=j-1;

  palCol[0]:=palCol[pisCol[0]+2];

  pen.Color:=0; brush.Color:=clBtnFace;
  rectangle(pisCol[0]*16,0,pisCol[0]*16+15+2,17);

  for i:=0 to j-1 do begin
   pen.Color:=0; brush.Color:=AtariPal[palCol[i+2]];
   rectangle(2+i*16,2,2+i*16+15-2,17-2);
  end;

  pen.Color:=0; brush.Color:=clWhite;
  rectangle(pisCol[1]*16+6,6,pisCol[1]*16+15+2-6,17-6);

  PenColors.Width:=j*16+2;
 end;

// arrow's

 with Image1.Canvas do begin
  Pen.Color:=clBtnFace; Brush.Color:=clBtnFace;
  rectangle(0,0,Image1.Width,Image1.Height);

  Pen.Color:=0;
  for i := 0 to 6 do begin
   MoveTo(31,6); LineTo(34,6-3+i);
   MoveTo(37,12); LineTo(34+i,9);
  end;

  MoveTo(31,6); LineTo(37,6);
  MoveTo(37,12); LineTo(37,6);

  Pen.Color:=clBtnShadow;
  MoveTo(31+3,6+1); LineTo(37,6+1);
  MoveTo(37-1,12-3); LineTo(37-1,6);

// primary, secondary colors

  Pen.Color:=0; Brush.Color:=clWhite;
  rectangle(16,16,16+28,16+28);
  Pen.Color:=AtariPal[palCol[1]]; Brush.Color:=Pen.Color;
  rectangle(16+2,16+2,16+26,16+26);

  Pen.Color:=0; Brush.Color:=clWhite;
  rectangle(0,0,28,28);
  Pen.Color:=AtariPal[palCol[0]]; Brush.Color:=Pen.Color;
  rectangle(2,2,26,26);
 end;

end;


procedure TframeAtariPalette.SpTBXToolPalette1CellClick(Sender: TObject; ACol, ARow: Integer; var Allow: Boolean);
begin
 pisPat := ACol + ARow * SpTBXToolPalette1.ColCount;

 if pisPat=0 then begin
   fTool.Caption:='Solid Color';
   fTool.ImageIndex:=-1;
 end else begin
   fTool.Caption:='';
   fTool.ImageIndex:=pisPat;
 end;

end;


procedure TframeAtariPalette.SwapColors;
var a: byte;
begin

  a:=palCol[0];
  palCol[0]:=palCol[1];
  palCol[1]:=a;

  a:=pisCol[0];
  pisCol[0]:=pisCol[1];
  pisCol[1]:=a;

  UstawPalete;

end;


procedure TframeAtariPalette.Image1Click(Sender: TObject);
// SWAP PEN COLORS
begin

 if PtInRect(Rect(28,0,44,15), pwsp) then SwapColors;
 
end;


procedure TframeAtariPalette.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var a: string;
begin

 pwsp:=Point(x,y);

 a:='';

 if PtInRect(Rect(0,0,28,28), pwsp) then a:='Primary' else
  if PtInRect(Rect(16,16,44,44), pwsp) then a:='Secondary' else
   if PtInRect(Rect(28,0,44,15), pwsp) then a:='Swap colors';

 if a<>Image1.Hint then begin
  Application.CancelHint;
  Image1.Hint:=a;
 end;

end;


procedure TframeAtariPalette.PenColorsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
 PenColorsClick(Sender);
end;


procedure TframeAtariPalette.PenColorsClick(Sender: TObject);
var i: byte;
    gat: Boolean;
begin

  wspCol:=wsp;

  i:=wspCol.X shr 4; gat:=false;

  case Pixel of
   1: gat := (i<2);
   2: gat := (i<5);
   4: if t_gtia(form1.SelectGTIA.ItemIndex)=gr10 then
       gat := (i<9)
      else
       gat := (i<16);
  end;

  if gat then begin
   palCol[mButton]:=palCol[i+2];
   pisCol[mButton]:=i;

   UstawPalete;
  end;

end;


procedure TframeAtariPalette.PenColorsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

 if Button=mbRight then
  mButton:=1
 else
  mButton:=0;

end;


procedure TframeAtariPalette.PenColorsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 wsp:=Point(x,y);
end;


end.
