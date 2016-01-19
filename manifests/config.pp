class chrony::config inherits chrony {
  file { $config:
    ensure   => file,
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    content  => template($config_template),
    notify   => Service['chrony'],
  }
}
