unit LoadPMGfile;

interface

uses
  Windows, SysUtils, Graphics, Controls, Forms, StdCtrls, Classes, ExtCtrls;

type
  TFLoadPMGfile = class(TForm)
    CheckBox1: TCheckBox;
    Panel1: TPanel;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLoadPMGfile: TFLoadPMGfile;

  lpmg_checkbox: array [0..7] of TCheckBox;

implementation

uses Main;

{$R *.dfm}

procedure TFLoadPMGfile.CheckBox1Click(Sender: TObject);
var i: integer;
begin

 if CheckBox1.Checked then begin

  for i:=0 to ComponentCount-1 do
   if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=true;

  CheckBox1.Checked:=true;
   
 end;

end;


procedure TFLoadPMGfile.CheckBox10Click(Sender: TObject);
begin
 CheckBox1.Checked:=false;
end;


procedure TFLoadPMGfile.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#27 then ModalResult:=mrCancel;
end;


procedure TFLoadPMGfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FLoadPMGfile', top, left);
end;


procedure TFLoadPMGfile.FormCreate(Sender: TObject);
var i, j: integer;
begin

for j:=0 to 1 do
 for i:=0 to 3 do begin

  with TCheckBox.Create(self) do begin
   Width:=64;
   Height:=17;
   Left:=8+j*72;
   Top:=8+i*24;
   Enabled:=true;
   Parent:=Panel1;
   Visible:=True;
   Checked:=true;
   Tag:=i+10+j*4;
   Name:='CheckBox'+IntToStr(Tag);
   OnClick:=CheckBox10Click;

   if j=0 then
    Caption:='Player '+IntToStr(i)
   else
    Caption:='Missile '+IntToStr(i);

  end;

 end;

 for i:=0 to ComponentCount-1 do
  if Components[i] is TCheckBox then
   if TCheckBox(Components[i]).Tag >=10 then
    lpmg_checkbox[TCheckBox(Components[i]).Tag-10]:=TCheckBox(Components[i]);

end;


end.
