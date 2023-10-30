@echo off
for /L %%N in (1,1,400) do (
  echo Deleting driver OEM%%N.INF
  pnputil /d OEM%%N.INF
)