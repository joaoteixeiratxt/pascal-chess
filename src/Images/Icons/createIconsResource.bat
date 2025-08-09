setlocal EnableDelayedExpansion

set "RC_FILE=Icons.rc"
set "RES_FILE=Icons.res"

if exist "%RC_FILE%" del "%RC_FILE%"
if exist "%RES_FILE%" del "%RES_FILE%"

for %%F in (*.png, *.gif) do (
    set "NAME=%%~nF"
    echo !NAME! RCDATA "%%F" >> "%RC_FILE%"
)

brcc32 -fo "%RES_FILE%" "%RC_FILE%"

endlocal
