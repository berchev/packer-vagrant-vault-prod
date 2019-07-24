# Check vault service
describe service('vault') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Check if vault is located into specific path
describe file('/usr/local/bin/vault') do
  it { should exist }
end

# Check if command vault is available
describe command('vault') do
  it { should exist }
end

# Check if vault configuration exists
describe file('/etc/vault.d/vault.hcl') do
  it { should exist }
  it { should be_file }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
  its('mode') { should cmp '0640' }

end

# Check if vault data directory exists
describe file('/vaultDataDir') do
  it { should exist }
  it { should be_directory }
  its('owner') { should eq 'vault' }
  its('group') { should eq 'vault' }
end
