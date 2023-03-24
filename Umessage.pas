unit Umessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, Buttons, StdCtrls, ComCtrls, Strings,
  GR32_Image, Tntforms, TntExtCtrls, TntStdCtrls, TntButtons,
  TntComCtrls, fspTaskbarMgr, RxRichEd, Tntdialogs;

type
  TFmessage = class(TTntform)
    ImageList1: TImageList;
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    BitBtn4: TTntBitBtn;
    Image321: TImage32;
    TntRichEdit1: TTntRichEdit;
    Richedit1: TRxRichEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmessage: TFmessage;
  FWinfo: TFlashWInfo;
  
implementation

uses Umain, Uscan, Userver;

{$R *.dfm}

procedure TFmessage.FormShow(Sender: TObject);
var
x:integer;
begin
if Fmain.fspTaskbarMgr1.ProgressState=fstpsIndeterminate then begin
  Fmain.fspTaskbarMgr1.ProgressValue:=100;
  Fmain.fspTaskbarMgr1.ProgressState:=fstpsPaused;
end;

Fmain.addtoactiveform((sender as Tform),true);

try
  stablishfocus(bitbtn3);
except
  try
    stablishfocus(bitbtn2);
  except
  end;
end;

Fmessage.TntRichEdit1.Lines.Text:=trim(Fmessage.TntRichEdit1.Lines.Text);//FIX
Fmessage.Richedit1.Clear;
for x:=0 to Fmessage.TntRichEdit1.Lines.count-1 do begin //0.037 RXRICHEDIT CONVERSION
  //wideshowmessage(Fmessage.TntRichEdit1.Lines.Strings[x]);
  insertrichtext(Fmessage.Richedit1,Fmessage.TntRichEdit1.Lines.Strings[x],Fmessage.Richedit1.font.color);
end;

Fmain.labelshadow(label1,Fmessage);

Beep;
end;

procedure TFmessage.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fmessage);

caption:=traduction(86);
BitBtn1.Caption:=traduction(83);
BitBtn2.Caption:=traduction(82);
BitBtn3.Caption:=traduction(84);
BitBtn4.Caption:=traduction(85);
end;

procedure TFmessage.BitBtn1Click(Sender: TObject);
begin
Fmessage.Tag:=2;
close;
end;

procedure TFmessage.BitBtn2Click(Sender: TObject);
begin
Fmessage.Tag:=1;
close;
end;

procedure TFmessage.BitBtn3Click(Sender: TObject);
begin
Fmessage.Tag:=0;
close;
end;

procedure TFmessage.BitBtn4Click(Sender: TObject);
begin
Fmessage.Tag:=-1;
close;
end;

procedure TFmessage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if Fmain.fspTaskbarMgr1.ProgressState=fstpsPaused then begin
  Fmain.fspTaskbarMgr1.ProgressValue:=0;
  Fmain.fspTaskbarMgr1.ProgressState:=fstpsIndeterminate;
end;

Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFmessage.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFmessage.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
