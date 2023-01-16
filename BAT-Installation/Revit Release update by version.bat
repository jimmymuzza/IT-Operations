IF NOT EXIST "C:\Autodesk\installed.txt" goto CHECK goto END

:CHECK IF EXIST "C:\Program Files\Autodesk\Revit Architecture 2016" GOTO REVITRAINSTALL
IF EXIST "C:\Program Files\Autodesk\Revit 2016" GOTO REVITBDSINSTALL GOTO END

:REVITRAINSTALL
\\<DFS LOCATION>\Autodesk\RevitReleaseUpdates\RA_2016_R2\Autodesk_Revit_Architecture_2016_R2-x64_UPD5.msp /passive /norestart
goto FILECOPY

:REVITBDSINSTALL

\\<DFS LOCATION>\Autodesk\RevitReleaseUpdates\RBDS_2016_R2\Autodesk_Revit_2016_R2-x64_UPD5.msp /passive /norestart
goto FILECOPY

:FILECOPY copy "<DFS LOCATION>\Autodesk\RevitReleaseUpdates\RA_2016_R2\Installed.txt" C:\autodesk
:END
