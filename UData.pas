unit UData;

interface

uses
  SysUtils, Classes, ABSMain, DB, Dialogs;

type
  TDataModule1 = class(TDataModule)
    Qaux: TABSQuery;
    TTree: TABSTable;
    DBDatabase: TABSDatabase;
    Tprofiles: TABSTable;
    Tprofilesview: TABSTable;
    DBProfilesview: TABSDatabase;
    Tscansets: TABSTable;
    Tscanroms: TABSTable;
    TDirectories: TABSTable;
    Temulators: TABSTable;
    Taux: TABSTable;
    DBConstructor: TABSDatabase;
    Tconstructor: TABSTable;
    DBUpdater: TABSDatabase;
    Tupdater: TABSTable;
    Qupdater: TABSQuery;
    DBHeaders: TABSDatabase;
    Trules: TABSTable;
    Ttest: TABSTable;
    Tinvertedcrc: TABSTable;
    DBUrls: TABSDatabase;
    Tfavorites: TABSTable;
    Thistory: TABSTable;
    Qurls: TABSQuery;
    Qfavorites: TABSQuery;
    Qaux2: TABSQuery;
    Qaux3: TABSQuery;
    QDupes: TABSQuery;
    Qsort: TABSQuery;
    Qconstructor: TABSQuery;
    DBMyquerys: TABSDatabase;
    Qmyquerys: TABSQuery;
    Tmyquerys: TABSTable;
    DBPeers: TABSDatabase;
    Tpeers: TABSTable;
    Qpeers: TABSQuery;
    Qmyquerysview: TABSQuery;
    Qemulators: TABSQuery;
    DBServers: TABSDatabase;
    Qservers: TABSQuery;
    Tservers: TABSTable;
    QpeersThread: TABSQuery;
    procedure DBDatabaseNeedRepair(Sender: TObject; var DoRepair: Boolean);
    procedure DBProfilesviewNeedRepair(Sender: TObject;
      var DoRepair: Boolean);
    procedure DBConstructorNeedRepair(Sender: TObject;
      var DoRepair: Boolean);
    procedure DBUpdaterNeedRepair(Sender: TObject; var DoRepair: Boolean);
    procedure DBHeadersNeedRepair(Sender: TObject; var DoRepair: Boolean);
    procedure DBUrlsNeedRepair(Sender: TObject; var DoRepair: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

procedure TDataModule1.DBDatabaseNeedRepair(Sender: TObject;
  var DoRepair: Boolean);
begin
dorepair:=false;
end;

procedure TDataModule1.DBProfilesviewNeedRepair(Sender: TObject;
  var DoRepair: Boolean);
begin
dorepair:=false;
end;

procedure TDataModule1.DBConstructorNeedRepair(Sender: TObject;
  var DoRepair: Boolean);
begin
dorepair:=false;
end;

procedure TDataModule1.DBUpdaterNeedRepair(Sender: TObject;
  var DoRepair: Boolean);
begin
dorepair:=false;
end;

procedure TDataModule1.DBHeadersNeedRepair(Sender: TObject;
  var DoRepair: Boolean);
begin
dorepair:=false;
end;

procedure TDataModule1.DBUrlsNeedRepair(Sender: TObject;
  var DoRepair: Boolean);
begin
dorepair:=false;
end;

end.
