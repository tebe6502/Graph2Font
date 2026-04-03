unit SelectValue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls;

type
  TFSelectValue = class(TForm)
    TrackBar1: TTrackBar;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
//    procedure CmMouseEnter(var Msg : TMessage); message CM_MOUSEENTER;
    procedure CmMouseLeave(var Msg : TMessage); message CM_MOUSELEAVE;
  public
    { Public declarations }
  end;

var
  FSelectValue: TFSelectValue;

implementation

uses Main;

{$R *.dfm}


//procedure TFSelectValue.CMMouseEnter(var Msg : TMessage);
//begin
//
//end;

procedure TFSelectValue.CmMouseLeave(var Msg : TMessage);
begin
 form1.Zamknij(f_SelectValue);
end;


procedure TFSelectValue.FormShow(Sender: TObject);
var i: integer;
begin

 with image1.Canvas do begin
  Pen.Color:=0; Brush.Color:=0;
  Rectangle(0,0,image1.Width, image1.Height);
 end;

 for i := 0 to 255 do
  with image1.Canvas do begin
   Pen.Color:=AtariPal[i]; Brush.Color:=AtariPal[i];
   MoveTo(0,i); LineTo(image1.Width, i);
  end;

end;


end.
