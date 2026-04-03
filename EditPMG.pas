// piorytet zapisywany jest na 3 ostatnich bitach w SPR0 (0..7)
// informacja o Player5 zapisywana jest na 3 ostatnich bitach w SPR1

// AktywnyWskaznik = [1..8]

unit EditPMG;

interface

uses
  Windows, Graphics, Forms, StdCtrls, Buttons, Classes, ExtCtrls, Controls,
  SysUtils, Menus, BMDSpinEdit, ComCtrls, LineRange, AddSkip, UnitButtonMenu;

type
  tPMGChange = (bChange, bClear, bFill, bDelete, bEdit);

  TFEditPMG = class(TForm)                  
    Label10: TLabel;
    Label1: TLabel;
    Label20: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Label22: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    Label40: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    Label57: TLabel;
    udPrior: TUpDown;
    P: TLabel;
    lPriority: TLabel;
    lPrior: TLabel;
    PM0: TLabel;
    PM1: TLabel;
    PM2: TLabel;
    PM3: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    chbPlayer5: TCheckBox;
    Bevel4: TBevel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    Bevel5: TBevel;
    chbMLC: TCheckBox;
    Bevel2: TBevel;
    PopupMenu1: TPopupMenu;
    pmgCHANGE: TMenuItem;
    pmgCLEAR: TMenuItem;
    pmgFILL: TMenuItem;
    pmgDELETE: TMenuItem;
    pmgEDIT: TMenuItem;
    BitBtn2: TBitBtn;
    N1: TMenuItem;
    PopupMenu2: TPopupMenu;
    fColor: TMenuItem;
    fSaturation: TMenuItem;
    frameLineRange1: TframeLineRange;
    frameAddSkip1: TframeAddSkip;
    FillPMGColors: TButtonMenu;
    Apply: TButtonMenu;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel1Click(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
    procedure pmg_rangeClick(Sender: TObject; Button: TUDBtnType);
    procedure pmg_lineClick(Sender: TObject; Button: TUDBtnType);
    procedure FormShow(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure chbPlayer5Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Ustaw_Reszte_Kolorow_Duchow(const i:integer);
    function SetPrior(var a:byte; const x:Boolean): shortint;
    procedure SetColLineSpr(const i: integer);
    function GetPrior(const i:integer): byte;
    function GetPlayer5Value(const i:integer; const a:Boolean):byte;
    procedure ChangeButton;
    procedure FormCreate(Sender: TObject);
    function GetLineValue:integer;
    function GetRangeValue:integer;
    procedure WskazLinie;
    procedure init_edit_sprites(const j: integer; const v:byte);
    procedure AktualizujSprity;
    function get_pmg_size: byte;
    function get_pmg_posx:integer;
    procedure set_pmg_posx(const a:integer);
    procedure set_pmg_size(const a:byte);
    procedure check_refresh;
    procedure NewPMGChange(Sender: TObject);
    procedure NewPMGClick(Sender: TObject);
    procedure chbMLCClick(Sender: TObject);
    function GetMLCValue(const i:integer; const a:Boolean): byte;
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetPosSprite(const x,y: integer);
    procedure pmgCHANGEClick(Sender: TObject);
    procedure FillPMGColorsClick(Sender: TObject);
    procedure fColorClick(Sender: TObject);
    procedure SetSprite(const t: byte; i,j: integer);
    procedure Line(const q:cardinal; rat:byte; const pmx,py:integer);
    procedure FormMouseEnter(Sender: TObject);
    procedure frameLineRange1bGetClick(Sender: TObject);
    procedure frameLineRange1seLineChange(Sender: TObject);
    procedure LineChange;
    procedure frameLineRange1seRangeChange(Sender: TObject);
    procedure SelectAll;
    procedure Copy;
    procedure Paste;
    procedure Delete;
    procedure ChangeDefault;
    procedure DisableContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ApplyMenuButtonClick(Sender: TObject);
    procedure FillPMGColorsMenuButtonClick(Sender: TObject);
    procedure udPriorChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);

  private
    { Private declarations }

  oldSelect: integer;
  cPMGColor: byte;

  useGet, allow: Boolean;

  spr_panel: array [1..8] of TPanel;
  spr_combo: array [1..8] of TComboBox;

  spr_size, spr_posx: array [1..8] of TBMDSpinEdit;


  const
  NewPosXTag: array [1..8] of byte = (1,7,2,8,3,9,4,10);

  public
    { Public declarations }
  end;

var
  FEditPMG: TFEditPMG;

  PMGChangeMode: tPMGChange = bChange;

  AktywnyWskaznik: byte = 1;


implementation

uses Main, SelectColor, Check, EditRasters, EditColors;

{$R *.dfm}


procedure TFEditPMG.ChangeDefault;
var i: byte;
begin

 for i:=0 to 7 do spr_combo[i+1].ItemIndex:=i shr 1;

end;


procedure TFEditPMG.SetColLineSpr(const i: integer);
var a, x: byte;
    cl: TColor;
begin

 for a:=0 to 3 do begin
  cl:=AtariPal[TabKolor[i+$500+a shl 8]];
  for x := 0 to 8 do form1.SetPixel(bmpPal, a*9+x, i, cl);
 end;

// jesli player5=true to pokaz kolor 711
//  if ply5 then
   cl:=AtariPal[TabKolor[i+$400]];
//  else
//   Pen.Color:=ClBtnFace;

 for x := 0 to 8 do form1.SetPixel(bmpPal, 36+x, i, cl);

 form1.Image6.Picture.Graphic:=bmpPal;
 
end;


function TFEditPMG.GetLineValue:integer;
begin
 Result:=frameLineRange1.seLine.Position;
end;


function TFEditPMG.GetRangeValue:integer;
begin
 Result:=frameLineRange1.seRange.Position;
end;


procedure TFEditPMG.WskazLinie;
var i, j: integer;
begin

 if FEditPMG.Visible then begin

  i:=GetLineValue;
  j:=GetRangeValue;

  form1.Sprawdz_Zaznaczenia(i,j);

//  pmg_line.Position:=i;
//  pmg_range.Position:=j;

  frameLineRange1.seLine.Position:=i;      // !!! koniecznie, POSITION nie aktualizuje TEXT
  frameLineRange1.seRange.Position:=j;

  form1.Ustaw_Button2_7(i,j);
  form1.Ustaw_Button4_5(i,j,-1,-1);

  with Canvas do begin

   if MLCpmg then
    Pen.Color:=0
   else
    Pen.Color:=clBtnFace;

   Brush.Style:=bsClear;

   RoundRect(158,6,158+75,6+105,16,16);
   RoundRect(158,118,158+75,118+105,16,16);

  end;

 end;

end;


procedure UstawWskaznik;
var i, j, idx: integer;
    bmp: TBitmap;
    A: PPixelRec;
    cs,g,b: byte;

const
    colorSelect = $7f40f0;

begin

 bmp:=TBitmap.Create;
 bmp.PixelFormat:=pf32bit;
 bmp.SetSize(form1.Image4.Width shr 2, form1.Image4.Height shr 1);

 form1.ClrRect(bmp, transCol);

 cs:=GetRValue(colorSelect);
 g:=GetGValue(colorSelect);
 b:=GetBValue(colorSelect);


// for x:=1 to 8 do spr_label[x].Caption:='';
// spr_label[AktywnyWskaznik].Caption:='*';

 j:=AktywnyWskaznik-1;
// FEditPMG.Shape3.Top:=7+j*24+(j shr 1) shl 3-2;

 idx:=7+j*24+(j shr 1) shl 3-2;

 with FEditPMG.Canvas do begin
  Brush.Color:=clBtnFace;
  FrameRect(Rect(3,FEditPMG.oldSelect,6+26,26+FEditPMG.oldSelect));

  Brush.Color:=0;
  FrameRect(Rect(3,idx,6+26,26+idx));
 end;

 FEditPMG.oldSelect:=idx;

 idx:=(CzarnyPas shr 1)*3;

 for j := 0 to Wysokosc-1 do begin

  A:=bmp.ScanLine[j];

  inc(A, CzarnyPas shr 1);

  for i := 0 to (Szerokosc shr 1)-1 do begin

   if  (Sprajt[j, CzarnyPas shr 1+i] and twyt1[8-AktywnyWskaznik]>0)
//   and ((Sprajt[CzarnyPas shr 1+i+j*290+1] and twyt1[8-AktywnyWskaznik]=0)
//    or (Sprajt[CzarnyPas shr 1+i+j*290-1] and twyt1[8-AktywnyWskaznik]=0))
//    or (Sprajt[CzarnyPas shr 1+i+j*290+290] and twyt1[8-AktywnyWskaznik]=0))

     then begin

       A^.R := cs;
       A^.G := g;
       A^.B := b;

     end;

   inc(A);
  end;

 end;

 form1.Image4.Picture.Graphic:=bmp;

 bmp.Free;

end;

{
procedure BlendSelectFast;
var x, y, w, h: integer;
    A, P: PPixelRec;
    cs, g, b: byte;
begin

   cs:=GetRValue(colorSelect);
   g:=GetGValue(colorSelect);
   b:=GetBValue(colorSelect);

   w:=timg[MainForm.ActiveMDIChild.Tag].bmpSelect.Width-1;
   h:=timg[MainForm.ActiveMDIChild.Tag].bmpSelect.Height-1;

   for y := 0 to h do begin

    A := timg[MainForm.ActiveMDIChild.Tag].image.ScanLine[y];
    P := timg[MainForm.ActiveMDIChild.Tag].bmpSelect.ScanLine[y];

    for x := 0 to w do begin

     if P^.R=cs then begin
       A^.R := A^.R shr 1 + cs;
       A^.G := A^.G shr 1 + g;
       A^.B := A^.B shr 1 + b;
     end;

     inc(A);
     inc(P);
    end;

   end;

 MainForm.ImageTRepaint;

end;
}


procedure shKolor(const p: TColor);
begin
 FSelectColor.initKolor(p);
 UstawWskaznik;
end;


procedure WlaczPalete(const c: string);
var t,l: integer;
begin

 if not(FSelectColor.Visible) then begin

  form1.SetFormPos('FSelectColor', t, l);
  FSelectColor.Top:=t;
  FSelectColor.Left:=l;

 end;

 FSelectColor.Caption:=c;
 FSelectColor.Visible:=true;
end;


function UstawKolor(const a: byte): byte;
var y, i: integer;
    v: byte;
begin

 y:=FEditPMG.GetLineValue;

 v:=0; i:=0;

 if FEditPMG.GetPlayer5Value(y,false)>0 then begin
  case a of
    1: begin i:=1; v:=1 end;
    2: begin i:=3; v:=2 end;
    3: begin i:=5; v:=3 end;
    4: begin i:=7; v:=4 end;

    7: begin i:=2; v:=5 end;
    8: begin i:=4; v:=5 end;
    9: begin i:=6; v:=5 end;
   10: begin i:=8; v:=5 end;
  end;
 end else begin
  case a of
    1: begin i:=1; v:=1 end;
    2: begin i:=3; v:=2 end;
    3: begin i:=5; v:=3 end;
    4: begin i:=7; v:=4 end;

    7: begin i:=2; v:=1 end;
    8: begin i:=4; v:=2 end;
    9: begin i:=6; v:=3 end;
   10: begin i:=8; v:=4 end;
  end;
 end;

 AktywnyWskaznik:=i; UstawWskaznik;

 Ofset:=$400+(v shl 8)*ord(v<>5);

 Result:=v;                 // !!! wartoœæ 1..8 !!!
end;


procedure TFEditPMG.Panel1Click(Sender: TObject);
var v, a: smallint;
    zm: string;
begin

 a:=TPanel(Sender).Tag;

 v:=ustawKolor(a);

 if v=5 then zm:='OR3' else zm:='PM'+IntToStr(v-1);

 if not(panel6.Visible) then WlaczPalete('Select COL'+zm);

 shKolor(spr_panel[v].Color);

 Ustaw_Reszte_Kolorow_Duchow(GetLineValue);

end;


procedure TFEditPMG.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 if Button=mbRight then begin
  form1.Zamknij(f_SelectColor);

  ustawKolor( TPanel(Sender).Tag );
 end;

end;


procedure TFEditPMG.check_refresh;
var i: integer;
begin

if FCheck.visible then begin

 form1.NewFormPos('FCheck', FCheck.top, FCheck.left);

 i:=FCheck.ListView1.ItemIndex;

 form1.Check1.Checked:=false;
 form1.Check1Execute(FCheck);

 if i>=0 then
  with FCheck.ListView1 do begin
   Selected    := Items[i];
   ItemFocused := Selected;

   Scroll(0, Items[i].Top - Height shr 1);
  end;

end;

end;


procedure TFEditPMG.Line(const q:cardinal; rat:byte; const pmx,py:integer);
(*----------------------------------------------------------------------------*)
(* tutaj beda ustawiane odpowiednie bity w zaleznosci od tego                 *)
(* czy jest to sprite bit8=0 czy pocisk bit8=1                                *)
(*----------------------------------------------------------------------------*)
var i, j, siz, v: byte;
    bit, nr: byte;
    spr: word;
    idx: integer;
begin

bit:=q shr 24;
nr:=byte(q shr 16);

spr:=q and $0000ff00;

if Ustaw then begin

 if rat=0 then rat:=1;
 if bit=0 then siz:=(rat shl 3) else siz:=(rat shl 1);

//tutaj zaznaczymy ze wogole zostal uzyty jakis sprite
 for i:=0 to siz-1 do Sprajt[py, pmx+i]:=Sprajt[py, pmx+i] or nr;

 for i:=0 to (siz div rat)-1 do begin

  case PMGChangeMode of
   bClear: Smask[spr+py]:=0;   // kasuj sprita jesli uzywamy przycisku CLEAR 'Clear sprite data'
    bFill: Smask[spr+py]:=$ff; // wypelnij wartoscia $FF sprita jesli uzywamy przycisku FILL 'Fill sprite data'
  end;

  v:=Smask[spr+py] and twyt1[i];     //a tutaj przepiszemy

  for j:=0 to rat-1 do begin         //jego ksztalt
   idx:=pmx+i*rat+j;

   if v>0 then
    SprajtX[py, idx]:=SprajtX[py, idx] or nr
   else
    SprajtX[py, idx]:=SprajtX[py, idx] and (nr xor $ff);

  end;

 end;

end;

end;


procedure PriorityUpdate(value: integer);
begin

with FEditPMG do
 case {udPrior.Position}value of
  -3: begin lPrior.Caption := '0'; Prior := 4; end;
  -2: begin lPrior.Caption := '1'; Prior := 2; end;
  -1: begin lPrior.Caption := '2'; Prior := 1; end;
   0: begin lPrior.Caption := '4'; Prior := 0; end;
   1: begin lPrior.Caption := '8'; Prior := 3; end;
 end;

 Prior_old:=$ff;

end;



procedure TFEditPMG.udPriorChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);
begin

 if FEditPMG.Allow then begin

 FEditPMG.caption:=inttostr(newValue);

 PriorityUpdate(NewValue);

 FEditPMG.SetPrior(Prior,true);

 end;


end;


procedure SetPriorText(const a: byte; const p:shortint);
var i: integer;
    s, t, Result: AnsiString;
begin

 t:='';
 s:=_tPrior[a];

 if FEditPMG.chbPlayer5.Checked then begin  // 4-th Player enabled

  for i := 1 to length(s) do
   if s[i]<>'M' then t:=t+s[i];

 end else begin                             // 4-th Player disabled

  t:=s;
  i:=AnsiPos('P4-',t); if i>0 then delete(t, i, 3);

 end;

 Result:=t;

 i:=FEditPMG.GetLineValue;

 FEditPMG.lPriority.Color:=clBtnFace;

 case gfxMode[i shr 3] of
  1: begin
      while AnsiPos('-PF0-',Result)>0 do delete(Result, AnsiPos('-PF0-', Result), 4);
      while AnsiPos('-PF3-',Result)>0 do delete(Result, AnsiPos('-PF3-', Result), 4);

      if not (a in [2,4]) then begin
        FEditPMG.lPriority.Color:=clRed;
        Result:='U N A V A I L A B L E';
      end;

     end;

  4: while AnsiPos('PF',Result)>0 do delete(Result, AnsiPos('PF', Result), 4);
 end;


 FEditPMG.lPriority.Caption := Result;

 PriorityUpdate(p);

end;


function TFEditPMG.SetPrior(var a:byte; const x:Boolean): shortint;
begin

if a<>Prior_old then begin

// if (Pixel=1) and not(a in [4,2]) then a:=2;
// if (Pixel=0) and (a<>2) then a:=2;

 Prior_old:=a;

if prev=___PMG then
     case a of
          0: move(pr0_null, tprior, sizeof(tprior));
        1,4: move(pr1_null, tprior, sizeof(tprior));
        2,3: move(pr2_null, tprior, sizeof(tprior));
     end

 else

  case a of
   2: begin
       move(pr2,tprior,sizeof(tprior));
       if x then begin SetPriorText(2, -2); Result := -2 end;      // 1
      end;

   1: begin
       move(pr1,tprior,sizeof(tprior));
       if x then begin SetPriorText(1, -1); Result := -1 end;      // 2
      end;

   0: begin
       move(pr0,tprior,sizeof(tprior));
       if x then begin SetPriorText(0, 0); Result := 0 end;        // 4
      end;

   3: begin
       move(pr3,tprior,sizeof(tprior));
       if x then begin SetPriorText(3, 1); Result := 1 end;        // 8
      end;

   4: begin
       move(pr4,tprior,sizeof(tprior));
       if x then begin SetPriorText(4, -3); Result := -3 end;      // 0
      end;

  end;

end;

end;


procedure WskazLiniePionowe(v1,v2: integer; const c: integer);
begin

 if FEditPMG.Visible then begin

  v2:=v2 and $8f;

  if v2<128 then begin

   form1.Shape1.Visible:=true;
   form1.Shape2.Visible:=true;

   v1:=v1 shl 1 + pozX;
   if v2=0 then v2:=1;
   form1.Ustaw_Button4_5(-1,-1,v1,v1+(v2*c) shl 1-1);

  end else begin
   form1.Shape1.Visible:=false;
   form1.Shape2.Visible:=false;
  end;

 end;

end;


procedure ValSprite(const k:integer; const m:byte; const q:cardinal; var t:word; const x:integer);
var v, v2: word;
    c: byte;
begin

 v2:=(m and $fe);

 if k<-32 then begin
  v2:=$80;
  v:=$8000;
 end else
  v:=byte(byte(k) and $00ff) or (v2 shl 8);

 if Ustaw then t:=v;

 if k>-33 then FEditPMG.Line(q,m, k,x);

 c:=q and $ff;

 WskazLiniePionowe(k,v2,c);
end;


function TFEditPMG.get_pmg_size: byte;
begin

 Result:=spr_size[AktywnyWskaznik].Position;

 if AktywnyWskaznik and 1>0 then
  pmg_div:=1
 else
  pmg_div:=4;

end;


procedure TFEditPMG.set_pmg_size(const a: byte);
begin
 spr_size[AktywnyWskaznik].Position := a;
end;


function TFEditPMG.get_pmg_posx: integer;
begin
 Result := spr_posx[AktywnyWskaznik].Position + 32;
end;


procedure TFEditPMG.set_pmg_posx(const a: integer);
begin
 spr_posx[AktywnyWskaznik].Position := a;
end;


procedure TFEditPMG.SetSprite(const t: byte; i,j: integer);
var x, v: integer;
    player5, mlc, pmg_penW: byte;
    px: array [1..8] of integer;
begin

{
if SpecialStr[___doublescan].val then begin
 i:=(i div 2)*2;
 j:=(j div 2)*2+1;

// frameLineRange1.seLine.Position:=i;
// frameLineRange1.seRange.Position:=j;
end;
}

ustawKolor(NewPosXTag[t]);

AktywnyWskaznik:=t; UstawWskaznik;

ply5:=FEditPMG.chbPlayer5.Checked;
player5:=ord(ply5);

MLCpmg:=FEditPMG.chbMLC.Checked;
mlc:=ord(MLCpmg);

{if form8.CheckBox1.Checked then begin
 player5:=1; ply5:=true;
end else begin
 player5:=0; ply5:=false;
end;}

pmg_penW:=FEditPMG.get_pmg_size;


px[t]:=spr_posx[t].Position;

if (PMGChangeMode=bDelete) and Ustaw then px[t]:=-33;

// najstarszy bajt to SIZE, najmlodszy to pozycja X
// najstarszy bajt ma ustawiony 8bit gdy obiekt jest wylaczony = -2
for x:=i to i+j do
if x in [0..239] then begin

if Ustaw then
 for v:=Low(tablica_sprite) to High(tablica_sprite) do begin
  Sprajt[x, v]:=Sprajt[x, v] and (tand_pmg[t] xor $ff);    //czysc linie ze spritem
  SprajtX[x, v]:=SprajtX[x, v] and (tand_pmg[t] xor $ff);
 end;

 with FEditPMG do
  case t of
   1: ValSprite(px[1],pmg_penW,$00010008,Spr0[x],x);

   2: ValSprite(px[2],pmg_penW,$80020102,Mis0[x],x);

   3: ValSprite(px[3],pmg_penW,$00040208,Spr1[x],x);

   4: ValSprite(px[4],pmg_penW,$80080302,Mis1[x],x);

   5: ValSprite(px[5],pmg_penW,$00100408,Spr2[x],x);

   6: ValSprite(px[6],pmg_penW,$80200502,Mis2[x],x);

   7: ValSprite(px[7],pmg_penW,$00400608,Spr3[x],x);

   8: ValSprite(px[8],pmg_penW,$80800702,Mis3[x],x);
  end;

 if Ustaw then begin
  Spr0[x]:=(Spr0[x] and $8fff) or ((prior shl 12) and $7000);
  Spr1[x]:=(Spr1[x] and $8fff) or (((player5+mlc shl 1) shl 12) and $7000);
 end;

end;

{ if FEditPMG.Visible then
  for x:=1 to 8 do begin
   v:=FEditPMG.spr_posx[x].Position;

   if v>-33 then inc(v,32);
   FEditPMG.spr_posx[x].Text:=IntToStr(v);
  end; }

end;


procedure NewZakres(nr:byte; const y:integer);
type
    Ptemp = ^tab_word256;

var p, p2, c, pl, pl2, mlc, mlc2: byte;
    a, pupa: word;
    start, koniec, i: integer;

    temp: Ptemp;

begin

 New(temp);

 FEditPMG.frameLineRange1.seLine.Position:=0;
 FEditPMG.frameLineRange1.seRange.Position:=0;

 case nr of
  1: move(Spr0, temp^, $200);
  2: move(Mis0, temp^, $200);
  3: move(Spr1, temp^, $200);
  4: move(Mis1, temp^, $200);
  5: move(Spr2, temp^, $200);
  6: move(Mis2, temp^, $200);
  7: move(Spr3, temp^, $200);
  8: move(Mis3, temp^, $200);
 end;

 dec(nr);
 a:=temp^[y];

 p:=FEditPMG.GetPrior(y);                  // odczytaj piorytet
 pl:=FEditPMG.GetPlayer5Value(y,false);    // odczytaj status 5-go gracza
 mlc:=FEditPMG.GetMLCValue(y,false);       // odczytaj status MLC

 if (nr in [1,3,5,7]) and (pl=1) then
  pupa:=$400
 else
  pupa:=(nr shr 1) shl 8+$500;

 c:=tabKolor[pupa+y]; start:=y; koniec:=y;

 for i:=y downto 0 do begin
  p2:=FEditPMG.GetPrior(i);
  pl2:=FEditPMG.GetPlayer5Value(i,false);
  mlc2:=FEditPMG.GetMLCValue(i,false);

  if (temp^[i]=a) and (p=p2) and (pl=pl2) and
     (mlc=mlc2) and (c=tabKolor[pupa+i]) then
                                          start:=i
                                         else
                                          Break;
 end;


 for i:=y to Wysokosc-1 do begin
  p2:=FEditPMG.GetPrior(i);
  pl2:=FEditPMG.GetPlayer5Value(i,false);
  mlc2:=FEditPMG.GetMLCValue(i,false);

  if (temp^[i]=a) and (p=p2) and (pl=pl2) and
     (mlc=mlc2) and (c=tabKolor[pupa+i]) then
                                          koniec:=i
                                         else
                                          Break;
 end;

 FEditPMG.frameLineRange1.seLine.Position:=start;
 FEditPMG.frameLineRange1.seRange.Position:=koniec-start;

 Dispose(temp);
end;


procedure ZakresAkt(const q: byte; const v: word; const p: integer);
(*----------------------------------------------------------------------------*)
(* sx -> pozycja pozioma sprita                                               *)
(* sy -> szerokosc sprita                                                     *)
(*----------------------------------------------------------------------------*)
var x, y, sy: integer;
    c, nr: byte;
begin

 c:=q shr 4;
 nr:=q and $0f;

 x:=v shr 8; y:=v and $00ff; sy:=x and $0f;
 if x>127 then y:=-33;// else inc(y,32);

 FEditPMG.spr_posx[nr].Position:=y;
 FEditPMG.spr_size[nr].Position:=sy;

 if AktywnyWskaznik=nr then begin

  y:=y and $8f;

  WskazLiniePionowe(x,y,c);

  NewZakres(nr, p);
 end;

end;


procedure akt;
var i,j: integer;
begin

 if FEditPMG.Visible then begin

{  for i:=1 to 8 do begin
   a:=StrToInt(FEditPMG.spr_posx[i].Text);

   if (a<Low(tablica_sprite)) or (a>224) then
    a:=-33
   else
    dec(a,32);

   FEditPMG.spr_posx[i].Position:=a;
  end;
}
  i:=FEditPMG.GetLineValue;
  j:=FEditPMG.GetRangeValue;

  Ustaw:=false; FEditPMG.SetSprite(AktywnyWskaznik, i,j);

 end;

end;


procedure TFEditPMG.Ustaw_Reszte_Kolorow_Duchow(const i: integer);
var c, x: byte;
    zm: string;
begin

 for x:=1 to 4 do begin
  c:=TabKolor[i+(x+4) shl 8];
  spr_panel[x].Hint:=form1.Hex(c,2);
  spr_panel[x].Color:=AtariPal[c];
 end;

 if GetPlayer5Value(i,false)>0 then begin
  c:=TabKolor[i+$400]; zm:=form1.Hex(c,2);
  spr_panel[5].Hint:=zm; spr_panel[6].Hint:=zm;
  spr_panel[7].Hint:=zm; spr_panel[8].Hint:=zm;
  spr_panel[5].Color:=AtariPal[c]; spr_panel[6].Color:=AtariPal[c];
  spr_panel[7].Color:=AtariPal[c]; spr_panel[8].Color:=AtariPal[c];
 end else begin
  spr_panel[5].Hint:=spr_panel[1].Hint; spr_panel[6].Hint:=spr_panel[2].Hint;
  spr_panel[7].Hint:=spr_panel[3].Hint; spr_panel[8].Hint:=spr_panel[4].Hint;
  spr_panel[5].Color:=spr_panel[1].Color; spr_panel[6].Color:=spr_panel[2].Color;
  spr_panel[7].Color:=spr_panel[3].Color; spr_panel[8].Color:=spr_panel[4].Color;
 end;

end;


function TFEditPMG.GetPlayer5Value(const i:integer; const a:Boolean): byte;
var p: byte;
begin

 if not(BlokadaRastra) and (t_mode(form1.SelectMode.ItemIndex)<>m_dli) then
  p:=rKolor[i,9] and $10
 else
  p:=(Spr1[i] shr 12) and 1;

 ply5 := (p<>0);
 if a then chbPlayer5.Checked:=ply5;

 Result:=p;
end;


function TFEditPMG.GetMLCValue(const i:integer; const a:Boolean): byte;
var p: byte;
begin

 if not(BlokadaRastra) and (t_mode(form1.SelectMode.ItemIndex)<>m_dli) then
  p:=rKolor[i,9] and $20
 else
  p:=(Spr1[i] shr 13) and 1;

 MLCpmg := (p<>0);
 if a then FEditPMG.chbMLC.Checked := MLCpmg;

 Result := p;
end;


function TFEditPMG.GetPrior(const i: integer): byte;
begin

 case gfxMode[i shr 3] of
  0: if Pixel in [1,4] then Result:=2 else Result:=(Spr0[i] shr 12) and 7;
  4: Result:=2;
 else
  Result:=(Spr0[i] shr 12) and 7;
 end;

end;


procedure TFEditPMG.AktualizujSprity;
var i: integer;
begin

useGet:=true;

i:=FEditPMG.GetLineValue;

FEditPMG.Ustaw_Reszte_Kolorow_Duchow(i);

Prior_old:=$ff;
Prior:=FEditPMG.GetPrior(i);

FEditPMG.udPrior.Position := FEditPMG.SetPrior(Prior,true);


FEditPMG.GetPlayer5Value(i,true);

ZakresAkt($81 , Spr0[i], i);
ZakresAkt($22 , Mis0[i], i);

ZakresAkt($83 , Spr1[i], i);
ZakresAkt($24 , Mis1[i], i);

ZakresAkt($85 , Spr2[i], i);
ZakresAkt($26 , Mis2[i], i);

ZakresAkt($87 , Spr3[i], i);
ZakresAkt($28 , Mis3[i], i);

akt;

useGet:=false;
end;


procedure TFEditPMG.fColorClick(Sender: TObject);
begin
 FillPMGColors.Enabled:=fColor.Checked or fSaturation.Checked;
end;


procedure TFEditPMG.pmgCHANGEClick(Sender: TObject);
var s: string;
begin

 PMGChangeMode:=tPMGChange(TPopupMenu(Sender).Tag);

 pmgChange.Checked:=false;
 pmgClear.Checked:=false;
 pmgFill.Checked:=false;
 pmgDelete.Checked:=false;
 pmgEdit.Checked:=false;

 case PMGChangeMode of
  bChange: begin pmgChange.Checked:=true; s:='CHANGE' end;
   bClear: begin pmgClear.Checked:=true; s:='CLEAR' end;
    bFill: begin pmgFill.Checked:=true; s:='FILL' end;
  bDelete: begin pmgDelete.Checked:=true; s:='DELETE' end;
    bEdit: begin pmgEdit.Checked:=true; s:='EDIT' end;
 end;

 Apply.Hint:='Apply '+s;

end;


procedure TFEditPMG.ChangeButton;
var i,j: integer;
begin
 i:=FEditPMG.GetLineValue;
 j:=FEditPMG.GetRangeValue;

 Ustaw:=true; SetSprite(AktywnyWskaznik, i,j); Ustaw:=false;

 form1.ZamienGrafike;

 WskazLinie;

 FEditPMG.Ustaw_Reszte_Kolorow_Duchow(GetLineValue);
end;


procedure UpdatePMGClick(Sender: TObject);
var a,i,j: integer;
begin
 ustawKolor( TBMDSpinEdit(Sender).Tag );

 i:=FEditPMG.GetLineValue;
 j:=FEditPMG.GetRangeValue;

 Ustaw:=false; FEditPMG.SetSprite(AktywnyWskaznik, i,j);

 a:=1;

 if SpecialStr[___AlignPMG].val then
  case FEditPMG.spr_size[AktywnyWskaznik].Position of
   2: a:=2;
   4: a:=4;
  else
   a:=1;
  end;

 FEditPMG.spr_posx[AktywnyWskaznik].Increment:=a;

// spr_posx[AktywnyWskaznik].Text:=IntToStr((StrToInt(spr_posx[AktywnyWskaznik].Text) div a)*a);

 FEditPMG.spr_posx[AktywnyWskaznik].Position:=(FEditPMG.spr_posx[AktywnyWskaznik].Position div a)*a;

 FEditPMG.WskazLinie;

end;


procedure TFEditPMG.Button5Click(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CHANGE SPRITES                                                             *)
(*----------------------------------------------------------------------------*)
var chg: array [0..7] of integer;
    Smask_copy: array [0..$800] of byte;
    y, yS, yE: integer;
begin

yS:=GetLineValue; yE:=GetRangeValue;

SaveAfterExit:=true;
form1.ZapiszUndo;

with FEditPMG do begin
// wartosci
// p0,p1,p2,p3,m0,m1,m2,m3

// players
 chg[0]:=spr_combo[1].ItemIndex; chg[1]:=spr_combo[3].ItemIndex;
 chg[2]:=spr_combo[5].ItemIndex; chg[3]:=spr_combo[7].ItemIndex;

// missiles
 chg[4]:=spr_combo[2].ItemIndex+4; chg[5]:=spr_combo[4].ItemIndex+4;
 chg[6]:=spr_combo[6].ItemIndex+4; chg[7]:=spr_combo[8].ItemIndex+4;
end;

move(TabKolor[$500], bufor, $400);
move(Smask, Smask_Copy, sizeof(Smask));


for y:=yS to yS+yE do begin
 
 Smask[y+$000]:=Smask_copy[y+(chg[0] shl 1) shl 8];      //p0
 Smask[y+$200]:=Smask_copy[y+(chg[1] shl 1) shl 8];      //p1
 Smask[y+$400]:=Smask_copy[y+(chg[2] shl 1) shl 8];      //p2
 Smask[y+$600]:=Smask_copy[y+(chg[3] shl 1) shl 8];      //p3

 Smask[y+$100]:=Smask_copy[y+((chg[4]-4) shl 1+1) shl 8];  //m0
 Smask[y+$300]:=Smask_copy[y+((chg[5]-4) shl 1+1) shl 8];  //m1
 Smask[y+$500]:=Smask_copy[y+((chg[6]-4) shl 1+1) shl 8];  //m2
 Smask[y+$700]:=Smask_copy[y+((chg[7]-4) shl 1+1) shl 8];  //m3

 TabKolor[$500+y]:=bufor[chg[0] shl 8+y];
 TabKolor[$600+y]:=bufor[chg[1] shl 8+y];
 TabKolor[$700+y]:=bufor[chg[2] shl 8+y];
 TabKolor[$800+y]:=bufor[chg[3] shl 8+y];

// str(chg[0],zm); label10.Caption:=zm;
end;

form1.ZamienGrafike;
end;


procedure TFEditPMG.ComboBoxChange(Sender: TObject);
begin

 AktywnyWskaznik:=TComboBox(Sender).Tag;
 shKolor(spr_panel[(AktywnyWskaznik+1) shr 1].Color);

end;


procedure Krawedz(const kier: shortint);
var p, i, j, k, m, vi, x, z: integer;
    v, v2: word;
    siz, t, old: byte;
    c: TColor;
    zm: string;
begin
i:=FEditPMG.GetLineValue;
j:=FEditPMG.GetRangeValue;

t:=AktywnyWskaznik;

vi:=FEditPMG.spr_size[AktywnyWskaznik].Position;

if AktywnyWskaznik and 1>0 then siz:=8 else siz:=2;

x:=FEditPMG.spr_posx[AktywnyWskaznik].Position;  if x<0 then exit;

//if x<1 then x:=0;

case vi of
 2: siz:=siz shl 1;
 4: siz:=siz shl 2;
end;

if kier>0 then x:=x+siz;

x:=x shl 1;

//glowna petla
str(vi,zm); Ustaw:=true;

img1.Canvas.Draw(0,0,form1.Image1.Picture.Graphic);

//--- let's go
for p:=i to i+j do begin

 for z:=Low(tablica_sprite) to High(tablica_sprite) do begin
  Sprajt[p, z]:=Sprajt[p, z] and (tand_pmg[t] xor $ff);   //czysc linie ze spritem
  SprajtX[p, z]:=SprajtX[p, z] and (tand_pmg[t] xor $ff);
 end;

v:=0;
if kier>0 then begin
 c:=img1.Canvas.Pixels[x,p];
 while c=img1.Canvas.Pixels[x+v,p] do inc(v);
end else begin
 c:=img1.Canvas.Pixels[x-1,p];
 while c=img1.Canvas.Pixels[x-v-1,p] do inc(v);
end;
if kier>0 then inc(v) else dec(v);

if kier>0 then k:=((x+v) shr 1)-siz else k:=((x-v) shr 1);
m:=vi;

if k<Low(tablica_sprite) then k:=Low(tablica_sprite) else
 if k>224 then k:=224;                             // zakres pozycji PM -32..224

v2:=(m and $fe); if k<0 then v2:=v2 or $80;
v:=(k and $00ff) or (v2 shl 8);

old:=(Spr1[p] shr 12) and 3;

case AktywnyWskaznik of
 1: begin Spr0[p]:=v; FEditPMG.Line($00010000,m, k,p); end;
 2: begin Mis0[p]:=v; FEditPMG.Line($80020100,m, k,p); end;
 3: begin Spr1[p]:=v; FEditPMG.Line($00040200,m, k,p); end;
 4: begin Mis1[p]:=v; FEditPMG.Line($80080300,m, k,p); end;
 5: begin Spr2[p]:=v; FEditPMG.Line($00100400,m, k,p); end;
 6: begin Mis2[p]:=v; FEditPMG.Line($80200500,m, k,p); end;
 7: begin Spr3[p]:=v; FEditPMG.Line($00400600,m, k,p); end;
 8: begin Mis3[p]:=v; FEditPMG.Line($80800700,m, k,p); end;
end;

Spr0[p]:=(Spr0[p] and $8fff) or ((prior shl 12) and $7000);
Spr1[p]:=(Spr1[p] and $8fff) or ((old shl 12) and $7000);

end;

Ustaw:=false;

form1.ZamienGrafike;
end;


procedure TFEditPMG.Button6Click(Sender: TObject);
// EDGE
begin
 Self.ActiveControl:=nil;

 SaveAfterExit:=true;
 form1.ZapiszUndo;

 Krawedz(TButton(Sender).Tag);
end;


procedure UstawPlayer5(const a: Boolean);
begin
 ply5:=a;

 form1.set_pm_colors;
end;


procedure UstawMLC(const a: Boolean);
begin
 MLCpmg:=a;

 form1.set_pm_colors;
end;


procedure TFEditPMG.chbPlayer5Click(Sender: TObject);
var i: integer;
    c, x: byte;
    zm: string;
begin

 i:=GetLineValue;

 for x:=1 to 4 do begin
  c:=TabKolor[i+(x+4) shl 8];
  spr_panel[x].Hint:=form1.Hex(c,2);
  spr_panel[x].Color:=AtariPal[c];
 end;


 if chbPlayer5.Checked then begin
  UstawPlayer5(true);
  chbMLC.Caption:=' Multicolor Players';
  chbMLC.Hint:='Multicolor Players';
  chbPlayer5.Hint:='5-th Player (Color Missiles = COLOR3)';

  c:=TabKolor[i+$400]; zm:=form1.Hex(c,2);
  spr_panel[5].Hint:=zm; spr_panel[6].Hint:=zm;
  spr_panel[7].Hint:=zm; spr_panel[8].Hint:=zm;
  spr_panel[5].Color:=AtariPal[c]; spr_panel[6].Color:=AtariPal[c];
  spr_panel[7].Color:=AtariPal[c]; spr_panel[8].Color:=AtariPal[c];

 end else begin
  UstawPlayer5(false);
  chbMLC.Caption:=' Multicolor PM';
  chbMLC.Hint:='Multicolor Players and Missiles';
  chbPlayer5.Hint:='5-th Player (Color Missiles = Color Players)';

  spr_panel[5].Hint:=spr_panel[1].Hint; spr_panel[6].Hint:=spr_panel[2].Hint;
  spr_panel[7].Hint:=spr_panel[3].Hint; spr_panel[8].Hint:=spr_panel[4].Hint;
  spr_panel[5].Color:=spr_panel[1].Color; spr_panel[6].Color:=spr_panel[2].Color;
  spr_panel[7].Color:=spr_panel[3].Color; spr_panel[8].Color:=spr_panel[4].Color; end;

 Prior_old:=$ff;

 FEditPMG.udPrior.Position := FEditPMG.SetPrior(Prior,true);


// form8.Ustaw_Reszte_Kolorow_Duchow(i);

 form1.Zamknij(f_SelectColor);
end;


procedure TFEditPMG.init_edit_sprites(const j: integer; const v:byte);
begin

 UstawKolor(v);

 frameLineRange1.seLine.Position:=j;
 frameLineRange1.seRange.Position:=0;

end;


procedure TFEditPMG.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then form1.Zamknij(f_EditPMG);
end;


procedure TFEditPMG.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FEditPMG', top, left);

 form1.Zamknij(f_SelectColor);

 form1.EditPMG.Checked:=false;
 form1.ChangePMG.Checked:=false;

 form1.Shape1.Enabled:=true;

 Panel5.Visible:=false; Panel6.Visible:=false;

 form1.Image4.Visible:=false;
 form1.image4.Enabled:=true;

 form1.tbEditPMG.Down:=false;

 if not(FEditRasters.visible) then form1.Usun_Zaznaczenia(false);

 form1.set_pf_colors;
 form1.Refresh;
end;


procedure TFEditPMG.SetPosSprite(const x,y: integer);
var i: integer;
begin

 with FEditPMG do begin
  frameLineRange1.seLine.Position:=y;

  editDraw:=false;

  i:=((x{+CzarnyPas}) shr 1); //+32;

  if SpecialStr[___AlignPMG].val then
   case spr_size[AktywnyWskaznik].Position of
    2: i:=(i shr 1) shl 1;
    4: i:=(i shr 2) shl 2;
   end;

  spr_posx[AktywnyWskaznik].Position:=i;
 end;

end;


procedure TFEditPMG.FormShow(Sender: TObject);
begin

 form1.Zamknij(f_Move);

 AktywnyWskaznik:=1; //AktualizujSprity;

 SetPosSprite(pSel.x , pSel.y);

 WskazLinie;

 spr_panel[1].SetFocus;

end;


procedure TFEditPMG.FormCreate(Sender: TObject);
var i, j: integer;

const
    p: array [0..1] of String = ('Player ','Missile ');

begin

 for i:=0 to 7 do begin

  with TLabel.Create(self) do begin
   Width:=11;
   Height:=16;
   Left:=56;
   Top:=5+i*24+(i shr 1) shl 3;
//   Font.Name:='Arial';
   Caption:='<';
   Font.Size:=9;
   Font.Style:=[fsBold];
   Parent:=panel5;
   Transparent:=false;
  end;

  with TComboBox.Create(self) do begin
   Parent:=panel5;
   Width:=41;
   Height:=21;
   Left:=9;
   Top:=3+i*24+(i shr 1) shl 3;
   Enabled:=false;
   Style:=csDropDownList;
   Items.Add(_tPrior[1][i and 1+1]+IntToStr(i shr 1));
   ItemIndex:=0;
  end;

  with TComboBox.Create(self) do begin
   Parent:=panel5;
   Width:=41;
   Height:=21;
   Left:=72;
   Top:=3+i*24+(i shr 1) shl 3;
   Style:=csDropDownList;
   for j:=0 to 3 do Items.Add(_tPrior[1][i and 1+1]+IntToStr(j));
   Tag:=i+1;
   OnChange:=ComboBoxChange;
  end;

  with TPanel.Create(self) do begin
   Left:=5;
   Top:=7+i*24+(i shr 1) shl 3;
   Width:=25;
   Height:=22;
   BevelInner:=bvNone;
   BevelOuter:=bvNone;
   BevelKind:=bkFlat;
   BorderStyle:=bsNone;
   Cursor:=crHandPoint;
   ParentBackground:=false;
   ShowHint:=true;
   Parent:=FEditPMG;
   Tag:=i shr 1+(i and 1)*6+1;
   OnClick:=Panel1Click;
   OnMouseDown:=Panel1MouseDown;
  end;

  with TBMDSpinEdit.Create(self) do begin
   Left:=48;
   Top:=7+i*24+(i shr 1) shl 3;
   Parent:=FEditPMG;
   EditLabel.Caption:='X';
   EditLabel.Font.Style:=[fsBold];
   LabelPosition:=lpLeft;
   Precision:=0;
   MaxValue:=224;
   MinValue:=-33;
   Value:=-33;
   Increment:=1;
   Tag:=i+$10;
   Width:=25+25;
   Height:=21;
   GaugeHeight:=0;                // !!! koniecznie przez TrackBarEnabled !!!
   UpDownOrientation:=udHorizontal;
   TrackBarEnabled:=false;
//   ReadOnly:=true;
   Hint:='Horizontal Position '+p[i and 1]+IntToStr(i shr 1);
   ShowHint:=true;
   OnContextPopup:=DisableContextPopup;
   OnChange:=NewPMGChange;
   OnClick:=NewPMGClick;
   Visible:=true;
  end;

  with TBMDSpinEdit.Create(self) do begin
   Left:=112+4;
   Top:=7+i*24+(i shr 1) shl 3;
   Parent:=FEditPMG;
   EditLabel.Caption:='S';
   EditLabel.Font.Style:=[fsBold];
   LabelPosition:=lpLeft;   
   Precision:=0;
   MaxValue:=4;
   MinValue:=0;
   Value:=0;
   Increment:=2;
   Tag:=i+$30;
   Width:=25+17+2-4;
   Height:=21;
   GaugeHeight:=0;                // !!! koniecznie przez TrackBarEnabled !!!
   UpDownOrientation:=udHorizontal;
   TrackBarEnabled:=false;
   Color:=clMoneyGreen;
   ReadOnly:=true;
   Hint:='Size '+p[i and 1]+IntToStr(i shr 1);
   ShowHint:=true;
   OnContextPopup:=DisableContextPopup;
   OnChange:=NewPMGChange;
   OnClick:=NewPMGClick;
   Visible:=true;
  end;

 end;

 Panel5.BringToFront;

 for i:=0 to ComponentCount-1 do begin

  if Components[i] is TComboBox then
   if TComboBox(Components[i]).Tag>0 then spr_combo[TComboBox(Components[i]).Tag]:=TComboBox(Components[i]);

  if Components[i] is TBMDSpinEdit then
   if TBMDSpinEdit(Components[i]).Tag in [$30..$37] then begin
    spr_size[TBMDSpinEdit(Components[i]).Tag-$30+1]:=TBMDSpinEdit(Components[i]);
    spr_size[TBMDSpinEdit(Components[i]).Tag-$30+1].Tag:=NewPosXTag[TBMDSpinEdit(Components[i]).Tag-$30+1];
   end;

  if Components[i] is TBMDSpinEdit then
   if TBMDSpinEdit(Components[i]).Tag in [$10..$17] then begin
    spr_posx[TBMDSpinEdit(Components[i]).Tag-$10+1]:=TBMDSpinEdit(Components[i]);
    spr_posx[TBMDSpinEdit(Components[i]).Tag-$10+1].Tag:=NewPosXTag[TBMDSpinEdit(Components[i]).Tag-$10+1];
   end;

  if Components[i] is TPanel then
   case TPanel(Components[i]).Tag of
     1..4: spr_panel[TPanel(Components[i]).Tag]:=TPanel(Components[i]);
    7..10: spr_panel[TPanel(Components[i]).Tag-2]:=TPanel(Components[i]);
   end;
 end;


 FEditPMG.Allow:=true;

end;


procedure TFEditPMG.NewPMGChange(Sender: TObject);
begin

 if not UseGet then begin

  UpdatePMGClick(Sender);
  akt;

 end;

end;


procedure TFEditPMG.NewPMGClick(Sender: TObject);
begin
 ustawKolor(TBMDSpinEdit(Sender).Tag);
end;


procedure TFEditPMG.ApplyClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CHANGE, CLEAR, FILL, DELETE PMG                                            *)
(*----------------------------------------------------------------------------*)
begin
 Self.ActiveControl:=nil;

 form1.ZapiszUndo; SaveAfterExit:=true;

 ChangeButton;

 check_refresh;

 LineChange;

 form1.OdswiezObraz;                   // !!! koniecznie !!! dla testRaster

end;


function PMGColSat(kol: real; old_c: byte): byte;
var l, k, r: byte;
begin
 k:=round(kol);

 l:=k and $f0; r:=k and $0f;

 if not(FEditPMG.fColor.Checked) then l:=old_c and $f0;
 if not(FEditPMG.fSaturation.Checked) then r:=old_c and $0f;

 Result := l or r;
end;


procedure TFEditPMG.FillPMGColorsClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* FILL COLORS                                                                *)
(*----------------------------------------------------------------------------*)
var k0, k1, k2, k3, k4: byte;
    i, j, x, skip: integer;
    add, _k0, _k1, _k2, _k3, _k4: real;
begin

Self.ActiveControl:=nil;

SaveAfterExit:=true; form1.ZapiszUndo;

add:=frameAddSkip1.seAdd.Value;

skip:=frameAddSkip1.seSkip.Position;

//if skip>Wysokosc-1 then skip:=Wysokosc-1;
//if skip<1 then skip:=1;

_k0:=StrToInt(spr_panel[1].Hint);
_k1:=StrToInt(spr_panel[2].Hint);
_k2:=StrToInt(spr_panel[3].Hint);
_k3:=StrToInt(spr_panel[4].Hint);
_k4:=StrToInt(spr_panel[5].Hint);

i:=GetLineValue; j:=GetRangeValue;

x:=i;
while x<=j+i do begin

 k0:=PMGColSat(_k0, TabKolor[x+$500]);
 k1:=PMGColSat(_k1, TabKolor[x+$600]);
 k2:=PMGColSat(_k2, TabKolor[x+$700]);
 k3:=PMGColSat(_k3, TabKolor[x+$800]);
 k4:=PMGColSat(_k4, TabKolor[x+$400]);

 if GetPlayer5Value(x,false)>0 then begin
                case AktywnyWskaznik of
                 1: TabKolor[x+$500]:=k0 and $fe;
                 3: TabKolor[x+$600]:=k1 and $fe;
                 5: TabKolor[x+$700]:=k2 and $fe;
                 7: TabKolor[x+$800]:=k3 and $fe;
                 2,4,6,8: TabKolor[x+$400]:=k4 and $fe;
                end;
 end else begin
                case AktywnyWskaznik of
                 1,2: TabKolor[x+$500]:=k0 and $fe;
                 3,4: TabKolor[x+$600]:=k1 and $fe;
                 5,6: TabKolor[x+$700]:=k2 and $fe;
                 7,8: TabKolor[x+$800]:=k3 and $fe;
                end;
 end;

 _k0:=_k0+add;
 _k1:=_k1+add;
 _k2:=_k2+add;
 _k3:=_k3+add;
 _k4:=_k4+add;

 SetColLineSpr(x);

 inc(x, skip);
end;

form1.OdswiezObraz;

check_refresh;
end;


procedure TFEditPMG.chbMLCClick(Sender: TObject);
begin
 if chbMLC.Checked then
  UstawMLC(true)
 else
  UstawMLC(false);

 Ustaw_Reszte_Kolorow_Duchow(GetLineValue);

 form1.Zamknij(f_SelectColor);
end;


procedure TFEditPMG.FormMouseEnter(Sender: TObject);
begin
 klikEdit:=false;
end;


procedure TFEditPMG.frameLineRange1bGetClick(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* GET PMG                                                                    *)
(*----------------------------------------------------------------------------*)
begin
 AktualizujSprity;
end;


procedure TFEditPMG.pmg_lineClick(Sender: TObject; Button: TUDBtnType);
begin
 form1.Zamknij(f_SelectColor);
end;

procedure TFEditPMG.pmg_rangeClick(Sender: TObject; Button: TUDBtnType);
begin
 FEditPMG.Ustaw_Reszte_Kolorow_Duchow(GetLineValue+GetRangeValue);
end;


procedure TFEditPMG.LineChange;
(*----------------------------------------------------------------------------*)
(* LINE CHANGE                                                                *)
(*----------------------------------------------------------------------------*)
var i,j: integer;
begin

 if FEditPMG.Visible then begin

  i:=GetLineValue;
{
  case gfxMode[i shr 3] of
   1: udPrior.Max:=-2;
   4: udPrior.Max:=-3;
  else
    udPrior.Max:=1;
  end;
}
  FEditPMG.Ustaw_Reszte_Kolorow_Duchow(i);
  GetPlayer5Value(i,true); GetMLCValue(i,true);

  Prior_old:=$ff;
  Prior:=FEditPMG.GetPrior(i);

  FEditPMG.udPrior.Position := FEditPMG.SetPrior(Prior,true);


  i:=FEditPMG.GetLineValue;
  j:=FEditPMG.GetRangeValue;

  Ustaw:=false; SetSprite(AktywnyWskaznik, i,j);

  WskazLinie;

//  frameLineRange1.seLine.SetFocus;

  frameLineRange1.seLineChange(self);

 end;

end;


procedure TFEditPMG.frameLineRange1seLineChange(Sender: TObject);
begin
 LineChange;
end;


procedure TFEditPMG.frameLineRange1seRangeChange(Sender: TObject);
(*----------------------------------------------------------------------------*)
(* CHANGE RANGE                                                               *)
(*----------------------------------------------------------------------------*)
var i,j: integer;
begin

 if FEditPMG.Visible then begin

  i:=FEditPMG.GetLineValue;
  j:=FEditPMG.GetRangeValue;

  Ustaw:=false; SetSprite(AktywnyWskaznik, i,j);

  WskazLinie;

  frameLineRange1.seRange.SetFocus;

 end;

end;


procedure TFEditPMG.Copy;
begin
 cPMGColor:=StrToInt(spr_panel[(AktywnyWskaznik+1) shr 1].Hint);
end;


procedure PasteColor(const a: byte);
var j: integer;
    old_c: byte;
begin

 SaveAfterExit:=true;

 form1.ZapiszUndo;

 j:=FEditPMG.GetLineValue;

 old_c := TabKolor[Ofset+j];

 TabKolor[Ofset+j] := a;
 FEditColors.zapisz_palete(j);

 TabKolor[Ofset+j] := old_c;

end;


procedure TFEditPMG.Delete;
begin

 PasteColor(0);

end;


procedure TFEditPMG.DisableContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;


procedure TFEditPMG.Paste;
begin

 PasteColor(cPMGColor);

end;


procedure TFEditPMG.SelectAll;
begin
 frameLineRange1.seLine.Position:=0;
 frameLineRange1.seRange.Position:=239;
end;


procedure TFEditPMG.FillPMGColorsMenuButtonClick(Sender: TObject);
begin
  Self.ActiveControl:=nil;

  FillPMGColors.MenuButtonClick(Sender);

end;


procedure TFEditPMG.ApplyMenuButtonClick(Sender: TObject);
begin
  Self.ActiveControl:=nil;

  Apply.MenuButtonClick(Sender);

end;


end.
