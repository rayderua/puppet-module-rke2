# rke2

### Description
Install and manage rke2-server / rke2-agent on nodes

### Setup
```commandline
include rke2
```

### Default config

```yaml
# Defaults (see data/common.yaml in module)
rke2::version: 1.31.3
rke2::checksum: b7c60e3fc7397179abdba173d6f91e571caa7c7035ac7b3db7c347209049b4ec
rke2::ensure: present
rke2::run_mode: server
rke2::service_ensure: running
rke2::service_enable: true
rke2::service_restart: false
rke2::service_envs:
  HOME: /root
rke2::config:
  ingress-controller: ingress-nginx
  tls-san:
    - "%{facts.networking.hostname}.%{facts.networking.domain}"
```

### Define additional manifests
```yaml
rke2::manifests:
  link-to-manifest:
    link: "<Url for download manifest file>"
  content-of-manifest:
    content: |
      # manifest content
      ---
      apiVersion: v1
      kind: Pod
      metadata: {}
  source-of-manifest:
    source: "puppet:///<Path to your manfest>"
  config-manifest-as-hash:
    config: 
      apiVersion: v1
      kind: Pod
      metadata: {}
  config-manifest-as-arr:
    config:
      - apiVersion: v1
        kind: Pod
        metadata: {}
      - apiVersion: v1
        kind: Pod
        metadata: {}
```