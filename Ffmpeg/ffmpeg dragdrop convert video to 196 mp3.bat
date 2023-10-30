@echo on
ffmpeg -i "%~1" -b:a 196k -vn "%~1.mp3" 