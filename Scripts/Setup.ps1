<#
.SYNOPSIS
    Setup the project workspace
.DESCRIPTION
    Performs the initial setup for the project workspace by renaming files and folders,
    removing unneeded files, and substituting placeholder values.
.EXAMPLE
    . .\Scripts\Setup.ps1
    Simply run the script. It will ask you for the ModName and generate the ModUUID automatically
.EXAMPLE
    . .\Scripts\Setup.ps1 -Name MyMod
    Run the script and specify the mod's name as `MyMod`. UUID will be auto-generated
.EXAMPLE
    . .\Scripts\Setup.ps1 -Name MyMod -UUID ((New-Guid).ToString())
    Run the script specifying both the ModName and the ModUUID
#>
param(
    # Name of the Mod. Please use an unique identifier like PREFIX_ModName (e.g. S7_Config)
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Name,

    # UUID for the Mod.
    [string] $UUID = ((New-Guid).ToString())
)

# Rename all placeholder files and directories. That is items with [ModName] and [ModUUID] placeholders.
Get-ChildItem -Recurse | ForEach-Object {
    if ($_.BaseName.EndsWith("[ModName]") -or $_.BaseName.EndsWith("[ModUUID]")) {
        $NewName = $_.FullName.Replace("[ModName]", $Name).Replace("[ModUUID]", $UUID)
        Rename-Item -Path $_.FullName -NewName $NewName.Split("\")[-1] -Force
        Write-Verbose "Renaming $($_.FullName.Split($PWD)[-1]) to $($NewName.Split($PWD)[-1])"
    }
}
