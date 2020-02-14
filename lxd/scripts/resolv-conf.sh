#!/usr/bin/env bash
set -o errexit

source /tmp/__common-lib.sh

main() {
  export DEBIAN_FRONTEND='noninteractive'
  call_build_function func_name="__resolvconf_install"
}

__resolvconf_install() {
  systemctl stop systemd-resolved
  systemctl mask systemd-resolved
  rm -f "/etc/resolv.conf"
  touch "/etc/resolv.conf"
  chmod 644 "/etc/resolv.conf"
  call_build_function func_name="__resolvconf_get_content" >> "/etc/resolv.conf"
}

__resolvconf_get_content(){
  echo "
options rotate
options timeout:1

nameserver 9.20.136.11
nameserver 9.20.136.25
nameserver 9.0.130.50
nameserver 9.0.128.50
nameserver 9.12.16.2
nameserver 8.8.8.8
"
}

__resolvconf_get_content_optional(){
  echo "options timeout:10
nameserver 9.20.136.11
nameserver 9.20.136.25
nameserver 9.0.130.50
nameserver 9.0.128.50
nameserver 9.12.16.2
nameserver 8.8.8.8
"
}

__resolvconf_get_content_ppc64le(){
  __resolvconf_get_content_optional
}

__resolvconf_get_content_s390x(){
  __resolvconf_get_content_optional
}

__resolvconf_get_content_aarch64(){
  __resolvconf_get_content_optional
}

main "$@"
