unit Bmp2Pmg;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  Menus, SysUtils;
  
type
  TFBmp2Pmg = class(TForm)
    Image1: TImage;
    RadioGroup1: TRadioGroup;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    PMG1: TMenuItem;
    pmgx1: TMenuItem;
    pmgx2: TMenuItem;
    pmgx4: TMenuItem;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1Change;
    procedure PokazORDER;
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure SaveAs1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure slidePMG(i: integer);
    procedure pmgx1Click(Sender: TObject);
    procedure pmgx2Click(Sender: TObject);
    procedure pmgx4Click(Sender: TObject);
    procedure SaveDialog1TypeChange(Sender: TObject);

  private
    { Private declarations }
     slide, UpDownMAX, edit1text: integer;
     mdown: Boolean;

     shape_pmg: array [0..$800] of byte;

const
  margin_width = 106;
  image_width = 80;

  public
    { Public declarations }
  end;

var
  FBmp2Pmg: TFBmp2Pmg;

  ___savPMG: integer;
  ___txtPMG: textfile;

  pmgMsk: array [0..7] of byte = (1,4,$10,$40,2,8,$20,$80);

  grab_pmg_col: array [0..15] of byte = (
  6,6,6,6,
  6,6,6,6,
  4,8,4,8,
  4,8,4,8);


  grab: array [0..31] of byte = (
  0,1,2,3,4,5,6,7,                     // 0..3 gracz
  0,4,1,5,2,6,3,7,                     // 4..7 pocisk
  0,1,2,3,4,5,6,7,
  0,1,4,5,2,3,6,7);

  pmgOrder: array [0..15] of byte = (
  72,72,80,80,88,88,90,90,
  72,72,80,80,82,82,90,90);

  pmgOrderOfset: array [0..15] of byte = (
  0,8,0,8,0,2,0,0,
  0,8,0,2,0,8,0,0);

  pmgPos: array [0..31] of word = (
  $48,$68,$50,$6a,$58,$6c,$60,$6e,     // GrabPMG = 0
  $48,$50,$52,$5a,$5c,$64,$66,$6e,     // GrabPMG = 1
  $48,$58,$2048,$58,$50,$5a,$50,$5a,   // GrabPMG = 2
  $48,$50,$2048,$50,$52,$5a,$52,$5a);  // GrabPMG = 3


implementation

uses Main;

{$R *.dfm}


procedure TFBmp2Pmg.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#27 then form1.Zamknij(f_Bmp2Pmg);
end;


procedure ClrTmpPMG;
begin
 fillchar(_tmpPMG,sizeof(_tmpPMG),$0080);
end;


procedure FilTmpPMG;
var T: array [0..7] of byte;
    hpos: array [0..7] of word;
    i, j, dv, s: byte;
    x: word;
begin

 if FBmp2Pmg.pmgx2.Checked then dv:=2 else
  if FBmp2Pmg.pmgx4.Checked then dv:=4 else
   dv:=1;

 fillchar(bufor,290,0);

 fillchar(hpos, sizeof(hpos), 0);

 move(grab[GrabPMG*8],T,8);

 x:=16;

 for i:=0 to 7 do begin

  if T[i]>3 then s:=2 else s:=8;

  if GrabPMG in [2,3] then x:=x or $2000;    // MULTICOLOR

  hpos[T[i]]:=x;

  if GrabPMG=2 then inc(x, pmgOrderOfset[i]*dv) else
   if GrabPMG=3 then inc(x, pmgOrderOfset[i+8]*dv) else
    inc(x, s*dv);
 end;


 if FBmp2Pmg.RadioButton3.Checked then begin    // MULTICOLOR #3
  hpos[4]:=0;
  hpos[5]:=0;
  hpos[6]:=0;
  hpos[7]:=0;
 end else
  if FBmp2Pmg.RadioButton4.Checked then begin   // MULTICOLOR #4
   hpos[2]:=0;
   hpos[3]:=0;
   hpos[6]:=0;
   hpos[7]:=0;
  end;


 for i:=0 to 3 do begin

 (************** player **************)

  ClrTmpPMG;

  if hpos[i]>0 then
   for j:=0 to 239 do _tmpPMG[j]:=hpos[i] or (dv shl 8);

  FileWrite(___savPMG, _tmpPMG,sizeof(_tmpPMG));

 (************** missile **************)

  ClrTmpPMG;

  if hpos[i+4]>0 then  
   for j:=0 to 239 do _tmpPMG[j]:=hpos[i+4] or (dv shl 8);

  FileWrite(___savPMG, _tmpPMG,sizeof(_tmpPMG));

 end;

end;


procedure FilSprajt;
var T: array [0..7] of byte;
    x, i, j, s, dv: byte;
    ok: Boolean;
begin

 if FBmp2Pmg.pmgx2.Checked then dv:=2 else
  if FBmp2Pmg.pmgx4.Checked then dv:=4 else
   dv:=1;

 fillchar(bufor,290,0);

 move(grab[GrabPMG*8],T,8);

 x:=16;

 for i:=0 to 7 do begin
  if T[i]>3 then s:=2 else s:=8;

  ok:=true;

  if FBmp2Pmg.RadioButton3.Checked then
   ok:=T[i] in [0..3]
  else
   if FBmp2Pmg.RadioButton4.Checked then
    ok:=T[i] in [0,1,4,5];

  if ok then
  for j:=0 to s-1 do
    case dv of
     1: bufor[x+j]:=bufor[x+j] or pmgMsk[T[i]];
     
     2: begin
         bufor[x+j*2]:=bufor[x+j*2] or pmgMsk[T[i]];
         bufor[x+j*2+1]:=bufor[x+j*2+1] or pmgMsk[T[i]];
        end;

     4: begin
         bufor[x+j*4]:=bufor[x+j*4] or pmgMsk[T[i]];
         bufor[x+j*4+1]:=bufor[x+j*4+1] or pmgMsk[T[i]];
         bufor[x+j*4+2]:=bufor[x+j*4+2] or pmgMsk[T[i]];
         bufor[x+j*4+3]:=bufor[x+j*4+3] or pmgMsk[T[i]];
        end;
    end;

  if GrabPMG=2 then inc(x, pmgOrderOfset[i]*dv) else
   if GrabPMG=3 then inc(x, pmgOrderOfset[i+8]*dv) else
    inc(x, s*dv);
 end;

end;


procedure FilSprajtX(const y: byte);
var T: array [0..7] of byte;
    x, i, j, s, dv: byte;
    ok: Boolean;
begin

 if FBmp2Pmg.pmgx2.Checked then dv:=2 else
  if FBmp2Pmg.pmgx4.Checked then dv:=4 else
   dv:=1;

 fillchar(bufor,290,0);

 move(grab[GrabPMG*8],T,8);

 x:=16;

 for i:=0 to 7 do begin
  if T[i]>3 then s:=2 else s:=8;

  ok:=true;

  if FBmp2Pmg.RadioButton3.Checked then
   ok:=T[i] in [0..3]
  else
   if FBmp2Pmg.RadioButton4.Checked then
    ok:=T[i] in [0,1,4,5];

  if ok then
  for j:=0 to s-1 do
   if FBmp2Pmg.shape_pmg[T[i] shl 8+y] and twyt1[j]<>0 then
    case dv of
     1: bufor[x+j]:=bufor[x+j] or pmgMsk[T[i]];

     2: begin
         bufor[x+j*2]:=bufor[x+j*2] or pmgMsk[T[i]];
         bufor[x+j*2+1]:=bufor[x+j*2+1] or pmgMsk[T[i]];
        end;

     4: begin
         bufor[x+j*4]:=bufor[x+j*4] or pmgMsk[T[i]];
         bufor[x+j*4+1]:=bufor[x+j*4+1] or pmgMsk[T[i]];
         bufor[x+j*4+2]:=bufor[x+j*4+2] or pmgMsk[T[i]];
         bufor[x+j*4+3]:=bufor[x+j*4+3] or pmgMsk[T[i]];
        end;
    end;

  if GrabPMG=2 then inc(x, pmgOrderOfset[i]*dv) else
   if GrabPMG=3 then inc(x, pmgOrderOfset[i+8]*dv) else
    inc(x, s*dv);
 end;

end;


procedure SavShapePMG;
var i: byte;
begin
 FileWrite(___savPMG, FBmp2Pmg.shape_pmg[$000],256); FileWrite(___savPMG, FBmp2Pmg.shape_pmg[$400],256);
 FileWrite(___savPMG, FBmp2Pmg.shape_pmg[$100],256); FileWrite(___savPMG, FBmp2Pmg.shape_pmg[$500],256);
 FileWrite(___savPMG, FBmp2Pmg.shape_pmg[$200],256); FileWrite(___savPMG, FBmp2Pmg.shape_pmg[$600],256);
 FileWrite(___savPMG, FBmp2Pmg.shape_pmg[$300],256); FileWrite(___savPMG, FBmp2Pmg.shape_pmg[$700],256);

 bufor[0]:=0; FileWrite(___savPMG, bufor,1);

 FilSprajt;
 for i:=0 to 239 do FileWrite(___savPMG, bufor,290);
 FileWrite(___savPMG, bufor,1);                     // nadmiarowy bajt

 for i:=0 to 239 do begin
  FilSprajtX(i);
  FileWrite(___savPMG, bufor,290);
 end;

 FileWrite(___savPMG, bufor,1);                     // nadmiarowy bajt

 fillchar(bufor,256,$0e);                           // pf4
 FileWrite(___savPMG, bufor,256);
end;


function PobierzPiksel(const x,y: smallint): byte;
var hlp: integer;
begin
 hlp:=form1.Sofs(X shr 2,tmul48[Y]);

 Result:=(tab[hlp] and twyt2[X mod 4]) shr (6-(X mod 4) shl 1);
end;


procedure ZamienNaPMG;
var T: array [0..7] of byte;
    i, j, s, y, v, ofs, p: byte;
begin

 p:=FBmp2Pmg.RadioGroup1.ItemIndex+1;

 fillchar(FBmp2Pmg.shape_pmg, sizeof(FBmp2Pmg.shape_pmg), 0);

 move(grab[GrabPMG*8],T,8);

 ofs:=FBmp2Pmg.Edit1Text shl 2;

 for i:=0 to 7 do begin

  if t[i]>3 then s:=2 else s:=8;

  for y:=0 to 239 do
   for j:=0 to s-1 do begin

    v:=PobierzPiksel(ofs+j,y);

    if GrabPMG<2 then begin
     if v=p then FBmp2Pmg.shape_pmg[t[i] shl 8+y] := FBmp2Pmg.shape_pmg[t[i] shl 8+y] or twyt1[j];
    end else
     if t[i] and 1=0 then begin
      if v and 1<>0 then FBmp2Pmg.shape_pmg[t[i] shl 8+y] := FBmp2Pmg.shape_pmg[t[i] shl 8+y] or twyt1[j];
      if v and 2<>0 then FBmp2Pmg.shape_pmg[t[i] shl 8+$100+y] := FBmp2Pmg.shape_pmg[t[i] shl 8+$100+y] or twyt1[j];
     end;

   end;

   if GrabPMG<2 then
    inc(ofs,s)
   else
    if t[i] and 1=0 then inc(ofs,s);

 end;

end;


procedure PokazPMG;
var T: array [0..7] of byte;
    i, j, y, x, s, v, dv: byte;
    bmp: TBitmap;
    cl: TColor;
begin

 form1.ClrShape9;

 if FBmp2Pmg.pmgx2.checked then dv:=2 else
  if FBmp2Pmg.pmgx4.Checked then dv:=4 else
   dv:=1;

 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize( (FBmp2Pmg.Image1.Width div dv) shr 1, 240);

 with bmp.Canvas do begin
  Pen.Color:=clBtnFace; Brush.Color:=clBtnFace;
  Rectangle(0,0,40,240);
 end;

 move(grab[GrabPMG*8],T,8);

 x:=72;

 for i:=0 to 7 do begin

  if t[i]>3 then s:=2 else s:=8;

  cl:=AtariPal[ grab_pmg_col[GrabPMG shl 2+t[i] and 3] ];
  bmp.Canvas.Pen.Color:=cl;

  for y:=0 to 239 do begin

  if GrabPMG=2 then x:=pmgOrder[i] else
   if GrabPMG=3 then x:=pmgOrder[i+8];

   for j:=0 to s-1 do
    if GrabPMG<2 then begin
     if FBmp2Pmg.shape_pmg[t[i] shl 8+y] and twyt1[j]<>0 then form1.SetPixel(bmp,x+j-72,y, cl);// bmp.Canvas.Pixels[x+j-72,y]:=cl;
    end else
     if t[i] and 1=0 then begin
      v:=0;
      if FBmp2Pmg.shape_pmg[t[i] shl 8+y] and twyt1[j]<>0 then v:=1;
      if FBmp2Pmg.shape_pmg[t[i] shl 8+$100+y] and twyt1[j]<>0 then v:=v or 2;

//      bmp.Canvas.Pixels[x+j-72,y]:=AtariPal[4+v*2];
      form1.SetPixel(bmp, x+j-72,y, AtariPal[4+v*2] );
     end;

  end;

  inc(x,s);
 end;

 FBmp2Pmg.image1.Picture.Bitmap:=bmp;

 bmp.Free;
end;


procedure TFBmp2Pmg.PokazORDER;
var dv, s: byte;
begin

 if pmgx2.Checked then dv:=2 else
  if pmgx4.Checked then dv:=4 else
   dv:=1;

  RadioButton3.Visible:=RadioGroup1.ItemIndex=3;
  RadioButton4.Visible:=RadioGroup1.ItemIndex=3;

  Label3.Visible:=RadioGroup1.ItemIndex=3;
  Label4.Visible:=RadioGroup1.ItemIndex=3;

 if RadioGroup1.ItemIndex=3 then begin            // MULTICOLOR

  RadioButton1.Top:=24; RadioButton1.Left:=14;
  RadioButton2.Top:=24; RadioButton2.Left:=58;

//  RadioButton3.Top:=100; RadioButton3.Left:=14;
//  RadioButton4.Top:=100; RadioButton4.Left:=58;

  Label1.Top:=40; Label1.Left:=6; //Label1.Height:=56;
  Label2.Top:=40; Label2.Left:=50; //Label2.Height:=56;

//  Label3.Top:=116; Label3.Left:=6;
//  Label4.Top:=116; Label4.Left:=50; 

  Label1.Caption:='P0-P1'+#13+'P2-P3'+#13+'M0-M1'+#13+'M2-M3';
  Label2.Caption:='P0-P1'+#13+'M0-M1'+#13+'P2-P3'+#13+'M2-M3';

  Label3.Caption:='P0-P1'+#13+'P2-P3';
  Label4.Caption:='P0-P1'+#13+'M0-M1';

  if RadioButton1.Checked or RadioButton3.Checked then
   GrabPMG:=2
  else
   GrabPMG:=3;

  if RadioButton3.Checked then s:=32 else
   if RadioButton4.Checked  then s:=20 else
    s:=40;

  SelectArea.Width:=s*2;
  UpDownMAX:=Bajt-5;
  FBmp2Pmg.Image1.Width:=s*dv;

 end else begin

  if RadioButton3.Checked then RadioButton1.Checked:=true;
  if RadioButton4.Checked then RadioButton2.Checked:=true;

  RadioButton1.Top:=24; RadioButton1.Left:=20;
  RadioButton2.Top:=24; RadioButton2.Left:=54;
  Label1.Top:=40; Label1.Left:=10; //Label1.Height:=104;
  Label2.Top:=40; Label2.Left:=44; //Label2.Height:=104;

  Label1.Caption:='P0'+#13+'P1'+#13+'P2'+#13+'P3'+#13+'M0'+#13+'M1'+#13+'M2'+#13+'M3';
  Label2.Caption:='P0'+#13+'M0'+#13+'P1'+#13+'M1'+#13+'P2'+#13+'M2'+#13+'P3'+#13+'M3';

  if RadioButton1.Checked then GrabPMG:=0 else GrabPMG:=1;

  SelectArea.Width:=80*2;
  UpDownMAX:=Bajt-10;
  FBmp2Pmg.Image1.Width:=80*dv;
 end;

 if RadioButton1.Checked then begin
  Label2.Enabled:=false;
  Label1.Enabled:=true;
  Label3.Enabled:=false;
  Label4.Enabled:=false;
 end else
  if RadioButton2.Checked then begin
   Label1.Enabled:=false;
   Label2.Enabled:=true;
   Label3.Enabled:=false;
   Label4.Enabled:=false;
  end else
   if RadioButton3.Checked then begin
    Label1.Enabled:=false;
    Label2.Enabled:=false;
    Label3.Enabled:=true;
    Label4.Enabled:=false;
   end else
    if RadioButton4.Checked then begin
     Label1.Enabled:=false;
     Label2.Enabled:=false;
     Label3.Enabled:=false;
     Label4.Enabled:=true;
    end;

 PokazPMG;
end;


procedure TFBmp2Pmg.RadioGroup1Click(Sender: TObject);
begin
 PokazORDER;
 ZamienNaPMG;
 PokazPMG;
end;


procedure TFBmp2Pmg.FormCreate(Sender: TObject);
begin
 doublebuffered:=true;

// image1.Picture.Bitmap.PixelFormat:=pf32bit;
end;


procedure TFBmp2Pmg.FormShow(Sender: TObject);
begin
 PokazORDER;

 with form1 do begin

  SelectArea.Top:=0;
  SelectArea.Left:=pozX; //+CzarnyPas*2;
  SelectArea.Height:=240*2;
  SelectArea.Width:=80*2;

  Shape9Enable(true);
 end;

 UpDownMAX:=Bajt-10;
end;


procedure TFBmp2Pmg.RadioButton1Click(Sender: TObject);
begin
 PokazORDER;
 Edit1Change;
end;


procedure TFBmp2Pmg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FBMP2PMG',top,left);

 form1.BMP2PMG.Checked:=false;
 form1.Shape9Enable(false);
end;


procedure TFBmp2Pmg.Edit1Change;
begin

 SelectArea.Left := CzarnyPas*2+Edit1Text shl 4;

 ZamienNaPMG;
 PokazPMG;
end;


procedure pociski;
var i: byte;
begin

 for i:=0 to 255 do
  bufor[i+8]:=(FBmp2Pmg.shape_pmg[$400+i] shr 6) and $03 +
              (FBmp2Pmg.shape_pmg[$500+i] shr 4) and $0c +
              (FBmp2Pmg.shape_pmg[$600+i] shr 2) and $30 +
              (FBmp2Pmg.shape_pmg[$700+i]) and $c0;

end;


procedure savASM(const c: integer);
var i, j: byte;
begin

 if c>=0 then move(FBmp2Pmg.shape_pmg[c], bufor[8],$100-8);

 for j:=0 to 15 do begin
  write(___txtPMG, #9'dta ');

  for i:=0 to 15 do begin
   write(___txtPMG, form1.hex(bufor[i+j shl 4],2));
   if i<>15 then write(___txtPMG, ',');
  end;

  writeln(___txtPMG);
 end;

end;


procedure SaveAsASM;
// SAVE AS PMG ASM
var a: string;
begin

 a:=FBmp2Pmg.Savedialog1.FileName;
 a:=ChangeFileExt(a, '.asm');
 FBmp2Pmg.Savedialog1.FileName:=a;

 pociski;

 assignfile(___txtPMG, a);

 rewrite(___txtPMG);

 if not(FBmp2Pmg.RadioButton3.Checked) then begin
  writeln(___txtPMG,       '; missiles'); savASM(-1);
 end;
 
 writeln(___txtPMG, #13#10'; player 0'); savASM($000);
 writeln(___txtPMG, #13#10'; player 1'); savASM($100);

 if not(FBmp2Pmg.RadioButton4.Checked) then begin
  writeln(___txtPMG, #13#10'; player 2'); savASM($200);
  writeln(___txtPMG, #13#10'; player 3'); savASM($300);
 end;

 closefile(___txtPMG);

end;


procedure PMGDAT(const i: integer);
begin
 FileWrite(___savPMG, bufor[$300], 8);

 FileWrite(___savPMG, FBmp2Pmg.shape_pmg[i],$100-8);
end;


procedure SaveAsDAT;
// SAVE AS PMG DAT
var a: string;
begin

 a:=FBmp2Pmg.Savedialog1.FileName;
 a:=ChangeFileExt(a, '.dat');
 FBmp2Pmg.Savedialog1.FileName:=a;

 pociski;

 ___savPMG:=FileCreate(a);

 if not(FBmp2Pmg.RadioButton3.Checked) then FileWrite(___savPMG, bufor, $100);

 PMGDAT($000);
 PMGDAT($100);

 if not(FBmp2Pmg.RadioButton4.Checked) then begin
  PMGDAT($200);
  PMGDAT($300);
 end;
 
 FileClose(___savPMG);

end;


procedure SaveAsPMG;
// SAVE AS PMG G2F
var a: string;
begin

 a:=FBmp2Pmg.Savedialog1.FileName;
 a:=ChangeFileExt(a, '.pmg');
 FBmp2Pmg.Savedialog1.FileName:=a;

 ___savPMG:=FileCreate(a);

 fillchar(bufor[$000],256,grab_pmg_col[GrabPMG shl 2+0]);
 fillchar(bufor[$100],256,grab_pmg_col[GrabPMG shl 2+1]);
 fillchar(bufor[$200],256,grab_pmg_col[GrabPMG shl 2+2]);
 fillchar(bufor[$300],256,grab_pmg_col[GrabPMG shl 2+3]);

 FileWrite(___savPMG, bufor,$400);

 FilTmpPMG;  SavShapePMG;

 FileClose(___savPMG);

end;


procedure TFBmp2Pmg.slidePMG(i: integer);
begin

  if i<0 then i:=0 else
  if i>FBmp2Pmg.UpDownMAX then i:=FBmp2Pmg.UpDownMAX;

  FBmp2Pmg.Edit1Text:=i;
  Edit1Change;

end;


procedure TFBmp2Pmg.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i: integer;
begin

 if not(mdown) then
  slide:=x
 else begin

  i:=Edit1Text;

  if x<slide then dec(i);
  if x>slide then inc(i);

  slidePMG(i);
 end;

end;


procedure TFBmp2Pmg.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 mdown:=true;

end;


procedure TFBmp2Pmg.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 mdown:=false;

end;


procedure TFBmp2Pmg.pmgx1Click(Sender: TObject);
begin
 pmgx1.Checked:=true;
 pmgx2.Checked:=false;
 pmgx4.Checked:=false;

 image1.Width:=image_width;
 bevel1.Width:=image_width+8;

 FBmp2Pmg.Width:=image_width+margin_width+8;

 PokazORDER;
 PokazPMG;
end;


procedure TFBmp2Pmg.pmgx2Click(Sender: TObject);
begin
 pmgx1.Checked:=false;
 pmgx2.Checked:=true;
 pmgx4.Checked:=false;

 image1.Width:=image_width*2;
 bevel1.Width:=image_width*2+8;

 FBmp2Pmg.Width:=image_width*2+margin_width+8;

 PokazORDER;
 PokazPMG;
end;


procedure TFBmp2Pmg.pmgx4Click(Sender: TObject);
begin
 pmgx1.Checked:=false;
 pmgx2.Checked:=false;
 pmgx4.Checked:=true;

 image1.Width:=image_width*4;
 bevel1.Width:=image_width*4+8;

 FBmp2Pmg.Width:=image_width*4+margin_width+8;

 PokazORDER;
 PokazPMG;
end;


procedure TFBmp2Pmg.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var i: integer;
begin
  i:=Edit1Text;

  dec(i);

  slidePMG(i);

  Handled:=true;
end;


procedure TFBmp2Pmg.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var i: integer;
begin
  i:=Edit1Text;

  inc(i);

  slidePMG(i);

  Handled:=true;
end;


procedure TFBmp2Pmg.SaveAs1Click(Sender: TObject);
var a: string;
const
    ext: array [1..3] of string = ('.pmg', '.dat', '.asm');
begin

 fillchar(bufor, sizeof(bufor), 0);

 a:=SaveDialog1.FileName;
 SaveDialog1.FileName:=ChangeFileExt(a, '');

 SaveDialog1.DefaultExt:=ext[SaveDialog1.FilterIndex];

 if SaveDialog1.Execute then begin

  case SaveDialog1.FilterIndex of
   1: SaveAsPMG; 
   2: SaveAsDAT;
   3: SaveAsASM;
  end;

 end;

end;


procedure TFBmp2Pmg.SaveDialog1TypeChange(Sender: TObject);
begin
// !!! zmiana rozszerzenia nie dziala w locie, ale bez tego wogole nie bedzie zapisywal plikow
end;


procedure TFBmp2Pmg.Exit1Click(Sender: TObject);
begin
 Close;
end;

end.

