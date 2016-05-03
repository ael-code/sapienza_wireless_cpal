#!/bin/bash

TARGET_ESSID="sapienza"
PORTAL_URL="https://wifi-cont1.uniroma1.it:8003/index.php?zone=wifi_sapienza"

PROBE_TIMEOUT=40
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:36.0) Gecko/20100101 Firefox/36.0"

function log_debug {
    echo $1
}

function is_internet_reachable {
    local probe_timeout=$1
    http_code=`curl --max-time $probe_timeout -s -o /dev/null -I -w "%{http_code}" http://clients3.google.com/generate_204`
    if [ $http_code == 204 ]; then
        return 1;
    fi
    return 0;
}

#control if user and password are being passed
if [ -z "$CPAL_USER" -o -z "$CPAL_PASS" ]; then
    log_debug "'CPAL_USER' and 'CPAL_PASS' env variable must be set"
    exit 1
fi

#controls if you are connected to the right AP
essid=`iwgetid -r`
if [ "$essid" != "$TARGET_ESSID" ]; then
    log_debug "Not connected to the target AP"
    exit 0;
fi

#controls if you are already logged
is_internet_reachable $PROBE_TIMEOUT
if [ $? == 1 ]; then
    log_debug "Already logged in"
    exit 0;
fi

# actual request
resp_page=$(
    echo "auth_user=$CPAL_USER&auth_pass=$CPAL_PASS&accept=Continue" | \
    curl -s --user-agent "$USER_AGENT" --retry 10 -d "@-" "$PORTAL_URL"
)
resp_out=$?;

# Check if curl exit with an error status code
if [ $resp_out -ne 0 ]; then
    log_debug "Failed to sent login request: $resp_out"
    exit 1;
fi

# If the response page contains the word 'logout' it means that
# we've successfully logged in
echo $resp_page | grep -iq "logout"
if [ $? -eq 0 ]; then
    log_debug "Successfully logged in"
    exit 0;
fi

# If the response page contains 'invalid credentials' it means that
# we had sended wrong username or password
echo $resp_page | grep -iq "Invalid credentials"
if [ $? -eq 0 ]; then
    log_debug "Invalid credentials"
    exit 3;
fi

log_debug "The login request has been sent but the response doesn't contain any meaningful data"
exit 1
