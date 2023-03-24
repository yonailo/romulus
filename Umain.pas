unit Umain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ExtCtrls, Buttons, StdCtrls, Menus, Hashes, Strings, Mymessages, Activex, Importation, ExplorerDrop, DB,
  ABSMain, Udata, BMDThread, RAR, SevenZipVCL, Uscan, Uchart, Ufilter, Udialog, CommCtrl,
  inifiles, GR32_Image,pngimage, Shellapi,
  Unewdat, BTMemoryModule, UxTheme, Themes, ZipForge, OleCtrls, SHDocVw_EWB,
  EwbCore, EmbeddedWB, Registry, MSHTML, SHDocVw, Urlmon, ClipBrd, AppEvnts, EwbTools,
  SystemCriticalU, CoolTrayIcon, Ecore, fspTaskbarMgr, Commdlg, ExceptionLog,
  fspTaskbarPreviews, fspControlsExt,Tntforms,TntExtCtrls,
  TntComCtrls, TntButtons, Tntsystem, TntStdCtrls, TntMenus, TntSysutils,Tntclasses,TntGraphics,
  TntDB, TntFilectrl, TntDialogs, Gptextfile, VirtualTrees, XPMenu, ExtActns, Wininet,GpHugeF,
  RxRichEd, Richedit, TntClipBrd, uencrypt;
  //REMOVED VCLFlickerReduce Problems with RxRichedit
type
  TFmain = class(TTntform)
    Panel1: TTntPanel;
    Panel2: TTntPanel;
    ImageList1: TImageList;
    Bevel7: TBevel;
    ImageList2: TImageList;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    Addsection1: TMenuItem;
    Deletesection1: TMenuItem;
    Editsection1: TMenuItem;
    N2: TMenuItem;
    Expandall1: TMenuItem;
    Collapseall1: TMenuItem;
    N1: TMenuItem;
    Selectall1: TMenuItem;
    Invertselection1: TMenuItem;
    OpenDialog1: TTntOpenDialog;
    PopupMenu3: TPopupMenu;
    Stayontop1: TMenuItem;
    Staynormal1: TMenuItem;
    N3: TMenuItem;
    Hide1: TMenuItem;
    Applicationpriority1: TMenuItem;
    High1: TMenuItem;
    Normal1: TMenuItem;
    Low1: TMenuItem;
    N4: TMenuItem;
    Loadselectedprofiles1: TMenuItem;
    Batchrunselectedprofiles1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    ExplorerDrop1: TExplorerDrop;
    N7: TMenuItem;
    Properties1: TMenuItem;
    Delete1: TMenuItem;
    N8: TMenuItem;
    adddats1: TMenuItem;
    N9: TMenuItem;
    SaveDialog1: TTntSaveDialog;
    BMDThread1: TBMDThread;
    PopupMenu4: TPopupMenu;
    Selectall2: TMenuItem;
    Invertselection2: TMenuItem;
    RAR1: TRAR;
    SevenZip1: TSevenZip;
    Panel44: TTntPanel;
    Panel45: TTntPanel;
    Rebuildall1: TMenuItem;
    Panel52: TTntPanel;
    Panel50: TTntPanel;
    Panel51: TTntPanel;
    Panel14: TTntPanel;
    Panel53: TTntPanel;
    Timer1: TTimer;
    ExplorerDrop2: TExplorerDrop;
    N10: TMenuItem;
    Setemulator1: TMenuItem;
    Configureemu1: TMenuItem;
    N11: TMenuItem;
    Emu0: TMenuItem;
    Emu1: TMenuItem;
    Emu2: TMenuItem;
    Emu3: TMenuItem;
    Emu4: TMenuItem;
    Emu5: TMenuItem;
    Emu6: TMenuItem;
    Emu7: TMenuItem;
    Emu8: TMenuItem;
    Emu9: TMenuItem;
    N12: TMenuItem;
    RAR2: TRAR;
    ExplorerDrop3: TExplorerDrop;
    ExplorerDrop4: TExplorerDrop;
    ImageList3: TImageList;
    PopupMenu5: TPopupMenu;
    ImageList4: TImageList;
    ImageList5: TImageList;
    N13: TMenuItem;
    Checkselected1: TMenuItem;
    Uncheckselected1: TMenuItem;
    Selectall3: TMenuItem;
    Invertselection3: TMenuItem;
    ImageList6: TImageList;
    Sendtogenerator1: TMenuItem;
    N14: TMenuItem;
    PopupMenu6: TPopupMenu;
    Close1: TMenuItem;
    N15: TMenuItem;
    Gotofirst1: TMenuItem;
    Gotolast1: TMenuItem;
    N16: TMenuItem;
    Dirmaker1: TMenuItem;
    Zip1: TZipForge;
    Zip2: TZipForge;
    PopupMenu7: TPopupMenu;
    Closegreen1: TMenuItem;
    Closeyellow1: TMenuItem;
    Closered1: TMenuItem;
    Closegrey1: TMenuItem;
    N17: TMenuItem;
    closeall1: TMenuItem;
    ImageList7: TImageList;
    PopupMenu8: TPopupMenu;
    Openinanewtab1: TMenuItem;
    N18: TMenuItem;
    Prior1: TMenuItem;
    Next1: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    Properties2: TMenuItem;
    Print1: TMenuItem;
    N21: TMenuItem;
    Paste1: TMenuItem;
    Cut1: TMenuItem;
    N22: TMenuItem;
    Copy1: TMenuItem;
    selectall4: TMenuItem;
    N23: TMenuItem;
    Newtab1: TMenuItem;
    Smartsearchingoogle1: TMenuItem;
    Description1: TMenuItem;
    Filename1: TMenuItem;
    N24: TMenuItem;
    PopupMenu9: TPopupMenu;
    Selectall5: TMenuItem;
    Invertselection4: TMenuItem;
    N25: TMenuItem;
    SmartsearchinGoogle2: TMenuItem;
    Filename2: TMenuItem;
    PopupMenu10: TPopupMenu;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    N26: TMenuItem;
    Paste2: TMenuItem;
    N27: TMenuItem;
    Selectall6: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    Goto1: TMenuItem;
    N28: TMenuItem;
    ROM1: TMenuItem;
    SAMPLE1: TMenuItem;
    CHD1: TMenuItem;
    PopupMenu11: TPopupMenu;
    Romspath1: TMenuItem;
    Samplespath1: TMenuItem;
    Chdspath1: TMenuItem;
    Extractto1: TMenuItem;
    N29: TMenuItem;
    Directory1: TMenuItem;
    Desktop1: TMenuItem;
    N30: TMenuItem;
    Makedirectoriesbycompressedfile1: TMenuItem;
    Extractto2: TMenuItem;
    N31: TMenuItem;
    Directory2: TMenuItem;
    Desktop2: TMenuItem;
    Activaterecursive1: TMenuItem;
    N32: TMenuItem;
    CoolTrayIcon1: TCoolTrayIcon;
    Image323: TImage32;
    fspTaskbarMgr1: TfspTaskbarMgr;
    N33: TMenuItem;
    CRC321: TMenuItem;
    MD51: TMenuItem;
    SHA11: TMenuItem;
    Jumptoprofiledirectory1: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    friendfix1: TMenuItem;
    Community1: TMenuItem;
    N36: TMenuItem;
    Shareselected1: TMenuItem;
    Unshareselected1: TMenuItem;
    N37: TMenuItem;
    PageControl1: TTntPageControl;
    TabSheet1: TTntTabSheet;
    Splitter1: TSplitter;
    Panel4: TTntPanel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    SpeedButton2: TTntSpeedButton;
    SpeedButton7: TTntSpeedButton;
    SpeedButton11: TTntSpeedButton;
    Bevel10: TBevel;
    SpeedButton13: TTntSpeedButton;
    Bevel11: TBevel;
    Bevel13: TBevel;
    SpeedButton27: TTntSpeedButton;
    Panel59: TTntPanel;
    Label5: TTntLabel;
    SpeedButton35: TTntSpeedButton;
    SpeedButton37: TTntSpeedButton;
    Edit4: TTntEdit;
    TreeView1: TTntTreeView;
    Panel3: TTntPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SpeedButton1: TTntSpeedButton;
    SpeedButton3: TTntSpeedButton;
    SpeedButton4: TTntSpeedButton;
    SpeedButton5: TTntSpeedButton;
    Panel10: TTntPanel;
    Panel11: TTntPanel;
    Panel12: TTntPanel;
    Panel13: TTntPanel;
    PanelO: TTntPanel;
    Panel9: TTntPanel;
    Panel17: TTntPanel;
    Panel66: TTntPanel;
    Panel6: TTntPanel;
    Panel7: TTntPanel;
    Panel20: TTntPanel;
    Panel32: TTntPanel;
    Label1: TTntLabel;
    SpeedButton18: TTntSpeedButton;
    SpeedButton19: TTntSpeedButton;
    SpeedButton20: TTntSpeedButton;
    SpeedButton21: TTntSpeedButton;
    TabSheet2: TTntTabSheet;
    Panel5: TTntPanel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    SpeedButton6: TTntSpeedButton;
    SpeedButton28: TTntSpeedButton;
    SpeedButton29: TTntSpeedButton;
    Bevel14: TBevel;
    SpeedButton30: TTntSpeedButton;
    Bevel15: TBevel;
    SpeedButton31: TTntSpeedButton;
    SpeedButton39: TTntSpeedButton;
    Bevel30: TBevel;
    SpeedButton40: TTntSpeedButton;
    Bevel31: TBevel;
    SpeedButton41: TTntSpeedButton;
    SpeedButton46: TTntSpeedButton;
    Bevel18: TBevel;
    SpeedButton51: TTntSpeedButton;
    Bevel23: TBevel;
    Panel22: TTntPanel;
    Panel16: TTntPanel;
    Panel41: TTntPanel;
    SpeedButton33: TTntSpeedButton;
    Bevel24: TBevel;
    SpeedButton10: TTntSpeedButton;
    SpeedButton12: TTntSpeedButton;
    SpeedButton34: TTntSpeedButton;
    Bevel29: TBevel;
    SpeedButton65: TTntSpeedButton;
    Bevel43: TBevel;
    Panel42: TTntPanel;
    Bevel27: TBevel;
    Bevel28: TBevel;
    Panel55: TTntPanel;
    Panel54: TTntPanel;
    Panel56: TTntPanel;
    Bevel25: TBevel;
    Bevel26: TBevel;
    SpeedButton32: TTntSpeedButton;
    Edit3: TTntEdit;
    Panel57: TTntPanel;
    Panel58: TTntPanel;
    Image322: TImage32;
    Image321: TImage32;
    Panel23: TTntPanel;
    Panel33: TTntPanel;
    Splitter2: TSplitter;
    Panel31: TTntPanel;
    Panel34: TTntPanel;
    Edit2: TTntEdit;
    Panel15: TTntPanel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    SpeedButton8: TTntSpeedButton;
    SpeedButton9: TTntSpeedButton;
    Panel18: TTntPanel;
    Panel19: TTntPanel;
    Panel40: TTntPanel;
    Panel38: TTntPanel;
    Panel21: TTntPanel;
    Panel35: TTntPanel;
    Label3: TTntLabel;
    SpeedButton25: TTntSpeedButton;
    SpeedButton26: TTntSpeedButton;
    Panel24: TTntPanel;
    Panel26: TTntPanel;
    Edit1: TTntEdit;
    Panel27: TTntPanel;
    Bevel12: TBevel;
    SpeedButton14: TTntSpeedButton;
    SpeedButton15: TTntSpeedButton;
    SpeedButton16: TTntSpeedButton;
    Panel39: TTntPanel;
    Panel28: TTntPanel;
    Panel29: TTntPanel;
    Panel37: TTntPanel;
    Panel30: TTntPanel;
    Panel25: TTntPanel;
    Label2: TTntLabel;
    SpeedButton22: TTntSpeedButton;
    SpeedButton23: TTntSpeedButton;
    SpeedButton24: TTntSpeedButton;
    Panel43: TTntPanel;
    Panel36: TTntPanel;
    SpeedButton17: TTntSpeedButton;
    Label4: TTntLabel;
    PageControl2: TTntPageControl;
    TabSheet7: TTntTabSheet;
    TabSheet3: TTntTabSheet;
    Panel46: TTntPanel;
    Bevel16: TBevel;
    Bevel17: TBevel;
    SpeedButton42: TTntSpeedButton;
    SpeedButton43: TTntSpeedButton;
    Bevel32: TBevel;
    SpeedButton44: TTntSpeedButton;
    Bevel33: TBevel;
    SpeedButton45: TTntSpeedButton;
    SpeedButton49: TTntSpeedButton;
    Bevel19: TBevel;
    SpeedButton50: TTntSpeedButton;
    Bevel22: TBevel;
    SpeedButton63: TTntSpeedButton;
    Bevel42: TBevel;
    Panel47: TTntPanel;
    SpeedButton48: TTntSpeedButton;
    SpeedButton47: TTntSpeedButton;
    Label7: TTntLabel;
    Edit6: TTntEdit;
    ComboBox2: TTntComboBox;
    Panel61: TTntPanel;
    Panel48: TTntPanel;
    Bevel20: TBevel;
    Bevel21: TBevel;
    Panel49: TTntPanel;
    TabSheet4: TTntTabSheet;
    Panel67: TTntPanel;
    Bevel34: TBevel;
    Bevel35: TBevel;
    SpeedButton53: TTntSpeedButton;
    SpeedButton58: TTntSpeedButton;
    SpeedButton57: TTntSpeedButton;
    SpeedButton56: TTntSpeedButton;
    SpeedButton54: TTntSpeedButton;
    SpeedButton55: TTntSpeedButton;
    Edit8: TTntEdit;
    ComboBox3: TTntComboBox;
    PageControl3: TTntPageControl;
    Panel69: TTntPanel;
    SpeedButton52: TTntSpeedButton;
    SpeedButton59: TTntSpeedButton;
    Bevel40: TBevel;
    Bevel41: TBevel;
    SpeedButton60: TTntSpeedButton;
    SpeedButton61: TTntSpeedButton;
    SpeedButton66: TTntSpeedButton;
    Bevel44: TBevel;
    Panel71: TTntPanel;
    Bevel38: TBevel;
    Bevel39: TBevel;
    Panel72: TTntPanel;
    Panel79: TTntPanel;
    TrackBar1: TTrackBar;
    Panel70: TTntPanel;
    Panel68: TTntPanel;
    Bevel36: TBevel;
    Bevel37: TBevel;
    SpeedButton62: TTntSpeedButton;
    SpeedButton64: TTntSpeedButton;
    Panel76: TTntPanel;
    Panel77: TTntPanel;
    Panel78: TTntPanel;
    Edit9: TTntEdit;
    Panel74: TTntPanel;
    Panel75: TTntPanel;
    Panel73: TTntPanel;
    TabSheet5: TTntTabSheet;
    TabSheet6: TTntTabSheet;
    TabSheet8: TTntTabSheet;
    TabSheet9: TTntTabSheet;
    TabSheet10: TTntTabSheet;
    Community2: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    Sendmissingtorequestlist1: TMenuItem;
    EurekaLog1: TEurekaLog;
    share1: TMenuItem;
    unshare1: TMenuItem;
    N40: TMenuItem;
    jumptodir1: TMenuItem;
    N41: TMenuItem;
    fspTaskbarPreviews1: TfspTaskbarPreviews;
    Panel80: TTntPanel;
    Image325: TImage32;
    Label8: TTntLabel;
    SpeedButton67: TTntSpeedButton;
    Bevel45: TBevel;
    PopupMenu12: TPopupMenu;
    Setfilters1: TMenuItem;
    N42: TMenuItem;
    Applyfilters1: TMenuItem;
    Removefilters1: TMenuItem;
    SpeedButton68: TTntSpeedButton;
    SpeedButton69: TTntSpeedButton;
    SpeedButton70: TTntSpeedButton;
    N43: TMenuItem;
    Sendtorequests1: TMenuItem;
    N44: TMenuItem;
    Sendmissingtorequest1: TMenuItem;
    sendtorequest1: TMenuItem;
    N45: TMenuItem;
    Panel81: TTntPanel;
    SpeedButton71: TTntSpeedButton;
    N46: TMenuItem;
    backuppath1: TMenuItem;
    N47: TMenuItem;
    Options1: TMenuItem;
    setbackupfolder1: TMenuItem;
    N48: TMenuItem;
    Setmd51: TMenuItem;
    Setsha11: TMenuItem;
    Settz1: TMenuItem;
    Sett7z1: TMenuItem;
    activate1: TMenuItem;
    deactivate1: TMenuItem;
    activate2: TMenuItem;
    deactivate2: TMenuItem;
    activate3: TMenuItem;
    deactivate3: TMenuItem;
    activate4: TMenuItem;
    deactivate4: TMenuItem;
    SevenZip2: TSevenZip;
    Panel60: TTntPanel;
    Label6: TTntLabel;
    SpeedButton38: TTntSpeedButton;
    SpeedButton36: TTntSpeedButton;
    ComboBox1: TTntComboBox;
    Edit5: TTntEdit;
    VirtualStringTree2: TVirtualStringTree;
    VirtualStringTree3: TVirtualStringTree;
    VirtualStringTree4: TVirtualStringTree;
    Expandall2: TMenuItem;
    Collapseall2: TMenuItem;
    N49: TMenuItem;
    Stop1: TMenuItem;
    Refresh1: TMenuItem;
    N50: TMenuItem;
    Panel8: TTntPanel;
    Timer3: TTimer;
    Timerdialog: TTimer;
    SpeedButton72: TSpeedButton;
    TntPanel1: TTntPanel;
    Panel62: TTntPanel;
    Panel64: TTntPanel;
    Panel63: TTntPanel;
    TntPanel2: TTntPanel;
    TntPanel3: TTntPanel;
    Panel65: TTntPanel;
    createxmldat1: TMenuItem;
    BMDThreadGroup1: TBMDThreadGroup;
    Image324: TImage32;
    TntPanel4: TTntPanel;
    RxRichEdit1: TRxRichEdit;
    XPMenu1: TXPMenu;
    Fakeunicoderich: TTntRichEdit;
    Copyto1: TMenuItem;
    Directory3: TMenuItem;
    Desktop3: TMenuItem;
    StaticText1: TStaticText;
    Copytoclipboard1: TMenuItem;
    N51: TMenuItem;
    copytoclipboard2: TMenuItem;
    N52: TMenuItem;
    Fakeedit: TTntEdit;
    copytoclipboard3: TMenuItem;
    N53: TMenuItem;
    copytoclipboard4: TMenuItem;
    N54: TMenuItem;
    copy3: TMenuItem;
    copy4: TMenuItem;
    copy5: TMenuItem;
    copy6: TMenuItem;
    VirtualStringTree1: TVirtualStringTree;
    TntSpeedButton1: TTntSpeedButton;
    TntPanel5: TTntPanel;
    TntPanel6: TTntPanel;
    procedure Addsection1Click(Sender: TObject);
    procedure TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Expandall1Click(Sender: TObject);
    procedure Collapseall1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Editsection1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Invertselection1Click(Sender: TObject);
    procedure Deletesection1Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure ExplorerDrop1Dropped(Sender: TObject; Files: TTntstrings;
      FileCount, x, y: Integer);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure ListView1Data(Sender: TObject; Item: TListItem);
    procedure Delete1Click(Sender: TObject);
    procedure adddats1Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure High1Click(Sender: TObject);
    procedure Low1Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure Loadselectedprofiles1Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure Panel36Resize(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure BMDThread1Execute(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure BMDThread1Start(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton23Click(Sender: TObject);
    procedure SpeedButton24Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton25Click(Sender: TObject);
    procedure SpeedButton26Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RAR1ListFile(Sender: TObject;
      const FileInformation: TRARFileItem);
    procedure SevenZip1Listfile(Sender: TObject; Filename: WideString;
      Fileindex, FileSizeU, FileSizeP, Fileattr, Filecrc: Int64;
      Filemethod: WideString; FileTime: Double);
    procedure SpeedButton27Click(Sender: TObject);
    procedure Selectall2Click(Sender: TObject);
    procedure Invertselection2Click(Sender: TObject);
    procedure Batchrunselectedprofiles1Click(Sender: TObject);
    procedure SpeedButton30Click(Sender: TObject);
    procedure ExplorerDrop1FolderNotAllowed(Sender: TObject;
      FileName: widestring);
    procedure PageControl2Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton28Click(Sender: TObject);
    procedure SpeedButton29Click(Sender: TObject);
    procedure BMDThread1Terminate(Sender: TObject;
      Thread: TBMDExecuteThread; var Data: Pointer);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton33Click(Sender: TObject);
    procedure Panel58Resize(Sender: TObject);
    procedure SpeedButton32Click(Sender: TObject);
    procedure SpeedButton34Click(Sender: TObject);
    procedure SpeedButton35Click(Sender: TObject);
    procedure SpeedButton37Click(Sender: TObject);
    procedure SpeedButton36Click(Sender: TObject);
    procedure SpeedButton38Click(Sender: TObject);
    procedure Edit5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton39Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure SpeedButton40Click(Sender: TObject);
    procedure SpeedButton31Click(Sender: TObject);
    procedure Rebuildall1Click(Sender: TObject);
    procedure ExplorerDrop2FolderNotAllowed(Sender: TObject;
      FileName: widestring);
    procedure ExplorerDrop2Dropped(Sender: TObject; Files: TTntstrings;
      FileCount, x, y: Integer);
    procedure ExplorerDrop1BeginDrop(Sender: TObject);
    procedure ExplorerDrop2BeginDrop(Sender: TObject);
    procedure Configureemu1Click(Sender: TObject);
    procedure PopupMenu4Popup(Sender: TObject);
    procedure Hide1Click(Sender: TObject);
    procedure RAR2ListFile(Sender: TObject;
      const FileInformation: TRARFileItem);
    procedure ExplorerDrop3BeginDrop(Sender: TObject);
    procedure ExplorerDrop3Dropped(Sender: TObject; Files: Ttntstrings;
      FileCount, x, y: Integer);
    procedure ExplorerDrop3FolderNotAllowed(Sender: TObject;
      FileName: widestring);
    procedure RAR1NextVolumeRequired(Sender: TObject;
      const requiredFileName: widestring; out newFileName: widestring;
      out Cancel: Boolean);
    procedure SpeedButton41Click(Sender: TObject);
    procedure ExplorerDrop4BeginDrop(Sender: TObject);
    procedure ExplorerDrop4Dropped(Sender: TObject; Files: TTntstrings;
      FileCount, x, y: Integer);
    procedure ExplorerDrop4FolderNotAllowed(Sender: TObject;
      FileName: widestring);
    procedure BMDThread1Update(Sender: TObject; Thread: TBMDExecuteThread;
      var Data: Pointer; Percent: Integer);
    procedure Selectall3Click(Sender: TObject);
    procedure Invertselection3Click(Sender: TObject);
    procedure SpeedButton45Click(Sender: TObject);
    procedure SpeedButton46Click(Sender: TObject);
    procedure SpeedButton44Click(Sender: TObject);
    procedure SpeedButton48Click(Sender: TObject);
    procedure SpeedButton47Click(Sender: TObject);
    procedure Edit6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Checkselected1Click(Sender: TObject);
    procedure Uncheckselected1Click(Sender: TObject);
    function GetTabIndex(Pager: TTntpagecontrol; X,Y: integer): integer;
    procedure PageControl2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PageControl2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure RAR2NextVolumeRequired(Sender: TObject;
      const requiredFileName: widestring; out newFileName: widestring;
      out Cancel: Boolean);
    procedure TreeView1Compare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure SpeedButton50Click(Sender: TObject);
    procedure Sendtogenerator1Click(Sender: TObject);
    procedure SpeedButton51Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Gotofirst1Click(Sender: TObject);
    procedure Gotolast1Click(Sender: TObject);
    procedure PopupMenu6Popup(Sender: TObject);
    procedure Dirmaker1Click(Sender: TObject);
    procedure TreeView1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Zip1Password(Sender: TObject; FileName: WideString;
      var NewPassword: String; var SkipFile: Boolean);
    procedure Zip2Password(Sender: TObject; FileName: WideString;
      var NewPassword: String; var SkipFile: Boolean);
    procedure Zip2ProcessFileFailure(Sender: TObject; FileName: WideString;
      Operation: TZFProcessOperation; NativeError, ErrorCode: Integer;
      ErrorMessage: WideString; var Action: TZFAction);
    procedure Zip1ProcessFileFailure(Sender: TObject; FileName: WideString;
      Operation: TZFProcessOperation; NativeError, ErrorCode: Integer;
      ErrorMessage: WideString; var Action: TZFAction);
    procedure Zip1RequestBlankVolume(Sender: TObject;
      VolumeNumber: Integer; var VolumeFileName: WideString;
      var Cancel: Boolean);
    procedure Zip2RequestBlankVolume(Sender: TObject;
      VolumeNumber: Integer; var VolumeFileName: WideString;
      var Cancel: Boolean);
    procedure Zip2RequestFirstVolume(Sender: TObject;
      var VolumeFileName: WideString; var Cancel: Boolean);
    procedure Zip2RequestLastVolume(Sender: TObject;
      var VolumeFileName: WideString; var Cancel: Boolean);
    procedure Zip2RequestMiddleVolume(Sender: TObject;
      VolumeNumber: Integer; var VolumeFileName: WideString;
      var Cancel: Boolean);
    procedure closeall1Click(Sender: TObject);
    procedure PopupMenu7Popup(Sender: TObject);
    procedure Closegreen1Click(Sender: TObject);
    procedure Closeyellow1Click(Sender: TObject);
    procedure Closered1Click(Sender: TObject);
    procedure Closegrey1Click(Sender: TObject);
    procedure SpeedButton53Click(Sender: TObject);
    procedure SpeedButton54Click(Sender: TObject);
    procedure SpeedButton55Click(Sender: TObject);
    procedure PageControl3Change(Sender: TObject);
    procedure SpeedButton56Click(Sender: TObject);
    procedure SpeedButton57Click(Sender: TObject);
    procedure SpeedButton58Click(Sender: TObject);
    procedure SpeedButton60Click(Sender: TObject);
    procedure EmbeddedWB1ProgressChange(ASender: TObject; Progress,
      ProgressMax: Integer);
    procedure SpeedButton52Click(Sender: TObject);
    procedure SpeedButton59Click(Sender: TObject);
    procedure SpeedButton61Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Prior1Click(Sender: TObject);
    procedure Next1Click(Sender: TObject);
    procedure Properties2Click(Sender: TObject);
    procedure PageControl3DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PageControl3DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PageControl3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EmbeddedWB1ShowContextMenu(Sender: TCustomEmbeddedWB;
      const dwID: Cardinal; const ppt: PPoint;
      const CommandTarget: IInterface; const Context: IDispatch;
      var Result: HRESULT);
    procedure Edit8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageControl3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PageControl2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure EmbeddedWB1NewWindow2(ASender: TObject;
      var ppDisp: IDispatch; var Cancel: WordBool);
    procedure EmbeddedWB1NewWindow3(ASender: TObject;
      var ppDisp: IDispatch; var Cancel: WordBool; dwFlags: Cardinal;
      const bstrUrlContext, bstrUrl: WideString);
    procedure Selectall4Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure PopupMenu8Popup(Sender: TObject);
    procedure EmbeddedWB1WindowClosing(ASender: TObject;
      IsChildWindow: WordBool; var Cancel: WordBool);
    procedure EmbeddedWB1StatusTextChange(ASender: TObject;
      const Text: WideString);
    procedure Openinanewtab1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Newtab1Click(Sender: TObject);
    procedure SpeedButton62Click(Sender: TObject);
    procedure Edit9KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Description1Click(Sender: TObject);
    procedure Filename1Click(Sender: TObject);
    procedure Selectall5Click(Sender: TObject);
    procedure Invertselection4Click(Sender: TObject);
    procedure PopupMenu9Popup(Sender: TObject);
    procedure Filename2Click(Sender: TObject);
    procedure PopupMenu10Popup(Sender: TObject);
    procedure Paste2Click(Sender: TObject);
    procedure Selectall6Click(Sender: TObject);
    procedure Cut2Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure SpeedButton63Click(Sender: TObject);
    procedure SpeedButton64Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure SpeedButton65Click(Sender: TObject);
    procedure PopupMenu11Popup(Sender: TObject);
    procedure Romspath1Click(Sender: TObject);
    procedure Samplespath1Click(Sender: TObject);
    procedure Chdspath1Click(Sender: TObject);
    procedure ROM1Click(Sender: TObject);
    procedure SAMPLE1Click(Sender: TObject);
    procedure CHD1Click(Sender: TObject);
    procedure Directory1Click(Sender: TObject);
    procedure Desktop1Click(Sender: TObject);
    procedure Desktop2Click(Sender: TObject);
    procedure Directory2Click(Sender: TObject);
    procedure SpeedButton66Click(Sender: TObject);
    procedure ComboBox3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox3Select(Sender: TObject);
    procedure ComboBox3Exit(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure Activaterecursive1Click(Sender: TObject);
    procedure CoolTrayIcon1DblClick(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure CoolTrayIcon1BalloonHintClick(Sender: TObject);
    procedure CRC321Click(Sender: TObject);
    procedure MD51Click(Sender: TObject);
    procedure SHA11Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure Jumptoprofiledirectory1Click(Sender: TObject);
    procedure friendfix1Click(Sender: TObject);
    procedure Shareselected1Click(Sender: TObject);
    procedure Unshareselected1Click(Sender: TObject);
    procedure Community2Click(Sender: TObject);
    procedure ApplicationEvents1Restore(Sender: TObject);
    procedure Sendmissingtorequestlist1Click(Sender: TObject);
    procedure EurekaLog1ExceptionActionNotify(
      EurekaExceptionRecord: TEurekaExceptionRecord;
      EurekaAction: TEurekaActionType; var Execute: Boolean);
    procedure share1Click(Sender: TObject);
    procedure unshare1Click(Sender: TObject);
    procedure jumptodir1Click(Sender: TObject);
    procedure fspTaskbarPreviews1NeedIconicBitmap(Sender: TObject; Width,
      Height: Integer; var Bitmap: HBITMAP);
    procedure fspTaskbarMgr1ThumbButtonClick(Sender: TObject;
      ButtonId: Integer);
    procedure SpeedButton67Click(Sender: TObject);
    procedure Setfilters1Click(Sender: TObject);
    procedure PopupMenu12Popup(Sender: TObject);
    procedure Removefilters1Click(Sender: TObject);
    procedure Applyfilters1Click(Sender: TObject);
    procedure PageControl2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Sendtorequests1Click(Sender: TObject);
    procedure Sendmissingtorequest1Click(Sender: TObject);
    procedure sendtorequest1Click(Sender: TObject);
    function EmbeddedWB1ZoomPercentChange(Sender: TCustomEmbeddedWB;
      const ulZoomPercent: Cardinal): HRESULT;
    procedure SpeedButton71Click(Sender: TObject);
    procedure backuppath1Click(Sender: TObject);
    procedure activate1Click(Sender: TObject);
    procedure deactivate1Click(Sender: TObject);
    procedure activate2Click(Sender: TObject);
    procedure deactivate2Click(Sender: TObject);
    procedure activate3Click(Sender: TObject);
    procedure deactivate3Click(Sender: TObject);
    procedure activate4Click(Sender: TObject);
    procedure deactivate4Click(Sender: TObject);
    procedure setbackupfolder1Click(Sender: TObject);
    procedure RichEditURL1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SevenZip2Listfile(Sender: TObject; Filename: WideString;
      Fileindex, FileSizeU, FileSizeP, Fileattr, Filecrc: Int64;
      Filemethod: WideString; FileTime: Double);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Zip1FileProgress(Sender: TObject; FileName: WideString;
      Progress: Double; Operation: TZFProcessOperation;
      ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
    procedure VirtualStringTree2GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree2GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree2Resize(Sender: TObject);
    procedure VirtualStringTree2DblClick(Sender: TObject);
    procedure VirtualStringTree2HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure VirtualStringTree1Click(Sender: TObject);
    procedure VirtualStringTree1Resize(Sender: TObject);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree1HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree3HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure VirtualStringTree3GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree3GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree3Resize(Sender: TObject);
    procedure VirtualStringTree4GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VirtualStringTree4GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure Expandall2Click(Sender: TObject);
    procedure Collapseall2Click(Sender: TObject);
    procedure VirtualStringTree2IncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: WideString;
      var Result: Integer);
    procedure Stop1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure VirtualStringTree2GetHint(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex;
      var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
    procedure Timer3Timer(Sender: TObject);
    procedure VirtualStringTree2MouseLeave(Sender: TObject);
    procedure VirtualStringTree2GetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure VirtualStringTree2Scroll(Sender: TBaseVirtualTree; DeltaX,
      DeltaY: Integer);
    procedure PopupMenu5Popup(Sender: TObject);
    procedure TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TimerdialogTimer(Sender: TObject);
    procedure VirtualStringTree2DragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure Zip1DiskFull(Sender: TObject; VolumeNumber: Integer;
      VolumeFileName: WideString; var Cancel: Boolean);
    procedure Zip2DiskFull(Sender: TObject; VolumeNumber: Integer;
      VolumeFileName: WideString; var Cancel: Boolean);
    procedure Zip2ConfirmOverwrite(Sender: TObject;
      SourceFileName: WideString; var DestFileName: WideString;
      var Confirm: Boolean);
    procedure Zip1ConfirmOverwrite(Sender: TObject;
      SourceFileName: WideString; var DestFileName: WideString;
      var Confirm: Boolean);
    procedure Zip1RequestFirstVolume(Sender: TObject;
      var VolumeFileName: WideString; var Cancel: Boolean);
    procedure Zip1RequestLastVolume(Sender: TObject;
      var VolumeFileName: WideString; var Cancel: Boolean);
    procedure Zip1RequestMiddleVolume(Sender: TObject;
      VolumeNumber: Integer; var VolumeFileName: WideString;
      var Cancel: Boolean);
    procedure TntFormActivate(Sender: TObject);
    procedure createxmldat1Click(Sender: TObject);
    procedure Directory3Click(Sender: TObject);
    procedure Desktop3Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure copy3Click(Sender: TObject);
    procedure copy4Click(Sender: TObject);
    procedure copy5Click(Sender: TObject);
    procedure copy6Click(Sender: TObject);
    procedure StaticText1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StaticText1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure Stayontop1Click(Sender: TObject);
    procedure Staynormal1Click(Sender: TObject);
    procedure TntSpeedButton1Click(Sender: TObject);
    procedure VirtualStringTree2MouseWheel(Sender: TObject;
      Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure TntPanel4Resize(Sender: TObject);
    procedure Panel65Resize(Sender: TObject);
  private
    { Private declarations }
    FDragPoint: TPoint;
    procedure ModalBegin(Sender: TObject);
    procedure URL_OnDownloadProgress
        (Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean) ;
    procedure WMQueryEndSession(var Msg : TWMQueryEndSession);message WM_QueryEndSession;
  protected

    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMDisplayChange(var Message: TWMDisplayChange);message WM_DISPLAYCHANGE;
  public
    { Public declarations }
    procedure RestoreRequest(var message: TMessage); message CM_RESTORE;
    procedure processnewdat(path:widestring);
    procedure processnewdatshowresults();
    procedure showprocessingwindow(cancancel:boolean;countdown:boolean);
    procedure hideprocessingwindow;
    procedure fixcomponentsbugs(F:TTntform);
    procedure createorloaddatabase(filename:widestring;forcecreate:boolean);
    Procedure MoveNode(TargetNode, SourceNode : TTnttreenode);
    function nodepathexists(tv:TTnttreeview;path:widestring):TTnttreenode;
    function Gettreepath(pTreeNode: TTnttreenode; var path: widestring): widestring;
    procedure deletenode(n:Ttnttreenode);
    procedure editnode(n:TTnttreenode;new:widestring);
    procedure showprofiles(progress:boolean);
    procedure showprofilesselected;
    function getcurrentprofileid():ansistring;
    procedure Scandirectory(path, mask : widestring;action:integer; brec : Boolean);
    procedure createnewprofiledetail(id:ansistring;description:widestring);
    procedure showcurrentscantab(forzedmaster,forzeddetail:boolean;id:ansistring);
    procedure deletecurrentscantab;
    procedure deleteallscantabs;
    procedure deletescantabs(i:integer);
    procedure traductfmain;
    function getdbid():string;
    procedure speedupdb;
    procedure addprofilesfielddefs(T:Tabstable);
    procedure waitforfinishthread;
    procedure showprolesmasterdetail(master,detail:boolean;id:ansistring;progress:boolean;saverestorefocus:boolean);
    procedure showprofilesmasterselected;
    procedure showprofilesdetailselected;
    procedure deletetab(id:ansistring);
    function zipvalidfile(path:widestring;z:Tzipforge):boolean;
    function rarvalidfile(path:widestring;Rar:Trar):boolean;
    function sevenzipvalidfile(path:widestring;sz:Tsevenzip):boolean;
    function addfiletozip(frompath,filename,zipfilename:widestring;level:smallint;realcrc,realspace:string):boolean;
    function addfiletorar(frompath,filename,rarfilename:widestring;level:smallint;realcrc,realspace:string):boolean;
    function addfiletosevenzip(frompath,filename,sevenzipfilename:widestring;level:smallint;realcrc,realspace:string):boolean;
    function addfiletosevenzip_ALT(frompath,filename,sevenzipfilename:widestring;level:smallint;realcrc,realspace:string):boolean;
    function extractfilefromsevenzip(sevenzip:Tsevenzip;fileinside:widestring;extractpath:widestring;reuse:boolean):boolean;
    function extractfilefromzip(z:Tzipforge;fileinside:widestring;extractpath:widestring;reuse:boolean):boolean;
    function extractfilefromrar(rar:Trar;fileinside:widestring;extractpath:widestring;reuse:boolean):boolean;
    procedure priority(i:integer);
    procedure savefocussedcontrol;
    procedure restorefocussedcontrol;
    procedure loadconfig;
    procedure saveconfig;
    procedure setstayontop;
    function importdat(path:widestring;id:longint):shortint;
    procedure loadimages;
    procedure setimagepath(edit:TTntedit);
    procedure Setdefaultbitmap;
    procedure findinlistview(lv:TVirtualStringTree;T:Tabstable;down:boolean;edit:TTntedit;fieldname:ansistring);
    procedure findinlistviewscanner(down:boolean);
    procedure setpopupemulatorslist;
    procedure emuclick(Sender: TObject);
    procedure currentdbstatusname;
    procedure showprofilestotalpanel(total:longint);
    function deletefilefromzip(zip:Tzipforge;path:widestring):boolean;
    function deletefilefromrar(rar:Trar;path:widestring):boolean;
    function deletefilefromsevenzip(sevenzip:Tsevenzip;path:widestring):boolean;
    function deletefilefromsevenzip_ALT(sevenzip:Tsevenzip;path:widestring):boolean;
    procedure createffix(all:boolean);
    procedure dbtodat;
    procedure lvClick(Sender: TObject);
    procedure constructorchecknext(b:boolean;var checkedsets:longint;var checkedroms:longint;var totalsets:longint; var totalroms:longint);
    procedure constructorstatuslite(checkedsets,checkedroms,totalsets,totalroms:longint);
    procedure adderror(text:widestring);
    procedure buildingchecksums(folder:boolean);
    procedure findinlistviewbuilder(down:boolean);
    procedure checkconstructorstatus;
    procedure checkselectedconstructor(b:boolean);
    procedure showconstructorselected;
    procedure traductvirtualcolumns;
    procedure fixcolumnsdragged(lv:Tlistview);
    function openandselectinbrowser(path:widestring):boolean;
    procedure fixpossibleemptysetconstructor(origin:longint);
    procedure TabMenuPopup(APageControl: TTntpagecontrol; X, Y: Integer);
    procedure setwinvista7theme(hdw:HWND);
    procedure setlangchanged;
    procedure removedatabaseinconsistences;
    procedure sortcolumn(lv:TVirtualStringtree;id:integer);
    function sqlsortcolumn(lv:TVirtualStringTree):ansistring;
    procedure wb_navigate(url:widestring;newtab:boolean;ownforzed:boolean);
    procedure wb_search(wb:TEmbeddedWB;text:widestring;down:boolean);
    function wb_current():TEmbeddedWB;
    procedure wb_updateurlbar(wb:TEmbeddedWB);
    procedure wb_updatecontrols(wb:TEmbeddedWB);
    procedure wb_TitleChange(ASender: TObject;const Text: WideString);
    procedure wb_CommandStateChange(ASender: TObject;Command: Integer; Enable: WordBool);
    procedure wb_NavigateError(ASender: TObject;const pDisp: IDispatch; var URL, Frame, StatusCode: OleVariant;var Cancel: WordBool);
    procedure wb_appendtext(text:ansistring;wb:TEmbeddedWB);
    procedure wb_defaultpage(wb:TEmbeddedWB;info:boolean);
    procedure wb_hidenotcurrent;
    procedure deletecurrentwebtab;
    procedure deleteallwebtabs;
    function gettrimmedtext(text:widestring;textwidth:integer):widestring;
    procedure searchingoogle(text:widestring;newtab:boolean;ownforzed:boolean);
    procedure EditEnter(Sender: TObject);
    procedure checkeditpopup;
    procedure uncheckallconstructor;
    procedure invertcheckedconstructor;
    function downloadfile2(urldown:ansistring;dest:widestring;progress:boolean):boolean;
    procedure setfilescanselection(id:longint);
    procedure extractselection(frommaster:boolean;ignorecompress:boolean;path:widestring);
    function createorloadurllist():boolean;
    function createorloadserverslist():boolean;
    procedure Richedit2URLClick(Sender: TObject; const URL: String);
    procedure checksleep;
    procedure addtoactiveform(f:Tform;add:boolean);
    procedure showballoon(title:widestring;msg:widestring;secs:integer;icon:Tballoonhinticon);
    procedure taskbaractive(b:boolean);
    function isdbcorrectversion(Dbcheck:Tabsdatabase):boolean;
    procedure shareselection(share:boolean);
    procedure missingtorequest(from:integer);
    procedure checkusername;
    procedure showfserver;
    procedure tabprofilesharing(b:boolean);
    function CloneComponent(AAncestor: TComponent;id:ansistring): TComponent;
    procedure labelshadow(l:Ttntlabel;F:Ttntform);
    procedure updatemasterpanel;
    procedure checkfilterglyph;
    procedure onthreadconstructor(param:string);
    procedure onthreadquery2table();
    procedure wb_zoomtotrackbar(zoom:cardinal);
    procedure selectedprofilestobool(fieldname:string;value:boolean);
    procedure selectedprofilestobackup;
    procedure showmyquerys;
    procedure flash;
    procedure setgridlines(lv:TVirtualStringTree;done:boolean);
    procedure destroycustomhint();
    function getpanelfilter():TTntpanel;
    procedure applyfilterlaststep(apply:boolean);
    procedure positiondialogstart();
    function extractmethodhack(nam:string;filenam:widestring;fileinside:widestring;extractpath:widestring;var tpath:widestring;reuse:boolean):boolean;
    procedure initializeextractionfolders();
    procedure RicheditURLClick(Sender: TObject;
  const URLText: string; Button: TMouseButton);
    procedure closepossiblyopenzip;
    procedure compresscache(filename:widestring);
    procedure WMTHEMECHANGED(var Msg: TMessage); message WM_THEMECHANGED;
    procedure WMSYSCOLORCHANGE(var Msg: TMessage); message WM_SYSCOLORCHANGE;
    procedure fixsystemcolors();
    procedure loadthemedcheckboxes;
    procedure setlabeltoprogressbar(lb:Ttntlabel;pb:Tprogressbar);
    procedure initializeprogresslabel(lb:Ttntlabel);
    procedure DeleteIECache(url : ansistring);
    procedure ScaleForm
    (F: TForm; ScreenWidth, ScreenHeight: LongInt) ;
    procedure formatxmlthread(path:widestring);
    procedure settrayicon();
    procedure scanorrebuildinbatch(toscan,onlyone:boolean);
    procedure addclosebuttontab(Fromform:Ttntform;pagecontrol:Tpagecontrol;x,y,correction:integer);
    function getnodetextundermouse(vt:Tvirtualstringtree):widestring;
    procedure flashstop;
    procedure refreshallfaces;
    procedure unlocksearchfolder;
    function displayfolderdialog(initialdir:widestring;title:widestring):boolean;
    function displayopendialog(initialdir:widestring;title:widestring;multifile:boolean;filter:widestring):boolean;
    function displaysavedialog(initialdir:widestring;title:widestring;filter:widestring):boolean;
    procedure setstaystatuslabel;
    procedure setgeneratorpathlabel;
  end;

var
  Fmain: TFmain;
  sterrors,stcompfiles,stcompfiles2,stdropfolders,stsimplehash,stsimplehashreb:TTntStringList;
  stcompcrcs,stcompcrcs2,stcompsizes,stcompsizes2,datgroups:Tstringlist;
  imported,decision,romscounter,maxloglines:longint;
  masterlv,detaillv:TVirtualStringTree;
  masteredit,detailedit:TTntedit;
  mastertable,detailtable,clonetable,offinfotable:Tabstable;
  detailhave,detailmiss,detailtotal,masterselected,detailselected:TTntpanel;
  visiblehave,visiblemiss,searchromulsupdates:boolean;
  showasbytes,askforclose:boolean;
  defromscomp,defsamplescomp,defchdscomp:smallint;
  defofffilename,imagespath:widestring;
  initialdirimportdat,initaldiropendatabase,initialdirimportmameexe,initialdirsharefile:widestring;
  initialdirsavedb,initialdirrebuild,initialdirexport,initialdiremulator,initialdirffix,initialdirxmlexport:widestring;
  initialdirroms,initialdirimages,initialdirlog,initialdirhash,initialdirfoldcreator,initialdirextract,initialdirxmlcreation:widestring;
  png,png2:TPNGObject;
  pngstream:TTntMemoryStream;
  bmp:Tbitmap;
  rar1filename,rar2filename,sevenzip1filename,sevenzip2filename,sourcebuilder:widestring;
  DBaux:TABSDatabase;
  xmlexport:Textfile;
  opt1,opt2,opt3,Foldname,Recdir,updatinglist,useownwb,startupdate,solidcomp,multicpu:boolean;
  fix0,fix1,fix2,fix3,fix4,fix5,fix6,fix7:string;
  mouselink,statuslink:widestring;
  Saved8087CW: Word;
  Focussededit: TTntedit;
  Focussedcombo: TTntcombobox;
  Focussedrich: TRxRichEdit;
  Focussedtntrich : Ttntrichedit;
  filtertext,communitydownfolder: widestring;
  filterdetection, filtersearchin :shortint;
  filtermatch, filteruncheck, preventsleep :boolean;
  downloadprogressposition,downloadprogresstotal:longint;
  Dbcheck:Tabsdatabase;
  startupconnect,agressive,firewall,userar5,colorcolumns:boolean;
  upslots,downslots:shortint;
  upspeed,downspeed:integer;
  connectionport:integer;
  servertransparency:Integer;
  flashing,ingridlines,zip1multivolume,zip2multivolume,rar1multivolume,sevenzip1multivolume:boolean;
  currenthint:widestring;
  lasttreenode:TTntTreeNode;
  dialogcounter:shortint;
  lastextracted1,lastextracted2,lastcompfile2:widestring;
  lastcompdate2:integer;
  isfiledialog,isserverdialog:boolean;
  Threadstodestroy:Tstringlist;
  batchlist:Tstringlist;
  dialoglist:TTntstringlist;
  updaterdatsdecision:Shortint;

implementation

uses Unewfolder, Umessage, Uprocessing, Usettings, Ureport, Types, Math,
  Ulog, Uofflineupdate, Uemulators, Uproperties, Uupdater,
  Udirmaker, Uask, Ufavorites, Uupdatedat, Userver, Uofflinefilters,
  TntWideStrings, DateUtils, Usoftselect, Uscene;

{$R *.dfm}

{TAGS
Treeview1 = Enable or disable showprofiles procedure
Fnewfolder = Ok or Cancel new folder insertion
Self = Bugfix onshow
Pagecontrol1 = Know the last tab pressed to know if next can be pressed too
Fnewdat = Know the option pressed
Fmessage = Know the option pressed
progressbar1 = Simple counter
timer1 = Simple counter
listview1 = Know the column to sort
panel9 = Know sort listview1 direction
}


type
  TTabSheetEx = class(TTnttabsheet)
  private
    EWB: TEmbeddedWB;
    CanBack: Boolean;
    CanForward: Boolean;
    Canstop: Boolean;
    favicourl : ansistring;
  end;

//----HINT STYLES--------------------------------------------------------

type
   TMyHintWindow = class(THintWindow)
   private
    FBitmap: TBitmap;
    FRegion: THandle;
    procedure FreeRegion;
   protected
    procedure CreateParams (var Params: TCreateParams); override;
    procedure Paint; override;
    procedure Erase(var Message: TMessage); message WM_ERASEBKGND;
   public
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     procedure ActivateHint(Rect: TRect; const AHint: string); Override;
   end;

constructor TMyHintWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf24bit;
end;

destructor TMyHintWindow.Destroy;
begin
  FBitmap.Free;
  FreeRegion;
  inherited;
end;

procedure TMyHintWindow.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $20000;
begin
  inherited;
  Params.Style := Params.Style - WS_BORDER;
  Params.WindowClass.Style := Params.WindowClass.style or CS_DROPSHADOW;
end;

procedure TMyHintWindow.FreeRegion;
begin
  if FRegion <> 0 then
  begin
    SetWindowRgn(Handle, 0, True);
    DeleteObject(FRegion);
    FRegion := 0;
  end;
end;

procedure TMyHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
vista7hint:boolean;
r:Trect;
ctrl:Tcontrol;
begin
  vista7hint:=false;

  ctrl := FindVCLWindow(Mouse.CursorPos) ;
  if ctrl is Ttntspeedbutton then
    currenthint:=(ctrl as Ttntspeedbutton).hint
  else
  if ctrl is TTntTreeView then
    if currenthint='' then begin //Empty treeview hints fix 0.026
      exit;
    end;

  r:=screen.monitorfromwindow(screen.activeform.Handle).BoundsRect;//FIX SINZE 0.024 MULTIMONITOR
                             
  if (Win32MajorVersion>=6) AND (ThemeServices.ThemesEnabled=true) then
    vista7hint := true;
                                                   //WIN10 RECTANGLE HINTS 0.032
  if (OS_IsWindows8=true) OR (Win32MajorVersion>=10) then
    vista7hint:=false;

  Caption := AHint;
  //Rect is possition of hint

  Canvas.Font := Application.MainForm.Font;
  FBitmap.Canvas.Font := Application.MainForm.Font;
  DrawTextw(Canvas.Handle, PwideChar(currenthint), Length(currenthint), Rect, DT_CALCRECT  or DT_NOPREFIX);

  //Size of hint
  if vista7hint=true then begin
    Width := (Rect.Right - Rect.Left) + 16;
    Height := (Rect.Bottom - Rect.Top) + 10;//10
  end
  else begin
    Width := (Rect.Right - Rect.Left) + 10;
    Height := (Rect.Bottom - Rect.Top) + 6;
  end;

  FBitmap.Width := Width;
  FBitmap.Height := Height;

  //FIX OUT OF SCREEN HINT     //FIX SINZE 0.024 MULTIMONITOR
  if FBitmap.Width+rect.Left>r.Right then begin
    Left := Rect.Left - ((FBitmap.Width+rect.Left)-r.right);
    top:= Rect.Top;
  end
  else begin
    Left := Rect.Left;
    Top := Rect.Top;
  end;

  if left<r.Left then //FIX SINZE 0.024 MULTIMONITOR
    left:=r.left;

  if top>r.Bottom-20 then begin //FIX SINZE 0.024 MULTIMONITOR
    top:=top-(top-r.bottom)-20;
  end;

  FreeRegion;

  if vista7hint=true then begin
    with Rect do
      FRegion := CreateRoundRectRgn(1, 1, Width, Height, 3, 3);
    if FRegion <> 0 then
      SetWindowRgn(Handle, FRegion, True);

    //AnimateWindowProc(Handle, 300, AW_BLEND);
  end;

  SetWindowPos(Handle, HWND_TOPMOST, Left, Top, 0, 0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
end;

procedure DrawGradientVertical(Canvas: TCanvas; Rect: TRect; FromColor, ToColor: TColor);
var
  i, Y: Integer;
  R, G, B: Byte;
begin
   i := 0;
   for Y := Rect.Top to Rect.Bottom - 1 do
   begin
      R := GetRValue(FromColor) + Ceil(((GetRValue(ToColor) - GetRValue(FromColor)) / Rect.Bottom-Rect.Top) * i);
      G := GetGValue(FromColor) + Ceil(((GetGValue(ToColor) - GetGValue(FromColor)) / Rect.Bottom-Rect.Top) * i);
      B := GetBValue(FromColor) + Ceil(((GetBValue(ToColor) - GetBValue(FromColor)) / Rect.Bottom-Rect.Top) * i);
      Canvas.Pen.Color := RGB(R, G, B);
      Canvas.MoveTo(Rect.Left, Y);
      Canvas.LineTo(Rect.Right, Y);
      Inc(i);
   end;
end;

procedure TMyHintWindow.Paint;
var
  CaptionRect: TRect;
  vista7hint: boolean;
  ctrl:Tcontrol;
begin
  vista7hint:=false;

  ctrl := FindVCLWindow(Mouse.CursorPos) ;
  if ctrl is Ttntspeedbutton then
    currenthint:=(ctrl as Ttntspeedbutton).hint;

  if (Win32MajorVersion>=6) AND (ThemeServices.ThemesEnabled=true) then
    vista7hint := true;
                                          //WIN10 RECTANGLE HINTS 0.032
  if (OS_IsWindows8=true) OR (Win32MajorVersion>=10) then
    vista7hint:=false;

  if vista7hint=true then begin

    DrawGradientVertical(FBitmap.Canvas, GetClientRect, RGB(255, 255, 255),  RGB(229, 229, 240));

    with FBitmap.Canvas do
    begin
      //Font.Color := RGB(118, 118, 118);
      Font.color:=$767676;//0.029
      Brush.Style := bsClear;
      Pen.Color := Font.Color;
      RoundRect(1, 1, Width - 1, Height - 1, 6, 6);
      RoundRect(1, 1, Width - 1, Height - 1, 3, 3);
    end;
                  
    //0.028 CHANGED TO CENTER HINTS
    captionrect:=Rect(8,(FBitmap.height div 2)-(WideCanvasTextHeight(Fbitmap.Canvas,currenthint) div 2),width,height);

  end
  else begin

    with FBitmap.Canvas do
    begin

      if (Win32MajorVersion>=6) AND (ThemeServices.ThemesEnabled=true) then begin //WIN8 AND NEXT THEMED HINT STYLES
        //LIKE VISTA & 7 BUT NOT ROUNDED
        DrawGradientVertical(FBitmap.Canvas, GetClientRect, RGB(255, 255, 255),  RGB(229, 229, 240));
        Brush.Style := bsClear;
        Font.color:=$767676;//0.029
        //Font.Color := RGB(118, 118, 118);
        Pen.Color:= Font.color;
      end
      else begin  //NO THEME
        Brush.Style := bsSolid;
        Font.Color := clwindowtext;
        Brush.Color := clInfoBk;
        Pen.Color := clwindowtext;
      end;

      Rectangle(0, 0, Width, Height);
    end;

    //CaptionRect := Rect(5, 3, Width, Height); < 0.028
                                       //0.028 CHANGED TO CENTER HINTS
    captionrect:=Rect(5,(FBitmap.height div 2)-(WideCanvasTextHeight(Fbitmap.Canvas,currenthint) div 2),width,height);
  end;

  captionrect.Top:=captionrect.Top-1;//FIX POSSITION 0.029

  DrawTextw(FBitmap.Canvas.Handle, PwideChar(currenthint), Length(currenthint), CaptionRect, DT_WORDBREAK or DT_NOPREFIX);
  BitBlt(Canvas.Handle, 0, 0, Width, Height, FBitmap.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TMyHintWindow.Erase(var Message: TMessage);
begin
  Message.Result := 0;
end;

var
  hintwin:TMyHintWindow;

procedure Tfmain.destroycustomhint();
begin
FreeAndNil(hintwin);
end;

procedure Tfmain.WMDisplayChange(var Message: TWMDisplayChange);
begin

end;

procedure Tfmain.WMQueryEndSession
      (var Msg : TWMQueryEndSession) ;
begin

if preventsleep=true then begin
  if SystemCritical.IsCritical=true then
    Msg.Result := 0
  else
    Msg.Result := 1;
end
else
  Msg.Result := 1;
end;

procedure TFmain.fixsystemcolors();
var
x,y:integer;
cl:Tcolor;
begin
//FORZES REGENERATE CHECKBOXES IMAGES FOR GENERATOR OPTION 0.029
VirtualStringTree4.Tag:=1;

//FIX IMG32 BG COLOR
for x:=0 to Application.ComponentCount-1 do
  if Application.Components[x] is TTntForm then
    for y:=0 to (Application.Components[x] as TTntForm).ComponentCount-1 do
      if ((Application.Components[x] as TTntForm).Components[y] is Timage32) then begin
        cl:=((Application.Components[x] as TTntForm).Components[y] as Timage32).Color;
        ((Application.Components[x] as TTntForm).Components[y] as Timage32).Color:=Tcolor(clnone);
        ((Application.Components[x] as TTntForm).Components[y] as Timage32).Color:=cl;
      end
      else
      if ((Application.Components[x] as TTntForm).Components[y] is TTnttreeview) then begin
        cl:=((Application.Components[x] as TTntForm).Components[y] as TTnttreeview).Color;
        ((Application.Components[x] as TTntForm).Components[y] as TTnttreeview).Color:=Tcolor(clnone);
        ((Application.Components[x] as TTntForm).Components[y] as TTnttreeview).Color:=cl;
        cl:=((Application.Components[x] as TTntForm).Components[y] as TTnttreeview).Font.Color;
        ((Application.Components[x] as TTntForm).Components[y] as TTnttreeview).Font.Color:=Tcolor(clnone);
        ((Application.Components[x] as TTntForm).Components[y] as TTnttreeview).Font.Color:=cl;
        setwinvista7theme(((Application.Components[x] as TTntForm).Components[y] as TTnttreeview).handle);
      end
      else
      if ((Application.Components[x] as TTntForm).Components[y] is TProgressBar) then
        SendMessage(((Application.Components[x] as TTntForm).Components[y] as TProgressBar).Handle, PBM_SETBARCOLOR, 0, clgreen);


end;

procedure Tfmain.WMSYSCOLORCHANGE(var Msg: TMessage);
begin
Msg.Result := 0;
fixsystemcolors;
end;

procedure Tfmain.WMTHEMECHANGED(var Msg: TMessage);
begin
Msg.Result:=0;
fixsystemcolors;
end;

function EnumWindowsProc2(wHandle: HWND; param : integer): BOOL; stdcall;
var
ClassName: array[0..255] of char;
begin
  GetClassName(wHandle, ClassName, 255);

  if classname='#32770' then
    if (getparent(whandle)=Application.Handle) then
      isfiledialog:=true;
end;

procedure Tfmain.setstaystatuslabel;
begin
if Stayontop1.Checked then begin
  tntpanel5.Caption:=traduction(43);
  tntpanel5.Font.Style:=tntpanel5.Font.Style+[fsBold];
end
else begin
  tntpanel5.Caption:=traduction(44);
  tntpanel5.Font.Style:=tntpanel5.Font.Style-[fsBold];
end;

end;

procedure Tfmain.setgeneratorpathlabel;
begin

if formexists('Flog')=false then //FIX
  exit;

if VirtualStringTree4.RootNodeCount=0 then begin
  panel65.Caption:=gettrimmedtext(changein(traduction(232)+' : '+traduction(347),'&','&&'),panel65.width-20);
end
else
  panel65.Caption:=gettrimmedtext(changein(traduction(232)+' : '+sourcebuilder,'&','&&'),panel65.width-20);

end;

//SET TO FROM THE DIALOG
function EnumWindowsProc3(wHandle: HWND; param : integer): BOOL; stdcall;
var
ClassName: array[0..255] of char;
begin
  GetClassName(wHandle, ClassName, 255);

  if classname='#32770' then
    if (getparent(whandle)=Application.Handle) then
      BringWindowToTop(whandle)
end;

function Tfmain.displayfolderdialog(initialdir:widestring;title:widestring):boolean;
begin
Result:=true;
Application.CreateForm(TFdialog, Fdialog);
Fdialog.Splitter1.Visible:=false;
Fdialog.VirtualStringTree1.Visible:=false;
Fdialog.TntTreeView1.Align:=alclient;

startdir:='';

//DRIVE EMPTY OR DOES NOT EXISTS
if WideDirectoryExists(checkpathbar(wideextractfiledrive(initialdir)))=true then
  startdir:=initialdir
else
  startdir:=checkpathbar(wideextractfiledrive(WideSystemDir));

//GetLongNameFromShort()
Fdialog.Caption:=title;

myshowform(Fdialog,true);

if Fdialog.Tag=1 then
  Result:=true;

Freeandnil(Fdialog);
end;

function Tfmain.displayopendialog(initialdir:widestring;title:widestring;multifile:boolean;filter:widestring):boolean;
var
x:integer;
f:widestring;
begin
Result:=false;
Application.CreateForm(TFdialog, Fdialog);
startdir:='';

//DRIVE EMPTY OR DOES NOT EXISTS
if WideDirectoryExists(checkpathbar(wideextractfiledrive(initialdir)))=true then
  startdir:=initialdir
else
  startdir:=checkpathbar(wideextractfiledrive(WideSystemDir));

Fdialog.Caption:=title;
if multifile=true then
  Fdialog.VirtualStringTree1.TreeOptions.SelectionOptions:=Fdialog.VirtualStringTree1.TreeOptions.SelectionOptions+[toMultiSelect];

f:=gettoken(filter,'|',2);
if f<>'*.*' then
  for x:=1 to GetTokenCount(f,';') do
    Fdialog.TntListBox2.Items.Add(wideuppercase(changein(gettoken(f,';',x),'*','')));

Fdialog.TntLabel3.Caption:=gettoken(filter,'|',1);
Fdialog.TntEdit1.ReadOnly:=true;
Fdialog.TntEdit1.Color:=clbtnface;

myshowform(Fdialog,true);

if Fdialog.Tag=1 then
  Result:=true;

Freeandnil(Fdialog);
end;

function Tfmain.displaysavedialog(initialdir:widestring;title:widestring;filter:widestring):boolean;
var
x:integer;
f:widestring;
begin
Result:=false;
Application.CreateForm(TFdialog, Fdialog);
startdir:='';

//DRIVE EMPTY OR DOES NOT EXISTS
if WideDirectoryExists(checkpathbar(wideextractfiledrive(initialdir)))=true then
  startdir:=initialdir
else
  startdir:=checkpathbar(wideextractfiledrive(WideSystemDir));

Fdialog.Caption:=title;

f:=gettoken(filter,'|',2);
if f<>'*.*' then
  for x:=1 to GetTokenCount(f,';') do
    Fdialog.TntListBox2.Items.Add(wideuppercase(changein(gettoken(f,';',x),'*','')));

Fdialog.TntLabel3.Caption:=gettoken(filter,'|',1);
Fdialog.TntBitBtn3.Left:=Fdialog.TntBitBtn1.Left;
Fdialog.TntBitBtn1.Visible:=false;
Fdialog.TntBitBtn3.Visible:=true;

myshowform(Fdialog,true);

if Fdialog.Tag=1 then
  Result:=true;

Freeandnil(Fdialog);
end;


procedure Tfmain.settrayicon();
var
id,x:integer;
begin
id:=34;
case Fserver.IdTCPClient1.Tag of
  0:id:=34;//NORMAL
  1:id:=35;//CONECTED
  2:id:=37;//CONNECTING
end;

if Fserver.Tag=1 then
  id:=42
else
if Fserver.PageControl1.Pages[4].Highlighted=true then begin
  id:=42;
end
else
for x:=0 to Fserver.PageControl2.PageCount-1 do
  if Fserver.PageControl2.Pages[x].Highlighted=true then begin
    id:=42;
    break;
  end;

if id=42 then begin
  ImageList2.GetIcon(42,fspTaskbarMgr1.OverlayIcon);
end
else begin
  fspTaskbarMgr1.OverlayIcon:=nil;
end;

if Cooltrayicon1.Tag=0 then  //FORCE SHOW TASKBAR IF NOT HIDDEN
  CoolTrayIcon1.ShowTaskbarIcon;

Fmain.CoolTrayIcon1.IconIndex:=id;
end;

procedure Tfmain.unlocksearchfolder;
var
Filesearch:TSearchRecW;
begin
WideSetCurrentDir(checkpathbar(WideExtractFilePath(TntApplication.ExeName)));
try
  wideFindFirst('*.*', faDirectory or fahidden, FileSearch);
  WideFindClose(FileSearch);
except
end;

end;

procedure Tfmain.initializeprogresslabel(lb:Ttntlabel);
begin
lb.Caption:='0'+decimalseparator+'00 %';
end;

procedure Tfmain.setlabeltoprogressbar(lb:Ttntlabel;pb:Tprogressbar);
begin
lb.Parent := pb;
lb.AutoSize := False;
lb.Transparent := True;
lb.Top :=  0;
lb.Left :=  0;
lb.Width := pb.ClientWidth;
lb.Height := pb.ClientHeight;
lb.Alignment := taCenter;
lb.Layout := tlCenter;
lb.Anchors:=lb.Anchors+[akRight];

initializeprogresslabel(lb);
end;

procedure Tfmain.refreshallfaces;
var
x,o:integer;
begin
for x:=1 to pagecontrol2.PageCount-1 do begin
  o:=pagecontrol2.Pages[x].ImageIndex;
  pagecontrol2.Pages[x].ImageIndex:=-1;
  pagecontrol2.Pages[x].ImageIndex:=o;
end;
end;

procedure Tfmain.scanorrebuildinbatch(toscan,onlyone:boolean);
var
x:integer;
n:Pvirtualnode;
scanned,fromprofiles:boolean;
path:widestring;
continue:boolean;
begin
fromprofiles:=false;
continue:=true;
if PageControl1.ActivePageIndex=0 then begin

  fromprofiles:=true;
  if virtualstringtree2.SelectedCount=0 then
    exit;

end
else
if pagecontrol1.ActivePageIndex=1 then begin

  if pagecontrol2.PageCount<=1 then
    exit;
end
else
  exit;


if toscan=false then begin

  if pagecontrol1.ActivePageIndex=1 then
    if onlyone=true then
      if ExplorerDrop2.Tag=1 then  //IF REBUILDED FROM DROPPED FOLDERS/FILES
        continue:=false;

  if continue=true then begin

    path:=folderdialoginitialdircheck(initialdirrebuild);

    stdropfolders.Clear;

    positiondialogstart;

    if wideselectdirectory(traduction(285)+' :','',path) then begin
      path:=checkpathbar(path);
      initialdirrebuild:=path;
      stdropfolders.Add(path);
    end
    else
      exit;

  end;

  isrebuild:=true;
  isrebuildbatch:=true;
end
else begin
  isrebuild:=false;
  isrebuildbatch:=false;
end;

//savefocussedcontrol;
batchlist.clear;

stop:=false;
scanned:=false;

if fromprofiles=true then begin  //GET BATCH PROFILES LIST

  n:=VirtualStringTree2.GetFirst;

  if VirtualStringTree2.SelectedCount>0 then
    for x:=0 to VirtualStringTree2.RootNodeCount-1 do begin
      if VirtualStringTree2.Selected[n]=true then begin
        Datamodule1.Tprofilesview.Locate('CONT',n.Index+1,[]);
        batchlist.Add(DataModule1.Tprofilesview.fieldbyname('ID').asstring);
      end;
      n:=virtualstringtree2.GetNext(n);
    end;

end
else begin  //GET BATCH PROFILES LOADED TAB LIST
  if onlyone=true then begin
    batchlist.add(gettoken(PageControl2.ActivePage.Name,'_',3));
  end
  else begin
    for x:=1 to PageControl2.PageCount-1 do
      batchlist.add(gettoken(pagecontrol2.Pages[x].Name,'_',3));
  end;
end;

Application.CreateForm(TFscan, Fscan);

//INITIALIZATION

Fask.tag:=1;
Fscan.loadprofile(batchlist.Strings[0]);
Fscan.panel4.Caption:=traduction(166)+' 1 / '+inttostr(batchlist.Count);
Flog.SpeedButton2.Enabled:=false;
Fscan.Tag:=1;

myshowform(Fask,true);

if Fask.bitbtn1.tag<>0 then begin//CANCELLED
  myshowform(Fscan,true);

  //SECURITY CLOSE
  Datamodule1.Tscansets.close;
  Datamodule1.Tscanroms.close;
  Datamodule1.Tinvertedcrc.close;
  Datamodule1.DBHeaders.Close;

  if Fscan.BitBtn2.tag=1 then
    scanned:=true;

end;

stdropfolders.clear;

Freeandnil(Fscan);

try  //0.030
  ShowWindow(Flog.Handle,SW_HIDE);
except
end;

if scanned=true then
  showprofiles(true);

taskbaractive(false);

//restorefocussedcontrol;
end;

procedure Tfmain.formatxmlthread(path:widestring);
begin
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Text:='FORMATXML '+UTF8Encode(path);

bmdthread1.Start();
waitforfinishthread;
end;

function EditStreamOutCallback(dwCookie: Longint; pbBuff: PByte; cb: Longint;
  var pcb: LongInt): LongInt; stdcall;
begin
  pcb := cb;
  if cb > 0 then
  begin
    TStream(dwCookie).WriteBuffer(pbBuff^, cb);
    Result := 0;
  end
  else
    Result := 1;
end;

procedure GetRTFSelection(aRichEdit: TRxRichEdit; intoStream: TStream);
type
  TEditStreamCallBack = function (dwCookie: longint; pbBuff: PByte;
    cb: Longint; var pcb: Longint): Longint; stdcall;

  TEditStream = packed record // <-- Note packed !!
    dwCookie: longint;
    dwError: Longint;
    pfnCallback: TEditStreamCallBack;
  end;

var
  editstream: TEditStream;
begin
  with editstream do
  begin
    dwCookie := longint(intoStream);
    dwError := 0;
    pfnCallback := EditStreamOutCallBack;
  end;
  aRichedit.Perform( EM_STREAMOUT, SF_RTF or SFF_SELECTION, LPARAM(@editstream));
end;

type
  TTextRangeW = record
    chrg: TCharRange;
    lpstrText: PWideChar;
  end;

function GetTextRange(h:Trxrichedit;StartPos, EndPos: Longint): widestring;
var
  TextRange: TTextRangew;
begin
  SetLength(Result, EndPos - StartPos + 1);
  TextRange.chrg.cpMin := StartPos;
  TextRange.chrg.cpMax := EndPos;
  TextRange.lpstrText := PwideChar(Result);
  SetLength(Result, SendMessagew(h.handle, EM_GETTEXTRANGE, 0, Longint(@TextRange)));
end;

procedure Tfmain.RicheditURLClick(Sender: TObject;
  const URLText: string; Button: TMouseButton);
var
st:TMemoryStream;
init:longint;
cutsep1,cutsep2:string;
row,col,i,j:integer;
t:widestring;
begin
if button<>mbleft then
  exit;

//SELECT WORD
cutsep1:=' ';
cutsep2:=' ';
if changein(urltext,' ','')<>urltext then begin  //NO SPACES NO BRAKETS
  cutsep1:='<';
  cutsep2:='>';
end;

init:=TRxRichEdit(Sender).SelStart;
st := TmemoryStream.Create;
TRxRichEdit(Sender).Lines.SaveToStream(st);
st.Position:=0;
Fakeunicoderich.Lines.LoadFromStream(st);
freeandnil(st);
Fakeunicoderich.SelStart:=init;

Row := SendMessage(Fakeunicoderich.Handle, EM_LineFromChar, Fakeunicoderich.SelStart, 0);
Col := Fakeunicoderich.SelStart - SendMessage(Fakeunicoderich.Handle, EM_LineIndex, Row, 0);
t:=Fakeunicoderich.lines[row];
i:=col;
j:=col;
while (i>0) and (copy(t,i,1)<>cutsep1) do dec(i,1);
while (j<=length(t)) and (copy(t,j,1)<>cutsep2) do inc(j,1);

inc(i,1);
t:=copy(t,i,j-i);

if Length(t)>2 then begin //FIX
  if t[1]='<' then
    t:=copy(t,2,length(t));

  if t[Length(t)]='>' then
    t:=copy(t,1,length(t)-1);
end;

//wideshowmessage(t);

if isthisvalidurlfile(t) then
  ShellExecutew(Handle,'OPEN',Pwidechar(widestring('explorer.exe')),Pwidechar('/select, "' + t + '"'),nil,SW_NORMAL)
else
if isthisvalidurl(t) then
  wb_navigate(t,true,false);
          
end;

procedure Tfmain.closepossiblyopenzip;
begin
try
  Fmain.Zip1.CloseArchive;
finally
  Fmain.Zip1.tag:=0;
end;

end;

//-COMMUNITY-----------------------------------------------

procedure Tfmain.showfserver;
var
x:integer;
begin
x:=0;
isfiledialog:=false;

EnumWindows(@EnumWindowsProc2, LPARAM(x));//DETECT EXISTING OPENEND DIALOGS
if isfiledialog=true then begin
  EnumWindows(@EnumWindowsProc3, LPARAM(x));//DETECT EXISTING OPENEND DIALOGS AND SET TO FRONT
  exit;
end;

if Fserver.Visible=false then
  myshowform(Fserver,false);

//FIX
Fserver.tntrichedit1.SelStart:=length(Fserver.tntrichedit1.text);

SetForegroundWindow(Fserver.Handle); //FIX FOCUS

if Fserver.WindowState=wsminimized then
  Fserver.WindowState:=wsNormal;

end;

procedure Tfmain.checkusername;
begin
username:=trim(username);
if (username='') OR (Length(username)>25) then
  username:=GetUserFromWindows;
end;

procedure Tfmain.showmyquerys;
var
x:integer;
columname:ansistring;
direction:string;
begin

Datamodule1.DBMyquerys.DatabaseFileName:=UTF8Encode(defrequestsfilename);

try
  Datamodule1.Qmyquerysview.close;
  Datamodule1.Qmyquerysview.SQL.Clear;
  Datamodule1.Qmyquerysview.SQL.Add('SELECT * FROM Querys');

  columname:='ID';
  direction:='ASC';

  //SORTING METHOD

  for x:=0 to Fserver.virtualstringtree2.header.Columns.Count-1 do
    if Fserver.virtualstringtree2.header.Columns[x].Tag<>0 then begin
      case x of
        0:columname:='Filename';
        1:columname:='Setname';
        2:columname:='Profilename';
        3:columname:='Priority';
        4:columname:='Size_';
        5:columname:='CRC';
        6:columname:='MD5';
        7:columname:='SHA1';
        8:columname:='Added';
        9:columname:='Completed';
        10:columname:='Downpath';
      end;
      if Fserver.virtualstringtree2.header.Columns[x].Tag<>2 then begin
        direction:='ASC';
        if x=3 then
          direction:=direction+',Added ASC';//0.044
      end
      else begin
        direction:='DESC';
        if x=3 then
          direction:=direction+',Added DESC';//0.044
      end;
    end;

  Datamodule1.Qmyquerysview.SQL.Add('ORDER BY '+columname+' '+direction);

  Datamodule1.Qmyquerysview.Open;

  Datamodule1.Tmyquerys.Open;

  if (Datamodule1.Tmyquerys.FieldCount=14) AND (Datamodule1.DBMyquerys.TableExists('Querys')=true) then begin//SECURITY CHECK

    Fserver.VirtualStringTree2.rootnodecount:=0;//FIX INDETERMINATED
    Fserver.VirtualStringTree2.rootnodecount:=Datamodule1.Qmyquerysview.RecordCount;

    Fserver.Panel28.Caption:=fillwithzeroes(inttostr(Datamodule1.Qmyquerysview.RecordCount),4);

  end
  else begin
    Fserver.VirtualStringTree2.rootnodecount:=0;
    Fserver.Panel28.Caption:='0000';
    Datamodule1.DBMyquerys.Close;
  end;

except

end;

Fserver.VirtualStringTree2.Repaint;
end;

procedure Tfmain.missingtorequest(from:integer);
var
loaded,pass,isoff:boolean;
x,y,fmode,max:Integer;
profilename,setname:widestring;
counter,setnum:Largeint;
n:PVirtualNode;
begin
stop:=false;
sterrors.Clear;
counter:=0;
loaded:=false;
Datamodule1.DBMyquerys.DatabaseFileName:=UTF8Encode(defrequestsfilename);
showprocessingwindow(true,false);

Fprocessing.Panel3.Caption:=traduction(61)+' : '+traduction(525);

try

  if Datamodule1.DBMyquerys.connected=false then begin
    if FileExists2(defrequestsfilename)=true then
      try
        Datamodule1.DBMyquerys.Open;
        //AND CHECK
        if Datamodule1.DBMyquerys.TableExists('Querys')=true then begin

          Datamodule1.Tmyquerys.Open;

          if Datamodule1.Tmyquerys.FieldCount=14 then //SECURITY CHECK
            loaded:=true
          else
            Datamodule1.DBMyquerys.Close;

        end
        else
          Datamodule1.DBMyquerys.Close;
      except
        Datamodule1.DBMyquerys.Close;
      end;

    if loaded=false then begin

      Datamodule1.DBMyquerys.Close;
      Datamodule1.DBMyquerys.PageCountInExtent:=defpagecountinextent;
      Datamodule1.DBMyquerys.PageSize:=defpagesize;
      DataModule1.DBMyquerys.MaxConnections:=defmaxconnections;
      DataModule1.DBMyquerys.SilentMode:=true;
      Datamodule1.DBMyquerys.CreateDatabase;

      Datamodule1.Tmyquerys.close;
      Datamodule1.Tmyquerys.FieldDefs.Clear;
      Datamodule1.Tmyquerys.FieldDefs.Add('ID',ftAutoInc,0,False);
      Datamodule1.Tmyquerys.FieldDefs.Add('Filename',ftwidestring,255,true);
      Datamodule1.Tmyquerys.FieldDefs.Add('Setname',ftwidestring,255,true);
      Datamodule1.Tmyquerys.FieldDefs.Add('Profilename',ftwidestring,255,true);
      Datamodule1.Tmyquerys.FieldDefs.Add('Size_',ftCurrency,0,true);
      Datamodule1.Tmyquerys.FieldDefs.Add('CRC',ftString,8,false);
      Datamodule1.Tmyquerys.FieldDefs.Add('MD5',ftString,32,false);
      Datamodule1.Tmyquerys.FieldDefs.Add('SHA1',ftString,40,false);
      Datamodule1.Tmyquerys.FieldDefs.Add('Type',ftInteger,0,true);
      Datamodule1.Tmyquerys.FieldDefs.Add('Status',ftstring,1,false);
      Datamodule1.Tmyquerys.FieldDefs.Add('Downpath',ftwidestring,255,false);
      Datamodule1.Tmyquerys.FieldDefs.Add('Priority',ftstring,1,false);
      Datamodule1.Tmyquerys.FieldDefs.Add('Added',ftDateTime,0,true);
      Datamodule1.Tmyquerys.FieldDefs.Add('Completed',ftDateTime,0,false);

      Datamodule1.Tmyquerys.IndexDefs.Clear;
      Datamodule1.Tmyquerys.IndexDefs.Add('I1', 'ID', [ixPrimary]); //Speedup locate
      Datamodule1.Tmyquerys.IndexDefs.Add('I2', 'Filename;Setname;Profilename', [ixUnique,ixCaseInsensitive]);
      Datamodule1.Tmyquerys.IndexDefs.Add('I3', 'Type;Profilename;Size_;CRC;MD5;SHA1;Status', []);

      Datamodule1.Tmyquerys.CreateTable;
      Datamodule1.Tmyquerys.Open;

      loaded:=true;
    end
    else
      Datamodule1.Tmyquerys.Open;

  end
  else
    loaded:=true;


  Datamodule1.Tmyquerys.Open;
except
end;

if loaded=true then
  Datamodule1.DBMyquerys.StartTransaction
else
  Datamodule1.DBMyquerys.Close;


//FROM=0 FROM PROFILES LIST ALL
//FROM=3 FROM SCANNER TAB ALL
//FROM=1 FROM SELECTED SCANNER LIST

//DB IS CREATED OR CHECKED
if loaded=true then
  if (from=0) OR (from=3) then begin //SEND TO REQUESTS BY PROFILES LIST SELECTION OR SCANNER TAB

    if from=0 then //Profiles list
      max:=VirtualStringTree2.RootNodeCount-1
    else
      max:=0; //SCANNER TAB

    n:=VirtualStringTree2.GetFirst;

    for x:=0 to max do begin

      if stop=true then
        break;

      Application.ProcessMessages;

      pass:=false;

      if from=0 then begin
        if VirtualStringTree2.Selected[n]=true then begin
          pass:=true;
          Datamodule1.Tprofilesview.Locate('CONT',x+1,[]);//GET THE PROFILE
          Datamodule1.Tprofiles.Locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
        end;
      end
      else begin
        pass:=true;
        Datamodule1.Tprofiles.Locate('ID',getcurrentprofileid,[]);
      end;

      if pass=true then begin

        //IGNORE IF SET IS COMPLETE
        if Datamodule1.Tprofiles.fields[5].asstring<>Datamodule1.Tprofiles.fields[15].asstring then begin

          isoff:=false;
          profilename:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Name'));
          fmode:=Datamodule1.Tprofiles.fieldbyname('Filemode').AsInteger;

          if Datamodule1.Tprofiles.FieldByName('Original').AsString='O' then
            isoff:=true;

          Fprocessing.Panel2.Caption:=changein(profilename,'&','&&');

          case fmode of
            0:begin
              allowmerge:=true;//Same file
              allowdupe:=false;
              end;
            1:begin
              allowmerge:=false;//Normal
              allowdupe:=true;
              end;
            2:begin
              allowmerge:=true;//Big size
              allowdupe:=true;
              end;
          end;

          Datamodule1.Tscansets.Close;
          Datamodule1.Tscanroms.Close;

          try

            Datamodule1.Tscansets.TableName:='Y'+fillwithzeroes(Datamodule1.Tprofiles.fieldbyname('ID').asstring,4);
            Datamodule1.Tscanroms.TableName:='Z'+fillwithzeroes(Datamodule1.Tprofiles.fieldbyname('ID').asstring,4);

            Datamodule1.Tscansets.open;
            Datamodule1.Tscanroms.open;

            Datamodule1.Tscanroms.Locate('Have',false,[]);//SPEED HACK

            While not Datamodule1.Tscanroms.Eof do begin

              if stop=true then
                break;

              Application.ProcessMessages;

              if Datamodule1.Tscanroms.FieldByName('Have').AsBoolean=false then begin

                pass:=true;

                if Datamodule1.Tscanroms.fieldbyname('Merge').asboolean=true then
                  if allowmerge=false then
                    pass:=false;

                if allowdupe=false then //CORRECT INDEXED?
                  if Datamodule1.Tscanroms.fieldbyname('Dupe').AsBoolean=true then
                    pass:=false;

                if pass=true then
                  try //Filename;Setname;Profilename;Size_;CRC;MD5;SHA1

                    if fmode=0 then
                      Datamodule1.Tscansets.Locate('ID',Datamodule1.Tscanroms.fieldbyname('Setnamemaster').asinteger,[])
                    else
                      Datamodule1.Tscansets.Locate('ID',Datamodule1.Tscanroms.fieldbyname('Setname').asinteger,[]);

                    Datamodule1.Tmyquerys.Append;

                    setwiderecord(Datamodule1.Tmyquerys.FieldByName('Profilename'),profilename);
                    setwiderecord(Datamodule1.Tmyquerys.FieldByName('Setname'),getwiderecord(Datamodule1.Tscansets.fieldbyname('Gamename')));
                    setwiderecord(Datamodule1.Tmyquerys.FieldByName('Filename'),getwiderecord(Datamodule1.Tscanroms.fieldbyname('Romname')));
                    Datamodule1.Tmyquerys.FieldByName('Size_').ascurrency:=Datamodule1.Tscanroms.fieldbyname('Space').ascurrency;
                    Datamodule1.Tmyquerys.FieldByName('CRC').AsString:=Datamodule1.Tscanroms.fieldbyname('CRC').asstring;

                    if isoff=false then begin
                      Datamodule1.Tmyquerys.FieldByName('MD5').AsString:=Datamodule1.Tscanroms.fieldbyname('MD5').asstring;
                      Datamodule1.Tmyquerys.FieldByName('SHA1').AsString:=Datamodule1.Tscanroms.fieldbyname('SHA1').asstring;
                    end;

                    Datamodule1.Tmyquerys.FieldByName('Type').asinteger:=Datamodule1.Tscanroms.fieldbyname('Type').asinteger;
                    Datamodule1.Tmyquerys.FieldByName('Added').AsDateTime:=now;
                    Datamodule1.Tmyquerys.FieldByName('Priority').AsString:='1';//NORMAL

                    Datamodule1.Tmyquerys.post;

                    counter:=counter+1;
                  except
                    Datamodule1.Tmyquerys.Cancel;
                    adderror(traduction(524)+' : '+profilename+' > '+Datamodule1.Tscanroms.fieldbyname('Romname').asstring);
                  end;
              end;//HAVE CHECK

              Datamodule1.Tscanroms.next;
            end;//END LOOP ROMS TABLE

          except
          //ERROR READING PROFILE
          end;

          Datamodule1.Tscansets.Close;
          Datamodule1.Tscanroms.Close;

        end;//END IGNORE COMPLETED

      end;//END SELECTED ITEM LISTVIEW

      if from=0 then
        n:=VirtualStringTree2.GetNext(n);
    end; //LISTVIEW LOOP
  end
  else
  if (from=1) OR (from=2) then begin //SEND TO REQUESTS BY LOADED PROFILE SCANNER MASTER LIST

    Datamodule1.Tprofiles.Locate('ID',getcurrentprofileid,[]);
    isoff:=false;
    profilename:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Name'));

    if Datamodule1.Tprofiles.FieldByName('Original').AsString='O' then
      isoff:=true;

    Fprocessing.Panel2.Caption:=changein(profilename,'&','&&');

    if from=1 then begin

      n:=masterlv.GetFirst;

      for x:=0 to masterlv.RootNodeCount-1 do begin

        if stop=true then
          break;

        if masterlv.Selected[n]=true then begin

          mastertable.Locate('CONT',x+1,[]);

          setnum:=mastertable.fieldbyname('ID').asinteger;
          setname:=getwiderecord(mastertable.fieldbyname('Gamename'));

          y:=0;

          while detailtable.Locate('CONT;Setname',VarArrayOf([y+1, setnum]),[])=true do begin

            if stop=true then
              break;

            if detailtable.FieldByName('Have').AsBoolean=false then begin

              try
                Datamodule1.Tmyquerys.Append;

                setwiderecord(Datamodule1.Tmyquerys.FieldByName('Profilename'),profilename);
                setwiderecord(Datamodule1.Tmyquerys.FieldByName('Setname'),setname);
                setwiderecord(Datamodule1.Tmyquerys.FieldByName('Filename'),getwiderecord(Detailtable.fieldbyname('Romname')));
                Datamodule1.Tmyquerys.FieldByName('Size_').ascurrency:=Detailtable.fieldbyname('Space').ascurrency;
                Datamodule1.Tmyquerys.FieldByName('CRC').AsString:=Detailtable.fieldbyname('CRC').asstring;
                if isoff=false then begin
                  Datamodule1.Tmyquerys.FieldByName('MD5').AsString:=Detailtable.fieldbyname('MD5').asstring;
                  Datamodule1.Tmyquerys.FieldByName('SHA1').AsString:=Detailtable.fieldbyname('SHA1').asstring;
                end;
                Datamodule1.Tmyquerys.FieldByName('Type').asinteger:=Detailtable.fieldbyname('Type').asinteger;
                Datamodule1.Tmyquerys.FieldByName('Added').AsDateTime:=now;
                Datamodule1.Tmyquerys.FieldByName('Priority').AsString:='1';//NORMAL

                Datamodule1.Tmyquerys.post;

                counter:=counter+1;
              except
                Datamodule1.Tmyquerys.Cancel;
                adderror(traduction(524)+' : '+profilename+' > '+getwiderecord(Detailtable.fieldbyname('Romname')));
              end;

            end;

            y:=y+1;
            Application.ProcessMessages;
          end;

        end;

        n:=masterlv.GetNext(n);

        Application.ProcessMessages;
      end;//FOR
    end//FROM 1
    else
    if from=2 then begin

      mastertable.locate('ID',detailedit.tag,[]);
      setname:=getwiderecord(mastertable.fieldbyname('Gamename'));

      n:=detaillv.GetFirst;
      for x:=0 to detaillv.RootNodeCount-1 do begin

        if stop=true then
          break;

        If detaillv.Selected[n]=true then begin

          detailtable.Locate('CONT;Setname',VarArrayOf([x+1, detailedit.tag]),[]);

          if detailtable.FieldByName('Have').asboolean=false then begin

            try
              Datamodule1.Tmyquerys.Append;

              setwiderecord(Datamodule1.Tmyquerys.FieldByName('Profilename'),profilename);
              setwiderecord(Datamodule1.Tmyquerys.FieldByName('Setname'),setname);
              setwiderecord(Datamodule1.Tmyquerys.FieldByName('Filename'),getwiderecord(Detailtable.fieldbyname('Romname')));
              Datamodule1.Tmyquerys.FieldByName('Size_').ascurrency:=Detailtable.fieldbyname('Space').ascurrency;
              Datamodule1.Tmyquerys.FieldByName('CRC').AsString:=Detailtable.fieldbyname('CRC').asstring;

              if isoff=false then begin
                Datamodule1.Tmyquerys.FieldByName('MD5').AsString:=Detailtable.fieldbyname('MD5').asstring;
                Datamodule1.Tmyquerys.FieldByName('SHA1').AsString:=Detailtable.fieldbyname('SHA1').asstring;
              end;

              Datamodule1.Tmyquerys.FieldByName('Type').asinteger:=Detailtable.fieldbyname('Type').asinteger;
              Datamodule1.Tmyquerys.FieldByName('Added').AsDateTime:=now;
              Datamodule1.Tmyquerys.FieldByName('Priority').AsString:='1';//NORMAL
              
              Datamodule1.Tmyquerys.post;

              counter:=counter+1;
            except
              Datamodule1.Tmyquerys.Cancel;
              adderror(traduction(524)+' : '+profilename+' > '+getwiderecord(Detailtable.fieldbyname('Romname')));
            end;
          end; //HAVE

        end;//LV SELECTED

        n:=detaillv.GetNext(n);
        Application.ProcessMessages;

      end;//X LOOP
    end;//FROM 2
  end;//FROM 1 2

if loaded=true then
  Datamodule1.DBMyquerys.Commit(true);

if counter>0 then begin
  showmyquerys;
  Datamodule1.Qmyquerys.Tag:=1;//FORZE REFRESH
end;

hideprocessingwindow;

pass:=false;
if sterrors.Count=0 then
  pass:=true;

sterrors.Add(inttostr(counter)+' '+traduction(523));

if pass=true then
  mymessageinfo(sterrors.Text)
else
  mymessagewarning(sterrors.Text);

sterrors.clear;
end;

procedure Tfmain.shareselection(share:boolean);
var
x:integer;
oposite:boolean;
done:boolean;
contshared:integer;
shareint,z:integer;
n:PVirtualNode;
begin
contshared:=0;
done:=false;
oposite:=true;
if share=true then
  oposite:=false;

n:=VirtualStringTree2.GetFirst;
for x:=0 to VirtualStringTree2.RootNodeCount-1 do begin

  Datamodule1.Tprofilesview.Locate('CONT',x+1,[]);

  if VirtualStringTree2.Selected[n]=true then begin

    if Datamodule1.Tprofilesview.FieldByName('Shared').asboolean=oposite then begin

      Datamodule1.Tprofilesview.Edit;
      Datamodule1.Tprofilesview.fieldbyname('Shared').AsBoolean:=share;
      Datamodule1.Tprofilesview.Post;

      Datamodule1.Tprofiles.Locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
      Datamodule1.Tprofiles.Edit;
      Datamodule1.Tprofiles.FieldByName('Shared').asboolean:=share;

      Datamodule1.Tprofiles.Post;

      shareint:=0;
      if Datamodule1.Tprofiles.fieldbyname('shared').asboolean=true then
        shareint:=4;

      //Check for loaded profile tab
      try
        if Datamodule1.Tprofiles.fieldbyname('Haveroms').asstring='' then
          z:=3
        else
        if Datamodule1.Tprofiles.fieldbyname('Haveroms').asstring='0' then
          z:=2
        else
        if Datamodule1.Tprofiles.fieldbyname('Haveroms').asstring=Datamodule1.Tprofiles.fieldbyname('Totalroms').asstring then
          z:=0
        else
          z:=1;

        (FindComponent('CLONE_TabSheet7_'+inttostr(Datamodule1.Tprofiles.fieldbyname('ID').asinteger)) as TTnttabsheet).ImageIndex:=z+shareint;
      except
      end;

      done:=true;

    end;

  end;

  if Datamodule1.Tprofilesview.FieldByName('Shared').asboolean=true then
    contshared:=contshared+1;

  n:=VirtualStringTree2.GetNext(n);
end;

if done=true then begin
  Datamodule1.Qaux.close;
  Datamodule1.Qaux.SQL.Clear;
  Datamodule1.Qaux.SQL.Text:='SELECT * FROM Profiles WHERE Shared=True';
  Datamodule1.Qaux.Open;
  VirtualStringTree2.Repaint;
  panel66.Caption:=traduction(512)+' '+inttostr(contshared)+' '+'/'+' '+inttostr(Datamodule1.Qaux.recordcount);
  Datamodule1.Qaux.close;
end;

end;

//-GENERAL--------------------------------------------------

function Tfmain.getnodetextundermouse(vt:Tvirtualstringtree):widestring;
var
P: TPoint;
hitinfo: THitInfo;
begin
try
  P := vt.ScreenToClient(Mouse.CursorPos);
  vt.GetHitTestInfoAt(p.x, p.y, true, hitinfo);
  result:=vt.Text[hitinfo.HitNode,hitinfo.HitColumn];
except
end;
end;

procedure Tfmain.URL_OnDownloadProgress;
begin
downloadprogresstotal:=Progressmax;
downloadprogressposition:=progress;
end;

procedure TFmain.positiondialogstart();
begin
exit;//REMOVED BY AGUS PROBLEMS
//0.029 IF MONITOR <>0 POSSITION IT
Timerdialog.Interval:=1;

if GetFormsCount=2 then
  Fmain.Enabled:=false; //SECURITY

if isserverdialog=true then begin
  SetWindowPos(Fserver.handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE);
  Fserver.Enabled:=false;
end
else begin
  //SetWindowPos(Fmain.handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE)
end;


try //0.031
    dialogcounter:=0;
    Timerdialog.Enabled:=true;
except
end;

end;

procedure Tfmain.applyfilterlaststep(apply:boolean);
var
x,c,total:integer;
begin
c:=1;
screen.Cursor:=crHourGlass;
masterlv.BeginUpdate;
masterlv.Repaint;
detaillv.BeginUpdate;
detaillv.Repaint;

mastertable.Filtered:=false;

mastertable.FilterOptions:=[];
mastertable.Filter:='';

mastertable.Open;
total:=mastertable.RecordCount; //GET ALL RECORDS COUNT WITHOUT FILTERS

try
  mastertable.Filtered:=apply;
except
  mastertable.Filtered:=false;
end;

mastertable.First;


//(Datamodule1.FindComponent(mastertable.DatabaseName) as TABSDatabase).StartTransaction;

//SET CORRECT COUNT 0.030
if mastertable.Filtered=true then begin
  for x:=1 to total do
    if mastertable.Locate('CONT',x,[])=true then begin

      mastertable.Edit;
      mastertable.fields[0].asinteger:=c;
      mastertable.Post;

      c:=c+1;
    end;
end
else //RECOVER CORRECT CONT USING OCONT FIELD
while mastertable.Eof=false do begin
  mastertable.edit;
  mastertable.fields[0].AsInteger:=mastertable.Fields[14].asinteger;
  mastertable.Post;

  mastertable.Next;
end;

//(Datamodule1.FindComponent(mastertable.DatabaseName) as TABSDatabase).Commit(false);

detailedit.Tag:=-1;
detaillv.ClearSelection;
detaillv.RootNodeCount:=0;
masterlv.ClearSelection;
masterlv.RootNodeCount:=mastertable.RecordCount;

Fmain.updatemasterpanel;

masterlv.Endupdate;
masterlv.Repaint;
detaillv.EndUpdate;

masteredit.Text:='';

detailedit.Text:='';

posintoindexbynode(masterlv.getfirst,masterlv);

Fmain.showprofilesmasterselected;
Fmain.showprofilesdetailselected;

//Image existing check
if masterlv.RootNodeCount=0 then begin
  detailtotal.Caption:=traduction(24)+' '+fillwithzeroes(inttostr(detaillv.rootnodecount),4)+' '+'/'+' '+fillwithzeroes(mastertable.fieldbyname('total_').asstring,4);
  detailhave.caption:='0000';
  detailmiss.caption:='0000';
  Fmain.loadimages;
end;

Fmain.checkfilterglyph;
screen.Cursor:=crdefault;
end;

function Tfmain.getpanelfilter():TTntpanel;
begin
result:=(Fmain.FindComponent('CLONE_Panel31_'+Fmain.getcurrentprofileid) as TTntpanel);
end;

procedure TFmain.setgridlines(lv:TVirtualStringTree;done:boolean);
begin
if done=true then
  (lv as TVirtualStringTree).TreeOptions.PaintOptions:=(lv as TVirtualStringTree).TreeOptions.PaintOptions+[toShowHorzGridLines]+[toShowVertGridLines]
else
  (lv as TVirtualStringTree).TreeOptions.PaintOptions:=(lv as TVirtualStringTree).TreeOptions.PaintOptions-[toShowHorzGridLines]-[toShowVertGridLines]
end;

procedure TFmain.flash;
var
FWinfo: TFlashWInfo;
begin
if CoolTrayIcon1.Tag<>0 then
  exit;

try

  FWinfo.cbSize    := SizeOf(FWInfo);
  FWinfo.hwnd      := application.Handle;
                                                                                             //FIX???
  if ((isaformactive('Fserver')=true)) OR ((GetForegroundWindow<>screen.ActiveForm.Handle) AND (Fmain.WindowState<>wsMinimized) AND (screen.ActiveForm.showing=true)) then begin
    FWinfo.dwflags   := FLASHW_ALL;
    FWinfo.ucount    := 10;
    if flashing=true then //NO REPEAT FIX
      exit;
    flashing:=true;
  end
  else begin
    FWinfo.dwflags   := FLASHW_STOP;
    FWinfo.ucount    := 0;
    flashing:=false;
  end;

  FWinfo.dwtimeout := 0;
  FlashWindowEx(FWinfo);
except
end;

end;

procedure Tfmain.flashstop;
var
FWinfo: TFlashWInfo;
begin

try
if flashing=true then
  if (isaformactive('Fserver')=false) then//0.044
  if (GetForegroundWindow=screen.ActiveForm.Handle) OR (Fmain.WindowState=wsminimized) then begin //UNFLASH
    FWinfo.cbSize    := SizeOf(FWInfo); ;
    FWinfo.hwnd      := Application.Handle;
    FWinfo.dwflags   := FLASHW_STOP;
    FWinfo.ucount    := 0;
    flashing:=false;
    FWinfo.dwtimeout := 0;
    FlashWindowEx(FWinfo);
  end;
except
end;
end;

function Tfmain.isdbcorrectversion(Dbcheck:Tabsdatabase):boolean;
var
res:boolean;
begin
res:=false;

if (Dbcheck.TableExists('Profiles')=true) AND (Dbcheck.TableExists('Tree')=true) then
  if (Dbcheck.PageSize=defpagesize) AND (Dbcheck.PageCountInExtent=defpagecountinextent) AND (Dbcheck.MaxConnections=defmaxconnections) then
   res:=true
  else begin

    mymessageinfo(traduction(505));

    try
      Dbcheck.close;

      showprocessingwindow(false,false);
      Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(506);
      Fprocessing.panel2.Caption:=changein(WideExtractfilename(UTF8Decode(Dbcheck.DatabaseFileName)),'&','&&');

      DataModule1.Qaux.Close;
      DataModule1.Qaux.SQL.Clear;
      DataModule1.Qaux.SQL.Add('CHANGEDATABASESETTINGS');
      BMDThread1.Start();

      waitforfinishthread;

      Dbcheck.open;
      hideprocessingwindow;

      if (Dbcheck.PageSize=defpagesize) AND (Dbcheck.PageCountInExtent=defpagecountinextent) then
        res:=true;
        
    except
    end;

  end;

Result:=res;
end;

procedure Tfmain.taskbaractive(b:boolean);
begin
try
  if b=true then begin
    if preventsleep=true then
      SystemCritical.IsCritical:=true; //Prevent sleep poweroff

    fspTaskbarMgr1.ProgressState:=fstpsIndeterminate;
  end
  else begin
    SystemCritical.IsCritical:=false;
    fspTaskbarMgr1.ProgressState:=fstpsNoProgress;
  end;
except
end;

end;

procedure Tfmain.showballoon(title:widestring;msg:widestring;secs:integer;icon:Tballoonhinticon);
begin
cooltrayicon1.ShowBalloonHint(gettoken(title,' - ',1),msg,icon,secs);
sleep(200);
end;

procedure LockControl(c: TWinControl; bLock: Boolean);
begin
  if (c = nil) or (c.Handle = 0) then Exit;
  if bLock then
    SendMessage(c.Handle, WM_SETREDRAW, 0, 0)
  else
  begin
    SendMessage(c.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(c.Handle, nil, 0,
      RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
  end;
end;

procedure Tfmain.addclosebuttontab(Fromform:Ttntform;pagecontrol:Tpagecontrol;x,y,correction:integer);
var
hi: TTcHitTestInfo;
tabindex,tabnew: Integer;
c:integeR;
lPoint :Tpoint;
begin
hi.pt.x := X;
hi.pt.y := Y;
hi.flags := 0;
tabindex := pagecontrol.Perform( TCM_HITTEST, 0, longint(@hi));
                                       //-1 CORRECTION
if tabindex<>pagecontrol.ActivePageIndex-correction then begin
  statictext1.visible:=false;
  exit;
end;

tabnew:=tabindex;
c:=hi.pt.x;

while tabnew=tabindex do begin
  c:=c+1;
  hi.pt.X:=c;
  tabnew := pagecontrol.Perform( TCM_HITTEST, 0, longint(@hi));
end;

//statictext1.Parent:=Fmain;
statictext1.Parent:=fromform;

lpoint.X:=0;
lpoint.Y:=0;
lpoint:=pagecontrol.ClientToScreen(lpoint);

//FIX WHEN CROSS IS OUT 0.043 UNKNOW REASON
hi.pt.X:=(c)+lpoint.x-statictext1.Width-fromform.left-1;
tabnew :=pagecontrol.Perform( TCM_HITTEST, 0, longint(@hi));
if tabnew<>tabindex then begin
  //caption:=datetimetostr(now)+' CORRECTION';
  lpoint.X:=lpoint.X-4;//6
  lpoint.Y:=lpoint.y-4;//6
end;

//0.044 WORKS WITH SERVER WINDOW
statictext1.left:=(c)+lpoint.x-statictext1.Width-fromform.left-4;//-4
statictext1.top:=lpoint.y-fromform.top-GetSystemMetrics(SM_CYCAPTION)-2; //-2
//statictext1.left:=(c)+lpoint.x-statictext1.Width-pagecontrol.parent.left-4;//-4
//statictext1.top:=lpoint.y-pagecontrol.parent.top-GetSystemMetrics(SM_CYCAPTION)-2; //-2

StaticText1.Visible:=true;
statictext1.BorderStyle:=sbsSingle;
end;

procedure Tfmain.addtoactiveform(f:Tform;add:boolean);
var
ico:TBalloonHintIcon;
x:integer;
begin

if Cooltrayicon1.Tag=2 then
  exit;

ico:=bitInfo;//INFO

//READDED 0.038
EnableWindow(Application.Handle,true);//ENABLE MODAL MINIMIZATION

if add=true then begin

  if activeformlist.IndexOf(F.name)=-1 then
    activeformlist.Add(F.name);

  if Stayontop1.Checked=true then begin //FIX MODAL
  
    SetWindowPos(
    Handle,
    HWND_NOTOPMOST,
    0,
    0,
    0,
    0,
    SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

    Stayontop1.Tag:=1;
  end;

  EnableWindow(Flog.Handle,true);//ENABLE ALWAYS FLOG FORM
  EnableWindow(Fserver.Handle,true);//ENABLE ALWAYS FSERVER FORM

  if F.Enabled=true then
    EnableWindow(F.handle,true);//FIX 0.019


  //HIDDEN CHECK
  if (fmain.CoolTrayIcon1.Tag=1) then begin

    F.AlphaBlendValue:=0;
    F.AlphaBlend:=true;

    cooltrayicon1.hidetaskbaricon;

    ShowWindow(F.Handle, SW_HIDE);
    //SetForegroundWindow(Fserver.Handle); //FIX FOCUS

    if F.Name='Fmessage' then begin
      case Fmessage.ImageList1.Tag of
        0:ico:=bitWarning;//WARNING
        1:ico:=bitInfo;//QUESTION Bitcustom
        2:ico:=bitError;//ERROR
        3:ico:=bitInfo;//INFO
      end;
      showballoon(Fmessage.caption,traduction(500),0,ico);
    end
    else
    if F.name='Fnewdat' then
      showballoon(Fnewdat.Caption,Fnewdat.edit2.text,0,bitInfo)
    else
    if F.name='Fupdatedat' then
      showballoon(Fupdatedat.Caption,Fupdatedat.edit2.text,0,bitInfo);  

  end
  else begin
    F.AlphaBlend:=false;

    cooltrayicon1.showtaskbaricon;
  end;

  //0.028 FIX LOSS THEME WHEN RECREATE WINDOW FOR VISTA EFFECT AT MYSHOWFORM
  for x:=0 to F.ComponentCount-1 do
    if F.components[x] is TTntTreeView then
      setwinvista7theme((F.components[x] as TTntTreeView).handle)
    else
    if F.Components[x] is TProgressBar then
      SendMessage((F.Components[x] as TProgressBar).Handle, PBM_SETBARCOLOR, 0, clgreen); //FIX
end
else begin

  try
    activeformlist.Delete(activeformlist.IndexOf(f.Name));
  except
  end;

end;

flash;
end;

function Tfmain.downloadfile2(urldown:ansistring;dest:widestring;progress:boolean):boolean;
var
res:boolean;
destination:ansistring;
begin

try
  DeleteIECache(urldown);
except
end;

if isunicodefilename(dest) then
  destination:=getvaliddestination(tempdirectoryresources+'rdown')
else
  destination:=dest;

with TDownloadURL.Create(self) do
  try

     URL:=urldown;
     FileName := destination;

     if progress=true then
      OnDownloadProgress := URL_OnDownloadProgress;
     //else //REMOVED BY BUF 0.037
     // OnDownloadProgress := URL_OnDownloadrefresh;

     ExecuteTarget(nil) ;

     res:=true;

     if isunicodefilename(dest) then begin
      res:=movefile2(destination,dest);
      //if res=false then
      //  caption:=datetimetostr(now);

      deletefile2(destination);
     end;

  finally
    Free;
  end;

Result:=res;
end;

procedure Tfmain.DeleteIECache(url : ansistring);
var
   lpEntryInfo: PInternetCacheEntryInfo;
   hCacheDir: LongWord;
   dwEntrySize: LongWord;
begin
url:=AnsiUpperCase(url);

dwEntrySize := 0;
FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize) ;
GetMem(lpEntryInfo, dwEntrySize) ;

if dwEntrySize > 0 then
  lpEntryInfo^.dwStructSize := dwEntrySize;

hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize) ;

if hCacheDir <> 0 then begin
  repeat
    if url=ansiuppercase(lpEntryInfo^.lpszSourceUrlName) then begin
      DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName) ;
      //showmessage('found');
    end;

    FreeMem(lpEntryInfo, dwEntrySize) ;
    dwEntrySize := 0;
    FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize) ;
    GetMem(lpEntryInfo, dwEntrySize) ;
    if dwEntrySize > 0 then
      lpEntryInfo^.dwStructSize := dwEntrySize;

  until not FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize) ;
end;

FreeMem(lpEntryInfo, dwEntrySize) ;
FindCloseUrlCache(hCacheDir) ;
end;

procedure Tfmain.ModalBegin(Sender: TObject); //IF MODAL FORM APPEARS THEN APPLICATION RESTORES
begin

try
  if cooltrayicon1.Tag=0 then
    ShowWindow(application.Handle, SW_RESTORE) ;
except
end;

end;

procedure Tfmain.checkeditpopup;
begin
cut2.Enabled:=false;
copy2.Enabled:=false;
paste2.Enabled:=false;
selectall6.Enabled:=false;

Focussededit:=nil;
Focussedrich:=nil;
Focussedcombo:=nil;
Focussedtntrich:=nil;

try
  if screen.ActiveForm.FindComponent(Screen.ActiveControl.Name) is Ttntcombobox then
    Focussedcombo:=screen.ActiveForm.FindComponent(Screen.ActiveControl.Name) as Ttntcombobox
  else
  if screen.ActiveForm.FindComponent(Screen.ActiveControl.Name) is Ttntedit then
    Focussededit:=screen.ActiveForm.FindComponent(Screen.ActiveControl.Name) as Ttntedit
  else
  if screen.ActiveForm.FindComponent(Screen.ActiveControl.Name) is TRxRichEdit then
    Focussedrich:=screen.ActiveForm.FindComponent(Screen.ActiveControl.Name) as TRxRichEdit
  else
  if screen.ActiveForm.FindComponent(Screen.ActiveControl.Name) is TTntrichedit then
    Focussedtntrich:=screen.ActiveForm.FindComponent(Screen.ActiveControl.Name) as TTntrichedit;

except
end;

if Focussededit<>nil then begin

  if Focussededit.SelLength<>0 then begin

    if (Focussededit.ReadOnly=false) then
      cut2.Enabled:=true;

    copy2.Enabled:=true;
  end;

  if (Length(Focussededit.Text)<>0) AND (Focussededit.SelLength<>length(Focussededit.Text)) then
    selectall6.Enabled:=true;

  if (Clipboard.AsText<>'') AND (Focussededit.ReadOnly=false) then
    paste2.Enabled:=true;

end
else
if Focussedcombo<>nil then begin
  if Focussedcombo.SelLength<>0 then begin

    cut2.Enabled:=true;

    copy2.Enabled:=true;
  end;

  if Length(Focussedcombo.Text)<>0 then
    selectall6.Enabled:=true;

  if (Clipboard.AsText<>'') then
    paste2.Enabled:=true;

end
else
if Focussedrich<>nil then begin

  if Focussedrich.SelLength<>0 then begin

    if (Focussedrich.ReadOnly=false) then
      cut2.Enabled:=true;

    copy2.Enabled:=true;
  end;

  if Length(Focussedrich.Text)<>0 then
    selectall6.Enabled:=true;

  if (Clipboard.AsText<>'') AND (Focussedrich.ReadOnly=false) then
    paste2.Enabled:=true;

end
else
if Focussedtntrich<>nil then begin

  if Focussedtntrich.SelLength<>0 then begin

    if (Focussedtntrich.ReadOnly=false) then
      cut2.Enabled:=true;

    copy2.Enabled:=true;
  end;

  if Length(Focussedtntrich.Text)<>0 then
    selectall6.Enabled:=true;

  if (Clipboard.AsText<>'') AND (Focussedtntrich.ReadOnly=false) then
    paste2.Enabled:=true;

end;

end;

function Tfmain.gettrimmedtext(text:widestring;textwidth:integer):widestring;
var
trimmed:boolean;
begin
trimmed:=false;
Flog.label2.Caption:=text;

while Flog.label2.Width>textwidth do begin
  text:=copy(text,1,length(text)-1);
  Flog.label2.Caption:=text;
  trimmed:=true;
end;


{if trimmed=false then //Try to fill
  while Flog.label2.Width<textwidth do begin
    text:=text+' ';
    Flog.label2.Caption:=text;
  end;  }

if trimmed=true then
  text:=text+'...  '; //0.043 +2spaces

Result:=text;

end;

procedure Tfmain.sortcolumn(lv:TVirtualStringTree;id:integer);
var
x:integer;
begin
if id=-1 then
  exit;

if lv.Header.Columns[id].tag=0 then
  lv.Header.Columns[id].tag:=1
else
if lv.Header.Columns[id].tag=1 then
  lv.Header.Columns[id].tag:=2
else
  lv.Header.Columns[id].tag:=1;

for x:=0 to lv.Header.Columns.Count-1 do
  if x<>id then begin
    lv.Header.Columns[x].Tag:=0;
    lv.Header.Columns[x].Color:=clWindow;
  end;

lv.Header.SortColumn:=-1;

if colorcolumns=true then
  lv.Header.Columns[id].Color:=clBtnFace;

if lv.Header.Columns[id].tag=2 then
  lv.Header.SortDirection:=sdDescending
else
  lv.Header.SortDirection:=sdAscending;

lv.Header.SortColumn:=id;
end;

function Tfmain.sqlsortcolumn(lv:TVirtualStringTree):ansistring;
var
ini,fin,mid,res:ansistring;
x,i:integer;
begin
ini:='ORDER BY ';
i:=-1;
fin:=' ASC';


for x:=0 to lv.Header.Columns.Count-1 do
  if lv.Header.Columns[x].tag<>0 then begin
    i:=x;

    if lv.Header.columns[x].tag=2 then
      fin:=' DESC';

    break;
  end;

if i=-1 then begin
  i:=0;
  lv.Header.Columns[i].Tag:=1;
end;

//GET ALL FIELDSNAMES
if (wideuppercase(lv.Name)='VIRTUALSTRINGTREE2') then begin

  if lv.Header.Columns.Count=10 then begin

    case i of
    0:mid:='DESCRIPTION';
    1:mid:='VERSION';
    2:mid:='HAVESETS'+fin+',HAVEROMS'+fin+',TOTALSETS';
    3:mid:='HAVEROMS'+fin+',TOTALROMS';
    4:mid:='FILEMODE';
    5:mid:='SHARED';
    6:mid:='ADDED';
    7:mid:='LASTSCAN';
    8:mid:='NAME';
    9:mid:='PATH';
    end;

  end
  else
    case i of
      0:mid:='DESCRIPTION';
      1:mid:='URL';
      2:mid:='ADDED';
    end;

  res:=ini+mid+fin;
end;

try

if masterlv<>nil then
  if masterlv.Name=lv.Name then begin
    case i of
      0:mid:='DESCRIPTION';
      1:mid:='GAMENAME';
      2:mid:='HAVE_'+fin+',TOTAL_';//TOTAL_
      3:mid:='SIZE_';
      4:begin
        if offinfotable<>nil then
            mid:='LANGUAGE'
        else
          mid:='MASTER';//LANG FOR OFF
      end;
      5:mid:='PUBLISHER';
      6:mid:='SAVETYPE';
      7:mid:='SOURCEROM';
      8:mid:='COMMENT';
    end;

    if (i>=2) AND (i<=4) then
      if (i=4) AND (offinfotable<>nil) then
        //
      else
        ini:='*'+ini;

    res:=ini+mid+fin;
  end;

except
end;

try

if detaillv<>nil then
  if detaillv.Name=lv.name then begin
    case i of
      0:mid:='ROMNAME';
      1:mid:='SPACE';
      2:mid:='CRC';
      3:mid:='MD5';
      4:mid:='SHA1';
    end;
    res:=mid+fin;
  end;

except
end;

result:=res;
end;

procedure Tfmain.removedatabaseinconsistences;
var
aux:ansistring;
begin

if DataModule1.DBDatabase.InTransaction=true then begin
  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;
  DataModule1.Qaux.SQL.Add('POST');
  BMDThread1.Start();
  waitforfinishthread;
end;

While DataModule1.Tprofiles.Locate('Totalsets','',[]) do begin

  aux:=fillwithzeroes(DataModule1.Tprofiles.fieldbyname('ID').asstring,4);

  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;

  DataModule1.Qaux.SQL.Add('DROP table Y'+aux+';');

  BMDThread1.Start();
  waitforfinishthread;

  application.processmessages;

  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;

  DataModule1.Qaux.SQL.Add('DROP table Z'+aux+';');

  BMDThread1.Start();
  waitforfinishthread;

  application.processmessages;

  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;

  DataModule1.Qaux.SQL.Add('DROP table O'+aux+';');

  BMDThread1.Start();
  waitforfinishthread;

  Application.ProcessMessages;

  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;

  DataModule1.Qaux.SQL.Add('DROP table R'+aux+';');

  BMDThread1.Start();
  waitforfinishthread;

  DataModule1.Qaux.Close;

  application.processmessages;

  While Datamodule1.TDirectories.Locate('Profile',Datamodule1.Tprofiles.fieldbyname('ID').asinteger,[])=true do
    Datamodule1.TDirectories.Delete;//Already delete his Directories

  Datamodule1.Tprofiles.Delete;
end;

try
  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;
  Datamodule1.Qaux.SQL.Text:='DELETE FROM PROFILES WHERE Tree NOT IN (SELECT ID FROM Tree)';
  DataModule1.Qaux.Open;
except
end;

end;

function GetCheckBoxBitmap(state : integer; Themmed : boolean; BgColor : TColor): TBitmap;
const
CtrlState : array[boolean] of integer = (DFCS_BUTTONCHECK,DFCS_BUTTONCHECK or DFCS_CHECKED);
var
CBRect : TRect;
Details : TThemedElementDetails;
ChkBmp : TBitmap;
checked:boolean;
begin
checked:=false;
ChkBmp := TBitmap.Create;

try

  Result:=bmp;

  with Result do begin
    Width := 16;
    Height := 16;

    with Canvas do begin

      Brush.Color := BgColor;
      FillRect(ClipRect);
      ChkBmp.Assign(Result);
      CBRect := ClipRect;
      CBRect.Top := 1;
      CBRect.Left := 1;

      if state<>0 then
        checked:=true;

      case state of
        0:Details :=ThemeServices.GetElementDetails(tbCheckBoxUncheckedNormal);
        1:Details :=ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal);
        2:Details :=ThemeServices.GetElementDetails(tbCheckBoxMixedNormal)
      end;

      ThemeServices.DrawElement(Handle, Details, CBRect);
      
      if Themmed = False then begin
        CBRect.Left := ClipRect.Left + 2;
        CBRect.Right := ClipRect.Right - 1;
        CBRect.Top := ClipRect.Top + 2; 
        CBRect.Bottom := ClipRect.Bottom - 1;
        DrawFrameControl(Handle, CBRect, DFC_BUTTON, CtrlState[Checked]);
      end;
      
    end;
  end;
finally
  ChkBmp.free;
end;
end;

procedure Tfmain.loadthemedcheckboxes;
begin
imagelist3.Clear;
imagelist3.Addmasked(GetCheckBoxBitmap(0,false,clFuchsia),clFuchsia);
imagelist3.Addmasked(GetCheckBoxBitmap(1,false,clFuchsia),clFuchsia);
imagelist3.Addmasked(GetCheckBoxBitmap(2,false,clFuchsia),clFuchsia);
imagelist3.Addmasked(GetCheckBoxBitmap(0,true,clFuchsia),clFuchsia);
imagelist3.Addmasked(GetCheckBoxBitmap(1,true,clFuchsia),clFuchsia);
imagelist3.Addmasked(GetCheckBoxBitmap(2,true,clFuchsia),clFuchsia);
end;

procedure DisableProcessWindowsGhosting;
var
  DisableProcessWindowsGhostingProc: procedure;
begin

try
  DisableProcessWindowsGhostingProc := GetProcAddress(
    GetModuleHandle('user32.dll'),
    'DisableProcessWindowsGhosting');
  if Assigned(DisableProcessWindowsGhostingProc) then
    DisableProcessWindowsGhostingProc;
except
end;
end;

procedure Tfmain.setlangchanged;
var
deflang:int64;
LangID: DWORD;
begin
deflang:=0;
//https://docs.microsoft.com/en-us/windows/win32/intl/language-identifier-constants-and-strings
try //Windows default languages
  LangID := GetUserDefaultLangID;
  case Byte(LangID and $03FF) of
    LANG_SPANISH: deflang:=1;
    LANG_GERMAN: deflang:=2;
    LANG_FRENCH: deflang:=3;
    LANG_HUNGARIAN: deflang:=4;
    LANG_JAPANESE: deflang:=5;
    LANG_PORTUGUESE: deflang:=6;
    LANG_KOREAN: deflang:=7;
    LANG_ITALIAN: deflang:=8;
    LANG_BASQUE: deflang:=9;
    LANG_CHINESE: deflang:=10;
    LANG_THAI: deflang:=11;
    LANG_POLISH: deflang:=12;
    $64: deflang:=13; //PHILIPINE
  end;
except
end;

if (lang<0) OR (lang>maxlangid) then //EDITION OF INI WRONG LANG HANDLED
  lang:=deflang
end;

procedure Tfmain.setwinvista7theme(hdw:HWND);
begin

try
  if Win32MajorVersion>=6 then
    SetWindowTheme(hdw,'explorer',nil);
except
end;

end;

procedure preparexmlwrite(filename,name,description,vers,date,author,category,homepage,email,headerfile:widestring);
begin
//version,date,author,category,homepage,email
try
  closefile(xmlexport);
except
end;

assignfile(xmlexport,filename);
Rewrite(xmlexport);

Writeln(xmlexport,'<?xml version="1.0" encoding="UTF-8"?>');//UTF8 sinze 0.021
Writeln(xmlexport,'<!DOCTYPE datafile PUBLIC "" "">');
Writeln(xmlexport,'<datafile build="" debug="no">');
Writeln(xmlexport,'	<header>');
Writeln(xmlexport,'		<name>'+UTF8Encode((xmlparser(name)))+'</name>');
Writeln(xmlexport,'		<description>'+UTF8Encode((xmlparser(description)))+'</description>');
Writeln(xmlexport,'		<version>'+UTF8Encode((xmlparser(vers)))+'</version>');
if headerfile<>'' then //0.032
  Writeln(xmlexport,'		<headerfile>'+UTF8Encode((xmlparser(headerfile)))+'</headerfile>');
Writeln(xmlexport,'		<date>'+UTF8Encode((xmlparser(date)))+'</date>');
Writeln(xmlexport,'		<author>'+UTF8Encode((xmlparser(author)))+'</author>');
Writeln(xmlexport,'		<category>'+UTF8Encode((xmlparser(category)))+'</category>');
Writeln(xmlexport,'		<homepage>'+UTF8Encode((xmlparser(homepage)))+'</homepage>');
Writeln(xmlexport,'		<email>'+UTF8Encode((xmlparser(email)))+'</email>');
Writeln(xmlexport,'	</header>');
end;

procedure xmlwriteset(gamename,description:widestring);
begin
gamename:=xmlparser(gamename);
description:=xmlparser(description);

Writeln(xmlexport,'	<game name="'+UTF8Encode(gamename)+'">');
Writeln(xmlexport,'		<description>'+UTF8Encode(description)+'</description>');
end;

procedure xmlwriterom(filename:widestring;size,crc,md5,sha1:ansistring;typ:integer);
var
aux:widestring;
cad:ansistring;
begin
//Make unicode conversion

if Length(size)>0 then
  cad:=' size="'+size+'"';

if length(crc)=8 then
  cad:=cad+' '+'crc="'+crc+'"';
if length(md5)=32 then
  cad:=cad+' '+'md5="'+md5+'"';
if length(sha1)=40 then
  cad:=cad+' '+'sha1="'+sha1+'"';

case typ of
  0:Writeln(xmlexport,'		<rom name="'+UTF8Encode(xmlparser(filename))+'"'+cad+'/>');
  1:Writeln(xmlexport,'		<sample name="'+UTF8Encode((xmlparser(filename)))+'"'+cad+'/>');
  2:begin

      //if gettokencount(filename,'.')>1 then
      aux:=WideExtractFileExt(filename);
      if Wideuppercase(aux)='.CHD' then
        filename:=copy(filename,1,length(filename)-4);

      Writeln(xmlexport,'		<disk name="'+UTF8Encode((xmlparser(filename)))+'"'+cad+'/>');
  end;
end;

end;

procedure xmlcloseset();
begin
Writeln(xmlexport,'	</game>');
end;

procedure closexmlwrite();
begin
try
  Writeln(xmlexport,'</datafile>');
except
end;

try
  closefile(xmlexport);
except
end;
end;

function Tfmain.openandselectinbrowser(path:widestring):boolean;
var
res:boolean;
begin
res:=false;
path:=GetShortFileName(path); //LONGPATH FIX 0.046

if (FileExists2(path)) or (WideDirectoryExists(path)) then begin
  ShellExecutew(Handle,'OPEN',Pwidechar(widestring('explorer.exe')),Pwidechar('/select, "' + path + '"'),nil,SW_NORMAL);
  res:=true;
end;

Result:=res;
end;

procedure Tfmain.fixcolumnsdragged(lv:Tlistview);
var
x:integer;
cad:ansistring;
begin
for x:=0 to lv.Columns.Count-1 do begin
  cad:=lv.Column[x].DisplayName;
  lv.Column[x].DisplayName:=cad+' ';
  lv.Column[x].DisplayName:=cad;
end;
end;

procedure Tfmain.adderror(text:widestring);
begin
if sterrors.Count<=99 then
  sterrors.add(text)
else
if sterrors.Count=100 then
  sterrors.add(traduction(333))

end;

procedure Tfmain.currentdbstatusname;
begin
if formexists('Flog')=false then //FIX
  exit;

tntpanel4.Caption:=gettrimmedtext(traduction(30)+' : '+changein(UTF8Decode(DataModule1.DBDatabase.DatabaseFileName),'&','&&'),tntpanel4.width-10);
end;

procedure Tfmain.Checksleep;
begin

try
  SystemCritical.IsCritical := preventsleep;
except
end;

end;

procedure Tfmain.compresscache(filename:widestring);
var
aux:widestring;
begin
aux:=tempdirectorycache+'cache';

if sizeoffile(aux)>10 then begin
  try
    Zip1.CloseArchive;
    Zip1.FileName:=filename;
    Zip1.BaseDir:=tempdirectorycache;
    Zip1.CompressionLevel:=clMax; //0.042
    Zip1.OpenArchive(fmCreate);
    Zip1.AddFiles(aux);
  except
  end;

  Fmain.Zip1.CloseArchive;
end;

deletefile2(aux)
end;

procedure Tfmain.findinlistview(lv:TVirtualStringTree;T:Tabstable;down:boolean;edit:TTntedit;fieldname:ansistring);
var
x,root,child:longint;
found,pass:boolean;
text:widestring;
n:PVirtualNode;
scolumn:Shortint;
begin
n:=nil;
found:=false;
scolumn:=0;

try

text:=edit.Text;

if (text='') OR (lv.RootNodeCount=0) then
  exit;

text:=wideuppercase(text);

x:=-1;

try
  n:=lv.FocusedNode;
  x:=n.Index;
except
end;

if n=nil then begin
  if down=true then begin
    T.first;
    n:=lv.Getfirst;
  end
  else begin
    T.Last;
    n:=lv.GetLast;
  end;
end
else
  x:=x+1;

screen.Cursor:=crHourGlass;

if T.name<>'Tconstructor' then begin //0.030 Wrong CONT sort solution with searches

  if Pagecontrol1.ActivePageIndex=1 then begin
    scolumn:=combobox1.itemindex;
    if scolumn>1 then
      scolumn:=combobox1.itemindex+2;
  end;


  while n<>nil do begin

    if down=true then
      n:=n.NextSibling
    else
      n:=n.PrevSibling;

    if Changein(wideuppercase(lv.text[n,scolumn]),text,'*')<>wideuppercase(wideuppercase(lv.text[n,scolumn])) then begin
      posintoindexbynode(n,lv);
      found:=true;
      break;
    end;

  end;
end
else
if (lv.RootNodeCount>0) then begin

  if x<>-1 then begin

    child:=0;
    if lv.GetNodeLevel(n)=1 then begin
      root:=n.Parent.Index;
      child:=n.Index;
      child:=child+1;
    end
    else
      root:=n.Index;

    root:=root+1;

    T.locate('ROOTCONT;CHILDCONT',VarArrayOf([root,child]),[]);
  end;


  while (T.Bof=false) OR (T.Eof=false) do begin

    if down=true then begin

      if x<>-1 then //IF NO INDEX START
        T.next;

      x:=0;

      if T.Eof=true then
        break;

    end
    else begin

      if x<>-1 then //IF NO INDEX START
        T.Prior;

      x:=0;

      if T.Bof=true then
        break;
    end;

    if Changein(wideuppercase(getwiderecord(T.fieldbyname(fieldname))),text,'*')<>wideuppercase(getwiderecord(T.fieldbyname(fieldname))) then begin

      root:=T.fieldbyname('ROOTCONT').asinteger;
      child:=T.fieldbyname('CHILDCONT').asinteger;
      n:=lv.GetFirst;
      pass:=false;

      while n<>nil do begin //ROOT

        if lv.GetNodeLevel(n)=0 then begin
          if n.Index=root-1 then
            if child=0 then
              break
            else
              pass:=true;//FOUND MASTER NODE
        end
        else
        if pass=true then //FIND CHILD NODE
          if n.Index=child-1 then
            break;

        n:=lv.GetNext(n,false);
      end;

      posintoindexbynode(n,lv);

      found:=true;
      break;
    end;

  end;

end;

except
end;

screen.Cursor:=crDefault;

if found=false then
  mymessageinfo(traduction(257));

freekeyboardbuffer;
freemousebuffer;

end;

function Tfmain.importdat(path:widestring;id:longint):shortint;
begin

//TRY TO DELETE POSSIBLE TEMP TABLES
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.SQL.Add('DROP TABLE TEMPY;');


try
  BMDThread1.Start();
  waitforfinishthread;
except
end;

Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.SQL.Add('DROP TABLE TEMPZ;');

try
  BMDThread1.Start();
  waitforfinishthread;
except
end;


Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.SQL.Add('DROP TABLE TEMPO;');//OLLINFO

try
  BMDThread1.Start();
  waitforfinishthread;
except
end;

Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.SQL.Add('DROP TABLE TEMPR;');//REGION

try
  BMDThread1.Start();
  waitforfinishthread;
except
end;


Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;

Result:=importdatpass(path,id,defofffilename);

removedatabaseinconsistences;
end;

procedure Tfmain.setstayontop;
begin

if Stayontop1.Checked=false then begin
  Stayontop1.Checked:=true;
end;

if getformscount<>2 then begin
  Stayontop1.Tag:=1;
  exit;
end;

treeview1.Tag:=1;


SetWindowPos(
  Handle,
  HWND_TOPMOST,
  0,
  0,
  0,
  0,
  SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

setstaystatuslabel;

treeview1.Tag:=0;
end;

procedure Tfmain.loadconfig;
var
IniFile : Tinifile;
inipath,aux,del:widestring;
x,initial:integer;
const
dbase='DB';
window='WINDOW';
misc='MISC';
inidirs='INIDIRS';
daters='DATERS';
dircreator='DIRMAKER';
defdecisions='DEFDECISIONS';
filters='FILTERS';
columns='COLUMNS';
community='COMMUNITY';
begin
inipath:=WideExtractfilepath(TntApplication.ExeName)+'romulus.ini';

if FileExists2(inipath) then
  if sizeoffile(inipath)>1024*64 then //MAX SIZE OF INI FILE THEN IGNORE IT
    exit;

if isunicodefilename(inipath) then begin
  del:=tempdirectoryresources+'ini.rmt';
  copyfile2(inipath,del);
  inipath:=del;
end;

IniFile := Tinifile.Create(inipath) ;
try
  with IniFile do begin

    sterrors.Strings[0]:=UTF8Decode(ReadString(dbase,'DB',''));
    Fmain.top:=ReadInteger(window,'Top',DesktopSize.Top) ;
    Fmain.left:=Readinteger(window,'Left', DesktopSize.left) ;
    Fmain.Width:=Readinteger(window,'Width', Fmain.Constraints.MinWidth) ;
    Fmain.Height:=Readinteger(window,'Height', Fmain.Constraints.MinHeight) ;
    Fmain.WindowState:=wsNormal;
    if ReadBool(window,'Max',false)=true then
      Fmain.WindowState:=wsMaximized;

    if ReadBool(window,'Stayontop',false)=true then
      timer1.Tag:=1;

    if ReadBool(window,'Trayicon',true)=true then
      cooltrayicon1.Tag:=2;

    lang:=Readinteger(misc,'Lang',-1);

    ingridlines:=ReadBool(misc,'Gridlines',false);
    setgridlines(virtualstringtree4,ingridlines);
    setgridlines(virtualstringtree2,ingridlines);
    defromscomp:=Readinteger(misc,'Defromscomp',19);
    defsamplescomp:=Readinteger(misc,'Defsamplescomp',19);
    defchdscomp:=Readinteger(misc,'Defchdscomp',0);
                                                                   
    tempdirectoryextractvar:=UTF8Decode(Readstring(misc,'Deftempdir',''));
    defbackuppath:=UTF8Decode(Readstring(misc,'Defbackuppath',tempdirectoryresources[1]+':\backup\'));
    defofffilename:=UTF8Decode(Readstring(misc,'Offlinelistfile',''));
    maxloglines:=Readinteger(misc,'Maxloglines',5000);
    defmd5:=ReadBool(misc,'DefMD5',false);
    defsha1:=ReadBool(misc,'DefSHA1',false);
    deftz:=ReadBool(misc,'DefTz',false);
    deft7z:=ReadBool(misc,'DefT7z',false);
    showasbytes:=ReadBool(misc,'Showasbytes',false);
    defFileMode:=Readinteger(misc,'Deffilemode',1);
    speedbutton7.Tag:=Readinteger(misc,'Autoscrolllog',0);
    speedbutton13.Tag:=Readinteger(misc,'Showlog',1);
    initialdirsharefile:=UTF8Decode(Readstring(misc,'Initialdirsharefile',''));

    if ReadBool(misc,'Resizelog',true)=false then
      speedbutton11.tag:=1;

    searchromulsupdates:=ReadBool(misc,'Searchupdates',true);
    speedbutton42.Down:=ReadBool(misc,'MD5Gen',false);
    speedbutton43.Down:=ReadBool(misc,'SHA1Gen',false);
    speedbutton49.Down:=ReadBool(misc,'CompressGen',true);
    colorcolumns:=ReadBool(misc,'Colorsortcolumns',true);
    useownwb:=ReadBool(misc,'OwnWB',true);
    solidcomp:=ReadBool(misc,'Solidcomp',true);
    multicpu:=ReadBool(misc,'Multicpu',true);
    userar5:=ReadBool(misc,'UseRAR5',false);
    preventsleep:=ReadBool(misc,'Preventoff',true);

    edit4.Tag:=Readinteger(misc,'Timeout',5);

    Activaterecursive1.Checked:=ReadBool(misc,'Recursivelist',false);


    try
    edit4.Tag:=edit4.tag*1000;
    except
    end;

    Makedirectoriesbycompressedfile1.Checked:=Readbool(misc,'Extractdir',true);
    updaterdatsdecision:=ReadInteger(misc,'Updaterdecision',0);

    //COMMUNITY
    username:=UTF8Decode(Readstring(community,'Username',UTF8Encode(GetUserFromWindows)));
    username:=removeconflictchars2(username,false);
    
    connectionport:=ReadInteger(community,'Port',defserverport);
    defaultprofileshare:=ReadBool(community,'Defprofileshare',false);
    startupconnect:=ReadBool(community,'Startupconnect',false);
    communitydownfolder:=UTF8Decode(Readstring(community,'Downloadsfolder',UTF8Encode(defcommunitydownfolder)));

    upslots:=ReadInteger(community,'Upslots',3);
    downslots:=ReadInteger(community,'Downslots',3);

    upspeed:=ReadInteger(community,'Upspeed',0);
    downspeed:=ReadInteger(community,'Downspeed',0);

    servertransparency:=ReadInteger(community,'Transparency',255);

    if (servertransparency<150) OR (servertransparency>255) then
      servertransparency:=255;

    agressive:=ReadBool(community,'Agressive',false);
    firewall:=ReadBool(community,'Firewall',false);

    opt1:=ReadBool(dircreator,'Opt1',true);
    opt2:=ReadBool(dircreator,'Opt2',true);
    opt3:=ReadBool(dircreator,'Opt3',true);
    foldname:=ReadBool(dircreator,'Foldname',true);
    recdir:=ReadBool(dircreator,'Recdir',false);


    initialdirimportdat:=UTF8Decode(Readstring(inidirs,'Importdat',UTF8Encode(initialdirimportdat)));
    initialdirimportmameexe:=UTF8Decode(Readstring(inidirs,'Importexe',UTF8Encode(initialdirimportmameexe)));
    initaldiropendatabase:=UTF8Decode(Readstring(inidirs,'Opendb',UTF8Encode(initaldiropendatabase)));
    initialdirsavedb:=UTF8Decode(Readstring(inidirs,'Savedb',UTF8Encode(initialdirsavedb)));
    initialdirrebuild:=UTF8Decode(Readstring(inidirs,'Rebuild',UTF8Encode(initialdirrebuild)));
    initialdirexport:=UTF8Decode(Readstring(inidirs,'Export',UTF8Encode(initialdirexport)));
    initialdirffix:=UTF8Decode(Readstring(inidirs,'FFix',UTF8Encode(initialdirexport)));
    initialdiremulator:=UTF8Decode(Readstring(inidirs,'Emulators',UTF8Encode(initialdiremulator)));
    initialdirroms:=UTF8Decode(Readstring(inidirs,'Roms',UTF8Encode(initialdirroms)));
    initialdirimages:=UTF8Decode(Readstring(inidirs,'Images',UTF8Encode(initialdirimages)));
    initialdirlog:=UTF8Decode(Readstring(inidirs,'Logs',UTF8Encode(initialdirlog)));
    initialdirhash:=UTF8Decode(Readstring(inidirs,'Hashing',UTF8Encode(initialdirhash)));
    initialdirxmlexport:=UTF8Decode(Readstring(inidirs,'Builder',UTF8Encode(initialdirhash)));
    initialdirfoldcreator:=UTF8Decode(Readstring(inidirs,'Foldcreator',UTF8Encode(initialdirfoldcreator)));
    initialdirextract:=UTF8Decode(Readstring(inidirs,'Extract',UTF8Encode(initialdirextract)));
    initialdirxmlcreation:=UTF8Decode(Readstring(inidirs,'CreationXML',UTF8Encode(initialdirxmlcreation)));

    for x:=0 to datgroups.Count-1 do begin
      aux:=gettoken(datgroups.Strings[x],'|',1);
      if ReadBool(daters,'D'+aux,true)=false then
        datgroups.Strings[x]:=aux+'|0';
    end;

    fix0:=Readstring(defdecisions,'fix0','0');
    fix1:=Readstring(defdecisions,'fix1','0');
    fix2:=Readstring(defdecisions,'fix2','0');
    fix3:=Readstring(defdecisions,'fix3','0');
    fix4:=Readstring(defdecisions,'fix4','0');
    fix5:=Readstring(defdecisions,'fix5','0');
    fix6:=Readstring(defdecisions,'fix6','0');
    fix7:=Readstring(defdecisions,'fix7','0');

    filtertext:=UTF8Decode(Readstring(filters,'text',''));
    filterdetection:=Readinteger(filters,'detection',1);
    filtersearchin:=Readinteger(filters,'searchin',2);

    filtermatch:=ReadBool(filters,'match',true);
    filteruncheck:=ReadBool(filters,'uncheck',true);

    for x:=0 to VirtualStringTree2.Header.Columns.Count-1 do begin
      initial:=Readinteger(columns,'column'+inttostr(x),VirtualStringTree2.Header.Columns[x].width);

      if initial<50 then
        initial:=50
      else
      if initial>2000 then
        initial:=2000;

      VirtualStringTree2.Header.Columns[x].width:=initial;
    end;

    treeview1.width:=Readinteger(columns,'treeview',treeview1.width);
    if treeview1.Width>Fmain.Width then
      treeview1.Width:=178;//FIX
  end;

finally
  IniFile.Free;
end;

if del<>'' then
  deletefile2(del);

end;

procedure Tfmain.saveconfig;
var
IniFile : Tinifile;
inipath,del:widestring;
b:boolean;
x:integer;
const
dbase='DB';
window='WINDOW';
misc='MISC';
inidirs='INIDIRS';
daters='DATERS';
dircreator='DIRMAKER';
defdecisions='DEFDECISIONS';
filters='FILTERS';
columns='COLUMNS';
community='COMMUNITY';
begin
if Fmain.CoolTrayIcon1.Enabled=false then //PREVENT RARE DOUBLEPASS 0.037
  exit;

inipath:=WideExtractfilepath(Tntapplication.ExeName)+'romulus.ini';
deletefile2(inipath);

if isunicodefilename(inipath) then begin
  del:=inipath;
  inipath:=tempdirectoryresources+'ini.rmt';
end;

IniFile := Tinifile.Create(inipath) ;
try

  with IniFile, Fmain do
  begin

    b:=false;
    if Fmain.WindowState=wsMaximized=true then begin
      b:=true;

      Fmain.WindowState:=wsnormal;
    end;

    Writestring(dbase,'DB',Datamodule1.DBDatabase.DatabaseFileName); //ALREADY UTF8

    WriteInteger(window,'Top', Top) ;
    WriteInteger(window,'Left', Left) ;
    WriteInteger(window,'Width', Width) ;
    WriteInteger(window,'Height', Height) ;
    WriteBool(window,'Max',b);
    WriteBool(window,'Trayicon',Cooltrayicon1.IconVisible);
    Writebool(window,'Stayontop',Stayontop1.Checked);

    WriteInteger(misc,'Lang',lang);
    Writebool(misc,'Gridlines',ingridlines);
    WriteInteger(misc,'Defromscomp',defromscomp);
    WriteInteger(misc,'Defsamplescomp',defsamplescomp);
    WriteInteger(misc,'Defchdscomp',defchdscomp);
    Writebool(misc,'DefMD5',defmd5);
    Writebool(misc,'DefSHA1',defsha1);
    Writebool(misc,'DefTz',deftz);
    Writebool(misc,'DefT7z',deft7z);
    Writestring(misc,'Deftempdir',UTF8Encode(tempdirectoryextractvar));
    Writestring(misc,'Defbackuppath',UTF8Encode(defbackuppath));
    Writestring(misc,'Offlinelistfile',UTF8Encode(defofffilename));
    WriteInteger(misc,'Maxloglines',maxloglines);
    Writebool(misc,'Showasbytes',showasbytes);
    WriteInteger(misc,'Deffilemode',deffilemode);
    Writebool(misc,'Searchupdates',searchromulsupdates);
    Writestring(misc,'Initialdirsharefile',UTF8Encode(initialdirsharefile));


    b:=Flog.SpeedButton3.Down;
    if b=true then
      b:=false
    else
      b:=true;

    Writebool(misc,'Autoscrolllog',b);

    b:=false;
    if Flog.Tag=1 then
      b:=true;

    Writebool(misc,'Showlog',b);
    Writebool(misc,'Resizelog',Flog.SpeedButton4.Down);

    Writebool(misc,'MD5Gen',speedbutton42.Down);
    Writebool(misc,'SHA1Gen',speedbutton43.Down);
    Writebool(misc,'CompressGen',speedbutton49.Down);
    Writebool(misc,'OwnWB',useownwb);
    Writebool(misc,'Solidcomp',solidcomp);
    Writebool(misc,'Multicpu',multicpu);
    Writebool(misc,'UseRAR5',userar5);
    Writebool(misc,'Preventoff',preventsleep);
    Writebool(misc,'Recursivelist',Activaterecursive1.Checked);
    Writebool(misc,'Colorsortcolumns',colorcolumns);

    try
      WriteInteger(misc,'Timeout',edit4.Tag div 1000);
    except
    end;

    WriteInteger(misc,'Updaterdecision',updaterdatsdecision);

    //COMMUNITY
    WriteString(community,'Username',UTF8Encode(username));
    WriteInteger(community,'Port',connectionport);
    WriteBool(community,'Defprofileshare',defaultprofileshare);
    WriteBool(community,'Startupconnect',startupconnect);
    WriteString(community,'Downloadsfolder',communitydownfolder);

    WriteInteger(community,'Upslots',upslots);
    WriteInteger(community,'Downslots',downslots);
    WriteInteger(community,'Upspeed',upspeed);
    WriteInteger(community,'Downspeed',downspeed);

    WriteInteger(community,'Transparency',servertransparency);

    WriteBool(community,'Agressive',agressive);
    WriteBool(community,'Firewall',firewall);

    Writebool(dircreator,'Opt1',Opt1);
    Writebool(dircreator,'Opt2',Opt2);
    Writebool(dircreator,'Opt3',Opt3);
    Writebool(dircreator,'Foldname',foldname);
    Writebool(dircreator,'Recdir',recdir);

    Writebool(misc,'Extractdir',Makedirectoriesbycompressedfile1.Checked);

   Writestring(inidirs,'Importdat',UTF8Encode(checkpathbar(initialdirimportdat)));
   Writestring(inidirs,'Importexe',UTF8Encode(checkpathbar(initialdirimportmameexe)));
   Writestring(inidirs,'Opendb',UTF8Encode(checkpathbar(initaldiropendatabase)));
   Writestring(inidirs,'Savedb',UTF8Encode(checkpathbar(initialdirsavedb)));
   Writestring(inidirs,'Rebuild',UTF8Encode(checkpathbar(initialdirrebuild)));
   Writestring(inidirs,'Export',UTF8Encode(checkpathbar(initialdirexport)));
   Writestring(inidirs,'FFix',UTF8Encode(checkpathbar(initialdirffix)));
   Writestring(inidirs,'Emulators',UTF8Encode(checkpathbar(initialdiremulator)));
   Writestring(inidirs,'Roms',UTF8Encode(checkpathbar(initialdirroms)));
   Writestring(inidirs,'Images',UTF8Encode(checkpathbar(initialdirimages)));
   Writestring(inidirs,'Logs',UTF8Encode(checkpathbar(initialdirlog)));
   Writestring(inidirs,'Hashing',UTF8Encode(checkpathbar(initialdirhash)));
   Writestring(inidirs,'Builder',UTF8Encode(checkpathbar(initialdirxmlexport)));
   Writestring(inidirs,'Foldcreator',UTF8Encode(checkpathbar(initialdirfoldcreator)));
   Writestring(inidirs,'Extract',UTF8Encode(checkpathbar(initialdirextract)));
   Writestring(inidirs,'CreateXML',UTF8Encode(checkpathbar(initialdirxmlcreation)));

   for x:=0 to datgroups.Count-1 do begin
    b:=true;
    if gettoken(datgroups.Strings[x],'|',2)='0' then
      b:=false;

    Writebool(daters,'D'+gettoken(datgroups.Strings[x],'|',1),b);

   end;

   Writestring(defdecisions,'fix0',fix0);
   Writestring(defdecisions,'fix1',fix1);
   Writestring(defdecisions,'fix2',fix2);
   Writestring(defdecisions,'fix3',fix3);
   Writestring(defdecisions,'fix4',fix4);
   Writestring(defdecisions,'fix5',fix5);
   Writestring(defdecisions,'fix6',fix6);
   Writestring(defdecisions,'fix7',fix7);

   Writestring(filters,'text',UTF8Encode(filtertext));

   WriteInteger(filters,'detection',filterdetection);
   WriteInteger(filters,'searchin',filtersearchin);

   Writebool(filters,'match',filtermatch);
   Writebool(filters,'uncheck',filteruncheck);

   for x:=0 to VirtualStringTree2.Header.Columns.Count-1 do
    WriteInteger(columns,'column'+inttostr(x),VirtualStringTree2.Header.Columns[x].Width);

   WriteInteger(columns,'treeview',treeview1.Width);
  end;
finally
  IniFile.Free;
end;

try
  if del<>'' then
    movefile2(Pwidechar(inipath),Pwidechar(del));
except
end;

end;

procedure Tfmain.savefocussedcontrol;
begin

if (GetFormsCount=2) then begin

  try

    if PageControl1.ActivePageIndex=0 then begin
      if activecontrol=VirtualStringTree2 then
        tabsheet1.Tag:=1
      else
      if activecontrol=Treeview1 then
        tabsheet1.Tag:=0
      else
      if activecontrol=edit4 then begin
        tabsheet1.Tag:=2;
      end
    end
    else
    if pagecontrol1.ActivePageIndex=1 then begin

      if activecontrol=Edit5 then begin
        tabsheet2.Tag:=5;
      end
      else
      if activecontrol=masteredit then begin
        tabsheet2.Tag:=1;
      end
      else
      if activecontrol=masterlv then
        tabsheet2.Tag:=0
      else
      if activecontrol=detailedit then begin
        tabsheet2.Tag:=2;
      end
      else
      if activecontrol=detaillv then
        tabsheet2.Tag:=3
      else
        tabsheet2.Tag:=4; //DEF COMBO

    end
    else
    if pagecontrol1.ActivePageIndex=2 then begin
      if activecontrol=edit6 then begin
        tabsheet3.Tag:=1;
      end
      else
      if activecontrol=VirtualStringTree4 then
        tabsheet3.Tag:=2
      else
        tabsheet3.Tag:=0;//DEF COMBO
    end
    else
    if pagecontrol1.ActivePageIndex=3 then begin
      if activecontrol=edit8 then begin
        tabsheet4.Tag:=1;
      end
      else
      if activecontrol=edit9 then begin
        tabsheet4.Tag:=2;
      end
      else begin
        tabsheet4.Tag:=0;
      end;

    end;

  except
    tabsheet2.Tag:=0;
  end;

end;

end;

procedure Tfmain.restorefocussedcontrol;
begin
if (GetFormsCount=2) then begin
       
  try

  if PageControl1.ActivePageIndex=0 then begin
    case tabsheet1.Tag of
      0:stablishfocus(treeview1);
      1:stablishfocus(VirtualStringTree2);
      2:stablishfocus(edit4);
    end;
  end
  else
  if pagecontrol1.ActivePageIndex=1 then begin
    case tabsheet2.Tag of
      4:stablishfocus(combobox1);
      5:if edit5.focused=false then
          stablishfocus(edit5);
      0:begin
          stablishfocus(masterlv);
        end;
      1:begin
        stablishfocus(masteredit);
      end;
      2:begin
        stablishfocus(detailedit);
      end;
      3:stablishfocus(detaillv);
    end;
  end
  else
  if pagecontrol1.ActivePageIndex=2 then begin
    case tabsheet3.Tag of
      0:stablishfocus(combobox2);
      1:stablishfocus(edit6);
      2:stablishfocus(VirtualStringTree4);
    end;
  end
  else
  if pagecontrol1.ActivePageIndex=3 then begin
    case TabSheet4.Tag of
      0:stablishfocus(combobox3);
      1:stablishfocus(edit8);
      2:stablishfocus(edit9);
    end;
  end;

  except
    try
      //stablishfocus(combobox1);
    except
    end;
  end;

end;

//BUG FIX
try
if pagecontrol1.ActivePageIndex=1 then
  if pagecontrol2.PageCount=1 then
    if edit5.Focused=false then
      stablishfocus(combobox1);
except
end;

end;

function Tfmain.zipvalidfile(path:widestring;z:Tzipforge):boolean;
var
res,added:boolean;
Archiveitem:TZFArchiveItem;
aux,aux2:widestring;
i,x:integer;
//foldercheck:boolean;
//oldfolder:widestring;
begin
res:=false;
//foldercheck:=false;

if z.Name='Zip1' then begin

  if zip2.Tag>=1 then //Erazor
    if wideuppercase(zip2.FileName)=wideuppercase(path) then begin

      try
        zip2.CloseArchive;
      except
      end;

      zip2.tag:=0;
    end;

  z.CloseArchive;
  z.Tag:=0;

  stcompfiles.Clear;
  stcompcrcs.Clear;
  stcompsizes.clear;
  realcompressedfilecount:=0;
end
else begin

  //Already opened
  if (z.FileName=path) AND (z.Tag>=1) then begin //Erazor
    result:=true;
    exit;
  end;

  stcompfiles2.Clear;
  stcompcrcs2.Clear;
  stcompsizes2.clear;

  z.CloseArchive;
  z.Tag:=0;
end;

try
  if FileExists2(path) then begin
    //SFX Detection

    try
      WideFileSetAttr(path,faArchive);//IF READONLY THEN READ AND WRITE
    except
    end;

    if isanexefile(path)=true then
      makeexception;

    z.Filename:=path;

    //z.OpenArchive(fmOpenReadWrite); //Erazor fix
    z.OpenArchive(fmOpenRead);

    if z.Name='Zip1' then begin

      zip1multivolume:=false;

      if z.VolumeNumberInfo.VolumeNumber<>-1 then
        zip1multivolume:=true;

      if (z.FindFirst('*.*',ArchiveItem)) then
      repeat

        if archiveitem.Encrypted=true then //PASSWORED
          makeexception;

        added:=true;

        aux:=Archiveitem.StoredPath+Archiveitem.filename;
        aux:=changein(aux,'/','\');

        if archiveitem.ExternalFileAttributes and fadirectory > 0 then begin
          aux:=checkpathbar(aux);
          if stcompfiles.IndexOf(aux)=-1 then begin
            stcompfiles.Add(aux);
            stcompcrcs.add('00000000');
            stcompsizes.Add('0');
          end
          else
            added:=false;

        end
        else begin
          stcompfiles.Add(aux);
          stcompcrcs.add(inttohex(Archiveitem.CRC,8));
          stcompsizes.Add(IntToStr(Archiveitem.UncompressedSize));
          realcompressedfilecount:=realcompressedfilecount+1;
        end;

        //0.028 SPEEDUP SORTING AND FINDING METHOD
        if added=true then begin  //0.034
          i:=stcompfiles.IndexOf(aux);
          stcompcrcs.Move(stcompcrcs.Count-1,i);
          stcompsizes.Move(stcompsizes.Count-1,i);

          //Folder fix problem 0.032
          aux2:='';
          i:=GetTokenCount(aux,'\');

          if i>1 then
          for x:=1 to i-1 do begin

            aux2:=aux2+gettoken(aux,'\',x)+'\';
            i:=stcompfiles.IndexOf(aux2);

            if i=-1 then begin //DOES NOT EXISTS ADD IT
              stcompfiles.Add(aux2);
              stcompcrcs.add('00000000');
              stcompsizes.Add('0');
              i:=stcompfiles.IndexOf(aux2);//REORDER
              stcompcrcs.Move(stcompcrcs.Count-1,i);
              stcompsizes.Move(stcompsizes.Count-1,i);
            end;
          end;

        end;///ADDED


      until (not z.FindNext(ArchiveItem));

      if stcompfiles.Count>0 then begin
        res:=true;
        z.tag:=1;//Erazor
      end
      else
        z.Tag:=0;

      if z.tag=0 then
        z.closearchive;

    end
    else
    if z.Name='Zip2' then begin

      zip2multivolume:=false;

      if z.VolumeNumberInfo.VolumeNumber<>-1 then
        zip2multivolume:=true;

      if (z.FindFirst('*.*',ArchiveItem)) then
      repeat

        if archiveitem.Encrypted=true then //PASSWORED
          makeexception;

        added:=true;

        aux:=Archiveitem.StoredPath+Archiveitem.filename;
        aux:=changein(aux,'/','\');

        if archiveitem.ExternalFileAttributes and fadirectory > 0 then begin
          aux:=checkpathbar(aux);
          if stcompfiles2.IndexOf(aux)=-1 then begin //0.034
            stcompfiles2.Add(aux);
            stcompcrcs2.add('00000000');
            stcompsizes2.Add('0');
          end
          else
            added:=false;
        end
        else begin
          stcompfiles2.Add(aux);
          stcompcrcs2.add(inttohex(Archiveitem.CRC,8));
          stcompsizes2.Add(IntToStr(Archiveitem.UncompressedSize));
        end;

        //0.028 SPEEDUP SORTING AND FINDING METHOD
        if added=true then begin //0.034
          i:=stcompfiles2.IndexOf(aux);
          stcompcrcs2.Move(stcompcrcs2.Count-1,i);
          stcompsizes2.Move(stcompsizes2.Count-1,i);

          //Folder fix problem 0.032
          aux2:='';
          i:=GetTokenCount(aux,'\');

          if i>1 then
          for x:=1 to i-1 do begin

            aux2:=aux2+gettoken(aux,'\',x)+'\';
            i:=stcompfiles2.IndexOf(aux2);

            if i=-1 then begin //DOES NOT EXISTS ADD IT
              stcompfiles2.Add(aux2);
              stcompcrcs2.add('00000000');
              stcompsizes2.Add('0');
              i:=stcompfiles2.IndexOf(aux2);//REORDER
              stcompcrcs2.Move(stcompcrcs2.Count-1,i);
              stcompsizes2.Move(stcompsizes2.Count-1,i);
            end;
          end;

        end;//ADDED

      until (not z.FindNext(ArchiveItem));

      if stcompfiles2.Count>0 then begin //0.028 CHANGED
        res:=true;
        z.tag:=1;
      end
      else begin
        z.closearchive;
        z.Tag:=0;
      end;

    end;

  end;

except
  z.closearchive;
  z.Tag:=0;
end;

Result:=res;
end;

function Tfmain.rarvalidfile(path:widestring;rar:Trar):boolean;
var
res:boolean;
newage:integer;
begin
res:=false;
newage:=-1;

if rar.Name='RAR1' then begin
  rar1multivolume:=false;
  stcompfiles.Clear;
  stcompcrcs.Clear;
  stcompsizes.clear;
  rar1filename:=path;
  realcompressedfilecount:=0;
end
else begin

  newage:=Widefileage2(path);

  if lastcompfile2=path then begin  //0.028 SPEED HACK

    if newage<>-1 then
      if newage=lastcompdate2 then begin
        result:=true;
        exit;
      end;

  end;

  stcompfiles2.Clear;
  stcompcrcs2.Clear;
  stcompsizes2.clear;
  rar2filename:=path;
end;

try
  res:=rar.OpenFile(path);

  if rar.ArchiveInformation.MultiVolume=true then
    if rar.ArchiveInformation.isfirstvolume=false then
      res:=false;

  if rar.Name='RAR1' then begin
    rar1multivolume:=rar.ArchiveInformation.MultiVolume;
    if stcompfiles.Count=0 then
      res:=false;
  end
  else
    if stcompfiles2.Count=0 then
      res:=false;

  if (rar.ArchiveInformation.SFX=true) OR (rar.ArchiveInformation.HeaderEncrypted=true) OR (rar.ArchiveInformation.Encryption=true) then
    res:=false;

  if res=false then begin
    if rar.Name='RAR1' then begin
      stcompfiles.Clear;
      stcompcrcs.Clear;
      stcompsizes.clear;
    end
    else begin
      stcompfiles2.Clear;
      stcompcrcs2.Clear;
      stcompsizes2.clear;
    end;
  end
  else begin //0.028 CHANGED
    lastcompfile2:=path;
    lastcompdate2:=newage;
  end;

except
end;


Result:=res;
end;

function Tfmain.sevenzipvalidfile(path:widestring;sz:Tsevenzip):boolean;
var
res:boolean;
newage:integer;
begin
res:=false;
sz.tag:=0;
newage:=-1;

if sz.Name='SevenZip1' then begin
  sevenzip1multivolume:=false;
  stcompfiles.clear;
  stcompcrcs.Clear;
  stcompsizes.clear;
  realcompressedfilecount:=0;
  sevenzip1filename:=path;
end
else begin
  newage:=Widefileage2(path);

  if lastcompfile2=path then begin  //0.028 SPEED HACK

    if newage<>-1 then
      if newage=lastcompdate2 then begin
        result:=true;
        exit;
      end;

  end;

  stcompfiles2.clear;
  stcompcrcs2.Clear;
  stcompsizes2.clear;
  sevenzip2filename:=path;
end;

try

  sz.SZFileName:=path;

  if sz.List>-1 then
    if (sz.IsSFX=false) AND (sz.Tag=0) then begin//SFX & PASSWORD ignore

      if sz.Name='SevenZip1' then begin
        sevenzip1multivolume:=sz.Ismultidisk;
        if stcompfiles.Count>0 then
          res:=true;
      end
      else begin
        if stcompfiles2.Count>0 then begin //0.028 CHANGED
          res:=true;
          lastcompfile2:=path;
          lastcompdate2:=newage;
        end;
      end;
    end;

except

end;


Result:=res;
end;

{ COMMANDS WITH COMPRESSED FILES

  ZIP COMPRESS -> EMBEDDED
  ZIP DECOMPRESS -> EMBEDDED
  ZIP DELETE -> EMBEDDED

  RAR COMPRESS -> COMMAND
  RAR DECOMPRESS -> COMMAND
  RAR DELETE -> COMMAND

  7Z COMPRESS -> COMMAND
  7Z DECOMPRESS -> COMMAND
  7Z DELETE -> COMMAND

}

procedure TFmain.scandirectory(path, mask: widestring;action:integer;brec:boolean);
var
FileSearch:  TSearchRecW;
begin
path:=checkpathbar(path);

try

WideSetCurrentDir(path);//WILL MAKE EXCEPTION ON PROTECTED FOLDERS
                                     //fahidden 0.032
if wideFindFirst(mask, faDirectory or fahidden, FileSearch)=0 then
repeat
  if ( (FileSearch.Attr and fadirectory) = fadirectory) then begin  //0.033 MUST FIX SYSTEM ZIP AS FOLDER BUG

    if  (FileSearch.Name <> '.') and (FileSearch.Name <> '..') then //FOLDER

      if brec=true then begin

        if (action=2) OR (action=5) then begin //WRITE LIST OF FILES/FOLDERS

            //0.028
            if (action=2) then
              if formexists('Fscan') then begin //FROM SCAN
                if Fscan.checkstop=true then
                  makeexception;
              end
              else
              if formexists('Fprocessing') then
                if Fprocessing.Tag=1 then
                  makeexception;//FROM BUILDER

            listfiles.Writeln(path+FileSearch.Name+'\');
            romscounter:=romscounter+1;
            scandirectory(path+FileSearch.Name+'\',mask,action,brec)

        end
        else
        if action=1 then begin //DELETE FILES
          if IsDirectoryEmpty(path+FileSearch.Name+'\') then begin
            try
              WideRemoveDir(Pwidechar(path+FileSearch.Name+'\'));
            except
            end;
          end
          else
            scandirectory(path+FileSearch.Name+'\',mask,action,brec);
        end
        else begin //IMPORT DATS

          if (decision<>2) AND (decision<>-1) then
            decision:=mymessagequestion(traduction(49)+' '+path+FileSearch.Name+'\',true);

          if (decision=1) OR (decision=2) then
            scandirectory(path+FileSearch.Name+'\',mask,action,brec);

          if (decision=-1) OR (decision=0)  then
            brec:=false;

        end;
      end//BREC
      else
      if action=5 then begin //WRITE LIST OF FILES/FOLDERS
        listfiles.Writeln(path+FileSearch.Name+'\');
        romscounter:=romscounter+1;
      end;
  end
  else begin //FILE

    case action of
      0:processnewdat(path+FileSearch.Name);  //IMPORT DATS
      1:begin  //DELETE FILES
          deletefile2(path+FileSearch.Name);
          if IsDirectoryEmpty(path) then begin //0.028
            WideSetCurrentDir('..');
            WideRemoveDir(Pwidechar(path));
          end;
        end;
      2:begin  //ROMS COUNTER

          //0.028
          if (action=2) then
            if formexists('Fscan') then begin //FROM SCAN
              if Fscan.checkstop=true then
                makeexception;
            end
            else
            if formexists('Fprocessing') then
              if Fprocessing.Tag=1 then
                makeexception;//FROM BUILDER

          listfiles.Writeln(path+FileSearch.Name);
          romscounter:=romscounter+1;
          currentset:=path+FileSearch.Name;
        end;
      3:begin //T7Z
          if sevenzipvalidfile(path+FileSearch.Name,sevenzip1) then
            writelist.Add(UTF8Encode(path+FileSearch.Name)); //FORZED TO UTF8 ONLY FOR T7Z
        end;
      4:begin //HEADERS
        try
          Fscan.ComboBox1.Items.Add(FileSearch.Name);
        except
        end;

        end;
    end;

  end;
until WideFindNext( FileSearch ) <> 0;

WideFindClose(FileSearch);

except
end;

unlocksearchfolder;//0.046
end;

procedure Tfmain.initializeextractionfolders();
begin
lastextracted1:='';
lastextracted2:='';

if WideDirectoryExists(tempdirectoryextractvar+'EXT\') then
  Scandirectory(tempdirectoryextractvar+'EXT\','*.*',1,true);

if WideDirectoryExists(tempdirectoryextractvar+'1\') then
  Scandirectory(tempdirectoryextractvar+'1\','*.*',1,true);

if WideDirectoryExists(tempdirectoryextractvar+'2\') then
  Scandirectory(tempdirectoryextractvar+'2\','*.*',1,true);


try
if zip2.Tag=1 then
  zip2.CloseArchive;
except
end;

zip2.Tag:=0;
end;

//Componentname+Zippedfilename+fileinsidezipped+realextractionpath+varfortempextractionpathhack
function Tfmain.extractmethodhack(nam:string;filenam:widestring;fileinside:widestring;extractpath:widestring;var tpath:widestring;reuse:boolean):boolean;
var
s:string;
tocheck,res:boolean;
begin
res:=false;
tocheck:=false;

s:=nam[length(nam)];
tpath:=tempdirectoryextractvar+s+'\';
WideForceDirectories(tpath);

//Check if is already extracted
if s='1' then begin
  if lastextracted1=filenam then
    tocheck:=true;

  lastextracted1:=filenam;
end
else
if s='2' then begin
  if lastextracted2=filenam then
    tocheck:=true;

  lastextracted2:=filenam;
end;

if tocheck=true then
  if reuse=true then
    res:=copyfile2(tpath+fileinside,extractpath+WideExtractFileName(fileinside))
  else
    res:=movefile2(tpath+fileinside,extractpath+WideExtractFileName(fileinside));

if res=false then //Delete all possible extracted files
  Scandirectory(tpath,'*.*',1,true);

Result:=res;
end;

function Tfmain.extractfilefromzip(z:Tzipforge;fileinside:widestring;extractpath:widestring;reuse:boolean):boolean;
var
res:boolean;
xpath,respath,cad:widestring;
f:textfile;
begin
res:=false;

z.Options.CreateDirs:=true;

//NEW HACK METHOD 0.028
if extractmethodhack(z.name,z.filename,fileinside,extractpath,xpath,reuse)=true then begin
  result:=true;
  exit;
end;

try
  if z.Tag=0 then begin
    z.OpenArchive(fmOpenRead);
    //z.OpenArchive(fmOpenReadWrite); //Erazor fix
    z.tag:=1;
  end;

  z.BaseDir:=xpath;
  z.ExtractFiles('*.*');

  if reuse=true then
    res:=copyfile2(xpath+fileinside,extractpath+WideExtractFileName(fileinside))
  else
    res:=movefile2(xpath+fileinside,extractpath+WideExtractFileName(fileinside));

except  //ERROR = CHANGE EXTRACT METHOD
  z.CloseArchive;

  respath:=mameoutpath;
  deletefile2(respath);

  RunAndWaitShell('"'+Ansitoutf8(sevenzippath)+'"','x "'+UTF8Encode(z.filename)+'" -aoa -pxxx -o"'+UTF8Encode(xpath)+'" -i!"*" -r',0,true,false);

  try //CHECK RESULTS

    assignfile(f,respath);
    Reset(f);
    while not eof(f) do begin

      readln(f,cad);

      if cad='Everything is Ok' then begin
        res:=movefile2(xpath+fileinside,extractpath+WideExtractFileName(fileinside));
        break;
      end;

    end;
  except
  end;

  try
    closefile(f);
  except
  end;

  deletefile2(respath);

  try
    if z.tag=1 then
      z.OpenArchive(fmOpenRead)//REOPEN AGAIN
    else
    if z.Tag=2 then
      z.OpenArchive(fmOpenReadWrite)//REOPEN AGAIN
  except
  end;
end;

if z.tag=0 then
  z.CloseArchive;

Result:=res;
end;

function Tfmain.extractfilefromsevenzip(sevenzip:Tsevenzip;fileinside:widestring;extractpath:widestring;reuse:boolean):boolean;
var
res:boolean;
f:textfile;
cad,respath,destfile,xpath:widestring;
szfil:widestring;
begin
res:=false;

//0.043 FIX
if sevenzip.Name='SevenZip1' then
  szfil:=sevenzip1filename
else
  szfil:=sevenzip2filename;

//NEW HACK METHOD 0.028
if extractmethodhack(sevenzip.name,szfil,fileinside,extractpath,xpath,reuse)=true then begin
  result:=true;
  exit;
end;

respath:=mameoutpath;
deletefile2(respath);

//FIXES EXTRACTPATH IS ALWAYS C:\TMP OR WINTEMPDIR
destfile:=extractpath+WideExtractFileName(fileinside);
                                                 //com=e or x
RunAndWaitShell('"'+Ansitoutf8(changein(sevenzippath,'%','%%'))+'"','x "'+UTF8Encode(changein(szfil,'%','%%'))+'" -aoa -pxxx -o"'+UTF8Encode(changein(xpath,'%','%%'))+'" -i!"*" -r',0,true,false);

//Check all is correct
try
  assignfile(f,respath);
  Reset(f);
  while not eof(f) do begin

    readln(f,cad);

    if cad='Everything is Ok' then begin

      if reuse=true then
        res:=copyfile2(xpath+fileinside,extractpath+WideExtractFileName(fileinside))
      else
        res:=movefile2(xpath+fileinside,extractpath+WideExtractFileName(fileinside));

      break;

    end;
  end;
except
end;

try
  closefile(f);
except
end;

deletefile2(respath);

Result:=res;
end;

function Tfmain.extractfilefromrar(rar:Trar;fileinside:widestring;extractpath:widestring;reuse:boolean):boolean;
var
res:boolean;
respath,cad:ansistring;
rarfile,destfile:widestring;
xpath:widestring;
f:textfile;
begin
res:=false;

if rar.Name='RAR1' then begin
  rarfile:=rar1filename;
end
else
if rar.Name='RAR2' then begin
  rarfile:=rar2filename;
end;

//NEW HACK METHOD 0.028
if extractmethodhack(rar.name,rarfile,fileinside,extractpath,xpath,reuse)=true then begin
  result:=true;
  exit;
end;

//FIXES EXTRACTPATH IS ALWAYS C:\TMP OR WINTEMPDIR
destfile:=extractpath+gettoken(fileinside,'\',gettokencount(fileinside,'\'));

try
  //rarfile utf8broken                                                                                          //-o+ Overwrite
  RunAndWaitShell('"'+Ansitoutf8(changein(rarpath,'%','%%'))+'"','x "'+UTF8Encode(changein(rarfile,'%','%%'))+'" "*.*" "'+UTF8Encode(changein(xpath,'%','%%'))+'"  -o+ -p-',0,true,false);

  respath:=mameoutpath;

  try
    assignfile(f,respath);
    reset(f);
    while not eof(f) do begin

      readln(f,cad);

      if cad='All OK' then begin

        if reuse=true then
          res:=copyfile2(xpath+fileinside,extractpath+WideExtractFileName(fileinside))
        else
          res:=movefile2(xpath+fileinside,extractpath+WideExtractFileName(fileinside));

        break;
      end;
    end;
  except
  end;

  try
    closefile(f);
  except
  end;

except
end;

deletefile2(respath);

Result:=res;
end;

function Tfmain.addfiletozip(frompath,filename,zipfilename:widestring;level:smallint;realcrc,realspace:string):boolean;
var
res:boolean;
w:widestring;
i:integer;
begin
res:=false;

try

if fileexists2(filename) then begin

  try
    //WideFileSetAttr(filename,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  case level of
    0:zip2.CompressionLevel:=clNone;
    1..5:zip2.CompressionLevel:=clFastest;
    6..8:zip2.CompressionLevel:=clNormal;
  else
    zip2.CompressionLevel:=clmax;
  end;

  if zipvalidfile(zipfilename,zip2)=false then
    if FileExists2(zipfilename)=false then begin
      zip2.FileName:=zipfilename;
      try
        zip2.OpenArchive(fmCreate);//Erazor
        zip2.tag:=1;
      except
        makeexception;
      end;
    end
    else
      makeexception;

  if zip2.Tag<>2 then begin //Erazor fix
    zip2.OpenArchive(fmOpenReadWrite);
    zip2.Tag:=2;
  end;

  zip2.BaseDir:=frompath;
  zip2.AddFiles(filename);

  res:=true;

  //0.028 SPEED HACK
  w:=copy(filename,length(frompath)+1,length(filename));
  
  //0.032 IF EXISTS IS OVERWRITED
  i:=stcompfiles2.IndexOf(w);
  if i<>-1 then begin
    stcompfiles2.Delete(i);
    stcompcrcs2.delete(i);
    stcompsizes2.delete(i);
  end;

  stcompfiles2.Add(w);
  i:=stcompfiles2.IndexOf(w);
  stcompsizes2.Add(realspace);
  stcompcrcs2.Add(realcrc);
  stcompsizes2.Move(stcompsizes2.Count-1,i);
  stcompcrcs2.Move(stcompcrcs2.Count-1,i);
end;

except
  res:=false;
end;

Result:=res;
end;

function Tfmain.addfiletorar(frompath,filename,rarfilename:widestring;level:smallint;realcrc,realspace:string):boolean;
var
res:boolean;
respath,cad,cad2:widestring;
f:textfile;
w:widestring;
listpath:ansistring;
tntwidelist:TTntStringList;
i:integer;
begin
cad:='';
cad2:='';
res:=false;
respath:=mameoutpath;
listpath:=tempdirectoryresources+'rar.rmt';

case level of
  0:level:=0;
  1..2:level:=1;
  3..4:level:=2;
  5..6:level:=3;
  7..8:level:=4;
  9:level:=5;
  else
    level:=5;
end;

tntwidelist:=TTntStringList.Create;

if FileExists2(filename) then begin

  try
    WideFileSetAttr(filename,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  try
    WideFileSetAttr(rarfilename,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  frompath:=checkpathbar(frompath);
  deletefile2(respath);
  cad:=copy(filename,length(frompath)+1,length(wideextractfilepath(filename))-length(frompath));
  if cad<>'' then
    cad:='-ap"'+cad+'"';

  cad:=changein(cad,'%','%%');

  try
    tntwidelist.Add(filename);
    tntwidelist.SaveToFile(listpath);

    if solidcomp=false then
      cad2:=' -s-';

    if userar5=true then
      cad2:=cad2+' -ma';

    if (multicpu=true) AND (getcpunumcores>1) then
      cad2:=cad2+' -mt'+inttostr(getcpunumcores);

    //test -mt(Threads) = multithread
    //-s-  remove solid archive

    RunAndWaitShell('"'+AnsiToUtf8(changein(rarpath,'%','%%'))+'"','a -m'+inttostr(level)+UTF8Encode(cad2)+' '+UTF8Encode(cad)+' -ep1 "'+UTF8Encode(changein(rarfilename,'%','%%'))+'" "@'+UTF8Encode(changein(listpath,'%','%%'))+'"',0,true,false);

    deletefile(listpath);
  
    try

      assignfile(f,respath);
      reset(f);
      while not eof(f) do begin
        readln(f,cad);
        if cad='Done' then begin
          res:=true;

          //0.028 SPEED HACK
          w:=copy(filename,length(frompath)+1,length(filename));

          //0.032 IF EXISTS IS OVERWRITED
          i:=stcompfiles2.IndexOf(w);
          if i<>-1 then begin
            stcompfiles2.Delete(i);
            stcompcrcs2.delete(i);
            stcompsizes2.delete(i);
          end;

          stcompfiles2.Add(w);
          i:=stcompfiles2.IndexOf(w);
          stcompsizes2.Add(realspace);
          stcompcrcs2.Add(realcrc);
          stcompsizes2.Move(stcompsizes2.Count-1,i);
          stcompcrcs2.Move(stcompcrcs2.Count-1,i);
          lastcompdate2:=WideFileAge2(rarfilename);

          break;
        end;
      end;
    except
    end;

  except
  end;

end;

try
  closefile(f);
except
end;

deletefile2(respath);

tntwidelist.Free;

Result:=res;
end;

//USE ALT 7zBINARY
function Tfmain.addfiletosevenzip_ALT(frompath,filename,sevenzipfilename:widestring;level:smallint;realcrc,realspace:string):boolean;
var
res:boolean;
f:textfile;
cad,cad2,respath:ansistring;
i:integer;
w:widestring;
begin
res:=false;
respath:=mameoutpath;
deletefile2(respath);
frompath:=checkpathbar(frompath);

if FileExists2(filename) then begin

  try
    WideFileSetAttr(filename,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  try
    WideFileSetAttr(sevenzipfilename,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  if (multicpu=true) AND (getcpunumcores>1) then
    cad:='-mmt=on '
  else
    cad:='-mmt=off ';

  if solidcomp=true then
    cad2:='-ms=on '
  else
    cad2:='-ms=off ';
                                                        //-mcu=on UTF8?
  RunAndWaitShell('"'+AnsiToUtf8(changein(sevenzipdelpath,'%','%%'))+'"','a '+cad2+cad+' -mx'+inttostr(level)+' "'+UTF8Encode(changein(sevenzipfilename,'%','%%'))+'" -ir!"'+UTF8Encode(changein(frompath+wideextractfilename(filename),'%','%%'))+'"',0,true,false);

//Check all is correct
  try
    assignfile(f,respath);
    Reset(f);
    while not eof(f) do begin
      readln(f,cad);
      if cad='Everything is Ok' then begin
        res:=true;

        //0.028 SPEED HACK
        w:=copy(filename,length(frompath)+1,length(filename));

        //0.032 IF EXISTS IS OVERWRITED
        i:=stcompfiles2.IndexOf(w);
        if i<>-1 then begin
          stcompfiles2.Delete(i);
          stcompcrcs2.delete(i);
          stcompsizes2.delete(i);
        end;

        stcompfiles2.Add(w);
        i:=stcompfiles2.IndexOf(w);
        stcompsizes2.Add(realspace);
        stcompcrcs2.Add(realcrc);
        stcompsizes2.Move(stcompsizes2.Count-1,i);
        stcompcrcs2.Move(stcompcrcs2.Count-1,i);
        lastcompdate2:=WideFileAge2(sevenzipfilename);

        break;
      end;
    end;
  except
  end;

  try
    closefile(f);
  except
  end;

end;

deletefile2(respath);

Result:=res;
end;

function Tfmain.addfiletosevenzip(frompath,filename,sevenzipfilename:widestring;level:smallint;realcrc,realspace:string):boolean;
var
res:boolean;
f:textfile;
cad,cad2,respath:ansistring;
i:integer;
w:widestring;
begin
res:=false;
respath:=mameoutpath;
deletefile2(respath);
frompath:=checkpathbar(frompath);

if FileExists2(filename) then begin

  try
    WideFileSetAttr(filename,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  try
    WideFileSetAttr(sevenzipfilename,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  if (multicpu=true) AND (getcpunumcores>1) then
    cad:='-mmt=on '
  else
    cad:='-mmt=off ';

  if solidcomp=true then
    cad2:='-ms=on '
  else
    cad2:='-ms=off ';

  RunAndWaitShell('"'+AnsiToUtf8(changein(sevenzippath,'%','%%'))+'"','a '+cad2+cad+' -mx'+inttostr(level)+' "'+UTF8Encode(changein(sevenzipfilename,'%','%%'))+'" -ir!"'+UTF8Encode(changein(frompath+wideextractfilename(filename),'%','%%'))+'"',0,true,false);

//Check all is correct
  try
    assignfile(f,respath);
    Reset(f);
    while not eof(f) do begin
      readln(f,cad);
      if cad='Everything is Ok' then begin
        res:=true;

        //0.028 SPEED HACK
        w:=copy(filename,length(frompath)+1,length(filename));

        //0.032 IF EXISTS IS OVERWRITED
        i:=stcompfiles2.IndexOf(w);
        if i<>-1 then begin
          stcompfiles2.Delete(i);
          stcompcrcs2.delete(i);
          stcompsizes2.delete(i);
        end;

        stcompfiles2.Add(w);
        i:=stcompfiles2.IndexOf(w);
        stcompsizes2.Add(realspace);
        stcompcrcs2.Add(realcrc);
        stcompsizes2.Move(stcompsizes2.Count-1,i);
        stcompcrcs2.Move(stcompcrcs2.Count-1,i);
        lastcompdate2:=WideFileAge2(sevenzipfilename);

        break;
      end;
    end;
  except
  end;

  try
    closefile(f);
  except
  end;

end;


deletefile2(respath);

if res=false then //0.037
  res:=addfiletosevenzip_ALT(frompath,filename,sevenzipfilename,level,realcrc,realspace);

Result:=res;
end;

function Tfmain.deletefilefromzip(zip:Tzipforge;path:widestring):boolean;
var
res:boolean;
i:integer;
begin
//ALWAYS DELETE IN ZIP1
Result:=false;
res:=false;

//0.028  TAG=0 CLOSE WHEN DONE
try

  //JUMP MULTIVOLUME ARCHIVES
  if ((zip.Name='Zip1') AND (zip1multivolume=true)) OR ((zip.Name='Zip2') AND (zip2multivolume=true)) then begin
    zip.CloseArchive;
    exit;
  end;

  if realcompressedfilecount=1 then begin

    zip.CloseArchive;
    zip.Tag:=0;

    result:=deletefile2(zip.FileName);
    exit;
  end;

  try
    WideFileSetAttr(zip.FileName,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  if zip.Tag<>2 then begin //Erazor
    zip.OpenArchive(fmOpenReadWrite);
    zip.Tag:=2;
  end;

  try

    zip.DeleteFiles(path);
    res:=true;

    if zip.Name='Zip1' then begin
      i:=stcompfiles.IndexOf(path);
      if i<>-1 then begin
        stcompfiles.Delete(i);
        stcompcrcs.Delete(i);
        stcompsizes.Delete(i);
        realcompressedfilecount:=realcompressedfilecount-1;
      end;
    end
    else //0.032
    if zip.Name='Zip2' then begin
      i:=stcompfiles2.IndexOf(path);
      if i<>-1 then begin
        stcompfiles2.Delete(i);
        stcompcrcs2.Delete(i);
        stcompsizes2.Delete(i);
      end;
    end;

  except

  end;


except
end;

if zip.Tag=0 then
  zip.CloseArchive;


Result:=res;
end;

function Tfmain.deletefilefromrar(rar:Trar;path:widestring):boolean;
var
f:textfile;
res:boolean;
cad:ansistring;
listpath:widestring;
respath:widestring;
i:integer;
tntwidelist:TTntStringList;
begin
//ALWAYS DELETE IN RAR1
res:=false;

listpath:=tempdirectoryresources+'rar.rmt';

if rar.ArchiveInformation.MultiVolume=False then begin

  respath:=rar1filename;

  if realcompressedfilecount=1 then begin
    result:=deletefile2(respath);
    exit;
  end;

  tntwidelist:=TTntStringList.Create;

  try
    WideFileSetAttr(respath,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  try
    tntwidelist.Add(path);
    tntwidelist.SaveToFile(listpath);

    RunAndWaitShell('"'+Ansitoutf8(changein(rarpath,'%','%%'))+'"','d'+' "'+UTF8Encode(changein(respath,'%','%%'))+'" "@'+UTF8Encode(changein(listpath,'%','%%'))+'"',0,true,false);
    deletefile2(listpath);

    try
      assignfile(f,mameoutpath);
      reset(f);
      while not eof(f) do begin
        readln(f,cad);
        if cad='Done' then begin
          res:=true;

          if rar.Name='RAR1' then begin
            i:=stcompfiles.IndexOf(path);
            if i<>-1 then begin
              stcompfiles.Delete(i);
              stcompcrcs.Delete(i);
              stcompsizes.Delete(i);
              realcompressedfilecount:=realcompressedfilecount-1;
            end;
          end
          else //0.032
          if rar.Name='RAR2' then begin
            i:=stcompfiles2.IndexOf(path);
            if i<>-1 then begin
              stcompfiles2.Delete(i);
              stcompcrcs2.Delete(i);
              stcompsizes2.Delete(i);
            end;
          end;

          break;
        end;
      end;
    except
    end;

  except
  end;

  tntwidelist.free;

  try
    closefile(f);
  except
  end;

end;

Result:=res;
end;

function Tfmain.deletefilefromsevenzip_ALT(sevenzip:Tsevenzip;path:widestring):boolean;
var
f:textfile;
res:boolean;
i:integer;
respath:widestring;
cad:ansistring;
begin
res:=false;
respath:=mameoutpath;

if sevenzip.Ismultidisk=false then begin

  if realcompressedfilecount=1 then begin
    result:=deletefile2(sevenzip.SZFileName);
    exit;
  end;

  try
    WideFileSetAttr(sevenzip.SZFileName,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  //0.037 CHANGED USING 9.20 version no problems deleting
  //RunAndWaitShell('"'+UTF8Encode(sevenzippath)+'"','d'+' "'+UTF8Encode(sevenzip.SZFileName)+'" -i!"'+UTF8Encode(path)+'"',0,true,false);
  RunAndWaitShell('"'+Ansitoutf8(changein(sevenzipdelpath,'%','%%'))+'"','d'+' "'+UTF8Encode(changein(sevenzip.SZFileName,'%','%%'))+'" -i!"'+UTF8Encode(changein(path,'%','%%'))+'"',0,true,false);

  try
    assignfile(f,respath);
    reset(f);
    while not eof(f) do begin
      readln(f,cad);
      if cad='Everything is Ok' then begin
        res:=true;

        if sevenzip.Name='SevenZip1' then begin
          i:=stcompfiles.IndexOf(path);
          if i<>-1 then begin
            stcompfiles.Delete(i);
            stcompcrcs.delete(i);
            stcompsizes.delete(i);
            realcompressedfilecount:=realcompressedfilecount-1;
          end;
        end
        else  //0.032
        if sevenzip.Name='SevenZip2' then begin
          i:=stcompfiles2.IndexOf(path);
          if i<>-1 then begin
            stcompfiles2.Delete(i);
            stcompcrcs2.delete(i);
            stcompsizes2.delete(i);
          end;
        end;

        break;
      end;
    end;

  except
  end;

end;//MULTIVOLUME

try
  closefile(f);
except
end;

Result:=res;
end;

function Tfmain.deletefilefromsevenzip(sevenzip:Tsevenzip;path:widestring):boolean;
var
f:textfile;
res:boolean;
i:integer;
respath:widestring;
cad:ansistring;
begin
res:=false;
respath:=mameoutpath;

if sevenzip.Ismultidisk=false then begin

  if realcompressedfilecount=1 then begin
    result:=deletefile2(sevenzip.SZFileName);
    exit;
  end;

  try
    WideFileSetAttr(sevenzip.SZFileName,faArchive);//IF READONLY THEN READ AND WRITE
  except
  end;

  //0.037 CHANGED USING 9.20 version no problems deleting
  //RunAndWaitShell('"'+UTF8Encode(sevenzippath)+'"','d'+' "'+UTF8Encode(sevenzip.SZFileName)+'" -i!"'+UTF8Encode(path)+'"',0,true,false);
  RunAndWaitShell('"'+Ansitoutf8(changein(sevenzipdelpath,'%','%%'))+'"','d'+' "'+UTF8Encode(changein(sevenzip.SZFileName,'%','%%'))+'" -i!"'+UTF8Encode(changein(path,'%','%%'))+'"',0,true,false);

  try
    assignfile(f,respath);
    reset(f);
    while not eof(f) do begin
      readln(f,cad);
      if cad='Everything is Ok' then begin
        res:=true;

        if sevenzip.Name='SevenZip1' then begin
          i:=stcompfiles.IndexOf(path);
          if i<>-1 then begin
            stcompfiles.Delete(i);
            stcompcrcs.delete(i);
            stcompsizes.delete(i);
            realcompressedfilecount:=realcompressedfilecount-1;
          end;
        end
        else  //0.032
        if sevenzip.Name='SevenZip2' then begin
          i:=stcompfiles2.IndexOf(path);
          if i<>-1 then begin
            stcompfiles2.Delete(i);
            stcompcrcs2.delete(i);
            stcompsizes2.delete(i);
          end;
        end;

        break;
      end;
    end;

  except
  end;

end;//MULTIVOLUME

try
  closefile(f);
except
end;

if res=false then
  res:=deletefilefromsevenzip_ALT(sevenzip,path);

Result:=res;
end;

procedure TFmain.waitforfinishthread;
begin
While BMDThread1.Runing=true do
  application.HandleMessage; //SEEMS SPEED UP 0.019

end;

procedure TFmain.speedupdb;
var
x:integer;
begin

for x:=0 to Datamodule1.ComponentCount-1 do
  if Datamodule1.Components[x] is TABSTable then begin
    if (Datamodule1.Components[x] as TABSTable).Tag=0 then
      (Datamodule1.Components[x] as TABSTable).DisableControls;  //Tscansets and Tscanroms not in disablecontrols. With new ABS version fix it?
  end
  else
  if Datamodule1.Components[x] is Tabsquery then begin
    if (uppercase((Datamodule1.Components[x] as Tabsquery).DatabaseName)<>'DBMYQUERYS') AND (uppercase((Datamodule1.Components[x] as Tabsquery).DatabaseName)<>'DBPEERS') AND (uppercase((Datamodule1.Components[x] as Tabsquery).DatabaseName)<>'DBSERVERS') then
      (Datamodule1.Components[x] as Tabsquery).RequestLive:=true
    else begin
      if uppercase((Datamodule1.Components[x] as Tabsquery).name)='QMYQUERYSVIEW' then
        (Datamodule1.Components[x] as Tabsquery).RequestLive:=true;
    end;

    (Datamodule1.Components[x] as Tabsquery).DisableControls;
  end
  else
  if Datamodule1.Components[x] is TABSDatabase then begin
    (Datamodule1.Components[x] as TABSDatabase).MaxConnections:=defmaxconnections;//CHANGE FROM 1 to 500 IS NORMAL DEFAULT
    (Datamodule1.Components[x] as TABSDatabase).SilentMode:=true;
    (Datamodule1.Components[x] as TABSDatabase).MultiUser:=false;//MAYBE CHANGED TO TRUE IF MORE PROBLEMS
  end;

end;

function Tfmain.getdbid():string;
begin
if Datamodule1.TDirectories.Locate('Profile',-1,[])=false then begin
  Datamodule1.TDirectories.append;
  Datamodule1.Tdirectories.fieldbyname('Profile').asinteger:=-1;
  DataModule1.TDirectories.FieldByName('Path').AsString:=inttohex(DateTimeToFileDate(now),8);
  DataModule1.TDirectories.FieldByName('Type').asstring:='C';//Cache
  DataModule1.TDirectories.FieldByName('Compression').asinteger:=0;
  Datamodule1.TDirectories.Post;
end;

result:=Datamodule1.TDirectories.fieldbyname('Path').AsString;
end;

procedure Tfmain.traductfmain;
var
x:integer;
n:TTnttreenode;
aux:widestring;
begin

if treeview1.Items.Count>1 then begin
  n:=treeview1.Items.Item[0];
  n.Text:='<  '+traduction(36)+'  >';
  n:=treeview1.Items.Item[1];
  n.text:='<  '+traduction(37)+'  >';
end;

speedbutton2.Hint:=traduction(1);
speedbutton11.Hint:=traduction(2);
speedbutton13.Hint:=traduction(3);
speedbutton7.Hint:=traduction(118);
speedbutton32.Hint:=traduction(163);


(Pagecontrol1.Pages[0] as TTntTabSheet).Caption:=traduction(4);
(Pagecontrol1.Pages[1] as TTntTabSheet).Caption:=traduction(5);
(Pagecontrol1.Pages[2] as TTntTabSheet).Caption:=traduction(7);
(Pagecontrol1.Pages[3] as TTntTabSheet).Caption:=traduction(449);
(Pagecontrol1.Pages[4] as TTntTabSheet).Caption:=traduction(6);
(Pagecontrol1.Pages[5] as TTntTabSheet).Caption:=traduction(8);
(Pagecontrol1.Pages[6] as TTntTabSheet).Caption:=traduction(314);
(Pagecontrol1.Pages[7] as TTntTabSheet).Caption:=traduction(9);
(Pagecontrol1.Pages[8] as TTntTabSheet).Caption:=traduction(250);

label1.Caption:=traduction(10);
labelshadow(label1,Fmain);
label2.Caption:=traduction(10);
labelshadow(label2,Fmain);
label3.Caption:=traduction(10);
labelshadow(label3,Fmain);
label4.Caption:=traduction(100);
Fmain.labelshadow(label4,Fmain);
label5.Caption:=traduction(255)+' :';
label6.Caption:=traduction(256)+' :';

combobox1.items.clear;
combobox1.Enabled:=false;

speedbutton17.Caption:=traduction(4);

VirtualStringTree2.Header.Columns[0].text:=traduction(11);
VirtualStringTree2.Header.Columns[1].text:=traduction(12);
VirtualStringTree2.Header.Columns[2].text:=traduction(13);
VirtualStringTree2.Header.Columns[3].text:=traduction(14);
VirtualStringTree2.Header.Columns[4].text:=traduction(276);
VirtualStringTree2.Header.Columns[5].text:=traduction(512);
VirtualStringTree2.Header.Columns[6].text:=traduction(20);
VirtualStringTree2.Header.Columns[7].text:=traduction(21);
VirtualStringTree2.Header.Columns[8].text:=traduction(22);
VirtualStringTree2.Header.Columns[9].text:=traduction(219);

speedbutton1.Hint:=traduction(26);
speedbutton3.Hint:=traduction(27);
speedbutton4.Hint:=traduction(28);
speedbutton5.Hint:=traduction(29);

//POPUP TREEVIEW
Addsection1.Caption:=UTF8Encode(traduction(31));
Editsection1.Caption:=UTF8Encode(traduction(32));
Deletesection1.Caption:=UTF8Encode(traduction(33));
Activaterecursive1.Caption:=UTF8Encode(traduction(190));
Expandall1.Caption:=UTF8Encode(traduction(34));
Collapseall1.Caption:=UTF8Encode(traduction(35));

//POPUP PROFILES LIST
adddats1.Caption:=UTF8Encode(traduction(1));
Loadselectedprofiles1.Caption:=UTF8Encode(traduction(38));
Batchrunselectedprofiles1.Caption:=UTF8Encode(traduction(39));
Rebuildall1.Caption:=UTF8Encode(traduction(164));
Sendtogenerator1.Caption:=UTF8Encode(traduction(389));
Dirmaker1.Caption:=UTF8Encode(traduction(394));
friendfix1.Caption:=UTF8Encode(traduction(508));
createxmldat1.Caption:=UTF8Encode(traduction(589));
Options1.Caption:=UTF8Encode(traduction(137));
Jumptoprofiledirectory1.Caption:=UTF8Encode(traduction(379));
Community1.Caption:=UTF8Encode(traduction(314));
copytoclipboard4.Caption:=UTF8Encode(traduction(627));
delete1.Caption:=UTF8Encode(traduction(33));
Selectall1.Caption:=UTF8Encode(traduction(40));
Invertselection1.Caption:=UTF8Encode(traduction(41));
Properties1.Caption:=UTF8Encode(traduction(42));
setbackupfolder1.Caption:=UTF8Encode(traduction(139));
Setmd51.Caption:=UTF8Encode(traduction(144));
Setsha11.Caption:=UTF8Encode(traduction(145));
Settz1.Caption:=UTF8Encode(traduction(146));
Sett7z1.Caption:=UTF8Encode(traduction(366));
activate1.Caption:=UTF8Encode(traduction(560));
activate2.Caption:=UTF8Encode(traduction(560));
activate3.Caption:=UTF8Encode(traduction(560));
activate4.Caption:=UTF8Encode(traduction(560));
deactivate1.Caption:=UTF8Encode(traduction(561));
deactivate2.Caption:=UTF8Encode(traduction(561));
deactivate3.Caption:=UTF8Encode(traduction(561));
deactivate4.Caption:=UTF8Encode(traduction(561));
Shareselected1.Caption:=UTF8Encode(traduction(510));
Unshareselected1.Caption:=UTF8Encode(traduction(511));
Sendmissingtorequestlist1.Caption:=UTF8Encode(traduction(522));

//POPUP TRAY
Stayontop1.Caption:=UTF8Encode(traduction(43));
Staynormal1.Caption:=UTF8Encode(traduction(44));
Applicationpriority1.Caption:=UTF8Encode(traduction(45));
High1.Caption:=UTF8Encode(traduction(46));
normal1.Caption:=UTF8Encode(traduction(47));
low1.Caption:=UTF8Encode(traduction(48));
Hide1.Caption:=UTF8Encode(traduction(152));
Community2.Caption:=UTF8Encode(traduction(314));

//POPUP GENERATOR
Checkselected1.Caption:=UTF8Encode(traduction(343));
Uncheckselected1.Caption:=UTF8Encode(traduction(344));
Selectall3.Caption:=UTF8Encode(traduction(40));
Invertselection3.Caption:=UTF8Encode(traduction(41));
Expandall2.Caption:=UTF8Encode(traduction(34));
Collapseall2.Caption:=UTF8Encode(traduction(35));
copytoclipboard3.Caption:=UTF8Encode(traduction(627));
//POPUP UP SCANNER LIST WARNING EMULATORS LIST AND ROM1 SAMPLE1 AND CHD1 ENCODE
Setemulator1.Caption:=UTF8Encode(traduction(287));
Goto1.Caption:=UTF8Encode(traduction(482));
Extractto1.Caption:=UTF8Encode(traduction(483));
Sendtorequests1.Caption:=UTF8Encode(traduction(522));
Copytoclipboard2.Caption:=UTF8Encode(traduction(627));
Smartsearchingoogle1.Caption:=UTF8Encode(traduction(463));
Copytoclipboard1.Caption:=UTF8Encode(traduction(627));
Selectall2.Caption:=UTF8Encode(traduction(40));
Invertselection2.Caption:=UTF8Encode(traduction(41));
directory1.Caption:=UTF8Encode(traduction(101));
directory3.Caption:=UTF8Encode(traduction(101));
desktop1.Caption:=UTF8Encode(traduction(485));
desktop3.Caption:=UTF8Encode(traduction(485));
Copyto1.Caption:=UTF8Encode(traduction(624));
Makedirectoriesbycompressedfile1.Caption:=UTF8Encode(traduction(484));
Configureemu1.Caption:=UTF8Encode(traduction(277));
Description1.Caption:=UTF8Encode(traduction(11));
Filename1.Caption:=UTF8Encode(traduction(101));

//POPUP DOWN SCANNER LIST
Extractto2.Caption:=UTF8Encode(traduction(483));
desktop2.Caption:=UTF8Encode(traduction(485));
directory2.Caption:=UTF8Encode(traduction(101));
Smartsearchingoogle2.Caption:=UTF8Encode(traduction(463));
Sendmissingtorequest1.caption:=UTF8Encode(traduction(522));
Filename2.caption:=UTF8Encode(traduction(151));
Selectall5.Caption:=UTF8Encode(traduction(40));
Invertselection4.caption:=UTF8Encode(traduction(41));
CRC321.Caption:=UTF8Encode(traduction(153));
MD51.Caption:=UTF8Encode(traduction(154));
SHA11.Caption:=UTF8Encode(traduction(155));

//POPUP TABS
Newtab1.Caption:=UTF8Encode(traduction(454));
jumptodir1.Caption:=UTF8Encode(traduction(379));
Gotofirst1.Caption:=UTF8Encode(traduction(390));
gotolast1.Caption:=UTF8Encode(traduction(391));
share1.Caption:=UTF8Encode(traduction(510));
unshare1.Caption:=UTF8Encode(traduction(511));
sendtorequest1.Caption:=UTF8Encode(traduction(522));
close1.Caption:=UTF8Encode(traduction(116));

//POPUP WEBBROWSER
Openinanewtab1.Caption:=UTF8Encode(traduction(461));
copy1.Caption:=UTF8Encode(traduction(458));
cut1.Caption:=UTF8Encode(traduction(459));
paste1.Caption:=UTF8Encode(traduction(460));
next1.Caption:=UTF8Encode(traduction(280));
Prior1.Caption:=UTF8Encode(traduction(281));
print1.Caption:=UTF8Encode(traduction(455));
Selectall4.caption:=UTF8Encode(traduction(40));
Properties2.Caption:=UTF8Encode(traduction(42));

//POPUP GENERIC CUT COPY PASTE
copy2.Caption:=UTF8Encode(traduction(458));
cut2.Caption:=UTF8Encode(traduction(459));
paste2.Caption:=UTF8Encode(traduction(460));
Selectall6.caption:=UTF8Encode(traduction(40));

//POPUP OFFLINELIST FILTERS
Setfilters1.Caption:=UTF8Encode(traduction(465));
Applyfilters1.Caption:=UTF8Encode(traduction(537));
Removefilters1.Caption:=UTF8Encode(traduction(538));

speedbutton18.Hint:=traduction(26);
speedbutton19.Hint:=traduction(27);
speedbutton20.Hint:=traduction(28);
speedbutton21.Hint:=traduction(29);
speedbutton27.Hint:=traduction(106);
speedbutton31.Hint:=traduction(165);
speedbutton39.Hint:=traduction(277);
speedbutton41.Hint:=traduction(329);

speedbutton42.Hint:=traduction(144);
speedbutton43.Hint:=traduction(145);
speedbutton45.Hint:=traduction(335);
speedbutton46.Hint:=traduction(42);
speedbutton49.Hint:=traduction(342);
speedbutton50.Hint:=traduction(387);
speedbutton63.Hint:=traduction(464);
speedbutton51.Hint:=traduction(389);
speedbutton44.Hint:=traduction(348);

speedbutton6.Hint:=traduction(110);
speedbutton28.Hint:=traduction(113);

speedbutton12.Hint:=traduction(116);


speedbutton10.Hint:=traduction(444);
speedbutton29.Hint:=traduction(118);
speedbutton30.Hint:=traduction(156);
speedbutton33.Hint:=traduction(241);
speedbutton65.Hint:=traduction(120);
speedbutton34.Hint:=traduction(240);
speedbutton67.Hint:=traduction(536);

speedbutton35.Hint:=traduction(258);
speedbutton37.Hint:=traduction(259);
speedbutton38.Hint:=traduction(258);
speedbutton36.Hint:=traduction(259);


speedbutton62.Hint:=traduction(258);
speedbutton64.Hint:=traduction(259);

VirtualStringTree4.header.Columns[0].text:=traduction(151);
VirtualStringTree4.header.Columns[1].text:=traduction(233);
VirtualStringTree4.header.Columns[2].text:=traduction(153);
VirtualStringTree4.header.Columns[3].text:=traduction(154);
VirtualStringTree4.header.Columns[4].text:=traduction(155);
VirtualStringTree4.header.Columns[5].text:=traduction(11);
VirtualStringTree4.header.Columns[6].text:=traduction(219);

speedbutton48.Hint:=traduction(258);
speedbutton47.Hint:=traduction(259);

x:=ComboBox2.ItemIndex; //FIX When apply settings
if x=-1 then
  x:=0;
  
combobox2.Items.Strings[0]:=traduction(151);
combobox2.Items.Strings[1]:=traduction(153);
combobox2.Items.Strings[2]:=traduction(154);
combobox2.Items.Strings[3]:=traduction(155);
combobox2.Items.Strings[4]:=traduction(11);
combobox2.Items.Strings[5]:=traduction(219);
combobox2.ItemIndex:=x;

label7.Caption:=traduction(256)+' :';


Romspath1.Caption:=traduction(160);
Samplespath1.Caption:=traduction(161);
CHDspath1.Caption:=traduction(162);

//WB
speedbutton56.caption:=traduction(281);
speedbutton57.caption:=traduction(280);
speedbutton54.caption:=traduction(143);
stop1.Caption:=UTF8Encode(traduction(143));
Refresh1.Caption:=UTF8Encode(traduction(452));

speedbutton53.caption:=traduction(451);
speedbutton55.caption:=traduction(452);
speedbutton58.hint:=traduction(453);
speedbutton52.hint:=traduction(116);
speedbutton59.hint:=traduction(117);
speedbutton60.hint:=traduction(454);
speedbutton61.hint:=traduction(455);
speedbutton66.hint:=traduction(493);
speedbutton71.hint:=traduction(551);

aux:=gettoken(panel66.Caption,' / ',1);
aux:=gettoken(aux,' ',2);
panel66.Caption:=traduction(512)+' '+aux+' / '+gettoken(panel66.Caption,' / ',2);

currentdbstatusname;
setstaystatuslabel;
setgeneratorpathlabel;

try
  showprofilestotalpanel(DataModule1.Tprofiles.RecordCount);
except
end;

try
  showprofilesselected;
except
end;

end;


procedure TFmain.ScaleForm
    (F: TForm; ScreenWidth, ScreenHeight: LongInt) ;
begin
   F.Scaled := True;
   F.AutoScroll := False;
   F.Position := poScreenCenter;
   //F.Font.Name := 'Arial';
   if (Screen.Width <> ScreenWidth) then begin
     F.Height :=
         LongInt(F.Height) * LongInt(Screen.Height)
         div ScreenHeight;
     F.Width :=
         LongInt(F.Width) * LongInt(Screen.Width)
         div ScreenWidth;
     F.ScaleBy(Screen.Width,ScreenWidth) ;
   end;
end;

procedure TFmain.fixcomponentsbugs(F:Ttntform);
var
x,y:integer;
b:boolean;
tv:TVTColumnOptions;
begin
//F.ControlStyle := F.ControlStyle - [csParentBackgrouond];
F.Font.Name:=defaultfontname;
F.Scaled:=False;//0.024 prevent problems with magnified Win options
F.Position:=poDesigned;//0.024 old poscreencenter
F.DefaultMonitor:=dmActiveForm;//0.024 seems free to possition
F.ScreenSnap:=true;//0.024 magnetic desktop corners
F.AutoScroll:=false;//0.029

for x:=0 to F.ComponentCount-1 do
  if F.components[x] is TTntpanel then begin
    (F.Components[x] as TTntpanel).font.Name:=defaultfontname;
    
    if (F.Components[x] as TTntpanel).Font.Style=[fsbold] then
      (F.Components[x] as TTntpanel).Font.size:=9;

    (F.Components[x] as TTntpanel).DoubleBuffered:=true;
    //FIXES BLACK OR WRONG COLOR PANELS
    (F.Components[x] as TTntpanel).ParentBackground:=true;
    (F.Components[x] as TTntpanel).ParentBackground:=false;
    (F.Components[x] as TTntpanel).Repaint;
   end
  else
  if F.components[x] is TTntlabel then begin
    (F.Components[x] as TTntlabel).font.Name:=defaultfontname;
    if (F.Components[x] as TTntlabel).Font.Style=[fsbold] then
      (F.Components[x] as TTntlabel).Font.size:=9;
  end
  else
  if F.components[x] is TTntpagecontrol then begin
    //REMOVED SINCE 0.016
    (F.Components[x] as TTntpagecontrol).Font.Name:=defaultfontname;
    (F.Components[x] as TTntpagecontrol).DoubleBuffered:=true;
  end
  else
  if F.components[x] is Tpopupmenu then begin
    (F.Components[x] as Tpopupmenu).AutoHotkeys:=maManual; //DISABLE SHORTCUTS
  end
  else
  if F.components[x] is TProgressBar then begin
    (F.Components[x] as TProgressBar).DoubleBuffered:=true;
    (F.Components[x] as TProgressBar).Smooth:=True;
    //SendMessage((F.Components[x] as TProgressBar).Handle, PBM_SETBKCOLOR, 0, Tcolor(clnone)) ;
    SendMessage((F.Components[x] as TProgressBar).Handle, PBM_SETBARCOLOR, 0, clgreen);
  end
  else
  if F.components[x] is TTnttreeview then begin
    (F.Components[x] as TTnttreeview).Font.Name:=defaultfontname;
    (F.Components[x] as TTnttreeview).DoubleBuffered:=true;
    //0.028 ADD TO ACTIVE FORM TOO
    setwinvista7theme((F.Components[x] as TTnttreeview).handle);
    (F.Components[x] as TTnttreeview).RightClickSelect:=true;
    //Disable automatic tooltips
    (F.Components[x] as TTnttreeview).ToolTips:=false;
    (F.Components[x] as TTnttreeview).ShowHint:=true;
    (F.Components[x] as TTnttreeview).OnMouseMove:=TreeView1MouseMove;
  end
  else
  if F.components[x] is TTntlistview then begin
    (F.Components[x] as TTntlistview).font.name:=defaultfontname;
    (F.Components[x] as TTntlistview).DoubleBuffered:=true;
    setwinvista7theme((F.Components[x] as TTntlistview).handle);
    for y:=0 to (F.Components[x] as TTntlistview).Columns.Count-1 do begin
      (F.Components[x] as TTntlistview).Column[y].MinWidth:=50;
      if (F.Components[x] as TTntlistview).Column[y].Width<50 then
        (F.Components[x] as TTntlistview).Column[y].Width:=175;
    end;

  end
  else
  if F.components[x] is TVirtualStringTree then begin
    (F.Components[x] as TVirtualStringTree).DoubleBuffered:=true;
    (F.Components[x] as TVirtualStringTree).OnGetHint:=VirtualStringTree2GetHint;
    (F.Components[x] as TVirtualStringTree).OnMouseLeave:=VirtualStringTree2MouseLeave;
    (F.Components[x] as TVirtualStringTree).OnScroll:=VirtualStringTree2Scroll;
    (F.Components[x] as TVirtualStringTree).Font.Name:=defaultfontname;
    (F.Components[x] as TVirtualStringTree).ShowHint:=true;
    (F.Components[x] as TVirtualStringTree).HintAnimation:=hatNone;
    (F.Components[x] as TVirtualStringTree).HintMode:=hmHintAndDefault;   
    (F.Components[x] as TVirtualStringTree).Header.Font.Name:=defaultfontname;
    (F.Components[x] as TVirtualStringTree).IncrementalSearch:=isAll;
    (F.Components[x] as TVirtualStringTree).IncrementalSearchDirection:=sdForward;
    (F.Components[x] as TVirtualStringTree).IncrementalSearchTimeout:=1000;//No timeout
    (F.Components[x] as TVirtualStringTree).TextMargin:=0;
    (F.Components[x] as TVirtualStringTree).Header.Height:=20;
    (F.Components[x] as TVirtualStringTree).OnIncrementalSearch:=VirtualStringTree2IncrementalSearch;
    (F.Components[x] as TVirtualStringTree).DragType:=dtVCL; //No remove
    (F.Components[x] as TVirtualStringTree).TreeOptions.MiscOptions:=(F.Components[x] as TVirtualStringTree).TreeOptions.MiscOptions-[toAcceptOLEDrop];  //Allow drag drop
    //(F.Components[x] as TVirtualStringTree).DragOperations:=[doCopy];
    (F.Components[x] as TVirtualStringTree).DrawSelectionMode:=smBlendedRectangle;
    b:=false;  //DETECT NO CLICKABLE HEADERS THEN DISSABLE HOTTTRACK 0.037
    if (F.Components[x] as TVirtualStringTree).Header.Columns.Count>0 then begin
      tv:=(F.Components[x] as TVirtualStringTree).Header.Columns[0].Options;
      if tv=tv-[coAllowClick] then
        b:=true;
    end;

    if b=false then begin  //Show root for generator list
      (F.Components[x] as TVirtualStringTree).Header.Options:=(F.Components[x] as TVirtualStringTree).Header.options+[hoHotTrack];
      (F.Components[x] as TVirtualStringTree).TreeOptions.PaintOptions:=(F.Components[x] as TVirtualStringTree).TreeOptions.PaintOptions-[toShowRoot]+[toUseExplorerTheme]-[toHotTrack];
    end
    else
      if ((F.Components[x] as TVirtualStringTree).name='VirtualStringTree4') AND (F.name='Fmain') then  //IF GENERATOR SHOW ROOT ELSE NOT
        (F.Components[x] as TVirtualStringTree).TreeOptions.PaintOptions:=(F.Components[x] as TVirtualStringTree).TreeOptions.PaintOptions+[toShowRoot]+[toUseExplorerTheme]-[toHotTrack]
      else
        (F.Components[x] as TVirtualStringTree).TreeOptions.PaintOptions:=(F.Components[x] as TVirtualStringTree).TreeOptions.PaintOptions-[toShowRoot]+[toUseExplorerTheme]-[toHotTrack];

    (F.Components[x] as TVirtualStringTree).TreeOptions.MiscOptions:=(F.Components[x] as TVirtualStringTree).TreeOptions.MiscOptions-[toFullRepaintOnResize];
    (F.Components[x] as TVirtualStringTree).Header.Options:=(F.Components[x] as TVirtualStringTree).Header.Options-[hoDrag];

    b:=false;
    if ((F.Components[x] as TVirtualStringTree).name='VirtualStringTree1') AND (F.name='Fserver') then
      b:=true;

    if b=false then //Columns visible except Fserver Peers list
      (F.Components[x] as TVirtualStringTree).Header.Options:=(F.Components[x] as TVirtualStringTree).Header.Options+[hoVisible];

    (F.Components[x] as TVirtualStringTree).TreeOptions.SelectionOptions:=(F.Components[x] as TVirtualStringTree).TreeOptions.SelectionOptions+[toFullRowSelect]+[toRightClickSelect];
    (F.Components[x] as TVirtualStringTree).DragImageKind:=diComplete;

    //0.031
    for y:=0 to (F.Components[x] as TVirtualStringTree).Header.Columns.Count-1 do
      (F.Components[x] as TVirtualStringTree).Header.Columns[y].MinWidth:=50;

    (F.components[x] as Tvirtualstringtree).OnMouseWheel:=VirtualStringTree2MouseWheel;//FIX MOUSE WHEEL WHEN NO FOCUS 0.046
  end
  else
  if F.components[x] is TTntedit then begin //ENABLE SELECTALL ON ENTER TO TEDIT
    (F.Components[x] as TTntedit).Font.Name:=defaultfontname;
    (F.Components[x] as TTntedit).AutoSelect:=false;
    (F.Components[x] as TTntedit).OnEnter:=EditEnter;
    (F.Components[x] as TTntedit).PopupMenu:=PopupMenu10;
    (F.Components[x] as TTntedit).DoubleBuffered:=true;//0.037
    //MOUSE DISSAPEAR FIX
    if assigned((F.Components[x] as TTntedit).OnChange)=false then
      (F.Components[x] as TTntedit).OnChange:=EditChange;
  end
  else
  if F.components[x] is TTntcombobox then begin //ENABLE SELECTALL ON ENTER TO TEDIT
    (F.Components[x] as TTntcombobox).font.Name:=defaultfontname;
    LockWindowUpdate((F.Components[x] as TTntcombobox).handle);//FLASHING EFFECT FIX

    if (F.Components[x] as TTntcombobox).Style=csDropDown then begin
      (F.Components[x] as TTntcombobox).OnEnter:=EditEnter;
      (F.Components[x] as TTntcombobox).PopupMenu:=PopupMenu10;
    end
    else
    if (F.Components[x] as TTntcombobox).Style<>csOwnerDrawFixed then begin
      (F.Components[x] as TTntcombobox).Style:=csOwnerDrawFixed;
      (F.Components[x] as TTntcombobox).OnDrawItem:=ComboBox1DrawItem;
    end;
    //ONEXIT,ONSELECT
    (F.Components[x] as TTntcombobox).ItemHeight:=16;//FIX
    (F.Components[x] as TTntcombobox).DropDownCount:=10; //SET COMBOBOXES TO MAX DROPDOWNCOUNT TO 10
    try
      SendMessage((F.Components[x] as TTntcombobox).Handle, $1701, 10, 0); //SET COMBOBOXES TO MAX DROPDOWNCOUNT TO 10
    except
    end;

    (F.Components[x] as TTntcombobox).ItemHeight:=Fmain.edit5.Height-5;//-5
    LockWindowUpdate(0);
    (F.Components[x] as TTntcombobox).Repaint; //FLASHING EFFECT FIX
  end
  else
  if F.components[x] is TRxrichedit then begin //ENABLE SELECTALL ON ENTER TO TEDIT
    (F.Components[x] as TRxrichedit).Font.Name:=defaultfontname;
    (F.Components[x] as TRxrichedit).WordWrap:=true;
    //(F.Components[x] as TTntrichedit).DoubleBuffered:=true;// BUG
    //(F.Components[x] as TTntrichedit).OnEnter:=EditEnter;
    (F.Components[x] as TRxrichedit).PlainText := False;
    //(F.Components[x] as TRxrichedit).StreamMode := [smSelection]; //BUG
    (F.Components[x] as TRxrichedit).LangOptions:=(F.Components[x] as TRxrichedit).LangOptions-[rlAutoFont];
    (F.Components[x] as TRxrichedit).SelectionBar:=false;
    (F.Components[x] as TRxrichedit).PopupMenu:=PopupMenu10;
    (F.Components[x] as TRxrichedit).ScrollBars:=ssVertical;
    (F.Components[x] as TRxrichedit).OnMouseWheel:=RichEditURL1MouseWheel;
    (F.Components[x] as TRxrichedit).OnURLClick:=RicheditURLClick;
  end
  else
  if F.Components[x] is TTntRichEdit then begin //USED IN COMMUNITY
    (F.Components[x] as TTntRichEdit).PopupMenu:=PopupMenu10;
    (F.Components[x] as TTntRichEdit).OnMouseWheel:=RichEditURL1MouseWheel;
  end
  else
  if F.components[x] is TBMDThread then begin

    (F.Components[x] as TBMDThread).ThreadGroup:=BMDThreadGroup1; //0.037

    if (wideuppercase(F.Name)<>'FMAIN') AND (wideuppercase(F.Name)<>'FSERVER') then
      (F.Components[x] as TBMDThread).Priority:=BMDThread1.Priority;

  end
  else
  if F.components[x] is TSplitter  then begin
    (F.components[x] as TSplitter).ResizeStyle:=rsUpdate;
  end
  else
  if F.components[x] is TXPMenu then begin
    (F.Components[x] as TXPMenu).Active:=true;
  end
  else
  if F.Components[x] is TStaticText then begin
    SetWindowTheme((F.Components[x] as TStaticText).handle,' ',' ');
    (F.Components[x] as TStaticText).Font.color:=clred;
    (F.Components[x] as TStaticText).DoubleBuffered:=true;
  end;

end;

//Only one instance cheat
procedure TFmain.CreateParams(var Params: TCreateParams);
begin
  inherited
  CreateParams(Params);
  //Params.ExStyle   := Params.ExStyle or WS_EX_APPWINDOW;
  //Params.WndParent := GetDesktopWindow;//This fixes opendialog hide Fserver window but duplicates taskbar 0.037
  Params.WinClassName :='@RMLPRJ@';
end;

{procedure TFmain.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then
    ShowWindow(Handle, SW_MINIMIZE)
  else
    inherited;
end;   }

procedure TFmain.RestoreRequest(var message: TMessage);
begin
  if Cooltrayicon1.Tag=1 then
    CoolTrayIcon1DblClick(Cooltrayicon1);

  Application.Restore;

  Application.BringToFront;    
end;

//Set App priority
procedure TFmain.priority(i:integer);
var
MainThread: THandle;
begin
MainThread := GetCurrentThread;
case i of
  0:SetThreadPriority(MainThread, HIGH_PRIORITY_CLASS);
  1:SetThreadPriority(MainThread, NORMAL_PRIORITY_CLASS);
  2:SetThreadPriority(MainThread, IDLE_PRIORITY_CLASS);
end;

case i of
  0:BMDThread1.Priority:=tpHigher;
  1:BMDThread1.Priority:=tpNormal;
  2:BMDThread1.Priority:=tpLower;
end;

end;

//Proces Window show and hide
procedure TFmain.showprocessingwindow(cancancel:boolean;countdown:boolean);
var
monitor:integer;
begin
taskbaractive(true);

try
  EnableWindow(handle,false);
except
end;

Fmain.enabled:=false;

freemousebuffer;
freekeyboardbuffer;
lastnewdatdecision:=0;

if formexists('Fprocessing') then
  FreeAndNil(Fprocessing);

Application.CreateForm(TFprocessing, Fprocessing);
Fprocessing.AlphaBlend:=true;//FIX GOSHING EFFECT

try
  if formexists('Fproperties') then //Processing displayed in Update file mode
    monitor:=Fproperties.Monitor.MonitorNum
  else
    monitor:=Application.MainForm.Monitor.MonitorNum;

  Fprocessing.Top:= ((screen.Monitors[monitor].BoundsRect.Top+screen.Monitors[monitor].BoundsRect.Bottom) div 2)-(Fprocessing.Height div 2);
  Fprocessing.left:=((screen.Monitors[monitor].BoundsRect.Left+screen.Monitors[monitor].BoundsRect.right) div 2)-(Fprocessing.width div 2);
except
  Fprocessing.Position:=poscreencenter;
end;


if cancancel=false then begin
  Fprocessing.SpeedButton1.caption:=traduction(339);
  Fprocessing.SpeedButton1.Enabled:=false;
end;

//0.044

if screen.Forms[0].Name='Fserver' then begin
  ShowWindow(Fprocessing.handle, SW_SHOWNOACTIVATE);
  Fserver.BringToFront
end
else
  Fprocessing.Show;

Fprocessing.Visible:=true;

Fprocessing.Repaint;

application.processmessages;
end;

procedure TFmain.hideprocessingwindow;
begin
if formexists('Fprocessing')=false then
  exit;

Fprocessing.timer1.enabled:=false;
Fprocessing.FormStyle:=fsNormal;
Fprocessing.Repaint;

//Fprocessing.hide;  //BUG
ShowWindow(Fprocessing.Handle, SW_HIDE);  //0.044 SERVER WINDOW BUGFIX

Fmain.addtoactiveform(Fprocessing,false);

FreeAndNil(Fprocessing);

Fmain.Repaint;
freemousebuffer;
freekeyboardbuffer;

try
  if formexists('Fupdater')=false then begin //0.046
    EnableWindow(handle,true);
    Fmain.Enabled:=true;
  end;
except
end;

taskbaractive(false);
application.ProcessMessages;//0.045 popupmenu fix
end;

function Tfmain.CloneComponent(AAncestor: TComponent;id:ansistring): TComponent;
var
XMemoryStream: TMemoryStream;
XTempName: string;
begin
Result:=nil;
if not Assigned(AAncestor) then exit;

XMemoryStream:=TMemoryStream.Create;

try

  XTempName:=AAncestor.Name;
  AAncestor.Name:='CLONE_' + XTempName+'_'+id;
  XMemoryStream.WriteComponent(AAncestor);
  AAncestor.Name:=XTempName;
  XMemoryStream.Position:=0;
  Result:=TComponentClass(AAncestor.ClassType).Create(AAncestor.Owner);
  if AAncestor is TControl then
    TControl(Result).Parent:=TControl(AAncestor).Parent;

  XMemoryStream.ReadComponent(Result);

finally
  XMemoryStream.Free;
end;
end;

procedure Tfmain.labelshadow(l:Ttntlabel;F:Ttntform);
var
l2:Tcomponent;
toclone:boolean;
begin
toclone:=true;
l2:=F.FindComponent('CLONE_'+l.Name+'_');

if l2<>nil then begin
  (l2 as Ttntlabel).Caption:=l.Caption;
  toclone:=false;
end;

l.Transparent:=true;

if toclone=true then begin
  l2:=CloneComponent(l,'');
  (l2 as TTntlabel).SendToBack;
  (l2 as TTntlabel).Font.Color:=clsilver;
end;

(l2 as TTntlabel).Top:=l.top+1;
(l2 as TTntlabel).Left:=l.Left-1;
end;

//-PROFILES-------------------------------------------------

procedure TFmain.selectedprofilestobool(fieldname:string;value:boolean);
var
x,affected:integer;
n:PVirtualNode;
begin
affected:=0;
n:=VirtualStringTree2.GetFirst;
for x:=0 to VirtualStringTree2.RootNodeCount-1 do begin
  if VirtualStringTree2.Selected[n]=true then begin
    Datamodule1.Tprofilesview.Locate('CONT',x+1,[]);
    Datamodule1.Tprofiles.Locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
    if Datamodule1.Tprofiles.fieldbyname(fieldname).AsBoolean<>value then begin
      try
        Datamodule1.Tprofiles.edit;
        Datamodule1.Tprofiles.fieldbyname(fieldname).AsBoolean:=value;
        Datamodule1.Tprofiles.post;
        affected:=affected+1;
      except
        Datamodule1.Tprofiles.Cancel;
      end;
    end;
  end;
  n:=VirtualStringTree2.GetNext(n);
end;

mymessageinfo(inttostr(affected)+' '+traduction(562));
end;

procedure TFmain.selectedprofilestobackup;
var
x,affected:integer;
changed:boolean;
path:widestring;
n:PVirtualNode;
begin
affected:=0;

path:=folderdialoginitialdircheck(defbackuppath);
positiondialogstart;

if WideSelectDirectory(traduction(139)+' :','',path) then begin
  path:=checkpathbar(path);
  n:=VirtualStringTree2.GetFirst;
  for x:=0 to VirtualStringTree2.RootNodeCount-1 do begin
    if VirtualStringTree2.Selected[n]=true then begin
      Datamodule1.Tprofilesview.Locate('CONT',x+1,[]);
      changed:=false;
      if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,'B']),[])=true then begin
        if getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'))<>path then begin
          changed:=true;
          Datamodule1.TDirectories.Edit;
        end;
      end
      else begin
        changed:=true;
        Datamodule1.TDirectories.Insert;
      end;

      if changed=true then begin
        try
          Datamodule1.TDirectories.FieldByName('Type').asstring:='B';
          setwiderecord(Datamodule1.TDirectories.FieldByName('Path'),path);
          Datamodule1.TDirectories.FieldByName('Profile').asinteger:=Datamodule1.Tprofilesview.fieldbyname('ID').asinteger;
          Datamodule1.TDirectories.FieldByName('Compression').asinteger:=0;
          Datamodule1.TDirectories.Post;
          affected:=affected+1;
        except
          Datamodule1.TDirectories.Cancel;
        end;
      end;

    end;

    n:=VirtualStringTree2.GetNext(n);
  end;//LOOP
end
else
  exit;

mymessageinfo(inttostr(affected)+' '+traduction(562));
end;

procedure Tfmain.onthreadquery2table();
var
pass,v1,v2,v3:boolean;
offtable:boolean;
counttotal,counthave,totalsets,readid,setnum,masternum,empty,complete:longint;
countsize:currency;
begin
totalsets:=0;
empty:=0;
complete:=0;
offtable:=strtobool(trim(gettoken(Datamodule1.Qsort.sql.Text,' ',2)));
v1:=strtobool(trim(gettoken(Datamodule1.Qsort.sql.Text,' ',3)));
v2:=strtobool(trim(gettoken(Datamodule1.Qsort.sql.Text,' ',4)));
v3:=strtobool(trim(gettoken(Datamodule1.Qsort.sql.Text,' ',5)));

While not Datamodule1.Qaux.Eof do begin //QUERY TO TABLE

  counttotal:=0;
  counthave:=0;
  countsize:=0;
  totalsets:=totalsets+1;

  readid:=Datamodule1.Qaux.fieldbyname('ID').asinteger;
  setnum:=Datamodule1.Qaux.fieldbyname('Setname').asinteger;
  masternum:=Datamodule1.Qaux.fieldbyname('Setnamemaster').asinteger;

  mastertable.append;

  mastertable.FieldByName('ID').asinteger:=readid;
  setwiderecord(mastertable.fieldbyname('Description'),getwiderecord(Datamodule1.Qaux.fieldbyname('Description')));
  setwiderecord(mastertable.fieldbyname('Gamename'),getwiderecord(Datamodule1.Qaux.fieldbyname('Gamename')));

  if offtable=true then begin

    setwiderecord(mastertable.fieldbyname('Publisher'),getwiderecord(Datamodule1.Qaux.fieldbyname('Publisher')));
    setwiderecord(mastertable.fieldbyname('Savetype'),getwiderecord(Datamodule1.Qaux.fieldbyname('Savetype')));
    setwiderecord(mastertable.fieldbyname('Comment'),getwiderecord(Datamodule1.Qaux.fieldbyname('Comment')));
    setwiderecord(mastertable.fieldbyname('Language'),getwiderecord(Datamodule1.Qaux.fieldbyname('Language')));
    setwiderecord(mastertable.fieldbyname('Sourcerom'),getwiderecord(Datamodule1.Qaux.fieldbyname('Sourcerom')));
    mastertable.fieldbyname('Locationnum').asinteger:=Datamodule1.Qaux.fieldbyname('Locationnum').asinteger;

  end;

  While (readid=Datamodule1.Qaux.fieldbyname('ID').asinteger) AND (Datamodule1.Qaux.Eof=False) do begin

    counttotal:=counttotal+1;
    countsize:=countsize+Datamodule1.Qaux.fieldbyname('Space').ascurrency;

    if Datamodule1.Qaux.fieldbyname('Have').AsBoolean=true then
      counthave:=counthave+1;

    detailtable.append;

    detailtable.fieldbyname('CONT').AsInteger:=counttotal;
    setwiderecord(detailtable.fieldbyname('Romname'),getwiderecord(Datamodule1.Qaux.fieldbyname('Romname')));
    detailtable.fieldbyname('Space').ascurrency:=Datamodule1.Qaux.fieldbyname('Space').ascurrency;
    detailtable.fieldbyname('CRC').asstring:=Datamodule1.Qaux.fieldbyname('CRC').asstring;
    detailtable.fieldbyname('MD5').asstring:=Datamodule1.Qaux.fieldbyname('MD5').asstring;
    detailtable.fieldbyname('SHA1').asstring:=Datamodule1.Qaux.fieldbyname('SHA1').asstring;
    detailtable.fieldbyname('Type').asstring:=Datamodule1.Qaux.fieldbyname('Type').asstring;
    detailtable.fieldbyname('Setname').asinteger:=Readid;
    detailtable.fieldbyname('Have').AsBoolean:=Datamodule1.Qaux.fieldbyname('Have').asboolean;

    detailtable.post;

    Datamodule1.Qaux.next;
  end;

  pass:=false;
  if counthave=0 then begin
    empty:=empty+1;
      if v3=true then
        pass:=true;
  end
  else
  if counthave=counttotal then begin
    complete:=complete+1;
    if v1=true then
      pass:=true;
  end
  else
    if v2=true then
      pass:=true;

  if pass=true then begin

    mastertable.fieldbyname('Size_').ascurrency:=countsize;
    mastertable.fieldbyname('Total_').asinteger:=counttotal;
    mastertable.fieldbyname('Have_').asinteger:=counthave;

    if offtable=false then
      if setnum<>masternum then begin
        if Datamodule1.Taux.Locate('ID',masternum,[]) then
          mastertable.fieldbyname('Master').asstring:=Datamodule1.Taux.fieldbyname('Description').asstring;
      end;

    mastertable.post;

  end
  else
    mastertable.cancel;

end;

//RETURN VARS
Datamodule1.Qaux.SQL.Text:=inttostr(complete)+' '+inttostr(empty)+' '+inttostr(totalsets);
end;

procedure Tfmain.dbtodat;
var
x,y:integer;
skip,added:boolean;
id:ansistring;
total:integer;
description,path,headerfile:widestring;
fmode:shortint;
n:PVirtualNode;
Qm,Qd:TABSQuery;
fieldname:string;
calc,setinsert:boolean;
tabidx:shortint;
begin
savefocussedcontrol;

//0.032
description:=traduction(589);

path:=folderdialoginitialdircheck(initialdirxmlcreation);
positiondialogstart;
if WideSelectDirectory(description+' :','',path)=false then
  exit;

path:=checkpathbar(path);
initialdirxmlcreation:=path;

n:=nil;
total:=0;
Qm:=TABSQuery.Create(Datamodule1);
Qd:=TABSQuery.Create(Datamodule1);

Qm.DatabaseName:='RML_DATA';
Qd.DatabaseName:='RML_DATA';
Qm.DisableControls;
Qd.DisableControls;
Qm.RequestLive:=true;
Qd.RequestLive:=true;


total:=VirtualStringTree2.RootNodeCount;
y:=0;

sterrors.Clear;//Initialize
imported:=0;

//POSITION ON CORRECT INDEX

n:=VirtualStringTree2.GetFirst;
While n.Index<>y do
  n:=VirtualStringTree2.GetNext(n);

for x:=y to total-1 do begin

  added:=false;
  setinsert:=true;

  if formexists('Fprocessing') then
    if Fprocessing.Tag=1 then
      break;

  skip:=false;

  DataModule1.Tprofilesview.locate('CONT',x+1,[]);
  Datamodule1.Tprofiles.Locate('ID',DataModule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
  id:=fillwithzeroes(DataModule1.Tprofilesview.fieldbyname('ID').asstring,4);
  description:=getwiderecord(Datamodule1.Tprofilesview.fieldbyname('Description'));
  fmode:=Datamodule1.Tprofilesview.fieldbyname('Filemode').asinteger;
  headerfile:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('header'));

  allowmerge:=false;
  allowdupe:=false;
  fieldname:='Setname';

  case fmode of
  0:begin
      allowmerge:=true;//Same file
      allowdupe:=false;
      fieldname:='Setnamemaster'
    end;
  1:begin
      allowmerge:=false;//Normal
      allowdupe:=true;
    end;
  2:begin
      allowmerge:=true;//Big size
      allowdupe:=true;
    end;
  end;

  Qm.SQL.Text:='SELECT * FROM Y'+id+' ORDER BY ID';
  Qd.SQL.text:='SELECT * FROM Z'+id+' ORDER BY '+fieldname;

  if VirtualStringTree2.Selected[n]=false then
    skip:=true;

  if skip=false then begin

    if formexists('Fprocessing')=false then
      if VirtualStringTree2.RootNodeCount=1 then
        showprocessingwindow(false,false)
      else
        showprocessingwindow(true,false);

    Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(327);

    if tabidx=1 then  //SCANNER TAB
      Fprocessing.panel2.Caption:=changein(description,'&','&&')
    else
      Fprocessing.panel2.Caption:=changein(description,'&','&&');

    try

      if skip=false then begin

        //FREEZE
        Qm.Open;
        Application.ProcessMessages; //0.031
        Qd.Open;

        //0.032
        DataModule1.Tprofilesview.locate('CONT',x+1,[]);
        //filename,name,description,vers,date,author,category,homepage,email:widestring
        preparexmlwrite(tempdirectoryresources+'export.rmt',getwiderecord(Datamodule1.Tprofilesview.FieldByName('Name')),getwiderecord(Datamodule1.Tprofilesview.FieldByName('Description')),getwiderecord(Datamodule1.Tprofilesview.FieldByName('Version')),getwiderecord(Datamodule1.Tprofilesview.FieldByName('Date')),getwiderecord(Datamodule1.Tprofilesview.FieldByName('Author')),getwiderecord(Datamodule1.Tprofilesview.FieldByName('Category')),getwiderecord(Datamodule1.Tprofilesview.FieldByName('Homeweb')),getwiderecord(Datamodule1.Tprofilesview.FieldByName('Email')),headerfile);

        description:=description+'.xml';
        description:=removeconflictchars2(description,true);
        description:=path+description;
        description:=getvaliddestination(description);

        While not Qd.Eof do begin

          Application.ProcessMessages;//0.031

          //Possition in correct set
          While Qm.FieldByName('ID').asinteger<>Qd.fieldbyname(fieldname).asinteger do begin

            Application.ProcessMessages;//0.031

            if added=true then
              xmlcloseset;

            added:=False;
            setinsert:=true;

            Qm.Next;

            if Qm.Eof then
              makeexception;
          end;

          calc:=false;

          if Qd.fieldbyname('Merge').asboolean=true then begin
            if allowmerge=true then
              calc:=true;
          end
          else
            calc:=true;

          if calc=true then
            if Qd.fieldbyname('Dupe').asboolean=true then begin
              if allowdupe=true then
                calc:=true
              else
                calc:=false;
            end
            else
              calc:=true;

          if (calc=true) then begin

            if setinsert=true then
              xmlwriteset(getwiderecord(Qm.fieldbyname('Gamename')),getwiderecord(Qm.fieldbyname('Description')));

            xmlwriterom(getwiderecord(Qd.FieldByName('Romname')),Qd.FieldByName('Space').asstring,Qd.FieldByName('CRC').asstring,Qd.FieldByName('MD5').asstring,Qd.FieldByName('SHA1').asstring,Qd.FieldByName('Type').asinteger);

            setinsert:=false;
            added:=true;
          end;

          Qd.Next;
        end;

        if added=true then
          xmlcloseset;

        closexmlwrite;

        if movefile2(tempdirectoryresources+'export.rmt',description)=false then
          makeexception;

        imported:=imported+1;

      end;

    except
      closexmlwrite;
      deletefile2(tempdirectoryresources+'export.rmt');
      adderror(traduction(150)+#10#13+description);
    end;

  end;

  n:=VirtualStringTree2.GetNext(n);
end;

closexmlwrite;

Freeandnil(Qm);
Freeandnil(Qd);

hideprocessingwindow;

restorefocussedcontrol;
                        
if sterrors.Count=0 then
  mymessageinfo(inttostr(imported)+' '+traduction(590))
else begin
  sterrors.Add(inttostr(imported)+' '+traduction(590));
  mymessagewarning(sterrors.Text);
end;

sterrors.clear;
end;

procedure Tfmain.createffix(all:boolean);
var
x,y:integer;
skip,added:boolean;
id:ansistring;
total:integer;
description,path,headerfile:widestring;
fmode:shortint;
n:PVirtualNode;
Qm,Qd:TABSQuery;
fieldname:string;
calc,setinsert:boolean;
tabidx:shortint;
begin
savefocussedcontrol;

//0.032
description:=traduction(508);
if PageControl1.ActivePageIndex=1 then
  if all=true then
    description:=traduction(329)
  else
    description:=speedbutton40.Hint;

path:=folderdialoginitialdircheck(initialdirffix);
positiondialogstart;
if WideSelectDirectory(description+' :','',path)=false then
  exit;

path:=checkpathbar(path);
initialdirffix:=path;

n:=nil;
total:=0;
Qm:=TABSQuery.Create(Datamodule1);
Qd:=TABSQuery.Create(Datamodule1);

Qm.DatabaseName:='RML_DATA';
Qd.DatabaseName:='RML_DATA';
Qm.DisableControls;
Qd.DisableControls;
Qm.RequestLive:=true;
Qd.RequestLive:=true;

y:=1;

tabidx:=pagecontrol1.ActivePageIndex;

if tabidx=1 then //SCANNER TAB
  total:=pagecontrol2.PageCount
else
if tabidx=0 then begin
  total:=VirtualStringTree2.RootNodeCount; //ADD FRIENDFIX MAKER FROM PROFILES LIST
  y:=0;
  all:=true;
end;

sterrors.Clear;//Initialize
imported:=0;

//POSITION ON CORRECT INDEX
if tabidx=0 then begin
  n:=VirtualStringTree2.GetFirst;
  While n.Index<>y do
    n:=VirtualStringTree2.GetNext(n);
end;

for x:=y to total-1 do begin

  added:=false;
  setinsert:=true;

  if formexists('Fprocessing') then
    if Fprocessing.Tag=1 then
      break;

  skip:=false;

  if tabidx=1 then begin //SCANNER TAB
    id:=gettoken(pagecontrol2.pages[x].Name,'_',3);
    DataModule1.Tprofiles.locate('ID',id,[]);
    description:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'));
    fmode:=Datamodule1.Tprofiles.fieldbyname('Filemode').asinteger;
  end
  else begin
    DataModule1.Tprofilesview.locate('CONT',x+1,[]);
    Datamodule1.Tprofiles.locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
    id:=fillwithzeroes(DataModule1.Tprofilesview.fieldbyname('ID').asstring,4);
    description:=getwiderecord(Datamodule1.Tprofilesview.fieldbyname('Description'));
    fmode:=Datamodule1.Tprofilesview.fieldbyname('Filemode').asinteger;
  end;

  //0.032
  headerfile:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('header'));

  allowmerge:=false;
  allowdupe:=false;
  fieldname:='Setname';

  case fmode of
  0:begin
      allowmerge:=true;//Same file
      allowdupe:=false;
      fieldname:='Setnamemaster'
    end;
  1:begin
      allowmerge:=false;//Normal
      allowdupe:=true;
    end;
  2:begin
      allowmerge:=true;//Big size
      allowdupe:=true;
    end;
  end;

  Qm.SQL.Text:='SELECT * FROM Y'+id+' ORDER BY ID';
  Qd.SQL.text:='SELECT * FROM Z'+id+' ORDER BY '+fieldname;

  if tabidx=1 then begin //SCANNER TAB
    if ((id<>getcurrentprofileid) AND (all=false)) then
      skip:=true;
  end
  else begin
    if VirtualStringTree2.Selected[n]=false then
      skip:=true;
  end;

  if skip=false then
    if tabidx=1 then begin //SCANNER TAB
      if pagecontrol2.pages[x].ImageIndex=0 then begin
        skip:=true;
        sterrors.add(traduction(393)+' : '+description);
      end;
    end
    else begin
      if (Datamodule1.Tprofilesview.fields[15].asinteger=Datamodule1.Tprofilesview.fieldbyname('Haveroms').AsInteger) AND (Datamodule1.Tprofilesview.fieldbyname('Haveroms').asstring<>'') AND (Datamodule1.Tprofilesview.fieldbyname('Haveroms').AsInteger<>0) then begin
        skip:=true;
        sterrors.add(traduction(393)+' : '+description);
      end;
    end;

  if skip=false then begin

    if tabidx=1 then begin //SCANNER TAB
      if (all=true) AND (pagecontrol2.PageCount>=3) then begin
        if formexists('Fprocessing')=false then
          showprocessingwindow(true,false) //CAN CANCEL IMPLEMENTED
      end
      else begin
        if formexists('Fprocessing')=false then
          showprocessingwindow(false,false); //CAN CANCEL IMPLEMENTED
      end;
    end
    else
      if formexists('Fprocessing')=false then
        if VirtualStringTree2.RootNodeCount=1 then
          showprocessingwindow(false,false)
        else
          showprocessingwindow(true,false);


    Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(327);

    if tabidx=1 then  //SCANNER TAB
      Fprocessing.panel2.Caption:=changein(description,'&','&&')
    else
      Fprocessing.panel2.Caption:=changein(description,'&','&&');

    try

      if skip=false then begin

        //FREEZE
        Qm.Open;
        Application.ProcessMessages; //0.031
        Qd.Open;

        //0.032
        description:='fix_'+description;
                                                                                                                         //0.037 Bingobongo suggestion
        preparexmlwrite(tempdirectoryresources+'export.rmt',description,description,'',datetimetostr(now),romulustitle,'FIXDATFILE',romulusurl,'','');
               //
        description:=description+'.xml';
        description:=removeconflictchars2(description,true);
        description:=path+description;
        description:=getvaliddestination(description);

        While not Qd.Eof do begin

          Application.ProcessMessages;//0.031

          //Possition in correct set
          While Qm.FieldByName('ID').asinteger<>Qd.fieldbyname(fieldname).asinteger do begin

            Application.ProcessMessages;//0.031

            if added=true then
              xmlcloseset;

            added:=False;
            setinsert:=true;

            Qm.Next;

            if Qm.Eof then
              makeexception;
          end;

          calc:=false;

          if Qd.fieldbyname('Merge').asboolean=true then begin
            if allowmerge=true then
              calc:=true;
          end
          else
            calc:=true;

          if calc=true then
            if Qd.fieldbyname('Dupe').asboolean=true then begin
              if allowdupe=true then
                calc:=true
              else
                calc:=false;
            end
            else
              calc:=true;

          if (calc=true) then
            if Qd.fieldbyname('Have').asboolean=false then begin

              if setinsert=true then
                xmlwriteset(getwiderecord(Qm.fieldbyname('Gamename')),getwiderecord(Qm.fieldbyname('Description')));
                        
              xmlwriterom(getwiderecord(Qd.FieldByName('Romname')),Qd.FieldByName('Space').asstring,Qd.FieldByName('CRC').asstring,Qd.FieldByName('MD5').asstring,Qd.FieldByName('SHA1').asstring,Qd.FieldByName('Type').asinteger);

              setinsert:=false;
              added:=true;
            end;

          Qd.Next;
        end;

        if added=true then
          xmlcloseset;

        closexmlwrite;

        if movefile2(tempdirectoryresources+'export.rmt',description)=false then
          makeexception;

        imported:=imported+1;

      end;

    except
      closexmlwrite;
      deletefile2(tempdirectoryresources+'export.rmt');
      adderror(traduction(150)+#10#13+description);
    end;

  end;

  n:=VirtualStringTree2.GetNext(n);
end;

closexmlwrite;

Freeandnil(Qm);
Freeandnil(Qd);

hideprocessingwindow;

restorefocussedcontrol;

if sterrors.Count=0 then
  mymessageinfo(inttostr(imported)+' '+traduction(590))
else begin
  sterrors.Add(inttostr(imported)+' '+traduction(590));
  mymessagewarning(sterrors.Text);
end;

sterrors.clear;
end;

procedure Tfmain.emuclick(Sender: TObject);
var
paramreal,path:widestring;
dos:boolean;
begin
sterrors.Clear;
Datamodule1.Qaux.Close;
Datamodule1.Qaux.sql.clear;
Datamodule1.Qaux.sql.add('SELECT * FROM Emulators WHERE ID ='+inttostr((sender as Tmenuitem).tag));
Datamodule1.Qaux.Open;
dos:=Datamodule1.Qaux.fieldbyname('DOS').asboolean;

paramreal:=getwiderecord(Datamodule1.Qaux.fieldbyname('Param'));

//%e emulator
//%r rompath
//%d description
//%f folder

if dos=false then begin
  paramreal:=Changein(paramreal,'%e',getwiderecord(Datamodule1.Qaux.fieldbyname('Path')));
end
else begin
   paramreal:=Changein(paramreal,'%e',GetShortFileName(getwiderecord(Datamodule1.Qaux.fieldbyname('Path'))));
end;

if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(getcurrentprofileid),'0']),[]) then begin
  if wideDirectoryExists(getwiderecord(Datamodule1.TDirectories.Fieldbyname('Path'))) then begin
    path:=getwiderecord(Datamodule1.TDirectories.Fieldbyname('Path'));
    path:=checkpathbar(path);
    if Length(path)>3 then //C:\
      path:=Copy(path,1,length(path)-1);

    if dos=true then begin
      paramreal:=Changein(paramreal,'%r',GetShortFileName(path));
    end
    else begin
      paramreal:=Changein(paramreal,'%r',path);
    end;
  end
  else
    sterrors.Add(traduction(157));
end
else
  sterrors.Add(traduction(157));

mastertable.Locate('ID',detailedit.tag,[]);
paramreal:=Changein(paramreal,'%d',getwiderecord(mastertable.fieldbyname('Description')));
paramreal:=Changein(paramreal,'%f',getwiderecord(mastertable.fieldbyname('Gamename')));

if sterrors.Count=0 then begin
  if mymessagequestion(traduction(321)+#10#13+paramreal,false)=1 then begin
    writelist.Clear;
    writelist.Add(UTF8Encode(changein(wideextractfilepath(getwiderecord(Datamodule1.Qaux.fieldbyname('Path'))),'%','%%')));
    RunAndWaitShell(UTF8Encode(paramreal),'',1,false,true)
  end;

end
else
  mymessageerror(sterrors.Text);

Datamodule1.Qaux.Close;

end;

procedure TFmain.setpopupemulatorslist;
var
ico:Ticon;
bmp:Tbitmap;
x,added:integer;
r:Trect;
Filter: Word;
begin
filter:=0;
added:=0;
r.Top:=0;
r.Bottom:=16;
r.Right:=16;

Datamodule1.Qaux.Close;
Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.sql.Add('SELECT * FROM Emulators WHERE Profile = '+inttostr(strtoint(getcurrentprofileid))+' ORDER BY Favorite DESC , Description');
Datamodule1.Qaux.Open;

for x:=0 to 9 do begin
  (FindComponent('Emu'+inttostr(x)) as Tmenuitem).Visible:=false;
  (FindComponent('Emu'+inttostr(x)) as Tmenuitem).OnClick:=emuclick;
end;

if masterlv.rootnodecount<>0 then
for x:=0 to Datamodule1.Qaux.RecordCount-1 do begin

  ico:=Ticon.Create;
  bmp:=Tbitmap.Create;
  bmp.canvas.Brush.Color:=clbtnface;

  if FileExists2(getwiderecord(Datamodule1.Qaux.fieldbyname('Path'))) then begin

    ico.Handle:=ExtractAssociatedIconw(
    hInstance,
    Pwidechar(getwiderecord(Datamodule1.Qaux.fieldbyname('Path'))),
    Filter);

    bmp.Height:=ico.Height;
    bmp.Width:=ico.Width;
    bmp.Canvas.Draw(0,0,ico);
    bmp.Canvas.StretchDraw(r,bmp);
    bmp.Height:=16;
    bmp.Width:=16;

    (FindComponent('Emu'+inttostr(x)) as Tmenuitem).Bitmap:=bmp;
    (FindComponent('Emu'+inttostr(x)) as Tmenuitem).Visible:=true;
    (FindComponent('Emu'+inttostr(x)) as Tmenuitem).Caption:=UTF8Encode(getwiderecord(Datamodule1.Qaux.fieldbyname('Description')));
    (FindComponent('Emu'+inttostr(x)) as Tmenuitem).Tag:=Datamodule1.Qaux.fieldbyname('ID').asinteger;

    added:=added+1;
  end;

  ico.Free;
  bmp.free;

  Datamodule1.Qaux.Next;
end;

N12.Visible:=true;
N11.Visible:=true;

if added=0 then begin
  N12.Visible:=false;
  N11.Visible:=false;
end
else
if added=1 then
  N11.Visible:=false;

Datamodule1.Qaux.Close;
end;

procedure Tfmain.showprofilestotalpanel(total:longint);
begin
panel9.Caption:=traduction(24);
panel9.Caption:=panel9.Caption+' '+fillwithzeroes(inttostr(VirtualStringTree2.RootNodeCount),4);
panel9.Caption:=panel9.Caption+' ';
panel9.Caption:=panel9.Caption+'/';
panel9.Caption:=panel9.Caption+' ';
panel9.Caption:=panel9.Caption+fillwithzeroes(inttostr(total),4);
end;

procedure Tfmain.deletetab(id:ansistring);
begin
if (Datamodule1.FindComponent('DB'+id) as TABSDatabase)<>nil then begin

  panel25.Visible:=false;
  panel25.Parent:=VirtualStringTree1;
  panel35.Visible:=false;
  panel35.Parent:=VirtualStringTree3;

  (FindComponent('CLONE_Panel23_'+id) as TTntpanel).free;
  (Datamodule1.FindComponent('TM'+id) as Tabstable).free;
  (Datamodule1.FindComponent('TD'+id) as Tabstable).free;
  (Datamodule1.FindComponent('DB'+id) as TABSDatabase).free;
  (FindComponent('CLONE_Tabsheet7_'+id) as TTnttabsheet).free;
  deletefile2(tempdirectorymasterdetail(id));

end;

end;

procedure Tfmain.addprofilesfielddefs(T:Tabstable);
begin
  T.FieldDefs.Add('Description',ftwidestring,255,true);
  T.FieldDefs.Add('Name',ftwidestring,255,true);
  T.FieldDefs.Add('Havesets',ftLargeint,0,false);
  T.FieldDefs.Add('Haveroms',ftLargeint,0,false);
  T.FieldDefs.Add('Version',ftwidestring,255,false);
  T.FieldDefs.Add('Filemode',ftString,1,true);
  T.FieldDefs.Add('Date',ftwidestring,255,false);
  T.FieldDefs.Add('Author',ftwidestring,255,false);
  T.FieldDefs.Add('Category',ftwidestring,255,false);
  T.FieldDefs.Add('Lastscan',ftDateTime,0,false);
  T.FieldDefs.Add('Homeweb',ftwidestring,255,false);
  T.FieldDefs.Add('Email',ftwidestring,255,false);
  T.FieldDefs.Add('Totalsets',ftLargeint,0,false);
  T.FieldDefs.Add('Totalroms',ftLargeint,0,false);
  T.FieldDefs.Add('Added',ftDateTime,0,false);
  T.FieldDefs.Add('Original',ftString,1,true);
  T.FieldDefs.Add('Tree',ftLargeint,0,true);
  T.FieldDefs.Add('Shared',ftBoolean,0,false);
end;

function TFmain.getcurrentprofileid():ansistring;
begin
try
  Result:=gettoken(PageControl2.ActivePage.Name,'_',3)
except
  Result:='';
end;
end;

procedure Tfmain.showprofilesselected;
begin
panel17.Caption:=traduction(23)+' '+inttostr(VirtualStringTree2.SelectedCount);
end;

procedure Tfmain.processnewdatshowresults();
begin

if (sterrors.Count=0) then
  mymessageinfo(inttostr(imported)+' '+traduction(50))
else begin
  sterrors.Add('');
  sterrors.Add(inttostr(imported)+' '+traduction(50));
  mymessagewarning(sterrors.Text);
end;

sterrors.Clear;
end;

procedure TFmain.processnewdat(path:widestring);
var
ext:widestring;
i,r:longint;
id:longint;
p,aux:widestring;
comptype:smallint;
begin
comptype:=0;

initializeextractionfolders;

Application.ProcessMessages;//0.029

if Not FileExists2(path) then
  exit;

try
  if formexists('Fprocessing') then begin
    Fprocessing.panel3.Caption:=traduction(61)+' : ';
    Fprocessing.panel3.Caption:=Fprocessing.panel3.Caption+traduction(71);
  end;
except
end;

ext:=WideUpperCase(WideExtractFileExt(path));

Gettreepath(treeview1.Selected,p);

id:=0;

if formexists('Fupdater')=false then //0.046 FORZE ALWAYS DEFAULT TREE WHEN AUTOUPDATER
if p<>'' then
  if DataModule1.TTree.Locate('Path',p,[loCaseInsensitive])=true then
    id:=DataModule1.TTree.fieldbyname('ID').AsInteger;

if FileInUse(path)=true then
  adderror(traduction(180)+' '+path)
else
if (ext='.ZIP') OR (ext='.RAR') OR (ext='.7Z') then begin

  if zipvalidfile(path,zip1) then
    comptype:=1
  else
  if rarvalidfile(path,rar1) then
    comptype:=2
  else
  if sevenzipvalidfile(path,sevenzip1) then
    comptype:=3
  else
    adderror(traduction(55)+' '+path);

  if comptype<>0 then

    for i:=0 to stcompfiles.Count-1 do begin

      if formexists('Fprocessing') then
        if Fprocessing.Tag=1 then
          break
        else
        if stcompfiles.Count>1 then
          Fprocessing.SpeedButton1.Enabled:=true;

      if stcompfiles.Strings[i][Length(stcompfiles.Strings[i])]<>'\' then //Ignore folders in zipfiles

        if (wideuppercase(wideExtractFileExt(stcompfiles.Strings[i]))='.DAT') OR (wideuppercase(wideExtractFileExt(stcompfiles.Strings[i]))='.XML') OR (wideuppercase(wideExtractFileExt(stcompfiles.Strings[i]))='.HSI') then begin

          try

            aux:=gettoken(stcompfiles.Strings[i],'\',GetTokenCount(stcompfiles.Strings[i],'\'));
            try
              if formexists('Fprocessing') then begin
                Fprocessing.panel2.Caption:=changein(aux,'&','&&');
                Fprocessing.repaint;
              end;
            except
            end;

            case comptype of
              1:if extractfilefromzip(zip1,stcompfiles.Strings[i],tempdirectoryextract,false)=false then
                  makeexception;
              2:if extractfilefromrar(rar1,stcompfiles.Strings[i],tempdirectoryextract,false)=false then
                  makeexception;
              3:if extractfilefromsevenzip(sevenzip1,stcompfiles.Strings[i],tempdirectoryextract,false)=false then
                  makeexception;
            end;

            try
              formatxmlthread(tempdirectoryextract+aux); //0.034
            except
            end;

            r:=importdat(tempdirectoryextract+aux,id);

            if r=3 then begin //EMPTY SETS DAT WARNING
              adderror(traduction(328)+' '+Changein(path+' > '+stcompfiles.Strings[i],'/','\'))
            end
            else
            if r=1 then
              imported:=imported+1
            else
            if r=0 then
              adderror(traduction(51)+' '+Changein(path+' > '+stcompfiles.Strings[i],'/','\'))
            else //RES2
              adderror(traduction(52)+' '+Changein(path+' > '+stcompfiles.Strings[i],'/','\'));

          except
            adderror(traduction(53)+' '+path+' > '+stcompfiles.Strings[i]);
          end;

          //Delete extracted and processed datfile
          deletefile2(tempdirectoryextract+aux);
        end
        else //Unknow extension
          adderror(traduction(54)+' '+path+' > '+stcompfiles.Strings[i])

    end;//FOR

end
else
if (ext='.DAT') OR (ext='.XML') OR (ext='.HSI') then begin

  try
    if formexists('Fprocessing') then begin
      Fprocessing.panel2.Caption:=changein(wideextractfilename(path),'&','&&');
      Fprocessing.repaint;
    end;
  except
  end;

  //0.034 move to temp to format it
  {recover:=false;
  movepath:=tempdirectoryresources+WideExtractFileName(path);
  if WideUpperCase(movepath)<>WideUpperCase(path) then
    deletefile2(movepath)
  else begin
    movepath:=getvaliddestination(movepath);
    recover:=true;
  end;   }//0.046 REMOVED

  try
    formatxmlthread(path);
  except
  end;

  r:=importdat(path,id); //ADDED 0.046

  if r=1 then
    imported:=imported+1
  else
  if r=3 then begin //EMPTY SETS DAT WARNING
    adderror(traduction(328)+' '+path);
  end
  else
    if r=0 then
      adderror(traduction(51)+' '+path)
    else
      adderror(traduction(52)+' '+path);

end
else
  adderror(traduction(54)+' '+path);

closepossiblyopenzip;//0.035
initializeextractionfolders;

stcompfiles.Clear;
end;

function findfathernode(n:TTnttreenode):TTnttreenode;
var
lv:longint;
begin
lv:=n.Level;

if lv=0 then
  n:=nil
else
  while n.Level>=lv do
    n:=n.GetPrev;

result:=n;
end;

function TFmain.nodepathexists(tv:TTnttreeview;path:widestring):TTnttreenode;
var
x,y:longint;
found:boolean;
cur:widestring;
n:TTnttreenode;
res:TTnttreenode;
begin
found:=true;
n:=nil;


for x:=0 to GetTokenCount(path,'\')-1 do begin //Folder by folder

  if found=false then
    break;

  cur:=gettoken(path,'\',x+1);
  cur:=wideuppercase(cur);

  if cur='' then break;

  found:=false;

  for y:=0 to tv.Items.Count-1 do
    if (tv.Items.Item[y].Level=x) AND (wideuppercase(tv.Items.Item[y].Text)=cur) then
      if findfathernode(tv.Items.Item[y])=n then begin
        found:=true;
        n:=tv.Items.Item[y];
        break; //Founded node get next
      end;


end;

if found=false then
  res:=nil
else
  res:=n;

Result:=res;

end;

function TFmain.Gettreepath(pTreeNode: TTnttreenode; var path: widestring): widestring;
begin
if (pTreeNode=treeview1.Items.Item[0]) OR ((pTreeNode=treeview1.Items.Item[1])) then //Never return correct in this nodes always nil
  Result:=''
else
if pTreeNode<>nil then begin
  path := pTreeNode.Text + '\' + path;
  if pTreeNode.Level = 0 then Result := path
  else
    Result := Gettreepath(pTreeNode.Parent, path);
end
else
  Result:='';

end;

Procedure TFmain.MoveNode(TargetNode, SourceNode : TTnttreenode);
var
  nodeTmp, nodeaux : TTnttreenode;
  i : longint;
  path,path2:widestring;
begin

  with treeview1 do
  begin

    if (targetnode=treeview1.Items.Item[0]) OR ((targetnode=treeview1.Items.Item[1])) then
      targetnode:=nil; //Moving to default folders = move to root

    path:='';

    gettreepath((targetnode as TTntTreeNode),path);
    path:=path+(SourceNode as TTnttreenode).Text;//Check if already exists
    path:=checkpathbar(path);
    nodeaux:=nodepathexists(treeview1,path);

    path2:='';
    Gettreepath((sourcenode as TTnttreenode),path2);
    path2:=checkpathbar(path2);

    if nodeaux<>nil then begin //Node exists
      nodeTmp:=nodeaux;

      if DataModule1.TTree.Locate('Path',path,[loCaseInsensitive])=true then begin

        i:=Datamodule1.TTree.fieldbyname('ID').asinteger;
        if Datamodule1.TTree.locate('Path',path2,[loCaseInsensitive])=true then begin

          While Datamodule1.Tprofiles.Locate('Tree',DataModule1.TTree.fieldbyname('ID').AsInteger,[]) do begin
            Datamodule1.Tprofiles.edit;
            Datamodule1.Tprofiles.fieldbyname('Tree').asinteger:=i;
            Datamodule1.Tprofiles.post;
          end;

          DataModule1.TTree.Delete;

        end;

      end;

    end
    else begin

      nodeTmp := Items.AddChild((TargetNode as TTnttreenode),(SourceNode as TTnttreenode).Text);
      if DataModule1.TTree.Locate('Path',path2,[loCaseInsensitive])=true then begin
        DataModule1.Ttree.Edit;
        setwiderecord(DataModule1.Ttree.fieldbyname('Path'),path);
        DataModule1.Ttree.post;
      end;
    end;

    nodetmp.ImageIndex:=30;
    nodetmp.SelectedIndex:=31;

    //Move subnodes
    for i := 0 to SourceNode.Count -1 do
    begin
      MoveNode(nodeTmp,SourceNode.Item[i])
    end;
    end;

end;

procedure Tfmain.createorloaddatabase(filename:widestring;forcecreate:boolean);
var
T:Tabstable;
aux,aux2,filename2:widestring;
n,n2:Ttnttreenode;
x:longint;
pass,isreadonly:boolean;
begin

if Fserver.IdTCPClient1.connected=true then begin
  mymessagewarning(traduction(564));
  exit;
end;

ChDir(tempdirectoryresources);
pass:=true;
Dbcheck:=Tabsdatabase.Create(datamodule1);

Dbcheck.SilentMode:=true;
Dbcheck.MaxConnections:=defmaxconnections;
Dbcheck.DatabaseName:='TMP';
Dbcheck.OnNeedRepair:=Datamodule1.DBDatabase.OnNeedRepair;//Ignore repair

filename2:=filename;

filename:=checkpathcase(filename);//Fix case

if (filename='') then
  filename2:=WideExtractfilepath(Tntapplication.ExeName)+'default.rml';

try //Check is valid RML database

  if forcecreate=true then
    makeexception;

  if wideuppercase(UTF8Decode(DataModule1.DBdatabase.DatabaseFileName))=wideuppercase(filename2) then begin
    mymessagewarning(traduction(56)+#10#13+filename2);
    pass:=false;
  end
  else begin
    isreadonly:=FileInUse(filename2);

    Dbcheck.DatabaseFileName:=UTF8Encode(filename2);
    Dbcheck.Open;

    if (Dbcheck.ReadOnly=true) OR (isreadonly=true) then begin

      mymessageerror(traduction(57)+#10#13+filename2);

      if DataModule1.DBdatabase.Connected=false then begin
        application.Terminate;
        exit;
      end;

    end
    else
    if isdbcorrectversion(Dbcheck)=true then begin

      DataModule1.DBDatabase.Close;
      DBcheck.Close;
      DataModule1.DBDatabase.DatabaseFileName:=UTF8Encode(filename2);
      DataModule1.DBDatabase.Open;

      try //SINCE 0.009version
        Datamodule1.Qaux.Close;
        Datamodule1.Qaux.sql.clear;
        Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles ADD (Header WIDESTRING(255))');
        Datamodule1.Qaux.ExecSQL;
      except
      end;

      try //SINCE 0.009version
        Datamodule1.Qaux.Close;
        Datamodule1.Qaux.sql.clear;
        Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles ADD (T7Z LOGICAL)');
        Datamodule1.Qaux.ExecSQL;
      except
      end;

      //SINCE 0.013 SAVE ASK DECISIONS
      for x:=0 to 6 do begin
        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.sql.clear;
          Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles ADD (FIX'+inttostr(x)+' VARCHAR(1))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;
      end;

      try //SINCE 0.017version
        Datamodule1.Qaux.Close;
        Datamodule1.Qaux.sql.clear;
        Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles ADD (Shared LOGICAL)');
        Datamodule1.Qaux.ExecSQL;
      except
      end;

      try //SINCE 0.023version
        Datamodule1.Qaux.Close;
        Datamodule1.Qaux.sql.clear;
        Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles ADD (Hasroms LOGICAL)');
        Datamodule1.Qaux.ExecSQL;
      except
      end;
      try //SINCE 0.023version
        Datamodule1.Qaux.Close;
        Datamodule1.Qaux.sql.clear;
        Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles ADD (Hassamples LOGICAL)');
        Datamodule1.Qaux.ExecSQL;
      except
      end;

      try //SINCE 0.023version
        Datamodule1.Qaux.Close;
        Datamodule1.Qaux.sql.clear;
        Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles ADD (Haschds LOGICAL)');
        Datamodule1.Qaux.ExecSQL;
      except
      end;

      try //SINCE 0.018version
        Datamodule1.Qaux.Close;
        Datamodule1.Qaux.sql.clear;
        Datamodule1.Qaux.sql.Add('ALTER TABLE Tree ADD (Expanded LOGICAL)');
        Datamodule1.Qaux.ExecSQL;
      except
      end;

      try //SINCE 0.037 Offlinelist description mask
        Datamodule1.Qaux.Close;
        Datamodule1.Qaux.sql.clear;
        Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles ADD (Descmask WIDESTRING(255))');
        Datamodule1.Qaux.ExecSQL;
      except
      end;

      //SINZE 0.021 WIDESTRING
      Datamodule1.Tprofiles.Open;

      if  Datamodule1.Tprofiles.FieldByName('Header').DataType<>ftWideString then begin

        try //SINCE 0.032
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.sql.clear;
          Datamodule1.Qaux.sql.Add('ALTER TABLE Profiles MODIFY (Header widestring(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

      end;

      if Datamodule1.Tprofiles.FieldByName('Homeweb').DataType<>ftWideString then begin

        Datamodule1.Tprofiles.close;

        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Profiles MODIFY (Description WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Profiles MODIFY (Name WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Profiles MODIFY (Version WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Profiles MODIFY (Date WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Profiles MODIFY (Author WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Profiles MODIFY (Category WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Profiles MODIFY (Email WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Profiles MODIFY (Homeweb WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;

      end;

      Datamodule1.TTree.Open; //SINZE 0.021
      if Datamodule1.TTree.FieldByName('Path').DataType<>ftWideString then begin
        Datamodule1.TTree.close;
        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Tree MODIFY (Path WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;
      end;

      Datamodule1.Temulators.Open;
      if Datamodule1.Temulators.FieldByName('Param').DataType<>ftwidestring then begin
        Datamodule1.Temulators.close;
        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Emulators MODIFY (Description WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;
        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Emulators MODIFY (Path WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;
        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Emulators MODIFY (Param WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;
      end;

      Datamodule1.Tdirectories.Open;
      if Datamodule1.Tdirectories.FieldByName('Path').DataType<>ftwidestring then begin
        Datamodule1.Tdirectories.close;
        try
          Datamodule1.Qaux.Close;
          Datamodule1.Qaux.SQL.Clear;
          Datamodule1.Qaux.SQL.Add('ALTER TABLE Directories MODIFY (Path WIDESTRING(255))');
          Datamodule1.Qaux.ExecSQL;
        except
        end;
      end;

    end
    else begin//ABSDatabase but not for Romulus
      mymessageerror(traduction(58)+#10#13+filename2);
      if DataModule1.DBdatabase.Connected=false then begin
        application.Terminate;
        exit;
      end;
    end;
  end;//Databasefilename=filename2
except begin

  if FileExists2(filename2) then begin

    if forcecreate=false then begin

      mymessageerror(traduction(58)+#10#13+filename2);
      if DataModule1.DBdatabase.Connected=false then begin
        application.Terminate;
        exit;
      end;

      pass:=false;
    end
    else begin //Answer overwrite
      if wideuppercase(UTF8Decode(DataModule1.DBdatabase.DatabaseFileName))=wideuppercase(filename2) then begin
        mymessagewarning(traduction(56)+#10#13+filename2);
        pass:=false;
      end
      else begin
        sterrors.Clear;
        sterrors.Add(traduction(59));
        sterrors.add(filename2);
        if mymessagequestion(sterrors.Text,false)<>1 then
          pass:=false;
        sterrors.Clear;
      end;
    end;

  end
  else begin
    if forcecreate=false then begin
      mymessageinfo(traduction(60)+#10#13+filename2);
    end;
  end;

  if pass=true then begin
    try

    filename:='';
    if isunicodefilename(filename2) then begin
      filename:=filename2;
      filename2:=tempdirectoryresources+'new.rmt';
    end;

    DBCheck.Close;
    DBCheck.DatabaseFileName:=UTF8Encode(filename2);
    Dbcheck.PageCountInExtent:=defpagecountinextent;
    Dbcheck.PageSize:=defpagesize;
    DBCheck.CreateDatabase;


    //Path tree
    T:=Tabstable.Create(DataModule1);
    T.DatabaseName:=DBCheck.DatabaseName;
    T.FieldDefs.Clear;
    T.TableName:='Tree';
    T.FieldDefs.Add('ID',ftAutoInc,0,False);
    T.FieldDefs.Add('Path',ftWideString,256,true);
    T.FieldDefs.Add('Expanded',ftBoolean,0,false);

    T.IndexDefs.Clear;
    T.IndexDefs.Add('TreeI1', 'ID', [ixPrimary]); //Speedup locate
    T.IndexDefs.Add('TreeI2', 'Path', []);
    T.CreateTable;
    T.Free;

    //Emulators
    T:=Tabstable.Create(DataModule1);
    T.DatabaseName:=DBCheck.DatabaseName;
    T.FieldDefs.Clear;
    T.TableName:='Emulators';
    T.FieldDefs.Add('ID',ftAutoInc,0,False);
    T.FieldDefs.Add('Description',ftwidestring,50,true);
    T.FieldDefs.Add('Path',ftWideString,255,true);
    T.FieldDefs.Add('Param',ftWideString,255,true);
    T.FieldDefs.Add('Profile',ftInteger,0,true);
    T.FieldDefs.Add('Favorite',ftBoolean,0,true);
    T.FieldDefs.Add('DOS',ftBoolean,0,true);

    T.IndexDefs.Clear;
    T.IndexDefs.Add('I', 'ID', [ixPrimary]); //Speedup locate
    T.IndexDefs.Add('I2', 'Profile;Favorite', []);
    T.CreateTable;
    T.Free;

    //Profiles list
    T:=Tabstable.Create(DataModule1);
    T.DatabaseName:=DBCheck.DatabaseName;
    T.FieldDefs.Clear;
    T.TableName:='Profiles';
    T.FieldDefs.Add('ID',ftAutoInc,0,False);
    addprofilesfielddefs(T);
    T.FieldDefs.Add('splitmerge',ftBoolean,0,true);
    T.FieldDefs.Add('splitnomerge',ftBoolean,0,true);
    T.FieldDefs.Add('MD5',ftBoolean,0,true);
    T.FieldDefs.Add('SHA1',ftBoolean,0,true);
    T.FieldDefs.Add('TZ',ftBoolean,0,true);
    T.FieldDefs.Add('IMG',ftBoolean,0,true);
    T.FieldDefs.Add('Header',ftwidestring,255,false);
    T.FieldDefs.Add('T7Z',ftBoolean,0,false);

    //SINCE 0.013
    for x:=0 to 6 do
      T.FieldDefs.Add('FIX'+inttostr(x),ftString,1,false);

    T.FieldDefs.Add('Hasroms',ftBoolean,0,false);
    T.FieldDefs.Add('Hassamples',ftBoolean,0,false);
    T.FieldDefs.Add('Haschds',ftBoolean,0,false);

    //SINCE 0.037
    T.FieldDefs.Add('Descmask',ftwidestring,255,false);

    T.IndexDefs.Clear;
    T.IndexDefs.Add('ProfilesI1', 'ID', [ixPrimary]); //Speedup locate
    T.IndexDefs.Add('ProfilesI2', 'Tree', []);
    T.IndexDefs.Add('ProfilesI3', 'Name', [ixCaseInsensitive]);

    T.CreateTable;

    T.free;

    //Directories list
    T:=Tabstable.Create(DataModule1);
    T.DatabaseName:=DBCheck.DatabaseName;
    T.FieldDefs.Clear;
    T.TableName:='Directories';
    T.FieldDefs.Add('ID',ftAutoInc,0,False);
    T.FieldDefs.Add('Path',ftWideString,255,false);
    T.FieldDefs.Add('Profile',ftLargeint,0,true);
    T.FieldDefs.Add('Type',ftstring,1,true);
    T.FieldDefs.Add('Compression',ftSmallint,0,true);

    T.IndexDefs.Clear;
    T.IndexDefs.Add('DirectoriesI1', 'ID', [ixPrimary]); //Speedup locate
    T.IndexDefs.Add('DirectoriesI2', 'Profile;Type', []);

    T.CreateTable;
    T.free;

    DBCheck.Open;
    DBCheck.close;

    if filename<>'' then begin
      if movefile2(filename2,filename)=false then
        makeexception;

      filename2:=filename;
    end;

    Datamodule1.DBDatabase.DatabaseFileName:=UTF8Encode(filename2);
    Datamodule1.DBDatabase.Open;
    except
      if filename<>'' then
        filename2:=filename;

      mymessageerror(traduction(104)+#10#13+filename2);
      if Datamodule1.DBDatabase.Connected=false then
        Application.Terminate;

      pass:=false;
    end;

  end;//Pass
end;
end;//Except

//Load tree
if pass=true then begin

  treeview1.tag:=1;
  VirtualStringTree2.BeginUpdate;
  VirtualStringTree2.RootNodeCount:=0;
  VirtualStringTree2.EndUpdate;
  VirtualStringTree2.repaint;

  treeview1.Items.BeginUpdate;
  treeview1.Items.Clear;

  DataModule1.TTree.Open;
  DataModule1.TTree.First;

  DataModule1.Tprofiles.Open;
  DataModule1.Tdirectories.Open;

  n:=treeview1.Items.AddChild(nil,'<  '+traduction(36)+'  >');
  n.ImageIndex:=32;
  n.SelectedIndex:=33;
  n:=treeview1.Items.AddChild(nil,'<  '+traduction(37)+'  >');
  n.ImageIndex:=32;
  n.SelectedIndex:=33;


  While not DataModule1.TTree.Eof do begin

    aux:=getwiderecord(DataModule1.TTree.fieldbyname('Path'));

    aux2:='';
    n:=nil;

    for x:=1 to GetTokenCount(aux,'\') do begin

      if gettoken(aux,'\',x)<>'' then begin

        aux2:=aux2+GetToken(aux,'\',x);

        n2:=nodepathexists(treeview1,aux2);

        if n2=nil then begin
          n:=treeview1.Items.AddChild(n,GetToken(aux,'\',x));
          n.ImageIndex:=30;
          n.SelectedIndex:=31;
        end
        else
          n:=n2;

        aux2:=aux2+'\';

      end;

    end;//for

    DataModule1.TTree.Next;
  end;//While eof

  for x:=2 to TreeView1.Items.Count-1 do begin
    aux:='';
    Gettreepath(treeview1.Items.Item[x],aux);
    if Datamodule1.TTree.Locate('Path',aux,[]) then
      Treeview1.Items.Item[x].Expanded:=Datamodule1.TTree.fieldbyname('Expanded').asboolean;
  end;

  deleteallscantabs;

  currentdbstatusname;

  TreeView1.AlphaSort(true);
  TreeView1.AlphaSort(false);
  Treeview1.Items.EndUpdate;

  Treeview1.Items.Item[0].Selected:=true;
  treeview1.tag:=0;

  showprofiles(true);

end;//pass

treeview1.tag:=0;
showprofilesselected;
Dbcheck.Free;
end;

procedure Tfmain.editnode(n:Ttnttreenode;new:widestring);
var
path,aux,res:widestring;
x,y,lv:longint;
found:boolean;
begin
Gettreepath(n,path);

DataModule1.Qaux.Close;
DataModule1.Qaux.SQL.Clear;

DataModule1.Qaux.SQL.Add('SELECT * FROM Tree WHERE Upper(Path) LIKE Upper('+':p_'+')');

Datamodule1.Qaux.Params.Clear;
Datamodule1.Qaux.Params.CreateParam(ftWideString,'p_',ptResult);

Datamodule1.Qaux.Params[0].DataType := ftWideString;
Datamodule1.Qaux.Params[0].Value:=path+'%';

DataModule1.Qaux.Open;

for x:=0 to DataModule1.Qaux.RecordCount-1 do begin

  DataModule1.TTree.Locate('ID',DataModule1.Qaux.fieldbyname('ID').asinteger,[]);
  aux:=getwiderecord(DataModule1.TTree.fieldbyname('path'));
  res:='';
  lv:=0;
  found:=false;

  for y:=1 to length(aux) do begin

    if (lv=n.level) then begin

      if found=false then
        res:=res+new;

      if (aux[y]='\') then begin
        lv:=lv+1;
        res:=res+'\';
      end;

      found:=true;

    end
    else
    if (aux[y]<>'\') then
      res:=res+aux[y]
    else begin
      lv:=lv+1;
      res:=res+'\';
    end;

  end;
  res:=checkpathbar(res);

  DataModule1.Ttree.Edit;
  setwiderecord(DataModule1.Ttree.fieldbyname('Path'),res);
  DataModule1.Ttree.Post;

  DataModule1.Qaux.next;
end;

DataModule1.Qaux.close;
end;

procedure Tfmain.deletenode(n:TTnttreenode);
var
path,aux:widestring;
x:longint;
id:longint;
Q,Q2,Q3:Tabsquery;
begin
Gettreepath(n,path);

Q:=Tabsquery.Create(self);
Q.RequestLive:=false;//IMPORTANT
Q.DatabaseName:='RML_DATA';
Q2:=Tabsquery.Create(self);
Q2.RequestLive:=false;//IMPORTANT
Q2.DatabaseName:='RML_DATA';
Q3:=Tabsquery.Create(self);
Q3.RequestLive:=false;//IMPORTANT
Q3.DatabaseName:='RML_DATA';

Q2.SQL.Clear;

Q2.SQL.Add('SELECT * FROM Tree WHERE Upper(Path) LIKE Upper('+':p_'+') ORDER BY Path DESC');

Q2.Params.Clear;
Q2.params.CreateParam(ftWideString,'p_',ptResult);

Q2.Params[0].DataType := ftWideString;
Q2.Params[0].Value:=path+'%';

Q2.Open;
Q2.first;

for x:=0 to Q2.RecordCount-1 do begin

  if Fprocessing.Tag=1 then
    break;

  application.processmessages;

  id:=Q2.fieldbyname('ID').asinteger;

  Q3.close;
  Q3.sql.clear;
  Q3.sql.add('SELECT * FROM Profiles');
  Q3.sql.Add('WHERE Tree = '+inttostr(id));
  Q3.sql.Add('ORDER BY Description');

  Q3.Open;
  Q3.First;

  while not Q3.eof do begin

    if Fprocessing.Tag=1 then
      break;

    Datamodule1.Tprofiles.Locate('ID',Q3.fieldbyname('ID').AsInteger,[]);

    Fprocessing.panel2.Caption:=changein(getwiderecord(Datamodule1.Tprofiles.Fieldbyname('Description')),'&','&&');
    Fprocessing.repaint;

    //And table datacontent delete too
    Datamodule1.Qaux.close;
    Datamodule1.Qaux.sql.Clear;
    aux:=fillwithzeroes(DataModule1.Tprofiles.fieldbyname('ID').asstring,4);

    DataModule1.Tprofiles.Delete;

    Datamodule1.Qaux.SQL.Add('DROP TABLE Y'+aux+';');

    BMDThread1.Start();
    waitforfinishthread;

    Datamodule1.Qaux.close;
    Datamodule1.Qaux.SQL.Clear;

    Datamodule1.Qaux.SQL.Add('DROP TABLE Z'+aux+';');

    BMDThread1.Start();
    waitforfinishthread;

    Datamodule1.Qaux.close;
    Datamodule1.Qaux.SQL.Clear;

    //Delete alread exist tab to delete
    deletetab(aux);

    While Datamodule1.TDirectories.Locate('Profile',strtoint(aux),[])=true do
      Datamodule1.TDirectories.Delete;//Already delete his Directories

    showprolesmasterdetail(false,false,getcurrentprofileid,true,true);//BUGFIX

    Q3.Next;

    application.processmessages;
  end;

  if Fprocessing.Tag=1 then
    break;

  DataModule1.Ttree.locate('ID',Q2.fieldbyname('ID').asinteger,[]);

  n:=nodepathexists(treeview1,getwiderecord(DataModule1.Ttree.fieldbyname('Path')));
  DataModule1.Ttree.delete;//Delete Folder in DB

  if n<>nil then begin//Delete folder in tree
    treeview1.Items.BeginUpdate;
    treeview1.Items.Delete(n);
    treeview1.Items.EndUpdate;
  end;

  Q2.Next;
end;

refreshallfaces;//0.044

Q.Free;
Q2.Free;
Q3.Free;
end;

procedure Tfmain.showprofiles(progress:boolean);
var
path:widestring;
id,total,totalshared,viewshared:longint;
x:longint;
aux,aux2,a,b,c,d:ansistring;
w,o,open:boolean;
s:Tspeedbutton;
T:Tabstable;
begin

if treeview1.Tag=1 then //BUGFIX
  exit;

savefocussedcontrol;

a:='0000';
b:='0000';
c:='0000';
d:='0000';
total:=0;
totalshared:=0;
viewshared:=0;


if progress=true then begin
  showprocessingwindow(false,false); //CAN NOT BE IMPLEMENTED
  Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(62);
  Fprocessing.Panel2.Caption:=changein(treeview1.Selected.Text,'&','&&');
end;

s:=nil;
open:=false;

removedatabaseinconsistences;//SINZE 0.017

//Always check if ID 0 exists for root
if Datamodule1.TTree.Locate('ID',0,[])=false then begin
  Datamodule1.TTree.Append;
  Datamodule1.TTree.FieldByName('ID').AsInteger:=0;
  setwiderecord(Datamodule1.TTree.FieldByName('Path'),'\');
  Datamodule1.TTree.Post;
end
else begin
  Datamodule1.TTree.edit;
  setwiderecord(Datamodule1.TTree.FieldByName('Path'),'\');
  Datamodule1.TTree.Post;
end;


aux:='';

if (speedbutton1.Down=false) AND (speedbutton3.Down=false) AND (speedbutton4.Down=false) AND (speedbutton5.Down=false) then begin
  CenterInClient(panel32,panel20);
  panel32.visible:=true;
  VirtualStringTree2.RootNodeCount:=0;
  VirtualStringTree2.Repaint;
end
else begin
  id:=0;
  w:=False;
  o:=false;
  panel32.visible:=false;

  total:=DataModule1.Tprofiles.RecordCount;

  if (treeview1.Selected<>treeview1.Items.Item[1]) then begin
    Gettreepath(treeview1.Selected,path);
    if DataModule1.TTree.Locate('path',path,[loCaseInsensitive])=true then
      id:=Datamodule1.TTree.fieldbyname('ID').asinteger;
  end;

  if (treeview1.Selected<>treeview1.Items.Item[0]) then begin

    if (treeview1.Selected<>treeview1.Items.Item[1]) AND (treeview1.Selected<>treeview1.Items.Item[0]) AND (Activaterecursive1.Checked=true) then begin
      aux:='WHERE Profiles.Tree=Tree.id AND Upper(Path) LIKE Upper('+':p_'+')';
    end
    else
      aux:='WHERE Tree = '+inttostr(id);

    w:=true;
  end;

  for x:=0 to 3 do begin //Status count

    application.processmessages;

    DataModule1.Qaux.Close;
    DataModule1.Qaux.SQL.Clear;

    case x of
      0:aux2:='Haveroms = Totalroms';
      1:aux2:='Haveroms > 0 AND Haveroms < Totalroms';
      2:aux2:='Haveroms = 0';
      3:aux2:='Haveroms = '+''''+'''';
    end;

    if w=true then
      aux2:='AND '+aux2
    else
      aux2:='WHERE '+aux2;

    if (treeview1.Selected<>treeview1.Items.Item[1]) AND (treeview1.Selected<>treeview1.Items.Item[0]) AND (Activaterecursive1.Checked=true) then
      Datamodule1.Qaux.SQL.Add('SELECT COUNT(Profiles.ID) FROM Profiles,Tree')
    else
      Datamodule1.Qaux.SQL.Add('SELECT COUNT(ID) FROM Profiles');

    Datamodule1.Qaux.SQL.Add(aux);
    Datamodule1.Qaux.SQL.Add(aux2);

    Datamodule1.Qaux.Params.Clear;
    Datamodule1.Qaux.Params.CreateParam(ftWideString,'p_',ptResult);

    Datamodule1.Qaux.Params[0].DataType := ftWideString;
    Datamodule1.Qaux.Params[0].Value:=path+'%';

    BMDThread1.Start();
    waitforfinishthread;

    case x of
      0:a:=fillwithzeroes(Datamodule1.Qaux.Fields[0].asstring,4);
      1:b:=fillwithzeroes(Datamodule1.Qaux.Fields[0].asstring,4);
      2:c:=fillwithzeroes(Datamodule1.Qaux.Fields[0].asstring,4);
      3:d:=fillwithzeroes(Datamodule1.Qaux.Fields[0].asstring,4);
    end;

  end;

  application.processmessages;

  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;

  Datamodule1.Qaux.SQL.Add('SELECT * FROM Profiles WHERE Shared=True');
  BMDThread1.Start();
  waitforfinishthread;

  totalshared:=Datamodule1.Qaux.RecordCount;

  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;

  Datamodule1.Qaux.SQL.Add('SELECT * FROM Profiles,Tree');

  if (treeview1.Selected<>treeview1.Items.Item[1]) AND (treeview1.Selected<>treeview1.Items.Item[0]) AND (Activaterecursive1.Checked=true) then begin
    aux:='WHERE Upper(Path) LIKE Upper('+':p_'+')';
  end;

  Datamodule1.Qaux.SQL.Add(aux);

  aux:='';
  if w=true then
    aux:='AND '+aux
  else
    aux:='WHERE '+aux;

  Datamodule1.Qaux.SQL.Add(aux+'Profiles.tree=Tree.id');
  w:=true;

  if (speedbutton1.Down=false) OR (speedbutton3.Down=false) OR (speedbutton4.Down=false) OR (speedbutton5.Down=false) then begin
    for x:=0 to 3 do begin

      aux:='';

      case x of
        0:s:=speedbutton1;
        1:s:=speedbutton3;
        2:s:=speedbutton4;
        3:s:=speedbutton5;
      end;

      if s.Down=true then begin

        if o=false then begin

          if w=false then
            aux:='WHERE ('
          else
            aux:='AND (';

          w:=true;
          o:=true;
          open:=true;
        end
        else
          aux:='OR ';//OR

        case x of
          0:aux:=aux+'Totalroms = Haveroms';
          1:aux:=aux+'(Haveroms > 0 AND Haveroms < Totalroms)';
          2:aux:=aux+'Haveroms = 0';
          3:aux:=aux+'Haveroms = '+''''+'''';
        end;

        Datamodule1.Qaux.SQL.Add(aux);

      end;

    end;
  end;

  if open=true then
    Datamodule1.Qaux.SQL.Add(')');


  Datamodule1.Qaux.SQL.Add(sqlsortcolumn(VirtualStringTree2));
  aux:=Datamodule1.Qaux.SQL.Strings[Datamodule1.Qaux.SQL.count-1];

  Datamodule1.Qaux.Params.Clear;
  Datamodule1.Qaux.Params.CreateParam(ftWideString,'p_',ptResult);

  Datamodule1.Qaux.Params[0].DataType := ftWideString;
  Datamodule1.Qaux.Params[0].Value:=path+'%';

  BMDThread1.Start();
  waitforfinishthread;

  //Temporal table
  VirtualStringTree2.RootNodeCount:=0;//FIX INDETERMINATED
  VirtualStringTree2.Repaint;

  DataModule1.DBProfilesview.Close;
  DataModule1.DBProfilesview.DatabaseFileName:=UTF8Encode(tempdirectoryprofiles);
  DataModule1.DBProfilesview.SilentMode:=true;
  DataModule1.DBProfilesview.PageCountInExtent:=defpagecountinextent;
  DataModule1.DBProfilesview.PageSize:=defpagesize;
  DataModule1.DBProfilesview.MaxConnections:=defmaxconnections;

  DataModule1.DBProfilesview.CreateDatabase;

  T:=Tabstable.Create(DataModule1);
  T.DatabaseName:=DataModule1.DBProfilesview.DatabaseName;
  T.FieldDefs.Clear;
  T.TableName:='Profiles';
  T.FieldDefs.Add('CONT',ftAutoInc,0,False);
  T.FieldDefs.Add('ID',ftLargeint,0,False);
  T.IndexDefs.Clear;
  T.IndexDefs.Add('I', 'CONT', [ixPrimary]); //Speedup locate
  T.IndexDefs.Add('I2','Path', [ixCaseInsensitive]);
  addprofilesfielddefs(T);

  T.FieldDefs.Add('Path',ftWideString,256,true); //Add path to temp table

  T.CreateTable;
  speedupdb;

  DataModule1.Tprofilesview.Open;
  T.Free;

  Datamodule1.DBProfilesview.StartTransaction;

  while not Datamodule1.Qaux.Eof do begin

    DataModule1.Tprofilesview.Append;
    DataModule1.Tprofilesview.FieldByName('ID').asinteger:= DataModule1.Qaux.fieldbyname('ID').asinteger;
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Description'),getwiderecord(DataModule1.Qaux.fieldbyname('Description')));
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Name'),getwiderecord(DataModule1.Qaux.fieldbyname('Name')));
    DataModule1.Tprofilesview.FieldByName('Havesets').asinteger:= DataModule1.Qaux.fieldbyname('Havesets').asinteger;
    DataModule1.Tprofilesview.FieldByName('Haveroms').asstring:= DataModule1.Qaux.fieldbyname('Haveroms').asstring;
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Version'),getwiderecord(DataModule1.Qaux.fieldbyname('Version')));
    DataModule1.Tprofilesview.FieldByName('Filemode').asstring:= DataModule1.Qaux.fieldbyname('Filemode').asstring;
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Date'),getwiderecord(DataModule1.Qaux.fieldbyname('Date')));
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Author'),getwiderecord(DataModule1.Qaux.fieldbyname('Author')));
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Category'),getwiderecord(DataModule1.Qaux.fieldbyname('Category')));
    DataModule1.Tprofilesview.FieldByName('Lastscan').AsDateTime:= DataModule1.Qaux.fieldbyname('Lastscan').asdatetime;
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Homeweb'),getwiderecord(DataModule1.Qaux.fieldbyname('Homeweb')));
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Email'),getwiderecord(DataModule1.Qaux.fieldbyname('Email')));
    DataModule1.Tprofilesview.FieldByName('Totalsets').asinteger:= DataModule1.Qaux.fieldbyname('Totalsets').asinteger;
    DataModule1.Tprofilesview.FieldByName('Totalroms').asinteger:= DataModule1.Qaux.fieldbyname('Totalroms').asinteger;
    DataModule1.Tprofilesview.FieldByName('Added').asdatetime:= DataModule1.Qaux.fieldbyname('Added').asdatetime;
    DataModule1.Tprofilesview.FieldByName('Original').asstring:= DataModule1.Qaux.fieldbyname('Original').asstring;
    DataModule1.Tprofilesview.FieldByName('Tree').asinteger:= DataModule1.Qaux.fieldbyname('Tree').asinteger;
    setwiderecord(DataModule1.Tprofilesview.FieldByName('Path'),getwiderecord(DataModule1.Qaux.fieldbyname('Path')));
    DataModule1.Tprofilesview.FieldByName('Shared').asboolean:= DataModule1.Qaux.fieldbyname('Shared').asboolean;

    DataModule1.Tprofilesview.post;

    if DataModule1.Qaux.fieldbyname('Shared').asboolean=true then
      viewshared:=viewshared+1;

    Datamodule1.Qaux.Next;
    application.processmessages;
  end;

  if Datamodule1.DBProfilesview.InTransaction=true then
    Datamodule1.DBProfilesview.Commit(true);

  VirtualStringTree2.RootNodeCount:=Datamodule1.Tprofilesview.RecordCount;

end;//All disabled

if (speedbutton1.Down=true) OR (speedbutton3.Down=true) OR (speedbutton4.Down=true) OR (speedbutton5.Down=true) then begin
  panel10.caption:=a;
  panel11.caption:=b;
  panel12.caption:=c;
  panel13.caption:=d;
end;

w:=true;
if VirtualStringTree2.RootNodeCount=0 then
  w:=false;

speedbutton35.Enabled:=w;
speedbutton37.Enabled:=w;

showprofilestotalpanel(total);
panel66.Caption:=traduction(512)+' '+inttostr(viewshared)+' '+'/'+' '+inttostr(totalshared);

Datamodule1.Qaux.Close;

posintoindexbynode(VirtualStringTree2.GetFirst,VirtualStringTree2);

showprofilesselected;

application.processmessages;

if progress=true then begin
  hideprocessingwindow;
end;

restorefocussedcontrol;
end;

//-SCANNER---------------------------------------------------

procedure Tfmain.checkfilterglyph;
begin
if mastertable.Filtered=true then
  SpeedButton67.Glyph:=speedbutton69.Glyph
else
  speedbutton67.Glyph:=speedbutton70.Glyph;
end;

procedure Tfmain.updatemasterpanel;
var
master:TTntpanel;
begin
master:=(FindComponent('CLONE_Panel37_'+getcurrentprofileid) as TTntpanel);
master.Caption:=traduction(24)+' '+fillwithzeroes(inttostr(masterlv.rootnodecount),4)+' '+'/'+' '+fillwithzeroes(inttostr(master.tag),4);
end;

procedure Tfmain.tabprofilesharing(b:boolean);
var
id:longint;
aux:ansistring;
sharetotals,contshared:longint;
begin
id:=strtoint(getcurrentprofileid);
if Datamodule1.Tprofiles.Locate('ID',id,[]) then begin

  sharetotals:=strtoint(gettoken(panel66.Caption,' ',gettokencount(panel66.caption,' ')));
  aux:=gettoken(panel66.caption,' '+'/'+' ',1);
  contshared:=strtoint(gettoken(aux,' ',gettokencount(aux,' ')));

  Datamodule1.Tprofiles.Edit;
  Datamodule1.Tprofiles.FieldByName('Shared').asboolean:=b;
  Datamodule1.Tprofiles.Post;

  if b=true then
    sharetotals:=sharetotals+1
  else
    sharetotals:=sharetotals-1;

  if Datamodule1.Tprofilesview.Locate('ID',id,[]) then begin
    Datamodule1.Tprofilesview.Edit;
    Datamodule1.Tprofilesview.FieldByName('Shared').asboolean:=b;
    Datamodule1.Tprofilesview.Post;

    if b=true then
      contshared:=contshared+1
    else
      contshared:=contshared-1;
  end;

  //COUNTER PANEL NEEDS UPDATED
  panel66.Caption:=traduction(512)+' '+inttostr(contshared)+' '+'/'+' '+inttostr(sharetotals);
  showprolesmasterdetail(false,false,inttostr(id),false,false);
end;
//
end;

function fileofprofile(path:widestring;typ:shortint;def:boolean;id:longint):widestring;
var
compext:string;
gamename:widestring;
comp:integer;
begin
Result:='*';
comp:=0;

path:=checkpathbar(path);

if masterlv.rootnodecount>0 then begin

  mastertable.Locate('ID',id,[]);
  //mastertable.locate('ID',detailedit.Tag,[]); //0.025
  gamename:=getwiderecord(mastertable.fieldbyname('Gamename'));


  if detailtable.Locate('Setname;Type',VarArrayOf([mastertable.fieldbyname('ID').asinteger,typ]),[])=false then
    exit;

  compext:='\';

  if def=false then
    comp:=Datamodule1.TDirectories.fieldbyname('Compression').asinteger
  else
    case typ of
      0:comp:=defromscomp;
      1:comp:=defsamplescomp;
      2:comp:=defchdscomp;
    end;

  case comp of
    10..19:compext:='.zip';
    20..29:compext:='.rar';
    30..39:compext:='.7z';
  end;

  if compext='\' then
    Result:=path+gamename+compext
  else
    Result:=path+gamename+compext;

end;

end;

procedure TFmain.setfilescanselection(id:longint);
var
fout,path:widestring;
readed,def:boolean;
rp,sp,cp:widestring;
begin
Romspath1.Visible:=false;
Samplespath1.Visible:=false;
CHDspath1.Visible:=false;

Romspath1.Enabled:=false;
samplespath1.Enabled:=false;
CHDspath1.Enabled:=false;
backuppath1.Enabled:=false;

rom1.Visible:=false;
sample1.visible:=false;
chd1.Visible:=false;
rom1.Enabled:=false;
sample1.Enabled:=false;
chd1.Enabled:=false;

//Datamodule1.Taux.Close;
//Datamodule1.Taux.TableName:='Z'+getcurrentprofileid;
//Datamodule1.Taux.Open;

rp:=traduction(347);
sp:=traduction(347);
cp:=traduction(347);

path:=getbackuppathofid(strtoint(getcurrentprofileid));

backuppath1.Caption:=UTF8Encode(changein(path,'&','&&'));

if WideDirectoryExists(path) then
  backuppath1.Enabled:=true;

mastertable.Locate('ID',id,[]); //0.030 CHANGED
//id:=detailedit.Tag;

if detailtable.Locate('Type',0,[]) then begin

  Romspath1.Visible:=true;
  readed:=false;
  def:=true;

  if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(getcurrentprofileid),0]),[])=true then begin
    rp:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
    readed:=true;
    def:=false;
  end;

  if WideDirectoryexists(rp) then begin
    rp:=checkpathbar(rp);
    Romspath1.Caption:=UTF8Encode(changein(rp,'&','&&'));
    Romspath1.Enabled:=true;
  end
  else
    Romspath1.Caption:=UTF8Encode(changein(rp,'&&','&&'));

  rom1.visible:=true;
  rom1.Caption:=UTF8Encode(changein(rp,'&','&&'));

  if readed=true then begin
    fout:=fileofprofile(rp,0,def,id);

    if fout<>'*' then begin
      scanprofileid:=fout; //Use Fscan var

      rom1.Caption:=UTF8Encode(changein(fout,'&','&&'));

      if (FileExists2(fout)) OR (WideDirectoryExists(fout)) then
        rom1.Enabled:=true;
    end;

  end;

end;

if detailtable.Locate('Type',1,[]) then begin

  samplespath1.Visible:=true;
  readed:=false;
  def:=true;

  if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(getcurrentprofileid),1]),[])=true then begin
    sp:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
    if sp='' then //FIX
      if rp<>traduction(347) then
        sp:=rp;

    readed:=true;
    def:=false;
  end;

  if WideDirectoryExists(sp) then begin
    sp:=checkpathbar(sp);
    samplespath1.Caption:=utf8Encode(changein(sp,'&','&&'));
    samplespath1.Enabled:=true;
  end
  else
    samplespath1.Caption:=utf8Encode(changein(sp,'&','&&'));

  if sp=traduction(347) then //FIX DEFAULT BY ROMSPATH
    if rp<>traduction(347) then begin
      sp:=sp;
      readed:=true;
    end;

  sample1.visible:=true;
  sample1.Caption:=utf8encode(changein(sp,'&','&&'));

  if readed=true then begin

    fout:=fileofprofile(sp,1,def,id);

    if fout<>'*' then begin
      scanpath:=fout; //Use Fscan var

      sample1.Caption:=UTF8Encode(changein(fout,'&','&&'));

      if (FileExists2(fout)) OR (WideDirectoryExists(fout))then
        sample1.Enabled:=true;
    end;

  end;

end;

if detailtable.Locate('Type',2,[]) then begin

  CHDspath1.Visible:=true;
  readed:=false;
  def:=true;

  if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(getcurrentprofileid),2]),[])=true then begin
    cp:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));

    if cp='' then //FIX
      if rp<>traduction(347) then
        cp:=rp;

    readed:=true;
    def:=false;
  end;

  if WideDirectoryExists(cp) then begin
    cp:=checkpathbar(cp);
    chdspath1.Caption:=utf8Encode(changein(cp,'&','&&'));
    chdspath1.Enabled:=true;
  end
  else
    chdspath1.Caption:=utf8Encode(changein(cp,'&','&&'));

  if cp=traduction(347) then //FIX DEFAULT BY ROMSPATH
    if rp<>traduction(347) then begin
      cp:=rp;
      readed:=true;
    end;

  CHD1.visible:=true;
  CHD1.Caption:=UTF8Encode(changein(cp,'&','&&'));

  if readed=true then begin
    fout:=fileofprofile(cp,2,def,id);
    if fout<>'*' then begin
      currentset:=fout; //Use Fscan var

      CHD1.Caption:=UTF8Encode(changein(fout,'&','&&'));

      if (FileExists2(fout)) OR (Widedirectoryexists(fout))then
        CHD1.Enabled:=true;
    end;
  end;

end;


//Datamodule1.Taux.Close;
end;

procedure TFmain.extractselection(frommaster:boolean;ignorecompress:boolean;path:widestring);
var
x,id,y,total,totalselected,currselected,extractcount:longint;
tryedopen,makefolders,noromspath,nosamplespath,nochdspath,ignore:boolean;
lv:TVirtualStringTree;
typ,typetoextract:integer;
openfile,filetoextract,destination,origin,setname,aux,lastvalidcomp:widestring;
n:PVirtualNode;
alreadylist:Ttntstringlist;
begin
//TODO LOCK FILES IF SERVER IS USING IT
alreadylist:=Ttntstringlist.Create;
alreadylist.Sorted:=true;
ignore:=false;

makefolders:=false;
showprocessingwindow(true,false);
path:=checkpathbar(path);

if ignorecompress=false then
  makefolders:=Makedirectoriesbycompressedfile1.Checked;

typetoextract:=-1;
lastvalidcomp:='';
typ:=-1;
id:=0;
total:=0;
extractcount:=0;
noromspath:=false;
nosamplespath:=false;
nochdspath:=false;

if frommaster=true then
  lv:=masterlv
else begin
  lv:=detaillv;
  makefolders:=false;
  mastertable.Locate('ID',detailedit.tag,[]);
  id:=mastertable.fieldbyname('ID').asinteger;
  setname:=getwiderecord(mastertable.fieldbyname('Gamename'));
  setfilescanselection(detailedit.tag);
end;

initializeextractionfolders;

totalselected:=lv.SelectedCount;
currselected:=0;

n:=lv.GetFirst;
for x:=0 to lv.rootnodecount-1 do begin

  If Fprocessing.Tag=1 then
    break;

  if totalselected=currselected then
    break;

  application.processmessages;

  if lv.Selected[n]=true then begin
    alreadylist.clear;//0.046
    currselected:=currselected+1;

    if frommaster=false then begin
      detailtable.Locate('CONT;Setname',VarArrayOf([x+1, detailedit.tag]),[]);
      filetoextract:=getwiderecord(detailtable.fieldbyname('romname'));
      typetoextract:=detailtable.fieldbyname('type').asinteger;
    end
    else begin

      mastertable.Locate('CONT',x+1,[]);

      total:=mastertable.fieldbyname('Total_').asinteger-1;
      id:=mastertable.fieldbyname('ID').asinteger;
      setname:=getwiderecord(mastertable.fieldbyname('Gamename'));
      setfilescanselection(id);

    end;

    for y:=0 to total do begin //GET THE NEEDED DETAIL FILES WHEN NEEDED

      If Fprocessing.Tag=1 then
        break;

      ignore:=false;
      application.processmessages;

      if frommaster=true then begin

        detailtable.Locate('CONT;Setname',VarArrayOf([y+1,id]),[]);
        filetoextract:=getwiderecord(detailtable.fieldbyname('romname'));
        typetoextract:=detailtable.fieldbyname('type').asinteger;

      end;

      case typetoextract of //ROMS SAMPLES CHDS PATH GET
        0:openfile:=scanprofileid;
        1:openfile:=scanpath;
        2:openfile:=currentset;
      end;

      if widedirectoryexists(wideextractfilepath(openfile)) then begin //IGNORE EMPTY NOT DEFINED DIRS

        tryedopen:=false;

        if lastvalidcomp<>openfile then
          typ:=-1
        else
          tryedopen:=true;

        if typ=-1 then //0.028
        if (ignorecompress=true) AND (frommaster=true) then begin//0.038 NOT EXTRACT ONLY COPY
          if fileexists2(openfile)=true then begin
            typ:=0;

            lastvalidcomp:=openfile;

            filetoextract:='';
          end;
        end
        else
        if wideuppercase(openfile[length(openfile)])='P' then begin//Zip
          tryedopen:=true;
          if zipvalidfile(openfile,Zip1)=true then begin
            typ:=1;
            lastvalidcomp:=openfile;
          end;
        end
        else
        if wideuppercase(openfile[length(openfile)])='R' then begin//RAR
          tryedopen:=true;
          if rarvalidfile(openfile,rar1)=true then  begin
            typ:=2;
            lastvalidcomp:=openfile;
          end;
        end
        else
        if wideuppercase(openfile[length(openfile)])='Z' then begin//7z
          tryedopen:=true;
          if sevenzipvalidfile(openfile,sevenzip1)=true then begin
            typ:=3;
            lastvalidcomp:=openfile;
          end;
        end
        else
        if wideDirectoryExists(openfile)=true then
          typ:=0;

        if typ>0 then begin
          if stcompfiles.IndexOf(filetoextract)=-1 then begin//DONT EXISTS INSIDE COMPRESSED THEN SKIP
            typ:=-1;
            tryedopen:=false;
          end;
        end
        else
        if typ=0 then
          if FileExists2(openfile+filetoextract)=false then begin //UNCOMPRESSED FILEEXISTS CHECK
            typ:=-1;
            tryedopen:=false;
          end;

        if typ=-1 then begin
          if (tryedopen=true) AND (FileExists2(openfile)=true) then //ERROR OPENING FILE
            adderror(traduction(181)+' : '+openfile); //OPEN ERROR
        end
        else begin

          tryedopen:=false;

          if ignorecompress=true then begin
            if changein(wideextractfilename(openfile),'&','&&')<>Fprocessing.panel2.Caption then
              Fprocessing.panel2.Caption:=changein(wideextractfilename(openfile),'&','&&');
          end
          else
          if changein(wideextractfilename(setname),'&','&&')<>Fprocessing.panel2.Caption then
            Fprocessing.panel2.Caption:=changein(wideextractfilename(setname),'&','&&');

          Fprocessing.panel3.Caption:=changein(filetoextract,'&','&&',);

          if ignorecompress=true then //ALREADY CHECKED 0.038
            tryedopen:=true
          else
          if filetoextract[Length(filetoextract)]<>'\' then
            case typ of
              0:tryedopen:=FileExists2(openfile+filetoextract);
              1:tryedopen:=extractfilefromzip(zip1,filetoextract,tempdirectoryextract,false);
              2:tryedopen:=extractfilefromrar(rar1,filetoextract,tempdirectoryextract,false);
              3:tryedopen:=extractfilefromsevenzip(sevenzip1,filetoextract,tempdirectoryextract,false);
            end;

          if tryedopen=true then begin

            if typ=0 then
              origin:=openfile+filetoextract
            else begin
              origin:=tempdirectoryextract+gettoken(filetoextract,'\',gettokencount(filetoextract,'\'));
            end;

            if makefolders then begin
              destination:=path+setname+'\'+filetoextract;
              wideForceDirectories(path+setname+'\');
            end
            else
              if ignorecompress=true then //0.038
                destination:=path+WideExtractFileName(openfile)
              else
                destination:=path+filetoextract;

            destination:=getvaliddestination(destination);//OK NEVER OVERWRITE

            aux:='';
            if typ<>0 then
              aux:=' > '+filetoextract;

            try //MUST BE THREATED
              wideforcedirectories(WideExtractfilepath(destination));//FIX

              Datamodule1.Qaux.Close;
              Datamodule1.Qaux.SQL.Clear;

              if typ<>0 then begin //HACK IF IS SAME DRIVE
                if gettoken(origin,':',1)<>gettoken(destination,':',1) then
                  TurboCopyFile(origin,destination)
                else
                  movefile2(origin,destination);

                deletefile2(origin);
              end
              else begin
                if alreadylist.IndexOf(wideuppercase(origin))=-1 then begin
                  TurboCopyFile(origin,destination);
                  alreadylist.Add(wideuppercase(origin));
                end
                else
                  ignore:=true;//0.046 ToniBC

              end;

              if ignore=false then //0.046 ToniBC
                if (FileExists2(destination)=false) then
                  makeexception
                else
                  extractcount:=extractcount+1;

            except //EXTRACT ERROR
              adderror(traduction(181)+' : '+openfile+aux);
            end

          end
          else
            if filetoextract[Length(filetoextract)]<>'\' then
              adderror(traduction(181)+' : '+openfile)//OPEN ERROR
            else
              wideForceDirectories(path+filetoextract);

          //DELETE POSSIBLE TEMPFILE
          if typ<>0 then
            deletefile2(tempdirectoryextract+filetoextract);

        end;

      end//END NOT DEFINED ROMS PATH
      else
        case typetoextract of
          0:noromspath:=true;
          1:nosamplespath:=true;
          2:nochdspath:=true;
        end;

    end;//END DETAILS LOOP

  end;//END SELECTED

  n:=lv.GetNext(n);
end;

initializeextractionfolders;

//CHECK FOR STERRORS
if noromspath=True then
  adderror(traduction(157));
if nosamplespath=true then
  adderror(traduction(158));
if nochdspath=true then
  adderror(traduction(159));

closepossiblyopenzip; //FIX

Freeandnil(alreadylist);

hideprocessingwindow;

if extractcount=0 then begin
  sterrors.Add('0 '+traduction(486));
  mymessageerror(sterrors.Text);
end
else
if sterrors.Count=0 then begin
  mymessageinfo(inttostr(extractcount)+' '+traduction(486));
end
else begin
  sterrors.Add(inttostr(extractcount)+' '+traduction(486));
  mymessagewarning(sterrors.Text);
end;

sterrors.Clear;
end;

procedure Tfmain.TabMenuPopup(APageControl: TTntpagecontrol; X, Y: Integer);
var
  hi: TTCHitTestInfo;
  TabIndex: Integer;
  p: TPoint;
begin
  hi.pt.x := X;
  hi.pt.y := Y;
  hi.flags := 0;
  TabIndex := APageControl.Perform(TCM_HITTEST, 0, longint(@hi));
  GetCursorPos(p);

  if uppercase(GetParentForm(APageControl).name)<>'FSERVER' then begin//FIX
    if pagecontrol1.ActivePageIndex=1 then begin
      tabindex:=tabindex+1;
      if tabindex<>pagecontrol2.ActivePageIndex then begin
        pagecontrol2.ActivePageIndex:=tabindex;
        PageControl2Change(APageControl);
      end;
    end
    else begin
      if tabindex<>pagecontrol3.ActivePageIndex then begin
        pagecontrol3.ActivePageIndex:=tabindex;
        PageControl3Change(APageControl);
      end;
    end;
  end
  else
    if tabindex+1<>Fserver.pagecontrol2.ActivePageIndex then begin
      Fserver.pagecontrol2.ActivePageIndex:=tabindex+1;
      Fserver.PageControl2Change(APageControl);
    end;

  PopupMenu6.Popup(P.x, P.Y);
end;


procedure Tfmain.traductvirtualcolumns;
begin
masterlv.header.Columns[0].text:=traduction(11);
masterlv.header.Columns[1].text:=traduction(101);
masterlv.header.Columns[2].text:=traduction(102);
masterlv.header.Columns[3].text:=traduction(103);

if masterlv.header.Columns.Count=9 then begin //Offlinelist columns
  masterlv.header.Columns[4].text:=traduction(230);
  masterlv.header.Columns[5].text:=traduction(226);
  masterlv.header.Columns[6].text:=traduction(227);
  masterlv.header.Columns[7].text:=traduction(232);
  masterlv.header.Columns[8].text:=traduction(229);
end
else
  masterlv.header.Columns[4].text:=traduction(322);


detaillv.header.Columns[0].text:=traduction(151);
detaillv.header.Columns[1].text:=traduction(233);
detaillv.header.Columns[2].text:=traduction(153);
detaillv.header.Columns[3].text:=traduction(154);
detaillv.header.Columns[4].text:=traduction(155);
end;

procedure Tfmain.findinlistviewscanner(down:boolean);
var
fieldname:ansistring;
begin
if combobox1.Items.count=0 then
  exit;

case combobox1.ItemIndex of
  0:fieldname:='Description';
  1:fieldname:='Gamename';
  2:if offinfotable=nil then
      fieldname:='Master'
    else
      fieldname:='Language';
  3:fieldname:='Publisher';
  4:fieldname:='Savetype';
  5:fieldname:='Sourcerom';
  6:fieldname:='Comment';
end;

findinlistview(masterlv,mastertable,down,edit5,fieldname);
end;

procedure TFmain.Setdefaultbitmap;
var
str:widestring;
begin
str:='       '+traduction(252)+'       ';

bmp.Canvas.Font.Name:='Tahoma';
bmp.Canvas.Font.Size:=22;
bmp.Canvas.Brush.Color:=clBtnFace;

bmp.Height:=WideCanvasTextHeight(bmp.Canvas,str);
bmp.Width:=WideCanvasTextWidth(bmp.Canvas,str);

WideCanvasTextOut(bmp.Canvas,0,0,str);
end;

procedure Tfmain.loadimages;
var
aux,aux2:longint;
subpath:ansistring;
r:real;
begin
//Load images
if (speedbutton33.enabled=true) AND (speedbutton33.down=true) AND (masterlv.rootnodecount>0) then begin

  if masterlv.rootnodecount=0 then
    exit;

  try
    detailtable.Locate('Setname',detailedit.Tag,[]);
    aux:=detailtable.fieldbyname('MD5').asinteger;
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


    subpath:=inttostr((aux2*500)+1)+'-'+inttostr((aux2+1)*500)+'\'+subpath;

    Image321.Bitmap.Clear(clWhite);//FIX
    try
      pngstream.Position:=0;
      if sizeoffile(imagespath+subpath+'a.png')<5000000 then begin
        pngstream.LoadFromFile(imagespath+subpath+'a.png');
        png.LoadFromStream(pngstream);
        Image321.Bitmap.Assign(png);
      end
      else
        makeexception;
    except
      Image321.Bitmap.Assign(bmp);
    end;

    Image322.Bitmap.Clear(clWhite);//FIX
    try
      pngstream.Position:=0;
      if sizeoffile(imagespath+subpath+'b.png')<5000000 then begin
        pngstream.LoadFromFile(imagespath+subpath+'b.png');
        png2.LoadFromStream(pngstream);
        image322.Bitmap.assign(png2);
      end
      else
        makeexception;
    except
      Image322.Bitmap.Assign(bmp);
    end;

  except
    Image321.Bitmap.Assign(bmp);
    Image322.Bitmap.Assign(bmp);
  end;

  image321.Refresh;
  image322.Refresh;

end
else begin
  Image321.Bitmap.Assign(bmp);
  Image322.Bitmap.Assign(bmp);

  image321.Refresh;
  image322.Refresh;
end;


end;


procedure Tfmain.setimagepath(edit:TTntedit);
var
id:ansistring;
fold:widestring;
begin
fold:=folderdialoginitialdircheck(initialdirimages);

if WideDirectoryExists(edit.text) then
  fold:=edit.Text;

positiondialogstart;

if WideSelectDirectory(traduction(239)+' :','',fold) then begin
  fold:=checkpathbar(fold);
  initialdirimages:=fold;
  edit.Text:=fold;

  if formexists('Fofflineupdate') then
    id:=updateid
  else
    id:=getcurrentprofileid;

  if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(id),'I']),[])=true then
    Datamodule1.TDirectories.edit
  else
    Datamodule1.TDirectories.append;

  setwiderecord(Datamodule1.TDirectories.fieldbyname('Path'),edit.Text);
  Datamodule1.TDirectories.fieldbyname('Profile').asstring:=id;
  Datamodule1.TDirectories.fieldbyname('Type').asstring:='I';
  Datamodule1.TDirectories.fieldbyname('Compression').asstring:='0';
  Datamodule1.TDirectories.post;

  imagespath:=edit.Text;

  //ID PATH PROFILE TYPE COMPRESSION
  loadimages;
end;

end;

procedure Tfmain.showprofilesmasterselected;
begin
masterselected.caption:=traduction(23)+' '+inttostr(masterlv.SelectedCount);
end;


procedure Tfmain.showprofilesdetailselected;
begin
detailselected.caption:=traduction(23)+' '+inttostr(detaillv.SelectedCount);
end;

procedure Tfmain.deletecurrentscantab;
var
aux:ansistring;
islast:boolean;
begin
islast:=false;

aux:=getcurrentprofileid;

panel25.Visible:=false;
panel25.Parent:=VirtualStringTree1;
panel35.Visible:=false;
panel35.Parent:=VirtualStringTree3;

(FindComponent('CLONE_Panel23_'+aux) as TTntpanel).free;
(Datamodule1.FindComponent('TM'+aux) as Tabstable).free;
(Datamodule1.FindComponent('TD'+aux) as Tabstable).free;
(Datamodule1.FindComponent('DB'+aux) as TABSDatabase).free;

try //Possible OLL
  if (Datamodule1.FindComponent('O'+aux) as Tabstable)<>nil then
    (Datamodule1.FindComponent('O'+aux) as Tabstable).free;
except
end;
deletefile2(tempdirectorymasterdetail(aux));

if pagecontrol2.ActivePageIndex=pagecontrol2.PageCount-1 then
  islast:=true;



pagecontrol2.ActivePage.Free;

if islast=true then
  pagecontrol2.ActivePageIndex:=pagecontrol2.PageCount-1;

freemousebuffer;
freekeyboardbuffer;
end;

procedure Tfmain.showcurrentscantab(forzedmaster,forzeddetail:boolean;id:ansistring);
var
aux,aux2,aux3:ansistring;
complete,incomplete,empty,totalsets:longint;//changed
x,y:longint;
DB:TABSDatabase;
masterpanel:TTntpanel;
tabid:ansistring;
filemode,fieldnum:shortint;
vmastercomp,vmasterincomp,vmasterempty,applyfilter:boolean;
column:Tvirtualtreecolumn;
isofftable,splitmerge,splitnomerge:boolean;
oldcaption,cloneof:widestring;
count:integer;
fieldname:string;
totalroms,havesets,haveroms,incompsets,setromscounter,sethavecounter,curid,tid,curmaster:longint;
wide:widestring;
calc,insecondtable:boolean;
totalsize:currency;
displayimg:boolean;
begin
displayimg:=false;
totalsets:=0;
havesets:=0;
haveroms:=0;
incompsets:=0;

Panel55.Caption:=inttostr(PageControl2.PageCount-1);

if pagecontrol2.PageCount<=1 then begin
  masterlv:=nil;
  detaillv:=nil;
  tntspeedbutton1.Enabled:=false;
  speedbutton6.Enabled:=false;
  speedbutton28.Enabled:=false;
  speedbutton29.Enabled:=false;
  speedbutton30.Enabled:=false;
  speedbutton31.Enabled:=false;
  speedbutton39.Enabled:=false;
  speedbutton40.Enabled:=false;
  speedbutton41.Enabled:=false;
  speedbutton46.Enabled:=false;
  speedbutton51.Enabled:=false;
  PageControl2.Visible:=false;
  panel36.Parent:=TabSheet2;
  panel36.Align:=alclient;
  panel36.Visible:=true;
  panel16.Visible:=false;
  speedbutton36.Enabled:=false;
  speedbutton38.Enabled:=false;
  combobox1.items.clear;
  combobox1.Enabled:=false;
  exit;
end;

if (Datamodule1.FindComponent('DB'+id) as TABSDatabase)=nil then
  exit;


{count:=(FindComponent('CLONE_VirtualStringTree1_'+id) as TVirtualStringTree).rootnodecount;
(FindComponent('CLONE_VirtualStringTree1_'+id) as TVirtualStringTree).RootNodeCount:=0;
}

panel36.Visible:=false; //Hide white panel
panel16.Visible:=true;
tntspeedbutton1.Enabled:=true;
speedbutton6.Enabled:=true;
speedbutton28.Enabled:=true;
speedbutton29.Enabled:=true;
speedbutton30.Enabled:=true;
speedbutton31.Enabled:=true;
speedbutton39.Enabled:=true;
speedbutton40.Enabled:=true;
speedbutton51.Enabled:=true;
speedbutton41.Enabled:=true;
speedbutton46.Enabled:=true;
speedbutton36.Enabled:=true;
speedbutton38.Enabled:=true;

Datamodule1.Tprofiles.Locate('ID',strtoint(id),[]);

offinfotable:=nil;

//SHOWING IMAGES OR NOT
if Datamodule1.Tprofiles.fieldbyname('Original').asstring<>'O' then begin
  edit3.Visible:=false;
  speedbutton32.Visible:=false;
  panel16.Width:=panel41.Width+3;
  speedbutton33.Enabled:=false;
  speedbutton34.Enabled:=false;
  speedbutton67.Enabled:=false;
  speedbutton67.Glyph:=speedbutton68.Glyph;
end
else begin
if Datamodule1.Tprofiles.fieldbyname('IMG').asboolean=true then begin
  edit3.Visible:=true;
  speedbutton32.Visible:=true;
  speedbutton33.Enabled:=true;
  speedbutton34.Enabled:=true;
  speedbutton67.Enabled:=true;
  speedbutton33.down:=true;
  //panel16.Width:=255; MOVED AT FINAL
  displayimg:=true;
end
else begin
  edit3.Visible:=false;
  speedbutton32.Visible:=false;
  speedbutton33.Enabled:=true;
  speedbutton34.Enabled:=true;
  speedbutton67.Enabled:=true;
  speedbutton33.down:=false;
  panel16.Width:=panel41.Width+3;
end;
try
  if Datamodule1.DBDatabase.TableExists('O'+id) then
    offinfotable:=(Datamodule1.FindComponent('O'+id) as Tabstable);
except
end;
end;

isofftable:=false;
if offinfotable<>nil then
  isofftable:=true;

filemode:=Datamodule1.Tprofiles.fieldbyname('Filemode').asinteger;
splitmerge:=Datamodule1.Tprofiles.fieldbyname('Splitmerge').asboolean;
splitnomerge:=Datamodule1.Tprofiles.fieldbyname('Splitmerge').asboolean;

//FIX DESCRIPTION

(FindComponent('CLONE_Tabsheet7_'+id) as TTnttabsheet).hint:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'));
(FindComponent('CLONE_Tabsheet7_'+id) as TTnttabsheet).Caption:=gettrimmedtext(changein(getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description')),'&','&&'),200);

aux:=id;
tabid:=getcurrentprofileid;

ExplorerDrop2.DestinationControl:=nil;
ExplorerDrop3.DestinationControl:=nil;
masterpanel:=(FindComponent('CLONE_Panel37_'+aux) as TTntpanel);

masterlv:=(FindComponent('CLONE_VirtualStringTree1_'+aux) as TVirtualStringTree);
detaillv:=(FindComponent('CLONE_VirtualStringTree3_'+aux) as TVirtualStringTree);

mastertable:=(Datamodule1.FindComponent('TM'+aux) as Tabstable);
detailtable:=(Datamodule1.FindComponent('TD'+aux) as Tabstable);

masterlv.TabOrder:=0;
detaillv.TabOrder:=1;

if isofftable=true then begin

  masterlv.Images:=imagelist5;

  if masterlv.header.Columns.Count=5 then begin
    column:=masterlv.header.Columns.Add; //Publisher
    column.Width:=120;
    column:=masterlv.header.Columns.Add;  //Savetype
    column.Width:=100;
    column:=masterlv.header.Columns.Add; //Source
    column.Width:=120;
    column:=masterlv.header.Columns.Add; //Comment
    column.Width:=350;
  end;

  if combobox1.Items.Count<=3 then begin
    combobox1.Items.BeginUpdate;

    x:=ComboBox1.ItemIndex;
    if x=-1 then
      x:=0;
    combobox1.Items.Clear;
    combobox1.Enabled:=false;
    combobox1.Items.Add(traduction(11));
    combobox1.Items.Add(traduction(101));
    combobox1.Items.Add(traduction(230));
    combobox1.Items.Add(traduction(226));
    combobox1.Items.Add(traduction(227));
    combobox1.Items.Add(traduction(232));
    combobox1.Items.Add(traduction(229));
    combobox1.Enabled:=true;
    //Lang,publisher,savetype,source,comment
    try
      combobox1.ItemIndex:=x;
    except
    end;

    if combobox1.itemindex=-1 then
      combobox1.itemindex:=0;

    combobox1.Items.Endupdate;
  end;


end
else begin

  masterlv.Images:=ImageList2;

  if combobox1.items.Count<>3 then begin
    x:=combobox1.ItemIndex;
    if x=-1 then
      x:=0;
    combobox1.Items.BeginUpdate;
    combobox1.Items.Clear;
    combobox1.Enabled:=false;
    combobox1.Items.Add(traduction(11));
    combobox1.Items.Add(traduction(101));
    combobox1.Items.Add(traduction(322));
    combobox1.Enabled:=true;
    
    try
      combobox1.ItemIndex:=x;
    except
    end;

    if combobox1.itemindex=-1 then
      combobox1.itemindex:=0;

    combobox1.Items.Endupdate;
  end;

  if masterlv.header.Columns.Count>5 then
    While masterlv.header.Columns.Count>5 do
      masterlv.header.columns[masterlv.header.columns.count-1].Destroy;

end;


setgridlines(masterlv,ingridlines);
setgridlines(detaillv,ingridlines);

traductvirtualcolumns;

ExplorerDrop2.DestinationControl:=masterlv;
ExplorerDrop3.DestinationControl:=detaillv;

fixcomponentsbugs(Fmain);

masteredit:=(FindComponent('CLONE_Edit1_'+aux) as TTntedit);
detailedit:=(FindComponent('CLONE_Edit2_'+aux) as TTntedit);

detailhave:=(FindComponent('CLONE_Panel18_'+aux) as TTntpanel);
detailmiss:=(FindComponent('CLONE_Panel19_'+aux) as TTntpanel);
detailtotal:=(FindComponent('CLONE_Panel38_'+aux) as TTntpanel);

visiblehave:= (FindComponent('CLONE_SpeedButton8_'+aux) as TTntspeedbutton).down;
visiblemiss:= (FindComponent('CLONE_SpeedButton9_'+aux) as TTntspeedbutton).down;

masterselected:=(FindComponent('CLONE_Panel39_'+aux) as TTntpanel);
detailselected:=(FindComponent('CLONE_Panel40_'+aux) as TTntpanel);

DB:=(Datamodule1.FindComponent('DB'+aux) as TABSDatabase);

vmastercomp:=(FindComponent('CLONE_Speedbutton14_'+aux) as TTntspeedbutton).down;
vmasterincomp:=(FindComponent('CLONE_Speedbutton15_'+aux) as TTntspeedbutton).down;
vmasterempty:=(FindComponent('CLONE_Speedbutton16_'+aux) as TTntspeedbutton).down;


if isofftable=true then
  checkfilterglyph;

if (tabid=aux) AND (vmastercomp=false) AND (vmasterincomp=false) AND (vmasterempty=false) then begin

  masterlv.rootnodecount:=0;

  masteredit.Text:='';
  masteredit.Repaint;

  detaillv.rootnodecount:=0;

  detailedit.Text:='';
  detailedit.Tag:=0;
  detailedit.Repaint;

  CenterInClient(panel25,masterlv);
  panel25.Visible:=true;
  panel25.Parent:=masterlv;
  forzedmaster:=false;
  detaillv.Repaint;
  masterlv.Repaint;

end
else
  panel25.Visible:=false;

if (tabid=aux) AND (visiblehave=false) and (visiblemiss=false) then begin

  detaillv.rootnodecount:=0;

  detailedit.Text:='';
  detailedit.Repaint;

  CenterInClient(panel35,detaillv);
  panel35.Visible:=true;
  panel35.Parent:=detaillv;

  forzeddetail:=false;
  detaillv.Repaint;

end
else
  panel35.Visible:=false;

if (forzedmaster=true) OR (forzeddetail=true) then begin

  masterlv.rootnodecount:=0;
  masterlv.Repaint;

  masteredit.Text:='';
  masteredit.Repaint;

  detaillv.rootnodecount:=0;
  detaillv.Repaint;

  detailedit.Text:='';
  detailedit.Repaint;

  applyfilter:=mastertable.Filtered;
  mastertable.close;
  mastertable.Filtered:=false;

  Datamodule1.Qaux.sql.Text:='EMPTYMASTER';
  BMDThread1.Start();
  waitforfinishthread;

  mastertable.Open;

  detailtable.close;

  Datamodule1.Qaux.sql.Text:='EMPTYDETAIL';
  BMDThread1.Start();
  waitforfinishthread;

  detailtable.Open;

  Datamodule1.Qaux.Close;
  Datamodule1.Qaux.SQL.clear;

//0.028 CHANGED
//-------------------------------------------------------

  mastertable.Open;
  detailtable.Open;

  if filemode=0 then begin
    fieldname:='Setnamemaster'; //Setnamemaster
    fieldnum:=8;
  end
  else begin
    fieldname:='Setname'; //Setname
    fieldnum:=7;
  end;

  allowmerge:=false;
  allowdupe:=false;

  case filemode of
  0:begin
      allowmerge:=true;//Same file
      allowdupe:=false;
    end;
  1:begin
      allowmerge:=false;//Normal
      allowdupe:=true;
    end;
  2:begin
      allowmerge:=true;//Big size
      allowdupe:=true;
    end;
  end;

  if isofftable=true then begin //FIX NOT CREATED INDEXATION
    Datamodule1.Qaux.SQL.Text:='CREATE unique index Y2 ON O'+aux+' (Setid)';
    BMDThread1.Start();
    waitforfinishthread;

    Datamodule1.Qaux.close;
    Datamodule1.Qaux.sql.clear;

    Datamodule1.Taux.Close;
    Datamodule1.Taux.TableName:='O'+aux;
    Datamodule1.Taux.Open;
  end;

  //Special sort when filter details
  aux2:='';
  if (visiblehave=false) OR (visiblemiss=false) then begin

    aux2:='Have ';
    If visiblehave=false then
      aux2:=aux2+'ASC,'
    else
    if visiblemiss=false then
      aux2:=aux2+'DESC,'
  end;

  Datamodule1.Qaux.SQL.Text:='SELECT * FROM Z'+aux+' ORDER BY '+fieldname+','+aux2+sqlsortcolumn(detaillv);
  BMDThread1.Start();
  waitforfinishthread;

  Datamodule1.Qaux2.SQL.Text:='SELECT * FROM Y'+aux;

  Datamodule1.Qaux2.Tag:=1;
  BMDThread1.Start();
  waitforfinishthread;

  x:=Datamodule1.Qaux2.RecordCount+1; //FAKE ID COUNTER

  Datamodule1.Qaux3.SQL.Text:='SELECT * FROM Y'+aux;
  Datamodule1.Qaux3.Tag:=1;
  BMDThread1.Start();
  waitforfinishthread;

  //Initialize
  if DB.InTransaction=false then
    DB.StartTransaction;

  setromscounter:=0;
  totalroms:=0;
  sethavecounter:=0;
  complete:=0;
  incomplete:=0;
  empty:=0;
  totalsize:=0;

  //FIRST LINE FIX
  while not Datamodule1.Qaux.Eof do begin

    application.ProcessMessages;

    calc:=true;
                              //Merge
    if Datamodule1.Qaux.fields[10].asboolean=true then
      if allowmerge=false then
        calc:=false;
                              //Dupe
    if Datamodule1.Qaux.Fields[11].asboolean=true then
      if allowdupe=false then
        calc:=false;

    if calc=true then
      break;

    Datamodule1.Qaux.next;
  end;

  curid:=Datamodule1.Qaux.fields[fieldnum].asinteger;

  while not Datamodule1.Qaux.Eof do begin

    application.ProcessMessages;

    calc:=true;
                                //Merge
    if Datamodule1.Qaux.fields[10].asboolean=true then
      if allowmerge=false then
        calc:=false;
                                //Dupe
    if Datamodule1.Qaux.Fields[11].asboolean=true then
      if allowdupe=false then
        calc:=false;

    if calc=true then begin

      tid:=Datamodule1.Qaux.fields[fieldnum].asinteger;

      if tid=curid then begin
        setromscounter:=setromscounter+1;
        totalroms:=totalroms+1;                    //Space
        totalsize:=totalsize+Datamodule1.Qaux.fields[2].ascurrency;

        if filemode<>0 then                 //Setnamemaster
          curmaster:=Datamodule1.Qaux.fields[8].asinteger; //PRIOR MASTER
      end
      else begin //END OF SET

        if totalroms=sethavecounter then begin
          complete:=complete+1;
          calc:=vmastercomp;
        end
        else
        if sethavecounter=0 then begin
          empty:=empty+1;
          calc:=vmasterempty;
        end
        else begin
          incomplete:=incomplete+1;
          calc:=vmasterincomp;
        end;

        if calc=true then begin
          cloneof:='';

          if filemode<>0 then //FIND CLONE
            if curid<>curmaster then begin
              Datamodule1.Qaux3.Locate('ID',curmaster,[]);    //Description
              cloneof:=getwiderecord(Datamodule1.Qaux3.fields[1]);
            end;

          //FIND IN MASTER
          Datamodule1.Qaux2.Locate('ID',curid,[]);

          mastertable.Append;

          mastertable.Fields[0].AsInteger:=x; //CONT
          mastertable.Fields[1].asinteger:=curid;
          setwiderecord(mastertable.Fields[2],getwiderecord(Datamodule1.Qaux2.Fields[1]));//Description
          setwiderecord(mastertable.Fields[3],getwiderecord(Datamodule1.Qaux2.Fields[2]));//Gamename
          mastertable.Fields[4].AsCurrency:=totalsize;  //Size_
          mastertable.Fields[5].asinteger:=sethavecounter;//Have_
          mastertable.Fields[6].asinteger:=totalroms; //Total_
          setwiderecord(mastertable.Fields[7],cloneof);//Master

          if isofftable=true then begin  //Add Offlinefields

            Datamodule1.Taux.Locate('Setid',curid,[]);

            setwiderecord(mastertable.Fields[8],getwiderecord(Datamodule1.Taux.Fields[2]));
            setwiderecord(mastertable.Fields[9],getwiderecord(Datamodule1.Taux.Fields[3]));
            setwiderecord(mastertable.Fields[10],getwiderecord(Datamodule1.Taux.Fields[5]));
            setwiderecord(mastertable.Fields[11],getwiderecord(Datamodule1.Taux.Fields[6]));
            setwiderecord(mastertable.Fields[12],getwiderecord(Datamodule1.Taux.Fields[8]));
            mastertable.Fields[13].asinteger:=Datamodule1.Taux.Fields[10].asinteger;

          end;

          mastertable.post;

          x:=x+1;

        end;

        setromscounter:=1;
        totalroms:=1;
        sethavecounter:=0;                 //Space
        totalsize:=Datamodule1.Qaux.fields[2].ascurrency;
        curid:=tid;
                           //0.029 FIX Relationship between master/detail display
        if filemode<>0 then                 //Setnamemaster
          curmaster:=Datamodule1.Qaux.fields[8].asinteger; //PRIOR MASTER
      end;
                                        //Have
      if Datamodule1.Qaux.Fields[9].asboolean=true then
        sethavecounter:=sethavecounter+1;

      detailtable.Append;
                          //CONT
      detailtable.Fields[0].asinteger:=setromscounter;
                             //Setname
      detailtable.Fields[7].asinteger:=curid;
                                     //Romname
      setwiderecord(detailtable.Fields[1],getwiderecord(Datamodule1.Qaux.fields[1]));
                         //Space
      detailtable.Fields[2].ascurrency:=Datamodule1.Qaux.Fields[2].ascurrency;
                         //CRC
      detailtable.Fields[3].asstring:=Datamodule1.Qaux.Fields[3].asstring;
                        //MD5
      detailtable.Fields[4].asstring:=Datamodule1.Qaux.Fields[4].asstring;
                       //SHA1
      detailtable.Fields[5].asstring:=Datamodule1.Qaux.Fields[5].asstring;
                      //Type
      detailtable.Fields[6].asstring:=Datamodule1.Qaux.Fields[6].asstring;
                        //Have
      detailtable.Fields[8].asboolean:=Datamodule1.Qaux.Fields[9].asboolean;

      detailtable.Post;

    end;

    Datamodule1.Qaux.Next;
  end;

  //LAST LINE FIX ---------------------

  if totalroms=sethavecounter then begin
    complete:=complete+1;
    calc:=vmastercomp;
  end
  else
  if sethavecounter=0 then begin
    empty:=empty+1;
    calc:=vmasterempty;
  end
  else begin
    incomplete:=incomplete+1;
    calc:=vmasterincomp;
  end;

  if Datamodule1.Qaux3.RecordCount=0 then  //FIX EMPTY PROFILE 0.037
    complete:=0;
                          //FIX EMPTY PROFILE 0.037
  if (calc=true) AND (Datamodule1.Qaux3.RecordCount<>0) then begin

    cloneof:='';
    tid:=Datamodule1.Qaux.Fields[fieldnum].AsInteger;

    if filemode<>0 then //FIND CLONE   //Setnamemaster
      if tid<>Datamodule1.Qaux.Fields[8].AsInteger then begin
        Datamodule1.Qaux3.Locate('ID',Datamodule1.Qaux.Fields[8].AsInteger,[]);
        cloneof:=getwiderecord(Datamodule1.Qaux3.fields[1]); //Description
      end;

      //FIND IN MASTER
      Datamodule1.Qaux2.Locate('ID',tid,[]);

      mastertable.Append;

      mastertable.Fields[1].asinteger:=tid;
      mastertable.Fields[0].AsInteger:=x; //CONT
      setwiderecord(mastertable.Fields[2],getwiderecord(Datamodule1.Qaux2.Fields[1]));//Description
      setwiderecord(mastertable.Fields[3],getwiderecord(Datamodule1.Qaux2.Fields[2]));//Gamename
      mastertable.Fields[4].AsCurrency:=totalsize;  //Size_
      mastertable.Fields[5].asinteger:=sethavecounter;//Have_
      mastertable.Fields[6].asinteger:=totalroms; //Total_
      setwiderecord(mastertable.Fields[7],cloneof);//Master

      if isofftable=true then begin  //Add Offlinefields

        Datamodule1.Taux.Locate('Setid',curid,[]);

        setwiderecord(mastertable.Fields[8],getwiderecord(Datamodule1.Taux.Fields[2]));
        setwiderecord(mastertable.Fields[9],getwiderecord(Datamodule1.Taux.Fields[3]));
        setwiderecord(mastertable.Fields[10],getwiderecord(Datamodule1.Taux.Fields[5]));
        setwiderecord(mastertable.Fields[11],getwiderecord(Datamodule1.Taux.Fields[6]));
        setwiderecord(mastertable.Fields[12],getwiderecord(Datamodule1.Taux.Fields[8]));
        mastertable.Fields[13].asinteger:=Datamodule1.Taux.Fields[10].asinteger;

      end;

      mastertable.post;

  end;


  //--------------------------------

  Datamodule1.Qaux.close;
  Datamodule1.Qaux2.close;
  Datamodule1.Qaux3.close;

  Datamodule1.Taux.close;

  //NOW SORT
  Datamodule1.Qsort.close;
  Datamodule1.Qsort.sql.Clear;
  Datamodule1.Qsort.RequestLive:=true;

  Datamodule1.Qsort.DatabaseName:=Db.Name;
  Datamodule1.Qsort.sql.Add('SELECT * FROM TM');
  Datamodule1.Qsort.sql.Add(sqlsortcolumn(masterlv));

  Datamodule1.Qaux.sql.Text:='QSORT';
  BMDThread1.Start();
  waitforfinishthread;

  Datamodule1.Qaux.sql.Text:='';
  Datamodule1.Qaux.close;

  x:=1;

  //NOW PUT THE CORRECT INDEX

  While Datamodule1.Qsort.Eof=false do begin

    Application.ProcessMessages;

    Datamodule1.Qsort.Edit;
    Datamodule1.Qsort.fields[0].asinteger:=x;

    if isofftable=true then //0.030 SAVE ORIGINAL POSSITION FOR OFFLINELIST
      Datamodule1.Qsort.fields[14].asinteger:=x;

    Datamodule1.Qsort.Post;

    x:=x+1;
    Datamodule1.Qsort.Next;

  end;

  Datamodule1.Qsort.Close;

//END CHANGES 0.028----------------------------------------------

  (FindComponent('CLONE_Panel28_'+aux) as TTntpanel).Caption:=fillwithzeroes(inttostr(complete),4);
  (FindComponent('CLONE_Panel29_'+aux) as TTntpanel).Caption:=fillwithzeroes(inttostr(incomplete),4);
  (FindComponent('CLONE_Panel30_'+aux) as TTntpanel).Caption:=fillwithzeroes(inttostr(empty),4);

  masterpanel.tag:=complete+incomplete+empty;

  //FILTER ADD
  if applyfilter=true then begin  //0.030 REM Set correct possitions TODO

    totalsets:=mastertable.RecordCount;

    mastertable.Filtered:=true;
    complete:=1;

    for x:=1 to totalsets do begin
      application.ProcessMessages;

      if mastertable.Locate('CONT',x,[])=true then begin

        mastertable.Edit;
        mastertable.fields[0].asinteger:=complete;
        mastertable.Post;

        complete:=complete+1;
     end;

    end;

  end;

  DBaux:=DB;  //MUST COMMIT
  Datamodule1.Qaux.SQL.Text:='POSTDB';
  BMDThread1.Start();
  waitforfinishthread;

  masterlv.rootnodecount:=mastertable.RecordCount;

  detailedit.Tag:=0;

  posintoindexbynode(masterlv.getfirst,masterlv);

end;

(FindComponent('CLONE_Panel23_'+aux) as TTntpanel).Visible:=true;

//FIXES
(FindComponent('CLONE_Panel37_'+aux) as TTntpanel).left:=(FindComponent('CLONE_Panel27_'+aux) as TTntpanel).width-(FindComponent('CLONE_Panel37_'+aux) as TTntpanel).width+1;//FIX PANEL POSSITION
(FindComponent('CLONE_Panel38_'+aux) as TTntpanel).left:=(FindComponent('CLONE_Panel15_'+aux) as TTntpanel).width-(FindComponent('CLONE_Panel38_'+aux) as TTntpanel).width+1; //FIX PANEL POSSITION
(FindComponent('CLONE_Panel39_'+aux) as TTntpanel).left:=(FindComponent('CLONE_Panel37_'+aux) as TTntpanel).left-(FindComponent('CLONE_Panel39_'+aux) as TTntpanel).width-3;
(FindComponent('CLONE_Panel40_'+aux) as TTntpanel).left:=(FindComponent('CLONE_Panel38_'+aux) as TTntpanel).left-(FindComponent('CLONE_Panel40_'+aux) as TTntpanel).width-3;
(FindComponent('CLONE_Edit1_'+aux) as TTntedit).left:=0;
(FindComponent('CLONE_Edit1_'+aux) as TTntedit).width:=(FindComponent('CLONE_Panel26_'+aux) as TTntpanel).width;
(FindComponent('CLONE_Edit1_'+aux) as TTntedit).Repaint;
(FindComponent('CLONE_Edit2_'+aux) as TTntedit).left:=0;
(FindComponent('CLONE_Edit2_'+aux) as TTntedit).width:=(FindComponent('CLONE_Panel34_'+aux) as TTntpanel).width;
(FindComponent('CLONE_Edit2_'+aux) as TTntedit).Repaint;


//Hide all possible non current tab parents
if tabid=aux then
for x:=0 to ComponentCount-1 do
  if components[x] is TTntpanel then
    if (components[x] as TTntpanel).Name<>'CLONE_Panel23_'+aux then
      if gettoken((components[x] as TTntpanel).Name,'_',2)='Panel23' then
        (components[x] as TTntpanel).Visible:=false;

//FORZED
detailtotal.Caption:=traduction(24)+' '+fillwithzeroes(inttostr(detaillv.rootnodecount),4)+' '+'/'+' '+fillwithzeroes(mastertable.fieldbyname('total_').asstring,4);

if forzeddetail=true then
  if forzedmaster=false then begin

    mastertable.Locate('ID',detailedit.Tag,[]);

    if (visiblehave=true) and (visiblemiss=true) then
      detaillv.rootnodecount:=mastertable.fieldbyname('total_').asinteger
    else
    if visiblehave=true then
      detaillv.rootnodecount:=mastertable.fieldbyname('have_').asinteger
    else
      detaillv.rootnodecount:=mastertable.fieldbyname('total_').asinteger-mastertable.fieldbyname('have_').asinteger;

    //detailtotal.Caption:=traduction(24)+' '+fillwithzeroes(inttostr(detaillv.Items.count),4)+' '+'/'+' '+fillwithzeroes(mastertable.fieldbyname('total_').asstring,4);
    detailhave.Caption:=fillwithzeroes(mastertable.fieldbyname('Have_').asstring,4);
    detailmiss.Caption:=fillwithzeroes(inttostr(mastertable.fieldbyname('Total_').asinteger-mastertable.fieldbyname('Have_').asinteger),4);


    detaillv.Selected[detaillv.GetFirst]:=true;
    detaillv.Repaint;

  end;

updatemasterpanel;

try //FACE

  Datamodule1.Tprofiles.Locate('ID',aux,[]);

  if Datamodule1.Tprofiles.fieldbyname('Haveroms').asstring='' then
    x:=3
  else
  if Datamodule1.Tprofiles.fieldbyname('Haveroms').asstring='0' then
    x:=2
  else
  if Datamodule1.Tprofiles.fieldbyname('Haveroms').asstring=Datamodule1.Tprofiles.fieldbyname('Totalroms').asstring then
    x:=0
  else
    x:=1;

  if Datamodule1.Tprofiles.fieldbyname('Shared').asboolean=true then
    x:=x+4;

  //CLONE_TabSheet7_0001
  //BUG SINZE 0.023 must redraw caption to changes icon in some cases
  (FindComponent('CLONE_TabSheet7_'+aux) as TTntTabSheet).ImageIndex:=-1;
  (FindComponent('CLONE_TabSheet7_'+aux) as TTntTabSheet).ImageIndex:=x;

except
end;

if masterlv.rootnodecount=0 then begin
  detailhave.Caption:='0000';
  detailmiss.caption:='0000';
  detailhave.Repaint;
  detailmiss.Repaint;
  detailtotal.Caption:=traduction(24)+' '+'0000'+' '+'/'+' '+'0000';
  detailtotal.Repaint;
end;

if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([strtoint(getcurrentprofileid),'I']),[])=true then begin

  if edit3.Text<>getwiderecord(Datamodule1.TDirectories.fieldbyname('Path')) then
    edit3.Text:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));

  imagespath:=edit3.text;

end
else begin
  edit3.text:='';
  imagespath:='';
end;

loadimages;
if displayimg=true then //0.037
  panel16.Width:=255;

showprofilesmasterselected;
showprofilesdetailselected;
end;


procedure Tfmain.showprolesmasterdetail(master,detail:boolean;id:ansistring;progress:boolean;saverestorefocus:boolean);
begin

if saverestorefocus=true then
  savefocussedcontrol;

if progress=true then
  if (master=true) or (detail=true) then begin
    showprocessingwindow(false,false); //CAN NOT BE IMPLEMENTED
    Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(62);
    Fprocessing.Panel2.Caption:=changein((PageControl2.ActivePage as Ttnttabsheet).Hint,'&','&&');
  end;

showcurrentscantab(master,detail,id);

if progress=true then
  if (master=true) or (detail=true) then
    hideprocessingwindow;

if saverestorefocus=true then
  restorefocussedcontrol;

end;

procedure Tfmain.deletescantabs(i:integer);
var
x:integer;
id:ansistring;
begin
id:=getcurrentprofileid;

LockWindowUpdate(Handle);

for x:=PageControl2.PageCount-1 downto 1 do
  if (pagecontrol2.Pages[x].ImageIndex=i) OR (pagecontrol2.Pages[x].ImageIndex=i+4) then begin
    PageControl2.ActivePageIndex:=x;
    deletecurrentscantab;
  end;

if pagecontrol2.PageCount>1 then begin//RECOVER ID
  pagecontrol2.ActivePageIndex:=1;//IF NOT RECOVER ALWAYS IN FIRST
  for x:=1 to pagecontrol2.PageCount-1 do
    if gettoken(pagecontrol2.Pages[x].Name,'_',3)=id then begin
      pagecontrol2.ActivePageIndex:=x;
      break;
    end;
end;

refreshallfaces;//0.044
showprolesmasterdetail(false,false,getcurrentprofileid,true,true);

LockWindowUpdate(0);
end;

procedure Tfmain.deleteallscantabs;
begin
getcurrentprofileid;
LockWindowUpdate(Handle);

while PageControl2.PageCount>1 do
  deletecurrentscantab;

LockWindowUpdate(0);

showprolesmasterdetail(false,false,getcurrentprofileid,true,true);
end;

procedure Tfmain.createnewprofiledetail(id:ansistring;description:widestring);
var
p,p2,p3,father:Tcomponent;
DB:TABSDatabase;
T:Tabstable;
begin
if (Datamodule1.FindComponent('DB'+id) as TABSDatabase)<>nil then begin
  exit;
end;

DB:=TABSDatabase.Create(Datamodule1);
DB.SilentMode:=true;
DB.Name:='DB'+id;
DB.DatabaseName:=DB.name;
DB.DatabaseFileName:=UTF8Encode(tempdirectorymasterdetail(id));
DB.DisableTempFiles:=true;
DB.PageCountInExtent:=defpagecountinextent;
DB.PageSize:=defpagesize;
DB.MaxConnections:=defmaxconnections;
DB.CreateDatabase;
DB.Open;

T:=TABSTable.Create(datamodule1);
T.Name:='TM'+id;
T.DatabaseName:=DB.DatabaseName;
T.FieldDefs.Clear;
T.TableName:='TM';
T.FieldDefs.Add('CONT',ftLargeint,0,true);
T.FieldDefs.Add('ID',ftLargeint,0,True);
T.FieldDefs.Add('Description',ftwidestring,255,true);
T.FieldDefs.Add('Gamename',ftwidestring,255,true);
T.FieldDefs.Add('Size_',ftCurrency,0,false);
T.FieldDefs.Add('Have_',ftLargeint,0,true);
T.FieldDefs.Add('Total_',ftLargeint,0,true);
T.FieldDefs.Add('Master',ftwidestring,255,false);

if Datamodule1.Tprofilesview.FieldByName('Original').asstring='O' then begin //0.030 create when necessary else speedup :)
  T.FieldDefs.Add('Publisher',ftwidestring,255,false);
  T.FieldDefs.Add('Savetype',ftwidestring,255,false);
  T.FieldDefs.Add('Comment',ftwidestring,255,false);
  T.FieldDefs.Add('Language',ftwidestring,255,false);
  T.FieldDefs.Add('Sourcerom',ftwidestring,255,false);
  T.FieldDefs.Add('Locationnum',ftinteger,0,false);
  T.FieldDefs.Add('OCONT',ftLargeint,0,false);
end;

T.IndexDefs.Clear;
T.IndexDefs.Add('ITM', 'CONT', []); //Speedup locate
T.IndexDefs.Add('ITM2', 'ID', [ixUnique]); //Speedup locate

T.CreateTable;
T.open;

T:=TABSTable.Create(datamodule1);
T.Name:='TD'+id;
T.DatabaseName:=DB.DatabaseName;
T.FieldDefs.Clear;
T.TableName:='TD';
T.FieldDefs.Add('CONT',ftLargeint,0,true);
T.FieldDefs.Add('Romname',ftwidestring,255,true);
T.FieldDefs.Add('Space',ftCurrency,0,false);
T.FieldDefs.Add('CRC',ftString,8,false);
T.FieldDefs.Add('MD5',ftString,32,false);
T.FieldDefs.Add('SHA1',ftString,40,false);
T.FieldDefs.Add('Type',ftString,1,false);
T.FieldDefs.Add('Setname',ftLargeint,0,true);
T.FieldDefs.Add('Have',ftBoolean,0,true);


T.IndexDefs.Clear;
T.IndexDefs.Add('ITD', 'CONT;Setname', [ixPrimary]); //Speedup locate
T.IndexDefs.Add('IDX', 'Setname', []); //Speedup locate
T.IndexDefs.Add('IDT', 'Type', []); //Speedup locate

T.CreateTable;
T.open;

//Prepare table for possible offlinelistinfo
if DataModule1.Tprofilesview.fieldbyname('Original').AsString='O' then  begin//DUMMY
  T:=TABSTable.Create(datamodule1);
  T.Name:='O'+id;
  T.DatabaseName:=DB.DatabaseName;
  T.FieldDefs.Clear;
  T.TableName:='O'+id;
  T.FieldDefs.Add('ID',ftAutoInc,0,False);

  T.CreateTable;
  T.open;
end;

p:=CloneComponent(tabsheet7,id);
(p as TTnttabsheet).PageControl:=pagecontrol2;

(p as TTnttabsheet).Hint:=description;

(p as TTnttabsheet).Caption:=gettrimmedtext(changein(description,'&','&&'),200);

//PANEL 23 Father of all
father:=CloneComponent(panel23,id);
(father as TTntpanel).Parent:=tabsheet2;

//BOTTOM PANEL
p2:=CloneComponent(panel31,id);
(p2 as TTntpanel).Parent:=(father as TTntpanel);
(p2 as TTntpanel).Constraints.MinHeight:=80;
(p2 as TTntpanel).TabOrder:=1;

p:=CloneComponent(panel21,id);
(p as TTntpanel).Parent:=(p2 as TTntpanel);

p:=CloneComponent(panel15,id);
(p as TTntpanel).Parent:=(p2 as TTntpanel);
p3:=CloneComponent(panel40,id);
(p3 as TTntpanel).parent:=(p as TTntpanel);
p3:=CloneComponent(panel38,id);
(p3 as TTntpanel).parent:=(p as TTntpanel);

p3:=CloneComponent(bevel9,id);
(p3 as Tbevel).parent:=(p as TTntpanel);

p3:=CloneComponent(bevel8,id);
(p3 as Tbevel).parent:=(p as TTntpanel);

p3:=CloneComponent(speedbutton8,id);
(p3 as TTntspeedbutton).parent:=(p as TTntpanel);
(p3 as TTntspeedbutton).Down:=true;
(p3 as TTntspeedbutton).OnClick:=SpeedButton8.OnClick;
(p3 as TTntspeedbutton).Hint:=traduction(185);

p3:=CloneComponent(speedbutton9,id);
(p3 as TTntspeedbutton).parent:=(p as TTntpanel);
(p3 as TTntspeedbutton).Down:=true;
(p3 as TTntspeedbutton).OnClick:=SpeedButton9.OnClick;
(p3 as TTntspeedbutton).Hint:=traduction(186);

p3:=CloneComponent(panel18,id);
(p3 as TTntpanel).Parent:=(p as TTntpanel);

p3:=CloneComponent(panel19,id);
(p3 as TTntpanel).Parent:=(p as TTntpanel);

p:=CloneComponent(panel34,id);
(p as TTntpanel).Parent:=(p2 as TTntpanel);

p:=CloneComponent(edit2,id);
(p as TTntedit).Parent:=(p2 as TTntpanel);

p:=clonecomponent(VirtualStringTree3,id);
(p as TVirtualStringTree).Parent:=(p2 as TTntpanel);//Copy events
(p as TVirtualStringTree).OnGetText:=VirtualStringTree3.OnGetText;
(p as TVirtualStringTree).OnHeaderClick:=VirtualStringTree3.OnHeaderClick;
(p as TVirtualStringTree).OnResize:=VirtualStringTree3.OnResize;
(p as TVirtualStringTree).OnGetImageIndex:=VirtualStringTree3.OnGetImageIndex;

detaillv:=(p as TVirtualStringTree);

//SPLITTER
p2:=CloneComponent(splitter2,id);
(p2 as TSplitter).Parent:=(father as TTntpanel);
(p2 as Tsplitter).Height:=3;//FIX

//TOP PANEL
p2:=CloneComponent(panel24,id);
(p2 as TTntpanel).Parent:=(father as TTntpanel);
(p2 as TTntpanel).Constraints.MinHeight:=80;
(p2 as TTntpanel).taborder:=0;

p:=CloneComponent(panel26,id);
(p as TTntpanel).Parent:=(p2 as TTntpanel);

p3:=CloneComponent(edit1,id);
(p3 as TTntedit).Parent:=(p as TTntpanel);

p:=clonecomponent(VirtualStringTree1,id);
(p as TVirtualStringTree).Parent:=(p2 as TTntpanel);//Copy events
(p as TVirtualStringTree).OnGetText:=VirtualStringTree1.OnGetText;
(p as TVirtualStringTree).OnHeaderClick:=VirtualStringTree1.OnHeaderClick;
(p as TVirtualStringTree).OnResize:=VirtualStringTree1.OnResize;
(p as TVirtualStringTree).OnGetImageIndex:=VirtualStringTree1.OnGetImageIndex;

masterlv:=(p as TVirtualStringTree);
//Modify columns if exists table with name O+id


p:=CloneComponent(panel27,id);
(p as TTntpanel).Parent:=(p2 as TTntpanel);
p3:=CloneComponent(panel39,id);
(p3 as TTntpanel).Parent:=(p as TTntpanel);
p3:=CloneComponent(panel37,id);
(p3 as TTntpanel).Parent:=(p as TTntpanel);

p3:=CloneComponent(bevel12,id);
(p3 as Tbevel).Parent:=(p as TTntpanel);

//Copy events
p3:=CloneComponent(speedbutton14,id);
(p3 as TTntspeedbutton).Parent:=(p as TTntpanel);
(p3 as TTntspeedbutton).Down:=true;
(p3 as TTntspeedbutton).OnClick:=Speedbutton14.OnClick;
(p3 as TTntspeedbutton).Hint:=traduction(182);

p3:=CloneComponent(speedbutton15,id);
(p3 as TTntspeedbutton).Parent:=(p as TTntpanel);
(p3 as TTntspeedbutton).Down:=true;
(p3 as TTntspeedbutton).OnClick:=Speedbutton15.OnClick;
(p3 as TTntspeedbutton).Hint:=traduction(183);

p3:=CloneComponent(speedbutton16,id);
(p3 as TTntspeedbutton).Parent:=(p as TTntpanel);
(p3 as TTntspeedbutton).Down:=true;
(p3 as TTntspeedbutton).OnClick:=Speedbutton16.OnClick;
(p3 as TTntspeedbutton).Hint:=traduction(184);

p3:=CloneComponent(panel28,id);
(p3 as TTntpanel).parent:=(p as TTntpanel);
p3:=CloneComponent(panel29,id);

Datamodule1.Tprofiles.Locate('ID',strtoint(id),[]);
if DataModule1.Tprofiles.fieldbyname('Original').asstring='O' then
  p3.tag:=1;  //Offlinelist possible to show images

(p3 as TTntpanel).parent:=(p as TTntpanel);
p3:=CloneComponent(panel30,id);
(p3 as TTntpanel).parent:=(p as TTntpanel);

p3:=CloneComponent(panel43,id);
(p3 as TTntpanel).Parent:=(p2 as TTntpanel);

(father as TTntpanel).Visible:=false;

speedupdb;
fixcomponentsbugs(Fmain);

PageControl2.Pages[PageControl2.PageCount-1].TabVisible:=true;
pagecontrol2.Visible:=true;
pagecontrol2.ActivePageIndex:=PageControl2.PageCount-1;

showcurrentscantab(true,true,getcurrentprofileid);
end;

//-CONSTRUCTOR-----------------------------------------------

procedure Tfmain.onthreadconstructor(param:string);
var
checkcomp,checkmd5,checksha1,done:boolean;
filelistpath,crc,md5,sha1,fieldname:ansistring;
cad,ext,fil,aux,lastmain:widestring;
countmaindir,typ,correction:smallint;
org,pos,currid:longint;
space:currency;
x,z:integer;
begin
sterrors.Clear;
countmaindir:=0;

checkcomp:=speedbutton49.Down;
checkmd5:=speedbutton42.Down;
checksha1:=speedbutton43.Down;

DataModule1.DBConstructor.Close;
DataModule1.DBConstructor.DatabaseFileName:=UTF8Encode(tempdirectoryconstructor);

DataModule1.DBConstructor.PageCountInExtent:=defpagecountinextent;
DataModule1.DBConstructor.PageSize:=defpagesize;
DataModule1.DBConstructor.MaxConnections:=defmaxconnections;
DataModule1.DBConstructor.SilentMode:=true;

DataModule1.DBConstructor.CreateDatabase;

DataModule1.Tconstructor.close;
DataModule1.Tconstructor.FieldDefs.Clear;
DataModule1.Tconstructor.TableName:='Profiles';
DataModule1.Tconstructor.FieldDefs.Add('CONT',ftLargeint,0,False);
DataModule1.Tconstructor.FieldDefs.Add('ROOTCONT',ftLargeint,0,False);
DataModule1.Tconstructor.FieldDefs.Add('CHILDCONT',ftLargeint,0,False);

DataModule1.Tconstructor.IndexDefs.Clear;
DataModule1.Tconstructor.IndexDefs.Add('I', 'CONT', [ixPrimary]); //Speedup locate
DataModule1.Tconstructor.IndexDefs.Add('I3', 'Origin', []); //Speedup locate
DataModule1.Tconstructor.IndexDefs.Add('I4', 'Origin;Checked', []); //Speedup locate
DataModule1.Tconstructor.IndexDefs.Add('I5', 'ROOTCONT;CHILDCONT', []); //Speedup locate

DataModule1.Tconstructor.FieldDefs.Add('Filename',ftwidestring,255,true);
DataModule1.Tconstructor.FieldDefs.Add('Space',ftCurrency,0,true);
DataModule1.Tconstructor.FieldDefs.Add('CRC',ftString,8,false);
DataModule1.Tconstructor.FieldDefs.Add('MD5',ftString,32,false);
DataModule1.Tconstructor.FieldDefs.Add('SHA1',ftString,40,false);
DataModule1.Tconstructor.FieldDefs.Add('Path',ftwidestring,256,false); //Add path to temp table
DataModule1.Tconstructor.FieldDefs.Add('Checked',ftboolean,0,true);
DataModule1.Tconstructor.FieldDefs.Add('Origin',ftLargeint,0,true);
DataModule1.Tconstructor.FieldDefs.Add('Type',ftSmallint,0,true);
DataModule1.Tconstructor.FieldDefs.Add('Description',ftwidestring,255,false);

DataModule1.Tconstructor.CreateTable;
DataModule1.Tconstructor.open;

speedupdb;

DataModule1.DBConstructor.StartTransaction;


if param='CONSTRUCTOR' then begin //HASHING FROM FILES
  try

    filelistpath:=tempdirectoryresources+'files.rmt';
    listfiles:=TGpTextFile.CreateW(filelistpath);
    listfiles.Rewrite([cfUnicode]);

    decision:=2;

    if wideDirectoryExists(stdropfolders.Strings[0]) then begin
      Scandirectory(stdropfolders.Strings[0],'*.*',2,true);
      countmaindir:=gettokencount(stdropfolders[0],'\');
    end;

    listfiles.Reset;

    org:=0;

    while listfiles.EOF=false do begin

      if Fprocessing.Tag=1 then
        break;

      try

        cad:=listfiles.Readln;

        currentset:=wideextractfilename(cad);

        typ:=-1;

        //1ST STEP
        if FileExists2(cad) then begin //OBTAIN TYPES

          ext:=wideuppercase(wideextractfileext(cad));

          if (ext='.ZIP') AND (checkcomp=true) then begin
            if zipvalidfile(cad,Zip1)=true then begin
              if zip1multivolume=false then
                typ:=2
              else
                typ:=1;
            end
            else
              adderror(traduction(181)+' '+cad);
          end
          else
          if (ext='.RAR') AND (checkcomp=true) then begin
            if rarvalidfile(cad,rar1)=true then begin
              if rar1multivolume=false then
                typ:=3
              else
                typ:=1;
            end
            else
              adderror(traduction(181)+' '+cad);
          end
          else
          if (ext='.7Z') AND (checkcomp=true) then begin
            if sevenzipvalidfile(cad,SevenZip1)=true then begin
              if sevenzip1multivolume=false then
                typ:=4
              else
                typ:=1;
            end
            else
              adderror(traduction(181)+' '+cad);
          end
          else
            typ:=1;

        end //FILE EXISTS
        else
        if WideDirectoryExists(cad) then
          typ:=0;

        //2ND STEP

        if typ<>-1 then begin  //MANAGE TYPES

          space:=0;
          crc:='';
          md5:='';
          sha1:='';
          correction:=0;

          case typ of
            0:begin
              fil:=gettoken(cad,'\',gettokencount(cad,'\')-1);
              correction:=1;
            end;
            1:begin
              fil:=WideExtractFileName(cad);
              space:=sizeoffile(cad);
              crc:=GetCRC32(cad);

              if (checkmd5=true) OR (checksha1=true) then begin
                if checkmd5=true then
                  md5:=wideuppercase(CalcHash(cad,haMD5));
                if checksha1=True then
                  sha1:=wideuppercase(CalcHash(cad,haSHA1));
              end;

            end;
            2..4:fil:=filewithoutext(cad);
          end;

          if countmaindir+correction=gettokencount(cad,'\') then begin
            org:=0;
            lastmain:=checkpathbar(WideExtractFilePath(cad));
            if typ>1 then
              lastmain:=lastmain+fil+'\';
          end
          else begin
            if (typ=0) OR (typ=1) then begin

              fil:=Changein(cad,lastmain,'');

              if typ=0 then
                crc:='00000000';

            end
            else begin
              fil:=Changein(wideextractfilepath(cad)+filewithoutext(cad),lastmain,'')+'\';
              crc:='00000000';
            end;

          end;

          if org=0 then
            if typ=0 then begin //No process empty directory if is master
              if IsDirectoryEmpty(cad) then begin
                typ:=-1; //ADD ERROR
                adderror(traduction(352)+' '+cad);
              end;

            end
            else
            if typ=1 then begin

              fixpossibleemptysetconstructor(org);
              pos:=Datamodule1.Tconstructor.RecordCount+1;

              //CREATE DUMMY MASTER
              DataModule1.Tconstructor.append;
              DataModule1.Tconstructor.fieldbyname('CONT').asinteger:=pos;
              setwiderecord(DataModule1.Tconstructor.fieldbyname('Filename'),filewithoutext(fil));
              DataModule1.Tconstructor.fieldbyname('Space').ascurrency:=0;
              setwiderecord(DataModule1.Tconstructor.fieldbyname('Path'),lastmain);
              DataModule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
              DataModule1.Tconstructor.fieldbyname('Origin').asinteger:=org;
              DataModule1.Tconstructor.fieldbyname('Type').asinteger:=0;
              setwiderecord(DataModule1.Tconstructor.fieldbyname('Description'),filewithoutext(fil));
              DataModule1.Tconstructor.post;
              org:=Datamodule1.Tconstructor.fieldbyname('CONT').asinteger;
            end;


          //3RD STEP
          if typ<>-1 then begin

            done:=true; //CORRECTION
            if org=0 then
              done:=false;

            fixpossibleemptysetconstructor(org);
            pos:=Datamodule1.Tconstructor.RecordCount+1;

            DataModule1.Tconstructor.append;
            DataModule1.Tconstructor.fieldbyname('CONT').asinteger:=pos;
            setwiderecord(DataModule1.Tconstructor.fieldbyname('Filename'),fil);
            DataModule1.Tconstructor.fieldbyname('CRC').asstring:=crc;
            DataModule1.Tconstructor.fieldbyname('Space').ascurrency:=space;
            setwiderecord(DataModule1.Tconstructor.fieldbyname('Path'),lastmain);
            DataModule1.Tconstructor.fieldbyname('MD5').asstring:=md5;
            DataModule1.Tconstructor.fieldbyname('SHA1').asstring:=sha1;
            DataModule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
            DataModule1.Tconstructor.fieldbyname('Type').asinteger:=0;

            if org=0 then
              setwiderecord(DataModule1.Tconstructor.fieldbyname('Description'),fil);

            DataModule1.Tconstructor.fieldbyname('Origin').asinteger:=org;
            DataModule1.Tconstructor.post;

            if done=false then begin //CORRECTION
              fil:='';
              org:=Datamodule1.Tconstructor.fieldbyname('CONT').asinteger;
            end;

            if typ>1 then //SCAN COMPRESSED

              for z:=0 to stcompfiles.Count-1 do begin

                if Fprocessing.Tag=1 then
                  break;


                done:=true;
                md5:='';
                sha1:='';
                                                                      //FIX 0.032 TRYING TO CHECK MD5 SHA1 OF FOLDER
                if ((checkmd5=true) or (checksha1=true)) AND (stcompfiles.strings[z][Length(stcompfiles.strings[z])]<>'\') then begin

                  aux:=changein(tempdirectoryextract+gettoken(stcompfiles.Strings[z],'\',GetTokenCount(stcompfiles.Strings[z],'\')),'?','-');

                  case typ of
                    2:done:=extractfilefromzip(Zip1,stcompfiles.Strings[z],tempdirectoryextract,false);
                    3:done:=extractfilefromrar(rar1,stcompfiles.Strings[z],tempdirectoryextract,false);
                    4:done:=extractfilefromsevenzip(sevenzip1,stcompfiles.Strings[z],tempdirectoryextract,false);
                  end;

                  if done=true then begin //MD5 SHA1 if necessary
                    if (checkmd5=true) then
                      md5:=wideuppercase(CalcHash(aux,haMD5));

                    if (checksha1=true) then
                      sha1:=wideuppercase(CalcHash(aux,haSHA1));

                    deletefile2(aux);
                  end
                  else begin
                    //ADD ERROR
                    adderror(traduction(181)+' '+cad+ ' > '+stcompfiles.Strings[z]);
                    deletefile2(aux);
                    break;
                  end;

                end;

                if done=true then begin

                  fixpossibleemptysetconstructor(org);
                  pos:=Datamodule1.Tconstructor.RecordCount+1;

                  DataModule1.Tconstructor.append;
                  DataModule1.Tconstructor.fieldbyname('CONT').asinteger:=pos;
                  setwiderecord(DataModule1.Tconstructor.fieldbyname('Filename'),fil+stcompfiles.strings[z]);
                  DataModule1.Tconstructor.fieldbyname('CRC').asstring:=stcompcrcs.Strings[z];
                  DataModule1.Tconstructor.fieldbyname('MD5').asstring:=md5;
                  DataModule1.Tconstructor.fieldbyname('SHA1').asstring:=sha1;
                  DataModule1.Tconstructor.fieldbyname('Space').ascurrency:=strtocurr(stcompsizes.Strings[z]);
                  setwiderecord(DataModule1.Tconstructor.fieldbyname('Path'),lastmain);
                  DataModule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
                  DataModule1.Tconstructor.fieldbyname('Type').asinteger:=0;

                  if org=0 then
                    setwiderecord(DataModule1.Tconstructor.fieldbyname('Description'),fil);

                  DataModule1.Tconstructor.fieldbyname('Origin').asinteger:=org;
                  DataModule1.Tconstructor.post;

                end;

              end;

          end;//PASS 3RD STEP

        end;//PASS 2ND STEP

        except
          if FileInUse(cad)=true then
            adderror(traduction(180)+' '+cad)
          else
            adderror(traduction(181)+' '+cad);
        end;

      end;//LOOP FILES

      except
          //adderror(fil);
      end;

      if Datamodule1.Tconstructor.RecordCount>0 then begin
        DataModule1.Tconstructor.last;
        if DataModule1.Tconstructor.fieldbyname('Origin').asinteger=0 then
          DataModule1.Tconstructor.Delete;
      end;

      if Fprocessing.Tag=1 then
        adderror(traduction(392));

    end
    else begin  //CONSTRUCTOR FROM PROFILE

      //TO OPTIMIZE
      {
      SELECT *
      FROM Z4445
      ORDER BY Setname,Romname

      SELECT *
      FROM Y4445
      ORDER BY Gamename
      }

      try
      aux:=trim(gettoken(Datamodule1.Qaux.SQL.Text,' ',2));

      //NEW CODE 0.028
      pos:=1;
      x:=Datamodule1.Tprofiles.fieldbyname('Filemode').AsInteger;
      fieldname:='Setname';

      case x of
        0:begin
          allowmerge:=true;//Same file
          allowdupe:=false;
          fieldname:='Setnamemaster';
        end;
        1:begin
          allowmerge:=false;//Normal
          allowdupe:=true;
        end;
        2:begin
          allowmerge:=true;//Big size
          allowdupe:=true;
        end;
      end;

      Datamodule1.Qaux.SQL.Clear;
      Datamodule1.Qaux.Close;
      Datamodule1.Qaux.SQL.add('SELECT * FROM Y'+aux);
      Datamodule1.Qaux.sql.Add('ORDER BY Gamename');
      Datamodule1.Qaux.Open;

      Datamodule1.Qaux2.SQL.Clear;
      Datamodule1.Qaux2.Close;
      Datamodule1.Qaux2.SQL.add('SELECT * FROM Z'+aux);
      Datamodule1.Qaux2.sql.Add('ORDER BY '+fieldname+',Romname');
      Datamodule1.Qaux2.Open;

      While not Datamodule1.Qaux.Eof do begin

        org:=0;
        if Fprocessing.Tag=1 then
          break;

        currid:=Datamodule1.Qaux.Fields[0].asinteger;

        if Datamodule1.Qaux2.Locate(fieldname,Datamodule1.Qaux.fields[0].asinteger,[]) then
          While (Datamodule1.Qaux2.fieldbyname(fieldname).AsInteger=currid) AND (Datamodule1.Qaux2.eof=false) do begin

            if Fprocessing.Tag=1 then
              break;

            done:=true;

            //Check validation
            if Datamodule1.Qaux2.FieldByName('Merge').asboolean=true then
              if allowmerge=false then
                done:=false;
            if Datamodule1.Qaux2.FieldByName('Dupe').AsBoolean=true then
              if allowdupe=false then
                done:=false;

            if done=true then begin

              if org=0 then begin //MASTER WRITE

                DataModule1.Tconstructor.append;
                DataModule1.Tconstructor.fieldbyname('CONT').asinteger:=pos;
                setwiderecord(DataModule1.Tconstructor.fieldbyname('Filename'),getwiderecord(Datamodule1.Qaux.fieldbyname('Gamename')));
                DataModule1.Tconstructor.fieldbyname('Space').ascurrency:=0;
                DataModule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
                DataModule1.Tconstructor.fieldbyname('Origin').asinteger:=0;
                setwiderecord(DataModule1.Tconstructor.fieldbyname('Description'),getwiderecord(Datamodule1.Qaux.fieldbyname('Description')));
                DataModule1.Tconstructor.fieldbyname('Type').asinteger:=0;
                DataModule1.Tconstructor.post;

                pos:=pos+1;

                org:=DataModule1.Tconstructor.fieldbyname('CONT').asinteger;

              end;

              //DETAIL WRITE

              md5:=Datamodule1.Qaux2.fieldbyname('MD5').asstring;
              if Length(md5)<>32 then
                md5:='';

              sha1:=Datamodule1.Qaux2.fieldbyname('SHA1').asstring;
              if length(sha1)<>40 then
                sha1:='';

              DataModule1.Tconstructor.append;          
              DataModule1.Tconstructor.fieldbyname('CONT').asinteger:=pos;
              setwiderecord(DataModule1.Tconstructor.fieldbyname('Filename'),getwiderecord(Datamodule1.Qaux2.fieldbyname('Romname')));
              DataModule1.Tconstructor.fieldbyname('CRC').asstring:=Datamodule1.Qaux2.fieldbyname('CRC').asstring;;
              DataModule1.Tconstructor.fieldbyname('MD5').asstring:=md5;
              DataModule1.Tconstructor.fieldbyname('SHA1').asstring:=sha1;
              DataModule1.Tconstructor.fieldbyname('Type').asinteger:=Datamodule1.Qaux2.fieldbyname('Type').asinteger;
              DataModule1.Tconstructor.fieldbyname('Space').ascurrency:=Datamodule1.Qaux2.fieldbyname('Space').ascurrency;
              DataModule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
              DataModule1.Tconstructor.fieldbyname('Origin').asinteger:=org;
              DataModule1.Tconstructor.post;

              pos:=pos+1;
            end; //END DONE

            Datamodule1.Qaux2.next;
          end; //END DETAIL LOOP


        Datamodule1.Qaux.Next;
      end;

      except
      end;

      if Fprocessing.Tag=1 then begin
        adderror(traduction(392));
        DataModule1.Tconstructor.close;
      end;

      Datamodule1.Qaux.Close;
      Datamodule1.Qaux2.Close;

      //OLD CODE
      {Datamodule1.Qaux.SQL.Clear;
      Datamodule1.Qaux.Close;
      Datamodule1.Qaux.SQL.Add('SELECT * FROM Y'+aux+',Z'+aux);

      //FILE TYPES
      x:=Datamodule1.Tprofiles.fieldbyname('Filemode').AsInteger;
      if x<>0 then
        Datamodule1.Qaux.sql.add('WHERE Y'+aux+'.ID=Z'+aux+'.Setname')
      else
        Datamodule1.Qaux.sql.add('WHERE Y'+aux+'.ID=Z'+aux+'.Setnamemaster');

      if (x=1) OR (x=0) then begin
        Datamodule1.Qaux.SQL.add('AND Merge=false');
        if x=0 then
          Datamodule1.Qaux.SQL.add('AND Dupe=false');
      end;

      Datamodule1.Qaux.SQL.Add('ORDER BY Description,Romname');

      {Datamodule1.Qaux.open;

      Datamodule1.Qaux2.sql.Clear;
      Datamodule1.Qaux2.close;
      Datamodule1.Qaux2.sql.add;


      try

        Datamodule1.Qaux.First;
        pos:=1;
        currid:=0;
        org:=0;

        While not Datamodule1.Qaux.Eof do begin

          if Fprocessing.Tag=1 then
            break;

          if currid<>Datamodule1.Qaux.FieldByName('ID').asinteger then begin  //SETNAME

            DataModule1.Tconstructor.append;
            DataModule1.Tconstructor.fieldbyname('CONT').asinteger:=pos;
            setwiderecord(DataModule1.Tconstructor.fieldbyname('Filename'),getwiderecord(Datamodule1.Qaux.fieldbyname('Gamename')));
            DataModule1.Tconstructor.fieldbyname('Space').ascurrency:=0;
            DataModule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
            DataModule1.Tconstructor.fieldbyname('Origin').asinteger:=0;
            setwiderecord(DataModule1.Tconstructor.fieldbyname('Description'),getwiderecord(Datamodule1.Qaux.fieldbyname('Description')));
            DataModule1.Tconstructor.fieldbyname('Type').asinteger:=0;
            DataModule1.Tconstructor.post;

            pos:=pos+1;
            currid:=Datamodule1.Qaux.FieldByName('ID').asinteger;
            org:=DataModule1.Tconstructor.fieldbyname('CONT').asinteger;
          end;

          md5:=Datamodule1.Qaux.fieldbyname('MD5').asstring;
          if Length(md5)<>32 then
            md5:='';

          sha1:=Datamodule1.Qaux.fieldbyname('SHA1').asstring;
          if length(sha1)<>40 then
            sha1:='';

          DataModule1.Tconstructor.append;
          DataModule1.Tconstructor.fieldbyname('CONT').asinteger:=pos;
          setwiderecord(DataModule1.Tconstructor.fieldbyname('Filename'),getwiderecord(Datamodule1.Qaux.fieldbyname('Romname')));
          DataModule1.Tconstructor.fieldbyname('CRC').asstring:=Datamodule1.Qaux.fieldbyname('CRC').asstring;;
          DataModule1.Tconstructor.fieldbyname('MD5').asstring:=md5;
          DataModule1.Tconstructor.fieldbyname('SHA1').asstring:=sha1;
          DataModule1.Tconstructor.fieldbyname('Type').asinteger:=Datamodule1.Qaux.fieldbyname('Type').asinteger;
          DataModule1.Tconstructor.fieldbyname('Space').ascurrency:=Datamodule1.Qaux.fieldbyname('Space').ascurrency;
          DataModule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
          DataModule1.Tconstructor.fieldbyname('Origin').asinteger:=org;
          DataModule1.Tconstructor.post;

          pos:=pos+1;
          Datamodule1.Qaux.next;
        end;

        except
          //FAIL SOMETHING
        end;

        if Fprocessing.Tag=1 then begin
          adderror(traduction(392));
          DataModule1.Tconstructor.close;
        end;

      Datamodule1.Qaux.close;
      }
    end;

try
  listfiles.Close;
  FreeAndNil(listfiles);
except
end;

try
  if Datamodule1.DBConstructor.InTransaction=true then
    DataModule1.DBConstructor.Commit(true);

  //
except
end;

stcompfiles.Clear;
stcompcrcs.Clear;

deletefile2(filelistpath);

stdropfolders.Clear;
end;

procedure Tfmain.uncheckallconstructor;
begin
Datamodule1.Tconstructor.first;
DataModule1.DBConstructor.StartTransaction;

while Datamodule1.Tconstructor.Eof=false do begin

  if Datamodule1.Tconstructor.fieldbyname('Checked').asboolean=True then begin
    Datamodule1.Tconstructor.edit;
    Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=false;
    Datamodule1.Tconstructor.post;
  end;


  Datamodule1.Tconstructor.next;
end;

try
  if Datamodule1.DBConstructor.InTransaction=true then
    DataModule1.DBConstructor.Commit(true);
except
end;

VirtualStringTree4.Repaint;

freemousebuffer;
freekeyboardbuffer;
end;

procedure Tfmain.invertcheckedconstructor;
var
b:boolean;
rec:longint;
begin
Datamodule1.Tconstructor.first;
DataModule1.DBConstructor.StartTransaction;

while Datamodule1.Tconstructor.Eof=false do begin

  rec:=Datamodule1.Tconstructor.fieldbyname('CONT').asinteger;

  if Datamodule1.Tconstructor.fieldbyname('Origin').asinteger=0 then begin

    b:=true;

    if Datamodule1.Tconstructor.locate('Origin;checked',VarArrayOf([rec,true]),[])=true then begin

      b:=false;

      if Datamodule1.Tconstructor.locate('Origin;checked',VarArrayOf([rec,false]),[])=true then
        b:=true;

      Datamodule1.Tconstructor.locate('CONT',rec,[]);
    end;//ELSE ALL ARE FALSE THEN MASTER = TRUE

  end
  else begin

    b:=true;
    if Datamodule1.Tconstructor.fieldbyname('Checked').asboolean=True then
      b:=false;
    //CHECK OR NOT MASTER
    Datamodule1.Tconstructor.locate('CONT',rec,[]);  
  end;

  Datamodule1.Tconstructor.edit;
  Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=b;
  Datamodule1.Tconstructor.post;

  Datamodule1.Tconstructor.next;
end;

try
  if Datamodule1.DBConstructor.InTransaction=true then
    DataModule1.DBConstructor.Commit(true);
except
end;

Fmain.checkconstructorstatus;

VirtualStringTree4.Repaint;

freemousebuffer;
freekeyboardbuffer;
end;

procedure Tfmain.fixpossibleemptysetconstructor(origin:Longint);
begin
try
if (Datamodule1.Tconstructor.IsEmpty=False) AND (origin=0) then begin //FIX POSSIBLE EMPTY SET
  Datamodule1.Tconstructor.Last;
  if Datamodule1.Tconstructor.FieldByName('Origin').asinteger=0 then
    DataModule1.Tconstructor.delete;
end;
except
end;
end;

procedure Tfmain.showconstructorselected;
begin
panel63.caption:=traduction(23)+' '+inttostr(VirtualStringTree4.SelectedCount);
end;

procedure Tfmain.checkselectedconstructor(b:boolean);
var
n,master:PVirtualNode;
inlevel,somethingchanged:boolean;
checkedsets,checkedroms,totalsets,totalroms,cont:longint;
begin
master:=nil;
inlevel:=false;
cont:=0;
somethingchanged:=false;
checkedsets:=-1;

try
  VirtualStringTree4.Enabled:=false;
  VirtualStringTree4.Enabled:=true;
  n:=VirtualStringTree4.GetFirst;
  DataModule1.Tconstructor.First;
  DataModule1.DBConstructor.StartTransaction;

  while n<>nil do begin

    if VirtualStringTree4.Selected[n]=true then

      if Datamodule1.Tconstructor.FieldByName('Checked').asboolean<>b then begin

          Datamodule1.Tconstructor.edit;
          Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=b;
          Datamodule1.Tconstructor.post;

          constructorchecknext(b,checkedsets,checkedroms,totalsets,totalroms);

          Datamodule1.Tconstructor.Locate('CONT',cont+1,[]);

          somethingchanged:=true;
      end; //Already in correct check status

    DataModule1.Tconstructor.next;
    cont:=cont+1;

    //Know if is master
    if (VirtualStringTree4.ChildCount[n]<>0) OR (inlevel=true) then begin
      if inlevel=false then begin
        master:=n;
        inlevel:=true;
        n:=VirtualStringTree4.GetFirstChild(master);
      end
      else begin
        n:=VirtualStringTree4.GetNextSibling(n);
        if not assigned(n) then begin
          inlevel:=false;
          n:=VirtualStringTree4.GetNextSibling(master);
        end;
      end;
    end
    else
      n:=VirtualStringTree4.GetNextSibling(n);

  end;//Loop in listview4
except
end;

try
  if Datamodule1.DBConstructor.InTransaction=true then
    DataModule1.DBConstructor.Commit(true);
except
end;

if somethingchanged=true then
  constructorstatuslite(checkedsets,checkedroms,totalsets,totalroms);

//checkconstructorstatus;
VirtualStringTree4.Repaint;
end;

procedure Tfmain.checkconstructorstatus;
var
b:Boolean;
checkedsets,totalsets,checkedroms,totalroms:integer;
begin
b:=true;
setgeneratorpathlabel;

if VirtualStringTree4.RootNodeCount=0 then
  b:=false;

speedbutton47.enabled:=b;
speedbutton48.enabled:=b;
speedbutton50.Enabled:=b;
speedbutton63.Enabled:=b;

try
  if Datamodule1.Tconstructor.Locate('Checked',true,[])=false then
    speedbutton44.Enabled:=false
  else
    speedbutton44.enabled:=b;
except
  speedbutton44.enabled:=b;
end;

checkedsets:=0;
checkedroms:=0;
totalsets:=0;
totalroms:=0;

try

  Datamodule1.Tconstructor.First;
  While not Datamodule1.Tconstructor.Eof do begin
    if Datamodule1.Tconstructor.FieldByName('Origin').AsInteger=0 then begin //Sets
      totalsets:=totalsets+1;
      if Datamodule1.Tconstructor.FieldByName('Checked').asboolean=true then
        checkedsets:=checkedsets+1;
    end
    else begin //Roms
      totalroms:=totalroms+1;
      if Datamodule1.Tconstructor.FieldByName('Checked').asboolean=true then
        checkedroms:=checkedroms+1;

    end;
    Datamodule1.Tconstructor.Next;
  end;
except
end;

panel64.Caption:=traduction(345)+' '+fillwithzeroes(inttostr(checkedsets),4)+' '+'/'+' '+fillwithzeroes(inttostr(totalsets),4);
panel62.Caption:=traduction(346)+' '+fillwithzeroes(inttostr(checkedroms),4)+' '+'/'+' '+fillwithzeroes(inttostr(totalroms),4);

end;

procedure Tfmain.findinlistviewbuilder(down:boolean);
var
param:ansistring;
begin
case combobox2.ItemIndex of
  0:param:='filename';
  1:param:='CRC';
  2:param:='MD5';
  3:param:='SHA1';
  4:param:='Description';
  5:param:='Path';
end;

findinlistview(VirtualStringTree4,Datamodule1.Tconstructor,down,edit6,param);
end;

procedure Tfmain.buildingchecksums(folder:boolean);
var
tabidx:shortint;
master:PVirtualNode;
begin
tabidx:=pagecontrol1.ActivePageIndex;
master:=nil;

savefocussedcontrol;

if VirtualStringTree4.rootnodecount>0 then
  if mymessagequestion(traduction(349),false)=0 then
    exit;

stop:=false;
currentset:='';
showprocessingwindow(true,false); //CAN CANCEL IMPLEMENTED

if folder=True then
  Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(331)
else
  Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(389);

Fprocessing.Repaint;

VirtualStringTree4.rootnodeCount:=0;
VirtualStringTree4.Repaint;

Datamodule1.Qaux.Close;

if folder=true then begin
  Datamodule1.Qaux.SQL.Text:='CONSTRUCTOR';
  sourcebuilder:=initialdirhash;
end
else begin

  if tabidx=0 then begin
    Datamodule1.Tprofilesview.Locate('CONT',VirtualStringTree2.FocusedNode.Index+1,[]);
    Datamodule1.Tprofiles.Locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
    sourcebuilder:=getwiderecord(Datamodule1.Tprofilesview.fieldbyname('Description'));
  end
  else begin
    Datamodule1.Tprofiles.Locate('ID',StrToInt(getcurrentprofileid),[]);
    sourcebuilder:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Description'));
  end;

  Fprocessing.Panel2.Caption:=changein(sourcebuilder,'&','&&');

  Datamodule1.Qaux.SQL.Text:='CONSTRUCTORPROFILE '+fillwithzeroes(Datamodule1.Tprofiles.fieldbyname('ID').AsString,4);
end;

sterrors.Clear;

BMDThread1.Start();
waitforfinishthread;

fixpossibleemptysetconstructor(0);

VirtualStringTree4.BeginUpdate;

try

  Datamodule1.DBConstructor.StartTransaction;

  Datamodule1.Tconstructor.First;

  While NOT Datamodule1.Tconstructor.Eof do begin

    if Datamodule1.Tconstructor.fieldbyname('Origin').asinteger=0 then begin//MASTER
      VirtualStringTree4.RootNodeCount:=VirtualStringTree4.RootNodeCount+1;
      master:=VirtualStringTree4.GetLast;
      Datamodule1.Tconstructor.edit;
      Datamodule1.Tconstructor.fieldbyname('ROOTCONT').asinteger:=VirtualStringTree4.RootNodeCount;
      Datamodule1.Tconstructor.fieldbyname('CHILDCONT').asinteger:=0;
      Datamodule1.Tconstructor.post;
    end
    else begin
      VirtualStringTree4.ChildCount[master]:=VirtualStringTree4.ChildCount[master]+1;
      VirtualStringTree4.Expanded[master]:=true; //NEEDED
      Datamodule1.Tconstructor.edit;
      Datamodule1.Tconstructor.fieldbyname('ROOTCONT').asinteger:=VirtualStringTree4.RootNodeCount;
      Datamodule1.Tconstructor.fieldbyname('CHILDCONT').asinteger:=VirtualStringTree4.ChildCount[master];
      Datamodule1.Tconstructor.post;
    end;

    Application.ProcessMessages;
    Datamodule1.Tconstructor.next;
  end;

except
end;

Datamodule1.Qaux.SQL.Text:='POSTDBCONSTRUCTOR';

BMDThread1.Start();
waitforfinishthread;

checkconstructorstatus;

VirtualStringTree4.Endupdate;

hideprocessingwindow;

if sterrors.Count>0 then
  mymessagewarning(sterrors.Text);

sterrors.clear;
stdropfolders.clear;

restorefocussedcontrol;

if folder=false then
  if VirtualStringTree4.rootnodecount>0 then
    PageControl1.ActivePageIndex:=2;

closepossiblyopenzip;//0.050

try
  stablishfocus(VirtualStringTree4);
  posintoindexbynode(VirtualStringTree4.getfirst,VirtualStringTree4);
except
end;
end;

procedure Tfmain.constructorchecknext(b:boolean;var checkedsets:longint;var checkedroms:longint;var totalsets:longint;var totalroms:longint);
var
sta:longint;
pass:boolean;
w:widestring;
begin
if checkedsets=-1 then begin
  w:=gettoken(panel64.Caption,' / ',gettokencount(panel64.caption,' / '));
  totalsets:=strtoint(w);

  w:=gettoken(panel64.Caption,' / ',1);
  w:=gettoken(w,' ',gettokencount(w,' '));
  w:=trim(w);
  checkedsets:=strtoint(w);

  w:=gettoken(panel62.Caption,' / ',gettokencount(panel62.caption,' / '));
  totalroms:=strtoint(w);

  w:=gettoken(panel62.Caption,' / ',1);
  w:=gettoken(w,' ',gettokencount(w,' '));
  w:=trim(w);
  checkedroms:=strtoint(w);
end;

sta:=Datamodule1.Tconstructor.fieldbyname('Origin').asinteger;
pass:=false;

if sta<>0 then begin
  if b=true then begin //Check/uncheck clone
    Datamodule1.Tconstructor.Locate('CONT',sta,[]);  //FIND MASTER
    pass:=true;
    checkedroms:=checkedroms+1;
  end
  else begin
    if Datamodule1.Tconstructor.Locate('Origin;Checked',VarArrayOf([sta,true]),[])=false then begin
      Datamodule1.Tconstructor.Locate('CONT',sta,[]);
      pass:=true;
    end;
    checkedroms:=checkedroms-1;
  end;

  if pass=true then begin //MODIFY MASTER
    if Datamodule1.Tconstructor.fieldbyname('Checked').asboolean<>b then begin
      Datamodule1.Tconstructor.edit;
      Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=b;
      Datamodule1.Tconstructor.post;

      if b=true then
        checkedsets:=checkedsets+1
      else
        checkedsets:=checkedsets-1;

    end;
  end;
end
else begin //Check/unckeck master
  if b=true then
    checkedsets:=checkedsets+1
  else
    checkedsets:=checkedsets-1;

  Datamodule1.Tconstructor.Next;

  while not Datamodule1.Tconstructor.Eof do begin
    sta:=Datamodule1.Tconstructor.fieldbyname('Origin').asinteger;

    if sta<>0 then begin  //MODIFY CLONE
      if Datamodule1.Tconstructor.FieldByName('Checked').asboolean<>b then begin
        Datamodule1.Tconstructor.edit;
        Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=b;
        Datamodule1.Tconstructor.post;

        if b=true then
          checkedroms:=checkedroms+1
        else
          checkedroms:=checkedroms-1;
      end;
    end
    else
      break;

    Datamodule1.Tconstructor.Next;
  end;
end;

end;

procedure Tfmain.constructorstatuslite(checkedsets,checkedroms,totalsets,totalroms:longint);
var
b:boolean;
begin
b:=true;
setgeneratorpathlabel;
if VirtualStringTree4.RootNodeCount=0 then
  b:=false;

speedbutton47.enabled:=b;
speedbutton48.enabled:=b;
speedbutton50.Enabled:=b;
speedbutton63.Enabled:=b;

try
  if Datamodule1.Tconstructor.Locate('Checked',true,[])=false then
    speedbutton44.Enabled:=false
  else
    speedbutton44.enabled:=b;
except
  speedbutton44.enabled:=b;
end;

panel64.Caption:=traduction(345)+' '+fillwithzeroes(inttostr(checkedsets),4)+' '+'/'+' '+fillwithzeroes(inttostr(totalsets),4);
panel62.Caption:=traduction(346)+' '+fillwithzeroes(inttostr(checkedroms),4)+' '+'/'+' '+fillwithzeroes(inttostr(totalroms),4);

VirtualStringTree4.Repaint;

freekeyboardbuffer;
freemousebuffer;
end;

procedure TFmain.lvClick(Sender: TObject);
var
hts : THitInfo;
lvCursorPos : TPoint;
li : PVirtualNode;
b:boolean;
root,child:longint;
checkedsets,checkedroms,totalsets,totalroms:longint;
closetransaction:boolean;
begin
inherited;
GetCursorPos(lvCursorPos);
lvcursorpos:=VirtualStringTree4.ScreenToClient(lvcursorpos);

//position of the mouse cursor related to ListView
li:=VirtualStringTree4.GetNodeAt(lvCursorPos);
if li=nil then
  exit;

//click where?
checkedsets:=-1;
closetransaction:=false;
VirtualStringTree4.GetHitTestInfoAt(lvCursorPos.X, lvCursorPos.Y,true,hts);

//locate the state-clicked item
if (hiOnStateIcon in hts.HitPositions) AND (hts.hitcolumn=0) then begin

  if Assigned(li) then begin

    //ROOTCONT, CHILDCONT
    child:=0;
    if VirtualStringTree4.GetNodeLevel(li) = 1 then begin
      root:=li.Parent.Index+1;
      child:=li.Index+1;
    end
    else
      root:=li.Index+1;

    Datamodule1.Tconstructor.Locate('ROOTCONT;CHILDCONT',VarArrayOf([root,child]),[]);

    if Datamodule1.DBConstructor.InTransaction=false then begin
      DataModule1.DBConstructor.StartTransaction;
      closetransaction:=true;
    end;

    b:=true;
    if Datamodule1.Tconstructor.fieldbyname('Checked').AsBoolean=true then
      b:=false;

    Datamodule1.Tconstructor.edit;
    Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=b;
    Datamodule1.Tconstructor.post;

    constructorchecknext(b,checkedsets,checkedroms,totalsets,totalroms);

    if closetransaction=true then
      DataModule1.DBConstructor.Commit(true);

  end
  else
    exit;

end
else
  exit;

constructorstatuslite(checkedsets,checkedroms,totalsets,totalroms);
end;


//-WEBBROWSER NAVIGATOR--------------------------------------

procedure Tfmain.wb_zoomtotrackbar(zoom:cardinal);
begin
try
  trackbar1.Position:=1000-zoom;
except
end;
end;

procedure Tfmain.Richedit2URLClick(Sender: TObject; const URL: String);
begin
//RECOVER TRAY IF NECESSARY
if CoolTrayIcon1.Tag<>0 then
  if PageControl1.Pages[3].TabVisible=true AND useownwb=true then
    CoolTrayIcon1DblClick(sender);

wb_navigate(url,true,false);
end;

function Tfmain.createorloadserverslist():boolean;
var
res:boolean;
dbpath,dbtemp:widestring;
Q:TABSQuery;
begin
res:=false;
dbpath:=checkpathbar(WideExtractfilepath(Tntapplication.ExeName))+'servers.lst';
try
  if Datamodule1.DBservers.Connected=false then begin //FAIL

    DataModule1.DBservers.DatabaseFileName:=UTF8Encode(dbpath);

    DataModule1.Tservers.TableName:='Servers';
    Datamodule1.Tservers.DatabaseName:=Datamodule1.DBServers.DatabaseName;

    if FileExists2(dbpath)=false then begin

      if isunicodefilename(dbpath) then begin
        dbtemp:=dbpath;
        dbpath:=tempdirectoryresources+'servers.rmt';
        DataModule1.DBservers.DatabaseFileName:=UTF8Encode(dbpath);
      end;

      Datamodule1.DBservers.SilentMode:=true;
      Datamodule1.DBservers.PageCountInExtent:=defpagecountinextent;
      Datamodule1.DBservers.PageSize:=defpagesize;
      Datamodule1.DBservers.MaxConnections:=defmaxconnections;

      Datamodule1.DBservers.CreateDatabase;

      DataModule1.Tservers.FieldDefs.Clear;

      DataModule1.Tservers.FieldDefs.Add('ID',ftAutoInc,0,False);
      DataModule1.Tservers.FieldDefs.Add('Description',ftWideString,255,false);
      DataModule1.Tservers.FieldDefs.Add('IP',ftWideString,255,True);
      DataModule1.Tservers.FieldDefs.Add('Port',ftInteger,0,True);
      DataModule1.Tservers.FieldDefs.Add('Password',ftWideString,255,false);

      DataModule1.Tservers.IndexDefs.Clear;
      DataModule1.Tservers.IndexDefs.Add('I', 'ID', [ixPrimary]); //Speedup locate
      DataModule1.Tservers.IndexDefs.Add('I2','IP', [ixCaseInsensitive]);

      DataModule1.Tservers.CreateTable;
    end;

    if dbtemp<>'' then begin
      DataModule1.DBServers.DatabaseFileName:=UTF8Encode(dbtemp);
      if movefile2(dbpath,dbtemp)=false then
        makeexception;
    end;

    Q:=Tabsquery.Create(self);
    Q.DatabaseName:=DataModule1.DBservers.DatabaseName;

    try //SINCE 0.033
      Q.sql.Add('ALTER TABLE Servers ADD (Password WIDESTRING(255))');
      Q.ExecSQL;
    except
    end;

    Freeandnil(Q);
    DataModule1.DBServers.Open;

    //SECURITY CHECK
    if Datamodule1.DBServers.TableExists('Servers')=false then
      Datamodule1.DBServers.Close;
      if deletefile2(dbpath)=true then //FAIL THEN DELETE AND RELOAD
        res:=createorloadserverslist
    else begin
      Datamodule1.Tservers.Open;
      res:=true;
    end;

  end
  else
    res:=true;
except
end;

Result:=res;
end;

function Tfmain.createorloadurllist():boolean;
var
res:boolean;
dbpath,dbtemp:widestring;
begin
res:=false;
dbpath:=checkpathbar(WideExtractfilepath(Tntapplication.ExeName))+'urls.lst';

try
  if Datamodule1.DBUrls.Connected=false then begin

    DataModule1.DBUrls.DatabaseFileName:=UTF8Encode(dbpath);

    if FileExists2(dbpath)=false then begin

      if isunicodefilename(dbpath) then begin
        dbtemp:=dbpath;
        dbpath:=tempdirectoryresources+'url.rmt';
        DataModule1.DBUrls.DatabaseFileName:=UTF8Encode(dbpath);
      end;

      Datamodule1.DBUrls.SilentMode:=true;
      Datamodule1.DBUrls.PageCountInExtent:=defpagecountinextent;
      Datamodule1.DBUrls.PageSize:=defpagesize;
      Datamodule1.DBUrls.MaxConnections:=defmaxconnections;

      Datamodule1.DBUrls.CreateDatabase;


      DataModule1.Thistory.FieldDefs.Clear;
      DataModule1.Thistory.TableName:='History';
      DataModule1.Thistory.FieldDefs.Add('ID',ftAutoInc,0,False);
      DataModule1.Thistory.FieldDefs.Add('Url',ftWideString,255,True);
      DataModule1.Thistory.IndexDefs.Clear;
      DataModule1.Thistory.IndexDefs.Add('I', 'ID', [ixPrimary]); //Speedup locate
      DataModule1.Thistory.IndexDefs.Add('I2','Url', [ixCaseInsensitive]);
      DataModule1.Thistory.IndexDefs.Add('I3','Url', [ixunique]);

      DataModule1.Thistory.CreateTable;


      DataModule1.Tfavorites.FieldDefs.Clear;
      DataModule1.Tfavorites.TableName:='Favorites';
      DataModule1.Tfavorites.FieldDefs.Add('ID',ftAutoInc,0,False);
      DataModule1.Tfavorites.FieldDefs.Add('Description',ftWideString,255,True);
      DataModule1.Tfavorites.FieldDefs.Add('Url',ftWideString,255,True);
      DataModule1.Tfavorites.FieldDefs.Add('Icon',ftGraphic,0,false);
      DataModule1.Tfavorites.FieldDefs.Add('Added',ftDateTime,0,true);


      DataModule1.Tfavorites.IndexDefs.Clear;
      DataModule1.Tfavorites.IndexDefs.Add('I', 'ID', [ixPrimary]); //Speedup locate
      DataModule1.Tfavorites.IndexDefs.Add('I2','Url', [ixCaseInsensitive]);
      DataModule1.Tfavorites.IndexDefs.Add('I3','Url', [ixunique]);

      DataModule1.Tfavorites.CreateTable;

    end;

    if dbtemp<>'' then begin
      DataModule1.DBUrls.DatabaseFileName:=UTF8Encode(dbtemp);
      if movefile2(dbpath,dbtemp)=false then
        makeexception;
    end;

    DataModule1.DBUrls.Open;

    //SECURITY CHECK
    if Datamodule1.DBUrls.TableExists('History')=false then
      Datamodule1.DBUrls.Close
    else begin //SINZE 0.021 WIDESTRING CONVERSION
      Datamodule1.Thistory.Open;

      if Datamodule1.Thistory.FieldByName('Url').DataType<>ftWideString then begin
        Datamodule1.Thistory.close;
        try
          Datamodule1.Qurls.SQL.Clear;
          Datamodule1.Qurls.SQL.Add('ALTER TABLE History MODIFY (Url WIDESTRING(255))');
          Datamodule1.Qurls.ExecSQL;
        except
        end;
      end;

      Datamodule1.Tfavorites.Open;
      if (Datamodule1.Tfavorites.FieldByName('Description').DataType<>ftWideString) OR (Datamodule1.Tfavorites.FieldByName('Url').DataType<>ftWideString) then begin
        Datamodule1.Tfavorites.close;
        try
          Datamodule1.Qurls.SQL.Clear;
          Datamodule1.Qurls.SQL.Add('ALTER TABLE Favorites MODIFY (Description WIDESTRING(255))');
          Datamodule1.Qurls.ExecSQL;
        except
        end;
        try
          Datamodule1.Qurls.SQL.Clear;
          Datamodule1.Qurls.SQL.Add('ALTER TABLE Favorites MODIFY (Url WIDESTRING(255))');
          Datamodule1.Qurls.ExecSQL;
        except
        end;
      end;

    end;

    if Datamodule1.DBUrls.Connected=false then begin
      if deletefile2(dbpath)=true then
        res:=createorloadurllist;
    end
    else begin
      Datamodule1.Thistory.Open;
      Datamodule1.Tfavorites.Open;
      res:=true;
    end;

  end
  else
    res:=true;
except
end;

Result:=res;
end;

procedure Tfmain.searchingoogle(text:widestring;newtab:boolean;ownforzed:boolean);
begin
wb_navigate('http://www.google.es/search?q='+Encodeurl(UTF8Encode(text),true)+'&ie=utf-8&oe=utf-8',newtab,ownforzed);
end;

function Tfmain.wb_current():TEmbeddedWB;
begin
Result:=(((PageControl3.ActivePage) as TTabSheetEx).EWB);
end;

procedure Tfmain.wb_updateurlbar(wb:TEmbeddedWB);
var
protocol,url:ansistring;
begin
if wb.Name=wb_current.Name then begin

    url:=wb_current.LocationURL;
    protocol:=Wideuppercase(Gettoken(url,':',1));

    if protocol='HTTPS' then begin
      combobox3.Text:=wb.LocationURL;
      combobox3.Color:=clMoneyGreen;
      combobox3.Repaint;
    end
    else begin
      combobox3.Color:=clwindow;
      combobox3.Text:=wb.LocationURL;
    end;

    if combobox3.Focused=true then
      combobox3.SelectAll;

    //ADD ICON TOO???
end;

end;

procedure wb_LoadHTML(WebBrowser: TEmbeddedWB; HTMLCode: ansistring);
var
  sl: TStringList;
  ms: TMemoryStream;
begin
  WebBrowser.Navigate('about:blank');
  while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
   application.processmessages;

  if Assigned(WebBrowser.Document) then
  begin
    sl := TStringList.Create;
    try
      ms := TMemoryStream.Create;
      try
        sl.Text := HTMLCode;
        sl.SaveToStream(ms);
        ms.Seek(0, 0);
        (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms));
      finally
        ms.Free;
      end;
    finally
      sl.Free;
    end;
  end;
end;

procedure Tfmain.wb_defaultpage(wb:TEmbeddedWB;info:boolean);
begin
wb_LoadHTML(wb,defaulthtmlsource(info));
end;

procedure Tfmain.wb_updatecontrols(wb:TEmbeddedWB);
var
tabex:TTabSheetEx;
oldcaption:widestring;
begin

if wb.Name=wb_current.name then begin

  wb_zoomtotrackbar(wb.ZoomPercent);

  (panel77.FindComponent('X'+wb.name) as TTntpanel).BringToFront;
  (panel78.FindComponent('P'+wb.name) as TProgressbar).BringToFront;

  TabEx := (PageControl3.ActivePage as TTabSheetEx);

  speedbutton57.Enabled:=tabex.CanForward;
  speedbutton56.Enabled:=tabex.CanBack;
  prior1.Enabled:=tabex.CanBack;
  next1.Enabled:=tabex.CanForward;

  oldcaption:=tabex.Caption;//REFRESH ICON BUGFIX
  tabex.Caption:='';

  if tabex.Canstop then begin
    tabex.ImageIndex:=1;
    speedbutton54.enabled:=true;
    Stop1.Enabled:=true;
    (panel77.FindComponent('X'+wb.name) as TTntpanel).caption:=traduction(456);//BUSY
  end
  else begin
    tabex.ImageIndex:=tabex.tag;
    speedbutton54.enabled:=false;
    Stop1.Enabled:=false;
    (panel77.FindComponent('X'+wb.name) as TTntpanel).caption:=traduction(147);//STOPPED
  end;

  tabex.Caption:=oldcaption;//REFRESH ICON BUGFIX

  wb.PopupMenu:=PopupMenu8;
    
end
else begin
  TabEx:=(FindComponent('T'+wb.name) as TTabSheetEx);

  oldcaption:=tabex.Caption;//REFRESH ICON BUGFIX
  tabex.Caption:='';

  if tabex.Canstop then
    tabex.ImageIndex:=1
  else
    tabex.ImageIndex:=tabex.Tag;

  tabex.Caption:=oldcaption;//REFRESH ICON BUGFIX
end;

end;

procedure TFmain.wb_CommandStateChange(ASender: TObject;
  Command: Integer; Enable: WordBool);
const
  CSC_UPDATECOMMANDS = $FFFFFFFF;
begin
try
  case TOleEnum(Command) of
    CSC_NAVIGATEBACK:
     (FindComponent('T'+TWinControl(asender).name) as Ttabsheetex).CanBack:=Enable;
    CSC_NAVIGATEFORWARD:
      (FindComponent('T'+TWinControl(asender).name) as Ttabsheetex).CanForward:=Enable;
  end;
except
end;

wb_updatecontrols(Asender as TEmbeddedWB);
end;

procedure Tfmain.wb_hidenotcurrent; //HIDES WB NOT IN ACTIVE TAB
var
x:integer;
begin

for x:=0 to Pagecontrol3.PageCount-1 do
  if ((pagecontrol3.Pages[x]) as TTabSheetEx).ewb<>wb_current then
    (((pagecontrol3.Pages[x]) as TTabSheetEx).ewb).Hide
  else
    (((pagecontrol3.Pages[x]) as TTabSheetEx).ewb).Visible:=true
end;

procedure Tfmain.wb_appendtext(text:ansistring;wb:TEmbeddedWB);
var
  Range: IHTMLTxtRange;
begin
  Range := ((wb.Document as IHTMLDocument2).body as
    IHTMLBodyElement).createTextRange;
  Range.collapse(False);
  Range.pasteHTML('<br><b>'+text+'!</b>');
end;

procedure TFmain.Wb_TitleChange(ASender: TObject;
  const Text: WideString);
var
ico:Ticon;
path,acumul,aux:widestring;
index,x:integer;
pre,pos,url,baseurl:widestring;
begin

baseurl:=(Asender as TEmbeddedWB).LocationURL;
if baseurl[Length(baseurl)]='/' then       //REMOVE LAST BAR
  baseurl:=Copy(baseurl,0,length(baseurl)-1);

pre:=gettoken((Asender as TEmbeddedWB).LocationURL,'//',1);
pre:=pre+'//';
pos:=gettoken((Asender as TEmbeddedWB).LocationURL,pre,2);
pos:=gettoken(pos,'/',1);
url:=pre+pos+'/favicon.ico';

(FindComponent('T'+TWinControl(asender).name) as Ttabsheetex).Hint:=text;
(FindComponent('T'+TWinControl(asender).name) as Ttabsheetex).Caption:=gettrimmedtext(changein(text,'&','&&'),200);

wb_updateurlbar(Asender as TEmbeddedWB);

ico:=Ticon.Create;
path:=tempdirectoryresources+'favicon.ico';
deletefile(path);
index:=-1;

//NOT LOAD SAME ICON MORE THAN 1 TIME FOR URL
if (FindComponent('T'+TWinControl(asender).name) as Ttabsheetex).favicourl<>url then begin

  //SET THE NEW ICON URL
  (FindComponent('T'+TWinControl(asender).name) as Ttabsheetex).favicourl:=url;

  try //SLOWDOWN GETTING ICON
    //makeexception;

    index:=(FindComponent('T'+TWinControl(asender).name) as TTabSheetEx).tag;

    if isthisvalidurl(url)=false then
      makeexception;

    if (Asender as TEmbeddedWB).DownloadFile(url,path)=false then
      makeexception;

    ico.LoadFromFile(path);
    imagelist7.ReplaceIcon(index,ico);
    deletefile2(path);

  except
    //SET DEFICON
    try
      imagelist7.geticon(0,ico);
      imagelist7.ReplaceIcon(index,ico);
    except
    end;
  end;

end;

//try to save new url
try
  if createorloadurllist=true then //acumul use to save strings before bars too
    if (baseurl<>'about:blank') then
      for x:=1 to GetTokenCount(baseurl,'/') do begin

        aux:=gettoken(baseurl,'/',x);

        if acumul<>'' then
          acumul:=acumul+'/'+aux
        else
          acumul:=aux;

        if (acumul[Length(acumul)]='/') AND (acumul[Length(acumul)-1]=':') OR (aux='http:') then
          aux:='';

        if aux<>'' then begin

          try
            Datamodule1.Thistory.Append;
            setwiderecord(Datamodule1.Thistory.FieldByName('Url'),acumul);
            Datamodule1.Thistory.Post;
          except
            Datamodule1.Thistory.Cancel;
          end;

          try
            Datamodule1.Thistory.Append;
            setwiderecord(Datamodule1.Thistory.FieldByName('Url'),gettoken(acumul,'//',2));
            Datamodule1.Thistory.Post;
          except
            Datamodule1.Thistory.Cancel;
          end;

          try
            Datamodule1.Thistory.Append;
            setwiderecord(Datamodule1.Thistory.FieldByName('Url'),gettoken(acumul,'//www.',2));
            Datamodule1.Thistory.Post;
          except
            Datamodule1.Thistory.Cancel;
          end;
        end;

      end;
except
end;


deletefile(path);

ico.Free;

pagecontrol3.Repaint;
end;

procedure TFmain.wb_NavigateError(ASender: TObject;
  const pDisp: IDispatch; var URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
var
index:integer;
ico:Ticon;
begin
if statuscode>=0 then//PUT ERROR ICON SEEMS PAGE NOT FOUND GETS NEGATIVE INTEGER
  exit;

if url<>(Asender as TEmbeddedWB).LocationURL then
  exit;

ico:=Ticon.Create;
index:=(FindComponent('T'+TWinControl(asender).name) as TTabSheetEx).tag;

imagelist7.GetIcon(0,ico);
imagelist7.ReplaceIcon(index,ico);

ico.free;

wb_defaultpage((Asender as TEmbeddedWB),false);

wb_updatecontrols(Asender as TEmbeddedWB);
wb_updateurlbar(Asender as TEmbeddedWB);

cancel:=true;//NON DEFAULT IE ERROR
end;

procedure fixdatetimeformat; //0.037
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ); //KEY_READ NO PROBLEM ACCESS INFO WITH UAC 0.027
  with Reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('Control Panel\International', False);

    if ValueExists('sShortDate') then
      shortdateformat := ReadString('sShortDate');
    if ValueExists('sTimeFormat') then
      LongTimeFormat := ReadString('sTimeFormat');
    if ValueExists('sDate') then
      DateSeparator:= ReadString('sDate')[1];
    if ValueExists('sTime') then
      TimeSeparator:= ReadString('sTime')[1];

    CloseKey;
    Free;
  end;
end;


function IE_installed(var Version: string): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ); //KEY_READ NO PROBLEM ACCESS INFO WITH UAC 0.027
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft\Internet Explorer', False);
    if ValueExists('Version') then
      Version := ReadString('Version')
    else
      Version := '';
    CloseKey;
    Free;
  end;
  Result := Version <> '';
end;

procedure Tfmain.wb_navigate(url:widestring;newtab:boolean;ownforzed:boolean);
var
wb:TEmbeddedWB;
tab:TTabSheetex;
i:integer;
pan:TTntpanel;
pg:Tprogressbar;
ico:Ticon;
begin
url:=trim(url);

if Wideuppercase(url)='ABOUT:BLANK' then
  exit;

ico:=Ticon.Create;


if ((PageControl1.Pages[3].TabVisible=true) AND (useownwb=true)) OR ((ownforzed=true) AND (PageControl1.Pages[3].TabVisible=true)) then begin


  if (newtab=true) then
    if url<>'' then
      if (Wideuppercase(wb_current.LocationURL)='ABOUT:BLANK') AND (wb_current.ReadyState>=READYSTATE_INTERACTIVE) then
        newtab:=false;

  if newtab=true then begin

    i:=0;

    LockWindowUpdate(handle);

    while Ttabsheet(FindComponent('TWB_'+inttostr(i)))<>nil do
      i:=i+1;

    tab:=TTabSheetEx.Create(self);
    tab.PageControl:=pagecontrol3;
    tab.Name:='TWB_'+inttostr(i);
    tab.Caption:='';

    pg:=TProgressBar.Create(panel78);
    pg.Align:=alclient;
    pg.Name:='PWB_'+inttostr(i);
    pg.Parent:=panel78;

    pan:=TTntpanel.Create(panel77);
    pan.Align:=alclient;
    pan.Name:='XWB_'+inttostr(i);
    pan.Parent:=panel77;
    pan.BevelInner:=bvNone;
    pan.BevelOuter:=bvnone;
    pan.Caption:=traduction(454);

    wb:=TEmbeddedWB.Create(panel74);
    wb.SetCharartersSet('_autodetect_all'); //utf-8???
    wb.Align:=alclient;
    wb.Constraints.MinHeight:=70;

    wb.UserAgentMode:=uaRegistry;

    //PROXY CONFIG
    //wb.ProxySettings.Port;
    //wb.ProxySettings.Password;
    //wb.ProxySettings.Adress;

    wb.Silent:=true;
    //wb.DialogBoxes.DisableAll:=false;//0.043
    wb.DisableErrors.ScriptErrorsSuppressed:=true;//0.043

    wb.ParentShowHint:=false;
    wb.AddressBar:=false;
    wb.StatusBar:=false;
    wb.RegisterAsBrowser:=true;
    wb.DisableCtrlShortcuts:='FNOLP+-';
    wb.DisableNavSound(true);
    wb.DisableErrors.fpExceptions:=false;
    wb.UserInterfaceOptions:=wb.UserInterfaceOptions+[EnableThemes]+[EnablesFormsAutoComplete];
    //wb.DoubleBuffered:=true;
    wb.VisualEffects.TextSize:=50;
    wb.Wait(Fmain.Edit4.Tag);
    wb.WaitWhileBusy(Fmain.Edit4.Tag);

    wb.Name:='WB_'+inttostr(i);
    wb.Parent:=panel74;

    imagelist7.geticon(0,ico);

    imagelist7.addicon(ico);

    tab.EWB:=wb;
    tab.CanBack:=false;
    tab.CanForward:=false;
    tab.ImageIndex:=imagelist7.Count-1;
    tab.Tag:=imagelist7.Count-1;

    pagecontrol3.ActivePage:=tab;
    tab.Caption:=traduction(454);
    
    if url='' then begin
      wb_defaultpage(wb,true);

      try
        stablishfocus(combobox3);
      except
      end;
    end;

    wb.OnTitleChange:=wb_TitleChange;
    wb.OnCommandStateChange:=wb_CommandStateChange;
    wb.OnProgressChange:=EmbeddedWB1ProgressChange;
    wb.OnNavigateError:=wb_NavigateError;
    wb.OnShowContextMenu:=EmbeddedWB1ShowContextMenu;
    wb.OnWindowClosing:=EmbeddedWB1WindowClosing;
    wb.OnNewWindow2:=EmbeddedWB1NewWindow2;
    wb.OnNewWindow3:=EmbeddedWB1NewWindow3;
    wb.OnStatusTextChange:=EmbeddedWB1StatusTextChange;
    wb.OnZoomPercentChange:=EmbeddedWB1ZoomPercentChange;
    //wb.OnFileDownload:=EmbeddedWB1FileDownload;


    panel72.Caption:=inttostr(PageControl3.PageCount);
    combobox3.Text:='';
    combobox3.Color:=clwindow;

    fixcomponentsbugs(Fmain);

    wb.Zoom:=2;//NORMAL FONT SIZE AS DEFAULT

    LockWindowUpdate(0);
  end;


  if trim(url)<>'' then begin

    if startupdate=false then begin
      PageControl1.ActivePageIndex:=3;
      wb_current.Repaint;
    end;

    combobox3.Text:=url;
    combobox3.Color:=clwindow;
    try
      wb_current.Navigate(url);
    except
    end;

    wb_current.Tag:=1;
  end;

  wb_updatecontrols(wb_current);

  wb_hidenotcurrent;

  //wb_updateurlbar(wb_current);

end
else
 ShellExecutew(self.WindowHandle,'open',pwidechar(url),nil,nil, SW_SHOWNORMAL);

ico.free;

freemousebuffer;
freekeyboardbuffer;
end;

procedure Tfmain.wb_search(wb:TEmbeddedWB;text:widestring;down:boolean);
var
doc: IHTMLDocument2;
selection: IHTMLSelectionObject;
textRange: IHtmlTxtRange;
direction:shortint;
begin
try

  Doc := wb.Document as IHTMLDocument2;
  Selection := Doc.Selection;

  TextRange :=selection.createRange as IHTMLTxtRange;

  if down=true then begin
    TextRange.collapse(false);
    direction:=0;
  end
  else begin
    TextRange.collapse(true);
    direction:=1;
  end;
               
  if TextRange.findText(text,1,direction) then begin
    TextRange.select;
    TextRange.scrollIntoView(TRUE);
    wb_updatecontrols(wb);
  end
  else
    (panel77.FindComponent('X'+wb.name) as TTntpanel).caption:=traduction(257);

except
  try
    (panel77.FindComponent('X'+wb.name) as TTntpanel).caption:=traduction(257);
  except
  end;
end;

freekeyboardbuffer;
freemousebuffer;
end;

procedure Tfmain.deleteallwebtabs;
var
x:integer;
begin
LockWindowUpdate(Handle);

for x:=PageControl3.PageCount-1 downto 0 do
  try
    deletecurrentwebtab;
  except
  end;

LockWindowUpdate(0);

PageControl3Change(PageControl3);//FORCE UPDATE

pagecontrol3.Repaint;
end;

procedure Tfmain.deletecurrentwebtab;
var
islast:boolean;
aux:ansistring;
wb:TEmbeddedWB;
iconpos,x,newpos:integer;
IP: IPersistStreamInit;
begin
islast:=false;
wb:=wb_current;

iconpos:=((Pagecontrol3.ActivePage) as TTabSheetEx).Tag;

if pagecontrol3.ActivePageIndex=pagecontrol3.PageCount-1 then
  islast:=true;

aux:=wb.Name;

wb.Visible:=false;


try
  wb.Hide;
  //wb.Stop;
except
end;


{try
wb.OnTitleChange:=nil;
wb.OnCommandStateChange:=nil;
wb.OnProgressChange:=nil;
wb.OnBeforeNavigate2:=nil;
wb.OnNavigateError:=nil;
wb.OnShowContextMenu:=nil;
wb.OnWindowClosing:=nil;
wb.OnNewWindow2:=nil;
wb.OnNewWindow3:=nil;
wb.OnStatusTextChange:=nil;
except
end;   }

try
//  wb.Navigate('about:blank');
except
end;

try //SEEMS FIXES MEMORY LEAKS AT DESTROY
  if Assigned(wb.document) and (wb.Document.QueryInterface(IPersistStreamInit, IP) = S_OK) then
    IP.InitNew;
except
end;

try //SEEMS FIXES MEMORY LEAKS AT DESTROY
  Freeandnil(wb);
  //wb.Destroy;
except
end;

try
if (panel77.FindComponent('X'+aux) as TTntpanel)<>nil then
  (panel77.FindComponent('X'+aux) as TTntpanel).Free;
except
end;

try
if (panel78.FindComponent('P'+aux) as Tprogressbar)<>nil then
  (panel78.FindComponent('P'+aux) as Tprogressbar).Free;
except
end;

try
  pagecontrol3.ActivePage.Free;
except
end;

try
if islast=true then
  pagecontrol3.ActivePageIndex:=pagecontrol3.PageCount-1;
except
end;

PageControl3Change(PageControl3);//FORCE UPDATE

imagelist7.Delete(iconpos);

for x:=pagecontrol3.PageCount-1 downto 0  do
  if ((pagecontrol3.Pages[x]) as TTabSheetEx).Tag>iconpos then begin
    newpos:=((pagecontrol3.Pages[x]) as TTabSheetEx).Tag-1;
    ((pagecontrol3.Pages[x]) as TTabSheetEx).ImageIndex:=newpos;
    ((pagecontrol3.Pages[x]) as TTabSheetEx).tag:=newpos;
  end;

if pagecontrol3.PageCount=0 then
  wb_navigate('',true,true);

panel72.Caption:=inttostr(PageControl3.PageCount);

freemousebuffer;
freekeyboardbuffer;
end;

//-COMPONENTS CODE-------------------------------------------

procedure TFmain.Addsection1Click(Sender: TObject);
var
n,n2:TTnttreenode;
path,new:widestring;
retry:boolean;
msgnum:integer;
begin
path:='';
msgnum:=0;
retry:=true;
n:=treeview1.Selected;

//Default nodes ignore
if (n.Level=0) AND (n=treeview1.Items.Item[0]) OR (n=treeview1.Items.Item[1]) then
  n:=nil
else
  Gettreepath(n,path);

//Check dupe nodes
while retry=true do begin

  Application.CreateForm(TFnewfolder, Fnewfolder);

  Fnewfolder.Edit1.MaxLength:=255-length(path);
  Fnewfolder.Caption:=traduction(31);
  Fnewfolder.Label1.Caption:=traduction(68);

  if msgnum<>0 then
  case msgnum of
    1:Fnewfolder.Label2.Caption:=traduction(69);
    2:Fnewfolder.Label2.Caption:=traduction(70);
  end;
  msgnum:=0;

  myshowform(Fnewfolder,true);

  if Fnewfolder.Tag=0 then begin
    FreeAndNil(Fnewfolder);
    break;
  end;

  new:=Fnewfolder.Edit1.Text;
  new:=removeconflictchars(new,false);
  new:=Trim(new);
  FreeAndNil(Fnewfolder);

  if new='' then
    msgnum:=1
  else
  if nodepathexists(treeview1,path+new)=nil then begin

    treeview1.Items.BeginUpdate;

    n2:=treeview1.Items.AddChild(n,new);
    n2.ImageIndex:=30;
    n2.SelectedIndex:=31;

    try
      n.Expand(false);
    except
    end;

    TreeView1.AlphaSort(true);
    TreeView1.AlphaSort(false);

    treeview1.items.EndUpdate;
    //UPDATE DB
    path:='';
    Gettreepath(n2,path);

    DataModule1.TTree.Append;
    setwiderecord(DataModule1.TTree.FieldByName('Path'),path);
    DataModule1.TTree.Post;

    retry:=false;
  end
  else
    msgnum:=2;
end;

end;

procedure TFmain.TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var node: Ttnttreenode;
begin
//BUGFIX Rightclick no treeview
node := TreeView1.GetNodeAt(MousePos.X, MousePos.Y); // Tries to get node
if (node <> nil) then TreeView1.Selected := (node as TTnttreenode); // Pass selection to tree
end;

procedure TFmain.Expandall1Click(Sender: TObject);
begin
TreeView1.FullExpand;
end;

procedure TFmain.Collapseall1Click(Sender: TObject);
var
node:TTnttreenode;
begin
//BUGFIX
treeview1.Tag:=1;
node:=treeview1.Selected;

if node.Level>0 then
  node.Selected:=false;

Treeview1.FullCollapse;

if node.Level>0 then begin

  while node.Level<>0 do
    node:=findfathernode(node);

  treeview1.Tag:=0;
  treeview1.Selected:=(node as TTnttreenode);
end;

treeview1.Tag:=0;
end;

procedure TFmain.FormCreate(Sender: TObject);
var
strm:TResourceStream;
res:ansistring;
x:integer;
Mode: DWORD;
begin
isfiledialog:=false;
isserverdialog:=false;
askforclose:=true;
AlphaBlendValue:=0;
AlphaBlend:=true;
lastmainpageindex:=0;
ingridlines:=false;
OleInitialize(nil); //BUGFIX for XP SP2-3 Opendialog crash when hint files
DisableProcessWindowsGhosting; //BUG MODAL WINDOWS FIX SINCE WIN2000/XP  //BUG MAKER ???
Saved8087CW := Default8087CW;
//Disabled = $133F
//Enabled = $1372
Set8087CW($133F); // Disable fpu exceptions for webbrowser floating operation error fix

Mode := SetErrorMode(SEM_FAILCRITICALERRORS);
SetErrorMode(Mode or SEM_FAILCRITICALERRORS); // Disable no disk in drive exception
Fmain.AlphaBlendValue:=0;//Prepare for not visible onclose
HintWindowClass := TMyHintWindow; //GENERATE HINT STYLES
CurrentEurekaLogOptions.AutoCrashOperation:=tbnone; //DONT RESTART AFTER 10 EXCEPTIONS
XPMenu1.Font.Name:=defaultfontname;
CoolTrayIcon1.IconIndex:=34;
oldlogtop:=-1;
oldlogLeft:=-1;
oldserverleft:=-1;
oldservertop:=-1;

try //DEFAULT USER AGENT
  UrlMkSetSessionOption(URLMON_OPTION_USERAGENT, PChar(defuseragent), Length(defuseragent), 0);
except
end;

label8.caption:='v '+appversion;

application.OnModalBegin:=modalbegin;

sterrors:=TTntStringList.Create;//List of errors for dialogs
stcompfiles:=TTntStringList.Create;//List of rar/7z content when open it
stcompfiles.Sorted:=true;//0.028 NEW FIND METHOD
//stcompfiles.Duplicates:=dupIgnore;
stcompcrcs:=Tstringlist.Create;
stcompsizes:=Tstringlist.Create;
stcompfiles2:=TTntStringList.create;
stcompfiles2.Sorted:=true;//0.028 NEW FIND METHOD

stcompcrcs2:=Tstringlist.Create;
stcompsizes2:=Tstringlist.create;
datgroups:=Tstringlist.Create;
activeformlist:=Tstringlist.Create;
stsets:=TTntStringList.Create;
stsofts:=Ttntstringlist.create;
stroms:=Ttntstringlist.Create;
stsimplehash:=Ttntstringlist.Create;
stsimplehash.Sorted:=true;//SPEEDUP 0.029
stsimplehash.Duplicates:=dupIgnore;//0.030
stsimplehash.CaseSensitive:=false;//0.030
stsimplehashreb:=Ttntstringlist.Create;
stsimplehashreb.Sorted:=true;//SPEEDUP 0.043
stsimplehashreb.Duplicates:=dupIgnore;//0.043
stsimplehashreb.CaseSensitive:=false;//0.043
recsets:=Tlist.Create;
recroms:=Tlist.Create;
reccrcs:=Tlist.create;
recmd5s:=Tlist.create;
recsha1s:=Tlist.create;
stids:=Tstringlist.create;
stids.Sorted:=true;
stids.Duplicates:=dupIgnore;//IGNORE DUPLICATES FOR REBUILD METHOD
batchlist:=TStringList.Create;
dialoglist:=TTntStringList.Create;

stsets.Sorted:=true; //IF NO SORTED NO DUP FOUND
stroms.Sorted:=true; //IF NO SORTED NO DUP FOUND
stsets.Duplicates:=dupIgnore;
stroms.Duplicates:=dupIgnore;
stsets.CaseSensitive:=false;
stroms.CaseSensitive:=false;
stsofts.Sorted:=true;
stsofts.Duplicates:=dupError;
stsofts.CaseSensitive:=false;
//datgroups.Sorted:=true;//SPEED UP LOCATE
//datgroups.Duplicates:=dupIgnore;
//datgroups.CaseSensitive:=false;

writelist:=TStringList.Create;
Threadstodestroy:=Tstringlist.create;

png:=TPNGObject.Create;
png2:=TPNGObject.Create;
pngstream:=TTntMemoryStream.Create;
bmp:=Tbitmap.Create;

opt1:=True;
opt2:=True;
opt3:=True;
Foldname:=True;
Recdir:=False;
iswin64:=false;
useownwb:=true;
startupdate:=false;
solidcomp:=true;
multicpu:=true;
onathread:=false;
defmd5:=false;
defsha1:=false;
deftz:=false;
deft7z:=false;
userar5:=false;
colorcolumns:=true;

//ASKMOD
fix0:='0';
fix1:='0';
fix2:='0';
fix3:='0';
fix4:='0';
fix5:='0';
fix6:='0';
fix7:='0';

upspeed:=0;
downspeed:=0;

upslots:=1;
downslots:=1;

firewall:=false;
agressive:=false;

connectionport:=defserverport;

try
  iswin64:=IAmIn64Bits;
except
end;

//GENERATOR CHECKBOXES FOR THEMED AND NOT
loadthemedcheckboxes;

//CONSTRUCTOR INITIALIZATION
VirtualStringTree4.OnClick:=lvclick;

//SET ALL INITIALDIRS
initialdirimportdat:=checkpathbar(GetDesktopFolder);
initialdirimportmameexe:=initialdirimportdat;
initaldiropendatabase:=initialdirimportdat;
initialdirsavedb:=initialdirimportdat;
initialdirrebuild:=initialdirimportdat;
initialdirexport:=initialdirimportdat;
initialdiremulator:=initialdirimportdat;
initialdirroms:=initialdirimportdat;
initialdirimages:=initialdirimportdat;
initialdirlog:=initialdirimportdat;
initialdirffix:=initialdirimportdat;
initialdirhash:=initialdirimportdat;
initialdirxmlexport:=initialdirimportdat;
initialdirextract:=initialdirimportdat;
initialdirxmlcreation:=initialdirimportdat;
initialdirsharefile:=initialdirimportdat;
initialdirfoldcreator:='';

stdropfolders:=TTntStringList.create;//Dropped folders list

zip1.OpenCorruptedArchives:=false;
zip2.OpenCorruptedArchives:=false;

//EXTRACTION RESOURCE RAR DLL - ZIP UNZIP DLL NOT NEEDED TO READ - 7Z DYNAMIC LOADED
try //BUG DUPE INSTANCES QUICK
  res:=checkpathbar(tempdirectoryresources)+'unrar.dll';
  strm:=TResourceStream.Create( hInstance,'#'+'10',RT_RCDATA );
  try
    strm.Seek(0,soFromBeginning);
    strm.SaveToFile(res);
  finally
    strm.free;
  end;
  rar1.DllName:=res;
  rar2.DllName:=res;

  rar1.LoadDLL;
  rar2.LoadDLL;
  //NOW DLL CAN BE DELETED
  deletefile2(res);
except
  halt;
end;

for x:=0 to updatercount-1 do begin //GET ALL IDs AND SET TO TRUE
  if updaterdescription(x,false)<>'' then
    datgroups.Add(updaterdescription(x,false)+'|1');
end;

fixcomponentsbugs(Fmain);//Prevent black panels on xp vista 7

//0.035 initialize columns colors
VirtualStringTree2.Header.Columns[0].Color:=clBtnFace;
VirtualStringTree1.Header.Columns[0].Color:=clBtnFace;
VirtualStringTree3.Header.Columns[0].Color:=clBtnFace;
VirtualStringTree4.Header.Columns[0].Color:=clBtnFace;

VirtualStringTree2.Header.SortColumn:=0;
VirtualStringTree1.Header.SortColumn:=0;
VirtualStringTree3.Header.SortColumn:=0;
VirtualStringTree4.Header.SortColumn:=-1;//NO CLICKEABLE COLUMN NO ARROW

PageControl1.ActivePageIndex:=0;//Go to first page
PageControl2.Pages[0].TabVisible:=false;
pagecontrol2.Visible:=false;

defofffilename:=defaultofffilename;
sterrors.Clear;
sterrors.Add('');
maxloglines:=500;
combobox1.ItemIndex:=0;
deffilemode:=1;
lang:=-1;

ExplorerDrop1.DestinationControl:=VirtualStringTree2;
ExplorerDrop4.DestinationControl:=VirtualStringTree4;

loadconfig;

if colorcolumns=false then begin
  VirtualStringTree2.Header.Columns[0].Color:=clWindow;
  VirtualStringTree1.Header.Columns[0].Color:=clWindow;
  VirtualStringTree3.Header.Columns[0].Color:=clWindow;
  VirtualStringTree4.Header.Columns[0].Color:=clWindow;
end;

setlangchanged;

checksleep;

//SECURITY
checkusername;
connectionport:=checkvalidinternetport(connectionport,10001);
try
  WideForceDirectories(tempdirectoryextractvar)
except
end;
if Not WideDirectoryExists(tempdirectoryextractvar) then
  tempdirectoryextractvar:=tempdirectoryextract;

communitydownfolder:=trim(communitydownfolder);
if communitydownfolder='' then
  communitydownfolder:=defcommunitydownfolder;

defbackuppath:=trim(defbackuppath);
if defbackuppath='' then
  defbackuppath:=tempdirectoryresources[1]+':\backup\';

if (upslots>10) OR (upslots<=0) then
  upslots:=1;

if (downslots>10) OR (downslots<=0) then
  downslots:=1;

if (downspeed<0) OR (downspeed>99999) then
  downspeed:=0;

if (upspeed<0) OR (upspeed>99999) then
  upspeed:=0;

if (defromscomp<0) OR (defromscomp>39) then
  defromscomp:=19;
if (defsamplescomp<0) OR (defsamplescomp>39) then
  defsamplescomp:=19;
if (defchdscomp<0) OR (defchdscomp>39) then
  defchdscomp:=0;

//SECURITY FORM POSITION
if (Fmain.Top<DesktopSize.Top) OR (Fmain.top>=DesktopSize.Bottom-GetSystemMetrics(SM_CYCAPTION)) then
  Fmain.top:=DesktopSize.Top;
if (Fmain.left<DesktopSize.left) OR (Fmain.left>=DesktopSize.Right-GetSystemMetrics(SM_CYCAPTION)) then
  Fmain.Left:=DesktopSize.left;

defbackuppath:=checkpathbar(defbackuppath);
defofffilename:=checkofflinelistfilenameiffailsreturndefault(defofffilename);

if (maxloglines<100) OR (maxloglines>9999) then
  maxloglines:=500;

if (deffilemode<0) OR (deffilemode>2) then
  deffilemode:=1;

if (Edit4.Tag>99000) OR (edit4.tag<0) then
  edit4.tag:=5000;//SET DEFAULT

//--------------------------------------------------

checkconstructorstatus;

traductfmain;
showcurrentscantab(false,false,'');
showprofilesselected;
showconstructorselected;

decision:=2;
if WideDirectoryExists(tempdirectoryresources) then
  Scandirectory(tempdirectoryresources,'*.rmt',1,false);

ChDir(tempdirectoryresources);//Fix no removable folder
setdefaultbitmap;

setgridlines(VirtualStringTree4,ingridlines);

//WB
try
  if (IE_installed(res)=true) AND (isWineOS=false) then begin
    if createorloadurllist=false then
      makeexception;
    wb_navigate('',true,true);
    panel76.caption:=res;
  end
  else
    makeexception;

except
  PageControl1.Pages[3].TabVisible:=false;
end;

createorloadserverslist;

setstaystatuslabel;

AlphaBlend:=false;
Fmain.Enabled:=true;

try
  fixdatetimeformat;
except
end;


end;

procedure TFmain.Selectall1Click(Sender: TObject);
begin
VirtualStringTree2.SelectAll(true);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.Editsection1Click(Sender: TObject);
var
n:TTnttreenode;
path,new:widestring;
msgnum,max:integer;
retry:boolean;
edited:boolean;
begin
path:='';
msgnum:=0;
edited:=false;

retry:=true;
n:=treeview1.Selected;
Gettreepath(n,path);

while retry=true do begin
  Application.CreateForm(TFnewfolder, Fnewfolder);
  Fnewfolder.Caption:=traduction(32);
  Fnewfolder.Label1.Caption:=traduction(91);

  max:=0;

  DataModule1.Qaux.Close;
  DataModule1.Qaux.SQL.Clear;

  Datamodule1.Qaux.Params.Clear;
  Datamodule1.Qaux.Params.CreateParam(ftWideString,'p_',ptResult);

  Datamodule1.Qaux.Params[0].DataType := ftWideString;
  Datamodule1.Qaux.Params[0].Value:=path+'%';

  DataModule1.Qaux.SQL.Add('SELECT * FROM Tree WHERE Upper(Path) LIKE Upper('+':p_'+')');
  DataModule1.Qaux.Open;
  DataModule1.Qaux.first;

  while not DataModule1.Qaux.Eof do begin
    if length(getwiderecord(DataModule1.Qaux.fieldbyname('path')))>max then
      max:=length(getwiderecord(DataModule1.Qaux.fieldbyname('path')));
    DataModule1.Qaux.next;
  end;

  Fnewfolder.Edit1.MaxLength:=255-max+length(n.Text)+1;
  Fnewfolder.edit1.Text:=n.Text;

  if msgnum<>0 then
    case msgnum of
      1:Fnewfolder.Label2.Caption:=traduction(69);
      2:Fnewfolder.Label2.Caption:=traduction(70);
    end;

  msgnum:=0;
  myshowform(Fnewfolder,true);

  if Fnewfolder.Tag=0 then begin
    Freeandnil(Fnewfolder);
    break;
  end;

  new:=Fnewfolder.Edit1.Text;
  new:=removeconflictchars(new,false);
  new:=Trim(new);

  if GetTokenCount(path,'\')<=2 then
    path:=''
  else begin
    path:=path+' ';
    path:=changein(path,n.Text+'\ ','');//Cut las folder to compare if exists new
  end;

  if new='' then begin
    msgnum:=1;
  end
  else
  if nodepathexists(treeview1,path+new)=nil then begin
    editnode(n,new);
    treeview1.Items.BeginUpdate;
    n.Text:=new;
    treeview1.AlphaSort(true);
    treeview1.AlphaSort(false);
    treeview1.Items.EndUpdate;
    retry:=false;
    //edited:=true;
  end
  else
    if WideUpperCase(new)<>wideuppercase(n.Text) then begin//Edit and add the same
      msgnum:=2;
    end
    else begin //CASE EDIT
      editnode(n,new);
      treeview1.Items.BeginUpdate;
      n.Text:=new;
      treeview1.AlphaSort(true);
      treeview1.AlphaSort(false);
      treeview1.Items.EndUpdate;
      retry:=false;
      edited:=true;
    end;

  FreeAndNil(Fnewfolder);
end;

if edited=true then
  showprofiles(true);

end;

procedure TFmain.SpeedButton2Click(Sender: TObject);
var
x:integer;
begin
savefocussedcontrol;

autodecision:=-1;
autodecisioncheck:=true;
OpenDialog1.title:=speedbutton2.Hint;
Opendialog1.Filter:=traduction(107)+' (*.dat;*.xml;*.hsi;*.zip;*.rar;*.7z)|*.dat;*.xml;*.hsi;*.zip;*.rar;*.7z';
opendialog1.Options:=opendialog1.Options+[ofAllowMultiSelect];
sterrors.Clear;//Initialize
imported:=0;//Initialize
opendialog1.FileName:='';
opendialog1.InitialDir:=folderdialoginitialdircheck(initialdirimportdat);

positiondialogstart;

if OpenDialog1.Execute then begin
  initialdirimportdat:=wideextractfilepath(opendialog1.FileName);
  if opendialog1.Files.Count>1 then
    showprocessingwindow(true,false) //CAN CANCEL IMPLEMENTED
  else
    showprocessingwindow(false,false);

  Fprocessing.panel3.Caption:=traduction(61)+' : ';
  Fprocessing.panel3.Caption:=Fprocessing.panel3.Caption+traduction(71);
  Fprocessing.repaint;

  for x:=0 to OpenDialog1.Files.Count-1 do begin
    if Fprocessing.Tag=1 then
      break;
    processnewdat(OpenDialog1.Files[x]);
  end;

  hideprocessingwindow;

  if imported<>0 then
    showprofiles(true);

  processnewdatshowresults;
end;

sterrors.clear;
imported:=0;

restorefocussedcontrol;
end;

procedure TFmain.Invertselection1Click(Sender: TObject);
begin
VirtualStringTree2.InvertSelection(false);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.Deletesection1Click(Sender: TObject);
begin
savefocussedcontrol;

if mymessagequestion(traduction(72)+' "'+TreeView1.Selected.Text+'" '+traduction(73),false)=1 then begin
  showprocessingwindow(true,false);// CAN CANCEL IMPLEMENTED
  Fprocessing.panel3.Caption:=traduction(61)+' : ';
  Fprocessing.panel3.Caption:=Fprocessing.panel3.Caption+traduction(63);
  Fprocessing.repaint;
  treeview1.Tag:=1; //Unable to automatic search in prev node
  deletenode(Treeview1.Selected);
  hideprocessingwindow;
  treeview1.Tag:=0;

  showprofiles(true);

  restorefocussedcontrol;
end;

end;

procedure TFmain.Normal1Click(Sender: TObject);
begin
normal1.Checked:=true;
priority(1);
end;

procedure TFmain.ExplorerDrop1Dropped(Sender: TObject; Files: TTntstrings;
  FileCount, x, y: Integer);
var
z:integer;
pass:boolean;
begin
pass:=true;
autodecision:=-1;
autodecisioncheck:=true;

if (Files.Count=0) AND (stdropfolders.Count=0) then
  pass:=false;

if (PageControl1.ActivePageIndex<>0) OR (GetFormsCount<>2) then  //SECURITY
  pass:=false;

if pass=true then begin
  Fmain.Show;//FIX FOCUS FOR FSERVER
  if mymessagequestion(traduction(105),false)<>1 then begin
    stcompfiles.Clear;
    pass:=false;;
  end;
end;

if pass=true then begin
  sterrors.Clear;
  imported:=0;
  decision:=0;
  showprocessingwindow(true,false); //CAN CANCEL IMPLEMENTED
  Fprocessing.panel3.Caption:=traduction(61)+' : ';
  Fprocessing.panel3.Caption:=Fprocessing.panel3.Caption+traduction(64);
  Fprocessing.repaint;
  decision:=0;

  for z:=0 to stdropfolders.count-1 do
    if WideDirectoryexists(stdropfolders.Strings[z]) then
      Scandirectory(stdropfolders.Strings[z],'*.*',0,true);

  ChDir(tempdirectoryresources);//Fix no removable folder
  stdropfolders.Clear;

  for z:=0 to filecount-1 do begin
    if Fprocessing.Tag=1 then
      break;

    if FileExists2(files[z]) then
      processnewdat(files[z]);

  end;


  hideprocessingwindow;

  if imported<>0 then
    showprofiles(true);

  processnewdatshowresults;

end;

ExplorerDrop1.FileNames.Clear;
stdropfolders.Clear;

imported:=0;
end;

procedure TFmain.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
nodedest:TTnttreenode;
path,path2,aux:widestring;
maxdest,maxorg:integer;
pass:boolean;
id,z:integer;
n:PVirtualNode;
begin
pass:=true;
path:='';
path2:='';
id:=0;
nodedest := TreeView1.GetNodeAt(X,Y);
gettreepath(nodedest,path);
path:=copy(path,1,length(path)-1);//Remove the last /


gettreepath(Treeview1.Selected,path2);
path2:=copy(path2,1,length(path2)-1);//Remove the last /

if source=VirtualStringTree2 then begin

  aux:=traduction(74)+' "';
  if path='' then
    aux:=aux+treeview1.Items.Item[1].Text
  else
    aux:=aux+nodedest.text;

  aux:=aux+'" ?';

  if mymessagequestion(aux,false)=1 then begin

    if path<>'' then
      if Datamodule1.TTree.Locate('Path',path+'\',[loCaseInsensitive])=true then
        id:=Datamodule1.TTree.fieldbyname('ID').asinteger;

    n:=VirtualStringTree2.GetFirst;
    for z:=0 to VirtualStringTree2.RootNodeCount-1 do begin
      if VirtualStringTree2.Selected[n]=true then begin

        DataModule1.Tprofilesview.locate('CONT',z+1,[]);

        Datamodule1.Tprofiles.Locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').asinteger,[]);
        Datamodule1.Tprofiles.Edit;
        Datamodule1.Tprofiles.fieldbyname('Tree').asinteger:=id;
        Datamodule1.Tprofiles.post;

        Datamodule1.TTree.Locate('ID',id,[]);

        //0.030 Tprofilesview update too
        Datamodule1.Tprofilesview.Edit;
        setwiderecord(Datamodule1.Tprofilesview.fieldbyname('Path'),getwiderecord(Datamodule1.TTree.fieldbyname('Path')));
        Datamodule1.Tprofilesview.Post;

      end;
    n:=VirtualStringTree2.GetNext(n);
    end;

    if treeview1.selected<>treeview1.Items.Item[0] then //If is different to ALL then reshow
      showprofiles(true)
    else
      VirtualStringTree2.repaint; //0.030
  end
end
else
if source=Treeview1 then begin

  aux:=traduction(75)+' "'+Treeview1.Selected.Text+'" '+traduction(76)+' "';
  if path='' then
    aux:=aux+traduction(77)
  else
    aux:=aux+nodedest.text;

  aux:=aux+'" ?';

  if mymessagequestion(aux,false)=1 then begin

    DataModule1.Qaux.Close;
    DataModule1.Qaux.SQL.Clear;
    DataModule1.Qaux.SQL.Add('SELECT * FROM Tree');
    DataModule1.Qaux.SQL.Add('WHERE UPPER(Path) LIKE UPPER('+''''+changein(path2,'''','''''')+'\%'+''''+')');
    DataModule1.Qaux.Open;
    DataModule1.Qaux.first;

    maxdest:=length(path)+1;
    maxorg:=length(gettoken(path2,'\',gettokencount(path2,'\')));

    while DataModule1.Qaux.Eof=false do begin
      aux:=DataModule1.Qaux.fieldbyname('path').asstring;
      if (Length(aux)-maxorg)+maxdest>255 then
        pass:=false;
      DataModule1.Qaux.next;
    end;

    if pass=true then begin

      TreeView1.Items.BeginUpdate;

      MoveNode(nodedest,Treeview1.Selected);

      TreeView1.AlphaSort(true);
      TreeView1.AlphaSort(false);

      //Delete all tree node
      Treeview1.Selected.Delete;
      Treeview1.Items.EndUpdate;
      nodedest.Expanded:=true;
    end
    else
      mymessageerror(traduction(92));

    DataModule1.Qaux.close;
  end;
end;

end;

procedure TFmain.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
node:Ttnttreenode;
b,aux:boolean;
begin
b:=false;
aux:=true;

//Allow to autoscroll when drag
if (y < 15) then begin
  SendMessage(TreeView1.Handle, WM_VSCROLL, SB_LINEUP, 0);
  treeview1.Repaint;
end
else
if (TreeView1.Height - y < 15) then begin
  SendMessage(TreeView1.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  treeview1.Repaint;
end;

try
  node := TreeView1.GetNodeAt(X,Y);
  if node<>nil then
    if source.ClassName='TVirtualStringTree' then begin
      if node<>treeview1.Items.Item[0] then
        if node<>treeview1.Selected then
          if (source as TVirtualStringTree).Name='VirtualStringTree2' then
            b:=true;
    end
    else
    if source.ClassName='TTntTreeView' then
      if (treeview1.Selected<>treeview1.Items.Item[0]) AND (treeview1.Selected<>treeview1.Items.Item[1]) then  //No move default directories
        //if (treeview1.selected.level=0) AND (node=treeview1.Items.Item[0]) OR (node=treeview1.Items.Item[1]) then //Can drop to default folders
          if node<>treeview1.Selected then
            if findfathernode(treeview1.Selected)<>node then begin

              while node<>nil do begin
                node:=findfathernode(node);
                if node=treeview1.Selected then
                  aux:=false;
              end;

              if aux=true then
                b:=true; //Check if selected is father of dropped

              node := TreeView1.GetNodeAt(X,Y); //Allow drop non level 0 node to make a root path of dropped folder
              if (treeview1.selected.level=0) then begin
                if (node=treeview1.Items.Item[0]) OR (node=treeview1.Items.Item[1]) then
                  b:=false;

              end;

            end;

except
end;

accept:=b;
end;

procedure TFmain.PopupMenu1Popup(Sender: TObject);
var
n:TTnttreenode;
b:boolean;
begin
b:=true;
n:=treeview1.Selected;

if (n.Level=0) AND (n=treeview1.Items.Item[0]) OR (n=treeview1.Items.Item[1]) then
  b:=false;

Editsection1.Enabled:=b;
Deletesection1.Enabled:=b;
end;

procedure TFmain.FormShow(Sender: TObject);
var
f:textfile;
cad,downl2:ansistring;
begin
Fmain.Caption:=Application.Title+' - '+appversion;

if testmode=true then
  Fmain.Caption:=Fmain.Caption+' - NO PUBLIC RELEASE';

//Check romulus update
if self.tag=1 then  //FIX SEMAPHORE RECOVERY
  exit;

if AlphaBlend=true then //FAIL LOADING THEN FINISH APP
  halt;

try
  if (searchromulsupdates=true) AND (IsConnectedtointernet) then begin

    showprocessingwindow(false,false); //CAN NOT BE IMPLEMENTED
    Fprocessing.panel2.Caption:=traduction(381);
    Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(364);

    Application.ProcessMessages;

    downl2:=tempdirectoryresources+'vers.rmt';
    deletefile2(downl2);

    downloadfile2(romulusurl+'version.rm',downl2,false);

    AssignFile(f,downl2);
    reset(f);
    readln(f,cad);
    closefile(f);
    deletefile2(downl2);


    try //0.0028 always must be version number a number
      if strtofloat(appversion)<strtofloat(cad) then
        if mymessagequestion(traduction(382)+#10#13+traduction(383)+' > '+appversion+#10#13+traduction(384)+' > '+cad,false)=1 then begin
          startupdate:=true;
          wb_navigate(romulusurl,false,false);
        end;

      sleep(500);
    except
    end;

  end;
except
end;

hideprocessingwindow;

try
  CloseFile(f);
except
end;

//Mymessages must be onshow else cant close mainwindow. BUG?
if self.tag=0 then begin
  self.Tag:=1;
  speedupdb;
  
  if Wideuppercase(WideExtractfilepath(Tntapplication.ExeName)+'default.rml')<>Wideuppercase(sterrors.strings[0]) then
    if not FileExists2(sterrors.strings[0]) then
      sterrors.strings[0]:=WideExtractfilepath(Tntapplication.ExeName)+'default.rml';

  createorloaddatabase(sterrors.strings[0],false);
  sterrors.clear;
end;


EnableWindow(handle,false);

BringWindowToTop(Fmain.handle);

if (startupdate=true) and (wb_current.tag=1) then
  pagecontrol1.ActivePageIndex:=3;//0.046 FORCE TAB TO UPDATE

timer1.Enabled:=true;
end;

procedure TFmain.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
showprofiles(true);
end;

procedure TFmain.ListView1Data(Sender: TObject; Item: TListItem);
var
typ:string;
haveroms,havesets,totalroms,totalsets:ansistring;
shareint:integer;
begin

try
  shareint:=0;

  Datamodule1.Tprofilesview.Locate('CONT',item.Index+1,[]);

  if Datamodule1.Tprofilesview.fields[19].asboolean=true then
    shareint:=4;

  //Type of dat
  typ:=Datamodule1.Tprofilesview.fields[17].asstring;
  item.imageindex:=getdattypeiconindexfromchar(typ);

  haveroms:=pointdelimiters(Datamodule1.Tprofilesview.fields[5].asinteger);//Havesets
  havesets:=pointdelimiters(Datamodule1.Tprofilesview.fields[4].asinteger);//Haveroms
  totalroms:=pointdelimiters(Datamodule1.Tprofilesview.fields[15].asinteger);
  totalsets:=pointdelimiters(Datamodule1.Tprofilesview.fields[14].asinteger);

  //Status icons
  if Datamodule1.Tprofilesview.fields[5].asstring='' then begin
    item.StateIndex:=3+shareint;
    haveroms:=' - ';
    havesets:=' - ';
  end
  else
  if Datamodule1.Tprofilesview.fields[5].asstring='0' then begin
    item.StateIndex:=2+shareint;
    haveroms:='0';
    havesets:='0';
  end
  else
  if haveroms=totalroms then
    item.StateIndex:=0+shareint//0
  else
    item.StateIndex:=1+shareint;

  (item as TTntListItem).Caption:=getwiderecord(Datamodule1.Tprofilesview.Fields[2]);//Description
  (item as TTntListItem).SubItems.Add(getwiderecord(Datamodule1.Tprofilesview.fields[6]));//Version

  item.SubItems.Add(havesets+' / '+totalsets);
  item.SubItems.Add(haveroms+' / '+totalroms);

  item.SubItems.Add(splitmergestring(Datamodule1.Tprofilesview.fields[7].AsInteger)); //Filemode

  if shareint=4 then
    item.SubItems.Add('X')
  else
    item.SubItems.Add('');

  item.SubItems.Add(Datamodule1.Tprofilesview.fields[16].asstring);//ADDED
  haveroms:=Datamodule1.Tprofilesview.fields[11].asstring;//LAST SCAN

  if Length(haveroms)<=12 then
    item.SubItems.Add('')
  else
    item.subitems.add(haveroms);

  (item as TTntListItem).SubItems.Add(getwiderecord(Datamodule1.Tprofilesview.fields[3]));//NAME
  (item as TTntListItem).SubItems.Add(getwiderecord(Datamodule1.Tprofilesview.fields[20]));//PATH

except
end;

showprofilesselected;
end;

procedure TFmain.Delete1Click(Sender: TObject);
var
x:integer;
aux,precache:widestring;
n:PVirtualNode;
begin
if VirtualStringTree2.SelectedCount=0 then
  exit;

savefocussedcontrol;

if mymessagequestion(traduction(78),false)=1 then begin

  if VirtualStringTree2.SelectedCount>1 then
    showprocessingwindow(true,false) //CAN CANCEL IMPLEMENTED
  else
    showprocessingwindow(false,false); //CAN CANCEL IMPLEMENTED

  Fprocessing.panel3.Caption:=traduction(61)+' : ';
  Fprocessing.panel3.Caption:=Fprocessing.panel3.Caption+traduction(63);
  Fprocessing.repaint;

  precache:=tempdirectorycache+getdbid+'-';
                    
  n:=VirtualStringTree2.GetFirst;
  for x:=0 to VirtualStringTree2.RootNodeCount-1 do begin

    if Fprocessing.Tag=1 then
      break;

    application.processmessages;

    if VirtualStringTree2.Selected[n]=true then begin

      DataModule1.Tprofilesview.locate('CONT',x+1,[]);

      Fprocessing.panel2.Caption:=changein(Datamodule1.Tprofilesview.Fieldbyname('Description').asstring,'&','&&');
      Fprocessing.panel2.Refresh;

      if Datamodule1.Tprofiles.Locate('ID',Datamodule1.Tprofilesview.fieldbyname('ID').AsInteger,[])=true then begin

        Datamodule1.Qaux.close;
        Datamodule1.Qaux.sql.Clear;
        aux:=fillwithzeroes(DataModule1.Tprofiles.fieldbyname('ID').asstring,4);

        deletefile2(precache+inttohex(strtoint64(aux),8));//0.029 DELETE CACHE FILE IF EXISTS

        Datamodule1.Qaux.SQL.Add('DROP TABLE Y'+aux+';');

        BMDThread1.Start();
        waitforfinishthread;

        application.processmessages;

        Datamodule1.Qaux.close;
        Datamodule1.Qaux.sql.Clear;

        Datamodule1.Qaux.SQL.Add('DROP TABLE Z'+aux+';');

        BMDThread1.Start();
        waitforfinishthread;

        application.processmessages; //OLLINFO

        Datamodule1.Qaux.close;
        Datamodule1.Qaux.sql.Clear;

        Datamodule1.Qaux.SQL.Add('DROP TABLE O'+aux+';');

        BMDThread1.Start();
        waitforfinishthread;

        //Delete alread exist tab to delete
        deletetab(aux);

        DataModule1.Tprofiles.Delete;

        While Datamodule1.TDirectories.Locate('Profile',strtoint(aux),[])=true do
          Datamodule1.TDirectories.Delete;//Already delete his Directories

        showprolesmasterdetail(false,false,getcurrentprofileid,true,true);//BUGFIX
      end;
    end;//Selected

    n:=VirtualStringTree2.GetNext(n);
  end;

  refreshallfaces; //0.044

  hideprocessingwindow;
  showprofiles(true);
  
  restorefocussedcontrol;
end;


end;

procedure TFmain.adddats1Click(Sender: TObject);
begin
SpeedButton2Click(sender);
end;

procedure TFmain.PopupMenu2Popup(Sender: TObject);
var
b:boolean;
p,p2,w:widestring;
begin
Fmain.destroycustomhint;
b:=true;
if VirtualStringTree2.SelectedCount=0 then
  b:=false;

Jumptoprofiledirectory1.Enabled:=b;
Loadselectedprofiles1.Enabled:=b;
Batchrunselectedprofiles1.Enabled:=b;
Rebuildall1.Enabled:=b;
friendfix1.Enabled:=b;
createxmldat1.Enabled:=b;

Community1.Enabled:=b;
Options1.Enabled:=b;

Delete1.Enabled:=b;
Properties1.Enabled:=b;
Dirmaker1.Enabled:=b;

if DataModule1.Tprofilesview.RecordCount>0 then
  b:=true;

Selectall1.Enabled:=b;
Invertselection1.Enabled:=b;

if VirtualStringTree2.SelectedCount=1 then begin
  Sendtogenerator1.Enabled:=true;
  Jumptoprofiledirectory1.Enabled:=false;

  //CHECK IF NOT ALL OR DEFAULT
  Gettreepath(treeview1.Selected,p);
  p:=checkpathbar(p);
  //P HAS CURRENT TREEPATH CHECK IF THE SAME OF SELECTED
  Datamodule1.Tprofilesview.Locate('CONT',VirtualStringTree2.FocusedNode.Index+1,[]);
  p2:=Datamodule1.Tprofilesview.fieldbyname('Path').asstring;
  if (p2='\') then //DEFAULT VALUE
    p2:=''
  else
    p2:=checkpathbar(p2);

  if treeview1.Selected.Index=0 then//FIX
    p2:='*';

  if wideuppercase(p)<>wideuppercase(p2) then
      Jumptoprofiledirectory1.Enabled:=true

end
else begin
  sendtogenerator1.Enabled:=false;
  Jumptoprofiledirectory1.Enabled:=false;
end;

//0.043
w:=getnodetextundermouse(virtualstringtree2);
Fakeedit.Text:=w;
if w<>'' then begin
  Copytoclipboard4.Enabled:=true;
  copy5.caption:=UTF8Encode(changein(w,'&','&&'));
end
else begin
  Copytoclipboard4.Enabled:=false;
end;

end;

procedure TFmain.SpeedButton13Click(Sender: TObject);
begin
if Fserver.IdTCPServer1.Active=true then begin //NO WHILE SERVER IS CONNECTED
  mymessageinfo(traduction(614));
  exit;
end;

Savedialog1.title:=traduction(3);
Savedialog1.Filter:=traduction(114)+' '+'(*.rml)|*.rml';
savedialog1.FileName:='';
SaveDialog1.InitialDir:=folderdialoginitialdircheck(initialdirsavedb);

positiondialogstart;

if SaveDialog1.Execute then begin
  initialdirsavedb:=WideExtractfilepath(savedialog1.FileName);
  createorloaddatabase(savedialog1.filename,true);
end;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.PageControl1Change(Sender: TObject);
var
aux:integer;
x:integer;
pass:boolean;
begin
aux:=PageControl1.ActivePageIndex;
currentdbstatusname;
setgeneratorpathlabel;

if aux=1 then begin
  //restorefocussedcontrol; //REMOVED 0.026
  LockWindowUpdate(0);
end
else
if (aux>3) then begin

  pagecontrol1.ActivePageIndex:=PageControl1.Tag;
  restorefocussedcontrol;

  LockWindowUpdate(0);

  case aux of
    4:begin
        pass:=false;
        //0.031 Removed Pocketheaven
        x:=datgroups.IndexOf('3|1');
        if x<>-1 then
          datgroups.Strings[x]:='3|0';
        //0.040 Removed Trurip NORMAL
        x:=datgroups.IndexOf('12|1');
        if x<>-1 then
          datgroups.Strings[x]:='12|0';
        //0.031 Removed Trurip SUPER
        x:=datgroups.IndexOf('13|1');
        if x<>-1 then
          datgroups.Strings[x]:='13|0';


        for x:=0 to datgroups.Count-1 do
          if gettoken(datgroups.Strings[x],'|',2)='1' then
            pass:=true;

        if pass=true then begin
          Application.CreateForm(TFupdater, Fupdater);
          myshowform(Fupdater,true);
          FreeAndNil(Fupdater);
        end
        else
          mymessagewarning(traduction(370));
    end;
    5:begin
        if Datamodule1.Tprofiles.IsEmpty=false then begin
          application.processmessages;
          Application.CreateForm(TFchart, Fchart);
          myshowform(Fchart,true);
          FreeAndNil(Fchart);
        end
        else
          mymessagewarning(traduction(128));
    end;
    6:begin
      showfserver;
    end;
    7:begin
        Application.CreateForm(TFsettings, Fsettings);
        myshowform(Fsettings,true);
        Freeandnil(Fsettings);
      end;
    8:wb_navigate(romulusurl,true,false);

  end;

end
else begin
  LockWindowUpdate(0);
end;

if (aux<>6) then //FIX
  restorefocussedcontrol;
  
treeview1.Tag:=0;//FIX
Fmain.Repaint;//FIX EFFECTS
freemousebuffer; //FIX EFFECTS
freekeyboardbuffer;  //FIX EFFECTS
end;


procedure TFmain.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

begin
savefocussedcontrol;

LockWindowUpdate(Handle);

if PageControl1.ActivePageIndex<=4 then
  PageControl1.Tag:=pagecontrol1.ActivePageIndex;


treeview1.Tag:=1;//FIX
end;

procedure TFmain.SpeedButton1Click(Sender: TObject);
begin
showprofiles(true);
end;

procedure TFmain.SpeedButton3Click(Sender: TObject);
begin
showprofiles(true);
end;

procedure TFmain.SpeedButton4Click(Sender: TObject);
begin
showprofiles(true);
end;

procedure TFmain.SpeedButton5Click(Sender: TObject);
begin
showprofiles(true);
end;

procedure TFmain.High1Click(Sender: TObject);
begin
High1.Checked:=true;
priority(0);
end;

procedure TFmain.Low1Click(Sender: TObject);
begin
low1.Checked:=true;
priority(2);
end;

procedure TFmain.SpeedButton11Click(Sender: TObject);
begin
if Fserver.IdTCPServer1.Active=true then begin //NO WHILE SERVER IS CONNECTED
  mymessageinfo(traduction(614));
  exit;
end;

opendialog1.title:=traduction(2);
opendialog1.Filter:=traduction(114)+' '+'(*.rml)|*.rml';
opendialog1.Options:=opendialog1.Options-[ofAllowMultiSelect];
opendialog1.filename:='';
opendialog1.InitialDir:=folderdialoginitialdircheck(initaldiropendatabase);

positiondialogstart;

if opendialog1.Execute then begin
  initaldiropendatabase:=wideextractfilepath(opendialog1.filename);
  createorloaddatabase(opendialog1.FileName,false);
end;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.SpeedButton6Click(Sender: TObject);
begin
savefocussedcontrol;

Application.CreateForm(TFscan, Fscan);
isrebuild:=false;
Fscan.loadprofile(getcurrentprofileid);
myshowform(Fscan,true);
Freeandnil(Fscan);

restorefocussedcontrol;
end;

procedure TFmain.PageControl2Change(Sender: TObject);
var
id:ansistring;
lvm,lvd:TVirtualStringTree;
x:integer;
begin

LockWindowUpdate(Handle);

lvm:=masterlv;
lvd:=detaillv;

//0.026 ICONS CHANGED EFFECT WHEN OFFLINE AND NOT OFFLINE
if (lvm<>nil) AND (lvd<>nil) then begin
  lvm.BeginUpdate;
  lvd.BeginUpdate;
end;


id:=getcurrentprofileid;

if id<>'' then //FIX
  showprolesmasterdetail(false,false,id,true,true);

//0.026 ICONS CHANGED EFFECT WHEN OFFLINE AND NOT OFFLINE
if (lvm<>nil) AND (lvd<>nil) then begin
  lvm.EndUpdate;
  lvd.EndUpdate;
end;

if masterlv<>nil then
  for x:=0 to masterlv.Header.Columns.Count-1 do
    if masterlv.Header.Columns[x].tag=0 then
      masterlv.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      masterlv.Header.Columns[x].Color:=clBtnFace
    else
      masterlv.Header.Columns[x].Color:=clwindow;

if detaillv<>nil then
  for x:=0 to detaillv.Header.Columns.Count-1 do
    if detaillv.Header.Columns[x].tag=0 then
      detaillv.Header.Columns[x].Color:=clwindow
    else
    if colorcolumns=true then
      detaillv.Header.Columns[x].Color:=clBtnFace
    else
      detaillv.Header.Columns[x].Color:=clwindow;


LockWindowUpdate(0);

if (sender is Ttntpagecontrol) then
  if (sender as TTntpagecontrol).name=Pagecontrol2.name then
    try
      restorefocussedcontrol ;
    except
    end;

//else
//  stablishfocus(lvm);
end;

procedure TFmain.Loadselectedprofiles1Click(Sender: TObject);
var
x:integer;
id:ansistring;
pass,continue:boolean;
n:PVirtualNode;
begin
if VirtualStringTree2.SelectedCount<=0 then
  exit;

sterrors.Clear;

savefocussedcontrol; //WHEN LOAD PROFILES AUTO CHANGE MAIN TAB SAVE PROFILES TAB

if VirtualStringTree2.SelectedCount>1 then
  showprocessingwindow(true,false) //CAN CANCEL IMPLEMENTED
else begin //NOT SHOW IF IS 1 AND ALREADY EXISTS
  showprocessingwindow(false,false); //CAN CANCEL IMPLEMENTED
end;

pass:=false;
Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(65);
n:=VirtualStringTree2.GetFirst;
for x:=0 to VirtualStringTree2.RootNodeCount-1 do begin

  if Fprocessing.Tag=1 then
    break;

  application.processmessages;

  if VirtualStringTree2.Selected[n]=true then begin
    DataModule1.Tprofilesview.locate('CONT',x+1,[]);
    id:=fillwithzeroes(DataModule1.Tprofilesview.fieldbyname('ID').asstring,4);

    //CHECK TABLES EXISTS
    continue:=false;

    //CHECK DAT TABLE EXISTS
    if ((Datamodule1.DBDatabase.TableExists('Y'+id)=true) AND (Datamodule1.DBDatabase.TableExists('Z'+id)=true)) then
      continue:=true;

    //CHECK OFFLINELIST TABLE ADDITIONAL
    if continue=true then
      if Datamodule1.Tprofilesview.FieldByName('Original').asstring='O' then
        continue:=Datamodule1.DBDatabase.TableExists('O'+id);

    if continue=true then begin //TABLE CHECK PASSED
      Fprocessing.Panel2.Caption:=changein(getwiderecord(DataModule1.Tprofilesview.fieldbyname('Description')),'&','&&');

      createnewprofiledetail(id,getwiderecord(DataModule1.Tprofilesview.fieldbyname('Description')));

      //Set position to selected or already loaded profile
      PageControl2.ActivePageIndex:=(FindComponent('CLONE_TabSheet7_'+id) as TTnttabsheet).PageIndex;

      showprolesmasterdetail(false,false,getcurrentprofileid,true,true);//FACE FIX
      application.processmessages;
      pass:=true;
    end
    else
      adderror(traduction(513)+' : '+DataModule1.Tprofilesview.fieldbyname('Description').asstring);

  end;

  n:=VirtualStringTree2.GetNext(n);
end;

loadimages;

if sterrors.Count>0 then
  mymessageerror(sterrors.Text);

if pass=true then begin
  pagecontrol1.ActivePageIndex:=1;
end;

hideprocessingwindow;
     
try
  if pass=true then //FIX
    stablishfocus(masterlv);
except
end;

end;

procedure TFmain.SpeedButton12Click(Sender: TObject);
begin
savefocussedcontrol;
LockWindowUpdate(Handle);
deletecurrentscantab;
refreshallfaces; //0.044
LockWindowUpdate(0);
showprolesmasterdetail(false,false,getcurrentprofileid,true,false);
restorefocussedcontrol;
end;

procedure TFmain.SpeedButton10Click(Sender: TObject);
var
p:TPoint;
begin
//if SpeedButton10.Down then begin
  GetCursorPos(p);
  PopupMenu7.Popup(p.X,p.Y);
//  application.processmessages;
//  SpeedButton10.Down := False;
//end;

end;

procedure TFmain.Panel36Resize(Sender: TObject);
begin
CenterInClient(label4,panel36);
label4.top:=label4.top-30;
labelshadow(Label4,Fmain);
CenterInClient(speedbutton17,panel36);
speedbutton17.top:=speedbutton17.top+20;
end;

procedure TFmain.SpeedButton17Click(Sender: TObject);
begin
pagecontrol1.ActivePageIndex:=0;
restorefocussedcontrol;
end;

procedure TFmain.SpeedButton18Click(Sender: TObject);
begin
speedbutton1.Down:=true;
SpeedButton1Click(sender);
end;

procedure TFmain.SpeedButton19Click(Sender: TObject);
begin
speedbutton3.Down:=true;
SpeedButton1Click(sender);
end;

procedure TFmain.SpeedButton20Click(Sender: TObject);
begin
speedbutton4.Down:=true;
SpeedButton1Click(sender);
end;

procedure TFmain.SpeedButton21Click(Sender: TObject);
begin
speedbutton5.Down:=true;
SpeedButton1Click(sender);
end;

procedure TFmain.BMDThread1Execute(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
var
aux:ansistring;
w:widestring;
begin
//Datamodule1.Qaux.sql.Text:=changein(Datamodule1.Qaux.sql.Text,#13#10,' '); //FIX FOR PARAMS

if Datamodule1.Qaux2.Tag=1 then begin
  try
    Datamodule1.Qaux2.Open;
  except
  end;

  Datamodule1.Qaux2.Tag:=0;

  exit;
end;

if Datamodule1.Qaux3.Tag=1 then begin
  try
    Datamodule1.Qaux3.Open;
  except
  end;

   Datamodule1.Qaux3.Tag:=0;

  exit;
end;

aux:=gettoken(trim(Datamodule1.Qaux.sql.Text),' ',1);

try
  if aux='DOWNLOAD' then begin

    aux:=gettoken(Datamodule1.Qaux.sql.Text,'"',2);
    w:=UTF8Decode(gettoken(Datamodule1.Qaux.sql.Text,'"',3));
    w:=trim(w);//BUG FIX
    if Fmain.downloadfile2(aux,w,false)=true then
      Datamodule1.Qaux.sql.Text:='OK';

  end
  else
  if aux='FORMATXML' then begin //0.034
    aux:=copy(Datamodule1.Qaux.SQL.Text,10,length(Datamodule1.Qaux.SQL.text));
    aux:=trim(aux);
    try
      if sizeoffile(aux)<10000000 then  //>=10Mb Ignore
        FormatXMLFile(utf8decode(aux));
    except
    end;
  end
  else
  if aux='POST' then begin //--------------------------------------------------
    if Datamodule1.DBDatabase.InTransaction=true then
      Datamodule1.DBDatabase.Commit(true);
  end
  else
  if aux='POSTDB' then begin  //-----------------------------------------------
    if DBaux.InTransaction=true then
      DBAux.Commit(false);
  end
  else
  if aux='POSTDBCLONES' then begin //------------------------------------------
    if DBClones.InTransaction=true then
      DBClones.Commit(false);
  end
  else
  if aux='POSTDBCONSTRUCTOR' then begin //------------------------------------------
    if Datamodule1.DBConstructor.InTransaction=true then
      Datamodule1.DBConstructor.Commit(false);
  end
  else
  if aux='EMPTYMASTER' then //--------------------------------------------------
    mastertable.EmptyTable
  else
  if aux='EMPTYDETAIL' then //--------------------------------------------------
    detailtable.EmptyTable
  else
  if aux='QSORT' then //--------------------------------------------------------
    Datamodule1.Qsort.Open
  else
  if aux='CHANGEDATABASESETTINGS' then //---------------------------------------
    Dbcheck.ChangeDatabaseSettings(aux,true,'',DBcheck.CryptoAlgorithm,defpagesize,defpagecountinextent,500)
  else
  if (aux='CONSTRUCTOR') OR (aux='CONSTRUCTORPROFILE') then begin //------------
    onthreadconstructor(aux);
  end
  else
  if (aux='DROP') OR (aux='ALTER') OR (aux='UPDATE') OR (aux='CREATE') then begin //--------------
    Datamodule1.Qaux.prepare;
    Datamodule1.Qaux.ExecSQL;
    Datamodule1.Qaux.Close;
  end
  else begin //-----------------------------------------------------------------
    Datamodule1.Qaux.Open;
    DataModule1.Qaux.first;
  end;
except
  {on E: exception do begin
  //caption:=('Exception message = '+E.Message);
  caption:=Datamodule1.Qaux.SQL.text;
  end;  }
end;

Thread.Terminate;
end;

procedure TFmain.BMDThread1Start(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
onathread:=true;

if gettoken(trim(Datamodule1.Qaux.SQL.Text),' ',1)='CONSTRUCTOR' then
  BMDThread1.UpdateEnabled:=true
else
  BMDThread1.UpdateEnabled:=false;

end;

procedure TFmain.SpeedButton14Click(Sender: TObject);
begin
showprolesmasterdetail(true,false,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton15Click(Sender: TObject);
begin
showprolesmasterdetail(true,false,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton16Click(Sender: TObject);
begin
showprolesmasterdetail(true,false,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton22Click(Sender: TObject);
begin
(FindComponent('CLONE_Speedbutton14_'+getcurrentprofileid) as TTntspeedbutton).down:=true;
showprolesmasterdetail(true,false,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton23Click(Sender: TObject);
begin
(FindComponent('CLONE_Speedbutton15_'+getcurrentprofileid) as TTntspeedbutton).down:=true;
showprolesmasterdetail(true,false,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton24Click(Sender: TObject);
begin
(FindComponent('CLONE_Speedbutton16_'+getcurrentprofileid) as TTntspeedbutton).down:=true;
showprolesmasterdetail(true,false,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton9Click(Sender: TObject);
begin
showprolesmasterdetail(false,true,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton8Click(Sender: TObject);
begin
showprolesmasterdetail(false,true,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton25Click(Sender: TObject);
begin
(FindComponent('CLONE_Speedbutton8_'+getcurrentprofileid) as TTntspeedbutton).down:=true;
showprolesmasterdetail(false,true,getcurrentprofileid,true,true);
end;

procedure TFmain.SpeedButton26Click(Sender: TObject);
begin
(FindComponent('CLONE_Speedbutton9_'+getcurrentprofileid) as TTntspeedbutton).down:=true;
showprolesmasterdetail(false,true,getcurrentprofileid,true,true);
end;

procedure TFmain.FormClose(Sender: TObject; var Action: TCloseAction);
var
path:widestring;
x:integer;
begin
treeview1.Tag:=1;

VirtualStringTree2.RootNodeCount:=0;
VirtualStringTree4.rootnodecount:=0;

Freeandnil(sterrors);
Freeandnil(stcompfiles);
Freeandnil(stcompfiles2);
Freeandnil(stcompcrcs);
Freeandnil(stcompcrcs2);
Freeandnil(stcompsizes);
Freeandnil(stcompsizes2);
Freeandnil(stsets);
Freeandnil(stroms);
Freeandnil(stdropfolders);
Freeandnil(stsofts);
Freeandnil(datgroups);
Freeandnil(activeformlist);
Freeandnil(stsimplehash);
Freeandnil(stsimplehashreb);
Freeandnil(stids);
Freeandnil(writelist);
Freeandnil(Threadstodestroy);
Freeandnil(batchlist);
Freeandnil(dialoglist);

Freeandnil(png);
Freeandnil(png2);
Freeandnil(pngstream);
Freeandnil(bmp);

//Fserver
Freeandnil(commands);
Freeandnil(requests);
Freeandnil(Q);
Freeandnil(Q2);
Freeandnil(Q3);

rar1.UnloadDLL;
rar2.UnloadDLL;

try //SAVE NODES EXPANSION VALUE
if Datamodule1.DBDatabase.Connected=true then
  for x:=2 to TreeView1.Items.Count-1 do begin
    path:='';
    Gettreepath(treeview1.Items.Item[x],path);

    if Datamodule1.TTree.Locate('Path',path,[]) then begin
      Datamodule1.TTree.Edit;
      Datamodule1.TTree.FieldByName('Expanded').asboolean:=treeview1.items.Item[x].Expanded;
      Datamodule1.TTree.post;
    end;
  end;
except
end;

treeview1.Items.Clear;

for x:=0 to DataModule1.ComponentCount-1 do  //Close all databases and delete temporals
  if Datamodule1.Components[x] is TABSDatabase then
    try
      (Datamodule1.Components[x] as Tabsdatabase).close;
    except
    end;

decision:=2;
if WideDirectoryExists(tempdirectoryresources) then
  Scandirectory(tempdirectoryresources,'*.rmt',1,false);

try
  WideSetCurrentDir(tempdirectoryresources);//Fix no removable folder
except
end;


decision:=2;
stop:=false;
if WideDirectoryExists(tempdirectoryextractserver) then
  Scandirectory(tempdirectoryextractserver,'*.*',1,false);

try
  WideSetCurrentDir(tempdirectoryextractserver);//Fix no removable folder
except
end;

try //Forze elimination of all webpages opened
  SpeedButton59Click(sender);
except
end;

Set8087CW(Saved8087CW);//Remove initialization of floating error fix for wb
OleUninitialize;

try
  Halt;//FORZE CLOSE
except
end;
try
 // KillProcess(application.Handle);//SECURITY KILL APPLICATION NO EXCEPTION PREVENT
except
end;
end;

procedure TFmain.RAR1ListFile(Sender: TObject;
  const FileInformation: TRARFileItem);
var
fil,aux2:widestring;
i,x:integer;
begin
//CHANGED SINZE 0.017
if FileInformation.Attributes=faDirectory then begin
  fil:=Changein(FileInformation.FileNamew+'\','/','\');
  if stcompfiles.IndexOf(fil)=-1 then begin //0.034 FIX
    stcompcrcs.add('00000000');
    stcompsizes.Add('0');
  end
  else
    exit;
end
else begin
  fil:=Changein(FileInformation.FileNamew,'/','\');
  stcompcrcs.Add(fillwithzeroes(FileInformation.CRC32,8));//fix for rar
  stcompsizes.Add(CurrToStr(int64(Fileinformation.UnCompressedSize)));
  realcompressedfilecount:=realcompressedfilecount+1;
end;

//0.028 SPEEDUP SORTING AND FINDING METHOD
stcompfiles.Add(fil);
i:=stcompfiles.IndexOf(fil);
stcompcrcs.Move(stcompcrcs.Count-1,i);
stcompsizes.Move(stcompsizes.Count-1,i);

//Folder fix problem 0.032
aux2:='';
i:=GetTokenCount(fil,'\');

if i>1 then
  for x:=1 to i-1 do begin

    aux2:=aux2+gettoken(fil,'\',x)+'\';
    i:=stcompfiles.IndexOf(aux2);

    if i=-1 then begin //DOES NOT EXISTS ADD IT
      stcompfiles.Add(aux2);
      stcompcrcs.add('00000000');
      stcompsizes.Add('0');
      i:=stcompfiles.IndexOf(aux2);//REORDER
      stcompcrcs.Move(stcompcrcs.Count-1,i);
      stcompsizes.Move(stcompsizes.Count-1,i);
    end;
  end;

end;

procedure TFmain.SevenZip1Listfile(Sender: TObject; Filename: WideString;
  Fileindex, FileSizeU, FileSizeP, Fileattr, Filecrc: Int64;
  Filemethod: WideString; FileTime: Double);
var
fil,aux2:widestring;
i,x:integer;
begin

if gettokencount(filemethod,'06F10701')>1 then //PASSWORD
  SevenZip1.Tag:=1;
                                       //EXCEPTION
if fileattr = fadirectory then begin

  fil:=changein(Filename+'\','/','\');
  if stcompfiles.IndexOf(fil)=-1 then begin //0.034 FIX
    stcompcrcs.add('00000000');
    stcompsizes.Add('0');
  end
  else
    exit;
end
else begin
  fil:=changein(Filename,'/','\');
  //stcompcrcs.add(inttohex(Filecrc,8));
  if FileSizeU<>0 then
    stcompcrcs.Add(hextl(filecrc)) //INTTOHEX DONT WORKS FINE
  else
    stcompcrcs.add('00000000');
    
  stcompsizes.Add(IntToStr(FileSizeU));
  realcompressedfilecount:=realcompressedfilecount+1;
end;

//0.028 SPEEDUP SORTING AND FINDING METHOD
stcompfiles.Add(fil);
i:=stcompfiles.IndexOf(fil);
stcompcrcs.Move(stcompcrcs.Count-1,i);
stcompsizes.Move(stcompsizes.Count-1,i);

//Folder fix problem 0.032
aux2:='';
i:=GetTokenCount(fil,'\');

if i>1 then
  for x:=1 to i-1 do begin

    aux2:=aux2+gettoken(fil,'\',x)+'\';
    i:=stcompfiles.IndexOf(aux2);

    if i=-1 then begin //DOES NOT EXISTS ADD IT
      stcompfiles.Add(aux2);
      stcompcrcs.add('00000000');
      stcompsizes.Add('0');
      i:=stcompfiles.IndexOf(aux2);//REORDER
      stcompcrcs.Move(stcompcrcs.Count-1,i);
      stcompsizes.Move(stcompsizes.Count-1,i);
    end;
  end;
end;

procedure TFmain.SpeedButton27Click(Sender: TObject);
var
o,r:widestring;
param:string;
f:TGpTextFile;
pass:boolean;
begin
autodecision:=-1;
Opendialog1.Filter:=traduction(108)+' (*.exe)|*.exe';
OpenDialog1.title:=speedbutton27.Hint;
opendialog1.Options:=opendialog1.Options-[ofAllowMultiSelect];
o:=tempdirectoryresources+'MAME.dat';
deletefile2(o);
sterrors.Clear;//Initialize
imported:=0;//Initialize
opendialog1.filename:='';
opendialog1.InitialDir:=folderdialoginitialdircheck(initialdirimportmameexe);
pass:=true;

positiondialogstart;

if opendialog1.Execute then begin

  showprocessingwindow(false,false); //CAN NOT BE IMPLEMENTED
            
  initialdirimportmameexe:=wideextractfilepath(opendialog1.filename);
  Fprocessing.panel3.Caption:=traduction(61)+' : ';
  Fprocessing.panel3.Caption:=Fprocessing.panel3.Caption+traduction(71);
  Fprocessing.Panel2.Caption:='MAME.dat';
  Fprocessing.repaint;

  deletefile2(o);

  param:='-listxml';

  //0.029 Since 0.162 try to know if is >= with mess or old
  RunAndWaitShell('"'+UTF8Encode(opendialog1.FileName)+'"','-showusage',0,true,false);

  if fileexists2(o) then begin
    try
      f:=TGpTextFile.CreateW(o);
      f.reset;
      r:=f.Readln;
      if (gettokencount(wideuppercase(r),'[MACHINE]')>1) OR (gettokencount(wideuppercase(r),'[MEDIA]')>1) then begin//MAME & MESS FUSION

        Application.CreateForm(TFsoftselect, Fsoftselect);

        if gettokencount(wideuppercase(r),'[MACHINE]')>1 then  //Pretranslation
          Fsoftselect.TntRadioGroup1.Items.Strings[0]:=traduction(581) //ARCADES
        else
          Fsoftselect.TntRadioGroup1.Items.Strings[0]:=traduction(583); //BIOS

        myshowform(Fsoftselect,true);

        if Fsoftselect.tag=1 then begin//ACCEPT
          if Fsoftselect.TntRadioGroup1.ItemIndex=1 then
            param:='-listsoftware';
        end
        else
          pass:=false;

        FreeAndNil(Fsoftselect);

      end;

    except
    end;

    FreeAndNil(f);
  end;

  deletefile2(o);

  if pass=true then begin

    RunAndWaitShell('"'+UTF8Encode(opendialog1.FileName)+'"',param,0,true,false);

    if fileexists2(o) then
      processnewdat(o);


    deletefile2(o);
  end;

  hideprocessingwindow;

  if pass=true then
    if imported<>0 then begin
      showprofiles(true);
      processnewdatshowresults;
    end
    else
      mymessageerror(traduction(115)+' '+opendialog1.FileName);
end;

imported:=0;
end;

procedure TFmain.Selectall2Click(Sender: TObject);
begin
masterlv.SelectAll(false);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.Invertselection2Click(Sender: TObject);
begin
masterlv.InvertSelection(false);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.Batchrunselectedprofiles1Click(Sender: TObject);
begin
scanorrebuildinbatch(true,false);
end;

procedure TFmain.SpeedButton30Click(Sender: TObject);
begin
scanorrebuildinbatch(true,false);
end;

procedure TFmain.ExplorerDrop1FolderNotAllowed(Sender: TObject;
  FileName: widestring);
begin
stdropfolders.Add(filename+'\');
end;

procedure TFmain.PageControl2Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
savefocussedcontrol;
end;

procedure TFmain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
msg:widestring;
begin
if activeformlist=nil then
  exit;
  
if GetFormsCount<>2 then begin
  canclose:=false;
  beep;
  exit;
end;

if CoolTrayIcon1.Tag=1 then //0.044
  CoolTrayIcon1DblClick(sender);

//MESSAGE
msg:=traduction(612);
if Fserver.IdTCPServer1.Active=true then
  msg:=msg+#13#10#13#10+'* '+traduction(613);


if mymessagequestion(msg,false)=0 then begin
  canclose:=false;
  exit;
end;

Fmain.TreeView1.Tag:=1;//CLOSE SPEEDUP

try
  Fserver.close; //IF EXISTS
except
end;

if CoolTrayIcon1.Tag=1 then begin
  Fmain.AlphaBlend:=true;
  cooltrayicon1.ShowMainForm;
end;


try
  saveconfig;
except
end;


Fmain.CoolTrayIcon1.IconVisible:=false;
CoolTrayIcon1.HideTaskbarIcon;
Fmain.CoolTrayIcon1.Enabled:=false;
Showwindow(Application.Handle, SW_Hide); //HIDE TASKBAR
hide;//HIDE MAINFORM

try //PRESS DISCONNECT BUTTON
  if Fserver.IdTCPClient1.Connected=true then begin
    Fserver.SpeedButton1.Down:=false;
    Fserver.SpeedButton1Click(sender);
  end;
except
end;

end;

procedure TFmain.SpeedButton7Click(Sender: TObject);
begin
if VirtualStringTree2.RootNodeCount=0 then begin
  mymessagewarning(traduction(212));
  exit;
end;

Application.CreateForm(TFreport, Freport);
myshowform(Freport,true);

Freeandnil(Freport);
end;

procedure TFmain.SpeedButton28Click(Sender: TObject);
begin
scanorrebuildinbatch(false,true);
end;

procedure TFmain.SpeedButton29Click(Sender: TObject);
begin
savefocussedcontrol;

if masterlv.rootnodecount=0 then begin
  mymessagewarning(traduction(212));
  exit;
end;

Application.CreateForm(TFreport, Freport);
myshowform(Freport,true);

FreeAndNil(Freport);

restorefocussedcontrol;
end;

procedure TFmain.BMDThread1Terminate(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer);
begin
onathread:=false;
speedupdb;
BMDThread1.UpdateEnabled:=False;
end;

procedure TFmain.Timer1Timer(Sender: TObject);
begin
timer1.enabled:=false;

if speedbutton7.Tag=1 then  //Autoscroll
  Flog.speedbutton3.Down:=false;

if speedbutton13.tag=0 then  //Showlog
  Flog.Tag:=0;

if speedbutton11.tag=1 then
  Flog.SpeedButton4.Down:=false;

combobox1.ItemIndex:=0;

EnableWindow(handle,true);
activeformlist.Clear;//FIX
Fmain.Enabled:=true;//Bugfix


if cooltrayicon1.Tag=2 then
  cooltrayicon1.IconVisible:=true;

CoolTrayIcon1.Hint:=Application.Title+' - '+appversion;//FIX

cooltrayicon1.Tag:=0;

If startupconnect=true then begin
  Fserver.SpeedButton1.Down:=true;
  Fserver.SpeedButton1Click(sender);
end;

showmyquerys;

freekeyboardbuffer;
freemousebuffer;

stablishfocus(edit4);//0.040FIX
stablishfocus(treeview1);//0.040FIX

if timer1.Tag=1 then
  setstayontop;
//timer1.Free;

try
  if (startupdate=true) and (wb_current.tag=1) then begin
    pagecontrol1.ActivePageIndex:=3;
  end;
  except
end;

startupdate:=false;
end;

procedure TFmain.SpeedButton33Click(Sender: TObject);
var
aux:ansistring;
res:boolean;
begin
LockWindowUpdate(Handle);

res:=false;
aux:=getcurrentprofileid;
Datamodule1.Tprofiles.Locate('ID',strtoint(aux),[]);

if speedbutton33.Down then begin
  if Datamodule1.Tprofiles.fieldbyname('Original').AsString='O' then
    res:=true;
end;

Datamodule1.Tprofiles.edit;
Datamodule1.Tprofiles.fieldbyname('IMG').asboolean:=res;
Datamodule1.Tprofiles.post;

loadimages;

showprolesmasterdetail(false,false,aux,true,true);
LockWindowUpdate(0);
end;

procedure TFmain.Panel58Resize(Sender: TObject);
var
x:integer;
begin
//FIX IMAGES SIZE
x:=panel58.Height-6;
x:=x div 2;
image322.Height:=x;
end;

procedure TFmain.SpeedButton32Click(Sender: TObject);
begin
setimagepath(edit3);
end;

procedure TFmain.SpeedButton34Click(Sender: TObject);
begin
Application.CreateForm(TFofflineupdate, Fofflineupdate);
Fofflineupdate.loadprofile(getcurrentprofileid);
myshowform(Fofflineupdate,true);

Freeandnil(Fofflineupdate);
end;

procedure TFmain.SpeedButton35Click(Sender: TObject);
begin
findinlistview(VirtualStringTree2,Datamodule1.Tprofilesview,true,edit4,'Description');
end;


procedure TFmain.SpeedButton37Click(Sender: TObject);
begin
findinlistview(VirtualStringTree2,Datamodule1.Tprofilesview,false,edit4,'Description');
end;

procedure TFmain.SpeedButton36Click(Sender: TObject);
begin
findinlistviewscanner(false);
end;

procedure TFmain.SpeedButton38Click(Sender: TObject);
begin
findinlistviewscanner(true);

end;

procedure TFmain.Edit5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  SpeedButton38Click(sender);
end;

procedure TFmain.Edit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  SpeedButton35Click(sender);
end;

procedure TFmain.SpeedButton39Click(Sender: TObject);
begin
Application.CreateForm(TFemulators, Femulators);
Femulators.Caption:=traduction(277);
myshowform(Femulators,true);

Freeandnil(Femulators);
setpopupemulatorslist;
end;

procedure TFmain.Properties1Click(Sender: TObject);
begin
Application.CreateForm(TFproperties, Fproperties);
myshowform(Fproperties,true);

Freeandnil(Fproperties);
end;

procedure TFmain.SpeedButton40Click(Sender: TObject);
begin
createffix(false);
end;

procedure TFmain.SpeedButton31Click(Sender: TObject);
begin
scanorrebuildinbatch(false,false);
end;

procedure TFmain.Rebuildall1Click(Sender: TObject);
begin
scanorrebuildinbatch(false,false);
end;

procedure TFmain.ExplorerDrop2FolderNotAllowed(Sender: TObject;
  FileName: widestring);
begin
stdropfolders.Add(filename+'\');
end;

procedure TFmain.ExplorerDrop2Dropped(Sender: TObject; Files: TTntstrings;
  FileCount, x, y: Integer);
var
continue:boolean;
begin
continue:=true;
if (Files.Count=0) AND (stdropfolders.Count=0) then
  continue:=false;


if continue=true then
if (explorerdrop2.Tag=1) then begin //SCANNER DROP
  if pagecontrol1.ActivePageIndex<>1 then
    continue:=false;
end
else //GET CHECKSUMS
if (explorerdrop3.Tag=1) then begin
  if pagecontrol1.ActivePageIndex<>2 then
    continue:=false;
end
else
  continue:=false;

if GetFormsCount<>2 then  //SECURITY
  continue:=false;

if continue=true then
  Fmain.Show; //FIX FOCUS FOR FSERVER

if continue=true then
  if pagecontrol1.ActivePageIndex=1 then begin
    if mymessagequestion(traduction(286),false)<>0 then
      SpeedButton28Click(sender);
  end
  else
  if pagecontrol1.ActivePageIndex=2 then
    if (stdropfolders.Count<>1) OR (ExplorerDrop4.FileCount<>0) then
      mymessageerror(traduction(334))
    else
    if mymessagequestion(traduction(332),false)<>0 then begin
      initialdirhash:=checkpathbar(stdropfolders.Strings[0]);
      sterrors.Clear;
      buildingchecksums(true);
    end;


taskbaractive(false);

ExplorerDrop2.FileNames.Clear;
Explorerdrop3.FileNames.clear;
stdropfolders.Clear;

explorerdrop2.Tag:=0;//FIX NO REPEAT
explorerdrop3.Tag:=0;
end;

procedure TFmain.ExplorerDrop1BeginDrop(Sender: TObject);
begin
stdropfolders.Clear;
end;

procedure TFmain.ExplorerDrop2BeginDrop(Sender: TObject);
begin
stdropfolders.Clear;
explorerdrop2.Tag:=1;
end;

procedure TFmain.Configureemu1Click(Sender: TObject);
begin
SpeedButton39Click(Sender);
end;

procedure TFmain.PopupMenu4Popup(Sender: TObject);
var
w,rp,sp,cp:widestring;
begin
Fmain.destroycustomhint;
setpopupemulatorslist;

if masterlv.rootnodecount<>0 then
  Smartsearchingoogle1.enabled:=true
else
  Smartsearchingoogle1.enabled:=false;

PopupMenu11Popup(sender);//Search for files in list

Extractto1.Enabled:=false;
Copyto1.enabled:=false;
Sendtorequests1.Enabled:=false;

if masterlv.SelectedCount>0 then begin
  if (pagecontrol2.ActivePage.ImageIndex<>0) AND (pagecontrol2.ActivePage.ImageIndex<>4) then
    sendtorequests1.Enabled:=true;

  rp:=getromspathofid(strtoint(getcurrentprofileid));
  sp:=getsamplespathofid(strtoint(getcurrentprofileid));
  cp:=getchdspathofid(strtoint(getcurrentprofileid));

  if (WideDirectoryexists(rp)) OR (WideDirectoryexists(sp)) OR (WideDirectoryexists(cp)) then begin
    Extractto1.Enabled:=true;
    copyto1.Enabled:=true;
  end;
end;

//0.043
w:=getnodetextundermouse(masterlv);
Fakeedit.Text:=w;
if w<>'' then begin
  Copytoclipboard2.Enabled:=true;
  copy3.Caption:=UTF8Encode(changein(w,'&','&&'));
end
else begin
  Copytoclipboard2.Enabled:=false;
end;

end;

procedure TFmain.Hide1Click(Sender: TObject);
begin
close;
end;

procedure TFmain.RAR2ListFile(Sender: TObject;
  const FileInformation: TRARFileItem);
var
fil,aux2:widestring;
i,x:integer;
begin
//CHANGED SINZE 0.017
if FileInformation.Attributes=faDirectory then begin
  fil:=Changein(FileInformation.FileNamew+'\','/','\');
  if stcompfiles2.IndexOf(fil)=-1 then begin //0.034 FIX
    stcompcrcs2.add('00000000');
    stcompsizes2.Add('0');
  end
  else
    exit;
end
else begin
  fil:=Changein(FileInformation.FileNamew,'/','\');
  stcompcrcs2.Add(fillwithzeroes(FileInformation.CRC32,8));//Fix for rar
  stcompsizes2.Add(currtostr(Fileinformation.UnCompressedSize));
end;

//0.028 SPEEDUP SORTING AND FINDING METHOD
stcompfiles2.Add(fil);
i:=stcompfiles2.IndexOf(fil);
stcompcrcs2.Move(stcompcrcs2.Count-1,i);
stcompsizes2.Move(stcompsizes2.Count-1,i);

//Folder fix problem 0.032
aux2:='';
i:=GetTokenCount(fil,'\');

if i>1 then
  for x:=1 to i-1 do begin

    aux2:=aux2+gettoken(fil,'\',x)+'\';
    i:=stcompfiles2.IndexOf(aux2);

    if i=-1 then begin //DOES NOT EXISTS ADD IT
      stcompfiles2.Add(aux2);
      stcompcrcs2.add('00000000');
      stcompsizes2.Add('0');
      i:=stcompfiles2.IndexOf(aux2);//REORDER
      stcompcrcs2.Move(stcompcrcs2.Count-1,i);
      stcompsizes2.Move(stcompsizes2.Count-1,i);
    end;
  end;
end;

procedure TFmain.ExplorerDrop3BeginDrop(Sender: TObject);
begin
ExplorerDrop3.Tag:=1;
ExplorerDrop2BeginDrop(sender);
end;

procedure TFmain.ExplorerDrop3Dropped(Sender: TObject; Files: TTntstrings;
  FileCount, x, y: Integer);
begin
ExplorerDrop2Dropped(sender,Files,Filecount,x,y);
end;

procedure TFmain.ExplorerDrop3FolderNotAllowed(Sender: TObject;
  FileName: widestring);
begin
ExplorerDrop2FolderNotAllowed(sender,Filename);
end;

procedure TFmain.RAR1NextVolumeRequired(Sender: TObject;
  const requiredFileName: widestring; out newFileName: widestring;
  out Cancel: Boolean);
begin
cancel:=true;
end;

procedure TFmain.SpeedButton41Click(Sender: TObject);
begin
createffix(true);
end;

procedure TFmain.ExplorerDrop4BeginDrop(Sender: TObject);
begin
ExplorerDrop2BeginDrop(sender);
end;

procedure TFmain.ExplorerDrop4Dropped(Sender: TObject; Files: TTntstrings;
  FileCount, x, y: Integer);
begin
ExplorerDrop2.Tag:=0;
ExplorerDrop3.Tag:=1;
ExplorerDrop2Dropped(sender,Files,Filecount,x,y);
end;

procedure TFmain.ExplorerDrop4FolderNotAllowed(Sender: TObject;
  FileName: widestring);
begin
ExplorerDrop2FolderNotAllowed(sender,Filename);
end;

procedure TFmain.BMDThread1Update(Sender: TObject;
  Thread: TBMDExecuteThread; var Data: Pointer; Percent: Integer);
begin
BMDThread1.UpdateEnabled:=false;

try
  if formexists('Fprocessing') then
    Fprocessing.Panel2.Caption:=changein(currentset,'&','&&');
except
end;

BMDThread1.UpdateEnabled:=true;
end;

procedure TFmain.Selectall3Click(Sender: TObject);
begin
VirtualStringTree4.SelectAll(true);

freekeyboardbuffer;
freemousebuffer;
end;

procedure TFmain.Invertselection3Click(Sender: TObject);
begin
VirtualStringTree4.InvertSelection(true);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.SpeedButton45Click(Sender: TObject);
var
fold:widestring;
begin
fold:=folderdialoginitialdircheck(initialdirhash);
stdropfolders.Clear;

positiondialogstart;

if WideSelectDirectory(traduction(335)+' :','',fold) then begin
  fold:=checkpathbar(fold);
  initialdirhash:=fold;
  stdropfolders.Add(fold);
  buildingchecksums(true);
end;

try
  ChDir(tempdirectoryresources);//Fix no removable folder
except
end;

end;

procedure TFmain.SpeedButton46Click(Sender: TObject);
begin
Application.CreateForm(TFproperties, Fproperties);
myshowform(Fproperties,true);
Freeandnil(Fproperties);
end;

procedure TFmain.SpeedButton44Click(Sender: TObject);
var
Q:Tabsquery;
writed:boolean;
aux:widestring;
begin
//BUG NO OVERWRITE AND EXCEPTION

writed:=False;
Q:=Datamodule1.Qconstructor;
speedupdb;

Savedialog1.title:=speedbutton44.Hint;
Savedialog1.Filter:=traduction(326)+' '+'(*.xml)|*.xml';
savedialog1.FileName:='';
SaveDialog1.InitialDir:=folderdialoginitialdircheck(initialdirxmlexport);

positiondialogstart;

if SaveDialog1.Execute then begin

  try

    if FileExists2(savedialog1.FileName) then
      if mymessagequestion(traduction(216)+#10#13+savedialog1.FileName,false)=0 then begin
        exit;
      end;

    Application.CreateForm(TFnewdat, Fnewdat);
    initialdirxmlexport:=wideextractfilepath(savedialog1.FileName);
    Fnewdat.Image3210.Tag:=1;
    Fnewdat.Edit2.Text:=wideextractfilename(savedialog1.FileName);

    //MOD 0.046
    aux:=gettoken(sourcebuilder,'\',gettokencount(sourcebuilder,'\')-1);
    Fnewdat.edit9.Text:=aux;
    Fnewdat.Edit1.Text:=aux;

    Fnewdat.trimall;

    myshowform(Fnewdat,true);

    If Fnewdat.Edit9.Text='' then
      Fnewdat.edit9.Text:=aux;
    If Fnewdat.Edit1.Text='' then
      Fnewdat.Edit1.Text:=Aux;

    if Fnewdat.Tag=0 then begin
      Freeandnil(Fnewdat);
      exit;
    end;

    showprocessingwindow(false,false);
    Fprocessing.panel3.Caption:=traduction(61)+' : '+traduction(327);

    Fprocessing.panel2.Caption:=changein(wideextractfilename(savedialog1.filename),'&','&&');

    Q.close;
    Q.DatabaseName:='DBConstructor';
    Q.SQL.Clear;
    Q.sql.Add('SELECT * FROM Profiles');
    Q.Open;
    Q.First;

    //version,date,author,category,homepage,email
    preparexmlwrite(tempdirectoryresources+'export.rmt',Fnewdat.Edit9.Text,Fnewdat.Edit1.Text,Fnewdat.Edit3.Text,Fnewdat.edit4.Text,Fnewdat.edit5.Text,Fnewdat.edit6.text,Fnewdat.edit7.Text,Fnewdat.edit8.text,'');

    Freeandnil(Fnewdat);

    while not Q.Eof do begin

      Application.ProcessMessages;

      if Q.fieldbyname('Checked').AsBoolean=true then begin

        if Q.fieldbyname('Origin').asinteger=0 then begin

          if Q.Eof=false then begin //Fix possible bugs description but not details
            Q.Next;
            if Q.fieldbyname('Origin').asinteger<>0 then
              Q.prior;

          end
          else
            break;

          if writed=true then//Close set description
            xmlcloseset;

          xmlwriteset(getwiderecord(Q.fieldbyname('Filename')),getwiderecord(Q.fieldbyname('Description')));
        end
        else begin
          xmlwriterom(getwiderecord(Q.fieldbyname('Filename')),Q.fieldbyname('Space').asstring,Q.fieldbyname('CRC').asstring,Q.fieldbyname('MD5').asstring,Q.fieldbyname('SHA1').asstring,Q.fieldbyname('type').asinteger);
          writed:=true;
        end;

      end;

      Q.Next;

    end;

    //Fix finish
    if writed=true then
      xmlcloseset;

    closexmlwrite;

    if movefile2(tempdirectoryresources+'export.rmt',Savedialog1.FileName)=false then
      makeexception;

    hideprocessingwindow;
    mymessageinfo(traduction(369)+#10#13+savedialog1.FileName);
  except
    closexmlwrite;
    deletefile2(savedialog1.FileName);
    hideprocessingwindow;
    mymessageerror(traduction(150)+#10#13+savedialog1.FileName);
  end;

  closexmlwrite;

end;

try
  Q.close;
except
end;

try
  Freeandnil(Fnewdat);
except
end;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.SpeedButton48Click(Sender: TObject);
begin
findinlistviewbuilder(true);
end;

procedure TFmain.SpeedButton47Click(Sender: TObject);
begin
findinlistviewbuilder(false);
end;

procedure TFmain.Edit6KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  SpeedButton48Click(sender);
end;

procedure TFmain.Checkselected1Click(Sender: TObject);
begin
screen.Cursor:=crHourGlass;
checkselectedconstructor(true);
screen.Cursor:=crdefault;
end;

procedure TFmain.Uncheckselected1Click(Sender: TObject);
begin
screen.Cursor:=crHourGlass;
checkselectedconstructor(false);
screen.Cursor:=crdefault;
end;

procedure TFmain.PageControl2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if button=mbleft then
  PageControl2.BeginDrag(False) ;
end;

function TFmain.GetTabIndex(Pager: TTntpagecontrol; X,Y: integer): integer;
var r: TRect;
begin
  with Pager do
    result := PageCount - 1;
    while result >=0 do begin
      TabCtrl_GetItemRect(Pager.Handle, result, r);
      if PtInRect(r, Point(X, Y)) then
        break;
      dec(result);
  end;
end;

procedure TFmain.PageControl2DragDrop(Sender, Source: TObject; X,
  Y: Integer);
const
TCM_GETITEMRECT = $130A;
var
TabRect: TRect;
j: Integer;
begin
if (Sender is TTntpagecontrol) then
  if GetParentForm(source as TTntpagecontrol).Name='Fmain' then
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

procedure TFmain.PageControl2DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
accept:=false;
try
  if (Sender is TTntpagecontrol) then
    if screen.ActiveForm=Fmain then
      Accept := true;
except
end;
end;

procedure TFmain.RAR2NextVolumeRequired(Sender: TObject;
  const requiredFileName: widestring; out newFileName: widestring;
  out Cancel: Boolean);
begin
cancel:=true;
end;

procedure TFmain.TreeView1Compare(Sender: TObject; Node1, Node2: TTreeNode;
  Data: Integer; var Compare: Integer);
begin //FIX TREE SORTING WITH SPECIAL PURPLE FOLDERS
if (node1.imageindex=32) or (node2.imageindex=32) then
  compare:=0
else
if wideuppercase(node1.Text)<wideuppercase(node2.text) then
  compare:=-1
else
  compare:=1

end;

procedure TFmain.SpeedButton50Click(Sender: TObject);
begin
if mymessagequestion(traduction(388),false)=1 then begin
  VirtualStringTree4.rootnodecount:=0;
  DataModule1.DBConstructor.Close;
  checkconstructorstatus;
  VirtualStringTree4.Repaint;
end;

end;

procedure TFmain.Sendtogenerator1Click(Sender: TObject);
begin
buildingchecksums(false);
end;

procedure TFmain.SpeedButton51Click(Sender: TObject);
begin
buildingchecksums(false);
end;

procedure TFmain.Close1Click(Sender: TObject);
begin
if screen.ActiveForm=Fserver then
  Fserver.SpeedButton4Click(sender)
else
if pagecontrol1.ActivePageIndex=1 then
  SpeedButton12Click(sender)
else
  SpeedButton52Click(sender);  
end;

procedure TFmain.Gotofirst1Click(Sender: TObject);
begin
if screen.ActiveForm=Fserver then begin
  Fserver.pagecontrol2.Pages[Fserver.PageControl2.ActivePageIndex].PageIndex:=1;
  Fserver.pagecontrol2.ActivePageIndex:=0;
  Fserver.pagecontrol2.ActivePageIndex:=1;
end
else
if pagecontrol1.ActivePageIndex=1 then begin
  pagecontrol2.Pages[PageControl2.ActivePageIndex].PageIndex:=1;
  pagecontrol2.ActivePageIndex:=0;
  pagecontrol2.ActivePageIndex:=1;
end
else begin
  pagecontrol3.Pages[PageControl3.ActivePageIndex].PageIndex:=0;
  pagecontrol3.ActivePageIndex:=0;
end;
end;

procedure TFmain.Gotolast1Click(Sender: TObject);
begin
if screen.ActiveForm=Fserver then begin
  Fserver.pagecontrol2.Pages[Fserver.PageControl2.ActivePageIndex].PageIndex:=Fserver.pagecontrol2.PageCount-1;
  Fserver.pagecontrol2.ActivePageIndex:=0;
  Fserver.pagecontrol2.ActivePageIndex:=Fserver.pagecontrol2.PageCount-1;
end
else
if pagecontrol1.ActivePageIndex=1 then begin
  pagecontrol2.Pages[PageControl2.ActivePageIndex].PageIndex:=pagecontrol2.PageCount-1;
  pagecontrol2.ActivePageIndex:=0;
  pagecontrol2.ActivePageIndex:=pagecontrol2.PageCount-1;
end
else begin
  pagecontrol3.Pages[PageControl3.ActivePageIndex].PageIndex:=pagecontrol3.PageCount-1;
  pagecontrol3.ActivePageIndex:=0;
  pagecontrol3.ActivePageIndex:=pagecontrol3.PageCount-1;
end;
end;

procedure TFmain.PopupMenu6Popup(Sender: TObject);
var
id:longint;
begin
Gotofirst1.Enabled:=true;
Gotolast1.Enabled:=True;
newtab1.Visible:=false;
n23.Visible:=false;
n40.Visible:=false;
share1.Visible:=false;
unshare1.visible:=false;
jumptodir1.Visible:=false;
sendtorequest1.Visible:=false;
sendtorequest1.Enabled:=false;
n45.Visible:=false;

if screen.ActiveForm=Fserver then begin
   if Fserver.PageControl2.PageCount<=2 then begin
    Gotofirst1.Enabled:=false;
    Gotolast1.Enabled:=false;
   end
   else
   if Fserver.PageControl2.ActivePageIndex<=1 then
    Gotofirst1.Enabled:=false
   else
    Gotolast1.Enabled:=false;
end
else
if pagecontrol1.ActivePageIndex=1 then begin
  n40.Visible:=true;
  jumptodir1.Visible:=true;
  N41.Visible:=false;
  id:=strtoint(getcurrentprofileid);
  Datamodule1.Tprofiles.Locate('ID',id,[]);
  if Datamodule1.Tprofiles.FieldByName('Shared').asboolean=true then
    unshare1.Visible:=true
  else
    share1.Visible:=true;

  sendtorequest1.Visible:=true;
  n45.Visible:=true;

  if (pagecontrol2.ActivePage.ImageIndex<>0) AND (pagecontrol2.ActivePage.ImageIndex<>4) then
    sendtorequest1.Enabled:=true;

  if pagecontrol2.ActivePageIndex<=1 then
    Gotofirst1.Enabled:=False;

  if pagecontrol2.ActivePageIndex=pagecontrol2.PageCount-1 then
    gotolast1.Enabled:=false;
end
else begin

  newtab1.Visible:=true;  //NEW WEB TAB VISIBLE
  n23.Visible:=true;

  if pagecontrol3.ActivePageIndex<=0 then
    Gotofirst1.Enabled:=False;

  if pagecontrol3.ActivePageIndex=pagecontrol3.PageCount-1 then
    gotolast1.Enabled:=false;

end;
end;


procedure TFmain.Dirmaker1Click(Sender: TObject);
begin
Application.CreateForm(TFdirmaker, Fdirmaker);
myshowform(Fdirmaker,true);
Freeandnil(Fdirmaker);
end;

procedure TFmain.TreeView1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin

if treeview1.Selected=nil then   //PAINT FIX
  Windows.SetCursorPos(FDragPoint.x, FDragPoint.y);
end;

procedure TFmain.TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
FDragPoint := Treeview1.ClientToScreen(Point(X, Y)); //PAINT FIX
end;

procedure TFmain.Zip1Password(Sender: TObject; FileName: WideString;
  var NewPassword: String; var SkipFile: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip2Password(Sender: TObject; FileName: WideString;
  var NewPassword: String; var SkipFile: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip2ProcessFileFailure(Sender: TObject;
  FileName: WideString; Operation: TZFProcessOperation; NativeError,
  ErrorCode: Integer; ErrorMessage: WideString; var Action: TZFAction);
begin
makeexception;
end;

procedure TFmain.Zip1ProcessFileFailure(Sender: TObject;
  FileName: WideString; Operation: TZFProcessOperation; NativeError,
  ErrorCode: Integer; ErrorMessage: WideString; var Action: TZFAction);
begin
makeexception;
end;

procedure TFmain.Zip1RequestBlankVolume(Sender: TObject;
  VolumeNumber: Integer; var VolumeFileName: WideString;
  var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip2RequestBlankVolume(Sender: TObject;
  VolumeNumber: Integer; var VolumeFileName: WideString;
  var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip2RequestFirstVolume(Sender: TObject;
  var VolumeFileName: WideString; var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip2RequestLastVolume(Sender: TObject;
  var VolumeFileName: WideString; var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip2RequestMiddleVolume(Sender: TObject;
  VolumeNumber: Integer; var VolumeFileName: WideString;
  var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.closeall1Click(Sender: TObject);
begin
savefocussedcontrol;

deleteallscantabs;

restorefocussedcontrol;
end;

procedure TFmain.PopupMenu7Popup(Sender: TObject);
var
red,green,yellow,grey:integer;
x:integer;
begin
red:=0;
green:=0;
yellow:=0;
grey:=0;

for x:=1 to PageControl2.PageCount-1 do
  case PageControl2.Pages[x].ImageIndex  of
    0:green:=green+1;
    1:yellow:=yellow+1;
    2:red:=red+1;
    3:grey:=grey+1;
    4:green:=green+1;
    5:yellow:=yellow+1;
    6:red:=red+1;
    7:grey:=grey+1;
  end;

Closegreen1.Visible:=true;
Closeyellow1.visible:=true;
Closered1.Visible:=true;
Closegrey1.Visible:=true;

closeall1.Caption:=UTF8Encode(traduction(117));

if green=0 then
  Closegreen1.Visible:=false;

if yellow=0 then
  Closeyellow1.Visible:=false;

if red=0 then
  closered1.Visible:=false;

if grey=0 then
  Closegrey1.Visible:=false;

Closegreen1.Caption:=UTF8Encode(traduction(445))+' ('+inttostr(green)+')';
Closeyellow1.Caption:=UTF8Encode(traduction(446))+' ('+inttostr(yellow)+')';
Closered1.Caption:=UTF8Encode(traduction(447))+' ('+inttostr(red)+')';
Closegrey1.Caption:=UTF8Encode(traduction(448))+' ('+inttostr(grey)+')';
end;

procedure TFmain.Closegreen1Click(Sender: TObject);
begin
deletescantabs(0);
end;

procedure TFmain.Closeyellow1Click(Sender: TObject);
begin
deletescantabs(1);
end;

procedure TFmain.Closered1Click(Sender: TObject);
begin
deletescantabs(2);
end;

procedure TFmain.Closegrey1Click(Sender: TObject);
begin
deletescantabs(3);
end;

procedure TFmain.SpeedButton53Click(Sender: TObject);
begin
wb_navigate(combobox3.Text,false,true);
end;

procedure TFmain.SpeedButton54Click(Sender: TObject);
begin
try
  wb_current.Stop;
except
end;
end;

procedure TFmain.SpeedButton55Click(Sender: TObject);
begin

if Wideuppercase(wb_current.LocationURL)='ABOUT:BLANK' then
  exit;

try
   DeleteIECache(wb_current.LocationURL);
except
end;

wb_current.Refresh;
end;

procedure TFmain.PageControl3Change(Sender: TObject);
begin
try
  if pagecontrol3.PageCount>0 then begin
    wb_current.BringToFront;

    wb_hidenotcurrent;

    wb_updatecontrols(wb_current);
    wb_updateurlbar(wb_current);
  end;
except
end;

end;

procedure TFmain.SpeedButton56Click(Sender: TObject);
begin
wb_current.GoBack;
end;

procedure TFmain.SpeedButton57Click(Sender: TObject);
begin
wb_current.GoForward;
end;

procedure TFmain.SpeedButton58Click(Sender: TObject);
begin
searchingoogle(edit8.text,false,true);
end;

procedure TFmain.SpeedButton60Click(Sender: TObject);
begin
wb_navigate('',true,true);
end;

procedure TFmain.EmbeddedWB1ProgressChange(ASender: TObject; Progress,
  ProgressMax: Integer);
begin
try
  (panel78.FindComponent('P'+TWinControl(asender).name) as TProgressBar).max:=ProgressMax;
  (panel78.FindComponent('P'+TWinControl(asender).name) as TProgressBar).Position:=progress;
except
end;

try //SIZE 0.020
if progressmax=0 then
  (FindComponent('T'+TWinControl(aSender).name) as TTabsheetex).Canstop:=false
else
  (FindComponent('T'+TWinControl(aSender).name) as TTabsheetex).Canstop:=true;
except
end;

wb_updatecontrols(aSender as TEmbeddedWB);
end;

procedure TFmain.SpeedButton52Click(Sender: TObject);
begin
//savefocussedcontrol;
LockWindowUpdate(Handle);
deletecurrentwebtab;
LockWindowUpdate(0);
pagecontrol3.Repaint;
end;

procedure TFmain.SpeedButton59Click(Sender: TObject);
begin
deleteallwebtabs;
end;

procedure TFmain.SpeedButton61Click(Sender: TObject);
begin
wb_current.PrintWithOptions;
end;

procedure TFmain.Print1Click(Sender: TObject);
begin
SpeedButton61Click(sender);
end;

procedure TFmain.Prior1Click(Sender: TObject);
begin
SpeedButton56Click(sender);
end;

procedure TFmain.Next1Click(Sender: TObject);
begin
SpeedButton57Click(sender);
end;

procedure TFmain.Properties2Click(Sender: TObject);
begin
wb_current.ShowPageProperties;
end;

procedure TFmain.PageControl3DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
if (Sender is TTntpagecontrol) then Accept := True;
end;

procedure TFmain.PageControl3DragDrop(Sender, Source: TObject; X,
  Y: Integer);
const
TCM_GETITEMRECT = $130A;
var
TabRect: TRect;
j: Integer;
begin
if (Sender is TTntpagecontrol) then
  for j := 0 to PageControl3.PageCount - 1 do begin
    PageControl3.Perform(TCM_GETITEMRECT, j, LParam(@TabRect)) ;
    if PtInRect(TabRect, Point(X, Y)) then begin

        if j<=j then begin
          PageControl3.ActivePage.PageIndex := j;
        end;

    Exit;
    end;
  end;

end;

procedure TFmain.PageControl3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if button=mbleft then
  PageControl3.BeginDrag(False) ;
end;

procedure TFmain.EmbeddedWB1ShowContextMenu(Sender: TCustomEmbeddedWB;
  const dwID: Cardinal; const ppt: PPoint; const CommandTarget: IInterface;
  const Context: IDispatch; var Result: HRESULT);
begin
Result := S_OK; //don't show WB popup

//dwID
//2=text input box open
//4=No link selected text
//5=Under link
Openinanewtab1.Enabled:=false;
copy1.Enabled:=false;
cut1.Enabled:=false;
paste1.Enabled:=false;

if (dwid=2) then begin
  copy1.enabled:=true;
  cut1.Enabled:=true;
end;

if (dwid=2) AND (Clipboard.HasFormat(CF_TEXT)) then
  paste1.Enabled:=true;

if dwid=4 then
  copy1.enabled:=true;

if (dwid=5) AND (isthisvalidurl(mouselink)=true) then
  Openinanewtab1.Enabled:=true;

Popupmenu8.Popup(ppt.X, ppt.Y);
end;

procedure TFmain.Edit8KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  SpeedButton58Click(sender);  
end;

procedure TFmain.PageControl3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
tabindex: Integer;
begin
tabindex := PageControl3.IndexOfTabAt( X, Y );

if tabindex >= 0 then begin
  PageControl3.Hint:=(pagecontrol3.Pages[tabindex] as TTabSheetEx).Hint;
  currenthint:=PageControl3.Hint;
end;

addclosebuttontab(Fmain,(sender as TPagecontrol),x,y,0);
end;

procedure TFmain.PageControl2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
tabindex: Integer;
begin

tabindex := PageControl2.IndexOfTabAt( X, Y );

if tabindex >= 0 then begin
  PageControl2.Hint:=(PageControl2.Pages[tabindex+1] as TTntTabSheet).hint;
  currenthint:=PageControl2.Hint;
end;


addclosebuttontab(Fmain,(sender as TPagecontrol),x,y,1);

end;

procedure TFmain.EmbeddedWB1NewWindow2(ASender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
cancel:=true;
end;

procedure TFmain.EmbeddedWB1NewWindow3(ASender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool; dwFlags: Cardinal;
  const bstrUrlContext, bstrUrl: WideString);
begin
wb_navigate(bstrUrl,true,true);
end;

procedure TFmain.Selectall4Click(Sender: TObject);
begin
wb_current.SelectAll;
end;

procedure TFmain.Paste1Click(Sender: TObject);
begin
wb_current.Paste;
end;

procedure TFmain.Copy1Click(Sender: TObject);
begin
wb_current.Copy;
end;

procedure TFmain.Cut1Click(Sender: TObject);
begin
wb_current.Cut;
end;

procedure TFmain.PopupMenu8Popup(Sender: TObject);
begin
mouselink:=statuslink;
end;

procedure TFmain.EmbeddedWB1WindowClosing(ASender: TObject;
  IsChildWindow: WordBool; var Cancel: WordBool);
begin
Cancel := True;
(ASender as TEmbeddedWB).GoAboutBlank;
end;

procedure TFmain.EmbeddedWB1StatusTextChange(ASender: TObject;
  const Text: WideString);
begin

if wb_current.name=(Asender as TEmbeddedWB).name then
  statuslink:=text;
end;

procedure TFmain.Openinanewtab1Click(Sender: TObject);
begin
wb_navigate(mouselink,true,true);
end;

procedure TFmain.TrackBar1Change(Sender: TObject);
begin

try
  wb_current.ZoomPercent:=1000-trackbar1.Position;
except
end;

freekeyboardbuffer;
freemousebuffer;
end;

procedure TFmain.Newtab1Click(Sender: TObject);
begin
SpeedButton60Click(sender);
end;

procedure TFmain.SpeedButton62Click(Sender: TObject);
begin
wb_search(wb_current,edit9.text,true);
end;

procedure TFmain.Edit9KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RETURN then
  SpeedButton62Click(sender);
end;

procedure TFmain.Description1Click(Sender: TObject);
begin
mastertable.Locate('ID',detailedit.tag,[]);
searchingoogle('"'+getwiderecord(mastertable.fieldbyname('description'))+'"'+' '+(pagecontrol2.ActivePage as TTnttabsheet).Hint,true,false);
end;

procedure TFmain.Filename1Click(Sender: TObject);
begin
mastertable.Locate('ID',detailedit.tag,[]);
searchingoogle('"'+getwiderecord(mastertable.fieldbyname('gamename'))+'"'+' '+(pagecontrol2.ActivePage as TTnttabsheet).Hint,true,false);
end;

procedure TFmain.Selectall5Click(Sender: TObject);
begin
detaillv.SelectAll(false);

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.Invertselection4Click(Sender: TObject);
begin
detaillv.InvertSelection(false);

freemousebuffer;
freekeyboardbuffer;

end;

procedure TFmain.EditEnter(Sender: TObject);
begin
//SELECT ALL ON ENTER

if (sender is TTntedit) then begin
  PostMessage((sender as TTntedit).Handle, EM_SETSEL, 0, -1);
  (sender as TTntedit).SelectAll;
end
else
if (sender is TTntcombobox) then begin
  PostMessage((sender as TTntcombobox).Handle, EM_SETSEL, 0, -1);
  (sender as TTntcombobox).SelectAll;
end
else
if (sender is TTntrichedit) then begin
  PostMessage((sender as TTntrichedit).Handle, EM_SETSEL, 0, -1);
  (sender as TTntrichedit).SelectAll;
end;

end;

procedure TFmain.PopupMenu9Popup(Sender: TObject);
var
w,rp,sp,cp:widestring;
begin
Fmain.destroycustomhint;
MD51.Enabled:=true;
sha11.Enabled:=true;
CRC321.Enabled:=true;

if detaillv.rootnodecount<>0 then
  Smartsearchingoogle2.enabled:=true
else
  Smartsearchingoogle2.enabled:=false;

PopupMenu11Popup(sender);//Search for files in list

Extractto2.Enabled:=false;
Sendmissingtorequest1.Enabled:=false;

if detaillv.SelectedCount>0 then begin
  if (pagecontrol2.ActivePage.ImageIndex<>0) AND (pagecontrol2.ActivePage.ImageIndex<>4) then
    if (FindComponent('CLONE_Panel19_'+getcurrentprofileid) as TTntpanel).Caption<>'0000' then
      Sendmissingtorequest1.Enabled:=true;

  //0.046
  rp:=getromspathofid(strtoint(getcurrentprofileid));
  sp:=getsamplespathofid(strtoint(getcurrentprofileid));
  cp:=getchdspathofid(strtoint(getcurrentprofileid));

  if (WideDirectoryexists(rp)) OR (WideDirectoryexists(sp)) OR (WideDirectoryexists(cp)) then
    Extractto2.Enabled:=true;
end;

//KNOW IF INFO IS AVAILABLE
detailtable.Locate('Romname;Setname',VarArrayOf([detailedit.text, detailedit.tag]),[]);

if detailtable.fieldbyname('CRC').asstring='' then
  CRC321.Enabled:=false;
if detailtable.fieldbyname('MD5').asstring='' then
  MD51.Enabled:=false;
if detailtable.fieldbyname('SHA1').asstring='' then
  SHA11.Enabled:=false;

if (offinfotable<>nil)  then begin
  MD51.Enabled:=false;
  sha11.Enabled:=false;
end;

//0.043
w:=getnodetextundermouse(detaillv);
Fakeedit.Text:=w;
if w<>'' then begin
  Copytoclipboard1.Enabled:=true;
  copy6.caption:=UTF8Encode(changein(w,'&','&&'));
end
else begin
  Copytoclipboard1.Enabled:=false;

end;

end;

procedure TFmain.Filename2Click(Sender: TObject);
var
aux:widestring;
begin
aux:=gettoken(detailedit.Text,'\',gettokencount(detailedit.text,'\')); //REMOVE POSSIBLE FOLDERS

searchingoogle('"'+aux+'"'+' '+(pagecontrol2.ActivePage as Ttnttabsheet).Hint,true,false);
end;

procedure TFmain.PopupMenu10Popup(Sender: TObject);
begin

try
if FindVCLWindow(Mouse.CursorPos) is TTntComboBox then //FIX FORZE ONENTER EVENT
  stablishfocus(FindVCLWindow(Mouse.CursorPos));
except
end;

checkeditpopup;
end;

procedure TFmain.Paste2Click(Sender: TObject);
var
len:integer;
w:widestring;
begin
if Focussededit<>nil then
  Focussededit.Perform(WM_PASTE,0,0)
else
if Focussedcombo<>nil then
  Focussedcombo.Perform(WM_PASTE,0,0)
else
if Focussedrich<>nil then
  Focussedrich.Perform(WM_PASTE,0,0)
else
if Focussedtntrich<>nil then begin
  //Focussedtntrich.Perform(WM_PASTE,0,0);
  w:=TntClipboard.AsWideText;
  len:=length(Focussedtntrich.Text)-Focussedtntrich.SelLength;
  w:=copy(w,1,Focussedtntrich.MaxLength-len);
  if len=Focussedtntrich.MaxLength then
    beep
  else
    Focussedtntrich.seltext:=w;
end;

end;

procedure TFmain.Selectall6Click(Sender: TObject);
begin
if Focussededit<>nil then
  Focussededit.SelectAll
else
if Focussedcombo<>nil then
  Focussedcombo.SelectAll
else
if Focussedrich<>nil then
  Focussedrich.SelectAll
else
if Focussedtntrich<>nil then
  Focussedtntrich.SelectAll;
end;

procedure TFmain.Cut2Click(Sender: TObject);
begin
if Focussededit<>nil then
  Focussededit.Perform(WM_CUT,0,0)
else
if Focussedcombo<>nil then
  Focussedcombo.Perform(WM_CUT,0,0)
else
if Focussedrich<>nil then
  Focussedrich.Perform(WM_CUT,0,0)
else
if Focussedtntrich<>nil then
  Focussedtntrich.Perform(WM_CUT,0,0);


end;

procedure TFmain.Copy2Click(Sender: TObject);
begin
if Focussededit<>nil then
  Focussededit.Perform(WM_COPY,0,0)
else
if Focussedcombo<>nil then
  Focussedcombo.Perform(WM_COPY,0,0)
else
if Focussedrich<>nil then
  Focussedrich.Perform(WM_COPY,0,0)
else
if Focussedtntrich<>nil then
  Focussedtntrich.Perform(WM_COPY,0,0);
end;

procedure TFmain.SpeedButton63Click(Sender: TObject);
begin
Application.CreateForm(TFfilter, Ffilter);
myshowform(Ffilter,true);
Freeandnil(Ffilter);
end;

procedure TFmain.SpeedButton64Click(Sender: TObject);
begin
wb_search(wb_current,edit9.text,false);
end;

procedure TFmain.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
activateform : Twincontrol;
CurControl: TControl;
P: TPoint;
begin
activateform:=nil;
flashstop;

if msg.message=164 then begin //NO MENUS ON SCROLLBARS
  handled:=true;
  SetForegroundWindow(screen.ActiveForm.Handle);
  exit;
end;

try
  activateform:=screen.ActiveForm;
  GetCursorPos(P);
  CurControl := FindDragTarget(P, True);

  if CurControl<>nil then begin
    //CLOSE BUTTON FOR TABS
    if Curcontrol is TPagecontrol then begin

    end
    else
    if curcontrol.Name<>'StaticText1' then
      statictext1.visible:=false;

    if CurControl is TTntSpeedButton then begin //FIX SPEEDBUTTON HINTS
      if (CurControl as TTntSpeedButton).showhint=true then
        currenthint:=(CurControl as TTntSpeedButton).hint;
    end
    else
    if curcontrol is TEmbeddedWB then begin //MIDDLE BUTTON ON WEB NAVIGATOR
      if msg.message=WM_MBUTTONDOWN then
        if isthisvalidurl(statuslink) OR (isthisvalidurlfile(statuslink)) then begin
          handled:=true;
          wb_navigate(statuslink,true,true);
        end;
    end
    else
    if CurControl is TTntTreeView then //RELEASE TREE HINT VAR
      flashstop
    else
      lasttreenode:=nil;

  end;

except
end;

//RETURN TO STAYONTOP OF FMAIN ONLY WHEN NO MORE MODAL WINDOWS
try
  if GetFormsCount=2 then begin
    if Stayontop1.Tag=1 then begin
      Stayontop1.Tag:=0;
      setstayontop;
    end
    else
    if Staynormal1.Tag=1 then begin
      staynormal1.Tag:=0;
      Staynormal1Click(nil);
    end;
    //RARE BUG FIX NOT DISSAPEAR LOG WINDOW
    ShowWindow(Flog.Handle,SW_HIDE);//Hide command dont work showwindow yes
  end;
except
end;

end;

procedure TFmain.SpeedButton65Click(Sender: TObject);
var
p:TPoint;
begin
//if SpeedButton65.Down then begin

  GetCursorPos(p);
  PopupMenu11.Popup(p.X,p.Y);
//  application.processmessages;
//  SpeedButton65.Down := False;

//end;

end;



procedure TFmain.PopupMenu11Popup(Sender: TObject);
begin
setfilescanselection(detailedit.tag);
end;

procedure TFmain.Romspath1Click(Sender: TObject);
var
path:widestring;
begin
path:=getromspathofid(strtoint(getcurrentprofileid));
path:=GetShortFileName(path); //LONGPATH FIX 0.046

if WideDirectoryexists(path) then
  ShellExecutew(self.WindowHandle,'open',pwidechar(path),nil,nil, SW_SHOWNORMAL);
end;

procedure TFmain.Samplespath1Click(Sender: TObject);
var
path:widestring;
begin
path:=getsamplespathofid(strtoint(getcurrentprofileid));
path:=GetShortFileName(path); //LONGPATH FIX 0.046

if WideDirectoryexists(path) then
  ShellExecutew(self.WindowHandle,'open',pwidechar(path),nil,nil, SW_SHOWNORMAL);
end;

procedure TFmain.Chdspath1Click(Sender: TObject);
var
path:widestring;
begin
path:=getchdspathofid(strtoint(getcurrentprofileid));
path:=GetShortFileName(path); //LONGPATH FIX 0.046

if WideDirectoryexists(path) then
  ShellExecutew(self.WindowHandle,'open',pwidechar(path),nil,nil, SW_SHOWNORMAL);
end;

procedure TFmain.ROM1Click(Sender: TObject);
begin
openandselectinbrowser(scanprofileid);
end;

procedure TFmain.SAMPLE1Click(Sender: TObject);
begin
openandselectinbrowser(scanpath);
end;

procedure TFmain.CHD1Click(Sender: TObject);
begin
openandselectinbrowser(currentset);
end;

procedure TFmain.Directory1Click(Sender: TObject);
var
path:widestring;
begin
path:=folderdialoginitialdircheck(initialdirextract);

positiondialogstart;

if WideSelectDirectory(traduction(483)+' :','',path) then begin
  path:=checkpathbar(path);
  initialdirextract:=path;
  extractselection(true,false,path);
end;

end;

procedure TFmain.Desktop1Click(Sender: TObject);
begin
extractselection(true,false,checkpathbar(GetDesktopFolder));
end;

procedure TFmain.Desktop2Click(Sender: TObject);
begin
extractselection(false,false,checkpathbar(GetDesktopFolder));
end;

procedure TFmain.Directory2Click(Sender: TObject);
var
path:widestring;
begin
path:=folderdialoginitialdircheck(initialdirextract);

positiondialogstart;

if wideselectdirectory(traduction(483)+' :','',path) then begin
  path:=checkpathbar(path);
  initialdirextract:=path;
  extractselection(false,false,path);
end;
end;

procedure TFmain.SpeedButton66Click(Sender: TObject);
var
imgid:integer;
ico:Ticon;
begin
Application.CreateForm(TFfavorites, Ffavorites);
ico:=TIcon.Create;

//SEND INFO
Ffavorites.Edit1.Text:=(PageControl3.ActivePage as TTabsheetex).hint;
Ffavorites.Edit2.Text:=wb_current.LocationURL;

imgid:=PageControl3.ActivePage.ImageIndex;
if (imgid=1) OR (imgid=-1) then
  imgid:=0;

ImageList7.GetIcon(imgid,ico);
Ffavorites.Image322.Bitmap.assign(ico);

ico.free;

if createorloadurllist=true then//FIX
  myshowform(Ffavorites,true);

Freeandnil(Ffavorites);
end;

procedure TFmain.ComboBox3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key = $08) AND (combobox3.Text<>'') then //BACKSPACE
  combobox3.tag:=1
else
if key=VK_RETURN then begin
  SendMessage(ComboBox3.Handle, CB_SHOWDROPDOWN, 0, 0);
  ComboBox3.SelectAll;
  SpeedButton53Click(sender);
end;

end;

procedure TFmain.ComboBox3Change(Sender: TObject);
var
Srch,recordurl: widestring;
ix,x: Integer;
sels:integer;
begin
if (combobox3.tag=1) OR (combobox3.Text='') then begin
  combobox3.tag:=0;
  Exit;
end;

ix:=-1;

Srch := combobox3.Text;

sels:=combobox3.SelStart;

if (sels=length(combobox3.text)) then //AT END
  if length(combobox3.text)>1 then //NOT START
    if combobox3.Items.Count=0 then //NO OLD FOUND ENTRIES
      exit;

LockWindowUpdate(combobox3.Handle);

combobox3.tag := 0;
combobox3.items.clear;

//LAUNCH SQL
//SELECT * FROM History WHERE Upper(URL) LIKE Upper(Srch%) ORDER BY URL;
//LATER MOVE WITH RESULT MAX 100
try
  if Datamodule1.DBUrls.Connected=true  then begin

    Datamodule1.Qurls.close;
    Datamodule1.Qurls.SQL.Clear;

    Datamodule1.Qurls.SQL.Add('SELECT TOP 10 * FROM History WHERE Upper(URL) LIKE Upper('+':p_'+') ORDER BY URL');

    Datamodule1.Qurls.Params.Clear;
    Datamodule1.Qurls.Params.CreateParam(ftWideString,'p_',ptResult);

    Datamodule1.Qurls.Params[0].DataType := ftWideString;
    Datamodule1.Qurls.Params[0].Value:=Srch+'%';

    Datamodule1.Qurls.Open;

    for x:=0 to Datamodule1.Qurls.RecordCount-1 do begin

      recordurl:=getwiderecord(Datamodule1.Qurls.fieldbyname('Url'));;

      if length(srch)<=length(recordurl) then begin
        combobox3.items.add(srch+copy(recordurl,length(srch)+1,length(recordurl)));
        if ix=-1 then //ALWAIS FIRST FOUND ALPHABETICAL ORDERED
          ix:=combobox3.Items.Count-1;
      end;

      Datamodule1.Qurls.next;
    end;
    
  end;
except
end;

if ix<>-1 then begin
  if SendMessage(ComboBox3.Handle, CB_GETDROPPEDSTATE, 0, 0) <> 1 then
    SendMessage(ComboBox3.Handle, CB_SHOWDROPDOWN, 1, 0);

  combobox3.itemindex:=ix;
  combobox3.SelStart  := Length(Srch);
  combobox3.SelLength := (Length(combobox3.Text) - Length(Srch));

end
else begin
  ComboBox3.SelStart:=sels;
  SendMessage(ComboBox3.Handle, CB_SHOWDROPDOWN, 0, 0)
end;

//RESHOW CURSOR
sendmessage(combobox3.handle, WM_SETCURSOR, 0, 0);

LockWindowUpdate(0);
combobox3.Repaint;
end;

procedure TFmain.ComboBox3Select(Sender: TObject);
begin
try
combobox3.tag:=1;//FIX
except
end;
end;

procedure TFmain.ComboBox3Exit(Sender: TObject);
begin
SendMessage(ComboBox3.Handle, CB_SHOWDROPDOWN, 0, 0);
end;

procedure TFmain.EditChange(Sender: TObject);
begin
//RESHOW CURSOR
sendmessage(combobox3.handle, WM_SETCURSOR, 0, 0);
end;

procedure TFmain.Activaterecursive1Click(Sender: TObject);
begin
if (treeview1.Selected<>treeview1.Items.Item[1]) AND (treeview1.Selected<>treeview1.Items.Item[0]) then
  showprofiles(true);
end;

function ActiveCaption: string;
var
  Handle: THandle;
  Len: LongInt;
  Title: string;
begin
  Result := '';
  Handle := GetForegroundWindow;
  if (Handle <> 0) then
  begin
    Len := GetWindowTextLength(Handle) + 1;
    SetLength(Title, Len);
    GetWindowText(Handle, PChar(Title), Len);
    ActiveCaption := TrimRight(Title);
  end;
end;

procedure TFmain.CoolTrayIcon1DblClick(Sender: TObject);
var
x:integer;
b:boolean;
begin
x:=0;
b:=false;

if CoolTrayIcon1.Tag=0 then begin //HIDE

  isfiledialog:=false;

  EnumWindows(@EnumWindowsProc2, LPARAM(x));//DETECT EXISTING OPENEND DIALOGS

  if (isfiledialog=true) then begin
    Application.BringToFront;
    EnumWindows(@EnumWindowsProc3, LPARAM(x));//DETECT EXISTING OPENEND DIALOGS AND SET TO FRONT
    beep;
    exit;
  end;


  Cooltrayicon1.Tag:=2;

  Application.BringToFront;

  CoolTrayIcon1.HideMainForm;
  cooltrayicon1.HideTaskbarIcon;

  for x:=0 to Application.ComponentCount-1 do
    if Application.Components[x] is Tform then begin//HIDE ACTIVE ONSHOW FORMS

      if activeformlist.IndexOf((Application.Components[x] as Tform).name)<>-1 then begin
        ShowWindow((Application.Components[x] as Tform).Handle, SW_HIDE);
      end;

    end;

  Cooltrayicon1.Tag:=1;

end
else begin
  Cooltrayicon1.Tag:=2;

  cooltrayicon1.HideBalloonHint;
  cooltrayicon1.ShowMainForm;
  Fmain.Repaint;//REFRESH EFFECT

  for x:=0 to Application.ComponentCount-1 do
    if Application.Components[x] is Tform then //SHOW ACTIVE ONSHOW FORMS
      if activeformlist.IndexOf((Application.Components[x] as Tform).name)<>-1 then begin
        (Application.Components[x] as Tform).AlphaBlend:=false;
        ShowWindow((Application.Components[x] as Tform).Handle, SW_SHOW);
        try
        //  (Application.Components[x] as Tform).Visible:=true;
        except
        end;
        (Application.Components[x] as Tform).BringToFront;
        (Application.Components[x] as Tform).Repaint;
      end;

  if Fserver.Visible=true then
    b:=true;

  if b=true then //FIX TASKBAR BUTTON FIRST AS COMMUNITY
    ShowWindow(Fserver.Handle, SW_HIDE);

  Cooltrayicon1.ShowTaskbarIcon;

  if b=true then //FIX TASKBAR BUTTON FIRST AS COMMUNITY
    ShowWindow(Fserver.Handle, SW_SHOW);

  Cooltrayicon1.Tag:=0;
end;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFmain.PopupMenu3Popup(Sender: TObject);
begin

if GetFormsCount=2 then
  hide1.Enabled:=true
else
  hide1.Enabled:=false;

end;

procedure TFmain.CoolTrayIcon1BalloonHintClick(Sender: TObject);
begin
if CoolTrayIcon1.Tag=1 then
   CoolTrayIcon1DblClick(sender);
end;


procedure TFmain.CRC321Click(Sender: TObject);
var
aux:ansistring;
begin
detailtable.Locate('Romname;Setname',VarArrayOf([edit2.text, detailedit.tag]),[]);
aux:=detailtable.fieldbyname('CRC').asstring;
searchingoogle('"'+aux+'"',true,false);
end;

procedure TFmain.MD51Click(Sender: TObject);
var
aux:ansistring;
begin
detailtable.Locate('Romname;Setname',VarArrayOf([edit2.text, detailedit.tag]),[]);
aux:=detailtable.fieldbyname('MD5').asstring;
searchingoogle('"'+aux+'"',true,false);
end;

procedure TFmain.SHA11Click(Sender: TObject);
var
aux:ansistring;
begin
detailtable.Locate('Romname;Setname',VarArrayOf([edit2.text, detailedit.tag]),[]);
aux:=detailtable.fieldbyname('SHA1').asstring;
searchingoogle('"'+aux+'"',true,false);
end;

procedure TFmain.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
//MUST DISSABLE EXCEPTIONS NOT CAPTURED WITH EUREKALOG
end;

procedure TFmain.Jumptoprofiledirectory1Click(Sender: TObject);
var
n:TTnttreenode;
id:longint;
begin
Datamodule1.Tprofilesview.Locate('CONT',VirtualStringTree2.FocusedNode.Index+1,[]);
id:=Datamodule1.Tprofilesview.fieldbyname('ID').asinteger;
//InTprofilesview no path exists

n:=nodepathexists(treeview1,getwiderecord(Datamodule1.Tprofilesview.fieldbyname('Path')));

if n<>nil then
  n.Selected:=true
else
  if getwiderecord(Datamodule1.Tprofilesview.fieldbyname('Path'))='\' then//DEFAULT
    treeview1.Items.Item[1].Selected:=true;

try
  if Datamodule1.Tprofilesview.Locate('ID',id,[])=true then begin
    VirtualStringTree2.ClearSelection;
    Datamodule1.Tprofilesview.Locate('ID',id,[]);
    posintoindex(datamodule1.tprofilesview.fieldbyname('CONT').AsInteger-1,VirtualStringTree2);
  end;
except
end;

end;

procedure TFmain.friendfix1Click(Sender: TObject);
begin
createffix(true);
end;

procedure TFmain.Shareselected1Click(Sender: TObject);
begin
shareselection(true);
end;

procedure TFmain.Unshareselected1Click(Sender: TObject);
begin
shareselection(false);
end;

procedure TFmain.Community2Click(Sender: TObject);
begin
showfserver;
end;

procedure TFmain.ApplicationEvents1Restore(Sender: TObject);
var
x:integer;
logactive:boolean;
begin
///FIX FOR MODAL FORMS
logactive:=false;
try
  if isaformactive('Flog')=true then
    logactive:=true;
except
end;

//BUG
for x:=0 to Application.ComponentCount-1 do
  if Application.Components[x] is Tform then //SHOW ACTIVE ONSHOW FORMS
    if activeformlist.IndexOf((Application.Components[x] as Tform).name)<>-1 then begin
      (Application.Components[x] as Tform).BringToFront;
      (Application.Components[x] as Tform).Repaint;
    end;



try
  if (logactive=true) AND (Flog.Visible=true) then
    Flog.BringToFront;
except
end;

end;

procedure TFmain.Sendmissingtorequestlist1Click(Sender: TObject);
begin
missingtorequest(0);
end;

procedure TFmain.EurekaLog1ExceptionActionNotify(
  EurekaExceptionRecord: TEurekaExceptionRecord;
  EurekaAction: TEurekaActionType; var Execute: Boolean);
var
f:TGpTextFile;
begin

  execute:=false;//SILENT EXCEPTION SET TO FALSE

  try
    f:=TGpTextFile.CreateW(checkpathbar(WideExtractFilePath(TntApplication.ExeName))+'error.log');
    f.Rewrite;                                  //Remove Eurekalog text
    f.Writeln(copy(EurekaExceptionRecord.LogText,19,length(EurekaExceptionRecord.LogText)));
    f.Close;
  finally
    FreeAndNil(f);
  end;
  
end;

procedure TFmain.share1Click(Sender: TObject);
begin
tabprofilesharing(true);
end;

procedure TFmain.unshare1Click(Sender: TObject);
begin
tabprofilesharing(false);
end;

procedure TFmain.jumptodir1Click(Sender: TObject);
var
n:TTnttreenode;
id:ansistring;
begin
id:=getcurrentprofileid;

pagecontrol1.ActivePageIndex:=0;

Datamodule1.Tprofiles.Locate('ID',id,[]);
Datamodule1.TTree.Locate('ID',Datamodule1.Tprofiles.fieldbyname('Tree').AsInteger,[]);

n:=nodepathexists(treeview1,getwiderecord(Datamodule1.TTree.fieldbyname('Path')));

if n<>nil then
  n.Selected:=true
else
  if getwiderecord(Datamodule1.Ttree.fieldbyname('Path'))='\' then//DEFAULT
    treeview1.Items.Item[1].Selected:=true;

try
  if Datamodule1.Tprofilesview.Locate('ID',id,[])=true then begin
    VirtualStringTree2.ClearSelection;
    Datamodule1.Tprofilesview.Locate('ID',id,[]);
    posintoindex(datamodule1.tprofilesview.recno-1,VirtualStringTree2);
    stablishfocus(VirtualStringTree2);
  end;
except
end;
end;

procedure TFmain.fspTaskbarPreviews1NeedIconicBitmap(Sender: TObject;
  Width, Height: Integer; var Bitmap: HBITMAP);
begin
Image325.Bitmap.ResamplerClassName:='TLinearResampler';
Bitmap := fspControl2DIBPreview(panel80, panel80.ClientRect, Width, height);
end;

procedure TFmain.fspTaskbarMgr1ThumbButtonClick(Sender: TObject;
  ButtonId: Integer);
begin
case buttonid of
  0:begin
    showfserver;
    //PostMessage(Fserver.handle,WM_LBUTTONDOWN ,0,0);
    //PostMessage(Fserver.handle,WM_LBUTTONUP ,0,0);
  end;
end;
end;

procedure TFmain.SpeedButton67Click(Sender: TObject);
var
p:Tpoint;
begin
//if SpeedButton67.Down then begin
  GetCursorPos(p);
  PopupMenu12.Popup(p.X,p.Y);
//  application.processmessages;
//  SpeedButton67.Down := False;
//end;

end;

procedure TFmain.Setfilters1Click(Sender: TObject);
begin
Application.CreateForm(TFofflinefilters, Fofflinefilters);
myshowform(Fofflinefilters,true);
Freeandnil(Fofflinefilters);
end;

procedure TFmain.PopupMenu12Popup(Sender: TObject);
begin
Applyfilters1.Enabled:=false;
Removefilters1.Enabled:=false;

if mastertable.Filtered=true then
  Removefilters1.Enabled:=true
else
if getpanelfilter.Caption<>'' then
  Applyfilters1.enabled:=true;

end;

procedure TFmain.Removefilters1Click(Sender: TObject);
begin
applyfilterlaststep(false);
end;

procedure TFmain.Applyfilters1Click(Sender: TObject);
begin
applyfilterlaststep(true);
end;

procedure TFmain.PageControl2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if button=mbright then
  TabMenuPopup(PageControl2, X, Y);
end;

procedure TFmain.PageControl3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if button=mbright then
  TabMenuPopup(PageControl3, X, Y);
end;

procedure TFmain.Sendtorequests1Click(Sender: TObject);
begin
missingtorequest(1);
end;

procedure TFmain.Sendmissingtorequest1Click(Sender: TObject);
begin
missingtorequest(2);
end;

procedure TFmain.sendtorequest1Click(Sender: TObject);
begin
missingtorequest(3);
end;

function TFmain.EmbeddedWB1ZoomPercentChange(Sender: TCustomEmbeddedWB;
  const ulZoomPercent: Cardinal): HRESULT;
begin
if (sender as TEmbeddedWB)=wb_current then
  wb_zoomtotrackbar(ulzoompercent);

end;

procedure TFmain.SpeedButton71Click(Sender: TObject);
begin
wb_current.ZoomPercent:=100;
end;

procedure TFmain.backuppath1Click(Sender: TObject);
var
path:widestring;
begin
path:=getbackuppathofid(strtoint(getcurrentprofileid));
path:=GetShortFileName(path); //LONGPATH FIX 0.046

if WideDirectoryexists(path) then
  ShellExecutew(self.WindowHandle,'open',pwidechar(path),nil,nil, SW_SHOWNORMAL);
end;

procedure TFmain.activate1Click(Sender: TObject);
begin
selectedprofilestobool('MD5',true);
end;

procedure TFmain.deactivate1Click(Sender: TObject);
begin
selectedprofilestobool('MD5',false);
end;

procedure TFmain.activate2Click(Sender: TObject);
begin
selectedprofilestobool('SHA1',true);
end;

procedure TFmain.deactivate2Click(Sender: TObject);
begin
selectedprofilestobool('SHA1',false);
end;

procedure TFmain.activate3Click(Sender: TObject);
begin
selectedprofilestobool('TZ',true);
end;

procedure TFmain.deactivate3Click(Sender: TObject);
begin
selectedprofilestobool('TZ',false);
end;

procedure TFmain.activate4Click(Sender: TObject);
begin
selectedprofilestobool('T7Z',true);
end;

procedure TFmain.deactivate4Click(Sender: TObject);
begin
selectedprofilestobool('T7Z',false);
end;

procedure TFmain.setbackupfolder1Click(Sender: TObject);
begin
selectedprofilestobackup;
end;


procedure TFmain.RichEditURL1MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
if MouseButtonIsDown(mbleft) then
  handled:=true;
end;

procedure TFmain.SevenZip2Listfile(Sender: TObject; Filename: WideString;
  Fileindex, FileSizeU, FileSizeP, Fileattr, Filecrc: Int64;
  Filemethod: WideString; FileTime: Double);
var
fil,aux2:widestring;
i,x:integer;
begin

if gettokencount(filemethod,'06F10701')>1 then //PASSWORD
  SevenZip2.Tag:=1;
                                            //EXCEPTION
if fileattr = fadirectory then begin
  fil:=changein(Filename+'\','/','\');
  if stcompfiles2.IndexOf(fil)=-1 then begin //0.034 FIX
    stcompcrcs2.add('00000000');
    stcompsizes2.Add('0');
  end
  else
    exit;
end
else begin
  fil:=changein(Filename,'/','\');
  //stcompcrcs2.add(inttohex(Filecrc,8));
  if FileSizeU<>0 then
    stcompcrcs2.add(hextl(filecrc))//INTTOHEX DONT WORKS FINE
  else
    stcompcrcs2.add('00000000');
    
  stcompsizes2.Add(currtostr(FileSizeU));
end;

//0.028 SPEEDUP SORTING AND FINDING METHOD
stcompfiles2.Add(fil);
i:=stcompfiles2.IndexOf(fil);
stcompcrcs2.Move(stcompcrcs2.Count-1,i);
stcompsizes2.Move(stcompsizes2.Count-1,i);

//Folder fix problem 0.032
aux2:='';
i:=GetTokenCount(fil,'\');

if i>1 then
  for x:=1 to i-1 do begin

    aux2:=aux2+gettoken(fil,'\',x)+'\';
    i:=stcompfiles2.IndexOf(aux2);

    if i=-1 then begin //DOES NOT EXISTS ADD IT
      stcompfiles2.Add(aux2);
      stcompcrcs2.add('00000000');
      stcompsizes2.Add('0');
      i:=stcompfiles2.IndexOf(aux2);//REORDER
      stcompcrcs2.Move(stcompcrcs2.Count-1,i);
      stcompsizes2.Move(stcompsizes2.Count-1,i);
    end;
  end;
end;

procedure TFmain.ComboBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
(control as TTntComboBox).canvas.fillrect(rect);

//imagelist3.Draw((control as TTntComboBox).Canvas,rect.left,rect.top,0);//Get index
WideCanvasTextOut((control as TTntComboBox).canvas,rect.left+2,rect.top+1,(control as TTntComboBox).Items.Strings[index]);

if odfocused in state then  //DISABLE FOCUS DOTTED
  (control as TTntComboBox).canvas.DrawFocusRect(rect);

end;

procedure TFmain.Zip1FileProgress(Sender: TObject; FileName: WideString;
  Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
if onathread=false then
  Application.ProcessMessages;
end;

procedure TFmain.VirtualStringTree2GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
shareint:integer;
haveroms,totalroms:ansistring;
begin

if column=0 then begin

  if Datamodule1.Tprofilesview.Fields[0].AsInteger<>node.Index+1 then //SPEEDUP
    Datamodule1.Tprofilesview.Locate('CONT',node.Index+1,[]);

  if Kind=ikState then begin

    shareint:=0;

    haveroms:=pointdelimiters(Datamodule1.Tprofilesview.fields[5].asinteger);//Havesets
    totalroms:=pointdelimiters(Datamodule1.Tprofilesview.fields[15].asinteger);

    if Datamodule1.Tprofilesview.fields[19].asboolean=true then
      shareint:=4;

    if Datamodule1.Tprofilesview.fields[5].asstring='' then begin
      ImageIndex:=3+shareint;
    end
    else
    if Datamodule1.Tprofilesview.fields[5].asstring='0' then begin
      ImageIndex:=2+shareint;
    end
    else
    if haveroms=totalroms then
      ImageIndex:=0+shareint//0
    else
      ImageIndex:=1+shareint;

  end
  else
  if kind<>ikOverlay then begin //OK
    ImageIndex:=getdattypeiconindexfromchar(Datamodule1.Tprofilesview.fields[17].asstring);
  end;

end;

end;

procedure TFmain.VirtualStringTree2GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
haveroms,havesets,totalroms,totalsets:ansistring;
begin

if Datamodule1.Tprofilesview.Fields[0].AsInteger<>node.Index+1 then //SPEEDUP
  Datamodule1.Tprofilesview.Locate('CONT',node.Index+1,[]);

case column of
  0:celltext:=getwiderecord(Datamodule1.Tprofilesview.Fields[2]);//Description
  1:celltext:=getwiderecord(Datamodule1.Tprofilesview.fields[6]);//Version
  2..3:begin
        haveroms:=pointdelimiters(Datamodule1.Tprofilesview.fields[5].asinteger);//Havesets
        havesets:=pointdelimiters(Datamodule1.Tprofilesview.fields[4].asinteger);//Haveroms
        totalroms:=pointdelimiters(Datamodule1.Tprofilesview.fields[15].asinteger);
        totalsets:=pointdelimiters(Datamodule1.Tprofilesview.fields[14].asinteger);

        if Datamodule1.Tprofilesview.fields[5].asstring='' then begin
          havesets:=' - ';
          haveroms:=' - ';
        end;

        if column=2 then
          celltext:=havesets+' / '+totalsets
        else
          celltext:=haveroms+' / '+totalroms;
      end;
  4:celltext:=splitmergestring(Datamodule1.Tprofilesview.fields[7].AsInteger);//Filemode
  5:begin
      if Datamodule1.Tprofilesview.fields[19].asboolean=true then //Shared
        celltext:='X'
      else
        celltext:='';
    end;
  6:celltext:=Datamodule1.Tprofilesview.fields[16].asstring;//Added
  7:begin
      haveroms:=Datamodule1.Tprofilesview.fields[11].asstring;//LAST SCAN
      if Length(haveroms)<=12 then
        celltext:=''
      else
        celltext:=haveroms;
  end;
  8:celltext:=getwiderecord(Datamodule1.Tprofilesview.fields[3]);
  9:celltext:=getwiderecord(Datamodule1.Tprofilesview.fields[20]);
end;

showprofilesselected;
end;

procedure TFmain.VirtualStringTree2Resize(Sender: TObject);
begin
CenterInClient(panel32,panel20);
end;

procedure TFmain.VirtualStringTree2DblClick(Sender: TObject);
begin
if updatinglist=false then
  Loadselectedprofiles1Click(sender);
end;

procedure TFmain.VirtualStringTree2HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
if HitInfo.Button<>mbLeft then
  exit;

if updatinglist=true then
  exit;
  
if HitInfo.Column=-1 then //BUGFIX
  exit;

updatinglist:=true;

//RARE BUT FIX A PROBLEM SELECTED COLUMN PRESSED
SendMessage(VirtualStringTree2.Handle, WM_LBUTTONUP, 0, 0);

sortcolumn(VirtualStringTree2,Hitinfo.Column);

if virtualstringtree2.RootNodeCount>1 then //0.034
  showprofiles(true);

updatinglist:=false;
//VirtualStringTree2.Invalidate; //FULL REPAINT???
end;

procedure TFmain.VirtualStringTree1Click(Sender: TObject);
begin
//FIX CLICK WRONG IMAGE
loadimages;
end;

procedure TFmain.VirtualStringTree1Resize(Sender: TObject);
begin
try
  CenterInClient(panel25,masterlv);
except
end;
end;

procedure TFmain.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin

if mastertable.Fields[0].AsInteger<>node.Index+1 then //SPEEDUP
  mastertable.Locate('CONT',node.Index+1,[]);

if (VirtualStringTree1.Selected[node]=true) and (masterlv.SelectedCount=1) then

  if (detailedit.Tag<>mastertable.fieldbyname('ID').asinteger) then begin

    masteredit.Text:=getwiderecord(mastertable.fieldbyname('Description'));
    detailedit.Tag:=mastertable.fieldbyname('ID').asinteger;

    detaillv.RootNodeCount:=0;

    if (visiblehave=true) OR (visiblemiss=true) then begin

      if (visiblehave=true) and (visiblemiss=true) then
        detaillv.RootNodeCount:=mastertable.fieldbyname('total_').asinteger
      else
      if visiblehave=true then
        detaillv.RootNodeCount:=mastertable.fieldbyname('have_').asinteger
      else
        detaillv.RootNodeCount:=mastertable.fieldbyname('total_').asinteger-mastertable.fieldbyname('have_').asinteger;

      posintoindexbynode(detaillv.getfirst,detaillv);
      detaillv.Repaint;
    end;

    detailhave.Caption:=fillwithzeroes(mastertable.fieldbyname('Have_').asstring,4);

    detailmiss.Caption:=fillwithzeroes(inttostr(mastertable.fieldbyname('Total_').asinteger-mastertable.fieldbyname('Have_').asinteger),4);

    detailtotal.Caption:=traduction(24)+' '+fillwithzeroes(inttostr(detaillv.rootnodecount),4)+' '+'/'+' '+fillwithzeroes(mastertable.fieldbyname('total_').asstring,4);

    loadimages;

    masteredit.Repaint;
    detailhave.Repaint;
    detailmiss.Repaint;
    detailtotal.Repaint;
  end;

case column of
  0:celltext:=getwiderecord(mastertable.fieldbyname('Description'));
  1:celltext:=getwiderecord(mastertable.fieldbyname('Gamename'));
  2:celltext:=pointdelimiters(mastertable.fieldbyname('Have_').asinteger)+' / '+pointdelimiters(mastertable.fieldbyname('Total_').asinteger);
  3:begin
    if showasbytes=false then
      celltext:=bytestostr(mastertable.fieldbyname('Size_').ascurrency)
    else
      celltext:=pointdelimiters(mastertable.fieldbyname('Size_').ascurrency)+' bytes';
  end;
  4:begin
    if offinfotable<>nil then
      celltext:=getwiderecord(mastertable.fieldbyname('Language'))
    else
      if (getwiderecord(mastertable.fieldbyname('Master'))=getwiderecord(mastertable.fieldbyname('Description'))) OR (mastertable.fieldbyname('Master').asstring='') then begin
        celltext:=''
      end
      else
        celltext:=getwiderecord(mastertable.fieldbyname('Master'));
    end;
  5:celltext:=getwiderecord(mastertable.fieldbyname('Publisher'));
  6:celltext:=getwiderecord(mastertable.fieldbyname('Savetype'));
  7:celltext:=getwiderecord(mastertable.fieldbyname('Sourcerom'));
  8:celltext:=getwiderecord(mastertable.fieldbyname('Comment'));
end;

showprofilesmasterselected;
end;

procedure TFmain.VirtualStringTree1HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
if HitInfo.Button<>mbLeft then
  exit;
  
if updatinglist=true then
  exit;

if HitInfo.Column=-1 then //BUGFIX
  exit;

updatinglist:=true;

//RARE BUT FIX A PROBLEM SELECTED COLUMN PRESSED
SendMessage(masterlv.Handle, WM_LBUTTONUP, 0, 0);

sortcolumn(masterlv,HitInfo.Column);

//showprofiles(true); //REMOVED 0.037

if masterlv.RootNodeCount>1 then
  showprolesmasterdetail(true,true,getcurrentprofileid,true,true);

updatinglist:=false;
end;

procedure TFmain.VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
if column=0 then begin
  if mastertable.Fields[0].AsInteger<>node.Index+1 then //SPEEDUP
    mastertable.Locate('CONT',node.Index+1,[]);

  if Kind=ikState then begin //OK
    if mastertable.fieldbyname('Total_').asinteger=mastertable.fieldbyname('Have_').asinteger then
      imageindex:=8
    else
    if mastertable.fieldbyname('Have_').asinteger=0 then
      imageindex:=10
    else
      imageindex:=9;
  end
  else
  if kind<>ikOverlay then begin
    if offinfotable<>nil then
      imageindex:=mastertable.fieldbyname('Locationnum').asinteger
    else
    if (getwiderecord(mastertable.fieldbyname('Master'))=getwiderecord(mastertable.fieldbyname('Description'))) OR (mastertable.fieldbyname('Master').asstring='') then
      ImageIndex:=17
    else
      ImageIndex:=18;
  end;

end;

end;

procedure TFmain.VirtualStringTree3HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
if HitInfo.Button<>mbLeft then
  exit;
  
if updatinglist=true then
  exit;

if HitInfo.Column=-1 then //BUGFIX
  exit;

updatinglist:=true;

//RARE BUT FIX A PROBLEM SELECTED COLUMN PRESSED
SendMessage(detaillv.Handle, WM_LBUTTONUP, 0, 0);

sortcolumn(detaillv,hitinfo.column);

//showprofiles(true);  REMOVED 0.037

showprolesmasterdetail(false,true,getcurrentprofileid,true,true);

updatinglist:=false;
end;

procedure TFmain.VirtualStringTree3GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
filename:widestring;
md5,sha1:ansistring;
begin
if (detailtable.FieldByName('CONT').asinteger<>node.Index+1) OR (detailtable.FieldByName('Setname').asinteger<>detailedit.tag) then
  detailtable.Locate('CONT;Setname',VarArrayOf([node.Index+1, detailedit.tag]),[]);

filename:=getwiderecord(detailtable.fieldbyname('Romname'));

if (detaillv.Selected[node]=true) AND (detaillv.SelectedCount=1) then
  if detailedit.Text<>filename then begin
    detailedit.Text:=filename;
    detailedit.Repaint;
  end;

case column of
  0:celltext:=filename;
  1:begin
      if showasbytes=false then
        celltext:=bytestostr(detailtable.fieldbyname('Space').ascurrency)
      else
        celltext:=pointdelimiters(detailtable.fieldbyname('Space').ascurrency)+' bytes';
    end;
  2:CellText:=detailtable.fieldbyname('CRC').asstring;
  3:begin
      md5:=detailtable.fieldbyname('MD5').asstring;
      if Length(md5)=32 then
        celltext:=md5
      else//HIDE OFFLINELIST
        celltext:='';
    end;
  4:begin
      sha1:=detailtable.fieldbyname('SHA1').asstring;
      if Length(sha1)=40 then
        celltext:=sha1
      else
        celltext:='';
    end;
end;

showprofilesdetailselected;
end;

procedure TFmain.VirtualStringTree3GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
typ:integer;
filename:widestring;
crc,md5,sha1:ansistring;
begin
if Column=0 then begin
  if (detailtable.FieldByName('CONT').asinteger<>node.Index+1) OR (detailtable.FieldByName('Setname').asinteger<>detailedit.tag) then
    detailtable.Locate('CONT;Setname',VarArrayOf([node.Index+1, detailedit.tag]),[]);

  if Kind=ikState then begin //OK
    if detailtable.FieldByName('Have').asboolean=true then
      imageindex:=11
    else
      imageindex:=12;
  end
  else
  if kind<>ikOverlay then begin

    filename:=getwiderecord(detailtable.fieldbyname('Romname'));
    typ:=detailtable.FieldByName('Type').asinteger;
    crc:=detailtable.fieldbyname('CRC').asstring;
    md5:=detailtable.fieldbyname('MD5').asstring;
    sha1:=detailtable.fieldbyname('SHA1').asstring;

    if filename[Length(filename)]='\' then
      ImageIndex:=30
    else
    if offinfotable<>nil then
      imageindex:=typ+20                                     //MD5 D41D8CD98F00B204E9800998ECF8427E SHA1 DA39A3EE5E6B4B0D3255BFEF95601890AFD80709
    else //BAD DUMP ICON                             //NOT FOR SAMPLES
    if ((crc='') OR (crc='00000000') OR (crc='FFFFFFFF')) AND ((md5='') OR (md5='00000000000000000000000000000000')) AND ((sha1='') Or (sha1='0000000000000000000000000000000000000000')) AND (typ<>1) then begin
      if typ=0 then
        imageindex:=28
      else
        imageindex:=29;
    end
    else
      imageindex:=typ+20;
  end;

end;
end;

procedure TFmain.VirtualStringTree3Resize(Sender: TObject);
begin
try
  CenterInClient(panel35,detaillv);
except
end;
end;

procedure TFmain.VirtualStringTree4GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
root,child:Longint;
begin
//ROOTCONT, CHILDCONT
child:=0;
if Sender.GetNodeLevel(Node) = 1 then begin
  root:=node.Parent.Index+1;
  child:=node.Index+1;
end
else
  root:=node.Index+1;

if (Datamodule1.Tconstructor.fieldbyname('ROOTCONT').asinteger<>root) OR (Datamodule1.Tconstructor.fieldbyname('CHILDCONT').asinteger<>child) then
  Datamodule1.Tconstructor.Locate('ROOTCONT;CHILDCONT',VarArrayOf([root,child]),[]);

case column of

  0:CellText:=getwiderecord(Datamodule1.Tconstructor.fieldbyname('Filename'));
  1:begin
    if showasbytes=false then
      celltext:=bytestostr(Datamodule1.Tconstructor.fieldbyname('Space').ascurrency)
    else
      celltext:=pointdelimiters(Datamodule1.Tconstructor.fieldbyname('Space').ascurrency)+' bytes';
    end;
  2:celltext:=Datamodule1.Tconstructor.fieldbyname('CRC').asstring;
  3:celltext:=Datamodule1.Tconstructor.fieldbyname('MD5').asstring;
  4:celltext:=Datamodule1.Tconstructor.fieldbyname('SHA1').asstring;
  5:celltext:=getwiderecord(Datamodule1.Tconstructor.fieldbyname('Description'));
  6:celltext:=getwiderecord(Datamodule1.Tconstructor.fieldbyname('Path'));
end;

showconstructorselected;
end;

procedure TFmain.VirtualStringTree4GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
idx:shortint;
fil:widestring;
root,child:longint;
begin
if VirtualStringTree4.tag=1 then begin  //FIX FOR THEME CHANGED
  VirtualStringTree4.tag:=0;
  loadthemedcheckboxes;
end;      

if Column=0 then begin
  //ROOTCONT, CHILDCONT
  child:=0;
  if Sender.GetNodeLevel(Node) = 1 then begin
    root:=node.Parent.Index+1;
    child:=node.Index+1;
  end
  else
    root:=node.Index+1;
    
  if (Datamodule1.Tconstructor.fieldbyname('ROOTCONT').asinteger<>root) OR (Datamodule1.Tconstructor.fieldbyname('CHILDCONT').asinteger<>child) then
    Datamodule1.Tconstructor.Locate('ROOTCONT;CHILDCONT',VarArrayOf([root,child]),[]);

  if Kind=ikState then begin

    idx:=0;

    if Datamodule1.Tconstructor.fieldbyname('Checked').asboolean=true then begin
      idx:=1;
      if Datamodule1.Tconstructor.fieldbyname('Origin').asinteger=0 then
        if Datamodule1.Tconstructor.Locate('Origin;Checked',VarArrayOf([Datamodule1.Tconstructor.fieldbyname('CONT').asinteger,'false']),[]) then
          idx:=2;
    end;

    if ThemeServices.ThemesEnabled=true then
      idx:=idx+3;

    ImageIndex:=idx;

  end
  else
  if kind<>ikOverlay then begin 
    if Datamodule1.Tconstructor.fieldbyname('Origin').asinteger<>0 then begin
      fil:=getwiderecord(Datamodule1.Tconstructor.fieldbyname('Filename'));
      if fil[Length(fil)]='\' then
        ImageIndex:=30
      else
      case Datamodule1.Tconstructor.fieldbyname('Type').asinteger of
        0:imageindex:=20;
        1:imageindex:=21;
        2:imageindex:=22;
      end;
      //typ 20 rom 21 sample 22 chd
    end
    else
      imageindex:=30;
    end;
end;   

end;

procedure TFmain.Expandall2Click(Sender: TObject);
begin
VirtualStringTree4.FullExpand(nil);
end;

procedure TFmain.Collapseall2Click(Sender: TObject);
begin
VirtualStringTree4.FullCollapse(nil);
end;

procedure TFmain.VirtualStringTree2IncrementalSearch(
  Sender: TBaseVirtualTree; Node: PVirtualNode;
  const SearchText: WideString; var Result: Integer);
var
S,PropText: string;
VT: TVirtualStringTree;
begin
S := utf8encode(SearchText);//UNICODE SOLUTION
VT := Sender as TVirtualStringTree;

PropText := utf8Encode(VT.Text[Node, 0]);//UNICODE SOLUTION

Result := StrLIComp(PChar(S), PChar(PropText), Min(Length(S), Length(PropText)));
end;

procedure TFmain.Stop1Click(Sender: TObject);
begin
SpeedButton54Click(sender);
end;

procedure TFmain.Refresh1Click(Sender: TObject);
begin
SpeedButton55Click(sender);
end;

procedure TFmain.VirtualStringTree2GetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
rect: Trect;
p:Tpoint;
begin
//Freeandnil in myshowform and popup
Timer3.Enabled:=false;
Timer3.Interval:=Application.HintHidePause;
Fmain.destroycustomhint;

currenthint:=(Sender as TVirtualStringTree).Text[node,column];

if currenthint='' then
  exit;

rect:=(Sender as TVirtualStringTree).GetDisplayRect(node,column,true,false,true);

Flog.label1.Caption:=changein(currenthint,'&','&&');

if Flog.Label1.Width<=rect.Right-rect.Left then begin
  exit;
end;


p:=(Sender as TVirtualStringTree).ClientToScreen(point(0,0));

rect.Top:=rect.top+p.Y-3;
rect.left:=rect.Left+p.X-3;

hintwin:=TMyHintWindow.Create(sender);

hintwin.ActivateHint(rect,'');
Timer3.Enabled:=true;
end;

procedure TFmain.Timer3Timer(Sender: TObject);
begin
Fmain.destroycustomhint;
timer3.Enabled:=false;
end;

procedure TFmain.VirtualStringTree2MouseLeave(Sender: TObject);
begin
Fmain.destroycustomhint;
end;

procedure TFmain.VirtualStringTree2GetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
begin
//caption:=inttostr(R.Right);
end;

procedure TFmain.VirtualStringTree2Scroll(Sender: TBaseVirtualTree; DeltaX,
  DeltaY: Integer);
begin
Fmain.destroycustomhint;
end;

procedure TFmain.PopupMenu5Popup(Sender: TObject);
var
w:widestring;
begin
Fmain.destroycustomhint;
//0.043
w:=getnodetextundermouse(virtualstringtree4);
Fakeedit.Text:=w;
if w<>'' then begin
  Copytoclipboard3.Enabled:=true;
  copy4.Caption:=UTF8Encode(changein(w,'&','&&'));
end
else begin
  Copytoclipboard3.Enabled:=false;
end;
end;

procedure TFmain.TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
hitTest : THitTests;
n:TTnttreenode;
text:widestring;
begin
n:=(sender as TTntTreeView).GetNodeAt(x,y);
hitTest := (sender as TTntTreeView).GetHitTestInfoAt(X, Y) ;

if n=nil then begin
  currenthint:='';//0.026 FIX
  exit;
end;

if (lasttreenode <> n) then begin
  Application.CancelHint;
 
  if (hitTest <= [htOnItem, htOnIcon, htOnLabel, htOnStateIcon]) then begin
    lasttreenode := n;

    if (sender as TTntTreeView)=Fmain.TreeView1 then
      Gettreepath(n,text);

    if (text='') then
      text:=n.text;

    currenthint:=Text;
    (sender as TTntTreeView).Hint := Text ;
  end;

end;

end;

function EnumWindowsProc(wHandle: HWND; param : integer): BOOL; stdcall;
var
ClassName: array[0..255] of char;
Winrect:Trect;
newleft,newtop:integer;
begin
  GetClassName(wHandle, ClassName, 255);

  if classname='#32770' then
    if (getparent(whandle)=Application.Handle) then begin

      newleft:=screen.ActiveForm.Monitor.Left+80;
      newtop:=screen.ActiveForm.Monitor.Top+80;

      GetWindowRect(whandle, WinRect);

      //IF MORE THAN 1 MONITOR
      if screen.ActiveForm.Monitor.MonitorNum<>0 then begin
        if (Winrect.Top<>newtop) AND (Winrect.Left<>newleft) AND (Winrect.Right<>450) AND (Winrect.Bottom<>450) then begin
          //REMOVED
          //ShowWindow(whandle,SW_HIDE);
        end
        else begin
          dialogcounter:=dialogcounter+1; //4TIMES NEEDED
        end;
      end
      else
        dialogcounter:=dialogcounter+1; //4TIMES NEEDED


      EnableMenuItem(GetSystemMenu(whandle, False), SC_SIZE, MF_BYCOMMAND);
      
      if screen.ActiveForm.Monitor.MonitorNum<>0 then
        MoveWindow(whandle,newleft,newtop, 450, 450, True);

      ShowWindow(whandle,SW_SHOWNORMAL);

      //ALWAYS ON TOP
      if screen.ActiveForm.Monitor.MonitorNum<>0 then //CHANGE POSSITION TO CURRENT MONITOR
        if isserverdialog=true then
        SetWindowPos(whandle, HWND_TOPMOST, newleft, newtop, 450, 450, SWP_SHOWWINDOW or SWP_NOSIZE)
        else
        SetWindowPos(whandle, HWND_TOP, newleft, newtop, 450, 450, SWP_SHOWWINDOW or SWP_NOSIZE)
      else
        if isserverdialog=true then
        SetWindowPos(whandle, HWND_TOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE)
        else
        SetWindowPos(whandle, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE)
    end;//DIALOG DETECTED

  Result := True;
end;

procedure TFmain.TimerdialogTimer(Sender: TObject);
var
h:integer;
begin
timerdialog.Enabled:=false;
h:=0;
if dialogcounter<4 then begin
  EnumWindows(@EnumWindowsProc, LPARAM(h));
  timerdialog.Enabled:=true;
end
else begin
  Timerdialog.Interval:=10;
  isfiledialog:=false;

  EnumWindows(@EnumWindowsProc2, LPARAM(h));//DETECT EXISTING OPENEND DIALOGS

  if isfiledialog=false then begin //WAIT FOR DIALOG CLOSE

    if GetFormsCount=2 then
      Fmain.Enabled:=true; //SECURITY

    if Fserver.visible=true then begin
      Fserver.enabled:=true;
      if isserverdialog=true then
      SetWindowPos(Fserver.handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE)
    end;

    isserverdialog:=false;

  end
  else begin
    timerdialog.Enabled:=true;
  end;

end;

end;

function RegReadWideString(const RootKey: HKEY; const Key, Name:
WideString): WideString;
var
  RegKey: HKEY;
  Size: DWORD;
  StrVal: WideString;
  RegKind: DWORD;
  Ret: Longint;
begin
Result := '';

if RegOpenKeyExW(RootKey, Pwidechar(Key), 0, KEY_READ, RegKey) = ERROR_SUCCESS then begin
  RegKind := 0;
  Size := 0;
  Ret := RegQueryValueExW(RegKey, PWideChar(Name), nil, @RegKind, nil,@Size);
  if Ret = ERROR_SUCCESS then
    if RegKind in [REG_SZ, REG_EXPAND_SZ] then begin
      SetLength(StrVal, Size);
      RegQueryValueExW(RegKey, PWideChar(Name), nil, @RegKind,PByte(StrVal), @Size);
      //SetLength(StrVal, StrLenw(PWideChar(StrVal))); //FAIL
      SetLength(strval,length(strval));
      Result := StrVal;
    end;
  RegCloseKey(RegKey);
end;

end;

function extractpathfromline(line:widestring):widestring;
var
aux,res:widestring;
const
s1=':\';
s2='\\';
begin

try
  aux:=gettoken(line,s1,gettokencount(line,s1));
  res:=gettoken(line,s1,gettokencount(line,s1)-1);
  res:=res[length(res)]+s1+aux;
  res:=gettoken(res,' > ',1);

except
end;

if (not fileexists2(res) AND not WideDirectoryExists(res)) then
  if gettokencount(line,s2)>1 then begin
    aux:=gettoken(line,s2,gettokencount(line,s2));
    res:=s2+aux;
  end;

if (not fileexists2(res) AND not WideDirectoryExists(res)) then
  res:='';

Result:=res;
end;

function GetFileTimes(FileName : widestring) : string;
var
FileHandle : integer;
FTimeC,FTimeA,FTimeM : TFileTime;
LTime : TFileTime;
STime : TSystemTime;
Modified : TDateTime;
begin
FileHandle := WideFileOpen(FileName,fmShareDenyNone);
Modified := 0.0;

GetFileTime(FileHandle,@FTimeC,@FTimeA,@FTimeM);
FileClose(FileHandle);

// Modified
FileTimeToLocalFileTime(FTimeM,LTime);
if FileTimeToSystemTime(LTime,STime) then begin
  Modified := EncodeDate(STime.wYear,STime.wMonth,STime.wDay);
  Modified := Modified + EncodeTime(STime.wHour,STime.wMinute,STime.wSecond,Stime.wMilliseconds);
end;

Result :=inttohex(strtoint64((FormatDateTime('ddmmyy',Modified))),0);
result:=result+IntToHex(strtoint64((FormatDateTime('hhnnss',Modified))),0);
end;

procedure TFmain.VirtualStringTree2DragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
allowed:=true;  //Really necessary
end;

procedure TFmain.Zip1DiskFull(Sender: TObject; VolumeNumber: Integer;
  VolumeFileName: WideString; var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip2DiskFull(Sender: TObject; VolumeNumber: Integer;
  VolumeFileName: WideString; var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip2ConfirmOverwrite(Sender: TObject;
  SourceFileName: WideString; var DestFileName: WideString;
  var Confirm: Boolean);
begin
confirm:=true;
end;

procedure TFmain.Zip1ConfirmOverwrite(Sender: TObject;
  SourceFileName: WideString; var DestFileName: WideString;
  var Confirm: Boolean);
begin
confirm:=true;
end;

procedure TFmain.Zip1RequestFirstVolume(Sender: TObject;
  var VolumeFileName: WideString; var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip1RequestLastVolume(Sender: TObject;
  var VolumeFileName: WideString; var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.Zip1RequestMiddleVolume(Sender: TObject;
  VolumeNumber: Integer; var VolumeFileName: WideString;
  var Cancel: Boolean);
begin
makeexception;
end;

procedure TFmain.TntFormActivate(Sender: TObject);
begin
flash;
end;

procedure TFmain.createxmldat1Click(Sender: TObject);
begin
dbtodat;
end;

procedure TFmain.Directory3Click(Sender: TObject);
var
path:widestring;
begin
path:=folderdialoginitialdircheck(initialdirextract);

positiondialogstart;

if WideSelectDirectory(traduction(483)+' :','',path) then begin
  path:=checkpathbar(path);
  initialdirextract:=path;
  extractselection(true,true,path);
end;

end;

procedure TFmain.Desktop3Click(Sender: TObject);
begin
extractselection(true,true,checkpathbar(GetDesktopFolder));
end;

procedure TFmain.StaticText1Click(Sender: TObject);
begin
statictext1.Visible:=false;

if StaticText1.Parent=Fserver then
  Fserver.deletecurrentchat(sender)
else
if statictext1.Parent=Fmain then
  case pagecontrol1.ActivePageIndex of
    1:SpeedButton12Click(sender);
    3:SpeedButton52Click(sender);
  end;

end;

procedure TFmain.copy3Click(Sender: TObject);
begin
TntClipboard.AsWideText:=Fakeedit.Text;
end;

procedure TFmain.copy4Click(Sender: TObject);
begin
TntClipboard.AsWideText:=Fakeedit.Text;
end;

procedure TFmain.copy5Click(Sender: TObject);
begin
TntClipboard.AsWideText:=Fakeedit.Text;
end;

procedure TFmain.copy6Click(Sender: TObject);
begin
TntClipboard.AsWideText:=Fakeedit.Text;
end;

procedure TFmain.StaticText1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if MouseButtonIsDown(mbleft) then
  statictext1.BorderStyle:=sbsSunken;
end;


procedure TFmain.StaticText1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
if MouseButtonIsDown(mbLeft)=true then
  statictext1.BorderStyle:=sbsSunken;

end;

procedure TFmain.ApplicationEvents1Activate(Sender: TObject);
begin
if (Application.Active=true) AND (screen.ActiveForm=Fserver) then  //0.044 FIX NOTIFICATION POSTICON WHEN ACTIVE APPLICATION
  if Fserver.tag=1 then begin
    Fserver.tag:=0;
    Fserver.checkchatselection;
  end;
  if Fserver.pagecontrol1.ActivePageIndex=1 then
    Fserver.TntRichEdit1.SelStart:=length(Fserver.TntRichEdit1.text);
  //FIX SCROLL ON MESSAGES
  if (Fserver.ActiveControl is TRxRichedit) then
    ScrollToEnd(Fserver.ActiveControl as TRxRichedit);
end;

procedure TFmain.Stayontop1Click(Sender: TObject);
begin
setstayontop;
end;

procedure TFmain.Staynormal1Click(Sender: TObject);
begin
if Staynormal1.Checked=false then begin
  Staynormal1.Checked:=true;
end;

if GetFormsCount<>2 then begin
  Staynormal1.Tag:=1;
  exit;
end;

show;
treeview1.Tag:=1;

SetWindowPos(
  Handle,
  HWND_NOTOPMOST,
  0,
  0,
  0,
  0,
  SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);


self.Enabled:=true; //FIX

setstaystatuslabel;

treeview1.Tag:=0;
end;

procedure TFmain.TntSpeedButton1Click(Sender: TObject);
begin
Application.CreateForm(TFscene, Fscene);
myshowform(Fscene,true);


Freeandnil(Fscene);
end;

procedure TFmain.VirtualStringTree2MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
if (sender as TVirtualStringTree).CanFocus=false then
  handled:=true;
end;

procedure TFmain.TntPanel4Resize(Sender: TObject);
begin
currentdbstatusname;
end;

procedure TFmain.Panel65Resize(Sender: TObject);
begin
setgeneratorpathlabel;
end;

end.
