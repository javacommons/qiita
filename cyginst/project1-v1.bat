REM URL: http://bit.ly/cyginst
REM Last Update: 2017/04/01 07:11
setlocal
set SCRIPT=%~0
for /f "delims=\ tokens=*" %%z in ("%SCRIPT%") do (
  set SCRIPT_CURRENT_DIR=%%~dpz
)


REM --- 編集するところ(ここから↓) ---
set CYG_NAME=project1
set CYG_BITS=32
set CYG_PKGS=emacs-w32,git,python2
REM --- 編集するところ(ここまで↑) ---


if "%CYG_PKGS%"=="" (
    set CYG_PKGS=bash
)
set CYG_SETUP=
if "%CYG_BITS%"=="32" (
    set CYG_SETUP=setup-x86.exe
) else if "%CYG_BITS%"=="64" (
    set CYG_SETUP=setup-x86_64.exe
) else (
    echo CYG_BITS must be 32 or 64. [Current CYG_BITS: %CYG_BITS%] Aborting!
    pause
    exit
)     
if not exist "%SCRIPT_CURRENT_DIR%%CYG_SETUP%" bitsadmin /TRANSFER "%CYG_SETUP%" "http://www.cygwin.com/%CYG_SETUP%" "%SCRIPT_CURRENT_DIR%%CYG_SETUP%"
set CYG_ROOT=%SCRIPT_CURRENT_DIR%%CYG_NAME%
set CYG_SITE=http://mirrors.kernel.org/sourceware/cygwin/
if not exist "%CYG_ROOT%\pkg" mkdir "%CYG_ROOT%\pkg"
%CYG_SETUP% -q -W --packages="%CYG_PKGS%" ^
                    --root="%CYG_ROOT%" ^
                    --local-package-dir="%CYG_ROOT%\pkg" ^
                    --site=%CYG_SITE% ^
                    --no-admin ^
                    --no-shortcuts
if exist "%CYG_ROOT%\Cygwin.bat" move "%CYG_ROOT%\Cygwin.bat" "%CYG_ROOT%\Cygwin%CYG_BITS% @%CYG_NAME%.bat"
"%CYG_ROOT%\bin\bash.exe" -c "/usr/bin/sed -i -e 's/0;[\]w[\]a/0;Cygwin%CYG_BITS% @%CYG_NAME% \\\\w\\\\a/g' -e 's/[\]u@[\]h/\\\\u@%CYG_NAME%\\(Cygwin%CYG_BITS%\\)/g' /etc/bash.bashrc"

endlocal
pause