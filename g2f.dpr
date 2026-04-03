program g2f;
{$R 'cursor\kursor1.res' 'cursor\kursor1.rc'}
{$R 'cursor\plik_asm.res' 'cursor\plik_asm.rc'}

uses
  Forms,
  Windows,
  Main in 'Main.pas' {Form1},
  Zoom in 'Zoom.pas' {FZoom},
  SelectColor in 'SelectColor.pas' {FSelectColor},
  EditColors in 'EditColors.pas' {FEditColors},
  MoveCopyPaste in 'MoveCopyPaste.pas' {FMove},
  EditPMG in 'EditPMG.pas' {FEditPMG},
  CharsFill in 'CharsFill.pas' {FCharsFill},
  EditCharset in 'EditCharset.pas' {FEditCharset},
  Check in 'Check.pas' {FCheck},
  EditRasters in 'EditRasters.pas' {FEditRasters},
  ExportAs in 'ExportAs.pas' {FExportAs},
  SelectFolder in 'SelectFolder.pas' {FSelectFolder},
  About in 'About.pas' {FAbout},
  PaletteOptions in 'PaletteOptions.pas' {FPaletteOptions},
  Bmp2Pmg in 'Bmp2Pmg.pas' {FBmp2Pmg},
  EditPalette in 'EditPalette.pas' {FEditPalette},
  EditColorsMap in 'EditColorsMap.pas' {FEditColorsMap},
  LoadScreens in 'LoadScreens.pas' {FLoadScreens},
  Special in 'Special.pas' {FSpecial},
  EditBMP in 'EditBMP.pas' {FEditBMP},
  ImportBMP in 'ImportBMP.pas' {FImportBMP},
  LineRange in 'LineRange.pas' {frameLineRange: TFrame},
  AddSkip in 'AddSkip.pas' {frameAddSkip: TFrame},
  AtariPalette in 'AtariPalette.pas' {frameAtariPalette: TFrame},
  UnitButtonMenu in 'dropdownbutton\UnitButtonMenu.pas' {ButtonMenu: TFrame};

{$R *.RES}

begin

  CreateMutex(nil, FALSE, 'G2FRUNING');

  if ParamCount>0 then
   if GetLastError() <> 0 then Halt;

  Application.Initialize;
  Application.Title := 'Graph2Font';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFMove, FMove);
  Application.CreateForm(TFSelectFolder, FSelectFolder);
  Application.CreateForm(TFExportAs, FExportAs);
  Application.CreateForm(TFEditRasters, FEditRasters);
  Application.CreateForm(TFCheck, FCheck);
  Application.CreateForm(TFEditCharset, FEditCharset);
  Application.CreateForm(TFCharsFill, FCharsFill);
  Application.CreateForm(TFEditPMG, FEditPMG);
  Application.CreateForm(TFEditColors, FEditColors);
  Application.CreateForm(TFSelectColor, FSelectColor);
  Application.CreateForm(TFZoom, FZoom);
  Application.CreateForm(TFAbout, FAbout);
  Application.CreateForm(TFPaletteOptions, FPaletteOptions);
  Application.CreateForm(TFBmp2Pmg, FBmp2Pmg);
  Application.CreateForm(TFEditPalette, FEditPalette);
  Application.CreateForm(TFEditColorsMap, FEditColorsMap);
  Application.CreateForm(TFLoadScreens, FLoadScreens);
  Application.CreateForm(TFSpecial, FSpecial);
  Application.CreateForm(TFImportBMP, FImportBMP);
  Application.CreateForm(TFEditBMP, FEditBMP);
  Application.Run;

end.

