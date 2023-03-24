unit Userver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, OleCtrls, SHDocVw, Activex, Math, ImgList, ComCtrls,
  StdCtrls, ABSMain, DB, GR32_Image, Strings, Udataserver, BMDThread,
  fsptaskbarmgr, Winsock, CoolTrayIcon, shellapi,CommCtrl, Themes, Menus, Tntforms,
  TntExtCtrls, TntComCtrls, TntButtons, TntStdCtrls, TntMenus, Tntsysutils,
  VirtualTrees, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPServer, IdTCPConnection, IdTCPClient,
  IdServerIOHandler, IdServerIOHandlerSocket, IdIOHandler,
  IdIOHandlerSocket,Uencrypt, RxRichEd, XPMenu, Gphugef, Gauges,
  IdIOHandlerThrottle, IdThreadMgr, IdThreadMgrDefault, TntDialogs, Tntclasses,
  IdIOHandlerStream,TntClipBrd, AppEvnts,SyncObjs;

type
//---------------------------------------------------------
  Ttransfers = class
    private
      // The data fields of this new class
      Aid: string;
      Afilename   : widestring;
      Atotalsize : int64;
      Adownsize : int64;
      Aspeed : int64;
      Apbar : TGauge;
      Aplabel : Ttntlabel;
      Anick   : widestring;
      Aprofilename : widestring;
      Adownsizedisp : string;
      Aspeeddisp : string;
      Atickstart : int64;
      AETA : string;
      Aolddown: int64;
    public
      // Properties to read these data values
      property id : string
          read Aid;
      property Filename : widestring
          read Afilename;
      property Downsize : int64
          read Adownsize;
      property Totalsize : int64
          read Atotalsize;
      property speed : int64
          read Aspeed;
      property Pbar : TGauge
          read Apbar;
      property Plabel : Ttntlabel
          read Aplabel;
      property Nick : Widestring
          read Anick;
      property Profilename : Widestring
          read Aprofilename;
      property Downsizedisp : string
          read Adownsizedisp;
      property Speeddisp : string
          read Aspeeddisp;
      property tickstart : int64
          read Atickstart;
      property ETA : string
          read AETA;
      property olddown : int64
          read Aolddown;
      // Constructor
      constructor Create(const Aid: string;
                         const Afilename   : widestring;
                         const Atotalsize   : int64;
                         const Adownsize   : int64;
                         const Aspeed : int64;
                         const Apbar : Tgauge;
                         const Aplabel: Ttntlabel;
                         const Anick : widestring;
                         const Aprofilename : widestring;
                         const Adownsizedisp : string;
                         const Aspeeddisp : string;
                         const Atickstart : int64;
                         const AETA : string;
                         const Aolddown : int64);
  end;

//---------------------------------------------------------
  TFserver = class(Ttntform)
    Panel1: TTntPanel;
    ImageList1: TImageList;
    Panel4: TTntPanel;
    Panel5: TTntPanel;
    Panel6: TTntPanel;
    Panel2: TTntPanel;
    Panel3: TTntPanel;
    Panel8: TTntPanel;
    Bevel1: TBevel;
    Panel9: TTntPanel;
    Bevel3: TBevel;
    SpeedButton3: TTntSpeedButton;
    ImageList2: TImageList;
    Label1: TTntLabel;
    Panel33: TTntPanel;
    Panel34: TTntPanel;
    Image323: TImage32;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Cleancompleted1: TMenuItem;
    N1: TMenuItem;
    Pauseselection1: TMenuItem;
    Resumeselection1: TMenuItem;
    Deleteselection1: TMenuItem;
    N2: TMenuItem;
    selectall1: TMenuItem;
    Invertselection1: TMenuItem;
    N3: TMenuItem;
    BMDThread1: TBMDThread;
    SpeedButton1: TTntSpeedButton;
    IdTCPServer1: TIdTCPServer;
    IdAntiFreeze1: TIdAntiFreeze;
    IdTCPClient1: TIdTCPClient;
    IdIOHandlerSocket1: TIdIOHandlerSocket;
    IdServerIOHandlerSocket1: TIdServerIOHandlerSocket;
    Timer2: TTimer;
    Imagelist3: TImageList;
    TntPopupMenu1: TPopupMenu;
    Connect1: TMenuItem;
    N4: TMenuItem;
    Delete1: TMenuItem;
    TntPopupMenu2: TPopupMenu;
    XPMenu1: TXPMenu;
    Threadsendfile: TBMDThread;
    TntLabel6: TTntLabel;
    Gauge1: TGauge;
    IdThreadMgrDefault1: TIdThreadMgrDefault;
    TntOpenDialog1: TTntOpenDialog;
    TntPopupMenu3: TPopupMenu;
    setchat1: TMenuItem;
    sendfile: TMenuItem;
    N5: TMenuItem;
    IdTCPClient2: TIdTCPClient;
    Panel7: TTntPanel;
    Panel13: TTntPanel;
    Panel14: TTntPanel;
    Panel20: TTntPanel;
    Panel11: TTntPanel;
    Panel50: TTntPanel;
    Panel15: TTntPanel;
    Panel16: TTntPanel;
    Panel40: TTntPanel;
    Panel18: TTntPanel;
    Panel19: TTntPanel;
    Bevel2: TBevel;
    Bevel9: TBevel;
    Panel22: TTntPanel;
    Image3212: TImage32;
    Panel23: TTntPanel;
    Image321: TImage32;
    Panel27: TTntPanel;
    Image322: TImage32;
    Panel28: TTntPanel;
    Panel29: TTntPanel;
    TrackBar1: TTrackBar;
    Panel10: TTntPanel;
    PageControl1: TTntPageControl;
    TntTabSheet1: TTntTabSheet;
    TntPanel1: TTntPanel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    TntSpeedButton1: TTntSpeedButton;
    TntLabel1: TTntLabel;
    TntLabel2: TTntLabel;
    TntLabel3: TTntLabel;
    TntLabel5: TTntLabel;
    TntEdit1: TTntEdit;
    TntEdit2: TTntEdit;
    TntEdit3: TTntEdit;
    TntEdit4: TTntEdit;
    TntPanel2: TTntPanel;
    VirtualStringTree3: TVirtualStringTree;
    TntTabSheet2: TTntTabSheet;
    TntPanel4: TTntPanel;
    TntSpeedButton4: TTntSpeedButton;
    TntSpeedButton6: TTntSpeedButton;
    RxRichEdit1: TRxRichEdit;
    TabSheet1: TTntTabSheet;
    Panel35: TTntPanel;
    Panel36: TTntPanel;
    VirtualStringTree4: TVirtualStringTree;
    VirtualStringTree5: TVirtualStringTree;
    TabSheet2: TTntTabSheet;
    Panel37: TTntPanel;
    Bevel5: TBevel;
    SpeedButton7: TTntSpeedButton;
    SpeedButton8: TTntSpeedButton;
    SpeedButton9: TTntSpeedButton;
    Bevel10: TBevel;
    Bevel6: TBevel;
    VirtualStringTree2: TVirtualStringTree;
    TntPanel3: TTntPanel;
    TabSheet3: TTntTabSheet;
    Panel31: TTntPanel;
    SpeedButton4: TTntSpeedButton;
    SpeedButton5: TTntSpeedButton;
    Bevel4: TBevel;
    SpeedButton6: TTntSpeedButton;
    TntSpeedButton7: TTntSpeedButton;
    Bevel11: TBevel;
    Panel32: TTntPanel;
    Panel55: TTntPanel;
    PageControl2: TTntPageControl;
    TabSheet4: TTntTabSheet;
    Panel12: TTntPanel;
    Panel17: TTntPanel;
    TntLabel4: TTntLabel;
    RxRichEdit3: TRxRichEdit;
    Panel30: TTntPanel;
    SpeedButton2: TTntSpeedButton;
    TntSpeedButton5: TTntSpeedButton;
    TabSheet5: TTntTabSheet;
    Image324: TImage32;
    TntPanel5: TTntPanel;
    N6: TMenuItem;
    Opendir1: TMenuItem;
    RxRichEdit2: TRxRichEdit;
    TntRichEdit1: TTntRichEdit;
    TntRichEdit3: TTntRichEdit;
    TntSpeedButton9: TTntSpeedButton;
    TntSpeedButton8: TTntSpeedButton;
    SpeedButton10: TSpeedButton;
    Priority1: TMenuItem;
    N7: TMenuItem;
    High1: TMenuItem;
    Normal1: TMenuItem;
    Low1: TMenuItem;
    Threadsendrequests: TBMDThread;
    Threadsendqueues: TBMDThread;
    TntSpeedButton10: TTntSpeedButton;
    TntSpeedButton11: TTntSpeedButton;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    N101: TMenuItem;
    N12: TMenuItem;
    N22: TMenuItem;
    N32: TMenuItem;
    N42: TMenuItem;
    N52: TMenuItem;
    N62: TMenuItem;
    N72: TMenuItem;
    N82: TMenuItem;
    N92: TMenuItem;
    N102: TMenuItem;
    TntPanel6: TTntPanel;
    TntPanel7: TTntPanel;
    Label12: TTntLabel;
    Label23: TTntLabel;
    Edit8: TTntEdit;
    Edit7: TTntEdit;
    Image325: TImage32;
    Image3213: TImage32;
    Panel38: TTntPanel;
    TntSpeedButton2: TTntSpeedButton;
    TntSpeedButton3: TTntSpeedButton;
    Panel39: TTntPanel;
    TntRichEdit2: TTntRichEdit;
    TntSpeedButton12: TTntSpeedButton;
    TntSpeedButton13: TTntSpeedButton;
    TntSpeedButton14: TTntSpeedButton;
    TntSpeedButton15: TTntSpeedButton;
    VirtualStringTree1: TVirtualStringTree;
    TntTabSheet3: TTntTabSheet;
    TntPanel8: TTntPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel12: TBevel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TntListBox1: TTntListBox;
    TntListBox2: TTntListBox;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure PageControl2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PageControl2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PageControl2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure PageControl2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure selectall1Click(Sender: TObject);
    procedure Invertselection1Click(Sender: TObject);
    procedure Deleteselection1Click(Sender: TObject);
    procedure VirtualStringTree2GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree2HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure VirtualStringTree2GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree1DblClick(Sender: TObject);
    procedure TntSpeedButton1Click(Sender: TObject);
    procedure VirtualStringTree3GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure TntEdit3Change(Sender: TObject);
    procedure VirtualStringTree3HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure TntEdit2Change(Sender: TObject);
    procedure VirtualStringTree3GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure BMDThread1Update(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer; Percent: Integer);
    procedure BMDThread1Execute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure VirtualStringTree3DblClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure IdTCPServer1Connect(AThread: TIdPeerThread);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
    procedure TntSpeedButton2Click(Sender: TObject);
    procedure TntSpeedButton3Click(Sender: TObject);
    procedure BMDThread1Start(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure Timer2Timer(Sender: TObject);
    procedure BMDThread1Terminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure TntPopupMenu1Popup(Sender: TObject);
    procedure Connect1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Pauseselection1Click(Sender: TObject);
    procedure Resumeselection1Click(Sender: TObject);
    procedure TntSpeedButton4Click(Sender: TObject);
    procedure TntSpeedButton6Click(Sender: TObject);
    procedure TntSpeedButton5Click(Sender: TObject);
    procedure EmojiClickchat(Sender: TObject);
    procedure ThreadsendfileExecute(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VirtualStringTree4GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure ThreadsendfileTerminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure Createuploadline(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure Createdownloadline;
    procedure updatedownloadrate;
    procedure refreshdownloadlist;
    procedure refreshuploadlist;
    procedure updateuploadline(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure deletedownline;
    procedure TntLabel6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VirtualStringTree5GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree5GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree5PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure VirtualStringTree4GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree4PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure setchat1Click(Sender: TObject);
    procedure sendfileClick(Sender: TObject);
    procedure TntPopupMenu3Popup(Sender: TObject);
    procedure TntSpeedButton7Click(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Opendir1Click(Sender: TObject);
    procedure TntRichEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntRichEdit3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure High1Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure Low1Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure ThreadsendrequestsExecute(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadsendrequestsStart(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure ThreadsendrequestsTerminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure SpeedButton9Click(Sender: TObject);
    procedure Cleancompleted1Click(Sender: TObject);
    procedure TntSpeedButton10Click(Sender: TObject);
    procedure TntSpeedButton11Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure N81Click(Sender: TObject);
    procedure N91Click(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N52Click(Sender: TObject);
    procedure N62Click(Sender: TObject);
    procedure N72Click(Sender: TObject);
    procedure N82Click(Sender: TObject);
    procedure N92Click(Sender: TObject);
    procedure N102Click(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure TntSpeedButton13Click(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure TntSpeedButton14Click(Sender: TObject);
    procedure TntSpeedButton12Click(Sender: TObject);
    procedure TntSpeedButton15Click(Sender: TObject);
    procedure TntRichEdit1Change(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
  private
    { Private declarations }
    Downloadlist : TList;
    Uploadlist : TList;
    procedure WMSysCommand(var Message: TWMSysCommand); message
    WM_SYSCOMMAND;
  protected
    paramstr1,paramstr2,paramstr3:Ansistring;
    paramwidestr1:widestring;
    paramint64:int64;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure traductfserver;
    procedure createpeersdb;
    procedure flagcontrol( Sender: TObject );
    procedure addchatthread;
    procedure addchat(id:integer;msg:widestring;forzed:boolean);
    procedure addglobalmessagethread(obj:Tobject);
    procedure addwellcomemessagethread(Obj:Tobject);
    procedure addeventerrorsync(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
    procedure addeventnothread(msg:widestring;cl:Tcolor);
    procedure enablesendbutton(Sender: TObject);
    procedure sendmyrequests(Sender :TObject);
    procedure checkchatselection();
    procedure deletecurrentchat( Sender : Tobject );
    procedure clearcurrentchat( Sender : Tobject );
    procedure scrollrichedits();
    procedure deleteallchats( Sender: Tobject);
    function getcurrentchatid():string;
    procedure checkconnectionstatus;
    procedure showserverslist;
    procedure reconnect(Sender: TObject);
    procedure showpeerslist(sender: Tobject);
    function idofip(ip:string):longint;
    procedure communitymessage(translationid:integer;yesno:boolean);
    procedure showbandwidthselector(down:boolean);
    procedure rarebugconnectionfixer;
    procedure requestselectiontostatus(fieldname:string;newstatus:string);
    function currentpassword():widestring;
    procedure uploadfile(path:widestring;userid:longint;fromrequest:boolean);
    procedure uploadfilefromselectedpeer();
    procedure uploadfilefromselectedchat();
    function gethostdescription(ip:string;port:integer):widestring;
    function nickofip(ip:string):widestring;
    procedure removequerysdownloadingstatus;
  protected
  end;

var
  Fserver: TFserver;
  selectedpeer,sendid,sendport:longint;
  currentuserip:string;
  sendrq:ansistring;
  fservertothemax,serverread,requestread:boolean;
  Q,Q2,Q3:Tabsquery; //???
  polarity,reconnection:boolean;
  oldserverleft,oldservertop:integer;
  sendmsg:widestring;
  transfers:Ttransfers;
  globaldownspeed:int64;
  currentusername:widestring;
  commands,requests:Ttntstringlist;
  cs:TCriticalsection;
  
const
separator=#9;
consttimeout=5000;
HASHBUFFSIZE=1024*32;//32Kb   1024*100=100Kb

implementation

uses Umain, UData, DateUtils;

{$R *.dfm}
procedure TFserver.WMSysCommand(var Message: TWMSysCommand);
begin

  case (Message.CmdType and $FFF0) of
    SC_RESTORE  : begin
                    if (Application.Active=true) AND (Fserver.Active=true) then  //0.044
                      Fserver.tag:=0;   //IS ACTIVE
                      
                    checkchatselection;
                    //Fmain.settrayicon;//FIX
                  end;
  end;

  inherited;
end;

procedure TFserver.CreateParams(var Params: TCreateParams); //INDEPENDENT WINDOW BUGGY
begin
  inherited
  CreateParams(Params);
  Params.ExStyle   := Params.ExStyle or WS_EX_APPWINDOW;
  //Params.WndParent := GetDesktopWindow;//This fixes opendialog hide Fserver window but duplicates taskbar 0.037
end;

//LISTS-------------------------------------------------------------------------

constructor Ttransfers.Create(const Aid :string;
                              const Afilename   : widestring;
                              const Atotalsize : int64;
                              const Adownsize : int64;
                              const Aspeed : int64;
                              const Apbar : Tgauge;
                              const Aplabel : Ttntlabel;
                              const Anick : widestring;
                              const Aprofilename : widestring;
                              const Adownsizedisp : string;
                              const Aspeeddisp :string;
                              const Atickstart : int64;
                              const AETA : string;
                              const Aolddown : int64);
begin
  // Save the passed parameters
  self.Aid := Aid;
  self.Afilename   := Afilename;
  self.Atotalsize := Atotalsize;
  self.Adownsize := Adownsize;
  self.Aspeed := Aspeed;
  self.Apbar := Apbar;
  self.Aplabel:=Aplabel;
  self.Anick := Anick;
  self.Aprofilename := Aprofilename;
  self.Adownsizedisp := Adownsizedisp;
  self.Aspeeddisp := Aspeeddisp;
  self.Atickstart := Atickstart;
  self.AETA := AETA;
  self.aolddown := aolddown;
end;

//SHOW LISTS -------------------------------------------------------------------

//SERVERS
function Tfserver.gethostdescription(ip:string;port:integer):widestring;
var
res:widestring;
begin
if Datamodule1.Qservers.Locate('IP;Port',VarArrayOf([ip, port]),[])=true then
  res:=getwiderecord(Datamodule1.Qservers.Fieldbyname('Description'));
result:=res;
end;

procedure Tfserver.showserverslist;
var
columname:string;
direction:string;
x:integer;
begin
VirtualStringTree3.RootNodeCount:=0;

Datamodule1.Qservers.Close;
Datamodule1.Qservers.SQL.Text:='SELECT * FROM Servers';

columname:='Description';

//ORDER
for x:=0 to Fserver.virtualstringtree3.header.Columns.Count-1 do
  if Fserver.virtualstringtree3.header.Columns[x].Tag<>0 then begin
    case x of
      0:columname:='Description';
      1:columname:='IP';
      2:columname:='Port';
    end;
    if Fserver.virtualstringtree3.header.Columns[x].Tag<>2 then
      direction:='ASC'
    else
      direction:='DESC';
  end;

Datamodule1.Qservers.SQL.Add('ORDER BY '+columname+' '+direction);
Datamodule1.Qservers.Open;

virtualstringtree3.RootNodeCount:=Datamodule1.Qservers.RecordCount;
posintoindex(0,virtualstringtree3);
end;

//PEERS
function Tfserver.nickofip(ip:string):widestring;
var
Q:Tabsquery;
res:widestring;
begin
res:='';

try
  Q:=Tabsquery.Create(self);
  Q.DatabaseName:='DBPeers';
  Q.SQL.Text:='SELECT * FROM Peers WHERE IP='+''''+ip+'''';
  Q.Open;

  res:=getwiderecord(Q.fieldbyname('Description'));
except
end;

Freeandnil(Q);

result:=res;
end;

procedure Tfserver.showpeerslist(sender : Tobject);
var
oldpeerid:longint;
x:integer;
aux,ip:ansistring;
begin
oldpeerid:=0;
if virtualstringtree1.SelectedCount>0 then
  oldpeerid:=selectedpeer;

VirtualStringTree1.RootNodeCount:=0;

if IdTCPClient1.tag=1 then begin //CONNECTED

  Datamodule1.Qpeers.close;
  Datamodule1.Qpeers.open;

  virtualstringtree1.RootNodeCount:=Datamodule1.Qpeers.RecordCount;
  panel33.Caption:=fillwithzeroes(inttostr(virtualstringtree1.RootNodeCount),4);

  if Datamodule1.Qpeers.locate('ID',oldpeerid,[])=true then
    posintoindex(Datamodule1.Qpeers.recno-1,virtualstringtree1)
  else
    posintoindex(0,virtualstringtree1);
end
else begin //FORZE CLOSE WHEN SERVER IS DOWN
  Datamodule1.Qpeers.close;
  panel33.Caption:=fillwithzeroes('0',4);
end;

//SET THE CORRECT CHAT STATUS
for x:=1 to PageControl2.PageCount-1 do begin
  //'CLONE_Speedbutton2_'+aux  'CLONE_Tabsheet4_'+aux
  aux:=Pagecontrol2.Pages[x].Name;
  aux:=gettoken(aux,'_',3);
  //Aux is ip
  ip:=changein(aux,'o','.');

  try
    if (Datamodule1.Qpeers.Locate('IP',ip,[])=true) AND (IdTCPClient1.tag=1) then begin
      Pagecontrol2.Pages[x].ImageIndex:=5;
      (Fserver.FindComponent('CLONE_Speedbutton2_'+aux) as TTntSpeedButton).Enabled:=true;
      //REFRESH USER NAME
      Pagecontrol2.Pages[x].Caption:=changein(getwiderecord(Datamodule1.Qpeers.Fieldbyname('Description')),'&','&&');
    end
    else begin
      Pagecontrol2.Pages[x].ImageIndex:=6;
      (Fserver.FindComponent('CLONE_Speedbutton2_'+aux) as TTntSpeedButton).Enabled:=false;
    end;
  except
    Pagecontrol2.Pages[x].ImageIndex:=6;
    (Fserver.FindComponent('CLONE_Speedbutton2_'+aux) as TTntSpeedButton).Enabled:=false;
  end;

end; 

checkchatselection;
virtualstringtree1.repaint;
end;

//REQUESTS
procedure Tfserver.requestselectiontostatus(fieldname:string;newstatus:string);
var
N:PVirtualNode;
x:integer;
done:boolean;
begin
done:=false;
if VirtualStringTree2.SelectedCount=0 then
  exit;

n:=virtualstringtree2.GetFirst;
for x:=0 to virtualstringtree2.RootNodeCount-1 do begin

  if virtualstringtree2.Selected[n]=true then begin
    Datamodule1.Qmyquerysview.RecNo:=x+1;
    If Datamodule1.Tmyquerys.Locate('ID',Datamodule1.Qmyquerysview.fieldbyname('ID').asinteger,[])=true then
      if (Datamodule1.Tmyquerys.fieldbyname(fieldname).asstring<>newstatus) then begin
        Datamodule1.Tmyquerys.edit;
        Datamodule1.Tmyquerys.fieldbyname(fieldname).asstring:=newstatus;
        Datamodule1.Tmyquerys.post;
        done:=true;
      end;
  end;

  n:=virtualstringtree2.getnext(n);
end;

VirtualStringTree2.repaint;

if done=true then
  Datamodule1.Qmyquerys.Tag:=2;//FORCE REFRESH AND FORCE FIRST RECORD
end;

procedure Tfserver.removequerysdownloadingstatus;
var
Q:Tabsquery;
begin
Q:=Tabsquery.Create(self);
try
  if Datamodule1.Qmyquerysview.Locate('Status','D',[])=true then begin //JUMP IF NO COMPLETED EXISTS
    Q.DatabaseName:=Datamodule1.DBMyquerys.DatabaseName;
    Q.SQL.Add('UPDATE Querys SET Status = '+''''+''+''''+' WHERE Status = '+''''+'D'+'''');
    Q.Prepare;
    Q.ExecSQL;
  end;
except
end;

Freeandnil(Q);
end;

//FUNCTIONS FOR INTERNET--------------------------------------------------------
procedure Tfserver.checkconnectionstatus;
var
bmp:TBitmap;
begin
bmp:=TBitmap.Create;

if IdTCPClient1.Tag=2 then begin //Connecting
  imagelist2.GetBitmap(6,bmp);
  TntPanel5.Caption:=' '+traduction(364)+' ['+gethostdescription(IdTCPClient1.host,IdTCPClient1.port)+'] - '+IdTCPClient1.host+':'+inttostr(IdTCPClient1.port);//CONNECTED STATUS
end
else
if IdTCPClient1.Tag=1 then begin //Connected
  imagelist2.GetBitmap(5,bmp);
  TntPanel5.Caption:=' '+traduction(515)+' : ['+gethostdescription(IdTCPClient1.host,IdTCPClient1.port)+'] - '+IdTCPClient1.host+':'+inttostr(IdTCPClient1.port);//CONNECTED STATUS
  TntSpeedButton4.Enabled:=true;
  SpeedButton1.Enabled:=true;
end
else
if IdTCPClient1.Tag=0 then begin
  imagelist2.GetBitmap(6,bmp);
  TntPanel5.Caption:=' '+traduction(516);
  tntspeedbutton10.Caption:='0/'+inttostr(downslots);
  tntspeedbutton11.Caption:='0/'+inttostr(upslots);
  tntspeedbutton14.Caption:='- Kb/s';
  tntspeedbutton15.Caption:='- Kb/s';
  virtualstringtree1.RootNodeCount:=0;
  panel33.Caption:='0000';
  TntSpeedButton4.Enabled:=false;
  showpeerslist(Fserver);
  SpeedButton1.Enabled:=true;
end;

image324.Canvas.Fillrect(image324.Canvas.ClipRect);
image324.Bitmap.Assign(bmp);
Freeandnil(bmp);

Fmain.settrayicon;
virtualstringtree3.Repaint;
end;

function isvalidip(Ip: string): Boolean;
const
  Z = ['0'..'9', '.'];
var
  I, J, P: Integer;
  W: string;
begin
  Result := False;
  if (Length(Ip) > 15) or (Ip[1] = '.') then Exit;
  I := 1;
  J := 0; 
  P := 0;
  W := '';
  repeat
    if (Ip[I] in Z) and (J < 4) then
    begin
      if Ip[I] = '.' then
      begin
        Inc(P);
        J := 0;
        try
          StrToInt(Ip[I + 1]);
        except
          Exit;
        end;
        W := '';
      end 
      else
      begin
        W := W + Ip[I];
        if (StrToInt(W) > 255) or (Length(W) > 3) then Exit;
        Inc(J);
      end;
    end
    else 
      Exit;
    Inc(I);
  until I > Length(Ip);
  if P < 3 then Exit;
  Result := True;
end;

Function getlocalip():String;
type
  pu_long = ^u_long;
var
  varTWSAData : TWSAData;
  varPHostEnt : PHostEnt;
  varTInAddr : TInAddr;
  namebuf : Array[0..255] of char;
begin
  If WSAStartup($101,varTWSAData) <> 0 Then
  Result := ''
  Else Begin
    gethostname(namebuf,sizeof(namebuf));
    varPHostEnt := gethostbyname(namebuf);
    varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
    Result := inet_ntoa(varTInAddr);
  End;
  WSACleanup;
end;

function getinternetip: string;
var
dest:widestring;
f:textfile;
cad:string;
ip:string;
begin
//'http://ipinfo.io/json'
//http://www.infobyip.com/

dest:=tempdirectoryresources+'ip.rmt';
deletefile2(dest);

if Fmain.downloadfile2('http://ipinfo.io/json',dest,false)=true then begin //1ST

  try
    assignfile(f,dest);
    reset(f);
    while not eof(f) do begin
      readln(f,cad);
      if uppercase(gettoken(cad,'"',2))='IP' then begin
        ip:=gettoken(cad,'"',4);
        if isvalidip(ip)=false then
          ip:=''
        else
          break;
      end;
    end;
    closefile(f);
  except
  end;
end;

if ip='' then begin //2ND
  deletefile2(dest);
  if Fmain.downloadfile2('http://www.infobyip.com',dest,false)=true then begin //1ST
    try
      assignfile(f,dest);
      reset(f);
      while not eof(f) do begin
        readln(f,cad);
        if gettokencount(uppercase(cad),'YOUR CLIENT IP:')>1 then begin
          ip:=gettoken(cad,'<b>',2);
          ip:=gettoken(ip,'</b>',1);
          if isvalidip(ip)=false then
            ip:=''
          else
            break;
        end;
      end;
      closefile(f);
    except
    end;
  end;
end;

deletefile2(dest);

result:=ip;
end;

procedure Tfserver.updateuploadline(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
var
sum:int64;
idcomp:string;
x:integer;
begin
//id,currentsum
idcomp:=gettoken(string(data),separator,1);
sum:=strtoint64(gettoken(string(data),separator,2));

for x:=0 to Uploadlist.Count-1 do
  if Ttransfers(Uploadlist[x]).id=idcomp then begin//LOCATE CURRENT LINE TO WRITE
    Ttransfers(Uploadlist[x]).Adownsize:=sum;
    break;
  end;
end;

procedure Tfserver.refreshuploadlist;
begin
virtualstringtree5.RootNodeCount:=Uploadlist.Count;

if (virtualstringtree5.SelectedCount=0) AND (virtualstringtree5.RootNodeCount>0) then
  posintoindex(0,virtualstringtree5);

virtualstringtree5.repaint;

tntspeedbutton11.caption:=inttostr(Uploadlist.Count)+'/'+inttostr(upslots);
end;

procedure Tfserver.Createuploadline(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
var
g,t:Tcomponent;
objid:string;
maxsize,maxprogress:int64;
filename,touser,toprofilename:widestring;
begin
objid:=gettoken(widestring(data),separator,1);

g:=Fmain.CloneComponent(Gauge1,objid);
(g as TGauge).parent:=Virtualstringtree5;
(g as Tgauge).forecolor:=$003535FF;
t:=Fmain.CloneComponent(TntLabel6,objid);
(t as Ttntlabel).Parent:=virtualstringtree5;
(t as Ttntlabel).OnMouseDown:=TntLabel6MouseDown;
(t as Ttntlabel).BringToFront;
(t as Ttntlabel).Transparent:=true;

(g as Tgauge).Tag:=1;
(g as Tgauge).Progress:=0;

maxsize:=StrToInt64(gettoken(gettoken(widestring(data),separator,2),separator,1));
maxprogress:=maxsize;

(g as Tgauge).MaxValue:=maxprogress;

//idcomp+separator+inttostr(maxsize)+separator+filename+separator+touser)
filename:=gettoken(widestring(data),separator,3);
touser:=gettoken(widestring(data),separator,4);
toprofilename:=gettoken(widestring(data),separator,5);

//ID,Filename,Totalsize,Downloadedsize,Speed,Gauge,Label,Nick,Profilename,Displaydownloaded,Displayspeed
uploadlist.Add(Ttransfers.Create(objid,filename,maxsize,0,0,(g as TGauge),(t as Ttntlabel),touser,toprofilename,bytestostr(0),bytestostr(0)+'/s',gettickcount,'???',0));

refreshuploadlist;
end;

procedure Tfserver.refreshdownloadlist;
begin
virtualstringtree4.RootNodeCount:=Downloadlist.Count;
if (virtualstringtree4.SelectedCount=0) AND (virtualstringtree4.RootNodeCount>0) then
  posintoindex(0,virtualstringtree4);

virtualstringtree4.repaint;

tntspeedbutton10.Caption:=inttostr(Downloadlist.Count)+'/'+inttostr(downslots);
end;

procedure Tfserver.Createdownloadline;
var
g,t:Tcomponent;
objid:string;
maxsize,maxprogress:int64;
filename,touser,commands:widestring;
begin
commands:=paramwidestr1;
//idcomp+separator+inttostr(maxsize)+separator+filename+separator+Athread.Connection.Socket.Binding.PeerIP+separator+reqid
objid:=gettoken(commands,separator,1);

g:=Fmain.CloneComponent(Gauge1,objid);
(g as TGauge).parent:=Virtualstringtree4;
t:=Fmain.CloneComponent(TntLabel6,objid);
(t as Ttntlabel).Parent:=virtualstringtree4;
(t as Ttntlabel).OnMouseDown:=TntLabel6MouseDown;
(t as Ttntlabel).BringToFront;
(t as Ttntlabel).Transparent:=true;

(g as Tgauge).Tag:=1;
(g as Tgauge).Progress:=0;

maxsize:=StrToInt64(gettoken(gettoken(commands,separator,2),separator,1));
maxprogress:=maxsize;

(g as Tgauge).MaxValue:=maxprogress;

filename:=gettoken(commands,separator,3);
touser:=nickofip(gettoken(commands,separator,4));

//ID,Filename,Totalsize,Downloadedsize,Speed,Gauge,Label,Nick,Profilename,Displaydownloaded,Displayspeed,Starttime,ETA
Datamodule1.Tmyquerys.locate('ID',gettoken(commands,separator,5),[]);
Datamodule1.Tmyquerys.Edit;
Datamodule1.Tmyquerys.fieldbyname('Status').asstring:='D';//DOWNLOADING
Datamodule1.Tmyquerys.Post;

virtualstringtree2.Repaint;
                                                                                                              //PROFILENAME
Downloadlist.Add(Ttransfers.Create(objid,filename,maxsize,0,0,(g as TGauge),(t as Ttntlabel),touser,gettoken(commands,separator,6),bytestostr(0),bytestostr(0)+'/s',gettickcount,'???',0));

refreshdownloadlist;
end;

procedure Tfserver.updatedownloadrate;
var
x:integer;
etastr:ansistring;
etacalc:int64;
begin
etastr:=paramstr1;
etacalc:=paramint64;

for x:=0 to Downloadlist.Count-1 do
  if Ttransfers(Downloadlist[x]).id=etastr then begin
    Ttransfers(Downloadlist[x]).ADownsize:=etacalc;
    break;
  end;

end;

procedure Tfserver.uploadfile(path:widestring;userid:longint;fromrequest:boolean);
var
bmd:Tcomponent;
Q:Tabsquery;
begin

Q:=TABSQuery.Create(self);
Q.DatabaseName:=DataModule1.DBPeers.Name;
Q.SQL.Add('SELECT * FROM Peers WHERE ID = '+''''+inttostr(userid)+'''');
Q.Open;

if Q.IsEmpty=false then begin

  //CREATE CLONED UPLOAD
  bmd:=Fmain.CloneComponent(Threadsendfile,'UP'+inttostr(GetTickCount));

  //SEND PARAMS
  //(bmd as Tbmdthread).ThreadGroup:=Fmain.BMDThreadGroup1;
  (bmd as Tbmdthread).OnExecute:=ThreadsendfileExecute;
  (bmd as Tbmdthread).OnTerminate:=ThreadsendfileTerminate;

  if fromrequest=true then
    (bmd as Tbmdthread).Start(Pwidechar(Q.fieldbyname('Port').asstring+separator+getwiderecord(Q.FieldByName('Description'))+separator+path))
  else
    (bmd as Tbmdthread).Start(Pwidechar(Q.fieldbyname('IP').asstring+separator+Q.fieldbyname('Port').asstring+separator+getwiderecord(Q.FieldByName('Description'))+separator+path));
end;

Freeandnil(Q);

end;

procedure Tfserver.uploadfilefromselectedpeer();
var
filename:widestring;
begin
if virtualstringtree1.SelectedCount=0 then
  exit;

TntOpenDialog1.title:=traduction(605);
TntOpenDialog1.Filter:=traduction(604)+' (*.*)|*.*';
TntOpenDialog1.FileName:='';
TntOpenDialog1.InitialDir:=folderdialoginitialdircheck(initialdirsharefile);

Fmain.positiondialogstart;

if TntOpenDialog1.Execute then begin
  filename:=TntOpenDialog1.FileName;
  initialdirsharefile:=wideextractfilepath(filename);
  uploadfile(filename,selectedpeer,false);
end;

end;

procedure Tfserver.uploadfilefromselectedchat();
var
filename:widestring;
ip,aux:string;
begin
if virtualstringtree1.SelectedCount=0 then
  exit;

aux:=getcurrentchatid;
ip:=changein(aux,'o','.');

TntOpenDialog1.title:=traduction(605);
TntOpenDialog1.Filter:=traduction(604)+' (*.*)|*.*';
TntOpenDialog1.FileName:='';
TntOpenDialog1.InitialDir:=folderdialoginitialdircheck(initialdirsharefile);

//MUST FIX PROBLEMS WITH DIALOG IN BACKGROUND

isserverdialog:=true;

Fmain.positiondialogstart;

if TntOpenDialog1.Execute then begin
  filename:=TntOpenDialog1.FileName;
  initialdirsharefile:=wideextractfilepath(filename);

  if FileExists2(filename)=false then
    exit;

  if FileInUse(filename)=true then begin
    addeventnothread(traduction(180)+' '+filename,clred);
    exit;
  end;

  if Datamodule1.Qpeers.Locate('IP',ip,[]) then
    uploadfile(filename,Datamodule1.Qpeers.fieldbyname('ID').asinteger,false);
end;

end;

procedure TFserver.deletedownline;
var
x:integer;
g:Tgauge;
t:Ttntlabel;
id,requestid:ansistring;
begin
id:=paramstr1;
requestid:=paramstr2;

for x:=0 to Downloadlist.Count-1 do
  if Ttransfers(Downloadlist[x]).id=id then begin//LOCATE CURRENT LINE TO WRITE

    g:=Ttransfers(Downloadlist[x]).pbar;
    t:=Ttransfers(Downloadlist[x]).Plabel;

    if Ttransfers(Downloadlist[x]).Profilename='' then begin//MANUAL SEND END

      if sizeoffile(Ttransfers(Downloadlist[x]).Filename)=Ttransfers(Downloadlist[x]).Totalsize then begin//OK
        insertrichtextchat(RxRichEdit2,traduction(607)+' '+getrichpath(Ttransfers(Downloadlist[x]).Filename),nil,clgreen,Ttransfers(Downloadlist[x]).Nick)
      end
      else begin
        insertrichtextchat(RxRichEdit2,traduction(608)+' '+Ttransfers(Downloadlist[x]).Filename,nil,clred,Ttransfers(Downloadlist[x]).Nick);
        deletefile2(Ttransfers(Downloadlist[x]).Filename);//REMOVE FAILED FILE
      end;

      if pagecontrol1.ActivePageIndex<>5 then
        pagecontrol1.Pages[5].Highlighted:=true;
        
    end
    else begin //AUTOMATIC SEND END

      Datamodule1.Tmyquerys.Locate('ID',requestid,[]);
      Datamodule1.Tmyquerys.edit;

      if sizeoffile(Ttransfers(Downloadlist[x]).Filename)=Ttransfers(Downloadlist[x]).Totalsize then begin//OK
        insertrichtextchat(RxRichEdit2,traduction(628)+' '+getrichpath(Ttransfers(Downloadlist[x]).Filename),nil,clgreen,Ttransfers(Downloadlist[x]).Nick);
        Datamodule1.Tmyquerys.FieldByName('Status').asstring:='C';//COMPLETED
        setwiderecord(Datamodule1.Tmyquerys.FieldByName('Downpath'),Ttransfers(Downloadlist[x]).Filename);
        Datamodule1.Tmyquerys.FieldByName('Completed').asdatetime:=now;
      end
      else begin
        insertrichtextchat(RxRichEdit2,traduction(629)+' '+Ttransfers(Downloadlist[x]).Filename,nil,clred,Ttransfers(Downloadlist[x]).Nick);
        deletefile2(Ttransfers(Downloadlist[x]).Filename);//REMOVE FAILED FILE
        Datamodule1.Tmyquerys.FieldByName('Status').asstring:='';//WAITING AGAIN BECAUSE FAILED
      end;

      Datamodule1.Tmyquerys.post;

      if pagecontrol1.ActivePageIndex<>5 then
        pagecontrol1.Pages[5].Highlighted:=true;

      Datamodule1.Qmyquerys.Tag:=1;//FORCE UPDATE MY REQUEST LIST
    end;
    Downloadlist.Delete(x);
    break;
  end;

try
  Freeandnil(g);
except
end;
try
  Freeandnil(t);
except
end;

virtualstringtree2.Repaint;

refreshdownloadlist;
end;


//CHATS-------------------------------------------------------------------------

procedure Tfserver.scrollrichedits();
var
x:integer;
begin

for x:=0 to Fserver.ComponentCount-1 do //SCROLL ALL RICHS AT SHOW
  if Fserver.Components[x] is TRxRichEdit then begin
    ScrollToEnd(Fserver.components[x] as TrxRichedit);
  end;
end;

//DELETE CURRENT CHAT TEXT
procedure Tfserver.clearcurrentchat( Sender : Tobject );
var
str:string;
begin
str:=getcurrentchatid;
try
  (Findcomponent('CLONE_RxRichedit3_'+str) as TRxRichEdit).Lines.Clear;
except
end;

end;

//DELETE CURRENT CHAT TAB
procedure Tfserver.deletecurrentchat( Sender : Tobject );
var
str:string;
lastindex:integer;
begin
str:=getcurrentchatid;
lastindex:=PageControl2.ActivePageIndex;

(Findcomponent('CLONE_Panel17_'+str) as TTntpanel).Free;
(Findcomponent('CLONE_Panel30_'+str) as TTntpanel).free;

pagecontrol2.ActivePage.Free;


if lastindex-1>=1 then
  lastindex:=lastindex-1
else
if pagecontrol2.PageCount>0 then
  lastindex:=1;

if pagecontrol2.PageCount>0 then
  pagecontrol2.ActivePageIndex:=lastindex;

//MUST DESTROY COMPONENT CONNECTION TOO
virtualstringtree1.Repaint;

checkchatselection;
PageControl1Change(sender);
end;

//DELETE ALL CHAT TABS
procedure Tfserver.deleteallchats( Sender: Tobject);
var
x:integer;
begin
LockWindowUpdate(Handle);

for x:=pagecontrol2.PageCount-1 downto 1 do begin
  pagecontrol2.ActivePageIndex:=x;
  deletecurrentchat(sender);
end;

LockWindowUpdate(0);
PageControl1Change(sender);
end;

procedure Tfserver.checkchatselection();
var
p,p2,p3:Tobject;
x,pos:integer;
select:ansistring;
ms : TMemoryStream;
begin

try
  PageControl2.Pages[PageControl2.ActivePageIndex].Highlighted:=false;
except
end;

if PageControl2.ActivePageIndex>0 then begin

  pagecontrol2.Pages[PageControl2.ActivePageIndex].Highlighted:=false;

  pagecontrol2.Visible:=true;
  panel31.Visible:=true;

  select:=getcurrentchatid;

  p2:=Findcomponent('CLONE_Panel30_'+select);

  p:=FindComponent('CLONE_SpeedButton2_'+select);
  (p as TTntspeedbutton).Caption:=traduction(25);
  (p as TTntspeedbutton).Left:=(p2 as TTntpanel).Width-(p as TTntspeedbutton).Width;//FIX BUTTON POSSITION
  (p as TTntspeedbutton).Repaint;
  (p as TTntspeedbutton).OnClick:=SpeedButton2Click;

  //pos:=Panel30.Width-speedbutton2.Width;
  pos:=PageControl2.Width-panel31.Width-speedbutton2.Width-speedbutton5.Width-6;

  p:=FindComponent('CLONE_Panel17_'+select); //SHOW PANEL SELECTED
  (p as TTntpanel).Visible:=true;
  (p as TTntpanel).BringToFront;
  p3:=FindComponent('CLONE_Tntrichedit3_'+select);

  (p3 as TTntrichedit).Anchors:=[];
  (p3 as TTntrichedit).Left:=0;
  (p3 as TTntrichedit).Anchors:=(p3 as TTntrichedit).Anchors+[akLeft];
  (p3 as TTntrichedit).Width:=pos-4;
  (p3 as TTntrichedit).Anchors:=(p3 as TTntrichedit).Anchors+[akRight];
  (p3 as TTntrichedit).SelStart:=length((p3 as TTntrichedit).text);
  
  //FIX NO LOSS HYPERLINK INFORMATION
  p2:=Findcomponent('CLONE_RxRichedit3_'+select);
  ms := TmemoryStream.Create;
  (p2 as TRxRichEdit).Lines.SaveToStream(ms);
  ms.Position:=0;
  (p2 as TRxRichEdit).Lines.LoadFromStream(ms);
  Freeandnil(ms);

  scrolltoend((p2 as TRxRichEdit));

  select:=(p as TTntpanel).name;

  for x:=0 to ComponentCount-1 do
    if (components[x] is TTntpanel) then begin
      if (changein((components[x] as TTntpanel).Name,'CLONE_Panel17_','')<>(components[x] as TTntpanel).Name) AND ((components[x] as TTntpanel).name<>select) then
        (components[x] as TTntpanel).Visible:=false;
    end;

  if PageControl2.ActivePage.ImageIndex=5 then //ACTIVE
    TntSpeedButton7.Enabled:=true
  else
    Tntspeedbutton7.enabled:=false;
  //(p3 as TTntedit).SetFocus; //REMOVED
end
else begin //DISABLE AND HIDE THIS ALWAYS FIRST TIME
  //panel12.Caption:=traduction(534);
  tntlabel4.Parent:=panel12;
  tntlabel4.Caption:=traduction(534);

  CenterInClient(tntlabel4,panel12);
  Fmain.labelshadow(tntlabel4,Fserver);
  
  panel17.Visible:=false;
  pagecontrol2.Pages[0].TabVisible:=false;
  pagecontrol2.Visible:=false;
  panel31.Visible:=false;
end;

Fmain.settrayicon;
panel55.Caption:=inttostr(pagecontrol2.PageCount-1);
end;

procedure Tfserver.addchatthread;
begin
addchat(paramint64,paramwidestr1,false);
end;

procedure Tfserver.addglobalmessagethread(Obj:Tobject);
var
id:string;
msg:widestring;
begin
id:=paramstr1;
msg:=paramwidestr1;

//id=IP
if Datamodule1.Qpeers.Active=true then                                             //IGNORE OWN MESSAGE
  if (DataModule1.Qpeers.Locate('IP',id,[])) AND (id<>currentuserip) then begin
    insertrichtextchat(RxRichEdit1,msg,imagelist3,clgreen,getwiderecord(DataModule1.Qpeers.fieldbyname('Description')));
    ScrollToEnd(Rxrichedit1);
    if pagecontrol1.ActivePageIndex<>1 then
      pagecontrol1.Pages[1].Highlighted:=true;
  end;
end;

procedure Tfserver.addwellcomemessagethread(Obj:Tobject);
var
msg:widestring;
begin
msg:=paramwidestr1;

insertrichtextchat(RxRichEdit1,msg,imagelist3,clFuchsia,'');
ScrollToEnd(Rxrichedit1);
if pagecontrol1.ActivePageIndex<>1 then
  pagecontrol1.Pages[1].Highlighted:=true;

end;

procedure Tfserver.addchat(id:integer;msg:widestring;forzed:boolean);
var
ip:string;
p,p2:Tcomponent;
ed:Ttntrichedit;
user:widestring;
aux:string;
begin
Datamodule1.Tpeers.locate('ID',id,[]);
user:=getwiderecord(Datamodule1.Tpeers.fieldbyname('Description'));
ip:=Datamodule1.Tpeers.fieldbyname('IP').asstring;

if ip=currentuserip then  //NO DISPLAY CHAT FOR YOURSELF
  exit;

aux:=getcurrentchatid;


ip:=changein(ip,'.','o');
p:=FindComponent('CLONE_Tabsheet4_'+ip);
              
if p=nil then begin

  LockWindowUpdate(Handle);

  p:=Fmain.CloneComponent(panel17,ip);
  (p as TTntpanel).Parent:=tabsheet3;

  p2:=Fmain.CloneComponent(RxRichEdit3,ip);
  (p2 as TRxRichEdit).Parent:=(p as TTntpanel);
  (p2 as TRxRichEdit).OnEnter:=Fmain.EditEnter;
  (p2 as TRxRichEdit).OnMouseWheel:=Fmain.RichEditURL1MouseWheel;
  (p2 as TRxRichEdit).OnURLClick:=Fmain.RicheditURLClick;

  insertrichtextchat((p2 as TRxRichEdit),traduction(535),imagelist3,RxRichEdit3.Font.Color,'');

  p2:=Fmain.CloneComponent(panel30,ip);
  (p2 as TTntpanel).Parent:=(p as TTntpanel);
  p:=Fmain.CloneComponent(tntrichedit3,ip);

  (p as TTntrichedit).Parent:=(p2 as TTntpanel);
  //(p as TTntedit).OnKeyDown:=Edit1KeyDown;
  //(p as TTntrichedit).OnEnter:=Fmain.EditEnter;  //REMOVED 0.044
  (p as TTntrichedit).OnChange:=TntRichEdit1Change;   //Fmain.EditChange ???? 0.044
  (p2 as TTntpanel).TabOrder:=0;

  p:=Fmain.CloneComponent(tntspeedbutton8,ip); //RETURN BUTTON
  (p as TTntspeedbutton).Parent:=(p2 as TTntpanel);
  (p as TTntspeedbutton).left:=(p2 as TTntpanel).width-130;//CENTER
  p:=Fmain.CloneComponent(speedbutton2,ip);
  (p as TTntspeedbutton).Parent:=(p2 as TTntpanel);
  p:=Fmain.CloneComponent(Tntspeedbutton5,ip); //Emojibutton
  (p as TTntspeedbutton).Parent:=(p2 as TTntpanel);
  (p as TTntspeedbutton).left:=(p2 as TTntpanel).width-130;//CENTER
  (p as TTntSpeedButton).OnClick:=TntSpeedButton5Click;
  //(p as TTntspeedbutton).OnClick:=SpeedButton2Click;

  p:=Fmain.CloneComponent(tabsheet4,ip);
  (p as TTnttabsheet).PageControl:=pagecontrol2;
  pagecontrol2.Pages[pagecontrol2.PageCount-1].TabVisible:=true;

  LockWindowUpdate(0);

  virtualstringtree1.repaint;//FORZE VISIBLE MSG ICON
end;

ed:=(FindComponent('CLONE_TntRichedit3_'+ip) as TTntrichedit);
ed.OnKeyDown:=TntRichEdit3KeyDown;

(p as TTnttabsheet).Caption:=Fmain.gettrimmedtext(changein(user,'&','&&'),100);//REFRESH USERNAME
(p as TTnttabsheet).Hint:=user;
pagecontrol2.Hint:=' ';
(p as TTnttabsheet).ImageIndex:=5;

if (msg<>'') then
  insertrichtextchat((Findcomponent('CLONE_RxRichedit3_'+ip) as TRxRichEdit),msg,imagelist3,clgreen,user);


if forzed=true then begin
  PageControl2.ActivePage:=(p as TTnttabsheet);
  pagecontrol1.ActivePageIndex:=4;
  pagecontrol1.Pages[4].Highlighted:=false;
end
else begin
  if pagecontrol1.ActivePageIndex<>4 then begin
    pagecontrol1.Pages[4].Highlighted:=true;
  end;

  if pagecontrol2.ActivePage<>(p as TTnttabsheet) then
    (p as TTnttabsheet).Highlighted:=true;
end;

if (Application.Active=false) OR (screen.ActiveForm<>Fserver) then  //0.044
  Fserver.tag:=1;   //IS INACTIVE

checkchatselection; //FORCE TRAYICON CHECK

if forzed=true then begin
  PageControl1.Pages[4].Highlighted:=false; //FIX
  ed.SetFocus;
  if ed.Text='' then begin //VISUAL RARE FIX
    SystemParametersInfo(SPI_SETBEEP, 0, nil, SPIF_SENDWININICHANGE);
    keybd_event(VK_LEFT, 0, 0, 0);
    application.ProcessMessages;
    SystemParametersInfo(SPI_SETBEEP, 1, nil, SPIF_SENDWININICHANGE);
  end;
end;


end;

function Tfserver.getcurrentchatid():string;
begin
try
  Result:=pagecontrol2.ActivePage.Name;
  Result:=gettoken(result,'_',gettokencount(result,'_'));
except
  Result:='';
end;
end;

//PROCEDURES FOR LOG LIST-------------------------------------------------------


//DISPLAY A EVENT IN COLOR
procedure Tfserver.addeventnothread(msg:widestring;cl:Tcolor);
begin

try //RichEdit line insertion error. Prevention ???
  insertrichtextchat(RxRichEdit2,msg,nil,cl,'');
except
end;

if pagecontrol1.ActivePageIndex<>5 then
  pagecontrol1.Pages[5].Highlighted:=true;

end;

procedure Tfserver.addeventerrorsync(Sender: TObject; Thread: TBMDExecuteThread; var Data: Pointer);
begin
try //RichEdit line insertion error. Prevention ???
  insertrichtextchat(RxRichEdit2,widestring(data),nil,clred,'');
except
end;         

if pagecontrol1.ActivePageIndex<>5 then
  pagecontrol1.Pages[5].Highlighted:=true;  

if IdTCPClient1.Tag=0 then begin
  TntPanel5.Caption:=' '+traduction(516);
  Fmain.settrayicon;
  VirtualStringTree3.Repaint;
end;

end;

//MISC--------------------------------------------------------------------------
function Tfserver.currentpassword():widestring;
begin
Result:='';
if Datamodule1.Tservers.Locate('ID',virtualstringtree3.tag,[]) then
  Result:=getwiderecord(Datamodule1.Tservers.fieldbyname('Password'));
end;

procedure Tfserver.rarebugconnectionfixer;
begin
sleep(100);
//caption:=Fserver.Caption;//NEEDED WHY? BUG
end;

procedure Tfserver.enablesendbutton(Sender: TObject);
begin
if Fserver.IdTCPClient1.Tag=1 then
  tntspeedbutton4.enabled:=true;
end;

procedure Tfserver.sendmyrequests(Sender :TObject);
begin
Threadsendrequests.start;
end;

procedure Tfserver.flagcontrol( Sender: TObject );
begin
caption:=timetostr(now);
end;


//DB PROCEDURES ------------------------------------------------

function Tfserver.idofip(ip:string):longint;
var
id:longint;
Q:Tabsquery;
begin
id:=0;
Q:=TABSQuery.Create(Datamodule2);
Q.DatabaseName:=DataModule1.DBPeers.Name;

//ACCEPT MESSAGES FROM IN LIST USERS
Q.SQL.Add('SELECT * FROM Peers WHERE IP = '+''''+ip+'''');
try
  Q.open;
  if Q.RecordCount>0 then
    id:=Q.fieldbyname('ID').asinteger;
except
end;

Freeandnil(Q);

result:=id;
end;

procedure Tfserver.createpeersdb;
begin
Datamodule1.DBPeers.Close;
Datamodule1.DBPeers.DatabaseFileName:=UTF8Encode(tempdirectorypeers);
Datamodule1.DBPeers.PageCountInExtent:=defpagecountinextent;
Datamodule1.DBPeers.PageSize:=defpagesize;
DataModule1.DBPeers.MaxConnections:=defmaxconnections;
DataModule1.DBPeers.SilentMode:=true;
Datamodule1.DBPeers.CreateDatabase;

Datamodule1.Tpeers.close;
Datamodule1.Tpeers.FieldDefs.Clear;
Datamodule1.Tpeers.FieldDefs.Add('ID',ftAutoInc,0,False);
Datamodule1.Tpeers.FieldDefs.Add('Description',ftWideString,50,true);
Datamodule1.Tpeers.FieldDefs.Add('IP',ftString,15,true);
Datamodule1.Tpeers.FieldDefs.Add('PORT',ftInteger,0,true);
Datamodule1.Tpeers.FieldDefs.Add('POLARITY',ftBoolean,0,true);
Datamodule1.Tpeers.FieldDefs.Add('Yourself',ftBoolean,0,true);

Datamodule1.Tpeers.IndexDefs.Clear;
Datamodule1.Tpeers.IndexDefs.Add('I1', 'ID', [ixPrimary]); //Speedup locate
Datamodule1.Tpeers.IndexDefs.Add('I2', 'IP', [ixUnique,ixCaseInsensitive]);
Datamodule1.Tpeers.IndexDefs.Add('I3', 'POLARITY', []);

Datamodule1.Tpeers.CreateTable;

Datamodule1.Tpeers.Open;
end;

//MESSAGES----------------------------------------------------------------------
procedure TFserver.communitymessage(translationid:integer;yesno:boolean);
begin
panel38.Tag:=translationid;

panel6.enabled:=false;
panel9.enabled:=false;
panel19.enabled:=false;
pagecontrol1.Enabled:=false;
panel13.Enabled:=false;

panel38.ParentColor:=false;
panel38.Color:=clBtnFace;
panel39.ParentColor:=false;
panel39.Color:=clActiveCaption;
panel39.Font:=Fserver.VirtualStringTree1.Font;
panel39.Font.style:=panel39.Font.style+[fsbold];
panel38.Font:=Fserver.VirtualStringTree1.Font;
panel38.font.Color:=clCaptionText;

TntRichEdit2.Lines.clear;
TntRichEdit2.Lines.add(traduction(translationid));
TntRichEdit2.tag:=translationid;

if yesno=false then begin
  TntSpeedButton3.Visible:=false;
  TntSpeedButton2.Left:=(panel38.Width div 2)-(TntSpeedButton2.Width div 2);
end
else begin
  TntSpeedButton3.Visible:=true;
  Tntspeedbutton2.Left:=(panel38.Width div 2)-TntSpeedButton2.Width-5;
  Tntspeedbutton3.Left:=(panel38.Width div 2)+5;
end;

AnimateWindow(Panel38.Handle, 150,   AW_CENTER or  AW_ACTIVATE);
Panel38.visible:=true;
end;

procedure Tfserver.showbandwidthselector(down:boolean);
begin
panel6.enabled:=false;
panel9.enabled:=false;
panel19.enabled:=false;
pagecontrol1.Enabled:=false;
panel13.Enabled:=false;

edit8.Text:=IntToStr(upspeed);
edit7.Text:=IntToStr(downspeed);

tntpanel6.ParentColor:=false;
tntpanel6.Color:=clBtnFace;
tntpanel7.ParentColor:=false;
tntpanel7.Color:=clActiveCaption;
tntpanel7.Font:=Fserver.VirtualStringTree1.Font;
tntpanel7.Font.Style:=tntpanel7.Font.Style+[fsBold];
tntpanel6.Font:=Fserver.VirtualStringTree1.Font;
tntpanel6.font.Color:=clCaptionText;

edit8.Text:=IntToStr(upspeed);
edit7.Text:=IntToStr(downspeed);

AnimateWindow(tntpanel6.Handle, 150,   AW_CENTER or  AW_ACTIVATE);
tntpanel6.visible:=true;

if down=false then
  edit8.setfocus
else
  edit7.SetFocus;
end;

procedure Tfserver.reconnect(Sender: TObject);
var
done:boolean;
begin
done:=false;
IdTCPClient1.tag:=2;
checkconnectionstatus;

wideforceDirectories(communitydownfolder);
if WideDirectoryExists(communitydownfolder)=false then
  addeventnothread(traduction(546),clred);

try
  IdTCPClient1.Disconnect;
except
end;

try //TRY CONNECT TO SERVER
  IdTCPClient1.Connect(consttimeout);
  //IF CONNECTED SEND MESSAGE WELCOME
  try
    IdTCPclient1.WriteLn('RML_SRV');

    if idtcpclient1.ReadLn<>'0' then
      makeexception
    else begin //SEND INFORMATION ABOUT PEER

      idtcpclient1.WriteLn(UTF8Encode(currentpassword));//PASSWORD
      idtcpclient1.WriteLn(UTF8Encode(currentusername));//NICK
      IdTCPClient1.WriteLn(inttostr(IdTCPServer1.defaultport));//PORT

      masterkey:=idtcpclient1.ReadLn; //GETTING MASTER KEY ENCRYPTION
      IdTCPClient1.WriteLn(Encrypt('GENUINEUSER')); //CHECK FOR CORRECT KEYS

      if IdTCPClient1.ReadLn='0' then begin
        done:=true;
        IdTCPClient1.Tag:=1;
        //UTF8Decode(Decrypt(idtcpclient1.ReadLn)); //WELCOME MESSAGE
      end;
      
    end;
  except
  end;
except
end;

if done=true then begin
  addeventnothread(traduction(587)+' - ['+gethostdescription(IdTCPClient1.Host,IdTCPClient1.port)+'] - '+IdTCPClient1.Host+':'+IntToStr(IdTCPClient1.Port),clgreen);
  insertrichtextchat(RxRichEdit1,traduction(601)+' - ['+gethostdescription(IdTCPClient1.Host,IdTCPClient1.port)+'] - '+IdTCPClient1.Host+':'+IntToStr(IdTCPClient1.Port),nil,RxRichEdit1.font.color,'');
  ScrollToEnd(RxRichedit1);
  if pagecontrol1.ActivePageIndex<>1 then
    pagecontrol1.Pages[1].Highlighted:=true;
end
else begin
  IdTCPClient1.tag:=0;
  IdTCPClient1.Disconnect;
  addeventnothread(traduction(552)+' - ['+gethostdescription(IdTCPClient1.Host,IdTCPClient1.port)+'] - '+IdTCPClient1.Host+':'+IntToStr(IdTCPClient1.Port),clred);
end;

checkconnectionstatus;
end;


procedure Tfserver.traductfserver;
begin
caption:=traduction(314)+' - '+'WIP';

TntLabel1.Caption:=traduction(11)+' :';
TntLabel2.Caption:=traduction(417)+' :';
TntLabel3.Caption:=traduction(539)+' :';
TntLabel5.Caption:=traduction(593)+' :';
tntspeedbutton1.caption:=traduction(293);

speedbutton1.Caption:=traduction(545);
speedbutton3.Caption:=traduction(547);

speedbutton4.Hint:=traduction(116);
speedbutton5.Hint:=traduction(117);
speedbutton6.Hint:=traduction(201);

speedbutton7.Hint:=traduction(567);
speedbutton8.Hint:=traduction(568);
speedbutton9.Hint:=traduction(570);

tntspeedbutton9.Hint:=traduction(611);
tntspeedbutton8.Hint:=tntspeedbutton9.Hint;

Resumeselection1.Caption:=UTF8Encode(traduction(567));
Pauseselection1.Caption:=UTF8Encode(traduction(569));
Deleteselection1.Caption:=UTF8Encode(traduction(33));
Priority1.Caption:=UTF8Encode(traduction(559));
High1.caption:=UTF8Encode(traduction(46));
Normal1.Caption:=UTF8Encode(traduction(47));
Low1.Caption:=UTF8Encode(traduction(48));
Cleancompleted1.Caption:=UTF8Encode(traduction(570));
selectall1.Caption:=UTF8Encode(traduction(40));
Invertselection1.caption:=UTF8Encode(traduction(41));
setchat1.Caption:=UTF8Encode(traduction(606));
sendfile.Caption:=UTF8Encode(traduction(605));
Opendir1.Caption:=UTF8Encode(traduction(547));
tntspeedbutton7.Hint:=traduction(605);

//GENERAL CHAT
tntspeedbutton4.Caption:=traduction(25);

//PAGECONTROL TITLES

tabsheet1.Caption:=traduction(518);
tabsheet2.Caption:=traduction(519);
tabsheet3.Caption:=traduction(520);
tabsheet5.Caption:=traduction(521);
TntTabSheet1.Caption:=traduction(578);
TntTabSheet2.Caption:=traduction(600);

//DOWNLOADS LIST
VirtualStringTree4.Header.Columns[0].Text:=traduction(548);
VirtualStringTree4.Header.Columns[1].Text:=traduction(233);
VirtualStringTree4.Header.Columns[2].Text:=traduction(140);
VirtualStringTree4.Header.Columns[3].Text:=traduction(550);
VirtualStringTree4.Header.Columns[4].Text:=traduction(602);
VirtualStringTree4.Header.Columns[5].Text:='ETA';
VirtualStringTree4.Header.Columns[6].Text:=traduction(526);
VirtualStringTree4.Header.Columns[7].Text:=traduction(517);


//UPLOADS LIST
VirtualStringTree5.Header.Columns[0].Text:=traduction(549);
VirtualStringTree5.Header.Columns[1].Text:=traduction(233);
VirtualStringTree5.Header.Columns[2].Text:=traduction(140);
VirtualStringTree5.Header.Columns[3].Text:=traduction(550);
VirtualStringTree5.Header.Columns[4].Text:=traduction(603);
VirtualStringTree5.Header.Columns[5].Text:='ETA';
VirtualStringTree5.Header.Columns[6].Text:=traduction(526);
VirtualStringTree5.Header.Columns[7].Text:=traduction(517);

//REQUESTS LIST
VirtualStringTree2.Header.Columns[0].Text:=traduction(151);
VirtualStringTree2.Header.Columns[1].Text:=traduction(101);
VirtualStringTree2.Header.Columns[2].Text:=traduction(517);
VirtualStringTree2.Header.Columns[3].Text:=traduction(559);
VirtualStringTree2.Header.Columns[4].Text:=traduction(233);
VirtualStringTree2.Header.Columns[5].Text:=traduction(153);
VirtualStringTree2.Header.Columns[6].Text:=traduction(154);
VirtualStringTree2.Header.Columns[7].Text:=traduction(155);
VirtualStringTree2.Header.Columns[8].Text:=traduction(20);
VirtualStringTree2.Header.Columns[9].Text:=traduction(571);
VirtualStringTree2.Header.Columns[10].Text:=traduction(547);

VirtualStringTree3.Header.Columns[0].Text:=traduction(11); //Description
VirtualStringTree3.Header.Columns[1].Text:=traduction(417); //Server
VirtualStringTree3.Header.Columns[2].Text:=traduction(593);; //Password
VirtualStringTree3.Header.Columns[3].Text:=traduction(539); //Port

TntSpeedButton2.Caption:=traduction(80);
TntSpeedButton3.Caption:=traduction(81);
panel39.Caption:=traduction(86);
TntRichEdit2.Text:=traduction(tntrichedit2.Tag);

tntpanel7.caption:=traduction(527);
TntSpeedButton12.Caption:=traduction(80);
TntSpeedButton13.Caption:=traduction(81);

//POPUPMENUS
connect1.Caption:=utf8encode(traduction(545));
Delete1.caption:=utf8encode(traduction(33));

checkconnectionstatus; //FORZED STATUS TRANSLATION
checkchatselection;
end;

//-SERVER CODE COMPONENTS--------------------------------------------------------

procedure TFserver.FormCreate(Sender: TObject);
var
x:integer;
NewItem: Tmenuitem;
begin
cs:=TCriticalsection.create;

if testmode=false then
  pagecontrol1.Pages[6].Visible:=false;
  
Downloadlist:=Tlist.Create;
Uploadlist:=Tlist.create;

gauge1.Parent:=Fserver;
TntLabel6.Parent:=Fserver;

ImageList1.GetIcon(11,Fserver.icon);

commands:=Ttntstringlist.Create;
requests:=Ttntstringlist.Create;

reconnection:=false;
traductfserver;
checkchatselection;
pagecontrol1.ActivePageIndex:=0;

Q:=Tabsquery.create(self);
Q2:=Tabsquery.create(self);
Q3:=Tabsquery.create(self);
Q.Databasename:='RML_DATA';
Q2.DatabaseName:=Q.DatabaseName;
Q3.DatabaseName:=Q.DatabaseName;
//SPEEDUP
Q.DisableControls;
Q2.DisableControls;
Q3.DisableControls;

Q.RequestLive:=false;
Q2.RequestLive:=false;
Q3.RequestLive:=false;

TntTabSheet1.PageIndex:=0;
PageControl1.ActivePageIndex:=0;
panel38.parent:=Fserver;
tntpanel6.parent:=Fserver;

if colorcolumns=true then
  VirtualStringTree3.Header.Columns[0].Color:=clbtnface;

VirtualStringTree3.Header.SortColumn:=0;
VirtualStringTree3.Header.SortDirection:=sdAscending;

if colorcolumns=true then
  VirtualStringTree2.Header.Columns[0].Color:=clbtnface;

VirtualStringTree2.Header.SortColumn:=0;
VirtualStringTree2.Header.SortDirection:=sdAscending;

//Copy sizes and alignment of download and upload lists
for x:=0 to VirtualStringTree4.Header.Columns.Count-1 do begin
  VirtualStringTree5.Header.Columns[x].Alignment:=VirtualStringTree4.Header.Columns[x].Alignment;
  VirtualStringTree5.Header.Columns[x].Width:=VirtualStringTree4.Header.Columns[x].Width;
end;

checkconnectionstatus;

initializeemojislist;//ONLY FIRST TIME
for x:=0 to emojislist.Count-1 do begin
  NewItem := Tmenuitem.Create(TntPopupMenu2);
  TntPopupMenu2.Items.Add(NewItem);
  NewItem.Caption:=emojislist.Strings[x];
  NewItem.OnClick:=EmojiClickchat;
  Newitem.ImageIndex:=x;
end;

tntspeedbutton9.Left:=tntspeedbutton6.left;
//Emoji61.OnClick:=EmojiClickchat;
end;

//CONNECTION BUTTON METHOD
procedure TFserver.SpeedButton1Click(Sender: TObject);
var
x:integer;
n:PVirtualNode;
rec:boolean;
toinitialize:boolean;
begin
try
  IdAntiFreeze1.Active:=false;
except
end;
{
tcpForwader             := TIdMappedPortTCP.Create(nil);
tcpForwader.MappedHost  := <ServerToForwardTo>;
tcpForwader.MappedPort  := <PortOnServer>;
tcpForwader.DefaultPort := <LocalPort>;
tcpForwader.Active      := True;
}

speedbutton1.Enabled:=false;

toinitialize:=false;
rec:=reconnection;

//RECONNECTION RESET
timer2.Enabled:=false;
Timer2.Interval:=1000;
reconnection:=false;

try

if speedbutton1.Down=true then begin //TO CONNECT

  if rec=false then begin

    IdTCPClient1.host:='';
    IdTCPClient1.Tag:=0;

    if VirtualStringTree3.SelectedCount=1 then begin  //Obtain selected server data
      n:=Virtualstringtree3.GetFirst;

      for x:=0 to VirtualStringTree3.RootNodeCount-1 do begin

        if Virtualstringtree3.Selected[n]=true then begin

          Datamodule1.Qservers.RecNo:=n.Index+1;
          IdTCPClient1.ReadTimeout:=consttimeout;
          IdTCPClient1.host:=Datamodule1.Qservers.fieldbyname('IP').asstring;//NO UNICODE SUPPORT PUNYCODE????
          IdTCPClient1.Port:=Datamodule1.Qservers.fieldbyname('Port').asinteger;

        end;

        n:=VirtualStringTree3.GetNext(n);
      end;
    end//SELCOUNT
    else begin
      speedbutton1.Down:=false;
      speedbutton1.Enabled:=true;
      exit;
    end;


  end;//RECONNECT
  createpeersdb;
  DataModule1.QpeersThread.Open;

  try
    AddPortToWinFirewall(romulustitle+' - Ports',connectionport);
  except
  end;

  IdTCPServer1.defaultport:=connectionport;
  try
    IdTCPServer1.active:=false;
    IdTCPServer1.Bindings.Clear;
    IdTCPServer1.active:=true; //START SERVER
    toinitialize:=true;
    currentusername:=username;
  except //PORT OPEN ERROR
    IdTCPClient1.tag:=0;
    addeventnothread(traduction(540),clred);
    makeexception;
  end;
end
else begin //TO DISCONNECT
  try
    IdTCPServer1.Active:=false;
  except
  end;

  try
    IdTCPClient1.Disconnect;
    IdTCPClient1.tag:=0;
  except
  end;

  addeventnothread(traduction(588)+' - ['+gethostdescription(IdTCPClient1.Host,IdTCPClient1.port)+'] - '+IdTCPClient1.Host+':'+IntToStr(IdTCPClient1.Port),clred); //Disconnect forzed by user
  IdTCPClient1.host:='';
end;

except
end;

if toinitialize=true then begin
  IdAntiFreeze1.Active:=true;
  IdTCPClient1.Tag:=2;//Connectiom
  Datamodule1.Qmyquerys.Tag:=1;//FORCE REFRESH
  BMDThread1.Start;
end
else begin
  checkchatselection;
  speedbutton1.Enabled:=true;
end;

//sleep(consttimeout);

try
  checkconnectionstatus;
except
end;

freemousebuffer;
end;

procedure TFserver.FormShow(Sender: TObject);
var
x:integer;
begin
Fserver.AlphaBlendValue:=0;

{if Fmain.cooltrayicon1.tag=0 then
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE)
else
  SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
}

if VirtualStringTree3.RootNodeCount=0 then
  showserverslist;

//ONLY FIRST TIME
if speedbutton1.tag=0 then begin //BUG MAKER
  Fmain.fixcomponentsbugs(Fserver);
  RxRichEdit1.Lines.Clear;
  RxRichEdit2.Lines.Clear;
  speedbutton1.tag:=1;
  removequerysdownloadingstatus;
end;

//FIX RECOVER PREVIOUS CHAT TAB
if pagecontrol2.PageCount>=speedbutton4.Tag then
  pagecontrol2.ActivePageIndex:=speedbutton4.Tag;

Fmain.setgridlines(VirtualStringTree2,ingridlines);
Fmain.setgridlines(VirtualStringTree3,ingridlines);
Fmain.setgridlines(VirtualStringTree4,ingridlines);
Fmain.setgridlines(VirtualStringTree5,ingridlines);

TrackBar1.Position:=servertransparency;

//checkconnectionstatus;

//Position of window
if (oldserverleft>screen.DesktopRect.Right) OR (oldservertop>screen.DesktopRect.Bottom)  OR (oldserverleft-Fserver.Width<screen.DesktopRect.left-Fserver.Width-Fserver.Width) OR (oldservertop-Fserver.Height<screen.DesktopRect.Top-Fserver.Height-Fserver.Height) then begin
  oldserverleft:=-1;
  oldservertop:=-1;
end;

if (oldservertop=-1) AND (oldserverleft=-1) then begin
  oldserverleft:=Fmain.Monitor.Left+80;
  oldservertop:=Fmain.Monitor.top+80;
end;

Fserver.Top:=oldservertop;
Fserver.Left:=oldserverleft;

checkchatselection; //REMOVE BUGGY
//FIX HIGHLIGHTING
for x:=0 to PageControl1.PageCount-1 do
  if PageControl1.Pages[x].Highlighted=true then
    if pagecontrol1.ActivePageIndex<>x then
      PageControl1.Pages[x].Highlighted:=true
    else
      PageControl1.Pages[x].Highlighted:=false;

for x:=0 to PageControl2.PageCount-1 do
  if PageControl2.Pages[x].Highlighted=true then
    if pagecontrol2.ActivePageIndex<>x then
      PageControl2.Pages[x].Highlighted:=true
    else
      PageControl2.Pages[x].Highlighted:=false;

timer1.Enabled:=true;
//EnableWindow(Application.Handle, True);
end;

procedure TFserver.TrackBar1Change(Sender: TObject);
begin
Fserver.AlphaBlendValue:=trackbar1.position;
servertransparency:=Fserver.AlphaBlendValue;
end;

procedure TFserver.FormClose(Sender: TObject; var Action: TCloseAction);
begin
alphablend:=false;

Fmain.fspTaskbarMgr1.ThumbButtons.Items[0].Flags:=Fmain.fspTaskbarMgr1.ThumbButtons.Items[0].Flags-[fsttfDisable];
fservertothemax:=false;

if Fserver.WindowState=wsMaximized then begin
  fservertothemax:=true;
  Fserver.WindowState:=wsNormal;
end;

oldserverleft:=Fserver.left;
oldservertop:=Fserver.top;

//FIX FOR RECOVER CHAT TAB
speedbutton4.Tag:=PageControl2.ActivePageIndex;

end;

procedure TFserver.PageControl1Change(Sender: TObject);
var
aux:string;
ed:TTntrichedit;
begin
PageControl1.ActivePage.Highlighted:=false;

if pagecontrol1.ActivePageIndex=1 then
  tntrichedit1.SelStart:=length(tntrichedit1.text)
else
if PageControl1.ActivePageIndex=4 then begin
  try
    checkchatselection; //FORZED SETTRAYICON
    aux:=getcurrentchatid;
    ed:=(Findcomponent('CLONE_Tntrichedit3_'+aux) as Ttntrichedit);
    ed.SetFocus;
    if ed.Text='' then begin//VISUAL RARE FIX
      SystemParametersInfo(SPI_SETBEEP, 0, nil, SPIF_SENDWININICHANGE); //DISSABLE BEEP
      keybd_event(VK_LEFT, 0, 0, 0);
      application.ProcessMessages;
      SystemParametersInfo(SPI_SETBEEP, 1, nil, SPIF_SENDWININICHANGE);
    end;
  except
  end;
  Fmain.settrayicon;
end;

FormResize(sender);//Fix resizing
end;

procedure TFserver.PageControl2Change(Sender: TObject);
begin
checkchatselection;
PageControl1Change(sender);
end;

procedure TFserver.SpeedButton4Click(Sender: TObject);
begin
deletecurrentchat(sender);
end;

procedure TFserver.SpeedButton5Click(Sender: TObject);
begin
deleteallchats(sender);
end;

procedure TFserver.PageControl2DragDrop(Sender, Source: TObject; X,
  Y: Integer);
const
TCM_GETITEMRECT = $130A;
var
TabRect: TRect;
j: Integer;
begin
if (Sender is TTntpagecontrol) then
  if GetParentForm(source as TTntpagecontrol).Name='Fserver' then
    for j := 0 to PageControl2.PageCount - 1 do begin
      PageControl2.Perform(TCM_GETITEMRECT, j, LParam(@TabRect)) ;
      if PtInRect(TabRect, Point(X, Y)) then begin

        if j<=j+1 then begin
          PageControl2.ActivePage.PageIndex := j+1;
        end;

        Exit;
      end;
    end;

end;

procedure TFserver.PageControl2DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:=false;
try
  if (Sender is TTntpagecontrol) then
    if screen.ActiveForm=Fserver then
      Accept := True;
except
end;

end;

procedure TFserver.PageControl2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbLeft then
  PageControl2.BeginDrag(False) ;
end;

procedure TFserver.PageControl2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
tabindex: Integer;
begin
tabindex := PageControl2.IndexOfTabAt( X, Y );

if tabindex >= 0 then begin
  PageControl2.Hint:=(PageControl2.Pages[tabindex+1] as TTnttabsheet).Hint;
  currenthint:=PageControl2.Hint;
end;

Fmain.addclosebuttontab(Fserver,(sender as TPagecontrol),x,y,1);
end;

procedure TFserver.FormActivate(Sender: TObject);
begin

if (Application.Active=true) AND (screen.ActiveForm=Fserver) then  //0.044
  Fserver.tag:=0;   //IS ACTIVE

checkchatselection;
Fmain.settrayicon;

if fservertothemax=true then
  Fserver.WindowState:=wsMaximized;

fservertothemax:=false;

end;

procedure TFserver.SpeedButton3Click(Sender: TObject);
begin
WideForceDirectories(communitydownfolder);

if WideDirectoryExists(communitydownfolder) then
  ShellExecutew(Handle,'open', pwidechar(getshortfilename(communitydownfolder)), nil, nil, SW_SHOWNORMAL) ;

end;

procedure TFserver.SpeedButton6Click(Sender: TObject);
begin
clearcurrentchat(sender);
end;

procedure TFserver.PageControl2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if button=mbright then
  Fmain.TabMenuPopup(PageControl2, X, Y);
end;

procedure TFserver.FormResize(Sender: TObject);
var
calc:integer;
begin
calc:=(panel35.height+panel36.height) div 2;
virtualstringtree4.Height:=calc;

CenterInClient(tntlabel4,panel12);
Fmain.labelshadow(tntlabel4,Fserver);

CenterInClient(panel38,fserver);
CenterInClient(tntpanel6,fserver);

scrollrichedits;
end;

procedure TFserver.Timer1Timer(Sender: TObject);
begin
timer1.Enabled:=false;

scrollrichedits;//EFFECT

AlphaBlend:=true;
TrackBar1Change(sender);//Recover transparency
end;

//----------------------------------------------

procedure TFserver.SpeedButton8Click(Sender: TObject);
begin
VirtualStringTree2.Repaint;
end;

procedure TFserver.SpeedButton7Click(Sender: TObject);
begin
VirtualStringTree2.Repaint;
end;

procedure TFserver.PopupMenu1Popup(Sender: TObject);
var
b:boolean;
begin
b:=false;
if virtualstringtree2.SelectedCount>0 then
  b:=true;

Resumeselection1.Enabled:=b;
Pauseselection1.Enabled:=b;
Deleteselection1.Enabled:=b;
Priority1.Enabled:=b;
end;

procedure TFserver.selectall1Click(Sender: TObject);
begin
VirtualStringTree2.SelectAll(true);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFserver.Invertselection1Click(Sender: TObject);
begin
VirtualStringTree2.InvertSelection(true);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFserver.Deleteselection1Click(Sender: TObject);
var
done:boolean;
x:integer;
n:Pvirtualnode;
pos:integer;
begin
done:=false;
pos:=-1;

if VirtualStringTree2.SelectedCount>0 then begin

  n:=VirtualStringTree2.GetLast;

  for x:=VirtualStringTree2.RootNodeCount-1 downto 0 do begin

    if virtualstringtree2.Selected[n]=true then begin
      Datamodule1.Qmyquerysview.RecNo:=x+1;

      if Datamodule1.Tmyquerys.Locate('ID',Datamodule1.Qmyquerysview.fieldbyname('ID').asinteger,[]) then begin
        Datamodule1.Tmyquerys.Delete;
        pos:=x;
      end;
    end;

    n:=VirtualStringTree2.Getprevious(n);
  end;
  done:=true;

end;

if done=true then begin
  Fmain.showmyquerys;
  pos:=pos-1;
  if pos<0 then
    pos:=0;
              
  posintoindex(pos,virtualstringtree2);
  DataModule1.Qmyquerys.Tag:=1;//FORZE REFRESH
end;

end;

//QUEUES LISTING
procedure TFserver.VirtualStringTree2GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
p:string;
begin
Datamodule1.Qmyquerysview.RecNo:=node.Index+1;
Datamodule1.Tmyquerys.Locate('ID',Datamodule1.Qmyquerysview.fieldbyname('ID').asinteger,[]);

case column of
  0:celltext:=getwiderecord(Datamodule1.Qmyquerysview.fieldbyname('Filename'));
  1:celltext:=getwiderecord(Datamodule1.Qmyquerysview.fieldbyname('Setname'));
  2:celltext:=getwiderecord(Datamodule1.Qmyquerysview.fieldbyname('Profilename'));
  3:begin
    p:=Datamodule1.Qmyquerysview.fieldbyname('Priority').asstring;
    if p='2' then
      celltext:=traduction(46)
    else
    if p='0' then
      celltext:=traduction(48)
    else
      celltext:=traduction(47);
    end;
  4:begin
      if showasbytes=false then
        celltext:=(bytestostr(Datamodule1.Qmyquerysview.fieldbyname('Size_').ascurrency))
      else
        celltext:=(pointdelimiters(Datamodule1.Qmyquerysview.fieldbyname('Size_').ascurrency)+' bytes');
  end;
  5:celltext:=Datamodule1.Qmyquerysview.fieldbyname('CRC').asstring;
  6:celltext:=Datamodule1.Qmyquerysview.fieldbyname('MD5').asstring;
  7:celltext:=Datamodule1.Qmyquerysview.fieldbyname('SHA1').asstring;
  8:celltext:=Datamodule1.Qmyquerysview.fieldbyname('Added').asstring;
  9:celltext:=Datamodule1.Qmyquerysview.fieldbyname('Completed').asstring;
  10:celltext:=getwiderecord(Datamodule1.Tmyquerys.fieldbyname('Downpath'));
end;

end;

//QUEUES LISTING IMAGES
procedure TFserver.VirtualStringTree2HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
var
x:integer;
begin
if HitInfo.Button <> mbLeft then
  exit;
  
if HitInfo.Column=-1 then
  exit;

if virtualstringtree2.Header.Columns[Hitinfo.column].Tag=0 then
  virtualstringtree2.Header.Columns[Hitinfo.column].Tag:=1
else
if virtualstringtree2.Header.Columns[Hitinfo.column].Tag=1 then
  virtualstringtree2.Header.Columns[Hitinfo.column].Tag:=2
else
  virtualstringtree2.Header.Columns[Hitinfo.column].Tag:=1;

virtualstringtree2.Header.SortColumn:=Hitinfo.column;

if virtualstringtree2.Header.Columns[Hitinfo.column].Tag=1 then
  virtualstringtree2.Header.SortDirection:=sdAscending
else
  virtualstringtree2.Header.SortDirection:=sdDescending;

for x:=0 to VirtualStringTree2.header.Columns.Count-1 do
  if x<>Hitinfo.column then begin
    virtualstringtree2.Header.Columns[x].Tag:=0;
    virtualstringtree2.Header.Columns[x].color:=clWindow;
  end
  else
    if colorcolumns=true then
      virtualstringtree2.Header.Columns[x].color:=clbtnface
    else
      virtualstringtree2.Header.Columns[x].color:=clWindow;

Fmain.showmyquerys;
end;

procedure TFserver.VirtualStringTree2GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
p:string;
begin
if column=0 then begin
  Datamodule1.Qmyquerysview.RecNo:=node.Index+1;

  if Kind=ikState then begin

    Datamodule1.Tmyquerys.locate('ID',Datamodule1.Qmyquerysview.fieldbyname('ID').asinteger,[]);
    p:=Datamodule1.Tmyquerys.fieldbyname('Status').asstring;//REAL TIME READ

    if p='' then begin//WAITING
      if speedbutton7.Down=true then
        imageindex:=0
      else
        imageindex:=3;
    end
    else
    if p='C' then //COMPLETE
      imageindex:=2
    else
    if p='D' then //DOWNLOADING
      imageindex:=1
    else
    if p='S' then //STOPPED
      imageindex:=4;
  end
  else
  if kind<>ikOverlay then begin
    imageindex:=Datamodule1.Qmyquerysview.fieldbyname('type').asinteger;
  end;

end;

end;

//USERS LIST DISPLAY
procedure TFserver.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
Datamodule1.Qpeers.RecNo:=node.Index+1;

celltext:=getwiderecord(Datamodule1.Qpeers.fieldbyname('Description'));

if virtualstringtree1.Selected[node]=true then
  selectedpeer:=Datamodule1.Qpeers.fieldbyname('ID').asinteger;
  
end;

//USERS LIST DISLAY IMAGES
procedure TFserver.VirtualStringTree1GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
Datamodule1.Qpeers.RecNo:=node.Index+1;

//SEARCH TAB OF CHAT IF NOT EXISTS NORMAL GREEN ELSE MAIL GREEN
if Kind=ikState then begin
  if Datamodule1.Qpeers.fieldbyname('Yourself').asboolean=true then
    imageindex:=9
  else
  if FindComponent('CLONE_Tabsheet4_'+changein(Datamodule1.Qpeers.fieldbyname('IP').asstring,'.','o'))<>nil then
    ImageIndex:=7
  else
    ImageIndex:=8;
end;

end;

//START A CHAT WITH A USER
procedure TFserver.VirtualStringTree1DblClick(Sender: TObject);
begin
if (VirtualStringTree1.SelectedCount<>0) then begin
  addchat(selectedpeer,'',true);//SET CHAT WITHOUT MESSAGE
end;
end;

//ADD SERVERS BUTTON
procedure TFserver.TntSpeedButton1Click(Sender: TObject);
var
port:integer;
value,desc:widestring;
begin
value:=widelowercase(trim(tntedit2.text));
desc:=trim(tntedit1.Text);
tntedit4.Text:=trim(tntedit4.Text);

port:=10000;

if value='' then
  exit;

if desc='' then
  desc:=value;
  
try
  port:=strtoint(tntedit3.Text);
except
end;

port:=checkvalidinternetport(port,10000);

if Datamodule1.Qservers.Locate('IP;Port',VarArrayOf([value, port]),[loCaseInsensitive])=true then begin
  posintoindex(Datamodule1.Qservers.recno-1,virtualstringtree3);
  VirtualStringTree3.SetFocus;
  tntedit1.Text:='';
  tntedit2.text:='';
  tntedit3.Text:='';
  tntedit4.Text:='';
  communitymessage(597,false);
  exit;
end
else
  Datamodule1.Tservers.Append;

setwiderecord(Datamodule1.Tservers.FieldByName('Description'),desc);
setwiderecord(Datamodule1.Tservers.FieldByName('IP'),value);
setwiderecord(Datamodule1.Tservers.FieldByName('Password'),tntedit4.Text);
Datamodule1.Tservers.FieldByName('Port').asinteger:=port;
Datamodule1.Tservers.Post;

showserverslist;
Datamodule1.Qservers.Locate('ID',Datamodule1.Tservers.fieldbyname('ID').asinteger,[]);

posintoindex(Datamodule1.Qservers.RecNo-1,virtualstringtree3);
VirtualStringTree3.SetFocus;
tntedit1.Text:='';
tntedit2.text:='';
tntedit3.Text:='';
tntedit4.Text:='';
end;

//DISPLAY SERVERS LIST
procedure TFserver.VirtualStringTree3GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
Datamodule1.Qservers.recno:=node.Index+1;

case column of
  0:celltext:=getwiderecord(Datamodule1.Qservers.Fieldbyname('Description'));
  1:celltext:=getwiderecord(Datamodule1.Qservers.Fieldbyname('IP'));
  2:celltext:=getwiderecord(Datamodule1.Qservers.Fieldbyname('Password'));
  3:celltext:=Datamodule1.Qservers.fieldbyname('Port').asstring;
end;

if VirtualStringTree3.Selected[node]=true then
  virtualstringtree3.Tag:=Datamodule1.Qservers.Fieldbyname('ID').asinteger;

end;

//PORT INSERTION CHECK
procedure TFserver.TntEdit3Change(Sender: TObject);
begin
try
  Filteredit(sender);
except
end;

end;

//SORTING HEADER CLICK SERVER LIST
procedure TFserver.VirtualStringTree3HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
var
x:integer;
begin
if HitInfo.Button <> mbLeft then
  exit;

if HitInfo.Column=-1 then
  exit;

if virtualstringtree3.Header.Columns[Hitinfo.column].Tag=0 then
  virtualstringtree3.Header.Columns[Hitinfo.column].Tag:=1
else
if virtualstringtree3.Header.Columns[Hitinfo.column].Tag=1 then
  virtualstringtree3.Header.Columns[Hitinfo.column].Tag:=2
else
  virtualstringtree3.Header.Columns[Hitinfo.column].Tag:=1;

virtualstringtree3.Header.SortColumn:=Hitinfo.column;

if virtualstringtree3.Header.Columns[Hitinfo.column].Tag=1 then
  virtualstringtree3.Header.SortDirection:=sdAscending
else
  virtualstringtree3.Header.SortDirection:=sdDescending;

for x:=0 to VirtualStringTree3.header.Columns.Count-1 do
  if x<>Hitinfo.column then begin
    virtualstringtree3.Header.Columns[x].Tag:=0;
    virtualstringtree3.Header.Columns[x].color:=clWindow;
  end
  else
    if colorcolumns=true then
      virtualstringtree3.Header.Columns[x].color:=clbtnface
    else
      virtualstringtree3.Header.Columns[x].color:=clWindow;

showserverslist;
end;

//CONVERT TO ASCII UNICODE SERVER INSERTION
procedure TFserver.TntEdit2Change(Sender: TObject);
begin
end;

//DISPLAY IN SERVER LIST CORRECT IMAGES
procedure TFserver.VirtualStringTree3GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
Datamodule1.Qservers.recno:=node.Index+1;

if (Kind<>ikState) AND (kind<>ikOverlay) then
  if column=0 then begin
    if (IdTCPClient1.host=Datamodule1.Qservers.FieldByName('IP').asstring) AND (IdTCPClient1.Port=Datamodule1.Qservers.FieldByName('Port').asinteger) AND (IdTCPClient1.tag=1) then
     imageindex:=5
    else
      imageindex:=6;

  end;
end;


procedure TFserver.BMDThread1Update(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer; Percent: Integer);
var
msg:widestring;
x:integer;
totalup,totaldown,etacalc,aux:int64;
etastr:string;
p:Currency;
upwide,downwide:widestring;
n:Tcomponent;
begin
BMDThread1.UpdateEnabled:=false;


try
    label3.Caption:=datetimetostr(now);
    tntlistbox1.Items:=requests;
    label5.Caption:=inttostr(requests.Count);
    tntlistbox2.Items:=commands;
    label7.Caption:=inttostr(commands.Count);
except
end;


totalup:=0;
totaldown:=0;

try

//SEND FILES OTHER USERS NEED
if (upslots>virtualstringtree5.RootNodeCount) AND (requests.count>0) then begin//NO SLOTS THEN SKIP

  msg:=requests.Strings[0];

  try
    requests.strings[0]:='';//SECURITY
    requests.Delete(0);
  except
  end;

  //CREATE UPLOAD THREAD FROM A REQUEST
  //USERQUEUEID*filename*size*CRC32*MD5*SHA1*Profilename*USERID
  etastr:=gettoken(msg,separator,gettokencount(msg,separator));

  //DESTROY ALL UPLOAD THREADS
  while Threadstodestroy.Count>0 do begin
    try
      n:=(FindComponent(Threadstodestroy.Strings[0]) as Tbmdthread);
      if n<>nil then
        Freeandnil(n);

      Threadstodestroy.Delete(0);
    except
    end;
  end;

  //uploadfile(msg,idofip(etastr),true);//NO SYNC NEEDED

end;

except
  on E : Exception do
  begin
    label9.caption:=('Exception class name = '+E.ClassName);
    label10.caption:=('Exception message = '+E.Message);
  end;
end;


if (IdTCPClient1.Tag=0) AND (virtualstringtree1.RootNodeCount<>0) then begin //NO USER WHEN DISCONNECT
  showpeerslist(sender);
end;


for x:=0 to Uploadlist.Count-1 do begin
  try
    if Ttransfers(Uploadlist[x]).Downsize<>0 then begin

      etacalc:=Ttransfers(Uploadlist[x]).olddown;
      aux:=Ttransfers(Uploadlist[x]).Downsize;
      etacalc:=aux-etacalc;
      Ttransfers(Uploadlist[x]).Aolddown:=aux;
      Ttransfers(Uploadlist[x]).Aspeed:=etacalc;

      totalup:=totalup+Ttransfers(Uploadlist[x]).speed;
      Ttransfers(Uploadlist[x]).Adownsizedisp:=bytestostr(Ttransfers(Uploadlist[x]).Downsize);
      Ttransfers(Uploadlist[x]).Aspeeddisp:=bytestostr(Ttransfers(Uploadlist[x]).speed)+'/s';
      Ttransfers(Uploadlist[x]).Apbar.Progress:=Ttransfers(Uploadlist[x]).Downsize;
      p:=(Ttransfers(Uploadlist[x]).Downsize*100) / (Ttransfers(Uploadlist[x]).Atotalsize);
      if p>100 then //FIX
        p:=100;

      Ttransfers(Uploadlist[x]).Aplabel.caption:=checknan(FormatFloat('0.00',p)+' %');

      //ETA
      etacalc:=Ttransfers(Uploadlist[x]).Totalsize-Ttransfers(Uploadlist[x]).Downsize;
      etacalc:=etacalc*1000 div Ttransfers(Uploadlist[x]).speed;
      etastr:=FormatInClock(etacalc);
      Ttransfers(Uploadlist[x]).AETA:=etastr;
    end;
  except
  end;

end;

for x:=0 to Downloadlist.Count-1 do begin
  try //PREVENT DIV BY ZERO ERROR
    if Ttransfers(Downloadlist[x]).Downsize<>0 then begin

      etacalc:=Ttransfers(Downloadlist[x]).olddown;
      aux:=Ttransfers(Downloadlist[x]).Downsize;
      etacalc:=aux-etacalc;
      Ttransfers(Downloadlist[x]).Aolddown:=aux;
      Ttransfers(Downloadlist[x]).Aspeed:=etacalc;

      totaldown:=totaldown+Ttransfers(Downloadlist[x]).speed;
      Ttransfers(Downloadlist[x]).Adownsizedisp:=bytestostr(Ttransfers(Downloadlist[x]).Downsize);
      Ttransfers(Downloadlist[x]).Aspeeddisp:=bytestostr(Ttransfers(Downloadlist[x]).speed)+'/s';
      Ttransfers(Downloadlist[x]).Apbar.Progress:=Ttransfers(Downloadlist[x]).Downsize;
      p:=(Ttransfers(Downloadlist[x]).Downsize*100) / (Ttransfers(Downloadlist[x]).Atotalsize);
      if p>100 then
        p:=100;
      Ttransfers(Downloadlist[x]).Aplabel.caption:=checknan(FormatFloat('0.00',p)+' %');

      //ETA
      etacalc:=Ttransfers(Downloadlist[x]).Totalsize-Ttransfers(Downloadlist[x]).Downsize;
      etacalc:=etacalc*1000 div Ttransfers(Downloadlist[x]).speed;

      etastr:=FormatInClock(etacalc);
      Ttransfers(Downloadlist[x]).AETA:=etastr;
    end;
  except
  end;
end;

if downspeed=0 then
  downwide:=widechar($221E)
else
  downwide:=BytesToStr(downspeed*1024)+'/s';

if upspeed=0 then
  upwide:=widechar($221E)
else
  upwide:=BytesToStr(upspeed*1024)+'/s';

globaldownspeed:=totaldown div 1024; //Kb

tntspeedbutton14.Caption:=bytestostr(totaldown)+'/s'+' ['+downwide+']';
tntspeedbutton15.Caption:=bytestostr(totalup)+'/s'+' ['+upwide+']';

tntspeedbutton10.Caption:=inttostr(Downloadlist.Count)+'/'+inttostr(downslots);
tntspeedbutton11.caption:=inttostr(Uploadlist.count)+'/'+inttostr(upslots);

virtualstringtree4.repaint;
virtualstringtree5.repaint;

BMDThread1.UpdateEnabled:=true;
end;

//CONNECTION LOOP
procedure TFserver.BMDThread1Execute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
elapsed:TDateTime;
useridcnt:ansistring;
temp:widestring;
aux,desc:widestring;
ip,port:string;
polarity,polinverse:boolean;
messagecounter:int64;
begin
{COMMANDS
I=GET TO SERVER USERS ID
U=GET USERS LIST
X=MESSAGES COUNTER
}

messagecounter:=-1;
polarity:=false;
elapsed:=now;
useridcnt:='';
IdTCPClient1.ReadTimeout:=5000;

currentuserip:=getinternetip;//BUG

while IdTCPServer1.Active=true do begin

  if IdTCPClient1.Tag=1 then begin //CONNECTED

    elapsed:=now;

    try
      //1. USERS LIST CHECK--------------------------------------------------------
      IdTCPclient1.WriteLn('I');//USER ID
      temp:=IdTCPclient1.ReadLn;

      if temp<>useridcnt then begin //GET USERS LIST

        if polarity=true then begin
          polarity:=false;
          polinverse:=true;
        end
        else begin
          polarity:=true;
          polinverse:=false;
        end;

        //ADD YOURSELF
        if Datamodule1.Tpeers.Locate('IP',currentuserip,[])=true then
          Datamodule1.Tpeers.Edit
        else
          Datamodule1.Tpeers.Append;

        setwiderecord(Datamodule1.Tpeers.FieldByName('Description'),currentusername);
        Datamodule1.Tpeers.FieldByName('IP').asstring:=currentuserip;
        Datamodule1.Tpeers.FieldByName('Port').asinteger:=0; //NO MATTER
        Datamodule1.Tpeers.FieldByName('Polarity').asboolean:=polarity;
        Datamodule1.Tpeers.FieldByName('Yourself').asboolean:=true;

        Datamodule1.Tpeers.Post;

        IdTCPclient1.WriteLn('U');//USERS LIST
        aux:=Decrypt(IdTCPClient1.ReadLn);

        while aux<>'' do begin

          aux:=UTF8Decode(aux);
          //description+ip+port
          ip:=gettoken(aux,separator,2);
          desc:=gettoken(aux,separator,1);
          port:=gettoken(aux,separator,3);

          //thread.Synchronize(addeventerrorsync,Pwidechar(desc));

          if isvalidip(ip)=false then //SECURITY CHECK
            break;

          if currentuserip<>ip then //IGNORE YOURSEL
          if Datamodule1.Tpeers.Locate('IP',ip,[])=true then begin
            try
              Datamodule1.Tpeers.edit;
              setwiderecord(Datamodule1.Tpeers.FieldByName('Description'),desc);
              Datamodule1.Tpeers.FieldByName('Port').asinteger:=strtoint(port);
              Datamodule1.Tpeers.FieldByName('Polarity').asboolean:=polarity;
              Datamodule1.Tpeers.post;
            except
              Datamodule1.Tpeers.cancel;
            end;
          end
          else begin
            try
              Datamodule1.Tpeers.append;

              setwiderecord(Datamodule1.Tpeers.FieldByName('Description'),desc);
              Datamodule1.Tpeers.FieldByName('IP').asstring:=ip;
              Datamodule1.Tpeers.FieldByName('Port').asinteger:=strtoint(port);
              Datamodule1.Tpeers.FieldByName('Polarity').asboolean:=polarity;
              Datamodule1.Tpeers.FieldByName('Yourself').asboolean:=true;
              Datamodule1.Tpeers.FieldByName('Yourself').asboolean:=false;

              Datamodule1.Tpeers.post;
            except
            end;
          end;

          aux:=Decrypt(IdTCPClient1.ReadLn);
        end;

        useridcnt:=temp;

        if Datamodule1.Tpeers.RecordCount>0 then
          while Datamodule1.Tpeers.Locate('Polarity',polinverse,[]) do
            Datamodule1.Tpeers.Delete;

        //REFRESH USERS LIST
        BMDThread1.Thread.Synchronize(showpeerslist);

        //FORCE REFRESH PEERS LIST AT THREAD
        Datamodule1.QpeersThread.Tag:=1;
      end;

      //2. RECEIVE GENERAL CHAT MESSAGES---------------------------------------------------
      if messagecounter=-1 then begin
        IdTCPclient1.WriteLn('C');//CURRENT MESSAGECOUNTER
        messagecounter:=strtoint(IdTCPclient1.ReadLn);
        IdTCPclient1.WriteLn('W');//WELLCOME MESSAGE
        temp:=UTF8Decode(Decrypt(IdTCPclient1.ReadLn));

        cs.Enter;
        paramwidestr1:=temp;
        Thread.Synchronize(addwellcomemessagethread);
        cs.Leave;
      end;

      IdTCPclient1.Writeln('X');//MESSAGES ID
      IdTCPclient1.WriteLn(inttostr(messagecounter));

      temp:=UTF8Decode(decrypt(IdTCPclient1.ReadLn));

      while temp<>'' do begin
        //INSERT MESSAGE
        cs.Enter;
        paramwidestr1:=gettoken(temp,separator,2);//MESSAGE
        paramstr1:=gettoken(temp,separator,1);//IP
        Thread.Synchronize(addglobalmessagethread);
        messagecounter:=messagecounter+1;
        cs.Leave;

        temp:=UTF8Decode(decrypt(IdTCPclient1.ReadLn));
      end;

      //3. SEND GENERAL MESSAGES--------------------------------------------------------
      if sendmsg<>'' then begin
        sendmsg:=Encrypt(UTF8Encode(sendmsg));

        try
          IdTCPClient1.WriteLn('M');
          IdTCPClient1.WriteLn(sendmsg);
        except
        end;

        sendmsg:='';
        thread.Synchronize(enablesendbutton);
      end;

      //SEND MY REQUESTS                                                                                                      //NOT IN PROCESS                        //NOT PAUSED
      if (downslots>virtualstringtree4.RootNodeCount) AND (virtualstringtree2.RootNodeCount>0) AND (virtualstringtree1.rootnodecount>1) AND (Threadsendrequests.tag=0) AND (speedbutton7.down=true) then  //NO SLOTS THEN SKIP
        thread.Synchronize(sendmyrequests);

    except //IF TIMEOUT DO NOTHING 0.037
      try
        IdTCPClient1.CheckForDisconnect(true,true);
        IdTCPClient1.CheckForGracefulDisconnect(true);
      except
        IdTCPClient1.Disconnect;
        IdTCPClient1.Tag:=0;
        if speedbutton1.Down=true then begin //0.037
          thread.Synchronize(addeventerrorsync,Pwidechar(traduction(552)));
        end;
      end;

    end;

  end
  else begin
    messagecounter:=-1;
    if IdTCPClient1.Tag=2 then begin //CONNECTING TO SERVER FIRST TIME
      thread.Synchronize(reconnect);
      elapsed:=now;
    end
    else
    if (SecondsBetween(now,elapsed)>=60) OR (SecondsBetween(now,elapsed)<0) then begin
      Thread.Synchronize(reconnect);
      elapsed:=now;
    end;
  end;

  if agressive=true then
    sleep(250)
  else
    sleep(1000);
end;

thread.Terminate;
end;

procedure TFserver.VirtualStringTree3DblClick(Sender: TObject);
begin
if VirtualStringTree3.SelectedCount=0 then
  exit;

end;

procedure TFserver.SpeedButton2Click(Sender: TObject);
var
ed:TTntrichedit;
rich:TRxRichEdit;
ip,aux:string;
msg:TIdTCPClient;
pass:boolean;
sendmsg:widestring;
Q:Tabsquery;
begin
pass:=false;
if (sender as TTntSpeedButton).Enabled=false then
  exit;

aux:=getcurrentchatid;
ip:=changein(aux,'o','.');

ed:=(FindComponent('CLONE_Tntrichedit3_'+aux) as TTntrichedit);
rich:=(FindComponent('CLONE_RxRichedit3_'+aux) as TRxrichedit);

sendmsg:=trim(ed.Text);

if sendmsg='' then begin
  ed.Text:='';
  exit;
end;

(sender as Ttntspeedbutton).Enabled:=false;
Q:=Tabsquery.Create(self);
Q.DatabaseName:=Datamodule1.DBPeers.Name;
Q.SQL.Add('SELECT * FROM Peers WHERE IP = '+''''+ip+'''');
Q.open;

if Q.IsEmpty=false then begin

  msg:=TIdTCPClient.Create(self);
  msg.Name:='con_'+aux;
  msg.ReadTimeout:=consttimeout;
  msg.Host:=ip;
  msg.Port:=Q.fieldbyname('Port').asinteger;

  try
    msg.Connect(consttimeout);
    msg.WriteLn('M'); //MESSAGE
    msg.WriteLn(Encrypt(utf8encode(sendmsg)));
    pass:=true;
  except
  end;

end;

if pass=true then begin
  insertrichtextchat(rich,sendmsg,imagelist3,clblue,currentusername);
  ed.Text:='';
  ed.SetFocus;
end
else begin
  insertrichtextchat(rich,traduction(599),imagelist3,clred,'');                                                                                              //ERROR SENDING MESSAGE
end;

try
  Freeandnil(msg);
except
end;

if Q.Locate('IP',ip,[])=true then //STILL CONNECTED ELSE DISABLED
  (sender as Ttntspeedbutton).Enabled:=true;

try
  Freeandnil(Q);
except
end;

end;

procedure TFserver.IdTCPServer1Connect(AThread: TIdPeerThread);
var
pass:boolean;
begin
//ACCEPT MESSAGES FROM IN LIST USERS
rarebugconnectionfixer;
pass:=true;   

try
  if idofip(Athread.Connection.Socket.Binding.PeerIP)=0 then
    pass:=false;
except
  pass:=false;
end;

if pass=false then begin
  athread.Connection.Disconnect;
  Athread.Terminate;
end;


end;



procedure TFserver.IdTCPServer1Execute(AThread: TIdPeerThread);
var
aux:widestring;
Fstream:Tgphugefilestream;
filename:widestring;
maxsize,sum:int64;
idcomp:string;
tick2:Longint;
sleeptime:int64;
str,reqid:ansistring;
Q:Tabsquery;
pass:boolean;
toprofilename:widestring;
//th:TIdIOHandlerThrottle;
//io:TIdIOHandlerStream;
begin
rarebugconnectionfixer;
{COMMANDS
M=MESSAGE M+ID+MESSAGE
F=FILE SIZE+CRC+MD5+SHA1
}
//AThread.Connection.IOHandler := IdIOHandlerThrottle1;

Athread.Connection.ReadTimeout:=consttimeout;
idcomp:='';
pass:=false;

try
  aux:=AThread.Connection.ReadLn;

  if aux='R' then begin //REQUESTS

    while requests.count<=1000 do begin

      aux:=UTF8Decode(Decrypt(AThread.Connection.ReadLn))+separator+Athread.Connection.Socket.Binding.PeerIP;

      cs.Enter; //CRITICAL SECTION START

      if aux='' then begin //EOF
        cs.Leave;
        break;
      end
      else
      if requests.IndexOf(aux)=-1 then
        requests.add(aux);

      cs.Leave;  //CRITICAL SECTION END

    end;

  end
  else
  if aux='M' then begin //MESSAGES
    aux:=UTF8Decode(Decrypt(AThread.Connection.ReadLn));

    cs.enter;  //CRITICAL SECTION START
    paramint64:=idofip(Athread.Connection.Socket.Binding.PeerIP);
    paramwidestr1:=aux;
    AThread.Synchronize(addchatthread);
    cs.Leave;   //CRITICAL SECTION END
  end
  else
  if (aux='F') OR (aux='S') then begin  //F=RECEIVE MANUALLY S=RECEIVE BY REQUEST

    if aux='S' then begin
      //DIASTOLE
      //CHECK IF IS VALID
      //toid+separator+tosize+separator+tocrc+separator+tomd5+separator+tosha1
      str:=Decrypt(Athread.Connection.readln);

      if (speedbutton8.Down=true) then  //PAUSED LIST THEN REVOQUE FILE
        Athread.connection.writeln('1')
      else
      if VirtualStringTree4.RootNodeCount>=downslots then begin //MAX DOWNLOAD SLOTS THEN REVOQUE
        Athread.connection.writeln('1')
      end
      else
        try
          reqid:=gettoken(str,separator,1);
          Q:=Tabsquery.Create(self);
          Q.DatabaseName:='DBMyquerys';
          Q.SQL.Text:='SELECT * FROM Querys WHERE ID='+reqid;
          Q.Open;

          if Q.RecordCount=1 then
            if Q.fieldbyname('Status').asstring='' then //WAITING
              if (Q.fieldbyname('Size_').asstring=gettoken(str,separator,2)) AND (Q.fieldbyname('CRC').asstring=gettoken(str,separator,3)) AND (Q.fieldbyname('MD5').asstring=gettoken(str,separator,4)) AND (Q.fieldbyname('SHA1').asstring=gettoken(str,separator,5)) then begin
                toprofilename:=getwiderecord(Q.FieldByName('Profilename'));
                Athread.Connection.WriteLn('0');
                pass:=true;
              end;

          if pass=false then
            Athread.connection.writeln('1');

        finally
          freeandnil(Q);
        end;
    end
    else begin//ACCEPT MANUALLY
      filename:=UTF8Decode(Decrypt(Athread.Connection.readln));
      maxsize:=strtoint(gettoken(filename,separator,2));
      filename:=gettoken(filename,separator,1);
      //MESSAGE TO ACCEPT
      Athread.Connection.WriteLn('0');//ACCEPT
      pass:=true;
    end;

    if pass=true then begin

      if aux='S' then begin
        filename:=UTF8Decode(decrypt(Athread.Connection.readln));
        //SIZE
        maxsize:=strtoint64(Athread.Connection.readln);
        filename:=communitydownfolder+'Requests\'+removeconflictchars(toprofilename,false)+'\'+filename;

        if FileExists2(filename)=true then
          makeexception;

      end
      else begin
        filename:=communitydownfolder+'Users\'+nickofip(Athread.Connection.Socket.Binding.PeerIP)+'\'+filename;
        //Athread.Connection.ReadTimeout:=30000;
      end;

      WideForceDirectories(WideExtractFilePath(filename));//FORCES MAKE PATH

      filename:=getvaliddestination(filename); //PREVENT OVERWRITE

      //CHECK FOR VALID
      try                                                //cache size
        //CHANGE DB STATUS

        Fstream:= Tgphugefilestream.Createw(filename,accWrite,[hfoBuffered],0,0,0,0,20,1048576,0);//1048576=1Mb*
        sum:=0;

        idcomp:='DOWN'+inttostr(AThread.ThreadID);

        cs.Enter;  //CRITICAL SECTION START
        paramwidestr1:=idcomp+separator+inttostr(maxsize)+separator+filename+separator+Athread.Connection.Socket.Binding.PeerIP+separator+reqid+separator+toprofilename;
        AThread.Synchronize(createdownloadline);
        cs.Leave;  //CRITICAL SECTION END

        tick2:=Gettickcount;
        sleeptime:=100;

        while sum<maxsize do begin

          sum:=sum+HASHBUFFSIZE;

          AThread.Connection.ReadStream(Fstream,-1,false);

          if gettickcount-tick2>=1000 then begin //1SECOND

            if sum>maxsize then //FIX
              sum:=maxsize;

            cs.Enter;  //CRITICAL SECTION START
            paramstr1:=idcomp;
            paramint64:=sum;
            athread.Synchronize(updatedownloadrate);
            cs.Leave;  //CRITICAL SECTION END

            if downspeed>0 then begin
              if globaldownspeed>downspeed then begin
                sleeptime:=sleeptime+1;
              end
              else
                if sleeptime>0 then
                  sleeptime:=sleeptime-1;

              sleep(sleeptime);
            end;

            tick2:=GetTickCount;
          end;

        end;

        //FINAL
        sum:=maxsize;
        cs.Enter;  //CRITICAL SECTION START
        paramstr1:=idcomp;
        paramint64:=sum;
        athread.Synchronize(updatedownloadrate);
        cs.Leave;  //CRITICAL SECTION END

      except
      end;

      //sleep(1000);//WAIT FOR UPDATE

      Freeandnil(Fstream);
    end;

  end;//F S
except
end;

try
  Athread.Connection.Disconnect;
except
end;

if idcomp<>'' then begin //END DOWNLOAD FILE
  cs.Enter; //CRITICAL SECTION START
  paramstr1:=idcomp;
  paramstr2:=reqid;
  AThread.Synchronize(deletedownline);
  cs.Leave;  //CRITICAL SECTION END
end;

Athread.Terminate;
end;

procedure TFserver.TntSpeedButton2Click(Sender: TObject);
begin
AnimateWindow(Panel38.Handle, 150,   AW_CENTER or  AW_HIDE);
panel38.visible:=false;

panel6.enabled:=true;
panel9.enabled:=true;
panel19.enabled:=true;
pagecontrol1.Enabled:=true;
panel13.Enabled:=true;

//TODO THINGS BY TRANSLATIONID PANEL38.TAG
case panel38.Tag of
  0:
end;

end;

procedure TFserver.TntSpeedButton3Click(Sender: TObject);
begin
AnimateWindow(Panel38.Handle, 150,   AW_CENTER or  AW_HIDE);
panel38.visible:=false;
panel6.enabled:=true;
panel9.enabled:=true;
panel19.enabled:=true;
pagecontrol1.Enabled:=true;
panel13.Enabled:=true;
end;

procedure TFserver.BMDThread1Start(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
IdTCPClient1.Tag:=2;
checkconnectionstatus;
end;

procedure TFserver.Timer2Timer(Sender: TObject);
begin
if Timer2.Interval=1000 then begin
  reconnection:=true;
  timer2.Interval:=60000;
end
else begin
  timer2.Enabled:=False;
  timer2.Interval:=1000;
  SpeedButton1Click(sender);
end;

end;

procedure TFserver.BMDThread1Terminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
x:integer;
idtcp:TIdTCPClient;
begin
//KILL AND DESTROY ALL CREATED SOCKETS
for x:=Fserver.ComponentCount-1 downto 0 do
  if (Fserver.Components[x] is TIdTCPClient) then   //
    if (uppercase((Fserver.Components[x] as TIdTCPClient).name)<>'IDTCPCLIENT1') AND (uppercase((Fserver.Components[x] as TIdTCPClient).name)<>'IDTCPCLIENT2') then begin
      idtcp:= (Fserver.Components[x] as TIdTCPClient);
      try
       idtcp.Disconnect;
      except
      end;
      try
        Freeandnil(idtcp);
      except
      end;
    end;

//CONVERT ALL DOWNLOADING STATUS TO WAITING
removequerysdownloadingstatus;

checkconnectionstatus;
end;

procedure TFserver.TntPopupMenu1Popup(Sender: TObject);
var
b:boolean;
begin
b:=false;
if VirtualStringTree3.SelectedCount<>0 then
  b:=true;

Delete1.Enabled:=b;


if (speedbutton1.Enabled=false) OR (speedbutton1.Down=true) then
  b:=false;

Connect1.Enabled:=b;
end;

procedure TFserver.Connect1Click(Sender: TObject);
begin
if SpeedButton1.Down=False then
  speedbutton1.Down:=true;

SpeedButton1Click(sender);
end;

procedure TFserver.Delete1Click(Sender: TObject);
var
updateserverslist:boolean;
pos:integer;
begin
updateserverslist:=false;

pos:=VirtualStringTree3.focusednode.index;
Datamodule1.Qservers.RecNo:=pos+1;
pos:=pos-1;
if pos<0 then
  pos:=0;

if (wideuppercase(IdTCPClient1.host)=wideuppercase(getwiderecord(Datamodule1.Qservers.FieldByName('IP')))) AND (IdTCPClient1.Port=Datamodule1.Qservers.FieldByName('Port').asinteger) then
  communitymessage(598,false)
else begin
  Datamodule1.Tservers.Locate('ID',Datamodule1.Qservers.fieldbyname('ID').asinteger,[]);
  Datamodule1.Tservers.Delete;
  updateserverslist:=true;
end;

if updateserverslist=true then begin
  showserverslist;
  posintoindex(pos,virtualstringtree3);
end;

end;

procedure TFserver.Pauseselection1Click(Sender: TObject);
begin
requestselectiontostatus('Status','S');
end;

procedure TFserver.Resumeselection1Click(Sender: TObject);
begin
requestselectiontostatus('Status','');
end;

procedure TFserver.TntSpeedButton4Click(Sender: TObject);
begin
if trim(tntrichedit1.Text)='' then begin
  tntrichedit1.Text:='';
  exit;
end;

if TntSpeedButton4.enabled=false then
  exit;

TntSpeedButton4.Enabled:=false;

sendmsg:=trim(tntrichedit1.Text); //STORE TO PROCESS IN MAIN TRHREAD

insertrichtextchat(RxRichEdit1,sendmsg,imagelist3,clblue,currentusername);

tntrichedit1.Text:='';

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFserver.TntSpeedButton6Click(Sender: TObject);
var
p:TPoint;
begin
//if Tntspeedbutton6.Down then
//begin
GetCursorPos(p);
TntPopupMenu2.Popup(p.X,p.Y);
//application.processmessages;
//Tntspeedbutton6.Down := False;
//end;

end;

procedure TFserver.TntSpeedButton5Click(Sender: TObject);
var
p:TPoint;
begin
//if (sender as TTntSpeedButton).Down then
//begin
GetCursorPos(p);
TntPopupMenu2.Popup(p.X,p.Y);
//application.processmessages;
//(sender as TTntSpeedButton).Down := False;
//end;

end;

procedure TFserver.EmojiClickchat(Sender: TObject);
var
s,e:widestring;
edit:TTntrichedit;
aux:string;
begin

if PageControl1.ActivePageIndex=1 then
  edit:=tntrichedit1
else
if PageControl1.ActivePageIndex=4 then begin
  aux:=gettoken(Pagecontrol2.ActivePage.Name,'_',3);
  edit:=(FindComponent('CLONE_TntRichedit3_'+aux) as Ttntrichedit);
end
else
  exit;

try
s:=copy(edit.Text,1,edit.SelStart)
except
end;

try
e:=copy(edit.text,edit.SelStart+1+edit.SelLength,length(edit.text));
except
end;

edit.text:=s+(sender as Tmenuitem).Caption+e;
stablishfocus(edit);
edit.SelStart:=length(s)+2;

end;

function MemoryStreamToString(M: TMemoryStream): ansistring;
begin
  SetString(Result, PChar(M.Memory), M.Size div SizeOf(Char));
end;


procedure TFserver.ThreadsendfileExecute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
client:TIdTCPClient;
Fstream:TGpHugeFileStream;
filename:widestring;
maxsize,sum,Bytesread:int64;
Buffer: array of Byte;
str:Tmemorystream;
idcomp,toip:string;
toport:integer;
touser,toid,tosetname,toprofilename,tosize,tocrc,tomd5,tosha1:widestring;
tick:int64;
io:TIdIOHandlerSocket;
th:TIdIOHandlerThrottle;
originalupspeed:int64;
uploadscount:integer;
Qprofiles,Qsets,Qroms,Qdirs:Tabsquery;
res,requestmode:boolean;
typ:integer;
compext:widestring;
aux:string;
begin
toport:=0;
requestmode:=false;
res:=false;
aux:='5.1';
try

  if gettokencount(widestring(data),separator)=10 then begin//FROM REQUEST

    requestmode:=true;
    toport:=strtoint(gettoken(widestring(data),separator,1));
    touser:=gettoken(widestring(data),separator,2);
    toid:=gettoken(widestring(data),separator,3);
    filename:=gettoken(widestring(data),separator,4);
    tosize:=gettoken(widestring(data),separator,5);
    tocrc:=gettoken(widestring(data),separator,6);
    tomd5:=gettoken(widestring(data),separator,7);
    tosha1:=gettoken(widestring(data),separator,8);
    toprofilename:=gettoken(widestring(data),separator,9);
    toip:=gettoken(widestring(data),separator,10);

    try
      Qprofiles:=TABSQuery.Create(self);
      Qsets:=Tabsquery.Create(self);
      Qroms:=Tabsquery.Create(self);
      Qdirs:=Tabsquery.create(self);
      Qprofiles.DatabaseName:=Datamodule1.DBDatabase.DatabaseName;
      Qsets.DatabaseName:=Datamodule1.DBDatabase.DatabaseName;
      Qroms.DatabaseName:=Datamodule1.DBDatabase.DatabaseName;
      Qdirs.DatabaseName:=Datamodule1.DBDatabase.DatabaseName;

      Qprofiles.SQL.Text:='SELECT * FROM Profiles WHERE Shared=true AND name = :p_';
      Qprofiles.Params.Clear;
      Qprofiles.params.CreateParam(ftWideString,'p_',ptResult);
      Qprofiles.Params[0].DataType := ftWideString;
      Qprofiles.Params[0].Value:=toprofilename;

      Qprofiles.open;

      while Qprofiles.Eof=false do begin

        res:=false;

        Qdirs.Close;
        Qdirs.SQL.Clear;
        Qdirs.SQL.add('SELECT * FROM Directories WHERE Profile ='+Qprofiles.fieldbyname('ID').asstring);
        Qdirs.Open;

        Qroms.Close;
        Qroms.SQL.Clear;
        Qroms.SQL.Add('SELECT * FROM Z'+fillwithzeroes(Qprofiles.fieldbyname('ID').asstring,4));
        Qroms.SQL.Add('WHERE Have=True AND [Space]='+tosize+' AND CRC='+''''+tocrc+''''+' AND MD5='+''''+tomd5+''''+' AND SHA1='+''''+tosha1+'''');
        Qroms.open;

        while Qroms.eof=false do begin

          Qsets.close;
          Qsets.SQL.Clear;
          Qsets.SQL.Add('SELECT * FROM Y'+fillwithzeroes(Qprofiles.fieldbyname('ID').asstring,4));

          //SPLIT/MERGE DETECTION
          if Qprofiles.FieldByName('filemode').asinteger=0 then
            Qsets.sql.Add('WHERE ID='+Qroms.fieldbyname('Setnamemaster').asstring)
          else
            Qsets.sql.Add('WHERE ID='+Qroms.fieldbyname('Setname').asstring);


          Qsets.Open;

          tosetname:=getwiderecord(Qsets.fieldbyname('Gamename')); //<-Set name

          typ:=Qroms.fieldbyname('Type').AsInteger;
          res:=Qdirs.Locate('Type',typ,[]);
          if res=false then
            if typ<>0 then
              res:=Qdirs.Locate('Type',0,[]);

          if res=true then begin //I KNOW THE PATH
            res:=false;
            filename:=checkpathbar(getwiderecord(Qdirs.FieldByName('Path')))+tosetname;
            compext:='\';
            case Qdirs.fieldbyname('Compression').AsInteger of
              10..19:compext:='.zip';
              20..29:compext:='.rar';
              30..39:compext:='.7z';
            end;

            if compext<>'\' then
              filename:=filename+compext
            else
              filename:=checkpathbar(filename)+getwiderecord(Qroms.fieldbyname('Romname'));

            res:=WideFileExists(filename);//FOUND???
          end;

          if res=true then //EXIT FROM LOOP
            break;

          Qroms.next;
        end;

        if res=true then //EXIT FROM LOOP
          break;

        Qprofiles.Next;
      end;

    finally
      Freeandnil(Qprofiles);
      Freeandnil(Qsets);
      Freeandnil(Qroms);
      Freeandnil(Qdirs);
    end;

  end
  else begin
    res:=true;
    toip:=gettoken(widestring(data),separator,1);
    toport:=strtoint(gettoken(widestring(data),separator,2));
    touser:=gettoken(widestring(data),separator,3);
    filename:=gettoken(widestring(data),separator,4);
    tosize:=inttostr(sizeoffile(filename));
  end;

except
end;

aux:='5.2';
try

str:=TMemoryStream.Create;
Bytesread:=HASHBUFFSIZE;
sum:=0;
idcomp:=(sender as TBMDThread).Name;
idcomp:=GetToken(idcomp,'_',3);

client:=TIdTCPClient.Create(self);
client.Name:='UPLOAD_'+idcomp;
aux:='5.3';
client.Host:=toip;
client.Port:=toport;

io:=TIdIOHandlerSocket.Create(self);
th:=TIdIOHandlerThrottle.Create(self);
th.BytesPerSec:=upspeed*1024;
th.ChainedHandler:=io;//IT WORKS
client.IOHandler:=th;//IT WORKS
client.ReadTimeout:=consttimeout;
client.SendBufferSize:=HASHBUFFSIZE;
client.RecvBufferSize:=HASHBUFFSIZE;

originalupspeed:=0;

aux:='5.4';
if res=true then begin

  client.Connect(consttimeout);

  if (requestmode=true) then begin
    client.WriteLn('S'); //FILE SEND COMMAND REQUEST
    client.WriteLn(encrypt(toid+separator+tosize+separator+tocrc+separator+tomd5+separator+tosha1));
  end
  else begin
    client.WriteLn('F'); //FILE SEND COMMAND MANUALLY
    client.WriteLn(encrypt(UTF8Encode(WideExtractFileName(filename)+separator+tosize)));
  end;
  aux:='5.5';
  //SISTOLE
  if (client.ReadLn='0') AND (FileExists2(filename)=true) AND (FileInUse(filename)=false) then begin

    Fstream:=TGpHugeFileStream.CreateW(filename,accRead,[hfoBuffered],0,0,0,0,20,1048576,0); //1048576=1Mb*
    maxsize:=Fstream.Size;
    aux:='5.6';
    //CREATE UPLOAD COMPONENTS HERE
    thread.Synchronize(createuploadline,Pwidechar(idcomp+separator+inttostr(maxsize)+separator+filename+separator+touser+separator+toprofilename));
    aux:='5.7';
    uploadscount:=virtualstringtree5.RootNodeCount;

    try

      if requestmode=true then begin
        client.WriteLn(encrypt(UTF8Encode(WideExtractFileName(filename))));
        client.Writeln(inttostr(Fstream.Size)); //SEND SIZE INFO
      end;
      aux:='5.8';
      SetLength(Buffer, bytesread);
      tick:=GetTickCount;

      //LOOP
      while sum<maxsize do begin

        sum:=sum+HASHBUFFSIZE;
        if sum>maxsize then begin //MOD BUFFER LENGHT
          bytesread:=HASHBUFFSIZE-(sum-maxsize);
          SetLength(Buffer, bytesread);
        end;

        str.Clear;
        Fstream.ReadBuffer(Pointer(Buffer)^, bytesread);
        str.WriteBuffer(Buffer[0], Length(Buffer));
        aux:='5.9';
        client.OpenWriteBuffer;
        client.WriteStream(str,true,true,str.size);
        client.CloseWriteBuffer;
        aux:='5.10';
        if GetTickCount-tick>=100 then begin
          thread.Synchronize(updateuploadline,Pchar(idcomp+separator+IntToStr(sum)));
          tick:=GetTickCount;
        end;

        //BW CONTROL IN PROCESS
        if (originalupspeed<>upspeed) OR (uploadscount<VirtualStringTree5.RootNodeCount) then begin

          uploadscount:=VirtualStringTree5.RootNodeCount;
          originalupspeed:=upspeed;

          if upspeed<>0 then
            th.BytesPerSec:=(upspeed*1024) div uploadscount
          else
            th.BytesPerSec:=0;

        end;

      end;

      //UPDATE LAST TIME
      aux:='5.11';
      thread.Synchronize(updateuploadline,Pchar(idcomp+separator+IntToStr(maxsize)));
      aux:='5.12';
      sleep(1000);
    except
      try
        client.CancelWriteBuffer;
      except
      end;
    end;

  end;

end;//IF res=true

except
  on E : Exception do
  begin
    label9.caption:=('Exception class name = '+E.ClassName+aux+toip);
    label10.caption:=('Exception message = '+E.Message+aux+toip);
  end;
end;


try
  client.Disconnect;
except
end;

Freeandnil(client);
Freeandnil(str);
Freeandnil(Fstream);
Freeandnil(th);
Freeandnil(io);

thread.Terminate;
end;

procedure TFserver.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
lvCursorPos:TPoint;
n:PVirtualNode;
begin
GetCursorPos(lvCursorPos);
try
  lvcursorpos:=VirtualStringTree4.ScreenToClient(lvcursorpos);
  n:=VirtualStringTree4.GetNodeAt(lvCursorPos);
  virtualstringtree4.setfocus;
  VirtualStringTree4.FocusedNode:=n;
  VirtualStringTree4.Selected[n]:=true;
except
end;
end;

procedure TFserver.VirtualStringTree4GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
//filename,size,progress,speed,ETA,nick,Profile
case column of
  0:celltext:=WideExtractFileName(Ttransfers(Downloadlist[node.index]).Filename);
  1:begin
    if showasbytes=false then
      celltext:=bytestostr(Ttransfers(Downloadlist[node.index]).Totalsize)
    else
      celltext:=pointdelimiters(Ttransfers(Downloadlist[node.index]).Totalsize)+' bytes';
  end;
  //2:celltext:=''; //MUST REMOVE
  3:celltext:=Ttransfers(Downloadlist[node.index]).speeddisp;
  4:celltext:=Ttransfers(Downloadlist[node.index]).Downsizedisp;
  5:celltext:=Ttransfers(Downloadlist[node.index]).ETA;
  6:celltext:=Ttransfers(Downloadlist[node.index]).Nick;
  7:celltext:=Ttransfers(Downloadlist[node.index]).Profilename;
end;

end;

procedure TFserver.ThreadsendfileTerminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
idcomp:string;
g:Tgauge;
t:TTntlabel;
x:integer;
begin
idcomp:=(sender as TBMDThread).Name;
idcomp:=GetToken(idcomp,'_',3);

for x:=0 to Uploadlist.Count-1 do
  if Ttransfers(Uploadlist[x]).id=idcomp then begin
    g:=Ttransfers(Uploadlist[x]).Pbar;
    t:=Ttransfers(Uploadlist[x]).Plabel;
    
    if Ttransfers(Uploadlist[x]).Profilename='' then begin//MANUAL UPLOAD
      if Ttransfers(Uploadlist[x]).Downsize=Ttransfers(Uploadlist[x]).Totalsize then
        insertrichtextchat(rxrichedit2,traduction(609)+' '+getrichpath(Ttransfers(Uploadlist[x]).filename),nil,clblue,Ttransfers(Uploadlist[x]).Nick)
      else
        insertrichtextchat(rxrichedit2,traduction(610)+' '+getrichpath(Ttransfers(Uploadlist[x]).filename),nil,clred,Ttransfers(Uploadlist[x]).nick);
    end
    else
      if Ttransfers(Uploadlist[x]).Downsize=Ttransfers(Uploadlist[x]).Totalsize then
        insertrichtextchat(rxrichedit2,traduction(630)+' '+getrichpath(Ttransfers(Uploadlist[x]).filename),nil,clblue,Ttransfers(Uploadlist[x]).Nick)
      else
        insertrichtextchat(rxrichedit2,traduction(631)+' '+getrichpath(Ttransfers(Uploadlist[x]).filename),nil,clred,Ttransfers(Uploadlist[x]).nick);

    if pagecontrol1.ActivePageIndex<>5 then
      pagecontrol1.Pages[5].Highlighted:=true;

    Uploadlist.Delete(x);
    break;
  end;

if g<>nil then
  Freeandnil(g);
if t<>nil then
  Freeandnil(t);

refreshuploadlist;

Threadstodestroy.add((sender as Tbmdthread).name);//FORZE FREE
end;

procedure TFserver.TntLabel6MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
lvCursorPos : TPoint;
li : PVirtualNode;
vt:TVirtualStringTree;
begin
if uppercase((sender as Ttntlabel).Parent.Name)='VIRTUALSTRINGTREE4' then
  vt:=VirtualStringTree4
else
if uppercase((sender as Ttntlabel).Parent.Name)='VIRTUALSTRINGTREE5' then
  vt:=VirtualStringTree5
else
  exit;

GetCursorPos(lvCursorPos);
lvcursorpos:=vt.ScreenToClient(lvcursorpos);

//position of the mouse cursor related to ListView
li:=vt.GetNodeAt(lvCursorPos);
vt.Selected[li]:=true;
vt.FocusedNode:=li;
vt.SetFocus;
end;

procedure TFserver.VirtualStringTree5GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
//filename,size,progress,speed,ETA,nick,Profile
//caption:=bytestostr(Ttransfers(Uploadlist[node.index]).Adownsize);
case column of
  0:celltext:=wideextractfilename(Ttransfers(Uploadlist[node.index]).Filename);
  1:begin
    if showasbytes=false then
      celltext:=bytestostr(Ttransfers(Uploadlist[node.index]).Totalsize)
    else
      celltext:=pointdelimiters(Ttransfers(Uploadlist[node.index]).Totalsize)+' bytes';
  end;
  //2:celltext:=''; //MUST REMOVE
  3:celltext:=Ttransfers(Uploadlist[node.index]).speeddisp;
  4:celltext:=Ttransfers(Uploadlist[node.index]).Downsizedisp;
  5:celltext:=Ttransfers(Uploadlist[node.index]).ETA;
  6:celltext:=Ttransfers(Uploadlist[node.index]).Nick;
  7:celltext:=Ttransfers(Uploadlist[node.index]).Profilename;
end;

end;

procedure TFserver.VirtualStringTree5GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
if column=0 then
  if Kind=ikState then begin

  end
  else
  if kind<>ikOverlay then
    ImageIndex:=10;//UPLOAD ICON
end;

procedure TFserver.VirtualStringTree5PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  R : TRect;
  g: Tgauge;
  t: Ttntlabel;
begin

//VirtualStringTree3.Header.Columns[2].Position

//MUST REMOVE TO CORRENT GAUGE PAINTING
//if Column=2 then begin //ONLY GAUGE

  g:=Ttransfers(Uploadlist[node.index]).Pbar;
  t:=Ttransfers(Uploadlist[node.index]).Plabel;

  R := VirtualStringTree5.GetDisplayRect(Node, 2, False);

  g.Left := R.Left+1;
  g.Top := R.Top+1;

  if node.index>0 then  //FIX
    g.Height:=Ttransfers(Uploadlist[0]).Pbar.Height
  else
    g.Height:=R.Bottom-3;

  g.Width:=virtualstringtree5.Header.Columns[2].Width-3;

  t.Left:=g.left;
  t.top:=g.Top;
  t.Height:=g.Height;
  t.Width:=g.Width;

  if g.visible=false then begin
    g.Visible:=true;
    t.Visible:=true;
  end;

//MUST REMOVE TO CORRENT GAUGE PAINTING
//end;
end;

procedure TFserver.VirtualStringTree4GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
if column=0 then
  if Kind=ikState then begin

  end
  else
  if kind<>ikOverlay then
    ImageIndex:=1;//DOWNLOAD ICON
end;

procedure TFserver.VirtualStringTree4PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  R : TRect;
  g: Tgauge;
  t: Ttntlabel;
begin
//MUST REMOVE TO CORRENT GAUGE PAINTING
//if Column=2 then begin //ONLY GAUGE

  g:=Ttransfers(Downloadlist[node.index]).Pbar;
  t:=Ttransfers(Downloadlist[node.index]).Plabel;

  R := VirtualStringTree4.GetDisplayRect(Node, 2, False);

  g.Left := R.Left+1;
  g.Top := R.Top+1;

  if node.index>0 then  //FIX
    g.Height:=Ttransfers(Downloadlist[0]).Pbar.Height
  else
    g.Height:=R.Bottom-3;

  g.Width:=virtualstringtree4.Header.Columns[2].Width-3;

  t.Left:=g.left;
  t.top:=g.Top;
  t.Height:=g.Height;
  t.Width:=g.Width;

  if g.visible=false then begin
    g.Visible:=true;
    t.Visible:=true;
  end;

//MUST REMOVE TO CORRENT GAUGE PAINTING
//end;

end;

procedure TFserver.setchat1Click(Sender: TObject);
begin
VirtualStringTree1DblClick(sender);
end;

procedure TFserver.sendfileClick(Sender: TObject);
begin
uploadfilefromselectedpeer;
end;

procedure TFserver.TntPopupMenu3Popup(Sender: TObject);
begin
setchat1.Enabled:=false;
sendfile.Enabled:=false;
opendir1.Enabled:=false;

if Datamodule1.Qpeers.locate('ID',selectedpeer,[])=false then
  exit;

if VirtualStringTree1.SelectedCount>0 then
  if currentuserip<>Datamodule1.Qpeers.fieldbyname('IP').asstring then begin
    setchat1.Enabled:=true;
    sendfile.Enabled:=true;
    if WideDirectoryExists(communitydownfolder+'Users\'+getwiderecord(Datamodule1.Qpeers.fieldbyname('Description')))=true then
      opendir1.Enabled:=true;

  end;
end;

procedure TFserver.TntSpeedButton7Click(Sender: TObject);
begin
uploadfilefromselectedchat;
end;

procedure TFserver.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  if panel38.Visible then begin
    TntSpeedButton3Click(Sender);
    freemousebuffer;
  end
  else
    close;
end;

procedure TFserver.Opendir1Click(Sender: TObject);
var
newpath:widestring;
begin
WideForceDirectories(communitydownfolder);
if Datamodule1.Qpeers.Locate('ID',selectedpeer,[])=true then
  newpath:=communitydownfolder+'Users\'+getwiderecord(Datamodule1.Qpeers.fieldbyname('Description'));

if WideDirectoryExists(newpath) then
  ShellExecutew(Handle,'open', pwidechar(getshortfilename(newpath)), nil, nil, SW_SHOWNORMAL)
else
  ShellExecutew(Handle,'open', pwidechar(getshortfilename(communitydownfolder)), nil, nil, SW_SHOWNORMAL)
end;

procedure TFserver.TntRichEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
len:integer;
w:widestring;
begin
if TntSpeedButton9.Down=false then //IF NOT THEN NOT SEND MESSAGE ON RETURN
  if key=VK_RETURN then begin
    key:=VK_CLEAR;
    TntSpeedButton4Click(sender);
  end;
//CTRL + V PASTE BUGIX
if (Key = 86) and (ssCtrl in Shift) then  // Ctrl-V was pressed NO UNICODE
    if tntClipboard.HasFormat(CF_TEXT) then begin // There is text in the clipboard

      w:=TntClipboard.AsWideText;
      len:=length(tntrichedit1.Text)-tntrichedit1.SelLength;
      w:=copy(w,1,tntrichedit1.MaxLength-len);
      if len=tntrichedit1.MaxLength then //FULL
        beep
      else
        TntRichEdit1.SelText:=w;

      Key := 0; // suppres the Ctrl-V
    end;
end;

procedure TFserver.TntRichEdit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
b:TTntSpeedButton;
len:integer;
w:widestring;
begin
if (FindComponent('CLONE_TntSpeedbutton8_'+getcurrentchatid) as Ttntspeedbutton).Down=false then
  if key=VK_RETURN then begin
    key:=VK_CLEAR;
    b:=(FindComponent('CLONE_Speedbutton2_'+gettoken((sender as TTntrichedit).Name,'_',3)) as TTntspeedbutton);
    SpeedButton2Click(b);
  end;

if (Key = 86) and (ssCtrl in Shift) then  // Ctrl-V was pressed NO UNICODE
    if tntClipboard.HasFormat(CF_TEXT) then begin // There is text in the clipboard

      w:=TntClipboard.AsWideText;
      len:=length((sender as Ttntrichedit).Text)-(sender as Ttntrichedit).SelLength;
      w:=copy(w,1,(sender as Ttntrichedit).MaxLength-len);
      if len=(sender as Ttntrichedit).MaxLength then
        beep
      else
        (sender as Ttntrichedit).seltext:=w;

      Key := 0; // suppres the Ctrl-V
    end;
end;

procedure TFserver.High1Click(Sender: TObject);
begin
requestselectiontostatus('Priority','2');
end;

procedure TFserver.Normal1Click(Sender: TObject);
begin
requestselectiontostatus('Priority','1');
end;

procedure TFserver.Low1Click(Sender: TObject);
begin
requestselectiontostatus('Priority','0');
end;

procedure TFserver.SpeedButton10Click(Sender: TObject);

begin
  pagecontrol1.Pages[6].Visible:=false;
end;

procedure TFserver.ThreadsendrequestsExecute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
lastqueueid,lastpeerid:int64;
str:ansistring;
w:widestring;
x:integer;
begin
lastqueueid:=0;
lastpeerid:=0;

//QUERYS------------------------------------------------------------------------

if Datamodule1.Qmyquerys.Tag>=1 then begin  //FORZE REFRESH

  //IF TAG=2 THEN START AGAIN
  if Datamodule1.Qmyquerys.tag=1 then
    if Datamodule1.Qmyquerys.Active=true then
      if Datamodule1.Qmyquerys.IsEmpty=false then
        lastqueueid:=Datamodule1.Qmyquerys.fieldbyname('ID').asinteger;//RECOVER POSITION

  Datamodule1.Qmyquerys.Close;
  Datamodule1.Qmyquerys.Open;
  Datamodule1.Qmyquerys.Tag:=0;

  if lastqueueid<>0 then
    if Datamodule1.Qmyquerys.Active=true then
      if Datamodule1.Qmyquerys.IsEmpty=false then
        Datamodule1.Qmyquerys.Locate('ID',lastqueueid,[]);
end;

//PEERS-------------------------------------------------------------------------

if Datamodule1.QpeersThread.Tag=1 then begin  //FORZE REFRESH

  if Datamodule1.QpeersThread.Active=true then
    if Datamodule1.QpeersThread.IsEmpty=false then
      lastpeerid:=Datamodule1.QpeersThread.fieldbyname('ID').asinteger;

  Datamodule1.QpeersThread.close;
  Datamodule1.Qpeersthread.Open;
  Datamodule1.Qpeersthread.tag:=0;

  if lastpeerid<>0 then
    if Datamodule1.QpeersThread.Active=true then
      if Datamodule1.QpeersThread.IsEmpty=false then
        Datamodule1.QpeersThread.Locate('ID',lastpeerid,[]);
end;

                                                      //NOT PAUSED
if (Datamodule1.Qmyquerys.Active=true) AND (Datamodule1.QpeersThread.Active=true) AND (speedbutton7.down=true) then

  if (Datamodule1.Qmyquerys.IsEmpty=false) AND (Datamodule1.QpeersThread.IsEmpty=false) then begin

    if Datamodule1.Qmyquerys.Eof=true then
      Datamodule1.Qmyquerys.First;

    if Datamodule1.QpeersThread.Eof=true then begin
      Datamodule1.QpeersThread.First;
      Datamodule1.Qmyquerys.First;//RESTART QUEUES LIST
    end;

    lastqueueid:=Datamodule1.Qmyquerys.fieldbyname('ID').asinteger;//RECOVER POSITION

    //SEND PETITION
    IdTCPClient2.Disconnect;
    IdTCPClient2.Host:=Datamodule1.QpeersThread.fieldbyname('IP').asstring;
    IdTCPClient2.Port:=Datamodule1.QpeersThread.fieldbyname('Port').asinteger;

    //100 REQUESTS NEW MODE START
    x:=1;
    //REQUEST
    while (Datamodule1.Qmyquerys.Eof=false) AND (x<=100) do begin
      //ID,Filename,Size_,CRC,MD5,SHA1,Profilename
      w:=Datamodule1.Qmyquerys.FieldByName('ID').asstring+separator+getwiderecord(Datamodule1.Qmyquerys.FieldByName('Filename'))+separator+Datamodule1.Qmyquerys.FieldByName('Size_').asstring+separator+Datamodule1.Qmyquerys.FieldByName('CRC').asstring+separator+Datamodule1.Qmyquerys.FieldByName('MD5').asstring+separator+Datamodule1.Qmyquerys.FieldByName('SHA1').asstring+separator+getwiderecord(Datamodule1.Qmyquerys.FieldByName('Profilename'));
      //Setname+filename+size_+crc+md5+sha1+profilename
      str:=UTF8Encode(w);
      str:=Encrypt(str);

      try
        if x=1 then begin //ONLY FIRST TIME NEXT IS CONNECTED TO PEER
          IdTCPClient2.Connect(consttimeout);
          IdTCPClient2.WriteLn('R');//REQUEST
        end;
        IdTCPClient2.WriteLn(str);
      except
        break;//ERROR CONNECTING ABORT LOOP
      end;

      Datamodule1.Qmyquerys.next;
      x:=x+1;
    end;//100 REQUESTS END

    Datamodule1.QpeersThread.next;//PREPARE FOR NEXT TIME
    Datamodule1.Qmyquerys.Locate('ID',lastqueueid,[]); //RECOVER PRIOR POSITION

    try
      IdTCPClient2.WriteLn('');
    except
    end;

    try
      IdTCPClient2.Disconnect;
    except
    end;

  end;

thread.Terminate;
end;

procedure TFserver.ThreadsendrequestsStart(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
Threadsendrequests.Tag:=1;
end;

procedure TFserver.ThreadsendrequestsTerminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
Threadsendrequests.Tag:=0;
end;

procedure TFserver.SpeedButton9Click(Sender: TObject);
var
pass:boolean;
Q:Tabsquery;
begin
pass:=false;

Q:=Tabsquery.Create(self);

try
  if Datamodule1.Qmyquerysview.Locate('Status','C',[])=true then begin //JUMP IF NO COMPLETED EXISTS
    Q.DatabaseName:=Datamodule1.DBMyquerys.DatabaseName;
    Q.SQL.Add('DELETE FROM Querys WHERE Status = '+''''+'C'+'''');
    Q.Prepare;
    Q.ExecSQL;
    pass:=true;
  end;
except
end;

Freeandnil(Q);

if pass=true then begin
  Fmain.showmyquerys;
end;

end;

procedure TFserver.Cleancompleted1Click(Sender: TObject);
begin
SpeedButton9Click(sender);
end;

procedure TFserver.TntSpeedButton10Click(Sender: TObject);
var
p:TPoint;
begin
//TntSpeedButton10.GroupIndex:=0;
//if TntSpeedButton10.Down then begin
GetCursorPos(p);
PopupMenu2.Popup(p.X,p.Y);
//application.processmessages;
//TntSpeedButton10.Down := False;
//end;
end;

procedure TFserver.TntSpeedButton11Click(Sender: TObject);
var
p:TPoint;
begin
GetCursorPos(p);
PopupMenu3.Popup(p.X,p.Y);
end;

procedure TFserver.N11Click(Sender: TObject);
begin
downslots:=1;
N11.Checked:=true;
refreshdownloadlist;
end;

procedure TFserver.N21Click(Sender: TObject);
begin
downslots:=2;
N21.Checked:=true;
refreshdownloadlist;
end;

procedure TFserver.N31Click(Sender: TObject);
begin
downslots:=3;
N31.Checked:=true;
refreshdownloadlist;
end;

procedure TFserver.N41Click(Sender: TObject);
begin
downslots:=4;
N41.checked:=true;
refreshdownloadlist;
end;

procedure TFserver.N51Click(Sender: TObject);
begin
downslots:=5;
N51.checked:=true;
refreshdownloadlist;
end;

procedure TFserver.N61Click(Sender: TObject);
begin
downslots:=6;
N61.checked:=true;
refreshdownloadlist;
end;

procedure TFserver.N71Click(Sender: TObject);
begin
downslots:=7;
N71.Checked:=True;
refreshdownloadlist;
end;

procedure TFserver.N81Click(Sender: TObject);
begin
downslots:=8;
N81.Checked:=true;
refreshdownloadlist;
end;

procedure TFserver.N91Click(Sender: TObject);
begin
downslots:=9;
N91.Checked:=true;
refreshdownloadlist;
end;

procedure TFserver.N101Click(Sender: TObject);
begin
downslots:=10;
n101.Checked:=true;
refreshdownloadlist;
end;

procedure TFserver.PopupMenu2Popup(Sender: TObject);
begin
case downslots of
  1:n11.Checked:=true;
  2:n21.Checked:=true;
  3:n31.Checked:=true;
  4:n41.Checked:=true;
  5:n51.Checked:=true;
  6:n61.Checked:=true;
  7:n71.Checked:=true;
  8:n81.Checked:=true;
  9:n91.Checked:=true;
  10:n101.Checked:=true;
end;

end;

procedure TFserver.N12Click(Sender: TObject);
begin
upslots:=1;
n12.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N22Click(Sender: TObject);
begin
upslots:=2;
n22.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N32Click(Sender: TObject);
begin
upslots:=3;
n32.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N42Click(Sender: TObject);
begin
upslots:=4;
n42.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N52Click(Sender: TObject);
begin
upslots:=5;
n52.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N62Click(Sender: TObject);
begin
upslots:=6;
n62.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N72Click(Sender: TObject);
begin
upslots:=7;
n72.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N82Click(Sender: TObject);
begin
upslots:=8;
n82.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N92Click(Sender: TObject);
begin
upslots:=9;
n92.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.N102Click(Sender: TObject);
begin
upslots:=10;
n102.Checked:=true;
refreshuploadlist;
end;

procedure TFserver.PopupMenu3Popup(Sender: TObject);
begin
case upslots of
  1:n12.Checked:=true;
  2:n22.Checked:=true;
  3:n32.Checked:=true;
  4:n42.Checked:=true;
  5:n52.Checked:=true;
  6:n62.Checked:=true;
  7:n72.Checked:=true;
  8:n82.Checked:=true;
  9:n92.Checked:=true;
  10:n102.Checked:=true;
end;

end;

procedure TFserver.TntSpeedButton13Click(Sender: TObject);
begin
AnimateWindow(tntpanel6.Handle, 150,   AW_CENTER or  AW_HIDE);
tntpanel6.visible:=false;
panel6.enabled:=true;
panel9.enabled:=true;
panel19.enabled:=true;
panel13.Enabled:=true;
pagecontrol1.Enabled:=true;
end;

procedure TFserver.Edit7Change(Sender: TObject);
begin
try
Filteredit(sender);
except
end;
end;

procedure TFserver.Edit8Change(Sender: TObject);
begin
try
Filteredit(sender);
except
end;
end;

procedure TFserver.TntSpeedButton14Click(Sender: TObject);
begin
showbandwidthselector(true);
end;

procedure TFserver.TntSpeedButton12Click(Sender: TObject);
begin
AnimateWindow(tntpanel6.Handle, 150,   AW_CENTER or  AW_HIDE);
tntpanel6.visible:=false;
panel6.enabled:=true;
panel9.enabled:=true;
panel19.enabled:=true;
panel13.Enabled:=true;
pagecontrol1.Enabled:=true;

try
upspeed:=strtoint(edit8.Text);
except
end;
try
downspeed:=strtoint(edit7.Text);
except
end;

end;

procedure TFserver.TntSpeedButton15Click(Sender: TObject);
begin
showbandwidthselector(false);
end;

procedure TFserver.TntRichEdit1Change(Sender: TObject);
begin
removerichformat(sender as Ttntrichedit);
end;

procedure TFserver.TntFormDestroy(Sender: TObject);
begin
CS.Free;
end;

end.


