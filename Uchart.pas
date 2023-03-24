unit Uchart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, strings, Buttons, Math, GR32_Image, Tntforms,
  TntExtCtrls, TntStdCtrls, TntButtons;

type
  TFchart = class(Ttntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label2: TTntLabel;
    Label3: TTntLabel;
    Label4: TTntLabel;
    BitBtn1: TTntBitBtn;
    Label6: TTntLabel;
    Label7: TTntLabel;
    Label8: TTntLabel;
    Label9: TTntLabel;
    Bevel4: TBevel;
    Label12: TTntLabel;
    Label13: TTntLabel;
    Label14: TTntLabel;
    Label15: TTntLabel;
    Label16: TTntLabel;
    Label17: TTntLabel;
    Label18: TTntLabel;
    Label19: TTntLabel;
    Panel5: TTntPanel;
    Panel6: TTntPanel;
    Panel9: TTntPanel;
    Panel10: TTntPanel;
    Panel7: TTntPanel;
    Panel8: TTntPanel;
    Panel11: TTntPanel;
    Panel12: TTntPanel;
    Label10: TTntLabel;
    Label11: TTntLabel;
    Label5: TTntLabel;
    Panel4: TTntPanel;
    Panel2: TTntPanel;
    Panel3: TTntPanel;
    Bevel5: TBevel;
    Label20: TTntLabel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Image321: TImage32;
    Image322: TImage32;
    Image323: TImage32;
    Image324: TImage32;
    Image325: TImage32;
    Image326: TImage32;
    Image327: TImage32;
    Image328: TImage32;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Image329: TImage32;
    Image3210: TImage32;
    Image3211: TImage32;
    Image3212: TImage32;
    Image3213: TImage32;
    Image3214: TImage32;
    Image3215: TImage32;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Fchart: TFchart;

implementation

uses UData, Umain;

{$R *.dfm}

function checkresult(n:ansistring):ansistring;
begin

if n<>'' then
  n:=pointdelimiters(strtoint(n))
else
  n:='0';

Result:=n;
end;

procedure TFchart.FormShow(Sender: TObject);
var
c,total,comp,incomp,empty,unscan:int64;
c2:extended;
begin
Fmain.addtoactiveform((sender as Tform),true);

caption:=traduction(8);
label1.Caption:=traduction(124);
Fmain.labelshadow(label1,Fchart);
BitBtn1.Caption:=traduction(80);

label2.Caption:=traduction(127);

label3.Caption:=traduction(13);
label4.Caption:=traduction(14);
label6.Caption:=traduction(130);
label7.Caption:=traduction(129);
label8.Caption:=traduction(125);
label9.Caption:=traduction(126);

label10.Caption:=traduction(132);
label11.Caption:=traduction(133);
label5.Caption:=traduction(134);
label20.caption:=traduction(135);

Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
Datamodule1.Qaux.SQL.add('SELECT SUM(Haveroms) AS HROMS, SUM(Havesets) AS HSETS, SUM(Totalroms) AS TROMS, SUM(Totalsets) AS TSETS');
Datamodule1.Qaux.SQL.add('FROM Profiles');
Datamodule1.Qaux.open;

label3.Caption:=label3.Caption+' : '+checkresult(Datamodule1.Qaux.Fields[1].AsString);
label4.Caption:=label4.Caption+' : '+checkresult(Datamodule1.Qaux.Fields[0].AsString);

c:=Datamodule1.Qaux.Fields[3].asinteger ;

try
  c:=c-Datamodule1.Qaux.Fields[1].asinteger;
except
end;

label6.Caption:=label6.Caption+' : '+checkresult(inttostr(c));

c:=Datamodule1.Qaux.Fields[2].asinteger ;
try
  c:=c-Datamodule1.Qaux.Fields[0].asinteger;
except
end;
label7.Caption:=label7.Caption+' : '+checkresult(inttostr(c));

label8.Caption:=label8.Caption+' : '+checkresult(Datamodule1.Qaux.Fields[3].AsString);
label9.Caption:=label9.Caption+' : '+checkresult(Datamodule1.Qaux.Fields[2].AsString);


CenterInClient(label6,Fchart);
label6.Top:=label3.top;
CenterInClient(label7,Fchart);
label7.Top:=label4.top;

//Datamodule1.Qaux.Fields[2].asinteger - 100
//Datamodule1.Qaux.Fields[0].asinteger -  x
//ROMS------------------------------------------------
c:=Datamodule1.Qaux.Fields[0].asinteger*100;
c2:=c / Datamodule1.Qaux.Fields[2].asinteger; //0.026
c:=c div Datamodule1.Qaux.Fields[2].asinteger;

image321.Height:=c;
image323.Height:=100-c;
Label12.caption:=FormatFloat('0.00', c2)+'%';
Label13.caption:=FormatFloat('0.00', 100-c2)+'%';

image321.Top:=100-image321.Height+4;
image323.Top:=100-image323.Height+4;

//SETS-------------------------------------------------
c:=Datamodule1.Qaux.Fields[1].asinteger*100;
c2:=c / Datamodule1.Qaux.Fields[3].asinteger; //0.026
c:=c div Datamodule1.Qaux.Fields[3].asinteger;

image324.Height:=c;
image325.Height:=100-c;

Label14.caption:=FormatFloat('0.00', c2)+'%';
Label15.caption:=FormatFloat('0.00', 100-c2)+'%';

image324.Top:=100-image324.Height+4;
image325.Top:=100-image325.Height+4;

Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;

//Total
Datamodule1.Qaux.SQL.add('SELECT COUNT(ID)');
Datamodule1.Qaux.SQL.add('FROM Profiles');
Datamodule1.Qaux.Open;
total:=Datamodule1.Qaux.fields[0].asinteger;
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
//Complete
Datamodule1.Qaux.SQL.add('SELECT COUNT(ID)');
Datamodule1.Qaux.SQL.add('FROM Profiles');
Datamodule1.Qaux.SQL.Add('WHERE Haveroms=Totalroms');
Datamodule1.Qaux.Open;
comp:=Datamodule1.Qaux.fields[0].asinteger;
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
//Incomplete
Datamodule1.Qaux.SQL.add('SELECT COUNT(ID)');
Datamodule1.Qaux.SQL.add('FROM Profiles');
Datamodule1.Qaux.SQL.Add('WHERE Haveroms > 0 AND Haveroms < Totalroms');
Datamodule1.Qaux.Open;
incomp:=Datamodule1.Qaux.fields[0].asinteger;
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
//Empty
Datamodule1.Qaux.SQL.add('SELECT COUNT(ID)');
Datamodule1.Qaux.SQL.add('FROM Profiles');
Datamodule1.Qaux.SQL.Add('WHERE Haveroms = 0');
Datamodule1.Qaux.Open;
empty:=Datamodule1.Qaux.fields[0].asinteger;
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;
//Unscanned
Datamodule1.Qaux.SQL.add('SELECT COUNT(ID)');
Datamodule1.Qaux.SQL.add('FROM Profiles');
Datamodule1.Qaux.SQL.Add('WHERE Haveroms = '+''''+'''');
Datamodule1.Qaux.Open;
unscan:=Datamodule1.Qaux.fields[0].asinteger;
Datamodule1.Qaux.close;
Datamodule1.Qaux.SQL.Clear;

panel5.Caption:=fillwithzeroes(inttostr(comp),4);
panel6.Caption:=fillwithzeroes(inttostr(incomp),4);
panel8.Caption:=fillwithzeroes(inttostr(empty),4);
panel12.Caption:=fillwithzeroes(inttostr(unscan),4);

//Total -100
// value - x
comp:=comp*100;
c2:=comp / total; //0.026
comp:=comp div total;
label16.Caption:=FormatFloat('0.00', c2)+'%';
image322.Height:=comp;
image322.Top:=100-image322.Height+4;

incomp:=incomp*100;
c2:=incomp / total; //0.026
incomp:=incomp div total;
label17.Caption:=FormatFloat('0.00', c2)+'%';
image327.Height:=incomp;
image327.Top:=100-image327.Height+4;

empty:=empty*100;
c2:=empty / total; //0.026
empty:=empty div total;
label18.Caption:=FormatFloat('0.00', c2)+'%';
image326.Height:=empty;
image326.Top:=100-image326.Height+4;

unscan:=unscan*100;
c2:=unscan / total; //0.026
unscan:=unscan div total;
label19.Caption:=FormatFloat('0.00', c2)+'%';
image328.Height:=unscan;
image328.Top:=100-image328.Height+4;


end;

procedure TFchart.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Fchart);
end;

procedure TFchart.BitBtn1Click(Sender: TObject);
begin
close;
end;

procedure TFchart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);

end;

procedure TFchart.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFchart.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
