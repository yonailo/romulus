unit UEncrypt;

interface

uses
  sysutils,forms;

var
  masterkey:string;

function Decrypt(S: AnsiString): AnsiString;
function Encrypt(S: AnsiString): AnsiString;
function Decryptnoserver(S: AnsiString): AnsiString;
function Encryptnoserver(S: AnsiString): AnsiString;

procedure generaterandomkey;

implementation

uses Classes;

function Crypt(Action:integer; Src: ansiString; key:string): ansiString;
Label
Lab;
var
KeyLen : Integer;
KeyPos : Integer;
OffSet : Integer;
Dest: String;
SrcPos : Integer;
SrcAsc : Integer;
TmpSrcAsc : Integer;
Range : Integer;
begin
if (Src = '') Then begin
Result:= '';
Goto Lab;
end;
Dest := '';
KeyLen := Length(key);
KeyPos := 0;
SrcPos := 0;
SrcAsc := 0;
Range := 256;
if Action = 0 then begin
Randomize;
OffSet := Random(Range);
Dest := Format('%1.2x',[OffSet]);
for SrcPos := 1 to Length(Src) do begin
  SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
  if KeyPos < KeyLen then KeyPos := KeyPos + 1 else KeyPos := 1;
  SrcAsc := SrcAsc Xor Ord(key[KeyPos]);
  Dest := Dest + Format('%1.2x',[SrcAsc]);
  OffSet := SrcAsc;
end;
end
Else
if Action = 1 then begin
  OffSet := StrToInt('$'+ copy(Src,1,2));
  SrcPos := 3;
  repeat
  SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));
  if (KeyPos < KeyLen) Then KeyPos := KeyPos + 1 else KeyPos := 1;
  TmpSrcAsc := SrcAsc Xor Ord(key[KeyPos]);
  if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
  else TmpSrcAsc := TmpSrcAsc - OffSet;
  Dest := Dest + Chr(TmpSrcAsc);
  OffSet := SrcAsc;
  SrcPos := SrcPos + 2;
  until (SrcPos >= Length(Src));
end;
Result := Dest;
Lab:
end;

function Decrypt(S: AnsiString): AnsiString;
begin
Result:=Crypt(1,S,masterkey);
end;

function Encrypt(S: AnsiString): AnsiString;
begin
Result:=Crypt(0,S,masterkey);
end;

function Decryptnoserver(S: AnsiString): AnsiString;
begin
Result:=Crypt(1,S,Application.MainForm.ClassName);
end;

function Encryptnoserver(S: AnsiString): AnsiString;
begin

Result:=Crypt(0,S,Application.MainForm.ClassName);
end;

procedure generaterandomkey;
var
str: string;
begin
Randomize;
//string with all possible chars
str    := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
masterkey := '';
repeat
  masterkey := masterkey + str[Random(Length(str)) + 1];
until (Length(masterkey) = 255)
end;

end.
