# win-dev-machine-setup

Customized version of [Mario Szpuszta's awesome setup script](https://github.com/mszcool/devmachinesetup).

Automates provisioning of Windows development machines using Powershell and Chocolatey. Because some steps depend on previous steps or require machine restarts, it needs to be run in phases.

# Step 1 - Installs Chocolatey and enables Windows Features
.\Setup-Machine.ps1 -prepOS

# Step 2 - Visual Studio
.\Setup-Machine.ps1 -installVs -vsVersion 2017 -vsEdition Professional

# Step 3 - Remaining dev tools
.\Setup-Machine.ps1 -tools -dev -data

# Step 4 - Visual Studio Extensions
.\Setup-Machine.ps1 -vsext -vsVersion 2017

