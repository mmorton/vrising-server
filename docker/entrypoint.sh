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
echo "$(timestamp) INFO: Linking log file to standard out"
ln -sf /proc/1/fd/1 "${VRISING_PATH}/logs/VRisingServer.log"

# Start xvfb 
echo "$(timestamp) INFO: Starting X11 emulation"
Xvfb :1 -screen 0 1024x768x16 &

args=()

[ -n "$SERVER_NAME" ] && args+=(--serverName "$SERVER_NAME")
[ -n "$DESCRIPTION" ] && args+=(--description "$DESCRIPTION")
[ -n "$GAME_PORT" ] && args+=(--gamePort "$GAME_PORT")
[ -n "$QUERY_PORT" ] && args+=(--queryPort "$QUERY_PORT")
[ -n "$BIND_ADDRESS" ] && args+=(--bindAddress "$BIND_ADDRESS")
[ -n "$HIDE_IP" ] && args+=(--hideIpAddress "$HIDE_IP")
[ -n "$LOWER_FPS_EMPTY" ] && args+=(--lowerFPSWhenEmpty "$LOWER_FPS_EMPTY")
[ -n "$PASSWORD" ] && args+=(--password "$PASSWORD")
[ -n "$SECURE" ] && args+=(--secure "$SECURE")
[ -n "$EOS_LIST" ] && args+=(--listOnEOS "$EOS_LIST")
[ -n "$STEAM_LIST" ] && args+=(--listOnSteam "$STEAM_LIST")
[ -n "$GAME_PRESET" ] && args+=(--preset "$GAME_PRESET")
[ -n "$DIFFICULTY" ] && args+=(--difficultyPreset "$DIFFICULTY")
[ -n "$SAVE_NAME" ] && args+=(--saveName "$SAVE_NAME")

# Start VRising
echo "$(timestamp) INFO: Launching V Rising"
echo wine ${VRISING_PATH}/VRisingServer.exe \
    -batchmode \
    -nographics \
    -persistentDataPath "${VRISING_PATH}/save-data" \
    -logFile "${VRISING_PATH}/logs/VRisingServer.log" \
    "${args[@]}"
