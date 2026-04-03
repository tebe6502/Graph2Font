unit EditColorsMap;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, ExtCtrls, StdCtrls, SysUtils, ComCtrls;

type
  TFEditColorsMap = class(TForm)
    RadioGroup1: TRadioGroup;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Edit3: TEdit;
    Edit4: TEdit;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Button1: TButton;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    Bevel2: TBevel;
    CheckBox2: TCheckBox;
    Bevel3: TBevel;
    Button2: TButton;
    Shape1: TShape;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioGroup1Click(Sender: TObject);
    procedure image4cmap_init;
    procedure Panel1Click(Sender: TObject);
    procedure show_cell_colors;
    procedure FillCellColors;
    procedure FormShow(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEditColorsMap: TFEditColorsMap;

  cmap_panel: array [1..3] of TPanel;
//  cmap_label: array [1..3] of TLabel;

implementation

uses Main, SelectColor;

{$R *.dfm}


procedure TFEditColorsMap.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FEditColorsMap',top,left);

 form1.EditColorsMap.Checked:=false;

 form1.Image4.Enabled:=true;
 form1.Image4.Visible:=false;

 form1.Timer3.Enabled:=false;

// bMarquee:=false;

 form1.Zamknij(f_SelectColor);

 form1.OdswiezObraz;
end;


procedure TFEditColorsMap.Button1Click(Sender: TObject);
// CHANGE BITMAP COLORS
var i, j, ofs: integer;
begin

 ofs:=CzarnyPas div cmap_cellW;

 for j := 0 to (Wysokosc div cmap_cellH)-1 do
  for i := 0 to (Szerokosc div cmap_cellW)-1 do
   if select_cmap[i+ofs,j] then begin
    cmap[i+ofs,j].c[0]:=select_cmap_cell_color[0];
    cmap[i+ofs,j].c[1]:=select_cmap_cell_color[1];
    cmap[i+ofs,j].c[2]:=select_cmap_cell_color[2];
    cmap[i+ofs,j].status:=
    ComboBox1.ItemIndex+
    ord(CheckBox1.Checked) shl 2+
    ord(CheckBox2.Checked) shl 3+
    ComboBox2.ItemIndex shl 4+
    ComboBox3.ItemIndex shl 6;
   end;

end;


procedure TFEditColorsMap.Button2Click(Sender: TObject);
begin

 select_cmap_cell_color[3]:= ComboBox1.ItemIndex+
  ord(CheckBox1.Checked) shl 2+
  ord(CheckBox2.Checked) shl 3+
  ComboBox2.ItemIndex shl 4+
  ComboBox3.ItemIndex shl 6;

 FEditColorsMap.FillCellColors;

 form1.OdswiezObraz;
end;


procedure TFEditColorsMap.FillCellColors;
var i, j, ofs: integer;
begin

 ofs:=CzarnyPas div cmap_cellW;

 for j := 0 to (Wysokosc div cmap_cellH)-1 do
  for i := 0 to (Szerokosc div cmap_cellW)-1 do
   if select_cmap[i+ofs,j] then begin
    cmap[i+ofs,j].c[0]:=select_cmap_cell_color[0];
    cmap[i+ofs,j].c[1]:=select_cmap_cell_color[1];
    cmap[i+ofs,j].c[2]:=select_cmap_cell_color[2];
    cmap[i+ofs,j].status:=select_cmap_cell_color[3];
   end;

end;


procedure TFEditColorsMap.show_cell_colors;
begin
 cmap_panel[1].Color:=AtariPal[select_cmap_cell_color[0]];
 cmap_panel[2].Color:=AtariPal[select_cmap_cell_color[1]];
 cmap_panel[3].Color:=AtariPal[select_cmap_cell_color[2]];

 cmap_panel[1].Hint:=form1.Hex(select_cmap_cell_color[0],2);
 cmap_panel[2].Hint:=form1.Hex(select_cmap_cell_color[1],2);
 cmap_panel[3].Hint:=form1.Hex(select_cmap_cell_color[2],2);

 ComboBox1.ItemIndex:=select_cmap_cell_color[3] and 3;
 CheckBox1.Checked:=select_cmap_cell_color[3] and 4>0;
 CheckBox2.Checked:=select_cmap_cell_color[3] and 8>0;
 ComboBox2.ItemIndex:=(select_cmap_cell_color[3] shr 4) and 3;
 ComboBox3.ItemIndex:=(select_cmap_cell_color[3] shr 6) and 3;
end;


procedure TFEditColorsMap.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var i, a: smallint;
begin
 i:=UpDown1.Position;

 a:=0;

 case i of
  0: a:=8;
  1: a:=16;
  2: a:=32;
 end;

 Edit3.Text:=IntToStr(a);
 cmap_cellW:=a;

 image4cmap_init;

 form1.OdswiezObraz;
end;


procedure TFEditColorsMap.UpDown2Click(Sender: TObject; Button: TUDBtnType);
var i, a: smallint;
begin
 i:=UpDown2.Position;

 a:=0;

 case i of
  0: a:=1;
  1: a:=2;
  2: a:=4;
  3: a:=8;
  4: a:=16;
  5: a:=32;
 end;

 Edit4.Text:=IntToStr(a);
 cmap_cellH:=a;

 image4cmap_init;

 form1.OdswiezObraz;
end;


procedure select_color;
begin

// cmap_label[1].Caption:='';
// cmap_label[2].Caption:='';
// cmap_label[3].Caption:='';

// cmap_label[select_cmap_color+1].Caption:='*';

 FEditColorsMap.Shape1.Top:=cmap_panel[select_cmap_color+1].Top-2;

end;


procedure TFEditColorsMap.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then form1.Zamknij(f_EditColorsMap);
end;


procedure TFEditColorsMap.FormShow(Sender: TObject);
var i: smallint;
begin

 i:=0;

 case cmap_cellW of
  8: i:=0;
  16: i:=1;
  32: i:=2;
 end;

 UpDown1.Position:=i;
 Edit3.Text:=IntToStr(cmap_cellW);

 case cmap_cellH of
  1: i:=0;
  2: i:=1;
  4: i:=2;
  8: i:=3;
  16: i:=4;
  32: i:=5;
 end;

 FEditColorsMap.UpDown2.Position:=i;
 Edit4.Text:=IntToStr(cmap_cellH);

 select_cmap_cell_color[0]:=cmap[CzarnyPas div cmap_cellW, 0].c[0];
 select_cmap_cell_color[1]:=cmap[CzarnyPas div cmap_cellW, 0].c[1];
 select_cmap_cell_color[2]:=cmap[CzarnyPas div cmap_cellW, 0].c[2];
 select_cmap_cell_color[3]:=cmap[CzarnyPas div cmap_cellW, 0].status;

 show_cell_colors;

 select_color;
end;


procedure TFEditColorsMap.image4cmap_init;
begin

 form1.ClrRectImage(form1.image4, transCol);

 fillchar(select_cmap, sizeof(select_cmap), false);
 
end;


procedure clic_color(const a: byte);
var ss: TShiftState;
    x, y: integer;
    t,l: integer;
begin
 select_cmap_color:=a;

 select_color;

 if form1.ShowColorsMap1.Checked then begin
  form1.ShowColorsMap1.Checked:=false;
  form1.ShowColorsMap1Execute(form1);

  exit;
 end;

 getCol:=true;
 x:=(select_cmap_cell_color[a] and $0f)*16;
 y:=(select_cmap_cell_color[a] div 16)*15;

 if not(FSelectColor.Visible) then begin

  form1.SetFormPos('FSelectColor', t, l);
  FSelectColor.Top:=t;
  FSelectColor.Left:=l;

 end;

 FSelectColor.Visible:=true;
 FSelectColor.Caption:='Select COLOR'+IntToStr(a);

 FSelectColor.Image1MouseMove(FEditColorsMap, ss, x,y);
end;


procedure TFEditColorsMap.PanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
begin
 select_cmap_color:=TForm(Sender).Tag-1;

 FEditColorsMap.Shape1.Top:=cmap_panel[select_cmap_color+1].Top-2;
end;


procedure TFEditColorsMap.Panel1Click(Sender: TObject);
begin
 clic_color(TForm(Sender).Tag-1);
end;


procedure TFEditColorsMap.RadioGroup1Click(Sender: TObject);
begin
 image4cmap_init;
end;


procedure TFEditColorsMap.FormCreate(Sender: TObject);
var i: integer;
begin

 for i:=0 to 2 do begin

 with TLabel.Create(self) do begin
  Caption:='C'+IntToStr(i);
  Font.Name:='Arial';
  Font.Style:=[fsBold];
  Font.Size:=9;
  Left:=46;
  Top:=84+i*40;
  Parent:=FEditColorsMap;
 end;
{
 with TLabel.Create(self) do begin
  Caption:='*';
  Font.Name:='Fixedsys';
  Left:=2;
  Top:=84+i*40;
  Parent:=FEditColorsMap;
  Tag:=i+1;
 end;
}
 with TPanel.Create(self) do begin
  Left:=14;
  Top:=80+i*40;
  Width:=25;
  Height:=25;
  Cursor:=crHandPoint;
  Color:=clBtnFace;
  BevelInner:=bvNone;
  BevelOuter:=bvNone;
  BevelKind:=bkFlat;
  BorderStyle:=bsNone;
  Parent:=FEditColorsMap;
  ParentBackground:=false;
  Tag:=i+1;
  OnClick:=Panel1Click;
  OnMouseDown:=PanelMouseDown;
 end;

 end;


 for i:=0 to ComponentCount-1 do begin

  if Components[i] is TPanel then
   if TPanel(Components[i]).Tag>0 then cmap_panel[TPanel(Components[i]).Tag]:=TPanel(Components[i]);

{  if Components[i] is TLabel then
   if TLabel(Components[i]).Tag>0 then cmap_label[TLabel(Components[i]).Tag]:=TLabel(Components[i]);
}
 end;

end;

end.
