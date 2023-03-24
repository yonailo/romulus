Unit Mymessages;

interface

uses
  Windows, SysUtils, Controls, Forms, ShellAPI, ComCtrls, Messages, Classes, Umessage, Strings, Graphics;

procedure mymessageerror(str:widestring);
function mymessagequestion(str:widestring;yestoall:boolean):integer;
procedure mymessagewarning(str:widestring);
procedure mymessageinfo(str:widestring);
procedure fixmymessagetext(str:widestring);
procedure mymessageinfomergesplit();

implementation

{ Iconindex

0:Warning
1:Question
2:Error
3:Info

}


procedure fixmymessagetext(str:widestring);
begin
insertrichtext(Fmessage.Richedit1,str,Fmessage.Richedit1.font.color);
end;

procedure mymessagewarning(str:widestring);
var
ico:Ticon;
begin
Application.CreateForm(TFmessage, Fmessage);
ico:=Ticon.Create;

Fmessage.Richedit1.Clear;
Fmessage.TntRichEdit1.Lines.add(str);

try
  Fmessage.ImageList1.GetIcon(0,ico);
  Fmessage.Image321.Bitmap.Assign(ico);
except
end;

ico.free;

Fmessage.ImageList1.Tag:=0;
Fmessage.Label1.Caption:=traduction(87);
Fmessage.BitBtn1.Visible:=false;
Fmessage.BitBtn3.Visible:=false;
Fmessage.BitBtn4.Visible:=false;
Fmessage.BitBtn2.left:=159;//Center button
Fmessage.BitBtn2.Caption:=traduction(80);

myshowform(Fmessage,true);

Freeandnil(Fmessage);
end;

function mymessagequestion(str:widestring;yestoall:boolean):integer;
var
res:integer;
ico:Ticon;
begin
Application.CreateForm(TFmessage, Fmessage);
ico:=Ticon.Create;

Fmessage.Richedit1.Clear;
Fmessage.TntRichEdit1.Lines.add(str);

try
  Fmessage.ImageList1.GetIcon(1,ico);
  Fmessage.Image321.bitmap.Assign(ico);
except
end;


ico.Free;
Fmessage.ImageList1.Tag:=1;
Fmessage.Label1.Caption:=traduction(88);

if yestoall=false then begin
  Fmessage.BitBtn1.Visible:=false;
  Fmessage.BitBtn4.Visible:=false;
end;

myshowform(Fmessage,true);

res:=Fmessage.Tag;
Freeandnil(Fmessage);
Result:=res;
end;

procedure mymessageinfo(str:widestring);
var
ico:Ticon;
begin
Application.CreateForm(TFmessage, Fmessage);
ico:=Ticon.create;

Fmessage.Richedit1.Clear;
Fmessage.TntRichEdit1.Lines.add(str);

try
  Fmessage.ImageList1.GetIcon(3,ico);
  Fmessage.Image321.bitmap.Assign(ico);
except
end;

ico.Free;

Fmessage.ImageList1.Tag:=3;
Fmessage.Label1.Caption:=traduction(89);
Fmessage.BitBtn1.Visible:=false;
Fmessage.BitBtn3.Visible:=false;
Fmessage.BitBtn4.Visible:=false;
Fmessage.BitBtn2.left:=159;//Center button
Fmessage.BitBtn2.Caption:=traduction(80);

myshowform(Fmessage,true);
Freeandnil(Fmessage);
end;

procedure mymessageerror(str:widestring);
var
ico:Ticon;
begin
Application.CreateForm(TFmessage, Fmessage);
ico:=Ticon.create;

Fmessage.Richedit1.Clear;
Fmessage.TntRichEdit1.Lines.add(str);

try
  Fmessage.ImageList1.GetIcon(2,ico);
  Fmessage.Image321.bitmap.Assign(ico);
except
end;

ico.Free;

Fmessage.ImageList1.Tag:=2;
Fmessage.Label1.Caption:=traduction(90);
Fmessage.BitBtn1.Visible:=false;
Fmessage.BitBtn3.Visible:=false;
Fmessage.BitBtn4.Visible:=false;
Fmessage.BitBtn2.left:=159;//Center button
Fmessage.BitBtn2.Caption:=traduction(80);

myshowform(Fmessage,true);
Freeandnil(Fmessage);
end;

procedure mymessageinfomergesplit();
var
str:widestring;
begin

str:=splitmergestring(0)+' : ';
str:=str+traduction(275)+#10#13;
str:=str+splitmergestring(1)+' : ';
str:=str+traduction(273)+#10#13;
str:=str+splitmergestring(2)+' : ';
str:=str+traduction(274)+#10#13;

mymessageinfo(str);
end;

end.