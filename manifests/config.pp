# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include rke2::config
class rke2::config (

) inherits rke2 {
  assert_private()

  file { "/etc/default/${::rke2::__service_name}":
    ensure  => $rke2::ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => epp("${module_name}/default.epp", { 'envs' => $rke2::service_envs }),
    notify  => $rke2::__notify,
  }

  file { "/etc/rancher/rke2/config.yaml":
    ensure  => $rke2::ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => epp("${module_name}/config.epp", { 'config' => $rke2::config }),
    notify  => $rke2::__notify,
  }

  ensure_resources ('rke2::manifest', $rke2::manifests)
}
