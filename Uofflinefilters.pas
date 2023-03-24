unit Uofflinefilters;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_Image, ExtCtrls, StdCtrls, Buttons, ComCtrls, strings, DB, Tntforms,
  TntExtCtrls, TntStdCtrls, TntButtons, Tntgraphics;

type
  TFofflinefilters = class(Ttntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Image329: TImage32;
    Edit1: TTntEdit;
    Label2: TTntLabel;
    Label3: TTntLabel;
    Label4: TTntLabel;
    ComboBox1: TTntComboBox;
    Label5: TTntLabel;
    ComboBox2: TTntComboBox;
    Label6: TTntLabel;
    ComboBox3: TTntComboBox;
    BitBtn1: TTntBitBtn;
    BitBtn2: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    Bevel5: TBevel;
    Label7: TTntLabel;
    ComboBox4: TTntComboBox;
    Image3210: TImage32;
    Label8: TTntLabel;
    Bevel3: TBevel;
    TntComboBox1: TTntComboBox;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox4Enter(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure ComboBox3Enter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TntComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TntComboBox1Enter(Sender: TObject);
    procedure TprofilesFilterRecord(DataSet: TDataSet;var Accept: Boolean);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure traductfofflinefilters();
    procedure fillcomboboxvalues(Obj:Tobject);
  end;

const
  return=' ';
var
  Fofflinefilters: TFofflinefilters;
  filtdescription,filtlocationum,filtpublisher,filtsavetype,filtsourcerom,filtlanguage:widestring;
implementation

uses Umain, UData;

{$R *.dfm}

procedure TFofflinefilters.TprofilesFilterRecord(DataSet: TDataSet;var Accept: Boolean);
var
res:boolean;
begin
//CHECK RECORD BY RECORD
{
Description
Locationnum
Publisher
Savetype
Sourcerom
[Language]
}
res:=true;

if filtdescription<>return then
  res:=gettokencount(wideuppercase(getwiderecord(Dataset.fieldbyname('Description'))),wideuppercase(filtdescription))>1;

if (filtlocationum<>return) AND (res=true) then
  res:=Dataset.FieldByName('Locationnum').AsString=filtlocationum;

if (filtpublisher<>return) AND (res=true) then
  res:=getwiderecord(Dataset.FieldByName('Publisher'))=filtpublisher;

if (filtsavetype<>return) AND (res=true) then
  res:=getwiderecord(Dataset.FieldByName('Savetype'))=filtsavetype;

if (filtsourcerom<>return) AND (res=true) then
  res:=getwiderecord(Dataset.FieldByName('Sourcerom'))=filtsourcerom;

if (filtlanguage<>return) AND (res=true) then
  res:=gettokencount(getwiderecord(Dataset.FieldByName('Language')),filtlanguage)>1;

Accept:=res;
end;

procedure TFofflinefilters.fillcomboboxvalues(Obj:Tobject);
var
x,y,id:integer;
c:TTntcombobox;
field,order:string;
aux:widestring;
put:boolean;
acceptempty:boolean;
firstvalue:widestring;
begin

if obj is TTntcombobox then begin
  c:=(obj as TTntcombobox);
  if c.tag<>0 then
    exit;

  c.tag:=1;
  if c.name='TntComboBox1' then
    id:=0
  else
    id:=strtoint(c.Name[length(c.Name)]);
end
else
  exit;

screen.Cursor:=crHourGlass;

try
  firstvalue:=c.Items.Strings[c.Items.count-1];
except
end;

c.Items.BeginUpdate;

case id of
  0:begin
      field:='Location,locationnum';
      order:='Locationnum';
  end;
  1:field:='Publisher';
  2:field:='Savetype';
  3:field:='Sourcerom';
  4:field:='[Language]';

end;

if order='' then
  order:=field;

//Location, Language, Publisher, Savetype, Sourcerom

Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.SQL.Add('SELECT DISTINCT '+field+' FROM O'+Fmain.getcurrentprofileid);
Datamodule1.Qaux.SQL.Add('ORDER BY '+order);
Datamodule1.Qaux.Open;

//FIX
field:=Changein(field,'[','');
field:=Changein(field,']','');
order:=Changein(order,']','');
order:=Changein(order,']','');

if id=0 then begin

  field:=gettoken(field,',',1);

  for x:=0 to Datamodule1.Qaux.RecordCount-1 do begin
    c.Items.Add(getwiderecord(Datamodule1.Qaux.fieldbyname(field))+'"'+Datamodule1.Qaux.fieldbyname('Locationnum').asstring);
    Datamodule1.Qaux.Next;
  end;

end
else
if id=4 then begin

  for x:=0 to Datamodule1.Qaux.RecordCount-1 do begin

    aux:=getwiderecord(Datamodule1.Qaux.fieldbyname(field));

    for y:=1 to GetTokenCount(aux,' - ') do
      if c.Items.IndexOf(gettoken(aux,' - ',y))=-1 then  //NO DUPES
        c.Items.add(gettoken(aux,' - ',y));

    Datamodule1.Qaux.Next;
  end;

end
else begin

  acceptempty:=true;
  if c.ItemIndex<>-1 then
    if c.Items.Strings[c.ItemIndex]='' then
      acceptempty:=false;

  for x:=0 to Datamodule1.Qaux.RecordCount-1 do begin

    put:=false;

    if c.items.IndexOf(Datamodule1.Qaux.fieldbyname(field).asstring)<>-1 then begin//NO DUPES
      c.Items.Delete(c.items.IndexOf(getwiderecord(Datamodule1.Qaux.fieldbyname(field))));
      put:=true;
    end;

    //FIX
    if (Datamodule1.Qaux.fieldbyname(field).asstring<>'') OR (acceptempty=true) then
      c.Items.Add(getwiderecord(Datamodule1.Qaux.fieldbyname(field)));

    if put=true then
      c.ItemIndex:=c.items.IndexOf(getwiderecord(Datamodule1.Qaux.fieldbyname(field)));

    Datamodule1.Qaux.Next;
  end;
end;

Datamodule1.Qaux.close;
try
  c.itemindex:=c.Items.IndexOf(firstvalue);
except
  c.itemindex:=0;
end;

screen.Cursor:=crDefault;

c.Items.Endupdate;
end;

procedure TFofflinefilters.traductfofflinefilters();
const
dpoint=' :';
begin
caption:=traduction(536);
label1.caption:=traduction(465);
Fmain.labelshadow(label1,Fofflinefilters);
//Location, Language, Publisher, Savetype, Sourcerom
label8.Caption:=traduction(137);

label2.Caption:=traduction(11)+dpoint;
label3.Caption:=traduction(231)+dpoint;
label7.Caption:=traduction(230)+dpoint;
label4.Caption:=traduction(226)+dpoint;
label5.Caption:=traduction(227)+dpoint;
label6.Caption:=traduction(232)+dpoint;

BitBtn2.Caption:=traduction(123);
BitBtn1.Caption:=traduction(80);
bitbtn3.Caption:=traduction(217);
end;

procedure TFofflinefilters.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fofflinefilters);
traductfofflinefilters;
end;

procedure TFofflinefilters.BitBtn3Click(Sender: TObject);
begin
close;
end;

procedure TFofflinefilters.BitBtn2Click(Sender: TObject);
var
value:widestring;
pan:TTntpanel;
applyfilter:boolean;
begin
applyfilter:=true;
//HERE SAVES FILTER VALUES
pan:=Fmain.getpanelfilter;

//RESET VALUES
filtdescription:=return;
filtlocationum:=return;
filtpublisher:=return;
filtsavetype:=return;
filtsourcerom:=return;
filtlanguage:=return;

edit1.Text:=trim(edit1.text);
if edit1.Text<>'' then
  filtdescription:=edit1.text;

if TntComboBox1.ItemIndex>0 then
  filtlocationum:=gettoken(Tntcombobox1.items.Strings[Tntcombobox1.ItemIndex],'"',2);

if combobox4.ItemIndex>0 then
  filtlanguage:=combobox4.Items.Strings[ComboBox4.ItemIndex];

if combobox1.itemindex>0 then
  filtpublisher:=combobox1.Items.Strings[ComboBox1.ItemIndex];

if combobox2.itemindex>0 then
  filtsavetype:=combobox2.Items.Strings[ComboBox2.ItemIndex];

if combobox3.ItemIndex>0 then
  filtsourcerom:=combobox3.Items.Strings[ComboBox3.ItemIndex];

value:=filtdescription+#13#10;
value:=value+filtlocationum+#13#10;
value:=value+filtlanguage+#13#10;
value:=value+filtpublisher+#13#10;
value:=value+filtsavetype+#13#10;
value:=value+filtsourcerom+#13#10;


//SKIP DETECTION
if (mastertable.Filtered=true) AND (pan.Caption=value) then
  exit;

if (filtdescription=return) AND (filtlocationum=return) AND (filtlanguage=return) AND (filtpublisher=return) AND (filtsavetype=return) AND (filtsourcerom=return) then
  applyfilter:=false;

if (mastertable.Filtered=false) AND (applyfilter=false) then
  exit;

pan.caption:=value;

if applyfilter=true then //0.032 FIX
  Fmain.applyfilterlaststep(false);

Fmain.applyfilterlaststep(applyfilter);
end;

procedure TFofflinefilters.BitBtn1Click(Sender: TObject);
begin
BitBtn2Click(sender);
close;
end;

procedure TFofflinefilters.FormShow(Sender: TObject);
var
x,y:integer;
value:widestring;
begin
Fmain.addtoactiveform((sender as Tform),true);

TntComboBox1.Items.Add('< '+traduction(36)+' >'+'"'+inttostr(Fmain.ImageList5.Count-1));//LAST ICON IS WORLD
combobox1.Items.Add('< '+traduction(36)+' >');
combobox2.Items.Add('< '+traduction(36)+' >');
combobox3.Items.Add('< '+traduction(36)+' >');
combobox4.Items.Add('< '+traduction(36)+' >');

if mastertable.Filtered=true then
for x:=1 to gettokencount(Fmain.getpanelfilter.caption,#13#10) do begin
  value:=gettoken(Fmain.getpanelfilter.caption,#13#10,x);
  if value<>return then
    case x of
      1:edit1.Text:=value; //Description
      2:begin //Locationnum
        fillcomboboxvalues(tntcombobox1);
        for y:=0 to TntComboBox1.Items.Count-1 do
          if gettoken(tntcombobox1.Items.Strings[y],'"',2)=value then begin
            TntComboBox1.ItemIndex:=y;
            break;
          end;
        end;
      3:begin  //Language
        combobox4.Items.Add(value);
        combobox4.ItemIndex:=1;
        end;
      4:begin //Publisher
        combobox1.Items.Add(value);
        combobox1.ItemIndex:=1;
        end;
      5:begin //Savetype
        combobox2.Items.Add(value);
        combobox2.ItemIndex:=1;
        end;
      6:begin //Sourcerom
        combobox3.Items.Add(value);
        combobox3.ItemIndex:=1;
        end;
    end;

end;

if tntcombobox1.ItemIndex=-1 then
  tntcombobox1.ItemIndex:=0;

if combobox1.ItemIndex=-1 then
  combobox1.ItemIndex:=0;

if combobox2.ItemIndex=-1 then
  combobox2.ItemIndex:=0;

if combobox3.ItemIndex=-1 then
  combobox3.ItemIndex:=0;

if combobox4.ItemIndex=-1 then
  combobox4.ItemIndex:=0;

mastertable.OnFilterRecord:=TprofilesFilterRecord;
end;

procedure TFofflinefilters.ComboBox4Enter(Sender: TObject);
begin
fillcomboboxvalues(sender);
end;

procedure TFofflinefilters.ComboBox1Enter(Sender: TObject);
begin
fillcomboboxvalues(sender);
end;

procedure TFofflinefilters.ComboBox2Enter(Sender: TObject);
begin
fillcomboboxvalues(sender);
end;

procedure TFofflinefilters.ComboBox3Enter(Sender: TObject);
begin
fillcomboboxvalues(sender);
end;

procedure TFofflinefilters.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFofflinefilters.TntComboBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
tntcombobox1.canvas.fillrect(rect);
Fmain.imagelist5.Draw(tntcombobox1.Canvas,rect.left,rect.top,strtoint(gettoken(tntcombobox1.items[index],'"',2)));//Get index
WideCanvasTextOut(tntcombobox1.canvas,rect.left+Fmain.imagelist5.width+2,rect.top+1,gettoken(tntcombobox1.items[index],'"',1));

if odfocused in state then  //DISABLE FOCUS DOTTED
  tntcombobox1.canvas.DrawFocusRect(rect);

end;

procedure TFofflinefilters.TntComboBox1Enter(Sender: TObject);
begin
fillcomboboxvalues(sender);
end;

procedure TFofflinefilters.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
end;

procedure TFofflinefilters.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.



