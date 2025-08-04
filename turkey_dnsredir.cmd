@ECHO OFF
TITLE GoodbyeDPI Turkey DNS Redirector

REM
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrator privileges confirmed.
    goto :main
) else (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:main
PUSHD "%~dp0"
set _arch=x86
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set _arch=x86_64)
IF DEFINED PROCESSOR_ARCHITEW6432 (set _arch=x86_64)
PUSHD "%_arch%"

echo.
echo What would you like to do?
echo 1. Start GoodbyeDPI
echo 2. Stop GoodbyeDPI (if running)
echo.
set /p choice="Enter your choice (1/2): "

if /i "%choice%"=="2" (
    echo Stopping GoodbyeDPI...
    taskkill /f /im goodbyedpi.exe >nul 2>&1
    if %errorLevel% == 0 (
        echo GoodbyeDPI has been stopped successfully!
    ) else (
        echo GoodbyeDPI was not running.
    )
    echo This window will close automatically in 1 second...
    timeout /t 1 /nobreak >nul
    goto :end
)

echo.
set /p minimize="Do you want to hide the GoodbyeDPI window completely? (y/n): "

if /i "%minimize%"=="y" (
    echo Starting GoodbyeDPI in hidden mode...
    powershell -Command "Start-Process 'goodbyedpi.exe' -ArgumentList '-5 --set-ttl 5 --dns-addr 77.88.8.8 --dns-port 1253 --dnsv6-addr 2a02:6b8::feed:0ff --dnsv6-port 1253' -WindowStyle Hidden"
) else (
    echo Starting GoodbyeDPI in normal window mode...
    start "" goodbyedpi.exe -5 --set-ttl 5 --dns-addr 77.88.8.8 --dns-port 1253 --dnsv6-addr 2a02:6b8::feed:0ff --dnsv6-port 1253
)

echo.
echo GoodbyeDPI has been started successfully!
echo.
echo This window will close automatically in 1 second...
timeout /t 1 /nobreak >nul

POPD
POPD

:end
