@echo on
title Shutdown Input

set /p hours=Enter number of hours to wait until shutdown:
set /a secs=%hours%*60*60

shutdown.exe -a & shutdown.exe -s -t %secs% /d p:4:1 /c "System will shutdown after %hours% hours"

pause
