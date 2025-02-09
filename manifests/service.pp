# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include rke2::service
class rke2::service {
  if ( 'server' == $rke2::run_mode ) {
    $__disabled_service = 'rke2-agent'
  } else {
    $__disabled_service = 'rke2-server'
  }

  service { $__disabled_service:
    ensure => stopped,
    enable => false
  }

  service { $rke2::__service_name:
    ensure  => $rke2::service_ensure,
    enable  => $rke2::service_enable,
    require => Systemd::Daemon_reload["$rke2::__service_name.service"]
  }
}
