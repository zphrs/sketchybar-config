#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

# Target date: 2025-12-11 23:59
TARGET_YEAR=2025
TARGET_MONTH=12
TARGET_DAY=11
TARGET_HOUR=23
TARGET_MINUTE=59

# Start date: 2025-12-04 09:00
START_YEAR=2025
START_MONTH=12
START_DAY=04
START_HOUR=09
START_MINUTE=00

# Calculate timestamps
TARGET_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$TARGET_YEAR-$TARGET_MONTH-$TARGET_DAY $TARGET_HOUR:$TARGET_MINUTE:00" +%s)
START_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$START_YEAR-$START_MONTH-$START_DAY $START_HOUR:$START_MINUTE:00" +%s)
CURRENT_EPOCH=$(date +%s)

# Calculate progress with active hours (09:00 - 22:00)
PERCENT=$(python3 "$CONFIG_DIR/plugins/progress_calc.py" "$START_EPOCH" "$TARGET_EPOCH" "$CURRENT_EPOCH")

# Calculate time remaining for label
REMAINING_SECONDS=$((TARGET_EPOCH - CURRENT_EPOCH))
if [ $REMAINING_SECONDS -lt 0 ]; then
  REMAINING_SECONDS=0
fi

DAYS=$((REMAINING_SECONDS / 86400))
HOURS=$(( (REMAINING_SECONDS % 86400) / 3600 ))
MINUTES=$(( (REMAINING_SECONDS % 3600) / 60 ))

# Draw the bar
BAR_WIDTH=150
FILLED_WIDTH=$((PERCENT * BAR_WIDTH / 100))
EMPTY_WIDTH=$((BAR_WIDTH - FILLED_WIDTH))

if [ $PERCENT -lt 33 ]; then
    COLOR=$GREEN
elif [ $PERCENT -lt 66 ]; then
    COLOR=$YELLOW
else
    COLOR=$RED
fi

LABEL="${DAYS}d ${HOURS}h ${MINUTES}m"

sketchybar --set progress.filled width=$FILLED_WIDTH background.color=$COLOR \
           --set progress.empty width=$EMPTY_WIDTH \
           --set progress.label label="$LABEL" icon="⏳"
