param acrSku string
param appServiceName string
param location string = resourceGroup().location

var appServiceSlotName = 'blue'
var suffix = substring(uniqueString(resourceGroup().id), 0, 8)
var acrName = 'acr${suffix}'
var appServicePlanName = 'asp-${suffix}'
var appName = 'app-${appServiceName}-${suffix}'

module containerRegistry 'containerRegistry.bicep' = {
  name: 'containerRegistry'
  params: {
    registryLocation: location 
    registryName: acrName
    registrySku: acrSku
    greenSlotName: appName
    blueSlotName: appServiceSlotName
  }
}

module appServicePlan 'appServicePlan.bicep' = {
  name: 'appServicePlan'
  params: {
    appServicePlanLocation: location
    appServicePlanName: appServicePlanName
  }
}

module appService 'appService.bicep' = {
  name: 'appService'
  params: {
    appServiceLocation: location 
    appServiceName: appName
    serverFarmId: appServicePlan.outputs.appServicePlanId
    appServiceSlotName: appServiceSlotName
    acrName: acrName
  }
}
