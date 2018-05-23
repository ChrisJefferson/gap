if defined PROGRAMFILES(X86) (
    echo 64-bit sytem detected
) else (
    echo 32-bit sytem detected
)

set CYGWIN=nodosfilewarning
set LANG=en_US.UTF-8
set HOME=%HOMEDRIVE%%HOMEPATH%


REM Get the location of the bat file
set BATPATH=%~dp0

set GAPDIR=%BATPATH%gap

if NOT exist "%GAPDIR%\gap.exe" (
    echo "%GAPDIR%\gap.exe missing"
    timeout 10
)

echo %GAPDIR%
set PATH=%GAPDIR%:%PATH%
cd %HOME%

set TERMINFO=%GAPDIR%/terminfo

cd %GAPDIR%
REM Use cygpath to convert the location of GAP into a Cygwin path

for /f %%i in ('cygpath.exe -u  -a "%GAPDIR%"') do set CYGDIR=%%i

echo %CYGDIR%

"%GAPDIR%\mintty.exe" --hold start -s 120,40 "%CYGDIR%/gap.exe" %*

timeout 150
