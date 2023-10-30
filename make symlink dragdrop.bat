::  drag drop multiple files or folders
:: use on objects located in other hard drives to make them appear as if they exist on C drive
for %%f in (%*) do ( 
	mklink /D "C:%%~pnxf" %%f
)
pause