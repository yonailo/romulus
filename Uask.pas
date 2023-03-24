unit Uask;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Umain, strings, StdCtrls, Buttons, ExtCtrls, ImgList, GR32_Image, Tntforms,
  TntExtCtrls, TntButtons, TntStdCtrls;

type
  TFask = class(Ttntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel9: TTntPanel;
    Panel2: TTntPanel;
    Panel3: TTntPanel;
    Panel4: TTntPanel;
    Panel5: TTntPanel;
    Panel6: TTntPanel;
    Panel7: TTntPanel;
    Panel8: TTntPanel;
    Panel10: TTntPanel;
    Panel11: TTntPanel;
    Panel12: TTntPanel;
    Panel13: TTntPanel;
    Panel14: TTntPanel;
    Label5: TTntLabel;
    SpeedButton4: TTntSpeedButton;
    SpeedButton5: TTntSpeedButton;
    SpeedButton6: TTntSpeedButton;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    Panel15: TTntPanel;
    CheckBox1: TTntCheckBox;
    CheckBox2: TTntCheckBox;
    CheckBox3: TTntCheckBox;
    CheckBox4: TTntCheckBox;
    CheckBox5: TTntCheckBox;
    CheckBox6: TTntCheckBox;
    CheckBox7: TTntCheckBox;
    CheckBox8: TTntCheckBox;
    CheckBox9: TTntCheckBox;
    CheckBox10: TTntCheckBox;
    CheckBox11: TTntCheckBox;
    CheckBox12: TTntCheckBox;
    CheckBox13: TTntCheckBox;
    CheckBox14: TTntCheckBox;
    CheckBox15: TTntCheckBox;
    CheckBox16: TTntCheckBox;
    CheckBox17: TTntCheckBox;
    CheckBox18: TTntCheckBox;
    CheckBox19: TTntCheckBox;
    CheckBox20: TTntCheckBox;
    CheckBox21: TTntCheckBox;
    SpeedButton1: TTntSpeedButton;
    SpeedButton2: TTntSpeedButton;
    SpeedButton3: TTntSpeedButton;
    SpeedButton7: TTntSpeedButton;
    Image321: TImage32;
    Image322: TImage32;
    Image323: TImage32;
    Image324: TImage32;
    Image325: TImage32;
    Image326: TImage32;
    Image327: TImage32;
    Image328: TImage32;
    ComboBox1: TTntComboBox;
    TntSpeedButton2: TTntSpeedButton;
    TntSpeedButton3: TTntSpeedButton;
    TntSpeedButton4: TTntSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure markradios(i:integer);
    procedure endtoimage(i:integer);
  end;

var
  Fask: TFask;
  inside:boolean;
  showingask:boolean;

implementation

uses Uscan;

{$R *.dfm}

procedure TFask.endtoimage(i:integer);
begin
case i of
  0:Fscan.TntSpeedButton1.Glyph:=Fask.tntspeedbutton2.glyph;
  1:Fscan.TntSpeedButton1.Glyph:=Fask.tntspeedbutton3.glyph;
  2:Fscan.TntSpeedButton1.Glyph:=Fask.tntspeedbutton4.glyph;
end;
Fscan.TntSpeedButton1.tag:=i;
end;

procedure Tfask.markradios(i:integer);
var
x:integer;
begin

for x:=0 to Fask.ComponentCount-1 do
  if Fask.components[x] is TTntcheckbox then
    if (Fask.Components[x] as TTntcheckbox).tag=i then
      (Fask.Components[x] as TTntcheckbox).Checked:=true
    else
      (Fask.Components[x] as TTntcheckbox).Checked:=false;
end;

procedure TFask.FormCreate(Sender: TObject);
var
x:integer;
begin
showingask:=false;
Fmain.fixcomponentsbugs(Fask);

//EVENTS
for x:=0 to Fask.ComponentCount-1 do
  if Fask.components[x] is TTntcheckbox then
      (Fask.Components[x] as TTntcheckbox).OnClick:=CheckBoxClick;

//DEFAULT
markradios(0);
end;

procedure TFask.FormShow(Sender: TObject);
begin
showingask:=true;
Fmain.addtoactiveform((sender as Tform),true);

//SCAN IN REBUILD OPTION
combobox1.Visible:=isrebuild;

inside:=false;
bitbtn1.Tag:=0;

caption:=traduction(433);
label1.Caption:=traduction(434);
Fmain.labelshadow(label1,Fask);
SpeedButton4.caption:=traduction(435);
speedbutton5.caption:=traduction(83);
speedbutton6.caption:=traduction(85);

bitbtn1.Caption:=traduction(80);
bitbtn2.Caption:=traduction(81);

label5.Caption:=traduction(436);

panel15.Caption:=traduction(437);
panel3.Caption:=traduction(438);
panel5.Caption:=traduction(439);
panel7.Caption:=traduction(440);
panel10.Caption:=traduction(441);
panel12.Caption:=traduction(442);
panel14.Caption:=traduction(443);

//ASKMOD
if Fask.Tag=1 then begin //AUTOMATIC ASK DECISIONS

  if fix0='1' then
    Fask.checkbox2.checked:=true
  else
  if fix0='2' then
    Fask.checkbox3.Checked:=true;

  if fix1='1' then
    Fask.checkbox5.checked:=true
  else
  if fix1='2' then
    Fask.checkbox6.Checked:=true;

  if fix2='1' then
    Fask.checkbox8.checked:=true
  else
  if fix2='2' then
    Fask.checkbox9.Checked:=true;

  if fix3='1' then
    Fask.checkbox11.checked:=true
  else
  if fix3='2' then
    Fask.checkbox12.Checked:=true;

  if fix4='1' then
    Fask.checkbox14.checked:=true
  else
  if fix4='2' then
    Fask.checkbox15.Checked:=true;

  if fix5='1' then
    Fask.checkbox17.checked:=true
  else
  if fix5='2' then
    Fask.checkbox18.Checked:=true;

  if fix6='1' then
    Fask.checkbox20.checked:=true
  else
  if fix6='2' then
    Fask.checkbox21.Checked:=true;

  if combobox1.Items.Count=0 then begin
    combobox1.Items.Add(traduction(553));
    combobox1.Items.Add(traduction(554));
  end;

  try
    combobox1.ItemIndex:=strtoint(fix7);
  except
    fix7:='0';
    combobox1.ItemIndex:=0;
  end;
end;

try
if combobox1.ItemIndex=-1 then
  combobox1.ItemIndex:=0;
except
end;

try
  stablishfocus(bitbtn2);
except
end;

end;

procedure TFask.BitBtn2Click(Sender: TObject);
begin
close;
end;

procedure TFask.SpeedButton4Click(Sender: TObject);
begin
markradios(0);
end;

procedure TFask.SpeedButton5Click(Sender: TObject);
begin
markradios(1);
end;

procedure TFask.SpeedButton6Click(Sender: TObject);
begin
markradios(2);
end;

procedure TFask.CheckBoxClick(Sender: TObject);
var
x:integer;
n,p:ansistring;
begin
if inside=true then
  exit;

inside:=true;

n:=(sender as TTntcheckbox).Name;
p:=(sender as TTntcheckbox).Parent.Name;

for x:=0 to Fask.ComponentCount-1 do
  if Fask.components[x] is TTntcheckbox then
    if ((Fask.Components[x] as TTntcheckbox).Name<>n) AND ((Fask.Components[x] as TTntcheckbox).parent.name=p)then begin
      (Fask.Components[x] as TTntcheckbox).Checked:=false;
    end;

if (sender as TTntcheckbox).Checked=false then
  (sender as TTntcheckbox).Checked:=true;

inside:=false;
end;

procedure TFask.BitBtn1Click(Sender: TObject);
begin
bitbtn1.Tag:=1;
close;
end;

procedure TFask.FormClose(Sender: TObject; var Action: TCloseAction);
begin
showingask:=false;
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFask.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFask.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
