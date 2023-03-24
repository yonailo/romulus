unit ABSDiskEngine;

interface

{$I ABSVer.inc}

uses SysUtils, Classes, Windows, Math,

// AbsoluteDatabase units

{$IFDEF DEBUG_LOG}
     ABSDebug,

{$ENDIF}
{$IFNDEF D5H}
     ABSD4Routines,
{$ENDIF}
     ABSExcept,
     ABSBase,
     ABSBaseEngine,
     ABSBTree,
     ABSMemory,
     ABSPage,
     ABSCompression,
     ABSExpressions,
     ABSSecurity,
     ABSCipher,
     ABSDecUtil,
     ABSConverts,
     ABSTypes,
     ABSConst;

type

 // forward decls
 TABSDiskPageManager = class;
 TABSDiskTableData = class;
 TABSSystemDirectory = class;
 TABSActiveSessionsFile = class;
 TABSTableListFile = class;
 TABSTableLocksFile = class;
 TABSInternalDBDirectAccessFile = class;
 TABSInternalDBTransactedAccessFile = class;
 TABSDatabaseTableLockManager = class;


////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskDatabaseData
//
////////////////////////////////////////////////////////////////////////////////


  TABSDiskDatabaseData = class (TABSDatabaseData)
   private
    FSystemDir:           TABSSystemDirectory;
    FActiveSessionsFile:  TABSActiveSessionsFile;
    FTableListFile:       TABSTableListFile;
    FPassword:            TABSPassword;
    FMaxSessionCount:     Integer;
    FPageSize:            Integer;
    FPageCountInExtent:   Integer;
    FTableLockManager:    TABSDatabaseTableLockManager;
    FSingleUserConnected: Boolean;

    procedure OpenDatabase(Session: TABSBaseSession; Exclusive: Boolean;
                           var RepairNeeded: Boolean);
    procedure CloseDatabase;
    function GetPassword: PABSPassword;
    function GetEncrypted: Boolean;

   protected
    procedure AddTable(
           TableID: TABSTableID;
           TableName: AnsiString;
           MetadataFilePageNo,
           MostUpdatedFilePageNo,
           LocksFilePageNo: TABSPageNo
                         );
    procedure RemoveTable(TableName: AnsiString);
    procedure OpenTable(
           TableName: AnsiString;
           out TableID: TABSTableID;
           out MetadataFilePageNo: TABSPageNo;
           out MostUpdatedFilePageNo: TABSPageNo;
           out LocksFilePageNo: TABSPageNo
                         );
    procedure RenameTable(TableName, NewTableName: AnsiString);

   public
    constructor Create;
    destructor Destroy; override;
    // create table data
    function CreateTableData(Cursor: TABSCursor): TABSTableData; override;
    // database operations
    procedure CreateDatabase; override;
    procedure ConnectSession(Session: TABSBaseSession); override;
    procedure DisconnectSession(Session: TABSBaseSession); override;
    procedure FreeIfNoSessionsConnected; override;
    procedure GetTablesList(List: TStrings); override;
    // database operations
    procedure TruncateDatabase;
    function GetDBFileConnectionsCount: Integer;

    // lock tables (virtual object)
    procedure LockTables;
    // unlock tables (virtual object)
    procedure UnlockTables;
    procedure Commit(SessionID: TABSSessionID; DoFlushBuffers: Boolean=True); override;
    procedure Rollback(SessionID: TABSSessionID); override;
    procedure FlushBuffers; override;

    function GetNewObjectId: TABSObjectID; override;

    function GetSuppressDBHeaderErrors: Boolean;
    procedure SetSuppressDBHeaderErrors(Value: boolean);

   public
    property Password: PABSPassword read GetPassword;
    property Encrypted: Boolean read GetEncrypted;
    property MaxSessionCount: Integer read FMaxSessionCount write FMaxSessionCount;
    property PageSize: Integer read FPageSize write FPageSize;
    property PageCountInExtent: Integer read FPageCountInExtent write FPageCountInExtent;
  end; // TABSDiskDatabaseData


////////////////////////////////////////////////////////////////////////////////
//
// TABSSmallRecordPage
//
////////////////////////////////////////////////////////////////////////////////

  TABSSmallRecordPage = class(TObject)
    private
      LPage: TABSPage;
      FRecordBufferSize: Integer;
      FMaxRecordsOnPage: Integer;
      FRecordDataOffset: Integer;

      function FindUnusedRecordSlot(var SlotNo: Integer): Boolean;
      function GetRecordCount: TABSRecordNo;

    public
      constructor Create(Page: TABSPage; RecordBufferSize: Integer;
                         MaxRecordsOnPage: Integer);
      procedure AddRecord(RecordBuffer: TAbsPByte; var RecordID: TABSRecordID);
      function UpdateRecord(RecordBuffer: TAbsPByte; RecordID: TABSRecordID): Boolean;
      function DeleteRecord(RecordID: TABSRecordID): Boolean;
      function GetRecordBuffer(RecordID: TABSRecordID; RecordBuffer: TAbsPByte): Boolean;
      // navigation inside page
      procedure GetFirstRecordID(var RecordID: TABSRecordID);
      procedure GetLastRecordID(var RecordID: TABSRecordID);
      function GetNextRecordID(var RecordID: TABSRecordID): Boolean;
      function GetPriorRecordID(var RecordID: TABSRecordID): Boolean;
      procedure GetRecordID(RecNoOnPage: Integer; var RecordID: TABSRecordID);
      procedure GetRecNoOnPage(RecordID: TABSRecordID; var RecNoOnPage: Integer);

      property RecordCount: TABSRecordNo read GetRecordCount;
  end;// TABSSmallRecordPage


////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskRecordManager
//
////////////////////////////////////////////////////////////////////////////////

  TABSDiskRecordManager = class(TABSBaseRecordManager)
   private
    FRecordPageIndex:     TABSBTreeRecordPageIndex;
    LPageManager:         TABSPageManager;
    LFieldManager:        TABSBaseFieldManager;
    LMostUpdatedFile:     TABSInternalDBTransactedAccessFile;
    FMaxRecordsOnPage:    Integer;
    FLastAutoIncValues:   array of Int64;
    FDiskRecordBufferSize: Integer;
    FTempDiskRecordBuffer: TAbsPByte;
    LTableData:           TABSDiskTableData;

    function IsRecordPageValid(Page: TABSPage): Boolean;
    procedure GetFirstRecord(SessionID: TABSSessionID;
                             var NavigationInfo: TABSNavigationInfo);
    procedure GetLastRecord(SessionID: TABSSessionID;
                             var NavigationInfo: TABSNavigationInfo);
    procedure GetNextRecord(SessionID: TABSSessionID;
                             var NavigationInfo: TABSNavigationInfo);
    procedure GetPriorRecord(SessionID: TABSSessionID;
                             var NavigationInfo: TABSNavigationInfo);
    procedure GetCurrentRecord(SessionID: TABSSessionID;
                             var NavigationInfo: TABSNavigationInfo);


   public
    constructor Create(PageManager: TABSPageManager;
       FieldManager: TABSBaseFieldManager; MostUpdatedFile: TABSInternalDBTransactedAccessFile;
       TableData: TABSDiskTableData);
    destructor Destroy; override;
    procedure Init(RecordBufferSize: Integer; DiskRecordBufferSize: Integer;
                   FieldCount: Integer);
    procedure LoadMostUpdated(Buf: TAbsPByte; var Offset: Integer);
    procedure SaveMostUpdated(Buf: TAbsPByte; var Offset: Integer);
    procedure LoadMetadata(Stream: TStream);
    procedure SaveMetadata(Stream: TStream);
    procedure CreateRecordPageIndex;

    procedure Empty(SessionID: TABSSessionID); override;
    procedure Delete(SessionID: TABSSessionID);

    // add record and return its number
    function AddRecord(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer; var RecordID: TABSRecordID): Boolean; override;
    // update record, return true if record was updated, false if record was deleted
    function UpdateRecord(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer; RecordID: TABSRecordID): Boolean; override;
    // delete record, return true if record was deleted, false if record was deleted earlier
    function DeleteRecord(SessionID: TABSSessionID; var RecordID: TABSRecordID): Boolean; override;
    procedure GetRecordBuffer(SessionID: TABSSessionID; var NavigationInfo: TABSNavigationInfo); override;
    // return 0,1, or -1 if (1 = 2), (1 > 2) or (1 < 2)
    function CompareRecordID(RecordID1: TABSRecordID; RecordID2: TABSRecordID): Integer; override;
    // return record no
    function GetApproximateRecNo(SessionID: TABSSessionID; RecordID: TABSRecordID): TABSRecordNo; override;

    procedure SetRecNo(SessionID: TABSSessionID; RecNo: TABSRecordNo; var RecordID: TABSRecordID);
    procedure GetRecNo(SessionID: TABSSessionID; RecordID: TABSRecordID; var RecNo: TABSRecordNo);

    procedure RebuildRecordPageIndex(SessionID: TABSSessionID);
    procedure ValidateRecordPageIndex(SessionID: TABSSessionID);

    property RecordPageIndex: TABSBTreeRecordPageIndex read FRecordPageIndex;
  end;// TABSDiskRecordManager



////////////////////////////////////////////////////////////////////////////////
//
// TABSSmallBlobPage
//
////////////////////////////////////////////////////////////////////////////////

  TABSSmallBlobPage = class(TObject)
    protected
      LPage: TABSPage;

      procedure SetBlobCount(Value: Integer);
      function GetBlobCount: Integer;
      function BlobHeader(Index: Integer): PABSDiskBlobHeader;
      function BlobData(Index: Integer): TAbsPByte;
      function GetNewBlobID: Word;

    public
      constructor Create(Page: TABSPage);
      procedure AddBlob(BlobCache: PABSDiskBLOBCache;
                        var PageItemID: TABSPageItemID);
      procedure DeleteBlob(PageItemID: TABSPageItemID; var BlobSize: Integer);
      procedure ReadBlob(BlobCache: PABSDiskBLOBCache;
                         PageItemID: TABSPageItemID);


      property BlobCount: Integer read GetBlobCount write SetBlobCount;
  end;// TABSSmallBlobPage


////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskBlobManager
//
////////////////////////////////////////////////////////////////////////////////

  TABSDiskBlobManager = class(TObject)
   private
    LPageManager:         TABSPageManager;
    LFieldManager:        TABSBaseFieldManager;
    LRecordManager:       TABSBaseRecordManager;
    FBlobCacheList:       TList;
    FBlobPageIndex:       TABSBTreeBlobPageIndex;

    procedure GetBlobInfo(RecordBuffer: TABSRecordBuffer;
                          FieldNo: Integer;
                          var PageItemID: TABSPageItemID;
                          var BlobCache: PABSDiskBLOBCache);
    procedure SetBlobInfo(RecordBuffer: TABSRecordBuffer;
                          FieldNo: Integer; PageItemID: TABSPageItemID);
    procedure CreateBlobCache(RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
                              var BlobCache: PABSDiskBLOBCache);
    procedure FreeBlobCache(RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
                            ForceClear: Boolean = False);
    procedure StreamToBlobCache(Stream: TABSStream; BlobCache: PABSDiskBLOBCache);
    procedure BlobCacheToStream(BlobCache: PABSDiskBLOBCache; Stream: TStream);

    // blob <-> disk pages
    procedure ReadBlobHeader(SessionID: TABSSessionID; PageItemID: TABSPageItemID;
                             var BlobHeader: TABSDiskBlobHeader;
                             BlobCache: PABSDiskBLOBCache);
    procedure WriteBlobHeader(SessionID: TABSSessionID;
                BlobHeader: TABSDiskBlobHeader; var PageItemID: TABSPageItemID);

    procedure ReadBlobData(
                   // in
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   BlobHeader: TABSDiskBlobHeader;
                   BlobDataPageList: TABSIntegerArray;
                   // out
                   BlobCache: PABSDiskBLOBCache);
    procedure ReadBlobDataPageList(
                   // in
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   const PageListLink: TABSPageListLink;
                   // out
                   BlobDataPageList: TABSIntegerArray;
                   BlobDataPageListPages: TABSIntegerArray);
    procedure ReadLinkToBlobDataPageList(
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   var PageListLink: TABSPageListLink);
    procedure ReadMultiPagesBlob(SessionID: TABSSessionID;
                      PageItemID: TABSPageItemID; BlobHeader: TABSDiskBlobHeader;
                      BlobCache: PABSDiskBLOBCache);

    procedure WriteBlobData(
                   // in
                   SessionID: TABSSessionID;
                   BlobCache: PABSDiskBLOBCache; PageItemID: TABSPageItemID;
                   BlobHeader: TABSDiskBlobHeader;
                   // out
                   var LastPageNo: TABSPageNo; var LastPageOffset: Word;
                   BlobDataPageList: TABSIntegerArray);
    procedure WriteBlobDataPageList(
                   // in
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   BlobHeader: TABSDiskBlobHeader;
                   LastPageNo: TABSPageNo; LastPageOffset: Word;
                   BlobDataPageList: TABSIntegerArray;
                   // out
                   var PageListLink: TABSPageListLink);
    procedure WriteLinkToBlobDataPageList(
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   PageListLink: TABSPageListLink);

    procedure WriteMultiPagesBlob(SessionID: TABSSessionID;
                      BlobCache: PABSDiskBLOBCache; var PageItemID: TABSPageItemID;
                      BlobHeader: TABSDiskBlobHeader);

    procedure InternalReadSmallBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; PageItemID: TABSPageItemID);
    procedure InternalReadLargeBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; PageItemID: TABSPageItemID);
    function IsProbablyLargeBlob(SessionID: TABSSessionID;
                                 PageItemID: TABSPageItemID): Boolean;
    procedure InternalReadBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; PageItemID: TABSPageItemID);

    procedure InternalWriteSmallBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; var PageItemID: TABSPageItemID);
    procedure InternalWriteLargeBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; var PageItemID: TABSPageItemID);
    function IsSmallBlob(BlobSize: Int64): Boolean;
    procedure InternalWriteBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; var PageItemID: TABSPageItemID);

    procedure InternalDeleteSmallBlob(SessionID: TABSSessionID;
                                 var PageItemID: TABSPageItemID);
    procedure InternalDeleteLargeBlob(SessionID: TABSSessionID;
                                 var PageItemID: TABSPageItemID);
    procedure InternalDeleteBlob(SessionID: TABSSessionID;
                                 var PageItemID: TABSPageItemID);

   public
    constructor Create(PageManager: TABSPageManager;
       FieldManager: TABSBaseFieldManager; RecordManager: TABSBaseRecordManager);
    destructor Destroy; override;
    procedure LoadMetadata(Stream: TStream);
    procedure SaveMetadata(Stream: TStream);
    procedure CreateBlobPageIndex;

    procedure Empty(SessionID: TABSSessionID);
    procedure Delete(SessionID: TABSSessionID);

    // RecordBuffer <-> disk pages
    procedure ReadBlob(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer;
                       FieldNo: Integer);
    procedure WriteBlob(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer;
                        FieldNo: Integer);
    procedure WriteBlobs(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer);
    procedure DeleteBlob(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer;
                        FieldNo: Integer);
    procedure DeleteBlobs(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer);

    // Blob stream <-> RecordBuffer
    procedure CopyBlobFromRecordBufferToStream(SessionID: TABSSessionID;
        RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
        var BLOBDescriptor: TABSBLOBDescriptor; Stream: TStream);
    procedure CopyBlobFromStreamToRecordBuffer(RecordBuffer: TABSRecordBuffer;
                        FieldNo: Integer; Stream: TABSStream);
    procedure ClearBlobInRecordBuffer(RecordBuffer: TABSRecordBuffer; FieldNo: Integer; ForceClear: Boolean = False);

    // RecordBuffer <-> Direct Blob Info (descriptor + binary data)
    procedure GetDirectBlobInfoFromRecordBuffer(SessionID: TABSSessionID;
        RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
        var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
        var pBlobData: TAbsPByte);
    procedure SetDirectBlobInfoFromRecordBuffer(SessionID: TABSSessionID;
        RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
        var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
        var pBlobData: TAbsPByte);


  end;// TABSDiskBlobManager




////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskTableData
//
////////////////////////////////////////////////////////////////////////////////


  TABSDiskTableData = class (TABSTableData)
   private
    FTableID:                TABSTableID;
    FTableLocksFile:         TABSTableLocksFile;
    FTableMetadataFile:      TABSInternalDbTransactedAccessFile;
    FTableMostUpdatedFile:   TABSInternalDbTransactedAccessFile;
    FBlobManager:            TABSDiskBlobManager;
    FTemporaryPageManager:   TABSPageManager;
    FExclusive:              Boolean;
    FIsChangingTableList:    Boolean;
    FLastUsedTableState:     Integer;

    procedure CreateTableFiles;
    procedure DeleteTableFiles;
    procedure OpenTableFiles(MetadataFilePageNo: TABSPageNo;
                             MostUpdatedFilePageNo: TABSPageNo;
                             LocksFilePageNo: TABSPageNo);
    procedure FreeTableFiles;
    procedure LoadMetadataFile(SessionID: TABSSessionID);
    procedure SaveMetadataFile(SessionID: TABSSessionID);
    procedure CleanMostUpdated(SessionID: TABSSessionID);
    procedure SaveMostUpdated(SessionID: TABSSessionID);
  public
    procedure LoadMostUpdated(SessionID: TABSSessionID);
  private
    function GetDiskRecordBufferSize: Integer;
    procedure RebuildRecordPageIndex(SessionID: TABSSessionID);
    procedure ValidateAndRepairMostUpdatedAndRecordPageIndex(Cursor: TABSCursor);
    procedure ValidateRecordPageIndex(Cursor: TABSCursor);

   protected
    // return filter bitmap rec count
    function GetBitmapRecordCount(SessionID: TABSSessionID): TABSRecordNo; override;
    // return filter bitmap rec no by record id
    function GetBitmapRecNoByRecordID(RecordID: TABSRecordID): TABSRecordNo; override;
    // return filter bitmap rec no by record id
    function GetRecordIDByBitmapRecNo(RecordNo: TABSRecordNo): TABSRecordID; override;

    procedure CreateRecordManager; override;
    procedure CreateBlobManager;
    procedure CreateFieldManager(FieldDefs: TABSFieldDefs); override;
    procedure CreateIndexManager(IndexDefs: TABSIndexDefs); override;
    procedure CreateConstraintManager(ConstraintDefs: TABSConstraintDefs); override;


   public
    constructor Create(aDatabaseData: TABSDatabaseData);
    destructor Destroy; override;
    procedure FreeIfNoCursorsConnected;

    procedure ApplyChanges(SessionID: TABSSessionID; InTransaction: Boolean); override;
    procedure CancelChanges(SessionID: TABSSessionID; InTransaction: Boolean); override;

    procedure CreateTable(
                          Cursor: TABSCursor;
                          FieldDefs: TABSFieldDefs;
                          IndexDefs: TABSIndexDefs;
                          ConstraintDefs: TABSConstraintDefs
                         ); override;
    procedure DeleteTable(Cursor: TABSCursor; DesignMode: Boolean = False); override;
    procedure EmptyTable(Cursor: TABSCursor); override;
    procedure RenameTable(NewTableName: string; Cursor: TABSCursor); override;
    procedure OpenTable(Cursor: TABSCursor); override;
    procedure CloseTable(Cursor: TABSCursor); override;

    procedure RenameField(FieldName, NewFieldName: string); override;

    procedure AddIndex(IndexDef: TABSIndexDef; Cursor: TABSCursor); override;
    procedure DeleteIndex(IndexID: TABSObjectID; Cursor: TABSCursor); override;

    //---------------------------------------------------------------------------
    // BLOB methods
    //---------------------------------------------------------------------------
    procedure WriteBLOBFieldToRecordBuffer(
              Cursor:     TABSCursor;
              FieldNo:    Integer;
              BLOBStream: TABSStream
              ); override;

    procedure ClearBLOBFieldInRecordBuffer(
              RecordBuffer: TABSRecordBuffer;
              FieldNo:    Integer
              ); override;

    procedure ClearModifiedBLOBFieldsInRecordBuffer(RecordBuffer: TABSRecordBuffer);

    function InternalCreateBlobStream(
              Cursor:   TABSCursor;
              ToInsert: Boolean;
              FieldNo:  Integer;
              OpenMode: TABSBLOBOpenMode
              ): TABSStream; override;

    procedure GetDirectBlobData(
              Cursor:     TABSCursor;
              FieldNo:    Integer;
              RecordBuffer: TABSRecordBuffer;
              var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
              var pBlobData: TAbsPByte); override;

    procedure SetDirectBlobData(
              Cursor:     TABSCursor;
              FieldNo:    Integer;
              RecordBuffer: TABSRecordBuffer;
              var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
              var pBlobData: TAbsPByte); override;

    procedure FreeDirectBlobData(
              Cursor:     TABSCursor;
              FieldNo:    Integer;
              RecordBuffer: TABSRecordBuffer;
              var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
              var pBlobData: TAbsPByte); override;

    function InsertRecord(var Cursor: TABSCursor): Boolean; override;
    function DeleteRecord(Cursor: TABSCursor): Boolean; override;
    function UpdateRecord(Cursor: TABSCursor): Boolean; override;

    procedure ClearBlobsCacheInRecordBuffer(Buffer: TABSRecordBuffer); override;
    function GetRecordBuffer(
                              Cursor:         TABSCursor;
                              GetRecordMode:  TABSGetRecordMode
                            ): TABSGetRecordResult; override;
    function Locate(Cursor: TABSCursor; SearchExpression: TABSExpression): Boolean; override;
    function FindKey(Cursor: TABSCursor; SearchCondition: TABSSearchCondition): Boolean; override;
    procedure SetRecNo(Cursor: TABSCursor; RecNo: TABSRecordNo); override;
    function GetRecNo(Cursor: TABSCursor): TABSRecordNo; override;
    function InternalGetRecordCount(Cursor: TABSCursor): TABSRecordNo; override;
    // move cursor to specified position and set current record id in cursor
    procedure InternalSetRecNo(Cursor: TABSCursor; RecNo: TABSRecordNo); override;
    // get current record position from cursor
    function InternalGetRecNo(Cursor: TABSCursor): TABSRecordNo; override;

    function LastAutoincValue(FieldNo: Integer; Session: TABSBaseSession): Int64; override;

    procedure Rollback(SessionID: TABSSessionID); override;

    // locking
    function LockTable(SessionID: TABSSessionID; LockType: TABSLockType;
                       TryCount, Delay: Integer;
                       AllowXIRWAfterSIRW: Boolean = True): Boolean;
    function UnlockTable(SessionID: TABSSessionID; LockType: TABSLockType; IgnoreIfNoLock: Boolean=False): Boolean;
    function LockRecord(SessionID: TABSSessionID; RecordID: TABSRecordID;
                        TryCount, Delay: Integer): Boolean;
    function UnlockRecord(SessionID: TABSSessionID; RecordID: TABSRecordID): Boolean;
    function IsRecordLocked(SessionID: TABSSessionID; RecordID: TABSRecordID): Boolean;

  end; // TABSDiskTableData


////////////////////////////////////////////////////////////////////////////////
//
// TABSDatabaseFile
//
////////////////////////////////////////////////////////////////////////////////

  TABSDatabaseFile = class(TObject)
   private
    FFileName:  string;

    FAccessMode:  TABSAccessMode;
    FShareMode:   TABSShareMode;
    FAttrFlags:   DWORD;

    FHandle:      THandle;
    FIsOpened:  Boolean;
    DesignOpenCount:  Integer;
    FWasCriticalError: Boolean;
   private
    function AccessModeToWindowsMode(am: TABSAccessMode): DWORD;
    function ShareModeToWindowsMode(sm: TABSShareMode): DWORD;

    // if file closed then raise
    procedure CheckOpened(OperationName: AnsiString);
    // if file opened then raise
    procedure CheckClosed(OperationName: AnsiString);
    // Seek
    function InternalSeek(Offset: Int64): Boolean;
    procedure Seek(Offset: Int64; ErrorCode: Integer = 0);

    procedure SetPosition(Offset: Int64);
    function  GetPosition: Int64;

    procedure SetSize(NewSize: Int64);
    function  GetSize: Int64;
   public
    // Constructor
    constructor Create;
    // Destructor
    destructor Destroy; override;

    // Create and Open File
    procedure CreateAndOpenFile(FileName: string);
    // Delete File
    procedure DeleteFile(FileName: string);
    // Rename Closed File
    procedure RenameFile(OldFileName, NewFileName: string);

    // Open File
    procedure OpenFile(FileName: string; AccessMode: TABSAccessMode; ShareMode: TABSShareMode);
    // Close File
    procedure CloseFile;
    procedure OpenFileForDesignTime;
    procedure CloseFileForDesignTime;
    // if connection to the network file is lost, try to reopen it
    function ReopenDatabaseFile: Boolean;

    // Read Buffer
    procedure ReadBuffer(var Buffer; const Count: Int64; const Position: Int64; ErrorCode: Integer); overload;
    function ReadBuffer(var Buffer; const Count: Int64; const Position: Int64): Boolean; overload;
    // Write Buffer
    procedure WriteBuffer(const Buffer; const Count: Int64; const Position: Int64; ErrorCode: Integer);
    // Flush Buffers
    procedure FlushFileBuffers;

    // Lock Byte (return TRUE if success)
    function LockByte(Offset: Int64; Count: Integer = 1): Boolean;
    // Unlock Byte
    function UnlockByte(Offset: Int64; Count: Integer = 1): Boolean;
    // return TRUE if byte Locked
    function IsByteLocked(Offset: Int64): Boolean;
    // return FALSE if any byte of region is locked
    function IsRegionLocked(Offset: Int64; Count: Integer): Boolean;
    // find signature
    function FindSignature(var Offset: Int64): Boolean;
   public
    property FileName: string read FFileName;
    property Size: Int64 read GetSize write SetSize;
    property IsOpened: Boolean read FIsOpened;
    property Position: Int64 read GetPosition write SetPosition;
  end;// TABSDatabaseFile



////////////////////////////////////////////////////////////////////////////////
//
// TABSDatabaseFreeSpaceManager
//
////////////////////////////////////////////////////////////////////////////////


  TABSDatabaseFreeSpaceManager = class(TObject)
   private
    LPageManager: TABSDiskPageManager;

    FPageCountInExtent:         Integer;
    FPFSPage_PagesAddressed:    Integer;  // count of pages addressed by PFSPage
    FEAMPage_ExtentsAddressed:  Integer;  // count of extents addressed by EAMPage
    FEAMPage_PagesAddressed:    Integer;  // count of pages addressed by EAMPage

    FLastUsedPageNo:            TABSPageNo;
    FTotalPageCount:            TABSPageNo;
    FSuppressDBHeaderErrors:    Boolean;

    function GetAddPagesStep: Integer;
    function GetDelPagesStep: Integer;

    function NewPage(PageNo: TABSPageNo): TABSPage;
    function ReadPage(PageNo: TABSPageNo): TABSPage;
    procedure WriteAndFreePage(var Page: TABSPage);


    function CorrectEamPageNo(EamPageNo: TABSPageNo): TABSPageNo;
    function UncorrectEamPageNo(EamPageNo: TABSPageNo): TABSPageNo;
    function EamPageNoForEamPagePosition(EamPagePosition: Integer): TABSPageNo;
    function EamPageNoToEamPagePosition(EamPageNo: TABSPageNo): Integer;
    function EamPageNoForPageNo(PageNo: TABSPageNo): TABSPageNo;

    function GetLastEamPagePosition: Integer;
    function GetLastEamPageNo: TABSPageNo;
    function GetLastPfsPagePosition: Integer;
    function PfsPositionsForExtentPosition(const ExtentPosition: Integer;
                                            out PfsFirstPagePosition: Integer;
                                            out PfsLastPagePosition: Integer
                                            ): Boolean;
    function PfsPageNoForPfsPagePosition(PfsPagePosition: Integer): TABSPageNo;
    function PfsPageNoForPageNo(PageNo: TABSPageNo): TABSPageNo;


    function IsPagePfsOrEam(PageNo: TABSPageNo): Boolean;

    function FindAndReusePage: TABSPageNo;
    function FindLastUsedPageNo: TABSPageNo;

    // Set in PFS and EAM maps that page with number PageNo is USED or FREE
    procedure SetPageUsage(PageNo: TABSPageNo; UsedFlag: Boolean);
    procedure SetPageUsageToPFS(PageNo: TABSPageNo; UsedFlag: Boolean);
    procedure SetPageUsageToEAM(PageNo: TABSPageNo; UsedFlag: Boolean);

   public
    function GetPageUsageFromPFS(PageNo: TABSPageNo) : Boolean;

   private
    function AddNewPageAndExtentFile: TABSPageNo;
    procedure TruncateFile;

    procedure ReReadPageCountVariables;
    procedure ReWritePageCountVariables;

   public
    constructor Create(aPageManager: TABSDiskPageManager);
    function GetPage(DesiredStartPageNo: TABSPageNo = INVALID_PAGE_NO): TABSPageNo;
    procedure FreePage(PageNo: TABSPageNo);
    procedure CheckPageNoForSystemPages(PageNo: TABSPageNo);

    property AddPagesStep: Integer read GetAddPagesStep;
    property DelPagesStep: Integer read GetDelPagesStep;
    property SuppressDBHeaderErrors: Boolean read FSuppressDBHeaderErrors write FSuppressDBHeaderErrors;

{
    procedure GetPages(
           PageCount:          TABSPageNo;
           var Pages:          TABSPagesArray;
           bUniform:           Boolean;
           DesiredStartPageNo: TABSPageNo
                     ); virtual; abstract;
    procedure FreePages(Pages: TABSPagesArray); virtual; abstract;
}
  end;// TABSDatabaseFreeSpaceManager




////////////////////////////////////////////////////////////////////////////////
//
// TABSDTPCTableInfo
//
////////////////////////////////////////////////////////////////////////////////

  TABSDTPCTableInfo = class
   private
    TableID: TABSTableID;
    TableSLockCount: Integer;
    TableRWLockCount: Integer;
    IsMostUpdatedLoaded: Boolean;

    procedure Clear;
   public
    TableState: Integer;

    constructor Create(aTableID: TABSTableID);
    destructor Destroy; override;
    procedure TableIsSLocked;
    procedure TableIsSUnlocked;
    procedure TableIsRWLocked;
    procedure TableIsRWUnlocked;
    function GetIsMostUpdatedLoaded: Boolean;
    procedure SetIsMostUpdatedLoaded(aTableState: Integer);
    function IsTableLockedFromModification: Boolean;
  end;

////////////////////////////////////////////////////////////////////////////////
//
// TABSDTPCSessionInfo
//
////////////////////////////////////////////////////////////////////////////////

  TABSDTPCSessionInfo = class
   private
    FTableInfo: array of TABSDTPCTableInfo;
    FWorkTableIDs: TList; // stack of work table IDs

   public
    constructor Create;
    destructor Destroy; override;
    function GetTableInfo(TableID: TABSTableID): TABSDTPCTableInfo;
    procedure BeginWorkWithTable(TableID: TABSTableID);
    procedure EndWorkWithTable(TableID: TABSTableID);
    function GetWorkTableState(var WorkTableState: Integer): Boolean;
  end;// TABSDTPCSessionInfo

////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskTablePagesCacheManager
//
////////////////////////////////////////////////////////////////////////////////

  TABSDiskTablePagesCacheManager = class
   private
    FSessionInfo: array of TABSDTPCSessionInfo;

    function GetSessionInfo(SessionID: TABSSessionID): TABSDTPCSessionInfo;
   public
    constructor Create;
    destructor Destroy; override;
    procedure TableIsSLocked(SessionID: TABSSessionID; TableID: TABSTableID);
    procedure TableIsSUnlocked(SessionID: TABSSessionID; TableID: TABSTableID);
    procedure TableIsRWLocked(SessionID: TABSSessionID; TableID: TABSTableID);
    procedure TableIsRWUnlocked(SessionID: TABSSessionID; TableID: TABSTableID);
    function GetIsMostUpdatedLoaded(SessionID: TABSSessionID; TableID: TABSTableID): Boolean;
    procedure SetIsMostUpdatedLoaded(SessionID: TABSSessionID; TableID: TABSTableID; TableState: Integer);
    procedure BeginWorkWithTable(SessionID: TABSSessionID; TableID: TABSTableID);
    procedure EndWorkWithTable(SessionID: TABSSessionID; TableID: TABSTableID);
    function GetWorkTableState(SessionID: TABSSessionID; var WorkTableState: Integer): Boolean;
  end;// TABSDiskTablePagesCacheManager



////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskPageManager
//
////////////////////////////////////////////////////////////////////////////////


  TABSDiskPageManager = class (TABSPageManager)
   private
    FDatabaseFreeSpaceManager:  TABSDatabaseFreeSpaceManager;
    FDatabaseFile:              TABSDatabaseFile;
    FDBHeader:                  TABSDBHeader;
    FCryptoHeader:              TABSCryptoHeader;
    FPassword:                  TABSPassword;
    FLockedBytes:               TABSLockedBytes;
    FLockDBHeaderCount:         Integer;
    FExclusive:                 Boolean;
    FTablePagesCacheManager:    TABSDiskTablePagesCacheManager;

    FOffsetToDBHeader:          Int64;
    FOffsetToCryptoHeader:      Int64;
    FOffsetToLockedBytes:       Int64;
    FOffsetToLastObjectID:      Int64;
    FOffsetToFirstPage:         Int64;

    procedure InitHeaders;

    procedure LoadDBHeader;
    procedure SaveDBHeader(PerformExternalAppUpdateCheck: boolean = True);
    function GetDbHeader: PABSDBHeader;

    procedure LoadCryptoHeader;
    procedure SaveCryptoHeader;

    procedure LoadLockedBytes;
    procedure SaveLockedBytes;

    function GetPassword: PABSPassword;
    function GetEncrypted: Boolean;
    function GetIsOpened: Boolean;
    function IsFileReadOnly(DatabaseFileName: string; var MultiUser: Boolean): Boolean;
    function GetPageOffset(PageNo: TABSPageNo): Int64;
    procedure OpenFileForDesignTime;
    procedure CloseFileForDesignTime;
   protected
    function GetPageCount: TABSPageNo; override;

    function IsSafeNotToSyncPage(SessionID: TABSSessionID; Page: TABSPage): Boolean; override;
    procedure UpdatePageTableState(SessionID: TABSSessionID; Page: TABSPage); override;
   public
    procedure ReadPageRegion(var Buffer; PageNo: TABSPageNo; Offset, Count: Word);
    procedure WritePageRegion(const Buffer; PageNo: TABSPageNo; Offset, Count: Word);

    procedure WriteEmptyPage(PageNo: TABSPageNo);
    procedure InternalAddPage(aPage: TABSPage); override;
    procedure InternalRemovePage(PageNo: TABSPageNo); override;
    function InternalReadPage(aPage: TABSPage): Boolean; override;
    procedure InternalWritePage(aPage: TABSPage); override;
    function InternalReadPageState(PageNo: Integer): Integer;
    procedure InternalWritePageState(PageNo: Integer; PageState: Integer);

    function GetPage(SessionID: TABSSessionID; PageNo: TABSPageNo;
                     PageType: TABSPageTypeID; SynchronizeAllowed: Boolean = True): TABSPage; override;

    procedure RemovePage(SessionID: TABSSessionID; PageNo: TABSPageNo); override;

    // lock Free Space Manager byte
    function LockFreeSpaceManager: Boolean;
    // unlock Free Space Manager byte
    function UnlockFreeSpaceManager: Boolean;
    // lock Free Space Manager byte
    function LockTables: Boolean;
    // unlock Free Space Manager byte
    function UnlockTables: Boolean;
    function LockDBHeader: Boolean;
    function UnlockDBHeader: Boolean;
    // LastObjectID
    function LockLastObjectID: Boolean;
    function UnlockLastObjectID: Boolean;

    // Lock Byte (return TRUE if success)
    function LockPageByte(PageNo: TABSPageNo; Offset: Word): Boolean;
    // Unlock Byte
    function UnlockPageByte(PageNo: TABSPageNo; Offset: Word): Boolean;
    // return True if byte is locked
    function IsPageByteLocked(PageNo: TABSPageNo; Offset: Word): Boolean;
    // return True if any byte of region is locked
    function IsPageRegionLocked(PageNo: TABSPageNo; Offset: Word; Count: Word): Boolean;
   public
    constructor Create;
    destructor Destroy; override;
    procedure CreateAndOpenDatabase(
                              DatabaseFileName: string;
                              Password:         TABSPassword;
                              PageSize:         Word = DefaultPageSize;
                              ExtentPageCount:  Word = DefaultExtentPageCount
                              );
    procedure OpenDatabase(
                DatabaseFileName: string;
                Password:         TABSPassword;
                var ReadOnly:     Boolean;
                var RepairNeeded: Boolean;
                Exclusive:        Boolean;
                var aMultiUser:    Boolean
                          );
    procedure CloseDatabase;
    procedure TruncateDatabase;
    // extend file by number of pages specified by PageCount
    procedure ExtendFile(PageCount: TABSPageNo);
    // Truncate file by number of pages specified by PageCount
    procedure TruncateFile(PageCount: TABSPageNo);
    // Increment LastObjectID and return it
    function GetNextObjectID(TryCount: Integer=5; DelayMS: Integer=100): TABSLastObjectID;
    procedure InitObjectID(TryCount: Integer=5; DelayMS: Integer=100);
    procedure ApplyChanges(SessionID: TABSSessionID); override;

   public
    property DatabaseFile: TABSDatabaseFile read FDatabaseFile;
    property DBHeader: PABSDBHeader read GetDbHeader;
    property LockedBytes: TABSLockedBytes read FLockedBytes;
    property Password: PABSPassword read GetPassword;
    property IsOpened: Boolean read GetIsOpened;
    property OffsetToFirstPage: Int64 read FOffsetToFirstPage;
    property OffsetToLockedBytes: Int64 read FOffsetToLockedBytes;
    property FreeSpaceManager: TABSDatabaseFreeSpaceManager read FDatabaseFreeSpaceManager;
    property TablePagesCacheManager: TABSDiskTablePagesCacheManager read FTablePagesCacheManager;
    property Exclusive: Boolean read FExclusive;
    property Encrypted: Boolean read GetEncrypted;
  end; // TABSDiskPageManager


////////////////////////////////////////////////////////////////////////////////
//
// TABSInternalDBTransactedAccessFile
//
////////////////////////////////////////////////////////////////////////////////

  TABSInternalDBTransactedAccessFile = class(TObject)
   private
    LPageManager: TABSDiskPageManager;
    FStartPageNo: TABSPageNo;
    FPageTypeID:  TABSPageTypeID;
   private
    // SetStartPageNo
    procedure SetStartPageNo(StartPageNo: TABSPageNo);
    // raise if file is Closed
    procedure CheckFileOpened(OperationName: AnsiString);
    // return Count of File Pages
    function GetPageCountForDataSize(DataSize: Integer): Integer;
    // return Count of File Pages
    procedure GetPageNoAndOffsetForPosition(Position: Integer; var PagePosition: Integer; var Offset: word);
    // return real page No for file page (firstPageNo=0)
    function GoToPage(SessionID: TABSSessionID; PagePosition: TABSPageNo): TABSPageNo;
   public
    // clean file header
    procedure InitFileHeader(SessionID: TABSSessionID);
    // Constructor
    constructor Create(PageManager: TABSDiskPageManager; PageTypeID: TABSPageTypeID);
    // Destructor
    destructor Destroy; override;

    // Create file
    procedure CreateFile(SessionID: TABSSessionID);
    // Delete file. And free all file pages
    procedure DeleteFile(SessionID: TABSSessionID; StartPageNo: TABSPageNo = INVALID_PAGE_NO);
    // Open file (reading file header)
    procedure OpenFile(StartPageNo: TABSPageNo);

    // Set File Size
    procedure SetFileSize(SessionID: TABSSessionID;
                            NewSize: Integer; DecompressedSize: Integer;
                            CompressionAlgorithm: TABSCompressionAlgorithm);
    // Get File Size
    procedure GetFileSize(SessionID: TABSSessionID; var Size: Integer;
                          var DecompressedSize: Integer;
                          var CompressionAlgorithm: TABSCompressionAlgorithm;
                          var FileWasChanged: Boolean;
                          SyncronizeAllowed: Boolean);
    function GetSize(SessionID: TABSSessionID): Integer;

    // Read File Data
    procedure ReadFile(SessionID: TABSSessionID; var Buffer; const Count: Integer; SynchronizeAllowed: Boolean = true);
    // Write File Data
    procedure WriteFile(SessionID: TABSSessionID; const Buffer; const Count: Integer;
                        const Algorithm: TABSCompressionAlgorithm = acaNone;
                        const CompressionMode: Integer = 0);

    function LockFile: Boolean;
    function UnlockFile: Boolean;
   public
    property PageManager: TABSDiskPageManager read LPageManager;
    property StartPageNo: TABSPageNo read FStartPageNo;
  end;// TABSInternalDBTransactedAccessFile



////////////////////////////////////////////////////////////////////////////////
//
// TABSInternalDBDirectAccessFile
//
////////////////////////////////////////////////////////////////////////////////

  TABSInternalDBDirectAccessFile = class(TObject)
   private
    LPageManager: TABSDiskPageManager;
    FStartPageNo: TABSPageNo;
    FPageTypeID:  TABSPageTypeID;
    FFileSize: Integer;
    FFilePages: TABSIntegerArray;

   private
    // SetStartPageNo
    procedure SetStartPageNo(StartPageNo: TABSPageNo);
    procedure ReadPageHeader(PageNo: TABSPageNo; var PageHeader: TABSDiskPageHeader;
                                             SkipFirstByte: Boolean = False);
    // raise if file is Closed
    procedure CheckFileOpened(OperationName: AnsiString);
    // return Count of File Pages
    function GetPageCountForDataSize(DataSize: Integer): Integer;
    // return Count of File Pages
    procedure GetPageNoAndOffsetForPosition(Position: Integer; var PagePosition: Integer; var Offset: word);
    procedure ReadPageList;
    // return real page No for file page (firstPageNo=0)
    function GoToPage(PagePosition: TABSPageNo): TABSPageNo;
    procedure InternalSeek(FileOffset: Integer; out PageNo: TABSPageNo; out PageOffset: Word);
   public
    // Constructor
    constructor Create(PageManager: TABSDiskPageManager; PageTypeID: TABSPageTypeID);
    // Destructor
    destructor Destroy; override;

    // Create file
    procedure CreateFile(Size: Integer);
    // Delete file. And free all file pages
    procedure DeleteFile(StartPageNo: TABSPageNo = INVALID_PAGE_NO);
    // Open file (reading file header)
    procedure OpenFile(StartPageNo: TABSPageNo);

    // Get File Size
    function GetSize: Integer;

    // direct (without sessions and transactions) Read buffer from file
    procedure ReadBuffer(var Buffer; const Count: Integer; const Position: Integer = -1);
    // direct (without sessions and transactions) Write buffer from file
    procedure WriteBuffer(const Buffer; const Count: Integer; const Position: Integer = -1);

    function LockFile: Boolean;
    function UnlockFile: Boolean;
    function LockByte(ByteNo: Integer): Boolean;
    function UnlockByte(ByteNo: Integer): Boolean;
    function IsByteLocked(ByteNo: Integer): Boolean;
    function IsRegionLocked(ByteNo, ByteCount: Integer): Boolean;
   public
    property PageManager: TABSDiskPageManager read LPageManager;
    property StartPageNo: TABSPageNo read FStartPageNo;
  end;// TABSInternalDBDirectAccessFile



////////////////////////////////////////////////////////////////////////////////
//
// TABSActiveSessionsFile
//
////////////////////////////////////////////////////////////////////////////////

  TABSActiveSessionsFile = class(TObject)
   private
    LPageManager:     TABSDiskPageManager;
    FHandle:          TABSInternalDBDirectAccessFile;
    FMaxSessionCount: Integer;

    function GetStartPageNo: TABSPageNo;
   public
    constructor Create(PageManager: TABSPageManager);
    destructor Destroy; override;
    function CreateFile(aMaxSessionCount: Integer): TABSPageNo;
    procedure OpenFile(aStartPageNo: TABSPageNo);
    procedure CloseFile;
    function MultiUserConnect: TABSSessionID;
    procedure MultiUserDisconnect(SessionID: TABSSessionID);
    function SingleUserConnect: Boolean;
    procedure SingleUserDisconnect;
    function GetDBFileConnectionsCount: Integer;

    property StartPageNo: TABSPageNo read GetStartPageNo;
    property MaxSessionCount: Integer read FMaxSessionCount;
  end;// TABSActiveSessionsFile



////////////////////////////////////////////////////////////////////////////////
//
// TABSTableListFile
//
////////////////////////////////////////////////////////////////////////////////

  TABSTableListFile = class(TObject)
   private
    LPageManager: TABSDiskPageManager;
    FHandle:      TABSInternalDBTransactedAccessFile;
    FTableList: array of TABSTableListItem;

    function GetStartPageNo: TABSPageNo;
    function GetTableIndex(TableName: AnsiString): Integer;
   public
    constructor Create(PageManager: TABSPageManager);
    destructor Destroy; override;

    function CreateFile: TABSPageNo;
    procedure OpenFile(aStartPageNo: TABSPageNo);
    procedure CloseFile;

    procedure Load;
    procedure Save;

    procedure AddTable(
           TableID: TABSTableID;
           TableName: AnsiString;
           MetadataFilePageNo,
           MostUpdatedFilePageNo,
           LocksFilePageNo: TABSPageNo
                         );
    procedure RemoveTable(TableName: AnsiString);
    procedure OpenTable(
           TableName: AnsiString;
           out TableID: TABSTableID;
           out MetadataFilePageNo: TABSPageNo;
           out MostUpdatedFilePageNo: TABSPageNo;
           out LocksFilePageNo: TABSPageNo
                         );
    procedure RenameTable(TableName, NewTableName: AnsiString);
    function TableExists(TableName: AnsiString): Boolean;
    procedure GetTablesList(List: TStrings);

   public
    property StartPageNo: TABSPageNo read GetStartPageNo;
  end;// TABSTableListFile



////////////////////////////////////////////////////////////////////////////////
//
// TABSTableLocksFile
//
////////////////////////////////////////////////////////////////////////////////

  TABSTableLocksFile = class(TObject)
   private
    LPageManager:     TABSDiskPageManager;
    FHandle:          TABSInternalDBDirectAccessFile;
    FMaxSessionCount: Integer;

    function GetStartPageNo: TABSPageNo;
    function GetTableLockByteNo(
                    SessionID: TABSSessionID; LockType: TABSLockType): Integer;
    function GetRecordLockByteNo(SessionID: TABSSessionID): Integer;
    function GetRecordLockRecordIDByteNo(SessionID: TABSSessionID): Integer;
   public
    constructor Create(PageManager: TABSPageManager);
    destructor Destroy; override;
    function CreateFile(aMaxSessionCount: Integer): TABSPageNo;
    procedure DeleteFile;
    procedure OpenFile(aStartPageNo: TABSPageNo);
    procedure CloseFile;

    function LockTable(SessionID: TABSSessionID; LockType: TABSLockType): Boolean;
    function UnlockTable(SessionID: TABSSessionID; LockType: TABSLockType): Boolean;
    function IsTableLockedByAnyOtherSession(SessionID: TABSSessionID;
                                            LockType: TABSLockType): Boolean;
    function IsTableLockAllowed(SessionID: TABSSessionID;
                                LockType: TABSLockType;
                                AllowXIRWAfterSIRW: Boolean = True): Boolean;

    function LockRecord(
                        SessionID:  TABSSessionID;
                        RecordID:   TABSRecordID
                       ): Boolean;
    function UnlockRecord(
                          SessionID:  TABSSessionID;
                          RecordID:   TABSRecordID
                         ): Boolean;
    function IsRecordLockedByAnyOtherSession(
                          SessionID:  TABSSessionID;
                          RecordID:   TABSRecordID
                         ): Boolean;
    function LockFile: Boolean;
    function UnlockFile: Boolean;

    property MaxSessionCount: Integer read FMaxSessionCount;
    property StartPageNo: TABSPageNo read GetStartPageNo;
  end;// TABSTableLocksFile



////////////////////////////////////////////////////////////////////////////////
//
// TABSSystemDirectory
//
////////////////////////////////////////////////////////////////////////////////


  TABSSystemDirectory = class(TObject)
   private
    LPageManager: TABSDiskPageManager;
    FHandle:      TABSInternalDBTransactedAccessFile;

    FFileList:    array of TABSSystemDirectoryListItem;
   public
    constructor Create(PageManager: TABSDiskPageManager);
    destructor Destroy; override;
    procedure CreateDirectory;
    procedure LoadDirectory;
    procedure SaveDirectory;
    procedure CreateFile(FileType: TABSDBFileType; FirstPageNo: TABSPageNo);
    function GetFileFirstPageNo(FileType: TABSDBFileType): TABSPageNo;
   public
    property PageManager: TABSDiskPageManager read LPageManager;
  end;// TABSSystemDirectory


////////////////////////////////////////////////////////////////////////////////
//
// TABSTableLockList
//
////////////////////////////////////////////////////////////////////////////////

  TABSTableLock = record
    LockType:         TABSLockType;
    LocksFilePageNo:  TABSPageNo;
    LockCount:        Integer;
    HasPhysicalLock:  Boolean;
    IsXIRWAfterSIRWAllowed: Boolean;
  end;
  PABSTableLock = ^TABSTableLock;

  TABSTableLockList = class(TObject)
   private
     FLockList: TList;

     function FindLock(LockType: TABSLockType; LocksFilePageNo: TABSPageNo;
                       var ItemNo: Integer): Boolean; overload;
     function FindLock(LockType: TABSLockType; LocksFilePageNo: TABSPageNo; IsXIRWAfterSIRWAllowed: Boolean;
                       var ItemNo: Integer): Boolean; overload;
     // is lock1 stronger than lock2
     function IsLockStronger(LockType1, LockType2: TABSLockType): Boolean;
   public
     constructor Create;
     destructor Destroy; override;
     procedure AddLock(LockType: TABSLockType; LocksFilePageNo: TABSPageNo; HasPhysicalLock: Boolean; IsXIRWAfterSIRWAllowed: Boolean = True);
     procedure RemoveLock(LockType: TABSLockType; LocksFilePageNo: TABSPageNo;
                          var HasPhysicalLock: Boolean; IgnoreCount: Boolean);
     function LockExists(LockType: TABSLockType; LocksFilePageNo: TABSPageNo): Boolean; overload;
     function LockExists(LockType: TABSLockType; LocksFilePageNo: TABSPageNo; IsXIRWAfterSIRWAllowed: Boolean): Boolean;overload;
     function StrongerLockExists(LockType: TABSLockType; LocksFilePageNo: TABSPageNo): Boolean;
     procedure SetPhysicalLock(ItemNo: Integer);
     function IsWeakerNonPhysicalLock(ItemNo: Integer; LockType: TABSLockType): Boolean;
  end;// TABSTableLockList


////////////////////////////////////////////////////////////////////////////////
//
// TABSDatabaseTableLockManager
//
////////////////////////////////////////////////////////////////////////////////

  TABSDatabaseTableLockManager = class(TObject)
   private
     FSessionLockList: TList;
     FMaxSessionCount: Integer;
     FCSect: TRTLCriticalSection;
     LPageManager: TABSPageManager;

     procedure Lock;
     procedure Unlock;
     function AddSIRWLocksToULocks(SessionID: TABSSessionID): Boolean;
     function SetPhysicalLockForWeakerLocks(SessionID: TABSSessionID; LockType: TABSLockType;
                        TableLocksFile: TABSTableLocksFile): Boolean;

   public
     constructor Create(MaxSessionCount: Integer; PageManager: TABSPageManager);
     destructor Destroy; override;
     function LockTable(SessionID: TABSSessionID; LockType: TABSLockType;
                        TableLocksFile: TABSTableLocksFile;
                        aTryCount: Integer;
                        aDelayMS:  Integer;
                        NoThreadLock: Boolean = False;
                        AllowXIRWAfterSIRW: Boolean = True): Boolean;
     function UnlockTable(SessionID: TABSSessionID; LockType: TABSLockType;
                        TableLocksFile: TABSTableLocksFile;
                        IgnoreIfNoLock: Boolean=False; IgnoreCount: Boolean=False): Boolean;
     function LockRecord(SessionID: TABSSessionID;
                        TableLocksFile: TABSTableLocksFile;
                        RecordID: TABSRecordID;
                        aTryCount: Integer;
                        aDelayMS:  Integer): Boolean;
     function UnlockRecord(SessionID: TABSSessionID;
                        TableLocksFile: TABSTableLocksFile;
                        RecordID: TABSRecordID): Boolean;
     function IsRecordLocked(SessionID: TABSSessionID;
                        TableLocksFile: TABSTableLocksFile;
                        RecordID: TABSRecordID): Boolean;
     function AddRWLocksBeforeCommit(SessionID: TABSSessionID): Boolean;
     function ClearTransactionLocks(SessionID: TABSSessionID): Boolean;
  end;// TABSDatabaseTableLockManager



type
  TBooleanFunctionForTimeOutCall = function: Boolean of object;

  // convert PageTypeID to String (for exceptions messages)
  function PageTypeToStr(PageType: TABSPageTypeID): AnsiString;
  function TryUsingTimeOut(Func: TBooleanFunctionForTimeOutCall; TryCount: Integer; DelayMS: Integer): Boolean;
  procedure CheckPageType(FoundType, WantedType: TABSPageTypeID; ErrorCode: Integer);

  // encrypts specified buffer
  function ABSInternalEncryptBuffer(
                                      CryptoAlg:              TABSCryptoAlgorithm;
                                      inBuf:                  TAbsPByte;
                                      Size:                   Integer;
                                      Password:               AnsiString
                                    ): Boolean;
  // decrypts specified buffer
  function ABSInternalDecryptBuffer(
                                      CryptoAlg:              TABSCryptoAlgorithm;
                                      inBuf:                  TAbsPByte;
                                      Size:                   Integer;
                                      Password:               AnsiString
                                    ): Boolean;

function IsOSCriticalError: Boolean;

implementation

uses ABSLocalEngine, ABSTempEngine;

{$IFNDEF D6H}
function RandomRange(const AFrom, ATo: Integer): Integer;
begin
  if AFrom > ATo then
    Result := Random(AFrom - ATo) + ATo
  else
    Result := Random(ATo - AFrom) + AFrom;
end;
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskDatabaseData
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// OpenDatabase
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.OpenDatabase(Session: TABSBaseSession; Exclusive: Boolean;
                                            var RepairNeeded: Boolean);
begin
  Lock;
  try
    FPageManager := TABSDiskPageManager.Create;
    try
      FMultiUser := Session.MultiUser;
      TABSDiskPageManager(FPageManager).OpenDatabase(DatabaseName, FPassword,
                       FReadOnly, RepairNeeded, Exclusive, FMultiUser);
      FPassword := TABSDiskPageManager(FPageManager).Password^;
      FPageSize := TABSDiskPageManager(FPageManager).PageSize;
      FPageCountInExtent := TABSDiskPageManager(FPageManager).DBHeader.PageCountInExtent;

      FSystemDir := TABSSystemDirectory.Create(TABSDiskPageManager(FPageManager));
      FSystemDir.LoadDirectory;
      FActiveSessionsFile := TABSActiveSessionsFile.Create(FPageManager);
      FActiveSessionsFile.OpenFile(FSystemDir.GetFileFirstPageNo(dbftActiveSessionsList));
      FMaxSessionCount := FActiveSessionsFile.MaxSessionCount;
      FTableListFile := TABSTableListFile.Create(TABSDiskPageManager(FPageManager));
      FTableListFile.OpenFile(FSystemDir.GetFileFirstPageNo(dbftTablesList));
      FTableListFile.Load;

      FTableLockManager := TABSDatabaseTableLockManager.Create(FMaxSessionCount, FPageManager);
    except
      CloseDatabase;
      raise;
    end;
  finally
   Unlock;
  end;
end;// OpenDatabase


//------------------------------------------------------------------------------
// CloseDatabase
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.CloseDatabase;
begin
  Lock;
  try
    if (FSystemDir <> nil) then
      FreeAndNil(FSystemDir);
    if (FTableListFile <> nil) then
      FreeAndNil(FTableListFile);
    if (FActiveSessionsFile <> nil) then
      FreeAndNil(FActiveSessionsFile);
    if (FTableLockManager <> nil) then
      FreeAndNil(FTableLockManager);
    if (FPageManager <> nil) then
     begin
      TABSDiskPageManager(FPageManager).CloseDatabase;
      FreeAndNil(FPageManager);
     end;
  finally
   Unlock;
  end;
end;// CloseDatabase


//------------------------------------------------------------------------------
// GetPassword
//------------------------------------------------------------------------------
function TABSDiskDatabaseData.GetPassword: PABSPassword;
begin
 Result := @Fpassword;
end;//GetPassword


//------------------------------------------------------------------------------
// GetEncrypted
//------------------------------------------------------------------------------
function TABSDiskDatabaseData.GetEncrypted: Boolean;
begin
  Result := TABSDiskPageManager(FPageManager).Encrypted;
end;// GetEncrypted


//------------------------------------------------------------------------------
// AddTable
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.AddTable(
       TableID: TABSTableID;
       TableName: AnsiString;
       MetadataFilePageNo, MostUpdatedFilePageNo, LocksFilePageNo: TABSPageNo
                     );
begin
  Lock;
  try
    FTableListFile.AddTable(TableID, TableName,
                            MetadataFilePageNo, MostUpdatedFilePageNo,
                            LocksFilePageNo);
    FTableListFile.Save;
  finally
   Unlock;
  end;
end;// AddTable


//------------------------------------------------------------------------------
// OpenTable
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.OpenTable(TableName: AnsiString;
  out TableID: TABSTableID; out MetadataFilePageNo, MostUpdatedFilePageNo,
  LocksFilePageNo: TABSPageNo);
begin
  Lock;
  try
    if (FTableListFile = nil) then
      raise EABSException.Create(20129, ErrorANilPointer);
    FTableListFile.OpenTable(TableName, TableID,
                            MetadataFilePageNo, MostUpdatedFilePageNo,
                            LocksFilePageNo);
  finally
   Unlock;
  end;
end;// OpenTable


procedure TABSDiskDatabaseData.RemoveTable(TableName: AnsiString);
begin
  Lock;
  try
    if (FTableListFile = nil) then
      raise EABSException.Create(20130, ErrorANilPointer);
    FTableListFile.RemoveTable(TableName);
    FTableListFile.Save;
  finally
    Unlock;
  end;
end;

procedure TABSDiskDatabaseData.RenameTable(TableName,
  NewTableName: AnsiString);
begin
  Lock;
  try
    if (FTableListFile = nil) then
      raise EABSException.Create(20131, ErrorANilPointer);
    FTableListFile.RenameTable(TableName, NewTableName);
    FTableListFile.Save;
  finally
   Unlock;
  end;
end;


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDiskDatabaseData.Create;
begin
  inherited Create;
  FPageManager := nil;
  FSystemDir := nil;
  FActiveSessionsFile := nil;
  FTableListFile := nil;
  FTableLockManager := nil;
  FSingleUserConnected := False;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDiskDatabaseData.Destroy;
begin
  CloseDatabase;
  inherited Destroy;
end;// Destroy


//------------------------------------------------------------------------------
// create table data
//------------------------------------------------------------------------------
function TABSDiskDatabaseData.CreateTableData(Cursor: TABSCursor): TABSTableData;
begin
  Lock;
  try
    Result := TABSDiskTableData.Create(Self);
    Result.TableName := Cursor.TableName;
    FTableDataList.Add(Result);
  finally
   Unlock;
  end;
end;// CreateTableData


//------------------------------------------------------------------------------
// CreateDatabase
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.CreateDatabase;
begin
  Lock;
  try
    FPageManager := TABSDiskPageManager.Create;
    try
    TABSDiskPageManager(FPageManager).CreateAndOpenDatabase(DatabaseName,
                                                            FPassword,
                                                            FPageSize,
                                                            FPageCountInExtent);
      FSystemDir := TABSSystemDirectory.Create(TABSDiskPageManager(FPageManager));
      FActiveSessionsFile := TABSActiveSessionsFile.Create(FPageManager);
      FTableListFile := TABSTableListFile.Create(TABSDiskPageManager(FPageManager));
      try
        FSystemDir.CreateDirectory;
        FSystemDir.CreateFile(dbftActiveSessionsList, FActiveSessionsFile.CreateFile(MaxSessionCount));
        FSystemDir.CreateFile(dbftTablesList, FTableListFile.CreateFile);
        FSystemDir.SaveDirectory;
        FPageManager.ApplyChanges(SYSTEM_SESSION_ID);
      finally
      FreeAndNil(FTableListFile);
      FreeAndNil(FActiveSessionsFile);
      FreeAndNil(FSystemDir);
      end;
    finally
      TABSDiskPageManager(FPageManager).CloseDatabase;
      FPageManager.Free;
      FPageManager := nil;
    end;
  finally
   Unlock;
  end;
end;// CreateDatabase


//------------------------------------------------------------------------------
// ConnectSession
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.ConnectSession(Session: TABSBaseSession);
var
  RepairNeeded: Boolean;
begin
  Lock;
  try
    if (FPageManager = nil) then
      begin
        OpenDatabase(Session, Session.Exclusive, RepairNeeded);
        Session.RepairNeeded := RepairNeeded;
        Session.MultiUser := FMultiUser;
      end;

{$IFDEF FILE_SERVER_VERSION}
    if (Session.MultiUser <> FMultiUser) then
      raise EABSException.Create(20235, ErrorAMultiUserOptionsConflict);
    if (Session.MultiUser) then
      Session.SessionID := FActiveSessionsFile.MultiUserConnect
    else
{$ENDIF}
      begin
        Session.SessionID := 0;
        if (not FSingleUserConnected) then
          begin
            FSingleUserConnected := FActiveSessionsFile.SingleUserConnect;
            if (not FSingleUserConnected) then
              FReadOnly := True;
          end;
      end;
    FSessionList.Add(Session);
  finally
    Unlock;
  end;
end;// ConnectSession


//------------------------------------------------------------------------------
// DisconnectSession
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.DisconnectSession(Session: TABSBaseSession);
begin
  Lock;
  try
    try
{$IFDEF FILE_SERVER_VERSION}
      if (FSessionList.Count > 0) then
        if (Session.MultiUser) then
          FActiveSessionsFile.MultiUserDisconnect(Session.SessionID)
        else
{$ENDIF}
          if ((FSingleUserConnected) and (FSessionList.Count = 1)) then
            FActiveSessionsFile.SingleUserDisconnect;
    except
      if (not IsDesignMode) then
        raise;
    end;
    FSessionList.Remove(Session);
    if (FSessionList.Count = 0) then
      begin
        if (Session.InTransaction) then
          Session.Rollback;
        CloseDatabase;
      end;
  finally
    Unlock;
  end;
end;// DisconnectSession


//------------------------------------------------------------------------------
// FreeIfNoSessionsConnected
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.FreeIfNoSessionsConnected;
var
  DestroyIt: Boolean;
begin
  DestroyIt := False;
  Lock;
  try
   DestroyIt := (FSessionList.Count = 0);
  finally
   Unlock;
   if (DestroyIt) then
     Free;
  end;
end;// FreeIfNoSessionsConnected


//------------------------------------------------------------------------------
// GetTablesList
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.GetTablesList(List: TStrings);
begin
  Lock;
  try
    FTableListFile.GetTablesList(List);
  finally
   Unlock;
  end;
end;// GetTablesList


//------------------------------------------------------------------------------
// TruncateDatabase
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.TruncateDatabase;
begin
  TABSDiskPageManager(FPageManager).TruncateDatabase;
end;//TruncateDatabase


//------------------------------------------------------------------------------
// return Count of connections to Database File or -1 if it's openned in Exclusive
//------------------------------------------------------------------------------
function TABSDiskDatabaseData.GetDBFileConnectionsCount: Integer;
begin
  Result := FActiveSessionsFile.GetDBFileConnectionsCount;
end;//GetDBFileConnectionsCount


//------------------------------------------------------------------------------
// lock tables (virtual object)
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.LockTables;
begin
  if (not TryUsingTimeOut(TABSDiskPageManager(FPageManager).LockTables,
         LockTablesRetries, LockTablesDelay)) then
      raise EABSException.Create(20210, ErrorADatabaseTablesLocked);
end;


//------------------------------------------------------------------------------
// unlock tables (virtual object)
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.UnlockTables;
begin
  if (not TABSDiskPageManager(FPageManager).UnlockTables) then
      raise EABSException.Create(20211, ErrorACannotUnlockDatabaseTables);
end;


//------------------------------------------------------------------------------
// Commit
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.Commit(SessionID: TABSSessionID; DoFlushBuffers: Boolean=True);

procedure DoCommit;
begin
  inherited Commit(SessionID, DoFlushBuffers);
  if (DoFlushBuffers) then
    TABSDiskPageManager(PageManager).DatabaseFile.FlushFileBuffers;
end;

begin
  Lock;
  try
{$IFDEF FILE_SERVER_VERSION}
    if (FMultiUser) then
      begin
        if (FTableLockManager.AddRWLocksBeforeCommit(SessionID)) then
          begin
            DoCommit;
            FTableLockManager.ClearTransactionLocks(SessionID);
          end
        else
          raise EABSException.Create(20233, ErrorACommitLocksFailed);
      end
    else
{$ENDIF}
      DoCommit;
  finally
   Unlock;
  end;
end;// Commit


//------------------------------------------------------------------------------
// Rollback
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.Rollback(SessionID: TABSSessionID);
begin
  Lock;
  try
{$IFDEF FILE_SERVER_VERSION}
    if (FMultiUser) then
      FTableLockManager.ClearTransactionLocks(SessionID);
{$ENDIF}
    inherited Rollback(SessionID);
  finally
   Unlock;
  end;
end;// Rollback


//------------------------------------------------------------------------------
// FlushBuffers
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.FlushBuffers;
begin
  TABSDiskPageManager(PageManager).DatabaseFile.FlushFileBuffers;
end;// FlushBuffers


//------------------------------------------------------------------------------
// GetNewObjectId
//------------------------------------------------------------------------------
function TABSDiskDatabaseData.GetNewObjectId: TABSObjectID;
begin
  Lock;
  try
    Result := TABSDiskPageManager(FPageManager).GetNextObjectID;
  finally
   Unlock;
  end;
end;// GetNewObjectId


//------------------------------------------------------------------------------
// GetSuppressDBHeaderErrors
//------------------------------------------------------------------------------
function TABSDiskDatabaseData.GetSuppressDBHeaderErrors: Boolean;
begin
  Result := TABSDiskPageManager(FPageManager).FDatabaseFreeSpaceManager.SuppressDBHeaderErrors;
end;// GetSuppressDBHeaderErrors


//------------------------------------------------------------------------------
// SetSuppressDBHeaderErrors
//------------------------------------------------------------------------------
procedure TABSDiskDatabaseData.SetSuppressDBHeaderErrors(Value: boolean);
begin
  TABSDiskPageManager(FPageManager).FDatabaseFreeSpaceManager.SuppressDBHeaderErrors := Value;
end;// SetSuppressDBHeaderErrors




////////////////////////////////////////////////////////////////////////////////
//
// TABSSmallRecordPage
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// FindUnusedRecordSlot (bit=1 - used slot, bit=0 - free record slot)
//------------------------------------------------------------------------------
function TABSSmallRecordPage.FindUnusedRecordSlot(var SlotNo: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FMaxRecordsOnPage-1 do
   if (not CheckNullFlag(i, LPage.PageData)) then
    begin
      SlotNo := i;
      Result := True;
      break;
    end;
end;// FindUnusedRecordSlot


//------------------------------------------------------------------------------
// GetRecordCount
//------------------------------------------------------------------------------
function TABSSmallRecordPage.GetRecordCount: TABSRecordNo;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FMaxRecordsOnPage-1 do
   if (CheckNullFlag(i, LPage.PageData)) then
     Inc(Result);
end;// GetRecordCount


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSSmallRecordPage.Create(Page: TABSPage; RecordBufferSize: Integer;
                   MaxRecordsOnPage: Integer);
begin
  LPage := Page;
  FRecordBufferSize := RecordBufferSize;
  FMaxRecordsOnPage := MaxRecordsOnPage;
  FRecordDataOffset := FMaxRecordsOnPage div 8;
  if ((FMaxRecordsOnPage mod 8) > 0) then
   Inc(FRecordDataOffset);
  if (LPage.PageDataSize < FRecordDataOffset + RecordBufferSize * FMaxRecordsOnPage) then
    raise EABSException.Create(20140, ErrorAInvalidNumberOfRecordsOnPage);
end;// Create


//------------------------------------------------------------------------------
// AddRecord
//------------------------------------------------------------------------------
procedure TABSSmallRecordPage.AddRecord(RecordBuffer: TAbsPByte; var RecordID: TABSRecordID);
var
  SlotNo: Integer;
begin
  if (not FindUnusedRecordSlot(SlotNo)) then
    raise EABSException.Create(20141, ErrorACannotAddRecordOnPage);
  SetNullFlag(True, SlotNo, LPage.PageData);
  Move(RecordBuffer^, (LPage.PageData+FRecordDataOffset+SlotNo*FRecordBufferSize)^,
       FRecordBufferSize);
  LPage.IsDirty := True;
  RecordID.PageNo := LPage.PageNo;
  RecordID.PageItemNo := SlotNo;
end;// AddRecord


//------------------------------------------------------------------------------
// UpdateRecord
//------------------------------------------------------------------------------
function TABSSmallRecordPage.UpdateRecord(RecordBuffer: TAbsPByte; RecordID: TABSRecordID): Boolean;
begin
  Result := CheckNullFlag(RecordID.PageItemNo, LPage.PageData);
  if (Result) then
    begin
      Move(RecordBuffer^, (LPage.PageData+FRecordDataOffset+RecordID.PageItemNo*FRecordBufferSize)^,
           FRecordBufferSize);
      LPage.IsDirty := True;
    end;
end;// UpdateRecord


//------------------------------------------------------------------------------
// DeleteRecord
//------------------------------------------------------------------------------
function TABSSmallRecordPage.DeleteRecord(RecordID: TABSRecordID): Boolean;
begin
  Result := CheckNullFlag(RecordID.PageItemNo, LPage.PageData);
  if (Result) then
    begin
      SetNullFlag(False, RecordID.PageItemNo, LPage.PageData);
      LPage.IsDirty := True;
    end;
end;// DeleteRecord


//------------------------------------------------------------------------------
// GetRecordBuffer
//------------------------------------------------------------------------------
function TABSSmallRecordPage.GetRecordBuffer(RecordID: TABSRecordID; RecordBuffer: TAbsPByte): Boolean;
begin
  Result := CheckNullFlag(RecordID.PageItemNo, LPage.PageData);
  if (Result) then
   Move((LPage.PageData+FRecordDataOffset+RecordID.PageItemNo*FRecordBufferSize)^,
        RecordBuffer^, FRecordBufferSize);
end;// GetRecordBuffer


//------------------------------------------------------------------------------
// GetFirstRecordID
//------------------------------------------------------------------------------
procedure TABSSmallRecordPage.GetFirstRecordID(var RecordID: TABSRecordID);
var
  i: Integer;
  bFound: Boolean;
begin
  RecordID.PageNo := LPage.PageNo;
  bFound := False;
  for i := 0 to FMaxRecordsOnPage-1 do
   if (CheckNullFlag(i, LPage.PageData)) then
    begin
      RecordID.PageItemNo := i;
      bFound := True;
      break;
    end;
  if (not bFound) then
    raise EABSException.Create(20143, ErrorARecordNotFoundOnSmallRecordPage, [LPage.PageNo, RecordCount]);
end;// GetFirstRecordID


//------------------------------------------------------------------------------
// GetLastRecordID
//------------------------------------------------------------------------------
procedure TABSSmallRecordPage.GetLastRecordID(var RecordID: TABSRecordID);
var
  i: Integer;
  bFound: Boolean;
begin
  RecordID.PageNo := LPage.PageNo;
  bFound := False;
  for i := FMaxRecordsOnPage-1 downto 0 do
   if (CheckNullFlag(i, LPage.PageData)) then
    begin
      RecordID.PageItemNo := i;
      bFound := True;
      break;
    end;
  if (not bFound) then
    raise EABSException.Create(20144, ErrorARecordNotFound);
end;// GetLastRecordID


//------------------------------------------------------------------------------
// GetNextRecordID
//------------------------------------------------------------------------------
function TABSSmallRecordPage.GetNextRecordID(var RecordID: TABSRecordID): Boolean;
var
  i: Integer;
  bFound: Boolean;
begin
  RecordID.PageNo := LPage.PageNo;
  bFound := False;
  for i := RecordID.PageItemNo+1 to FMaxRecordsOnPage-1 do
   if (CheckNullFlag(i, LPage.PageData)) then
    begin
      RecordID.PageItemNo := i;
      bFound := True;
      break;
    end;
  Result := bFound;
end;// GetNextRecordID


//------------------------------------------------------------------------------
// GetPriorRecordID
//------------------------------------------------------------------------------
function TABSSmallRecordPage.GetPriorRecordID(var RecordID: TABSRecordID): Boolean;
var
  i: Integer;
  bFound: Boolean;
begin
  RecordID.PageNo := LPage.PageNo;
  bFound := False;
  for i := RecordID.PageItemNo-1 downto 0 do
   if (CheckNullFlag(i, LPage.PageData)) then
    begin
      RecordID.PageItemNo := i;
      bFound := True;
      break;
    end;
  Result := bFound;
end;// GetPriorRecordID


//------------------------------------------------------------------------------
// GetRecordID
//------------------------------------------------------------------------------
procedure TABSSmallRecordPage.GetRecordID(RecNoOnPage: Integer; var RecordID: TABSRecordID);
var
  i: Integer;
  curNo: Integer;
  bFound: Boolean;
begin
  RecordID.PageNo := LPage.PageNo;
  bFound := False;
  curNo := 0;
  for i := 0 to FMaxRecordsOnPage-1 do
   if (CheckNullFlag(i, LPage.PageData)) then
    begin
      if (curNo = RecNoOnPage) then
       begin
        RecordID.PageItemNo := i;
        bFound := True;
        break;
       end;
      Inc(curNo);
    end;
  if (not bFound) then
    raise EABSException.Create(20146, ErrorARecordNotFound);
end;// GetRecordID


//------------------------------------------------------------------------------
// GetRecNoOnPage
//------------------------------------------------------------------------------
procedure TABSSmallRecordPage.GetRecNoOnPage(RecordID: TABSRecordID; var RecNoOnPage: Integer);
var
  i: Integer;
begin
  RecNoOnPage := 0;
  for i := 0 to RecordID.PageItemNo-1 do
   if (CheckNullFlag(i, LPage.PageData)) then
    Inc(RecNoOnPage);
end;// GetRecNoOnPage





////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskRecordManager
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// IsRecordPageValid
//------------------------------------------------------------------------------
function TABSDiskRecordManager.IsRecordPageValid(Page: TABSPage): Boolean;
begin
    Result := (TABSDiskPageManager(LPageManager).FDatabaseFreeSpaceManager.SuppressDBHeaderErrors) or
              (TABSDiskPageManager(LPageManager).DBHeader.Version < 2.99) or
              ((Page.PageHeader^.State <= LAST_VALID_PAGE_STATE) and
              (Page.PageHeader^.PageType = ptTableRecord) and
              (Page.PageHeader^.ObjectID = LTableData.FTableID));
end;// IsRecordPageValid


//------------------------------------------------------------------------------
// GetFirstRecord
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.GetFirstRecord(SessionID: TABSSessionID;
                         var NavigationInfo: TABSNavigationInfo);
var
  PageNo:     TABSPageNo;
  Page:       TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  NavigationInfo.GetRecordResult := grrError;
  case NavigationInfo.GetRecordMode of
    grmPrior:
      NavigationInfo.GetRecordResult := grrBOF;
    grmCurrent:
      NavigationInfo.GetRecordResult := grrError;
    grmNext:
     begin
      if (FRecordPageIndex.GetFirstRecordPage(SessionID, PageNo)) then
        begin
          Page := LPageManager.GetPage(SessionID, PageNo, ptAnyPage);
          try
            if (IsRecordPageValid(Page)) then
              begin
                RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize,
                                                         FMaxRecordsOnPage);
                try
                  RecordPage.GetFirstRecordID(NavigationInfo.RecordID);
                  if (NavigationInfo.RecordBuffer <> nil) then
                    begin
                      RecordPage.GetRecordBuffer(NavigationInfo.RecordID, FTempDiskRecordBuffer);
                      LFieldManager.DiskRecordBufferToMemRecordBuffer(FTempDiskRecordBuffer,
                                                        NavigationInfo.RecordBuffer);
                    end;
                  NavigationInfo.GetRecordResult := grrOK;
                  NavigationInfo.FirstPosition := False;
                  NavigationInfo.LastPosition := False;
                finally
                  RecordPage.Free;
                end;
              end;
          finally
            LPageManager.PutPage(Page);
          end;
        end;
     end;
  end;
end;// GetFirstRecord


//------------------------------------------------------------------------------
// GetLastRecord
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.GetLastRecord(SessionID: TABSSessionID;
                         var NavigationInfo: TABSNavigationInfo);
var
  PageNo:     TABSPageNo;
  Page:       TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  NavigationInfo.GetRecordResult := grrError;
  case NavigationInfo.GetRecordMode of
    grmPrior:
     begin
      if (FRecordPageIndex.GetLastRecordPage(SessionID, PageNo)) then
        begin
          Page := LPageManager.GetPage(SessionID, PageNo, ptAnyPage);
          try
            if (IsRecordPageValid(Page)) then
              begin
                RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize,
                                                         FMaxRecordsOnPage);
                try
                  RecordPage.GetLastRecordID(NavigationInfo.RecordID);
                  if (NavigationInfo.RecordBuffer <> nil) then
                    begin
                      RecordPage.GetRecordBuffer(NavigationInfo.RecordID, FTempDiskRecordBuffer);
                      LFieldManager.DiskRecordBufferToMemRecordBuffer(FTempDiskRecordBuffer,
                                                        NavigationInfo.RecordBuffer);
                    end;
                  NavigationInfo.GetRecordResult := grrOK;
                  NavigationInfo.FirstPosition := False;
                  NavigationInfo.LastPosition := False;
                finally
                  RecordPage.Free;
                end;
              end;
          finally
            LPageManager.PutPage(Page);
          end;
        end;
     end;
    grmCurrent:
      NavigationInfo.GetRecordResult := grrError;
    grmNext:
      NavigationInfo.GetRecordResult := grrEOF;
  end;
end;// GetLastRecord


//------------------------------------------------------------------------------
// GetNextRecord
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.GetNextRecord(SessionID: TABSSessionID;
                         var NavigationInfo: TABSNavigationInfo);
var
  PageNo:     TABSPageNo;
  Page, NextPage:  TABSPage;
  RecordPage, NextRecordPage: TABSSmallRecordPage;
begin
  Page := LPageManager.GetPage(SessionID, NavigationInfo.RecordID.PageNo,
                             ptAnyPage);
  try
    NavigationInfo.GetRecordResult := grrEOF;
    if (IsRecordPageValid(Page)) then
      begin
        RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize,
                                                 FMaxRecordsOnPage);
        try
          if (RecordPage.GetNextRecordID(NavigationInfo.RecordID)) then
           begin
            if (NavigationInfo.RecordBuffer <> nil) then
             if (not RecordPage.GetRecordBuffer(NavigationInfo.RecordID, FTempDiskRecordBuffer)) then
              raise EABSException.Create(20145, ErrorARecordNotFound);
            NavigationInfo.GetRecordResult := grrOK;
           end
          else
           if (FRecordPageIndex.GetNextRecordPage(SessionID,
                                      NavigationInfo.RecordID.PageNo, PageNo)) then
             begin
               NextPage := LPageManager.GetPage(SessionID, PageNo,
                                   ptTableRecord);
               try
                 NextRecordPage := TABSSmallRecordPage.Create(NextPage,
                                          FDiskRecordBufferSize, FMaxRecordsOnPage);
                 try
                   NextRecordPage.GetFirstRecordID(NavigationInfo.RecordID);
                   if (NavigationInfo.RecordBuffer <> nil) then
                    if (not NextRecordPage.GetRecordBuffer(NavigationInfo.RecordID,
                                                       FTempDiskRecordBuffer)) then
                     raise EABSException.Create(20146, ErrorARecordNotFound);
                   NavigationInfo.GetRecordResult := grrOK;
                 finally
                   NextRecordPage.Free;
                 end;
               finally
                 LPageManager.PutPage(NextPage);
               end;
             end;
          if (NavigationInfo.GetRecordResult = grrOK) then
            begin
              if (NavigationInfo.RecordBuffer <> nil) then
                LFieldManager.DiskRecordBufferToMemRecordBuffer(FTempDiskRecordBuffer,
                                                    NavigationInfo.RecordBuffer);
              NavigationInfo.FirstPosition := False;
              NavigationInfo.LastPosition := False;
            end;
        finally
          RecordPage.Free;
        end;
      end
    else
  finally
    LPageManager.PutPage(Page);
  end;
end;// GetNextRecord


//------------------------------------------------------------------------------
// GetPriorRecord
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.GetPriorRecord(SessionID: TABSSessionID;
                         var NavigationInfo: TABSNavigationInfo);
var
  PageNo:     TABSPageNo;
  Page, PriorPage:  TABSPage;
  RecordPage, PriorRecordPage: TABSSmallRecordPage;
begin
  Page := LPageManager.GetPage(SessionID, NavigationInfo.RecordID.PageNo, ptAnyPage);
  NavigationInfo.GetRecordResult := grrError;
  try
    if (IsRecordPageValid(Page)) then
      begin
        NavigationInfo.GetRecordResult := grrBOF;
        RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize,
                                                 FMaxRecordsOnPage);
        try
          if (RecordPage.GetPriorRecordID(NavigationInfo.RecordID)) then
           begin
            if (NavigationInfo.RecordBuffer <> nil) then
             if (not RecordPage.GetRecordBuffer(NavigationInfo.RecordID, FTempDiskRecordBuffer)) then
              raise EABSException.Create(20147, ErrorARecordNotFound);
            NavigationInfo.GetRecordResult := grrOK;
           end
          else
           if (FRecordPageIndex.GetPriorRecordPage(SessionID,
                                      NavigationInfo.RecordID.PageNo, PageNo)) then
             begin
               PriorPage := LPageManager.GetPage(SessionID, PageNo, ptTableRecord);
               try
                 PriorRecordPage := TABSSmallRecordPage.Create(PriorPage,
                                          FDiskRecordBufferSize, FMaxRecordsOnPage);
                 try
                   PriorRecordPage.GetLastRecordID(NavigationInfo.RecordID);
                   if (NavigationInfo.RecordBuffer <> nil) then
                    if (not PriorRecordPage.GetRecordBuffer(NavigationInfo.RecordID,
                                                       FTempDiskRecordBuffer)) then
                     raise EABSException.Create(20148, ErrorARecordNotFound);
                   NavigationInfo.GetRecordResult := grrOK;
                 finally
                   PriorRecordPage.Free;
                 end;
               finally
                 LPageManager.PutPage(PriorPage);
               end;
             end;
          if (NavigationInfo.GetRecordResult = grrOK) then
            begin
              if (NavigationInfo.RecordBuffer <> nil) then
                LFieldManager.DiskRecordBufferToMemRecordBuffer(FTempDiskRecordBuffer,
                                                    NavigationInfo.RecordBuffer);
              NavigationInfo.FirstPosition := False;
              NavigationInfo.LastPosition := False;
            end;
        finally
          RecordPage.Free;
        end;
      end;
  finally
    LPageManager.PutPage(Page);
  end;
  // prior from non-existing record => read last record
  if (NavigationInfo.GetRecordResult = grrError) then
    GetLastRecord(SessionID, NavigationInfo);
end;// GetPriorRecord


//------------------------------------------------------------------------------
// GetCurrentRecord
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.GetCurrentRecord(SessionID: TABSSessionID;
                         var NavigationInfo: TABSNavigationInfo);
var
  Page:       TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  NavigationInfo.GetRecordResult := grrError;
  Page := LPageManager.GetPage(SessionID, NavigationInfo.RecordID.PageNo,
                             ptAnyPage);
  try
    if (IsRecordPageValid(Page)) then
      begin
        RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize,
                                                 FMaxRecordsOnPage);
        try
          if (RecordPage.GetRecordBuffer(NavigationInfo.RecordID, FTempDiskRecordBuffer)) then
            begin
              LFieldManager.DiskRecordBufferToMemRecordBuffer(FTempDiskRecordBuffer,
                                                NavigationInfo.RecordBuffer);
              NavigationInfo.GetRecordResult := grrOK;
              NavigationInfo.FirstPosition := False;
              NavigationInfo.LastPosition := False;
            end
          else
            NavigationInfo.GetRecordResult := grrError;
        finally
          RecordPage.Free;
        end;
      end
    else
      NavigationInfo.GetRecordResult := grrError;
  finally
    LPageManager.PutPage(Page);
  end;
end;// GetCurrentRecord


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDiskRecordManager.Create(PageManager: TABSPageManager;
       FieldManager: TABSBaseFieldManager; MostUpdatedFile: TABSInternalDBTransactedAccessFile;
       TableData: TABSDiskTableData);
begin
  LPageManager := PageManager;
  LFieldManager := FieldManager;
  LMostUpdatedFile := MostUpdatedFile;
  FRecordPageIndex := TABSBTreeRecordPageIndex.Create(PageManager);
  LTableData := TableData;
  FTempDiskRecordBuffer := nil;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDiskRecordManager.Destroy;
begin
  if (FTempDiskRecordBuffer <> nil) then
    MemoryManager.FreeAndNillMem(FTempDiskRecordBuffer);
  FRecordPageIndex.Free;
end;// Destroy


//------------------------------------------------------------------------------
// Init
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.Init(RecordBufferSize: Integer;
                            DiskRecordBufferSize: Integer; FieldCount: Integer);
var
  i: Integer;
begin
  FRecordBufferSize := RecordBufferSize;
  FDiskRecordBufferSize := DiskRecordBufferSize;
  FTempDiskRecordBuffer := MemoryManager.GetMem(FDiskRecordBufferSize);
  FMaxRecordsOnPage := Trunc((LPageManager.PageDataSize-1) / (DiskRecordBufferSize + 1/8));
  if (FMaxRecordsOnPage = 0) then
    raise EABSException.Create(20174, ErrorATooLargeRecord);
  FRecordPageIndex.MaxRecordsOnPage := FMaxRecordsOnPage;
  FRecordCount := 0;
  FTableState := 0;
  SetLength(FLastAutoIncValues, FieldCount);
  for i := 0 to FieldCount-1 do
   FLastAutoIncValues[i] := 0;
end;// Init


//------------------------------------------------------------------------------
// LoadMostUpdated
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.LoadMostUpdated(Buf: TAbsPByte; var Offset: Integer);
begin
  FTableState := PInteger(Buf+Offset)^;
  Inc(Offset, sizeof(Integer));
  FRecordCount := PInteger(Buf+Offset)^;
  Inc(Offset, sizeof(Integer));
end;// LoadMostUpdated


//------------------------------------------------------------------------------
// SaveMostUpdated
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.SaveMostUpdated(Buf: TAbsPByte; var Offset: Integer);
begin
  PInteger(Buf+Offset)^ := FTableState;
  Inc(Offset, sizeof(Integer));
  PInteger(Buf+Offset)^ := FRecordCount;
  Inc(Offset, sizeof(Integer));
end;// SaveMostUpdated


//------------------------------------------------------------------------------
// LoadMetadataFromStream
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.LoadMetadata(Stream: TStream);
var
  RootPageNo: TABSPageNo;
begin
  Stream.Read(RootPageNo, sizeof(FRecordPageIndex.RootPageNo));
  FRecordPageIndex.OpenIndex(RootPageNo);
end;// LoadMetadata


//------------------------------------------------------------------------------
// SaveMetadataToStream
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.SaveMetadata(Stream: TStream);
begin
  Stream.Write(FRecordPageIndex.RootPageNo, sizeof(FRecordPageIndex.RootPageNo));
end;// SaveMetadata


//------------------------------------------------------------------------------
// CreateRecordPageIndex
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.CreateRecordPageIndex;
begin
  FRecordPageIndex.CreateIndex(SYSTEM_SESSION_ID);
end;// CreateRecordPageIndex


//------------------------------------------------------------------------------
// Empty
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.Empty(SessionID: TABSSessionID);
var
  PageNo: TABSPageNo;
begin
  if (FRecordPageIndex.GetFirstRecordPage(SessionID, PageNo)) then
    begin
      repeat
        LPageManager.RemovePage(SessionID, PageNo);
      until (not FRecordPageIndex.GetNextRecordPage(SessionID, PageNo, PageNo));
    end;
  FTableState := 0;
  FRecordPageIndex.EmptyIndex(SessionID);
  FRecordCount := 0;
end;// Empty


//------------------------------------------------------------------------------
// Delete
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.Delete(SessionID: TABSSessionID);
begin
  Empty(SessionID);
  FRecordPageIndex.DropIndex(SessionID);
end;// Delete


//------------------------------------------------------------------------------
// add record and return its number
//------------------------------------------------------------------------------
function TABSDiskRecordManager.AddRecord(SessionID: TABSSessionID;
           RecordBuffer: TABSRecordBuffer; var RecordID: TABSRecordID): Boolean;
var
  PageNo:     TABSPageNo;
  Page:       TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  try
    if (FRecordPageIndex.FindPageForNewRecord(SessionID, PageNo)) then
      Page := LPageManager.GetPage(SessionID, PageNo, ptTableRecord)
    else
      begin
        Page := LPageManager.AddPage(SessionID, ptTableRecord);
        Page.PageHeader^.ObjectID := LTableData.FTableID;
      end;
    try
      RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize, FMaxRecordsOnPage);
      try
        LFieldManager.MemRecordBufferToDiskRecordBuffer(RecordBuffer, FTempDiskRecordBuffer);
        RecordPage.AddRecord(FTempDiskRecordBuffer, RecordID);
        Inc(FRecordCount);
        Inc(FTableState);
      finally
        RecordPage.Free;
      end;
      FRecordPageIndex.AddRecord(SessionID, Page.PageNo);
      Result := True;
    finally
      LPageManager.PutPage(Page);
    end;
  except
    Result := False;
  end;
end;// AddRecord


//------------------------------------------------------------------------------
// update record, return true if record was updated, false if record was deleted
//------------------------------------------------------------------------------
function TABSDiskRecordManager.UpdateRecord(SessionID: TABSSessionID;
               RecordBuffer: TABSRecordBuffer; RecordID: TABSRecordID): Boolean;
var
  Page:       TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  Page := LPageManager.GetPage(SessionID, RecordID.PageNo, ptTableRecord);
  try
    RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize, FMaxRecordsOnPage);
    try
      LFieldManager.MemRecordBufferToDiskRecordBuffer(RecordBuffer, FTempDiskRecordBuffer);
      Result := RecordPage.UpdateRecord(FTempDiskRecordBuffer, RecordID);
      if (Result) then
        Inc(FTableState);
    finally
      RecordPage.Free;
    end;
  finally
    LPageManager.PutPage(Page);
  end;
end;// UpdateRecord


//------------------------------------------------------------------------------
// delete record, return true if record was deleted, false if record was deleted earlier
//------------------------------------------------------------------------------
function TABSDiskRecordManager.DeleteRecord(SessionID: TABSSessionID;
                                           var RecordID: TABSRecordID): Boolean;
var
  Page:       TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  Page := LPageManager.GetPage(SessionID, RecordID.PageNo, ptTableRecord);
  try
    RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize, FMaxRecordsOnPage);
    try
      Result := RecordPage.DeleteRecord(RecordID);
      if (Result) then
       begin
         Dec(FRecordCount);
         Inc(FTableState);
         if (RecordPage.RecordCount = 0) then
           LPageManager.RemovePage(SessionID, Page.PageNo);
         FRecordPageIndex.DeleteRecord(SessionID, Page.PageNo, RecordPage.RecordCount);
       end;
    finally
      RecordPage.Free;
    end;
  finally
    LPageManager.PutPage(Page);
  end;
end;// DeleteRecord


//------------------------------------------------------------------------------
// GetRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.GetRecordBuffer(SessionID: TABSSessionID;
                                        var NavigationInfo: TABSNavigationInfo);
begin
 if (FRecordCount = 0) then
   NavigationInfo.GetRecordResult := grrEOF
 else
  begin
    if (NavigationInfo.FirstPosition) then
      GetFirstRecord(SessionID, NavigationInfo)
    else
    if (NavigationInfo.LastPosition) then
      GetLastRecord(SessionID, NavigationInfo)
    else
    if (NavigationInfo.GetRecordMode = grmNext) then
      GetNextRecord(SessionID, NavigationInfo)
    else
    if (NavigationInfo.GetRecordMode = grmPrior) then
      GetPriorRecord(SessionID, NavigationInfo)
    else
    if (NavigationInfo.GetRecordMode = grmCurrent) then
      GetCurrentRecord(SessionID, NavigationInfo);
  end;
end;// GetRecordBuffer


//------------------------------------------------------------------------------
// return 0,1, or -1 if (1 = 2), (1 > 2) or (1 < 2)
//------------------------------------------------------------------------------
function TABSDiskRecordManager.CompareRecordID(RecordID1: TABSRecordID; RecordID2: TABSRecordID): Integer;
begin
 if (RecordID1.PageNo > RecordID2.PageNo) then
  Result := 1
 else
 if (RecordID1.PageNo < RecordID2.PageNo) then
  Result := -1
 else
  if (RecordID1.PageItemNo > RecordID2.PageItemNo) then
    Result := 1
  else
  if (RecordID1.PageItemNo < RecordID2.PageItemNo) then
    Result := -1
  else
    Result := 0;
end;// CompareRecordID


//------------------------------------------------------------------------------
// return record no
//------------------------------------------------------------------------------
function TABSDiskRecordManager.GetApproximateRecNo(SessionID: TABSSessionID;
                                          RecordID: TABSRecordID): TABSRecordNo;
begin
  Result := FRecordCount div 2;
end;// GetApproximateRecNo


//------------------------------------------------------------------------------
// SetRecNo
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.SetRecNo(SessionID: TABSSessionID;
                               RecNo: TABSRecordNo; var RecordID: TABSRecordID);
var
  PageNo: TABSPageNo;
  RecNoOnPage: Integer;
  Page: TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  FRecordPageIndex.GetRecordByRecNo(SessionID, RecNo-1, PageNo, RecNoOnPage);
  Page := LPageManager.GetPage(SessionID, PageNo, ptTableRecord);
  try
    RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize, FMaxRecordsOnPage);
    try
      RecordPage.GetRecordID(RecNoOnPage, RecordID);
    finally
      RecordPage.Free;
    end;
  finally
    LPageManager.PutPage(Page);
  end;
end;// SetRecNo


//------------------------------------------------------------------------------
// GetRecNo
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.GetRecNo(SessionID: TABSSessionID;
                               RecordID: TABSRecordID; var RecNo: TABSRecordNo);
var
  RecNoOnPage: Integer;
  Page: TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  Page := LPageManager.GetPage(SessionID, RecordID.PageNo, ptTableRecord);
  try
    RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize, FMaxRecordsOnPage);
    try
      RecordPage.GetRecNoOnPage(RecordID, RecNoOnPage);
      FRecordPageIndex.GetRecNoByRecord(SessionID, RecordID.PageNo, RecNoOnPage, RecNo);
      Inc(RecNo);
    finally
      RecordPage.Free;
    end;
  finally
    LPageManager.PutPage(Page);
  end;
end;// GetRecNo


//------------------------------------------------------------------------------
// RebuildRecordPageIndex
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.RebuildRecordPageIndex(SessionID: TABSSessionID);
var
  PageNo, PageCount: Integer;
  Page: TABSPage;
  RecordPage: TABSSmallRecordPage;
begin
  FRecordPageIndex.CreateIndex(SessionID);
  // full db scan
  PageCount := LPageManager.PageCount;
  FRecordCount := 0;
  for PageNo:=1 to PageCount-1 do
    begin
      try
        Page := LPageManager.GetPage(SessionID, PageNo, ptTableRecord);
        try
          if (Page.PageHeader^.ObjectID = LTableData.FTableID) then
            if (IsRecordPageValid(Page)) then
              if (TABSDiskPageManager(LPageManager).FreeSpaceManager.GetPageUsageFromPFS(PageNo)) then
                begin
                  RecordPage := TABSSmallRecordPage.Create(Page, FDiskRecordBufferSize, FMaxRecordsOnPage);
                  try
                    FRecordPageIndex.AddRecord(SessionID, PageNo, RecordPage.GetRecordCount);
                    Inc(FRecordCount, RecordPage.GetRecordCount);
                  finally
                    RecordPage.Free;
                  end;
                end;
        finally
          LPageManager.PutPage(Page);
        end;
      except
        // skip this page and go to the next
      end;
    end;
end;// RebuildRecordPageIndex


//------------------------------------------------------------------------------
// ValidateRecordPageIndex
//------------------------------------------------------------------------------
procedure TABSDiskRecordManager.ValidateRecordPageIndex(SessionID: TABSSessionID);
begin
  FRecordPageIndex.Validate(SessionID, FRecordCount);
end;// ValidateRecordPageIndex


////////////////////////////////////////////////////////////////////////////////
//
// TABSSmallBlobPage
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// SetBlobCount
//------------------------------------------------------------------------------
procedure TABSSmallBlobPage.SetBlobCount(Value: Integer);
begin
  PWord(LPage.PageData)^ := Value;
end;// SetBlobCount


//------------------------------------------------------------------------------
// GetBlobCount
//------------------------------------------------------------------------------
function TABSSmallBlobPage.GetBlobCount: Integer;
begin
  Result := PWord(LPage.PageData)^;
end;// GetBlobCount


//------------------------------------------------------------------------------
// BlobHeader
//------------------------------------------------------------------------------
function TABSSmallBlobPage.BlobHeader(Index: Integer): PABSDiskBlobHeader;
var
  i: Integer;
  Offset: Integer;
begin
  Offset := sizeof(Word); // skip BlobCount
  for i := 0 to Index-1 do
    Inc(Offset, sizeof(TABSDiskBlobHeader) +
                PABSDiskBlobHeader(LPage.PageData+Offset)^.CompressedSize);
  Result := PABSDiskBlobHeader(LPage.PageData+Offset);
end;// BlobHeader


//------------------------------------------------------------------------------
// BlobData
//------------------------------------------------------------------------------
function TABSSmallBlobPage.BlobData(Index: Integer): TAbsPByte;
begin
  Result := TAbsPByte(BlobHeader(Index))+sizeof(TABSDiskBlobHeader);
end;// BlobData


//------------------------------------------------------------------------------
// GetNewBlobID
//------------------------------------------------------------------------------
function TABSSmallBlobPage.GetNewBlobID: Word;
var
  NewBlobID: Word;
  i: Integer;
  bFound: Boolean;
begin
  NewBlobID := BlobCount;
  repeat
    bFound := False;
    for i := 0 to BlobCount-1 do
      if (BlobHeader(i)^.BlobID = NewBlobID) then
        begin
          bFound := True;
          if (NewBlobID <> $FFFE) then
            Inc(NewBlobID)
          else
            NewBlobID := 0;
          break;
        end;
  until (not bFound);
  if (NewBlobID = INVALID_PAGE_ITEM_NO) then
    raise EABSException.Create(20172, ErrorAInvalidBlobFieldID);
  Result := NewBlobID;
end;// GetNewBlobID


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSSmallBlobPage.Create(Page: TABSPage);
begin
  LPage := Page;
end;// Create


//------------------------------------------------------------------------------
// AddBlob
//------------------------------------------------------------------------------
procedure TABSSmallBlobPage.AddBlob(BlobCache: PABSDiskBLOBCache;
                                    var PageItemID: TABSPageItemID);
var
 pBlobHeader: PABSDiskBlobHeader;
begin
  pBlobHeader := BlobHeader(BlobCount);
  pBlobHeader^.BlobID := GetNewBlobID;
  pBlobHeader^.NumBlocks := BlobCache^.NumBlocks;
  pBlobHeader^.CompressedSize := MemoryManager.GetMemoryBufferSize(BlobCache^.BlobData);
  pBlobHeader^.UncompressedSize := BlobCache^.UncompressedSize;
  Move(BlobCache^.BlobData^, BlobData(BlobCount)^, pBlobHeader^.CompressedSize);
  PageItemID.PageNo := LPage.PageNo;
  PageItemID.PageItemNo := BlobHeader(BlobCount)^.BlobID;
  BlobCount := BlobCount + 1;
  LPage.IsDirty := True;
end;// AddBlob


//------------------------------------------------------------------------------
// DeleteBlob
//------------------------------------------------------------------------------
procedure TABSSmallBlobPage.DeleteBlob(PageItemID: TABSPageItemID; var BlobSize: Integer);
var
  i, BlobIndex: Integer;
begin
  BlobIndex := -1;
  for i := 0 to BlobCount-1 do
    if (BlobHeader(i)^.BlobID = PageItemID.PageItemNo) then
      begin
        BlobIndex := i;
        BlobSize := BlobHeader(i)^.CompressedSize + sizeof(TABSDiskBlobHeader);
        break;
      end;
  if (BlobIndex < 0) then
    raise EABSException.Create(20171, ErrorACannotFindBlob);
  if (BlobIndex < BlobCount-1) then
    Move(BlobHeader(BlobIndex+1)^, BlobHeader(BlobIndex)^,
{$IFDEF WIN64}
         NativeUInt(LPage.PageData)  + NativeUInt(LPage.PageDataSize)  - NativeUInt(BlobHeader(BlobIndex+1)));
{$ELSE}
         Integer(LPage.PageData)  + Integer(LPage.PageDataSize)  - Integer(BlobHeader(BlobIndex+1)));
{$ENDIF}
  BlobCount := BlobCount - 1;
  LPage.IsDirty := True;
end;// DeleteBlob


//------------------------------------------------------------------------------
// ReadBlob
//------------------------------------------------------------------------------
procedure TABSSmallBlobPage.ReadBlob(BlobCache: PABSDiskBLOBCache;
                   PageItemID: TABSPageItemID);
var
  i: Integer;
begin
  for i := 0 to BlobCount-1 do
    if (BlobHeader(i)^.BlobID = PageItemID.PageItemNo) then
      begin
        with (BlobHeader(i)^) do
          begin
            BlobCache^.NumBlocks := NumBlocks;
            BlobCache^.UncompressedSize := UncompressedSize;
            BlobCache^.Modified := False;
            BlobCache^.BlobData := MemoryManager.GetMem(CompressedSize);
            Move(BlobData(i)^, BlobCache^.BlobData^, CompressedSize);
          end;
        break;
      end;
end;// ReadBlob



////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskBlobManager
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// GetBlobInfo
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.GetBlobInfo(RecordBuffer: TABSRecordBuffer;
                      FieldNo: Integer;
                      var PageItemID: TABSPageItemID;
                      var BlobCache: PABSDiskBLOBCache);
begin
  PageItemID := PABSPageItemID(RecordBuffer + LFieldManager.FieldDefs[FieldNo].MemoryOffset)^;
  BlobCache := PPABSDiskBLOBCache(RecordBuffer +
                                  LFieldManager.FieldDefs[FieldNo].MemoryOffset+
                                  sizeof(TABSPageItemID))^;
  if (FBlobCacheList.IndexOf(BlobCache) = -1) then
    BlobCache := nil;
end;// GetBlobInfo


//------------------------------------------------------------------------------
// SetBlobInfo
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.SetBlobInfo(RecordBuffer: TABSRecordBuffer;
                      FieldNo: Integer; PageItemID: TABSPageItemID);
begin
  PABSPageItemID(RecordBuffer +
                 LFieldManager.FieldDefs[FieldNo].MemoryOffset)^ := PageItemID;
end;// SetBlobInfo


//------------------------------------------------------------------------------
// CreateBlobCache
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.CreateBlobCache(RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
                          var BlobCache: PABSDiskBLOBCache);
begin
  New(BlobCache);
  FBlobCacheList.Add(BlobCache);
  BlobCache^.BlobData := nil;
  BlobCache^.Modified := false;
  PPABSDiskBLOBCache(RecordBuffer +
                     LFieldManager.FieldDefs[FieldNo].MemoryOffset+
                     sizeof(TABSPageItemID))^ := BlobCache;
end;// CreateBlobCache


//------------------------------------------------------------------------------
// FreeBlobCache
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.FreeBlobCache(RecordBuffer: TABSRecordBuffer;
                                 FieldNo: Integer; ForceClear: Boolean = False);
var
  BlobCache: PABSDiskBLOBCache;
  PageItemID: TABSPageItemID;
begin
  GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
  if (BlobCache <> nil) then
   if (FBlobCacheList.IndexOf(BlobCache) <> -1) then
    if ((not BlobCache^.Modified) or (ForceClear)) then
      begin
        if (BlobCache^.BlobData <> nil) then
          MemoryManager.FreeAndNillMem(BlobCache^.BlobData);
        Dispose(BlobCache);
        PPABSDiskBLOBCache(RecordBuffer +
                           LFieldManager.FieldDefs[FieldNo].MemoryOffset+
                           sizeof(TABSPageItemID))^ := nil;
        FBlobCacheList.Remove(BlobCache);
      end;
end;// FreeBlobCache


//------------------------------------------------------------------------------
// StreamToBlobCache
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.StreamToBlobCache(Stream: TABSStream; BlobCache: PABSDiskBLOBCache);
var
  CompressedStream: TStream;
begin
  CompressedStream := TABSCompressedBLOBStream(
          TABSLocalBLOBStream(Stream).TemporaryStream).CompressedStream;
  BlobCache^.NumBlocks := TABSCompressedBLOBStream(
          TABSLocalBLOBStream(Stream).TemporaryStream).BLOBDescriptor.NumBlocks;
  BlobCache^.UncompressedSize := TABSCompressedBLOBStream(
          TABSLocalBLOBStream(Stream).TemporaryStream).BLOBDescriptor.UncompressedSize;
  BlobCache^.Modified := True;
  if (CompressedStream.Size > 0) then
    begin
      BlobCache^.BlobData := MemoryManager.GetMem(CompressedStream.Size);
      CompressedStream.Position := 0;
      CompressedStream.Read(BlobCache^.BlobData^, CompressedStream.Size);
    end;
end;// StreamToBlobCache


//------------------------------------------------------------------------------
// BlobCacheToStream
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.BlobCacheToStream(BlobCache: PABSDiskBLOBCache; Stream: TStream);
begin
  if (BlobCache = nil) then
    raise EABSException.Create(20161, ErrorANilPointer);
  Stream.Write(BlobCache^.BlobData^,
               MemoryManager.GetMemoryBufferSize(BlobCache^.BlobData));
end;// BlobCacheToStream


//------------------------------------------------------------------------------
// ReadBlobHeader
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.ReadBlobHeader(SessionID: TABSSessionID; PageItemID: TABSPageItemID;
                         var BlobHeader: TABSDiskBlobHeader;
                         BlobCache: PABSDiskBLOBCache);
var
  Page: TABSPage;
begin
  Page := LPageManager.GetPage(SessionID, PageItemID.PageNo, ptTableBlob);
  try
    Move(Page.PageData^, BlobHeader, sizeof(BlobHeader));
    if (BlobCache <> nil) then
      begin
        BlobCache^.NumBlocks := BlobHeader.NumBlocks;
        BlobCache^.UncompressedSize := BlobHeader.UncompressedSize;
        BlobCache^.Modified := False;
        BlobCache^.BlobData := nil;
      end;
  finally
    LPageManager.PutPage(Page);
  end;
end;// ReadBlobHeader


//------------------------------------------------------------------------------
// WriteBlobHeader
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.WriteBlobHeader(SessionID: TABSSessionID;
            BlobHeader: TABSDiskBlobHeader; var PageItemID: TABSPageItemID);
var
  Page: TABSPage;
begin
  Page := LPageManager.AddPage(SessionID, ptTableBlob);
  PageItemID.PageNo := Page.PageNo;
  try
    Move(BlobHeader, Page.PageData^, sizeof(BlobHeader));
    Page.IsDirty := True;
  finally
    LPageManager.PutPage(Page);
  end;
end;// WriteBlobHeader


//------------------------------------------------------------------------------
// ReadBlobData
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.ReadBlobData(
                   // in
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   BlobHeader: TABSDiskBlobHeader;
                   BlobDataPageList: TABSIntegerArray;
                   // out
                   BlobCache: PABSDiskBLOBCache);
var
  Page: TABSPage;
  ReadSize: Int64;
  SizeToRead: Integer;
  PageOffset: Integer;
  PageNoInList: Integer;
begin
  //--- read blob data using stored numbers of used pages ---
  ReadSize := 0;
  BlobCache^.BlobData := MemoryManager.GetMem(BlobHeader.CompressedSize);
  // read blob data (on first page with BlobHeader+link offset)
  PageOffset := sizeof(BlobHeader)+sizeof(TABSPageListLink);
  PageNoInList := 0;
  repeat
    Page := LPageManager.GetPage(SessionID, BlobDataPageList.Items[PageNoInList],
                             ptTableBlob);
    try
      SizeToRead := min(Page.PageDataSize-PageOffset,
                         BlobHeader.CompressedSize - ReadSize);
      Move((Page.PageData+PageOffset)^, (BlobCache^.BlobData+ReadSize)^,
           SizeToRead);
      ReadSize := ReadSize + SizeToRead;
    finally
      LPageManager.PutPage(Page);
    end;
    PageOffset := 0;
    Inc(PageNoInList);
  until (ReadSize >= BlobHeader.CompressedSize);
end;// ReadBlobData


//------------------------------------------------------------------------------
// ReadBlobDataPageList
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.ReadBlobDataPageList(
                   // in
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   const PageListLink: TABSPageListLink;
                   // out
                   BlobDataPageList: TABSIntegerArray;
                   BlobDataPageListPages: TABSIntegerArray);
var
  Page: TABSPage;
  PageNo: TABSPageNo;
  PageOffset: Word;
  PageNoCountToRead, ReadPageNoCount: integer;
begin
    PageNo := PageListLink.StartPageNo;
    PageOffset := PageListLink.StartOffset;
    BlobDataPageList.SetSize(PageListLink.ItemCount);
    ReadPageNoCount := 0;
    repeat
      if (BlobDataPageListPages <> nil) then
        BlobDataPageListPages.Append(PageNo);
      Page := LPageManager.GetPage(SessionID, PageNo, ptTableBlob);
      try
        // blob data page numbers on this page
        PageNoCountToRead := min((Page.PageDataSize-PageOffset) div sizeof(TABSPageNo),
                                  PageListLink.ItemCount-ReadPageNoCount);
        Move((Page.PageData+PageOffset)^,
             BlobDataPageList.Items[ReadPageNoCount],
             PageNoCountToRead*sizeof(TABSPageNo));
        ReadPageNoCount := ReadPageNoCount + PageNoCountToRead;
        PageNo := Page.PageHeader.NextPageNo;
        PageOffset := 0;
      finally
        LPageManager.PutPage(Page);
      end;
    until (ReadPageNoCount >= BlobDataPageList.ItemCount);
end;// ReadBlobDataPageList


//------------------------------------------------------------------------------
// ReadLinkToBlobDataPageList
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.ReadLinkToBlobDataPageList(
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   var PageListLink: TABSPageListLink);
var
  Page: TABSPage;
begin
  Page := LPageManager.GetPage(SessionID, PageItemID.PageNo, ptTableBlob);
  try
    Move((Page.PageData+sizeof(TABSDiskBlobHeader))^, PageListLink,
         sizeof(PageListLink));
  finally
    LPageManager.PutPage(Page);
  end;
end;// ReadLinkToBlobDataPageList


//------------------------------------------------------------------------------
// ReadMultiPagesBlob
//------------------------------------------------------------------------------
// Blob format:
// 1) BlobHeader
// 2) Link to BlobData page list (PageNo, PageOffset)
// 3) BlobData Page1->Page2->Page3
// 4) BlobData page list (Page1No, Page2No, Page3No)
procedure TABSDiskBlobManager.ReadMultiPagesBlob(SessionID: TABSSessionID;
                  PageItemID: TABSPageItemID; BlobHeader: TABSDiskBlobHeader;
                  BlobCache: PABSDiskBLOBCache);
var
  BlobDataPageList: TABSIntegerArray;
  PageListLink: TABSPageListLink;
begin
  BlobDataPageList := TABSIntegerArray.Create;
  try
    ReadLinkToBlobDataPageList(SessionID, PageItemID, PageListLink);
    ReadBlobDataPageList(SessionID, PageItemID, PageListLink, BlobDataPageList, nil);
    ReadBlobData(SessionID, PageItemID, BlobHeader, BlobDataPageList, BlobCache);
  finally
    BlobDataPageList.Free;
  end;
end;// ReadMultiPagesBlob


//------------------------------------------------------------------------------
// WriteBlobData
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.WriteBlobData(
               // in
               SessionID: TABSSessionID;
               BlobCache: PABSDiskBLOBCache; PageItemID: TABSPageItemID;
               BlobHeader: TABSDiskBlobHeader;
               // out
               var LastPageNo: TABSPageNo; var LastPageOffset: Word;
               BlobDataPageList: TABSIntegerArray);
var
  Page: TABSPage;
  WrittenSize: Int64;
  SizeToWrite: Integer;
  PageOffset: Integer;
begin
  //--- write blob data, store numbers of used pages ---
  WrittenSize := 0;
  PageOffset := sizeof(BlobHeader)+sizeof(TABSPageListLink);
  // write blob data (on first page with BlobHeader offset)
  repeat
    if (PageOffset <> 0) then
     Page := LPageManager.GetPage(SessionID, PageItemID.PageNo, ptTableBlob)
    else
     Page := LPageManager.AddPage(SessionID, ptTableBlob);
    try
      SizeToWrite := min(Page.PageDataSize-PageOffset,
                         BlobHeader.CompressedSize - WrittenSize);
      Move((BlobCache^.BlobData+WrittenSize)^, (Page.PageData+PageOffset)^, SizeToWrite);
      WrittenSize := WrittenSize + SizeToWrite;
      Page.IsDirty := True;
      BlobDataPageList.Append(Page.PageNo);
      LastPageNo := Page.PageNo;
      LastPageOffset := PageOffset + SizeToWrite;
    finally
      LPageManager.PutPage(Page);
    end;
    PageOffset := 0;
  until (WrittenSize >= BlobHeader.CompressedSize);
end;// WriteBlobData


//------------------------------------------------------------------------------
// WriteBlobDataPageList
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.WriteBlobDataPageList(
                   // in
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   BlobHeader: TABSDiskBlobHeader;
                   LastPageNo: TABSPageNo; LastPageOffset: Word;
                   BlobDataPageList: TABSIntegerArray;
                   // out
                   var PageListLink: TABSPageListLink);
var
  Page, NewPage: TABSPage;
  WrittenPageNoCount: Integer;
  PageNoCountToWrite: Integer;
  PageOffset: Integer;
begin
    WrittenPageNoCount := 0;
    NewPage := nil;
    if (LastPageOffset = LPageManager.PageDataSize) then
      PageOffset := 0
    else
      PageOffset := LastPageOffset;
    if (PageOffset <> 0) then
     Page := LPageManager.GetPage(SessionID, LastPageNo, ptTableBlob)
    else
     Page := LPageManager.AddPage(SessionID, ptTableBlob);
    repeat
      // write pagelist (on first page with last page offset)
      try
        if (WrittenPageNoCount = 0) then
         begin
           PageListLink.StartPageNo := Page.PageNo;
           PageListLink.StartOffset := PageOffset;
           PageListLink.ItemCount := BlobDataPageList.ItemCount;
         end;
        // blob data page numbers on this page
        PageNoCountToWrite := min((Page.PageDataSize-PageOffset) div sizeof(TABSPageNo),
                                  BlobDataPageList.ItemCount-WrittenPageNoCount);
        Move(BlobDataPageList.Items[WrittenPageNoCount],
             (Page.PageData+PageOffset)^,
             PageNoCountToWrite*sizeof(TABSPageNo));
        WrittenPageNoCount := WrittenPageNoCount + PageNoCountToWrite;
        Page.IsDirty := True;
        // another page needed to store blob data page numbers?
        if (WrittenPageNoCount < BlobDataPageList.ItemCount) then
         begin
          NewPage := LPageManager.AddPage(SessionID, ptTableBlob);
          Page.PageHeader.NextPageNo := NewPage.PageNo;
         end
        else
         NewPage := nil;
        PageOffset := 0; 
      finally
        LPageManager.PutPage(Page);
        Page := NewPage;
      end;
    until (WrittenPageNoCount >= BlobDataPageList.ItemCount);
end;// WriteBlobDataPageList


//------------------------------------------------------------------------------
// WriteLinkToBlobDataPageList
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.WriteLinkToBlobDataPageList(
                   SessionID: TABSSessionID;
                   PageItemID: TABSPageItemID;
                   PageListLink: TABSPageListLink);
var
  Page: TABSPage;
begin
  Page := LPageManager.GetPage(SessionID, PageItemID.PageNo, ptTableBlob);
  try
    Move(PageListLink, (Page.PageData+sizeof(TABSDiskBlobHeader))^,
         sizeof(PageListLink));
    Page.IsDirty := True;
  finally
    LPageManager.PutPage(Page);
  end;
end;// WriteLinkToBlobDataPageList


//------------------------------------------------------------------------------
// WriteMultiPagesBlob
//------------------------------------------------------------------------------
// Blob format:
// 1) BlobHeader
// 2) Link to BlobData page list (PageNo, PageOffset)
// 3) BlobData Page1->Page2->Page3
// 4) BlobData page list (Page1No, Page2No, Page3No)
procedure TABSDiskBlobManager.WriteMultiPagesBlob(SessionID: TABSSessionID;
                  BlobCache: PABSDiskBLOBCache; var PageItemID: TABSPageItemID;
                  BlobHeader: TABSDiskBlobHeader);
var
  BlobDataPageList: TABSIntegerArray;
  LastPageNo: TABSPageNo;
  LastPageOffset: Word;
  PageListLink: TABSPageListLink;
begin
  PageItemID.PageItemNo := INVALID_PAGE_ITEM_NO;
  BlobDataPageList := TABSIntegerArray.Create;
  try
    //--- write blob data, store numbers of used pages ---
    WriteBlobData(SessionID, BlobCache, PageItemID, BlobHeader, LastPageNo,
                  LastPageOffset, BlobDataPageList);
    //--- write page list ---
    WriteBlobDataPageList(SessionID, PageItemID, BlobHeader,
                          LastPageNo, LastPageOffset, BlobDataPageList,
                          PageListLink);
    // --- write link to the PageList on first page
    WriteLinkToBlobDataPageList(SessionID, PageItemID,PageListLink);
  finally
    BlobDataPageList.Free;
  end;
end;// WriteMultiPagesBlob


//------------------------------------------------------------------------------
// InternalReadSmallBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalReadSmallBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; PageItemID: TABSPageItemID);
var
  Page:       TABSPage;
  BlobPage:   TABSSmallBlobPage;
begin
  Page := LPageManager.GetPage(SessionID, PageItemID.PageNo, ptTableBlob);
  try
    BlobPage := TABSSmallBlobPage.Create(Page);
    try
      BlobPage.ReadBlob(BlobCache, PageItemID);
    finally
      BlobPage.Free;
    end;
  finally
    LPageManager.PutPage(Page);
  end;

end;// InternalReadSmallBlob


//------------------------------------------------------------------------------
// InternalReadLargeBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalReadLargeBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; PageItemID: TABSPageItemID);
var
  BlobHeader: TABSDiskBlobHeader;
begin
  ReadBlobHeader(SessionID, PageItemID, BlobHeader, BlobCache);
  ReadMultiPagesBlob(SessionID, PageItemID, BlobHeader, BlobCache);
end;// InternalReadLargeBlob


//------------------------------------------------------------------------------
// IsProbablyLargeBlob
//------------------------------------------------------------------------------
function TABSDiskBlobManager.IsProbablyLargeBlob(SessionID: TABSSessionID;
                                          PageItemID: TABSPageItemID): Boolean;
var
  BlobHeader: TABSDiskBlobHeader;
  PageListLink: TABSPageListLink;
begin
  try
    ReadBlobHeader(SessionID, PageItemID, BlobHeader, nil);
    ReadLinkToBlobDataPageList(SessionID, PageItemID, PageListLink);
    Result := (BlobHeader.CompressedSize < int64(PageListLink.ItemCount) * LPageManager.PageDataSize) and
              (BlobHeader.CompressedSize > int64(PageListLink.ItemCount-2) * LPageManager.PageDataSize);
  except
    Result := False;
  end;
end;// IsProbablyLargeBlob


//------------------------------------------------------------------------------
// InternalReadBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalReadBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; PageItemID: TABSPageItemID);
begin
  if (PageItemID.PageItemNo = INVALID_PAGE_ITEM_NO) then
    InternalReadLargeBlob(SessionID, BlobCache, PageItemID)
  else
    if (PageItemID.PageItemNo = $FF) then
      begin
        // bug-fix for Absolute 4.77 and earlier
        if (IsProbablyLargeBlob(SessionID, PageItemID)) then
          try
            InternalReadLargeBlob(SessionID, BlobCache, PageItemID);
          except
            InternalReadSmallBlob(SessionID, BlobCache, PageItemID)
          end
        else
          try
            InternalReadSmallBlob(SessionID, BlobCache, PageItemID)
          except
            InternalReadLargeBlob(SessionID, BlobCache, PageItemID);
          end
      end
    else
      InternalReadSmallBlob(SessionID, BlobCache, PageItemID);
end;// InternalReadBlob


//------------------------------------------------------------------------------
// InternalWriteSmallBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalWriteSmallBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; var PageItemID: TABSPageItemID);
var
  PageNo:     TABSPageNo;
  Page:       TABSPage;
  BlobPage:   TABSSmallBlobPage;
  BlobSize:   Integer;
begin
  BlobSize := MemoryManager.GetMemoryBufferSize(BlobCache^.BlobData) +
              sizeof(TABSDiskBlobHeader);
  if (FBlobPageIndex.FindPageForNewBlob(SessionID, BlobSize, PageNo)) then
    Page := LPageManager.GetPage(SessionID, PageNo, ptTableBlob)
  else
    Page := LPageManager.AddPage(SessionID, ptTableBlob);
  try
    BlobPage := TABSSmallBlobPage.Create(Page);
    try
      if (TAbsPByte(BlobPage.BlobHeader(BlobPage.BlobCount))+sizeof(TABSDiskBlobHeader)+
          MemoryManager.GetMemoryBufferSize(BlobCache^.BlobData) - Page.PageData >
          Page.PageDataSize) then
        raise EABSException.Create(20290, ErrorACannotAddBlob, [BlobPage.BlobCount, TAbsPByte(BlobPage.BlobHeader(BlobPage.BlobCount))-Page.PageData, MemoryManager.GetMemoryBufferSize(BlobCache^.BlobData)+sizeof(TABSDiskBlobHeader), Page.PageDataSize, FBlobPageIndex.GetBlobPageAllocatedSpace(SessionID,Page.PageNo)]);

      BlobPage.AddBlob(BlobCache, PageItemID);
    finally
      BlobPage.Free;
    end;
    FBlobPageIndex.AddBlob(SessionID, BlobSize, Page.PageNo);
  finally
    LPageManager.PutPage(Page);
  end;
end;// InternalWriteSmallBlob


//------------------------------------------------------------------------------
// InternalWriteLargeBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalWriteLargeBlob(SessionID: TABSSessionID;
            BlobCache: PABSDiskBLOBCache; var PageItemID: TABSPageItemID);
var
  BlobHeader: TABSDiskBlobHeader;
begin
  BlobHeader.NumBlocks := BlobCache^.NumBlocks;
  BlobHeader.CompressedSize := MemoryManager.GetMemoryBufferSize(BlobCache^.BlobData);
  BlobHeader.UncompressedSize := BlobCache^.UncompressedSize;
  WriteBlobHeader(SessionID, BlobHeader, PageItemID);
  WriteMultiPagesBlob(SessionID, BlobCache, PageItemID, BlobHeader);
end;// InternalWriteLargeBlob


//------------------------------------------------------------------------------
// IsSmallBlob
//------------------------------------------------------------------------------
function TABSDiskBlobManager.IsSmallBlob(BlobSize: Int64): Boolean;
begin
  Result := (sizeof(Word) + // BlobCount
             sizeof(TABSDiskBlobHeader)+
             BlobSize <  LPageManager.PageDataSize);
end;// IsSmallBlob


//------------------------------------------------------------------------------
// InternalWriteBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalWriteBlob(SessionID: TABSSessionID;
        BlobCache: PABSDiskBLOBCache; var PageItemID: TABSPageItemID);
begin
  if (IsSmallBlob(MemoryManager.GetMemoryBufferSize(BlobCache^.BlobData))) then
    InternalWriteSmallBlob(SessionID, BlobCache, PageItemID)
  else
    InternalWriteLargeBlob(SessionID, BlobCache, PageItemID);
end;// InternalWriteBlob


//------------------------------------------------------------------------------
// InternalDeleteSmallBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalDeleteSmallBlob(SessionID: TABSSessionID;
                                                 var PageItemID: TABSPageItemID);
var
  Page:       TABSPage;
  BlobPage:   TABSSmallBlobPage;
  BlobSize:   Integer;
begin
  Page := LPageManager.GetPage(SessionID, PageItemID.PageNo, ptTableBlob);
  try
    BlobPage := TABSSmallBlobPage.Create(Page);
    try
      BlobPage.DeleteBlob(PageItemID, BlobSize);
      if (BlobPage.BlobCount = 0) then
        LPageManager.RemovePage(SessionID, Page.PageNo);
    finally
      BlobPage.Free;
    end;
    FBlobPageIndex.DeleteBlob(SessionID, BlobSize, Page.PageNo);
    PageItemID.PageNo := INVALID_PAGE_NO;
    PageItemID.PageItemNo := INVALID_PAGE_ITEM_NO;
  finally
    LPageManager.PutPage(Page);
  end;
end;// InternalDeleteSmallBlob


//------------------------------------------------------------------------------
// InternalDeleteLargeBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalDeleteLargeBlob(SessionID: TABSSessionID;
                                                 var PageItemID: TABSPageItemID);
var
  BlobDataPageList: TABSIntegerArray;
  BlobDataPageListPages: TABSIntegerArray;
  PageListLink: TABSPageListLink;
  i, startIndex: Integer;
begin
  BlobDataPageList := TABSIntegerArray.Create;
  BlobDataPageListPages := TABSIntegerArray.Create;
  try
    ReadLinkToBlobDataPageList(SessionID, PageItemID, PageListLink);
    ReadBlobDataPageList(SessionID, PageItemID, PageListLink, BlobDataPageList,
                         BlobDataPageListPages);
    // free blob data pages
    for i := 0 to BlobDataPageList.ItemCount-1 do
      LPageManager.RemovePage(SessionID, BlobDataPageList.Items[i]);

    // skip page which is used for both blob data and blob pages list
    startIndex := 0;
    if (BlobDataPageList.ItemCount > 0) then
     if (BlobDataPageList.Items[BlobDataPageList.ItemCount-1] =
         BlobDataPageListPages.Items[0]) then
      startIndex := 1;

    // free BlobDataPageList pages
    for i := startIndex to BlobDataPageListPages.ItemCount-1 do
      LPageManager.RemovePage(SessionID, BlobDataPageListPages.Items[i]);
    PageItemID.PageNo := INVALID_PAGE_NO;
    PageItemID.PageItemNo := INVALID_PAGE_ITEM_NO;
  finally
    BlobDataPageList.Free;
    BlobDataPageListPages.Free;
  end;
end;// InternalDeleteLargeBlob


//------------------------------------------------------------------------------
// InternalDeleteBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.InternalDeleteBlob(SessionID: TABSSessionID;
                                                 var PageItemID: TABSPageItemID);
begin
  if (PageItemID.PageItemNo = INVALID_PAGE_ITEM_NO) then
    InternalDeleteLargeBlob(SessionID, PageItemID)
  else
    if (PageItemID.PageItemNo = $FF) then
      begin
        // bug-fix for Absolute 4.77 and earlier
        if (IsProbablyLargeBlob(SessionID, PageItemID)) then
          try
            InternalDeleteLargeBlob(SessionID, PageItemID)
          except
            InternalDeleteSmallBlob(SessionID, PageItemID);
          end
        else
          try
            InternalDeleteSmallBlob(SessionID, PageItemID);
          except
            InternalDeleteLargeBlob(SessionID, PageItemID)
          end
      end
    else
      InternalDeleteSmallBlob(SessionID, PageItemID);
end;// InternalDeleteBlob


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDiskBlobManager.Create(PageManager: TABSPageManager;
   FieldManager: TABSBaseFieldManager; RecordManager: TABSBaseRecordManager);
begin
  LPageManager := PageManager;
  LFieldManager := FieldManager;
  LRecordManager := RecordManager;
  FBlobCacheList := TList.Create;
  FBlobPageIndex := TABSBTreeBlobPageIndex.Create(LPageManager);
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDiskBlobManager.Destroy;
begin
  if (FBlobCacheList.Count > 0) then
    raise EABSException.Create(20150, ErrorABlobCacheNotReleased);
  FBlobCacheList.Free;
  FBlobPageIndex.Free;
end;// Destroy


//------------------------------------------------------------------------------
// LoadMetadataFromStream
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.LoadMetadata(Stream: TStream);
var
  RootPageNo: TABSPageNo;
begin
  Stream.Read(RootPageNo, sizeof(FBlobPageIndex.RootPageNo));
  FBlobPageIndex.OpenIndex(RootPageNo);
end;// LoadMetadata


//------------------------------------------------------------------------------
// SaveMetadataToStream
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.SaveMetadata(Stream: TStream);
begin
  Stream.Write(FBlobPageIndex.RootPageNo, sizeof(FBlobPageIndex.RootPageNo));
end;// SaveMetadata


//------------------------------------------------------------------------------
// CreateBlobPageIndex
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.CreateBlobPageIndex;
begin
  FBlobPageIndex.CreateIndex(SYSTEM_SESSION_ID);
end;// CreateBlobPageIndex


//------------------------------------------------------------------------------
// Empty
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.Empty(SessionID: TABSSessionID);
var
  NavInfo: TABSNavigationInfo;
begin
  if (LFieldManager.BlobFieldsPresent) then
    begin
      NavInfo.RecordBuffer := MemoryManager.AllocMem(LFieldManager.FieldDefs.GetMemoryRecordBufferSize);
      try
        NavInfo.GetRecordMode := grmNext;
        NavInfo.FirstPosition := True;
        NavInfo.LastPosition := False;
        NavInfo.IndexID := INVALID_OBJECT_ID;
        LRecordManager.GetRecordBuffer(SessionID, NavInfo);
        while (NavInfo.GetRecordResult = grrOK) do
          begin
            DeleteBlobs(SessionID, NavInfo.RecordBuffer);
            LRecordManager.GetRecordBuffer(SessionID, NavInfo);
          end;
        FBlobPageIndex.EmptyIndex(SessionID);
      finally
        MemoryManager.FreeAndNillMem(NavInfo.RecordBuffer);
      end;
    end;
end;// Empty


//------------------------------------------------------------------------------
// Delete
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.Delete(SessionID: TABSSessionID);
begin
  if (LFieldManager.BlobFieldsPresent) then
    begin
      Empty(SessionID);
      FBlobPageIndex.DropIndex(SessionID);
    end;
end;// Delete


//------------------------------------------------------------------------------
// ReadBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.ReadBlob(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer;
                   FieldNo: Integer);
var
  PageItemID: TABSPageItemID;
  BlobCache: PABSDiskBLOBCache;
begin
  GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
  if ((BlobCache = nil) and
      ((PageItemID.PageNo <> 0) and (PageItemID.PageNo <> INVALID_PAGE_NO))) then
    begin
      CreateBlobCache(RecordBuffer, FieldNo, BlobCache);
      InternalReadBlob(SessionID, BlobCache, PageItemID);
    end;
end;// ReadBlob


//------------------------------------------------------------------------------
// WriteBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.WriteBlob(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer;
                    FieldNo: Integer);
var
  PageItemID: TABSPageItemID;
  BlobCache: PABSDiskBLOBCache;
begin
  GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
  if (BlobCache <> nil) then
    if (BlobCache^.Modified) then
      begin
        // delete old blob if exists
        if ((PageItemID.PageNo <> 0) and (PageItemID.PageNo <> INVALID_PAGE_NO)) then
          InternalDeleteBlob(SessionID, PageItemID);
        // write blob to pages
        if (BlobCache^.UncompressedSize > 0) then
          InternalWriteBlob(SessionID, BlobCache, PageItemID);
        // update record buffer
        SetBlobInfo(RecordBuffer, FieldNo, PageItemID);
        // free
        BlobCache^.Modified := False;
        ClearBlobInRecordBuffer(RecordBuffer, FieldNo);
      end;
end;// WriteBlob


//------------------------------------------------------------------------------
// WriteBlobs
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.WriteBlobs(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer);
var i: Integer;
begin
   for i := 0 to LFieldManager.FieldDefs.Count - 1 do
    if (IsBLOBFieldType(LFieldManager.FieldDefs[i].BaseFieldType)) then
      WriteBlob(SessionID, RecordBuffer,i);
end;// WriteBlobs


//------------------------------------------------------------------------------
// DeleteBlob
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.DeleteBlob(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer;
                    FieldNo: Integer);
var
  PageItemID: TABSPageItemID;
  BlobCache: PABSDiskBLOBCache;
begin
  if (not CheckNullFlag(FieldNo, RecordBuffer)) then
    begin
      GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
      // delete blob if exists
      if ((PageItemID.PageNo <> 0) and (PageItemID.PageNo <> INVALID_PAGE_NO)) then
        InternalDeleteBlob(SessionID, PageItemID);
      if (BlobCache <> nil) then
       BlobCache^.Modified := False;
    end;
end;// DeleteBlob


//------------------------------------------------------------------------------
// DeleteBlobs
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.DeleteBlobs(SessionID: TABSSessionID; RecordBuffer: TABSRecordBuffer);
var i: Integer;
begin
   for i := 0 to LFieldManager.FieldDefs.Count - 1 do
    if (IsBLOBFieldType(LFieldManager.FieldDefs[i].BaseFieldType)) then
      DeleteBlob(SessionID, RecordBuffer,i);
end;// DeleteBlobs


//------------------------------------------------------------------------------
// CopyBlobFromRecordBufferToStream
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.CopyBlobFromRecordBufferToStream(SessionID: TABSSessionID;
    RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
    var BLOBDescriptor: TABSBLOBDescriptor; Stream: TStream);
var
  PageItemID: TABSPageItemID;
  BlobCache: PABSDiskBLOBCache;
begin
  if (not CheckNullFlag(FieldNo, RecordBuffer)) then
    begin
      GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
      if (BlobCache = nil) then
        begin
          ReadBlob(SessionID, RecordBuffer, FieldNo);
          GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
        end;
      if (BlobCache = nil) then
        raise EABSException.Create(20162, ErrorACannotReadBlobValue);
      BlobCacheToStream(BlobCache, Stream);
      BLOBDescriptor.NumBlocks := BlobCache^.NumBlocks;
      BLOBDescriptor.UncompressedSize := BlobCache^.UncompressedSize;
    end
  else
    begin
      BLOBDescriptor.NumBlocks := 0;
      BLOBDescriptor.UncompressedSize := 0;
    end;
end;// CopyBlobFromRecordBufferToStream


//------------------------------------------------------------------------------
// CopyBlobFromStreamToRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.CopyBlobFromStreamToRecordBuffer(RecordBuffer: TABSRecordBuffer;
                    FieldNo: Integer; Stream: TABSStream);
var
  PageItemID: TABSPageItemID;
  BlobCache: PABSDiskBLOBCache;
begin
  if (Stream.Modified) then
    begin
      GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
      if (BlobCache <> nil) then
        FreeBlobCache(RecordBuffer, FieldNo, True);
      CreateBlobCache(RecordBuffer, FieldNo, BlobCache);
      StreamToBlobCache(Stream, BlobCache);
      if (Stream.Size > 0) then
        SetNullFlag(False, FieldNo, RecordBuffer)
      else
        SetNullFlag(True, FieldNo, RecordBuffer);
    end;
end;// CopyBlobFromStreamToRecordBuffer


//------------------------------------------------------------------------------
// ClearBlobInRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.ClearBlobInRecordBuffer(RecordBuffer: TABSRecordBuffer;
                                 FieldNo: Integer; ForceClear: Boolean = False);
var
  PageItemID: TABSPageItemID;
  BlobCache: PABSDiskBLOBCache;
begin
  if (RecordBuffer <> nil) then
    begin
      GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
      if (BlobCache <> nil) then
         FreeBlobCache(RecordBuffer, FieldNo, ForceClear);
    end;
end;// ClearBlobInRecordBuffer


//------------------------------------------------------------------------------
// GetDirectBlobInfoFromRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.GetDirectBlobInfoFromRecordBuffer(SessionID: TABSSessionID;
        RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
        var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
        var pBlobData: TAbsPByte);
var
  PageItemID: TABSPageItemID;
  BlobCache: PABSDiskBLOBCache;
begin
  if (not CheckNullFlag(FieldNo, RecordBuffer)) then
    begin
      GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
      if (BlobCache = nil) then
        begin
          ReadBlob(SessionID, RecordBuffer, FieldNo);
          GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
        end;
      if (BlobCache = nil) then
        raise EABSException.Create(20291, ErrorACannotReadBlobValue);
      BLOBDescriptor.NumBlocks := BlobCache^.NumBlocks;
      BLOBDescriptor.UncompressedSize := BlobCache^.UncompressedSize;
      BLOBDescriptor.CompressedSize := MemoryManager.GetMemoryBufferSize(BlobCache^.BlobData);
      pBlobData := BlobCache^.BlobData;
    end
  else
    begin
      BLOBDescriptor.NumBlocks := 0;
      BLOBDescriptor.UncompressedSize := 0;
      BLOBDescriptor.CompressedSize := 0;
      pBlobData := nil;
    end;
end;// GetDirectBlobInfoFromRecordBuffer


//------------------------------------------------------------------------------
// SetDirectBlobInfoFromRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskBlobManager.SetDirectBlobInfoFromRecordBuffer(SessionID: TABSSessionID;
        RecordBuffer: TABSRecordBuffer; FieldNo: Integer;
        var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
        var pBlobData: TAbsPByte);
var
  PageItemID: TABSPageItemID;
  BlobCache: PABSDiskBLOBCache;
begin
  GetBlobInfo(RecordBuffer, FieldNo, PageItemID, BlobCache);
  if (BlobCache <> nil) then
    FreeBlobCache(RecordBuffer, FieldNo, True);
  CreateBlobCache(RecordBuffer, FieldNo, BlobCache);

  BlobCache^.NumBlocks := BLOBDescriptor.NumBlocks;
  BlobCache^.UncompressedSize := BLOBDescriptor.UncompressedSize;
  BlobCache^.Modified := True;
  if (BLOBDescriptor.CompressedSize > 0) then
    begin
      BlobCache^.BlobData := MemoryManager.GetMem(BLOBDescriptor.CompressedSize);
      Move(pBlobData^, BlobCache^.BlobData^, BLOBDescriptor.CompressedSize);
    end;

  if (BLOBDescriptor.CompressedSize > 0) then
    SetNullFlag(False, FieldNo, RecordBuffer)
  else
    SetNullFlag(True, FieldNo, RecordBuffer);
end;// SetDirectBlobInfoFromRecordBuffer



////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskTableData
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// CreateTableFiles
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CreateTableFiles;
begin
  FTableLocksFile := TABSTableLocksFile.Create(PageManager);
  FTableMetadataFile := TABSInternalDbTransactedAccessFile.Create(TABSDiskPageManager(PageManager),
                                                  ptTableMetaDataFile);
  FTableMostUpdatedFile := TABSInternalDbTransactedAccessFile.Create(TABSDiskPageManager(PageManager),
                                                  ptTableMostUpdatedFile);

  FTableLocksFile.CreateFile(TABSDiskDatabaseData(FDatabaseData).MaxSessionCount);
  FTableMetadataFile.CreateFile(SYSTEM_SESSION_ID);
  FTableMostUpdatedFile.CreateFile(SYSTEM_SESSION_ID);
end;// CreateTableFiles


//------------------------------------------------------------------------------
// DeleteTableFiles
//------------------------------------------------------------------------------
procedure TABSDiskTableData.DeleteTableFiles;
begin
  FTableLocksFile.DeleteFile;
  FTableMetadataFile.DeleteFile(SYSTEM_SESSION_ID);
  FTableMostUpdatedFile.DeleteFile(SYSTEM_SESSION_ID);
end;// DeleteTableFiles


//------------------------------------------------------------------------------
// OpenTableFiles
//------------------------------------------------------------------------------
procedure TABSDiskTableData.OpenTableFiles(MetadataFilePageNo: TABSPageNo;
                             MostUpdatedFilePageNo: TABSPageNo;
                             LocksFilePageNo: TABSPageNo);
begin
  FTableLocksFile := TABSTableLocksFile.Create(PageManager);
  FTableMetadataFile := TABSInternalDbTransactedAccessFile.Create(TABSDiskPageManager(PageManager),
                                                  ptTableMetaDataFile);
  FTableMostUpdatedFile := TABSInternalDbTransactedAccessFile.Create(TABSDiskPageManager(PageManager),
                                                  ptTableMostUpdatedFile);

  FTableLocksFile.OpenFile(LocksFilePageNo);
  FTableMetadataFile.OpenFile(MetadataFilePageNo);
  FTableMostUpdatedFile.OpenFile(MostUpdatedFilePageNo);
end;// OpenTableFiles


//------------------------------------------------------------------------------
// FreeTableFiles
//------------------------------------------------------------------------------
procedure TABSDiskTableData.FreeTableFiles;
begin
  if (FTableLocksFile <> nil) then
    FTableLocksFile.Free;
  FTableLocksFile := nil;
  if (FTableMetadataFile <> nil) then
    FTableMetadataFile.Free;
  FTableMetadataFile := nil;
  if (FTableMostUpdatedFile <> nil) then
    FTableMostUpdatedFile.Free;
  FTableMostUpdatedFile := nil;
end;// FreeTableFiles


//------------------------------------------------------------------------------
// LoadMetadataFile
//------------------------------------------------------------------------------
procedure TABSDiskTableData.LoadMetadataFile(SessionID: TABSSessionID);
var
  Stream: TMemoryStream;
  CompressedSize: Integer;
  DecompressedSize: Integer;
  CompressionAlgorithm: TABSCompressionAlgorithm;
  FileWasChanged: Boolean;
begin
  Stream := TMemoryStream.Create;
  try
    FTableMetadataFile.GetFileSize(SessionID, CompressedSize,
                                   DecompressedSize, CompressionAlgorithm, FileWasChanged, True);
    Stream.Size := DecompressedSize;
    FTableMetadataFile.ReadFile(SessionID, TAbsPByte(Stream.Memory)^, DecompressedSize);
    Stream.Position := 0;
    FieldManager.LoadMetadata(Stream);
    IndexManager.LoadMetadata(Stream);
    ConstraintManager.LoadMetadata(Stream);
    TABSDiskRecordManager(RecordManager).LoadMetadata(Stream);
    FBlobManager.LoadMetadata(Stream);
  finally
    Stream.Free;
  end;
end;// LoadMetadataFile


//------------------------------------------------------------------------------
// SaveMetadataFile
//------------------------------------------------------------------------------
procedure TABSDiskTableData.SaveMetadataFile(SessionID: TABSSessionID);
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    FieldManager.SaveMetadata(Stream);
    IndexManager.SaveMetadata(Stream);
    ConstraintManager.SaveMetadata(Stream);
    TABSDiskRecordManager(RecordManager).SaveMetadata(Stream);
    FBlobManager.SaveMetadata(Stream);
    FTableMetadataFile.WriteFile(SessionID, TAbsPByte(Stream.Memory)^, Stream.Size,
                                   acaZLIB, 1);
  finally
    Stream.Free;
  end;
end;// SaveMetadataFile


//------------------------------------------------------------------------------
// CleanMostUpdated
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CleanMostUpdated(SessionID: TABSSessionID);
begin
  FTableMostUpdatedFile.InitFileHeader(SessionID);
end;


//------------------------------------------------------------------------------
// SaveMostUpdated
//------------------------------------------------------------------------------
procedure TABSDiskTableData.SaveMostUpdated(SessionID: TABSSessionID);
var
  Buf: TAbsPByte;
  BufSize: Integer;
  Offset: Integer;
begin
  BufSize := (FieldManager.FieldDefs.Count * sizeof(Int64) + 2*sizeof(Integer))*4;
  Buf := MemoryManager.GetMem(BufSize);
  Offset := 0;
  try
    FieldManager.SaveMostUpdated(Buf, Offset);
    TABSDiskRecordManager(RecordManager).SaveMostUpdated(Buf, Offset);
    if (Offset > BufSize) then
      raise EABSException.Create(20164, ErrorAInvalidTableHeaderData);
    FTableMostUpdatedFile.WriteFile(SessionID, Buf^, Offset);
    FLastUsedTableState := TABSDiskRecordManager(FRecordManager).TableState;
  finally
    MemoryManager.FreeAndNillMem(Buf);
  end;
end;// SaveMostUpdated


//------------------------------------------------------------------------------
// LoadMostUpdated
//------------------------------------------------------------------------------
procedure TABSDiskTableData.LoadMostUpdated(SessionID: TABSSessionID);
var
  Buf: TAbsPByte;
  BufSize: Integer;
  Offset: Integer;
  CompressedSize: Integer;
  CompressionAlgorithm: TABSCompressionAlgorithm;
  FileWasChanged: Boolean;
  SynchronizeAllowed: Boolean;
begin
  if (FTableMostUpdatedFile = nil) then
    raise EABSException.Create(20176, ErrorANilPointer);

  SynchronizeAllowed := not TABSDiskPageManager(PageManager).TablePagesCacheManager.GetIsMostUpdatedLoaded(SessionID, FTableID);
  FTableMostUpdatedFile.GetFileSize(SessionID, CompressedSize,
                                 BufSize, CompressionAlgorithm, FileWasChanged, SynchronizeAllowed);
  Buf := MemoryManager.GetMem(BufSize);
  Offset := 0;
  try
    FTableMostUpdatedFile.ReadFile(SessionID, Buf^, BufSize, FileWasChanged);
    FieldManager.LoadMostUpdated(Buf, Offset);
    TABSDiskRecordManager(FRecordManager).LoadMostUpdated(Buf, Offset);
    FLastUsedTableState := TABSDiskRecordManager(FRecordManager).TableState;
    TABSDiskPageManager(PageManager).TablePagesCacheManager.SetIsMostUpdatedLoaded(SessionID, FTableID, FLastUsedTableState);
  finally
    MemoryManager.FreeAndNillMem(Buf);
  end;
end;// LoadMostUpdated


//------------------------------------------------------------------------------
// GetDiskRecordBufferSize
//------------------------------------------------------------------------------
function TABSDiskTableData.GetDiskRecordBufferSize: Integer;
begin
 if (FFieldManager.FieldDefs.Count <= 0) then
  raise EABSException.Create(20142, ErrorLNoFields);
 Result := FFieldManager.FieldDefs.GetDiskRecordBufferSize;
end;// GetDiskRecordBufferSize


//------------------------------------------------------------------------------
// RebuildRecordPageIndex
//------------------------------------------------------------------------------
procedure TABSDiskTableData.RebuildRecordPageIndex(SessionID: TABSSessionID);
begin
  if (GetDiskRecordBufferSize < PageManager.PageDataSize) then
    TABSDiskRecordManager(FRecordManager).RebuildRecordPageIndex(SessionID)
  else
    raise EABSException.Create(10512, ErrorLCannotRepairTablePagesIndexForLargeRecordsTable, [FTableName]);
end;// RebuildRecordPageIndex


//------------------------------------------------------------------------------
// ValidateAndRepairMostUpdatedAndRecordPageIndex
//------------------------------------------------------------------------------
procedure TABSDiskTableData.ValidateAndRepairMostUpdatedAndRecordPageIndex(Cursor: TABSCursor);
begin
  try
    LoadMostUpdated(Cursor.Session.SessionID);
    ValidateRecordPageIndex(Cursor);
  except
    RebuildRecordPageIndex(Cursor.Session.SessionID);
    SaveMetadataFile(Cursor.Session.SessionID);
    CleanMostUpdated(Cursor.Session.SessionID);
    SaveMostUpdated(Cursor.Session.SessionID);
    ApplyChanges(Cursor.Session.SessionID, False);
  end;
end;// ValidateAndRepairMostUpdatedAndRecordPageIndex


//------------------------------------------------------------------------------
// ValidateRecordPageIndex
//------------------------------------------------------------------------------
procedure TABSDiskTableData.ValidateRecordPageIndex(Cursor: TABSCursor);
begin
  TABSDiskRecordManager(FRecordManager).ValidateRecordPageIndex(Cursor.Session.SessionID);
end;// ValidateRecordPageIndex


//------------------------------------------------------------------------------
// return filter bitmap rec count
//------------------------------------------------------------------------------
function TABSDiskTableData.GetBitmapRecordCount(SessionID: TABSSessionID): TABSRecordNo;
var
  LastRecordPageNo: TABSPageNo;
begin
  if (TABSDiskRecordManager(FRecordManager).RecordPageIndex.GetLastRecordPage(SessionID, LastRecordPageNo)) then
    Result := (LastRecordPageNo+1) * TABSDiskRecordManager(FRecordManager).FMaxRecordsOnPage
  else
    Result := 1; 
end;// GetBitmapRecordCount


//------------------------------------------------------------------------------
// return filter bitmap rec no by record id
//------------------------------------------------------------------------------
function TABSDiskTableData.GetBitmapRecNoByRecordID(RecordID: TABSRecordID): TABSRecordNo;
begin
  Result := RecordID.PageNo * TABSDiskRecordManager(FRecordManager).FMaxRecordsOnPage +
            RecordID.PageItemNo;
end;// GetBitmapRecNoByRecordID


//------------------------------------------------------------------------------
// return filter bitmap rec no by record id
//------------------------------------------------------------------------------
function TABSDiskTableData.GetRecordIDByBitmapRecNo(RecordNo: TABSRecordNo): TABSRecordID;
begin
  Result.PageNo := RecordNo div TABSDiskRecordManager(FRecordManager).FMaxRecordsOnPage;
  Result.PageItemNo := RecordNo mod TABSDiskRecordManager(FRecordManager).FMaxRecordsOnPage;
end;// GetRecordIDByBitmapRecNo


//------------------------------------------------------------------------------
// CreateRecordManager
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CreateRecordManager;
begin
 if (FRecordManager <> nil) then
   FRecordManager.Free;
 FRecordManager := TABSDiskRecordManager.Create(FPageManager, FFieldManager,
      FTableMostUpdatedFile, Self);
 TABSDiskRecordManager(FRecordManager).Init(GetRecordBufferSize,
                        GetDiskRecordBufferSize, FFieldManager.FieldDefs.Count);
end;// CreateRecordManager


//------------------------------------------------------------------------------
// CreateBlobManager
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CreateBlobManager;
begin
 if (FBlobManager <> nil) then
   FBlobManager.Free;
 FBlobManager := TABSDiskBlobManager.Create(FPageManager, FFieldManager, FRecordManager);
end;// CreateBlobManager


//------------------------------------------------------------------------------
// CreateFieldManager
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CreateFieldManager(FieldDefs: TABSFieldDefs);
begin
  if (FFieldManager <> nil) then
    FFieldManager.Free;
  FFieldManager := TABSBaseFieldManager.Create(Self);
  inherited CreateFieldManager(FieldDefs);
end;// CreateFieldManager


//------------------------------------------------------------------------------
// CreateIndexManager
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CreateIndexManager(IndexDefs: TABSIndexDefs);
begin
 if (FIndexManager <> nil) then
   FIndexManager.Free;
 if (FTemporaryPageManager <> nil) then
   FTemporaryPageManager.Free;
 FTemporaryPageManager := TABSTemporaryPageManager.Create(FDisableTempFiles);
 FIndexManager := TABSBaseIndexManager.Create(Self, FTemporaryPageManager);
 inherited CreateIndexManager(IndexDefs);
end;// CreateIndexManager


//------------------------------------------------------------------------------
// CreateConstraintManager
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CreateConstraintManager(ConstraintDefs: TABSConstraintDefs);
var
  i: Integer;
begin
 if (FConstraintManager <> nil) then
   FConstraintManager.Free;
  // Fill New ObjectIds
  FillDefsByObjectId(ConstraintDefs);
  // Set TableName to Constraits
  for i:=0 to ConstraintDefs.Count-1 do
   case ConstraintDefs[i].ConstraintType of
    ctNotNull:
      TABSConstraintDefNotNull(ConstraintDefs[i]).TableName := FTableName;
    ctCheck:
      TABSConstraintDefCheck(ConstraintDefs[i]).TableName := FTableName;
    ctPK:
      TABSConstraintDefPrimary(ConstraintDefs[i]).TableName := FTableName;
    ctUnique:
      TABSConstraintDefUnique(ConstraintDefs[i]).TableName := FTableName;
    else
      raise EABSException.Create(30040, ErrorGNotImplementedYet);
   end;
  // Create ConstraintManager
  FConstraintManager := TABSBaseConstraintManager.Create(Self);
  FConstraintManager.ConstraintDefs.Assign(ConstraintDefs);
  // Links ObjectIds
  FConstraintManager.LinkObjectIds;
  // Set enpty Names
  FConstraintManager.FillConstraintAutoNames;
end;// CreateConstraintManager


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDiskTableData.Create(aDatabaseData: TABSDatabaseData);
begin
  inherited Create(aDatabaseData);
  FPageManager := aDatabaseData.PageManager;
  FTemporaryPageManager := nil;
  FIsChangingTableList := False;
  FLastUsedTableState := -1;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDiskTableData.Destroy;
begin
  if (FTemporaryPageManager <> nil) then
    FreeAndNil(FTemporaryPageManager);
  if (FBlobManager <> nil) then
    FreeAndNil(FBlobManager);
  inherited Destroy;
end;// Destroy


//------------------------------------------------------------------------------
// FreeIfNoCursorsConnected
//------------------------------------------------------------------------------
procedure TABSDiskTableData.FreeIfNoCursorsConnected;
begin
  if ((FCursorList = nil) or (FCursorList.Count = 0)) then
    Free;
end;// FreeIfNoCursorsConnected


//------------------------------------------------------------------------------
// ApplyChanges
//------------------------------------------------------------------------------
procedure TABSDiskTableData.ApplyChanges(SessionID: TABSSessionID; InTransaction: Boolean);
begin
  inherited ApplyChanges(SessionID, InTransaction);
  //  always apply changes to reduce memory overhead on temp index creation
  FTemporaryPageManager.ApplyChanges(SessionID);
end;// ApplyChanges


//------------------------------------------------------------------------------
// CancelChanges
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CancelChanges(SessionID: TABSSessionID; InTransaction: Boolean);
begin
  inherited CancelChanges(SessionID, InTransaction);
  FTemporaryPageManager.CancelChanges(SessionID);
end;// CancelChanges


//------------------------------------------------------------------------------
// CreateTable
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CreateTable(
                      Cursor: TABSCursor;
                      FieldDefs: TABSFieldDefs;
                      IndexDefs: TABSIndexDefs;
                      ConstraintDefs: TABSConstraintDefs
                     );
begin
  Lock;
  try
    if (FieldDefs.Count <= 0) then
     raise EABSException.Create(20128, ErrorLNoFields);
    TableName := Cursor.TableName;
    FDisableTempFiles := Cursor.FDisableTempFiles;
    FTableID := FDatabaseData.GetNewObjectId;
    TABSDiskDatabaseData(FDatabaseData).LockTables;
    try
      try
        CreateTableFiles;
        try
          CreateFieldManager(FieldDefs);
          CreateIndexManager(IndexDefs);
          CreateConstraintManager(ConstraintDefs);
          CreateRecordManager;
          CreateBlobManager;

          SaveMostUpdated(SYSTEM_SESSION_ID);
          TABSDiskRecordManager(RecordManager).CreateRecordPageIndex;
          if (FFieldManager.BlobFieldsPresent) then
            FBlobManager.CreateBlobPageIndex;
          IndexManager.CreateIndexesByIndexDefs(nil);

          SaveMetadataFile(SYSTEM_SESSION_ID);

          TABSDiskDatabaseData(FDatabaseData).AddTable(FTableID,
                                 TableName,
                                 FTableMetadataFile.StartPageNo,
                                 FTableMostUpdatedFile.StartPageNo,
                                 FTableLocksFile.StartPageNo);
        finally
          FreeTableFiles;
        end;
        PageManager.ApplyChanges(SYSTEM_SESSION_ID);
      except
        PageManager.CancelChanges(SYSTEM_SESSION_ID);
        raise;
      end;
    finally
      TABSDiskDatabaseData(FDatabaseData).UnlockTables;
    end;
  finally
    Unlock;
  end;
end;// CreateTable


//------------------------------------------------------------------------------
// DeleteTable
//------------------------------------------------------------------------------
procedure TABSDiskTableData.DeleteTable(Cursor: TABSCursor; DesignMode: Boolean = False);
var
  OldExclusive: Boolean;
begin
  Lock;
  try
    inherited DeleteTable(Cursor, DesignMode);
    TABSDiskDatabaseData(FDatabaseData).LockTables;
    FIsChangingTableList := True;
    OldExclusive := Cursor.Exclusive;
    Cursor.Exclusive := True;
    try
      OpenTable(Cursor);
      try
        DeleteAllIndexes(nil);
        FBlobManager.Delete(SYSTEM_SESSION_ID);
        TABSDiskRecordManager(FRecordManager).Delete(SYSTEM_SESSION_ID);
        UnlockTable(Cursor.Session.SessionID, ltX);
        DeleteTableFiles;
        FreeTableFiles;
      finally
        CloseTable(Cursor);
        TABSDiskDatabaseData(FDatabaseData).RemoveTable(TableName);
        FPageManager.ApplyChanges(SYSTEM_SESSION_ID);
      end;
    finally
      FIsChangingTableList := False;
      Cursor.Exclusive := OldExclusive;
      TABSDiskDatabaseData(FDatabaseData).UnlockTables;
    end;
  finally
    Unlock;
  end;
end;// DeleteTable


//------------------------------------------------------------------------------
// EmptyTable
//------------------------------------------------------------------------------
procedure TABSDiskTableData.EmptyTable(Cursor: TABSCursor);
var
  OldExclusive: Boolean;
begin
  OldExclusive := Cursor.Exclusive;
  Lock;
  try
    Cursor.Exclusive := True;
    OpenTable(Cursor);
    try
      inherited EmptyTable(Cursor);
      FBlobManager.Empty(Cursor.Session.SessionID);
      FRecordManager.Empty(Cursor.Session.SessionID);
      SaveMostUpdated(Cursor.Session.SessionID);
      ApplyChanges(Cursor.Session.SessionID, Cursor.Session.InTransaction);
     finally
      CloseTable(Cursor);
     end;
   finally
    Cursor.Exclusive := OldExclusive;
    Unlock;
   end;
end;// EmptyTable


//------------------------------------------------------------------------------
// RenameTable
//------------------------------------------------------------------------------
procedure TABSDiskTableData.RenameTable(NewTableName: string; Cursor: TABSCursor);
var
  OldExclusive: Boolean;
begin
  TABSDiskDatabaseData(FDatabaseData).LockTables;
  OldExclusive := Cursor.Exclusive;
  try
    Cursor.Exclusive := True;
    FIsChangingTableList := True;
    try
      OpenTable(Cursor);
      CloseTable(Cursor);
    finally
      FIsChangingTableList := False;
    end;
    try
      TABSDiskDatabaseData(FDatabaseData).RenameTable(TableName, NewTableName);
      PageManager.ApplyChanges(SYSTEM_SESSION_ID);
    finally
    end;
  finally
    Cursor.Exclusive := OldExclusive;
    TABSDiskDatabaseData(FDatabaseData).UnlockTables;
  end;
end;// RenameTable


//------------------------------------------------------------------------------
// OpenTable
//------------------------------------------------------------------------------
procedure TABSDiskTableData.OpenTable(Cursor: TABSCursor);
var
  MetadataFilePageNo, MostUpdatedFilePageNo, LocksFilePageNo: TABSPageNo;
begin
  Lock;
  try
    if (not FIsChangingTableList) then
      TABSDiskDatabaseData(FDatabaseData).LockTables;
    try
      // check if exlusive cursor connects to non-exclusively open tabledata
      if ((FCursorList.Count > 0) and (Cursor.Exclusive) and (not FExclusive)) then
        raise EABSException.Create(20242, ErrorACannotReopenTableInExclusiveMode, [FTableName]);

      if (FCursorList.Count = 0) then
        begin
          FDisableTempFiles := Cursor.FDisableTempFiles;
          TABSDiskDatabaseData(FDatabaseData).OpenTable(TableName,
                                  FTableID,
                                  MetadataFilePageNo,
                                  MostUpdatedFilePageNo,
                                  LocksFilePageNo);
          OpenTableFiles(MetadataFilePageNo, MostUpdatedFilePageNo, LocksFilePageNo);

          FFieldManager := TABSBaseFieldManager.Create(Self);
          FTemporaryPageManager := TABSTemporaryPageManager.Create(FDisableTempFiles);
          FIndexManager := TABSBaseIndexManager.Create(Self, FTemporaryPageManager);
          FConstraintManager := TABSBaseConstraintManager.Create(Self);
          FRecordManager := TABSDiskRecordManager.Create(FPageManager,
                                  FFieldManager, FTableMostUpdatedFile, Self);
          FBlobManager := TABSDiskBlobManager.Create(FPageManager, FFieldManager, FRecordManager);
          LoadMetadataFile(Cursor.Session.SessionID);
          TABSDiskRecordManager(FRecordManager).Init(GetRecordBufferSize,
                                GetDiskRecordBufferSize, FFieldManager.FieldDefs.Count);
          if (not IsRepairing) then
            // in single-user mode - load only once
            LoadMostUpdated(Cursor.Session.SessionID)
          else
            ValidateAndRepairMostUpdatedAndRecordPageIndex(Cursor);
          FExclusive := Cursor.Exclusive;
        end;

      FCursorList.Add(Cursor);

      if (Cursor.Exclusive) then
        begin
          if (not LockTable(Cursor.Session.SessionID, ltX, OpenTableLockRetries, OpenTableLockDelay)) then
              raise EABSException.Create(20208, ErrorACannotOpenTableInExclusiveMode, [FTableName])
        end
      else
        begin
          if (not LockTable(Cursor.Session.SessionID, ltIS, OpenTableLockRetries, OpenTableLockDelay)) then
            raise EABSException.Create(20209, ErrorACannotOpenLockedTable, [FTableName]);
        end;
      Cursor.TableLockedByCursor := True;
    finally
      if (not FIsChangingTableList) then
        TABSDiskDatabaseData(FDatabaseData).UnlockTables;
    end;
  finally
    Unlock;
  end;
end;// OpenTable


//------------------------------------------------------------------------------
// CloseTable
//------------------------------------------------------------------------------
procedure TABSDiskTableData.CloseTable(Cursor: TABSCursor);
begin
  Lock;
  try
    if (FCursorList <> nil) then
      begin
        if (FCursorList.IndexOf(Cursor) <> -1) then
          if (FTableLocksFile <> nil) then
            if (Cursor.TableLockedByCursor) then
              begin
                if (Cursor.Exclusive) then
                  UnlockTable(Cursor.Session.SessionID, ltX)
                else
                  UnlockTable(Cursor.Session.SessionID, ltIS);
                Cursor.TableLockedByCursor := False;
              end;
        FCursorList.Remove(Cursor);
        if (FCursorList.Count = 0) then
          begin
            { unnecessary but very slow
            if (FIndexManager <> nil) then
              if (Cursor <> nil) then
                begin
                  FIndexManager.DropTemporaryIndexes(Cursor.Session.SessionID);
                  ApplyChanges(Cursor.Session.SessionID, Cursor.Session.InTransaction);
                end
              else
                FIndexManager.DropTemporaryIndexes(SYSTEM_SESSION_ID);
            }
            if (FRecordManager <> nil) then
              FRecordManager.Free;
            FRecordManager := nil;
            if (FConstraintManager <> nil) then
              FConstraintManager.Free;
            FConstraintManager := nil;
            if (FTemporaryPageManager <> nil) then
              FreeAndNil(FTemporaryPageManager);
            if (FIndexManager <> nil) then
              FIndexManager.Free;
            FIndexManager := nil;
            if (FFieldManager <> nil) then
              FFieldManager.Free;
            FFieldManager := nil;
            if (FBlobManager <> nil) then
             FBlobManager.Free;
            FBlobManager := nil;
            FCursorList.Free;
            FCursorList := nil;
            FreeTableFiles;
          end;
      end;
  finally
    Unlock;
  end;
end;// CloseTable


//------------------------------------------------------------------------------
// RenameField
//------------------------------------------------------------------------------
procedure TABSDiskTableData.RenameField(FieldName, NewFieldName: string);
begin
  Lock;
  try
    inherited RenameField(FieldName, NewFieldName);
    SaveMetadataFile(SYSTEM_SESSION_ID);
    PageManager.ApplyChanges(SYSTEM_SESSION_ID);
  finally
    Unlock;
  end;
end;// RenameField


//------------------------------------------------------------------------------
// AddIndex
//------------------------------------------------------------------------------
procedure TABSDiskTableData.AddIndex(IndexDef: TABSIndexDef; Cursor: TABSCursor);
begin
  Lock;
  try
    inherited AddIndex(IndexDef, Cursor);
    SaveMetadataFile(Cursor.Session.SessionID);
    ApplyChanges(Cursor.Session.SessionID, Cursor.Session.InTransaction);
  finally
    Unlock;
  end;
end;// AddIndex


//------------------------------------------------------------------------------
// DeleteIndex
//------------------------------------------------------------------------------
procedure TABSDiskTableData.DeleteIndex(IndexID: TABSObjectID; Cursor: TABSCursor);
var
  IndexDef: TABSIndexDef;
  TempIndex: Boolean;
begin
  Lock;
  try
    IndexDef := TABSIndexDef(FIndexManager.IndexDefs.GetDefByObjectID(IndexID));
    TempIndex := IndexDef.Temporary;
    inherited DeleteIndex(IndexID, Cursor);
    if (Cursor <> nil) then
      begin
        if (not TempIndex) then
          SaveMetadataFile(Cursor.Session.SessionID);
        ApplyChanges(Cursor.Session.SessionID, Cursor.Session.InTransaction);
      end;
  finally
    Unlock;
  end;
end;// DeleteIndex


//------------------------------------------------------------------------------
// WriteBLOBFieldToRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskTableData.WriteBLOBFieldToRecordBuffer(
          Cursor:     TABSCursor;
          FieldNo:    Integer;
          BLOBStream: TABSStream
          );
begin
  Lock;
  try
    FBlobManager.CopyBlobFromStreamToRecordBuffer(Cursor.CurrentRecordBuffer,
                                                  FieldNo, BLOBStream);
  finally
    Unlock;
  end;
end;// WriteBLOBFieldToRecordBuffer


//------------------------------------------------------------------------------
// ClearBLOBFieldInRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskTableData.ClearBLOBFieldInRecordBuffer(
                   RecordBuffer: TABSRecordBuffer;
                   FieldNo:    Integer);
begin
  Lock;
  try
    FBlobManager.ClearBlobInRecordBuffer(RecordBuffer, FieldNo);
  finally
    Unlock;
  end;
end;// ClearBLOBFieldInRecordBuffer


//------------------------------------------------------------------------------
// ClearModifiedBLOBFieldInRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskTableData.ClearModifiedBLOBFieldsInRecordBuffer(
                                             RecordBuffer: TABSRecordBuffer);
var i: Integer;
begin
  Lock;
  try
    if (FFieldManager.BlobFieldsPresent) then
      for i := 0 to FieldManager.FieldDefs.Count - 1 do
        if (IsBLOBFieldType(FieldManager.FieldDefs[i].BaseFieldType)) then
          FBlobManager.ClearBlobInRecordBuffer(RecordBuffer, i, True);
  finally
    Unlock;
  end;
end;// ClearModifiedBLOBFieldInRecordBuffer


//------------------------------------------------------------------------------
// InternalCreateBlobStream
//------------------------------------------------------------------------------
function TABSDiskTableData.InternalCreateBlobStream(
          Cursor:   TABSCursor;
          ToInsert: Boolean;
          FieldNo:  Integer;
          OpenMode: TABSBLOBOpenMode
          ): TABSStream;
var
  TempStream:             TABSTemporaryStream;
  CompressedStream:       TABSCompressedBLOBStream;
  BLOBDescriptor:         TABSBLOBDescriptor;
begin
 Lock;
 try
   Result := nil;
   BLOBDescriptor.CompressionAlgorithm :=
       Byte(FieldManager.FieldDefs[FieldNo].BLOBCompressionAlgorithm);
   BLOBDescriptor.CompressionMode := FieldManager.FieldDefs[FieldNo].BLOBCompressionMode;
   BLOBDescriptor.BlockSize := FieldManager.FieldDefs[FieldNo].BLOBBlockSize;
   if (BLOBDescriptor.BlockSize = 0) then
    raise EABSException.Create(20149, ErrorLZeroBlockSizeIsNotAllowed);
   BLOBDescriptor.StartPosition := 0;
   TempStream := TABSTemporaryStream.Create(FDisableTempFiles);
   // create new compressed stream
   if ((ToInsert and (OpenMode = bomWrite)) or (OpenMode = bomWrite) or
       (Cursor.CurrentRecordBuffer = nil) or
       (CheckNullFlag(FieldNo,Cursor.CurrentRecordBuffer))) then
    begin
     // empty stream
     BLOBDescriptor.NumBlocks := 0;
     BLOBDescriptor.UncompressedSize := 0;
     CompressedStream := TABSCompressedBLOBStream.Create(TempStream,
      BLOBDescriptor,True);
     Result := TABSLocalBLOBStream.Create(CompressedStream,Cursor,OpenMode,FieldNo);
    end // empty stream
   else
    begin
     // copy value from TableData
     try
       FBlobManager.CopyBlobFromRecordBufferToStream(Cursor.Session.SessionID,
            Cursor.CurrentRecordBuffer, FieldNo, BLOBDescriptor, TempStream);
       TempStream.Position := 0;
       CompressedStream := TABSCompressedBLOBStream.Create(TempStream, BLOBDescriptor,False);
       if (BLOBDescriptor.UncompressedSize < 0) then
        raise EABSException.Create(20248, ErrorAInvalidBlobFieldSize);
     except
       FBlobManager.FreeBlobCache(Cursor.CurrentRecordBuffer, FieldNo, True);
       TempStream.Free;
       raise;
     end;
     Result := TABSLocalBLOBStream.Create(CompressedStream,Cursor,OpenMode,FieldNo);
    end; // copy value from TableData
 finally
  Unlock;
 end;
end;// InternalCreateBlobStream


//------------------------------------------------------------------------------
// GetDirectBlobData
//------------------------------------------------------------------------------
procedure TABSDiskTableData.GetDirectBlobData(
              Cursor:     TABSCursor;
              FieldNo:    Integer;
              RecordBuffer: TABSRecordBuffer;
              var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
              var pBlobData: TAbsPByte);
begin
 Lock;
 try
  FBlobManager.GetDirectBlobInfoFromRecordBuffer(Cursor.Session.SessionID,RecordBuffer,FieldNo,BLOBDescriptor,pBlobData);
 finally
  Unlock;
 end;
end;// GetDirectBlobData


//------------------------------------------------------------------------------
// SetDirectBlobData
//------------------------------------------------------------------------------
procedure TABSDiskTableData.SetDirectBlobData(
              Cursor:     TABSCursor;
              FieldNo:    Integer;
              RecordBuffer: TABSRecordBuffer;
              var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
              var pBlobData: TAbsPByte);
begin
 Lock;
 try
  FBlobManager.SetDirectBlobInfoFromRecordBuffer(Cursor.Session.SessionID,RecordBuffer,FieldNo,BLOBDescriptor,pBlobData);
 finally
  Unlock;
 end;
end;// SetDirectBlobData


//------------------------------------------------------------------------------
// FreeDirectBlobData
//------------------------------------------------------------------------------
procedure TABSDiskTableData.FreeDirectBlobData(
              Cursor:     TABSCursor;
              FieldNo:    Integer;
              RecordBuffer: TABSRecordBuffer;
              var BLOBDescriptor: TABSPartialTemporaryBLOBDescriptor;
              var pBlobData: TAbsPByte);
begin
 Lock;
 try
  FBlobManager.FreeBlobCache(RecordBuffer, FieldNo);
 finally
  Unlock;
 end;
end;// FreeDirectBlobData


//------------------------------------------------------------------------------
// InsertRecord
//------------------------------------------------------------------------------
function TABSDiskTableData.InsertRecord(var Cursor: TABSCursor): Boolean;
var
  IsTempIndexChanged: Boolean;
begin
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog('TABSDiskTableData.InsertRecord started: SessionID='+IntToStr(Cursor.Session.SessionID));
{$ENDIF}
 Result := False;
 Lock;
 try
  if (FRecordManager = nil) then
   raise EABSException.Create(20135, ErrorLNilPointer);
  if (Cursor.CurrentRecordBuffer = nil) then
   raise EABSException.Create(20136, ErrorLNilPointer);

{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    FIndexManager.SynchronizeTemporaryIndexes(Cursor, IsTempIndexChanged);
{$ENDIF}
  // write modified BLOB fields
  FBlobManager.WriteBlobs(Cursor.Session.SessionID, Cursor.CurrentRecordBuffer);
  // add record to first empty space
  Result := FRecordManager.AddRecord(Cursor.Session.SessionID,
                             Cursor.CurrentRecordBuffer,Cursor.CurrentRecordID);
  if (Result) then
   begin
     if (TABSRecordBitmap(Cursor.RecordBitmap).Active) then
      begin
        if (IsRecordVisible(Cursor)) then
         TABSRecordBitmap(Cursor.RecordBitmap).ShowRecord(Cursor.CurrentRecordID)
        else
         TABSRecordBitmap(Cursor.RecordBitmap).HideRecord(Cursor.CurrentRecordID);
      end;
     FIndexManager.InsertRecord(Cursor);
     Cursor.FirstPosition := False;
     Cursor.LastPosition := False;
     SaveMostUpdated(Cursor.Session.SessionID);
     if (not Cursor.InBatchUpdate) then
       ApplyChanges(Cursor.Session.SessionID, Cursor.Session.InTransaction);
   end;
 finally
  Unlock;
 end;
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog('TABSDiskTableData.InsertRecord finished: SessionID='+IntToStr(Cursor.Session.SessionID));
{$ENDIF}
end;// InsertRecord


//------------------------------------------------------------------------------
// DeleteRecord
//------------------------------------------------------------------------------
function TABSDiskTableData.DeleteRecord(Cursor: TABSCursor): Boolean;
var
  RecordID:    TABSRecordID;
  NewRecordID: TABSRecordID;
  Buffer:      TABSRecordBuffer;
  TempBuffer:  TABSRecordBuffer;
  OldPos:      Pointer;
  IsLastRecordToDelete: Boolean;
  PrevTableState: Integer;
  IsTempIndexChanged: Boolean;
begin
 Result := False;
 Lock;
 try
  if (FRecordManager = nil) then
   raise EABSException.Create(20137, ErrorLNilPointer);
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      LoadMostUpdated(Cursor.Session.SessionID);
      FIndexManager.SynchronizeTemporaryIndexes(Cursor, IsTempIndexChanged);
    end;
{$ENDIF}
  RecordID := Cursor.CurrentRecordID;
  Buffer := Cursor.CurrentRecordBuffer;
  TempBuffer := Cursor.AllocateRecordBuffer;
  OldPos := Cursor.SavePosition;
  try
   Cursor.CurrentRecordBuffer := TempBuffer;
   IsLastRecordToDelete := False;
   if (GetRecordBuffer(Cursor, grmNext) = grrOK) then
     NewRecordID := Cursor.CurrentRecordID
   else
    begin
      Cursor.RestorePosition(OldPos);
      if (GetRecordBuffer(Cursor, grmPrior) = grrOK) then
        NewRecordID := Cursor.CurrentRecordID
      else
        IsLastRecordToDelete := True;
    end;
   Cursor.RestorePosition(OldPos);
   Cursor.CurrentRecordBuffer := Buffer;
   Cursor.CurrentRecordID := RecordID;
  finally
   Cursor.FreePosition(OldPos);
   Cursor.FreeRecordBuffer(TempBuffer);
  end;
  // clear blob fields cache
  ClearBLOBFieldsInRecordBuffer(Cursor.CurrentRecordBuffer);
  // delete BLOB fields
  FBlobManager.DeleteBlobs(Cursor.Session.SessionID, Cursor.CurrentRecordBuffer);
  FIndexManager.DeleteRecord(Cursor);
  PrevTableState := FRecordManager.TableState;
  Result := FRecordManager.DeleteRecord(Cursor.Session.SessionID, RecordID);
  if (Result) then
   begin
    SaveMostUpdated(Cursor.Session.SessionID);
    if (not Cursor.InBatchUpdate) then
      ApplyChanges(Cursor.Session.SessionID, Cursor.Session.InTransaction);
    if (TABSRecordBitmap(Cursor.RecordBitmap).Active) then
      begin
        TABSRecordBitmap(Cursor.RecordBitmap).HideRecord(Cursor.CurrentRecordID);
        if (PrevTableState = TABSRecordBitmap(Cursor.RecordBitmap).TableState) and (not Cursor.IsDistinctApplied) then
          TABSRecordBitmap(Cursor.RecordBitmap).TableState := FRecordManager.TableState;
      end;
    if (IsLastRecordToDelete) then
     begin
      Cursor.FirstPosition := True;
      Cursor.LastPosition := False;
     end
    else
     begin
      Cursor.FirstPosition := False;
      Cursor.LastPosition := False;
      Cursor.CurrentRecordID := NewRecordID;
     end;
   end;
 finally
   Unlock;
 end;
end;// DeleteRecord


//------------------------------------------------------------------------------
// UpdateRecord
//------------------------------------------------------------------------------
function TABSDiskTableData.UpdateRecord(Cursor: TABSCursor): Boolean;
var
  IsTempIndexChanged: Boolean;
begin
 Result := False;
 Lock;
 try
  if (FRecordManager = nil) then
   raise EABSException.Create(20138, ErrorLNilPointer);
  if (Cursor.CurrentRecordBuffer = nil) then
   raise EABSException.Create(20139, ErrorLNilPointer);
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      LoadMostUpdated(Cursor.Session.SessionID);
      FIndexManager.SynchronizeTemporaryIndexes(Cursor, IsTempIndexChanged);
    end;
{$ENDIF}
  FIndexManager.UpdateRecord(Cursor, True);
  // write modified BLOB fields
  FBlobManager.WriteBlobs(Cursor.Session.SessionID, Cursor.CurrentRecordBuffer);
  Result := FRecordManager.UpdateRecord(Cursor.Session.SessionID,
                            Cursor.CurrentRecordBuffer, Cursor.CurrentRecordID);
  FIndexManager.UpdateRecord(Cursor, False);
  if (Result) then
   begin
     if (TABSRecordBitmap(Cursor.RecordBitmap).Active) then
      begin
        if (IsRecordVisible(Cursor)) then
         TABSRecordBitmap(Cursor.RecordBitmap).ShowRecord(Cursor.CurrentRecordID)
        else
         TABSRecordBitmap(Cursor.RecordBitmap).HideRecord(Cursor.CurrentRecordID);
      end;
     SaveMostUpdated(Cursor.Session.SessionID);
     if (not Cursor.InBatchUpdate) then
       ApplyChanges(Cursor.Session.SessionID, Cursor.Session.InTransaction);
   end;
 finally
  Unlock;
 end;
end;// UpdateRecord


//------------------------------------------------------------------------------
// ClearBlobsCacheInRecordBuffer
//------------------------------------------------------------------------------
procedure TABSDiskTableData.ClearBlobsCacheInRecordBuffer(Buffer: TABSRecordBuffer);
begin
 Lock;
 try
  ClearBLOBFieldsInRecordBuffer(Buffer);
 finally
  Unlock;
 end;
end;// ClearBlobsCacheInRecordBuffer


//------------------------------------------------------------------------------
// GetRecordBuffer
//------------------------------------------------------------------------------
function TABSDiskTableData.GetRecordBuffer(
                          Cursor:         TABSCursor;
                          GetRecordMode:  TABSGetRecordMode
                        ): TABSGetRecordResult;
{$IFDEF FILE_SERVER_VERSION}
var
  IsTempIndexChanged: Boolean;
{$ENDIF}
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Lock;
      try
        if (LockTable(Cursor.Session.SessionID, ltS, GetRecordTableLockRetries, GetRecordTableLockDelay)) then
          begin
            try
              LoadMostUpdated(Cursor.Session.SessionID);
              TABSDiskPageManager(PageManager).TablePagesCacheManager.BeginWorkWithTable(
                 Cursor.Session.SessionID, FTableID);
              try
                FIndexManager.SynchronizeTemporaryIndexes(Cursor, IsTempIndexChanged);
                if (IsTempIndexChanged) then
                  FTemporaryPageManager.ApplyChanges(Cursor.Session.SessionID);
                Result := inherited GetRecordBuffer(Cursor, GetRecordMode);
              finally
                TABSDiskPageManager(PageManager).TablePagesCacheManager.EndWorkWithTable(
                   Cursor.Session.SessionID, FTableID);
              end;
            finally
              UnlockTable(Cursor.Session.SessionID, ltS);
            end;
          end
         else
           Result := grrError;
      finally
        Unlock;
      end;
    end
  else
{$ENDIF}
    Result := inherited GetRecordBuffer(Cursor, GetRecordMode);
end;// GetRecordBuffer


//------------------------------------------------------------------------------
// Locate
//------------------------------------------------------------------------------
function TABSDiskTableData.Locate(Cursor: TABSCursor; SearchExpression: TABSExpression): Boolean;
{$IFDEF FILE_SERVER_VERSION}
var
  IsTempIndexChanged: Boolean;
{$ENDIF}
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Lock;
      try
        if (LockTable(Cursor.Session.SessionID, ltS, SearchTableLockRetries, SearchTableLockDelay)) then
          begin
            try
              LoadMostUpdated(Cursor.Session.SessionID);
              TABSDiskPageManager(PageManager).TablePagesCacheManager.BeginWorkWithTable(
                 Cursor.Session.SessionID, FTableID);
              try
                FIndexManager.SynchronizeTemporaryIndexes(Cursor, IsTempIndexChanged);
                if (IsTempIndexChanged) then
                  FTemporaryPageManager.ApplyChanges(Cursor.Session.SessionID);
                Result := inherited Locate(Cursor, SearchExpression);
              finally
                TABSDiskPageManager(PageManager).TablePagesCacheManager.EndWorkWithTable(
                   Cursor.Session.SessionID, FTableID);
              end;
            finally
              UnlockTable(Cursor.Session.SessionID, ltS);
            end;
          end
        else
          raise EABSException.Create(20214, ErrorATableLocked);
      finally
        Unlock;
      end;
    end
  else
{$ENDIF}
    Result := inherited Locate(Cursor, SearchExpression);
end;// Locate


//------------------------------------------------------------------------------
// FindKey
//------------------------------------------------------------------------------
function TABSDiskTableData.FindKey(Cursor: TABSCursor; SearchCondition: TABSSearchCondition): Boolean;
{$IFDEF FILE_SERVER_VERSION}
var
  IsTempIndexChanged: Boolean;
{$ENDIF}
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Lock;
      try
        if (LockTable(Cursor.Session.SessionID, ltS, SearchTableLockRetries, SearchTableLockDelay)) then
          begin
            try
              LoadMostUpdated(Cursor.Session.SessionID);
              TABSDiskPageManager(PageManager).TablePagesCacheManager.BeginWorkWithTable(
                 Cursor.Session.SessionID, FTableID);
              try
                FIndexManager.SynchronizeTemporaryIndexes(Cursor, IsTempIndexChanged);
                if (IsTempIndexChanged) then
                  FTemporaryPageManager.ApplyChanges(Cursor.Session.SessionID);
                Result := inherited FindKey(Cursor, SearchCondition);
              finally
                TABSDiskPageManager(PageManager).TablePagesCacheManager.EndWorkWithTable(
                   Cursor.Session.SessionID, FTableID);
              end;
            finally
              UnlockTable(Cursor.Session.SessionID, ltS);
            end;
          end
        else
          raise EABSException.Create(20215, ErrorATableLocked);
      finally
        Unlock;
      end;
    end
  else
{$ENDIF}
    Result := inherited FindKey(Cursor, SearchCondition);
end;// FindKey


//------------------------------------------------------------------------------
// SetRecNo
//------------------------------------------------------------------------------
procedure TABSDiskTableData.SetRecNo(Cursor: TABSCursor; RecNo: TABSRecordNo);
{$IFDEF FILE_SERVER_VERSION}
var
  IsTempIndexChanged: Boolean;
{$ENDIF}
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Lock;
      try
        if (LockTable(Cursor.Session.SessionID, ltS, SearchTableLockRetries, SearchTableLockDelay)) then
          begin
            try
              LoadMostUpdated(Cursor.Session.SessionID);
              TABSDiskPageManager(PageManager).TablePagesCacheManager.BeginWorkWithTable(
                 Cursor.Session.SessionID, FTableID);
              try
                FIndexManager.SynchronizeTemporaryIndexes(Cursor, IsTempIndexChanged);
                if (IsTempIndexChanged) then
                  FTemporaryPageManager.ApplyChanges(Cursor.Session.SessionID);
                inherited SetRecNo(Cursor, RecNo);
              finally
                TABSDiskPageManager(PageManager).TablePagesCacheManager.EndWorkWithTable(
                   Cursor.Session.SessionID, FTableID);
              end;
            finally
              UnlockTable(Cursor.Session.SessionID, ltS);
            end;
          end
        else
          raise EABSException.Create(20216, ErrorATableLocked);
      finally
        Unlock;
      end;
    end
  else
{$ENDIF}
    inherited SetRecNo(Cursor, RecNo);
end;// SetRecNo


//------------------------------------------------------------------------------
// GetRecNo
//------------------------------------------------------------------------------
function TABSDiskTableData.GetRecNo(Cursor: TABSCursor): TABSRecordNo;
{$IFDEF FILE_SERVER_VERSION}
var
  IsTempIndexChanged: Boolean;
{$ENDIF}
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Lock;
      try
        if (LockTable(Cursor.Session.SessionID, ltS, SearchTableLockRetries, SearchTableLockDelay)) then
          begin
            try
              LoadMostUpdated(Cursor.Session.SessionID);
              TABSDiskPageManager(PageManager).TablePagesCacheManager.BeginWorkWithTable(
                 Cursor.Session.SessionID, FTableID);
              try
                FIndexManager.SynchronizeTemporaryIndexes(Cursor, IsTempIndexChanged);
                if (IsTempIndexChanged) then
                  FTemporaryPageManager.ApplyChanges(Cursor.Session.SessionID);
                Result := inherited GetRecNo(Cursor);
              finally
                TABSDiskPageManager(PageManager).TablePagesCacheManager.EndWorkWithTable(
                   Cursor.Session.SessionID, FTableID);
              end;
            finally
              UnlockTable(Cursor.Session.SessionID, ltS);
            end;
          end
        else
          raise EABSException.Create(20217, ErrorATableLocked);
      finally
        Unlock;
      end
    end
  else
{$ENDIF}
    Result := inherited GetRecNo(Cursor);
end;// GetRecNo


//------------------------------------------------------------------------------
// InternalGetRecordCount
//------------------------------------------------------------------------------
function TABSDiskTableData.InternalGetRecordCount(Cursor: TABSCursor): TABSRecordNo;
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Lock;
      try
        if (LockTable(Cursor.Session.SessionID, ltS, SearchTableLockRetries, SearchTableLockDelay)) then
          begin
            try
              LoadMostUpdated(Cursor.Session.SessionID);
              Result := FRecordManager.RecordCount;
            finally
              UnlockTable(Cursor.Session.SessionID, ltS);
            end;
          end
        else
          raise EABSException.Create(20218, ErrorATableLocked);
      finally
        Unlock;
      end
    end
  else
{$ENDIF}
    Result := FRecordManager.RecordCount;
end;// InternalGetRecordCount


//------------------------------------------------------------------------------
// InternalSetRecNo
//------------------------------------------------------------------------------
// move cursor to specified position and set current record id in cursor
procedure TABSDiskTableData.InternalSetRecNo(Cursor: TABSCursor; RecNo: TABSRecordNo);
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Lock;
      try
        if (LockTable(Cursor.Session.SessionID, ltS, SearchTableLockRetries, SearchTableLockDelay)) then
          begin
            try
              LoadMostUpdated(Cursor.Session.SessionID);
              TABSDiskPageManager(PageManager).TablePagesCacheManager.BeginWorkWithTable(
                 Cursor.Session.SessionID, FTableID);
              try
                TABSDiskRecordManager(FRecordManager).SetRecNo(Cursor.Session.SessionID,
                                                               RecNo, Cursor.CurrentRecordID);
              finally
                TABSDiskPageManager(PageManager).TablePagesCacheManager.EndWorkWithTable(
                   Cursor.Session.SessionID, FTableID);
              end;
            finally
              UnlockTable(Cursor.Session.SessionID, ltS);
            end;
          end
        else
          raise EABSException.Create(20219, ErrorATableLocked);
      finally
        Unlock;
      end;
    end
  else
{$ENDIF}
    TABSDiskRecordManager(FRecordManager).SetRecNo(Cursor.Session.SessionID,
                                                   RecNo, Cursor.CurrentRecordID);
end;// InternalSetRecNo


//------------------------------------------------------------------------------
// InternalGetRecNo
//------------------------------------------------------------------------------
// get current record position from cursor
function TABSDiskTableData.InternalGetRecNo(Cursor: TABSCursor): TABSRecordNo;
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Lock;
      try
        if (LockTable(Cursor.Session.SessionID, ltS, SearchTableLockRetries, SearchTableLockDelay)) then
          begin
            try
              LoadMostUpdated(Cursor.Session.SessionID);
              TABSDiskPageManager(PageManager).TablePagesCacheManager.BeginWorkWithTable(
                 Cursor.Session.SessionID, FTableID);
              try
                TABSDiskRecordManager(FRecordManager).GetRecNo(Cursor.Session.SessionID,
                                                              Cursor.CurrentRecordID, Result);
              finally
                TABSDiskPageManager(PageManager).TablePagesCacheManager.EndWorkWithTable(
                   Cursor.Session.SessionID, FTableID);
              end;
            finally
              UnlockTable(Cursor.Session.SessionID, ltS);
            end;
          end
        else
          raise EABSException.Create(20220, ErrorATableLocked);
      finally
        Unlock;
      end;
    end
  else
{$ENDIF}
    TABSDiskRecordManager(FRecordManager).GetRecNo(Cursor.Session.SessionID,
                                                   Cursor.CurrentRecordID, Result);
end;// InternalGetRecNo


//------------------------------------------------------------------------------
// LastAutoincValue
//------------------------------------------------------------------------------
function TABSDiskTableData.LastAutoincValue(FieldNo: Integer; Session: TABSBaseSession): Int64;
begin
  Result := FFieldManager.GetLastAutoinc(Session, FieldNo);
end;// LastAutoincValue


//------------------------------------------------------------------------------
// Rollback
//------------------------------------------------------------------------------
procedure TABSDiskTableData.Rollback(SessionID: TABSSessionID);
begin
  LoadMostUpdated(SessionID);
  FTemporaryPageManager.CancelChanges(SessionID);
  inherited Rollback(SessionID);
  FTemporaryPageManager.ApplyChanges(SessionID);
end;// Rollback


//------------------------------------------------------------------------------
// LockTable
//------------------------------------------------------------------------------
function TABSDiskTableData.LockTable(SessionID: TABSSessionID; LockType: TABSLockType;
                                     TryCount, Delay: Integer;
                                     AllowXIRWAfterSIRW: Boolean = True): Boolean;
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Result := TABSDiskDatabaseData(FDatabaseData).FTableLockManager.LockTable(
                              SessionID, LockType, FTableLocksFile, TryCount, Delay, False, AllowXIRWAfterSIRW);
      if (Result) then
        if (LockType = ltS) then
          TABSDiskPageManager(PageManager).TablePagesCacheManager.TableIsSLocked(SessionID, FTableID)
        else
        if (LockType = ltRW) then
          TABSDiskPageManager(PageManager).TablePagesCacheManager.TableIsRWLocked(SessionID, FTableID);
    end
  else
{$ENDIF}
    Result := True;
end;// LockTable


//------------------------------------------------------------------------------
// UnlockTable
//------------------------------------------------------------------------------
function TABSDiskTableData.UnlockTable(SessionID: TABSSessionID;
                LockType: TABSLockType; IgnoreIfNoLock: Boolean=False): Boolean;
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    begin
      Result := TABSDiskDatabaseData(FDatabaseData).FTableLockManager.UnlockTable(
                              SessionID, LockType, FTableLocksFile, IgnoreIfNoLock);
      if (Result) then
        if (LockType = ltS) then
          TABSDiskPageManager(PageManager).TablePagesCacheManager.TableIsSUnlocked(SessionID, FTableID)
        else
        if (LockType = ltRW) then
          TABSDiskPageManager(PageManager).TablePagesCacheManager.TableIsRWUnlocked(SessionID, FTableID);
    end
  else
{$ENDIF}
    Result := True;
end;// UnlockTable


//------------------------------------------------------------------------------
// LockRecord
//------------------------------------------------------------------------------
function TABSDiskTableData.LockRecord(SessionID: TABSSessionID; RecordID: TABSRecordID;
                                     TryCount, Delay: Integer): Boolean;
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
    Result := TABSDiskDatabaseData(FDatabaseData).FTableLockManager.LockRecord(
                            SessionID, FTableLocksFile, RecordID, TryCount, Delay)
  else
{$ENDIF}
    Result := True;
end;// LockRecord


//------------------------------------------------------------------------------
// UnlockRecord
//------------------------------------------------------------------------------
function TABSDiskTableData.UnlockRecord(SessionID: TABSSessionID; RecordID: TABSRecordID): Boolean;
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
      Result := TABSDiskDatabaseData(FDatabaseData).FTableLockManager.UnlockRecord(
                              SessionID, FTableLocksFile, RecordID)
  else
{$ENDIF}
    Result := True;
end;// UnlockRecord


//------------------------------------------------------------------------------
// IsRecordLocked
//------------------------------------------------------------------------------
function TABSDiskTableData.IsRecordLocked(SessionID: TABSSessionID; RecordID: TABSRecordID): Boolean;
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FDatabaseData.MultiUser) then
      Result := TABSDiskDatabaseData(FDatabaseData).FTableLockManager.IsRecordLocked(
                              SessionID, FTableLocksFile, RecordID)
  else
{$ENDIF}
    Result := True;
end;// IsRecordLocked


////////////////////////////////////////////////////////////////////////////////
//
// TABSDatabaseFile
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// Convert ABSAccessMode to WindowsAccessMode
//------------------------------------------------------------------------------
function TABSDatabaseFile.AccessModeToWindowsMode(am: TABSAccessMode): DWORD;
begin
  case am of
    amReadOnly:
      Result := GENERIC_READ;
    amReadWrite:
      Result := GENERIC_READ or GENERIC_WRITE;
    else
      raise EABSException.Create(30366, ErrorGUnknownAccessMode, [Integer(am)]);
  end;
end;//AccessModeToWindowsMode


//------------------------------------------------------------------------------
// Convert ABSShareMode to WindowsShareMode
//------------------------------------------------------------------------------
function TABSDatabaseFile.ShareModeToWindowsMode(sm: TABSShareMode): DWORD;
begin
  case sm of
    smExclusive:
      Result := 0;
    smShareDenyNone:
      Result := FILE_SHARE_READ or FILE_SHARE_WRITE;
    smShareDenyWrite:
      Result := FILE_SHARE_READ
    else
      raise EABSException.Create(30367, ErrorGUnknownShareMode, [Integer(sm)]);
  end;
end;//ShareModeToWindowsMode


//------------------------------------------------------------------------------
// if file opened then raise
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.CheckOpened(OperationName: AnsiString);
begin
  if not IsOpened then
    raise EABSException.Create(30376, ErrorGFileIsClosed, [OperationName]);
end;//CheckOpened


//------------------------------------------------------------------------------
// File Seek
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.CheckClosed(OperationName: AnsiString);
begin
  if IsOpened then
    raise EABSException.Create(30377, ErrorGFileIsOpened, [OperationName]);
end;//CheckClosed


//------------------------------------------------------------------------------
// InternalSeek
//------------------------------------------------------------------------------
function TABSDatabaseFile.InternalSeek(Offset: Int64): Boolean;

function DoInternalSeek: Boolean;
var
  pos:      Int64;
  HOffset:  Cardinal;
begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}aaWriteToLog('TABSDatabaseFile.DoInternalSeek started. Offset = ' + IntToStr(Offset));{$ENDIF}
  HOffset := Int64Rec(Offset).Hi;
  Int64Rec(pos).Lo := SetFilePointer(FHandle, Int64Rec(Offset).Lo, @HOffset, 0);
  Int64Rec(pos).Hi := HOffset;
  Result := (pos = Offset);
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}aaWriteToLog('TABSDatabaseFile.DoInternalSeek finished. Pos = ' + IntToStr(Pos) + ' GetLastError: ' + IntToStr(GetLastError));{$ENDIF}
end;

begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}aaWriteToLog('TABSDatabaseFile.InternalSeek started. Offset = ' + IntToStr(Offset));{$ENDIF}
  CheckOpened('Seek');
  Result := DoInternalSeek;
  if (not Result) then
    if (ReopenDatabaseFile) then
      Result := DoInternalSeek;
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}aaWriteToLog('TABSDatabaseFile.InternalSeek finished');{$ENDIF}      
end;// InternalSeek


//------------------------------------------------------------------------------
// File Seek
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.Seek(Offset: Int64; ErrorCode: Integer = 0);
var
  ECode:    Integer;
begin
  if (not InternalSeek(Offset)) then
    begin
      if ErrorCode = 0 then
        ECode := 30372
      else
        ECode := ErrorCode;
      raise EABSException.Create(ECode, ErrorGCannotSetFilePosition,
                                 [Offset, FFileName, Position, Size]);
    end;
end;//Seek


//------------------------------------------------------------------------------
// File Set Position
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.SetPosition(Offset: Int64);
begin
  CheckOpened('SetPosition');
  Seek(Offset);
end;//SetPosition


//------------------------------------------------------------------------------
// File Get Position
//------------------------------------------------------------------------------
function TABSDatabaseFile.GetPosition: Int64;
var
  WinErrorCode: DWORD;

function DoGetPosition: Int64;
var
  HOffset:  Integer;
begin
  HOffset := 0;
  Int64Rec(Result).Lo := SetFilePointer(FHandle, 0, @HOffset, FILE_CURRENT);
  Int64Rec(Result).Hi := HOffset;
end;

begin
  CheckOpened('GetPosition');
  Result := DoGetPosition;
  if (Result = INVALID_ID4) then
    if (ReopenDatabaseFile) then
      Result := DoGetPosition;
  if (Result = INVALID_ID4) then
    begin
      WinErrorCode := GetLastError;
      raise EABSException.Create(30373, ErrorGCannotGetFilePosition,
                                   [FFileName, WinErrorCode, SysErrorMessage(WinErrorCode)]);
    end;
end;//GetPosition


//------------------------------------------------------------------------------
// Set File Size
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.SetSize(NewSize: Int64);
var
  WinErrorCode: DWORD;

function DoSetSize: Boolean;
begin
  // SetPosition
  Seek(NewSize);
  // Truncate File
  Result := SetEndOfFile(FHandle);
  if (not Result) then
    WinErrorCode := GetLastError;
end;

begin
  CheckOpened('SetSize');
  if (not DoSetSize) then
    if ((not ReopenDatabaseFile) or (not DoSetSize)) then
    begin
      {$IFDEF DEBUG_TRACE_DISK_ENGINE}
      aaWriteToLog('TABSDatabaseFile.SetSize - DoSetSize error. WinErrorCode: '+IntToStr(WinErrorCode)
        + ' - ' + SysErrorMessage(WinErrorCode) + ' old size: '  +
        IntToStr(GetFileSize(FHandle, nil)) + ' new size: ' + IntToStr(NewSize));
      {$ENDIF}
      raise EABSException.Create(30370, ErrorGCannotTruncateFile,
                                 [FFileName, NewSize, WinErrorCode, SysErrorMessage(WinErrorCode)]);
    end;
end;//SetSize


//------------------------------------------------------------------------------
// Get File Size
//------------------------------------------------------------------------------
function TABSDatabaseFile.GetSize: Int64;
var
  Size64: Int64;
  WinErrorCode: DWORD;

function DoGetSize: Boolean;
var
  HSize: Integer;
begin
  Int64Rec(Size64).Lo := GetFileSize(FHandle, @HSize);
  Result := (Int64Rec(Size64).Lo <> INVALID_FILE_SIZE);
  if (not Result) then
    WinErrorCode := GetLastError
  else
    Int64Rec(Size64).Hi := HSize;
end;

begin
  CheckOpened('GetSize');
  if (not DoGetSize) then
    if ((not ReopenDatabaseFile) or (not DoGetSize)) then
      raise EABSException.Create(30371, ErrorGCannotGetFileSize,
                                 [FFileName, WinErrorCode, SysErrorMessage(WinErrorCode)]);
  Result := Size64;
end;//GetSize


//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
constructor TABSDatabaseFile.Create;
begin
  FFileName := '';

  FAccessMode := amReadWrite;
  FAttrFlags  := FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN;

  FHandle     := INVALID_HANDLE_VALUE;
  FIsOpened   := False;
  DesignOpenCount := 0;
  FWasCriticalError := False;
end;//Create


//------------------------------------------------------------------------------
// Destructor
//------------------------------------------------------------------------------
destructor TABSDatabaseFile.Destroy;
begin
  if IsOpened then
    CloseFile;
end;//Destroy


//------------------------------------------------------------------------------
// Create and Open File
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.CreateAndOpenFile(FileName: string);
var
  WinErrorCode: DWORD;
begin
  CheckClosed('CreateFile');

  if FileName = '' then
    raise EABSException.Create(30374, ErrorGBlankFileName);

  // delete existing file
  if (SysUtils.FileExists(FileName)) then
   begin
     // remove read-only attr
     SysUtils.FileSetAttr(FileName, SysUtils.faSysFile);
     SysUtils.DeleteFile(FileName);
   end;

  FFileName := FileName;
  FAccessMode := amReadWrite;
  FShareMode := smExclusive;
  FHandle := Windows.CreateFile(
                                  PChar(FFileName),
                                  AccessModeToWindowsMode(FAccessMode),
                                  ShareModeToWindowsMode(FShareMode),
                                  nil,
                                  CREATE_ALWAYS,
                                  FAttrFlags,
                                  0
                               );

  if (FHandle = INVALID_HANDLE_VALUE) then
    begin
      WinErrorCode := GetLastError;
      raise EABSException.Create(30361, ErrorGCreateFileError,
                                 [FFileName, WinErrorCode, SysErrorMessage(WinErrorCode)]);
    end;

  FIsOpened := True;
  
end;//CreateFile


//------------------------------------------------------------------------------
// Delete File
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.DeleteFile;
var
  WinErrorCode: DWORD;
begin
  CheckClosed('DeleteFile');
  if not Windows.DeleteFile(PChar(FFileName)) then
    begin
      WinErrorCode := GetLastError;
      raise EABSException.Create(30362, ErrorGDeleteFileError,
                                 [FFileName, WinErrorCode, SysErrorMessage(WinErrorCode)]);
    end;
end;//DeleteFile


//------------------------------------------------------------------------------
// Rename Closed File
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.RenameFile(OldFileName, NewFileName: string);
var
  WinErrorCode: DWORD;
begin
  //CheckClosed('RenameFile');

  if not Windows.MoveFile(PChar(OldFileName), PChar(NewFileName)) then
    begin
      WinErrorCode := GetLastError;
      raise EABSException.Create(30378, ErrorGRenameFileError,
          [OldFileName,NewFileName, WinErrorCode, SysErrorMessage(WinErrorCode)]);
    end;
  
end;//RenameFile


//------------------------------------------------------------------------------
// Open File
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.OpenFile(FileName: string; AccessMode: TABSAccessMode; ShareMode: TABSShareMode);
var
  WinErrorCode: DWORD;
begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}aaWriteToLog('TABSDatabaseFile.OpenFile start');{$ENDIF}
  try
    CheckClosed('OpenFile');

    FFileName := FileName;
    FAccessMode := AccessMode;
    FShareMode := ShareMode;

    //F0X
    FHandle := Windows.CreateFilew(
                                    Pwidechar(UTF8Decode(FFileName)),
                                    AccessModeToWindowsMode(FAccessMode),
                                    ShareModeToWindowsMode(FShareMode),
                                    nil,
                                    OPEN_EXISTING,
                                    FAttrFlags,
                                    0
                                 );

    if (FHandle = INVALID_HANDLE_VALUE) then
      begin
        WinErrorCode := GetLastError;
        raise EABSException.Create(30364, ErrorGOpenFileError,
                                   [FFileName, WinErrorCode, SysErrorMessage(WinErrorCode)]);
      end;

    FIsOpened := True;
  finally
    {$IFDEF DEBUG_TRACE_DISK_ENGINE}aaWriteToLog('TABSDatabaseFile.OpenFile end');{$ENDIF}
  end;
end;//OpenFile



//------------------------------------------------------------------------------
// Close File
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.CloseFile;
var
  WinErrorCode: DWORD;
begin
  CheckOpened('CloseFile');

  if not CloseHandle(FHandle) then
    begin
      WinErrorCode := GetLastError;
      raise EABSException.Create(30365, ErrorGCloseFileError,
                                 [FFileName, WinErrorCode, SysErrorMessage(WinErrorCode)]);
    end;
  FHandle := INVALID_HANDLE_VALUE;
  FIsOpened := False;
end;//CloseFile


//------------------------------------------------------------------------------
// OpenFileForDesignTime
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.OpenFileForDesignTime;
begin
  if (DesignOpenCount = 0) then
    OpenFile(FFileName, FAccessMode, FShareMode);
  Inc(DesignOpenCount);
end;// OpenFileForDesignTime


//------------------------------------------------------------------------------
// CloseFileForDesignTime
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.CloseFileForDesignTime;
begin
  if (DesignOpenCount > 0) then
   begin
    Dec(DesignOpenCount);
    if (DesignOpenCount = 0) then
      CloseFile;
   end;
end;// CloseFileForDesignTime


//------------------------------------------------------------------------------
// if connection to the network file is lost, try to reopen it
//------------------------------------------------------------------------------
function TABSDatabaseFile.ReopenDatabaseFile: Boolean;
var
  i: Integer;

function IsFileDisconnected: Boolean;
var
  Size64: Int64;
  HSize: Integer;
begin
  Int64Rec(Size64).Lo := Windows.GetFileSize(FHandle, @HSize);
  Result := (Int64Rec(Size64).Lo = INVALID_FILE_SIZE);
end;

function ReopenDBFile: Boolean;
begin
   if (FHandle <> INVALID_HANDLE_VALUE) then
     CloseHandle(FHandle);
   FHandle := Windows.CreateFile(
                                  PChar(FFileName),
                                  AccessModeToWindowsMode(FAccessMode),
                                  ShareModeToWindowsMode(FShareMode),
                                  nil,
                                  OPEN_EXISTING,
                                  FAttrFlags,
                                  0
                               );
   Result := (FHandle <> INVALID_HANDLE_VALUE);
end;

begin
 if (IsFileDisconnected) then
   begin
     i := 1;
     while ((not ReopenDBFile) and (i < ReopenDatabaseFileRetries)) do
      begin
        Inc(i);
        Sleep(ReopenDatabaseFileDelay);
      end;
   end;
   Result := (FHandle <> INVALID_HANDLE_VALUE);
end;// ReopenDatabaseFile


//------------------------------------------------------------------------------
// Read Buffer
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.ReadBuffer(var Buffer; const Count, Position: Int64; ErrorCode: Integer);
var
  WinErrorCode: DWORD;

function DoReadBuffer: Boolean;
begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    WinErrorCode := 0;
    aaWriteToLog('TABSDatabaseFile.ReadBuffer.DoReadBuffer started');
  {$ENDIF}
  Result := ReadBuffer(Buffer, Count, Position);
  if (not Result) then
    begin
      // check to remove strange locks
      IsRegionLocked(Position, Count);
      // try to read again
      Result := ReadBuffer(Buffer, Count, Position);
      if (not Result) then
        WinErrorCode := GetLastError;
    end;
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    aaWriteToLog('TABSDatabaseFile.ReadBuffer.DoReadBuffer finished. Last error code = ' + IntToStr(WinErrorCode));
  {$ENDIF}
end;

begin
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
  aaWriteToLog('TABSDatabaseFile.ReadBuffer started: Count='+
  IntToStr(Count)+' Position='+IntToStr(Position) + ' ErrorCode='+IntToStr(ErrorCode));
{$ENDIF}
  if (not DoReadBuffer) then
    // try to reopen db and read again
    if (not ReopenDatabaseFile) or (not DoReadBuffer) then
       raise EABSException.Create(ErrorCode, ErrorGReadFileError,
                                  [FFileName, Position, Count, self.Position, self.Size,
                                   WinErrorCode, SysErrorMessage(WinErrorCode)]);
end;//ReadBuffer


//------------------------------------------------------------------------------
// ReadBuffer
//------------------------------------------------------------------------------
function TABSDatabaseFile.ReadBuffer(var Buffer; const Count: Int64; const Position: Int64): Boolean;

function DoReadBuffer: Boolean;
var
  NumberOfBytesRead: DWORD;
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
  WinErrorCode: DWORD;
{$ENDIF}
begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    aaWriteToLog('TABSDatabaseFile.DoReadBuffer_1 started');
  {$ENDIF}
  // Set Position
  Result := InternalSeek(Position);
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
  {$IFDEF D6H}
    WinErrorCode := GetLastError;
    aaWriteToLog('InternalSeek returned ' + BoolToStr(Result, True) + ' Error code ' + IntToStr(WinErrorCode)+', Error msg: '+SysErrorMessage(WinErrorCode));
  {$ENDIF}
  {$ENDIF}
  // Read Bytes
  if (Result) then
    Result := ReadFile(FHandle, Buffer, Count, NumberOfBytesRead, nil);
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
  {$IFDEF D6H}
    WinErrorCode := GetLastError;
    aaWriteToLog('ReadFile returned ' + BoolToStr(Result, True) + ' Error code ' + IntToStr(WinErrorCode)+', Error msg: '+SysErrorMessage(WinErrorCode));
  {$ENDIF}
  {$ENDIF}
end;

begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    aaWriteToLog('TABSDatabaseFile.ReadBuffer_1 started');
  {$ENDIF}

  CheckOpened('ReadBuffer');
  Result := DoReadBuffer;
  if (not Result) then
    // try to reopen db and read again
    if (ReopenDatabaseFile) then
      Result := DoReadBuffer;
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    aaWriteToLog('TABSDatabaseFile.ReadBuffer_1 finished');
  {$ENDIF}

end;//


//------------------------------------------------------------------------------
// Write Buffer
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.WriteBuffer(const Buffer; const Count, Position: Int64; ErrorCode: Integer);
var
  NumberOfBytesWritten: DWORD;
  WinErrorCode: DWORD;

function DoWriteBuffer: Boolean;
begin
  // Set Position
  Seek(Position, ErrorCode);
  // Write Bytes
  Result := WriteFile(FHandle, Buffer, Count, NumberOfBytesWritten, nil);
  if (not Result) then
    WinErrorCode := GetLastError;
end;

begin
  CheckOpened('WriteBuffer');
  if (not DoWriteBuffer) then
    // try to reopen db and write again
    if (not ReopenDatabaseFile) or (not DoWriteBuffer) then
      raise EABSException.Create(ErrorCode, ErrorGWriteFileError,
                                 [FFileName, Position, Count, self.Position, self.Size,
                                 WinErrorCode, SysErrorMessage(WinErrorCode)]);
end;//WriteBuffer


//------------------------------------------------------------------------------
// Flush Buffers
//------------------------------------------------------------------------------
procedure TABSDatabaseFile.FlushFileBuffers;
var
  WinErrorCode: DWORD;

function DoFlushFileBuffers: Boolean;
begin
  Result := Windows.FlushFileBuffers(FHandle);
  if (not Result) then
    WinErrorCode := GetLastError;
end;

begin
  CheckOpened('FlushFileBuffers');
  if (not DoFlushFileBuffers) then
    // try to reopen db and flush again
    if (not ReopenDatabaseFile) or (not DoFlushFileBuffers) then
      raise EABSException.Create(30379, ErrorGFlushFileBufferError,
                       [FFileName,  WinErrorCode, SysErrorMessage(WinErrorCode)]);
end;//FlushFileBuffers


//------------------------------------------------------------------------------
// Lock Byte
//------------------------------------------------------------------------------
function TABSDatabaseFile.LockByte(Offset: Int64; Count: Integer = 1): Boolean;

function DoLockByte: Boolean;
begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    aaWriteToLog('TABSDatabaseFile.LockByte started. Offset = ' + IntToStr(Offset) +
    ' Count = ' + IntToStr(Count));
  {$ENDIF}
  Result := Windows.LockFile(FHandle, Int64Rec(Offset).Lo, Int64Rec(Offset).Hi, Count, 0);
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
  {$IFDEF D6H}
    aaWriteToLog('Windows.LockFile returned ' + BoolToStr(Result, True) + 'Error code ' + IntToStr(GetLastError));
  {$ENDIF}
  {$ENDIF}
  if (not Result) then
    begin
      if (not FWasCriticalError) then
       FWasCriticalError := IsOSCriticalError;
      Result := FWasCriticalError;
    end;
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    aaWriteToLog('TABSDatabaseFile.LockByte finished');
  {$ENDIF}
end;

begin
  CheckOpened('LockByte');
  Result := DoLockByte;
  if (not Result) then
   if (ReopenDatabaseFile) then
     begin
       FWasCriticalError := False;
       Result := DoLockByte;
     end;
end;//LockByte


//------------------------------------------------------------------------------
// Unlock Byte
//------------------------------------------------------------------------------
function TABSDatabaseFile.UnlockByte(Offset: Int64; Count: Integer = 1): Boolean;

function DoUnlockByte: Boolean;
begin
  Result := Windows.UnLockFile(FHandle, Int64Rec(Offset).Lo, Int64Rec(Offset).Hi, Count, 0);
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
  {$IFDEF D6H}
    aaWriteToLog('Windows.UnLockFile returned ' + BoolToStr(Result, True) + ' Error code: ' + IntToStr(GetLastError));
  {$ENDIF}
  {$ENDIF}
  if (IsDesignMode) then
    Result := True;
  if (not Result) then
    begin
      if (not FWasCriticalError) then
       FWasCriticalError := IsOSCriticalError;
      Result := FWasCriticalError;
    end;

end;

begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    aaWriteToLog('TABSDatabaseFile.UnlockByte started. Offset = ' + IntToStr(Offset) +
    ' Count = ' + IntToStr(Count));
  {$ENDIF}
  CheckOpened('UnlockByte');
  Result := DoUnlockByte;
  if (not Result) then
   if (ReopenDatabaseFile) then
     begin
       FWasCriticalError := False;
       Result := DoUnlockByte;
     end;
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
  {$IFDEF D6H}
    aaWriteToLog('TABSDatabaseFile.UnlockByte finished. Result = ' + BoolToStr(Result, True));
  {$ENDIF}
  {$ENDIF}
end;//UnlockByte


//------------------------------------------------------------------------------
// return TRUE if byte locked
//------------------------------------------------------------------------------
function TABSDatabaseFile.IsByteLocked(Offset: Int64): Boolean;
begin
  CheckOpened('IsByteLocked');
  Result := LockByte(Offset);
  if Result then
    UnlockByte(Offset);
  Result := not Result;
end;//IsByteNotLocked


//------------------------------------------------------------------------------
// return FALSE if any byte of region is locked
//------------------------------------------------------------------------------
function TABSDatabaseFile.IsRegionLocked(Offset: Int64; Count: Integer): Boolean;
begin
  {$IFDEF DEBUG_TRACE_DISK_ENGINE}
    aaWriteToLog('TABSDatabaseFile.IsRegionLocked started. Offset = ' + IntToStr(Offset) +
    ' Count = ' + IntToStr(Count));
  {$ENDIF}
  CheckOpened('IsRegionLocked');
  Result := LockByte(Offset, Count);
  if Result then
    UnlockByte(Offset, Count);
  Result := not Result;
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
{$IFDEF D6H}
    aaWriteToLog('TABSDatabaseFile.IsRegionLocked finished. Result = ' + BoolToStr(Result, True));
{$ENDIF}
{$ENDIF}
end;//IsByteRegionNotLocked


//------------------------------------------------------------------------------
// find signature
//------------------------------------------------------------------------------
function TABSDatabaseFile.FindSignature(var Offset: Int64): Boolean;
var
  Buf: TAbsPByte;
  BufSize: Integer;
  WorkPos, OldPos: Int64;
  Signature: AnsiString;
  SignatureLen: integer;

function IsCorrectDBHeader(pDBHeader: TAbsPByte): Boolean;
var
  DBHeader: TABSDBHeader;
begin
  Move(pDBHeader^, DBHeader, sizeof(DBHeader));
  Result := (DBHeader.HeaderSize = Sizeof(DBHeader));
end;


function FindSignatureInBlock(FilePos: Int64; var SignatureOffset: Int64): Boolean;
var
  i: Integer;
  SizeToCheck: Integer;
begin
  Result := False;
  SizeToCheck := min(Size-Position, BufSize)-SignatureLen;
  ReadBuffer(Buf^, BufSize, FilePos);
  for i := 0 to SizeToCheck do
    if (StrLComp(PAnsiChar(Signature), PAnsiChar(Buf+i), SignatureLen) = 0) then
      if (IsCorrectDBHeader(Buf+i)) then
        begin
          Result := True;
          SignatureOffset := FilePos + i;
          break;
        end;
end;

begin
  Result := False;
  Signature := ABSDiskSignature1 + ABSDiskSignature2;
  SignatureLen := Length(Signature);
  BufSize := 10000;
  OldPos := Position;
  Buf := MemoryManager.AllocMem(BufSize);
  try
  ReadBuffer(Buf^, SignatureLen+sizeof(TABSDBHeader), 0);
  if (StrLComp(PAnsiChar(Signature), PAnsiChar(Buf), SignatureLen) = 0) then
    if (IsCorrectDBHeader(Buf)) then
      begin
        Offset := 0;
        Result := True;
      end;

  if (not Result) then
    begin
      WorkPos := 0;
      while (WorkPos < Size) do
        if (FindSignatureInBlock(WorkPos, Offset)) then
          begin
            Result := True;
            break;
          end
        else
          WorkPos := WorkPos+BufSize-SignatureLen;
    end;
  finally
      MemoryManager.FreeAndNillMem(Buf);
      Position := OldPos;
  end;
end;// FindSignature



////////////////////////////////////////////////////////////////////////////////
//
// TABSDatabaseFreeSpaceManager
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// GetAddPagesStep
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.GetAddPagesStep: Integer;
begin
  //Result := FPageCountInExtent; // = 8
  //Exit;

  if (FTotalPageCount = 0) then
   begin
    Result := 6;
   end
  else
   begin
    // return 10 % or 8
    Result := max((FTotalPageCount div 10), FPageCountInExtent);
    // but < Eam adderessed
    //Result := min(Result, FEAMPage_PagesAddressed div 2);
    //Result := 8;
   end;

   //Result := 1;
   
end;//GetAddPagesStep


//------------------------------------------------------------------------------
// GetDelPagesStep
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.GetDelPagesStep: Integer;
begin
  Result := GetAddPagesStep;
end;//GetDelPagesStep


//------------------------------------------------------------------------------
// NewPage
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.NewPage(PageNo: TABSPageNo): TABSPage;
begin
  Result := TABSPage.Create(LPageManager);
  try
    Result.AllocPageBuffer;
    Result.PageNo := PageNo;
    Result.SessionID := SYSTEM_SESSION_ID;
  except
    Result.Free;
    raise;
  end;
end;//NewPage


//------------------------------------------------------------------------------
// ReadPage
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.ReadPage(PageNo: TABSPageNo): TABSPage;
begin
  Result := NewPage(PageNo);
  try
    LPageManager.InternalReadPage(Result);
  except
    Result.Free;
    raise;
  end;
end;//ReadPage


//------------------------------------------------------------------------------
// WriteAndFreePage
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.WriteAndFreePage(var Page: TABSPage);
begin
  if (Page.IsDirty) then
    LPageManager.InternalWritePage(Page);
  FreeAndNil(Page);
end;//WriteAndFreePage


//------------------------------------------------------------------------------
// CorrectEamPageNo
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.CorrectEamPageNo(EAMPageNo: TABSPageNo): TABSPageNo;
begin
  Result := EAMPageNo;
  if ((EAMPageNo mod FPFSPage_PagesAddressed) = 0) then Inc(Result);
end;//CorrectEamPageNo


//------------------------------------------------------------------------------
// UncorrectEamPageNo
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.UncorrectEamPageNo(EamPageNo: TABSPageNo): TABSPageNo;
begin
  Result := (EAMPageNo div FEAMPage_PagesAddressed) * FEAMPage_PagesAddressed;
end;//UncorrectEamPageNo


//------------------------------------------------------------------------------
// EamPageNoForEamPagePosition
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.EamPageNoForEamPagePosition(
                                         EamPagePosition: Integer): TABSPageNo;
begin
  Result := CorrectEamPageNo(EamPagePosition * FEAMPage_PagesAddressed);
end;//EamPageNoForEamPagePosition


//------------------------------------------------------------------------------
// EamPageNoToEamPagePosition
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.EamPageNoToEamPagePosition(EamPageNo: TABSPageNo): Integer;
begin
  Result := UncorrectEamPageNo(EamPageNo) div FEAMPage_PagesAddressed;
end;//EamPageNoToEamPagePosition


//------------------------------------------------------------------------------
// EamPageNoForPageNo
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.EamPageNoForPageNo(PageNo: TABSPageNo): TABSPageNo;
begin
  Result := CorrectEamPageNo(
              EamPageNoForEamPagePosition(
                PageNo div FEAMPage_PagesAddressed));
end;//EamPageNoForPageNo


//------------------------------------------------------------------------------
// GetLastEamPagePosition
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.GetLastEamPagePosition: Integer;
begin
  //Result := FTotalPageCount div FEAMPage_PagesAddressed;
  Result := (max(FTotalPageCount-1,0)) div FEAMPage_PagesAddressed;
end;//GetLastEamPagePosition


//------------------------------------------------------------------------------
// GetLastEamPageNo
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.GetLastEamPageNo: TABSPageNo;
begin
  Result := EamPageNoForEamPagePosition(GetLastEamPagePosition);
end;//GetLastEamPageNo


//------------------------------------------------------------------------------
// GetLastPfsPagePosition
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.GetLastPfsPagePosition: Integer;
begin
  //Result := FTotalPageCount div FPFSPage_PagesAddressed;
  Result := (max(FTotalPageCount-1,0)) div FPFSPage_PagesAddressed;
end;//GetLastPfsPagePosition


//------------------------------------------------------------------------------
// PfsPositionsForExtentPosition
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.PfsPositionsForExtentPosition(
                                              const ExtentPosition: Integer;
                                              out PfsFirstPagePosition: Integer;
                                              out PfsLastPagePosition: Integer
                                                                    ): Boolean;
begin
  PfsFirstPagePosition := (ExtentPosition * FPageCountInExtent) div
                           FPFSPage_PagesAddressed;
  PfsLastPagePosition :=  ((ExtentPosition + 1) * FPageCountInExtent - 1) div
                           FPFSPage_PagesAddressed;
  Result := False;

  if (PfsPageNoForPfsPagePosition(PfsFirstPagePosition) >= FTotalPageCount) then
  //if (PfsPageNoForPfsPagePosition(PfsFirstPagePosition) >= FLastUsedPageNo) then
   Exit;

  while (PfsPageNoForPfsPagePosition(PfsLastPagePosition) >= FTotalPageCount) do
  //while (PfsPageNoForPfsPagePosition(PfsLastPagePosition) >= FLastUsedPageNo) do
   Dec(PfsLastPagePosition);

  if (PfsLastPagePosition < PfsFirstPagePosition) then
   Exit;

  Result := True;
end;//PfsPositionsForExtentPosition


//------------------------------------------------------------------------------
// PfsPageNoForPfsPagePosition
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.PfsPageNoForPfsPagePosition(PfsPagePosition: Integer): TABSPageNo;
begin
  Result := PfsPagePosition * FPFSPage_PagesAddressed;
end;//PfsPageNoForPfsPagePosition


//------------------------------------------------------------------------------
// PfsPageNoForPageNo
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.PfsPageNoForPageNo(PageNo: TABSPageNo): TABSPageNo;
begin
  Result := (PageNo div FPFSPage_PagesAddressed) * FPFSPage_PagesAddressed;
end;//PfsPageNoForPageNo


//------------------------------------------------------------------------------
// IsPagePfsOrEam
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.IsPagePfsOrEam(PageNo: TABSPageNo): Boolean;
begin
  Result := ((PageNo mod FPFSPage_PagesAddressed) = 0) or
            ((PageNo mod FEAMPage_PagesAddressed) = 0) or
          ( (((PageNo-1) mod FPFSPage_PagesAddressed) = 0) and
            (((PageNo-1) mod FEAMPage_PagesAddressed) = 0) );
end;//IsPagePfsOrEam



//------------------------------------------------------------------------------
// FindAndReusePage
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.FindAndReusePage: TABSPageNo;

 //-----------------------------------------------------------------------------
 // FindExtentWithFreePages
 //-----------------------------------------------------------------------------
 function FindExtentWithFreePages(EAMPageNo: TABSPageNo): TABSPageNo;
 var
   Page:      TABSPage;
   ExtentNo:  TABSPageNo;
   PageNo:    TABSPageNo;
   b:         Byte;
   i,j:       Integer;
   PFSFirstNo,
   PFSLastNo: Integer;
   PFSPageNo: TABSPageNo;
   pn:        TABSPageNo;
 begin
   Result := INVALID_PAGE_NO;

   // Find extent with free pages
   ExtentNo := INVALID_PAGE_NO;
   Page := ReadPage(EAMPageNo);
   try
    CheckPageType(Page.PageHeader.PageType, ptEAM, 30423);
    for i:=0 to Page.PageDataSize-1 do
     if (Byte(Page.PageData[i]) <> 255) then
      begin
       b := Byte(Page.PageData[i]);
       for j:=0 to 3 do
        if (((b shr (j*2)) and 3 ) in [ABS_EXTENT_IS_FREE,
                                       ABS_EXTENT_IS_PARTIAL_USED]) then
         begin
          ExtentNo := i*4 + j + EamPageNoToEamPagePosition(EAMPageNo) *
                                FEAMPage_ExtentsAddressed;
          Break;
         end;
       if (ExtentNo <> INVALID_PAGE_NO) then
        Break;
      end;
   finally
    WriteAndFreePage(Page);
   end;

   // Exit, if not found
   if (ExtentNo = INVALID_PAGE_NO) then Exit;

   // Find Free page No
   if (not PfsPositionsForExtentPosition(ExtentNo, PFSFirstNo, PFSLastNo)) then
     Exit;

   PageNo := INVALID_PAGE_NO;
   for pn:=PFSFirstNo to PFSLastNo do
    begin
     // Read PFS Page
     PFSPageNo := PfsPageNoForPfsPagePosition(pn);
     Page := ReadPage(PFSPageNo);
     try
      CheckPageType(Page.PageHeader.PageType, ptPFS, 30423);
      for i:=0 to Page.PageDataSize-1 do
      if (Byte(Page.PageData[i]) <> 255) then
        begin
         b := Byte(Page.PageData[i]);
         for j:=0 to 7 do
          if (((b shr j) and 1) = ABS_PAGE_IS_FREE) then
           begin
            PageNo := PfsPageNoForPfsPagePosition(pn) + i*8 + j;
            break;
           end;
         if (PageNo <> INVALID_PAGE_NO) then
          Break;
        end;
     finally
      WriteAndFreePage(Page);
     end;
    end;//for

   if ((PageNo <> INVALID_PAGE_NO) and (PageNo < FTotalPageCount)) then
     Result := PageNo;     
 end;//FindExtentWithFreePages
//------------------------------------------------------------------------------
var
  RndEAMPageNo:  TABSPageNo;
  LastEamPagePosition: Integer;
  Eams: array of integer;
  i: Integer;
begin
  Result := INVALID_PAGE_NO;
  if (FLastUsedPageNo = INVALID_PAGE_NO) then Exit;
  // Look at Last EAM Page
  Result := FindExtentWithFreePages(GetLastEamPageNo);
  // Look at random EAM Page
  if (Result = INVALID_PAGE_NO) then
   begin
    LastEamPagePosition := GetLastEamPagePosition;
    if (LastEamPagePosition > 0) then
     begin
      // Set random order
      SetLength(Eams, LastEamPagePosition);
      for i:=0 to LastEamPagePosition-1 do Eams[i] := i;
      {for i:=0 to LastEamPagePosition-1 do
       begin
        k := Eams[i];
        r := RandomRange(0, LastEamPagePosition-1);
        Eams[i] := Eams[r];
        Eams[r] := k;
       end;}

      for i:=0 to LastEamPagePosition-1 do
       begin
        RndEAMPageNo := EamPageNoForEamPagePosition(Eams[i]);
        Result := FindExtentWithFreePages(RndEAMPageNo);
        if (Result <> INVALID_PAGE_NO) then Break;
       end;

      {RndEAMPageNo := EamPageNoForEamPagePosition(RandomRange(0,
                                                       LastEamPagePosition-1));
      Result := FindExtentWithFreePages(RndEAMPageNo);}
     end;
   end;
  // Use this Page
  if (Result <> INVALID_PAGE_NO) then
   SetPageUsage(Result, True);
end;//FindAndReusePage


//------------------------------------------------------------------------------
// FindLastUsedPageNo
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.FindLastUsedPageNo: TABSPageNo;
var
  LastPFSNo: TABSPageNo;
  Page:       TABSPage;
  pn,i,j:     Integer;
  b: Byte;
begin
  Result := FLastUsedPageNo;
  if (FLastUsedPageNo = INVALID_PAGE_NO) then Exit;

  LastPFSNo := GetLastPfsPagePosition;
  for pn:=LastPFSNo downto 0 do
   begin
    // Read PFS Page
    Page := ReadPage(PfsPageNoForPfsPagePosition(pn));
    try
     CheckPageType(Page.PageHeader.PageType, ptPFS, 30432);
     for i:=Page.PageDataSize-1 downto 0 do
      if (Byte(Page.PageData[i]) <> 0) then
       begin
        b := Byte(Page.PageData[i]);
        for j:=7 downto 0 do
         if (((b shr j) and 1) <> ABS_PAGE_IS_FREE) then
          begin
           Result := PfsPageNoForPfsPagePosition(pn) + i*8 + j;
           if not IsPagePfsOrEam(Result) then
             Exit;
           //while (Result>=0) and (IsPagePfsOrEam(Result)) do Dec(Result);
           //Exit;
          end;
       end;
    finally
     WriteAndFreePage(Page);
    end;
   end;
  if (Result >= 0) then
    Result := INVALID_PAGE_NO;
end;//FindLastUsedPageNo


//------------------------------------------------------------------------------
// Set in PFS map that page with number PageNo is USED or FREE
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.SetPageUsage(PageNo: TABSPageNo; UsedFlag: Boolean);
begin
  SetPageUsageToPFS(PageNo, UsedFlag);
  SetPageUsageToEAM(PageNo, UsedFlag);
end;//PFSSetPageUsed


//------------------------------------------------------------------------------
// SetPageUsageToPFS
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.SetPageUsageToPFS(PageNo: TABSPageNo; UsedFlag: Boolean);
var
  PFSPage: TABSPage;
  PFSPageNo: TABSPageNo;
  BitsOffset, ByteNo, BitNo: Integer;
  mask, OldByte: byte;
begin
  if ( (PageNo < 0) or (PageNo >= FTotalPageCount) ) then
    raise EABSException.Create(30430, ErrorGPageCannotBeAddressed, [PageNo, FTotalPageCount]);
  // Set flag to PFS Map
  PFSPageNo := PfsPageNoForPageNo(PageNo);
  BitsOffset := PageNo mod FPFSPage_PagesAddressed;
  ByteNo := BitsOffset div 8;
  BitNo := BitsOffset mod 8;
  mask := 1 shl BitNo;
  PFSPage := ReadPage(PFSPageNo);
  try
   CheckPageType(PFSPage.PageHeader.PageType, ptPFS, 30424);
   OldByte := Byte(PFSPage.PageData[ByteNo]);
   if UsedFlag then
    begin
     if ((Byte(PFSPage.PageData[ByteNo]) and mask) <> 0) then
       raise EABSException.Create(30425, ErrorGPageAlreadyUsed, [PageNo]);
     Byte(PFSPage.PageData[ByteNo]) := Byte(PFSPage.PageData[ByteNo]) or mask;
    end
   else
    begin
     if ((Byte(PFSPage.PageData[ByteNo]) and mask) = 0) then
       raise EABSException.Create(30427, ErrorGPageAlreadyFree, [PageNo]);
     Byte(PFSPage.PageData[ByteNo]) := Byte(PFSPage.PageData[ByteNo]) and not mask;
    end;
   if (OldByte <> Byte(PFSPage.PageData[ByteNo])) then
    PFSPage.IsDirty := True;
  finally
   WriteAndFreePage(PFSPage);
  end;
end;//SetPageUsageToPFS


//------------------------------------------------------------------------------
// SetPageUsageToEAM
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.SetPageUsageToEAM(PageNo: TABSPageNo; UsedFlag: Boolean);
var
  EAMPage: TABSPage;
  EAMPageNo, pn: TABSPageNo;
  ExtentNo: TABSPageNo;
  MinPageNo, MaxPageNo: TABSPageNo;
  ByteNo, BitNo: Integer;
  mask, cmask, OldByte: byte;
  FreePagesCount, UsedPagesCount: Integer;
begin
  if ( (PageNo < 0) or (PageNo >= FTotalPageCount) ) then
    raise EABSException.Create(30431, ErrorGPageCannotBeAddressed, [PageNo, FTotalPageCount]);
  // Set flag to EAM Map
  EAMPageNo := EamPageNoForPageNo(PageNo);
  
  ExtentNo := PageNo div FPageCountInExtent;
  ByteNo := (ExtentNo mod FEAMPage_ExtentsAddressed) div 4;
  BitNo := ((ExtentNo mod FEAMPage_ExtentsAddressed) mod 4)*2;

  EAMPage := ReadPage(EAMPageNo);
  try
   CheckPageType(EAMPage.PageHeader.PageType, ptEAM, 30428);
   // Scan PFS Pages...
   FreePagesCount := 0;
   UsedPagesCount := 0;
   MinPageNo := ExtentNo * FPageCountInExtent;
   MaxPageNo := (ExtentNo+1) * FPageCountInExtent - 1;

   for pn := MinPageNo to MaxPageNo do
    begin
      if GetPageUsageFromPFS(pn) then
        Inc(UsedPagesCount)
      else
        Inc(FreePagesCount);
      if ((UsedPagesCount <> 0) and (FreePagesCount <> 0)) then
        Break;
    end;
   // set Mask
   if ((UsedPagesCount <> 0) and (FreePagesCount = 0)) then
    mask := ABS_EXTENT_IS_FULL
   else if ((UsedPagesCount = 0) and (FreePagesCount = 0)) then
    mask := ABS_EXTENT_IS_FREE
   else
    mask := ABS_EXTENT_IS_PARTIAL_USED;
   mask := mask shl BitNo;
   cmask := 3 shl BitNo;
   OldByte := Byte(EAMPage.PageData[ByteNo]);
   Byte(EAMPage.PageData[ByteNo]) := Byte(EAMPage.PageData[ByteNo]) and not cmask;
   Byte(EAMPage.PageData[ByteNo]) := Byte(EAMPage.PageData[ByteNo]) or mask;
   if (OldByte <> Byte(EAMPage.PageData[ByteNo])) then
    EAMPage.IsDirty := True;
  finally
   WriteAndFreePage(EAMPage);
  end;
end;//SetPageUsageToEAM


//------------------------------------------------------------------------------
// GetPageUsageFromPFS
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.GetPageUsageFromPFS(PageNo: TABSPageNo): Boolean;
var
  PFSPage: TABSPage;
  PFSPageNo: TABSPageNo;
  BitsOffset, ByteNo, BitNo: Integer;
  mask: byte;
begin
  PFSPageNo := PfsPageNoForPageNo(PageNo);
  if (PFSPageNo > FLastUsedPageNo) then
   begin
    Result := False;
    Exit;
   end;
  BitsOffset := PageNo mod FPFSPage_PagesAddressed;
  ByteNo := BitsOffset div 8;
  BitNo := BitsOffset mod 8;
  mask := 1 shl BitNo;
  PFSPage := ReadPage(PFSPageNo);
  try
   CheckPageType(PFSPage.PageHeader.PageType, ptPFS, 30430);
   Result := (Byte(PFSPage.PageData[ByteNo]) and mask) <> 0;
  finally
   WriteAndFreePage(PFSPage);
  end;
end;//GetPageUsageFromPFS


//------------------------------------------------------------------------------
// AddNewPageAndExtentFile
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.AddNewPageAndExtentFile: TABSPageNo;
var
  //OldTotalPageCount: TABSPageNo;
  OldPFSLastPosition, NewPFSLastPosition, pn: Integer;
  OldEAMLastPosition, NewEAMLastPosition: Integer;
  OldLastUsedPageNo: TABSPageNo;
  PFSPageNo: TABSPageNo;
  PFSPage: TABSPage;
  EAMPageNo: TABSPageNo;
  EAMPage: TABSPage;
  EmptyDB: Boolean;
  Increment: Integer;
begin
  EmptyDB := (FLastUsedPageNo = INVALID_PAGE_NO);

  OldPFSLastPosition := GetLastPfsPagePosition;
  if EmptyDB then OldPFSLastPosition := -1;

  OldEAMLastPosition := GetLastEamPagePosition;
  if EmptyDB then OldEAMLastPosition := -1;

  FLastUsedPageNo := FLastUsedPageNo + 1;
  while IsPagePfsOrEam(FLastUsedPageNo) do Inc(FLastUsedPageNo);

  //OldTotalPageCount := FTotalPageCount;
  OldLastUsedPageNo := FLastUsedPageNo;

  // extend file
  Increment := AddPagesStep;
  if (FTotalPageCount + Increment <= FLastUsedPageNo) then
    Increment := FLastUsedPageNo - FTotalPageCount + 1;
  while (IsPagePfsOrEam(FTotalPageCount+Increment-1)) do Inc(Increment);

  //Inc(Increment);
  //LPageManager.ExtendFile(AddPagesStep);
  LPageManager.ExtendFile(Increment);
  FTotalPageCount := LPageManager.DBHeader.TotalPageCount;
{
  // additional extend file
  if (PfsPageNoForPfsPagePosition(GetLastPfsPagePosition)+2 >= FTotalPageCount) then
    begin
      // extend file
      LPageManager.ExtendFile(5);
      FTotalPageCount := LPageManager.DBHeader.TotalPageCount;
    end;
}
  // Extent PFS Map ?
  NewPFSLastPosition := GetLastPfsPagePosition;
//  PFSPageNo := INVALID_PAGE_NO;
  if ((OldPFSLastPosition <> NewPFSLastPosition) or EmptyDB) then
   for pn:=OldPFSLastPosition+1 to NewPFSLastPosition do
    begin
     PFSPageNo := PfsPageNoForPfsPagePosition(pn);
     PFSPage := NewPage(PFSPageNo);
     try
      PFSPage.PageHeader.PageType := ptPFS;
      // address itself
      Byte(PFSPage.PageData[0]) := ABS_PAGE_IS_FULL;
      PFSPage.IsDirty := True;
     finally
      WriteAndFreePage(PFSPage);
     end;
     //if (PFSPageNo > FLastUsedPageNo) then
     //  FLastUsedPageNo := PFSPageNo;
    end;

  // Extent EAM Map ?
  NewEAMLastPosition := GetLastEamPagePosition;
//  EAMPageNo := INVALID_PAGE_NO;
  if ((OldEAMLastPosition <> NewEAMLastPosition) or EmptyDB) then
   for pn:=OldEAMLastPosition+1 to NewEAMLastPosition do
    begin
     EAMPageNo := EamPageNoForEamPagePosition(pn);
     EAMPage := NewPage(EAMPageNo);
     try
      EAMPage.PageHeader.PageType := ptEAM;
      // address itself
      Byte(EAMPage.PageData[0]) := ABS_EXTENT_IS_PARTIAL_USED;
      EAMPage.IsDirty := True;
     finally
      WriteAndFreePage(EAMPage);
     end;
     //if (EAMPageNo > FLastUsedPageNo) then
     //  FLastUsedPageNo := EAMPageNo;
    end;

  // Calculate LastUsedPageNo
  FLastUsedPageNo := OldLastUsedPageNo;
  ///if (PFSPageNo > FLastUsedPageNo) then FLastUsedPageNo := PFSPageNo;
  ///if (EAMPageNo > FLastUsedPageNo) then FLastUsedPageNo := EAMPageNo;
  while IsPagePfsOrEam(FLastUsedPageNo) do Inc(FLastUsedPageNo);

  // Apply EAM usage flags to PFS
  for pn:=OldEAMLastPosition+1 to NewEAMLastPosition do
  begin
   EAMPageNo := EamPageNoForEamPagePosition(pn);
   SetPageUsageToPFS(EAMPageNo, True);
  end;

  // Apply PFS usage flags to EAM
  for pn:=OldPFSLastPosition+1 to NewPFSLastPosition do
    SetPageUsageToEAM(PfsPageNoForPfsPagePosition(pn), True);

  // Set First page in this part is Used
  Result := FLastUsedPageNo;
  SetPageUsage(Result, True);
end;//AddNewPageAndExtentFile


//------------------------------------------------------------------------------
// TruncateFile
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.TruncateFile;
var
 DelPagesCount: Integer;
begin
 if ( ((FTotalPageCount-1) - FLastUsedPageNo) >= DelPagesStep) then
 //if (FLastUsedPageNo < FTotalPageCount) then
  begin
   DelPagesCount := (FTotalPageCount-1) - FLastUsedPageNo;
   DelPagesCount := (DelPagesCount div DelPagesStep) * DelPagesStep;
   LPageManager.TruncateFile(DelPagesCount);
   FTotalPageCount := LPageManager.DBHeader.TotalPageCount;
  end;
end;//TruncateFile


//------------------------------------------------------------------------------
// ActualizePageCountVariables
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.ReReadPageCountVariables;
begin
   LPageManager.LoadDBHeader;
   FLastUsedPageNo := LPageManager.DBHeader^.LastUsedPageNo;
   FTotalPageCount := LPageManager.DBHeader^.TotalPageCount;
end;//ReReadPageCountVariables


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.ReWritePageCountVariables;
begin
  if ((FLastUsedPageNo <> LPageManager.DBHeader^.LastUsedPageNo) or
      (FTotalPageCount <> LPageManager.DBHeader^.TotalPageCount)) then
   begin
    LPageManager.DBHeader^.LastUsedPageNo := FLastUsedPageNo;
    LPageManager.DBHeader^.TotalPageCount := FTotalPageCount;
    LPageManager.SaveDBHeader;
   end;
end;


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDatabaseFreeSpaceManager.Create(aPageManager: TABSDiskPageManager);
begin
 LPageManager := aPageManager;

 FPageCountInExtent := LPageManager.FDBHeader.PageCountInExtent;

 FLastUsedPageNo := LPageManager.FDBHeader.LastUsedPageNo;
 FTotalPageCount := LPageManager.FDBHeader.TotalPageCount;

 FPFSPage_PagesAddressed := LPageManager.PageDataSize * 8;
 FEAMPage_ExtentsAddressed := LPageManager.PageDataSize *  4;
 FEAMPage_PagesAddressed := FEAMPage_ExtentsAddressed * FPageCountInExtent ;

 FSuppressDBHeaderErrors := False;
 //FAddPagesStep := FPageCountInExtent;
 //FDelPagesStep := FPageCountInExtent;

end; // Create


//------------------------------------------------------------------------------
// get page
//------------------------------------------------------------------------------
function TABSDatabaseFreeSpaceManager.GetPage(DesiredStartPageNo: TABSPageNo = INVALID_PAGE_NO): TABSPageNo;
begin
{  if (not TryUsingTimeOut(LPageManager.LockFreeSpaceManager,FTryCount,FDelayMS)) then
   raise EABSException.Create(10472,ErrorLLockByTimeoutFailed,[FTryCount,FDelayMS]);
  try}
   if TryUsingTimeOut(LPageManager.LockDBHeader, DBHeaderLockRetries, DBHeaderLockDelay) then
     try
       ReReadPageCountVariables;
       try
        Result := FindAndReusePage;
        if (Result = INVALID_PAGE_NO) then
         Result := AddNewPageAndExtentFile;
        if Result > FLastUsedPageNo then
         FLastUsedPageNo := Result;
        finally
         ReWritePageCountVariables;
        end;
     finally
        LPageManager.UnlockDBHeader;
     end
   else
     raise EABSException.Create(20231, ErrorADatabaseLocked);
{  finally
   LPageManager.UnlockFreeSpaceManager;
  end;}
end; // GetPage


//------------------------------------------------------------------------------
// free page
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.FreePage(PageNo: TABSPageNo);
begin
{  if (not TryUsingTimeOut(LPageManager.LockFreeSpaceManager,FTryCount,FDelayMS)) then
   raise EABSException.Create(10473,ErrorLLockByTimeoutFailed,[FTryCount,FDelayMS]);}
  if TryUsingTimeOut(LPageManager.LockDBHeader, DBHeaderLockRetries, DBHeaderLockDelay) then
    try
       ReReadPageCountVariables;
       try
        SetPageUsage(PageNo, False);
        FLastUsedPageNo := FindLastUsedPageNo;
        TruncateFile;
       finally
        ReWritePageCountVariables;
       end;
    finally
       LPageManager.UnlockDBHeader;
    end
   else
     raise EABSException.Create(20232, ErrorADatabaseLocked);
{  finally
   LPageManager.UnlockFreeSpaceManager;
  end;}
end; // FreePage


//------------------------------------------------------------------------------
// CheckPageNoForSystemPages
//------------------------------------------------------------------------------
procedure TABSDatabaseFreeSpaceManager.CheckPageNoForSystemPages(PageNo: TABSPageNo);
begin
{// doesn't work in multi-user mode without DBHeader reload
  if (((not FSuppressDBHeaderErrors) and (PageNo > FTotalPageCount)) or
      (PageNo < 0)) then
    raise EABSException.Create(30433, ErrorGPageCannotBeAddressed,
                              [PageNo, FTotalPageCount]);
}
  if IsPagePfsOrEam(PageNo) then
    raise EABSException.Create(30434, ErrorGCannotDeletePFSOrEAMPage, [PageNo]);
end;//CheckPageNoForSystemPages




////////////////////////////////////////////////////////////////////////////////
//
// TABSDTPCTableInfo
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// Clear
//------------------------------------------------------------------------------
procedure TABSDTPCTableInfo.Clear;
begin
  IsMostUpdatedLoaded := false;
  TableState := -1;
end;// Clear


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDTPCTableInfo.Create(aTableID: TABSTableID);
begin
  TableID := aTableID;
  TableSLockCount := 0;
  IsMostUpdatedLoaded := false;
  TableState := -1;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDTPCTableInfo.Destroy;
begin

end;// Destroy


//------------------------------------------------------------------------------
// TableIsSLocked
//------------------------------------------------------------------------------
procedure TABSDTPCTableInfo.TableIsSLocked;
begin
  if (TableSLockCount+TableRWLockCount = 0) then
    Clear;
  Inc(TableSLockCount);
end;// TableIsSLocked


//------------------------------------------------------------------------------
// TableIsSUnlocked
//------------------------------------------------------------------------------
procedure TABSDTPCTableInfo.TableIsSUnlocked;
begin
  if (TableSLockCount > 0) then
    Dec(TableSLockCount);
  if (TableSLockCount+TableRWLockCount = 0) then
    Clear;
end;// TableIsSUnlocked


//------------------------------------------------------------------------------
// TableIsRWLocked
//------------------------------------------------------------------------------
procedure TABSDTPCTableInfo.TableIsRWLocked;
begin
  if (TableSLockCount+TableRWLockCount = 0) then
    Clear;
  Inc(TableRWLockCount);
end;// TableIsRWLocked


//------------------------------------------------------------------------------
// TableIsRWUnlocked
//------------------------------------------------------------------------------
procedure TABSDTPCTableInfo.TableIsRWUnlocked;
begin
  if (TableRWLockCount > 0) then
    Dec(TableRWLockCount);
  if (TableSLockCount+TableRWLockCount = 0) then
    Clear;
end;// TableIsRWUnlocked


//------------------------------------------------------------------------------
// GetIsMostUpdatedLoaded
//------------------------------------------------------------------------------
function TABSDTPCTableInfo.GetIsMostUpdatedLoaded: Boolean;
begin
  Result := IsMostUpdatedLoaded;
end;// GetIsMostUpdatedLoaded


//------------------------------------------------------------------------------
// SetIsMostUpdatedLoaded
//------------------------------------------------------------------------------
procedure TABSDTPCTableInfo.SetIsMostUpdatedLoaded(aTableState: Integer);
begin
  if (not IsMostUpdatedLoaded) then
    begin
      IsMostUpdatedLoaded := True;
      TableState := aTableState;
    end;
end;// SetIsMostUpdatedLoaded


//------------------------------------------------------------------------------
// IsTableLockedFromModification
//------------------------------------------------------------------------------
function TABSDTPCTableInfo.IsTableLockedFromModification: Boolean;
begin
  Result := (TableSLockCount+TableRWLockCount > 0);
end;// IsTableLockedFromModification


////////////////////////////////////////////////////////////////////////////////
//
// TABSDTPCSessionInfo
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDTPCSessionInfo.Create;
begin
  FWorkTableIDs := TList.Create;
end;// Create

//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDTPCSessionInfo.Destroy;
var
  i: Integer;
begin
  FWorkTableIDs.Free;
  for i:=0 to Length(FTableInfo)-1 do
    FTableInfo[i].Free;
end;// Destroy


//------------------------------------------------------------------------------
// GetTableInfo
//------------------------------------------------------------------------------
function TABSDTPCSessionInfo.GetTableInfo(TableID: TABSTableID): TABSDTPCTableInfo;
var
  i: Integer;
begin
  Result := nil;
  for i:=0 to Length(FTableInfo)-1 do
   if (FTableInfo[i].TableID = TableID) then
     begin
       Result := FTableInfo[i];
       break;
     end;
  if (Result = nil) then
    begin
      SetLength(FTableInfo, Length(FTableInfo)+1);
      Result := TABSDTPCTableInfo.Create(TableID);
      FTableInfo[Length(FTableInfo)-1] := Result;
    end;
end;// GetTableInfo


//------------------------------------------------------------------------------
// BeginWorkWithTable
//------------------------------------------------------------------------------
procedure TABSDTPCSessionInfo.BeginWorkWithTable(TableID: TABSTableID);
begin
  FWorkTableIDs.Add(Pointer(TableID));
end;// BeginWorkWithTable


//------------------------------------------------------------------------------
// EndWorkWithTable
//------------------------------------------------------------------------------
procedure TABSDTPCSessionInfo.EndWorkWithTable(TableID: TABSTableID);
begin
  FWorkTableIDs.Remove(Pointer(TableID));
end;// EndWorkWithTable


//------------------------------------------------------------------------------
// GetWorkTableState
//------------------------------------------------------------------------------
function TABSDTPCSessionInfo.GetWorkTableState(var WorkTableState: Integer): Boolean;
begin
  Result := (FWorkTableIDs.Count > 0);
  if (Result) then
    with GetTableInfo(Integer(FWorkTableIDs[FWorkTableIDs.Count-1])) do
      begin
        Result := IsTableLockedFromModification and (IsMostUpdatedLoaded);
        WorkTableState := TableState;
      end;
end;// GetWorkTableState




////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskTablePagesCacheManager
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// GetSessionInfo
//------------------------------------------------------------------------------
function TABSDiskTablePagesCacheManager.GetSessionInfo(SessionID: TABSSessionID): TABSDTPCSessionInfo;
var
  Index: Integer;
  i, OldLength: Integer;
begin
  Index := SessionID - MIN_SESSION_ID;
  if (Index >= Length(FSessionInfo)) then
    begin
      OldLength := Length(FSessionInfo);
      SetLength(FSessionInfo, Index+1);
      for i:=OldLength to Index do
        FSessionInfo[i] := TABSDTPCSessionInfo.Create;
    end;
  Result := FSessionInfo[Index];
end;// GetSessionInfo


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDiskTablePagesCacheManager.Create;
begin

end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDiskTablePagesCacheManager.Destroy;
var
  i: Integer;
begin
  for i:=0 to Length(FSessionInfo)-1 do
   if (FSessionInfo[i] <> nil) then
     FSessionInfo[i].Free;
end;// Destroy


//------------------------------------------------------------------------------
// TableIsSLocked
//------------------------------------------------------------------------------
procedure TABSDiskTablePagesCacheManager.TableIsSLocked(
  SessionID: TABSSessionID; TableID: TABSTableID);
begin
  GetSessionInfo(SessionID).GetTableInfo(TableID).TableIsSLocked;
end;// TableIsSLocked


//------------------------------------------------------------------------------
// TableIsSUnlocked
//------------------------------------------------------------------------------
procedure TABSDiskTablePagesCacheManager.TableIsSUnlocked(
  SessionID: TABSSessionID; TableID: TABSTableID);
begin
  GetSessionInfo(SessionID).GetTableInfo(TableID).TableIsSUnlocked;
end;// TableIsSUnlocked


//------------------------------------------------------------------------------
// TableIsRWLocked
//------------------------------------------------------------------------------
procedure TABSDiskTablePagesCacheManager.TableIsRWLocked(
  SessionID: TABSSessionID; TableID: TABSTableID);
begin
  GetSessionInfo(SessionID).GetTableInfo(TableID).TableIsRWLocked;
end;// TableIsRWLocked


//------------------------------------------------------------------------------
// TableIsRWUnlocked
//------------------------------------------------------------------------------
procedure TABSDiskTablePagesCacheManager.TableIsRWUnlocked(
  SessionID: TABSSessionID; TableID: TABSTableID);
begin
  GetSessionInfo(SessionID).GetTableInfo(TableID).TableIsRWUnlocked;
end;// TableIsRWUnlocked


//------------------------------------------------------------------------------
// GetIsMostUpdatedLoaded
//------------------------------------------------------------------------------
function TABSDiskTablePagesCacheManager.GetIsMostUpdatedLoaded(
  SessionID: TABSSessionID; TableID: TABSTableID): Boolean;
begin
  Result := GetSessionInfo(SessionID).GetTableInfo(TableID).GetIsMostUpdatedLoaded;
end;// GetIsMostUpdatedLoaded


//------------------------------------------------------------------------------
// SetIsMostUpdatedLoaded
//------------------------------------------------------------------------------
procedure TABSDiskTablePagesCacheManager.SetIsMostUpdatedLoaded(
  SessionID: TABSSessionID; TableID: TABSTableID; TableState: Integer);
begin
  GetSessionInfo(SessionID).GetTableInfo(TableID).SetIsMostUpdatedLoaded(TableState);
end;// SetIsMostUpdatedLoaded


//------------------------------------------------------------------------------
// BeginWorkWithTable
//------------------------------------------------------------------------------
procedure TABSDiskTablePagesCacheManager.BeginWorkWithTable(
  SessionID: TABSSessionID; TableID: TABSTableID);
begin
  GetSessionInfo(SessionID).BeginWorkWithTable(TableID);
end;// BeginWorkWithTable


//------------------------------------------------------------------------------
// EndWorkWithTable
//------------------------------------------------------------------------------
procedure TABSDiskTablePagesCacheManager.EndWorkWithTable(
  SessionID: TABSSessionID; TableID: TABSTableID);
begin
  GetSessionInfo(SessionID).EndWorkWithTable(TableID);
end;// EndWorkWithTable


//------------------------------------------------------------------------------
// GetWorkTableState
//------------------------------------------------------------------------------
function TABSDiskTablePagesCacheManager.GetWorkTableState(
  SessionID: TABSSessionID; var WorkTableState: Integer): Boolean;
begin
  Result := GetSessionInfo(SessionID).GetWorkTableState(WorkTableState);
end;// GetWorkTableState




////////////////////////////////////////////////////////////////////////////////
//
// TABSDiskPageManager
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// init DBHeader
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.InitHeaders;
begin
  FDBHeader.Signature := ABSDiskSignature1 + ABSDiskSignature2;
  FDBHeader.Version := ABSVersion;
  FDBHeader.TotalPageCount := 0;
  //FDBHeader.HeaderSize := Sizeof(FDBHeader) + DefaultDBHeaderReserved;
  FDBHeader.HeaderSize := Sizeof(FDBHeader);
  FDBHeader.LastUsedPageNo := -1;
  FDBHeader.WriteChangesState := WriteChangesFinished;

  FLockedBytes.LockedByteSize := Sizeof(FLockedBytes);
  FCryptoHeader.CryptoHeaderSize := Sizeof(FCryptoHeader);
end; // InitDBHeader


//------------------------------------------------------------------------------
// load DBHeader
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.LoadDBHeader;
begin
  OpenFileForDesignTime;
  try
    if (not FDatabaseFile.IsOpened) then
      raise EABSException.Create(10459,ErrorLDatabaseFileIsNotOpened);
    FillChar(FDBHeader, sizeof(FDBHeader), #0);
    // Read Header
    FDatabaseFile.ReadBuffer(FDBHeader,Sizeof(FDBHeader),FOffsetToDBHeader,10464);
{
    //Read LocalBytesCount
    Inc(Position,(FDBHeader.HeaderSize));
    FDatabaseFile.ReadBuffer(FLockedBytes,Sizeof(Word),Position,10465);

    FOffsetToLastObjectID := FDBHeader.HeaderSize + FLockedBytes.LockedByteSize;
}
  finally
    CloseFileForDesignTime;
  end;
end; // LoadDBHeader


//------------------------------------------------------------------------------
// save DBHeader
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.SaveDBHeader(PerformExternalAppUpdateCheck: boolean = True);
var
  DBHeaderInFile: TABSDBHeader;
begin
  OpenFileForDesignTime;
  try
    if (not FDatabaseFile.IsOpened) then
      raise EABSException.Create(10460,ErrorLDatabaseFileIsNotOpened);
    // check that file is not updated by external app
    if (IsDesignMode) then
      begin
        FDatabaseFile.ReadBuffer(DBHeaderInFile,Sizeof(DBHeaderInFile),FOffsetToDBHeader,20195);
        if ((DBHeaderInFile.State <> FDBHeader.State) and
            (DBHeaderInFile.WriteChangesState = WriteChangesStarted) and
            PerformExternalAppUpdateCheck)  // 5.10 - fix 20195 error at design time
            then
          raise EABSException.Create(20196, ErrorADatabaseFileIsModifiedByExternalApp);
      end;
    FDatabaseFile.WriteBuffer(FDBHeader,Sizeof(FDBHeader),FOffsetToDBHeader,10462);
{
    Inc(Position,(FDBHeader.HeaderSize));
    FDatabaseFile.WriteBuffer(FLockedBytes,Sizeof(FLockedBytes),Position,10463);
    Inc(Position,FLockedBytes.LockedByteCount + Sizeof(FLockedBytes));
    if (FDatabaseFile.Size < Position) then
      FDatabaseFile.Size := Position;
}
  finally
    CloseFileForDesignTime;
  end;
end; // SaveDBHeader


//------------------------------------------------------------------------------
// GetDbHeader
//------------------------------------------------------------------------------
function TABSDiskPageManager.GetDbHeader: PABSDBHeader;
begin
  Result := @FDBHeader;
end;//GetDbHeader


//------------------------------------------------------------------------------
// LoadCryptoHeader
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.LoadCryptoHeader;
begin
  OpenFileForDesignTime;
  try
    if (not FDatabaseFile.IsOpened) then
      raise EABSException.Create(30436,ErrorLDatabaseFileIsNotOpened);
    FDatabaseFile.ReadBuffer(FCryptoHeader,Sizeof(FCryptoHeader),
                             FOffsetToCryptoHeader,30439);
  finally
    CloseFileForDesignTime;
  end;
end;//LoadCryptoHeader


//------------------------------------------------------------------------------
// SaveCryptoHeader
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.SaveCryptoHeader;
begin
  OpenFileForDesignTime;
  try
    if (not FDatabaseFile.IsOpened) then
      raise EABSException.Create(30437,ErrorLDatabaseFileIsNotOpened);
    FDatabaseFile.WriteBuffer(FCryptoHeader, Sizeof(FCryptoHeader),
                              FOffsetToCryptoHeader,30438);
  finally
    CloseFileForDesignTime;
  end;
end;//SaveCryptoHeader


//------------------------------------------------------------------------------
// LoadLockedBytes
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.LoadLockedBytes;
begin
  OpenFileForDesignTime;
  try
    if (not FDatabaseFile.IsOpened) then
      raise EABSException.Create(30441,ErrorLDatabaseFileIsNotOpened);
    // read only size of LockedBytes
    FDatabaseFile.ReadBuffer(FLockedBytes,Sizeof(SmallInt),
                             FOffsetToLockedBytes,30442);
  finally
    CloseFileForDesignTime;
  end;
end;//LoadLockedBytes


//------------------------------------------------------------------------------
// SaveLockedBytes
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.SaveLockedBytes;
begin
  OpenFileForDesignTime;
  try
    if (not FDatabaseFile.IsOpened) then
      raise EABSException.Create(30443,ErrorLDatabaseFileIsNotOpened);
    FDatabaseFile.WriteBuffer(FLockedBytes, Sizeof(FLockedBytes),
                              FOffsetToLockedBytes,30444);
  finally
    CloseFileForDesignTime;
  end;
end;//SaveLockedBytes


//------------------------------------------------------------------------------
// GetPassword
//------------------------------------------------------------------------------
function TABSDiskPageManager.GetPassword: PABSPassword;
begin
  Result := @FPassword;
end;//GetPassword


//------------------------------------------------------------------------------
// GetEncrypted
//------------------------------------------------------------------------------
function TABSDiskPageManager.GetEncrypted: Boolean;
begin
  Result := DBHeader.Encrypted;
end;// GetEncrypted


//------------------------------------------------------------------------------
// return true if database file is opened
//------------------------------------------------------------------------------
function TABSDiskPageManager.GetIsOpened: Boolean;
begin
  Result := FDatabaseFile.IsOpened;
end; // GetIsOpened


//------------------------------------------------------------------------------
// IsFileReadOnly
//------------------------------------------------------------------------------
function TABSDiskPageManager.IsFileReadOnly(DatabaseFileName: string; var MultiUser: Boolean): Boolean;
var
  handle, attr: Integer;
  mode: LongWord;
  c: AnsiChar;
begin
  Result := False;
  // check read-only attr
  attr := FileGetAttr(DatabaseFileName);
  if ((attr and faReadOnly) <> 0) then
    begin
      Result := True;
      MultiUser := False;
    end;
  if (not Result) then
   begin
{$IFDEF FILE_SERVER_VERSION}
    // try to open with shared read-write access
    if (MultiUser) then
      mode := fmOpenReadWrite or fmShareDenyNone
    else
{$ENDIF}
      // try to open with exclusive read-write access
      mode := fmOpenReadWrite or fmShareDenyWrite or fmShareDenyRead;
    Handle := SysUtils.FileOpen(DatabaseFileName, mode);
    Result := (Handle < 0);
    if (Handle >= 0) then
      begin
        // check write access
        if (SysUtils.FileRead(Handle, c, 1) = 1) then
          begin
            SysUtils.FileSeek(Handle,0,0);
            Result := (SysUtils.FileWrite(Handle, c, 1) <> 1);
          end;
        FileClose(Handle);
      end;
   end;
end;// IsFileReadOnly


//------------------------------------------------------------------------------
// return offset to beginning of the page in the file
//------------------------------------------------------------------------------
function TABSDiskPageManager.GetPageOffset(PageNo: TABSPageNo): Int64;
begin
  if (PageNo = INVALID_PAGE_NO) then
   raise EABSException.Create(10471,ErrorLInvalidPageNo,[PageNo]);
  Result := Int64(FOffsetToFirstPage) + Int64(PageNo) * Int64(FPageSize);
end; // GetPageOffset


//------------------------------------------------------------------------------
// OpenFileForDesignTime
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.OpenFileForDesignTime;
begin
  if (IsDesignMode) then
    FDatabaseFile.OpenFileForDesignTime;
end;// OpenFileForDesignTime


//------------------------------------------------------------------------------
// CloseFileForDesignTime
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.CloseFileForDesignTime;
begin
  if (IsDesignMode) then
    FDatabaseFile.CloseFileForDesignTime;
end;// CloseFileForDesignTime


//------------------------------------------------------------------------------
// return page count
//------------------------------------------------------------------------------
function TABSDiskPageManager.GetPageCount: TABSPageNo;
begin
  if (LockDBHeader) then
    try
      LoadDBHeader;
      Result := FDBHeader.TotalPageCount;
    finally
      UnlockDBHeader;
    end
  else
    raise EABSException.Create(20236, ErrorADatabaseLocked);
end; // GetPageCount


//------------------------------------------------------------------------------
// IsSafeNotToSyncPage
//------------------------------------------------------------------------------
function TABSDiskPageManager.IsSafeNotToSyncPage(SessionID: TABSSessionID; Page: TABSPage): Boolean;
var
  WorkTableState, PageTableState: Integer;
begin
  if (MultiUser) then
    begin
      Result := False;
      if (TablePagesCacheManager.GetWorkTableState(SessionID,WorkTableState)) then
        if (Page.GetTableState(SessionID,PageTableState)) then
          Result := (WorkTableState = PageTableState);
    end
  else
    Result := True;
end;// IsSafeNotToSyncPage


//------------------------------------------------------------------------------
// UpdatePageTableState
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.UpdatePageTableState(SessionID: TABSSessionID; Page: TABSPage);
var
  WorkTableState: Integer;
begin
  if (MultiUser) then
    if (TablePagesCacheManager.GetWorkTableState(SessionID,WorkTableState)) then
      Page.SetTableState(SessionID,WorkTableState);
end;// UpdatePageTableState


//------------------------------------------------------------------------------
// read page region
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.ReadPageRegion(var Buffer; PageNo: TABSPageNo; Offset, Count: Word);
begin
  if (Offset+Count > FPageSize) then
    raise EABSException.Create(10476,ErrorLInvalidPageOffset,[Offset+Count,FPageSize]);
  OpenFileForDesignTime;
  try
   FDatabaseFile.ReadBuffer(Buffer,
                           Count,GetPageOffset(PageNo)+Int64(Offset),10474);
  finally
    CloseFileForDesignTime;
  end;
end; // ReadPageRegion


//------------------------------------------------------------------------------
// write page region
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.WritePageRegion(const Buffer; PageNo: TABSPageNo; Offset, Count: Word);
begin
  if (Offset+Count > FPageSize) then
    raise EABSException.Create(10477,ErrorLInvalidPageOffset,[Offset+Count,FPageSize]);
  OpenFileForDesignTime;
  try
    FDatabaseFile.WriteBuffer(Buffer,
                            Count,GetPageOffset(PageNo)+Int64(Offset),10475);
  finally
    CloseFileForDesignTime;
  end;
end; // WritePageRegion


//------------------------------------------------------------------------------
// write empty page
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.WriteEmptyPage(PageNo: TABSPageNo);
var page: TABSPage;
begin
 Page := TABSPage.Create(Self);
 Page.PageNo := PageNo;
 try
  Page.AllocPageBuffer;
  Page.ClearPageBuffer;
  Page.PageHeader^.Signature := ABSSignature;
  Page.PageHeader^.PageType := ptEmpty;
  Page.PageHeader^.State := 0;
  Page.PageHeader^.NextPageNo := INVALID_PAGE_NO;
  Page.PageHeader^.ObjectID := INVALID_OBJECT_ID;
  InternalWritePage(Page);
 finally
  Page.Free;
 end;
end; // WriteEmptyPage


//------------------------------------------------------------------------------
// internal add page
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.InternalAddPage(aPage: TABSPage);
begin
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog(Format('TABSDiskPageManager.InternalAddPage started: SessionID=%d',
                    [aPage.SessionID]));
{$ENDIF}
  OpenFileForDesignTime;
  try
   aPage.PageNo := FDatabaseFreeSpaceManager.GetPage;
   aPage.AllocPageBuffer;
  finally
    CloseFileForDesignTime;
  end;
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog(Format('TABSDiskPageManager.InternalAddPage finished: SessionID=%d PageNo=%d State=%d',
 [aPage.SessionID, aPage.PageNo, aPage.PageHeader^.State]));
{$ENDIF}
end; // InternalAddPage


//------------------------------------------------------------------------------
// internal remove page
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.InternalRemovePage(PageNo: TABSPageNo);
begin
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog('TABSDiskPageManager.InternalRemovePage started: PageNo='+IntToStr(PageNo));
{$ENDIF}
  OpenFileForDesignTime;
  try
    InternalWritePageState(PageNo, DELETED_PAGE_STATE);
    FDatabaseFreeSpaceManager.FreePage(PageNo);
  finally
    CloseFileForDesignTime;
  end;
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog('TABSDiskPageManager.InternalRemovePage finished: PageNo='+IntToStr(PageNo));
{$ENDIF}
end; // InternalRemovePage

//------------------------------------------------------------------------------
// read page data
//------------------------------------------------------------------------------
function TABSDiskPageManager.InternalReadPage(aPage: TABSPage): Boolean;
begin
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog('TABSDiskPageManager.InternalReadPage started: SessionID='+
             IntToStr(aPage.SessionID)+' PageNo='+IntToStr(aPage.PageNo));
{$ENDIF}
  OpenFileForDesignTime;
  try
    if (aPage.PageBuffer = nil) then
     aPage.AllocPageBuffer;
    // read
    Result := FDatabaseFile.ReadBuffer(aPage.PageBuffer^,FPageSize,GetPageOffset(aPage.PageNo));
    if (Result) then
      begin
        // decrypt
        if FDBHeader.Encrypted then
         if (not FDatabaseFreeSpaceManager.IsPagePfsOrEam(aPage.PageNo)) then
          begin
           // decrypt buffer
           ABSInternalDecryptBuffer(TABSCryptoAlgorithm(aPage.PageHeader.Cipherype), aPage.PageData,
                                    aPage.PageDataSize, FPassword.Password);
           // check CRC
           if (not IgnoreCRCErrors) and (aPage.PageHeader.CRC32 <> CRC32(0, aPage.PageData, aPage.PageDataSize)) then
             raise EABSException.Create(30446, ErrorGCheckPageCRCError, [aPage.PageNo]);
          end;
      end
    else
      aPage.PageHeader^.State := DELETED_PAGE_STATE;
    aPage.Reloaded := True;
  finally
    CloseFileForDesignTime;
  end;
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog(Format('TABSDiskPageManager.InternalReadPage finished: SessionID=%d PageNo=%d State=%d',
 [aPage.SessionID, aPage.PageNo, aPage.PageHeader^.State]));
{$ENDIF}
end;// InternalReadPage


//------------------------------------------------------------------------------
// write page data
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.InternalWritePage(aPage: TABSPage);
begin
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog('TABSDiskPageManager.InternalWritePage started: SessionID='+
             IntToStr(aPage.SessionID)+' PageNo='+IntToStr(aPage.PageNo));
{$ENDIF}
  OpenFileForDesignTime;
  try
    repeat
      aPage.PageHeader^.State := aPage.PageHeader^.State + 1;
      if (aPage.PageHeader^.State = LAST_VALID_PAGE_STATE) then
        aPage.PageHeader^.State := 0;
    until (aPage.PageHeader^.State <= LAST_VALID_PAGE_STATE);

    // encrypt
    if FDBHeader.Encrypted then
     if ((not FDatabaseFreeSpaceManager.IsPagePfsOrEam(aPage.PageNo)) and
         (aPage.EncryptionEnabled)) then
      begin
       // calculate CRC
       aPage.PageHeader.Cipherype := byte(FPassword.CryptoAlgorithm);
       aPage.PageHeader.CRC32 := CRC32(0, aPage.PageData, aPage.PageDataSize);
       // encrypt buffer
       ABSInternalEncryptBuffer(FPassword.CryptoAlgorithm, aPage.PageData,
                                aPage.PageDataSize, FPassword.Password);
      end;

    FDatabaseFile.WriteBuffer(aPage.PageBuffer^,FPageSize,GetPageOffset(aPage.PageNo),10469);

    if FDBHeader.Encrypted then
     if (not FDatabaseFreeSpaceManager.IsPagePfsOrEam(aPage.PageNo)) then
      // decrypt page data in memory
       ABSInternalDecryptBuffer(TABSCryptoAlgorithm(aPage.PageHeader.Cipherype), aPage.PageData,
                                aPage.PageDataSize, FPassword.Password);
  finally
    CloseFileForDesignTime;
  end;
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog(Format('TABSDiskPageManager.InternalWritePage finished: SessionID=%d PageNo=%d State=%d',
 [aPage.SessionID, aPage.PageNo, aPage.PageHeader^.State]));
{$ENDIF}
end; // WritePageData


//------------------------------------------------------------------------------
// InternalReadPageState
//------------------------------------------------------------------------------
function TABSDiskPageManager.InternalReadPageState(PageNo: Integer): Integer;
begin
{$IFDEF FILE_SERVER_VERSION}
  if (FMultiUser) then
    begin
      OpenFileForDesignTime;
      try
        try
          FDatabaseFile.ReadBuffer(Result, sizeof(integer), GetPageOffset(PageNo)+4, 20197);
        except
          Result := DELETED_PAGE_STATE
        end;
      finally
        CloseFileForDesignTime;
      end;
    end;
{$ENDIF}
end;// InternalReadPageState


//------------------------------------------------------------------------------
// InternalWritePageState
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.InternalWritePageState(PageNo: Integer; PageState: Integer);
begin
  OpenFileForDesignTime;
  try
    FDatabaseFile.WriteBuffer(PageState, sizeof(integer), GetPageOffset(PageNo)+4, 20198);
  finally
    CloseFileForDesignTime;
  end;
end;// InternalWritePageState


//------------------------------------------------------------------------------
// GetPage
//------------------------------------------------------------------------------
function TABSDiskPageManager.GetPage(SessionID: TABSSessionID;
  PageNo: TABSPageNo; PageType: TABSPageTypeID; SynchronizeAllowed: Boolean = True): TABSPage;
begin
  FDatabaseFreeSpaceManager.CheckPageNoForSystemPages(PageNo);
  Result := inherited GetPage(SessionID, PageNo, PageType, SynchronizeAllowed);
end;//GetPage


//------------------------------------------------------------------------------
// RemovePage
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.RemovePage(SessionID: TABSSessionID;PageNo: TABSPageNo);
begin
  FDatabaseFreeSpaceManager.CheckPageNoForSystemPages(PageNo);
  inherited;
end;//RemovePage


//------------------------------------------------------------------------------
// lock Free Space Manager byte
//------------------------------------------------------------------------------
function TABSDiskPageManager.LockFreeSpaceManager: Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.LockByte(FOffsetToLockedBytes + OffsetToFreeSpaceManagerLockByte);
  finally
    CloseFileForDesignTime;
  end;
end; // LockFreeSpaceManager


//------------------------------------------------------------------------------
// unlock Free Space Manager byte
//------------------------------------------------------------------------------
function TABSDiskPageManager.UnlockFreeSpaceManager: Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.UnlockByte(FOffsetToLockedBytes + OffsetToFreeSpaceManagerLockByte);
  finally
    CloseFileForDesignTime;
  end;
end; // UnockFreeSpaceManager


//------------------------------------------------------------------------------
// lock Tables byte
//------------------------------------------------------------------------------
function TABSDiskPageManager.LockTables: Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.LockByte(FOffsetToLockedBytes + OffsetToTablesLockByte);
  finally
    CloseFileForDesignTime;
  end;
end; // LockTables


//------------------------------------------------------------------------------
// unlock Tables byte
//------------------------------------------------------------------------------
function TABSDiskPageManager.UnlockTables: Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.UnlockByte(FOffsetToLockedBytes + OffsetToTablesLockByte);
  finally
    CloseFileForDesignTime;
  end;
end; // UnockTables


//------------------------------------------------------------------------------
// LockDBHeader
//------------------------------------------------------------------------------
function TABSDiskPageManager.LockDBHeader: Boolean;
begin
  if (FLockDBHeaderCount = 0) then
    begin
      OpenFileForDesignTime;
      try
        Result := FDatabaseFile.LockByte(FOffsetToLockedBytes + OffsetToDBHeaderLockByte);
      finally
        CloseFileForDesignTime;
      end;
    end
  else
    Result := True;
    
  if (Result) then
    Inc(FLockDBHeaderCount);
end;// LockDBHeader


//------------------------------------------------------------------------------
// UnlockDBHeader
//------------------------------------------------------------------------------
function TABSDiskPageManager.UnlockDBHeader: Boolean;
begin
  Dec(FLockDBHeaderCount);
  if (FLockDBHeaderCount = 0) then
    begin
      OpenFileForDesignTime;
      try
        Result := FDatabaseFile.UnlockByte(FOffsetToLockedBytes + OffsetToDBHeaderLockByte);
      finally
        CloseFileForDesignTime;
      end;
    end
  else
    Result := True;
end;// UnlockDBHeader


//------------------------------------------------------------------------------
// Lock LastObjectID
//------------------------------------------------------------------------------
function TABSDiskPageManager.LockLastObjectID: Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.LockByte(FOffsetToLastObjectID);
  finally
    CloseFileForDesignTime;
  end;
end;//LockLastObjectID


//------------------------------------------------------------------------------
// unlock LastObjectID
//------------------------------------------------------------------------------
function TABSDiskPageManager.UnlockLastObjectID: Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.UnlockByte(FOffsetToLastObjectID);
  finally
    CloseFileForDesignTime;
  end;
end;//UnlockLastObjectID


//------------------------------------------------------------------------------
// Lock Byte (return TRUE if success)
//------------------------------------------------------------------------------
function TABSDiskPageManager.LockPageByte(PageNo: TABSPageNo; Offset: Word): Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.LockByte(GetPageOffset(PageNo) + Int64(Offset));
  finally
    CloseFileForDesignTime;
  end;
end; // LockPageByte


//------------------------------------------------------------------------------
// Unlock Byte
//------------------------------------------------------------------------------
function TABSDiskPageManager.UnlockPageByte(PageNo: TABSPageNo; Offset: Word): Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.UnlockByte(GetPageOffset(PageNo) + Int64(Offset));
  finally
    CloseFileForDesignTime;
  end;
end; // UnlockPageByte


//------------------------------------------------------------------------------
// return True if byte is locked
//------------------------------------------------------------------------------
function TABSDiskPageManager.IsPageByteLocked(PageNo: TABSPageNo; Offset: Word): Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.IsByteLocked(GetPageOffset(PageNo) + Int64(Offset));
  finally
    CloseFileForDesignTime;
  end;
end; // IsPageByteLocked


//------------------------------------------------------------------------------
// return True if any byte of region is locked
//------------------------------------------------------------------------------
function TABSDiskPageManager.IsPageRegionLocked(PageNo: TABSPageNo; Offset: Word; Count: Word): Boolean;
begin
  OpenFileForDesignTime;
  try
    Result := FDatabaseFile.IsRegionLocked(
                GetPageOffset(PageNo) + Int64(Offset),Count);
  finally
    CloseFileForDesignTime;
  end;
end; // IsPageRegionLocked


//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
constructor TABSDiskPageManager.Create;
begin
 inherited Create;
 FDatabaseFreeSpaceManager := nil;
 FDatabaseFile := TABSDatabaseFile.Create;
 InitHeaders;
 FLockDBHeaderCount := 0;
  // calc offsets
  FOffsetToDBHeader := 0;
  FOffsetToCryptoHeader := FOffsetToDBHeader + Sizeof(TABSDBHeader);
  FOffsetToLockedBytes := FOffsetToCryptoHeader + Sizeof(TABSCryptoHeader);
  FOffsetToLastObjectID := FOffsetToLockedBytes + Sizeof(TABSLockedBytes);
  FOffsetToFirstPage := FOffsetToLastObjectID + Sizeof(TABSLastObjectID);
 FTablePagesCacheManager := TABSDiskTablePagesCacheManager.Create;
end; // Create


//------------------------------------------------------------------------------
// destructor
//------------------------------------------------------------------------------
destructor TABSDiskPageManager.Destroy;
begin
  CloseDatabase;
  FreeAndNil(FDatabaseFile);
  FTablePagesCacheManager.Free;
  inherited Destroy;
end; // Destroy


//------------------------------------------------------------------------------
// CreateAndOpenDatabase
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.CreateAndOpenDatabase(
                              DatabaseFileName: string;
                              Password:         TABSPassword;
                              PageSize:         Word = DefaultPageSize;
                              ExtentPageCount:  Word = DefaultExtentPageCount
                                            );
var
  i: Integer;
begin
  if (FDatabaseFile.IsOpened) then
   raise EABSException.Create(10461,ErrorLDatabaseFileIsInUse,[FDatabaseFile.FileName]);

  FPageSize := PageSize;
  FPageHeaderSize := Sizeof(TABSDiskPageHeader);
  FPageDataSize := FPageSize - FPageHeaderSize;
  FPassword := Password;

  FDatabaseFile.CreateAndOpenFile(DatabaseFileName);
  // InitDBHeader;
  FDBHeader.Encrypted := (FPassword.Password <> '');
  FDBHeader.PageSize := PageSize;
  FDBHeader.PageCountInExtent := ExtentPageCount;

  if FDBHeader.Encrypted then
   begin
    FCryptoHeader.CryptoAlgorithm := Byte(FPassword.CryptoAlgorithm);

    // Random fill ControlBlock
    for i:=0 to ABS_CONTROL_BLOCK_SIZE-1 do
      FCryptoHeader.ControlBlock[i] := RandomRange(0,255);

    // Calc CRC for ControlBlock
    FCryptoHeader.ControlBlockCRC := CRC32(0,
                                           TAbsPByte(@FCryptoHeader.ControlBlock[0]),
                                           ABS_CONTROL_BLOCK_SIZE);
    // Encrypt ControlBlock
    ABSInternalEncryptBuffer(FPassword.CryptoAlgorithm,
                             TAbsPByte(@FCryptoHeader.ControlBlock[0]),
                             ABS_CONTROL_BLOCK_SIZE, FPassword.Password);
   end;


  // Save Headers
  SaveDBHeader;
  SaveCryptoHeader;
  SaveLockedBytes;
  InitObjectID;
  FDatabaseFreeSpaceManager := TABSDatabaseFreeSpaceManager.Create(Self);
end; // CreateAndOpenDatabase


//------------------------------------------------------------------------------
// Open database
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.OpenDatabase(
                DatabaseFileName: string;
                Password:         TABSPassword;
                var ReadOnly:     Boolean;
                var RepairNeeded: Boolean;
                Exclusive:        Boolean;
                var aMultiUser:    Boolean
                                          );
var AccessMode: TABSAccessMode;
    ShareMode: TABSShareMode;
begin
 if (FDatabaseFile.IsOpened) then
  raise EABSException.Create(10462,ErrorLDatabaseFileIsInUse,[FDatabaseFile.FileName]);

 FPassword := Password;

 // auto-detect read-only database file
 if (not ReadOnly) then
  if (SysUtils.FileExists(DatabaseFileName)) then
   ReadOnly := IsFileReadOnly(DatabaseFileName, aMultiUser);
 MultiUser := aMultiUser;

 FExclusive := Exclusive;
 if (ReadOnly) then
   begin
     AccessMode := amReadOnly;
     ShareMode := smShareDenyNone;
   end
 else
   begin
     AccessMode := amReadWrite;
     if (Exclusive) then
       begin
        ShareMode := smExclusive;
        FMultiUser := False;
       end
     else
      ShareMode := smShareDenyNone;
   end;
 FDatabaseFile.OpenFile(DatabaseFileName,AccessMode,ShareMode);
 if (IsDesignMode) then
   FDatabaseFile.CloseFile;

 // Load DBHeader
 FOffsetToDBHeader := 0;
 if TryUsingTimeOut(LockDBHeader, DBHeaderLockRetries, DBHeaderLockDelay) then
   try
      // find signature
      OpenFileForDesignTime;
      try
        if (not FDatabaseFile.FindSignature(FOffsetToDBHeader)) then
          FOffsetToDBHeader := 0;
      finally
        CloseFileForDesignTime;
      end;
      // load db header
      LoadDBHeader;
      RepairNeeded := (FDBHeader.WriteChangesState <> WriteChangesFinished);
      // converting to the new format?
      if (FDBHeader.Version < 2.99) then
        RepairNeeded := True;
   finally
      UnlockDBHeader;
   end
 else
   raise EABSException.Create(20230, ErrorADatabaseLocked);

 if (FDBHeader.Signature <> (ABSDiskSignature1 + ABSDiskSignature2)) then
  raise EABSException.Create(10470,ErrorLInvalidSignature,
        [FDBHeader.Signature,(ABSDiskSignature1 + ABSDiskSignature2)]);

 FPageSize := FDBHeader.PageSize;
 FPageHeaderSize := Sizeof(TABSDiskPageHeader);
 FPageDataSize := FPageSize - FPageHeaderSize;

 // Load CryptoHeader
 FOffsetToCryptoHeader := FOffsetToDBHeader + FDBHeader.HeaderSize;
 FOffsetToLockedBytes := FOffsetToCryptoHeader + Sizeof(TABSCryptoHeader);
 LoadCryptoHeader;
 if FDBHeader.Encrypted then
  begin
    FPassword.CryptoAlgorithm := TABSCryptoAlgorithm(FCryptoHeader.CryptoAlgorithm);
    // Decrypt ControlBlock
    ABSInternalDecryptBuffer(FPassword.CryptoAlgorithm,
                             TAbsPByte(@FCryptoHeader.ControlBlock[0]),
                             ABS_CONTROL_BLOCK_SIZE, FPassword.Password);
    // Calc CRC for ControlBlock
    if (FCryptoHeader.ControlBlockCRC <> CRC32(0,
                                           TAbsPByte(@FCryptoHeader.ControlBlock[0]),
                                           ABS_CONTROL_BLOCK_SIZE)) then
      raise EABSException.Create(30445, ErrorGWrongPassword);
  end;

 // Load LockedBytes
 if (FOffsetToLockedBytes <> FOffsetToCryptoHeader + FCryptoHeader.CryptoHeaderSize) then
   raise EABSException.Create(20237, ErrorAInvalidDatabaseFormat);
 LoadLockedBytes;

 // LastObjectID
 FOffsetToLastObjectID := FOffsetToLockedBytes + FLockedBytes.LockedByteSize;

 // Offset to FirstPage
 FOffsetToFirstPage := FOffsetToLastObjectID + Sizeof(TABSLastObjectID);

 FDatabaseFreeSpaceManager := TABSDatabaseFreeSpaceManager.Create(Self);
end; // OpenDatabase


//------------------------------------------------------------------------------
// Close database
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.CloseDatabase;
begin
 if (FDatabaseFile.FIsOpened) then
  begin
{   if (FDatabaseFile.FAccessMode <> amReadOnly) then
     SaveDBHeader;}
   try
     FDatabaseFile.CloseFile;
   except
     FDatabaseFile.FIsOpened := false;
   end;
  end;
 if (FDatabaseFreeSpaceManager <> nil) then
  FreeAndNil(FDatabaseFreeSpaceManager);
end; // CloseDatabase


//------------------------------------------------------------------------------
// Truncate Database File to Last Used PageNo
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.TruncateDatabase;
var
  Count: Integer;
begin
  Count := FDBHeader.TotalPageCount - 1 - FDBHeader.LastUsedPageNo;
  if (Count > 0) then TruncateFile(Count);
end;//TruncateDatabase


//------------------------------------------------------------------------------
// extend file by number of pages specified by PageCount
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.ExtendFile(PageCount: TABSPageNo);
begin
  if (PageCount > 0) then
   begin
    FDatabaseFile.Size := FDatabaseFile.Size + (Int64(PageCount) * Int64(PageSize));
    Inc(FDBHeader.TotalPageCount,PageCount);
   end;
end; // ExtendFile


//------------------------------------------------------------------------------
// Truncate file by number of pages specified by PageCount
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.TruncateFile(PageCount: TABSPageNo);
begin
  if ( (PageCount > 0) and ((FDBHeader.TotalPageCount-PageCount) >= 0) ) then
   begin
    Dec(FDBHeader.TotalPageCount, PageCount);
    FDatabaseFile.Size := FDatabaseFile.Size - Int64(PageCount) * Int64(FPageSize);
    SaveDBHeader;
   end;
end;//TruncateFile


//------------------------------------------------------------------------------
// Increment LastObjectID and return it
//------------------------------------------------------------------------------
function TABSDiskPageManager.GetNextObjectID(TryCount: Integer=5; DelayMS: Integer=100): TABSLastObjectID;
begin
  OpenFileForDesignTime;
  try
    if (not FDatabaseFile.IsOpened) then
      raise EABSException.Create(30399,ErrorLDatabaseFileIsNotOpened,[]);

    if TryUsingTimeOut(LockLastObjectID, LockLastObjectIDRetries, LockLastObjectIDDelay) then
      try
        FDatabaseFile.ReadBuffer(Result,Sizeof(Result),FOffsetToLastObjectID, 30400);
        Inc(Result);
        // db file is read-only?
        if (FDatabaseFile.FAccessMode <> amReadOnly) then
          FDatabaseFile.WriteBuffer(Result,Sizeof(Result),FOffsetToLastObjectID,30404)
        else
          Result := Result + Random(10000);
      finally
        UnlockLastObjectID;
      end
    else
      raise EABSException.Create(30401, ErrorGCannotGetNextObjectID);
  finally
    CloseFileForDesignTime;
  end;
end;//GetNextObjectID


//------------------------------------------------------------------------------
// InitObjectID
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.InitObjectID(TryCount: Integer=5; DelayMS: Integer=100);
const n: TABSObjectID = 0;
begin
  OpenFileForDesignTime;
  try
    if TryUsingTimeOut(LockLastObjectID, LockLastObjectIDRetries, LockLastObjectIDDelay) then
      try
        if (FDatabaseFile.FAccessMode <> amReadOnly) then
          FDatabaseFile.WriteBuffer(n,Sizeof(n),FOffsetToLastObjectID, 30406);
      finally
        UnlockLastObjectID;
      end
  finally
    CloseFileForDesignTime;
  end;
end;//InitObjectID


//------------------------------------------------------------------------------
// ApplyChanges
//------------------------------------------------------------------------------
procedure TABSDiskPageManager.ApplyChanges(SessionID: TABSSessionID);
var
  SessionNo: Integer;
begin
  OpenFileForDesignTime;
  try
    if (FindSession(SessionID, SessionNo)) then
      if ((FSessions[SessionNo].RemovedPageNumbers.ItemCount > 0) or
          (FSessions[SessionNo].AddedPageNumbers.ItemCount > 0) or
          (FSessions[SessionNo].DirtyPages.Count > 0)) then
        begin
          if TryUsingTimeOut(LockDBHeader, DBHeaderLockRetries, DBHeaderLockDelay) then
            try
              LoadDBHeader;
              FDBHeader.WriteChangesState := WriteChangesStarted;
              SaveDBHeader;
              inherited ApplyChanges(SessionID);
              FDBHeader.State := FDBHeader.State + 1;
              FDBHeader.WriteChangesState := WriteChangesFinished;
              SaveDBHeader(False); // 5.10 fix 20195 error which always 
                                   // raised when database modified in design time
            finally
              UnlockDBHeader;
            end
          else
            raise EABSException.Create(20213, ErrorADatabaseLocked);
        end;
  finally
    CloseFileForDesignTime;
  end;
end;// ApplyChanges





////////////////////////////////////////////////////////////////////////////////
//
// TABSInternalDBTransactedAccessFile
//
////////////////////////////////////////////////////////////////////////////////



//------------------------------------------------------------------------------
// SetStartPageNo
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.SetStartPageNo(StartPageNo: TABSPageNo);
begin
  if (StartPageNo <> INVALID_PAGE_NO) then
    FStartPageNo := StartPageNo;
end;//SetStartPageNo


//------------------------------------------------------------------------------
// raise if file is Closed
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.CheckFileOpened(OperationName: AnsiString);
begin
  if (FStartPageNo = INVALID_PAGE_NO) then
    raise EABSException.Create(30389, ErrorGIFClosed, [OperationName]);
end;//CheckFileOpened


//------------------------------------------------------------------------------
// return Count of File Pages for Size
//------------------------------------------------------------------------------
function TABSInternalDBTransactedAccessFile.GetPageCountForDataSize(DataSize: Integer): Integer;
var Offset: word;
   begin
  GetPageNoAndOffsetForPosition(DataSize, Result, Offset);
  Inc(Result);
end;//GetPageCountForDataSize


//------------------------------------------------------------------------------
// return PagePosition and Offset in page
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.GetPageNoAndOffsetForPosition(Position: Integer; var PagePosition: Integer; var Offset: word);
begin
  Offset := (Position + SizeOf(TABSInternalFileHeader) ) mod LPageManager.PageDataSize;
  PagePosition := Ceil( (Position + SizeOf(TABSInternalFileHeader)) / LPageManager.PageDataSize) - 1;
end;//GetPageOffsetForPosition


//------------------------------------------------------------------------------
// return real page No for file page (firstPageNo=0)
//------------------------------------------------------------------------------
function TABSInternalDBTransactedAccessFile.GoToPage(SessionID: TABSSessionID; PagePosition: TABSPageNo): TABSPageNo;
var
  Page: TABSPage;
  i:    Integer;
begin
  Result := FStartPageNo;
  for i:=0 to PagePosition-1 do
    begin
      Page := LPageManager.GetPage(SessionID, Result, FPageTypeID);
      Result := Page.PageHeader.NextPageNo;
      LPageManager.PutPage(Page);
      if (Result = INVALID_PAGE_NO) then
        raise EABSException.Create(20300, ErrorACannotFindNthPage, [i]);
    end;
end;//GoToPage


//------------------------------------------------------------------------------
// clean file header
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.InitFileHeader(SessionID: TABSSessionID);
var
  Page: TABSPage;
begin
  // Check File Opened
  if (FStartPageNo = INVALID_PAGE_NO) then
    raise EABSException.Create(20301, ErrorAInvalidPageNo);

  LPageManager.IgnoreCRCErrors := True;
  try
    Page := LPageManager.GetPage(SessionID, FStartPageNo, FPageTypeID);
    Page.InitHeader;
    Page.PageHeader.PageType := FPageTypeID;
    try
      // Init File Header
      PABSInternalFileHeader(Page.PageData).FileHeaderSize := sizeof(TABSInternalFileHeader);
      PABSInternalFileHeader(Page.PageData).FileSize := 0;
      PABSInternalFileHeader(Page.PageData).CompressionAlgorithm := Byte(acaNone);
    finally
      LPageManager.PutPage(Page);
    end;
  finally
    LPageManager.IgnoreCRCErrors := False;
  end;
end;


//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
constructor TABSInternalDBTransactedAccessFile.Create(PageManager: TABSDiskPageManager; PageTypeID: TABSPageTypeID);
begin
  LPageManager := PageManager;
  FPageTypeID := PageTypeID;
  FStartPageNo := INVALID_PAGE_NO;
end;//Create


//------------------------------------------------------------------------------
// Destructor
//------------------------------------------------------------------------------
destructor TABSInternalDBTransactedAccessFile.Destroy;
begin
  inherited;
end;//Destroy


//------------------------------------------------------------------------------
// Create file
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.CreateFile(SessionID: TABSSessionID);
var
  Page: TABSPage;
begin
  // Check File Opened
  if (FStartPageNo <> INVALID_PAGE_NO) then
    raise EABSException.Create(30383, ErrorGIFCannotRecreateFile, [FStartPageNo]);

  Page := LPageManager.AddPage(SessionID, FPageTypeID);
  try
    FStartPageNo := Page.PageNo;
    // Init File Header
    PABSInternalFileHeader(Page.PageData).FileHeaderSize := sizeof(TABSInternalFileHeader);
    PABSInternalFileHeader(Page.PageData).FileSize := 0;
    PABSInternalFileHeader(Page.PageData).CompressionAlgorithm := Byte(acaNone);
  finally
    LPageManager.PutPage(Page);
  end;
end;//CreateFile


//------------------------------------------------------------------------------
// Delete file. And free all file pages
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.DeleteFile(SessionID: TABSSessionID; StartPageNo: TABSPageNo);
var
  Page: TABSPage;
  PageNo, NextPageNo: TABSPageNo;
begin
  if (StartPageNo <> INVALID_PAGE_NO) then
   SetStartPageNo(StartPageNo);

  PageNo := FStartPageNo;
  repeat
    Page := LPageManager.GetPage(SessionID, PageNo, FPageTypeID);
    NextPageNo := Page.PageHeader.NextPageNo;
    LPageManager.PutPage(Page);
    LPageManager.RemovePage(SessionID, PageNo);
    PageNo := NextPageNo;
  until (PageNo = INVALID_PAGE_NO);

  FStartPageNo := INVALID_PAGE_NO;
end;//DeleteFile


//------------------------------------------------------------------------------
// Open file (reading file header)
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.OpenFile(StartPageNo: TABSPageNo);
begin
  SetStartPageNo(StartPageNo);
end;//OpenFile


//------------------------------------------------------------------------------
// Set File Size, ...
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.SetFileSize(SessionID: TABSSessionID;
                            NewSize: Integer; DecompressedSize: Integer;
                            CompressionAlgorithm: TABSCompressionAlgorithm);
var
  FirstPage, Page, NewPage: TABSPage;
  PageNo: TABSPageNo;
  OldSize:      Integer;
  OldPageCount: Integer;
  NewPageCount: Integer;
  i: Integer;
begin
  CheckFileOpened('SetSize');

  FirstPage := LPageManager.GetPage(SessionID, FStartPageNo, FPageTypeID);
  try
    OldSize := PABSInternalFileHeader(FirstPage.PageData).FileSize;
    if (OldSize < 0) then
      OldSize := NewSize;
    OldPageCount := GetPageCountForDataSize(OldSize);
    NewPageCount := GetPageCountForDataSize(NewSize);

    // Add or remove pages
    if (OldPageCount <> NewPageCount) then
     begin
      if (NewPageCount > OldPageCount) then
       begin
         // add and link new pages

         // go to Last Page
         PageNo := GoToPage(SessionID, OldPageCount-1);

         // get last page
         Page := LPageManager.GetPage(SessionID, PageNo, FPageTypeID);

         // add Pages
         for i:=1 to NewPageCount - OldPageCount do
          begin
            NewPage := LPageManager.AddPage(SessionID, FPageTypeID);
            // store link
            Page.PageHeader.NextPageNo := NewPage.PageNo;
            Page.IsDirty := True;
            LPageManager.PutPage(Page);

            Page := NewPage;
          end;
         // Put Last Page
         LPageManager.PutPage(Page);

       end
      else
       begin
         // remove last pages

         // go to last page
         PageNo := GoToPage(SessionID, OldPageCount-1);

         // get last page
         Page := LPageManager.GetPage(SessionID, PageNo, FPageTypeID);
         Page.PageHeader.NextPageNo := INVALID_PAGE_NO;
         Page.IsDirty := True;
         LPageManager.PutPage(Page);

       end;
     end;

    // Write New Size
    PABSInternalFileHeader(FirstPage.PageData).FileSize := NewSize;
    PABSInternalFileHeader(FirstPage.PageData).DecompressedSize := DecompressedSize;
    PABSInternalFileHeader(FirstPage.PageData).CompressionAlgorithm := Byte(CompressionAlgorithm);
    FirstPage.IsDirty := True;
  finally
    LPageManager.PutPage(FirstPage);
  end;

end;//SetFileSize


//------------------------------------------------------------------------------
// Get File Size
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.GetFileSize(SessionID: TABSSessionID;
                          var Size: Integer;
                          var DecompressedSize: Integer;
                          var CompressionAlgorithm: TABSCompressionAlgorithm;
                          var FileWasChanged: Boolean;
                          SyncronizeAllowed: Boolean);
var
  Page: TABSPage;
begin
  CheckFileOpened('GetSize');
  Page := LPageManager.GetPage(SessionID, FStartPageNo, FPageTypeID, SyncronizeAllowed);
  try
    Size := PABSInternalFileHeader(Page.PageData).FileSize;
    DecompressedSize := PABSInternalFileHeader(Page.PageData).DecompressedSize;
    CompressionAlgorithm := TABSCompressionAlgorithm(PABSInternalFileHeader(Page.PageData).CompressionAlgorithm);
    FileWasChanged := Page.Reloaded;
  finally
    LPageManager.PutPage(Page);
  end;
end;// GetFileSize


//------------------------------------------------------------------------------
// GetSize
//------------------------------------------------------------------------------
function TABSInternalDBTransactedAccessFile.GetSize(SessionID: TABSSessionID): Integer;
var
  CompressedSize: Integer;
  DecompressedSize: Integer;
  CompressionAlgorithm: TABSCompressionAlgorithm;
  FileWasChanged: Boolean;
begin
  GetFileSize(SessionID, CompressedSize, DecompressedSize, CompressionAlgorithm, FileWasChanged, True);
  Result := DecompressedSize;
end;// GetSize


//------------------------------------------------------------------------------
// Read File Data
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.ReadFile(SessionID: TABSSessionID;
                                              var Buffer; const Count: Integer; SynchronizeAllowed: Boolean = true);
var
  Page: TABSPage;
  PageNo, NextPageNo: TABSPageNo;
  BufferOffset: Integer;
  PageOffset:   Integer;
  NumBytes:     Integer;
  SizeToRead:   Integer;
  BufferToRead: TAbsPByte;
  OutBuf:       TAbsPByte;
  OutSize:      Integer;
  DecompressedSize: Integer;
  CompressionAlgorithm: TABSCompressionAlgorithm;
  FileWasChanged: Boolean;

  ///s: String;
procedure aaWriteToLog(s : AnsiString); overload;
var f : Text;
const logFileName: string = '_abs_log.txt';

begin
 Exit;

 Assign(f,logFileName);
 if (FileExists(logFileName)) then
  Append(f)
 else
  ReWrite(f);
 Writeln(f,s);
 Close(f);
end;

begin
  CheckFileOpened('ReadFile');

  GetFileSize(SessionID, SizeToRead, DecompressedSize, CompressionAlgorithm, FileWasChanged, SynchronizeAllowed);
  if Count > DecompressedSize then
   raise EABSException.Create(30387, ErrorGIFCannotRead, [DecompressedSize, Count]);

  if (CompressionAlgorithm <> acaNone) then
    BufferToRead := MemoryManager.AllocMem(SizeToRead)
  else
    begin
      SizeToRead := Count;
      BufferToRead := TAbsPByte(@Buffer);
    end;
  try
  PageOffset := SizeOf(TABSInternalFileHeader);
  PageNo := FStartPageNo;
  BufferOffset := 0;
  repeat
    Page := LPageManager.GetPage(SessionID, PageNo, FPageTypeID, SynchronizeAllowed);
    try

      NumBytes := Page.PageDataSize - PageOffset;

        if (BufferOffset + NumBytes > SizeToRead) then
          NumBytes := SizeToRead - BufferOffset;

        Move(TAbsPByte(Page.PageData + PageOffset)^, (BufferToRead + BufferOffset)^, NumBytes);

      BufferOffset := BufferOffset + NumBytes;
      PageOffset := 0;

      NextPageNo := Page.PageHeader.NextPageNo;
    finally
      LPageManager.PutPage(Page);
    end;
    PageNo := NextPageNo;
    until ( (NextPageNo = INVALID_PAGE_NO) or (BufferOffset >= SizeToRead) );

    if (BufferOffset <> SizeToRead) then
    raise EABSException.Create(30388, ErrorGIFCannotReadNBytes,
                                 [SizeToRead, BufferOffset, SizeToRead]);
  finally
    if (CompressionAlgorithm <> acaNone) then
     begin
       OutSize := DecompressedSize;

{IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog('TABSInternalDBTransactedAccessFile.ReadFile Decompression Start');
aaWriteToLog('CompressionAlgorithm='+IntToStr(integer(CompressionAlgorithm)));
aaWriteToLog('SizeToRead='+IntToStr(SizeToRead));
aaWriteToLog('OutSize='+IntToStr(OutSize));
aaWriteToLog('buf = [ ' +
             TStringFormat_MIME64.StrTo(PAnsiChar(BufferToRead), SizeToRead) +
             ' ]');
//s := TStringFormat_MIME64.StrTo(PAnsiChar(BufferToRead), SizeToRead);
//s := TStringFormat_MIME64.ToStr(PAnsiChar(s), Length(s));
//aaWriteToLog('buf2 = [ ' + s + ' ]');
{ENDIF}

       if (not ABSInternalDecompressBuffer(CompressionAlgorithm, BufferToRead, SizeToRead,
                                   OutBuf, OutSize)) then
         raise EABSException.Create(20189, ErrorATableFileDecompression, [ABSCompressionGetLastError]);
{$IFDEF DEBUG_TRACE_DISK_ENGINE}
aaWriteToLog('TABSInternalDBTransactedAccessFile.ReadFile Decompression Finish');
{$ENDIF}
       try
         Move(OutBuf^, Buffer, Count);
       finally
         FreeMem(OutBuf);
         MemoryManager.FreeAndNillMem(BufferToRead);
       end;
     end;
  end;

end;//ReadFile


//------------------------------------------------------------------------------
// Write File Data
//------------------------------------------------------------------------------
procedure TABSInternalDBTransactedAccessFile.WriteFile(SessionID: TABSSessionID;
                        const Buffer; const Count: Integer;
                        const Algorithm: TABSCompressionAlgorithm = acaNone;
                        const CompressionMode: Integer = 0);
var
  Page: TABSPage;
  PageNo: TABSPageNo;
  BufferOffset: Integer;
  PageOffset:   Integer;
  NumBytes:     Integer;
  PageCount:    Integer;
  i: Integer;
  BufferToWrite: TAbsPByte;
  SizeToWrite:   Integer;
begin
  CheckFileOpened('WriteFile');

  if (Algorithm = acaNone) then
    begin
      BufferToWrite := TAbsPByte(@Buffer);
      SizeToWrite := Count;
    end
  else
    begin
      if (not ABSInternalCompressBuffer(Algorithm, CompressionMode,
                                        TAbsPByte(@Buffer), Count,
                                        BufferToWrite, SizeToWrite)) then
        raise EABSException.Create(20187, ErrorATableFileCompression);
    end;

  try
  // Set New File Size
    SetFileSize(SessionID, SizeToWrite, Count, Algorithm);
    PageCount := GetPageCountForDataSize(SizeToWrite);

  PageOffset := SizeOf(TABSInternalFileHeader);
  PageNo := FStartPageNo;
  BufferOffset := 0;

  for i:=1 to PageCount do
   begin
     Page := LPageManager.GetPage(SessionID, PageNo, FPageTypeID);
     try
       NumBytes := Page.PageDataSize - PageOffset;
         if (BufferOffset + NumBytes > SizeToWrite) then
           NumBytes := SizeToWrite - BufferOffset;

         Move(TAbsPByte(BufferToWrite + BufferOffset)^,
              TAbsPByte(Page.PageData + PageOffset)^, NumBytes);
       Page.IsDirty := True;

       BufferOffset := BufferOffset + NumBytes;
       PageOffset := 0;
       PageNo := Page.PageHeader.NextPageNo;
     finally
       LPageManager.PutPage(Page);
     end;
   end;//for
  finally
    if (Algorithm <> acaNone) then
      FreeMem(BufferToWrite);
  end;
end;//WriteFile


//------------------------------------------------------------------------------
// LockFile (Lock byte in 1-st page header
//------------------------------------------------------------------------------
function TABSInternalDBTransactedAccessFile.LockFile: Boolean;
begin
  CheckFileOpened('LockFile');
  Result := LPageManager.LockPageByte(FStartPageNo, 0);
end;//LockFile


//------------------------------------------------------------------------------
// UnockFile
//------------------------------------------------------------------------------
function TABSInternalDBTransactedAccessFile.UnlockFile: Boolean;
begin
  CheckFileOpened('UnlockFile');
  Result := LPageManager.UnlockPageByte(FStartPageNo, 0);
end;//UnlockFile




////////////////////////////////////////////////////////////////////////////////
//
// TABSInternalDBDirectAccessFile
//
////////////////////////////////////////////////////////////////////////////////



//------------------------------------------------------------------------------
// SetStartPageNo
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.SetStartPageNo(StartPageNo: TABSPageNo);
begin
  if (StartPageNo <> INVALID_PAGE_NO) then
    FStartPageNo := StartPageNo;
end;//SetStartPageNo


//------------------------------------------------------------------------------
// read page header
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.ReadPageHeader(PageNo: TABSPageNo;
                                             var PageHeader: TABSDiskPageHeader;
                                             SkipFirstByte: Boolean = False);
var
  Offset: Integer;
begin
  if (SkipFirstByte) then
    Offset := 1
  else
    Offset := 0;
  LPageManager.ReadPageRegion((TAbsPByte(@PageHeader)+Offset)^, PageNo, Offset,
                              sizeof(TABSDiskPageHeader)-Offset);
  if (PageHeader.PageType <> FPageTypeID) then
    raise EABSException.Create(20155, ErrorGInvalidPageType,
                               [PageHeader.PageType, FPageTypeID]);
end;//ReadPageHeader


//------------------------------------------------------------------------------
// raise if file is Closed
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.CheckFileOpened(OperationName: AnsiString);
begin
  if (FStartPageNo = INVALID_PAGE_NO) then
    raise EABSException.Create(20156, ErrorGIFClosed, [OperationName]);
end;//CheckFileOpened


//------------------------------------------------------------------------------
// return Count of File Pages for Size
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.GetPageCountForDataSize(DataSize: Integer): Integer;
var Offset: word;
begin
  GetPageNoAndOffsetForPosition(DataSize, Result, Offset);
  Inc(Result);
end;//GetPageCountForDataSize


//------------------------------------------------------------------------------
// return PagePosition and Offset in page
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.GetPageNoAndOffsetForPosition(
                Position: Integer; var PagePosition: Integer; var Offset: word);
begin
  Offset := (Position + SizeOf(TABSInternalFileHeader) ) mod LPageManager.PageDataSize;
  PagePosition := Ceil( (Position + SizeOf(TABSInternalFileHeader)) / LPageManager.PageDataSize) - 1;
end;//GetPageOffsetForPosition


//------------------------------------------------------------------------------
// ReadPageList
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.ReadPageList;
var
  PageHeader: TABSDiskPageHeader;
  i, PageNo:    Integer;
  Offset: Word;
  PageCount: Integer;
begin
  FFileSize := GetSize;
  GetPageNoAndOffsetForPosition(FFileSize-1, PageCount, Offset);
  Inc(PageCount);

  FFilePages.SetSize(0);
  PageNo := FStartPageNo;
  for i := 0 to PageCount-1 do
    begin
      ReadPageHeader(PageNo, PageHeader, True);
      FFilePages.Append(PageNo);
      PageNo := PageHeader.NextPageNo;
      if (PageNo < 0) and (i = 0) then
        begin
          FFileSize := LPageManager.PageDataSize - SizeOf(TABSInternalFileHeader);
          break;
        end;
    end;
end;// ReadPageList


//------------------------------------------------------------------------------
// return real page No for file page (firstPageNo=0)
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.GoToPage(PagePosition: TABSPageNo): TABSPageNo;
begin
  Result := FFilePages.Items[PagePosition];
end;//GoToPage


//------------------------------------------------------------------------------
// return PageNo and PageOffset by FileOffset
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.InternalSeek(FileOffset: Integer;
                                  out PageNo: TABSPageNo; out PageOffset: Word);
var
  Size: Integer;
  PagePos: Integer;
begin
//  Size := GetSize;
  Size := FFileSize;

  if (FileOffset > Size) then
    raise EABSException.Create(20159, ErrorGIFCannotSeekAfterEOF, [Size, FileOffset]);

  GetPageNoAndOffsetForPosition(FileOffset, PagePos, PageOffset);
  PageNo := GoToPage(PagePos);
  PageOffset := PageOffset + LPageManager.PageHeaderSize;
end;//InternalSeek


//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
constructor TABSInternalDBDirectAccessFile.Create(PageManager: TABSDiskPageManager; PageTypeID: TABSPageTypeID);
begin
  LPageManager := PageManager;
  FPageTypeID := PageTypeID;
  FStartPageNo := INVALID_PAGE_NO;
  FFileSize := 0;
  FFilePages := TABSIntegerArray.Create;
end;//Create


//------------------------------------------------------------------------------
// Destructor
//------------------------------------------------------------------------------
destructor TABSInternalDBDirectAccessFile.Destroy;
begin
  FFilePages.Free;
end;//Destroy


//------------------------------------------------------------------------------
// Create file
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.CreateFile(Size: Integer);
var
  FirstPage, Page, NewPage: TABSPage;
  PageNo: TABSPageNo;
  NewPageCount: Integer;
  i: Integer;
begin
  // Check File created
  if (FStartPageNo <> INVALID_PAGE_NO) then
    raise EABSException.Create(20157, ErrorGIFCannotRecreateFile, [FStartPageNo]);

  FirstPage := LPageManager.AddPage(SYSTEM_SESSION_ID, FPageTypeID);
  try
    FStartPageNo := FirstPage.PageNo;
    // Init File Header
    PABSInternalFileHeader(FirstPage.PageData).FileHeaderSize := sizeof(TABSInternalFileHeader);
    PABSInternalFileHeader(FirstPage.PageData).FileSize := Size;
    FirstPage.IsDirty := True;
    FirstPage.EncryptionEnabled := False;

    //--- add and link new pages
    NewPageCount := GetPageCountForDataSize(Size);
    // go to Last Page
    PageNo := FStartPageNo;
    // get last page
    Page := LPageManager.GetPage(SYSTEM_SESSION_ID, PageNo, FPageTypeID);
    try
      // add Pages
      for i:=1 to NewPageCount-1 do
      begin
        NewPage := LPageManager.AddPage(SYSTEM_SESSION_ID, FPageTypeID);
        NewPage.EncryptionEnabled := False;
        // store link
        Page.PageHeader.NextPageNo := NewPage.PageNo;
        Page.IsDirty := True;
        LPageManager.PutPage(Page);
        Page := NewPage;
      end;
      FFileSize := Size;
    finally
      // Put Last Page
      LPageManager.PutPage(Page);
    end;
  finally
    LPageManager.PutPage(FirstPage);
  end;
end;//CreateFile


//------------------------------------------------------------------------------
// Delete file. And free all file pages
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.DeleteFile(StartPageNo: TABSPageNo);
var
  PageHeader: TABSDiskPageHeader;
  PageNo, NextPageNo: TABSPageNo;
begin
  if (StartPageNo <> INVALID_PAGE_NO) then
    SetStartPageNo(StartPageNo);

  PageNo := FStartPageNo;
  repeat
    ReadPageHeader(PageNo, PageHeader);
    NextPageNo := PageHeader.NextPageNo;
    LPageManager.RemovePage(SYSTEM_SESSION_ID, PageNo);
    PageNo := NextPageNo;
  until (PageNo = INVALID_PAGE_NO);

  FStartPageNo := INVALID_PAGE_NO;
end;//DeleteFile


//------------------------------------------------------------------------------
// Open file (reading file header)
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.OpenFile(StartPageNo: TABSPageNo);
begin
  SetStartPageNo(StartPageNo);
  ReadPageList;
end;//OpenFile


//------------------------------------------------------------------------------
// Get File Size
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.GetSize: Integer;
var
  FileHeader: TABSInternalFileHeader;
begin
  CheckFileOpened('GetSize');
  LPageManager.ReadPageRegion(TAbsPByte(@FileHeader)^, FStartPageNo,
                   sizeof(TABSDiskPageHeader), sizeof(TABSInternalFileHeader));
  Result := FileHeader.FileSize;
end;//GetSize



//------------------------------------------------------------------------------
// direct (without sessions and transactions) Read buffer from file without
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.ReadBuffer(var Buffer; const Count: Integer;
                                                    const Position: Integer);
var
  PageHeader: TABSDiskPageHeader;
  PageNo: TABSPageNo;
  BufferOffset: Integer;
  PageOffset:   Word;
  NumBytes:     Integer;

begin
  CheckFileOpened('DirectReadBuffer');
  BufferOffset := 0;
  // First Page No
  InternalSeek(Position, PageNo, PageOffset);

  repeat
    ReadPageHeader(PageNo, PageHeader);
    NumBytes := LPageManager.PageSize - PageOffset;
    if (BufferOffset + NumBytes > Count) then
      NumBytes := Count - BufferOffset;
    LPageManager.ReadPageRegion(TAbsPByte(TAbsPByte(@Buffer) + BufferOffset)^, PageNo, PageOffset, NumBytes);
    BufferOffset := BufferOffset + NumBytes;
    // Next PageNo
    PageNo := PageHeader.NextPageNo;
    PageOffset := LPageManager.PageHeaderSize;
  until ( (PageNo = INVALID_PAGE_NO) or (BufferOffset >= Count) );
end;//ReadBuffer


//------------------------------------------------------------------------------
// direct (without sessions and transactions) Write buffer from file
//------------------------------------------------------------------------------
procedure TABSInternalDBDirectAccessFile.WriteBuffer(const Buffer;
                                  const Count: Integer; const Position: Integer);
var
  PageHeader: TABSDiskPageHeader;
  Size: Integer;
  BufferOffset: Integer;
  PageOffset: word;
  PageNo: TABSPageNo;
  NumBytes:     Integer;
begin
  CheckFileOpened('DirectWriteBuffer');
  // Check bounds
  Size := GetSize;
  if (Position + Count > Size) then
    raise EABSException.Create(20158, ErrorGIFCannotWriteAfterEOF, [Size, Position, Count]);
  BufferOffset := 0;
  // go to First page
  InternalSeek(Position, PageNo, PageOffset);

  repeat
    ReadPageHeader(PageNo, PageHeader);
    NumBytes := LPageManager.PageSize - PageOffset;
    if (BufferOffset + NumBytes > Count) then
      NumBytes := Count - BufferOffset;
    LPageManager.WritePageRegion(TAbsPByte(TAbsPByte(@Buffer) + BufferOffset)^, PageNo, PageOffset, NumBytes);
    BufferOffset := BufferOffset + NumBytes;
    // Next PageNo
    PageNo := PageHeader.NextPageNo;
    PageOffset := LPageManager.PageHeaderSize;
  until (BufferOffset >= Count) ;
end;//WriteBuffer


//------------------------------------------------------------------------------
// LockFile (Lock byte in 1-st page header
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.LockFile: Boolean;
begin
  CheckFileOpened('LockFile');
  Result := LPageManager.LockPageByte(FStartPageNo, 0);
end;//LockFile


//------------------------------------------------------------------------------
// UnockFile
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.UnlockFile: Boolean;
begin
  CheckFileOpened('UnlockFile');
  Result := LPageManager.UnlockPageByte(FStartPageNo, 0);
end;//UnlockFile


//------------------------------------------------------------------------------
// LockByte
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.LockByte(ByteNo: Integer): Boolean;
var
  PagePos: Word;
  PageNo: TABSPageNo;
begin
  CheckFileOpened('LockByte');
  InternalSeek(ByteNo, PageNo, PagePos);
  Result := LPageManager.LockPageByte(PageNo, PagePos);
end;//LockByte


//------------------------------------------------------------------------------
// UnlockByte
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.UnlockByte(ByteNo: Integer): Boolean;
var
  PagePos: Word;
  PageNo: TABSPageNo;
begin
  CheckFileOpened('UnlockByte');
  InternalSeek(ByteNo, PageNo, PagePos);
  Result := LPageManager.UnlockPageByte(PageNo, PagePos);
end;//UnlockByte


//------------------------------------------------------------------------------
// IsByteLocked
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.IsByteLocked(ByteNo: Integer): Boolean;
var
  PagePos: Word;
  PageNo: TABSPageNo;
begin
  CheckFileOpened('IsByteLocked');
  InternalSeek(ByteNo, PageNo, PagePos);
  Result := LPageManager.IsPageByteLocked(PageNo, PagePos);
end;//IsByteLocked


//------------------------------------------------------------------------------
// IsRegionLocked
//------------------------------------------------------------------------------
function TABSInternalDBDirectAccessFile.IsRegionLocked(ByteNo, ByteCount: Integer): Boolean;
var
  PageNo1, PageNo2, PageNo: TABSPageNo;
  Offset1, Offset2, Offset, PageOffset: Word;
  Count: Word;
  PagePos: Integer;
begin
  CheckFileOpened('IsRegionLocked');
  Result := False;
  if (ByteCount > 0) then
    begin
      InternalSeek(ByteNo, PageNo1, Offset1);
      InternalSeek(ByteNo+ByteCount-1, PageNo2, Offset2);

      if (PageNo1 = PageNo2) then
        Result := LPageManager.IsPageRegionLocked(PageNo1, Offset1, ByteCount)
      else
        begin
          GetPageNoAndOffsetForPosition(ByteNo, PagePos, PageOffset);
          Offset := Offset1;
          repeat
            PageNo := GoToPage(PagePos);
            if (PageNo <> PageNo2) then
              Count := LPageManager.PageSize - Offset
            else
              Count := Offset2 - Offset;
            if (LPageManager.IsPageRegionLocked(PageNo, Offset, Count)) then
              begin
                Result := True;
                break;
              end;
            Inc(PagePos);
            Offset := LPageManager.PageHeaderSize;
          until (PageNo = PageNo2);
        end;
    end;
end;//IsRegionLocked


////////////////////////////////////////////////////////////////////////////////
//
// TABSActiveSessionsFile
//
////////////////////////////////////////////////////////////////////////////////

function TABSActiveSessionsFile.GetStartPageNo: TABSPageNo;
begin
  Result := FHandle.StartPageNo;
end;// GetStartPageNo


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSActiveSessionsFile.Create(PageManager: TABSPageManager);
begin
  LPageManager := TABSDiskPageManager(PageManager);
  FHandle := nil;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSActiveSessionsFile.Destroy;
begin
  CloseFile;
  inherited;
end;// Destroy


//------------------------------------------------------------------------------
// CreateFile
//------------------------------------------------------------------------------
function TABSActiveSessionsFile.CreateFile(aMaxSessionCount: Integer): TABSPageNo;
begin
  FMaxSessionCount := aMaxSessionCount;
  FHandle := TABSInternalDBDirectAccessFile.Create(LPageManager, ptActiveSessionList);
  FHandle.CreateFile(FMaxSessionCount);
  Result := FHandle.StartPageNo;
  CloseFile;
end;// CreateFile


//------------------------------------------------------------------------------
// OpenFile
//------------------------------------------------------------------------------
procedure TABSActiveSessionsFile.OpenFile(aStartPageNo: TABSPageNo);
begin
  FHandle := TABSInternalDBDirectAccessFile.Create(LPageManager, ptActiveSessionList);
  FHandle.OpenFile(aStartPageNo);
  FMaxSessionCount := FHandle.GetSize;
  if (FHandle.FFileSize < FMaxSessionCount) then
    FMaxSessionCount := FHandle.FFileSize;
end;// OpenFile


//------------------------------------------------------------------------------
// CloseFile
//------------------------------------------------------------------------------
procedure TABSActiveSessionsFile.CloseFile;
begin
  if (FHandle <> nil) then
    FreeAndNil(FHandle);
end;// CloseFile


//------------------------------------------------------------------------------
// MultiUserConnect
//------------------------------------------------------------------------------
function TABSActiveSessionsFile.MultiUserConnect: TABSSessionID;
{$IFDEF FILE_SERVER_VERSION}
var
  i: Integer;
{$ENDIF}
begin
{$IFDEF FILE_SERVER_VERSION}
  if (LPageManager.MultiUser) then
    begin
      TryUsingTimeOut(FHandle.LockFile, ConnectSessionLockRetries, ConnectSessionLockDelay);
      try
        Result := INVALID_SESSION_ID;
        for i := 0 to FHandle.GetSize-1 do
          if (FHandle.LockByte(i)) then
            begin
              Result := i;
              break;
            end;
        if (Result = INVALID_SESSION_ID) then
         raise EABSException.Create(20094, ErrorACannotConnectSession);
      finally
        if (not FHandle.UnlockFile) then
          raise EABSException.Create(20093, ErrorACannotUnlockSessionsFile);
      end;
    end
  else
{$ENDIF}
    Result := 0;
end;// MultiUserConnect


//------------------------------------------------------------------------------
// MultiUserDisconnect
//------------------------------------------------------------------------------
procedure TABSActiveSessionsFile.MultiUserDisconnect(SessionID: TABSSessionID);
begin
{$IFDEF FILE_SERVER_VERSION}
  if (LPageManager.MultiUser) then
    begin
      TryUsingTimeOut(FHandle.LockFile, DisconnectSessionLockRetries, DisconnectSessionLockDelay);
      try
         if (not FHandle.UnlockByte(SessionID)) then
          raise EABSException.Create(20095, ErrorACannotDisconnectSession);
      finally
        if (not FHandle.UnlockFile) then
          raise EABSException.Create(20096, ErrorACannotUnlockSessionsFile);
      end;
    end;
{$ENDIF}
end;// MultiUserDisconnect


//------------------------------------------------------------------------------
//  connect and lock all session bytes
//------------------------------------------------------------------------------
function TABSActiveSessionsFile.SingleUserConnect: Boolean;
var
  i: Integer;
begin
    begin
      TryUsingTimeOut(FHandle.LockFile, ConnectSessionLockRetries, ConnectSessionLockDelay);
      try
        if (FHandle.IsRegionLocked(0, FHandle.GetSize)) then
          Result := False
        else
          begin
            for i := 0 to FHandle.GetSize-1 do
              FHandle.LockByte(i);
            Result := True;
          end;
      finally
        if (not FHandle.UnlockFile) then
          raise EABSException.Create(20240, ErrorACannotUnlockSessionsFile);
      end;
    end
end;// SingleUserConnect


//------------------------------------------------------------------------------
//  disconnect and unlock all session bytes
//------------------------------------------------------------------------------
procedure TABSActiveSessionsFile.SingleUserDisconnect;
var
  i: Integer;
begin
    begin
      TryUsingTimeOut(FHandle.LockFile, ConnectSessionLockRetries, ConnectSessionLockDelay);
      try
        for i := 0 to FHandle.GetSize-1 do
          FHandle.UnlockByte(i);
      finally
        if (not FHandle.UnlockFile) then
          raise EABSException.Create(20241, ErrorACannotUnlockSessionsFile);
      end;
    end
end;// SingleUserDisconnect


//------------------------------------------------------------------------------
//  GetDBFileConnectionsCount
//------------------------------------------------------------------------------
function TABSActiveSessionsFile.GetDBFileConnectionsCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  TryUsingTimeOut(FHandle.LockFile, ConnectSessionLockRetries, ConnectSessionLockDelay);
  try
    for i := 0 to FHandle.GetSize-1 do
      if (FHandle.IsByteLocked(i)) then
        Inc(Result);
  finally
    if (not FHandle.UnlockFile) then
      raise EABSException.Create(30484, ErrorACannotUnlockSessionsFile);
  end;
end;//GetDBFileConnectionsCount




////////////////////////////////////////////////////////////////////////////////
//
// TABSTableListFile
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// GetStartPageNo
//------------------------------------------------------------------------------
function TABSTableListFile.GetStartPageNo: TABSPageNo;
begin
  Result := FHandle.StartPageNo;
end;// GetStartPageNo


//------------------------------------------------------------------------------
// GetTableIndex
//------------------------------------------------------------------------------
function TABSTableListFile.GetTableIndex(TableName: AnsiString): Integer;
var i: Integer;
begin
  Result := -1;
  for i:=0 to Length(FTableList)-1 do
   if UpperCase(FTableList[i].TableName) = UpperCase(TableName) then
    begin
     Result := i;
     Break;
end;
end;//GetTableIndex


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSTableListFile.Create(PageManager: TABSPageManager);
begin
  LPageManager := TABSDiskPageManager(PageManager);
  FHandle := nil;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSTableListFile.Destroy;
begin
  CloseFile;
  inherited;
end;// Destroy


//------------------------------------------------------------------------------
// CreateFile
//------------------------------------------------------------------------------
function TABSTableListFile.CreateFile: TABSPageNo;
begin
  FHandle := TABSInternalDBTransactedAccessFile.Create(LPageManager, ptTableList);
  FHandle.CreateFile(SYSTEM_SESSION_ID);
  Result := FHandle.StartPageNo;
  CloseFile;
end;// CreateFile


//------------------------------------------------------------------------------
// OpenFile
//------------------------------------------------------------------------------
procedure TABSTableListFile.OpenFile(aStartPageNo: TABSPageNo);
begin
  if (FHandle <> nil) then
    EABSException.Create(30393, ErrorGTableListFileAlreadyOpened);
  FHandle := TABSInternalDBTransactedAccessFile.Create(LPageManager, ptTableList);
  FHandle.OpenFile(aStartPageNo);
end;// OpenFile


//------------------------------------------------------------------------------
// CloseFile
//------------------------------------------------------------------------------
procedure TABSTableListFile.CloseFile;
begin
  if (FHandle <> nil) then
   FreeAndNil(FHandle);
end;// CloseFile


//------------------------------------------------------------------------------
// Load Table List
//------------------------------------------------------------------------------
procedure TABSTableListFile.Load;
var
  FileSize: Integer;
begin
  FileSize := FHandle.GetSize(SYSTEM_SESSION_ID);
  SetLength(FTableList, FileSize div SizeOf(TABSTableListItem));
  FHandle.ReadFile(SYSTEM_SESSION_ID, FTableList[0], FileSize);
end;//Load


//------------------------------------------------------------------------------
// Save Table List
//------------------------------------------------------------------------------
procedure TABSTableListFile.Save;
begin
  FHandle.WriteFile(SYSTEM_SESSION_ID, FTableList[0],
                    Length(FTableList) * SizeOf(TABSTableListItem));
end;//Save


//------------------------------------------------------------------------------
// AddTable
//------------------------------------------------------------------------------
procedure TABSTableListFile.AddTable(TableID: TABSTableID;
  TableName: AnsiString; MetadataFilePageNo, MostUpdatedFilePageNo,
  LocksFilePageNo: TABSPageNo);
var
  OldLen: Integer;
begin
  if TableExists(TableName) then
    raise EABSException.Create(30395, ErrorGTableAlreadyExists, [TableName]);
  OldLen := Length(FTableList);
  SetLength(FTableList,OldLen+1);
  FTableList[OldLen].TableName := TableName;
  FTableList[OldLen].TableID := TableID;
  FTableList[OldLen].MetaDataFilePageNo := MetaDataFilePageNo;
  FTableList[OldLen].MostUpdatedFilePageNo := MostUpdatedFilePageNo;
  FTableList[OldLen].LocksFilePageNo := LocksFilePageNo;
end;//AddTable


//------------------------------------------------------------------------------
// OpenTable
//------------------------------------------------------------------------------
procedure TABSTableListFile.OpenTable(TableName: AnsiString;
  out TableID: TABSTableID; out MetadataFilePageNo, MostUpdatedFilePageNo,
  LocksFilePageNo: TABSPageNo);
var n: Integer;
begin
  n := GetTableIndex(TableName);
  if n = -1 then
    raise EABSException.Create(30396, ErrorGTableNotExists, [TableName]);

  TableID := FTableList[n].TableID;
  MetadataFilePageNo := FTableList[n].MetaDataFilePageNo;
  MostUpdatedFilePageNo := FTableList[n].MostUpdatedFilePageNo;
  LocksFilePageNo := FTableList[n].LocksFilePageNo;
end;//OpenTable


//------------------------------------------------------------------------------
// RemoveTable
//------------------------------------------------------------------------------
procedure TABSTableListFile.RemoveTable(TableName: AnsiString);
var n,i: Integer;
begin
  n := GetTableIndex(TableName);
  if n = -1 then
    raise EABSException.Create(30405, ErrorGTableNotExists, [TableName]);

  for i:=n to Length(FTableList)-2 do
    FTableList[i] := FTableList[i+1];

  SetLength(FTableList, Length(FTableList)-1);
end;//RemoveTable


//------------------------------------------------------------------------------
// RenameTable
//------------------------------------------------------------------------------
procedure TABSTableListFile.RenameTable(TableName, NewTableName: AnsiString);
var n: Integer;
begin
  n := GetTableIndex(TableName);
  if n = -1 then
    raise EABSException.Create(30397, ErrorGTableNotExists, [TableName]);
  FTableList[n].TableName := NewTableName;
end;//RenameTable


//------------------------------------------------------------------------------
// TableExists
//------------------------------------------------------------------------------
function TABSTableListFile.TableExists(TableName: AnsiString): Boolean;
begin
  Result := not (GetTableIndex(TableName) = -1);
end;//TableExists


//------------------------------------------------------------------------------
// GetTablesList
//------------------------------------------------------------------------------
procedure TABSTableListFile.GetTablesList(List: TStrings);
var
  i: Integer;
begin
  Load;
  List.Clear;
  for i:=0 to Length(FTableList)-1 do
   List.Add(FTableList[i].TableName);
end;// GetTablesList



////////////////////////////////////////////////////////////////////////////////
//
// TABSTableLocksFile
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// return number of start page
//------------------------------------------------------------------------------
function TABSTableLocksFile.GetStartPageNo: TABSPageNo;
begin
  if (FHandle = nil) then
   raise EABSException.Create(10483,ErrorLNilPointer);
  Result := FHandle.StartPageNo;
end;// GetStartPageNo


//------------------------------------------------------------------------------
// return number of byte for lock / unlock /is locked operations
//------------------------------------------------------------------------------
function TABSTableLocksFile.GetTableLockByteNo(
                    SessionID: TABSSessionID; LockType: TABSLockType): Integer;
begin
  Result := SessionID + Integer(LockType) * FMaxSessionCount;
end;// GetTableLockByteNo


//------------------------------------------------------------------------------
// GetRecordLockByteNo
//------------------------------------------------------------------------------
function TABSTableLocksFile.GetRecordLockByteNo(SessionID: TABSSessionID): Integer;
begin
  Result := SessionID + Integer(ltU) * FMaxSessionCount;
end;// GetRecordLockByteNo


//------------------------------------------------------------------------------
// GetRecordLockRecordIDByteNo
//------------------------------------------------------------------------------
function TABSTableLocksFile.GetRecordLockRecordIDByteNo(SessionID: TABSSessionID): Integer;
begin
  Result := SessionID * sizeof(TABSRecordID) + ABSMaxLockTypes * FMaxSessionCount;
end;// GetRecordLockRecordIDByteNo


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSTableLocksFile.Create(PageManager:  TABSPageManager);
begin
  LPageManager := TABSDiskPageManager(PageManager);
  FHandle := nil;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSTableLocksFile.Destroy;
begin
  CloseFile;
  inherited;
end;// Destroy


//------------------------------------------------------------------------------
// CreateFile
//------------------------------------------------------------------------------
function TABSTableLocksFile.CreateFile(aMaxSessionCount: Integer): TABSPageNo;
begin
  FMaxSessionCount := aMaxSessionCount;
  FHandle := TABSInternalDBDirectAccessFile.Create(LPageManager, ptTableLocksFile);
  FHandle.CreateFile(FMaxSessionCount * (ABSMaxLockTypes + SizeOf(TABSRecordID)));
  Result := FHandle.StartPageNo;
end;// CreateFile


//------------------------------------------------------------------------------
// DeleteFile
//------------------------------------------------------------------------------
procedure TABSTableLocksFile.DeleteFile;
begin
  FHandle.DeleteFile;
end;// DeleteFile


//------------------------------------------------------------------------------
// OpenFile
//------------------------------------------------------------------------------
procedure TABSTableLocksFile.OpenFile(aStartPageNo: TABSPageNo);
begin
  FHandle := TABSInternalDBDirectAccessFile.Create(LPageManager, ptTableLocksFile);
  FHandle.OpenFile(aStartPageNo);
  FMaxSessionCount := FHandle.GetSize div (ABSMaxLockTypes + SizeOf(TABSRecordID));
end;// OpenFile


//------------------------------------------------------------------------------
// CloseFile
//------------------------------------------------------------------------------
procedure TABSTableLocksFile.CloseFile;
begin
  if (FHandle <> nil) then
   begin
    FHandle.Free;
    FHandle := nil;
   end;
end;// CloseFile


//------------------------------------------------------------------------------
// Lock Table
//------------------------------------------------------------------------------
function TABSTableLocksFile.LockTable(SessionID: TABSSessionID; LockType: TABSLockType): Boolean;
begin
  if (FHandle = nil) then
    raise EABSException.Create(10489,ErrorLNilPointer);
  if (SessionID >= FMaxSessionCount) then
    raise EABSException.Create(20200, ErrorACannotSetTableLock);
  if (LockType <> ltX) then
    Result := FHandle.LockByte(GetTableLockByteNo(SessionID,LockType))
  else
    Result := False;
end; // LockTable


//------------------------------------------------------------------------------
// Unlock Table
//------------------------------------------------------------------------------
function TABSTableLocksFile.UnlockTable(SessionID: TABSSessionID; LockType: TABSLockType): Boolean;
begin
  if (FHandle = nil) then
   raise EABSException.Create(10494,ErrorLNilPointer);
  if (LockType <> ltX) then
    Result := FHandle.UnlockByte(GetTableLockByteNo(SessionID,LockType))
  else
    Result := False;
end; // UnlockTable


//------------------------------------------------------------------------------
// Is Table Locked By Any Other Session
//------------------------------------------------------------------------------
function TABSTableLocksFile.IsTableLockedByAnyOtherSession(
                     SessionID: TABSSessionID; LockType: TABSLockType): Boolean;
begin
  if (FHandle = nil) then
   raise EABSException.Create(10490, ErrorLNilPointer);
  Result := False;
  if (LockType <> ltX) then
    Result := FHandle.IsRegionLocked(GetTableLockByteNo(0,LockType), SessionID) or
              FHandle.IsRegionLocked(GetTableLockByteNo(SessionID+1,LockType),
                                     FMaxSessionCount - SessionID - 1);
end;// IsTableLockedByAnyOtherSession


//------------------------------------------------------------------------------
// IsTableLockAllowed
//------------------------------------------------------------------------------
function TABSTableLocksFile.IsTableLockAllowed(SessionID: TABSSessionID;
                                LockType: TABSLockType;
                                AllowXIRWAfterSIRW: Boolean = True): Boolean;
var
  i: TABSLockType;
begin
  Result := True;
  for i:= ltIS to ltX do
    if (not LocksCompatible[i, LockType]) then
      // XIRW allowed after existsing SIRW?
      if (not AllowXIRWAfterSIRW) or
         ((LockType <> ltXIRW) or (i <> ltSIRW)) then
        if (IsTableLockedByAnyOtherSession(SessionID, i)) then
          begin
            Result := False;
            break;
          end;
end;// IsTableLockAllowed


//------------------------------------------------------------------------------
// Lock Record
//------------------------------------------------------------------------------
function TABSTableLocksFile.LockRecord(
                    SessionID:  TABSSessionID;
                    RecordID:   TABSRecordID
                   ): Boolean;
begin
  if (FHandle = nil) then
   raise EABSException.Create(10491,ErrorLNilPointer);
  Result := FHandle.LockByte(GetRecordLockByteNo(SessionID));
  if (Result) then
    FHandle.WriteBuffer(RecordID, SizeOf(RecordID), GetRecordLockRecordIDByteNo(SessionID));
end; // LockRecord


//------------------------------------------------------------------------------
// Unlock Record
//------------------------------------------------------------------------------
function TABSTableLocksFile.UnlockRecord(
                      SessionID:  TABSSessionID;
                      RecordID:   TABSRecordID
                     ): Boolean;
begin
  if (FHandle = nil) then
   raise EABSException.Create(10492,ErrorLNilPointer);
  Result := FHandle.UnlockByte(GetRecordLockByteNo(SessionID));
end; // UnlockRecord


//------------------------------------------------------------------------------
// Is Record Locked By Any Other Session
//------------------------------------------------------------------------------
function TABSTableLocksFile.IsRecordLockedByAnyOtherSession(
                      SessionID:  TABSSessionID;
                      RecordID:   TABSRecordID
                     ): Boolean;
var
  i: Integer;
  LockedRecordID: TABSRecordID;
begin
  if (FHandle = nil) then
   raise EABSException.Create(10493, ErrorLNilPointer);
  Result := FHandle.IsRegionLocked(GetRecordLockByteNo(0), SessionID) or
            FHandle.IsRegionLocked(GetRecordLockByteNo(SessionID+1),
                                     FMaxSessionCount - SessionID - 1);
  if (Result) then
    begin
      Result := False;
      for i := 0 to FMaxSessionCount-1 do
       if (i <> SessionID) then
         if (FHandle.IsByteLocked(GetRecordLockByteNo(i))) then
           begin
             FHandle.ReadBuffer(LockedRecordID, SizeOf(LockedRecordID),
                                GetRecordLockRecordIDByteNo(i));
             Result := (LockedRecordID.PageNo = RecordID.PageNo) and
                       (LockedRecordID.PageItemNo = RecordID.PageItemNo);
             if (Result) then
               break;
           end;
    end;
end;// IsRecordLockedByAnyOtherSession


//------------------------------------------------------------------------------
// LockFile
//------------------------------------------------------------------------------
function TABSTableLocksFile.LockFile: Boolean;
begin
  Result := FHandle.LockFile;
end;// LockFile


//------------------------------------------------------------------------------
// UnlockFile
//------------------------------------------------------------------------------
function TABSTableLocksFile.UnlockFile: Boolean;
begin
  Result := FHandle.UnlockFile;
end;// UnlockFile



////////////////////////////////////////////////////////////////////////////////
//
// TABSSystemDirectory
//
////////////////////////////////////////////////////////////////////////////////



//------------------------------------------------------------------------------
// Constructor
//------------------------------------------------------------------------------
constructor TABSSystemDirectory.Create(PageManager: TABSDiskPageManager);
begin
  LPageManager := PageManager;
  FHandle := TABSInternalDBTransactedAccessFile.Create(LPageManager, ptFileSystemDirectory);
end;//Create


//------------------------------------------------------------------------------
// Destructor
//------------------------------------------------------------------------------
destructor TABSSystemDirectory.Destroy;
begin
  FreeAndNil(FHandle);
  inherited;
end;//Destroy


//------------------------------------------------------------------------------
// Create SystemDirectory
//------------------------------------------------------------------------------
procedure TABSSystemDirectory.CreateDirectory;
begin
  FHandle.CreateFile(SYSTEM_SESSION_ID);
  if (FHandle.StartPageNo <> ABSFirstPageNoSystemDirectory) then
    raise EABSException.Create(30392, ErrorGSystemDirInvalidFirstPageNo,
                               [FHandle.StartPageNo, ABSFirstPageNoSystemDirectory]);
end;//CreateDirectory


//------------------------------------------------------------------------------
// Load SystemDirectory
//------------------------------------------------------------------------------
procedure TABSSystemDirectory.LoadDirectory;
var
  size:   Integer;
  count:  Integer;
begin
  FHandle.OpenFile(ABSFirstPageNoSystemDirectory);
  size := FHandle.GetSize(SYSTEM_SESSION_ID);
  count := Size div SizeOf(TABSSystemDirectoryListItem);
  SetLength(FFileList, count);
  FHandle.ReadFile(SYSTEM_SESSION_ID, FFileList[0], size);
end;//LoadDirectory


//------------------------------------------------------------------------------
// Save SystemDirectory
//------------------------------------------------------------------------------
procedure TABSSystemDirectory.SaveDirectory;
begin
  FHandle.WriteFile(SYSTEM_SESSION_ID, FFileList[0],
                    Length(FFileList)*SizeOf(TABSSystemDirectoryListItem));
end;//SaveDirectory


//------------------------------------------------------------------------------
// CreateFile
//------------------------------------------------------------------------------
procedure TABSSystemDirectory.CreateFile(FileType: TABSDBFileType; FirstPageNo: TABSPageNo);
var
  count: Integer;
begin
  count := Length(FFileList);
  SetLength(FFileList, count+1);
  FFileList[count].FileID := FileType;
  FFileList[count].FirstPageNo := FirstPageNo;
end;//CreateFile


//------------------------------------------------------------------------------
// GetFileFirstPageNo
//------------------------------------------------------------------------------
function TABSSystemDirectory.GetFileFirstPageNo(FileType: TABSDBFileType): TABSPageNo;
var
  i: Integer;
begin
  Result := INVALID_PAGE_NO;
  for i:= 0 to Length(FFileList)-1 do
   if (FFileList[i].FileID = FileType) then
    begin
     Result := FFileList[i].FirstPageNo;
     break;
    end;
end;//GetFileFirstPageNo



////////////////////////////////////////////////////////////////////////////////
//
// TABSTableLockList
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// FindLock
//------------------------------------------------------------------------------
function TABSTableLockList.FindLock(LockType: TABSLockType; LocksFilePageNo: TABSPageNo;
                       var ItemNo: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FLockList.Count-1 do
    if ((PABSTableLock(FLockList.Items[i])^.LockType = LockType) and
        (PABSTableLock(FLockList.Items[i])^.LocksFilePageNo = LocksFilePageNo)) then
      begin
        Result := True;
        ItemNo := i;
        break;
      end;
end;// FindLock

function TABSTableLockList.FindLock(LockType: TABSLockType; LocksFilePageNo: TABSPageNo; IsXIRWAfterSIRWAllowed: Boolean;
                       var ItemNo: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FLockList.Count-1 do
    if ((PABSTableLock(FLockList.Items[i])^.LockType = LockType) and
        (PABSTableLock(FLockList.Items[i])^.LocksFilePageNo = LocksFilePageNo) and
        (PABSTableLock(FLockList.Items[i])^.IsXIRWAfterSIRWAllowed = IsXIRWAfterSIRWAllowed)) then
      begin
        Result := True;
        ItemNo := i;
        break;
      end;
end;// FindLock


//------------------------------------------------------------------------------
// is lock1 stronger than lock2
//------------------------------------------------------------------------------
function TABSTableLockList.IsLockStronger(LockType1, LockType2: TABSLockType): Boolean;
var
  i: TABSLockType;
begin
  Result := True;
  for i := ltIS to ltX do
    if (LocksCompatible[LockType1, i]) then
      if (not LocksCompatible[LockType2, i]) then
        begin
          Result := False;
          break;
        end;
end;// IsLockStronger


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSTableLockList.Create;
begin
  FLockList := TList.Create;
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSTableLockList.Destroy;
begin
  if (FLockList.Count > 0) then
    raise EABSException.Create(20201, ErrorATableIsStillLocked);
  FLockList.Free;
  inherited;
end;// Destroy


//------------------------------------------------------------------------------
// AddLock
//------------------------------------------------------------------------------
procedure TABSTableLockList.AddLock(LockType: TABSLockType; LocksFilePageNo: TABSPageNo; HasPhysicalLock: Boolean; IsXIRWAfterSIRWAllowed: Boolean = True);
var
  ItemNo: Integer;
  pLock: PABSTableLock;
begin
  if (FindLock(LockType, LocksFilePageNo, ItemNo)) then
    PABSTableLock(FLockList.Items[ItemNo])^.LockCount :=
                         PABSTableLock(FLockList.Items[ItemNo])^.LockCount + 1
  else
    begin
      New(pLock);
      pLock^.LockType := LockType;
      pLock^.LocksFilePageNo := LocksFilePageNo;
      pLock^.LockCount := 1;
      pLock^.HasPhysicalLock := HasPhysicalLock;
      pLock^.IsXIRWAfterSIRWAllowed := IsXIRWAfterSIRWAllowed;
      FLockList.Add(pLock);
    end;
end;// AddLock


//------------------------------------------------------------------------------
// RemoveLock
//------------------------------------------------------------------------------
procedure TABSTableLockList.RemoveLock(LockType: TABSLockType;
 LocksFilePageNo: TABSPageNo; var HasPhysicalLock: Boolean; IgnoreCount: Boolean);
var
  ItemNo: Integer;
  pLock: PABSTableLock;
begin
  if (FindLock(LockType, LocksFilePageNo, ItemNo)) then
    begin
      PABSTableLock(FLockList.Items[ItemNo])^.LockCount :=
                         PABSTableLock(FLockList.Items[ItemNo])^.LockCount - 1;
      if ((PABSTableLock(FLockList.Items[ItemNo])^.LockCount = 0) or
          (IgnoreCount)) then
        begin
          pLock := FLockList.Items[ItemNo];
          HasPhysicalLock := pLock^.HasPhysicalLock;
          FLockList.Remove(pLock);
          Dispose(pLock);
        end
      else
        HasPhysicalLock := False;
    end
  else
    raise EABSException.Create(20202, ErrorACannotRemoveLock);
end;// RemoveLock


//------------------------------------------------------------------------------
// LockExists
//------------------------------------------------------------------------------
function TABSTableLockList.LockExists(LockType: TABSLockType; LocksFilePageNo: TABSPageNo): Boolean;
var
  ItemNo: Integer;
begin
  Result := FindLock(LockType, LocksFilePageNo, ItemNo);
end;// LockExists

function TABSTableLockList.LockExists(LockType: TABSLockType;
                                      LocksFilePageNo: TABSPageNo;
                                      IsXIRWAfterSIRWAllowed: Boolean): Boolean;
var
  ItemNo: Integer;
begin
  Result := FindLock(LockType, LocksFilePageNo, IsXIRWAfterSIRWAllowed, ItemNo);
end;// LockExists


//------------------------------------------------------------------------------
// StrongerLockExists
//------------------------------------------------------------------------------
function TABSTableLockList.StrongerLockExists(LockType: TABSLockType; LocksFilePageNo: TABSPageNo): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FLockList.Count-1 do
    if ((PABSTableLock(FLockList.Items[i])^.LockType <> LockType) or
        (PABSTableLock(FLockList.Items[i])^.LocksFilePageNo <> LocksFilePageNo)) then
      if (IsLockStronger(PABSTableLock(FLockList.Items[i])^.LockType, LockType)) then
        begin
          Result := True;
          break;
        end;
end;// StrongerLockExists


//------------------------------------------------------------------------------
// SetPhysicalLock
//------------------------------------------------------------------------------
procedure TABSTableLockList.SetPhysicalLock(ItemNo: Integer);
begin
  PABSTableLock(FLockList.Items[ItemNo])^.HasPhysicalLock := True;
end;// SetPhysicalLock


//------------------------------------------------------------------------------
// IsWeakerNonPhysicalLock
//------------------------------------------------------------------------------
function TABSTableLockList.IsWeakerNonPhysicalLock(ItemNo: Integer; LockType: TABSLockType): Boolean;
begin
  Result := (IsLockStronger(LockType, PABSTableLock(FLockList.Items[ItemNo])^.LockType) and
             (not PABSTableLock(FLockList.Items[ItemNo])^.HasPhysicalLock));
end;// IsWeakerNonPhysicalLock



////////////////////////////////////////////////////////////////////////////////
//
// TABSDatabaseTableLockManager
//
////////////////////////////////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// Lock
//------------------------------------------------------------------------------
procedure TABSDatabaseTableLockManager.Lock;
begin
  EnterCriticalSection(FCSect);
end;// Lock


//------------------------------------------------------------------------------
// Unlock
//------------------------------------------------------------------------------
procedure TABSDatabaseTableLockManager.Unlock;
begin
  LeaveCriticalSection(FCSect);
end;// Unlock


//------------------------------------------------------------------------------
// AddSIRWLocksToULocks
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.AddSIRWLocksToULocks(SessionID: TABSSessionID): Boolean;
var
  i: Integer;
  LocksFile: TABSTableLocksFile;
  StartPageNo: TABSPageNo;
begin
  if (TABSTableLockList(FSessionLockList[SessionID]).FLockList.Count > 0) then
    begin
      LocksFile := TABSTableLocksFile.Create(LPageManager);
      try
        Result := True;
        // add SRW locks to U locks
        for i := 0 to TABSTableLockList(FSessionLockList[SessionID]).FLockList.Count-1 do
          if (PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LockType = ltU) then
            begin
              StartPageNo := PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LocksFilePageNo;
              if (not TABSTableLockList(FSessionLockList[SessionID]).LockExists(
                                  ltX, StartPageNo)) then
                begin
                  LocksFile.OpenFile(StartPageNo);
                  if (not TABSTableLockList(FSessionLockList[SessionID]).LockExists(ltSIRW, StartPageNo)) then
                    Result := LockTable(SessionID, ltSIRW, LocksFile,
                             CommitTablesLockRetries, CommitTablesLockDelay, True);
                  LocksFile.CloseFile;
                  if (not Result) then
                    break;
                end
              else
                begin
                  Result := LockTable(SessionID, ltSIRW, LocksFile,
                             CommitTablesLockRetries, CommitTablesLockDelay, True);
                  if (not Result) then
                    break;
                end;
            end;
      finally
        LocksFile.Free;
      end;
    end
  else
    Result := True;
end;// AddSRWLocksToULocks


//------------------------------------------------------------------------------
// SetPhysicalLockForWeakerLocks
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.SetPhysicalLockForWeakerLocks(SessionID: TABSSessionID; LockType: TABSLockType;
                        TableLocksFile: TABSTableLocksFile): Boolean;
var
  i: Integer;
begin
  Result := False;

  // attempts
  if (LockType = ltX) then
    Result := True
  else
   for i:=0 to TableUnlockRetries-1 do
     if (TableLocksFile.LockFile) then
       begin
         Result := True;
         break;
       end
     else
       begin
         Unlock;
         Sleep(TableUnlockDelay);
         Lock;
       end;
  // set phys lock for all weaker locks
  if (Result) then
    begin
      for i := 0 to TABSTableLockList(FSessionLockList[SessionID]).FLockList.Count-1 do
        if (TableLocksFile.StartPageNo = PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LocksFilePageNo) then
          if (TABSTableLockList(FSessionLockList[SessionID]).IsWeakerNonPhysicalLock(i, LockType)) then
            begin
              Result := TableLocksFile.LockTable(SessionID, PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i]).LockType);
              TABSTableLockList(FSessionLockList[SessionID]).SetPhysicalLock(i);
            end;

      if (LockType <> ltX) then
        TableLocksFile.UnlockFile;
    end;

end;// SetPhysicalLockForWeakerLocks


//------------------------------------------------------------------------------
// Create
//------------------------------------------------------------------------------
constructor TABSDatabaseTableLockManager.Create(MaxSessionCount: Integer; PageManager: TABSPageManager);
var
  i: Integer;
begin
  FMaxSessionCount := MaxSessionCount;
  LPageManager := PageManager;
  InitializeCriticalSection(FCSect);
  FSessionLockList := TList.Create;
  for i:=0 to FMaxSessionCount-1 do
    FSessionLockList.Add(TABSTableLockList.Create)
end;// Create


//------------------------------------------------------------------------------
// Destroy
//------------------------------------------------------------------------------
destructor TABSDatabaseTableLockManager.Destroy;
var
  i: Integer;
begin
  DeleteCriticalSection(FCSect);
  for i:=0 to FMaxSessionCount-1 do
    TABSTableLockList(FSessionLockList.Items[i]).Free;
  FSessionLockList.Free;
  inherited;
end;// Destroy


//------------------------------------------------------------------------------
// LockTable
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.LockTable(SessionID: TABSSessionID; LockType: TABSLockType;
                  TableLocksFile: TABSTableLocksFile;
                  aTryCount: Integer;
                  aDelayMS:  Integer;
                  NoThreadLock: Boolean = False;
                  AllowXIRWAfterSIRW: Boolean = True): Boolean;
var
  i: Integer;
{$IFDEF DEBUG_TABLELOCK}
  Error: Integer;
{$ENDIF}
begin
  if (not TABSDiskPageManager(LPageManager).Exclusive) then
    begin
      if (not NoThreadLock) then
        Lock;
      try
        // lock of this type from this session already exists?
        if (TABSTableLockList(FSessionLockList[SessionID]).LockExists(LockType, TableLocksFile.StartPageNo)) then
          begin
            // SIRW is not compatible with itself in the same session
            if (LockType <> ltSIRW) then
              begin
                TABSTableLockList(FSessionLockList[SessionID]).AddLock(LockType,
                                                TableLocksFile.StartPageNo, False);
                Result := True;
              end
            else
              Result := False;
          end
        else
          // stronger lock exists?
          if (TABSTableLockList(FSessionLockList[SessionID]).StrongerLockExists(LockType, TableLocksFile.StartPageNo)) then
            begin
              // add it and mark that it has no physically locked byte
              TABSTableLockList(FSessionLockList[SessionID]).AddLock(LockType,
                                              TableLocksFile.StartPageNo, False);
              Result := True;
            end
          else
            begin
              Result := False;
              // attempts
              for i:=0 to aTryCount-1 do
                begin
                  if (TableLocksFile.LockFile) then
                    begin
                      try
                        if (TableLocksFile.IsTableLockAllowed(SessionID, LockType, AllowXIRWAfterSIRW)) then
                          if (LockType <> ltX) then
                            begin
                              Result := TableLocksFile.LockTable(SessionID, LockType);
                              if (not Result) then
                              begin
                                {$IFDEF DEBUG_TABLELOCK}
                                Error := GetLastError;
                                raise EABSException.Create(20203, ErrorAFailedToSetTableLock + '#10#13 Windows error code: ' + IntToStr(Error));
                                {$ELSE}
                                raise EABSException.Create(20203, ErrorAFailedToSetTableLock );
                                {$ENDIF}
                              end
                            end
                          else
                            Result := True;
                        if (Result) then
                          begin
                            TABSTableLockList(FSessionLockList[SessionID]).AddLock(
                                LockType, TableLocksFile.StartPageNo, True, AllowXIRWAfterSIRW);
                            break;
                          end;
                      finally
                        if (not ((LockType = ltX) and Result)) then
                          TableLocksFile.UnlockFile;
                      end;
                    end;
                  if (not NoThreadLock) then
                    Unlock;
                  Sleep((aDelayMs div 2) + Random(aDelayMS div 2));
                  if (not NoThreadLock) then
                    Lock;
                end;
            end;
      finally
        if (not NoThreadLock) then
          Unlock;
      end;
    end
  else
    Result := True;
end;// LockTable


//------------------------------------------------------------------------------
// UnlockTable
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.UnlockTable(SessionID: TABSSessionID; LockType: TABSLockType;
     TableLocksFile: TABSTableLocksFile;
     IgnoreIfNoLock: Boolean=False; IgnoreCount: Boolean=False): Boolean;
var
  i: Integer;
  HasPhysicalLock: Boolean;
begin
  if (not TABSDiskPageManager(LPageManager).Exclusive) then
    begin
      Lock;
      try
        if (not TABSTableLockList(FSessionLockList[SessionID]).LockExists(LockType, TableLocksFile.StartPageNo)) then
         if (IgnoreIfNoLock) then
           begin
             Result := True;
             Exit;
           end;
        TABSTableLockList(FSessionLockList[SessionID]).RemoveLock(LockType,
                         TableLocksFile.StartPageNo, HasPhysicalLock, IgnoreCount);
        // physically unlock file byte?
        if ((HasPhysicalLock) and
            (not TABSTableLockList(FSessionLockList[SessionID]).LockExists(
                                        LockType, TableLocksFile.StartPageNo))) then
          begin
            Result := False;
            if (SetPhysicalLockForWeakerLocks(SessionID, LockType, TableLocksFile)) then
              // attempts
              for i:=0 to TableUnlockRetries-1 do
                begin
                  if (LockType = ltX) then
                    Result := TableLocksFile.UnlockFile
                  else
                    if (TableLocksFile.LockFile) then
                      begin
                        Result := TableLocksFile.UnlockTable(SessionID, LockType);
                        TableLocksFile.UnlockFile;
                        if (not Result) then
                          raise EABSException.Create(20204, ErrorAFailedToUnlockTable);
                      end;
                  if (Result) then
                    break;
                  Unlock;
                  Sleep(TableUnlockDelay);
                  Lock;
                end;
          end
        else
          Result := True;
        if (not Result) then
          TABSTableLockList(FSessionLockList[SessionID]).AddLock(LockType,
                            TableLocksFile.StartPageNo, HasPhysicalLock);
      finally
        Unlock;
      end;
    end
  else
    Result := True;
end;// UnlockTable


//------------------------------------------------------------------------------
// LockRecord
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.LockRecord(SessionID: TABSSessionID;
                                   TableLocksFile: TABSTableLocksFile;
                                   RecordID: TABSRecordID;
                                   aTryCount: Integer;
                                   aDelayMS:  Integer): Boolean;
var
  i: Integer;
  ActualDelayTimeMS, MaxDelayTimeMS, TimeStarted: Integer;
begin
  MaxDelayTimeMS := aTryCount * aDelayMS;
  TimeStarted := GetTickCount;
  Lock;
  try
    // lock from this session already exists?
    if (TABSTableLockList(FSessionLockList[SessionID]).LockExists(ltU, TableLocksFile.StartPageNo)) then
      Result := False
    else
      // X-lock or full-XIRW-lock of this session exists?
      if (TABSTableLockList(FSessionLockList[SessionID]).LockExists(ltX, TableLocksFile.StartPageNo)) or
         (TABSTableLockList(FSessionLockList[SessionID]).LockExists(ltXIRW, TableLocksFile.StartPageNo, False)) then
        begin
          TABSTableLockList(FSessionLockList[SessionID]).AddLock(
                             ltU, TableLocksFile.StartPageNo, False);
          Result := True;
        end
      else
        begin
          Result := False;
          // attempts
          for i:=0 to aTryCount-1 do
            begin
              if (TableLocksFile.LockFile) then
                begin
                  try
                    if (not TableLocksFile.IsRecordLockedByAnyOtherSession(SessionID, RecordID)) then
                      begin
                        Result := TableLocksFile.LockRecord(SessionID, RecordID);
                        if (not Result) then
                           raise EABSException.Create(20205, ErrorAFailedToSetRecordLock);
                      end
                    else
                      Result := False;
                    if (Result) then
                      begin
                        TABSTableLockList(FSessionLockList[SessionID]).AddLock(
                                           ltU, TableLocksFile.StartPageNo, True);
                        break;
                      end;
                  finally
                    TableLocksFile.UnlockFile;
                  end;
                end;
              Unlock;
              Sleep(aDelayMS);
              Lock;
              ActualDelayTimeMS := GetTickCount - TimeStarted;
              if ActualDelayTimeMS >= MaxDelayTimeMS then
                Break;
            end;
        end;
  finally
    Unlock;
  end;
end;// LockRecord


//------------------------------------------------------------------------------
// UnlockRecord
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.UnlockRecord(SessionID: TABSSessionID;
                                   TableLocksFile: TABSTableLocksFile;
                                   RecordID: TABSRecordID): Boolean;
var
  i: Integer;
  HasPhysicalLock: Boolean;
begin
  Lock;
  try
    // physically unlock file byte?
    if (not TABSTableLockList(FSessionLockList[SessionID]).LockExists(ltU, TableLocksFile.StartPageNo)) then
      Result := False
    else
      begin
        TABSTableLockList(FSessionLockList[SessionID]).RemoveLock(
               ltU, TableLocksFile.StartPageNo, HasPhysicalLock, False);
        if (HasPhysicalLock) then
          begin
            Result := False;
            // attempts
            for i:=0 to RecordUnlockRetries-1 do
              begin
                if (TableLocksFile.LockFile) then
                  begin
                    Result := TableLocksFile.UnlockRecord(SessionID, RecordID);
                    TableLocksFile.UnlockFile;
                    if (not Result) then
                      raise EABSException.Create(20206, ErrorAFailedToUnlockRecord);
                  end;
                if (Result) then
                  break;
                Unlock;
                Sleep(RecordUnlockDelay);
                Lock;
              end;
          end
        else
          Result := True;
      end;
  finally
    Unlock;
  end;
end;// UnlockRecord


//------------------------------------------------------------------------------
// IsRecordLocked
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.IsRecordLocked(SessionID: TABSSessionID;
                        TableLocksFile: TABSTableLocksFile;
                        RecordID: TABSRecordID): Boolean;
begin
  Lock;
  try
    Result := TableLocksFile.IsRecordLockedByAnyOtherSession(SessionID, RecordID);
  finally
    Unlock;
  end;
end;// IsRecordLocked


//------------------------------------------------------------------------------
// AddRWLocksBeforeCommit
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.AddRWLocksBeforeCommit(SessionID: TABSSessionID): Boolean;
var
  i: Integer;
  LocksFile: TABSTableLocksFile;
  StartPageNo: TABSPageNo;
begin
  Lock;
  try
    if (TABSTableLockList(FSessionLockList[SessionID]).FLockList.Count > 0) then
      begin
        LocksFile := TABSTableLocksFile.Create(LPageManager);
        try
          Result := True;
          // add RW locks to XIRW locks
          for i := 0 to TABSTableLockList(FSessionLockList[SessionID]).FLockList.Count-1 do
            if (PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LockType = ltXIRW) then
              begin
                StartPageNo := PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LocksFilePageNo;
                if (not TABSTableLockList(FSessionLockList[SessionID]).StrongerLockExists(
                                    ltRW, StartPageNo)) then
                  begin
                    LocksFile.OpenFile(StartPageNo);
                    Result := LockTable(SessionID, ltRW, LocksFile,
                               CommitTablesLockRetries, CommitTablesLockDelay, True);
                    LocksFile.CloseFile;
                    if (not Result) then
                      break;
                  end;
              end;
          // if failed, then remove RW locks
          if (not Result) then
            begin
              i := 0;
              while (i < TABSTableLockList(FSessionLockList[SessionID]).FLockList.Count) do
                begin
                  if (PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LockType = ltRW) then
                    begin
                      StartPageNo := PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LocksFilePageNo;
                      LocksFile.OpenFile(StartPageNo);
                      UnlockTable(SessionID, ltRW, LocksFile);
                      LocksFile.CloseFile;
                      if (TABSTableLockList(FSessionLockList[SessionID]).LockExists(ltRW, StartPageNo)) then
                        raise EABSException.Create(20234, ErrorATableIsStillLocked);
                    end
                  else
                    Inc(i);
                end;
            end;
        finally
          LocksFile.Free;
        end;
      end
    else
      Result := True;
  finally
    Unlock;
  end;
end;// AddRWLocksBeforeCommit


//------------------------------------------------------------------------------
// ClearTransactionLocks
//------------------------------------------------------------------------------
function TABSDatabaseTableLockManager.ClearTransactionLocks(SessionID: TABSSessionID): Boolean;
var
  i: Integer;
  LockType: TABSLockType;
  LocksFile: TABSTableLocksFile;
  StartPageNo: TABSPageNo;
begin
  Lock;
  try
    Result := AddSIRWLocksToULocks(SessionID);
    if (Result) then
      begin
        i := 0;
        LocksFile := TABSTableLocksFile.Create(LPageManager);
        try
          while (i < TABSTableLockList(FSessionLockList[SessionID]).FLockList.Count) do
            begin
              LockType := PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LockType;
              if ((LockType = ltXIRW) or (LockType = ltRW)) then
                begin
                  StartPageNo := PABSTableLock(TABSTableLockList(FSessionLockList[SessionID]).FLockList.Items[i])^.LocksFilePageNo;
                  LocksFile.OpenFile(StartPageNo);
                  UnlockTable(SessionID, LockType, LocksFile, False, True);
                  LocksFile.CloseFile;
                end
              else
                Inc(i);
            end;
        finally
          LocksFile.Free;
        end;
      end;
  finally
    Unlock;
  end;
end;// ClearTransactionLocks



////////////////////////////////////////////////////////////////////////////////
//
// Common routines
//
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// convert PageTypeID to String (for exceptions messages)
//------------------------------------------------------------------------------
function PageTypeToStr(PageType: TABSPageTypeID): AnsiString;
begin
  if PageType > High(ABSPageTypeNames) then
      raise EABSException.Create(30382, ErrorGUnknownPageType, [PageType]);
  Result := ABSPageTypeNames[PageType];
end;//PageTypeToStr


//------------------------------------------------------------------------------
// Try call Func before Success or TimeOut off
//------------------------------------------------------------------------------
function TryUsingTimeOut(Func: TBooleanFunctionForTimeOutCall;
                          TryCount: Integer; DelayMS: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i:=0 to TryCount-1 do
    if Func then
      begin
       Result := True;
       break;
      end
    else
      Sleep(DelayMS);
end;//TryUsingTimeOut


//------------------------------------------------------------------------------
// CheckPageType
//------------------------------------------------------------------------------
procedure CheckPageType(FoundType, WantedType: TABSPageTypeID; ErrorCode: Integer);
begin
 if (FoundType <> WantedType) then
  raise EABSException.Create(ErrorCode, ErrorGWrongPageType,
                         [PageTypeToStr(FoundType), PageTypeToStr(WantedType)]);
end;//CheckPageType


//------------------------------------------------------------------------------
// encrypts specified buffer
//------------------------------------------------------------------------------
function ABSInternalEncryptBuffer(
                          CryptoAlg:              TABSCryptoAlgorithm;
                          inBuf:                  TAbsPByte;
                          Size:                   Integer;
                          Password:               AnsiString
                          ): Boolean;
var crypto: TCipher;
begin
 try
  case CryptoAlg of
   craRijndael_128:
    begin
     crypto := TCipher_Rijndael.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.EncodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craRijndael_256:
    begin
     crypto := TCipher_Rijndael.Create(Password,nil);
     crypto.HashClass := THash_RipeMD256;
     crypto.InitKey(Password,crypto.Vector);
     crypto.EncodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craSquare:
    begin
     crypto := TCipher_Square.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.EncodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craDES_Single:
    begin
     crypto := TCipher_1DES.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.EncodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craDES_Triple:
    begin
     crypto := TCipher_3TDES.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.EncodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craBlowfish:
    begin
     crypto := TCipher_Blowfish.Create(Password,nil);
     crypto.HashClass := THash_RipeMD256;
     crypto.InitKey(Password,crypto.Vector);
     crypto.EncodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craTwofish_128:
    begin
     crypto := TCipher_Twofish.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.EncodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craTwofish_256:
    begin
     crypto := TCipher_Twofish.Create(Password,nil);
     crypto.HashClass := THash_RipeMD256;
     crypto.InitKey(Password,crypto.Vector);
     crypto.EncodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
  end; // case
  result := true;
 except
  result := false; // encryption error
 end;
end; // ABSInternalEncryptBuffer


//------------------------------------------------------------------------------
// decrypts specified buffer
//------------------------------------------------------------------------------
function ABSInternalDecryptBuffer(
                          CryptoAlg:              TABSCryptoAlgorithm;
                          inBuf:                  TAbsPByte;
                          Size:                   Integer;
                          Password:               AnsiString
                          ): Boolean;
var crypto: TCipher;
begin
 try
  case CryptoAlg of
   craRijndael_128:
    begin
     crypto := TCipher_Rijndael.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.DecodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craRijndael_256:
    begin
     crypto := TCipher_Rijndael.Create(Password,nil);
     crypto.HashClass := THash_RipeMD256;
     crypto.InitKey(Password,crypto.Vector);
     crypto.DecodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craSquare:
    begin
     crypto := TCipher_Square.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.DecodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craDES_Single:
    begin
     crypto := TCipher_1DES.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.DecodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craDES_Triple:
    begin
     crypto := TCipher_3TDES.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.DecodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craBlowfish:
    begin
     crypto := TCipher_Blowfish.Create(Password,nil);
     crypto.HashClass := THash_RipeMD256;
     crypto.InitKey(Password,crypto.Vector);
     crypto.DecodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craTwofish_128:
    begin
     crypto := TCipher_Twofish.Create(Password,nil);
     crypto.HashClass := THash_RipeMD128;
     crypto.InitKey(Password,crypto.Vector);
     crypto.DecodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
   craTwofish_256:
    begin
     crypto := TCipher_Twofish.Create(Password,nil);
     crypto.HashClass := THash_RipeMD256;
     crypto.InitKey(Password,crypto.Vector);
     crypto.DecodeBuffer(inBuf^,inBuf^,Size);
     crypto.Free;
    end;
  end; // case
  result := true;
 except
  result := false; // decryption error
 end;
end; // ABSInternalDecryptBuffer

function IsOSCriticalError: Boolean;
begin
	case GetLastError of
		ERROR_ACCESS_DENIED,
    ERROR_INVALID_HANDLE,
    ERROR_WRITE_FAULT,
    ERROR_READ_FAULT,
    ERROR_GEN_FAILURE,
    ERROR_BAD_NETPATH,
    ERROR_ADAP_HDW_ERR,
    ERROR_UNEXP_NET_ERR,
    ERROR_NETNAME_DELETED,
    ERROR_NETWORK_ACCESS_DENIED,
    ERROR_BAD_NET_NAME:
      Result:=True;
   else
	  	Result := False;
	end;
end;


end.
