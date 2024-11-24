param prefix string = 'my_app'
var name = '${prefix}${uniqueString(resourceGroup().id)}'

resource serverfarms_ASP_learn9fe9d04ccb154d578064745fa2_a344_name_resource 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: name
  location: 'East US'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 1
  }
  kind: 'linux'
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
