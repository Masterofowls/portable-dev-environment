# Windows Indexing Exclusion Instructions

To prevent Windows from indexing your portable development environment:

## Method 1: Using File Properties (Per Folder)

1. Right-click on `F:\PortableDev` folder
2. Select "Properties"
3. Click "Advanced" button
4. Uncheck "Allow files in this folder to have contents indexed..."
5. Click OK
6. Select "Apply changes to this folder, subfolders and files"
7. Click OK

## Method 2: Using Windows Indexing Options

1. Press `Win + S` and search for "Indexing Options"
2. Click "Modify"
3. Expand your USB drive (F:\)
4. Uncheck `PortableDev` folder
5. Click OK

## Method 3: Using PowerShell (Run as Administrator)

```powershell
# Add INDEXING=OFF attribute to the folder
attrib +I "F:\PortableDev" /S /D

# Or use fsutil to disable indexing
fsutil usn deletejournal /n F:
```

## Method 4: Create desktop.ini (Automatic)

The setup script creates a desktop.ini file that hints to Windows not to index:

```ini
[.ShellClassInfo]
IconResource=shell32.dll,4
[ViewState]
Mode=
Vid=
FolderType=NotSpecified
[{F29F85E0-4FF9-1068-AB91-08002B27B3D9}]
Prop2=31,Portable Development Environment
```

## What Gets Excluded

When you disable indexing:
- Windows Search won't index file contents
- Preview handlers won't cache thumbnails
- Recent files lists won't include these files
- Cortana/Search won't suggest these files

## Important Notes

- USB drives are typically not indexed by default
- These settings apply per-PC (won't transfer to other computers)
- For complete isolation, run the launchers which set proper PATH
