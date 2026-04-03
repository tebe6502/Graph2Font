unit AddSkip;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, StdCtrls, BMDSpinEdit, ExtCtrls;

type
  TframeAddSkip = class(TFrame)
    seAdd: TBMDSpinEdit;
    seSkip: TBMDSpinEdit;
    procedure seAddContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TframeAddSkip.seAddContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;

end.
