unit unDPI;

interface

implementation

uses
  Winapi.Windows,
  Winapi.ShellScaling,
  System.SysUtils;


procedure SetDpiAwareness(value: DPI_AWARENESS_CONTEXT);
begin
  SetProcessDpiAwarenessContext(value);
  SetThreadDpiAwarenessContext(value);
end;

procedure InitDPI;
var
  LParam, LValue: string;
begin
  for var I := 1 to ParamCount do
  begin
    LParam := LowerCase(ParamStr(I));
    {/highdpi:unaware}
    if Pos('/highdpi:', LParam) = 1 then
    begin
      LValue := Copy(LParam, 10, Length(LParam));
      if LValue = 'unaware' then
        SetDpiAwareness(DPI_AWARENESS_CONTEXT_UNAWARE)
      else
      if LValue = 'system' then
        SetDpiAwareness(DPI_AWARENESS_CONTEXT_SYSTEM_AWARE)
      else
      if LValue = 'permonitor' then
        SetDpiAwareness(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE)
      else
      if LValue = 'permonitorv2' then
        SetDpiAwareness(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2)
      else
      if Pos('gdi', LValue) = 1 then
        SetDpiAwareness(DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED);
    end;
  end;
end;

initialization

InitDPI

end.
