

$htmlPath = ".\hello.html"
$targetFile = Get-ChildItem -Path $htmlPath
$zipFilePath = $targetFile.BaseName + ".zip"
Compress-Archive -Path $htmlPath -DestinationPath $zipFilePath

$ResourceGroupName = Get-AzResourceGroup | Where-Object {$_.Tags.'x-module-id' -eq "learn.azure.deploy-azure-resources-bicep"} | Select-Object -ExpandProperty ResourceGroupName

$webapp = Get-AzWebApp -ResourceGroupName $ResourceGroupName
$publishingProfile = Get-AzWebAppPublishingProfile -WebApp $webapp

$invokeWebRequestParameters = @{
    Uri = "https://$($webapp.DefaultHostName)/api/zipdeploy"
    Headers = @{
        Authorization = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($publishingProfile.UserName):$($publishingProfile.Password)")))"
    }
    InFile = $zipFilePath
    Method = "POST"
}

$invokeWebRequestParameters
Invoke-WebRequest @invokeWebRequestParameters



#Final Cleanup
#Remove-Item $zipFilePath
