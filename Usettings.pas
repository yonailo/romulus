unit Usettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, strings, Buttons, ComCtrls, ImgList,
  Umain, Mymessages, Registry, Shellapi, EmbeddedWB,
  GR32_Image, Tntforms, TntExtCtrls, TntComCtrls, TntButtons,
  TntStdCtrls, Tntfilectrl, Tntclasses, Tntgraphics, RxRichEd ;

type
  TFsettings = class(TTntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    TreeView1: TTntTreeView;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    ImageList1: TImageList;
    PageControl1: TTntPageControl;
    TabSheet1: TTntTabSheet;
    TabSheet2: TTntTabSheet;
    TabSheet3: TTntTabSheet;
    TabSheet4: TTntTabSheet;
    Panel3: TTntPanel;
    Panel4: TTntPanel;
    Edit1: TTntEdit;
    SpeedButton1: TTntSpeedButton;
    Label2: TTntLabel;
    ImageList2: TImageList;
    ImageList3: TImageList;
    Label13: TTntLabel;
    Panel6: TTntPanel;
    SpeedButton14: TTntSpeedButton;
    SpeedButton15: TTntSpeedButton;
    Label17: TTntLabel;
    CheckBox4: TTntCheckBox;
    TabSheet6: TTntTabSheet;
    ComboBox2: TTntComboBox;
    Label18: TTntLabel;
    CheckBox5: TTntCheckBox;
    TabSheet7: TTntTabSheet;
    TabSheet5: TTntTabSheet;
    CheckBox9: TTntCheckBox;
    Label24: TTntLabel;
    Edit5: TTntEdit;
    SpeedButton16: TTntSpeedButton;
    TrackBar1: TTrackBar;
    Label4: TTntLabel;
    Label5: TTntLabel;
    Label7: TTntLabel;
    TrackBar2: TTrackBar;
    Label6: TTntLabel;
    Label8: TTntLabel;
    TrackBar3: TTrackBar;
    Label9: TTntLabel;
    CheckBox10: TTntCheckBox;
    Label3: TTntLabel;
    Bevel3: TBevel;
    Image3210: TImage32;
    Image321: TImage32;
    Image322: TImage32;
    Image323: TImage32;
    Image329: TImage32;
    TabSheet8: TTntTabSheet;
    Panel8: TTntPanel;
    Image325: TImage32;
    Panel7: TTntPanel;
    Panel9: TTntPanel;
    Label20: TTntLabel;
    Label21: TTntLabel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    CheckBox6: TTntCheckBox;
    CheckBox7: TTntCheckBox;
    Image327: TImage32;
    Image328: TImage32;
    Panel2: TTntPanel;
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
    SpeedButton12: TTntSpeedButton;
    Label15: TTntLabel;
    Label14: TTntLabel;
    Bevel4: TBevel;
    Label16: TTntLabel;
    SpeedButton13: TTntSpeedButton;
    CheckBox1: TTntCheckBox;
    Edit3: TTntEdit;
    Panel5: TTntPanel;
    Edit2: TTntEdit;
    CheckBox2: TTntCheckBox;
    ComboBox1: TTntComboBox;
    Image324: TImage32;
    Panel10: TTntPanel;
    Edit6: TTntEdit;
    Label10: TTntLabel;
    CheckBox11: TTntCheckBox;
    CheckBox12: TTntCheckBox;
    CheckBox13: TTntCheckBox;
    Bevel8: TBevel;
    Image3211: TImage32;
    Label11: TTntLabel;
    Edit7: TTntEdit;
    Edit8: TTntEdit;
    Label12: TTntLabel;
    Label23: TTntLabel;
    ComboBox3: TTntComboBox;
    Image3212: TImage32;
    Image3213: TImage32;
    Label25: TTntLabel;
    Label26: TTntLabel;
    Edit9: TTntEdit;
    Label27: TTntLabel;
    SpeedButton17: TTntSpeedButton;
    CheckBox14: TTntCheckBox;
    Label28: TTntLabel;
    Edit10: TTntEdit;
    CheckBox15: TTntCheckBox;
    CheckBox16: TTntCheckBox;
    CheckBox17: TTntCheckBox;
    CheckBox18: TTntCheckBox;
    Label19: TTntLabel;
    Edit4: TTntEdit;
    TntComboBox1: TTntComboBox;
    TntGroupBox1: TTntGroupBox;
    ListView1: TTntListView;
    TntComboBox2: TTntComboBox;
    TntComboBox3: TTntComboBox;
    TntComboBox4: TTntComboBox;
    Combobox4: TTntComboBox;
    CheckBox3: TTntCheckBox;
    TntButton1: TTntButton;
    TntCheckBox1: TTntCheckBox;
    Richedit1: TRxRichEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure traductfsettings();
    procedure TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Edit2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image325Click(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure TntComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TntComboBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TntComboBox2Change(Sender: TObject);
    procedure TntComboBox3Change(Sender: TObject);
    procedure TntComboBox3DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TntComboBox4Change(Sender: TObject);
    procedure TntComboBox4DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CheckBox3Click(Sender: TObject);
    procedure TntButton1Click(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FFocusControl: TControl;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    procedure checkunchecklist(b:boolean);
  public
    { Public declarations }
    procedure OnEnter(Sender: TObject);
    procedure OnExit(Sender: TObject);
    procedure buttonclick(sender : Tobject);
    procedure loadlangslist;
  end;

var
  Fsettings: TFsettings;

implementation

uses Ulog, Userver;

{$R *.dfm}

procedure Tfsettings.checkunchecklist(b:boolean);
var
x:integer;
begin
for x:=0 to listview1.Items.count-1 do
  listview1.items.Item[x].Checked:=b;
end;

function WindowsExit(RebootParam: Longword): Boolean;
var
   TTokenHd: THandle;
   TTokenPvg: TTokenPrivileges;
   cbtpPrevious: DWORD;
   rTTokenPvg: TTokenPrivileges;
   pcbtpPreviousRequired: DWORD;
   tpResult: Boolean;
const
   SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
   if Win32Platform = VER_PLATFORM_WIN32_NT then
   begin
     tpResult := OpenProcessToken(GetCurrentProcess(),
       TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
       TTokenHd) ;
     if tpResult then
     begin
       tpResult := LookupPrivilegeValue(nil,
                                        SE_SHUTDOWN_NAME,
                                        TTokenPvg.Privileges[0].Luid) ;
       TTokenPvg.PrivilegeCount := 1;
       TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
       cbtpPrevious := SizeOf(rTTokenPvg) ;
       pcbtpPreviousRequired := 0;
       if tpResult then
         Windows.AdjustTokenPrivileges(TTokenHd,
                                       False,
                                       TTokenPvg,
                                       cbtpPrevious,
                                       rTTokenPvg,
                                       pcbtpPreviousRequired) ;
     end;
   end;
   Result := ExitWindowsEx(RebootParam, 0) ;
end;

procedure Tfsettings.loadlangslist;
var
st:TTntStringList;
x,y:integer;
begin

//Sort and add langs
Tntcombobox1.Items.Clear;
//LANGS HERE

st:=TTntStringList.Create;
for x:=0 to maxlangid do
  st.Add(idtolangname(x+1)+'"'+inttostr(x));

st.Sort;

for x:=0 to st.Count-1 do begin
  y:=strtoint(gettoken(st.Strings[x],'"',2));
  TntComboBox1.Items.Add(st.Strings[x]);

  if y=lang then begin //SET CURRENT LANG AUTOMATIC
    tntcombobox1.ItemIndex:=tntcombobox1.Items.Count-1;
  end;

end;

st.Free;
end;

procedure TFsettings.buttonclick(sender : Tobject);
var
s,e:widestring;
begin
try
s:=copy(edit3.Text,1,Edit3.SelStart)
except
end;

try
e:=copy(edit3.text,Edit3.SelStart+1+edit3.SelLength,length(edit3.text));
except
end;

edit3.text:=s+(sender as TTntspeedbutton).Caption+e;
stablishfocus(edit3);
edit3.SelStart:=length(s)+2;
end;

procedure TFsettings.ApplicationIdle(Sender: TObject; var Done: Boolean);
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

procedure TFsettings.OnEnter(Sender: TObject);
var
s:shortint;
begin
//OnEnter code

If sender.classname='TTntSpeedButton' then begin
  if (sender as TTntspeedbutton).Tag=0 then begin
    try
      strtoint((sender as TTntspeedbutton).Name[13]);
      s:=strtoint((sender as TTntspeedbutton).Name[12]+(sender as TTntspeedbutton).Name[13]);
    except
      s:=strtoint((sender as TTntspeedbutton).Name[12]);
    end;
    panel5.caption:=traduction(s+223);
  end;
  end;
end;

procedure TFsettings.OnExit(Sender: TObject);
begin
//OnExit code
If sender.classname='TTntSpeedButton' then begin
  if (sender as TTntspeedbutton).Tag=0 then
   panel5.caption:='';
end;
end;


procedure Tfsettings.traductfsettings;
const
s=' : ';
var
rec:integer;
begin
//TRADUCTION
caption:=traduction(9);
Label1.Caption:=traduction(111);
Fmain.labelshadow(label1,Fsettings);
label18.Caption:=traduction(45)+s;

rec:=combobox2.ItemIndex;

combobox2.Items.Strings[0]:=traduction(46);
combobox2.Items.Strings[1]:=traduction(47);
combobox2.Items.Strings[2]:=traduction(48);

combobox2.ItemIndex:=rec;

TreeView1.Items.Item[0].Text:=traduction(119);
TreeView1.Items.Item[1].Text:=traduction(120);
TreeView1.Items.Item[2].Text:=traduction(6);
TreeView1.Items.Item[3].Text:=traduction(314);
TreeView1.Items.Item[4].Text:=traduction(121);
TreeView1.Items.Item[5].Text:=traduction(489);
TreeView1.Items.Item[6].Text:=traduction(122);
TreeView1.Items.Item[7].Text:=traduction(386);

BitBtn1.Caption:=traduction(80);
BitBtn2.Caption:=traduction(123);
BitBtn3.Caption:=traduction(217);
TntButton1.Caption:=traduction(594);

//COMMUNITY
label10.caption:=traduction(526)+s;
checkbox12.Caption:=traduction(528);
checkbox11.Caption:=traduction(529);
label27.Caption:=traduction(530)+s;
label28.Caption:=traduction(539)+s;
label11.Caption:=traduction(527);
label25.Caption:=traduction(531)+s;
label26.Caption:=traduction(531)+s;
checkbox13.Caption:=traduction(532);
checkbox14.Caption:=traduction(533);


//MISC
checkbox1.Caption:=traduction(203);
checkbox2.Caption:=traduction(271);
TntCheckBox1.Caption:=traduction(596);
checkbox4.Caption:=traduction(381);
checkbox5.Caption:=traduction(450);

checkbox9.Caption:=traduction(498);
checkbox10.Caption:=traduction(109);

label16.Caption:=traduction(272)+s;

label14.Caption:=traduction(204)+s;
label20.Caption:=traduction(188);
label21.Caption:=traduction(5);
label19.Caption:=traduction(492)+s;
label24.Caption:=traduction(189)+s;

//INFO

Richedit1.Lines.BeginUpdate;
Richedit1.Lines.Clear;

//RichEdit1.Lines.Add('[APP]');
//RichEdit1.Lines.Add('');
insertrichtext(RichEdit1,traduction(225)+' > '+Application.Title,RichEdit1.font.color);
insertrichtext(RichEdit1,traduction(12)+' > '+appversion,RichEdit1.font.color);
insertrichtext(RichEdit1,traduction(16)+' > F0XHOUND',RichEdit1.font.color);
insertrichtext(RichEdit1,traduction(19)+' > '+'playwithfire@hotmail.com',RichEdit1.font.color);
insertrichtext(RichEdit1,'Url > '+romulusurl,RichEdit1.font.color);
insertrichtext(RichEdit1,'',RichEdit1.font.color);                                               //SPA
insertrichtext(RichEdit1,'F0XHOUND'+' > '+traduction(487)+' > '+idtolangname(1)+' / '+idtolangname(2),RichEdit1.font.color);
insertrichtext(RichEdit1,'Kludge'+' > '+traduction(487)+' > '+idtolangname(1),RichEdit1.font.color);  //ENG
insertrichtext(RichEdit1,'SpaceAgeHero & Thallyrion'+' > '+traduction(487)+' > '+idtolangname(3),RichEdit1.font.color);  //GER
insertrichtext(RichEdit1,'Kaito Kito'+' > '+traduction(487)+' > '+idtolangname(4),RichEdit1.font.color); //FRA
insertrichtext(RichEdit1,'Thallyrion'+' > '+traduction(487)+' > '+idtolangname(5),RichEdit1.font.color);  //HUN
insertrichtext(RichEdit1,'Xiao'+' > '+traduction(487)+' > '+idtolangname(6),RichEdit1.font.color);  //JAP
insertrichtext(RichEdit1,'Caboteta & Silius'+' > '+traduction(487)+' > '+idtolangname(7),RichEdit1.font.color); //POR
insertrichtext(RichEdit1,'Minsoo Jang'+' > '+traduction(487)+' > '+idtolangname(8),RichEdit1.font.color); //KOR
insertrichtext(RichEdit1,'Caboteta & Squalo'+' > '+traduction(487)+' > '+idtolangname(9),RichEdit1.font.color); //ITA
insertrichtext(RichEdit1,'Agus & Mikel & Laura'+' > '+traduction(487)+' > '+idtolangname(10),RichEdit1.font.color); //EUSK
insertrichtext(RichEdit1,'xlmldh'+' > '+traduction(487)+' > '+idtolangname(11)+' / '+idtolangname(12),RichEdit1.font.color);
insertrichtext(RichEdit1,'Michip'+' > '+traduction(487)+' > '+idtolangname(13),RichEdit1.font.color);
insertrichtext(RichEdit1,'',RichEdit1.font.color);
insertrichtext(RichEdit1,'[BETATESTERS & MISC]',RichEdit1.font.color);
insertrichtext(RichEdit1,'',RichEdit1.font.color);
insertrichtext(RichEdit1,'Mr Ravik, Grinderedge, Elfish, emuLOAD, MrTikki, Maero, xTMODx, Paccy, Johnny gin gasper, Executer, Special-T, ErAzOr, Silius, Agus, xlmldh, RowlaxX, ToniBC',RichEdit1.font.color);

//182 183 184 185 186

RichEdit1.selStart := 0 ;
SendMessage(richedit1.handle, EM_SCROLLCARET,0,0);
Richedit1.Lines.endupdate;

label2.Caption:=traduction(187)+s;
label3.Caption:=traduction(188);
//label12.Caption:=traduction(109)+s;

rec:=TntComboBox2.ItemIndex;
TntComboBox2.Items.Strings[0]:=traduction(171);
tntcombobox2.ItemIndex:=rec;

rec:=TntComboBox3.ItemIndex;
TntComboBox3.Items.Strings[0]:=traduction(171);
tntcombobox3.ItemIndex:=rec;

rec:=TntComboBox4.ItemIndex;
TntComboBox4.Items.Strings[0]:=traduction(171);
tntcombobox4.ItemIndex:=rec;

//label10.Caption:=traduction(189);
//label11.Caption:=traduction(190);
label13.Caption:=traduction(191)+s;
label15.Caption:=traduction(238);

checkbox6.Caption:=traduction(488);
checkbox7.Caption:=traduction(490);
checkbox3.Caption:=traduction(585);

checkbox15.Caption:=traduction(555);
checkbox16.Caption:=traduction(556);
checkbox17.Caption:=traduction(557);
checkbox18.Caption:=traduction(558);

Flog.label2.Caption:=text;
//checkbox6.Width:=Flog.Label2.Width+18;

speedbutton1.Hint:=traduction(163);
speedbutton13.Hint:=traduction(93);
speedbutton16.Hint:=traduction(163);
speedbutton17.Hint:=traduction(163);

TntGroupBox1.Caption:=traduction(353);
label17.Caption:=traduction(373);

//DRAG N DROP CHECK
//checkbox3.Caption:=traduction(309);

speedbutton14.Caption:=traduction(371);
speedbutton15.Caption:=traduction(372);
end;

procedure TFsettings.FormShow(Sender: TObject);
var
x:integer;
listitem:Tlistitem;
begin

Fmain.addtoactiveform((sender as Tform),true);

pagecontrol1.ActivePageIndex:=0;

for x:=0 to PageControl1.PageCount-1 do
  PageControl1.Pages[x].TabVisible:=false;

//LOAD CONFIG

checkbox1.Checked:=ingridlines;
checkbox2.Checked:=showasbytes;
checkbox10.Checked:=Fmain.CoolTrayIcon1.IconVisible;
Fmain.CoolTrayIcon1.Hint:=Application.Title+' - '+appversion;//FIX

checkbox4.Checked:=searchromulsupdates;

checkbox6.Checked:=solidcomp;
checkbox7.Checked:=multicpu;
checkbox3.Checked:=userar5;
checkbox9.Checked:=preventsleep;
checkbox15.Checked:=defmd5;
checkbox16.Checked:=defsha1;
checkbox17.Checked:=deftz;
checkbox18.Checked:=deft7z;
TntCheckBox1.Checked:=colorcolumns;

if getcpunumcores=1 then
  checkbox7.Enabled:=false;

if fmain.PageControl1.Pages[3].TabVisible=false then
  checkbox5.Enabled:=false
else
  checkbox5.Checked:=useownwb;

loadlangslist;

edit1.Text:=defbackuppath;
edit4.Text:=inttostr(Fmain.Edit4.Tag div 1000);

x:=defromscomp;

case x of
  0..9:TntComboBox2.ItemIndex:=0;
  10..19:begin
          TntComboBox2.ItemIndex:=1;
          TrackBar1.Position:=x-10;
          end;
  20..29:begin
          TntComboBox2.ItemIndex:=2;
          TrackBar1.Position:=x-20;
          end;
  30..39:begin
          TntComboBox2.ItemIndex:=3;
          TrackBar1.Position:=x-30;
          end;
else
  TntComboBox2.ItemIndex:=0;
end;

x:=defsamplescomp;
case x of
  0..9:TntComboBox3.ItemIndex:=0;
  10..19:begin
          TntComboBox3.ItemIndex:=1;
          TrackBar2.Position:=x-10;
        end;
  20..29:begin
          TntComboBox3.ItemIndex:=2;
          TrackBar2.Position:=x-20;
        end;
  30..39:begin
          TntComboBox3.ItemIndex:=3;
          TrackBar2.Position:=x-30;
        end;
else
  TntComboBox3.ItemIndex:=0;
end;

x:=defchdscomp;
case x of
  0..9:Tntcombobox4.ItemIndex:=0;
  10..19:begin
          Tntcombobox4.ItemIndex:=1;
          TrackBar3.Position:=x-10;
          end;
  20..29:begin
          Tntcombobox4.ItemIndex:=2;
          TrackBar3.Position:=x-20;
        end;
  30..39:begin
          Tntcombobox4.ItemIndex:=3;
          TrackBar3.Position:=x-30;
          end;
else
  Tntcombobox4.ItemIndex:=0;
end;

Tntcombobox2Change(sender);
Tntcombobox3Change(sender);
Tntcombobox4Change(sender);

edit3.Text:=defofffilename;
edit2.Text:=inttostr(maxloglines);
edit5.Text:=tempdirectoryextractvar;
edit9.Text:=communitydownfolder;
edit10.Text:=inttostr(connectionport);
checkbox13.Checked:=firewall;
checkbox14.Checked:=agressive;

combobox3.ItemIndex:=combobox3.Items.IndexOf(inttostr(upslots));
combobox4.ItemIndex:=combobox4.Items.IndexOf(inttostr(downslots));
edit7.Text:=IntToStr(upspeed);
edit8.Text:=IntToStr(downspeed);
combobox1.ItemIndex:=deffilemode;

for x:=0 to updatercount-1 do begin                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               //0.050 Removed Yori
  if (updaterdescription(x,false)<>'3') AND (updaterdescription(x,false)<>'12') AND (updaterdescription(x,false)<>'13') AND (updaterdescription(x,false)<>'14') AND (updaterdescription(x,false)<>'16') AND (updaterdescription(x,false)<>'17') AND (updaterdescription(x,false)<>'18') AND (updaterdescription(x,false)<>'19') AND (updaterdescription(x,false)<>'20') AND (updaterdescription(x,false)<>'5') AND (updaterdescription(x,false)<>'6') AND (updaterdescription(x,false)<>'9') AND (updaterdescription(x,false)<>'10') then begin  //0.031 Removed Pocketheaven
    listitem:=listview1.items.add;
    listitem.Caption:=updaterdescription(x,true);
    listitem.ImageIndex:=strtoint(updaterdescription(x,false))+1;
    if gettoken(datgroups.Strings[x],'|',2)='1' then
      listitem.Checked:=true;
  end;
end;

//checkbox3.Enabled:=false;

edit6.Text:=username;
checkbox11.Checked:=defaultprofileshare;
checkbox12.Checked:=startupconnect;

//REMOVED 0.029
{If (Win32MajorVersion>=6) then begin //Is vista or later

  checkbox3.enabled:=true;

  if currentluavalue=0 then
    checkbox3.Checked:=true
  else
  if currentluavalue=1 then
    checkbox3.Checked:=false
  else
    checkbox3.Enabled:=false;
end;      }

traductfsettings;

combobox2.ItemIndex:=1;

if Fmain.High1.Checked then
  combobox2.ItemIndex:=0
else
if Fmain.Low1.Checked then
  combobox2.ItemIndex:=2;

stablishfocus(treeview1);
PageControl1.ActivePageIndex:=0;
stablishfocus(BitBtn3);

if checklinkedconnectionsok=true then
  TntButton1.Enabled:=false;

end;

procedure TFsettings.FormCreate(Sender: TObject);
var
x:integer;
begin
Fmain.fixcomponentsbugs(FSettings);

for x:=0 to ComponentCount-1 do
  if components[x] is TTntspeedbutton then
    if  (components[x] as TTntspeedbutton).tag=0 then
      (components[x] as TTntspeedbutton).OnClick:=buttonclick;

FFocusControl := nil;
Application.OnIdle := ApplicationIdle;
end;

procedure TFsettings.BitBtn3Click(Sender: TObject);
begin
close;
end;

procedure TFsettings.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
PageControl1.ActivePageIndex:=node.ImageIndex;
Fmain.setwinvista7theme(listview1.handle);  //FIX
end;

procedure TFsettings.SpeedButton1Click(Sender: TObject);
var
fold:widestring;
begin
fold:=folderdialoginitialdircheck(Edit1.Text);

Fmain.positiondialogstart;

if WideSelectDirectory(label2.caption,'',fold) then
  edit1.Text:=checkpathbar(fold);

end;

procedure TFsettings.BitBtn2Click(Sender: TObject);
var
//luavalue:integer;
x,y,oldlang:integer;
s:ansistring;
wb:TEmbeddedWB;
oldcolorcolumns:boolean;
warningmsg:widestring;
begin
oldlang:=lang;
oldcolorcolumns:=colorcolumns;

lang:=strtoint(gettoken(TntComboBox1.Items.Strings[tntcombobox1.ItemIndex],'"',2));

if oldlang<>lang then begin //ONLY TRANSLATE IF NEEDED

  loadlangslist;

  traductfsettings;

  repaint;//0.029

  Fmain.traductfmain;

  try
    Fmain.traductvirtualcolumns;
  except
  end;

  for x:=0 to Fmain.PageControl3.PageCount-1 do begin
    s:=changein(Fmain.PageControl3.Pages[x].name,'T','');

    try
      wb:=(Fmain.Panel74.FindComponent (s) as TEmbeddedWB);

      if Wideuppercase(wb.LocationURL)='ABOUT:BLANK' then begin
        wb.stop;
        if wb.DocumentSource<>'' then
          Fmain.wb_defaultpage(wb,true);
      end;

    except
    end;

  end;
end;

defbackuppath:=Edit1.Text;
tempdirectoryextractvar:=Edit5.Text;
defromscomp:=(TntComboBox2.ItemIndex*10)+TrackBar1.position;
defsamplescomp:=(TntComboBox3.ItemIndex*10)+TrackBar2.position;
defchdscomp:=(Tntcombobox4.ItemIndex*10)+TrackBar3.position;

deffilemode:=combobox1.ItemIndex;
useownwb:=checkbox5.Checked;
solidcomp:=checkbox6.Checked;
multicpu:=checkbox7.Checked;
userar5:=checkbox3.Checked;
defmd5:=checkbox15.checked;
defsha1:=checkbox16.checked;
deftz:=checkbox17.checked;
deft7z:=checkbox18.checked;
preventsleep:=checkbox9.checked;

colorcolumns:=TntCheckBox1.Checked;

username:=trim(edit6.Text);
Fmain.checkusername;

try
  connectionport:=strtoint(edit10.text);
except
end;

//COMMUNITY WARNING
connectionport:=checkvalidinternetport(connectionport,10001);
edit6.text:=username;

if Fserver.IdTCPServer1.Active=true then begin
  if currentusername<>username then begin
    warningmsg:=label10.caption;
  end;
  if Fserver.IdTCPServer1.DefaultPort<>connectionport then begin
    if warningmsg<>'' then
      warningmsg:=warningmsg+' - ';
    warningmsg:=warningmsg+label28.caption;
  end;
end;

communitydownfolder:=edit9.text;
firewall:=CheckBox13.Checked;
agressive:=checkbox14.Checked;

try
upslots:=strtoint(combobox3.Items.Strings[combobox3.itemindex]);
except
upslots:=3;
end;
try
downslots:=strtoint(combobox4.Items.Strings[combobox4.itemindex]);
except
downslots:=3;
end;

try
upspeed:=strtoint(edit7.Text);
except
upspeed:=0;
end;

try
downspeed:=strtoint(edit8.Text);
except
downspeed:=0;
end;;

startupconnect:=checkbox12.Checked;

defaultprofileshare:=checkbox11.Checked;

try
  maxloglines:=StrToInt(edit2.text);
except
end;
if (maxloglines<100) OR (maxloglines>9999) then
  maxloglines:=500;

try
Fmain.Edit4.Tag:=strtoint(Edit4.Text)*1000;
except
end;

ingridlines:=CheckBox1.Checked;

Fmain.setgridlines(Fmain.VirtualStringTree2,ingridlines);
Fmain.setgridlines(Fmain.VirtualStringTree4,ingridlines);
Fmain.setgridlines(Fserver.VirtualStringTree3,ingridlines);
Fmain.setgridlines(Fserver.VirtualStringTree2,ingridlines);
Fmain.setgridlines(Fserver.VirtualStringTree4,ingridlines);
Fmain.setgridlines(Fserver.VirtualStringTree5,ingridlines);

if oldcolorcolumns<>colorcolumns then begin //0.035 Color columns

  //DEFAULT SCANNER LISTS
  for x:=0 to Fmain.VirtualStringTree1.Header.Columns.Count-1 do
    if Fmain.VirtualStringTree1.Header.Columns[x].tag=0 then
      Fmain.VirtualStringTree1.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      Fmain.VirtualStringTree1.Header.Columns[x].Color:=clBtnFace
    else
      Fmain.VirtualStringTree1.Header.Columns[x].Color:=clwindow;

  for x:=0 to Fmain.VirtualStringTree3.Header.Columns.Count-1 do
    if Fmain.VirtualStringTree3.Header.Columns[x].tag=0 then
      Fmain.VirtualStringTree3.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      Fmain.VirtualStringTree3.Header.Columns[x].Color:=clBtnFace
    else
      Fmain.VirtualStringTree3.Header.Columns[x].Color:=clwindow;

  if masterlv<>nil then
  for x:=0 to masterlv.Header.Columns.Count-1 do
    if masterlv.Header.Columns[x].tag=0 then
      masterlv.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      masterlv.Header.Columns[x].Color:=clBtnFace
    else
      masterlv.Header.Columns[x].Color:=clwindow;

  if detaillv<>nil then
  for x:=0 to detaillv.Header.Columns.Count-1 do
    if detaillv.Header.Columns[x].tag=0 then
      detaillv.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      detaillv.Header.Columns[x].Color:=clBtnFace
    else
      detaillv.Header.Columns[x].Color:=clwindow;

  //in main list color columns
  for x:=0 to Fmain.VirtualStringTree2.Header.Columns.Count-1 do
    if Fmain.VirtualStringTree2.Header.Columns[x].tag=0 then
      Fmain.VirtualStringTree2.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      Fmain.VirtualStringTree2.Header.Columns[x].Color:=clBtnFace
    else
      Fmain.VirtualStringTree2.Header.Columns[x].Color:=clwindow;

  //generator list color columns
  for x:=0 to Fmain.VirtualStringTree4.Header.Columns.Count-1 do
    if Fmain.VirtualStringTree4.Header.Columns[x].tag=0 then
      Fmain.VirtualStringTree4.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      Fmain.VirtualStringTree4.Header.Columns[x].Color:=clBtnFace
    else
      Fmain.VirtualStringTree4.Header.Columns[x].Color:=clwindow;

  //in community
  for x:=0 to Fserver.VirtualStringTree2.Header.Columns.Count-1 do
    if Fserver.VirtualStringTree2.Header.Columns[x].tag=0 then
      Fserver.VirtualStringTree2.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      Fserver.VirtualStringTree2.Header.Columns[x].Color:=clBtnFace
    else
      Fserver.VirtualStringTree2.Header.Columns[x].Color:=clwindow;

  for x:=0 to Fserver.VirtualStringTree3.Header.Columns.Count-1 do
    if Fserver.VirtualStringTree3.Header.Columns[x].tag=0 then
      Fserver.VirtualStringTree3.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      Fserver.VirtualStringTree3.Header.Columns[x].Color:=clBtnFace
    else
      Fserver.VirtualStringTree3.Header.Columns[x].Color:=clwindow;

end;

Fmain.Setdefaultbitmap;
Fmain.loadimages;

showasbytes:=CheckBox2.Checked;
searchromulsupdates:=CheckBox4.Checked;
Fmain.CoolTrayIcon1.IconVisible:=checkbox10.Checked;

defofffilename:=checkofflinelistfilenameiffailsreturndefault(edit3.text);

case ComboBox2.ItemIndex of
  0:Fmain.High1Click(sender);
  1:Fmain.Normal1Click(sender);
  2:Fmain.low1click(sender);
end;

try
  masterlv.Repaint;
except
end;
try
 detaillv.Repaint;
except
end;

Fmain.VirtualStringTree4.Repaint;
Fmain.VirtualStringTree2.Repaint;

Fserver.virtualstringtree1.Repaint;
Fserver.virtualstringtree2.Repaint;
Fserver.virtualstringtree3.Repaint;
Fserver.virtualstringtree4.Repaint;
Fserver.virtualstringtree5.Repaint;

//Forze repaint and traduction
Fmain.showprolesmasterdetail(false,false,Fmain.getcurrentprofileid,true,true);

Fmain.checkconstructorstatus;
Fmain.showconstructorselected;

Fmain.checksleep;

for x:=0 to listview1.items.count-1 do begin
  s:='0';
  if listview1.Items.Item[x].Checked=true then
    s:='1';

  y:=datgroups.IndexOf(inttostr(listview1.Items.Item[x].ImageIndex-1)+'|0');
  if y=-1 then
    y:=datgroups.IndexOf(inttostr(listview1.Items.Item[x].ImageIndex-1)+'|1');

  datgroups.Strings[y]:=gettoken(datgroups.strings[y],'|',1)+'|'+s;
end;

try
  Fmain.wb_updatecontrols(Fmain.wb_current);
except
end;

try
  Fserver.traductfserver;///FORZE TRANSLATION
except
end;

//COMMUNITY RECONNECT NEEDED (Nick,Port)
if warningmsg<>'' then begin
  warningmsg:=changein(warningmsg,':','');
  warningmsg:=traduction(615)+#13#10#13#10+warningmsg;
  mymessagewarning(warningmsg);
end;

end;

procedure TFsettings.BitBtn1Click(Sender: TObject);
begin
BitBtn2Click(sender);
close;
end;

procedure TFsettings.TreeView1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
node: TTnttreenode;
begin
node := TreeView1.GetNodeAt(MousePos.X, MousePos.Y); // Tries to get node
if (node <> nil) then TreeView1.Selected := node; // Pass selection to tree
end;


procedure TFsettings.Edit2Change(Sender: TObject);
begin
try
Filteredit(sender);
except
end;
end;

procedure TFsettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);

FFocusControl := nil;
Application.OnIdle := nil;

end;

procedure TFsettings.SpeedButton13Click(Sender: TObject);
begin

mymessageinfomergesplit;

FFocusControl := nil;
Application.OnIdle := ApplicationIdle;
end;

procedure TFsettings.Edit3Change(Sender: TObject);
begin
limitconflictcharsedit2(sender,true);
end;

procedure TFsettings.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
key:=limitconflictcharsedit(sender,key,true);
end;

procedure TFsettings.SpeedButton14Click(Sender: TObject);
begin
checkunchecklist(true);
end;

procedure TFsettings.SpeedButton15Click(Sender: TObject);
begin
checkunchecklist(false);
end;

procedure TFsettings.Edit5Change(Sender: TObject);
begin
try
Filteredit(sender);
except
end;
end;

procedure TFsettings.Edit6Change(Sender: TObject);
begin
limitconflictcharsedit2(sender,false);
end;

procedure TFsettings.Edit4Change(Sender: TObject);
begin
try
Filteredit(sender);
except
end;
end;

procedure TFsettings.SpeedButton16Click(Sender: TObject);
var
fold:widestring;
begin
fold:=folderdialoginitialdircheck(Edit5.Text);

Fmain.positiondialogstart;

if WideSelectDirectory(label24.caption,'',fold) then
  edit5.Text:=checkpathbar(fold);

end;

procedure TFsettings.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);

end;

procedure TFsettings.Image325Click(Sender: TObject);
var
donationurl:ansistring;
begin
donationurl:='https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=playwithfire%40hotmail%2ecom&lc=IN&item_name=Romulus%20Rom%20Manager&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted';
Fmain.wb_navigate(donationurl,true,false);

end;

procedure TFsettings.Edit7Change(Sender: TObject);
begin
try
Filteredit(sender);
except
end;
end;

procedure TFsettings.Edit8Change(Sender: TObject);
begin
try
Filteredit(sender);
except
end;
end;

procedure TFsettings.SpeedButton17Click(Sender: TObject);
var
fold:widestring;
begin
fold:=folderdialoginitialdircheck(Edit9.Text);

Fmain.positiondialogstart;

if WideSelectDirectory(label27.Caption,'',fold) then
  edit9.Text:=checkpathbar(fold);
end;

procedure TFsettings.Edit10Change(Sender: TObject);
begin
try
Filteredit(sender);
except
end;
end;

procedure TFsettings.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
key:=limitconflictcharsedit(sender,key,false);
end;

procedure TFsettings.TntComboBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
tntcombobox1.canvas.fillrect(rect);
imagelist3.Draw(tntcombobox1.Canvas,rect.left,rect.top,strtoint(gettoken(tntcombobox1.items[index],'"',2)));//Get index
WideCanvasTextOut(tntcombobox1.canvas,rect.left+imagelist3.width+2,rect.top+1,gettoken(tntcombobox1.items[index],'"',1));

if odfocused in state then  //DISABLE FOCUS DOTTED
  tntcombobox1.canvas.DrawFocusRect(rect);

end;

procedure TFsettings.TntComboBox2DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
TntComboBox2.canvas.fillrect(rect);

imagelist2.Draw(TntComboBox2.Canvas,rect.left,rect.top,index);//Get index
WideCanvasTextOut(TntComboBox2.canvas,rect.left+imagelist2.width+2,rect.top+1,TntComboBox2.items[index]);

if odfocused in state then  //DISABLE FOCUS DOTTED
  TntComboBox2.canvas.DrawFocusRect(rect);

end;

procedure TFsettings.TntComboBox2Change(Sender: TObject);
begin
if TntComboBox2.ItemIndex=0 then
  TrackBar1.Enabled:=false
else
  TrackBar1.Enabled:=true;
end;

procedure TFsettings.TntComboBox3Change(Sender: TObject);
begin
if TntComboBox3.ItemIndex=0 then
  TrackBar3.Enabled:=false
else
  TrackBar3.Enabled:=true;
end;

procedure TFsettings.TntComboBox3DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
TntComboBox3.canvas.fillrect(rect);

imagelist2.Draw(TntComboBox3.Canvas,rect.left,rect.top,index);//Get index
WideCanvasTextOut(TntComboBox3.canvas,rect.left+imagelist2.width+2,rect.top+1,TntComboBox3.items[index]);

if odfocused in state then  //DISABLE FOCUS DOTTED
  TntComboBox3.canvas.DrawFocusRect(rect);

end;

procedure TFsettings.TntComboBox4Change(Sender: TObject);
begin
if TntComboBox4.ItemIndex=0 then
  TrackBar3.Enabled:=false
else
  TrackBar3.Enabled:=true;
end;

procedure TFsettings.TntComboBox4DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
TntComboBox4.canvas.fillrect(rect);

imagelist2.Draw(TntComboBox4.Canvas,rect.left,rect.top,index);//Get index
WideCanvasTextOut(TntComboBox4.canvas,rect.left+imagelist2.width+2,rect.top+1,TntComboBox4.items[index]);

if odfocused in state then  //DISABLE FOCUS DOTTED
  TntComboBox4.canvas.DrawFocusRect(rect);
end;

procedure TFsettings.CheckBox3Click(Sender: TObject);
begin
if CheckBox3.Checked then
  if TntComboBox1.Items.Count>0 then
    mymessagewarning(traduction(586));
end;

procedure TFsettings.TntButton1Click(Sender: TObject);
begin
TntButton1.enabled:=false;
setlinkedconnections;
mymessageinfo(traduction(595));
end;

procedure TFsettings.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
