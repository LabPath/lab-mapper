#!/system/bin/sh

# --- Variables --- #
# Modify if needed...
DEVICEWIDTH=1080
SCREENSHOTLOCATION="/storage/emulated/0/scripts/afk-arena/screen.dump"

# Do not modify
RGB=00000000

# --- Functions --- #
# Test function: change apps, take screenshot, get rgb, change apps, exit. Params: X, Y
function test() {
    #startApp
    switchApp
    sleep 2
    getColor $1 $2
    echo "RGB: $RGB"
    switchApp
    exit
}

# Default wait time for actions
function wait() {
    sleep 0.5
}

# Starts the app
function startApp() {
    monkey -p com.lilithgame.hgame.gp 1 >/dev/null 2>/dev/null
}

# Closes the app
function closeApp() {
    am force-stop com.lilithgame.hgame.gp >/dev/null 2>/dev/null
}

# Switches between last app
function switchApp() {
    input keyevent KEYCODE_APP_SWITCH
    input keyevent KEYCODE_APP_SWITCH
}

# Disables automatic orientation
function disableOrientation() {
    content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0
}

# Takes a screenshot and saves it
function takeScreenshot() {
    screencap $SCREENSHOTLOCATION
}

# Gets pixel color. Params: X, Y
function readRGB() {
    let offset=$DEVICEWIDTH*$2+$1+3
    RGB=$(dd if=$SCREENSHOTLOCATION bs=4 skip="$offset" count=1 2>/dev/null | hd)
    RGB=${RGB:9:9}
    RGB="${RGB// /}"
    #echo "RGB: $RGB'"
}

# Sets RGB. Params: X, Y
function getColor() {
    takeScreenshot
    readRGB $1 $2
}

# Verifies if X and Y have specific RGB. Params: X, Y, RGB, MessageSuccess, MessageFailure
function verifyRGB() {
    getColor $1 $2
    if [ "$RGB" != "$3" ]; then
        echo "VerifyRGB: Failure! Expected $3, but got $RGB instead."
        echo ""
        echo $5
        switchApp
        exit
    else
        echo $4
    fi
}

# Switches to another tab. Params: Tab name
function switchTab() {
    case "$1" in
    "Campaign")
        input tap 550 1850
        wait
        verifyRGB 450 1775 cc9261 "Successfully switched to the Campaign Tab."
        ;;
    "Dark Forest")
        input tap 300 1850
        wait
        verifyRGB 240 1775 d49a61 "Successfully switched to the Dark Forest Tab."
        ;;
    "Ranhorn")
        input tap 110 1850
        wait
        verifyRGB 20 1775 d49a61 "Successfully switched to the Rahorn Tab."
        ;;
    *)
        echo "Failed to switch to another Tab."
        switchApp
        exit
        ;;
    esac
}

# Checks lab row. Params: Row
function checkRow() {
    case $1 in
    1)
        input tap 400 1410
        wait
        checkTile $1 Left
        input tap 685 1410
        wait
        checkTile $1 Right
        ;;
    2)
        input tap 240 1200
        wait
        checkTile $1 Left
        input tap 535 1200
        wait
        checkTile $1 Middle
        input tap 830 1200
        wait
        checkTile $1 Right
        ;;
    3)
        input tap 400 1040
        wait
        checkTile $1 Left
        input tap 685 1040
        wait
        checkTile $1 Right
        ;;
    4)
        input tap 240 840
        wait
        checkTile $1 Left
        input tap 535 840
        wait
        checkTile $1 Middle
        input tap 830 840
        wait
        checkTile $1 Right
        ;;
    5)
        input tap 400 650
        wait
        checkTile $1 Left
        input tap 685 650
        wait
        checkTile $1 Right
        ;;
    6)
        input tap 240 460
        wait
        checkTile $1 Left
        input tap 535 460
        wait
        checkTile $1 Middle
        input tap 830 460
        wait
        checkTile $1 Right
        ;;
    7)
        input tap 400 250
        wait
        checkTile $1 Left
        input tap 685 250
        wait
        checkTile $1 Right
        ;;
    8)
        input tap 240 1270
        wait
        checkTile $1 Left
        input tap 535 1270
        wait
        checkTile $1 Middle
        input tap 830 1270
        wait
        checkTile $1 Right
        ;;
    9)
        input tap 400 1070
        wait
        checkTile $1 Left
        input tap 685 1070
        wait
        checkTile $1 Right
        ;;
    *)
        echo "Wtf do you mean you can't write a correct row number. Srlsy? Yu stoopid."
        ;;
    esac
}

# Check what tile it is
function checkTile() {
    takeScreenshot

    # Flag
    readRGB 700 480
    if [ $RGB = c39c69 ]; then
        # Which flag
        readRGB 260 520
        if [ $RGB = 9f96b7 ]; then
            echo "$1|$2: Brown flag"
        else
            echo "$1|$2: Red Flag"
        fi
    else
        # Wagon
        readRGB 540 400
        if [ $RGB = 9a8162 ]; then
            echo "$1|$2: Wagon"
        else
            # Fountain
            readRGB 344 728
            if [ $RGB == ffe8b9 ]; then
                echo "$1|$2: Fountain"
            else
                # Resurrect
                if [ $RGB == 83613f ]; then
                    echo "$1|$2: Resurrect"
                else
                    # Roamer
                    readRGB 585 415
                    if [ $RGB == 78a4a7 ]; then
                        echo "$1|$2: Roamer"
                    else
                        echo "$1|$2: Unknown Tile"
                    fi
                fi
            fi
        fi
    fi
    input tap 270 1800
}

# --- Script Start --- #
closeApp
wait
startApp
sleep 10
echo "Starting script..."
echo

# Disables Orientation
disableOrientation

# Loops until the game has launched
while [ "$RGB" != "cc9261" ]; do
    sleep 1
    getColor 450 1775
done
sleep 2

switchTab "Campaign"
sleep 1
switchTab "Dark Forest"
sleep 1
input tap 350 1050
sleep 1

# Check each row
checkRow 1
checkRow 2
checkRow 3
checkRow 4
checkRow 5
checkRow 6
checkRow 7

# Swipe to end of lab floor
input swipe 550 300 550 1600 200
sleep 0.1
input swipe 550 300 550 1600 200

# Check last rows
checkRow 8
checkRow 9

switchApp
echo
echo "End of script!"
exit
