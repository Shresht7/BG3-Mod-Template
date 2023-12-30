<#
.SYNOPSIS
    Builds the Mod Project
.DESCRIPTION
    Builds the Mod Project using `divine.exe` (lslib).
.EXAMPLE
    . .\Build.ps1
    Builds the mod project and creates a `.pak` in the Build output directory
.EXAMPLE
    . .\Build.ps1 -WhatIf
    Performs a dry-run without actually making any changes. This will tell you what changes
    the script will make
.EXAMPLE
    . .\Build.ps1 -Confirm
    Asks for your confirmation as it builds the mod project.
.EXAMPLE
    . .\Build.ps1 -Archive
    Builds the mod project and create a `.zip` archive containing the `.pak` in the
    Build output directory 
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    # Path to the `meta.lsx` file. If not specified, will try to find the `meta.lsx` file in the workspace
    [ValidateScript({ (Test-Path -Path $_ -PathType Leaf) && ($_.EndsWith("meta.lsx")) })]
    [string] $Path = (Get-ChildItem -Path . -File -Recurse -Depth 5 -Filter meta.lsx | Select-Object -First 1 -ExpandProperty FullName),

    # Path to the Build Output directory
    [ValidateScript({ Test-Path -Path $_.DirectoryName -PathType Container })]
    [Alias("Output", "Out")]
    [string] $Destination = (Join-Path $PSScriptRoot ".." "Build"),

    # Switch to compress the .pak into an .zip archive
    [switch] $Archive
)

# Import Helpers
. .\Scripts\Helpers\Utils.ps1

# Update the path to point to the root folder
$Path = Get-ModRootFolder -Path $Path

# Check requirements
if (!(Get-Command -Name divine.exe -ErrorAction SilentlyContinue)) {
    throw "[FAIL] Could not find divine.exe (lslib). You may need to add divine.exe to your `$Env:PATH variable"
}

# Determine the ModName
$ModName = $Path.BaseName

# Build Localization Files
Get-ChildItem "$Path/Localization/" -Filter *.xml -File -Recurse | ForEach-Object {
    $dest = "$(Join-Path $_.DirectoryName $_.BaseName).loca"
    if ($PSCmdlet.ShouldProcess($_.FullName, "Create-Localization using divine.exe")) {
        divine --game bg3 --action convert-loca --source $_.FullName --destination $dest
    }
}

# Build lsx files
Get-ChildItem "$Path/Public" -Filter *.lsx -File -Recurse | ForEach-Object {
    $dest = "$(Join-Path $_.DirectoryName $_.BaseName).lsf"
    if ($PSCmdlet.ShouldProcess($_.FullName, "Create-Resource using divine.exe")) {
        divine --game bg3 --action convert-resource --source $_.FullName --destination $dest
    }
}

# Build Package
$PakPath = Join-Path $Destination "$ModName.pak"
if ($PSCmdlet.ShouldProcess($Path, "Create-Package using divine.exe")) {
    divine --game bg3 --action create-package --source $Path --destination $PakPath
}

# Compress Archive, if the $Archive switch is set
if ($Archive) {
    $ArchivePath = Join-Path $Destination "$ModName.zip"
    if ($PSCmdlet.ShouldProcess($PakPath, "Archive the .pak")) {
        Compress-Archive -Path $PakPath -DestinationPath $ArchivePath
        Remove-Item -Path $PakPath
    }
}
