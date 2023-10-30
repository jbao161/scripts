:: usage: drag drop a text file with a list of filenames (e.g. copied as path from search result in explorer)
@echo off
if "%~x1" == ".txt" ( For /f "delims=" %%a in ('Type "%~1"') do ( call :ffmpegConvert %%a)
) else ( if "%~x1" == ".gif" (call :ffmpegConvert "%~1"))
pause
EXIT /B

:ffmpegConvert
ffmpeg -y -i "%~1" -filter_complex "fps=10,scale=iw:ih:flags=lanczos, split [o1] [o2];[o1] palettegen=stats_mode=diff [p]; [o2] fifo [o3];[o3] [p] paletteuse=dither=floyd_steinberg" "%~dpn1c.gif" 
Exit /B