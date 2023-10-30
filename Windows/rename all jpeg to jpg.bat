echo on
::  drag drop multiple files or folders
for %%f in (%*) do ( 
::  if object is a folder, set it as current path
if exist "%%f\" (
    cd %%f
:: for all files in all subfolders, if .jpeg rename it to .jpg
    for /R %%# in (*.jpeg) do move "%%#" "%%~dpn#.jpg"
) else (
    if "%%~xf"==".jpeg" (move %%f "%%~dpnf.jpg")
))

pause
