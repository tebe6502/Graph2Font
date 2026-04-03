unit ImportBMP;

interface

uses
  Windows, SysUtils, Graphics, Controls, Forms, StdCtrls, ExtCtrls, Menus, Classes;

type
  TFImportBMP = class(TForm)
    Panel2: TPanel;
    Image5: TImage;
    SmartColors: TCheckBox;
    CountColors: TCheckBox;
    FifthColors: TCheckBox;
    AutoresizeBMP1: TCheckBox;
    Dither: TCheckBox;
    DitherMatrix: TComboBox;
    PopupMenu2: TPopupMenu;
    Selectall1: TMenuItem;
    Unselectall1: TMenuItem;
    Invertselection1: TMenuItem;
    Grayscale: TCheckBox;
    procedure DitherClick(Sender: TObject);
    procedure AutoresizeBMP1Click(Sender: TObject);
    procedure FifthColorsClick(Sender: TObject);
    procedure SmartColorsClick(Sender: TObject);
    procedure Unselectall1Click(Sender: TObject);
    procedure ZaznaczKoloryBMP;
    procedure Image5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Invertselection1Click(Sender: TObject);
    procedure Image5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DitherMatrixChange(Sender: TObject);
    procedure ShowImportPalette(var bitmap: TBitmap; const iC: byte);


  private
    { Private declarations }
    SelectColor: integer;

  const
    skp = 68; 

  public
    { Public declarations }
  end;

var
  FImportBMP: TFImportBMP;

  box_combo: array [0..15] of TComboBox;
  selCol: array [0..15] of Boolean;


implementation

uses Main; 

{$R *.dfm}


procedure TFImportBMP.ShowImportPalette(var bitmap: TBitmap; const iC: byte);
var P: PByteArray;
    i: integer;
    pl: TColor;
    bmp: TBitmap;
begin

 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(image5.Width, image5.Height);

 form1.ClrRect(bmp);

 P:=bitmap.ScanLine[0];

 for i:=0 to iC-1 do begin
//zapisze RGB do tablicy
  P[0]:=palBmp[i]; pl:=bitmap.Canvas.Pixels[0,0];

  with bmp.Canvas do begin
   Pen.Color:=0;
   Brush.Color:=pl;
   Rectangle(i*skp,0,i*skp+skp-2,20);
  end;

 end;

 image5.Picture.Graphic:=bmp;

 bmp.Free;
end;


procedure TFImportBMP.AutoresizeBMP1Click(Sender: TObject);
// RESIZE, SORT COLORS, GRAYSCALE
begin
 SaveAfterExit:=false;
 form1.PreviewButton;
end;


procedure TFImportBMP.ZaznaczKoloryBMP;
var i, j, x: integer;
begin

j:=0;

  for x:=0 to 15 do begin

   i:=box_combo[x].Tag;
   box_combo[x].Enabled:=selCol[i];

   if selCol[i] then begin

    if (j<(4+ord(FifthColors.Checked))) and (SmartColors.Checked) then
     box_combo[x].Color:=clLime
    else
     box_combo[x].Color:=clWindow;

   inc(j);

   if (temp[i]>0) and (SmartColors.Checked) then box_combo[x].Color:=clRed;

   end else
    box_combo[x].Color:=clGradientInactiveCaption;

  end;
end;


procedure InvertSelection;
var i: integer;
begin

 fillchar(temp,sizeof(temp),0);

 for i:=0 to 15 do selCol[i]:=not(selCol[i]);

 FImportBMP.ZaznaczKoloryBMP;

 form1.ClickPreviewBMP;
end;


procedure UnselectAll;
begin
 fillchar(temp,sizeof(temp),0);
 fillchar(selCol,sizeof(selCol),false);
 FImportBMP.ZaznaczKoloryBMP;

 form1.ClickPreviewBMP;
end;


procedure SelectAll;
begin
 fillchar(selCol,sizeof(selCol),true);
 fillchar(temp,sizeof(temp),0);
 FImportBMP.ZaznaczKoloryBMP;

 form1.ClickPreviewBMP;
end;


procedure TFImportBMP.DitherClick(Sender: TObject);
// DITHER
var i: byte;
begin

 if Dither.Checked then begin

  SmartColors.Checked:=false;

  Image5.Cursor:=crHandPoint;
  DitherMatrix.Enabled:=true;

  fillchar(selCol, sizeof(selCol), false);
  for i:=0 to 3+ord(FifthColors.Checked) do selCol[i]:=true;

 end else begin
  Image5.Cursor:=crDefault;
  DitherMatrix.Enabled:=false;

  SelectALL;
 end;

 ZaznaczKoloryBMP;

 form1.ClickPreviewBMP;

end;


procedure TFImportBMP.DitherMatrixChange(Sender: TObject);
begin
 DitherClick(self);
end;


procedure TFImportBMP.FifthColorsClick(Sender: TObject);
// 5th COLORS
var i: byte;
begin

 if Dither.Checked then begin

  SmartColors.Checked:=false;

  Image5.Cursor:=crHandPoint;
  DitherMatrix.Enabled:=true;

  if FifthColors.Checked then begin

   for i:=0 to 15 do
    if not(selCol[i]) then begin selCol[i]:=true; Break end;

  end else begin

   for i:=15 downto 0 do
    if selCol[i] then begin selCol[i]:=false; Break end;

  end;

 end;

 ZaznaczKoloryBMP;

 SaveAfterExit:=false;

 form1.PreviewButton;
 form1.ClickPreviewBMP;

end;


procedure MaksVal(const o: byte);
// zmiana koloru przy odczycie BMP'y
var a: integer;
begin

 a:=box_combo[o].ItemIndex;

 if Pixel=1 then begin dec(a,2); a:=a xor 1; end;

 if a<0 then a:=0;

 case Pixel of
  1: if a>1 then a:=1;           //2 kolory
  2: if a>4 then a:=4;           //5 kolorow
  4: if a>15 then a:=15;         //16 odcieni szarosci
 end;

 newPal[o]:=a;

 if Pixel=1 then begin a:=a xor 1; inc(a,2); end;

 box_combo[o].ItemIndex:=a;
end;









procedure TFImportBMP.ComboBoxChange(Sender: TObject);
// wybranie ComboBox-a z rejestrem koloru  - LOAD BMP
begin

  MaksVal(TComboBox(Sender).Tag);
  form1.ClickPreviewBMP;

end;


procedure TFImportBMP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FImportBMP', top, left);
 form1.Shape3_4Enable(false);

 SaveAfterExit:=true;
end;


procedure TFImportBMP.FormCreate(Sender: TObject);
var x: integer;
begin
 image5.Picture.Bitmap.PixelFormat:=pf32bit;

// init tablicy z ComboBox'ami
 for x:=0 to 15 do
  with TComboBox.Create(self) do begin
   Width:=skp-2;
   Height:=18;
   Left:=2+x*skp;
   Top:=26;
   Tag:=x+1;

//   Style:=csDropDownList;           !!! nie widac zmiany koloru ComboBox-a !!!

   Parent:=panel2;
  
   Items.Add('COLBAK');
   Items.Add('COLOR0');
   Items.Add('COLOR1');
   Items.Add('COLOR2');
   Items.Add('COLOR3');

//   Style:=csSimple;
   Visible:=True;
   OnChange:=ComboBoxChange; // dodaj tê liniê
  end;

 for x:=0 to ComponentCount-1 do
  if (Components[x] is TComboBox) then
   if Components[x].Tag in [1..16] then begin
    box_combo[Components[x].Tag-1]:=TComboBox(Components[x]);
    box_combo[Components[x].Tag-1].Tag:=Components[x].Tag-1;
   end;

end;


procedure TFImportBMP.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then form1.Zamknij(f_ImportBMP);
end;


procedure TFImportBMP.Image5Click(Sender: TObject);
var i, x: byte;
begin

 if Dither.Checked then begin

  selCol[SelectColor]:=not(selCol[SelectColor]);

  x:=0;
  for i:=0 to 15 do
   if selCol[i] then inc(x);

  if x>4+ord(FifthColors.Checked) then
   selCol[SelectColor]:=false;

  ZaznaczKoloryBMP;

  form1.ClickPreviewBMP;

 end else
 if SmartColors.Checked then begin

  selCol[SelectColor]:=not(selCol[SelectColor]);
  ZaznaczKoloryBMP;

  form1.ClickPreviewBMP;
 end;

end;


procedure TFImportBMP.Image5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 if (Button=mbRight) and SmartColors.Checked then begin
  PopupMenu2.Popup(x+image5.Left+FImportBMP.Left, y+FImportBMP.Top+SmartColors.Top);
 end;

end;


procedure TFImportBMP.Image5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 SelectColor:=x div skp;
end;


procedure TFImportBMP.SmartColorsClick(Sender: TObject);
// SMART COLORS
begin

  if SmartColors.Checked then begin
   Dither.Checked:=false;
   
   Image5.Cursor:=crHandPoint;
  end else begin
   Image5.Cursor:=crDefault;

   SelectAll;
  end;

  SaveAfterExit:=false;

  form1.PreviewButton;
  form1.ClickPreviewBMP;

end;


procedure TFImportBMP.Selectall1Click(Sender: TObject);
begin
 SelectAll;
end;

procedure TFImportBMP.Unselectall1Click(Sender: TObject);
begin
 UnselectAll;
end;

procedure TFImportBMP.Invertselection1Click(Sender: TObject);
begin
 InvertSelection;
end;


end.
