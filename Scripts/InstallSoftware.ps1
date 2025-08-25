# 1. Make sure the Microsoft App Installer is installed:
#    https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1
# 2. Edit the list of apps to install.
# 3. Run this script as administrator.

Write-Output "Installing Apps"
$apps = @(
    @{name = "ElectronicArts.EADesktop" },
    @{name = "Git.Git" },
    @{name = "GitHub.GitHubDesktop" },
    @{name = "Google.Chrome" },
    @{name = "Microsoft.OneDrive" },
    @{name = "Microsoft.PowerShell" },
    @{name = "Microsoft.VisualStudio.2022.Enterprise" },
    @{name = "Notepad++.Notepad++" },
    @{name = "Notion.Notion" },
    @{name = "Valvel.Steam" },
    # @{name = "Microsoft.Azure.StorageExplorer" },
    # @{name = "Microsoft.AzureDataStudio" }, # Retiring on February 28, 2026
    # @{name = "Microsoft.DotNet.SDK.9" },
    # @{name = "Microsoft.NuGet" },
    #@{name = "Microsoft.PowerShell" },
    @{name = "Microsoft.PowerToys" },
    # @{name = "Microsoft.Sysinternals.ZoomIt" }, # Now included in PowerToys
    # @{name = "Microsoft.VisualStudio.2022.Community" }, # Still requires configuration using the Visual Studio Installer
    @{name = "Microsoft.VisualStudioCode" },
    #@{name = "Mozilla.Firefox.DeveloperEdition" },
    @{name = "Mozilla.Firefox" },
    # @{name = "namazso.OpenHashTab" },
    #@{name = "NickeManarin.ScreenToGif" },
    # @{name = "Notepad++.Notepad++" },    
);

Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing: " $app.name
        winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name 
    }
    else {
        Write-host "Skipping: " $app.name " (already installed)"
    }
}
