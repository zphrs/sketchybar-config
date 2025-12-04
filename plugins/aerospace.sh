#!/usr/bin/env bash
CURRENT=$(aerospace list-workspaces --focused)
EXISTING=$(sketchybar --query bar | jq '.items | map(select(startswith("space."))) | map(.[6:]) | join("\n")' -r)
AEROSPACES=$(aerospace list-workspaces --monitor all --empty no)
AEROSPACES=$(echo "$AEROSPACES
$FOCUSED_WORKSPACE" | LC_COLLATE=C sort -u | grep .)
if [[ $EXISTING != $AEROSPACES ]]; then
    echo "HERE"
    echo "$EXISTING"
    echo "HERE2"
    echo "$AEROSPACES"
    CMD="sketchybar"
    THEME=$(defaults read -g AppleInterfaceStyle)
    if [[ $THEME == "Dark" ]]; then
        TXT_COLOR=0xffffffff
    else
        TXT_COLOR=0xff000000
    fi
    for sid in $AEROSPACES; do

            CMD="${CMD} --add item space.$sid left \
                --subscribe space.$sid aerospace_workspace_change \
                --set space.$sid \
                background.color=0x11A5A1FF \
                label.color=$TXT_COLOR \
                background.height=30 \
                background.border_color=0x22A5A1FF \
                background.border_width=1 \
                background.corner_radius=4 \
                background.drawing=on \
                icon.drawing=off \
                padding_left=4 \
                padding_right=4 \
                blur_radius=4 \
                label="$sid" \
                click_script=\"aerospace workspace $sid\" \
                script=\"$CONFIG_DIR/plugins/aerospace.sh $sid\""
    done
    sketchybar --remove /space\./
    eval "$CMD"
    sketchybar --add bracket spaces $(echo "$AEROSPACES" | jq -Rn '[inputs] | map(select(length > 0)) | map("space." + .) | join(" ")' -r) \
        --set spaces background.color=0x22777771 \
            background.border_color=0x11777771 \
            background.border_width=1 \
            background.corner_radius=8 \
            background.height=56 \
            padding_left=5 \
            padding_right=5 \
            blur_radius=4 \
            y_offset=8

    # Ensure progress bar stays to the right of spaces
    sketchybar --move progress.filled after spaces \
               --move progress.empty after progress.filled \
               --move progress.label after progress.empty 2>/dev/null
fi
for space in $EXISTING; do
    sketchybar --set "space.$space" background.color=0x11A5A1FF
done


sketchybar --set "space.$CURRENT" background.color=0x77A5A1FF
