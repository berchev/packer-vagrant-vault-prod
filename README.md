# packer-vagrant-vault-prod
Packer template used to build vagrant box with
- latest version of Vault, runing as systemd service
- Vault configuration placed in `/etc/vault.d/vault.hcl`
- Vault Backend used is `file`
- Vault listening on all IPs (0.0.0.0:8200)
- Vault TLS disabled
- Vault data directory `/vaultDataDir`

## Requirements
- Packer installed
- Virtualbox installed
- VMware Workstation installed

## Instructions
`git clone https://github.com/berchev/packer-vagrant-vault-prod.git`
`cd packer-vagrant-vault-prod`
`packer build vault64.json`

## Kitchen test results
```
Target:  ssh://vagrant@127.0.0.1:2200

  Service vault
     ✔  should be installed
     ✔  should be enabled
     ✔  should be running
  File /usr/local/bin/vault
     ✔  should exist
  Command: `vault`
     ✔  should exist
  File /etc/vault.d/vault.hcl
     ✔  should exist
     ✔  should be file
     ✔  owner should eq "vault"
     ✔  group should eq "vault"
     ✔  mode should cmp == "0640"
  File /vaultDataDir
     ✔  should exist
     ✔  should be directory
     ✔  owner should eq "vault"
     ✔  group should eq "vault"

Test Summary: 14 successful, 0 failures, 0 skipped
       Finished verifying <default-vault64-vbox> (0m1.20s).
-----> Verifying <default-vault64-vmware>...
[2019-07-24T15:27:29+03:00] WARN: DEPRECATION: InSpec Attributes are being renamed to InSpec Inputs to avoid confusion with Chef Attributes. Use --input-file on the command line instead of --attrs.
       Loaded tests from {:path=>".home.gberchev.spreadsheet.packer.packer-vagrant-vault-prod.test.integration.default"} 
[2019-07-24T15:27:29+03:00] WARN: DEPRECATION: The service `be_running?` matcher is deprecated. This is only allowed for compatibility with ServerSpec (used at /home/gberchev/spreadsheet/packer/packer-vagrant-vault-prod/test/integration/default/check_pkg.rb:5)

Profile: tests from {:path=>"/home/gberchev/spreadsheet/packer/packer-vagrant-vault-prod/test/integration/default"} (tests from {:path=>".home.gberchev.spreadsheet.packer.packer-vagrant-vault-prod.test.integration.default"})
Version: (not specified)
Target:  ssh://vagrant@127.0.0.1:2201

  Service vault
     ✔  should be installed
     ✔  should be enabled
     ✔  should be running
  File /usr/local/bin/vault
     ✔  should exist
  Command: `vault`
     ✔  should exist
  File /etc/vault.d/vault.hcl
     ✔  should exist
     ✔  should be file
     ✔  owner should eq "vault"
     ✔  group should eq "vault"
     ✔  mode should cmp == "0640"
  File /vaultDataDir
     ✔  should exist
     ✔  should be directory
     ✔  owner should eq "vault"
     ✔  group should eq "vault"

Test Summary: 14 successful, 0 failures, 0 skipped
       Finished verifying <default-vault64-vmware> (0m1.61s).
-----> Kitchen is finished. (0m4.25s)
```
