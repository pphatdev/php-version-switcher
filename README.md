# Phat - XAMPP PHP Version Switcher

A simple yet powerful CLI tool to manage multiple PHP versions in XAMPP on Windows.

[![Release](https://github.com/pphatdev/php-version-switcher/actions/workflows/release.yml/badge.svg)](https://github.com/pphatdev/php-version-switcher/actions/workflows/release.yml)

## Features

- 🔄 Switch between PHP versions instantly
- 📦 Download and install new PHP versions automatically
- 📋 List all installed PHP versions (local)
- 🌐 Fetch available stable PHP versions from PHP.net (global)
- ⚡ Automatic Apache configuration updates
- 🛡️ Safe backups before switching

## Setup

### Option 1: Install from MSI (Recommended)

Download the latest MSI installer from [Releases](https://github.com/pphatdev/php-version-switcher/releases) and run it. The installer will automatically add `phat` to your PATH.

### Option 2: Manual Installation

1. Clone or download from [GitHub](https://github.com/pphatdev/php-version-switcher):

   ```bash
   git clone https://github.com/pphatdev/php-version-switcher.git
   ```

2. Add the folder to your system **PATH**:

   > Settings → System → About → Advanced system settings → Environment Variables → Path → New

   Add the full path to where you cloned/extracted the files.

3. Open a **new** terminal and run:
   ```bash
   phat help
   ```

## Commands

### Show version

```bash
phat -v
# or
phat --version
```

Displays the current Phat version.

### List installed versions

```bash
phat list
# or explicitly list local versions
phat list --php --local
```

Output example:

```
  Installed PHP versions:
  * 7.4.33 (active, php7)
    8.0.30 (8.0.30)
    8.2.27 (8.2.27)
```

### List available PHP versions globally

```bash
phat list --php --global
```

This fetches the latest stable PHP versions available from [windows.php.net](https://windows.php.net/downloads/releases/) (Thread-Safe x64 builds).

Output example:

```
  Fetching available PHP versions from windows.php.net...

  Available stable PHP versions (Thread-Safe x64):

  PHP 8.3:
    8.3.15
    8.3.14
    8.3.13

  PHP 8.2:
    8.2.27
    8.2.26

  PHP 8.1:
    8.1.31
    8.1.30

  To install a version: phat install <version>
```

### Show current version

```bash
phat current
```

Displays the currently active PHP version in XAMPP.

### Switch PHP version

```bash
phat switch 8.0.30
# or use the alias
phat use 8.0.30
```

This will:

1. Stop Apache
2. Backup current `php/` → `php{version}/` (e.g., `php7.4.33/`)
3. Rename `php{target}/` → `php/`
4. Update Apache config (`httpd-xampp.conf`)
5. Start Apache

### Download & install a new PHP version

```bash
phat install 8.3.6
```

Downloads the **thread-safe x64** build from [windows.php.net](https://windows.php.net/downloads/releases/) and extracts it to `C:\xampp\php8.3.6\`.

After installing, switch to it:

```bash
phat switch 8.3.6
```

### Help

```bash
phat help
```

Shows all available commands with examples.

## How It Works

| Component         | Description                                                                                    |
| ----------------- | ---------------------------------------------------------------------------------------------- |
| **Directories**   | PHP versions are stored as `C:\xampp\php{version}\`. The active one is always `C:\xampp\php\`. |
| **Apache config** | `httpd-xampp.conf` is updated to load the correct `php7apache2_4.dll` or `php8apache2_4.dll`.  |
| **Module name**   | PHP 7.x uses `php7_module`, PHP 8.x uses `php_module` (XAMPP convention).                      |
| **Backup**        | A backup of `httpd-xampp.conf.bak` is created on first switch.                                 |
| **Services**      | Apache is automatically stopped before switching and restarted after configuration updates.    |

## Requirements

- **Windows 10/11** - Required for PowerShell support
- **XAMPP** - Installed at `C:\xampp` (default location)
- **PowerShell 5.1+** - Pre-installed on Windows 10/11
- **.NET SDK 6.0+** - Only needed for building the MSI installer

## Building the MSI Installer

If you want to build the installer from source:

1. Install the [.NET SDK 6.0+](https://dotnet.microsoft.com/download)

2. Build the MSI:

   ```powershell
   dotnet build ./installer/Phat.wixproj -c Release
   ```

3. The MSI will be created in `installer\bin\Release\`

To specify a custom version:

```powershell
dotnet build ./installer/Phat.wixproj -c Release -p:ProductVersion=1.0.0
```

## Troubleshooting

### Permission Errors

Run your terminal as **Administrator** if you encounter permission errors when switching PHP versions.

### Apache Won't Start

1. Check Apache error logs at `C:\xampp\apache\logs\error.log`
2. Ensure the correct PHP DLL files exist in the PHP directory
3. Verify `httpd-xampp.conf` has the correct PHP module configuration

### VHost Warnings

Apache virtual host warnings (e.g., `Could not resolve host name`) are unrelated to PHP switching — they come from your virtual host configuration in `httpd-vhosts.conf`.

## Contributing

Contributions are welcome! Feel free to:

- Report bugs and issues
- Suggest new features
- Submit pull requests

## Support

If you find this tool helpful, please consider:

- ⭐ Starring the repository
- 🐛 Reporting bugs
- 📝 Improving documentation

## License

MIT © [pphatdev](https://github.com/pphatdev)

---

**Made with ❤️ by [pphatdev](https://github.com/pphatdev)**

