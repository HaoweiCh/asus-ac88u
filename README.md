
Use Asus Merlin as a router with transparent proxy

> This project is several scripts for config you ASUS router(merlin based) to serve
as a transparent forward proxy.

[中文文档](./docs)

## Feature

1. transparent proxy for all devices connect to our LAN network whether through Wi-Fi or wire.
2. use your router ports as a socks5/http proxy directly.
   * e.g. router.asus.com:2010 for http proxy
3. Ad block.

For transparent proxy, current three mode is supported, will select automatically depend on your router device.

1. tproxy mode will be used if routers support TProxy.
2. redirect mode will be used if router not support TProxy.
3. fakedns mode based on tproxy mode, it can only switch on manually.

*NOTICE*

redirect mode require dnsmasq serve as LAN DNS server, if you asus-wrt merlin, this is default mode.
others mode V2Ray and basically build tools(For use with QUIC) is the only dependency.

You can always check router if check TProxy use:

```sh
# modprobe xt_TPROXY
```

## Switch proxy mode

You can switch modes after deploy successful.

### Switch to use old redirect transparent proxy (need dnsmasq)

```sh
$: ./use_redirect_proxy admin@192.168.50.1
```

### Switch to use fakedns based transparent proxy (need TProxy support)

```sh
$: ./use_fakedns admin@192.168.50.1
```

### Switch to auto mode (default)

```sh
$: ./use_auto_proxy admin@192.168.50.1
```

## Prerequisites

- A newer router which support [Entware](https://github.com/Entware/Entware), and can run V2Ray comfortable.
    I use ASUS RT-AC88U
- Update yours router firmware to [AsusWRT-merlin](https://github.com/RMerl/asuswrt-merlin.ng)
- Initialize EntWare, please follow this [wiki](https://github.com/RMerl/asuswrt-merlin.ng/wiki/Entware)
- A local ssh client which can log in to router use ssh key.
- If VPS behind a firewall, (e.g. UCloud, Google Cloud), you need enable 22334/22335
tcp/udp port on server manually.
- A real domain name, if you want to use Xray + XTLS mode.

update your VPS linux kernel to a more recently version (>= 4.9) is encouraged,   
then you can enable BBR for better performance.

I recommend you enable swap through `amtm` command


```shell
opkg install bash perl python3 python3-pip openssh-sftp-server
```

## How to use it

We assume your router IP is `192.168.50.1`.

### Deploy client config to router, serve as a transparent proxy.

Previous step will create a new v2ray client config for you in `router/opt/etc/v2ray.json`.

Run following command will deploy V2ray transparent proxy to your's local ASUS
router automatically.


```sh
./deploy_router admin@192.168.50.1
```

### Useful command for router

You can run following command on router

`/opt/etc/toggle_proxy.sh` is used for disable/enable proxy temporary, for disable completely, you need `chmod -x /opt/etc/patch_router`

`/opt/etc/patch_router` basically, just disable proxy, and then enable it.

`/opt/etc/update_geosite.sh` or `/opt/etc/update_big_geosite.sh` is used for update geosite data.

`/opt/etc/apply_iptables_rule.sh` `/opt/etc/clean_iptables_rule.sh` for enable/clean iptables rule.

`/opt/etc/restart_dnsmasq.sh` for restart dnsmasq. (for router which install dnsmasq only)

`/opt/etc/check_google_use_socks5` check V2Ray if works in router. (not work for fakeDNS mode)

`/opt/etc/check_google_use_proxy` check V2Ray transparent proxy if works in router. (not work for fakeDNS mode)

