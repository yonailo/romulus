unit Ureport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, strings, Buttons, ComCtrls, DB, ABSMain, Mymessages,
  GR32_Image, Tntforms, TntExtCtrls, TntStdCtrls, TntButtons,
  TntMenus,TntComCtrls, TntDialogs, TntSysutils, Gptextfile, VirtualTrees,
  Menus;

type
  TFreport = class(Ttntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    RadioButton1: TTntRadioButton;
    RadioButton2: TTntRadioButton;
    RadioButton3: TTntRadioButton;
    Bevel3: TBevel;
    Panel2: TTntPanel;
    Bevel4: TBevel;
    RadioButton4: TTntRadioButton;
    RadioButton5: TTntRadioButton;
    BitBtn1: TTntBitBtn;
    Bevel6: TBevel;
    SaveDialog1: TTntSaveDialog;
    Label2: TTntLabel;
    Label3: TTntLabel;
    BitBtn2: TTntBitBtn;
    Image321: TImage32;
    Image3210: TImage32;
    Image322: TImage32;
    SpeedButton1: TTntSpeedButton;
    TntPopupMenu1: TPopupMenu;
    C11: TMenuItem;
    C21: TMenuItem;
    C31: TMenuItem;
    C41: TMenuItem;
    C51: TMenuItem;
    C61: TMenuItem;
    C71: TMenuItem;
    C81: TMenuItem;
    C91: TMenuItem;
    C10: TMenuItem;
    N1: TMenuItem;
    Selectall1: TMenuItem;
    Unselectall1: TMenuItem;
    N2: TMenuItem;
    C111: TMenuItem;
    C121: TMenuItem;
    C131: TMenuItem;
    C141: TMenuItem;
    C151: TMenuItem;
    Savecolumntitles1: TMenuItem;
    N3: TMenuItem;
    Radiobutton6: TTntRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Unselectall1Click(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure columnscheck(b:boolean);
  public
    { Public declarations }
  end;

var
  Freport: TFreport;

implementation

uses Umain, UData;

{$R *.dfm}
procedure Tfreport.columnscheck(b:boolean);
var
x:integer;
begin
for x:=0 to TntPopupMenu1.Items.Count-1 do
  if TntPopupMenu1.Items[x].Tag=0 then
    if TntPopupMenu1.Items[x].visible=true then
      TntPopupMenu1.Items[x].Checked:=b;

end;

procedure TFreport.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Freport);
end;

procedure TFreport.FormShow(Sender: TObject);
begin
Freport.Tag:=Fmain.PageControl1.ActivePageIndex;
Fmain.addtoactiveform((sender as Tform),true);

caption:=traduction(118);
label1.caption:=traduction(197);
Fmain.labelshadow(label1,Freport);
label2.caption:=traduction(210);
label3.caption:=traduction(211);

RadioButton1.Caption:=traduction(207)+' (*.txt)';
RadioButton2.Caption:=traduction(208)+' (*.doc)';
RadioButton3.Caption:=traduction(209)+' (*.html)';
RadioButton6.Caption:=traduction(591)+' (*.csv)';

radiobutton4.Caption:=traduction(214);
radiobutton5.Caption:=traduction(213);

bitbtn2.Caption:=traduction(217);
stablishfocus(bitbtn2);
BitBtn1.Caption:=traduction(202);

speedbutton1.Caption:=traduction(543);

if Freport.Tag=0 then begin
  if Fmain.VirtualStringTree2.SelectedCount<=0 then
    radiobutton4.Enabled:=false;

  //Fill menu items
  C11.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[0].Text);
  C21.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[1].Text);
  C31.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[2].Text);
  C41.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[3].Text);
  C51.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[4].Text);
  C61.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[5].Text);
  C71.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[6].Text);
  C81.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[7].Text);
  C91.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[8].Text);
  C10.Caption:=UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[9].Text);

  N1.Visible:=false;
  C111.Visible:=false;
  C121.Visible:=false;
  C131.Visible:=false;
  C141.Visible:=false;
  C151.Visible:=false;
end
else
if Freport.Tag=1 then begin
  if masterlv.SelectedCount<=0 then
    radiobutton4.Enabled:=false;

  //Fill menu items
  C11.Caption:=UTF8Encode(masterlv.Header.Columns[0].Text);
  C21.Caption:=UTF8Encode(masterlv.Header.Columns[1].Text);
  C31.Caption:=UTF8Encode(masterlv.Header.Columns[2].Text);
  C41.Caption:=UTF8Encode(masterlv.Header.Columns[3].Text);
  C51.Caption:=UTF8Encode(masterlv.Header.Columns[4].Text);

  if masterlv.Header.Columns.Count>5 then begin //Offlinelist
    C61.Caption:=UTF8Encode(masterlv.Header.Columns[5].Text);
    C71.Caption:=UTF8Encode(masterlv.Header.Columns[6].Text);
    C81.Caption:=UTF8Encode(masterlv.Header.Columns[7].Text);
    C91.Caption:=UTF8Encode(masterlv.Header.Columns[8].Text);
  end
  else begin
    C61.Visible:=false;
    C71.Visible:=false;
    C81.Visible:=false;
    C91.Visible:=false;
  end;

  C10.Visible:=false;

  C111.Caption:=UTF8Encode(detaillv.Header.Columns[0].Text);
  C121.Caption:=UTF8Encode(detaillv.Header.Columns[1].Text);
  C131.Caption:=UTF8Encode(detaillv.Header.Columns[2].Text);
  C141.Caption:=UTF8Encode(detaillv.Header.Columns[3].Text);
  C151.Caption:=UTF8Encode(detaillv.Header.Columns[4].Text);
end;

//Default checked
C11.Checked:=true;
C21.Checked:=true;
C31.Checked:=true;
C41.Checked:=true;

Savecolumntitles1.Caption:=UTF8Encode(traduction(509));
Selectall1.Caption:=UTF8Encode(traduction(371));
Unselectall1.Caption:=UTF8Encode(traduction(372));
end;

procedure TFreport.BitBtn1Click(Sender: TObject);
var
lv:TVirtualstringtree;
x:longint;
extyp,typ:shortint;
add:boolean;
T:TABSTable;
f:Textfile;
pass,displaydetails,displaymaster,displayhave,displaymiss,writen:boolean;
mastertableisopen,masterdetailsisopen:boolean;
haveroms,havesets,aux,s,mount:ansistring;
colhtml,coldoc,colhtml2:string;
n:PVirtualNode;
tdir:ansistring;
csvsep:string;
begin
//CHECK COLUMNS SELECTION
pass:=false;
displaydetails:=false;
displaymaster:=false;
displayhave:=true;
displaymiss:=true;
mastertableisopen:=false;
masterdetailsisopen:=false;
csvsep:=UTF8Encode('"');

for x:=0 to TntPopupMenu1.Items.Count-1 do
  if TntPopupMenu1.Items[x].Tag=0 then
    if TntPopupMenu1.Items[x].Checked=true then begin
      if TntPopupMenu1.Items[x].Name<>Savecolumntitles1.Name then
        pass:=true;

        //Check displaymaster
      if Length(TntPopupMenu1.Items[x].Name)=3 then
        displaymaster:=true;
    end;

//Check displaydetails
if (C111.Checked=true) OR (C121.Checked=true) OR (C131.Checked=true) OR (C141.Checked=true) OR (C151.Checked=true) then
  displaydetails:=true;

if pass=false then begin
  mymessageerror(traduction(311));
  exit;
end;

//CSV Check
if (displaymaster=true) AND (displaydetails=true) AND (radiobutton6.checked=true) then begin
  mymessageerror(traduction(592));
  exit;
end;

if displaydetails=true then begin
  if mymessagequestion(traduction(544),false)=0 then
    exit;

  displayhave:=(Fmain.FindComponent('CLONE_Speedbutton8_'+Fmain.getcurrentprofileid) as TTntspeedbutton).down;
  displaymiss:=(Fmain.FindComponent('CLONE_Speedbutton9_'+Fmain.getcurrentprofileid) as TTntspeedbutton).down;
end;

if (displayhave=false) AND (displaymiss=false) then
  displaydetails:=false;

tdir:=tempdirectoryresources+'export.rmt';
extyp:=0;
typ:=0;
savedialog1.Title:=traduction(202);
savedialog1.FileName:='';
savedialog1.InitialDir:=folderdialoginitialdircheck(initialdirexport);

if RadioButton1.Checked=true then begin
  extyp:=0;
  savedialog1.Filter:=RadioButton1.caption+'|'+'*.txt';
  savedialog1.DefaultExt:='.txt';
  csvsep:='    ';
end
else
if RadioButton2.Checked=true then begin
  extyp:=1;
  savedialog1.Filter:=RadioButton2.caption+'|'+'*.doc';
  savedialog1.DefaultExt:='.doc';
end
else
if RadioButton3.Checked=true then begin
  extyp:=2;
  savedialog1.Filter:=RadioButton3.caption+'|'+'*.html';
  savedialog1.DefaultExt:='.html';
end
else
if Radiobutton6.Checked=true then begin
  extyp:=3;
  savedialog1.Filter:=RadioButton6.caption+'|'+'*.csv';
  savedialog1.DefaultExt:='.csv';
end;

pass:=true;

try

Fmain.positiondialogstart;

if savedialog1.Execute then begin
  if FileExists2(savedialog1.filename) then
    if mymessagequestion(traduction(216)+#10#13+savedialog1.filename,false)<>1 then
      pass:=false;

  if pass=true then begin
    screen.Cursor:=crhourglass;
    initialdirexport:=WideExtractfilepath(Savedialog1.FileName);

    assignfile(f,tdir);
    rewrite(f);

    //Get list to export
    lv:=Fmain.VirtualStringTree2;
    T:=Datamodule1.Tprofilesview;
    T.First;

    if Freport.tag=1 then begin //Roms list
      lv:=masterlv;
      T:=mastertable;
      typ:=1;
    end;

    if (extyp=0) OR (extyp=3) then begin //TXT & CSV

      if extyp=0 then begin
        Writeln(f,UTF8Encode(traduction(206)));
        writeln(f,'');
      end;

      mount:='';
      if (extyp=3) AND (Savecolumntitles1.Checked=true) then begin
        if typ=0 then begin //Profiles
          if C11.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[0].text+csvsep);
          if C21.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[1].text+csvsep);
          if C31.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[2].text+csvsep);
          if C41.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[3].text+csvsep);
          if C51.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[4].text+csvsep);
          if C61.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[5].text+csvsep);
          if C71.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[6].text+csvsep);
          if C81.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[7].text+csvsep);
          if C91.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[8].text+csvsep);
          if C10.Checked=true then
            mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.Columns[9].text+csvsep);
        end//TYP 0
        else begin
          if C11.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[0].text+csvsep);
          if C21.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[1].text+csvsep);
          if C31.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[2].text+csvsep);
          if C41.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[3].text+csvsep);
          if C51.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[4].text+csvsep);
          if C61.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[5].text+csvsep);
          if C71.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[6].text+csvsep);
          if C81.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[7].text+csvsep);
          if C91.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[8].text+csvsep);
          if C10.Checked=true then
            mount:=mount+UTF8Encode(masterlv.Header.Columns[9].text+csvsep);

          if C111.Checked=true then
            mount:=mount+UTF8Encode(detaillv.Header.Columns[0].text+csvsep);
          if C121.Checked=true then
            mount:=mount+UTF8Encode(detaillv.Header.Columns[1].text+csvsep);
          if C131.Checked=true then
            mount:=mount+UTF8Encode(detaillv.Header.Columns[2].text+csvsep);
          if C141.Checked=true then
            mount:=mount+UTF8Encode(detaillv.Header.Columns[3].text+csvsep);
          if C151.Checked=true then
            mount:=mount+UTF8Encode(detaillv.Header.Columns[4].text+csvsep);
        end;

        writeln(f,mount);
      end;
    end
    else
    if extyp=1 then begin //DOC
      Writeln(f,'{\rtf1\ansi\deff0{\fonttbl{\f0\fswiss\fcharset0 Tahoma;}}');
      Writeln(f,'{\colortbl ;\red0\green128\blue0;\red255\green128\blue0;\red255\green0\blue0;\red102\green102\blue102;\red0\green0\blue255;}');
      aux:='{\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\lang3082\b\f0\fs20 ';
      Writeln(f,widestringtoustring(traduction(206))+'\b0  '+'\par');
      Writeln(f,'\par');
      aux:='\b ';
    end
    else
    if extyp=2 then begin//PREPARE HTML

      Writeln(f,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
      Writeln(f,'<html xmlns="http://www.w3.org/1999/xhtml">');
      Writeln(f,'<head>');
      Writeln(f,'<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />');
      Writeln(f,'<title>'+UTF8Encode(xmlparser(traduction(206)))+'</title>');
      Writeln(f,'<style type="text/css">');
      Writeln(f,'<!--');
      Writeln(f,'body {');
      Writeln(f,'	background-color: #181818;');
      Writeln(f,'}');
      Writeln(f,'body,td,th {');
      Writeln(f,'	font-size: 12px;');
      Writeln(f,'	font-family: Tahoma;');
      Writeln(f,'	color: #FFFFFF;');
      Writeln(f,'}');
      Writeln(f,'.Estilo1 {color: #030303}');
      Writeln(f,'a:link {');
      Writeln(f,'color: #FFFFFF;');
      Writeln(f,'}');
      Writeln(f,'a:visited {');
      Writeln(f,'color: #FFFFFF;');
      Writeln(f,'}');
      Writeln(f,'a:hover {');
      Writeln(f,'color: #FFFFFF;');
      Writeln(f,'}');
      Writeln(f,'a:active {');
      Writeln(f,'color: #FFFFFF;');
      Writeln(f,'}');
      Writeln(f,'-->');
      Writeln(f,'</style></head>');
      Writeln(f,'<body>');
      Writeln(f,'<table width="100%" border="0" cellpadding="2" cellspacing="2">');
      Writeln(f,'  <tr>');

      if typ=0 then begin //Profile
        if Savecolumntitles1.Checked=true then begin
          if C11.Checked=true then
            Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[0].text))+'</span></th>');
          if C21.Checked=true then
            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[1].text))+'</span></th>');
          if C31.Checked=true then
            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[2].text))+'</span></th>');
          if C41.Checked=true then
            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[3].text))+'</span></th>');
          if C51.Checked=true then
            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[4].text))+'</span></th>');
          if C61.Checked=true then
            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[5].text))+'</span></th>');
          if C71.Checked=true then
            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[6].text))+'</span></th>');
          if C81.Checked=true then
            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[7].text))+'</span></th>');
          if C91.Checked=true then
            Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[8].text))+'</span></th>');
          if C10.Checked=true then
            Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(Fmain.VirtualStringTree2.Header.Columns[9].text))+'</span></th>');
        end;
        mastertableisopen:=true;
      end;

      Writeln(f,'  </tr>');

    end; //EXTYPE

    T.First;

    n:=lv.GetFirst;
    for x:=0 to lv.RootNodeCount-1 do begin

      add:=false;

      if RadioButton4.Checked=true then begin
        if lv.Selected[n]=true then
          add:=true;
      end
      else
        add:=true;

      if add=true then begin //INSERT INFO

        //0.030 FIX NO SORTED TABLE INSERTION
        if Freport.tag=1 then
          T.Locate('CONT',x+1,[]);

        if typ=0 then begin //FROM PROFILES

          haveroms:=T.fieldbyname('Haveroms').asstring;
          havesets:=T.fieldbyname('Havesets').asstring;

          if haveroms='' then begin
            haveroms:='-';
            havesets:='-';
            colhtml:='#666666';
            coldoc:='\cf4';
          end
          else begin
            haveroms:=pointdelimiters(T.fieldbyname('Haveroms').asinteger);
            havesets:=pointdelimiters(T.fieldbyname('Havesets').asinteger);

            if T.FieldByName('Haveroms').asinteger=0 then begin
              colhtml:='#CC0000';
              coldoc:='\cf3';
            end
            else
            if T.fieldbyname('Haveroms').asinteger=T.fieldbyname('Totalroms').asinteger then begin
              colhtml:='#006600';
              coldoc:='\cf1';
            end
            else begin
              colhtml:='#CC6600';
              coldoc:='\cf2';
            end;

          end;

          case extyp of
            0,3:begin   //DONE
              mount:='';

              if C11.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[0].text)+' : ';

                mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Description'))+csvsep);
              end;

              if C21.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[1].text)+' : ';

                mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Version'))+csvsep);
              end;

              if C31.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[2].text)+' : ';

                mount:=mount+havesets+' / '+pointdelimiters(T.fieldbyname('Totalsets').asinteger)+UTF8Encode(csvsep);
              end;

              if C41.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[3].text)+' : ';

                mount:=mount+haveroms+' / '+pointdelimiters(T.fieldbyname('Totalroms').asinteger)+UTF8Encode(csvsep);
              end;

              if C51.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[4].text)+' : ';

                 mount:=mount+splitmergestring(T.fieldbyname('Filemode').asinteger)+UTF8Encode(csvsep);
              end;

              if C61.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[5].text)+' : ';

                if T.FieldByName('Shared').AsBoolean=true then
                  mount:=mount+'X'+UTF8Encode(csvsep)
                else
                  mount:=mount+UTF8Encode(csvsep);

              end;

              if C71.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[6].text)+' : ';

                 mount:=mount+datetimetostr(T.fieldbyname('Added').AsDateTime)+UTF8Encode(csvsep);;
              end;

              if C81.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[7].text)+' : ';

                if length(T.fields[11].asstring)<=12 then
                  mount:=mount+csvsep
                else
                  mount:=mount+datetimetostr(T.fieldbyname('Lastscan').AsDateTime)+UTF8Encode(csvsep);
              end;

              if C91.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[8].text)+' : ';

                 mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Name'))+csvsep);
              end;

              if C10.Checked=true then begin
                if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                  mount:=mount+UTF8Encode(Fmain.VirtualStringTree2.Header.columns[9].text)+' : ';

                 mount:=mount+UTF8Encode(getwiderecord(T.fields[20])+csvsep);
              end;

              mount:=trim(mount);

              Writeln(f,mount);

              //Writeln(f,''); //REMOVED 0.031
            end;
            1:begin  //DONE
              mount:=coldoc+aux;

              if C11.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[0].text)+'\b0  : ';
                mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Description')))+'    \b ';
              end;

              if C21.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[1].text)+'\b0  : ';
                mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Version')))+'    \b ';
              end;

              if C31.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[2].text)+'\b0  : ';
                mount:=mount+widestringtoustring(havesets+' / '+pointdelimiters(T.fieldbyname('Totalsets').asinteger))+'    \b ';
              end;

              if C41.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[3].text)+'\b0  : ';
                mount:=mount+widestringtoustring(haveroms+' / '+pointdelimiters(T.fieldbyname('Totalroms').asinteger))+'    \b ';
              end;

              if C51.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[4].text)+'\b0  : ';
                 mount:=mount+widestringtoustring(splitmergestring(T.fieldbyname('Filemode').asinteger))+'    \b ';
              end;

              if C61.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[5].text)+'\b0  : ';

                if T.FieldByName('Shared').AsBoolean=true then
                  mount:=mount+'X';

                 mount:=mount+'    \b ';
              end;

              if C71.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[6].text)+'\b0  : ';
                 mount:=mount+widestringtoustring(datetimetostr(T.fieldbyname('Added').AsDateTime))+'    \b ';
              end;

              if C81.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[7].text)+'\b0  : ';
                if length(T.fields[11].asstring)<=12 then
                  mount:=mount+widestringtoustring(' ')+'    \b '
                else
                  mount:=mount+widestringtoustring(datetimetostr(T.fieldbyname('Lastscan').AsDateTime))+'    \b ';
              end;

              if C91.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[8].text)+'\b0  : ';
                 mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Name')))+'    \b ';
              end;

              if C10.Checked=true then begin
                if Savecolumntitles1.Checked=true then
                  mount:=mount+widestringtoustring(Fmain.VirtualStringTree2.Header.columns[9].text)+'\b0  : ';
                 mount:=mount+widestringtoustring(getwiderecord(T.fields[20]))+'    \b ';
              end;

              mount:=mount+'\par';
              Writeln(f,mount);
              Writeln(f,'\par');
              aux:='\b ';
            end;
            2:begin //DONE
              Writeln(f,'<tr>');
              if C11.Checked=true then                 //FIRST UTF8ENCODE!!!!
                Writeln(f,'<td bgcolor="'+colhtml+'">'+UTF8Encode(xmlparser(getwiderecord(T.fieldbyname('Description'))))+'</td>');

              if C21.Checked=true then
                Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+UTF8Encode(xmlparser(getwiderecord(T.fieldbyname('Version'))))+'</div></td>');

              if C31.Checked=true then
                Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+havesets+' / '+pointdelimiters(T.fieldbyname('Totalsets').asinteger)+'</div></td>');

              if C41.Checked=true then
                Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+haveroms+' / '+pointdelimiters(T.fieldbyname('Totalroms').asinteger)+'</div></td>');

              if C51.Checked=true then
                 Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+UTF8Encode(xmlparser(splitmergestring(T.fieldbyname('Filemode').asinteger)))+'</div></td>');

              if C61.Checked=true then begin
                if T.FieldByName('Shared').AsBoolean=true then
                  Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+'X'+'</div></td>')
                else
                  Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+'</div></td>')
              end;

              if C71.Checked=true then
                Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+UTF8Encode(xmlparser(datetimetostr(T.fieldbyname('Added').asdatetime)))+'</div></td>');

              if C81.Checked=true then
                if length(T.fields[11].asstring)<=12 then
                  Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+' '+'</div></td>')
                else
                  Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+UTF8Encode(xmlparser(datetimetostr(T.fieldbyname('Lastscan').asdatetime)))+'</div></td>');

              if C91.Checked=true then
                Writeln(f,'<td bgcolor="'+colhtml+'">'+UTF8Encode(xmlparser(getwiderecord(T.fieldbyname('Name'))))+'</td>');

              if C10.Checked=true then
                Writeln(f,'<td bgcolor="'+colhtml+'">'+UTF8Encode(xmlparser(getwiderecord(T.fields[20])))+'</td>');

              Writeln(f,'</tr>');
            end;
          end;

        end
        else
        if typ=1 then begin  //FROM SCANNER

          if T.fieldbyname('Total_').asinteger=T.fieldbyname('Have_').asinteger then begin
            colhtml:='#006600';
            coldoc:='\cf1';
          end
          else
          if T.fieldbyname('Have_').asinteger=0 then begin
            colhtml:='#CC0000';
            coldoc:='\cf3';
          end
          else begin
            colhtml:='#CC6600';
            coldoc:='\cf2';
          end;

          //offinfotable=nil
          case extyp of
            0,3:begin

              if displaymaster=true then begin
                if showasbytes=true then
                  s:=pointdelimiters(T.fieldbyname('Size_').asinteger)
                else
                  s:=BytesToStr(T.fieldbyname('Size_').ascurrency);

                mount:='';
                if C11.Checked=true then begin
                  if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                    mount:=mount+UTF8Encode(masterlv.header.columns[0].text)+' : ';

                  mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Description'))+csvsep);
                end;
                if C21.Checked=true then begin
                  if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                    mount:=mount+UTF8Encode(masterlv.header.columns[1].text)+' : ';

                  mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Gamename'))+csvsep);
                end;
                if C31.Checked=true then begin
                  if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                    mount:=mount+UTF8Encode(masterlv.header.columns[2].text)+' : ';

                  mount:=mount+pointdelimiters(T.fieldbyname('Have_').asinteger)+' / '+pointdelimiters(T.fieldbyname('Total_').asinteger)+UTF8Encode(csvsep);
                end;
                if C41.Checked=true then begin
                  if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                    mount:=mount+UTF8Encode(masterlv.header.columns[3].text)+' : ';

                  mount:=mount+s+csvsep;
                end;
                if C51.Checked=true then begin
                  if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                    mount:=mount+UTF8Encode(masterlv.header.columns[4].text)+' : ';

                  if offinfotable=nil then begin
                    if (getwiderecord(T.fieldbyname('Master'))=getwiderecord(T.fieldbyname('Description'))) OR (T.fieldbyname('Master').asstring='') then begin
                      mount:=mount+UTF8Encode(csvsep)
                    end
                    else
                      mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Master'))+csvsep);
                  end
                  else begin //Langs
                    mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Language'))+csvsep);
                  end;
                end;

                if offinfotable<>nil then begin
                  if C61.Checked=true then begin
                    if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                      mount:=mount+UTF8Encode(masterlv.header.columns[5].text)+' : ';

                    mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Publisher'))+csvsep);
                  end;
                  if C71.Checked=true then begin
                    if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                      mount:=mount+UTF8Encode(masterlv.header.columns[6].text)+' : ';
                    mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Savetype'))+csvsep);
                  end;
                  if C81.Checked=true then begin
                    if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                      mount:=mount+UTF8Encode(masterlv.header.columns[7].text)+' : ';

                    mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Sourcerom'))+csvsep);
                  end;
                  if C91.Checked=true then begin
                    if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                      mount:=mount+UTF8Encode(masterlv.header.columns[8].text)+' : ';
                    mount:=mount+UTF8Encode(getwiderecord(T.fieldbyname('Comment'))+csvsep);
                  end;
                end;

                mount:=trim(mount);

                Writeln(f,mount);
              end;//Displaymaster en

              //POSSIBLE ROMS INFO
              if displaydetails=true then begin

                detailtable.Locate('Setname',T.fieldbyname('ID').asinteger,[]);

                While (detailtable.FieldByName('Setname').AsInteger=T.FieldByName('ID').asinteger) AND (detailtable.Eof=false) do begin
                  mount:='';
                  pass:=false;

                  if detailtable.FieldByName('Have').asboolean=true then begin
                    if displayhave=true then
                      pass:=true;
                  end
                  else
                  if displaymiss=true then
                    pass:=true;

                  if pass=true then begin

                    if C111.Checked=true then begin
                      if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                        mount:=mount+UTF8Encode(detaillv.header.columns[0].text)+' : ';

                      mount:=mount+UTF8Encode(getwiderecord(detailtable.fieldbyname('Romname'))+csvsep);
                    end;

                    if C121.Checked=true then begin
                      if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                        mount:=mount+UTF8Encode(detaillv.header.columns[1].text)+' : ';

                      if showasbytes=false then
                        mount:=mount+bytestostr(detailtable.fieldbyname('Space').ascurrency)+UTF8Encode(csvsep)
                      else
                        mount:=mount+pointdelimiters(detailtable.fieldbyname('Space').ascurrency)+UTF8Encode(csvsep);
                    end;

                    if C131.Checked=true then begin
                      if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                        mount:=mount+UTF8Encode(detaillv.header.columns[2].text)+' : ';

                      mount:=mount+detailtable.fieldbyname('CRC').asstring+UTF8Encode(csvsep);
                    end;

                    if C141.Checked=true then begin
                      if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                        mount:=mount+UTF8Encode(detaillv.header.columns[3].text)+' : ';

                      if offinfotable=nil then
                        mount:=mount+detailtable.fieldbyname('MD5').asstring+UTF8Encode(csvsep)
                      else
                        mount:=mount+UTF8Encode(csvsep);
                    end;

                    if C151.Checked=true then  begin
                      if (Savecolumntitles1.Checked=true) AND (extyp=0) then
                        mount:=mount+UTF8Encode(detaillv.header.columns[4].text)+' : ';

                      if offinfotable=nil then
                        mount:=mount+detailtable.fieldbyname('SHA1').asstring+UTF8Encode(csvsep)
                      else
                        mount:=mount+UTF8Encode(csvsep);
                    end;

                    mount:=trim(mount);

                    if displaymaster=true then //INDENT
                      mount:='    '+mount;

                    Writeln(f,mount);

                  end;//PASS

                  detailtable.Next;
                end;//WHILE
              end;

            end;
            1:begin
              if displaymaster=true then begin

                mount:=coldoc+aux;

                if C11.Checked=true then begin
                  if Savecolumntitles1.Checked=true then
                    mount:=mount+widestringtoustring(masterlv.header.columns[0].text)+'\b0  : ';
                  mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Description')))+'    \b ';
                end;
                if C21.Checked=true then begin
                  if Savecolumntitles1.Checked=true then
                    mount:=mount+widestringtoustring(masterlv.header.columns[1].text)+'\b0  : ';
                  mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Gamename')))+'    \b ';
                end;
                if C31.Checked=true then begin
                  if Savecolumntitles1.Checked=true then
                    mount:=mount+widestringtoustring(masterlv.header.columns[2].text)+'\b0  : ';
                  mount:=mount+pointdelimiters(T.fieldbyname('Have_').asinteger)+' / '+pointdelimiters(T.fieldbyname('Total_').asinteger)+'    \b ';
                end;
                if C41.Checked=true then begin

                  if showasbytes=true then
                    s:=pointdelimiters(T.fieldbyname('Size_').asinteger)
                  else
                    s:=BytesToStr(T.fieldbyname('Size_').ascurrency);

                  if Savecolumntitles1.Checked=true then
                    mount:=mount+widestringtoustring(masterlv.header.columns[3].text)+'\b0  : ';
                  mount:=mount+s+'    \b ';

                end;
                if C51.Checked=true then begin
                  if Savecolumntitles1.Checked=true then
                    mount:=mount+widestringtoustring(masterlv.header.columns[4].text)+'\b0  : ';

                  if offinfotable=nil then begin
                    if (getwiderecord(T.fieldbyname('Master'))=getwiderecord(T.fieldbyname('Description'))) OR (T.fieldbyname('Master').asstring='') then begin
                      mount:=mount+'    \b '
                    end
                    else
                      mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Master')))+'    \b ';
                  end
                  else begin //Langs
                    mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Language')))+'    \b ';
                  end;
                end;

                if offinfotable<>nil then begin
                  if C51.Checked=true then begin
                    if Savecolumntitles1.Checked=true then
                      mount:=mount+widestringtoustring(masterlv.header.columns[5].text)+'\b0  : ';
                    mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Publisher')))+'    \b ';
                  end;
                  if C61.Checked=true then begin
                    if Savecolumntitles1.Checked=true then
                      mount:=mount+widestringtoustring(masterlv.header.columns[6].text)+'\b0  : ';
                    mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Savetype')))+'    \b ';
                  end;
                  if C71.Checked=true then begin
                    if Savecolumntitles1.Checked=true then
                      mount:=mount+widestringtoustring(masterlv.header.columns[7].text)+'\b0  : ';
                    mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Sourcerom')))+'    \b ';
                  end;
                  if C81.Checked=true then begin
                    if Savecolumntitles1.Checked=true then
                      mount:=mount+widestringtoustring(masterlv.header.columns[8].text)+'\b0  : ';
                    mount:=mount+widestringtoustring(getwiderecord(T.fieldbyname('Comment')))+'    \b ';
                  end;
                end;

                mount:=trim(mount);

                Writeln(f,mount+'\par');
                //Writeln(f,coldoc+aux+widestringtoustring(masterlv.header.columns[0].text)+'\b0  : '+widestringtoustring(getwiderecord(T.fieldbyname('Description')))+'    \b '+widestringtoustring(masterlv.header.columns[1].text)+'\b0  : '+widestringtoustring(getwiderecord(T.fieldbyname('Gamename')))+'    \b '+widestringtoustring(masterlv.header.columns[2].text)+'\b0  : '+pointdelimiters(T.fieldbyname('Have_').asinteger)+' / '+pointdelimiters(T.fieldbyname('Total_').asinteger)+'    \b '+widestringtoustring(masterlv.header.columns[3].text)+'\b0  : '+s+'\par');

                Writeln(f,'\par');
              end; //DISPLAYMASTER

              if displaydetails=true then begin

                detailtable.Locate('Setname',T.fieldbyname('ID').asinteger,[]);
                writen:=false;

                While (detailtable.FieldByName('Setname').AsInteger=T.FieldByName('ID').asinteger) AND (detailtable.Eof=false) do begin

                  pass:=false;

                  if detailtable.FieldByName('Have').asboolean=true then begin
                    if displayhave=true then begin
                      pass:=true;
                      mount:='\cf1'+aux;
                    end;
                  end
                  else
                  if displaymiss=true then begin
                    pass:=true;
                    mount:='\cf3'+aux;
                  end;

                  if pass=true then begin

                    writen:=true;

                    if C111.Checked=true then begin
                      if Savecolumntitles1.Checked=true then
                        mount:=mount+widestringtoustring(detaillv.header.columns[0].text)+'\b0  : ';
                      mount:=mount+widestringtoustring(getwiderecord(detailtable.fieldbyname('Romname')))+'    \b ';
                    end;

                    if C121.Checked=true then begin
                      if Savecolumntitles1.Checked=true then
                        mount:=mount+widestringtoustring(detaillv.header.columns[1].text)+'\b0  : ';

                      if showasbytes=false then
                        mount:=mount+bytestostr(detailtable.fieldbyname('Space').ascurrency)+'    \b '
                      else
                        mount:=mount+pointdelimiters(detailtable.fieldbyname('Space').ascurrency)+' bytes'+'    \b ';
                    end;

                    if C131.Checked=true then begin
                      if Savecolumntitles1.Checked=true then
                        mount:=mount+widestringtoustring(detaillv.header.columns[2].text)+'\b0  : ';
                      mount:=mount+detailtable.fieldbyname('CRC').asstring+'    \b ';
                    end;

                    if C141.Checked=true then begin
                      if Savecolumntitles1.Checked=true then
                        mount:=mount+widestringtoustring(detaillv.header.columns[3].text)+'\b0  : ';
                      if offinfotable=nil then
                        mount:=mount+detailtable.fieldbyname('MD5').asstring+'    \b '
                      else
                        mount:=mount+'    \b ';
                    end;

                    if C151.Checked=true then  begin
                      if Savecolumntitles1.Checked=true then
                        mount:=mount+widestringtoustring(detaillv.header.columns[4].text)+'\b0  : ';
                      if offinfotable=nil then
                        mount:=mount+detailtable.fieldbyname('SHA1').asstring+'    \b '
                      else
                        mount:=mount+'    \b ';
                    end;

                    mount:=trim(mount);

                    if displaymaster=true then //INDENT
                      mount:='    '+mount;

                    Writeln(f,mount+'\par');
                  end;

                  detailtable.Next;
                end;

                if writen=true then
                  Writeln(f,'\par');//LINE JUMP

              end;

            end;
            2:begin
              if displaymaster=true then begin

                if mastertableisopen=false then begin//REPEAT COLUMNS

                  mastertableisopen:=true;

                  if masterdetailsisopen=true then begin
                    Writeln(f,    '</tr>');
                    Writeln(f,' </table>');
                    Writeln(f,'<br>');//LINEBREAK
                    masterdetailsisopen:=false;
                  end;

                  Writeln(f,'<table width="100%" border="0" cellpadding="2" cellspacing="2">');

                  //DISPLAYCOLUMNS?
                  if Savecolumntitles1.Checked=true then begin  //ONE VARIABLE TO NO REPEAT THIS
                    if C11.Checked=true then
                      Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[0].text))+'</span></th>');
                    if C21.Checked=true then
                      Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[1].text))+'</span></th>');
                    if C31.Checked=true then
                      Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[2].text))+'</span></th>');
                    if C41.Checked=true then
                      Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[3].text))+'</span></th>');
                    if C51.Checked=true then  //CLONEOF OR LANG
                      Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[4].text))+'</span></th>');

                    if offinfotable<>nil then begin
                      if C61.Checked=true then
                        Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[5].text))+'</span></th>');
                      if C71.Checked=true then
                        Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[6].text))+'</span></th>');
                      if C81.Checked=true then
                        Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[7].text))+'</span></th>');
                      if C91.Checked=true then
                        Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(masterlv.Header.Columns[8].text))+'</span></th>');
                    end;

                  end;//SAVECOLUMNS
                end;//MASTERTABLEISOPEN

                Writeln(f,  '<tr>');

                if C11.Checked=true then
                  Writeln(f,'<td bgcolor="'+colhtml+'">'+UTF8Encode(xmlparser(getwiderecord(T.fieldbyname('Description'))))+'</td>');
                if C21.Checked=true then
                  Writeln(f,'<td bgcolor="'+colhtml+'">'+UTF8Encode(xmlparser(getwiderecord(T.fieldbyname('Gamename'))))+'</td>');
                if C31.Checked=true then
                  Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+pointdelimiters(T.fieldbyname('Have_').asinteger)+' / '+pointdelimiters(T.fieldbyname('Total_').asinteger)+'</td>');
                if C41.Checked=true then begin
                  if showasbytes=true then
                    s:=pointdelimiters(T.fieldbyname('Size_').asinteger)
                  else
                    s:=BytesToStr(T.fieldbyname('Size_').ascurrency);

                  Writeln(f,'<td bgcolor="'+colhtml+'"><div align="center">'+s+'</td>');
                end;
                if C51.Checked=true then begin

                  if offinfotable=nil then begin
                    if (getwiderecord(T.fieldbyname('Master'))=getwiderecord(T.fieldbyname('Description'))) OR (T.fieldbyname('Master').asstring='') then begin
                      Writeln(f,'<td bgcolor="'+colhtml+'">'+''+'</td>');
                    end
                    else
                      Writeln(f,'<td bgcolor="'+colhtml+'">'+UTF8Encode(xmlparser(getwiderecord(T.fieldbyname('Master'))))+'</td>');
                  end
                  else begin //Langs
                    Writeln(f,'<td bgcolor="'+colhtml+'">'+UTF8Encode(xmlparser(getwiderecord(T.fieldbyname('Language'))))+'</td>');
                  end;
                end;

                Writeln(f,'</tr>');
              end;//DISPLAYMASTER

              if displaydetails=true then begin

                writen:=false;

                detailtable.Locate('Setname',T.fieldbyname('ID').asinteger,[]);

                While (detailtable.FieldByName('Setname').AsInteger=T.FieldByName('ID').asinteger) AND (detailtable.Eof=false) do begin

                  pass:=false;

                  if detailtable.FieldByName('Have').asboolean=true then begin
                    if displayhave=true then begin
                      pass:=true;
                      colhtml2:='#006600';
                    end;
                  end
                  else
                  if displaymiss=true then begin
                    pass:=true;
                    colhtml2:='#CC0000';
                  end;

                  if pass=true then begin

                    if writen=false then begin

                      if mastertableisopen=true then begin
                        mastertableisopen:=false;
                        Writeln(f,'</table>');
                      end;

                      if masterdetailsisopen=false then begin
                        masterdetailsisopen:=true;
                        Writeln(f,'<table width="100%" border="0" cellpadding="2" cellspacing="2">');


                        if Savecolumntitles1.Checked=true then begin //DISPLAY COLUMNS?
                          if C111.Checked=true then
                            Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(detaillv.Header.Columns[0].text))+'</span></th>');
                          if C121.Checked=true then
                            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(detaillv.Header.Columns[1].text))+'</span></th>');
                          if C131.Checked=true then
                            Writeln(f,'<th width="50" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(detaillv.Header.Columns[2].text))+'</span></th>');
                          if C141.Checked=true then
                            Writeln(f,'<th width="100" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(detaillv.Header.Columns[3].text))+'</span></th>');
                          if C151.Checked=true then
                            Writeln(f,'<th width="150" bgcolor="#FFFFFF" scope="col"><span class="Estilo1">'+UTF8Encode(xmlparser(detaillv.Header.Columns[4].text))+'</span></th>');
                        end;
                      end;//MASTERDETAILISOPEN
                    end; //WRITEN

                    writen:=true;

                    Writeln(f,'  <tr>');

                    //CONTINUE FILLING
                    if C111.Checked=true then
                      Writeln(f,' <td bgcolor="'+colhtml2+'">'+UTF8Encode(xmlparser(getwiderecord(detailtable.fieldbyname('Romname'))))+'</td>');
                    if C121.Checked=true then begin
                      if showasbytes=false then
                        s:=bytestostr(detailtable.fieldbyname('Space').ascurrency)
                      else
                        s:=pointdelimiters(detailtable.fieldbyname('Space').ascurrency)+' bytes';
                      Writeln(f,' <td bgcolor="'+colhtml2+'"><div align="center">'+xmlparser(s)+'</td>');
                    end;
                    if C131.Checked=true then
                      Writeln(f,' <td bgcolor="'+colhtml2+'">'+xmlparser(detailtable.fieldbyname('CRC').asstring)+'</td>');
                    if C141.Checked=true then
                      if offinfotable=nil then
                        Writeln(f,' <td bgcolor="'+colhtml2+'">'+xmlparser(detailtable.fieldbyname('MD5').asstring)+'</td>')
                      else
                        Writeln(f,' <td bgcolor="'+colhtml2+'">'+''+'</td>');

                    if C151.Checked=true then
                      if offinfotable=nil then
                        Writeln(f,' <td bgcolor="'+colhtml2+'">'+xmlparser(detailtable.fieldbyname('SHA1').asstring)+'</td>')
                      else
                        Writeln(f,' <td bgcolor="'+colhtml2+'">'+''+'</td>');

                    Writeln(f,'  </tr>');

                  end;

                  detailtable.Next;
                end;//WHILE

                {if writen=true then begin //CLOSE TABLE
                  Writeln(f,'  </tr>');
                  Writeln(f,'</table>');
                end;}

              end; //DISPLAYDETAILS

            end;//2
          end;
        end;
      end; //ADD

      T.next;
      n:=lv.GetNext(n);
    end;

    if extyp=0 then begin
      Writeln(f,'');
      Writeln(f,romulustitle);
      Writeln(f,romulusurl);
    end
    else
    if extyp=1 then begin
      Writeln(f,'\cf0\b '+romulustitle+'\par');
      Writeln(f,'\cf0\b '+romulusurl+'\par');
      Writeln(f,'}');
    end
    else
    if extyp=2 then begin//FINALIZE HTML

      if masterdetailsisopen=true then
        Writeln(f,'   </table>');
      if mastertableisopen=true then
        Writeln(f,'</table>');

      Writeln(f,'<p>'+romulustitle+'<br />');
      Writeln(f,'<a href="'+romulusurl+'">'+romulusurl+'</a></p>');
      Writeln(f,'</body>');
      Writeln(f,'</html>');
    end;

    Closefile(f);

    if movefile2(tdir,SaveDialog1.FileName)=false then
      makeexception;

    //ASK FOR OPEN IF EXISTS AN EXE TO OPEN THE EXTENSION
    if Findexefromextension(Savedialog1.filename)<>'' then
      if mymessagequestion(traduction(215)+#10#13+Savedialog1.filename,false)=1 then
        if extyp=2 then
          Fmain.wb_navigate(savedialog1.FileName,true,false)
        else
          exec(Freport,savedialog1.FileName);

  end;//PASS
end;//EXECUTE

except
  try
    Closefile(f);
  except
  end;

  mymessageerror(traduction(150)+#10#13+Savedialog1.filename);
end;

deletefile2(tdir);

screen.Cursor:=crdefault;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFreport.BitBtn2Click(Sender: TObject);
begin
close;
end;

procedure TFreport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFreport.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFreport.SpeedButton1Click(Sender: TObject);
var
p:TPoint;
begin
//if SpeedButton1.Down then
//begin
GetCursorPos(p);
TntPopupMenu1.Popup(p.X,p.Y);
//application.processmessages;
//SpeedButton1.Down := False;
//end;

end;

procedure TFreport.Selectall1Click(Sender: TObject);
begin
columnscheck(true);
end;

procedure TFreport.Unselectall1Click(Sender: TObject);
begin
columnscheck(false);
end;

procedure TFreport.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
