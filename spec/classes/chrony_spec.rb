require 'spec_helper'

describe 'chrony' do

  debian = {
    :hardwaremodels => 'x86_64',
    :supported_os   => [
      {
        'operatingsystem'        => 'Debian',
        'operatingsystemrelease' => ['8'],
      },
    ],
  }

  redhat = {
    :hardwaremodels => 'x86_64',
    :supported_os   => [
      {
        'operatingsystem'        => 'CentOS',
        'operatingsystemrelease' => ['7'],
      },
      {
        'operatingsystem'        => 'Fedora',
      },
    ],
  }

  on_supported_os(redhat).each do |os, facts|
    let(:facts) {
      facts
    }

    context "custom bindaddress on #{os}" do
      let(:params) {{
        :packages => ['chrony'],
        :bindaddress => ['127.0.0.1', '::1', '192.168.0.1'],
      }}

      it do
        is_expected.to contain_file('/etc/chrony.conf')
            .with({
              :show_diff => false,
            })
            .that_requires('Package[chrony]')
            .that_notifies('Service[chronyd]')
      end
    end
  end

  on_supported_os(redhat).each do |os, facts|
    context "on #{os}" do

      let(:facts) {
        facts.merge({
          :osfamily => 'RedHat',
        })
      }

      it do
        is_expected.to contain_package('chrony')
            .with({
              :ensure => 'installed',
            })
      end

      it do
        is_expected.to contain_file('/etc/chrony.conf')
            .that_requires('Package[chrony]')
            .that_notifies('Service[chronyd]')
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

  on_supported_os(debian).each do |os, facts|
    context "on #{os}" do
      let(:params) {{
        :packages    => ['chrony'],
        :services    => ['chrony'],
        :config_file => '/etc/chrony/chrony.conf',
      }}

      it do
        is_expected.to contain_package('chrony')
            .with({
              :ensure => 'installed',
            })
      end

      it do
        is_expected.to contain_file('/etc/chrony/chrony.conf')
            .that_requires('Package[chrony]')
      end

      it do
        is_expected.to contain_service('chrony')
            .with({
              :ensure => 'running',
              :enable => true,
            })
      end
    end
  end

end
