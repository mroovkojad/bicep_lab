# List of locations to try
$locations = @("eastus", "westus", "centralus", "westeurope")

# Module Id corresponding to Exercise - Create a web app in the Azure portal
$xModuleId = "learn.host-a-web-application-with-azure-web-apps"
$parameters = @{
    ResourceGroupName = Get-AzResourceGroup | Where-Object {$_.Tags.'x-module-id' -eq $xModuleId} | Select-Object -ExpandProperty ResourceGroupName
    TemplateFile  = ".\main.bicep"
    location =""
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
