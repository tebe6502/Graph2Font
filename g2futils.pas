unit g2futils;

interface

uses Windows, Classes, Forms, Controls, SysUtils;

function GetTempName: string;

function GetFileBuild(FileName: string): string;
function GetFileInfoString(FileName: string; KeyName: string): string;
function GetFileVersion(FileName: string): string;
function GetProductVersion(FileName: string): string;
function ExtractFileVersion(Version: string; var Major, Minor, BuildMajor, BuildMinor: Integer): Boolean;
function FileAgeDateString(FileName: string): string;

implementation

function GetTempName: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
 GetTempPath(MAX_PATH - 1, Buffer);
 GetTempFileName(Buffer, '~', 0, Buffer);
 Result:= Buffer;
end;

function GetFileBuild(FileName: string): string;
var
  P: Integer;
begin
  Result := GetFileVersion(FileName);
  repeat
    P := Pos('.', Result);
    if P > 0 then Delete(Result, 1, P);
  until
    P = 0;
end;

type
  PVerTranslation = ^TVerTranslation;
  TVerTranslation = packed record
    LangID, CharSet: Word;
  end;

function GetFileInfoLang(Data: Pointer; var LangId, Charset: Word): Boolean;
var
  pTransArray: PVerTranslation;
  pTrans: PVerTranslation;
  Len: UINT;

  function FindTrans(ALangID: Word): PVerTranslation;
  var
    I: Integer;
  begin
    Result := pTransArray;
    for I := 0 to Len - 1 do
    begin
      if Result^.LangID = ALangID then Exit;
      Inc(Result);
    end;
    Result := nil;
  end;
begin
  Result := False;
  if Data <> nil then
  begin
    Result := True;
    LangID := 0;
    CharSet := 0;
    if not VerQueryValue(Data, '\VarFileInfo\Translation',
      Pointer(pTransArray), Len) then Exit;
    Len := Len div SizeOf(TVerTranslation);
    if not (Len > 0) then Exit;
    // Zgodne z ustawieniami Windows:
    pTrans := FindTrans(LoWord(SysLocale.DefaultLCID));
    if pTrans = nil then pTrans := pTransArray;
    if pTrans <> nil then
    begin
      LangID := pTrans^.LangID;
      CharSet := pTrans^.CharSet;
    end;
  end;
end;

function GetFileInfoStringData(Data: Pointer; KeyName: string; var KeyValue: string): Boolean;
var
  FLangID, FCharSet: Word;
  pKeyValue: Pointer;
  Len: UINT;
begin
  Result := False;
  if Data <> nil then
  begin
    if GetFileInfoLang(Data, FLangID, FCharSet) then
    begin
      Result := VerQueryValue(Data, PChar(
          Format('\StringFileInfo\%.4x%.4x\%s', [FLangID, FCharSet, KeyName])),
        pKeyValue, Len);
      if Result and (Len > 0) then
      begin
        SetString(KeyValue, PChar(pKeyValue), Len - 1);
        KeyValue := Trim(KeyValue);
      end
      else
        KeyValue := '';
    end;
  end;
end;

function GetFileInfoString(FileName: string; KeyName: string): string;
var
  FN: string;
  InfoSize: DWORD;
  NullVar: DWORD;
  Buffer: Pointer;
  FileInfo: PVSFixedFileInfo;
  Size: DWORD;
  StrVer: string;
begin
  Result := '';
  FN := FileName;
  InfoSize := GetFileVersionInfoSize(PChar(FN), NullVar);
  if InfoSize <> 0 then
  begin
    GetMem(Buffer, InfoSize);
    try
      if GetFileVersionInfo(PChar(FN), 0, InfoSize, Buffer) then
      begin
        if GetFileInfoStringData(Buffer, KeyName, StrVer) then
          Result := StrVer;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function GetFileVersion(FileName: string): string;
var
  FN: string;
  InfoSize: DWORD;
  NullVar: DWORD;
  Buffer: Pointer;
  FileInfo: PVSFixedFileInfo;
  Size: DWORD;
  StrVer: string;
begin
  Result := '';
  FN := FileName;
  InfoSize := GetFileVersionInfoSize(PChar(FN), NullVar);
  if InfoSize <> 0 then
  begin
    GetMem(Buffer, InfoSize);
    try
      if GetFileVersionInfo(PChar(FN), 0, InfoSize, Buffer) then
      begin
        if VerQueryValue(Buffer, '\', Pointer(FileInfo), Size) then
        begin
          Result := IntToStr(FileInfo.dwFileVersionMS shr 16) + '.' +
            IntToStr(FileInfo.dwFileVersionMS and $0000FFFF) + '.' +
            IntToStr(FileInfo.dwFileVersionLS shr 16) + '.' +
            IntToStr(FileInfo.dwFileVersionLS and $0000FFFF);
        end;
{
        if Result = '0.0.0.0' then
        begin
          if GetFileInfoStringData(Buffer, 'FileVersion', StrVer) then
            Result := StrVer;
        end;
}
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function GetProductVersion(FileName: string): string;
var
  FN: string;
  InfoSize: DWORD;
  NullVar: DWORD;
  Buffer: Pointer;
  FileInfo: PVSFixedFileInfo;
  Size: DWORD;
  StrVer: string;
begin
  Result := '';
  FN := FileName;
  InfoSize := GetFileVersionInfoSize(PChar(FN), NullVar);
  if InfoSize <> 0 then
  begin
    GetMem(Buffer, InfoSize);
    try
      if GetFileVersionInfo(PChar(FN), 0, InfoSize, Buffer) then
      begin
        if VerQueryValue(Buffer, '\', Pointer(FileInfo), Size) then
        begin
          Result := IntToStr(FileInfo.dwProductVersionMS shr 16) + '.' +
            IntToStr(FileInfo.dwProductVersionMS and $0000FFFF) + '.' +
            IntToStr(FileInfo.dwProductVersionLS shr 16) + '.' +
            IntToStr(FileInfo.dwProductVersionLS and $0000FFFF);
        end;
        if (Result = '') or (Result = '0.0.0.0') then
        begin
          if GetFileInfoStringData(Buffer, 'ProductVersion', StrVer) then
            Result := StrVer;
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function GetModuleFileName(Handle: THandle): string;
var
  P: PChar;
  Buffer: array[0..260] of Char;
begin
  Result := '';
  SetString(Result, Buffer, Windows.GetModuleFileName(Handle, Buffer, Length(Buffer)));
end;

function ExtractFileVersion(Version: string; var Major, Minor, BuildMajor, BuildMinor: Integer): Boolean;
var
  L: TStringList;
  I: Integer;
begin
  Result := False;
  Major := 0;
  Minor := 0;
  BuildMajor := 0;
  BuildMinor := 0;
  L := TStringList.Create;
  try
    L.Delimiter := '.';
    L.StrictDelimiter := True;
    L.DelimitedText := Version;
    for I := 0 to L.Count - 1 do
    begin
      case I of
        0: Major := StrToIntDef(L[I], 0);
        1: Minor := StrToIntDef(L[I], 0);
        2: BuildMajor := StrToIntDef(L[I], 0);
        3: BuildMinor := StrToIntDef(L[I], 0);
      end;
    end;
    Result := True;
  finally
    L.Free;
  end;

end;

function FileAgeDateString(FileName: string):string;
begin
 Result := FormatDateTime('yyyy-mm-dd hh:mm:ss',FileDateToDateTime(FileAge(FileName)));
end;


end.