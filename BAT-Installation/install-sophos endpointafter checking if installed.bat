IF EXIST "c:\SophosInstallSucceeded.txt" GOTO END

@echo off
 SET MCS_ENDPOINT=Sophos\Management Communications System\Endpoint\McsClient.exe
 IF "%PROCESSOR_ARCHITECTURE%" == "x86" GOTO X86_PROG
 IF NOT EXIST "%ProgramFiles(x86)%\%MCS_ENDPOINT%" GOTO INSTALL
 exit /b 0

 :X86_PROG
 IF NOT EXIST "%ProgramFiles%\%MCS_ENDPOINT%" GOTO INSTALL
 exit /b 0

 :INSTALL
 pushd "\\<SERVER LOCATION>\Sophos\Anti Virus\"
 SophosSetup.exe --quiet --nocompetitorremoval
 Popd

:FILECOPY
copy "\\<SERVER LOCATION>\Sophos\Anti Virus\SophosInstallSucceeded.txt" C:\

:END
Exit