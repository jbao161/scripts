@echo on
ffmpeg -i "%~1" -b:a 128k -vn "%~1.opus" 