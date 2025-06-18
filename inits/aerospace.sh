#!/usr/bin/env bash
sketchybar --add event aerospace_workspace_change
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sh $CONFIG_DIR/plugins/aerospace.sh
