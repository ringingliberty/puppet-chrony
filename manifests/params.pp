class chrony::params {

  $bindcmdaddress   = [ '127.0.0.1', '::1' ]
  $client_allow     = []
  $client_deny      = []
  $client_log       = false
  $config_template  = 'chrony/chronyd.conf.erb'
  $offline          = false
  $package_ensure   = 'present'
  $refclock         = []
  $rtconutc         = true
  $serve_ntp        = false
  $service_enable   = true
  $service_ensure   = 'running'
  $service_manage   = true
  $source_port      = undef
  $sync_local_clock = true
  $udlc             = false

  case $::osfamily {
    'Debian': {
      $config = '/etc/chrony/chrony.conf'
      $driftfile = '/var/lib/chrony/chrony.drift'
      $keys_file = '/etc/chrony/chrony.keys'
      $log_dir = '/var/log/chrony'
      $package_name = 'chrony'
      $servers = [
        '0.debian.pool.ntp.org iburst',
        '1.debian.pool.ntp.org iburst',
        '2.debian.pool.ntp.org iburst',
        '3.debian.pool.ntp.org iburst',
      ]
      $service_name = 'chrony'
    }
    'RedHat': {
      $config = '/etc/chrony.conf'
      $driftfile = '/var/lib/chrony/drift'
      $keys_file = '/etc/chrony.keys'
      $log_dir = '/var/log/chrony'
      $package_name = 'chrony'
      $servers = [
        '0.centos.pool.ntp.org iburst',
        '1.centos.pool.ntp.org iburst',
        '2.centos.pool.ntp.org iburst',
        '3.centos.pool.ntp.org iburst',
      ]
      $service_name = 'chronyd'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
    }
  }
}
