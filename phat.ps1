param(
    [Parameter(Position = 0)]
    [string]$Command = "help",

    [Parameter(Position = 1)]
    [string]$Argument,

    [Alias("v", "version")]
    [switch]$VersionFlag,

    [switch]$Php,
    [switch]$Local,
    [switch]$Global
)

# Configuration
$PHAT_VERSION = "1.0.0"
$XAMPP_ROOT  = "C:\xampp"
$APACHE_CONF = "$XAMPP_ROOT\apache\conf\extra\httpd-xampp.conf"
$APACHE_BIN  = "$XAMPP_ROOT\apache\bin\httpd.exe"

# ── Helpers ────────────────────────────────────────────────────────────────────

function Get-PhpVersion ([string]$PhpDir) {
    $exe = Join-Path $PhpDir "php.exe"
    if (Test-Path $exe) {
        return [System.Diagnostics.FileVersionInfo]::GetVersionInfo($exe).FileVersion
    }
    return $null
}

function Get-PhpMajor ([string]$PhpDir) {
    if (Test-Path (Join-Path $PhpDir "php7apache2_4.dll")) { return 7 }
    if (Test-Path (Join-Path $PhpDir "php8apache2_4.dll")) { return 8 }
    return $null
}

function Get-ApacheModuleName ([int]$Major) {
    # XAMPP convention:
    #   PHP 7.x -> php7_module  (loads php7apache2_4.dll)
    #   PHP 8.x -> php_module   (loads php8apache2_4.dll)
    switch ($Major) {
        7 { return "php7_module" }
        8 { return "php_module"  }
        default { return "php_module" }
    }
}

function Stop-ApacheService {
    $stopBat = Join-Path $XAMPP_ROOT "apache_stop.bat"
    if (Test-Path $stopBat) {
        Start-Process -FilePath $stopBat -Wait -NoNewWindow -ErrorAction SilentlyContinue 2>$null
        Start-Sleep -Milliseconds 500
    }
    Get-Process -Name httpd -ErrorAction SilentlyContinue |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 300
}

function Start-ApacheService {
    $startBat = Join-Path $XAMPP_ROOT "apache_start.bat"
    if (Test-Path $startBat) {
        Start-Process -FilePath $startBat -WindowStyle Hidden
    }
}

function Update-ApacheConf ([int]$Major) {
    if (-not (Test-Path $APACHE_CONF)) {
        Write-Host "  WARNING: Apache config not found at $APACHE_CONF" -ForegroundColor Yellow
        return
    }

    # Backup before modifying (only once)
    $backupConf = "$APACHE_CONF.bak"
    if (-not (Test-Path $backupConf)) {
        Copy-Item -Path $APACHE_CONF -Destination $backupConf
        Write-Host "  Backed up original config to httpd-xampp.conf.bak" -ForegroundColor DarkGray
    }

    $phpDirUnix    = "C:/xampp/php"
    $moduleName    = Get-ApacheModuleName $Major
    $tsDllName     = "php${Major}ts.dll"
    $apacheDllName = "php${Major}apache2_4.dll"

    # Verify DLLs exist
    $phpDir = Join-Path $XAMPP_ROOT "php"
    if (-not (Test-Path (Join-Path $phpDir $tsDllName))) {
        Write-Host "  ERROR: $tsDllName not found in $phpDir" -ForegroundColor Red
        return
    }
    if (-not (Test-Path (Join-Path $phpDir $apacheDllName))) {
        Write-Host "  ERROR: $apacheDllName not found in $phpDir" -ForegroundColor Red
        return
    }

    $content = Get-Content $APACHE_CONF
    $newContent = @()

    foreach ($line in $content) {
        if ($line -match '^\s*LoadFile\s+".*php\d?ts\.dll"') {
            $newContent += "LoadFile `"$phpDirUnix/$tsDllName`""
        }
        elseif ($line -match '^\s*LoadModule\s+php\d?_module\s+') {
            $newContent += "LoadModule $moduleName `"$phpDirUnix/$apacheDllName`""
        }
        elseif ($line -match '<IfModule\s+php\d?_module>') {
            $newContent += ($line -replace 'php\d?_module', $moduleName)
        }
        else {
            $newContent += $line
        }
    }

    Set-Content -Path $APACHE_CONF -Value $newContent -Encoding UTF8
    Write-Host "  Updated Apache config: module=$moduleName, dll=$apacheDllName" -ForegroundColor DarkGray
}

function Show-CurrentVersion {
    $phpDir = Join-Path $XAMPP_ROOT "php"
    if (-not (Test-Path $phpDir)) {
        Write-Host "  ERROR: PHP directory not found at $phpDir" -ForegroundColor Red
        return
    }

    $ver = Get-PhpVersion $phpDir
    $major = Get-PhpMajor $phpDir

    if ($ver) {
        Write-Host ""
        Write-Host "  Current PHP Version: " -ForegroundColor Cyan -NoNewline
        Write-Host "$ver (PHP $major)" -ForegroundColor Green
        Write-Host ""
    }
    else {
        Write-Host ""
        Write-Host "  ERROR: Unable to determine current PHP version" -ForegroundColor Red
        Write-Host ""
    }
}

function Show-Version {
    Write-Host ""
    Write-Host "  Phat v$PHAT_VERSION" -ForegroundColor Cyan
    Write-Host "  XAMPP PHP Version Switcher" -ForegroundColor Gray
    Write-Host ""
}

function Write-ExampleLine ([string]$CommandText) {
    Write-Host "    $ " -ForegroundColor DarkGray -NoNewline
    Write-Host $CommandText -ForegroundColor Cyan
}

function Write-UsageLine ([string]$CommandText, [string]$Description) {
    Write-Host "    $CommandText" -ForegroundColor Cyan -NoNewline
    Write-Host "  $Description" -ForegroundColor DarkGray
}

# ── Commands ───────────────────────────────────────────────────────────────────

function Show-Help {
    Write-Host ""
    Write-Host "      ____  __          __ " -ForegroundColor Cyan
    Write-Host "     / __ \/ /_  ____ _/ /_" -ForegroundColor Cyan
    Write-Host "    / /_/ / __ \/ __ `/ __/" -ForegroundColor Cyan
    Write-Host "   / ____/ / / / /_/ / /_  " -ForegroundColor Cyan
    Write-Host "  /_/   /_/ /_/\__,_/\__/  " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Phat - My Personal XAMPP PHP Version Switcher " -ForegroundColor Gray
    Write-Host "  Github: @pphatdev" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Usage:"
    Write-UsageLine "phat list" "                      -> List installed PHP versions"
    Write-UsageLine "phat list --php --local" "        -> List local PHP versions (same as list)"
    Write-UsageLine "phat list --php --global" "       -> List available stable versions from PHP.net"
    Write-UsageLine "phat current" "                   -> Show current PHP version"
    Write-UsageLine "phat -v | --version" "            -> Show Phat version"
    Write-UsageLine "phat switch [version]" "          -> Switch to a PHP version"
    Write-UsageLine "phat use [version]" "             -> Alias for switch"
    Write-UsageLine "phat install [version]" "         -> Download and install a PHP version"
    Write-UsageLine "phat help" "                      -> Show this help"
    Write-Host ""
    Write-Host "  Examples:"
    Write-ExampleLine "phat list --php --global"
    Write-ExampleLine "phat switch 7.4.33"
    Write-ExampleLine "phat install 8.2.27"
    Write-Host ""
}

function Get-GlobalPhpVersions {
    try {
        Write-Host "  Fetching available PHP versions from windows.php.net..." -ForegroundColor Gray
        Write-Host ""
        
        $url = "https://windows.php.net/downloads/releases/"
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
        
        # Parse available versions from the releases page
        $versions = @()
        $pattern = 'php-(\d+\.\d+\.\d+)-Win32-vs\d+-x64\.zip'
        
        $matches = [regex]::Matches($response.Content, $pattern)
        foreach ($match in $matches) {
            $version = $match.Groups[1].Value
            if ($version -notin $versions) {
                $versions += $version
            }
        }
        
        # Sort versions
        $sortedVersions = $versions | Sort-Object {
            $parts = $_ -split '\.'
            [int]$parts[0] * 1000000 + [int]$parts[1] * 1000 + [int]$parts[2]
        } -Descending
        
        if ($sortedVersions.Count -eq 0) {
            Write-Host "  No versions found. Please check your internet connection." -ForegroundColor Yellow
            return
        }
        
        Write-Host "  Available stable PHP versions (Thread-Safe x64):" -ForegroundColor Cyan
        
        # Group by major.minor version
        $grouped = @{}
        foreach ($ver in $sortedVersions) {
            $majorMinor = ($ver -split '\.')[0,1] -join '.'
            if (-not $grouped.ContainsKey($majorMinor)) {
                $grouped[$majorMinor] = @()
            }
            $grouped[$majorMinor] += $ver
        }
        
        # Display grouped versions
        foreach ($key in ($grouped.Keys | Sort-Object -Descending)) {
            Write-Host ""
            Write-Host "  PHP ${key}:" -ForegroundColor Yellow
            foreach ($ver in $grouped[$key]) {
                Write-Host "    $ver" -ForegroundColor White
            }
        }
        
        Write-Host ""
        Write-Host "  To install a version: " -NoNewline -ForegroundColor Gray
        Write-Host "phat install <version>" -ForegroundColor Cyan
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "  Error: Failed to fetch PHP versions from website." -ForegroundColor Red
        Write-Host "  $_" -ForegroundColor Red
        Write-Host ""
    }
}

function Invoke-List {
    # Handle --php --global flag
    if ($Global -and $Php) {
        Get-GlobalPhpVersions
        return
    }
    
    # Handle --php --local flag or default behavior
    Write-Host ""
    Write-Host "  Installed PHP versions:" -ForegroundColor Cyan

    $dirs = Get-ChildItem -Path $XAMPP_ROOT -Directory -Filter "php*" | Sort-Object Name
    foreach ($dir in $dirs) {
        if ($dir.Name -eq "php") {
            $ver = Get-PhpVersion $dir.FullName
            $major = Get-PhpMajor $dir.FullName
            $label = if ($ver) { $ver } else { "unknown" }
            Write-Host "  * $label (active, php${major})" -ForegroundColor Green
        }
        elseif ($dir.Name -eq "phpMyAdmin") {
            continue
        }
        else {
            $ver = Get-PhpVersion $dir.FullName
            $tag = $dir.Name -replace '^php', ''
            $label = if ($ver) { "$tag ($ver)" } else { $tag }
            Write-Host "    $label" -ForegroundColor White
        }
    }
    Write-Host ""
}

function Invoke-Switch ([string]$Version) {
    if (-not $Version) {
        Write-Host "  Error: Version required. Usage: phat switch [version]" -ForegroundColor Red
        return
    }

    $targetDir  = Join-Path $XAMPP_ROOT "php$Version"
    $currentDir = Join-Path $XAMPP_ROOT "php"

    # Validate target exists
    if (-not (Test-Path $targetDir)) {
        Write-Host "  Error: php$Version not found in $XAMPP_ROOT" -ForegroundColor Red
        Write-Host "  Available:" -ForegroundColor Gray
        Get-ChildItem -Path $XAMPP_ROOT -Directory -Filter "php*" |
            Where-Object { $_.Name -ne "php" -and $_.Name -ne "phpMyAdmin" } |
            ForEach-Object { Write-Host "    $($_.Name -replace '^php', '')" }
        return
    }

    # Check not switching to same version
    $currentVer = Get-PhpVersion $currentDir
    $targetVer  = Get-PhpVersion $targetDir
    if ($currentVer -and $targetVer -and ($currentVer -eq $targetVer)) {
        Write-Host "  Already on PHP $currentVer, nothing to do." -ForegroundColor Yellow
        return
    }

    $targetMajor = Get-PhpMajor $targetDir
    if (-not $targetMajor) {
        Write-Host "  Error: No php*apache2_4.dll found in $targetDir" -ForegroundColor Red
        return
    }

    Write-Host ""
    Write-Host "  Switching PHP: $currentVer -> $targetVer (php$targetMajor)" -ForegroundColor Cyan

    # Step 1: Stop Apache
    Write-Host "  [1/5] Stopping Apache..." -ForegroundColor White
    Stop-ApacheService

    # Step 2: Backup current php/
    if (Test-Path $currentDir) {
        $backupName = if ($currentVer) { "php$currentVer" } else { "php_backup" }
        $backupPath = Join-Path $XAMPP_ROOT $backupName

        if (Test-Path $backupPath) {
            $backupName = "php_old_$(Get-Date -Format 'yyyyMMddHHmmss')"
        }

        Write-Host "  [2/5] Backing up current PHP -> $backupName" -ForegroundColor White
        Rename-Item -Path $currentDir -NewName $backupName -ErrorAction Stop
    }

    # Step 3: Activate target
    Write-Host "  [3/5] Activating php$Version -> php/" -ForegroundColor White
    Rename-Item -Path $targetDir -NewName "php" -ErrorAction Stop

    # Step 4: Update Apache config
    Write-Host "  [4/5] Updating Apache configuration..." -ForegroundColor White
    Update-ApacheConf $targetMajor

    # Step 5: Start Apache
    Write-Host "  [5/5] Starting Apache..." -ForegroundColor White
    Start-ApacheService

    Write-Host ""
    Write-Host "  Done! Switched to PHP $targetVer" -ForegroundColor Green
    Write-Host ""
}

function Invoke-Install ([string]$Version) {
    if (-not $Version) {
        Write-Host "  Error: Version required. Usage: phat install [version]" -ForegroundColor Red
        Write-Host "  Example: phat install 8.2.27" -ForegroundColor Gray
        return
    }

    $destDir = Join-Path $XAMPP_ROOT "php$Version"
    if (Test-Path $destDir) {
        Write-Host "  PHP $Version is already installed at $destDir" -ForegroundColor Yellow
        return
    }

    Write-Host ""
    Write-Host "  Installing PHP $Version..." -ForegroundColor Cyan

    # Determine major version for VS compiler tag
    $majorVer = [int]($Version.Split('.')[0])

    # Build download URL candidates (TS = thread-safe, required for Apache module)
    # Try vs17 first (PHP 8.2+), then vs16 (PHP 7.4 - 8.1)
    $vsVersions = @("vs17", "vs16")
    if ($majorVer -le 7) {
        $vsVersions = @("vs16", "vs15")
    }

    # Try releases first, then archives
    $basePaths = @(
        "https://windows.php.net/downloads/releases",
        "https://windows.php.net/downloads/releases/archives"
    )

    $zipUrl = $null
    $fileName = $null

    Write-Host "  [1/3] Finding download URL..." -ForegroundColor White

    foreach ($basePath in $basePaths) {
        foreach ($vs in $vsVersions) {
            $candidateName = "php-$Version-Win32-$vs-x64.zip"
            $candidateUrl  = "$basePath/$candidateName"

            Write-Host "    Trying: $candidateName" -ForegroundColor DarkGray

            try {
                $response = Invoke-WebRequest -Uri $candidateUrl -Method Head -UseBasicParsing -ErrorAction Stop
                if ($response.StatusCode -eq 200) {
                    $zipUrl  = $candidateUrl
                    $fileName = $candidateName
                    break
                }
            } catch {
                # URL not found, try next candidate
            }
        }
        if ($zipUrl) { break }
    }

    if (-not $zipUrl) {
        Write-Host "  Error: Could not find PHP $Version for download." -ForegroundColor Red
        Write-Host "  Check available versions at: https://windows.php.net/downloads/releases/" -ForegroundColor Gray
        Write-Host "  Or archives: https://windows.php.net/downloads/releases/archives/" -ForegroundColor Gray
        return
    }

    Write-Host "  Found: $fileName" -ForegroundColor DarkGray

    # Download
    $tempDir  = Join-Path $env:TEMP "phat_download"
    $tempZip  = Join-Path $tempDir $fileName

    if (-not (Test-Path $tempDir)) {
        New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
    }

    Write-Host "  [2/3] Downloading..." -ForegroundColor White
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        # Disable progress bar for much faster download
        $oldProgress = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
        $ProgressPreference = $oldProgress
    } catch {
        Write-Host "  Error: Download failed - $_" -ForegroundColor Red
        return
    }

    if (-not (Test-Path $tempZip)) {
        Write-Host "  Error: Downloaded file not found." -ForegroundColor Red
        return
    }

    $fileSize = [math]::Round((Get-Item $tempZip).Length / 1MB, 1)
    Write-Host "  Downloaded: $fileSize MB" -ForegroundColor DarkGray

    # Extract
    Write-Host "  [3/3] Extracting to $destDir..." -ForegroundColor White
    try {
        Expand-Archive -Path $tempZip -DestinationPath $destDir -Force
    } catch {
        Write-Host "  Error: Extraction failed - $_" -ForegroundColor Red
        return
    }

    # Copy php.ini from development template if no php.ini exists
    $phpIni = Join-Path $destDir "php.ini"
    $phpIniDev = Join-Path $destDir "php.ini-development"
    if ((-not (Test-Path $phpIni)) -and (Test-Path $phpIniDev)) {
        Copy-Item -Path $phpIniDev -Destination $phpIni
        Write-Host "  Created php.ini from php.ini-development" -ForegroundColor DarkGray
    }

    # Cleanup temp
    Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Host "  Done! PHP $Version installed to $destDir" -ForegroundColor Green
    Write-Host "  Run 'phat switch $Version' to activate it." -ForegroundColor Gray
    Write-Host ""
}

# ── Dispatch ───────────────────────────────────────────────────────────────────

if ($VersionFlag) {
    Show-Version
    return
}

switch ($Command) {
    "list"       { Invoke-List }
    "current"    { Show-CurrentVersion }
    "switch"     { Invoke-Switch $Argument }
    "use"        { Invoke-Switch $Argument }
    "install"    { Invoke-Install $Argument }
    "help"       { Show-Help }
    
    default      { Show-Help }
}
