# == Class: chrony
#
# Manages the chronyd NTP client/server daemon.
#
# === Parameters
#
# Document parameters here.
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
# [*servers*]
#   A list of NTP servers and options for those servers. (It is not necessary
#   to specify the offline option; this can be done with the offline
#   parameter.)
#   Default: Array of public NTP servers, depending on $::osfamily
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
#
class chrony (
  $bindcmdaddress    = $chrony::params::bindcmdaddress,
  $client_allow      = $chrony::params::client_allow,
  $client_deny       = $chrony::params::client_deny,
  $client_log        = $chrony::params::client_log,
  $config            = $chrony::params::config,
  $config_template   = $chrony::params::config_template,
  $driftfile         = $chrony::params::driftfile,
  $keys_file         = $chrony::params::keys_file,
  $log_dir           = $chrony::params::log_dir,
  $offline           = $chrony::params::offline,
  $package_ensure    = $chrony::params::package_ensure,
  $package_name      = $chrony::params::package_name,
  $refclock          = $chrony::params::refclock,
  $rtconutc          = $chrony::params::rtconutc,
  $serve_ntp         = $chrony::params::serve_ntp,
  $servers           = $chrony::params::servers,
  $service_hasstatus = $chrony::params::service_hasstatus,
  $service_enable    = $chrony::params::service_enable,
  $service_ensure    = $chrony::params::service_ensure,
  $service_manage    = $chrony::params::service_manage,
  $service_name      = $chrony::params::service_name,
  $source_port       = $chrony::params::source_port,
  $stratumweight     = $chrony::params::stratumweight,
  $sync_local_clock  = $chrony::params::sync_local_clock,
  $udlc              = $chrony::params::udlc,
) inherits chrony::params {
  validate_array($bindcmdaddress)
  validate_array($client_allow)
  validate_array($client_deny)
  validate_bool($client_log)
  validate_absolute_path($config)
  validate_string($config_template)
  validate_absolute_path($driftfile)
  validate_absolute_path($keys_file)
  validate_absolute_path($log_dir)
  validate_bool($offline)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_array($refclock)
  validate_bool($rtconutc)
  validate_bool($serve_ntp)
  validate_array($servers)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name)
  validate_string($source_port)
  validate_bool($sync_local_clock)
  validate_bool($udlc)

  anchor { 'chrony::begin': } ->
  class { '::chrony::install': } ->
  class { '::chrony::config': } ->
  class { '::chrony::service': } ->
  anchor { 'chrony::end': }
}
