program Romulus;

{%ToDo 'Romulus.todo'}

uses
  FastMM4,
  ExceptionLog,
  Tntforms,
  Tntsystem,
  Forms,
  Windows,
  Dialogs,
  Messages,
  ShellAPI,
  Sysutils,
  Strings,
  Mymessages,
  Umain in 'Umain.pas' {Fmain},
  Unewfolder in 'Unewfolder.pas' {Fnewfolder},
  Umessage in 'Umessage.pas' {Fmessage},
  Unewdat in 'Unewdat.pas' {Fnewdat},
  Uprocessing in 'Uprocessing.pas' {Fprocessing},
  UData in 'UData.pas' {DataModule1: TDataModule},
  Usettings in 'Usettings.pas' {Fsettings},
  Uscan in 'Uscan.pas' {Fscan},
  Uchart in 'Uchart.pas' {Fchart},
  Ulog in 'Ulog.pas' {Flog},
  Ureport in 'Ureport.pas' {Freport},
  Uupdatedat in 'Uupdatedat.pas' {Fupdatedat},
  Uofflineupdate in 'Uofflineupdate.pas' {Fofflineupdate},
  Uemulators in 'Uemulators.pas' {Femulators},
  Uproperties in 'Uproperties.pas' {Fproperties},
  Uupdater in 'Uupdater.pas' {Fupdater},
  Udirmaker in 'Udirmaker.pas' {Fdirmaker},
  Uask in 'Uask.pas' {Fask},
  Ufilter in 'Ufilter.pas' {Ffilter},
  Ufavorites in 'Ufavorites.pas' {Ffavorites},
  Userver in 'Userver.pas' {Fserver},
  Uofflinefilters in 'Uofflinefilters.pas' {Fofflinefilters},
  UDataserver in 'UDataserver.pas' {DataModule2: TDataModule},
  Usoftselect in 'Usoftselect.pas' {Fsoftselect},
  Uscene in 'Uscene.pas' {Fscene};

var
  RvHandle : hWnd;

{$SetPEFlags $0020} //REMOVED 2GB LIMIT FOR EXE HEADER
{$R uac_xp.RES} //NEW MANIFEST UAC DISSABLED, THEMES ADDED AND ADMIN BOOT
{$R *.res} //Necessary
//{$R myicons.res myicons.rc} //Compression icons

begin
  testmode:=false;
  {if (GetKeyState(VK_SHIFT) < 0) then //COMPRESSOR MODE FUTURE WIP
    showmessage('SHIFT');}

  //shortdateformat must get current system date format
  Application.UpdateFormatSettings:=false;
  decimalseparator:='.';

  //Must force to 1033 to work with all regions
  //Syslocale.DefaultLCID:=1033;
  SetThreadLocale(1033); //1041=JAP 1033=USA
  SysLocale.PriLangID:=LANG_ENGLISH;
  GetFormatSettings;

  //Application.HintHidePause:=3000;//SHOWING TIME DEF 2500
  //Application.HintPause:=100;//TIME TO DISPLAY

  if Win32MajorVersion<5 then begin
    showmessage('Your O.S is no longer supported by Romulus. Update your O.S to Windows XP or later. Sorry :(');
    halt;
  end;

  RvHandle := FindWindow('@RMLPRJ@.UnicodeClass', NIL);

  if RvHandle > 0 then begin
    PostMessage(RvHandle, CM_RESTORE, 0, 0);
    Exit;
  end;

  //IsUserAdmin
 try //Removed sinze 0.027
  {if Win32Platform = VER_PLATFORM_WIN32_NT then //ONLY FOR NT BASED OS

    If (lowercase(Paramstr(1))<>'admin') AND (Win32MajorVersion<>5) then begin
      RunAsAdmin(0,TntApplication.ExeName,'admin'); //NEEDED FOR VISTA AND LATER UAC FIX
      halt;
    end;     }

    AddApplicationToWinFirewall(romulustitle,TntApplication.ExeName);

  except
  end;

  installfonts;
  
  try
    TntSystem.InstallTntSystemUpdates; //0.030
  except
  end;
  Application.Initialize;
  Application.Title := 'Romulus';
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFmain, Fmain);
  Application.CreateForm(TFlog, Flog);
  Application.CreateForm(TFserver, Fserver);
  Application.CreateForm(TDataModule2, DataModule2);
  //Application.CreateForm(TFscene, Fscene);
  //Application.CreateForm(TFsoftselect, Fsoftselect);
  //Application.CreateForm(TFofflinefilters, Fofflinefilters);
  //Application.CreateForm(TFfavorites, Ffavorites);
  //Application.CreateForm(TFask, Fask);
  //Application.CreateForm(TFdirmaker, Fdirmaker);
  //Application.CreateForm(TFupdater, Fupdater);
  //Application.CreateForm(TFproperties, Fproperties);
  //Application.CreateForm(TFemulators, Femulators);
  //Application.CreateForm(TFofflineupdate, Fofflineupdate);
  //Application.CreateForm(TFupdatedat, Fupdatedat);
  //Application.CreateForm(TFreport, Freport);
  //Application.CreateForm(TFDirectorytree, FDirectorytree);
  //Application.CreateForm(TFsettings, Fsettings);
  //Application.CreateForm(TFchart, Fchart);
  //Application.CreateForm(TFscan, Fscan);
  //Application.CreateForm(TFprocessing, Fprocessing);
  //Application.CreateForm(TFnewdat, Fnewdat);
  //Application.CreateForm(TFmessage, Fmessage);
  //Application.CreateForm(TFnewfolder, Fnewfolder);
  //Application.CreateForm(TFfilter, Ffilter);
  Application.Run;
end.
