# Apache Won't Start After Switching

## Problem

Apache service fails to start after switching PHP versions.

## Cause

Apache processes may still be running in the background, or there might be configuration issues with the new PHP version.

## Solutions

### Step 1: Check for Running Apache Processes

```powershell
Get-Process -Name httpd -ErrorAction SilentlyContinue
```

### Step 2: Kill Any Remaining Apache Processes

```powershell
Get-Process -Name httpd | Stop-Process -Force
```

### Step 3: Try Switching Again

```powershell
phat switch [version]
```

## Additional Troubleshooting

### Check Apache Error Logs

Look for detailed error messages in:

```
C:\xampp\apache\logs\error.log
```

### Verify PHP DLL Files

Ensure the correct PHP DLL files exist in the PHP directory:
- For PHP 7.x: `php7ts.dll` and `php7apache2_4.dll`
- For PHP 8.x: `php8ts.dll` and `php8apache2_4.dll`

### Verify Apache Configuration

Check that `httpd-xampp.conf` has the correct PHP module configuration:

```
C:\xampp\apache\conf\extra\httpd-xampp.conf
```

Look for lines like:
```apache
LoadFile "C:/xampp/php/php8ts.dll"
LoadModule php_module "C:/xampp/php/php8apache2_4.dll"
```

## Manual Apache Control

If automatic switching fails, you can manually control Apache:

**Stop Apache:**
```powershell
C:\xampp\apache_stop.bat
```

**Start Apache:**
```powershell
C:\xampp\apache_start.bat
```

## Related Resources

- [XAMPP Documentation](https://www.apachefriends.org/docs/)
- [Back to Troubleshooting Index](TROUBLESHOOTING.md)
