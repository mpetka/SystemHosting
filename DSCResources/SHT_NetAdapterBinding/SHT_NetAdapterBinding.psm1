<### 
 # SHT_NetAdapterBinding - A DSC resource for modifying network adapter bindings.
 #
 # Authored by: M.T.Nielsen - mni@systemhosting.dk
 #>

function Get-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$InterfaceAlias,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComponentID,

        [Parameter(Mandatory)]
        [bool]$Enabled
	)
	
    Write-Verbose 'Get-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }
    
    return @{
        InterfaceAlias = $InterfaceAlias
        ComponentID = $ComponentID
        Enabled = $Enabled
    }
}


function Set-TargetResource
{
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$InterfaceAlias,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$ComponentID,

        [Parameter(Mandatory)]
        [bool]$Enabled
	)

    Write-Verbose 'Set-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    Get-NetAdapter -InterfaceAlias $InterfaceAlias | Get-NetAdapterBinding -ComponentID $ComponentID | Set-NetAdapterBinding -Enabled $Enabled
}


function Test-TargetResource
{
    param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$InterfaceAlias,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
        [string]$ComponentID,

        [Parameter(Mandatory)]
        [bool]$Enabled
	)

    Write-Verbose 'Test-TargetResource'
    foreach ($k in $PSBoundParameters.GetEnumerator()) {
        Write-Verbose ('{0} - {1}' -f $k.Key, $k.Value)
    }

    $binding = Get-NetAdapter -InterfaceAlias $InterfaceAlias | Get-NetAdapterBinding -ComponentID $ComponentID

    if($binding -eq $null) { 
        throw "ComponentID $ComponentID not supported. Use `"Get-NetAdapter -InterfaceAlias '$InterfaceAlias' | Get-NetAdapterBinding | Format-Table DisplayName, ComponentID, Enabled`" to get a list of supported components." 
    }

    $testResult = [bool]($binding.Enabled -eq $Enabled)

    Write-Verbose "Test-TargetResource - Value match: $testResult"

    return $testResult
}


Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource