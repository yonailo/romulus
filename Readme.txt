< ROMULUS ROM MANAGER >

  ROM Manager developed by F0XHOUND
  Tutorial can be found at https://romulus.cc/tutorial/tutorial.php
  Homepage https://romulus.cc
  Email playwithfire@hotmail.com
  Translators : F0XHOUND, Kludge, SpaceAgeHero, Thallyrion, Kaito-Kito, Xiao, Caboteta, Squalo, Jangminsoo, Agus, xlmldh, Michip, Elijah067
  Betatesters : SpaceAgeHero, Kaito Kito, Mr Ravik, Thallyrion, Grinderedge, Elfish, EmuLOAD, Maero, Xiao, xTMODx, Agus, ToniBC, RowlaxX

< REQUIREMENTS >

  Really Romulus can be runned in every computers with Windows XP, Vista, 7, 8, 8.1, 10 and probably in 
  future Windows versions including 64bits releases. 
  Some users tested Romulus using WINE (Windows interpreter for different OS), and reports works fine.
  Overall speed is different in computers with quick CPUs, more RAM memory or quick Hard Drives.
  Romulus was tested under different computers speed, and the result is...

  Minimum Requirements

  INTEL or AMD Single Core Processor of 1Ghz
  RAM 2Gb
  HDD with some Mb free, but enought for Database that will be increasing when you add new DAT files.
  HDD formated in NTFS/ExFAT is required for more than 4Gb databases.

  Recommended Requirements

  INTEL Core I5 or Ryzen5 2Ghz processor or higher
  RAM 8Gb
  SSD with some Mb free, but enought for Database that will be increasing when you add new DAT files.
  HDD formated in NTFS/ExFAT is required for more than 4Gb databases.

< CURRENT VERSION >

0.047

- FIXED Updater displaying profiles list. Thanks to Rowlaxx 
- ADDED Information at bottom of Main form if window is set as stay on top or normal.
- ADDED Updater new DAT group. Gruby's Adventure packs.
- ADDED Updater new DAT group. Retroplay - English translations and MSU chips.
- ADDED Updater new DAT group. Super Mario World Hacks.
- ADDED to Updater an option to store downloaded DATs after imported it or delete it.
- ADDED to Updater a button to display downloaded DATs folder in your file explorer.
- ADDED to Updater popuplist. Select all and invert selection options.
- ADDED to Updater popupmenu new option, download without prompts.
- CHANGED Updater doubleclick in list now will download selected profile DAT.
- FIXED Some minor visuals.


0.046

- IMPROVED Speed at scanning when profile has big compressed sets with thousand of files inside folders.
- IMPROVED Compatibility importing softwarelist DATs.
- WRITED Native CHD header reader. No more CHDMAN binaries needed. Now CHDs detection is more fast.
- FIXED Extract to option of Scanner details list popupmenu.
- FIXED Popupmenu display when right click at Profiles treelist at a new node.
- FIXED Import DAT from MAME based EXE option.
- FIXED Lost displaying file extension when using generator in a not compressed files.
- FIXED Locked folders when search files inside for scan/rebuild process.
- FIXED Mousewheel function at lists when list is in a dissabled window.
- FIXED Duplicated files copying files from Scanner - copy selection popupmenu option. Thanks to ToniBC
- FIXED Some visuals.
- RECODED All updater search dats process. Now is more accurate.
- ADDED Description column to updater dats list.
- ADDED Autodownload dats option at updater dats list. Including batch download process. Thanks to RowlaxX for his incredible work.
- ADDED Tons of new dats groups like Connie, DatsSite, MAME, Dos Collections.
- ADDED Statusbar information if main form is on stay normal or stay on top mode.
- REMOVED Rawdump from Updater list. Seems Rawdump project is dead :(

0.045

- CHANGED Romulus web host to https://romulus.cc
- ADDED shutdown or hibernate OS when scan or rebuild process ends. From scanner/rebuilder window use the hourglass button to set this option.
- ADDED support for longpaths at add DATs function. 
- ADDED support for longpaths at Builder option
- ADDED support for XML DATs without header information. Thanks to ToniBC
- ADDED Tagalog "Philippine" language. Thanks to Elijah067
- ADDED Tagalog language OS autodetection on Romulus first run.
- IMPROVED Speed at dislaying profiles list.
- FIXED Copy file option from scanner list popupmenu when origin drive is same as destination drive doing a move operation not a copy. Thanks to ToniBC
- FIXED Displaying header filename when batch process are running.

0.044

- ADDED A lot of new code for Community module. Working hard to make this dream reality.
- CHANGED Romulus web host to https://romulusrommanager.000webhostapp.com/ 
- FIXED Popupmenu from Scanner-Profiles tabs.
- FIXED Rare rendering problem when updating status icons of Scanner-Profiles tabs.
- FIXED Notifications display in Windows 10.
- FIXED Center on screen forms by compiler bug.
- FIXED Visuals displaying forms.

0.043a

- FIXED Sorting profiles and games list on column click. 

0.043

- ADDED Cache for compressed files. Up to 5000% speedup reading compressed files after 1st scan. Thanks to Agus for his insistence.
- ADDED Cache for rebuilding uncompressed and compressed files. Up to 5000% speedup process after 1st rebuild. Thanks to Agus for his insistence.
- ADDED At Updater DATs option popupmenu to select to open URLs with integrated navigator or default system navigator.
- ADDED Copy to clipboard option at popupmenu in lists. With this you can copy to clipboard under mouse text.
- ADDED detection of <CLRMAMEPRO HEADER> param at importation DATs.
- INCREASED Cache compression.
- REWRITED Cache for Offlinelist updating images. Now is more accurate.
- FIXED Reading 7z files with some special compression methods. Thanks to Agus
- FIXED Rebuild results when a compressed file is manually removed and is added again using rebuild function.
- FIXED Close tab button position.
- FIXED Saving default XML header filename when a new DAT is imported.
- FIXED incorrect behavior in some parts when mouse buttons are swapped.
- UPDATED CHDMAN binaries to 0.211 version.
- UPDATED 7z binaries to 19.00 version
- UPDATED RAR binaries to 5.71 version

0.042

- FIXED problems reading/writing files and sometimes crashes when managing long path filenames.
- IMPROVED Speed at Offlinelist profiles updating/downloading pictures and less CPU usage.
- ADDED Cache for Offlinelist profiles images updater.
- ADDED Close button for tabs.
- ADDED Polish language. Thanks to Michip
- ADDED Polish O.S language detection when Romulus first run.
- CHANGED Languages list from settings in native language country names.
- MINOR Bug fixes.

0.041

- FIXED batch scan/rebuild start problem from profiles list option.
	
0.040

- FIXED problems getting information from CHDs in paths with "%" chars.
- FIXED rebuilding files in profiles with CHDs and no ROMs.
- IMPROVED recovering last focus when closing forms to go back.
- NO MORE flickering when batch run for rebuild or scan. More speed added because is not necessary to close and reopen window for every profile.
- REWRITED saving cache by some problems. Now old cache files won't work you must rescan again to save new cache files.
- REMOVED Trurip dat group for Updater. Trurip is dead ?
- UPDATED CHDMAN binaries to 0.205 version.

0.039

- ADDED A copy files option from Scanner master list. Now you can select sets and use this option to copy to a folder without extract them. Thanks to Michael Lachmann
- FIXED bug releasing Zip file(s) after extract them from "extract selected files to..." option from scanner main menu.
- FIXED Importation problems when Clone/s has same file/s of Master set with different checksums.Now this is detected and the Master/Clone relationshing must be dissabled.
- FIXED Problems managing compressed files in RAR and 7z format that contains "%" chars.
- FIXED XML param <homepage> to <homeweb> in DAT files.
- FIXED Problems reading PNG images with unicode path at Windows 10 and maybe other last OS.
- FIXED Bugs releasing vars when closing Romulus.
- SPEED new hack for uncompressed files scan.


0.038

- FIXED Problems with invert selection and mark and unmark option at Constructor. Thanks to Agus
- FIXED Problems with minimization/maximization with Modal Forms. Thanks to Teo Teorex
- FIXED RTF encoding problems again to display messages.
- FIXED Problems executing commandline with non ASCII characters in Asian Windows versions. Thanks to xlmldh.
- FIXED Samples detection at Clrmamepro old DATs format. Thanks to zousizhe

0.037

- ADDED a speed hack at rebuild files when trying to check duplicated checksums.
- ADDED Message question when trying to close Romulus.
- ADDED A description modification mask for Offlinelist profiles. Thanks to xlmldh.
- ADDED Simplifed chinese and Traditional chinese language by xlmldh.
- ADDED Detection of OS region China or Taiwan to set Simplified/Traditional chinese as default language at first run.
- ADDED Forze MD5 and/or SHA-1 message in log at profiles that needs it because has not enought CRC32 information.
- ADDED Detection of "No Sets information DATs" displaying this message and not an error reading DAT.
- ADDED Support for DOSCenter based DATs. More info at http://www.totaldoscollection.org/DOSCenter/
- ADDED to Community a basic module to connect to Romulus server with communications using private or public chats and 256bits encryption. 
- FIXED File writing problems in some cases.
- FIXED Problems deleting files inside 7zip archives created with old 7zip versions.
- FIXED Displaying DATE and TIME values ignoring your system configuration.
- FIXED RTF encoding problems with "\" char used in exportation to Word format.
- FIXED When found a dupe rom and must be stored in same ZIP file.
- FIXED Problems with downloadfile function inside threads.
- FIXED Problems extracting DATs from mame based EXE. 
- FIXED Problems displaying menus information on asian Windows versions. Thanks to xlmldh.
- FIXED Updating Offlinelist profiles using the Offlinelist updater of Scanner option.
- FIXED Transparences and displaying images of buttons in Windows XP. Thanks to xlmldh.
- FIXED Problems launching emulators with unicode params.Thanks to xlmldh.
- FIXED WindowsXP and Vista commandline encoding problems. Thanks to xlmldh.
- FIXED Problems with current working directory of emulators when launching emulators. Thanks to xlmldh.
- FIXED Encoding DATs detection for imporation. Thanks to xlmldh.
- FIXED Problems displaying Files/Folders dialogs. Thanks to Agus.
- FIXED Wrong displaying information and a unnecessary delay when user click a column at loaded profile list.
- IMPROVED Community form interaction with the other forms.
- IMPROVED Rebuild speed for profiles with only CHDs.
- IMPROVED Scan/Rebuild when profile has baddumps.
- REDUCED Small freezing time when finishing DATs importation.
- CHANGED Time counter non based on OS datetime. Prevents problems if user changes datetime when Romulus is running.
- CHANGED Rollback ESCAPE button to close a Window with keydown event again.
- UPDATED CHDMan binaries to 0.193 version.
- UPDATED RAR binaries to 5.50 version.
- REMOVED in Settings - Advanced "Check for baddumps and duplicates", now always is checked and created by user decision.
- REMOVED hottrack painting in profiles and scan lists to decrease CPU render usage.

0.036

- FIXED Problems managing Zip files in some cases.
- FIXED Saving configuration - Advanced for use RAR5 mode compression and search for duplicates and baddumps. Thanks to mtdew000000
- CHANGED Close forms pressing ESCAPE key from keydown event to keyup.
- UPDATED 7zip binaries to 16.04 version

0.035

- IMPROVED Hashing speed for uncompressed files using a new cache method. Thanks to Agus.
- ADDED Speed hacks when scanning profiles with compressed files but must be scanned as uncompressed.
- ADDED Support for hashlists *.hsi dat files.
- ADDED Sorted Scan/Rebuild files in a non NTFS Drives.
- ADDED For profiles and scanning lists a column sorted color with direction arrow, this visual can be removed from settings.
- ADDED Support for XML new param <MAME> able to import last Connie Arcade and MAME dats. Thanks to Agus.
- CHANGED Zip and uncompressed files in write mode access only when needed. Thanks to ErAzOr.
- CHANGED Process screen with a indeterminated animation.
- UPDATED Torrentzip to 0.8 version. Now no more problems with >4Gb ZIP files. Thanks to Serafín Villar.
- UPDATED CHDMAN to 0.185 version.
- FIXED Problems scanning different file types like ROMs, SAMPLES, CHDs in same profile. Thanks to Agus.
- FIXED Problems sorting list at found duplicates Profiles window. 
- FIXED Minor bugs.


0.034

- FIXED Reading 7z files information compressed by t7z and probably other compressors. Thanks to 0. 
- FIXED XML Importation when has no description for information for sets.
- IMPROVED XML Importation compatibility. Now SMW-Hacks dats can be imported.
- IMPROVED Importation compatibility for DATs without "NAME" OR "DESCRIPTION" information like snesmusic.org old DATs.

0.033

- ADDED In settings an option to apply registry fix to detect mapped drives at elevated applications as Romulus.
- ADDED To XML dats new param at "<HEADER>".The new "<HEADERFILE>" node contains filename of needed header for the profile. This param don´t take effect in other rom mamangers.
- ADDED Saving current header xml file when creating XML dats from Database and fixdats.
- FIXED Problems detecting inside Zip files with especial attributes.
- FIXED Problems with inverted CRCs and correct CRCs in same profile. Rebuilding correct CRC when inverted CRC exists in same place.
- FIXED Detecting ROMs scan or rebuild hidden files or folders. Thanks to Agus.
- FIXED Detecting folders inside compressed files when profile has single folders information. Thanks to Agus.
- FIXED Reading and creating baddumps when MD5 and/or SHA-1 checksums are filled with zeroes.
- FIXED Zero bytes creation baddumps when MD5 and/or SHA-1 checksums are filled with information.
- FIXED Problems displaying master games list end at Offlinelist profiles with filters.
- FIXED Open URLs in Richedits using OS default web browser when in settings is enabled the option to do it.
- FIXED Visuals non rectangle hints on Windows 8 and laters.
- FIXED Taskbar preview size problems for Windows 7 and laters.
- CHANGED Importation security code to prevent files information with final backslash when really has checksums converting it to files and not folders. Thanks to Agus.

0.032

- ADDED From profiles list popup menu an option to create XML Dats of selected profiles.
- ADDED To report option exportation to CSV format. Thanks to Special-T.
- ADDED Some rebuilding files optimizations.
- FIXED Ignored setting compression level option from scanner window and not always using the general defauls settings. Thanks to Executer.
- FIXED Problem in generator option creating checksums when compressed file has folders and MD5 and/or SHA1 is activated.
- FIXED Freezing when using extract option from scanner in a uncompressed files method and is saving in a different drive from files source.
- FIXED Wrong Profile type displaying when an old dat is updated and new one has different type.
- FIXED Problems detecting updated profiles at Updater option in Trurip group.
- CHANGED Fixdat creation no asks for fixdat filename in batch mode. Romulus automatic name it.
- REMOVED try to open as compressed file when rebuild if file has no compression extension like .zip .rar .7z .001. This will increases a lot rebuilding speed in no compressed files.

0.031

- ADDED More flexible reports with listing columns selection and/or remove columns header text. Elfish request.
- ADDED Support for "romTitle" param at Offlinelist DATs as default filename mask or possibility to set mask as Romulus settings default. Thanks to Johnny gin gasper
- ADDED Support for Unicode filename masks in Offlinelist profiles.
- REMOVED Limit of obligated filename masks of "%n" and "%u" for Offlinelist profiles.
- REMOVED From DAT Groups "Pocketheaven". With some years without updates finally the homepage seems dead.
- IMPROVED Detection of updates in Updater option.
- UPDATED CHDMAN to 0.175 version.
- UPDATED RAR to 3.51 version.
- FIXED Crash problem when Offlinelist filename mask changed from properties option and result filename is empty.
- FIXED Duplicated filename problem when filename mask for Offlinelist profiles changed using properties option.
- FIXED BROKEN Non ascii path problem when creating or opening databases.
- FIXED Rare problem extracting big zip files caused by a Deflate64 method error.
- FIXED Directory maker problem when user try to add ROMpath manually.
- FIXED Launch emulators option removing last path slash to make more compatible with them.
- FIXED Remove cache file when delete a profile in a unicode Romulus path.
- FIXED Clear cache downloads procedure problem causing sometimes freezing when trying to download files or using Updater option.
- FIXED Freeze time when creating a fixdat.
- FIXED Some visual problems with magnified fonts. But use this Windows option is not recommended by me.
- FIXED Updater option profiles collision between Trurip and Tosec.
- FIXED Minor bugs.

0.030

- ADDED Option in Settings - Advanced to enable RAR5 format compression for new created RAR files. This option is dissabled by default. Thanks to James O'Grady
- ADDED Cache save on uncompressed files on rebuild."No need to scan again to save cache"
- ADDED Euskera/Basque language by Agus and Mikel and Laura.
- ADDED Euskera/Basque OS language detection at startup Romulus first time and set it as default.
- ADDED to Updater option "Rawdump".A new dumpers group with normal options like detect new, updated or outdated profiles.
- OPTIMIZATION Loading profiles gain up to 15% of speed.
- OPTIMIZATION Updater search profiles function. Now is up to x3 more fast.
- FIXED Offlinelist sorting by clicked column when filters are enabled.
- FIXED Broken loaded profile search by fields option.
- FIXED Random memory problem that cause wrong center Forms when showing.
- FIXED Report saving report information using Scanner - report button.
- FIXED Cache deletion when user add new files to rebuild and set skip scan when done.
- FIXED Cache lost previous results when new scan/rebuild is stopped by user.
- FIXED Delay when trying to launch an open/save file dialog and some rare times a complete freeze.
- FIXED Problem hide to tray when user tryed last time to hide application when a file dialog was displaying.
- FIXED Delete file error when rebuilding Zip files but file is handled as a single one.
- FIXED Error when a destination ROM is trimmed and a rebuilded one has correct size and destination file is compress in Zip with only one file inside.
- FIXED Invisible scan window when minimized application and log window is visible.
- FIXED Quick show and hide log window when finish a batch process.
- FIXED Flicker effect for progressbar percent displaying. 
- FIXED Community Form stayontop params. Now always is upper of Romulus but not other apps.
- FIXED Wrong display in profiles columns list. Column path information when drag'n drop a profile to other left side treepath and is displaying All profiles at same time.
- FIXED Manual extraction in loaded profile list when multiselect.
- FIXED Send to generator problem when source profile has only one set.
- FIXED More colors update problems when user changes system colors and themes when Romulus is running.
- FIXED Minor bugs.

0.029

- FINALLY Found the way to enable drag'n drop files to Romulus without dissable UAC (User Account Control) and the option to dissable UAC was removed.
- ADDED Support for import DAT from MAME based EXE with versions >=0.162 with -listxml or -listsoftware selection option.
- ADDED Import DAT MAME based EXE for MESS option to get softwarelists or bioses.
- ADDED Cached hashlist when scan. This will increase speed next time you scan including when profile is updated. Thanks to Kludge for the idea.
- ADDED Special code to increase compatibility with WINE for MAC and Linux.
- ADDED Italian language by Caboteta & Squalo.
- ADDED Italian OS detection language at Romulus first run and automatic setup.
- ADDED Korean language by Minsoo Jang.
- ADDED Korean OS detection language at Romulus first run and automatic setup.
- FIXED Displaying master relationship when Clone Set has only one ROM. This not affects to scan only displaying information bug.
- FIXED Importation wrong renaming duplicate Sets or ROMs.
- FIXED Rebuilding files detection with MD5 option enabled or when MD5 is automatic forzed because exists empty CRCs.
- FIXED Delete files inside Zip archives when it contains more than one file.
- FIXED Problems with Settings - Prevent sleep and poweroff. Now is more secure. No more shutdowns for Windows Updates when is scanning or fixing ROMs.
- FIXED RARE calculation bug when center windows on screen.
- FIXED "Insert next disk" message while trying to check if a file is Zip in some cases.
- FIXED Visual bugs and wrong themed objects when user changes from non themed to themed OS without restart Romulus.
- FIXED Non themed progressbar color compatibility.
- FIXED Non NTFS warning when drives are formated in ExFAT that supports more than 4Gb too.
- FIXED Log position problems when run scan/rebuild in batch mode.
- FIXED English translation corrections by Kludge.
- FIXED Portuguese translation corrections by Caboteta.
- IMPROVED CRC32 calculation speed.
- UPDATED CHDMAN to 0.162 version.

0.028

- ADDED Possibility to stop process when Builder or Scan/Rebuild option is used when searching files.
- ADDED Detection of hyperlinks at Richedit component. Not very usefull at moment but will be interesting in future.
- ADDED Automatic checking of file before rebuild if is compressed or not when has a wrong compression extension.
- ADDED Manifest GUID Declaration for Windows 10 Compatibility.
- ADDED Error.log when Romulus has an internal exception.
- ADDED Portuguese translation by Caboteta & Silius.
- ADDED Portuguese OS Detection at first run and set Portuguese as default language.
- CHANGED Paused taskbar status when a process is running and a question message is displayed.
- OPTIMIZATION Loading profiles to display. New algorith is up to 150% more fast.
- OPTIMIZATION Scanning files up to 10% more fast using different speed hacks.
- OPTIMIZATION Extracting files to use it when compressed file has a big number of files inside.
- OPTIMIZATION Rebuilding method finding coincidences and adding files to compressed files now is up to 500% more fast.
- OPTIMIZATION Managing of Zip files now is fully embedded without need to external files to compress and uncompress. Btw is more fast.
- OPTIMIZATION Builder option checking and unchecking big lists now is very fast.
- OPTIMIZATION Deleting files inside compressed files more fast too.
- OPTIMIZATION Importation DATs new hacks. Up to 10% more fast.
- OPTIMIZATION Reading and displaying history when user types on URL text bar.
- OPTIMIZATION Send to construtor option speed from an existing profile up to 500%.
- IMPROVED detection of internet protocols at Integrated Webbrowser when middle mouse button is pressed under a link.(ftp:,news:,mailto...)
- UPDATED CHDMAN to 0.160 version,
- FIXED Importation problem for Offlinelist DATs without ROM sizes information. Thanks to Silius.
- FIXED Detection of Zip multivolume files flag.
- FIXED Deletion of non needed files when compressed archive has more than one to file for delete and Header XML is enabled.
- FIXED Creating baddumps and duplicates when files contains Unicode characters.
- FIXED Problems displaying progressbar percentage indicator and statistics values when system decimal separator is different of a dot.
- FIXED Release of romspath that locks an external drive to extract with security.
- FIXED Some visuals when user forze to dissable vistual themes using compatibility properties options.
- FIXED minor bugs.

0.027

- ADDED Percentage indicator to progressbars.
- CHANGED Importation automatic overwrite for same name profiles. If more than one profile exists with same name, will ask again.
- FIXED Windows XP compatibility. Now can run on XP again :)
- FIXED Windows 8 Hint styles again.
- FIXED Importation CHD filenames duplicated file extension.
- FIXED Directory maker wrong counter displaying.
- FIXED Error reading DATs set as readonly.
- FIXED XML Headers load when offsets has HEX format.
- FIXED some problems rebuilding files already existing in Romspath with XML Headers activated causing a read error problem.
- FIXED MS-DOS command line unicode bug when is used a not TrueType font. Thanks to xTMODx to discover this bug.
- FIXED Detection of inverted CRCs when Headers are enabled.
- FIXED Inverted CRCs when scanning in no compression option.
- FIXED Save log option. Bug report by xTMODx
- FIXED Search in google option complex query encoding
- IMPROVED Rebuild files with XML Headers activated. Now duplicate and unneeded files are removed.
- IMPROVED Speed of generation MS-DOS Commands.
- IMPROVED Detection of desktop available region without taskbar to set position of forms.
- IMPROVED Speed of application launch.
- UPDATED CHDMAN to 0.158 version.
- FIXED minor bugs.

0.026

- ADDED to Portable Executable header flag support up to 4Gb of RAM Usage instead of 2Gb as default. 
- ADDED Decimals to Statistics completion percent status.
- ADDED Windows 8 correct hint styles.
- FIXED Importation duplicates roms and sets names detection.
- FIXED Importation problem detection clones when no merged files exists.
- FIXED Importation problem with last Softlists DATs where in some cases displays duplicated Set names.
- FIXED Importation. Add .chd extension if not exists in CHD filename.
- FIXED Importation some mixing filenames in sets at some last MESS CHD Softlists DATs 
- FIXED Wrong displaying scan results introduced in 0.024 version when fixing files in some special cases.
- FIXED Creating duplicates ROMs at end of scan when profile contains baddumps or records without CRC information.
- FIXED Creating duplicates with compressed unicode filenames.
- FIXED Problems locating correct file to jump to directory using Scanner sets list popupmenu.
- FIXED "AGAIN" Flashing and lost focus problem when scan/rebuild with Romulus hidden in tray.
- FIXED Updater option random bug when trying to download updates list and never finish a loop.
- FIXED Updater random no display profiles problem.
- FIXED Fixdat creation using Scanner section button when main profiles list is empty.
- FIXED Savedialog autohidden folders list when displaying.
- FIXED Wrong icon display in detail set list of Scanner of folder icon.
- FIXED Updater displaying information random lost information.
- FIXED Some recovery and lost Community window focus events.
- IMPROVED Download function. Now connects more fast. For example getting Offlinelist images.
- IMPROVED Importation indexation for new imported DATs. Now for rebuild process is up to 50% more fast.
- IMPROVED Importation detection of duplicate filenames and checksums. If filename in a set is same now checksum is checked if same rom is ignored if different renamed.
- IMPROVED Speed autocomplete Urls when typed at Webbrowser navigation Edit.
- IMPROVED Speed displaying Scanner main tab when moving inside main Form tabs.
- IMPROVED Integrated webbrowser memory usage.
- UPDATED Integrated Web browser with default user agent as "Mozilla/5.0 (Windows NT X.Y; Trident/7.0; rv:11.0) like Gecko" that increases compatibility with some Urls.
- UPDATED Torrentip to 0.9.2 version fixing some problems found by MrTikki. Thanks.
- FIXED minor bugs.

0.025

- ADDED Importation check for correct checksum sizes.If is wrong then is saved as empty.
- IMPROVED Scan speed hacks. Now sets with thousand and thousand of ROMs runs scan fast and general performance too.
- IMPROVED Rebuilding files with some speed hacks.
- IMPROVED importation speed up to 50%
- IMPROVED Decreased database size by imported profile up to 20%
- IMPROVED Recount roms/sets function speed up to 200%
- IMPROVED speed of fixdat creation. 
- FIXED Flashing and lost focus problem when scan/rebuild with Romulus hidden in tray.
- FIXED Importation Reading first ROM NAME description with some XML created using DIR2DAT.
- FIXED custom temporal directory in Settings directories option. Now can be set and remember it. Thanks to Executer.
- FIXED Torrent7z option, now works fine. Thanks to MrTikki
- FIXED Go to file option from popupmenu at Scanner master list.
- FIXED Move form effect when batch scan/rebuild opening window.
- FIXED some problems displaying forms on a multimonitor systems.
- FIXED minor bugs.

0.024

- FIXED 7z file validation problem. Causing a read file error in some cases.
- FIXED Rebuilding files with CRC FFFFFFFF, other hashes are forced and checked. Bug found at UnRenamed ISOs - PC Compatibles [ISO] [MSDN] Dat.
- FIXED Importation XML files with symbol "<!--" to exclude inside content.
- FIXED Error when making report using Scanner option in TXT format.
- FIXED Displaying problems with modified Windows settings fonts. Like 125 %.
- FIXED XML importation conversion chars based in numbers using this param. &amp;#number;
- FIXED Writing in disk very random problem caused by Windows creating a file read error when scan/rebuild files.
- FIXED Send to requests list problems for Community option using Scanner menus.
- FIXED In Generator processing checksums with multivolume compressed files and forzed to get info inside compressed files.
- FIXED Correct displaying windows on extended desktops.
- FIXED Restore and bring to from Romulus when is trying to run a Romulus second instance.
- ADDED Screensnap "magnetic desktop borders" to Romulus windows.
- REMOVED "No disk in drive" Windows error when a Drive is not ready. 
- UPDATED CHDMAN to 0.153 version.

0.023

- ADDED Special recoding optimization for lists. Now scrolling and displaying in real time is up to x10 more fast.
- ADDED Incremental search in lists. Automatic move focus to the text starting with key pressed. Mareo request.
- ADDED to Generator Treelist mode display with full expand and full collapse option at popup menu.
- ADDED Experimental RAM memory manager to decrease general RAM usage.
- ADDED Speed hack when displaying scanner window. When a profile has thousand and thousand of roms in other Romulus versions can take some seconds to open it.
- ADDED Stop and refresh options at integrated webbrowser popup menu. Maero request.
- ADDED Japanese language. Thanks to Xiao
- ADDED Autodetection of Japanese language at startup the first use of Romulus and set it as default.
- ADDED Support for Offlinelist DATs with Unicode information.
- CHANGED Offlinelist profiles updated automatic not show profile info and not ask to continue now.
- CHANGED Default font from Tahoma to Segoe UI. Seems more accurate to display all languages.If this font don't exists in system will be added automatic.
- CHANGED Default directories for resources and extract files as X:\TMP\RES and X:\TMP\EXT0
- FIXED Displaying property unicode texts in Windows versions with different set region of English. Thanks to Xiao
- FIXED Option for drag n drop files into Romulus for Windows Vista and later users using Settings option.Thanks to Xiao
- FIXED Save UTF8 textfiles in Oriental OS Systems where codepage is different. This affects to reports (HTML and TXT), XML exportation and saving log. Thanks to Xiao
- FIXED Max text length limit of 256 chars for log.
- FIXED Memory problem found importing last MAME DATs.
- FIXED Unicode displaying information for Update DAT window.
- FIXED Unicode displaying information for Directory maker window.
- FIXED Importation error for Clrmame DATs with no description for Sets found on The Wizard of DATz. Bug reported by Maero.
- FIXED Importation error when an Offlinelist or Romcenter DAT is imported or updated and you try to import other DATs later.
- FIXED Importation from MAME Based EXE fails in some cases caused by a wrong initialization of a variable. Bug reported by Maero.
- FIXED Importation XML files where separator brackets are between to lines. Thanks to Xiao
- FIXED Importation Offlinelist DATs where Releasenumber field not exists. Thanks to Xiao
- FIXED Scanner window folder list focus when batch scan/rebuild in some special cases.
- FIXED taskbar indeterminate progressbar not ends when batch scan with popupmenu of profiles section.
- FIXED Special XML conversions like &amp; when exports. Bug reported by Maero.
- FIXED Problem overwriting files like when generate your own DAT.
- FIXED Comboboxes dropdown max visible list count is set to 10 at default and works with themes.
- FIXED Broken Offlinelist filters.
- FIXED Displaying Scanner option smile faces sometimes when other tabs are closed.
- FIXED Displaying backslash symbol like in pathes in asian Windows versions.
- FIXED Correct displaying of backup path from right menu folders button at scanner option.
- FIXED Importation CHDs and SAMPLEs without extension in DAT, extension not added if filename has points.
- FIXED random problem closing process window and application infinite loop.
- FIXED Settings section left list focus at show settings.
- FIXED Transparency bug at PNG files loaded by Offlinelist profiles.
- FIXED Flashing taskbar sometimes non stops.
- FIXED Recovery focus control when other forms open and close.
- FIXED Some components not correct converted to UNC to display correctly.
- FIXED Some memory leaks found that can cause application crash.
- UPDATED CHDMAN to 0.152 version.

0.022

- FIXED Folders list of scanner window lost focus and problems to set the folder to scan. 

0.021

- ADDED FULL UNICODE support to Romulus. All functions and procedures are recoded to support UNC characters.
- ADDED Windows version check. Now Romulus is not longer compatible with Windows versions without UNC support. Like Win95, Wind98, etc.
- ADDED Delete from compressed files check for file is set as read only and automatic set attributtes to read/write to able to delete files inside compressed.
- ADDED Support for import DATs with diferente codepages (UNC, UTF-8, ANSI). Thanks to MrTikki for testing.
- ADDED Possibility for batch DATs importation with existing profiles, automatic overwrite, ignore or cancel for all batch. Thanks to MrTikki for the great idea.
- ADDED Security check. New database can not created or opened a new one if Community module is connected.
- ADDED to Community. Peers accumulative check to increase speed of connections.
- ADDED to Community. Port mapping check at start of server and sends a message if port is closed. 
- ADDED to Community automatic file transfers. "Experimental at moment"
- IMPROVED XML decoder. Now is 5% more fast.
- IMPROVED OEM and UNC inside zip filenames again. Now detection of filenames compressed with different methods are detected.
- IMPROVED Low level events hook.
- FIXED Flashing taskbar now is not forzed to be displayed as the top system window.
- FIXED extraction of some Zip files caused by unknow compression method.
- FIXED problem that can not able to add new records to requests lists.
- FIXED Problem setting images path for Offlinelist DATs using Updater when profile is not loaded.
- FIXED Wrong display of Scanner profile when a Offlinelist DAT is loaded and updated with Updater option and is not the current profile tab displayied.
- FIXED Invisible progress window when main form is set as stayontop.
- FIXED Hungarian translation to UNC support. Thanks to Thallyrion.
- CHANGED Offlinelist profiles automatic update never will ask for select overwrite old profile again.
- CHANGED to Community Chat and Events log from Font Bold style to normal style.
- REMOVED temporally Richedit hyperlink feature because detected some problems.
- REMOVED Richedit left mouse click + mouse wheel change font size effect.
- REMOVED Popupmenus shortcuts.
- REMOVED Community module activation at moment because has a lot of bugs.
- UPDATED RAR engine to 5.00beta8.

0.020

- ADDED Automatic Windows firewall Ports exception when user uses Community module.
- ADDED Support to reading RAR files in 5.xx version format. No creating RAR 5.xx format at moment because is in early versions.
- ADDED Option for rebuild decisions window to skip scanning ROMs after rebuild files. Thanks for people to email me the idea.
- ADDED URL click feature at Richedit component.
- ADDED to Settings - Advanced options to set as default to check MD5,SHA1 make TorrentZip or Torrent7zip for new added DATs.
- ADDED Send missing to request list option for Community at Scanner tab, loaded profile tab and master and detail profile lists popupmenu.
- ADDED Button to taskbar for Community module. This can be used like independent application, close, minimize, maximize. You can hide main Romulus window and Community window still visible.
- ADDED Small speed hack for rebuilding when profile contains a lot of duplicated checksums and trying a various files with this checksum.
- ADDED For Webbrowser a default zoom button to turn back to default Webbrowser zoom percent and hooked zoom events for example when user makes a zoom on a touch screen.
- ADDED to Scanner at directories right popupmenu possibility to open at explorer current backup folder
- ADDED Hungarian translation by Thallyrion
- ADDED Autodetection of OS Hungarian language and automatic setting up for first run users.
- CHANGED Charset at initialization to LOCALE_USER_DEFAULT must fix problems with some characters for some users.
- CHANGED Dissabled default keyboard shortcuts at integrated Webbrowser.
- CHANGED Importation Romname without filename now is ignored.
- UPDATED Unrar.dll to 5.20 version.
- UPDATED Database Engine to 7.20 version.
- FIXED Random crash in Updater section when trying to get new updates.
- FIXED Some threads termination making Romulus more stable.
- FIXED importation for Clrmamepro old format clausule "emulator" as valid header. Bug found at Raine v0.62.3 DAT. Thanks to MrTikki for bug found.
- FIXED Table file decompression error that causes an application crash rare randomly times.
- FIXED Bug deleting of profiles when selecting entire folder with profiles inside.
- FIXED Integrated Webbrowser error page when loading a URL takes an error when fails loading of some components.
- FIXED Integrated Webbrowser loading page message and icon when really the page load is done in some cases.
- FIXED Integrated Webbrowser zoom option. Now works correctly.
- FIXED Integrated Webbrowser opens new tab if necessary if current one is about:blank.
- FIXED Extraction wrong files on Scanner when Offlinelist profile is displaying with filters activated.
- FIXED Send to request wrong on Scanner when Offlinelist profile is displaying with filters activated.
- FIXED Search wrong on Scanner when Offlinelist profile is displaying with filters activated.
- FIXED Automaximize on Log and Server window when user activate it.
- FIXED Generic popupmenu for Cut,Copy,Paste,etc not displayed status property in some cases.
- FIXED Community bug that not able to connect to other users.
- FIXED Some German translation strings. Thanks to Thallyrion.
- FIXED Accumulative Windows firewall exception entry.
- FIXED Not hidding to tray Offlinelist filters window when is active.
- FIXED Locked Community window when Offlinelist filters window is active.
- FIXED save bool at Scanner - Extraction files - create folder option on INI file.
- FIXED More and more minor bugs.

0.019

- FIRST Release of Community module. At moment you can add to request list and chat with other connected users. 
- ADDED Sharing option by scanner - profiles tab popupmenu.
- ADDED Filters for Offlinelist profiles at Scanner tab.
- ADDED Taskbar special effect feature when mouse is over Romulus bar for Windows 7 and later users.
- ADDED Automatic exception to integrated Windows Firewall for Windows XP and later users.
- ADDED to Updater groups Trurip Normal and Super DATs collection.
- CHANGED Automatic detection for empty CRC32 hashes when rebuild files, then MD5 and SHA1 are checked.
- CHANGED jump to directory option added to scanner - profiles tabs.
- CHANGED jump to directory option now sets the possition in list of selected profile.
- CHANGED full thread of loading profiles, no more slowdowns loading big profiles.
- CHANGED Right click menus has 15 seconds of timeout.
- IMPROVED detection of profiles at Updater option based on more profile information like author or email.
- IMPROVED security code at end of application that kill it if is running a hard process.
- IMPROVED Speedup hacks when importing, reading or displaying profiles.
- IMPROVED Threads methods are more stable adding a security code.
- FIXED Generator creating DAT from folder when process is stopped by user when is searching files.
- FIXED Recovery of Log window real position and size when user close it when maximized and opens it again.
- FIXED Lost application icon when using report option.
- FIXED Lost on mouse under button effect when doing some hard processes.
- FIXED scanner option tabs and web navigators tabs, right mouse button click popupmenu event from mousedown to mouseup.
- FIXED a crash problem when user try to hide to tray application in some cases.
- FIXED not hide Log window when is necessary.
- FIXED If user sets scan MD5 or SHA1 and this not exists in current profile then this checksums are ignored.
- FIXED minor bugs.
- REMOVED unnecessary and old Windows default events like right click on windows bars or right click on scrollbars of lists.

0.018

- CHANGED Now expand/collation of tree nodes in Profiles is saved and restored as configuration.
- FIXED a problem creating default database first time not displaying the default message and freezing GUI. Klaus Gessner bug report.
- FIXED When Romulus is minimized and a control is focused only shows the current form and not others like main form.
- FIXED correct accepted rebuild files from scanner tab using drag n drop files at bottom list.
- FIXED extraction of zip files with special chars like ?????created with old versions of winzip.
- FIXED Non transparent trayicon.

0.017

- ADDED possibility to create fixdat using the popupmenu of main profiles list.
- ADDED Windows NT based OS users check at start and relaunch with administrator privileges. Seems in some computers is needed to elevate privileges to full work with Romulus, read registry, access or write in some system paths, etc. And in some cases access to integrated web navigator.
- ADDED Status colors to reports for HTML and DOC format.
- ADDED Code to optimize the release of RAM memory when Romulus closes.
- ADDED more and more security code to prevent exceptions
- ADDED UPX compression. It reduces EXE file size and can prevent memory problems.
- ADDED Table corruption check to prevent loading profiles errors.
- ADDED to log window a new button to enable or dissable autoresize of columns. Mr Ravik request.
- ADDED possibility to stop the importation process when is reading a unique compressed file but with more than one DAT inside.
- IMPROvED download files function. Now can connect more fast and download more fast using multiplart downloading method.
- IMPROVED speed when reseting counter at properties of profile.
- IMPROVED speed when rebuilding big number of files to same compressed file.
- IMPROVED speed when rebuilding inside compressed files when destination files contains hundreds of ROMs.
- IMPROVED detection of correct filenames inside Zip files when are UTF8.
- IMPROVED saving and displaying Web browser URLs lists.
- IMPROVED speed after inside compressed files deletion when compressed file has a big number of files inside.
- IMPROVED Flashing taskbar when a new window is open or closed and Romulus is not the current active application.
- IMPROVED Romulus minimize hook. Now Romulus can be minimized when modal windows are present.
- IMPROVED Integrated navigator compatibility forzing user agent as Mozilla/5.0
- IMPROVED Detection of ROMs. MD5 checksum as D41D8CD98F00B204E9800998ECF8427E is detected as bad dump and SHA-1 checksum DA39A3EE5E6B4B0D3255BFEF95601890AFD80709 too.
- IMPROVED Code to increase compatibility with Windows 8, don´t worry are only some details.
- CHANGED friendfix name is changed to fixdat, is the most common name of this kind of dat file.
- CHANGED Log window when is visible will continue enabled when other windows are showing.
- CHANGED When a extraction or reading compressed file fails. Now in log is displayed the inside compressed file failed filename.
- CHANGED registered last silent exception at error.log file.
- CHANGED columns of lists can not be resized less than 50pix.
- CHANGED download files function is set as trycount from 1 to 3.
- UPDATED CHDMAN 32 and 64 Bits versions to 0.147u3.
- STARTING Community module. At moment is dissabled it needs more coding time, but i wish will be available soon ;)
- FIXED found problem with Unrenamed IBM ISO Dat when CRC is FFFFFFFF. Now check other checksums if exists and remove wrong creation of Bad dump.
- FIXED locked application when trying to display a new window and main application is set as stay on top.
- FIXED inside zip counter bug that decrease speed of deleting inside files when zip content has only 1 file.
- FIXED Updater conflict between No-intro and Redump.org DATs when description name of DAT is same. Now author field is checked to know the correct DAT group.
- FIXED Updater Yori Yoshizuki DATs. His latest DATs has the same version number and Updater status information can be wrong. Now in his DATs are checked by date field too and correct version detection is done.
- FIXED Reading RAR files attributes that can cause a problem detecting ROMs.
- FIXED multiple file deletions in same operation of RAR files.
- FIXED Problems with modal windows when Romulus is hidden on trayicon.
- FIXED recovering stay on top status when other windows are closed and the main window is activated.
- FIXED Windows Vista users option activate drag'n drop from settings, now must work in all cases.
- FIXED problem sorting loaded profile by columns size and files count.
- FIXED sometimes counting sets/roms after import dats at complex profiles like MAME, after scans the counting was correct.
- FIXED creating fixdats when try to create more than one.
- FIXED fixdat correct sorting when profile has merged files.
- FIXED correct management of clausule SAMPLEOF in XML and old Clrmamepro DAT.
- FIXED correct merging of bioses when file mode is different than split/merged.
- FIXED importation status messages when a lot of profiles are importing quickly.
- FIXED unable to update offlinelist dat using main Updater option, else was possible using Scanner - updater option after load profile.
- FIXED freeze time when update profile importation process. 
- FIXED freeze time when large files are uncompressed and moved using in scanner list popupmenu option.
- FIXED recursive access to get files list of protected folders like some inside Windows folder.
- FIXED some loses focus of objects when navigate from main button menus.
- FIXED visuals on Windows 8 when form close button is dissabled and enabled then is showed as dissabled but works.
- FIXED EAccessViolation exception that some rare cases makes infinite loop when is running a thread process.
- FIXED Cannot make a visible window modal exception.
- FIXED more and more minor bugs found.


0.016

- ADDED indeterminated progressbar on taskbar when a process is running. An inteligent way to know if Romulus is running a loop process without see the main window.
- ADDED scanner detail set list search in Google by CRC, MD5 and SHA-1.
- ADDED detection of number of CPU cores and dissable multicpu options if not multicore CPU exists in system.
- ADDED Multithread compression for RAR files forzing if available to compress and get extra compression speed.
- ADDED Jump to profile directory option at profiles list popup menu, this can be a good option to locate the current directory of the selected profile when showing all profiles at same time.
- ADDED Flashing taskbar when progress window ends and Romulus is not on top.
- ADDED Flashing taskbar for windows - New dat found and Dat update.
- UPDATED Database engine to last version 7.04, as result database seems more strong and best performance.
- UPDATED XP manifest resource file to a more complete version according to the last Windows OS.
- UPDATED CHDman to last version 0.146u5.
- UPDATED Unrar.dll to last version 4.20.100.526
- UPDATED RAR version to 4.20
- CHANGED Romulus database is updated with biggest params to support thousand of profiles without lose speed or have memory problems. When Romulus starts will check for new params, if are not present database will be updated, this can take time, please wait.
- CHANGED Webbrowser useragent changed to Mozilla/5.0 and download socket too, will increase compatibility with some urls.
- CHANGED Database flushing buffers when database hard operations ends, this will improbe security.
- CHANGED Not accepted inverted crc and wrong size for same rom as valid when scans or rebuilds.
- CHANGED Headers won't modify ROMs now, only will be checked.
- CHANGED profiles with headers enabled can be rebuilded but won't be modifed and only will checked using header rules.
- IMPROVED Hacks to increase speed of loading profiles, now profiles can be displayied 10%-400% more fast.
- IMPROVED destroying windows mode, this will increase the stability and prevent memory leaks.
- IMPROVED Generator reading files speed about 10%.
- IMPROVED Generator exportation speed about 20%.
- REMOVED the last UAC check when Romulus start, because some users reported problems with it.
- FIXED displaying Offlinelist wrong additional in list information like flags, langs, etc.
- FIXED Problems reading to display big profiles lists and finally showed as empty list.
- FIXED Generator reading files error when files to read are thousand and thousand.
- FIXED Deletion of files inside RAR archives when rebuild.
- FIXED manual extraction of compressed files by sets of incorrect folder.
- FIXED crazy flashing taskbar for Messages window.
- FIXED Edit popupmenu functions like cut, copy and paste at not main window.
- FIXED integrated webbrowser to read local files like html report exportations.
- FIXED rare bug destroying Querys, this will increase the stability of Romulus.
- FIXED detail scanner list displaying Edit information when different items are selected.
- FIXED content of scanner list when more than 1 profile is loaded and 1 of them is a importation update and is not the current selected at scanner tabs.
- FIXED some icon transparences problems.
- FIXED problem with color of some panels in some OS systems.
- FIXED minor general bugs.

0.015

- ADDED Trayicon to show/hide application, you can use it to hide when batch runs, scan, rebuild etc. Romulus icon will show a balloon message when important processes are done. Mr Ravik request.
- ADDED General settings possibility to remove Trayicon if user prefer not display it.
- ADDED UAC (User Control Access) checks to Romulus, special feature for Windows Vista users that can have problems with privileges.
- ADDED Column click sorting at profiles list, scanner list and emulators list. Mr Ravik request.
- ADDED to INI file the with of profiles list columns to restore it when Romulus is restarted. Mr Ravik request.
- ADDED recursive display folders at profiles. Just use popup menu in profiles tree and activate the option. Mr Ravik idea.
- ADDED from Folders settings an option to change the temporal directory. SpaceAgeHero request.
- ADDED Sleep/Power off prevention at general settings. Mr Ravik idea.
- ADDED Autocomplete for Webbrowser saving the typed urls at Urls.lst file, and placed the Edit component for a Combobox.
- ADDED Webbrowser a favorites option to add and go to your added favorites Urls, saved at Urls.lst file.
- ADDED Settings - advanced - forzed multicpu for compression in compressors that can do this.
- ADDED Settings - advanced - create solid archives for compression in compressors that can do this.
- ADDED Settings - advanced - possibity to dissable search for bad dump and duplicates at end of scan saving time.
- ADDED Settings - advanced - change timeout for offlinelist downloads, updates and images. 10 seconds as default.
- ADDED to log, batch information number.
- ADDED Windows Vista/7 hints visual styles.
- ADDED Scanner to fields search list "Clone of" field for all profiles except Offlinelist.
- ADDED Scanner to fields search list "Language, Publisher, Save type, Source and Comments" fields for Offlinelist profiles.
- ADDED NTFS HDD format check when start to scan/rebuild, log will show a warning if format drive is not NTFS, but will start to process anyway. Remember NTFS can handle files with more than 4Gb and FAT32 not.
- UPDATED CHDMAN to 0.146u1 needed to check some of last CHD files.
- CHANGED ported Timage to Timage32 component that is more accurate.
- CHANGED some routines of destroying webbrowser tabs increasing the speed.
- IMPROVED control of exceptions, now Romulus is more stable.
- FIXED a bug rebuilding files when MD5 and/or SHA1 checksums are forzed and this checksums are not available in profile making the file not match when really matches.
- FIXED German - Turkish language for Offlinelist that was displayed as Unknow.
- FIXED Lost dissapeared mouse cursor when types at Edit component.
- FIXED if extraction of compressed file fails the incomplete extracted file is removed.
- FIXED Exportation friendfix dat default filename now is not trimmed.
- FIXED Offlinelist filesizes with spaces found at AdvanScene PSP.
- FIXED tab counter at Webbrowser when the tab closing.
- FIXED rare random Out of resources bug that not displays sometimes a image and can crash application.
- FIXED Minor general bugs.

0.014

- ADDED Filter option button at Generator to make selections to export at Generator list. This is usefull for example to split a DAT making the selection of "(USA)" text save the DAT and invert selection to save a DAT with the rest of regions. 
- ADDED in Scanner menu at right hand buttons panel a new button to jump to current directories at Windows Explorer. 
- ADDED in Scanner at Sets list popup menu an option to jump in Windows Explorer to selected set.
- ADDED in Scanner at Sets list popup menu an option to extract to selected directory of desktop the selected set. 
- ADDED in Scanner at Sets list popup menu an option to make an Smart search in Google of selected set. 
- ADDED French language at Settings option. Thanks to Kaito Kito for translation.
- ADDED correct decoding for special chars at Google searches.
- ADDED Webbrowser middle mouse button hook to open clicked link in a new tab. 
- ADDED Silent control of exceptions. Now exceptions will not be showed. 
- CHANGED Compiler with a third party. Seems is more accurate and makes best use of memory. 
- CHANGED Romulus main window is restored when application is minimized and the processing panel used when load a dat, sending to generator, etc terminates. 
- CHANGED in Webbrowser when trying to open a link if only one tab exists and is about:blank then not open a new tab, opens at current one.
- CHANGED When enter to a Tedit control automatic is selectall.
- CHANGED at importation a control of extensions for Samples and CHD files if this not exists then will be added *.WAV and *.CHD. 
- CHANGED Removed the current community trading unused code for decrease the size of application. Maybe in future if is needed will be readded. 
- CHANGED added custom popup menu to Tedit controls. Copy, Cut, Paste and Selectall.
- CHANGED Webbrowser navigator url bar is set to green if is a secure connection url. 
- UPDATED CHDMAN to 0.145u5.
- UPDATED RAR to 4.11 version.
- UPDATED Unrarlib to 4.11 version.
- UPDATED Ziplib to 1.2.6 version. 
- UPDATED CHDMAN params to work with the last version of CHDMAN necessary to check the last CHDs files. 
- FIXED a bug that can not recover the last focussed control when changing of main menu tabs. 
- FIXED some cases RAR multivolume files with comments as not valid RAR files. 
- FIXED counting SETS and ROMS at end of Scan / Rebuild for large profiles. 
- FIXED random cases not showing modal Windows and application freezes. 
- FIXED at directory maker problems when no ROMs exists in profile and checks now for CHDs and SAMPLES.
- FIXED exportation to HTML and open it in Romulus Webbrowser if is set as default.
- FIXED Webbrowser font size selector, now is set with trackbar the size of font and not zoom that needs more CPU usage and can freezes the application.
- FIXED Webbrowser search for text not writing to HTML the highlight code, now makes search selecting the current text found and is need to push the next button for next match or prior button.
- FIXED Webbrowser problems destroying tabs that sometimes hangs and closes the application.
- FIXED Webbrowser problems showing properties option.
- FIXED Webbrowser memory leaks that can hangs or make application crashes. Now webbrowser is more stable.
- FIXED Webbrowser some problems getting favicon, now is more fast and works in secure webs (HTTPS).
- FIXED transparent default icon at tabs. 

0.013

- ADDED basic Web navigator to the first menu, user now can navigate to the wished URLs and Romulus links will be redirected to this navigator. To disable the redirection if user prefer his default OS navigator can do it in General - Settings menu.
- ADDED in Scanner/Rebuild configuration a default backup button, to return to the default backup path.
- ADDED Multicpu command to Zip and 7z compressions. This will increase the speed of rebuilding process for users with 2 and more CPU cores. Andrea Sassanelli suggestion. 
- ADDED Custom automatic decissions for Scan/Rebuild processes, if you wish to fix files now don't need to wait to find it. The modified decission will be saved for each profile, and batch runs will have a default decision that user can modify. Default decission for batch runs will be saved in Romulus.ini.
- ADDED Accepted inverted CRCs. This means in some rare and very old dats, a bad dump is expressed as inverted CRC. Romulus will not try to remove it as normal, only will advert of this in log.
- ADDED Custom icons for baddumps and duplicates creation in log and custom icons for baddumps displaying roms list.
- CHANGED Decissions information for profiles will be saved on database. The first run of this version Romulus will modify the database to store this new records and can take some seconds to start. 
- CHANGED Scanner option the close all tabs button is converted to a popup menu with more options to close tab profiles like close all complete profiles, close all incomplete profiles, close all not checked profiles, close all empty profiles and of course close all profiles. Lastagehero idea. 
- CHANGED Scanner and Navigator tabs size is set to 250pix and not automatic, if tab caption is more long than tab will be trimmed but user can see the full description by a hint putting mouse over the tab. 
- CHANGED Dat updater detection will be ignore the dat type of already existing profiles, only will compare the dat name. In this last weeks some dat groups updated his dats from clrmame format to xml format. 
- CHANGED Remove agresive use of GetifOSis64bits function used always when a command line run is done. Just checked at start of application and stored in a variable.
- CHANGED in Scan if a file don't have CRC information and MD5 and SHA1 verification is not checked. Automatic will try to to check MD5 if available else SHA1 if available, if not the file is considered bad dump and check is passed.
- CHANGED before compress a file now is checked if both files are as read only and this property is removed to fix possible future problems.
- CHANGED removed MD5 and SHA1 availability when scan/rebuild window is displayed to increase the speed of the load information. The MD5 and SHA1 availability is moved to the start of scan/rebuild process and if a checksum is not necessary and is marked then automatic will be dissabled. 
- UPDATED CHDMAN 32 and 64 bits to 0.145 version. 
- FIXED Creation of baddumps for CHDs.
- FIXED Detection of duplicated ROMs at end of scan only for Offlinelist dat type. 
- FIXED Exception in rare times when try to set Romspath using button in Scan/Rebuild window. Lastagehero bug report. 
- FIXED fixing read error files for only compressed files with more than 2Gig. 
- FIXED Finding an already existing dat to update when profile name has apostrophes. Bug is pressent at profiles tree list and can make exceptions when creating or editing folder names with apostrophes. 
- FIXED rare UTF8 conversion at importation that very rare times returns an empty string and not converted string, losing this ROM line information.
- FIXED reading file inside zip files with special chars like ?char that returns a wrong filename.This bug is not pressent reading RAR and 7z files. Lastagehero bug report.
- FIXED unnecessary CHD detection function when profile has not CHDs files. This decreased the rebuild speed.
- FIXED File in use detection if each file is set as read only. 
- FIXED Removed .chd extension when export to XML dat a CHD file information.
- FIXED unnecesary rebuild more than 1 time the same files when profile has more than 1 path to scan like (Roms, Samples CHDs). 
- FIXED Importation XML parser when the NAME param is not the next of ROM DISK or SAMPLE param, now can be unsorted.
- FIXED possibility to manipulate the application in the short time of drag'n drop some file inside for rebuild roms or add dats openning the doors for a bug. Now this possibility of bug is checked before drag n drop. 

0.012

- ADDED Detection of bad dumps at end of Scan / Rebuild and Romulus asks to add it. Bad dump is detected when no CRC, MD5 and SHA-1 information found for a ROM.
- ADDED Detection of duplicated ROMs at end of Scan / Rebuild and Romulus asks to add it.
- ADDED Support for Zip64 format. This is support for big Zip files with more than 4Gb.
- ADDED UTF8 file format for DAT files supported and import it without errors.
- ADDED to XML parser full conversions of special chars based in numeric or hex codes.
- ADDED Importation displaying information about imported sets count and currect process inside importation.
- ADDED Proper German translation made by SpaceAgeHero, the old one sucks.
- CHANGED Recoded all XML parser, fixing some possible errors and cleaning code.
- CHANGED Recoded Scaning process fixing some rare but possible errors.
- CHANGED Now a compressed file with no files inside is checked as a single ROM in Scan / Rebuild process. Sometimes a small file, compressors thinks is a compressed empty file. 
- CHANGED at Scan, CRC 00000000 or FFFFFFFF is considereded as a empty CRC information, included in baddumps creation process.
- CHANGED Compressed files with a password are skipped and not processed in Scan.
- CHANGED if checksum match in Scan but the filesize is different ROM is marked as valid but with a warning, in Rebuild file with wrong size will be marked as correct until a file with same checksum but correct filesize found. 
- CHANGED One more time little optimization for Zip files scanning with hundred of files inside.
- CHANGED Adding path editbox to browserfolder dialogs.
- CHANGED Forze rebuild when multidisk compressed files are placed in romspath. Multidisk files are not acepted in romspath, must be single compressed file.
- CHANGED buttons sizes width to 90pix to fits fine the next future translations including the new German.
- CHANGED in Generator when getting information of compressed files if file is multidisk is checked as a single not compressed file.
- CHANGED Accepted Merged param at importation to force merging filemode for different filenames between master and clone set.
- CHANGED Initialization progress bar when start to Scan.
- IMPROVED Indexation at importing that increases a little bit the speed of scan.
- IMPROVED Speed of importation when profile has clones.
- FIXED Importation in Clones relationship. If in Clone set a file exists in Master set automatic is merged.
- FIXED Importation before merging the checksum is checked and if not the same automatic the relation between master and clone is broken.
- FIXED Importation Bioses are removed from master and Clone sets and included in your own Bios set.
- FIXED Filesize reading for RAR files of more than 2Gb was wrong, now is correct. This affects to Generator, Scan and Rebuild make the process not works fine.
- FIXED importation filesizes larger than 4Gb now displays fine and not displays as 0 bytes. Reimport DAT to fix it.
- FIXED Getting big filesizes to compare to database obtaining a reading compressing file error.
- FIXED Broken relationship in Scan/Rebuild when Not merged filemode is set and profile has merge files or duplicates.
- FIXED Display list in Not Merged filemode when profile has merge files or duplicates.
- FIXED Roms counter in Not merged filemode when profile has merge files or duplicates.
- FIXED importation of CHD filenames in Clrmame pro dat files non in xml format.
- FIXED problems when Headers are active and CHDs exists in current profile.
- FIXED fixing file message that shows again and again included if user says yes to all when headers must be fixed. Thanks to SpaceAgeHero and Mr Ravic for bug report.
- FIXED Saving DATE field when new dat added and not updated for a old one. Thanks to Mr Ravic for bug report.
- FIXED folders detection at long path names at Scan.
- FIXED Bug in function removeconflictchars that is used to correct not valid filenames at importation. This bug is present in rare cases but can make errors on importation.
- FIXED Max log lines that displays wrong count.
- FIXED Change filemode in Properties using OK Button that causes the Main form can not be closed.
- FIXED minor general bugs.

0.011

- ADDED Stop button in processing window available in a lot of actions.
- ADDED Automatic romspath maker and configuration. This is available in popup menu in profiles list and using a base path Romulus can detect or create folders for romspath based in Profile name or Profile description. This is a very usefull option for manage a new or already created folders. TODO LIST DONE.
- ADDED Send to generator option available in Profiles list and Scanner tool buttons. This can send the selected profile to Generator to export to other format or select/unselect roms before export or for example split a profile. 
- ADDED popup menu for Scanner - loaded profiles tabs to send to first, send to last possition and delete tab.
- ADDED Automatic detection of OS Language and if is available in Romulus automatic setting up. This will be done the first Romulus run or when no INI file exists.
- ADDED possiblity to maximize / minimize when processing windows is making a process just making a click in taskbar.
- ADDED flashing window message in taskbar when Romulus is not the active application.
- ADDED Windows theme Vista and 7 for Treelist, Listview, Opendialog and Savedialog for all Romulus components.
- CHANGED Removed Listview dotted rectangle when a line is focussed like Windows Explorer. 
- CHANGED File extensions different to ZIP RAR or 7Z are checked as compressed and manage it if is necessary, else are managed as uncompressed roms.
- CHANGED Generator checkboxes are used from windows theme. For example in Windows XP and Windows 7 are diferent bitmaps for checkboxes and Romulus display your correct OS checkbox bitmap. 
- CHANGED All command line params are converted to OEM, this will fix problems with some special filenames when making some actions like compress, uncompress or run emulators.
- CHANGED Importation removed "." changed with empty at end of set names because a compressed file can have this filename "romname..zip" but a uncompressed mode a folder can not be "Setname." with point at final.
- CHANGED Importation removed ".\" changed with "\" at start of filename reason same as the other change. 
- UPDATED 7z binary to 9.22 version.
- IMPROVED speed hack for Scan compressed files with a lot of folders inside.
- IMPROVED speed in some general functions.
- IMPROVED speed for Log displaying lines.
- FIXED some problems applying headers when correct filename to rebuild is the same of header check.
- FIXED when header is activated for a profile was not closed correctly and is active for the next profiles without header selected.
- FIXED compressing files that filename is same as filename compressed.
- FIXED move to backup function fails when filename to backup is the same of existing folder.
- FIXED When stay on top of Romulus is active the messages window was on back and not in front.
- FIXED Update Offlinelist profile using Updater option causes errors. 
- FIXED Sometimes when DAT import fails next DATs tryed to imported fails too.
- FIXED Some problems when processing window is active and user can use other options that must not be used when processing window is making the process forzing sometimes an exception.
- FIXED importation filesizes in HEX format 0x0000, i found only a DAT file using this kind of expression.
- FIXED XML some special chars in export profile options, (",&....).
- FIXED donation bug link in settings window. 

0.010

- ADDED full headers support. In Scan/Rebuild window you will see a selectable list with XML file headers available inside headers folder. If scanned files checksum matchs, header rules will be not applyed. But if not, the file is rebuilded and header rules will be applyed. TODO LIST DONE
- ADDED multivolume compressed files detection. If a file is multivolume can not delete files inside them. Romulus detects and adverts this.
- ADDED new Romulus versions check at start. Option can be dissabled from settings window.
- ADDED Nongood and Unrenamed in dat groups for updater option.
- ADDED Offlinelist to dat groups for updater option. But in this case will show updates for already existing Offlinelist dats inside the current database.
- ADDED Administrator check to change UAC option and enable or dissable Drag n Drop possibility. (Only Windows Vista Users).
- ADDED full XML parser to convert special chars to "-" char. This affects to importation module.
- ADDED XML parser is applyed to DAT headers too. This affects to importation module.
- ADDED more inconsistences checks at importation module, like "\\" or "<space> \" or "\<space>". Corrected with a "\" char.
- ADDED Donation option at settings window. Well im not in best economic times, "im spanish" ... thanks.
- CHANGED If file inside compressed file must be deleted and compressed file has only 1 file inside, Romulus deletes all compressed file without making a empty compressed file as result. This increases a bit the speed too.
- CHANGED Empty compressed files now are scanned as single rom. Is a remote possibility, but it can happen.
- CHANGED Not valid chars as "*","<",">" etc. Are changed to "-" and not for "_" to make filenames like Clrmamepro.
- FIXED crash when read multivolume 7z files, and one or more volume is lost.
- FIXED Torrent7z log is moved to temporal windows directory and not inside roms path.
- FIXED unnecessary double scan after rebuild files.
- FIXED Negative file sizes display for files with more than 2 Gig. If you see the problem is continuing, reimport same dat to fix it.
- FIXED Extracting from RAR, files that starts with "@" or "-".
- FIXED deleting files from RAR ZIP and 7Z, files that starts with "@" or "-".
- FIXED Treeview profile sorting when created folders starts with special chars.
- FIXED importation set names, files with chars "\" or "/", are changed to "-". Reimport same dat to fix it, if you have this problem.
- FIXED correct information message at Dat updater window, when connection fails.
- FIXED Generation of XML dat files from Generator option, XML special chars like "commas" are converted to XML format.
- FIXED Treeview profile sorting when created folders starts with special chars.
- FIXED When rebuild a file and this file must be possitioned and the destination file already exists but this file dont match and the origin and destination compression type is different, now works fine.
- FIXED compressed files count after done delete process. This only affects to overall speed.
- REMOVED SFX support for compressed files, because people dont use this, is very conflictive convining this with multivolume archives and file size of them is more.
- UPDATED RAR and RAR 64Bits to 4.01 version.
- UPDATED CHDMAN.EXE to 0.143 version. 

0.009

- ADDED detection of 32 or 64 Bits S.O running. Why? because external merged EXEs of 64 Bits like RAR.EXE 7Z.EXE or CHDMAN.EXE are added and used if you are in 64 Bits S.O. This will increase the speed in this S.Os.
- REMOVED external Romulus DLLs like 7za.dll, UnzDll.dll, ZipDll.dll, Unrar.dll, are merged into main EXE and are loaded in memory when Romulus starts. This increase a little bit the speed of reading compressed files.
- CHANGED All operations of adding, delete and extract are ported to command line. The reason is can be optimize your S.O if you have a 64 Bits version, easy update the compressors and remove possible errors.
- ADDED REBUILDER option. Is a new option that brings to you the possibility of create your own DAT files in XML format selecting a folder. You can check MD5, SHA1 or take compressed files as single files hashing it and not the content. TODO LIST DONE.
- ADDED UPDATER option. Is a new option (experimental) that check in some seconds if exists new versions of your existing DAT files. At moment groups of Arcade, Pinball, Fruit Machines, No-Intro, Tosec, Redump.org are included in this interesting option. TODO LIST DONE.
- ADDED in Settings a Updater section where the user can decide what Updater groups can be checked.
- ADDED Torrent7zip support. When a scanner ends if option is checked Romulus will launch t7z.exe for *.7z files.
- ADDED in Log window a popupmenu with possibility to go first line, go last line and if selected line has filenames or directory names will show the possility to open browser and select this file or folder.
- ADDED possibility to drag n drop tabs in loaded profiles in Scanner to sort it.
- ADDED first code to use HEADERS and RESIZE, for security dissabled. But will be available in next version.
- UPDATED CHDMAN.EXE to 0.142 version.
- UPDATED RAR.EXE to 4.00 version.
- IMPROVED stop process when compressed files with some files inside are rebuilding.
- IMPROVED download files function. All code was rewrited and is more secure. No Internet Explorer installed is needed to works and don't needs to remove cache to fix problems. By this reason removecache function was deleted.
- IMPROVED sizeoffile function. Now don't fails if a file is in use.
- IMPROVED compatibility for folders inside compressed files, empty or full.
- FIXED IMPORTANT BUG when files to rebuild or fix contains '%' char. The result was no predictable.
- FIXED Error extracting corrupted 7z files and takes it as correct.
- FIXED at import dat. If a file is duplicated first of all check if all checksums are same of the other. If is same then ignore else rename. At now only renames without check the hashes.
- FIXED processing files in scanner in no compressed mode (Folder) if an empty folder found but is needed now no delete it.
- FIXED wrong availability information if scanning process is stopped in the middle of compressed file with some files inside.
- FIXED error when start to scan in profiles with only CHDs and no ROMs. No more "No path found".
- FIXED stupid inverted information in main Profiles list, between Sets and Roms, don't worry is only a possition information bug, don't affect your Roms.
- FIXED more minor bugs.

0.008

- FIXED In scanner if CRC information is not available Romulus forces to try to check MD5, if not available SHA1 if not available then takes the rom as correct.
- FIXED extraction of RAR files that has special chars like commas.
- FIXED Recover prior rom mask name for updated offlinelist dats.
- FIXED Offlinelist updates finder that fails sometimes, removed internet cached files to solve it.
- ADDED all Offlinelist information by columns in list. Just reimport dat or update to view this new info.
- ADDED country flags for offlinelist dats. Just reimport dat or update to view.
- ADDED in scanner tab properties button to change some properties of loaded profiles.
- ADDED possibility to change Offlinelist Rom Naming Mask without reimport dat using properties option.
- ADDED experimental code to increase access disk when read offlinelist images.
- ADDED Preliminar German language using online traductor, Elfish a new german betatester is fixing errors.
- UPDATED CHDMan merged EXE to 0.141u1 version.
- FIXED some minor bugs.

0.007

- FIXED compression in Zip for some big files, used 7z.exe for now to solve it.
- FIXED some errors showing images at Offlinelist profiles.
- FIXED slowdowns when shoing images at Offlinelist profiles.
- FIXED some bugs at rebuilding files process that cause same file is trying to rebuilded in the place of same file exists.
- FIXED problems detecting Folders inside Rar and 7z files.
- FIXED detecting files and folders at scan or rebuild process when a empty folder is found next file was skipped.
- FIXED when a file needs to be rebuilded and user decides not to fix, now continue scanning inside compressed file to know more possible correct roms. In other versions automatic skip complete compressed file without check more inside.
- FIXED checking folders inside compresed files, to know if is empty, part of a path of correct rom place and if it needed or not.
- FIXED bug found at import DAT with files that ends with a '.' causing scanning errors. No-intro Microsoft Xbox 360 (DLC) has this kind of bug, Romulus checks it and remove this to fix this problem. Reimport DAT to fix it.
- FIXED file exists detection when file has wrong datetime format.
- FIXED some freezes found in different parts of the application. I hate freezes like fixing at Clrmame pro. Multithreating was added in heavy processes.
- FIXED 7z file extraction when inside compressed files has wrong datetime format, like made with torrent7z utility. Bug found by Grinderedge.
- FIXED some bugs detecting DATs in XML format.
- FIXED some Offlinelist bugs displaying Regions when DAT is imported.
- FIXED default temporal dir and backup dir not set always in 'C:' drive else OS drive.
- FIXED a lot and a lot of minor bugs.
- IMPROVED Scan/Rebuild initialization speed.
- IMPROVED Profiles loading speed about +50%, this new code disables sorting column ability.
- MERGED 7z.exe, 7z.dll, Rar.exe, Torrentzip.exe inside Romulus main EXE, and extracted from it when needed. Seems some antivirus don't like this, ignore it Romulus is not a virus.
- ADDED and merged Chdman.exe inside Romulus main EXE, needed to check CHD Mame files correctly.
- ADDED possiblity of detect and rebuild CHD files when a profile with CHDs is loaded.
- ADDED Spanish language to Romulus selectable in Settings options.
- ADDED finally scanning/rebuild uncompressed roms.
- ADDED Rar splitted files support at Scan/Rebuild/Import DATs. Rar, R00, R01 ... you know.
- ADDED code to set as valid a ROM with wrong size only for Offlinelist profiles, but logs adverts of this saying "possible trimmed rom". This fix was decided because Offlinelist not checks size and some Advanscene DATs has some wrong sizes as original Scene Releases.
- ADDED code to make friendfixes as current loaded profile or loaded profiles in batch mode. Friendfix is a simple DAT file with your missing roms used to send it to a friend to know your missing roms.
- STARTED some ideas but not in this version visibles but will be implemented in next versions like, Updater, DAT Creator and P2P Community. 

0.006 (First public release)

- RECODED all the scan/rebuild functions, as result we have more security in this processes and i think that you can do this steps without worrying
- RECODED all the RAR and 7z files manipulation and finally are enabled in scan/rebuild processes.
- FIXED rare effect when ALT key pressed in Windows Vista and Windows 7 that make some components of forms disappear.
- FIXED wrong display format of elapsed time in progress form in some OS.
- FIXED wrong display in file sizes columns showed as bytes.
- FIXED freezes time on Windows 7 when being started to scan or rebuild files.
- FIXED when a file is tried to be opened as 7zip and the file is not that cause a file lock unless Romulus closed.
- FIXED crashing problem when a lot of 7zip files are scanned.
- FIXED lost Images CRC information at offlinelist dat import that causes Romulus is always downloading all images when only needs to find the news, reimport it to fix the problem.
- FIXED lost Image number information at offlinelist dat that causes displaying wrong images, reimport it to fix the problem.
- ADDED in settings a option to disable UAC Security needed to enable drag'n drop features only for Windows Vista users.
- ADDED the code to save the log in log window.
- ADDED the code to save the last browsed directories and recover the position in the next uses.
- FIXED a lot of small bugs.

0.005<= (No public)

- Early versions only for testing...