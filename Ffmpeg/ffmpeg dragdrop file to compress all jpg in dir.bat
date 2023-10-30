mkdir processed
for %%F in (*.jpg) do (
  
    ffmpeg -i "%%F" -q:v 10 "processed\%%F"
)