//==============================================================================
// Product name: Absolute Database
// Copyright 2003 ComponentAce
//==============================================================================
//==============================================================================
// Product name: Absolute Database
// Copyright 2003 ComponentAce
//==============================================================================
unit ABSMain;

interface

{$I ABSVer.inc}

uses SysUtils,Math, Tntsysutils,Classes,Db,Windows

{$IFNDEF NO_DIALOGS}
{$IFNDEF D16H}
  ,Dialogs, Forms, Controls
{$ELSE}
  ,VCL.Dialogs, VCL.Forms, VCL.Controls
{$ENDIF}
{$ENDIF},

{$IFDEF D17H}
System.Generics.Collections,
{$ENDIF}

{$IFDEF D6H}
     DBCommon,
     Variants,
     SqlTimSt,
{$ENDIF}


// AbsoluteDatabase units

     {$IFDEF LOCAL_VERSION}
     ABSLocalEngine,
     {$ENDIF}

{$IFNDEF D6H}
     ABSD4Routines,
{$ENDIF}

     {$IFDEF DEBUG_MEMCHECK}
     MemCheck,
     {$ENDIF}

     {$IFDEF DEBUG_LOG}
     ABSDebug,
     {$ENDIF}

     {$IFDEF CLIENT_VERSION}
     ABSClient,
     {$ENDIF}
     ABSBase,
     {$IFNDEF NO_DIALOGS}
     ABSDlgWait,
     {$ENDIF}
     ABSCompression,
     ABSSecurity,
     ABSVariant,
     ABSConverts,
     ABSExcept,
     ABSSQLProcessor,
     ABSLexer,
     ABSTypes,
     ABSConst,
     ABSMemory;       // UNIT ABSMemory MUST BE LAST !!!

var
  StartDisconnected: Boolean = False; // disable design-time database connections on app start

const
  // TABSDataset flags
  dbfOpened     = 0;
  dbfPrepared   = 1;
  dbfExecSQL    = 2;
  dbfTable      = 3;
  dbfFieldList  = 4;
  dbfIndexList  = 5;
  dbfStoredProc = 6;
  dbfExecProc   = 7;
  dbfProcDesc   = 8;
  dbfDatabase   = 9;
  dbfProvider   = 10;
  dbfRepair     = 11;

type

  TABSEngineType = (etLocal, etClient, etServer);
  TCompressionAlgorithm = (caNone,caZLIB,caBZIP,caPPM);
{
  TABSCryptoAlgorithm =   (
                            craNone,
                            craRijndael_128,craRijndael_256,
                            craBlowfish,
                            craTwofish_128,craTwofish_256,
                            craSquare,
                            craDES_Single_8,
                            craDES_Double_8,craDES_Double_16,
                            craDES_Triple_8,craDES_Triple_16,craDES_Triple_24
                          );
}
  // forward declarations
  TABSSession = class;
  TABSDatabase = class;
  TABSDataSet = class;
  TABSTable = class;
  TABSAdvFieldDefs = class;
  TABSAdvIndexDefs = class;

////////////////////////////////////////////////////////////////////////////////
//
// EABSEngineError
//
////////////////////////////////////////////////////////////////////////////////

   EABSEngineError = class(EDatabaseError)
   private
      FErrorCode: Integer;
      FErrorMessage: string;
   public
      constructor Create(ErrorCode: Integer; ErrMessage: string = '');

      property ErrorCode: Integer read FErrorCode;
      property ErrorMessage: string read FErrorMessage;
   end;


////////////////////////////////////////////////////////////////////////////////
//
// TABSBLOBStream
//
////////////////////////////////////////////////////////////////////////////////


  TABSBLOBStream = class (TABSStream)
  private
    FField:      TBlobField;
    FDataSet:    TABSDataSet;
    FBLOBStream: TABSStream; // local or client blob stream
   protected
    // sets new size of the stream
    procedure InternalSetSize(const NewSize: Int64);
    // sets new size of the stream
    procedure SetSize(NewSize: Longint);
    {$IFDEF D6H}
      overload;
    {$ENDIF}
      override;
    {$IFDEF D6H}
    procedure SetSize(const NewSize: Int64); overload; override;
    {$ENDIF}
    function GetCompressedSize: Int64;
   public
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint;
    {$IFDEF D6H}
            overload;
    {$ENDIF}
      override;
    {$IFDEF D6H}
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    {$ENDIF}
    constructor Create(Field: TBlobField; Mode: TBlobStreamMode);
    destructor Destroy; override;
    procedure Truncate;
  public
   // blob stream interface
   property BLOBStream: TABSStream read FBLOBStream;
   property CompressedSize: Int64 read GetCompressedSize;
  end; // TABSBLOBStream



////////////////////////////////////////////////////////////////////////////////
//
// TABSSessionList
//
////////////////////////////////////////////////////////////////////////////////

  // global list of sessions
  TABSSessionList = class(TObject)
   private
    FSessions: TThreadList;
    FSessionNumbers: TBits;

    // adds session to list
    procedure AddSession(ASession: TABSSession);
    // closes all sessions
    procedure CloseAll;
    // Gets sessions count
    function GetCount: Integer;
    // Gets session by No
    function GetSession(Index: Integer): TABSSession;
    // gets current session
    function GetCurrentSession: TABSSession;
    // Gets session by Name
    function GetSessionByName(const SessionName: string): TABSSession;
    // Sets current session
    procedure SetCurrentSession(Value: TABSSession);

   public
    constructor Create;
    destructor Destroy; override;
    // Finds session by name
    function FindSession(const SessionName: string): TABSSession;
    // Gets list of sessions names
    procedure GetSessionNames(List: TStrings);
    // Opens session by name
    function OpenSession(const SessionName: string): TABSSession;

    property Count: Integer read GetCount;
    property CurrentSession: TABSSession read GetCurrentSession write SetCurrentSession;
    property Sessions[Index: Integer]: TABSSession read GetSession; default;
    property List[const SessionName: string]: TABSSession read GetSessionByName;
  end;


////////////////////////////////////////////////////////////////////////////////
//
// TABSSession
//
////////////////////////////////////////////////////////////////////////////////

  TABSDatabaseEvent = (dbOpen, dbClose, dbAdd, dbRemove);
  TABSDatabaseNotifyEvent = procedure(DBEvent: TABSDatabaseEvent; const Param) of object;
  TABSPasswordEvent = procedure(Sender: TObject; var Continue: Boolean) of object;

  TABSProgressEvent = procedure(Sender: TObject; PercentDone: Integer; var Continue: Boolean) of object;
  TABSDataSetNotifyEvent = procedure(DataSet: TObject) of object;

  // TSession replacement for thread-safe use
  TABSSession = class(TComponent)
  private
    FHandle: TABSSessionComponentManager;
    FDatabases: TList;
    FStreamedActive: Boolean;
    FKeepConnections: Boolean;
    FDefault: Boolean;
    FAutoSessionName: Boolean;
    FUpdatingAutoSessionName: Boolean;
    FSessionName: string;
    FSessionNumber: Integer;
    FOnDBNotify: TABSDatabaseNotifyEvent;
    FOnStartup: TNotifyEvent;

    // adds database
    procedure AddDatabase(Value: TABSDatabase);
    // raises exception if active
    procedure CheckInactive;
    // sends notification
    procedure DBNotification(DBEvent: TABSDatabaseEvent; const Param);
    // finds database with specified owner
    function DoFindDatabase(const DatabaseName: string; AOwner: TComponent): TABSDatabase;
    // opens database (thread-safe)
    function DoOpenDatabase(const DatabaseName: string;
                            AOwner: TComponent): TABSDatabase;
    // find DB manager by db name
    function FindDatabaseHandle(const DatabaseName: string): TABSBaseSession;
    // session is active?
    function GetActive: Boolean;
    // gets database by No
    function GetDatabase(Index: Integer): TABSDatabase;
    // gets count of connected databases
    function GetDatabaseCount: Integer;
    // gets handle
    function GetHandle: TABSSessionComponentManager;
    // not auto-session?
    function SessionNameStored: Boolean;
    // makes session current
    procedure MakeCurrent;
    // removes database from list
    procedure RemoveDatabase(Value: TABSDatabase);
    // opens session
    procedure SetActive(Value: Boolean);
    // sets auto-session name
    procedure SetAutoSessionName(Value: Boolean);
    // sets the name of session
    procedure SetSessionName(const Value: string);
    // sets session name to datasets and databases
    procedure SetSessionNames;
    // starts session
    procedure StartSession(Value: Boolean);
    // updates auto-session name
    procedure UpdateAutoSessionName;
    // auto-session name is valid?
    procedure ValidateAutoSession(AOwner: TComponent; AllSessions: Boolean);

  protected
    // loaded
    procedure Loaded; override;
    // send notification to datasets and databases
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property OnDBNotify: TABSDatabaseNotifyEvent read FOnDBNotify write FOnDBNotify;
    // set name of component
    procedure SetName(const NewName: TComponentName); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // locks session
    procedure LockSession;
    // unlocks session
    procedure UnlockSession;
    // closes session
    procedure Close;
    // closes database
    procedure CloseDatabase(Database: TABSDatabase);
    // drops all connections
    procedure DropConnections;
    // finds database by name
    function FindDatabase(const DatabaseName: string): TABSDatabase;
    // get list of database names
    procedure GetDatabaseNames(List: TStrings);
    // get list of database tables
    procedure GetTableNames(const DatabaseName: string; List: TStrings);
    // opens session
    procedure Open;
    // opens database
    function OpenDatabase(const DatabaseName: string): TABSDatabase;

    property DatabaseCount: Integer read GetDatabaseCount;
    property Databases[Index: Integer]: TABSDatabase read GetDatabase;
    property Handle: TABSSessionComponentManager read GetHandle;

  published
    property Active: Boolean read GetActive write SetActive default False;
    property AutoSessionName: Boolean read FAutoSessionName write SetAutoSessionName default False;
    property KeepConnections: Boolean read FKeepConnections write FKeepConnections default True;
    property SessionName: string read FSessionName write SetSessionName stored SessionNameStored;
    property OnStartup: TNotifyEvent read FOnStartup write FOnStartup;
  end;


////////////////////////////////////////////////////////////////////////////////
//
// TABSDataset
//
////////////////////////////////////////////////////////////////////////////////


 TABSDBFlags = set of 0..15;
 TABSDataset = class (TDataset)
  private
   FCurrentVersion:                 string;
   FHandle:                         TABSCursor;
   FSessionName:                    string;
   FFilterBuffer:                   TABSRecordBuffer; // filter record buffer
   FIndexFieldCount:                Integer;
   FIndexFieldMap:                  array of Word;
   FKeySize:                        Integer;
   FDBFlags:                        TABSDBFlags;
   FDatabase:                       TABSDatabase;
   FDatabaseName:                   string;
   FInMemory:                       Boolean;
   FReadOnly:                       Boolean;
   FStoreDefs:                      Boolean;  // for FFieldDefs
   FEditRecordBuffer:               TABSRecordBuffer; // for storing record on edit
   FABSConstraintDefs:              TABSConstraintDefs;  // Constraint definitions
   FExternalHandle:                 TABSCursor;
{$IFDEF D6H}
   FOnUpdateRecord: TUpdateRecordEvent;
{$ENDIF}
  protected
   FIndexDefs:                      TIndexDefs; // index definitions
   FABSFieldDefs:                   TABSFieldDefs; // fields definitions
   FABSIndexDefs:                   TABSIndexDefs; // indexes definitions
   FAdvIndexDefs:                   TABSAdvIndexDefs; // index definitions
   FAdvFieldDefs:                   TABSAdvFieldDefs; // USER fields definitions
   FRestructureIndexDefs:           TABSAdvIndexDefs; // restructure index definitions
   FRestructureFieldDefs:           TABSAdvFieldDefs; // restructure field definitions
   FKeyBuffers:                     array[TABSKeyIndex] of TABSRecordBuffer;
   FKeyBuffer:                      TABSRecordBuffer;
   FIsRefreshing:                   Boolean;
   FIgnoreDesignMode:               Boolean; // 5.05
{$IFDEF D6H}
   // IProviderSupport
   function PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError; override;
   function PSIsSQLSupported: Boolean; override;
   procedure PSReset; override;
   function PSUpdateRecord(UpdateKind: TUpdateKind; Delta: TDataSet): Boolean; override;
   procedure PSStartTransaction; override;
   procedure PSEndTransaction(Commit: Boolean); override;
   procedure PSGetAttributes(List: TList); override;
   function PSGetQuoteChar: string; override;
   function PSInTransaction: Boolean; override;
   function PSIsSQLBased: Boolean; override;
{$ENDIF}
{$IFDEF D17H}
    function PSExecuteStatement(const ASQL: string; AParams: TParams): Integer; override;
    function PSExecuteStatement(const ASQL: string; AParams: TParams;
      var ResultSet: TDataSet): Integer; override;
{$ELSE}
{$IFDEF D6H}
   function PSExecuteStatement(const ASQL: string; AParams: TParams; ResultSet: Pointer = nil): Integer; override;
{$ENDIF}
{$ENDIF}
   function InitKeyBuffer(Buffer: TABSRecordBuffer): TABSRecordBuffer;
   procedure AllocKeyBuffers;
   procedure FreeKeyBuffers;
   // field defs support
   function FieldDefsStored: Boolean;
   // index defs support
   function IndexDefsStored: Boolean;
   // set index definitions
   procedure SetIndexDefs(Value: TIndexDefs);
   // get active buffer
   function GetActiveRecordBuffer: TAbsPByte;
   procedure CheckDBSessionName;
   function GetDBHandle: TABSBaseSession;
   function GetDBSession: TABSSession;
   procedure CheckInMemoryDatabaseName;
   procedure SetDatabaseName(const Value: string);
   procedure SetSessionName(const Value: string);
   procedure SetInMemory(const Value: Boolean);
   function GetCurrentVersion: string;
   property IgnoreDesignMode: Boolean read FIgnoreDesignMode write FIgnoreDesignMode;
  protected
   procedure OpenCursor(InfoQuery: Boolean); override;
   procedure CloseCursor; override;
   procedure Disconnect; virtual;
   procedure SetDBFlag(Flag: Integer; Value: Boolean); virtual;
   function CreateHandle: TABSCursor; virtual;
   procedure DestroyHandle; virtual;
   function GetCanModify: Boolean; override;

   procedure DateTimeConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean);
   procedure DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean);
{$IFDEF D5H}
    override;
{$ENDIF}

{$IFDEF D18H}
   procedure DataConvert(Field: TField; Source: TValueBuffer; var Dest: TValueBuffer; ToNative: Boolean); override;
{$ELSE}
{$IFDEF D17H}
   procedure DataConvert(Field: TField; Source, Dest: TValueBuffer; ToNative: Boolean); override;
{$ENDIF}

{$ENDIF}


   procedure SetActive(Value: Boolean); override;

   //---------------------------------------------------------------------------
   // indexes and ranges
   //---------------------------------------------------------------------------

   procedure SwitchToIndex(const IndexName: string);
   function GetIsIndexField(Field: TField): Boolean; override;
   procedure GetIndexInfo;
   function ResetCursorRange: Boolean;

   //---------------------------------------------------------------------------
   // navigation & bookmark methods
   //---------------------------------------------------------------------------

   // clear calculated fields
   procedure ClearCalcFields(Buffer: TAbsPByte); override;
   procedure InternalRefresh; override;
   function GetRecord(Buffer: TAbsPByte; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
  public
   function GetCurrentRecord(Buffer: TAbsPByte): Boolean; override;
  protected
   // return record count
   function GetRecordCount: Integer; override;
   // go to record
   procedure SetRecNo(Value: Integer); override;
   // return current record number
   function GetRecNo: Integer; override;
   // go to first record
   procedure InternalFirst; override;
   // go to last record
   procedure InternalLast; override;
   // go to record in buffer
   procedure InternalSetToRecord(Buffer: TAbsPByte); override;
   // get bookmark flag
   function GetBookmarkFlag(Buffer: TAbsPByte): TBookmarkFlag; override;
   // get bookmark data
   procedure GetBookmarkData(Buffer: TAbsPByte; Data: Pointer); override;
   // get bookmark data
{$IFDEF D17H}
   procedure  GetBookmarkData(Buffer: TRecordBuffer; Data: TBookmark); override;
{$ENDIF}
   // go to bookmark
   procedure InternalGotoBookmark(Bookmark: Pointer); override;
   // set flag
   procedure SetBookmarkFlag(Buffer: TAbsPByte; Value: TBookmarkFlag); override;
   // set data
   procedure SetBookmarkData(Buffer: TAbsPByte; Data: Pointer); override;
{$IFDEF D17H}
   procedure SetBookmarkData(Buffer: TRecordBuffer; Data: TBookmark); override;
{$ENDIF}


  public
   // compare bookmarks
   function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;
   // checks if bookmark is valid
   function BookmarkValid(Bookmark: TBookmark): Boolean; override;
  protected

   //---------------------------------------------------------------------------
   // Filters and search
   //---------------------------------------------------------------------------

   // for OnFilterRecord Event
   function IsOnFilterRecordApplied: Boolean;
  public
   function InternalFilterRecord(Buffer: TABSRecordBuffer): Boolean;
   function FilterRecord(Buffer: TABSRecordBuffer; Dataset: Pointer): Boolean;
  protected
   procedure SetOnFilterRecord(const Value: TFilterRecordEvent); override;
   function IsIndexApplied: Boolean;
   procedure PrepareCursor; virtual;
  public
   // set SQL Filter
   procedure SetSQLFilter(FilterExpr: TObject; ParentQueryAO: TObject; ParentCursor: TABSCursor);
   // apply projection
   procedure ApplyProjection(FieldNamesList, AliasList: TStringList);
   // FindFirst, FindNext, Filters
   procedure ActivateFilters;
   procedure DeactivateFilters;
   procedure SetFilterData(const Text: string; Options: TFilterOptions);
   procedure SetFiltered(Value: Boolean); override;
   procedure SetFilterOptions(Value: TFilterOptions); override;
   procedure SetFilterText(const Value: string); override;
   function FindRecord(Restart, GoForward: Boolean): Boolean; override;
   function LocateRecord(
                         const KeyFields: string;
                         const KeyValues: Variant;
                         Options:         TLocateOptions
                        ): Boolean;
  public
   function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; override;
   function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;

   //---------------------------------------------------------------------------
   // insert, edit, post, delete methods
   //---------------------------------------------------------------------------
  protected
   procedure InitRecord(Buffer: TAbsPByte); override;
   // appending table (Append flag - ignored, record will be inserted at first empty position)
   procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
{$IFDEF D17H}
   procedure InternalAddRecord(Buffer: TRecordBuffer; Append: Boolean); override;
{$ENDIF}
   // insert record
   procedure InternalInsert; override;
   // edit record
   procedure InternalEdit; override;
   // cancels updates
   procedure InternalCancel; override;
   // update record
   procedure InternalPost; override;
   // delete record
   procedure InternalDelete; override;

   //---------------------------------------------------------------------------
   // open, close methods
   //---------------------------------------------------------------------------

   procedure InternalHandleException; override;
   function IsCursorOpen: Boolean; override;
   procedure InternalOpen; override;
   procedure InternalClose; override;
   procedure InternalInitFieldDefs; override;


   //---------------------------------------------------------------------------
   // general methods
   //---------------------------------------------------------------------------

   // copy records and return error log
   function CopyRecords(DestinationDataset: TDataset): string;
   function InternalCopyRecords(SourceDataset: TDataset;
                                DestinationDataset: TDataset;
                                var Log: string;
                                var Continue: Boolean;
                                IgnoreErrors: Boolean = True;
                                RestructuringTable: Boolean = False;
                                ProgressEvent: TABSProgressEvent = nil;
                                MinProgress: Integer = 0;
                                MaxProgress: Integer = 100
                               ): Boolean;

   // allocate record buffer
   function AllocRecordBuffer: TAbsPByte; override;
   // free record buffer
   procedure FreeRecordBuffer(var Buffer: TAbsPByte); override;
   // initialize record buffer
   procedure InternalInitRecord(Buffer: TAbsPByte); override;
{$IFDEF D17}
   // initialize record buffer
   procedure InternalInitRecord(Buffer: TRecordBuffer); override;
{$ENDIF}
   // return record size in bytes
   function GetRecordSize: Word; override;
   // return true if range is applied
   function IsRangeApplied: Boolean;
  public 
   // return true if distinct is applied
   function IsDistinctApplied: Boolean;

  protected
   property DBFlags: TABSDBFlags read FDBFlags;
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   function OpenDatabase: TABSDatabase;
   procedure CloseDatabase(Database: TABSDatabase);
   // read field data to current record buffer
   function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
{$ifdef D18H}
   function GetFieldData(Field: TField; var Buffer: TValueBuffer): Boolean; override;
{$else}
{$ifdef D17H}
   function GetFieldData(Field: TField; Buffer: TValueBuffer): Boolean; override;
{$endif}
{$endif}
  protected
   // write field data from buffer to current record buffer
   procedure SetFieldData(Field: TField; Buffer: Pointer); override;
{$ifdef D17H}
   procedure SetFieldData(Field: TField; Buffer: TValueBuffer); override;
{$endif}


  public
   procedure GetFieldValue(Value: TABSVariant; FieldNo: Integer; DirectAccess: Boolean);
   procedure SetFieldValue(Value: TABSVariant; FieldNo: Integer; DirectAccess: Boolean);
   procedure CopyFieldValue(SrcFieldNo: Integer; UseDirectFieldAccess: Boolean;
                            DestFieldNo: Integer; DestDataset: TABSDataset);
   // create blob stream
  private
   function InternalCreateBlobStream(
    					Field: TField;
              Mode: TBlobStreamMode
              ): TABSStream;
  public
   // create TABSBlobStream
   function CreateBlobStream(
    					Field: TField;
              Mode: TBlobStreamMode
              ): TStream; override;
    // close blob stream, write blob field value to blob data file
    procedure CloseBlob(Field: TField); override;

    // Get list of names of all database components
    procedure GetDatabaseNameList(List: TStrings);
  public
   property Handle: TABSCursor read FHandle;
   property Database: TABSDatabase read FDatabase;
//   property DBHandle: TABSBaseSession read GetDBHandle;
   property DBSession: TABSSession read GetDBSession;
   // index definitions, used by CreateTable;
   property IndexDefs: TIndexDefs read FIndexDefs write SetIndexDefs stored IndexDefsStored;
   // field definitions, used by CreateTable;
   property FieldDefs stored FieldDefsStored;
   // index definitions, used by CreateTable;
   property AdvIndexDefs: TABSAdvIndexDefs read FAdvIndexDefs;
   // field definitions, used by CreateTable;
   property AdvFieldDefs: TABSAdvFieldDefs read FAdvFieldDefs;
   property KeySize: Integer read FKeySize;
   property StoreDefs: Boolean read FStoreDefs write FStoreDefs default False;
  published
   property CurrentVersion: string read GetCurrentVersion write FCurrentVersion;
   // fielddefs support
   property DatabaseName: string read FDatabaseName write SetDatabaseName;
   property SessionName: string read FSessionName write SetSessionName;
   property InMemory: Boolean read FInMemory write SetInMemory;
   property ReadOnly: Boolean read FReadOnly write FReadOnly;

   property Active;
   property AutoCalcFields;
   property Filter;
   property Filtered;
   property FilterOptions;
   property BeforeOpen;
   property AfterOpen;
   property BeforeClose;
   property AfterClose;
   property BeforeInsert;
   property AfterInsert;
   property BeforeEdit;
   property AfterEdit;
   property BeforePost;
   property AfterPost;
   property BeforeCancel;
   property AfterCancel;
   property BeforeDelete;
   property AfterDelete;
   property BeforeScroll;
   property AfterScroll;
{$IFDEF D5H}
   property BeforeRefresh;
   property AfterRefresh;
{$ENDIF}
   property OnCalcFields;
   property OnDeleteError;
   property OnEditError;
   property OnFilterRecord;
   property OnNewRecord;
   property OnPostError;
{$IFDEF D6H}
   property OnUpdateRecord: TUpdateRecordEvent read FOnUpdateRecord write FOnUpdateRecord;
{$ENDIF}
 end; // TABSDataset



 TABSExportToSqlOptions = class(TPersistent)
  private
   FStructure:            Boolean;
   FAddDropTable:         Boolean;
   FBlobSettings:         Boolean;
   FData:                 Boolean;
   FFieldNamesInInserts:  Boolean;
  public
   constructor Create;
   procedure Assign(Source: TPersistent); override;
  published
   property Structure: Boolean read FStructure write FStructure default True;
   property AddDropTable: Boolean read FAddDropTable write FAddDropTable default True;
   property BlobSettings: Boolean read FBlobSettings write FBlobSettings default False;
   property Data: Boolean read FData write FData default False;
   property FieldNamesInInserts: Boolean read FFieldNamesInInserts write FFieldNamesInInserts default False;
 end;


////////////////////////////////////////////////////////////////////////////////
//
// TABSTable
//
////////////////////////////////////////////////////////////////////////////////


 TABSTable = class (TABSDataset)
  private
   FTableName:    string;
   FExclusive:    Boolean;
   FTemporary:    Boolean;
   FIndexName:    string;
   FFieldsIndex:  Boolean;
   FMasterLink:   TMasterDataLink;
   FDisableTempFiles: Boolean;
   {$IFNDEF NO_DIALOGS}
   frmWait:       TfrmWait;
   {$ENDIF}
   FIsRepairing:  Boolean;

   FBeforeCopy:           TABSDatasetNotifyEvent;
   FOnCopyProgress:         TABSProgressEvent;
   FAfterCopy:            TABSDatasetNotifyEvent;

   FBeforeImport:           TABSDatasetNotifyEvent;
   FOnImportProgress:         TABSProgressEvent;
   FAfterImport:            TABSDatasetNotifyEvent;

   FBeforeExport:           TABSDatasetNotifyEvent;
   FOnExportProgress:         TABSProgressEvent;
   FAfterExport:            TABSDatasetNotifyEvent;

   FBeforeRestructure:    TABSDatasetNotifyEvent;
   FOnRestructureProgress:  TABSProgressEvent;
   FAfterRestructure:     TABSDatasetNotifyEvent;

   FBeforeBatchMove:        TABSDatasetNotifyEvent;
   FOnBatchMoveProgress:    TABSProgressEvent;
   FAfterBatchMove:         TABSDatasetNotifyEvent;

   FExportToSqlOptions:     TABSExportToSqlOptions;

   procedure CheckBlankTableName;
   procedure AutoCorrectAdvFieldDefs;
   procedure AutoCorrectFieldDefs;
   procedure CheckAdvFieldDefs;
   procedure AutoCorrectAdvIndexDefs;
   procedure SetTemporary(const Value: Boolean);
   function GetIndexFieldNames: string;
   function GetIndexName: string;
   procedure GetIndexParams(IndexName: string; FieldsIndex: Boolean;
         var IndexedName: string);
   function IndexDefsStored: Boolean;
   procedure SetIndex(const Value: string; FieldsIndex: Boolean);
   procedure SetIndexFieldNames(const Value: string);
   procedure SetIndexName(const Value: string);
   procedure SetTableName(const Value: string);
    // return index name
  public
   function FindOrCreateIndex(FieldNamesList, AscDescList, CaseSensitivityList: TStringList; var IsCreated: Boolean): string;
   function IndexExists(FieldNamesList, AscDescList, CaseSensitivityList: TStringList): Boolean;
   // set distinct
   procedure ApplyDistinct(FieldNamesList, AscDescList, CaseSensitivityList: TStringList); overload;
   procedure ApplyDistinct(ds: TABSDataset); overload;
  private

   function GetTableExists: Boolean;
   //---------------------------- master-detail --------------------------------
   procedure CheckMasterRange;
   procedure UpdateRange;
   procedure MasterChanged(Sender: TObject);
   procedure MasterDisabled(Sender: TObject);
   procedure SetDataSource(Value: TDataSource);
   function GetMasterFields: string;
   procedure SetMasterFields(const Value: string);

  protected
{$IFDEF D6H}
    // IProviderSupport
    function PSGetDefaultOrder: TIndexDef; override;
    function PSGetKeyFields: string; override;
    function PSGetTableName: string; override;
    function PSGetIndexDefs(IndexTypes: TIndexOptions): TIndexDefs; override;
    procedure PSSetCommandText(const CommandText: string); override;
    procedure PSSetParams(AParams: TParams); override;
{$ENDIF}
   procedure PrepareCursor; override;
   function CreateHandle: TABSCursor; override;
   procedure DataEvent(Event: TDataEvent; Info: {$ifdef D16H}NativeInt{$else}Longint{$endif}); override;
   procedure DefChanged(Sender: TObject); override;
   procedure InitFieldDefs; override;
   procedure DestroyHandle; override;
   function GetHandle: TABSCursor;
   procedure UpdateIndexDefs; override;
   function GetIndexField(Index: Integer): TField;
   procedure SetIndexField(Index: Integer; Value: TField);

   //---------------------------- master-detail --------------------------------
   procedure SetLinkRanges(MasterFields: TList);
   function GetDataSource: TDataSource; override;
   procedure DoOnNewRecord; override;
   function GetIndexFieldCount: Integer;
   procedure SetDefaultBlobFieldsValues;

  protected
   property MasterLink: TMasterDataLink read FMasterLink;
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure CreateTable;
   procedure DeleteTable;
   procedure EmptyTable;
   procedure RenameTable(NewTableName: string);
   function ImportTable(
                          SourceTable: TDataset;
                          var Log:     string;
                          aIndexDefs:   TIndexDefs = nil
                        ): Boolean; overload;
   function ImportTable(SourceTable: TDataset): Boolean; overload;
   function ExportTable(
                          DestinationTable:   TDataset;
                          CreateTablePointer: TProcedure;
                          var Log:            string
                       ): Boolean; overload;
   function ExportTable(
                          DestinationTable:   TDataset;
                          CreateTablePointer: TProcedure
                       ): Boolean; overload;

   function CopyTable(NewTableName: string;
                      var Log: string;
                      var Continue: Boolean;
                      DestDatabaseFileName: string ='';
                      DestDatabasePassword: string ='';
                      IgnoreErrors: Boolean = False;
                      OverwriteExistingTable: Boolean = False;
                      CopyIndexes: Boolean = True;
                      MinProgress: Integer = 0;
                      MaxProgress: Integer = 100
                       ): Boolean; overload;

   procedure CopyTable(NewTableName: string; DestDatabaseFileName: string='';
                       DestDatabasePassword: string=''); overload;

   procedure BatchMove(SourceTableOrQuery: TABSDataSet;
                       MoveType: TABSBatchMoveType;
                       DstTableIndexNameToIdentifyEqualRecords: string = '');

   function RestructureTable(var Log: string): Boolean; overload;
   function RestructureTable: Boolean; overload;

   function ExportToSQL: string; overload;
   procedure ExportToSQL(Stream: TStream); overload;
   procedure ExportToSQL(FileName: string); overload;

   // Rename Field by Name
   procedure RenameField(FieldName, NewFieldName: string); overload;

   procedure AddIndex(
              const Name,
              Fields: string;
              Options: TIndexOptions;
              const DescFields: string = '';
              const CaseInsFields: string = ''
                     );
   procedure DeleteIndex(const Name: string);
   procedure DeleteAllIndexes;

 protected
   // repair method
   procedure ValidateAndRepairMostUpdatedAndRecordPageIndex;

   //---------------------------------------------------------------------------
   // key and range methods
   //---------------------------------------------------------------------------
  protected
    procedure CheckSetKeyMode;
    function GetKeyBuffer(KeyIndex: TABSKeyIndex): TABSRecordBuffer;
    function GetKeyExclusive: Boolean;
    function GetKeyFieldCount: Integer;
    procedure SetKeyExclusive(Value: Boolean);
    procedure SetKeyFieldCount(Value: Integer);
    procedure SetKeyBuffer(KeyIndex: TABSKeyIndex; Clear: Boolean);
    procedure SetKeyFields(KeyIndex: TABSKeyIndex; const Values: array of const);
    procedure PostKeyBuffer(Commit: Boolean);
  public
   function FindKey(const KeyValues: array of const): Boolean;
   procedure FindNearest(const KeyValues: array of const);
   function GotoKey: Boolean;
   procedure GotoNearest;
   procedure EditKey;
   procedure SetKey;

   function SetCursorRange: Boolean;
   procedure ApplyRange;
   procedure CancelRange;
   procedure EditRangeStart;
   procedure EditRangeEnd;
   procedure SetRange(const StartValues, EndValues: array of const);
   procedure SetRangeStart;
   procedure SetRangeEnd;

   procedure Post; override;
   procedure Cancel; override;

   function IsRecordLocked: Boolean;

   // return LastAutoincValue for Field (FieldIndex started by 0)
   function LastAutoincValue(FieldIndex: Integer): Int64; overload;
   // return LastAutoincValue for Field
   function LastAutoincValue(FieldName: string): Int64; overload;


   procedure InternalBeforeCopy(Sender: TObject);
   procedure InternalOnCopyProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
   procedure InternalAfterCopy(Sender: TObject);

   procedure InternalBeforeImport(Sender: TObject);
   procedure InternalOnImportProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
   procedure InternalAfterImport(Sender: TObject);

   procedure InternalBeforeExport(Sender: TObject);
   procedure InternalOnExportProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
   procedure InternalAfterExport(Sender: TObject);

   procedure InternalBeforeRestructure(Sender: TObject);
   procedure InternalOnRestructureProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
   procedure InternalAfterRestructure(Sender: TObject);

   procedure InternalBeforeBatchMove(Sender: TObject);
   procedure InternalOnBatchMoveProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
   procedure InternalAfterBatchMove(Sender: TObject);

  public
   property IndexFieldCount: Integer read GetIndexFieldCount;
   property IndexFields[Index: Integer]: TField read GetIndexField write SetIndexField;
   property KeyExclusive: Boolean read GetKeyExclusive write SetKeyExclusive;
   property KeyFieldCount: Integer read GetKeyFieldCount write SetKeyFieldCount;
   property Temporary: Boolean Read FTemporary Write SetTemporary;
   // index definitions, used by RestructureTable;
   property RestructureIndexDefs: TABSAdvIndexDefs read FRestructureIndexDefs;
   // field definitions, used by RestructureTable;
   property RestructureFieldDefs: TABSAdvFieldDefs read FRestructureFieldDefs;
   property DisableTempFiles: Boolean Read FDisableTempFiles Write FDisableTempFiles;

  published
   // fielddefs support
   property StoreDefs;
   // index definitions
   property IndexDefs: TIndexDefs read FIndexDefs write SetIndexDefs
              stored IndexDefsStored;
   property IndexFieldNames: string read GetIndexFieldNames write SetIndexFieldNames;
   property IndexName: string read GetIndexName write SetIndexName;
   // field definitions
   property FieldDefs stored FieldDefsStored;
   property TableName: string Read FTableName Write SetTableName;
   property Exclusive: Boolean read FExclusive write FExclusive;
   property Exists: Boolean read GetTableExists;
   property MasterFields: string read GetMasterFields write SetMasterFields;
   property MasterSource: TDataSource read GetDataSource write SetDataSource;

   property ExportToSqlOptions: TABSExportToSqlOptions read FExportToSqlOptions write FExportToSqlOptions;

   property BeforeCopy: TABSDatasetNotifyEvent read FBeforeCopy write FBeforeCopy;
   property OnCopyProgress: TABSProgressEvent read FOnCopyProgress write FOnCopyProgress;
   property AfterCopy: TABSDatasetNotifyEvent read FAfterCopy write FAfterCopy;

   property BeforeImport: TABSDatasetNotifyEvent read FBeforeImport write FBeforeImport;
   property OnImportProgress: TABSProgressEvent read FOnImportProgress write FOnImportProgress;
   property AfterImport: TABSDatasetNotifyEvent read FAfterImport write FAfterImport;

   property BeforeExport: TABSDatasetNotifyEvent read FBeforeExport write FBeforeExport;
   property OnExportProgress: TABSProgressEvent read FOnExportProgress write FOnExportProgress;
   property AfterExport: TABSDatasetNotifyEvent read FAfterExport write FAfterExport;

   property BeforeRestructure: TABSDatasetNotifyEvent read FBeforeRestructure write FBeforeRestructure;
   property OnRestructureProgress: TABSProgressEvent read FOnRestructureProgress write FOnRestructureProgress;
   property AfterRestructure: TABSDatasetNotifyEvent read FAfterRestructure write FAfterRestructure;

   property BeforeBatchMove: TABSDatasetNotifyEvent read FBeforeBatchMove write FBeforeBatchMove;
   property OnBatchMoveProgress: TABSProgressEvent read FOnBatchMoveProgress write FOnBatchMoveProgress;
   property AfterBatchMove: TABSDatasetNotifyEvent read FAfterBatchMove write FAfterBatchMove;

 end; // TABSTable


////////////////////////////////////////////////////////////////////////////////
//
// TABSQuery
//
////////////////////////////////////////////////////////////////////////////////


 TABSQuery = class (TABSDataset)
  private
    FStmtHandle:        TABSSQLProcessor;
    FSQL:               TStrings;
    FPrepared:          Boolean;
    FParams:            TParams;
    FText:              string;
    FDataLink:          TDataLink;
    FRowsAffected:      Integer;
    FRequestLive:       Boolean;
    FSQLBinary:         PAnsiChar;
    FParamCheck:        Boolean;
    FExecSQL:           Boolean;
    FCheckRowsAffected: Boolean;
   protected
{$IFDEF D6H}
    // IProviderSupport
    procedure PSExecute; override;
    function PSGetDefaultOrder: TIndexDef; override;
    function PSGetParams: TParams; override;
    function PSGetTableName: string; override;
    procedure PSSetCommandText(const CommandText: string); override;
    procedure PSSetParams(AParams: TParams); override;
{$ENDIF}
    procedure GetStatementHandle(SQLText: PChar);
    procedure FreeStatement;
    function CreateCursor(GenHandle: Boolean): TABSCursor;
    function GetQueryCursor(GenHandle: Boolean): TABSCursor;
    function GetRowsAffected: Integer;
    procedure QueryChanged(Sender: TObject);
    function GetDataSource: TDataSource; override;
    procedure SetDataSource(Value: TDataSource);
    procedure SetQuery(Value: TStrings);
    procedure InternalRefresh; override;

    function GetParamsCount: Word;
    procedure RefreshParams;
    procedure SetParamsList(Value: TParams);
    procedure SetParamsFromCursor;
  public
    function ParamByName(const Value: string): TParam;

    procedure Prepare;
    procedure UnPrepare;
  protected
    procedure PrepareSQL(Value: PChar);
    procedure SetPrepared(Value: Boolean);
    procedure SetPrepare(Value: Boolean);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadBinaryData(Stream: TStream);
    procedure WriteBinaryData(Stream: TStream);
    procedure ReadParamData(Reader: TReader);
    procedure WriteParamData(Writer: TWriter);
  protected
    function CreateHandle: TABSCursor; override;
    procedure Disconnect; override;
    procedure SetDBFlag(Flag: Integer; Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecSQL;
    procedure GetDetailLinkFields(MasterFields, DetailFields: TList); override;
  public
    property Prepared: Boolean read FPrepared write SetPrepare;
    property ParamCount: Word read GetParamsCount;
    property StmtHandle: TABSSQLProcessor read FStmtHandle;
    property Text: string read FText;
    property RowsAffected: Integer read GetRowsAffected;
    property SQLBinary: PAnsiChar read FSQLBinary write FSQLBinary;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ParamCheck: Boolean read FParamCheck write FParamCheck default True;
    property RequestLive: Boolean read FRequestLive write FRequestLive default False;
    property SQL: TStrings read FSQL write SetQuery;
    property Params: TParams read FParams write SetParamsList stored False;
 end; // TABSQuery


////////////////////////////////////////////////////////////////////////////////
//
// TABSDatabase
//
////////////////////////////////////////////////////////////////////////////////
 TABSOnNeedRepairEvent = procedure(Sender: TObject; var DoRepair: Boolean) of Object;

 TABSDatabase = class (TComponent)
  private
    FCurrentVersion:                    string;
    FDataSets:                          TList;
    FKeepConnection:                    Boolean;
    FTemporary:                         Boolean;
    FStreamedConnected:                 Boolean;
    FAcquiredHandle:                    Boolean;
    FHandleShared:                      Boolean;
    FReadOnly:                          Boolean;
    FExclusive:                         Boolean;
    FRefCount:                          Integer;
    FHandle:                            TABSBaseSession;
    FSession:                           TABSSession;
    FSessionName:                       string;
    FDatabaseName:                      string; // name of database
    FDatabaseFileName:                  string; // database file name
    FPassword:                          string;  // password
    FCryptoAlgorithm:                   TABSCryptoAlgorithm;
    FPageSize:                          Integer;
    FPageCountInExtent:                 Integer;
    FNoRequestAutoRepair:               Boolean;
    FSilentMode:                        Boolean;
    FMultiUser:                         Boolean;
    FMaxConnections:                    Integer;
    FDisableTempFiles:                  Boolean;

    FOnPassword:                        TABSPasswordEvent;

    FBeforeRepair:                      TNotifyEvent;
    FOnRepairProgress:                  TABSProgressEvent;
    FAfterRepair:                       TNotifyEvent;

    FBeforeCompact:                     TNotifyEvent;
    FOnCompactProgress:                 TABSProgressEvent;
    FAfterCompact:                      TNotifyEvent;

    FBeforeChangePassword:              TNotifyEvent;
    FOnChangePasswordProgress:          TABSProgressEvent;
    FAfterChangePassword:               TNotifyEvent;

    FAfterChangeDatabaseSettings:       TNotifyEvent;
    FOnChangeDatabaseSettingsProgress:  TABSProgressEvent;
    FBeforeChangeDatabaseSettings:      TNotifyEvent;

    FOnNeedRepair:                      TABSOnNeedRepairEvent;
    {$IFNDEF NO_DIALOGS}
    frmWait:                            TfrmWait;
    {$ENDIF}

    procedure CheckActive;
    // raises exception if not active
    procedure CheckInactive;
    // raises exception if database name is not valid
    procedure CheckDatabaseName;
    // checks session name
    procedure CheckSessionName(Required: Boolean);
    procedure CheckConnected;
    // db connected?
    function GetConnected: Boolean;
    // connected dataset
    function GetDataSet(Index: Integer): TABSDataSet;
    // count of connected datasets
    function GetDataSetCount: Integer;
    // opens from existing DB
    function OpenFromExistingDB: Boolean;

    // sets specified file name
    procedure SetDatabaseFileName(Value: string);
    // sets specified database name
    procedure SetDatabaseName(Value: string);
    // sets handle
    procedure SetHandle(Value: TABSBaseSession);
    // keeps connection
    procedure SetKeepConnection(Value: Boolean);
    // sets read-only mode
    procedure SetReadOnly(Value: Boolean);
    // sets session name
    procedure SetSessionName(const Value: string);

    // connect / disconnect
    procedure SetConnected(value: boolean);
    // is database file exists
    function GetExists: boolean;
    // get database manager
    procedure CreateHandle;
    // release database manager
    procedure DestroyHandle;
    // get password
    function GetPassword: Boolean;

    // transactions
    function GetInTransaction: Boolean;
    function GetCurrentVersion: string;

    // last write to DB file was interrupted
    procedure DoOnNeedRepair(var DoRepair: Boolean);
    // DBB need convertation to the new format
    procedure DoOnNeedConvert(var DoRepair: Boolean);

    function InternalCopyDatabase(
                NewDatabaseFileName: string;
                var Log: string;
                IgnoreErrors: Boolean = False;
                  NewPassword: string = '';
                  NewCryptoAlgorithm: TABSCryptoAlgorithm = DefaultCryptoAgorithm;
                  NewPageSize: Integer = DefaultPageSize;
                  NewPageCountInExtent: Integer = DefaultExtentPageCount;
                  NewMaxConnections: Integer = DefaultMaxSessionCount;
                BeforeEvent: TNotifyEvent = nil;
                ProgressEvent: TABSProgressEvent = nil;
                AfterEvent: TNotifyEvent = nil
              ): Boolean;

    procedure EmptyEvent(Sender: TObject);

    procedure InternalBeforeRepair(Sender: TObject);
    procedure InternalOnRepairProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
    procedure InternalAfterRepair(Sender: TObject);

    procedure InternalBeforeCompact(Sender: TObject);
    procedure InternalOnCompactProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
    procedure InternalAfterCompact(Sender: TObject);

    procedure InternalBeforeChangePassword(Sender: TObject);
    procedure InternalOnChangePasswordProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
    procedure InternalAfterChangePassword(Sender: TObject);

    procedure InternalBeforeChangeDatabaseSettings(Sender: TObject);
    procedure InternalOnChangeDatabaseSettingsProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
    procedure InternalAfterChangeDatabaseSettings(Sender: TObject);

  protected
    // loaded
    procedure Loaded; override;
    // sends notification
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    // creates databases with specified directory
    constructor Create(AOwner: TComponent); override;
    // destructor
    destructor Destroy; override;
    // connected := true
    procedure Open;
    // connected := false
    procedure Close;
    // create database
    procedure CreateDatabase;
    // delete database
    procedure DeleteDatabase;
    // rename database
    procedure RenameDatabase(NewDatabaseFileName: string);

    // compact database
    function CompactDatabase(NewDatabaseFileName: string): Boolean; overload;
    // compact database
    function CompactDatabase: Boolean; overload;
    // truncate free pages from database
    procedure TruncateDatabase;

    // repair database
    function RepairDatabase: string; overload;
    // repair database
    function RepairDatabase(NewDatabaseFileName: string; var Log: string): Boolean; overload;
    // Change Database Settings
    function ChangeDatabaseSettings(
                  var Log: string;
                  IgnoreErrors: Boolean;
                  NewPassword: string;
                  NewCryptoAlgorithm: TABSCryptoAlgorithm = DefaultCryptoAgorithm;
                  NewPageSize: Integer = DefaultPageSize;
                  NewPageCountInExtent: Integer = DefaultExtentPageCount;
                  NewMaxConnections: Integer = DefaultMaxSessionCount
                            ): Boolean;
    // change password
    function ChangePassword(NewPassword: string): string; overload;
    // change password and CryptoAggorithm
    function ChangePassword(NewPassword: string; NewCryptoAlgorithm: TABSCryptoAlgorithm): string; overload;
    // makes Exe database from abs file
    procedure MakeExecutableDatabase(const ExeStubFileName, ExeDbFileName: string);
    // return Count of connections to Database File or -1 if it's openned in Exclusive
    function GetDBFileConnectionsCount: Integer;
    // flush all changes that have been written to the database
    procedure FlushBuffers;

    // close all datasets
    procedure CloseDataSets;
    // validates name
    procedure ValidateName(const Name: string);
    // get list of tables in database file
    procedure GetTablesList(List: TStrings);
    // determine if table exists
    function TableExists(TableName: string): Boolean;

    // transactions
    procedure StartTransaction;
    procedure Commit(DoFlushBuffers: Boolean=True);
    procedure Rollback;

    property DataSets[Index: Integer]: TABSDataSet read GetDataSet;
    property DataSetCount: Integer read GetDataSetCount;
    property Exists: Boolean read GetExists;
    property Handle: TABSBaseSession read FHandle write SetHandle;
    property Session: TABSSession read FSession;
    property Temporary: Boolean read FTemporary write FTemporary;
    property InTransaction: Boolean read GetInTransaction;
    property PageSize: Integer read FPageSize write FPageSize;
    property PageCountInExtent: Integer read FPageCountInExtent write FPageCountInExtent;
    property CryptoAlgorithm: TABSCryptoAlgorithm read FCryptoAlgorithm write FCryptoAlgorithm;

  published
    property Connected: boolean read GetConnected write SetConnected default false;
    property CurrentVersion: string read GetCurrentVersion write FCurrentVersion;
    property DatabaseFileName: string read FDatabaseFileName write SetDatabaseFileName;
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
    property Exclusive: Boolean read FExclusive write FExclusive;
    property Password: string read FPassword write FPassword;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property HandleShared: Boolean read FHandleShared write FHandleShared default False;
    property KeepConnection: Boolean read FKeepConnection write SetKeepConnection default True;
    property MaxConnections: Integer read FMaxConnections write FMaxConnections;
    property MultiUser: Boolean read FMultiUser write FMultiUser;
    property SessionName: string read FSessionName write SetSessionName;
    property SilentMode: boolean read FSilentMode write FSilentMode default False;
    property DisableTempFiles: boolean read FDisableTempFiles write FDisableTempFiles default False;

    property OnPassword: TABSPasswordEvent read FOnPassword write FOnPassword;
    property BeforeRepair: TNotifyEvent read FBeforeRepair write FBeforeRepair;
    property OnRepairProgress: TABSProgressEvent read FOnRepairProgress write FOnRepairProgress;
    property AfterRepair: TNotifyEvent read FAfterRepair write FAfterRepair;
    property BeforeCompact: TNotifyEvent read FBeforeCompact write FBeforeCompact;
    property OnCompactProgress: TABSProgressEvent read FOnCompactProgress write FOnCompactProgress;
    property AfterCompact: TNotifyEvent read FAfterCompact write FAfterCompact;
    property BeforeChangePassword: TNotifyEvent read FBeforeChangePassword write FBeforeChangePassword;
    property OnChangePasswordProgress: TABSProgressEvent read FOnChangePasswordProgress write FOnChangePasswordProgress;
    property AfterChangePassword: TNotifyEvent read FAfterChangePassword write FAfterChangePassword;
    property OnNeedRepair: TABSOnNeedRepairEvent read FOnNeedRepair write FOnNeedRepair;

    property BeforeChangeDatabaseSettings: TNotifyEvent read FBeforeChangeDatabaseSettings write FBeforeChangeDatabaseSettings;
    property OnChangeDatabaseSettingsProgress: TABSProgressEvent read FOnChangeDatabaseSettingsProgress write FOnChangeDatabaseSettingsProgress;
    property AfterChangeDatabaseSettings: TNotifyEvent read FAfterChangeDatabaseSettings write FAfterChangeDatabaseSettings;

//    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
 end; // TABSDatabase



////////////////////////////////////////////////////////////////////////////////
//
//  TABSAdvFieldDef
//
////////////////////////////////////////////////////////////////////////////////
   TABSAdvFieldDef = class (TObject)
    private
     FName:                 string;
     FObjectID:             TABSObjectID;
     FDataType:             TABSAdvancedFieldType;
     FRequired:             Boolean;
     FSize:                 Integer;

     FDefaultValue:         TABSVariant;
     FMinValue:             TABSVariant;
     FMaxValue:             TABSVariant;

     // Autoinc settings
     FAutoincIncrement:     Int64;
     FAutoincInitialValue:  Int64;
     FAutoincMinValue:      Int64;
     FAutoincMaxValue:      Int64;
     FAutoincCycled:        Boolean;

     FBLOBCompressionAlgorithm: TCompressionAlgorithm;
     FBLOBCompressionMode:      Byte;
     FBLOBBlockSize:            Integer;
    public
     procedure Assign(Source: TABSAdvFieldDef);
     constructor Create;
     destructor Destroy; override;
    public
     property Name: string read FName write FName;
     property ObjectID: TABSObjectID read FObjectID write FObjectID;
     property DataType: TABSAdvancedFieldType read FDataType write FDataType;
     property Required: Boolean read FRequired write FRequired;
     property Size: Integer read FSize write FSize;
     property DefaultValue: TABSVariant read FDefaultValue;
     property MinValue: TABSVariant read FMinValue;
     property MaxValue: TABSVariant read FMaxValue;
     property AutoincIncrement: Int64 read FAutoincIncrement write FAutoincIncrement;
     property AutoincInitialValue: Int64 read FAutoincInitialValue write FAutoincInitialValue;
     property AutoincMinValue:   Int64 read FAutoincMinValue write FAutoincMinValue;
     property AutoincMaxValue:  Int64 read FAutoincMaxValue write FAutoincMaxValue;
     property AutoincCycled:    Boolean read FAutoincCycled write FAutoincCycled;
     property BLOBCompressionAlgorithm: TCompressionAlgorithm read FBLOBCompressionAlgorithm write FBLOBCompressionAlgorithm;
     property BLOBCompressionMode: Byte read FBLOBCompressionMode write FBLOBCompressionMode;
     property BLOBBlockSize: Integer read FBLOBBlockSize write FBLOBBlockSize;
   end;


////////////////////////////////////////////////////////////////////////////////
//
//  TABSAdvFieldDefs
//
////////////////////////////////////////////////////////////////////////////////

   TABSAdvFieldDefs = class (TObject)
    private
     FDefsList: TList;
    private
     function GetCount: Integer;
     function GetDef(Index: Integer): TABSAdvFieldDef;
     procedure SetDef(Index: Integer; value: TABSAdvFieldDef);
    public
     procedure Assign(Source: TABSAdvFieldDefs);
     constructor Create;
     destructor Destroy; override;
     function AddFieldDef: TABSAdvFieldDef;
     procedure Add(const Name: string; DataType: TABSAdvancedFieldType;
                   Size: Integer = 0; Required: Boolean = False;
                   BLOBCompressionAlgorithm: TCompressionAlgorithm = caNone;
                   BLOBCompressionMode: Byte = 0);
     procedure DeleteFieldDef(const FieldName: string);
     function Find(const Name: string): TABSAdvFieldDef;
     procedure Clear;
    public
     property Items[Index: Integer]: TABSAdvFieldDef read GetDef write SetDef; default;
     property Count: Integer read GetCount;
   end;


////////////////////////////////////////////////////////////////////////////////
//
//  TABSAdvIndexDef
//
////////////////////////////////////////////////////////////////////////////////
   TABSAdvIndexDef = class (TObject)
    private
      FName:                 string;
      FFields: string;
      FDescFields: string;
      FCaseInsFields: string;
      FOptions: TIndexOptions;
      FMaxIndexedSizes: string;
      FTemporary: Boolean;
    public
      constructor Create;
      procedure Assign(ASource: TABSAdvIndexDef);

    published
      property Name: string read FName write FName;
      property CaseInsFields: string read FCaseInsFields write FCaseInsFields;
      property DescFields: string read FDescFields write FDescFields;
      property Fields: string read FFields write FFields;
      property Options: TIndexOptions read FOptions write FOptions default [];
      property Temporary: Boolean read FTemporary write FTemporary;
      property MaxIndexedSizes: string read FMaxIndexedSizes write FMaxIndexedSizes;
  end;// TABSAdvIndexDef


////////////////////////////////////////////////////////////////////////////////
//
//  TABSAdvIndexDefs
//
////////////////////////////////////////////////////////////////////////////////

   TABSAdvIndexDefs = class (TObject)
    private
     FDefsList: TList;
     FDataset: TDataset;
    private
     function GetCount: Integer;
     function GetDef(Index: Integer): TABSAdvIndexDef;
     procedure SetDef(Index: Integer; value: TABSAdvIndexDef);
    public
     procedure Assign(Source: TABSAdvIndexDefs; SkipTemporaryIndexes: Boolean = False);
     constructor Create(ADataSet: TDataSet);
     destructor Destroy; override;
     function AddIndexDef: TABSAdvIndexDef;
     procedure Add(const Name, Fields: string; Options: TIndexOptions; Temporary: Boolean = false;
                   DescFields: string = '';
                   CaseInsFields: string = '';
                   MaxIndexedSizes: string = '');
     procedure DeleteIndexDef(const IndexName: string);
     function Find(const Name: string): TABSAdvIndexDef;
     procedure Clear;
     procedure Update;
    public
     property Items[Index: Integer]: TABSAdvIndexDef read GetDef write SetDef; default;
     property Count: Integer read GetCount;
   end;// TABSAdvIndexDefs


 // convert TFieldDefs to ABSFieldDefs
 procedure ConvertFieldDefsToABSFieldDefs(
                FieldDefs:      TFieldDefs;
                ABSFieldDefs:   TABSFieldDefs
                                         );

 // convert AdvFieldDefs to ABSFieldDefs
procedure ConvertAdvFieldDefsToABSFieldDefs(
                AdvFieldDefs:      TABSAdvFieldDefs;
                ABSFieldDefs:      TABSFieldDefs;
                IndexDefs:         TABSIndexDefs;
                ABSConstraintDefs: TABSConstraintDefs;
                Temporary:         Boolean
                                            );

 // Add Unic or Primary Key constraint
 function AddConstraintForIndex(
                                  IndexDef:           TABSIndexDef;
                                  ABSConstraintDefs:  TABSConstraintDefs
                                 ): TABSConstraintDef;

 // convert ABSFieldDefs to AdvFieldDefs
 procedure ConvertABSFieldDefsToAdvFieldDefs(
                VisibleFieldDefs:   TABSFieldDefs;
                ABSFieldDefs:   TABSFieldDefs;
                ABSConstraintDefs: TABSConstraintDefs;
                AdvFieldDefs:   TABSAdvFieldDefs
                                        );


 // convert ABSFieldDefs to TFieldDefs
 procedure ConvertABSFieldDefsToFieldDefs(
                ABSFieldDefs:   TABSFieldDefs;
                ABSConstraintDefs: TABSConstraintDefs;
                FieldDefs:      TFieldDefs
                                         );


 // convert AdvFieldDefs to FieldDefs
 procedure ConvertAdvFieldDefsToFieldDefs(AdvFieldDefs: TABSAdvFieldDefs; FieldDefs: TFieldDefs);

 // convert FieldDefs to AdvFieldDefs
 procedure ConvertFieldDefsToAdvFieldDefs(FieldDefs: TFieldDefs; AdvFieldDefs: TABSAdvFieldDefs);


 // get string list from string with names
 procedure GetNamesList(List: TStrings; const Names: string);

 // fill ABSIndexDef
 procedure FillABSIndexDef(
              ABSIndexDef:         TABSIndexDef;
              const Name,
              Fields: string;
              Options: TIndexOptions;
              Temporary: Boolean;
              const DescFields: string;
              const CaseInsFields: string;
              const MaxIndexedSizes: string;
              FieldDefs:           TFieldDefs
                           );

 // convert TIndexDef to TABSIndexDef
 procedure ConvertAdvIndexDefToABSIndexDef(
                AdvIndexDef:      TABSAdvIndexDef;
                ABSIndexDef:   TABSIndexDef;
                FieldDefs:     TFieldDefs
                                         );

 // convert AdvIndexDefs to TIndexDefs
 procedure ConvertAdvIndexDefsToIndexDefs(
                AdvIndexDefs:   TABSAdvIndexDefs;
                IndexDefs:      TIndexDefs
                                         );
 // convert TIndexDefs to TABSAdvIndexDefs
 procedure ConvertIndexDefsToAdvIndexDefs(
                IndexDefs:      TIndexDefs;
                AdvIndexDefs:   TABSAdvIndexDefs
                                         );
 // convert TAdvIndexDefs to TABSIndexDefs
 procedure ConvertAdvIndexDefsToABSIndexDefs(
                AdvIndexDefs:   TABSAdvIndexDefs;
                ABSIndexDefs:   TABSIndexDefs;
                FieldDefs:      TFieldDefs
                                         );

 // convert ABSIndexDef to AdvIndexDef
 procedure ConvertABSIndexDefToAdvIndexDef(
                ABSIndexDef:   TABSIndexDef; AdvIndexDef:   TABSAdvIndexDef);
 // convert ABSIndexDefs to TIndexDefs
 procedure ConvertABSIndexDefsToAdvIndexDefs(
                ABSIndexDefs:   TABSIndexDefs; AdvIndexDefs:   TABSAdvIndexDefs);

 // return true if field exists
 function FindFieldInFieldDefs(FieldDefs: TFieldDefs; FieldName : string): Boolean;

 // compression algorithm
function ConvertCompressionAlgorithmToABSCompressionAlgorithm(
            CompressionAlgorithm: TCompressionAlgorithm
          ): TABSCompressionAlgorithm;
 // compression algorithm
function ConvertABSCompressionAlgorithmToCompressionAlgorithm(
            CompressionAlgorithm: TABSCompressionAlgorithm
          ): TCompressionAlgorithm;

// copy records and return error log
//function CopyDatasets(SourceDataset: TDataset; DestinationDataset: TDataset): string;

procedure DbiError(ErrorCode: Integer; ErrorMessage: string = '');
procedure Check(Status: Integer; ErrorMessage: string = '');

var
  Sessions:              TABSSessionList;
  Session:               TABSSession;




implementation

uses
     {$IFDEF MEMORY_ENGINE}
     ABSMemEngine,
     {$ENDIF}
     {$IFDEF TEMPORARY_ENGINE}
     ABSTempEngine,
     {$ENDIF}
     {$IFDEF DISK_ENGINE}
     ABSDiskEngine,
     {$IFNDEF NO_DIALOGS}
     ABSPasswordDialog,
     {$ENDIF}
     ABSExpressions,
     {$ENDIF}
{$IFDEF D6H}
     DateUtils,
{$ENDIF}
     ABSDecUtil,
     ABSBaseEngine;
var
  FCSect:                TRTLCriticalSection;
  CurrentSessionManager: TABSSessionComponentManager;
  Initialized:           Boolean;
  WideStringsStack:      TList;

type

////////////////////////////////////////////////////////////////////////////////
//
//  TABSQueryDataLink
//
////////////////////////////////////////////////////////////////////////////////

  TABSQueryDataLink = class(TDetailDataLink)
  private
    FQuery: TABSQuery;
  protected
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
    function GetDetailDataSet: TDataSet; override;
    procedure CheckBrowseMode; override;
  public
    constructor Create(AQuery: TABSQuery);
  end;


////////////////////////////////////////////////////////////////////////////////
//
//  TABSQueryDataLink
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSQueryDataLink.Create(AQuery: TABSQuery);
begin
  inherited Create;
  FQuery := AQuery;
end;// Create


//------------------------------------------------------------------------------
// ActiveChanged
//------------------------------------------------------------------------------
procedure TABSQueryDataLink.ActiveChanged;
begin
  if FQuery.Active then
    FQuery.RefreshParams;
end;// ActiveChanged


//------------------------------------------------------------------------------
// GetDetailDataSet
//------------------------------------------------------------------------------
function TABSQueryDataLink.GetDetailDataSet: TDataSet;
begin
  Result := FQuery;
end;// GetDetailDataSet


//------------------------------------------------------------------------------
// RecordChanged
//------------------------------------------------------------------------------
procedure TABSQueryDataLink.RecordChanged(Field: TField);
begin
  if (Field = nil) and FQuery.Active
    then FQuery.RefreshParams;
end;// RecordChanged


//------------------------------------------------------------------------------
// CheckBrowseMode
//------------------------------------------------------------------------------
procedure TABSQueryDataLink.CheckBrowseMode;
begin
  if FQuery.Active then
    FQuery.CheckBrowseMode;
end;// CheckBrowseMode




//------------------------------------------------------------------------------
// inits engine
//------------------------------------------------------------------------------
procedure InitializeABSEngine;
begin
  if (not Initialized) then
   begin
     Initialized:=True;
     CurrentSessionManager:=TABSSessionComponentManager.Create;
   end;
end;


//------------------------------------------------------------------------------
// finalizes engine
//------------------------------------------------------------------------------
procedure FinalizeABSEngine;
begin
  if (Initialized) then
   begin
     Initialized:=False;
     CurrentSessionManager.Free;
   end;
end;

//------------------------------------------------------------------------------
// gets default session
//------------------------------------------------------------------------------
function ABSDefaultSession: TABSSession;
begin
   Result := ABSMain.Session;
end;

//------------------------------------------------------------------------------
// gets current session manager
//------------------------------------------------------------------------------
function ABSGetCurrentSession: TABSSessionComponentManager;
begin
  if (not Initialized) then
   raise EABSException.Create(20007, ErrorAEngineNotInitialized);
  Result := CurrentSessionManager;
end;

//------------------------------------------------------------------------------
// sets current session manager
//------------------------------------------------------------------------------
procedure ABSSetCurrentSession(Value: TABSSessionComponentManager);
begin
  CurrentSessionManager := Value;
end;

//------------------------------------------------------------------------------
// creates session manager
//------------------------------------------------------------------------------
procedure ABSStartSession(var Value: TABSSessionComponentManager);
begin
  Value := TABSSessionComponentManager.Create;
end;

//------------------------------------------------------------------------------
// frees session manager
//------------------------------------------------------------------------------
procedure ABSCloseSession(Value: TABSSessionComponentManager);
begin
  if (Value <> nil) then
    Value.Free;
end;


////////////////////////////////////////////////////////////////////////////////
//
// EABSEngineError
//
////////////////////////////////////////////////////////////////////////////////

constructor EABSEngineError.Create(ErrorCode: Integer; ErrMessage: string = '');
begin
   inherited Create('');
   FErrorCode := ErrorCode;
   case FErrorCode of
     ABS_ERR_INSERT_RECORD: FErrorMessage := ErrorLAddingRecord;
     ABS_ERR_UPDATE_RECORD: FErrorMessage := ErrorLUpdatingRecord;
     ABS_ERR_DELETE_RECORD: FErrorMessage := ErrorLDeletingRecord;
     ABS_ERR_UPDATE_RECORD_MODIFIED: FErrorMessage := ErrorLUpdateRecordModified;
     ABS_ERR_DELETE_RECORD_MODIFIED: FErrorMessage := ErrorLDeleteRecordModified;
     ABS_ERR_UPDATE_RECORD_DELETED: FErrorMessage := ErrorLUpdateRecordDeleted;
     ABS_ERR_DELETE_RECORD_DELETED: FErrorMessage := ErrorLDeleteRecordDeleted;
     ABS_ERR_CONSTRAINT_VIOLATED: FErrorMessage := ErrMessage;
     ABS_ERR_UPDATE_RECORD_PROHIBITED: FErrorMessage := ErrorLUpdateRecordProhibited;
     ABS_ERR_DELETE_RECORD_PROHIBITED: FErrorMessage := ErrorLDeleteRecordProhibited;
     ABS_ERR_CANCEL_PROHIBITED: FErrorMessage := ErrorLCancelProhibited;
     ABS_ERR_RECORD_LOCKED: FErrorMessage := ErrorARecordLocked;
     ABS_ERR_TABLE_LOCKED: FErrorMessage := ErrorATableLocked;
   end;
   inherited Message:='Absolute Engine Error # '+IntToStr(ErrorCode)+' '+FErrorMessage;
end;




////////////////////////////////////////////////////////////////////////////////
//
//  TABSSessionList
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
constructor TABSSessionList.Create;
begin
  inherited Create;
  FSessions:=TThreadList.Create;
  FSessionNumbers:=TBits.Create;
  InitializeCriticalSection(FCSect);
end;// Create


//------------------------------------------------------------------------------
// destructor
//------------------------------------------------------------------------------
destructor TABSSessionList.Destroy;
begin
  CloseAll;
  DeleteCriticalSection(FCSect);
  FSessionNumbers.Free;
  FSessions.Free;
  inherited Destroy;
end;// Destroy


//------------------------------------------------------------------------------
// adds session to list
//------------------------------------------------------------------------------
procedure TABSSessionList.AddSession(ASession: TABSSession);
var
  List: TList;
begin
  List:=FSessions.LockList;
  try
   if (List.Count=0) then
     ASession.FDefault:=True;
   List.Add(ASession);
  finally
   FSessions.UnlockList;
  end;
end;// AddSession


//------------------------------------------------------------------------------
// closes all sessions
//------------------------------------------------------------------------------
procedure TABSSessionList.CloseAll;
var
  I: Integer;
  List: TList;
begin
  List:=FSessions.LockList;
  try
    for I:=List.Count-1 downto 0 do
      TABSSession(List[I]).Free;
  finally
    FSessions.UnlockList;
  end;
end;// CloseAll


//------------------------------------------------------------------------------
// Gets sessions count
//------------------------------------------------------------------------------
function TABSSessionList.GetCount: Integer;
var
  List: TList;
begin
  List:=FSessions.LockList;
  try
    Result:=List.Count;
  finally
    FSessions.UnlockList;
  end;
end;// GetCount


//------------------------------------------------------------------------------
// gets current session
//------------------------------------------------------------------------------
function TABSSessionList.GetCurrentSession: TABSSession;
var
  Handle: TABSSessionComponentManager;
  I: Integer;
  List: TList;
begin
  List:=FSessions.LockList;
  try
    Handle := CurrentSessionManager;
    for I:=0 to List.Count-1 do
      begin
       if (TABSSession(List[I]).FHandle=Handle) then
         begin
           Result:=TABSSession(List[I]);
           Exit;
         end;
      end;
    Result:=nil;
  finally
    FSessions.UnlockList;
  end;
end;// GetCurrentSession


//------------------------------------------------------------------------------
// Gets session by No
//------------------------------------------------------------------------------
function TABSSessionList.GetSession(Index: Integer): TABSSession;
var
  List: TList;
begin
  List:=FSessions.LockList;
  try
    Result:=TABSSession(List[Index]);
  finally
    FSessions.UnlockList;
  end;
end;// GetSession


//------------------------------------------------------------------------------
// Gets session by Name
//------------------------------------------------------------------------------
function TABSSessionList.GetSessionByName(const SessionName: string): TABSSession;
begin
  if (SessionName = '') then
    Result:=Session
  else
    Result := FindSession(SessionName);
  if (Result = nil) then
    raise EABSException.Create(20002, ErrorAInvalidSessionName, [SessionName]);
end;// GetSessionByName


//------------------------------------------------------------------------------
// Finds session by name
//------------------------------------------------------------------------------
function TABSSessionList.FindSession(const SessionName: string): TABSSession;
var
  I: Integer;
  List: TList;
begin
  if (SessionName='') then
    Result:=Session
  else
    begin
      List:=FSessions.LockList;
      try
        for I:=0 to List.Count-1 do
          begin
            Result:=List[I];
            if CompareText(Result.SessionName,SessionName)=0 then
               Exit;
          end;
        Result:=nil;
      finally
        FSessions.UnlockList;
      end;
    end;
end;// FindSession


//------------------------------------------------------------------------------
// Gets list of sessions names
//------------------------------------------------------------------------------
procedure TABSSessionList.GetSessionNames(List: TStrings);
var
  I: Integer;
  SList: TList;
begin
  List.BeginUpdate;
  try
    List.Clear;
    SList:=FSessions.LockList;
    try
      for I:=0 to SList.Count-1 do
        with TABSSession(SList[I]) do
          List.Add(SessionName);
    finally
      FSessions.UnlockList;
    end;
  finally
    List.EndUpdate;
  end;
end;// GetSessionNames


//------------------------------------------------------------------------------
// Opens session by name
//------------------------------------------------------------------------------
function TABSSessionList.OpenSession(const SessionName: string): TABSSession;
begin
  Result:=FindSession(SessionName);
  if (Result=nil) then
    begin
      Result:=TABSSession.Create(nil);
      Result.SessionName:=SessionName;
    end;
  Result.SetActive(True);
end;// OpenSession


//------------------------------------------------------------------------------
// Sets current session
//------------------------------------------------------------------------------
procedure TABSSessionList.SetCurrentSession(Value: TABSSession);
begin
  ABSSetCurrentSession(Value.FHandle);
end;// SetCurrentSession


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
//  TABSSession
//
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
constructor TABSSession.Create(AOwner: TComponent);
begin
  ValidateAutoSession(AOwner,False);
  inherited Create(AOwner);
  FDatabases:=TList.Create;
  Sessions.AddSession(Self);
  FKeepConnections:=True;
  FHandle := nil;
end;// Create


//------------------------------------------------------------------------------
// destructor
//------------------------------------------------------------------------------
destructor TABSSession.Destroy;
begin
  SetActive(False);
  Sessions.FSessions.Remove(Self);
  FDatabases.Free;
  inherited Destroy;
end;// Destroy


//------------------------------------------------------------------------------
// adds database
//------------------------------------------------------------------------------
procedure TABSSession.AddDatabase(Value: TABSDatabase);
begin
  FDatabases.Add(Value);
  DBNotification(dbAdd,Value);
end;// AddDatabase


//------------------------------------------------------------------------------
// raises exception if active
//------------------------------------------------------------------------------
procedure TABSSession.CheckInactive;
begin
  if Active then
    DatabaseError(ErrorASessionActive, Self);
end;// CheckInactive


//------------------------------------------------------------------------------
// closes session
//------------------------------------------------------------------------------
procedure TABSSession.Close;
begin
  SetActive(False);
end;// Close


//------------------------------------------------------------------------------
// closes database
//------------------------------------------------------------------------------
procedure TABSSession.CloseDatabase(Database: TABSDatabase);
begin
  with Database do
  begin
    if FRefCount <> 0 then Dec(FRefCount);
    if (FRefCount = 0) and not KeepConnection then
      if not Temporary then Close else
         if not (csDestroying in ComponentState) then Free;
  end;
end;// CloseDatabase


//------------------------------------------------------------------------------
// sends notification
//------------------------------------------------------------------------------
procedure TABSSession.DBNotification(DBEvent: TABSDatabaseEvent; const Param);
begin
  if Assigned(FOnDBNotify) then FOnDBNotify(DBEvent, Param);
end;// DBNotification


//------------------------------------------------------------------------------
// drops all connections
//------------------------------------------------------------------------------
procedure TABSSession.DropConnections;
var
  I: Integer;
begin
  for I := FDatabases.Count - 1 downto 0 do
    with TABSDatabase(FDatabases[I]) do
      if Temporary and (FRefCount = 0) then
        Free;
end;// DropConnections


//------------------------------------------------------------------------------
// finds database by name
//------------------------------------------------------------------------------
function TABSSession.FindDatabase(const DatabaseName: string): TABSDatabase;
var
  I: Integer;
begin
  LockSession;
  try
    for I := 0 to FDatabases.Count - 1 do
    begin
      Result := FDatabases[I];
      if ((Result.DatabaseName <> '') or Result.Temporary) and
        (CompareText(Result.DatabaseName, DatabaseName) = 0) then
          Exit;
    end;
  finally
    UnlockSession;
  end;
  Result := nil;
end;// FindDatabase


//------------------------------------------------------------------------------
// finds database with specified owner
//------------------------------------------------------------------------------
function TABSSession.DoFindDatabase(const DatabaseName: string; AOwner: TComponent): TABSDatabase;
var
  I: Integer;
begin
  LockSession;
  try
    if AOwner <> nil then
      for I := 0 to FDatabases.Count - 1 do
      begin
        Result := FDatabases[I];
        if (Result.Owner = AOwner) and (Result.HandleShared) and
           (CompareText(Result.DatabaseName, DatabaseName) = 0) then
            Exit;
      end;
  finally
    UnlockSession;
  end;
  Result := FindDatabase(DatabaseName);
end;// DoFindDatabase


//------------------------------------------------------------------------------
// session is active?
//------------------------------------------------------------------------------
function TABSSession.GetActive: Boolean;
begin
  Result := FHandle <> nil;
end;// GetActive


//------------------------------------------------------------------------------
// gets database by No
//------------------------------------------------------------------------------
function TABSSession.GetDatabase(Index: Integer): TABSDatabase;
begin
  Result := FDatabases[Index];
end;// GetDatabase


//------------------------------------------------------------------------------
// gets count of connected databases
//------------------------------------------------------------------------------
function TABSSession.GetDatabaseCount: Integer;
begin
  Result := FDatabases.Count;
end;// GetDatabaseCount


//------------------------------------------------------------------------------
// get list of database names
//------------------------------------------------------------------------------
procedure TABSSession.GetDatabaseNames(List: TStrings);
var
  I: Integer;
  Names: TStringList;
begin
  Names := TStringList.Create;
  try
    Names.Sorted := True;
    for I := 0 to FDatabases.Count - 1 do
      with TABSDatabase(FDatabases[I]) do
         Names.Add(DatabaseName);
    List.Assign(Names);
  finally
    Names.Free;
  end;
end;// GetDatabaseNames


//------------------------------------------------------------------------------
// get list of database tables
//------------------------------------------------------------------------------
procedure TABSSession.GetTableNames(const DatabaseName: string; List: TStrings);
var
   Database: TABSDatabase;
begin
  List.BeginUpdate;
  try
    List.Clear;
    if (DatabaseName <> '') then
      begin
        Database := OpenDatabase(DatabaseName);
        try
          if (Database <> nil) and (Database.Handle <> nil) then
            Database.Handle.GetTablesList(List);
        finally
          CloseDatabase(Database);
        end;
      end;
  finally
     List.EndUpdate;
  end;
end;// GetTableNames


//------------------------------------------------------------------------------
// gets handle
//------------------------------------------------------------------------------
function TABSSession.GetHandle: TABSSessionComponentManager;
begin
  if (FHandle <> nil) then
    ABSSetCurrentSession(FHandle)
  else
    SetActive(True);
  Result:=FHandle;
end;// GetHandle


//------------------------------------------------------------------------------
// loaded
//------------------------------------------------------------------------------
procedure TABSSession.Loaded;
begin
  inherited Loaded;
  if AutoSessionName then
     SetSessionNames;
  if FStreamedActive then
     SetActive(True);
end;// Loaded


//------------------------------------------------------------------------------
// locks session
//------------------------------------------------------------------------------
procedure TABSSession.LockSession;
begin
  EnterCriticalSection(FCSect);
  try
    MakeCurrent;
  except
    UnlockSession;
    raise;
  end;
end;


//------------------------------------------------------------------------------
// unlocks session
//------------------------------------------------------------------------------
procedure TABSSession.UnlockSession;
begin
  LeaveCriticalSection(FCSect);
end;// UnlockSession


//------------------------------------------------------------------------------
// makes session current
//------------------------------------------------------------------------------
procedure TABSSession.MakeCurrent;
begin
  if (FHandle <> nil) then
    ABSSetCurrentSession(FHandle)
  else
    SetActive(True);
end;// MakeCurrent


//------------------------------------------------------------------------------
// send notification to datasets and databases
//------------------------------------------------------------------------------
procedure TABSSession.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if AutoSessionName and (Operation=opInsert) then
    begin
      if (AComponent is TABSDataSet) then
        TABSDataSet(AComponent).FSessionName:=Self.SessionName
      else
       if (AComponent is TABSDatabase) then
        TABSDatabase(AComponent).FSession:=Self;
      end;
end;// Notification


//------------------------------------------------------------------------------
// opens session
//------------------------------------------------------------------------------
procedure TABSSession.Open;
begin
  SetActive(True);
end;// Open


//------------------------------------------------------------------------------
// opens database (thread-safe)
//------------------------------------------------------------------------------
function TABSSession.DoOpenDatabase(const DatabaseName: string;
                                     AOwner: TComponent): TABSDatabase;
var
  TempDatabase: TABSDatabase;
begin
  Result := nil;
  LockSession;
  try
    TempDatabase := nil;
    try
      Result := DoFindDatabase(DatabaseName, AOwner);
      if Result = nil then
      begin
        TempDatabase := TABSDatabase.Create(Self);
        TempDatabase.DatabaseName := DatabaseName;
        TempDatabase.KeepConnection := FKeepConnections;
        TempDatabase.Temporary := True;
        TempDatabase.SilentMode := True;
        Result := TempDatabase;
      end;
      Result.Open;
      Inc(Result.FRefCount);
    except
      TempDatabase.Free;
      raise;
    end;
  finally
    UnlockSession;
  end;
end;// DoOpenDatabase


//------------------------------------------------------------------------------
// find DB manager by db name
//------------------------------------------------------------------------------
function TABSSession.FindDatabaseHandle(const DatabaseName: string): TABSBaseSession;
var
  I: Integer;
  DB: TABSDatabase;
begin
  for I := 0 to FDatabases.Count - 1 do
  begin
    DB := FDatabases[I];
    if (DB.Handle <> nil) and
       (CompareText(DB.DatabaseName, DatabaseName) = 0) and
       DB.HandleShared then
    begin
      Result := DB.Handle;
      Exit;
    end;
  end;
  Result := nil;
end;// FindDatabaseHandle


//------------------------------------------------------------------------------
// opens database
//------------------------------------------------------------------------------
function TABSSession.OpenDatabase(const DatabaseName: string): TABSDatabase;
begin
  Result := DoOpenDatabase(DatabaseName,nil);
end;// OpenDatabase


//------------------------------------------------------------------------------
// not auto-session?
//------------------------------------------------------------------------------
function TABSSession.SessionNameStored: Boolean;
begin
  Result := not FAutoSessionName;
end;// SessionNameStored


//------------------------------------------------------------------------------
// removes database from list
//------------------------------------------------------------------------------
procedure TABSSession.RemoveDatabase(Value: TABSDatabase);
begin
  EnterCriticalSection(FCSect);
  try
    FDatabases.Remove(Value);
  finally
    LeaveCriticalSection(FCSect);
  end;
  DBNotification(dbRemove, Value);
end;// RemoveDatabase


//------------------------------------------------------------------------------
// opens session
//------------------------------------------------------------------------------
procedure TABSSession.SetActive(Value: Boolean);
begin
  if csReading in ComponentState then
    FStreamedActive := Value
  else
    if Active <> Value then
      StartSession(Value);
end;// SetActive


//------------------------------------------------------------------------------
// sets auto-session name
//------------------------------------------------------------------------------
procedure TABSSession.SetAutoSessionName(Value: Boolean);
begin
  if Value <> FAutoSessionName then
  begin
    if Value then
    begin
      CheckInActive;
      ValidateAutoSession(Owner, True);
      FSessionNumber := -1;
      EnterCriticalSection(FCSect);
      try
        with Sessions do
        begin
          FSessionNumber := FSessionNumbers.OpenBit;
          FSessionNumbers[FSessionNumber] := True;
        end;
      finally
        LeaveCriticalSection(FCSect);
      end;
      UpdateAutoSessionName;
    end
    else
    begin
      if FSessionNumber > -1 then
      begin
        EnterCriticalSection(FCSect);
        try
          Sessions.FSessionNumbers[FSessionNumber] := False;
        finally
          LeaveCriticalSection(FCSect);
        end;
      end;
    end;
    FAutoSessionName := Value;
  end;
end;// SetAutoSessionName


//------------------------------------------------------------------------------
// set name of component
//------------------------------------------------------------------------------
procedure TABSSession.SetName(const NewName: TComponentName);
begin
  inherited SetName(NewName);
  if FAutoSessionName then
    UpdateAutoSessionName;
end;// SetName


//------------------------------------------------------------------------------
// sets the name of session
//------------------------------------------------------------------------------
procedure TABSSession.SetSessionName(const Value: string);
var
  Ses: TABSSession;
begin
  if (FAutoSessionName and (not FUpdatingAutoSessionName)) then
   DatabaseError(ErrorAAutoSessionActive,Self);
  CheckInActive;
  if Value <> '' then
   begin
    Ses := Sessions.FindSession(Value);
    if (not ((Ses = nil) or (Ses = Self))) then
      DatabaseErrorFmt(ErrorADuplicateSessionName, [Value], Self);
   end;
  FSessionName := Value
end;// SetSessionName


//------------------------------------------------------------------------------
// sets session name to datasets and databases
//------------------------------------------------------------------------------
procedure TABSSession.SetSessionNames;
var
  I: Integer;
  Component: TComponent;
begin
  if Owner <> nil then
    for I := 0 to Owner.ComponentCount - 1 do
    begin
      Component := Owner.Components[I];
      if (Component is TABSDataSet) and
        (CompareText(TABSDataSet(Component).SessionName, Self.SessionName) <> 0) then
        TABSDataSet(Component).SessionName := Self.SessionName
      else if (Component is TABSDatabase) and
        (CompareText(TABSDatabase(Component).SessionName, Self.SessionName) <> 0) then
        TABSDatabase(Component).SessionName := Self.SessionName
    end;
end;// SetSessionNames


//------------------------------------------------------------------------------
// starts session
//------------------------------------------------------------------------------
procedure TABSSession.StartSession(Value: Boolean);
var
  I: Integer;
begin
  EnterCriticalSection(FCSect);
  try
    if Value then
      begin
        if Assigned(FOnStartup) then
          FOnStartup(Self);
        // session name missing?
        if (FSessionName = '') then
         DatabaseError(ErrorASessionNameMissing, Self);
        // activate default session
        if (ABSDefaultSession <> Self) then
            ABSDefaultSession.Active:=True;
        // default session?
        if FDefault then
          begin
            InitializeABSEngine;
            FHandle := ABSGetCurrentSession;
          end
        else
          ABSStartSession(FHandle);
      end
    else
     begin
       ABSSetCurrentSession(FHandle);
       for I:=FDatabases.Count-1 downto 0 do
         begin
           with TABSDatabase(FDatabases[I]) do
             begin
               if Temporary then
                 Free
               else
                 Close;
             end;
         end;
       if FDefault then
         FinalizeABSEngine
       else
         begin
           ABSCloseSession(FHandle);
           ABSSetCurrentSession(Session.FHandle);
         end;
       FHandle:=nil;
     end;
  finally
    LeaveCriticalSection(FCSect);
  end;
end;// StartSession


//------------------------------------------------------------------------------
// updates auto-session name
//------------------------------------------------------------------------------
procedure TABSSession.UpdateAutoSessionName;
begin
  FUpdatingAutoSessionName := True;
  try
    SessionName := Format('%s_%d', [Name, FSessionNumber + 1]);
  finally
    FUpdatingAutoSessionName := False;
  end;
  SetSessionNames;
end;// UpdateAutoSessionName


//------------------------------------------------------------------------------
// auto-session name is valid?
//------------------------------------------------------------------------------
procedure TABSSession.ValidateAutoSession(AOwner: TComponent; AllSessions: Boolean);
var
  I: Integer;
  Component: TComponent;
begin
  if AOwner <> nil then
    for I := 0 to AOwner.ComponentCount - 1 do
    begin
      Component := AOwner.Components[I];
      if (Component <> Self) and (Component is TABSSession) then
        if AllSessions then
         DatabaseError(ErrorAAutoSessionExclusive, Self)
        else
        if TABSSession(Component).AutoSessionName then
         DatabaseErrorFmt(ErrorAAutoSessionExists, [Component.Name], Self);
    end;
end;// ValidateAutoSession


////////////////////////////////////////////////////////////////////////////////
//
// TABSDataset
//
////////////////////////////////////////////////////////////////////////////////

{$IFDEF D6H}
//--- IProviderSupport

//------------------------------------------------------------------------------
// GetUpdateException
//------------------------------------------------------------------------------
function TABSDataset.PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSGetUpdateException';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := inherited PSGetUpdateException(E, Prev);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSGetUpdateException


//------------------------------------------------------------------------------
// IsSQLSupported
//------------------------------------------------------------------------------
function TABSDataset.PSIsSQLSupported: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSIsSQLSupported';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := True;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSIsSQLSupported


//------------------------------------------------------------------------------
// Reset
//------------------------------------------------------------------------------
procedure TABSDataset.PSReset;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSReset';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    inherited PSReset;
    if Active then
      begin
        Close;
        Open;
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSReset


//------------------------------------------------------------------------------
// UpdateRecord
//------------------------------------------------------------------------------
function TABSDataset.PSUpdateRecord(UpdateKind: TUpdateKind; Delta: TDataSet): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSUpdateRecord';{$ENDIF}
var
  UpdateAction: TUpdateAction;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := False; // fixed in 6.03 to support records editing
//    Result := True;
    if Assigned(OnUpdateRecord) then
    begin
      UpdateAction := uaFail;
      if Assigned(FOnUpdateRecord) then
      begin
        FOnUpdateRecord(Delta, UpdateKind, UpdateAction);
        Result := UpdateAction = uaApplied;
      end;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSUpdateRecord


//------------------------------------------------------------------------------
// StartTransaction
//------------------------------------------------------------------------------
procedure TABSDataset.PSStartTransaction;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSStartTransaction';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetDBFlag(dbfProvider, True);
    try
      Database.StartTransaction;
    except
      SetDBFlag(dbfProvider, False);
      raise;
    end
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSStartTransaction


//------------------------------------------------------------------------------
// EndTransaction
//------------------------------------------------------------------------------
procedure TABSDataset.PSEndTransaction(Commit: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSEndTransaction';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    try
      if (Commit) then
        Database.Commit
      else
        Database.Rollback;
    finally
      SetDBFlag(dbfProvider, False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSEndTransaction


//------------------------------------------------------------------------------
// ExecuteStatemnt
//------------------------------------------------------------------------------
{$IFDEF D17H}
function TABSDataset.PSExecuteStatement(const ASQL: string; AParams: TParams;
      var ResultSet: TDataSet): Integer;
{$ELSE}
function TABSDataset.PSExecuteStatement(const ASQL: string; AParams: TParams;
  ResultSet: Pointer = nil): Integer;
{$ENDIF}
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSExecuteStatement';{$ENDIF}
{var
  InProvider: Boolean;}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    // 6.09 fix - to remove AV
{    SetDBFlag(dbfProvider, True);
    InProvider := dbfProvider in DBFlags;}
    try
      ResultSet := TABSQuery.Create(nil);
      TABSQuery(ResultSet).DatabaseName := FDatabaseName;
      TABSQuery(ResultSet).SessionName := FSessionName;
      TABSQuery(ResultSet).InMemory := FInMemory;
      TABSQuery(ResultSet).SQL.Text := ASQL;
      TABSQuery(ResultSet).FParams.Assign(AParams);
      TABSQuery(ResultSet).ExecSQL;
      Result := TABSQuery(ResultSet).RowsAffected;
    finally
{      if InProvider then
        SetDBFlag(dbfProvider, False);}
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSExecuteStatement

{$IFDEF D17H}
function TABSDataset.PSExecuteStatement(const ASQL: string; AParams: TParams): Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSExecuteStatement';{$ENDIF}
var ResultSet: TDataSet;
{  InProvider: Boolean;}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    // 6.09 fix - to remove AV
{    SetDBFlag(dbfProvider, True);
    InProvider := dbfProvider in DBFlags;}
    try
      ResultSet := TABSQuery.Create(nil);
      TABSQuery(ResultSet).DatabaseName := FDatabaseName;
      TABSQuery(ResultSet).SessionName := FSessionName;
      TABSQuery(ResultSet).InMemory := FInMemory;
      TABSQuery(ResultSet).SQL.Text := ASQL;
      TABSQuery(ResultSet).FParams.Assign(AParams);
      TABSQuery(ResultSet).ExecSQL;
      Result := TABSQuery(ResultSet).RowsAffected;
    finally
{      if InProvider then
        SetDBFlag(dbfProvider, False);}
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSExecuteStatement
{$ENDIF}


//------------------------------------------------------------------------------
// GetAttributes
//------------------------------------------------------------------------------
procedure TABSDataset.PSGetAttributes(List: TList);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSGetAttributes';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    inherited PSGetAttributes(List);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSGetAttributes


//------------------------------------------------------------------------------
// GetQuoteChar
//------------------------------------------------------------------------------
function TABSDataset.PSGetQuoteChar: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSGetQuoteChar';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    //Result := '';
    Result := '`';
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSGetQuoteChar


//------------------------------------------------------------------------------
// InTransaction
//------------------------------------------------------------------------------
function TABSDataset.PSInTransaction: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSInTransaction';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle <> nil) then
      Result := FHandle.Session.InTransaction
    else
      Result := False;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSInTransaction


//------------------------------------------------------------------------------
// IsSQLBased
//------------------------------------------------------------------------------
function TABSDataset.PSIsSQLBased: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.PSIsSQLBased';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := True;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSIsSQLBased


{$ENDIF} // D6H

//------------------------------------------------------------------------------
// init key buffer
//------------------------------------------------------------------------------
function TABSDataset.InitKeyBuffer(Buffer: TABSRecordBuffer): TABSRecordBuffer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.InitKeyBuffer';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10280,ErrorLNilPointer);
    Result := Buffer;
    FHandle.InternalInitKeyBuffer(Result);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InitKeyBuffer


//------------------------------------------------------------------------------
// allocate key buffers
//------------------------------------------------------------------------------
procedure TABSDataset.AllocKeyBuffers;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.AllocKeyBuffers';{$ENDIF}
var
  KeyIndex: TABSKeyIndex;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10281,ErrorLNilPointer);
    try
      for KeyIndex := Low(TABSKeyIndex) to High(TABSKeyIndex) do
        FKeyBuffers[KeyIndex] := InitKeyBuffer(FHandle.AllocateKeyRecordBuffer);
    except
      FreeKeyBuffers;
      raise;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // AllocKeyBuffers


//------------------------------------------------------------------------------
// free key buffers
//------------------------------------------------------------------------------
procedure TABSDataset.FreeKeyBuffers;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.FreeKeyBuffers';{$ENDIF}
var
  KeyIndex: TABSKeyIndex;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    for KeyIndex := Low(TABSKeyIndex) to High(TABSKeyIndex) do
     if (FKeyBuffers[KeyIndex] <> nil) then
      FreeRecordBuffer(FKeyBuffers[KeyIndex]);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // FreeKeyBuffers


//------------------------------------------------------------------------------
// field defs support
//------------------------------------------------------------------------------
function TABSDataset.FieldDefsStored: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.FieldDefsStored';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := StoreDefs and (FieldDefs.Count > 0);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // FieldDefsStored


//------------------------------------------------------------------------------
// index defs support
//------------------------------------------------------------------------------
function TABSDataset.IndexDefsStored: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.IndexDefsStored';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := StoreDefs and (IndexDefs.Count > 0);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // IndexDefsStored


//------------------------------------------------------------------------------
// set index definitions
//------------------------------------------------------------------------------
procedure TABSDataset.SetIndexDefs(Value: TIndexDefs);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SetIndexDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    IndexDefs.Assign(Value);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetIndexDefs


//------------------------------------------------------------------------------
// get active buffer
//------------------------------------------------------------------------------
function TABSDataSet.GetActiveRecordBuffer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.GetActiveRecordBuffer';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   case State of
        dsBrowse:
          if IsEmpty then Result := nil else Result := TAbsPByte(ActiveBuffer);
        dsCalcFields:
          Result := TAbsPByte(CalcBuffer);
        dsFilter:
          Result := FFilterBuffer;
        dsEdit,dsInsert:
          Result:=TAbsPByte(ActiveBuffer);
        dsOldValue:
          Result:=FEditRecordBuffer;
        dsSetKey:
          Result := TAbsPByte(FKeyBuffer);
          else Result:=nil;
   end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetActiveRecordBuffer


//------------------------------------------------------------------------------
// check session name
//------------------------------------------------------------------------------
procedure TABSDataset.CheckDBSessionName;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.CheckDBSessionName';{$ENDIF}
var
  S: TABSSession;
  Database: TABSDatabase;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (SessionName <> '') and (DatabaseName <> '') then
    begin
      S := Sessions.FindSession(SessionName);
      if (Assigned(S) and not Assigned(S.DoFindDatabase(DatabaseName, Self))) then
      begin
        Database := ABSDefaultSession.DoFindDatabase(DatabaseName, Self);
        if Assigned(Database) then
         Database.CheckSessionName(True);
      end;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CheckDBSessionName


//------------------------------------------------------------------------------
// get base session
//------------------------------------------------------------------------------
function TABSDataset.GetDBHandle: TABSBaseSession;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetDBHandle';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if FDatabase <> nil then
      Result := FDatabase.Handle
    else
      Result := nil;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetDBHandle


//------------------------------------------------------------------------------
// get ABSSession
//------------------------------------------------------------------------------
function TABSDataset.GetDBSession: TABSSession;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetDBSession';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FDatabase <> nil) then
      Result := FDatabase.Session
    else
      Result := Sessions.FindSession(SessionName);
    if Result = nil then
     Result := ABSDefaultSession;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetDBSession


//------------------------------------------------------------------------------
// set InMemory property if memory database
//------------------------------------------------------------------------------
procedure TABSDataset.CheckInMemoryDatabaseName;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.CheckInMemoryDatabaseName';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (CompareText(FDatabaseName, ABSMemoryDatabaseName) = 0) then
      FInMemory := True
    else
      FInMemory := False;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CheckInMemoryDatabaseName


//------------------------------------------------------------------------------
// set specified database name
//------------------------------------------------------------------------------
procedure TABSDataset.SetDatabaseName(const Value: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SetDatabaseName';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if csReading in ComponentState then
     begin
      FDatabaseName := Value;
      CheckInMemoryDatabaseName;
     end
    else if FDatabaseName <> Value then
    begin
      CheckInactive;
      if FDatabase <> nil then
       DatabaseError(ErrorADatabaseOpen, Self);
      FDatabaseName := Value;
      CheckInMemoryDatabaseName;
      DataEvent(dePropertyChange, 0);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetDatabaseName


//------------------------------------------------------------------------------
// set specified session name
//------------------------------------------------------------------------------
procedure TABSDataset.SetSessionName(const Value: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SetSessionName';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    FSessionName := Value;
    DataEvent(dePropertyChange, 0);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetSessionName


//------------------------------------------------------------------------------
// set in-memory
//------------------------------------------------------------------------------
procedure TABSDataset.SetInMemory(const Value: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SetInMemory';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    FInMemory := Value;
    if (Value) then
     FDatabaseName := ABSMemoryDatabaseName;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetInMemory


//------------------------------------------------------------------------------
// return current version
//------------------------------------------------------------------------------
function TABSDataSet.GetCurrentVersion: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.GetCurrentVersion';{$ENDIF}
var c : AnsiChar;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   c := AnsiChar({$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif});
   {$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif} := '.';
   Result := FloatToStrF(ABSVersion,ffFixed,3,2) + ' ' + ABSVersionText;
   {$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif} := Char(c);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetCurrentVersion


//------------------------------------------------------------------------------
// open cursor
//------------------------------------------------------------------------------
procedure TABSDataSet.OpenCursor(InfoQuery: Boolean);
const FunctionName = 'TABSDataSet.OpenCursor';
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (DatabaseName = '') then
     DatabaseError(ErrorABlankDatabaseName, Self);
   SetDBFlag(dbfOpened, True);
   if (FHandle = nil) then
      FHandle := CreateHandle;
   if (FHandle = nil) then
      raise EABSException.Create(20001, ErrorAHandleError);
   inherited OpenCursor(InfoQuery);
   {$IFDEF DEBUG_TRACE_DATASET} if (FHandle = nil) then aaWriteToLog('TABSDataSet.OpenCursor nil 2');{$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// OpenCursor


//------------------------------------------------------------------------------
// close cursor
//------------------------------------------------------------------------------
procedure TABSDataSet.CloseCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.CloseCursor';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   inherited CloseCursor;
   if (FHandle <> nil) then
     DestroyHandle;
   SetDBFlag(dbfOpened, False);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CloseCursor


//------------------------------------------------------------------------------
// disconnect
//------------------------------------------------------------------------------
procedure TABSDataset.Disconnect;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.Disconnect';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Close;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// Disconnect


//------------------------------------------------------------------------------
// set DBFlag
//------------------------------------------------------------------------------
procedure TABSDataset.SetDBFlag(Flag: Integer; Value: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SetDBFlag';{$ENDIF}
var
  S: TAbsSession;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Value then
      begin
        if (not (Flag in FDBFlags)) then
          begin
           if (FDBFlags=[]) then
             begin
              CheckDBSessionName;
              FDatabase := OpenDatabase;
              FDatabase.FDataSets.Add(Self);
             end;
           Include(FDBFlags,Flag);
         end;
      end
    else
      begin
        if (Flag in FDBFlags) then
          begin
           Exclude(FDBFlags,Flag);
           if (FDBFlags=[]) then
             begin
               try
                 S:= FDatabase.Session;
                 S.LockSession;
                 FDatabase.FDataSets.Remove(Self);
                 FDatabase.Session.CloseDatabase(FDatabase);
                 FDatabase := nil;
               finally
                 S.UnlockSession;
               end;
             end;
          end;
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetDBFlag


//------------------------------------------------------------------------------
// create handle
//------------------------------------------------------------------------------
function TABSDataSet.CreateHandle: TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.CreateHandle';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   Result := nil;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CreateHandle


//------------------------------------------------------------------------------
// destroy handle
//------------------------------------------------------------------------------
procedure TABSDataSet.DestroyHandle;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.DestroyHandle';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FExternalHandle = nil) then
    if (FHandle <> nil) then
      begin
        FHandle.FSettingProjection := False;
        FreeAndNil(FHandle);
      end;
   FHandle := nil;
   FExternalHandle := nil;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// DestroyHandle


//------------------------------------------------------------------------------
// GetCanModify
//------------------------------------------------------------------------------
function TABSDataset.GetCanModify: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetCanModify';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result:=(inherited GetCanModify and (not ReadOnly));
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetCanModify


//------------------------------------------------------------------------------
// DateTimeConvert
//------------------------------------------------------------------------------
procedure TABSDataset.DateTimeConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.DateTimeConvert';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    case Field.DataType of
     ftDate:
       begin
        if ToNative then
          TABSDate(Dest^) := DateToABSDate(Double(Source^))
        else
          Double(Dest^) := ABSDateToDate(TABSDate(Source^));
       end;
     ftDateTime:
       begin
        if ToNative then
          TABSDateTime(Dest^) := DateTimeToABSDateTime(TDateTime(Source^))
        else
          TDateTime(Dest^) := ABSDateTimeToDateTime(TABSDateTime(Source^));
       end;
     ftTime:
       begin
        if ToNative then
          TABSTime(Dest^) := TimeToABSTime(Double(Source^))
        else
          Double(Dest^) := ABSTimeToTime(TABSTime(Source^));
       end;

  {$IFDEF D6H}
     ftTimeStamp:
       begin
        if ToNative then
          begin
            TABSDateTime(Dest^) := DateTimeToABSDateTime(SQLTimeStampToDateTime(TSQLTimeStamp(Source^)));
          end
        else
          begin
            TSQLTimeStamp(Dest^) := DateTimeToSQLTimeStamp(ABSDateTimeToDateTime(TABSDateTime(Source^)));
          end;
       end;
  {$ENDIF}
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// DateTimeConvert


//------------------------------------------------------------------------------
// DataConvert
//------------------------------------------------------------------------------
procedure TABSDataset.DataConvert(Field: TField; Source, Dest: Pointer;
  ToNative: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.DataConvert';{$ENDIF}
const x: Word = 0;
{$IFNDEF D10H}
var L: Integer;
{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    case Field.DataType of
     ftDate, ftTime{, ftDateTime}:
       DateTimeConvert(Field, Source, Dest, ToNative);
  {$IFDEF D6H}
     ftTimeStamp:
       DateTimeConvert(Field, Source, Dest, ToNative);
  {$ENDIF}
     ftWideString:
       begin
       {$IFDEF D10H}
         inherited DataConvert(Field, Source, Dest, ToNative);
       {$ELSE}
        if ToNative then
          begin
           L := Length(PWideChar(Source^));
           if (L <= 0) then
            Move(x,Dest^,2)
           else
            begin
             if (L <= Field.Size) then
              Move(PWideChar(Source^)^, Dest^, (L+1)*2)
             else
              begin
               Move(PWideChar(Source^)^, Dest^, Field.Size*2);
               Move(x, (PAnsiChar(Dest)+Field.Size*2 - 2)^, 2);
              end;
            end;
          end
         else
          begin
//           Move(PWideChar(Source)^, Dest^, Length(WideString(PWideChar(Source)))*2+2);
           WideString(Dest^) := WideString(PWideChar(Source));
          end;
       {$ENDIF}
       end;//ftWideString
     else
      begin
       {$IFDEF D5H}
       inherited DataConvert(Field, Source, Dest, ToNative);
       {$ENDIF}
      end
    end;//case
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//DataConvert


{$IFDEF D18H}
//------------------------------------------------------------------------------
// DataConvert
//------------------------------------------------------------------------------
procedure TABSDataset.DataConvert(Field: TField; Source: TValueBuffer; var Dest: TValueBuffer; ToNative: Boolean);
begin
  DataConvert(Field, Pointer(Source), Pointer(Dest), ToNative);
end;
{$ELSE}
{$IFDEF D17H}
//------------------------------------------------------------------------------
// DataConvert
//------------------------------------------------------------------------------
procedure TABSDataset.DataConvert(Field: TField; Source, Dest: TValueBuffer; ToNative: Boolean);
begin
  DataConvert(Field, Pointer(Source), Pointer(Dest), ToNative);
end;
{$ENDIF}
{$ENDIF}

//------------------------------------------------------------------------------
// SetActive
//------------------------------------------------------------------------------
procedure TABSDataset.SetActive(Value: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SetActive';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (csReading in ComponentState) and (StartDisconnected) then exit;
   if (State in [dsEdit,dsInsert]) and (Value = False) then
     InternalCancel;
   inherited;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//SetActive


//------------------------------------------------------------------------------
// switch to index
//------------------------------------------------------------------------------
procedure TABSDataset.SwitchToIndex(const IndexName: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SwitchToIndex';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   ResetCursorRange;
   UpdateCursorPos;
   if (FHandle <> nil) then
      FHandle.IndexName := IndexName;
   FKeySize := 0;
   FIndexFieldCount := 0;
   GetIndexInfo;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SwitchToIndex


//------------------------------------------------------------------------------
// check whether field is in index
//------------------------------------------------------------------------------
function TABSDataset.GetIsIndexField(Field: TField): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetIsIndexField';{$ENDIF}
var
  I: Integer;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result:=False;
    with Field do
     if FieldNo > 0 then
       for I := 0 to FIndexFieldCount - 1 do
        if FIndexFieldMap[I] = FieldNo then
          begin
            Result := True;
            Exit;
          end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetIsIndexField


//------------------------------------------------------------------------------
// get info of acive index
//------------------------------------------------------------------------------
procedure TABSDataSet.GetIndexInfo;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.GetIndexInfo';{$ENDIF}
var
  ABSIndexDef: TABSIndexDef;
  i:           Integer;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle <> nil) and (FHandle.IndexName <> '') then
     begin
       ABSIndexDef := FHandle.IndexDefs.GetIndexDefByName(FHandle.IndexName);
       if (ABSIndexDef = nil) then
         raise EABSException.Create(10325,ErrorLCannotFindIndex,[FHandle.IndexName]);
       FIndexFieldCount := ABSIndexDef.ColumnCount;
       SetLength(FIndexFieldMap,FIndexFieldCount);
       FKeySize := 0;
       for i := 0 to FIndexFieldCount - 1 do
        begin
          FIndexFieldMap[i] := FHandle.FieldDefs.GetDefNumberByName(
                                ABSIndexDef.Columns[i].FieldName) + 1;
          Inc(FKeySize,FHandle.FieldDefs[FIndexFieldMap[i]-1].MemoryDataSize);
        end;
     end
    else
     begin
       FIndexFieldMap := nil;
       FIndexFieldCount := 0;
       FKeySize := 0;
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetIndexInfo


//------------------------------------------------------------------------------
// ResetCursorRange
//------------------------------------------------------------------------------
function TABSDataSet.ResetCursorRange: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.ResetCursorRange';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
     raise EABSException.Create(10287,ErrorLNilPointer);
    Result := False;
    if (PABSKeyBuffer(FKeyBuffers[kiCurRangeStart] + FHandle.KeyOffset)^.Modified or
      PABSKeyBuffer(FKeyBuffers[kiCurRangeEnd] + FHandle.KeyOffset)^.Modified) then
     begin
      InitKeyBuffer(FKeyBuffers[kiCurRangeStart]);
      InitKeyBuffer(FKeyBuffers[kiCurRangeEnd]);
      Result := True;
     end;
    FHandle.ResetRange;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// ResetCursorRange


//------------------------------------------------------------------------------
// clear calculated fields
//------------------------------------------------------------------------------
procedure TABSDataSet.ClearCalcFields(Buffer: TAbsPByte);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.ClearCalcFields';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (Buffer = nil) then
    raise EABSException.Create(10039,ErrorLNilPointer);
   if (FHandle = nil) then
    raise EABSException.Create(10040,ErrorLNilPointer);
   if (CalcFieldsSize > 0) then
    FillChar(Buffer[FHandle.CalculatedFieldsOffset],CalcFieldsSize,0);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ClearCalcFields


//------------------------------------------------------------------------------
// refresh
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalRefresh;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalRefresh';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (Active) then
     begin
       if (IsOnFilterRecordApplied) then
         FHandle.DisableRecordBitmap;
//    commented in 4.83 ((bug-fix for filtered Query.Refresh after table update leading to the hiding active query record)
//    DataEvent(deDataSetChange, 0);
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;


//------------------------------------------------------------------------------
// get record
//------------------------------------------------------------------------------
function TABSDataSet.GetRecord(Buffer: TAbsPByte; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.GetRecord';{$ENDIF}
var ABSGetMode:   TABSGetRecordMode;
    ABSGetResult: TABSGetRecordResult;
    Bookmark:     PABSBookmarkInfo;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10041,ErrorLNilPointer);
   case (GetMode) of
    gmCurrent: ABSGetMode := grmCurrent;
    gmNext: ABSGetMode := grmNext;
    gmPrior: ABSGetMode := grmPrior
   else
    ABSGetMode := grmCurrent;
   end;
   FHandle.CurrentRecordBuffer := Buffer;

   ABSGetResult := FHandle.GetRecordBuffer(ABSGetMode);

   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog('FHandle.GetRecordBuffer called');{$ENDIF}

   case (ABSGetResult) of
    grrOK:
     begin
      Result := grOK;
      // write bookmark info to record buffer
      Bookmark := PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset);
      Bookmark^.BookmarkData := FHandle.CurrentRecordID;
      Bookmark^.BookmarkFlag := abfCurrent;
      // bug fix 4.86 (bookmark value could be required in calc fields for blob streams)
      ClearCalcFields(Buffer);
      GetCalcFields(Buffer);
     end;
    grrBOF: Result := grBOF;
    grrEOF: Result := grEOF
   else
    Result := grError;
   end;
   if (Result = grError) and DoCheck then
    raise EABSException.Create(10026,ErrorLGetRecordFailed);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetRecord


//------------------------------------------------------------------------------
// GetCurrentRecord
//------------------------------------------------------------------------------
function TABSDataset.GetCurrentRecord(Buffer: TAbsPByte): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetCurrentRecord';{$ENDIF}
var
  OldBuffer: TABSRecordBuffer;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle <> nil) then
      begin
        if ((not IsEmpty) and (GetBookmarkFlag(ActiveBuffer) = bfCurrent)) then
           begin
             UpdateCursorPos;
             OldBuffer := FHandle.CurrentRecordBuffer;
             FHandle.CurrentRecordBuffer := Buffer;
             try
               Result := (FHandle.GetRecordBuffer(grmCurrent) = grrOK);
             finally
               FHandle.CurrentRecordBuffer := OldBuffer;
             end;
           end
        else
          Result:=False;
      end
    else
      Result:=False;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetCurrentRecord


//------------------------------------------------------------------------------
// return record count
//------------------------------------------------------------------------------
function TABSDataset.GetRecordCount: Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetRecordCount';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (not Active) then
     Result := 0
   else
     begin
       if (FHandle = nil) then
        raise EABSException.Create(10056,ErrorLNilPointer);
       Result := FHandle.RecordCount;
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetRecordCount


//------------------------------------------------------------------------------
// go to record
//------------------------------------------------------------------------------
procedure TABSDataSet.SetRecNo(Value: Integer);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetRecNo';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   CheckBrowseMode; //  <<< It make Post before Resync.
   if (FHandle = nil) then
    raise EABSException.Create(10042,ErrorLNilPointer);
   DoBeforeScroll;
   FHandle.SetRecNo(Value);
   Resync([rmCenter]);
   DoAfterScroll;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetRecNo


//------------------------------------------------------------------------------
// return current record number
//------------------------------------------------------------------------------
function TABSDataSet.GetRecNo: Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.GetRecNo';{$ENDIF}
var
  Pos: Pointer;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10043,ErrorLNilPointer);
   if (State = dsInsert) then
    Result := -1
   else
    begin
     // bug-fix 4.85
//     FHandle.CurrentRecordBuffer := GetActiveRecordBuffer;
     if (State=dsCalcFields) then
       FHandle.CurrentRecordBuffer := TABSRecordBuffer(CalcBuffer)
     else
       FHandle.CurrentRecordBuffer := TABSRecordBuffer(ActiveBuffer);
     if (FHandle.CurrentRecordBuffer = nil) then
      Result := -1
     else
      begin
        Pos := FHandle.SavePosition;
        try
          FHandle.FirstPosition := False;
          FHandle.LastPosition := False;
          FHandle.CurrentRecordID :=
            PABSBookmarkInfo(FHandle.CurrentRecordBuffer + FHandle.BookmarkOffset)^.BookmarkData;
          Result := FHandle.GetRecNo;
        finally
          FHandle.RestorePosition(Pos);
          FHandle.FreePosition(Pos);
        end;
      end;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetRecNo


//------------------------------------------------------------------------------
// go to first record (before first record to BOF)
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalFirst;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalFirst';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10044,ErrorLNilPointer);
   FHandle.InternalFirst;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalFirst


//------------------------------------------------------------------------------
// go to last record (after last record to EOF)
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalLast;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalLast';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10045,ErrorLNilPointer);
   FHandle.InternalLast;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalLast


//------------------------------------------------------------------------------
// go to record in buffer
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalSetToRecord(Buffer: TAbsPByte);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalSetToRecord';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10046,ErrorLNilPointer);
   if (Buffer = nil) then
    raise EABSException.Create(10047,ErrorLNilPointer);
   InternalGotoBookmark(Buffer + FHandle.BookmarkOffset);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalSetToRecord


//------------------------------------------------------------------------------
// get bookmark flag
//------------------------------------------------------------------------------
function TABSDataSet.GetBookmarkFlag(Buffer: TAbsPByte): TBookmarkFlag;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.GetBookmarkFlag';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (Buffer = nil) then
    raise EABSException.Create(10059,ErrorLNilPointer);
   if (FHandle = nil) then
    raise EABSException.Create(10060,ErrorLNilPointer);
   Result := bfCurrent;
   case PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset)^.BookmarkFlag  of
    abfCurrent:
       Result := bfCurrent;
    abfBOF:
       Result := bfBOF;
    abfEOF:
       Result := bfEOF;
    abfInserted:
       Result := bfInserted;
   end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetBookmarkFlag


//------------------------------------------------------------------------------
// get bookmark data
//------------------------------------------------------------------------------
procedure TABSDataSet.GetBookmarkData(Buffer: TAbsPByte; Data: Pointer);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.GetBookmarkData';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (Buffer = nil) then
    raise EABSException.Create(10034,ErrorLNilPointer);
   if (Data = nil) then
    raise EABSException.Create(10035,ErrorLNilPointer);
   if (FHandle = nil) then
    raise EABSException.Create(10036,ErrorLNilPointer);
   // copy bookmark
   Move(PAnsiChar(Buffer + FHandle.BookmarkOffset)^,PAnsiChar(Data)^,Sizeof(TABSRecordID));
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetBookmarkData

{$IFDEF D17H}
//------------------------------------------------------------------------------
// get bookmark data
//------------------------------------------------------------------------------
procedure TABSDataset.GetBookmarkData(Buffer: TRecordBuffer; Data: TBookmark);
begin
  GetBookmarkData(TAbsPByte(Buffer), Pointer(Data));
end;
{$ENDIF}


//------------------------------------------------------------------------------
// go to bookmark
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalGotoBookmark(Bookmark: Pointer);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalGotoBookmark';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (Bookmark = nil) then
    raise EABSException.Create(10037,ErrorLNilPointer);
   if (FHandle = nil) then
    raise EABSException.Create(10038,ErrorLNilPointer);
   FHandle.CurrentRecordID :=
     PABSBookmarkInfo(Bookmark)^.BookmarkData;
   FHandle.FirstPosition := False;
   FHandle.LastPosition := False;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalGotoBookmark


//------------------------------------------------------------------------------
// set flag
//------------------------------------------------------------------------------
procedure TABSDataSet.SetBookmarkFlag(Buffer: TAbsPByte; Value: TBookmarkFlag);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetBookmarkFlag';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10057,ErrorLNilPointer);
   case Value of
    bfCurrent:
      PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset)^.BookmarkFlag :=
        abfCurrent;
    bfBOF:
      PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset)^.BookmarkFlag :=
        abfBOF;
    bfEOF:
      PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset)^.BookmarkFlag :=
        abfEOF;
    bfInserted:
      PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset)^.BookmarkFlag :=
        abfInserted;
   end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetBookmarkFlag


//------------------------------------------------------------------------------
// set data
//------------------------------------------------------------------------------
procedure TABSDataSet.SetBookmarkData(Buffer: TAbsPByte; Data: Pointer);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetBookmarkData';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10058,ErrorLNilPointer);
   if (Buffer = nil) then
    raise EABSException.Create(10061,ErrorLNilPointer);
   if (Data = nil) then Exit;
   // copy bookmark
   Move(PAnsiChar(Data)^,PAnsiChar(Buffer + FHandle.BookmarkOffset)^,Sizeof(TABSRecordID));
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetBookmarkData

{$IFDEF D17H}
//------------------------------------------------------------------------------
// set data
//------------------------------------------------------------------------------
procedure TABSDataSet.SetBookmarkData(Buffer: TRecordBuffer; Data: TBookmark);
begin
  SetBookmarkData(TAbsPByte(Buffer), Pointer(Data));
end; // SetBookmarkData
{$ENDIF}

//------------------------------------------------------------------------------
// compare bookmarks
//------------------------------------------------------------------------------
function TABSDataSet.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.CompareBookmarks';{$ENDIF}
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2,-1),(1,0));
var 
    RecordID1, RecordID2: TABSRecordID;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10063,ErrorLNilPointer);
   Result := RetCodes[Bookmark1 = nil, Bookmark2 = nil];
   if Result = 2 then
    begin
        Move(PAnsiChar(Bookmark1)^,RecordID1,Sizeof(TABSRecordID));
        Move(PAnsiChar(Bookmark2)^,RecordID2,Sizeof(TABSRecordID));
        Result := FHandle.CompareRecordsOrder(RecordID1, RecordID2);
    end; // Result = 2
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // CompareBookmarks


//------------------------------------------------------------------------------
// checks if bookmark is valid
//------------------------------------------------------------------------------
function TABSDataSet.BookmarkValid(Bookmark: TBookmark): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.BookmarkValid';{$ENDIF}
var
    OldPos:               Pointer;
    OldBuffer:            TAbsPByte;
    TempBuffer:           TAbsPByte;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := (FHandle <> nil) and (Bookmark <> nil);
    if Result then
      begin
         CursorPosChanged;
         OldPos := FHandle.SavePosition;
         OldBuffer := FHandle.CurrentRecordBuffer;
         TempBuffer := FHandle.AllocateRecordBuffer;
         FHandle.CurrentRecordBuffer := TempBuffer;
         FHandle.FirstPosition := False;
         FHandle.LastPosition := False;
         try
           Move(PAnsiChar(Bookmark)^,FHandle.CurrentRecordID,sizeof(TABSRecordID));
           Result := (FHandle.GetRecordBuffer(grmCurrent) = grrOK);
         finally
           FHandle.RestorePosition(OldPos);
           FHandle.FreePosition(OldPos);
           FHandle.FreeRecordBuffer(TempBuffer);
           FHandle.CurrentRecordBuffer := OldBuffer;
         end;
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // BookmarkValid


//------------------------------------------------------------------------------
// return True if OnFilterRecord is applied and Fitlered is True
//------------------------------------------------------------------------------
function TABSDataSet.IsOnFilterRecordApplied: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.IsOnFilterRecordApplied';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := Filtered and (Assigned(OnFilterRecord));
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // IsOnFilterRecordApplied


//------------------------------------------------------------------------------
// return True if OnFilterRecord is applied and Fitlered is True
//------------------------------------------------------------------------------
function TABSDataSet.InternalFilterRecord(Buffer: TABSRecordBuffer): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalFilterRecord';{$ENDIF}
var
 SaveState: TDataSetState;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (IsOnFilterRecordApplied) then
    begin
     SaveState := SetTempState(dsFilter);
     FFilterBuffer := Buffer;
     try
       OnFilterRecord(Self,Result);
     except
         {$IFDEF D6H}
       ApplicationHandleException(Self);
         {$ELSE}
         Application.HandleException(Self)
         {$ENDIF}
     end;
     RestoreState(SaveState);
    end
   else
    Result := True;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;


//------------------------------------------------------------------------------
// return Accept if OnFilterRecord accepts current record
//------------------------------------------------------------------------------
function TABSDataSet.FilterRecord(Buffer: TABSRecordBuffer; Dataset: Pointer): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.FilterRecord';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := TABSDataSet(Dataset).InternalFilterRecord(Buffer);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // FilterRecord


//------------------------------------------------------------------------------
// applies OnFilterRecord
//------------------------------------------------------------------------------
procedure TABSDataSet.SetOnFilterRecord(const Value: TFilterRecordEvent);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetOnFilterRecord';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Active then
     begin
      if (FHandle = nil) then
       raise EABSException.Create(10275,ErrorLNilPointer);
      CheckBrowseMode;
      if (Assigned(OnFilterRecord) <> Assigned(Value)) then
       begin
        if (Filtered) then
         ActivateFilters
        else
         DeactivateFilters;
      end;
      inherited SetOnFilterRecord(Value);
      if (Filtered) then First;
     end
    else
     inherited SetOnFilterRecord(Value);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;


//------------------------------------------------------------------------------
// return true if index applied
//------------------------------------------------------------------------------
function TABSDataSet.IsIndexApplied: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.IsIndexApplied';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10381,ErrorLNilPointer);
   Result := (FHandle.FIndexID <> INVALID_OBJECT_ID);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // IsIndexApplied


//------------------------------------------------------------------------------
// prepare cursor
//------------------------------------------------------------------------------
procedure TABSDataSet.PrepareCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.PrepareCursor';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PrepareCursor


//------------------------------------------------------------------------------
// set SQL Filter
//------------------------------------------------------------------------------
procedure TABSDataSet.SetSQLFilter(FilterExpr: TObject; ParentQueryAO: TObject; ParentCursor: TABSCursor);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetSQLFilter';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10300,ErrorLNilPointer);
    FHandle.SetSQLFilter(FilterExpr, ParentQueryAO, ParentCursor);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetSQLFilter


//------------------------------------------------------------------------------
// apply projection
//------------------------------------------------------------------------------
procedure TABSDataSet.ApplyProjection(FieldNamesList, AliasList: TStringList);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.ApplyProjection';{$ENDIF}
var
  tmp: TABSCursor;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10320,ErrorLNilPointer);
    FHandle.ApplyProjection(FieldNamesList,AliasList);
    FHandle.FSettingProjection := True;
    FExternalHandle := FHandle;
    FExternalHandle.FirstPosition := True;
    try
      tmp := FExternalHandle;
      Close;
      FExternalHandle := tmp;
      try
       Open;
       if (Database <> nil) then
         FHandle.Session := Database.Handle;
      except
        Close;
        FExternalHandle.FSettingProjection := False;
        Open;
        raise;
      end;
    finally
      FExternalHandle.FSettingProjection := False;
      FExternalHandle := nil;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ApplyProjection


//------------------------------------------------------------------------------
// activate filters
//------------------------------------------------------------------------------
procedure TABSDataSet.ActivateFilters;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.ActivateFilters';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10269,ErrorLNilPointer);
   // Filter property based filters
   if (Filter <> '') then
     FHandle.ActivateFilters(Filter,(foCaseInsensitive in FilterOptions),
    (not (foNoPartialCompare in FilterOptions)))
   else
    FHandle.DeactivateFilters;
   if (Assigned(OnFilterRecord)) then
     FHandle.FilterRecord := @TABSDataset.FilterRecord
   else
     FHandle.FilterRecord := nil;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ActivateFilters


//------------------------------------------------------------------------------
// deactivate filters
//------------------------------------------------------------------------------
procedure TABSDataSet.DeactivateFilters;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.DeactivateFilters';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10270,ErrorLNilPointer);
   FHandle.DeactivateFilters;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // DeactivateFilters


//------------------------------------------------------------------------------
// set filter
//------------------------------------------------------------------------------
procedure TABSDataSet.SetFilterData(const Text: string; Options: TFilterOptions);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetFilterData';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Active then
     begin
      CheckBrowseMode;
      if (FHandle = nil) then
       raise EABSException.Create(10266,ErrorLNilPointer);
     end;
    inherited SetFilterText(Text);
    inherited SetFilterOptions(Options);
    if (Active and Filtered) then
      begin
        ActivateFilters;
        First;
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetFilterData


//------------------------------------------------------------------------------
// set filtered
//------------------------------------------------------------------------------
procedure TABSDataSet.SetFiltered(Value: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetFiltered';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (Active) then
     begin
      CheckBrowseMode;
      if (FHandle = nil) then
       raise EABSException.Create(10267,ErrorLNilPointer);
      if (Filtered <> Value) then
       begin
        // filtered changed
        if (Value) then
         ActivateFilters
        else
         DeactivateFilters;
        inherited SetFiltered(Value);
      end;
      if (Value) then
        First
      else
        Refresh; // 6.07 fix
     end
    else
     inherited SetFiltered(Value);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetFiltered


//------------------------------------------------------------------------------
// set filter options
//------------------------------------------------------------------------------
procedure TABSDataSet.SetFilterOptions(Value: TFilterOptions);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetFilterOptions';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetFilterData(Filter, Value);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetFilterOptions


//------------------------------------------------------------------------------
// set filter text
//------------------------------------------------------------------------------
procedure TABSDataSet.SetFilterText(const Value: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.SetFilterText';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetFilterData(Value, FilterOptions);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetFilterText


//------------------------------------------------------------------------------
// FindFirst, FindNext, Filters
//------------------------------------------------------------------------------
function TABSDataSet.FindRecord(Restart, GoForward: Boolean): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.FindRecord';{$ENDIF}
var Buffer:     TABSRecordBuffer;
    GetResult:  TGetResult;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckBrowseMode;
    DoBeforeScroll;
    SetFound(False);
    if (FHandle = nil) then
     raise EABSException.Create(10268,ErrorLNilPointer);
    UpdateCursorPos;
    CursorPosChanged;
    if (not Filtered) then
     ActivateFilters;
    Buffer := AllocRecordBuffer;
    try
     if GoForward then
      begin
       if (Restart) then
        InternalFirst;
       GetResult := GetRecord(Buffer,gmNext,False);
      end
     else
      begin
       if (Restart) then
        InternalLast;
       GetResult := GetRecord(Buffer,gmPrior,False);
      end;
    finally
     FreeRecordBuffer(Buffer);
     if (not Filtered) then
      DeactivateFilters;
    end;
   if (GetResult = grOK) then
    begin
      Resync([rmExact, rmCenter]);
      SetFound(True);
    end;
    Result := Found;
    if (Result) then
      DoAfterScroll;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // FindRecord


//------------------------------------------------------------------------------
// Locate record
//------------------------------------------------------------------------------
function TABSDataSet.LocateRecord(
                         const KeyFields: string;
                         const KeyValues: Variant;
                         Options:         TLocateOptions
                        ): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.LocateRecord';{$ENDIF}
var Buffer: TAbsPByte;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
     raise EABSException.Create(10271,ErrorALocateFailedDatasetClosed);
    CheckBrowseMode;
    CursorPosChanged;
    SetTempState(dsFilter);
    Buffer := TAbsPByte(TempBuffer);
    FFilterBuffer := Buffer;
    try
      FHandle.CurrentRecordBuffer := Buffer;
      Result := FHandle.Locate(
                               KeyFields,KeyValues,
                               (loCaseInsensitive in Options),
                               (loPartialKey in Options)
                              );
    finally
      RestoreState(dsBrowse);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // LocateRecord


//------------------------------------------------------------------------------
// Locate
//------------------------------------------------------------------------------
function TABSDataSet.Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.Locate';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    DoBeforeScroll;
    Result := LocateRecord(string(KeyFields), KeyValues, Options);
    if (Result) then
     begin
      Resync([rmExact, rmCenter]);
      DoAfterScroll;
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // Locate


//------------------------------------------------------------------------------
// Lookup
//------------------------------------------------------------------------------
function TABSDataSet.Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.Lookup';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := Null;
    if (LocateRecord(string(KeyFields), KeyValues, [])) then
    begin
      SetTempState(dsCalcFields);
      try
        CalculateFields(TempBuffer);
        Result := FieldValues[ResultFields];
      finally
        RestoreState(dsBrowse);
      end;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // Lookup


//------------------------------------------------------------------------------
// InitRecord
//------------------------------------------------------------------------------
procedure TABSDataSet.InitRecord(Buffer: TAbsPByte);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InitRecord';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    inherited InitRecord(Buffer);
    PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset)^.BookmarkFlag := abfInserted;
    PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset)^.BookmarkData.PageNo := INVALID_PAGE_NO;
    PABSBookmarkInfo(Buffer + FHandle.BookmarkOffset)^.BookmarkData.PageItemNo := $FFFF;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// InitRecord


//------------------------------------------------------------------------------
// appending table (Append flag - ignored, record will be inserted at first empty position)
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalAddRecord(Buffer: Pointer; Append: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalAddRecord';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (not Active) then
    raise EABSException.Create(10075,ErrorLDatasetIsNotOpened);
   if (State <> dsInsert) then
    raise EABSException.Create(10076,ErrorLDatasetIsNotInInsertOrEditMode);
   if (ReadOnly) then
    raise EABSException.Create(10077,ErrorLDatasetIsInReadOnlyMode);
   if (FHandle = nil) then
    raise EABSException.Create(10078,ErrorLNilPointer);

   FHandle.CurrentRecordBuffer := Buffer;
   FHandle.InternalPost(True);

   // replaced to Check(...) in 6.03
{   if (FHandle.ErrorCode <> ABS_ERR_OK) then
    begin
     if (FHandle.ErrorCode = ABS_ERR_INSERT_RECORD) then
      DatabaseError(ErrorLAddingRecord);
    end;}
   Check(FHandle.ErrorCode, FHandle.ErrorMessage);

  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalAddRecord

{$IFDEF D17H}
procedure TABSDataSet.InternalAddRecord(Buffer: TRecordBuffer; Append: Boolean);
begin
  InternalAddRecord(Pointer(Buffer), Append);
end; // InternalAddRecord
{$ENDIF}

//------------------------------------------------------------------------------
// insert record
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalInsert;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalInsert';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (not ReadOnly) then
     FHandle.InternalInsert;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalInsert


//------------------------------------------------------------------------------
// edit record
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalEdit;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalEdit';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (not ReadOnly) then
     begin
       if (FHandle = nil) then
        raise EABSException.Create(10065,ErrorLNilPointer);
       if (TABSRecordBuffer(ActiveBuffer) = nil) then
        raise EABSException.Create(10067,ErrorLNilPointer);
       FEditRecordBuffer := AllocRecordBuffer;
       Move(TAbsPByte(ActiveBuffer)^,FEditRecordBuffer^,FHandle.RecordSize);
       FHandle.CurrentRecordBuffer := TABSRecordBuffer(ActiveBuffer);
       FHandle.InternalEdit;
       try
         Check(FHandle.ErrorCode, FHandle.ErrorMessage);
       except
         FreeRecordBuffer(FEditRecordBuffer);
         raise;
       end;
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalEdit


//------------------------------------------------------------------------------
// cancels updates
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalCancel;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalCancel';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10066,ErrorLNilPointer);
   if (FEditRecordBuffer <> nil) then
     FreeRecordBuffer(FEditRecordBuffer);
   FHandle.CurrentRecordBuffer := GetActiveRecordBuffer;
   FHandle.InternalCancel(State = dsInsert);
   Check(FHandle.ErrorCode, FHandle.ErrorMessage);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalCancel


//------------------------------------------------------------------------------
// update record
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalPost;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalPost';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
  {$IFDEF D6H}
   inherited InternalPost;
  {$ENDIF}
   if (not Active) then
    raise EABSException.Create(10029,ErrorLDatasetIsNotOpened);
   if (State <> dsInsert) and (State <> dsEdit) then
    raise EABSException.Create(10030,ErrorLDatasetIsNotInInsertOrEditMode);
   if (ReadOnly) then
    raise EABSException.Create(10032,ErrorLDatasetIsInReadOnlyMode);
   if (FHandle = nil) then
    raise EABSException.Create(10048,ErrorLNilPointer);
   FHandle.CurrentRecordBuffer := GetActiveRecordBuffer;
   if (State = dsEdit) then
    FHandle.EditRecordBuffer := FEditRecordBuffer;

   FHandle.InternalPost(State = dsInsert);

   if (State = dsEdit) then
    if (FHandle.ErrorCode = ABS_ERR_OK) then
    FreeRecordBuffer(FEditRecordBuffer);

   Check(FHandle.ErrorCode, FHandle.ErrorMessage);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalPost


//------------------------------------------------------------------------------
// delete record
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalDelete;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalDelete';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (not Active) then
    raise EABSException.Create(10068,ErrorLDatasetIsNotOpened);
   if (ReadOnly) then
    raise EABSException.Create(10069,ErrorLDatasetIsInReadOnlyMode);
   if (FHandle = nil) then
    raise EABSException.Create(10070,ErrorLNilPointer);
   if (TABSRecordBuffer(ActiveBuffer) = nil) then
    raise EABSException.Create(10071,ErrorLNilPointer);
   FHandle.CurrentRecordBuffer := TABSRecordBuffer(ActiveBuffer);
   FHandle.InternalDelete;
   Check(FHandle.ErrorCode, FHandle.ErrorMessage);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalDelete


//------------------------------------------------------------------------------
// internal handle exception
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalHandleException;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalHandleException';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   {$IFNDEF NO_DIALOGS}
   Application.HandleException(Self);
   {$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalHandleException


//------------------------------------------------------------------------------
// is cusor open
//------------------------------------------------------------------------------
function TABSDataSet.IsCursorOpen: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.IsCursorOpen';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := (FHandle <> nil);
  {$IFDEF DEBUG_TRACE_DATASET}
  if (DebugStarted) then
   aaWriteToLog('TABSDataSet.IsCursorOpen DebugStarted = True')
  else
   aaWriteToLog('TABSDataSet.IsCursorOpen DebugStarted = False');

  if (Result) then
   aaWriteToLog('TABSDataSet.IsCursorOpen = True')
  else
   aaWriteToLog('TABSDataSet.IsCursorOpen = False');

  if (Assigned(Designer)) then
   aaWriteToLog('TABSDataSet.IsCursorOpen Designer = True')
  else
   aaWriteToLog('TABSDataSet.IsCursorOpen Designer = False');
  {$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// IsCursorOpen


//------------------------------------------------------------------------------
// internal open
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalOpen;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalOpen';{$ENDIF}
{$IFDEF D5H}
var i: Integer;
{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    {$IFDEF DEBUG_TRACE_DATASET}if (FHandle = nil) then aaWriteToLog('TABSDataSet.InternalOpen - FHandle = nil ');{$ENDIF}
    if (FHandle <> nil) then
      begin
        BookmarkSize := sizeOf(TABSBookmarkInfo);
        FieldDefs.Updated:=False;
        FieldDefs.Update;
        GetIndexInfo;

        if (FEditRecordBuffer <> nil) then
         FreeRecordBuffer(FEditRecordBuffer);
        { TODO : It is not the best way for GUIDs}
  {$IFDEF D5H}
        for i:=0 to FieldDefs.Count-1 do
          if (FieldDefs[i].DataType = ftGuid) then
            FieldDefs[i].Size := 38;
  {$ENDIF}
        if DefaultFields then
          CreateFields;
        BindFields(true);
        // for OnFilterRecord
        FHandle.Dataset := TABSDataset(Self);
        if (FHandle.RecordBufferSize + CalcFieldsSize > FHandle.RecordBufferSize) then
         FHandle.RecordBufferSize := FHandle.RecordBufferSize + CalcFieldsSize;
        if (Filtered) then
         ActivateFilters
        else
         DeactivateFilters;
        AllocKeyBuffers;
        ResetCursorRange;
        PrepareCursor;
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// InternalOpen


//------------------------------------------------------------------------------
// internal close
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalClose;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalClose';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   {$IFDEF DEBUG_TRACE_DATASET}  aaWriteToLog('TABSDataSet.InternalClose - FHandle = nil #1');{$ENDIF}
   if (FHandle <> nil) then
    begin
     if (FEditRecordBuffer <> nil) then
       FreeRecordBuffer(FEditRecordBuffer);
     FreeKeyBuffers;
    end;
  {$IFDEF DEBUG_TRACE_DATASET}
  aaWriteToLog('TABSDataSet.InternalClose, FieldCount = ' + IntToStr(Fields.Count));
  if (FHandle = nil) then
    aaWriteToLog('TABSDataSet.InternalClose - FHandle = nil #2');
  {$ENDIF}
   BindFields(False);
   if DefaultFields then
    DestroyFields;
   FAdvFieldDefs.Clear;
   FABSFieldDefs.Clear;
   FAdvIndexDefs.Clear;
   FABSIndexDefs.Clear;
   FIndexFieldCount := 0;
   FIndexFieldMap := nil;
   FKeySize := 0;
  {$IFDEF DEBUG_TRACE_DATASET}
  aaWriteToLog('TABSDataSet.InternalClose, FieldCount2 = ' + IntToStr(Fields.Count));
  {$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalClose


//------------------------------------------------------------------------------
// init field defs
//------------------------------------------------------------------------------
procedure TABSDataSet.InternalInitFieldDefs;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataSet.InternalInitFieldDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   {$IFDEF DEBUG_TRACE_DATASET}if (FHandle = nil) then aaWriteToLog('TABSDataSet.InternalInitFieldDefs FHandle = nil');{$ENDIF}
   FieldDefs.Clear;
   {$IFDEF DEBUG_TRACE_DATASET}if DebugStarted then  aaWriteToLog('TABSDataSet.InternalInitFieldDefs debug start');{$ENDIF}
   if (FHandle <> nil) then
    begin
     if (not IgnoreDesignMode) then
       FHandle.IsDesignMode := IsDesignMode;
     FHandle.InternalInitFieldDefs;
     // Fill ABSFieldDefs
     FABSFieldDefs.Assign(FHandle.VisibleFieldDefs);
     // Fill FieldDefs
     ConvertABSFieldDefsToFieldDefs(FHandle.VisibleFieldDefs, FHandle.FConstraintDefs, FieldDefs);
     //Fill AdvFieldDefs
     ConvertABSFieldDefsToAdvFieldDefs(FHandle.VisibleFieldDefs,FHandle.FieldDefs, FHandle.FConstraintDefs, AdvFieldDefs);
     FRestructureFieldDefs.Assign(FAdvFieldDefs);
    end;
   {$IFDEF DEBUG_TRACE_DATASET}if DebugStarted then  aaWriteToLog('TABSDataSet.InternalInitFieldDefs debug finish');{$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// InternalInitFieldDefs


//------------------------------------------------------------------------------
// read field data to current record buffer
//------------------------------------------------------------------------------
function TABSDataset.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetFieldData';{$ENDIF}
var RecordBuffer: TAbsPByte;
    t: TDateTime;
    pw: PWideString;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   Result := False;
   RecordBuffer := GetActiveRecordBuffer;
   if (not Active) or (RecordBuffer = nil) then Exit;
  {$IFDEF DEBUG_TRACE_DATASET} aaWriteToLog('Dataset.GetFieldData started - FieldNo = ' + IntToStr(Field.FieldNo));{$ENDIF}
   if (FHandle = nil) then
    raise EABSException.Create(10050,ErrorLNilPointer);
   // this is a calculated or lookup field
   if (Field.FieldKind = fkCalculated) or (Field.FieldKind = fkLookup) then
    begin
     Result := False;
     Inc(RecordBuffer,FHandle.CalculatedFieldsOffset + Field.Offset);
     if (not (byte(RecordBuffer[0]) = 0)) then
      begin
       if (Buffer <> nil) then
         begin
           if (Field.DataType = ftWideString) then
             begin
               Move(TAbsPByte(@RecordBuffer[1])^, pw, sizeof(WideString));
               Move(PWideChar(pw^)^, PWideChar(Buffer)^, (Length(pw^)+1)*2);
             end
           else
             Move(RecordBuffer[1],Buffer^,Field.DataSize);
         end;
       Result := true;
      end;
    end
   else
    begin
     Result := FHandle.GetFieldData(Field.FieldNo-1,Buffer,RecordBuffer);
     // call data convert
     if (Result and (Buffer <> nil)) then
      if (Field.DataType in [ftDate,ftTime,ftDateTime]) then
       begin
          DateTimeConvert(Field,Buffer,@t,False);
          case (Field.DataType) of
           ftDate: TDateTimeRec(Buffer^).Date := Integer(Trunc(t)) + DateDelta;
           ftTime: TDateTimeRec(Buffer^).Time := Integer(Round(Frac(t) * MSecsPerDay));
          else
           TDateTimeRec(Buffer^).DateTime := (t + DateDelta) * MSecsPerDay;
          end;
       end;
    end;
  {$IFDEF DEBUG_TRACE_DATASET}
   if (Result) then
    aaWriteToLog('Dataset.GetFieldData finished - FieldNo = ' +
      IntToStr(Field.FieldNo) + ', Result = True')
   else
    aaWriteToLog('Dataset.GetFieldData finished - FieldNo = ' +
      IntToStr(Field.FieldNo) + ', Result = False');
  {$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetFieldData



{$ifdef D18H}
//------------------------------------------------------------------------------
// read field data to current record buffer
//------------------------------------------------------------------------------
function TABSDataset.GetFieldData(Field: TField; var Buffer: TValueBuffer): Boolean;
begin
  Result := GetFieldData(Field, Pointer(Buffer));
end;
{$else}
{$ifdef D17H}
//------------------------------------------------------------------------------
// read field data to current record buffer
//------------------------------------------------------------------------------
function TABSDataset.GetFieldData(Field: TField; Buffer: TValueBuffer): Boolean;
begin
  Result := GetFieldData(Field, Pointer(Buffer));
end;
{$endif}
{$endif}


//------------------------------------------------------------------------------
// write field data from buffer to current record buffer
//------------------------------------------------------------------------------
procedure TABSDataset.SetFieldData(Field: TField; Buffer: Pointer);

 procedure Finalize;
 begin
  if not (State in [dsCalcFields, dsFilter, dsNewValue]) then
   DataEvent(deFieldChange, {$ifdef D16H}NativeInt{$else}Longint{$endif}(Field));
 end; // Finalize

{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SetFieldData';{$ENDIF}
var
    RecordBuffer: TAbsPByte;
    t: TDateTime;
    pw: PWideString;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog('Dataset.SetFieldData started - FieldNo = ' + IntToStr(Field.FieldNo));{$ENDIF}

   if not (State in dsWriteModes) then
    raise EABSException.Create(10007, ErrorLDatasetIsNotInEditOrInsertMode);

   if ((State = dsSetKey) and
       ((Field.FieldNo < 0) or
        (FIndexFieldCount > 0) and not Field.IsIndexField)) then
    raise EABSException.Create(20019, ErrorANotIndexField, [Field.DisplayName]);

   RecordBuffer := GetActiveRecordBuffer;

   if (FHandle = nil) then
    raise EABSException.Create(10051,ErrorLNilPointer);
   // this is a calculated or lookup field
   if (Field.FieldKind = fkCalculated) or (Field.FieldKind = fkLookup) then
    begin
     Inc(RecordBuffer,FHandle.CalculatedFieldsOffset + Field.Offset);
     Boolean(RecordBuffer[0]) := (Buffer <> nil);
     if Boolean(RecordBuffer[0]) then
       begin
         if (Field.DataType = ftWideString) then
           begin
             Move(TAbsPByte(@RecordBuffer[1])^, pw, sizeof(WideString));
             if (pw = nil) then
               begin
                 New(pw);
                 WideStringsStack.Add(pw);
               end;
             Move(pw,TAbsPByte(@RecordBuffer[1])^, sizeof(WideString));
             pw^ := WideString(PWideChar(Buffer));
           end
         else
           Move(Buffer^,TAbsPByte(@RecordBuffer[1])^,Field.DataSize);
       end;
     Finalize;
    end
   else
    begin
     Field.Validate(Buffer);
     // call data convert
     if (Buffer <> nil) then
      if (Field.DataType in [ftDate,ftTime,ftDateTime]) then
       begin
          case (Field.DataType) of
           ftDate: t := TDateTimeRec(Buffer^).Date - DateDelta;
           ftTime: t := TDateTimeRec(Buffer^).Time / MSecsPerDay;
            else    t := (TDateTimeRec(Buffer^).DateTime / MSecsPerDay) - DateDelta;
          end;
          DateTimeConvert(Field,@t,Buffer,True);
       end;

     FHandle.SetFieldData(Field.FieldNo-1,Buffer,RecordBuffer);
     Finalize;
    end;
  {$IFDEF DEBUG_TRACE_DATASET}  aaWriteToLog('Dataset.SetFieldData finished - FieldNo = ' + IntToStr(Field.FieldNo));  {$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetFieldData


{$ifdef D17H}
//------------------------------------------------------------------------------
// write field data from buffer to current record buffer
//------------------------------------------------------------------------------
procedure TABSDataset.SetFieldData(Field: TField; Buffer: TValueBuffer);
begin
  SetFieldData(Field, Pointer(Buffer));
end;
{$endif}


//------------------------------------------------------------------------------
// get field value
//------------------------------------------------------------------------------
procedure TABSDataset.GetFieldValue(Value: TABSVariant; FieldNo: Integer; DirectAccess: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetFieldValue';{$ENDIF}
var
  Buffer: TAbsPByte;
  bs: TABSBLOBStream;
  BaseFieldType: TABSBaseFieldType;
  VisibleFieldNo, i: Integer;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10315,ErrorLNilPointer);
   FHandle.CurrentRecordBuffer := GetActiveRecordBuffer;

   if (DirectAccess) then
     BaseFieldType := FHandle.FieldDefs[FieldNo].BaseFieldType
   else
     BaseFieldType := FHandle.VisibleFieldDefs[FieldNo].BaseFieldType;

   if (IsBlobFieldType(BaseFieldType)) then
     begin
       Value.SetNull(BaseFieldType);
       VisibleFieldNo := FieldNo;
       if (DirectAccess) then
         begin
           // get visible field No to access fields objects
           for i := 0 to FHandle.VisibleFieldDefs.Count-1 do
             if (FHandle.VisibleFieldDefs[i].FieldNoReference = FieldNo) then
               begin
                 VisibleFieldNo := i;
                 break;
               end;
         end;
       bs := TABSBLOBStream.Create(TBlobField(Fields[VisibleFieldNo]), bmRead);
       try
        if (bs.Size > 0) then
         begin
           Buffer := MemoryManager.AllocMem(bs.Size);
           try
             bs.ReadBuffer(Buffer^, bs.Size);
             Value.SetData(Buffer, bs.Size, BaseFieldType);
           finally
             MemoryManager.FreeAndNillMem(Buffer);
           end;
         end;//if
       finally
         bs.Free;
       end;
     end
   else
     begin
       FHandle.GetFieldValue(Value,FieldNo, DirectAccess);
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetFieldValue



//------------------------------------------------------------------------------
// set field value
//------------------------------------------------------------------------------
procedure TABSDataset.SetFieldValue(Value: TABSVariant; FieldNo: Integer; DirectAccess: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.SetFieldValue';{$ENDIF}
var
  bs: TABSBLOBStream;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10316,ErrorLNilPointer);
   FHandle.CurrentRecordBuffer := GetActiveRecordBuffer;

   if (Fields[FieldNo].IsBlob) then
    begin
     if (not Value.IsNull) then
      begin
       bs := TABSBLOBStream.Create(TBlobField(Fields[FieldNo]), bmWrite);
       try
         bs.WriteBuffer(Value.pData^, MemoryManager.GetMemoryBufferSize(Value.pData));
       finally
         bs.Free;
       end;
      end
     else
      FHandle.SetFieldValue(Value,FieldNo, DirectAccess);
    end
   else
     begin
      FHandle.SetFieldValue(Value,FieldNo, DirectAccess);
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetFieldValue


//------------------------------------------------------------------------------
// CopyFieldValue
//------------------------------------------------------------------------------
procedure TABSDataset.CopyFieldValue(SrcFieldNo: Integer; UseDirectFieldAccess: Boolean;
                            DestFieldNo: Integer; DestDataset: TABSDataset);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.CopyFieldValue';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10500, ErrorLNilPointer);
    if (DestDataset = nil) then
      raise EABSException.Create(10503, ErrorLNilPointer);
    if (DestDataset.Handle = nil) then
      raise EABSException.Create(10504, ErrorLNilPointer);
      
    FHandle.CurrentRecordBuffer := GetActiveRecordBuffer;
    DestDataset.Handle.CurrentRecordBuffer := DestDataset.GetActiveRecordBuffer;
    FHandle.CopyFieldValue(SrcFieldNo, UseDirectFieldAccess, DestFieldNo, DestDataset.Handle);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CopyFieldValue


//------------------------------------------------------------------------------
// create blob stream
//------------------------------------------------------------------------------
function TABSDataset.InternalCreateBlobStream(
              Field:  TField;
              Mode:   TBlobStreamMode
              ): TABSStream;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.InternalCreateBlobStream';{$ENDIF}
var
  OpenMode: TABSBLOBOpenMode;
  OldPos: Pointer;
  OldRecordBuffer: TABSRecordBuffer;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10108,ErrorLNilPointer);
   if (
        ((Mode = bmReadWrite) or (Mode = bmWrite)) and
        (State <> dsInsert) and (State <> dsEdit)
      ) then
    raise EABSException.Create(10111,ErrorLDatasetIsNotInEditOrInsertMode);

   OpenMode := bomRead;
   case Mode of
    bmRead:
      OpenMode := bomRead;
    bmReadWrite:
      OpenMode := bomReadWrite;
    bmWrite:
      OpenMode := bomWrite;
   end;
   OldRecordBuffer := FHandle.CurrentRecordBuffer;
   try
     FHandle.CurrentRecordBuffer := GetActiveRecordBuffer;
     if (FHandle.CurrentRecordBuffer = nil) then
      begin
       Result := FHandle.InternalCreateBlobStream(True, False,
        Field.FieldNo-1,OpenMode, False);
      end
     else
      begin
       OldPos := FHandle.SavePosition;
       try
       Move(TAbsPByte(FHandle.CurrentRecordBuffer + FHandle.BookmarkOffset)^,
        FHandle.CurrentRecordID,sizeof(TABSRecordID));
       Result := FHandle.InternalCreateBlobStream((State = dsInsert),(State = dsEdit),
        Field.FieldNo-1,OpenMode,(State = dsBrowse));
       finally
         FHandle.RestorePosition(OldPos);
         FHandle.FreePosition(OldPos);
       end;
      end;
   finally
     FHandle.CurrentRecordBuffer := OldRecordBuffer;
   end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // InternalCreateBlobStream


//------------------------------------------------------------------------------
// create TABSBlobStream
//------------------------------------------------------------------------------
function TABSDataset.CreateBlobStream(
    					Field:  TField;
              Mode:   TBlobStreamMode
              ): TStream;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.CreateBlobStream';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if ((Mode <> bmRead) and (TABSDataset(Field.DataSet).ReadOnly)) then
    raise EABSException.Create(10107,ErrorLDatasetIsInReadOnlyMode);
   Result := TABSBLOBStream.Create(TBlobField(Field),Mode);
   if (TABSBLOBStream(Result).FBlobStream = nil) then
    if (not FIsRefreshing) then
      begin
        FIsRefreshing := True;
        try
          Refresh;
        finally
          FIsRefreshing := False;
        end;
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // CreateBlobStream


//------------------------------------------------------------------------------
// close blob stream, write blob field value to blob data file
//------------------------------------------------------------------------------
procedure TABSDataset.CloseBlob(Field: TField);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.CloseBlob';{$ENDIF}
var
  OldRecordBuffer: TABSRecordBuffer;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10108,ErrorLNilPointer);
   OldRecordBuffer := FHandle.CurrentRecordBuffer;
   try
     FHandle.CurrentRecordBuffer := GetActiveRecordBuffer;
     FHandle.InternalCloseBlob(Field.FieldNo-1);
   finally
     FHandle.CurrentRecordBuffer := OldRecordBuffer;
   end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // CloseBlob


//------------------------------------------------------------------------------
// Get list of names of all database components
//------------------------------------------------------------------------------
procedure TABSDataset.GetDatabaseNameList(List: TStrings);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetDatabaseNameList';{$ENDIF}
var i: integer;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   List.Clear;
   if (DBSession <> nil) then
    for i:=0 to DBSession.FDatabases.Count-1 do
     List.Add(TABSDatabase(DBSession.FDatabases.Items[i]).DatabaseName);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetDatabaseNameList


//------------------------------------------------------------------------------
// copy records and return error log
//------------------------------------------------------------------------------
function TABSDataset.CopyRecords(DestinationDataset: TDataset): string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.CopyRecords';{$ENDIF}
var
  Log: string;
  Continue: Boolean;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    //Result := CopyDatasets(Self,DestinationDataset);
    Continue := True;
    Log := '';
    InternalCopyRecords(Self,DestinationDataset, Log, Continue);
    Result := Log;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // CopyRecords


//------------------------------------------------------------------------------
// InternalCopyRecords
//------------------------------------------------------------------------------
function TABSDataset.InternalCopyRecords( SourceDataset: TDataset;
                                          DestinationDataset: TDataset;
                                          var Log:      string;
                                          var Continue: Boolean;
                                          IgnoreErrors: Boolean = True;
                                          RestructuringTable: Boolean = False;
                                          ProgressEvent: TABSProgressEvent = nil;
                                          MinProgress: Integer = 0;
                                          MaxProgress: Integer = 100
                                        ): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.InternalCopyRecords';{$ENDIF}
var
  CurrentRecordNo:  Int64;
  i,j,k:            Integer;
  DestFieldNo:      Integer;
  Bookmark:         TBookmark;
  Progress:         Integer;
  ProgressStep:     Integer;
  s:                string;
  SrcField:         TField;
  TableName:        string;
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   //Log := '';
   Result := True;
   if (Self is TABSTable) then
     TableName := TABSTable(Self).TableName
   else
     TableName := 'unknown';
   SourceDataset.CheckBrowseMode;
   CurrentRecordNo := 1;
   if (MaxProgress - MinProgress <> 0) then
     ProgressStep := 1 + SourceDataset.RecordCount div (MaxProgress - MinProgress)
   else
     ProgressStep := 1;
   try
     SourceDataset.Refresh;
   except
   end;
   Bookmark := SourceDataset.GetBookmark;
   try
     SourceDataset.First;
     while not SourceDataset.Eof do
      begin
        DestinationDataset.Insert;
        for k := 0 to SourceDataset.FieldDefs.Count - 1 do
         begin
           if (SourceDataset.Fields.Count = SourceDataset.FieldDefs.Count) then
             i := k
           else
             begin
               SrcField := SourceDataset.FindField(SourceDataset.FieldDefs[k].Name);
               if (SrcField <> nil) then
                 i := SrcField.Index
               else
                 begin
                    if (SourceDataset is TABSTable) then
                      s := TABSTable(SourceDataset).TableName
                    else
                      s := 'unknown';
                    Log := Log + Format(ErrorLNotSupportedFieldType,
                      [s, SourceDataset.FieldDefs[k].Name]);
                    if not IgnoreErrors then
                      raise EABSException.Create(10499, ErrorLNotSupportedFieldType,
                      [s, SourceDataset.FieldDefs[k].Name]);
                    Result := False;
                 end;
             end;

          DestFieldNo := -1;
          if (RestructuringTable) then
            if (SourceDataset is TABSTable) and (DestinationDataset is TABSTable) then
              for j := 0 to TABSTable(SourceDataset).RestructureFieldDefs.Count-1 do
                if (TABSTable(SourceDataset).AdvFieldDefs[i].ObjectID =
                    TABSTable(SourceDataset).RestructureFieldDefs[j].ObjectID) then
                  begin
                    DestFieldNo := j;
                    break;
                  end;
          if (DestFieldNo < 0) then
            if (DestinationDataset.FindField(SourceDataset.Fields[i].FieldName) <> nil) then
              DestFieldNo := DestinationDataset.FieldByName(SourceDataset.Fields[i].FieldName).Index;
          if (DestFieldNo >= 0) then
            try
              // copy field value
              AssignField(SourceDataset.Fields[i], DestinationDataset.Fields[DestFieldNo]);
            except
             on e: Exception do
              begin
                Log := Log + Format(ErrorLCopyTableInvalidFieldValue,
                  [TableName, CurrentRecordNo, SourceDataset.Fields[i].FieldName, e.Message]);
                try
                  DestinationDataset.Fields[DestFieldNo].Clear;
                except
                end;
                if not IgnoreErrors then raise;
                Result := False;
              end;
            end;
         end; // copying fields
        try
         DestinationDataset.Post;
        except
         on e: Exception do
           begin
             Log := Log + Format(ErrorLCopyTablePostFailed, [TableName, CurrentRecordNo ,e.Message]) + #13#10;
             try
               DestinationDataset.Cancel;
             except
             end;
             if not IgnoreErrors then raise;
             Result := False;
           end;
        end;
        Inc(CurrentRecordNo);
        try
          SourceDataset.Next;
        except
          while CurrentRecordNo < SourceDataset.RecordCount do
           begin
             try
               SourceDataset.RecNo := CurrentRecordNo;
               break;
             except
               Log := Log + 'Record #'+IntToStr(CurrentRecordNo)+' corrupted and skipped.' + #13#10;
             end;
             Inc(CurrentRecordNo);
           end;

        end;
        if ((CurrentRecordNo-2) mod Min(ProgressStep, 30) = 0) then
          begin
            Progress := MinProgress + Round(((CurrentRecordNo-1)*(MaxProgress - MinProgress)) / SourceDataset.RecordCount);
            if Assigned(ProgressEvent) then
              begin
                ProgressEvent(SourceDataset, Progress, Continue);
                if not Continue then
                 begin
                  Log := Log + SAborted + #13#10;
                  Result := False;
                  Break;
                 end;
              end;
          end;
      end;
   finally
     SourceDataset.GotoBookmark(Bookmark);
     SourceDataset.FreeBookmark(Bookmark);
   end;
   //Result := (Log = '');
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalCopyRecords


//------------------------------------------------------------------------------
// allocate record buffer
//------------------------------------------------------------------------------
function TABSDataset.AllocRecordBuffer: TAbsPByte;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.AllocRecordBuffer';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog('TABSDataset.AllocRecordBuffer - FHandle = ' + IntToStr(Integer(FHandle)));
     if (FHandle = nil) then aaWriteToLog('TABSDataset.AllocRecordBuffer - FHandle = nil');
    {$ENDIF}
     if (FHandle = nil) then
      raise EABSException.Create(10052,ErrorLNilPointer);
     Result := FHandle.AllocateRecordBuffer;
    {$IFDEF DEBUG_TRACE_DATASET}
    aaWriteToLog('TABSDataset.AllocRecordBuffer: Size=' + IntToStr(FHandle.RecordBufferSize) +
                 '  Address=' + IntToStr(Integer(Pointer(Result))));
    {$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // AllocRecordBuffer


//------------------------------------------------------------------------------
// free record buffer
//------------------------------------------------------------------------------
procedure TABSDataset.FreeRecordBuffer(var Buffer: TAbsPByte);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.FreeRecordBuffer';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog('TABSDataset.FreeRecordBuffer:  - FHandle = ' + IntToStr(Integer(FHandle)) + ' Buffer=' + IntToStr(Integer(Pointer(Buffer))));
     if (FHandle = nil) then  aaWriteToLog('TABSDataset.FreeRecordBuffer - FHandle = nil');
    {$ENDIF}
     if (FHandle = nil) then
      raise EABSException.Create(10053,ErrorLNilPointer);
     FHandle.FreeRecordBuffer(Buffer);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // FreeRecordBuffer


//------------------------------------------------------------------------------
// initialize record buffer
//------------------------------------------------------------------------------
procedure TABSDataset.InternalInitRecord(Buffer: TAbsPByte);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.InternalInitRecord';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10054,ErrorLNilPointer);
   FHandle.InternalInitRecord(Buffer,True);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;

{$IFDEF D17}
procedure TABSDataset.InternalInitRecord(Buffer: TRecordBuffer);
begin
  InternalInitRecord(TAbsPByte(Buffer));
end;
{$ENDIF}

//------------------------------------------------------------------------------
// return record size in bytes
//------------------------------------------------------------------------------
function TABSDataset.GetRecordSize: Word;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.GetRecordSize';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FHandle = nil) then
    raise EABSException.Create(10055,ErrorLNilPointer);
   Result := FHandle.RecordSize - SizeOf(TABSBookmarkInfo);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // Get Record Size


//------------------------------------------------------------------------------
// return true if range is applied
//------------------------------------------------------------------------------
function TABSDataset.IsRangeApplied: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.IsRangeApplied';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10298,ErrorLNilPointer);
    Result := FHandle.IsRangeApplied;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // IsRangeApplied


//------------------------------------------------------------------------------
// return true if distinct is applied
//------------------------------------------------------------------------------
function TABSDataset.IsDistinctApplied: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.IsDistinctApplied';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10326,ErrorLNilPointer);
    Result := (FHandle.DistinctFieldCount > 0);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // IsDistinctApplied


//------------------------------------------------------------------------------
// create
//------------------------------------------------------------------------------
constructor TABSDataset.Create(AOwner: TComponent);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.Create';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    inherited Create(AOwner);
    FExternalHandle := nil;
    FHandle := nil;
    FEditRecordBuffer := nil;
    FIndexDefs := TIndexDefs.Create(Self);
    FABSFieldDefs := TABSFieldDefs.Create;
    FABSIndexDefs := TABSIndexDefs.Create;
    FAdvIndexDefs := TABSAdvIndexDefs.Create(Self);
    FAdvFieldDefs := TABSAdvFieldDefs.Create;
    FRestructureIndexDefs := TABSAdvIndexDefs.Create(Self);
    FRestructureFieldDefs := TABSAdvFieldDefs.Create;
    FABSConstraintDefs := TABSConstraintDefs.Create;
    FIsRefreshing := False;

  {$IFNDEF DEBUG_DESIGN_TIME}
    if (not IsDesignMode) then
     if (AOwner <> nil) then
      if (csDesigning in AOwner.ComponentState) then
  {$ENDIF}
        IsDesignMode := true;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDataset.Destroy;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.Destroy';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (FEditRecordBuffer <> nil) then
    FreeRecordBuffer(FEditRecordBuffer);
   Active := false;
   FIndexDefs.Free;
   FABSFieldDefs.Free;
   FABSIndexDefs.Free;
   FAdvIndexDefs.Free;
   FAdvFieldDefs.Free;
   FRestructureIndexDefs.Free;
   FRestructureFieldDefs.Free;
   FABSConstraintDefs.Free;
   inherited Destroy;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // Destroy


//------------------------------------------------------------------------------
// open database
//------------------------------------------------------------------------------
function TABSDataset.OpenDatabase: TABSDatabase;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.OpenDatabase';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    with Sessions.List[FSessionName] do
      Result := DoOpenDatabase(FDatabaseName, Self.Owner);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// OpenDatabase


//------------------------------------------------------------------------------
// close database
//------------------------------------------------------------------------------
procedure TABSDataset.CloseDatabase(Database: TABSDatabase);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSDataset.CloseDatabase';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(Database) then
      Database.Session.CloseDatabase(Database);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CloseDatabase




//------------------------------------------------------------------------------
// create
//------------------------------------------------------------------------------
constructor TABSExportToSqlOptions.Create;
begin
  inherited;
  FStructure            := True;
  FAddDropTable         := True;
  FBlobSettings         := False;
  FData                 := False;
  FFieldNamesInInserts  := False;
end;//Create


//------------------------------------------------------------------------------
// Assign
//------------------------------------------------------------------------------
procedure TABSExportToSqlOptions.Assign(Source: TPersistent);
var src: TABSExportToSqlOptions;
begin
 if Source is TABSExportToSqlOptions then
  begin
   src := TABSExportToSqlOptions(Source);
   Structure            := src.Structure;
   AddDropTable         := src.AddDropTable;
   BlobSettings         := src.BlobSettings;
   Data                 := src.Data;
   FieldNamesInInserts  := src.FieldNamesInInserts;
  end
 else
  inherited Assign(Source);
end;


////////////////////////////////////////////////////////////////////////////////
//
//  TABSTable
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// check table name is blank?
//------------------------------------------------------------------------------
procedure TABSTable.CheckBlankTableName;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CheckBlankTableName';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (Trim(string(FTableName)) = '') then
      DatabaseError(ErrorANoTableName, Self);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CheckBlankTableName


//------------------------------------------------------------------------------
// AutoCorrect AdvFieldDefs
//------------------------------------------------------------------------------
procedure TABSTable.AutoCorrectAdvFieldDefs;
var
  i: Integer;
  bft: TABSBaseFieldType;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.AutoCorrectAdvFieldDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    for i:=0 to FAdvFieldDefs.Count-1 do
     begin
      bft := AdvancedFieldTypeToBaseFieldType(FAdvFieldDefs[i].DataType);
      // DefaultValue
      if ((not FAdvFieldDefs[i].DefaultValue.IsNull) and
          (FAdvFieldDefs[i].DefaultValue.AsAnsiString = '')) then
        FAdvFieldDefs[i].DefaultValue.SetNull(bft)
      else begin
        try
            // creation-time expression (evaluated at table creation time)
            if (not IsNonConstantExpression(FAdvFieldDefs[i].DefaultValue)) then
              FAdvFieldDefs[i].DefaultValue.Cast(bft);
        except
          FAdvFieldDefs[i].DefaultValue.Cast(bft);
        end;
      end;
      // MinValue
      if ((not FAdvFieldDefs[i].MinValue.IsNull) and
          (FAdvFieldDefs[i].MinValue.AsAnsiString = '')) then
        FAdvFieldDefs[i].MinValue.SetNull(bft)
      else
          FAdvFieldDefs[i].MinValue.Cast(bft);
      // MaxValue
      if ((not FAdvFieldDefs[i].MaxValue.IsNull) and
          (FAdvFieldDefs[i].MaxValue.AsAnsiString = '')) then
        FAdvFieldDefs[i].MaxValue.SetNull(bft)
      else
          FAdvFieldDefs[i].MaxValue.Cast(bft);
      // Size <> 0
      if ( (FAdvFieldDefs[i].Size <> 0) and (not IsStringFieldType(bft)) and
           (bft <> bftBytes) and (bft <> bftVarBytes)) then
        FAdvFieldDefs[i].Size := 0;
      // GUID
      if (FAdvFieldDefs[i].DataType = aftGuid) then
       begin
        FAdvFieldDefs[i].Size := 38;
       end;
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//AutoCorrectAdvFieldDefs


//------------------------------------------------------------------------------
// AutoCorrectFieldDefs
//------------------------------------------------------------------------------
procedure TABSTable.AutoCorrectFieldDefs;
{$IFDEF D5H}
var
  i: Integer;
{$ENDIF}
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.AutoCorrectFieldDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    {$IFDEF D5H}
      for i:=0 to FieldDefs.Count-1 do
        // GUID
        if (FieldDefs[i].DataType = ftGuid) then
          FieldDefs[i].Size := 38;
    {$ENDIF}
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//AutoCorrectFieldDefs


//------------------------------------------------------------------------------
// CheckAdvFieldDefs
//------------------------------------------------------------------------------
procedure TABSTable.CheckAdvFieldDefs;
var
  i: Integer;
  bft: TABSBaseFieldType;
  aft: TABSAdvancedFieldType;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CheckAdvFieldDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    for i:=0 to FAdvFieldDefs.Count-1 do
     begin
      if (FAdvFieldDefs[i].Name = '') then
       raise EABSException.Create(30499, ErrorGMissingFieldName,[i,TableName]);
      aft := FAdvFieldDefs[i].DataType;
      bft := AdvancedFieldTypeToBaseFieldType(aft);
      if ( (FAdvFieldDefs[i].Size <= 0) and (IsStringFieldType(aft) or
                                           (aft = aftBytes) or
                                           (aft = aftVarBytes))) then
        raise EABSException.Create(30453, ErrorGCannotCreateTableWithField,
                                   [TableName, FAdvFieldDefs[i].Name,
                                    BftToStr(bft), FAdvFieldDefs[i].Size]);
      if (IsBLOBFieldType(aft) and
          (FAdvFieldDefs[i].BLOBCompressionAlgorithm <> caNone) and
          ((FAdvFieldDefs[i].BLOBCompressionMode < 1) or
           (FAdvFieldDefs[i].BLOBCompressionMode > 9))) then
        raise EABSException.Create(20257, ErrorGCannotCreateTableWithBlobField,
                                   [FAdvFieldDefs[i].Name, TableName]);
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//CheckAdvFieldDefs


//------------------------------------------------------------------------------
// AutoCorrectAdvIndexDefs
//------------------------------------------------------------------------------
procedure TABSTable.AutoCorrectAdvIndexDefs;
var
  i,j: Integer;
  ABSIdxDef: TABSIndexDef;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.AutoCorrectAdvIndexDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  ABSIdxDef := TABSIndexDef.Create;
  try
      for i:=0 to FAdvIndexDefs.Count-1 do
        begin
          ConvertAdvIndexDefToAbsIndexDef(FAdvIndexDefs[i],ABSIdxDef, FieldDefs);
          for j:=0 to ABSIdxDef.ColumnCount-1 do
            if (ABSIdxDef.Columns[j].MaxIndexedSize <= 0) or
               ((FAdvFieldDefs.Find(ABSIdxDef.Columns[j].FieldName) <> nil) and
                (not IsSizebleFieldType(FAdvFieldDefs.Find(ABSIdxDef.Columns[j].FieldName).DataType))
               ) then
               if (ABSIdxDef.Columns[j].MaxIndexedSize <> DEFAULT_MAX_INDEXED_SIZE) then
                  begin
                    ABSIdxDef.Columns[j].MaxIndexedSize := DEFAULT_MAX_INDEXED_SIZE;
                    ConvertABSIndexDefToAdvIndexDef(ABSIdxDef, FAdvIndexDefs[i]);
                  end;

        end;
  finally
    ABSIdxDef.Free;
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// AutoCorrectAdvIndexDefs


//------------------------------------------------------------------------------
// set temporary
//------------------------------------------------------------------------------
procedure TABSTable.SetTemporary(const Value: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetTemporary';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    FTemporary := Value;
    if (Value) then
     FDatabaseName := ABSTemporaryDatabaseName;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetTemporary


//------------------------------------------------------------------------------
// GetIndexFieldNames
//------------------------------------------------------------------------------
function TABSTable.GetIndexFieldNames: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetIndexFieldNames';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if FFieldsIndex then
      Result := FIndexName
    else
      Result := '';
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetIndexFieldNames


//------------------------------------------------------------------------------
// GetIndexName
//------------------------------------------------------------------------------
function TABSTable.GetIndexName: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetIndexName';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if FFieldsIndex then
      Result := ''
    else
      Result := FIndexName;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetIndexName


//------------------------------------------------------------------------------
// GetIndexParams
//------------------------------------------------------------------------------
procedure TABSTable.GetIndexParams(IndexName: string; FieldsIndex: Boolean;
         var IndexedName: string);
var
  IndexStr: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetIndexParams';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    IndexStr := '';
    if (IndexName <> '') then
     begin
       FIndexDefs.Updated := False;
       FIndexDefs.Update;
       IndexStr := IndexName;
       if FieldsIndex then
         IndexStr := string(FIndexDefs.FindIndexForFields(String(IndexName)).Name);
     end;
    IndexedName := IndexStr;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetIndexParams


//------------------------------------------------------------------------------
// IndexDefsStored
//------------------------------------------------------------------------------
function TABSTable.IndexDefsStored: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.IndexDefsStored';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := (FStoreDefs and (IndexDefs.Count > 0));
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// IndexDefsStored


//------------------------------------------------------------------------------
// SetIndex
//------------------------------------------------------------------------------
procedure TABSTable.SetIndex(const Value: string; FieldsIndex: Boolean);
var
  IndexName: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetIndex';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Active then
      CheckBrowseMode;
    if (FIndexName <> Value) or (FFieldsIndex <> FieldsIndex) then
      begin
        if Active then
          begin
           GetIndexParams(Value, FieldsIndex,IndexName);
           SwitchToIndex(IndexName);
           CheckMasterRange;
          end;
        FIndexName := Value;
        FFieldsIndex := FieldsIndex;
        if Active then
         Resync([]);
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetIndex


//------------------------------------------------------------------------------
// SetIndexFieldNames
//------------------------------------------------------------------------------
procedure TABSTable.SetIndexFieldNames(const Value: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetIndexFieldNames';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetIndex(Value, Value <> '');
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetIndexFieldNames


//------------------------------------------------------------------------------
// SetIndexName
//------------------------------------------------------------------------------
procedure TABSTable.SetIndexName(const Value: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetIndexName';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetIndex(Value, False);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetIndexName


//------------------------------------------------------------------------------
// SetTableName
//------------------------------------------------------------------------------
procedure TABSTable.SetTableName(const Value: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetTableName';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (csReading in ComponentState) then
      FTableName:=Value
    else
      if (Value <> FTablename) then
        begin
         CheckInactive;
         FTableName := Value;
         DataEvent(dePropertyChange,0);
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// SetTableName


//------------------------------------------------------------------------------
// return index name
//------------------------------------------------------------------------------
function TABSTable.FindOrCreateIndex(FieldNamesList, AscDescList, CaseSensitivityList: TStringList;
                                     var IsCreated: Boolean): string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.FindOrCreateIndex';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10311,ErrorLNilPointer);
    Result := FHandle.FindOrCreateIndex(FieldNamesList, AscDescList, CaseSensitivityList, IsCreated);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // FindOrCreateIndex


//------------------------------------------------------------------------------
// IndexExists
//------------------------------------------------------------------------------
function TABSTable.IndexExists(FieldNamesList, AscDescList, CaseSensitivityList: TStringList): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.IndexExists';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10514,ErrorLNilPointer);
    Result := FHandle.IndexExists(FieldNamesList, AscDescList, CaseSensitivityList);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// IndexExists


//------------------------------------------------------------------------------
// apply distinct
//------------------------------------------------------------------------------
procedure TABSTable.ApplyDistinct(FieldNamesList, AscDescList, CaseSensitivityList: TStringList);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ApplyDistinct';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10319,ErrorLNilPointer);
    FHandle.ApplyDistinct(FieldNamesList, AscDescList, CaseSensitivityList);
    IndexName := FHandle.IndexName;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ApplyDistinct


//------------------------------------------------------------------------------
// ApplyDistinct
//------------------------------------------------------------------------------
procedure TABSTable.ApplyDistinct(ds: TABSDataset);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ApplyDistinct';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10319,ErrorLNilPointer);
    IndexName := ds.Handle.IndexName;
    FHandle.DistinctFieldCount := ds.Handle.DistinctFieldCount;
    FHandle.DisableRecordBitmap;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// ApplyDistinct


//------------------------------------------------------------------------------
// return true if table exists
//------------------------------------------------------------------------------
function TABSTable.GetTableExists: Boolean;
var DatabaseClosed: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetTableExists';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FDatabaseName <> '') then
      begin
        DatabaseClosed := (FDatabase = nil);
        try
          if (DatabaseClosed) then
            FDatabase := OpenDatabase;

          Result := FDatabase.TableExists(TableName);
          
          if (DatabaseClosed) then
            begin
              CloseDatabase(FDatabase);
              FDatabase := nil;
            end;
        except
          Result := False;
        end;
      end
    else
      Result := False;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetTableExists


//------------------------------------------------------------------------------
// CheckMasterRange
//------------------------------------------------------------------------------
procedure TABSTable.CheckMasterRange;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CheckMasterRange';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FMasterLink.Active and (FMasterLink.Fields.Count > 0)) then
    begin
      {$ifndef D17H}
        SetLinkRanges(FMasterLink.Fields);
      {$else}
        SetLinkRanges(TList(FMasterLink.Fields));
      {$endif}
      SetCursorRange;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // CheckMasterRange


//------------------------------------------------------------------------------
// update range
//------------------------------------------------------------------------------
procedure TABSTable.UpdateRange;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.UpdateRange';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    {$ifndef D17H}
      SetLinkRanges(FMasterLink.Fields);
    {$else}
      SetLinkRanges(TList(FMasterLink.Fields));
    {$endif}

  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // UpdateRange


//------------------------------------------------------------------------------
// Master changed
//------------------------------------------------------------------------------
procedure TABSTable.MasterChanged(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.MasterChanged';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckBrowseMode;
    UpdateRange;
    ApplyRange;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // MasterChanged


//------------------------------------------------------------------------------
// Master dv sabled
//------------------------------------------------------------------------------
procedure TABSTable.MasterDisabled(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.MasterDisabled';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CancelRange;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // MasterDisabled


//------------------------------------------------------------------------------
// Set data source
//------------------------------------------------------------------------------
procedure TABSTable.SetDataSource(Value: TDataSource);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetDataSource';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (IsLinkedTo(Value)) then
      DatabaseError(ErrorLCircularDataLink, Self);
    FMasterLink.DataSource := Value;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetDataSource


//------------------------------------------------------------------------------
// get master fields
//------------------------------------------------------------------------------
function TABSTable.GetMasterFields: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetMasterFields';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := string(FMasterLink.FieldNames);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetMasterFields


//------------------------------------------------------------------------------
// set master fields
//------------------------------------------------------------------------------
procedure TABSTable.SetMasterFields(const Value: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetMasterFields';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    FMasterLink.FieldNames := String(Value);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetMasterFields


{$IFDEF D6H}
//------------------------------------------------------------------------------
// get default order
//------------------------------------------------------------------------------
function TABSTable.PSGetDefaultOrder: TIndexDef;

  function GetIdx(IdxType: TIndexOption): TIndexDef;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to IndexDefs.Count - 1 do
      if (IdxType in IndexDefs[i].Options) then
      try
        Result := IndexDefs[i];
        {$ifndef D17H}
          GetFieldList(nil, Result.Fields);
        {$else}
          GetFieldList(TList<TField>(nil), Result.Fields);
        {$endif}
        break;
      except
        Result := nil;
      end;
  end;

var
  DefIdx: TIndexDef;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.PSGetDefaultOrder';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    DefIdx := nil;
    IndexDefs.Update;
    try
      if IndexName <> '' then
        DefIdx := IndexDefs.Find(string(IndexName))
      else
       if IndexFieldNames <> '' then
        DefIdx := IndexDefs.FindIndexForFields(string(IndexFieldNames));
      if Assigned(DefIdx) and (DefIdx <> nil) then  // bug in Delphi XE3 Assigned(nil) return true :(
        {$ifndef D17H}
          GetFieldList(nil, DefIdx.Fields);
        {$else}
          GetFieldList(TList<TField>(nil), DefIdx.Fields);
        {$endif}
    except
      DefIdx := nil;
    end;
    if not Assigned(DefIdx) then
      DefIdx := GetIdx(ixPrimary);
    if not Assigned(DefIdx) then
      DefIdx := GetIdx(ixUnique);
    if Assigned(DefIdx) then
     begin
      Result := TIndexDef.Create(nil);
      Result.Assign(DefIdx);
     end
    else
     Result := nil;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSGetDefaultOrder


//------------------------------------------------------------------------------
// get key fields
//------------------------------------------------------------------------------
function TABSTable.PSGetKeyFields: string;
var
  i, Pos: Integer;
  IndexFound: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.PSGetKeyFields';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := inherited PSGetKeyFields;
    if Result = '' then
     begin
      if not Exists then
       Exit;
      IndexFound := False;
      IndexDefs.Update;
      for i := 0 to IndexDefs.Count - 1 do
        if (ixUnique in IndexDefs[I].Options) or (ixPrimary in IndexDefs[I].Options) then
         begin
          Result := IndexDefs[I].Fields;
          IndexFound := (FieldCount = 0);
          if not IndexFound then
           begin
            Pos := 1;
            while Pos <= Length(Result) do
             begin
              IndexFound := FindField(ExtractFieldName(Result, Pos)) <> nil;
              if not IndexFound then
               Break;
             end;
           end;
          if IndexFound then
           Break;
         end;
      if not IndexFound then
        begin
          Result := '';
          for i := 0 to Fields.Count - 1 do
            begin
              if Result <> '' then
                Result := Result + ';';
              Result := Result + Fields[i].FieldName;
            end;
        end;
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSGetKeyFields


//------------------------------------------------------------------------------
// get table name
//------------------------------------------------------------------------------
function TABSTable.PSGetTableName: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.PSGetTableName';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := string(TableName);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSGetTableName


//------------------------------------------------------------------------------
// get index defs
//------------------------------------------------------------------------------
function TABSTable.PSGetIndexDefs(IndexTypes: TIndexOptions): TIndexDefs;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.PSGetIndexDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := GetIndexDefs(IndexDefs, IndexTypes);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSGetIndexDefs


//------------------------------------------------------------------------------
// set command text
//------------------------------------------------------------------------------
procedure TABSTable.PSSetCommandText(const CommandText: string);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.PSSetCommandText';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if CommandText <> '' then
      TableName := string(CommandText);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSSetCommandText


//------------------------------------------------------------------------------
// set params
//------------------------------------------------------------------------------
procedure TABSTable.PSSetParams(AParams: TParams);

  procedure AssignFields;
  var
    I: Integer;
  begin
    for I := 0 to AParams.Count - 1 do
      if AParams[I].Name <> '' then
        FieldByName(AParams[I].Name).Value := AParams[I].Value
      else
        IndexFields[I].Value := AParams[I].Value;
  end;

{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.PSSetParams';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if AParams.Count > 0 then
     begin
      Open;
      SetRangeStart;
      AssignFields;
      SetRangeEnd;
      AssignFields;
      ApplyRange;
     end
    else
     if Active then
      CancelRange;
    PSReset;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PSSetParams
{$ENDIF}


//------------------------------------------------------------------------------
// prepare cursor
//------------------------------------------------------------------------------
procedure TABSTable.PrepareCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.PrepareCursor';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckMasterRange;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;


//------------------------------------------------------------------------------
// create and open cursor
//------------------------------------------------------------------------------
function TABSTable.CreateHandle: TABSCursor;
var
   IndexName: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CreateHandle';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckBlankTableName;
    FIndexDefs.Updated:=False;
    if (FExternalHandle = nil) then
      Result := GetHandle
    else
      Result := FExternalHandle;
    FHandle := Result;
    FIndexDefs.Update;
    GetIndexParams(FIndexName, FFieldsIndex, IndexName);
    if (IndexName <> '') then
      Result.IndexName := IndexName;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CreateHandle


//------------------------------------------------------------------------------
// Data Event
//------------------------------------------------------------------------------
procedure TABSTable.DataEvent(Event: TDataEvent; Info: {$ifdef D16H}NativeInt{$else}Longint{$endif});
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.DataEvent';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if ((Event = dePropertyChange) and Assigned(IndexDefs)) then
     IndexDefs.Updated := False;
    inherited DataEvent(Event, Info);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// DataEvent


//------------------------------------------------------------------------------
// DefChanged
//------------------------------------------------------------------------------
procedure TABSTable.DefChanged(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.DefChanged';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    StoreDefs := True;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// DefChanged


//------------------------------------------------------------------------------
// InitFieldDefs
//------------------------------------------------------------------------------
procedure TABSTable.InitFieldDefs;
var
  TmpCursor: TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InitFieldDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle <> nil) then
      InternalInitFieldDefs
    else
      begin
       SetDBFlag(dbfFieldList,True);
       try
         CheckBlankTableName;
         TmpCursor := GetHandle;
         try
           TmpCursor.InternalInitFieldDefs;
           // Fill ABSFieldDefs
           FABSFieldDefs.Assign(TmpCursor.VisibleFieldDefs);
           // Fill FieldDefs
           ConvertABSFieldDefsToFieldDefs(TmpCursor.VisibleFieldDefs, TmpCursor.FConstraintDefs, FieldDefs);
           // Fill AdvFieldDefs
           ConvertABSFieldDefsToAdvFieldDefs(TmpCursor.VisibleFieldDefs,TmpCursor.FieldDefs, TmpCursor.FConstraintDefs, AdvFieldDefs);
           FRestructureFieldDefs.Assign(FAdvFieldDefs);
         finally
          TmpCursor.Free;
         end;
       finally
         SetDBFlag(dbfFieldList,False);
       end;
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// InitFieldDefs


//------------------------------------------------------------------------------
// destroy cursor
//------------------------------------------------------------------------------
procedure TABSTable.DestroyHandle;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.DestroyHandle';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    inherited DestroyHandle;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// DestroyHandle


//------------------------------------------------------------------------------
// get cursor
//------------------------------------------------------------------------------
function TABSTable.GetHandle: TABSCursor;
var i: Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetHandle';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := TABSLocalCursor.Create;
     try
       Result.Session := FDatabase.Handle;
       Result.TableName := FTableName;
       Result.Exclusive := FExclusive;
       Result.ReadOnly := FReadOnly or FDatabase.ReadOnly;
       Result.InMemory := FInMemory;
       Result.Temporary := FTemporary;
       if (FInMemory) then
         Result.FDisableTempFiles := True
       else
         if (FDatabase.Temporary) then
           Result.FDisableTempFiles := FDisableTempFiles
         else
           Result.FDisableTempFiles := FDatabase.DisableTempFiles;
       if (not IgnoreDesignMode) then
         Result.IsDesignMode := IsDesignMode
       else
         Result.IsDesignMode := False;

       Result.IsRepairing := FIsRepairing;
       // adding fields, specified by editor
       for i := 0 to Fields.Count - 1 do
        if (Fields[i].FieldKind in [fkData]) then
          if (not FindFieldInFieldDefs(FieldDefs, string(Fields[i].FieldName))) then
            FieldDefs.Add(Fields[i].FieldName,Fields[i].DataType,Fields[i].Size,Fields[i].Required);
       if (FTemporary or FInMemory) then
         begin
           // convert field and index defs
           if (FieldDefs.Count > 0) then
            begin
              FABSFieldDefs.Clear;
              ConvertFieldDefsToABSFieldDefs(FieldDefs,FABSFieldDefs);
            end
           else
             ConvertAdvFieldDefsToFieldDefs(FAdvFieldDefs, FieldDefs);
           if (IndexDefs.Count > 0) then
            begin
             FABSIndexDefs.Clear;
             ConvertIndexDefsToAdvIndexDefs(IndexDefs, FAdvIndexDefs);
             ConvertAdvIndexDefsToABSIndexDefs(FAdvIndexDefs, FABSIndexDefs, FieldDefs);
            end;
         end;
       Result.OpenTableByFieldDefs(FABSFieldDefs,FABSIndexDefs, FABSConstraintDefs);
       FReadOnly := Result.ReadOnly;
     except
       Result.Free;
       raise;
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// GetHandle


//------------------------------------------------------------------------------
// UpdateIndexDefs
//------------------------------------------------------------------------------
procedure TABSTable.UpdateIndexDefs;
var
  TmpCursor: TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.UpdateIndexDefs';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   if (not FIndexDefs.Updated) then
    begin
     SetDBFlag(dbfIndexList, True);
     try
       FieldDefs.Update;
       if (FHandle = nil) then
         TmpCursor := GetHandle
       else
         TmpCursor := FHandle;
       try
        ConvertABSIndexDefsToAdvIndexDefs(TmpCursor.IndexDefs, FAdvIndexDefs);
        ConvertAdvIndexDefsToIndexDefs(FAdvIndexDefs, FIndexDefs);
        FRestructureIndexDefs.Assign(FAdvIndexDefs);

        FIndexDefs.Updated:=True;
       finally
        if (FHandle = nil) then
         TmpCursor.Free;
       end;
     finally
       SetDBFlag(dbfIndexList, False);
     end;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// UpdateIndexDefs


//------------------------------------------------------------------------------
// return field object for the specified field in the current index
//------------------------------------------------------------------------------
function TABSTable.GetIndexField(Index: Integer): TField;
var
  FieldNo: Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetIndexField';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (Index < 0) or (Index >= FIndexFieldCount) then
      DatabaseError(ErrorLFieldIndexError, Self);
    FieldNo := FIndexFieldMap[Index];
    Result := FieldByNumber(FieldNo);
    if Result = nil then
      DatabaseErrorFmt(ErrorLIndexFieldMissing, [FieldDefs[FieldNo - 1].Name], Self);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetIndexField


//------------------------------------------------------------------------------
// set index field
//------------------------------------------------------------------------------
procedure TABSTable.SetIndexField(Index: Integer; Value: TField);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetIndexField';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    GetIndexField(Index).Assign(Value);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetIndexField


//------------------------------------------------------------------------------
// set link ranges
//------------------------------------------------------------------------------
procedure TABSTable.SetLinkRanges(MasterFields: TList);
var
  i: Integer;
  SaveState: TDataSetState;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetLinkRanges';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10299,ErrorLNilPointer);
    SaveState := SetTempState(dsSetKey);
    try
      FKeyBuffer := InitKeyBuffer(FKeyBuffers[kiRangeStart]);
      PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.Modified := True;
      for i := 0 to MasterFields.Count - 1 do
        GetIndexField(i).Assign(TField(MasterFields[i]));
      PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.FieldCount := MasterFields.Count;
    finally
      RestoreState(SaveState);
    end;
    Move(FKeyBuffers[kiRangeStart]^, FKeyBuffers[kiRangeEnd]^, FHandle.KeyBufferSize);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetLinkRanges


//------------------------------------------------------------------------------
// get data source
//------------------------------------------------------------------------------
function TABSTable.GetDataSource: TDataSource;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetDataSource';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := FMasterLink.DataSource;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetDataSource


//------------------------------------------------------------------------------
// on new record
//------------------------------------------------------------------------------
procedure TABSTable.DoOnNewRecord;
var
  I: Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.DoOnNewRecord';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FMasterLink.Active and (FMasterLink.Fields.Count > 0)) then
      for I := 0 to FMasterLink.Fields.Count - 1 do
        IndexFields[I] := TField(FMasterLink.Fields[I]);
    inherited DoOnNewRecord;
    SetDefaultBlobFieldsValues;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // DoOnNewRecord


//------------------------------------------------------------------------------
// get index field count
//------------------------------------------------------------------------------
function TABSTable.GetIndexFieldCount: Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetIndexFieldCount';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := FIndexFieldCount;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetIndexFieldCount


//------------------------------------------------------------------------------
// get default values for blob fields
//------------------------------------------------------------------------------
procedure TABSTable.SetDefaultBlobFieldsValues;
var
  bs: TStream;
  buf: AnsiString;
  I: Integer;
  value: TABSVariant;
begin
  buf := ' ';
  for I := 0 to FHandle.FieldDefs.Count -1  do
  begin
    if (FHandle.FieldDefs[I].BaseFieldType in [bftBlob, bftClob]) and (not FHandle.FieldDefs[I].DefaultValue.IsNull) then
    begin
      if (FHandle.FFieldDefs[i].DefaultValueExpr <> nil) then
      begin
        try
          value := TABSExpression(FHandle.FFieldDefs[i].DefaultValueExpr).GetValue;
          buf := value.AsAnsiString;
        except
          buf := FHandle.FieldDefs[I].DefaultValue.AsAnsiString;
        end;
      end
      else
        buf := FHandle.FieldDefs[I].DefaultValue.AsAnsiString;

      bs := CreateBlobStream(Fields[I], bmWrite);
      bs.Write(TAbsPByte(buf)^, Length(buf));
      bs.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
// create
//------------------------------------------------------------------------------
constructor TABSTable.Create(AOwner: TComponent);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.Create';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    inherited Create(AOwner);
    FTemporary := False;
    FIsRepairing := False;
    FDisableTempFiles := False;
    FMasterLink := TMasterDataLink.Create(Self);
    FMasterLink.OnMasterChange := MasterChanged;
    FMasterLink.OnMasterDisable := MasterDisabled;
    FExportToSqlOptions := TABSExportToSqlOptions.Create;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// Create


//------------------------------------------------------------------------------
// destory
//------------------------------------------------------------------------------
destructor TABSTable.Destroy;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.Destroy';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    FExportToSqlOptions.Free;
    FMasterLink.Free;
    inherited Destroy;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // Destroy


//------------------------------------------------------------------------------
// create table
//------------------------------------------------------------------------------
procedure TABSTable.CreateTable;
var i:          Integer;
  TempCursor: TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CreateTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    CheckBlankTableName;

    SetDBFlag(dbfTable, True);
    try
     TempCursor := TABSLocalCursor.Create;
     try
      TempCursor.Session := FDatabase.Handle;
      TempCursor.TableName := FTableName;
      TempCursor.InMemory := FInMemory;
      TempCursor.Temporary := FTemporary;

       if (FInMemory) then
         TempCursor.FDisableTempFiles := True
       else
         if (FDatabase.Temporary) then
           TempCursor.FDisableTempFiles := FDisableTempFiles
         else
           TempCursor.FDisableTempFiles := FDatabase.DisableTempFiles;

      TempCursor.ReadOnly := False;
      TempCursor.Exclusive := True;
      // adding fields, specified by editor
      for i := 0 to Fields.Count - 1 do
       if (Fields[i].FieldKind in [fkData]) then
        if (not FindFieldInFieldDefs(FieldDefs,string(Fields[i].FieldName))) then
          FieldDefs.Add(Fields[i].FieldName,Fields[i].DataType,Fields[i].Size,Fields[i].Required);

      // Synchronize FieldDefs and AdvFieldDefs
      if (AdvFieldDefs.Count > 0) then
        begin
          AutoCorrectAdvFieldDefs;
          CheckAdvFieldDefs;
          // Copy AdvFieldDefs to FieldDefs
          ConvertAdvFieldDefsToFieldDefs(AdvFieldDefs, FieldDefs);
        end
      else
       begin
          AutoCorrectFieldDefs;
          // Copy FieldDefs to AdvFieldDefs or
          ConvertFieldDefsToAdvFieldDefs(FieldDefs, AdvFieldDefs);
          CheckAdvFieldDefs;
       end;

      if (AdvIndexDefs.Count > 0) then
        ConvertAdvIndexDefsToIndexDefs(AdvIndexDefs, IndexDefs)
      else
       begin
        FAdvIndexDefs.Clear;
        ConvertIndexDefsToAdvIndexDefs(IndexDefs,FAdvIndexDefs);
       end;

      AutoCorrectAdvIndexDefs;
      // convert field and index defs
      ConvertAdvIndexDefsToABSIndexDefs(AdvIndexDefs, FABSIndexDefs, FieldDefs);
      ConvertAdvFieldDefsToABSFieldDefs(AdvFieldDefs, FABSFieldDefs,
                                        FABSIndexDefs, FABSConstraintDefs, FTemporary);

      if (TempCursor.Session.InTransaction) then
       raise EABSException.Create(20182, ErrorADatabaseInTransaction, ['CreateTable']);
      TempCursor.CreateTable(FABSFieldDefs,FABSIndexDefs,FABSConstraintDefs);
     finally
      TempCursor.Free;
     end;
    finally
     SetDBFlag(dbfTable, False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// CreateTable


//------------------------------------------------------------------------------
// delete table
//------------------------------------------------------------------------------
procedure TABSTable.DeleteTable;
var
  TempCursor:   TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.DeleteTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Active then Close;
    CheckBlankTableName;
    SetDBFlag(dbfTable, True);
    try
     TempCursor := TABSLocalCursor.Create;
     try
      TempCursor.Session := FDatabase.Handle;
      TempCursor.TableName := FTableName;
      TempCursor.InMemory := FInMemory;
      TempCursor.Temporary := FTemporary;
      TempCursor.ReadOnly := False;
      TempCursor.Exclusive := True;
      if (TempCursor.Session.InTransaction) then
       raise EABSException.Create(20183, ErrorADatabaseInTransaction, ['DeleteTable']);
      TempCursor.DeleteTable;
     finally
      TempCursor.Free;
     end;
    finally
     SetDBFlag(dbfTable, False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // DeleteTable


//------------------------------------------------------------------------------
// empty table
//------------------------------------------------------------------------------
procedure TABSTable.EmptyTable;
var
  TempCursor:   TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.EmptyTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    SetDBFlag(dbfTable, True);
    try
     TempCursor := TABSLocalCursor.Create;
     try
      TempCursor.Session := FDatabase.Handle;
      TempCursor.TableName := FTableName;
      TempCursor.InMemory := FInMemory;
      TempCursor.Temporary := FTemporary;
      TempCursor.ReadOnly := False;
      TempCursor.Exclusive := True;
      TempCursor.EmptyTable;
     finally
      TempCursor.Free;
     end;
    finally
     SetDBFlag(dbfTable, False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // EmptyTable


//------------------------------------------------------------------------------
// rename table
//------------------------------------------------------------------------------
procedure TABSTable.RenameTable(NewTableName: string);
var
  TempCursor:   TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.RenameTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    CheckBlankTableName;
    SetDBFlag(dbfTable, True);
    try
     TempCursor := TABSLocalCursor.Create;
     try
      TempCursor.Session := FDatabase.Handle;
      TempCursor.TableName := FTableName;
      TempCursor.InMemory := FInMemory;
      TempCursor.Temporary := FTemporary;
      TempCursor.ReadOnly := False;
      TempCursor.Exclusive := True;
      if (TempCursor.Session.InTransaction) then
       raise EABSException.Create(20181, ErrorADatabaseInTransaction, ['RenameTable']);
      TempCursor.RenameTable(NewTableName);
      FTableName := NewTableName;
     finally
      TempCursor.Free;
     end;
    finally
     SetDBFlag(dbfTable, False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // RenameTable


//------------------------------------------------------------------------------
// import table
//------------------------------------------------------------------------------
function TABSTable.ImportTable(
                      SourceTable: TDataset;
                      var Log:     string;
                      aIndexDefs:   TIndexDefs = nil
                      ): Boolean;
var
    s,SourceLog:     string;
    Continue: Boolean;
    i: integer;
    IndexDef: TIndexDef;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ImportTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := False;

    Filtered := False;

    SourceLog := Log;
    CheckInactive;
    IndexDefs.Clear;
    AdvIndexDefs.Clear;
    FieldDefs.Clear;
    AdvFieldDefs.Clear;
    if (SourceTable is TABSDataset) then
      begin
       AdvFieldDefs.Assign(TABSDataset(SourceTable).AdvFieldDefs);
       AdvIndexDefs.Assign(TABSDataset(SourceTable).AdvIndexDefs, True);
      end
    else
      begin
        FieldDefs.Assign(SourceTable.FieldDefs);
        if (aIndexDefs <> nil) then
          begin
            for i := 0 to aIndexDefs.Count-1 do
              if (aIndexDefs[i].Fields = '') then
                Log := Log + Format(ErrorAImportingIndex, [aIndexDefs[i].Name])
              else begin
                  IndexDef := IndexDefs.AddIndexDef;

                  IndexDef.Assign(aIndexDefs[i]);
                  IndexDef.DescFields := aIndexDefs[i].DescFields;
              end;
          end;
          for i := 0 to IndexDefs.Count-1 do
           if (IndexDefs[i].Name = '') then
             begin
              IndexDefs[i].Name := 'idxPrimaryKey';
              break;
             end;
      end;
    try
      Self.CreateTable;
    except
     on e: Exception do
      begin
       Log := Log + Format(ErrorLImportTableCannotCreateTable,[e.Message]);
       Exit;
      end;
    end;
    Self.Open;
    if (FHandle = nil) then
      raise EABSException.Create(10259,ErrorLNilPointer);
    FHandle.LockTableData;
    InternalBeforeImport(Self);
    try
      //s := CopyRecords(Self);
      Continue := true;
      InternalCopyRecords(SourceTable, Self, s, Continue, True, False, InternalOnImportProgress);
      if (s <> '') then
        Log := Log + Format(ErrorLImportTableCannotCopyData,[s]);

      Result := (Log = SourceLog);
    finally
      InternalAfterImport(Self);
      FHandle.UnlockTableData;
    end;
    Self.Close;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ImportTable


//------------------------------------------------------------------------------
// import table
//------------------------------------------------------------------------------
function TABSTable.ImportTable(SourceTable: TDataset): Boolean;
var s: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ImportTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   Result := ImportTable(SourceTable,s);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ImportTable


//------------------------------------------------------------------------------
// export table
//------------------------------------------------------------------------------
function TABSTable.ExportTable(
                      DestinationTable:   TDataset;
                      CreateTablePointer: TProcedure;
                      var Log:            string
                   ): Boolean;
var
    s,SourceLog:     string;
    OldActive:       Boolean;
    Bookmark:        TBookmark;
    Continue:        Boolean;
    i:               Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ExportTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := False;
    SourceLog := Log;
    OldActive := Self.Active;
    DestinationTable.Close;
    if (OldActive) then
     Bookmark := Self.GetBookmark
    else
     Bookmark := nil;
    Self.Close;
    Self.Open;
    if (FHandle = nil) then
      raise EABSException.Create(10262,ErrorLNilPointer);
      if (DestinationTable is TABSDataset) then
       TABSDataset(DestinationTable).AdvFieldDefs.Assign(Self.AdvFieldDefs)
      else
       DestinationTable.FieldDefs.Assign(Self.FieldDefs);
      try
        CreateTablePointer;
      except
       on e: Exception do
        begin
         Log := Log + Format(ErrorLExportTableCannotCreateTable,[e.Message]);
         Exit;
        end;
      end;
      try
        DestinationTable.Open;
        // switch off "required" as it could be unreasonably enabled by BDE
        for i:=0 to DestinationTable.FieldDefs.Count-1 do
          DestinationTable.FieldDefs[i].Required := False;
        for i:=0 to DestinationTable.Fields.Count-1 do
          DestinationTable.Fields[i].Required := False;
      except
       on e: Exception do
        begin
         Log := Log + Format(ErrorLExportTableCannotOpenTable,[e.Message]);
         Exit;
        end;
      end;

      FHandle.LockTableData;
      InternalBeforeExport(Self);
      try
        Continue := true;
        InternalCopyRecords(Self, DestinationTable, s, Continue, True, False, InternalOnExportProgress);
        if (s <> '') then
          Log := Log + Format(ErrorLExportTableCannotCopyData,[s]);

        Result := (Log = SourceLog);
      finally
        InternalAfterExport(Self);
        FHandle.UnlockTableData;
      end;
      // restore table position
      if (OldActive) then
       begin
        try
          Self.GotoBookmark(Bookmark);
        finally
          Self.FreeBookmark(Bookmark);
        end;
       end
      else
       Self.Close;
    finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ExportTable


//------------------------------------------------------------------------------
// export table
//------------------------------------------------------------------------------
function TABSTable.ExportTable(
                      DestinationTable:   TDataset;
                      CreateTablePointer: TProcedure
                   ): Boolean;
var
  s: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ExportTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   Result := ExportTable(DestinationTable,CreateTablePointer, s);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ExportTable


//------------------------------------------------------------------------------
// CopyTable
//------------------------------------------------------------------------------
function TABSTable.CopyTable( NewTableName: string;
                              var Log: string;
                              var Continue: Boolean;
                              DestDatabaseFileName: string ='';
                              DestDatabasePassword: string ='';
                              IgnoreErrors: Boolean = False;
                              OverwriteExistingTable: Boolean = False;
                              CopyIndexes: Boolean = True;
                              MinProgress: Integer = 0;
                              MaxProgress: Integer = 100
                   ): Boolean;
var
  NewTable: TABSTable;
  DestDatabase: TAbsDataBase;
  OldActive: Boolean;
  OldBookmark: Pointer;
  i: Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CopyTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  OldActive := Active;
  try
    Result := False;
    if OldActive then
      begin
        OldBookmark := GetBookmark;
        Close;
      end;
    Open;
    try
      // Set Database
      if DestDatabaseFileName = '' then
        DestDatabase := Database
      else
       begin
        DestDatabase := nil;
        if (DestDatabaseFileName <> ABSMemoryDatabaseName) then
          begin
            DestDatabase := TABSDatabase.Create(nil);
            DestDatabase.DatabaseName := GetTemporaryName(string('TempDb'));
            DestDatabase.DatabaseFileName := DestDatabaseFileName;
            DestDatabase.Password := DestDatabasePassword;
            try
              DestDatabase.Open;
            except
              FreeAndNil(DestDatabase);
              if (not IgnoreErrors) then
                raise;
            end;
            // Check for TableName
            if ((UpperCase(DatabaseName) = UpperCase(DestDatabase.DatabaseName)) and
                (UpperCase(string(NewTableName)) = UpperCase(string(TableName)))) then
              begin
               if (not IgnoreErrors) then
                raise EABSException.Create(30447, ErrorGCannotCopyTableIntoItSelf,
                                           [DestDatabase.DatabaseFileName,TableName]);
                Log := Log + Format(ErrorGCannotCopyTableIntoItSelf, [DestDatabase.DatabaseFileName,TableName]);
                Exit;
              end;
          end;
       end;

      // check if fields objects are created for all field defs
      for i := 0 to FieldDefs.Count - 1 do
        if (FindField(FieldDefs[i].Name) = nil) then
          raise EABSException.Create(20297, ErrorACannotCopyTableNoFieldObject,
                                       [TableName, FieldDefs[i].Name]);

      // BeforeCopyTable
      InternalBeforeCopy(Self);

      // Create Dst Table
      NewTable := TABSTable.Create(nil);
      try
        NewTable.FTableName := NewTableName;
        if (DestDatabaseFileName = '') then
          begin
            NewTable.FInMemory := Self.FInMemory;
            NewTable.FTemporary := Self.FTemporary;
          end;
        if (DestDatabase <> nil) then
          NewTable.FDatabaseName := DestDatabase.DatabaseName
        else
          NewTable.FDatabaseName := DestDatabaseFileName;
        NewTable.AdvFieldDefs.Assign(FRestructureFieldDefs);
        if CopyIndexes then
          begin
            NewTable.AdvIndexDefs.Assign(FRestructureIndexDefs, True);
          end;

        // Check for table exists
        if NewTable.Exists then
          if OverwriteExistingTable then
            NewTable.DeleteTable
          else
            begin
              if (not IgnoreErrors) then
              // fix AV error when DestDatabase = nil (for in-memory dest tables) - 5.05
              if DestDatabase <> nil then
                raise EABSException.Create(30448, ErrorGBDTableAlreadyExists, [DestDatabase.DatabaseFileName,TableName])
              else
                raise EABSException.Create(10515, ErrorGBDTableAlreadyExists, ['MEMORY' ,TableName]);
              Log := Log + Format(ErrorGBDTableAlreadyExists, [DestDatabase.DatabaseFileName,TableName]);
              Exit;
            end;

        // Create Table
        try
          NewTable.CreateTable;
        except
         on e: Exception do
          begin
            if (not IgnoreErrors) then
              raise EABSException.Create(30450, ErrorGCreateTable, [DestDatabase.DatabaseFileName,TableName, e.Message]);
            Log := Log + Format(ErrorGCreateTable, [DestDatabase.DatabaseFileName,TableName, e.Message]);
            Exit;
          end;
        end;

        NewTable.Open;
        try
          // Copy Table Rows
          InternalCopyRecords(Self, NewTable, Log, Continue, IgnoreErrors, False, InternalOnCopyProgress, MinProgress, MaxProgress);
        finally
          NewTable.Close;
        end;
      finally
        NewTable.Free;
      end;

      Result := True;

    finally
      // AfterCopyTable
      InternalAfterCopy(Self);
      if not OldActive then
        Close
      else
        GotoBookmark(OldBookmark);
      if DestDatabaseFileName <> '' then FreeAndNil(DestDatabase);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//CopyTable


//------------------------------------------------------------------------------
// CopyTable
//------------------------------------------------------------------------------
procedure TABSTable.CopyTable(NewTableName: string; DestDatabaseFileName: string='';
                              DestDatabasePassword: string ='');
var
  Log: string;
  Continue: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CopyTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Log := '';
    Continue := True;
    CopyTable(NewTableName,Log,Continue,DestDatabaseFileName,DestDatabasePassword);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//CopyTable


//------------------------------------------------------------------------------
// batch move
//------------------------------------------------------------------------------
procedure TABSTable.BatchMove(SourceTableOrQuery: TABSDataSet;
                              //DestTable: TABSTable;
                              MoveType: TABSBatchMoveType;
                              DstTableIndexNameToIdentifyEqualRecords: string = '');
var
   DestTable: TABSTable;
   I: Integer;
   RecordWasFound: Boolean;
   FieldList, AscDescList, CaseInsList, TmpList: TStringList;
   OldSrcIndexName, OldDstIndexName, OldSrcIndexFieldNames, OldDstIndexFieldNames: string;
   OldMasterSource: TDatasource;
   SrcBookmark: TBookmark;
   DstBookmark: TBookmark;
   rc, rn: Integer;
   Continue: Boolean;
   KeyFields: string;
   v: Variant;
   IndexDef: TIndexDef;
   TempDestIndex, TempSrcIndex: string;
   IsDestIndexCreated, IsSrcIndexCreated: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.BatchMove';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    DestTable := Self;
    SourceTableOrQuery.DisableControls;
    DestTable.DisableControls;

    IsDestIndexCreated := False;
    IsSrcIndexCreated := False;

    FieldList   := TStringList.Create;
    AscDescList := TStringList.Create;
    CaseInsList := TStringList.Create;
    TmpList     := TStringList.Create;

    SrcBookmark := SourceTableOrQuery.GetBookmark;
    DstBookmark := DestTable.GetBookmark;

    try
      OldDstIndexFieldNames := DestTable.IndexFieldNames;
      OldDstIndexName := DestTable.IndexName;
      OldMasterSource := DestTable.MasterSource;
      DestTable.MasterSource := nil;
      DestTable.IndexFieldNames := '';
      SourceTableOrQuery.Open;

      // create DestTable if necessary
      if (not DestTable.Exists) or (MoveType=bmtCopy) then
        begin
          DestTable.Close;
          DestTable.FieldDefs.Assign(SourceTableOrQuery.FieldDefs);
          DestTable.IndexDefs.Assign(SourceTableOrQuery.IndexDefs);
          DestTable.CreateTable;
        end;

      DestTable.Open;

      SourceTableOrQuery.First;

      if (DstTableIndexNameToIdentifyEqualRecords <> '') then
        DestTable.IndexName := DstTableIndexNameToIdentifyEqualRecords;

      // If no index ...
      if (DestTable.IndexName = '') then
          // 1 find Primary Key
          for i:=0 to DestTable.IndexDefs.Count-1 do
            if (ixPrimary in DestTable.IndexDefs[i].Options) then
              begin
                DestTable.IndexName := string(DestTable.IndexDefs[i].Name);
                Break;
              end;

      if (DestTable.IndexName = '') then
        begin
          // 2 Create Temporary Index
          for i:=0 to SourceTableOrQuery.FieldCount-1 do
            if (DestTable.FieldDefs.IndexOf(SourceTableOrQuery.Fields[i].FieldName)>= 0) then
              begin
                FieldList.Add(SourceTableOrQuery.Fields[i].FieldName);
                AscDescList.Add(ABS_ASC);
                CaseInsList.Add(ABS_CASE);
              end;
          DestTable.IndexName := DestTable.FindOrCreateIndex(FieldList,AscDescList,CaseInsList,IsDestIndexCreated);
          TempDestIndex := DestTable.IndexName;
        end;

      if (MoveType = bmtSynchronize) then
        rc := SourceTableOrQuery.RecordCount + DestTable.RecordCount
      else
        rc := SourceTableOrQuery.RecordCount;
      rn := 1;
      Continue := True;

      // before
      InternalBeforeBatchMove(SourceTableOrQuery);

      try
        while not SourceTableOrQuery.EOF do
          begin
            InternalOnBatchMoveProgress(SourceTableOrQuery, Round((rn/rc)*100), Continue);
            if (not Continue) then Break;
            RecordWasFound := False;
            if (MoveType in [bmtAppend, bmtAppendUpdate, bmtUpdate, bmtDelete, bmtSynchronize]) then
              begin
                DestTable.SetKey;
                for i:=0 to DestTable.IndexFieldCount-1 do
                  AssignField(SourceTableOrQuery.FieldByName(DestTable.IndexFields[i].FieldName),
                              DestTable.IndexFields[i]);
                RecordWasFound := DestTable.GotoKey;
              end;
            if RecordWasFound then
              begin
                if (MoveType in [bmtAppendUpdate, bmtUpdate, bmtSynchronize]) then
                  begin
                    DestTable.Edit;
                    for i:=0 to SourceTableOrQuery.FieldCount-1 do
                      if (DestTable.FieldDefs.IndexOf(SourceTableOrQuery.Fields[i].FieldName) >= 0) then
                        AssignField(SourceTableOrQuery.Fields[I],
                                    DestTable.FieldByName(SourceTableOrQuery.Fields[i].FieldName));
                    DestTable.Post;
                  end
                else if (MoveType=bmtDelete) then DestTable.Delete;
              end
            else
              begin
                if (MoveType in [bmtAppend, bmtAppendUpdate, bmtCopy, bmtSynchronize]) then
                  begin
                    DestTable.Insert;
                    try
                       for i:=0 to SourceTableOrQuery.FieldCount-1 do
                        if (DestTable.FieldDefs.IndexOf(SourceTableOrQuery.Fields[i].FieldName) >= 0) then
                          AssignField(SourceTableOrQuery.Fields[i], DestTable.FieldByName(SourceTableOrQuery.Fields[i].FieldName));
                      DestTable.Post;
                    except
                      // 5.05 cancel post if a error occurred
                      DestTable.Cancel;
                    end;
                  end;
              end;
            SourceTableOrQuery.Next;
            Inc(rn);
          end;// while

        // Delete unnecessary records
        if ((MoveType = bmtSynchronize) and Continue) then
          begin
            rc := SourceTableOrQuery.RecordCount + DestTable.RecordCount;
            DestTable.First;

            // Common Fields for Index
            FieldList.Clear;
            AscDescList.Clear;
            CaseInsList.Clear;
            KeyFields := '';
            IndexDef := DestTable.IndexDefs.Find(string(DestTable.IndexName));
            if (IndexDef <> nil) then
              begin
                KeyFields := string(IndexDef.Fields);
                GetNamesList(FieldList, string(IndexDef.Fields));
                GetNamesList(TmpList, string(IndexDef.DescFields));
                for i:=0 to FieldList.Count-1 do
                  if (TmpList.IndexOf(FieldList[i]) <> -1) then
                    AscDescList.Add(ABS_DESC)
                  else
                    AscDescList.Add(ABS_ASC);
                GetNamesList(TmpList, IndexDef.CaseInsFields);
                for i:=0 to FieldList.Count-1 do
                  if (TmpList.IndexOf(FieldList[i]) <> -1) then
                    CaseInsList.Add(ABS_NO_CASE)
                  else
                    CaseInsList.Add(ABS_CASE);
              end;

            if SourceTableOrQuery is TABSTable then
              begin
                // Create Temporary Index
                OldSrcIndexName := TABSTable(SourceTableOrQuery).IndexName;
                OldSrcIndexFieldNames := TABSTable(SourceTableOrQuery).IndexFieldNames;
                TABSTable(SourceTableOrQuery).IndexName := TABSTable(SourceTableOrQuery).FindOrCreateIndex(FieldList,AscDescList,CaseInsList,IsSrcIndexCreated);
                TempSrcIndex := TABSTable(SourceTableOrQuery).IndexName;
              end
            else
              begin
                if (FieldList.Count = 1) then
                  v := Null
                else
                  v := VarArrayCreate([0, FieldList.Count-1], varVariant);
              end;

            while not DestTable.EOF do
              begin
                InternalOnBatchMoveProgress(SourceTableOrQuery, Round((rn/rc)*100), Continue);
                if (not Continue) then Break;
                if SourceTableOrQuery is TABSTable then
                  begin
                    TABSTable(SourceTableOrQuery).SetKey;
                    for i:=0 to TABSTable(SourceTableOrQuery).IndexFieldCount-1 do
                      AssignField(DestTable.FieldByName(TABSTable(SourceTableOrQuery).IndexFields[i].FieldName),
                                  TABSTable(SourceTableOrQuery).IndexFields[i]);
                    RecordWasFound := TABSTable(SourceTableOrQuery).GotoKey;
                  end
                else
                  begin
                    if (FieldList.Count = 1) then
                      v := DestTable.FieldByName(FieldList[0]).AsVariant
                    else
                      for i:=0 to FieldList.Count-1 do
                        v[i] := DestTable.FieldByName(FieldList[i]).AsVariant;
                    RecordWasFound := TABSTable(SourceTableOrQuery).Locate(KeyFields, v, []);
                  end;
                if not RecordWasFound then
                  DestTable.Delete
                else
                  DestTable.Next;
                Inc(rn);
              end;

            if SourceTableOrQuery is TABSTable then
              begin
                if (OldSrcIndexFieldNames <> '') then
                  TABSTable(SourceTableOrQuery).IndexFieldNames := OldSrcIndexFieldNames
                else
                  TABSTable(SourceTableOrQuery).IndexName := OldSrcIndexName;
              end;
          end;
      finally
        //after
        InternalAfterBatchMove(SourceTableOrQuery);
      end;

      if (OldDstIndexFieldNames <> '') then
        DestTable.IndexFieldNames := OldDstIndexFieldNames
      else
        DestTable.IndexName := OldDstIndexName;
      DestTable.MasterSource := OldMasterSource;
    finally
      try
        if (IsDestIndexCreated) then
          DestTable.DeleteIndex(TempDestIndex);
        if (IsSrcIndexCreated) then
          TABSTable(SourceTableOrQuery).DeleteIndex(TempSrcIndex);
      finally
        SourceTableOrQuery.EnableControls;
        DestTable.EnableControls;
        FieldList.Free;
        AscDescList.Free;
        CaseInsList.Free;
        TmpList.Free;
      end;
    end;

    SourceTableOrQuery.GotoBookmark(SrcBookmark);
    SourceTableOrQuery.FreeBookmark(SrcBookmark);
    if (DestTable.BookmarkValid(DstBookmark)) then
      DestTable.GotoBookmark(DstBookmark);
    DestTable.FreeBookmark(DstBookmark);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//BatchMove


//------------------------------------------------------------------------------
// restructure table
//------------------------------------------------------------------------------
function TABSTable.RestructureTable(var Log: string): Boolean;
var DstTable:   TABSTable;
    Continue:   Boolean;
    OldTableName: string;
    TempTableName: string;
    TmpRestructureFieldDefs: TABSAdvFieldDefs;
    OldFiltered: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.RestructureTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    Continue := True;


    OldTableName := TableName;

      RenameTable(GetTemporaryName('OLD_' + TableName + '_'));
      try
        DstTable := TABSTable.Create(nil);
        try
          // Create Output Table
          DstTable.FTableName := OldTableName;
          DstTable.FInMemory := Self.FInMemory;
          DstTable.FTemporary := Self.FTemporary;
          DstTable.FDatabaseName := Self.FDatabaseName;
          DstTable.FSessionName := Self.SessionName;
          DstTable.AdvFieldDefs.Assign(FRestructureFieldDefs);
          DstTable.AdvIndexDefs.Assign(FRestructureIndexDefs);
          DstTable.IgnoreDesignMode := Self.IgnoreDesignMode;
          try
           DstTable.CreateTable;
          except
           on e: Exception do
            begin
              Log := Log + Format(ErrorLRestructureTableCannotCreateTable,[e.Message]);
              Result := False;
              if (e is EABSException) then
               if (EABSException(e).NativeError = 20182) then
                raise EABSException.Create(20180, ErrorADatabaseInTransaction, ['RestructureTable']);
              if (TableName <> OldTableName) then
                begin
                  TempTableName := TableName;
                  TableName := OldTableName;
                  if (Exists) then
                    DeleteTable;
                  TableName := TempTableName;
                  RenameTable(OldTableName);
                end;
              Exit;
            end;
          end;

          // Open all
          DstTable.Open;
          TmpRestructureFieldDefs := TABSAdvFieldDefs.Create;
          TmpRestructureFieldDefs.Assign(FRestructureFieldDefs);
          try
            Open;
            // restore restructure field defs
            FRestructureFieldDefs.Assign(TmpRestructureFieldDefs);
            try
              InternalBeforeRestructure(Self);
              // Copy Records
              OldFiltered := Filtered;
              try
                Filtered := False;
                Result := InternalCopyRecords(self, DstTable, Log, Continue, False, True,
                                            InternalOnRestructureProgress, 0, 99);
              finally
                Filtered := OldFiltered;
              end;
            finally
              InternalAfterRestructure(Self);
              // Close all
              Close;
              DstTable.Close;
            end;
          finally
            TmpRestructureFieldDefs.Free;
          end;

          if Result then
            begin
          // Delete Src Table
          try
           DeleteTable;
          except
           on e: Exception do
            begin
              Log := Log + Format(ErrorLRestructureTableCannotDeleteTable,[e.Message]);
              Result := False;
            end;
          end;
          // Rename Tmp Table to Self
          TableName := DstTable.TableName;
            end
          else
            begin
              DstTable.DeleteTable;
              RenameTable(DstTable.TableName);
            end;
        finally
          DstTable.Free;
        end;
      except
        if (TableName <> OldTableName) then
          begin
            TempTableName := TableName;
            TableName := OldTableName;
            if (Exists) then
              DeleteTable;
            TableName := TempTableName;
            RenameTable(OldTableName);
          end;
        raise;
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // RestructureTable


//------------------------------------------------------------------------------
// restructure table
//------------------------------------------------------------------------------
function TABSTable.RestructureTable: Boolean;
var s: string;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.RestructureTable';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
   Result := RestructureTable(s);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // RestructureTable


//------------------------------------------------------------------------------
// ExportToSQL
//------------------------------------------------------------------------------
procedure TABSTable.ExportToSQL(Stream: TStream);
var
  i,j,k,l: Integer;
  d,d1,d2: string;
  Fields, DescFields, CaseInsFields: TStringList;
  OldDecimalSeparator: AnsiChar;
  yyyy,mm,dd,hh,nn,ss,ms: Word;
  dt: TDateTime;
  MimeCoder: TStringFormat_MIME64;

 function Quoter(const s: string): string;
 begin
   if (Pos(' ', s ) <= 0) and (FindReservedWord(s) < 0) and (Pos('-', s) <= 0) then
     Result := s
   else
     Result := QuotedStr(s);
 end;

 procedure ToStream(s:String);
 begin
  if (Stream is TStringStream) then
    TStringStream(Stream).WriteString(s)
  else
    Stream.Write(PAnsiChar(AnsiString(s))^, length(s));
 end;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ExportToSQL';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    Open;
    try
      if ExportToSqlOptions.Structure then
       begin
        if ExportToSqlOptions.AddDropTable then
          ToStream('DROP TABLE ' + Quoter(TableName) + ';'#13#10);

        ToStream('CREATE TABLE ' + Quoter(TableName) + ' ('#13#10);

        d := '';
        for i:=0 to AdvFieldDefs.Count-1 do
         begin
           ToStream(d);
           // Name
           ToStream('  ' + Quoter(AdvFieldDefs[i].Name));

           // Type
           if (AdvFieldDefs[i].DataType = aftString) then
             ToStream(' VARCHAR')
           else
             ToStream(' ' + AftToStr(AdvFieldDefs[i].DataType));

           // Size
           if IsSizebleFieldType(AdvFieldDefs[i].DataType) then
             ToStream('(' + IntToStr(AdvFieldDefs[i].Size) + ')');

           // Blob Settings
           if ExportToSqlOptions.BlobSettings and IsBLOBFieldType(AdvFieldDefs[i].DataType) then
            begin
              ToStream(' BLOBBlockSize ' + IntToStr(AdvFieldDefs[i].BLOBBlockSize));
              ToStream(' BLOBCompressionAlgorithm ' +
                        ABSCompressionAlgorithmNames[Integer(AdvFieldDefs[i].BLOBCompressionAlgorithm)]);
              ToStream(' BLOBCompressionMode ' + IntToStr(AdvFieldDefs[i].BLOBCompressionMode));
            end;


           // Default
           if not AdvFieldDefs[i].DefaultValue.IsNull then
            begin
             ToStream(' DEFAULT ');
             if IsStringFieldType(AdvFieldDefs[i].DataType) then
               ToStream('''' + AdvFieldDefs[i].DefaultValue.AsWideString + '''')
             else
               ToStream(AdvFieldDefs[i].DefaultValue.AsAnsiString);
            end;

           // NOT NULL
           if AdvFieldDefs[i].Required then
             ToStream(' NOT NULL');

           // MIN Value
           if not AdvFieldDefs[i].MinValue.IsNull then
            begin
             ToStream(' MINVALUE ');
             if IsStringFieldType(AdvFieldDefs[i].DataType) then
               ToStream('''' + AdvFieldDefs[i].MinValue.AsAnsiString + '''')
             else
               ToStream(AdvFieldDefs[i].MinValue.AsAnsiString);
            end;


           // MAX Value
           if not AdvFieldDefs[i].MaxValue.IsNull then
            begin
             ToStream(' MAXVALUE ');
             if IsStringFieldType(AdvFieldDefs[i].DataType) then
               ToStream('''' + AdvFieldDefs[i].MaxValue.AsAnsiString + '''')
             else
               ToStream(AdvFieldDefs[i].MaxValue.AsAnsiString);
            end;

           d := ','#13#10;
         end;

        d1 := ', '#13#10;
        // INDEXES
        Fields := TStringList.Create;
        DescFields := TStringList.Create;
        CaseInsFields := TStringList.Create;
        try
          for j:=0 to AdvIndexDefs.Count-1 do
            begin
              ToStream(d1);
              GetNamesList(Fields, AdvIndexDefs[j].Fields);
              GetNamesList(DescFields, AdvIndexDefs[j].DescFields);
              GetNamesList(CaseInsFields, AdvIndexDefs[j].CaseInsFields);
              // PRIMARY KEY
              if (ixPrimary in AdvIndexDefs[j].Options) then
                ToStream('  PRIMARY KEY')
              // UNIQUE
              else if (ixUnique in AdvIndexDefs[j].Options) then
                ToStream('  UNIQUE INDEX')
              else
                ToStream('  INDEX');

              // Index Name
              if AdvIndexDefs[j].Name <> '' then
                ToStream(' ' + Quoter(AdvIndexDefs[j].Name));

              // Fields
              ToStream(' (');
              d2 := '';
              for k:=0 to Fields.Count-1 do
                begin
                  ToStream(d2);
                  ToStream(Quoter(Fields[k]));
                  // DESC
                  for l:=0 to DescFields.Count-1 do
                    if (AnsiUpperCase(DescFields[l]) = AnsiUpperCase(Fields[k])) then
                      begin
                        ToStream(' DESC');
                        Break;
                      end;
                  // NOCASE
                  for l:=0 to CaseInsFields.Count-1 do
                    if (AnsiUpperCase(CaseInsFields[l]) = AnsiUpperCase(Fields[k])) then
                      begin
                        ToStream(' NOCASE');
                        Break;
                      end;

                  d2 := ', ';
                end;
              ToStream(')');
              d1 := ', '#13#10;
            end;
        finally
          Fields.Free;
          DescFields.Free;
          CaseInsFields.Free;
        end;

        ToStream(#13#10');'#13#10);
      end; // Structure

        // Insert Data
      if ExportToSqlOptions.Data then
          begin
            OldDecimalSeparator := AnsiChar({$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif});
            {$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif} := '.';
            First;
            while not EOF do
              begin
               ToStream('INSERT INTO ');
               ToStream(Quoter(TableName) + ' ');

                // Metadata
               if ExportToSqlOptions.FieldNamesInInserts then
                 begin
                   ToStream('(');
                   d := '';
                   for i:=0 to AdvFieldDefs.Count-1 do
                     begin
                      ToStream(d + Quoter(AdvFieldDefs[i].Name));
                      d := ', ';
                     end;
                   ToStream(') values (');
                 end
               else
                 ToStream('values (');
                // Data
                d := '';
                for i:=0 to AdvFieldDefs.Count-1 do
                 begin
                 ToStream(d);
                  d := ', ';
                 // NULL
                  if self.Fields[i].IsNull then
                   ToStream('NULL')
                 // Strings or WideStrings or Memo
                  else if IsStringFieldType(AdvFieldDefs[i].DataType) or
                          (AdvFieldDefs[i].DataType = aftMemo) then
                   ToStream(QuotedStr(self.Fields[i].asString))
                 // Numeric
                  else if IsNumericFieldType(AdvFieldDefs[i].DataType) then
                   ToStream(self.Fields[i].asString)
                 // DateTime
                  else if IsDateTimeFieldType(AdvFieldDefs[i].DataType) then
                  begin
                    dt := self.Fields[i].AsDateTime;
                    DecodeDate(dt,yyyy,mm,dd);
                    DecodeTime(dt,hh,nn,ss,ms);
                    case AdvFieldDefs[i].DataType of
                     aftDate:
                       ToStream(Format('''%.4d-%.2d-%.2d''',[yyyy,mm,dd]));
                     aftTime:
                       ToStream(Format('ToDate(''%.2d:%.2d:%.2d'',''HH24:NN:SS'')',[hh,nn,ss]));
                     aftDateTime,
                     aftTimeStamp:
                       ToStream(Format('''%.4d-%.2d-%.2d %.2d:%.2d:%.2d''',[yyyy,mm,dd,hh,nn,ss]));
                    end;
                  end
                 // Boolean
                 else if (AdvFieldDefs[i].DataType = aftBoolean) then
                   ToStream(BoolToStr(self.Fields[i].AsBoolean, true))
                 // BLOB
                  else if IsBLOBFieldType(AdvFieldDefs[i].DataType) then
                   begin
                     MimeCoder := TStringFormat_MIME64.Create;
                     try
{$IFDEF D12H}
                       ToStream('MimeToBin(''' +
                          MimeCoder.StrTo(PAnsiChar(self.Fields[i].AsAnsiString),
                                          Length(self.Fields[i].AsAnsiString)) + ''')')
{$ELSE}
                       ToStream('MimeToBin(''' +
                          MimeCoder.StrTo(PAnsiChar(self.Fields[i].AsString),
                                          Length(self.Fields[i].AsString)) + ''')')
{$ENDIF}
                     finally
                       MimeCoder.Free;
                     end;
                   end;
                 end;
               ToStream(');'#13#10);

                Next;
              end;
              {$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif} := Char(OldDecimalSeparator);
          end;// Data

       ToStream(#13#10);

    finally
      Close;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//ExportToSQL


//------------------------------------------------------------------------------
// ExportToSQL
//------------------------------------------------------------------------------
procedure TABSTable.ExportToSQL(FileName: string);
var
  fs: TFileStream;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ExportToSQL';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    fs := TFileStream.Create(FileName, fmCreate or fmOpenWrite or fmShareDenyWrite);
    try
      ExportToSQL(fs);
    finally
      fs.Free;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//ExportToSQL


//------------------------------------------------------------------------------
// ExportToSQL
//------------------------------------------------------------------------------
function TABSTable.ExportToSQL: string;
var
  st: TStringStream;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ExportToSQL';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := '';
{$IFDEF D12H}
    st := TStringStream.Create('',TUnicodeEncoding.Create);
{$ELSE}
    st := TStringStream.Create('');
{$ENDIF}
    try
      ExportToSQL(st);
      Result := st.DataString;
    finally
      st.Free;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//ExportToSQL


//------------------------------------------------------------------------------
// Rename Field by Name
//------------------------------------------------------------------------------
procedure TABSTable.RenameField(FieldName, NewFieldName: string);
var
  OldExclusive: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.RenameField';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckInactive;
    OldExclusive := FExclusive;
    try
      FExclusive := True;
      Open;
      try
        if (FHandle.Session.InTransaction) then
          raise EABSException.Create(20179, ErrorADatabaseInTransaction, ['RenameField']);
        // Rename
        FHandle.RenameField(FieldName, NewFieldName);
      finally
        Close;
      end;
    finally
      FExclusive := OldExclusive;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//RenameField


//------------------------------------------------------------------------------
// create new index
//------------------------------------------------------------------------------
procedure TABSTable.AddIndex(
              const Name,
              Fields: string;
              Options: TIndexOptions;
              const DescFields: string = '';
              const CaseInsFields: string = ''
                   );
var
  TmpCursor: TABSCursor;
  ABSIndexDef: TABSIndexDef;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.AddIndex';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    FieldDefs.Update;
    SetDBFlag(dbfIndexList,True);
    try
      if (FHandle = nil) then
        TmpCursor := GetHandle
      else
        begin
         CheckBrowseMode;
         CursorPosChanged;
         TmpCursor := FHandle;
       end;
      ABSIndexDef := TABSIndexDef.Create;
      try
       if (Name = '') then
        raise EABSException.Create(20046, ErrorAInvalidIndexName, ['']);
       if (Fields = '') then
        raise EABSException.Create(20047, ErrorACannotFindIndexField, ['']);
       if (TmpCursor.Session.InTransaction) then
        raise EABSException.Create(20175, ErrorADatabaseInTransaction, ['AddIndex']);
       FillABSIndexDef(ABSIndexDef, Name, Fields, Options, False, DescFields, CaseInsFields,
                       '', FieldDefs);
       TmpCursor.InternalInitFieldDefs;
       if (TmpCursor.LockTable(ltX, OpenTableLockRetries, OpenTableLockDelay)) then
         try
           TmpCursor.AddIndex(ABSIndexDef);
         finally
           TmpCursor.UnlockTable(ltX);
         end
       else
         raise EABSException.Create(20228, ErrorACannotOpenTableInExclusiveMode, [FTableName]);
      finally
         ABSIndexDef.Free;
         if (FHandle = nil) then
          TmpCursor.Free;
      end;
      FIndexDefs.Updated := False;
    finally
      SetDBFlag(dbfIndexList,False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// AddIndex


//------------------------------------------------------------------------------
// DeleteIndex
//------------------------------------------------------------------------------
procedure TABSTable.DeleteIndex(const Name: string);
var
  TmpCursor: TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.DeleteIndex';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetDBFlag(dbfIndexList, True);
    try
      if (FHandle = nil) then
        TmpCursor := GetHandle
      else
        begin
          CheckBrowseMode;
          TmpCursor := FHandle;
        end;
      try
        if (TmpCursor.Session.InTransaction) then
         raise EABSException.Create(20177, ErrorADatabaseInTransaction, ['DeleteIndex']);
        TmpCursor.InternalInitFieldDefs;
        TmpCursor.DeleteIndex(Name);
      finally
        if (FHandle = nil) then
         TmpCursor.Free;
      end;
      FIndexDefs.Updated := False;
    finally
      SetDBFlag(dbfIndexList, False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// DeleteIndex


//------------------------------------------------------------------------------
// DeleteAllIndexes
//------------------------------------------------------------------------------
procedure TABSTable.DeleteAllIndexes;
var
  TmpCursor: TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.DeleteAllIndexes';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetDBFlag(dbfIndexList, True);
    try
      if (FHandle = nil) then
        TmpCursor := GetHandle
      else
        begin
          CheckBrowseMode;
          TmpCursor := FHandle;
        end;
      try
        if (TmpCursor.Session.InTransaction) then
         raise EABSException.Create(20178, ErrorADatabaseInTransaction, ['DeleteAllIndexes']);
        TmpCursor.InternalInitFieldDefs;
        TmpCursor.DeleteAllIndexes;
      finally
        if (FHandle = nil) then
         TmpCursor.Free;
      end;
      FIndexDefs.Updated := False;
    finally
      SetDBFlag(dbfIndexList, False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// DeleteAllIndexes


//------------------------------------------------------------------------------
// ValidateAndRepairMostUpdatedAndRecordPageIndex
//------------------------------------------------------------------------------
procedure TABSTable.ValidateAndRepairMostUpdatedAndRecordPageIndex;
var
  TmpCursor: TABSCursor;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ValidateAndRepairMostUpdatedAndRecordPageIndex';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  TmpCursor := nil;
  try
    SetDBFlag(dbfRepair, True);
    try
      try
        FIsRepairing := True;
        TmpCursor := GetHandle;
      finally
       FIsRepairing := False;
       if Assigned(TmpCursor) then TmpCursor.Free;
      end;
    finally
      SetDBFlag(dbfRepair, False);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;// ValidateAndRepairMostUpdatedAndRecordPageIndex


//------------------------------------------------------------------------------
// check set key mode
//------------------------------------------------------------------------------
procedure TABSTable.CheckSetKeyMode;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CheckSetKeyMode';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (State <> dsSetKey) then
      DatabaseError(ErrorLDatasetIsNotInEditOrInsertMode, Self);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // CheckSetKeyMode


//------------------------------------------------------------------------------
// get key buffer
//------------------------------------------------------------------------------
function TABSTable.GetKeyBuffer(KeyIndex: TABSKeyIndex): TABSRecordBuffer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetKeyBuffer';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := FKeyBuffers[KeyIndex];
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetKeyBuffer


//------------------------------------------------------------------------------
// return true if key is exclusive
//------------------------------------------------------------------------------
function TABSTable.GetKeyExclusive: Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetKeyExclusive';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10282,ErrorLNilPointer);
    CheckSetKeyMode;
    Result := PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.Exclusive;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetKeyExclusive


//------------------------------------------------------------------------------
// return key field count
//------------------------------------------------------------------------------
function TABSTable.GetKeyFieldCount: Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GetKeyFieldCount';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10284,ErrorLNilPointer);
    CheckSetKeyMode;
    Result := PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.FieldCount;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GetKeyFieldCount


//------------------------------------------------------------------------------
// set key exclusive
//------------------------------------------------------------------------------
procedure TABSTable.SetKeyExclusive(Value: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetKeyExclusive';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10283,ErrorLNilPointer);
    CheckSetKeyMode;
    PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.Exclusive := Value;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetKeyExclusive


//------------------------------------------------------------------------------
// set key field count
//------------------------------------------------------------------------------
procedure TABSTable.SetKeyFieldCount(Value: Integer);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetKeyFieldCount';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10285,ErrorLNilPointer);
    CheckSetKeyMode;
    PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.FieldCount := Value;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetKeyFieldCount


//------------------------------------------------------------------------------
// set key buffer
//------------------------------------------------------------------------------
procedure TABSTable.SetKeyBuffer(KeyIndex: TABSKeyIndex; Clear: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetKeyBuffer';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10286,ErrorLNilPointer);
    CheckBrowseMode;
    FKeyBuffer := FKeyBuffers[KeyIndex];
    Move(FKeyBuffer^, FKeyBuffers[kiSave]^, FHandle.KeyBufferSize);
    if (Clear) then
      InitKeyBuffer(FKeyBuffer);
    SetState(dsSetKey);
    SetModified(PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.Modified);
    DataEvent(deDataSetChange, 0);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetKeyBuffer


//------------------------------------------------------------------------------
// set key fields
//------------------------------------------------------------------------------
procedure TABSTable.SetKeyFields(KeyIndex: TABSKeyIndex; const Values: array of const);
var
    i:          Integer;
    SaveState:  TDataSetState;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetKeyFields';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10289,ErrorLNilPointer);
    if (not IsIndexApplied) then
      DatabaseError(ErrorLNoFieldIndexes, Self);
    SaveState := SetTempState(dsSetKey);
    try
      FKeyBuffer := InitKeyBuffer(FKeyBuffers[KeyIndex]);
      for i := 0 to High(Values) do
        GetIndexField(i).AssignValue(Values[i]);
      PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.FieldCount := High(Values) + 1;
      PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.Modified := Modified;
    finally
      RestoreState(SaveState);
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetKeyFields


//------------------------------------------------------------------------------
// post key buffer
//------------------------------------------------------------------------------
procedure TABSTable.PostKeyBuffer(Commit: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.PostKeyBuffer';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10288,ErrorLNilPointer);
    DataEvent(deCheckBrowseMode, 0);
    if (Commit) then
      PABSKeyBuffer(FKeyBuffer + FHandle.KeyOffset)^.Modified := Modified
    else
      Move(FKeyBuffers[kiSave]^, FKeyBuffer^, FHandle.KeyBufferSize);
    SetState(dsBrowse);
    DataEvent(deDataSetChange, 0);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // PostKeyBuffer


//------------------------------------------------------------------------------
// find key
//------------------------------------------------------------------------------
function TABSTable.FindKey(const KeyValues: array of const): Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.FindKey';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckBrowseMode;
    SetKeyFields(kiLookup, KeyValues);
    Result := GotoKey;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // FindKey


//------------------------------------------------------------------------------
// find nearest
//------------------------------------------------------------------------------
procedure TABSTable.FindNearest(const KeyValues: array of const);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.FindNearest';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckBrowseMode;
    SetKeyFields(kiLookup, KeyValues);
    GotoNearest;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // FindNearest


//------------------------------------------------------------------------------
// goto key
//------------------------------------------------------------------------------
function TABSTable.GotoKey: Boolean;
var
  SearchCondition:    TABSSearchCondition;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GotoKey';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10290,ErrorLNilPointer);
    CheckBrowseMode;
    DoBeforeScroll;
    CursorPosChanged;
    SearchCondition := scEqual;
    FHandle.KeyBuffer := GetKeyBuffer(kiLookup);
    FHandle.KeyFieldCount := PABSKeyBuffer(FHandle.KeyBuffer + FHandle.KeyOffset)^.FieldCount;
    if (FHandle.KeyFieldCount = 0) then
     FHandle.KeyFieldCount := FIndexFieldCount;
    Result := FHandle.FindKey(SearchCondition);
    if (Result) then
     begin
      if (Handle.LockTable(ltS, RangeTablesLockRetries, RangeTablesLockDelay)) then
        begin
          Resync([rmExact, rmCenter]);
          Handle.UnlockTable(ltS);
        end
      else
        Resync([rmExact, rmCenter]);
      DoAfterScroll;
     end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GotoKey


//------------------------------------------------------------------------------
// goto nearest
//------------------------------------------------------------------------------
procedure TABSTable.GotoNearest;
var
  SearchCondition: TABSSearchCondition;
  Result:          Boolean;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.GotoNearest';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if (FHandle = nil) then
      raise EABSException.Create(10291,ErrorLNilPointer);
    CheckBrowseMode;
    CursorPosChanged;
    FHandle.KeyBuffer := GetKeyBuffer(kiLookup);
    if (PABSKeyBuffer(FHandle.KeyBuffer + FHandle.KeyOffset)^.Exclusive) then
      SearchCondition := scGreater
    else
      SearchCondition := scGreaterEqual;
    FHandle.KeyFieldCount := PABSKeyBuffer(FHandle.KeyBuffer + FHandle.KeyOffset)^.FieldCount;
    if (FHandle.KeyFieldCount = 0) then
      FHandle.KeyFieldCount := FIndexFieldCount;
    Result := FHandle.FindKey(SearchCondition);
    if (Handle.LockTable(ltS, RangeTablesLockRetries, RangeTablesLockDelay)) then
      begin
        // if nearest record was not find go to last record
        if (not Result) then
          Last;
        Resync([rmCenter]);
        Handle.UnlockTable(ltS);
      end
    else
      begin
        // if nearest record was not find go to last record
        if (not Result) then
          Last;
        Resync([rmCenter]);
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // GotoNearest


//------------------------------------------------------------------------------
// edit key
//------------------------------------------------------------------------------
procedure TABSTable.EditKey;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.EditKey';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetKeyBuffer(kiLookup, False);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // EditKey


//------------------------------------------------------------------------------
// set key
//------------------------------------------------------------------------------
procedure TABSTable.SetKey;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetKey';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetKeyBuffer(kiLookup, True);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetKey


//------------------------------------------------------------------------------
// set range
//------------------------------------------------------------------------------
function TABSTable.SetCursorRange: Boolean;
var StartBuffer, EndBuffer:       TABSRecordBuffer;
    StartExclusive, EndExclusive: Boolean;
    StartKeyFieldCount,
    EndKeyFieldCount:             Integer;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetCursorRange';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := False;
    if (FHandle = nil) then
      raise EABSException.Create(10296,ErrorLNilPointer);
    FHandle.ClearStringFieldsGarbage(FKeyBuffers[kiRangeStart]);
    FHandle.ClearStringFieldsGarbage(FKeyBuffers[kiCurRangeStart]);
    FHandle.ClearStringFieldsGarbage(FKeyBuffers[kiRangeEnd]);
    FHandle.ClearStringFieldsGarbage(FKeyBuffers[kiCurRangeEnd]);
    if (not (
              BuffersEqual(FKeyBuffers[kiRangeStart], FKeyBuffers[kiCurRangeStart],
                FHandle.KeyBufferSize)
             and
              BuffersEqual(FKeyBuffers[kiRangeEnd], FKeyBuffers[kiCurRangeEnd],
                FHandle.KeyBufferSize))) then
    begin
      StartBuffer := FKeyBuffers[kiRangeStart];
      StartKeyFieldCount := PABSKeyBuffer(StartBuffer + FHandle.KeyOffset)^.FieldCount;
      if (StartKeyFieldCount = 0) then
       StartKeyFieldCount := FIndexFieldCount;
      StartExclusive := PABSKeyBuffer(StartBuffer + FHandle.KeyOffset)^.Exclusive;
      EndBuffer := FKeyBuffers[kiRangeEnd];
      EndKeyFieldCount := PABSKeyBuffer(EndBuffer + FHandle.KeyOffset)^.FieldCount;
      if (EndKeyFieldCount = 0) then
       EndKeyFieldCount := FIndexFieldCount;
      EndExclusive := PABSKeyBuffer(EndBuffer + FHandle.KeyOffset)^.Exclusive;
      FHandle.ApplyRange(StartBuffer,EndBuffer,
                         StartKeyFieldCount,EndKeyFieldCount,
                         StartExclusive, EndExclusive);
      Move(FKeyBuffers[kiRangeStart]^, FKeyBuffers[kiCurRangeStart]^,
        FHandle.KeyBufferSize);
      Move(FKeyBuffers[kiRangeEnd]^, FKeyBuffers[kiCurRangeEnd]^,
        FHandle.KeyBufferSize);
      Result := True;
    end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetCursorRange


//------------------------------------------------------------------------------
// apply range
//------------------------------------------------------------------------------
procedure TABSTable.ApplyRange;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.ApplyRange';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckBrowseMode;
    if (SetCursorRange) then
      begin
        if (Handle.LockTable(ltS, RangeTablesLockRetries, RangeTablesLockDelay)) then
          begin
            try
              First;
            finally
              Handle.UnlockTable(ltS);
            end;
          end
        else
          First;
      end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // ApplyRange


//------------------------------------------------------------------------------
// cancel range
//------------------------------------------------------------------------------
procedure TABSTable.CancelRange;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.CancelRange';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckBrowseMode;
    UpdateCursorPos;
    if (ResetCursorRange) then
      if (Handle.LockTable(ltS, RangeTablesLockRetries, RangeTablesLockDelay)) then
        begin
          Resync([]);
          Handle.UnlockTable(ltS);
        end
      else
        Resync([]);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // CancelRange


//------------------------------------------------------------------------------
// edit range start
//------------------------------------------------------------------------------
procedure TABSTable.EditRangeStart;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.EditRangeStar';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetKeyBuffer(kiRangeStart, False);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // EditRangeStart


//------------------------------------------------------------------------------
// edit range end
//------------------------------------------------------------------------------
procedure TABSTable.EditRangeEnd;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.EditRangeEnd';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetKeyBuffer(kiRangeEnd, False);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // EditRangeEnd


//------------------------------------------------------------------------------
// set range
//------------------------------------------------------------------------------
procedure TABSTable.SetRange(const StartValues, EndValues: array of const);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetRange';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    CheckBrowseMode;
    SetKeyFields(kiRangeStart, StartValues);
    SetKeyFields(kiRangeEnd, EndValues);
    ApplyRange;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetRange


//------------------------------------------------------------------------------
// set range start
//------------------------------------------------------------------------------
procedure TABSTable.SetRangeStart;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetRangeStart';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetKeyBuffer(kiRangeStart, True);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetRangeStart


//------------------------------------------------------------------------------
// set range end
//------------------------------------------------------------------------------
procedure TABSTable.SetRangeEnd;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.SetRangeEnd';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    SetKeyBuffer(kiRangeEnd, True);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // SetRangeEnd


//------------------------------------------------------------------------------
// post
//------------------------------------------------------------------------------
procedure TABSTable.Post;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.Post';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    inherited Post;
    if (State = dsSetKey) then
      PostKeyBuffer(True);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // Post


//------------------------------------------------------------------------------
// cancel
//------------------------------------------------------------------------------
procedure TABSTable.Cancel;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.Cancel';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    inherited Cancel;
    if (State = dsSetKey) then
      PostKeyBuffer(False);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end; // Cancel


//------------------------------------------------------------------------------
// IsRecordLocked
//------------------------------------------------------------------------------
function TABSTable.IsRecordLocked: Boolean;
begin
  if (FHandle <> nil) then
    Result := FHandle.IsRecordLocked
  else
    Result := False;
end;// IsRecordLocked


//------------------------------------------------------------------------------
// LastAutoincValue
//------------------------------------------------------------------------------
function TABSTable.LastAutoincValue(FieldIndex: Integer): Int64;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.LastAutoincValue';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := FHandle.LastAutoincValue(FieldIndex);
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//LastAutoincValue


//------------------------------------------------------------------------------
// LastAutoincValue
//------------------------------------------------------------------------------
function TABSTable.LastAutoincValue(FieldName: string): Int64;
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.LastAutoincValue';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    Result := LastAutoincValue(Fields.IndexOf(Fields.FieldByName(FieldName)));
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//LastAutoincValue


//------------------------------------------------------------------------------
// Internal BeforeCopy Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalBeforeCopy(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalBeforeCopy';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(BeforeCopy) then
      BeforeCopy(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          frmWait:=TfrmWait.Create(nil);
          frmWait.pb.Position := 0;
          frmWait.Show(SCopyTableDialogMessage);
          Application.ProcessMessages;
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalBeforeCopy


//------------------------------------------------------------------------------
// Internal OnCopyProgress Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalOnCopyProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalOnCopyProgress';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(OnCopyProgress) then
      OnCopyProgress(Sender, PercentDone, Continue)
    else
      if not (Database.SilentMode or Temporary) then
       begin
        {$IFNDEF NO_DIALOGS}
        frmWait.pb.Position := PercentDone;
        Application.ProcessMessages;
        Continue := not frmWait.Terminated;
        {$ENDIF}
       end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalOnCopyProgress


//------------------------------------------------------------------------------
// Internal AfterCopy Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalAfterCopy(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'InternalAfterCopy';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(AfterCopy) then
      AfterCopy(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          if (frmWait <> nil) then
            begin
              frmWait.Close;
              frmWait := nil;
            end;
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalAfterCopy


//------------------------------------------------------------------------------
// Internal BeforeImport Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalBeforeImport(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalBeforeImport';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(BeforeImport) then
      BeforeImport(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          frmWait:=TfrmWait.Create(nil);
          frmWait.pb.Position := 0;
          frmWait.Show(SImportTableDialogMessage);
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalBeforeImport


//------------------------------------------------------------------------------
// Internal OnImportProgress Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalOnImportProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalOnImportProgress';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(OnImportProgress) then
      OnImportProgress(Sender, PercentDone, Continue)
    else
      if not (Database.SilentMode or Temporary) then
       begin
        {$IFNDEF NO_DIALOGS}
        frmWait.pb.Position := PercentDone;
        Application.ProcessMessages;
        Continue := not frmWait.Terminated;
        {$ENDIF}
       end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalOnImportProgress


//------------------------------------------------------------------------------
// Internal AfterImport Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalAfterImport(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalAfterImport';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(AfterImport) then
      AfterImport(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          if (frmWait <> nil) then
            begin
              frmWait.Close;
              frmWait := nil;
            end;
          {$ENDIF}
        end;

  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalAfterImport


//------------------------------------------------------------------------------
// Internal BeforeExport Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalBeforeExport(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalBeforeExport';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(BeforeExport) then
      BeforeExport(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          frmWait:=TfrmWait.Create(nil);
          frmWait.pb.Position := 0;
          frmWait.Show(SExportTableDialogMessage);
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalBeforeExport


//------------------------------------------------------------------------------
// Internal OnExportProgress Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalOnExportProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalOnExportProgress';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(OnExportProgress) then
      OnExportProgress(Sender, PercentDone, Continue)
    else
      if not (Database.SilentMode or Temporary) then
       begin
        {$IFNDEF NO_DIALOGS}
        frmWait.pb.Position := PercentDone;
        Application.ProcessMessages;
        Continue := not frmWait.Terminated;
        {$ENDIF}
       end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalOnExportProgress


//------------------------------------------------------------------------------
// Internal AfterExport Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalAfterExport(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalAfterExport';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(AfterExport) then
      AfterExport(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          if (frmWait <> nil) then
            begin
              frmWait.Close;
              frmWait := nil;
            end;
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalAfterExport


//------------------------------------------------------------------------------
// Internal BeforeRestructure Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalBeforeRestructure(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalBeforeRestructure';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(BeforeRestructure) then
      BeforeRestructure(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          frmWait:=TfrmWait.Create(nil);
          frmWait.pb.Position := 0;
          frmWait.Show(SRestructureTableDialogMessage);
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalBeforeRestructure


//------------------------------------------------------------------------------
// Internal OnRestructureProgress Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalOnRestructureProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalOnRestructureProgress';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(OnRestructureProgress) then
      OnRestructureProgress(Sender, PercentDone, Continue)
    else
      if not (Database.SilentMode or Temporary) then
       begin
        {$IFNDEF NO_DIALOGS}
        frmWait.pb.Position := PercentDone;
        Application.ProcessMessages;
        Continue := not frmWait.Terminated;
        {$ELSE}
        Continue := True;
        {$ENDIF}
       end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalOnRestructureProgress


//------------------------------------------------------------------------------
// Internal AfterRestructure Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalAfterRestructure(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalAfterRestructure';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(AfterRestructure) then
      AfterRestructure(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          if (frmWait <> nil) then
            begin
              frmWait.Close;
              frmWait := nil;

            end;
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalAfterRestructure


//------------------------------------------------------------------------------
// Internal BeforeBatchMove Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalBeforeBatchMove(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalBeforeBatchMove';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(BeforeBatchMove) then
      BeforeBatchMove(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          frmWait:=TfrmWait.Create(nil);
          frmWait.pb.Position := 0;
          frmWait.Show(SBatchMoveDialogMessage);
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalBeforeBatchMove


//------------------------------------------------------------------------------
// Internal OnBatchMoveProgress Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalOnBatchMoveProgress(Sender: TObject;
  PercentDone: Integer; var Continue: Boolean);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalOnBatchMoveProgress';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(OnBatchMoveProgress) then
      OnBatchMoveProgress(Sender, PercentDone, Continue)
    else
      if not (Database.SilentMode or Temporary) then
       begin
        {$IFNDEF NO_DIALOGS}
        frmWait.pb.Position := PercentDone;
        Application.ProcessMessages;
        Continue := not frmWait.Terminated;
        {$ELSE}
        Continue := True;
        {$ENDIF}
       end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalOnBatchMoveProgress


//------------------------------------------------------------------------------
// Internal AfterBatchMove Event
//------------------------------------------------------------------------------
procedure TABSTable.InternalAfterBatchMove(Sender: TObject);
{$IFDEF DEBUG_TRACE_DATASET}const FunctionName = 'TABSTable.InternalAfterBatchMove';{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncStart, [FunctionName]);{$ENDIF}
  try
    if Assigned(AfterBatchMove) then
      AfterBatchMove(TDataset(Sender))
    else
      if not (Database.SilentMode or Temporary) then
        begin
          {$IFNDEF NO_DIALOGS}
          if (frmWait <> nil) then
            begin
              frmWait.Close;
              frmWait := nil;
            end;
          {$ENDIF}
        end;
  finally
   {$IFDEF DEBUG_TRACE_DATASET}aaWriteToLog(SABSFuncEnd, [FunctionName]);{$ENDIF}
  end;
end;//InternalAfterBatchMove


////////////////////////////////////////////////////////////////////////////////
//
// TABSQuery
//
////////////////////////////////////////////////////////////////////////////////


{$IFDEF D6H}
//------------------------------------------------------------------------------
// execute
//------------------------------------------------------------------------------
procedure TABSQuery.PSExecute;
begin
  ExecSQL;
end; // PSExecute


//------------------------------------------------------------------------------
// get default order
//------------------------------------------------------------------------------
function TABSQuery.PSGetDefaultOrder: TIndexDef;
begin
  Result := inherited PSGetDefaultOrder;
  if not Assigned(Result) then
    Result := GetIndexForOrderBy(SQL.Text, Self);
end; // PSGetDefaultOrder


//------------------------------------------------------------------------------
// get params
//------------------------------------------------------------------------------
function TABSQuery.PSGetParams: TParams;
begin
  Result := Params;
end; // PSGetParams


//------------------------------------------------------------------------------
// get table name
//------------------------------------------------------------------------------
function TABSQuery.PSGetTableName: string;
begin
  Result := GetTableNameFromSQL(SQL.Text);
end; // PSGetTableName


//------------------------------------------------------------------------------
// set command text
//------------------------------------------------------------------------------
procedure TABSQuery.PSSetCommandText(const CommandText: string);
begin
  if CommandText <> '' then
    SQL.Text := CommandText;
end; // PSSetCommandText


//------------------------------------------------------------------------------
// set params
//------------------------------------------------------------------------------
procedure TABSQuery.PSSetParams(AParams: TParams);
begin
  if AParams.Count <> 0 then
    Params.Assign(AParams);
  Close;
end; // PSSetParams
{$ENDIF}


//------------------------------------------------------------------------------
// GetStatementHandle
//------------------------------------------------------------------------------
procedure TABSQuery.GetStatementHandle(SQLText: PChar);
begin
  FStmtHandle := TABSLocalSQLProcessor.Create(Self);
  try
    FStmtHandle.RequestLive := FRequestLive;
    FStmtHandle.InMemory := FInMemory;
    FStmtHandle.PrepareStatement(SQLText);
  except
    FStmtHandle.Free;
    FStmtHandle := nil;
    raise;
  end;
end;// GetStatementHandle


//------------------------------------------------------------------------------
// FreeStatement
//------------------------------------------------------------------------------
procedure TABSQuery.FreeStatement;
begin
  if (FStmtHandle <> nil) then
    begin
      FStmtHandle.Free;
      FStmtHandle := nil;
    end;
end;// FreeStatement


//------------------------------------------------------------------------------
// CreateCursor
//------------------------------------------------------------------------------
function TABSQuery.CreateCursor(GenHandle: Boolean): TABSCursor;
begin
  if (SQL.Count > 0) then
    begin
      FExecSQL := not GenHandle;
      try
        SetPrepared(True);
      finally
        FExecSQL := False;
      end;
      if FDataLink.DataSource <> nil then
        SetParamsFromCursor;
      Result := GetQueryCursor(GenHandle);
    end
  else
    begin
      raise EABSException.Create(20034, ErrorAEmptySQLStatement);
      Result := nil;
    end;
  FCheckRowsAffected := (Result = nil);
end;// CreateCursor


//------------------------------------------------------------------------------
// GetQueryCursor
//------------------------------------------------------------------------------
function TABSQuery.GetQueryCursor(GenHandle: Boolean): TABSCursor;
var
  i: Integer;
  Param: TABSSQLParam;
begin
  Result := nil;
    // Set Params
  if FParams.Count > 0 then
   begin
    StmtHandle.SQLParams.Clear;
    for i:=0 to FParams.Count-1 do
     begin
      Param := StmtHandle.SQLParams.AddCreated;
      Param.Name := FParams[i].Name;
      if (FParams[i].DataType <> ftUnknown) then
        begin
          Param.SetNull(AdvancedFieldTypeToBaseFieldType(
                                FieldTypeToABSAdvFieldType(FParams[i].DataType)));
          if (FParams[i].IsNull) then
            Param.DataType := AdvancedFieldTypeToBaseFieldType(
                                FieldTypeToABSAdvFieldType(FParams[i].DataType));
        end;
      if (not FParams[i].IsNull) then
        case FParams[i].DataType of
          ftBlob, ftGraphic:
            begin
              Param.DataType := bftBlob;
              Param.SetData(PAnsiChar(Params[i].AsBlob), Length(Params[i].AsBlob), bftBlob);
            end;
          ftTime:
            begin
              Param.AsTTime := FParams[i].AsTime;
            end;
          ftMemo, ftFmtMemo:
            begin
                Param.DataType := bftVarchar;
{$IFDEF D12H}
                Param.SetData(PAnsiChar(Params[i].AsAnsiString), Length(Params[i].AsAnsiString), bftVarchar);
{$ELSE}
                Param.SetData(PAnsiChar(Params[i].AsString), Length(Params[i].AsString), bftVarchar);
{$ENDIF}
            end
{$IFDEF D10H}
;         ftWideMemo:
            begin
                Param.DataType := bftWideVarchar;
                Param.SetData(PChar(Params[i].AsWideString), Length(Params[i].AsWideString)*2, bftWideVarchar);
            end
{$ENDIF}
         else
           if (FParams[i].DataType <> ftUnknown) then
             Param.AsVariant := FParams[i].Value
        end;
     end;
    end;

   if (GenHandle) then
    begin
      Result := StmtHandle.OpenQuery;
      // reopen cursor
      if Result <> nil then
        Result.FSettingProjection := True;
      FExternalHandle := Result;
      FReadOnly := StmtHandle.ReadOnly;
      if (Database <> nil) then
        FReadOnly := FReadOnly or Database.ReadOnly;
    end
   else
    StmtHandle.ExecuteQuery;
end;// GetQueryCursor

//------------------------------------------------------------------------------
// GetRowsAffected
//------------------------------------------------------------------------------
function TABSQuery.GetRowsAffected: Integer;
begin
  if Prepared then
    Result := StmtHandle.RowsAffected
  else
    Result := FRowsAffected;
end;//GetRowsAffected


//------------------------------------------------------------------------------
// QueryChanged
//------------------------------------------------------------------------------
procedure TABSQuery.QueryChanged(Sender: TObject);
var
  List: TParams;
begin
  if not (csReading in ComponentState) then
  begin
    Disconnect;
    StrDispose(SQLBinary);
    SQLBinary := nil;
    if ParamCheck or (csDesigning in ComponentState) then
    begin
      List := TParams.Create(Self);
      try
        FText := StringReplace(
                   List.ParseSQL(StringReplace(SQL.Text, '":"', '"<cut colon>"', [rfReplaceAll]),  True),
                   '"<cut colon>"', '":"', [rfReplaceAll]);
        List.AssignValues(FParams);
        FParams.Clear;
        FParams.Assign(List);
      finally
        List.Free;
      end;
     end
    else
      FText := SQL.Text;
    DataEvent(dePropertyChange, 0);
   end
  else
    FText := FParams.ParseSQL(SQL.Text, False);
end;// QueryChanged


//------------------------------------------------------------------------------
// GetDataSource
//------------------------------------------------------------------------------
function TABSQuery.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;// GetDataSource


//------------------------------------------------------------------------------
// SetDataSource
//------------------------------------------------------------------------------
procedure TABSQuery.SetDataSource(Value: TDataSource);
begin
  if IsLinkedTo(Value) then
   DatabaseError(ErrorACircularDataLink, Self);
  FDataLink.DataSource := Value;
end;// SetDataSource


//------------------------------------------------------------------------------
// SetQuery
//------------------------------------------------------------------------------
procedure TABSQuery.SetQuery(Value: TStrings);
begin
  if SQL.Text <> Value.Text then
   begin
    Disconnect;
    SQL.BeginUpdate;
    try
      SQL.Assign(Value);
    finally
      SQL.EndUpdate;
    end;
   end;
end;// SetQuery


//------------------------------------------------------------------------------
// InternalRefresh
//------------------------------------------------------------------------------
procedure TABSQuery.InternalRefresh;
begin
  if (Active) then
    begin
      if ReadOnly then
        begin
          Close;
          Open;
        end
      else
        inherited;
    end;
end;// InternalRefresh


//------------------------------------------------------------------------------
// GetParamsCount
//------------------------------------------------------------------------------
function TABSQuery.GetParamsCount: Word;
begin
  Result := FParams.Count;
end;// GetParamsCount


//------------------------------------------------------------------------------
// RefreshParams
//------------------------------------------------------------------------------
procedure TABSQuery.RefreshParams;
var
  DataSet: TDataSet;
begin
  DisableControls;
  try
    if FDataLink.DataSource <> nil then
    begin
      DataSet := FDataLink.DataSource.DataSet;
      if DataSet <> nil then
        if DataSet.Active and (DataSet.State <> dsSetKey) then
        begin
          Close;
          Open;
        end;
    end;
  finally
    EnableControls;
  end;
end;// RefreshParams


//------------------------------------------------------------------------------
// SetParamsList
//------------------------------------------------------------------------------
procedure TABSQuery.SetParamsList(Value: TParams);
begin
  FParams.AssignValues(Value);
end;// SetParamsList


//------------------------------------------------------------------------------
// SetParamsFromCursor
//------------------------------------------------------------------------------
procedure TABSQuery.SetParamsFromCursor;
var
  I: Integer;
  DataSet: TDataSet;
begin
  if FDataLink.DataSource <> nil then
  begin
    DataSet := FDataLink.DataSource.DataSet;
    if DataSet <> nil then
    begin
      DataSet.FieldDefs.Update;
      for I := 0 to FParams.Count - 1 do
       if not FParams[I].Bound then
          begin
           FParams[I].AssignField(DataSet.FieldByName(FParams[I].Name));
           FParams[I].Bound := False;
           if (FParams[I].IsNull) then
            FParams[I].DataType := ftInteger; // avoid evaluating to true of StrField=''
          end;
    end;
  end;
end;// SetParamsFromCursor


//------------------------------------------------------------------------------
// ParamByName
//------------------------------------------------------------------------------
function TABSQuery.ParamByName(const Value: string): TParam;
begin
  Result:=FParams.ParamByName(Value);
end;// ParamByName


//------------------------------------------------------------------------------
// Prepare
//------------------------------------------------------------------------------
procedure TABSQuery.Prepare;
begin
  SetDBFlag(dbfPrepared, True);
  SetPrepared(True);
end;// Prepare


//------------------------------------------------------------------------------
// UnPrepare
//------------------------------------------------------------------------------
procedure TABSQuery.UnPrepare;
begin
  SetPrepared(False);
  SetDBFlag(dbfPrepared, False);
end;// UnPrepare


//------------------------------------------------------------------------------
// PrepareSQL
//------------------------------------------------------------------------------
procedure TABSQuery.PrepareSQL(Value: PChar);
begin
  GetStatementHandle(Value);
end;// PrepareSQL


//------------------------------------------------------------------------------
// SetPrepared
//------------------------------------------------------------------------------
procedure TABSQuery.SetPrepared(Value: Boolean);
begin
  if FHandle <> nil then
   if (not Value) then
     begin
       FHandle := nil;
       FExternalHandle := nil;
     end
   else
    raise EABSException.Create(30141, ErorrGDataSetOpen);

  if Value <> Prepared then
  begin
   if Value then
    begin
      FRowsAffected := -1;
      FCheckRowsAffected := True;
      if Length(SQL.Text) > 1 then
        PrepareSQL(PChar(SQL.Text))
      else
        raise EABSException.Create(30142, ErorrGEmptySQLStatement);
    end
   else
    begin
      if FCheckRowsAffected then
        FRowsAffected := RowsAffected;
      FreeStatement;
    end;
    FPrepared := Value;
  end;
end;// SetPrepared


//------------------------------------------------------------------------------
// SetPrepare
//------------------------------------------------------------------------------
procedure TABSQuery.SetPrepare(Value: Boolean);
  begin
  if Value then
   Prepare
  else
   UnPrepare;
end;// SetPrepare


//------------------------------------------------------------------------------
// DefineProperties
//------------------------------------------------------------------------------
procedure TABSQuery.DefineProperties(Filer: TFiler);

  function WriteData: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not FParams.IsEqual(TABSQuery(Filer.Ancestor).FParams) else
      Result := FParams.Count > 0;
  end;

begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadBinaryData, WriteBinaryData, SQLBinary <> nil);
  Filer.DefineProperty('ParamData', ReadParamData, WriteParamData, WriteData);
end;// DefineProperties


//------------------------------------------------------------------------------
// ReadBinaryData
//------------------------------------------------------------------------------
procedure TABSQuery.ReadBinaryData(Stream: TStream);
begin
  SQLBinary := PAnsiChar(StrAlloc(Stream.Size));
  Stream.ReadBuffer(SQLBinary^, Stream.Size);
end;// ReadBinaryData


//------------------------------------------------------------------------------
// WriteBinaryData
//------------------------------------------------------------------------------
procedure TABSQuery.WriteBinaryData(Stream: TStream);
begin
  Stream.WriteBuffer(SQLBinary^, StrBufSize(SQLBinary));
end;// WriteBinaryData


//------------------------------------------------------------------------------
// ReadParamData
//------------------------------------------------------------------------------
procedure TABSQuery.ReadParamData(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(FParams);
end;// ReadParamData


//------------------------------------------------------------------------------
// WriteParamData
//------------------------------------------------------------------------------
procedure TABSQuery.WriteParamData(Writer: TWriter);
begin
  Writer.WriteCollection(Params);
end;// WriteParamData


//------------------------------------------------------------------------------
// CreateHandle
//------------------------------------------------------------------------------
function TABSQuery.CreateHandle: TABSCursor;
var
  OldSilentMode: Boolean;
begin
  OldSilentMode := Database.SilentMode;
  Database.SilentMode := True;
  try
  if (FExternalHandle = nil) then
    Result := CreateCursor(True)
  else
    Result := FExternalHandle;
  finally
    Database.SilentMode := OldSilentMode;
  end;
end;// CreateHandle


//------------------------------------------------------------------------------
// Disconnect
//------------------------------------------------------------------------------
procedure TABSQuery.Disconnect;
begin
  Close;
  UnPrepare;
end;// Disconnect


//------------------------------------------------------------------------------
// SetDBFlag
//------------------------------------------------------------------------------
procedure TABSQuery.SetDBFlag(Flag: Integer; Value: Boolean);
begin
  if Value then
    inherited SetDBFlag(Flag,Value)
  else
    begin
      if ((DBFlags - [Flag]) = []) then
         SetPrepared(False);
      inherited SetDBFlag(Flag, Value);
    end;
end;// SetDBFlag


//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
constructor TABSQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSQL := TStringList.Create;
  TStringList(SQL).OnChange := QueryChanged;
  FParams := TParams.Create(Self);
  FDataLink := TABSQueryDataLink.Create(Self);
  RequestLive := False;
  ParamCheck := True;
  FRowsAffected := -1;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSQuery.Destroy;
begin
  Destroying;
  Disconnect;
  SQL.Free;
  FParams.Free;
  FDataLink.Free;
  StrDispose(SQLBinary);
  inherited Destroy;
end;// Destroy


//------------------------------------------------------------------------------
// ExecSQL
//------------------------------------------------------------------------------
procedure TABSQuery.ExecSQL;
begin
  CheckInActive;
  SetDBFlag(dbfExecSQL, True);
  try
    CreateCursor(False);
  finally
    SetDBFlag(dbfExecSQL, False);
  end;
end;// ExecSQL


//------------------------------------------------------------------------------
// GetDetailLinkFields
//------------------------------------------------------------------------------
procedure TABSQuery.GetDetailLinkFields(MasterFields, DetailFields: TList);


  function AddFieldToList(
                          const FieldName:  string;
                          DataSet:          TDataSet;
                          List:             TList
                         ): Boolean;
  var
    Field: TField;
  begin
    Field := DataSet.FindField(FieldName);
    if (Field <> nil) then
      List.Add(Field);
    Result := (Field <> nil);
  end; // AddFieldToList


var
  i: Integer;
begin
  MasterFields.Clear;
  DetailFields.Clear;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    for i := 0 to Params.Count - 1 do
      if AddFieldToList(Params[i].Name, DataSource.DataSet, MasterFields) then
        AddFieldToList(Params[i].Name, Self, DetailFields);
end;// GetDetailLinkFields


////////////////////////////////////////////////////////////////////////////////
//
//  TABSDatabase
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// creates databases with specified directory
//------------------------------------------------------------------------------
constructor TABSDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if (FSession=nil) then
    begin
      if (AOwner is TABSSession) then
        FSession:=TABSSession(AOwner)
      else
        FSession:=ABSDefaultSession;
    end;
  SessionName:=FSession.SessionName;
  FSession.AddDatabase(Self);
  FDataSets:=TList.Create;
  FKeepConnection:=True;
{$IFNDEF DEBUG_DESIGN_TIME}
  if (not IsDesignMode)  then
   if (Aowner <> nil) then
    if (csDesigning in AOwner.ComponentState) then
{$ENDIF}
     IsDesignMode := true;
  FHandle := nil; // no manager
  FExclusive := False;

  FPageSize := DefaultPageSize;
  FPageCountInExtent := DefaultExtentPageCount;
  FCryptoAlgorithm := DefaultCryptoAgorithm;
  FPassword := '';
  FNoRequestAutoRepair := False;
  FMultiUser := False;
  FMaxConnections := DefaultMaxSessionCount;
  FDisableTempFiles := False;
end;//Create


//------------------------------------------------------------------------------
// destructor
//------------------------------------------------------------------------------
destructor TABSDatabase.Destroy;
begin
  Destroying;
  Close;
  FDataSets.Free;
  if (Sessions <> nil) then
   if (FSession <> nil) then
     FSession.RemoveDatabase(Self);
  inherited Destroy;
end;//Destroy


//------------------------------------------------------------------------------
// connected := true
//------------------------------------------------------------------------------
procedure TABSDatabase.Open;
var
  bCatchException: Boolean;
  DoRepair: Boolean;
  OldSilentMode: Boolean;
  Log: string;

begin
  if (FHandle=nil) then
   begin

    bCatchException := False;
{$IFDEF D5H}
     // fix: to enable open forms with incorrect properties
     if (csDesigning in ComponentState)
       and (not (csFreeNotification in ComponentState)) then
      bCatchException := True;
{$ENDIF}
    try

     CheckDatabaseName;
     CheckSessionName(True);

     if not (HandleShared and OpenFromExistingDB) then
       begin

         FSession.LockSession;
         try
           try

             if ((not Temporary) and (not wideFileExists(UTF8Decode(FDatabaseFileName)))) then //F0X
               DatabaseErrorFmt(ErrorADatabaseFileNotExist, [FDatabaseFileName], Self);

             // Get Password Loop
             repeat
               try

                 CreateHandle;
                 if (FHandle = nil) then
                  DatabaseError(ErrorADatabaseOpenError, Self);

                 try

                   FHandle.Connected := True;

                   if (FHandle.RepairNeeded and (not FSilentMode) and (not IsDesignMode)) then
                     begin
                       if (TABSDiskPageManager(TABSLocalSession(FHandle).DatabaseData.PageManager).DBHeader.Version < 2.99) then
                         DoOnNeedConvert(DoRepair)
                       else
                         DoOnNeedRepair(DoRepair);
                       if (DoRepair) then
                         begin
                          FHandle.Connected := False;
                          DestroyHandle;
                          OldSilentMode := FNoRequestAutoRepair;
                          try
                            FNoRequestAutoRepair := True;
                            try
                              Log := RepairDatabase;
                              {$IFNDEF NO_DIALOGS}
                              if (Log <> '') then
                                MessageDlg(Log, mtWarning, [mbOK], 0);
                              {$ENDIF}
                            except
                              raise EABSException.Create(20238, ErrorAConvertDatabase);
                            end;
                          finally
                            FNoRequestAutoRepair := OldSilentMode;
                          end;
                          CreateHandle;
                          FHandle.Connected := True;
                         end;
                     end;
                 except
                   DestroyHandle;
                   raise;
                 end;
                 Break;
               except
                 on e: EABSException do
                  begin
                    // if exception = wrong password
                    if (e.NativeError = 30445) then
                      begin
                        if not GetPassword then
                          raise;
                      end
                    else
                      raise;
                  end;
                 else
                   raise
               end
             until False;

             // auto-detect read-only
             if not (csDesigning in ComponentState) then
               FReadOnly := FHandle.ReadOnly;

{$IFDEF LOCAL_VERSION}
              FCryptoAlgorithm := TABSLocalSession(FHandle).Password.CryptoAlgorithm;
              FPageSize := TABSLocalSession(FHandle).PageSize;
              FPageCountInExtent := TABSLocalSession(FHandle).PageCountInExtent;
              FMaxConnections := TABSLocalSession(FHandle).MaxSessionCount;
{$ENDIF}
             // send notification
             Session.DBNotification(dbOpen,Self);
           except
             raise;
           end;
         finally
           FSession.UnlockSession;
         end;
       end
      else
        FAcquiredHandle:=False;
    except
      on E: Exception do
        if (not bCatchException) then
          raise
        else
          {$IFNDEF NO_DIALOGS}
          MessageDlg(E.Message, mtError, [mbOK],0)
          {$ENDIF}
          ;
    end;
   end;
end;// Open


//------------------------------------------------------------------------------
// connected := false
//------------------------------------------------------------------------------
procedure TABSDatabase.Close;
begin
  if (FHandle <> nil) then
    begin
      Session.DBNotification(dbClose,Self);
      CloseDataSets;
      if (not FAcquiredHandle) then
        begin
         if (FHandle <> nil) then
           DestroyHandle;
        end
      else
        FAcquiredHandle:=False;
      FHandle:=nil;
      FRefCount:=0;
    end;
end;// Close


//------------------------------------------------------------------------------
// create database
//------------------------------------------------------------------------------
procedure TABSDatabase.CreateDatabase;
begin
  CheckDatabaseName;
  CheckSessionName(True);
  CheckConnected;

  FDatabaseFileName:=UTF8Decode(FDatabaseFileName);//F0X FIX

  FSession.LockSession;
  try
    CreateHandle;
    if (FHandle = nil) then
      DatabaseError(ErrorADatabaseCreate, Self);
    FHandle.CreateDatabase;
    DestroyHandle;
  finally
   FSession.UnlockSession;
  end;

end;// CreateDatabase


//------------------------------------------------------------------------------
// delete database
//------------------------------------------------------------------------------
procedure TABSDatabase.DeleteDatabase;
begin
  CheckDatabaseName;
  CheckSessionName(True);
  CheckConnected;

  DeleteFile(PChar(FDatabaseFileName));
end;// DeleteDatabase


//------------------------------------------------------------------------------
// rename database
//------------------------------------------------------------------------------
procedure TABSDatabase.RenameDatabase(NewDatabaseFileName: string);
begin
  CheckDatabaseName;
  CheckSessionName(True);
  CheckConnected;

  if (RenameFile(FDatabaseFileName, NewDatabaseFileName)) then
    FDatabaseFileName := NewDatabaseFileName;
end;// RenameDatabase


//------------------------------------------------------------------------------
// compact database
//------------------------------------------------------------------------------
function TABSDatabase.CompactDatabase(NewDatabaseFileName: string): Boolean;
var Log: string;
begin
  CheckDatabaseName;
  CheckSessionName(True);
  CheckInactive;

  // if db is encrypted - request password if necessary
  Open;
  Close;

  try
    Result := InternalCopyDatabase(NewDatabaseFileName, Log, False,
                         Password, CryptoAlgorithm, PageSize, PageCountInExtent,
                         MaxConnections,
                         InternalBeforeCompact, InternalOnCompactProgress, InternalAfterCompact);
  except
    DeleteFile(PChar(NewDatabaseFileName));
    raise;
  end;

  if (not Result) then
   begin
    DeleteFile(PChar(NewDatabaseFileName));
    raise EABSException.Create(30456, ErrorGOperationFailed, ['CompactDatabase', Log]);
   end;
end;//CompactDatabase


//------------------------------------------------------------------------------
// compact database
//------------------------------------------------------------------------------
function TABSDatabase.CompactDatabase: Boolean;
var FN: string;
begin
  FN := DatabaseFileName + '.tmp';
  Result := CompactDatabase(FN);
  if Result then
    begin
  DeleteDatabase;
  RenameFile(FN, DatabaseFileName);
    end;
end;//CompactDatabase


//------------------------------------------------------------------------------
// truncate free pages from database
//------------------------------------------------------------------------------
procedure TABSDatabase.TruncateDatabase;
var
  OldExclusive: Boolean;
begin
{$IFDEF LOCAL_VERSION}
  CheckDatabaseName;
  CheckSessionName(True);
  CheckConnected;

  OldExclusive := Exclusive;
  Open;
  try
    TABSLocalSession(FHandle).TruncateDatabase;
  finally
    Close;
    Exclusive := OldExclusive;
  end;

{$ENDIF}
end;//TruncateDatabase


//------------------------------------------------------------------------------
// RepairDatabase
//------------------------------------------------------------------------------
function TABSDatabase.RepairDatabase: string;
var FN: string;
    RepairOk: Boolean;
begin
  Result := '';
  FN := DatabaseFileName + '.tmp';

  try
    RepairOk := RepairDatabase(FN,Result);
  except
    DeleteFile(PChar(FN));
    raise;
  end;

  if RepairOk then
    begin
     DeleteDatabase;
     RenameFile(FN, DatabaseFileName);
    end
  else
    begin
      if (Result = '') then
        Result := ErrorAUnknownError;
      DeleteFile(PChar(FN));
    end;
end;//RepairDatabase


//------------------------------------------------------------------------------
// RepairDatabase
//------------------------------------------------------------------------------
function TABSDatabase.RepairDatabase(NewDatabaseFileName: string;var Log: string): Boolean;
begin
  CheckDatabaseName;
  CheckSessionName(True);
  CheckConnected;

  // request password if DB is encrypted
  Open;
  Close;

  Result := InternalCopyDatabase(NewDatabaseFileName, Log, True,
                                 Password, CryptoAlgorithm,
                                 PageSize, PageCountInExtent,
                                 MaxConnections,
                                 InternalBeforeRepair, InternalOnRepairProgress, InternalAfterRepair);
end;//RepairDatabase


//------------------------------------------------------------------------------
// Change Database Settings
//------------------------------------------------------------------------------
function TABSDatabase.ChangeDatabaseSettings(
                  var Log: string;
                  IgnoreErrors: Boolean;
                  NewPassword: string;
                  NewCryptoAlgorithm: TABSCryptoAlgorithm = DefaultCryptoAgorithm;
                  NewPageSize: Integer = DefaultPageSize;
                  NewPageCountInExtent: Integer = DefaultExtentPageCount;
                  NewMaxConnections: Integer = DefaultMaxSessionCount
                                            ): Boolean;
var FN: string;
begin
  CheckDatabaseName;
  CheckSessionName(True);
  CheckConnected;

  // request password if DB is encrypted
  Open;
  Close;

  if (NewMaxConnections <= 0) then
    raise EABSException.Create(20274,ErrorAInvalidMaxConnectionsValue);

  FN := DatabaseFileName + '.tmp';

  try
  Result := InternalCopyDatabase(FN, Log, IgnoreErrors,
                                 NewPassword, NewCryptoAlgorithm,
                                 NewPageSize, NewPageCountInExtent,
                                 NewMaxConnections,
                                   InternalBeforeChangeDatabaseSettings,
                                   InternalOnChangeDatabaseSettingsProgress,
                                   InternalAfterChangeDatabaseSettings);
  except
    DeleteFile(PChar(FN));
    raise;
  end;

  if Result then
    begin
      DeleteDatabase;
      RenameFile(FN, DatabaseFileName);
      Password := NewPassword;
      CryptoAlgorithm := NewCryptoAlgorithm;
    end
  else
    DeleteFile(PChar(FN));
end;//ChangeDatabaseSettings


//------------------------------------------------------------------------------
// ChangePassword
//------------------------------------------------------------------------------
function TABSDatabase.ChangePassword(NewPassword: string): string;
begin
  Result := ChangePassword(NewPassword, CryptoAlgorithm);
end;//ChangePassword


//------------------------------------------------------------------------------
// change password and CryptoAggorithm
//------------------------------------------------------------------------------
function TABSDatabase.ChangePassword(NewPassword: string; NewCryptoAlgorithm: TABSCryptoAlgorithm): string;
var FN: string;
  Ok: Boolean;
begin
  Result := '';
  FN := DatabaseFileName + '.tmp';

  try
    Ok := InternalCopyDatabase(FN, Result, False,
                       NewPassword, NewCryptoAlgorithm,
                       PageSize, PageCountInExtent, MaxConnections,
                       InternalBeforeChangePassword,
                       InternalOnChangePasswordProgress,
                       InternalAfterChangePassword);
  except
    DeleteFile(PChar(FN));
    raise;
  end;

  if (Ok) then
    begin
  DeleteDatabase;
  RenameFile(FN, DatabaseFileName);
      Password := NewPassword;
      CryptoAlgorithm := NewCryptoAlgorithm;
    end
  else
    DeleteFile(PChar(FN));
end;//ChangePassword


//------------------------------------------------------------------------------
// makes Exe database from abs file
//------------------------------------------------------------------------------
procedure TABSDatabase.MakeExecutableDatabase(const ExeStubFileName, ExeDbFileName: string);
var
  DBStream, ExeStream, ExeDBStream: TFileStream;
begin
   DBStream := TFileStream.Create(DatabaseFileName, fmOpenRead or fmShareDenyWrite);
  try
   ExeStream := TFileStream.Create(ExeStubFileName, fmOpenRead or fmShareDenyNone);
   try
     ExeDBStream := TFileStream.Create(ExeDbFileName, fmCreate);
     try
       ExeDBStream.CopyFrom(ExeStream, ExeStream.Size);
       ExeDBStream.CopyFrom(DBStream, DBStream.Size);
     finally
       ExeDBStream.Free;
     end;
   finally
     ExeStream.Free;
   end;
  finally
     DBStream.Free;
  end;
end;// MakeExecutableDatabase


//------------------------------------------------------------------------------
// return Count of connections to Database File or -1 if it's openned in Exclusive
//------------------------------------------------------------------------------
function TABSDatabase.GetDBFileConnectionsCount: Integer;
begin
{$IFDEF LOCAL_VERSION}
  CheckDatabaseName;
  CheckSessionName(True);
  CheckActive;
  Result := TABSLocalSession(FHandle).GetDBFileConnectionsCount;
{$ENDIF}
end;//GetDBFileConnectionsCount


//------------------------------------------------------------------------------
// flush all changes that have been written to the database
//------------------------------------------------------------------------------
procedure TABSDatabase.FlushBuffers;
begin
  CheckDatabaseName;
  CheckSessionName(True);
  CheckActive;
  FHandle.FlushBuffers;
end;// FlushBuffers


//------------------------------------------------------------------------------
// close all datasets
//------------------------------------------------------------------------------
procedure TABSDatabase.CloseDataSets;
var
  QueryFound: Boolean;
  i: integer;
begin
  QueryFound := True;
  // close queries first to avoid double destroying of its cursor
  while (QueryFound) do
   begin
     QueryFound := False;
     for i := 0 to DataSetCount-1 do
       if (DataSets[i] is TABSQuery) then
         begin
          TABSQuery(DataSets[i]).Disconnect;
          QueryFound := True;
          break;
         end;
   end;
  while DataSetCount <> 0 do
   TABSDataset(DataSets[DataSetCount-1]).Disconnect;
end;// CloseDataSets


//------------------------------------------------------------------------------
// get list of tables in database file
//------------------------------------------------------------------------------
procedure TABSDatabase.GetTablesList(List: TStrings);
var
  OldConnected: Boolean;
begin
  try
    OldConnected := Connected;
    if (not OldConnected) then
     Connected := True;
    if (Assigned(FHandle)) then
     FHandle.GetTablesList(List);
    if (not OldConnected) then
     Connected := False;
  except
  end;
end;// GetTablesList


//------------------------------------------------------------------------------
// determine if table exists
//------------------------------------------------------------------------------
function TABSDatabase.TableExists(TableName: string) : Boolean;
begin
  Result := False;
  if (not Connected) then
   Connected := True;
  if (Assigned(FHandle)) then
   Result := FHandle.TableExists(TableName);
end;// TableExists


//------------------------------------------------------------------------------
// StartTransaction
//------------------------------------------------------------------------------
procedure TABSDatabase.StartTransaction;
begin
  CheckActive;
  if (InTransaction) then
    DatabaseError(ErrorADatabaseAlreadyInTransaction);
  FHandle.StartTransaction;
end;// StartTransaction


//------------------------------------------------------------------------------
// Commit
//------------------------------------------------------------------------------
procedure TABSDatabase.Commit(DoFlushBuffers: Boolean=True);
begin
  CheckActive;
  FHandle.Commit(DoFlushBuffers);
end;// Commit


//------------------------------------------------------------------------------
// Rollback
//------------------------------------------------------------------------------
procedure TABSDatabase.Rollback;
begin
  CheckActive;
  FHandle.Rollback;
end;// Rollback


//------------------------------------------------------------------------------
// connect / disconnect
//------------------------------------------------------------------------------
procedure TABSDatabase.SetConnected(value: boolean);
begin
  if (csReading in ComponentState) then
    FStreamedConnected:=Value
  else
   begin
    if Value = GetConnected then
     Exit;
    if Value then
     Open
    else
     Close;
   end;
end;//SetConnected


//------------------------------------------------------------------------------
// set specified database name
//------------------------------------------------------------------------------
procedure TABSDatabase.SetDatabaseName(Value: string);
begin
  if csReading in ComponentState then
    FDatabaseName := Value
  else
  if FDatabaseName <> Value then
   begin
    CheckInactive;
    ValidateName(Value);
    FDatabaseName := Value;
   end;
end;//SetDatabaseName


//------------------------------------------------------------------------------
// sets handle
//------------------------------------------------------------------------------
procedure TABSDatabase.SetHandle(Value: TABSBaseSession);
var
  DBSession: TABSSessionComponentManager;
begin
   if Connected then
      Close;
   if (Value <> nil) then
     begin
      DBSession := Value.SessionComponentManager;
      CheckDatabaseName;
      CheckSessionName(True);
      // database handle owned by another session
      if (FSession.FHandle <> DBSession) then
        DatabaseError(ErrorADatabaseHandleSet, Self);
      FHandle:=Value;
      Session.DBNotification(dbOpen,Self);
      FAcquiredHandle:=True;
     end;
end;// SetHandle


//------------------------------------------------------------------------------
// set specified file name
//------------------------------------------------------------------------------
procedure TABSDatabase.SetDatabaseFileName(Value: string);
begin
  if csReading in ComponentState then
    FDatabaseFileName := Value
  else
  if FDatabaseFileName <> Value then
   begin
//    CheckInactive;
    Connected := False;
    FDatabaseFileName := Value;
   end;
end;// SetDatabaseFileName


//------------------------------------------------------------------------------
// is database file exists
//------------------------------------------------------------------------------
function TABSDatabase.GetExists: boolean;
begin
  Result := FileExists(FDatabaseFileName);
end;// GetExists


//------------------------------------------------------------------------------
// get database manager
//------------------------------------------------------------------------------
procedure TABSDatabase.CreateHandle;
begin
 {$IFDEF LOCAL_VERSION}
  FHandle := TABSLocalSession.Create;
  FHandle.DatabaseName := FDatabaseName;
  FHandle.DatabaseFileName := FDatabaseFileName;
  TABSLocalSession(FHandle).Password.Password := FPassword;
  TABSLocalSession(FHandle).Password.CryptoAlgorithm := FCryptoAlgorithm;
  TABSLocalSession(FHandle).PageSize := FPageSize;
  TABSLocalSession(FHandle).PageCountInExtent := FPageCountInExtent;
  FHandle.MaxSessionCount := FMaxConnections;
  FHandle.ReadOnly := FReadOnly;
  FHandle.Exclusive := FExclusive;
  FHandle.MultiUser := FMultiUser;
  FAcquiredHandle := False;
  // 5.12 readonly in mltiuser mode within same application bugfix
  if MultiUser then
    FHandle.SessionName := SessionName;
 {$ENDIF}
end;// CreateHandle


//------------------------------------------------------------------------------
// release database manager
//------------------------------------------------------------------------------
procedure TABSDatabase.DestroyHandle;
begin
 if (Assigned(FHandle)) then
    FHandle.Connected := False;
 FHandle.Free;
 FHandle := nil;
end;// DestroyHandle


//------------------------------------------------------------------------------
// get password
//------------------------------------------------------------------------------
function TABSDatabase.GetPassword: Boolean;
begin
  if Assigned(FOnPassword) then
    begin
      Result:=False;
      FOnPassword(Self,Result);
    end
  else
    if (not SilentMode) then
      {$IFNDEF NO_DIALOGS}
      Result := PasswordDialog(Self, '')
      {$ENDIF}
    else
      Result := False;
end;// GetPassword


//------------------------------------------------------------------------------
// GetInTransaction
//------------------------------------------------------------------------------
function TABSDatabase.GetInTransaction: Boolean;
begin
  Result := (FHandle <> nil);
  if (Result) then
    Result := FHandle.InTransaction;
end;// GetInTransaction


//------------------------------------------------------------------------------
// return current version
//------------------------------------------------------------------------------
function TABSDatabase.GetCurrentVersion: string;
var c : AnsiChar;
begin
 c := AnsiChar({$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif});
 {$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif} := '.';
 Result := FloatToStrF(ABSVersion,ffFixed,3,2) + ' ' + ABSVersionText;
 {$ifndef D17H}DecimalSeparator{$else}FormatSettings.DecimalSeparator{$endif} := Char(c);
end; // GetCurrentVersion


//------------------------------------------------------------------------------
// last write to DB file was interrupted
//------------------------------------------------------------------------------
procedure TABSDatabase.DoOnNeedRepair(var DoRepair: Boolean);
begin
  if (not FNoRequestAutoRepair) then
    if Assigned(FOnNeedRepair) then
      FOnNeedRepair(Self, DoRepair)
    else
      {$IFNDEF NO_DIALOGS}
      DoRepair := (MessageDlg(SOnNeedRepair, mtConfirmation,[mbYes,mbNo],0) = mrYes)
      {$ELSE}
      DoRepair := False
      {$ENDIF}
  else
    DoRepair := False;
end;// DoOnNeedRepair


//------------------------------------------------------------------------------
// DB need convertation to the new format
//------------------------------------------------------------------------------
procedure TABSDatabase.DoOnNeedConvert(var DoRepair: Boolean);
begin
  if (not FNoRequestAutoRepair) then
    begin
      {$IFNDEF NO_DIALOGS}
      MessageDlg(SOnNeedConvert, mtInformation,[mbOK],0);
      {$ENDIF}
      DoRepair := True;
    end
  else
    DoRepair := False;
end;// DoOnNeedConvert


//------------------------------------------------------------------------------
// InternalCopyDatabase
//------------------------------------------------------------------------------
function TABSDatabase.InternalCopyDatabase(
                NewDatabaseFileName: string;
                var Log: string;
                IgnoreErrors: Boolean = False;
                NewPassword: string = '';
                NewCryptoAlgorithm: TABSCryptoAlgorithm = DefaultCryptoAgorithm;
                NewPageSize: Integer = DefaultPageSize;
                NewPageCountInExtent: Integer = DefaultExtentPageCount;
                NewMaxConnections: Integer = DefaultMaxSessionCount;
                BeforeEvent: TNotifyEvent = nil;
                ProgressEvent: TABSProgressEvent = nil;
                AfterEvent: TNotifyEvent = nil
              ): Boolean;
var
  NewDb: TABSDatabase;
  S: string;
  TablesList: TStringList;
  i: Integer;
  T: TABSTable;
  minp, maxp: Integer;
  Continue: Boolean;
  OldExclusive: Boolean;
  OldSilentMode: Boolean;
  FileDrive: string;
  Size1, Size2, Size3, DriveFreeSpace: int64;
  fs: TFileStream;
begin
  CheckDatabaseName;
  CheckSessionName(True);
  CheckConnected;
  Result := False;
  OldExclusive := Exclusive;
  OldSilentMode := FSilentMode;
  Log := '';

  if Assigned(BeforeEvent) then BeforeEvent(self);

  FileDrive := ExtractFileDrive(NewDatabaseFileName);
  FileDrive := FileDrive + '\';
  GetDiskFreeSpaceEx(PChar(FileDrive), Size1, Size2, @Size3);
  DriveFreeSpace := Size1;
  
  fs := TFileStream.Create(FDatabaseFileName, fmOpenRead or fmShareDenyNone);
  try
    if (fs.size > DriveFreeSpace) then
      raise EABSException.Create(20303, ErrorANotEnoughFreeSpace);   
  finally
    fs.free;
  end;
  
  NewDb := TABSDatabase.Create(nil);
  try
    NewDb.DatabaseFileName := NewDatabaseFileName;
    NewDb.DatabaseName := GetTemporaryName('TempDatabase');
    NewDb.SessionName := SessionName;
    NewDb.Password := NewPassword;
    NewDb.CryptoAlgorithm := NewCryptoAlgorithm;
    NewDb.PageSize := NewPageSize;
    NewDb.PageCountInExtent := NewPageCountInExtent;
    NewDb.MaxConnections := NewMaxConnections;
    try
      NewDb.CreateDatabase;
      NewDb.Open;
    except
      on e: Exception do
       begin
         s := Format(ErrorGCreateDataBaseError, [e.Message]);
         Log := Log + s;
         if (not IgnoreErrors) then
           raise EABSException.Create(30449, ErrorGCreateDataBaseError, [s]);
         Result := False;
         exit;
       end;
    end;
    Exclusive := True;
    FSilentMode := True;
    Open;
    FSilentMode := OldSilentMode;
    if Assigned(Handle) then
      Handle.SuppressDBHeaderErrors := True;
    Continue := True;
    TablesList := TStringList.Create;
    try
      GetTablesList(TablesList);
      for i:=0 to TablesList.Count-1 do
       begin
        t := TABSTable.Create(nil);
        t.TableName := TablesList[i];
        t.DatabaseName := DatabaseName;
        t.SessionName := SessionName;
        try
           try
             if (IgnoreErrors) then
               t.ValidateAndRepairMostUpdatedAndRecordPageIndex;
             t.Open;
             t.Close;
             minp := (i*100) div TablesList.Count;
             maxp := ((i+1)*100) div TablesList.Count;
             t.OnCopyProgress := ProgressEvent;
             t.BeforeCopy := EmptyEvent;
             t.AfterCopy := EmptyEvent;
             t.CopyTable(t.TableName, Log, Continue, NewDb.DatabaseFileName,
                         NewDb.Password, IgnoreErrors, False, True, minp, maxp);

             if ( not Continue ) then
              begin
                //Log := Log + SAborted + #13#10;
                Result := False;
                Exit;
              end;

           except
            on e: Exception do
             begin
               s := Format(ErrorACopyTableProblem, [t.TableName, e.Message]);
               Log := Log + s;
               if (not IgnoreErrors) then
                 raise EABSException.Create(20199, ErrorACopyTableProblem, [t.TableName, e.Message]);
             end;
           end;
        finally
         t.Free;
        end;
       end;
    finally
      TablesList.Free;
      if Assigned(Handle) then
        Handle.SuppressDBHeaderErrors := False;
      Close;
    end;

    if (Assigned(ProgressEvent)) then
      ProgressEvent(Self, 100, Continue);

    NewDb.Close;
    // Truncate empty pages
    NewDb.TruncateDatabase;

    if (IgnoreErrors) then
      Result := True
    else
      Result := (Log = '');
  finally
    NewDb.Free;
    Exclusive := OldExclusive;
    FSilentMode := OldSilentMode;
    if Assigned(AfterEvent) then AfterEvent(self);
  end;

end;//InternalCopyDatabase


//------------------------------------------------------------------------------
// loaded
//------------------------------------------------------------------------------
procedure TABSDatabase.Loaded;
begin
  inherited Loaded;
  if (not StartDisconnected) then // 6.08
    if FStreamedConnected then
      Open
    else
      CheckSessionName(False)

end;// Loaded


//------------------------------------------------------------------------------
// sends notification
//------------------------------------------------------------------------------
procedure TABSDatabase.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation = opRemove) and (AComponent = FSession) and
     (FSession <> ABSDefaultSession) then
    begin
      Close;
      SessionName := '';
    end;
end;// Notification


//------------------------------------------------------------------------------
// keep connection
//------------------------------------------------------------------------------
procedure TABSDatabase.SetKeepConnection(Value: Boolean);
begin
  if FKeepConnection <> Value then
  begin
    FKeepConnection := Value;
    if not Value and (FRefCount = 0) then
     Close;
  end;
end;// SetKeepConnection


//------------------------------------------------------------------------------
// sets read-only mode
//------------------------------------------------------------------------------
procedure TABSDatabase.SetReadOnly(Value: Boolean);
begin
//  CheckInactive;
  FReadOnly := Value;
end;// SetReadOnly


//------------------------------------------------------------------------------
// set session name
//------------------------------------------------------------------------------
procedure TABSDatabase.SetSessionName(const Value: string);
begin
  if csReading in ComponentState then
    FSessionName := Value
  else
  begin
    CheckInactive;
    if FSessionName <> Value then
    begin
      FSessionName := Value;
      if not (csDestroying in ComponentState) then
        CheckSessionName(False);
    end;
  end;
end;// SetSessionName


//------------------------------------------------------------------------------
// checks session name
//------------------------------------------------------------------------------
procedure TABSDatabase.CheckSessionName(Required: Boolean);
var
  NewSession: TABSSession;
begin
  if Required then
    NewSession := Sessions.List[FSessionName]
  else
    NewSession := Sessions.FindSession(FSessionName);
  if (NewSession <> nil) and (NewSession <> FSession) then
  begin
    if (FSession <> nil) then FSession.RemoveDatabase(Self);
    FSession := NewSession;
    FSession.FreeNotification(Self);
    FSession.AddDatabase(Self);
    try
      ValidateName(FDatabaseName);
    except
      FDatabaseName := '';
      raise;
    end;
  end;
  if Required then FSession.Active := True;
end;// CheckSessionName


//------------------------------------------------------------------------------
// CheckConnected
//------------------------------------------------------------------------------
procedure TABSDatabase.CheckConnected;
begin
  if (Connected) then
    DatabaseError(ErrorADatabaseOpen, Self);
end;// CheckConnected


//------------------------------------------------------------------------------
// db connected?
//------------------------------------------------------------------------------
function TABSDatabase.GetConnected: Boolean;
begin
  Result := (FHandle <> nil);
end;// GetConnected


//------------------------------------------------------------------------------
// connected dataset
//------------------------------------------------------------------------------
function TABSDatabase.GetDataSet(Index: Integer): TABSDataSet;
begin
  Result := FDataSets[Index];
end;// GetDataSet


//------------------------------------------------------------------------------
// count of connected datasets
//------------------------------------------------------------------------------
function TABSDatabase.GetDataSetCount: Integer;
begin
  Result := FDataSets.Count;
end;// GetDataSetCount


//------------------------------------------------------------------------------
// opens from existing DB
//------------------------------------------------------------------------------
function TABSDatabase.OpenFromExistingDB: Boolean;
begin
  FHandle := FSession.FindDatabaseHandle(DatabaseName);
  Result := (FHandle <> nil);
  FAcquiredHandle := Result;
end;// OpenFromExistingDB


//------------------------------------------------------------------------------
// validates name
//------------------------------------------------------------------------------
procedure TABSDatabase.ValidateName(const Name: string);
var
  Database: TABSDatabase;
begin
  if (Name <> '') and (FSession <> nil) then
  begin
    FSession.LockSession;
    try
      Database := FSession.FindDatabase(Name);
      if ((Database <> nil) and (Database <> Self) and
            not (Database.HandleShared and HandleShared)) then
      begin
        if (not Database.Temporary or (Database.FRefCount <> 0)) then
         DatabaseErrorFmt(ErrorADuplicateDatabaseName, [Name], Self);
        Database.Free;
      end;
    finally
      FSession.UnlockSession;
    end;
  end;
end;// ValidateName


//------------------------------------------------------------------------------
// CheckActive
//------------------------------------------------------------------------------
procedure TABSDatabase.CheckActive;
begin
  if FHandle = nil then
    DatabaseError(ErrorADatabaseClosed, Self);
end;//


//------------------------------------------------------------------------------
// raises exception if not active
//------------------------------------------------------------------------------
procedure TABSDatabase.CheckInactive;
begin
  if FHandle <> nil then
    if (csDesigning in ComponentState) then
      Close
    else
      DatabaseError(ErrorADatabaseOpen, Self);
end;// CheckInactive


//------------------------------------------------------------------------------
// raises exception if database name is not valid
//------------------------------------------------------------------------------
procedure TABSDatabase.CheckDatabaseName;
begin
 if ((FDatabaseName = '') and (not Temporary)) then
    DatabaseError(ErrorADatabaseNameMissing, Self);
end;// CheckDatabaseName



//------------------------------------------------------------------------------
// empty
//------------------------------------------------------------------------------
procedure TABSDatabase.EmptyEvent(Sender: TObject);
begin
end;//EmptyEvent


//------------------------------------------------------------------------------
// Internal BeforeRepair Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalBeforeRepair(Sender: TObject);
begin
  if Assigned(BeforeRepair) then
    BeforeRepair(Sender)
  else
    if not SilentMode then
      begin
        {$IFNDEF NO_DIALOGS}
        frmWait:=TfrmWait.Create(nil);
        frmWait.pb.Position := 0;
        frmWait.Show(SRepairDialogMessage);
        frmWait.Visible := True;
        Application.ProcessMessages;
        {$ENDIF}
      end;
end;//InternalBeforeRepair


//------------------------------------------------------------------------------
// Internal OnRepairProgress Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalOnRepairProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
begin
  if Assigned(OnRepairProgress) then
    OnRepairProgress(Sender, PercentDone, Continue)
  else
    if not SilentMode then
     begin
      {$IFNDEF NO_DIALOGS}
      frmWait.Visible := true;
      frmWait.pb.Position := PercentDone;
      Application.ProcessMessages;
      Continue := not frmWait.Terminated;
      {$ELSE}
      Continue := True;
      {$ENDIF}
     end;
end;//InternalOnRepairProgress


//------------------------------------------------------------------------------
// Internal AfterRepair Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalAfterRepair(Sender: TObject);
begin
  if Assigned(AfterRepair) then
    AfterRepair(Sender)
  else
    if not SilentMode then
      begin
        {$IFNDEF NO_DIALOGS}
        if (frmWait <> nil) then
          begin
            frmWait.Close;
            frmWait := nil;
          end;
        {$ENDIF}
      end;
end;//InternalAfterRepair


//------------------------------------------------------------------------------
// Internal BeforeCompact Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalBeforeCompact(Sender: TObject);
begin
  if Assigned(BeforeCompact) then
    BeforeCompact(Sender)
  else
    if not SilentMode then
      begin
        {$IFNDEF NO_DIALOGS}
        frmWait:=TfrmWait.Create(nil);
        frmWait.pb.Position := 0;
        frmWait.Show(SCompactingDialogMessage);
        {$ENDIF}
      end;
end;//InternalBeforeCompact


//------------------------------------------------------------------------------
// Internal OnCompactProgress Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalOnCompactProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
begin
  if Assigned(OnCompactProgress) then
    OnCompactProgress(Sender, PercentDone, Continue)
  else
    if not SilentMode then
     begin
      {$IFNDEF NO_DIALOGS}
      frmWait.pb.Position := PercentDone;
      Application.ProcessMessages;
      Continue := not frmWait.Terminated;
      {$ELSE}
      Continue := True;
      {$ENDIF}
     end;
end;//InternalOnCompactProgress


//------------------------------------------------------------------------------
// Internal AfterCompact Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalAfterCompact(Sender: TObject);
begin
  if Assigned(AfterCompact) then
    AfterCompact(Sender)
  else
    if not SilentMode then
      begin
        {$IFNDEF NO_DIALOGS}
        if (frmWait <> nil) then
          begin
            frmWait.Close;
            frmWait := nil;
          end;
        {$ENDIF}
      end;
end;//InternalAfterCompact


//------------------------------------------------------------------------------
// Internal BeforeChangePassword Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalBeforeChangePassword(Sender: TObject);
begin
  if Assigned(BeforeChangePassword) then
    BeforeChangePassword(Sender)
  else
    if not SilentMode then
      begin
        {$IFNDEF NO_DIALOGS}
        frmWait:=TfrmWait.Create(nil);
        frmWait.pb.Position := 0;
        frmWait.Show(SChangePasswordDialogMessage);
        {$ENDIF}
      end;
end;//InternalBeforeChangePassword


//------------------------------------------------------------------------------
// Internal OnChangePasswordProgress Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalOnChangePasswordProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
begin
  if Assigned(OnChangePasswordProgress) then
    OnChangePasswordProgress(Sender, PercentDone, Continue)
  else
    if not SilentMode then
     begin
      {$IFNDEF NO_DIALOGS}
      frmWait.pb.Position := PercentDone;
      Application.ProcessMessages;
      Continue := not frmWait.Terminated;
      {$ELSE}
      Continue := True;
      {$ENDIF}
     end;
end;//InternalOnChangePasswordProgress


//------------------------------------------------------------------------------
// Internal AfterChangePassword Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalAfterChangePassword(Sender: TObject);
begin
  if Assigned(AfterChangePassword) then
    AfterChangePassword(Sender)
  else
    if not SilentMode then
      begin
        {$IFNDEF NO_DIALOGS}
        if (frmWait <> nil) then
          begin
            frmWait.Close;
            frmWait := nil;
          end;
        {$ENDIF}
      end;
end;//InternalAfterChangePassword


//------------------------------------------------------------------------------
// Internal BeforeChangeDatabaseSettings Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalBeforeChangeDatabaseSettings(Sender: TObject);
begin
  if Assigned(BeforeChangeDatabaseSettings) then
    BeforeChangeDatabaseSettings(Sender)
  else
    if not SilentMode then
      begin
        {$IFNDEF NO_DIALOGS}
        frmWait:=TfrmWait.Create(nil);
        frmWait.pb.Position := 0;
        frmWait.Show(SChangeDatabaseSettingsDialogMessage);
        {$ENDIF}
      end;
end;//InternalBeforeChangeDatabaseSettings


//------------------------------------------------------------------------------
// Internal OnChangeDatabaseSettingsProgress Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalOnChangeDatabaseSettingsProgress(Sender: TObject; PercentDone: Integer; var Continue: Boolean);
begin
  if Assigned(OnChangeDatabaseSettingsProgress) then
    OnChangeDatabaseSettingsProgress(Sender, PercentDone, Continue)
  else
    if not SilentMode then
     begin
      {$IFNDEF NO_DIALOGS}
      frmWait.pb.Position := PercentDone;
      Application.ProcessMessages;
      Continue := not frmWait.Terminated;
      {$ELSE}
      Continue := True;
      {$ENDIF}
     end;
end;//InternalOnChangeDatabaseSettingsProgress


//------------------------------------------------------------------------------
// Internal AfterChangeDatabaseSettings Event
//------------------------------------------------------------------------------
procedure TABSDatabase.InternalAfterChangeDatabaseSettings(Sender: TObject);
begin
  if Assigned(AfterChangeDatabaseSettings) then
    AfterChangeDatabaseSettings(Sender)
  else
    if not SilentMode then
      begin
       {$IFNDEF NO_DIALOGS}
        if (frmWait <> nil) then
          begin
            frmWait.Close;
            frmWait := nil;
          end;
        {$ENDIF}
      end;
end;//InternalAfterChangeDatabaseSettings






////////////////////////////////////////////////////////////////////////////////
//
//  TABSAdvFieldDef
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// Assign
//------------------------------------------------------------------------------
procedure TABSAdvFieldDef.Assign(Source: TABSAdvFieldDef);
begin
  FName := Source.Name;
  FObjectID := Source.ObjectID;
  FDataType := Source.DataType;
  FRequired := Source.Required;
  FSize := Source.Size;

  //FDefaultValueType := Source.DefaultValueType;
  FDefaultValue.Assign(Source.DefaultValue);
  FMinValue.Assign(Source.FMinValue);
  FMaxValue.Assign(Source.MaxValue);

  // Blob data
  FBLOBCompressionAlgorithm := Source.BLOBCompressionAlgorithm;
  FBLOBCompressionMode := Source.BLOBCompressionMode;
  FBLOBBlockSize := Source.BLOBBlockSize;

  // Autoinc settings
  FAutoincIncrement := Source.FAutoincIncrement;
  FAutoincInitialValue := Source.FAutoincInitialValue;
  FAutoincMinValue  := Source.FAutoincMinValue;
  FAutoincMaxValue  := Source.FAutoincMaxValue;
  FAutoincCycled    := Source.FAutoincCycled;

end;


//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
constructor TABSAdvFieldDef.Create;
begin
  FName := '';
  FObjectID := INVALID_OBJECT_ID;
  FDataType := aftUnknown;
  FRequired := false;
  FSize := 0;

  FDefaultValue := TABSVariant.Create;
  FMinValue := TABSVariant.Create;
  FMaxValue := TABSVariant.Create;

  // Blob data
  FBLOBCompressionAlgorithm := caNone;
  FBLOBCompressionMode := 0;
  FBLOBBlockSize := DefaultBLOBBlockSize;

  // Autoinc settings
  FAutoincIncrement := 1;
  FAutoincInitialValue := 0;
  FAutoincMinValue  := 0;//Low(Int64);
  FAutoincMaxValue  := High(Int64);
  FAutoincCycled    := False;

end;//Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSAdvFieldDef.Destroy;
begin
  FDefaultValue.Free;
  FMinValue.Free;
  FMaxValue.Free;
  inherited;
end;//Destroy




////////////////////////////////////////////////////////////////////////////////
//
//  TABSAdvFieldDefs
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSAdvFieldDefs.Create;
begin
  FDefsList := TList.Create;
end;//Create


//------------------------------------------------------------------------------
// Assign
//------------------------------------------------------------------------------
procedure TABSAdvFieldDefs.Assign(Source: TABSAdvFieldDefs);
var i:  Integer;
begin
  Clear;
  for i := 0 to Source.Count - 1 do
    AddFieldDef.Assign(Source[i]);
end;


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSAdvFieldDefs.Destroy;
begin
  Clear;
  FDefsList.Free;
end;//Destroy



//------------------------------------------------------------------------------
// Count
//------------------------------------------------------------------------------
function TABSAdvFieldDefs.GetCount: Integer;
begin
  Result := FDefsList.Count;
end;//GetCount


//------------------------------------------------------------------------------
// GetDef
//------------------------------------------------------------------------------
function TABSAdvFieldDefs.GetDef(Index: Integer): TABSAdvFieldDef;
begin
  Result := TABSAdvFieldDef(FDefsList[Index]);
end;//GetDef


//------------------------------------------------------------------------------
// SetDef
//------------------------------------------------------------------------------
procedure TABSAdvFieldDefs.SetDef(Index: Integer; value: TABSAdvFieldDef);
begin
  if (FDefsList[Index] <> nil) then
    TABSAdvFieldDef(FDefsList[Index]).Free;
  FDefsList[Index] := Value;
end;//SetDef


//------------------------------------------------------------------------------
// AddFieldDef
//------------------------------------------------------------------------------
function TABSAdvFieldDefs.AddFieldDef: TABSAdvFieldDef;
begin
  Result := TABSAdvFieldDef.Create;
  FDefsList.Add(Result);
end;//AddFieldDef


//------------------------------------------------------------------------------
// Add
//------------------------------------------------------------------------------
procedure TABSAdvFieldDefs.Add(const Name: string; DataType: TABSAdvancedFieldType;
                   Size: Integer = 0; Required: Boolean = False;
                   BLOBCompressionAlgorithm: TCompressionAlgorithm = caNone;
                   BLOBCompressionMode: Byte = 0);
var TmpAdvFieldDef: TABSAdvFieldDef;
begin
  TmpAdvFieldDef := AddFieldDef;
  TmpAdvFieldDef.Name := Name;
  TmpAdvFieldDef.DataType := DataType;
  TmpAdvFieldDef.Size := Size;
  TmpAdvFieldDef.Required := Required;
  TmpAdvFieldDef.BLOBCompressionAlgorithm := BLOBCompressionAlgorithm;
  TmpAdvFieldDef.BLOBCompressionMode := BLOBCompressionMode;
end;//Add


//------------------------------------------------------------------------------
// DeleteFieldDef
//------------------------------------------------------------------------------
procedure TABSAdvFieldDefs.DeleteFieldDef(const FieldName: string);
var i: Integer;
    s1,s2: AnsiString;
begin
  for i:=0 to Count-1 do
  begin
   s1 := AnsiString(TABSAdvFieldDef(Items[i]).Name);
   s2 := AnsiString(FieldName);
   if (AnsiStrIComp(PAnsiChar(s1), PAnsiChar(s2)) = 0) then
    begin
      TABSAdvFieldDef(FDefsList[i]).Free;
      FDefsList.Delete(i);
      Exit;
    end;
  end;
  raise EABSException.Create(30349, ErrorGFieldWithNameNotFound, [FieldName]);
end;//DeleteFieldDef


//------------------------------------------------------------------------------
// Find
//------------------------------------------------------------------------------
function TABSAdvFieldDefs.Find(const Name: string): TABSAdvFieldDef;
var i: Integer;
begin
  Result := nil;
  for i:=0 to Count-1 do
   if (UpperCase(TABSAdvFieldDef(Items[i]).Name) = UpperCase(Name)) then
    begin
      Result := Items[i];
      break;
    end
end;//Find


//------------------------------------------------------------------------------
// Clear
//------------------------------------------------------------------------------
procedure TABSAdvFieldDefs.Clear;
var i: Integer;
begin
  for i:=0 to FDefsList.Count-1 do
    TABSAdvFieldDef(FDefsList[i]).Free;
  FDefsList.Clear;
end;//Clear


////////////////////////////////////////////////////////////////////////////////
//
//  TABSAdvIndexDef
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSAdvIndexDef.Create;
begin
  FName := '';
  FFields := '';
  FDescFields := '';
  FCaseInsFields := '';
  FOptions := [];
  FMaxIndexedSizes := '';
  FTemporary := False;
end;// Create


//------------------------------------------------------------------------------
// Assign
//------------------------------------------------------------------------------
procedure TABSAdvIndexDef.Assign(ASource: TABSAdvIndexDef);
begin
  FName := ASource.FName;
  FFields := ASource.Fields;
  FDescFields := ASource.DescFields;
  FCaseInsFields := ASource.CaseInsFields;
  FOptions := ASource.Options;
  FTemporary := ASource.Temporary;
  FMaxIndexedSizes := ASource.MaxIndexedSizes;
end;// Assign




////////////////////////////////////////////////////////////////////////////////
//
//  TABSAdvIndexDefs
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// GetCount
//------------------------------------------------------------------------------
function TABSAdvIndexDefs.GetCount: Integer;
begin
  Result := FDefsList.Count;
end;// GetCount


//------------------------------------------------------------------------------
// GetDef
//------------------------------------------------------------------------------
function TABSAdvIndexDefs.GetDef(Index: Integer): TABSAdvIndexDef;
begin
  Result := TABSAdvIndexDef(FDefsList[Index]);
end;// GetDef


//------------------------------------------------------------------------------
// SetDef
//------------------------------------------------------------------------------
procedure TABSAdvIndexDefs.SetDef(Index: Integer; value: TABSAdvIndexDef);
begin
  if (FDefsList[Index] <> nil) then
    TABSAdvIndexDef(FDefsList[Index]).Free;
  FDefsList[Index] := Value;
end;// SetDef


//------------------------------------------------------------------------------
// Assign
//------------------------------------------------------------------------------
procedure TABSAdvIndexDefs.Assign(Source: TABSAdvIndexDefs; SkipTemporaryIndexes: Boolean = False);
var i:  Integer;
begin
  Clear;
  for i := 0 to Source.Count - 1 do
    if (not SkipTemporaryIndexes) or
       (not Source[i].Temporary and (Pos('TEMPORARY',UpperCase(Source[i].Name)) = 0)) then
      AddIndexDef.Assign(Source[i]);
end;// Assign


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSAdvIndexDefs.Create(ADataSet: TDataSet);
begin
  FDefsList := TList.Create;
  FDataset := ADataset;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSAdvIndexDefs.Destroy;
begin
  Clear;
  FDefsList.Free;
end;// Destroy


//------------------------------------------------------------------------------
// AddIndexDef
//------------------------------------------------------------------------------
function TABSAdvIndexDefs.AddIndexDef: TABSAdvIndexDef;
begin
  Result := TABSAdvIndexDef.Create;
  FDefsList.Add(Result);
end;// AddIndexDef


//------------------------------------------------------------------------------
// Add
//------------------------------------------------------------------------------
procedure TABSAdvIndexDefs.Add(const Name, Fields: string; Options: TIndexOptions; Temporary: Boolean = false;
                   DescFields: string = '';
                   CaseInsFields: string = '';
                   MaxIndexedSizes: string = '');
var TmpAdvIndexDef: TABSAdvIndexDef;
begin
  TmpAdvIndexDef := AddIndexDef;
  TmpAdvIndexDef.Name := Name;
  TmpAdvIndexDef.Fields := Fields;
  TmpAdvIndexDef.DescFields := DescFields;
  TmpAdvIndexDef.CaseInsFields := CaseInsFields;
  TmpAdvIndexDef.MaxIndexedSizes := MaxIndexedSizes;
  TmpAdvIndexDef.Options := Options;
  TmpAdvIndexDef.Temporary := Temporary;
end;// Add


//------------------------------------------------------------------------------
// DeleteIndexDef
//------------------------------------------------------------------------------
procedure TABSAdvIndexDefs.DeleteIndexDef(const IndexName: string);
var i: Integer;
begin
  for i:=0 to Count-1 do
   if (AnsiStrIComp(PAnsiChar(TABSAdvIndexDef(Items[i]).Name), PAnsiChar(IndexName)) = 0) then
    begin
      TABSAdvIndexDef(FDefsList[i]).Free;
      FDefsList.Delete(i);
      Exit;
    end;
  raise EABSException.Create(20190, ErrorAIndexByNameNotFound, [IndexName]);
end;// DeleteIndexDef


//------------------------------------------------------------------------------
// Find
//------------------------------------------------------------------------------
function TABSAdvIndexDefs.Find(const Name: string): TABSAdvIndexDef;
var i: Integer;
begin
  Result := nil;
  for i:=0 to Count-1 do
   if (AnsiStrIComp(PAnsiChar(TABSAdvIndexDef(Items[i]).Name), PAnsiChar(Name)) = 0) then
    begin
      Result := Items[i];
      break;
    end
end;// Find


//------------------------------------------------------------------------------
// Clear
//------------------------------------------------------------------------------
procedure TABSAdvIndexDefs.Clear;
var i: Integer;
begin
  for i:=0 to FDefsList.Count-1 do
    TABSAdvIndexDef(FDefsList[i]).Free;
  FDefsList.Clear;
end;// Clear


//------------------------------------------------------------------------------
// Update
//------------------------------------------------------------------------------
procedure TABSAdvIndexDefs.Update;
begin
  if Assigned(FDataSet) then
    TABSDataset(FDataSet).UpdateIndexDefs;
end;// Update




////////////////////////////////////////////////////////////////////////////////
//
// TABSBLOBStream
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// sets new size of the stream
//------------------------------------------------------------------------------
procedure TABSBLOBStream.InternalSetSize(const NewSize: Int64);
begin
 if (FBlobStream <> nil) then
   begin
     FBLOBStream.Size := NewSize;
     if (FBLOBStream.Size = NewSize) then
      FBLOBStream.Modified := True;
   end;
end; // InternalSetSize


//------------------------------------------------------------------------------
// sets new size of the stream
//------------------------------------------------------------------------------
procedure TABSBLOBStream.SetSize(NewSize: Longint);
begin
 InternalSetSize(NewSize);
end; // SetSize


{$IFDEF D6H}
//------------------------------------------------------------------------------
// sets new size of the stream
//------------------------------------------------------------------------------
procedure TABSBLOBStream.SetSize(const NewSize: Int64);
begin
 InternalSetSize(NewSize);
end; // SetSize
{$ENDIF}


//------------------------------------------------------------------------------
// GetCompressedSize
//------------------------------------------------------------------------------
function TABSBLOBStream.GetCompressedSize: Int64;
begin
 if (FBlobStream = nil) then
   Result := 0
 else
   Result := TABSCompressedBLOBStream(TABSLocalBLOBStream(FBLOBStream).TemporaryStream).CompressedSize;
end;// GetCompressedSize


//------------------------------------------------------------------------------
// set size of compressed stream
//------------------------------------------------------------------------------
function TABSBLOBStream.Read(var Buffer; Count: Longint): Longint;
begin
 if (FBlobStream = nil) then
   Result := 0
 else
   Result := FBLOBStream.Read(Buffer,Count);
end; // Read


//------------------------------------------------------------------------------
// set size of compressed stream
//------------------------------------------------------------------------------
function TABSBLOBStream.Write(const Buffer; Count: Longint): Longint;
begin
 if (FBlobStream = nil) then
   Result := 0                                     
 else
   Result := FBLOBStream.Write(Buffer,Count);
 if (Result > 0) then
   FBLOBStream.Modified := True;
end; // Write


//------------------------------------------------------------------------------
// set size of compressed stream
//------------------------------------------------------------------------------
function TABSBLOBStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
 if (FBlobStream = nil) then
   Result := 0
 else
   Result := FBLOBStream.Seek(Offset,Origin);
end; // Seek


{$IFDEF D6H}
//------------------------------------------------------------------------------
// set size of compressed stream
//------------------------------------------------------------------------------
function TABSBLOBStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
 if (FBlobStream = nil) then
   Result := 0
 else
   Result := FBLOBStream.Seek(Offset,Origin);
end; // Seek
{$ENDIF}


//------------------------------------------------------------------------------
// set size of compressed stream
//------------------------------------------------------------------------------
constructor TABSBLOBStream.Create(Field: TBlobField; Mode: TBlobStreamMode);
begin
 if ((Mode <> bmRead) and (TABSDataset(Field.DataSet).ReadOnly)) then
  raise EABSException.Create(10106,ErrorLDatasetIsInReadOnlyMode);
 FBLOBStream := TABSDataset(Field.DataSet).InternalCreateBlobStream(
  Field.DataSet.FieldByName(Field.FieldName),Mode);
 if (FBlobStream <> nil) then
   begin
     BlockSize := FBLOBStream.BlockSize;
     TABSLocalBLOBStream(FBLOBStream).UserBLOBStream := Self;
     FField := Field;
     FDataSet := FField.DataSet as TABSDataSet;
     if (Mode = bmWrite) then
      Truncate;
   end;
end; // Create


//------------------------------------------------------------------------------
// set size of compressed stream
//------------------------------------------------------------------------------
destructor TABSBLOBStream.Destroy;
begin
 if (FBLOBStream <> nil) then
   begin
     Modified := FBLOBStream.Modified;
     TABSLocalBLOBStream(FBLOBStream).UserBLOBStream := nil;
     FDataset.CloseBlob(FField);
     if (Modified) then
      begin
       FField.Modified := True;
       try
         FDataSet.DataEvent(deFieldChange, {$ifdef D16H}NativeInt{$else}Longint{$endif}(FField));
       except
         {$IFDEF D6H}
         ApplicationHandleException(Self);
         {$ELSE}
         Application.HandleException(Self)
         {$ENDIF}
       end;
      end;
   end;
 inherited;
end; // Destroy


//------------------------------------------------------------------------------
// truncate
//------------------------------------------------------------------------------
procedure TABSBLOBStream.Truncate;
begin
 Size := Position;
end; // Truncate


////////////////////////////////////////////////////////////////////////////////
//
// Global functions
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// convert TFieldDefs to ABSFieldDefs
//------------------------------------------------------------------------------
procedure ConvertFieldDefsToABSFieldDefs(
                FieldDefs:      TFieldDefs;
                ABSFieldDefs:   TABSFieldDefs
                                        );
var i:        Integer;
    FieldDef: TABSFieldDef;
begin
 ABSFieldDefs.Clear;
 for i := 0 to FieldDefs.Count-1 do
  begin
   FieldDef := ABSFieldDefs.AddCreated;
   FieldDef.Name := FieldDefs[i].Name;
   FieldDef.SetFieldDefDataType(
      FieldTypeToABSAdvFieldType(FieldDefs[i].DataType),
      FieldDefs[i].Size
                               );
  end;
end; //



//------------------------------------------------------------------------------
// convert AdvFieldDefs to FieldDefs
//------------------------------------------------------------------------------
procedure ConvertAdvFieldDefsToFieldDefs(AdvFieldDefs: TABSAdvFieldDefs; FieldDefs: TFieldDefs);
var
  i: Integer;
  FieldDef: TFieldDef;
begin
  FieldDefs.Clear;
  for i:=0 to AdvFieldDefs.Count-1 do
   begin
    FieldDef := FieldDefs.AddFieldDef;
    FieldDef.Name := AdvFieldDefs[i].Name;
    FieldDef.DataType := ABSAdvFieldTypeToFieldType(AdvFieldDefs[i].DataType);
    FieldDef.Size := AdvFieldDefs[i].Size;
    //FieldDef.Precision := AdvFieldDefs[i].Precision;
    FieldDef.Required := AdvFieldDefs[i].Required;
    //FieldDef.FieldNo := i + 1;
   end;
end;

//------------------------------------------------------------------------------
// convert FieldDefs to AdvFieldDefs
//------------------------------------------------------------------------------
procedure ConvertFieldDefsToAdvFieldDefs(FieldDefs: TFieldDefs; AdvFieldDefs: TABSAdvFieldDefs);
var
  i: Integer;
  AdvFieldDef: TABSAdvFieldDef;
begin
  AdvFieldDefs.Clear;
  for i:=0 to FieldDefs.Count-1 do
   begin
    AdvFieldDef := AdvFieldDefs.AddFieldDef;
    AdvFieldDef.Name := FieldDefs[i].Name;
    AdvFieldDef.DataType := FieldTypeToABSAdvFieldType(FieldDefs[i].DataType);
    AdvFieldDef.Size := FieldDefs[i].Size;
    //AdvFieldDef.Precision := FieldDefs[i].Precision;
    AdvFieldDef.Required := FieldDefs[i].Required;
   end;
end;

//------------------------------------------------------------------------------
// convert AdvFieldDefs to ABSFieldDefs
//------------------------------------------------------------------------------
procedure ConvertAdvFieldDefsToABSFieldDefs(
                AdvFieldDefs:      TABSAdvFieldDefs;
                ABSFieldDefs:      TABSFieldDefs;
                IndexDefs:         TABSIndexDefs;
                ABSConstraintDefs: TABSConstraintDefs;
                Temporary:         Boolean
                                        );
var i: Integer;
    FieldDef: TABSFieldDef;
begin
 // Clear Lists
 ABSFieldDefs.Clear;
 ABSConstraintDefs.Clear;

 // Fill ABSFieldDefs
 for i := 0 to AdvFieldDefs.Count-1 do
  begin
   // Fill ABSFieldDefs
   FieldDef := ABSFieldDefs.AddCreated;
   FieldDef.Name := AdvFieldDefs[i].Name;
   FieldDef.SetFieldDefDataType(AdvFieldDefs[i].DataType, AdvFieldDefs[i].Size);

   FieldDef.BLOBCompressionAlgorithm := TABSCompressionAlgorithm(Byte(AdvFieldDefs[i].BLOBCompressionAlgorithm));
   FieldDef.BLOBCompressionMode := AdvFieldDefs[i].BLOBCompressionMode;
   if (AdvFieldDefs[i].BLOBBlockSize > 0) then
     FieldDef.BLOBBlockSize := AdvFieldDefs[i].BLOBBlockSize
   else
     FieldDef.BLOBBlockSize := DefaultBLOBBlockSize;

   FieldDef.AutoincIncrement := AdvFieldDefs[i].AutoincIncrement;
   FieldDef.AutoincInitialValue := AdvFieldDefs[i].AutoincInitialValue;
   FieldDef.AutoincMinValue  := AdvFieldDefs[i].AutoincMinValue;
   FieldDef.AutoincMaxValue  := AdvFieldDefs[i].AutoincMaxValue;
   FieldDef.AutoincCycled    := AdvFieldDefs[i].AutoincCycled;

   FieldDef.DefaultValue.Assign(AdvFieldDefs[i].DefaultValue);

   if (not Temporary) then
    begin
     if (AdvFieldDefs[i].Required) then
       ABSConstraintDefs.AddNotNull.ColumnName := ShortString(AdvFieldDefs[i].Name);

     // Fill ABSConstraintDefs Check
     if ((not AdvFieldDefs[i].MinValue.IsNull) or (not AdvFieldDefs[i].MaxValue.IsNull)) then
      with ABSConstraintDefs.AddCheck do
      begin
        ColumnName := AdvFieldDefs[i].Name;
        MinValue.Assign(AdvFieldDefs[i].MinValue);
        MaxValue.Assign(AdvFieldDefs[i].MaxValue);
      end;
    end;//if

  end;//for

// if (not Temporary) then
   for i := 0 to IndexDefs.Count-1 do
     AddConstraintForIndex(IndexDefs[i], ABSConstraintDefs);

end;//ConvertAdvFieldDefsToABSFieldDefs


//------------------------------------------------------------------------------
// Add Unic or Primary Key constraint
//------------------------------------------------------------------------------
function AddConstraintForIndex(
                                  IndexDef:           TABSIndexDef;
                                  ABSConstraintDefs:  TABSConstraintDefs
                                 ): TABSConstraintDef;
var
  j: Integer;
  ConstraintDefPK: TABSConstraintDefPrimary;
  ConstraintDefUnique: TABSConstraintDefUnique;
begin
  Result := nil;
  if (IndexDef.Primary) then
    begin
     ConstraintDefPK := ABSConstraintDefs.AddPK;
     ConstraintDefPK.IndexName := IndexDef.Name;
     ConstraintDefPK.IndexObjectId := IndexDef.ObjectId;
     ConstraintDefPK.Name := AutoNameConstraintPKPreffix;

     // Constraint Fields...
     SetLength(ConstraintDefPK.Columns, IndexDef.ColumnCount);
     for j:=0 to IndexDef.ColumnCount-1 do
      begin
       ConstraintDefPK.Columns[j].ColumnName := IndexDef.Columns[j].FieldName;
       ConstraintDefPK.Name := ConstraintDefPK.Name + AutoNameSymbol +
                               IndexDef.Columns[j].FieldName;

      end;
     Result := ConstraintDefPK;
    end
   else if (IndexDef.Unique) then
    begin
     ConstraintDefUnique := ABSConstraintDefs.AddUnique;
     ConstraintDefUnique.IndexName := IndexDef.Name;
     ConstraintDefUnique.IndexObjectId := IndexDef.ObjectId;
     ConstraintDefUnique.Name :=  AutoNameConstraintUniquePreffix;

     // Constraint Fields...
     SetLength(ConstraintDefUnique.Columns, IndexDef.ColumnCount);
     for j:=0 to IndexDef.ColumnCount-1 do
      begin
       ConstraintDefUnique.Columns[j].ColumnName := IndexDef.Columns[j].FieldName;
       ConstraintDefUnique.Name := ConstraintDefUnique.Name + AutoNameSymbol +
                               IndexDef.Columns[j].FieldName;

      end;
     Result := ConstraintDefUnique;
    end;
end;//AddCoustraintFromIndex


//------------------------------------------------------------------------------
// convert ABSFieldDefs to AdvFieldDefs
//------------------------------------------------------------------------------
procedure ConvertABSFieldDefsToAdvFieldDefs(
                VisibleFieldDefs:   TABSFieldDefs;
                ABSFieldDefs:   TABSFieldDefs;
                ABSConstraintDefs: TABSConstraintDefs;
                AdvFieldDefs:   TABSAdvFieldDefs
                                        );
var i,j,k,n:      Integer;
    AdvFieldDef: TABSAdvFieldDef;
begin
 // Clear Lists
 AdvFieldDefs.Clear;

 // Fill AdvFieldDefs
 for i := 0 to VisibleFieldDefs.Count-1 do
  begin
   AdvFieldDef := AdvFieldDefs.AddFieldDef;

   // Fill AdvFieldDefs
   AdvFieldDef.Name := string(VisibleFieldDefs[i].Name);
   AdvFieldDef.ObjectID := VisibleFieldDefs[i].ObjectID;
   AdvFieldDef.DataType := VisibleFieldDefs[i].AdvancedFieldType;
   if (AdvFieldDef.DataType = aftGuid) then
     AdvFieldDef.Size := 0
   else
   AdvFieldDef.Size := VisibleFieldDefs[i].FieldSize;

   AdvFieldDef.AutoincIncrement := VisibleFieldDefs[i].AutoincIncrement;
   AdvFieldDef.AutoincInitialValue := VisibleFieldDefs[i].AutoincInitialValue;
   AdvFieldDef.AutoincMinValue   := VisibleFieldDefs[i].AutoincMinValue;
   AdvFieldDef.AutoincMaxValue  := VisibleFieldDefs[i].AutoincMaxValue;
   AdvFieldDef.AutoincCycled := VisibleFieldDefs[i].AutoincCycled;

   AdvFieldDef.BLOBCompressionAlgorithm :=
    ConvertABSCompressionAlgorithmToCompressionAlgorithm(
       VisibleFieldDefs[i].BLOBCompressionAlgorithm);
   AdvFieldDef.BLOBCompressionMode := VisibleFieldDefs[i].BLOBCompressionMode;
   AdvFieldDef.BLOBBlockSize := VisibleFieldDefs[i].BLOBBlockSize;

   AdvFieldDef.DefaultValue.Assign(VisibleFieldDefs[i].DefaultValue);
  end;

 // Fill Constraints Data
 for i := 0 to ABSConstraintDefs.Count-1 do
  begin
   case ABSConstraintDefs[i].ConstraintType of
     ctNotNull:
       begin
         n := ABSFieldDefs.GetDefNumberByObjectId(
                    TABSConstraintDefNotNull(ABSConstraintDefs[i]).ColumnObjectID);
         if n = -1 then
           raise EABSException.Create(30032, ErrorGFieldWithObjectIdNotFound,
                  [TABSConstraintDefNotNull(ABSConstraintDefs[i]).ColumnObjectID]);
         k := -1;
         for j := 0 to VisibleFieldDefs.Count - 1 do
           if (VisibleFieldDefs[j].FieldNoReference = n) then
            begin
             k := j;
             break;
            end;
         if (k > -1) then
          begin
           // Requared
           AdvFieldDefs[k].FRequired := True;
          end;
       end;
     ctCheck:
       begin
         n := ABSFieldDefs.GetDefNumberByObjectId(
                    TABSConstraintDefCheck(ABSConstraintDefs[i]).ColumnObjectID);
         if n = -1 then
           raise EABSException.Create(30031, ErrorGFieldWithObjectIdNotFound,
                  [TABSConstraintDefCheck(ABSConstraintDefs[i]).ColumnObjectID]);
         k := -1;
         for j := 0 to VisibleFieldDefs.Count - 1 do
           if (VisibleFieldDefs[j].FieldNoReference = n) then
            begin
             k := j;
             break;
            end;
         if (k > -1) then
          begin
           // Min
           AdvFieldDefs[k].MinValue.Assign(TABSConstraintDefCheck(ABSConstraintDefs[i]).MinValue);
           // Max
           AdvFieldDefs[k].MaxValue.Assign(TABSConstraintDefCheck(ABSConstraintDefs[i]).MaxValue);
          end;
       end;
     ctPK,
     ctUnique: ; // Nothing to do
     else
        raise EABSException.Create(30039, ErrorGNotImplementedYet);
   end;
  end;

end;//ConvertABSFieldDefsToAdvFieldDefs



//------------------------------------------------------------------------------
// convert ABSFieldDefs to TFieldDefs
//------------------------------------------------------------------------------
procedure ConvertABSFieldDefsToFieldDefs(
                ABSFieldDefs:   TABSFieldDefs;
                ABSConstraintDefs:  TABSConstraintDefs;
                FieldDefs:      TFieldDefs
                                        );
var i,j,n: Integer;
    fd:    TFieldDef;
    size:  Integer;
    ft:    TFieldType;
begin
{$IFDEF DEBUG_TRACE_DATASET}
aaWriteToLog('ConvertABSFieldDefsToFieldDefs start');
{$ENDIF}
 FieldDefs.Clear;
 for i := 0 to ABSFieldDefs.Count-1 do
  begin
   ft := ABSAdvFieldTypeToFieldType(ABSFieldDefs[i].AdvancedFieldType);
{$IFDEF D5H}
   if (ft = ftGuid) then
     size := 0
   else
{$ENDIF}
   if (IsSizebleFieldType(ABSFieldDefs[i].AdvancedFieldType)) then
     size := ABSFieldDefs[i].FieldSize
   else
     size := 0;
     
   FieldDefs.Add(ABSFieldDefs[i].Name, ft, Size, False);
  end;

 for i := 0 to ABSConstraintDefs.Count-1 do
  if ABSConstraintDefs[i].ConstraintType = ctNotNull then
   begin
    n := TABSConstraintDefNotNull(ABSConstraintDefs[i]).ColumnObjectID;
    j := ABSFieldDefs.GetDefNumberByObjectId(n);
    if j <> -1 then
      begin
        fd := FieldDefs.Find(ABSFieldDefs[j].Name);
        if (fd <> nil) then
          // Autoinc field must skip required, as otherwise dataset Post fails
          if (fd.DataType <> ftAutoInc) then
            fd.Required := true;
      end;
   end;

{$IFDEF DEBUG_TRACE_DATASET}
aaWriteToLog('ConvertABSFieldDefsToFieldDefs finish');
{$ENDIF}
end; //


//------------------------------------------------------------------------------
// get string list from string with names
//------------------------------------------------------------------------------
procedure GetNamesList(List: TStrings; const Names: string);
var
  Pos: Integer;
  NewNames: string;
begin
  Pos := 1;
  NewNames := StringReplace(Names, ',', ';', [rfReplaceAll]);
  if Assigned(List) then
   begin
    List.Clear;
    while Pos <= Length(NewNames) do
     List.Add(ExtractFieldName(NewNames, Pos));
   end;
end;// GetNamesList


//------------------------------------------------------------------------------
// fill ABSIndexDef
//------------------------------------------------------------------------------
procedure FillABSIndexDef(
              ABSIndexDef:         TABSIndexDef;
              const Name,
              Fields:              string;
              Options:             TIndexOptions;
              Temporary:           Boolean;
              const DescFields:    string;
              const CaseInsFields: string;
              const MaxIndexedSizes: string;
              FieldDefs:           TFieldDefs
                           );
var
  j:      Integer;
  FieldList, DescFieldList, CaseInsFieldList, MaxIndexedSizeList: TStringList;
begin
 FieldList := TStringList.Create;
 DescFieldList := TStringList.Create;
 CaseInsFieldList := TStringList.Create;
 MaxIndexedSizeList := TStringList.Create;
 try
     if (Name = '') then
      raise EABSException.Create(20048, ErrorAInvalidIndexName, ['']);
     if (Fields = '') then
      raise EABSException.Create(20049, ErrorACannotFindIndexField, ['']);

     ABSIndexDef.Name := Name;
     ABSIndexDef.IndexType := itBTree;
     ABSIndexDef.Unique := (ixUnique in Options);
     ABSIndexDef.Primary := (ixPrimary in Options);
     ABSIndexDef.Temporary := Temporary;
     GetNamesList(FieldList, Fields);
     GetNamesList(DescFieldList, DescFields);
     GetNamesList(CaseInsFieldList, CaseInsFields);
     GetNamesList(MaxIndexedSizeList, MaxIndexedSizes);
     ABSIndexDef.ColumnCount := FieldList.Count;
     for j := 0 to FieldList.Count-1 do
      begin
       if (FieldDefs.IndexOf(FieldList.Strings[j]) = -1) then
             raise EABSException.Create(20050, ErrorACannotFindIndexField,
                                        [FieldList.Strings[j]]);
       ABSIndexDef.Columns[j].FieldName := FieldList.Strings[j];
       ABSIndexDef.Columns[j].Descending :=
         (DescFieldList.IndexOf(FieldList.Strings[j]) >= 0) or
           ((ixDescending in Options) and (DescFieldList.Count = 0));
       ABSIndexDef.Columns[j].CaseInsensitive :=
         (CaseInsFieldList.IndexOf(FieldList.Strings[j]) >= 0) or
           ((ixCaseInsensitive in Options) and (CaseInsFieldList.Count = 0)) ;
       if (MaxIndexedSizeList.Count <= j) then
         ABSIndexDef.Columns[j].MaxIndexedSize := DEFAULT_MAX_INDEXED_SIZE
       else
         if (MaxIndexedSizeList.Strings[j] <> '') then
           ABSIndexDef.Columns[j].MaxIndexedSize := StrToInt(MaxIndexedSizeList.Strings[j])
         else
           ABSIndexDef.Columns[j].MaxIndexedSize := DEFAULT_MAX_INDEXED_SIZE;
      end;
 finally
   MaxIndexedSizeList.Free;
   FieldList.Free;
   DescFieldList.Free;
   CaseInsFieldList.Free;
 end;
end;// FillABSIndexDef


//------------------------------------------------------------------------------
// convert TABSAdvIndexDef to TABSIndexDef
//------------------------------------------------------------------------------
procedure ConvertAdvIndexDefToABSIndexDef(
                AdvIndexDef:   TABSAdvIndexDef;
                ABSIndexDef:   TABSIndexDef;
                FieldDefs:     TFieldDefs
                                       );
begin
 FillABSIndexDef(ABSIndexDef,
                 AdvIndexDef.Name, AdvIndexDef.Fields, AdvIndexDef.Options,
                 AdvIndexDef.Temporary,
                 AdvIndexDef.DescFields, AdvIndexDef.CaseInsFields,
                 AdvIndexDef.MaxIndexedSizes,
                 FieldDefs);
end;// ConvertIndexDefToABSIndexDef


//------------------------------------------------------------------------------
// convert AdvIndexDefs to TIndexDefs
//------------------------------------------------------------------------------
procedure ConvertAdvIndexDefsToIndexDefs(
              AdvIndexDefs:   TABSAdvIndexDefs; IndexDefs: TIndexDefs);
var
  i: Integer;
begin
  IndexDefs.Clear;
  for i := 0 to AdvIndexDefs.Count-1 do
    with IndexDefs.AddIndexDef do
      begin
        Name := AdvIndexDefs[i].Name;
        Fields := AdvIndexDefs[i].Fields;
        DescFields := AdvIndexDefs[i].DescFields;
        CaseInsFields := AdvIndexDefs[i].CaseInsFields;
        Options := AdvIndexDefs[i].Options;
        // correct options
        if (UpperCase(Trim(Fields))=UpperCase(Trim(DescFields))) then
         Options := Options + [ixDescending];
        if (UpperCase(Trim(Fields))=UpperCase(Trim(CaseInsFields))) then
         Options := Options + [ixCaseInsensitive];
      end;
end;// ConvertAdvIndexDefsToIndexDefs


//------------------------------------------------------------------------------
// convert TIndexDefs to TABSAdvIndexDefs
//------------------------------------------------------------------------------
procedure ConvertIndexDefsToAdvIndexDefs(
              IndexDefs: TIndexDefs; AdvIndexDefs:   TABSAdvIndexDefs);
var
  i: Integer;
begin
  AdvIndexDefs.Clear;
  for i := 0 to IndexDefs.Count-1 do
    with AdvIndexDefs.AddIndexDef do
      begin
        Name := IndexDefs[i].Name;
        Fields := IndexDefs[i].Fields;
        DescFields := IndexDefs[i].DescFields;
        CaseInsFields := IndexDefs[i].CaseInsFields;
        Options := IndexDefs[i].Options;
      end;
end;// ConvertIndexDefsToAdvIndexDefs


//------------------------------------------------------------------------------
// convert AdvIndexDefs to ABSIndexDefs
//------------------------------------------------------------------------------
procedure ConvertAdvIndexDefsToABSIndexDefs(
                AdvIndexDefs:   TABSAdvIndexDefs;
                ABSIndexDefs:   TABSIndexDefs;
                FieldDefs:      TFieldDefs
                                         );
var
  i:      Integer;
begin
  ABSIndexDefs.Clear;
  for i := 0 to AdvIndexDefs.Count-1 do
   ConvertAdvIndexDefToABSIndexDef(AdvIndexDefs[i], ABSIndexDefs.AddCreated, FieldDefs);
end;// ConvertAdvIndexDefsToABSIndexDefs


//------------------------------------------------------------------------------
// convert ABSIndexDef to AdvIndexDef
//------------------------------------------------------------------------------
procedure ConvertABSIndexDefToAdvIndexDef(
                ABSIndexDef:   TABSIndexDef; AdvIndexDef:   TABSAdvIndexDef);
var
  j: Integer;
  Options: TIndexOptions;
  Fields, DescFields, CaseInsFields, MaxIndexedSizes: string;
begin
  Fields := '';
  DescFields := '';
  CaseInsFields := '';
  MaxIndexedSizes := '';
  for j := 0 to ABSIndexDef.ColumnCount-1 do
    begin
      if (Fields <> '') then
       Fields := Fields + ';' + ABSIndexDef.Columns[j].FieldName
      else
       Fields := ABSIndexDef.Columns[j].FieldName;

      if (ABSIndexDef.Columns[j].Descending) then
       if (DescFields <> '') then
        DescFields := DescFields + ';' + ABSIndexDef.Columns[j].FieldName
       else
        DescFields := ABSIndexDef.Columns[j].FieldName;

      if (ABSIndexDef.Columns[j].CaseInsensitive) then
       if (CaseInsFields <> '') then
        CaseInsFields := CaseInsFields + ';' + ABSIndexDef.Columns[j].FieldName
       else
        CaseInsFields := ABSIndexDef.Columns[j].FieldName;

      if (MaxIndexedSizes <> '') then
        MaxIndexedSizes := MaxIndexedSizes + ';' + IntToStr(ABSIndexDef.Columns[j].MaxIndexedSize)
      else
        MaxIndexedSizes := IntToStr(ABSIndexDef.Columns[j].MaxIndexedSize);
    end;

   Options := [];
   if (ABSIndexDef.Unique) then
    Options := Options + [ixUnique];
   if (ABSIndexDef.Primary) then
    Options := Options + [ixPrimary];


   AdvIndexDef.Name := ABSIndexDef.Name;
   AdvIndexDef.CaseInsFields := CaseInsFields;
   AdvIndexDef.DescFields := DescFields;
   AdvIndexDef.Fields := Fields;
   AdvIndexDef.Options := Options;
   AdvIndexDef.Temporary := ABSIndexDef.Temporary;
   AdvIndexDef.MaxIndexedSizes := MaxIndexedSizes;
end;// ConvertABSIndexDefToAdvIndexDef


//------------------------------------------------------------------------------
// convert ABSIndexDefs to AdvIndexDefs
//------------------------------------------------------------------------------
procedure ConvertABSIndexDefsToAdvIndexDefs(ABSIndexDefs:   TABSIndexDefs;
                                         AdvIndexDefs:   TABSAdvIndexDefs);
var
  i: Integer;
begin
 AdvIndexDefs.Clear;
 for i := 0 to ABSIndexDefs.Count-1 do
   ConvertABSIndexDefToAdvIndexDef(ABSIndexDefs[i], AdvIndexDefs.AddIndexDef);
end;// ConvertABSIndexDefsToAdvIndexDefs


//------------------------------------------------------------------------------
// return true if field exists
//------------------------------------------------------------------------------
function FindFieldInFieldDefs(FieldDefs: TFieldDefs; FieldName : string): Boolean;
var i: integer;
    f: Boolean;
begin
 f := false;
 for i := 0 to FieldDefs.Count -1 do
   if (AnsiUpperCase(FieldDefs.Items[i].Name) = AnsiUpperCase(FieldName)) then
    begin
      f := true;
      break;
    end;
 Result := f;
end; // FindFieldInFieldDefs


//------------------------------------------------------------------------------
// compression algorithm
//------------------------------------------------------------------------------
function ConvertCompressionAlgorithmToABSCompressionAlgorithm(
    CompressionAlgorithm: TCompressionAlgorithm
          ): TABSCompressionAlgorithm;
begin
 Result := acaNone;
 case (CompressionAlgorithm) of
  caZLIB: Result := acaZLIB;
  caBZIP: Result := acaBZIP;
  caPPM: Result := acaPPM;
 end;
end; // ConvertCompressionAlgorithmToABSCompressionAlgorithm


//------------------------------------------------------------------------------
// compression algorithm
//------------------------------------------------------------------------------
function ConvertABSCompressionAlgorithmToCompressionAlgorithm(
            CompressionAlgorithm: TABSCompressionAlgorithm
          ): TCompressionAlgorithm;
begin
 Result := caNone;
 case (CompressionAlgorithm) of
  acaZLIB: Result := caZLIB;
  acaBZIP: Result := caBZIP;
  acaPPM: Result := caPPM;
 end;
end; // ConvertABSCompressionAlgorithmToCompressionAlgorithm


//------------------------------------------------------------------------------
// DbiError
//------------------------------------------------------------------------------
procedure DbiError(ErrorCode: Integer; ErrorMessage: string = '');
begin
  raise EABSEngineError.Create(ErrorCode, ErrorMessage);
end;// DbiError


//------------------------------------------------------------------------------
// Check
//------------------------------------------------------------------------------
procedure Check(Status: Integer; ErrorMessage: string = '');
begin
  if (Status <> ABS_ERR_OK) then
    DbiError(Status, ErrorMessage);
end;// Check




var
  DBDatas: TList;
{$IFDEF MEMORY_ENGINE}
  MemDBData: TABSMemoryDatabaseData;
{$ENDIF}
{$IFDEF TEMPORARY_ENGINE}
  TempDBData: TABSTemporaryDatabaseData;
{$ENDIF}


initialization
  {$IFDEF DEBUG_MEMCHECK}
  MemChk;
  {$ENDIF}

  DBDataList := TThreadList.Create;
  DBDatas := nil;
 {$IFDEF MEMORY_ENGINE}
  MemDBData := TABSMemoryDatabaseData.Create;
  DBDatas := DBDataList.LockList;
  DBDatas.Add(MemDBData);
  DBDataList.UnlockList;
 {$ENDIF}
 {$IFDEF TEMPORARY_ENGINE}
  TempDBData := TABSTemporaryDatabaseData.Create;
  DBDatas := DBDataList.LockList;
  DBDatas.Add(TempDBData);
  DBDataList.UnlockList;
 {$ENDIF}
{$IFDEF DEBUG_DESIGN_TIME}
  IsDesignMode := True;
{$ELSE}
  IsDesignMode := False;
{$ENDIF}
  Sessions:=TABSSessionList.Create;
  Session:=TABSSession.Create(nil);
  Session.SessionName := 'Default';
  WideStringsStack := TList.Create;



finalization
  Sessions.Free;
  Sessions := nil;
  DBDatas := DBDataList.LockList;
  while (DBDatas.Count > 0) do
    TABSDatabaseData(DBDatas.Items[0]).Free;
  DBDataList.UnlockList;
  DBDataList.Free;
  DBDataList := nil;
  while (WideStringsStack.Count > 0) do
    begin
      Dispose(WideStringsStack[0]);
      WideStringsStack.Delete(0);
    end;
  WideStringsStack.Free;

end.


