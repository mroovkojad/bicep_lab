# This repo expands on *Microsoft Learn* web app excersises
- [Exercise - Add parameters and variables to your Bicep template](https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/-exercise-add-parameters-variables-bicep-template?pivots=powershell)
- [Create a web app in the Azure portal](https://learn.microsoft.com/en-us/training/modules/host-a-web-app-with-azure-app-service/2-create-a-web-app-in-the-azure-portal)


# Goals and motivations
- Automate as much as possible of example app deployment
- Get as much learning potential from this excersise and lab
- Automate both creating and removing resources
- Provide more resiliance
  - e.g. default **Location** provided in lab sometimes fails
  - repo scripts try out several locations to deploy the app automatically

# Files and structure

- `main.bicep`
  -  File based on lab excersise, extended when needed
- `ConnectLab.ps1`
  - Script connecting terminal (device) to azure
- `CreateApp.ps1`
  - main script that creates resources from `main.bicep` template
- `DeleteBicepResources.ps1`
  - script for deleting resources crated by the `main.bicep` template