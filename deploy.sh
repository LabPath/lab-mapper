#!/system/bin/sh

# Variables
LOCATION="storage/emulated/0"

# TODO: Check if a device is connected with adb devices

# Create directories if they don't already exist
adb shell mkdir -p $LOCATION/scripts/afk-arena

# Push the script to phone
adb push afk-lab-mapper.sh $LOCATION/scripts/afk-arena

# Run script. Comment line if you don't want to run the script after pushing
adb shell sh $LOCATION/scripts/afk-arena/afk-lab-mapper.sh