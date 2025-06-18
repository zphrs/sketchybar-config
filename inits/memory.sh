sketchybar --add item memory.used_txt right \
           --set memory.used_txt width=0 label.font.size=10 label.font.style=Bold label="--G/--G" y_offset=-15 \
           --add graph memory.used right 50 \
           --set memory.used graph.color=$RED background.color=0xff000000 script="$PLUGIN_DIR/memory.sh" update_freq=2 label.drawing=off icon.drawing=off background.corner_radius=0 background.padding_left=0 background.padding_right=0 background.height=30 y_offset=7 \