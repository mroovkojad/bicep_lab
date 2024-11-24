$ResourceGroupName = Get-AzResourceGroup | Where-Object {$_.Tags.'x-module-id' -eq "learn.azure.deploy-azure-resources-bicep"} | Select-Object -ExpandProperty ResourceGroupName

$parameters = @{
    ResourceGroupName = $ResourceGroupName
    DeploymentName =  Get-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName | Sort-Object -Property Timestamp| Select-Object -ExpandProperty DeploymentName -Last 1
}

# Get the list of resources created by the deployment
$resources = Get-AzResourceGroupDeploymentOperation @parameters

# Iterate through each resource and attempt to delete
foreach ($resource in $resources) {
    try {
        # Check if the resource exists before attempting to delete
        $existingResource = Get-AzResource -ResourceId $resource.TargetResource -ErrorAction SilentlyContinue

        if ($existingResource) {
            Write-Host "Resource found. Attempting to delete resource: $($resource.ResourceName) of type $($resource.ResourceType)" -ForegroundColor Cyan
            Remove-AzResource -ResourceId $resource.TargetResource -Force
            Write-Host "Successfully deleted: $($resource.ResourceName)" -ForegroundColor Green
        } else {
            Write-Host "Resource not found: $($resource.ResourceName)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Failed to delete resource: $($resource.ResourceName)" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "Resource deletion script completed." -ForegroundColor Magenta

$removeParameters = @{
    ResourceGroupName = $ResourceGroupName
    Name = $parameters.DeploymentName
}

Write-Host "Deleting Resource Group Deployment"
Remove-AzResourceGroupDeployment @removeParameters
