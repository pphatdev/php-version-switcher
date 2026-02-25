# PowerShell Execution Policy Error

## Problem

When running `phat` commands, you see this error:

```
phat : File C:\Program Files (x86)\Phat\phat.ps1 cannot be loaded. The file C:\Program Files (x86)\Phat\phat.ps1 is
not digitally signed. You cannot run this script on the current system. For more information about running scripts and
setting execution policy, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ phat
+ ~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
```

## Cause

Windows PowerShell has an execution policy that prevents unsigned scripts from running. By default, Windows blocks all scripts for security reasons.

## Solutions

### Solution 1: Set Execution Policy (Recommended)

This is the recommended approach that balances security and functionality.

**Step 1:** Open PowerShell as Administrator
- Press `Win + X` and select "Windows PowerShell (Admin)" or "Terminal (Admin)"

**Step 2:** Set the execution policy
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

When prompted, type `Y` and press Enter.

**Step 3:** Unblock the script file
```powershell
Unblock-File "C:\Program Files (x86)\Phat\phat.ps1"
```

**Step 4:** Test the installation
```powershell
phat --version
```

### Solution 2: Unblock File Only

If your execution policy is already set but the script is still blocked:

```powershell
Unblock-File "C:\Program Files (x86)\Phat\phat.ps1"
```

### Solution 3: Bypass for Current Session

If you only need to run Phat temporarily:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

This only affects the current PowerShell session and doesn't make permanent changes.

## Understanding Execution Policies

| Policy | Description |
|--------|-------------|
| **Restricted** | No scripts allowed (Windows default) |
| **RemoteSigned** | Local scripts run; downloaded scripts need signature (Recommended) |
| **Unrestricted** | All scripts run with warnings for downloaded ones |
| **Bypass** | Nothing blocked, no warnings |

## Check Current Policy

To see your current execution policy settings:

```powershell
Get-ExecutionPolicy -List
```

## Why RemoteSigned is Recommended

- **Security**: Downloaded scripts still require a digital signature
- **Functionality**: Your own local scripts (like Phat) can run without issues
- **Balance**: Provides protection against malicious downloaded scripts while allowing legitimate local development

## Related Resources

- [PowerShell Execution Policies Documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)
- [Back to Troubleshooting Index](TROUBLESHOOTING.md)
