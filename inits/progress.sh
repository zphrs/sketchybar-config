#!/usr/bin/env sh

sketchybar --remove progress 2>/dev/null

sketchybar --add item progress.filled left \
           --set progress.filled background.color=$RED \
                                 background.drawing=on \
                                 width=0 \
                                 label.drawing=off \
                                 icon.drawing=off \
                                 background.height=26 \
                                 background.corner_radius=4 \
           --add item progress.empty left \
           --set progress.empty background.color=0x44ffffff \
                                background.drawing=on \
                                width=150 \
                                label.drawing=off \
                                icon.drawing=off \
                                background.height=26 \
                                background.corner_radius=4 \
           --add bracket progress_bar progress.filled progress.empty \
           --set progress_bar background.border_color=$WHITE \
                              background.border_width=0 \
                              background.color=0x00000000 \
                              padding_left=4 \
                              padding_right=4 \
           --add item progress.label left \
           --set progress.label script="$PLUGIN_DIR/progress-bar.sh" \
                                update_freq=60 \
                                icon.drawing=off \
                                width=0 \
                                align=left \
                                padding_left=-146
