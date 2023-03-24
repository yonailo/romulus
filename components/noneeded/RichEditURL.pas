unit RichEditURL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls,
  ComCtrls, ExtCtrls, RichEdit, TntComCtrls;
  
type
  TURLClickEvent = procedure(Sender :TObject; const URL: widestring) of object;

  TRichEditURL = class(TTntRichEdit)
  private
    FOnURLClick: TURLClickEvent;
    procedure CNNotify(var Msg: TWMNotify); message CN_NOTIFY;
  protected
    procedure DoURLClick (const URL : widestring);
    procedure CreateWnd; override;
  published
    property OnURLClick : TURLClickEvent read FOnURLClick write FOnURLClick;
  end;

procedure Register;
  
  
implementation

procedure Register;
begin
  RegisterComponents('F0XHOUND', [TRichEditURL]);
end;


{ TRichEditURL }
procedure TRichEditURL.DoURLClick(const URL : widestring);
begin
  if Assigned(FOnURLClick) then OnURLClick(Self, URL);
end; (*DoURLClick*)

procedure TRichEditURL.CNNotify(var Msg: TWMNotify);
var
  p: TENLink;
  sURL: widestring;
begin
  if (Msg.NMHdr^.code = EN_LINK) then
  begin
   p := TENLink(Pointer(Msg.NMHdr)^);
   if (p.Msg = WM_LBUTTONDOWN) then
   begin
    try
     SendMessage(Handle, EM_EXSETSEL, 0, Longint(@(p.chrg)));
     sURL := SelText;
     DoURLClick(sURL);
    except
    end;
   end;
  end;

 inherited;
end; (*CNNotify*)

procedure TRichEditURL.CreateWnd;
var
  mask: Word;
begin
  inherited CreateWnd;

  SendMessage(Handle, EM_AUTOURLDETECT,1, 0);
  mask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(Handle, EM_SETEVENTMASK, 0, mask or ENM_LINK);
end; (*CreateWnd*)

end. (* RichEditURL.pas *)


{
********************************************
Zarko Gajic
About.com Guide to Delphi Programming
http://delphi.about.com
email: delphi@aboutguide.com
free newsletter: http://delphi.about.com/library/blnewsletter.htm
forum: http://forums.about.com/ab-delphi/start/
********************************************
}