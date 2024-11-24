@allowed([
  'eastus'
  'westus'
  'centralus'
  'westeurope'
])
@description('The region where the resources should be created.')
param location string

param prefix string = 'pythonapp'

param storageAccountName string = '${prefix}${uniqueString(resourceGroup().id)}'

@description('The name of the web app. Must be unique across all Azure web apps.')
param webAppName string = '${prefix}${uniqueString(resourceGroup().id)}'

@description('The runtime stack for the web app.')
param runtimeStack string = 'PYTHON|3.12'

@description('The operating system for the web app.')
param operatingSystem string = 'Linux'

@description('The name of the App Service plan.')
param appServicePlanName string = '${webAppName}-plan'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 1
  }
  kind: operatingSystem
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: runtimeStack // Specifies the runtime stack for Linux
    }
  }
  kind: 'app,linux'
}
