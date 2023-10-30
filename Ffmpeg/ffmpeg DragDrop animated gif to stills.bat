@echo on
FOR /F "tokens=*" %%G IN (%*) DO ffmpeg -i "%%G" -vsync 0 "%%~nG%%d.jpg"
pause

