<#
.SYNOPSIS
    Updates the version number in the `meta.lsx` file
.DESCRIPTION
    Bumps and updates the version number in the `meta.lsx` files
    as specified. (Defaults to `Build`)
.EXAMPLE
    . .\Scripts\Update-VersionNumber.ps1
    Bumps the version number build by 1. (1.0.0.0 --> 1.0.0.1)
.EXAMPLE
    . .\Scripts\Update-VersionNumber.ps1 -Kind Minor
    Bumps the minor version number by 1. (1.0.2.14 --> 1.1.0.0)
#>
param(
    # Path to the `meta.lsx` file. If not specified, will try to find the `meta.lsx` file in the workspace
    [ValidateScript({ (Test-Path -Path $_ -PathType Leaf) && ($_.EndsWith("meta.lsx")) })]
    [string] $Path = (Get-ChildItem -Path . -File -Recurse -Depth 5 -Filter meta.lsx | Select-Object -First 1 -ExpandProperty FullName),

    # The kind of version update. Should be one of `Major`, `Minor`, `Revision`, `Build`
    [ValidateSet("Major", "Minor", "Revision", "Build")]
    [string] $Kind = "Build"
)

# Import Helpers
. .\Scripts\Helpers\Version.ps1

# Get `meta.lsx` content
$MetaXML = [xml](Get-Content -Path $Path)
$Version64Attribute = $MetaXML.SelectSingleNode("//node[@id='ModuleInfo']/attribute[@id='Version64']")

# Update the version number
$NewVersion64 = Update-VersionNumber -Version64 $Version64Attribute.Value -Kind $Kind -As "Version64"

# Update the Version64 attribute in the XML data
$Version64Attribute.SetAttribute("value", $NewVersion64)

# Write the update contents back to the file
$StringWriter = New-Object System.IO.StringWriter
$Writer = New-Object System.Xml.XmlTextwriter($StringWriter)
$Writer.Formatting = [System.XML.Formatting]::Indented
$MetaXML.WriteContentTo($Writer)
$StringWriter.ToString() | Out-File -FilePath $Path -Encoding utf8
