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

# Calculate progress
TOTAL_SECONDS=$((TARGET_EPOCH - START_EPOCH))
ELAPSED_SECONDS=$((CURRENT_EPOCH - START_EPOCH))

if [ $ELAPSED_SECONDS -lt 0 ]; then
  ELAPSED_SECONDS=0
fi

if [ $ELAPSED_SECONDS -gt $TOTAL_SECONDS ]; then
  ELAPSED_SECONDS=$TOTAL_SECONDS
fi

# Exponential progress calculation (Fast start, slow end)
# k determines the steepness.
K=10
PERCENT=$(awk -v elapsed="$ELAPSED_SECONDS" -v total="$TOTAL_SECONDS" -v k="$K" 'BEGIN {
  if (total <= 0) { print 100; exit }
  ratio = elapsed / total
  if (ratio < 0) ratio = 0
  if (ratio > 1) ratio = 1
  p = (1 - exp(-k * ratio)) / (1 - exp(-k))
  printf "%.0f", p * 100
}')

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
