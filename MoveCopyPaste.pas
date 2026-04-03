unit MoveCopyPaste;

interface

uses
  Windows, Graphics, Controls, Forms, Buttons, StdCtrls, Classes, ComCtrls,
  ExtCtrls, Menus, LineRange, SysUtils, BMDSpinEdit, UnitButtonMenu;

type
  tCopyMode = (mCopy=5, mPaste=4, mFlip=8, mMirror=9, mMerge=16);

  TFMove = class(TForm)
    Panel1: TPanel;
    MoveX: TButton;
    MoveY: TButton;
    Panel2: TPanel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    MovePMG: TCheckBox;
    MoveBitmap: TCheckBox;
    MoveColors: TCheckBox;
    Bevel5: TBevel;
    bCopy: TBitBtn;
    PopupMenu1: TPopupMenu;
    Paste1: TMenuItem;
    Flip1: TMenuItem;
    Mirror1: TMenuItem;
    Merge1: TMenuItem;
    frameLineRange1: TframeLineRange;
    seMoveX: TBMDSpinEdit;
    seMoveY: TBMDSpinEdit;
    udLeft: TBMDSpinEdit;
    udRight: TBMDSpinEdit;
    bPaste: TButtonMenu;
    procedure Button8Click(Sender: TObject);
    procedure MoveXClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MoveYClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseForm7;
    procedure ShowMarker;
    procedure FormShow(Sender: TObject);
    procedure GetLineRangeValue(out i,j:integer);
    procedure bCopyClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Copy;
    procedure Paste;
    procedure Delete;
    procedure Mirror;
    procedure Flip;
    procedure Merge;
    procedure Paste1Click(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure Panel1MouseEnter(Sender: TObject);
    procedure Panel2MouseEnter(Sender: TObject);
    procedure frameLineRange1seLineChange(Sender: TObject);
    procedure LineChange;
    procedure seMoveXChange(Sender: TObject);
    procedure seMoveYChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SelectAll;
    procedure udLeftChange(Sender: TObject);
    procedure udRightChange(Sender: TObject);
    procedure seMoveXContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure bPasteMenuButtonClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMove: TFMove;

  CopyMode: tCopyMode = mPaste;

implementation

uses Main, EditCharset, EditPMG;

{$R *.dfm}


procedure TFMove.Button8Click(Sender: TObject);
// INVERS
var b, x, y: byte;
    ofs, hlp: integer;
begin
ofs:=CurShp.x+tmul48[CurShp.Y];

SaveAfterExit:=true;

form1.ZapiszUndo;

for y:=0 to yel_hig-1 do
 for x:=0 to yel_wid-1 do
  if (CurShp.X+x<48) and (CurShp.Y+y<30) then begin

   case gfxMode[CurShp.Y+y] of
    1,4:
       begin
        hlp:=CurShp.X+x+tmul48[(CurShp.Y+y) shl 3];

        for b:=0 to 7 do begin
         tab[hlp]:=tab[hlp] xor $ff;
         inc(hlp,48);
        end;

       end;

    2: begin
        hlp:=ofs+x+tmul48[y];

        b:=scren[hlp] xor $80;

        scren[hlp]:=b;

        invers[hlp]:=b;
        invers2[hlp]:=b;
       end;

   end;

  end;

form1.ShowChars(CurShp.Y,CurShp.Y+yel_hig-1,true);

FEditCharset.PutChar(scren[ofs]);

if FEditCharset.Visible then FEditCharset.PrzepiszZnaki;
end;


procedure TFMove.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FMove', top, left);

 CloseForm7;
end;


procedure TFMove.FormCreate(Sender: TObject);
begin

 Paste1.Tag  := ord(mPaste);
 Flip1.Tag   := ord(mFlip);
 Mirror1.Tag := ord(mMirror);
 Merge1.Tag  := ord(mMerge);

 Paste1.ImageIndex  := ord(mPaste);
 Flip1.ImageIndex   := ord(mFlip);
 Mirror1.ImageIndex := ord(mMirror);
 Merge1.ImageIndex  := ord(mMerge);

end;


procedure TFMove.MoveXClick(Sender: TObject);
begin
 form1.ZapiszUndo; SaveAfterExit:=true;

 Form1.MoveX;
end;


procedure TFMove.MoveYClick(Sender: TObject);
begin
 form1.ZapiszUndo; SaveAfterExit:=true;

 Form1.MoveY;
end;


procedure TFMove.Button2Click(Sender: TObject);
// CHARSET #
begin

 if FEditCharset.Visible then
  form1.Zamknij(f_EditCharset)
 else begin
  charset:=table[cur.Y]; charset_old:=$ff; showCharset:=false;

  form1.Cnv;
  form1.PokazCharset;
  FEditCharset.Visible:=true;

  Cur:=Point(CurShp.X+Shp.X , CurShp.Y+Shp.Y);

  form1.kafelek(false);

  FEditCharset.SetFocus;
 end;

end;


procedure TFMove.Button3Click(Sender: TObject);
begin
 form1.PutChars;
 form1.SetFocus;
end;


procedure TFMove.GetLineRangeValue(out i, j: integer);
begin
 i:=FMove.frameLineRange1.seLine.Position;
 j:=FMove.frameLineRange1.seRange.Position;
end;


procedure TFMove.ShowMarker;
var i, j, a, b: integer;
begin

 form1.ClrShape9;

 a:=udLeft.Position;
 b:=udRight.Position;

 GetLineRangeValue(i,j);

 SelectArea.Left:=a shl 4;
 SelectArea.Top:=i shl 1;
 SelectArea.Width:=(b-a) shl 4;
 SelectArea.Height:=(j+1) shl 1;

 pMark:=Point(a shl 3, i);
 lMark:=Point(pMark.X+(b-a) shl 3, pMark.Y+(j+1));

end;


procedure LiniaMove;
var i, j: integer;
begin
 FMove.GetLineRangeValue(i,j);

 form1.Sprawdz_Zaznaczenia(i,j);

 FMove.frameLineRange1.seLine.Position:=i;
 FMove.frameLineRange1.seRange.Position:=j;

 form1.Ustaw_Button2_7(i,j);

 FMove.ShowMarker;
end;


procedure TFMove.LineChange;
begin

 LiniaMove;

 frameLineRange1.seLineChange(self);

end;


procedure TFMove.frameLineRange1seLineChange(Sender: TObject);
begin
 LineChange;
end;


procedure TFMove.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then form1.Zamknij(f_Move);
end;


procedure TFMove.Copy;
// COPY
var i, j, a, plik: integer;
    s, lf, rg, k: byte;
begin

 GetLineRangeValue(i,j);

// lewa i prawa krawedz zaznaczenia
 lf:=udLeft.Position;
 rg:=udRight.Position;
// szerokosc
 s:=rg-lf;

 plik:=FileCreate(path+'copy$.$$$');

 bufor[0]:=s; FileWrite(plik, bufor,1);

 for a:=i to i+j do begin

  FileWrite(plik, tab[tmul48[a]+lf],s);
  FileWrite(plik, invers[tmul48[a div 8]+lf],s);

  FileWrite(plik, Sprajt[a],sizeof(tablica_sprite));
  FileWrite(plik, SprajtX[a],sizeof(tablica_sprite));

  FileWrite(plik, Spr0[a],2); FileWrite(plik, Spr1[a],2);
  FileWrite(plik, Spr2[a],2); FileWrite(plik, Spr3[a],2);
  FileWrite(plik, Mis0[a],2); FileWrite(plik, Mis1[a],2);
  FileWrite(plik, Mis2[a],2); FileWrite(plik, Mis3[a],2);

  for k:=0 to 7 do FileWrite(plik, Smask[a+k shl 8],1);
  for k:=0 to 8 do FileWrite(plik, tabKolor[a+k shl 8],1);

  FileWrite(plik, raster[a], sizeof(tARaster));
  FileWrite(plik, raster_line_ofset[a], 2);
 end;

 FileClose(plik);

 bPaste.MenuButton.Enabled:=true;
 bPaste.MainButton.Enabled:=true;

end;


procedure TFMove.Delete;
var i,j, lf,rg, s, a: integer;
begin

 SaveAfterExit:=true;
 form1.ZapiszUndo;

 GetLineRangeValue(i,j);

// lewa i prawa krawedz zaznaczenia
 lf:=udLeft.Position;
 rg:=udRight.Position;
// szerokosc
 s:=rg-lf;

 for a:=i to i+j do begin

  if MoveBitmap.Checked then begin
   fillchar(tab[tmul48[a]+lf],s,0);
   fillchar(invers[tmul48[a div 8]+lf],s,0);
  end;

  if MovePMG.Checked then form1.DeletePMG(a,lf shl 2,s shl 2);

//  if MoveColors.Checked then
//   for k := 0 to 8 do TabKolor[k shl 8+a]:=0;

 end;


form1.OdswiezObraz;

ShowMarker;

form1.UstawKolory;

FEditPMG.check_refresh;
 
end;


procedure TFMove.Paste;
// PASTE
var i, j, a, plik: integer;
    k, lf, s: byte;
begin
GetLineRangeValue(i,j);

SaveAfterExit:=true;

// lewa krawedz, tutaj bedziemy wklejac
lf:=udLeft.Position;

plik:=FileOpen(path+'copy$.$$$', fmOpenRead);
FileSeek(plik, 0, 0);

FileRead(plik,bufor,1); s:=bufor[0];
if lf+s>48 then lf:=48-s;  // aby nie wyszlo za krawedz obrazu

// odswiezenie wartosci zaznaczenia zakresu
udLeft.Position:=lf;
udRight.Position:=lf+s;

form1.ZapiszUndo;

for a:=i to i+j do begin

 if MoveBitmap.Checked then
  FileRead(plik,tab[tmul48[a]+lf],s)
 else
  FileRead(plik,bufor,s);

 if (a mod 8=0) and MoveBitmap.Checked then
  FileRead(plik,invers[tmul48[a div 8]+lf],s)
 else
  FileRead(plik,bufor,s);

 if MovePMG.Checked then begin
  FileRead(plik,Sprajt[a],sizeof(tablica_sprite));
  FileRead(plik,SprajtX[a],sizeof(tablica_sprite));

  FileRead(plik,Spr0[a],2); FileRead(plik,Spr1[a],2);
  FileRead(plik,Spr2[a],2); FileRead(plik,Spr3[a],2);
  FileRead(plik,Mis0[a],2); FileRead(plik,Mis1[a],2);
  FileRead(plik,Mis2[a],2); FileRead(plik,Mis3[a],2);
 end else
  FileRead(plik,bufor,sizeof(tablica_sprite)*2+16);

 for k:=0 to 7 do
  if MovePMG.Checked then
   FileRead(plik,Smask[a+k shl 8],1)
  else
   FileRead(plik,bufor,1);

 for k:=0 to 8 do
  if MoveColors.Checked then
   FileRead(plik,tabKolor[a+k shl 8],1)
  else
   FileRead(plik,bufor,1);

 if MoveColors.Checked then begin
  FileRead(plik,raster[a],sizeof(tARaster));
  FileRead(plik,raster_line_ofset[a],2);
 end else
  FileRead(plik,bufor,sizeof(tARaster)+2);

end;

FileClose(plik);

form1.OdswiezObraz;

ShowMarker;

form1.UstawKolory;

FEditPMG.check_refresh;
end;


procedure TFMove.Paste1Click(Sender: TObject);
begin

 CopyMode:=tCopyMode(TPopupMenu(Sender).Tag);

 case CopyMode of
   mPaste: bPaste.MainButton.Caption:='Paste';
    mFlip: bPaste.MainButton.Caption:='Flip';
  mMirror: bPaste.MainButton.Caption:='Mirror';
   mMerge: bPaste.MainButton.Caption:='Merge';
 end;

 bPaste.MainButton.Glyph:=nil;
 form1.Imagelist2.GetBitmap(ord(CopyMode), bPaste.MainButton.Glyph);

end;


procedure PasteCopyData(plik, a: integer);
var k: integer;
begin

 if FMove.MovePMG.Checked then begin
  FileRead(plik,Sprajt[a],sizeof(tablica_sprite));
  FileRead(plik,SprajtX[a],sizeof(tablica_sprite));

  FileRead(plik,Spr0[a],2); FileRead(plik,Spr1[a],2);
  FileRead(plik,Spr2[a],2); FileRead(plik,Spr3[a],2);
  FileRead(plik,Mis0[a],2); FileRead(plik,Mis1[a],2);
  FileRead(plik,Mis2[a],2); FileRead(plik,Mis3[a],2);
 end else
  FileRead(plik,bufor,sizeof(tablica_sprite)*2+16);

 for k:=0 to 7 do
  if FMove.MovePMG.Checked then
   FileRead(plik,Smask[a+k shl 8],1)
  else
   FileRead(plik,bufor,1);

 for k:=0 to 8 do
  if FMove.MoveColors.Checked then
   FileRead(plik,tabKolor[a+k shl 8],1)
  else
   FileRead(plik,bufor,1);

 if FMove.MoveColors.Checked then begin
  FileRead(plik,raster[a],sizeof(tARaster));
  FileRead(plik,raster_line_ofset[a], 2);
 end else
  FileRead(plik,bufor,sizeof(tARaster) + 2);

end;


procedure TFMove.Merge;
// MERGE
type
    Pmaska = ^tab_byte256;

var i, j, a, x, plik: integer;
    k, lf, s: byte;

    maska: Pmaska;

begin

 GetLineRangeValue(i,j);

 SaveAfterExit:=true;


 New(maska);

 fillchar(maska^, sizeof(maska^), 0);

 for x := 0 to 255 do begin

  k:=byte(x);

  if k and 3<>0 then k:=k or 3;
  if k and 12<>0 then k:=k or 12;
  if k and $30<>0 then k:=k or $30;
  if k and $c0<>0 then k:=k or $c0;

  maska^[x]:= k xor $ff;
 end;
                            
// lewa krawedz, tutaj bedziemy wklejac
lf:=udLeft.Position;

plik:=FileOpen(path+'copy$.$$$', fmOpenRead);
FileSeek(plik, 0, 0);

FileRead(plik,bufor,1); s:=bufor[0];
if lf+s>48 then lf:=48-s;  // aby nie wyszlo za krawedz obrazu

// odswiezenie wartosci zaznaczenia zakresu
udLeft.Position:=lf;
udRight.Position:=lf+s;

form1.ZapiszUndo;

for a:=i to i+j do begin

 if MoveBitmap.Checked then begin     // ....... realizacja MERGE
//  blockread(dane,tab[tmul48[a]+lf],s)

  FileRead(plik, bufor,s);

  for x := 0 to s-1 do begin
   bufor[x]:=bufor[x] and maska^[tab[tmul48[a]+lf+x]];
   tab[tmul48[a]+lf+x]:=tab[tmul48[a]+lf+x] or bufor[x];
  end;

 end else
  FileRead(plik, bufor,s);

 if (a mod 8=0) and MoveBitmap.Checked then
  FileRead(plik,invers[tmul48[a div 8]+lf],s)
 else
  FileRead(plik,bufor,s);

 PasteCopyData(plik, a);

end;

 FileClose(plik);

 form1.OdswiezObraz;

 ShowMarker;

 form1.UstawKolory;

 Dispose(maska);

 FEditPMG.check_refresh;  
end;


procedure TFMove.Mirror;
// MIRROR
var i, j, a, x, l, plik: integer;
    lf, s, y, v: byte;
begin
GetLineRangeValue(i,j);

SaveAfterExit:=true;

// lewa krawedz, tutaj bedziemy wklejac
lf:=udLeft.Position;

plik:=FileOpen(path+'copy$.$$$', fmOpenRead);
FileSeek(plik, 0, 0);

FileRead(plik,bufor,1); s:=bufor[0];
if lf+s>48 then lf:=48-s;  // aby nie wyszlo za krawedz obrazu

// odswiezenie wartosci zaznaczenia zakresu
udLeft.Position:=lf;
udRight.Position:=lf+s;

form1.ZapiszUndo;        

for a:=i to i+j do begin

 FileRead(plik, bufor, s);

// realizujemy mirror danych grafiki bitmapy
// rozbijamy pozioma linie na pojedyncze piksle
 l:=0;
 for x:=0 to s-1 do begin

  v:=bufor[x];

  case Pixel of
   1: for y:=0 to 7 do begin
       bufor[$100+7-y+l] := (v and $01);
       v:=v shr 1;
      end;

   2: for y:=0 to 3 do begin
       bufor[$100+3-y+l] := (v and $03);
       v:=v shr 2;
      end;

   4: for y:=0 to 1 do begin
       bufor[$100+2-y+l] := (v and $0f);
       v:=v shr 4;
      end;
  end;

  inc(l, 8 div Pixel);
 end;

// scalamy pojedyncze pixle w bajty od tylu
 for x:=0 to s-1 do begin

  v:=0;
  case Pixel of
   1: for y:=0 to 7 do
       if bufor[$100+l-y-1]<>0 then v:=v or twyt1[y];

   2: begin
       v:=bufor[$100+l-1] shl 6 or
          bufor[$100+l-1-1] shl 4 or
          bufor[$100+l-2-1] shl 2 or
          bufor[$100+l-3-1];
      end;

   4: begin
       v:=bufor[$100+l] shl 4 or
          bufor[$100+l-1];
      end;
  end;

  bufor[x]:=v;
  dec(l,8 div Pixel);
 end;


 if MoveBitmap.Checked then move(bufor,tab[tmul48[a]+lf],s);

// mirror informacji o inversie
 FileRead(plik,bufor[$100],s);

 for y:=0 to s-1 do
  bufor[y]:=bufor[$100+s-y-1];

 if (a mod 8=0) and MoveBitmap.Checked then move(bufor,invers[tmul48[a div 8]+lf],s);

 PasteCopyData(plik, a);

end;

FileClose(plik);

form1.OdswiezObraz;

ShowMarker;

form1.UstawKolory;

FEditPMG.check_refresh;
end;


procedure TFMove.Flip;
// FLIP
var i, j, a, plik: integer;
    lf, s: byte;
begin
GetLineRangeValue(i,j);

SaveAfterExit:=true;

// lewa krawedz, tutaj bedziemy wklejac
lf:=udLeft.Position;

plik:=FileOpen(path+'copy$.$$$', fmOpenRead);
FileSeek(plik, 0, 0);

FileRead(plik,bufor,1); s:=bufor[0];
if lf+s>48 then lf:=48-s;  // aby nie wyszlo za krawedz obrazu

// odswiezenie wartosci zaznaczenia zakresu
udLeft.Position:=lf;
udRight.Position:=lf+s;

form1.ZapiszUndo;

for a:=i+j downto i do begin

 if MoveBitmap.Checked then
  FileRead(plik,tab[tmul48[a]+lf],s)
 else
  FileRead(plik,bufor,s);

 if (a mod 8=0) and MoveBitmap.Checked then
  FileRead(plik,invers[tmul48[a div 8]+lf],s)
 else
  FileRead(plik,bufor,s);

 PasteCopyData(plik, a);

end;

FileClose(plik);

form1.OdswiezObraz;

ShowMarker;

form1.UstawKolory;

FEditPMG.check_refresh;  
end;


procedure TFMove.FormShow(Sender: TObject);
begin
 udLeft.Position:=CzarnyPas shr 3;
 udRight.Position:=CzarnyPas shr 3+Bajt;

 ShowMarker;

 bCopy.Glyph:=nil;
 form1.Imagelist2.GetBitmap(ord(mCopy), bCopy.Glyph);

 bPaste.MainButton.Caption:='Paste';
 bPaste.MainButton.Glyph:=nil;
 form1.Imagelist2.GetBitmap(ord(CopyMode), bPaste.MainButton.Glyph);
end;


procedure TFMove.CloseForm7;
begin

 with form1 do begin

  Shape9Enable(false);

  Zamknij(f_EditCharset);

  Showchars1.Checked:=false;
  MoveCopyPaste.Checked:=false;

  ZamienGrafike; Usun_Zaznaczenia(false);

//  Refresh;
 end;

 form1.DisableDrawMode;

end;


procedure TFMove.bCopyClick(Sender: TObject);
begin

 Self.ActiveControl:=nil;
 
 Copy;
end;


procedure TFMove.BitBtn1Click(Sender: TObject);
begin

 Self.ActiveControl:=nil;

 case CopyMode of
   mPaste: Paste;
    mFlip: Flip;
  mMirror: Mirror;
   mMerge: Merge;
 end;

end;


procedure TFMove.bPasteMenuButtonClick(Sender: TObject);
begin
 Self.ActiveControl:=nil;

 bPaste.MenuButtonClick(Sender);

end;


procedure TFMove.FormMouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;
                      
procedure TFMove.Panel1MouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;

procedure TFMove.Panel2MouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;


procedure TFMove.seMoveXChange(Sender: TObject);
// MOVE X
begin

 if seMoveX.Position>0 then seMoveX.Hint:='Move RIGHT' else
  if seMoveX.Position<0 then seMoveX.Hint:='Move LEFT' else
   seMoveX.Hint:='';

 MoveX.Hint:=seMoveX.Hint;
end;


procedure TFMove.seMoveXContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;


procedure TFMove.seMoveYChange(Sender: TObject);
// MOVE Y
begin

 if seMoveY.Position>0 then seMoveY.Hint:='Move UP' else
  if seMoveY.Position<0 then seMoveY.Hint:='Move DOWN' else
   seMoveY.Hint:='';

 MoveY.Hint:=seMoveY.Hint;
end;


procedure TFMove.SelectAll;
begin

 frameLineRange1.seLine.Position:=0;
 frameLineRange1.seRange.Position:=239;

 udLeft.Position:=CzarnyPas shr 3;
 udRight.Position:=Bajt + udLeft.Position;

 ShowMarker;

end;


procedure TFMove.udLeftChange(Sender: TObject);
var a, b: integer;
begin
 a:=udLeft.Position;
 b:=udRight.Position;

 if a>=b then begin
  b:=a+1; udRight.Position:=b;
 end;

 ShowMarker;
end;


procedure TFMove.udRightChange(Sender: TObject);
var a, b: integer;
begin
 a:=udLeft.Position;
 b:=udRight.Position;

 if b<=a then begin
  a:=b-1; udLeft.Position:=a;
 end;

 ShowMarker;
end;


end.


