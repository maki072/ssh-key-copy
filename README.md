🌟 SSH Key Copy Script
This PowerShell script simplifies copying an SSH public key to a remote server and setting up key-based authentication. Built for Windows 11, it leverages the native OpenSSH client for seamless operation. 🚀
✨ Features

📋 Copies the SSH public key (id_ed25519.pub) to the remote server's ~/.ssh/authorized_keys.
🔒 Configures correct permissions on the server (chmod 700 ~/.ssh, chmod 600 ~/.ssh/authorized_keys).
✅ Tests key-based authentication to confirm successful setup.
🛠 Uses only built-in Windows 11 tools (OpenSSH client).

📋 Requirements

Windows 11 with the OpenSSH client enabled (included by default).
An SSH key pair at ~/.ssh/id_ed25519 (generate with ssh-keygen -t ed25519 if needed).
SSH access to the target server with password authentication.
PowerShell script execution enabled (see instructions below).

⚙️ Enabling PowerShell Script Execution
By default, Windows restricts running PowerShell scripts for security. To enable script execution:

Open PowerShell as Administrator.
Check the current execution policy:Get-ExecutionPolicy


If set to Restricted, change it to allow scripts: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned


Confirm with Y when prompted.

⚠️ Security Warning: Changing the execution policy to RemoteSigned allows running unsigned scripts, which can pose a security risk. Only run scripts from trusted sources. To revert to a safer policy after use:
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted

🚀 Usage

Save the script as ssh-key-copy.ps1.
Open a PowerShell terminal.
Run the script:.\ssh-key-copy.ps1


Enter the server address (e.g., example.com or 192.168.1.100).
Provide the username for the remote server.
When prompted, enter the password for the initial SSH connection.
The script will copy the public key and verify key-based authentication. ✅

📝 Notes

The script assumes the SSH key is at ~/.ssh/id_ed25519.pub. Modify $publicKeyPath if using a different key.
Ensure the remote server has PubkeyAuthentication yes and AuthorizedKeysFile .ssh/authorized_keys in /etc/ssh/sshd_config.
If key-based authentication fails, check server permissions and SSH configuration as suggested in the script's output.

🛠 Troubleshooting

Password prompt during key copying: Expected for the initial connection.
Debugging: Run the SSH command manually with verbose output:ssh -v -i "$env:USERPROFILE\.ssh\id_ed25519" <username>@<server>


Key permissions: Ensure the private key (id_ed25519) has restricted permissions:icacls "$env:USERPROFILE\.ssh\id_ed25519" /inheritance:r
icacls "$env:USERPROFILE\.ssh\id_ed25519" /grant:r "$env:USERNAME:F"



📜 License
This script is provided under the MIT License. See LICENSE for details.
🙌 Credits
This script and its documentation were generated with the assistance of Grok 3, created by xAI. 🚀