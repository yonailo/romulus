unit Udirmaker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, strings, Mymessages, Uscan,
  BMDThread, GR32_Image, Tntforms, TntExtCtrls, TntButtons, TntStdCtrls, Tntfilectrl,
  TntSysutils, Gptextfile, VirtualTrees;

type
  TFdirmaker = class(TTntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    GroupBox1: TTntGroupBox;
    CheckBox1: TTntCheckBox;
    CheckBox2: TTntCheckBox;
    CheckBox3: TTntCheckBox;
    Label2: TTntLabel;
    Edit1: TTntEdit;
    RadioGroup1: TTntRadioGroup;
    SpeedButton1: TTntSpeedButton;
    BitBtn1: TTntBitBtn;
    Bevel7: TBevel;
    SpeedButton2: TTntSpeedButton;
    Bevel3: TBevel;
    Label6: TTntLabel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    ProgressBar1: TProgressBar;
    Label4: TTntLabel;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    Label3: TTntLabel;
    CheckBox4: TTntCheckBox;
    BMDThread1: TBMDThread;
    Label8: TTntLabel;
    Image3210: TImage32;
    Image322: TImage32;
    Image323: TImage32;
    Image321: TImage32;
    TntLabel1: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BMDThread1Start(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BMDThread1Terminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure BMDThread1Execute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BMDThread1Update(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer; Percent: Integer);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure syncposition( Sender : TObject );
    procedure posintoprofiles( Sender : TObject );
    procedure askfolder( Sender : TObject );
  end;

var
  Fdirmaker: TFdirmaker;

implementation

uses Umain, Ulog, UData, Math, GPHugeF;

{$R *.dfm}

procedure TFdirmaker.askfolder( Sender : TObject );
var
fold:widestring;
begin
Flog.Enabled:=false;
currentset:='';

if WideDirectoryExists(edit1.text) then
  fold:=edit1.Text
else
  fold:=GetDesktopFolder;

Fmain.positiondialogstart;

if WideSelectDirectory(getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description')),'',fold) then
  currentset:=checkpathbar(fold);

Flog.enabled:=true;
end;

procedure TFdirmaker.posintoprofiles( Sender : TObject );
begin
Datamodule1.Tprofilesview.Locate('CONT',setsposition,[]);
Datamodule1.Tprofiles.Locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
end;

procedure TFdirmaker.syncposition( Sender : TObject );
begin
Label4.Caption:=inttostr(insideposition)+' / '+inttostr(Fmain.VirtualStringTree2.SelectedCount);
progressbar1.Position:=insideposition;
ProgressBar1.Position:=insideposition;
tntlabel1.caption:=checknan(FormatFloat('0.00',(insideposition*100) / Progressbar1.max)+' %');
end;

procedure TFdirmaker.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fdirmaker);
Fmain.setlabeltoprogressbar(tntlabel1,ProgressBar1);
end;

procedure TFdirmaker.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
canclose:=bitbtn1.Enabled;

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

procedure TFdirmaker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);

opt1:=checkbox1.Checked;
opt2:=checkbox2.Checked;
opt3:=checkbox3.Checked;

if RadioGroup1.ItemIndex=0 then
  foldname:=false
else
  foldname:=true;
  
recdir:=checkbox4.Checked;
end;

procedure TFdirmaker.SpeedButton2Click(Sender: TObject);
begin
if speedbutton2.Down then begin
  myshowform(Flog,false);
end
else begin
  Flog.close;
end;
end;

procedure TFdirmaker.FormShow(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);

caption:=traduction(394);
label1.Caption:=traduction(395);
Fmain.labelshadow(label1,Fdirmaker);
label2.Caption:=traduction(396)+' :';
speedbutton1.Hint:=traduction(163);
speedbutton2.Caption:=traduction(177);
label3.Caption:=traduction(137);
label6.Caption:=traduction(140);
bitbtn3.Caption:=traduction(142);
bitbtn2.Caption:=traduction(143);
bitbtn1.Caption:=traduction(217);
checkbox4.Caption:=traduction(397);
label8.Caption:=traduction(61)+' : '+traduction(147);

groupbox1.Caption:=traduction(398);
radiogroup1.Caption:=Traduction(399);

checkbox1.Caption:=traduction(400);
checkbox2.Caption:=traduction(401);
checkbox3.Caption:=traduction(402);

RadioGroup1.Items.Strings[0]:=traduction(11);
RadioGroup1.Items.Strings[1]:=traduction(22);

label4.Caption:='0 / '+inttostr(Fmain.VirtualStringTree2.SelectedCount);

if Flog.tag=1 then begin
  speedbutton2.Down:=true;
  myshowform(Flog,false);
end
else
  speedbutton2.Down:=false;

edit1.Text:=initialdirfoldcreator;

checkbox1.Checked:=opt1;
checkbox2.Checked:=opt2;
checkbox3.Checked:=opt3;

if Foldname=false then
  RadioGroup1.ItemIndex:=0
else
  RadioGroup1.ItemIndex:=1;
  
checkbox4.Checked:=recdir;
end;

procedure TFdirmaker.SpeedButton1Click(Sender: TObject);
var
fold:widestring;
begin
Flog.Enabled:=false;

fold:=folderdialoginitialdircheck(edit1.Text);

Fmain.positiondialogstart;

if WideSelectDirectory(label2.caption,'',fold) then begin
  edit1.text:=checkpathbar(fold);
  initialdirfoldcreator:=edit1.text;
end;

Flog.enabled:=true;
end;

procedure TFdirmaker.BitBtn1Click(Sender: TObject);
begin
close;
end;

procedure TFdirmaker.BitBtn3Click(Sender: TObject);
begin
sterrors.Clear;

if (checkbox1.Checked=false) AND (checkbox2.Checked=false) AND (checkbox3.Checked=false) then
  sterrors.Add(traduction(410));

if not WideDirectoryexists(edit1.text) then
  sterrors.add(traduction(403));

if sterrors.Text<>'' then begin
  mymessageerror(sterrors.text);
  sterrors.Clear;
  exit;
end;

BMDThread1.Start;
end;

procedure TFdirmaker.BMDThread1Start(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
onathread:=true;

insideposition:=0;
progressbar1.Max:=Fmain.VirtualStringTree2.SelectedCount;

Fmain.taskbaractive(true);
Fmain.initializeprogresslabel(tntlabel1);

disablesysmenu(Fdirmaker,false);
label8.Caption:=traduction(61)+' : '+traduction(418);
Flog.SpeedButton2.Enabled:=false;
decision:=0;
stop:=False;

Fscan.preparelogline(0,-1,0,traduction(404)+' - '+datetimetostr(now),'');
Fscan.addlogline(Fdirmaker);

BitBtn1.Enabled:=false;
BitBtn3.Enabled:=false;
BitBtn2.Enabled:=true;
stablishfocus(bitbtn2);

speedbutton1.Enabled:=false;
checkbox1.Enabled:=false;
checkbox2.Enabled:=false;
checkbox3.Enabled:=false;
checkbox4.Enabled:=false;
radiogroup1.Enabled:=false;

try
  listfiles.Close;
  FreeAndNil(listfiles);
except
end;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFdirmaker.BMDThread1Terminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
onathread:=false;
progressbar1.Position:=0;
insideposition:=0;
Fmain.initializeprogresslabel(tntlabel1);

BitBtn1.Enabled:=true;
BitBtn3.Enabled:=true;
BitBtn2.Enabled:=false;
bitbtn2.Caption:=traduction(143);

speedbutton1.Enabled:=true;
checkbox1.Enabled:=true;
checkbox2.Enabled:=true;
checkbox3.Enabled:=true;
checkbox4.Enabled:=true;
radiogroup1.Enabled:=true;

if stop=false then begin
  Fscan.preparelogline(0,-1,0,traduction(405)+' - '+datetimetostr(now),'');
  Fscan.addlogline(Fdirmaker);
end
else begin
  Fscan.preparelogline(0,-1,0,traduction(416)+' - '+datetimetostr(now),'');
  Fscan.addlogline(Fdirmaker);
end;

label8.Caption:=traduction(61)+' : '+traduction(147);

disablesysmenu(Fdirmaker,true);
Flog.SpeedButton2.Enabled:=true;
freemousebuffer;
freekeyboardbuffer;

Fmain.taskbaractive(false);
end;

procedure TFdirmaker.BMDThread1Execute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
filelistpath:ansistring;
dirfield:widestring;
basedir,oldpath,foldsearch,aux,cad,none:widestring;
x,y:Longint;
pass,notdefined,definednotexists,definedandexists,done,found:boolean;
resp,respfoundpath,respsuggestpath,respmanualpath:integer;
typwrite:shortint;
n:PVirtualNode;
begin
romscounter:=0;
respfoundpath:=0;
respsuggestpath:=0;
respmanualpath:=0;
none:=traduction(347);

basedir:=Edit1.Text;

case RadioGroup1.ItemIndex of
  0:dirfield:='Description';
  1:dirfield:='Name';
end;

notdefined:=CheckBox1.Checked;
definednotexists:=checkbox2.Checked;
definedandexists:=checkbox3.Checked;

filelistpath:=tempdirectoryresources+'files.rmt';

listfiles:=TGpTextFile.CreateW(filelistpath);
listfiles.Rewrite([cfUnicode]);

Fmain.Scandirectory(basedir,'*.*',5,checkbox4.Checked);

n:=Fmain.VirtualStringTree2.GetFirst;;
for x:=0 to Fmain.VirtualStringTree2.RootNodeCount-1 do begin

  if stop=true then
    break;

  if Fmain.VirtualStringTree2.Selected[n]=true then begin


    insideposition:=insideposition+1;

    BMDThread1.Thread.Synchronize(syncposition);

    done:=false;
    pass:=false;
    cad:='';
    oldpath:='';
    typwrite:=0;

    //SYNC
    setsposition:=x+1;

    BMDThread1.Thread.Synchronize(posintoprofiles);

    //MUST GET IF ROMS EXISTS OR ONLY CHD OR SAMPLES
    Datamodule1.Taux.close;
    Datamodule1.Taux.TableName:='Z'+fillwithzeroes(Datamodule1.Tprofiles.fieldbyname('ID').Asstring,4);
    Datamodule1.Taux.Open;

    if Datamodule1.Taux.locate('Type',0,[])=true then//ROMS
      typwrite:=0
    else
    if Datamodule1.Taux.locate('Type',2,[])=true then//CHDS
      typwrite:=2
    else
    if Datamodule1.Taux.locate('Type',1,[])=true then//SAMPLES
      typwrite:=1;

    if Datamodule1.TDirectories.locate('Profile;Type',Vararrayof([Datamodule1.Tprofiles.fieldbyname('ID').AsInteger,typwrite]),[])=true then
      oldpath:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));

    oldpath:=trim(oldpath);
    oldpath:=checkpathbar(oldpath);

    if oldpath='' then begin
      if notdefined=true then
        pass:=true;

    end
    else
    If wideDirectoryExists(cad)=false then begin
      if definednotexists=true then
        pass:=true;
    end
    else
      if definedandexists=true then
        pass:=true;

    foldsearch:=getwiderecord(Datamodule1.Tprofiles.fieldbyname(dirfield));
    foldsearch:=removeconflictchars(foldsearch,false);
    foldsearch:=trim(foldsearch);

    if foldsearch='' then
      pass:=false;

    if pass=true then begin  //1ST STEP FOUND COINCIDENCES FOLDERS

      listfiles.Reset;

      if oldpath='' then
        oldpath:=none;

      while listfiles.EOF=false do begin
        cad:=listfiles.Readln;

        aux:=Changein(wideuppercase(cad),wideuppercase(basedir),'');
        aux:=copy(cad,length(cad)-length(aux)+1,length(cad));//+1  remove first bar \

        //Now aux contains strings to search
        if wideuppercase(cad)<>wideuppercase(oldpath) then begin//NO REPEAT FOLDER

          if done=false then
            for y:=0 to GetTokenCount(aux,'\')-1 do begin

              found:=false;
              if y=0 then begin
                if changein(wideuppercase(aux),changein(wideuppercase(foldsearch),' - ','\'),'')='\' then
                  found:=true
              end
              else
                if wideuppercase(gettoken(aux,'\',y))=wideuppercase(foldsearch) then
                  found:=true;

              if found=true then begin //FOUND FOLDER

                if respfoundpath=-1 then
                  resp:=-1
                else
                if respfoundpath=2 then
                  resp:=2
                else begin    //SYNC Found possible ROMs path for
                  Fscan.question(traduction(407)+' "'+getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+'"'+#10#13+traduction(414)+#10#13+oldpath+#10#13+traduction(415)+#10#13+cad,0);
                  resp:=decision;
                  respfoundpath:=resp;
                end;

                if (resp=1) OR (resp=2) then begin

                  try
                    if Datamodule1.TDirectories.locate('Profile;Type',Vararrayof([Datamodule1.Tprofiles.fieldbyname('ID').AsInteger,typwrite]),[])=true then
                      Datamodule1.TDirectories.Edit
                    else begin
                      Datamodule1.TDirectories.append;
                      Datamodule1.TDirectories.fieldbyname('Profile').asinteger:=Datamodule1.Tprofiles.fieldbyname('ID').asinteger;
                      Datamodule1.TDirectories.fieldbyname('Type').asinteger:=typwrite;
                      Datamodule1.TDirectories.fieldbyname('Compression').asinteger:=defromscomp;
                    end;

                    setwiderecord(Datamodule1.TDirectories.FieldByName('Path'),cad);
                    Datamodule1.TDirectories.Post;

                    done:=true;
                    //MESSAGE LOG
                    Fscan.preparelogline(1,15,1,traduction(411),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+#10#13+' '+cad);
                    Fscan.addlogline(Fdirmaker);

                  except
                    Datamodule1.TDirectories.Cancel; //MESSAGE LOG
                    Fscan.preparelogline(3,15,1,traduction(411),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+#10#13+' '+cad);
                    Fscan.addlogline(Fdirmaker);
                  end;

                  break;
                end
                else begin //MESSAGE LOG
                  Fscan.preparelogline(2,15,1,traduction(411),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+#10#13+' '+cad);
                  Fscan.addlogline(Fdirmaker);
                end;

              end;
            end;
        end;

      end; //EOF FILES

      if stop=true then
        done:=true;

      if done=false then //2ND STEP SUGGESTED FOLDER
        If wideDirectoryExists(basedir+foldsearch)=false then begin

          if respsuggestpath=-1 then
            resp:=-1
          else
          if respsuggestpath=2 then
            resp:=2
          else begin    //SYNC
            Fscan.question(traduction(408)+' "'+getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+'"'+#10#13+traduction(414)+#10#13+oldpath+#10#13+traduction(415)+#10#13+checkpathbar(basedir+foldsearch),1);
            resp:=decision;
            respsuggestpath:=resp;
          end;

          if (resp=1) OR (resp=2) then begin

            try

              wideforcedirectories(checkpathbar(basedir+foldsearch));  //MESSAGE LOG

              if not WideDirectoryExists(checkpathbar(basedir+foldsearch)) then
                makeexception;

              if Datamodule1.TDirectories.locate('Profile;Type',Vararrayof([Datamodule1.Tprofiles.fieldbyname('ID').AsInteger,0]),[])=true then
                Datamodule1.TDirectories.Edit
              else begin
                Datamodule1.TDirectories.append;
                Datamodule1.TDirectories.fieldbyname('Profile').asinteger:=Datamodule1.Tprofiles.fieldbyname('ID').asinteger;
                Datamodule1.TDirectories.fieldbyname('Type').asstring:='0';
                Datamodule1.TDirectories.fieldbyname('Compression').asinteger:=defromscomp;
              end;

              setwiderecord(Datamodule1.TDirectories.FieldByName('Path'),checkpathbar(basedir+foldsearch));
              Datamodule1.TDirectories.Post;

              done:=true;
              //MESSAGE LOG
              Fscan.preparelogline(1,14,1,traduction(412),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+#10#13+' '+checkpathbar(basedir+foldsearch));
              Fscan.addlogline(Fdirmaker);
            except //MESSAGE LOG
              datamodule1.TDirectories.Cancel;
              Fscan.preparelogline(3,14,1,traduction(412),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+#10#13+' '+checkpathbar(basedir+foldsearch));
              Fscan.addlogline(Fdirmaker);
            end;
          end
          else begin //MESSAGE LOG
            Fscan.preparelogline(2,14,1,traduction(412),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+#10#13+' '+checkpathbar(basedir+foldsearch));
            Fscan.addlogline(Fdirmaker);
          end;

        end;//IF Exists already asked

      if stop=true then
        done:=true;

      //3RD STEP MANUAL FOLDER
      if done=False then begin
        if respmanualpath=-1 then
          resp:=-1
        else
        if respmanualpath=2 then
          resp:=2
        else begin    //SYNC
          Fscan.question(traduction(409)+' "'+getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+'" ?'+#10#13+traduction(414)+#10#13+oldpath,2);
          resp:=decision;
          respmanualpath:=resp;
        end;

        if (resp=1) OR (resp=2) then begin

          BMDThread1.Thread.Synchronize(askfolder);

          if currentset='' then begin
            //SKIP
            Fscan.preparelogline(2,16,1,traduction(413),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description')));
            Fscan.addlogline(Fdirmaker);
          end
          else begin
            //OK
            try

              if Datamodule1.TDirectories.locate('Profile;Type',Vararrayof([Datamodule1.Tprofiles.fieldbyname('ID').AsInteger,0]),[])=true then
                Datamodule1.TDirectories.Edit
              else begin
                Datamodule1.TDirectories.append;
                Datamodule1.TDirectories.fieldbyname('Profile').asinteger:=Datamodule1.Tprofiles.fieldbyname('ID').asinteger;
                Datamodule1.TDirectories.fieldbyname('Type').asstring:='0';
                Datamodule1.TDirectories.fieldbyname('Compression').asinteger:=defromscomp;
              end;

              setwiderecord(Datamodule1.TDirectories.FieldByName('Path'),checkpathbar(currentset));
              Datamodule1.TDirectories.Post;

              Fscan.preparelogline(1,16,1,traduction(413),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'))+#10#13+' '+currentset);
              Fscan.addlogline(Fdirmaker);

            except
              //FAIL
              Datamodule1.TDirectories.cancel;
              Fscan.preparelogline(3,16,1,traduction(413),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description')));
              Fscan.addlogline(Fdirmaker);
            end;
          end;

        end
        else begin  //MESSAGE LOG
          Fscan.preparelogline(2,16,1,traduction(413),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description')));
          Fscan.addlogline(Fdirmaker);
        end;

      end;
      
    end
    else begin //Skipped by rules
      Fscan.preparelogline(2,13,1,traduction(406),getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description')));
      Fscan.addlogline(Fdirmaker);   
    end;

  end;//Listview item selected

  n:=Fmain.VirtualStringTree2.GetNext(n);

end;

try
  listfiles.Close;
  FreeAndNil(listfiles);
except

end;

Datamodule1.Taux.close;

deletefile2(filelistpath);

Thread.Terminate;
end;

procedure TFdirmaker.BMDThread1Update(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer; Percent: Integer);
begin
BMDThread1.UpdateEnabled:=false;

if decision=-2 then begin
  decision:=mymessagequestion(sterrors.Text,allbuttons);
  sterrors.Clear;
end;

BMDThread1.UpdateEnabled:=true;
end;

procedure TFdirmaker.BitBtn2Click(Sender: TObject);
begin
stop:=true;
bitbtn2.Caption:=traduction(339);
bitbtn2.Enabled:=false;
end;

procedure TFdirmaker.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFdirmaker.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  if bitbtn1.Enabled=true then
    close;
end;

end.
