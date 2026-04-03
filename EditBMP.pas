unit EditBMP;

interface

uses
  Windows, SysUtils, Graphics, Controls, Forms, StdCtrls, Buttons, ExtCtrls,
  ImgList, Classes, Dialogs, ToolWin, AtariPalette, TB2Item, SpTBXItem, ComCtrls,
  System.ImageList;

type
  TFEditBMP = class(TForm)
    ImageList2: TImageList;
    Panel3: TPanel;
    Bevel8: TBevel;
    Image7: TImage;
    ToolBar2: TToolBar;
    ToolSelect: TToolButton;
    ToolDraw: TToolButton;
    ToolElipse: TToolButton;
    ToolRect: TToolButton;
    ToolDropper: TToolButton;
    ToolRRect: TToolButton;
    ToolFill: TToolButton;
    ToolSpray: TToolButton;
    ToolLines: TToolButton;
    ToolLine: TToolButton;
    ToolFShape: TToolButton;
    ToolText: TToolButton;
    FontDialog1: TFontDialog;
    Memo1: TMemo;
    ToolBezierLine: TToolButton;
    ToolRColor: TToolButton;
    AutoDLI: TCheckBox;
    frameAtariPalette1: TframeAtariPalette;
    ToolAtariText: TToolButton;
    OpenDialog1: TOpenDialog;
    SpTBXStatusBar1: TSpTBXStatusBar;
    EditBMPStatus: TSpTBXLabelItem;
    SpTBXLabelItem2: TSpTBXLabelItem;
    procedure ToolSelectClick(Sender: TObject);
    procedure ClrDraw(const a: Boolean);
    procedure SelectMode;
    procedure Image7Click(Sender: TObject);
    procedure Image7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image8DblClick(Sender: TObject);
    procedure AutoDLIClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);

  private
    { Private declarations }
  selPix, wspCol, wsp: TPoint;

  public
    { Public declarations }
  end;

var
  FEditBMP: TFEditBMP;


implementation

{$R *.dfm}

uses Main, SelectColor;


procedure PokazBoxy(var bmp: TBitmap);
begin
 with bmp.Canvas do begin
  Pen.Color:=0; Brush.Color:=clBtnFace;
  Rectangle(2,3,52,13);

  Pen.Color:=0; Brush.Color:=clBtnShadow;
  Rectangle(2,19,52,29);

  Pen.Color:=clBtnShadow; Brush.Color:=clBtnShadow;
  Rectangle(2,35,52,45);
 end;
end;


procedure PokazLine(var bmp: TBitmap);
begin
 with bmp.Canvas do begin
  Brush.Color:=0;

  FillRect(Rect(2,6,52,7));

  FillRect(Rect(2,17,52,19));

  FillRect(Rect(2,28,52,32));

  FillRect(Rect(2,38,52,46));
 end;
end;



procedure TFEditBMP.Image7Click(Sender: TObject);
begin

 case drawMode of
                       Rec, Elipse, RRec: selMod[1]:=selPix.Y shr 4;
  RColor, FDraw, Line, Lines, BezierLine: selMod[0]:=selPix.Y div 12;
 end;

 SelectMode;
 ClrDraw(true);

end;


procedure TFEditBMP.Image7MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 selPix:=Point(x,y);
end;


procedure TFEditBMP.Image8DblClick(Sender: TObject);
var i, t,l: integer;
    c: string;
begin

 wspCol:=wsp;

 if AutoDLI.Checked then
 if wspCol.Y div 17=0 then begin

//  Image8Click(Sender);

  i:=pisCol[0];

  if not(FSelectColor.Visible) then begin

   form1.SetFormPos('FSelectColor', t, l);
   FSelectColor.Top:=t;
   FSelectColor.Left:=l;

  end;

  case i of
   0: c:='COLBAK';
  else
   c:='COLOR'+IntToStr(i-1)
  end;

  FSelectColor.Caption:='Select '+c;
  FSelectColor.Visible:=true;

  FSelectColor.initKolor(AtariPal[palCol[0]]);

  Ofset:=i shl 8;
  AktywnyKolor:=i;

 end else
  form1.Zamknij(f_SelectColor);

end;


procedure LiczTekst;
var i, a, w: integer;
    t: string;
begin

 TekstWidth:=0;
 TekstHeight:=0;

 if drawMode=Tekst then begin

   draw.Canvas.Font:=FEditBMP.FontDialog1.Font;

   for i := 0 to FEditBMP.Memo1.Lines.Count-1 do begin
    inc(TekstHeight, draw.Canvas.TextHeight(FEditBMP.Memo1.Lines.Strings[i]));

    a:=draw.Canvas.TextWidth(FEditBMP.Memo1.Lines.Strings[i])*Pixel;
    if a>TekstWidth then TekstWidth:=a;

   end;

 end else begin

   for i := 0 to FEditBMP.Memo1.Lines.Count-1 do begin

    case Pixel of
     1: inc(TekstHeight, 8);
     2: inc(TekstHeight, 16);
     4: inc(TekstHeight, 32);
    end;

    t:=FEditBMP.Memo1.Lines.Strings[i];

    w:=0;
    for a := 1 to length(t) do
     case Pixel of
      1: inc(w, 8);
      2: inc(w, 16);
      4: inc(w, 32);
     end;

    if w>TekstWidth then TekstWidth:=w;

   end;

 end;


end;


procedure TFEditBMP.Memo1Change(Sender: TObject);
begin
 LiczTekst;
end;


procedure TFEditBMP.SelectMode;
// zaznaczanie nowo wybranej grubosci linii
// albo nowego trybu rysowania dla Circle, Box itp.
var i,j,x,y: integer;
    K: PByteArray;
    bmp: TBitmap;
begin

 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(image7.Width, image7.Height);

 form1.ClrRect(bmp);

 y:=0; i:=0;

 case drawMode of
                       Rec, Elipse, RRec: begin PokazBoxy(bmp); y:=16; i:=selMod[1] end;
  RColor, FDraw, Line, Lines, BezierLine: begin PokazLine(bmp); y:=12; i:=selMod[0] end;
 end;

 if y>0 then
  for j:=i*y to i*y+y-1 do begin
    K := bmp.ScanLine[j];
    for x := 0 to bmp.Width shl 2 - 1 do K[x] := 255 - K[x];
  end;

 image7.Picture.Graphic:=bmp;

 bmp.Free;

end;


procedure TFEditBMP.AutoDLIClick(Sender: TObject);
begin

 if AutoDli.Checked then begin
  wsp:=wspCol;
  Image8DblClick(self);
 end else begin
  form1.Zamknij(f_SelectColor);
  form1.PobierzPalete(0,0);
  frameAtariPalette1.UstawPalete;
 end;

end;


procedure TFEditBMP.ClrDraw(const a: Boolean);
var i: integer;
    pc, bc: TColor;
begin
 i:=draw.Width;

 pc:=AtariPal[palCol[0 xor PrawyPrzycisk]]; bc:=transCol;

 case selMod[1] of
//  0: begin pc:=AtariPal[palCol[0]]; bc:=transCol end;
  1: begin pc:=AtariPal[palCol[0 xor PrawyPrzycisk]]; bc:=AtariPal[palCol[1 xor PrawyPrzycisk]] end;
  2: begin pc:=AtariPal[palCol[0 xor PrawyPrzycisk]]; bc:=pc end;
 end;

 with draw.canvas do begin

  if a then begin
//   Pen.Style := psSolid; Brush.Style := bsSolid; Pen.Width:=1;
//   Pen.Color:=transCol;
   Brush.Color:=transCol;
   FillRect(Rect(0,0, i, Wysokosc));
//   Rectangle(0,0,i,Wysokosc);
  end;

  Pen.Width:=selMod[0]+1;
  Pen.Color:=pc; Brush.Color:=bc;
 end;
end;


procedure SetMemo(const v: Boolean);
begin

 FEditBMP.Memo1.Visible:=v;

 if v then
  FEditBMP.Height:=FEditBMP.Memo1.Top+FEditBMP.Memo1.Height+FEditBMP.SpTBXStatusBar1.Height+GetSystemMetrics(SM_CYSIZEFRAME)+GetSystemMetrics(SM_CYEDGE)*2
 else
  FEditBMP.Height:=FEditBMP.Memo1.Top+FEditBMP.SpTBXStatusBar1.Height+GetSystemMetrics(SM_CYSIZEFRAME)+GetSystemMetrics(SM_CYEDGE)*2;

end;


procedure TFEditBMP.ToolSelectClick(Sender: TObject);
var i, f: integer;
    mPos: TPoint;
begin

 drawMode:=tdrawMode(TComponent(Sender).Tag-39);
 oldBmpTool:=drawMode;

 ToolSelect.Down:=false;
 ToolDraw.Down:=false;
 ToolFill.Down:=false;
 ToolSpray.Down:=false;
 ToolRect.Down:=false;
 ToolLines.Down:=false;
 ToolLine.Down:=false;
 ToolDropper.Down:=false;
 ToolRRect.Down:=false;
 ToolFShape.Down:=false;
 ToolText.Down:=false;
 ToolBezierLine.Down:=false;
 ToolRColor.Down:=false;
 ToolElipse.Down:=false;
 ToolAtariText.Down:=false;

 ToolSelect.Marked:=false;
 ToolDraw.Marked:=false;
 ToolFill.Marked:=false;
 ToolSpray.Marked:=false;
 ToolRect.Marked:=false;
 ToolLines.Marked:=false;
 ToolLine.Marked:=false;
 ToolDropper.Marked:=false;
 ToolRRect.Marked:=false;
 ToolFShape.Marked:=false;
 ToolText.Marked:=false;
 ToolBezierLine.Marked:=false;
 ToolRColor.Marked:=false;
 ToolElipse.Marked:=false;
 ToolAtariText.Marked:=false;

 TToolButton(Sender).Marked:=true;
 TToolButton(Sender).Down:=true;

 if (drawMode in [Select,SelectAlign,Tekst,TekstAtari]) or (drawMode<>drawMode_old) then begin

 SetMemo(false);

 drawMode_old:=drawMode; BlokujDraw:=false;

 SelectMode;

 if not(drawMode in [Select, SelectAlign, FShape]) then ToolFShape.Enabled:=false;

  i:=-2;
  case drawMode of

   FDraw: begin i:=12; EditBMPStatus.Caption:=tInfo[ord(FDraw)] end;

    Select, SelectAlign:
       begin
        form1.Select_OFF(false);

        EditBMPStatus.Caption:=tInfo[ord(select)];        

        ClrDraw(true);
        form1.Shape1.Visible:=true;
        form1.Shape1.Enabled:=false;             //true;
        form1.Shape1.Cursor:=crHandPoint;
        form1.PutDraw(0,0);

        pDraw:=Point(CzarnyPas shr 1,0);
        pMark:=Point(CzarnyPas,0);
        lMark:=Point(CzarnyPas+Szerokosc,Wysokosc);

        i:=9;
       end;

  Line, Lines: begin i:=6; EditBMPStatus.Caption:=tInfo[ord(line)] end;
   BezierLine: begin i:=6; EditBMPStatus.Caption:=tInfo[ord(BezierLine)] end;

    Rec, RRec: begin i:=7; EditBMPStatus.Caption:=tInfo[ord(rec)] end;
       Elipse: begin i:=8; EditBMPStatus.Caption:=tInfo[ord(Elipse)] end;
       RColor: begin i:=11; EditBMPStatus.Caption:=tInfo[ord(rColor)] end;
      Dropper: begin i:=1; EditBMPStatus.Caption:=tInfo[ord(Dropper)] end;

 Fill, FShape: begin i:=10; EditBMPStatus.Caption:=tInfo[ord(Fill)] end;
        Spray: begin i:=4; EditBMPStatus.Caption:=tInfo[ord(Spray)] end;

        Tekst: begin
                EditBMPStatus.Caption:=tInfo[ord(tekst)];

                form1.Select_OFF(false);

                if FontDialog1.Execute then begin
                 SetMemo(true);
                 i:=13;

                 Memo1.Font:=FontDialog1.Font;
                 
                 LiczTekst;
                 form1.Select_OFF(true);
                end;

               end;

   TekstAtari: begin
                EditBMPStatus.Caption:=tInfo[ord(tekst)];

                OpenDialog1.InitialDir := ExtractFileDir(charset_path);
                OpenDialog1.FileName   := ExtractFileName(charset_path);

                form1.Select_OFF(false);

                if OpenDialog1.Execute then begin
                 f:=FileOpen(OpenDialog1.FileName, fmOpenRead);
                 FileRead(f, EditBmpFnt, 1024);
                 FileClose(f);

                 charset_path:=OpenDialog1.FileName;

                 SetMemo(true);
                 i:=13;

                 LiczTekst;
                 form1.Select_OFF(true);
                end;

               end;

//  else
//    form1.Select_OFF(false);
  end;


  if not(drawMode in [Select,SelectAlign,Tekst,TekstAtari]) then begin
   form1.PutDraw(0,0);
   form1.Select_OFF(false);
  end;

  //form1.image4.Cursor:=i;

  clrDraw(true);

  GetCursorPos(mPos);
  SetCursorPos(mPos.x, mPos.y);

 end;

end;


procedure TFEditBMP.FormClose(Sender: TObject; var Action: TCloseAction);
begin

 form1.NewFormPos('FEditBMP', top, left);

 AutoDLI.Checked:=false;

 form1.image4.Visible:=false;

 form1.tbShowChars.Down:=false;

 if oldGfx_use then begin
  move(old_GfxMode,gfxMode,sizeof(gfxModE));
  oldGfx_use:=false;

  form1.image2.Enabled:=true;
  form1.image3.Enabled:=true;

  form1.ustawMemo; form1.showMIC;
 end;

 form1.zamknij(f_EditPMG);
 form1.Zamknij(f_SelectColor);

 form1.SelectScreen.Enabled:=true;
// form1.SelectPixel.Enabled:=true;

 form1.EditBitmap.Checked:=false;

 form1.Shape1.Pen.Style:=psSolid;
 form1.Shape1.Enabled:=false;

 form1.Shape1.Height:=0;
 form1.Shape1.Width:=2;

 form1.InitShape3_4;

// form1.Shape1.Visible:=false;
// form1.Shape2.Visible:=false;

 form1.DisableDrawMode;

 form1.SelectPreview.ItemIndex:=2;    // ALL

 form1.Usun_Zaznaczenia(false);

 form1.MenuOptions.Enabled:=true;
 form1.MenuScreen.Enabled:=true;

end;


procedure TFEditBMP.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(Key)=27 then form1.Zamknij(f_EditBMP);

 if not(FEditBMP.Memo1.Visible) then form1.FormKeyPress(Sender, Key);

end;


procedure TFEditBMP.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 if key=vk_control then begin
  form1.SetFocus;

 end else

 if not(FEditBMP.Memo1.Visible) then begin

  if Shift=[] then
  case Key of
   ord('S'), ord('s'): ToolSelectClick(FEditBMP.ToolSelect);
   ord('E'), ord('e'): ToolSelectClick(FEditBMP.ToolElipse);
   ord('R'), ord('r'): ToolSelectClick(FEditBMP.ToolRect);
   ord('D'), ord('d'): ToolSelectClick(FEditBMP.ToolDraw);
   ord('F'), ord('f'): ToolSelectClick(FEditBMP.ToolFill);
   ord('T'), ord('t'): ToolSelectClick(FEditBMP.ToolText);
   ord('L'), ord('l'): ToolSelectClick(FEditBMP.ToolLine);
  end;

  form1.SetFocus;
 end;

end;


procedure TFEditBMP.FormShow(Sender: TObject);
begin

 form1.MenuOptions.Enabled:=false;
 form1.MenuScreen.Enabled:=false;
 
 SetMemo(False);

 case oldBmpTool of
//         FDraw: ToolSelectClick(FEditBMP.ToolDraw);
//        Circle: ToolSelectClick(FEditBMP.ToolCircle);
    BezierLine: ToolSelectClick(FEditBMP.ToolBezierLine);
//        Select: ToolSelectClick(FEditBMP.ToolSelect);
//   SelectAlign: ToolSelectClick(FEditBMP.ToolSelectAlign);
        Elipse: ToolSelectClick(FEditBMP.ToolElipse);
           Rec: ToolSelectClick(FEditBMP.ToolRect);
          RRec: ToolSelectClick(FEditBMP.ToolRRect);
          Fill: ToolSelectClick(FEditBMP.ToolFill);
//         Tekst: ToolSelectClick(FEditBMP.ToolText);
          Line: ToolSelectClick(FEditBMP.ToolLine);
         Lines: ToolSelectClick(FEditBMP.ToolLines);
       Dropper: ToolSelectClick(FEditBMP.ToolDropper);
        FShape: ToolSelectClick(FEditBMP.ToolFShape);
        RColor: ToolSelectClick(FEditBMP.ToolRColor);
         Spray: ToolSelectClick(FEditBMP.ToolSpray);
 else
  ToolSelectClick(FEditBMP.ToolDraw);
 end;

 SelectMode;

 frameAtariPalette1.UstawPalete;
end;


procedure TFEditBMP.FormCreate(Sender: TObject);
begin
 doublebuffered:=true;

// image7.Picture.Bitmap.PixelFormat:=pf32bit;
end;

end.
