# spec/classes/edeploy_tftpserver_spec.pp

require 'spec_helper'

describe 'edeploy::tftpserver' do

  context 'RHEL platform' do

    let(:facts) do
      {'osfamily' => 'RedHat',}
    end

    let(:params) do
      {'username'  => 'tftp',
       'address'   => '0.0.0.0',
       'directory' => '/tmp',}
    end

    it 'installs a tftp server' do
      should contain_class('tftp')
    end

    it 'installs file pxelinux.0' do
      should contain_tftp__file('pxelinux.0').with({
        'source' => 'puppet:///modules/edeploy/tftpserver/pxelinux.0',
      })
    end

    it 'creates directory pxelinux.cfg' do
      should contain_file('/tmp/pxelinux.cfg').with({
        'ensure' => 'directory',
        'owner'  => 'tftp',
        'group'  => 'tftp',
      })
    end

    it 'installs file pxelinux.cfg/default' do
      should contain_tftp__file('pxelinux.cfg/default')
    end

  end

  context 'Debian platform' do

    let(:facts) do
      {'osfamily' => 'Debian',}
    end

    let(:params) do
      {'username'  => 'tftp',
       'address'   => '0.0.0.0',
       'directory' => '/tmp',}
    end

    it 'installs a tftp server' do
      should contain_class('tftp')
    end

    it 'installs file pxelinux.0' do
      should contain_tftp__file('pxelinux.0').with({
        'source' => 'puppet:///modules/edeploy/tftpserver/pxelinux.0',
      })
    end

    it 'creates directory pxelinux.cfg' do
      should contain_file('/tmp/pxelinux.cfg').with({
        'ensure' => 'directory',
        'owner'  => 'tftp',
        'group'  => 'tftp',
      })
    end

    it 'installs file pxelinux.cfg/default' do
      should contain_tftp__file('pxelinux.cfg/default')
    end

  end

end
