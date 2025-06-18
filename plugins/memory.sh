#!/usr/bin/env bash

data=$(free | grep "Mem:")
data=($data)
total=${data[1]}
used=${data[2]}
total_percent=$(echo "$used / $total" | bc -l)
total=$(echo "$total" | gnumfmt --to=iec)
used=$(echo "$used" | gnumfmt --to=iec)
sketchybar --push memory.used $total_percent \
           --set memory.used_txt label="$used/$total"