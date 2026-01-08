#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"


TARGET_YEAR=$(date +%Y)
TARGET_MONTH=$(date +%m)
TARGET_DAY=$(date +%d)
TARGET_HOUR=23
TARGET_MINUTE=00


START_YEAR=$(date +%Y)
START_MONTH=$(date +%m)
START_DAY=$(date +%d)
START_HOUR=07
START_MINUTE=00

# Calculate timestamps
TARGET_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$TARGET_YEAR-$TARGET_MONTH-$TARGET_DAY $TARGET_HOUR:$TARGET_MINUTE:00" +%s)
START_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$START_YEAR-$START_MONTH-$START_DAY $START_HOUR:$START_MINUTE:00" +%s)
echo $START_EPOCH
echo $TARGET_EPOCH
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
BAR_WIDTH=85
FILLED_WIDTH=$((PERCENT * BAR_WIDTH / 100))
EMPTY_WIDTH=$(( BAR_WIDTH - FILLED_WIDTH ))
EMPTY_WIDTH=$(( EMPTY_WIDTH > 8 ? EMPTY_WIDTH : 8 ))
echo $PERCENT
if [ $PERCENT -lt 33 ]; then
    COLOR=$GREEN
elif [ $PERCENT -lt 66 ]; then
    COLOR=$YELLOW
elif [ $PERCENT -lt 100]; then
    COLOR=$RED
else 
    COLOR=$GREEN
fi

LABEL="$([ $DAYS -gt 0 ] && printf '%d' $DAYS && echo "d " || echo "")"
LABEL="$LABEL$(($HOURS))h$(($MINUTES))m|$(($PERCENT))%"

sketchybar --set daily_progress_fill width=$FILLED_WIDTH background.color=$COLOR \
           --set daily_progress_empty width=$EMPTY_WIDTH \
           --set daily_progress_label label="$LABEL" icon="⏳"
