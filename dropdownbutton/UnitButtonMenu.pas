unit UnitButtonMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Menus, Buttons;

type
  TButtonMenu = class(TFrame)
    MenuButton: TBitBtn;
    MainButton: TBitBtn;
    procedure MenuButtonClick(Sender: TObject);
    procedure FrameContextPopup(Sender: TObject; MousePos: TPoint;  var Handled: Boolean);
  private
    { Private declarations }
  public

  end;

implementation

{$R *.dfm}

procedure TButtonMenu.FrameContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean); 
begin
  //suppress the default context menu
  Handled := true;
end;


procedure TButtonMenu.MenuButtonClick(Sender: TObject);
var
  popupPoint : TPoint;
begin

  if Assigned(PopupMenu) then
  begin
    popupPoint.X := MenuButton.Left + (MenuButton.Width DIV 2);
    popupPoint.Y := MenuButton.Top + (MenuButton.Height DIV 2);
    popupPoint := ClientToScreen(popupPoint);

    //display the popup in the center of the "menu button"
    PopupMenu.Popup(popupPoint.X, popupPoint.Y);
  end;
  
end;

end.
