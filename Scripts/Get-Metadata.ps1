<#
.SYNOPSIS
    Returns the metadata from the `meta.lsx` file
.DESCRIPTION
    Parses the metadata from the `meta.lsx` file and returns it as an object.
    The $Select parameter can be used to only select the given attribute.
.EXAMPLE
    . .\Scripts\Get-Metadata.ps1
    Returns the entire metadata object
.EXAMPLE
    . .\Scripts\Get-Metadata.ps1 -Select UUID
    Returns the mod's UUID
#>
param(
    # Path to the `meta.lsx` file
    [ValidateScript({ (Test-Path -Path $_ -PathType Leaf) && ($_.EndsWith("meta.lsx")) })]
    [string] $Path = (Get-ChildItem -Path . -File -Recurse -Filter meta.lsx | Select-Object -First 1 -ExpandProperty FullName),

    # Select a particular attribute
    [ValidateSet('Author', 'Name', 'Description', 'UUID', 'Folder', 'Version64', 'Tags')]
    [string] $Select
)

# Read the `meta.lsx` file
$MetaXML = [xml](Get-Content -Path $Path)

# Extract module information out of the `meta.lsx`
$Author = $MetaXML.SelectSingleNode("//node[@id='ModuleInfo']/attribute[@id='Author']").Value
$Name = $MetaXML.SelectSingleNode("//node[@id='ModuleInfo']/attribute[@id='Name']").Value
$Description = $MetaXML.SelectSingleNode("//node[@id='ModuleInfo']/attribute[@id='Description']").Value
$Folder = $MetaXML.SelectSingleNode("//node[@id='ModuleInfo']/attribute[@id='Folder']").Value
$UUID = $MetaXML.SelectSingleNode("//node[@id='ModuleInfo']/attribute[@id='UUID']").Value
$Version64 = [UInt64] $MetaXML.SelectSingleNode("//node[@id='ModuleInfo']/attribute[@id='Version64']").Value
$Tags = $MetaXML.SelectSingleNode("//node[@id='ModuleInfo']/attribute[@id='Tags']").Value

# Return the parsed metadata
$Metadata = [PSCustomObject]@{
    Author      = $Author
    Name        = $Name
    Description = $Description
    UUID        = $UUID
    Folder      = $Folder
    Version64   = $Version64
    Tags        = $Tags
}

# Return the selected property if $Select is not null
if ($Select) {
    return $Metadata | Select-Object -ExpandProperty $Select
}

# Return the metadata
return $Metadata
