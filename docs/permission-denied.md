# Permission Denied When Installing

## Problem

Installation fails with permission errors when trying to install a new PHP version.

## Cause

Installing PHP versions requires write access to the XAMPP directory (`C:\xampp`), which typically requires administrator privileges.

## Solution

Run PowerShell as Administrator before installing PHP versions.

### How to Run PowerShell as Administrator

**Method 1: Start Menu**
1. Press the `Windows` key
2. Type "PowerShell"
3. Right-click on "Windows PowerShell"
4. Select "Run as Administrator"

**Method 2: Win + X Menu**
1. Press `Win + X`
2. Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

**Method 3: From File Explorer**
1. Open File Explorer
2. Navigate to any folder
3. Click "File" → "Open Windows PowerShell" → "Open Windows PowerShell as administrator"

### After Opening as Administrator

Once you have an administrator PowerShell window, run your install command:

```powershell
phat install 8.2.27
```

## Verifying Administrator Access

To check if you're running as administrator, look for "Administrator" in the PowerShell window title:

```
Administrator: Windows PowerShell
```

Or run this command:

```powershell
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
```

This should return `True` if you have administrator privileges.

## Alternative: Run Specific Command as Admin

If you don't want to open a new admin window, you can run a specific command with admin rights:

1. Right-click on PowerShell/Terminal icon
2. Select "Run as Administrator"
3. In the admin prompt, run: `phat install [version]`

## Common Permission Error Messages

You might see errors like:
- "Access to the path is denied"
- "UnauthorizedAccessException"
- "Administrator rights required"

All of these indicate you need to run PowerShell as Administrator.

## Related Resources

- [Windows User Account Control](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/user-account-control/)
- [Back to Troubleshooting Index](TROUBLESHOOTING.md)
