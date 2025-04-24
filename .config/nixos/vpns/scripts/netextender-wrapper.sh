#!/usr/bin/env bash

nxBender --use-resolvconf -u micha.wehrli -d ad.informaticon.com -s ssl.informaticon.com -P 4433 -p "$(systemd-creds cat inf-netextender)" \
  <<< $(oathtool --totp --base32 $(systemd-creds cat inf-netextender-totp)) \
  2>&1 | {
      trap '' SIGINT
      while read -r line
      do
        echo $line
      	[[ $line == *'Remote routing configured, VPN is up'* ]] && break
      done

      systemd-notify --ready --status 'ready'
      cat
    }

status=${PIPESTATUS[0]} 
exit $status
