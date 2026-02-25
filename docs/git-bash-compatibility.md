# Git Bash / MINGW64 Compatibility

## Problem

When using Git Bash, MINGW64, or other bash terminals, you get:

```bash
$ phat
bash: phat: command not found
```

## Cause

Phat uses `.bat` (batch) files which only work in Windows Command Prompt and PowerShell. Bash terminals on Windows don't recognize `.bat` files as executable commands.

## Solutions

### Solution 1: Use PowerShell or CMD (Recommended)

Simply switch to PowerShell or Command Prompt to run Phat:

- **PowerShell**: Press `Win + X` and select "Windows PowerShell" or "Terminal"
- **CMD**: Press `Win + R`, type `cmd`, and press Enter

Then run your `phat` commands normally.

### Solution 2: Create a Bash Alias

Add this to your `~/.bashrc` or `~/.bash_profile`:

```bash
# Phat alias for Git Bash
phat() {
    powershell.exe -ExecutionPolicy Bypass -File "C:/Program Files (x86)/Phat/phat.ps1" "$@"
}
```

**Note**: Adjust the path if Phat is installed elsewhere. Use forward slashes (`/`) instead of backslashes.

After adding the alias:
1. Restart your bash terminal, or
2. Run: `source ~/.bashrc`

Now you can use `phat` commands in Git Bash.

### Solution 3: Run via PowerShell Command

You can run Phat directly from bash using PowerShell:

```bash
powershell.exe -ExecutionPolicy Bypass -File "C:/Program Files (x86)/Phat/phat.ps1" list
```

### Solution 4: Add PowerShell Function to PATH

Create a bash function wrapper. Add to `~/.bashrc`:

```bash
export PHAT_HOME="/c/Program Files (x86)/Phat"
alias phat='powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PHAT_HOME/phat.ps1"'
```

## Important Notes for Bash Users

- Phat is designed for Windows environments (PowerShell/CMD)
- It manages XAMPP which is a Windows application
- For the best experience, use PowerShell or CMD when working with Phat

## Testing Your Setup

After configuring, test with:

```bash
phat --version
```

## Related Resources

- [Bash Aliases Guide](https://www.gnu.org/software/bash/manual/html_node/Aliases.html)
- [Back to Troubleshooting Index](TROUBLESHOOTING.md)
