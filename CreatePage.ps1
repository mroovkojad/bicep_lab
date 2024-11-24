$htmlPath = ".\hello.html"
$targetFile = Get-ChildItem -Path $htmlPath
$zipFilePath = $targetFile.BaseName + ".zip"
Compress-Archive -Path $htmlPath -DestinationPath $zipFilePath

$webapp = Get-AzWebApp -Name $appName -ResourceGroupName $resourceGroupName
$kuduUrl = "https://$($webapp.DefaultHostName)/api/zipdeploy"
$publishingProfile = (Get-AzWebAppPublishingProfile -ResourceGroupName $resourceGroupName -WebAppName $appName)
$headers = @{
    Authorization = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($publishingProfile.UserName):$($publishingProfile.Password)")))"
}
Invoke-WebRequest -Uri $kuduUrl -Headers $headers -InFile "./site.zip" -Method POST



#Final Cleanup
Remove-Item $zipFilePath