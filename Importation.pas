Unit Importation;

interface

uses
  Windows, SysUtils, Dialogs, Controls, Forms, Messages, Strings, ShellAPI, ComCtrls,
  Classes, Variants, ABSMain, DB, Unewdat,Udata, Graphics, Uupdatedat, TntSysutils,
  Tntclasses,gptextfile, Tntforms, Menus;
var

lastnewdatdecision:Shortint;
Tsets,Troms,TClones,Toffinfo,Tromsof,Tsampleof:Tabstable;
DBClones:TABSDatabase;
mamebuild:ansistring;
olregionlist:Tstringlist;
error:boolean;
datreader:TGpTextFile;
updateid:ansistring;
forzeversion:ansistring;
//Tregions:Tabstable;//0.050

function importdatpass(path:widestring;id:longint;offfilename:widestring):shortint;
function checkifisupdate(typ:string;firstid:longint):longint;
function parseolfilename(parser:widestring;title,editor,savetype,romnum,comments,language,region,source,space,langnum,crc:widestring):widestring;
function getline():widestring;
procedure extractbraketsandinfo(var str:widestring;var pr:widestring;var pr2:widestring;var aux:widestring);
function ollangnums(num:longint;isnum:boolean):ansistring;

implementation

uses GPHugeF;

function getline():widestring;
var
res:widestring;
begin
res:=datreader.Readln;

if datreader.Codepage=1252 then begin
  result:=UTF8Decode(res);
  if result<>'' then //FIX FOR WRONG CONVERSION
    res:=result;
end;
//TRIM 0.025 DIR2DAT BUG
result:=trim(res);
end;

procedure extractbraketsandinfo(var str:widestring;var pr:widestring;var pr2:widestring;var aux:widestring);
var
c,x,pos:integer;
m,rem:widestring;
finish:boolean;
begin
pr:=''; //0.026FIX
pr2:='';  //0.026FIX

//<TITLE></TITLE>
//<!-- -->
//<!--<nospace>

//FIX SINZE 0.024
while gettokencount(str,'<!--')>1 do begin

  finish:=false;
  m:=gettoken(str,'<!--',1);
  rem:='<!--';
  pos:=length(m)+5;

  //showmessage('ORIGIN>'+str);

  while finish=false do begin

    for x:=pos to length(str) do begin
      rem:=rem+str[x];
      if rem[Length(rem)]='>' then //-->
        if (rem[length(rem)-1]='-') AND (rem[length(rem)-2]='-') then begin
          finish:=true;
          break;
        end;
    end;


    str:=changein(str,rem,'');

    if finish=false then begin
      pos:=length(str)+1;
      rem:='';
      str:=str+getline;
    end;


  end;

  str:=trim(str); //FIX ONE LINE JUMP PROBLEM 0.026
end;

c:=gettokencount(str,'>');
case c of
  3:begin//NORMAL NO BREAK LINE
      pr:=gettoken(str,'>',1);
      pr:=gettoken(pr,'<',2);//<TITLE
      pr:=Wideuppercase(pr);
      pr2:=gettoken(str,'<',3);
      pr2:=gettoken(pr2,'>',1);
      pr2:=Wideuppercase(pr2);
      aux:=gettoken(str,'>',2);
      aux:=gettoken(aux,'<',1);
    end;
  2:begin//WITH BREAK LINE
      pr:=gettoken(str,'>',1);
      pr:=gettoken(pr,'<',2);//<TITLE
      pr:=Wideuppercase(pr);

      aux:=gettoken(str,'>',2);
      while gettokencount(aux,'<')=1 do
        aux:=aux+getline;

      pr2:=gettoken(aux,'<',2);
      pr2:=gettoken(pr2,'>',1);
      pr2:=Wideuppercase(pr2);

      aux:=gettoken(aux,'<',1);
    end;
end;

aux:=trim(aux);
pr:=trim(pr);
pr2:=trim(pr2);
str:=trim(str);
end;

procedure insertromsdata(setid:longint;romname:widestring;size,crc,md5,sha1:ansistring;typ:longint;merge,cloneof,romof,sampleof:ansistring);
var
x:longint;
cnt:integer;
romnametemp,exttemp:widestring;
isfirst:boolean;
begin
isfirst:=true;
x:=0;

if stsets.Count=0 then
  exit;

if romname='' then
  romname:='Unk';

if length(crc)<>8 then
  crc:='';

if length(md5)<>32 then
  if Toffinfo=nil then
    md5:='';

if length(sha1)<>40 then
  if Toffinfo=nil then
    sha1:='';

//0.033 FOLDERS FIX
if romname[Length(romname)]='\' then
  if ((crc<>'') AND (crc<>'00000000')) OR (md5<>'') OR (sha1<>'') OR (size<>'0') then
    romname:=copy(romname,1,length(romname)-1);
                       
crc:=Uppercase(crc);
md5:=Uppercase(md5);
sha1:=Uppercase(sha1);

if typ<>1 then //FIX IGNORE SAMPLE OF IF ROM IS NOT A SAMPLE FILE
  sampleof:='';

//FIX NO EXISTING EXTENSIONS
case typ of
  1:begin
      if gettokencount(romname,'.')>1 then begin
        if Length(gettoken(romname,'.',gettokencount(romname,'.')))>3 then //CONSIDERED NO EXT ADD IT
          romname:=romname+'.wav';
      end
      else //NO EXT ADD IT
        romname:=romname+'.wav';

      if sampleof<>'' then //FIX     //***stsets.strings[stsets.count-1]
        if (Wideuppercase(getwiderecord(Tsets.Fields[2]))=Wideuppercase(sampleof))then
          sampleof:='';//REMOVE REFERENCE TO SAMPLES BECAUSE ARE FROM CLONES OR ORIGINAL
  end;
  2:begin
      if gettokencount(romname,'.')>1 then begin      //0.026 always add .chd if not exists
        if Wideuppercase(gettoken(romname,'.',gettokencount(romname,'.')))<>'CHD' then //CONSIDERED NO EXT ADD IT
          romname:=romname+'.chd';
      end
      else //NO EXT ADD IT
        romname:=romname+'.chd';
  end;
end;

//Lenght of romname string
romname:=copy(romname,1,255);

cnt:=stroms.count;

stroms.add(inttostr(setid)+'*'+romname);

while stroms.count=cnt do begin //CHECKSUMS MUST BE DETECTED

  if isfirst=true then begin
    romnametemp:=romname;
    isfirst:=false;
    x:=-1;
  end
  else begin
    //0.026 FIX
    exttemp:=Wideextractfileext(romname);
    romnametemp:=filewithoutext(romname)+'_'+inttostr(x)+exttemp;
  end;

  if length(romnametemp)>255 then begin
    romname:='Unk';
    romnametemp:=romname;
    x:=-1;
  end;

  //0.026
  //Must locate if same checksum if same skip else add with other name
  if Troms.Locate('Romname;Setname',Vararrayof([romnametemp,setid]),[]) then
    if (Troms.fields[2].AsString=size) AND (Troms.fields[3].AsString=crc) AND (Troms.fields[4].AsString=md5) AND (Troms.fields[5].AsString=sha1) AND (Troms.fields[6].asinteger=typ) then
      exit;//IGNORE ALL NEXT CODE OK


  stroms.add(inttostr(setid)+'*'+romnametemp);

  if stroms.count<>cnt then
    romname:=romnametemp;

  x:=x+1;
end;

Troms.Append;

setwiderecord(Troms.Fields[1],romname); //Romname
Troms.Fields[2].asstring:= size;  //Space
Troms.Fields[3].asstring:=crc; //CRC
Troms.Fields[4].asstring:=md5; //MD5
Troms.Fields[5].asstring:=sha1; //SHA1
Troms.Fields[6].asinteger:=typ; //TYPE
Troms.fields[7].asinteger:=setid;//SETNAME
Troms.fieldbyname('Have').asboolean:=false; //HAVE
Troms.fields[8].asinteger:=setid; //SETNAMEMASTER
Troms.fieldbyname('Merge').asboolean:=false; //MERGE
Troms.fieldbyname('Dupe').asboolean:=false; //DUPE

Troms.Post;

//[Filename,Cloneof,Setname,Pos]

If (romof<>cloneof) AND (romof<>'') then begin //BIOS

  Tromsof.append;
                 //POS                      //ID
  Tromsof.fields[1].asinteger:=Troms.fields[0].asinteger;
  setwiderecord(Tromsof.fields[2],romname);//Filename
  setwiderecord(Tromsof.fields[3],romof);//Cloneof
  setwiderecord(Tromsof.fields[4],getwiderecord(Tsets.Fields[2])); //Setname

  Tromsof.post;

end;

if cloneof<>'' then begin //CLONES

  TClones.append;

  setwiderecord(Tclones.fields[2],romname); //Filename
                 //POS                            //ID
  Tclones.fields[1].asinteger:=Troms.fields[0].asinteger;
  setwiderecord(Tclones.fields[3],cloneof); //Cloneof
  setwiderecord(Tclones.fields[4],getwiderecord(Tsets.Fields[2])); //Setname

  Tclones.post;

  if (merge<>'') AND (merge<>romof) then begin

    Tclones.append;

    Tclones.fields[1].asinteger:=Troms.fields[0].asinteger;
    setwiderecord(Tclones.fields[2],merge);
    setwiderecord(Tclones.fields[3],cloneof);
    setwiderecord(Tclones.fields[4],getwiderecord(Tsets.Fields[2]));

    Tclones.post;

  end;

end;

if sampleof<>'' then begin //SAMPLES OF OTHER SETS NO CLONES

  Tsampleof.append;
                //POS                      //ID
  Tsampleof.fields[1].asinteger:=Troms.fields[0].asinteger;
  setwiderecord(Tsampleof.fields[2],romname);//Filename
  setwiderecord(Tsampleof.fields[3],sampleof);//Sampleof
  Tsampleof.fields[4].asstring:=crc;
  Tsampleof.fields[5].asstring:=md5;
  Tsampleof.fields[6].asstring:=sha1;
  Tsampleof.fields[7].asstring:=size;

  Tsampleof.post;

end;

{rowscounter:=rowscounter+1;
if rowscounter>100000 then begin
  rowscounter:=0;

  if Datamodule1.DBDatabase.InTransaction=true then begin
    Datamodule1.DBDatabase.Commit(false);
    Datamodule1.DBDatabase.StartTransaction;
  end;

end;     }

end;


procedure insertsetsdata(description,gamename:widestring);
var
x:integer;
cnt:integer;
gamenametemp:widestring;
begin
stroms.Clear;//0.037 FIX SPEEDUP
x:=0;

if gamename='' then
  gamename:='Unk';

if description='' then
  description:=gamename;

gamename:=Copy(gamename,1,255);

cnt:=stsets.count;

stsets.add(gamename); //DUPE DETECTION AND RENAMER

while stsets.count=cnt do begin

  gamenametemp:=gamename+'_'+inttostr(x);

  if length(gamenametemp)>255 then begin
    gamenametemp:='Unk';
    gamename:=gamenametemp;
    x:=-1;
  end;

  stsets.add(gamenametemp);

  if stsets.count<>cnt then
    gamename:=gamenametemp;

  x:=x+1;
end;

Tsets.Append;
setwiderecord(Tsets.Fields[1],description);
setwiderecord(Tsets.Fields[2],gamename);
Tsets.Post;   

posmessage2:='';
posmessage:=stsets.Count;
end;

//0.050
{procedure insertsetregion(region:widestring);
begin
Tregions.append;
Tregions.fields[1].asstring:=region;
Tregions.fields[2].asinteger:=Tsets.Fields[0].asinteger;
Tregions.Post;
end;   }

function checkifisupdate(typ:string;firstid:longint):longint;
var
res:longint;
begin

res:=firstid;
overwritedat:=0;
//if Datamodule1.Tprofiles.Locate('Name;Original',VarArrayOf([trim(Fnewdat.Edit9.Text),typ]),[loCaseInsensitive])=true then begin
if Datamodule1.Tprofiles.Locate('Name',trim(Fnewdat.Edit9.Text),[loCaseInsensitive])=true then begin

  DataModule1.Qaux.Close;
  Datamodule1.Qaux.SQL.Clear;
  Datamodule1.Qaux.SQL.add('SELECT * FROM Profiles,Tree');
  Datamodule1.Qaux.SQL.add('WHERE Tree.id=Profiles.tree');           //FIX LOCATION WHEN APOSTROPHES
  Datamodule1.Qaux.SQL.add('AND UPPER(Profiles.Name) = UPPER('+':p_'+')');
  //Datamodule1.Qaux.SQL.add('AND Original ='+''''+typ+'''');
  Datamodule1.Qaux.SQL.add('ORDER BY Profiles.Description');

  Datamodule1.Qaux.Params.Clear;
  Datamodule1.Qaux.Params.CreateParam(ftWideString,'p_',ptResult);

  Datamodule1.Qaux.Params[0].DataType := ftWideString;
  Datamodule1.Qaux.Params[0].Value:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Name'));

  Fupdatedat.executequery(false,false);

  if Datamodule1.Qaux.RecordCount>0 then begin

    overwritedat:=-1;
    
    Fupdatedat.Edit2.Text:=Fnewdat.Edit2.text;
    Fupdatedat.Edit9.text:=Fnewdat.edit9.text;
    Fupdatedat.Edit1.text:=Fnewdat.Edit1.text;
    Fupdatedat.Edit3.text:=Fnewdat.Edit3.text;
  
    if typ='O' then
      Fupdatedat.CheckBox2.Visible:=true;

    Fupdatedat.VirtualStringTree2.RootNodeCount:=Datamodule1.Qaux.RecordCount;
    
    if formexists('Fofflineupdate')=false then begin
      //AUTODECISION
      //SINZE 0.027
      if (Datamodule1.Qaux.RecordCount>1) AND (autodecision=2) then
        autodecision:=-1;                

      if autodecision=-1 then begin
        myshowform(Fupdatedat,true);
      end
      else
      if autodecision=1 then//IGNORE
        overwritedat:=0
      else
      if autodecision=2 then //OVERWRITE
        overwritedat:=Datamodule1.Qaux.fieldbyname('ID').asinteger;

      if (autodecision=1) OR (autodecision=2) then
        Fupdatedat.CheckBox1.Checked:=autodecisioncheck;
    end
    else begin
      overwritedat:=strtoint(updateid);
    end;

    Fnewdat.edit1.text:=Fupdatedat.Edit1.Text;

    if (overwritedat>0) AND (Fupdatedat.CheckBox1.Checked=true) then begin
      Datamodule1.Qaux.Locate('ID',overwritedat,[]);
      res:=Datamodule1.Qaux.fieldbyname('Tree').asinteger;
      if typ='O' then
        if Fupdatedat.CheckBox2.Checked then
          Fnewdat.edit10.Text:=getwiderecord(Datamodule1.Qaux.fieldbyname('Date'));
    end;

  end;

end;
Result:=res;
end;

procedure createsetsromsfields(id:ansistring;oll:boolean);
begin
Tsets.TableName:='TEMPY';

if overwritedat<=0 then  //NOT UPDATE
  Tsets.TableName:='Y'+fillwithzeroes(id,4);

Tsets.FieldDefs.Clear;

Tsets.FieldDefs.Add('ID',ftAutoInc,0,False);
Tsets.FieldDefs.Add('Description',ftwidestring,255,true);
Tsets.FieldDefs.Add('Gamename',ftwidestring,255,true);

Tsets.IndexDefs.Clear;
Tsets.IndexDefs.Add('Y1', 'ID', [ixPrimary]); //Speedup locate
Tsets.IndexDefs.Add('Y2', 'Gamename', []); //Need for locate clones

Tsets.CreateTable;
Tsets.Open;
Tsets.DisableControls;

Troms.TableName:='TEMPZ';

if overwritedat<=0 then  //NOT UPDATE
  Troms.TableName:='Z'+fillwithzeroes(id,4);

Troms.FieldDefs.Add('ID',ftAutoInc,0,False);
Troms.FieldDefs.Add('Romname',ftwidestring,255,true);
Troms.FieldDefs.Add('Space',ftCurrency,0,false);
Troms.FieldDefs.Add('CRC',ftString,8,false);
Troms.FieldDefs.Add('MD5',ftString,32,false);
Troms.FieldDefs.Add('SHA1',ftString,40,false);
Troms.FieldDefs.Add('Type',ftstring,1,true);
Troms.FieldDefs.Add('Setname',ftLargeint,0,true);
Troms.FieldDefs.Add('Setnamemaster',ftLargeint,0,true);
Troms.FieldDefs.Add('Have',ftBoolean,0,true);
Troms.FieldDefs.Add('Merge',Ftboolean,0,true);
Troms.FieldDefs.Add('Dupe',Ftboolean,0,true);

Troms.IndexDefs.Clear;
Troms.IndexDefs.Add('Z', 'ID', [ixPrimary]);
Troms.IndexDefs.Add('Z1', 'Setname', []); //NEEDED
Troms.IndexDefs.Add('Z2', 'Setnamemaster', []); //NEEDED
//IF CLONES
Troms.IndexDefs.Add('Z3', 'Romname;Setnamemaster;Setname',[]);
Troms.IndexDefs.Add('Z4', 'Romname;Setnamemaster',[]);
//IF SAMPLES
Troms.IndexDefs.Add('Z5', 'Romname;Setname',[]);
//Troms.IndexDefs.Add('Z6', 'Romname',[]);//0.025  REMOVED ???

Troms.CreateTable;
Troms.Open;
Troms.DisableControls;

Tclones.TableName:='CLONES';
Tclones.FieldDefs.Add('ID',ftAutoInc,0,False);
Tclones.FieldDefs.Add('Pos',ftLargeint,0,true);
Tclones.FieldDefs.Add('Filename',ftwidestring,255,true);
Tclones.FieldDefs.Add('Cloneof',ftwidestring,255,true);
Tclones.FieldDefs.Add('Setname',ftwidestring,255,true);

Tclones.IndexDefs.Clear;
Tclones.IndexDefs.Add('T', 'ID', [ixPrimary]);

Tclones.CreateTable;
Tclones.Open;
Tclones.DisableControls;

Tromsof.TableName:='ROMSOF';
Tromsof.FieldDefs.Add('ID',ftAutoInc,0,False);
Tromsof.FieldDefs.Add('Pos',ftLargeint,0,true);
Tromsof.FieldDefs.Add('Filename',ftwidestring,255,true);
Tromsof.FieldDefs.Add('Cloneof',ftwidestring,255,true);
Tromsof.FieldDefs.Add('Setname',ftwidestring,255,true);

Tromsof.IndexDefs.Clear;
Tromsof.IndexDefs.Add('T', 'ID', [ixPrimary]);

Tromsof.CreateTable;
Tromsof.Open;
Tromsof.DisableControls;

if oll=true then begin

  if overwritedat<=0 then  //NOT UPDATE
    Toffinfo.TableName:='O'+fillwithzeroes(id,4);

  Toffinfo.FieldDefs.Add('ID',ftAutoInc,0,False);
  Toffinfo.FieldDefs.Add('Description',ftwidestring,255,true);
  Toffinfo.FieldDefs.Add('Publisher',ftwidestring,255,false);
  Toffinfo.FieldDefs.Add('Savetype',ftwidestring,255,false);
  Toffinfo.FieldDefs.Add('Relnum',ftString,6,false);
  Toffinfo.FieldDefs.Add('Comment',ftwidestring,255,false);
  Toffinfo.FieldDefs.Add('Language',ftwidestring,255,false);
  Toffinfo.FieldDefs.Add('Location',ftwidestring,255,false);
  Toffinfo.FieldDefs.Add('Sourcerom',ftwidestring,255,false);
  Toffinfo.FieldDefs.Add('Langnum',ftwidestring,255,false);
  Toffinfo.FieldDefs.Add('Locationnum',ftinteger,0,true);
  Toffinfo.FieldDefs.Add('Setid',ftinteger,0,true);
  //publisher,savetype,relnum,comment,language,location,sourcerom,langnum
  Toffinfo.IndexDefs.Clear;
  Toffinfo.IndexDefs.Add('Y1', 'ID', [ixPrimary]); //Speedup locate
  Toffinfo.IndexDefs.Add('Y2', 'Setid', [ixUnique]); //Speedup locate 0.028

  Toffinfo.CreateTable;
  Toffinfo.Open;
  Toffinfo.DisableControls;
end;

//pos,Filename,sampleof,crc,md5,sha1,size
Tsampleof.TableName:='SAMPLES';

Tsampleof.FieldDefs.Add('ID',ftAutoInc,0,False);
Tsampleof.FieldDefs.Add('Pos',ftLargeint,0,true);
Tsampleof.FieldDefs.Add('Filename',ftwidestring,255,true);
Tsampleof.FieldDefs.Add('Sampleof',ftwidestring,255,true);
Tsampleof.FieldDefs.Add('CRC',ftString,8,False);
Tsampleof.FieldDefs.Add('MD5',ftString,32,False);
Tsampleof.FieldDefs.Add('SHA1',ftString,40,False);
Tsampleof.FieldDefs.Add('Space',ftCurrency,0,False);

Tsampleof.IndexDefs.Clear;
Tsampleof.IndexDefs.Add('T', 'ID', [ixPrimary]);

Tsampleof.CreateTable;
Tsampleof.Open;
Tsampleof.DisableControls;


//REGION 1G1R  0.050
{Tregions.TableName:='TEMPR';
if overwritedat<=0 then  //NOT UPDATE
  Tregions.TableName:='R'+fillwithzeroes(id,4);

Tregions.FieldDefs.Add('ID',ftAutoInc,0,False);
Tregions.FieldDefs.Add('Region',ftstring,3,false);
Tregions.FieldDefs.Add('Set',ftLargeint,255,true);

Tregions.IndexDefs.Clear;
Tregions.IndexDefs.Add('R1', 'ID', [ixPrimary]); //Speedup locate
Tregions.IndexDefs.Add('R2', 'Set', []); //Need for locate sets

Tregions.CreateTable;
Tregions.Open;
Tregions.DisableControls;  }

Datamodule1.DBDatabase.StartTransaction;
DBClones.StartTransaction;
end;

procedure delbiosclones;
var
hs1,hs2,hs3,hs4:ansistring;
begin
{
1- The master of this clone has bioses?
2- Get the bios gamename
3- Get the bios filename using gamename and Tclonesfilename
4- Get hashes of biosfilename found that is same of Tclonesfound
5- Comprare hashes with current Tclone and if same delete from Roms table
}
//1
//application.MainForm.Caption:=timetostr(now);
//SLOW

if Tromsof.Locate('Setname',getwiderecord(Tclones.fieldbyname('Cloneof')),[]) then
  //2
  if Tsets.Locate('Gamename',getwiderecord(Tromsof.fieldbyname('Cloneof')),[]) then
    //3 CAN DO WITH STROMS
    if Troms.locate('Romname;Setnamemaster;Setname',VarArrayOf([getwiderecord(Tclones.FieldByName('Filename')),Tsets.FieldByName('ID').asinteger,Tsets.FieldByName('ID').asinteger]),[]) then begin

      //4
      hs1:=Troms.fieldbyname('Space').asstring;
      hs2:=Troms.fieldbyname('CRC').asstring;
      hs3:=Troms.fieldbyname('MD5').asstring;
      hs4:=Troms.fieldbyname('SHA1').asstring;

      //5
      if Troms.Locate('ID',Tclones.fieldbyname('Pos').asinteger,[]) then
        if (Troms.fieldbyname('Space').asstring=hs1) AND (Troms.fieldbyname('CRC').asstring=hs2) AND (Troms.fieldbyname('MD5').asstring=hs3) AND (Troms.fieldbyname('SHA1').asstring=hs4) then begin
          //Troms.Delete; CHANGED SINCE 0.017
          Troms.edit;
          Troms.fieldbyname('merge').asboolean:=true;
          Troms.post;
        end;

    end;

end;

procedure breakrelation;
var
idmaster,idset:longint;
begin

idmaster:=Tsets.fieldbyname('ID').asinteger;

Tsets.locate('Gamename',getwiderecord(TClones.fieldbyname('Setname')),[]);
idset:=Tsets.fieldbyname('ID').asinteger;

//CONVERT ALL ROMS TO MASTER
While Troms.locate('Setname;Setnamemaster',VarArrayOf([idset,idmaster]),[]) do begin
  application.processmessages;

  Troms.edit;

  Troms.FieldByName('Setnamemaster').asinteger:=idset;
  Troms.fieldbyname('Merge').asboolean:=false;
  Troms.fieldbyname('Dupe').asboolean:=false;

  Troms.post;
end;

//SET TO LAST POS OF CLONES BIOS TABLE TO CONTINUE CHECKING
While (getwiderecord(TClones.FieldByName('Setname'))=getwiderecord(Tsets.fieldbyname('Gamename'))) do begin

  if TClones.Eof then
    break;

  application.processmessages;
  TClones.next;
end;

end;

procedure finalizeheader(uver,uup,uim:widestring;id:longint;dattype:string);
var
sets,roms,counter:int64;
rn:ansistring;
hasclones,splitmerge,splitnomerge:boolean;
fmode:shortint;
hs1,hs2,hs3,hs4:ansistring;
dupe,continue,breaked:boolean;
shareit,md5it,sha1it,tzit,t7zit,improms,impsamples,impchds:boolean;
headerfile:widestring;
begin
hasclones:=false;
splitmerge:=false;
splitnomerge:=false;

{
Tclones table [Filename,Cloneof,Setname,Pos]
Tromsof table [Filename,Cloneof,Setname,Pos] //ONLY MASTER SETNAME
}

//TEMPORAL SOLUTION TO OUT OF MEMORY 0.023
Fupdatedat.executequery(true,false); //COMMIT DB
Fupdatedat.executequery(true,true);

//Transaction again
if Datamodule1.DBDatabase.InTransaction=false then
  Datamodule1.DBDatabase.StartTransaction;

//Make clones relationship -----------------------------------------------------
posmessage2:='';
posmessage:=0;
counter:=0;

if TClones.RecordCount>0 then begin
  fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(426)+' ');
  posmessage2:=' / '+inttostr(Tclones.RecordCount);
  Tclones.First;
  hasclones:=true;//0.026 FIX SOFTLIST
end;

While Tclones.Eof=False do begin
  breaked:=false;
  application.processmessages;
{
Tclones.FieldDefs.Add('ID',ftAutoInc,0,False);
Tclones.FieldDefs.Add('Pos',ftLargeint,0,true);
Tclones.FieldDefs.Add('Filename',ftwidestring,255,true);
Tclones.FieldDefs.Add('Cloneof',ftwidestring,255,true);
Tclones.FieldDefs.Add('Setname',ftwidestring,255,true);
}

  posmessage:=counter;

  //1 FIND SETMASTER                                    //Cloneof
  if Tsets.Locate('Gamename',getwiderecord(Tclones.fields[3]),[]) then begin

    //2.1 LOCATE IF IS IN MASTER                                                         //Filename           //ID                    //ID
    if Troms.locate('Romname;Setnamemaster;Setname',VarArrayOf([getwiderecord(Tclones.Fields[2]),Tsets.Fields[0].asinteger,Tsets.Fields[0].asinteger]),[loCaseInsensitive]) then begin

      dupe:=true;
      //GET HASHES OF MASTER
      hs1:=Troms.fields[2].asstring; //Space
      hs2:=Troms.fields[3].asstring;//CRC
      hs3:=Troms.fields[4].asstring;//MD5
      hs4:=Troms.fields[5].asstring;//SHA1
                                            //pos
      if Troms.locate('ID',Tclones.fields[1].AsInteger,[])=true then begin

        //MERGE WITH DIFFERENT ROMNAME
        //Tclones table [Filename,Cloneof,Setname,Pos] //Romname                                     //Filename
        if Wideuppercase(getwiderecord(Troms.fields[1]))<>Wideuppercase(getwiderecord(Tclones.fields[2])) then
          dupe:=false;

        //3.1 COMPARE CHECKSUMS OF MASTER                 //CRC                                     //MD5                                        //SHA1
        if (Troms.fields[2].asstring=hs1) AND (Troms.fields[3].asstring=hs2) AND (Troms.fields[4].asstring=hs3) AND (Troms.fields[5].asstring=hs4) then begin
                     //Space
          try
          Troms.edit;    //Setnamemaster           //ID
          Troms.Fields[8].asinteger:=Tsets.fields[0].asinteger;
          Troms.Fields[11].asboolean:=dupe; //Dupe
          Troms.fields[10].asboolean:=true; //Merge
          Troms.post;
          except//PILLERIA
            makeexception;
            {try
              Troms.Cancel;
              Fupdatedat.executequery(true,false); //COMMIT DB
              Fupdatedat.executequery(true,true);
              Troms.edit;
              Troms.FieldByName('Setnamemaster').asinteger:=Tsets.fieldbyname('ID').asinteger;
              Troms.FieldByName('Dupe').asboolean:=dupe;
              Troms.fieldbyname('Merge').asboolean:=true;
              Troms.post;
            except
              makeexception;
            end;  }
          end;
          //Already if Tromsof original set to merge=true
        end
        else begin//3.2 BREAK ALL SET RELATIONSHIP

          breakrelation;

          breaked:=true;
        end;

      end;//POS LOCATE
      //else begin
      //  breaked:=true;//CHANGED
      //  Tclones.next;//CHANGED
      //end;
    end
    else begin//FOR BIOS SKIP
      //2.2 TRY TO FIND IN OTHER CLONE "NO MERGE BUT POSSIBLE DUPE"

      dupe:=false;
      continue:=true;
      //3.1 COMPARE CHECKSUMS OF OTHER FOUND CLONE                                     //Filename
      if Troms.Locate('Romname;Setnamemaster',VarArrayOf([getwiderecord(Tclones.fields[2]),Tsets.Fields[0].asinteger]),[]) then begin

        //GET HASHES OF CLONE
        hs1:=Troms.fields[2].asstring; //Space
        hs2:=Troms.fields[3].asstring;//CRC
        hs3:=Troms.fields[4].asstring;//MD5
        hs4:=Troms.fields[5].asstring;//SHA1
                                              //Pos
        if Troms.locate('ID',Tclones.fields[1].AsInteger,[])=true then begin

          //MERGE WITH DIFFERENT ROMNAME THEN NO DUPE
          //CHANGED
          if (Troms.fields[2].asstring=hs1) AND (Troms.fields[3].asstring=hs2) AND (Troms.fields[4].asstring=hs3) AND (Troms.fields[5].asstring=hs4) then
            dupe:=true
          else begin //3.2 BREAK ALL SET RELATIONSHIP

            breakrelation;
            continue:=false;
            breaked:=true;
          end;
                                                      //Romname                                       //Filename
          if Wideuppercase(getwiderecord(Troms.fields[1]))<>Wideuppercase(getwiderecord(Tclones.fields[2])) then
            dupe:=false;
              
        end;
        //else begin
        //  continue:=false;
        //  breaked:=true;//CHANGED
        //  Tclones.Next;//CHANGED
        //end;
      end;

      if continue=true then begin        //Pos
        Troms.locate('ID',Tclones.fields[1].AsInteger,[]);

        try
        Troms.edit;    //Setnamemaster
        Troms.Fields[8].asinteger:=Tsets.fields[0].asinteger;
        Troms.Fields[11].asboolean:=dupe; //Dupe
        Troms.post;
        except
          makeexception;
          {try
            Troms.Cancel;
            Fupdatedat.executequery(true,false); //COMMIT DB
            Fupdatedat.executequery(true,true);
            Troms.edit;
            Troms.FieldByName('Setnamemaster').asinteger:=Tsets.fieldbyname('ID').asinteger;
            Troms.FieldByName('Dupe').asboolean:=dupe;
            Troms.post;
          except
            makeexception;
          end;}
        end;
      end;

    end;

  end;//END FIND MASTER SET

  if breaked=false then
    Tclones.Next
  else
    counter:=Tclones.RecNo-1;

  counter:=counter+1;
end;//END TCLONESLOOP

//MERGE SAMPLES OF OTHER SETS -------------------------------------------------
posmessage2:='';
posmessage:=0;
counter:=0;

if Tsampleof.RecordCount>0 then begin
  fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(507)+' ');
  posmessage2:=' / '+inttostr(Tsampleof.RecordCount);
  Tsampleof.First;
end;

While Tsampleof.Eof=false do begin
  application.processmessages;
  posmessage:=counter;
  //Pos,Filename,sampleof,CRC,MD5,SHA1,Space

  //FIRST FIND ID ON SETS TABLE                            //Sampleof
  if Tsets.Locate('Gamename',getwiderecord(Tsampleof.fields[3]),[]) then         //Filename
    if Troms.locate('Romname;Setname',VarArrayOf([getwiderecord(Tsampleof.fields[2]),Tsets.Fields[0].asinteger]),[]) then //FOUND POSSIBLE DUPE SAMPLE
      if (Troms.Fields[3].asstring=Tsampleof.fields[4].AsString) AND (Troms.Fields[4].asstring=Tsampleof.fields[5].AsString) AND (Troms.Fields[5].asstring=Tsampleof.fields[6].AsString) AND (Troms.Fields[2].ascurrency=Tsampleof.fields[7].ascurrency) then
        if Troms.locate('ID',Tsampleof.fields[1].AsInteger,[]) then begin //Pos
          //ALL IS CORRECT THEN MERGE
          Troms.Edit;
          Troms.Fields[10].asboolean:=true; //Merge
          Troms.post;
        end;

  counter:=counter+1;

  Tsampleof.Next;
end;

//REMOVE OR MERGE BIOS RELATION IN CLONES PREPARE
{TClones.First;
While Tclones.Eof=false do begin
  //Locate Tclones if is in Tromsof
  getwiderecord(Tclones.fieldbyname('Cloneof'))
  Tclones.next;
end;        }

//REMOVE OR MERGE BIOS RELATION IN MASTER -------------------------------------------
posmessage2:='';
posmessage:=0;
counter:=0;

if Tromsof.RecordCount>0 then begin
  fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(427)+' ');
  posmessage2:=' / '+inttostr(Tromsof.RecordCount);
  Tromsof.First;
end;

//CAN BE OPTIMIZED FINDING WHEN MASTER BIOS TRY TO FIND ON CLONES USING LOCATE IN TCLONES FILENAME AND CLONEOF
While Tromsof.Eof=False do begin

  application.processmessages;
  posmessage:=counter;

  //FIND BIOS IN MASTER BIOS                              //Cloneof
  if Tsets.Locate('Gamename',getwiderecord(Tromsof.fields[3]),[]) then begin                 //Filename
    if Troms.locate('Romname;Setnamemaster;Setname',VarArrayOf([getwiderecord(Tromsof.Fields[2]),Tsets.Fields[0].asinteger,Tsets.Fields[0].asinteger]),[]) then begin

      hs1:=Troms.fields[2].asstring;//Space
      hs2:=Troms.fields[3].asstring; //CRC
      hs3:=Troms.fields[4].asstring;  //MD5
      hs4:=Troms.fields[5].asstring;  //SHA1
                                       //Pos
      Troms.Locate('ID',Tromsof.fields[1].asinteger,[]);

      if (Troms.fields[2].asstring=hs1) AND (Troms.fields[3].asstring=hs2) AND (Troms.fields[4].asstring=hs3) AND (Troms.fields[5].asstring=hs4) then begin
        //Troms.Delete; //merge????  //CHANGED SINCE 0.017
        Troms.edit;
        Troms.Fields[10].asboolean:=true;//Merge
        Troms.post;
      end;

    end;
  end;

  counter:=counter+1;

  Tromsof.Next;
end;

posmessage2:='';
posmessage:=0;
fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(428)+' ');

//REMOVE OR MERGE BIOS RELATION IN CLONES -----------------------------------------
//REM 0.025
{Tclones.first;

While not Tclones.Eof do begin
  application.processmessages;

  delbiosclones;

  if hasclones=false then
    if Troms.Locate('ID',Tclones.fieldbyname('Pos').asinteger,[])=true then
      if Troms.fieldbyname('Setname').asinteger<>Troms.fieldbyname('Setnamemaster').asinteger then
        hasclones:=true;

  Tclones.Next;
end;     }

DataModule1.Qaux.Close;
Datamodule1.Qaux.SQL.Clear;

Fupdatedat.executequery(true,false); //COMMIT DB

shareit:=defaultprofileshare;
md5it:=defmd5;
sha1it:=defsha1;
tzit:=deftz;
t7zit:=deft7z;

if overwritedat>0 then begin  //UPDATE
  DataModule1.Tprofiles.locate('ID',overwritedat,[]);
  shareit:=Datamodule1.Tprofiles.FieldByName('Shared').asboolean;
  md5it:=Datamodule1.Tprofiles.FieldByName('MD5').asboolean;
  sha1it:=Datamodule1.Tprofiles.FieldByName('SHA1').asboolean;
  tzit:=Datamodule1.Tprofiles.FieldByName('TZ').asboolean;
  t7zit:=Datamodule1.Tprofiles.FieldByName('T7Z').asboolean;
  headerfile:=getwiderecord(Datamodule1.Tprofiles.fieldbyname('Header')); //0.032
end;

//COUNT AS FILEMODE
fmode:=Datamodule1.Tprofiles.fieldbyname('Filemode').asinteger;

//CHANGED SINCE 0.017
If Troms.locate('Merge',true,[])=true then begin//FIX FORZED
  hasclones:=true;
  splitmerge:=true;
  splitnomerge:=true;
end
else
if hasclones=true then begin
  splitmerge:=true;
end;

//0 Always pass
if fmode>0 then
  if hasclones=false then
    fmode:=0
  else
  if fmode=2 then
    If splitnomerge=false then
      fmode:=0;

    
//KNOW IF ROMS SAMPLES OF CHDS
improms:=Troms.Locate('Type',0,[]);
impsamples:=Troms.Locate('Type',1,[]);
impchds:=Troms.Locate('Type',2,[]);

if Tclones.RecordCount>0 then begin //SPEED HACK NO CLONES ALLWAYS TOTAL SETS AND TOTAL ROMS SAME
  Tsets.close;
  Troms.close;

  rn:=getcounterfilemode(Tsets.TableName,Troms.TableName,fmode,false);

  sets:=strtoint64(gettoken(rn,'/',2));
  roms:=strtoint64(gettoken(rn,'/',4));
end
else begin
  sets:=Tsets.RecordCount;
  roms:=Troms.RecordCount;
end;

Tsets.close;
Troms.close;

//Replace old dat
if overwritedat>0 then begin

  fupdatedat.rewrite('');

  DataModule1.Tprofiles.edit;
  DataModule1.Tprofiles.FieldByName('Totalsets').asstring:='';  //Reset
  Datamodule1.Tprofiles.post;

  //Delete master
  Datamodule1.Qaux.Close;
  Datamodule1.Qaux.sql.Clear;
  Datamodule1.Qaux.SQL.Add('DROP TABLE Y'+fillwithzeroes(inttostr(overwritedat),4));
  Fupdatedat.executequery(false,true);
                 
  //Delete detail
  Datamodule1.Qaux.Close;
  Datamodule1.Qaux.sql.Clear;
  Datamodule1.Qaux.SQL.Add('DROP TABLE Z'+fillwithzeroes(inttostr(overwritedat),4));
  Fupdatedat.executequery(false,true);

  //Delete possible ollinfo
  Datamodule1.Qaux.Close;
  Datamodule1.Qaux.sql.Clear;
  Datamodule1.Qaux.SQL.Add('DROP TABLE O'+fillwithzeroes(inttostr(overwritedat),4));
  Fupdatedat.executequery(false,true);

  //rename master
  Tsets.Close;
  Datamodule1.Qaux.Close;
  Datamodule1.Qaux.sql.Clear;
  Datamodule1.Qaux.SQL.Add('ALTER TABLE TEMPY RENAME TO Y'+fillwithzeroes(inttostr(overwritedat),4)+';');
  Fupdatedat.executequery(false,true);

  //Rename detail
  Troms.close;
  Datamodule1.Qaux.Close;
  Datamodule1.Qaux.sql.Clear;
  Datamodule1.Qaux.SQL.Add('ALTER TABLE TEMPZ RENAME TO Z'+fillwithzeroes(inttostr(overwritedat),4)+';');
  Fupdatedat.executequery(False,true);

  //Rename possible ollinfo
  try
    Toffinfo.close;
    Datamodule1.Qaux.Close;
    Datamodule1.Qaux.sql.Clear;
    Datamodule1.Qaux.SQL.Add('ALTER TABLE TEMPO RENAME TO O'+fillwithzeroes(inttostr(overwritedat),4)+';');
    Fupdatedat.executequery(False,true);
  except
  end;

  Datamodule1.Qaux.Close;

  DataModule1.Tprofiles.edit;

  setwiderecord(Datamodule1.Tprofiles.FieldByName('Description'),Fnewdat.edit1.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Name'),Fnewdat.edit9.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Version'),Fnewdat.edit3.text);

  //OFFLINELIST SPECIAL FINISH
  if uver<>'' then begin
    setwiderecord(Datamodule1.Tprofiles.FieldByName('Date'),Fnewdat.edit10.text);
    setwiderecord(Datamodule1.Tprofiles.FieldByName('Descmask'),Fnewdat.tntedit1.text);
  end
  else
    setwiderecord(Datamodule1.Tprofiles.FieldByName('Date'),Fnewdat.edit4.text);

  if uver<>'' then
    setwiderecord(DataModule1.Tprofiles.fieldbyname('Author'),uver)
  else
    setwiderecord(DataModule1.Tprofiles.fieldbyname('Author'),Fnewdat.edit5.text);

  if uup<>'' then
    setwiderecord(DataModule1.Tprofiles.fieldbyname('Homeweb'),uup)
  else
    setwiderecord(Datamodule1.Tprofiles.FieldByName('Homeweb'),Fnewdat.edit7.text);

  if uim<>'' then
    setwiderecord(DataModule1.Tprofiles.fieldbyname('Email'),uim)
  else
    setwiderecord(Datamodule1.Tprofiles.FieldByName('Email'),Fnewdat.edit8.text);

  //0.032
  DataModule1.Tprofiles.FieldByName('Original').asstring:=dattype;

  setwiderecord(Datamodule1.Tprofiles.FieldByName('Category'),Fnewdat.edit6.text);
  DataModule1.Tprofiles.FieldByName('lastscan').asstring:='';
  DataModule1.Tprofiles.FieldByName('Havesets').asinteger:=0;
  DataModule1.Tprofiles.FieldByName('Haveroms').asstring:='';
  DataModule1.Tprofiles.FieldByName('Tree').asinteger:=id;

  //0.032 IF NEW DAT HAS NO HEADERFILE THEN USE THE LAST ONE IF EXISTS
  if overwritedat>0 then  //0.043
  if (getwiderecord(Datamodule1.Tprofiles.fieldbyname('header'))='') AND (headerfile<>'') then
    setwiderecord(Datamodule1.Tprofiles.FieldByName('header'),headerfile);

  Datamodule1.Tprofiles.post;

end
else  //SET BACKUP PATH FOR NEW PROFILE 0.020
  getbackuppathofid(DataModule1.Tprofiles.fieldbyname('ID').asinteger);

DataModule1.Tprofiles.edit;

if uver='' then
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Date'),Fnewdat.edit4.text);

DataModule1.Tprofiles.FieldByName('splitmerge').asboolean:=splitmerge;
DataModule1.Tprofiles.FieldByName('splitnomerge').asboolean:=splitnomerge;
DataModule1.Tprofiles.FieldByName('Filemode').asstring:=inttostr(fmode);
DataModule1.Tprofiles.FieldByName('Totalsets').asinteger:=sets;
DataModule1.Tprofiles.FieldByName('Totalroms').asinteger:=roms;
DataModule1.Tprofiles.FieldByName('Added').asdatetime:=now;
Datamodule1.Tprofiles.FieldByName('Shared').asboolean:=shareit;
Datamodule1.Tprofiles.FieldByName('MD5').asboolean:=md5it;
Datamodule1.Tprofiles.FieldByName('SHA1').asboolean:=sha1it;
Datamodule1.Tprofiles.FieldByName('TZ').asboolean:=tzit;
Datamodule1.Tprofiles.FieldByName('T7Z').asboolean:=t7zit;
Datamodule1.Tprofiles.FieldByName('hasroms').asboolean:=improms;
Datamodule1.Tprofiles.FieldByName('hassamples').asboolean:=impsamples;
Datamodule1.Tprofiles.FieldByName('haschds').asboolean:=impchds;
//setwiderecord(datamodule1.Tprofiles.FieldByName('header'),headerfile);

Datamodule1.Tprofiles.post;

end;

procedure insertheader(id:longint;typ:string;header:widestring);
begin

if overwritedat>0 then //UPDATE
  DataModule1.Tprofiles.locate('ID',overwritedat,[])
else begin
  DataModule1.Tprofiles.Append;
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Description'),Fnewdat.edit1.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Name'),Fnewdat.edit9.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Version'),Fnewdat.edit3.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Date'),Fnewdat.edit4.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Author'),Fnewdat.edit5.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Category'),Fnewdat.edit6.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Homeweb'),Fnewdat.edit7.text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Email'),Fnewdat.edit8.text);
  Datamodule1.Tprofiles.FieldByName('Filemode').asstring:=Fnewdat.getdeffilemode;
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Date'),Fnewdat.Edit10.Text);
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Descmask'),Fnewdat.tntedit1.Text);
  Datamodule1.Tprofiles.FieldByName('splitmerge').AsBoolean:=false;
  Datamodule1.Tprofiles.FieldByName('splitnomerge').AsBoolean:=false;
  Datamodule1.Tprofiles.FieldByName('MD5').AsBoolean:=false;
  Datamodule1.Tprofiles.FieldByName('SHA1').AsBoolean:=false;
  Datamodule1.Tprofiles.FieldByName('TZ').AsBoolean:=false;
  Datamodule1.Tprofiles.FieldByName('IMG').AsBoolean:=true;

  Datamodule1.Tprofiles.FieldByName('Original').asstring:=typ;
  setwiderecord(Datamodule1.Tprofiles.FieldByName('Header'),header);
  Datamodule1.Tprofiles.FieldByName('Tree').asinteger:=id;
  DataModule1.Tprofiles.post;

end;

end;

procedure createsetsromstables;
begin
Tsets:=TABSTable.Create(Datamodule1);
Tsets.DatabaseName:=DataModule1.DBDatabase.DatabaseName;
Tsets.FieldDefs.Clear;
Tsets.DisableControls;

Troms:=TABSTable.Create(Datamodule1);
Troms.DatabaseName:=DataModule1.DBDatabase.DatabaseName;
Troms.FieldDefs.Clear;
Troms.DisableControls;

DBClones:=TABSDatabase.Create(datamodule1);
DBClones.DatabaseName:='Clones';
DBClones.DatabaseFileName:=UTF8Encode(tempdirectoryresources+'clones.rmt');
DeleteFile(UTF8Decode(DBClones.DatabaseFileName));
DBClones.CreateDatabase;
DBClones.MaxConnections:=defmaxconnections;
DBClones.SilentMode:=true;

Tclones:=Tabstable.Create(datamodule1);
Tclones.DatabaseName:=DBClones.DatabaseName;
Tclones.FieldDefs.Clear;
Tclones.DisableControls;

Tromsof:=Tabstable.Create(datamodule1);
Tromsof.DatabaseName:=DBClones.DatabaseName;
Tromsof.FieldDefs.Clear;
Tromsof.DisableControls;

Tsampleof:=Tabstable.Create(datamodule1);
Tsampleof.DatabaseName:=DBClones.DatabaseName;
Tsampleof.FieldDefs.Clear;
Tsampleof.DisableControls;

//0.050
{
Tregions:=Tabstable.Create(datamodule1);
Tregions.DatabaseName:=DataModule1.DBDatabase.DatabaseName;
Tregions.FieldDefs.Clear;
Tregions.DisableControls;  }
end;

function parsehs(path:widestring;idtree:longint):integer;
var
str,pr,pr2:widestring;
gamename,romname,merge,description,size,crc,md5,sha1,aux,cloneof,romof,sampleof,addition:widestring;
init,ending,pass,typ:longint;
res:shortint;
softlist,insertedset:boolean;
header:widestring;
begin
pass:=0;
res:=0;
cloneof:='';
error:=false;
insertedset:=false;

if Tsets=nil then   //CREATE TABLES IF NOT EXISTS
  createsetsromstables;

Fnewdat.Label1.caption:=traduction(96);

while datreader.EOF=false do begin //Header start detection
  str:=getline;

  pr:=str;

  aux:=str;
  application.processmessages;
  str:=Wideuppercase(trim(str));

  if str='<HEADER>' then begin
    pass:=1;
    break;
  end;

end;

if pass=1 then begin//Process header
  Fnewdat.setimagetype('N',Fnewdat.Image3210);
  Fnewdat.setimagetype('N',Fupdatedat.image323);

  while datreader.EOF=false do begin
    str:=getline;

    application.processmessages;

    extractbraketsandinfo(str,pr,pr2,aux);

    aux:=fixxmlseparators(aux);

    //0.043
    if (aux='') AND (pr2='') then begin//CLRMAMEPRO HEADER="xxx.xml"/
      aux:=pr;
      pr:=gettoken(pr,'=',1);//CLRMAMEPRO HEADER
      aux:=copy(aux,length(pr)+2,length(aux));
      aux:=Changein(aux,'"','');
      aux:=changein(aux,'\','');
      aux:=changein(aux,'/','');
    end;

    if (pr='LISTNAME') AND (pr2='/LISTNAME') then begin
      Fnewdat.edit9.text:=aux;
      if Fnewdat.Edit1.Text='' then
        Fnewdat.Edit1.Text:=aux;
    end
    else
    if (pr='LISTVERSION') AND (pr2='/LISTVERSION') then begin
      Fnewdat.edit3.text:=aux
    end
    else
    if (pr='LASTLISTUPDATE') AND (pr2='/LISTLISTUPDATE') then begin
      Fnewdat.edit4.text:=aux
    end
    else                           //XML WITHOUT INFO 0.045
    if (pr='/HEADER') OR ((pr=']') AND (pr2='')) then begin
      Fnewdat.edit2.Text:=WideExtractfilename(path);

      if Fnewdat.edit1.text='' then //0.045
        Fnewdat.Edit1.Text:=filewithoutext(WideExtractfilename(path));
      if Fnewdat.Edit9.text='' then
        Fnewdat.Edit9.Text:=filewithoutext(WideExtractfilename(path));

      if Fnewdat.edit9.text<>'' then begin
        if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall
          myshowform(Fnewdat,true);
          lastnewdatdecision:=Fnewdat.tag;
        end;

        pass:=2;
      end;

      break;
    end;
  end;
end;

if (lastnewdatdecision=0) OR (lastnewdatdecision=3) then begin//No or nottoall
  if pass=2 then
    res:=2;
end;


//UPDATE DB
if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then begin

  insertheader(idtree,'N',header);

  createsetsromsfields(Datamodule1.Tprofiles.FieldByName('ID').asstring,false);
end;

fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(425)+' ');

if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then  //Yes or yestoall
  while datreader.EOF=false do begin

    str:=getline;
    //showmessage(stR);

    application.processmessages;

    extractbraketsandinfo(str,pr,pr2,aux);

    romname:='';
    merge:='';
    size:='0';
    crc:='';
    md5:='';
    sha1:='';

    if (pr='DESCRIPTION') AND (pr2='/DESCRIPTION') then begin
      description:=fixxmlseparators(aux);
      {gamename:=removeconflictchars2(fixxmlseparators(gamename),true);

      insertsetsdata(description+addition ,gamename);
      insertedset:=true; //0.034   }
    end
    else                                               //NEW MAME ENTRY SINZE 0.162
    if (pr='/GAME') OR (pr='/SOFTWARE') OR (pr='/MACHINE') then begin
      description:='';
      gamename:='';
      cloneof:='';
      romof:='';
      sampleof:='';
      insertedset:=false;  //0.034
    end
    else begin   //GAME SOFTWARE MACHINE     //ROM SAMPLE DISK
      aux:=gettoken(pr,' ',1);
      if (aux='ROM') OR (aux='SAMPLE') OR (aux='DISK') then begin

        typ:=0;

        if aux='SAMPLE' then
          typ:=1
        else
        if aux='DISK' then
          typ:=2;

        while gettokencount(str,'="')>=2 do begin

          pr:=gettoken(str,'="',1);
          init:=length(pr)+3;
          if pr[1]='<' then
            pr:=copy(pr,2,length(pr));

          aux:=gettoken(str,'"',2);
          ending:=length(aux);
          aux:=trim(aux);

          str:=copy(str,init+ending+2,length(str));
          pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
          pr:=Wideuppercase(trim(pr));

          if pr='NAME' then begin
            romname:=aux;
          end
          else
          if pr='SIZE' then begin
            size:=aux;
            try
              size:=inttostr(strtoint64(size))
            except
              size:='0';
            end;
          end
          else
          if pr='CRC' then
            crc:=aux
          else
          if pr='MD5' then
            md5:=aux
          else
          if pr='SHA1' then
            sha1:=aux
          else
          if pr='MERGE' then
            merge:=aux;

        end;  //WHILE="

        //NOW SAVE ROM INFO
        if (romname<>'') then begin
          romname:=removeconflictchars(fixxmlseparators(romname),true);
          merge:=removeconflictchars(fixxmlseparators(merge),true);

          if (merge<>'') then
            if typ=2 then
              merge:=merge+'.chd';

          if insertedset=false then begin //0.034
            gamename:=removeconflictchars2(fixxmlseparators(gamename),true);

            if description='' then
              description:=gamename;

            insertsetsdata(description+addition ,gamename);
            showmessage(gamename);
            insertedset:=true;
          end;

          insertromsdata(stsets.Count,romname,size,crc,md5,sha1,typ,merge,cloneof,romof,sampleof);
          merge:='';
        end;

      end
      else
      if (aux='GAME') OR (aux='SOFTWARE') OR (aux='MACHINE') then begin
        while gettokencount(str,'="')>=2 do begin

          pr:=gettoken(str,'="',1);
          init:=length(pr)+3;
          if pr[1]='<' then
            pr:=copy(pr,2,length(pr));

          aux:=gettoken(str,'"',2);
          ending:=length(aux);
          aux:=trim(aux);

          str:=copy(str,init+ending+2,length(str));
          pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
          pr:=Wideuppercase(trim(pr));

          if pr='NAME' then begin
            gamename:=aux;
          end
          else
          if pr='CLONEOF' then begin
            cloneof:=aux;
            cloneof:=removeconflictchars(fixxmlseparators(cloneof),false);
          end
          else
          if pr='ROMOF' then begin
            romof:=aux;
            romof:=removeconflictchars(fixxmlseparators(romof),false);
          end
          else
          if pr='SAMPLEOF' then begin
            sampleof:=aux;
            sampleof:=removeconflictchars(fixxmlseparators(sampleof),false);
          end;

        end;

        //INSERT SET INFORMATION
      end
      else
      if aux='SOFTWARELIST' then begin//SOFTWARE LIST 0.029
        if stsofts.Count>1 then
          while gettokencount(str,'="')>=2 do begin

            pr:=gettoken(str,'="',1);
            init:=length(pr)+3;
            if pr[1]='<' then
              pr:=copy(pr,2,length(pr));

            aux:=gettoken(str,'"',2);
            ending:=length(aux);
            aux:=trim(aux);

            str:=copy(str,init+ending+2,length(str));
            pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
            pr:=Wideuppercase(trim(pr));

            if pr='DESCRIPTION' then begin
              addition:=aux;
              if addition<>'' then begin
                removeconflictchars(fixxmlseparators(addition),false);
                addition:=' - '+addition;
              end;
            end;
          end;
      end;//SOFTWARELIST

    end;

  end;//While eof

if ((stroms.count>0) AND (stsets.count>0) AND (error=false)) OR ((pass=2) AND (res=0) AND (error=false)) then begin
  if softlist=false then
    finalizeheader('','','',idtree,'X')
  else
    finalizeheader('','','',idtree,'S');

  res:=1;
end;

{else       //HEADER PASSED BUT NO SETS FOUND
if (pass=2) AND (res=0) AND (error=false) then begin
  res:=3;
end;     }

Result:=res;
end;

function parsecmxml(path:widestring;idtree:longint):integer;
var
str,pr,pr2:widestring;
gamename,romname,merge,description,size,crc,md5,sha1,aux,cloneof,romof,sampleof,addition:widestring;
init,ending,pass,typ:longint;
res:shortint;
softlist,insertedset:boolean;
header:widestring;
region:widestring;
begin
softlist:=false;
pass:=0;
res:=0;
cloneof:='';
error:=false;
insertedset:=false;
createsetsromstables;

Fnewdat.Label1.caption:=traduction(96);
if (forzeversion<>'') then
  Fnewdat.Edit3.Text:=forzeversion;

if mamebuild<>'' then
  pass:=2;

if pass=0 then

  while datreader.EOF=false do begin //Header start detection
    str:=getline;
    pr:=str;

    aux:=str;
    application.processmessages;
    str:=Wideuppercase(trim(str));

    {if str='<MENU>' then begin  //HYPERSPIN REMOVED
      parsehs(path,idtree);
      break;
    end
    else   }
    if str='<HEADER>' then begin
      pass:=1;
      break;
    end
    else begin  //0.045
      str:=gettoken(str,' ',1);
      if (str='<!ELEMENT') OR (str='<!DOCTYPE') then begin
        pass:=1;
        break;
      end;

    end;

    try //Softwarelist

      str:=gettoken(str,' ',1);
      //showmessage(str);
      if str[1]='<' then begin
        str:=copy(str,2,length(str));
        str:=trim(str);

        if str='SOFTWARELIST' then begin
          pass:=1;
          softlist:=true;
          break;
        end;

      end;

    except
    end;

  end;

if stsofts.Count>0 then begin //0.029 NEW SOFTLIST PARAMS SINZE MAME 0.162
  softlist:=true;
  Fnewdat.edit2.Text:=WideExtractfilename(path);
  Fnewdat.setimagetype('S',Fnewdat.Image3210);
  Fnewdat.setimagetype('S',Fupdatedat.Image323);

  if stsofts.Count=1 then begin
    Fnewdat.Edit9.Text:=gettoken(stsofts.Strings[0],#10#13,2);  //NAME
    Fnewdat.Edit1.Text:=gettoken(stsofts.Strings[0],#10#13,1); //DESCRIPTION
  end
  else begin //SOFTLIST SELECTION MODE
    Fnewdat.Edit9.Text:='Softwarelists MAME based EXE';  //NAME
    Fnewdat.Edit1.Text:='Softwarelists ('+inttostr(stsofts.Count)+') systems = '+gettoken(stsofts.Strings[0],#10#13,1)+' ... '+gettoken(stsofts.Strings[stsofts.count-1],#10#13,1); //DESCRIPTION
  end;

  if (lastnewdatdecision<=1) then begin//Already selected yestoall or nottoall
    Fnewdat.Label1.caption:=traduction(278);
    myshowform(Fnewdat,true);
    lastnewdatdecision:=Fnewdat.tag;
  end;

  datreader.Reset;
  //Reset to first text possition

  pass:=2;
end
else
if softlist=true then begin
  Fnewdat.edit2.Text:=WideExtractfilename(path);
  Fnewdat.setimagetype('S',Fnewdat.Image3210);
  Fnewdat.setimagetype('S',Fupdatedat.Image323);

  for init:=0 to 1 do begin

    str:=gettoken(aux,'=',init+1);
    str:=gettoken(str,' ',init+2);
    str:=trim(str);

    if Wideuppercase(str)='NAME' then begin
      Fnewdat.Edit9.Text:=fixxmlseparators(gettoken(aux,'"',2+init+init));
      if Fnewdat.edit1.Text='' then
        Fnewdat.Edit1.Text:=Fnewdat.Edit9.Text;
    end
    else
    if Wideuppercase(str)='DESCRIPTION' then
      Fnewdat.Edit1.Text:=fixxmlseparators(gettoken(aux,'"',2+init+init))

  end;

  if Fnewdat.edit9.text<>'' then begin
    if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall
      Fnewdat.Label1.caption:=traduction(278);
      myshowform(Fnewdat,true);
      lastnewdatdecision:=Fnewdat.tag;
    end;

    pass:=2;
  end;

end
else
if pass=1 then begin//Process header
  Fnewdat.setimagetype('X',Fnewdat.Image3210);
  Fnewdat.setimagetype('X',Fupdatedat.image323);

  while datreader.EOF=false do begin
    str:=getline;

    application.processmessages;

    extractbraketsandinfo(str,pr,pr2,aux);

    aux:=fixxmlseparators(aux);

    //0.043
    if (aux='') AND (pr2='') then begin//CLRMAMEPRO HEADER="xxx.xml"/
      aux:=pr;
      pr:=gettoken(pr,'=',1);//CLRMAMEPRO HEADER
      aux:=copy(aux,length(pr)+2,length(aux));
      aux:=Changein(aux,'"','');
      aux:=changein(aux,'\','');
      aux:=changein(aux,'/','');
    end;

    if (pr='NAME') AND (pr2='/NAME') then begin
      Fnewdat.edit9.text:=aux;
      if Fnewdat.Edit1.Text='' then
        Fnewdat.Edit1.Text:=aux;
    end
    else
    if (pr='DESCRIPTION') AND (pr2='/DESCRIPTION') then begin
      Fnewdat.edit1.text:=aux
    end
    else
    if (pr='VERSION') AND (pr2='/VERSION') then begin
      Fnewdat.edit3.text:=aux
    end
    else
    if (pr='DATE') AND (pr2='/DATE') then begin
      Fnewdat.edit4.text:=aux
    end
    else
    if (pr='CATEGORY') AND (pr2='/CATEGORY') then begin
      Fnewdat.edit6.text:=aux
    end
    else
    if (pr='AUTHOR') AND (pr2='/AUTHOR') then begin
      Fnewdat.edit5.text:=aux
    end
    else
    if (pr='HOMEPAGE') AND (pr2='/HOMEPAGE') then begin
      Fnewdat.edit7.text:=aux
    end
    else
    if (pr='EMAIL') AND (pr2='/EMAIL') then begin
      Fnewdat.edit8.text:=aux
    end
    else
    if (pr='HEADERFILE') AND (pr2='/HEADERFILE') then begin
      header:=aux;
    end
    else
    if pr='CLRMAMEPRO HEADER' then begin
      header:=aux;
    end
    else                           //XML WITHOUT INFO 0.045
    if (pr='/HEADER') OR ((pr=']') AND (pr2='')) then begin
      Fnewdat.edit2.Text:=WideExtractfilename(path);

      if Fnewdat.edit1.text='' then //0.045
        Fnewdat.Edit1.Text:=filewithoutext(WideExtractfilename(path));
      if Fnewdat.Edit9.text='' then
        Fnewdat.Edit9.Text:=filewithoutext(WideExtractfilename(path));

      if Fnewdat.edit9.text<>'' then begin
        if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall
          myshowform(Fnewdat,true);
          lastnewdatdecision:=Fnewdat.tag;
        end;

        pass:=2;
      end;

      break;
    end;
  end;
end;

if mamebuild<>'' then begin//MAME EXTRACT EXE
  Fnewdat.setimagetype('X',Fnewdat.Image3210);
  Fnewdat.setimagetype('X',Fupdatedat.Image323);
  Fnewdat.edit9.text:=gettoken(mamebuild,' ',1);
  Fnewdat.edit1.text:=mamebuild;
  Fnewdat.edit3.text:=mamebuild;

  Fnewdat.edit2.Text:=WideExtractfilename(path);

  if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall
    myshowform(Fnewdat,true);
    lastnewdatdecision:=Fnewdat.tag;
  end;

  pass:=2;
end;

if (lastnewdatdecision=0) OR (lastnewdatdecision=3) then begin//No or nottoall
  if pass=2 then
    res:=2;
end
else//Yes yesall
  if pass=2 then begin

    if softlist=false then
      idtree:=checkifisupdate('X',idtree)
    else
      idtree:=checkifisupdate('S',idtree);

    if overwritedat=-1 then
      res:=2; //Skip

  end;

//UPDATE DB
if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then begin
  if softlist=false then
    insertheader(idtree,'X',header)
  else
    insertheader(idtree,'S',header);     

  createsetsromsfields(Datamodule1.Tprofiles.FieldByName('ID').asstring,false);
end;

fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(425)+' ');

if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then  //Yes or yestoall
  while datreader.EOF=false do begin

    str:=getline;

    application.processmessages;

    extractbraketsandinfo(str,pr,pr2,aux);

    romname:='';
    merge:='';
    size:='0';
    crc:='';
    md5:='';
    sha1:='';

    if (pr='DESCRIPTION') AND (pr2='/DESCRIPTION') then begin
      description:=fixxmlseparators(aux);
      {gamename:=removeconflictchars2(fixxmlseparators(gamename),true);

      insertsetsdata(description+addition ,gamename);
      insertedset:=true; //0.034   }
    end
    else                                               //NEW MAME ENTRY SINZE 0.162
    if (pr='/GAME') OR (pr='/SOFTWARE') OR (pr='/MACHINE') then begin
      //SAVE REGION 0.050
      //if region<>'' then
      //  insertsetregion(region);

      region:='';
      description:='';
      gamename:='';
      cloneof:='';
      romof:='';
      sampleof:='';
      insertedset:=false;  //0.034
    end
    else begin   //GAME SOFTWARE MACHINE     //ROM SAMPLE DISK
      aux:=gettoken(pr,' ',1);
      if (aux='ROM') OR (aux='SAMPLE') OR (aux='DISK') then begin

        typ:=0;

        if aux='SAMPLE' then
          typ:=1
        else
        if aux='DISK' then
          typ:=2;

        while gettokencount(str,'="')>=2 do begin

          pr:=gettoken(str,'="',1);
          init:=length(pr)+3;
          if pr[1]='<' then
            pr:=copy(pr,2,length(pr));

          aux:=gettoken(str,'"',2);
          ending:=length(aux);
          aux:=trim(aux);

          str:=copy(str,init+ending+2,length(str));
          pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
          pr:=Wideuppercase(trim(pr));

          if pr='NAME' then begin
            romname:=aux;
          end
          else
          if pr='SIZE' then begin
            size:=aux;
            try
              size:=inttostr(strtoint64(size))
            except
              size:='0';
            end;
          end
          else
          if pr='CRC' then
            crc:=aux
          else
          if pr='MD5' then
            md5:=aux
          else
          if pr='SHA1' then
            sha1:=aux
          else
          if pr='MERGE' then
            merge:=aux;

        end;  //WHILE="

        //NOW SAVE ROM INFO
        if (romname<>'') then begin
          romname:=removeconflictchars(fixxmlseparators(romname),true);
          merge:=removeconflictchars(fixxmlseparators(merge),true);

          if (merge<>'') then
            if typ=2 then
              merge:=merge+'.chd';

          if insertedset=false then begin //0.034
            gamename:=removeconflictchars2(fixxmlseparators(gamename),true);

            if description='' then
              description:=gamename;

            insertsetsdata(description+addition ,gamename);
            insertedset:=true;
          end;

          insertromsdata(stsets.Count,romname,size,crc,md5,sha1,typ,merge,cloneof,romof,sampleof);
          merge:='';
        end;

      end
      else
      if (aux='GAME') OR (aux='SOFTWARE') OR (aux='MACHINE') then begin
        while gettokencount(str,'="')>=2 do begin

          pr:=gettoken(str,'="',1);
          init:=length(pr)+3;
          if pr[1]='<' then
            pr:=copy(pr,2,length(pr));

          aux:=gettoken(str,'"',2);
          ending:=length(aux);
          aux:=trim(aux);

          str:=copy(str,init+ending+2,length(str));
          pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
          pr:=Wideuppercase(trim(pr));

          if pr='NAME' then begin
            gamename:=aux;

          end
          else
          if pr='CLONEOF' then begin
            cloneof:=aux;
            cloneof:=removeconflictchars(fixxmlseparators(cloneof),false);
          end
          else
          if pr='ROMOF' then begin
            romof:=aux;
            romof:=removeconflictchars(fixxmlseparators(romof),false);
          end
          else
          if pr='SAMPLEOF' then begin
            sampleof:=aux;
            sampleof:=removeconflictchars(fixxmlseparators(sampleof),false);
          end;

        end;

        //INSERT SET INFORMATION
      end
      else
      if aux='SOFTWARELIST' then begin//SOFTWARE LIST 0.029
        if stsofts.Count>1 then
          while gettokencount(str,'="')>=2 do begin

            pr:=gettoken(str,'="',1);
            init:=length(pr)+3;
            if pr[1]='<' then
              pr:=copy(pr,2,length(pr));

            aux:=gettoken(str,'"',2);
            ending:=length(aux);
            aux:=trim(aux);

            str:=copy(str,init+ending+2,length(str));
            pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
            pr:=Wideuppercase(trim(pr));

            if pr='DESCRIPTION' then begin
              addition:=aux;
              if addition<>'' then begin
                removeconflictchars(fixxmlseparators(addition),false);
                addition:=' - '+addition;
              end;
            end;
          end;
      end;//SOFTLIST
      {else
      if aux='RELEASE' then begin //1G1R 0.050
        while gettokencount(str,'="')>=2 do begin

          pr:=gettoken(str,'="',1);
          init:=length(pr)+3;
          if pr[1]='<' then
            pr:=copy(pr,2,length(pr));

          aux:=gettoken(str,'"',2);
          ending:=length(aux);
          aux:=trim(aux);

          str:=copy(str,init+ending+2,length(str));
          pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
          pr:=Wideuppercase(trim(pr));

          if pr='REGION' then begin
            region:=aux;
          end;

        end;

      end;}

    end;

  end;//While eof

if ((stroms.count>0) AND (stsets.count>0) AND (error=false)) OR ((pass=2) AND (res=0) AND (error=false)) then begin
  if softlist=false then
    finalizeheader('','','',idtree,'X')
  else
    finalizeheader('','','',idtree,'S');

  res:=1;
end;

{else       //HEADER PASSED BUT NO SETS FOUND
if (pass=2) AND (res=0) AND (error=false) then begin
  res:=3;
end;     }

Result:=res;
end;

//ADD SAMPLES DETECTION
function parsecmold(path:widestring;idtree:longint):integer;
var
res,pass,pos,other:longint;
typ:integer;
str,aux,header:widestring;
pr:ansistring;
gamename,romname,description,size,crc,md5,sha1,cloneof,merge,romof,sampleof:widestring;
begin
res:=0;
pass:=0;
pos:=0;
error:=false;

createsetsromstables;
Fnewdat.setimagetype('C',Fnewdat.Image3210);
Fnewdat.setimagetype('C',Fupdatedat.Image323);

while datreader.EOF=false do begin
  str:=getline;

  pr:=str;

  application.processmessages;

  str:=trim(str);
  pr:=Wideuppercase(gettoken(str,' ',1));
  aux:=copy(str,length(pr)+1,length(str));
  aux:=Changein(aux,'"','');
  aux:=trim(aux);

  if (pr=')') OR ((pr='GAME') AND (aux='(')) then begin

    Fnewdat.edit2.Text:=WideExtractfilename(path);
    Fnewdat.Label1.caption:=traduction(97);

    if (pr='GAME') AND (aux='(') then begin //0.034

      if Fnewdat.edit9.text='' then
        Fnewdat.edit9.text:=filewithoutext(WideExtractFileName(path));
      if Fnewdat.edit1.text='' then
        Fnewdat.edit1.text:=Fnewdat.edit9.text;

      datreader.Reset; //RESTART

    end;

    if Fnewdat.edit9.text<>'' then begin

      if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall
        myshowform(Fnewdat,true);
        lastnewdatdecision:=Fnewdat.tag;
      end;

      pass:=1;
    end;
    break;
  end
  else
  if pr='NAME' then begin
    Fnewdat.edit9.text:=aux;
    if Fnewdat.edit1.text='' then
      Fnewdat.edit1.text:=aux;
  end
  else
  if pr='DESCRIPTION' then
    Fnewdat.edit1.text:=aux
  else
  if pr='VERSION' then
    Fnewdat.edit3.text:=aux
  else
  if pr='DATE' then
    Fnewdat.edit4.text:=aux
  else
  if pr='CATEGORY' then
    Fnewdat.edit6.text:=aux
  else
  if pr='AUTHOR' then
    Fnewdat.edit5.text:=aux
  else
  if pr='HOMEWEB' then
    Fnewdat.edit7.text:=aux
  else
  if pr='EMAIL' then
    Fnewdat.edit8.text:=aux
  else
  if pr='HEADER' then
    header:=aux;
  //else
  //if pr='FORCEMERGING' then
  //FULL,SPLIT,NONE
end;

if (lastnewdatdecision=0) OR (lastnewdatdecision=3) then begin//No or nottoall
  if pass=1 then
    res:=2;
end
else //Yes yesall
  if pass=1 then begin
    idtree:=checkifisupdate('C',idtree);

    if overwritedat=-1 then
      res:=2; //Skip

  end;

//0.032
{if (pass=1) AND (res=0) then begin
  str:=checkforemptysetsdats;
  if str='' then
    res:=3;
  showmessage(inttostr(res));
end;  }

//UPDATE DB
if ((res=0) AND (pass=1)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then begin

  fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(425)+' ');

  insertheader(idtree,'C',header);
  createsetsromsfields(DataModule1.Tprofiles.fieldbyname('ID').asstring,false);

  while datreader.EOF=false do begin
    str:=getline;

    pr:=str;

    application.processmessages;

    str:=trim(str);
    pr:=Wideuppercase(gettoken(str,' ',1));

    if pos=0 then begin             //RESOURCE IS BIOS
      if (pr='GAME') OR (pr='RESOURCE') then begin //Initialize
        description:='';
        gamename:='';
        pos:=1;
      end;
    end
    else begin
      if (pr='ROM') OR (pr='DISK') then begin

        typ:=0;
        romname:='';
        crc:='';
        size:='0';
        md5:='';
        sha1:='';
        merge:='';

        if pr='DISK' then
          typ:=2;

        str:=copy(str,4,length(str));
        str:=trim(str);

        while gettokencount(str,' ')>=2 do begin

          aux:=Wideuppercase(gettoken(str,' ',1));
          aux:=Wideuppercase(trim(aux));

          if aux='NAME' then begin

            if str[6]='"' then begin
              romname:=gettoken(str,'"',2);
              str:=copy(str,length(romname)+3,length(str));//FIX
              romname:=trim(romname);
            end
            else
              romname:=GetToken(str,' ',2);

            if typ=2 then
              if romname<>'' then
                romname:=romname+'.chd';
          end
          else
          if aux='SIZE' then begin
           size:=GetToken(str,' ',2);
           try
            size:=inttostr(strtoint64(size))
           except
            size:='0';
           end;
          end
          else
          if aux='CRC' then begin
            crc:=GetToken(str,' ',2);
            if Length(crc)>8 then //FIX FOR 0x00000000
              crc:=Copy(crc,length(crc)-7,length(crc));
          end
          else
          if aux='MD5' then
            md5:=GetToken(str,' ',2)
          else
          if aux='SHA1' then
            sha1:=GetToken(str,' ',2)
          else
          if aux='MERGE' then
            merge:=GetToken(str,' ',2);

          other:=length(str);
          str:=copy(str,length(aux)+2,length(str));

          if length(str)=other then
            break;
        end;

        //Insert
        romname:=removeconflictchars(romname,true);
        merge:=removeconflictchars(merge,true);

        if (merge<>'') then
          if typ=2 then
            merge:=merge+'.chd';

        //FIX 0.023
        if pos=1 then begin
          gamename:=removeconflictchars2(gamename,true);
          cloneof:=removeconflictchars2(cloneof,true);
          romof:=removeconflictchars2(romof,true);
          insertsetsdata(description,gamename);
          pos:=2;
        end;

        insertromsdata(stsets.Count,romname,size,crc,md5,sha1,typ,merge,cloneof,romof,sampleof);

      end
      else
      if pr='NAME' then begin
        aux:=copy(str,length(pr)+1,length(str));
        aux:=Changein(aux,'"','');
        aux:=trim(aux);
        gamename:=aux;
      end
      else
      if pr='DESCRIPTION' then begin
        aux:=copy(str,length(pr)+1,length(str));
        aux:=Changein(aux,'"','');
        aux:=trim(aux);
        description:=aux;
      end
      else
      if pr='CLONEOF' then begin
        aux:=copy(str,length(pr)+1,length(str));
        aux:=Changein(aux,'"','');
        aux:=trim(aux);
        cloneof:=aux;
      end
      else
      if pr='ROMOF' then begin
        aux:=copy(str,length(pr)+1,length(str));
        aux:=Changein(aux,'"','');
        aux:=trim(aux);
        romof:=aux; //BIOS INDICATOR
      end
      else
      if pr='SAMPLEOF' then begin
        aux:=copy(str,length(pr)+1,length(str));
        aux:=Changein(aux,'"','');
        aux:=trim(aux);
        sampleof:=aux;
      end
      else
      if pr='SAMPLE' then begin //0.038
        aux:=copy(str,length(pr)+1,length(str));
        aux:=Changein(aux,'"','');
        aux:=trim(aux)+'.wav';
        insertromsdata(stsets.Count,aux,'','','','',1,'',cloneof,romof,sampleof);
      end
      else
      if pr=')' then begin
        pos:=0;
        cloneof:='';
        romof:='';
        sampleof:='';
      end;

    end;

  end;
end;

Fupdatedat.executequery(true,false);

if (stsets.count>0) AND (stroms.count>0) AND (error=false) then begin
  finalizeheader('','','',idtree,'C');
  res:=1;
end
else       //HEADER PASSED BUT NO SETS FOUND
if (pass=1) AND (res=0) AND (error=false) then begin
  res:=3;
end;

Result:=res;
end;

procedure createolregionlist();
begin
olregionlist:=Tstringlist.Create;

olregionlist.add('EU');
olregionlist.add('US');
olregionlist.add('DE');
olregionlist.add('CN');
olregionlist.add('ES');
olregionlist.add('FR');
olregionlist.add('IT');
olregionlist.add('JP');
olregionlist.add('NL');
olregionlist.add('GB');
olregionlist.add('DK');
olregionlist.add('FI');
olregionlist.add('NO');
olregionlist.add('PL');
olregionlist.add('PT');
olregionlist.add('SE');
olregionlist.add('UE');
olregionlist.add('JUE');
olregionlist.add('JU');
olregionlist.add('AU');
olregionlist.add('KN');
olregionlist.add('BR');
olregionlist.add('KS');
olregionlist.add('EUB');
olregionlist.add('EBU');
olregionlist.add('UB');
end;

function olgetregion(region:ansistring):ansistring;
var
res:ansistring;
begin
res:='UNK';
try
  res:=olregionlist.Strings[strtoint(region)];
except
end;

res:='('+res+')';
Result:=res;
end;

function langofnum(n:longint):ansistring;
var
res:ansistring;
begin
case n of
  0:res:='German - Turkish';//ADDED ON 0.015
  1:res:='French';
  2:res:='English';
  4:res:='Chinese';
  8:res:='Danish';
  16:res:='Dutch';
  32:res:='Finish';
  64:res:='German';
  128:res:='Italian';
  256:res:='Japanese';
  512:res:='Norwegian';
  1024:res:='Polish';
  2048:res:='Portuguese';
  4096:res:='Spanish';
  8192:res:='Swedish';
  16384:res:='English (UK)';
  32768:res:='Portuguese (BR)';
  65536:res:='Korean';
  else
    res:='Unknow';
end;

Result:=res;
end;

function ollangnums(num:longint;isnum:boolean):ansistring;
var
max,c:longint;
cont:shortint;
pass,othereng:boolean;
res,aux:ansistring;
st:Tstringlist;
begin
st:=Tstringlist.Create;
cont:=0;
max:=65536;
c:=max;
pass:=false;
othereng:=false;
res:='';
aux:='';

try
  {if num>65794 then
    res:='Unknow'
  else }
  while pass=false do begin

    while c>num do begin
      c:=c div (2);
    end;

    cont:=cont+1;

    if c=num then
      pass:=true
    else
      num:=num-c;

    aux:=langofnum(c);

    if c=16384 then
      othereng:=true
    else
    if (c=2) AND (othereng=true) then
      aux:=aux+' (US)';

    st.add(aux);

  end;
except
end;

if isnum=true then begin
  if cont>1 then
    res:='(M'+inttostr(cont)+')';
end
else begin
  st.Sort;
  res:='';
  for c:=0 to st.Count-1 do begin
    if res<>'' then
      res:=res+' - ';

    res:=res+st.Strings[c];
  end;
end;

Freeandnil(st);

Result:=res;
end;

function parseolfilename(parser:widestring;title,editor,savetype,romnum,comments,language,region,source,space,langnum,crc:widestring):widestring;
begin
parser:=Changein(parser,'%n',title);
parser:=Changein(parser,'%p',editor);
parser:=Changein(parser,'%s',savetype);
parser:=Changein(parser,'%u',romnum);
parser:=Changein(parser,'%e',comments);
parser:=Changein(parser,'%a',language); //Number

parser:=Changein(parser,'%o',region); //OK

parser:=Changein(parser,'%g',source);

parser:=Changein(parser,'%i',Changein((bytestostr(strtoint64(space))+'ytes'),'.00',''));

parser:=Changein(parser,'%m',langnum); //Number
parser:=Changein(parser,'%c',crc);

parser:=trim(parser);
parser:=removeconflictchars(parser,false);

Result:=parser
end;

procedure insertollinfo(description,publisher,savetype,relnum,comment,language,location,sourcerom,langnum,locationnum:widestring);
begin
//publisher,savetype,relnum,comment,language,location,sourcerom,langnum
Toffinfo.Append;

setwiderecord(Toffinfo.Fields[1],description);
setwiderecord(Toffinfo.Fields[2],publisher);
setwiderecord(Toffinfo.Fields[3],savetype);
Toffinfo.Fields[4].asstring:=relnum;
setwiderecord(Toffinfo.Fields[5],comment);
setwiderecord(Toffinfo.Fields[6],language);
setwiderecord(Toffinfo.Fields[7],location);
setwiderecord(Toffinfo.Fields[8],sourcerom);
Toffinfo.Fields[9].asstring:=langnum;
Toffinfo.Fields[10].asstring:=locationnum;
Toffinfo.Fields[11].asinteger:=Tsets.fieldbyname('ID').asinteger;

Toffinfo.Post;
end;

function parseol(path:widestring;idtree:longint;defoff:widestring):integer;
var
res:longint;
str,pr,pr2,aux,gamename,gamename2,urlversion,urlupdate,urlimages:widestring;
description,size,crc,imnum,relnum,ext,imcrc1,imcrc2,publisher,savetype,sourcerom,language,comment,location,langnum,locationnum:widestring;
pass:integer;
filepass,descriptionpass:widestring;
begin
res:=0;
pass:=0;
error:=false;
locationnum:='-1';

Fnewdat.setimagetype('O',Fnewdat.Image3210);
Fnewdat.setimagetype('O',Fupdatedat.image323);

createsetsromstables;

//OLLINFO
Toffinfo:=TABSTable.Create(Datamodule1);
Toffinfo.DatabaseName:=DataModule1.DBDatabase.DatabaseName;
Toffinfo.FieldDefs.Clear;
Toffinfo.DisableControls;
Toffinfo.TableName:='TEMPO';

while datreader.EOF=false do begin

  str:=getline;

  application.processmessages;

  extractbraketsandinfo(str,pr,pr2,aux);

  aux:=fixxmlseparators(aux);

  if (pr='DATNAME') AND (pr2='/DATNAME') then
    Fnewdat.Edit9.Text:=aux
  else
  if (pr='DATVERSION') AND (pr2='/DATVERSION') then
    Fnewdat.edit3.text:=aux
  else
  if (pr='SYSTEM') AND (pr2='/SYSTEM') then
    Fnewdat.Edit6.Text:=aux
  else
  if (pr='DATVERSIONURL') AND (pr2='/DATVERSIONURL') then
    urlversion:=aux
  else
  if pr2='/DATURL' then
    urlupdate:=aux
  else
  if (pr='IMURL') AND (pr2='/IMURL') then
    urlimages:=aux
  else
  if (pr='ROMTITLE') AND (pr2='/ROMTITLE') then //0.031
    Fnewdat.Edit10.Text:=aux
  else
  if (pr='GAMES') then begin
    pass:=1;
    break;
  end;

end;

Fnewdat.Tntedit1.Text:=checkofflinelistdescriptioniffailsreturndefault('');

if pass=1 then begin
  Fnewdat.edit2.Text:=WideExtractfilename(path);
  Fnewdat.Label1.caption:=traduction(98);
  Fnewdat.edit1.Text:=Fnewdat.edit9.Text;
  //Fnewdat.Edit10.Text:=defoff;

  if Fnewdat.edit9.text<>'' then begin

    if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall
      Fnewdat.Edit4.ReadOnly:=true;
      Fnewdat.Edit4.Color:=clBtnFace;
      Fnewdat.Edit4.TabStop:=false;
      Fnewdat.Edit5.ReadOnly:=true;
      Fnewdat.Edit5.Color:=clBtnFace;
      Fnewdat.Edit5.TabStop:=false;
      Fnewdat.Edit7.ReadOnly:=true;
      Fnewdat.Edit7.Color:=clBtnFace;
      Fnewdat.Edit7.TabStop:=false;
      Fnewdat.Edit8.ReadOnly:=true;
      Fnewdat.Edit8.Color:=clBtnFace;
      Fnewdat.Edit8.TabStop:=false;

      Fnewdat.panel2.Visible:=true;
      Fnewdat.Edit5.Visible:=false;
      Fnewdat.label5.Visible:=false;
      Fnewdat.Edit4.Visible:=false;
      Fnewdat.edit7.Visible:=false;
      Fnewdat.edit8.Visible:=false;
      Fnewdat.Label8.Visible:=false;
      Fnewdat.label9.Visible:=false;
      Fnewdat.Label7.Top:=Fnewdat.Label5.top;

      Fnewdat.edit6.Top:=Fnewdat.Edit4.top;

      Fnewdat.Label6.Tag:=1;

      if formexists('Fofflineupdate')=false then begin
        myshowform(Fnewdat,true);
        lastnewdatdecision:=Fnewdat.tag;
      end
      else
        lastnewdatdecision:=1;//AUTOMATIC YES FOR OFFLINELIST UPDATER
        
    end;
    
    pass:=2;

  end;
end;

if (lastnewdatdecision=0) OR (lastnewdatdecision=3) then begin//No or nottoall
  if pass=2 then
    res:=2;
end
else //Yes yesall
  if pass=2 then begin
    idtree:=checkifisupdate('O',idtree);

    if overwritedat=-1 then
      res:=2; //Skip

  end;

//UPDATE DB
if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then begin

  if overwritedat>0 then begin//0.031 USE OLD DESCRIPTIOR
    Datamodule1.Tprofiles.Locate('ID',overwritedat,[]);
    //Fnewdat.Edit10.Text:=getwiderecord(Datamodule1.Tprofiles.FieldByName('Date'));
    //Fnewdat.Tntedit1.Text:=getwiderecord(Datamodule1.Tprofiles.FieldByName('Descmask'));
  end;

  Fnewdat.Edit10.Text:=checkofflinelistfilenameiffailsreturndefault(Fnewdat.Edit10.Text);
  Fnewdat.tntedit1.Text:=checkofflinelistdescriptioniffailsreturndefault(Fnewdat.tntedit1.Text);

  filepass:=Fnewdat.edit10.text;
  descriptionpass:=Fnewdat.tntedit1.text;

  insertheader(idtree,'O','');
  createsetsromsfields(DataModule1.Tprofiles.fieldbyname('ID').asstring,true);

  if overwritedat<=0 then begin
    DataModule1.Tprofiles.edit;
    DataModule1.Tprofiles.fieldbyname('Author').asstring:=urlversion;
    DataModule1.Tprofiles.fieldbyname('Homeweb').asstring:=urlupdate;
    DataModule1.Tprofiles.fieldbyname('Email').asstring:=urlimages;
    DataModule1.Tprofiles.post;
  end;

  fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' '+traduction(425)+' ');
  size:='0'; //INITIALIZATION FIX 0.028

  while datreader.EOF=false do begin

    //GET INFO METHOD 0.023 START
    str:=getline;

    application.processmessages;

    extractbraketsandinfo(str,pr,pr2,aux);

    if (pr='TITLE') AND (pr2='/TITLE') then
      description:=removeconflictchars(fixxmlseparators(aux),false)
    else
    if (pr='IMAGENUMBER') AND (pr2='/IMAGENUMBER') then
      imnum:=aux
    else
    if (pr='RELEASENUMBER') AND (pr2='/RELEASENUMBER') then
      relnum:=fillwithzeroes(aux,4)
    else
    if (pr='SAVETYPE') AND (pr2='/SAVETYPE') then
      savetype:=removeconflictchars(fixxmlseparators(aux),false)
    else
    if (pr='SOURCEROM') AND (pr2='/SOURCEROM') then
      sourcerom:=removeconflictchars(fixxmlseparators(aux),false)
    else
    if (pr='PUBLISHER') AND (pr2='/PUBLISHER') then
      publisher:=removeconflictchars(fixxmlseparators(aux),false)
    else
    if (pr='LANGUAGE') AND (pr2='/LANGUAGE') then begin
      language:=ollangnums(strtoint(aux),false);
      langnum:=ollangnums(strtoint(aux),true);
    end
    else
    if (pr='LOCATION') AND (pr2='/LOCATION') then begin
      location:=olgetregion(aux);
      locationnum:=aux;
    end
    else
    if (pr='COMMENT') AND (pr2='/COMMENT') then
      comment:=removeconflictchars(fixxmlseparators(aux),false)
    else
    if (pr='ROMSIZE') AND (pr2='/ROMSIZE') then begin
      size:=aux;
      try
      //FIX PSP ADVANSCENE
        size:=changein(size,' ','');
        size:=inttostr(strtoint64(size))
      except
        size:='0';
      end;
    end
    else
    if (pr2='/ROMCRC') then begin
      crc:=aux;
      ext:=lowercase(GetToken(pr,'"',2));
    end
    else
    if (pr='IM1CRC') AND (pr2='/IM1CRC') then
      imcrc1:=aux
    else
    if (pr='IM2CRC') AND (pr2='/IM2CRC') then
      imcrc2:=aux
    else
    if pr='/GAME' then begin

      gamename:=parseolfilename(filepass,description,publisher,savetype,relnum,comment,language,location,sourcerom,size,langnum,crc);
      gamename2:=parseolfilename(descriptionpass,description,publisher,savetype,relnum,comment,language,location,sourcerom,size,langnum,crc);
      if gamename2='' then
        gamename2:='Unk';

      insertsetsdata(gamename2,gamename);

      //0.031
      //insertromsdata(stsets.Count,gamename+ext,size,crc,imnum,imcrc1+'-'+imcrc2,0,'','','','');
      insertromsdata(stsets.Count,getwiderecord(Tsets.Fields[2])+ext,size,crc,imnum,imcrc1+'-'+imcrc2,0,'','','','');

      insertollinfo(description,publisher,savetype,relnum,comment,language,location,sourcerom,langnum,locationnum);

      description:='';
      publisher:='';
      savetype:='';
      comment:='';
      language:='';
      location:='';
      sourcerom:='';
      imnum:='';
      relnum:='';
      size:='0';
      crc:='';
      ext:='';
      imcrc1:='';
      imcrc2:='';
      langnum:='';
      locationnum:='-1';
    end;//GAME

  end;//WHILE

end;//IF

Fupdatedat.executequery(true,false);

if (stroms.count>0) AND (stsets.count>0) AND (error=false) then begin
  finalizeheader(urlversion,urlupdate,urlimages,idtree,'O');
  res:=1;  
end
else       //HEADER PASSED BUT NO SETS FOUND
if (pass=2) AND (res=0) AND (error=false) then begin
  res:=3;
end;

Result:=res;
end;


function parserc(path:widestring;idtree:longint):integer;
const
s='¬';
var
str,aux,description,gamename,romname,size,cloneof,merge,header:widestring;
crc:widestring;
res:longint;
pass:integer;
idpos:longint;
begin
stsets.Sorted:=true;//SPEEDUP INDEXOF NECESSARY
res:=0;
pass:=0;
createsetsromstables;
error:=false;
Fnewdat.setimagetype('R',Fnewdat.Image3210);
Fnewdat.setimagetype('R',Fupdatedat.image323);

Fnewdat.edit2.Text:=WideExtractfilename(path);

while datreader.EOF=false do begin

  str:=getline;

  aux:=str;

  application.processmessages;
  str:=trim(str);//Ignore COMMENT ; HOMEPAGE

  if Wideuppercase(str)='[GAMES]' then begin

    if Fnewdat.edit9.text='' then begin //0.034
      Fnewdat.edit9.text:=filewithoutext(WideExtractFileName(path));
      if Fnewdat.Edit1.Text='' then
        Fnewdat.Edit1.text:=Fnewdat.Edit9.Text; 
    end;

    pass:=1;

    break;
  end;

  if gettokencount(str,'=')>1 then begin

    aux:=GetToken(str,'=',1);
    aux:=Wideuppercase(aux);
    str:=copy(str,length(aux)+2,length(str));
    str:=trim(str);
    aux:=trim(aux);

    if aux='AUTHOR' then
      Fnewdat.edit5.text:=str
    else
    if aux='EMAIl' then
      Fnewdat.edit8.text:=str
    else
    if aux='URL' then
      Fnewdat.edit7.text:=str
    else
    if aux='VERSION' then
      if fnewdat.Edit3.Text='' then
        Fnewdat.edit3.text:=str
      else
        Fnewdat.edit1.text:=str
    else
    if aux='DATE' then
      Fnewdat.edit4.text:=str
    else
    if aux='REFNAME' then begin
      Fnewdat.edit9.text:=str;
      if Fnewdat.edit1.text='' then
        Fnewdat.Edit1.Text:=str;
    end
    else
    if aux='CATEGORY' then
      Fnewdat.edit6.text:=str
    else
    if aux='HEADER' then
      header:=str;
  end;

end;

if pass=1 then begin

  if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall

    Fnewdat.Label1.Caption:=traduction(253);
    myshowform(Fnewdat,true);
    lastnewdatdecision:=Fnewdat.tag;

  end;

  pass:=2;
end;

if (lastnewdatdecision=0) OR (lastnewdatdecision=3) then begin//No or nottoall
  if pass=2 then
    res:=2;
end
else //Yes yesall
  if pass=2 then begin
    idtree:=checkifisupdate('R',idtree);

    if overwritedat=-1 then
      res:=2; //Skip

  end;

//UPDATEDB
if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then begin

  fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(425)+' ');

  insertheader(idtree,'R',header);
  createsetsromsfields(DataModule1.Tprofiles.fieldbyname('ID').asstring,false);

  while datreader.EOF=false do begin

    str:=getline;

    aux:=str;

    application.processmessages;

    if gettokencount(str,s)=11 then begin

      cloneof:=trim(gettoken(str,s,2));
      description:=trim(gettoken(str,s,5));
      gamename:=trim(gettoken(str,s,4));

      romname:=trim(gettoken(str,s,6));
      crc:=trim(gettoken(str,s,7));
      size:=trim(gettoken(str,s,8));
      merge:=trim(gettoken(str,s,10));

      try //Check valid integer
        size:=inttostr(strtoint64(size));
      except
        size:='0';
      end;

      romname:=removeconflictchars(romname,true);

      idpos:=stsets.IndexOf(gamename);

      if idpos=-1 then begin

        gamename:=removeconflictchars2(gamename,true);
        insertsetsdata(description,gamename);
        idpos:=stsets.Count-1;
      end;

      idpos:=idpos+1;

      if cloneof=gamename then
        cloneof:=''
      else
        cloneof:=removeconflictchars2(cloneof,true);

      merge:=removeconflictchars(merge,true);

      //RC ALWAYS TYPE 0 NO CHD NO SAMPLES NO MD5 NO SHA1
      insertromsdata(idpos,romname,size,crc,'','',0,merge,cloneof,'','');

      cloneof:='';
    end;

  end;//WHILE (F)

end;

Fupdatedat.executequery(true,false);

if (stroms.count>0) AND (stsets.count>0) AND (error=false) then begin
  finalizeheader('','','',idtree,'R');
  res:=1;
end
else       //HEADER PASSED BUT NO SETS FOUND
if (pass=2) AND (res=0) AND (error=false) then begin
  res:=3;
end;

Result:=res;
end;

function parsehsi(path:widestring;idtree:longint):integer;
var
str,pr,pr2:widestring;
gamename,size,crc,md5,sha1,aux:widestring;
init,ending,pass:longint;
res:shortint;
begin
pass:=2; //0.035
res:=0;
error:=false;

createsetsromstables;

Fnewdat.Label1.caption:=traduction(96);
Fnewdat.edit2.Text:=WideExtractfilename(path);
Fnewdat.edit9.Text:=filewithoutext(WideExtractfilename(path));
Fnewdat.edit1.Text:=Fnewdat.edit9.Text;
Fnewdat.setimagetype('H',Fnewdat.Image3210);
Fnewdat.setimagetype('H',Fupdatedat.Image323);


if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall
  Fnewdat.Label1.caption:=traduction(278);
  myshowform(Fnewdat,true);
  lastnewdatdecision:=Fnewdat.tag;
end;

if (lastnewdatdecision=0) OR (lastnewdatdecision=3) then begin//No or nottoall
  if pass=2 then
    res:=2;
end
else//Yes yesall
  if pass=2 then begin

    idtree:=checkifisupdate('H',idtree);

    if overwritedat=-1 then
      res:=2; //Skip
  end;

//UPDATE DB
if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then begin
  insertheader(idtree,'H','');
  createsetsromsfields(Datamodule1.Tprofiles.FieldByName('ID').asstring,false);
end;

fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(425)+' ');


if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then  //Yes or yestoall
  while datreader.EOF=false do begin
    str:=getline;
    application.processmessages;

    extractbraketsandinfo(str,pr,pr2,aux);

    aux:=gettoken(pr,' ',1);

    if (aux='HASH') then begin

      while gettokencount(str,'="')>=2 do begin

        pr:=gettoken(str,'="',1);
        init:=length(pr)+3;
        if pr[1]='<' then
        pr:=copy(pr,2,length(pr));

        aux:=gettoken(str,'"',2);
        ending:=length(aux);
        aux:=trim(aux);

        str:=copy(str,init+ending+2,length(str));
        pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
        pr:=Wideuppercase(trim(pr));

        if pr='NAME' then begin
          gamename:=aux;
        end
        else
        if pr='SIZE' then begin
          size:=aux;
          try
            size:=inttostr(strtoint64(size))
          except
          size:='0';
          end;
        end
        else
        if pr='CRC32' then
          crc:=aux
        else
        if pr='MD5' then
          md5:=aux
        else
        if pr='SHA1' then
          sha1:=aux;

      end;  //WHILE="

      //NOW SAVE ROM INFO
      if (gamename<>'') then begin
        gamename:=removeconflictchars(fixxmlseparators(gamename),true);

        insertsetsdata(gamename,gamename);

        insertromsdata(stsets.Count,gamename,size,crc,md5,sha1,0,'','','','');
        gamename:='';
      end; //GAMENAME=''

    end; //IF PR=HASH

  end; //DAT READING


if (stroms.count>0) AND (stsets.count>0) AND (error=false) then begin
  finalizeheader('','','',idtree,'H');
  res:=1;
end
else       //HEADER PASSED BUT NO SETS FOUND
if (pass=2) AND (res=0) AND (error=false) then begin
  res:=3;
end;

Result:=res;

{

if ((res=0) AND (pass=2)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then  //Yes or yestoall
  while datreader.EOF=false do begin

    str:=getline;

    application.processmessages;

    extractbraketsandinfo(str,pr,pr2,aux);

    romname:='';
    merge:='';
    size:='0';
    crc:='';
    md5:='';
    sha1:='';

    if (pr='DESCRIPTION') AND (pr2='/DESCRIPTION') then begin
      description:=fixxmlseparators(aux);

    end
    else                                               //NEW MAME ENTRY SINZE 0.162
    if (pr='/GAME') OR (pr='/SOFTWARE') OR (pr='/MACHINE') then begin
      description:='';
      gamename:='';
      cloneof:='';
      romof:='';
      sampleof:='';
      insertedset:=false;  //0.034
    end
    else begin   //GAME SOFTWARE MACHINE     //ROM SAMPLE DISK
      aux:=gettoken(pr,' ',1);
      if (aux='ROM') OR (aux='SAMPLE') OR (aux='DISK') then begin

        typ:=0;

        if aux='SAMPLE' then
          typ:=1
        else
        if aux='DISK' then
          typ:=2;

        while gettokencount(str,'="')>=2 do begin

          pr:=gettoken(str,'="',1);
          init:=length(pr)+3;
          if pr[1]='<' then
            pr:=copy(pr,2,length(pr));

          aux:=gettoken(str,'"',2);
          ending:=length(aux);
          aux:=trim(aux);

          str:=copy(str,init+ending+2,length(str));
          pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
          pr:=Wideuppercase(trim(pr));

          if pr='NAME' then begin
            romname:=aux;
          end
          else
          if pr='SIZE' then begin
            size:=aux;
            try
              size:=inttostr(strtoint64(size))
            except
              size:='0';
            end;
          end
          else
          if pr='CRC' then
            crc:=aux
          else
          if pr='MD5' then
            md5:=aux
          else
          if pr='SHA1' then
            sha1:=aux
          else
          if pr='MERGE' then
            merge:=aux;

        end;  //WHILE="

        //NOW SAVE ROM INFO
        if (romname<>'') then begin
          romname:=removeconflictchars(fixxmlseparators(romname),true);
          merge:=removeconflictchars(fixxmlseparators(merge),true);

          if (merge<>'') then
            if typ=2 then
              merge:=merge+'.chd';

          if insertedset=false then begin //0.034
            gamename:=removeconflictchars2(fixxmlseparators(gamename),true);

            if description='' then
              description:=gamename;

            insertsetsdata(description+addition ,gamename);
            insertedset:=true;
          end;

          insertromsdata(stsets.Count,romname,size,crc,md5,sha1,typ,merge,cloneof,romof,sampleof);
          merge:='';
        end;

      end
      else
      if (aux='GAME') OR (aux='SOFTWARE') OR (aux='MACHINE') then begin
        while gettokencount(str,'="')>=2 do begin

          pr:=gettoken(str,'="',1);
          init:=length(pr)+3;
          if pr[1]='<' then
            pr:=copy(pr,2,length(pr));

          aux:=gettoken(str,'"',2);
          ending:=length(aux);
          aux:=trim(aux);

          str:=copy(str,init+ending+2,length(str));
          pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
          pr:=Wideuppercase(trim(pr));

          if pr='NAME' then begin
            gamename:=aux;

          end
          else
          if pr='CLONEOF' then begin
            cloneof:=aux;
            cloneof:=removeconflictchars(fixxmlseparators(cloneof),false);
          end
          else
          if pr='ROMOF' then begin
            romof:=aux;
            romof:=removeconflictchars(fixxmlseparators(romof),false);
          end
          else
          if pr='SAMPLEOF' then begin
            sampleof:=aux;
            sampleof:=removeconflictchars(fixxmlseparators(sampleof),false);
          end;

        end;

        //INSERT SET INFORMATION
      end
      else
      if aux='SOFTWARELIST' then //SOFTWARE LIST 0.029
        if stsofts.Count>1 then
          while gettokencount(str,'="')>=2 do begin

            pr:=gettoken(str,'="',1);
            init:=length(pr)+3;
            if pr[1]='<' then
              pr:=copy(pr,2,length(pr));

            aux:=gettoken(str,'"',2);
            ending:=length(aux);
            aux:=trim(aux);

            str:=copy(str,init+ending+2,length(str));
            pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
            pr:=Wideuppercase(trim(pr));

            if pr='DESCRIPTION' then begin
              addition:=aux;
              if addition<>'' then begin
                removeconflictchars(fixxmlseparators(addition),false);
                addition:=' - '+addition;
              end;
            end;
          end;
    end;

  end;//While eof

if (stroms.count>0) AND (stsets.count>0) AND (error=false) then begin
  if softlist=false then
    finalizeheader('','','',idtree,'X')
  else
    finalizeheader('','','',idtree,'S');

  res:=1;
end;

Result:=res;  }
end;

function parsedc(path:widestring;idtree:longint):integer;
var
res,pass,pos,other:longint;
typ:integer;
str,aux,header:widestring;
pr:ansistring;
gamename,romname,description,size,crc,md5,sha1,cloneof,merge,romof,sampleof:widestring;
begin

res:=0;
pass:=0;
pos:=0;
error:=false;

createsetsromstables;
Fnewdat.setimagetype('D',Fnewdat.Image3210);
Fnewdat.setimagetype('D',Fupdatedat.Image323);

while datreader.EOF=false do begin
  str:=getline;

  pr:=str;

  application.processmessages;

  str:=trim(str);
  pr:=gettoken(str,':',1);
  aux:=copy(str,length(pr)+2,length(str));
  pr:=wideuppercase(pr);
  pr:=trim(pr);
  aux:=trim(aux);

  if (pr=')') OR ((pr='GAME') AND (aux='(')) then begin

    Fnewdat.edit2.Text:=WideExtractfilename(path);
    Fnewdat.Label1.caption:=traduction(623);

    if (pr='GAME') AND (aux='(') then begin //0.034

      if Fnewdat.edit9.text='' then
        Fnewdat.edit9.text:=filewithoutext(WideExtractFileName(path));
      if Fnewdat.edit1.text='' then
        Fnewdat.edit1.text:=Fnewdat.edit9.text;

      datreader.Reset; //RESTART

    end;                              

    if Fnewdat.edit9.text<>'' then begin

      if lastnewdatdecision<=1 then begin//Already selected yestoall or nottoall
        myshowform(Fnewdat,true);
        lastnewdatdecision:=Fnewdat.tag;
      end;

      pass:=1;
    end;
    break;
  end
  else
  if pr='NAME' then begin
    Fnewdat.edit9.text:=aux;
    if Fnewdat.edit1.text='' then
      Fnewdat.edit1.text:=aux;
  end
  else
  if pr='DESCRIPTION' then
    Fnewdat.edit1.text:=aux
  else
  if pr='VERSION' then
    Fnewdat.edit3.text:=aux
  else
  if pr='DATE' then
    Fnewdat.edit4.text:=aux
  else
  if pr='CATEGORY' then
    Fnewdat.edit6.text:=aux
  else
  if pr='AUTHOR' then
    Fnewdat.edit5.text:=aux
  else
  if pr='HOMEPAGE' then
    Fnewdat.edit7.text:=aux
  else
  if pr='EMAIL' then
    Fnewdat.edit8.text:=aux;
  //else
  //if pr='FORCEMERGING' then
  //FULL,SPLIT,NONE
end;

if (lastnewdatdecision=0) OR (lastnewdatdecision=3) then begin//No or nottoall
  if pass=1 then
    res:=2;
end
else //Yes yesall
  if pass=1 then begin
    idtree:=checkifisupdate('D',idtree);

    if overwritedat=-1 then
      res:=2; //Skip

  end;

//0.032
{if (pass=1) AND (res=0) then begin
  str:=checkforemptysetsdats;
  if str='' then
    res:=3;
  showmessage(inttostr(res));
end;  }

//UPDATE DB
if ((res=0) AND (pass=1)) AND ((lastnewdatdecision=1) OR (lastnewdatdecision=2)) then begin

  fupdatedat.rewrite(traduction(61)+' : '+traduction(71)+' - '+traduction(425)+' ');

  insertheader(idtree,'D',header);
  createsetsromsfields(DataModule1.Tprofiles.fieldbyname('ID').asstring,false);

  while datreader.EOF=false do begin
    str:=getline;

    pr:=str;

    application.processmessages;

    str:=trim(str);
    pr:=Wideuppercase(gettoken(str,' ',1));
    //showmessage(pr);
    //if stsets.count=100 then
    //  break;

    if pos=0 then begin             //RESOURCE IS BIOS
      if (pr='GAME') then begin //Initialize
        description:='';
        gamename:='';
        pos:=1;
      end;
    end
    else begin
      if (pr='FILE') then begin

        typ:=0;
        romname:='';
        crc:='';
        size:='0';
        md5:='';
        sha1:='';
        merge:='';

        str:=copy(str,4,length(str));
        str:=trim(str);

        while gettokencount(str,' ')>=2 do begin

          aux:=Wideuppercase(gettoken(str,' ',1));
          aux:=Wideuppercase(trim(aux));
          //if romname<>'' then
          //  showmessage(aux);

          if aux='NAME' then begin

            if str[6]='"' then begin
              romname:=gettoken(str,'"',2);
              str:=copy(str,length(romname)+3,length(str));//FIX
              romname:=trim(romname);
            end
            else begin
              //romname:=GetToken(str,' ',2);
              romname:=gettoken(str,' size ',1);
              romname:=copy(romname,length(gettoken(romname,' ',1))+1,length(romname));
              romname:=trim(romname);
              //str:=copy(str,length(romname)+7,length(str));
              //showmessage(stR);
            end;
          end
          else
          if aux='SIZE' then begin

           size:=GetToken(str,' ',2);
           try
            size:=inttostr(strtoint64(size))
           except
            size:='0';
           end;
          end
          else
          if aux='CRC' then begin
            crc:=GetToken(str,' ',2);
            if Length(crc)>8 then //FIX FOR 0x00000000
              crc:=Copy(crc,length(crc)-7,length(crc));
          end;
          {
          else
          if aux='MD5' then
            md5:=GetToken(str,' ',2)
          else
          if aux='SHA1' then
            sha1:=GetToken(str,' ',2)
          else
          if aux='MERGE' then
            merge:=GetToken(str,' ',2);    } //REMOVED SEEMS NOT NEEDED

          other:=length(str);
          str:=copy(str,length(aux)+2,length(str));

          if length(str)=other then
            break;
        end;

        //Insert
        romname:=removeconflictchars(romname,true);
        //merge:=removeconflictchars(merge,true);

        //FIX 0.023
        if pos=1 then begin
          gamename:=removeconflictchars2(gamename,true);
          //cloneof:=removeconflictchars2(cloneof,true);
          //romof:=removeconflictchars2(romof,true);
          gamename:=copy(gamename,1,length(gamename)-4);//REMOVE ZIP EXTENSION
          insertsetsdata(description,gamename);
          pos:=2;
        end;

        insertromsdata(stsets.Count,romname,size,crc,md5,sha1,typ,merge,cloneof,romof,sampleof);

      end
      else
      if pr='NAME' then begin
        aux:=copy(str,length(pr)+1,length(str));
        aux:=Changein(aux,'"','');
        aux:=trim(aux);
        gamename:=aux;
      end
      else
      if pr='DESCRIPTION' then begin
        aux:=copy(str,length(pr)+1,length(str));
        aux:=Changein(aux,'"','');
        aux:=trim(aux);
        description:=aux;
      end
      else
      if pr=')' then begin
        pos:=0;
        cloneof:='';
        romof:='';
        sampleof:='';
      end;

    end;

  end;
end;

Fupdatedat.executequery(true,false);

if (stsets.count>0) AND (stroms.count>0) AND (error=false) then begin
  finalizeheader('','','',idtree,'D');
  res:=1;
end
else       //HEADER PASSED BUT NO SETS FOUND
if (pass=1) AND (res=0) AND (error=false) then begin
  res:=3;
end;

Result:=res;
end;

// 0=fail
// 1=Ok
// 2=Skip
// 3=Header found but empty without sets

function importdatpass(path:widestring;id:longint;offfilename:widestring):shortint;
var
str,aux,pr,pr2,softname,softdesc:widestring;
res,init,ending:integer;
dattype:shortint;
begin

try
  fupdatedat.rewrite(traduction(61)+' : '+traduction(71));
except
end;

stsets.Clear;
stroms.Clear;
stsofts.clear;

res:=0;
mamebuild:='';
posmessage2:='';
posmessage:=0;

Application.CreateForm(TFnewdat, Fnewdat);
Application.CreateForm(TFupdatedat, Fupdatedat);

createolregionlist;//GENERIC LATER DESTROY

try

  try
    WideFileSetAttr(path,faArchive);//IF READONLY FAILS MUST CONVERT TO WRITE TOO 0.027
  except
  end;

  datreader:=TGpTextFile.CreateW(path);
  datreader.Reset;

  // 0.037 Liao Dahao bugfix
  //NO CONVERT TO UTF8 CODEPAGES OF UNICODE ELSE CONVERT

  //showmessage(inttostr(datreader.codepage));                                                                                                                                                            //0.050 FIX
  if (datreader.codepage<>65000) AND (datreader.codepage<>65001) AND (datreader.codepage<>1200) AND (datreader.codepage<>1201) AND (datreader.codepage<>12000) AND (datreader.codepage<>12001) AND (datreader.codepage<>1252) then begin
    datreader.Close;
    if FileMayBeUTF8(path)=true then begin
      //showmessage('UTF8');
      datreader.Reset;
      datreader.Codepage:=CP_UTF8;
    end
    else begin //ANSI
      //showmessage('ANSI');
      datreader.Reset;
    end;
  end;

  dattype:=-1;

  While datreader.EOF=false do begin

    str:=getline;
    //showmessage(str);
    application.processmessages;

    str:=Wideuppercase(trim(str));

    if str=']>' then begin

      while datreader.EOF=false do begin
        str:=getline;
        aux:=gettoken(str,'="',1);
        aux:=gettoken(aux,'<',2);
        aux:=Wideuppercase(trim(aux));

        if aux='MAME BUILD' then begin
          mamebuild:='MAME '+GetToken(str,'"',2);
          dattype:=0;
          break;
        end
        else
        if aux='MESS BUILD' then begin
          mamebuild:='MESS '+GetToken(str,'"',2);
          dattype:=0;
          break;
        end
        else
        if aux='SOFTWARELISTS>' then begin //SINZE MAME 0.162

          while NOT datreader.EOF do begin

            application.ProcessMessages;

            str:=getline;
            extractbraketsandinfo(str,pr,pr2,aux);
            aux:=gettoken(pr,' ',1);

            //pr is without brackets
            if aux='SOFTWARELIST' then begin

              softname:='';
              softdesc:='';

              while gettokencount(str,'="')>=2 do begin

                pr:=gettoken(str,'="',1);
                init:=length(pr)+3;
                if pr[1]='<' then
                  pr:=copy(pr,2,length(pr));

                aux:=gettoken(str,'"',2);
                ending:=length(aux);
                aux:=trim(aux);

                str:=copy(str,init+ending+2,length(str));
                pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
                pr:=Wideuppercase(trim(pr));

                aux:=fixxmlseparators(aux);
                //aux is value and pr is param

                if pr='NAME' then
                  softname:=aux
                else
                if pr='DESCRIPTION' then
                  softdesc:=aux;
              end;

              if softname<>'' then begin
                if softdesc='' then
                  softdesc:=softname;

                //ADD TO LIST
                stsofts.Add(softdesc+#10#13+softname);
                dattype:=0;
              end;

            end;//IF SOFTLIST

          end;

        end;

        application.processmessages;
      end;
      break;

    end
    else                                                                  //0.035 CONNIE NEW BRACKET
    if (str='<DATAFILE>') OR (gettoken(str,' ',1)='<DATAFILE') OR (str='<MAME>') then begin
      dattype:=0;
      break;
    end
    else                                //SINZE 0.020          //SINCE 0.034
    if (str='CLRMAMEPRO (') OR (str='EMULATOR (') OR (str='GAME (') then begin

      if str='GAME (' then begin //NO HEADER INFO THEN RELOAD  0.034
        datreader.Reset;
      end;

      dattype:=1;
      break;
    end
    else
    if str='<CONFIGURATION>' then begin
      dattype:=2;
      break;
    end
    else
    if str='[CREDITS]' then begin
      dattype:=3;
      break;
    end
    else
    if str='<HASHFILE>' then begin
      dattype:=4;
      break;
    end
    else
    if str='DOSCENTER (' then begin
      dattype:=5;
      break;
    end
    else
    if widelowercase(str)='<?xml version="1.0"?>' then begin

      str:=trim(getline);
      while str='' do
        str:=trim(getline);

      if wideuppercase(str)<>'<!DOCTYPE SOFTWARELIST SYSTEM "SOFTWARELIST.DTD">' then begin //0.046
        dattype:=0;//0.045
        break;
      end
      else begin //SOFTLIST 2ND METHOD 0.046

          while NOT datreader.EOF do begin

            application.ProcessMessages;

            str:=getline;
            extractbraketsandinfo(str,pr,pr2,aux);
            aux:=gettoken(pr,' ',1);

            //pr is without brackets
            if aux='SOFTWARELIST' then begin

              softname:='';
              softdesc:='';

              while gettokencount(str,'="')>=2 do begin

                pr:=gettoken(str,'="',1);
                init:=length(pr)+3;
                if pr[1]='<' then
                  pr:=copy(pr,2,length(pr));

                aux:=gettoken(str,'"',2);
                ending:=length(aux);
                aux:=trim(aux);

                str:=copy(str,init+ending+2,length(str));
                pr:=gettoken(pr,' ',gettokencount(pr,' ')); //NEW
                pr:=Wideuppercase(trim(pr));

                aux:=fixxmlseparators(aux);
                //aux is value and pr is param

                if pr='NAME' then
                  softname:=aux
                else
                if pr='DESCRIPTION' then
                  softdesc:=aux;
              end;

              if softname<>'' then begin
                if softdesc='' then
                  softdesc:=softname;

                //ADD TO LIST
                stsofts.Add(softdesc+#10#13+softname);
                dattype:=0;
              end;

            end;//IF SOFTLIST

          end;

      end;
    end;
    {else
    if str='<MENU>' then begin //HYPERSPIN REMOVED
      dattype:=6;
      break;
    end;        }

    str:=gettoken(str,'"',2);
    if (str='SOFTWARELIST.DTD') then begin
      dattype:=0;
      break;
    end;

  end;

  if Formexists('Fupdater')=true then //0.047 NO PROMP
    if ((Application.FindComponent('Fupdater') as TTntform).FindComponent('Popupmenu1') as Tpopupmenu).Tag=1 then begin
      lastnewdatdecision:=2;//INFORMATION PROFILE PROMPT
      autodecision:=2;//UPDATE PROFILE PROMPT
    end;

  case dattype of
    0:res:=parsecmxml(path,id);
    1:res:=parsecmold(path,id);
    2:res:=parseol(path,id,offfilename);
    3:res:=parserc(path,id);
    4:res:=parsehsi(path,id);
    5:res:=parsedc(path,id);
    //6:res:=parsehs(path,id);  //HYPERSPIN REMOVED
  end;
  
except
  res:=0;
end;

try
  FreeAndNil(datreader);
except
end;

application.ProcessMessages;

//Reload tab if exists
if (res=1) AND (overwritedat<>0) AND (formexists('Fupdatedat')) then begin
  Fupdatedat.reloadtab;
end;

//NO FREEZE FREE DBCLONES MEMORY
Fupdatedat.executequery(true,true);

application.ProcessMessages;

stsets.clear;

application.ProcessMessages;

stroms.clear;

application.ProcessMessages;

stsofts.clear;

application.ProcessMessages;

try
  Freeandnil(Tsets);
except
end;

application.ProcessMessages;

try
  Freeandnil(Troms);
except
end;

application.ProcessMessages;

//0.050
{try
  Freeandnil(Tregions);
except
end;}

application.ProcessMessages;

try
  Freeandnil(Tclones);
except
end;

application.ProcessMessages;

Try
  Freeandnil(Tromsof);
except
end;

application.ProcessMessages;

Try
  Freeandnil(Tsampleof);
except
end;

application.ProcessMessages;

try
  Freeandnil(Toffinfo);
except
end;

application.ProcessMessages;

try
  Freeandnil(DBClones);
except
end;
application
.ProcessMessages;

if formexists('Fupdatedat')=true then
  Freeandnil(Fupdatedat);

application.ProcessMessages;

if formexists('Fnewdat')=true then
  Freeandnil(Fnewdat);

application.ProcessMessages;

try
  FreeAndNil(olregionlist);
except
end;

application.ProcessMessages;

Result:=res;
end;


end.
