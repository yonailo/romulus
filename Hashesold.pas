Unit hashes;

interface

uses Windows, SysUtils, Classes, TntClasses, Tntsysutils, BufferedFileStream;

type
  Long = record
    LoWord: Word;
    HiWord: Word;
  end;

type
  THashAlgorithm = (haMD5, haSHA1);

function SZCRC32Update(P: Pointer; ByteCount: LongInt; CurCrc : DWORD): DWORD;
function SZCRC32UpdateStream(Stream : Tstream; CurCrc : DWORD) : DWORD;
function GetCRC32(FileName : widestring) : string;
function CalcHash(Archivo: widestring; Algorithm: THashAlgorithm): string; overload;
function CalcHash(Stream: Ttntfilestream; Algorithm: THashAlgorithm): string; overload;
Function StringToStream(const AString: string): TStream;
function HextL(l: longint): string;

implementation

const
  CRC32BASE: DWORD = $FFFFFFFF;

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

function SZCRC32Update(P: Pointer; ByteCount: LongInt; CurCrc : DWORD): DWORD;
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

function SZCRC32UpdateStream(Stream : Tstream; CurCrc : DWORD) : DWORD;
const
  CRC32BUFSIZE = 2048;//2048  
var
  BufArray : array[0..(CRC32BUFSIZE-1)] of Byte;
  Res   : LongInt;
  CRC32 : DWORD;
begin
  CRC32 := CurCrc;
  repeat

    Res := Stream.Read(BufArray, CRC32BUFSIZE);

    CRC32 := SZCRC32Update(@BufArray, Res, CRC32);

  until (Res <> int(CRC32BUFSIZE));
  Result:=CRC32
end;

function GetCRC32(FileName : widestring) : string;
var
  FileStream: TTntFileStream;
  //FileStream:TReadOnlyCachedFileStream;
begin
  //Filestream:=TReadOnlyCachedFileStream.Create(Filename,1024);
  FileStream := TTntFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);

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

function CalcHash(Stream: TTntfilestream; Algorithm: THashAlgorithm): string; overload;
var
  hProv: HCRYPTPROV;
  hHash: HCRYPTHASH;
  Buffer: PByte;
  BytesRead: DWORD;
  Algid: ALG_ID;
  Data: array[1..20] of Byte; 
  DataLen: DWORD;
  Success: BOOL;
  i: integer;
begin
  Result:= EmptyStr;
  Success := CryptAcquireContext(@hProv, nil, nil, PROV_RSA_FULL, 0);
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
    begin
      GetMem(Buffer,10*1024);
      try
        while  TRUE do
        begin
          BytesRead:= Stream.Read(Buffer^, 10*1024);
          if (BytesRead = 0) then
          begin
            if (CryptGetHashParam(hHash, HP_HASHVAL, @Data, @DataLen, 0)) then
              for i := 1 to DataLen do
                Result := Result + LowerCase(IntToHex(Integer(Data[i]), 2));
            break;
          end;
          if (not CryptHashData(hHash, Buffer, BytesRead, 0)) then
            break;
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
  Stream: TTntFileStream;
begin
  Result:= EmptyStr;
  if WideFileExists(archivo) then
  try
    Stream:= TTntFileStream.Create(Archivo,fmOpenRead or fmShareDenyWrite);
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

