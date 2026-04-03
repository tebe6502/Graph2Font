unit About;

interface

uses
  Windows, Classes, Graphics, Controls, Forms, StdCtrls, HTMLabel, ExtCtrls;

type
  TFAbout = class(TForm)
    Bevel1: TPanel;
    Image1: TImage;
    HTMLabel1: THTMLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RichEdit1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAbout: TFAbout;

  testlogo:integer;

const
   title_name  = 'Graph2Font ';//v4.1 (08.12.2024) Freeware';

implementation

uses Main, URLabel, g2futils;

{$R *.dfm}



procedure TFAbout.FormShow(Sender: TObject);
var a: string;
begin
 FAbout.Caption:=title_name + GetFileVersion(Application.ExeName) +' '+
// build '+GetFileBuild(Application.ExeName)+' '+
 '('+FileAgeDateString(Application.ExeName)+')'+
 ' Freeware';

 a:=form1.GetUndoName('$logo.bmp');
 form1.DepackRES('G2FLOGO', a);

 image1.Picture.LoadFromFile(a);

end;


procedure TFAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form1.NewFormPos('FAbout', top, left);
end;


procedure TFAbout.FormCreate(Sender: TObject);
begin

 with TURLabel.Create(Bevel1) do
 begin
    Caption := 'http://g2f.atari8.info';
    URL := 'http://g2f.atari8.info';
    Parent := Bevel1;
    Align := alTop;
    Font.Size:=10;
 end;

 with TURLabel.Create(Bevel1) do
 begin
    Caption := 'https://atariage.com/forums/topic/34916-graph2fnt/#comments';
    URL := 'https://atariage.com/forums/topic/34916-graph2fnt/#comments';
    Parent := Bevel1;
    Align := alTop;
    Font.Size:=10;
 end;

  with TURLabel.Create(Bevel1) do
 begin
    Caption := 'http://atarionline.pl/forum/comments.php?DiscussionID=3&page=1#Item_0';
    URL := 'http://atarionline.pl/forum/comments.php?DiscussionID=3&page=1#Item_0';
    Parent := Bevel1;
    Align := alTop;
    Font.Size:=10;
 end;

  with TURLabel.Create(Bevel1) do
 begin
    Caption := 'http://atariage.com/forums/topic/200118-images-generated-by-rastaconverter/page-1';
    URL := 'http://atariage.com/forums/topic/200118-images-generated-by-rastaconverter/page-1';
    Parent := Bevel1;
    Align := alTop;
    Font.Size:=10;
 end;

end;


procedure TFAbout.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#27 then ModalResult:=mrOK;
end;

procedure TFAbout.Image1Click(Sender: TObject);
begin
 ModalResult:=mrOK;
end;


procedure TFAbout.RichEdit1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
 Handled:=true;
end;

end.
