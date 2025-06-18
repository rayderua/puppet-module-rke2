# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include rke2::post
class rke2::post {
  if ( 'present' == $rke2::ensure ) {
    file { '/root/.kube':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }

    exec { 'rke2-copy-kubeconfig':
      path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/sin', '/sbin', '/bin'],
      command => 'cp /etc/rancher/rke2/rke2.yaml /root/.kube/config',
      unless  => [
        'test -s /root/.kube/config',
        'diff -q /etc/rancher/rke2/rke2.yaml /root/.kube/config',
      ],
      onlyif  => [
        'test -f /etc/rancher/rke2/rke2.yaml',
      ],
      require => [
        File['/root/.kube'],
        File['/etc/rancher/rke2/config.yaml'],
        Service[$rke2::__service_name]
      ]
    }
  }

  file { '/root/.kube/config':
    ensure => $rke2::ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
}
