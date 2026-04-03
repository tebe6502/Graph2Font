unit PaletteOptions;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls,
  BMDSpinEdit, ExtCtrls, SysUtils;

type
  TFPaletteOptions = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    UseExternal: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit5: TEdit;
    Panel1: TPanel;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure UseExternalClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PokazPalete(const p: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure movePal;
    procedure LoadPal(const nam: string);
    procedure Palette_Format(const black, white, colors: integer);
    procedure Edit5ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);

  private
    { Private declarations }
  palBuf: array [0..767] of byte;

type
  palt = array [0..767] of record
          r: byte;
          g: byte;
          b: byte;
         end;
  
  public
    { Public declarations }
  end;


var
  FPaletteOptions: TFPaletteOptions;
  old_palette_path: string;

  tspin: array [0..3] of TBMDSpinEdit;

implementation

uses Main;

{$R *.dfm}


function CLIP_VAR(x:integer): byte;
begin
 if x>255 then x:=$ff else if x<0 then x:=0;
 Clip_Var:=x;
end;


procedure TFPaletteOptions.Palette_Format(const black, white, colors: integer);
var white_in, black_in, brightfix, y, r, g, b: double;
    rgb: palt;
    i, j, r1, g1, b1: integer;
    c: TColor;

const
 COLINTENS = 100;
 redf = 0.30;
 greenf = 0.59;
 bluef = 0.11;

begin

  for i:=0 to 255 do begin
   c:=AtariPal[i];
   rgb[i].r:=GetRValue(c);
   rgb[i].g:=GetGValue(c);
   rgb[i].b:=GetBValue(c);
  end;

  black_in:= redf * rgb[0].r + greenf * rgb[0].g + bluef * rgb[0].b;
  white_in:= redf * rgb[15].r + greenf * rgb[15].g + bluef * rgb[15].b;

  if (white_in - black_in)=0 then
   brightfix:=0
  else
   brightfix:= (white - black) / (white_in - black_in);

  for i:=0 to 15 do
    for j:=0 to 15 do begin

     y:=redf * rgb[i shl 4 + j].r+ greenf * rgb[i shl 4 + j].g+ bluef * rgb[i shl 4 + j].b;
     r:=rgb[i shl 4 + j].r - y;
     g:=rgb[i shl 4 + j].g - y;
     b:=rgb[i shl 4 + j].b - y;

     y:=((y - black_in) * brightfix) + black;
     r:=r*(colors * brightfix / COLINTENS);
     g:=g*(colors * brightfix / COLINTENS);
     b:=b*(colors * brightfix / COLINTENS);

     r1:=CLIP_VAR(trunc(y+r)); g1:=CLIP_VAR(trunc(y+g)); b1:=CLIP_VAR(trunc(y+b));

     rgb[i shl 4 + j].r:= r1;
     rgb[i shl 4 + j].g:= g1;
     rgb[i shl 4 + j].b:= b1;
    end;

  for i:=0 to 255 do begin
   FPaletteOptions.palBuf[i*3]:=rgb[i].r;
   FPaletteOptions.palBuf[i*3+1]:=rgb[i].g;
   FPaletteOptions.palBuf[i*3+2]:=rgb[i].b;
  end;

end;


procedure TFPaletteOptions.movePal;
var i: byte;
begin

 for i:=0 to 255 do AtariPal[i]:=palBuf[i*3+2] shl 16+palBuf[i*3+1] shl 8+palBuf[i*3+0];
 
end;


procedure TFPaletteOptions.LoadPal(const nam: string);
var f, len: integer;
    i: byte;
begin

 if not(FileExists(nam)) then begin
 
  for i:=0 to 255 do begin
   palBuf[i*3]   := GetRValue(defPal[i]);
   palBuf[i*3+1] := GetGValue(defPal[i]);
   palBuf[i*3+2] := GetBValue(defPal[i]);
  end;

  form1.CustomMessage('Missing file palette '''+nam+'''', 'Load Palette');

 end else begin
  f:=FileOpen(nam, fmOpenRead);
  len:=FileSeek(f, 0, 2);
  FileSeek(f, 0, 0);
  if len=768 then FileRead(f,palBuf,768);
  FileClose(f);
 end;

end;


procedure TFPaletteOptions.PokazPalete(const p: Boolean);
var x, y, rx, ry: byte;
    bmp: TBitmap;
begin

 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(image1.Width, image1.Height);

 form1.ClrRect(bmp);

 rx:=Image1.Width shr 4;
 ry:=Image1.Height shr 4;

 with bmp.Canvas do
  for y:=0 to 15 do
   for x:=0 to 15 do begin

    if p then
     Brush.Color:=AtariPal[x+y shl 4]
    else
     Brush.Color:=palBuf[(x+y shl 4)*3+2] shl 16+palBuf[(x+y shl 4)*3+1] shl 8+palBuf[(x+y shl 4)*3+0];

    FillRect(Rect(x*rx,y*ry,x*rx+rx-1,y*ry+ry-1));
   end;

 image1.Picture.Graphic:=bmp;

 bmp.Free;

end;


procedure NewPal;
begin
 FPaletteOptions.LoadPal(palette_path);

 if not FPaletteOptions.UseExternal.Checked then
  FPaletteOptions.Palette_Format(tspin[0].Position, tspin[1].Position, tspin[2].Position);

 FPaletteOptions.PokazPalete(false);
end;


procedure TFPaletteOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#27 then ModalResult:=mrCancel;
end;


procedure TFPaletteOptions.UseExternalClick(Sender: TObject);
begin

 NewPal;

end;


procedure TFPaletteOptions.Button3Click(Sender: TObject);
begin
 OpenDialog1.DefaultExt:='.act';
 edit5.Text:=palette_path;

 OpenDialog1.InitialDir := ExtractFileDir(palette_path);
 OpenDialog1.FileName   := ExtractFileName(palette_path);

 if OpenDialog1.Execute then begin
  LoadPal(OpenDialog1.FileName);
  PokazPalete(false);

  palette_path:=OpenDialog1.FileName;
  edit5.Text:=palette_path;
 end;

end;


procedure TFPaletteOptions.SpinEdit1Change(Sender: TObject);
begin
 if not UseExternal.Checked then NewPal;
end;


procedure TFPaletteOptions.FormShow(Sender: TObject);
begin
 tspin[0].Value := pal_b;
 tspin[1].Value := pal_w;
 tspin[2].Value := pal_s;
 tspin[3].Value := pal_c;

 UseExternal.Checked := pal_extr;

 NewPal;

 old_palette_path:=palette_path;
 Edit5.Text:=palette_path;
end;


procedure TFPaletteOptions.Edit5ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;

procedure TFPaletteOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FPaletteOptions', top, left);
end;


procedure TFPaletteOptions.FormCreate(Sender: TObject);
var i: integer;
begin

 for i:=0 to 3 do
  with TBMDSpinEdit.Create(self) do begin
   Parent:=GroupBox1;
   Width:=46;
   Height:=22;
   Left:=8;
   Top:=18+i*34;
   Precision:=0;
   Tag:=i;
   MaxValue:=255;
   MinValue:=0;
   LabelPosition:=lpRight;
   TrackBarEnabled:=false;
   Visible:=True;
   OnChange:=SpinEdit1Change; 
  end;

 for i:=0 to ComponentCount-1 do
  if (Components[i] is TBMDSpinEdit) then
   tspin[Components[i].Tag]:=TBMDSpinEdit(Components[i]);

 tspin[0].EditLabel.Caption:='Black level';
 tspin[1].EditLabel.Caption:='White level';
 tspin[2].EditLabel.Caption:='Saturation';
 tspin[3].EditLabel.Caption:='Color shift';

end;


end.
