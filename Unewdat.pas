unit Unewdat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, strings, GR32_Image, Tntforms,
  TntExtCtrls, TntButtons, TntStdCtrls;

type
  TFnewdat = class(TTntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    BitBtn4: TTntBitBtn;
    Label3: TTntLabel;
    Edit2: TTntEdit;
    Label10: TTntLabel;
    Edit9: TTntEdit;
    Label2: TTntLabel;
    Edit1: TTntEdit;
    Label4: TTntLabel;
    Edit3: TTntEdit;
    Label5: TTntLabel;
    Label6: TTntLabel;
    Edit5: TTntEdit;
    Label8: TTntLabel;
    Edit7: TTntEdit;
    Label9: TTntLabel;
    Edit8: TTntEdit;
    Label7: TTntLabel;
    Edit6: TTntEdit;
    Edit4: TTntEdit;
    Label11: TTntLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Panel2: TTntPanel;
    SpeedButton1: TTntSpeedButton;
    SpeedButton2: TTntSpeedButton;
    SpeedButton3: TTntSpeedButton;
    SpeedButton4: TTntSpeedButton;
    SpeedButton5: TTntSpeedButton;
    SpeedButton6: TTntSpeedButton;
    SpeedButton7: TTntSpeedButton;
    SpeedButton8: TTntSpeedButton;
    SpeedButton9: TTntSpeedButton;
    SpeedButton10: TTntSpeedButton;
    SpeedButton11: TTntSpeedButton;
    Panel3: TTntPanel;
    Edit10: TTntEdit;
    Image321: TImage32;
    Image3210: TImage32;
    TntSpeedButton1: TTntSpeedButton;
    TntEdit1: TTntEdit;
    TntSpeedButton2: TTntSpeedButton;
    TntSpeedButton3: TTntSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit10KeyPress(Sender: TObject; var Key: Char);
    procedure Edit10Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TntSpeedButton1Click(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntSpeedButton2Click(Sender: TObject);
    procedure TntSpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    FFocusControl: TControl;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
  public
    { Public declarations }
    procedure OnEnter(Sender: TObject);
    procedure OnExit(Sender: TObject);
    procedure buttonclick(sender : Tobject);
    function getdeffilemode():string;
    procedure setimagetype(typ:string;img:Timage32);
    procedure trimall;
  end;

var
  Fnewdat: TFnewdat;
  overwritedat: longint;

implementation

uses Umain;

{$R *.dfm}

procedure Tfnewdat.trimall;
begin
edit1.Text:=Trim(edit1.Text);
edit2.Text:=Trim(edit2.Text);
edit3.Text:=Trim(edit3.Text);
edit4.Text:=Trim(edit4.Text);
edit5.Text:=Trim(edit5.Text);
edit6.Text:=Trim(edit6.Text);
edit7.Text:=Trim(edit7.Text);
edit8.Text:=Trim(edit8.Text);
edit9.Text:=Trim(edit9.Text);
edit10.Text:=Trim(edit10.Text);

if edit1.Text='' then
  Edit1.Text:=traduction(282);
end;

procedure Tfnewdat.setimagetype(typ:string;img:Timage32);
var
bmp:Tbitmap;
begin
bmp:=TBitmap.Create;
img.Canvas.Brush.Color := Fnewdat.Color;
img.Canvas.Fillrect(img.Canvas.ClipRect);
Fmain.ImageList2.GetBitmap(getdattypeiconindexfromchar(typ),bmp);
img.Bitmap.Assign(bmp);
bmp.free;
end;

function Tfnewdat.getdeffilemode():string;
begin
Result:=IntToStr(deffilemode);
end;

procedure TFnewdat.buttonclick(sender : Tobject);
var
s,e:widestring;
ed:TTntedit;
begin
if edit10.Visible=true then
  ed:=edit10
else
  ed:=Tntedit1;

try
s:=copy(ed.Text,1,ed.SelStart)
except
end;

try
e:=copy(ed.text,ed.SelStart+1+ed.SelLength,length(ed.text));
except
end;

ed.text:=s+(sender as TTntspeedbutton).Caption+e;
stablishfocus(ed);
ed.SelStart:=length(s)+2;
end;

procedure TFnewdat.ApplicationIdle(Sender: TObject; var Done: Boolean);
var
CurControl: TControl;
P: TPoint;
begin
try
  GetCursorPos(P);
  CurControl := FindDragTarget(P, True);
  if FFocusControl <> CurControl then
    begin
    if FFocusControl <> nil then
      OnExit(FFocusControl);
    FFocusControl := CurControl;
    if FFocusControl <> nil then
      OnEnter(FFocusControl);
  end;
except
  FFocusControl:=nil;
end;
end;

procedure TFnewdat.OnEnter(Sender: TObject);
var
s:shortint;
begin
//OnEnter code
If sender.classname='TTntSpeedButton' then begin
  try
    strtoint((sender as TTntspeedbutton).Name[13]);
    s:=strtoint((sender as TTntspeedbutton).Name[12]+(sender as TTntspeedbutton).Name[13]);
  except
    s:=strtoint((sender as TTntspeedbutton).Name[12]);
  end;
  panel3.caption:=traduction(s+224);
end;

end;

procedure TFnewdat.OnExit(Sender: TObject);
begin
//OnExit code
If sender.classname='TTntSpeedButton' then begin
   panel3.caption:='';
end;
end;

procedure TFnewdat.FormCreate(Sender: TObject);

var
x:integer;
begin
FFocusControl := nil;
Application.OnIdle := ApplicationIdle;

Fmain.fixcomponentsbugs(Fnewdat);
                                  
TntSpeedButton1.Hint:=traduction(541);

for x:=0 to ComponentCount-1 do
  if components[x] is TTntspeedbutton then
    if (components[x] as TTntspeedbutton).Caption<>'' then
      (components[x] as TTntspeedbutton).OnClick:=buttonclick;
end;

procedure TFnewdat.BitBtn1Click(Sender: TObject);
begin
trimall;
Fnewdat.Tag:=2;
close;
end;

procedure TFnewdat.BitBtn2Click(Sender: TObject);
begin
trimall;
Fnewdat.Tag:=1;
close;
end;

procedure TFnewdat.BitBtn3Click(Sender: TObject);
begin
close;
end;

procedure TFnewdat.BitBtn4Click(Sender: TObject);
begin
Fnewdat.Tag:=3;
close;
end;

procedure TFnewdat.FormDestroy(Sender: TObject);
begin
Application.OnIdle := nil;
end;

procedure TFnewdat.FormShow(Sender: TObject);
const
s=' :';
begin
Fmain.addtoactiveform((sender as Tform),true);

caption:=traduction(95);

BitBtn1.caption:=traduction(83);
if Image3210.Tag=0 then begin
  BitBtn2.caption:=traduction(82);
  BitBtn3.caption:=traduction(84);
end
else begin
  BitBtn2.caption:=traduction(80);
  BitBtn3.caption:=traduction(81);
  BitBtn1.Visible:=False;
  BitBtn4.Visible:=false;
  edit3.ReadOnly:=false;
  edit9.ReadOnly:=False;
  edit3.Color:=clwindow;
  edit9.color:=clwindow;
  edit3.TabStop:=true;
  edit9.TabStop:=true;
  edit4.Text:=datetostr(now);
  setimagetype('X',Image3210);
  label1.Caption:=traduction(350)
end;

Fmain.labelshadow(label1,Fnewdat);
BitBtn4.caption:=traduction(85);

label11.Caption:=traduction(93)+' ';

label3.Caption:=traduction(94)+s;
label10.Caption:=traduction(22)+s;
label2.Caption:=traduction(11)+s;
label4.Caption:=traduction(12)+s;
label5.Caption:=traduction(15)+s;

if label6.tag=0 then
  label6.Caption:=traduction(16)+s
else
  label6.Caption:=traduction(236)+s;


label7.Caption:=traduction(17)+s;

label8.Caption:=traduction(18)+s;
label9.Caption:=traduction(19)+s;

tntspeedbutton2.Caption:=traduction(11);
tntspeedbutton3.Caption:=traduction(151);
end;

procedure TFnewdat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
FFocusControl := nil;
Application.OnIdle := nil;
trimall;
end;

procedure TFnewdat.Edit10KeyPress(Sender: TObject; var Key: Char);
begin
key:=limitconflictcharsedit(sender,key,true);
end;

procedure TFnewdat.Edit10Change(Sender: TObject);
begin
limitconflictcharsedit2(sender,true);
end;

procedure TFnewdat.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFnewdat.TntSpeedButton1Click(Sender: TObject);
begin
if edit10.visible=true then
  edit10.Text:=defofffilename
else
  tntedit1.Text:=checkofflinelistdescriptioniffailsreturndefault('');;

end;

procedure TFnewdat.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

procedure TFnewdat.TntSpeedButton2Click(Sender: TObject);
begin
edit10.Visible:=false;
tntedit1.Width:=edit10.Width;
TntEdit1.Visible:=true;
label6.Caption:=traduction(620);
end;

procedure TFnewdat.TntSpeedButton3Click(Sender: TObject);
begin
edit10.Visible:=true;
TntEdit1.Visible:=false;
label6.Caption:=traduction(236);
end;

end.
