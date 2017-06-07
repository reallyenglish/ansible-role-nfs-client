require "spec_helper"
require "serverspec"

ports   = []
package = ""
default_user = "root"
default_group = "root"

case os[:family]
when "freebsd"
  default_group = "wheel"
end

case os[:family]
when /bsd$/
else
  describe package(package) do
    it { should be_installed }
  end
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/lockd") do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/^rpc_lockd_enable="YES"$/) }
    its(:content) { should match(/^rpc_lockd_flags="-h 10\.0\.2\.15"$/) }
  end

  describe service("lockd") do
    it { should be_running }
  end

  describe file("/etc/rc.conf.d/statd") do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/^rpc_statd_enable="YES"$/) }
    its(:content) { should match(/^rpc_statd_flags="-h 10\.0\.2\.15"$/) }
  end

  describe service("statd") do
    it { should be_running }
  end

  describe command("service rpcbind onestatus") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^rpcbind is running as pid \d+\.$/) }
    its(:stderr) { should eq "" }
  end
end

describe file("/etc/fstab") do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by default_user }
  it { should be_grouped_into default_group }
  its(:content) { should match(/^#{Regexp.escape("127.0.0.1:/exports/foo")}\s+\/mnt\s+nfs\s+ro\s+0\s+0/) }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
