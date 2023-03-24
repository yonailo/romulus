unit Uupdater;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Umain, Buttons, dbcgrids, ComCtrls, strings,
  ImgList, DBCtrls, DB, Shellapi, BMDThread, AppEvnts, GR32_Image, Tntforms,
  TntExtCtrls, TntButtons, TntStdCtrls, TntComCtrls, Tntgraphics, TntSysutils,
  VirtualTrees, tntclasses, ewbtools, Menus,Gptextfile,Uupdatedat,importation, Uencrypt;

type
  TFupdater = class(TTntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SpeedButton1: TTntSpeedButton;
    BitBtn1: TTntBitBtn;
    Label2: TTntLabel;
    Panel2: TTntPanel;
    Panel3: TTntPanel;
    SpeedButton2: TTntSpeedButton;
    SpeedButton3: TTntSpeedButton;
    SpeedButton4: TTntSpeedButton;
    Panel18: TTntPanel;
    Panel4: TTntPanel;
    Panel5: TTntPanel;
    BMDThread1: TBMDThread;
    Panel6: TTntPanel;
    SpeedButton5: TTntSpeedButton;
    SpeedButton6: TTntSpeedButton;
    SpeedButton7: TTntSpeedButton;
    ImageList1: TImageList;
    Image322: TImage32;
    TntComboBox1: TTntComboBox;
    VirtualStringTree1: TVirtualStringTree;
    TntPanel1: TTntPanel;
    ProgressBar2: TProgressBar;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    PopupMenu1: TPopupMenu;
    Openwithintegratednavigator1: TMenuItem;
    Openwithdefaultnavigator1: TMenuItem;
    Updatedat1: TMenuItem;
    N2: TMenuItem;
    TntComboBox2: TTntComboBox;
    TntSpeedButton1: TTntSpeedButton;
    Bevel3: TBevel;
    Bevel11: TBevel;
    Image1: TImage;
    N1: TMenuItem;
    Selectall1: TMenuItem;
    Invertselection1: TMenuItem;
    Updatedatnoprompt1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BMDThread1Execute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BMDThread1Start(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BMDThread1Terminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure BMDThread1Update(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer; Percent: Integer);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure TntComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TntComboBox1Change(Sender: TObject);
    procedure VirtualStringTree1DblClick(Sender: TObject);
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
    procedure Openwithintegratednavigator1Click(Sender: TObject);
    procedure Openwithdefaultnavigator1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Updatedat1Click(Sender: TObject);
    procedure TntSpeedButton1Click(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Invertselection1Click(Sender: TObject);
    procedure Updatedatnoprompt1Click(Sender: TObject);
  private
    { Private declarations }
    pbpos:integer;
  public
    { Public declarations }
    procedure TraductFupdater;
    procedure processupdatefinder;
    procedure processupdatefindernew;
    procedure showupdates;
    procedure checkpanelstatus;
    function findnameversion(group:integer;description,vers,date:ansistring;typ:string):integer;
    procedure messageoffline( Sender : TObject );

  end;

var
  Fupdater: TFupdater;

implementation

uses UData, ListActns, Uofflineupdate, Ulog, Uscan, Uprocessing;

{$R *.dfm}

procedure Tfupdater.messageoffline( Sender : TObject );
begin
tntlabel1.Caption:=traduction(364)+' Offlinelist [ '+inttostr(Datamodule1.Qaux.RecNo)+' / '+inttostr(Datamodule1.Qaux.RecordCount)+' ]';
Fmain.labelshadow(tntlabel1,Fupdater);
end;

function Tfupdater.findnameversion(group:integer;description,vers,date:ansistring;typ:string):integer;
var
res:integer;
foundversion:ansistring;
next:boolean;
//x:integer;
begin
//0 No 1 Outdated 2 Uptodate
{CHANGES SINZE 0.017
param group is index of dat group
param date is dat field to correct detect of yori dats

for group 2 is redump.org check for field author as redump.org to know if is redump.org dat
for group 1 is no-intro check for field author different of redump.org to know is no-intro
}

res:=0;

description:=trim(description);
//SAME AS FOUNDVERSION VAR

vers:=Wideuppercase(vers);
vers:=changein(vers,'(','');
vers:=changein(vers,')','');
vers:=changein(vers,'-','');
vers:=changein(vers,'/','');
vers:=changein(vers,'\','');
vers:=changein(vers,' ','');
vers:=trim(vers);

try
  vers:=inttostr(strtoint64(vers));
except
end;


if Datamodule1.Qaux.Locate('Name',description,[loCaseInsensitive]) then
  while not Datamodule1.Qaux.Eof do begin

    if Wideuppercase(Datamodule1.Qaux.fieldbyname('Name').asstring)<>Wideuppercase(description) then
      break;

    {next:=false; //REMOVED TO IGNORE DAT TYPE
    for x:=1 to gettokencount(typ,';') do
      if Datamodule1.Qaux.FieldByName('Original').asstring=gettoken(typ,';',x) then
        next:=true;       }

    next:=false;

    if vers<>'' then
      next:=true;

    {
     0 TOSEC ROMS
     1 NO-INTRO
     2 REDUMP
     3 POCKET HEAVEN (SECURE)
     4 ARCADE(SECURE)
     5 PINBALL (SECURE)
     6 FRUIT MACHINES (SECURE)
     7 TOSEC ISO
     8 TOSEC PIX
     9 NONGOOD (SECURE)
     10 UNRENAMED (SECURE)
     11
     12 TRURIP
     13 TRURIP SUPERDAT (SECURE)
     14 RAWDUMP
    }

    if next=true then
    if (group=0) OR (group=7) OR (group=8) then begin //TOSEC OK
      next:=false;
      if gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Description').AsString),'(TOSEC-')>1 then
        next:=true;
    end
    else
    if group=2 then begin//REDUMP OK
      next:=false;
      if gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Author').AsString),'REDUMP.ORG')>1 then
        next:=true;
    end
    else
    if group=1 then begin//NO-INTRO
      next:=false;                                                                                                                                                                                                                                                                                                          //REMOVED ??? AND (gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Description').AsString),'AUTHOR')<=1)
      if (gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Author').AsString),'REDUMP.ORG')<=1) AND (gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Author').AsString),'TRURIP DAT GENERATOR')<=1) AND (gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Description').AsString),'(TOSEC-')<=1) then
        next:=true;
    end;{//REM 0.046
    else
    if (group=12) OR (group=13) then begin //TRURIP NORMAL & SUPER DATS  OK
      next:=false;
      if (gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Author').AsString),'TRURIP DAT GENERATOR')>1) OR (gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Author').AsString),'TRURIP SUPERDAT GENERATOR')>1)then
        next:=true;
    end
    else
    if group=14 then begin //RAWDUMP OK
      next:=false;
      if gettokencount(Wideuppercase(Datamodule1.Qaux.fieldbyname('Author').AsString),'RAWDUMP')>1 then
        next:=true;
    end; }

    if next=true then begin

      //Possible bugfixes when search versions
      //SAME AS VERS VAR
      //if group=14 then //FIX RAWDUMP  RAM 0.046
      //  foundversion:=Datamodule1.Qaux.fieldbyname('date').asstring
      //else
      foundversion:=Datamodule1.Qaux.fieldbyname('version').asstring;

      foundversion:=Wideuppercase(foundversion);
      foundversion:=changein(foundversion,'(','');
      foundversion:=changein(foundversion,')','');
      foundversion:=changein(foundversion,'-','');
      foundversion:=changein(foundversion,'/','');
      foundversion:=changein(foundversion,'\','');
      foundversion:=changein(foundversion,' ','');
      foundversion:=trim(foundversion);

      try
        foundversion:=inttostr(strtoint64(foundversion));
      except
      end;

      res:=1;
      if (foundversion=vers) then begin
                          //IGNORE DATSCENE DATE PARAM
        if (date='') OR (group=21) OR (group=22) then begin
          res:=2;
          break;
        end
        else //DATE PARAM DETECTION FOR YORI DATS
        if date=Datamodule1.Qaux.FieldByName('Date').AsString then begin
          res:=2;
          break;
        end;

      end;
    end;
    Datamodule1.Qaux.Next;
  end;

Result:=res;
end;

function dattypetodescription(typ:string):ansistring;
var
y:integer;
begin
Result:='';
for y:=0 to updatercount-1 do
  if typ=updaterdescription(y,false) then begin
    Result:=updaterdescription(y,true);
    break;
  end;

end;

procedure Tfupdater.checkpanelstatus;
var
vis,vis2,vis3,vis4:boolean;
begin
vis:=false;
vis2:=false;
vis3:=false;
vis4:=true;

if Datamodule1.DBUpdater.Connected=false then begin
  tntlabel1.Caption:=traduction(357);   //PRESS TO BEGIN
  Fmain.labelshadow(tntlabel1,Fupdater);

  vis:=True;
  vis2:=true;
  vis4:=false;
end
else
if (speedbutton2.Down=False) AND (Speedbutton3.Down=False) AND (speedbutton4.Down=false) then begin
  tntlabel1.Caption:=traduction(10);   //AT LEAST
  Fmain.labelshadow(tntlabel1,Fupdater);
  
  vis:=true;
  vis3:=true;
  vis4:=false;
end
else
if Datamodule1.Qupdater.RecordCount=0 then begin
  tntlabel1.Caption:=traduction(354);   //NO INFO
  Fmain.labelshadow(tntlabel1,Fupdater);
  
  vis:=true;
  vis4:=false;
end;

panel6.Visible:=vis3;
panel3.Visible:=vis;
progressbar2.Visible:=vis2;
VirtualStringTree1.Visible:=vis4;
end;


procedure Tfupdater.showupdates;
var
sql,aux:ansistring;
w,s:boolean;
x:integer;
comp,incomp,empty:integer;
begin
comp:=0;
incomp:=0;
empty:=0;

if (Datamodule1.Tupdater.IsEmpty=true) OR (speedbutton1.Enabled=false) then begin
  exit;
end;

if (speedbutton2.Down=False) AND (Speedbutton3.Down=False) AND (speedbutton4.Down=false) then begin
  checkpanelstatus;
  exit;
end;

VirtualStringTree1.rootnodecount:=0;//FIX INDETERMINATED
VirtualStringTree1.BeginUpdate;

Datamodule1.Qupdater.close;
Datamodule1.Qupdater.SQL.Clear;
Datamodule1.Qupdater.SQL.Text:='SELECT * FROM Updater ORDER BY Status';
Datamodule1.Qupdater.open;
{
0
0
1
1
2
2
}

empty:=Datamodule1.Qupdater.RecordCount;
if Datamodule1.Qupdater.Locate('Status',2,[])=true then
  comp:=(empty-Datamodule1.Qupdater.RecNo)+1;
if Datamodule1.Qupdater.Locate('Status',1,[])=true then
  incomp:=(empty-Datamodule1.Qupdater.RecNo-comp)+1;
empty:=empty-incomp-comp;

Datamodule1.Qupdater.close;
Datamodule1.Qupdater.SQL.Clear;

w:=False;
if tntcombobox1.ItemIndex>0 then begin
  sql:='WHERE Type = '+inttostr(strtoint(gettoken(TntComboBox1.Items.Strings[tntcombobox1.itemindex],'"',2))-1);
  w:=true;
end;

if (speedbutton2.Down=false) OR (speedbutton3.Down=false) OR (speedbutton4.Down=false) then begin
  s:=False;
  if w=false then
    sql:='WHERE '
  else begin
    sql:=sql+' AND (';
    s:=true;
  end;

  w:=false;
  if speedbutton2.Down=true then begin
    sql:=sql+'Status = 2 ';
    w:=true;
  end;

  if speedbutton3.Down=true then begin
    if w=true then
      sql:=sql+'OR ';

    sql:=Sql+'Status = 1 ';
    w:=True;
  end;

  if speedbutton4.Down=true then begin
    if w=true then
      sql:=sql+'OR ';
    sql:=sql+'Status = 0';
  end;

  if s=true then
    sql:=Sql+')';
end;

Datamodule1.Qupdater.SQL.Add('SELECT * FROM Updater '+sql);

for x:=0 to VirtualStringTree1.Header.Columns.count-1 do
  if virtualstringtree1.Header.Columns[x].Tag<>0 then begin
    aux:='';
    case x of
      0:aux:='name';
      1:aux:='version';
      2:aux:='description';
      3:aux:='url';
    end;
    aux:='ORDER BY '+aux;
    if virtualstringtree1.Header.Columns[x].tag=1 then
      aux:=aux+' ASC'
    else
      aux:=aux+' DESC';
  end;

Datamodule1.Qupdater.SQL.Add(aux);

//ARCADE = TYPE = 4
Datamodule1.Qupdater.open;

VirtualStringTree1.rootnodecount:=datamodule1.Qupdater.RecordCount;

VirtualStringTree1.EndUpdate;

panel18.caption:=fillwithzeroes(inttostr(comp),4);
panel4.caption:=fillwithzeroes(inttostr(incomp),4);
panel5.caption:=fillwithzeroes(inttostr(empty),4);

//listview1.ClearSelection;
//listview1.ItemIndex:=0;
//  (obj as TTntlistview).Items[ind].MakeVisible(true);
//  (obj as TTntlistview).ItemFocused:=(obj as TTntlistview).Items.Item[ind];
posintoindexbynode(VirtualStringTree1.getfirst,VirtualStringTree1); //UNLIKE EFFECT

checkpanelstatus;

freemousebuffer;
freekeyboardbuffer;
end;

procedure tfupdater.processupdatefindernew;
//const
//urlpath='https://www.dropbox.com/s/86sa0ap0u0g1e0p/global.xml.zip?dl=1'
//urlpath='https://www.dropbox.com/s/xm1qm4iqopxki4w/global.xml.zip?dl=1'; //REMOVED
var
x,y:integer;
offlinetoo:boolean;
datgroupstemp:Tstringlist;
f:TGpTextFile;
r:widestring;
pr,content:widestring;
groupread:boolean;
currgroupid:integer;
cnt,sta:integer;
downl1,downl2,cad,version,group,date,urlpath,extraurl:ansistring;
begin
urlpath:=Decryptnoserver('D916CC2CFD183C3F28F20BEB748CB845D45EA34830FE0F152AC9BE9BB04DC0A440DD6F8DD36FE62130C996A950D254DC27013FC14F14E01EC865A87CD75D');
cnt:=0;
pbpos:=0;
sterrors.clear;
offlinetoo:=false; //Check for offlinelist
currgroupid:=-1;

groupread:=true;
datgroupstemp:=Tstringlist.Create;
datgroupstemp.Sorted:=true; //SPEEDUP

//templist.Sorted:=true; //NEVER MUST SORT


for x:=1 to tntcombobox1.Items.Count-1 do begin
  content:=gettoken(tntcombobox1.items.strings[x],'"',1);//DATGROUP NAME
  datgroupstemp.Add(content);

  if gettoken(tntcombobox1.items.strings[x],'"',2)='12' then //CHANGED 0.050
    offlinetoo:=true;
end;

Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Add('SELECT * FROM Profiles');
Datamodule1.Qaux.SQL.Add('ORDER BY Name,Original');
//SORTING BY NAME AND DAT TYPE

Datamodule1.Qaux.Open;

deletefile2(tempdirectoryupdater);

DataModule1.DBUpdater.Close;
DataModule1.DBUpdater.DatabaseFileName:=UTF8Encode(tempdirectoryupdater);
DataModule1.DBUpdater.PageCountInExtent:=defpagecountinextent;
DataModule1.DBUpdater.PageSize:=defpagesize;
DataModule1.DBUpdater.MaxConnections:=defmaxconnections;
DataModule1.DBUpdater.SilentMode:=true;
Datamodule1.DBUpdater.CreateDatabase;

Datamodule1.Tupdater.close;
Datamodule1.Tupdater.FieldDefs.Clear;
Datamodule1.Tupdater.TableName:='Updater';
Datamodule1.Tupdater.FieldDefs.Add('I',ftAutoInc,0,False);
Datamodule1.Tupdater.FieldDefs.Add('Description',ftString,255,false);
Datamodule1.Tupdater.FieldDefs.Add('Name',ftString,255,True);
Datamodule1.Tupdater.FieldDefs.Add('Version',ftString,255,false);
Datamodule1.Tupdater.FieldDefs.Add('Type',ftInteger,0,True);
Datamodule1.Tupdater.FieldDefs.Add('Date_',ftString,255,false);
Datamodule1.Tupdater.FieldDefs.Add('Url',ftString,255,false);
Datamodule1.Tupdater.FieldDefs.Add('Status',ftinteger,0,True);
Datamodule1.Tupdater.FieldDefs.Add('Downurl',ftString,255,false);

Datamodule1.Tupdater.IndexDefs.Clear;
Datamodule1.Tupdater.IndexDefs.Add('I1', 'I', [ixPrimary]); //Speedup locate
Datamodule1.Tupdater.IndexDefs.Add('I2','Name', [ixCaseInsensitive]);
Datamodule1.Tupdater.IndexDefs.Add('I3','Url', []);
Datamodule1.Tupdater.IndexDefs.Add('I4','Type', []);
Datamodule1.Tupdater.IndexDefs.Add('I5','Status', []);

Datamodule1.Tupdater.CreateTable;
Datamodule1.Tupdater.open;

Datamodule1.DBUpdater.StartTransaction;
forzeversion:='';

try

  deletefile2(tempdirectoryupdates);
  if Fmain.DownLoadFile2(urlpath,tempdirectoryupdates,false)=true then begin //0

    if Fmain.zipvalidfile(tempdirectoryupdates,Fmain.zip1)=true then begin //1

      if Fmain.extractfilefromzip(Fmain.zip1,stcompfiles.strings[0],tempdirectoryextractvar,false) then  begin//2

        //showmessage(tempdirectoryextractvar+stcompfiles.strings[0]);
        f:=TGpTextFile.CreateW(tempdirectoryextractvar+stcompfiles.strings[0]);
        f.reset;
        while f.eof=false do begin
          f.Readln;
          cnt:=cnt+1;
        end;

        ProgressBar2.Max:=cnt;
        f.reset;

        while f.EOF=false do begin //GLOBAL.XLM PARSER START
          pbpos:=pbpos+1;
          r:=trim(f.Readln);

          pr:=gettoken(r,'>',1);
          content:=gettoken(r,pr+'>',2);
          content:=gettoken(content,'</',1);
          content:=fixxmlseparators(content);

          //showmessage(pr);
          if (pr='<datfile') or (pr='<softwarelist') or (pr='<hashfile') then begin
            Datamodule1.Tupdater.append;
            groupread:=false;
            date:='';
          end
          else
          if (pr='</datfile') OR (pr='</softwarelist') OR (pr='</hashfile') then begin
            if currgroupid<>-1 then begin
              if (forzeversion<>'') AND  (Datamodule1.Tupdater.fieldbyname('version').asstring='') then
                Datamodule1.Tupdater.fieldbyname('version').asstring:=forzeversion;

              Datamodule1.Tupdater.fieldbyname('type').asinteger:=currgroupid;                                                                                                                                       //
              Datamodule1.Tupdater.fieldbyname('status').asinteger:=findnameversion(currgroupid,Datamodule1.Tupdater.fieldbyname('name').asstring,Datamodule1.Tupdater.fieldbyname('version').asstring,Datamodule1.Tupdater.fieldbyname('date_').asstring,'X;C');;
              //Datamodule1.Tupdater.fieldbyname('status').asinteger:=0;
              Datamodule1.Tupdater.fieldbyname('url').asstring:=extraurl;
              Datamodule1.Tupdater.post;
            end
            else
              Datamodule1.Tupdater.cancel;

            groupread:=true;
          end
          else
          if pr='<description' then
            Datamodule1.Tupdater.fieldbyname('description').asstring:=content
          else
          if pr='<name' then
            Datamodule1.Tupdater.fieldbyname('name').asstring:=content
          else
          if pr='<version' then
            Datamodule1.Tupdater.fieldbyname('version').asstring:=content
          else
          if pr='<date' then
            Datamodule1.Tupdater.fieldbyname('date_').asstring:=content
          else
          if pr='<url' then begin
            if extraurl='' then
              extraurl:=content;
          end
          else
          if (pr='<downloadUrl') OR (pr='<extra name="downloadUrl"') then begin
            Datamodule1.Tupdater.fieldbyname('downurl').asstring:=content;
            //showmessage(content);
          end
          else
          if groupread=true then begin
            extraurl:='';
            forzeversion:='';
            pr:=changein(pr,'<','');
            pr:=changein(pr,' collection=',' - ');
            

            if gettokencount(pr,' version="')>1 then begin
              forzeversion:=gettoken(pr,' version="',gettokencount(pr,' version="'));
              forzeversion:=gettoken(forzeversion,'"',1);
              if gettokencount(forzeversion,'.')=1 then
                forzeversion:='0.'+forzeversion; //SOFTLIST CORRECTION
            end;

            extraurl:=pr;
            //showmessage(extraurl);
            pr:=gettoken(pr,' version="',1);
            pr:=changein(pr,'"','');
            pr:=changein(pr,'_',' ');

            //0.047
            if gettokencount(extraurl,' url="')>1 then begin
              extraurl:=gettoken(extraurl,' url="',2);
              extraurl:=gettoken(extraurl,'"',1);
              pr:=gettoken(pr,' url=',1);
            end
            else
              extraurl:='';

            if changein(wideuppercase(pr),'CONNIE - FINALBURN','')<>wideuppercase(pr) then begin

              pr:=updaterdescription(24,true);//Connie Finalburn NEO
              pr:='Connie - FinalBurn Neo';
            end
            else
            if changein(wideuppercase(pr),'GRUBY-S','')<>wideuppercase(pr) then begin //FIX
              pr:=changein(pr,'Gruby-s','Gruby'+''''+'s');
            end;

            pr:=gettoken(pr,' dat count=',1);//FIX IN 0.050
            y:=datgroupstemp.IndexOf(pr);
            //showmessage(pr);
            //if pr='TOSEC - ISO
            if y<>-1 then begin
              for x:=0 to updatercount-1 do
                if uppercase(updaterdescription(x,true))=uppercase(pr) then begin
                  currgroupid:=strtoint(updaterdescription(x,false));
                  //showmessage(pr);
                  break;
                end;

            end
            else
              currgroupid:=-1;
          end;

        end; //GLOBAL.XLM PARSER END

        f.Close;
      end;//2

    end; //1

    //UPDATE VIEW


  end;
except
    { on E : Exception do
     begin
       ShowMessage('Exception class name = '+E.ClassName);
       ShowMessage('Exception message = '+E.Message);
     end;        }
end;

forzeversion:='';

deletefile2(tempdirectoryupdates);

//Now offlinelist dats not necessary if not selected

if offlinetoo=true then begin
  Datamodule1.Qaux.SQL.Clear;
  Datamodule1.Qaux.close;
  Datamodule1.Qaux.SQL.Add('SELECT * FROM Profiles');
  Datamodule1.Qaux.SQL.Add('WHERE Original = '+''''+'O'+'''');

  Datamodule1.Qaux.Open;

  Datamodule1.Qaux.First;

  While not Datamodule1.Qaux.Eof do begin

    //DOWNLOAD VERSION
    try

      BMDThread1.Thread.Synchronize(messageoffline);

      downl1:=Datamodule1.Qaux.fieldbyname('Author').asstring;
      downl2:=tempdirectoryresources+'vers.rmt';
      deletefile2(downl2);

      Fmain.downloadfile2(downl1,downl2,false);

      Freeandnil(f);
      f:=TGpTextFile.CreateW(downl2);
      f.reset;
      cad:=f.Readln;
      F.Close;

      deletefile2(downl2);

      sta:=2;
      version:=Datamodule1.Qaux.fieldbyname('Version').asstring;

      cad:=trim(cad);
      version:=trim(version);

      if cad<>version then begin
        version:=cad;
        sta:=1;
      end;

      group:='-1';

      //x:=templist.IndexOf('12');
      //if x<>-1 then
      //  group:=fillwithzeroes(inttostr(x),2);//sort in complete view

      Datamodule1.Tupdater.Append;
      Datamodule1.Tupdater.FieldByName('Name').asstring:=Datamodule1.Qaux.fieldbyname('Name').asstring;
      Datamodule1.Tupdater.FieldByName('Version').asstring:=version;
      Datamodule1.Tupdater.FieldByName('Type').asinteger:=11;
      Datamodule1.Tupdater.FieldByName('Url').asstring:=Datamodule1.Qaux.fieldbyname('ID').asstring;
      Datamodule1.Tupdater.FieldByName('Date_').asstring:='11';

      Datamodule1.Tupdater.FieldByName('Status').asinteger:=sta;
      Datamodule1.Tupdater.post;

    except

    end;

    try
      Freeandnil(f);
    except
    end;

    Datamodule1.Qaux.Next;

  end;

end;


Freeandnil(datgroupstemp);

Freeandnil(f);

if stcompfiles.Count=1 then
  deletefile2(tempdirectoryextractvar+stcompfiles.strings[0]);

fmain.closepossiblyopenzip;

Datamodule1.DBUpdater.Commit(false);
showupdates;
end;

procedure Tfupdater.processupdatefinder;
var
f:Textfile;
cad,group,downl1,downl2,version,date:ansistring;
next,offlinetoo:boolean;
ty,sta,x,cnt:integer;
templist,datgroupstemp:Tstringlist;
begin
templist:=Tstringlist.Create;
//templist.Sorted:=true; //NEVER MUST SORT

for x:=0 to tntcombobox1.Items.Count-1 do
  templist.Add(gettoken(tntcombobox1.items.strings[x],'"',2));

datgroupstemp:=Tstringlist.Create;
datgroupstemp.Sorted:=true; //SPEEDUP

for x:=0 to datgroups.Count-1 do
  datgroupstemp.Add(datgroups.Strings[x]);

offlinetoo:=false; //Check for offlinelist

if datgroupstemp.IndexOf('11|1')<>-1 then
  offlinetoo:=true;

Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Add('SELECT * FROM Profiles');
Datamodule1.Qaux.SQL.Add('ORDER BY Name,Original');
//SORTING BY NAME AND DAT TYPE

Datamodule1.Qaux.Open;

deletefile2(tempdirectoryupdater);

DataModule1.DBUpdater.Close;
DataModule1.DBUpdater.DatabaseFileName:=UTF8Encode(tempdirectoryupdater);
DataModule1.DBUpdater.PageCountInExtent:=defpagecountinextent;
DataModule1.DBUpdater.PageSize:=defpagesize;
DataModule1.DBUpdater.MaxConnections:=defmaxconnections;
DataModule1.DBUpdater.SilentMode:=true;
Datamodule1.DBUpdater.CreateDatabase;

Datamodule1.Tupdater.close;
Datamodule1.Tupdater.FieldDefs.Clear;
Datamodule1.Tupdater.TableName:='Updater';
Datamodule1.Tupdater.FieldDefs.Add('I',ftAutoInc,0,False);
Datamodule1.Tupdater.FieldDefs.Add('Name',ftString,255,True);
Datamodule1.Tupdater.FieldDefs.Add('Version',ftString,255,True);
Datamodule1.Tupdater.FieldDefs.Add('Type',ftInteger,0,True);
Datamodule1.Tupdater.FieldDefs.Add('Daters',ftString,255,True);
Datamodule1.Tupdater.FieldDefs.Add('Url',ftString,255,True);
Datamodule1.Tupdater.FieldDefs.Add('Status',ftinteger,0,True);

Datamodule1.Tupdater.IndexDefs.Clear;
Datamodule1.Tupdater.IndexDefs.Add('I1', 'I', [ixPrimary]); //Speedup locate
Datamodule1.Tupdater.IndexDefs.Add('I2','Name', [ixCaseInsensitive]);
Datamodule1.Tupdater.IndexDefs.Add('I3','Url', []);
Datamodule1.Tupdater.IndexDefs.Add('I4','Type', []);
Datamodule1.Tupdater.IndexDefs.Add('I5','Status', []);

Datamodule1.Tupdater.CreateTable;
Datamodule1.Tupdater.open;

Datamodule1.DBUpdater.StartTransaction;

try
  deletefile2(tempdirectoryupdates);

  if Fmain.DownLoadFile2(romulusurl+'list.rm',tempdirectoryupdates,false)=true then begin

    //copyfile2(tempdirectoryupdates,'C:\updater.txt');

    assignfile(f,tempdirectoryupdates);

    reset(F);
    cnt:=0;
    while not eof(f) do begin
      cnt:=cnt+1;
      readln(f,cad);
    end;

    ProgressBar2.Max:=cnt;
    pbpos:=0;

    reset(F);

    while not eof(f) do begin

      pbpos:=pbpos+1;
      Readln(f,cad);
      next:=false;
      group:='-1';
      ty:=strtoint(gettoken(cad,'*',1));

      //TY IS GROUP INDEX IN DOWNLOADED FILE
      {
      0:Tosec roms
      1:No intro
      2:Redump.org
      3:Pocket Heaven
      4:Arcade
      5:Pinball
      6:Fruit machines
      7:Tosec ISO
      8:Tosec PIX
      9:Nongood
      10:Unrenamed
      12:Trurip normal
      13:Trurip Super
      14:Rawdump
      }

      //READ ONLY AVAILABLE GROUPS

      //SLOWDOWN A LOT

      if (gettokencount(cad,'*')=4) OR (gettokencount(cad,'*')=5) then
        if datgroupstemp.IndexOf(inttostr(ty)+'|1')<>-1 then begin //THIS GROUP IS SELECTED
          next:=true;
          x:=templist.IndexOf(inttostr(ty+1));
          if x<>-1 then
            group:=fillwithzeroes(inttostr(x),2);//sort in complete view
        end;

      if next=True then begin

        //NEW PARAMS SINCE 0.017 VERSION DELETE THE LAST ADDED
        if Datamodule1.Tupdater.FieldByName('Name').asstring=gettoken(cad,'*',2) then
          Datamodule1.Tupdater.Delete;

        date:='';
        if gettokencount(cad,'*')=5 then
          date:=gettoken(cad,'*',5);

        try
          Datamodule1.Tupdater.Append;
          Datamodule1.Tupdater.FieldByName('Name').asstring:=gettoken(cad,'*',2);
          Datamodule1.Tupdater.FieldByName('Version').asstring:=gettoken(cad,'*',3);
          Datamodule1.Tupdater.FieldByName('Type').asinteger:=ty;
          Datamodule1.Tupdater.FieldByName('Url').asstring:=gettoken(cad,'*',4);
          Datamodule1.Tupdater.FieldByName('Daters').asstring:=group;

          Datamodule1.Tupdater.FieldByName('Status').asinteger:=findnameversion(ty,gettoken(cad,'*',2),gettoken(cad,'*',3),date,'X;C');

          Datamodule1.Tupdater.post;
        except //FAILED IMPORTED BUT CONTINUE
          Datamodule1.Tupdater.Cancel;
        end;

      end;

    end;

    closefile(f);
  end;

  //Now offlinelist dats not necessary if not selected

  if offlinetoo=true then begin

    Datamodule1.Qaux.SQL.Clear;
    Datamodule1.Qaux.close;
    Datamodule1.Qaux.SQL.Add('SELECT * FROM Profiles');
    Datamodule1.Qaux.SQL.Add('WHERE Original = '+''''+'O'+'''');

    Datamodule1.Qaux.Open;

    Datamodule1.Qaux.First;

    While not Datamodule1.Qaux.Eof do begin

      //DOWNLOAD VERSION
      try

        BMDThread1.Thread.Synchronize(messageoffline);

        downl1:=Datamodule1.Qaux.fieldbyname('Author').asstring;
        downl2:=tempdirectoryresources+'vers.rmt';
        deletefile2(downl2);

        Fmain.downloadfile2(downl1,downl2,false);

        assignfile(f,downl2);
        reset(f);
        readln(f,cad);
        closefile(f);

        deletefile2(downl2);

        sta:=2;
        version:=Datamodule1.Qaux.fieldbyname('Version').asstring;

        cad:=trim(cad);
        version:=trim(version);

        if cad<>version then begin
          version:=cad;
          sta:=1;
        end;

        group:='-1';

        x:=templist.IndexOf('12');
        if x<>-1 then
          group:=fillwithzeroes(inttostr(x),2);//sort in complete view

        Datamodule1.Tupdater.Append;
        Datamodule1.Tupdater.FieldByName('Name').asstring:=Datamodule1.Qaux.fieldbyname('Name').asstring;
        Datamodule1.Tupdater.FieldByName('Version').asstring:=version;
        Datamodule1.Tupdater.FieldByName('Type').asinteger:=11;
        Datamodule1.Tupdater.FieldByName('Url').asstring:=Datamodule1.Qaux.fieldbyname('ID').asstring;
        Datamodule1.Tupdater.FieldByName('Daters').asstring:=group;

        Datamodule1.Tupdater.FieldByName('Status').asinteger:=sta;

        Datamodule1.Tupdater.post;
      except
      end;

      try
        closefile(f);
      except
      end;

      Datamodule1.Qaux.Next;

    end;

  end;

except

end;

datgroupstemp.Free;
templist.Free;

Datamodule1.DBUpdater.Commit(false);

try
  closefile(f);
except
end;

deletefile2(tempdirectoryupdates);
end;

procedure Tfupdater.TraductFupdater;
begin
caption:=traduction(6);
bitbtn1.Caption:=traduction(217);
speedbutton1.Caption:=traduction(356);
label1.caption:=traduction(355);
Fmain.labelshadow(label1,Fupdater);
label2.Caption:=traduction(353)+' :';
tntlabel1.Caption:=traduction(357);
Fmain.labelshadow(tntlabel1,Fupdater);

speedbutton4.hint:=Traduction(361);
speedbutton3.hint:=Traduction(362);
speedbutton2.hint:=Traduction(363);

speedbutton5.Hint:=Traduction(363);
speedbutton6.Hint:=Traduction(362);
speedbutton7.Hint:=Traduction(361);

VirtualStringTree1.header.Columns[0].text:=Traduction(22);
VirtualStringTree1.header.Columns[1].text:=Traduction(12);
VirtualStringTree1.header.Columns[2].text:=Traduction(11);
VirtualStringTree1.header.Columns[3].text:=Traduction(18);

Updatedat1.Caption:=UTF8Encode(traduction(642));
Updatedatnoprompt1.caption:=UTF8Encode(traduction(647));
Openwithintegratednavigator1.Caption:=UTF8Encode(traduction(625));
Openwithdefaultnavigator1.caption:=UTF8Encode(traduction(626));
Selectall1.Caption:=UTF8Encode(traduction(40));
Invertselection1.Caption:=UTF8Encode(traduction(41));

TntComboBox2.Items.Clear;
tntcombobox2.Items.Add(traduction(645));
tntcombobox2.Items.Add(traduction(646));
tntcombobox2.ItemIndex:=0;

try
  TntComboBox2.ItemIndex:=updaterdatsdecision;
except
end;

TntSpeedButton1.Caption:=traduction(644);
end;

procedure TFupdater.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fupdater);
//VirtualStringTree1.Header.Options:=VirtualStringTree1.Header.options-[hoHotTrack];//REMOVE HOTTRACK IB HEADER
Fmain.setlabeltoprogressbar(tntlabel2,ProgressBar2);//Autoinitialize

virtualstringtree1.Header.SortColumn:=0;
virtualstringtree1.header.SortDirection:=sdAscending;

if colorcolumns=true then
  VirtualStringTree1.Header.Columns[0].Color:=clBtnFace;


end;

procedure TFupdater.BitBtn1Click(Sender: TObject);
begin
close;
end;

procedure TFupdater.FormShow(Sender: TObject);
var
x,id:integer;
begin
traductFupdater;

Fmain.setgridlines(VirtualStringTree1,ingridlines);
VirtualStringTree1.Align:=alclient;
tntcombobox1.ItemIndex:=0;
Panel3.Align:=Alclient;
panel3.Visible:=true;
CenterInClient(progressbar2,panel3);
progressbar2.Top:=progressbar2.Top+30;
CenterInClient(panel6,panel3);
panel6.Top:=panel6.Top+30;

//SHADOW LABEL
tntlabel1.Width:=progressbar2.Width;
tntlabel1.Left:=progressbar2.left;
CenterInClient(tntlabel1,panel3);
tntlabel1.top:=tntlabel1.top;//FIX
Fmain.labelshadow(tntlabel1,Fupdater);


Datamodule1.DBUpdater.Close;
TntComboBox1.Items.Clear;

TntComboBox1.Items.Add(traduction(36)+'"0');

for x:=0 to updatercount-1 do begin                                                                                                                                                                                                                                                                                                                                           //0.050 Removed Yori
  if (updaterdescription(x,false)<>'3') AND (updaterdescription(x,false)<>'12') AND (updaterdescription(x,false)<>'13') AND (updaterdescription(x,false)<>'14') AND (updaterdescription(x,false)<>'16') AND (updaterdescription(x,false)<>'17') AND (updaterdescription(x,false)<>'18') AND (updaterdescription(x,false)<>'19') AND (updaterdescription(x,false)<>'20') AND (updaterdescription(x,false)<>'5') AND (updaterdescription(x,false)<>'6') AND (updaterdescription(x,false)<>'9') AND (updaterdescription(x,false)<>'10') then  //0.031 Removed Pocketheaven
    if gettoken(datgroups.Strings[x],'|',2)='1' then begin
      id:=strtoint(updaterdescription(x,false));
      TntComboBox1.items.Add(updaterdescription(x,true)+'"'+inttostr(id+1));
    end;
end;
TntComboBox1.ItemIndex:=0;
Fupdater.Tag:=1;

Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFupdater.SpeedButton1Click(Sender: TObject);
begin
BMDThread1.Start;
//processupdatefindernew;
end;

procedure TFupdater.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if speedbutton1.Enabled=false then
  canclose:=False;
end;

procedure TFupdater.SpeedButton2Click(Sender: TObject);
begin
speedbutton5.Down:=speedbutton2.down;
showupdates;
end;

procedure TFupdater.SpeedButton3Click(Sender: TObject);
begin
speedbutton6.Down:=speedbutton3.down;
showupdates;
end;

procedure TFupdater.SpeedButton4Click(Sender: TObject);
begin
speedbutton7.Down:=speedbutton4.down;
showupdates;
end;

procedure TFupdater.BMDThread1Execute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
//processupdatefinder;
processupdatefindernew;
Thread.Terminate;
end;

procedure TFupdater.BMDThread1Start(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
Fmain.taskbaractive(true);
//Fmain.initializeprogressbar(ProgressBar2);
Fmain.initializeprogresslabel(tntlabel2);

disablesysmenu(Fupdater,false);
bitbtn1.Enabled:=false;
speedbutton1.Enabled:=false;
Datamodule1.DBUpdater.Close;
bitbtn1.Tag:=0;
tntlabel1.Caption:=traduction(357);
Fmain.labelshadow(tntlabel1,Fupdater);

ProgressBar2.Position:=0;
panel3.Visible:=true;
VirtualStringTree1.rootnodecount:=0;
VirtualStringTree1.Visible:=false;

checkpanelstatus;
tntlabel1.caption:=traduction(364);
Fmain.labelshadow(tntlabel1,Fupdater);

pbpos:=0;

end;

procedure TFupdater.BMDThread1Terminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);

begin
speedbutton1.Enabled:=true;
bitbtn1.Enabled:=true;
showupdates;

checkpanelstatus;

disablesysmenu(Fupdater,true);

Fmain.taskbaractive(false);

//Fmain.initializeprogressbar(progressbar2);
Fmain.initializeprogresslabel(tntlabel2);
end;

procedure TFupdater.BMDThread1Update(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer; Percent: Integer);
begin
BMDThread1.UpdateEnabled:=false;

ProgressBar2.Position:=pbpos;
//ProgressBar2.ProgressText:=checknan(FormatFloat('0.00',(pbpos*100) / Progressbar2.max)+' %');
tntlabel2.Caption:=checknan(FormatFloat('0.00',(pbpos*100) / Progressbar2.max)+' %');

bmdthread1.UpdateEnabled:=true;    
end;

procedure TFupdater.SpeedButton5Click(Sender: TObject);
begin
speedbutton2.Down:=true;
SpeedButton2Click(sender);
end;

procedure TFupdater.SpeedButton6Click(Sender: TObject);
begin
speedbutton3.Down:=true;
SpeedButton3Click(sender);
end;

procedure TFupdater.SpeedButton7Click(Sender: TObject);
begin
speedbutton4.Down:=true;
SpeedButton4Click(sender);
end;

procedure TFupdater.FormClose(Sender: TObject; var Action: TCloseAction);
begin
updaterdatsdecision:=TntComboBox2.ItemIndex;
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFupdater.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFupdater.TntComboBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
tntcombobox1.canvas.fillrect(rect);

Fmain.imagelist6.Draw(tntcombobox1.Canvas,rect.left,rect.top,strtoint(gettoken(TntComboBox1.Items.Strings[index],'"',2)));
WideCanvasTextOut(tntcombobox1.canvas,rect.left+Fmain.imagelist6.width+2,rect.top+1,gettoken(tntcombobox1.items[index],'"',1));

if odfocused in state then
  tntcombobox1.canvas.DrawFocusRect(rect);
end;

procedure TFupdater.TntComboBox1Change(Sender: TObject);
begin
showupdates;
freemousebuffer;
freekeyboardbuffer;
end;

procedure TFupdater.VirtualStringTree1DblClick(Sender: TObject);
begin
if virtualstringtree1.SelectedCount>0 then begin

  Datamodule1.Qupdater.RecNo:=virtualstringtree1.FocusedNode.index+1;

  if Datamodule1.Qupdater.FieldByName('Type').asinteger<>11 then begin
    {if isthisvalidurl(Datamodule1.Qupdater.fieldbyname('Url').asstring)=true then
      Fmain.wb_navigate(Datamodule1.Qupdater.fieldbyname('Url').asstring,true,false); }
    Updatedat1Click(sender)
  end
  else begin //Offlinelist update
    Application.CreateForm(TFofflineupdate, Fofflineupdate);
    Datamodule1.Qupdater.RecNo:=virtualstringtree1.FocusedNode.index+1;
    Datamodule1.Tupdater.Locate('I',Datamodule1.Qupdater.fieldbyname('I').asinteger,[]);
    Fofflineupdate.loadprofile(fillwithzeroes(Datamodule1.Tupdater.FieldByName('Url').asstring,4));
    myshowform(Fofflineupdate,true);
    Freeandnil(Fofflineupdate);
    try
      Flog.close; //FIX
    except
    end;

  end;

end;

end;

procedure TFupdater.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
if Datamodule1.Qupdater.RecNo<>node.Index+1 then
  Datamodule1.Qupdater.RecNo:=node.Index+1;

case Column of
  0:celltext:=Datamodule1.Qupdater.fieldbyname('Name').asstring;
  1:celltext:=Datamodule1.Qupdater.fieldbyname('Version').asstring;
  2:begin
    if Datamodule1.Qupdater.FieldByName('Type').AsInteger<>11 then
      celltext:=Datamodule1.Qupdater.fieldbyname('Description').asstring
    else
      celltext:='-';
    end;
  3:begin
    if Datamodule1.Qupdater.FieldByName('Type').AsInteger<>11 then
      celltext:=Datamodule1.Qupdater.fieldbyname('Url').asstring
    else
      celltext:='-';
  end;
  {2:begin
    if Datamodule1.Qupdater.FieldByName('Type').AsInteger<>11 then
      celltext:=Datamodule1.Qupdater.fieldbyname('Url').asstring
    else
      celltext:='-';
  end;      }
end;

end;

procedure TFupdater.VirtualStringTree1GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
if  column=0 then begin

  if Datamodule1.Qupdater.RecNo<>node.Index+1 then
    Datamodule1.Qupdater.RecNo:=node.Index+1;


  if Kind=ikState then begin
    imageindex:=Datamodule1.Qupdater.fieldbyname('Type').AsInteger+1;
  end
  else
  if kind<>ikOverlay then begin //OK
    ImageIndex:=Datamodule1.Qupdater.fieldbyname('Status').AsInteger;
  end;

end;
end;

procedure TFupdater.VirtualStringTree1HeaderClick(Sender: TVTHeader;
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

TntComboBox1Change(sender);
end;

procedure TFupdater.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  if speedbutton1.enabled=true then
    close;
end;

procedure TFupdater.Openwithintegratednavigator1Click(Sender: TObject);
begin
if virtualstringtree1.SelectedCount>0 then begin
  Datamodule1.Qupdater.RecNo:=virtualstringtree1.FocusedNode.index+1;
  if isthisvalidurl(Datamodule1.Qupdater.fieldbyname('Url').asstring)=true then
    Fmain.wb_navigate(Datamodule1.Qupdater.fieldbyname('Url').asstring,true,true);
end;

end;

procedure TFupdater.Openwithdefaultnavigator1Click(Sender: TObject);
begin
if virtualstringtree1.SelectedCount>0 then begin
  Datamodule1.Qupdater.RecNo:=virtualstringtree1.FocusedNode.index+1;
  if isthisvalidurl(Datamodule1.Qupdater.fieldbyname('Url').asstring)=true then
    ShellExecute(handle,'open',pchar(Datamodule1.Qupdater.fieldbyname('Url').asstring),nil,nil, SW_SHOWNORMAL);
end;
end;

procedure TFupdater.PopupMenu1Popup(Sender: TObject);
begin
Openwithintegratednavigator1.Enabled:=false;
Openwithdefaultnavigator1.Enabled:=false;

if virtualstringtree1.SelectedCount>0 then begin
  Datamodule1.Qupdater.RecNo:=virtualstringtree1.FocusedNode.index+1;
  if Datamodule1.Qupdater.FieldByName('Type').asinteger<>11 then begin
    if isthisvalidurl(Datamodule1.Qupdater.FieldByName('Url').asstring)=true then begin
      Openwithintegratednavigator1.Enabled:=true;
      Openwithdefaultnavigator1.Enabled:=true;
    end;
  end;

end;

end;

procedure TFupdater.Updatedat1Click(Sender: TObject);
var
n:PVirtualNode;
x:integer;
url,nam:ansistring;
dest:widestring;
showresults:boolean;
priorimported:integer;
selectedlist:Tstringlist;
p,fold:widestring;
begin
PopupMenu1.Tag:=0;
if (sender is TMenuItem) then
  if ((sender as TMenuItem).name)='Updatedatnoprompt1' then
    PopupMenu1.Tag:=1;//NO PROMPT FLAG

if virtualstringtree1.SelectedCount=0 then
  exit;

lastnewdatdecision:=0;
selectedlist:=TStringList.Create;

Image1.Align:=alclient; //0.047 FIX
image1.BringToFront;
image1.Visible:=true;

showresults:=true;
enabled:=false;

sterrors.Clear;
autodecision:=-1;
autodecisioncheck:=true;
imported:=0;

fmain.showprocessingwindow(true,false);


n:=virtualstringtree1.GetFirst; //GET SELECTED LIST
for x:=0 to virtualstringtree1.RootNodeCount-1 do begin
  if virtualstringtree1.Selected[n]=true then begin
    datamodule1.Qupdater.RecNo:=n.Index+1;
    selectedlist.Add(Datamodule1.Qupdater.fieldbyname('I').asstring);
  end;
  n:=virtualstringtree1.GetNext(n);
end;


if selectedlist.count>0 then
  p:=checkpathbar(downloadeddatsdirectory);

for x:=0 to selectedlist.count-1 do begin

  if lastnewdatdecision=3 then //NO TO ALL
    Fprocessing.Tag:=1;//FORZE STOP
    
  if Fprocessing.Tag=1 then
    break;

  datamodule1.Tupdater.Locate('I',selectedlist.Strings[x],[]);

  if Datamodule1.Tupdater.FieldByName('Type').asinteger<>11 then begin

    forzeversion:='';//0.046

    if Datamodule1.Tupdater.fieldbyname('type').asstring='27' then  //0.046
      forzeversion:=Datamodule1.Tupdater.fieldbyname('version').asstring;  //0.046

    fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(642);

    url:=datamodule1.Tupdater.FieldByName('Downurl').asstring;
    //showmessage(url);
    //dest:=tempdirectoryextractvar+datamodule1.Tupdater.fieldbyname('name').asstring+'.zip';
    //0.047
    dest:=downloadeddatsdirectory;
    dest:=checkpathbar(dest+dattypetodescription(datamodule1.Tupdater.FieldByName('Type').asstring));
    try
      wideforcedirectories(dest);
    except
    end;
    dest:=dest+trim(removeconflictchars(datamodule1.Tupdater.FieldByName('name').asstring+' ('+datamodule1.Tupdater.FieldByName('version').asstring+')',false))+'.zip';
    dest:=getvaliddestination(dest);

    fprocessing.panel2.Caption:=changein(datamodule1.Tupdater.fieldbyname('name').asstring,'&','&&');

    //deletefile2(dest);

    Datamodule1.Qaux.sql.Text:='DOWNLOAD "'+url+'"'+utf8encode(dest);

    Fmain.bmdthread1.Start();
    Fmain.waitforfinishthread;

    if (FileExists2(dest)=true) AND (trim(Datamodule1.Qaux.sql.Text)='OK') then begin
      priorimported:=imported;

      Fmain.processnewdat(dest);

      if imported>priorimported then begin
        datamodule1.Tupdater.Edit;
        Datamodule1.Tupdater.fieldbyname('status').asinteger:=2; //UPDATED
        Datamodule1.Tupdater.Post;
      end;

      if TntComboBox2.ItemIndex=1 then
        deletefile2(dest);
    end
    else begin //ERROR DOWNLOADING
      nam:=dattypetodescription(datamodule1.Tupdater.fieldbyname('type').asstring);
      deletefile2(dest);
      sterrors.Add(traduction(643)+' : '+nam+' > '+datamodule1.Tupdater.fieldbyname('name').asstring);
    end;

    forzeversion:='';//0.046
  end
  else begin  //Offlinelist profile
    fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(642);

    Application.CreateForm(TFofflineupdate, Fofflineupdate);

    fprocessing.panel2.Caption:=changein(datamodule1.Tupdater.fieldbyname('name').asstring,'&','&&');

    Fofflineupdate.loadprofile(fillwithzeroes(Datamodule1.Tupdater.FieldByName('Url').asstring,4));

    if VirtualStringTree1.SelectedCount>1 then begin
      Fofflineupdate.Timer1.Tag:=1;//FORCE START AND CLOSE
    end
    else
      showresults:=false;

    myshowform(Fofflineupdate,true);
    Freeandnil(Fofflineupdate);

    try
      Flog.close; //FIX
    except
    end;
  end; //END OFFLINE

end; //END FOR

forzeversion:='';//0.046
Freeandnil(selectedlist);

if p<>'' then begin//0.047
  for x:=0 to updatercount-1 do begin
    fold:=checkpathbar(p+updaterdescription(x,true));
    if WideDirectoryExists(fold)=true then
      if IsDirectoryEmpty(fold)=true then
        WideRemoveDir(fold)
  end;

  if WideDirectoryExists(p)=true then
    if IsDirectoryEmpty(p)=true then
      WideRemoveDir(p);
end;

if imported<>0 then begin

  showupdates;

  Fmain.TreeView1.Tag:=0;
  Fmain.showprofiles(true);
  Fmain.TreeView1.Tag:=1;
end;

Fmain.hideprocessingwindow;

if showresults=true then
  Fmain.processnewdatshowresults;

sterrors.Clear;
Fupdater.Enabled:=true;
image1.Visible:=false;
Fupdater.VirtualStringTree1.SetFocus;
end;

procedure TFupdater.TntSpeedButton1Click(Sender: TObject);
begin
ShellExecutew(Handle,'open', pwidechar(getshortfilename(downloadeddatsdirectory)), nil, nil, SW_SHOWNORMAL) ;
end;

procedure TFupdater.Selectall1Click(Sender: TObject);
begin
VirtualStringTree1.SelectAll(true);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFupdater.Invertselection1Click(Sender: TObject);
begin
VirtualStringTree1.InvertSelection(false);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFupdater.Updatedatnoprompt1Click(Sender: TObject);
begin
Updatedat1Click(sender);
end;

end.




