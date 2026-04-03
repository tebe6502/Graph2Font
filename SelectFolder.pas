unit SelectFolder;

interface

uses
  Windows, SysUtils, Controls, Forms, Classes, ComCtrls, StdCtrls, FileCtrl;

type
  TFSelectFolder = class(TForm)
    Button1: TButton;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DriveComboBox1Change(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSelectFolder: TFSelectFolder;

implementation

uses Main, ExportAs;

{$R *.dfm}

procedure TFSelectFolder.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then ModalResult:=mrCancel;
end;


procedure TFSelectFolder.DirectoryListBox1Change(Sender: TObject);
begin
 mapa_path:=DirectoryListBox1.Directory;

 mapa_plik:=ExtractFileName(mapa_path);
 pomoc_mapa := mapa_plik;
 if not(mapa_path[length(mapa_path)]in ['\','/']) then mapa_plik:='\'+mapa_plik;

 FExportAs.Caption:='Edit Maps ('+mapa_path+')';

 FSelectFolder.Caption:='Select Folder ('+mapa_path+')';

 form1.OpenDialog1.FileName:=mapa_path;
end;


procedure TFSelectFolder.DriveComboBox1Change(Sender: TObject);
begin
 DirectoryListBox1.Drive:=DriveComboBox1.Drive;
end;


end.
