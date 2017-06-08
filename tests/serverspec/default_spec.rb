require "spec_helper"
require "serverspec"

ports = []
default_user = "root"
default_group = "root"

case os[:family]
when "freebsd"
  default_group = "wheel"
when "openbsd"
  default_group = "wheel"
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
when "ubuntu"
  describe file("/etc/default/nfs-common") do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/^STATDOPTS=""$/) }
    its(:content) { should match(/^NEED_GSSD="no"$/) }
    its(:content) { should match(/^NEED_STATD="yes"$/) }
    its(:content) { should match(/^NEED_IDMAPD="no"$/) }
  end

  describe file("/etc/default/rpcbind") do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/^OPTIONS="-w"$/) }
  end

  describe service("rpcbind") do
    it { should be_enabled }
    it { should be_running }
  end

  puts os[:release]
  statd_service = os[:release].to_f >= 16.04 ? "rpc-statd" : "statd"
  describe service(statd_service) do
    it { should be_enabled }
    it { should be_running }
  end
end

describe file("/etc/fstab") do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by default_user }
  it { should be_grouped_into default_group }
  its(:content) { should match(%r{^#{Regexp.escape("127.0.0.1:/exports/foo")}\s+\/mnt\s+nfs\s+ro\s+0\s+0}) }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
