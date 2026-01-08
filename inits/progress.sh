#!/usr/bin/env sh

sketchybar --remove /daily_progress\./ 2>/dev/null

sketchybar --add item daily_progress_fill left \
           --set daily_progress_fill background.color=$RED \
                                 background.drawing=on \
                                 width=0 \
                                 label.drawing=off \
                                 icon.drawing=off \
                                 background.height=24 \
                                 background.corner_radius=4 \
                                 background.padding_left=4 \
                                 background.padding_right=4 \
           --add item daily_progress_empty left \
           --set daily_progress_empty background.color=0x00000000 \
                                background.drawing=on \
                                width=81 \
                                icon.drawing=off \
                                background.height=26 \
                                background.corner_radius=0 \
           --add item daily_progress_label left \
           --set daily_progress_label \
                                script="$PLUGIN_DIR/daily-progress-bar.sh" \
                                update_freq=15 \
                                icon.drawing=off \
                                width=8 \
                                padding_left=-81 \
                                align=center \

sketchybar --add bracket daily_progress_bar daily_progress_fill daily_progress_empty daily_progress_label \
           --set daily_progress_bar background.color=0x22777771 \
                              background.border_color=0x44777771 \
                              background.border_width=1 \
                              background.corner_radius=8 \
                              blur_radius=4 \
                              background.height=32

sketchybar --remove /\$progress\./ 2>/dev/null

sketchybar --add item progress_fill left \
           --set progress_fill background.color=$RED \
                                 background.drawing=on \
                                 width=0 \
                                 label.drawing=off \
                                 icon.drawing=off \
                                 background.height=24 \
                                 background.corner_radius=4 \
                                 background.padding_left=4 \
                                 background.padding_right=4 \
           --add item progress_empty left \
           --set progress_empty background.color=0x00000000 \
                                background.drawing=on \
                                width=136 \
                                icon.drawing=off \
                                background.height=26 \
                                background.corner_radius=0 \
           --add item progress_label left \
           --set progress_label \
                                script="$PLUGIN_DIR/progress-bar.sh" \
                                update_freq=15 \
                                icon.drawing=off \
                                width=8 \
                                padding_left=-136 \
                                align=center \


sketchybar --add bracket progress_bar progress_fill progress_empty progress_label \
           --set progress_bar background.color=0x22777771 \
                              background.border_color=0x44777771 \
                              background.border_width=1 \
                              background.corner_radius=8 \
                              blur_radius=4 \
                              background.height=32

