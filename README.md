# Sapienza wirless cpal

Bash script for automatic login to sapienza wirless captive portal

## Dependencies

| Dependency | Arch | Debian 7 / Ubuntu |
|------------|------|----------|
| GNU bash | bash | bash |
| curl | curl | curl |
| iwgetid | wireless_tools | wireless-tools |

## One shot usage

```bash
CPAL_USER="yourusername" CPAL_PASS="yourpassword" swcp-autologin.sh
```

## System wide installation

You can install the script as a system command

```
sudo cp swcp-autologin.sh /usr/local/bin/swcp-autologin
sudo chmod +x /usr/local/bin/swcp-autologin
```

## Run as daemon

To run swcp-autologin as daemon you need to follow the [system wide installation procedure](#system-wide-installation) and
then choose one of the integration method:
 - [cron integration](#cron-integration)
 - [systemd integration](#systemd-integration)



### Cron integration

Thanks to cron it's possible to automatically launch the script at specific time intervals

edit your user crons with `crontab -e` and add the following line:
```
* * * * * env CPAL_USER="" CPAL_PASS="" PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" swcp-autologin >> /tmp/swcp-autologin.log 2>&1
```
remember to fill in the `CPAL_USER` and `CPAL_PASS` variables

you will find the daemon log at `/tmp/swcp-autologin.log`


### Systemd integration

This installation method provide a configurable timed daemon that will keep you logged in.

##### Configuration
write your username and password in ```/etc/swcp-autologin.conf```:

```bash
CPAL_USER="yourusername"
CPAL_PASS="yourpassword"
```
It's recommanded to make it readable only:

```sudo chmod 660 /etc/swcp-autologin.conf```

##### Systemd files

Now we need to copy systemd files:

```sudo cp systemd/swcp-autologin.* /etc/systemd/system/```

#### Usage

```bash
# Perform login:
sudo systemctl start swcp-autologin.service

# Start daemon ( this will keep you logged in )
sudo systemctl start swcp-autologin.timer

# Stop daemon
sudo systemctl stop swcp-autologin.timer

# Enable daemon automatic startup:
sudo systemctl enable swcp-autologin.timer

# Disable daemon automatic startup:
sudo systemctl disable swcp-autologin.timer

# Show logs
sudo journalctl -fb -u swcp-autologin
```
