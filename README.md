# Portable Development Environment

A fully isolated, portable development environment for USB flash drives.

## Quick Start

### First Time Setup (already done!)
The environment is already set up. If you need to reinstall, run:
```
Setup-Environment.bat
```

### Daily Use

1. **Launch Isolated Terminal**: Double-click `Launch-Terminal.bat`
2. **Launch VS Code**: Double-click `Launch-VSCode.bat`  
3. **Launch Firefox**: Double-click `Launch-Firefox.bat`
4. **Launch Chrome**: Double-click `Launch-Chrome.bat`

## What's Included

| Tool | Version | Status |
|------|---------|--------|
| PowerShell 7 | 7.4.6 | ✅ Installed |
| Git | 2.47.1 | ✅ Installed |
| Node.js | 22.12.0 | ✅ Installed |
| NVM | 1.2.2 | ✅ Installed |
| Python | 3.12.8 | ✅ Installed |
| VS Code | Latest | ✅ Installed |
| Firefox | 133.0 | ✅ Installed |
| Chrome | - | ⚠️ Manual install needed |

### PowerShell Enhancement Tools

| Tool | Description | Status |
|------|-------------|--------|
| Oh My Posh | Prompt theming | ✅ Installed |
| Starship | Cross-shell prompt | ✅ Installed |
| Nerd Fonts | Icon fonts (CascadiaCode, JetBrainsMono) | ✅ Downloaded |
| FZF | Fuzzy finder | ✅ Installed |
| Zoxide | Smart cd command | ✅ Installed |
| gsudo | Sudo for Windows | ✅ Installed |
| pyenv-win | Python version manager | ✅ Installed |
| Playwright | Browser automation | ✅ Installed |
| PSReadLine | Enhanced readline | ✅ Installed |
| PSFzf | FZF PowerShell integration | ✅ Installed |
| Terminal-Icons | File icons in terminal | ✅ Installed |

## Features

### Complete Isolation
- **Separate PATH**: Only portable apps in PATH (no system tools visible)
- **Separate HOME**: `F:\PortableDev\Home` instead of system user folder
- **Separate TEMP**: `F:\PortableDev\Data\temp` 
- **Separate APPDATA**: `F:\PortableDev\Data\AppData`
- **No Windows indexing**: Files won't be indexed by Windows Search

### Enhanced Terminal Experience
- **Starship/Oh My Posh**: Beautiful customizable prompts (switch in profile)
- **FZF Integration**: `Ctrl+R` for fuzzy history, `Ctrl+F` for file search
- **Zoxide**: Smart `z` command learns your frequent directories
- **gsudo**: Run commands as admin with `sudo`
- **Terminal-Icons**: See file icons in directory listings
- **PSReadLine**: Predictive IntelliSense and history search

### Portable Tools Configuration
- **NPM**: Cache and global packages stored on USB
- **Python/pip**: Packages installed to USB
- **Git**: Config file on USB
- **VS Code**: Full portable mode with data folder

## Directory Structure

```
F:\PortableDev\
├── Apps\                    # All applications
│   ├── PowerShell\          # PowerShell 7
│   ├── Git\                 # Git Portable
│   ├── NodeJS\              # Node.js
│   ├── NVM\                 # Node Version Manager
│   ├── Python\              # Python 3.12
│   ├── VSCode\              # VS Code Portable
│   └── Chrome\              # Chrome Portable
├── Config\                  # Configuration files
│   ├── PortableProfile.ps1  # PowerShell isolation profile
│   ├── vscode-settings.json # VS Code settings
│   └── .gitconfig           # Git configuration
├── Data\                    # App data (cache, packages, etc)
│   ├── npm-cache\           # NPM cache
│   ├── npm-global\          # Global NPM packages
│   ├── pip-cache\           # pip cache
│   ├── python-packages\     # Python packages
│   └── temp\                # Temporary files
├── Home\                    # Portable HOME directory
├── Projects\                # Your projects go here!
├── Scripts\                 # Helper scripts
├── Launch-Terminal.bat      # Start isolated PowerShell
├── Launch-VSCode.bat        # Start VS Code
└── Launch-Chrome.bat        # Start Chrome
```

## Using on Another PC

1. Plug in the USB drive
2. Note the drive letter (might be different, e.g., E:\, G:\)
3. Navigate to `PortableDev` folder
4. Run `Launch-Terminal.bat` or `Launch-VSCode.bat`

The scripts automatically detect the drive letter!

## Chrome Installation (Manual)

Chrome Portable requires manual download:
1. Visit https://portableapps.com/apps/internet/google_chrome_portable
2. Download GoogleChromePortable
3. Install to `F:\PortableDev\Apps\Chrome\`

## VS Code Extensions

To install extensions, open the portable terminal and run:
```powershell
.\Scripts\Install-VSCodeExtensions.ps1 -Basic   # Basic extensions
.\Scripts\Install-VSCodeExtensions.ps1 -All     # All extensions
```

## Troubleshooting

### "PowerShell not found"
Run `Setup-Environment.bat` to reinstall apps.

### Tools not working in terminal
Make sure you launched via `Launch-Terminal.bat`, not system PowerShell.

### VS Code using system settings
Launch via `Launch-VSCode.bat` to use portable mode.

## Notes

- All data stays on the USB - nothing installed to host PC
- Works on Windows 10 and 11
- No admin rights required for daily use
- Internet connection needed for first-time setup only
