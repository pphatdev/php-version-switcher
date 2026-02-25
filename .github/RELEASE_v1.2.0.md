## 🎉 What's New in v1.2.0

This release improves the installer experience with a single-file MSI package.

### 🔧 Improvements

**Embedded CAB File**
- ✨ Single-file installer — The MSI now embeds the CAB file internally
- ✅ No more missing file errors during installation
- 📦 Easier distribution — One `.msi` file contains everything

**Enhanced CI/CD Pipeline**
- 🔨 Added WiX Toolset installation step for reliable builds
- ✅ Improved build error detection and reporting
- 🐛 Better debug output for troubleshooting

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

---

## 📝 Full Changelog

**Full Changelog:** https://github.com/pphatdev/php-version-switcher/compare/v1.1.1...v1.2.0

---

## 🙏 Thank You

Thank you for using Phat! If you find it useful, please **star ⭐ the repo**!

For issues or suggestions, please [open an issue](https://github.com/pphatdev/php-version-switcher/issues).
