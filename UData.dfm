object DataModule1: TDataModule1
  OldCreateOrder = False
  Left = 222
  Top = 131
  Height = 375
  Width = 1068
  object Qaux: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    RequestLive = True
    Left = 276
    Top = 121
  end
  object TTree: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    TableName = 'Tree'
    Exclusive = False
    Left = 21
    Top = 65
  end
  object DBDatabase: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    SilentMode = True
    OnNeedRepair = DBDatabaseNeedRepair
    Left = 23
    Top = 13
  end
  object Tprofiles: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    TableName = 'Profiles'
    Exclusive = False
    Left = 96
    Top = 65
  end
  object Tprofilesview: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'Profilesview'
    InMemory = False
    ReadOnly = False
    TableName = 'Profiles'
    Exclusive = False
    Left = 280
    Top = 64
  end
  object DBProfilesview: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'Profilesview'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    SilentMode = True
    OnNeedRepair = DBProfilesviewNeedRepair
    Left = 280
    Top = 16
  end
  object Tscansets: TABSTable
    Tag = 1
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    StoreDefs = True
    IndexDefs = <
      item
        Name = 'Y1'
        Fields = 'ID'
        Options = [ixPrimary]
      end
      item
        Name = 'Y2'
        Fields = 'Gamename'
        Options = [ixUnique]
      end>
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftAutoInc
      end
      item
        Name = 'Description'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Gamename'
        Attributes = [faRequired]
        DataType = ftString
        Size = 255
      end>
    Exclusive = False
    Left = 24
    Top = 120
  end
  object Tscanroms: TABSTable
    Tag = 1
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    StoreDefs = True
    Exclusive = False
    Left = 24
    Top = 176
  end
  object TDirectories: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    TableName = 'Directories'
    Exclusive = False
    Left = 168
    Top = 64
  end
  object Temulators: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    TableName = 'Emulators'
    Exclusive = False
    Left = 168
    Top = 120
  end
  object Taux: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    Exclusive = False
    Left = 276
    Top = 176
  end
  object DBConstructor: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'DBConstructor'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    SilentMode = True
    OnNeedRepair = DBConstructorNeedRepair
    Left = 368
    Top = 16
  end
  object Tconstructor: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBConstructor'
    InMemory = False
    ReadOnly = False
    Exclusive = False
    Left = 368
    Top = 64
  end
  object DBUpdater: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'DBUpdater'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    SilentMode = True
    OnNeedRepair = DBUpdaterNeedRepair
    Left = 528
    Top = 16
  end
  object Tupdater: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBUpdater'
    InMemory = False
    ReadOnly = False
    Exclusive = False
    Left = 528
    Top = 72
  end
  object Qupdater: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'DBUpdater'
    InMemory = False
    ReadOnly = False
    Left = 528
    Top = 128
  end
  object DBHeaders: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'DBHeaders'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    SilentMode = True
    OnNeedRepair = DBHeadersNeedRepair
    Left = 600
    Top = 16
  end
  object Trules: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBHeaders'
    InMemory = False
    ReadOnly = False
    TableName = 'Rules'
    Exclusive = False
    Left = 600
    Top = 72
  end
  object Ttest: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBHeaders'
    InMemory = False
    ReadOnly = False
    TableName = 'Tests'
    Exclusive = False
    Left = 600
    Top = 128
  end
  object Tinvertedcrc: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    Exclusive = False
    Left = 24
    Top = 232
  end
  object DBUrls: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'DBURLs'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    SilentMode = True
    OnNeedRepair = DBUrlsNeedRepair
    Left = 688
    Top = 16
  end
  object Tfavorites: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBURLs'
    InMemory = False
    ReadOnly = False
    TableName = 'Favorites'
    Exclusive = False
    Left = 688
    Top = 80
  end
  object Thistory: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBURLs'
    InMemory = False
    ReadOnly = False
    TableName = 'History'
    Exclusive = False
    Left = 688
    Top = 128
  end
  object Qurls: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'DBURLs'
    InMemory = False
    ReadOnly = False
    RequestLive = True
    Left = 688
    Top = 184
  end
  object Qfavorites: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'DBURLs'
    InMemory = False
    ReadOnly = False
    RequestLive = True
    Left = 688
    Top = 240
  end
  object Qaux2: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    Left = 272
    Top = 232
  end
  object Qaux3: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    Left = 272
    Top = 280
  end
  object QDupes: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    Left = 24
    Top = 288
  end
  object Qsort: TABSQuery
    CurrentVersion = '7.30 '
    InMemory = False
    ReadOnly = False
    Left = 448
    Top = 280
  end
  object Qconstructor: TABSQuery
    CurrentVersion = '7.30 '
    InMemory = False
    ReadOnly = False
    Left = 368
    Top = 120
  end
  object DBMyquerys: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'DBMYQUERYS'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    Left = 792
    Top = 18
  end
  object Qmyquerys: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'DBMYQUERYS'
    InMemory = False
    ReadOnly = False
    SQL.Strings = (
      'SELECT * FROM Querys'
      'WHERE Status = '#39#39
      'ORDER BY Priority DESC,Added DESC')
    Left = 791
    Top = 130
  end
  object Tmyquerys: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBMYQUERYS'
    InMemory = False
    ReadOnly = False
    TableName = 'Querys'
    Exclusive = False
    Left = 792
    Top = 80
  end
  object DBPeers: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'DBPEERS'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    Left = 875
    Top = 19
  end
  object Tpeers: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBPEERS'
    InMemory = False
    ReadOnly = False
    TableName = 'Peers'
    Exclusive = False
    Left = 872
    Top = 80
  end
  object Qpeers: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'DBPEERS'
    InMemory = False
    ReadOnly = False
    SQL.Strings = (
      'SELECT * FROM Peers'
      'ORDER BY Description')
    Left = 872
    Top = 136
  end
  object Qmyquerysview: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'DBMYQUERYS'
    InMemory = False
    ReadOnly = False
    SQL.Strings = (
      'SELECT * FROM Querys')
    Left = 792
    Top = 184
  end
  object Qemulators: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'RML_DATA'
    InMemory = False
    ReadOnly = False
    Left = 168
    Top = 176
  end
  object DBServers: TABSDatabase
    CurrentVersion = '7.30 '
    DatabaseName = 'DBSERVERS'
    Exclusive = False
    MaxConnections = 500
    MultiUser = False
    SessionName = 'Default'
    Left = 952
    Top = 16
  end
  object Qservers: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'DBSERVERS'
    InMemory = False
    ReadOnly = False
    Left = 952
    Top = 136
  end
  object Tservers: TABSTable
    CurrentVersion = '7.30 '
    DatabaseName = 'DBSERVERS'
    InMemory = False
    ReadOnly = False
    Exclusive = False
    Left = 952
    Top = 80
  end
  object QpeersThread: TABSQuery
    CurrentVersion = '7.30 '
    DatabaseName = 'DBPEERS'
    InMemory = False
    ReadOnly = False
    SQL.Strings = (
      'SELECT * FROM Peers'
      'WHERE Yourself=false'
      'ORDER BY ID')
    Left = 872
    Top = 192
  end
end
