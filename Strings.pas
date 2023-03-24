Unit Strings;

interface

uses
  Windows, SysUtils, Controls, Dialogs, Forms, ShellAPI, Graphics, ComCtrls,
  Messages, Classes, StdCtrls, ShlObj, Absmain,Activex, BMDThread, WinInet,
  ComObj, Udata, Buttons, Extctrls, GR32_Image, Variants,Winsock, VirtualTrees, Math,
  TntWindows, TntStdCtrls, Tntforms, Tntsysutils, Tntclasses, TntComCtrls,TntButtons, DB,
  Cooltrayicon, registry, Hashes, XMLIntf, XMLDoc, RxRiched, Gptextfile, Tntdialogs;

type
  Trecsets = class
    private
      dir : widestring;
      dirup : widestring;
      id : longint;
    public
      property directory : widestring
          read dir;
      property directoryup : widestring
          read dirup;
      property id_ : longint
          read id;
      constructor Create(const dir : widestring; const dirup :widestring ;const id : longint);
  end;

type
  Trecroms = class
    private
      id : longint;
      romname : widestring;
      romnameup : widestring;
    public
      property id_ : longint
          read id;
      property romname_ : widestring
          read romname;
      property romnameup_ : widestring
          read romnameup;
      constructor Create(const id : longint; const romname :widestring ;const romnameup : widestring);
  end;

type
  Treccrcs = class
    private
      id : longint;
      checksum : string;
    public
      property id_ : longint
          read id;
      property checksum_ : string
          read checksum;
      constructor Create(const id : longint; const checksum :string);
  end;

type
  Trecmd5s = class
    private
      id : longint;
      checksum : string;
    public
      property id_ : longint
          read id;
      property checksum_ : string
          read checksum;
      constructor Create(const id : longint; const checksum :string);
  end;

type
  Trecsha1s = class
    private
      id : longint;
      checksum : string;
    public
      property id_ : longint
          read id;
      property checksum_ : string
          read checksum;
      constructor Create(const id : longint; const checksum :string);
  end;

function removeconflictchars(str:widestring;folderallowed:boolean):widestring;
function removeconflictchars2(str:widestring;percent:boolean):widestring;
function fillwithzeroes(str:ansistring;howmany:integer):ansistring;
function Changein(Instr, this, forthis: widestring): widestring;
procedure freemousebuffer;
procedure freekeyboardbuffer;
function romulusurl():ansistring;
function romulustitle():ansistring;
function GetToken(str, separator: widestring; Token: Integer): widestring;
function GetTokenCount(str, Separator: widestring): Integer;
function sizeoffile(f: widestring): int64;
function checkpathbar(path:widestring):widestring;
function xmlparser(str:widestring):widestring;
procedure exec(F:Tform;path:widestring);
procedure RunAndWaitShell(exe,args:ansistring;visibility:integer;out_:boolean;emulator:boolean);//NO WIDE NEEDED
procedure posintoindex(ind:int64;obj:Tobject);
procedure posintoindexbynode(n:PVirtualNode;lv:TVirtualStringTree);
function BytesToStr(Bytes: currency): ansiString;
function currtohex(c:currency):string;
Procedure CenterInClient(Obj:TControl; Const ObjRef:TControl);
function limitconflictcharsedit(sender:Tobject;key:char;percent:boolean):char;
procedure limitconflictcharsedit2(sender:Tobject;percent:boolean);
function traduction(i:integer):widestring;
function tempdirectoryextractdefault():ansistring;
function tempdirectoryextract():widestring;
function tempdirectoryextractserver():widestring;
function tempdirectorycommunity():ansistring;
function tempdirectoryresources():ansistring;
function tempdirectoryprofiles():ansistring;
function tempdirectoryupdater():ansistring;
function tempdirectoryupdates():ansistring;
function tempdirectoryconstructor():ansistring;
function tempdirectorymasterdetail(id:ansistring):ansistring;
function tempdirectoryheadersdbpath():ansistring;
function tempdirectorypeers():ansistring;
function downloadeddatsdirectory():widestring;
function tempdirectorycache():widestring;
function pointdelimiters(num:extended):ansistring;
function filewithoutext(f:widestring):widestring;
function IsDirectoryEmpty(directory : widestring) : boolean;
function getvaliddestination(path:widestring):widestring;
function FileInUse(FileName: widestring): Boolean;
function appversion():ansistring;
function IsWineOS:Boolean;
procedure makeexception;
function DesktopSize: TRect;
function defaultofffilename():ansistring;
function checkofflinelistfilenameiffailsreturndefault(str:widestring):widestring;
function checkofflinelistdescriptioniffailsreturndefault(str:widestring):widestring;
function splitmergestring(i:integer):ansistring;
function getcounterfilemode(Tablesets,Tableroms:ansistring;fmode:shortint;insertion:boolean):ansistring;
function getdattypeiconindexfromchar(typ:string):integer;
function GetShortFileName(Const FileName : widestring) : widestring;
function GetDesktopFolder: widestring;
Function checkpathcase(S : widestring) : widestring;
function folderdialoginitialdircheck(path:widestring):widestring;
function mameoutpath():ansistring;
function deletefile2(path:widestring):boolean;
function chdmanpath():ansistring;//NO WIDE NEEDED
function rarpath():ansistring;//NO WIDE NEEDED
function sevenzippath():ansistring;//NO WIDE NEEDED
function sevenzipdelpath():ansistring;//NO WIDE NEEDED
function FileExists2(FileName: widestring): boolean;
function torrentzippath():ansistring;
function torrent7zippath():ansistring;
function headerspath():widestring;
function SecToTime(Sec: int64): string;
function IAmIn64Bits: Boolean;
function updatercount():integer;
function updaterdescription(id:integer;text:boolean):string;
function ispowerof2(num:int64):boolean;
function applyheader(filename:widestring;Rules:Tabstable;Test:Tabstable):widestring;//NO WIDE NEEDED
function resizefile(Filenamein,Filenameout:widestring;startsize,newsize:int64;operation:integer):boolean;//NO WIDE NEEDED
function isanexefile(path:widestring):boolean;
function IsUserAdmin : boolean;
procedure disablesysmenu(F:Tform;status:boolean);
function isunicodefilename(path:widestring):boolean;
function widestringtoustring(text:widestring):ansistring;
Function MouseButtonIsDown(Button:TMousebutton):Boolean;
function fixxmlseparators(str:widestring):widestring;
function Fileisutf8(FileName: widestring): Boolean;
function createdummyfile(path:ansistring;space:int64):boolean;//NO WIDE NEEDED
function getinverthex(hex:string):string;
function defaulthtmlsource(asinfo:boolean):widestring;
function isthisvalidurl(url:ansistring):boolean;
function isthisvalidurlfile(url:ansistring):boolean;
function maxlangid():integer;
function IsNTFS(AFileName : widestring) : boolean;
function defpagecountinextent(): integer;
function defpagesize(): integer;
function defuseragent():ansistring;
function defcommunitydownfolder():widestring;
function formexists(formname:ansistring):boolean;
function defmaxconnections():integer;
function getcpunumcores():cardinal;
function RunAsAdmin(const Handle: Hwnd; const Path, Params: widestring): Boolean;
procedure TurboCopyFile(const SourceFile,DestinationFile: widestring);
procedure stablishfocus(Obj:Tobject);
procedure myshowform(F:Tform;modal:boolean);
Function GetFormsCount: Integer;
function copyfile2(origin,dest:widestring):boolean;
function defrequestsfilename():widestring;
Function GetUserFromWindows: widestring;
function checkvalidinternetport(port,default:integer):integer;
function IsConnectedtointernet: boolean;
function Findexefromextension(const aFileName: widestring): widestring;
procedure AddApplicationToWinFirewall(const EntryName, ApplicationPathAndExe: widestring);
procedure AddPortToWinFirewall(const EntryName: string; PortNumber: cardinal);
function GetParentForm(Acomponent: Tcomponent): TCustomForm;
procedure KillProcess(hWindowHandle: HWND);
function defserverport():integer;
function getbackuppathofid(id:Integer):widestring;
function getromspathofid(id:integer):widestring;
function getsamplespathofid(id:integer):widestring;
function getchdspathofid(id:integer):widestring;
procedure setwiderecord(field:Tfield;value:widestring);
function getwiderecord(field:Tfield):widestring;
procedure PrintControl(AControl :TWinControl;AOut:TBitmap);
function movefile2(org,dest:widestring):boolean;
function defaultfontname:string;
function recsetsbinsearch(recsets: Tlist; SubStr: widestring): Integer;
function recromsbinsearch(recroms: Tlist; SubStr: widestring): Integer;
procedure clearrecords;
procedure Filteredit(Sender: TObject);
procedure installfonts;
function OS_IsWindows8: Boolean;
function checkNAN(s:string):string;
function reccrcsbinarysort(Item1 : Pointer; Item2 : Pointer) : Integer;
function recmd5sbinarysort(Item1 : Pointer; Item2 : Pointer) : Integer;
function recsha1sbinarysort(Item1 : Pointer; Item2 : Pointer) : Integer;
function reccrcsbinsearch(recroms: Tlist; SubStr: string): Integer;
function recmd5sbinsearch(recroms: Tlist; SubStr: string): Integer;
function recsha1sbinsearch(recroms: Tlist; SubStr: string): Integer;
function geticonofextension(extension:string):Ticon;
procedure sleepmillionsegs(millionsecs:int64);
function checklinkedconnectionsok():boolean;
function IsAeroEnabled: Boolean;
procedure setlinkedconnections;
Procedure FormatXMLFile(const XmlFile:widestring);
procedure insertrichtext(rich:Trxrichedit;txt:widestring;cl:Tcolor);
procedure insertrichtextchat(rich:Trxrichedit;txt:widestring;imagelist:Timagelist;cl:Tcolor;username:widestring);
procedure removerichformat(rich:Ttntrichedit);
procedure ScrollToEnd(ARichEdit: TRxRichEdit);
procedure initializeemojislist;
function FormatInClock(TickCount: int64): string;
function getrichpath(path:widestring):widestring;
function WideSystemDir: widestring;
function cmdpatchedpath: ansistring;
function ansi2widestring(str:ansistring):widestring;
procedure setconsolefont(face:ansistring;numb:integer);
procedure getconsolefont(var facename:ansistring;var fontfamily:integer);//save console font
function FileMayBeUTF8(FileName: WideString): Boolean;
function HexToInt(const Value: String): Int64;
function widefileage2(filename:widestring):longint;
function idtolangname(i:integer):widestring;
function isaformactive(formname:string):boolean;
procedure Windowshibernate();
function WindowsExit(RebootParam: Longword): Boolean;
function chdgetinfo(filename:widestring):widestring;
function limitconflictcharseditdialog(sender:Tobject;key:char):char;
function removeconflictchars3(str:widestring):widestring;

var
lang:shortint;
deffilemode:shortint;
iswin64,onathread:boolean;
activeformlist,writelist:Tstringlist;
username:widestring;
defaultprofileshare:boolean;
lastmainpageindex:shortint;
defmd5,defsha1,deftz,deft7z:boolean;
defbackuppath:widestring;
translation:TTntStringList;
testmode:boolean;
tempdirectoryextractvar,tempdirectoryextractservervar:widestring;
stsets:TTntStringList;
stroms:Ttntstringlist;
stsofts:Ttntstringlist;
stids:Tstringlist;
recsets,recroms:Tlist;
reccrcs,recmd5s,recsha1s:Tlist;
oldscanleft,oldscantop:integer;
foreghandle:integer;
emojislist:TStringList;

const
  RsSystemIdleProcess = 'System Idle Process';
  RsSystemProcess = 'System Process';
  CM_RESTORE = WM_USER + $1000;
  //CRYPT KEYS
  CKEY1 = 53761;
  CKEY2 = 32618;

implementation

uses Types, GPHugeF;

{$R RESOURCES.RES}
{$DEFINE UseRes7zdll}  //DYNAMIC DLL 7Z LOAD

constructor Trecsets.Create(const dir:widestring; const dirup:widestring; const id:longint);
begin
  self.dir := dir;
  self.dirup:= dirup;
  self.id := id;
end;

constructor Trecroms.Create(const id : longint; const romname :widestring ;const romnameup : widestring);
begin
  self.id:=id;
  self.romname:=romname;
  self.romnameup:=romnameup;
end;

constructor Treccrcs.Create(const id : longint; const checksum :string);
begin
  self.id:=id;
  self.checksum:=checksum;
end;

constructor Trecmd5s.Create(const id : longint; const checksum :string);
begin
  self.id:=id;
  self.checksum:=checksum;
end;

constructor Trecsha1s.Create(const id : longint; const checksum :string);
begin
  self.id:=id;
  self.checksum:=checksum;
end;

function recsetsbinarysort(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  c1, c2 : Trecsets;
begin
  // We start by viewing the object pointers as TCustomer objects
  c1 := Trecsets(Item1);
  c2 := Trecsets(Item2);

  // Now compare by string
  if c1.dirup > c2.dirup
  then Result := 1
  else if c1.dirup = c2.dirup
  then Result := 0
  else Result := -1;
end;

function recromsbinarysort(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  c1, c2 : Trecroms;
begin
  // We start by viewing the object pointers as TCustomer objects
  c1 := Trecroms(Item1);
  c2 := Trecroms(Item2);

  // Now compare by string
  if c1.romnameup > c2.romnameup
  then Result := 1
  else if c1.romnameup = c2.romnameup
  then Result := 0
  else Result := -1;
end;


function recsetsbinsearch(recsets: Tlist; SubStr: widestring): Integer;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
  Found: Boolean;
begin

  First  := 0; //Sets the first item of the range
  Last   := recsets.Count-1; //Sets the last item of the range
  Found  := False; //Initializes the Found flag (Not found yet)
  Result := -1; //Initializes the Result

  //If First > Last then the searched item doesn't exist
  //If the item is found the loop will stop
  while (First <= Last) and (not Found) do
  begin
    //Gets the middle of the selected range
    Pivot := (First + Last) div 2;
    //Compares the String in the middle with the searched one
    if Trecsets(recsets[Pivot]).dirup = SubStr then
    begin
      Found  := True;
      Result := Pivot;
    end
    //If the Item in the middle has a bigger value than
    //the searched item, then select the first half
    else if Trecsets(recsets[Pivot]).dirup  > SubStr then
      Last := Pivot - 1
        //else select the second half
    else
      First := Pivot + 1;
  end;
end;

function recromsbinsearch(recroms: Tlist; SubStr: widestring): Integer;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
  Found: Boolean;
begin

  First  := 0; //Sets the first item of the range
  Last   := recroms.Count-1; //Sets the last item of the range
  Found  := False; //Initializes the Found flag (Not found yet)
  Result := -1; //Initializes the Result

  //If First > Last then the searched item doesn't exist
  //If the item is found the loop will stop
  while (First <= Last) and (not Found) do
  begin
    //Gets the middle of the selected range
    Pivot := (First + Last) div 2;
    //Compares the String in the middle with the searched one
    if Trecroms(recroms[Pivot]).romnameup = SubStr then
    begin
      Found  := True;
      Result := Pivot;
    end
    //If the Item in the middle has a bigger value than
    //the searched item, then select the first half
    else if Trecroms(recroms[Pivot]).romnameup  > SubStr then
      Last := Pivot - 1
        //else select the second half
    else
      First := Pivot + 1;
  end;
end;

function reccrcsbinarysort(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  c1, c2 : Treccrcs;
begin
  // We start by viewing the object pointers as TCustomer objects
  c1 := Treccrcs(Item1);
  c2 := Treccrcs(Item2);

  // Now compare by string
  if c1.checksum > c2.checksum
  then Result := 1
  else if c1.checksum = c2.checksum
  then Result := 0
  else Result := -1;
end;

function recmd5sbinarysort(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  c1, c2 : Trecmd5s;
begin
  // We start by viewing the object pointers as TCustomer objects
  c1 := Trecmd5s(Item1);
  c2 := Trecmd5s(Item2);

  // Now compare by string
  if c1.checksum > c2.checksum
  then Result := 1
  else if c1.checksum = c2.checksum
  then Result := 0
  else Result := -1;
end;

function recsha1sbinarysort(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  c1, c2 : Trecsha1s;
begin
  // We start by viewing the object pointers as TCustomer objects
  c1 := Trecsha1s(Item1);
  c2 := Trecsha1s(Item2);

  // Now compare by string
  if c1.checksum > c2.checksum
  then Result := 1
  else if c1.checksum = c2.checksum
  then Result := 0
  else Result := -1;
end;

function reccrcsbinsearch(recroms: Tlist; SubStr: string): Integer;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
  Found: Boolean;
begin

  First  := 0; //Sets the first item of the range
  Last   := reccrcs.Count-1; //Sets the last item of the range
  Found  := False; //Initializes the Found flag (Not found yet)
  Result := -1; //Initializes the Result

  //If First > Last then the searched item doesn't exist
  //If the item is found the loop will stop
  while (First <= Last) and (not Found) do
  begin
    //Gets the middle of the selected range
    Pivot := (First + Last) div 2;
    //Compares the String in the middle with the searched one
    if Treccrcs(reccrcs[Pivot]).checksum = SubStr then
    begin
      Found  := True;
      Result := Pivot;
    end
    //If the Item in the middle has a bigger value than
    //the searched item, then select the first half
    else if Treccrcs(reccrcs[Pivot]).checksum  > SubStr then
      Last := Pivot - 1
        //else select the second half
    else
      First := Pivot + 1;
  end;
end;

function recmd5sbinsearch(recroms: Tlist; SubStr: string): Integer;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
  Found: Boolean;
begin

  First  := 0; //Sets the first item of the range
  Last   := recmd5s.Count-1; //Sets the last item of the range
  Found  := False; //Initializes the Found flag (Not found yet)
  Result := -1; //Initializes the Result

  //If First > Last then the searched item doesn't exist
  //If the item is found the loop will stop
  while (First <= Last) and (not Found) do
  begin
    //Gets the middle of the selected range
    Pivot := (First + Last) div 2;
    //Compares the String in the middle with the searched one
    if Trecmd5s(recmd5s[Pivot]).checksum = SubStr then
    begin
      Found  := True;
      Result := Pivot;
    end
    //If the Item in the middle has a bigger value than
    //the searched item, then select the first half
    else if Trecmd5s(recmd5s[Pivot]).checksum  > SubStr then
      Last := Pivot - 1
        //else select the second half
    else
      First := Pivot + 1;
  end;
end;

function recsha1sbinsearch(recroms: Tlist; SubStr: string): Integer;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
  Found: Boolean;
begin

  First  := 0; //Sets the first item of the range
  Last   := recsha1s.Count-1; //Sets the last item of the range
  Found  := False; //Initializes the Found flag (Not found yet)
  Result := -1; //Initializes the Result

  //If First > Last then the searched item doesn't exist
  //If the item is found the loop will stop
  while (First <= Last) and (not Found) do
  begin
    //Gets the middle of the selected range
    Pivot := (First + Last) div 2;
    //Compares the String in the middle with the searched one
    if Trecsha1s(recsha1s[Pivot]).checksum = SubStr then
    begin
      Found  := True;
      Result := Pivot;
    end
    //If the Item in the middle has a bigger value than
    //the searched item, then select the first half
    else if Trecsha1s(recsha1s[Pivot]).checksum  > SubStr then
      Last := Pivot - 1
        //else select the second half
    else
      First := Pivot + 1;
  end;
end;

procedure Windowshibernate();
begin
//powercfg.exe /hibernate on
//shutdown /h
RunAndWaitShell('powercfg.exe','/hibernate on',0,false,false);
RunAndWaitShell('shutdown','/h',0,false,false);
end;

function WindowsExit(RebootParam: Longword): Boolean;
var
   TTokenHd: THandle;
   TTokenPvg: TTokenPrivileges;
   cbtpPrevious: DWORD;
   rTTokenPvg: TTokenPrivileges;
   pcbtpPreviousRequired: DWORD;
   tpResult: Boolean;
const
   SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
   if Win32Platform = VER_PLATFORM_WIN32_NT then
   begin
     tpResult := OpenProcessToken(GetCurrentProcess(),
       TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
       TTokenHd) ;
     if tpResult then
     begin
       tpResult := LookupPrivilegeValue(nil,
                                        SE_SHUTDOWN_NAME,
                                        TTokenPvg.Privileges[0].Luid) ;
       TTokenPvg.PrivilegeCount := 1;
       TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
       cbtpPrevious := SizeOf(rTTokenPvg) ;
       pcbtpPreviousRequired := 0;
       if tpResult then
         Windows.AdjustTokenPrivileges(TTokenHd,
                                       False,
                                       TTokenPvg,
                                       cbtpPrevious,
                                       rTTokenPvg,
                                       pcbtpPreviousRequired) ;
     end;
   end;
   Result := ExitWindowsEx(RebootParam, 0) ;
end;


function isaformactive(formname:string):boolean;
var
res:boolean;
x:integer;
begin
res:=false;
formname:=UpperCase(formname);

for x:=0 to screen.FormCount-1 do
  if uppercase(screen.Forms[x].Name)=formname then
    if screen.Forms[x].Active=true then
      res:=true;

Result:=res;
end;

function HexToInt(const Value: String): Int64;
 begin
   Result := StrToInt64('$' + Value);
end;

function ansi2widestring(str:ansistring):widestring;
begin
str:=AnsitoUtf8(str);
result:=UTF8Decode(str);
end;

procedure sleepmillionsegs(millionsecs:int64);
var
Frec,X,Y,res:Int64;
begin
res:=0;
QueryPerformanceFrequency(Frec);
QueryPerformanceCounter(X);
while res<millionsecs do begin
  QueryPerformanceCounter(Y);
  res:=((Y - X) * 1000000 div Frec);
end;

end;

function geticonofextension(extension:string):Ticon;
var
Ainfo:TSHFileInfo;
AIcon: TIcon;
begin
Aicon:=Ticon.Create;

try
  SHGetFileInfo(PChar('*.'+extension), FILE_ATTRIBUTE_NORMAL, Ainfo,
  SizeOf(Ainfo), SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES);

  Aicon.handle:=Ainfo.hIcon;
except
end;

Result:=Aicon;

Aicon.Free;
end;

procedure initializeemojislist;
begin
emojislist:=TStringList.Create;

emojislist.Add(':)');
emojislist.Add(';)');
emojislist.Add(':(');
emojislist.Add(':D');
emojislist.Add(':P');
emojislist.Add(':o');
emojislist.Add(':S');
emojislist.Add(':''');
emojislist.Add(':#');
emojislist.Add(':$');
emojislist.Add('8@');
emojislist.Add('8)');
emojislist.Add('8D');
emojislist.Add('8|');
emojislist.Add('^|');
emojislist.Add(':@');
end;

function FileMayBeUTF8(FileName: WideString): Boolean;
var
 Stream: TTntMemoryStream;
 BytesRead: integer;
 ArrayBuff: array[0..127] of byte;
 PreviousByte: byte;
 i: integer;
 YesSequences, NoSequences: integer;
begin
Result:=true;

if not WideFileExists(FileName) then
  Exit;

YesSequences := 0;
NoSequences := 0;
Stream := TTntMemoryStream.Create;
try

  Stream.LoadFromFile(FileName);
  repeat
    application.ProcessMessages;//F0X FIX
    {read from the TMemoryStream}

    BytesRead := Stream.Read(ArrayBuff, High(ArrayBuff) + 1);
    {Do the work on the bytes in the buffer}
    if BytesRead > 1 then begin
      for i := 1 to BytesRead-1 do begin
        PreviousByte := ArrayBuff[i-1];
        if ((ArrayBuff[i] and $c0) = $80) then begin
          if ((PreviousByte and $c0) = $c0) then begin
            inc(YesSequences)
          end
          else
          begin
            if ((PreviousByte and $80) = $0) then
              inc(NoSequences);
          end;
        end;
      end;
    end;
  until (BytesRead < (High(ArrayBuff) + 1));

  //Below, >= makes ASCII files = UTF-8, which is no problem.
  //Simple > would catch only UTF-8;

  Result := (YesSequences >= NoSequences);

finally
  Stream.Free;
end;

end;

Procedure FormatXMLFile(const XmlFile:widestring);
var
oXml : IXMLDocument;
begin
oXml := TXMLDocument.Create(nil);
try
  oXml.LoadFromFile(XmlFile);
  oXml.XML.Text:=xmlDoc.FormatXMLData(oXml.XML.Text);
  oXml.Active := true;
  oXml.SaveToFile(XmlFile);
except
end;
oXml := nil;
end;

procedure getconsolefont(var facename:ansistring;var fontfamily:integer);//save console font
var
reg:TRegistry;
faceaux:ansistring;
begin

reg:=TRegistry.Create(KEY_READ);

try
  reg.RootKey:=HKEY_CURRENT_USER;

  if reg.OpenKey('\Console',true) then begin
    facename:=reg.ReadString('Facename');
    fontfamily:=reg.ReadInteger('FontFamily');
  end;

  if reg.OpenKey('\Console\%SystemRoot%_system32_cmd.exe',true) then begin
    try
      faceaux:=reg.ReadString('Facename');
      fontfamily:=reg.ReadInteger('FontFamily');
      if faceaux<>facename then
        facename:=facename+'*'+faceaux;
    except
      facename:=facename+'*';
    end;
  end;

  //XP AND VISTA FIX
  if (Win32MajorVersion=5) OR ((Win32MajorVersion=6) AND (Win32MinorVersion=0)) OR (testmode=true) then
    if reg.OpenKey('\Console\'+changein(cmdpatchedpath,'\','_'),true) then begin
      try
        facename:=reg.ReadString('Facename');
        fontfamily:=reg.ReadInteger('FontFamily');
      except
        facename:=facename+'*';
      end;
    end;

except
end;

reg.Free;
end;

procedure setconsolefont(face:ansistring;numb:integer);
var
reg:TRegistry;
begin

reg:=TRegistry.Create(KEY_WRITE);

try
  reg.RootKey:=HKEY_CURRENT_USER;

  if reg.OpenKey('\Console',true) then begin
    reg.WriteString('FaceName',face);
    reg.WriteInteger('FontFamily',numb);
  end;

  if reg.OpenKey('\Console\%SystemRoot%_system32_cmd.exe',true) then begin
    reg.WriteString('FaceName',face);
    reg.WriteInteger('FontFamily',numb);
  end;

  //XP AND VISTA FIX
  if (Win32MajorVersion=5) OR ((Win32MajorVersion=6) AND (Win32MinorVersion=0)) OR (testmode=true) then
    if reg.OpenKey('\Console\'+changein(cmdpatchedpath,'\','_'),true) then begin
      reg.WriteString('FaceName',face);
      reg.WriteInteger('FontFamily',numb);
    end;

except
end;

reg.Free;
end;

procedure setlinkedconnections;
var
reg:TRegistry;
begin
reg:=TRegistry.Create(KEY_WRITE);

try
  reg.RootKey:=HKEY_LOCAL_MACHINE;

  if reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',true) then
    reg.Writeinteger('EnableLinkedConnections',1);

except
end;

reg.Free;
end;

function IsAeroEnabled: Boolean;
type
  TDwmIsCompositionEnabledFunc = function(out pfEnabled: BOOL): HRESULT; stdcall;
var
  IsEnabled: BOOL;
  ModuleHandle: HMODULE;
  DwmIsCompositionEnabledFunc: TDwmIsCompositionEnabledFunc;
begin
  Result := False;
  if Win32MajorVersion >= 6 then // Vista or Windows 7+
  begin
    ModuleHandle := LoadLibrary('dwmapi.dll');
    if ModuleHandle <> 0 then
    try
      @DwmIsCompositionEnabledFunc := GetProcAddress(ModuleHandle, 'DwmIsCompositionEnabled');
      if Assigned(DwmIsCompositionEnabledFunc) then
        if DwmIsCompositionEnabledFunc(IsEnabled) = S_OK then
          Result := IsEnabled;
    finally
      FreeLibrary(ModuleHandle);
    end;
  end;
end;

function checklinkedconnectionsok():boolean;
var
reg:TRegistry;
val:integer;
res:boolean;
begin
res:=true;

if Win32MajorVersion>=6 then begin//NO PROBLEM OLD OSs

  res:=false;
  val:=0;
  reg:=TRegistry.Create(KEY_READ);

  try
  reg.RootKey:=HKEY_LOCAL_MACHINE;

  if reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',true) then
    val:=reg.readinteger('EnableLinkedConnections');

  except
  end;

  reg.Free;

  if val=1 then
    res:=true;

end;

Result:=res;
end;

function checkNAN(s:string):string;
begin
if (s='NAN %') OR (s='INF %') then
  s:='0'+DecimalSeparator+'00 %';

Result:=s;
end;

function bitmapchangecolor(bmp:Tbitmap;correct:Tcolor):Tbitmap;
var
x,y:integer;
coriginal:Tcolor;
begin
coriginal:=bmp.Canvas.Pixels[0,0];
for x:=0 to bmp.Height-1 do
  for y:=0 to bmp.Width-1 do
    if bmp.Canvas.pixels[x,y]=coriginal then
      bmp.Canvas.pixels[x,y]:=correct;

Result:=bmp;
end;

function BitmapToRTF(pict: TBitmap): string;
var
  bi, bb, rtf: string;
  bis, bbs: Cardinal;
  achar: ShortString;
  hexpict: string;
  I: Integer;
begin
  GetDIBSizes(pict.Handle, bis, bbs);
  SetLength(bi, bis);
  SetLength(bb, bbs);
  GetDIB(pict.Handle, pict.Palette, PChar(bi)^, PChar(bb)^);
  rtf := '{\rtf1 {\pict\dibitmap0 ';
  SetLength(hexpict, (Length(bb) + Length(bi)) * 2);
  I := 2;
  for bis := 1 to Length(bi) do
  begin
    achar := IntToHex(Integer(bi[bis]), 2);
    hexpict[I - 1] := achar[1];
    hexpict[I] := achar[2];
    Inc(I, 2);
  end;
  for bbs := 1 to Length(bb) do
  begin
    achar := IntToHex(Integer(bb[bbs]), 2);
    hexpict[I - 1] := achar[1];
    hexpict[I] := achar[2];
    Inc(I, 2);
  end;
  rtf := rtf + hexpict + ' }}';
  Result := rtf;
end;

procedure ScrollToEnd(ARichEdit: TRxRichEdit);
begin
ARichEdit.SelStart := ARichEdit.GetTextLen;
ARichEdit.Perform(EM_SCROLLCARET, 0, 0);
SendMessage(ARichEdit.Handle, WM_VSCROLL, SB_BOTTOM, 0);//NEW CODE 0.031
end;

function getrichpath(path:widestring):widestring;
begin
//'<file://C:\Users\C&A\Documents\Disk Explorer Professional 3>'
result:='<file://'+path+'>';
end;


procedure insertrichtextchat(rich:Trxrichedit;txt:widestring;imagelist:Timagelist;cl:Tcolor;username:widestring);
var
bmp:Tbitmap;
pre,word:widestring;
x,max:integer;
tojump:boolean;
smileid:integer;
c:Tcolor;
begin
if rich.Lines.Count=1000 then
  rich.Lines.Delete(0);

tojump:=false;

//if rich.AutoURLDetect=true then
//  txt:=changein(txt,'\','\\'); //0.037 CONVERSION FIX

max:=length(txt);

rich.SelStart:=100000000; //CARET START
rich.SelAttributes.Color:=cl;
rich.SelAttributes.Style:=rich.SelAttributes.Style-[fsBold];//0.044
  
if username='' then begin//ALL LINE IN BOLD
  rich.SelAttributes.Style:=rich.SelAttributes.Style+[fsBold];
  rich.RtfSelText:='{\rtf1\ansi\f0\pard ['+datetimetostr(now)+'] }';
  c:=cl;
end
else begin
  rich.RtfSelText:='{\rtf1\ansi\f0\pard ['+datetimetostr(now)+'] }';
  rich.SelStart:=100000000; //CARET START
  rich.SelAttributes.Color:=cl;
  rich.RtfSelText:='{\rtf1\ansi\f0\pard \b <'+widestringtoustring(username)+'> \b0  }';
  c:=clWindowText;
end;

for x:=1 to max do begin

  if tojump=true then
    tojump:=false
  else
  if x+1<=max then begin
    pre:=txt[x];
    pre:=pre+txt[x+1];

    smileid:=-1;
    if imagelist<>nil then
      smileid:=emojislist.IndexOf(wideuppercase(pre));

    if smileid<>-1 then begin //INSERT IMAGE
      tojump:=true;
      //INSERT WORD IF NOT EMPTY
      if word<>'' then begin
        rich.SelStart:=1000000000; //CARET START
        //COLOR?
        rich.SelAttributes.Color := c;
        rich.RtfSelText:='{\rtf1\ansi\f0\pard '+widestringtoustring(word)+' }';
        word:='';
      end;
      //INSERT IMAGE
      rich.SelStart:=1000000000; //CARET START
      bmp:=TBitmap.create;
      imagelist.GetBitmap(smileid,bmp);
      bitmapchangecolor(bmp,rich.Color);
      rich.RtfSelText:=BitmapToRTF(BMP);
      FreeAndNil(bmp);
    end
    else
      word:=word+txt[x];
  end
  else begin
    word:=word+txt[x];

  end;

end;

if word<>'' then begin
  rich.SelStart:=100000000; //CARET START
  //COLOR
  rich.SelAttributes.Color := c;
  rich.RtfSelText:='{\rtf1\ansi\f0\pard '+widestringtoustring(word)+' }';
end;

rich.Lines.Add('');
ScrollToEnd(rich);
end;

procedure removerichformat(rich:TTntRichEdit);
var
w:widestring;
i,l:longint;
begin
if rich.Tag=1 then
  exit;

rich.Tag:=1;

w:=rich.Text;
i:=rich.SelStart;
l:=rich.SelLength;

rich.text:='';
rich.text:=w;

rich.SelStart:=i;
rich.SelLength:=l;

rich.Tag:=0;
end;

procedure insertrichtext(rich:Trxrichedit;txt:widestring;cl:Tcolor);
var
bmp:Tbitmap;
pre,word:widestring;
x,max:integer;
tojump:boolean;
smileid:integer;
imagelist:TImageList;
begin
tojump:=false;
imagelist:=nil;
//if rich.AutoURLDetect=true then
//  txt:=changein(txt,'\','\\'); //0.037 CONVERSION FIX
rich.SelAttributes.style:=rich.SelAttributes.style-[fsbold];//0.044
max:=length(txt);

for x:=1 to max do begin

  if tojump=true then
    tojump:=false
  else
  if x+1<=max then begin
    pre:=txt[x];
    pre:=pre+txt[x+1];

    smileid:=-1;
    if imagelist<>nil then
      smileid:=emojislist.IndexOf(wideuppercase(pre));

    if smileid<>-1 then begin //INSERT IMAGE
      tojump:=true;
      //INSERT WORD IF NOT EMPTY
      if word<>'' then begin
        rich.SelStart:=1000000000; //CARET START
        //COLOR?
        rich.SelAttributes.Color := cl;
        rich.RtfSelText:='{\rtf1\ansi\f0\pard '+widestringtoustring(word)+' }';
        word:='';
      end;
      //INSERT IMAGE
      rich.SelStart:=1000000000; //CARET START
      bmp:=TBitmap.create;
      imagelist.GetBitmap(smileid,bmp);
      bitmapchangecolor(bmp,rich.Color);
      rich.RtfSelText:=BitmapToRTF(BMP);
      FreeAndNil(bmp);
    end
    else
      word:=word+txt[x];
  end
  else begin
    word:=word+txt[x];

  end;

end;

if word<>'' then begin
  rich.SelStart:=100000000; //CARET START
  //COLOR
  rich.SelAttributes.Color := cl;
  rich.RtfSelText:='{\rtf1\ansi\f0\pard '+widestringtoustring(word)+' }';
end;

rich.Lines.Add('');
end;

procedure Filteredit(Sender: TObject);
var
i : integer;
aux,aux2,cad : string;
begin
cad:='0123456789';   // Solo se admiten estos caracteres
aux2:='';
with (Sender as TTntedit) do
begin
  aux:=text;
  for i:=1 to length(aux) do
    if pos(aux[i],cad)>0 then
      aux2:=aux2+aux[i];

  try
    if text[1]='0' then
      aux2:='0';
  finally
    text:=aux2;
    SelStart:=length(aux2);
  end;
  //FIX CURSOR DISSAPEAR
  sendmessage((Sender as TTntedit).handle, WM_SETCURSOR, 0, 0);
end;

end;

function OS_IsWindows8: Boolean;
begin
 Result:= (Win32MajorVersion = 6) AND (Win32MinorVersion>= 2);  //OR 8.1
end;

function checkpathbar(path:widestring):widestring;
var
sep:string;
begin
sep:='\';
if Length(path)>0 then begin

  if gettokencount(path,'/')>1 then //NET PATH
    sep:='/';

  if path[Length(path)]<>sep then
    path:=path+sep;
end;

Result:=path;
end;

function xmlparser(str:widestring):widestring;
begin
{
&lt; represents "<"
&gt; represents ">"
&amp; represents "&"
&apos; represents '
&quot; represents "
}

str:=Changein(str,'&','&amp;');//ALWAYS FIRST
str:=Changein(str,'<','&lt;');
str:=Changein(str,'>','&gt;');
str:=Changein(str,'''','&apos;');
str:=Changein(str,'"','&quot;');

result:=str;
end;

procedure clearrecords;
var
x:integer;
begin
for x:=0 to recsets.Count-1 do
  TObject(recsets[x]).Free;

recsets.Clear;

for x:=0 to recroms.Count-1 do
  TObject(recroms[x]).Free;

recroms.clear;

for x:=0 to reccrcs.Count-1 do
  TObject(reccrcs[x]).Free;

reccrcs.clear;

for x:=0 to recmd5s.Count-1 do
  TObject(recmd5s[x]).Free;

recmd5s.clear;

for x:=0 to recsha1s.Count-1 do
  TObject(recsha1s[x]).Free;

recsha1s.clear;
end;

procedure setwiderecord(field:Tfield;value:widestring);
begin
field.AsVariant:=value;
end;

function getwiderecord(field:Tfield):widestring;
begin
Result:='';
if field.AsVariant<>null then
  result:=field.AsVariant;
end;

procedure makeexception;
begin
strtoint('A');
end;

procedure TrimAppMemorySize;
//var
//MainHandle : THandle;
begin
{Used in
Showprocessingwindow
Hideprocessingwindow
Loadselectedprofiles1Click start
Scan end
Importation end
Timer of application launch
End of application

try
  MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
  SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
  CloseHandle(MainHandle) ;
except
end;
}
end;

function isunicodefilename(path:widestring):boolean;
begin
result:=true;
if UTF8Encode(path)=path then
  result:=false
end;

function widestringtoustring(text:widestring):ansistring;
var
x,max,i:integer;
res:ansistring;
s:ansistring;
begin
max:=Length(text);

for x:=1 to max do begin

  s:=UTF8Encode(text[x]);

  if s='\' then
    res:=res+'\\'
  else
  if s<>text[x] then begin
    i:=Ord(text[x]);
    res:=res+'\u'+inttostr(i)+'?'
  end
  else
    res:=res+s;

end;

//0.038 
res:=changein(res,#13#10,'\line ');//0.037 line jump fix
res:=changein(res,'{','\{');
res:=changein(res,'}','\}');

Result:=res;
end;

procedure PrintControl(AControl :TWinControl;AOut:TBitmap);
var
  DC: HDC;
begin
  if not Assigned(AOut) then Exit;
  if not Assigned(AControl) then Exit;

  DC :=GetWindowDC(AControl.Handle);
  AOut.Width  :=AControl.Width;
  AOut.Height :=AControl.Height;
  with AOut do
  BitBlt(
    Canvas.Handle, 0, 0, Width, Height, DC, 0, 0, SrcCopy
  );

  ReleaseDC(AControl.Handle, DC);
end;

Function MouseButtonIsDown(Button:TMousebutton):Boolean;
var Swap :Boolean;
    State:short;
begin
State:=0;
Swap:= GetSystemMetrics(SM_SWAPBUTTON)<>0;
if Swap then
   case button of
   mbLeft :State:=getAsyncKeystate(VK_RBUTTON);
   mbRight:State:=getAsyncKeystate(VK_LBUTTON);
   end
else
   case button of
   mbLeft :State:=getAsyncKeystate(VK_LBUTTON);
   mbRight:State:=getAsyncKeystate(VK_RBUTTON);
   end;
Result:= (State < 0);
end;

function Findexefromextension(const aFileName: widestring): widestring;
var
  Buffer: array[0..WINDOWS.MAX_PATH] of wideChar;
begin
  Result := '';
  FillChar(Buffer, SizeOf(Buffer), #0);
  if (SHELLAPI.FindExecutablew(Pwidechar(aFileName), nil, Buffer) > 32) then
    Result := Buffer;
end;

procedure KillProcess(hWindowHandle: HWND);
var
  hprocessID: INTEGER;
  processHandle: THandle;
  DWResult: DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0,
    SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);

  if isWindow(hWindowHandle) then
  begin
    // PostMessage(hWindowHandle, WM_QUIT, 0, 0);

    { Get the process identifier for the window}
    GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then
    begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,
        False, hprocessID);
      if processHandle <> 0 then
      begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(ProcessHandle);
      end;
    end;
  end;
end;

function IsConnectedtointernet: boolean;
const
  // local system uses a modem to connect to the Internet.
  INTERNET_CONNECTION_MODEM      = 1;
  // local system uses a local area network to connect to the Internet.
  INTERNET_CONNECTION_LAN        = 2;
  // local system uses a proxy server to connect to the Internet.
  INTERNET_CONNECTION_PROXY      = 4;
  // local system's modem is busy with a non-Internet connection.
  INTERNET_CONNECTION_MODEM_BUSY = 8;

var
  dwConnectionTypes : DWORD;
begin
Result:=true;
try
  dwConnectionTypes := INTERNET_CONNECTION_MODEM +
                       INTERNET_CONNECTION_LAN +
                       INTERNET_CONNECTION_PROXY;
  Result := InternetGetConnectedState(@dwConnectionTypes,0);
except
end;

end;

function checkvalidinternetport(port,default:integer):integer;
begin
if (port<=0) or (port>65535) then
  port:=default;

result:=port;
end;

Function GetUserFromWindows: widestring;
const
unknow='Unk';
Var
   UserName : widestring;
   UserNameLen : Dword;
Begin
   UserNameLen := 255;
   SetLength(userName, UserNameLen) ;

   If GetUserNamew(PwideChar(UserName), UserNameLen) Then
     Result := Copy(UserName,1,UserNameLen - 1)
   Else
     Result := unknow;

   if result='' then
    result:=unknow
   else
   if Length(result)>25 then
    result:=copy(result,1,25);
    
End;


function Getparentform(AComponent: TComponent): TCustomForm;
var
  LOwner: TComponent;
begin
  LOwner:= AComponent;
  while  (LOwner <> nil) and not (LOwner is TCustomForm) do
    LOwner := LOwner.Owner;

  Result := (LOwner as Tform);
end;

function getvaliddestination(path:widestring):widestring;
var
cont:longint;
fname,respath:widestring;
begin
cont:=1;
respath:=path;
respath:=changein(respath,'?','-'); //UNICODE SOLUTION
fname:=filewithoutext(path);

try

  while FileExists2(respath) OR WideDirectoryexists(respath) do begin

    respath:=wideExtractFilePath(path)+fname+'('+inttostr(cont)+')'+wideExtractFileExt(path);
    respath:=changein(respath,'?','-'); //UNICODE SOLUTION

    if (cont=high(cont)) OR (Length(respath)>255) then //VERY DIFFICULT TO GET INSIDE HERE
      makeexception;

    cont:=cont+1;

  end;

except
  respath:='';
end;

Result:=respath;
end;

{procedure RunAndWaitShell(exe,args:ansistring;visibility:integer;out_:boolean;emulator:boolean);
var
Info:TShellExecuteInfo;
pInfo:PShellExecuteInfo;
exitCode:DWord;
f:textfile;
aux,dest:ansistring;
writefile:boolean;
retrycount:integer;
facename:ansistring;
facenumber:integer;
//h:hwnd;
begin
writefile:=false;
retrycount:=0;

pInfo:=@Info;

aux:=exe;

if emulator=false then
  dest:=tempdirectoryresources+'rml.bat'
else
  dest:=tempdirectoryresources+'emu.bat';

if args<>'' then
  aux:=aux+' '+args;

if emulator=false then
  if out_=true then
    aux:=aux+' > "'+GetShortFileName(mameoutpath+'"');

while writefile=false do begin //0.025 RANDOM WRITE PROBLEM BY .BAT AND ANTIVIRUS? RETRY 10 TIMES

  try
    assignfile(f,dest);
    Rewrite(f);
    writefile:=true;
    break;
  except
    sleep(250);//WAIT TIME
    try
      closefile(f);
    except
    end;
  end;

  retrycount:=retrycount+1;

  if retrycount=10 then
    makeexception;
end;

aux:=changein(aux,'%','%%');//IMPORTANT FIX PARSER ANULATION

writeln(f,'chcp 65001'); //SET UNICODE
writeln(f,'cls');
Writeln(f,aux);

closefile(f);

//showmessage(aux);

exe:=dest;
args:='';

With Info do begin
  cbSize:=SizeOf(Info);
  fMask:=SEE_MASK_NOCLOSEPROCESS;

  lpVerb:=nil;
  lpFile:=PChar(exe);

  lpParameters:=Pchar(args+#0);
  lpDirectory:=nil;

  if visibility=0 then
    nShow:=visibility
  else
    nshow:=SW_MINIMIZE; //IF visible always minimized

  hInstApp:=0;
end;

getconsolefont(facename,facenumber);//save console font
if (facename<>'Lucida Console') then
  setconsolefont('Lucida Console',54);//FIXES Win8 crash problem with other fonts

ShellExecuteEx(pInfo);

//if facename<>'' then
//  setconsolefont(facename,facenumber);//Recover old config

if emulator=false then begin
  repeat
    exitCode := WaitForSingleObject(Info.hProcess,100);
    if onathread=false then begin
      application.processmessages;
      sleep(10);
    end;
  until (exitCode <> WAIT_TIMEOUT);
end
else //NO WAIT IN EMULATORS
  WaitForSingleObject(Info.hProcess,100);

deletefile2(dest);
end;    }

//NEW METHOD TGPTEXTFILE
procedure RunAndWaitShell(exe,args:ansistring;visibility:integer;out_:boolean;emulator:boolean);
var
Info:TShellExecuteInfo;
pInfo:PShellExecuteInfo;
exitCode:DWord;
aux,dest,emuutf8:ansistring;
facename:ansistring;
facenumber:integer;
begin

{USED FOR
  EMULATOR LAUNCH
  COMPRESS
  UNCOMPRESS
  GET DAT FROM MAME EXE
  GET CHD INFO
  TORRENTZIP AND TORRENT7ZIP
}

aux:=exe;

if emulator=false then
  dest:=tempdirectoryresources+'rml.bat'
else
  dest:=tempdirectoryresources+'emu.bat';

if args<>'' then
  aux:=aux+' '+args;

if emulator=false then begin
  if out_=true then
    aux:=aux+' > "'+AnsiToUtf8(GetShortFileName(mameoutpath)+'"');
end
else
  emuutf8:=writelist.strings[0];

deletefile2(dest);

args:='';
writelist.Clear;

writelist.Add('chcp 65001');
writelist.Add('');

if emulator=true then //SET CURRENT PATH     //FIX % PATH
  writelist.Add('CD /d "'+UTF8Encode(changein(UTF8Decode(emuutf8),'%','%%'))+'"');

writelist.Add('cls');         //FIX % PATH
//writeln(f,changein(aux,'%','%%')); <---- BUG CHINESSE
if emulator=true then
  writelist.Add(UTF8Encode(changein(UTF8Decode(aux),'%','%%')))
else
  writelist.Add(aux);
  
writelist.SaveToFile(dest);

//wideshowmessage(UTF8Decode(exe));

if (Win32MajorVersion=5) OR ((Win32MajorVersion=6) AND (Win32MinorVersion=0)) OR (testmode=true) then begin
  args:='/c '+extractfilename(dest);//BAT PATH ALWAYS ANSI
  exe:='"'+cmdpatchedpath+'"';  //ALWAYS ANSI
end
else
  exe:=dest;

//BROKING CMD ???
getconsolefont(facename,facenumber);//save console font
if (facename<>'Lucida Console') then
  setconsolefont('Lucida Console',54);//FIXES Win8 crash problem with other fonts

//if facename<>'' then
//  setconsolefont(facename,facenumber);//Recover old config

pInfo:=@Info;

With Info do begin
    cbSize:=SizeOf(Info);
    fMask:=SEE_MASK_NOCLOSEPROCESS;

    lpVerb:=nil;
    lpFile:=Pchar(exe);

    lpParameters:=Pchar(args+#0);
    lpDirectory:=nil;

    if emulator=false then
      lpDirectory:=Pchar(tempdirectoryresources); //0.037 FIXES FOR WORKING WITH XP

    if visibility=0 then
      nShow:=visibility
    else
      nshow:=SW_MINIMIZE; //IF visible always minimized

    hInstApp:=0;
end;

ShellExecuteEx(pInfo);

if emulator=false then begin

  repeat
    exitCode := WaitForSingleObject(Info.hProcess,100);
    if onathread=false then begin
      application.processmessages;
      sleep(10);
    end;
  until (exitCode <> WAIT_TIMEOUT);

  CloseHandle(info.hProcess);

  deletefile2(dest);
end
else begin//NO WAIT IN EMULATORS
  application.ProcessMessages;
  WaitForSingleObject(Info.hProcess,1000);
end;

end;

function currtohex(c:currency):string;
var
aux:string;
begin
aux:=CurrToStr(c);
aux:=gettoken(aux,decimalseparator,1);
result:=IntToHex(StrToInt64(aux),0);
end;

function getbackuppathofid(id:Integer):widestring;
var
path:widestring;
begin

if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([id,'B']),[])=true then begin
  path:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
  path:=checkpathbar(path);
end
else begin
  path:=defbackuppath;
  Datamodule1.TDirectories.insert;
  setwiderecord(Datamodule1.TDirectories.fieldbyname('Path'),path);
  Datamodule1.TDirectories.fieldbyname('Profile').asinteger:=id;
  Datamodule1.TDirectories.fieldbyname('Type').AsString:='B';
  Datamodule1.TDirectories.fieldbyname('Compression').asinteger:=0;
  Datamodule1.TDirectories.post;
end;

result:=path;
end;

function getromspathofid(id:integer):widestring;
begin
Result:='';
if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([id,'0']),[])=true then
  Result:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
end;

function getsamplespathofid(id:integer):widestring;
begin
Result:='';
if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([id,'1']),[])=true then
  Result:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
end;

function getchdspathofid(id:integer):widestring;
begin
Result:='';
if Datamodule1.TDirectories.Locate('Profile;Type',VarArrayOf([id,'2']),[])=true then
  Result:=getwiderecord(Datamodule1.TDirectories.fieldbyname('Path'));
end;

function FileExists2(FileName: widestring): boolean;
var
Handle: THandle;
FindData: TWin32FindDataw;
begin

  Handle := FindFirstFilew(PwideChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
    begin
      Windows.FindClose(Handle);
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)=0 then
        Result:=true
      else
        Result:=false;
    end
  else Result:=false;
end;

function copyfile2(origin,dest:widestring):boolean;
var
res:boolean;
begin
res:=false;

//0.028
if WideFileExists(origin)=false then begin
  Result:=false;
  exit;
end;

if FileExists2(dest) then
  if wideuppercase(origin)=wideuppercase(dest) then begin //FIX SAME ORIGIN AND DEST
    result:=true;
    exit;
  end
  else
    deletefile2(dest);

try
  CopyFilew(Pwidechar(origin),Pwidechar(dest),true);
  res:=true;
except
end;

Result:=res;
end;

procedure TurboCopyFile(const SourceFile,DestinationFile: widestring);
type
(* define an array of 4096 bytes which holds the bytes *)
TurboBuffer = array[1..4096] of Byte;
const
(* we need to set the size of the buffer in a constant *)
szBuffer = sizeof(TurboBuffer);
var
(* File streams with which we work *)
InStream,OutStream: TTntFileStream;
(* we need this to store a logical operation's result *)
CanCopy: Boolean;
(* holds the number of bytes left when
InStream.Size -InStream.Position < 4096 bytes *)
BytesLeft: Integer;
(* the Buffer almighty *)
Buffer: TurboBuffer;
begin

  (* Open the source file so we can read it's bytes *)
  InStream := TTntFileStream.Create(SourceFile, fmOpenRead);
  (* create a new file to the desired destination *)
  OutStream := TTntFileStream.Create(DestinationFile, fmCreate);

  (* this is the operation I was talking about in the
     variable section, this checks if we can read a
     full buffer(4096 bytes) *)
  CanCopy :=
    (InStream.Size > InStream.Position) and
    ((InStream.Size -InStream.Position) >= szBuffer);

  (* this ensures that the progress bar is being painted *)
  application.processmessages;

  (* loop while we CanCopy *)
  while CanCopy do begin
    (* this ensures that the progress bar is being painted *)
    application.processmessages;         //0.032
    (* read 4096 bytes from source file *)
    InStream.ReadBuffer(Buffer, szBuffer);
    (* then write it to destination file *)
    OutStream.WriteBuffer(Buffer, szBuffer);

    CanCopy :=
      (InStream.Size > InStream.Position) and
      ((InStream.Size -InStream.Position) >= szBuffer);
  end;

  (* store the number of bytes that is less than 4096 into
     a local variable *)
  BytesLeft := InStream.Size -InStream.Position;

  (* do we have some bytes left ? we don't care how many,
     we just know it's less than 4096 bytes *)
  if BytesLeft > 0 then begin
    (* surprise, or not we have some bytes left,
       read them all into the buffer *)
    InStream.ReadBuffer(Buffer, BytesLeft);
    (* write them to destination file *)
    OutStream.WriteBuffer(Buffer, BytesLeft);
  end;

  (* free the memory *)
  FreeAndNil(InStream);
  FreeAndNil(OutStream);

end;

function deletefile2(path:widestring):boolean;
var
res:boolean;
begin
res:=false;

try

  if FileExists2(path) then begin

    WideFileSetAttr(path,faArchive);
    WideDeleteFile(path);

    if not fileexists2(path) then
      res:=true;

  end;

except
end;

Result:=res;
end;

function movefile2(org,dest:widestring):boolean;
var
res:boolean;
begin
res:=false;
try
  if FileExists2(dest) then
    if WideUpperCase(org)=wideuppercase(dest) then begin
      res:=true;
    end
    else
      DeleteFile2(dest);//Delete destination to add origin

  if res=false then
    res:=MoveFileW(pwidechar(org),pwidechar(dest));
except
end;

Result:=res;
end;

function sizeoffile(f: widestring): int64;
var
//FileHandle: THandle;
//FileSize: LongWord;
//siz:int64;
//sr : TSearchRec;
fHandle: DWORD;
begin   //OLD CODE
{siz:=-1;

if FindFirst(f, faAnyFile, sr ) = 0 then
  siz := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow);

FindClose(sr) ;

Result:=siz; }
fHandle := CreateFilew(PwideChar(f), 0, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

if fHandle = INVALID_HANDLE_VALUE then
  Result := -1
else try
  Int64Rec(Result).Lo := GetFileSize(fHandle, @Int64Rec(Result).Hi);
finally
  CloseHandle(fHandle);
end;

end;

function FileInUse(FileName: widestring): Boolean;
var
hFileRes: HFILE;
attr:cardinal;
begin

  Result := False;

  if not FileExists2(FileName) then exit;

  attr:=GetFileAttributesw(Pwidechar(filename)); //GET ATTRIBUTES

  WideFileSetAttr(filename,faArchive);

  hFileRes := CreateFilew(PwideChar(FileName),
                                    GENERIC_READ or GENERIC_WRITE,
                                    0,
                                    nil,
                                    OPEN_EXISTING,
                                    FILE_ATTRIBUTE_NORMAL,
                                    0);
  Result := (hFileRes = INVALID_HANDLE_VALUE);

  if not Result then
    CloseHandle(hFileRes);

  WideFileSetAttr(filename,attr);//RESTORE ATTRIBUTES
end;

Function GetFormsCount: Integer;
begin
Result := Screen.FormCount-1;//NORMAL IS 2
end;

function defrequestsfilename():widestring;
begin
Result:=checkpathbar(WideExtractfilepath(Tntapplication.ExeName))+'Requests.lst';
end;

function DesktopSize: TRect;
var
  r : TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
  Result := r;
end;

procedure myshowform(F:Tform;modal:boolean);
var
formname:ansistring;
x,monitor:integer;
fake:Timage;
setcenter:boolean;
//cont:Twincontrol;
begin
TrimAppMemorySize;
application.Restore; //IF MINIMIZED
setcenter:=true;
monitor:=0;

if Win32MajorVersion>=6 then //0.028 FIX ANIMATION EFFECT ON SHOW FORM FOR VISTA AND LATER
  SendMessage(F.Handle,CM_RECREATEWND,0,0); //BTW LOS TREEVIEW WIN7STYLES MUST BE READDED

if modal=true then begin

  //MUST LOCK THE LAST FORM
  //MUST FIX NON MODAL FORMS WHEN IS HIDDEN ON TRAY
  if activeformlist=nil then //0.038 ERROR WHEN CLOSE ROMULUS
    exit;

  if activeformlist.Count>0 then
    formname:=activeformlist.Strings[activeformlist.Count-1];

  if formname='Flog' then
    if activeformlist.Count>1 then
      formname:=activeformlist.strings[activeformlist.count-2]
    else
      formname:='';

  if formname='' then
    formname:='Fmain';

  //DISSABLE PARENT FORM
  for x:=0 to screen.FormCount-1 do
      if screen.Forms[x].Name=formname then begin

        //showmessage(formname);
        //0.040
        //cont:=screen.Forms[x].ActiveControl;

        if (F.Name='Fscan') then begin
          if (oldscanleft<>-1) AND (oldscantop<>-1) then
            setcenter:=false;
        end;

        if setcenter=true then //CENTER IN LAST ACTIVE FORM
          try
            monitor:=screen.Forms[x].Monitor.MonitorNum;
          except
          end;

        //BUG FIX MOUSE OVER SPEEDBUTTON
        LockWindowUpdate(screen.Forms[x].handle);

        fake:=((screen.Forms[x]).FindComponent('FAKEIMG') as Timage);

        if fake=nil then begin
          fake:=TImage.Create(screen.Forms[x]);
          fake.Parent:=(screen.Forms[x]);
          fake.Name:='FAKEIMG';
          fake.Transparent:=false;
        end;

        fake.Align:=alclient;
        fake.BringToFront;
        fake.Visible:=true;

        LockWindowUpdate(0);
        screen.Forms[x].Repaint;

        break;
      end;

  F.AlphaBlendValue:=0;

  F.Enabled:=true;//FIX
  EnableWindow(F.handle,true);//FIX

  application.Restore;//IF MINIMIZED

  if setcenter=true then begin //0.044 FIX FINALLY CENTER POSITION
    try
      F.Top:= ((screen.Monitors[monitor].BoundsRect.Top+screen.Monitors[monitor].BoundsRect.Bottom) div 2)-(F.Height div 2);
      F.left:=((screen.Monitors[monitor].BoundsRect.Left+screen.Monitors[monitor].BoundsRect.right) div 2)-(F.width div 2);
    except
      F.Position:=poScreenCenter;
    end;
  end;

  f.Showmodal;

  //ENABLE PARENT FORM
  for x:=0 to screen.FormCount-1 do
      if screen.Forms[x].name=formname then begin
        screen.Forms[x].enabled:=true;

        //BUG FIX MOUSE OVER SPEEDBUTTON
        LockWindowUpdate(screen.Forms[x].handle);

        fake:=((screen.Forms[x]).FindComponent('FAKEIMG') as Timage);
        if fake<>nil then
          fake.free;

        LockWindowUpdate(0);

        try
        //if cont<>nil then
        //  screen.forms[x].ActiveControl:=cont;
        except
        end;

        screen.Forms[x].Repaint;

        break;
      end;

end
else begin
  f.Show;
end;

end;

procedure stablishfocus(Obj:Tobject);
var
exception:boolean;
begin
exception:=false;

if obj=nil then
  exit;
//GetParentForm(Obj as TTntedit).ActiveControl:=(Obj as TTntedit);

try

if (Obj is TTntedit) then
  GetParentForm(Obj as TTntedit).ActiveControl:=(Obj as TTntedit)
else
if (Obj is Ttnttreeview) then
  GetParentForm(Obj as Ttnttreeview).ActiveControl:=(Obj as Ttnttreeview)
else
if (Obj is Ttntlistview) then begin
  GetParentForm(Obj as Ttntlistview).ActiveControl:=(Obj as Ttntlistview)
end
else
if (Obj is TVirtualStringTree) then begin
  GetParentForm(Obj as TVirtualStringTree).ActiveControl:=(Obj as TVirtualStringTree)
end
else
if (Obj is Ttntcombobox) then
  GetParentForm(Obj as Ttntcombobox).ActiveControl:=(Obj as Ttntcombobox)
else
if (Obj is TTntbitbtn) then
  GetParentForm(Obj as TTntbitbtn).ActiveControl:=(Obj as TTntbitbtn);


except
  exception:=true;
end;

//CHANGED 0.040
{
try

if (Obj is TTntedit) then
  (Obj as TTntedit).SetFocus
else
if (Obj is Ttnttreeview) then
  (Obj as Ttnttreeview).SetFocus
else
if (Obj is Ttntlistview) then begin
  (Obj as Ttntlistview).SetFocus;
end
else
if (Obj is TVirtualStringTree) then begin
  (Obj as TVirtualStringTree).SetFocus;
end
else
if (Obj is Ttntcombobox) then
  (Obj as TTntcombobox).SetFocus
else
if (Obj is TTntbitbtn) then
  (Obj as TTntbitbtn).setfocus;


except
  exception:=true;
end;    }

if exception=true then
  makeexception;
end;

function UnixTime(DateTime: TDateTime): longint;
begin
result := Trunc( (DateTime -EncodeDate(1970,1,1)) * SecsPerDay);
end;

function UnixDateTimeToDelphiDateTime(UnixDateTime: longint): TDateTime;
begin
result := EncodeDate(1970, 1, 1) +( UnixDateTime / SecsPerDay );
end;

function widefileage2(filename:widestring):longint;
var
d:Tdatetime;
begin
result:=-1;
try
  WideFileAge(filename,d);
  result:=UnixTime(d);
except
end;
end;

function getcpunumcores():cardinal;
var
Info: SYSTEM_INFO;
res:cardinal;
begin
res:=1;
GetSystemInfo(Info);
try
  res:= Info.dwNumberOfProcessors;
except
end;

if res<=0 then
  res:=1;

Result:=res;
end;

function formexists(formname:ansistring):boolean;
var
x:integer;
res:boolean;
begin
res:=false;
formname:=Wideuppercase(formname);

for x:=0 to screen.FormCount-1 do
  if wideuppercase(screen.Forms[x].Name)=formname then begin
    res:=true;
    break;
  end;

Result:=res;
end;

function RunAsAdmin(const Handle: Hwnd; const Path, Params: widestring): Boolean;
var
  sei: TShellExecuteInfoW;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(sei);
  sei.Wnd := Handle;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := 'runas';
  sei.lpFile := PwideChar(Path);
  sei.lpParameters := PwideChar(Params);
  sei.nShow := SW_SHOWNORMAL;
  Result := ShellExecuteexw(@sei);
end;

function defuseragent():ansistring;
begin                                     //0.026 get current win version
//Result:='Mozilla/5.0 (Windows NT '+inttostr(Win32MajorVersion)+'.'+inttostr(Win32MinorVersion)+'; Trident/7.0; rv:11.0) like Gecko';
//CHANGED IN 0.049
Result:='Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0';
end;

function defpagecountinextent(): integer;
begin
Result:=16;
end;

function defpagesize(): integer;
begin
Result:=64000;
end;

function defmaxconnections():integer;
begin
Result:=500;
end;

function defserverport():integer;
begin
Result:=10001;
end;

function defcommunitydownfolder():widestring;
var
res:widestring;
begin
res:=checkpathbar(WideExtractfilepath(TntApplication.ExeName))+'downloads\';
Result:=res;
end;

//- END GET EXE FROM A HANDLE


function IsNTFS(AFileName : widestring) : boolean;
var
fso, drv : OleVariant;
res:boolean;
begin
res := False;
try
  fso := CreateOleObject('Scripting.FileSystemObject');
  drv := fso.GetDrive(fso.GetDriveName(AFileName));                         //0.034
  if (drv.FileSystem = 'NTFS') OR (drv.FileSystem = 'exFAT') OR (drv.Filesystem= 'EXFS') then
    res := True;
except
end;
result:=res;
end;

function createdummyfile(path:ansistring;space:int64):boolean;
var
f:textfile;
res:boolean;
mov:int64;
begin
res:=true;
mov:=0;

try

  assignfile(f,path);
  Rewrite(f);

  While mov<space do begin
    Write(f,'0');
    mov:=mov+1;
  end;

except
  res:=false;
end;

try
  closefile(f);
except
end;

Result:=res;

end;

function IsUserAdmin : boolean;
const CAdminSia : TSidIdentifierAuthority = (value: (0, 0, 0, 0, 0, 5));
var
sid : PSid;
ctm : function (token: dword; sid: pointer; var isMember: bool) : bool; stdcall;
b1  : bool;
res:boolean;
begin
res:= false;
try
  ctm := GetProcAddress(LoadLibrary('advapi32.dll'), 'CheckTokenMembership');
  if (@ctm <> nil) and AllocateAndInitializeSid(CAdminSia, 2, $20, $220, 0, 0, 0, 0, 0, 0,sid) then begin
    res:= ctm(0, sid, b1) and b1;
    FreeSid(sid);
  end;
except
end;

result:=res;
end;

function isanexefile(path:widestring):boolean;
var
BinaryType: DWORD;
begin
Result:=GetBinaryTypew(PwideChar(path), Binarytype);
end;

function bitswapbin (value:string):string;
var
aux:char;
begin
aux:=value[1];
value[1]:=value[8];
value[8]:=aux;
aux:=value[2];
value[2]:=value[7];
value[7]:=aux;
aux:=value[3];
value[3]:=value[6];
value[6]:=aux;
aux:=value[4];
value[4]:=value[5];
value[5]:=aux;

Result:=value;
end;

function BinToInt(Value: string): Integer;
var
  i, iValueSize: Integer;
begin
  Result := 0;
  iValueSize := Length(Value);
  for i := iValueSize downto 1 do
    if Value[i] = '1' then Result := Result + (1 shl (iValueSize - i));
end;

function IntToBin(Value: Longint; Digits: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := Digits downto 0 do
    if Value and (1 shl i) <> 0 then
      Result := Result + '1'
  else
    Result := Result + '0';
end;

function Changein(Instr, this, forthis: widestring): widestring;
var
aPos: Integer;
begin
aPos := Pos(this, Instr);
Result:= '';
while (aPos <> 0) do begin
  Result := Result + Copy(Instr, 1, aPos-1) + forthis;
  Delete(Instr, 1, aPos + Length(This)-1);
  aPos := Pos(This, Instr);
end;
  Result := Result+Instr;
end;

function GetToken(str, Separator: widestring; Token: Integer): widestring;
var
  Position: Integer;
begin
  while Token > 1 do begin
    Delete(str, 1, Pos(Separator,str)+Length(Separator)-1);
    Dec(Token);
  end;
  Position:= Pos(Separator, str);
  if Position = 0
    then  Result:= str
    else  Result:= Copy(str, 1, Position-1);
end;

function GetTokenCount(str, Separator: widestring): Integer;
var
   Position: Integer;
begin
  if str <> '' then begin
    Position:= Pos(Separator, str);
    Result:= 1;
    while Position <> 0 do begin
      Inc(Result);
      Delete(str, 1, Position+Length(Separator)-1);
      Position:= Pos(Separator, str);
    end;
  end else
    Result:=0;
end;

//HEADERS--------------------------------------------------------------------------

function ispowerof2(num:int64):boolean;
var
test:int64;
res:boolean;
begin
res:=false;
test:=2;
if num=1 then
  res:=true
else
while test<num do
  test:=test*2;

if test=num then
  res:=true;

Result:=res;
end;

function resizefile(Filenamein,Filenameout:widestring;startsize,newsize:int64;operation:integer):boolean;
var
fin,fout:TTntFileStream;
move:int64;
maxpos:int64;
empty:byte;
res:boolean;
readed:integer;
bufferread:array [0..4] of byte;
bufferwrite:array [0..4] of byte;
begin
res:=true;
fin := TTntFileStream.Create(filenamein, fmOpenRead or fmShareDenyWrite);
fout := TTntFileStream.Create(filenameout, fmCreate or fmShareExclusive);

try
  if operation=3 then
    if fin.size mod 4 <> 0 then //WORDSWAP RULE
      makeexception;

  fin.Position:=startsize;
  maxpos:=newsize;

  if newsize>fin.size then
    maxpos:=fin.Size;

  startsize:=startsize+1;

  move:=startsize+1;

  case operation of
    0:begin //NORMAL
      while move<>maxpos+2 do begin //SEEMS FINE BUT CAN INCREASE SPEED
        readed:=fin.Read(bufferread,4);
        fout.Write(bufferread,readed);
        move:=move+readed;
      end;
    end;
    1:begin //BITSWAP BYTE = INT = BIN = SWAP 8 VALUES = BIN = INT
      while move<>maxpos+2 do begin //SEEMS FINE BUT CAN INCREASE SPEED
        fin.Read(bufferread,1);
        bufferread[0]:=bintoint(bitswapbin(inttobin(bufferread[0],8)));
        fout.Write(bufferread,1);
        move:=move+1;
      end;
      end;
    2:begin //BYTESWAP 01|02 > 02|01
      while move<>maxpos+2 do begin //SEEMS OK
        readed:=fin.Read(bufferread,2);
        if readed=2 then begin
          bufferwrite[0]:=bufferread[1];
          bufferwrite[1]:=bufferread[0];
          fout.Write(bufferwrite,readed);
        end
        else
          fout.Write(bufferread,readed);

        move:=move+readed;
      end;
    end;
    3:begin  //WORDSWAP 01|02|03|04 > 04|03|02|01

      while move<>maxpos+2 do begin //SEEMS OK

        //NOT CHECK SIZE BECAUSE ALREADY CHECKED AS MOD 4
        readed:=fin.Read(bufferread,4);
        bufferwrite[0]:=bufferread[3];
        bufferwrite[1]:=bufferread[2];
        bufferwrite[2]:=bufferread[1];
        bufferwrite[3]:=bufferread[0];

        fout.Write(bufferwrite,readed);

        move:=move+readed;
      end;
    end;
  end;

  if newsize>fin.size then begin  //TO STUDY
    maxpos:=newsize-fin.Size; //Difference size fill "overdump"
    empty:=0;
    move:=1;
    while move<>maxpos+1 do begin //SEEMS FINE CAN INCREASE SPEED
      fout.Write(empty,1);
      move:=move+1;
    end;
    fout.Position:=fout.Size-1;//Correct last byte
    empty:=0;
    fout.Write(empty,1);

  end;
except
  res:=false;
end;

fout.free;

fin.free;

Result:=res;
end;

function applyheader(filename:widestring;Rules:Tabstable;Test:Tabstable):widestring;
var
fin:TTntFileStream;
//posinitial,siz:ansistring;
startpos,endpos:int64;
outfilevalue:ansistring;
x,z,readcount,readnow,readed:integer;
buffer:array[0..3] of byte;
userule:boolean;
aux,aux2,value:ansistring;
res,outfilename:widestring;
b:boolean;
begin
{
<RULE>

  START_OFFSET (DEFAULT 0)
  END_OFFSET (DEFAULT EOF)

  OPERATION
    NONE(DEFAULT)
    BITESWAP
    WORDSWAP
    BITSWAP

<TEST>
  * = REQUIRED

  DATA -> OFFSET(DEFAULT = 0), VALUE*, RESULT(DEFAULT = TRUE)
  BOOLEAN -> [OR, XOR, AND]*, OFFSET(DEFAULT = 0), MASK*, VALUE*, RESULT(DEFAULT = TRUE)  * MASK AND SIZE = SAME LENGTH
  FILE -> SIZE*(NUM OR PO2), RESULT(DEFAULT = TRUE), OPERATOR [EQUAL(DEFAULT), LESS, GREATER]

*
PO2=Factorial de 2 [1,2,4,8,16,32...]
}
res:='';
outfilevalue:='';
Rules.first;

try //0.032

fin := TTntFileStream.Create(filename, fmOpenRead or fmShareDenyNone);

for x:=0 to Rules.RecordCount-1 do begin

  userule:=true;

  try

    if Test.Locate('Rule',Rules.fieldbyname('ID').asinteger,[]) then
      while not Test.Eof do begin

        if Test.FieldByName('Rule').asinteger<>Rules.fieldbyname('ID').asinteger then
          break;

        //Check tests
        case Test.FieldByName('Test').asinteger of
          1:begin //DATA TEST

            aux:=Test.fieldbyname('OFFSET_SIZE').asstring;
            aux2:=Test.fieldbyname('VALUE').asstring; //ALREADY WITH SEPARATORS

            readcount:=length(aux2) div 2;

            if aux='EOF' then //UNKNOW
              fin.Seek(readcount*-1,soFromEnd)//GET LAS DATA INFO
            else
            if aux[1]='-' then begin //SEEMS OK
              aux:=GetToken(aux,'-',gettokencount(aux,'-'));
              fin.Seek(strtoint('-$'+aux),soFromEnd);
            end
            else //OK
              fin.Seek(strtoint('$'+aux),soFromBeginning);

            readed:=0;
            aux:='';

            while readed<readcount do begin  //OK

              readnow:=fin.Read(buffer, sizeof(buffer));

              if readnow=0 then
                break;

              readed:=readed+readnow;

              for z:=0 to readnow-1 do
                aux:=aux+inttohex(Buffer[z],2);

            end;

            //Correction size
            aux:=copy(aux,0,length(aux2));

            //showmessage(Aux+' '+aux2);

            b:=False;
            if aux=aux2 then
              b:=true;

            if Test.fieldbyname('CORRECTRESULT').asboolean<>b then
              userule:=false;

            end;
          2:begin

            aux:=Test.fieldbyname('OFFSET_SIZE').asstring;
            aux2:=Test.fieldbyname('MASK').asstring; //ALREADY WITH SEPARATORS
            value:=Test.fieldbyname('VALUE').asstring; //ALREADY WITH SEPARATORS

            readcount:=length(aux2) div 2;

            if aux='EOF' then
              fin.Seek(readcount*-1,soFromEnd)//GET LAS DATA INFO
            else
            if aux[1]='-' then begin
              aux:=GetToken(aux,'-',gettokencount(aux,'-'));
              fin.Seek(strtoint('-$'+aux),soFromEnd);
            end
            else
              fin.Seek(strtoint('$'+aux),soFromBeginning);

            readed:=0;
            aux:='';

            while readed<readcount do begin  //OK

              readnow:=fin.Read(buffer, sizeof(buffer));

              if readnow=0 then
                break;

              readed:=readed+readnow;

              for z:=0 to readnow-1 do
                aux:=aux+inttohex(Buffer[z],2);

            end;

            //Correction size
            aux:=copy(aux,0,length(aux2));

            //showmessage(aux+'='+aux2);

            //CANT STAND WHAT TO DO
          end;
          3:begin //OK
            b:=false;
            if Test.fieldbyname('OFFSET_SIZE').asstring='PO2' then
               b:=ispowerof2(fin.Size)
            else
              case Test.fieldbyname('OPERATOR_BOOL').asinteger of
                0:if fin.Size<strtoint('$'+Test.fieldbyname('OFFSET_SIZE').asstring) then
                  b:=true;
                1:if fin.Size=strtoint('$'+Test.fieldbyname('OFFSET_SIZE').asstring) then
                   b:=true;
                2:if fin.Size>strtoint('$'+Test.fieldbyname('OFFSET_SIZE').asstring) then
                  b:=true;
              end;

            if Test.fieldbyname('CORRECTRESULT').asboolean<>b then
              userule:=False;

            end;
        end; //CASE

        Test.Next;
      end;//MOVE IN RULE

  except
    userule:=false;
  end;

  try

    if userule=true then begin
      //TRY TO APPLY RULE
      aux:=Rules.fieldbyname('START_OFFSET').asstring; //NUM OR NEGATIVE
      aux2:=Rules.fieldbyname('END_OFFSET').asstring;

      //CHECK IF APPLIED FILE IS SAME AS ORIGIN
      if (aux='0') AND (aux2='EOF') AND (Rules.fieldbyname('Operation').asinteger=0) then
        res:=''
      else begin
        //CONVERT OFFSETS TO FILE POSITION
        if aux[1]='-' then begin
          aux:=GetToken(aux,'-',gettokencount(aux,'-'));
          startpos:=strtoint('-$'+aux);//OFFSET TO SIZE
          fin.Seek(startpos,soFromEnd);
        end
        else begin
          startpos:=strtoint('$'+aux);//OFFSET TO SIZE
          fin.Seek(startpos,soFromBeginning);
        end;

        startpos:=fin.Position;

        if aux2='EOF' then
          endpos:=Fin.Size
        else
        if aux2[1]='-' then begin
          aux2:=GetToken(aux2,'-',gettokencount(aux2,'-'));
          Fin.Seek(strtoint('-$'+aux2),soFromEnd);
          endpos:=fin.Position; //Get position equal to new size
        end
        else begin
          endpos:=strtoint('$'+aux2);//OFFSET TO SIZE
          fin.Seek(endpos,soFromBeginning);
          endpos:=fin.Position; //Get position equal to new size
        end;

        outfilename:=getvaliddestination(filename);

        if resizefile(filename,outfilename,startpos,endpos,Rules.fieldbyname('Operation').asinteger)=true then
          res:=outfilename
        else
          userule:=false;

      end;
    end;//USERULE=true
  except
    userule:=false;
  end;

  if userule=true then
    break;

  Rules.next;
end;

finally
  Freeandnil(fin);
end;


Result:=res;
end;


function IAmIn64Bits: Boolean;
type
  TIsWow64Process = function(Handle:THandle; var IsWow64 : BOOL) : BOOL; stdcall;
var
  hKernel32 : Integer;
  IsWow64Process : TIsWow64Process;
  IsWow64 : BOOL;
begin
  // we can check if the operating system is 64-bit by checking whether
  // we are running under Wow64 (we are 32-bit code). We must check if this
  // function is implemented before we call it, because some older versions
  // of kernel32.dll (eg. Windows 2000) don't know about it.
  // see http://msdn.microsoft.com/en-us/library/ms684139%28VS.85%29.aspx
  Result := False;
  hKernel32 := LoadLibrary('kernel32.dll');
  
  if (hKernel32 <> 0) then begin
    @IsWow64Process := GetProcAddress(hkernel32, 'IsWow64Process');
    if Assigned(IsWow64Process) then begin
      IsWow64 := False;
      if (IsWow64Process(GetCurrentProcess, IsWow64)) then
        Result := IsWow64;
    end;
  end;

  FreeLibrary(hKernel32);
end;

function updatercount():integer;
begin
Result:=35;  //IMPORTANT WHEN ADD NEW DAT GROUPS
end;

function updaterdescription(id:integer;text:boolean):string;
var
res:string;
st:Tstringlist;
begin
st:=Tstringlist.Create;
st.add('TOSEC - ROMs'+'|'+'0');
st.add('No-Intro - Public'+'|'+'1');
st.add('Redump.org - Public'+'|'+'2');
st.add('Pocket heaven'+'|'+'3'); // REMOVED
st.Add('Arcade - MAME'+'|'+'4');
st.add('Yori Yoshizuki - Pinballs'+'|'+'5');
st.add('Gambling - Fruit Machines'+'|'+'6');
st.add('TOSEC - ISO'+'|'+'7');
st.add('TOSEC - PIX'+'|'+'8');
st.add('Yori Yoshizuki - NonGoods'+'|'+'9');
st.add('Yori Yoshizuki - Unrenamed Files'+'|'+'10');
st.add('Offlinelist (DB DATs)'+'|'+'11');
st.add('Trurip - Normal DATs'+'|'+'12'); //REMOVED
st.add('Trurip - Super DATs'+'|'+'13');  //REMOVED
st.add('Rawdump'+'|'+'14'); //REMOVED
st.add('DOS - TotalDosCollection'+'|'+'15');
st.add('Yori Yoshizuki - Unrenamed Consoles'+'|'+'16'); //REMOVED
st.add('Yori Yoshizuki - UnRenamed ISOs'+'|'+'17');//REMOVED
st.add('Yori Yoshizuki - Arcade'+'|'+'18');//REMOVED
st.add('Yori Yoshizuki - Artworks'+'|'+'19');//REMOVED
st.add('Yori Yoshizuki - Misc'+'|'+'20'); //REMOVED
st.add('DatsSite - Scene'+'|'+'21');
st.add('DatsSite - Custom'+'|'+'22');
st.add('Connie - Main'+'|'+'23');
st.add('Connie - FinalBurn Neo'+'|'+'24');
st.add('Arcade - EMMA'+'|'+'25');
st.add('DOS - GoodOldDays'+'|'+'26');
st.add('Arcade - MAME - Softwarelists'+'|'+'27');
st.add('Gruby'+''''+'s Adventure Pack - DATs - Misc'+'|'+'28');
st.add('Gruby'+''''+'s Adventure Pack - DATs'+'|'+'29');
st.add('Super Mario World Hacks - All'+'|'+'30');
st.add('Retroplay - English Translations'+'|'+'31');
st.add('Retroplay - MSU'+'|'+'32');
st.add('Retroplay - Amiga'+'|'+'33');
st.add('Antopisa - Progetto Snaps'+'|'+'34');
st.Sort;

res:=st.Strings[id];

if text=true then
  res:=gettoken(res,'|',1)
else
  res:=gettoken(res,'|',2);

st.free;

Result:=res;
end;

function GetDesktopFolder: widestring;
var
 buf: array[0..MAX_PATH] of widechar;
begin
 Result := '';
 SHGetSpecialFolderPathW(Application.Handle,buf,CSIDL_DESKTOP,false);
 Result := buf;
end;

function getdattypeiconindexfromchar(typ:string):integer;
var
res:shortint;
begin
res:=41;

if typ='X' then //XML
  res:=15
else
if typ='C' then //CLRMAME OLD FORMAME
  res:=13
else
if typ='O' then //OFFLINELIST
  res:=14
else
if typ='R' then //ROMCENTER
  res:=16
else
if typ='S' then //SOFTLISTS
  res:=19
else
if typ='H' then //HASHES
  res:=40
else
if typ='D' then //DOSCENTER
  res:=43
else
if typ='N' then //HYPERSPIN
  res:=44;

result:=res;
end;

function getcounterfilemode(Tablesets,Tableroms:ansistring;fmode:shortint;insertion:boolean):ansistring;
var
totalsets,havesets:longint;
totalroms,haveroms,setromscounter,sethavecounter,incompsets:longint;
allowmerge,allowdupe,calc:boolean;
Qm,Qd:TABSQuery;
fieldname:ansistring;
wide:widestring;
fieldnum:integer;
begin
totalsets:=0;
totalroms:=0;
havesets:=0;
haveroms:=0;
incompsets:=0;
setromscounter:=0;
sethavecounter:=0;

if fmode=0 then begin
  fieldname:='Setnamemaster';
  fieldnum:=8;
end
else begin
  fieldname:='Setname';
  fieldnum:=7;
end;

Qm:=TABSQuery.Create(Datamodule1);
Qd:=TABSQuery.Create(Datamodule1);

Qm.DatabaseName:='RML_DATA';
Qd.DatabaseName:='RML_DATA';
Qm.DisableControls;
Qd.DisableControls;
Qm.RequestLive:=true;
Qd.RequestLive:=true;

Qm.SQL.Text:='SELECT * FROM '+Tablesets+' ORDER BY ID';
Qm.Open;
Qd.SQL.add('SELECT * FROM '+Tableroms+' ORDER BY '+fieldname);
Qd.Open;

allowmerge:=false;
allowdupe:=false;

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

Qm.first;
Qd.First;

{
type
  Trecsets = class
    private
      dir : widestring;
      dirup : widestring;
      id : longint;
    public
      property directory : widestring
          read dir;
      property directoryup : widestring
          read dirup;
      property id_ : longint
          read id;
      constructor Create(const dir : widestring; const dirup :widestring ;const id : longint);
  end;

type
  Trecroms = class
    private
      id : longint;
      romname : widestring;
      romnameup : widestring;
    public
      property id_ : longint
          read id;
      property romname_ : widestring
          read romname;
      property romnameup_ : widestring
          read romnameup;
      constructor Create(const id : longint; const romname :widestring ;const romnameup : widestring);
  end;
}

try

//Datamodule1.DBDatabase.StartTransaction;
While not Qd.Eof do begin

  if onathread=false then
    Application.ProcessMessages;
                  //ID
  While Qm.Fields[0].asinteger<>Qd.fields[fieldnum].asinteger do begin

    if setromscounter>0 then begin //Count as set

      totalsets:=totalsets+1;
      totalroms:=totalroms+setromscounter;

      if sethavecounter=setromscounter then
        havesets:=havesets+1
      else
      if sethavecounter>0 then
        incompsets:=incompsets+1;

      haveroms:=haveroms+sethavecounter;

      //ADD SET
      if insertion=true then begin     //Gamename
        wide:=getwiderecord(Qm.fields[2]);                               //ID
        recsets.Add(Trecsets.Create(wide, wideuppercase(wide), Qm.Fields[0].asinteger));
      end;
    end;

    setromscounter:=0;
    sethavecounter:=0;

    Qm.Next;

    if Qm.Eof then
      makeexception;
  end;

  calc:=true;
                //Merge
  if Qd.fields[10].asboolean=true then
    if allowmerge=false then
      calc:=false;

  if Qd.fields[11].asboolean=true then 
    if allowdupe=false then
      calc:=false;

  if calc=true then begin
    setromscounter:=setromscounter+1;
    if Qd.fields[9].asboolean=true then  //Have
      sethavecounter:=sethavecounter+1;

    //ADD ROM
    if insertion=true then begin
      wide:=getwiderecord(Qd.fields[1]); //Romname
      recroms.Add(Trecroms.Create(Qd.fields[0].asinteger, wide, Qd.fields[fieldnum].asstring+'*'+wideuppercase(wide)));
    end;
  end;

  Qd.Next;
end;

except
end;

//LAST SET
if setromscounter>0 then begin //Count as set

  totalsets:=totalsets+1;
  totalroms:=totalroms+setromscounter;
  if sethavecounter=setromscounter then
    havesets:=havesets+1
  else
  if sethavecounter>0 then
    incompsets:=incompsets+1;

  haveroms:=haveroms+sethavecounter;
  //ADD SET
  if insertion=true then begin
    wide:=getwiderecord(Qm.fields[2]);//Gamename
    recsets.Add(Trecsets.Create(wide, wideuppercase(wide), Qm.Fields[0].asinteger));
  end;
end;

FreeAndNil(Qm);
FreeAndNil(Qd);

//SORT BY BINARY SEARCH
if insertion=true then begin
  recsets.Sort(recsetsbinarysort);
  recroms.Sort(recromsbinarysort);
end;

//Havesets/Totalsets/Haveroms/Totalroms/Incompletesets
Result:=inttostr(havesets)+'/'+inttostr(totalsets)+'/'+inttostr(haveroms)+'/'+inttostr(totalroms)+'/'+inttostr(incompsets);
end;

function splitmergestring(i:integer):ansistring;
begin
case i of
  0:Result:='Not split';
  1:Result:='Split / Merged';
  2:Result:='Split / Not merged';
  else
    Result:='Split / Merged';
end;
end;

function appversion():ansistring;
begin
result:='0.050rc1';
end;

function IsWineOS:Boolean;
var H: cardinal;
begin
Result := False;
H := LoadLibrary('ntdll.dll');
if H > HINSTANCE_ERROR then begin
  Result := Assigned(GetProcAddress(H, 'wine_get_version'));
  FreeLibrary(H);
  end;
end;

function filewithoutext(f:widestring):widestring;
begin
result:=WideChangeFileExt(WideExtractFileName(f),'');
end;

function pointdelimiters(num:extended):ansistring;
begin
if num=0 then
  Result:='0'
else
  Result:=Changein(FormatFloat('#,',num),',','.');
end;

function GetWinDir: string;
var
  dir: array [0..MAX_PATH] of Char;
begin
GetTempPath(SizeOf(dir), dir);
Result :=checkpathbar(String(dir));
end;

function WideSystemDir: widestring;
var
  dir: array [0..MAX_PATH] of WCHAR;
begin
  GetSystemDirectoryw(dir, MAX_PATH);
  Result := checkpathbar(dir);
end;

function cmdpatchedpath: ansistring;
var
res:widestring;
pass:boolean;
strm:TResourceStream;
begin
pass:=true;
res:=tempdirectoryresources+'cmdpatched.exe';

try

  if fileexists2(res) then
    if sizeoffile(res)=403456 then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(24),RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res);
    finally
      strm.free;
    end;

  end;

except
end;

Result:=res;
end;

function tempdirectoryresources():ansistring;
var
res:ansistring;
begin
res:=GetWinDir;

if isunicodefilename(res)=true then
  res:=res[1]+':\TMP\RES\';

try
  ForceDirectories(res);
except
end;

Result := res;
end;

function tempdirectorycache():widestring;
begin
result:=checkpathbar(wideextractfilepath(TntApplication.ExeName))+'cache\';
try
  WideForceDirectories(result);
except
end;
end;

function tempdirectorymasterdetail(id:ansistring):ansistring;
begin
result:=tempdirectoryresources+id+'.rmt';
end;

function tempdirectoryprofiles():ansistring;
begin
result:=tempdirectoryresources+'profiles.rmt';
end;

function tempdirectoryupdater():ansistring;
begin
result:=tempdirectoryresources+'updater.rmt';
end;


function tempdirectoryupdates():ansistring;
begin
result:=tempdirectoryresources+'updates.rmt';
end;

function tempdirectoryconstructor():ansistring;
begin
result:=tempdirectoryresources+'constructor.rmt';
end;

function tempdirectorypeers():ansistring;
begin
result:=tempdirectoryresources+'peers.rmt';
end;

function downloadeddatsdirectory():widestring;
var
w:widestring;
begin
w:=checkpathbar(wideextractfilepath(TntApplication.ExeName));
w:=checkpathbar(w+'DAT');
try
  WideForceDirectories(w);
except
end;
Result:=w;
end;

procedure installfonts;
var
fname:string;
strm:TResourceStream;
temp:ansistring;
begin
fname:='Segoe UI';//Segoe UI
strm:=nil;

if screen.Fonts.IndexOf(fname)=-1 then begin //AUTOINSTALL FONT IF NOT AVAILABLE

  try
    temp:=tempdirectoryresources+'segoeui.ttf';
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(16),RT_RCDATA );
  except
  end;

  try
    strm.Seek(0,soFromBeginning);
    strm.SaveToFile(temp);
  finally
    strm.free;
  end;

  try
    AddFontResource(Pchar(temp));
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  except
  end;

  try
    temp:=tempdirectoryresources+'segoeuib.ttf';
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(17),RT_RCDATA );
  except
  end;

  try
    strm.Seek(0,soFromBeginning);
    strm.SaveToFile(temp);
  finally
    strm.free;
  end;

  try
    AddFontResource(Pchar(temp));
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  except
  end;

end;

end;

function defaultfontname:string;
var
fname:string;
begin
fname:='Segoe UI';//Segoe UI

//IF FAILS THEN USE TAHOMA
if screen.Fonts.IndexOf(fname)<>-1 then
  result:=fname
else
  result:='Tahoma';

//result:='Tahoma';
end;

function traduction(i:integer):widestring;
var
strm:TResourceStream;
temp:ansistring;
x:integer;
trt:TTntStringList;
begin
if translation=nil then begin

  temp:=tempdirectoryresources+'lang.rmt';
  translation:=TTntStringList.Create;
  trt:=TTntStringList.Create;

  strm:=TResourceStream.Create( hInstance,'#'+inttostr(15),RT_RCDATA );

  try
    strm.Seek(0,soFromBeginning);
    strm.SaveToFile(temp);
    trt.LoadFromFile(temp);
  finally
    strm.free;
  end;

  deletefile2(temp);

  for x:=0 to 1000*(maxlangid+1) do //MEMORY RESERVED MAX 1000 STRINGS BY LANG
    translation.Add('');

  for x:=0 to trt.Count-1 do begin
    if gettokencount(trt.strings[x],',"')>1 then
      try
        translation.Strings[strtoint(gettoken(trt.strings[x],',"',1))]:=gettoken(trt.strings[x],'"',2);
      except
      end;
  end;

  trt.Free;
end;


Result:=translation.Strings[i+(lang*1000)];

if result='' then
  result:=translation.Strings[i]; //ENGLISH RETURNED IF NOT FOUND

//result:=UTF8DEcode('æ¼¢');  }
end;

function maxlangid():integer;
begin
Result:=13;
end;

function idtolangname(i:integer):widestring;
var
res:widestring;
begin
case i of
 1:res:='English';
 2:begin
    res:='Espa';
    res:=res+wchar(241);
    res:=res+'ol';
   end;
 3:res:='Deutsch';
 4:begin
    res:='Fran';
    res:=res+wchar(231);
    res:=res+'ais';
   end;
 5:res:='Magyar';
 6:begin //JAP
    res:=wchar(26085);
    res:=res+wchar(26412);
    res:=res+wchar(35486);
  end;
 7:begin
    res:='Portugu';
    res:=res+wchar(234);
    res:=res+'s';
   end;
 8:begin //KOR
    res:=wchar(54620);
    res:=res+wchar(44397);
    res:=res+wchar(51032);
  end;
 9:begin
    res:='Italiano';
   end;
 10:res:='Euskera';
 11:begin  //CHN SIMP
      res:=wchar(31616);
      res:=res+wchar(20307);
      res:=res+wchar(20013);
      res:=res+wchar(25991);
    end;
 12:begin  //CHN TRAD
      res:=wchar(32321);
      res:=res+wchar(39636);
      res:=res+wchar(20013);
      res:=res+wchar(25991);
    end;
 13:res:='Polish';
 14:res:='Tagalog';
end;

result:=res;
end;

function defaulthtmlsource(asinfo:boolean):widestring;
var
tempimg:ansistring;
res:widestring;
strm:TResourceStream;
id:shortint;
begin
id:=14;
tempimg:=tempdirectoryresources+'error.png';

if asinfo=true then begin
  tempimg:=tempdirectoryresources+'info.png';
  id:=13;
end;

strm:=TResourceStream.Create( hInstance,'#'+inttostr(id),RT_RCDATA );
try
  strm.Seek(0,soFromBeginning);
  strm.SaveToFile(tempimg);
finally
  strm.free;
end;

res:='<head>';
res:=res+'<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';//UTF8
if asinfo=true then
  res:=res+'<title>'+utf8Encode(traduction(454))+'</title>'
else
  res:=res+'<title>'+utf8Encode(traduction(479))+'</title>';

res:=res+'<style type="text/css">';

res:=res+'<!--';
res:=res+'body {';
res:=res+'margin-left: 50px;';
res:=res+'margin-top: 50px;';
res:=res+'margin-right: 50px;';
res:=res+'margin-bottom: 50px;';
res:=res+'background-color: #FFFFFF;';
res:=res+'}';

res:=res+'body,td,th {';
res:=res+'font-family: Arial;';
res:=res+'color: #000;';
res:=res+'font-size: 12px;';
res:=res+'}';
res:=res+'-->';

res:=res+'</style></head>';

res:=res+'<body>';                                                    //30
res:=res+'<table bgcolor="#FFFFFF" width="100%" border="0" cellpadding="30" cellspacing="0">';
res:=res+'<tr>';                                                      //10
res:=res+'<td bgcolor="#FFFFFF"><table width="100%" border="0" cellpadding="10" cellspacing="0">';
res:=res+'<tr>';
res:=res+'<td width="9%"><img src="'+UTF8Encode(tempimg)+'" alt="" width="64" height="64" /></td>';

if asinfo=true then
  res:=res+'<td width="91%"><b>'+utf8Encode(traduction(457))+'</b></td>'
else
  res:=res+'<td width="91%"><b>'+utf8Encode(traduction(480))+'</b></td>';

res:=res+'</tr>';
res:=res+'</table></td>';
res:=res+'</tr>';
res:=res+'</table>';
res:=res+'<div align="center"></div>';
res:=res+'</body>';
res:=res+'</html>';

Result:=res;
//Result:='<html><head><title>'+traduction(454)+'</title><body bgcolor="#CCCCCC"</body></head><p><font face="Tahoma">'+traduction(457)+'</font></p></html>';
end;

function limitconflictcharsedit(sender:Tobject;key:char;percent:boolean):char;
begin
if key<>removeconflictchars2(key,percent) then
  key:=#0;

Result:=key;

//FIX CURSOR DISSAPEAR
sendmessage((Sender as TTntedit).handle, WM_SETCURSOR, 0, 0);
end;

procedure limitconflictcharsedit2(sender:Tobject;percent:boolean);
var
aux:widestring;
r,r2:longint;
begin
aux:=removeconflictchars2((sender as TTntedit).Text,percent);

if (sender as TTntedit).Text<>aux then begin
  r2:=length((sender as TTntedit).text);
  r := (sender as TTntedit).SelStart;
  (sender as TTntedit).Text:=aux;
  (sender as TTntedit).SelStart:=r-(r2-length(aux));
  (sender as TTntedit).SelLength:=0;
end;

//FIX CURSOR DISSAPEAR
sendmessage((Sender as TTntedit).handle, WM_SETCURSOR, 0, 0);
end;

Procedure CenterInClient(Obj:TControl; Const ObjRef:TControl);
Begin
Obj.Left:=(ObjRef.ClientWidth  Div 2) - (Obj.Width  Div 2);
Obj.Top :=(ObjRef.ClientHeight Div 2) - (Obj.Height Div 2);

If Obj.Left<0 Then Obj.Left:=0;
If Obj.Top<0 Then Obj.Top:=0;
End;

function StrPasw(const Str: PwideChar): widestring;
begin
  Result := Str;
end;

Function GetShortFileName(Const FileName : widestring) : widestring;
var
aTmp: array[0..255] of widechar;
begin

if GetShortPathNamew(PwideChar(FileName),aTmp,Sizeof(aTmp)-1)=0 then
  Result:= FileName
else
  Result:=StrPasw(aTmp);

end;

function removeconflictchars3(str:widestring):widestring;
begin
//THIS ARE FOR SET NAMES
if length(str)=0 then begin //OPTIMIZED
  Result:='';
  exit;
end;

str:=Changein(str,'<','-');
str:=Changein(str,'>','-');
str:=Changein(str,'*','-');

//str:=Changein(str,':','-');
str:=Changein(str,'?','-');
str:=Changein(str,'"','-');
str:=Changein(str,'|','-');

str:=Changein(str,#9,'-');
str:=Changein(str,#10,'-');
str:=Changein(str,#13,'-');

str:=Changein(str,'–','-');

Result:=str;
end;

function limitconflictcharseditdialog(sender:Tobject;key:char):char;
begin
if key<>removeconflictchars3(key) then
  key:=#0;

Result:=key;

//FIX CURSOR DISSAPEAR
sendmessage((Sender as TTntedit).handle, WM_SETCURSOR, 0, 0);
end;

function tempdirectoryextractdefault():ansistring;
var
t:ansistring;
begin
t:=tempdirectoryresources[1]+':\TMP\';

try
  ForceDirectories(t);
except
end;

Result:=t;
end;

function tempdirectoryextract():widestring;
begin
tempdirectoryextractvar:=checkpathbar(tempdirectoryextractvar);

try
  WideForceDirectories(tempdirectoryextractvar);
except
end;

if not WideDirectoryExists(tempdirectoryextractvar) then
  tempdirectoryextractvar:=tempdirectoryextractdefault;

result:=tempdirectoryextractvar+'EXT\';
WideForceDirectories(result);
end;

function tempdirectoryextractserver():widestring;
begin
//
end;

function tempdirectorycommunity():ansistring;
var
t:ansistring;
begin
t:=tempdirectoryresources[1]+':\TMP\PART\';

try
  forcedirectories(t);
except
end;

Result:=t;
end;



function fillwithzeroes(str:ansistring;howmany:integer):ansistring;
var
res:ansistring;
x,y:longint;
begin
res:='';
x:=howmany-length(str);
for y:=1 to x do
  res:=res+'0';

res:=res+str;

result:=res;

end;

function removeconflictchars2(str:widestring;percent:boolean):widestring;
begin
//THIS ARE FOR SET NAMES
if length(str)=0 then begin //OPTIMIZED
  Result:='';
  exit;
end;
  
str:=Changein(str,'<','-');
str:=Changein(str,'>','-');
str:=Changein(str,'*','-');

str:=Changein(str,'/','-');
str:=Changein(str,'\','-');

str:=Changein(str,':','-');
str:=Changein(str,'?','-');
str:=Changein(str,'"','-');
str:=Changein(str,'|','-');

str:=Changein(str,#9,'-');
str:=Changein(str,#10,'-');
str:=Changein(str,#13,'-');

str:=Changein(str,'–','-');

if percent=false then
  str:=Changein(str,'%','-');

//NOT ALLOWED BARS / \
try
  while (str[Length(str)]='.') do begin

    str:=copy(str,1,length(str)-1);

    str:=trim(str);
  end;
except
  str:='';
end;

Result:=str;
end;

function removeconflictchars(str:widestring;folderallowed:boolean):widestring;
var
aux:widestring;
begin //OPTIMIZED
//THIS ARE FOR ROM NAMES
if length(str)=0 then begin
  Result:='';
  exit;
end;

str:=Changein(str,'<','-');
str:=Changein(str,'>','-');
str:=Changein(str,'*','-');
str:=Changein(str,':','-');
str:=Changein(str,'?','-');
str:=Changein(str,'"','-');
str:=Changein(str,'|','-');

str:=Changein(str,#9,'-');
str:=Changein(str,#10,'-');
str:=Changein(str,#13,'-');

//POSSIBLE BUT PROBLEMATIC RARE APOS
str:=Changein(str,'–','-');

if folderallowed=false then begin
  str:=Changein(str,'/','-');
  str:=Changein(str,'\','-');
end
else begin
  str:=Changein(str,'/','\');

  if gettokencount(str,'\')>1 then
    try
      aux:='*';//Impossible already changed
      while aux<>str do begin
        aux:=str;

        str:=Changein(aux,'\ ','\');
        str:=changein(str,' \','\');
        str:=changein(str,'.\','\');
        str:=Changein(str,'\\','\');

        if str[1]='\' then //First bar bug
          str:=copy(str,2,length(str));

        str:=trim(str);
      end;
    except
      str:='';
    end;

end;

try
  while (str[Length(str)]='.') do begin

    str:=copy(str,1,length(str)-1);

    str:=trim(str);
  end;
except
  str:='';
end;


Result:=str;
end;

function romulusurl():ansistring;
begin
//MUST END WITH '/'
//result:='http://romulus.net63.net/';
result:='https://romulus.cc/';
end;

function romulustitle():ansistring;
begin
result:='Romulus - Rom Manager';
end;


procedure freekeyboardbuffer;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, WM_KEYFIRST, WM_KEYLAST,
    PM_REMOVE or PM_NOYIELD) do;
end;

procedure freemousebuffer;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, WM_MOUSEFIRST, WM_MOUSELAST,
    PM_REMOVE or PM_NOYIELD) do;
end;

function FormatInClock(TickCount: int64): string;
var
  Hours:  Integer;
  Minutes:Integer;
  Seconds:Integer;
  S_HUR:  string;
  S_MIN:  string;
  S_SEC:  string;
begin
  Result := '00:00:00';
  if (TickCount>0) then
  try
    TickCount := TickCount div 1000;

    Seconds := TickCount mod 60;
    TickCount := TickCount div 60;
    S_SEC := fillwithzeroes(IntToStr(Seconds),2);

    Minutes := TickCount mod 60;
    TickCount := TickCount div 60;
    S_MIN := fillwithzeroes(IntToStr(Minutes),2);

    Hours := TickCount mod 60;
    //TickCount := TickCount div 60;
    S_HUR := fillwithzeroes(IntToStr(Hours),2);

  finally
    Result :=S_HUR+TimeSeparator+S_MIN+timeseparator+S_SEC;
  end;
end;

function BytesToStr(Bytes: currency): ansiString;
const
FACTOR = 1024;
Arr: array [0..4] of String=('Bytes','KB','MB','GB','TB');
var
i: cardinal;
begin
i := 0;

while (i < High(Arr)) and  (Bytes >= FACTOR) do
begin
  Bytes := Bytes / FACTOR;
  Inc(i);
end;

Result :=FormatFloat('0.00',Bytes) + ' ' + Arr[i];
end;

function numberpoints(n:double):ansistring;
begin
Result:=' ['+FormatFloat('#,',n)+' bytes]';
end;

procedure exec(F:Tform;path:widestring);
begin
ShellExecutew(F.Handle,nil,PwideChar(path),'','',SW_SHOWNORMAL);
end;

procedure disablesysmenu(F:Tform;status:boolean);
var
  Flag: UINT;
  AppSysMenu: THandle;
begin
  //CHANGED SINZE 0.019
  AppSysMenu:=GetSystemMenu(F.Handle,False);

  if status=false then
    Flag:=MF_GRAYED
  else
    Flag:=MF_ENABLED;

  EnableMenuItem(AppSysMenu,SC_CLOSE,MF_BYCOMMAND or Flag);
  DrawMenuBar(F.Handle);
end;

procedure posintoindexbynode(n:PVirtualNode;lv:TVirtualStringTree);
begin
try
  lv.ClearSelection;
  lv.FocusedNode:=n;
  lv.Selected[n]:=true;
  lv.ScrollIntoView(lv.FocusedNode,true);
except
end;

end;

procedure posintoindex(ind:int64;obj:Tobject);
var
n:PVirtualNode;
begin

try begin
  if (obj is TVirtualStringTree) then begin
    n:=(obj as TVirtualStringTree).GetFirst;
    
    while n.Index<>ind do //SLOOOOOOOOOOOW
      n:=(obj as TVirtualStringTree).GetNext(n);

    (obj as TVirtualStringTree).ClearSelection;
    (obj as TVirtualStringTree).FocusedNode:=n;
    (obj as TVirtualStringTree).Selected[n]:=true;
    (obj as TVirtualStringTree).ScrollIntoView((obj as TVirtualStringTree).FocusedNode,true);
  end;
end
except
end;

end;

function defaultofffilename():ansistring;
begin
Result:='%u - %n %o';
end;

function checkofflinelistdescriptioniffailsreturndefault(str:widestring):widestring;
begin
//relnum+' '+description+' '+location+' '+langnum
if trim(str)='' then
  str:='%u %n %o %m';

result:=str;
end;

function checkofflinelistfilenameiffailsreturndefault(str:widestring):widestring;
var
good:boolean;
default:widestring;
begin
good:=false;
default:=defaultofffilename;
str:=trim(str);

if Changein(str,'%n','')<>str then
  good:=true;

if Changein(str,'%p','')<>str then
  good:=true;

if Changein(str,'%s','')<>str then
  good:=true;

if Changein(str,'%u','')<>str then
  good:=true;

if Changein(str,'%e','')<>str then
  good:=true;

if Changein(str,'%a','')<>str then
  good:=true;

if Changein(str,'%o','')<>str then
  good:=true;

if Changein(str,'%g','')<>str then
  good:=true;

if Changein(str,'%i','')<>str then
  good:=true;

if Changein(str,'%m','')<>str then
  good:=true;

if Changein(str,'%c','')<>str then
  good:=true;


if good=false then
  str:=default;

str:=removeconflictchars(str,false);

Result:=str;
end;

function Getlongpathname(const ShortPathName: ansistring): ansistring; //TO WIDE
var
  bSuccess: Boolean;
  fncGetLongPathName: function (lpszShortPath: LPCTSTR;
    lpszLongPath: LPTSTR; cchBuffer: DWORD): DWORD stdcall;
  szBuffer: array[0..MAX_PATH] of Char;
  pDesktop: IShellFolder;
  swShortPath: WideString;
  iEaten: ULONG;
  pItemList: PItemIDList;
  iAttributes: ULONG;
begin
  bSuccess := False;
  // try to use the function "GetLongPathNameA" (Win98/2000 and up)
  @fncGetLongPathName := GetProcAddress(
    GetModuleHandle('Kernel32.dll'), 'GetLongPathNameA');
  if (Assigned(fncGetLongPathName)) then
  begin
    bSuccess := fncGetLongPathName(PChar(ShortPathName), szBuffer,
      SizeOf(szBuffer)) <> 0;
    if bSuccess then
      Result := szBuffer;
  end;
  // use an alternative way of getting the path (Win95/NT). the function
  // "SHGetFileInfo" (as often seen in examples) only converts the
  // filename without the path.

  if (not bSuccess) and Succeeded(SHGetDesktopFolder(pDesktop)) then
  begin
    swShortPath := ShortPathName;
    iAttributes := 0;
    if Succeeded(pDesktop.ParseDisplayName(0, nil, POLESTR(swShortPath),
      iEaten, pItemList, iAttributes)) then
    begin
      bSuccess := SHGetPathFromIDList(pItemList, szBuffer);
      if bSuccess then
        Result := szBuffer;
      // release ItemIdList (SHGetMalloc is superseded)
      CoTaskMemFree(pItemList);
    end;
  end;
  // give back the original path if unsuccessful
  if (not bSuccess) then
    Result := ShortPathName;
end;

Function checkpathcase(S : widestring) : widestring;  //GET REAL CURRENT CASE FILENAME
var
fso : OleVariant;
res:widestring;
begin
res:=s;

try
  if s<>'' then begin
    fso := CreateOleObject('Scripting.FileSystemObject');
    res:=Fso.Getabsolutepathname(s);
    if s[Length(s)]='\' then//IF DIRECTORY
      res:=checkpathbar(res);
  end;
except
end;

Result:=res;
end;

function DiskInDrive(Drive: Char): Boolean;
var
res:boolean;
begin
res:=false;

if Drive in ['a'..'z'] then Dec(Drive, $20);

try
  if DiskSize(Ord(Drive) - $40) <> -1 then
    res := true;
except
end;

Result:=res;
end;

function folderdialoginitialdircheck(path:widestring):widestring;
var
res,aux:widestring;
x,init:integer;
isnetfolder:boolean;
const
bar='\';
begin
init:=1;
isnetfolder:=false;

if changein(path,'\\','')<>path then begin //Fix for local folders
  isnetfolder:=true;
  init:=4;
end;


if Length(path)>0 then
  If (DiskInDrive(Char(path[1]))) or (isnetfolder=true) then begin

    path:=checkpathbar(path);

    for x:=init to GetTokenCount(path,bar) do begin

      aux:=GetToken(path,bar,x);
      if ((isnetfolder=true) AND (init=4)) then  //Fix for local folders
        res:='\\'+gettoken(path,'\',3)+'\';

      if WideDirectoryExists(res+aux) then
        res:=checkpathbar(res+aux)
      else
        break;

    end;

  end;

if res='' then
  res:=checkpathbar(GetDesktopFolder);

result:=res;
end;

function mameoutpath():ansistring;
begin
result:=tempdirectoryresources+'MAME.dat'
end;

function rarpath():ansistring;
var
strm:TResourceStream;
res:ansistring;
pass:boolean;
id:integer;
correctsize:longint;
begin
pass:=true;
res:=checkpathbar(tempdirectoryresources)+'RAR.exe';

if iswin64 then begin
  correctsize:=603864;
  id:=6;
end
else begin
  correctsize:=569560;
  id:=1;
end;

try

  if FileExists2(res) then
    if sizeoffile(res)=correctsize then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(id),RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res);
    finally
      strm.free;
    end;

  end;

except
end;

Result:=res;
end;

function HexToBin(HexStr: string): string;
const
  BinArray: array[0..15, 0..1] of string =
    (('0000', '0'), ('0001', '1'), ('0010', '2'), ('0011', '3'),
     ('0100', '4'), ('0101', '5'), ('0110', '6'), ('0111', '7'),
     ('1000', '8'), ('1001', '9'), ('1010', 'A'), ('1011', 'B'),
     ('1100', 'C'), ('1101', 'D'), ('1110', 'E'), ('1111', 'F'));
  HexAlpha: set of char = ['0'..'9', 'A'..'F'];
var
  i, j: Integer;
begin
  Result:='';
  HexStr:=AnsiUpperCase(HexStr);
  for i:=1 to Length(HexStr) do
    if HexStr[i] in HexAlpha then
    begin
      for j:=1 to 16 do
        if HexStr[i]=BinArray[j-1, 1] then
          Result:=Result+BinArray[j-1, 0];
    end
    else
    begin
      Result:='';
      Break;
    end;
  if Result<>'' then
   while (Result[1]='0')and(Length(Result)>1) do
     Delete(result, 1, 1);
end;

function BinToHex(BinStr: string): string;
const
  BinArray: array[0..15, 0..1] of string =
    (('0000', '0'), ('0001', '1'), ('0010', '2'), ('0011', '3'),
     ('0100', '4'), ('0101', '5'), ('0110', '6'), ('0111', '7'),
     ('1000', '8'), ('1001', '9'), ('1010', 'A'), ('1011', 'B'),
     ('1100', 'C'), ('1101', 'D'), ('1110', 'E'), ('1111', 'F'));
var
  Error: Boolean;
  j: Integer;
  BinPart: string;
begin
  Result:='';

  Error:=False;
  for j:=1 to Length(BinStr) do
    if not (BinStr[j] in ['0', '1']) then
    begin
      Error:=True;
      Break;
    end;

  if not Error then
  begin
    case Length(BinStr) mod 4 of
      1: BinStr:='000'+BinStr;
      2: BinStr:='00'+BinStr;
      3: BinStr:='0'+BinStr;
    end;

    while Length(BinStr)>0 do
    begin
      BinPart:=Copy(BinStr, Length(BinStr)-3, 4);
      Delete(BinStr, Length(BinStr)-3, 4);
      for j:=1 to 16 do
        if BinPart=BinArray[j-1, 0] then
          Result:=BinArray[j-1, 1]+Result;
    end;
  end;
end;

function getinverthex(hex:string):string;
var
aux,res:string;
x:integer;
begin

try
  aux:=HexToBin(hex);

  aux:=fillwithzeroes(aux,32);

  for x:=1 to length(aux) do
    if aux[x]='0' then
      res:=res+'1'
    else
      res:=res+'0';

  result:=fillwithzeroes(BinToHex(res),8);
except
  result:='@';
end;

end;

function chdgetinfo(filename:widestring):widestring;
var
fin:TTntFileStream;
buffer:array[0..124] of byte; //MAX HEADER LENGHT
str,sha1:string;
x,ini:integer;
begin
//https://github.com/mamedev/mame/blob/master/src/lib/util/chd.h
sha1:='*';

try
  fin := TTntFileStream.Create(filename, fmOpenRead or fmShareDenyNone);

  fin.Seek(0,soFromBeginning);
  fin.Read(buffer, sizeof(buffer));

  for x:=0 to 7 do
    str:=str+chr(buffer[x]);

  if str='MComprHD' then begin//IS CHD
    ini:=84;
    sha1:='';

    case ord(buffer[15]) of //VERSION ALWAYS IS SAME POSSITION
      3:ini:=80;
      4:ini:=48;
      5:ini:=84
    end;

    for x:=ini to ini+19 do
      sha1:=sha1+IntToHex(ord(buffer[x]),2);

  end;

except
end;

Freeandnil(fin);

result:=sha1;
end;

function chdmanpath():ansistring;
var
strm:TResourceStream;
res:ansistring;
pass:boolean;
id:integer;
correctsize:longint;
begin
pass:=true;

res:=checkpathbar(tempdirectoryresources)+'chdman.exe';

//Always size in disk properties
if iswin64 then begin
  id:=9;
  correctsize:=2019840 ;
end
else begin
  id:=5;
  correctsize:=2283022;
end;

try //FIX?

  if fileexists2(res) then
    if sizeoffile(res)=correctsize then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(id),RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res);
    finally
      strm.free;
    end;
  end;

except
end;

Result:=res;
end;

function sevenzippath():ansistring;
var
strm:TResourceStream;
res,res2:ansistring;
pass:boolean;
correctsize1,correctsize2:longint;
id1,id2:integer;
begin
pass:=true;
res:=checkpathbar(tempdirectoryresources)+'7z.exe';
res2:=checkpathbar(tempdirectoryresources)+'7z.dll';

//Always size in disk properties
if iswin64 then begin
  correctsize1:=468992 ; //EXE
  correctsize2:=1679360; //DLL
  id1:=7;
  id2:=8;
end
else begin
  correctsize1:=292864;
  correctsize2:=1141248 ;
  id1:=2;
  id2:=3;
end;

try

  if fileexists2(res) then
    if sizeoffile(res)=correctsize1 then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(id1),RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res);
    finally
      strm.free;
    end;

  end;

except
end;

pass:=True;

try

  if fileexists2(res2) then
    if sizeoffile(res2)=correctsize2 then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(id2),RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res2);
    finally
      strm.free;
    end;

  end;

except
end;

Result:=res;
end;

function sevenzipdelpath():ansistring;
var
strm:TResourceStream;
mainpath,res,res2:ansistring;
pass:boolean;
correctsize1,correctsize2:longint;
id1,id2:integer;
begin
pass:=true;
mainpath:=checkpathbar(tempdirectoryresources);
mainpath:=mainpath+'7zd\';
ForceDirectories(mainpath);

res:=mainpath+'7z.exe';
res2:=mainpath+'7z.dll';

//Always size in disk properties
if iswin64 then begin
  correctsize1:=284160;
  correctsize2:=1422336;
  id1:=20;
  id2:=21;
end
else begin
  correctsize1:=163840;
  correctsize2:=914432;
  id1:=18;
  id2:=19;
end;

try

  if fileexists2(res) then
    if sizeoffile(res)=correctsize1 then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(id1),RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res);
    finally
      strm.free;
    end;

  end;

except
end;

pass:=True;

try

  if fileexists2(res2) then
    if sizeoffile(res2)=correctsize2 then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#'+inttostr(id2),RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res2);
    finally
      strm.free;
    end;

  end;

except
end;

Result:=res;

end;

function torrent7zippath():ansistring;
var
strm:TResourceStream;
res,res2:ansistring;
pass:boolean;
begin
pass:=true;
res:=checkpathbar(tempdirectoryresources)+'t7z.exe';

try
  if fileexists2(res) then
    if sizeoffile(res)=299008 then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#11',RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res);
    finally
      strm.free;
    end;
  end;
except
end;

res2:=checkpathbar(tempdirectoryresources)+'msvcr71.dll';
pass:=true;

try
  if fileexists2(res2) then
    if sizeoffile(res2)=348160 then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#12',RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res2);
    finally
      strm.free;
    end;
  end;
except
end;

Result:=res;
end;

function torrentzippath():ansistring;
var
strm:TResourceStream;
res:ansistring;
pass:boolean;
begin
pass:=true;
res:=checkpathbar(tempdirectoryresources)+'trrntzip.exe';

//0.035
deletefile2(checkpathbar(tempdirectoryresources)+'error.log');

try
  if fileexists2(res) then
    if sizeoffile(res)=237189 then
      pass:=false;

  if pass=true then begin
    strm:=TResourceStream.Create( hInstance,'#4',RT_RCDATA );
    try
      strm.Seek(0,soFromBeginning);
      strm.SaveToFile(res);
    finally
      strm.free;
    end;
  end;

except
end;

Result:=res;
end;

function tempdirectoryheadersdbpath():ansistring;
begin
Result:=tempdirectoryresources+'headers.rmt';
end;

function headerspath():widestring;
var
path:widestring;
begin
path:=checkpathbar(WideExtractfilepath(TntApplication.ExeName))+'headers\';
WideForceDirectories(path);
Result:=path;
end;

function SecToTime(Sec: int64): string;
var
   H, M, S: string;
   ZH, ZM, ZS: Integer;
begin
   ZH := Sec div 3600;
   ZM := Sec div 60 - ZH * 60;
   ZS := Sec - (ZH * 3600 + ZM * 60) ;
   H := IntToStr(ZH) ;
   M := IntToStr(ZM) ;
   S := IntToStr(ZS) ;
   Result := fillwithzeroes(H,2) + ':' + fillwithzeroes(M,2) + ':' + fillwithzeroes(S,2);
end;

function IsDirectoryEmpty(directory : widestring) : boolean;
var
searchRec :TSearchRecw;
begin
directory:=checkpathbar(directory);

try
result := (WideFindFirst(directory+'*.*', faAnyFile, searchRec) = 0) AND
              (WideFindnext(searchRec) = 0) AND
              (WideFindnext(searchRec) <> 0) ;
finally
  WideFindClose(searchRec);
end;

end;

function Fileisutf8(FileName: widestring): Boolean;
var
 Stream: Ttntmemorystream;
 BytesRead: integer;
 ArrayBuff: array[0..127] of byte;
 PreviousByte: byte;
 i: integer;
 YesSequences, NoSequences: integer;

begin
   if not fileexists2(FileName) then begin
     result:=false;
     Exit;
   end;
   YesSequences := 0;
   NoSequences := 0;
   Stream := Ttntmemorystream.Create;
   try
     Stream.LoadFromFile(FileName);
     repeat

     {read from the TMemoryStream}

       BytesRead := Stream.Read(ArrayBuff, High(ArrayBuff) + 1);
           {Do the work on the bytes in the buffer}
       if BytesRead > 1 then
         begin
           for i := 1 to BytesRead-1 do
             begin
               PreviousByte := ArrayBuff[i-1];
               if ((ArrayBuff[i] and $c0) = $80) then
                 begin
                   if ((PreviousByte and $c0) = $c0) then
                     begin
                       inc(YesSequences)
                     end
                   else
                     begin
                       if ((PreviousByte and $80) = $0) then
                         inc(NoSequences);
                     end;
                 end;
             end;
         end;
     until (BytesRead < (High(ArrayBuff) + 1));
//Below, >= makes ASCII files = UTF-8, which is no problem.
//Simple > would catch only UTF-8;
     Result := (YesSequences >= NoSequences);

   finally
    Stream.Free;
   end;
end;

function fixxmlseparators(str:widestring):widestring;
var
x:integer;
fake,num:widestring;
c:widechar;
inside:boolean;
begin

if GetTokenCount(str,';')>1 then begin //SPEED CHEAT

  str:=changein(str, '&gt;', '-');
  str:=changein(str, '&quot;', '-');
  str:=changein(str, '&apos;', '''');
  str:=changein(str, '&lt;', '-');

  str:=changein(str, '&amp;', '&');//SEEMS MUST BE HERE

  //Special bugfixes
  str:=changein(str, '&#160;',''); //no-break space
  str:=changein(str, '&#173;',''); //soft hyphen

  //numeric &# hex &#x
  if gettokencount(str,'&#')>1 then begin
    inside:=false;
    x:=1;

    while x<>length(str)+1 do begin

      if str[x]='&' then begin
        fake:='';
        inside:=true;
      end
      else
      if inside=true then
        if str[x]=';' then begin
          if fake[1]='#' then begin

            fake:=copy(fake,2,length(fake));

            if fake[1]='x' then //HEX
              num:='$'+copy(fake,2,length(fake))
            else
              num:=fake;
            try

              c:=widechar(strtoint(num));

              fake:='&#'+fake+';';
              str:=changein(str,fake,c);

              x:=x-length(fake);//Reposition
            except
            end;
          end;
          inside:=false;
        end
        else
          fake:=fake+str[x];

      x:=x+1;
    end;//WHILE X
  end;

  //str:=changein(str, '&amp;', '&');//ALWAYS LAST

  str:=trim(str);
end;

//MORE AT http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
Result:=str;
end;

function isthisvalidurlfile(url:ansistring):boolean;
var
aux:string;
begin
//file:///C:/
Result:=false;

url:=Wideuppercase(url);
aux:=gettoken(url,':',1);

if (aux='FILE') then
  if trim(gettoken(url,':',2))<>'' then
    Result:=true


end;

function isthisvalidurl(url:ansistring):boolean;
var
aux:string;
begin
//www. http: file: mailto: ftp: https: gopher: nntp: telnet: news:

Result:=false;

url:=Wideuppercase(url);
aux:=gettoken(url,':',1);

if (aux='HTTP') OR (aux='HTTPS') OR (aux='FTP') OR (aux='MAILTO') OR (aux='GOPHER') OR (aux='TELNET') OR (aux='NEWS') OR (aux='NNTP') then begin
  if trim(gettoken(url,':',2))<>'' then
    Result:=true
end
else begin
  aux:=gettoken(url,'.',1);
  if aux='WWW' then
    if trim(gettoken(url,'.',2))<>'' then
      result:=true;
end;

end;

//-WINDOWS FIREWALL------------------------------------------------------------

const
  NET_FW_PROFILE_DOMAIN = 0;
  NET_FW_PROFILE_STANDARD = 1;
  NET_FW_IP_VERSION_ANY = 2;
  NET_FW_IP_PROTOCOL_UDP = 17;
  NET_FW_IP_PROTOCOL_TCP = 6;
  NET_FW_SCOPE_ALL = 0;
  NET_FW_SCOPE_LOCAL_SUBNET = 1;

function GetWinFirewall(var fwMgr, profile: OleVariant): boolean;
begin
  Result := (Win32Platform=VER_PLATFORM_WIN32_NT) and
    (Win32MajorVersion>5) or ((Win32MajorVersion=5) and (Win32MinorVersion>0));
  if result then // need Windows XP at least
  try
    fwMgr := CreateOleObject('HNetCfg.FwMgr');
    profile := fwMgr.LocalPolicy.CurrentProfile;
  except
    on E: Exception do
      result := false;
  end;
end;

procedure AddApplicationToWinFirewall(const EntryName, ApplicationPathAndExe: widestring);
var fwMgr, profile, app: OleVariant;
begin
  if GetWinFirewall(fwMgr,profile) then
  try
    if profile.FirewallEnabled then begin
      app := CreateOLEObject('HNetCfg.FwAuthorizedApplication');
      try
        app.ProcessImageFileName := ApplicationPathAndExe;
        app.Name := EntryName;
        app.Scope := NET_FW_SCOPE_ALL;
        app.IpVersion := NET_FW_IP_VERSION_ANY;
        app.Enabled :=true;
        profile.AuthorizedApplications.Add(app);
      finally
        app := varNull;
      end;
    end;
  finally
    profile := varNull;
    fwMgr := varNull;
  end;
end;

procedure AddPortToWinFirewall(const EntryName: string; PortNumber: cardinal);
var fwMgr, profile, port: OleVariant;
begin
  if GetwinFirewall(fwMgr,profile) then
  try
    if profile.FirewallEnabled then begin
      port := CreateOLEObject('HNetCfg.FWOpenPort');
      port.Name := EntryName;
      port.Protocol := NET_FW_IP_PROTOCOL_TCP;
      port.Port := PortNumber;
      port.Scope := NET_FW_SCOPE_ALL;
      port.Enabled := true;
      profile.GloballyOpenPorts.Add(port);
    end;
  finally
    port := varNull;
    profile := varNull;
    fwMgr := varNull;
  end;
end;

end.
