unit Uscan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, strings, ImgList,
  BMDThread, CommCtrl, Hashes, Mymessages, DB,Absmain, Menus, CoolTrayIcon, GR32_Image, Tntforms, TntExtCtrls,
  TntButtons, TntStdCtrls, TntMenus, TntSysutils, TntComCtrls, TntFilectrl, Tntclasses,Gptextfile,zipforge;

type
  TFscan = class(TTntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TTntBitBtn;
    BMDThread1: TBMDThread;
    Bevel3: TBevel;
    Label2: TTntLabel;
    SpeedButton2: TTntSpeedButton;
    SpeedButton6: TTntSpeedButton;
    SpeedButton1: TTntSpeedButton;
    Edit1: TTntEdit;
    Label5: TTntLabel;
    CheckBox3: TTntCheckBox;
    CheckBox4: TTntCheckBox;
    CheckBox5: TTntCheckBox;
    Label6: TTntLabel;
    Bevel4: TBevel;
    Panel2: TTntPanel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label4: TTntLabel;
    Bevel6: TBevel;
    Edit2: TTntEdit;
    Label7: TTntLabel;
    Bevel7: TBevel;
    Label3: TTntLabel;
    Bevel5: TBevel;
    BitBtn2: TTntBitBtn;
    Label8: TTntLabel;
    TreeView1: TTntTreeView;
    ImageList2: TImageList;
    SpeedButton3: TTntSpeedButton;
    ImageList3: TImageList;
    PopupMenu1: TPopupMenu;
    Folder1: TMenuItem;
    N1: TMenuItem;
    Zip1: TMenuItem;
    Rar1: TMenuItem;
    N7z1: TMenuItem;
    N01: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    N02: TMenuItem;
    N12: TMenuItem;
    N22: TMenuItem;
    N32: TMenuItem;
    N42: TMenuItem;
    N52: TMenuItem;
    N62: TMenuItem;
    N72: TMenuItem;
    N82: TMenuItem;
    N92: TMenuItem;
    N03: TMenuItem;
    N13: TMenuItem;
    N23: TMenuItem;
    N33: TMenuItem;
    N43: TMenuItem;
    N53: TMenuItem;
    N63: TMenuItem;
    N73: TMenuItem;
    N83: TMenuItem;
    N93: TMenuItem;
    SpeedButton4: TTntSpeedButton;
    BitBtn3: TTntBitBtn;
    Panel3: TTntPanel;
    Panel4: TTntPanel;
    CheckBox1: TTntCheckBox;
    ComboBox1: TTntComboBox;
    SpeedButton5: TTntSpeedButton;
    PopupMenu2: TPopupMenu;
    Alwaysask1: TMenuItem;
    N2: TMenuItem;
    Decideyestoall1: TMenuItem;
    Decidenotoall1: TMenuItem;
    N3: TMenuItem;
    Custom1: TMenuItem;
    SpeedButton7: TTntSpeedButton;
    Image321: TImage32;
    Image322: TImage32;
    Image3210: TImage32;
    Image323: TImage32;
    Image324: TImage32;
    Image325: TImage32;
    Timer1: TTimer;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    SpeedButton8: TSpeedButton;
    TntSpeedButton1: TTntSpeedButton;
    PopupMenu3: TPopupMenu;
    Donothing1: TMenuItem;
    N4: TMenuItem;
    Sleeponterminte1: TMenuItem;
    Shutdownonterminate1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BMDThread1Execute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BMDThread1Start(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
    procedure TreeView2DblClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BMDThread1Terminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure BMDThread1Update(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer; Percent: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton3Click(Sender: TObject);
    procedure TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Folder1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Custom1Click(Sender: TObject);
    procedure Alwaysask1Click(Sender: TObject);
    procedure Decideyestoall1Click(Sender: TObject);
    procedure Decidenotoall1Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton8Click(Sender: TObject);
    procedure TntSpeedButton1Click(Sender: TObject);
    procedure Donothing1Click(Sender: TObject);
    procedure Sleeponterminte1Click(Sender: TObject);
    procedure Shutdownonterminate1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure processrom(path:widestring);
    procedure addcompressioncache(cache:widestring;compid:widestring);
    procedure addcompressioncacherebuild(cache:widestring;compid:widestring);
    procedure loadprofile(id:ansistring);
    function checkstop():boolean;
    procedure question(msg:widestring;typ:integer);
    function movetobackup(path:widestring):widestring;
    function rebuildfile(path:widestring;comptype:integer;action:integer;actionfilename:widestring;forzedindex:integer;origincomp:widestring):boolean;
    procedure setcompressionimages;
    procedure setcompression(Obj:Tobject);
    procedure processromascompressed(path,ext:widestring;comptyp:smallint;correctext:string);
    function processromasnocompress(path:widestring;origintype:integer;res:boolean):boolean;
    function correctcompext(path,ext,correctext:widestring;comptype:shortint):widestring;
    function correctcase(path,dest:widestring):widestring;
    procedure preparelogline(typ,action,indent:integer;msg1,msg2:widestring);
    procedure addlogline( Sender: TObject );
    procedure syncstatus( Sender: TObject );
    procedure disablecancelbutton( Sender : Tobject );
    procedure savechecked;
    procedure restoreactionmessage;
    function loadheader(path:widestring):boolean;
    procedure askstatoimage;
    procedure statosave;
    procedure statoload;
    procedure fixtreeviewfocus;
    procedure disableforscan(b:boolean);
    procedure shutdownorhibernate();
  end;

var
  Fscan: TFscan;
  currentset:widestring;
  stop,hascompressed:boolean;
  listfiles,cachefile,cachefilereb:Tgptextfile;
  deletelist,deleteheaderlist:TTntStringList;
  isrebuild,isrebuildbatch,issecondpass,flagscanned,scantoo:boolean;
  isoff:boolean;
  scanpath,romspath,samplespath,chdspath:widestring;
  zipcount,setsposition,insideposition:longint;
  allbuttons:boolean;
  //checked stopdecision,extensiondecision,emptydecision,renamedecision
  stopdecision,extensiondecision,renamedecision,baddumpdecision,fixdecision,deletenobackupdecision,chddecision,dupedecision:shortint;
  scanprofileid:widestring;
  romscomp,samplescomp,chdscomp:smallint;
  romscomplevel,samplescomplevel,chdscomplevel:smallint;
  backuppath:widestring;
  typ_,action_,indent_:integer;
  msg1_,msg2_,other:widestring;
  pass_,allowmerge,allowdupe,haschds,hasroms,hassamples,isdupebaddump:boolean;
  md5checked,sha1checked,md5checkedreb,sha1checkedreb:boolean;
  zipcomplv:smallint;
  fieldmode:ansistring;
  deleteheaderflag,sortedhashes,scanasnocompress:boolean;
  realcompressedfilecount:integer;
  agusfakecache:boolean;
const
  zipext='.zip';
  rarext='.rar';
  sevenzipext='.7z';
  
implementation

uses Umain, UData, Math, Ulog , Uprocessing, RAR, SevenZipVCL,
  Uask, Umessage, TntWideStrings, Userver;

//uses ZipDlls removed

{$R *.dfm}

procedure Tfscan.shutdownorhibernate();
var
continue:boolean;
begin
continue:=false;

if stop=false then
  if tntspeedbutton1.Tag<>0 then begin//SLEEP OR SHUTDOWN

    Fscan.Enabled:=false;//NEEDED

    Fmain.showprocessingwindow(true,true);

    case tntspeedbutton1.tag of
      1:Fprocessing.Panel2.Caption:=traduction(632);
      2:Fprocessing.Panel2.Caption:=traduction(633);
    end;

    Fprocessing.Panel3.Caption:='';

    while Fprocessing.tag=0 do  //COUNTDOWN
      Application.HandleMessage;

    if Fprocessing.tag=2 then
      continue:=true;

    Fmain.hideprocessingwindow;
    Fscan.Enabled:=true;//NEEDED

    if continue=true then
    case tntspeedbutton1.tag of
      1:Windowshibernate;
      2:begin
          try
            Fserver.close; //IF EXISTS
          except
          end;

          if Fmain.CoolTrayIcon1.Tag=1 then begin
            Fmain.AlphaBlend:=true;
            Fmain.cooltrayicon1.ShowMainForm;
          end;

          if formexists('Fscan')=true then
            Fscan.Close;

          try
            Fmain.saveconfig;
          except

          end;
          //showmessage('SHUTDOWN');
          WindowsExit(EWX_SHUTDOWN or EWX_FORCE);//SHUTDOWN
          halt;
        end;
    end; 
    
  end;
end;

procedure Tfscan.disableforscan(b:boolean);
var
op:boolean;
begin
op:=true;
if b=true then
  op:=false;

panel1.Enabled:=op;

checkbox3.Enabled:=op; //MD5
checkbox4.Enabled:=op; //SHA1
checkbox5.Enabled:=op;
checkbox1.Enabled:=op;
speedbutton1.Enabled:=op;
speedbutton2.Enabled:=op;
speedbutton6.Enabled:=op;
speedbutton5.enabled:=op;
speedbutton4.Enabled:=op;
speedbutton7.Enabled:=op;
combobox1.Enabled:=op;

bitbtn2.Enabled:=b;
bitbtn1.Enabled:=op;
bitbtn3.Enabled:=op;

if bitbtn2.enabled=true then
  Fscan.ActiveControl:=bitbtn2;
end;

procedure Tfscan.fixtreeviewfocus;
//var
//n:TTnttreenode;
begin

if treeview1.Items.Count>0 then
  Treeview1.Items.Item[0].Selected:=true;
{try
  n:=Treeview1.Selected;
  if n=nil then begin
    stablishfocus(Treeview1);
    Treeview1.Items.Item[0].Selected;
    stablishfocus(Bitbtn3);
  end;
except
end; }
end;


procedure Tfscan.statoload;
begin
//ASKMOD
if Datamodule1.Tprofiles.Locate('ID',scanprofileid,[])=true then begin

  fask.markradios(0); //INITIALIZE

  if Datamodule1.Tprofiles.fieldbyname('FIX0').asstring='1' then
    Fask.checkbox2.checked:=true
  else
  if Datamodule1.Tprofiles.fieldbyname('FIX0').asstring='2' then
    Fask.checkbox3.Checked:=true;

  if Datamodule1.Tprofiles.fieldbyname('FIX1').asstring='1' then
    Fask.checkbox5.checked:=true
  else
  if Datamodule1.Tprofiles.fieldbyname('FIX1').asstring='2' then
    Fask.checkbox6.Checked:=true;

  if Datamodule1.Tprofiles.fieldbyname('FIX2').asstring='1' then
    Fask.checkbox8.checked:=true
  else
  if Datamodule1.Tprofiles.fieldbyname('FIX2').asstring='2' then
    Fask.checkbox9.Checked:=true;

  if Datamodule1.Tprofiles.fieldbyname('FIX3').asstring='1' then
    Fask.checkbox11.checked:=true
  else
  if Datamodule1.Tprofiles.fieldbyname('FIX3').asstring='2' then
    Fask.checkbox12.Checked:=true;

  if Datamodule1.Tprofiles.fieldbyname('FIX4').asstring='1' then
    Fask.checkbox14.checked:=true
  else
  if Datamodule1.Tprofiles.fieldbyname('FIX4').asstring='2' then
    Fask.checkbox15.Checked:=true;

  if Datamodule1.Tprofiles.fieldbyname('FIX5').asstring='1' then
    Fask.checkbox17.checked:=true
  else
  if Datamodule1.Tprofiles.fieldbyname('FIX5').asstring='2' then
    Fask.checkbox18.Checked:=true;

  if Datamodule1.Tprofiles.fieldbyname('FIX6').asstring='1' then
    Fask.checkbox20.checked:=true
  else
  if Datamodule1.Tprofiles.fieldbyname('FIX6').asstring='2' then
    Fask.checkbox21.Checked:=true;

end;

askstatoimage;
end;

procedure Tfscan.statosave;
begin
//ASKMOD
if Datamodule1.Tprofiles.Locate('ID',scanprofileid,[])=true then begin
  Datamodule1.Tprofiles.edit;

  if Fask.CheckBox2.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX0').asstring:='1'
  else
  if Fask.CheckBox3.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX0').asstring:='2'
  else
    Datamodule1.Tprofiles.fieldbyname('FIX0').asstring:='0';

  if Fask.CheckBox5.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX1').asstring:='1'
  else
  if Fask.CheckBox6.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX1').asstring:='2'
  else
    Datamodule1.Tprofiles.fieldbyname('FIX1').asstring:='0';

  if Fask.CheckBox8.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX2').asstring:='1'
  else
  if Fask.CheckBox9.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX2').asstring:='2'
  else
    Datamodule1.Tprofiles.fieldbyname('FIX2').asstring:='0';

  if Fask.CheckBox11.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX3').asstring:='1'
  else
  if Fask.CheckBox12.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX3').asstring:='2'
  else
    Datamodule1.Tprofiles.fieldbyname('FIX3').asstring:='0';

  if Fask.CheckBox14.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX4').asstring:='1'
  else
  if Fask.CheckBox15.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX4').asstring:='2'
  else
    Datamodule1.Tprofiles.fieldbyname('FIX4').asstring:='0';

  if Fask.CheckBox17.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX5').asstring:='1'
  else
  if Fask.CheckBox18.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX5').asstring:='2'
  else
    Datamodule1.Tprofiles.fieldbyname('FIX5').asstring:='0';

  if Fask.CheckBox20.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX6').asstring:='1'
  else
  if Fask.CheckBox21.Checked then
    Datamodule1.Tprofiles.fieldbyname('FIX6').asstring:='2'
  else
    Datamodule1.Tprofiles.fieldbyname('FIX6').asstring:='0';

  Datamodule1.Tprofiles.post;
end;
end;

procedure Tfscan.askstatoimage;
var
ask,yes,no,x:integer;
begin
//ASKMOD
ask:=0;
yes:=0;
no:=0;

for x:=0 to Fask.ComponentCount-1 do
  if Fask.components[x] is TTntcheckbox then
    if (Fask.Components[x] as TTntcheckbox).checked then
      case (Fask.Components[x] as TTntcheckbox).tag of
        1:yes:=yes+1;
        2:no:=no+1;
        else
          ask:=ask+1;
      end;

Speedbutton5.Glyph.Assign(nil);

if yes=7 then begin
  Speedbutton5.Glyph:=Fask.SpeedButton2.Glyph;
end
else
if no=7 then begin
  Speedbutton5.Glyph:=Fask.SpeedButton3.Glyph;
end
else
if ask=7 then begin
  Speedbutton5.Glyph:=Fask.SpeedButton1.Glyph;
end
else begin
  Speedbutton5.Glyph:=Fask.SpeedButton7.Glyph;
end;


end;

function Tfscan.loadheader(path:widestring):boolean;
var
f:TGpTextFile;
cad,command,aux:ansistring;
x,typ:integer;
rulestartoff,ruleendoff,data,value,offset,res,mask,siz,operator:ansistring;
ruleoperation:integer;
resu:boolean;
T:Tabstable;
begin
resu:=true;

try

try
  WideFileSetAttr(path,faArchive);//IF READONLY FAILS MUST CONVERT TO WRITE TOO 0.027
except
end;

f:=TGpTextFile.CreateW(path);
f.Reset;

Datamodule1.DBHeaders.Close;
Datamodule1.DBHeaders.DatabaseFileName:=UTF8Encode(tempdirectoryheadersdbpath);
Datamodule1.DBHeaders.PageCountInExtent:=defpagecountinextent;
Datamodule1.DBHeaders.PageSize:=defpagesize;
Datamodule1.DBHeaders.MaxConnections:=defmaxconnections;
Datamodule1.DBHeaders.SilentMode:=true;
Datamodule1.DBHeaders.CreateDatabase;

//TABLE RULES
T:=Tabstable.Create(Datamodule1);
T.DatabaseName:=Datamodule1.DBHeaders.DatabaseName;
T.FieldDefs.Clear;
T.TableName:='Rules';
T.FieldDefs.Add('ID',ftAutoInc,0,False);
T.FieldDefs.Add('Start_offset',ftString,255,true);
T.FieldDefs.Add('End_offset',ftString,255,true);
T.FieldDefs.Add('Operation',ftInteger,0,true);

T.IndexDefs.Clear;
T.IndexDefs.Add('I1', 'ID', [ixPrimary]); //Speedup locate
T.CreateTable;
T.Free;

//TABLE TESTS
T:=Tabstable.Create(Datamodule1);
T.DatabaseName:=Datamodule1.DBHeaders.DatabaseName;
T.FieldDefs.Clear;
T.TableName:='Tests';
T.FieldDefs.Add('ID',ftAutoInc,0,False);
T.FieldDefs.Add('Test',ftinteger,0,true);
T.FieldDefs.Add('Offset_size',ftString,255,false);
T.FieldDefs.Add('Value',ftString,255,false);
T.FieldDefs.Add('Mask',ftString,255,false);
T.FieldDefs.Add('Operator_bool',ftinteger,0,false);
T.FieldDefs.Add('Correctresult',ftBoolean,0,true);
T.FieldDefs.Add('Rule',ftinteger,0,true);

T.IndexDefs.Clear;
T.IndexDefs.Add('I1', 'ID', [ixPrimary]); //Speedup locate
T.IndexDefs.Add('I2', 'Rule', []);
T.CreateTable;
T.Free;

Datamodule1.Trules.Open;
Datamodule1.Ttest.Open;


While f.EOF=false do begin

  cad:=f.Readln;
  cad:=trim(cad);
  cad:=Wideuppercase(cad);

  if (gettokencount(cad,'<')>1) AND (gettokencount(cad,'>')>1) then begin

    cad:=gettoken(cad,'<',2);
    cad:=gettoken(cad,'>',1);
    cad:=trim(cad);

    command:=gettoken(cad,' ',1);

    rulestartoff:='0';
    ruleendoff:='EOF';
    ruleoperation:=0;
    offset:='0';
    value:='';
    res:='TRUE';
    mask:='';
    siz:='';
    operator:='EQUAL';
    typ:=-1;

    for x:=2 to gettokencount(cad,' ') do begin //DATA OF A LINE

      aux:=gettoken(cad,' ',x);
      aux:=trim(aux);

      if gettokencount(aux,'=')=2 then begin

        data:=gettoken(aux,'"',2);
        data:=trim(data);
        aux:=trim(gettoken(aux,'=',1));
        data:=Wideuppercase(data);
        aux:=Wideuppercase(aux);

        if command='RULE' then begin

          if aux='START_OFFSET' then
            rulestartoff:=data
          else
          if aux='END_OFFSET' then
            ruleendoff:=data
          else
          if aux='OPERATION' then begin
            if data='BYTESWAP' then// 01 02 > 02 01
              ruleoperation:=2
            else
            if data='WORDSWAP' then//01 02 03 04 > 04 03 02 01
              ruleoperation:=3
            else
            if data='BITSWAP' then
              ruleoperation:=1;

          end;

          typ:=0;

        end//RULE
        else
        if command='DATA' then begin

          if aux='OFFSET' then
            offset:=data
          else
          if aux='VALUE' then
            value:=data
          else
          if aux='RESULT' then
            res:=data;

          typ:=1;

        end//DATA
        else
        if (command='OR') OR (command='XOR') OR (command='AND') then begin

          if aux='OFFSET' then
            offset:=data
          else
          if aux='VALUE' then
            value:=data
          else
          if aux='MASK' then
            mask:=data
          else
          if aux='RESULT' then
            res:=data;

          typ:=2;

        end//BOOL
        else
        if command='FILE' then begin

          if aux='SIZE' then
            siz:=data
          else
          if aux='OPERATOR' then
            operator:=data
          else
          if aux='RESULT' then
            res:=data;

          typ:=3;

        end;

      end; //GETTING VALUE

    end;//DATA OF A LINE

    case typ of
      0:begin  //RULE

          strtoint('$'+rulestartoff);
          if ruleendoff<>'EOF' then
            strtoint('$'+ruleendoff);

          Datamodule1.Trules.Append;
          Datamodule1.Trules.fieldbyname('start_offset').asstring:=rulestartoff;
          Datamodule1.Trules.FieldByName('end_offset').asstring:=ruleendoff;
          Datamodule1.Trules.FieldByName('Operation').asinteger:=ruleoperation;
          Datamodule1.Trules.Post;
        end;
      1:begin // DATA
          if (value='') OR (Datamodule1.Trules.IsEmpty) OR ((res<>'TRUE') AND (res<>'FALSE')) then
            makeexception
          else begin

            if Length(value) mod 2<>0 then
              makeexception;

            Datamodule1.Ttest.Append;
            Datamodule1.Ttest.fieldbyname('Test').AsInteger:=typ;
            Datamodule1.Ttest.fieldbyname('Offset_size').asstring:=offset;
            Datamodule1.Ttest.FieldByName('Value').asstring:=value;
            Datamodule1.Ttest.FieldByName('Correctresult').AsBoolean:=StrToBool(res);
            Datamodule1.Ttest.FieldByName('Rule').asinteger:=Datamodule1.Trules.fieldbyname('ID').asinteger;
            Datamodule1.Ttest.Post;

          end;
        end;
      2:begin
          if (mask='') OR (value='') OR (Length(mask)<>length(value)) then
            makeexception
          else begin
            if Length(mask) mod 2 <>0 then
              makeexception;

            if Length(value) mod 2 <>0 then
              makeexception;

            if command='AND' then
              command:='0'
            else
            if command='OR' then
              command:='1'
            else
            if command='XOR' then
              command:='2';

            if offset<>'EOF' then
              strtoint('$'+offset);

            Datamodule1.Ttest.Append;
            Datamodule1.Ttest.fieldbyname('Test').AsInteger:=typ;
            Datamodule1.Ttest.fieldbyname('Offset_size').asstring:=offset;
            Datamodule1.Ttest.fieldbyname('Mask').asstring:=mask;
            Datamodule1.Ttest.FieldByName('Value').asstring:=value;
            Datamodule1.Ttest.FieldByName('Correctresult').AsBoolean:=StrToBool(res);
            Datamodule1.Ttest.FieldByName('Operator_bool').asinteger:=strtoint(command);
            Datamodule1.Ttest.FieldByName('Rule').asinteger:=Datamodule1.Trules.fieldbyname('ID').asinteger;
            Datamodule1.Ttest.Post;
          end;
        end;
      3:begin //FILE
          if siz='' then
            makeexception
          else begin
            if operator='EQUAL' then
              command:='1'
            else
            if operator='LESS' then
              command:='0'
            else
            if operator='GREATER' then
              command:='2'
            else
              makeexception;

            if siz<>'PO2' then
              strtoint64(siz);

            Datamodule1.Ttest.Append;
            Datamodule1.Ttest.fieldbyname('Test').AsInteger:=typ;
            Datamodule1.Ttest.fieldbyname('Offset_size').asstring:=siz;
            Datamodule1.Ttest.FieldByName('Correctresult').AsBoolean:=StrToBool(res);
            Datamodule1.Ttest.FieldByName('Operator_bool').asinteger:=strtoint(command);
            Datamodule1.Ttest.FieldByName('Rule').asinteger:=Datamodule1.Trules.fieldbyname('ID').asinteger;
            Datamodule1.Ttest.Post;
          end;

        end;
    end;

  end;//VALIDATION LINE

end; //FILE LOOP

except
  resu:=false;
  Datamodule1.DBheaders.Close;
end;

try
  f.Close;
  FreeAndNil(f);
except
end;

Result:=resu;
end;

procedure Tfscan.restoreactionmessage;
begin
if isdupebaddump=true then
  other:=traduction(61)+' : '+traduction(419)
else
if (isrebuild=false) OR (issecondpass=true) then
  other:=traduction(61)+' : '+traduction(149)
else
  other:=traduction(61)+' : '+traduction(200);

BMDThread1.Thread.Synchronize(syncstatus);
end;

procedure Tfscan.savechecked;
begin
Datamodule1.Tprofiles.Edit;
Datamodule1.Tprofiles.fieldbyname('MD5').AsBoolean:=checkbox3.Checked;
Datamodule1.Tprofiles.fieldbyname('SHA1').AsBoolean:=checkbox4.Checked;
Datamodule1.Tprofiles.fieldbyname('TZ').AsBoolean:=checkbox5.Checked;
Datamodule1.Tprofiles.fieldbyname('T7Z').AsBoolean:=checkbox1.Checked;
Datamodule1.Tprofiles.Post;
end;

procedure TFscan.disablecancelbutton( Sender :tObject);
begin
bitbtn2.Enabled:=false;
end;


procedure TFscan.syncstatus( Sender : TObject );
begin
Label8.Caption:=other;
end;

procedure TFscan.preparelogline(typ,action,indent:integer;msg1,msg2:widestring);
begin
msg1_:=msg1;
msg2_:=msg2;
typ_:=typ;
action_:=action;
indent_:=indent;
end;

procedure Tfscan.addlogline( Sender: TObject );
var
x,aux,cont:Integer;
msg3:widestring;
begin
x:=0;

if GetTokenCount(msg2_,#10#13)>1 then
  msg3:=gettoken(msg2_,#10#13,3);

msg2_:=gettoken(msg2_,#10#13,1);

Flog.VirtualStringTree1.BeginUpdate;

cont:=Flog.VirtualStringTree1.rootnodecount+1;

While cont>maxloglines do begin //MAX LOG LINES CONTROL

  aux:=strtoint(stateindexlist.Strings[0]);

  case aux of
    1:x:=strtoint(Flog.Panel18.caption);
    2:x:=strtoint(Flog.Panel5.caption);
    3:x:=strtoint(Flog.Panel6.caption);
  end;

  x:=x-1;

  case aux of
    1:Flog.Panel18.caption:=fillwithzeroes(inttostr(x),4);
    2:Flog.Panel5.caption:=fillwithzeroes(inttostr(x),4);
    3:Flog.Panel6.caption:=fillwithzeroes(inttostr(x),4);
  end;

  Flog.VirtualStringTree1.rootnodecount:=Flog.VirtualStringTree1.rootnodecount-1;

  stateindexlist.Delete(0);
  imageindexlist.Delete(0);
  column0list.Delete(0);
  column1list.Delete(0);
  column2list.Delete(0);

  cont:=cont-1;
end;

stateindexlist.Add(inttostr(typ_));
imageindexlist.Add(inttostr(action_));
column0list.Add(msg1_);
column1list.Add(msg2_);
column2list.Add(msg3);

Flog.VirtualStringTree1.RootNodeCount:=Flog.VirtualStringTree1.RootNodeCount+1;

Flog.VirtualStringTree1.EndUpdate;

if (Fmain.CoolTrayIcon1.Tag=1) AND (typ_=0) then //BALLOON
  Fmain.showballoon(trim(msg1_),trim(msg2_),10,bitInfo);

if Flog.speedbutton3.Down=true then //AUTOSCROLL
  posintoindexbynode(Flog.VirtualStringTree1.GetLast,Flog.VirtualStringTree1);

//COLUMNS SIZE CONTROL
Flog.label1.Caption:=changein(msg1_,'&','&&');
if Flog.VirtualStringTree1.header.Columns[0].Width<Flog.label1.width+60 then begin
  if Flog.SpeedButton4.Down=true then
    Flog.VirtualStringTree1.header.Columns[0].Width:=Flog.label1.width+60;
  Flog.VirtualStringTree1.header.Columns[0].Tag:=Flog.label1.width+60;
end;

Flog.label1.Caption:=changein(msg2_,'&','&&');
if Flog.VirtualStringTree1.header.Columns[1].Width<Flog.label1.width+20 then begin
  if Flog.SpeedButton4.Down=true then
    Flog.VirtualStringTree1.header.Columns[1].Width:=Flog.label1.width+20;
  Flog.VirtualStringTree1.header.Columns[1].Tag:=Flog.label1.width+20;
end;

Flog.label1.Caption:=changein(msg3,'&','&&');
if Flog.VirtualStringTree1.header.Columns[2].Width<Flog.label1.width+20 then begin
  if Flog.SpeedButton4.Down=true then
    Flog.VirtualStringTree1.header.Columns[2].Width:=Flog.label1.width+20;
  Flog.VirtualStringTree1.header.Columns[2].Tag:=Flog.label1.width+20;
end;

//COUNTER
x:=0;

try
  case typ_ of
    1:x:=strtoint(Flog.Panel18.caption);
    2:x:=strtoint(Flog.Panel5.caption);
    3:x:=strtoint(Flog.Panel6.caption);
  end;
except
end;

x:=x+1;

case typ_ of
  1:Flog.Panel18.caption:=fillwithzeroes(inttostr(x),4);
  2:Flog.Panel5.caption:=fillwithzeroes(inttostr(x),4);
  3:Flog.Panel6.caption:=fillwithzeroes(inttostr(x),4);
end;

application.processmessages;//POSSIBLE FIX FOR FREEZES WHEN CONTINUOUS LOGGING
end;

procedure Tfscan.setcompression(Obj:Tobject);
var
aux:ansistring;
level,comp:integer;
n:TTnttreenode;
begin
aux:=(Obj as Tmenuitem).Name;
try
  aux:=Changein(aux,'N','');
  level:=strtoint(aux[1]);
  comp:=strtoint(aux[2]);
  comp:=comp*10;
  comp:=comp+level;
except
  comp:=0;
end;

n:=treeview1.Selected;
if n=nil then
  exit;

TreeView1.Items[n.Index].Data:=Pointer(comp);

if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(scanprofileid),n.ImageIndex]),[])=true then
  Datamodule1.TDirectories.Edit
else begin
  Datamodule1.TDirectories.insert;
end;

Datamodule1.TDirectories.Fieldbyname('Compression').asinteger:=Integer( TreeView1.Items[n.index].Data );
Datamodule1.TDirectories.FieldByName('Profile').asinteger:=strtoint(scanprofileid);
//Datamodule1.TDirectories.FieldByName('Path').asstring:=path;
Datamodule1.TDirectories.Fieldbyname('Type').asstring:=inttostr(n.imageindex);

Datamodule1.TDirectories.post;

setcompressionimages;
end;

procedure TFscan.setcompressionimages;
var
bt,mask:Tbitmap;
imidx,comp,x:integer;
cl:Tcolor;
begin
bt:=TBitmap.Create;
mask:=Tbitmap.Create;

for x:=0 to TreeView1.Items.Count-1 do begin

  bt.Assign(nil);
  mask.Assign(nil);
  comp:=Integer( TreeView1.Items[x].Data );

  imidx:=0;

  while comp>=10 do begin
    comp:=comp-10;
    imidx:=imidx+1;
  end;

  case imidx of
    0:cl:=clGreen;
    1:cl:=clblue;
    2:cl:=clwhite;
    3:cl:=clred;
  else begin
    cl:=clgreen;
    comp:=0;
    imidx:=0;
  end;
  end;

  bt.Canvas.Brush.Style := bsclear;
  bt.Canvas.Brush.color:=Tcolor(clnone);

  ImageList3.GetBitmap(imidx,bt);

  bt.Canvas.Font.Name:=defaultfontname;//NEEDED FOR SOME OS ELSE CAN BE OTHER LIKE ARIAL
  bt.Canvas.Font.Color:=cl;
  bt.Canvas.Font.Style:=[fsbold];
  bt.canvas.Font.Size:=8;
  bt.Canvas.Brush.Style := bsclear;

  if imidx<>0 then
    bt.Canvas.TextOut(3,0,inttostr(comp));

  mask.Assign(bt);
  mask.Canvas.Brush.Color := Tcolor(clnone);
  mask.Monochrome := true;

  ImageList2.Replace(TreeView1.Items[x].ImageIndex+1,bt,mask);
end;

bt.free;
mask.free;
end;

function getcompressionimage(id:integer):integer;
var
res:integer;
begin

case id of
  0..9:res:=0;
  10..19:res:=1;
  20..29:res:=2;
  30..39:res:=3;
else
  res:=0;
end;

Result:=res;
end;

procedure Tfscan.loadprofile(id:ansistring);
var
n:TTnttreenode;
x:integer;
bmp:Tbitmap;
aux:string;
pass:boolean;
begin
//0.043 PART1
LockWindowUpdate(Handle);

id:=fillwithzeroes(id,4);//FIX 0.041
hasroms:=false;
hassamples:=false;
haschds:=False;
checkbox3.Checked:=false;
checkbox4.Checked:=false;
checkbox5.Checked:=false;
checkbox1.Checked:=false;
isoff:=false;
checkbox3.tag:=0;
checkbox4.Tag:=0;

Datamodule1.Tprofiles.Locate('ID',StrToInt(id),[]);
aux:=Datamodule1.Tprofiles.fieldbyname('Original').asstring;

//PUT IMAGE DAT TYPE
x:=getdattypeiconindexfromchar(aux);
if x=14 then
  isoff:=true;

if image3210.Tag<>x then begin  //0.040 PREVENT RELOAD SAME IMAGE
  bmp:=Tbitmap.Create;
  image3210.Canvas.Fillrect(image3210.Canvas.ClipRect);
  Fmain.ImageList2.GetBitmap(x,bmp);
  image3210.Bitmap.Assign(bmp);
  image3210.Tag:=x;
  bmp.free;
end;

x:=Datamodule1.Tprofiles.fieldbyname('Filemode').AsInteger;
case x of
  0:begin
      allowmerge:=true;//Same file 
      allowdupe:=false;
      panel3.caption:=splitmergestring(0);
    end;
  1:begin
      allowmerge:=false;//Normal
      allowdupe:=true;
      panel3.caption:=splitmergestring(1);
    end;
  2:begin
      allowmerge:=true;//Big size
      allowdupe:=true;
      panel3.caption:=splitmergestring(2);
    end;
else
  allowdupe:=false;
  allowmerge:=false;
  panel3.caption:=splitmergestring(1);
end;

edit2.Text:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'));

Datamodule1.Tscansets.Close;
Datamodule1.Tscanroms.Close;

Datamodule1.Tscansets.TableName:='Y'+id;
Datamodule1.Tscanroms.TableName:='Z'+id;

Datamodule1.TDirectories.Open; //Must already opened

if (Datamodule1.Tprofiles.FieldByName('Hasroms').AsBoolean=false) AND (Datamodule1.Tprofiles.FieldByName('Hassamples').AsBoolean=false) AND (Datamodule1.Tprofiles.FieldByName('Haschds').AsBoolean=false) then begin

  Datamodule1.Tscanroms.open;    //Check speed
  Datamodule1.Tscansets.open;

  Treeview1.Items.BeginUpdate;
  Treeview1.Items.Clear;

  //Directories
  for x:=0 to 2 do begin
                                //Check speed
    if Datamodule1.Tscanroms.Locate('Type',inttostr(x),[]) then begin//Roms dir

      Datamodule1.Tprofiles.Edit;

      case x of
        0:Datamodule1.Tprofiles.fieldbyname('Hasroms').asboolean:=true;
        1:Datamodule1.Tprofiles.fieldbyname('Hassamples').asboolean:=true;
        2:Datamodule1.Tprofiles.fieldbyname('Haschds').asboolean:=true;
      end;

      Datamodule1.Tprofiles.post;

      n:=Treeview1.Items.Add(nil,'');
      n.text:='';
      n.ImageIndex:=x;
      n.SelectedIndex:=x;
      n.StateIndex:=x+1;

      if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(id),inttostr(x)]),[])=true then begin

        n.text:=checkpathbar(getwiderecord(Datamodule1.TDirectories.fieldbyname('Path')));
        TreeView1.Items[n.Index].Data:=Pointer(Datamodule1.TDirectories.fieldbyname('Compression').asinteger);

      end
      else begin//Default compressions

        case x of
          0:TreeView1.Items[n.Index].Data:=Pointer(defromscomp);
          1:TreeView1.Items[n.Index].Data:=Pointer(defsamplescomp);
          2:TreeView1.Items[n.Index].Data:=Pointer(defchdscomp);
        end;

      end;

    end;

  end;

  Treeview1.Items.EndUpdate;
end//HASROMS SAMPLES CHDS
else begin

  TreeView1.Items.BeginUpdate;
  treeview1.Items.Clear;

  for x:=0 to 2 do begin
    pass:=false;

    case x of
      0:pass:=Datamodule1.Tprofiles.FieldByName('Hasroms').asboolean;
      1:pass:=Datamodule1.Tprofiles.FieldByName('Hassamples').asboolean;
      2:pass:=Datamodule1.Tprofiles.FieldByName('Haschds').asboolean;
    end;

    if pass=true then begin

      n:=Treeview1.Items.Add(nil,'');
      n.text:='';
      n.ImageIndex:=x;
      n.SelectedIndex:=x;
      n.StateIndex:=x+1;

      if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(id),inttostr(x)]),[])=true then begin

        n.text:=checkpathbar(getwiderecord(Datamodule1.TDirectories.fieldbyname('Path')));
        TreeView1.Items[n.Index].Data:=Pointer(Datamodule1.TDirectories.fieldbyname('Compression').asinteger);

      end
      else begin//Default compressions

        case x of
          0:TreeView1.Items[n.Index].Data:=Pointer(defromscomp);
          1:TreeView1.Items[n.Index].Data:=Pointer(defsamplescomp);
          2:TreeView1.Items[n.Index].Data:=Pointer(defchdscomp);
        end;

      end;

    end;

  end;

  treeview1.Items.EndUpdate;
end;

//0.037
hasroms:=Datamodule1.Tprofiles.FieldByName('Hasroms').asboolean;
hassamples:=Datamodule1.Tprofiles.FieldByName('Hassamples').asboolean;
haschds:=Datamodule1.Tprofiles.FieldByName('Haschds').asboolean;

//Backup path  //Check speed
edit1.text:=getbackuppathofid(strtoint(id));

//REMOVED BY SPEED PROBLEM HASMD5 HASSHA1 WILL BE CHECKED AT SCAN
{if isoff=false then begin //ONLY FOR NOT OL PROFILES

  {DataModule1.Qaux.Close;
  Datamodule1.Qaux.SQL.Clear;
  Datamodule1.Qaux.SQL.Add('SELECT COUNT(*) FROM Z'+id+' WHERE MD5<>''''');
  Datamodule1.Qaux.SQL.Add('UNION');
  Datamodule1.Qaux.SQL.Add('SELECT COUNT(*) FROM Z'+id+' WHERE SHA1<>''''');
  Datamodule1.Qaux.Open; }

  {DataModule1.Qaux.Close;
  Datamodule1.Qaux.SQL.Clear;
  Datamodule1.Qaux.SQL.Add('SELECT MD5 FROM Z'+id+' ORDER BY MD5 DESC');
  Datamodule1.Qaux.Open;

  //MD5
  if (Datamodule1.Qaux.fieldbyname('MD5').asstring='') then begin
    checkbox3.Enabled:=false;
    checkbox3.tag:=1;
  end
  else
  if Datamodule1.Tprofiles.FieldByName('MD5').AsBoolean=true then
    checkbox3.Checked:=true;


  DataModule1.Qaux.Close;
  Datamodule1.Qaux.SQL.Clear;
  Datamodule1.Qaux.SQL.Add('SELECT SHA1 FROM Z'+id+' ORDER BY SHA1 DESC');
  Datamodule1.Qaux.Open;

  //SHA1
  if (Datamodule1.Qaux.fieldbyname('SHA1').asstring='') then begin
    checkbox4.Enabled:=false;
    checkbox4.Tag:=1;
  end
  else
  if Datamodule1.Tprofiles.FieldByName('SHA1').AsBoolean=true then
    checkbox4.Checked:=true;

  DataModule1.Qaux.Close;
  Datamodule1.Qaux.SQL.Clear;
end
else begin
  checkbox3.Enabled:=false;
  checkbox4.Enabled:=false;
end;    }
if Datamodule1.Tprofiles.FieldByName('MD5').AsBoolean=true then
  checkbox3.Checked:=true;

if Datamodule1.Tprofiles.FieldByName('SHA1').AsBoolean=true then
  checkbox4.Checked:=true;

checkbox5.Checked:=Datamodule1.Tprofiles.FieldByName('TZ').AsBoolean;

if Datamodule1.Tprofiles.FieldByName('T7Z').AsBoolean=true then
  checkbox1.Checked:=true;

Datamodule1.Qaux.close;

//HEADERS
combobox1.Items.Clear;
combobox1.items.add('< '+traduction(377)+' >');
combobox1.itemindex:=0;

decision:=2;
if WideDirectoryExists(headerspath) then
  Fmain.Scandirectory(headerspath,'*.xml',4,false);

for x:=1 to combobox1.items.Count-1 do
  if wideuppercase(combobox1.items.Strings[x])=wideuppercase(getwiderecord(Datamodule1.Tprofiles.fieldbyname('Header'))) then begin
    combobox1.ItemIndex:=x;
    combobox1.Tag:=x;
  end;

scanprofileid:=id;

setcompressionimages;

//0.043 PART 2
LockWindowUpdate(0);
Fscan.repaint;
end;

procedure Tfscan.question(msg:widestring;typ:integer);
begin
allbuttons:=true;
sterrors.clear;
sterrors.Add(msg);
decision:=-2;//FORZE MESSAGE

while decision=-2 do
  sleep(250);

case typ of
  0:extensiondecision:=decision;//ZIP RAR 7Z
  1:renamedecision:=decision;//Case correction
  2:baddumpdecision:=decision;//Create baddump files
  3:chddecision:=decision;//Check sha1 of chds
  4:fixdecision:=decision;//Fix entire incorrect file
  5:deletenobackupdecision:=decision; //Delete file never back
  6:dupedecision:=decision;// Add a duplicate rom
end;

end;

function TFscan.checkstop():boolean;
var
s:boolean;
begin
s:=false;
allbuttons:=false;

if stop=true then begin

  if stopdecision<>1 then begin //No ask

    sterrors.Add(traduction(178));

    decision:=-2;//FORZE MESSAGE

    while decision=-2 do begin
      sleep(50);
    end;

    stopdecision:=decision;

    if stopdecision=1 then
      s:=true
    else
      stop:=false;

  end
  else
    s:=true;

end;

Result:=s;
end;

function TFscan.movetobackup(path:widestring):widestring;
var
fname,destpath:widestring;
res:boolean;
begin
res:=false;

fname:=wideExtractFileName(path);

destpath:=backuppath+fname;
                        
destpath:=getvaliddestination(destpath);

if FileExists2(path) then begin
  try
    wideForceDirectories(backuppath);
    if destpath<>'' then
      res:=movefile2(path,destpath);
  except
  end;
end;

if res=false then
  destpath:='';

Result:=destpath;
end;

procedure addtostidscrc(z:integer);
var
x:integer;
crc:string;
begin
//SET TO FIRST POSSITION
crc:=Treccrcs(reccrcs[z]).checksum_;
x:=z;

while x>=0 do begin

  if Treccrcs(reccrcs[x]).checksum_<>crc then begin
    x:=x+1;
    break;
  end;

  x:=x-1;
end;

if x=-1 then //FIX WHEN FIRST
  x:=0;

for z:=x to reccrcs.Count-1 do
  if Treccrcs(reccrcs[z]).checksum_=crc then begin
    stids.Add(inttostr(Treccrcs(reccrcs[z]).id_));
  end;

end;

procedure addtostidsmd5(z:integer);
var
x:integer;
md5:string;
begin
//SET TO FIRST POSSITION
md5:=Trecmd5s(recmd5s[z]).checksum_;
x:=z;

while x>=0 do begin
  if Trecmd5s(recmd5s[x]).checksum_<>md5 then begin
    x:=x+1;
    break;
  end;
  x:=x-1;
end;

if x=-1 then //FIX WHEN FIRST
  x:=0;

for z:=x to recmd5s.Count-1 do
  if Trecmd5s(recmd5s[z]).checksum_=md5 then
    stids.Add(inttostr(Trecmd5s(recmd5s[z]).id_));

end;

procedure addtostidssha1(z:integer);
var
x:integer;
sha1:string;
begin
//SET TO FIRST POSSITION
sha1:=Treccrcs(recsha1s[z]).checksum_;
x:=z;

while x>=0 do begin
  if Trecsha1s(recsha1s[x]).checksum_<>sha1 then begin
    x:=x+1;
    break;
  end;
  x:=x-1;
end;

if x=-1 then //FIX WHEN FIRST
  x:=0;

for z:=x to recsha1s.Count-1 do
  if Trecsha1s(recsha1s[z]).checksum_=sha1 then
    stids.Add(inttostr(Trecsha1s(recsha1s[z]).id_));

end;

function Tfscan.rebuildfile(path:widestring;comptype:integer;action:integer;actionfilename:widestring;forzedindex:integer;origincomp:widestring):boolean;
var
x,y,z,k,count:longint;
aux,aux2,aux3,aux4,aux5,aux6,aux7,aux8,dest,subpathmsg,originalpath,resizedfilename,rebuildoldfile:widestring;
crc,md5,sha1,crc1,md51,sha11,crc2,md52,sha12,sha1chd,invertedcrc,ext:string;
crcdb,sha1db,md5db,realcrc:string;
typ,destcomp,ini:shortint;
move,continue,delete,offhave,isinvertedcrc:boolean;
space,space1,spacedb,space2,realspace:currency;
deletecompressed,multdelete:boolean;
mustresize:boolean;
isdummy,pass,reuse:boolean;
hcnt:integer;
cache,cachereb,auxcache:widestring;
cacherebidx:longint;
cachedsize:currency;
cachedcrc,cachedmd5,cachedsha1:string;
//relativefolder:widestring;
begin
{
rebuildfile(s2,0,1,'',n2,origincomp);
path : path of file to rebuild
comptype : file of path compression method
action : action to do 0=normal 1=header fix
actionfilename : original filename if header fixed
forzedindex : forzed ID of Troms table to rebuild it used to rebuild bad dumps
rebuildoldfile : used to display rebuilded already existing dupe file
}

isdummy:=false;
mustresize:=false;
deletecompressed:=False;
move:=false;
originalpath:=path;
space:=0;
ini:=0;
deletelist.Clear;
rebuildoldfile:='';
cacherebidx:=-1;
cachedsize:=-1;
cachedcrc:='';
cachedmd5:='';
cachedsha1:='';

if Fmain.zip2.tag>0 then //0.028
  if wideuppercase(Fmain.zip2.filename)=wideuppercase(path) then begin
    try
      Fmain.Zip2.CloseArchive;
    except
    end;
    Fmain.zip2.tag:=0;
  end;

//Simple check
if not fileexists2(path) then begin
  restoreactionmessage;
  Result:=true;
  exit;
end;

//If is in scan path then move to backup to rebuild later
if (gettoken(wideuppercase(path),wideuppercase(romspath),1)<>wideuppercase(path)) OR (gettoken(wideuppercase(path),wideuppercase(samplespath),1)<>wideuppercase(path)) OR (gettoken(wideuppercase(path),wideuppercase(chdspath),1)<>wideuppercase(path)) then
  move:=true;

//0.035 FIX
if FileInUse(path) then begin
  if (wideuppercase(Fmain.Zip1.FileName)=wideuppercase(path)) AND (Fmain.zip1.tag>0) then begin
  //DO NONE
  end
  else begin
    preparelogline(2,5,1,traduction(180),originalpath);
    BMDThread1.Thread.Synchronize(addlogline);
    restoreactionmessage;
    Result:=true;
    exit;
  end;
end;

if sortedhashes=false then begin //0.028 SORT TO SPEEDUP SEARCHES ONLY FIRST TIME
  sortedhashes:=true;
  reccrcs.Sort(reccrcsbinarysort);
  recmd5s.Sort(recmd5sbinarysort);
  recsha1s.Sort(recsha1sbinarysort);
end;


//-------------1ST STEP ASK FOR FIX 100% Completed!!!

if fixdecision<>-1 then begin

    if move=true then begin//Not ask if real rebuild
      if fixdecision<>2 then
        question(traduction(306)+' '+traduction(315)+#10#13+path+#10#13+traduction(317),4);
    end;

end;

if move=true then //ASK ONLY IF MOVE FROM ROMSPATH ELSE ALWAYS FIX ****
  if (fixdecision=-1) OR (fixdecision=0) then begin//Skip fix
    preparelogline(2,0,1,traduction(306),originalpath);
    BMDThread1.Thread.Synchronize(addlogline);
    restoreactionmessage;
    Result:=false;
    exit;
  end;

Result:=true;

if move=true then begin

  other:=traduction(61)+' : '+traduction(316);//Fixing status
  BMDThread1.Thread.Synchronize(syncstatus);

  //0.036 FIX MUST RELEASE FILE TO BE COPIED
  if (comptype=1) then begin
    Fmain.zip1.closearchive;
    Fmain.zip1.Tag:=0;
  end;

  path:=movetobackup(path);

  if path='' then begin//Error moving to backup

    preparelogline(3,8,1,traduction(172),originalpath);
    BMDThread1.Thread.Synchronize(addlogline);

    restoreactionmessage;
    exit;
  end
  else
    preparelogline(1,8,1,traduction(172),originalpath+#10#13+' '+path);
    BMDThread1.Thread.Synchronize(addlogline);

    //ONLY IF MOVED = REBUILDING FROM ROMSPATH
    //SET TO FALSE ALL POSSIBLE ALREADY SCANNED SET AFTER REBUILD
    aux:=wideExtractFileName(originalpath);
    aux:=filewithoutext(aux);

    if wideuppercase(getwiderecord(Datamodule1.Tscansets.FieldByName('Gamename')))=wideuppercase(aux) then begin

      aux:=wideuppercase(wideextractfilepath(originalpath));

      //CHANGED SINCE 0.026 BUG FIX NO MASTER/DETAIL
      Datamodule1.Qaux.Close;
      Datamodule1.Qaux.sql.Clear;
      Datamodule1.Qaux.SQL.Add('SELECT * FROM Z'+scanprofileid);
      Datamodule1.Qaux.SQL.Add('WHERE');

      if (allowmerge=true) AND (allowdupe=false) then //Is Not split
        Datamodule1.Qaux.SQL.Add('Setnamemaster = '+Datamodule1.Tscansets.fieldbyname('ID').asstring)
      else
        Datamodule1.Qaux.SQL.Add('Setname = '+Datamodule1.Tscansets.fieldbyname('ID').asstring);

      Datamodule1.Qaux.open;

      while not Datamodule1.Qaux.eof do begin

        continue:=false;

        case Datamodule1.Qaux.fieldbyname('Type').AsInteger of//ROMS SAMPLES CHDS
          0:if (romscomp=comptype) AND (wideuppercase(romspath)=aux) then
            continue:=true;
          1:if (samplescomp=comptype) AND (wideuppercase(samplespath)=aux) then
            continue:=True;
          2:if (chdscomp=comptype) AND (wideuppercase(chdspath)=aux) then
            continue:=true;
        end;

        if (continue=true) AND (Datamodule1.Qaux.fieldbyname('Have').asboolean=true) then begin //Only for roms
          Datamodule1.Tscanroms.Locate('ID',Datamodule1.Qaux.fieldbyname('ID').asinteger,[]);
          Datamodule1.Tscanroms.edit;
          Datamodule1.Tscanroms.fieldbyname('Have').asboolean:=false;
          Datamodule1.Tscanroms.post;
        end;

        Datamodule1.Qaux.next;

      end;

      //RELEASE QUERY
      Datamodule1.Qaux.Close;
      Datamodule1.Qaux.SQL.Clear;
    end;

end//HERE 0.040 new cache mode ELSE BECAUSE NO MOVE BTW IS REBUILD
else //0.043 CACHE FOR AGUS
if ((action=0) AND (comptype=0)) OR ((action=0) AND (hascompressed=true)) then begin //0.043fix
  cachereb:=wideuppercase(path)+'*'+inttohex(sizeoffile(path),0)+'*'+Inttohex(WideFileAge2(path),0);
  cacherebidx:=stsimplehashreb.IndexOf(cachereb);

  //FILENAME.ZIP-SIZE-AGE <---- LOCATION 3 TOKENS
  //FILENAME.ZIP-SIZE-AGE-SIZE-CRC-MD5-SHA1 <--- NON COMPRESSED 7 TOKENS

  if cacherebidx<>-1 then begin

    try
      cacherebidx:=cacherebidx+1;

      while cacherebidx<=stsimplehashreb.Count-1 do begin

        auxcache:=stsimplehashreb.strings[cacherebidx];
        if gettokencount(auxcache,cachereb)=1 then
          break;

        if gettokencount(auxcache,'*')=7 then begin
          cachedsize:=hextoint(gettoken(auxcache,'*',4));
          cachedcrc:=gettoken(auxcache,'*',5);
          cachedmd5:=gettoken(auxcache,'*',6);
          cachedsha1:=gettoken(auxcache,'*',7);
        end;

        cacherebidx:=cacherebidx+1;
      end;//WHILE

    except
      cachedsize:=-1;
      cachedcrc:='';
      cachedmd5:='';
      cachedsha1:='';
    end;
  end;//-1
end;//IF


//-------------2ND GET COUNTER FOR INSIDE COMPRESSED FILES 100% Completed!!!

count:=1;
//comptype 0 always is count 1

if comptype=1 then begin

  if move=true then begin
    Fmain.zipvalidfile(path,Fmain.Zip1);
    //SAVE CACHE
    //addcompressioncacherebuild(WideUpperCase(path)+'*'+inttohex(sizeoffile(path),0)+'*'+Inttohex(WideFileAge2(path),0),inttostr(comptype));
  end;

  count:=stcompfiles.count;

  //SAVE REBUILD CACHE IF MOVE=FALSE

  if hascompressed=true then
    ini:=-1;

end
else
if comptype=2 then begin

  if move=true then begin
    Fmain.rarvalidfile(path,Fmain.RAR1);
    //SAVE CACHE
    //addcompressioncacherebuild(WideUpperCase(path)+'*'+inttohex(sizeoffile(path),0)+'*'+Inttohex(WideFileAge2(path),0),inttostr(comptype));
  end;
  count:=stcompfiles.count;

  //SAVE REBUILD CACHE IF MOVE=FALSE

  if hascompressed=true then
    ini:=-1;

end
else
if comptype=3 then begin

  if move=true then begin
    Fmain.sevenzipvalidfile(path,Fmain.sevenzip1);
    //SAVE CACHE
    //addcompressioncacherebuild(WideUpperCase(path)+'*'+inttohex(sizeoffile(path),0)+'*'+Inttohex(WideFileAge2(path),0),inttostr(comptype));
  end;
  count:=stcompfiles.count;

  //SAVE REBUILD CACHE IF MOVE=FALSE

  if hascompressed=true then
    ini:=-1;
end
else  //0.028 POSSIBLE BAD EXTENSION OR MULTIFILE LIKE 001 FIX
  if action=0 then begin //SKIP IF IS INSIDE COMPRESSED FILE HEADER CHECK SECOND PASS
    continue:=false;

    //0.032 CHECK IF ARE VALID EXTENSIONS ZIP RAR 7Z
    ext:=Wideuppercase(WideExtractFileExt(path));

    if (ext='.ZIP') OR (ext='.RAR') OR (ext='.7Z') OR (ext='.001') then begin

      continue:=true;

      if Fmain.zipvalidfile(path,Fmain.Zip1)=true then
        comptype:=1
      else
      if Fmain.rarvalidfile(path,Fmain.RAR1)=true then
        comptype:=2
      else
      if Fmain.sevenzipvalidfile(path,Fmain.SevenZip1)=true then
        comptype:=3
      else
        continue:=false;

    end;

    if continue=true then begin
      count:=stcompfiles.count;

      if hascompressed=true then
        ini:=-1;
    end;

  end;

insideposition:=0;
zipcount:=count;

//3RD HEADERS RESIZE DETECT AND APPLY HEADERS---------------------------------------

if (action=0) AND (forzedindex=0) then begin//HEADERS

  if DataModule1.DBHeaders.connected=true then begin

    deleteheaderlist.clear;

    hcnt:=zipcount;

    for x:=ini to hcnt-1 do begin

      case comptype of
        1:Fmain.zipvalidfile(path,Fmain.zip1);
        2:Fmain.rarvalidfile(path,Fmain.RAR1);
        3:Fmain.sevenzipvalidfile(path,Fmain.SevenZip1);
      end;

      continue:=false;

      //1EXTRACT path var
      case comptype of
        -1..0:begin
          aux5:=path; //Always is a file
          continue:=true;
          subpathmsg:=aux5;
        end;//UNICODE SUPPORT FOR HEADERS
        1:if stcompfiles[x][1]<>'\' then begin
          continue:=Fmain.extractfilefromzip(Fmain.zip1,stcompfiles.strings[x],tempdirectoryextract,true);
          aux5:=tempdirectoryextract+gettoken(stcompfiles.strings[x],'\',GetTokenCount(stcompfiles.Strings[x],'\'));
          subpathmsg:=path+' > '+stcompfiles.strings[x];
        end;
        2:if stcompfiles[x][1]<>'\' then begin
          continue:=Fmain.extractfilefromrar(Fmain.RAR1,stcompfiles.strings[x],tempdirectoryextract,true);
          aux5:=tempdirectoryextract+gettoken(stcompfiles.Strings[x],'\',GetTokenCount(stcompfiles.Strings[x],'\'));
          subpathmsg:=path+' > '+stcompfiles.Strings[x];
        end;
        3:if stcompfiles[x][1]<>'\' then begin
          continue:=Fmain.extractfilefromsevenzip(Fmain.SevenZip1,stcompfiles.strings[x],tempdirectoryextract,true);
          aux5:=tempdirectoryextract+gettoken(stcompfiles.Strings[x],'\',GetTokenCount(stcompfiles.Strings[x],'\'));
          subpathmsg:=path+' > '+stcompfiles.Strings[x];
        end;
      end;

      if continue=true then begin

        //2APPLY HEADERS

        deleteheaderflag:=false;

        //question('HEADER TO APPLY '+aux5,20);
        aux6:=applyheader(aux5,Datamodule1.Trules,Datamodule1.Ttest);

        if FileExists2(aux6) then  //3SEND TO REBUILD ALWAYS UNCOMPRESSED
          rebuildfile(aux6,0,1,subpathmsg,0,'')
        else
          rebuildfile(aux5,0,1,subpathmsg,0,'');

        //3DELETE
        if (comptype>=1) then  //DELETE EXTRACTED ONLY
          deletefile2(aux5);

        deletefile2(aux6); //DELETE POSSIBLE CREATED ROM HEADER MODIFIED

        if deleteheaderflag=true then
          deleteheaderlist.Add(subpathmsg)
      end;


    end;

    //DELETE REBUILDED FILES --------------------------------------------------------------------------
    if deleteheaderlist.Count>0 then //0.028 FIX
      case comptype of
        1:Fmain.zipvalidfile(gettoken(deleteheaderlist.Strings[0],' > ',1),Fmain.zip1);
        2:Fmain.rarvalidfile(gettoken(deleteheaderlist.Strings[0],' > ',1),Fmain.rar1);
        3:Fmain.sevenzipvalidfile(gettoken(deleteheaderlist.Strings[0],' > ',1),Fmain.sevenzip1);
      end;

    for x:=0 to deleteheaderlist.Count-1 do begin

      if checkstop=true then  //If pressed stop button
        break;

      aux:=deleteheaderlist.Strings[x];

      if (deletenobackupdecision<>-1) AND (deletenobackupdecision<>2) then
        question(traduction(318)+traduction(320)+#10#13+aux+#10#13+traduction(319),5);

      if (deletenobackupdecision=-1) OR (deletenobackupdecision=0) then begin//ALWAYS NO
        preparelogline(2,4,1,traduction(318),aux);
        BMDThread1.Thread.Synchronize(addlogline);
      end
      else
      if (deletenobackupdecision=1) OR (deletenobackupdecision=2) then begin//YES OR ALWAYS YES

        delete:=true;
        case comptype of
          0:delete:=deletefile2(aux);
          1:delete:=Fmain.deletefilefromzip(Fmain.Zip1,gettoken(aux,' > ',2));
          2:delete:=Fmain.deletefilefromrar(Fmain.rar1,gettoken(aux,' > ',2));
          3:delete:=Fmain.deletefilefromsevenzip(Fmain.sevenzip1,gettoken(aux,' > ',2));
        end;

        if delete=true then begin
          preparelogline(1,4,1,traduction(318),aux);
          BMDThread1.Thread.Synchronize(addlogline);
        end
        else begin

          multdelete:=false;

          case comptype of
            1:multdelete:=zip1multivolume;
            2:multdelete:=rar1multivolume;
            3:multdelete:=sevenzip1multivolume;
          end;

          if multdelete=False then begin
            preparelogline(3,4,1,traduction(318),aux);
            BMDThread1.Thread.Synchronize(addlogline);
          end
          else begin
            preparelogline(2,4,1,traduction(385),aux);
            BMDThread1.Thread.Synchronize(addlogline);
          end;
        end;

      end;

    end;
    //END DELETE FOR HEADERS--------------------------------------------

    Fmain.closepossiblyopenzip;

    restoreactionmessage;

    exit;//HEADERS SCANNED DONT NEED MORE SCAN
  end;//HEADERS CONNECTED
end;
//-----------------------------------------------------------------------------

//----------4TH STEP MOVE INSIDE COMPRESSED FILES 100% Completed!!!

//question(path+'ini'+inttostr(ini)+'cnt'+inttostr(count),10);

for x:=ini to count-1 do begin  //X:=-1

  if x<0 then begin//0.027 progresstext fix
    insideposition:=0;
    if comptype=1 then begin //FIX LOCKED FILE 0.036
      Fmain.closepossiblyopenzip;
    end;
  end
  else begin
    insideposition:=x;
    if (x=0) AND (ini=-1) then begin //REOPEN LOCKED FILE 0.036
      if comptype=1 then
        Fmain.zipvalidfile(Fmain.Zip1.FileName,Fmain.Zip1);
    end;
  end;

  continue:=true;
  sha1chd:='*';

  if checkstop=true then  //If pressed stop button
    break;

  if (comptype=0) OR (x=-1) then begin //NO COMPRESS OR X:=-1

    if cachedsize<>-1 then
      space:=cachedsize
    else
      space:=sizeoffile(path); //AUXSIZE

    //0.037 SKIP HASHING IF PROFILE ONLY HAS CHDs
    if (haschds=true) AND (hassamples=false) AND (hasroms=false) then begin
      crc:='';
      md5:='';
      sha1:='';
    end
    else begin

      if cachedcrc<>'' then  //0.043
        crc:=cachedcrc
      else
        crc:=GetCRC32(path); //AUXCRC

      if forzedindex=0 then
        if cachedmd5<>'' then
          md5:=cachedmd5
        else
        if (md5checkedreb=true) then
          md5:=Wideuppercase(CalcHash(path,haMD5));

      if forzedindex=0 then
        if cachedsha1<>'' then
          sha1:=cachedsha1
        else
        if (sha1checkedreb=true) then
          sha1:=Wideuppercase(CalcHash(path,haSHA1));

    end;

    //NEVER COMPRESSED ARE CHDs X<>-1      OR (hasroms=false)        //0.040
    if ((haschds=true) AND (x<>-1)) then
      if chddecision<>-1 then begin //NEVER

        aux6:=path;

        if comptype<>0 then //MESSAGE FOR COMPRESSED
          aux6:=aux6+' > '+stcompfiles[x];

        if chddecision<>2 then//YESALL
          question(traduction(325)+#10#13+aux6,3);

        if (chddecision=1) OR (chddecision=2) then
          sha1chd:=chdgetinfo(path);

        //if (hasroms=false) AND (sha1chd='*') then //0.040 IGNORE CHECK IF NO ROMS
        //  exit;
      end;

  end
  else
  if (comptype=1) OR (comptype=2) OR (comptype=3) then begin //ZIP RAR 7Z COMPRESSION

    if (stcompfiles.Strings[x][length(stcompfiles.Strings[x])]<>'\') then begin

      aux2:=stcompfiles.Strings[x];
      subpathmsg:=' > '+stcompfiles.Strings[x];
      crc:=stcompcrcs.Strings[x];
      realcrc:=crc;

      space:=StrTocurr(stcompsizes.strings[x]);

      //NEVER COMPRESSED ARE CHDs X<>-1
      if (haschds=true) AND (x<>-1) then
        if chddecision<>-1 then begin //NEVER

          if chddecision<>2 then//YESALL
            question(traduction(325)+#10#13+path,3);

        end;

      if ((forzedindex=0) AND (md5checkedreb) OR (sha1checkedreb)) OR ((chddecision>=1) AND (haschds=true)) then begin //Extract and check md5

        aux:=tempdirectoryextract+gettoken(aux2,'\',GetTokenCount(aux2,'\'));

        if comptype=1 then begin
          if Fmain.extractfilefromzip(Fmain.zip1,stcompfiles.strings[x],tempdirectoryextract,true)=false then begin
            deletefile2(aux);
            makeexception;
          end;
        end
        else
        if comptype=2 then begin //RAR
          if Fmain.extractfilefromrar(Fmain.rar1,stcompfiles.strings[x],tempdirectoryextract,true)=false then begin
            deletefile2(aux);
            makeexception;
          end;
        end
        else //7Z                                                            i
          if Fmain.extractfilefromsevenzip(Fmain.SevenZip1,stcompfiles.strings[x],tempdirectoryextract,true)=false then begin
            deletefile2(aux);
            makeexception;
          end;

        if (md5checkedreb) AND (forzedindex=0) then //Check if already hashed
          md5:=Wideuppercase(CalcHash(aux,haMD5));          //FFFFFFFF since 0.017

        if (chddecision>=1) AND (haschds=true) then
          sha1chd:=chdgetinfo(aux);

        if (sha1checkedreb) AND (forzedindex=0) then //Check if already hashed
          sha1:=Wideuppercase(CalcHash(aux,haSHA1));        //FFFFFFFF since 0.017

        deletefile2(aux);

      end;
    end
    else
      continue:=false;

  end;
  
  realcrc:=crc;
  realspace:=space;

  //0.043 SAVE CACHE FOR REBUILD                                                                                                      //FORCE SAVE AS UNCOMPRESSED
  if ((isrebuild=true) AND (action=0) AND (move=False) AND (comptype=0)) OR ((isrebuild=true) AND (action=0) AND (move=False) AND (x=-1)) then begin
    cachefilereb.Writeln(cachereb);    //CURRTOHEX
    cachefilereb.Writeln(cachereb+'*'+currtohex(realspace)+'*'+realcrc+'*'+md5+'*'+sha1);
  end;

  stids.Clear;

  //----------------------------5TH STEP COMPARE CHECKSUMS 100% Completed!!!

  if continue=true then begin

    if forzedindex=0 then begin //NOT FORZED POSITION NOT DUPE NOT BADDUMP

      invertedcrc:=getinverthex(crc);

      z:=reccrcsbinsearch(reccrcs,crc);

      if z<>-1 then
        addtostidscrc(z);

      //INVERTED CRC SOLUTION
      z:=reccrcsbinsearch(reccrcs,invertedcrc);

      if z<>-1 then
        addtostidscrc(z);

      if (md5checkedreb=true) AND (forzedindex=0) then begin  //FFFFFFFF since 0.017
        z:=recmd5sbinsearch(recmd5s,md5);

        if z<>-1 then
          addtostidsmd5(z);

      end;

      if (sha1checkedreb=true) AND (forzedindex=0) then begin  //FFFFFFFF since 0.017
        z:=recsha1sbinsearch(recsha1s,sha1);

        if z<>-1 then
          addtostidssha1(z);
      end;

      if (sha1chd<>'*') AND (sha1chd<>'') then begin

        z:=recsha1sbinsearch(recsha1s,sha1chd);
        if z<>-1 then
          addtostidssha1(z);

      end;

    end
    else begin

      stids.Add(inttostr(forzedindex));
      Datamodule1.Tscanroms.locate('ID',forzedindex,[]);

      //THIS FIXES CREATION CHDS BAD DUMPS
      sha1chd:='';

      if (Datamodule1.Tscanroms.FieldByName('CRC').asstring='') OR (Datamodule1.Tscanroms.FieldByName('CRC').asstring='FFFFFFFF') OR (Datamodule1.Tscanroms.FieldByName('CRC').asstring='00000000') then
        if (Datamodule1.Tscanroms.FieldByName('MD5').asstring='') OR (Datamodule1.Tscanroms.FieldByName('MD5').asstring='00000000000000000000000000000000')then
          if (Datamodule1.Tscanroms.FieldByName('SHA1').asstring='') OR (Datamodule1.Tscanroms.FieldByName('SHA1').asstring='0000000000000000000000000000000000000000')then //0.017
            isdummy:=true;

    end;

    //---------------6TH CHECK POSSIBLE COINCIDENCES 100% Completed!!!

    for k:=0 to stids.Count-1 do begin //LOOP MATCH START
      //stids.count-1 = Possible matches with DB

      if checkstop=true then  //If pressed stop button
        break;

      Datamodule1.Tscanroms.Locate('ID',stids.Strings[k],[]);
      pass:=true;

      if allowmerge=false then
        if Datamodule1.Tscanroms.fieldbyname('Merge').asboolean=true then
          pass:=false;

      if allowdupe=false then
        if Datamodule1.Tscanroms.fieldbyname('Dupe').asboolean=true then
          pass:=false;

      //MERGE & DUPE VALIDATION CHECK
      if pass=true then begin //0.028

      spacedb:=Datamodule1.Tscanroms.fieldbyname('Space').ascurrency;
      crcdb:=Datamodule1.Tscanroms.fieldbyname('CRC').asstring;
      md5db:=Datamodule1.Tscanroms.fieldbyname('MD5').asstring;
      sha1db:=Datamodule1.Tscanroms.fieldbyname('SHA1').asstring;

      isinvertedcrc:=false;

      crc1:=crcdb;
      space1:=spacedb;
      md51:=md5db;
      sha11:=sha1db;

      if (crcdb<>'') AND (crcdb<>'00000000') AND (crcdb<>'FFFFFFFF') then begin
        crc1:=crc;
        if crcdb=invertedcrc then begin
          if (space=spacedb) OR (spacedb=0) then //FIX REBUILD INVERTED WITH WRONG SIZE
            isinvertedcrc:=true
          else
            invertedcrc:='@';
        end;
      end;

      if spacedb<>0 then
        space1:=spacedb;

      if forzedindex=0 then begin//0.026FIX
        if (md5checkedreb=true) AND (md5db<>'') AND (forzedindex=0) then
          md51:=md5;

        if (Datamodule1.Tscanroms.FieldByName('Type').asinteger=2) AND (chddecision>=1) AND (haschds=true) then
          sha11:=sha1chd
        else               //BAD DUMP SKIP 0.017
        if (sha1checkedreb=true) AND (sha1db<>'') then
          sha11:=sha1;
      end;

//NEXT HEADERS BUG
      //question(crc1+'='+crcdb+' '+md51+'='+md5db+' '+sha11+'='+sha1db,20);

      if ((crc1=crcdb) OR (invertedcrc=crcdb)) AND (space1=spacedb) AND (md51=md5db) AND (sha11=Sha1db) then begin

        //0 Roms
        //1 Samples
        //2 CHDs

        typ:=Datamodule1.Tscanroms.fieldbyname('Type').asinteger;
        destcomp:=1;//DEFAULT ZIP
        zipcomplv:=9;

        case typ of
          0:begin
            dest:=romspath;
            destcomp:=romscomp;
            zipcomplv:=romscomplevel;
          end;
          1:begin
            dest:=samplespath;
            destcomp:=samplescomp;
            zipcomplv:=samplescomplevel;
          end;
          2:begin
            dest:=chdspath;
            destcomp:=chdscomp;
            zipcomplv:=chdscomplevel;
          end;
        end;

        dest:=checkpathcase(dest);
        wideForceDirectories(dest);

        if (allowmerge=true) AND (allowdupe=false) then //Is Not split
          Datamodule1.Tscansets.Locate('ID',Datamodule1.Tscanroms.fieldbyname('Setnamemaster').AsInteger,[])
        else
          Datamodule1.Tscansets.Locate('ID',Datamodule1.Tscanroms.fieldbyname('Setname').AsInteger,[]);

        //------------7TH CHECK INSIDE DESTINATION

        aux3:='';
        aux4:='';

        case destcomp of //Filetype destination
          0:aux4:=dest+getwiderecord(Datamodule1.Tscansets.fieldbyname('Gamename'))+'\'+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname'));
          1:aux4:=dest+getwiderecord(Datamodule1.Tscansets.fieldbyname('Gamename'))+zipext;
          2:aux4:=dest+getwiderecord(Datamodule1.Tscansets.fieldbyname('Gamename'))+rarext;
          3:aux4:=dest+getwiderecord(Datamodule1.Tscansets.fieldbyname('Gamename'))+sevenzipext;
        end;

        continue:=fileexists2(aux4);

        //0.037 HACK SPEED SKIP IF ALREADY IS CHECKED
        //MUST REMOVED 0.043 FALSE POSITIVE ?                                                            //0.043
        if (Datamodule1.Tscanroms.fieldbyname('Have').asboolean=true) AND (continue=true) AND (scantoo=true) then begin
          //DO NOTHING I HAVE THE ROM GO TO DELETE MESSAGE
          continue:=false;
          aux4:=checkpathcase(aux4);
          aux:=aux4;
          offhave:=true;
          //stids.Count NUMBER OF COINCIDENCES
        end
        else
        if continue=true then begin
          continue:=false;
          aux4:=checkpathcase(aux4);

          case destcomp of
            0:continue:=true;
            1:continue:=Fmain.zipvalidfile(aux4,Fmain.zip2);
            2:continue:=Fmain.rarvalidfile(aux4,Fmain.RAR2);
            3:continue:=Fmain.sevenzipvalidfile(aux4,Fmain.sevenzip2);
          end;


          if continue=false then begin //Not valid destination

            preparelogline(3,4,1,traduction(181),aux4);
            BMDThread1.Thread.Synchronize(addlogline);

            aux:=movetobackup(aux4);

            if aux<>'' then begin
              preparelogline(1,8,1,traduction(172),aux4+#10#13+' '+aux);
              BMDThread1.Thread.Synchronize(addlogline);
              continue:=true;
            end
            else begin
              preparelogline(3,8,1,traduction(172),aux4);
              BMDThread1.Thread.Synchronize(addlogline);
            end;

          end
          else begin //Check inside existing checksums

            if destcomp=0 then begin //Uncompressed

              cache:='';
              aux7:='';//FOR HEADERS
              aux8:='';//FOR HEADERS
              md52:=md5db;
              sha12:=sha1db;
              crc2:=crcdb;
              space2:=spacedb;

              //0.027 HEADERS FIX

              if DataModule1.DBHeaders.Connected=true then begin
                aux8:=aux4; //ORIGINAL
                aux7:=applyheader(aux4,Datamodule1.Trules,Datamodule1.Ttest);
                if aux7<>'' then begin
                  aux4:=aux7;
                end;
              end;

              if (crcdb<>'') AND (crcdb<>'FFFFFFFF') AND (crcdb<>'00000000') then
                crc2:=GetCRC32(aux4);
                      //0.043 FROM MD5CHECKEDREB TO MD5CHECKED
              if (md5checked) AND (md5db<>'') then
                md52:=Wideuppercase(CalcHash(aux4,haMD5));

              if (Datamodule1.Tscanroms.FieldByName('Type').asinteger=2) AND (chddecision>=1) then
                sha12:=chdgetinfo(aux4)
              else       //0.043 FROM SHA1CHECKEDREB TO SHA1CHECKED
              if (sha1checked) AND (sha1db<>'') then
                sha12:=Wideuppercase(CalcHash(aux4,haSHA1));

              offhave:=True;
              pass:=false;

              //---------------INVERTED AND WRONG SIZE???
              if (isinvertedcrc=true) AND (getinverthex(crc2)=crcdb) then
                pass:=true; //THE FILE IS GOODDUMP

              try
                cache:=wideuppercase(getwiderecord(Datamodule1.Tscansets.fieldbyname('Gamename'))+'\'+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')))+'-'+inttohex(sizeoffile(aux4),0)+'-'+Inttohex(WideFileAge2(aux4),0)+'-'+IntToHex(trunc(spacedb),0)+'-'+crcdb+'-'+md5db+'-'+sha1db;
                if pass=true then //Inverted check
                  cache:=cache+'-';
              except
              end;

              if spacedb<>0 then begin
                space2:=sizeoffile(aux4);

                if (crc2=crcdb) OR (pass=true) then begin

                  if space2=realspace then begin //Already exists origin to destination
                    space2:=spacedb;
                  end
                  else
                  if realspace=spacedb then begin//Origin real correct dump destination was trimmed
                    space2:=-1;//Force removed to insert correct dump
                  end
                  else
                    offhave:=false; //Other size ignored but no remove

                  {if ((isinvertedcrc=true) AND (crc2=crcdb)) then begin//BADDUMP WILL BE REBUILDED
                    space2:=-1;//Force removed to insert correct dump
                    offhave:=true;
                  end;}
                  //0.032 INVERTED CRCs FIX
                  if ((crc1=crcdb) AND (crc2<>crcdb)) then begin//ADDUMP WILL BE REBUILDED
                    space2:=-1;//Force removed to insert correct dump
                    offhave:=true;
                  end;

                end;

              end;

              if aux7<>'' then begin//0.027 FOR HEADERS
                deletefile2(aux7);//DELETE FIXED FILE HEADER
                aux4:=aux8;
              end;

              if Datamodule1.DBHeaders.Connected=true then //0.027
                space2:=spacedb;

              //FOUND AND MATCH DO NOTHING
              if ((crc2=crcdb) OR (pass=true)) AND (space2=spacedb) AND (md52=md5db) AND (sha12=Sha1db) then begin

                if (offhave=true) AND (Datamodule1.Tscanroms.FieldByName('Have').asboolean=false) then begin
                  DataModule1.Tscanroms.Edit;
                  Datamodule1.Tscanroms.FieldByName('Have').asboolean:=true;
                  Datamodule1.Tscanroms.Post;

                  //Save cache 0.030 already descomp=0
                  try
                    if cache<>'' then begin
                      stsimplehash.Add(cache);
                      cachefile.Writeln(cache);
                    end;
                  except
                  end;

                end;

                continue:=false;

              end
              else begin

                aux:=movetobackup(aux4);

                if aux='' then begin

                  preparelogline(3,4,1,traduction(181),aux4);
                  BMDThread1.Thread.Synchronize(addlogline);
                  continue:=false;
                end
                else begin
                  //aux is destination old file
                  preparelogline(2,8,1,traduction(193),aux4+#10#13+' '+aux);//Recommended rebuild done
                  BMDThread1.Thread.Synchronize(addlogline);
                  continue:=true;
                end;

              end;

            end
            else begin //NOT COMPTYPE 0 CHECK

              y:=stcompfiles2.IndexOf(getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

              //If destination exists the check if is correct file
               if y<>-1 then begin

                  continue:=true;
                  md52:=md5db;
                  sha12:=sha1db;
                  crc2:=crcdb;
                  space2:=spacedb;

                  if (crcdb<>'') AND (crcdb<>'FFFFFFFF') AND (crcdb<>'00000000') then
                    crc2:=stcompcrcs2.Strings[y];

                  if spacedb<>0 then
                    space2:=strtocurr(stcompsizes2.Strings[y]);

                  //0.027 CONFLICT WITH HEADERS REMOVED
                  WideForceDirectories(tempdirectoryextract+'-\');
                  aux3:=tempdirectoryextract+'-\'+gettoken(stcompfiles2.Strings[y],'\',GetTokenCount(stcompfiles2.Strings[y],'\'));

                  if wideuppercase(aux3)<>wideuppercase(path) then
                    deletefile2(aux3);
                                                                     //0.043 FROM MD5CHECKEDREB TO MD5CHECKED
                  if (Datamodule1.DBHeaders.connected=true) OR (md5checked) OR (sha1checked) OR ((Datamodule1.Tscanroms.FieldByName('Type').asinteger=2) AND (chddecision>=1)) then  //Extract and check md5 sha1
                    if (md5db<>'') OR (sha1db<>'') OR (Datamodule1.DBHeaders.connected=true) then begin  //MD5SHA1 0 START

                      case destcomp of
                        1:continue:=Fmain.extractfilefromzip(fmain.Zip2,stcompfiles2.strings[y],tempdirectoryextract+'-\',true);
                        2:continue:=Fmain.extractfilefromrar(Fmain.RAR2,stcompfiles2.strings[y],tempdirectoryextract+'-\',true);
                        3:continue:=Fmain.extractfilefromsevenzip(Fmain.SevenZip2,stcompfiles2.strings[y],tempdirectoryextract+'-\',true);
                      end;

                      if continue=false then begin

                        preparelogline(3,4,1,traduction(181),aux4);
                        BMDThread1.Thread.Synchronize(addlogline);
                      end
                      else begin //Get more hashes if uncompressed
                        aux7:='';//0.027 HEADERS
                        aux8:='';//0.027 HEADERS

                        //0.027 HEADERS
                        if DataModule1.DBHeaders.Connected=true then begin

                          aux8:=aux3; //ORIGINAL
                          aux7:=applyheader(aux3,Datamodule1.Trules,Datamodule1.Ttest);

                          if aux7<>'' then begin
                            aux3:=aux7;

                            if (crcdb<>'') AND (crcdb<>'FFFFFFFF') AND (crcdb<>'00000000') then
                              crc2:=GetCRC32(aux3);

                            if spacedb<>0 then
                              space2:=sizeoffile(aux3)

                          end;
                        end;

                        if (md5checkedreb=true) AND (md5db<>'') then
                          md52:=Wideuppercase(CalcHash(aux3,haMD5));

                        if (Datamodule1.Tscanroms.FieldByName('Type').asinteger=2) AND (sha1db<>'') AND (chddecision>=1) then
                          sha12:=chdgetinfo(aux3)
                        else
                        if (sha1checkedreb=true) AND (sha1db<>'') then
                          sha12:=Wideuppercase(CalcHash(aux3,haSHA1));
                      end;

                    end;//MD5SHA1 0 END

                    if aux7<>'' then begin//0.027 HEADERS
                      deletefile2(aux7);//DELETE FIXED HEADER FILE
                      WideRemoveDir(tempdirectoryextract+'-\');
                      aux3:=aux8;
                    end;

                    if wideuppercase(aux3)<>wideuppercase(path) then
                      deletefile(aux3);

                  if continue=true then begin

                    offhave:=True;
                    pass:=false;

                    //ISINVERTEDCRC=TRUE = INVERTED(CRC1)=CRCDB

                    if (isinvertedcrc=true) AND (getinverthex(crc2)=crcdb) then
                      pass:=true; //THE FILE IS GOODDUMP NOW CHECK FOR SIZE

                    if (crc2=crcdb) OR (pass=true) then begin
                      if space2=realspace then begin //Already exists origin to destination
                        space2:=spacedb;
                      end
                      else
                      if realspace=spacedb then begin//Origin real correct dump destination was trimmed
                        space2:=-1;//Force removed to insert correct dump
                      end
                      else
                        offhave:=false; //Other size ignored but no remove

                      {if ((isinvertedcrc=true) AND (crc2=crcdb)) then begin//BADDUMP WILL BE REBUILDED
                        space2:=-1;//Force removed to insert correct dump
                        offhave:=true;
                      end;}
                      //0.032 INVERTED CRCs FIX
                      if ((crc1=crcdb) AND (crc2<>crcdb)) then begin//ADDUMP WILL BE REBUILDED
                        space2:=-1;//Force removed to insert correct dump
                        offhave:=true;
                      end;

                    end;


                    //SEEMS FINE
                    if ((crc2=crcdb) OR (pass=true)) AND (space2=spacedb) AND (md52=md5db) AND (sha12=Sha1db) then begin

                      if offhave=true then begin
                        Datamodule1.Tscanroms.Edit;
                        Datamodule1.Tscanroms.fieldbyname('Have').asboolean:=true;
                        Datamodule1.Tscanroms.post;
                      end;

                      continue:=false;
                    end
                    else begin //NOT MATCH REMOVE AND SET CONTINUE TO TRUE TO ADD IN NEXT STEP

                      //DESTCOMP 0 ALREADY CHECKED CHECK COMPRESSED ONLY
                      if wideuppercase(aux3)<>wideuppercase(path) then
                        deletefile2(aux3);//Extracted filename

                      //aux3 = temporal filename
                      //aux4 = original path filename to rebuild

                      if stcompfiles2.Count<=1 then begin//If 1 file compressed move to backup compressed else extract and move
                        //0.030 Fix locked zip file
                        Fmain.Zip2.CloseArchive;
                        Fmain.zip2.Tag:=0;

                        aux:=movetobackup(aux4);
                      end
                      else begin

                        aux3:=tempdirectoryextract+'-\'+stcompfiles2.Strings[y];//0.030
                        deletefile2(aux3);

                        //if space2=-1 then
                        //  question('TO EXTRACT '+aux3,20);

                        case destcomp of
                          1:if Fmain.extractfilefromzip(Fmain.Zip2,stcompfiles2.Strings[y],tempdirectoryextract+'-\',true)=true then
                            aux:=movetobackup(aux3);
                          2:if Fmain.extractfilefromrar(Fmain.rar2,stcompfiles2.strings[y],tempdirectoryextract+'-\',true)=true then
                            aux:=movetobackup(aux3);
                          3:if Fmain.extractfilefromsevenzip(Fmain.SevenZip2,stcompfiles2.strings[y],tempdirectoryextract+'-\',true)=true then
                            aux:=movetobackup(aux3);
                        end;

                        //if space2=-1 then
                        //question('EXTRACTED '+aux3+' MOVED TO '+aux,20);

                      end;

                      //PROBABLY AN OVERWRITE PROBLEM
                      if wideuppercase(aux3)<>wideuppercase(path) then
                        deletefile2(aux3);

                      if (aux='') then begin //FAIL EXTRACTION
                        if destcomp<>0 then
                          preparelogline(3,4,1,traduction(181),aux4+' > '+stcompfiles2.Strings[y])
                        else
                          preparelogline(3,4,1,traduction(181),aux4);

                        BMDThread1.Thread.Synchronize(addlogline);

                        if wideuppercase(aux3)<>wideuppercase(path) then
                          deletefile2(aux3);

                        continue:=false;
                      end
                      else begin
                        //aux is destination old file
                        //DESTINATION IS COMPRESSED FILE 0.032
                        subpathmsg:=aux4+' > '+stcompfiles2.strings[y]+#10#13+' '+aux;
                        preparelogline(2,8,1,traduction(193),subpathmsg);//Recommended rebuild done
                        BMDThread1.Thread.Synchronize(addlogline);

                        {
                        //0.032 Delete OLD FILE
                        case destcomp of
                          1:continue:=Fmain.deletefilefromzip(Fmain.Zip2,stcompfiles2.Strings[y]);
                          2:continue:=Fmain.deletefilefromrar(Fmain.rar2,stcompfiles2.Strings[y]);
                          3:continue:=Fmain.deletefilefromsevenzip(Fmain.sevenzip2,stcompfiles2.Strings[y]);
                        end;

                        //FAIL DELETION MESSAGE
                        if continue=false then begin
                          preparelogline(3,4,1,traduction(181),aux4);
                          BMDThread1.Thread.Synchronize(addlogline);
                        end;       }

                      end;

                    end;//END NO MATCH REMOVE

                  end;//CONTINUE TRUE

              end;//END FOUND FILE INSIDE ARCHIVE

          end;//END CHECK INSIDE BUT NOT FILETYPE 0

        end;//End check inside file

      end//DESTINATION EXISTS IF NOT CONTINUE
      else
        continue:=true;//NO EXISTS ARCHIVE FILE THEN CONTINUE

      if continue=true then begin
         //XBOX
        if (comptype<>0) AND (x<>-1) then begin //X:=-1
          aux3:=tempdirectoryextract+gettoken(stcompfiles.Strings[x],'\',GetTokenCount(stcompfiles.Strings[x],'\'));
        end;

        reuse:=true; //0.028 SPEED HACK
        if (stids.Count=1) OR (k=stids.count-1) then
          reuse:=false;

        if x<>-1 then //X:=-1
          case comptype of
            1:continue:=Fmain.extractfilefromzip(Fmain.Zip1,stcompfiles.Strings[x],tempdirectoryextract,reuse);
            2:continue:=Fmain.extractfilefromrar(Fmain.rar1,stcompfiles.Strings[x],tempdirectoryextract,reuse);
            3:continue:=Fmain.extractfilefromsevenzip(Fmain.SevenZip1,stcompfiles.Strings[x],tempdirectoryextract,reuse);
          end;

        if continue=false then begin

          if comptype<>0 then begin
            preparelogline(3,4,1,traduction(181),path+' > '+stcompfiles.Strings[x]);
          end
          else begin
            preparelogline(3,4,1,traduction(181),path);
          end;

          BMDThread1.Thread.Synchronize(addlogline);
        end
        else begin

          if actionfilename<>'' then begin //HEADER CORRECTION ORIGINAL REBUILD

            if gettokencount(actionfilename,' > ')>1 then
              path:=tempdirectoryextract+gettoken(actionfilename,' > ',2)
            else
              path:=actionfilename;

          end;

          if (comptype=0) OR (x=-1) then
            aux3:=path;
                                                                    //X:=-1
          if ((comptype=0) OR (x=-1)) AND (destcomp<>0) then begin //Prepare from tmp folder and compress later

            aux3:=tempdirectoryextract+WideExtractfilename(path);

            if wideuppercase(path)<>wideuppercase(aux3) then
              deletefile2(aux3);//POSSIBLE EXISTING FILE DELETE


            CopyFile2(path,aux3);
          end;

          if destcomp<>0 then begin
//---------------------------------------------------------
            //question('4 '+aux3,20);

            //Rename file/Folder fix if both exists in same dir
            if gettokencount(getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')),'\')>1 then begin
              wideforcedirectories(WideExtractfilepath(tempdirectoryextract+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname'))));

              if not wideDirectoryExists(wideextractfilepath(tempdirectoryextract+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')))) then begin
                aux6:=getvaliddestination(aux3);
                WideRenameFile(aux3,aux6);
                aux3:=aux6;
                wideforcedirectories(wideextractfilepath(tempdirectoryextract+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname'))));
              end;

            end;
            //POSSIBLE OPTIMIZATION OPTION FOR DUPLICATES TODO IF REUSE=TRUE

            if wideuppercase(tempdirectoryextract+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')))<>wideuppercase(Aux3) then
              deletefile2(tempdirectoryextract+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));//POSSIBLE EXISTING FILE DELETE

            WideRenameFile(aux3,tempdirectoryextract+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

            aux3:=tempdirectoryextract+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname'));
          end;

          delete:=false;//Temp var
          case destcomp of
              0:begin
                  cache:='';

                  try
                    wideForceDirectories(wideextractfilepath(aux4));
                    CopyFile2(aux3,aux4);
                  except
                  end;

                  delete:=FileExists2(aux4);

                  if delete=true then //0.030 cache rebuild
                    try
                      cache:=wideuppercase(getwiderecord(Datamodule1.Tscansets.fieldbyname('Gamename'))+'\'+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')))+'-'+inttohex(sizeoffile(aux4),0)+'-'+Inttohex(WideFileAge2(aux4),0)+'-'+IntToHex(trunc(spacedb),0)+'-'+crcdb+'-'+md5db+'-'+sha1db;
                      if isinvertedcrc=true then //Inverted check
                        cache:=cache+'-';
                    except
                    end;

              end;
              1:delete:=Fmain.addfiletozip(tempdirectoryextract,aux3,aux4,zipcomplv,realcrc,currtostr(realspace));
              2:delete:=Fmain.addfiletorar(tempdirectoryextract,aux3,aux4,zipcomplv,realcrc,currtostr(realspace));
              3:delete:=Fmain.addfiletosevenzip(tempdirectoryextract,aux3,aux4,zipcomplv,realcrc,currtostr(realspace));
          end;

          if delete=true then begin //DONE

            if Datamodule1.Tscanroms.FieldByName('Have').AsBoolean=false then begin//0.030
              Datamodule1.Tscanroms.edit;
              Datamodule1.Tscanroms.FieldByName('Have').AsBoolean:=true;
              Datamodule1.Tscanroms.post;

              if (destcomp=0) AND (cache<>'') then //aux4 must be cached save cache 0.030
                try
                  cachefile.Writeln(cache);
                  stsimplehash.Add(cache)
                except
                end;
            end;

            //And folders too
            //relativefolder:='';

            //TO SPEEDUP 0.031???  REMOVED 0.032
            {for z:=1 to gettokencount(getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')),'\')-1 do begin
              relativefolder:=relativefolder+gettoken(getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')),'\',z)+'\';

              y:=recromsbinsearch(recroms,inttostr(Datamodule1.Tscansets.fieldbyname('ID').asinteger)+'*'+wideuppercase(relativefolder));

              if y<>-1 then begin
                Datamodule1.Tscanroms.Locate('ID',Trecroms(recroms[y]).id_,[]);

                if Datamodule1.Tscanroms.FieldByName('Have').AsBoolean=false then begin //0.030
                  Datamodule1.Tscanroms.edit;
                  Datamodule1.Tscanroms.FieldByName('Have').AsBoolean:=true;
                  Datamodule1.Tscanroms.post;
                end; //NO NEED SAVE CACHE ARE FOLDERS 0.030
              end;

            end;    }

            if (comptype=0) OR (x=-1) then begin //X:=-1 //DONE ORIGIN UNCOMPRESS

              //MESSAGE IF HEADER CORRECTED
              if actionfilename<>'' then begin
                if destcomp=0 then
                  preparelogline(1,0,1,traduction(306),actionfilename+#10#13+' '+traduction(192)+' '+aux4)
                else
                  preparelogline(1,0,1,traduction(306),actionfilename+#10#13+' '+traduction(192)+' '+aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));
              end
              else
              if forzedindex<>0 then begin //BADDUMPS AND DUMMIES

                if destcomp=0 then begin
                  if isdummy then begin
                    if Datamodule1.Tscanroms.fieldbyname('Type').asinteger=2 then
                      preparelogline(1,20,1,traduction(420),aux4)//CHD ICON BADDUMP
                    else
                      preparelogline(1,19,1,traduction(420),aux4)

                  end
                  else                                             //ORIGIN COMP?
                    preparelogline(1,18,1,traduction(423),currentset+origincomp+#10#13+' '+traduction(424)+' '+aux4);

                end
                else begin
                  if isdummy then begin
                    if Datamodule1.Tscanroms.fieldbyname('Type').asinteger=2 then
                      preparelogline(1,20,1,traduction(420),aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')))
                    else
                      preparelogline(1,19,1,traduction(420),aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

                  end
                  else                                            //ORIGIN COMP?
                    preparelogline(1,18,1,traduction(423),currentset+origincomp+#10#13+' '+traduction(424)+' '+aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

                end;

              end
              else
              if destcomp=0 then
                preparelogline(1,0,1,traduction(306),path+#10#13+' '+traduction(192)+' '+aux4)
              else
                preparelogline(1,0,1,traduction(306),path+#10#13+' '+traduction(192)+' '+aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

              BMDThread1.Thread.Synchronize(addlogline);
            end
            else begin  //DONE ORIGIN COMPRESS

              if destcomp=0 then
                 preparelogline(1,0,1,traduction(306),path+' > '+stcompfiles.Strings[x]+#10#13+' '+traduction(192)+' '+aux4)
              else
                preparelogline(1,0,1,traduction(306),path+' > '+stcompfiles.Strings[x]+#10#13+' '+traduction(192)+' '+aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

              BMDThread1.Thread.Synchronize(addlogline);

            end;

          end
          else begin //FAILED

            if (comptype=0) OR (x=-1) then begin //X:=-1   FAILED ORIGIN UNCOMPRESS

              //BADDUMP AND DUMMIES
              if forzedindex<>0 then begin //BADDUMPS AND DUMMIES

                if destcomp=0 then begin
                  if isdummy then begin
                    if Datamodule1.Tscanroms.fieldbyname('Type').asinteger=2 then
                      preparelogline(3,20,1,traduction(420),aux4)
                    else
                      preparelogline(3,19,1,traduction(420),aux4);
                  end
                  else                                             //ORIGIN COMP?
                    preparelogline(3,18,1,traduction(423),currentset+origincomp+#10#13+' '+traduction(424)+' '+aux4);

                end
                else begin
                  if isdummy then begin
                    if Datamodule1.Tscanroms.fieldbyname('Type').asinteger=2 then
                      preparelogline(3,20,1,traduction(420),aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')))
                    else
                      preparelogline(3,19,1,traduction(420),aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')))
                  end
                  else                                            //ORIGIN COMP?
                    preparelogline(3,18,1,traduction(423),currentset+origincomp+#10#13+' '+traduction(424)+' '+aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

                end;

              end
              else
              if destcomp=0 then
                preparelogline(3,0,1,traduction(306),path+#10#13+' '+traduction(192)+' '+aux4)
              else
                preparelogline(3,0,1,traduction(306),path+#10#13+' '+traduction(192)+' '+aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

              BMDThread1.Thread.Synchronize(addlogline);
            end
            else begin //FAILED ORIGIN COMPRESS
              if destcomp=0 then
                 preparelogline(3,0,1,traduction(306),path+' > '+stcompfiles.Strings[x]+#10#13+' '+traduction(192)+' '+aux4)
              else
                preparelogline(3,0,1,traduction(306),path+' > '+stcompfiles.Strings[x]+#10#13+' '+traduction(192)+' '+aux4+' > '+getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));

              BMDThread1.Thread.Synchronize(addlogline);
            end;
          end;

        end;

        if ((comptype=0) AND (destcomp<>0)) OR (comptype<>0) then  //DELETES TEMP 0.028
          if x<>-1 then begin  //X:=-1
            if wideuppercase(aux3)<>wideuppercase(path) then begin
              if WideDirectoryExists(tempdirectoryextract) then
                Fmain.Scandirectory(tempdirectoryextract,'*.*',1,true);
            end;
          end;

      end;//CONTINUE

    end;//Checksum found

    end;//END VALID MERGE DUPE

    end;//END loop Query results

    //Check if all query has have as true and add to deletelist
    delete:=false;

    //0.028
    for z:=0 to stids.Count-1 do begin

      Datamodule1.Tscanroms.Locate('ID',stids.Strings[z],[]);

      //MERGE DUPE CHECK
      pass:=true;

      if allowmerge=false then
        if Datamodule1.Tscanroms.fieldbyname('Merge').asboolean=true then
          pass:=false;

      if allowdupe=false then
        if Datamodule1.Tscanroms.fieldbyname('Dupe').asboolean=true then
          pass:=false;

      if pass=true then
        if Datamodule1.Tscanroms.FieldByName('Have').asboolean=true then begin
          delete:=true;
          break;
        end;

    end;

    if delete=true then
      if (comptype<>0) AND (x<>-1) then
        deletelist.add(stcompfiles.Strings[x])
      else
      if x=-1 then
        deletecompressed:=true
      else
        deletelist.add(path);

  end//CONTINUE FALSE FOR COMPRESSED INSIDE FOLDERS

end;//Inside compressed files move


//Delete no longer needed files
ini:=0;
if (deletecompressed=true) AND (deletelist.Count=0) then //X:=-1
  ini:=-1;

if action=1 then begin //0.027 HEADER FIXES
  if deletelist.Count>0 then
    deleteheaderflag:=true;
end
else
if ((action=0) AND (forzedindex=0)) then begin//NO DELETE HEADER FIXED FILE

  //SPEED HACK 0.028
  if (x<>-1) AND (comptype=1) then begin

      Fmain.Zip1.Tag:=1;
      if Fmain.zipvalidfile(Fmain.Zip1.FileName,Fmain.zip1)=false then
        Fmain.Zip1.Tag:=0;

  end;

  for x:=ini to deletelist.Count-1 do begin //X:=-1
    
    if checkstop=true then  //If pressed stop button
      break;

    if (comptype<>0) AND (x<>-1) then
      aux:=path+' > '+deletelist.strings[x]
    else begin

      Fmain.closepossiblyopenzip; //0.030 Unlock possible zipped files after delete it

      if x=-1 then
        aux:=path
      else
        aux:=deletelist.strings[x];
        
    end;

    //question('X value = '+inttostr(x)+' '+'deletelistcount = '+inttostr(deletelist.count),20);

    if (deletenobackupdecision<>-1) AND (deletenobackupdecision<>2) then
      question(traduction(318)+traduction(320)+#10#13+aux+#10#13+traduction(319),5);

    if (deletenobackupdecision=-1) OR (deletenobackupdecision=0) then begin//ALWAYS NO
      preparelogline(2,4,1,traduction(318),aux);
      BMDThread1.Thread.Synchronize(addlogline);
    end
    else
    if (deletenobackupdecision=1) OR (deletenobackupdecision=2) then begin//YES OR ALWAYS YES

      delete:=true;
      multdelete:=false;
            
      //SPEED HACK 0.028 SAME FILES TO DELETE IS SAME FILES INSIDE COMPRESSED
      if (deletenobackupdecision=2) AND (comptype<>0) AND (x<>-1) then
        if realcompressedfilecount=deletelist.count-x then begin

          case comptype of
            1:begin
                if zip1multivolume=false then begin
                  Fmain.Zip1.CloseArchive;
                  Fmain.Zip1.tag:=0;
                end
                else
                  multdelete:=true;
              end;
            2:multdelete:=rar1multivolume;
            3:multdelete:=sevenzip1multivolume;
          end;

          if multdelete=false then
            delete:=deletefile2(path)
          else
            delete:=false;

          for y:=x to deletelist.Count-1 do begin

            aux:=path+' > '+deletelist.strings[y];

            if delete=true then begin
              preparelogline(1,4,1,traduction(318),aux);
              BMDThread1.Thread.Synchronize(addlogline);
            end
            else begin
              if multdelete=false then begin
                preparelogline(3,4,1,traduction(318),aux);
                BMDThread1.Thread.Synchronize(addlogline);
              end
              else begin
                preparelogline(2,4,1,traduction(385),aux);
                BMDThread1.Thread.Synchronize(addlogline);
              end;
            end;

          end;

          break;//EXIT LOOP

        end;//END SPEED HACK



      if x<>-1 then begin
        case comptype of
          0:delete:=deletefile2(path);
          1:delete:=Fmain.deletefilefromzip(Fmain.Zip1,deletelist.Strings[x]);
          2:delete:=Fmain.deletefilefromrar(Fmain.rar1,deletelist.Strings[x]);
          3:delete:=Fmain.deletefilefromsevenzip(Fmain.sevenzip1,deletelist.Strings[x]);
        end;
      end
      else begin
        delete:=deletefile2(path);
      end;

      if delete=true then begin
        preparelogline(1,4,1,traduction(318),aux);
        BMDThread1.Thread.Synchronize(addlogline);
      end
      else begin
        multdelete:=false;

        case comptype of
          1:multdelete:=zip1multivolume;
          2:multdelete:=rar1multivolume;
          3:multdelete:=Fmain.sevenzip1.Ismultidisk;
        end;

        if multdelete=False then begin
          preparelogline(3,4,1,traduction(318),aux);
          BMDThread1.Thread.Synchronize(addlogline);
        end
        else begin
          preparelogline(2,4,1,traduction(385),aux);
          BMDThread1.Thread.Synchronize(addlogline);
        end;
      end;

    end;
  end;

  //0.028 CLOSE SPEED HACK
  Fmain.closepossiblyopenzip;
end;

deletelist.Clear;

if action<>1 then
  restoreactionmessage;
end;

//GENERAL FIXES--------------------------------------------

function Tfscan.correctcase(path,dest:widestring):widestring;
begin

if (renamedecision<>2) AND (renamedecision<>-1) then
  question(traduction(173)+#10#13+path+#10#13+traduction(170)+#10#13+dest,1);

if (renamedecision=2) OR (renamedecision=1) AND (renamedecision<>-1) then begin
  if fileexists2(path) then begin

    WideRenameFile(path,dest);

    if fileexists2(dest)=true then begin

      //Done rename
      preparelogline(1,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+dest);
      BMDThread1.Thread.Synchronize(addlogline);
      path:=dest;
    end
    else begin //Error renaming
      preparelogline(3,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+dest);
      BMDThread1.Thread.Synchronize(addlogline);
    end;

  end
  else begin //Not found
    preparelogline(3,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+dest);
    BMDThread1.Thread.Synchronize(addlogline);
  end;

end
else begin //Skipped by user
  preparelogline(2,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+dest);
  BMDThread1.Thread.Synchronize(addlogline);
end;

Result:=path;
end;

function Tfscan.correctcompext(path,ext,correctext:widestring;comptype:shortint):widestring;
var
aux:widestring;
begin
//Path,extension,correctextensio,compression type
if ext<>correctext then begin //Check correct extension

  aux:=wideExtractfilepath(path)+filewithoutext(path)+correctext;

  if (extensiondecision<>2) AND (extensiondecision<>-1) then
    question(traduction(169)+#10#13+path+#10#13+traduction(170)+#10#13+aux,0);

  if (extensiondecision=2) OR (extensiondecision=1) AND (extensiondecision<>-1) then begin

    pass_:=true; //Check already exists

    if fileexists2(aux) then
      if wideuppercase(aux)<>wideuppercase(path) then //Check if only is a char case in extension
        if movetobackup(aux)='' then begin
          pass_:=false;
          preparelogline(3,8,1,traduction(169),path+#10#13+' '+traduction(170)+' '+aux);
          BMDThread1.Thread.Synchronize(addlogline);
        end
        else begin
          //aux is destination old file
          preparelogline(2,8,1,traduction(193),aux); //UNCOMPRESSED
          BMDThread1.Thread.Synchronize(addlogline);
        end;

    if pass_=true then
      if fileexists2(path) then begin

        WideRenameFile(path,aux);

        if fileexists2(aux)=true then begin

          case comptype of //Reload renamed compressed file
            0:Fmain.zipvalidfile(aux,Fmain.zip1);
            1:Fmain.rarvalidfile(aux,Fmain.RAR1);
            2:Fmain.sevenzipvalidfile(aux,Fmain.sevenzip1);
          end;
          
          //Done renamed
          preparelogline(1,9,1,traduction(169),path+#10#13+' '+traduction(170)+' '+aux);
          BMDThread1.Thread.Synchronize(addlogline);

          path:=aux;
        end
        else begin //Fail renamed
          preparelogline(3,9,1,traduction(169),path+#10#13+' '+traduction(170)+' '+aux);
          BMDThread1.Thread.Synchronize(addlogline);
        end;

      end
      else begin //Not found
        preparelogline(3,9,1,traduction(169),path+#10#13+' '+traduction(170)+' '+aux);
        BMDThread1.Thread.Synchronize(addlogline);
      end;

    end
    else begin //Skipped by user
      preparelogline(2,9,1,traduction(169),path+#10#13+' '+traduction(170)+' '+aux);
      BMDThread1.Thread.Synchronize(addlogline);
    end;

end; //END EXTENSION CHECK

Result:=path;
end;

//-----------------------------------------------------------

procedure TFscan.processromascompressed(path,ext:widestring;comptyp:smallint;correctext:string);
var
space,spacedb:currency;
noext,aux_,hfile:widestring;
crc,md5,sha1,crcdb,md5db,sha1db:string;
x,pos,pos2:longint;
typ:shortint;
first:boolean;
invertedcrc:string;
precache,cache:widestring;
begin
//REV015
first:=true;
noext:=filewithoutext(path);
zipcount:=stcompfiles.Count;

pos:=recsetsbinsearch(recsets,wideuppercase(noext));

if pos<>-1 then begin
  Datamodule1.Tscansets.Locate('ID',Trecsets(recsets[pos]).id_,[]);
                                                //Gamename
  if getwiderecord(Datamodule1.Tscansets.Fields[2])<>noext then
    pos:=-1;
end;

if pos<>-1 then begin

  for x:=0 to zipcount-1 do begin

    if checkstop=true then
      break;

    //INITIALIZE
    aux_:='';
    crc:='';
    space:=0;
    md5:='';
    sha1:='';
    invertedcrc:='*';
    insideposition:=x;
    cache:='';

    //---LOCATE INSIDE COMPRESSED-----------------------------------------
    pos2:=recromsbinsearch(recroms,inttostr(Trecsets(recsets[pos]).id_)+'*'+wideuppercase(stcompfiles.Strings[x]));

    if pos2<>-1 then begin

      Datamodule1.Tscanroms.Locate('ID',Trecroms(recroms[pos2]).id_,[]);

      //0.029
      cache:='';
      pass_:=false;

      crcdb:=Datamodule1.Tscanroms.fields[3].asstring;
      spacedb:=Datamodule1.Tscanroms.fields[2].ascurrency;
      md5db:=Datamodule1.Tscanroms.fields[4].asstring;
      md5:=md5db;
      sha1db:=Datamodule1.Tscanroms.fields[5].asstring;
      sha1:=sha1db;
      typ:=Datamodule1.Tscanroms.fields[6].AsInteger;

      if (crcdb<>'') AND (crcdb<>'00000000') AND (crcdb<>'FFFFFFFF') then begin
        crc:=stcompcrcs.Strings[x];
      end
      else begin //MD5 AND SHA1 BAD DUMPS 0.017
        crcdb:='';
        crc:=crcdb;
      end;

      if spacedb<>0 then
        space:=strtocurr(stcompsizes.Strings[x]);
                     
      if (md5checked=true) OR (sha1checked=true) OR (crc='') OR (typ=2) OR (Datamodule1.DBHeaders.Connected=true) then begin

        if ((md5db<>'') AND (md5db<>'00000000000000000000000000000000')) OR ((sha1db<>'') AND (sha1db<>'0000000000000000000000000000000000000000')) OR (Datamodule1.DBHeaders.connected=true) then begin

          if precache='' then
            precache:=inttohex(sizeoffile(path),0)+'-'+Inttohex(WideFileAge2(path),0)+'-';

          cache:=wideuppercase(noext+'\'+stcompfiles.strings[x])+'-'+precache+IntToHex(trunc(spacedb),0)+'-'+crcdb+'-'+md5db+'-'+sha1db;

          if (stsimplehash.IndexOf(cache)<>-1) then begin//FOUND
            pass_:=true;
            crc:=crcdb;//FORZED FOR HEADERS

            if Datamodule1.DBHeaders.Connected=true then
              space:=spacedb;
          end
          else
          if (stsimplehash.IndexOf(cache+'-')<>-1) then begin//FOUND INVERTED
            pass_:=true;
            crc:=crcdb;//FORZED FOR HEADERS

            if Datamodule1.DBHeaders.Connected=true then
              space:=spacedb;

            if crcdb<>'' then
              invertedcrc:=getinverthex(crcdb);
          end;

          if pass_=false then begin  //NOT FOUND ON CACHE THEN CHECK

            aux_:=tempdirectoryextract+gettoken(stcompfiles.strings[x],'\',GetTokenCount(stcompfiles.strings[x],'\'));

            case comptyp of
            1:begin
                if Fmain.extractfilefromzip(Fmain.zip1,stcompfiles.strings[x],tempdirectoryextract,true)=false then begin
                  deletefile2(aux_);
                  makeexception;
                end;
                end;
            2:begin
                if Fmain.extractfilefromrar(Fmain.rar1,stcompfiles.strings[x],tempdirectoryextract,true)=false then begin
                  deletefile2(aux_);
                  makeexception;
                end;
                end;
            3:begin
                if Fmain.extractfilefromsevenzip(Fmain.SevenZip1,stcompfiles.strings[x],tempdirectoryextract,true)=false then begin
                  deletefile2(aux_);
                  makeexception;
                end;
                end;
            end;

            if Datamodule1.DBHeaders.Connected=true then begin

              hfile:=applyheader(aux_,Datamodule1.Trules,Datamodule1.Ttest);

              if hfile<>'' then begin//HEADER MOD DETECTED
                deletefile2(aux_);//DELETE DECOMPRESSED
                aux_:=hfile;
              end;

              if (FileExists2(aux_)=true) AND (hfile<>'') then begin  //NEW HEADER MOD INFO

                if (crcdb<>'') then //ALSO NO INFO
                  crc:=GetCRC32(aux_);

                if spacedb<>0 then
                  space:=sizeoffile(aux_)

              end;

           end;//CONNECTED HEADERS

           if FileExists2(aux_)=true then begin

            if (md5db<>'') AND (md5db<>'00000000000000000000000000000000') then
              if (md5checked=true) OR (crc='') then
                if typ<>2 then
                  md5:=Wideuppercase(CalcHash(aux_,haMD5));

            if (sha1db<>'') AND (sha1db<>'0000000000000000000000000000000000000000') then begin
              if typ=2 then
                sha1:=chdgetinfo(aux_)
              else
              if (sha1checked=true) OR (crc='') then
                sha1:=Wideuppercase(CalcHash(aux_,haSHA1));

            end;
           end
           else begin
            crc:='@';
            invertedcrc:='@';//FORZED FAIL
           end;

           deletefile2(aux_);

          end;//FILEEXISTS AUX_
        end; //PASS_

      end;

      if Datamodule1.DBHeaders.Connected=false then begin//NOT ACCEPT HEADERS ON INVERTED CRC
        if (crc<>crcdb) then //0.027 FIX
          if (length(crc)=8) then
            invertedcrc:=getinverthex(crc);
      end
      else
      if (space<>spacedb) AND (spacedb<>0) then  //FORCE FAIL IF SIZE NOT MATCH IN USE HEADERS
        crc:='@';

      if ((crc=crcdb) OR (invertedcrc=crcdb)) AND (md5=md5db) AND (sha1=Sha1db) then begin

        //CHECK CORRECT FOLDER AND COMPRESSION
        pass_:=false;

        case typ of
          0:if (romspath=wideextractfilepath(path)) AND (romscomp=comptyp) then
            pass_:=true;
          1:if (samplespath=wideextractfilepath(path)) AND (samplescomp=comptyp) then
            pass_:=true;
          2:if (chdspath=wideextractfilepath(path)) AND (chdscomp=comptyp) then
            pass_:=true;
        end;

        //CHECK FOR MULTIDISK FORZE FAIL
        case comptyp of
          1:if zip1multivolume=true then begin
            pass_:=false;
          end;
          2:if rar1multivolume=true then
            pass_:=false;
          3:if sevenzip1multivolume=true then
            pass_:=false;
        end;

        if (space<>spacedb) AND (crcdb=invertedcrc) then  //NO ACCEPT INVERTEDCRC AND WRONG SIZE
          pass_:=false;

        //CASE SENSITIVE DIFFERENCE                   //Romname
        if getwiderecord(Datamodule1.Tscanroms.Fields[1])<>stcompfiles.strings[x] then
          pass_:=false;

        if pass_=true then begin  //ALL IS FINE

          if first=True then begin  //Only check one time in compressed file

            //CHECK CORRECT EXT IF
            path:=correctcompext(path,ext,correctext,0);//NEEDS CHANGE
            //CHECK CASE SENSITIVE  //NEEDS CHANGE              //gamename
            if noext<>getwiderecord(Datamodule1.Tscansets.Fields[2]) then
              path:=correctcase(path,WideExtractfilepath(path)+Datamodule1.Tscansets.Fields[2].asstring+zipext);

            first:=False;
          end;

          if Datamodule1.Tscanroms.Fields[9].AsBoolean=false then begin //0.030
            Datamodule1.Tscanroms.Edit;    //Have
            Datamodule1.Tscanroms.Fields[9].AsBoolean:=true;
            Datamodule1.Tscanroms.post;
          end
          else
            cache:='';//Already cached

          if (crcdb=invertedcrc) then begin
            preparelogline(2,19,1,traduction(131),path+' > '+stcompfiles.strings[x]);
            BMDThread1.Thread.Synchronize(addlogline);
            if cache<>'' then
              cache:=cache+'-';
          end
          else
          if (space<>spacedb) then begin
            preparelogline(2,3,1,traduction(323),path+' > '+stcompfiles.strings[x]);
            BMDThread1.Thread.Synchronize(addlogline);
          end;

          if typ=2 then begin
            preparelogline(2,10,1,traduction(324),path+' > '+stcompfiles.strings[x]);
            BMDThread1.Thread.Synchronize(addlogline);
          end;

          //CACHE 0.029
          if cache<>'' then //DONT SAVE
            try
              cachefile.Writeln(cache);
              stsimplehash.Add(cache);
            except
            end;

          end
          else begin
            if flagscanned=false then //If not rebuilded continue checking inside
              if processromasnocompress(path,comptyp,false)=true then
                break;

            flagscanned:=true;
          end;

        end
        else begin//Incorrect checksum

          if flagscanned=false then //If not rebuilded continue checking inside
            if processromasnocompress(path,comptyp,false)=true then
              break;

          flagscanned:=true;
        end;

    end //NOT MATCH
    else begin

      if stcompfiles.strings[x][Length(stcompfiles.strings[x])]='\' then begin  //FOUND FOLDER THIS PATH IS PART OF OTHER DB PATH THEN IGNORE

          //x=  TEMPFOLDER\T1
          //x+1=TEMPFOLDER\T1\T2
          //ADDED 0.046
          if x<>stcompfiles.Count-1 then begin
            if gettoken(stcompfiles.strings[x+1],stcompfiles.strings[x],1)<>'' then begin

              //RARE DELPHI SORTING BUG CHECK
              if Datamodule1.Tscanroms.Locate('Romname',stcompfiles.strings[x],[lopartialkey])=false then begin
                if flagscanned=false then //If not rebuilded continue checking inside
                  if processromasnocompress(path,comptyp,false)=true then
                    break;

                flagscanned:=true;
              end;

            end;//HAS A FILE OR FOLDER IN NEXT THEN IGNORE
          end
          else begin //EMPTY FOLDER THEN REBUILD
            if flagscanned=false then
              if processromasnocompress(path,comptyp,false)=true then
                break;

            flagscanned:=true;
          end;
          
          //MUST BE OPTIMIZED VERY SLOW  REMOVED 0.046
          {if Datamodule1.Tscanroms.Locate('Romname',stcompfiles.strings[x],[lopartialkey])=false then begin
            if flagscanned=false then //If not rebuilded continue checking inside
              if processromasnocompress(path,comptyp,false)=true then
                break;

            flagscanned:=true;
          end;    }

      end
      else begin

        if flagscanned=false then //If not rebuilded continue checking inside
          if processromasnocompress(path,comptyp,false)=true then
            break;

        flagscanned:=true;
      end;
    end;

  end //WHILE INSIDE ZIP

end
else //FILENAME DONT MATCH WITH ANY FOLDER REBUILD ALL
  processromasnocompress(path,comptyp,false);

end;

function Tfscan.processromasnocompress(path:widestring;origintype:integer;res:boolean):boolean;
var
x,typ,typ2:integer;
currentpath,cad,setname,romname,aux,hpath,cache,ext:widestring;
rebuild,isfolder,pass_,getcrc:boolean;
space,spacedb:currency;
crc,md5,sha1,crcdb,md5db,sha1db,invertedcrc:string;
pos,pos2:longint;
begin
//REV015
zipcount:=0;
insideposition:=0;
invertedcrc:='*';
rebuild:=true;
isfolder:=false;

//0.028
if Fmain.zip2.Tag>0 then
  if Fmain.zip2.FileName=path then begin
    Fmain.Zip2.CloseArchive;
    Fmain.zip2.Tag:=0;
  end;

if path[Length(path)]='\' then
  isfolder:=True;

path:=checkpathcase(path);//FIX possible Already fixed

//THEADSAFE???
for x:=0 to treeview1.Items.Count-1 do begin

  typ:=treeview1.items.item[x].imageindex;

  case typ of
    0:currentpath:=romspath;
    1:currentpath:=samplespath;
    2:currentpath:=chdspath;
  end;

  cad:=changein(path,currentpath,'');

  if (cad<>path) AND (currentpath+cad=path) then begin //KNOW IF PATH IS IN SCANPATH

    setname:=gettoken(cad,'\',1);

    //0.025
    pos:=recsetsbinsearch(recsets,wideuppercase(setname));

    if pos<>-1 then begin

      Datamodule1.Tscansets.Locate('ID',Trecsets(recsets[pos]).id_,[]);

      //CHECK IF CONTENT ROMS IN SET CAN UNLESS ONLY ONE BE UNCOMPRESSED
      pass_:=false;

      if (typ=0) AND (romscomp=0) AND (romspath=currentpath) then
        pass_:=true
      else
      if (typ=1) AND (samplescomp=0) AND (samplespath=currentpath) then
        pass_:=true
      else
      if (typ=2) AND (chdscomp=0) AND (chdspath=currentpath) then
        pass_:=true;

      if pass_=true then begin

        //CHECK CASE SETNAME ??? IF CONTENT IS INCORRECT RENAME ALL
        if gettoken(cad,'\',2)='' then begin//Only set folder wait next
                                                              //Gamename
          if setname<>getwiderecord(Datamodule1.Tscansets.fields[2]) then begin
            aux:=currentpath+getwiderecord(Datamodule1.Tscansets.fields[2])+'\';
            if renamedecision<>-1 then begin
              if renamedecision<>2 then
                question(traduction(173)+#10#13+path+#10#13+traduction(170)+#10#13+aux,1);

              if (renamedecision=2) OR (renamedecision=1) then begin

                WideRenameFile(path,aux);

                if checkpathcase(aux)=aux then begin
                  preparelogline(1,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+aux);
                  BMDThread1.Thread.Synchronize(addlogline);
                  path:=aux;
                end
                else begin
                  preparelogline(3,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+aux);
                  BMDThread1.Thread.Synchronize(addlogline);
                end;

              end;

            end;

            if (renamedecision=-1) OR (renamedecision=0) then begin
              preparelogline(2,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+aux);
              BMDThread1.Thread.Synchronize(addlogline);
            end;

          end;

          rebuild:=false;
          //break;

        end;

      end;
      //else  //REMOVED 0.034 Problems with multiple file types ROMS SAMPLES CHS in same profile
      //  break;
      romname:=copy(cad,length(setname)+2,length(cad));//possible romname

      pos2:=recromsbinsearch(recroms,inttostr(Trecsets(recsets[pos]).id_)+'*'+wideuppercase(romname));

      if pos2<>-1 then begin

        Datamodule1.Tscanroms.Locate('ID',Trecroms(recroms[pos2]).id_,[]);
        //INITIALIZATION
        crc:='';
        space:=0;
        md5:='';
        sha1:='';
        cache:='';

        crcdb:=Datamodule1.Tscanroms.fields[3].asstring;
        spacedb:=Datamodule1.Tscanroms.fields[2].ascurrency;
        md5db:=Datamodule1.Tscanroms.fields[4].asstring;
        md5:=md5db;
        sha1db:=Datamodule1.Tscanroms.fields[5].asstring;
        sha1:=sha1db;
        typ2:=Datamodule1.Tscanroms.fields[6].asinteger;

        getcrc:=false;

        if (crcdb<>'') AND (crcdb<>'00000000') AND (crcdb<>'FFFFFFFF') then begin
          if isfolder=true then
            crc:='00000000'
          else
            getcrc:=true;
        end
        else begin //BAD DUMPS MD5 AND SHA1 //0.017
          crc:=crcdb;
        end;

        if spacedb<>0 then
          if isfolder=false then
            space:=sizeoffile(path);

        //CACHE 0.029
        pass_:=false;

        if isfolder=false then begin
          cache:=wideuppercase(setname+'\'+romname)+'-'+inttohex(sizeoffile(path),0)+'-'+Inttohex(WideFileAge2(path),0)+'-'+IntToHex(trunc(spacedb),0)+'-'+crcdb+'-'+md5db+'-'+sha1db;

          if (stsimplehash.IndexOf(cache)<>-1) OR (agusfakecache=true) then begin//FOUND SIMPLEHASH
            pass_:=true;      //

            if getcrc=true then
              crc:=crcdb;
          end
          else
          if (stsimplehash.IndexOf(cache+'-')<>-1) then begin//FOUND SIMPLEHASH INVERTED
            pass_:=true;

            if getcrc=true then
              if crcdb<>'' then
                invertedcrc:=getinverthex(crcdb);
          end;

          if pass_=true then begin
            md5:=md5db;//FAKE CHECKSUMS
            sha1:=sha1db;
            if Datamodule1.DBHeaders.Connected=true then
              space:=spacedb;
          end;

        end;

        if pass_=false then begin //0.029 CACHE

          if getcrc=true then
            crc:=GetCRC32(path);

          //MD5 AND SHA1 in folder ignored // Force more checksums
          if (md5checked=true) OR (sha1checked=true) OR (crc='') OR (typ2=2) OR (Datamodule1.DBHeaders.Connected=true) then
            if ((md5db<>'') AND (md5db<>'00000000000000000000000000000000')) OR ((sha1db<>'0000000000000000000000000000000000000000') AND (sha1db<>'')) OR (Datamodule1.DBHeaders.connected=true) then begin

              if isfolder=False then begin

                hpath:='';

                if Datamodule1.DBHeaders.Connected=true then begin

                  hpath:=path;
                  path:=applyheader(path,Datamodule1.Trules,Datamodule1.Ttest);

                  if path<>'' then begin

                    if fileexists2(path) then
                      if (crcdb<>'') AND (crcdb<>'00000000') AND (crcdb<>'FFFFFFFF') then
                        crc:=GetCRC32(path);

                    if spacedb<>0 then
                      space:=sizeoffile(path);

                  end
                  else begin
                    path:=hpath;
                    hpath:='';
                  end;

                end;

                if FileExists2(path) then begin

                  if (md5db<>'') AND (md5db<>'00000000000000000000000000000000') then
                    if (md5checked=true) OR (crc='') then
                      if typ2<>2 then
                        md5:=Wideuppercase(CalcHash(path,haMD5));

                  if (sha1db<>'') AND (sha1db<>'0000000000000000000000000000000000000000') then
                    if typ2=2 then  //Chd force sha1
                      sha1:=chdgetinfo(path)
                    else
                    if (sha1checked=true) OR (crc='') then
                      sha1:=Wideuppercase(CalcHash(path,haSHA1));

                end
                else begin
                  crc:='@'; //FORZED FAIL
                  invertedcrc:='@';
                end;

                if hpath<>'' then begin //DELETE GENERATED HEADER FILE AND RECOVER TO OLD
                  deletefile2(path);
                  path:=hpath;
                end;

              end;//END ISFOLDER

            end;//END CHECK MD5 SHA1 OR HEADER

        end;//CACHE 0.029 END

        if Datamodule1.DBHeaders.Connected=false then begin
          if crc<>crcdb then
            if (isfolder=false) AND (length(crc)=8) then //0.027 FIX
              invertedcrc:=getinverthex(crc);
        end
        else
          if (spacedb<>space) AND (spacedb<>0) then
            crc:='@';//FORCE FAIL

        if ((crc=crcdb) OR (invertedcrc=crcdb)) AND (md5=md5db) AND (sha1=Sha1db) then begin

          pass_:=false;

          case typ2 of
            0:if (romspath=currentpath) AND (romscomp=0) then
                pass_:=true;
            1:if (samplespath=currentpath) AND (samplescomp=0) then
                pass_:=true;
            2:if (chdspath=currentpath) AND (chdscomp=0) then
                pass_:=true;
          end;

          if (space<>spacedb) AND (crcdb=invertedcrc) then  //NO ACCEPT INVERTEDCRC AND WRONG SIZE
            pass_:=false;

          if pass_=true then begin

            //CHECK CASE ROMNAME
            if romname<>getwiderecord(Datamodule1.Tscanroms.Fields[1]) then begin

              aux:=currentpath+setname+'\'+getwiderecord(Datamodule1.Tscanroms.Fields[1]);
              if isfolder=true then
                aux:=aux+'\';

              if renamedecision<>-1 then begin
                if renamedecision<>2 then
                  question(traduction(173)+#10#13+currentpath+setname+'\'+#10#13+romname+#10#13+traduction(170)+#10#13+getwiderecord(Datamodule1.Tscanroms.Fields[1]),1);

                if (renamedecision=1) OR (renamedecision=2) then begin
                  WideRenamefile(path,aux);
                  if checkpathcase(aux)=aux then begin
                    preparelogline(1,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+aux);
                    BMDThread1.Thread.Synchronize(addlogline);
                    path:=aux;
                  end
                  else begin
                    preparelogline(3,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+aux);
                    BMDThread1.Thread.Synchronize(addlogline);
                  end;
                end;

              end;

              if (Renamedecision=-1) OR (renamedecision=0) then begin
                preparelogline(2,2,1,traduction(173),path+#10#13+' '+traduction(170)+' '+aux);
                BMDThread1.Thread.Synchronize(addlogline);
              end;

            end;

            if Datamodule1.Tscanroms.Fields[9].AsBoolean=false then begin //0.030
              Datamodule1.Tscanroms.Edit;  //Have
              Datamodule1.Tscanroms.Fields[9].AsBoolean:=true;
              Datamodule1.Tscanroms.post;
            end
            else //Already cached no need to do again 0.030
              cache:='';

            rebuild:=false;

            if (crcdb=invertedcrc) then begin
              preparelogline(2,19,1,traduction(131),path);
              BMDThread1.Thread.Synchronize(addlogline);
              if cache<>'' then
                cache:=cache+'-';
            end
            else
            if (space<>spacedb) then begin
              preparelogline(2,3,1,traduction(323),path);
              BMDThread1.Thread.Synchronize(addlogline);
            end;

            //0.029 CACHE
            if cache<>'' then
              try
                cachefile.Writeln(cache);
                stsimplehash.Add(cache);
              except
              end;

            break;
          end
          else
            break;//SPEED UP

        end;//Checksums verification

      end; //Romname found
      {else //CHECK PARTIAL PATH
        if romname<>'' then begin //REMOVED SINCE 0.025
          If (Datamodule1.Tscanroms.Locate('Romname;Type',Vararrayof([romname,0]),[lopartialkey,loCaseInsensitive])=true) AND (romscomp=0) AND (romspath=currentpath) then begin
            rebuild:=False;
            break;
          end
          else
          If (Datamodule1.Tscanroms.Locate('Romname;Type',Vararrayof([romname,1]),[lopartialkey,loCaseInsensitive])=true) AND (samplescomp=0) AND (samplespath=currentpath) then begin
            rebuild:=False;
            break;
          end
          else
          If (Datamodule1.Tscanroms.Locate('Romname;Type',Vararrayof([romname,2]),[lopartialkey,loCaseInsensitive])=true) AND (chdscomp=0) AND (chdspath=currentpath) then begin
            rebuild:=False;
            break;
          end
          else
            break;
        end
        else
          break;  }

    end;//Gamename found

  end;//Scanpath is in path

end;//Treeview loop

if (rebuild=true) then
  if isfolder=False then begin

    if scanasnocompress=true then begin //0.035 --------------------------------
      ext:=WideExtractFileExt(path);

      if wideLowerCase(ext)=zipext then begin
        if Fmain.zipvalidfile(path,Fmain.zip1)=true then
          origintype:=1
        else
        if Fmain.sevenzipvalidfile(path,Fmain.sevenzip1)=true then
          origintype:=3
        else
        if Fmain.rarvalidfile(path,Fmain.rar1)=true then
          origintype:=2;
      end
      else
      if wideLowerCase(ext)=sevenzipext then begin
        if Fmain.sevenzipvalidfile(path,Fmain.sevenzip1)=true then
          origintype:=3
        else
        if Fmain.zipvalidfile(path,Fmain.zip1)=true then
          origintype:=1
        else
        if Fmain.rarvalidfile(path,Fmain.rar1)=true then
          origintype:=2;
      end
      else
      if wideLowerCase(ext)=rarext then begin
        if Fmain.rarvalidfile(path,Fmain.rar1)=true then
          origintype:=2
        else
        if Fmain.zipvalidfile(path,Fmain.zip1)=true then
          origintype:=1
        else
        if Fmain.sevenzipvalidfile(path,Fmain.sevenzip1)=true then
          origintype:=3
      end;

    end;//SCANASNOCOMPRESS RECOVER COMPRESSION ORIGIN IF EXISTS-----------------

    res:=rebuildfile(path,origintype,0,'',0,'');

    if (IsDirectoryEmpty(wideextractfilepath(path))) AND (wideDirectoryExists(wideextractfilepath(path))) then begin//Fixed
      flagscanned:=false;
      processromasnocompress(checkpathbar(wideextractfilepath(path)),origintype,res);
    end;
  end
  else
    if (IsDirectoryEmpty(path)) AND (WideDirectoryexists(path))then
      if (wideuppercase(path)<>wideuppercase(romspath)) AND (wideuppercase(path)<>wideuppercase(samplespath)) AND (wideuppercase(path)<>wideuppercase(chdspath)) AND (wideuppercase(path)<>wideuppercase(edit1.text)) then begin
        try
          WideRemoveDir(path);
        except
        end;
        if wideDirectoryExists(path)=true then begin
          preparelogline(3,11,1,traduction(365),path);
          BMDThread1.Thread.Synchronize(addlogline);
        end
        else begin
          preparelogline(1,11,1,traduction(365),path);
          BMDThread1.Thread.Synchronize(addlogline);
        end;
      end;


Result:=res;
end;

procedure TFscan.addcompressioncache(cache:widestring;compid:widestring);
var
x:integer;
mount:widestring;
begin
cachefile.Writeln(cache);
for x:=0 to stcompfiles.Count-1 do begin
  mount:=cache+'*'+stcompfiles.Strings[x]+'*'+inttohex(strtoint64(stcompsizes.Strings[x]),0)+'*'+stcompcrcs.Strings[x];
  if x=0 then begin
    mount:=mount+'*'+compid+'*'+inttohex(realcompressedfilecount,0);

  end;
  //question('SALVADA: '+mount,20);
  //stsimplehash.Add(mount);
  cachefile.Writeln(mount);
end;

end;

procedure TFscan.addcompressioncacherebuild(cache:widestring;compid:widestring);
var
x:integer;
mount,aux:widestring;
begin
aux:='';
cachefilereb.Writeln(cache);
for x:=0 to stcompfiles.Count-1 do begin
  mount:=cache+'*'+stcompfiles.Strings[x]+'*'+inttohex(strtoint64(stcompsizes.Strings[x]),0)+'*'+stcompcrcs.Strings[x];
  if x=0 then begin //SAVE IF MULTIVOLUME

    case strtoint(compid) of
      1:if zip1multivolume=true then
          aux:='*'+booltostr(zip1multivolume);
      2:if rar1multivolume=true then
          aux:='*'+booltostr(rar1multivolume);
      3:if sevenzip1multivolume=true then
          aux:='*'+booltostr(sevenzip1multivolume);
    end;

    mount:=mount+'*'+compid+'*'+inttohex(realcompressedfilecount,0)+aux;

  end;

  cachefilereb.Writeln(mount);
end;

end;

procedure TFscan.processrom(path:widestring);
var
ext:widestring;
cache,cachereb:widestring;
cacheid:longint;
aux:widestring;
x:integer;
filename,apath:widestring;
c,i:longint;
cext:string;
pass,savecache,inromspath:boolean;
begin
pass:=false;
flagscanned:=false;
currentset:=path;
savecache:=false;
inromspath:=false;

apath:=wideextractfilepath(path);
apath:=checkpathbar(apath);//SECURITY

//0.043 KNOW IF IS ROMSPATH THE FILE TO PROCESS
if gettokencount(wideuppercase(apath),wideuppercase(romspath))>1 then
  inromspath:=true
else
if gettokencount(wideuppercase(apath),wideuppercase(samplespath))>1 then
  inromspath:=true
else
if gettokencount(wideuppercase(apath),wideuppercase(chdspath))>1 then
  inromspath:=true;


//0.043 FORZE FOR NOT CACHED REBUILD
if (scanasnocompress=true) AND (inromspath=true) then begin //0.035 SPEEDUP
  processromasnocompress(path,0,false);
end
else begin
  ext:=wideExtractFileExt(path);

  cache:='*'+inttohex(sizeoffile(path),0)+'*'+Inttohex(WideFileAge2(path),0);
  cachereb:=cache;
  cache:=wideuppercase(WideExtractFileName(path))+cache;
  cachereb:=wideuppercase(path)+cachereb;

  //NOT REBUILD FILE MUST CHECK FOR CACHE 0.043
  if inromspath=true then
  try
    cacheid:=stsimplehash.IndexOf(cache);

    if cacheid<>-1 then begin
      stcompfiles.clear;
      stcompsizes.Clear;
      stcompcrcs.clear;

      cacheid:=cacheid+1;

      while cacheid<=stsimplehash.Count-1 do begin
        aux:=stsimplehash.Strings[cacheid];

        if gettokencount(aux,cache)=1 then
          break;

        x:=gettokencount(aux,'*');
        case x of
          6:begin   //FILENAME.ZIP-SIZE-AGE-INFILENAME-SIZE-CRC32
              filename:=gettoken(aux,'*',4);
              stcompfiles.Add(filename);
              stcompsizes.add(inttostr(hextoint(gettoken(aux,'*',5))));
              stcompcrcs.Add(gettoken(aux,'*',6));
              //SORTING
              i:=stcompfiles.IndexOf(filename);
              stcompcrcs.Move(stcompcrcs.Count-1,i);
              stcompsizes.Move(stcompsizes.Count-1,i);
          end;
          8..9:begin
              c:=strtoint(gettoken(aux,'*',7));
              case c of
                1:begin
                    cext:=zipext; //FORCE CLOSE
                    fmain.zip1.CloseArchive;
                    fmain.Zip1.Tag:=0;
                    fmain.Zip1.FileName:=path;
                    zip1multivolume:=false;
                    if x=9 then
                      zip1multivolume:=strtobool(gettoken(aux,'*',9));
                  end;
                2:begin
                    cext:=rarext;
                    rar1filename:=path; //0.043
                    rar1multivolume:=false;
                    if x=9 then
                      rar1multivolume:=strtobool(gettoken(aux,'*',9));
                  end;
                3:begin
                    cext:=sevenzipext;
                    sevenzip1filename:=path;//0.043
                    sevenzip1multivolume:=false;
                    if x=9 then
                      sevenzip1multivolume:=strtobool(gettoken(aux,'*',9));
                  end;
                else
                  makeexception;//FORZE EXCEPTION WRONG READING
              end;

              realcompressedfilecount:=hextoint(gettoken(aux,'*',8));

              filename:=gettoken(aux,'*',4);
              stcompfiles.Add(filename);
              stcompsizes.add(inttostr(hextoint(gettoken(aux,'*',5))));
              stcompcrcs.Add(gettoken(aux,'*',6));
              //SORTING
              i:=stcompfiles.IndexOf(filename);
              stcompcrcs.Move(stcompcrcs.Count-1,i);
              stcompsizes.Move(stcompsizes.Count-1,i);

            end;
        end;//CASE

        cacheid:=cacheid+1;

      end; //WHILE

      if cext<>'' then begin
        pass:=true;
        addcompressioncache(cache,inttostr(c));
        processromascompressed(path,ext,c,cext);
      end;

    end//CACHEID FOUND
    else
      savecache:=true;

  except //IF FAIL CACHE CONTINUE NORMAL
    stcompfiles.clear;
    stcompsizes.Clear;
    stcompcrcs.clear;
    //question('EXCEPT',20);
  end;
  //0.039 END

  if pass=false then begin

//FIND CACHE REBUILD COMPRESSED FILES--------------------------------------------------------------
    if inromspath=false then begin//OUT OF ROMSPATH THEN CACHE IN CACHE FOR REBUILD FOR ZIPPED
      try
        cacheid:=stsimplehashreb.IndexOf(cachereb);
                          
        if cacheid<>-1 then begin
          stcompfiles.clear;
          stcompsizes.Clear;
          stcompcrcs.clear;

          cacheid:=cacheid+1;

          while cacheid<=stsimplehashreb.Count-1 do begin
            aux:=stsimplehashreb.Strings[cacheid];

            if gettokencount(aux,cachereb)=1 then
              break;

            x:=gettokencount(aux,'*');
            case x of
              6:begin   //FILENAME.ZIP-SIZE-AGE-INFILENAME-SIZE-CRC32
                filename:=gettoken(aux,'*',4);
                stcompfiles.Add(filename);
                stcompsizes.add(inttostr(hextoint(gettoken(aux,'*',5))));
                stcompcrcs.Add(gettoken(aux,'*',6));
                //SORTING
                i:=stcompfiles.IndexOf(filename);
                stcompcrcs.Move(stcompcrcs.Count-1,i);
                stcompsizes.Move(stcompsizes.Count-1,i);
              end;
              8..9:begin
                c:=strtoint(gettoken(aux,'*',7));
                case c of
                1:begin
                    cext:=zipext; //FORCE CLOSE
                    fmain.zip1.CloseArchive;
                    fmain.Zip1.Tag:=0;
                    fmain.Zip1.FileName:=path;
                    zip1multivolume:=false;
                    if x=9 then
                      zip1multivolume:=strtobool(gettoken(aux,'*',9));
                  end;
                2:begin
                    cext:=rarext;
                    rar1filename:=path; //0.043
                    rar1multivolume:=false;
                    if x=9 then
                      rar1multivolume:=strtobool(gettoken(aux,'*',9));
                  end;
                3:begin
                    cext:=sevenzipext;
                    sevenzip1filename:=path;//0.043
                    sevenzip1multivolume:=false;
                    if x=9 then
                      sevenzip1multivolume:=strtobool(gettoken(aux,'*',9));
                  end;
                else
                  makeexception;//FORZE EXCEPTION WRONG READING
              end;
              realcompressedfilecount:=hextoint(gettoken(aux,'*',8));

              filename:=gettoken(aux,'*',4);
              stcompfiles.Add(filename);
              stcompsizes.add(inttostr(hextoint(gettoken(aux,'*',5))));
              stcompcrcs.Add(gettoken(aux,'*',6));
              //SORTING
              i:=stcompfiles.IndexOf(filename);
              stcompcrcs.Move(stcompcrcs.Count-1,i);
              stcompsizes.Move(stcompsizes.Count-1,i);
            end;

            end;//CASE

            cacheid:=cacheid+1;

          end; //WHILE

          if cext<>'' then begin
            pass:=true;
            addcompressioncacherebuild(cachereb,inttostr(c));
            processromascompressed(path,ext,c,cext);
          end;

        end//CACHEID FOUND
        else
          savecache:=true;

      except //IF FAIL CACHE CONTINUE NORMAL
        stcompfiles.clear;
        stcompsizes.Clear;
        stcompcrcs.clear;
        //question('EXCEPT',20);
      end;
    end;


//END FIND CACHE REBUILD COMPRESSED FILES--------------------------------------------------


    if pass=false then
    if wideLowerCase(ext)=zipext then begin

      if Fmain.zipvalidfile(path,Fmain.Zip1)=true then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'1');
        end
        else begin
          addcompressioncacherebuild(cachereb,'1');
        end;

        processromascompressed(path,ext,1,zipext);
      end
      else
      if Fmain.sevenzipvalidfile(path,Fmain.sevenzip1)=true then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'3');
        end
        else
          addcompressioncacherebuild(cachereb,'3');

        processromascompressed(path,ext,3,sevenzipext);
      end
      else
      if Fmain.rarvalidfile(path,Fmain.RAR1)=true then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'2');
        end
        else
          addcompressioncacherebuild(cachereb,'2');

        processromascompressed(path,ext,2,rarext);
      end
      else
        processromasnocompress(path,0,false);

    end
    else
    if lowercase(ext)=sevenzipext then begin

      if Fmain.sevenzipvalidfile(path,Fmain.sevenzip1)=true then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'3');
        end
        else
          addcompressioncacherebuild(cachereb,'3');
        processromascompressed(path,ext,3,sevenzipext);
      end
      else
      if Fmain.zipvalidfile(path,Fmain.Zip1) then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'1');
        end
        else
          addcompressioncacherebuild(cachereb,'1');
        processromascompressed(path,ext,1,zipext);
      end
      else
      if Fmain.rarvalidfile(path,Fmain.RAR1) then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'2');
        end
        else
          addcompressioncacherebuild(cachereb,'2');
        processromascompressed(path,ext,2,rarext);
      end
      else
        processromasnocompress(path,0,false);

    end
    else
    if lowercase(ext)=rarext then begin

      if Fmain.rarvalidfile(path,Fmain.RAR1) then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'2');
        end
        else
          addcompressioncacherebuild(cachereb,'2');
        processromascompressed(path,ext,2,rarext);
      end
      else
      if Fmain.zipvalidfile(path,Fmain.Zip1) then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'1');
        end
        else
          addcompressioncacherebuild(cachereb,'1');
        processromascompressed(path,ext,1,zipext);
      end
      else
      if Fmain.sevenzipvalidfile(path,Fmain.sevenzip1) then begin
        if inromspath=true then begin
          if savecache=true then
            addcompressioncache(cache,'3');
        end
        else
          addcompressioncacherebuild(cachereb,'3');
        processromascompressed(path,ext,3,sevenzipext);
      end
      else
        processromasnocompress(path,0,false);

    end
    else begin//Check invalid extensions and last check as uncompressed
      processromasnocompress(path,0,false);
    end;

  end;//PASS FALSE

end;//SCANASNOCOMPRESS ELSE

end;

procedure TFscan.FormShow(Sender: TObject);
var
x:integer;
begin
Fmain.addtoactiveform((sender as Tform),true);

if isrebuild=false then begin
  caption:=traduction(110);
  image322.Visible:=true;
  label1.Caption:=traduction(112);
end
else begin
  caption:=traduction(113);
  image321.Visible:=true;
  label1.Caption:=traduction(199);
end;

Fmain.labelshadow(label1,Fscan);

bitbtn3.Enabled:=true;

bitbtn1.Caption:=traduction(142);
bitbtn2.Caption:=traduction(143);
bitbtn3.caption:=traduction(217);
label2.Caption:=traduction(120);
label4.Caption:=traduction(137);
label5.Caption:=traduction(139)+' :';
label7.Caption:=traduction(138);
label6.Caption:=traduction(140);
label3.Caption:=traduction(141);
CheckBox3.Caption:=traduction(144);
CheckBox4.Caption:=traduction(145);
CheckBox5.Caption:=traduction(146)+' (*.zip)';
checkbox1.Caption:=traduction(366)+' (*.7z)';
label8.Caption:=traduction(61)+' : '+traduction(147);
SpeedButton3.Caption:=traduction(177);
Folder1.Caption:=UTF8Encode(traduction(171));
speedbutton1.Hint:=traduction(163);
speedbutton2.Hint:=traduction(163);
speedbutton4.Hint:=traduction(340);
speedbutton6.Hint:=traduction(341);
speedbutton7.Hint:=traduction(351);

Alwaysask1.caption:=UTF8Encode(traduction(429));
Decideyestoall1.caption:=UTF8Encode(traduction(430));
Decidenotoall1.caption:=UTF8Encode(traduction(431));
Custom1.caption:=UTF8Encode(traduction(432));
speedbutton5.Hint:=traduction(433);

Donothing1.Caption:=UTF8Encode(traduction(635));
Sleeponterminte1.Caption:=UTF8Encode(traduction(636));
Shutdownonterminate1.Caption:=UTF8Encode(traduction(637));

for x:=0 to ComponentCount-1 do
  if components[x] is Tmenuitem then
    if (Components[x] as Tmenuitem).tag=1 then
      (Components[x] as Tmenuitem).OnClick:=Folder1Click;

n01.caption:=n01.caption+' - '+UTF8Encode(traduction(502));
n02.caption:=n02.caption+' - '+UTF8Encode(traduction(502));
n03.caption:=n03.caption+' - '+UTF8Encode(traduction(502));

n91.caption:=n91.caption+' - '+UTF8Encode(traduction(501));
n92.caption:=n92.caption+' - '+UTF8Encode(traduction(501));
n93.caption:=n93.caption+' - '+UTF8Encode(traduction(501));

if Flog.tag=1 then begin
  speedbutton3.Down:=true;
  myshowform(Flog,false);
end
else
  speedbutton3.Down:=false;

if Fscan.Tag=1 then begin
  //MUST DISSABLED
  //disableforscan(true);//DISABLE COMPONENTS ON SHOW

  speedbutton5.Visible:=false;//ON BATCH HIDE DECISION BUTTON
  tntspeedbutton1.Left:=speedbutton5.Left;

  //SAVE DEFAULT ASK DECISIONS
  fix0:='0';
  fix1:='0';
  fix2:='0';
  fix3:='0';
  fix4:='0';
  fix5:='0';
  fix6:='0';

  if Fask.checkbox2.Checked then
    fix0:='1'
  else
  if Fask.CheckBox3.Checked then
    fix0:='2';

  if Fask.checkbox5.Checked then
    fix1:='1'
  else
  if Fask.CheckBox6.Checked then
    fix1:='2';

  if Fask.checkbox8.Checked then
    fix2:='1'
  else
  if Fask.CheckBox9.Checked then
    fix2:='2';

  if Fask.checkbox11.Checked then
    fix3:='1'
  else
  if Fask.CheckBox12.Checked then
    fix3:='2';

  if Fask.checkbox14.Checked then
    fix4:='1'
  else
  if Fask.CheckBox15.Checked then
    fix4:='2';

  if Fask.checkbox17.Checked then
    fix5:='1'
  else
  if Fask.CheckBox18.Checked then
    fix5:='2';

  if Fask.checkbox20.Checked then
    fix6:='1'
  else
  if Fask.CheckBox21.Checked then
    fix6:='2';

  fix7:=inttostr(Fask.ComboBox1.ItemIndex);

  timer1.tag:=0;//NEEDED
  Fmain.taskbaractive(true);

  timer1.enabled:=true;

end
else begin
  statoload;//LOAD NORMAL PROFILE ASK DECISIONS
end;

//Window position check
if (oldscanleft<>-1) AND (oldscantop<>-1) then
  if (oldscanleft>screen.DesktopRect.Right) OR (oldscantop>screen.DesktopRect.Bottom) OR (oldscanleft-Fscan.Width<screen.DesktopRect.left-Fscan.Width-Fscan.Width) OR (oldscantop-Fscan.Height<screen.DesktopRect.Top-Fscan.Height-Fscan.Height) then begin
    oldscanleft:=-1;
    oldscantop:=-1;
  end
  else begin
    Fscan.Left:=oldscanleft;
    Fscan.Top:=oldscantop;
  end;

end;

procedure TFscan.FormCreate(Sender: TObject);
begin
oldscanleft:=-1;
oldscantop:=-1;
haschds:=false;

Fmain.setlabeltoprogressbar(tntlabel1,progressbar1);
Fmain.setlabeltoprogressbar(tntlabel2,progressbar2);

deletelist:=TTntStringList.Create;
deletelist.Sorted:=true;
deletelist.Duplicates:=dupIgnore;//NO DUPLICATES NEVER
deleteheaderlist:=Ttntstringlist.create;
Fmain.fixcomponentsbugs(Fscan);

Application.CreateForm(TFask, Fask);
Fask.endtoimage(0);
end;

procedure TFscan.BitBtn1Click(Sender: TObject);
var
x:integer;
begin
sterrors.Clear;
scanpath:='';
romspath:='';
samplespath:='';
chdspath:='';
scantoo:=true;
scanasnocompress:=true;
agusfakecache:=speedbutton8.Down;

Datamodule1.Tprofiles.Locate('ID',scanprofileid,[]);//0.037 SETS EXISTS?
if Datamodule1.Tprofiles.FieldByName('Totalsets').asinteger=0 then begin
  mymessageerror(traduction(328));
  disableforscan(false);//FIX 0.042
  exit;
end;

md5checked:=checkbox3.Checked;
sha1checked:=checkbox4.Checked;

//DEFAULT
romscomp:=strtoint(fillwithzeroes(inttostr(defromscomp),2)[1]);
samplescomp:=strtoint(fillwithzeroes(inttostr(defsamplescomp),2)[1]);
chdscomp:=strtoint(fillwithzeroes(inttostr(defchdscomp),2)[1]);
romscomplevel:=strtoint(fillwithzeroes(inttostr(defromscomp),2)[2]);
samplescomplevel:=strtoint(fillwithzeroes(inttostr(defsamplescomp),2)[2]);
chdscomplevel:=strtoint(fillwithzeroes(inttostr(defchdscomp),2)[2]);

if romscomp=0 then
  romscomplevel:=0;
if samplescomp=0 then
  samplescomplevel:=0;
if chdscomp=0 then
  chdscomplevel:=0;

for x:=0 to treeview1.Items.Count-1 do begin
         
  if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([scanprofileid,treeview1.Items.Item[x].ImageIndex]),[])=true then
    case treeview1.Items.Item[x].ImageIndex of
      0:begin
          romspath:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
          romscomp:=getcompressionimage(Integer( TreeView1.Items[x].Data ));
          try
            romscomplevel:=strtoint((inttostr((Integer( TreeView1.Items[x].Data )))[2]));
          except
          end;
        end;
      1:begin
          samplespath:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
          samplescomp:=getcompressionimage(Integer( TreeView1.Items[x].Data ));
          try
            samplescomplevel:=strtoint((inttostr((Integer( TreeView1.Items[x].Data )))[2]));
          except
          end;
        end;
      2:begin
          chdspath:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
          chdscomp:=getcompressionimage(Integer( TreeView1.Items[x].Data ));
          try
            chdscomplevel:=strtoint((inttostr((Integer( TreeView1.Items[x].Data )))[2]));
          except
          end;
        end;
    end;

end;

//0.035 SPEEDUP FOR COMPRESSED BUT SCAN AS NOT AGUS
for x:=0 to treeview1.Items.Count-1 do
  if getcompressionimage(Integer(TreeView1.Items[x].Data))>0 then //>0 = No folder 
    scanasnocompress:=false;

if samplespath='' then
  samplespath:=romspath;

if chdspath='' then
  chdspath:=romspath;

backuppath:=Edit1.Text;
backuppath:=checkpathbar(backuppath);

//Check directories
for x:=0 to treeview1.Items.Count-1 do begin
  case treeview1.Items.Item[x].ImageIndex of
    0:if not WideDirectoryExists(romspath) then
        sterrors.Add(traduction(157));
    1:if not WideDirectoryExists(samplespath) then
        sterrors.Add(traduction(158));
    2:if not WideDirectoryExists(chdspath) then
        sterrors.Add(traduction(159));
  end;
end;

try
  wideforcedirectories(backuppath);
except            
end;

if not WideDirectoryExists(backuppath) then
  sterrors.Add(traduction(168));

if sterrors.text='' then
  if (GetToken(Wideuppercase(backuppath),Wideuppercase(romspath),1)<>Wideuppercase(backuppath)) OR (GetToken(Wideuppercase(backuppath),Wideuppercase(samplespath),1)<>Wideuppercase(backuppath)) OR (GetToken(Wideuppercase(backuppath),Wideuppercase(chdspath),1)<>
Wideuppercase(backuppath)) OR (GetToken(Wideuppercase(romspath),Wideuppercase(backuppath),1)<>Wideuppercase(romspath)) OR (GetToken(Wideuppercase(samplespath),Wideuppercase(backuppath),1)<>Wideuppercase(samplespath)) OR (GetToken(Wideuppercase(chdspath),Wideuppercase(backuppath),1)<>Wideuppercase(chdspath)) OR (GetToken(Wideuppercase(tempdirectoryextract),Wideuppercase(romspath),1)<>Wideuppercase(tempdirectoryextract)) OR (GetToken(Wideuppercase(tempdirectoryextract),Wideuppercase(samplespath),1)<>Wideuppercase(tempdirectoryextract)) OR (GetToken(Wideuppercase(tempdirectoryextract),Wideuppercase(chdspath),1)<>Wideuppercase(tempdirectoryextract)) OR (GetToken(Wideuppercase(romspath),Wideuppercase(tempdirectoryextract),1)<>Wideuppercase(romspath)) OR (GetToken(Wideuppercase(samplespath),Wideuppercase(tempdirectoryextract),1)<>Wideuppercase(samplespath)) OR (GetToken(Wideuppercase(chdspath),Wideuppercase(tempdirectoryextract),1)<>Wideuppercase(chdspath))
  OR (GetToken(Wideuppercase(backuppath),Wideuppercase(tempdirectoryextract),1)<>Wideuppercase(backuppath)) OR (GetToken(Wideuppercase(tempdirectoryextract),Wideuppercase(backuppath),1)<>Wideuppercase(tempdirectoryextract)) then
    sterrors.add(traduction(305));

if sterrors.Text<>'' then begin
  mymessageerror(sterrors.Text);
  sterrors.Clear;
  Flog.speedbutton2.Enabled:=true;
  romspath:='';
  samplespath:='';
  chdspath:='';
  backuppath:='';
  disableforscan(false);
  exit;
end;
                       
stop:=false;
BMDThread1.Priority:=Fmain.BMDThread1.Priority;


if isrebuild=true then begin

  if Fask.ComboBox1.ItemIndex=1 then //SINZE 0.020
    scantoo:=false;

  if isrebuildbatch=false then begin
      BMDThread1.Start;
  end
  else begin
    //stdropfolders must have folder value to rebuild
    BMDThread1.Start;
  end;

end
else begin
  BMDThread1.Start;
end;

end;

function checksumtobool(md5,sha1:boolean):string;
begin
result:='0';
if md5=true then
  result:='1';

if sha1=true then
  result:=result+'1'
else
  result:=result+'0';
end;

procedure TFscan.BMDThread1Execute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
croms,csets,tid:longint;
lastpathes,sortfiles:TTntStringList;
x,y:integer;
s,s2:widestring;
filelistpath,dupepath,origincomp,originfile,aux:widestring;
acrc,amd5,asha1:string;
dupecomp:Shortint;
n,n2:integer;
dummypass,already,hasmd5,hassha1:boolean;
begin
Fmain.initializeextractionfolders;
already:=false;
issecondpass:=false;
filelistpath:=tempdirectoryresources+'files.rmt';
hasmd5:=false;
hassha1:=false;

//NEEDED TO DETECT INVERTED CRC AS BADDUMP
Datamodule1.Tinvertedcrc.close;
Datamodule1.Tinvertedcrc.tablename:=Datamodule1.Tscanroms.tablename;
Datamodule1.Tinvertedcrc.open;

//LOAD HEADERS
if Datamodule1.Tprofiles.FieldByName('Header').asstring<>'' then begin
  if loadheader(headerspath+getwiderecord(Datamodule1.Tprofiles.FieldByName('Header'))) then begin
    preparelogline(1,12,1,traduction(368),headerspath+getwiderecord(Datamodule1.Tprofiles.FieldByName('Header')));
    addlogline(Fscan);
  end
  else begin
    preparelogline(3,12,1,traduction(368),headerspath+getwiderecord(Datamodule1.Tprofiles.FieldByName('Header')));
    addlogline(Fscan);
  end;
end;

lastpathes:=TTntStringList.Create;

Datamodule1.Tscansets.Open;
Datamodule1.Tscanroms.open;

Datamodule1.DBDatabase.StartTransaction;

lastpathes.Clear;

//INITIALIZE HERE
hascompressed:=false;

other:=traduction(61)+' : '+traduction(270);
BMDThread1.Thread.Synchronize(syncstatus);

Datamodule1.Tscanroms.first;

setsposition:=0;//Zero progress
progressbar2.Max:=Datamodule1.Tscanroms.RecordCount;

//TO DEFAULT
md5checkedreb:=false;
sha1checkedreb:=false;

Datamodule1.Tscanroms.DisableControls;//SPEED HACK

clearrecords;

While not Datamodule1.Tscanroms.Eof do begin
  s:=wideuppercase(wideExtractFileExt(getwiderecord(Datamodule1.Tscanroms.FieldByName('Romname'))));

  if s='.ZIP' then
    hascompressed:=true
  else
  if s='.RAR' then
    hascompressed:=true
  else
  if s='.7Z' then
    hascompressed:=true;

  acrc:=Datamodule1.Tscanroms.fields[3].asstring; //CRC
  amd5:=Datamodule1.Tscanroms.fields[4].asstring; //Md5
  asha1:=Datamodule1.Tscanroms.fields[5].asstring; //SHA1
                                    //Have                                 //SINZE 0.020
  if (Datamodule1.Tscanroms.Fields[9].asboolean=true) AND (scantoo=true) then begin
    Datamodule1.Tscanroms.edit;
    Datamodule1.Tscanroms.Fields[9].asboolean:=false;
    Datamodule1.Tscanroms.post;
  end;

  if amd5<>'' then
    hasmd5:=true;

  if asha1<>'' then
    hassha1:=true;

  //0.028 create hashes list with DBID
  tid:=Datamodule1.Tscanroms.fields[0].asinteger; //ID
  reccrcs.Add(Treccrcs.Create(tid,acrc));
  recmd5s.Add(Trecmd5s.Create(tid,amd5));
  recsha1s.Add(Trecsha1s.Create(tid,asha1));

  //FOLDERS PASS
  s:=getwiderecord(Datamodule1.Tscanroms.fieldbyname('romname'));
  if s[Length(s)]<>'\' then
  if (acrc='') OR (acrc='FFFFFFFF') OR (acrc='00000000') then //0.024
    if Datamodule1.Tscanroms.Fields[6].asinteger=0 then //Type ROM
      if (amd5<>'') AND (amd5<>'D41D8CD98F00B204E9800998ECF8427E') AND (amd5<>'00000000000000000000000000000000') then
        md5checkedreb:=true
      else
      if (asha1<>'') AND (asha1<>'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709') AND (asha1<>'0000000000000000000000000000000000000000') then
        sha1checkedreb:=true;

  setsposition:=setsposition+1;
  Datamodule1.Tscanroms.Next;
end;


//0.025
getcounterfilemode('Y'+scanprofileid,'Z'+scanprofileid,Datamodule1.Tprofiles.fieldbyname('Filemode').asinteger,true);

if (isoff=true) AND (md5checked=true) then begin
  md5checked:=false;//MSG DISSABLE
  preparelogline(2,21,1,traduction(616),'');
  addlogline(Fscan);
end
else
if (hasmd5=false) AND (md5checked=true) then begin
  md5checked:=false;//MSG DISSABLE
  preparelogline(2,21,1,traduction(616),'');
  addlogline(Fscan);
end;

if (isoff=true) AND (sha1checked=true) then begin
  sha1checked:=false;//MSG DISSABLE
  preparelogline(2,22,1,traduction(617),'');
  addlogline(Fscan);
end
else
if (hassha1=false) AND (sha1checked=true) then begin
  sha1checked:=false;//MSG DISSABLE
  preparelogline(2,22,1,traduction(617),'');
  addlogline(Fscan);
end;

//IF NOT DEFAULT THEN COPY RESULTS OF SCAN CHECKSUMS
if (md5checkedreb=false) then
  md5checkedreb:=md5checked
else begin //FORZE MD5 MSG
  preparelogline(2,21,1,traduction(618),'');
  addlogline(Fscan);
end;

if (sha1checkedreb=false) then
  sha1checkedreb:=sha1checked
else begin  //FORZE SHA1 MSG
  preparelogline(2,22,1,traduction(619),'');
  addlogline(Fscan);
end;

//CACHE 0.029 FILE LOAD AND SAVE
aux:=tempdirectorycache+Fmain.getdbid+'-'+inttohex(strtoint64(scanprofileid),8);

if FileExists2(aux) then begin
  try //IF NOT VALID ZIP FILE THEN TRY TO LOAD AS TXT FILE

    Fmain.Zip1.CloseArchive;
    Fmain.zip1.FileName:=aux;
    Fmain.zip1.OpenArchive;

    aux:=tempdirectoryresources+'cache';
    deletefile2(aux);//SECURITY TO CAN EXTRACT
    Fmain.zip1.BaseDir:=tempdirectoryresources;
    Fmain.Zip1.ExtractFiles('cache');
    stsimplehash.LoadFromFile(aux);
    deletefile2(aux);

  except
  end;

  Fmain.zip1.CloseArchive;
end;

//Cache load 0.029
deletefile2(aux);

//Changed hashing options clear cache
if stsimplehash.IndexOf(checksumtobool(md5checked,sha1checked))=-1 then
  stsimplehash.Clear;

try
  aux:=tempdirectorycache+'cache';
  //If only rebuild option without scan copy old cache and add apped new one
  if (scantoo=false) AND (stsimplehash.Count>1) then begin
    //Delete compression info flag
    stsimplehash.Delete(stsimplehash.IndexOf(checksumtobool(md5checked,sha1checked)));

    stsimplehash.SaveToFile(aux);
    cachefile:=TGpTextFile.CreateW(aux);
    cachefile.append;
  end
  else begin
    cachefile:=TGpTextFile.CreateW(aux);
    cachefile.Rewrite([cfUnicode]);
  end;
except
end;

//0.043 CACHE FOR REBUILD
try
  if isrebuild=true then begin
    aux:=tempdirectorycache+Fmain.getdbid+'-'+'REBUILD';
    //LOAD LATEST CACHE AND CREATE NEW ONE
    if FileExists2(aux) then
      if FileExists2(aux) then begin
        try
          stsimplehashreb.LoadFromFile(aux);
          if stsimplehashreb.IndexOf('00')=-1 then //NO END FLAG FOUND, DELETE CACHE REBUILD
            stsimplehashreb.Clear;
        except
        end;
      end;

    cachefilereb:=TGpTextFile.CreateW(aux);
    cachefilereb.Rewrite([cfUnicode]);
  end;
except
end;

setsposition:=0;//Zero progress

//INITIALIZED END

romspath:=checkpathcase(romspath);
samplespath:=checkpathcase(samplespath);
chdspath:=checkpathcase(chdspath);
romspath:=checkpathbar(romspath);
samplespath:=checkpathbar(samplespath);
chdspath:=checkpathbar(chdspath);

lastpathes.Add(romspath);
lastpathes.add(samplespath);
lastpathes.add(chdspath);
lastpathes.Sort;

for x:=lastpathes.Count-1 downto 1 do //Delete descendants or dupes
  if changein(lastpathes.Strings[x],lastpathes.Strings[x-1],'')<>lastpathes.Strings[x] then
    lastpathes.Delete(x);

for n:=0 to 1 do begin

  if n=1 then begin
    issecondpass:=true;
    if isrebuild=false then
      break;
  end;

  //Loop scan pathes
  for x:=0 to lastpathes.Count-1 do begin

    if checkstop=true then
      break;

    romscounter:=0;
    setsposition:=0;

    scanpath:=lastpathes.Strings[x];

    if wideDirectoryExists(scanpath) then begin

        scanpath:=checkpathcase(scanpath);

        //Count files
        if checkstop=false then begin

          other:=traduction(61)+' : '+traduction(148);
          BMDThread1.Thread.Synchronize(syncstatus);

          listfiles:=TGpTextFile.Createw(filelistpath);
          listfiles.Rewrite([cfUnicode]);

          If (isrebuild=false) OR (n=1) then begin

            if scantoo=true then //SINZE 0.020
              if wideDirectoryExists(scanpath) then begin
                Fmain.Scandirectory(scanpath,'*.*',2,true);
              end;

          end
          else
            if already=False then begin //BUGFIXED ONLY DO THIS ONE TIME
              for y:=0 to stdropfolders.Count-1 do
                if wideDirectoryExists(stdropfolders.Strings[y]) then
                  Fmain.Scandirectory(stdropfolders.Strings[y],'*.*',2,true);

              //Add dropped files
              if (Fmain.ExplorerDrop2.tag=1) OR (Fmain.ExplorerDrop3.Tag=1) then
                if Fmain.ExplorerDrop3.Tag=1 then begin
                  for y:=0 to Fmain.ExplorerDrop3.FileCount-1 do begin
                    listfiles.Writeln(Fmain.ExplorerDrop3.FileNames.Strings[y]);
                    romscounter:=romscounter+1;
                  end;
                end
                else
                for y:=0 to Fmain.ExplorerDrop2.FileCount-1 do begin
                  listfiles.Writeln(Fmain.explorerdrop2.FileNames.Strings[y]);
                  romscounter:=romscounter+1;
                end;
                already:=true;

            end;

        WideSetCurrentDir(tempdirectoryresources);

        Try
          listfiles.Close;
          FreeAndNil(listfiles);
        except
        end;

      end;

      //Scanning
      if checkstop=false then begin

        restoreactionmessage;

        //0.035 SORTING METHOD
        sortfiles:=TTntStringList.Create;
        sortfiles.Duplicates:=dupIgnore;
        sortfiles.LoadFromFile(filelistpath);
        sortfiles.sort;
        sortfiles.SaveToFile(filelistpath);
        freeandnil(sortfiles);

        listfiles:=TGpTextFile.Createw(filelistpath);
        listfiles.Reset;

        if romscounter>0 then //0.027
          ProgressBar2.Max:=romscounter-1;
                                  
        for y:=0 to romscounter-1 do begin

          if checkstop=true then
            break;

          s:=listfiles.Readln;

          setsposition:=y;

          try
            processrom(s);
          except  //IF FAILS
              restoreactionmessage;

              Fmain.closepossiblyopenzip;//0.028

              If FileInUse(s)=true then begin
                preparelogline(2,5,1,traduction(180),s);
                BMDThread1.Thread.Synchronize(addlogline);
              end
              else begin
                if FileExists2(s)=true then begin //0.030 IF NOT EXISTS NO ERROR THEN DELETED OR PROCESSED
                  preparelogline(3,4,1,traduction(181),s);
                  BMDThread1.Thread.Synchronize(addlogline);
                end;
              end;

          end;

        end;//CHECKSTOP

      end;//SCAN PATH

    end;//TREEVIEW PATHES

    try
      listfiles.Close;
      FreeAndNil(listfiles);
    except
    end;

    try
      deletefile2(filelistpath);
    except
    end;

    setsposition:=0;
    zipcount:=0;

    currentset:=''; //FIX FINISH

  end;

end;

setsposition:=0;
zipcount:=0;
currentset:='';

try
  listfiles.Close;
  FreeAndNil(listfiles);
except
end;


if stop=true then begin //Backup cachefile to stsimplehash autodelete dupes and save to file again
  try
    cachefile.Writeln(checksumtobool(md5checked,sha1checked));
    cachefile.Reset;

    while not cachefile.EOF do
      stsimplehash.Add(cachefile.Readln);

    cachefile.Close;
    stsimplehash.SaveToFile(tempdirectorycache+'cache');
  except
  end;
end
else
  try
    //SAVE CHECKSUM OPTIONS
    cachefile.Writeln(checksumtobool(md5checked,sha1checked));
    cachefile.Close;
  except
  end;

//CACHE 0.029
stsimplehash.Clear;
FreeAndNil(cachefile);
Fmain.compresscache(tempdirectorycache+Fmain.getdbid+'-'+inttohex(strtoint64(scanprofileid),8));

//CACHE REBUILD 0.043
stsimplehashreb.Clear;
if isrebuild=true then
  cachefilereb.Writeln('00');//CORRECT END FLAG

Freeandnil(cachefilereb);

deletefile2(filelistpath);

fixdecision:=0;//NEEDED FOR CORRECT
deletenobackupdecision:=2;//NEEDED FOR CORRECT
chddecision:=2;//NEEDED FOR CORRECT

if haschds=false then //FIX
  chddecision:=-1;

//CHECK DUPES AND BADDUMPS
clearrecords;

//SPEED HACK  NEEDS A HAVE FALSE AND A HAVE TRUE AS MINIMUM
                               //IN BATCH REMOVED???
if (scantoo=true) then //SKIPS BADDUMP DUPES CHECK  //AND (Datamodule1.Tscanroms.Locate('Have',true,[])) REMOVED FOR BADDUMPS
if (checkstop=false) AND (Datamodule1.Tscanroms.Locate('Have',false,[]))  then begin

  isdupebaddump:=true;
  restoreactionmessage;

  Datamodule1.Qdupes.close;
  Datamodule1.Qdupes.sql.clear;
  Datamodule1.Qdupes.sql.add('SELECT *');
  Datamodule1.Qdupes.sql.add('FROM Z'+scanprofileid);
  Datamodule1.Qdupes.SQL.Add('WHERE (Type<>1)'); //NO MAKE BADDUMPS FOR SAMPLES 1
                                          //CHANGE TO CREATE SAMPLES AS BADDUMPS
  //CHECK THIS
  if allowmerge=false then
    Datamodule1.Qdupes.SQL.Add('AND Merge = false');
  if allowdupe=false then
    Datamodule1.Qdupes.SQL.Add('AND Dupe = false');

  Datamodule1.Qdupes.SQL.Add('ORDER BY CRC,MD5,SHA1,have DESC');

  //question(Datamodule1.Qdupes.sql.text,20);

  Datamodule1.Qdupes.Open;

  if checkstop=false then
  if Datamodule1.Qdupes.Locate('Have',false,[]) then begin  //Now locate if have=false exists if not then skip process

    Datamodule1.Qdupes.prior;

    //WRONG % CALCULATION???
    setsposition:=0;
    progressbar2.Max:=Datamodule1.Qdupes.RecordCount;

    setsposition:=Datamodule1.Qdupes.RecNo-1;

    if checkstop=false then
    While Datamodule1.Qdupes.eof=false do begin
                                   //Romname
      if Datamodule1.Qdupes.fields[1].AsString[length(Datamodule1.Qdupes.fields[1].asstring)]<>'\' then begin

        currentset:='';
                                    //Have
        If Datamodule1.Qdupes.Fields[9].AsBoolean=true then begin
                                      //Space                                    //CRC
          s:=Datamodule1.Qdupes.fields[2].asstring+'-'+Datamodule1.Qdupes.fields[3].asstring+'-';

          if isoff=false then begin
            s:=s+Datamodule1.Qdupes.fields[4].asstring+'-'; //MD5
            s:=s+Datamodule1.Qdupes.fields[5].asstring+'-'; //SHA1
          end
          else
            s:=s+'--';

          n:=Datamodule1.Qdupes.fields[0].AsInteger; //ID
        end
        else begin
          dummypass:=false;

          s2:=Datamodule1.Qdupes.fields[2].asstring+'-'+Datamodule1.Qdupes.fields[3].asstring+'-';

          if isoff=false then begin
            //BADDUMP MD5 DETECTION 0.017
            //0.032 FORZE ZERO BYTES CREATION BAD DUMP
            if ('D41D8CD98F00B204E9800998ECF8427E'=Datamodule1.Qdupes.fields[4].asstring) AND (Datamodule1.Qdupes.fields[2].asstring='0') then
              s2:=s2+'-'
            else
            if '00000000000000000000000000000000'=Datamodule1.Qdupes.fields[4].asstring then
              s2:=s2+'-'
            else
              s2:=s2+Datamodule1.Qdupes.fields[4].asstring+'-';

            //0.032 FORZE ZERO BYTES CREATION BAD DUMP
            if ('DA39A3EE5E6B4B0D3255BFEF95601890AFD80709'=Datamodule1.Qdupes.fields[5].asstring) AND (Datamodule1.Qdupes.fields[2].asstring='0') then
              s2:=s2+'-'
            else
            if '0000000000000000000000000000000000000000'=Datamodule1.Qdupes.fields[5].asstring then
              s2:=s2+'-'
            else
              s2:=s2+Datamodule1.Qdupes.fields[5].asstring+'-'

          end
          else
            s2:=s2+'--';

          //POSSIBLE BAD DUMPS
          if (gettokencount(s2,'----')=2) OR (gettokencount(s2,'-FFFFFFFF---')=2) OR (gettokencount(s2,'-00000000---')=2) then  //BAD DUMP
            dummypass:=true;

          if (s=s2) OR (dummypass=true) then begin //DUPE HAVE FOUND

            //FIND ORIGINAL IN TROMS TSETS
            n2:=Datamodule1.Qdupes.fields[0].asinteger;
            aux:='';


            // ROM HAVE FALSE NOW GETTING DESTINATION
            if dummypass=false then begin //HAVE ROM POSSITION

              Datamodule1.Tscanroms.locate('ID',Datamodule1.Qdupes.fields[0].asinteger,[]);

              if (allowmerge=false) AND (allowdupe=false) then //SAMEFILE
                Datamodule1.Tscansets.locate('ID',Datamodule1.Tscanroms.fields[8].asinteger,[]) //Setnamemaster
              else
                Datamodule1.Tscansets.locate('ID',Datamodule1.Tscanroms.fields[7].asinteger,[]); //Setname
                                                  //type
              croms:=Datamodule1.Tscanroms.Fields[6].asinteger; //Type obtained

              dupecomp:=0;
              dupepath:='';

              if croms=0 then begin//1 SAMPLES IGNORED
                dupepath:=romspath;
                dupecomp:=romscomp;
              end
              else
              if croms=2 then begin
                dupepath:=chdspath;
                dupecomp:=chdscomp;
              end
              else
              if croms=1 then begin
                dupepath:=samplespath;
                dupecomp:=samplescomp;
              end;

              case dupecomp of
              0:begin
                originfile:=dupepath+getwiderecord(Datamodule1.Tscansets.fields[2])+'\'+getwiderecord(Datamodule1.Tscanroms.fields[1]);
                origincomp:='';
              end;
              1:begin
                originfile:=dupepath+getwiderecord(Datamodule1.Tscansets.fields[2])+'.zip';
                origincomp:=' > '+getwiderecord(Datamodule1.Tscanroms.fields[1]);
              end;
              2:begin
                originfile:=dupepath+getwiderecord(Datamodule1.Tscansets.fields[2])+'.rar';
                origincomp:=' > '+getwiderecord(Datamodule1.Tscanroms.fields[1]);
              end;
              3:begin
              originfile:=dupepath+getwiderecord(Datamodule1.Tscansets.fields[2])+'.7z';
                origincomp:=' > '+getwiderecord(Datamodule1.Tscanroms.fields[1]);
              end;
              end;

              aux:=originfile+origincomp; //DESTINATION PATH

              Datamodule1.Tscanroms.locate('ID',n,[])
            end
            else
              Datamodule1.Tscanroms.locate('ID',n2,[]);

            croms:=Datamodule1.Tscanroms.Fields[6].asinteger; //Type obtained
            originfile:='';

            //NEEDS SET NAME FILEMODECHECK
            if (allowmerge=false) AND (allowdupe=false) then //SAMEFILE
              Datamodule1.Tscansets.locate('ID',Datamodule1.Tscanroms.fields[8].asinteger,[])
            else
              Datamodule1.Tscansets.locate('ID',Datamodule1.Tscanroms.fields[7].asinteger,[]);

            dupecomp:=0;
            dupepath:='';

            if croms=0 then begin//1 SAMPLES IGNORED
              dupepath:=romspath;
              dupecomp:=romscomp;
            end
            else
            if croms=2 then begin
              dupepath:=chdspath;
              dupecomp:=chdscomp;
            end
            else
            if croms=1 then begin
              dupepath:=samplespath;
              dupecomp:=samplescomp;
            end;

            s2:='';

            case dupecomp of
              0:begin
                originfile:=dupepath+getwiderecord(Datamodule1.Tscansets.fields[2])+'\'+getwiderecord(Datamodule1.Tscanroms.fields[1]);
                origincomp:='';
              end;
              1:begin
                originfile:=dupepath+getwiderecord(Datamodule1.Tscansets.fields[2])+'.zip';
                origincomp:=' > '+getwiderecord(Datamodule1.Tscanroms.fields[1]);
              end;
              2:begin
                originfile:=dupepath+getwiderecord(Datamodule1.Tscansets.fields[2])+'.rar';
                origincomp:=' > '+getwiderecord(Datamodule1.Tscanroms.fields[1]);
              end;
              3:begin
                originfile:=dupepath+getwiderecord(Datamodule1.Tscansets.fields[2])+'.7z';
                origincomp:=' > '+getwiderecord(Datamodule1.Tscanroms.fields[1]);
              end;
            end;

            if dummypass=true then begin

              if (baddumpdecision<>-1) AND (baddumpdecision<>2) then
                question(traduction(421)+#10#13+traduction(422)+#10#13+originfile+origincomp,2);//s+origincomp

              if (baddumpdecision=1) OR (baddumpdecision=2) then begin
                s2:=tempdirectoryextract+'baddump';             //Space
                if createdummyfile(s2,Datamodule1.Qdupes.fields[2].AsInteger)=False then
                  s2:='';
              end
              else begin //SKIP LOG          //Type
                if Datamodule1.Qdupes.Fields[6].asinteger=2 then //CHD BADDUMP
                  preparelogline(2,20,1,traduction(420),originfile+origincomp)
                else
                  preparelogline(2,19,1,traduction(420),originfile+origincomp);//s+origincomp

                BMDThread1.Thread.Synchronize(addlogline);
              end;

            end
            else begin

              if (dupedecision<>-1) AND (dupedecision<>2) then
                question(traduction(423)+#10#13+originfile+origincomp+#10#13+traduction(424)+#10#13+aux,6);

              if (dupedecision=0) OR (dupedecision=-1) then begin
                preparelogline(2,18,1,traduction(423),originfile+origincomp+#10#13+' '+traduction(424)+' '+aux);
                BMDThread1.Thread.Synchronize(addlogline);
              end
              else
              case dupecomp of
              0:begin //UNCOMPRESS

                s2:=tempdirectoryextract+WideExtractfilename(originfile);

                currentset:=originfile;//Thread info

                if CopyFile2(originfile,s2)=false then //FAILS COPY
                  s2:='';

              end;
              1:begin //ZIP

                currentset:=originfile;//Thread info

                if Fmain.zipvalidfile(originfile,Fmain.Zip1) then                                  //Romname
                  if Fmain.extractfilefromzip(Fmain.zip1,Getwiderecord(Datamodule1.Tscanroms.fields[1]),tempdirectoryextract,true) then begin
                    s2:=tempdirectoryextract+WideExtractfilename(Getwiderecord(Datamodule1.Tscanroms.fields[1])); //Romname
                    Fmain.closepossiblyopenzip;//0.037 FIX WHEN TRY TO INSERT DUPES IN CURRENT SET
                  end;

              end;
              2:begin //RAR

                currentset:=originfile;//Thread info

                if Fmain.rarvalidfile(originfile,Fmain.rar1) then
                  if Fmain.extractfilefromrar(Fmain.rar1,Getwiderecord(Datamodule1.Tscanroms.fields[1]),tempdirectoryextract,true) then begin
                    s2:=tempdirectoryextract+WideExtractfilename(Getwiderecord(Datamodule1.Tscanroms.fields[1]));
                  end;

              end;
              3:begin //7Z

                currentset:=originfile;//Thread info

                if Fmain.sevenzipvalidfile(originfile,Fmain.SevenZip1) then
                  if Fmain.extractfilefromsevenzip(Fmain.SevenZip1,Getwiderecord(Datamodule1.Tscanroms.fields[1]),tempdirectoryextract,true) then begin
                    s2:=tempdirectoryextract+WideExtractfilename(Getwiderecord(Datamodule1.Tscanroms.fields[1]));
                  end;
                              
              end;
              end;

            end;//ELSE

            if FileExists2(s2) then begin  //EN REBUILD CUANDO RENOMBRA ANTES DE COMPRIMIR BORRA EL ANTERIOR QUE ES EL MISMO NOMBRE

              try
                rebuildfile(s2,0,1,'',n2,origincomp);
              except

              end;

              deletefile2(s2);

            end; //ELSE FAILED

          end;

        end; //ELSE HAVE FALSE

        If checkstop=true then
          break;

      end;//Romname is path

      if setsposition<progressbar2.Max then //0.030 Wrong percent fix
        setsposition:=setsposition+1;

      Datamodule1.Qdupes.Next;

    end;//LOOP QDUPES
  end;  //LOCATE

end;//IF

Datamodule1.Qdupes.close;

//RELEASE POSSIBLE LOCKED FILES 0.028
Fmain.closepossiblyopenzip;

try
  Fmain.Zip2.CloseArchive;
finally
  Fmain.Zip2.Tag:=0;
end;

try
  WideSetCurrentDir(tempdirectoryresources);
except
end;

//FREE HASHES FROM MEMORY
for x:=0 to reccrcs.Count-1 do
  TObject(reccrcs[x]).Free;

reccrcs.Clear;

for x:=0 to recmd5s.Count-1 do
  TObject(recmd5s[x]).Free;

recmd5s.Clear;

for x:=0 to recsha1s.Count-1 do
  TObject(recsha1s[x]).Free;

recsha1s.Clear;

setsposition:=0;
currentset:='';
sleep(50);

//Apply results
BMDThread1.Thread.Synchronize(disablecancelbutton);

if (checkstop=false)then begin

  if hascompressed=true then begin
    if (checkbox5.checked=true) OR (checkbox1.Checked=true) then begin
      preparelogline(2,-1,1,traduction(374),'');  
      BMDThread1.Thread.Synchronize(addlogline);
    end;
  end
  else begin

    if checkbox5.Checked=true then begin//Torrentzip

      other:=traduction(61)+' : '+traduction(205);
      BMDThread1.Thread.Synchronize(syncstatus);
      for x:=0 to lastpathes.Count-1 do begin
        s:=checkpathbar(lastpathes.Strings[x]);
        s:=copy(s,1,length(s)-1); //Delete barpath else torrentzip dont work
        RunAndWaitShell('"'+Ansitoutf8(torrentzippath)+'"','"'+UTF8Encode(s)+'"',1,false,false);
      end;
    end;

    if checkbox1.Checked=true then begin

      other:=traduction(61)+' : '+traduction(367);  //T7Z
      BMDThread1.Thread.Synchronize(syncstatus);
      decision:=2;

      for x:=0 to lastpathes.Count-1 do begin  //Make list
        s:=checkpathbar(lastpathes.Strings[x]);
        writelist.Clear; //0.037 Save from stringlist to file to force UTF8

        if WideDirectoryexists(s) then
          Fmain.scandirectory(s,'*.7z',3,true);

        try
          writelist.SaveToFile(filelistpath);
        except
        end;

        writelist.Clear;

        //question('"'+UTF8Encode(torrent7zippath)+'"'+' '+'-aos -bd -o --log"'+UTF8Encode(tempdirectoryresources+'t7z.log')+'" "@'+UTF8Encode(filelistpath)+'"',10);

        RunAndWaitShell('"'+Ansitoutf8(torrent7zippath)+'"','-aos -bd -o --log"'+Ansitoutf8(tempdirectoryresources+'t7z.log')+'" "@'+UTF8Encode(filelistpath)+'"',1,false,false);
        //t7z -aos -bd -o "@C:\list.txt"

      end;

    end;

  end;

end;

deletefile2(filelistpath);

other:=traduction(61)+' : '+traduction(245);
BMDThread1.Thread.Synchronize(syncstatus);

Datamodule1.Tprofiles.Locate('ID',strtoint(scanprofileid),[]);

filelistpath:=getcounterfilemode(Datamodule1.Tscansets.TableName,Datamodule1.Tscanroms.tablename,Datamodule1.Tprofiles.fieldbyname('Filemode').AsInteger,false);

csets:=strtoint(gettoken(filelistpath,'/',1));
croms:=strtoint(gettoken(filelistpath,'/',3));

Datamodule1.Tprofiles.edit;
Datamodule1.Tprofiles.FieldByName('Havesets').asinteger:=csets;
Datamodule1.Tprofiles.FieldByName('Haveroms').asinteger:=croms;
Datamodule1.Tprofiles.FieldByName('Totalsets').asinteger:=strtoint(gettoken(filelistpath,'/',2));
Datamodule1.Tprofiles.FieldByName('Totalroms').asinteger:=strtoint(gettoken(filelistpath,'/',4));
Datamodule1.Tprofiles.FieldByName('Lastscan').AsDateTime:=now;
Datamodule1.Tprofiles.post;

if Datamodule1.DBDatabase.InTransaction=true then
  Datamodule1.DBDatabase.Commit(true);

Datamodule1.Tscansets.Close;
Datamodule1.Tscanroms.Close;

Fmain.initializeextractionfolders;

if isrebuild=false then begin
  if stop=false then begin
    preparelogline(0,-1,0,traduction(176)+' - '+datetimetostr(Datamodule1.Tprofiles.FieldByName('Lastscan').AsDateTime)+' '+panel4.caption,edit2.text);
    BMDThread1.Thread.Synchronize(addlogline);
  end
  else begin
    preparelogline(0,-1,0,traduction(179)+' - '+datetimetostr(Datamodule1.Tprofiles.FieldByName('Lastscan').AsDateTime)+' '+panel4.caption,edit2.text);
    BMDThread1.Thread.Synchronize(addlogline);
  end;
end
else
  if stop=false then begin
    preparelogline(0,-1,0,traduction(195)+' - '+datetimetostr(Datamodule1.Tprofiles.FieldByName('Lastscan').AsDateTime),edit2.text);
    BMDThread1.Thread.Synchronize(addlogline);
  end
  else begin
    preparelogline(0,-1,0,traduction(196)+' - '+datetimetostr(Datamodule1.Tprofiles.FieldByName('Lastscan').AsDateTime),edit2.text);
    BMDThread1.Thread.Synchronize(addlogline);
  end;

lastpathes.Free;
clearrecords;

other:=traduction(61)+' : '+traduction(62);
BMDThread1.Thread.Synchronize(syncstatus);
                              
Thread.Terminate;
end;

procedure TFscan.BMDThread1Start(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
warningntfs:boolean;
begin
onathread:=true;

Fmain.initializeprogresslabel(tntlabel1);
Fmain.initializeprogresslabel(tntlabel2);

if Fscan.Tag=0 then
  Fmain.taskbaractive(true);

lastcompfile2:='';//FIX 0.043
lastcompdate2:=-1;//FIX 0.043
warningntfs:=false;
isdupebaddump:=false;
sortedhashes:=false;
bitbtn2.tag:=1;
disablesysmenu(Fscan,false);
Flog.SpeedButton2.enabled:=false;

if isrebuild=false then begin
  preparelogline(0,-1,0,traduction(175)+' - '+datetimetostr(now)+' '+panel4.caption,edit2.text);
  addlogline(Fscan);
end
else begin
  preparelogline(0,-1,0,traduction(194)+' - '+datetimetostr(now)+' '+panel4.caption,edit2.text);
  addlogline(Fscan);
  if scantoo=false then begin
    preparelogline(2,6,1,traduction(554),'');
    addlogline(Fscan);
  end;
end;

//NTFS CHECK

if WideDirectoryExists(romspath) then
  if IsNTFS(romspath)=false then
    warningntfs:=true;

if WideDirectoryExists(samplespath) then
  if IsNTFS(samplespath)=false then
    warningntfs:=true;

if WideDirectoryexists(chdspath) then
  if IsNTFS(chdspath)=false then
    warningntfs:=true;

if warningntfs=true then begin
  preparelogline(2,10,1,traduction(503),'');
  addlogline(Fscan);
end;

romspath:=checkpathcase(romspath);
samplespath:=checkpathcase(samplespath);
chdspath:=checkpathcase(chdspath);

BitBtn3.Enabled:=false;

disableforscan(true);

currentset:='';
BMDThread1.Tag:=0;
romscounter:=0;
setsposition:=0;

stopdecision:=-1;

//Batch mode reset???
fixdecision:=0;
deletenobackupdecision:=0;
renamedecision:=0;
extensiondecision:=0;
baddumpdecision:=0;
dupedecision:=0;
chddecision:=0;

//ASKMOD
if Fask.checkbox2.Checked then
  fixdecision:=2
else
if Fask.CheckBox3.Checked then
  fixdecision:=-1;

if Fask.checkbox5.Checked then
  deletenobackupdecision:=2
else
if Fask.CheckBox6.Checked then
  deletenobackupdecision:=-1;

if Fask.checkbox8.Checked then
  renamedecision:=2
else
if Fask.CheckBox9.Checked then
  renamedecision:=-1;

if Fask.checkbox11.Checked then
  extensiondecision:=2
else
if Fask.CheckBox12.Checked then
  extensiondecision:=-1;

if Fask.checkbox14.Checked then
  baddumpdecision:=2
else
if Fask.CheckBox15.Checked then
  baddumpdecision:=-1;

if Fask.checkbox17.Checked then
  dupedecision:=2
else
if Fask.CheckBox18.Checked then
  dupedecision:=-1;

if Fask.checkbox20.Checked then
  chddecision:=2
else
if Fask.CheckBox21.Checked then
  chddecision:=-1;

if haschds=false then //FIX
  chddecision:=-1;

if hasroms=false then begin
  hasroms:=true;//FIX PROBLEMS WITH ONLY CHDS in PROFILE 0.040
  if haschds=true then
    chddecision:=2;//0.040 FORZED
end;

sterrors.Clear;

Datamodule1.DBHeaders.Close;
end;

procedure TFscan.BitBtn2Click(Sender: TObject);
begin
stop:=true;
bitbtn2.Caption:=traduction(339);
bitbtn2.Enabled:=false;
end;

procedure TFscan.FormClose(Sender: TObject; var Action: TCloseAction);
begin

oldscanleft:=Fscan.Left;
oldscantop:=Fscan.Top;

Fmain.addtoactiveform((sender as Tform),false);

savechecked;

DataModule1.Tscansets.Close;
Datamodule1.Tscanroms.close;
Datamodule1.Tinvertedcrc.close;
Datamodule1.DBHeaders.Close;
end;

procedure TFscan.SpeedButton2Click(Sender: TObject);
var
fold,title,path:widestring;
n:TTnttreenode;
begin
Flog.enabled:=false;

fold:=folderdialoginitialdircheck(initialdirroms);

n:=Treeview1.Selected;

if n=nil then
  exit;

if WideDirectoryExists(n.text) then
  fold:=n.text;

case n.ImageIndex of
  0:title:=traduction(160)+' :';
  1:title:=traduction(161)+' :';
  2:title:=traduction(162)+' :';
end;

Fmain.positiondialogstart;

//if Fmain.displayfolderdialog(fold,title) then begin
if WideSelectDirectory(title,'',fold) then begin
  fold:=checkpathbar(fold);
  //fold:=dialoglist.Strings[0];

  initialdirroms:=fold;
  treeview1.Items.BeginUpdate;

  path:=fold;

  n.text:=path;

  if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(scanprofileid),n.ImageIndex]),[])=true then
    Datamodule1.TDirectories.Edit
  else begin
    Datamodule1.TDirectories.insert;
    Datamodule1.TDirectories.Fieldbyname('Compression').asinteger:=Integer( TreeView1.Items[n.index].Data );
  end;

  Datamodule1.TDirectories.FieldByName('Profile').asinteger:=strtoint(scanprofileid);
  setwiderecord(Datamodule1.TDirectories.FieldByName('Path'),path);
  Datamodule1.TDirectories.Fieldbyname('Type').asstring:=inttostr(n.imageindex);


  Datamodule1.TDirectories.post;
  treeview1.Items.Endupdate;

end;

Flog.enabled:=true;
end;

procedure TFscan.TreeView2DblClick(Sender: TObject);
begin
SpeedButton2Click(sender);
end;

procedure TFscan.TreeView1DblClick(Sender: TObject);
begin
if BitBtn1.Enabled=true then
  SpeedButton2Click(sender);
end;

procedure TFscan.SpeedButton6Click(Sender: TObject);
var
n:TTnttreenode;
begin

n:=Treeview1.Selected;

if n=nil then
  exit;

if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(scanprofileid),n.ImageIndex]),[])=true then
  Datamodule1.TDirectories.Edit
else begin
  Datamodule1.TDirectories.insert;
  Datamodule1.TDirectories.Fieldbyname('Compression').asinteger:=Integer( TreeView1.Items[n.index].Data );
end;

Datamodule1.TDirectories.FieldByName('Profile').asinteger:=strtoint(scanprofileid);
setwiderecord(Datamodule1.TDirectories.FieldByName('Path'),'');
Datamodule1.TDirectories.Fieldbyname('Type').asstring:=inttostr(n.imageindex);

Datamodule1.TDirectories.post;

n.Text:='';

treeview1.Items.Endupdate;
end;

procedure TFscan.SpeedButton1Click(Sender: TObject);
var
fold:widestring;
begin
Flog.Enabled:=false;

if WideDirectoryExists(edit1.Text) then
  fold:=edit1.Text
else
  fold:=GetDesktopFolder;

fold:=checkpathbar(fold);

Fmain.positiondialogstart;

if WideSelectDirectory(label5.Caption,'',fold) then begin
  fold:=checkpathbar(fold);

  if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(scanprofileid),'B']),[])=true then
    Datamodule1.TDirectories.Edit
  else
    Datamodule1.TDirectories.insert;

  Datamodule1.TDirectories.FieldByName('Profile').asinteger:=strtoint(scanprofileid);
  setwiderecord(Datamodule1.TDirectories.FieldByName('Path'),fold);
  Datamodule1.TDirectories.Fieldbyname('Compression').asinteger:=0;
  Datamodule1.TDirectories.Fieldbyname('Type').asstring:='B';

  Datamodule1.TDirectories.post;

  edit1.Text:=checkpathbar(fold);

end;
Flog.Enabled:=true;
end;


procedure TFscan.BMDThread1Terminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
insideposition:=0;

Fmain.initializeprogresslabel(tntlabel1);
Fmain.initializeprogresslabel(tntlabel2);

romspath:='';
samplespath:='';
chdspath:='';
backuppath:='';

onathread:=false;
application.processmessages;

if isrebuildbatch=false then
  stdropfolders.clear;

if Fscan.Tag=0 then //Batch fix
  Fmain.showprofiles(false);

Fmain.showprolesmasterdetail(true,true,scanprofileid,false,false);

Fmain.showprolesmasterdetail(false,false,Fmain.getcurrentprofileid,false,false);

try
  Fmain.Enabled:=false;//FIX
except
end;

ChDir(tempdirectoryresources);//Fix no removable folder


flog.SpeedButton2.Enabled:=true;
Datamodule1.DBHeaders.Close;

bitbtn2.Caption:=traduction(143);

disablesysmenu(Fscan,true);

label8.Caption:=traduction(61)+' : '+traduction(147);

panel1.Enabled:=true;//NEEDED TO CAN CLOSE

if Fscan.Tag=1 then begin//Batch fix
  Timer1Timer(sender);
end
else begin
  Fmain.taskbaractive(false);
  disableforscan(false);
  //END OF SINGLE SCAN REBUILD
  shutdownorhibernate;
end;

isdupebaddump:=false;
end;

procedure TFscan.BMDThread1Update(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer; Percent: Integer);
begin
BMDThread1.UpdateEnabled:=false;

try
  panel2.caption:=changein(WideExtractfilename(currentset),'&','&&');
except
end;

try
  ProgressBar1.max:=zipcount;
  ProgressBar1.Position:=insideposition;
  tntlabel1.caption:=checknan(FormatFloat('0.00',(insideposition*100) / Progressbar1.max)+' %');
except
end;

try
  ProgressBar2.Position:=setsposition;
  tntlabel2.caption:=checknan(FormatFloat('0.00',(setsposition*100) / Progressbar2.max)+' %');
except
end;

if decision=-2 then begin //Show sended messages

  decision:=mymessagequestion(sterrors.Text,allbuttons);

  sterrors.Clear;

  if decision=0 then begin
    bitbtn2.Enabled:=true;
    bitbtn2.Caption:=traduction(143);
  end;

end;

BMDThread1.UpdateEnabled:=true;
end;

procedure TFscan.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
canclose:=panel1.Enabled;

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

procedure TFscan.SpeedButton3Click(Sender: TObject);
begin
if speedbutton3.Down then begin
  myshowform(Flog,false);
end
else begin
  Flog.close;
end;

end;

procedure TFscan.TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
node: TTntTreenode;
begin
node := TreeView1.GetNodeAt(MousePos.X, MousePos.Y); // Tries to get node
if (node <> nil) then TreeView1.Selected := node; // Pass selection to tree

end;

procedure TFscan.SpeedButton4Click(Sender: TObject);
var
p:TPoint;
begin
//if SpeedButton4.Down then begin
  GetCursorPos(p);
  PopupMenu1.Popup(p.X,p.Y);
//  application.processmessages;
//  SpeedButton4.Down := False;
//end;

end;

procedure TFscan.Folder1Click(Sender: TObject);
begin
setcompression(Sender);
end;

procedure TFscan.BitBtn3Click(Sender: TObject);
begin
stop:=true;
if Fscan.Tag=1 then
  timer1.enabled:=true
else
  close;
end;

procedure TFscan.FormDestroy(Sender: TObject);
begin
deletelist.Free;
deleteheaderlist.Free;
batchlist.Clear;
Datamodule1.Qdupes.close;
Freeandnil(Fask);
oldscanleft:=-1;
oldscantop:=-1;
end;

procedure TFscan.ComboBox1Change(Sender: TObject);
var
res:ansistring;
toset:boolean;
begin
if combobox1.ItemIndex=combobox1.Tag then
  exit;

toset:=false;

if combobox1.ItemIndex=0 then begin
  if mymessagequestion(traduction(378)+#10#13+traduction(376),false)=1 then begin
    toset:=true;
    res:='';
  end;
end
else
if mymessagequestion(traduction(375)+#10#13+combobox1.items.Strings[ComboBox1.itemindex]+#10#13+traduction(376),false)=1 then begin
  toset:=true;
  res:=combobox1.items.Strings[ComboBox1.itemindex];
end;

if toset=false then
  combobox1.ItemIndex:=combobox1.Tag
else begin
  combobox1.Tag:=combobox1.ItemIndex;
  Datamodule1.Tprofiles.Edit;
  Datamodule1.Tprofiles.FieldByName('Header').asstring:=res;
  Datamodule1.Tprofiles.Post;
end;

end;

procedure TFscan.SpeedButton5Click(Sender: TObject);
var
p:TPoint;
begin
//if SpeedButton5.Down then
//begin
GetCursorPos(p);
PopupMenu2.Popup(p.X,p.Y);
//application.processmessages;
//SpeedButton5.Down := False;
//end;

end;

procedure TFscan.Custom1Click(Sender: TObject);
begin
myshowform(Fask,true);

if Fask.BitBtn1.Tag=1 then begin
  askstatoimage;
  statosave;
end
else
  statoload;

end;

procedure TFscan.Alwaysask1Click(Sender: TObject);
begin
Fask.markradios(0);
askstatoimage;
statosave;
end;

procedure TFscan.Decideyestoall1Click(Sender: TObject);
begin
Fask.markradios(1);
askstatoimage;
statosave;
end;

procedure TFscan.Decidenotoall1Click(Sender: TObject);
begin
Fask.markradios(2);
askstatoimage;
statosave;
end;

procedure TFscan.SpeedButton7Click(Sender: TObject);
begin
edit1.Text:=defbackuppath;

if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(scanprofileid),'B']),[])=true then
  Datamodule1.TDirectories.Delete
{else
  Datamodule1.TDirectories.insert;

Datamodule1.TDirectories.FieldByName('Profile').asinteger:=strtoint(scanprofileid);
Datamodule1.TDirectories.FieldByName('Path').asstring:=edit1.text;
Datamodule1.TDirectories.Fieldbyname('Compression').asinteger:=0;
Datamodule1.TDirectories.Fieldbyname('Type').asstring:='B';

Datamodule1.TDirectories.post;  }

end;

procedure TFscan.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);

//fixtreeviewfocus;//FIX TREEVIEW SELECTION AND ROLLBACK TO THE DEFAULT FOCUS BUTTON

//if formexists('Fmessage') then begin //RARE NON MODAL BUG FIX
//  Fmessage.BringToFront;
//end;

end;

procedure TFscan.Timer1Timer(Sender: TObject);
var
continue:boolean;
begin
timer1.enabled:=false;

if image322.Tag>batchlist.Count-1 then begin//BATCH END
  shutdownorhibernate;
  close;
end
else begin
  continue:=true;
  //STOP QUESTION
  if stop=true then
    if mymessagequestion(traduction(167),false)=1 then
      continue:=false;

  if continue=true then begin
    
    if image322.tag<>0 then begin//ALREADY LOADED

      //SECURITY CLOSE
      Datamodule1.Tscansets.close;
      Datamodule1.Tscanroms.close;
      Datamodule1.Tinvertedcrc.close;
      Datamodule1.DBHeaders.Close;


      loadprofile(batchlist.Strings[image322.tag]);

      fixtreeviewfocus;

      Fscan.panel4.Caption:=traduction(166)+' '+inttostr(image322.tag+1)+' / '+inttostr(batchlist.Count);


    end;

    image322.tag:=image322.tag+1;

    BitBtn1Click(sender);
  end
  else begin
    close;
  end;

end;

end;

procedure TFscan.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  if bitbtn3.Enabled=true then begin
    close;
  end;
end;

procedure TFscan.SpeedButton8Click(Sender: TObject);
begin
if speedbutton8.down=true then
  showmessage('Cache falseada activa');
end;

procedure TFscan.TntSpeedButton1Click(Sender: TObject);
var
p:TPoint;
begin
GetCursorPos(p);
PopupMenu3.Popup(p.X,p.Y);
end;

procedure TFscan.Donothing1Click(Sender: TObject);
begin
Fask.endtoimage(0);
end;

procedure TFscan.Sleeponterminte1Click(Sender: TObject);
begin
Fask.endtoimage(1);
end;

procedure TFscan.Shutdownonterminate1Click(Sender: TObject);
begin
Fask.endtoimage(2);
end;

end.



