require 'spec_helper'
require 'shared_contexts'

describe 'chrony' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let (:facts) {
        facts.merge({
          :chrony_version => '3.2',
        })
      }

      it do
        is_expected.to contain_package('chrony')
            .with({
              :ensure => 'installed',
            })
      end

      it do
        is_expected.to contain_file('/run/chrony-helper')
            .with({
              :ensure  => 'directory',
              :seltype => 'chronyd_var_run_t',
            })
      end

      it do
        is_expected.to contain_file('/etc/chrony.conf')
            .that_requires('Package[chrony]')
      end

      it do
        is_expected.to contain_service('chronyd')
            .with({
              :ensure => 'running',
              :enable => true,
            })
      end
    end
  end

end
