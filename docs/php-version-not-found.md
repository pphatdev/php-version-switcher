# PHP Version Not Found

## Problem

Running `phat switch [version]` says the version isn't found even though you believe it's installed.

## Cause

Phat looks for PHP installations using a specific naming convention. If the folder name doesn't match the expected pattern, Phat won't recognize it.

## Solution

Make sure the PHP folder is named correctly. Phat looks for folders named `php[version]`, for example:

### Correct Naming Examples

✅ **Correct:**
- `C:\xampp\php7.4.33`
- `C:\xampp\php8.2.27`
- `C:\xampp\php8.3.15`
- `C:\xampp\php8.1.0`

❌ **Incorrect:**
- `C:\xampp\php-7.4.33` (contains dash)
- `C:\xampp\PHP7.4.33` (uppercase PHP)
- `C:\xampp\php_7.4.33` (contains underscore)
- `C:\xampp\php-7.4` (incomplete version)

### Active PHP Version

The currently active version should be in a folder named exactly:
```
C:\xampp\php
```

## Checking Installed Versions

List all recognized PHP versions:

```powershell
phat list
```

This will show which versions Phat can detect.

## Renaming Folders

If your folder is named incorrectly:

1. Stop Apache if it's running
2. Rename the folder to match the correct pattern
3. Run `phat list` to verify Phat can now see it

### Example

If you have `C:\xampp\php-8.2.27`, rename it to:
```
C:\xampp\php8.2.27
```

## Verification

After renaming, verify the version is detected:

```powershell
phat list
```

You should see your version in the output.

## Related Resources

- [Back to Troubleshooting Index](TROUBLESHOOTING.md)
