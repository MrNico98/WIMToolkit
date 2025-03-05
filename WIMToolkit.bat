@echo off 
SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL ENABLEEXTENSIONS 
::Ask for admin privileges 
 set "params=%*" 
 cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/c cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B ) 
::############################################################################################################################## 
::Non impallare il cmd 
 if exist "%TEMP%\consoleSettingsBackup.reg" regedit /S "%TEMP%\consoleSettingsBackup.reg"&DEL /F /Q "%TEMP%\consoleSettingsBackup.reg"&goto :mainstart 
 regedit /S /e "%TEMP%\consoleSettingsBackup.reg" "HKEY_CURRENT_USER\Console" 
 echo REGEDIT4>"%TEMP%\disablequickedit.reg" 
 echo [HKEY_CURRENT_USER\Console]>>"%TEMP%\disablequickedit.reg" 
 (echo "QuickEdit"=dword:00000000)>>"%TEMP%\disablequickedit.reg" 
 regedit /S "%TEMP%\disablequickedit.reg" 
 DEL /F /Q "%TEMP%\disablequickedit.reg" 
 start "" "cmd" /c "%~dpnx0"&exit 
::############################################################################################################################## 
::Vari Set 
 :mainstart 
 color 1f 
 set ConsoleBackColor=Blue 
 set ConsoleForeColor=White 
 set "Zip=Risorse\7z.exe" 
 IF NOT EXIST "DVD" ( mkdir "%~dp0\DVD" ) 
 IF NOT EXIST "ISO" ( mkdir "%~dp0\ISO" ) 
 IF NOT EXIST "Aggiunte" ( mkdir "%~dp0\Aggiunte" ) 
 IF NOT EXIST "Mount" ( mkdir "%~dp0\Mount" ) 
 IF NOT EXIST "Boot" ( mkdir "%~dp0\Boot" ) 
 IF NOT EXIST "WinRE" ( mkdir "%~dp0\WinRe" ) 
 IF NOT EXIST "Temp" ( mkdir "%~dp0\Temp" ) 
 IF NOT EXIST "Features" ( mkdir "%~dp0\Features" ) 
 IF NOT EXIST "WIMpersonali" ( mkdir "%~dp0\WIMpersonali" )
 IF NOT EXIST "Aggiunte\W11" ( mkdir "%~dp0\Aggiunte\W11" )
 IF NOT EXIST "Aggiunte\W10" ( mkdir "%~dp0\Aggiunte\W10" )
 IF NOT EXIST "Aggiunte\W10\VisualCRuntime" ( mkdir "%~dp0\Aggiunte\W10\VisualCRuntime" )
 IF NOT EXIST "Aggiunte\W11\VisualCRuntime" ( mkdir "%~dp0\Aggiunte\W11\VisualCRuntime" )
 IF NOT EXIST "Aggiunte\W11\Driver" ( mkdir "%~dp0\Aggiunte\W11\Driver" )
 IF NOT EXIST "Aggiunte\W11\FileCAB" ( mkdir "%~dp0\Aggiunte\W11\FileCAB" )
 set "driver=Aggiunte\W11\Driver"
 set "risorcacab=Risorse\ESD2CAB-CAB2ESD.zip"
 set "aggiunte11=Aggiunte\W11"
 set "aggiunte10=Aggiunte\W10"
 set "wimpersonali=WIMpersonali"
 set "features=Features" 
 set "winre=WinRE" 
 set "mount=Mount" 
 set "DVD=DVD" 
 set "wimtemp=Temp"
 set "ISO=ISO" 
 set "boot=Boot" 
 set "Aggiunte=Aggiunte" 
 set "Oscdimg=Risorse\oscdimg.exe" 
 set "WimlibImagex=Risorse\wimlib-imagex.exe"
 set "os=" 
 set "OutputFolder=%DVD%" 
 chcp 1252 > nul 2>&1 
 set LANG=it_IT 
 echo. > %features%\DisabilitaFeatures.txt 
 echo. > %features%\AbilitaFeatures.txt
 set "w11homekey=YTMG3-N6DKC-DKB77-7M9GH-8HVX7"
 set "w11homenkey=4CPRK-NM3K3-X6XXQ-RXX86-WXCHW"
 set "w11prokey=VK7JG-NPHTM-C97JM-9MPGT-3V66T"
 set "w11pronkey=2B87N-8KFHP-DKV6R-Y2C8J-PKCKT"
 set "w11proworkkey=DXG7C-N36C4-C4HTG-X4T3X-2YV77"
 set "w11proworknkey=WYPNQ-8C467-V2W6J-TX4WX-WT2RQ"
 set "w11proeducationkey=8PTT6-RNW4C-6V7J2-C2D3X-MHBPB"
 set "w11proEducationnkey=84NGF-MHBT6-FXBX8-QWJK7-DRR8H"
 set "w11enterprisekey=XGVPP-NMH47-7TTHJ-W3FW7-8HV2C"
 set "w11enterprisenkey=WGGHN-J84D6-QYCPR-T7PJ7-X766F"
 set "cab=Risorse\esd2cab_CLI.cmd"
 set "empty=1"
 set "HostUILanguage=it-IT"
 set "FileCAB=Aggiunte\W11\FileCAB"
::############################################################################################################################## 
::EULA 
 cls 
 title WIMToolkit v.0.6
 echo. ======================================================EULA============================================================ 
 echo. Il WIMToolkit e' fondamentalmente uno strumento per eseguire la manutenzione, personalizzare, aggiungere o rimuovere 
 echo. funzionalita' e componenti, abilitare o disabilitare funzionalita' del sistema operativo Windows. 
 echo. 
 echo. WIMToolkit e' destinato al solo uso su sistemi operativi Microsoft Windows. 
 echo. WIMToolkit viene fornito "cosi com'e'", senza alcuna garanzia espressa o implicita. 
 echo. In nessun caso l'autore sara' ritenuto responsabile per eventuali danni derivanti dall'uso di questo script. 
 echo. 
 echo. WIMToolkit utilizza vari strumenti di terze parti per eseguire alcune delle sue attivita'. 
 echo. WIMToolkit, Windows sono marchi registrati dei rispettivi autori o societa'. 
 echo. ===============================================A:Accetta/R:Rifiuta==================================================== 
 choice /C:AR /M "Digita " 
 if errorlevel 2 goto :eof 
::############################################################################################################################## 
::Puliziadism 
 :puliziadism 
 cls 
 echo               PULIZIA DISM 
 echo =========================================== 
 echo Ora eseguiro' una pulizia rimani in attesa 
 echo =========================================== 
 dism /quiet /unmount-image /mountdir:%mount% /discard >nul
 dism /quiet /unmount-image /mountdir:%boot% /discard >nul
 dism /quiet /unmount-image /mountdir:%winre% /discard >nul
 dism /cleanup-mountpoints 
::############################################################################################################################## 
::MenuPrincipale 
 :menuprincipale
 cls
 title WIMToolkit v.0.6
 echo                        Menu
 echo =================================================== 
 echo                   [1] Estrai ISO 
 echo                   [2] Monta WIM 
 echo                   [3] Rimuovi\Modifica Componenti 
 echo                   [4] Unattend e Servizi
 echo                   [5] Tweaks 
 echo                   [6] Aggiungi Componenti
 echo                   [7] Smonta WIM 
 echo                   [8] Extra WIM 
 echo                   [9] Crea ISO
 echo.
 echo                   [X] Esci
 echo ===================================================
 choice /C:123456789X /N /M "Digita un numero: " 
 if errorlevel 10 goto :exitvolontario 
 if errorlevel 9 call :creaiso 
 if errorlevel 8 goto :extra 
 if errorlevel 7 goto :smontawim 
 if errorlevel 6 goto :aggiungicomeponenti 
 if errorlevel 5 goto :tweaks 
 if errorlevel 4 goto :unattend 
 if errorlevel 3 goto :rimuovicomponenti 
 if errorlevel 2 goto :montawim 
 if errorlevel 1 goto :estraiso 
::############################################################################################################################## 
::RimuoviComponenti 
 :rimuovicomponenti 
 title WIMToolkit Menu Componenti 
 IF "%os%" equ "" ( echo Seleziona prima ^<Monta ISO^> && timeout 4 >NUL && goto :menuprincipale ) 
 cls 
 echo               Menu Componenti 
 echo =================================================== 
 echo        [1] Seleziona i componenti
 echo        [2] Rimuovi Lingue Windows
 echo        [3] Cambia lingua default Windows
 echo        [4] Avvia rimozione selezionati "-" 
 echo. 
 echo                [X] Indietro 
 echo =================================================== 
 choice /C:1234X /N /M "Digita un numero: " 
 if errorlevel 5 goto :menuprincipale
 if errorlevel 4 goto :rimozioneselzionati
 if errorlevel 3 goto :cambialingua   
 if errorlevel 2 call :lingue
 if errorlevel 1 goto :selezionacomponenti 
::############################################################################################################################## 
::SelezionaCompoenti 
 :selezionacomponenti
 cls 
 echo                    Menu Componenti 
 echo =============================================== 
 echo                    [1] Internet 
 echo                    [2] Multimedia 
 echo                    [3] Privacy 
 echo                    [4] Remoto 
 echo                    [5] System 
 echo                    [6] App Sistema 
 echo. 
 echo                    [C] Suggeriti 
 echo                    [X] Indietro 
 echo =============================================== 
 choice /C:123456CX /N /M "Digita un numero: " 
 if errorlevel 8 goto :rimuovicomponenti 
 if errorlevel 7 goto :suggeritilista 
 if errorlevel 6 goto :appsistema  
 if errorlevel 5 goto :system  
 if errorlevel 4 goto :remoto   
 if errorlevel 3 goto :privacy 
 if errorlevel 2 goto :multimedia 
 if errorlevel 1 goto :internet 
::############################################################################################################################## 
::SelezionaComponenti2 
 :internet 
 title WIMToolkit Menu Internet 
 cls 
 echo                         MENU INTERNET 
 echo ==============================================================
 echo           %internetexplorer% [1] Internet Explorer 
 echo           %windowsservice% [2] Windows Service 
 echo           %windowsmail% [3] Windows Mail 
 echo           %openssh% [4] Open SSH
 echo           %remedge% [5] Edge 
 echo.
 echo                   [A] Seleziona tutto 
 echo                   [X] Indietro 
 echo ==============================================================
 set /p "Sceltanumero=Digita un numero, poi premi invio: " 
 if "%Sceltanumero%" equ "1" ( if "%internetexplorer%" equ "-" ( set "internetexplorer=" ) else ( set "internetexplorer=-" ) ) 
 if "%Sceltanumero%" equ "2" ( if "%windowsservice%" equ "-" ( set "windowsservice=" ) else ( set "windowsservice=-" ) ) 
 if "%Sceltanumero%" equ "3" ( if "%windowsmail%" equ "-" ( set "windowsmail=" ) else ( set "windowsmail=-" ) ) 
 if "%Sceltanumero%" equ "4" ( if "%openssh%" equ "-" ( set "openssh=" ) else ( set "openssh=-" ) )
 if "%Sceltanumero%" equ "5" ( if "%remedge%" equ "-" ( set "remedge=" ) else ( set "remedge=-" ) ) 
 if /i "%Sceltanumero%" equ "A" ( 
    set "internetexplorer=-" 
    set "windowsservice=-" 
    set "windowsmail=-" 
    set "openssh=-"
    set "remedge=-" 
 ) 
 if /i "%Sceltanumero%" equ "X" (  
  goto :selezionacomponenti 
 ) else ( 
  goto :internet 
 ) 
 :multimedia 
 cls 
 title WIMToolkit Menu Multimedia 
 echo                             MENU Multimedia 
 echo =============================================================================== 
 echo       %firstlogonoanimation% [1] First Logon Animation Chromium 
 echo       %gameexplorer% [2] Game Explorer 
 echo       %lockscreen% [3] Lock Screen Background 
 echo       %screensaver% [4] Screen Saver 
 echo       %strumentodicattura% [5] Strumento di Cattura 
 echo       %suonitemi% [6] Suoni di tema 
 echo       %riconoscimentovocale% [7] Riconoscimento Vocale 
 echo       %wallpaper% [8] Wallpaper 
 echo       %windowsmediaplayer% [9] Windows Media Player 
 echo       %windowsphotoviewer% [10] Windows Photo Viewer 
 echo       %temiwindowspersonalizzati% [11] Temi Windows Personalizzati 
 echo       %windowstifffilter% [12] Windows TIFF IFilter (OCR) 
 echo       %winsat% [13] Windows Sysstem Assessment Tool (WinSAT) 
 echo.          
 echo                           [A] Seleziona tutto 
 echo                           [X] Indietro 
 echo =============================================================================== 
 set /p "Sceltanumero=Digita un numero, poi premi invio: " 
 if "%Sceltanumero%" equ "1" ( if "%firstlogonoanimation%" equ "-" ( set "firstlogonoanimation=" ) else ( set "firstlogonoanimation=-" ) ) 
 if "%Sceltanumero%" equ "2" ( if "%gameexplorer%" equ "-" ( set "gameexplorer=" ) else ( set "gameexplorer=-" ) ) 
 if "%Sceltanumero%" equ "3" ( if "%lockscreen%" equ "-" ( set "lockscreen=" ) else ( set "lockscreen=-" ) ) 
 if "%Sceltanumero%" equ "4" ( if "%screensaver%" equ "-" ( set "screensaver=" ) else ( set "screensaver=-" ) ) 
 if "%Sceltanumero%" equ "5" ( if "%strumentodicattura%" equ "-" ( set "strumentodicattura=" ) else ( set "strumentodicattura=-" ) ) 
 if "%Sceltanumero%" equ "6" ( if "%suonitemi%" equ "-" ( set "suonitemi=" ) else ( set "suonitemi=-" ) ) 
 if "%Sceltanumero%" equ "7" ( if "%riconoscimentovocale%" equ "-" ( set "riconoscimentovocale=" ) else ( set "riconoscimentovocale=-" ) ) 
 if "%Sceltanumero%" equ "8" ( if "%wallpaper%" equ "-" ( set "wallpaper=" ) else ( set "wallpaper=-" ) ) 
 if "%Sceltanumero%" equ "9" ( if "%windowsmediaplayer%" equ "-" ( set "windowsmediaplayer=" ) else ( set "windowsmediaplayer=-" ) ) 
 if "%Sceltanumero%" equ "10" ( if "%windowsphotoviewer%" equ "-" ( set "windowsphotoviewer=" ) else ( set "windowsphotoviewer=-" ) ) 
 if "%Sceltanumero%" equ "11" ( if "%temiwindowspersonalizzati%" equ "-" ( set "temiwindowspersonalizzati=" ) else ( set "temiwindowspersonalizzati=-" ) ) 
 if "%Sceltanumero%" equ "12" ( if "%windowstifffilter%" equ "-" ( set "windowstifffilter=" ) else ( set "windowstifffilter=-" ) ) 
 if "%Sceltanumero%" equ "13" ( if "%winsat%" equ "-" ( set "winsat=" ) else ( set "winsat=-" ) ) 
 if /i "%Sceltanumero%" equ "A" ( 
    set "firstlogonoanimation=-" 
    set "internetexplorer=-" 
    set "gameexplorer=-" 
    set "lockscreen=-" 
    set "screensaver=-" 
    set "strumentodicattura=-" 
    set "suonitemi=-" 
    set "riconoscimentovocale=-" 
    set "wallpaper=-" 
    set "windowsmediaplayer=-" 
    set "windowsphotoviewer=-" 
    set "temiwindowspersonalizzati=-" 
    set "windowstifffilter=-" 
    set "winsat=-" 
 ) 
 if /i "%Sceltanumero%" equ "X" (  
  goto :selezionacomponenti 
 ) else ( 
  goto :multimedia 
 ) 
 :privacy 
 cls 
 title WIMToolkit Menu Privcay 
 echo                          MENU Privacy 
 echo =================================================================== 
 echo        %assignedaccess% [1] Assigned Access 
 echo        %ceip% [2] Customer Experience Improvement Program (CEIP) 
 echo        %windowshelloface% [3] Windows Hello Face 
 echo        %kerneldegging% [4] Kernel Debugging 
 echo        %wifisense% [5] Wifi Sense 
 echo        %unifiedtelemetryclient% [6] Unified Telemetry Client 
 echo        %picturepassword% [7] Picture Password
 echo.          
 echo                       [A] Seleziona tutto 
 echo                       [X] Indietro 
 echo ==================================================================
 set /p "Sceltanumero=Digita un numero, poi premi invio: " 
 if "%Sceltanumero%" equ "1" ( if "%assignedaccess%" equ "-" ( set "assignedaccess=" ) else ( set "assignedaccess=-" ) ) 
 if "%Sceltanumero%" equ "2" ( if "%ceip%" equ "-" ( set "ceip=" ) else ( set "ceip=-" ) ) 
 if "%Sceltanumero%" equ "3" ( if "%windowshelloface%" equ "-" ( set "windowshelloface=" ) else ( set "windowshelloface=-" ) ) 
 if "%Sceltanumero%" equ "4" ( if "%kerneldegging%" equ "-" ( set "kerneldegging=" ) else ( set "kerneldegging=-" ) ) 
 if "%Sceltanumero%" equ "5" ( if "%wifisense%" equ "-" ( set "wifisense=" ) else ( set "wifisense=-" ) ) 
 if "%Sceltanumero%" equ "6" ( if "%unifiedtelemetryclient%" equ "-" ( set "unifiedtelemetryclient=" ) else ( set "unifiedtelemetryclient=-" ) ) 
 if "%Sceltanumero%" equ "7" ( if "%picturepassword%" equ "-" ( set "picturepassword=" ) else ( set "picturepassword=-" ) ) 
 if /i "%Sceltanumero%" equ "A" ( 
    set "assignedaccess=-" 
    set "ceip=-" 
    set "windowshelloface=-" 
    set "kerneldegging=-" 
    set "wifisense=-" 
    set "unifiedtelemetryclient=-" 
    set "picturepassword=-" 
 ) 
 if /i "%Sceltanumero%" equ "X" (  
  goto :selezionacomponenti 
 ) else ( 
  goto :privacy 
 ) 
 :remoto 
 cls 
 title WIMToolkit Menu Remoto 
 echo                   MENU Remoto 
 echo ================================================== 
 echo            %homegroup% [1] Home Group
 echo.          
 echo                 [A] Seleziona tutto 
 echo                 [X] Indietro 
  echo ==================================================
 set /p "Sceltanumero=Digita un numero, poi premi invio: " 
 if "%Sceltanumero%" equ "1" ( if "%homegroup%" equ "-" ( set "homegroup=" ) else ( set "homegroup=-" ) )
 if /i "%Sceltanumero%" equ "A" ( 
    set "homegroup=-" 
 ) 
 if /i "%Sceltanumero%" equ "X" (  
  goto :selezionacomponenti 
 ) else ( 
  goto :remoto 
 ) 
 :system 
 cls 
 title WIMToolkit Menu System 
 echo                              MENU System 
 echo =============================================================================== 
 echo                       %directx% [1] DirectX (causa problemi) 
 echo                       %accessibilita% [2] Accessibilita
 echo                       %hello% [3] Windows Hello 
 echo                       %kernella57% [4] Kernel LA57 
 echo                       %mediaplayer% [5] Windows Media Player 
 echo                       %stepsrecord% [6] Steps StepsRecord 
 echo                       %tabletpc% [7] Tablet PC Math 
 echo                       %hevecvido% [8] Codifica HEVEC Video 
 echo                       %automatedesktop% [9] Automate Desktop 
 echo                       %rawimageextention% [10] Estensione RAW per foto 
 echo                       %scanhealt% [11] Scan Helat 
 echo                       %vp9video% [12] Estensione VP9 per video 
 echo                       %webmediaextation% [13] Estensione WEB per multimedia 
 echo                       %webimage% [14] Estensione WEB per foto 
 echo                       %terminale% [15] Terminale 
 echo                       %telemetria% [16] Telemetria 
 echo                       %localizzazione% [17] Localizzazione 
 echo                       %tailoredexperiences% [18] Tailored Experience
 echo                       %onedrive% [19] OneDrive
 echo                       %heifi% [20] Estensione immagini HEIFI
 echo                       %StepsRecorder% [21] Registrazione passaggi Windows
 echo.          
 echo                           [A] Seleziona tutto 
 echo                           [X] Indietro 
 echo =============================================================================== 
 set /p "Sceltanumero=Digita un numero, poi premi invio: " 
 if "%Sceltanumero%" equ "1" ( if "%directx%" equ "-" ( set "directx=" ) else ( set "directx=-" ) ) 
 if "%Sceltanumero%" equ "2" ( if "%accessibilita%" equ "-" ( set "accessibilita=" ) else ( set "accessibilita=-" ) ) 
 if "%Sceltanumero%" equ "3" ( if "%hello%" equ "-" ( set "hello=" ) else ( set "hello=-" ) ) 
 if "%Sceltanumero%" equ "4" ( if "%kernella57%" equ "-" ( set "kernella57=" ) else ( set "kernella57=-" ) ) 
 if "%Sceltanumero%" equ "5" ( if "%mediaplayer%" equ "-" ( set "mediaplayer=" ) else ( set "mediaplayer=-" ) ) 
 if "%Sceltanumero%" equ "6" ( if "%stepsrecord%" equ "-" ( set "stepsrecord=" ) else ( set "stepsrecord=-" ) ) 
 if "%Sceltanumero%" equ "7" ( if "%tabletpc%" equ "-" ( set "tabletpc=" ) else ( set "tabletpc=-" ) ) 
 if "%Sceltanumero%" equ "8" ( if "%hevecvido%" equ "-" ( set "hevecvido=" ) else ( set "hevecvido=-" ) ) 
 if "%Sceltanumero%" equ "9" ( if "%automatedesktop%" equ "-" ( set "automatedesktop=" ) else ( set "automatedesktop=-" ) ) 
 if "%Sceltanumero%" equ "10" ( if "%rawimageextention%" equ "-" ( set "rawimageextention=" ) else ( set "rawimageextention=-" ) ) 
 if "%Sceltanumero%" equ "11" ( if "%scanhealt%" equ "-" ( set "scanhealt=" ) else ( set "scanhealt=-" ) ) 
 if "%Sceltanumero%" equ "12" ( if "%vp9video%" equ "-" ( set "vp9video=" ) else ( set "vp9video=-" ) ) 
 if "%Sceltanumero%" equ "13" ( if "%webmediaextation%" equ "-" ( set "webmediaextation=" ) else ( set "webmediaextation=-" ) ) 
 if "%Sceltanumero%" equ "14" ( if "%webimage%" equ "-" ( set "webimage=" ) else ( set "webimage=-" ) ) 
 if "%Sceltanumero%" equ "15" ( if "%terminale%" equ "-" ( set "terminale=" ) else ( set "terminale=-" ) ) 
 if "%Sceltanumero%" equ "16" ( if "%telemetria%" equ "-" ( set "telemetria=" ) else ( set "telemetria=-" ) ) 
 if "%Sceltanumero%" equ "17" ( if "%localizzazione%" equ "-" ( set "localizzazione=" ) else ( set "localizzazione=-" ) ) 
 if "%Sceltanumero%" equ "18" ( if "%tailoredexperiences%" equ "-" ( set "tailoredexperiences=" ) else ( set "tailoredexperiences=-" ) )
 if "%Sceltanumero%" equ "19" ( if "%onedrive%" equ "-" ( set "onedrive=" ) else ( set "onedrive=-" ) ) 
 if "%Sceltanumero%" equ "20" ( if "%heifi%" equ "-" ( set "heifi=" ) else ( set "heifi=-" ) )
 if "%Sceltanumero%" equ "21" ( if "%StepsRecorder%" equ "-" ( set "StepsRecorder=" ) else ( set "StepsRecorder=-" ) )

 if /i "%Sceltanumero%" equ "A" ( 
    set "directx=-" 
    set "language=-" 
    set "hello=-" 
    set "kernella57=-" 
    set "mediaplayer=-" 
    set "stepsrecord=-" 
    set "tabletpc=-" 
    set "hevecvido=-" 
    set "automatedesktop=-" 
    set "rawimageextention=-" 
    set "vp9video=-" 
    set "webmediaextation=-" 
    set "webimage=-" 
    set "terminale=-" 
    set "telemetria=-" 
    set "scanhealt=-" 
    set "localizzazione=-" 
    set "tailoredexperiences=-"
    set "onedrive=-"
    set "heifi=-"
    set "StepsRecorder=-"
 ) 
 if /i "%Sceltanumero%" equ "X" (  
  goto :selezionacomponenti 
 ) else ( 
  goto :system 
 ) 
 :appsistema
 if "%os%" equ "10" ( goto :appsistema10 )
 if "%os%" equ "11" ( goto :appsistema11 ) else ( echo OS non settato && timeout 4 >NUL && goto :menuprincipale )

 :appsistema10
 cls 
 title WIMToolkit Menu APP Sistema 
 echo                            MENU APP Sistema 
 echo =============================================================================== 
 echo                     %wordpad% [1] WordPad 
 echo                     %clipchamp% [2] Clip Champ 
 echo                     %bingnews% [3] Bing News 
 echo                     %bingwheter% [4] Bing Wheter 
 echo                     %desktopappinstaller% [5] Desktop App Installer 
 echo                     %gamingapp% [6] Gaming App 
 echo                     %gethelp% [7] Get Help 
 echo                     %getstarted% [8] Per Iniziare 
 echo                     %officehub% [9] Office 
 echo                     %microsoftsolitair% [10] Solitario 
 echo                     %microsoftstickynotes% [11] Sticky Notes 
 echo                     %microsoftpaint% [12] Paint 
 echo                     %microsoftpeople% [13] Microsoft People 
 echo                     %catturaschermo% [14] Cattura Schermo 
 echo                     %microsoftstore% [15] Microsoft Store Acquisti in app -
 echo                     %todo% [16] Microsoft To Do 
 echo                     %vclibs% [17] VC Libs (causa problemi) 
 echo                     %windowsphoto% [18] Windows Photo -
 echo                     %windowsallarms% [19] Sveglie e Allarmi -
 echo                     %windowscalculator% [20] Calcolatrice -
 echo                     %windowscamera% [21] Windows Camera -
 echo                     %windowscomunication% [22] Windows Comunication -
 echo                     %feedbackhub% [23] Feedback HUB 
 echo                     %windowsmap% [24] Mappe -
 echo                     %windowsnotepad% [25] Blocco Note 
 echo                     %suondrecord% [26] Registratore -
 echo                     %windowsstore% [27] Microsoft Store 
 echo                     %xbox% [28] Xbox -
 echo                     %yourphone% [29] Connetti il tuo telefono  -
 echo                     %zunemusic% [30] Zune Music -
 echo                     %zunevideo% [31] Zune video -
 echo                     %quickassist% [32] Quick QuickAssist 
 echo                     %webexperience% [33] Web Experience -
 echo                     %microsoftteam% [34] Microsoft Team
 echo                     %mixedrealty% [35] Microsoft MixedReality Portal
 echo                     %onenote% [36] OneNote
 echo                     %dviewe% [37] Microsoft3DViewer
 echo                     %wallet% [38] Microsoft Wallet
 echo.          
 echo                           [A] Seleziona tutto 
 echo                           [X] Indietro 
 echo =============================================================================== 
 set /p "Sceltanumero=Digita un numero, poi premi invio: " 
 if "%Sceltanumero%" equ "1" ( if "%wordpad%" equ "-" ( set "wordpad=" ) else ( set "wordpad=-" ) ) 
 if "%Sceltanumero%" equ "2" ( if "%clipchamp%" equ "-" ( set "clipchamp=" ) else ( set "clipchamp=-" ) ) 
 if "%Sceltanumero%" equ "3" ( if "%bingnews%" equ "-" ( set "bingnews=" ) else ( set "bingnews=-" ) ) 
 if "%Sceltanumero%" equ "4" ( if "%bingwheter%" equ "-" ( set "bingwheter=" ) else ( set "bingwheter=-" ) ) 
 if "%Sceltanumero%" equ "5" ( if "%desktopappinstaller%" equ "-" ( set "desktopappinstaller=" ) else ( set "desktopappinstaller=-" ) ) 
 if "%Sceltanumero%" equ "6" ( if "%gamingapp%" equ "-" ( set "gamingapp=" ) else ( set "gamingapp=-" ) ) 
 if "%Sceltanumero%" equ "7" ( if "%gethelp%" equ "-" ( set "gethelp=" ) else ( set "gethelp=-" ) ) 
 if "%Sceltanumero%" equ "8" ( if "%getstarted%" equ "-" ( set "getstarted=" ) else ( set "getstarted=-" ) ) 
 if "%Sceltanumero%" equ "9" ( if "%officehub%" equ "-" ( set "officehub=" ) else ( set "officehub=-" ) ) 
 if "%Sceltanumero%" equ "10" ( if "%microsoftsolitair%" equ "-" ( set "microsoftsolitair=" ) else ( set "microsoftsolitair=-" ) ) 
 if "%Sceltanumero%" equ "11" ( if "%microsoftstickynotes%" equ "-" ( set "microsoftstickynotes=" ) else ( set "microsoftstickynotes=-" ) ) 
 if "%Sceltanumero%" equ "12" ( if "%microsoftpaint%" equ "-" ( set "microsoftpaint=" ) else ( set "microsoftpaint=-" ) ) 
 if "%Sceltanumero%" equ "13" ( if "%microsoftpeople%" equ "-" ( set "microsoftpeople=" ) else ( set "microsoftpeople=-" ) ) 
 if "%Sceltanumero%" equ "14" ( if "%catturaschermo%" equ "-" ( set "catturaschermo=" ) else ( set "catturaschermo=-" ) ) 
 if "%Sceltanumero%" equ "15" ( if "%microsoftstore%" equ "-" ( set "microsoftstore=" ) else ( set "microsoftstore=-" ) ) 
 if "%Sceltanumero%" equ "16" ( if "%todo%" equ "-" ( set "todo=" ) else ( set "todo=-" ) ) 
 if "%Sceltanumero%" equ "17" ( if "%vclibs%" equ "-" ( set "vclibs=" ) else ( set "vclibs=-" ) ) 
 if "%Sceltanumero%" equ "18" ( if "%windowsphoto%" equ "-" ( set "windowsphoto=" ) else ( set "windowsphoto=-" ) ) 
 if "%Sceltanumero%" equ "19" ( if "%windowsallarms%" equ "-" ( set "windowsallarms=" ) else ( set "windowsallarms=-" ) ) 
 if "%Sceltanumero%" equ "20" ( if "%windowscalculator%" equ "-" ( set "windowscalculator=" ) else ( set "windowscalculator=-" ) ) 
 if "%Sceltanumero%" equ "21" ( if "%windowscamera%" equ "-" ( set "windowscamera=" ) else ( set "windowscamera=-" ) ) 
 if "%Sceltanumero%" equ "22" ( if "%windowscomunication%" equ "-" ( set "windowscomunication=" ) else ( set "windowscomunication=-" ) ) 
 if "%Sceltanumero%" equ "23" ( if "%feedbackhub%" equ "-" ( set "feedbackhub=" ) else ( set "feedbackhub=-" ) ) 
 if "%Sceltanumero%" equ "24" ( if "%windowsmap%" equ "-" ( set "windowsmap=" ) else ( set "windowsmap=-" ) ) 
 if "%Sceltanumero%" equ "25" ( if "%windowsnotepad%" equ "-" ( set "windowsnotepad=" ) else ( set "windowsnotepad=-" ) ) 
 if "%Sceltanumero%" equ "26" ( if "%suondrecord%" equ "-" ( set "suondrecord=" ) else ( set "suondrecord=-" ) ) 
 if "%Sceltanumero%" equ "27" ( if "%windowsstore%" equ "-" ( set "windowsstore=" ) else ( set "windowsstore=-" ) ) 
 if "%Sceltanumero%" equ "28" ( if "%xbox%" equ "-" ( set "xbox=" ) else ( set "xbox=-" ) ) 
 if "%Sceltanumero%" equ "29" ( if "%yourphone%" equ "-" ( set "yourphone=" ) else ( set "yourphone=-" ) ) 
 if "%Sceltanumero%" equ "30" ( if "%zunemusic%" equ "-" ( set "zunemusic=" ) else ( set "zunemusic=-" ) ) 
 if "%Sceltanumero%" equ "31" ( if "%zunevideo%" equ "-" ( set "zunevideo=" ) else ( set "zunevideo=-" ) ) 
 if "%Sceltanumero%" equ "32" ( if "%quickassist%" equ "-" ( set "quickassist=" ) else ( set "quickassist=-" ) )  
 if "%Sceltanumero%" equ "33" ( if "%webexperience%" equ "-" ( set "webexperience=" ) else ( set "webexperience=-" ) )
 if "%Sceltanumero%" equ "34" ( if "%microsoftteam%" equ "-" ( set "microsoftteam=" ) else ( set "microsoftteam=-" ) ) 
 if "%Sceltanumero%" equ "35" ( if "%mixedrealty%" equ "-" ( set "mixedrealty=" ) else ( set "mixedrealty=-" ) )
 if "%Sceltanumero%" equ "36" ( if "%onenote%" equ "-" ( set "onenote=" ) else ( set "onenote=-" ) )
 if "%Sceltanumero%" equ "37" ( if "%dviewe%" equ "-" ( set "dviewe=" ) else ( set "dviewe=-" ) )
 if "%Sceltanumero%" equ "38" ( if "%wallet%" equ "-" ( set "wallet=" ) else ( set "wallet=-" ) )

 if /i "%Sceltanumero%" equ "A" ( 
    set "wordpad=-" 
    set "clipchamp=-" 
    set "bingnews=-" 
    set "bingwheter=-" 
    set "desktopappinstaller=-" 
    set "gamingapp=-" 
    set "gethelp=-" 
    set "getstarted=-" 
    set "officehub=-" 
    set "microsoftsolitair=-" 
    set "microsoftpaint=-" 
    set "microsoftstickynotes=-" 
    set "microsoftpeople=-" 
    set "catturaschermo=-" 
    set "microsoftstore=-" 
    set "todo=-" 
    set "vclibs=-" 
    set "windowsphoto=-" 
    set "windowsallarms=-" 
    set "windowscalculator=-" 
    set "windowscamera=-" 
    set "windowscomunication=-" 
    set "feedbackhub=-" 
    set "windowsmap=-" 
    set "windowsnotepad=-" 
    set "suondrecord=-" 
    set "windowsstore=-" 
    set "xbox=-" 
    set "yourphone=-" 
    set "zunemusic=-" 
    set "zunevideo=-" 
    set "quickassist=-" 
    set "webexperience=-"
    set "microsoftteam=-"
    set "mixedrealty=-"
    set "onenote=-"
    set "dviewe=-"
    set "wallet=-"

 ) 
 if /i "%Sceltanumero%" equ "X" (  
  goto :selezionacomponenti 
 ) else ( 
  goto :appsistema10
 ) 


 :appsistema11
 cls 
 title WIMToolkit Menu APP Sistema 
 echo                            MENU APP Sistema 
 echo =============================================================================== 
 echo                     %wordpad% [1] WordPad 
 echo                     %clipchamp% [2] Clip Champ 
 echo                     %bingnews% [3] Bing News 
 echo                     %bingwheter% [4] Bing Wheter 
 echo                     %desktopappinstaller% [5] Desktop App Installer 
 echo                     %gamingapp% [6] Gaming App 
 echo                     %gethelp% [7] Get Help 
 echo                     %getstarted% [8] Per Iniziare 
 echo                     %officehub% [9] Office 
 echo                     %microsoftsolitair% [10] Solitario 
 echo                     %microsoftstickynotes% [11] Sticky Notes 
 echo                     %microsoftpaint% [12] Paint 
 echo                     %microsoftpeople% [13] Microsoft People 
 echo                     %catturaschermo% [14] Cattura Schermo 
 echo                     %microsoftstore% [15] Microsoft Store Acquisti in app 
 echo                     %todo% [16] Microsoft To Do 
 echo                     %vclibs% [17] VC Libs (causa problemi) 
 echo                     %windowsphoto% [18] Windows Photo 
 echo                     %windowsallarms% [19] Sveglie e Allarmi 
 echo                     %windowscalculator% [20] Calcolatrice 
 echo                     %windowscamera% [21] Windows Camera 
 echo                     %windowscomunication% [22] Windows Comunication 
 echo                     %feedbackhub% [23] Feedback HUB 
 echo                     %windowsmap% [24] Mappe 
 echo                     %windowsnotepad% [25] Blocco Note 
 echo                     %suondrecord% [26] Registratore 
 echo                     %windowsstore% [27] Microsoft Store 
 echo                     %xbox% [28] Xbox 
 echo                     %yourphone% [29] Connetti il tuo telefono 
 echo                     %zunemusic% [30] Zune Music 
 echo                     %zunevideo% [31] Zune video 
 echo                     %quickassist% [32] Quick QuickAssist 
 echo                     %webexperience% [33] Web Experience
 echo                     %microsoftteam% [34] Microsoft Team
 echo                     %onenote% [35] OneNote
 echo                     %wallet% [36] Microsoft Wallet
 echo                     %outlook% [37] Outlook
 echo.          
 echo                           [A] Seleziona tutto 
 echo                           [X] Indietro 
 echo =============================================================================== 
 set /p "Sceltanumero=Digita un numero, poi premi invio: " 
 if "%Sceltanumero%" equ "1" ( if "%wordpad%" equ "-" ( set "wordpad=" ) else ( set "wordpad=-" ) ) 
 if "%Sceltanumero%" equ "2" ( if "%clipchamp%" equ "-" ( set "clipchamp=" ) else ( set "clipchamp=-" ) ) 
 if "%Sceltanumero%" equ "3" ( if "%bingnews%" equ "-" ( set "bingnews=" ) else ( set "bingnews=-" ) ) 
 if "%Sceltanumero%" equ "4" ( if "%bingwheter%" equ "-" ( set "bingwheter=" ) else ( set "bingwheter=-" ) ) 
 if "%Sceltanumero%" equ "5" ( if "%desktopappinstaller%" equ "-" ( set "desktopappinstaller=" ) else ( set "desktopappinstaller=-" ) ) 
 if "%Sceltanumero%" equ "6" ( if "%gamingapp%" equ "-" ( set "gamingapp=" ) else ( set "gamingapp=-" ) ) 
 if "%Sceltanumero%" equ "7" ( if "%gethelp%" equ "-" ( set "gethelp=" ) else ( set "gethelp=-" ) ) 
 if "%Sceltanumero%" equ "8" ( if "%getstarted%" equ "-" ( set "getstarted=" ) else ( set "getstarted=-" ) ) 
 if "%Sceltanumero%" equ "9" ( if "%officehub%" equ "-" ( set "officehub=" ) else ( set "officehub=-" ) ) 
 if "%Sceltanumero%" equ "10" ( if "%microsoftsolitair%" equ "-" ( set "microsoftsolitair=" ) else ( set "microsoftsolitair=-" ) ) 
 if "%Sceltanumero%" equ "11" ( if "%microsoftstickynotes%" equ "-" ( set "microsoftstickynotes=" ) else ( set "microsoftstickynotes=-" ) ) 
 if "%Sceltanumero%" equ "12" ( if "%microsoftpaint%" equ "-" ( set "microsoftpaint=" ) else ( set "microsoftpaint=-" ) ) 
 if "%Sceltanumero%" equ "13" ( if "%microsoftpeople%" equ "-" ( set "microsoftpeople=" ) else ( set "microsoftpeople=-" ) ) 
 if "%Sceltanumero%" equ "14" ( if "%catturaschermo%" equ "-" ( set "catturaschermo=" ) else ( set "catturaschermo=-" ) ) 
 if "%Sceltanumero%" equ "15" ( if "%microsoftstore%" equ "-" ( set "microsoftstore=" ) else ( set "microsoftstore=-" ) ) 
 if "%Sceltanumero%" equ "16" ( if "%todo%" equ "-" ( set "todo=" ) else ( set "todo=-" ) ) 
 if "%Sceltanumero%" equ "17" ( if "%vclibs%" equ "-" ( set "vclibs=" ) else ( set "vclibs=-" ) ) 
 if "%Sceltanumero%" equ "18" ( if "%windowsphoto%" equ "-" ( set "windowsphoto=" ) else ( set "windowsphoto=-" ) ) 
 if "%Sceltanumero%" equ "19" ( if "%windowsallarms%" equ "-" ( set "windowsallarms=" ) else ( set "windowsallarms=-" ) ) 
 if "%Sceltanumero%" equ "20" ( if "%windowscalculator%" equ "-" ( set "windowscalculator=" ) else ( set "windowscalculator=-" ) ) 
 if "%Sceltanumero%" equ "21" ( if "%windowscamera%" equ "-" ( set "windowscamera=" ) else ( set "windowscamera=-" ) ) 
 if "%Sceltanumero%" equ "22" ( if "%windowscomunication%" equ "-" ( set "windowscomunication=" ) else ( set "windowscomunication=-" ) ) 
 if "%Sceltanumero%" equ "23" ( if "%feedbackhub%" equ "-" ( set "feedbackhub=" ) else ( set "feedbackhub=-" ) ) 
 if "%Sceltanumero%" equ "24" ( if "%windowsmap%" equ "-" ( set "windowsmap=" ) else ( set "windowsmap=-" ) ) 
 if "%Sceltanumero%" equ "25" ( if "%windowsnotepad%" equ "-" ( set "windowsnotepad=" ) else ( set "windowsnotepad=-" ) ) 
 if "%Sceltanumero%" equ "26" ( if "%suondrecord%" equ "-" ( set "suondrecord=" ) else ( set "suondrecord=-" ) ) 
 if "%Sceltanumero%" equ "27" ( if "%windowsstore%" equ "-" ( set "windowsstore=" ) else ( set "windowsstore=-" ) ) 
 if "%Sceltanumero%" equ "28" ( if "%xbox%" equ "-" ( set "xbox=" ) else ( set "xbox=-" ) ) 
 if "%Sceltanumero%" equ "29" ( if "%yourphone%" equ "-" ( set "yourphone=" ) else ( set "yourphone=-" ) ) 
 if "%Sceltanumero%" equ "30" ( if "%zunemusic%" equ "-" ( set "zunemusic=" ) else ( set "zunemusic=-" ) ) 
 if "%Sceltanumero%" equ "31" ( if "%zunevideo%" equ "-" ( set "zunevideo=" ) else ( set "zunevideo=-" ) ) 
 if "%Sceltanumero%" equ "32" ( if "%quickassist%" equ "-" ( set "quickassist=" ) else ( set "quickassist=-" ) )  
 if "%Sceltanumero%" equ "33" ( if "%webexperience%" equ "-" ( set "webexperience=" ) else ( set "webexperience=-" ) )
 if "%Sceltanumero%" equ "34" ( if "%microsoftteam%" equ "-" ( set "microsoftteam=" ) else ( set "microsoftteam=-" ) )
 if "%Sceltanumero%" equ "35" ( if "%onenote%" equ "-" ( set "onenote=" ) else ( set "onenote=-" ) )
 if "%Sceltanumero%" equ "36" ( if "%wallet%" equ "-" ( set "wallet=" ) else ( set "wallet=-" ) )
 if "%Sceltanumero%" equ "37" ( if "%outlook%" equ "-" ( set "outlook=" ) else ( set "outlook=-" ) )

 if /i "%Sceltanumero%" equ "A" ( 
    set "wordpad=-" 
    set "clipchamp=-" 
    set "bingnews=-" 
    set "bingwheter=-" 
    set "desktopappinstaller=-" 
    set "gamingapp=-" 
    set "gethelp=-" 
    set "getstarted=-" 
    set "officehub=-" 
    set "microsoftsolitair=-" 
    set "microsoftpaint=-" 
    set "microsoftstickynotes=-" 
    set "microsoftpeople=-" 
    set "catturaschermo=-" 
    set "microsoftstore=-" 
    set "todo=-" 
    set "vclibs=-" 
    set "windowsphoto=-" 
    set "windowsallarms=-" 
    set "windowscalculator=-" 
    set "windowscamera=-" 
    set "windowscomunication=-" 
    set "feedbackhub=-" 
    set "windowsmap=-" 
    set "windowsnotepad=-" 
    set "suondrecord=-" 
    set "windowsstore=-" 
    set "xbox=-" 
    set "yourphone=-" 
    set "zunemusic=-" 
    set "zunevideo=-" 
    set "quickassist=-" 
    set "webexperience=-"
    set "microsoftteam=-"
    set "onenote=-"
    set "wallet=-"
    set "outlook=-"

 ) 
 if /i "%Sceltanumero%" equ "X" (  
  goto :selezionacomponenti 
 ) else ( 
  goto :appsistema11
 ) 
::############################################################################################################################## 
::Estrazione iso
 :estraiso
 set ISOFileName= 
 if exist "%DVD%\sources\*.wim" ( 
  echo.La cartella C:\DVD non e' vuota... 
	echo. 
	choice /C:SN /N /M "Gli elementi verranno eliminati, continuare? ['S'i/'N'o] : " 
   if errorlevel 2 goto :Stop 
	echo. 
 ) 
 if not exist "%ISO%\*.iso" ( 
	echo.La cartella C:\ISO e' vuota... 
	echo. 
	echo.Inserisci la iso di windows in %ISO%... 
	goto :Stop 
 ) 
 set /p ISOFileName=Inserisci il nome dell'iso senza inserire ".iso" :  
 set "ISOFileName=%ISOFileName%.iso" 
 echo. 
 if not exist "%ISO%\%ISOFileName%" ( 
	echo.Non trovo l'immagine : "<%ISO%\%ISOFileName%>"... 
	echo. 
	echo.Assicurati di aver scritto correttamente il nome iso... 
	goto :Stop 
 ) 
 echo.------------------------------------------------------------------------------- 
 echo.####Inizio Estrazione####################### 
 echo.------------------------------------------------------------------------------- 
 echo.
 call :RemoveFolder "%DVD%"
 echo.Sto estraendo l'iso in ^<DVD^> attendi... 
 echo.
 echo.Attendi...
 "%Zip%" x -y "%ISO%\%ISOFileName%" -o"%DVD%" >nul
 echo.
 set /a n=0
 if exist "%DVD%\sources\boot.wim" set /a n+=1
 if exist "%DVD%\sources\install.wim" set /a n+=1
 if exist "%DVD%\sources\install.esd" set /a n+=1
 if "%n%" equ "2" (echo.Estrazione Completata...) else echo.Estrazione Fallita...
 echo.
 echo.------------------------------------------------------------------------------- 
 echo.####Fine Estrazione############## 
 echo.------------------------------------------------------------------------------- 
 :Stop 
 echo. 
 echo.=============================================================================== 
 echo. 
 pause>nul|set /p=Premi un tasto per continuare... 
 set ISOFileName= 
 goto :menuprincipale 
::############################################################################################################################## 
::Rimozioe Cartella
 :RemoveFolder 
 if exist "%~1" rd /q /s "%~1" >nul 
 goto :eof 
::############################################################################################################################## 
::Montaggio WIM
 :montawim 
 IF "%os%" equ "11" echo WIM gia' montato! && timeout 4 >NUL && goto :menuprincipale 
 IF "%os%" equ "10" echo WIM gia' montato! && timeout 4 >NUL && goto :menuprincipale 
 cls 
 rem check if wim or esd 
 IF EXIST "%DVD%\sources\install.wim" ( goto :wim ) else ( goto :esd )

 :esd
 cls 
 echo ============================= 
 echo Converto ESD in WIM 
 echo =============================
 for /f "tokens=2 delims=: " %%a in ('dism /english /Get-ImageInfo /ImageFile:%DVD%\sources\install.esd ^| findstr Index') do ( set ImageCount=%%a )
 set "ImageIndexNo=1"
	for /l %%i in (2, 1, %ImageCount%) do (
		set "ImageIndexNo=!ImageIndexNo!,%%i"
	)
 for %%i in (%ImageIndexNo%) do (
	echo. 
	dism /export-image /SourceImageFile:"%DVD%\sources\install.esd" /SourceIndex:%%i /DestinationImageFile:"%DVD%\sources\install.wim" /Compress:max /CheckIntegrity
	echo.
 )
 del "%DVD%\sources\install.esd"
 goto :montawim

 :wim 
 cls 
 echo. 
 echo.=============================================================================== 
 echo.^| Indice ^|  Arch ^| Nome 
 echo.=============================================================================== 
 for /f "tokens=2 delims=: " %%a in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim ^| findstr Index') do ( 
    for /f "tokens=2 delims=: " %%b in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim /Index:%%a ^| findstr /i Architecture') do ( 
        for /f "tokens=* delims=:" %%c in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim /Index:%%a ^| findstr /i Name') do ( 
            set "Name=%%c" 
            if %%a equ 1 echo.^|   %%a    ^|  %%b  ^| !Name! 
            if %%a gtr 1 if %%a leq 9 echo.^|   %%a    ^|  %%b  ^| !Name! 
            if %%a gtr 9 echo.^|   %%a   ^|  %%b  ^| !Name! 
        ) 
    ) 
 ) 
 echo.=============================================================================== 
 set /p indicemontato="Inserisci numero Indice oppure 'X' per tornare indietro: " 
 if /i "%indicemontato%" equ "X" goto :menuprincipale 
 echo.
 dism /mount-image /imagefile:"%DVD%\sources\install.wim" /index:%indicemontato% /mountdir:%mount% 
  choice /C:SN /N /M "Vuoi montare Boot.wim? ['S'i/'N'o]: " 
 if errorlevel 2 ( 
    set "bootwim=no" 
 ) else ( 
    set "bootwim=si" 
 ) 
 if "%bootwim%" equ "si" ( 
 dism /mount-image /imagefile:"%DVD%\sources\boot.wim" /index:2 /mountdir:%boot% 
 set "bootmontato=si"
 ) else ( set "bootmontato=no" )
 choice /C:SN /N /M "Vuoi montare WinRE.wim? ['S'i/'N'o]: " 
 if errorlevel 2 ( 
    set "rewin=no" 
 ) else ( 
    set "rewin=si" 
 ) 
 if "%rewin%" equ "si" ( 
 dism /mount-image /imagefile:"%DVD%\sources\boot.wim" /index:1 /mountdir:%winre% 
 set "winremontato=si"
 ) else ( set "winremontato=no" )
 set "deltrim=%indicemontato%"
 dism /Get-WimInfo /WimFile:"%DVD%\sources\install.wim" | find "Windows 11" 
 IF "%ERRORLEVEL%"=="0" ( set "os=11" ) else ( set "os=10" ) 
 cls 
 goto :menuprincipale 
::############################################################################################################################## 
::Rimozione Componenti 
 :rimozioneselzionati 
 cls 
 echo Inizio Rimozione..... 
 If "%internetexplorer%" equ "-" ( 
   powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'InternetExplorer*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
  )
  If "%StepsRecorder%" equ "-" ( 
   powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'StepsRecorder*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
  )  
 If "%windowsservice%" equ "-" ( 
  Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\System32\WalletService.exe" 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg delete "HKLM\TempHive\SOFTWARE\Microsoft\Wallet" /f 
  reg unload HKLM\TempHive 
 ) 
 If "%windowsmail%" equ "-" ( 
  Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\System32\WinMail.exe" 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg delete "HKLM\TempHive\SOFTWARE\Microsoft\Windows Mail" /f 
  reg unload HKLM\TempHive
 for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: microsoft.windowscommunicationsapps"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 )  
 ) 
 If "%firstlogonoanimation%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLogonAnimation /t REG_DWORD /d 0 /f
  reg unload HKLM\TempHive 
 ) 
 If "%gameexplorer%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\Software\Microsoft\Windows\CurrentVersion\GameUX" /v Games /t REG_DWORD /d 0 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%lockscreen%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\Software\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%screensaver%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 0 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%strumentodicattura%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\Software\Microsoft\Windows\TabletPC" /v SnippingToolCreation /t REG_DWORD /d 0 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%suonitemi%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v DisableSoundEffects /t REG_DWORD /d 1 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%riconoscimentovocale%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\SOFTWARE\Microsoft\Speech_OneCore\Settings\SpeechRecognition" /v SpeechRecognitionServiceAdaptiveLearningEnabled /t REG_DWORD /d 0 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%wallpaper%" equ "-" (
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Wallpaper*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}"   
 Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\Web\4K" 
 Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\Web\Screen" 
 Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\Web\touchkeyboard" 
 Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\Web\Wallpaper\Spotlight" 
 Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\Web\Wallpaper\ThemeA" 
 Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\Web\Wallpaper\ThemeB" 
 Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\Web\Wallpaper\ThemeC" 
 Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\Web\Wallpaper\ThemeD 
 ) 
 If "%windowsmediaplayer%" equ "-" ( 
  Risorse\PowerRun.exe cmd.exe /c "del /S /Q %mount%\Windows\System32\wmp*.dll" 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg delete "HKLM\TempHive\SOFTWARE\Microsoft\MediaPlayer" /f 
  reg unload HKLM\TempHive 
 ) 
 If "%windowsphotoviewer%" equ "-" ( 
  Risorse\PowerRun.exe cmd.exe /c "del /S /Q %mount%\Windows\System32\PhotoViewer.dll" 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg delete "HKLM\TempHive\Software\Microsoft\Windows Photo Viewer" /f 
  reg unload HKLM\TempHive 
 ) 
 If "%temiwindowspersonalizzati%" equ "-" ( 
  Risorse\PowerRun.exe cmd.exe /c "rmdir /s /q %mount%\Windows\Resources\Themes\Windows Classic" 
 ) 
 If "%windowstifffilter%" equ "-" ( 
  Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\System32\TiffIFilter.dll" 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg delete "HKLM\TempHive\SOFTWARE\Microsoft\Windows Search\Gather\Windows\SystemIndex\Extensions\.tiff" /f 
  reg unload HKLM\TempHive 
 ) 
 If "%winsat%" equ "-" ( 
  Risorse\PowerRun.exe cmd.exe /c "del /Q /S %mount%\Windows\System32\WinSAT.exe" 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg delete "HKLM\TempHive\SOFTWARE\Microsoft\Windows\CurrentVersion\WinSAT" /f 
  reg unload HKLM\TempHive 
 ) 
 If "%ceip%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\SOFTWARE\Microsoft\SQMClient" /v CEIPEnable /t REG_DWORD /d 0 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%wifisense%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\Software\Microsoft\WcmSvc\wifinetworkmanager\config" /v AutoConnectAllowedOEM /t REG_DWORD /d 0 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%unifiedtelemetryclient%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%picturepassword%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\System" /v BlockDomainPicturePassword /t REG_DWORD /d 1 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%homegroup%" equ "-" ( 
  reg load HKLM\TempHive "%mount%\Windows\System32\config\SOFTWARE" 
  reg add "HKLM\TempHive\SOFTWARE\Policies\Microsoft\Windows\HomeGroup" /v DisableHomeGroup /t REG_DWORD /d 1 /f 
  reg unload HKLM\TempHive 
 ) 
 If "%directx%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-OneCore-DirectX-Database-FOD*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
 ) 
 If "%accessibilita%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-LanguageFeatures-Handwriting*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart | Out-Null}" 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-LanguageFeatures-OCR*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart | Out-Null}" 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-LanguageFeatures-Speech*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart | Out-Null}" 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-LanguageFeatures-TextToSpeech*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart | Out-Null}" 
 ) 
 If "%hello%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-Hello-Face-Package*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
 ) 
 If "%kernella57%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-Kernel-LA57-FoD*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
 ) 
 If "%mediaplayer%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-MediaPlayer*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
 ) 
 If "%stepsrecord%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-MediaPlayer*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
 ) 
 If "%tabletpc%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-TabletPCMath*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
 ) 
 If "%wordpad%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-WordPad-FoD*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
 ) 
 If "%openssh%" equ "-" ( 
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'OpenSSH-Client*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart}" 
 ) 
 If "%clipchamp%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Clipchamp.Clipchamp"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%bingnews%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.BingNews"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%bingwheter%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.BingWeather"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%desktopappinstaller%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.DesktopAppInstaller"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%gamingapp%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.GamingApp"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%gethelp%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.GetHelp"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%getstarted%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.Getstarted"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%hevecvido%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.HEVCVideoExtension"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
  If "%heifi%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.HEIFImageExtension"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%officehub%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.MicrosoftOfficeHub"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%microsoftsolitair%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.MicrosoftSolitaireCollection"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%microsoftstickynotes%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.MicrosoftStickyNotes"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%microsoftpaint%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.Paint"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%microsoftpeople%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.People"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%automatedesktop%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.PowerAutomateDesktop"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%automatedesktop%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.PowerAutomateDesktop"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%rawimageextention%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.RawImageExtension"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%catturaschermo%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.RScreenSketch"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%scanhealt%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.SecHealthUI"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%microsoftstore%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.StorePurchaseApp"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%todo%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.Todos"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%vclibs%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.VCLibs"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%vp9video%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.VP9VideoExtensions"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%webmediaextation%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WebMediaExtensions"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%webimage%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WebpImageExtension"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%windowsphoto%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.Windows.Photos"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%windowsallarms%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsAlarms"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%windowscalculator%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsCalculator"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%windowscamera%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsCamera"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%windowscomunication%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: microsoft.windowscommunicationsapps"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%feedbackhub%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsFeedbackHub"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%windowsmap%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsMaps"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%windowsnotepad%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsNotepad"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%suondrecord%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsSoundRecorder"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%windowsstore%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsStore"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%terminale%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.WindowsTerminal"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%xbox%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.Xbox.TCUI"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
    for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.XboxGameOverlay"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
     for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.XboxGamingOverlay"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
      for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.XboxIdentityProvider"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
      for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.XboxSpeechToTextOverlay"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 )
    for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.XboxApp"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%yourphone%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.YourPhone"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 )
 ) 
 If "%zunemusic%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.ZuneMusic"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%zunevideo%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.ZuneVideo"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%quickassist%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: MicrosoftCorporationII.QuickAssist"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 ) 
 If "%webexperience%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: MicrosoftWindows.Client.WebExperience"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 )
 If "%microsoftteam%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: MicrosoftTeams"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 )
  If "%mixedrealty%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.MixedReality.Portal"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 )
   If "%onenote%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.Office.OneNote"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 )
   If "%dviewe%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.Microsoft3DViewer"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 )
   If "%wallet%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.Wallet"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 )
    If "%outlook%" equ "-" ( 
   for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.OutlookForWindows"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 ) 
 )
 if "%onedrive%" equ "-" ( 
 takeown /f "%mount%\Windows\System32\OneDriveSetup.exe"
 icacls "%mount%\Windows\System32\OneDriveSetup.exe /grant Administrators:F /T /C"
 Risorse\PowerRun.exe cmd.exe /c "del /f /q /s %mount%\Windows\System32\OneDriveSetup.exe"
 )
 if "%remedge%" equ "-" ( 
 rd "%mount%\Program Files (x86)\Microsoft\Edge" /s /q
 rd "%mount%\Program Files (x86)\Microsoft\EdgeUpdate" /s /q
 )
 
 If "%telemetria%" equ "-" ( 
 reg load HKLM\zCOMPONENTS "%mount%\Windows\System32\config\COMPONENTS" 
 reg load HKLM\zDEFAULT "%mount%\Windows\System32\config\default" 
 reg load HKLM\TK_NTUSER "%mount%\mount\Users\Default\ntuser.dat" 
 reg load HKLM\zSOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 reg load HKLM\zSYSTEM "%mount%\Windows\System32\config\SYSTEM" 
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f 
 Reg delete "HKLM\TK_SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f  
 Reg delete "HKLM\TK_SYSTEM\ControlSet001\Control\WMI\AutoLogger\SQMLogger" /f 
 Reg delete "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /f 
 Reg add "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f 
 Reg add "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD 0 /f 
 Reg add "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD 0 /f 
 Reg delete "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /f 
 Reg delete "Microsoft\Windows\Application Experience\ProgramDataUpdater" /f 
 Reg delete "Microsoft\Windows\Autochk\Proxy" /f 
 Reg delete "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /f 
 Reg delete "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /f 
 Reg delete "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /f 
 reg unload HKLM\zCOMPONENTS 
 reg unload HKLM\zDRIVERS 
 reg unload HKLM\zDEFAULT 
 reg unload HKLM\TK_NTUSER 
 reg unload HKLM\zSOFTWARE 
 reg unload HKLM\zSYSTEM 
 ) 
 If "%localizzazione%" equ "-" ( 
 reg load HKLM\zSOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 reg load HKLM\zSYSTEM "%mount%\Windows\System32\config\SYSTEM" 
 reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f 
 reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d 0 /f 
 reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d 0 /f 
 reg unload HKLM\zSOFTWARE 
 reg unload HKLM\zSYSTEM 
 ) 
 If "%tailoredexperiences%" equ "-" ( 
 reg load HKLM\zSOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d 1 /f 
 reg unload HKLM\zSOFTWARE 
 ) 
 goto :rimuovicomponenti 
::#############################################################################################################################
:cambialingua
 cls
 title WIMToolkit Seleziona Lingua
 set /a count=0
 for /f "tokens=*" %%A in ('dism /english /Image:C:\WIMToolkit\Mount /Get-Intl ^| findstr /C:"Default system UI language"') do (
    set DefaultLang=%%A
 )
 set count=0
 set lang_list=
 pause
 for /f "tokens=1,* delims=:" %%A in ('dism /english /Image:%mount% /Get-Intl ^| findstr /C:"Installed language(s):"') do (
    set "lang_list=%%B"
    for %%C in (!lang_list!) do (
        set "Lang[!count!]=%%C"
        set /a count+=1
    )
 )


 echo                    Seleziona lingua Windows
 echo. ==============================================================
 echo.
 echo Lingua UI predefinita: !DefaultLang!
 echo.
 echo.
 if !count! equ 0 (
    echo Nessuna lingua trovata && timeout 4 >NUL && goto :menuprincipale
 )

 set i=0
 for /l %%i in (0,1,!count!) do (
    set lang=!Lang[%%i]!
    if defined lang (
    echo [%%i] !lang!
    )
 )
 echo.
 echo. ==============================================================
 set /p "Sceltanumero=Digita il numero della lingua da rimuovere, poi premi invio o premi 'X' per tornare indietro: "

 if /i "!Sceltanumero!" equ "X" goto :rimuovicomponenti
 set "SceltaLingua=!Lang[%Sceltanumero%]!"
 if not "!SceltaLingua!"=="" (
    call :cambialinguasistema !SceltaLingua!
    goto :cambialingua
 ) else (
    echo Selezione non valida && timeout 4 >NUL && goto :cambialingua
 )


 :cambialinguasistema
 set language=%1
 dism /Image:%mount% /Set-UILang:%language%
 dism /Image:%mount% /Set-UserLocale:%language%
 dism /Image:%mount% /Set-InputLocale:%language%
 dism /Image:%boot% /Set-UILang:%language%
 dism /Image:%boot% /Set-UserLocale:%language%
 dism /Image:%boot% /Set-InputLocale:%language%
 goto :cambialingua
::#############################################################################################################################
:lingue
 cls
 title WIMToolkit Rimuovi Lingua 
 set count=0
 set lang_list=
 for /f "tokens=1,* delims=:" %%A in ('dism /english /Image:%mount% /Get-Intl ^| findstr /C:"Installed language(s):"') do (
    set "lang_list=%%B"
    for %%C in (!lang_list!) do (
        set "Lang[!count!]=%%C"
        set /a count+=1
    )
 )

 echo                    Rimuovi lingua Windows
 echo. ==============================================================
 echo.
 if !count! equ 0 (
    echo Nessuna lingua trovata && timeout 4 >NUL && goto :menuprincipale
 )

 set i=0
 for /l %%i in (0,1,!count!) do (
    set lang=!Lang[%%i]!
    if defined lang (
    echo [%%i] !lang!
    )
 )
 echo.
 echo. ==============================================================
 set /p "Sceltanumero=Digita il numero della lingua da rimuovere, poi premi invio o premi 'X' per tornare indietro: "

 if /i "!Sceltanumero!" equ "X" goto :rimuovicomponenti
 set "SceltaLingua=!Lang[%Sceltanumero%]!"
 if not "!SceltaLingua!"=="" (
    call :RemoveLanguage !SceltaLingua!
    goto :lingue
 ) else (
    echo Selezione non valida && timeout 4 >NUL && goto :lingue
 )


 :RemoveLanguage
 set language=%1
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-LanguageFeatures*-%language%*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /NoRestart }"
 powershell -Command "Get-WindowsPackage -Path '%mount%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-LanguageFeatures*-%language%*'} | ForEach-Object {dism /image:%mount% /Remove-Package /PackageName:$($_.PackageName) /ScratchDir:%wimtemp% /NoRestart }"
 powershell -Command "$mount='%mount%'; $language='%language%'; $results=Get-WindowsPackage -Path $mount | Where-Object { $_.PackageName -like 'Microsoft-Windows-Client-LanguagePack*' -and $_.PackageName -like '*'+$language+'*' }; if ($results) { $results | ForEach-Object { dism /image:$mount /Remove-Package /PackageName:$($_.PackageName) /ScratchDir='%wimtemp%' /NoRestart } } else { Write-Host 'Nessun pacchetto trovato con i criteri specificati.' }"
 powershell -Command "Get-WindowsPackage -Path '%boot%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-LanguageFeatures*-%language%*'} | ForEach-Object {dism /image:%boot% /Remove-Package /PackageName:$($_.PackageName) /NoRestart }"
 powershell -Command "Get-WindowsPackage -Path '%boot%' | Where-Object {$_.PackageName -like 'Microsoft-Windows-LanguageFeatures*-%language%*'} | ForEach-Object {dism /image:%boot% /Remove-Package /PackageName:$($_.PackageName) /ScratchDir:%wimtemp% /NoRestart }"
 powershell -Command "$mount='%boot%'; $language='%language%'; $results=Get-WindowsPackage -Path $mount | Where-Object { $_.PackageName -like 'Microsoft-Windows-Client-LanguagePack*' -and $_.PackageName -like '*'+$language+'*' }; if ($results) { $results | ForEach-Object { dism /image:$mount /Remove-Package /PackageName:$($_.PackageName) /ScratchDir='%wimtemp%' /NoRestart } } else { Write-Host 'Nessun pacchetto trovato con i criteri specificati.' }"
 PowerRun.exe cmd.exe /c "rmdir /s /q %wimtemp%"
 IF NOT EXIST "Temp" ( mkdir "%~dp0\Temp" ) 
 pause
 goto :lingue
::############################################################################################################################## 
::Unattend 
 :unattend 
 Title WIMToolkit Autounattend 
 IF "%os%" equ "" ( echo Seleziona prima ^<Monta ISO^> && timeout 4 >NUL && goto :menuprincipale )
 IF "%os%" equ "11" ( call :unattend11 ) else ( call :unattend10 )

:unattend10
 echo in arrivo con i prossimi aggiornamenti && timeout 4 >NUL && goto :menuprincipale

:unattend11
 dism /english /Get-ImageInfo /ImageFile:"%DVD%\sources\install.wim" /Index:%indicemontato% | find "Home N"
 if "%errorlevel%"=="0" ( set "key=%w11homenkey%" && goto :menuunattend11 ) else ( goto :homen )
 :homen
  dism /english /Get-ImageInfo /ImageFile:"%DVD%\sources\install.wim" /Index:%indicemontato% | find "Home"
 if "%errorlevel%"=="0" ( set "key=%w11homekey%" && goto :menuunattend11 ) else ( goto :pron )
 :pron
  dism /english /Get-ImageInfo /ImageFile:"%DVD%\sources\install.wim" /Index:%indicemontato% | find "Pro N"
 if "%errorlevel%"=="0" ( set "key=%w11pronkey%" && goto :menuunattend11 ) else ( goto :pro )
 :pro
  dism /english /Get-ImageInfo /ImageFile:"%DVD%\sources\install.wim" /Index:%indicemontato% | find "Pro"
 if "%errorlevel%"=="0" ( set "key=%w11prokey%" && goto :menuunattend11 ) else ( goto :proworkn )
 :proworkn
  dism /english /Get-ImageInfo /ImageFile:"%DVD%\sources\install.wim" /Index:%indicemontato% | find "Pro N for Worksations"
 if "%errorlevel%"=="0" ( set "key=%w11proworknkey%" && goto :menuunattend11 ) else ( goto :prowork )
 :prowork
  dism /english /Get-ImageInfo /ImageFile:"%DVD%\sources\install.wim" /Index:%indicemontato% | find "Pro for Worksations"
 if "%errorlevel%"=="0" ( set "key=%w11proworkkey%" && goto :menuunattend11 ) else ( goto :educationn )
 :educationn
  dism /english /Get-ImageInfo /ImageFile:"%DVD%\sources\install.wim" /Index:%indicemontato% | find "Education N"
 if "%errorlevel%"=="0" ( set "key=%w11proEducationnkey%" && goto :menuunattend11 ) else ( goto :education )
 :education
  dism /english /Get-ImageInfo /ImageFile:"%DVD%\sources\install.wim" /Index:%indicemontato% | find "Education"
 if "%errorlevel%"=="0" ( set "key=%w11proeducationkey%" && goto :menuunattend11 ) else ( echo Versione non identificata && timeout 4 >NUL && goto :menuprincipale )
 :menuunattend11
 cls
 echo             AUTOUNATTEND 
 echo ====================================== 
 echo          [1] Autounattend
 echo          [2] Servizi
 echo. 
 echo            [X] Indietro 
 echo ======================================
 choice /C:12X /N /M "Digita un numero: " 
 if errorlevel 3 goto :menuprincipale
 if errorlevel 2 goto :servizi
 if errorlevel 1 goto :generaautounattend

:servizi
reg load HKLM\TempSystem C:\WIMToolkit\Mount\Windows\System32\config\SYSTEM >nul 2>&1
if errorlevel 1 (
    echo Errore nel caricamento del registry. Assicurati che l'immagine sia montata correttamente.
    goto :end
)

echo Elenco dei servizi con stato (Automatico, Manuale, Disabilitato):
echo ==============================================

set count=0
for /f "tokens=*" %%A in ('reg query HKLM\TempSystem\ControlSet001\Services') do (
    set "serviceKey=%%A"
    
    :: Estrai solo il nome del servizio (parte finale del percorso)
    for %%C in ("%%A") do (
        set "serviceName=%%~nxC"
    )
    
    :: Ottieni il valore "Start" del servizio
    for /f "tokens=3" %%B in ('reg query "%%A" /v Start 2^>nul') do (
        set start=%%B
        
        if "!start!"=="0x2" (
            set status=Automatico
        ) else if "!start!"=="0x3" (
            set status=Manuale
        ) else if "!start!"=="0x4" (
            set status=Disabilitato
        ) else (
            set status=Altro
        )

        :: Mostra solo il nome del servizio con il suo stato
        if defined status (
            set /a count+=1
            echo !count! - !serviceName! (!status!)
            set "services[!count!]=!serviceName!"
            set "serviceStatus[!count!]=!status!"
            set "serviceKey[!count!]=%%A"
        )
    )
)

:: Se nessun servizio è stato trovato
if !count!==0 (
    echo Nessun servizio trovato.
    goto :end
)

:: Chiedi all'utente di scegliere il numero del servizio
echo.
set /p serviceNumber=Scegli il numero del servizio da abilitare/disabilitare o premi X per tornare indietro: 

:: Se l'utente sceglie X, torna al menu
if /i "%serviceNumber%"=="X" (
    reg unload HKLM\TempSystem
    goto :menuunattend11
)

:: Verifica la scelta e disabilita/abilita il servizio
if defined services[%serviceNumber%] (
    set "selectedService=!services[%serviceNumber%]!"
    set "selectedKey=!serviceKey[%serviceNumber%]!"

    echo Hai scelto il servizio: !selectedService!

    set "selectedStatus=!serviceStatus[%serviceNumber%]!"
    if "!selectedStatus!"=="Disabilitato" (
        set /p choice=Vuoi abilitare il servizio (A per automatico, M per manuale, N per annullare)? 
        if /i !choice!==A (
            reg add "!selectedKey!" /v Start /t REG_DWORD /d 2 /f
            echo Servizio impostato su automatico.
        ) else if /i !choice!==M (
            reg add "!selectedKey!" /v Start /t REG_DWORD /d 3 /f
            echo Servizio impostato su manuale.
        ) else (
            echo Operazione annullata.
        )
    ) else (
        echo Il servizio e' !selectedStatus!. Vuoi disabilitarlo (S/N)?
        set /p choice=
        if /i !choice!==S (
            reg add "!selectedKey!" /v Start /t REG_DWORD /d 4 /f
            echo Servizio disabilitato.
        ) else (
            echo Operazione annullata.
        )
    )
) else (
    echo Scelta non valida!
)

 :end
 :: Scarica l'hive del registro
 reg unload HKLM\TempSystem
 goto :menuunattend11



:generaautounattend
 powershell -command "(Get-Content -path Risorse\autounattend.xml -Raw) -replace 'keyporduct', '%key%' | Set-Content -Path Risorse\autounattend_edited.xml"
 powershell -command "(Get-Content -path Risorse\autounattend_edited.xml -Raw) -replace 'maips1', '%ps1main%' | Set-Content -Path Risorse\autounattend_e1dited.xml"
 del "Risorse\autounattend_edited.xml"
 move "Risorse\autounattend_e1dited.xml" "%DVD%\autounattend.xml" 
 goto :menuunattend11
::############################################################################################################################## 
::Smonta WIM
 :smontawim 
 title WIMToolkit Smonta Wim 
 IF "%os%" equ "" ( echo Seleziona prima ^<Monta ISO^> && timeout 4 >NUL && goto :menuprincipale ) 
 cls 
 echo                   Menu Smonta Wim 
 echo =================================================== 
 echo          [1] Annulla le modifiche e smonta wim 
 echo          [2] Applica le modifiche e smonta wim 
 echo. 
 echo                    [X] Indietro 
 echo =================================================== 
 choice /C:12X /N /M "Digita un numero: " 
 if errorlevel 3 goto :menuprincipale 
 if errorlevel 2 goto :applywim 
 if errorlevel 1 goto :discardwim 

 :discardwim 
 if "%bootmontato%" equ "si" (
 dism /unmount-image /mountdir:"%boot%" /discard
 ) 
 dism /unmount-image /mountdir:"%mount%" /discard 
 if "%winremontato%" equ "si" (
 dism /unmount-image /mountdir:"%winre%" /discard
 )
 call :RemoveFolder "%wimtemp%"
 set "os=" 
 goto :smontawim 

 :applywim
 choice /C:SN /N /M "Vuoi rimuovere le altre versioni? [S'i/'N'o]: " 
 if errorlevel 2 ( 
    set "trim=no" 
 ) else ( 
    set "trim=si" 
 ) 
 choice /C:SN /N /M "Vuoi pulire l'install.wim? [S'i/'N'o]: " 
 if errorlevel 2 ( 
    set "cleanwim=no" 
 ) else ( 
    set "cleanwim=si" 
 )
 if "%cleanwim%" equ "si" ( call :CleanupImage )
 :puliziaimmagine
 choice /C:SN /N /M "Vuoi pulire l'immagine? ['S'i/'N'o]: "
 if "%errorlevel%" equ "1" (
	echo.-------------------------------------------------------------------------------
	echo.Inizio Pulizia immagine....
	echo.-------------------------------------------------------------------------------
	echo.
	echo.
	if "%bootmontato%" equ "si" (
		   if exist "%boot%\Users\Default\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Users\Default\*.LOG1" 
			if exist "%boot%\Users\Default\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Users\Default\*.LOG2" 
			if exist "%boot%\Users\Default\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Users\Default\*.TM.blf" 
			if exist "%boot%\Users\Default\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Users\Default\*.regtrans-ms" 
			if exist "%boot%\Windows\inf\*.log" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\inf\*.log" 

			if exist "%boot%\Windows\CbsTemp\*" (
				for /f %%i in ('"dir /s /b /ad "%boot%\Windows\CbsTemp\*"" 2^>nul') do ( call :RemoveFolder %%i )
				Risorse\PowerRun.exe cmd.exe /c "del /s /f /q %boot%\Windows\CbsTemp\*" 
			)

			if exist "%boot%\Windows\System32\config\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\System32\config\*.LOG1" 
			if exist "%boot%\Windows\System32\config\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\System32\config\*.LOG2" 
			if exist "%boot%\Windows\System32\config\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\System32\config\*.TM.blf" 
			if exist "%boot%\Windows\System32\config\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q%boot%\Windows\System32\config\*.regtrans-ms" 
			if exist "%boot%\Windows\System32\SMI\Store\Machine\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\System32\SMI\Store\Machine\*.LOG1" 
			if exist "%boot%\Windows\System32\SMI\Store\Machine\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\System32\SMI\Store\Machine\*.LOG2" 
			if exist "%boot%\Windows\System32\SMI\Store\Machine\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\System32\SMI\Store\Machine\*.TM.blf" 
			if exist "%boot%\Windows\System32\SMI\Store\Machine\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\System32\SMI\Store\Machine\*.regtrans-ms" 
			if exist "%boot%\Windows\WinSxS\Backup\*" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\WinSxS\Backup\*" 
			if exist "%boot%\Windows\WinSxS\ManifestCache\*.bin" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\WinSxS\ManifestCache\*.bin" 
			if exist "%boot%\Windows\WinSxS\Temp\PendingDeletes\*" Risorse\PowerRun.exe cmd.exe /c "del /f /q %boot%\Windows\WinSxS\Temp\PendingDeletes\*" 
			if exist "%boot%\Windows\WinSxS\Temp\TransformerRollbackData\*" Risorse\PowerRun.exe cmd.exe /c "del /s /f /q %boot%\Windows\WinSxS\Temp\TransformerRollbackData\*" 
		)

	if "%winremontato%" equ "si" (
		if exist "%winre%\Users\Default\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Users\Default\*.LOG1" 
		if exist "%winre%\Users\Default\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Users\Default\*.LOG2" 
		if exist "%winre%\Users\Default\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Users\Default\*.TM.blf" 
		if exist "%winre%\Users\Default\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Users\Default\*.regtrans-ms" 
		if exist "%winre%\Windows\inf\*.log" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\inf\*.log" 

		if exist "%winre%\Windows\CbsTemp\*" (
			for /f %%j in ('"dir /s /b /ad "%winre%\Windows\CbsTemp\*"" 2^>nul') do ( call :RemoveFolder %%j)
			Risorse\PowerRun.exe cmd.exe /c "del /s /f /q %winre%\Windows\CbsTemp\*" 
		)

		if exist "%winre%\Windows\System32\config\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\System32\config\*.LOG1" 
		if exist "%winre%\Windows\System32\config\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\System32\config\*.LOG2" 
		if exist "%winre%\Windows\System32\config\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\System32\config\*.TM.blf" 
		if exist "%winre%\Windows\System32\config\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\System32\config\*.regtrans-ms" 
		if exist "%winre%\Windows\System32\SMI\Store\Machine\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\System32\SMI\Store\Machine\*.LOG1" 
		if exist "%winre%\Windows\System32\SMI\Store\Machine\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\System32\SMI\Store\Machine\*.LOG2" 
		if exist "%winre%\Windows\System32\SMI\Store\Machine\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\System32\SMI\Store\Machine\*.TM.blf" 
		if exist "%winre%\Windows\System32\SMI\Store\Machine\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\System32\SMI\Store\Machine\*.regtrans-ms" 
		if exist "%winre%\Windows\WinSxS\Backup\*" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\WinSxS\Backup\*" 
		if exist "%winre%\Windows\WinSxS\ManifestCache\*.bin" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\WinSxS\ManifestCache\*.bin" 
		if exist "%winre%\Windows\WinSxS\Temp\PendingDeletes\*" Risorse\PowerRun.exe cmd.exe /c "del /f /q %winre%\Windows\WinSxS\Temp\PendingDeletes\*" 
		if exist "%winre%\Windows\WinSxS\Temp\TransformerRollbackData\*" del /s /f /q "%winre%\Windows\WinSxS\Temp\TransformerRollbackData\*" 
	)

			if exist "%mount%\$Recycle.Bin" call :RemoveFolder "%mount%\$Recycle.Bin"
			if exist "%mount%\PerfLogs" call :RemoveFolder "%mount%\PerfLogs"
			if exist "%mount%\Users\Default\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Users\Default\*.LOG1" 
			if exist "%mount%\Users\Default\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Users\Default\*.LOG2" 
			if exist "%mount%\Users\Default\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Users\Default\*.TM.blf" 
			if exist "%mount%\Users\Default\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Users\Default\*.regtrans-ms" 
			if exist "%mount%\Windows\inf\*.log" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\inf\*.log" 
			if exist "%mount%\Windows\CbsTemp\*" (
				for /f %%i in ('"dir /s /b /ad "%mount%\Windows\CbsTemp\*"" 2^>nul') do ( call :RemoveFolder %%i )
				Risorse\PowerRun.exe cmd.exe /c "del /s /f /q %mount%\Windows\CbsTemp\*" 
			)
			if exist "%mount%\Windows\System32\config\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\System32\config\*.LOG1" 
			if exist "%mount%\Windows\System32\config\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\System32\config\*.LOG2" 
			if exist "%mount%\Windows\System32\config\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\System32\config\*.TM.blf" 
			if exist "%mount%\Windows\System32\config\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\System32\config\*.regtrans-ms" 
			if exist "%mount%\Windows\System32\SMI\Store\Machine\*.LOG1" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\System32\SMI\Store\Machine\*.LOG1" 
			if exist "%mount%\Windows\System32\SMI\Store\Machine\*.LOG2" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\System32\SMI\Store\Machine\*.LOG2" 
			if exist "%mount%\Windows\System32\SMI\Store\Machine\*.TM.blf" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\System32\SMI\Store\Machine\*.TM.blf" 
			if exist "%mount%\Windows\System32\SMI\Store\Machine\*.regtrans-ms" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\System32\SMI\Store\Machine\*.regtrans-ms" 
			if exist "%mount%\Windows\WinSxS\Backup\*" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\WinSxS\Backup\*" 
			if exist "%mount%\Windows\WinSxS\ManifestCache\*.bin" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\WinSxS\ManifestCache\*.bin" 
			if exist "%mount%\Windows\WinSxS\Temp\PendingDeletes\*" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\WinSxS\Temp\PendingDeletes\*" 
			if exist "%mount%\Windows\WinSxS\Temp\TransformerRollbackData\*" Risorse\PowerRun.exe cmd.exe /c "del /f /q %mount%\Windows\WinSxS\Temp\TransformerRollbackData\*" 
 )
 if "%bootmontato%" equ "si" (
 dism /unmount-image /mountdir:"%boot%" /commit
 ) 
 dism /unmount-image /mountdir:"%mount%" /commit
 if "%winremontato%" equ "si" ( 
 dism /unmount-image /mountdir:"%winre%" /commit 
 )
 if "%trim%" equ "si" ( 
 dism /Export-Image /SourceImageFile:"%DVD%\sources\install.wim" /SourceIndex:%deltrim% /DestinationImageFile:"%DVD%\sources\install_edit.wim" 
 del "%DVD%\sources\install.wim"
 move "%DVD%\sources\install_edit.wim" "%DVD%\sources\install.wim" 
 )
 choice /C:SN /N /M "Vuoi ottimizzare l'install.wim e boot.wim? [S'i/'N'o]: " 
 if errorlevel 2 ( 
    set "ottinwim=no" 
 ) else ( 
    set "ottinwim=si" 
 )
 if "%ottinwim%" equ "si" ( 
 "%WimlibImagex%" optimize "%DVD%\sources\install.wim"
 "%WimlibImagex%" optimize "%DVD%\sources\boot.wim"
 )
 call :RemoveFolder "%wimtemp%"
 set "os="
 goto :menuprincipale 
::############################################################################################################################## 
::Tweaks 
 :tweaks 
 IF "%os%" equ "" ( echo Seleziona prima ^<Monta ISO^> && timeout 4 >NUL && goto :menuprincipale ) 
 IF "%os%" equ "11" ( call :tweaks11 ) else ( call :tweaks10 ) 
 :tweaks10
 cls 
 title WIMToolkit Tweaks 
 echo                    TWEAKS 
 echo ================================================== 
 echo        [1] Disabilita Cortana 
 echo        [2] Elimina icone superflue taskbar 
 echo        [3] Abilita visualizzatore foto windows 
 echo        [4] Disabilita spazio riservato agli update 
 echo        [5] Rimuovi Inbox App associate 
 echo        [6] Disabilita Windows Update 
 echo        [7] Disabilita Windows Feature 
 echo        [8] Altri Tweaks
 echo. 
 echo                 [X] Indietro                    
 echo =================================================== 
 choice /C:12345678X /N /M "Digita un numero: " 
 if errorlevel 9 goto :menuprincipale 
 if errorlevel 8 call :altritweaks 
 if errorlevel 7 call :disabilitawindowsfeature 
 if errorlevel 6 call :stopupdate 
 if errorlevel 5 call :inboxapp 
 if errorlevel 4 call :disabilitaspazioriservato 
 if errorlevel 3 call :abilitaphotoviwer 
 if errorlevel 2 call :iconetaskbar 
 if errorlevel 1 call :disabcortana


 :tweaks11 
 cls 
 title WIMToolkit Tweaks 
 echo                    TWEAKS 
 echo ================================================== 
 echo        [1] Bypassa Requisiti Windows 11  
 echo        [2] Disabilita Cortana 
 echo        [3] Elimina icone superflue taskbar 
 echo        [4] Abilita visualizzatore foto windows 
 echo        [5] Disabilita spazio riservato agli update 
 echo        [6] Rimuovi Inbox App associate 
 echo        [7] Disabilita Windows Update 
 echo        [8] Disabilita Windows Feature 
 echo        [9] Altri Tweaks
 echo. 
 echo                 [X] Indietro                    
 echo =================================================== 
 choice /C:123456789X /N /M "Digita un numero: " 
 if errorlevel 10 goto :menuprincipale 
 if errorlevel 9 call :altritweaks 
 if errorlevel 8 call :disabilitawindowsfeature 
 if errorlevel 7 call :stopupdate 
 if errorlevel 6 call :inboxapp 
 if errorlevel 5 call :disabilitaspazioriservato 
 if errorlevel 4 call :abilitaphotoviwer 
 if errorlevel 3 call :iconetaskbar 
 if errorlevel 2 call :disabcortana 
 if errorlevel 1 call :bypass 
::############################################################################################################################## 
::Extra 
 :extra
 cls 
 title WIMToolkit Menu Extra 
 if "%os%" equ "11" ( echo Devi smontare il l'install.wim per proseguire && timeout 5 >NUL && goto :menuprincipale )
 if "%os%" equ "10" ( echo Devi smontare il l'install.wim per proseguire && timeout 5 >NUL && goto :menuprincipale )
 for /d %%D in ("%DVD%\*") do set "empty=0"
 if %empty%==1 (
    echo Devi prima estrarre la iso nella cartella <DVD> tramite il menu principale!
    timeout 5 >NUL
    goto :menuprincipale
 )

 echo                   EXTRA 
 echo ==============================================
 echo     [1] Converti ESD in WIM
 echo     [2] Elimina indici nell'install.wim
 echo     [3] Personalizza nomi indici dell'install.wim
 echo     [4] Ottimizza WIM
 echo     [5] Converti WIM in ESD
 echo     [6] Elimina WinRe
 echo     [7] DaRT
 echo. 
 echo               [X] Indietro                    
 echo ==============================================
 choice /C:1234567X /N /M "Digita un numero: " 
 if errorlevel 8 goto :menuprincipale
 if errorlevel 7 call :dart
 if errorlevel 6 call :delwinre
 if errorlevel 5 call :convertwim
 if errorlevel 4 call :ottimizzawim
 if errorlevel 3 call :nomeindicipers
 if errorlevel 2 call :DeleteImage 
 if errorlevel 1 call :convertesd

 :delwinre
 dism /Delete-Image /ImageFile:%DVD%\sources\boot.wim /Index:1
 goto :extra

::############################################################################################################################## 
::Crea ISO 
 :creaiso
 cls 
 echo                  CREA ISO
 echo ==============================================
 echo     [1] Crea il .iso
 echo     [2] Crea una USB avviabile
 echo. 
 echo               [X] Indietro                    
 echo ==============================================
 choice /C:12X /N /M "Digita un numero: " 
 if errorlevel 3 goto :menuprincipale
 if errorlevel 2 call :FormatUSB 
 if errorlevel 1 call :creazioneiso

:creazioneiso
 set "BIOSBoot=%DVD%\boot\etfsboot.com" 
 set "UEFIBoot=%DVD%\efi\microsoft\boot\efisys.bin" 
 set ISOLabel= 
 set ISOFileName= 
 set /p ISOLabel=Inserisci il nome del Volume:  
 echo. 
 set /p ISOFileName=Inserisci il nome della ISO:  
 echo. 
 if "%ISOLabel%" equ "" ( 
	if exist "%UEFIBoot%" "%Oscdimg%" -bootdata:2#p0,e,b"%BIOSBoot%"#pEF,e,b"%UEFIBoot%" -o -h -m -u2 -udfver102 "%DVD%" "%ISO%\%ISOFileName%.iso" 
	if not exist "%UEFIBoot%" "%Oscdimg%" -bootdata:1#p0,e,b"%BIOSBoot%" -o -h -m -u2 -udfver102 "%DVD%" "%ISO%\%ISOFileName%.iso" 
 ) 
 if "%ISOLabel%" neq "" ( 
	if exist "%UEFIBoot%" "%Oscdimg%" -bootdata:2#p0,e,b"%BIOSBoot%"#pEF,e,b"%UEFIBoot%" -o -h -m -u2 -udfver102 -l"%ISOLabel%" "%DVD%" "%ISO%\%ISOFileName%.iso" 
	if not exist "%UEFIBoot%" "%Oscdimg%" -bootdata:1#p0,e,b"%BIOSBoot%" -o -h -m -u2 -udfver102 "%DVD%" "%ISO%\%ISOFileName%.iso" 
 ) 
 pause>nul|set /p=Premi un tasto per continuare... 
 set BIOSBoot= 
 set UEFIBoot= 
 set ISOLabel= 
 set ISOFileName=
 goto :menuprincipale 
::############################################################################################################################## 
::Stop 
 :Stop 
 echo. 
 echo.=============================================================================== 
 echo. 
 pause>nul|set /p=Premi un tasto per continuare...
 goto :menuprincipale 
::############################################################################################################################## 
::Bypass 
 :bypass 
 if "%bootwim%" equ "no" echo Devi montare il Boot.wim && timeout 5 >NUL && goto :tweaks11 
 reg load HKLM\TK_COMPONENTS "%mount%\Windows\System32\config\COMPONENTS" 
 reg load HKLM\TK_DEFAULT "%mount%\Windows\System32\config\default"  
 reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat" 
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE"  
 reg load HKLM\TK_SYSTEM "%mount%\Windows\System32\config\SYSTEM"  
 Reg add "HKLM\TK_DEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_DEFAULT\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV1" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\Control Panel\UnsupportedHardwareNotificationCache" /v "SV2" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v "BypassNRO" /t REG_DWORD /d "1" /f  
 reg unload HKLM\TK_COMPONENTS  
 reg unload HKLM\TK_DEFAULT  
 reg unload HKLM\TK_DRIVERS  
 reg unload HKLM\TK_NTUSER  
 reg unload HKLM\TK_SCHEMA  
 reg unload HKLM\TK_SOFTWARE  
 reg unload HKLM\TK_SYSTEM  
 reg load HKLM\TK_SOFTWARE "%boot%\Windows\System32\config\SOFTWARE" 
 Reg load "HKLM\TK_BOOT_SYSTEM" "%boot%\Windows\System32\Config\SYSTEM" 
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v "BypassNRO" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_BOOT_SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f 
 Reg unload "HKLM\TK_BOOT_SYSTEM" 
 reg unload HKLM\TK_SOFTWARE  
 move "%DVD%\sources\appraiserres.dll" "%DVD%\sources\appraiserres.dll.bak"
 goto :tweaks11 
::############################################################################################################################## 
::Conversioni
 :convertesd
 echo Inizio conversione 
 for /f "tokens=2 delims=: " %%a in ('dism /english /Get-ImageInfo /ImageFile:%DVD%\sources\install.esd ^| findstr Index') do ( set ImageCount=%%a )
 set "ImageIndexNo=1"
	for /l %%i in (2, 1, %ImageCount%) do (
		set "ImageIndexNo=!ImageIndexNo!,%%i"
	)
 for %%i in (%ImageIndexNo%) do (
	echo. 
	dism /export-image /SourceImageFile:"%DVD%\sources\install.esd" /SourceIndex:%%i /DestinationImageFile:"%DVD%\sources\install.wim" /Compress:max /CheckIntegrity
	echo.
 )
 del "%DVD%\sources\install.esd"
 goto :extra

 :convertwim 
 for /f "tokens=2 delims=: " %%a in ('dism /english /Get-ImageInfo /ImageFile:%DVD%\sources\install.wim ^| findstr Index') do ( set ImageCount=%%a )
 set "ImageIndexNo=1"
	for /l %%i in (2, 1, %ImageCount%) do (
		set "ImageIndexNo=!ImageIndexNo!,%%i"
	)
 for %%i in (%ImageIndexNo%) do (
	echo. 
	dism /export-image /SourceImageFile:"%DVD%\sources\install.wim" /SourceIndex:%%i /DestinationImageFile:"%DVD%\sources\install.esd" /Compress:max /CheckIntegrity
	echo.
 )
 del "%DVD%\sources\install.wim" 
 goto :extra
::##############################################################################################################################
::Conta Index
 :GetImageCount
 for /f "tokens=2 delims=: " %%a in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim ^| findstr Index') do ( 
   set "ImageCount=%%a"
 )
 goto :eof 
::############################################################################################################################## 
::Crea cartella
 :CreateFolder 
 if not exist "%~1" md "%~1" >nul 
 goto :eof 
::##############################################################################################################################   
::Rimozione Cartella 
 :RemoveFile 
 if exist "%~1" del /f /q "%~1" >nul 
 goto :eof 
::##############################################################################################################################
::Aggiungi Componenti  
 :aggiungicomeponenti
 cls
 Title WIMToolkit Aggiungi Componenti 
 IF "%os%" equ "" ( echo Seleziona prima ^<Monta ISO^> && timeout 4 >NUL && goto :menuprincipale ) 
 echo                 Aggiungi Componenti
 echo =================================================== 
 echo           [1] Visual C++
 echo           [2] Aggiungi Driver
 echo           [3] Aggiungi file cab (lingua, aggioranmenti)
 echo.
 echo                   [X] Indietro
 echo ===================================================
 choice /C:123X /N /M "Digita un numero: " 
 if errorlevel 4 goto :menuprincipale
 if errorlevel 3 goto :cab 
 if errorlevel 2 goto :adddriver
 if errorlevel 1 goto :visualc

 :adddriver
 dism /Image:%mount% /Add-Driver /Driver:%driver% /ForceUnsigned /recurse
 dism /Image:%boot% /Add-Driver /Driver:%driver% /ForceUnsigned /recurse
 dism /Image:%winre% /Add-Driver /Driver:%driver% /ForceUnsigned /recurse
 goto :aggiungicomeponenti

 :cab
 if exist "%FileCAB%\*.esd" (
   "%Zip%" x -y "%risorcacab%" -o"%FileCAB%"
   set "esd2cab=%FileCAB%\esd2cab_CLI.cmd"
   call "%esd2cab%" goto :continuacab
   ) else (
      goto :continuacab
 )

 :continuacab
if exist "%FileCAB%\*.cab" (
   for %%f in ("%FileCAB%\*.cab") do (
      dism /english /Image:%mount% /Add-Package /PackagePath:"%%f"
      dism /english /Image:%boot% /Add-Package /PackagePath:"%%f"
   )
 ) else (
   echo Nessun file .cab trovato! && timeout 4 >NUL && goto :aggiungicomeponenti
 )

 :visualc
 echo In arrivo
 timeout 5
 goto :aggiungicomeponenti
::############################################################################################################################
::Dart
 :dart
 Risorse\7z.exe l .\%DVD%\setup.exe >.\%DVD%\version.txt 2>&1
 for /f "tokens=4 delims=. " %%i in ('findstr /i /b FileVersion .\%DVD%\version.txt') do set vermajor=%%i
 for /f "tokens=4,5 delims=. " %%i in ('findstr /i /b FileVersion .\%DVD%\version.txt') do (set majorbuildnr=%%i&set deltabuildnr=%%j)
 IF NOT DEFINED vermajor (
 echo.
 ECHO==========================================================
 echo Non trovo il setup.exe....
 ECHO==========================================================
 echo.
 pause
 exit /b
 )

 SET "Winver="
 IF %vermajor% GEQ 10240 SET "Winver=10" & SET "ISOVer=10"
 IF %vermajor% EQU 20348 SET "Winver=10" & SET "ISOVer=SRV_2022"
 IF %vermajor% EQU 22000 SET "Winver=11" & SET "ISOVer=11"
 IF %vermajor% EQU 22621 SET "Winver=11" & SET "ISOVer=11"

 IF NOT DEFINED Winver (
 echo.
 ECHO==========================================================
 echo Iso non supportata....
 ECHO==========================================================
 echo.
 pause
 exit /b
 )

 SET "BUILD="
 IF %vermajor% EQU 10240 SET "BUILD=th1"
 IF %vermajor% EQU 10586 SET "BUILD=th2"
 IF %vermajor% EQU 14393 SET "BUILD=rs1"
 IF %vermajor% EQU 15063 SET "BUILD=rs2"
 IF %vermajor% EQU 16299 SET "BUILD=rs3"
 IF %vermajor% EQU 17134 SET "BUILD=rs4"
 IF %vermajor% EQU 17763 SET "BUILD=rs5"
 IF %vermajor% EQU 18362 SET "BUILD=rs6"
 IF %vermajor% GEQ 19041 SET "BUILD=rs7"
 IF %vermajor% EQU 20348 SET "BUILD=rs8"
 IF %vermajor% EQU 22000 SET "BUILD=21h2"
 IF %vermajor% EQU 22621 SET "BUILD=22h2"

 IF NOT DEFINED BUILD (
 echo.
 ECHO==========================================================
 echo Build non supportata....
 ECHO==========================================================
 echo.
 pause
 exit /b
 )

 :AskDartWinreWIM
 SET "DARTWRE=DARTWRE1"

 :next2
 if exist "%DVD%\sources\install.wim" set WIMFILE=install.wim
 if exist "%DVD%\sources\install.esd" set WIMFILE=install.esd

 for /f "tokens=2 delims=: " %%# in ('dism.exe /english /get-wiminfo /wimfile:"%DVD%\sources\%WIMFILE%" /index:1 ^| find /i "Architecture"') do set warch=%%#
 echo %warch% is detected

 If "%warch%"=="x86" set "darch=1"
 If "%warch%"=="x64" set "darch=2"

 for /f "tokens=3 delims=: " %%m in ('dism.exe /english /Get-WimInfo /wimfile:"%DVD%\sources\%WIMFILE%" /Index:1 ^| findstr /i Build') do set b2=%%m

 IF /I "%Winver%"=="10" GOTO :Win10Lang
 IF /I "%Winver%"=="11" GOTO :Win10Lang
 IF /I "%Winver%"=="SRV_2022" GOTO :Win10Lang

 :Win10Lang
 set "IsoLang=it-IT"
 for %%i in (%IsoLang%) do if exist "%DVD%\sources\%%i\*.mui" set %%i=1
 :resume
 SET "DartLang=it-it"
 set "lang=it-it"

 for %%i in (%IsoLang%) do if defined %%i (
 for %%a in (%lang%) do if /I "%%i"=="%%a" SET "DartLang=%%a"
 )

 if not exist "Risorse\Dart_w%Winver%\Dart_w%Winver%_%DartLang%.tpk" (
 echo.
 echo Lingua %DartLang% non presente nella cartelal di DaRT 
 SET "DartLang=it-IT"
 Timeout /T 2 >nul
 )

 for %%i in (%IsoLang%) do if defined %%i (
 SET "LabelLang=%%i"
 )

 echo.
 ECHO==========================================================
 echo Preparo DaRT %ISOver% %warch%...
 ECHO==========================================================
 echo.

 :DartVer78110

 Risorse\7z x -y -o%DVD%\Dart_w%Winver% Risorse\Dart_w%Winver%\Dart_w%Winver%.tpk

 Risorse\7z x -y -o%DVD%\Dart_w%Winver%_LP Risorse\Dart_w%Winver%\Dart_w%Winver%_%DartLang%.tpk

 :DartVer10

 Risorse\7z x -y -o%DVD%\Dart_w%Winver%_DeBug Risorse\Dart_w%Winver%\DebugTools_w%Winver%_%build%.tpk

 :resume1
 IF /I "%DARTBW%"=="DARTBW1" GOTO :BootWIM_DaRT
 IF /I "%DARTBW%"=="DARTBW0" GOTO :resume3

 :BootWIM_DaRT
 echo.
 ECHO==========================================================
 echo Aggiungo DaRT %ISOver% %warch% in %warch% Boot.wim...
 ECHO==========================================================
 echo.
 %WimlibImagex% update "%DVD%\Sources\boot.wim" 2 --command="add '%DVD%\Dart_w%Winver%\%darch%\' '\'"

 %WimlibImagex% update "%DVD%\Sources\boot.wim" 2 --command="add '%DVD%\Dart_w%Winver%_LP\%darch%\' '\'"

 %WimlibImagex% update "%DVD%\Sources\boot.wim" 2 --command="add '%DVD%\Dart_w%Winver%_DeBug\%darch%\' '\'"

 :resume2
 echo.
 ECHO==========================================================
 echo Ottimizzazione %warch% Boot.wim...
 ECHO==========================================================
 echo.
 %WimlibImagex% optimize "%DVD%\Sources\boot.wim" --recompress

 :resume3
 IF /I "%DARTWRE%"=="DARTWRE1" GOTO :WinreWIM_DaRT
 IF /I "%DARTWRE%"=="DARTWRE0" GOTO :resume5

 :WinreWIM_DaRT
 echo.
 ECHO==========================================================
 echo Aggiungo DaRT %ISOver% %warch% in %warch% Winre.wim...
 ECHO==========================================================
 echo.
 %WimlibImagex% extract "%DVD%\sources\%WIMFILE%" 1 Windows\System32\Recovery\winre.wim --no-acls --dest-dir=%DVD%\Winre

 %WimlibImagex% update "%DVD%\Winre\winre.wim" 1 --command="add '%DVD%\Dart_w%Winver%\%darch%\' '\'"

 %WimlibImagex% update "%DVD%\Winre\winre.wim" 1 --command="add '%DVD%\Dart_w%Winver%_LP\%darch%\' '\'"

 IF /I "%Winver%"=="7" GOTO :resume4
 IF /I "%Winver%"=="81" GOTO :resume4

 %WimlibImagex% update "%DVD%\Winre\winre.wim" 1 --command="add '%DVD%\Dart_w%Winver%_DeBug\%darch%\' '\'"

 :resume4
 echo.
 ECHO==========================================================
 echo Ottimizzo %warch% WinRe...
 ECHO==========================================================
 echo.
 "%WimlibImagex%" optimize "%DVD%\Winre\Winre.wim" --recompress

 echo.
 ECHO==========================================================
 echo Aggiungo %warch% Winre.wim In %warch% %WIMFILE%...
 ECHO==========================================================
 echo.

for /f "tokens=3 delims=: " %%i in ('%WimlibImagex% info "%DVD%\sources\%WIMFILE%" ^| findstr /c:"Image Count"') do set images=%%i
for /L %%i in (1,1,%images%) do (
  %WimlibImagex% update "%DVD%\sources\%WIMFILE%" %%i --command="add '%DVD%\Winre\Winre.wim' '\Windows\System32\Recovery\winre.wim'" >nul
)
echo.
ECHO==========================================================
echo Ottimizzo %warch% %WIMFILE%...
ECHO==========================================================
echo.
"%WimlibImagex%" optimize "%DVD%\Sources\%WIMFILE%" --recompress
echo.
rmdir /q /s "%DVD%\Dart_w11" >NUL
rmdir /q /s "%DVD%\Dart_w11_DeBug" >NUL
rmdir /q /s "%DVD%\Dart_w11_LP" >NUL
rmdir /q /s "%DVD%\Dart_w10" >NUL
rmdir /q /s "%DVD%\Dart_w10_DeBug" >NUL
rmdir /q /s "%DVD%\Dart_w10_LP" >NUL
ECHO==========================================================
echo Fatto
ECHO==========================================================
goto :extra
::############################################################################################################################## 
::Vari Tweaks
 :disabcortana 
 reg load HKLM\TK_COMPONENTS "%mount%\Windows\System32\config\COMPONENTS" 
 reg load HKLM\TK_DEFAULT "%mount%\Windows\System32\config\default"  
 reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat" 
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 reg load HKLM\TK_SYSTEM "%mount%\Windows\System32\config\SYSTEM"   
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaceable" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaced" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI" /v "EnableCortana" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaceable" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaIsReplaced" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\AboveLock" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Experience" /v "AllowCortana" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d "3" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchSafeSearch" /t REG_DWORD /d "3" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Wow6432Node\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SOFTWARE\Policies\Wow6432Node\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f 
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana ActionUriServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\ActionUriServer.exe|Name=Block Cortana ActionUriServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f 
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana Package" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|Name=Block Cortana Package|Desc=Block Cortana Outbound UDP/TCP Traffic|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|Platform=2:6:2|Platform2=GTEQ|" /f 
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana PlacesServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\PlacesServer.exe|Name=Block Cortana PlacesServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f 
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana RemindersServer.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\RemindersServer.exe|Name=Block Cortana RemindersServer.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f 
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana RemindersShareTargetApp.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\RemindersShareTargetApp.exe|Name=Block Cortana RemindersShareTargetApp.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f 
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Cortana SearchUI.exe" /t REG_SZ /d "v2.26|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe|Name=Block Cortana SearchUI.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|" /f   
 reg unload HKLM\TK_COMPONENTS  
 reg unload HKLM\TK_DEFAULT  
 reg unload HKLM\TK_DRIVERS  
 reg unload HKLM\TK_NTUSER  
 reg unload HKLM\TK_SOFTWARE  
 reg unload HKLM\TK_SYSTEM
 for /f "tokens=2 delims=: " %%a in ('dism /Image:%mount% /Get-ProvisionedAppxPackages ^| find /I "PackageName: Microsoft.549981C3F5F10"') do ( 
    set "PackageName=%%a" 
 ) 
 if defined PackageName ( 
    dism /Image:"%mount%" /Remove-ProvisionedAppxPackage /PackageName:"!PackageName!" 
 )
 goto :tweaks

 :iconetaskbar 
 reg load HKLM\TK_COMPONENTS "%mount%\Windows\System32\config\COMPONENTS" 
 reg load HKLM\TK_DEFAULT "%mount%\Windows\System32\config\default"  
 reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat" 
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 reg load HKLM\TK_SYSTEM "%mount%\Windows\System32\config\SYSTEM"   
 Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" /v "GroupBy" /t REG_SZ /d "System.None" /f  
 Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" /v "PrimaryProperty" /t REG_SZ /d "System.Name" /f  
 Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" /v "SortByList" /t REG_SZ /d "prop:System.Name" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "ChatIcon" /t REG_DWORD /d "3" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d "2" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "HeadlinesOnboardingComplete" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DriverUpdateWizardWuSearchEnabled" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v "ConfigureStartPins" /t REG_SZ /d "{\"pinnedList\": [{}]}" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v "ConfigureStartPins_ProviderSet" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d "0" /f  
 reg unload HKLM\TK_COMPONENTS  
 reg unload HKLM\TK_DEFAULT  
 reg unload HKLM\TK_DRIVERS  
 reg unload HKLM\TK_NTUSER 
 reg unload HKLM\TK_SOFTWARE  
 reg unload HKLM\TK_SYSTEM 
 goto :tweaks 
 
 :stopupdate 
 reg load HKLM\TK_COMPONENTS "%mount%\Windows\System32\config\COMPONENTS" 
 reg load HKLM\TK_DEFAULT "%mount%\Windows\System32\config\default"  
 reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat" 
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 reg load HKLM\TK_SYSTEM "%mount%\Windows\System32\config\SYSTEM"   
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "5" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-DeviceUpdateAgent/Operational" /v "Enabled" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-WindowsUpdateClient/Operational" /v "Enabled" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d " " /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d " " /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d " " /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f 
 reg unload HKLM\TK_COMPONENTS  
 reg unload HKLM\TK_DEFAULT  
 reg unload HKLM\TK_DRIVERS  
 reg unload HKLM\TK_NTUSER 
 reg unload HKLM\TK_SOFTWARE  
 reg unload HKLM\TK_SYSTEM
 goto :tweaks

 :disabilitaspazioriservato 
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f 
 reg unload HKLM\TK_SOFTWARE   
 goto :tweaks

 :abilitaphotoviwer
 reg load HKLM\TK_COMPONENTS "%mount%\Windows\System32\config\COMPONENTS" 
 reg load HKLM\TK_DEFAULT "%mount%\Windows\System32\config\default"  
 reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat" 
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 reg load HKLM\TK_SYSTEM "%mount%\Windows\System32\config\SYSTEM"  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "emffile_.emf" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "rlefile_.rle" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v "wmffile_.wmf" /t REG_DWORD /d "0" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "GlobalAssocChangedCounter" /t REG_DWORD /d "13" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\UserChoice" /v "Hash" /t REG_SZ /d "TDU75KWAGi4=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\UserChoice" /v "Hash" /t REG_SZ /d "hAQpLYJfRYE=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\UserChoice" /v "Hash" /t REG_SZ /d "1in4hcmDrB4=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\UserChoice" /v "Hash" /t REG_SZ /d "Y5upkzp3g5E=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\UserChoice" /v "Hash" /t REG_SZ /d "ZIeqfdrNtFk=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\UserChoice" /v "Hash" /t REG_SZ /d "iVWM3EAePKw=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\UserChoice" /v "Hash" /t REG_SZ /d "Xq9gH4jXoFM=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\UserChoice" /v "Hash" /t REG_SZ /d "ahz7f/Yl09M=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\UserChoice" /v "Hash" /t REG_SZ /d "Evm7jp++AWA=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\UserChoice" /v "Hash" /t REG_SZ /d "wEj9gLqtYH4=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\UserChoice" /v "Hash" /t REG_SZ /d "/r2V12Yryig=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\OpenWithList" /v "a" /t REG_SZ /d "PhotoViewer.dll" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\OpenWithList" /v "MRUList" /t REG_SZ /d "a" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\UserChoice" /v "Hash" /t REG_SZ /d "/qcrPB0bhuI=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.bmp\UserChoice" /v "Hash" /t REG_SZ /d "rEigxhAPyos=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.bmp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.dib\UserChoice" /v "Hash" /t REG_SZ /d "R60f5QZs3Hg=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.dib\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.gif\UserChoice" /v "Hash" /t REG_SZ /d "YcQO9pssSPU=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.gif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jfif\UserChoice" /v "Hash" /t REG_SZ /d "5yjvWKb+Jns=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jfif\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpe\UserChoice" /v "Hash" /t REG_SZ /d "TujD2rCi+po=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpe\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpeg\UserChoice" /v "Hash" /t REG_SZ /d "wdZ9wQI4vW8=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpeg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpg\UserChoice" /v "Hash" /t REG_SZ /d "3xY0V0JOiFc=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jpg\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jxr\UserChoice" /v "Hash" /t REG_SZ /d "ENXEd5Uzg84=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.jxr\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.png\UserChoice" /v "Hash" /t REG_SZ /d "SPesrUKrIFE=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.png\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tif\UserChoice" /v "Hash" /t REG_SZ /d "bCXQRSAHD/I=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tif\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tiff\UserChoice" /v "Hash" /t REG_SZ /d "7F/LfjhVnes=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.tiff\UserChoice" /v "ProgId" /t REG_SZ /d "TIFImage.Document" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.wdp\UserChoice" /v "Hash" /t REG_SZ /d "tu0JqOen+Es=" /f  
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\Roaming\OpenWith\FileExts\.wdp\UserChoice" /v "ProgId" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open" /v "MuiVerb" /t REG_SZ /d "@photoviewer.dll,-3043" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\DropTarget" /v "Clsid" /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3056" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-70" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-83" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "EditFlags" /t REG_DWORD /d "65536" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "EditFlags" /t REG_DWORD /d "65536" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-71" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3058" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-122" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "EditFlags" /t REG_DWORD /d "65536" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\wmphoto.dll,-400" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f  
 Reg add "HKLM\TK_SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jxr" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f  
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".wdp" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f  
 reg unload HKLM\TK_COMPONENTS  
 reg unload HKLM\TK_DEFAULT  
 reg unload HKLM\TK_DRIVERS  
 reg unload HKLM\TK_NTUSER 
 reg unload HKLM\TK_SOFTWARE  
 reg unload HKLM\TK_SYSTEM  
 goto :tweaks 

 :inboxapp
 dism /english /Get-DefaultAppAssociations /Image:%mount% | findstr /c:"file could not be" 
 if errorlevel 1 ( 
 dism /english /Remove-DefaultAppAssociations /Image:%mount% 
 ) 
 goto :tweaks
::##############################################################################################################################
::Pulizia WIM
 :CleanupImage
 dism /Image:%mount% /Cleanup-Image /SPSuperseded /HideSP 
 dism /Image:%mount% /Cleanup-Image /StartComponentCleanup /ResetBase 
 dism /Image:%mount% /Cleanup-Image /CheckHealth 
 dism /Image:%mount% /Cleanup-Image /ScanHealth

 if "%bootmontato%" equ "si" (
 dism /Image:%boot% /Cleanup-Image /SPSuperseded /HideSP 
 dism /Image:%boot% /Cleanup-Image /StartComponentCleanup /ResetBase 
 dism /Image:%boot% /Cleanup-Image /CheckHealth
 )
 goto :puliziaimmagine
::############################################################################################################################## 
::Lista suggerita
 :suggeritilista
 if "%os%" equ "11" (
    set "internetexplorer=-" 
    set "windowsservice=-" 
    set "windowsmail=-" 
    set "openssh=-" 
    set "firstlogonoanimation=-" 
    set "internetexplorer=-" 
    set "gameexplorer=-" 
    set "lockscreen=-" 
    set "screensaver=-" 
    set "suonitemi=-" 
    set "riconoscimentovocale=-" 
    set "wallpaper=-" 
    set "windowsmediaplayer=-" 
    set "windowsphotoviewer=-" 
    set "temiwindowspersonalizzati=-" 
    set "windowstifffilter=-" 
    set "winsat=-"
    set "microsoftteam=-"
    set "assignedaccess=-" 
    set "ceip=-" 
    set "windowshelloface=-" 
    set "kerneldegging=-" 
    set "wifisense=-" 
    set "unifiedtelemetryclient=-" 
    set "picturepassword=-" 
    set "homegroup=-" 
    set "language=-" 
    set "hello=-" 
    set "kernella57=-" 
    set "mediaplayer=-" 
    set "stepsrecord=-" 
    set "tabletpc=-" 
    set "hevecvido=-" 
    set "automatedesktop=-" 
    set "rawimageextention=-" 
    set "vp9video=-" 
    set "webmediaextation=-" 
    set "webimage=-" 
    set "telemetria=-" 
    set "localizzazione=-" 
    set "tailoredexperiences=-" 
    set "wordpad=-" 
    set "clipchamp=-"
    set "onedrive=-"
    set "bingnews=-" 
    set "bingwheter=-" 
    set "gamingapp=-" 
    set "gethelp=-" 
    set "getstarted=-" 
    set "officehub=-" 
    set "microsoftsolitair=-" 
    set "microsoftpaint=-" 
    set "microsoftstickynotes=-" 
    set "microsoftpeople=-" 
    set "microsoftstore=-" 
    set "todo=-" 
    set "windowsphoto=-" 
    set "windowsallarms=-" 
    set "windowscalculator=-" 
    set "windowscamera=-" 
    set "windowscomunication=-" 
    set "feedbackhub=-" 
    set "windowsmap=-" 
    set "suondrecord=-" 
    set "windowsstore=-" 
    set "xbox=-" 
    set "yourphone=-" 
    set "zunemusic=-" 
    set "zunevideo=-" 
    set "quickassist=-" 
    set "webexperience=-"
    set "mixedrealty=-"
    set "onenote=-"
    set "wallet=-"
    set "outlook=-"
    set "heifi=-"
    set "StepsRecorder=-"
 ) else (
    set "internetexplorer=-" 
    set "windowsservice=-" 
    set "windowsmail=-" 
    set "openssh=-" 
    set "firstlogonoanimation=-" 
    set "internetexplorer=-" 
    set "gameexplorer=-" 
    set "lockscreen=-" 
    set "screensaver=-" 
    set "suonitemi=-" 
    set "riconoscimentovocale=-" 
    set "wallpaper=-" 
    set "windowsmediaplayer=-" 
    set "windowsphotoviewer=-" 
    set "temiwindowspersonalizzati=-" 
    set "windowstifffilter=-" 
    set "winsat=-"
    set "microsoftteam=-"
    set "assignedaccess=-" 
    set "ceip=-" 
    set "windowshelloface=-" 
    set "kerneldegging=-" 
    set "wifisense=-" 
    set "unifiedtelemetryclient=-" 
    set "picturepassword=-" 
    set "homegroup=-" 
    set "language=-" 
    set "hello=-" 
    set "kernella57=-" 
    set "mediaplayer=-" 
    set "stepsrecord=-" 
    set "tabletpc=-" 
    set "hevecvido=-" 
    set "automatedesktop=-" 
    set "rawimageextention=-" 
    set "vp9video=-" 
    set "webmediaextation=-" 
    set "webimage=-" 
    set "telemetria=-" 
    set "localizzazione=-" 
    set "tailoredexperiences=-" 
    set "wordpad=-" 
    set "clipchamp=-"
    set "onedrive=-"
    set "bingnews=-" 
    set "bingwheter=-" 
    set "gamingapp=-" 
    set "gethelp=-" 
    set "getstarted=-" 
    set "officehub=-" 
    set "microsoftsolitair=-" 
    set "microsoftpaint=-" 
    set "microsoftstickynotes=-" 
    set "microsoftpeople=-" 
    set "microsoftstore=-" 
    set "todo=-" 
    set "windowsphoto=-" 
    set "windowsallarms=-" 
    set "windowscalculator=-" 
    set "windowscamera=-" 
    set "windowscomunication=-" 
    set "feedbackhub=-" 
    set "windowsmap=-" 
    set "suondrecord=-" 
    set "windowsstore=-" 
    set "xbox=-" 
    set "yourphone=-" 
    set "zunemusic=-" 
    set "zunevideo=-" 
    set "quickassist=-" 
    set "webexperience=-"
    set "mixedrealty=-"
    set "onenote=-"
    set "dviewe=-"
    set "wallet=-"
 )
 goto :selezionacomponenti 
::##############################################################################################################################
::Disabilita Windows Feature
 :disabilitawindowsfeature 
 dism /Image:%mount% /Get-Features /Format:Table >%features%\Features.txt 
 echo Ho creato dentro la cartella Features il file Features.txt con elencate le Features attive\disattive 
 echo Se vuoi attivare o disattivare qualche funzionalita scrivila nei appositi txt 
 echo "AbilitaFeatures.txt" e "DisabilitaFeatures.txt" 
 choice /C:CX /N /M "Premi 'C' per continuare o premi 'X' per tornare indietro" 
 if errorlevel 2 ( 
    goto :disabilfeature 
 ) else ( 
    goto :tweaks
 )

 :disabilfeature 
 set "AbilInputFile=%features%\AbilitaFeatures.txt" 
 for /f %%i in (%AbilInputFile%) do ( 
    dism /Image:%ImagePath% /Enable-Feature /FeatureName:%%i 
 ) 
 set "DisabilInputFile=%features%\AbilitaFeatures.txt" 
 for /f %%i in (%DisabilInputFile%) do ( 
    dism /Image:%ImagePath% /Disable-Feature /FeatureName:%%i 
 )
 goto :tweaks 
::############################################################################################################################## 
::Errore ISO 
 :erroreiso 
 echo Nessun Install.wim o Install.esd trovato
 timeout 5 >NUL
 goto :menuprincipale 
::############################################################################################################################## 
::Elimina Immagine
 :DeleteImage
 IF EXIST "%DVD%\sources\install.esd" ( echo Devi prima convertire .esd in .wim && timeout 5 >Nul && goto :extra ) else ( goto :eliminaimmagine )
 :eliminaimmagine
 echo.=============================================================================== 
 echo.^| Indice ^|  Arch ^| Nome 
 echo.=============================================================================== 
 for /f "tokens=2 delims=: " %%a in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim ^| findstr Index') do ( 
    for /f "tokens=2 delims=: " %%b in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim /Index:%%a ^| findstr /i Architecture') do ( 
        for /f "tokens=* delims=:" %%c in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim /Index:%%a ^| findstr /i Name') do ( 
            set "Name=%%c" 
            if %%a equ 1 echo.^|   %%a    ^|  %%b  ^| !Name! 
            if %%a gtr 1 if %%a leq 9 echo.^|   %%a    ^|  %%b  ^| !Name! 
            if %%a gtr 9 echo.^|   %%a   ^|  %%b  ^| !Name! 
        ) 
    ) 
 ) 
 echo.
 echo.===============================================================================  
 set /p eliminaindex="Inserisci numero Indice oppure 'X' per tornare indietro: "
 if /i "%eliminaindex%" equ "X" goto :extra
 dism /Delete-Image /ImageFile:%DVD%\sources\install.wim /Index:%eliminaindex%
 goto :extra
::##############################################################################################################################
::Ottimizza WIM
 :ottimizzawim
 IF EXIST "%DVD%\sources\install.wim" (
 "%WimlibImagex%" optimize "%DVD%\sources\install.wim"
 "%WimlibImagex%" optimize "%DVD%\sources\boot.wim"
 )
 IF EXIST "%DVD%\sources\install.esd" (
 "%WimlibImagex%" optimize "%DVD%\sources\install.esd"
 "%WimlibImagex%" optimize "%DVD%\sources\boot.esd"
 )
 goto :extra
::##############################################################################################################################
::Cambio Nome e Descrizione WIM
 :nomeindicipers
 IF EXIST "%DVD%\sources\install.esd" ( echo Devi prima convertire install.esd in install.wim && timeout 5 >Nul && goto :extra ) else ( goto :connomeindicipers )
 :connomeindicipers
 echo.=============================================================================== 
 echo.^| Indice ^|  Arch ^| Nome 
 echo.=============================================================================== 
 for /f "tokens=2 delims=: " %%a in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim ^| findstr Index') do ( 
    for /f "tokens=2 delims=: " %%b in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim /Index:%%a ^| findstr /i Architecture') do ( 
        for /f "tokens=* delims=:" %%c in ('dism /English /Get-WimInfo /WimFile:%DVD%\sources\install.wim /Index:%%a ^| findstr /i Name') do ( 
            set "Name=%%c" 
            if %%a equ 1 echo.^|   %%a    ^|  %%b  ^| !Name! 
            if %%a gtr 1 if %%a leq 9 echo.^|   %%a    ^|  %%b  ^| !Name! 
            if %%a gtr 9 echo.^|   %%a   ^|  %%b  ^| !Name! 
        ) 
    ) 
 ) 
 echo. 
 set /p indice_immagine="Inserisci numero Indice oppure 'X' per tornare indietro: "
 if /i "%indice_immagine%" equ "X" goto :extra
 set /p "nuovo_nome=Scrivi il nome che vuoi dare all'indice dell'install.wim: "
 set /p "nuova_descrizione=Scrivi il nome che vuoi dare alla descrizione: "
 dism /Export-Image /SourceImageFile:"%DVD%\sources\install.wim" /SourceIndex:%indice_immagine% /DestinationImageFile:"%wimpersonali%\install_rename.wim" /DestinationName:"%nuovo_nome%"
 dism /Append-Image /ImageFile:"%DVD%\sources\install.wim" /CaptureDir:"%wimpersonali%" /Name:"%nuovo_nome%" /Description:"%nuova_descrizione%"
 del "%wimpersonali%\install_rename.wim" >Nul
 dism /Delete-Image /ImageFile:"%DVD%\sources\install.wim" /Index:"%indice_immagine%"
 goto :eof
::##############################################################################################################################
::Altri Tweaks
 :altritweaks
 cls
 title WIMToolkit Tweaks 
 echo                  TWEAKS 2
 echo ===============================================
 echo          [1] Nascondi Icona Chat
 echo          [3] Disabilita Windows Defender
 echo          [4] Disabilita Firewall
 echo          [5] Disabilita SmartScreen
 echo. 
 echo                [X] Indietro                    
 echo ===============================================
 choice /C:12345X /N /M "Digita un numero: " 
 if errorlevel 5 goto :tweaks
 if errorlevel 4 goto :disabilitasmartscreen
 if errorlevel 3 goto :disabfirewall
 if errorlevel 2 goto :disabilitadefender
 if errorlevel 1 call :nascondichaticon


 :disabilitasmartscreen
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE"
 reg load HKLM\TK_DEFAULT "%mount%\Windows\System32\config\default"  
 reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat"  
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Security Health\State" /v "AppAndBrowser_StoreAppsSmartScreenOff" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControl" /t REG_SZ /d "Anywhere" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
 reg unload HKLM\TK_NTUSER 
 reg unload HKLM\TK_DEFAULT 
 reg unload HKLM\TK_SOFTWARE
 goto :altritweaks

 :disabfirewall
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "DisableFirewall" /t REG_SZ /d "%%windir%%\System32\netsh.exe advfirewall set allprofiles state off" /f >nul 2>&1
 reg unload HKLM\TK_SOFTWARE
 goto :altritweaks

 :disabilitadefender
 reg load "HKLM\Temp" "%mount%\Windows\System32\config\COMPONENTS" 
 reg load HKLM\TK_COMPONENTS "%mount%\Windows\System32\config\COMPONENTS" 
 reg load HKLM\TK_DEFAULT "%mount%\Windows\System32\config\default"  
 reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat" 
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 reg load HKLM\TK_SYSTEM "%mount%\Windows\System32\config\SYSTEM" 
 Reg add "HKLM\TK_DEFAULT\SOFTWARE\Microsoft\Windows Security Health\State" /v "AccountProtection_MicrosoftAccount_Disconnected" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows Security Health\State" /v "AccountProtection_MicrosoftAccount_Disconnected" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtectionSource" /t REG_DWORD /d "2" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\Signature Updates" /v "FirstAuGracePeriod" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /t REG_BINARY /d "030000000000000000000000" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender" /v "RandomizeScheduleTaskTimes" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" /v "DisableAutoExclusions" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Quarantine" /v "LocalSettingOverridePurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Quarantine" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScriptScanning" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleDay" /t REG_DWORD /d "8" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "AdditionalActionTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "CriticalFailureTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d 1 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "NonCriticalTimeOut" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "AvgCPULoadFactor" /t REG_DWORD /d "10" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableArchiveScanning" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupFullScan" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupQuickScan" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableRemovableDriveScanning" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableRestorePoint" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningMappedNetworkDrivesForFullScan" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningNetworkFiles" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "PurgeItemsAfterDelay" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScanOnlyIfIdle" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScanParameters" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableUpdateOnStartupWithoutEngine" /t REG_DWORD /d 1 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleDay" /t REG_DWORD /d 8 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleTime" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateCatchupInterval" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d 0 /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReportingLocation" /t REG_MULTI_SZ /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\EventLog\System\Microsoft-Antimalware-ShieldProvider" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\EventLog\System\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\MsSecFlt" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdBoot" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdFilter" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdNisDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
 Reg add "HKLM\TK_SYSTEM\ControlSet001\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
 reg unload "HKLM\Temp" 
 reg unload HKLM\TK_COMPONENTS  
 reg unload HKLM\TK_DEFAULT  
 reg unload HKLM\TK_DRIVERS  
 reg unload HKLM\TK_NTUSER 
 reg unload HKLM\TK_SOFTWARE  
 reg unload HKLM\TK_SYSTEM 
 goto :altritweaks

 :nascondichaticon
 reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat" 
 reg load HKLM\TK_SOFTWARE "%mount%\Windows\System32\config\SOFTWARE" 
 Reg add "HKLM\TK_SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "ChatIcon" /t REG_DWORD /d "3" /f 
 Reg add "HKLM\TK_NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d "0" /f   
 reg unload HKLM\TK_NTUSER 
 reg unload HKLM\TK_SOFTWARE
 goto :altritweaks

 :taskbarsinistra
 Reg load HKLM\TK_NTUSER "%mount%\Users\Default\ntuser.dat" 
 Reg add "HKLM\TK_NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d "0" /f
 reg unload HKLM\TK_NTUSER
 goto :altritweaks
::##############################################################################################################################
::Uscita
 :exitvolontario 
 echo Pulizia WIMtoolkit, attendi.... 
 dism /quiet /unmount-image /mountdir:%mount% /discard >nul
 dism /quiet /unmount-image /mountdir:%boot% /discard >nul
 dism /quiet /unmount-image /mountdir:%winre% /discard >nul
 call :RemoveFile %mount% 
 exit 
::############################################################################################################################## 
::CreazioneUSB
:FormatUSB

setlocal

set USBDriveLetter=
set USBDriveLabel=

cls
echo.
echo.-------------------------------------------------------------------------------
echo.####Inizio Formattazione USB########################################
echo.-------------------------------------------------------------------------------
echo.
:: Show Available USB Flash Drivers.
echo.Lista USB disponibili
call :ListDisks

:: Getting USB Flash Drive Letter
set /p USBDriveLetter=Digitia la lettera della USB e premi invio : 
echo.

:: Setting USB Flash Drive Letter
set "USBDriveLetter=%USBDriveLetter%:"

:: Checking whether the Specified USB Flash Drive exist
cd /d %USBDriveLetter% 2>nul
if errorlevel 1 (
	echo.Errore selezione USB, riprova
	goto :Stop
)

:: Getting USB Flash Drive Volume Label.
set /p USBDriveLabel=Inserisci l'etichetta del volume della USB : 
echo.

:: Getting USB Boot Type (UEFI/BIOS/ALL).
choice /C:12 /N /M "Inserisci il tipo di avvio dell'unita flash USB [1=BIOS,2=BIOS/UEFI] : "
if errorlevel 2 goto :BIOS_UEFI
if errorlevel 1 goto :BIOS

:: Formatting USB Flash Drive in NTFS Format for BIOS Booting Systems.
:BIOS
	echo.
	choice /C:SN /N /M "Sei sicuro di voler formattare? [%USBDriveLetter%]? ['S'i/'N'o] : "
	if errorlevel 2 (
		echo.
		echo.Formattazione della USB [%USBDriveLetter%] cancellata...
		echo.
		echo.-------------------------------------------------------------------------------
		echo.####Fermo la formattazione della USB########################################
		echo.-------------------------------------------------------------------------------
		goto :Stop
	)
	if errorlevel 1 (
		call :FormatDisk %USBDriveLetter%, NTFS, %USBDriveLabel%
		echo.
		echo.-------------------------------------------------------------------------------
		echo.####USB Formattata correttamente########################################
		echo.-------------------------------------------------------------------------------
		goto :Stop
	)

:: Formatting USB Flash Drive in FAT32 Format for BIOS and or UEFI Booting Systems.
:BIOS_UEFI
	echo.
	choice /C:SN /N /M "Sei sicuro di voler formattare? [%USBDriveLetter%]? ['S'i/'N'o] : "
	if errorlevel 2 (
		echo.
		echo.Formattazione della USB [%USBDriveLetter%] cancellata...
		echo.
		echo.-------------------------------------------------------------------------------
		echo.####Fermo la formattazione della USB########################################
		echo.-------------------------------------------------------------------------------
		goto :Stop
	)
	if errorlevel 1 (
		call :FormatDisk %USBDriveLetter%, FAT32, %USBDriveLabel%
		echo.
		echo.-------------------------------------------------------------------------------
		echo.####USB Formattata correttamente########################################
		echo.-------------------------------------------------------------------------------
		goto :Stop
	)

:Stop
echo.
echo.===============================================================================
echo.

set USBDriveLetter=
set USBDriveLabel=

endlocal

goto :BurnUSB
::#####################################################################################################################################################################
:ListDisks

set "DiskTemp=C:"
call :RemoveFile "%DiskTemp%\DiskList.txt"
call :RemoveFile "%DiskTemp%\DiskList1.txt"

echo.list volume>> "%DiskTemp%\DiskList.txt"
diskpart /s "%DiskTemp%\DiskList.txt" >> "%DiskTemp%\DiskList1.txt"
call :RemoveFile "%DiskTemp%\DiskList.txt"
echo.>> "%DiskTemp%\DiskList.txt"

echo.===============================================================================>> "%DiskTemp%\DiskList.txt"
if "%HostUILanguage%" equ "en-US" echo.  Volume #  Letter Label      file Sys Type         Size    Status     Info>> "%DiskTemp%\DiskList.txt"
if "%HostUILanguage%" equ "fr-FR" echo.  N# volume   Ltr  Nom          Fs     Type        Taille   Statut     Info>> "%DiskTemp%\DiskList.txt"
if "%HostUILanguage%" equ "zh-CN" echo.  卷 #      盘符   标签       文件系统  类型        大小    状态       信息>> "%DiskTemp%\DiskList.txt"
if "%HostUILanguage%" equ "it-IT" echo.  Volume #  Lettera Etichetta  file Sys Tipo         Dimensione Stato     Info>> "%DiskTemp%\DiskList.txt"
echo.------------------------------------------------------------------------------->> "%DiskTemp%\DiskList.txt"
if "%HostUILanguage%" equ "en-US" findstr "Removable" "%DiskTemp%\DiskList1.txt" >> "%DiskTemp%\DiskList.txt"
if "%HostUILanguage%" equ "fr-FR" findstr "Amovible" "%DiskTemp%\DiskList1.txt" >> "%DiskTemp%\DiskList.txt"
if "%HostUILanguage%" equ "zh-CN" findstr "可移动" "%DiskTemp%\DiskList1.txt" >> "%DiskTemp%\DiskList.txt"
if "%HostUILanguage%" equ "it-IT" findstr "Rimovibile" "%DiskTemp%\DiskList1.txt" >> "%DiskTemp%\DiskList.txt"
echo.===============================================================================>> "%DiskTemp%\DiskList.txt"

type "%DiskTemp%\DiskList.txt"
call :RemoveFile "%DiskTemp%\DiskList.txt"
call :RemoveFile "%DiskTemp%\DiskList1.txt"
echo.

goto :eof

::#####################################################################################################################################################################
:FormatDisk

set "DiskTemp=C:"

:: Writing DiskPart.txt Script File.
call :RemoveFile "%DiskTemp%\DiskPart.txt"
echo.select volume ^%~1>> "%DiskTemp%\DiskPart.txt"
echo.clean>> "%DiskTemp%\DiskPart.txt"
echo.create partition primary>> "%DiskTemp%\DiskPart.txt"
echo.select partition ^1>> "%DiskTemp%\DiskPart.txt"
echo.active>> "%DiskTemp%\DiskPart.txt"
echo.format fs=%~2 quick label=%~3>> "%DiskTemp%\DiskPart.txt"
echo.exit>> "%DiskTemp%\DiskPart.txt"
echo.exit>> "%DiskTemp%\DiskPart.txt"
echo.
echo.-------------------------------------------------------------------------------
echo.####Formatto USB Flash Drive###################################################
echo.-------------------------------------------------------------------------------
echo.
:: Executing DiskPart.txt Script file With Diskpart.
echo.Formatto la usb [%~1] in %~2 Format, Please wait...
start /B /wait diskpart /s "%DiskTemp%\DiskPart.txt" >nul
echo.
echo.Formattazione USB [%~1] in %~2 Format, complete...
call :RemoveFile "%DiskTemp%\DiskPart.txt"

goto :eof
::#####################################################################################################################################################################
:BurnUSB

setlocal

set ISOFileName=
set USBDriveLetter=
echo.

if not exist "%ISO%\*.iso" (
	echo.La cartella immagine ^<ISO^> sembra vuota...
	echo.
	echo.Copia le immagini ISO nella cartella ^<ISO^>...
	goto :Stop
)

echo.-------------------------------------------------------------------------------
echo.####Avvio della masterizzazione di un'immagine ISO su USB######################
echo.-------------------------------------------------------------------------------
echo.
echo.
:: Getting ISO File Name
set /p ISOFileName=Enter the ISO File Name : 

:: Setting ISO File Name
set "ISOFileName=%ISOFileName%.iso"
echo.
echo.-------------------------------------------------------------------------------
echo.####Ottengo informazioni USB###################################################
echo.-------------------------------------------------------------------------------
echo.
:: Show Available USB Flash Drivers.
echo.Lista delle USB disponibili...
call :ListDisks

:: Getting USB Flash Drive Letter
set /p USBDriveLetter=Inserisci la lettera della USB : 

:: Setting USB Flash Drive Letter
set "USBDriveLetter=%USBDriveLetter%:"

echo.
echo.-------------------------------------------------------------------------------
echo.####Masterizzazione di immagini ISO su USB#####################################
echo.-------------------------------------------------------------------------------
echo.
echo.-------------------------------------------------------------------------------
echo.Copia del contenuto del file immagine ISO sulla USB, attendere...
echo.-------------------------------------------------------------------------------
echo.
echo.Source ISO        : %ISOFileName%
echo.Target Drive      : %USBDriveLetter%
echo.
"%Zip%" x -y "%ISO%\%ISOFileName%" -o"%USBDriveLetter%"
echo.
echo.-------------------------------------------------------------------------------
echo.####Masterizzazione di un'immagine ISO su USB completata#######################
echo.-------------------------------------------------------------------------------

:Stop
echo.
echo.===============================================================================
echo.
pause>nul|set /p=Premi un tasto per continuare...

set ISOFileName=
set USBDriveLetter=

endlocal
goto :creaiso