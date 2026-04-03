unit Unit1;

{

Implement a Button with a Drop Down Menu in Delphi

http://delphi.about.com/od/vclusing/a/dropdown_button.htm 

A "Button with a Drop Down Context Menu" appears as a normal button
with an additional down arrow on the right side of the button.
You will usually find such buttons on toolbars. The "arrow button"
displays a drop down (popup) menu. Here's how to implement
such user interface in Delphi.

}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitButtonMenu, Menus;

type
  TForm1 = class(TForm)
    ButtonMenu1: TButtonMenu;
    PopupMenu1: TPopupMenu;
    CloseSaveItem: TMenuItem;
    CloseItem: TMenuItem;
    procedure ButtonMenu1MenuButtonClick(Sender: TObject);
    procedure CloseItemClick(Sender: TObject);
    procedure CloseSaveItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ButtonMenu1MenuButtonClick(Sender: TObject);
begin
  //added by Delphi - display the popup menu
  ButtonMenu1.MenuButtonClick(Sender);

end;

procedure TForm1.CloseItemClick(Sender: TObject);
begin
  ShowMessage('This should will close the program...');
end;

procedure TForm1.CloseSaveItemClick(Sender: TObject);
begin
  ShowMessage('Save all user information and close program ...');
end;

end.
