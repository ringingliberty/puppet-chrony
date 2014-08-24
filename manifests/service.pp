class chrony::service inherits chrony {
  if ! ($service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if $service_manage == true {
    service { 'chrony':
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => $service_name,
      hasstatus  => $service_hasstatus,
      hasrestart => true,
      require    => Package[$package_name],
    }
  }
}
