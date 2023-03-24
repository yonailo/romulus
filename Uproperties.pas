unit Uproperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons ,ComCtrls ,strings, Absmain, mymessages,importation,
  GR32_Image, Tntforms, TntExtCtrls, TntButtons, TntStdCtrls, Tntsysutils, Tntclasses, VirtualTrees;

type
  TFproperties = class(TTntform)
    Label3: TTntLabel;
    Label10: TTntLabel;
    Label2: TTntLabel;
    Label4: TTntLabel;
    Label5: TTntLabel;
    Label11: TTntLabel;
    Bevel3: TBevel;
    Edit9: TTntEdit;
    Edit1: TTntEdit;
    Edit3: TTntEdit;
    Edit4: TTntEdit;
    Label6: TTntLabel;
    Label8: TTntLabel;
    Label9: TTntLabel;
    Label7: TTntLabel;
    Bevel4: TBevel;
    Edit5: TTntEdit;
    Edit7: TTntEdit;
    Edit8: TTntEdit;
    Edit6: TTntEdit;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    Label12: TTntLabel;
    ComboBox1: TTntComboBox;
    Panel2: TTntPanel;
    Panel3: TTntPanel;
    Label13: TTntLabel;
    Label14: TTntLabel;
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SpeedButton1: TTntSpeedButton;
    SpeedButton2: TTntSpeedButton;
    SpeedButton3: TTntSpeedButton;
    Image321: TImage32;
    Image3210: TImage32;
    Panel4: TTntPanel;
    SpeedButton4: TTntSpeedButton;
    SpeedButton5: TTntSpeedButton;
    SpeedButton6: TTntSpeedButton;
    SpeedButton7: TTntSpeedButton;
    SpeedButton8: TTntSpeedButton;
    SpeedButton9: TTntSpeedButton;
    SpeedButton10: TTntSpeedButton;
    SpeedButton11: TTntSpeedButton;
    SpeedButton12: TTntSpeedButton;
    SpeedButton13: TTntSpeedButton;
    SpeedButton14: TTntSpeedButton;
    TntSpeedButton1: TTntSpeedButton;
    TntSpeedButton2: TTntSpeedButton;
    TntSpeedButton3: TTntSpeedButton;
    Panel5: TTntPanel;
    Edit10: TTntEdit;
    TntEdit1: TTntEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure Edit10KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure TntSpeedButton1Click(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntSpeedButton3Click(Sender: TObject);
    procedure TntSpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    lastfocus: longint;
    FFocusControl: TControl;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);

    procedure showinfoprofile(id:longint);
    procedure trimall;
  public
    { Public declarations }
    procedure OnEnter(Sender: TObject);
    procedure OnExit(Sender: TObject);
    procedure buttonclick(sender : Tobject);
  end;

var
  Fproperties: TFproperties;


implementation

uses Umain, UData, Uprocessing;

{$R *.dfm}
procedure Tfproperties.buttonclick(sender : Tobject);
var
s,e:widestring;
ed:Ttntedit;
begin
if edit10.visible=true then
  ed:=edit10
else
  ed:=TntEdit1;

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

procedure Tfproperties.ApplicationIdle(Sender: TObject; var Done: Boolean);
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

procedure Tfproperties.OnEnter(Sender: TObject);
var
s:shortint;
begin
//OnEnter code

If sender.classname='TTntSpeedButton' then begin
  if (((sender as TTntspeedbutton).Tag=0) AND ((sender as TTntspeedbutton).width=25)) then begin
    try
      strtoint((sender as TTntspeedbutton).Name[13]);
      s:=strtoint((sender as TTntspeedbutton).Name[12]+(sender as TTntspeedbutton).Name[13]);
    except
      s:=strtoint((sender as TTntspeedbutton).Name[12]);
    end;
    panel5.caption:=traduction(s+221);
  end;
  end;
end;

procedure Tfproperties.OnExit(Sender: TObject);
begin
//OnExit code
If sender.classname='TTntSpeedButton' then begin
   panel5.caption:='';
end;
end;


procedure Tfproperties.trimall;
begin
edit1.Text:=Trim(edit1.Text);
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

procedure TFproperties.showinfoprofile(id:longint);
var
x,y:longint;
pass:boolean;
isprofiles:boolean;
bmp:Tbitmap;
n:PVirtualNode;
begin
pass:=false;
x:=id;
isprofiles:=false;
if Fproperties.Tag=0 then
  isprofiles:=true;

//POS IN CORRECT INDEX
y:=0;
n:=Fmain.VirtualStringTree2.GetFirst;
if x<>-1 then
  while x<>y do begin
    n:=Fmain.VirtualStringTree2.GetNext(n);
    y:=y+1;
  end;

//For profiles
if isprofiles=true then begin
  while (x>=-1) AND (x<>Fmain.VirtualStringTree2.RootNodeCount) do begin

    if Fmain.VirtualStringTree2.Selected[n]=true then begin
      lastfocus:=x;
      pass:=true;
      break;
    end;

    if speedbutton1.Tag=0 then begin
      x:=x+1;
      n:=Fmain.VirtualStringTree2.GetNext(n);
    end
    else begin
      x:=x-1;
      n:=Fmain.VirtualStringTree2.GetPrevious(n);
    end;

  end;
end
else
  pass:=true;


if pass=true then begin
  if speedbutton1.Tag=0 then
    speedbutton2.tag:=speedbutton2.tag+1
  else
    speedbutton2.tag:=speedbutton2.tag-1;

  //Max
  if isprofiles=true then begin
    if speedbutton2.tag=Fmain.VirtualStringTree2.SelectedCount then
      speedbutton1.Enabled:=false
    else
      speedbutton1.Enabled:=true;
  end
  else begin
    if speedbutton2.Tag=Fmain.PageControl2.PageCount-1 then
      speedbutton1.Enabled:=false
    else
      speedbutton1.Enabled:=true;
  end;

  //Min
  if speedbutton2.Tag=1 then
    speedbutton2.Enabled:=false
  else
    speedbutton2.Enabled:=true;

  if isprofiles then begin
    label14.Caption:=inttostr(speedbutton2.tag)+' / '+inttostr(Fmain.VirtualStringTree2.SelectedCount);
    Datamodule1.Tprofilesview.Locate('CONT',lastfocus+1,[]);
    Datamodule1.Tprofiles.Locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
  end
  else begin
    //POSITION TO TAB
    Fmain.pagecontrol2.activepageindex:=speedbutton2.tag;
    Fmain.showprolesmasterdetail(false,false,Fmain.getcurrentprofileid,true,true);

    label14.Caption:=inttostr(speedbutton2.tag)+' / '+inttostr(Fmain.PageControl2.PageCount-1);
    Datamodule1.Tprofiles.Locate('ID',gettoken(Fmain.PageControl2.pages[speedbutton2.tag].Name,'_',3),[]);
  end;

  panel2.Caption:=pointdelimiters(Datamodule1.Tprofiles.fieldbyname('Havesets').asinteger)+' / '+pointdelimiters(Datamodule1.Tprofiles.fieldbyname('Totalsets').asinteger);
  panel3.caption:=pointdelimiters(Datamodule1.Tprofiles.fieldbyname('Haveroms').asinteger)+' / '+pointdelimiters(Datamodule1.Tprofiles.fieldbyname('Totalroms').asinteger);

  edit1.Text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'));
  edit3.text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Version'));
  edit9.text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Name'));
  edit4.text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Date'));
  edit5.text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Author'));
  edit6.text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Category'));
  edit7.text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Homeweb'));
  edit8.text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Email'));

  ComboBox1.Items.Clear;
  combobox1.Items.add(splitmergestring(0));

  if Datamodule1.Tprofiles.fieldbyname('Splitmerge').AsBoolean=true then
    ComboBox1.Items.Add(splitmergestring(1));

  if Datamodule1.Tprofiles.fieldbyname('Splitnomerge').AsBoolean=true then
    ComboBox1.Items.Add(splitmergestring(2));

  x:=Datamodule1.Tprofiles.fieldbyname('Filemode').asinteger;
  combobox1.ItemIndex:=ComboBox1.Items.IndexOf(splitmergestring(x));

  Image3210.Canvas.Brush.Color := Fproperties.Color;
  x:=getdattypeiconindexfromchar(Datamodule1.Tprofiles.fieldbyname('Original').asstring);
  image3210.Canvas.Fillrect(image3210.Canvas.ClipRect);
  bmp:=Tbitmap.Create;
  Fmain.ImageList2.GetBitmap(x,bmp);
  Fproperties.Image3210.Bitmap.Assign(bmp);
  bmp.free;

  if Datamodule1.Tprofiles.fieldbyname('Original').asstring='O' then begin
    edit10.Text:=checkofflinelistfilenameiffailsreturndefault(getwiderecord(Datamodule1.Tprofiles.fieldbyname('Date')));
    if getwiderecord(Datamodule1.Tprofiles.fieldbyname('Descmask'))='' then begin
      Datamodule1.Tprofiles.edit;
      setwiderecord(Datamodule1.Tprofiles.fieldbyname('Descmask'),checkofflinelistdescriptioniffailsreturndefault(''));
      Datamodule1.Tprofiles.post;
    end;
    tntedit1.Text:=checkofflinelistdescriptioniffailsreturndefault(getwiderecord(Datamodule1.Tprofiles.fieldbyname('Descmask')));
    edit4.Text:='';
    edit5.Text:='';
    edit7.Text:='';
    edit8.Text:='';
    edit4.ReadOnly:=true;
    edit5.ReadOnly:=true;
    edit7.ReadOnly:=true;
    edit8.ReadOnly:=true;
    edit4.TabStop:=false;
    edit5.TabStop:=false;
    edit7.TabStop:=false;
    edit8.TabStop:=false;
    edit4.Color:=clBtnFace;
    edit5.Color:=clBtnFace;
    edit7.Color:=clBtnFace;
    edit8.Color:=clBtnFace;
    panel4.Visible:=true;
    Edit6.Top:=Edit4.Top; //296
    Label7.Top:=Label5.top; //280
    Edit4.Visible:=false;
    Label5.Visible:=false;

    Edit5.Visible:=false;
    Edit7.Visible:=false;
    Edit8.Visible:=false;
    Label6.Caption:=traduction(236)+' :';
    Label8.Visible:=false;
    Label9.Visible:=false;
  end
  else begin
    edit4.ReadOnly:=false;
    edit5.ReadOnly:=false;
    edit7.ReadOnly:=false;
    edit8.ReadOnly:=false;
    edit4.TabStop:=true;
    edit5.TabStop:=true;
    edit7.TabStop:=true;
    edit8.TabStop:=true;
    edit4.Color:=clWindow;
    edit5.Color:=clWindow;
    edit7.Color:=clWindow;
    edit8.Color:=clWindow;

    panel4.Visible:=false;
    Edit6.Top:=296;
    Label7.Top:=280;
    Edit4.Visible:=true;
    Label5.Visible:=true;

    Edit5.Visible:=true;
    Edit7.Visible:=true;
    Edit8.Visible:=true;
    Label6.Caption:=traduction(16)+' :';
    Label8.Visible:=true;
    Label9.Visible:=true;
  end;
end;
freemousebuffer;
freekeyboardbuffer;
end;

procedure TFproperties.FormCreate(Sender: TObject);
var
x:integer;
begin
FFocusControl := nil;
Application.OnIdle := ApplicationIdle;

Fmain.fixcomponentsbugs(Fproperties);
lastfocus:=0;

TntSpeedButton1.Hint:=traduction(541);

for x:=0 to ComponentCount-1 do
  if components[x] is TTntspeedbutton then
    if  (((components[x] as TTntspeedbutton).tag=0) AND ((components[x] as TTntspeedbutton).width=25)) then
      (components[x] as TTntspeedbutton).OnClick:=buttonclick;
end;

procedure TFproperties.FormShow(Sender: TObject);
const
s=' :';
begin
//Saving current maintab
Fproperties.Tag:=Fmain.PageControl1.ActivePageIndex;

Fmain.addtoactiveform((sender as Tform),true);
caption:=traduction(42);

BitBtn1.caption:=traduction(80);
BitBtn2.caption:=traduction(123);
BitBtn3.caption:=traduction(217);


label1.Caption:=traduction(279);
Fmain.labelshadow(label1,Fproperties);
label11.Caption:=traduction(93)+' ';

label3.Caption:=traduction(13)+s;
label13.Caption:=traduction(14)+s;
label10.Caption:=traduction(22)+s;
label2.Caption:=traduction(11)+s;
label4.Caption:=traduction(12)+s;
label5.Caption:=traduction(15)+s;
label12.Caption:=traduction(276)+s;

if label6.tag=0 then
  label6.Caption:=traduction(16)+s
else
  label6.Caption:=traduction(236)+s;


label7.Caption:=traduction(17)+s;

label8.Caption:=traduction(18)+s;
label9.Caption:=traduction(19)+s;

speedbutton1.Hint:=traduction(280);
speedbutton2.Hint:=traduction(281);
speedbutton3.Hint:=traduction(93);

stablishfocus(BitBtn3);
if Fproperties.Tag=1 then begin
  speedbutton2.tag:=Fmain.PageControl2.ActivePageIndex-1;
end;

tntspeedbutton2.Caption:=traduction(11);
tntspeedbutton3.Caption:=traduction(151);

showinfoprofile(lastfocus);
end;

procedure TFproperties.BitBtn3Click(Sender: TObject);
begin
close;
end;

procedure TFproperties.SpeedButton1Click(Sender: TObject);
begin
SpeedButton1.Tag:=0;
showinfoprofile(lastfocus+1);
end;

procedure TFproperties.SpeedButton2Click(Sender: TObject);
begin
SpeedButton1.Tag:=1;
showinfoprofile(lastfocus-1);
end;

procedure TFproperties.SpeedButton3Click(Sender: TObject);
begin
mymessageinfomergesplit;
end;

procedure TFproperties.BitBtn1Click(Sender: TObject);
begin
BitBtn2Click(sender);
close;
end;

procedure TFproperties.BitBtn2Click(Sender: TObject);
var
pass,reset,isoffline,offdone,offfailed:boolean;
newfilemode:shortint;
counter,id:ansistring;
Toff,Tm,Td:Tabstable;
gamename,ext,filepass,gamenameresult:widestring;
x:longint;
Dupmaster:TTntStringList;
oldcnt:Longint;
offdescriptionreset,reimportmsg:boolean;
begin
Enabled:=false;
reimportmsg:=false;

Toff:=Tabstable.Create(Datamodule1);
Tm:=Tabstable.Create(Datamodule1);
Td:=Tabstable.Create(Datamodule1);
Toff.DatabaseName:=Datamodule1.TTree.DatabaseName;
Tm.DatabaseName:=Datamodule1.TTree.DatabaseName;
Td.DatabaseName:=Datamodule1.TTree.DatabaseName;

Fmain.speedupdb;

trimall;
pass:=true;
reset:=false;
newfilemode:=0;
isoffline:=false;
offdescriptionreset:=false;
filepass:=checkofflinelistfilenameiffailsreturndefault('');

if Datamodule1.Tprofiles.fieldbyname('Original').asstring='O' then
  isoffline:=true;

id:=fillwithzeroes(DataModule1.Tprofiles.FieldByName('ID').asstring,4);

Tm.TableName:='Y'+id;

Td.TableName:='Z'+id;

Tm.Open;
Td.open;

if isoffline=true then begin
  if getwiderecord(DataModule1.Tprofiles.FieldByName('Date'))<>edit10.text then
    if edit10.text=checkofflinelistfilenameiffailsreturndefault(edit10.Text) then begin
      if Datamodule1.DBDatabase.TableExists('O'+id)=true then begin
        if mymessagequestion(traduction(337),false)=0 then
          pass:=false
        else begin
          reset:=true;
          filepass:=edit10.text;
        end;
      end
      else begin
        pass:=false;
        reimportmsg:=true;
        mymessageerror(traduction(338));
      end;

    end
    else begin
      mymessageerror(traduction(336));
      pass:=false;
    end;

  if getwiderecord(DataModule1.Tprofiles.FieldByName('Descmask'))<>Tntedit1.text then
    if tntedit1.text=checkofflinelistdescriptioniffailsreturndefault(tntedit1.Text) then begin
      offdescriptionreset:=true;
      DataModule1.Tprofiles.edit;
      setwiderecord(DataModule1.Tprofiles.FieldByName('Descmask'),tntedit1.text);
      DataModule1.Tprofiles.post;
    end;

end
else
  if combobox1.Items.Strings[ComboBox1.ItemIndex]<>splitmergestring(DataModule1.Tprofiles.FieldByName('Filemode').asinteger) then
    if mymessagequestion(traduction(283),false)=0 then
      pass:=false
    else
     reset:=true;

Enabled:=false;//FIX
Datamodule1.DBDatabase.StartTransaction;

if pass=true then begin

  if reset=true then begin

    Fmain.showprocessingwindow(false,false);//CAN NOT IMPLEMENTED
    Fprocessing.panel2.caption:=changein(trim(edit1.Text),'&','&&');
    Fprocessing.panel3.caption:=traduction(61)+' : '+traduction(270);

    if isoffline=false then begin
      if combobox1.Items.Strings[ComboBox1.ItemIndex]=splitmergestring(1) then
        newfilemode:=1
      else
      if combobox1.Items.Strings[ComboBox1.ItemIndex]=splitmergestring(2) then
        newfilemode:=2;
    end;

  end
  else
    newfilemode:=DataModule1.Tprofiles.FieldByName('Filemode').asinteger;

  if (reset=true) AND (isoffline=False) then begin

  //RESET TO HAVE NOT
    while td.Eof=false do begin
      if td.FieldByName('Have').asboolean=true then begin
        td.edit;
        td.fieldbyname('Have').asboolean:=false;
        td.post;
      end;
      td.next;
    end;

    counter:=getcounterfilemode(tm.TableName,td.TableName,newfilemode,false);

  end
  else
  if (reset=true) AND (isoffline=true) then begin

    while td.Eof=false do begin
      if td.FieldByName('Have').asboolean=true then begin
        td.edit;
        td.fieldbyname('Have').asboolean:=false;
        td.post;
      end;
      td.next;
    end;

    Toff.TableName:='O'+id;
    Toff.open;

    ext:=WideExtractFileExt(Td.fieldbyname('Romname').asstring);

    Tm.first;
    Td.First;

    While not Tm.Eof do begin
      Tm.edit;
      Tm.FieldByName('Gamename').asstring:='*'+Tm.FieldByName('ID').asstring; //NO WIDENEEDED
      Tm.post;

      Td.edit;
      Td.FieldByName('Romname').asstring:='*'+Td.FieldByName('ID').asstring;  //NO WIDENEEDED
      Td.post;

      Application.processmessages;
      Tm.Next;
      Td.next;
    end;

    Tm.first;
    Td.First;

    Dupmaster:=TTntStringList.Create;
    Dupmaster.Sorted:=true;
    Dupmaster.Duplicates:=dupIgnore;
    Dupmaster.CaseSensitive:=false;

    While not Tm.Eof do begin

      gamename:=parseolfilename(filepass,getwiderecord(Toff.fieldbyname('Description')),getwiderecord(Toff.fieldbyname('Publisher')),getwiderecord(Toff.fieldbyname('Savetype')),Toff.fieldbyname('Relnum').asstring,getwiderecord(Toff.fieldbyname('Comment')),Toff.fieldbyname('Language').asstring,getwiderecord(Toff.fieldbyname('Location')),getwiderecord(Toff.fieldbyname('Sourcerom')),Td.fieldbyname('Space').AsString,Toff.fieldbyname('Langnum').asstring,Td.fieldbyname('CRC').AsString);
      gamename:=trim(gamename);
      offdone:=false;
      offfailed:=false;
      x:=-1;

      while offdone=false do begin

        if (Length(gamename)>255) OR (gamename='') then
          gamename:='Unk';

        gamenameresult:=gamename;
        if offfailed=true then
          gamenameresult:=gamename+'_'+inttostr(x);

        oldcnt:=Dupmaster.Count;
        Dupmaster.Add(gamenameresult);

        //showmessage(gamenameresult);

        if oldcnt<>Dupmaster.Count then begin

          Tm.Edit;
          setwiderecord(Tm.fieldbyname('Gamename'),gamenameresult);
          Tm.Post;

          Td.Edit;

          if offfailed=true then
            setwiderecord(Td.fieldbyname('Romname'),gamename+'_'+inttostr(x)+ext)
          else
            setwiderecord(Td.fieldbyname('Romname'),gamename+ext);

          Td.post;

          offdone:=true;
        end
        else begin
          offfailed:=true;
          x:=x+1;
        end;

        Application.processmessages;

      end;

      Tm.Next;
      Td.Next;
      Toff.Next;
    end;

    Freeandnil(Dupmaster);

  end;

  Datamodule1.Tprofiles.Edit;
  setwiderecord(DataModule1.Tprofiles.FieldByName('Description'),trim(edit1.text));

  if isoffline=false then begin
    setwiderecord(DataModule1.Tprofiles.FieldByName('Date'),edit4.Text);
    setwiderecord(DataModule1.Tprofiles.FieldByName('Author'),edit5.text);
    setwiderecord(DataModule1.Tprofiles.FieldByName('Homeweb'),edit7.text);
    setwiderecord(DataModule1.Tprofiles.FieldByName('Email'),edit8.Text);
  end
  else begin
    setwiderecord(DataModule1.Tprofiles.FieldByName('Date'),checkofflinelistfilenameiffailsreturndefault(edit10.text));
    setwiderecord(DataModule1.Tprofiles.FieldByName('Descmask'),checkofflinelistdescriptioniffailsreturndefault(tntedit1.text));
  end;


  setwiderecord(DataModule1.Tprofiles.FieldByName('Category'),edit6.text);
  DataModule1.Tprofiles.FieldByName('Filemode').asinteger:=newfilemode;

  if reset=true then begin
    DataModule1.Tprofiles.FieldByName('Havesets').asinteger:=0;
    DataModule1.Tprofiles.FieldByName('Haveroms').asstring:='';
    if isoffline=false then begin
      DataModule1.Tprofiles.FieldByName('Totalsets').asinteger:=strtoint(gettoken(counter,'/',2));
      DataModule1.Tprofiles.FieldByName('Totalroms').asinteger:=strtoint(gettoken(counter,'/',4));
    end;
  end;

  Datamodule1.Tprofiles.post;

  Datamodule1.Qaux.Close;

  if Datamodule1.Tprofilesview.Locate('ID',Datamodule1.Tprofiles.fieldbyname('ID').asinteger,[]) then begin
    Datamodule1.Tprofilesview.Edit;
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Description'),getwiderecord(DataModule1.Tprofiles.FieldByName('Description')));

    if isoffline=false then begin
      setwiderecord(DataModule1.Tprofilesview.FieldByName('Date'),getwiderecord(DataModule1.Tprofiles.FieldByName('Date')));
      setwiderecord(DataModule1.Tprofilesview.FieldByName('Author'),getwiderecord(DataModule1.Tprofiles.FieldByName('Author')));
      setwiderecord(DataModule1.Tprofilesview.FieldByName('Homeweb'),getwiderecord(DataModule1.Tprofiles.FieldByName('Homeweb')));
      setwiderecord(DataModule1.Tprofilesview.FieldByName('Email'),getwiderecord(DataModule1.Tprofiles.FieldByName('Email')));
    end
    else begin
      setwiderecord(DataModule1.Tprofilesview.FieldByName('Date'),getwiderecord(DataModule1.Tprofiles.FieldByName('Date')));
      //setwiderecord(DataModule1.Tprofilesview.FieldByName('Descmask'),getwiderecord(DataModule1.Tprofiles.FieldByName('Homeweb')));
    end;
    
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Category'),getwiderecord(DataModule1.Tprofiles.FieldByName('Category')));
    DataModule1.Tprofilesview.FieldByName('Filemode').asinteger:=newfilemode;

    if reset=true then begin
      DataModule1.Tprofilesview.FieldByName('Havesets').asinteger:=0;
      DataModule1.Tprofilesview.FieldByName('Haveroms').asstring:='';

      if isoffline=false then begin
        DataModule1.Tprofilesview.FieldByName('Totalsets').asinteger:=strtoint(gettoken(counter,'/',2));
        DataModule1.Tprofilesview.FieldByName('Totalroms').asinteger:=strtoint(gettoken(counter,'/',4));
      end;

    end;

    Datamodule1.Tprofilesview.post;
    Fmain.VirtualStringTree2.Repaint;
  end;

  panel2.Caption:=pointdelimiters(Datamodule1.Tprofiles.fieldbyname('Havesets').asinteger)+' / '+pointdelimiters(Datamodule1.Tprofiles.fieldbyname('Totalsets').asinteger);
  panel3.caption:=pointdelimiters(Datamodule1.Tprofiles.fieldbyname('Haveroms').asinteger)+' / '+pointdelimiters(Datamodule1.Tprofiles.fieldbyname('Totalroms').asinteger);

  //Is already opened
  if (Datamodule1.FindComponent('DB'+id) as TABSDatabase)<>nil then begin

    Fmain.showprolesmasterdetail(false,false,id,false,true);//Update face

    if reset=true then begin
      Fprocessing.panel3.caption:=traduction(61)+' : '+traduction(245);

      if offdescriptionreset=false then
        Fmain.showprolesmasterdetail(true,true,id,false,true);
    end;
  end;

  Enabled:=true;

end;

if offdescriptionreset=true then
  if Datamodule1.DBDatabase.TableExists('O'+id)=false then begin
    if reimportmsg=false then
      mymessageerror(traduction(338));
    offdescriptionreset:=false;
  end;

if offdescriptionreset=true then begin //0.037

  if reset=false then begin
    Fmain.showprocessingwindow(false,false);//CAN NOT IMPLEMENTED
    Fprocessing.panel2.caption:=changein(trim(edit1.Text),'&','&&');
    Fprocessing.panel3.caption:=traduction(61)+' : '+traduction(270);
  end;

  filepass:=tntedit1.Text;

  if Toff.Active=false then begin
    Toff.TableName:='O'+id;
    Toff.open;
  end;

  Tm.First;

  while Tm.Eof=false do begin
    Application.ProcessMessages;
    Toff.Locate('Setid',Tm.fieldbyname('ID').asinteger,[]);
    Td.Locate('Setnamemaster',Tm.fieldbyname('ID').asinteger,[]);

    //Apply description mask
    gamenameresult:=parseolfilename(filepass,getwiderecord(Toff.fieldbyname('Description')),getwiderecord(Toff.fieldbyname('Publisher')),getwiderecord(Toff.fieldbyname('Savetype')),Toff.fieldbyname('Relnum').asstring,getwiderecord(Toff.fieldbyname('Comment')),Toff.fieldbyname('Language').asstring,getwiderecord(Toff.fieldbyname('Location')),getwiderecord(Toff.fieldbyname('Sourcerom')),Td.fieldbyname('Space').AsString,Toff.fieldbyname('Langnum').asstring,Td.fieldbyname('CRC').AsString);

    if (Length(gamenameresult)>255) OR (gamenameresult='') then
      gamenameresult:='Unk';

    Tm.edit;
    setwiderecord(Tm.fieldbyname('Description'),gamenameresult);
    Tm.post;

    Tm.Next;
  end;

  Fmain.showprolesmasterdetail(true,true,id,false,true);

  id:=Fmain.getcurrentprofileid;
  if id<>'' then //FIX
    Fmain.showprolesmasterdetail(false,false,id,true,true);

end;

Fmain.hideprocessingwindow;

Datamodule1.Qaux.sql.Text:='POST';
Fmain.BMDThread1.Start();
Fmain.waitforfinishthread;

Toff.free;
Tm.free;
Td.free;

Enabled:=true;
end;

procedure TFproperties.FormDestroy(Sender: TObject);
begin
Application.OnIdle := nil;
end;

procedure TFproperties.Edit10Change(Sender: TObject);
begin
limitconflictcharsedit2(sender,true);
end;

procedure TFproperties.Edit10KeyPress(Sender: TObject; var Key: Char);
begin
key:=limitconflictcharsedit(sender,key,true);
end;

procedure TFproperties.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFproperties.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFproperties.TntSpeedButton1Click(Sender: TObject);
begin
if edit10.visible=true then
  edit10.Text:=defofffilename
else
  tntedit1.Text:=checkofflinelistdescriptioniffailsreturndefault('');
end;

procedure TFproperties.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

procedure TFproperties.TntSpeedButton3Click(Sender: TObject);
begin
edit10.Visible:=true;
TntEdit1.Visible:=false;
label6.Caption:=traduction(236);
end;

procedure TFproperties.TntSpeedButton2Click(Sender: TObject);
begin
edit10.Visible:=false;
tntedit1.Width:=edit10.Width;
TntEdit1.Visible:=true;
label6.Caption:=traduction(620);
end;

end.
