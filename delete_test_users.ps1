$token = '<Management API Token Here>'
$headers = @{ Authorization = "Bearer $token" }
$response = (Invoke-WebRequest `
	-Uri "https://merthin0.auth0.com/api/v2/users?per_page=100&fields=email%2Cuser_id" `
	-Method 'GET' `
	-Headers $headers) | ConvertFrom-Json
	
$testUsers = $response.Where({$_.email.StartsWith('user') -or $_.email.StartsWith('testuser')})	

Write-Host 'Listing test users'	
Foreach ($user in $testUsers) {
	Write-Host $user.email
}

$confirmation = Read-Host "Are you sure you want to delete them (y/n)?"
if ($confirmation -eq 'y') {
	Foreach ($user in $testUsers) {	
		$id = [System.Web.HttpUtility]::UrlEncode($user.user_id)  
		Invoke-WebRequest `
			-Uri "https://merthin0.auth0.com/api/v2/users/$id" `
			-Method 'DELETE' `
			-Headers $headers
	}    
}
