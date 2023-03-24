unit Uofflineupdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ExtActns, Strings,
  GR32_Image,pngimage, Hashes, Mymessages, BMDThread, importation,Tntforms,
  TntExtCtrls, TntButtons, TntStdCtrls, TntGraphics, TntSysutils, ewbtools,
  TntComCtrls,Gptextfile;

type
  TFofflineupdate = class(TTntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label11: TTntLabel;
    CheckBox1: TTntCheckBox;
    CheckBox2: TTntCheckBox;
    Edit1: TTntEdit;
    SpeedButton1: TTntSpeedButton;
    Label2: TTntLabel;
    ProgressBar1: TProgressBar;
    Label6: TTntLabel;
    Bevel4: TBevel;
    Panel2: TTntPanel;
    Label3: TTntLabel;
    ProgressBar2: TProgressBar;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    Panel3: TTntPanel;
    Bevel5: TBevel;
    BitBtn3: TTntBitBtn;
    CheckBox3: TTntCheckBox;
    Label4: TTntLabel;
    Bevel7: TBevel;
    Label7: TTntLabel;
    Edit2: TTntEdit;
    BMDThread1: TBMDThread;
    Image321: TImage32;
    SpeedButton3: TTntSpeedButton;
    Image322: TImage32;
    Image3210: TImage32;
    Image323: TImage32;
    Image324: TImage32;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure BMDThread1Start(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BMDThread1Execute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BMDThread1Terminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton3Click(Sender: TObject);
    procedure BMDThread1Update(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer; Percent: Integer);
    procedure FormActivate(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    newvers:ansistring;
  public
    { Public declarations }
    procedure action(Sender: TObject);
    procedure updatedatsynch(Sender : Tobject);
    procedure showupdatesynch(Sender : Tobject);
    procedure updateimage(Sender : Tobject);
    procedure updateshowfile(SEnder : Tobject);
    procedure refreshupdaterform(Sender : Tobject);
    procedure initpbar( Sender : Tobject);
    procedure loadprofile(id:ansistring);
  end;

var
  Fofflineupdate: TFofflineupdate;
  cancel:boolean;
  msg:widestring;
  space,pos:int64;

implementation

uses Umain, UData, DB, Ulog, Uscan, Uupdater;

{$R *.dfm}
procedure Tfofflineupdate.loadprofile(id:ansistring);
begin
Datamodule1.Tprofiles.Locate('ID',StrToInt(id),[]);
edit2.Text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'));
if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(id),'I']),[])=true then begin
  edit1.Text:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
end;
updateid:=id;
end;

procedure TFofflineupdate.initpbar(Sender : TObject);
begin
progressbar2.Position:=0;
progressbar2.Min:=0;
progressbar2.Max:=Datamodule1.Tscansets.RecordCount-1;//Vista 7 FIX
end;

procedure Tfofflineupdate.refreshupdaterform(Sender : Tobject);
begin
try //If is part of Updater form
    if Datamodule1.Tupdater.Locate('Url',Datamodule1.Tprofiles.fieldbyname('ID').asstring,[])=true then begin
      Datamodule1.Tupdater.edit;
      Datamodule1.Tupdater.FieldByName('Status').AsInteger:=2;
      Datamodule1.Tupdater.FieldByName('version').asstring:=newvers;
      Datamodule1.Tupdater.post;
      if timer1.Tag=0 then //IF IS IN BATCH NOT UPDATE
        Fupdater.showupdates;
    end;
except
end;
end;

procedure Tfofflineupdate.updateshowfile(Sender : Tobject);
begin
panel2.Caption:=msg;
end;

procedure TFofflineupdate.updateimage(Sender : Tobject);
begin
image321.Bitmap.Clear;//FIX
Image321.Bitmap.Assign(png);
Image321.Repaint;
end;

procedure TFofflineupdate.showupdatesynch(Sender : Tobject);
begin
Fmain.treeview1.tag:=0;

Fmain.showprofiles(false);

end;

procedure TFofflineupdate.updatedatsynch(Sender : Tobject);
var
tab:Ttnttabsheet;
recover:integer;
begin
bmdthread1.Suspend;

recover:=-1;
tab:=(Fmain.FindComponent('CLONE_TabSheet7_'+updateid) as TTnttabsheet);

if tab<>nil then begin
  recover:=Fmain.PageControl2.ActivePageIndex;
  Fmain.PageControl2.ActivePage:=tab;
  try
  //Fmain.PageControl2Change(sender); bug
  except
  end;
end;


Fmain.processnewdat(msg);
Fmain.showprolesmasterdetail(false,false,Fmain.getcurrentprofileid,true,true);

if recover<>-1 then begin
  Fmain.PageControl2.ActivePageIndex:=recover;
  Fmain.PageControl2Change(sender); //BUG
end;

bmdthread1.resume;
end;

procedure TFofflineupdate.action(Sender: TObject);
begin
label4.Caption:=msg;
end;

procedure TFofflineupdate.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fofflineupdate);
Fmain.setlabeltoprogressbar(tntlabel1,progressbar1);
Fmain.setlabeltoprogressbar(tntlabel2,progressbar2);
end;

procedure TFofflineupdate.BitBtn2Click(Sender: TObject);
begin
bitbtn2.Caption:=traduction(339);
bitbtn2.Enabled:=false;
cancel:=true;
end;

procedure TFofflineupdate.FormShow(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);

caption:=traduction(240);
label1.Caption:=traduction(242);
Fmain.labelshadow(label1,Fofflineupdate);
checkbox3.Caption:=traduction(243);
label6.Caption:=traduction(140);
label11.Caption:=traduction(137);
label3.Caption:=traduction(141);
label2.caption:=traduction(239)+' :';
bitbtn1.Caption:=traduction(142);
bitbtn2.Caption:=traduction(143);
bitbtn3.caption:=traduction(217);
label4.Caption:=traduction(61)+' : '+traduction(147);
label7.Caption:=traduction(138);
checkbox1.Caption:=traduction(248);
checkbox2.Caption:=traduction(249);
SpeedButton3.Caption:=traduction(177);
speedbutton1.Hint:=traduction(163);

if Flog.Tag=1 then begin
  myshowform(Flog,false);
  speedbutton3.Down:=true;
end
else
  speedbutton3.Down:=false;

Image321.Bitmap.Clear(clWhite);//0.043
image321.bitmap.Assign(bmp);

if timer1.Tag=1 then
  timer1.Enabled:=true;
end;

procedure TFofflineupdate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);

Datamodule1.Tscansets.Close;
Datamodule1.Tscanroms.Close;
end;

procedure TFofflineupdate.SpeedButton1Click(Sender: TObject);
begin
Fmain.setimagepath(edit1);

try //FIX SINCE 0.021
  if strtoint(Fmain.getcurrentprofileid)=strtoint(updateid) then
    if Fmain.edit3.Text<>edit1.Text then
      Fmain.Edit3.Text:=edit1.Text;
except
end;

end;

procedure TFofflineupdate.BitBtn3Click(Sender: TObject);
begin
close;
end;

procedure TFofflineupdate.CheckBox1Click(Sender: TObject);
begin
if (checkbox1.Checked=false) AND (checkbox2.Checked=false) then
  bitbtn1.Enabled:=false
else
  bitbtn1.Enabled:=true;
end;

procedure TFofflineupdate.CheckBox2Click(Sender: TObject);
begin
CheckBox1Click(sender);
end;

procedure TFofflineupdate.BMDThread1Start(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
onathread:=true;
Fmain.taskbaractive(true);

currentset:='';
panel2.caption:='';

Fmain.initializeprogresslabel(tntlabel1);
Fmain.initializeprogresslabel(tntlabel2);

disablesysmenu(Fofflineupdate,false);
Flog.SpeedButton2.enabled:=False;

bitbtn1.Enabled:=false;
bitbtn2.Enabled:=true;
bitbtn3.Enabled:=false;
checkbox1.Enabled:=false;
checkbox2.Enabled:=false;
speedbutton1.Enabled:=false;

Datamodule1.Tscansets.Close;
Datamodule1.Tscanroms.Close;

Datamodule1.Tscansets.TableName:='Y'+updateid;
Datamodule1.Tscanroms.TableName:='Z'+updateid;

lastnewdatdecision:=0;

msg:=edit1.Text;
msg:=checkpathbar(msg);
cancel:=false;
end;

procedure TFofflineupdate.BMDThread1Execute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
url,subpath,str,crc,precrc:ansistring;
d:TDateTime;
f:textfile;
x,aux,aux2:longint;
r:real;
download,beginupdate:boolean;
downl1,downl2:widestring;
destdir,dest,impath:widestring;
cpath,cpathtemp,cachestr:widestring;
begin
dest:=msg;
beginupdate:=false;
cancel:=False;
//Uses addlogline from Fscan
//Fscan.addlogline(Sender);
try

  //Check updates
  if checkbox1.Checked=true then begin

    imported:=0;
    try

      Fscan.preparelogline(0,-1,0,traduction(260)+' - '+datetimetostr(now),edit2.text);
      BMDThread1.Thread.Synchronize(Fscan.addlogline);

      d:=Datamodule1.Tprofiles.fieldbyname('Added').AsDateTime;

      //SYNC
      msg:=traduction(61)+' : '+traduction(244);
      BMDThread1.Thread.Synchronize(action);

      subpath:=tempdirectoryresources+'vers.rmt';
      deletefile2(subpath);

      //SYNC
      downl1:=Datamodule1.Tprofiles.fieldbyname('Author').asstring;
      downl2:=subpath;

      if cancel=false then begin

        Fmain.downloadfile2(downl1,downl2,true);

        assignfile(f,subpath);
        reset(f);
        readln(f,str);
        closefile(f);
        deletefile2(subpath);
      end;
       //
      //Check update
      

      if (cancel=false) AND (str<>Datamodule1.Tprofiles.FieldByName('Version').asstring) then begin

        //SYNC
        msg:=traduction(61)+' : '+traduction(245);
        BMDThread1.Thread.Synchronize(action);

        subpath:=tempdirectoryresources+'offlinelist.zip';

        //SYNC
        downl1:=Datamodule1.Tprofiles.fieldbyname('Homeweb').asstring;
        deletefile2(downl1);
        downl2:=subpath;

        Fmain.downloadfile2(downl1,downl2,true);

        if cancel=false then begin

          beginupdate:=true;
          //SYNC
          msg:=subpath;

          BMDThread1.Thread.Synchronize(updatedatsynch);

          //Fix dat version seems updated
          if Datamodule1.Tprofiles.Locate('ID',strtoint(updateid),[])=true then
            if d<>Datamodule1.Tprofiles.fieldbyname('Added').AsDateTime then begin

              Datamodule1.Tprofiles.edit;
              Datamodule1.Tprofiles.FieldByName('Version').asstring:=str;
              Datamodule1.Tprofiles.post;

              newvers:=str;

              //Check if is part of updater form action
              BMDThread1.Thread.Synchronize(refreshupdaterform);
            end;

          //SYNC
          if timer1.tag=0 then //IF NOT IT BATCH THEN UPDATE
            BMDThread1.Thread.Synchronize(showupdatesynch);
        end;

      end;

    except //Error updating

    end;

    if imported=1 then //OK
      Fscan.preparelogline(1,6,1,traduction(267),'')
    else
    if beginupdate=true then//SKIPPED
      Fscan.preparelogline(2,6,1,traduction(268),'')
    else
    if cancel=false then//NO NEW UPDATE
      Fscan.preparelogline(2,6,1,traduction(266),'')
    else //STOPPED
      Fscan.preparelogline(2,6,1,traduction(264),'');

    BMDThread1.Thread.Synchronize(Fscan.addlogline);
    Fscan.preparelogline(0,-1,0,traduction(261)+' - '+datetimetostr(now),edit2.text);
    BMDThread1.Thread.Synchronize(Fscan.addlogline);

  end;

  if checkbox2.Checked=true then begin

    //HERE BECAUSE IF UPDATE CHANGED PICS URL DONT WORK
    Datamodule1.Tprofiles.Locate('ID',strtoint(updateid),[]);
    url:=Datamodule1.Tprofiles.fieldbyname('Email').asstring;
    //CACHE
    stsimplehash.clear;                                                                                              //O Off Offlinelist
    cpath:=tempdirectorycache+Fmain.getdbid+'-'+inttohex(strtoint64(Datamodule1.Tprofiles.FieldByName('ID').asstring),8)+'O';
    cpathtemp:=tempdirectorycache+'cache';

    if FileExists2(cpath) then begin
      try //IF NOT VALID ZIP FILE THEN TRY TO LOAD AS TXT FILE

        Fmain.Zip1.CloseArchive;
        Fmain.zip1.FileName:=cpath;
        Fmain.zip1.OpenArchive;

        deletefile2(cpathtemp);//SECURITY TO CAN EXTRACT
        Fmain.zip1.BaseDir:=tempdirectorycache;
        Fmain.Zip1.ExtractFiles('cache');
        stsimplehash.LoadFromFile(cpathtemp);

      except
      end;

      Fmain.zip1.CloseArchive;
    end;

    deletefile2(cpathtemp);
    cachefile:=TGpTextFile.CreateW(cpathtemp);
    cachefile.Rewrite([cfUnicode]);

    if length(url)>0 then
      if url[Length(url)]<>'/' then
        url:=url+'/';

    //open tables
    Fscan.preparelogline(0,-1,0,traduction(262)+' - '+datetimetostr(now),edit2.text);
    BMDThread1.Thread.Synchronize(Fscan.addlogline);

    Datamodule1.Tscansets.Open;
    Datamodule1.Tscanroms.Open;

    msg:=traduction(61)+' : '+traduction(246);
    BMDThread1.Thread.Synchronize(action);

    Datamodule1.Tscansets.first;

    BMDThread1.Thread.Synchronize(initpbar);
    downloadprogressposition:=0;

    for x:=1 to Datamodule1.Tscansets.RecordCount do begin

      if cancel=true then
        break;

      msg:=traduction(61)+' : '+traduction(246);
      BMDThread1.Thread.Synchronize(action);

      ///SYNC
      progressbar2.Tag:=x-1;

      Datamodule1.Tscanroms.Locate('Setname',Datamodule1.Tscansets.FieldByName('ID').AsInteger,[]);
      aux:= Datamodule1.Tscanroms.fieldbyname('MD5').asinteger;
      subpath:=inttostr(aux);

      if aux<=500 then
        aux2:=0
      else begin

        r:=aux / 500;
        aux2:=aux;

        if Frac(r)=0 then //Decimal
          aux2:=(aux-500);

        aux2:=aux2 div 500;

      end;

      destdir:=inttostr((aux2*500)+1)+'-'+inttostr((aux2+1)*500)+'\';
      subpath:=destdir+subpath;
      destdir:=dest+destdir;
      wideforcedirectories(destdir);

      if cancel=true then
        break;

      download:=true;
      msg:=inttostr(aux)+'a.png';
      currentset:=msg; //SPEED HACK 0.042

      //A IMAGE
      //------------------------------------------------------------------------
      impath:=destdir+inttostr(aux)+'a.png';
      precrc:=gettoken(Datamodule1.Tscanroms.fieldbyname('SHA1').asstring,'-',1); //CORRECT CRC OF DB MATCH

      if fileexists2(impath) then begin

        //CHECK IN CACHE 0.042
        cachestr:=inttostr(aux)+'a.png'+'-'+Inttohex(WideFileAge2(impath),0)+'-'+inttohex(sizeoffile(impath),0);
        if stsimplehash.IndexOf(cachestr)=-1 then begin  //CHECK IN CACHE
          //caption:=(datetimetostr(now));

          crc:=GetCRC32(impath);

          if (crc=precrc) OR (length(precrc)<>8) then begin
            download:=false;
            cachefile.Writeln(cachestr);
          end
          else
            deletefile2(impath);

        end
        else begin
          download:=false;
          cachefile.Writeln(cachestr);
        end;

      end;

      if download=true then begin

        msg:=traduction(61)+' : '+traduction(247);
        BMDThread1.Thread.Synchronize(action);

        try
          downl1:=url+changein(subpath,'\','/')+'a.png';
          downl2:=dest+subpath+'a.png';
          Fmain.downloadfile2(downl1,downl2,true);

          if GetCRC32(dest+subpath+'a.png')=precrc then begin
            cachestr:=inttostr(aux)+'a.png'+'-'+Inttohex(WideFileAge2(dest+subpath+'a.png'),0)+'-'+inttohex(sizeoffile(dest+subpath+'a.png'),0);
            cachefile.Writeln(cachestr);
          end;

        except
        end;
        
        downloadprogressposition:=0;

        try
          pngstream.Position:=0;

          if checkbox3.Checked=true then
          if sizeoffile(dest+subpath+'a.png')<5000000 then begin
            pngstream.LoadFromFile(dest+subpath+'a.png');
            png.LoadFromStream(pngstream);
            BMDThread1.Thread.Synchronize(updateimage);
          end
          else
            makeexception;

          Fscan.preparelogline(1,7,1,traduction(269),dest+subpath+'a.png');
          BMDThread1.Thread.Synchronize(Fscan.addlogline);

        except
          Fscan.preparelogline(3,7,1,traduction(269),dest+subpath+'a.png');
          BMDThread1.Thread.Synchronize(Fscan.addlogline);
        end;
      end;

      if cancel=true then
        break;

      download:=true;
      msg:=inttostr(aux)+'b.png';
      currentset:=msg;//SPEED HACK 0.042

      //B IMAGE
      //------------------------------------------------------------------------
      impath:=destdir+inttostr(aux)+'b.png';
      precrc:=gettoken(Datamodule1.Tscanroms.fieldbyname('SHA1').asstring,'-',2);

      if fileexists2(impath) then begin

        //CHECK IN CACHE 0.042
        cachestr:=inttostr(aux)+'b.png'+'-'+Inttohex(WideFileAge2(impath),0)+'-'+inttohex(sizeoffile(impath),0);
        if stsimplehash.IndexOf(cachestr)=-1 then begin  //CHECK IN CACHE

          crc:=GetCRC32(impath);

          if (crc=precrc) OR (length(precrc)<>8) then begin
            download:=false;
            cachefile.Writeln(cachestr);
          end
          else
            deletefile2(impath);

        end
        else begin
          download:=false;
          cachefile.Writeln(cachestr);
        end;

      end;

      if download=true then begin
      
        msg:=traduction(61)+' : '+traduction(247);
        BMDThread1.Thread.Synchronize(action);

        try
          downl1:=url+changein(subpath,'\','/')+'b.png';
          downl2:=dest+subpath+'b.png';
          Fmain.downloadfile2(downl1,downl2,true);

          if GetCRC32(dest+subpath+'b.png')=precrc then begin
            cachestr:=inttostr(aux)+'b.png'+'-'+Inttohex(WideFileAge2(dest+subpath+'b.png'),0)+'-'+inttohex(sizeoffile(dest+subpath+'b.png'),0);
            cachefile.Writeln(cachestr);
          end;

        except
        end;

        downloadprogressposition:=0;

        try
          pngstream.Position:=0;

          if checkbox3.Checked=true then
          if sizeoffile(dest+subpath+'b.png')<5000000 then begin
            pngstream.LoadFromFile(dest+subpath+'b.png');
            png.LoadFromStream(pngstream);
            BMDThread1.Thread.Synchronize(updateimage);
          end
          else
            makeexception;

          Fscan.preparelogline(1,7,1,traduction(269),dest+subpath+'b.png');
          BMDThread1.Thread.Synchronize(Fscan.addlogline);

        except
          Fscan.preparelogline(3,7,1,traduction(269),dest+subpath+'b.png');
          BMDThread1.Thread.Synchronize(Fscan.addlogline);
        end;
      end;

      Datamodule1.Tscansets.next;
    end;

    if cancel=false then begin
      Fscan.preparelogline(0,-1,0,traduction(263)+' - '+datetimetostr(now),edit2.text);
      BMDThread1.Thread.Synchronize(Fscan.addlogline);
    end
    else begin
      Fscan.preparelogline(0,-1,0,traduction(265)+' - '+datetimetostr(now),edit2.text);
      BMDThread1.Thread.Synchronize(Fscan.addlogline);
    end;

  end;//IF CHECKBOX2

except

end;

try
  closefile(f);
except
end;

Freeandnil(cachefile);

Fmain.compresscache(cpath);

Thread.Terminate;
end;

procedure TFofflineupdate.BMDThread1Terminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
onathread:=false;

Fmain.initializeprogresslabel(tntlabel1);
Fmain.initializeprogresslabel(tntlabel2);

bitbtn2.Caption:=traduction(143);
currentset:='';
panel2.Caption:='';
ProgressBar1.Position:=0;
progressbar2.Position:=0;

Fmain.loadimages;

bitbtn1.Enabled:=true;
bitbtn2.Enabled:=false;
bitbtn3.Enabled:=true;
checkbox1.Enabled:=true;
checkbox2.Enabled:=true;
speedbutton1.Enabled:=true;

label4.Caption:=traduction(61)+' : '+traduction(147);

Flog.SpeedButton2.enabled:=true;
disablesysmenu(Fofflineupdate,true);

Fmain.taskbaractive(false);

if timer1.tag=1 then
  close;
end;

procedure TFofflineupdate.BitBtn1Click(Sender: TObject);
begin

if checkbox2.Checked=true then
  if not WideDirectoryExists(edit1.text) then begin
    mymessageerror(traduction(251));
    exit;
  end;

BMDThread1.Start;
end;

procedure TFofflineupdate.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
canclose:=checkbox1.Enabled;

if canclose=false then
  exit;
  
if Flog.Visible=true then begin

  Flog.Tag:=1;
  flogtothemax:=false;

  if Flog.WindowState=wsmaximized then begin
    flogtothemax:=true;
    Flog.WindowState:=wsNormal;
  end;

  oldlogleft:=Flog.Left;
  oldlogtop:=Flog.top;
  Flog.Hide;

end
else
  Flog.tag:=0;
  
end;

procedure TFofflineupdate.SpeedButton3Click(Sender: TObject);
begin
if speedbutton3.Down then begin
  myshowform(Flog,false);
end
else begin
  Flog.Close;
end;
end;

procedure TFofflineupdate.BMDThread1Update(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer; Percent: Integer);
begin
BMDThread1.UpdateEnabled:=false;

try
  panel2.caption:=currentset;

  ProgressBar1.Max:=downloadprogresstotal;
  progressbar1.Position:=downloadprogressposition;
  tntlabel1.caption:=checknan(FormatFloat('0.00',(downloadprogressposition*100) / downloadprogresstotal)+' %');

  progressbar2.Position:=progressbar2.tag;
  tntlabel2.caption:=checknan(FormatFloat('0.00',(progressbar2.tag*100) / Progressbar2.max)+' %');
except
end;

ProgressBar1.repaint;
ProgressBar2.repaint;

BMDThread1.UpdateEnabled:=true;
end;

procedure TFofflineupdate.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFofflineupdate.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  if bitbtn3.Enabled=true then
    close;
end;

procedure TFofflineupdate.Timer1Timer(Sender: TObject);
begin
timer1.Enabled:=false;
BitBtn1Click(sender);
end;

end.
