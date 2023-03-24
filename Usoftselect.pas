unit Usoftselect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, TntExtCtrls, Tntforms, Buttons,
  TntButtons,strings, GR32_Image, ExtCtrls;

type
  TFsoftselect = class(TTntform)
    TntRadioGroup1: TTntRadioGroup;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Image329: TImage32;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fsoftselect: TFsoftselect;

implementation

uses Umain;

{$R *.dfm}

procedure TFsoftselect.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFsoftselect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFsoftselect.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fsoftselect);
end;

procedure TFsoftselect.FormShow(Sender: TObject);
begin
caption:=traduction(137);
label1.Caption:=traduction(580);
Fmain.labelshadow(label1,Fsoftselect);
TntRadioGroup1.Caption:=traduction(71);
TntRadioGroup1.Items.Strings[1]:=traduction(582);
TntBitBtn1.Caption:=traduction(80);
TntBitBtn2.Caption:=traduction(81);

end;

procedure TFsoftselect.TntBitBtn2Click(Sender: TObject);
begin
close;
end;

procedure TFsoftselect.TntBitBtn1Click(Sender: TObject);
begin
Fsoftselect.Tag:=1;
close;
end;

procedure TFsoftselect.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
