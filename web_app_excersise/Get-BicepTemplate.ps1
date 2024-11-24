$xModuleId = "learn.host-a-web-application-with-azure-web-apps"
$ResourceGroupName = Get-AzResourceGroup | Where-Object {$_.Tags.'x-module-id' -eq $xModuleId} | Select-Object -ExpandProperty ResourceGroupName
$resources = Get-AzResource | Where-Object {$_.Name -notlike "cloudshell*"}
foreach ($resource in $resources){
    $exportName = ".\" +$resource.ResourceName + ".json"
    Write-Output "Exporting resource: $($resource.ResourceName)"
    Export-AzResourceGroup -ResourceGroupName $ResourceGroupName -Resource $resource.ResourceId
    Write-Output "Renaming exported file to: $exportName "
    Move-Item -Path ".\$ResourceGroupName.json" -Destination ".\templates\$exportName" -Force
}

$templates = Get-ChildItem -Path .\templates -Filter *.json

foreach ($file in $templates){
    az bicep decompile --file $file.FullName
}