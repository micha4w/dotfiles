#!/usr/bin/env bash

openconnect sslvpn.ethz.ch/student-net --useragent=AnyConnect -u miwehrli@student-net.ethz.ch --passwd-on-stdin \
  <<< "$(systemd-creds cat ethz)
$(oathtool --totp --base32 "$(systemd-creds cat ethz-totp)")" \
  | {
      trap '' SIGINT
      while read -r line
      do
        echo $line
        [[ $line == 'Using vhost-net for tun acceleration'* ]] && break
      done

      systemd-notify --ready --status 'ready'
      cat
    }

status=${PIPESTATUS[0]} 
exit $status
