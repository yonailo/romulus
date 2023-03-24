unit Uscene;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, TntComCtrls, Buttons, TntButtons,Tntforms,
  TntStdCtrls,strings, mymessages, tntsysutils, tntfilectrl, Gptextfile,Uscan, DB,Absmain,
  RxRichEd;

type
  TFscene = class(TTntform)
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntEdit1: TTntEdit;
    TntSpeedButton1: TTntSpeedButton;
    TntBitBtn1: TTntBitBtn;
    TntBitBtn2: TTntBitBtn;
    RxRichEdit1: TRxRichEdit;
    procedure FormShow(Sender: TObject);
    procedure TntBitBtn1Click(Sender: TObject);
    procedure TntSpeedButton1Click(Sender: TObject);
    procedure TntBitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fscene: TFscene;

implementation

uses Umain, UData;

{$R *.dfm}

procedure TFscene.FormShow(Sender: TObject);
var
path:widestring;
begin
Fmain.addtoactiveform((sender as Tform),true);

Datamodule1.Tprofiles.Locate('ID',Fmain.getcurrentprofileid,[]);
if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([Datamodule1.Tprofiles.fieldbyname('ID').asinteger,'0']),[])=true then 
  path:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));

Rxrichedit1.Lines.Add('When you press start all the files found in origin and correspond to the names found in this profile "'+getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+'" will be copied in the path "'+path+'"'+#13#10);
end;

procedure TFscene.TntBitBtn1Click(Sender: TObject);
var
source,filelistpath,line,filename,aux,destination:widestring;
Master,Detail:TABSTable;
profileid:string;
added:boolean;
csets,croms:longint;
begin
added:=false;
source:=tntedit1.Text;
source:=checkpathbar(source);

if widedirectoryexists(source)=false then begin
  mymessageerror('Source path does not exists');
  exit;
end;

profileid:=Fmain.getcurrentprofileid;

if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([profileid,'0']),[])=false then begin
  mymessageerror('Romspath is not defined for the current profile');
  exit;
end;

destination:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
destination:=checkpathbar(destination);

if WideDirectoryExists(destination)=false then begin
  mymessageerror('Destination path does not exists');
  exit;
end;

if wideuppercase(destination)=wideuppercase(source) then begin
  mymessageerror('Source path and ROMs path are the same');
  exit;
end;

tntbitbtn1.Enabled:=false;
tntbitbtn2.Enabled:=true;
TntSpeedButton1.Enabled:=false;

rxrichedit1.Lines.add('Search files in '+source+#13#10);
ScrollToEnd(rxrichedit1);
application.ProcessMessages;

filelistpath:=tempdirectoryresources+'files.rmt';

listfiles:=TGpTextFile.CreateW(filelistpath);
listfiles.Rewrite([cfUnicode]);

Fmain.Scandirectory(source,'*.*',2,true);
listfiles.Close;
Freeandnil(listfiles);

listfiles:=TGpTextFile.Createw(filelistpath);
listfiles.Reset;

rxrichedit1.Lines.add('Comparing files ...'+#13#10);
scrolltoend(rxrichedit1);
application.ProcessMessages;

Master:=TABSTable.Create(self);
Master.DatabaseName:=Datamodule1.DBDatabase.DatabaseName;
Master.TableName:='Y'+profileid;
Master.Open;

Detail:=TABSTable.Create(self);
Detail.DatabaseName:=Datamodule1.DBDatabase.DatabaseName;
Detail.TableName:='Z'+profileid;
Detail.Open;

while listfiles.EOF=false do begin
  application.ProcessMessages;
  if tntbitbtn2.Tag=1 then
    break;
  
  line:=listfiles.Readln;
  filename:=WideExtractFileName(line);
  if filename<>'' then
    if Detail.Locate('Romname',filename,[locaseinsensitive])=true then
      if Master.Locate('ID',Detail.fieldbyname('Setnamemaster').asinteger,[])=true then begin
        aux:=destination+getwiderecord(Master.FieldByName('Gamename'))+'\';
        if widefileexists(aux+filename)=true then
          rxrichedit1.Lines.add('[WARNING] File "'+line+'" already exists in destination "'+aux+filename+'"'+#13#10)
        else begin
          try
            WideForceDirectories(aux);
            aux:=aux+filename;
            TurboCopyFile(line,aux);
            rxrichedit1.Lines.add('[OK] File "'+line+'" was copied to "'+aux+'"'+#13#10);
            Detail.Edit;
            Detail.fieldbyname('Have').AsBoolean:=true;
            Detail.Post;
            added:=true;
          except
            rxrichedit1.Lines.add('[ERROR] Copying file "'+line+'" to "'+aux+'"'+#13#10);
          end;
        end;
        scrolltoend(rxrichedit1);
      end;

end;

listfiles.Close;
Freeandnil(listfiles);
aux:='';

tntbitbtn2.Enabled:=false;

if added=true then begin
  RxRichEdit1.Lines.add('Updating lists ...'+#13#10);
  scrolltoend(rxrichedit1);
  application.ProcessMessages;

  Datamodule1.Tprofiles.Locate('ID',profileid,[]);
  filelistpath:=getcounterfilemode(Master.tablename,Detail.tablename,Datamodule1.Tprofiles.fieldbyname('Filemode').AsInteger,false);

  csets:=strtoint(gettoken(filelistpath,'/',1));
  croms:=strtoint(gettoken(filelistpath,'/',3));

  Datamodule1.Tprofiles.edit;
  Datamodule1.Tprofiles.FieldByName('Havesets').asinteger:=csets;
  Datamodule1.Tprofiles.FieldByName('Haveroms').asinteger:=croms;
  Datamodule1.Tprofiles.FieldByName('Totalsets').asinteger:=strtoint(gettoken(filelistpath,'/',2));
  Datamodule1.Tprofiles.FieldByName('Totalroms').asinteger:=strtoint(gettoken(filelistpath,'/',4));
  Datamodule1.Tprofiles.FieldByName('Lastscan').AsDateTime:=now;
  Datamodule1.Tprofiles.post;

  Fmain.showprolesmasterdetail(true,true,profileid,false,false);
  aux:='. Is highly recommended to scan profile to check if new files are the correct';
end;

if tntbitbtn2.Tag=1 then
  RxRichEdit1.Lines.add('Process cancelled by user'+aux+#13#10)
else
  RxRichEdit1.Lines.add('Process finished'+aux+#13#10);

scrolltoend(rxrichedit1);

tntbitbtn1.Enabled:=true;
TntSpeedButton1.Enabled:=true;

Freeandnil(Master);
Freeandnil(Detail);
end;

procedure TFscene.TntSpeedButton1Click(Sender: TObject);
var
fold:widestring;
begin
if WideSelectDirectory('Source folder','',fold) then
  tntedit1.Text:=fold;
end;

procedure TFscene.TntBitBtn2Click(Sender: TObject);
begin
tntbitbtn2.Tag:=1;
tntbitbtn2.Enabled:=false;
end;

procedure TFscene.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFscene.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFscene.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fscene);
end;

end.
