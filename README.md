# Sapienza wirless cpal

Bash script for automatic login to sapienza wirless captive portal

## One shot usage

```bash
CPAL_USER="yourusername" CPAL_PASS="yourpassword" swcp-autologin.sh
```

## Systemd integration

This installation method provide a configurable timed daemon that will keep you logged in.

##### Configuration
write your username and password in ```/etc/swcp-autologin.conf```:

```bash
CPAL_USER="yourusername"
CPAL_PASS="yourpassword"
```
It's recommanded to make it readable only:

```sudo chmod 660 /etc/swcp-autologin.conf```

##### Binary file

Install binary file:

```sudo cp swcp-autologin.sh /usr/local/bin/swcp-autologin```

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
