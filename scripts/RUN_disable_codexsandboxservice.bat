@echo off
:: =========================================================
:: v1.0.0
:: Runs disable_codexsandboxservice.ps1 with elevation and correct host
:: Created by Vikindor: https://vikindor.github.io/
:: Source: https://github.com/Vikindor/codexsandboxservice-autostart-fix/
:: =========================================================

setlocal
set "SCRIPT=%~dp0disable_codexsandboxservice.ps1"

set "PSHOST="
for /f "delims=" %%I in ('where pwsh.exe 2^>nul') do if not defined PSHOST set "PSHOST=%%I"
if not defined PSHOST if exist "%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe" set "PSHOST=%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe"
if not defined PSHOST set "PSHOST=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

"%PSHOST%" -NoProfile -Command "$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()); if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit 0 } else { exit 1 }" >nul 2>&1
if errorlevel 1 goto :elevate

"%PSHOST%" -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"
set "EXIT_CODE=%ERRORLEVEL%"
endlocal & exit /b %EXIT_CODE%

:elevate
echo Requesting administrative privileges...
"%PSHOST%" -NoProfile -Command "$ErrorActionPreference = 'Stop'; try { $quotedScript = [char]34 + $env:SCRIPT + [char]34; $process = Start-Process -FilePath $env:PSHOST -Verb RunAs -WindowStyle Normal -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $quotedScript) -Wait -PassThru; exit $process.ExitCode } catch { Write-Error $_; exit 1 }"
set "EXIT_CODE=%ERRORLEVEL%"
endlocal & exit /b %EXIT_CODE%
