@echo on
title Shutdown Input

set /a hours=1
set /a secs=%hours%*60*60

shutdown.exe -a & shutdown.exe -s -t %secs% /d p:0:0 /c "System will shutdown after %hours% hours"

pause