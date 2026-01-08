#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"


TARGET_YEAR=2026
TARGET_MONTH=02
TARGET_DAY=02
TARGET_HOUR=23
TARGET_MINUTE=59


START_YEAR=2026
START_MONTH=01
START_DAY=05
START_HOUR=09
START_MINUTE=00

# Calculate timestamps
TARGET_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$TARGET_YEAR-$TARGET_MONTH-$TARGET_DAY $TARGET_HOUR:$TARGET_MINUTE:00" +%s)
START_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$START_YEAR-$START_MONTH-$START_DAY $START_HOUR:$START_MINUTE:00" +%s)
CURRENT_EPOCH=$(date +%s)

# Calculate progress with active hours (09:00 - 22:00)
read -r TOTAL_ACTIVE ELAPSED_ACTIVE PERCENT_FLOAT <<< $(python3 "$CONFIG_DIR/plugins/progress_calc.py" "$START_EPOCH" "$TARGET_EPOCH" "$CURRENT_EPOCH")
PERCENT=$(( PERCENT_FLOAT / 10 ))
PERCENT_DEC=$((PERCENT_FLOAT % 10))
# Calculate time remaining for label
REMAINING_SECONDS=$((TOTAL_ACTIVE - ELAPSED_ACTIVE))
if [ $REMAINING_SECONDS -lt 0 ]; then
  REMAINING_SECONDS=0
fi

DAYS=$((REMAINING_SECONDS / 86400))
HOURS=$(( (REMAINING_SECONDS % 86400) / 3600 ))
MINUTES=$(( (REMAINING_SECONDS % 3600) / 60 ))

# Draw the bar
BAR_WIDTH=140
FILLED_WIDTH=$((PERCENT * BAR_WIDTH / 100))
EMPTY_WIDTH=$(( BAR_WIDTH - FILLED_WIDTH ))
EMPTY_WIDTH=$(( EMPTY_WIDTH > 8 ? EMPTY_WIDTH : 8 ))
echo $PERCENT
if [ $PERCENT -lt 33 ]; then
    COLOR=$GREEN
elif [ $PERCENT -lt 66 ]; then
    COLOR=$YELLOW
else
    COLOR=$RED
fi

LABEL="$([ $DAYS -gt 0 ] && printf '%d' $DAYS && echo "d" || echo "")"
LABEL="$LABEL$(($HOURS))h$(($MINUTES))m|$(($PERCENT)).$(($PERCENT_DEC))%"

sketchybar --set progress_fill width=$FILLED_WIDTH background.color=$COLOR \
           --set progress_empty width=$EMPTY_WIDTH \
           --set progress_label label="$LABEL" icon="⏳"
