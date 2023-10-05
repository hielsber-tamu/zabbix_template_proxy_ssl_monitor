# zabbix_template_proxy_ssl_monitor
This is a very specific implementation of an ssl monitor for RHEL9/certbot/letsencrypt. 

This implementation assumes that all certificates are installed in a path, currently hard-coded as /etc/letsencrypt/live, and stored within folders named using FQDN.  For example:
```
/etc/letsencrypt/live/www.myserver.com/cert.pem
/etc/letsencrypt/live/www.myserver.com/...
/etc/letsencrypt/live/www.anotherpage.com/cert.pem
/etc/letsencrypt/live/www.anotherpage.com/...
```
The FQDN (the folder name) is not really important here, except that it is included in the UserParameter, proxy_ssl.exp, and can be helpful to have in a auto-generated ticket, for instance.

The shell script zabbix_proxy_ssl_check.sh simply gets the expiration date for all certs in `/etc/letsencrypt/live/*/cert.pem`, and reports any whose date is within the threshold (in seconds) specified by `exp_thresh_sec`.

The zabbix template is set to update once a day, and by default will report any certificates that expire within the next two weeks.


## Installation

 - Copy `zabbix_proxy_ssl_check.sh` to `/opt/Zabbix/bin/zabbix_proxy_ssl_check.sh`
 - Copy `zabbix_proxy_ssl.conf` to `/etc/zabbix/zabbix_agent2.d/zabbix_proxy_ssl.conf`
 - Import `template_proxy_ssl_monitor.yaml` into Zabbix and assign to relevant hosts.
