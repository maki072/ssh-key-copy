<<<<<<< HEAD
# ssh-key-copy
=======
SSH Key Copy Script
This PowerShell script automates the process of copying an SSH public key to a remote server and setting up key-based authentication. It is designed to work with the built-in OpenSSH client in Windows 11.
Features

Copies the public key (id_ed25519.pub) to the remote server's ~/.ssh/authorized_keys.
Sets correct permissions on the server (chmod 700 ~/.ssh, chmod 600 ~/.ssh/authorized_keys).
Tests key-based authentication to ensure successful setup.
Uses only native Windows 11 tools (OpenSSH client).

Requirements

Windows 11 with the OpenSSH client enabled (included by default).
An SSH key pair generated at ~/.ssh/id_ed25519 (use ssh-keygen -t ed25519 to generate one if needed).
Access to the target server via SSH with password authentication.

Usage

Save the script as ssh-key-copy.ps1.
Open a PowerShell terminal.
Run the script:.\ssh-key-copy.ps1


Enter the server address (e.g., example.com or 192.168.1.100).
Enter the username for the remote server.
When prompted, enter the password for the initial SSH connection.
The script will copy the public key and test key-based authentication.

Notes

The script assumes the SSH key is located at ~/.ssh/id_ed25519.pub. If using a different key, modify the $publicKeyPath variable.
Ensure the remote server has PubkeyAuthentication yes and AuthorizedKeysFile .ssh/authorized_keys in /etc/ssh/sshd_config.
If the key-based authentication test fails, check server permissions and SSH configuration as suggested in the script's output.

Troubleshooting

If the script prompts for a password during key copying, this is expected for the initial connection.
For debugging, run the SSH command manually with verbose output:ssh -v -i "$env:USERPROFILE\.ssh\id_ed25519" <username>@<server>


Ensure the private key (id_ed25519) has restricted permissions:icacls "$env:USERPROFILE\.ssh\id_ed25519" /inheritance:r
icacls "$env:USERPROFILE\.ssh\id_ed25519" /grant:r "$env:USERNAME:F"



License
This script is provided under the MIT License. See LICENSE for details.
Credits
This script and its accompanying documentation were generated with the assistance of Grok 3, created by xAI.
>>>>>>> 158f2aa (Added Readme)
