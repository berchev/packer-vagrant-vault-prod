#!/usr/bin/env bash

# Install latest version of vault
pushd /usr/local/bin
VAULT_URL=$(curl https://releases.hashicorp.com/index.json | jq '{vault}' | egrep "linux.*amd64" | sort -r | head -1 | awk -F[\"] '{print $4}')
curl -o vault.zip ${VAULT_URL}
unzip vault.zip
rm -f vault.zip
popd

# Installing autocomplete
echo 'complete -C /usr/local/bin/vault vault' | tee -a /home/vagrant/.bashrc

# Give Vault the ability to use the mlock syscall without running the process as root. The mlock syscall prevents memory from being swapped to disk.
setcap cap_ipc_lock=+ep /usr/local/bin/vault

# Add vault user
mkdir -p /etc/vault.d
useradd --system --home /etc/vault.d --shell /bin/false vault

# Add vault configuration file
cat > /etc/vault.d/vault.hcl << EOF
backend "file" {
path = "/vaultDataDir"
}
listener "tcp" {
address = "0.0.0.0:8200"
tls_disable = 1
}

# Enable UI
ui = true
EOF

# Vault user owns the files inside this dir.
chown -R vault:vault /etc/vault.d
chmod 640 /etc/vault.d/vault.hcl

# Create data dir for Vault
mkdir -p /vaultDataDir
chown vault:vault /vaultDataDir

# Createting System D service for vault
cat > /etc/systemd/system/vault.service << EOF
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl
[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitInterval=60
StartLimitBurst=3
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

# Start Vault
systemctl daemon-reload
systemctl enable vault
systemctl start vault

apt-get autoremove -y
apt-get clean

# Removing leftover leases and persistent rules
rm /var/lib/dhcp/*

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
