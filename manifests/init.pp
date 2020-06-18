# == Class: chrony
#
# Manages the chronyd NTP client/server daemon.
#
# === Parameters
#
# Document parameters here.
#
# [*packages*]
#   List of packages to install.
#
# [*package_ensure*]
#   Set to 'installed' or 'latest'
#
# [*bindaddress*]
#   Restrict the network interface to which chronyd will listen for NTP client
#   requests.
#   Default: [ '127.0.0.1', '::1' ]
#
# [*bindcmdaddress*]
#   Restrict the network interface to which chronyd will listen for command
#   packets (issued by chronyc).
#   Default: [ '127.0.0.1', '::1' ]
#
# [*client_allow*]
#   Designate subnets from which NTP clients are allowed to access the
#   computer as an NTP server. IPv4 and IPv6 CIDR ranges can be specified.
#   Default: []
#
# [*client_deny*]
#   Designate subnets within previously allowed subnets which are denied
#   to access the NTP server. IPv4 and IPv6 CIDR ranges can be specified.
#   Default: []
#
# [*client_log*]
#   Whether to log statistics about NTP clients.
#   Default: false
#
# [*cmdport*]
#   The port that chronyd will listen for control packets. Set to 0 to
#   disable listening for control packets. This does not affect listening
#   for control packets on a Unix socket. By default (and when unspecified)
#   chronyd uses udp/323.
#   Default: undef
#
# [*offline*]
#   Whether the NTP client should start in offline mode. In this mode, clients
#   must issue the chronyc online command to begin synchronization (though
#   most systems with a GUI will manage to do this automatically). Useful for
#   laptops and other intermittently connected devices.
#   Default: false
#
# [*refclock*]
#   Specify one or more reference clocks to which chrony should obtain time
#   information to act as a stratum 1 server. See the chrony documentation
#   for details.
#   Default: []
#
# [*config_file*]
#   Path to the chrony configuration file.  Defaults to '/etc/chrony.conf' which
#   is the file path used in Redhat based systems.
#
# [*config_template*]
#   Config file template to use.
#
# [*driftfile*]
#   File to store NTP drift data.
#
# [*keys_file*]
#   File to stre NTP keys.
#
# [*log_dir*]
#   Log directory for chrony logs.
#
# [*rtconutc*]
#   Whether the computer's onboard real-time clock is set to UTC. Set to false
#   if the RTC is in local time, such as a system which boots multiple
#   operating systems.
#   Default: true
#
# [*serve_ntp*]
#   Whether to enable the NTP server functionality. If disabled, chrony will
#   act only as an NTP client.
#   Default: false
#
# [*services*]
#   List of services to manage.
#
# [*service_enable*]
#   Defines whether the chrony service is enabled.  Defaults to true.
#
# [*service_ensure*]
#   Defines the running state of the chrony service.  Defaults to 'running'.
#
# [*service_manage*]
#   Determines if the chrony service should be managed by puppet.  Defaults to true.
#
# [*service_hasstatus*]
#   Defines if the service has a status function.  Defaults to true.
#
# [*source_port*]
#   Select a fixed source port for outgoing NTP packets. By default, the
#   source port is dynamically assigned by the operating system.
#   Default: undef
#
# [*sync_local_clock*]
#   Keep the computer's hardware clock in sync.
#   Default: true
#
# [*udlc*]
#   Allow the server to operate without synchronization to an external time
#   source (undisciplined local clock).
#   Default: false
#
# [*stratumweight*]
#   Set the default stratum weight.
#
# [*iburst*]
#   Defines whether to use iburst mode.  Defaults to true.
#
# [*servers*]
#   A list of NTP servers and options for those servers. (It is not necessary
#   to specify the offline option; this can be done with the offline
#   parameter.)
#   Default: Array of public NTP servers, depending on $::osfamily
#
# === Examples
#
#  class { chrony:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Michael Hampton <puppet@ringingliberty.com>
#
# === Copyright
#
# Copyright 2014 Michael Hampton, unless otherwise noted.

class chrony (
  Array[String] $packages                   = ['chrony'],
  String $package_ensure                    = 'installed',
  Array[String] $bindaddress                = [ '127.0.0.1', '::1' ],
  Array[String] $bindcmdaddress             = [ '127.0.0.1', '::1' ],
  Array[String] $client_allow               = [],
  Array[String] $client_deny                = [],
  Boolean $client_log                       = false,
  Optional[Integer] $cmdport                = undef,
  Boolean $offline                          = false,
  Array[String] $refclock                   = [],
  String $config_file                       = '/etc/chrony.conf',
  String $config_template                   = 'chrony/chronyd.conf.erb',
  String $driftfile                         = '/var/lib/chrony/drift',
  String $keys_file                         = '/etc/chrony.keys',
  String $log_dir                           = '/var/log/chrony',
  Boolean $rtconutc                         = true,
  Boolean $serve_ntp                        = false,
  Array[String] $services                   = ['chronyd'],
  Boolean $service_enable                   = true,
  String $service_ensure                    = 'running',
  Boolean $service_manage                   = true,
  Boolean $service_hasstatus                = true,
  Optional[String] $source_port             = undef,
  Boolean $sync_local_clock                 = true,
  Boolean $udlc                             = false,
  Integer $stratumweight                    = 0,
  Boolean $iburst                           = true,
  Optional[Array[String]] $servers          = undef,
  ) {

  package { $packages:
    ensure => $package_ensure,
  }

  file { $config_file:
    content   => template($config_template),
    show_diff => false,
    require   => Package[$packages],
    notify    => Service[$services],
  }

  service { $services:
    ensure => $service_ensure,
    enable => $service_enable,
  }

}
