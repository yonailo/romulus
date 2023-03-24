unit Unewfolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, Strings, GR32_Image,Tntforms,
  TntExtCtrls, TntStdCtrls, TntButtons;

type
  TFnewfolder = class(Ttntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label3: TTntLabel;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    Label2: TTntLabel;
    Edit1: TTntEdit;
    Label4: TTntLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Image321: TImage32;
    Image3210: TImage32;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
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
  Fnewfolder: TFnewfolder;

implementation

uses Umain;

{$R *.dfm}

procedure TFnewfolder.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  BitBtn1Click(sender);

end;

procedure TFnewfolder.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fnewfolder);
end;

procedure TFnewfolder.FormShow(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);


label3.Caption:=traduction(79)+' '+inttostr(Edit1.MaxLength);
if Edit1.MaxLength<=0 then begin
  edit1.Enabled:=false;
  label3.Caption:=traduction(79)+' '+'0';
  label3.Font.Color:=clred;
  bitbtn1.Enabled:=false;
end;

Fmain.labelshadow(label1,Fnewfolder);
BitBtn1.Caption:=traduction(80);
BitBtn2.Caption:=traduction(81);
Label4.caption:=traduction(136);
stablishfocus(edit1);

end;

procedure TFnewfolder.BitBtn1Click(Sender: TObject);
begin
Fnewfolder.Tag:=1;
close;
end;

procedure TFnewfolder.BitBtn2Click(Sender: TObject);
begin
close;
end;

procedure TFnewfolder.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
key:=limitconflictcharsedit(sender,key,false);
end;

procedure TFnewfolder.Edit1Change(Sender: TObject);
begin
limitconflictcharsedit2(sender,false);
end;

procedure TFnewfolder.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFnewfolder.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFnewfolder.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
