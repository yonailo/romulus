unit Ulog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, strings, Buttons, ExtCtrls,Mymessages,
  Menus, DB, StdCtrls, GR32_Image,CommCtrl,Tntforms, TntExtCtrls,
  TntButtons, TntStdCtrls, TntMenus, TntSysutils, TntComCtrls, Gptextfile, TntClasses,
  VirtualTrees ;

type
  TFlog = class(Ttntform)
    ImageList1: TImageList;
    ImageList2: TImageList;
    Panel1: TTntPanel;
    Bevel3: TBevel;
    Panel2: TTntPanel;
    Bevel1: TBevel;
    Panel9: TTntPanel;
    Panel3: TTntPanel;
    Panel4: TTntPanel;
    Panel18: TTntPanel;
    Panel5: TTntPanel;
    Panel6: TTntPanel;
    Panel7: TTntPanel;
    SpeedButton3: TTntSpeedButton;
    Bevel2: TBevel;
    SpeedButton2: TTntSpeedButton;
    SpeedButton1: TTntSpeedButton;
    Bevel4: TBevel;
    PopupMenu1: TPopupMenu;
    Gotofirst1: TMenuItem;
    Gotolast1: TMenuItem;
    N1: TMenuItem;
    Viewfile1: TMenuItem;
    File11: TMenuItem;
    File21: TMenuItem;
    Label1: TTntLabel;
    Label2: TTntLabel;
    Image3212: TImage32;
    Image321: TImage32;
    Image322: TImage32;
    SpeedButton4: TTntSpeedButton;
    VirtualStringTree1: TVirtualStringTree;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Gotofirst1Click(Sender: TObject);
    procedure Gotolast1Click(Sender: TObject);
    procedure roms(Sender: TObject);
    procedure File11Click(Sender: TObject);
    procedure File21Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TntFormHide(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure initializelog;
  end;

var
  Flog: TFlog;
  logcorrection: int64;
  flogtothemax:boolean;
  imageindexlist:TStringList;
  stateindexlist:Tstringlist;
  column0list:TTntStringList;
  column1list:TTntStringList;
  column2list:TTntStringList;
  oldlogleft,oldlogtop:integer;
  
implementation

uses Uscan, Umain, Uofflineupdate, Udirmaker, UData, GPHugeF;

{$R *.dfm}

procedure checkforlogstatusbuttons;
var
save:boolean;
begin
save:=true;

if formexists('Fscan') then
  Fscan.SpeedButton3.Down:=false
else
if formexists('Fofflineupdate') then
  Fofflineupdate.SpeedButton3.Down:=false
else
if formexists('Fdirmaker') then
  Fdirmaker.SpeedButton2.Down:=false
else
  save:=false;

if save=true then begin

  flogtothemax:=false;

  if Flog.WindowState=wsmaximized then begin
    flogtothemax:=true;
    Flog.WindowState:=wsNormal;
  end;

  oldlogleft:=Flog.Left;
  oldlogtop:=Flog.top;
end;

end;

procedure TFlog.initializelog;
begin
VirtualStringTree1.BeginUpdate;
VirtualStringTree1.RootNodeCount:=0;
VirtualStringTree1.header.Columns[0].Width:=175;
VirtualStringTree1.header.Columns[1].Width:=175;
VirtualStringTree1.header.Columns[2].Width:=175;
VirtualStringTree1.EndUpdate;
Panel18.Caption:='0000';
Panel5.Caption:='0000';
Panel6.Caption:='0000';

imageindexlist.Clear;
stateindexlist.Clear;
column0list.Clear;
column1list.clear;
column2list.clear;
end;

function extractpathfromline(line:widestring):widestring;
var
aux,res:widestring;
const
s1=':\';
s2='\\';
begin

try
  aux:=gettoken(line,s1,gettokencount(line,s1));
  res:=gettoken(line,s1,gettokencount(line,s1)-1);
  res:=res[length(res)]+s1+aux;
  res:=gettoken(res,' > ',1);

except
end;

if (not fileexists2(res) AND not WideDirectoryExists(res)) then
  if gettokencount(line,s2)>1 then begin
    aux:=gettoken(line,s2,gettokencount(line,s2));
    res:=s2+aux;
  end;

if (not fileexists2(res) AND not WideDirectoryExists(res)) then
  res:='';

Result:=res;
end;

procedure TFlog.SpeedButton1Click(Sender: TObject);
begin
if VirtualStringTree1.RootNodeCount>0 then
  initializelog;
end;

procedure TFlog.FormShow(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);

Fmain.setgridlines(VirtualStringTree1,ingridlines);

caption:=traduction(177);
speedbutton1.hint:=traduction(201);
speedbutton2.hint:=traduction(202);
speedbutton3.hint:=traduction(284);
speedbutton4.hint:=traduction(514);
Gotofirst1.Caption:=UTF8Encode(traduction(358));
Gotolast1.Caption:=UTF8Encode(traduction(359));
Viewfile1.Caption:=UTF8Encode(traduction(360));

VirtualStringTree1.header.columns[0].text:=traduction(61);
VirtualStringTree1.header.columns[1].text:=traduction(497)+' #1';
VirtualStringTree1.header.columns[2].text:=traduction(497)+' #2';

//Position of window
if (oldlogleft>screen.DesktopRect.Right) OR (oldlogtop>screen.DesktopRect.Bottom) OR (oldlogleft-Flog.Width<screen.DesktopRect.left-Flog.Width-Flog.Width) OR (oldlogtop-Flog.Height<screen.DesktopRect.Top-Flog.Height-Flog.Height) then begin
  oldlogleft:=-1;
  oldlogtop:=-1;
end;

if (oldlogleft=-1) AND (oldlogtop=-1) then begin //INITALIZE POSITION
  oldlogleft:=Screen.ActiveForm.Monitor.BoundsRect.right-80-Flog.Width;
  oldlogtop:=Screen.ActiveForm.Monitor.BoundsRect.top+80;
end;

Flog.left:=oldlogleft;
Flog.top:=oldlogtop;

SpeedButton4Click(sender);
end;

procedure TFlog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFlog.FormCreate(Sender: TObject);
begin
Flog.AlphaBlendValue:=0;//FIX FLASHING
imageindexlist:=TStringList.create;
stateindexlist:=Tstringlist.Create;
column0list:=TTntStringList.Create;
column1list:=TTntStringList.create;
column2list:=TTntStringList.create;
Fmain.fixcomponentsbugs(Flog);
//virtualstringtree1.Header.Options:=virtualstringtree1.Header.options-[hoHotTrack];
initializelog;
end;

procedure TFlog.SpeedButton2Click(Sender: TObject);
var
x:integer;
f:textfile;
pre:string;
tdir:ansistring;
begin
tdir:=tempdirectoryresources+'export.rmt';

if VirtualStringTree1.RootNodeCount>0 then begin

  Fmain.Savedialog1.title:=traduction(312);
  Fmain.Savedialog1.Filter:=traduction(207)+' '+'(*.txt)|*.txt';
  Fmain.savedialog1.FileName:='log.txt';
  Fmain.SaveDialog1.InitialDir:=folderdialoginitialdircheck(initialdirlog);

  try
    Fmain.positiondialogstart;

    if Fmain.savedialog1.Execute then begin
      if fileexists2(Fmain.SaveDialog1.FileName) then
        if mymessagequestion(traduction(216)+#10#13+Fmain.savedialog1.filename,false)<>1 then
          exit;

      initialdirlog:=wideextractfilepath(Fmain.SaveDialog1.FileName);

      assignfile(f,tdir);
      rewrite(f,tdir);

      for x:=0 to VirtualStringTree1.RootNodeCount-1 do begin

        pre:='';
        if imageindexlist.Strings[x]<>'-1' then begin
          pre:='    ';
          case strtoint(stateindexlist.Strings[x]) of
            0:pre:=pre+'[INFO]'+' ';
            1:pre:=pre+'[OK]'+' ';
            2:pre:=pre+'[WARNING]'+' ';
            3:pre:=pre+'[ERROR]'+' ';
          end;
        end;

        Writeln(f,pre+UTF8Encode(column0list.Strings[x])+'   '+UTF8Encode(column1list.strings[x])+'   '+UTF8Encode(column2list.strings[x]));
      end;

      closefile(f);

      movefile2(tdir,Fmain.savedialog1.FileName);//0.027 fix

      if FileExists2(Fmain.SaveDialog1.filename)=false then
        makeexception;

      mymessageinfo(traduction(313)+' : '+Fmain.savedialog1.FileName);
    end;

  except
    try
      closefile(f);
    except
    end;

    mymessageerror(traduction(150)+#10#13+Fmain.Savedialog1.filename);
  end;

end;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFlog.Gotofirst1Click(Sender: TObject);
begin
posintoindexbynode(VirtualStringTree1.getfirst,VirtualStringTree1);
end;

procedure TFlog.Gotolast1Click(Sender: TObject);
begin
posintoindexbynode(VirtualStringTree1.getlast,VirtualStringTree1);
end;

procedure TFlog.roms(Sender: TObject);
var
aux:widestring;
begin
Fmain.destroycustomhint;
File11.Visible:=false;
File21.visible:=false;
File11.Caption:='';
File21.caption:='';
Viewfile1.Visible:=False;

if VirtualStringTree1.SelectedCount=0 then
  exit;


//POSSIBLE 1
aux:=extractpathfromline(column1list.Strings[VirtualStringTree1.FocusedNode.Index]);

if (FileExists2(aux) OR WideDirectoryExists(aux)) then begin
  File11.Caption:=UTF8Encode(changein(aux,'&','&&'));
  File11.Visible:=true;
  Viewfile1.Visible:=true;
end;

//POSSIBLE 2
aux:=extractpathfromline(column2list.Strings[VirtualStringTree1.FocusedNode.Index]);

if (FileExists2(aux) OR WideDirectoryExists(aux)) then begin
  File21.Caption:=UTF8Encode(changein(aux,'&','&&'));
  File21.Visible:=true;
  Viewfile1.Visible:=true;
end;

end;

procedure TFlog.File11Click(Sender: TObject);
var
aux,ud:widestring;
begin
try

aux:=File11.caption;
aux:=UTF8Decode(aux);
aux:=changein(aux,'&&','&');
aux:=trim(aux);

if gettokencount(aux,':\')>1 then begin
  ud:=gettoken(aux,':\',1);
  ud:=ud[length(ud)];
  aux:=gettoken(aux,':\',2);
  aux:=ud+':\'+aux;
end
else begin
  aux:=gettoken(aux,'\\',2);
  aux:='\\'+aux;
end;

Fmain.openandselectinbrowser(aux);

except
end;

end;

procedure TFlog.File21Click(Sender: TObject);
var
aux,ud:widestring;
begin
try

aux:=File21.caption;
aux:=UTF8Decode(aux);

aux:=changein(aux,'&&','&');
aux:=trim(aux);
if gettokencount(aux,':\')>1 then begin
  ud:=gettoken(aux,':\',1);
  ud:=ud[length(ud)];
  aux:=gettoken(aux,':\',2);
  aux:=ud+':\'+aux;
end
else begin
  aux:=gettoken(aux,'\\',2);
  aux:='\\'+aux;
end;

Fmain.openandselectinbrowser(aux);

except
end;

end;

procedure TFlog.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);

if flogtothemax=true then
  flog.WindowState:=wsMaximized;

flogtothemax:=false;
end;

procedure TFlog.SpeedButton4Click(Sender: TObject);
var
x:integer;
begin
if speedbutton4.Down then begin
  for x:=0 to VirtualStringTree1.header.Columns.Count-1 do
    if VirtualStringTree1.header.Columns[x].Tag>=50 then
      VirtualStringTree1.header.Columns[x].Width:=VirtualStringTree1.header.Columns[x].Tag;

  VirtualStringTree1.header.options:=VirtualStringTree1.header.options-[hocolumnresize];
end
else
  VirtualStringTree1.header.options:=VirtualStringTree1.header.options+[hocolumnresize];

end;

procedure TFlog.TntFormDestroy(Sender: TObject);
begin
imageindexlist.Free;
stateindexlist.Free;
column0list.Free;
column1list.Free;
column2list.Free;
end;

procedure TFlog.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin

case column of
  0:celltext:=column0list.Strings[node.index];
  1:celltext:=column1list.Strings[node.index];
  2:celltext:=column2list.Strings[node.index];
end;

end;

procedure TFlog.VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin

if column=0 then begin

  if Kind=ikState then begin
    ImageIndex:=StrToInt(stateindexlist.Strings[node.index])
  end
  else
  if kind<>ikOverlay then
    ImageIndex:=StrToInt(imageindexlist.Strings[node.index]);

end;

end;

procedure TFlog.TntFormHide(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFlog.TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
checkforlogstatusbuttons;
end;

procedure TFlog.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;

end;

end.
