Unit hashes;

interface

uses Windows, SysUtils, Classes, TntClasses, Tntsysutils, Dialogs, Gphugef, Forms;

type
  Long = record
    LoWord: Word;
    HiWord: Word;
  end;

type
  THashAlgorithm = (haMD5, haSHA1);

function SZCRC32Update(P: Pointer; ByteCount: Longint ; CurCrc : DWORD): DWORD;
function SZCRC32UpdateStream(Stream : TGpHugeFileStream; CurCrc : DWORD) : DWORD;
function GetCRC32(FileName : widestring) : string;
function CalcHash(Archivo: widestring; Algorithm: THashAlgorithm): string; overload;
function CalcHash(Stream: Tgphugefilestream; Algorithm: THashAlgorithm): string; overload;
Function StringToStream(const AString: string): TStream;
function HextL(l: longint): string;
function fasthash(Filename:widestring):string;

implementation

const
  CRC32BASE: DWORD = $FFFFFFFF;
  cachemultiplier = 100;  //In MB
Var
  CRC32Table: array[0..255] of DWORD;

function HextW(w: Word): string;
const
  h: array[0..15] Of char = '0123456789ABCDEF';
begin
  HextW := '';
  HextW := h[Hi(w) shr 4] + h[Hi(w) and $F] + h[Lo(w) shr 4]+h[Lo(w) and $F];
end;

function HextL(l: longint): string;
begin
  with Long(l) do
    HextL := HextW(HiWord) + HextW(LoWord);
end;        

Function StringToStream(const AString: string): TStream;
begin
  Result := TStringStream.Create(AString);
end;

procedure SZCRC32MakeTable;
var
  i,j: integer;
  r: DWORD;
begin
  for i:= 0 to 255 do
  begin
    r := i;
    for j:=1 to 8 do
      if (r and 1) = 1 then
        r := (r shr 1) xor DWORD($EDB88320)
      else
        r := (r shr 1);

      CRC32Table[i] := r
  end;
end;

function SZCRC32Update(P: Pointer; ByteCount: Longint ; CurCrc : DWORD): DWORD;
var
  CRCValue: DWORD;
  i: LongInt;
  b: ^Byte;
begin
  b := p;
  CRCValue := CurCrc;
  for i := 1 to ByteCount do
  begin
    CRCvalue := (CRCvalue shr 8) xor CRC32Table[b^ xor byte(CRCvalue and $FF)];
    inc(b);
  end;
  Result := CRCValue;
end;

function SZCRC32UpdateStream(Stream : Tgphugefilestream; CurCrc : DWORD) : DWORD;
const
  CRC32BUFSIZE = 1048576*cachemultiplier;//1Mb
var
  BufArray:PByte;
  Res   : longint;
  CRC32 : DWORD;
  maxsize:int64;
  //
  sum:int64;
begin
  CRC32 := CurCrc;
  maxsize:=stream.Size;//0.034 Speedup
  res:=CRC32BUFSIZE;
  sum:=0;
  GetMem(BufArray,CRC32BUFSIZE);
try
  repeat
    sum:=sum+CRC32BUFSIZE;

    if sum>maxsize then //LAST PASS
      res:=CRC32BUFSIZE-(sum-maxsize);

    stream.ReadBuffer(BufArray^,res);

    CRC32 := SZCRC32Update(BufArray,res,CRC32);

  until (stream.Position = maxsize);

finally
  FreeMem(BufArray);
end;

Result:=CRC32
end;

function fasthash(Filename:widestring):string;
var
BufArray:PByte;
Res   : longint;
sum,maxsize:int64;
FileStream:Tgphugefilestream;
CRC32 : DWORD;
r_:string;
const
CRC32BUFSIZE = 32000;
begin
r_:='';
try
  Filestream:=Tgphugefilestream.Createw(Filename,accRead,[hfoBuffered],0 ,0 ,0 ,0 ,20,CRC32BUFSIZE,0);

  res:=CRC32BUFSIZE;
  crc32:=CRC32BASE;
  sum:=0;
  GetMem(BufArray,CRC32BUFSIZE);
  maxsize:=FileStream.Size;//0.034 Speedup
  sum:=sum+CRC32BUFSIZE;

  if sum>maxsize then //LAST PASS
    res:=CRC32BUFSIZE-(sum-maxsize);

  filestream.ReadBuffer(BufArray^,res);
  CRC32 := SZCRC32Update(BufArray,res,CRC32);

  r_:=HextL(crc32)+'-'+Inttohex(maxsize,0);
finally
  FileStream.Free;
  FreeMem(BufArray);
end;

result:=r_;
end;

function GetCRC32(FileName : widestring) : string;
var
  FileStream:Tgphugefilestream;  //0.034
begin                                                       //0.034
  Filestream:=Tgphugefilestream.Createw(Filename,accRead,[hfoBuffered],0,0,0,0,20,1048576*cachemultiplier,0); //1Mb BUFFER
  try
    Result := format('%.8x',[not DWORD(SZCRC32UpdateStream(FileStream, CRC32BASE))]);
  finally
    FileStream.Free;
  end;
end;

//MD5 & SHA-1-----------------------------------------------------------------

type
  HCRYPTPROV = ULONG;
  PHCRYPTPROV = ^HCRYPTPROV;
  HCRYPTKEY = ULONG;
  PHCRYPTKEY = ^HCRYPTKEY;
  HCRYPTHASH = ULONG;
  PHCRYPTHASH = ^HCRYPTHASH;
  LPAWSTR = PAnsiChar;
  ALG_ID = ULONG;

const
  CRYPT_NEWKEYSET = $00000008;
  PROV_RSA_FULL = 1;
  CALG_MD5 = $00008003;
  CALG_SHA1  = $00008004;
  HP_HASHVAL = $0002;

function CryptAcquireContext(phProv: PHCRYPTPROV;
  pszContainer: LPAWSTR;
  pszProvider: LPAWSTR;
  dwProvType: DWORD;
  dwFlags: DWORD): BOOL; stdcall;
  external ADVAPI32 name 'CryptAcquireContextA';

function CryptCreateHash(hProv: HCRYPTPROV;
  Algid: ALG_ID;
  hKey: HCRYPTKEY;
  dwFlags: DWORD;
  phHash: PHCRYPTHASH): BOOL; stdcall;
  external ADVAPI32 name 'CryptCreateHash';

function CryptHashData(hHash: HCRYPTHASH;
  const pbData: PBYTE;
  dwDataLen: DWORD;
  dwFlags: DWORD): BOOL; stdcall;
  external ADVAPI32 name 'CryptHashData';

function CryptGetHashParam(hHash: HCRYPTHASH;
  dwParam: DWORD;
  pbData: PBYTE;
  pdwDataLen: PDWORD;
  dwFlags: DWORD): BOOL; stdcall;
  external ADVAPI32 name 'CryptGetHashParam';

function CryptDestroyHash(hHash: HCRYPTHASH): BOOL; stdcall;
  external ADVAPI32 name 'CryptDestroyHash';

function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: DWORD): BOOL; stdcall;
  external ADVAPI32 name 'CryptReleaseContext';

function CalcHash(Stream: Tgphugefilestream; Algorithm: THashAlgorithm): string; overload;
const
  HASHBUFSIZE = 1048576*cachemultiplier;//1Mb
var
  hProv: HCRYPTPROV;
  hHash: HCRYPTHASH;
  Buffer: PByte;
  BytesRead: int64;
  Algid: ALG_ID;
  Data: array[1..20] of Byte; 
  DataLen: DWORD;
  Success: BOOL;
  i: integer;
  sum,maxsize:int64;
  tostop:boolean;
begin
  Result:= EmptyStr;
  Success := CryptAcquireContext(@hProv, nil, nil, PROV_RSA_FULL, 0);
  //
  Bytesread:=HASHBUFSIZE;
  sum:=0;
  maxsize:=stream.Size;
  tostop:=false;

  if (not Success) then
    if GetLastError() = DWORD(NTE_BAD_KEYSET) then
      Success := CryptAcquireContext(@hProv, nil, nil, PROV_RSA_FULL,
        CRYPT_NEWKEYSET);
  if Success then
  begin
    if Algorithm = haMD5 then
    begin
      Algid:= CALG_MD5;
      Datalen:= 16
    end else
    begin
      Algid:= CALG_SHA1;
      Datalen:= 20;
    end;
    if CryptCreateHash(hProv, Algid, 0, 0, @hHash) then
    begin                //0.034
      GetMem(Buffer,HASHBUFSIZE);
      try
        while TRUE do
        begin

          sum:=sum+HASHBUFSIZE;//0.034
          if sum>maxsize then begin

            if tostop=true then begin //LAST PASS
              if (CryptGetHashParam(hHash, HP_HASHVAL, @Data, @DataLen, 0)) then
                for i := 1 to DataLen do
                  Result := Result + Uppercase(IntToHex(Integer(Data[i]), 2));
              break;
            end
            else begin
              bytesread:=HASHBUFSIZE-(sum-maxsize);
              tostop:=true;
              stream.ReadBuffer(Buffer^, bytesread);
            end;
            if (not CryptHashData(hHash, Buffer, BytesRead, 0)) then
              break;

          end
          else begin
            stream.ReadBuffer(Buffer^, bytesread);
            if (not CryptHashData(hHash, Buffer, BytesRead, 0)) then
              break;
          end;
        end;
      finally
        FreeMem(Buffer);
      end;
      CryptDestroyHash(hHash);
    end;
    CryptReleaseContext(hProv, 0);
  end;
end;

function CalcHash(Archivo: widestring; Algorithm: THashAlgorithm): string; overload;
var
  Stream: Tgphugefilestream;
begin
  Result:= EmptyStr;
  if WideFileExists(archivo) then
  try
    Stream:= Tgphugefilestream.Createw(Archivo,accRead,[hfoBuffered],0,0,0,0,20,1048576*cachemultiplier,0);//1048576=1Mb*
    try
      Result:= CalcHash(Stream,Algorithm);
    finally
      Stream.Free;
    end;
  except
  end;
end;

initialization
  SZCRC32MakeTable;
end.

