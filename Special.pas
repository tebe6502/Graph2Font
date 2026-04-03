unit Special;

{

TreeView with check boxes and radio buttons.

http://delphi.about.com/library/weekly/aa092104a.htm

Here's how to add check boxes and radio buttons to a
TTreeView Delphi component. Give your applications a
more professional and smoother look.

..............................................
Zarko Gajic, BSCS
About Guide to Delphi Programming
http://delphi.about.com
how to advertise: http://delphi.about.com/library/bladvertise.htm
free newsletter: http://delphi.about.com/library/blnewsletter.htm
forum: http://forums.about.com/ab-delphi/start/
..............................................

}


interface

uses
  Windows, Classes, Graphics, Controls, Forms, ComCtrls, StdCtrls, ImgList, ExtCtrls, BMDSpinEdit,
  CheckLst;

type
  TFSpecial = class(TForm)
    ImageList1: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TreeView1: TTreeView;
    TabSheet2: TTabSheet;
    gbCharset: TGroupBox;
    gbChars: TGroupBox;
    Image1: TImage;
    GroupBox4: TGroupBox;
    ged_a: TCheckBox;
    ged_x: TCheckBox;
    ged_y: TCheckBox;
    ChrOpty: TRadioGroup;
    seFirstChar: TBMDSpinEdit;
    seLastChar: TBMDSpinEdit;
    TabSheet3: TTabSheet;
    gbLoadPMG: TGroupBox;
    All: TCheckBox;
    PmgG2f: TRadioButton;
    PmgAtari: TRadioButton;
    gbAllData: TGroupBox;
    Colbak: TCheckBox;
    Missiles: TCheckBox;
    Charsets: TCheckBox;
    GroupBox1: TGroupBox;
    CheckListBox1: TCheckListBox;
    GroupBox2: TGroupBox;
    chk_players: TCheckBox;
    chk_missiles: TCheckBox;
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure seLastCharChange(Sender: TObject);
    procedure seFirstCharChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TabSheet2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AllClick(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure ged_aClick(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure seFirstCharContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);

 private
 { Private declarations }
 public
 { Public declarations }
 end;


const
//ImageList.StateIndex=0 has some bugs, so we add one dummy image to position 0
cFlatUnCheck = 1;
cFlatChecked = 2;
cFlatRadioUnCheck = 3;
cFlatRadioChecked = 4;

var
  FSpecial: TFSpecial;

  chl_select, chl_first: TPoint;
  chl_left: Boolean;

  lpmg_checkbox: array [0..7] of TCheckBox;
  sdat_checkbox: array [0..19] of TCheckBox;

implementation

uses Main;

{$R *.dfm}


procedure ToggleTreeViewCheckBoxes(const Node:TTreeNode; cUnChecked, cChecked, cRadioUnchecked, cRadioChecked:integer);
var
  tmp:TTreeNode;
begin
  if Assigned(Node) then
  begin
    if Node.StateIndex = cUnChecked then
      Node.StateIndex := cChecked
    else if Node.StateIndex = cChecked then
      Node.StateIndex := cUnChecked
    else if Node.StateIndex = cRadioUnChecked then
    begin
      tmp := Node.Parent;
      if not Assigned(tmp) then
        tmp := TTreeView(Node.TreeView).Items.getFirstNode
      else
        tmp := tmp.getFirstChild;
      while Assigned(tmp) do
      begin
        if (tmp.StateIndex in [cRadioUnChecked,cRadioChecked]) then
          tmp.StateIndex := cRadioUnChecked;
        tmp := tmp.getNextSibling;
      end;
      Node.StateIndex := cRadioChecked;
    end; // if StateIndex = cRadioUnChecked
  end; // if Assigned(Node)
end; (*ToggleTreeViewCheckBoxes*)


procedure TFSpecial.TreeView1Click(Sender: TObject);
var
  P:TPoint;
begin
  GetCursorPos(P);
  P := TreeView1.ScreenToClient(P);
  if (htOnStateIcon in TreeView1.GetHitTestInfoAt(P.X,P.Y)) then
    ToggleTreeViewCheckBoxes(
       TreeView1.Selected,
       cFlatUnCheck,
       cFlatChecked,
       cFlatRadioUnCheck,
       cFlatRadioChecked);
end;


procedure TFSpecial.TreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) and Assigned(TreeView1.Selected) then
    ToggleTreeViewCheckBoxes(TreeView1.Selected,cFlatUnCheck,cFlatChecked,cFlatRadioUnCheck,cFlatRadioChecked);
end; (*TreeView1KeyDown*)


procedure show_checkbox(const x,y,i: integer);
var b: Boolean;
const
 size=11;
begin

 b:=chlimit[i];

 with FSpecial.image1.Canvas do begin
  Pen.Width:=1;

  Pen.Width:=1;

  if i in [min_znakow..ile_znakow] then begin
   Pen.Color:=clMoneyGreen; Brush.Color:=clMoneyGreen;
  end else begin
   Pen.Color:=clWhite; Brush.Color:=clWhite;
  end;

  Rectangle(x-1,y-1,x+size+1,y+size+1);

  Pen.Color:=clGray;
  MoveTo(x-1,y+size-1); LineTo(x-1,y-1); LineTo(x+size,y-1);

  Pen.Color:=0;
  MoveTo(x,y+size-2); LineTo(x,y); LineTo(x+size-1,y);

  Pen.Color:=clBtnFace;
  MoveTo(x+size-1,y); LineTo(x+size-1,y+size-1); LineTo(x-1,y+size-1);

  if b then begin
   Pen.Color:=0; Brush.Color:=0;
   Pen.Width:=2;
   MoveTo(x+2,y+5); LineTo(x+5,y+8); LineTo(x+8,y+2);
  end;

 end;

end;


procedure show_chars_limit;
var i,x,w: integer;
    a: byte;
begin

 with FSpecial.image1.Canvas do begin
  Pen.Color:=clBtnFace;
  Brush.Color:=clBtnFace;
  Rectangle(0,0,FSpecial.image1.Width, FSpecial.image1.Height);
 end;

 
 with FSpecial.image1.Canvas do
  for i:=0 to 15 do
   for x:=0 to 7 do begin
    a:=AtariFnt[(48+i-32+7*(ord(i>9)))*8+x];

    for w:=0 to 7 do
     if (a and twyt1[w])>0 then Pixels[i*12+w+4+8,x]:=0;

   end;


 with FSpecial.image1.Canvas do
  for i:=0 to 7 do
   for x:=0 to 7 do begin
    a:=AtariFnt[(48+i-32)*8+x];

    for w:=0 to 7 do
     if (a and twyt1[w])>0 then Pixels[w,i*12+x+11]:=0;

   end;


 for x:=0 to 7 do
  for i:=0 to 15 do
   show_checkbox(i*12+10, x*12+10, i+x*16);

end;


procedure TFSpecial.TabSheet2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 show_chars_limit;

 chl_left:=false;
end;


procedure TFSpecial.AllClick(Sender: TObject);
var i: integer;
begin

 if All.Checked then begin

  for i:=0 to ComponentCount-1 do
   if Components[i] is TCheckBox then
   if TCheckBox(Components[i]).Tag in [10..19] then TCheckBox(Components[i]).Checked:=true;

  All.Checked:=true;
   
 end;

end;


procedure TFSpecial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FSpecial', top, left);
end;


procedure TFSpecial.CheckBox10Click(Sender: TObject);
begin
 All.Checked:=false;
end;


procedure TFSpecial.CheckListBox1Click(Sender: TObject);
var i: byte;
begin

 row_limit:=0;

 for i := 0 to 7 do
  if CheckListBox1.Checked[i] then row_limit:=row_limit or twyt1[i];

end;


procedure TFSpecial.FormCreate(Sender: TObject);
var i,j: integer;
    s: string;
begin

 TreeView1.FullExpand;

 show_chars_limit;


for j:=0 to 1 do
 for i:=0 to 3 do begin

  with TCheckBox.Create(self) do begin
   Width:=64;
   Height:=17;
   Left:=8+j*69;
   Top:=18+i*18;
   Enabled:=true;
   Parent:=gbLoadPMG;
   Visible:=True;
   Checked:=true;
   Tag:=i+10+j*4;

//   str(Tag, s);
//   Name:='CheckBox'+s;
   OnClick:=CheckBox10Click;

   str(i, s);

   if j=0 then
    Caption:='Player '
   else
    Caption:='Missile ';

   Caption:=Caption+s;

  end;

 end;


for j:=0 to 4 do
 for i:=0 to 3 do begin

  with TCheckBox.Create(self) do begin
   Width:=64;
   Height:=17;

   if j>2 then
    Left:=8+j*69-3*69
   else
    Left:=8+j*69;

   if j>2 then begin

    Top:=18+i*18+4*18+8;

    if j=3 then Top:=Top+18;

   end else
    Top:=18+i*18;

   Enabled:=true;
   Parent:=gbAllData;
   Visible:=True;
   Checked:=true;
   Tag:=i+20+j*4;

//   str(Tag, s);
//   Name:='CheckBox'+s;

   str(i, s);

   case j of
    0: Caption:='HPosP ';
    1: Caption:='HPosM ';
    2: Caption:='ColPM ';
    3: Caption:='Player ';
    4: Caption:='ColPf ';
   end;

   Caption:=Caption+s;

  end;

 end;

 for i:=0 to ComponentCount-1 do
  if Components[i] is TCheckBox then
   if TCheckBox(Components[i]).Tag in [10..19] then lpmg_checkbox[TCheckBox(Components[i]).Tag-10]:=TCheckBox(Components[i]) else
    if TCheckBox(Components[i]).Tag >=20 then sdat_checkbox[TCheckBox(Components[i]).Tag-20]:=TCheckBox(Components[i]);

 All.Left:=8+69*2; All.Top:=18;

 PmgG2f.Left:=All.Left;
 PmgAtari.Left:=All.Left;

 PmgG2f.Top:=18*3;
 PmgAtari.Top:=18*4;

 Charsets.Left:=8+2*69; Charsets.Top:=18+4*18+8;
 
 Colbak.Left:=8+1*69; Colbak.Top:=18+4*18+4*18+8;
 Missiles.Left:=8; Missiles.Top:=18+4*18+{4*18+}8;

 ged_a.Left:=8; ged_x.Left:=8+69; ged_y.Left:=8+69*2;
end;


procedure TFSpecial.FormKeyPress(Sender: TObject; var Key: Char);
begin

 if Key=#27 then begin

  ModalResult:=mrCancel;

  seFirstCharChange(self);
  seLastCharChange(self);
 end;

end;


procedure TFSpecial.FormShow(Sender: TObject);
begin
 seFirstChar.Position:=min_znakow;
 seLastChar.Position:=ile_znakow;

 seFirstChar.MaxValue:=ile_znakow-Bajt;
 seLastChar.MinValue:=Bajt;

 seLastCharChange(self);

 show_chars_limit;
end;


procedure TFSpecial.ged_aClick(Sender: TObject);
begin

 if not(ged_x.Checked) and not(ged_y.Checked) then ged_a.Checked:=true;

end;


procedure select_chars(const a: Boolean);
var i, j, tmp: integer;
    k: byte;
    f,l: TPoint;
    hits: array [0..127] of Boolean;
begin

 f:=chl_first;
 l:=chl_select;

 if f.x>l.x then begin
  tmp:=f.x;
  f.x:=l.x;
  l.x:=tmp;
 end;

 if f.y>l.y then begin
  tmp:=f.y;
  f.y:=l.y;
  l.y:=tmp;
 end;


 fillchar(hits, sizeof(hits), false);

  for j:=f.y-10 to l.y-10 do
   for i:=f.x-10 to l.x-10 do
    if (i div 12 in [0..15]) and (j div 12 in [0..7]) then begin

     k:=i div 12+(j div 12)*16;

     if not(hits[k]) then chlimit[k]:=not(chlimit[k]);
     hits[k]:=true;

    end;

end;


procedure DrawMarquee(const mStart, mStop: TPoint; const AMode: TPenMode);
begin
 FSpecial.image1.Canvas.Pen.Mode := AMode;
 FSpecial.image1.Canvas.Rectangle( mStart.X, mStart.Y, mStop.X, mStop.Y );
end;


procedure TFSpecial.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 if (x<11) or (y<11) then exit;

 if Button=mbLeft then chl_left:=true;

 chl_first:=Point(x,y);

end;


procedure TFSpecial.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

 if (x<11) or (y<11) then exit;

 if chl_left then begin

   DrawMarquee(chl_first, chl_select, pmNotXor );
   DrawMarquee(chl_first, Point( X, Y ), pmNotXor );
   FSpecial.Image1.Canvas.Pen.Mode := pmCopy;

 end;

 chl_select:=Point(x,y);

end;


procedure TFSpecial.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 if chl_left then begin
  chl_left:=false;

  select_chars(true);
 end;

 show_chars_limit;

end;


procedure TFSpecial.seFirstCharChange(Sender: TObject);
begin
 if not(seFirstChar.Position in [0..127]) then seFirstChar.Position:=0;

 min_znakow:=seFirstChar.Position;

 show_chars_limit;
end;


procedure TFSpecial.seFirstCharContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;

procedure TFSpecial.seLastCharChange(Sender: TObject);
begin
 if not(seLastChar.Position in [0..127]) then seLastChar.Position:=127;

 ile_znakow:=seLastChar.Position;

 seFirstChar.MaxValue:=ile_znakow;//-Bajt;

 show_chars_limit;

end;


end.
