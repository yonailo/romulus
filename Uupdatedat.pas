unit Uupdatedat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, strings, GR32_Image, Tntforms,
  TntExtCtrls, TntStdCtrls, TntButtons, TntComCtrls, Mymessages,
  VirtualTrees, DB;

type
  TFupdatedat = class(TTntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    Bitbtn3: TTntBitBtn;
    CheckBox1: TTntCheckBox;
    Label3: TTntLabel;
    Label10: TTntLabel;
    Label11: TTntLabel;
    Bevel3: TBevel;
    Edit2: TTntEdit;
    Edit9: TTntEdit;
    Bevel4: TBevel;
    Label2: TTntLabel;
    Bevel5: TBevel;
    Label4: TTntLabel;
    Edit1: TTntEdit;
    Label5: TTntLabel;
    Edit3: TTntEdit;
    CheckBox2: TTntCheckBox;
    Timer1: TTimer;
    Image321: TImage32;
    Image322: TImage32;
    Image323: TImage32;
    TntCheckBox1: TTntCheckBox;
    VirtualStringTree2: TVirtualStringTree;
    procedure ListView1Data(Sender: TObject; Item: TListItem);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Bitbtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure VirtualStringTree2HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure VirtualStringTree2DblClick(Sender: TObject);
    procedure VirtualStringTree2GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree2GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure reloadtab;
    procedure executequery(ispost,isreplace:boolean);
    procedure rewrite(str:widestring);
  end;

var
  Fupdatedat: TFupdatedat;
  processmessage : widestring;
  posmessage:longint;
  posmessage2:widestring;
  autodecision:integer;
  autodecisioncheck:boolean;

implementation

uses UData, Umain, Unewdat, Uprocessing, Ulog;

{$R *.dfm}

procedure Tfupdatedat.rewrite(str:widestring);
begin
//Find Fprocessing
if formexists('Fprocessing') then begin
  if str='' then
    timer1.enabled:=false
  else begin
    processmessage:=str;
    timer1.Enabled:=true;
  end;
end;

end;

procedure Tfupdatedat.reloadtab;
var
id:string;
begin

try
  Datamodule1.Tscansets.close;//CHANGED 0.013
  Datamodule1.Tscansets.TableName:='Y'+fillwithzeroes(inttostr(overwritedat),4);
  Datamodule1.Tscansets.open;

  id:=Fmain.getcurrentprofileid;

  (Fmain.FindComponent('CLONE_Panel37_'+fillwithzeroes(inttostr(overwritedat),4)) as TTntpanel).Tag:=Datamodule1.Tscansets.RecordCount;
  (Fmain.FindComponent('CLONE_Panel28_'+fillwithzeroes(inttostr(overwritedat),4)) as TTntpanel).caption:='0000';
  (Fmain.FindComponent('CLONE_Panel29_'+fillwithzeroes(inttostr(overwritedat),4)) as TTntpanel).caption:='0000';
  (Fmain.FindComponent('CLONE_Panel30_'+fillwithzeroes(inttostr(overwritedat),4)) as TTntpanel).Caption:=fillwithzeroes(inttostr(Datamodule1.Tscansets.RecordCount),4);

  //MUST UPDATE TAB ONLY
  LockWindowUpdate(Fmain.Handle);
  
  try //FIX SINZE 0.021 LOAD OVERWRITE DAT TO UPDATE SCANNER TAB BUT RETURNS TO OTHER WITHOUT FLICKING
    Fmain.showprolesmasterdetail(true,true,fillwithzeroes(inttostr(overwritedat),4),False,true);
    if Fmain.getcurrentprofileid<>(fillwithzeroes(inttostr(overwritedat),4)) then
      Fmain.showprolesmasterdetail(false,false,Fmain.getcurrentprofileid,true,true);
  except
  end;

  LockWindowUpdate(0);
except
end;

Datamodule1.Tscansets.close;
end;

procedure Tfupdatedat.executequery(ispost,isreplace:boolean);
begin

if (ispost=true) AND (isreplace=true) then begin //COMMIT DBCLONES
    Datamodule1.Qaux.Close;
    Datamodule1.Qaux.SQL.Clear;
    Datamodule1.Qaux.SQL.Add('POSTDBCLONES');
end
else begin
  if ispost then begin
    Datamodule1.Qaux.Close;
    Datamodule1.Qaux.SQL.Clear;
    Datamodule1.Qaux.SQL.Add('POST');
  end
  else
  if isreplace then
    try
    if formexists('Fprocessing') then
      Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(71)+' - '+traduction(254);
    except
    end;
end;

try
  Fmain.BMDThread1.Start();
  Fmain.waitforfinishthread;
except
end;


end;

procedure TFupdatedat.ListView1Data(Sender: TObject; Item: TListItem);
var
typ:string;
haveroms,havesets,totalroms,totalsets:ansistring;
shareint:integer;
begin
try
shareint:=0;

Datamodule1.Qaux.RecNo:=item.Index+1;

if Datamodule1.Qaux.FieldByName('Shared').asboolean=true then
  shareint:=4;

//Type of dat
typ:=Datamodule1.Qaux.FieldByName('Original').asstring;
item.ImageIndex:=getdattypeiconindexfromchar(typ);

haveroms:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Haveroms').asinteger);
havesets:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Havesets').asinteger);
totalroms:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Totalroms').asinteger);
totalsets:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Totalsets').asinteger);

//Status icons
if Datamodule1.Qaux.fieldbyname('Haveroms').asstring='' then begin
    item.StateIndex:=3+shareint;
    haveroms:=' - ';
    havesets:=' - ';
end
else
if Datamodule1.Qaux.fieldbyname('Haveroms').asstring='0' then begin
  item.StateIndex:=2+shareint;
  haveroms:='0';
  havesets:='0';
end
else
if haveroms=totalroms then
  item.StateIndex:=0+shareint
else
  item.StateIndex:=1+shareint;

(item as TTntListItem).Caption:=getwiderecord(Datamodule1.Qaux.fieldbyname('Description'));

//Complete columns
(item as TTntListItem).SubItems.Add(getwiderecord(Datamodule1.Qaux.fieldbyname('Version')));
item.SubItems.Add(havesets+' / '+totalsets);
item.SubItems.Add(haveroms+' / '+totalroms);

item.SubItems.Add(splitmergestring(Datamodule1.Qaux.fieldbyname('Filemode').AsInteger));

if Datamodule1.Qaux.fieldbyname('Shared').asboolean=true then
  item.SubItems.Add('X')
else
  item.SubItems.Add('');

item.SubItems.Add(Datamodule1.Qaux.fieldbyname('Added').asstring);
haveroms:=Datamodule1.Qaux.fieldbyname('Lastscan').asstring;

if Length(haveroms)<=12 then
  item.SubItems.Add('')
else
  item.subitems.add(haveroms);

(item as TTntListItem).SubItems.Add(getwiderecord(Datamodule1.Qaux.fieldbyname('Name')));
(item as TTntListItem).SubItems.Add(getwiderecord(Datamodule1.Qaux.fieldbyname('Path')));

except
end;

end;

procedure TFupdatedat.FormShow(Sender: TObject);
var
x:integer;
begin
autodecision:=-1;
autodecisioncheck:=true;
Fmain.addtoactiveform((sender as Tform),true);
  
BitBtn1.Caption:=traduction(218);
bitbtn2.Caption:=traduction(81);
bitbtn3.Caption:=traduction(222);
caption:=traduction(220);
Label1.Caption:=traduction(221);
Fmain.labelshadow(label1,Fupdatedat);

label3.Caption:=traduction(94)+' :';
label10.Caption:=traduction(22)+' :';

label4.Caption:=traduction(11)+' :';
label5.Caption:=traduction(12)+' :';

label11.Caption:=traduction(93)+' ';
label2.Caption:=traduction(223)+' ';
CheckBox1.Caption:=traduction(224);
CheckBox2.Caption:=traduction(237);
TntCheckBox1.Caption:=traduction(572);
Flog.Label1.Caption:=changein(traduction(572),'&','&&');
Tntcheckbox1.Width:=Flog.Label1.Width+20;
tntcheckbox1.Left:=Fupdatedat.Width-TntCheckBox1.Width-25;

//Size,translation,etc autocopy
VirtualStringTree2.Header.Columns:=Fmain.virtualstringtree2.header.columns;

for x:=0 to VirtualStringTree2.Header.Columns.Count-1 do
  VirtualStringTree2.Header.Columns[x].Tag:=0;

VirtualStringTree2.header.Columns[0].Tag:=1;
Virtualstringtree2.Header.SortColumn:=0;
Virtualstringtree2.Header.SortDirection:=sdAscending;


if checkbox2.Visible=false then
  checkbox1.Top:=392;

Fmain.setgridlines(VirtualStringTree2,ingridlines);

posintoindexbynode(VirtualStringTree2.getfirst,VirtualStringTree2);

end;

procedure TFupdatedat.BitBtn2Click(Sender: TObject);
begin
close;
end;

procedure TFupdatedat.Bitbtn3Click(Sender: TObject);
begin
if TntCheckBox1.Checked then
  if mymessagequestion(traduction(573)+#13#10+traduction(575),false)=0 then
    exit;

overwritedat:=0;

if TntCheckBox1.Checked then begin
  autodecision:=1;
  autodecisioncheck:=checkbox1.checked;
end;

close;
end;

procedure TFupdatedat.BitBtn1Click(Sender: TObject);
begin
if VirtualStringTree2.SelectedCount<>0 then begin

  if TntCheckBox1.Checked then
    if mymessagequestion(traduction(573)+#13#10+traduction(574),false)=0 then
      exit;

  Datamodule1.Qaux.RecNo:=VirtualStringTree2.FocusedNode.Index+1;
  overwritedat:=Datamodule1.Qaux.fieldbyname('ID').asinteger;
  
  if (checkbox2.Checked=true) AND (checkbox2.Visible=true) then begin
    Fnewdat.Edit10.Text:=getwiderecord(Datamodule1.Qaux.fieldbyname('Date'));
    Fnewdat.Tntedit1.Text:=getwiderecord(Datamodule1.Qaux.fieldbyname('Descmask'));
  end;

  if TntCheckBox1.Checked then begin
    autodecision:=2;
    autodecisioncheck:=checkbox1.checked;
  end;
    
  close;
end;
end;

procedure TFupdatedat.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fupdatedat);
end;

procedure TFupdatedat.Timer1Timer(Sender: TObject);
begin
timer1.enabled:=false;

if posmessage<>0 then
  Fprocessing.panel3.Caption:=processmessage+inttostr(posmessage)+posmessage2
else
  Fprocessing.panel3.Caption:=processmessage;

timer1.enabled:=true;
end;

procedure TFupdatedat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
if TntCheckBox1.Checked then
  if overwritedat=-1 then
    autodecision:=0;
end;

procedure TFupdatedat.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFupdatedat.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
if TntCheckBox1.Checked then
  if autodecision=-1 then
    if mymessagequestion(traduction(573)+#13#10+traduction(576),false)=0 then
      canclose:=False;
end;

procedure TFupdatedat.VirtualStringTree2HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
if HitInfo.Button <> mbLeft then
  exit;

if HitInfo.Column=-1 then
  exit;

//RARE BUT FIX A PROBLEM SELECTED COLUMN PRESSED
//SendMessage(virtualstringtree2.Handle, WM_LBUTTONUP, 0, 0);
  
Fmain.sortcolumn(VirtualStringTree2,HitInfo.Column);

if virtualstringtree2.RootNodeCount>1 then begin//0.034

  VirtualStringTree2.rootnodeCount:=0;
  VirtualStringTree2.Repaint;

  DataModule1.Qaux.Close;
  Datamodule1.Qaux.SQL.Clear;
  Datamodule1.Qaux.SQL.add('SELECT * FROM Profiles,Tree');
  Datamodule1.Qaux.SQL.add('WHERE Tree.id=Profiles.tree');           //FIX LOCATION WHEN APOSTROPHES
  //Datamodule1.Qaux.SQL.add('AND UPPER(Name) LIKE UPPER('+''''+changein(Datamodule1.Tprofiles.fieldbyname('Name').asstring,'''','''''')+''''+')');
  Datamodule1.Qaux.SQL.add('AND UPPER(Profiles.Name) = UPPER('+':p_'+')'); //0.035 NEW
  Datamodule1.Qaux.SQL.add(Fmain.sqlsortcolumn(VirtualStringTree2));

  //0.035 NEW
  Datamodule1.Qaux.Params.Clear;
  Datamodule1.Qaux.Params.CreateParam(ftWideString,'p_',ptResult);
  Datamodule1.Qaux.Params[0].DataType := ftWideString;
  Datamodule1.Qaux.Params[0].Value:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Name'));

  Datamodule1.Qaux.Open;

  VirtualStringTree2.rootnodecount:=0;//FIX INDETERMINATED
  VirtualStringTree2.rootnodecount:=Datamodule1.Qaux.RecordCount;
  VirtualStringTree2.Repaint;

  posintoindexbynode(VirtualStringTree2.getfirst,VirtualStringTree2);
end;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFupdatedat.VirtualStringTree2DblClick(Sender: TObject);
begin
BitBtn1Click(sender);
end;

procedure TFupdatedat.VirtualStringTree2GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
haveroms,havesets,totalroms,totalsets:ansistring;
begin

Datamodule1.Qaux.recno:=node.Index+1;

case column of
  0:celltext:=getwiderecord(Datamodule1.Qaux.fieldbyname('Description'));
  1:celltext:=getwiderecord(Datamodule1.Qaux.fieldbyname('Version'));
  2..3:begin
        haveroms:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Haveroms').asinteger);
        havesets:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Havesets').asinteger);
        totalroms:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Totalroms').asinteger);
        totalsets:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Totalsets').asinteger);

        if Datamodule1.Qaux.fieldbyname('Haveroms').asstring='' then begin
          havesets:=' - ';
          haveroms:=' - ';
        end;

        if column=2 then
          celltext:=havesets+' / '+totalsets
        else
          celltext:=haveroms+' / '+totalroms;
      end;
  4:celltext:=splitmergestring(Datamodule1.Qaux.fieldbyname('Filemode').AsInteger);
  5:begin
      if Datamodule1.Qaux.fieldbyname('Shared').asboolean=true then
        celltext:='X'
      else
        celltext:='';
    end;
  6:celltext:=Datamodule1.Qaux.fieldbyname('Added').asstring;
  7:begin
      haveroms:=Datamodule1.Qaux.fieldbyname('Lastscan').asstring;
      if Length(haveroms)<=12 then
        celltext:=''
      else
        celltext:=haveroms;
  end;
  8:celltext:=getwiderecord(Datamodule1.Qaux.fieldbyname('Name'));
  9:celltext:=getwiderecord(Datamodule1.Qaux.fieldbyname('Path'));
end;


end;

procedure TFupdatedat.VirtualStringTree2GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
shareint:integer;
haveroms,havesets,totalroms,totalsets:ansistring;
begin

if column=0 then begin

  Datamodule1.Qaux.recno:=node.Index+1;

  if Kind=ikState then begin

    shareint:=0;

    haveroms:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Haveroms').asinteger);
    havesets:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Havesets').asinteger);
    totalroms:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Totalroms').asinteger);
    totalsets:=pointdelimiters(Datamodule1.Qaux.fieldbyname('Totalsets').asinteger);

    if Datamodule1.Qaux.fieldbyname('Shared').asboolean=true then
      shareint:=4;

    if Datamodule1.Qaux.fieldbyname('Haveroms').asstring='' then begin
      ImageIndex:=3+shareint;
      haveroms:=' - ';
      havesets:=' - ';
    end
    else
    if Datamodule1.Qaux.fieldbyname('Haveroms').asstring='0' then begin
      ImageIndex:=2+shareint;
      haveroms:='0';
      havesets:='0';
    end
    else
    if haveroms=totalroms then
      ImageIndex:=0+shareint//0
    else
      ImageIndex:=1+shareint;

  end
  else
  if kind<>ikOverlay then begin //OK
    ImageIndex:=getdattypeiconindexfromchar(Datamodule1.Qaux.fieldbyname('Original').asstring);
  end;

end;

end;

procedure TFupdatedat.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
