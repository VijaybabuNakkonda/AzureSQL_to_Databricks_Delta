# Set variables for your server and database

$subscriptionId = 'be95106b-e57f-4d40-bcdd-1944f07d035f'
#$resourceGroupName = "myResourceGroup-$(Get-Random)"
$resourceGroupName="rg-we-analytics-dev"
$location = "West Europe"
$adminLogin = "sqladmin"
$password = "Tiger123"
#$serverName = "mysqlserver-$(Get-Random)"
$serverName="SqlSrv-Nklabs"
$databaseName = "Adventureworks"

# The ip address range that you want to allow to access your server 
# (leaving at 0.0.0.0 will prevent outside-of-azure connections to your DB)
$startIp = "0.0.0.0"
$endIp = "0.0.0.0"

# Show randomized variables
Write-host "Resource group name is" $resourceGroupName 
Write-host "Password is" $password  
Write-host "Server name is" $serverName 

# Connect to Azure
Connect-AzAccount

# Set subscription ID
Set-AzContext -SubscriptionId $subscriptionId 

# Create a resource group
Write-host "Creating resource group..."
#$resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag @{Owner="SQLDB-Samples"}
$resourceGroup

# Create a server with a system wide unique server name
Write-host "Creating primary logical server..."
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -Location $location `
   -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential `
   -ArgumentList $adminLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
$server

# Create a server firewall rule that allows access from the specified IP range
Write-host "Configuring firewall for primary logical server..."
$serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp
$serverFirewallRule

# Create General Purpose Gen4 database with 1 vCore
Write-host "Creating a gen5 2 vCore database..."
$database = New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -DatabaseName $databaseName `
   -Edition GeneralPurpose `
   -VCore 2 `
   -ComputeGeneration Gen5 `
   -MinimumCapacity 2 `
   -SampleName "AdventureWorksLT"
$database