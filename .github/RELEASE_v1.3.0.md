## 🎉 What's New in v1.3.0

This release focuses on improving user experience with better diagnostics and comprehensive troubleshooting documentation.

### ✨ New Features

**WhereAmI Command**
- 🔍 New `phat whereami` command — Instantly locate your phat.bat and phat.ps1 installation paths
- ✅ Helpful for debugging PATH issues and verifying installation
- 📍 Shows exactly where Phat is installed on your system

**Comprehensive Troubleshooting Guides**
- 📚 Added extensive documentation for common issues:
  - Apache won't start after PHP version switch
  - Download failures during PHP installation
  - Git Bash compatibility issues
  - Permission denied errors
  - PHP version not found errors
  - PowerShell execution policy restrictions
- 🎯 Centralized troubleshooting guide for quick problem resolution
- 💡 Step-by-step solutions with detailed explanations

### 🔧 Improvements

**Better User Support**
- 📖 Improved documentation structure with dedicated troubleshooting section
- 🔧 Enhanced error messages and diagnostic information
- 🎨 Clearer command output and user guidance

---

## 📦 Installation

### MSI Installer (Recommended)

1. Download `Phat.msi` from the assets below
2. Run the installer
3. Open a new terminal and verify:
   ```bash
   phat help
   ```

### Manual Installation

```bash
git clone https://github.com/pphatdev/php-version-switcher.git
# Add the folder to your system PATH
phat help
```

---

## 🚀 Quick Start

```bash
# List all installed PHP versions
phat list

# Switch to a specific version
phat switch 8.3.30

# Install a new PHP version
phat install 8.4.0

# Find where Phat is installed (NEW!)
phat whereami
```

---

## 📋 Requirements

- **OS:** Windows 10/11
- **XAMPP:** Installed at `C:\xampp`
- **PowerShell:** 5.1 or higher
- **Permissions:** Administrator rights for switching versions

---

## 🐛 Known Issues

- Requires an **elevated terminal** (Run as Administrator) if permission errors occur during version switching
- Apache vhost warnings (e.g. `Could not resolve host name`) are unrelated to PHP switching

For solutions to common issues, check out our [Troubleshooting Guide](https://github.com/pphatdev/php-version-switcher/blob/master/docs/TROUBLESHOOTING.md)

---

## 📝 Full Changelog

**Full Changelog:** https://github.com/pphatdev/php-version-switcher/compare/v1.2.0...v1.3.0

---

## 🙏 Thank You

Thank you for using Phat! If you find it useful, please **star ⭐ the repo**!

For issues or suggestions, please [open an issue](https://github.com/pphatdev/php-version-switcher/issues).
