# Set UTF-8 encoding for output
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Prompt for server and username
$server = Read-Host "Enter the server address (e.g., example.com or 192.168.1.100)"
$username = Read-Host "Enter the username"

# Path to the public key
$publicKeyPath = "$env:USERPROFILE\.ssh\id_ed25519.pub"

# Check if the public key exists
if (-not (Test-Path $publicKeyPath)) {
    Write-Error "❌ Public key not found at $publicKeyPath. Please generate a key pair using ssh-keygen."
    exit 1
}

# Read the public key content
$publicKey = Get-Content -Path $publicKeyPath -Raw

# Escape single quotes POSIX-style for remote shell
$escapedPublicKey = $publicKey -replace "'", "'\\''"

# Compose SSH commands as multi-line text
$sshCommandRaw = @"
mkdir -p ~/.ssh && chmod 700 ~/.ssh
grep -qxF '{0}' ~/.ssh/authorized_keys 2>/dev/null || echo '{0}' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
"@ -f $escapedPublicKey

# Convert to one-liner for SSH execution
$sshCommand = [Regex]::Replace($sshCommandRaw, "\r?\n", "; ")

try {
    Write-Host "`n>>> Copying the public key to $username@$server ..."
    Write-Host "Please enter the password when prompted."
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $username@$server "$sshCommand"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "`n❌ Failed to copy the public key to the server. Please check SSH access and login credentials."
        exit 1
    }

    Write-Host "`n✅ Public key successfully copied to $server."

    # Test key-based authentication
    Write-Host "`n>>> Testing key-based authentication ..."
    $testResult = ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 -i "$env:USERPROFILE\.ssh\id_ed25519" $username@$server "echo OK" 2>&1

    if ($LASTEXITCODE -eq 0 -and $testResult -match "OK") {
        Write-Host "`n✅ Key-based authentication was successful."
    } else {
        Write-Error "`n❌ Key-based authentication failed. Error: $testResult"
        Write-Host "`nRecommendations:"
        Write-Host "- Ensure correct permissions on the server: chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"
        Write-Host "- Check that PubkeyAuthentication is enabled in /etc/ssh/sshd_config"
        Write-Host "- Try connecting manually: ssh -i $env:USERPROFILE\.ssh\id_ed25519 $username@$server"
        exit 1
    }
}
catch {
    Write-Error "`n❌ An unexpected error occurred: $_"
    exit 1
}