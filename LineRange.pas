unit LineRange;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, StdCtrls, ComCtrls, BMDSpinEdit, ExtCtrls,
  Vcl.Mask;

type
  TframeLineRange = class(TFrame)
    Panel1: TPanel;
    bGet: TButton;
    seLine: TBMDSpinEdit;
    seRange: TBMDSpinEdit;

    procedure seLineChange(Sender: TObject);
    procedure seLineContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    
  private
    { Private declarations }

    procedure FUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);
    
  public

    constructor Create(AOwner: TComponent) ; override;
    { Public declarations }
  end;

implementation

uses Main;

{$R *.dfm}


constructor TframeLineRange.Create(AOwner: TComponent) ;
begin

 inherited Create(AOwner) ;

 seLine.FUpDown.OnChangingEx := FUpDownChangingEx;

end;


procedure TframeLineRange.FUpDownChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);
var i,j,k: integer;
    ok: Boolean;
begin

 i:=seLine.Position shr 3;
 j:=seLine.Position mod 8;

 k:=0;

 case Direction of
  updDown: begin                               // down

            ok:=false;

            for k := j+1 to 7 do
             if row_limit and twyt1[k]<>0 then begin ok:=true; Break end;

            if not(ok) then begin
             inc(i);

             for k := 0 to 7 do
              if row_limit and twyt1[k]<>0 then Break;

            end;

            AllowChange:=false;

           end;

    updUp: begin                                // up

            ok:=false;

            for k := j-1 downto 0 do
             if row_limit and twyt1[k]<>0 then begin ok:=true; Break end;

            if not(ok) then begin
             dec(i);

             for k := 7 downto 0 do
              if row_limit and twyt1[k]<>0 then Break;

            end;

            AllowChange:=false;

           end;

//  updNone: seLine.EditLabel.Caption:='';
 end;

 seLine.Position := i shl 3 + k;

end;


procedure TframeLineRange.seLineChange(Sender: TObject);
begin

 if seLine.Position mod 8=0 then
  seLine.Color:=clMoneyGreen
 else
  seLine.Color:=clWindow;

 if Fox1 and (seLine.Position and 7=4) then seLine.Color:=clMoneyGreen;

 seLine.Hint:=form1.Hex(seLine.Position,2);

end;

procedure TframeLineRange.seLineContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;

end.
