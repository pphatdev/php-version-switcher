# Troubleshooting Guide

This guide covers common issues you might encounter when using Phat. Each issue has its own detailed documentation page.

## Quick Navigation

### 🔒 Security & Permissions
- **[PowerShell Execution Policy Error](powershell-execution-policy.md)** - "File cannot be loaded. The file is not digitally signed"
- **[Permission Denied When Installing](permission-denied.md)** - Access denied errors during installation

### ⚙️ Installation & Setup
- **[Download Fails](download-fails.md)** - Issues downloading PHP versions
- **[Git Bash / MINGW64 Compatibility](git-bash-compatibility.md)** - "command not found" in bash terminals

### 🔧 Operation Issues
- **[Apache Won't Start After Switching](apache-wont-start.md)** - Apache fails to start after changing PHP versions
- **[PHP Version Not Found](php-version-not-found.md)** - Version not detected even though it's installed

---

## Most Common Issues

### 1. PowerShell Execution Policy Error

**Symptoms:** 
```
phat : File C:\Program Files (x86)\Phat\phat.ps1 cannot be loaded. The file is not digitally signed.
```

**Quick Fix:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Unblock-File "C:\Program Files (x86)\Phat\phat.ps1"
```

➡️ **[Full solution guide](powershell-execution-policy.md)**

---

### 2. Command Not Found in Git Bash

**Symptoms:**
```bash
$ phat
bash: phat: command not found
```

**Quick Fix:** Use PowerShell or CMD instead, or add bash alias:
```bash
phat() {
    powershell.exe -ExecutionPolicy Bypass -File "C:/Program Files (x86)/Phat/phat.ps1" "$@"
}
```

➡️ **[Full solution guide](git-bash-compatibility.md)**

---

### 3. Permission Denied When Installing

**Symptoms:** Access denied errors during `phat install`

**Quick Fix:** Run PowerShell as Administrator

➡️ **[Full solution guide](permission-denied.md)**

---

## Getting Help

If you're still experiencing issues after checking the guides above:

1. Check the [README.md](../README.md) for usage instructions
2. Verify your XAMPP installation is at `C:\xampp`
3. Run `phat whereami` to verify installation paths
4. Open an issue on GitHub with:
   - The exact error message
   - Output of `phat whereami`
   - Output of `Get-ExecutionPolicy -List` (if PowerShell issue)
   - Your Windows version

## Diagnostic Commands

Run these commands to gather diagnostic information:

```powershell
# Check Phat installation
phat whereami

# Check PHP versions
phat list

# Check PowerShell execution policy
Get-ExecutionPolicy -List

# Check if running as administrator
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
```

## Related Resources

- [PowerShell Execution Policies Documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)
- [XAMPP Documentation](https://www.apachefriends.org/docs/)
- [PHP Windows Downloads](https://windows.php.net/download/)

