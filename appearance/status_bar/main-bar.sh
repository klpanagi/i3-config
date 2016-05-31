#!/bin/sh

#ScreenWidth=1980
#fg="#efefef"
#bg="#343C48"
#hg="25"
#icons2="FontAwesome:size=16"
#icons4="FontAwesome:size=16"
#bg_volume="#BA5E57"
#font='Droid Serif-14'
#WidthInfo=`expr $ScreenWidth / 2 - 100`
#WidthVolume=100
#X_info=`expr $ScreenWidth - $WidthInfo - $WidthVolume`
#X_volume=`expr $ScreenWidth - $WidthVolume`

echo "{\"version\":1}"
echo "[[] ,"

# Now send blocks with information forever:
conky -c ~/.i3/appearance/status_bar/conky/info1

#i3status --config ~/.i3/appearance/status_bar/i3status/bar1
