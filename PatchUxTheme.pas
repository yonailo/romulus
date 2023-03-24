unit PatchUxTheme;

interface


procedure EnableThemesApp;
procedure DisableThemesApp;


implementation

uses
Controls,
Forms,
Messages,
UxTheme,
Sysutils,
Windows;

type
  TJumpOfs = Integer;
  PPointer = ^Pointer;

  PXRedirCode = ^TXRedirCode;
  TXRedirCode = packed record
    Jump: Byte;
    Offset: TJumpOfs;
  end;

  PAbsoluteIndirectJmp = ^TAbsoluteIndirectJmp;
  TAbsoluteIndirectJmp = packed record
    OpCode: Word;
    Addr: PPointer;
  end;

var
 UseThemesBackup: TXRedirCode;

function GetActualAddr(Proc: Pointer): Pointer;
begin
  if Proc <> nil then
  begin
    if (Win32Platform = VER_PLATFORM_WIN32_NT) and (PAbsoluteIndirectJmp(Proc).OpCode = $25FF) then
      Result := PAbsoluteIndirectJmp(Proc).Addr^
    else
      Result := Proc;
  end
  else
    Result := nil;
end;


procedure HookProc(Proc, Dest: Pointer; var BackupCode: TXRedirCode);
var
  n: DWORD;
  Code: TXRedirCode;
begin
  Proc := GetActualAddr(Proc);
  Assert(Proc <> nil);
  if ReadProcessMemory(GetCurrentProcess, Proc, @BackupCode, SizeOf(BackupCode), n) then
  begin
    Code.Jump := $E9;
    Code.Offset := PAnsiChar(Dest) - PAnsiChar(Proc) - SizeOf(Code);
    WriteProcessMemory(GetCurrentProcess, Proc, @Code, SizeOf(Code), n);
  end;
end;

procedure UnhookProc(Proc: Pointer; var BackupCode: TXRedirCode);
var
  n: Cardinal;
begin
  if (BackupCode.Jump <> 0) and (Proc <> nil) then
  begin
    Proc := GetActualAddr(Proc);
    Assert(Proc <> nil);
    WriteProcessMemory(GetCurrentProcess, Proc, @BackupCode, SizeOf(BackupCode), n);
    BackupCode.Jump := 0;
  end;
end;

function UseThemesH:Boolean;
Var
 Flag : DWORD;
begin
  Flag:=GetThemeAppProperties;
  if ( (@IsAppThemed<>nil) and (@IsThemeActive<>nil) ) then
    Result := IsAppThemed and IsThemeActive and ((Flag and STAP_ALLOW_CONTROLS)<>0)
  else
    Result := False;
end;

procedure HookUseThemes;
begin
  HookProc(@UxTheme.UseThemes, @UseThemesH, UseThemesBackup);
end;

procedure UnHookUseThemes;
begin
  UnhookProc(@UxTheme.UseThemes, UseThemesBackup);
end;


Procedure DisableThemesApp;
begin
  SetThemeAppProperties(0);
  SendMessage(Application.Handle,WM_THEMECHANGED,0,0);
  SendMessage(Application.MainForm.Handle,CM_RECREATEWND,0,0);
end;

Procedure EnableThemesApp;
begin
  SetThemeAppProperties(STAP_ALLOW_NONCLIENT or STAP_ALLOW_CONTROLS or STAP_ALLOW_WEBCONTENT);
  SendMessage(Application.Handle,WM_THEMECHANGED,0,0);
  SendMessage(Application.MainForm.Handle,CM_RECREATEWND,0,0);
end;

initialization
 HookUseThemes;
finalization
 UnHookUseThemes;
end.