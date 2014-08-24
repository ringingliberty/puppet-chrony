class chrony::install inherits chrony {
  package { 'chrony':
    ensure => $package_ensure,
    name   => $package_name,
  }
}
