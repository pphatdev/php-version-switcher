# Download Fails

## Problem

Running `phat install [version]` fails to download PHP.

## Common Causes

1. No internet connection
2. PHP version doesn't exist
3. Network firewall blocking the download
4. Windows PHP download site is temporarily down

## Solutions

### Solution 1: Check Your Internet Connection

Verify you can access the internet:

```powershell
Test-NetConnection windows.php.net -Port 443
```

If this fails, check your network connection.

### Solution 2: Verify the Version Exists

Check what versions are actually available:

```powershell
phat list --php --global
```

This fetches the current list of stable PHP versions from windows.php.net.

### Solution 3: Try a Different Version

The version you want might not be available for Windows. Try a different version from the list:

```powershell
# Example: if 8.2.27 doesn't exist, try 8.2.26
phat install 8.2.26
```

### Solution 4: Manual Download

If automatic download fails, you can download manually:

1. Visit [PHP for Windows Downloads](https://windows.php.net/download/)
2. Download the **Thread Safe (TS) x64** version
3. Extract to `C:\xampp\php[version]`
   - Example: `C:\xampp\php8.2.27`
4. Run `phat list` to verify it's detected

### Solution 5: Check Firewall/Antivirus

Your firewall or antivirus might be blocking downloads:

1. Temporarily disable your antivirus
2. Try the download again
3. Re-enable your antivirus after installation

### Solution 6: Use Archives

Older PHP versions are in the archives. Check:
- [PHP Release Archives](https://windows.php.net/downloads/releases/archives/)

## Understanding Version Availability

### Thread Safe vs Non-Thread Safe

⚠️ **Important**: Phat only downloads **Thread Safe (TS)** versions because they're required for Apache module mode.

### Compiler Versions

PHP for Windows comes in different compiler versions:
- **VS17** (Visual Studio 2022) - PHP 8.2+
- **VS16** (Visual Studio 2019) - PHP 7.4 - 8.1
- **VS15** (Visual Studio 2017) - Older PHP versions

Phat automatically tries the correct compiler version for your PHP version.

## Checking Download URL

If you want to verify the download URL manually:

For PHP 8.2.27, the URL would be:
```
https://windows.php.net/downloads/releases/php-8.2.27-Win32-vs17-x64.zip
```

Try accessing this in your browser to see if it exists.

## Error Messages

### "Could not find PHP X.X.X for download"

This means the exact version doesn't exist on windows.php.net. Try:
1. Check available versions: `phat list --php --global`
2. Install a version from that list

### "Download failed - Connection refused"

Network issue. Check:
1. Internet connection
2. Firewall settings
3. Proxy settings (if applicable)

### "Extraction failed"

The downloaded file might be corrupted:
1. Delete the temp file: `C:\Users\[YourUser]\AppData\Local\Temp\phat_download\`
2. Try downloading again

## Manual Installation Steps

If all else fails, install manually:

1. Download PHP from [windows.php.net](https://windows.php.net/download/)
   - Choose: **Thread Safe (TS) x64**

2. Extract to XAMPP directory:
   ```
   C:\xampp\php8.2.27
   ```

3. Copy `php.ini-development` to `php.ini`:
   ```powershell
   Copy-Item "C:\xampp\php8.2.27\php.ini-development" "C:\xampp\php8.2.27\php.ini"
   ```

4. Switch to the new version:
   ```powershell
   phat switch 8.2.27
   ```

## Related Resources

- [PHP Windows Downloads](https://windows.php.net/download/)
- [PHP Release Archives](https://windows.php.net/downloads/releases/archives/)
- [Back to Troubleshooting Index](TROUBLESHOOTING.md)
