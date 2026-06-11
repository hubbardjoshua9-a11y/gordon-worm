@echo off
title adopting gordon...
rem Registers Gordon's daily 9am wake-up from wherever this folder lives,
rem then wakes him once so you two can meet.

schtasks /create /tn "Wake Gordon" /tr "wscript.exe \"%~dp0wake-gordon-silent.vbs\"" /sc daily /st 09:00 /f >nul 2>&1
if errorlevel 1 (
    echo.
    echo adoption failed. try right-click, "run as administrator".
    pause
    exit /b 1
)
echo.
echo gordon is adopted. he will wake up every morning at 9:00.
echo waking him now so he can meet you...
wscript.exe "%~dp0wake-gordon-silent.vbs"
ping -n 4 127.0.0.1 >nul
