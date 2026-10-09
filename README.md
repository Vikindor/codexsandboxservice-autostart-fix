<h1 align="center">
Codex Sandbox Service Autostart Fix
</h1>

A PowerShell script that stops the Windows Codex sandbox service process and switches its startup type to **Manual**.

## ✨ What it does

1. Finds the process associated with `CodexSandboxService.OpenAI.Codex` and forcibly stops it if running.
2. Sets the DWORD value `Start` to `3` under:

   ```text
   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CodexSandboxService.OpenAI.Codex
   ```

`Start=2` means Automatic; `Start=3` means Manual. Manual startup still allows the service to be started on demand.

The script does NOT uninstall Codex, change registry permissions, create scheduled tasks, or block updates.

## 🧩 Requirements

- Windows with `CodexSandboxService.OpenAI.Codex` installed.
- <a href="https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows" target="_blank" rel="noopener noreferrer">PowerShell</a> **5.1+** or **7+ (recommended)**
- **Administrator rights**

## 📁 Files

| File | Description |
| --- | --- |
| [scripts/disable_codexsandboxservice.ps1](scripts/disable_codexsandboxservice.ps1) | Stops the service process and sets `Start=3`. |
| [scripts/RUN_disable_codexsandboxservice.bat](scripts/RUN_disable_codexsandboxservice.bat) | Requests administrator rights and runs the PowerShell script. |

Keep the `.bat` and `.ps1` files together. The launcher resolves the script relative to its own location.

## ❗ Notes

- Codex, Windows package registration, or an application update may change `Start` back to `2`. The script applies the setting once; it does not enforce it persistently. Run it again if needed.
