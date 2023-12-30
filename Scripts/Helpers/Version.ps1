function Convert-VersionNumber(
    # The string representation of the version number
    [Parameter(ParameterSetName = "Version")]
    [ValidatePattern("^\d\.\d\.\d\.\d$")]
    [string] $Version = "1.0.0.0",

    # The long int version number
    [Parameter(ParameterSetName = "Version64")]
    [long] $Version64,

    # Format the output as string
    [switch] $AsString
) {

    # If the input is a Version64
    if ($PSCmdlet.ParameterSetName -eq "Version64") {
        # Perform the conversion
        $Major = $Version64 -shr 55
        $Minor = ($Version64 -shr 47) -band 0xFF
        $Revision = ($Version64 -shr 31) -band 0xFFFF
        $Build = $Version64 -band 0x7FFFFFF 

        # If the AsString switch is passed return as a string
        if ($AsString) {
            return "$Major.$Minor.$Revision.$Build"
        }

        # Return the output object
        return [PSCustomObject]@{
            Major    = $Major
            Minor    = $Minor
            Revision = $Revision
            Build    = $Build
        }
    }
    # Else if the input is a string version
    else {
        # Parse the string version
        $Major, $Minor, $Revision, $Build = $Version.Split(".")
        $Major = ([long] $Major -shl 55)
        $Minor = ([long] $Minor -shl 47)
        $Revision = ([long] $Revision -shl 31)
        $Build = [long] $Build

        # Calculate the Version64
        $Version64 = $Major + $Minor + $Revision + $Build

        # If the AsString switch was passed return as a string
        if ($AsString) {
            return $Version64
        }

        # Return the output object
        return [PSCustomObject]@{
            Version64 = $Version64
        }
    }

}
