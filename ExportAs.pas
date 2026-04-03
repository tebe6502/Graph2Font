unit ExportAs;

interface

uses
  Windows, Graphics, Controls, Forms, Menus, StdCtrls, Grids, Dialogs, ExtCtrls,
  Classes, ComCtrls, SysUtils, BMDSpinEdit;

type
  TFExportAs = class(TForm)
    ScrollBox2: TScrollBox;
    Image2: TImage;
    MainMenu1: TMainMenu;
    New1: TMenuItem;
    New2: TMenuItem;
    SaveProject1: TMenuItem;
    New3: TMenuItem;
    StringGrid1: TStringGrid;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button4: TButton;
    Export1: TMenuItem;
    ProgressBar1: TProgressBar;
    Options1: TMenuItem;
    Charsfill1: TMenuItem;
    anm1: TMenuItem;
    scr1: TMenuItem;
    sld1: TMenuItem;
    N1: TMenuItem;
    ashscroll1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Edit5: TMenuItem;
    Insert1: TMenuItem;
    Load1: TMenuItem;
    Remove1: TMenuItem;
    Bevel2: TBevel;
    Bevel1: TBevel;
    N2: TMenuItem;
    N3: TMenuItem;
    seWidth: TBMDSpinEdit;
    seHeight: TBMDSpinEdit;
    seFirst: TBMDSpinEdit;
    seLast: TBMDSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure New3Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure SaveProject1Click(Sender: TObject);
    procedure New2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Charsfill1Click(Sender: TObject);
    procedure anm1Click(Sender: TObject);
    procedure scr1Click(Sender: TObject);
    procedure sld1Click(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Edit5Click(Sender: TObject);
    procedure Remove1Click(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure ustaw_button_export(const i:integer);
    procedure insert_screen;
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure seWidthChange(Sender: TObject);
    procedure seHeightChange(Sender: TObject);
    procedure seFirstChange(Sender: TObject);
    procedure seLastChange(Sender: TObject);
    procedure seWidthContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }

    pack_temp: array [0..2047] of byte;

    singleFrame: Boolean;

  public
    { Public declarations }
  end;

type
__tasm = record
          lin: smallint;
          ope: string[20];
          reg: string[20];
          war: byte;
         end;

 __dli = record
          num: word;
          loa: array [0..31] of string[30];
          reg: array [0..31] of string[30];
          cnt: smallint;
         end;

var
  FExportAs: TFExportAs;
  punkt: Tpoint;
  ratio: byte;
  ins, ins_tmp, lineASM: integer;
  av, bv: byte;
  buf: array [0..65] of byte;

  vscr_use: Boolean = false;

  tabASM: array of __tasm;

  lenPackSCR: array of integer;

  tmpBmp, tmpBmp2: TBitmap;


implementation

uses Main, SelectFolder, CharsFill, LoadScreens;

{$R *.dfm}


procedure GetFirstLastRow(out x,y: integer);
begin
 x:=FExportAs.seFirst.Position;
 y:=FExportAs.seLast.Position;
end;


procedure putPic(const a: AnsiString; const x_,y_:integer);
var i, j, x, y, h, f: integer;
    k, m: PByteArray;
    hea: word;
begin

 if FileExists(a+'.bmp') then begin

 // sprawdzenie czy plik to BMP
 hea:=0;

 f:=FileOpen(a+'.bmp', fmOpenRead);
 FileSeek(f, 0, 0);
 FileRead(f, hea, sizeof(hea));
 FileClose(f);

 if hea = ( byte('B')+byte('M') shl 8 ) then
  tmpBmp.LoadFromFile(a+'.bmp')
 else begin
  form1.Depack_Zlib(a+'.bmp', path+'$$$preview.bmp');
  tmpBmp.LoadFromFile(path+'$$$preview.bmp');
 end;

  GetFirstLastRow(x,y);

  x:=x shl 3; y:=y shl 3; h:=abs(y-x);

  for i:=0 to h-1 do begin
   k:=tmpBmp.ScanLine[i+x];
   m:=tmpBmp2.ScanLine[i+y_];
   for j:=0 to ((Bajt shl 3)*3)-1 do m[x_*3+j] := k[CzarnyPas*3+j];
  end;

 end else
  form1.CustomMessage('File '''+a+'.bmp'+''''+' not found.', 'Load BMP');

end;


function test(const x,y: integer):Boolean;
begin

 Result:=false;

 if not((x<0) or (y<0) or (x>FExportAs.StringGrid1.ColCount) or (y>FExportAs.StringGrid1.RowCount)) then
  if FExportAs.StringGrid1.Cells[x,y]='*' then Result:=true;

end;


procedure TFExportAs.StringGrid1Click(Sender: TObject);
var y1, y2, y: integer;
    b: integer;
    zm:AnsiString;
begin
 zm:=StringGrid1.Cells[punkt.x,punkt.y];

 GetFirstLastRow(y1,y2);

 y1:=y1 shl 3; y2:=y2 shl 3; y:=abs(y2-y1);

 tmpBmp:=TBitmap.Create;
 tmpBmp.PixelFormat:=pf24bit;
 tmpBmp.SetSize(384, 240);

 tmpBmp2:=TBitmap.Create;
 tmpBmp2.PixelFormat:=pf24bit;
 tmpBmp2.SetSize( (Bajt shl 3)*3, y*3);

 image2.Width:=(Bajt shl 3)*3; image2.Height:=y*3;

 with tmpBmp2.canvas do begin
  Pen.Color:=0; Brush.Color:=0; Rectangle(0,0,tmpBmp2.Width,tmpBmp2.Height);
 end;

// wczytaj 9 plikow BMP (po 3 w poziomie) i stworz z nich obrazek
// 1-rzadek
 if not(FExportAs.SingleFrame) then begin

 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x-1)+'_'+IntToStr(punkt.y-1);
 if test(punkt.x-1,punkt.y-1) then putPic(zm,0,0);

 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x)+'_'+IntToStr(punkt.y-1);
 if test(punkt.x,punkt.y-1) then putPic(zm,Bajt shl 3,0);

 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x+1)+'_'+IntToStr(punkt.y-1);
 if test(punkt.x+1,punkt.y-1) then putPic(zm,(Bajt shl 3) shl 1,0);

// 2-rzadek
 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x-1)+'_'+IntToStr(punkt.y);
 if test(punkt.x-1,punkt.y) then putPic(zm,0,y);

 end;

 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x)+'_'+IntToStr(punkt.y);
 if test(punkt.x,punkt.y) then putPic(zm,Bajt shl 3,y);


 if not(FExportAs.SingleFrame) then begin

 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x+1)+'_'+IntToStr(punkt.y);
 if test(punkt.x+1,punkt.y) then putPic(zm,(Bajt shl 3) shl 1,y);

// 3-rzadek
 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x-1)+'_'+IntToStr(punkt.y+1);
 if test(punkt.x-1,punkt.y+1) then putPic(zm,0,y shl 1);

 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x)+'_'+IntToStr(punkt.y+1);
 if test(punkt.x,punkt.y+1) then putPic(zm,Bajt shl 3,y shl 1);

 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x+1)+'_'+IntToStr(punkt.y+1);
 if test(punkt.x+1,punkt.y+1) then putPic(zm,(Bajt shl 3) shl 1,y shl 1);

 end;
 
 image2.Canvas.Draw(0,0,tmpBmp2);

 tmpBmp.Free; tmpBmp2.Free;


// a:=165;
 b:=(y-(248-y) shr 1)+4;
 scrollbox2.HorzScrollBar.Position:=Bajt shl 3-(384-(Bajt shl 3)) shr 1;
 scrollbox2.VertScrollBar.Position:=b;
end;


procedure TFExportAs.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 PopupMenu1.Items[1].Enabled:= (gate>0) and not(Blokada);

 if Button4.Enabled then
  if button=mbRight then PopupMenu1.Popup(x+FExportAs.Left+12, y+FExportAs.Top+40);
end;


procedure TFExportAs.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin

 punkt:=Point(ACol,ARow);

end;


procedure TFExportAs.New3Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* NEW MAP                                                                    *)
(*----------------------------------------------------------------------------*)
var i, j: integer;
    a,b,c: string;
begin
// if mapa_path<>'' then form15.DirectoryListBox1.Directory:=ExtractFilePath(mapa_path);

 a:=mapa_path;
 b:=mapa_plik;
 c:=pomoc_mapa;

 FSelectFolder.Caption:='Select Folder ('+mapa_path+')';

 if FSelectFolder.ShowModal=mrOK then begin

  Button4.Enabled:=true;
  FExportAs.ustaw_button_export(0);
  seWidth.Enabled:=true;
  seHeight.Enabled:=true;

  mapa_plik:=ExtractFileName(mapa_path);  // mapa_path ustawiane w SelectFolder
  pomoc_mapa := mapa_plik;

  for j:=0 to 127 do
   for i:=0 to 255 do FExportAs.StringGrid1.Cells[j,i]:='';

 end else begin
  mapa_path:=a;
  mapa_plik:=b;
  pomoc_mapa:=c;
 end;

 if not(mapa_path[length(mapa_path)] in ['\','/']) then mapa_path:=mapa_path+'\';

// if mapa_path[length(mapa_path)]<>'\' then mapa_plik:='\'+mapa_plik;
   

 FExportAs.Caption:='Edit Maps ('+mapa_path+')';
 form1.OpenDialog1.FileName:=mapa_path;

end;


procedure TFExportAs.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then form1.Zamknij(f_ExportAs);
end;


procedure TFExportAs.insert_screen;
(*----------------------------------------------------------------------------*)
(* INSERT SCREEN                                                              *)
(*----------------------------------------------------------------------------*)
var ARect, ARect_des: TRect;
    txt, zm: string;
begin
 if not((gate>0) and not(Blokada)) then exit;

 if form1.Showchars1.Checked then form1.OdswiezObraz;

 FExportAs.StringGrid1.Cells[punkt.x,punkt.y]:='*';

// val(edit3.Text,y1,y); val(edit4.Text,y2,y);
// y1:=y1 shl 3; y2:=y2 shl 3;

 tmpBmp:=TBitmap.Create;
 tmpBmp.PixelFormat:=pf24bit;
 tmpBmp.SetSize(384, 240);

 with tmpBmp.Canvas do begin
  ARect_des := Rect(CzarnyPas,0,CzarnyPas+Bajt*8,240);
  ARect := Rect(CzarnyPas,0,Bajt*8+CzarnyPas,240); // get bitmap rectangle
  CopyRect(ARect_des, form1.image1.canvas, ARect); // copy bitmap
 end;

 zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x)+'_'+IntToStr(punkt.y);
 tmpBmp.SaveToFile(path+'$$$preview.bmp');
 tmpBmp.Free;

 form1.Pack_Zlib(path+'$$$preview.bmp', zm+'.bmp');

// zapis pliku G2F pod nowa nazwa
 txt:=form1.Savedialog1.FileName;
 form1.Savedialog1.FileName:=zm+'.g2f'; form1.SaveG2F1Click(FExportAs);
 form1.Savedialog1.FileName:=txt;

 FExportAs.StringGrid1Click(FExportAs); // odswiez podglad
end;


procedure show_title;
begin
 FExportAs.Caption:='Export ('+mapa_path+')';
end;


procedure TFExportAs.ustaw_button_export(const i: integer);
var a: string;
begin
 a:='Export ';

 if FExportAs.anm1.Checked then a:=a+'as animation' else
  if FExportAs.ashscroll1.Checked then a:=a+'as hscroll' else
   if FExportAs.scr1.Checked then a:=a+'as vscroll' else
    if FExportAs.sld1.Checked then a:=a+'as slideshow';

 if i>0 then a:=a+' ('+IntToStr(i)+')';

 FExportAs.Button4.Caption:=a;
end;


procedure TFExportAs.New2Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* OPEN MAP                                                                   *)
(*----------------------------------------------------------------------------*)
var i, j, f: integer;
    z: AnsiChar;
    txt: string;
    bufor: array [0..511] of byte;
begin

OpenDialog1.InitialDir := ExtractFileDir(mapa_path);
OpenDialog1.FileName   := ExtractFileName(mapa_path);

OpenDialog1.DefaultExt:='.map';

ustaw_button_export(0);

 if OpenDialog1.Execute then begin

  for j:=0 to 127 do
   for i:=0 to 255 do FExportAs.StringGrid1.Cells[j,i]:='';

  txt:=OpenDialog1.FileName;

  f:=FileOpen(txt, fmOpenRead);
  FileSeek(f, 0, 0);

// odczytaj parametry mapy
  FileRead(f,bufor,6);

  button4.Enabled:=true;

  seWidth.Enabled:=true;
  seHeight.Enabled:=true;

  StringGrid1.ColCount:=bufor[0];
  StringGrid1.RowCount:=bufor[1];

  seWidth.Value  := bufor[0];
  seHeight.Value := bufor[1];
  seFirst.Value  := bufor[2];   // from ROW
  seLast.Value   := bufor[3];   // to ROW

  form1.SelectScreen.ItemIndex:=bufor[4];

  mapa_path:=ExtractFilePath(txt);

  show_title;

  mapa_plik:=''; pomoc_mapa:='';
  for i:=1 to bufor[5] do begin
   FileRead(f,z,sizeof(z));
   mapa_plik:=mapa_plik+z;
  end;

  pomoc_mapa:=mapa_plik;
  if pomoc_mapa[1] in ['\','/'] then pomoc_mapa:=copy(pomoc_mapa,2,length(pomoc_mapa));

  if not(mapa_path[length(mapa_path)] in ['\','/']) then mapa_plik:='\'+mapa_plik;


   for j:=0 to bufor[1]-1 do begin

    FileRead(f,bufor[256],bufor[0]);

    for i:=0 to bufor[0]-1 do
     if bufor[256+i]>0 then
      StringGrid1.Cells[i,j]:='*'
     else
      StringGrid1.Cells[i,j]:=' ';

   end;

  FileClose(f);

  punkt:=Point(0,0);

  StringGrid1Click(FExportAs);
 end;

 FExportAs.SetFocus;
end;


procedure TFExportAs.SaveDialog1TypeChange(Sender: TObject);
begin
// !!! zmiana rozszerzenia nie dziala w locie, ale bez tego wogole nie bedzie zapisywal plikow
end;


procedure TFExportAs.SaveProject1Click(Sender: TObject);
var i, j, f: integer;
    zm, zm2, zm3: string;
begin

 if not(Button4.Enabled) then exit;

 SaveDialog1.InitialDir := ExtractFileDir(mapa_path);
 SaveDialog1.FileName   := ExtractFileName(mapa_path);

 SaveDialog1.DefaultExt:='.map';

 if SaveDialog1.Execute then begin

// zapisz parametry mapy
  bufor[0] := seWidth.Position;
  bufor[1] := seHeight.Position;
  bufor[2] := seFirst.Position;
  bufor[3] := seLast.Position;

  bufor[4]:=form1.SelectScreen.ItemIndex;
  bufor[5]:=length(pomoc_mapa);

 zm:=SaveDialog1.FileName;
 zm2:=ExtractFileName(zm);
 zm3:=ExtractFileExt(zm2);
 if zm3<>'' then zm2:=copy(zm2,1,pos(zm3,zm2)-1);
 SaveDialog1.FileName:=zm2;

  f:=FileCreate(zm);

  FileWrite(f,bufor,6);
  for i:=1 to bufor[5] do FileWrite(f,pomoc_mapa[i],1);

  for j:=0 to bufor[1]-1 do begin
   for i:=0 to bufor[0]-1 do
    if StringGrid1.Cells[i,j]='*' then
     bufor[256+i]:=1
    else
     bufor[256+i]:=0;

   FileWrite(f,bufor[256],bufor[0]);
  end;

  FileClose(f);
 end;
end;


procedure TestStore(var f_all: file; var s:integer);
var x: integer;
begin

 if s>64 then
  while s>64 do begin
   buf[0]:=63 or $c0;
   for x:=0 to 63 do buf[x+1]:=FExportAs.pack_temp[ins+x];
   blockwrite(f_all,buf,65);
   dec(s,64); inc(ins,64);
  end;

 if s>0 then begin
  buf[0]:=(s-1) or $c0;
  for x:=0 to s-1 do buf[x+1]:=FExportAs.pack_temp[ins+x];
  blockwrite(f_all,buf,s+1);
  s:=0;
 end;
 
end;


procedure Store(var s: integer);
begin
 if s=0 then ins:=ins_tmp;
 inc(s); av:=bv;
end;


procedure PackSCR(var f_all: file; len:integer);
var i, k, s: integer;
    v: byte;
begin

{ -* KOMPRESJA *- }
i:=0; s:=0;

av:=FExportAs.pack_temp[i]; inc(i);

while i<len do begin
bv:=FExportAs.pack_temp[i]; inc(i);
ins_tmp:=i-2;

 if av=bv then begin
  k:=2;
  v:=av;
  while (bv=FExportAs.pack_temp[i]) and (k<64) and (i<len) do begin
   inc(i); inc(k);
  end;
  if k>2 then begin
   TestStore(f_all, s);
   buf[0]:=(k-1) or $80; buf[1]:=v;
   blockwrite(f_all,buf,2);
   s:=0; av:=FExportAs.pack_temp[i]; inc(i);
  end else Store(s);

 end else if (bv-av=1) then begin
  k:=2;
  v:=av;
  while (FExportAs.pack_temp[i]-bv=1) and (k<64) and (i<len) do begin
   bv:=FExportAs.pack_temp[i]; inc(i); inc(k);
  end;
  if k>2 then begin
   TestStore(f_all, s);
   buf[0]:=(k-1) or $40; buf[1]:=v+k-1;
   blockwrite(f_all,buf,2);
   s:=0; av:=FExportAs.pack_temp[i]; inc(i);
  end else Store(s);

 end else Store(s);

end;

TestStore(f_all, s);

buf[0]:=0;
blockwrite(f_all,buf,1);

i:=High(lenPackSCR);

lenPackSCR[i]:=integer(FilePos(f_all));

SetLength(lenPackSCR, i+2);
end;


procedure sav(const a:byte; const w:word);
var zm1, zm2, tx: string;
    i: integer;
begin
 zm1:=IntToHex(a,2);
 zm2:=form1.Hex(w,4);

 tx:=form1.reg_label(w);
 if tx<>'' then zm2:=tx;

 tx:='#$';
 if w=$d409 then tx:='>fnt+.get['+IntToStr(lineASM)+'/8]*$4';

 if a<>tmp[w-$d000] then begin

  i:=High(tabASM);
  tabASM[i].lin:=lineASM;
  tabASM[i].ope:=tx;

  if w=$d409 then tabASM[i].war:=0 else tabASM[i].war:=a;
  tabASM[i].reg:=zm2;

  SetLength(tabASM,i+2);

  tmp[w-$d000]:=a;
 end;
 
end;


procedure SaveChange(const pr:byte);
var x, y: byte;
    v: word;
    y0, y1, y2, y3: smallint;
     my0, my1, my2, my3: smallint;
    mx0, mx1, mx2, mx3: byte;
    m0, m1, m2, m3: byte;
begin
sav(tabKolor[px+$000],$d01a); if locKolor[px+$000] then tmp[$1a]:=-100;
sav(tabKolor[px+$100],$d016); if locKolor[px+$100] then tmp[$16]:=-100;
sav(tabKolor[px+$200],$d017); if locKolor[px+$200] then tmp[$17]:=-100;
sav(tabKolor[px+$300],$d018); if locKolor[px+$300] then tmp[$18]:=-100;
sav(tabKolor[px+$400],$d019); if locKolor[px+$400] then tmp[$19]:=-100;

sav(pr or gtia,$d01b);

v:=Spr0[px]; x:=v shr 8; y0:=(v and $00ff)+32;
if x>127 then y0:=0 else begin x:=x and $f;
if x>0 then dec(x); sav(x,$d008); end;

v:=Spr1[px]; x:=v shr 8; y1:=(v and $00ff)+32;
if x>127 then y1:=0 else begin x:=x and $f;
if x>0 then dec(x); sav(x,$d009); end;

v:=Spr2[px]; x:=v shr 8; y2:=(v and $00ff)+32;
if x>127 then y2:=0 else begin x:=x and $f;
if x>0 then dec(x); sav(x,$d00a); end;

v:=Spr3[px]; x:=v shr 8; y3:=(v and $00ff)+32;
if x>127 then y3:=0 else begin x:=x and $f;
if x>0 then dec(x); sav(x,$d00b); end;

v:=Mis0[px]; mx0:=v shr 8; my0:=(v and $00ff)+32;
v:=Mis1[px]; mx1:=v shr 8; my1:=(v and $00ff)+32;
v:=Mis2[px]; mx2:=v shr 8; my2:=(v and $00ff)+32;
v:=Mis3[px]; mx3:=v shr 8; my3:=(v and $00ff)+32;

x:=0; y:=0;
if mx0<128 then begin m0:=mx0 and $f; if m0>0 then dec(m0); x:=m0; y:=3; end;
if mx1<128 then begin m1:=mx1 and $f; if m1>0 then dec(m1); x:=x or (m1 shl 2); y:=y or $0c; end;
if mx2<128 then begin m2:=mx2 and $f; if m2>0 then dec(m2); x:=x or (m2 shl 4); y:=y or $30; end;
if mx3<128 then begin m3:=mx3 and $f; if m3>0 then dec(m3); x:=x or (m3 shl 6); y:=y or $c0; end;

if ((old_m and y)<>x) then begin sav(x,$d00c); old_m:=x end;

if y0>0 then sav(y0,$d000);
if y1>0 then sav(y1,$d001);
if y2>0 then sav(y2,$d002);
if y3>0 then sav(y3,$d003);

if mx0<128 then sav(my0,$d004);
if mx1<128 then sav(my1,$d005);
if mx2<128 then sav(my2,$d006);
if mx3<128 then sav(my3,$d007);

if (y0>0) or (mx0<128) then sav(tabKolor[px+$500],$d012);
if (y1>0) or (mx1<128) then sav(tabKolor[px+$600],$d013);
if (y2>0) or (mx2<128) then sav(tabKolor[px+$700],$d014);
if (y3>0) or (mx3<128) then sav(tabKolor[px+$800],$d015);
end;


procedure SaveVBL;
var x, y, pr: byte;
    v, _x: word;
    y0, y1, y2, y3: smallint;
     my0, my1, my2, my3: smallint;
    mx0, mx1, mx2, mx3: byte;
    m0, m1, m2, m3: byte;
begin
fillchar(tmp,sizeof(tmp),-100);  old_m:=-100;

for _x:=0 to Wysokosc-1 do begin

px := _x;

gtia:=form1.SetGTIAValue(gfxMode[px shr 3]);

pr:=form1.ObliczPiorytet(px);

if tmp[$409]<0 then sav(table[px shr 3],$d409);

if tmp[$01a]<0 then sav(tabKolor[px+$000],$d01a);       //712
if tmp[$016]<0 then sav(tabKolor[px+$100],$d016);       //708
if tmp[$017]<0 then sav(tabKolor[px+$200],$d017);       //709
if tmp[$018]<0 then sav(tabKolor[px+$300],$d018);       //710
if tmp[$019]<0 then sav(tabKolor[px+$400],$d019);       //711

if tmp[$01b]<0 then sav(pr or gtia,$d01b);

v:=Spr0[px]; x:=v shr 8; y0:=(v and $00ff)+32;
if x>127 then y0:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$008]<0 then sav(x,$d008); end;

v:=Spr1[px]; x:=v shr 8; y1:=(v and $00ff)+32;
if x>127 then y1:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$009]<0 then sav(x,$d009); end;

v:=Spr2[px]; x:=v shr 8; y2:=(v and $00ff)+32;
if x>127 then y2:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$00a]<0 then sav(x,$d00a); end;

v:=Spr3[px]; x:=v shr 8; y3:=(v and $00ff)+32;
if x>127 then y3:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$00b]<0 then sav(x,$d00b); end;

v:=Mis0[px]; mx0:=v shr 8; my0:=(v and $00ff)+32;
v:=Mis1[px]; mx1:=v shr 8; my1:=(v and $00ff)+32;
v:=Mis2[px]; mx2:=v shr 8; my2:=(v and $00ff)+32;
v:=Mis3[px]; mx3:=v shr 8; my3:=(v and $00ff)+32;

// X to nowy rozmiar, Y to maska dla operacji AND
// dzieki temu jednoznacznie stwierdzimy czy rozmiar sie zmienil
x:=0; y:=0;
if mx0<128 then begin m0:=mx0 and $f; if m0>0 then dec(m0); x:=m0; y:=y or $03 end;
if mx1<128 then begin m1:=mx1 and $f; if m1>0 then dec(m1); x:=x or (m1 shl 2); y:=y or $0c end;
if mx2<128 then begin m2:=mx2 and $f; if m2>0 then dec(m2); x:=x or (m2 shl 4); y:=y or $30 end;
if mx3<128 then begin m3:=mx3 and $f; if m3>0 then dec(m3); x:=x or (m3 shl 6); y:=y or $c0 end;

if (tmp[$00c]<0) and ((old_m and y)<>x) then begin old_m:=x; sav(x,$d00c) end;

if (tmp[$000]<0) and (y0>0) then sav(y0,$d000);
if (tmp[$001]<0) and (y1>0) then sav(y1,$d001);
if (tmp[$002]<0) and (y2>0) then sav(y2,$d002);
if (tmp[$003]<0) and (y3>0) then sav(y3,$d003);

if (tmp[$004]<0) and (mx0<128) then sav(my0,$d004);
if (tmp[$005]<0) and (mx1<128) then sav(my1,$d005);
if (tmp[$006]<0) and (mx2<128) then sav(my2,$d006);
if (tmp[$007]<0) and (mx3<128) then sav(my3,$d007);

if (tmp[$012]<0) and ((y0>0) or (mx0<128)) then sav(tabKolor[px+$500],$d012);
if (tmp[$013]<0) and ((y1>0) or (mx1<128)) then sav(tabKolor[px+$600],$d013);
if (tmp[$014]<0) and ((y2>0) or (mx2<128)) then sav(tabKolor[px+$700],$d014);
if (tmp[$015]<0) and ((y3>0) or (mx3<128)) then sav(tabKolor[px+$800],$d015);

end;

end;


procedure SaveVBL2(const H,H2: integer);
var x, y, pr: byte;
    v, _x: word;
    y0, y1, y2, y3: smallint;
    my0, my1, my2, my3: smallint;
    mx0, mx1, mx2, mx3: byte;
    m0, m1, m2, m3: byte;
begin

for _x:=H to H2 do begin

px := _x;

gtia:=form1.SetGTIAValue(gfxMode[px shr 3]);

pr:=form1.ObliczPiorytet(px);

if tmp[$409]<0 then sav(table[px shr 3],$d409);

if tmp[$01a]<0 then sav(tabKolor[px+$000],$d01a);       //712
if tmp[$016]<0 then sav(tabKolor[px+$100],$d016);       //708
if tmp[$017]<0 then sav(tabKolor[px+$200],$d017);       //709
if tmp[$018]<0 then sav(tabKolor[px+$300],$d018);       //710
if tmp[$019]<0 then sav(tabKolor[px+$400],$d019);       //711

if tmp[$01b]<0 then sav(pr or gtia,$d01b);

v:=Spr0[px]; x:=v shr 8; y0:=(v and $00ff)+32;
if x>127 then y0:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$008]<0 then sav(x,$d008); end;

v:=Spr1[px]; x:=v shr 8; y1:=(v and $00ff)+32;
if x>127 then y1:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$009]<0 then sav(x,$d009); end;

v:=Spr2[px]; x:=v shr 8; y2:=(v and $00ff)+32;
if x>127 then y2:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$00a]<0 then sav(x,$d00a); end;

v:=Spr3[px]; x:=v shr 8; y3:=(v and $00ff)+32;
if x>127 then y3:=0 else begin x:=x and $f;
if x>0 then dec(x); if tmp[$00b]<0 then sav(x,$d00b); end;

v:=Mis0[px]; mx0:=v shr 8; my0:=(v and $00ff)+32;
v:=Mis1[px]; mx1:=v shr 8; my1:=(v and $00ff)+32;
v:=Mis2[px]; mx2:=v shr 8; my2:=(v and $00ff)+32;
v:=Mis3[px]; mx3:=v shr 8; my3:=(v and $00ff)+32;

// X to nowy rozmiar, Y to maska dla operacji AND
// dzieki temu jednoznacznie stwierdzimy czy rozmiar sie zmienil
x:=0; y:=0;
if mx0<128 then begin m0:=mx0 and $f; if m0>0 then dec(m0); x:=m0; y:=y or $03 end;
if mx1<128 then begin m1:=mx1 and $f; if m1>0 then dec(m1); x:=x or (m1 shl 2); y:=y or $0c end;
if mx2<128 then begin m2:=mx2 and $f; if m2>0 then dec(m2); x:=x or (m2 shl 4); y:=y or $30 end;
if mx3<128 then begin m3:=mx3 and $f; if m3>0 then dec(m3); x:=x or (m3 shl 6); y:=y or $c0 end;

if (tmp[$00c]<0) and ((old_m and y)<>x) then begin old_m:=x; sav(x,$d00c) end;

if (tmp[$000]<0) and (y0>0) then sav(y0,$d000);
if (tmp[$001]<0) and (y1>0) then sav(y1,$d001);
if (tmp[$002]<0) and (y2>0) then sav(y2,$d002);
if (tmp[$003]<0) and (y3>0) then sav(y3,$d003);

if (tmp[$004]<0) and (mx0<128) then sav(my0,$d004);
if (tmp[$005]<0) and (mx1<128) then sav(my1,$d005);
if (tmp[$006]<0) and (mx2<128) then sav(my2,$d006);
if (tmp[$007]<0) and (mx3<128) then sav(my3,$d007);

if (tmp[$012]<0) and ((y0>0) or (mx0<128)) then sav(tabKolor[px+$500],$d012);
if (tmp[$013]<0) and ((y1>0) or (mx1<128)) then sav(tabKolor[px+$600],$d013);
if (tmp[$014]<0) and ((y2>0) or (mx2<128)) then sav(tabKolor[px+$700],$d014);
if (tmp[$015]<0) and ((y3>0) or (mx3<128)) then sav(tabKolor[px+$800],$d015);

end;

end;


procedure Etykiety_zakres(var f: textfile; const _od,_do:integer);
var i: integer;
begin

 if not SpecialStr[___ShortLabels].val then
  for i:=_od to _do do
   writeln(f, form1.reg_label(i),#9,'= $',IntToHex(i,4));

end;


procedure liniaDLI(var f:textfile; var dli:__dli; var cnt:byte);
var i: byte;
begin

 if cnt=0 then exit;

 if cnt in [1,2] then begin

  case cnt of
   1: begin                       // zapisz jedna zmiane
       writeln(f, dli.loa[0]);
       writeln(f, ' sta $d40a',#9,';',dli.cnt);
       writeln(f, dli.reg[0]);
      end;
   2: begin                       // zapisz dwie zmiany
       writeln(f, dli.loa[0]);
       writeln(f, dli.loa[1]);
       writeln(f, ' sta $d40a',#9,';',dli.cnt);
       writeln(f, dli.reg[0]);
       writeln(f, dli.reg[1]);
      end;
  end;

 end else begin                   // zapisz wszystkie zmiany
  writeln(f, dli.loa[0]);
  writeln(f, dli.loa[1]);
  writeln(f, dli.loa[2]);
  writeln(f, ' sta $d40a',#9,';',dli.cnt);
  writeln(f, dli.reg[0]);
  writeln(f, dli.reg[1]);
  writeln(f, dli.reg[2]);

  for i:=3 to cnt-1 do begin
   writeln(f, dli.loa[i]);
   writeln(f, dli.reg[i]);
  end;
 end;

 if cnt>4 then writeln(f, ';!!!',cnt);

 writeln(f, 'd',dli.num);
 inc(dli.num);
 inc(dli.cnt);

 cnt:=0;
end;


procedure liczCRC(var crc_:cardinal; txt:string);
var l: cardinal;
    b, i: byte;
begin
 for i:=1 to length(txt) do begin
  b:=(crc_ and $ff) xor ord(txt[i]);
  l:=(crc_ shr 8) and $00ffffff;
  crc_:=tcrc32[b] xor l;
 end;
end;


procedure LoadG2F(const ab: tCharCompres; const x,y: integer; zm: string);
var txt: string;
    k, m: integer;
begin

    txt:=current_filename;

    current_filename:=zm+'.g2f';
    form1.OpenDialog1.FileName:=current_filename;

    SaveAfterExit:=false;

    form1.PreviewButton;

    current_filename:=txt;

    form1.ZnakCheck(ab);

    form1.cnv;

// czyscimy X pierwszych wierszy
    if x>0 then
     for k:=0 to x-1 do fillchar(tab[k*384],384,0);

// czyscimy koncowe wiersze
    m:=30-(x+y);
    if m>0 then
     for k:=0 to m-1 do fillchar(tab[(x+y+k)*384],384,0);

end;


procedure CreateASM;
(*----------------------------------------------------------------------------*)
(* tworzymy program dla scrola pionowego                                      *)
(* przerwanie DLI max co 8 linii                                              *)
(*----------------------------------------------------------------------------*)
type
    crcData = record
               crc: cardinal;
               lin: integer;
              end;

    vblData = record
               vbl: integer;
               lin: integer;
              end;

var f: textfile;
    ifile, ofile, len, idx: integer;
    i, l, k, m, err, hlp, klatki, x, y, ile_klatek: integer;
    cnt, j, p: byte;
    vbl: word;
    reg: char;
    dli: __dli;
    crc_, cr: cardinal;
    hit, b: Boolean;
    tscr: array of integer;
    tOptyVBL: array of vblData;
    tbcrc_: array of crcData;
    tbstr_: array of string;
    value: array [0..255] of Boolean;
    wiersz: array [0..47] of Byte;
    zm: string;
    ab: tCharCompres;
//    frame0, frame1: TMemoryStream;
begin

ile_klatek := FExportAs.seHeight.Position;

reg:=' ';

assignfile(f, mapa_path+'Atari\'+mapa_plik+'.asm'); rewrite(f);

writeln(f, #13#10+'scr48'+#9+'= %00111111	;screen 48b');
writeln(f, 'scr40'+#9+'= %00111110	;screen 40b');
writeln(f, 'scr32'+#9+'= %00111101	;screen 32b',#13#10);

writeln(f, 'regA',#9,'= $80');
writeln(f, 'regX',#9,'= regA+1');
writeln(f, 'regY',#9,'= regX+1');
writeln(f, 'temp',#9,'= regY+1',#13#10);

writeln(f, 'pmg',#9,'= $c000',#13#10);

Etykiety_zakres(f,$d000,$d00c);
Etykiety_zakres(f,$d012,$d01b);

writeln(f, 'vscrol'#9'= $d405');
writeln(f, 'chbase'#9'= $d409'#13#10);

writeln(f, 'width',#9,'= ',Bajt);
writeln(f, 'height',#9,'= 22'#13#10);

writeln(f, 'ile',#9,'= ',ile_klatek*30,'-height'#13#10);

writeln(f, 'rows'#9'= ',ile_klatek*30,'*width>$1000');


writeln(f, #13#10'*---'#13#10);

writeln(f, #9'org $2000',#13#10);

writeln(f, 'screen');
writeln(f, #9,'ift rows');
writeln(f, #9'ins "',mapa_plik,'.row"');
writeln(f, #9'els');
writeln(f, #9'ins "',mapa_plik,'.scr"');
writeln(f, #9'eif'#13#10);

writeln(f, #9'.ALIGN'#9'$100');
writeln(f, 'ant'#9':(30-height-1)/2 dta $70');
writeln(f, #9'dta $f0');

writeln(f, 'scr');
writeln(f, #9'ift rows');
writeln(f, #9':height dta $62,a(screen+#*width)');
writeln(f, #9'els');
writeln(f, #9'dta $62,a(screen)');
writeln(f, #9':height-2 dta $22');
writeln(f, #9'dta $02');
writeln(f, #9'eif'#13#10);

writeln(f, #9'dta $41,a(ant)'#13#10);

writeln(f, 'gfxmode'#9'ins "',mapa_plik,'.gfx"'#13#10);

writeln(f, #9'.ALIGN'#9'$400');
writeln(f, 'fnt'#9'ins "',mapa_plik,'.fnt"');

writeln(f, #13#10#9'.get "',mapa_plik,'.tab"');

writeln(f, #13#10#9'ert *>$BFFF,"no ram"');

writeln(f, #13#10'*---'#13#10);

writeln(f, 'main');

writeln(f, #9'mva'#9'>pmg'#9'$d407');
writeln(f, #9'mva'#9'#3'#9'$d01d',#13#10);

writeln(f, #9'lda:cmp:req 20'+#9#9+';wait 1 frame',#13#10);

writeln(f, #9'sei'+#9+#9+#9+';stop interrups');
writeln(f, #9'mva'#9'#0'#9'$d40e'+#9+';stop all interrupts');
writeln(f, #9'mva'#9'#$fe'#9'$d301'+#9+';switch off ROM to get 16k more ram'+#13#10);

writeln(f, #9'INIT:UPDATE');
writeln(f, #9'ldy'#9'#0');
writeln(f, #9'jsr'#9'CREATE._nxt',#13#10);

writeln(f, #9'mwa'#9'#nmi'#9'$fffa'+#9+';new NMI handler'+#13#10);

writeln(f, #9'mva'#9'#$c0'#9'$d40e'+#9+';switch on NMI+DLI again'+#13#10);

writeln(f, #9'ift ile=0');
writeln(f, #9'jmp *');
writeln(f, #9'els');
writeln(f, #9'jmp prg');
writeln(f, #9'eif');

writeln(f, #13#10,'*---',#13#10);

writeln(f, 'nmi'#9'bit'#9'$d40f');
writeln(f, #9'bpl'#9'vbl'#13#10);

writeln(f, #9'sta'#9'regA');
writeln(f, #9'stx'#9'regX');
writeln(f, #9'sty'#9'regY'#13#10);

writeln(f, 'dliv'#9'jmp d0'#13#10);

writeln(f, 'nmiQ'#9'lda'#9'regA');
writeln(f, #9'ldx'#9'regX');
writeln(f, #9'ldy'#9'regY');
writeln(f, #9'rti'+#13#10);

writeln(f, 'vbl'#9'phr');
writeln(f, #9'sta'#9'$d40f');
writeln(f, #9'inc'#9'20'#13#10);

writeln(f, #9'mwa'#9'#ant'#9'$d402');
writeln(f, #9'mva'#9'#scr',Bajt,#9'$d400',#13#10);

writeln(f, 'ffnt'#9'mva'#9'>fnt'#9'$d409',#13#10);

writeln(f, 'ivbl'#9'jsr'#9'v0',#13#10);

writeln(f, 'ldli'#9'mva'#9'<d0'#9'dliv+1');
writeln(f, 'hdli'#9'mva'#9'>d0'#9'dliv+2',#13#10);

writeln(f, #9'plr:rti'#13#10);

writeln(f, '*---'+#13#10);

// zapisujemy program DLI
cnt:=0;
dli.num:=1;
dli.cnt:=0;

writeln(f, 'd0');

for i:=0 to High(tabASM)-1 do
 if tabASM[i].lin>0 then begin

  if tabASM[i].lin<>tabASM[i-1].lin then begin

    if cnt>0 then
     p:=1
    else
     p:=0;

    liniaDLI(f,dli,cnt);

    l:=tabASM[i].lin - tabASM[i-1].lin;

    for k:=p to l-1 do begin
     writeln(f, ' sta $d40a',#9,';',dli.cnt);
     writeln(f, 'd',dli.num);
     inc(dli.num);
     inc(dli.cnt);
    end;

  end;

   case cnt of
    0: reg:='a';
    1: reg:='x';
    2: reg:='y';
   end;

   dli.loa[cnt]:=' ld'+reg+' '+tabASM[i].ope+IntToHex(tabASM[i].war,2);
   dli.reg[cnt]:=' st'+reg+' '+tabASM[i].reg;

   inc(cnt);
end;

liniaDLI(f,dli,cnt);

while dli.cnt<=ile_klatek*240 do begin
 writeln(f, ' sta $d40a',#9,';',dli.cnt);
 writeln(f, 'd',dli.num);
 inc(dli.num);
 inc(dli.cnt);
end;

writeln(f, ' jmp nmiQ',#13#10);


write(f, 'l_dli');
for i:=0 to dli.num-1 do begin

 if i mod 8=0 then begin
  if i<>0 then writeln(f, ')');
  write(f, #9'dta l(');
 end else write(f, ',');

 write(f, 'd',i);

end;
writeln(f, ')',#13#10);


write(f, 'h_dli');
for i:=0 to dli.num-1 do begin

 if i mod 8=0 then begin
  if i<>0 then writeln(f, ')');
  write(f, #9'dta h(');
 end else write(f, ',');

 write(f, 'd',i);

end;
writeln(f, ')',#13#10);

 flush(f);


// tutaj generujemy przerwania VBL i jeszcze raz wczytujemy wszystkie grafiki

 SetLength(tbcrc_,1);
 vbl:=0;

 ab:=ccOptymizing;

 GetFirstLastRow(x,y); dec(y, x);

 SetLength(tOptyVBL, 1);

for klatki:=0 to ile_klatek-1 do begin

 zm:=mapa_path+mapa_plik+'_0_'+IntToStr(klatki);     // 1-a klatka
 LoadG2F(ab,x,y,zm);

 zm:=mapa_path+mapa_plik+'_0_'+IntToStr(klatki+1);   // nastepna klatka
 if FileExists(zm) then begin
  LoadG2F(ab,x,y,zm);
 end;


 for k:=0 to 239 do begin

// frame0

  lineASM:=vbl;

  SetLength(tabASM,1);

  fillchar(tmp,sizeof(tmp),-100);  old_m:=-100;

  SaveVBL2(k,239);

(* -------------------------------------------------------------------------- *)

  if FileExists(zm) then begin                      // nastepna klatka

//   frame1

   if k<>0 then SaveVBL2(0,k);
  end;

  SetLength(tbstr_, 1);

  writeln(f, 'v', vbl);

 // tworzymy program NMI i VBL
  fillchar(value,sizeof(value),false);

  for m:=0 to High(tabASM)-1 do
   if tabASM[m].war in [0..255] then value[tabASM[m].war]:=true;

  crc_:=$ffffffff;

  for err:=0 to 255 do
   if value[err] then begin

    hlp:=High(tbstr_);
    tbstr_[hlp]:=' lda #$'+IntToHex(err,2);
    SetLength(tbstr_,hlp+2);

    for m:=0 to High(tabASM)-1 do
     if tabASM[m].war=err then
      if (AnsiUpperCase(tabASM[m].reg)<>'CHBASE') and (AnsiUpperCase(tabASM[m].reg)<>'$D409') then begin

       hlp:=High(tbstr_);
       tbstr_[hlp]:=' sta '+tabASM[m].reg;
       SetLength(tbstr_,hlp+2);

       liczCRC(crc_, tabASM[m].reg+'$'+IntToHex(err,2));
      end;
   end;

  hit:=false;
  for m:=0 to High(tbcrc_)-1 do
   if tbcrc_[m].crc=crc_ then begin hit:=true; Break end;

  if not(hit) then begin
   m:=High(tbcrc_);
   tbcrc_[m].crc:=crc_;
   tbcrc_[m].lin:=lineASM;
   SetLength(tbcrc_, m+2);

   for hlp:=0 to High(tbstr_)-1 do writeln(f, tbstr_[hlp]);

   writeln(f, ' rts',#13#10);
  end else begin
//   writeln(f, ' jmp v',tbcrc_[m].lin,#13#10);

   l:=High(tOptyVBL);

   tOptyVBL[l].vbl:=vbl;
   tOptyVBL[l].lin:=tbcrc_[m].lin;

   SetLength(tOptyVBL, l+2);

  end;

  inc(vbl);
 end;

end;

//frame0.Free;
//frame1.Free;


write(f, #13#10'l_vbl');
for i:=0 to vbl-1 do begin

 if i mod 8=0 then begin
  if i<>0 then writeln(f, ')');
  write(f, #9'dta l(');
 end else write(f, ',');

 m:=i;
 for l:=0 to High(tOptyVBL)-1 do
  if tOptyVBL[l].vbl=m then begin m:=tOptyVBL[l].lin; Break end;

 write(f, 'v', m);

end;
writeln(f, ')',#13#10);


write(f, 'h_vbl');
for i:=0 to vbl-1 do begin

 if i mod 8=0 then begin
  if i<>0 then writeln(f, ')');
  write(f, #9'dta h(');
 end else write(f, ',');

 m:=i;
 for l:=0 to High(tOptyVBL)-1 do
  if tOptyVBL[l].vbl=m then begin m:=tOptyVBL[l].lin; Break end;

 write(f, 'v', m);

end;
writeln(f, ')',#13#10#13#10);


// jesli dane obrazu przekraczaja 4KB to zamieniamy na pojedyncze wiersze

SetLength(tbcrc_, 1);
SetLength(tscr, 1);

ifile:=FileOpen(mapa_path+'Atari\'+mapa_plik+'.scr', fmOpenRead);
len:=FileSeek(ifile, 0, 2);
FileSeek(ifile, 0, 0);

ofile:=FileCreate(mapa_path+'Atari\'+mapa_plik+'.row');

idx:=0;
while idx<len do begin
 inc(idx, FileRead(ifile, wiersz, Bajt));

 crc_:=$ffffffff;

 for i:=0 to Bajt-1 do begin
  p:=(crc_ and $ff) xor wiersz[i];
  cr:=(crc_ shr 8) and $00ffffff;
  crc_:=tcrc32[p] xor cr;
 end;

 b:=false; l:=0;
 for i:=0 to High(tbcrc_)-1 do
  if tbcrc_[i].crc=crc_ then begin l:=i; b:=true; Break end;

 if not(b) then begin
  FileWrite(ofile, wiersz, Bajt);

  i:=High(tbcrc_);
  tbcrc_[i].crc:=crc_;
  SetLength(tbcrc_, i+2);

  k:=High(tscr);
  tscr[k]:=i;
  SetLength(tscr, k+2);
 end else begin
  k:=High(tscr);
  tscr[k]:=l;
  SetLength(tscr, k+2);
 end;

end;

FileClose(ifile);
FileClose(ofile);

writeln(f, #13#10#9'ift rows'#13#10);

write(f, 'l_scr');
for i:=0 to High(tscr)-1 do begin

 if i mod 8=0 then begin
  if i<>0 then writeln(f, ')');
  write(f, #9'dta l(');
 end else write(f, ',');

 write(f, 'screen+',tscr[i]*Bajt);

end;
writeln(f, ')',#13#10);


write(f, 'h_scr');
for i:=0 to High(tscr)-1 do begin

 if i mod 8=0 then begin
  if i<>0 then writeln(f, ')');
  write(f, #9'dta h(');
 end else write(f, ',');

 write(f, 'screen+',tscr[i]*Bajt);

end;
writeln(f, ')',#13#10);

writeln(f, #9'eif'#13#10);


form1.DepackRES('HVSCROL',mapa_path+'Atari\hvscrol.asm');


writeln(f, #9'icl "hvscrol.asm"',#13#10);

writeln(f, #9'.ALIGN $100');
writeln(f, 'mis'#9'ins "',mapa_plik,'.mis"',#13#10);

writeln(f, #9'.ALIGN $100');
writeln(f, 'pm0'#9'ins "',mapa_plik,'.pm0"',#13#10);

writeln(f, #9'.ALIGN $100');
writeln(f, 'pm1'#9'ins "',mapa_plik,'.pm1"',#13#10);

writeln(f, #9'.ALIGN $100');
writeln(f, 'pm2'#9'ins "',mapa_plik,'.pm2"',#13#10);

writeln(f, #9'.ALIGN $100');
writeln(f, 'pm3'#9'ins "',mapa_plik,'.pm3"',#13#10);

writeln(f, #9'run'#9'main');


writeln(f, #13#10,'*---',#13#10);

writeln(f, #9'opt l-',#13#10);

writeln(f, #13#10,';',lineASM);

flush(f);
closefile(f);

SetLength(tabASM,1);   // zwalniamy pamiec na tablice dynamiczna
end;


procedure zapisz_slideshow_bat(var bat: textfile);
begin
 writeln(bat, #13#10'set PLAYER=$c400');
 writeln(bat, 'set MODUL=$d800');
 writeln(bat, 'set STEREOMODE=1'#13#10);

 writeln(bat, 'mads.exe rmt.asm -d:MODUL=%MODUL% -o:modul.obx');
 writeln(bat, 'mads.exe rmt.asm -d:PLAYER=%PLAYER% -d:STEREOMODE=%STEREOMODE% -o:player.obx');

 writeln(bat, 'exomizer sfx sys -t 168 -f "lda #$ff sta $d301 lda #$40 sta $d40e cli rts" -Di_table_addr=0xcf00 -q -n modul.obx -o modul.exo');
 writeln(bat, 'exomizer sfx sys -t 168 -f "lda #$ff sta $d301 lda #$40 sta $d40e cli rts" -Di_table_addr=0xcf00 -q -n player.obx -o player.exo');

 writeln(bat, 'mads.exe slideshow.asm -o:slideshow.xex -d:MODUL=%MODUL% -d:PLAYER=%PLAYER%');
end;


procedure Slideshow;
(*----------------------------------------------------------------------------*)
(* SLIDESHOW                                                                  *)
(*----------------------------------------------------------------------------*)
var x, y, i, mlen, mexo: integer;
    a, zm, old0, old1, old2: string;
    bat, txt: textfile;
    f: file;
begin

 asm_slideshow:=true;

 FExportAs.Button4.Caption:='P L E A S E   W A I T   . . .';

 old0:=current_filename;
 old1:=form1.SaveDialog1.FileName;
 old2:=form1.OpenDialog1.FileName;

 if not(DirectoryExists(mapa_path+'Atari')) then CreateDir(mapa_path+'Atari');


 dane:=FileCreate(mapa_path+'Atari\slideshow.hea');
 form1.save_zerop_variables;
 FileClose(dane);

 
 form1.DepackRES('MADS',mapa_path+'Atari\mads.exe');
 form1.DepackRES('EXOM',mapa_path+'Atari\exomizer.exe');

 form1.DepackRES('RMTASM',mapa_path+'Atari\rmt.asm');

 form1.DepackRES('SLIDE',mapa_path+'Atari\slideshow.tmp');
 form1.DepackRES('RMT',mapa_path+'Atari\music.rmt');
 form1.DepackRES('RMTFEAT',mapa_path+'Atari\music.feat');
 form1.DepackRES('RMTPLAY',mapa_path+'Atari\rmtplayer.asm');
 form1.DepackRES('RMTRELO',mapa_path+'Atari\rmt_relocator.mac');

 GetFirstLastRow(x,y); dec(y, x);

 for i:=0 to FExportAs.seHeight.Position-1 do begin

  zm:=mapa_path+mapa_plik+'_0_'+IntToStr(i);
  if (FileExists(zm+'.g2f')) and (FExportAs.StringGrid1.Cells[0,i]='*') then begin

   LoadG2F(ccOptymizing,x,y,zm);

   current_filename:=mapa_path+'Atari\'+mapa_plik+'_0_'+IntToStr(i);
   form1.SaveDialog1.FileName:=current_filename;
   form1.pliki_danych(current_filename);

   form1.SaveASM_Routine;
  end;

 end;

 asm_slideshow:=false;


 assignfile(bat,mapa_path+'go$$$.bat'); rewrite(bat);

 writeln(bat,'copy *.asq "'+mapa_path+'Atari\"');
 writeln(bat,'copy *.asm "'+mapa_path+'Atari\"');
 writeln(bat,'copy *.fad "'+mapa_path+'Atari\"');
 writeln(bat,'copy *.fnt "'+mapa_path+'Atari\"');
 writeln(bat,'copy *.scr "'+mapa_path+'Atari\"');
 writeln(bat,'copy *.raw "'+mapa_path+'Atari\"');

 writeln(bat,'del *.asq');
 writeln(bat,'del *.asm');
 writeln(bat,'del *.fad');
 writeln(bat,'del *.fnt');
 writeln(bat,'del *.scr');
 writeln(bat,'del *.raw');
 writeln(bat,'del *.h');

 writeln(bat,'del go$$$.bat');

 flush(bat);
 closefile(bat);

 form1.Execute('go$$$.bat', mapa_path, '', true);

 assignfile(bat,mapa_path+'Atari\go$$$.bat'); rewrite(bat);

 for i:=0 to FExportAs.seHeight.Position-1 do begin
  zm:=mapa_path+mapa_plik+'_0_'+IntToStr(i);

  if (FileExists(zm+'.asm')) then
   writeln(bat, 'mads.exe "'+pomoc_mapa+'_0_'+IntToStr(i)+'.asm"')
  else
   writeln(bat, 'mads.exe "'+pomoc_mapa+'_0_'+IntToStr(i)+'.asq"');

  writeln(bat, 'exomizer sfx sys -t 168 -Di_ram_enter=0xfe -Di_ram_exit=0xfe -Di_table_addr=0x0300 -q -n "'+pomoc_mapa+'_0_',i,'.obx"'+' -o "'+pomoc_mapa+'_0_',i,'.exo"');

 end;

 writeln(bat, 'del go$$$.bat');

 flush(bat);
 closefile(bat);

 form1.Execute('go$$$.bat', mapa_path+'Atari\', '', true);


 mlen:=0; mexo:=0;
 for i:=0 to FExportAs.seHeight.Position-1 do begin
  zm:=mapa_path+'Atari\'+mapa_plik+'_0_'+IntToStr(i);

  if (FileExists(zm+'.obx')) then begin
   assignfile(f, zm+'.obx'); reset(f,1);
   if FileSize(f)>mlen then mlen:=FileSize(f);
   closefile(f);

   assignfile(f, zm+'.exo'); reset(f,1);
   if FileSize(f)>mexo then mexo:=FileSize(f);
   closefile(f);
  end;

 end;


 assignfile(bat, mapa_path+'Atari\slideshow.tmp'); reset(bat);
 assignfile(txt, mapa_path+'Atari\slideshow.asm'); rewrite(txt);

 y:=0;

 while not eof(bat) do begin
  readln(bat, a);

  if pos('..S', a)>0 then begin
   i:=$200+$600+(mlen div 256*256);
   if i<$2100+mexo then i:=$2100+(mexo div 256*256);
   a:='SLIDESHOW'#9'= $'+IntToHex(i,4);
  end;

  if pos('..D', a)>0 then
   for i:=0 to FExportAs.seHeight.Position-1 do begin
    zm:=mapa_path+'Atari\'+mapa_plik+'_0_'+IntToStr(i);

    writeln(txt, #9'depack #pic',y);
    inc(y);

    a:='';
   end;

  writeln(txt, a);
 end;

 for i := 0 to y-1 do writeln(txt, 'pic',i,#9'ins "'+mapa_plik+'_0_',i,'.exo"');

 writeln(txt,#9'.print ''end: '',*');
 writeln(txt,#9'run SLIDESHOW');

 closefile(bat);

 flush(txt);
 closefile(txt);


 assignfile(bat, mapa_path+'Atari\!make.bat'); rewrite(bat);

 writeln(bat, 'FOR %%z IN ('+pomoc_mapa+'_0_'+'*.asm) DO mads.exe %%z');
 writeln(bat, 'FOR %%z IN ('+pomoc_mapa+'_0_'+'*.obx) DO exomizer sfx sys -t 168 -Di_ram_enter=0xfe -Di_ram_exit=0xfe -Di_table_addr=0x0300 -q -n %%z -o %%~nz.exo');

 zapisz_slideshow_bat(bat);

 flush(bat);
 closefile(bat);


 assignfile(bat, mapa_path+'Atari\go$$$.bat'); rewrite(bat);

 zapisz_slideshow_bat(bat);

 writeln(bat, 'del slideshow.tmp');
 writeln(bat, 'del go$$$.bat');

 flush(bat);
 closefile(bat);                   

 form1.Execute('go$$$.bat', mapa_path+'Atari\', '', true);


 current_filename:=old0;
 form1.SaveDialog1.FileName:=old1;
 form1.OpenDialog1.FileName:=old2;

 FExportAs.ustaw_button_export(0);

 SaveAfterExit:=false;
end;


procedure TFExportAs.Button4Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* export map do plikow SCR,FNT,DLI,RAS,SPR                                   *)
(*----------------------------------------------------------------------------*)
var k, m, i, j, err, x, y, fps, frm_len: integer;
    txt, zm: string;
    zestaw_tmp, y0, y1, y2, y3, pr: byte;
    f_fnt, f_dli, f_tab, f_scr, f_gfx: integer;
    f_mis, f_pmg0, f_pmg1, f_pmg2, f_pmg3: integer;
    f_all: file;
    hit: Boolean;
    pl, se, bat: textfile;
    w: word;
    ab: tCharCompres;
    temp: tablica_row;
begin

if not(mapa_path[length(mapa_path)] in ['\','/']) then mapa_plik:='\'+mapa_plik;

form1.Zamknij(f_Zoom);
form1.Zamknij(f_EditCharset);

if sld1.Checked then begin Slideshow; exit end;

if scr1.Checked then begin
 vscr_use:=true;

 seWidth.Value:=1;
 seFirst.Value:=0;
 seLast.Value:=30;
end;

// zapamietaj metode kompresji znakow

 if not(DirectoryExists(mapa_path+'Atari')) then CreateDir(mapa_path+'Atari');

 resetujFonty:=true;
// old_nazwa:=nazwa;

 ab:=ccOptymizing;

 fps:=0; lineASM:=0;

 ProgressBar1.Max:=seWidth.Position * seHeight.Position;
 ProgressBar1.Position:=0; ProgressBar1.Visible:=true;

 GetFirstLastRow(x,y); dec(y, x);

 zestaw:=0;

 zestaw_tmp:=0;
 fillchar(fonty_tmp,sizeof(fonty_tmp),0);

 zm:=mapa_path+'Atari\'+mapa_plik;

 assignfile(f_all, zm+'.frm'); rewrite(f_all,1);

 f_fnt:=FileCreate(zm+'.fnt');
 f_dli:=FileCreate(zm+'.col');
 f_tab:=FileCreate(zm+'.tab');
 f_scr:=FileCreate(zm+'.scr');
 f_gfx:=FileCreate(zm+'.gfx');

 f_mis:=FileCreate(zm+'.mis');
 f_pmg0:=FileCreate(zm+'.pm0');
 f_pmg1:=FileCreate(zm+'.pm1');
 f_pmg2:=FileCreate(zm+'.pm2');
 f_pmg3:=FileCreate(zm+'.pm3');

 SetLength(lenPackSCR, 1);

 for j:=0 to seWidth.Position-1 do
  for i:=0 to seHeight.Position-1 do begin

   ProgressBar1.StepIt;

   zm:=mapa_path+mapa_plik+'_'+IntToStr(j)+'_'+IntToStr(i);

   if (FileExists(zm+'.g2f')) and (FExportAs.StringGrid1.Cells[j,i]='*') then begin

    LoadG2F(ab,x,y,zm);

    inc(fps);

    move(fonty_tmp,fonty,sizeof(fonty));

    fillchar(scren, sizeof(scren), 0);
    form1.ClrTable;

    zestaw:=zestaw_tmp;

    if zestaw<128 then
     form1.optymizing((FExportAs.seLast.Position+1)*Bajt, zestaw, false)
    else begin
     Application.MessageBox('Charsets > 127','ERROR',MB_ICONEXCLAMATION);
     Break;
    end;

    zestaw_tmp:=zestaw;

    move(fonty,fonty_tmp,sizeof(fonty));

    frm_len:=0;

    if form1.Optymizing1.Checked then
     for k:=0 to y-1 do begin

      move(scren[tmul48[x+k]+CzarnyPas shr 3], FExportAs.pack_temp[frm_len], bajt);
      inc(frm_len, bajt);

//      for m:=0 to 7 do blockwrite(f_raw,tab[(x+k)*384+CzarnyPas shr 3+tmul48[m]],bajt);
     end;

    for k:=0 to 8 do FileWrite(f_dli,TabKolor[k shl 8+x*8],y*8);

    move(table[x], FExportAs.pack_temp[frm_len], y);
    inc(frm_len, y+1);


    PackSCR(f_all, frm_len+1);

   end;    // if (FileExists(zm+'.g2f')) ...

   FileWrite(f_tab,table[x],y);       // informacja o numerze zestawu znakow w wierszu

   move(gfxMode, temp, sizeof(gfxMode));
   for k:=0 to 30 do
    case temp[k] of
       0: temp[k]:=$70;
     1,4: temp[k]:=$22;
       2: temp[k]:=$24;
    end;

   FileWrite(f_gfx,temp[x],y);

   for k:=x to y-1 do
    FileWrite(f_scr,scren[tmul48[k]+CzarnyPas shr 3],Bajt);

// zapiszemy dane do pliku *.PMG
   move(Smask,SmaskX,$800);

   form1.RemoveUnusedPMGByte;

   for k:=0 to 255 do begin
    y0:=(SmaskX[$100+k] and $c0) shr 6;
    y1:=(SmaskX[$300+k] and $c0) shr 4;
    y2:=(SmaskX[$500+k] and $c0) shr 2;
    y3:=SmaskX[$700+k] and $c0;

    SmaskX[$800+k]:=y0 or y1 or y2 or y3;
   end;

   FileWrite(f_mis,SmaskX[$800+x shl 3],y shl 3);
   FileWrite(f_pmg0,SmaskX[$000+x shl 3],y shl 3);
   FileWrite(f_pmg1,SmaskX[$200+x shl 3],y shl 3);
   FileWrite(f_pmg2,SmaskX[$400+x shl 3],y shl 3);
   FileWrite(f_pmg3,SmaskX[$600+x shl 3],y shl 3);


(********************)
(*    AS VSCROLL    *)
(********************)
if scr1.Checked then begin

 if vscr_use then begin

  SetLength(tabASM,1);

  lineASM:=0;

  SaveVBL;

  vscr_use:=false;
 end;

// tworzymy program DLI (koniecznie dla ca³ej wysokoœci obrazu)
 for k:=0 to Wysokosc-1 do begin

  px := k;

  pr:=form1.ObliczPiorytet(px);

  gtia:=form1.SetGTIAValue(gfxMode[px shr 3]);

  sav(table[px shr 3],$d409);

  SaveChange(pr);

  inc(lineASM);
 end;


end;

         
  end;

FileWrite(f_fnt,fonty,zestaw*1024);

w:=FileSize(f_all);

closefile(f_all);

FileClose(f_fnt);
FileClose(f_dli);
FileClose(f_tab);
FileClose(f_scr);
FileClose(f_gfx);

FileClose(f_mis);

FileClose(f_pmg0);
FileClose(f_pmg1);
FileClose(f_pmg2);
FileClose(f_pmg3);

ProgressBar1.Visible:=false;

FExportAs.Refresh;

ustaw_button_export(zestaw);
button4.Hint:=IntToStr(zestaw)+' charsets';


if scr1.Checked then begin       // as VSCROLL

 CreateASM;

 vscr_use:=false;

end;

//nazwa:=old_nazwa;


(**********************)
(*    AS ANIMATION    *)
(**********************)

if anm1.Checked then
 if (zestaw<49) and ((zestaw)*1024+w<$d400) then begin

// zapisanie pliku ASM ladujacego zestawy znakow
 form1.DepackRES('LOAFNT',mapa_path+'Atari\'+mapa_plik+'.asq');

assignfile(pl,mapa_path+'Atari\'+mapa_plik+'.asq'); append(pl);

writeln(pl,#13#10';---'+#13#10);

for i:=0 to zestaw-1 do begin
 writeln(pl,#9'org loaFnt');
 writeln(pl,#9'ins '+#39+pomoc_mapa+'.fnt'+#39+',',i*1024,',1024');
 writeln(pl,#9'ini putFnt'+#13#10);
end;

flush(pl);
closefile(pl);

// zapisanie pliku ASM pokazujacego animacje (RAM)
assignfile(pl,mapa_path+'Atari\'+mapa_plik+'.asm'); rewrite(pl);

writeln(pl,';-');
writeln(pl,';- G2F Animation v1.2 by TeBe/Madteam (17.08.2004)');
writeln(pl,';- procedura pokazujaca poszczegolne mapy (klatki animacji)');
writeln(pl,';- kompresja znakow: OPTYMIZING, bez zmian kolorow co linie i grafiki PMG');
writeln(pl,';-'+#13#10);

writeln(pl,'BAK = $'+IntToHex(TabKolor[$000],2));
writeln(pl,'PF0 = $'+IntToHex(TabKolor[$100],2));
writeln(pl,'PF1 = $'+IntToHex(TabKolor[$200],2));
writeln(pl,'PF2 = $'+IntToHex(TabKolor[$300],2));
writeln(pl,'PF3 = $'+IntToHex(TabKolor[$400],2)+#13#10);

zm:='2'; if Pixel=2 then zm:='4';

writeln(pl,'pixel'+#9+#9+'= ',zm);
writeln(pl,'gtia'+#9+#9+'= ',Pixel);
writeln(pl,'width'+#9+#9+'= ',Bajt);
writeln(pl,'row_from'+#9+'= ',seFirst.Position);
writeln(pl,'row_to'+#9+#9+'= ',seLast.Position);
writeln(pl,'height'+#9+#9+'= row_to-row_from'+#9+';wysokosc obrazu wyrazona w wierszach');
writeln(pl,'size'+#9+#9+'= width*height'+#9+#9+';dlugosc danych dla 1 ekranu');

//writeln(pl,'frames'+#9+#9+'= '+IntToStr(fps)+#9+#9+#9+';liczba wszystkich ekranow');
writeln(pl,'delay'+#9+#9+'= 6'+#9+#9+#9+';opoznienie (fps)');

writeln(pl);
writeln(pl,#9'icl '+#39+pomoc_mapa+'.asq'+#39);

flush(pl);
closefile(pl);

form1.DepackRES('PROGRAM',path+'file$$$.$$$');   // anima.asm

assignfile(pl,mapa_path+'Atari\'+mapa_plik+'.asm'); append(pl);
assignfile(se,path+'file$$$.$$$'); reset(se);

while not eof(se) do begin
 readln(se,zm); writeln(pl,zm);
end;

write(pl,'lfrm');
for i:=0 to High(lenPackSCR)-1 do begin
 if i mod 8=0 then begin writeln(pl); write(pl,#9,'.by ') end;
 write(pl,'<frm',i,' ');
end;

write(pl,#13#10'hfrm');
for i:=0 to High(lenPackSCR)-1 do begin
 if i mod 8=0 then begin writeln(pl); write(pl,#9,'.by ') end;
 write(pl,'>frm',i,' ');
end;

writeln(pl,#13#10#13#10'plylst'#9'; frame_repeat_counter, frame');
for i:=0 to High(lenPackSCR)-1 do writeln(pl,#9'dta 1,',i);

writeln(pl,#9'dta $ff'#9'; end playlist'#13#10);

k:=0;
for i:=0 to High(lenPackSCR)-1 do begin
 writeln(pl,'frm',i,#9'ins '+#39+pomoc_mapa+'.frm'+#39+',',k,',',lenPackSCR[i]-k);
 k:=lenPackSCR[i];
end;

SetLength(lenPackSCR, 1);

writeln(pl,#13#10';---');
writeln(pl,#9'run animation'+#13#10);

flush(pl);
closefile(pl);
closefile(se);

{ form1.SaveRES('MADS',mapa_path+'Atari\mads.exe');

 assignfile(bat,mapa_path+'Atari\go$$$.bat'); rewrite(bat);

 writeln(bat,'cd "'+mapa_path+'Atari\"');
 writeln(bat,'mads.exe '+pomoc_mapa+'.asm /o:'+pomoc_mapa+'.xex');

 writeln(bat,'del mads.exe');
 writeln(bat,'del go$$$.bat');

 closefile(bat);

 zm:=mapa_path+'Atari\go$$$.bat';
 akcja:=AllocMem(Length(zm)+1);
 StrPCopy(akcja,zm);
 WinExec(akcja,SW_minimize); FreeMem(akcja);   }

end else
 Application.MessageBox('No RAM !','Export',MB_ICONERROR);

 form1.DepackRES('MADS',mapa_path+'Atari\mads.exe');

 form1.Execute('mads.exe', mapa_path+'Atari\', '"'+pomoc_mapa+'.asm" -o:"'+pomoc_mapa+'.xex"', false);

end;


procedure TFExportAs.Charsfill1Click(Sender: TObject);
var i, j, k, m, x: integer;
    a, b, c: string;
begin

if pos('(0)',button4.Caption)=0 then begin

a:='';

 for i:=0 to 127 do begin
  k:=0;
  for j:=0 to 127 do begin
   m:=0;
   for x:=0 to 7 do m:=fonty[i shl 10+j shl 3+x] or m;
   if m>0 then inc(k);
  end;

  str(i,b);
  while length(b)<3 do b:='0'+b;

  str(k,c);
  while length(c)<3 do c:='0'+c;

  a:=a+'Charset #'+b+'  '+c;

  if i<>127 then a:=a+#13#10;
 end;

 FCharsFill.Memo1.Height:=FCharsFill.Canvas.TextHeight('A')*128;
 FCharsFill.Memo1.Text:=a;

 if FCharsFill.ShowModal=mrCancel then begin end;

end else Application.MessageBox('Use first button EXPORT','Chars fill',MB_ICONEXCLAMATION);
end;


procedure TFExportAs.FormShow(Sender: TObject);
begin
{ form1.Zamknij(2);
 form1.Zamknij(5);
 form1.Zamknij(7);
 form1.Zamknij(8);
}
 ratio:=4;

// punkt:=Point(0,0);

 if mapa_plik='' then button4.Enabled:=false;

 show_title;

 ustaw_button_export(0);
end;


procedure TFExportAs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  form1.NewFormPos('FExportAs', top, left);
end;


procedure TFExportAs.FormCreate(Sender: TObject);
begin
 doublebuffered:=true;                  // aby nie szarpalo obrazem
end;


procedure TFExportAs.anm1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* as animation                                                               *)
(*----------------------------------------------------------------------------*)
begin

 if not(anm1.Checked) then begin
  anm1.Checked:=true;
  scr1.Checked:=false;
  sld1.Checked:=false;

  seWidth.Enabled:=true;
  seHeight.Enabled:=true;
  seFirst.Enabled:=true;
  seLast.Enabled:=true;
 end;

 ustaw_button_export(0);
end;


procedure TFExportAs.scr1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* as vscroll                                                                 *)
(*----------------------------------------------------------------------------*)
begin
 if not(scr1.Checked) then begin
  scr1.Checked:=true;
  anm1.Checked:=false;
  sld1.Checked:=false;

  seWidth.Value:=1;
  seWidth.Enabled:=false;
  seHeight.Enabled:=true;

  seFirst.Value:=0;
  seLast.Value:=30;

  seFirst.Enabled:=false;
  seLast.Enabled:=false;
 end;

 ustaw_button_export(0);
end;


procedure TFExportAs.sld1Click(Sender: TObject);
// as slideshow
begin

 if not(sld1.Checked) then begin
  scr1.Checked:=false;
  anm1.Checked:=false;
  sld1.Checked:=true;

  seWidth.Value:=1;
  seWidth.Enabled:=false;
  seHeight.Enabled:=true;

  seFirst.Value:=0;
  seLast.Value:=30;

  seFirst.Enabled:=false;
  seLast.Enabled:=false;
 end;

 ustaw_button_export(0);
end;


procedure TFExportAs.Insert1Click(Sender: TObject);
begin
 insert_screen;
end;


procedure TFExportAs.Load1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* LOAD SCREEN                                                                *)
(*----------------------------------------------------------------------------*)
var t,l: integer;
begin

 if DirectoryExists(mapa_path) then
  FLoadScreens.DirectoryListBox1.Directory:=ExtractFilePath(mapa_path)
 else
  FLoadScreens.DirectoryListBox1.Directory:=ExtractFilePath(path);

 form1.SetFormPos('FLoadScreens', t, l);
 FLoadScreens.Top:=t;
 FLoadScreens.Left:=l;

 if FLoadScreens.ShowModal=mrOK then begin end;
 
end;


procedure TFExportAs.Remove1Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* REMOVE SCREEN                                                              *)
(*----------------------------------------------------------------------------*)
begin

 FExportAs.StringGrid1.Cells[punkt.x,punkt.y]:=' ';
 FExportAs.StringGrid1Click(FExportAs);
end;


procedure TFExportAs.Edit5Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* EDIT SCREEN                                                                *)
(*----------------------------------------------------------------------------*)
var txt, zm: string;
begin
 form1.SaveChanges;

 if FExportAs.StringGrid1.Cells[punkt.x,punkt.y]='*' then begin
  zm:=mapa_path+mapa_plik+'_'+IntToStr(punkt.x)+'_'+IntToStr(punkt.y);

  form1.SaveDialog1.FileName:=ExtractFileName(zm);

  if FileExists(zm+'.g2f') then begin
   txt:=current_filename;
   current_filename:=zm+'.g2f';
   form1.PreviewButton;
   current_filename:=txt;
  end;

 end;

end;


procedure TFExportAs.seWidthChange(Sender: TObject);
begin
 StringGrid1.ColCount:=seWidth.Position;
end;


procedure TFExportAs.seWidthContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;

procedure TFExportAs.seHeightChange(Sender: TObject);
begin
 StringGrid1.RowCount:=seHeight.Position;
end;


procedure TFExportAs.seFirstChange(Sender: TObject);
var x, y: integer;
begin

 GetFirstLastRow(x,y);

 if x>30 then seFirst.Value:=30;
 if x>y then seFirst.Value:=y;

 FExportAs.StringGrid1Click(FExportAs);
end;


procedure TFExportAs.seLastChange(Sender: TObject);
var x, y: integer;
begin

 GetFirstLastRow(x,y);

 if y>30 then seLast.Value:=30;
 if y<x then seLast.Value:=x;

 FExportAs.StringGrid1Click(FExportAs);
end;

end.

