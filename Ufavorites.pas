unit Ufavorites;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, ExtCtrls, StdCtrls, strings,DB, ImgList,
  GR32_Image, Menus, Tntforms, TntExtCtrls, TntButtons, TntStdCtrls,
  TntMenus,Tntgraphics, TntComCtrls, VirtualTrees;

type
  TFfavorites = class(TTntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SpeedButton1: TTntSpeedButton;
    Edit1: TTntEdit;
    Edit2: TTntEdit;
    Bevel3: TBevel;
    Label4: TTntLabel;
    Bevel4: TBevel;
    Label2: TTntLabel;
    Label3: TTntLabel;
    Label5: TTntLabel;
    Bevel5: TBevel;
    BitBtn1: TTntBitBtn;
    ImageList1: TImageList;
    Image321: TImage32;
    Image3210: TImage32;
    Image322: TImage32;
    PopupMenu1: TPopupMenu;
    selectall1: TMenuItem;
    invertselection1: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    N2: TMenuItem;
    Open1: TMenuItem;
    VirtualStringTree2: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure selectall1Click(Sender: TObject);
    procedure invertselection1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
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
    procedure showfavorites;
  end;

var
  Ffavorites: TFfavorites;

implementation

uses Umain, UData;

{$R *.dfm}

procedure Tffavorites.showfavorites;
var
Blobstream:Tstream;
bmp:Tbitmap;
x,y:integer;
begin
Datamodule1.Qfavorites.Close;
Datamodule1.Qfavorites.SQL.Clear;
Datamodule1.Qfavorites.sql.Add('SELECT * FROM Favorites');

Datamodule1.Qfavorites.sql.Add(Fmain.sqlsortcolumn(VirtualStringTree2));
Datamodule1.Qfavorites.Open;

ImageList1.Clear;
imagelist1.bkcolor:=VirtualStringTree2.Color;

Datamodule1.Tfavorites.open;
Datamodule1.Qfavorites.first;

While Datamodule1.Qfavorites.Eof=false do begin
  bmp:=Tbitmap.Create;

  try

    BlobStream := Datamodule1.Qfavorites.CreateBlobStream(Datamodule1.Qfavorites.FieldByName('Icon'),bmRead);

    if Blobstream.Size<>0 then begin
      bmp.LoadFromStream(BlobStream);

      //Convert to listview bgcolor
      for x:=0 to 15 do
        for y:=0 to 15 do
          if bmp.Canvas.Pixels[x,y]=clblack then
            bmp.Canvas.Pixels[x,y]:=VirtualStringTree2.Color;

      ImageList1.addmasked(bmp,VirtualStringTree2.color);
    end;

  finally
    try
      Freeandnil(bmp);
    except
    end;
    try
      Freeandnil(Blobstream);
    except
    end;
  end;

  Datamodule1.Qfavorites.next;
end;

VirtualStringTree2.rootnodecount:=0;//FIX INDETERMINATED
VirtualStringTree2.rootnodecount:=Datamodule1.Qfavorites.RecordCount;
VirtualStringTree2.Repaint;
end;

procedure TFfavorites.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Ffavorites);
virtualstringtree2.Header.SortColumn:=0;
virtualstringtree2.header.SortDirection:=sdAscending;

if colorcolumns=true then
  VirtualStringTree2.Header.Columns[0].Color:=clBtnFace;
end;

procedure TFfavorites.FormShow(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
  
caption:=traduction(493);

Fmain.setgridlines(VirtualStringTree2,ingridlines);

label1.Caption:=traduction(494);
Fmain.labelshadow(label1,FFavorites);
label2.Caption:=traduction(496);
label3.Caption:=traduction(11)+' :';
label4.Caption:=traduction(497);
label5.Caption:=traduction(18)+' :';

VirtualStringTree2.header.Columns[0].text:=traduction(11);
VirtualStringTree2.header.Columns[1].text:=traduction(18);
VirtualStringTree2.header.Columns[2].text:=traduction(20);

selectall1.Caption:=UTF8Encode(traduction(40));
invertselection1.Caption:=UTF8Encode(traduction(41));
Open1.Caption:=UTF8Encode(traduction(504));
Delete1.Caption:=UTF8Encode(traduction(33));

bitbtn1.Caption:=traduction(217);

speedbutton1.Hint:=traduction(495);

showfavorites;
posintoindex(0,VirtualStringTree2);
end;

procedure TFfavorites.BitBtn1Click(Sender: TObject);
begin
close;
end;

procedure TFfavorites.SpeedButton1Click(Sender: TObject);
var
desc:widestring;
FileStream: Tfilestream;
BlobStream: TStream;
iconoutdir:ansistring;
newurl:widestring;
bmp:Tbitmap;
begin
iconoutdir:=tempdirectoryresources+'savefav.bmp';

newurl:=edit2.text;

desc:=edit1.Text;
desc:=trim(desc);

if desc='' then
  desc:='---';

try

  if Datamodule1.Qfavorites.Locate('URL',newurl,[loCaseInsensitive])=false then
    Datamodule1.Tfavorites.append
  else begin
    Datamodule1.Tfavorites.Locate('URL',newurl,[loCaseInsensitive]);
    Datamodule1.Tfavorites.edit;
  end;

  setwiderecord(Datamodule1.Tfavorites.fieldbyname('Url'),newurl);
  setwiderecord(Datamodule1.Tfavorites.fieldbyname('Description'),desc);
  Datamodule1.Tfavorites.FieldByName('added').AsDateTime:=now;

  image322.Bitmap.SaveToFile(iconoutdir);

  //TRIM FIX
  bmp:=Tbitmap.Create;
  bmp.LoadFromFile(iconoutdir);

  if bmp.Height<>16 then
    bmp.Height:=16;

  if bmp.width<>16 then
    bmp.Width:=16;

  bmp.SaveToFile(iconoutdir);

  bmp.free;

  BlobStream := Datamodule1.Tfavorites.CreateBlobStream(Datamodule1.Tfavorites.FieldByName('Icon'),bmWrite);
  FileStream := TFileStream.Create(iconoutdir,fmOpenRead or fmShareDenyNone);
  BlobStream.CopyFrom(FileStream,FileStream.Size);

  FileStream.Free;
  BlobStream.Free;

  Datamodule1.Tfavorites.Post;
  
  Datamodule1.Tfavorites.close;
  Datamodule1.Tfavorites.open;

  showfavorites;

  Datamodule1.Qfavorites.Locate('URL',newurl,[loCaseInsensitive]);

  posintoindex(Datamodule1.Qfavorites.RecNo-1,VirtualStringTree2);

except
  Datamodule1.Tfavorites.cancel;
end;

deletefile(iconoutdir);
end;

procedure TFfavorites.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
Datamodule1.Qfavorites.Close;
end;

procedure TFfavorites.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFfavorites.selectall1Click(Sender: TObject);
begin
VirtualStringTree2.SelectAll(false);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFfavorites.invertselection1Click(Sender: TObject);
begin
VirtualStringTree2.InvertSelection(false);

freemousebuffer;
freekeyboardbuffer;

end;

procedure TFfavorites.Open1Click(Sender: TObject);
var
x:integer;
n:PVirtualNode;
begin
if VirtualStringTree2.SelectedCount=0 then
  exit;

Ffavorites.Enabled:=false;

n:=VirtualStringTree2.GetFirst;
for x:=0 to VirtualStringTree2.rootnodecount-1 do begin
  if VirtualStringTree2.selected[n]=true then begin
    try
      Datamodule1.Qfavorites.RecNo:=x+1;
      Fmain.wb_navigate(getwiderecord(Datamodule1.Qfavorites.fieldbyname('Url')),true,true);
    except
    end;
  end;
  n:=VirtualStringTree2.getnext(n);
end;


FFavorites.Enabled:=true;

freemousebuffer;
freekeyboardbuffer;
end;


procedure TFfavorites.Delete1Click(Sender: TObject);
var
x,pos:integer;
n:PVirtualNode;
begin
if VirtualStringTree2.SelectedCount=0 then
  exit;

pos:=-1;

Ffavorites.Enabled:=false;

n:=VirtualStringTree2.GetFirst;
for x:=0 to VirtualStringTree2.rootnodecount-1 do begin
  if VirtualStringTree2.selected[n]=true then begin
    VirtualStringTree2.selected[n]:=false;
    try

      Datamodule1.Qfavorites.RecNo:=x+1;
      Datamodule1.Qfavorites.Delete;

      if pos=-1 then
        pos:=x;

    except
    end;
  end;

  n:=VirtualStringTree2.GetNext(n);
end;

if pos<>-1 then
  pos:=pos-1;

if pos<0 then
  pos:=0;

showfavorites;

Ffavorites.Enabled:=true;

posintoindex(pos,VirtualStringTree2);
if VirtualStringTree2.SelectedCount=0 then
  posintoindexbynode(VirtualStringTree2.getfirst,VirtualStringTree2);

freemousebuffer;
freekeyboardbuffer;

end;

procedure TFfavorites.PopupMenu1Popup(Sender: TObject);
var
b:boolean;
begin
Fmain.destroycustomhint;
b:=true;
if VirtualStringTree2.SelectedCount=0 then
  b:=false;

open1.Enabled:=b;
Delete1.Enabled:=b;
end;

procedure TFfavorites.VirtualStringTree2HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
if HitInfo.Button <> mbLeft then
  exit;
  
if updatinglist=true then
  exit;

if hitinfo.Column=-1 then
  exit;

//RARE BUT FIX A PROBLEM SELECTED COLUMN PRESSED
//SendMessage(VirtualStringTree2.Handle, WM_LBUTTONUP, 0, 0);

Fmain.sortcolumn(VirtualStringTree2,hitinfo.column);
showfavorites;
posintoindexbynode(VirtualStringTree2.getfirst,VirtualStringTree2);
end;

procedure TFfavorites.VirtualStringTree2DblClick(Sender: TObject);
begin
if updatinglist=false then
  Open1Click(sender);
end;

procedure TFfavorites.VirtualStringTree2GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
if Datamodule1.Qfavorites.RecNo<>node.Index+1 then
  Datamodule1.Qfavorites.RecNo:=node.Index+1;

case column of
  0:celltext:=getwiderecord(Datamodule1.Qfavorites.fieldbyname('Description'));
  1:celltext:=getwiderecord(Datamodule1.Qfavorites.fieldbyname('Url'));
  2:celltext:=Datamodule1.Qfavorites.fieldbyname('Added').asstring;
end;

end;

procedure TFfavorites.VirtualStringTree2GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin

if column=0 then begin

  if Datamodule1.Qfavorites.RecNo<>node.Index+1 then
    Datamodule1.Qfavorites.RecNo:=node.Index+1;

  if kind<>ikOverlay then begin
    ImageIndex:=node.index;
  end;

end;

end;

procedure TFfavorites.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
