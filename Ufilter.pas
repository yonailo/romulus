unit Ufilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, strings, GR32_Image, Tntforms,
  TntExtCtrls, TntStdCtrls, TntButtons;

type
  TFfilter = class(Ttntform)
    Panel1: TTntPanel;
    Label1: TTntLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    RadioGroup1: TTntRadioGroup;
    RadioGroup2: TTntRadioGroup;
    CheckBox1: TTntCheckBox;
    Bevel4: TBevel;
    BitBtn1: TTntBitBtn;
    BitBtn3: TTntBitBtn;
    BitBtn5: TTntBitBtn;
    Label3: TTntLabel;
    Label4: TTntLabel;
    Bevel3: TBevel;
    Edit2: TTntEdit;
    CheckBox2: TTntCheckBox;
    Image321: TImage32;
    Image3210: TImage32;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
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
  Ffilter: TFfilter;

implementation

uses Umain, UData;

{$R *.dfm}

procedure TFfilter.FormCreate(Sender: TObject);
begin
Fmain.fixcomponentsbugs(Ffilter);
end;

procedure TFfilter.BitBtn3Click(Sender: TObject);
begin
screen.Cursor:=crHourGlass;
Fmain.invertcheckedconstructor;
screen.Cursor:=crdefault;
end;

procedure TFfilter.FormShow(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
  
caption:=traduction(464);

label1.caption:=traduction(462);
Fmain.labelshadow(label1,Ffilter);
label4.Caption:=traduction(137);
label3.Caption:=traduction(466)+' :';
RadioGroup2.Caption:=traduction(467);

radiogroup2.Items.Clear;
radiogroup2.Items.Add(traduction(468));
radiogroup2.Items.Add(traduction(469));
radiogroup2.Items.Add(traduction(470));
radiogroup2.Items.Add(traduction(471));

RadioGroup1.Caption:=traduction(472);
radiogroup1.Items.Clear;
radiogroup1.Items.Add(traduction(473));
radiogroup1.Items.Add(traduction(474));
radiogroup1.Items.Add(traduction(475));

checkbox1.Caption:=traduction(476);
checkbox2.Caption:=traduction(477);

BitBtn1.Caption:=traduction(123);
bitbtn3.Caption:=traduction(478);
BitBtn5.Caption:=traduction(217);

//FIX POSSIBLE INI MODIFICATION
if (filterdetection<0) OR (filterdetection>3) then
  filterdetection:=1;

if (filtersearchin<0) OR (filtersearchin>2) then
  filtersearchin:=2;

edit2.Text:=filtertext;
RadioGroup2.ItemIndex:=filterdetection;
radiogroup1.ItemIndex:=filtersearchin;
checkbox1.Checked:=filtermatch;
checkbox2.Checked:=filteruncheck;
end;

procedure TFfilter.BitBtn1Click(Sender: TObject);
var
ignorecase:boolean;
detection,searchin:shortint;
continue:boolean;
text,compare:widestring;
rec:longint;
begin
text:=edit2.text;

if text='' then
  exit;

screen.Cursor:=crHourGlass;
  
ignorecase:=checkbox1.checked;
detection:=radiogroup2.itemindex;
searchin:=radiogroup1.itemindex;

if checkbox2.checked=true then
  Fmain.uncheckallconstructor;

Datamodule1.Tconstructor.first;
Datamodule1.DBconstructor.StartTransaction;

While datamodule1.Tconstructor.eof=false do begin

  continue:=true;

  if searchin<>2 then
    if (Datamodule1.Tconstructor.fieldbyname('Origin').asinteger=0) then begin
      if searchin<>0 then
        continue:=false;
    end
    else
      if searchin<>1 then
        continue:=false;

  if continue=true then begin

    compare:=getwiderecord(Datamodule1.Tconstructor.fieldbyname('filename'));
    continue:=False;

    case detection of
      0:if wideuppercase(text)=wideuppercase(compare) then
          if ignorecase=false then begin
            if text=compare then
              continue:=true;
          end
          else
            continue:=true;
      1:if gettokencount(wideuppercase(compare),wideuppercase(text))>1 then
          if ignorecase=false then begin
            if gettokencount(compare,text)>1 then
              continue:=true;
          end
          else
            continue:=true;
      2..3:begin
            if length(compare)>=length(text) then begin
            
              if detection=2 then
                compare:=copy(compare,0,length(text))
              else
                compare:=copy(compare,length(compare)-length(text)+1,length(compare)+length(text));

              if wideuppercase(compare)=wideuppercase(text) then
                if ignorecase=false then begin
                  if compare=text then
                    continue:=true;
                end
                else
                  continue:=true;
            end;
          end;
    end;

    if (continue=true) AND (Datamodule1.Tconstructor.fieldbyname('Checked').asboolean=false) then begin

      rec:=Datamodule1.Tconstructor.fieldbyname('CONT').asinteger;

      if Datamodule1.Tconstructor.fieldbyname('Origin').asinteger=0 then begin
        //IF CHECK MASTER MUST CHECK OTHER CHILDS
        Datamodule1.Tconstructor.edit;
        Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
        Datamodule1.Tconstructor.post;

          while Datamodule1.Tconstructor.locate('Origin;checked',VarArrayOf([rec,false]),[])=true do begin
            Datamodule1.Tconstructor.edit;
            Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
            Datamodule1.Tconstructor.post;
          end;

      end
      else begin
        //IF CHECK ONE CHILD MUST CHECKED MASTER
        Datamodule1.Tconstructor.edit;
        Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
        Datamodule1.Tconstructor.post;

        Datamodule1.Tconstructor.locate('CONT',Datamodule1.Tconstructor.fieldbyname('Origin').asinteger,[]);

        if Datamodule1.Tconstructor.fieldbyname('Checked').asboolean=false then begin
          Datamodule1.Tconstructor.edit;
          Datamodule1.Tconstructor.fieldbyname('Checked').asboolean:=true;
          Datamodule1.Tconstructor.post;
        end;

      end;

      //RECOVERY POSITION
      Datamodule1.Tconstructor.locate('CONT',rec,[]);

    end;
  end;

  Datamodule1.Tconstructor.next;
end;

Datamodule1.DBconstructor.commit(true);
Fmain.checkconstructorstatus;

Fmain.VirtualStringTree4.Repaint;

screen.Cursor:=crdefault;

freemousebuffer;
freekeyboardbuffer;
end;

procedure TFfilter.BitBtn5Click(Sender: TObject);
begin
close;
end;

procedure TFfilter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Fmain.addtoactiveform((sender as Tform),false);
filtertext:=edit2.Text;
filterdetection:=RadioGroup2.ItemIndex;
filtersearchin:=radiogroup1.ItemIndex;
filtermatch:=checkbox1.Checked;
filteruncheck:=checkbox2.Checked;
end;

procedure TFfilter.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFfilter.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then
  close;
end;

end.
