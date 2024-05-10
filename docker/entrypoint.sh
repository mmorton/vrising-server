#!/bin/bash
export WINEDEBUG=-all
export DISPLAY=:1.0

# Quick function to generate a timestamp
timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

# Install/Update V Rising
echo "$(timestamp) INFO: Updating V Rising Dedicated Server"
steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "$VRISING_PATH" +login anonymous +app_update ${STEAM_APP_ID} validate +quit

# Check that steamcmd was successful
if [ $? != 0 ]; then
    echo "$(timestamp) ERROR: steamcmd was unable to successfully initialize and update V Rising"
    exit 1
fi

# Redirect log file to stdout
ln -sf /proc/1/fd/1 "${VRISING_PATH}/logs/VRisingServer.log"

# Start xvfb 
Xvfb :1 -screen 0 1024x768x16 &

# Start VRising
wine ${VRISING_PATH}/VRisingServer.exe \
    -batchmode \
    -nographics \
    -persistentDataPath "${VRISING_PATH}/save-data" \
    -logFile "${VRISING_PATH}/logs/VRisingServer.log" \
    -serverName "${SERVER_NAME}" \
    -description "${DESCRIPTION}" \
    -gamePort "${GAME_PORT}" \
    -queryPort "${QUERY_PORT}" \
    -bindAddress "${BIND_ADDRESS}" \
    -hideIpAddress "${HIDE_IP}" \
    -lowerFPSWhenEmpty "${LOWER_FPS_EMPTY}" \
    -password "${SERVER_PASSWORD}" \
    -secure "${SECURE}"
