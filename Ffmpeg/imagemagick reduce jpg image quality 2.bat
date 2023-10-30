:: using imagemagick
:: for %%# IN (*.jpg) DO magick -quality 70 "%%#" "%%#"
:: This batch file will reduce a .jpg image (or all .jpg images in all subdirectories of a folder) to a maximum resolution of MAXWIDTH x MAXHEIGHT
:: then if the file size (in bytes) is greater than MINBYTESIZE, it will reduce the quality to QUALITY percent.


set MINBYTESIZE=501001
set MAXWIDTH=2560
set MAXHEIGHT=1920
set QUALITY=70

@echo off
set /a filesresized=0
set /a filesreduced=0
::  drag drop multiple files or folders
for %%f in (%*) do ( 
::  if object is a folder, set it as current path
if exist "%%f\" (
    cd %%f
:: for each file in folder, if jpg and resolution too high, lower resolution
    for /R %%# IN (*.jpg) do (call :reducesize "%%~f#")
:: if filesize is still too big, reduce the image quality
:: second loop required to update the filesize after resolution changes
    for /R %%# IN (*.jpg) do (call :reducequality "%%~z#" "%MINBYTESIZE%" "%%~f#")
)  else (
:: if object is a file, 
    if "%%~xf"==".jpg" (call :reducesize "%%~ff")
    if "%%~xf"==".jpg" (call :reducequality %%~zf %MINBYTESIZE% "%%~ff")
) 
)
echo Files resized: %filesresized%. Files reduced in quality: %filesreduced%.
pause
EXIT /B

:incrementcounter
set /a %~1 +=1
EXIT /B

:: reducequality
:: if jpg and greater than min size, reduce its quality
:: original command
:: if %%~z# GTR %MINBYTESIZE% (magick -$QUALITY$ -verbose "%%~f#" "%%~f#"
:: usage
:: call :reducequality %%~z# %MINBYTESIZE% %%~f#

:reducesize
for /f "tokens=1-2" %%i in ('magick identify -ping -format "%%w %%h" "%~1"') do set W=%%i & set H=%%j
set varOR=true
if not %W% GTR %MAXWIDTH% if not %H% GTR %MAXHEIGHT% (set varOR=false)
if "%varOR%"=="true" (magick mogrify -verbose -resize "%MAXWIDTH%x%MAXHEIGHT%>" "%~1"
call :incrementcounter filesresized)
EXIT /B

:reducequality
if %~1 GTR %~2 (magick -quality %QUALITY% -verbose "%~3" "%~3" 
call :incrementcounter filesreduced)
EXIT /B

