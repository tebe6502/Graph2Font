unit EditCharset;

interface

uses
  Windows, Graphics, Controls, Forms, Menus, StdCtrls, Classes, ExtCtrls,
  Dialogs, ComCtrls, SysUtils, ToolWin, AtariPalette,
  GR32, GR32_Layers, GR32_Image;

type

  tcharset = record
              name: string[32];
              data: array [0..1023] of byte;
             end;

  tfnt     = array [0..7] of byte;

type
  TFEditCharset = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    MainMenu1: TMainMenu;
    FlipVertical1: TMenuItem;
    FlipVertical2: TMenuItem;
    Fill1: TMenuItem;
    Option1: TMenuItem;
    File1: TMenuItem;
    LoadFNT1: TMenuItem;
    SaveFNT1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Help1: TMenuItem;
    Bevel3: TBevel;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    RotateRight1: TMenuItem;
    RotateLeft1: TMenuItem;
    frameAtariPalette1: TframeAtariPalette;
    ComboCharset: TComboBox;
    Label1: TLabel;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    N1: TMenuItem;
    DeleteFNT: TMenuItem;
    Image1: TImgView32;
    Image3: TImgView32;
    Image2: TImgView32;
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure Image1DblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PutChar(a: byte);
    procedure FormShow(Sender: TObject);
    procedure UstawPaleteKolorow;
    procedure Fill1Click(Sender: TObject);
    procedure FlipVertical1Click(Sender: TObject);
    procedure FlipVertical2Click(Sender: TObject);
    procedure LoadFNT1Click(Sender: TObject);
    procedure SaveFNT1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure PrzepiszZnaki;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image3Click(Sender: TObject);
    procedure yellow_char_status;
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const _Rect: TRect);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RotateRight1Click(Sender: TObject);
    procedure RotateLeft1Click(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure ComboCharsetChange(Sender: TObject);
    procedure lFnt(var f: tfnt);
    procedure FormActivate(Sender: TObject);
    procedure ComboCharsetCloseUp(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure DeleteFNTClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure SetShape1(x,y: integer);
    procedure SetShape2(x,y: integer);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);

  private
    { Private declarations }
    bmarker: TBitmap;

    Offset: byte;

  public
    { Public declarations }
  end;

var
  FEditCharset: TFEditCharset;
  PunktZnak, Shp, ShpCopy, chrPis: TPoint;
  AktywnyZnak: byte;
  flash: TColor;
  blink: Boolean;

  Shape1, Shape2, CharGrid: TBitmapLayer;

  bufZnak: tfnt;
  tmpRotate: array [0..7, 0..7] of byte;
  chrPal: array [0..15] of TColor;

const
     AL_RIGHT = 1;
     AL_DOWN  = 2;
     AL_LEFT  = 3;
     AL_UP    = 4;

     __echar = 'echar.dat';

implementation

uses Main, MoveCopyPaste;

{$R *.dfm}


procedure _SetFocus;
begin

 FEditCharset.ComboCharset.Enabled:=false;
 FEditCharset.SetFocus;
 FEditCharset.ComboCharset.Enabled:=true;

end;


procedure ustaw_kursor_znaku;
// wskazany znak z zestawu znajduje na obrazku
var x, y, v: byte;
    ok: Boolean;
    hit: TPoint;
begin
 AktywnyZnak:=znak_X+znak_Y shl 4;

 ok:=false;

 hit:=Point(0,0);


 if FEditCharset.ComboCharset.ItemIndex>0 then begin

  form1.ZaznaczAktualnyZnak(znak_X , znak_Y);

  Shp:=Point(0,0);
  Cur:=hit;

//  CurShp:=Cur;                       // aby ustawic yellow_cursor

  yel_wid:=1; yel_hig:=1;
  form1.create_yellow_cursor;

  form1.PokazCharset;

 end else begin

 for y:=0 to 29 do
  if table[y]=charset then
   for x:=0 to Bajt-1 do begin
    v:=scren[form1.Sofs(x,tmul48[y])] and $7f;

    if v=AktywnyZnak then begin
     form1.ZaznaczAktualnyZnak(znak_X , znak_Y);

     hit:=Point(x+CzarnyPas shr 3,y);
     ok:=true;
     Break;
    end;

   end;

 if ok then begin
  Shp:=Point(0,0);
  Cur:=hit;

  CurShp:=Cur;                       // aby ustawic yellow_cursor

  yel_wid:=1; yel_hig:=1;            // !!! koniecznie inaczej 'scan line index out'
  form1.create_yellow_cursor;

  form1.kafelek(true);
 end;

 end;

 _SetFocus;
end;


procedure TFEditCharset.SetShape1(x,y: integer);
begin
 Shape1.Location := FloatRect(x, y, x+20, y+20);
end;


procedure TFEditCharset.SetShape2(x,y: integer);
begin
 Shape2.Location := FloatRect(x, y, x+20, y+20);
end;


procedure TFEditCharset.PrzepiszZnaki;
var a, b, c, v: byte;
    z, tmp, idx, mul: integer;
begin

//przepisz znaki na ekran
 for a:=0 to 29 do begin
  z:=table[a] shl 10;

  mul:=tmul48[a] shl 3;

  for b:=0 to bajt-1 do begin
   idx:=CzarnyPas shr 3+b;

   for c:=0 to 7 do begin
    tmp:=idx+mul+tmul48[c];
    v:=scren[idx+tmul48[a]];

    tab[tmp]:=fonty[z+(v and $7f) shl 3+c];

 // !!! konieczny test aby dzialal INVERS w HIRES !!!
    if (gfxMode[a] in [1,4]) and (v>127) then begin
     tab[tmp]:=tab[tmp] xor $ff;
     invers[idx+tmul48[a]]:=v xor $80;
    end;

   end;

  end;
 end;


 if form1.Showchars1.Checked then begin
  form1.showMIC;
//  img_char.Canvas.Draw(0,0,img1);
  form1.ShowChars(0,29,false);
 end else begin
  form1.ShowChars(0,0,true);
//  img_char.Canvas.Draw(0,0,img1);
 end;

 form1.PokazCharset;

 form1.PrzepiszShape9NaZnaki;

end;


function SetZnakKolor: byte;
begin
 Result:=0;

 case gfxMode[Cur.Y] of
    1: Result:=tcol1[pisCol[0 xor PrawyPrzycisk]];
  0,2: Result:=tcol2[pisCol[0 xor PrawyPrzycisk]];
    4: Result:=tcol4[pisCol[0 xor PrawyPrzycisk]];
 end;

end;


procedure PaletaKolorow;
var i: byte;
begin

 form1.PobierzPalete(Cur.X shl 3, Cur.Y shl 3);

 for i := 0 to 15 do chrPal[i]:=AtariPal[palCol[2+i]];

 FEditCharset.frameAtariPalette1.UstawPalete;
end;


procedure TFEditCharset.UstawPaleteKolorow;
begin
 PaletaKolorow;

 PrzepiszZnaki;
end;


procedure rozbij_pixle(const v,i:byte);
begin

 case gfxMode[Cur.Y] of
  1: begin
      tmpRotate[0,i]:=ord((v and twyt1[0])<>0);
      tmpRotate[1,i]:=ord((v and twyt1[1])<>0);
      tmpRotate[2,i]:=ord((v and twyt1[2])<>0);
      tmpRotate[3,i]:=ord((v and twyt1[3])<>0);
      tmpRotate[4,i]:=ord((v and twyt1[4])<>0);
      tmpRotate[5,i]:=ord((v and twyt1[5])<>0);
      tmpRotate[6,i]:=ord((v and twyt1[6])<>0);
      tmpRotate[7,i]:=ord (v and twyt1[7]<>0);
     end;

  0,2:
     begin
      tmpRotate[0,i]:=(v and twyt2[0]) shr 6;
      tmpRotate[1,i]:=(v and twyt2[1]) shr 4;
      tmpRotate[2,i]:=(v and twyt2[2]) shr 2;
      tmpRotate[3,i]:=v and twyt2[3];
     end;

  4: begin
      tmpRotate[0,i]:=(v and twyt4[0]) shr 4;
      tmpRotate[1,i]:=v and twyt4[1];
     end;
 end;

end;


procedure TFEditCharset.lFnt(var f: tfnt);
var lStream: TFileStream;
begin

 if FEditCharset.ComboCharset.ItemIndex=0 then

  move(fonty[table[Cur.Y] shl 10+(AktywnyZnak and $7f) shl 3], f, 8)

 else begin

  lStream:=TFileStream.Create(form1.GetUndoName(__echar), fmOpenRead);
  lStream.Position:=(FEditCharset.ComboCharset.ItemIndex-1) * sizeof(tcharset) + 33 + (AktywnyZnak and $7f) shl 3;

  lStream.ReadBuffer(f, 8);

  lStream.Free;
 end;


end;


procedure sFnt(var f:tfnt);
var lStream: TFileStream;
begin

 if FEditCharset.ComboCharset.ItemIndex=0 then

  move(f, fonty[table[Cur.Y] shl 10+(AktywnyZnak and $7f) shl 3], 8)

 else begin

  lStream:=TFileStream.Create(form1.GetUndoName(__echar), fmOpenWrite);
  lStream.Position:=(FEditCharset.ComboCharset.ItemIndex-1) * sizeof(tcharset) + 33 + (AktywnyZnak and $7f) shl 3;

  lStream.WriteBuffer(f, 8);

  lStream.Free;
 end;

end;


procedure TFEditCharset.yellow_char_status;
var txt: string;
    i: integer;
begin

 txt:='';

 if ComboCharset.ItemIndex=0 then begin

  for i := 0 to yel_wid-1 do begin
   txt:=txt+IntToHex(scren[{CzarnyPas shr 3+}CurShp.X+i+tmul48[CurShp.Y+ShpCopy.Y]],2);
   if i<>8 then txt:=txt+'|';
  end;

 end;

 FEditCharset.StatusBar1.Panels[2].Text:=txt;
end;


procedure TFEditCharset.PutChar(a: byte);
var i, j, p, val: byte;
    x, y, cnt, dv: integer;
    c: TColor32;
    s: string;
    g: TBitmap;
    b: TBitmap32;
    fnt: tfnt;
begin
 AktywnyZnak:=a; newChar:=a;

 i:=(Cur.Y) shl 3;
// val:=scren[form1.Sofs(Cur.X,tmul48[Cur.Y])];
 val:=scren[Cur.X+tmul48[Cur.Y]];

 form1.PutChar(val);

 p:=gfxMode[Cur.Y];
 if p=0 then p:=2;

 PaletaKolorow;


 b:=TBitmap32.Create;
 b.SetSize(144, 144);
 b.OuterColor:=Color32(transCol);
 b.Clear(Color32(transCol));
 b.DrawMode := dmTransparent;
 b.CombineMode := cmBlend;

 with b do begin
  BeginUpdate;

  SetStipple([{clWhite32} clLightGray32, 0]);
  StippleStep:=1;

  dv:=(b.Width div (8 div p));
  for i:=0 to dv-1 do VertLineTSP(i*dv, 0, 144);

  dv:=b.Height shr 3;
  for i:=0 to 7 do HorzLineTSP(0, i*dv, 144);

  EndUpdate;
 end;

 CharGrid.Bitmap := b;

 b.Free;



// label10.Caption:='Color 2';

 if p in [0,2] then begin
  if val>127 then begin
   chrPal[3] := AtariPal[TabKolor[$400+i]];
//   label10.Caption:='Color 3';
  end else begin
   chrPal[3] := AtariPal[TabKolor[$300+i]];
//   label10.Caption:='Color 2';
  end;

  FEditCharset.frameAtariPalette1.UstawPalete;

//  Panel12.Color:=chrPal[3];
 end;

 lFnt(fnt);

 for i:=0 to 7 do rozbij_pixle(fnt[i], i);

 b:=TBitmap32.Create;
 b.OuterColor:=Color32(transCol);
 b.SetSize(8,8);
 b.CombineMode := cmBlend;
 b.DrawMode := dmTransparent;

 b.BeginUpdate;

 case p of
  1: for j:=0 to 7 do
      for i:=0 to 7 do
       b.Pixels[i,j]:=Color32(chrPal[tmpRotate[i,j]]);

  2: for j:=0 to 7 do
      for i:=0 to 3 do begin
       c:=Color32(chrPal[tmpRotate[i,j]]);

       b.Pixels[i shl 1,j]   := c;
       b.Pixels[i shl 1+1,j] := c;
      end;

  4: for j:=0 to 7 do
      for i:=0 to 2 do begin
       c:=Color32(chrPal[tmpRotate[i,j]]);

       b.Pixels[i shl 2,j]   := c;
       b.Pixels[i shl 2+1,j] := c;
       b.Pixels[i shl 2+2,j] := c;
       b.Pixels[i shl 2+3,j] := c;
      end;
 end;

 b.EndUpdate;

 FEditCharset.Image2.Bitmap := b;

 b.Free;

// image2.Invalidate;


 a:=a and $7f;

 x:=(a mod 16)*9+1; y:=(a shr 4)*9;

// Image1.Width:=145*2; Image1.Height:=72*2 + 1;

 s:='Char #'+IntToStr(AktywnyZnak and $7f)+' ('+form1.Hex(AktywnyZnak and $7f,2)+')';

 if AktywnyZnak>127 then s:=s+' + invers';

 image2.hint:=s;

 FEditCharset.StatusBar1.Panels[0].Text:=s;
 FEditCharset.StatusBar1.Panels[1].Text:=s;

 yellow_char_status;

 s:='';

 if FEditCharset.ComboCharset.ItemIndex=0 then begin

  s:='Charset #'+IntToStr(charset)+'  (char #'+IntToStr(AktywnyZnak and $7f);

  cnt:=0;
  for j := 0 to 29 do
   for i := 0 to Bajt - 1 do
    if table[j]=charset then
     if scren[CzarnyPas shr 3+i+tmul48[j]]=val then inc(cnt);

  s:=s+' is used '+IntToStr(cnt)+' times in the screen)';

 end;

 FEditCharset.StatusBar1.Panels[3].Text:=s;

end;


procedure TFEditCharset.Image1Click(Sender: TObject);
// SELECT CHAR
var x, y: integer;
begin
 edX_old:=edX; edY_old:=edY;

 x:=edX div 2; y:=edY div 2;

 znak_X:=x div 9;
 znak_Y:=y div 9;

// Cur:=CurShp;

 ustaw_kursor_znaku;

 _SetFocus;
end;


procedure TFEditCharset.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var x_, y_: integer;
    a: byte;
begin

if (X>0) and (Y>0) then begin
 edX:=X; edY:=Y;

 if (edX<>edX_old) and (edY<>edY_old) then begin

  x_:=edX div 2; y_:=edY div 2;
  a:=x_ div 9+(y_ div 9) shl 4;
  newChar:=a;

  if newChar<>oldChar then oldChar:=newChar;
 end;

end;

end;



procedure TFEditCharset.FormKeyPress(Sender: TObject; var Key: Char);
begin

 if ord(key)=27 then form1.Zamknij(f_EditCharset);

end;


procedure UpdateComboCharset;
var ch: tcharset;
    i, y: integer;
    lStream: TFileStream;
begin

 lStream:=TFileStream.Create(form1.GetUndoName(__echar), fmOpenRead );

 y:=FEditCharset.ComboCharset.ItemIndex;

 FEditCharset.ComboCharset.Clear;

 FEditCharset.ComboCharset.Items.Add('Default');

 for i := 0 to (lStream.Size div sizeof(ch))-1 do begin

  lStream.ReadBuffer(ch, sizeof(ch));

  FEditCharset.ComboCharset.Items.Add(ch.name);

 end;

 lStream.Free;

 if y>FEditCharset.ComboCharset.Items.Count-1 then
  FEditCharset.ComboCharset.ItemIndex:=FEditCharset.ComboCharset.Items.Count-1
 else
  FEditCharset.ComboCharset.ItemIndex:=y;

 FEditCharset.DeleteFNT.Enabled:=FEditCharset.ComboCharset.ItemIndex>0;
end;


procedure TFEditCharset.FormShow(Sender: TObject);
begin
 UstawPaleteKolorow;
 PunktZnak:=Point(0,0);
 Timer1.Enabled:=true;

 frameAtariPalette1.UstawPalete;

 bmarker:=TBitmap.Create;
 bmarker.PixelFormat:=pf32bit;
 bmarker.SetSize(20, 20);
 bmarker.TransparentColor:=transCol;

 form1.ClrRect(bmarker, transCol);

 UpdateComboCharset;

// ustaw_kursor_znaku;     // !!! nie wolno wywolywac USTAW_KURSOR_ZNAKU poza IMAGE1CLICK !!!
end;


procedure TFEditCharset.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin

 if Button=mbRight then
  PrawyPrzycisk:=1
 else
  PrawyPrzycisk:=0;

end;


procedure TFEditCharset.Image2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var i, j: integer;
begin
// obliczamy wspolczynnik powiekszenia
 j:=image2.height shr 3; i:=1;

 case gfxMode[Cur.Y] of
    1: i:=image2.Width shr 3;
  0,2: i:=image2.Width shr 2;
    4: i:=image2.Width shr 1;
 end;

// i wyliczamy pozycje X,Y w znaku
 PunktZnak:=Point(x div i , y div j);
end;


procedure Punkt;
var v, k: byte;
    fnt: tfnt;
begin

Form1.ZapiszUndo;

// odczytujemy zestaw znakow
FEditCharset.lFnt(fnt);

v:=fnt[PunktZnak.y];

k:=SetZnakKolor; SaveAfterExit:=true;

case gfxMode[Cur.Y] of
 1: begin
     k:=k and twyt1[PunktZnak.x]; v:=v and (twyt1[PunktZnak.x] xor $ff);
     v:=v or k;
    end;
 0,2:
    begin
     k:=k and twyt2[PunktZnak.x]; v:=v and (twyt2[PunktZnak.x] xor $ff);
     v:=v or k;
    end;
 4: begin
     k:=k and twyt4[PunktZnak.x]; v:=v and (twyt4[PunktZnak.x] xor $ff);
     v:=v or k;
    end;
end;

fnt[PunktZnak.y]:=v;

sFnt(fnt);

FEditCharset.PrzepiszZnaki;
end;


procedure TFEditCharset.Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
 Punkt;
end;


procedure TFEditCharset.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const _Rect: TRect);
var MyRect, MyOther: TRect;
begin

 case Panel.Index of
  0: with StatusBar.Canvas do begin

      MyRect := Rect(_Rect.Left+4,_Rect.Top,_Rect.Left+16+4,16+_Rect.Top);
      MyOther := Rect(0,0,8,8);

//      TextRect(_Rect,_Rect.Left+48,_Rect.Top,image2.hint);

      CopyRect(MyRect,atasciiChar.Canvas,MyOther);

     end;
 end;

end;


procedure NaBity(const a: integer);
var i, j, k: integer;
    v: byte;
    fnt: tfnt;
begin
 FEditCharset.lFnt(fnt);

 move(fnt, bufor, 8);

 for j:=0 to 7 do begin
 fillchar(bufor[$100+j*24],24,0);
  for i:=0 to 7 do
   if (bufor[j] and twyt1[i])>0 then begin
    bufor[$100+i+j*24]:=1;
    bufor[$100+i+j*24+8]:=1;
    bufor[$100+i+j*24+16]:=1;
   end;
 end;

// teraz przekopiujemy to z przesunieciem A
// jesli A=0 to zrob mirror
 if a=0 then begin
 fillchar(bufor[$300],$100,0);
 for j:=0 to 7 do begin
  v:=gfxMode[Cur.Y]; if v=0 then v:=2;
  
  for k:=0 to (8 div v)-1 do
   for i:=0 to v-1 do bufor[$300+j*24+8+i+k*v]:=bufor[$100+j*24+8+i+8-(k+1)*v];
 end;

 move(bufor[$300],bufor[$100],$100);
 end;

 for i:=0 to 7 do move(bufor[$100+i*24+8+a],bufor[$200+i shl 3],8);

// zamieniamy na bajty
 for j:=0 to 7 do begin
 v:=0;
  for i:=0 to 7 do if bufor[$200+j shl 3+i]>0 then v:=v or twyt1[i];
 bufor[j]:=v;
 end;

 move(bufor, fnt, 8);

 sFnt(fnt);

 FEditCharset.PrzepiszZnaki;
end;


procedure TFEditCharset.LoadFNT1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* LOAD | ADD CHARSET                                                         *)
(*----------------------------------------------------------------------------*)
var f: integer;
    lStream: TFileStream;
    ch: tcharset;
begin

 Form1.ZapiszUndo;

 OpenDialog1.InitialDir := ExtractFileDir(charset_path);
 OpenDialog1.FileName   := ExtractFileName(charset_path);

 if OpenDialog1.Execute then begin

   lStream:=TFileStream.Create(form1.GetUndoName(__echar), fmOpenReadWrite );

   ch.name:=ExtractFileName(OpenDialog1.FileName);

   f:= FileOpen(OpenDialog1.FileName, fmOpenRead);
   FileSeek(f, 0, 0);
   FileRead(f, ch.data, 1024);
   FileClose(f);

   if ComboCharset.ItemIndex=0 then                            // ADD NEW CHARSET
    lStream.Position := lStream.Size
   else
    lStream.Position := (ComboCharset.ItemIndex-1) * sizeof(ch);  // REWRITE CHARSET

   lStream.WriteBuffer(ch, sizeof(ch));

   lStream.Free;

   form1.ZamienGrafike;

   form1.PokazCharset;

   UpdateComboCharset;

   charset_path:=OpenDialog1.FileName;
 end;

end;


procedure TFEditCharset.SaveDialog1TypeChange(Sender: TObject);
begin
// !!! zmiana rozszerzenia nie dziala w locie, ale bez tego wogole nie bedzie zapisywal plikow
end;


procedure TFEditCharset.SaveFNT1Click(Sender: TObject);
var plik: integer;
    lStream: TFileStream;
begin

 SaveDialog1.InitialDir := ExtractFileDir(charset_path);
 SaveDialog1.FileName   := ExtractFileName(charset_path);

 SaveDialog1.DefaultExt:=file_ext[9];

 if SaveDialog1.Execute then begin

  if ComboCharset.ItemIndex=0 then

   move(fonty[table[CurShp.Y] shl 10], bufor, 1024)

  else begin

   lStream:=TFileStream.Create(form1.GetUndoName(__echar), fmOpenRead);
   lStream.Position := (ComboCharset.ItemIndex-1) * sizeof(tcharset) + 33;
   lStream.ReadBuffer(bufor, 1024);
   lStream.Free;

  end;

  plik:=FileCreate(SaveDialog1.FileName);
  FileWrite(plik, bufor, 1024);
  FileClose(plik);

  charset_path:=SaveDialog1.FileName;
 end;

end;


procedure TFEditCharset.ToolButton2Click(Sender: TObject);
var i: byte;
begin
 i:=TToolButton(Sender).Tag;

 case i of
  0: FlipVertical1Click(FEditCharset);
  1: FlipVertical2Click(FEditCharset);
 end;

end;


procedure TFEditCharset.Help1Click(Sender: TObject);
begin
 Application.MessageBox('CURSOR ARROWS'#9#9'move chars selection'#13#13'NUMLOCK ARROWS'#9#9'change size chars selection'#13#13'CTRL + C'#9#9#9'copy selected chars'+#13#13+'CTRL + V'#9#9#9'paste selected chars'+#13#13+'SPACE'#9#9#9'invers selected chars (add 5-th color)','Help',MB_ICONINFORMATION);
end;


procedure TFEditCharset.FormCreate(Sender: TObject);
begin
 doublebuffered:=true;

 edX:=0; edY:=0; edX_old:=0; edY_old:=0;
 newChar:=$ff; oldChar:=$ff;

 CharGrid := TBitmapLayer.Create(Image2.Layers);
 CharGrid.Scaled := False;
 with CharGrid.Bitmap do begin
  BeginUpdate;
  SetSize(144,144);
  OuterColor:=Color32(transCol);
  CombineMode := cmBlend;
  DrawMode := dmTransparent;
  EndUpdate;
 end;
 CharGrid.Location := FloatRect(0, 0, 144, 144);

 Shape1 := TBitmapLayer.Create(Image3.Layers);
 Shape1.Scaled := False;
 with Shape1.Bitmap do begin
  BeginUpdate;
  SetSize(20,20);
  OuterColor:=Color32(transCol);
  CombineMode := cmBlend;
  DrawMode := dmTransparent;
  EndUpdate;
 end;
 Shape1.Location := FloatRect(0, 0, 20, 20);

 Shape2 := TBitmapLayer.Create(Image1.Layers);
 Shape2.Scaled := False;
 with Shape2.Bitmap do begin
  BeginUpdate;
  SetSize(20,20);
  OuterColor:=Color32(transCol);
  CombineMode := cmBlend;
  DrawMode := dmTransparent;
  EndUpdate;
 end;
 Shape2.Location := FloatRect(0, 0, 20, 20);

end;


procedure MarchingAnts(x,y: integer; lpData: lParam); stdcall;
var cord: integer;
begin

 case lpData of
  AL_RIGHT: cord:=x;
   AL_DOWN: cord:=y;
   AL_LEFT: cord:=20-x;
     AL_UP: cord:=20-y;
 end;

 cord:=(cord shr 1) and 3;

 SetPixelV(FEditCharset.bmarker.Canvas.Handle, x,y, ord(cord <> FEditCharset.Offset and 3) *clWhite);
end;


procedure DrawSelectMarker;
begin
 LineDDA(0,0,20-1,0,       @MarchingAnts, AL_RIGHT);
 LineDDA(0,1,20-1,1,       @MarchingAnts, AL_RIGHT);

 LineDDA(20-1,0,20-1,20-1, @MarchingAnts, AL_DOWN);
 LineDDA(20-2,0,20-2,20-1, @MarchingAnts, AL_DOWN);

 LineDDA(0,20-1,20-1,20-1, @MarchingAnts, AL_LEFT);
 LineDDA(0,20-2,20-1,20-2, @MarchingAnts, AL_LEFT);

 LineDDA(0,20-1,0,0,       @MarchingAnts, AL_UP);
 LineDDA(1,20-1,1,0,       @MarchingAnts, AL_UP);

 Shape1.Bitmap.BeginUpdate;
 Shape1.Bitmap.Assign(FEditCharset.bmarker);
 Shape1.Bitmap.FillRect(2,2,16,16, Color32(transCol));
 Shape1.Bitmap.EndUpdate;

 Shape2.Bitmap.BeginUpdate;
 Shape2.Bitmap.Assign(FEditCharset.bmarker);
 Shape2.Bitmap.FillRect(2,2,16,16, Color32(transCol));
 Shape2.Bitmap.EndUpdate;

end;


procedure TFEditCharset.Timer1Timer(Sender: TObject);
begin
 inc(Offset);

 DrawSelectMarker;

 FEditCharset.Image1.Invalidate;
 FEditCharset.Image3.Invalidate;

end;


procedure TFEditCharset.FormActivate(Sender: TObject);
begin
 _SetFocus;
end;

procedure TFEditCharset.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FEditCharset', top, left);

 form1.EditCharset.Checked:=false;
 
 FEditCharset.Timer1.Enabled:=false;
 Cur:=CurShp;
 Shp:=Point(0,0);

 form1.Shape9Enable(false);

 edit:=false;

 form1.DisableDrawMode;

// Shape2.Free;
 bmarker.Free;
end;


procedure TFEditCharset.Image3Click(Sender: TObject);
begin
 Shp:=ShpCopy;
 Cur:=Point(CurShp.X+ShpCopy.X , CurShp.Y+ShpCopy.Y);

 form1.kafelek(false);

 _SetFocus;
end;


procedure TFEditCharset.Image3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var i, j: byte;
begin
 i:=x shr 4; if i>yel_wid-1 then i:=yel_wid-1;
 j:=y shr 4; if j>yel_hig-1 then j:=yel_hig-1;

 ShpCopy:=Point(i,j);
end;


procedure TFEditCharset.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var src, dst: tfnt;
begin

 case Key of

      vk_left: begin Form1.ZapiszUndo; NaBity(gfxMode[Cur.Y]) end;
     vk_right: begin Form1.ZapiszUndo; NaBity(-gfxMode[Cur.Y]) end;
        vk_up: begin
                Form1.ZapiszUndo;
                lFnt(src);

                move(src, bufor[7], 8);

                move(bufor[8], dst, 7);
                dst[7]:=bufor[7];

                sFnt(dst);
                PrzepiszZnaki;
               end;
      vk_down: begin
                Form1.ZapiszUndo;
                lFnt(src);

                move(src, bufor[8], 8);
                move(bufor[8], dst[1], 7);
                dst[0] := bufor[15];

                sFnt(dst);
                PrzepiszZnaki;
               end;
 end;
 
end;



procedure TFEditCharset.DeleteFNTClick(Sender: TObject);
// DELETE CHARSET
var ch: tcharset;
    i, f: integer;
    lStream: TFileStream;
begin

  i:=Application.MessageBox(PWideChar('Delete charset '''+ComboCharset.Items.Strings[ComboCharset.ItemIndex]+''' ?'),'Delete charset',mb_YESNO+MB_ICONQUESTION);
  case i of
   idYes: begin

           lStream:=TFileStream.Create(form1.GetUndoName(__echar), fmOpenRead );
           f:=FileCreate(form1.GetUndoName('backup_'+__echar), fmOpenWrite );

           for i := 0 to (lStream.Size div sizeof(ch))-1 do begin

            lStream.ReadBuffer(ch, sizeof(ch));

            if i<>ComboCharset.ItemIndex-1 then FileWrite(f, ch, sizeof(ch));

           end;

           lStream.Free;
           FileClose(f);

           DeleteFile(form1.GetUndoName(__echar));
           RenameFile(form1.GetUndoName('backup_'+__echar), form1.GetUndoName(__echar));

           UpdateComboCharset;

          end;
  end;


 _SetFocus;

end;


procedure TFEditCharset.ComboCharsetChange(Sender: TObject);
begin

 znak_X:=0; znak_Y:=0;
 ustaw_kursor_znaku;
// form1.ZaznaczAktualnyZnak(0 , 0);

 form1.ZamienGrafike;

 form1.PokazCharset;

 DeleteFNT.Enabled:=ComboCharset.ItemIndex>0;

 _SetFocus;

end;


procedure TFEditCharset.Copy1Click(Sender: TObject);
// COPY (CTRL + C)
begin
 lFnt(bufZnak);

 old_zestaw[0,0].inv:=false;
 old_zestaw[0,0].inv2:=false;

 move(bufZnak, old_zestaw[0,0].tb, 8);

end;


procedure TFEditCharset.Paste1Click(Sender: TObject);
// PASTE (CTRL + V)
begin
 Form1.ZapiszUndo;
 sFnt(bufZnak);
 PrzepiszZnaki;
end;


procedure TFEditCharset.ComboCharsetCloseUp(Sender: TObject);
begin
 _SetFocus;
end;



procedure TFEditCharset.Fill1Click(Sender: TObject);
// FILL
var fnt: tfnt;
begin
 Form1.ZapiszUndo;
 fillchar(fnt,8,SetZnakKolor);
 sFnt(fnt);
 PrzepiszZnaki;
end;


procedure TFEditCharset.FlipVertical1Click(Sender: TObject);
// FLIP HORIZONTAL
var i: byte;
    src, dst: tfnt;
begin
 Form1.ZapiszUndo;
 lFnt(src);
 for i:=0 to 7 do dst[i] := src[7-i];
 sFnt(dst);
 PrzepiszZnaki;
end;


procedure TFEditCharset.FlipVertical2Click(Sender: TObject);
// FLIP VERTICAL
begin
 Form1.ZapiszUndo;
 NaBity(0);
end;


procedure TFEditCharset.RotateRight1Click(Sender: TObject);
// ROTATE RIGHT
var i, j: integer;
    a: byte;
    src, dst: tfnt;
begin
 Form1.ZapiszUndo;
 lFnt(src);

 fillchar(dst, 8, 0);

 for i := 0 to 7 do begin
  a:=src[i];

  for j := 0 to 7 do begin
   if a and $80<>0 then dst[j]:=dst[j] or twyt1[7-i];
   a:=byte(a shl 1);
  end;

 end;

 sFnt(dst);

 PrzepiszZnaki;
end;


procedure TFEditCharset.RotateLeft1Click(Sender: TObject);
//ROTATE LEFT
var i, j: integer;
    a: byte;
    src, dst: tfnt;
begin
 Form1.ZapiszUndo;
 lFnt(src);

 fillchar(dst, 8, 0);

 for i := 0 to 7 do begin
  a:=src[i];

  for j := 0 to 7 do begin
   if a and 1<>0 then dst[j]:=dst[j] or twyt1[i];
   a:=a shr 1;
  end;

 end;

 sFnt(dst);

 PrzepiszZnaki;
end;


procedure TFEditCharset.FormMouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;

end.

