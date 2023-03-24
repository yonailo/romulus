unit Uprocessing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, strings, ComCtrls, CommCtrl, Buttons,
  GR32_Image,Tntforms, TntExtCtrls, TntButtons, TntStdCtrls,Uxtheme,
  ImgList;

type
  TFprocessing = class(Ttntform)
    Panel1: TTntPanel;
    Timer1: TTimer;
    Label3: TTntLabel;
    Label1: TTntLabel;
    Panel2: TTntPanel;
    SpeedButton1: TTntSpeedButton;
    Panel3: TTntPanel;
    Image321: TImage32;
    ImageList1: TImageList;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    starttime : int64;
  public
    { Public declarations }
  end;

var
  Fprocessing: TFprocessing;
  animbmp:Tbitmap;

implementation

uses Umain;

{$R *.dfm}
function timebetween(oldtime:Tdatetime):string;
begin
Result:=FormatDateTime('hh:nn:ss',now - oldtime);
end;

procedure TFprocessing.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
canclose:=false;
end;

procedure TFprocessing.Timer1Timer(Sender: TObject);
begin
timer1.Enabled:=false;
//Application.HandleMessage;

try
  label3.Caption:=traduction(66)+' : '+formatinclock(gettickcount-starttime);


  ImageList1.GetBitmap(timer1.tag,animbmp);
  image321.Bitmap.Assign(animbmp);

  timer1.tag:=timer1.tag+1;

  if timer1.tag>ImageList1.Count-1 then
    timer1.tag:=0;

except
end;

timer1.Enabled:=true;
end;

procedure TFprocessing.FormShow(Sender: TObject);
begin
starttime:=gettickcount;
Fmain.addtoactiveform((sender as Tform),true);

Timer1Timer(sender);
timer1.Enabled:=true;
end;

procedure TFprocessing.FormCreate(Sender: TObject);
begin
animbmp:=Tbitmap.create;
Fmain.fixcomponentsbugs(Fprocessing);

//FIX 0.028 Marquee progress
{Progressbar1.DoubleBuffered:=false;
SetWindowLong(ProgressBar1.Handle, GWL_STYLE, GetWindowLong(ProgressBar1.Handle, GWL_STYLE) or $08);
SendMessage(ProgressBar1.Handle, WM_USER+10, 0, 60); //DO MANUAL PROGRESS
SendMessage(ProgressBar1.Handle, WM_USER+10, 1, 60); //DO MANUAL PROGRESS   }
//timer2.Enabled:=true;
//end;

label1.Caption:=traduction(67);
Fmain.labelshadow(label1,Fprocessing);
speedbutton1.Caption:=traduction(143);
end;

procedure TFprocessing.SpeedButton1Click(Sender: TObject);
begin
speedbutton1.Enabled:=false;
SpeedButton1.Caption:=traduction(339);
Fprocessing.Tag:=1;
end;

procedure TFprocessing.FormActivate(Sender: TObject);
begin
Fmain.addtoactiveform((sender as Tform),true);
end;

procedure TFprocessing.FormDestroy(Sender: TObject);
begin
Freeandnil(animbmp);
//Fmain.addtoactiveform((sender as Tform),false);
end;

end.
