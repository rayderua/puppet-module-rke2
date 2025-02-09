# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include rke2::install
class rke2::install {
  assert_private()

  $__binary_url = "https://github.com/rancher/rke2/releases/download/v${rke2::version}%2Brke2r1/rke2.linux-amd64"

  # Install rke2 binary
  archive { '/usr/local/bin/rke2':
    source        => $__binary_url,
    ensure        => $rke2::ensure,
    checksum      => $rke2::checksum,
    checksum_type => 'sha256',
    cleanup       => false,
    creates       => '/usr/local/bin/rke2',
    notify        => $rke2::__notify,
  }

  file { '/usr/local/bin/rke2':
    ensure  => $rke2::ensure,
    mode    => '0755',
    require => Archive['/usr/local/bin/rke2'],
    notify        => $rke2::__notify,
  }

  # Install rke2 scripts
  ['rke2-killall.sh', 'rke2-uninstall.sh'].each | String $__script | {
    file { "/usr/local/bin/${__script}":
      ensure  => $rke2::ensure,
      mode    => '0755',
      source  => "puppet:///modules/${module_name}/bin/${__script}",
    }
  }

  # Create required directonries
  if ( 'present' == $rke2::ensure ) {
    file { [
      '/etc/rancher',
      '/etc/rancher/rke2',
      '/var/lib/rancher',
      '/var/lib/rancher/rke2',
      '/var/lib/rancher/rke2/server',
      '/var/lib/rancher/rke2/server/manifests',
      '/var/lib/rancher/rke2/agent',
      '/var/lib/rancher/rke2/agent/images',
    ]:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }
  }

  systemd::unit_file { "${rke2::__service_name}.service":
    source => "puppet:///modules/${module_name}/systemd/${rke2::__service_name}.service",
    notify => $rke2::__notify,
  }

  file { '/etc/profile.d/rke2.sh':
    ensure => $rke2::ensure,
    source => "puppet:///modules/${module_name}/etc/profile.sh",
  }
}
