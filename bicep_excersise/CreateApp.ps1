# List of locations to try
$locations = @("eastus", "westus", "centralus", "westeurope")

$parameters = @{
    ResourceGroupName = Get-AzResourceGroup | Where-Object {$_.Tags.'x-module-id' -eq "learn.azure.deploy-azure-resources-bicep"} | Select-Object -ExpandProperty ResourceGroupName
    TemplateFile  = ".\main.bicep"
    location =""
    environmentType  = 'nonprod'
    ErrorAction = "SilentlyContinue"
    Name = 'toyAppDeployment'
}

foreach ($location in $locations) {
    try {
        # Attempt deployment in the current location
        Write-Host "Attempting deployment in location: $location"

        $parameters.location = $location
        $result = New-AzResourceGroupDeployment @parameters

        # Check deployment result
        if ($result.ProvisioningState -eq "Succeeded") {
            Write-Host "Deployment succeeded in location: $location"
            break
        }
    } catch {
        # Log the error and move to the next location
        Write-Host "Deployment failed in location: $location"
        Write-Host "Error: $_"
    }
}

Write-Host "Deployment process completed."
