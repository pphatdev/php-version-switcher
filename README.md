# Phat - XAMPP PHP Version Switcher

A CLI tool to manage multiple PHP versions in XAMPP on Windows.

## Setup

1. Clone or download from [GitHub](https://github.com/pphatdev/php-version-switcher):

   ```bash
   git clone https://github.com/pphatdev/php-version-switcher.git
   ```

2. Add the folder to your system **PATH**:

   > Settings → System → About → Advanced system settings → Environment Variables → Path → New

   Add the full path to where you cloned/extracted the files.

3. Open a **new** terminal and run:
   ```
   phat help
   ```

## Commands

### List installed versions

```bash
phat list
```

Output:

```
  Installed PHP versions:
  * 7.4.33 (active, php7)
    8.0.30 (8.0.30)
    8.2.27 (8.2.27)
```

### Switch PHP version

```bash
phat switch 8.0.30
```

This will:

1. Stop Apache
2. Backup current `php/` → `php7.4.33/`
3. Rename `php8.0.30/` → `php/`
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

## How it works

| Step              | What happens                                                                                   |
| ----------------- | ---------------------------------------------------------------------------------------------- |
| **Directories**   | PHP versions are stored as `C:\xampp\php{version}\`. The active one is always `C:\xampp\php\`. |
| **Apache config** | `httpd-xampp.conf` is updated to load the correct `php7apache2_4.dll` or `php8apache2_4.dll`.  |
| **Module name**   | PHP 7.x uses `php7_module`, PHP 8.x uses `php_module` (XAMPP convention).                      |
| **Backup**        | A backup of `httpd-xampp.conf.bak` is created on first switch.                                 |

## File structure

```
php-version-switcher/
├── phat.bat          # Entry point (calls phat.ps1)
├── phat.ps1          # Core logic (PowerShell)
├── README.md
└── PLAN.md
```

## Requirements

- Windows 10/11
- XAMPP installed at `C:\xampp`
- PowerShell 5.1+

## Notes

- Run from an **elevated terminal** (Run as Administrator) if you get permission errors during switching.
- Apache vhost warnings (e.g. `Could not resolve host name`) are unrelated to PHP switching — they come from your virtual host configuration.

## License

MIT © [pphatdev](https://github.com/pphatdev)
