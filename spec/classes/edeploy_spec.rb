# spec/classes/edeploy_spec.pp

require 'spec_helper'

describe 'edeploy' do

  context 'RHEL platform' do

    let(:facts) do
      {'osfamily' => 'RedHat',}
    end

    it 'includes stdlib' do
      should include_class('stdlib')
    end

    it 'includes epel' do
      should include_class('epel')
    end

  end

  context 'Debian platform' do

    let(:facts) do
      {'osfamily' => 'Debian',}
    end

    it 'includes stdlib' do
      should include_class('stdlib')
    end

  end

end
