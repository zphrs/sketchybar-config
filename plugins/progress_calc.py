#!/usr/bin/env python3
import math
import sys
from datetime import datetime, timedelta

if len(sys.argv) < 4:
    print("0")
    sys.exit(1)

start_ts: float = float(sys.argv[1])
target_ts: float = float(sys.argv[2])
current_ts: float = float(sys.argv[3])


def get_active_duration(t1: float, t2: float) -> float:
    start_dt: datetime = datetime.fromtimestamp(t1)
    end_dt: datetime = datetime.fromtimestamp(t2)

    if start_dt >= end_dt:
        return 0.0

    duration: float = 0.0
    curr_day: datetime = start_dt.replace(hour=0, minute=0, second=0, microsecond=0)

    while curr_day < end_dt + timedelta(days=1):
        # Skip saturdays
        saturday = 5
        if curr_day.weekday() != saturday:
            active_start: datetime = curr_day.replace(hour=9, minute=30, second=0)
            # gives 3 hours of buffer for commuting & dinner
            active_end: datetime = curr_day.replace(hour=22, minute=0, second=0)

            s: datetime = max(start_dt, active_start)
            e: datetime = min(end_dt, active_end)

            if s < e:
                duration += (e - s).total_seconds()

        curr_day += timedelta(days=1)

    return duration


total_active: float = get_active_duration(start_ts, target_ts)
elapsed_active: float = get_active_duration(start_ts, current_ts)

if elapsed_active < 0:
    elapsed_active = 0
if elapsed_active > total_active:
    elapsed_active = total_active

if total_active <= 0:
    percent: float = 100.0
else:
    ratio: float = elapsed_active / total_active
    # k: float = 1
    # try:
    #     percent = (1 - math.exp(-k * ratio)) / (1 - math.exp(-k)) * 100
    # except Exception:
    #     percent = 0.0
    percent = ratio * 100

print(f"{int(total_active)} {int(elapsed_active)} {int(percent * 10)}")
