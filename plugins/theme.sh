if [[ $(defaults read -g AppleInterfaceStyle) == "Dark" ]]; then
sketchybar --set '/.*/' label.color=0xffffffff icon.color=0xffffffff
else
sketchybar --set '/.*/' label.color=0xff000000 icon.color=0xff000000
fi