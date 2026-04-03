unit Check;

interface

uses
  Windows, Controls, Forms, StdCtrls, ComCtrls, ExtCtrls, Classes, SysUtils,
  Menus, Graphics, Messages;

type
  TFCheck = class(TForm)
    ListView1: TListView;
    lWarnings: TLabel;
    lErrors: TLabel;
    Bevel1: TBevel;
    ListBox1: TListBox;
    lLimit: TLabel;
    PopupMenu1: TPopupMenu;
    Repair1: TMenuItem;
    Repair2: TMenuItem;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ListView1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Repair1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Repair2Click(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
   FListViewWndProc: TWndMethod;
   procedure ListViewWndProc(var Message: TMessage);

   var mpos, cpos: TPoint;

  public
    { Public declarations }
  end;

var
  FCheck: TFCheck;

  check_limit: byte;

implementation

{$R *.dfm}

uses Main, EditColors, EditPMG;


procedure TFCheck.ListViewWndProc(var Message: TMessage);
begin
 ShowScrollBar(ListView1.Handle, SB_HORZ, False); // hide horiz scrollbar
 FListViewWndProc(Message); // process message
end;


procedure KasujPliki;
begin
 deletefile(form1.snazwa+'.asm'); deletefile(form1.snazwa+'.scr'); deletefile(form1.snazwa+'.lst');
 deletefile(form1.snazwa+'.fnt'); deletefile(form1.snazwa+'.fad'); deletefile(form1.snazwa+'.lab');
 deletefile(form1.snazwa+'.asq'); deletefile(form1.snazwa+'.raw'); deletefile(form1.snazwa+'.mac');
 deletefile(form1.snazwa+'.all'); deletefile(form1.snazwa+'.tab'); deletefile(form1.snazwa+'.pmf');
 deletefile(form1.snazwa+'.cmp'); deletefile(form1.snazwa+'.h'); deletefile(form1.snazwa+'.vbx');
end;


procedure TFCheck.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(Key)=27 then form1.Zamknij(f_Check);
end;



function sprawdz_etykiete(s: string): word;
// zwraca numer obiektu ,  typ pmg ($80), colors ($ff)
var v: byte;
begin

 Result:=0;

 s:=AnsiUpperCase(s);

 if pos('COLOR',s)>0 then begin
  v:=StrToInt(s[length(s)]) + 1;

  Result:=$ff00 + v; exit;

 end else
  if pos('COLBA',s)>0 then begin

   Result:=$ff00; exit;
  end;


 if pos('COLPM',s)>0 then begin
  v:=StrToInt(s[length(s)]) + 1;

  Result:=$8000 + v; exit;
 end;


 if (pos('HPOSP',s)>0) or (pos('SIZEP',s)>0) then begin
  v:=StrToInt(s[length(s)]) + 1;

  Result:=$8000 + v; exit;
 end;


 if (pos('HPOSM',s)>0) then begin
  v:=StrToInt(s[length(s)]) + 7;

  Result:=$8000 + v; exit;
 end;


 if (pos('SIZEM',s)>0) then begin
  Result:=$8000 + 7; exit;
 end;

end;


procedure pokaz_listing(i: integer);
var src: TextFile;
    zm2, zm: string;
    skp, skp2: Boolean;
begin

str(i,zm);

zm:='line='+zm; zm2:='';

skp:=False; skp2:=true;


if changes[i]>0 then begin

 assignfile(src,path+'asm$$$.$$$'); reset(src);
 while not eof(src) do begin
  readln(src,zm2);

  while pos(#9,zm2)>0 do delete(zm2, pos(#9, zm2), 1);

  if (pos('line',zm2)>0) or (pos('jmp',zm2)>0) or (pos('--',zm2)>0) or
     (pos('rti',zm2)>0) or (pos('<',zm2)>0) or (pos('XXX',zm2)>0) or
     (pos('mwa',zm2)>0) or (pos('DLINEW',zm2)>0) then skp:=false;

  if (pos(zm,zm2)>0) and skp2 then begin skp:=true; skp2:=false; end;


  if pos('nop', zm2)=0 then  
  if skp then begin

   if pos('st',zm2)>0 then delete(zm2,pos('st',zm2),4);

   if (pos('wsync',zm2)>0) or (pos('$D40A',zm2)>0) then begin

    zm2:=AnsiUpperCase(zm);
    FCheck.listbox1.Items.Add(zm2);

    zm:='';

    while FCheck.ListBox1.Canvas.TextWidth(zm)<=FCheck.ListBox1.Canvas.TextWidth(zm2) do zm:=zm+'-';

    zm2:=zm;
   end;

   if pos('lda ',zm2)<1 then begin
{    k:=sprawdz_etykiete(zm2);

    case hi(k) of
     $81..$84: zm2:=zm2+' = '+form1.Hex(TabKolor[$500+lo(k) shl 8+i],2);
          $ff: zm2:=zm2+' = '+form1.Hex(TabKolor[lo(k) shl 8+i],2);
    end;}

    FCheck.listbox1.Items.Add(AnsiUpperCase(zm2));
   end;

  end;

 end;

closefile(src);
end; 

end;


procedure TFCheck.ListView1Click(Sender: TObject);
var i, x: integer;
    pmg: array [0..15] of byte;
    nam: string [16];
    k: word;
    cl: Boolean;
begin


 cpos:=mpos;

 listbox1.Clear;

 i:=listview1.ItemIndex;


 if not(form1.Image4.Visible) then begin
  form1.Shape9Enable(true);
  SelectArea.Height:=0;
 end;

 SelectArea.Top:=i shl 1;
 form1.ClrShape9;

 
 if changes[i]>0 then pokaz_listing(i);

//*********************************************//
// czy jest mozliwa optymalizacja obiektów PMG //
//*********************************************//

// zliczamy odwolania do duchow w linii

  fillchar(pmg,sizeof(pmg),0);
  cl:=false;                       // czy odwolanie do kolorow wystepuje

// zliczamy wystapienia odwolan do duchow i pociskow
 for x:=0 to High(check_list)-1 do
  if check_list[x].lin=i then begin
   nam:=check_list[x].nam;

   k:=sprawdz_etykiete(nam);

   if byte(k shr 8)=$80 then
    inc ( pmg[ byte(k and $ff) ] )
   else
    if byte(k shr 8)=$ff then cl:=true;


  end;

// jesli w linii odwolujemy sie do jednego ducha wiecej niz raz mozemy optymalizowac
 for x:=0 to 15 do
  if pmg[x]>0 then begin Repair1.Enabled:=true; Break end;

//************************************************//
// czy jest mozliwa optymalizacja kolorów bitmapy //
//************************************************//

 if cl then Repair2.Enabled:=true;

end;


procedure TFCheck.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin

 if Item.Index=0 then
  ListView1.Canvas.Brush.Color:=clLime
 else
  if Item.Index mod 8=0 then ListView1.Canvas.Brush.Color:=clMoneyGreen;

 if Fox1 then
  if Item.Index and 7 in [4] then ListView1.Canvas.Brush.Color:=clMoneyGreen;

end;


procedure TFCheck.ListView1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 mpos:=Point(x,y);
end;


procedure TFCheck.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FCheck', top, left);

 form1.Check1.Checked:=false;

 form1.Shape9Enable(false);

// form1.Refresh;
end;


procedure TFCheck.ListBox1Click(Sender: TObject);
// na podstawie nazwy rejestru otwieramy okno 'Edit Sprites' lub 'Edit Colors'
var i, j: integer;
    s: string;
    k: word;
    v: Byte;
begin
 i:=ListBox1.ItemIndex;   // linia z nazwa rejestru
 j:=ListView1.ItemIndex;  // numer linii z bledem

if i>=2 then begin

 s:=ListBox1.Items.Strings[i];

 if pos('=',s)>0 then s:=copy(s,1,pos('=',s)-2);

 K:=sprawdz_etykiete(s);

 v:=byte(k and $ff);

 case byte(k shr 8) of
  $80: begin form1.EditPMG.Checked:=false; form1.EditPMGExecute(self); FEditPMG.init_edit_sprites(j,v) end;
  $ff: begin form1.EditColors.Checked:=false; form1.EditColorsExecute(self); FEditColors.init_edit_colors(j,v) end;
 else
  begin
   form1.Zamknij(f_EditColors);
   form1.Zamknij(f_EditPMG);
  end;
 end;

 ListView1.SetFocus;

end;

end;


procedure TFCheck.PopupMenu1Popup(Sender: TObject);
begin
 Repair1.Enabled:=false;
 Repair2.Enabled:=false;

 ListView1Click(FCheck);
end;


function szukaj_wolnych(const x,y:integer): byte;
// szukamy najmniejszej liczby zmian w przedziale <x,y> i zwracamy pozycje Y
var i: integer;
    min: byte;
begin
 Result:=x;

 min:=$ff;

 for i:=x to y-1 do
  if changes[i]<min then begin min:=changes[i]; Result:=i end;

end;


procedure TFCheck.Repair1Click(Sender: TObject);
// OPTIMIZE PMG
var i, ni, x, psx: integer;
    lin, max, npmg, siz: byte;
    k: word;
    nam, txt: string [16];
    pmg: array [0..15] of byte;
    oldPMGChangeMode: tPMGChange;
begin
 i:=listview1.ItemIndex;

 lin:=0; txt:='';

 fillchar(pmg,sizeof(pmg),0);

// zliczamy wystapienia odwolan do spritow
 for x:=0 to High(check_list)-1 do
  if check_list[x].lin=i then begin
   nam:=check_list[x].nam;

   k:=sprawdz_etykiete(nam);      

   if byte(k shr 8)=$80 then inc ( pmg[ byte(k and $ff) ] );
  end;

// wybieramy ducha do ktorego najczesciej wystepowaly odwolania NPMG
 max:=0; npmg:=0;
 for x:=15 downto 0 do
  if pmg[x]>=max then begin max:=pmg[x]; npmg:=x end;

// szukamy wczesniejszych odwolan do numeru ducha NPMG
 for x:=0 to High(check_list)-1 do
  if (check_list[x].lin<i) then begin
   nam:=check_list[x].nam;

   k:=sprawdz_etykiete(nam);

   if byte(k shr 8)=$80 then
    if byte(k and $ff)=npmg then begin
     txt:=nam;
     lin:=check_list[x].lin;
    end;
  end;

 form1.Zamknij(f_EditColors);
 form1.Zamknij(f_EditPMG);

 if txt='' then exit;        // nie mozna poprawiac

 k:=sprawdz_etykiete(txt);   // numer ducha ktorym sie zajmujemy

 form1.EditPMGExecute(self);
 FEditPMG.WindowState:=wsMinimized;

 oldPMGChangeMode:=PMGChangeMode;

 PMGChangeMode:=bClear;

// odczytujemy parametry ducha do poprawki
 FEditPMG.init_edit_sprites(i, byte(k and $ff));
 FEditPMG.AktualizujSprity;

 siz:=FEditPMG.get_pmg_size;    // szerokosc ducha
 psx:=FEditPMG.get_pmg_posx;    // pozycja X ducha

// teraz odczytujemy parametry ducha poprzedzajacego
 FEditPMG.init_edit_sprites(lin, byte(k and $ff));
 FEditPMG.AktualizujSprity;

 ni:=FEditPMG.GetLineValue+FEditPMG.GetRangeValue+1;  // od tej pozycji Y mozemy wstawiac poprawki

// przedtem wypelniamy kolorem do tej pozycji, kolor z poprzedniego wystapienia ducha
 FEditPMG.frameLineRange1.seRange.Value:=i-FEditPMG.GetLineValue-1;
 FEditPMG.FillPMGColorsClick(FCheck);

// ustawiamy nowa pozycje X ducha na wolnej pozycji Y
 x:=szukaj_wolnych(ni,i); inc(changes[x]);

 FEditPMG.frameLineRange1.seRange.Value:=0;
 FEditPMG.frameLineRange1.seLine.Value:=x;

 FEditPMG.set_pmg_posx(psx);
 FEditPMG.ChangeButton;

// ustawiamy nowa szerokosc ducha na wolnej pozycji Y
 x:=szukaj_wolnych(ni,i); inc(changes[x]);

 FEditPMG.frameLineRange1.seRange.Value:=0;
 FEditPMG.frameLineRange1.seLine.Value:=x;

 FEditPMG.set_pmg_size(siz);
 FEditPMG.ChangeButton;

 PMGChangeMode:=oldPMGChangeMode;

 form1.Zamknij(f_EditPMG);
 FEditPMG.WindowState:=wsNormal;

 SaveAfterExit:=true;
 
 FEditPMG.check_refresh;
end;


procedure TFCheck.FormCreate(Sender: TObject);
//var i: integer;
begin
 ListView1.DoubleBuffered:=true;

 FListViewWndProc := ListView1.WindowProc; // save old window proc
 ListView1.WindowProc := ListViewWndProc; // subclass

end;


procedure optimize_bmp(i: integer; c: byte);
var x, y, lin: integer;
    min, old, g: byte;
    ok: Boolean;
begin
 old:=TabKolor[c shl 8+i];

 g:=gfxMode[i shr 3];

 dec(i);

// szukamy poprzedniego wystapienia tego koloru
// jesli kolorem jest 1 lub 4 to sprawdzamy niezaleznie od trybu GFXMODE
 if c in [1,4] then begin
 
  for y:=i downto 0 do
   if check_bmp[y].col[c] then Break;

 end else begin
                        
  ok:=false;
  for y:=i downto 0 do
   if (check_bmp[y].col[c]) and (gfxMode[y shr 3]=g) then begin ok:=true; Break end;

//  if not(ok) then exit;

 end;

 inc(y);

 lin:=y;


 form1.ZapiszUndo; SaveAfterExit:=true;


// teraz w znalezionym przedziale znajdujemy najmniejsza liczbe zmian w linii
 min:=$ff;
 for x:=y to i do
  if changes[x]<min then begin min:=changes[x]; lin:=x end;

 inc(changes[lin]);

 fillchar(TabKolor[c shl 8+lin],abs(i-lin)+1,old);

 form1.set_pf_colors;
end;


procedure TFCheck.Repair2Click(Sender: TObject);
// OPTIMIZE BMP
var i, x: integer;
    col: array [0..5] of Boolean;
    nam: string [16];
    k: word;
begin
 i:=ListView1.ItemIndex;

 fillchar(col,sizeof(col),false);

// jakie kolory sa zmieniane w aktualnej linii
 for x:=0 to High(check_list)-1 do
  if (check_list[x].lin=i) then begin
   nam:=check_list[x].nam;

   k:=sprawdz_etykiete(nam);

   if byte(k shr 8)=$ff then col[ byte(k and $ff) ]:=true;
  end;

 if col[1] then optimize_bmp(i,1);
 if col[2] then optimize_bmp(i,2);
 if col[3] then optimize_bmp(i,3);
 if col[4] then optimize_bmp(i,4);

 SaveAfterExit:=true;

 FEditPMG.check_refresh;
end;


end.
