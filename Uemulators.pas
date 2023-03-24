unit Uemulators;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, strings, ImgList, Shellapi, Mymessages,
  Menus, GR32_Image, FileExtAssociate, Tntforms, TntExtCtrls, TntButtons,
  TntStdCtrls, TntComCtrls, TntSysutils, VirtualTrees, TntDialogs;

type
  TFemulators = class(Ttntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Edit1: TTntEdit;
    Bevel3: TBevel;
    Label2: TTntLabel;
    SpeedButton1: TTntSpeedButton;
    SpeedButton2: TTntSpeedButton;
    SpeedButton3: TTntSpeedButton;
    SpeedButton4: TTntSpeedButton;
    CheckBox1: TTntCheckBox;
    Panel3: TTntPanel;
    Edit2: TTntEdit;
    Label3: TTntLabel;
    Label4: TTntLabel;
    Edit3: TTntEdit;
    Edit4: TTntEdit;
    Label5: TTntLabel;
    ImageList1: TImageList;
    Label6: TTntLabel;
    Bevel4: TBevel;
    BitBtn1: TTntBitBtn;
    Label7: TTntLabel;
    Label8: TTntLabel;
    SpeedButton5: TTntSpeedButton;
    SpeedButton6: TTntSpeedButton;
    SpeedButton7: TTntSpeedButton;
    SpeedButton8: TTntSpeedButton;
    SpeedButton9: TTntSpeedButton;
    ImageList2: TImageList;
    SpeedButton10: TTntSpeedButton;
    SpeedButton11: TTntSpeedButton;
    Bevel5: TBevel;
    Image321: TImage32;
    Image3210: TImage32;
    VirtualStringTree1: TVirtualStringTree;
    TntOpenDialog1: TTntOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree1HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FFocusControl: TControl;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
  public
    { Public declarations }
    procedure OnEnter(Sender: TObject);
    procedure OnExit(Sender: TObject);
    procedure setmodeas(m:integer);
    procedure setlistemulators;
    procedure buttonclick(sender : Tobject);
  end;

var
  Femulators: TFemulators;
  Descending: Boolean;
  SortedColumn: Integer;

implementation

uses Umain, UData, Math;

{$R *.dfm}

procedure Tfemulators.buttonclick(sender : Tobject);
var
s,e:widestring;
begin
try
s:=copy(edit2.Text,1,Edit2.SelStart)
except
end;

try
e:=copy(edit2.text,Edit2.SelStart+1+edit2.SelLength,length(edit2.text));
except
end;

edit2.text:=s+(sender as TTntspeedbutton).Caption+e;
stablishfocus(edit2);
edit2.SelStart:=length(s)+2;
end;

procedure Tfemulators.setlistemulators;
var
x:integer;
Icon: TIcon;
filter:word;
aux:string;
begin
//INITIALIZE
filter:=0;
Descending:=false;
SortedColumn:=0;
{
  0:celltext:=getwiderecord(Datamodule1.Qemulators.fieldbyname('Description'));
  1:celltext:=getwiderecord(Datamodule1.Qemulators.fieldbyname('Path'));
  2:celltext:=getwiderecord(Datamodule1.Qemulators.fieldbyname('Param'));
  3:if Datamodule1.Qemulators.fieldbyname('DOS').AsBoolean=true then
}

Datamodule1.Qemulators.Close;
Datamodule1.Qemulators.SQL.Clear;
Datamodule1.Qemulators.SQL.Add('SELECT * FROM Emulators WHERE Profile = '+''''+inttostr(strtoint(Fmain.getcurrentprofileid))+'''');

for x:=0 to virtualstringtree1.Header.Columns.Count-1 do
  if virtualstringtree1.Header.Columns[x].Tag<>0 then begin
    if aux<>'' then
      aux:='';

    case x of 0:aux:='Description';
              1:aux:='Path';
              2:aux:='Param';
              3:aux:='DOS';
    end;

    if virtualstringtree1.Header.Columns[x].Tag=1 then
      aux:=aux+' ASC'
    else
      aux:=aux+' DESC';

    Datamodule1.Qemulators.sql.add('ORDER BY '+aux);
  end;

Datamodule1.Qemulators.Open;

ImageList1.Clear;

for x:=0 to Datamodule1.Qemulators.RecordCount-1 do begin

  Icon := TIcon.Create;

  try

    if not fileexists2(getwiderecord(Datamodule1.Qemulators.fieldbyname('Path'))) then
      makeexception;

    icon.Handle:=ExtractAssociatedIconw(
    hInstance,
    Pwidechar(getwiderecord(Datamodule1.Qemulators.fieldbyname('Path'))),
    Filter);

    imagelist1.AddIcon(icon);

  except
    imagelist2.GetIcon(1,icon);
    imagelist1.AddIcon(icon);
  end;

  Icon.Free;

  Datamodule1.Qemulators.Next;
end;

VirtualStringTree1.RootNodeCount:=Datamodule1.Qemulators.RecordCount;
end;

procedure TFemulators.ApplicationIdle(Sender: TObject; var Done: Boolean);
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

procedure TFemulators.OnEnter(Sender: TObject);
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
    case s of
     2:panel3.caption:=traduction(288);
     10:panel3.caption:=traduction(160);
     3:panel3.caption:=traduction(101);
     4:panel3.caption:=traduction(11);
    end;

  end;
  end;
end;

procedure TFemulators.OnExit(Sender: TObject);
begin
//OnExit code
If sender.classname='TTntSpeedButton' then begin
  if (sender as TTntspeedbutton).Tag=0 then
   panel3.caption:='';
end;
end;


procedure TFemulators.setmodeas(m:integer);
var
c:widestring;
begin
case m of
  0:c:=traduction(292);
  1:c:=traduction(293);
  2:c:=traduction(294);
end;

if label7.Caption<>c then
  label7.Caption:=c;

case m of
  0:begin
      edit3.ReadOnly:=true;
      edit3.Color:=clbtnface;
      speedbutton1.Enabled:=false;
      speedbutton2.Enabled:=false;
      speedbutton3.Enabled:=false;
      speedbutton4.Enabled:=false;
      speedbutton10.Enabled:=false;
      checkbox1.Enabled:=false;

      edit2.ReadOnly:=true;
      edit2.Color:=clbtnface;

      if VirtualStringTree1.RootNodeCount<=9 then
        speedbutton5.Enabled:=true
      else
        speedbutton5.Enabled:=false;

      if VirtualStringTree1.RootNodeCount=0 then begin
        speedbutton6.Enabled:=false;
        speedbutton7.Enabled:=false;
        speedbutton11.Enabled:=false;
      end
      else begin
        speedbutton6.Enabled:=true;
        speedbutton7.Enabled:=true;
        speedbutton11.Enabled:=true;
      end;

      speedbutton8.Enabled:=false;
      speedbutton9.Enabled:=false;

      VirtualStringTree1.Enabled:=true;

      try

      if VirtualStringTree1.SelectedCount>0 then begin
        Datamodule1.Qemulators.RecNo:=VirtualStringTree1.focusednode.index+1;

        edit3.Text:=getwiderecord(Datamodule1.Qemulators.FieldByName('Description'));
        edit1.Text:=getwiderecord(Datamodule1.Qemulators.FieldByName('Path'));
        edit2.Text:=getwiderecord(Datamodule1.Qemulators.FieldByName('Param'));

        if Datamodule1.Qemulators.FieldByName('DOS').asboolean=true then
          checkbox1.Checked:=true
        else
          checkbox1.Checked:=false;

        speedbutton8.tag:=Datamodule1.Qemulators.FieldByName('ID').asinteger;//ID

      end
      else begin
        edit1.Text:='';
        edit2.text:='';
        edit3.Text:='';
        checkbox1.Checked:=false;
      end;

      except
        edit1.Text:='';
        edit2.text:='';
        edit3.Text:='';
        checkbox1.Checked:=false;
      end;

    end
  else begin

    if m=1 then begin
      edit1.Text:='';
      edit2.text:='';
      edit3.Text:='';
      checkbox1.Checked:=false;

      stablishfocus(edit3);
    end;

    edit3.ReadOnly:=false;
    edit3.Color:=clwindow;
    speedbutton1.Enabled:=true;
    speedbutton2.Enabled:=true;
    speedbutton3.Enabled:=true;
    speedbutton4.Enabled:=true;
    speedbutton10.Enabled:=true;
    checkbox1.Enabled:=true;

    edit2.ReadOnly:=false;
    edit2.Color:=clwindow;

    speedbutton5.Enabled:=false;
    speedbutton6.Enabled:=false;
    speedbutton7.Enabled:=false;
    speedbutton11.Enabled:=false;

    speedbutton8.Enabled:=true;
    speedbutton9.Enabled:=true;

    VirtualStringTree1.Enabled:=false;

    stablishfocus(edit3);
  end;
end;


end;

procedure TFemulators.FormCreate(Sender: TObject);
var
x:integer;
begin
Fmain.fixcomponentsbugs(Femulators);
//virtualstringtree1.Header.Options:=virtualstringtree1.Header.options-[hoHotTrack];

for x:=0 to ComponentCount-1 do
  if components[x] is TTntspeedbutton then
    if  (components[x] as TTntspeedbutton).tag=0 then
      (components[x] as TTntspeedbutton).OnClick:=buttonclick;

FFocusControl := nil;
Application.OnIdle := ApplicationIdle;

virtualstringtree1.Header.SortColumn:=0;
virtualstringtree1.header.SortDirection:=sdAscending;

if colorcolumns=true then
  VirtualStringTree1.Header.Columns[0].Color:=clBtnFace;
end;

procedure TFemulators.FormShow(Sender: TObject);
const
s=' :';
begin
//INITIALIZE
Descending:=false;
SortedColumn:=0;

Fmain.addtoactiveform((sender as Tform),true);

Datamodule1.Temulators.Open;

Fmain.setgridlines(VirtualStringTree1,ingridlines);


label1.Caption:=traduction(290);
Fmain.labelshadow(label1,Femulators);
label2.Caption:=traduction(288)+s;
VirtualStringTree1.header.Columns[1].text:=traduction(288);

label3.Caption:=traduction(289)+s;
VirtualStringTree1.header.Columns[2].text:=traduction(289);

label4.Caption:=traduction(11)+s;
VirtualStringTree1.header.Columns[0].text:=traduction(11);

label5.Caption:=traduction(138)+s;
label6.Caption:=traduction(291)+s;
label8.Caption:=traduction(295);

speedbutton1.Hint:=traduction(163);
speedbutton5.Hint:=traduction(297);
speedbutton6.Hint:=traduction(298);
speedbutton7.Hint:=traduction(299);
speedbutton8.Hint:=traduction(301);
speedbutton9.Hint:=traduction(302);
speedbutton11.Hint:=traduction(304);

bitbtn1.Caption:=traduction(217);

Datamodule1.Tprofiles.Locate('ID',strtoint(Fmain.getcurrentprofileid),[]);
edit4.Text:=getwiderecord(Datamodule1.Tprofiles.Fieldbyname('Description'));
tntopendialog1.Title:=traduction(288);
tntopendialog1.Filter:=traduction(296)+' (*.exe)|*.exe';

ImageList1.BkColor:=clwindow;
imagelist2.BkColor:=clwindow;

setlistemulators;

posintoindexbynode(VirtualStringTree1.GetFirst,VirtualStringTree1);

setmodeas(0);

stablishfocus(bitbtn1);
end;

procedure TFemulators.SpeedButton1Click(Sender: TObject);
begin
tntopendialog1.FileName:='';
tntopendialog1.InitialDir:=folderdialoginitialdircheck(initialdiremulator);

Fmain.positiondialogstart;

if tntOpenDialog1.Execute then begin
  initialdiremulator:=WideExtractfilepath(tntopendialog1.filename);
  edit1.Text:=tntopendialog1.FileName;
end;

end;

procedure TFemulators.BitBtn1Click(Sender: TObject);
begin
close;
end;

procedure TFemulators.SpeedButton5Click(Sender: TObject);
begin
setmodeas(1);
end;

procedure TFemulators.SpeedButton6Click(Sender: TObject);
begin
setmodeas(2);
end;

procedure TFemulators.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);

Datamodule1.Temulators.Close;
Datamodule1.Qaux.Close;

FFocusControl := nil;
Application.OnIdle := nil;
end;

procedure TFemulators.SpeedButton9Click(Sender: TObject);
begin
setmodeas(0);
stablishfocus(Virtualstringtree1);
end;

procedure TFemulators.SpeedButton8Click(Sender: TObject);
var
pos:longint;
fav:boolean;
pr:longint;
begin
pr:=strtoint(Fmain.getcurrentprofileid);
fav:=false;
Edit3.Text:=Trim(edit3.text);
Edit2.Text:=Trim(edit2.text);
pos:=speedbutton8.Tag;

if (edit1.Text='') OR (edit2.Text='') OR (edit3.Text='') then begin
  mymessagewarning(traduction(303));
end
else begin
  If label7.caption=traduction(293) then begin//INSERT
    if Datamodule1.Temulators.Locate('Profile;Favorite',VarArrayOf([pr,true]),[])=false then
      fav:=true;
      
    Datamodule1.Temulators.Append;
  end
  else begin
    Datamodule1.Temulators.Locate('ID',speedbutton8.Tag,[]);
    Datamodule1.Temulators.edit;
  end;

  setwiderecord(Datamodule1.Temulators.fieldbyname('Description'),edit3.text);
  setwiderecord(Datamodule1.Temulators.fieldbyname('Path'),edit1.text);
  setwiderecord(Datamodule1.Temulators.fieldbyname('Param'),edit2.text);
  Datamodule1.Temulators.fieldbyname('Profile').asinteger:=strtoint(Fmain.getcurrentprofileid);
  Datamodule1.Temulators.fieldbyname('DOS').AsBoolean:=checkbox1.checked;

  If label7.caption=traduction(293) then //INSERT
    Datamodule1.Temulators.fieldbyname('Favorite').AsBoolean:=fav;
    
  Datamodule1.Temulators.Post;

  If label7.caption=traduction(293) then //INSERT
    pos:=Datamodule1.Temulators.fieldbyname('ID').asinteger;

  setmodeas(0);
  setlistemulators;

  Datamodule1.Qemulators.Locate('ID',pos,[]);

  stablishfocus(VirtualStringTree1);

  posintoindex(Datamodule1.Qemulators.RecNo-1,Virtualstringtree1);

end;

end;

procedure TFemulators.SpeedButton7Click(Sender: TObject);
var
pos:integer;
fav:boolean;
begin
if mymessagequestion(traduction(300),false)=0 then
  exit;

pos:=VirtualStringTree1.focusednode.index;
Datamodule1.Temulators.Locate('ID',speedbutton8.tag,[]);
fav:=Datamodule1.Temulators.fieldbyname('Favorite').asboolean;

Datamodule1.Temulators.delete;

pos:=pos-1;
if pos<0 then
  pos:=0;

if (fav=true) AND (Datamodule1.Temulators.IsEmpty=false) then begin
  Datamodule1.Temulators.First;
  Datamodule1.Temulators.edit;
  Datamodule1.Temulators.FieldByName('Favorite').asboolean:=fav;
  Datamodule1.Temulators.post;
end;

setlistemulators;
stablishfocus(virtualstringtree1);

posintoindex(pos,virtualstringtree1);

setmodeas(0);
end;

procedure TFemulators.SpeedButton11Click(Sender: TObject);
var
pr:longint;
ind:integer;
begin
ind:=VirtualStringTree1.FocusedNode.Index;
Datamodule1.Qemulators.RecNo:=ind+1;
pr:=strtoint(Fmain.getcurrentprofileid);
Datamodule1.Temulators.Locate('ID',Datamodule1.Qemulators.fieldbyname('ID').asinteger,[]);

if Datamodule1.Temulators.FieldByName('Favorite').AsBoolean=false then begin

  While Datamodule1.Temulators.Locate('Profile;Favorite',VarArrayOf([pr,true]),[])=true do begin
    Datamodule1.Temulators.edit;
    Datamodule1.Temulators.FieldByName('Favorite').asboolean:=false;
    Datamodule1.Temulators.post;
  end;

  Datamodule1.Temulators.Locate('ID',Datamodule1.Qemulators.fieldbyname('ID').asinteger,[]);
  Datamodule1.Temulators.edit;
  Datamodule1.Temulators.FieldByName('Favorite').asboolean:=true;
  Datamodule1.Temulators.post;

  setlistemulators;

  stablishfocus(VirtualStringTree1);
  posintoindex(ind,VirtualStringTree1);
end;

end;

procedure TFemulators.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFemulators.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
if Datamodule1.Qemulators.RecNo<>node.Index+1 then
  Datamodule1.Qemulators.RecNo:=node.Index+1;

if (VirtualStringTree1.Selected[node]=true) AND (edit3.ReadOnly=true) then
  setmodeas(0);

case column of
  0:celltext:=getwiderecord(Datamodule1.Qemulators.fieldbyname('Description'));
  1:celltext:=getwiderecord(Datamodule1.Qemulators.fieldbyname('Path'));
  2:celltext:=getwiderecord(Datamodule1.Qemulators.fieldbyname('Param'));
  3:if Datamodule1.Qemulators.fieldbyname('DOS').AsBoolean=true then
      celltext:='*'
    else
      celltext:='';
end;

end;

procedure TFemulators.VirtualStringTree1GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
if column=0 then begin
  if Datamodule1.Qemulators.RecNo<>node.Index+1 then //SPEEDUP
    Datamodule1.Qemulators.RecNo:=node.Index+1;

  if Kind=ikState then begin
    imageindex:=node.Index;
  end
  else
  if kind<>ikOverlay then begin
    if Datamodule1.Qemulators.fieldbyname('Favorite').asboolean=true then
      imageindex:=0
    else
      imageindex:=-1;
  end;

end;
end;

procedure TFemulators.VirtualStringTree1HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
var
x,id:integer;
begin
id:=hitinfo.Column;

if HitInfo.Button <> mbLeft then
  exit;

if id=-1 then
  exit;

//RARE BUT FIX A PROBLEM SELECTED COLUMN PRESSED
//SendMessage(VirtualStringTree1.Handle, WM_LBUTTONUP, 0, 0);

if VirtualStringTree1.Header.Columns[id].tag=0 then
  VirtualStringTree1.Header.Columns[id].tag:=1
else
if VirtualStringTree1.Header.Columns[id].tag=1 then
  VirtualStringTree1.Header.Columns[id].tag:=2
else
  VirtualStringTree1.Header.Columns[id].tag:=1;


for x:=0 to VirtualStringTree1.Header.Columns.Count-1 do
  if x<>id then begin
    VirtualStringTree1.Header.Columns[x].Tag:=0;
    VirtualStringTree1.Header.Columns[x].Color:=clWindow;
  end;

VirtualStringTree1.Header.SortColumn:=-1;

if colorcolumns=true then
  VirtualStringTree1.Header.Columns[id].Color:=clBtnFace;

if VirtualStringTree1.Header.Columns[id].tag=2 then
  VirtualStringTree1.Header.SortDirection:=sdDescending
else
  VirtualStringTree1.Header.SortDirection:=sdAscending;

VirtualStringTree1.Header.SortColumn:=id;

setlistemulators;
posintoindex(0,virtualstringtree1);
end;

procedure TFemulators.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
