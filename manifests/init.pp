# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include rke2
#
#   @param ensure
#   if we ensure the rke2 present or absent.
#
#   @param version
#   rke2 version
#
#   @param checksum
#   Specifies sha256 checksum of rke2 binnary downloaded from github
#
#   @param service_ensure
#   Ensure rke2 service (agent or server) is running/stopped
#
#   @param service_enable
#   Enable/Disable rke2 service (agent or server)
#
#   @param service restart
#   Specifies if service will be restarted after config or files changed
#
#   @param service_envs
#   Environment variables for running service
#
#   @param run_mode
#   Running mode agent/server for rke2
#
#   @param manifes
#   Specifies additional manifests generated
#
#   @param config
#   rke2 agent/server config parameters
#

class rke2 (
  Enum['present','absent']  $ensure,
  String                    $version,
  String                    $checksum,
  Enum['running','stopped'] $service_ensure,
  Boolean                   $service_enable,
  Boolean                   $service_restart,
  Hash                      $service_envs,
  Enum['agent', 'server']   $run_mode,
  Hash                      $manifests,
  Hash                      $config,
) {
  if ( $rke2::run_mode == 'server' ) {
    $__service_name = 'rke2-server'
  } else {
    $__service_name = 'rke2-agent'
  }

  if ( 'present' == $ensure and true == $service_restart ) {
    $__notify = [Service[$__service_name]]
  } else {
    $__notify = undef
  }

  include archive
  include systemd

  contain rke2::install
  contain rke2::config
  contain rke2::service
  contain rke2::post

  Class['rke2::install']
  -> Class['rke2::config']
  -> Class['rke2::service']
  -> Class['rke2::post']
}
