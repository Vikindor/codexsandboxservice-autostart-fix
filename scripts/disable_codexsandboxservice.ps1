# =========================================================
# v1.0.0
# Stop the sandbox service process and switch startup to Manual
# Created by Vikindor: https://vikindor.github.io/
# Source: https://github.com/Vikindor/codexsandboxservice-autostart-fix/
# =========================================================

$ErrorActionPreference = 'Stop'
$exitCode = 0

try {
    $principal = [Security.Principal.WindowsPrincipal]::new(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'Run this script as administrator or use RUN_disable_codexsandboxservice.bat.'
    }

    $serviceName = 'CodexSandboxService.OpenAI.Codex'
    $key = "HKLM:\SYSTEM\CurrentControlSet\Services\$serviceName"

    Write-Host '[1/2] Stop the CodexSandboxService process...' -ForegroundColor Cyan
    $service = Get-CimInstance -ClassName Win32_Service -Filter "Name='$serviceName'"
    if (-not $service) {
        throw "Service is not installed: $serviceName"
    }

    if ($service.ProcessId -ne 0) {
        $process = Get-Process -Id $service.ProcessId -ErrorAction SilentlyContinue
        if ($process) {
            $process | Stop-Process -Force
            Write-Host 'OK: service process stopped.' -ForegroundColor Green
        } else {
            Write-Host 'INFO: service process has already exited.' -ForegroundColor Yellow
        }
    } else {
        Write-Host 'INFO: service process is not running.' -ForegroundColor Yellow
    }

    Write-Host '[2/2] Set Start = 3 (Manual)...' -ForegroundColor Cyan
    Set-ItemProperty -LiteralPath $key -Name Start -Type DWord -Value 3
    Write-Host 'OK: Start = 3 (Manual).' -ForegroundColor Green
    Write-Host 'Done. Codex or a package update may change this value again.'
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    $exitCode = 1
}

Read-Host 'Press ENTER to exit'
exit $exitCode
