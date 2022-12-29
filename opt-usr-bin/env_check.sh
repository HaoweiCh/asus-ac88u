#! /opt/bin/bash


# 应该在 router 上执行以下环境检测

###
# Service Start

if [ ! -e /jffs/scripts/services-start ]; then
    cat <<'HEREDOC' > /jffs/scripts/services-start
#!/bin/sh

RC='/opt/etc/init.d/rc.unslung'

i=30
until [ -x "$RC" ] ; do
  i=$(($i-1))
  if [ "$i" -lt 1 ] ; then
    logger "Could not start Entware"
    exit
  fi
  sleep 1
done
$RC start
HEREDOC
fi

chmod +x /jffs/scripts/services-start

###
# function

function add_service {
    [ -e /jffs/scripts/$1 ] || echo '#!/bin/sh' > /jffs/scripts/$1
    chmod +x /jffs/scripts/$1
    fgrep -qs -e "$2" /jffs/scripts/$1 || echo "$2" >> /jffs/scripts/$1
}

# 每隔 3 分钟检测下所有的服务是否运行, 以及 iptables rule 是否失效.
add_service wan-start 'cru a run-services "*/3 * * * * /jffs/scripts/services-start"'
add_service wan-start 'cru a run-iptables "*/3 * * * * /opt/etc/apply_iptables_rule.sh"'
# 每个周日的 5: 25 升级一次 geosites 数据.
add_service wan-start 'cru a update_geosites "25 5 * * 0 /opt/etc/update_geosite.sh"'

# 如果 DHCP 重新分配 IP 地址时, 会清除 iptables rule, 此时重新应用 iptables
add_service dhcpc-event '/opt/etc/apply_iptables_rule.sh'
add_service services-start '[ -f /tmp/patch_router_was_run_at ] || /opt/etc/patch_router'
/jffs/scripts/wan-start

mkdir -p /opt/usr/bin /opt/usr/sbin

chmod +x\
  /opt/etc/apply_iptables_rule.sh \
  /opt/etc/clean_iptables_rule.sh \
  /opt/etc/update_geosite.sh \
  /opt/etc/restart_dnsmasq.sh \
  /opt/etc/toggle_proxy.sh \
  /opt/etc/patch_router \
  /jffs/scripts/services-start
