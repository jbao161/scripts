
echo on
::  drag drop multiple files or folders
for %%f in (%*) do ( 
::  if object is a folder, set it as current path
if exist "%%f\" (
    cd %%f
:: for all files in all subfolders
    for /R %%# in (*.gif) do ffmpeg -i "%%#" "%%~dpn#.mp4"
) else (
    if "%%~xf"==".gif" (ffmpeg -i %%f "%%~dpnf.mp4")
))

pause