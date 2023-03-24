unit Progressbarwithtext;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TProgressBarWithText = class(TProgressBar)
  private
    FProgressText: string;
  protected
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  published
    property ProgressText: string read FProgressText write FProgressText;
  end;

procedure Register;

implementation


procedure TProgressBarWithText.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  prevfont: HGDIOBJ;
  prevbkmode: Integer;
  R: TRect;
begin
  inherited;
  if ProgressText <> '' then
  begin
    R := ClientRect;
    DC := GetWindowDC(Handle);
    prevbkmode := SetBkMode(DC, TRANSPARENT);
    prevfont := SelectObject(DC, Font.Handle);
    DrawText(DC, PChar(ProgressText), Length(ProgressText),
      R, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
    SelectObject(DC, prevfont);
    SetBkMode(DC, prevbkmode);
    ReleaseDC(Handle, DC);
  end;
end;


procedure Register;
begin
  RegisterComponents('F0XHOUND', [TProgressBarWithText]);
end;

end.