#!/system/bin/sh

# TODO: Check if a device is connected with adb devices
# TODO: Check if folders exist

# Push the script to phone
adb push afk-lab-mapper.sh storage/emulated/0/scripts/afk-arena

# Run script. Comment line if you don't want to run the script after pushing
adb shell "su -c 'sh storage/emulated/0/scripts/afk-arena/afk-lab-mapper.sh'"