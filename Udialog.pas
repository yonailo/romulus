unit Udialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, TntComCtrls,Tntforms, ImgList, Shellapi, Buttons,
  TntButtons, ExtCtrls, TntExtCtrls, strings, TntSysutils, StdCtrls,
  TntStdCtrls, VirtualTrees, Tntclasses, Mymessages, Menus,
  TntMenus, Math;

type
  TFdialog = class(TTntform)
    ImageList1: TImageList;
    TntPanel2: TTntPanel;
    TntPanel3: TTntPanel;
    TntPanel4: TTntPanel;
    TntPanel5: TTntPanel;
    TntEdit1: TTntEdit;
    TntLabel1: TTntLabel;
    TntPanel6: TTntPanel;
    TntTreeView1: TTntTreeView;
    Splitter1: TSplitter;
    VirtualStringTree1: TVirtualStringTree;
    TntLabel2: TTntLabel;
    ScrollBox1: TScrollBox;
    TntPanel8: TTntPanel;
    TntSpeedButton1: TTntSpeedButton;
    TntSpeedButton2: TTntSpeedButton;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    TntListBox1: TTntListBox;
    TntListBox2: TTntListBox;
    TntLabel3: TTntLabel;
    TntBitBtn3: TTntBitBtn;
    TntPopupMenu1: TTntPopupMenu;
    TntPopupMenu2: TTntPopupMenu;
    addfolder1: TTntMenuItem;
    Edit1: TTntMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TntTreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure TntTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TntSpeedButton1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure TntPanel2Resize(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntTreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntBitBtn3Click(Sender: TObject);
    procedure VirtualStringTree1AddToSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VirtualStringTree1RemoveFromSelection(
      Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TntEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure TntEdit1Change(Sender: TObject);
    procedure VirtualStringTree1DblClick(Sender: TObject);
    procedure TntSpeedButton2Click(Sender: TObject);
    procedure addfolder1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
  private
    { Private declarations }
    procedure displaydrives;
    procedure foldersoffolder(n:Ttnttreenode);
    procedure editfoldername(fromtree:boolean);
  public
    { Public declarations }
    procedure displayletter(path:widestring);
  end;

var
  Fdialog: TFdialog;
  fileslist:Ttntstringlist;
  startdir:widestring;
  selection:longint;
  dialogfileleft,dialogfiletop,dialogfilewidth,dialogfileheight,dialogfiletree:integer;
  dialogfilemax,dialogfoldermax:boolean;
  dialogfolderleft,dialogfoldertop,dialogfolderwidth,dialogfolderheight:integer;

implementation

uses Umain, Unewfolder;

{$R *.dfm}

function GetVolumeName(DriveLetter: Char): string;
var
  dummy: DWORD;
  buffer: array[0..MAX_PATH] of Char;
  oldmode: LongInt;
begin
  oldmode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    GetVolumeInformation(PChar(DriveLetter + ':\'),
                         buffer,
                         SizeOf(buffer),
                         nil,
                         dummy,
                         dummy,
                         nil,
                         0);
    Result := StrPas(buffer);
  finally
    SetErrorMode(oldmode);
  end;
end;

function GetVolumeLabelw(DriveChar: widestring): widestring;
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  //VolumeInfo:  array[0..MAX_PATH] of Wchar;
  VolumeSerialNumber: DWORD;
  Buf: array [0..MAX_PATH] of Wchar;
  x,s:integer;
  drivename:widestring;
  d:char;
  r:ansistring;
begin
drivename:='';
r:=DriveChar;
d:=r[1];

try

  if widedirectoryexists(d)=true then begin

    r:=GetVolumeName(d);//STRING SIZE
    s:=length(trim(r));

    if s>0 then begin
      GetVolumeInformationw(PwChar(DriveChar + ':\'),
      Buf, sizeof(buf), @VolumeSerialNumber, NotUsed,
      VolumeFlags, nil, 0);

      for x:=0 to s-1 do
        drivename:=drivename+buf[x];
  end;

  end;
except
end;

result:=drivename;
end;

function folderhasfolders(path:widestring):boolean;
var
FileSearch:  TSearchRecW;
res:boolean;
begin
res:=false;
path:=checkpathbar(path);
//path:=addlongpath(path);

try

WideSetCurrentDir(path);//WILL MAKE EXCEPTION ON PROTECTED FOLDERS
                                     //fahidden 0.032
if wideFindFirst('*.*', faDirectory or fahidden, FileSearch)=0 then

repeat
  if ( (FileSearch.Attr and fadirectory) = fadirectory) then   //0.033 MUST FIX SYSTEM ZIP AS FOLDER BUG
    if  (FileSearch.Name <> '.') and (FileSearch.Name <> '..') then begin//FOLDER
      res:=true;
      break;
    end;
until WideFindNext( FileSearch ) <> 0;

WideFindClose(FileSearch);

except
end;

Fmain.unlocksearchfolder;

Result:=res;
end;

procedure Tfdialog.foldersoffolder(n:Ttnttreenode);
var
FileSearch:  TSearchRecW;
path,date_:widestring;
n2,n3:Ttnttreenode;
s:int64;
a:longint;
x,c:integer;
updatefiles,updatefolders,pass:boolean;
folderlist:Ttntstringlist;
begin
screen.Cursor:=crHourGlass;
Fmain.Gettreepath(n,path);
path:=checkpathbar(path);
//path:=addlongpath(path);
updatefiles:=true;
updatefolders:=false;
folderlist:=Ttntstringlist.Create;
folderlist.Sorted:=true;
n3:=nil;

if WideDirectoryExists(path)=false then begin
  VirtualStringTree1.RootNodeCount:=0;
  screen.Cursor:=crDefault;
  mymessageerror(traduction(638));
  exit;
end
else
  if virtualstringtree1.Visible=false then
    tntbitbtn1.Enabled:=true;

tnttreeview1.Items.BeginUpdate;

try
  if n.GetNext.Text='' then begin
    n.DeleteChildren;
  end
  else begin

    n3:=n.GetNext;
    if n.Level<n3.Level then //IMPORTANT
    while n3<>nil do begin
      updatefolders:=true;
      folderlist.Add(n3.Text);
      n3:=n3.GetNextChild(n3);
    end;

  end;
except
   n.DeleteChildren;
end;


//caption:=path;
//REFRESH FOLDERS
if n.AbsoluteIndex<>TntTreeView1.Selected.AbsoluteIndex then
  updatefiles:=false
else
if virtualstringtree1.Visible=false then
  updatefiles:=false
else
  fileslist.Clear;

VirtualStringTree1.RootNodeCount:=0;
selection:=0;

if virtualstringtree1.Visible=true then begin
  if tntbitbtn2.Visible=true then begin
    tntedit1.Text:='';
  end;

  if tntedit1.Text='' then begin
    TntBitBtn1.Enabled:=false;
    TntBitBtn3.Enabled:=false;
  end;
end;

fileslist.Sorted:=true;

{if folderhasfolders(path)=false then begin
  tnttreeview1.Items.EndUpdate;
  exit;
end;   }

try

WideSetCurrentDir(path);//WILL MAKE EXCEPTION ON PROTECTED FOLDERS
                                     //fahidden 0.032
if wideFindFirst('*.*', faDirectory or fahidden, FileSearch)=0 then

repeat
  if ( (FileSearch.Attr and fadirectory) = fadirectory) then begin   //0.033 MUST FIX SYSTEM ZIP AS FOLDER BUG
    if  (FileSearch.Name <> '.') and (FileSearch.Name <> '..') then begin//FOLDER

      pass:=true;
      if updatefolders=true then begin
        x:=folderlist.IndexOf(Filesearch.Name);
        if x<>-1 then begin
          if folderlist.Strings[x]<>Filesearch.Name then begin //FOLDER IS RENAMED

            n3:=n.GetNext;
            if n.Level<n3.Level then //IMPORTANT
            while n3<>nil do begin
              if n3.Text=folderlist.Strings[x] then begin
                n3.Text:=Filesearch.Name;
                break;
              end;
              n3:=n3.GetNextChild(n3);
            end;

          end;

          folderlist.Delete(x);
          pass:=false;
        end;
      end;

      if pass=true then begin
        n2:=TntTreeView1.Items.Addchild(n,FileSearch.Name);
        n2.ImageIndex:=5;
        n2.SelectedIndex:=6;

        if folderhasfolders(path+FileSearch.Name)=true then begin

          n2:=TntTreeView1.Items.AddChild(n2,'');
          n2.ImageIndex:=5;
          n2.SelectedIndex:=6;

        end;
      end;

      if updatefiles=true then begin
        fileslist.Add(FileSearch.Name+'|-1|');
      end;

    end;
  end
  else
  if updatefiles=true then begin
    pass:=true;

    if TntListBox2.Items.Count>0 then
      if TntListBox2.Items.IndexOf(WideExtractFileExt(wideuppercase(Filesearch.Name)))=-1 then
        pass:=false;

    if pass=true then begin //FILTER NO PASS
      s:=0;
      try
        s:=sizeoffile(path+Filesearch.Name);
      except
      end;
      try
        a:=widefileage(path+Filesearch.Name);
        date_:=datetimetostr(FileDateToDateTime(a));
      except
        date_:='';
      end;

      fileslist.Add(FileSearch.Name+'|'+inttostr(s)+'|'+date_);
    end;
  end;
until WideFindNext( FileSearch ) <> 0;

WideFindClose(FileSearch);

except
end;

Fmain.unlocksearchfolder;

if (updatefolders=true) AND (folderlist.Count>0) then begin //DELETE NON EXISTING FOLDERS
  n3:=n.GetNext;

  if n.Level<n3.Level then //IMPORTANT
  while n3<>nil do begin
    n2:=nil;
    x:=folderlist.IndexOf(n3.Text);
    if x<>-1 then begin//FOUND AND DELETE
      //showmessage('borrar'+folderlist.Strings[x]);
      folderlist.Delete(x);
      n2:=n3;
    end;

    n3:=n3.GetNextChild(n3);

    if n2<>nil then
      n2.Delete;

  end;
end;

Freeandnil(Folderlist);
c:=0;
fileslist.Sorted:=false;
{FILE
 DIR
 FILE}
for x:=0 to fileslist.count-1 do //SORT DIRECTORIES
  if gettoken(fileslist.Strings[x],'|',2)='-1' then begin
    fileslist.Move(x,c);
    c:=c+1;
  end;

tnttreeview1.Items.EndUpdate;

VirtualStringTree1.RootNodeCount:=fileslist.count;
//posintoindex(0,virtualstringtree1);

screen.Cursor:=crDefault;
end;

procedure Tfdialog.displaydrives;
var
vDrivesSize: Cardinal;
vDrives	: array[0..128] of Char;
vDrive	 : PChar;
p,s:Tcomponent;
i,h,img:integer;
drive:ansistring;
begin
i:=0;
h:=0;
img:=0;

try
	// clear the list from possible leftover from prior operations
  vDrivesSize := GetLogicalDriveStrings(SizeOf(vDrives), vDrives);
	if vDrivesSize=0 then Exit; // no drive found, no further processing needed
	vDrive := vDrives;
	while vDrive^ <> #0 do begin

    p:=Fmain.CloneComponent(TntPanel8,inttostr(i));
    s:=Fmain.CloneComponent(TntSpeedButton1,inttostr(i));

    (p as TTntPanel).parent:=ScrollBox1;
    (p as Ttntpanel).top:=h;
    (p as Ttntpanel).Visible:=true;
    h:=(p as Ttntpanel).top+(p as Ttntpanel).Height+5;
    (s as Ttntspeedbutton).Parent:=(p as TTntPanel);
    (s as Ttntspeedbutton).caption:=StrPas(vDrive);
    (s as TTntSpeedButton).OnClick:=TntSpeedButton1Click;

    drive:=trim(strpas(vDrive));

    case GetDriveType(Pchar(drive)) of
      DRIVE_REMOVABLE: img:=0;
      DRIVE_FIXED: img:=1;
      DRIVE_REMOTE: img:=3;
      DRIVE_CDROM: img:=2;
      DRIVE_RAMDISK: img:=4;
    end;

    ImageList1.GetBitmap(img,(s as Ttntspeedbutton).Glyph);

    i:=i+1;
    Inc(vDrive, SizeOf(vDrive));
  end;
except
end;



end;

procedure TFdialog.displayletter(path:widestring);
var
n,n2:TTntTreeNode;
drive,aux,aux2:widestring;
s:string;
x,y:integer;
img:integer;
begin
//path:=addlongpath(path);
path:=checkpathbar(path);
drive:=checkpathbar(wideextractfiledrive(path));

//DRIVE EMPTY OR DOES NOT EXISTS
if WideDirectoryExists(drive)=False then begin
  mymessageerror(traduction(638));
  Exit;
end;

//if pass=false then
//  exit;


img:=1;

//s:=removelongpath(drive)[1];
s:=(drive)[1];

case GetDriveType(Pchar(s)) of
  DRIVE_REMOVABLE: img:=0;
  DRIVE_FIXED: img:=1;
  DRIVE_REMOTE: img:=3;
  DRIVE_CDROM: img:=2;
  DRIVE_RAMDISK: img:=4;
end;

TntTreeView1.tag:=1;
TntTreeView1.Items.BeginUpdate;
TntTreeView1.Items.Clear;

n:=TntTreeView1.Items.Add(nil,drive);
n.ImageIndex:=img;
n.SelectedIndex:=img;

tnttreeview1.Items.Item[0].Selected:=true;

if folderhasfolders(drive) then begin
  if tnttreeview1.Items.Item[0].Expanded=false then
    tnttreeview1.Items.Item[0].Expand(false);
end;

path:=changein(path,drive,'');


if path<>'' then //NOT ROOT
  for x:=1 to GetTokenCount(path,'\')-1 do begin
    aux:=gettoken(path,'\',x);

    if WideDirectoryExists(drive+aux2+aux) then begin
      //showmessage('EXISTE '+drive+aux2+aux);

      for y:=n.AbsoluteIndex+1 to TntTreeView1.Items.Count-1 do begin
        n2:=tnttreeview1.Items.Item[y];
        //showmessage(inttostr(n2.Level)+'='+n2.Text+'-'+inttostr(n.Level)+'='+aux);

        if n2.Level=n.Level+1 then begin
          if wideuppercase(n2.Text)=wideuppercase(aux) then begin

            //showmessage('ok');
            aux2:=aux2+aux+'\';
            n:=n2;
            tnttreeview1.Items.Item[y].Selected:=true;
            if n.Expanded=false then
              n.Expand(false);

            break;
          end
        end
        else
        if n2.level<=n.level then
          break;
      end;
    end
    else
      break;
  end;


tnttreeview1.Items.EndUpdate;

end;

procedure Tfdialog.editfoldername(fromtree:boolean);
var
path,curr,org,dest:widestring;
retry:boolean;
msgnum:integer;
begin
retry:=true;
msgnum:=0;

while retry=true do begin
  Application.CreateForm(TFnewfolder, Fnewfolder);

  Fnewfolder.Caption:=traduction(32);
  Fnewfolder.Label1.Caption:=traduction(91);

  Fnewfolder.Edit1.MaxLength:=255;
  Fnewfolder.Image321.Tag:=1;

  if msgnum<>0 then
  case msgnum of
    1:Fnewfolder.Label2.Caption:=traduction(69);
    2:Fnewfolder.Label2.Caption:=traduction(70);
  end;
  msgnum:=0;

  if fromtree=true then begin
    curr:=gettoken(tntlabel2.Caption,'\',gettokencount(tntlabel2.caption,'\')-1);
    Fnewfolder.Edit1.Text:=curr;
  end;
  myshowform(Fnewfolder,true);

  Fnewfolder.Edit1.Text:=trim(Fnewfolder.Edit1.text);

  if (Fnewfolder.Tag<>0) then begin//ACCEPT
    if Fnewfolder.Edit1.Text='' then begin
      msgnum:=1;
    end
    else begin
      path:=(tntlabel2.caption);
      path:=path+Fnewfolder.edit1.Text;
      if (WideDirectoryExists(path)) AND (wideuppercase(curr)<>wideuppercase(Fnewfolder.Edit1.Text)) then
        msgnum:=2
      else begin
        //FROM TREE OR NOT
        //ORIGIN checkpathbar(addlongpath(tntlabel2.caption)
        //DESTINATION
        org:=checkpathbar((tntlabel2.caption));
        dest:=copy(org,1,length(org)-length(curr)-1);
        dest:=dest+Fnewfolder.Edit1.Text;

        if WideRenameFile(org,dest)=true then begin
          TntTreeView1.items.item[tnttreeview1.Selected.AbsoluteIndex].Text:=Fnewfolder.Edit1.Text;
          retry:=false;
        end
        else begin
          msgnum:=1;
        end;
      end;
    end;
  end
  else
    retry:=false;

  Freeandnil(Fnewfolder);
end;
end;

procedure TFdialog.FormCreate(Sender: TObject);
begin
dialoglist.Clear;
selection:=0;
fileslist:=Ttntstringlist.create;
Fmain.fixcomponentsbugs(Fdialog);
TntTreeView1.RightClickSelect:=true;
displaydrives;
end;

procedure TFdialog.TntTreeView1Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin

if node.AbsoluteIndex<>TntTreeView1.Selected.AbsoluteIndex then
  foldersoffolder(TntTreeView1.items.item[node.AbsoluteIndex]);
end;

procedure TFdialog.TntTreeView1Change(Sender: TObject; Node: TTreeNode);
var
path:widestring;
begin
repaint;
Fmain.Gettreepath(TntTreeView1.items.item[node.AbsoluteIndex],path);

foldersoffolder(TntTreeView1.items.item[node.AbsoluteIndex]);

path:=changein(path,':\\',':\');//FIX

if virtualstringtree1.Visible=false then
  tntedit1.Text:=path;

TntLabel2.Caption:=path;
end;

procedure TFdialog.FormShow(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
Fdialog.displayletter(startdir);
//TRADUCTION
Tntpanel5.Caption:=traduction(639)+' :';
Tntspeedbutton2.Caption:=traduction(640);
tntlabel1.Caption:=traduction(23)+' :';
tntbitbtn1.Caption:=traduction(504);
tntbitbtn2.Caption:=traduction(81);
tntbitbtn3.Caption:=traduction(202);

addfolder1.Caption:=UTF8Encode(traduction(640));
Edit1.Caption:=UTF8Encode(traduction(32));

VirtualStringTree1.header.Columns[0].text:=traduction(151);
VirtualStringTree1.header.Columns[1].text:=traduction(233);
VirtualStringTree1.header.Columns[2].text:=traduction(641);

if virtualstringtree1.Visible=true then begin
  if dialogfileleft<>-1 then begin
    Fdialog.Left:=dialogfileleft;
    Fdialog.Top:=dialogfiletop;
    fdialog.Width:=dialogfilewidth;
    fdialog.Height:=dialogfileheight;
    Fdialog.TntTreeView1.Width:=dialogfiletree;
  end;
end
else
  if dialogfolderleft<>-1 then begin
    Fdialog.Left:=dialogfolderleft;
    Fdialog.Top:=dialogfoldertop;
    Fdialog.Width:=dialogfolderwidth;
    Fdialog.Height:=dialogfolderheight;
  end;

end;

procedure TFdialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);

VirtualStringTree1.OnRemoveFromSelection:=nil;//FIX
VirtualStringTree1.OnAddToSelection:=nil;//FIX

if VirtualStringTree1.Visible=true then begin

  dialogfilemax:=false;

  if (dialogfileleft>screen.DesktopRect.Right) OR (dialogfiletop>screen.DesktopRect.Bottom) OR (dialogfileleft-Fdialog.Width<screen.DesktopRect.left-Fdialog.Width-Fdialog.Width) OR (dialogfiletop-Fdialog.Height<screen.DesktopRect.Top-Fdialog.Height-Fdialog.Height) then begin
    dialogfileleft:=-1;
    dialogfiletop:=-1;
    dialogfilewidth:=-1;
    dialogfileheight:=-1;
    dialogfiletree:=-1;
    dialogfilemax:=false;
  end
  else begin

    if Fdialog.WindowState=wsmaximized then begin
      dialogfilemax:=true;
      Fdialog.WindowState:=wsNormal;
    end;

    dialogfileleft:=fdialog.Left;
    dialogfiletop:=fdialog.Top;
    dialogfilewidth:=fdialog.Width;
    dialogfileheight:=Fdialog.Height;
    dialogfiletree:=TntTreeView1.Width;
  end;

end
else begin

  dialogfoldermax:=false;

  if (dialogfolderleft>screen.DesktopRect.Right) OR (dialogfoldertop>screen.DesktopRect.Bottom) OR (dialogfolderleft-Fdialog.Width<screen.DesktopRect.left-Fdialog.Width-Fdialog.Width) OR (dialogfoldertop-Fdialog.Height<screen.DesktopRect.Top-Fdialog.Height-Fdialog.Height) then begin
    dialogfolderleft:=-1;
    dialogfoldertop:=-1;
    dialogfolderwidth:=-1;
    dialogfolderheight:=-1;
    dialogfoldermax:=false;
  end
  else begin

    if Fdialog.WindowState=wsmaximized then begin
      dialogfoldermax:=true;
      Fdialog.WindowState:=wsNormal;
    end;

    dialogfolderleft:=fdialog.Left;
    dialogfoldertop:=fdialog.Top;
    dialogfolderwidth:=fdialog.Width;
    dialogfolderheight:=Fdialog.Height;
  end;

end;

freeandnil(fileslist);

if Fdialog.Tag=0 then
  dialoglist.Clear;
end;

procedure TFdialog.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);

if virtualstringtree1.visible=true then begin
  if dialogfilemax=true then
    Fdialog.WindowState:=wsMaximized;
end
else
  if dialogfoldermax=true then
    Fdialog.WindowState:=wsMaximized;

dialogfoldermax:=false;
dialogfilemax:=false;
end;

procedure TFdialog.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
s:widestring;
begin
case column of
  0:celltext:=gettoken(fileslist.Strings[node.Index],'|',1);
  1:begin
      s:=gettoken(fileslist.Strings[node.Index],'|',2);
      if s='-1' then
        s:=''
      else
        if showasbytes=false then
          s:=bytestostr(StrToCurr(s))
        else
          s:=pointdelimiters(strtocurr(s))+' bytes';

      celltext:=s;
    end;
  2:begin
      s:=gettoken(fileslist.Strings[node.Index],'|',3);
      celltext:=s;
  end;
end;

end;

procedure TFdialog.VirtualStringTree1GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
s:widestring;
i:integer;
begin

if column=0 then
  if Kind=ikState then begin
    s:=gettoken(fileslist.Strings[node.Index],'|',2);
    if s='-1' then
      imageindex:=5  //FOLDER
    else begin
      s:=WideExtractFileExt(gettoken(fileslist.Strings[node.Index],'|',1));
      s:=wideuppercase(s);
      i:=TntListBox1.Items.IndexOf(s);

      if i=-1 then  //UNKNOW FILE
        imageindex:=7
      else
        imageindex:=i+8;
    
    end;
  end;
  //else
  //if kind<>ikOverlay then begin //OK
  //  ImageIndex:=1;
  //end;

end;

procedure TFdialog.TntSpeedButton1Click(Sender: TObject);
begin
displayletter((sender as Ttntspeedbutton).caption);
end;

procedure TFdialog.TntBitBtn2Click(Sender: TObject);
begin
close;
end;

procedure TFdialog.TntPanel2Resize(Sender: TObject);
begin
tntbitbtn1.Repaint;
tntbitbtn2.Repaint;
tntbitbtn3.Repaint;
end;

procedure TFdialog.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

procedure TFdialog.TntTreeView1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var node: Ttnttreenode;
begin
//BUGFIX Rightclick no treeview
node := TntTreeView1.GetNodeAt(MousePos.X, MousePos.Y); // Tries to get node
if (node <> nil) then TntTreeView1.Selected := (node as TTnttreenode); // Pass selection to tree
end;

procedure TFdialog.TntBitBtn1Click(Sender: TObject);
var
f:widestring;
x:integer;
n:Pvirtualnode;
begin
if WideDirectoryExists((TntLabel2.Caption))=false then begin
  mymessageerror(traduction(638));
  exit;
end;

if virtualstringtree1.Visible=false then begin //FOLDER DIALOG

  dialoglist.Text:=(tntlabel2.caption);

end
else begin

    if (selection=0) AND (virtualstringtree1.SelectedCount>0) then begin //ALREADY SELECTED A FOLDER THEN OPEN IT
      n:=VirtualStringTree1.GetFirst;

      for x:=0 to VirtualStringTree1.RootNodeCount-1 do begin

        if VirtualStringTree1.Selected[n]=true then begin
          if gettoken(fileslist.Strings[x],'|',2)='-1' then begin//FOLDER
            if WideDirectoryExists((TntLabel2.Caption+gettoken(fileslist.Strings[x],'|',1)))=true then begin
              Fdialog.displayletter(TntLabel2.Caption+gettoken(fileslist.Strings[x],'|',1));
              exit;
            end
            else begin
              mymessageerror(traduction(638));
              exit;
            end;
          end;
        end;

        n:=Virtualstringtree1.GetNext(n);
      end;//VT LOOP

    end;//SELECTION=1

    //CHECK VALID FILENAME OR PATH
    f:=trim(tntedit1.Text);
    if f='' then
      exit;

    if tntbitbtn3.Visible=true then begin//SAVE DIALOG

      if WideDirectoryExists(checkpathbar((f)))=true then begin
        Fdialog.displayletter(f);
        exit;
      end;

      if tntlistbox2.Items.Count>0 then begin //EXTENSION
        if wideuppercase(WideExtractFileExt(f))<>tntlistbox2.Items.Strings[0] then
          f:=f+WideLowerCase(tntlistbox2.Items.Strings[0]);
      end;

      dialoglist.clear;

      if WideExtractFilePath(f)='' then
        dialoglist.Add((tntlabel2.caption+f))
      else
        dialoglist.Add((f));


    end
    else begin //OPEN DIALOG
      n:=VirtualStringTree1.GetFirst;
      for x:=0 to VirtualStringTree1.RootNodeCount-1 do begin
        if virtualstringtree1.Selected[n]=true then
          if gettoken(fileslist.Strings[x],'|',2)<>'-1' then  //IGNORE FOLDERS
            dialoglist.Add((TntLabel2.Caption+gettoken(fileslist.Strings[x],'|',1)));

        n:=VirtualStringTree1.GetNext(n);
      end;

    end;

end;

Fdialog.Tag:=1;
close;
end;

procedure TFdialog.TntBitBtn3Click(Sender: TObject);
var
pass:boolean;
path:widestring;
begin
pass:=true;
path:=(tntlabel2.Caption+tntedit1.Text);
//CHECK EXISTING FILE
if WideFileExists(path) then begin
  if mymessagequestion(traduction(216)+#10#13+path,false)<>1 then
      pass:=false;
end;

if pass=true then
  TntBitBtn1Click(sender);
end;

procedure TFdialog.VirtualStringTree1AddToSelection(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
if fileslist.Count>0 then //FIX
  if gettoken(fileslist.Strings[node.Index],'|',2)<>'-1' then begin
    selection:=selection+1;
    if selection=1 then
      tntedit1.Text:=gettoken(fileslist.Strings[node.Index],'|',1)
    else
      tntedit1.Text:='< '+tntlabel1.Caption+' '+inttostr(selection)+' >';
  end;

if VirtualStringTree1.RootNodeCount>0 then begin
  TntBitBtn1.Enabled:=true;
  TntBitBtn3.Enabled:=true;
end;
end;

procedure TFdialog.VirtualStringTree1RemoveFromSelection(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
begin

if fileslist.Count>0 then //FIX
  if gettoken(fileslist.Strings[node.Index],'|',2)<>'-1' then
    selection:=selection-1;

if VirtualStringTree1.RootNodeCount=0 then begin
  TntBitBtn1.Enabled:=false;
  TntBitBtn3.Enabled:=false;
end;           

end;

procedure TFdialog.TntEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

if key=VK_RETURN then
  if virtualstringtree1.Visible=false then begin
    if WideDirectoryExists((tntedit1.Text))=true then begin
      TntLabel2.Caption:=(tntedit1.Text);
      TntBitBtn1Click(sender);//AUTOCLICK
    end
    else
      mymessageerror(traduction(638));
  end
  else
  if trim(tntedit1.Text)<>'' then
    TntBitBtn1Click(sender);
end;

procedure TFdialog.TntEdit1KeyPress(Sender: TObject; var Key: Char);
begin
if tntedit1.ReadOnly=false then
  if virtualstringtree1.Visible=true then
    key:=limitconflictcharseditdialog(sender,key);
end;

procedure TFdialog.TntEdit1Change(Sender: TObject);
begin
if tntedit1.ReadOnly=false then
if (virtualstringtree1.Visible=true) then begin
  if trim(TntEdit1.Text)<>'' then
    TntBitBtn3.Enabled:=true
  else
    TntBitBtn3.Enabled:=false;
end;
end;

procedure TFdialog.VirtualStringTree1DblClick(Sender: TObject);
var
x:Integer;
n:PVirtualNode;
begin
if virtualstringtree1.SelectedCount<=0 then
  exit;

n:=VirtualStringTree1.GetFirst;

for x:=0 to VirtualStringTree1.RootNodeCount-1 do begin
  if VirtualStringTree1.Selected[n]=true then begin
    if gettoken(fileslist.Strings[x],'|',2)='-1' then begin//FOLDER
      if WideDirectoryExists((TntLabel2.Caption+gettoken(fileslist.Strings[x],'|',1)))=true then
        Fdialog.displayletter(TntLabel2.Caption+gettoken(fileslist.Strings[x],'|',1))
      else
        mymessageerror(traduction(638));
      break;
    end
    else begin//FILE
      if tntbitbtn3.Visible=true then
        TntBitBtn3Click(sender)
      else
        TntBitBtn1Click(sender);
      break;
    end;
  end;
  n:=Virtualstringtree1.GetNext(n);
end;

end;

procedure TFdialog.TntSpeedButton2Click(Sender: TObject);
var
path:widestring;
retry:boolean;
msgnum:integer;
begin
retry:=true;
msgnum:=0;

while retry=true do begin
  Application.CreateForm(TFnewfolder, Fnewfolder);

  Fnewfolder.Caption:=traduction(31);
  Fnewfolder.Label1.Caption:=traduction(68);
  Fnewfolder.Edit1.MaxLength:=255;
  Fnewfolder.Image321.Tag:=1;

  if msgnum<>0 then
  case msgnum of
    1:Fnewfolder.Label2.Caption:=traduction(69);
    2:Fnewfolder.Label2.Caption:=traduction(70);
  end;
  msgnum:=0;

  myshowform(Fnewfolder,true);

  Fnewfolder.Edit1.Text:=trim(Fnewfolder.Edit1.text);

  if (Fnewfolder.Tag<>0) then begin//ACCEPT
    if Fnewfolder.Edit1.Text='' then begin
      msgnum:=1;
    end
    else begin
      path:=(tntlabel2.caption);
      path:=path+Fnewfolder.edit1.Text;
      if WideDirectoryExists(path)=true then
        msgnum:=2
      else
        if WideCreateDir(path)=true then begin
          foldersoffolder(TntTreeView1.items.item[tnttreeview1.Selected.AbsoluteIndex]);
          if virtualstringtree1.Visible=true then
            posintoindex(fileslist.indexof(Fnewfolder.edit1.text+'|-1|'),virtualstringtree1);
          retry:=false;
        end
        else
          msgnum:=1;
    end;
  end
  else
    retry:=false;

  Freeandnil(Fnewfolder);
end;

end;

procedure TFdialog.addfolder1Click(Sender: TObject);
begin
TntSpeedButton2Click(sender);
end;

procedure TFdialog.Edit1Click(Sender: TObject);
begin
editfoldername(true);
end;

end.
