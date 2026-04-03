unit LoadScreens;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, StdCtrls, FileCtrl, ComCtrls,
  Menus, SysUtils;

type
  TFLoadScreens = class(TForm)
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Addall1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    N1: TMenuItem;
    Moveatfirstposition1: TMenuItem;
    Moveatlastposition1: TMenuItem;
    N2: TMenuItem;
    Removefromlist1: TMenuItem;
    Clearalllist1: TMenuItem;
    N3: TMenuItem;
    ListView1: TListView;
    Button1: TButton;
    FilterComboBox1: TFilterComboBox;
    procedure FormCreate(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FileListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Add1Click(Sender: TObject);
    procedure Addall1Click(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Clearalllist1Click(Sender: TObject);
    procedure Removefromlist1Click(Sender: TObject);
    procedure Moveatlastposition1Click(Sender: TObject);
    procedure Moveatfirstposition1Click(Sender: TObject);
    procedure Moveup1Click(Sender: TObject);
    procedure Movedown1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLoadScreens: TFLoadScreens;

  batch_file: array of string;


implementation

uses Main, ExportAs;

{$R *.dfm}


procedure show_batch_files;
var ListItem: TListItem;
    i: integer;
begin

 FLoadScreens.ListView1.Clear;

 for i:=0 to High(batch_file)-1 do begin

  ListItem := FLoadScreens.ListView1.Items.Add;
  ListItem.Caption := batch_file[i];
 end;

end;


procedure TFLoadScreens.DirectoryListBox1Change(Sender: TObject);
begin
 FileListBox1.Directory:=DirectoryListBox1.Directory;
end;


procedure TFLoadScreens.FileListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

 if FileListBox1.ItemIndex>=0 then
  if Button=mbRight then PopupMenu1.Popup(x+FLoadScreens.left+FLoadScreens.FileListBox1.Left,y+FLoadScreens.top+FLoadScreens.FileListBox1.Top+32);

end;


procedure TFLoadScreens.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FLoadScreens', top, left);

 SetLength(batch_file, 1);
end;


procedure TFLoadScreens.FormCreate(Sender: TObject);
begin
 doublebuffered:=true;
 SetLength(batch_file, 1);
end;

procedure TFLoadScreens.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then ModalResult:=mrCancel;
end;


procedure TFLoadScreens.FormShow(Sender: TObject);
begin
 show_batch_files;
end;


procedure TFLoadScreens.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if ListView1.ItemIndex>=0 then
  if Button=mbRight then PopupMenu2.Popup(x+FLoadScreens.Left+FLoadScreens.ListView1.Left,y+FLoadScreens.Top+32)
end;


procedure add_batch(const a: string);
var i: integer;
begin
  i:=High(batch_file);
  batch_file[i]:=a;

  SetLength(batch_file, i+2);
end;


procedure TFLoadScreens.Add1Click(Sender: TObject);
// ADD
var i: integer;
begin

 for i:=0 to FileListBox1.Count-1 do
  if FileListBox1.Selected[i] then add_batch(FileListBox1.Directory +'\'+ FileListBox1.Items.Strings[i]);

 show_batch_files;
end;


procedure TFLoadScreens.Addall1Click(Sender: TObject);
// ADD ALL
var j: integer;
begin

 for j:=0 to FileListBox1.Count-1 do add_batch(FileListBox1.Directory +'\'+ FileListBox1.Items[j]);

 show_batch_files;
end;


procedure TFLoadScreens.Button1Click(Sender: TObject);
// LOAD FROM LIST
var txt, zm: string;
    i, j, min, max: integer;
begin
 form1.SaveChanges;

 if not(FExportAs.ashscroll1.Checked) then begin
  min:=punkt.y;
  max:=trunc(FExportAs.seHeight.Value)-1;
 end else begin
  min:=punkt.x;
  max:=trunc(FExportAs.seWidth.Value)-1;
 end;

 j:=0;

 for i:=min to max do begin
  zm:=batch_file[j];

  form1.SaveDialog1.FileName:=ExtractFileName(zm);

  if FileExists(zm) then begin
   form1.ClearAll;
   txt:=current_filename;
   current_filename:=zm;
   form1.PreviewButton;
   current_filename:=txt;
  end;

  FExportAs.StringGrid1.Cells[punkt.x,punkt.y]:='*';

  FExportAs.insert_screen;

  if not(FExportAs.ashscroll1.Checked) then
   inc(punkt.y)
  else
   inc(punkt.x);

  inc(j);
  if j>=High(batch_file) then Break;
 end;

 FLoadScreens.SetFocus;
end;


procedure TFLoadScreens.Moveatfirstposition1Click(Sender: TObject);
// MOVE AT FIRST POSITION
var i: integer;
    a: string;
begin

 a:=batch_file[ListView1.ItemIndex];

 for i:=ListView1.ItemIndex+1 to High(batch_file)-1 do
  batch_file[i-1]:=batch_file[i];
 
 for i:=High(batch_file)-1 downto 1 do
  batch_file[i]:=batch_file[i-1];

 batch_file[0]:=a;

 show_batch_files;
end;


procedure TFLoadScreens.Moveatlastposition1Click(Sender: TObject);
// MOVE AT LAST POSITION
var i, k: integer;
    a: string;
begin

 a:=batch_file[ListView1.ItemIndex];

 k:=ListView1.ItemIndex+1;

 for i:=k to High(batch_file)-1 do batch_file[i-1]:=batch_file[i];

 batch_file[i-1]:=a;

 show_batch_files;
end;


procedure TFLoadScreens.Movedown1Click(Sender: TObject);
// MOVE DOWN
var i: integer;
    a, b: string;
begin

 i:=ListView1.ItemIndex;

 if i<High(batch_file)-1 then begin

  a:=batch_file[i];
  b:=batch_file[i+1];

  batch_file[i+1]:=a;
  batch_file[i]:=b;
 end;

 show_batch_files;
end;


procedure TFLoadScreens.Moveup1Click(Sender: TObject);
// MOVE UP
var i: integer;
    a, b: string;
begin

 i:=ListView1.ItemIndex;

 if i>0 then begin

  a:=batch_file[i];
  b:=batch_file[i-1];

  batch_file[i-1]:=a;
  batch_file[i]:=b;
 end;

 show_batch_files;
end;


procedure TFLoadScreens.Removefromlist1Click(Sender: TObject);
// REMOVE FROM LIST
var i: integer;
begin

 for i:=ListView1.ItemIndex+1 to High(batch_file)-1 do
  batch_file[i-1]:=batch_file[i];

 SetLength(batch_file, High(batch_file));

 show_batch_files;
end;


procedure TFLoadScreens.Clearalllist1Click(Sender: TObject);
// CLEAR ALL
begin
 SetLength(batch_file, 1);

 show_batch_files;
end;


end.
