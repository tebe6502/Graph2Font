unit CharsFill;

interface

uses
  Windows, Controls, Forms, StdCtrls, Classes;

type
  TFCharsFill = class(TForm)
    ScrollBox1: TScrollBox;
    Memo1: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Memo1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCharsFill: TFCharsFill;

implementation

uses Main;

{$R *.dfm}


procedure TFCharsFill.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  form1.NewFormPos('FCharsFill', top, left);
end;


procedure TFCharsFill.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(key)=27 then ModalResult:=mrCancel;
end;

procedure TFCharsFill.Memo1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;

end.
