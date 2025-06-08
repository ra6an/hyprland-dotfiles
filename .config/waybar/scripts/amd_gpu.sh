#!/bin/bash

usage=$(amdgpu_top -J -n 1 -s 1000 | jq '.devices[0].gpu_activity.GFX.value' 2>/dev/null)
# Zaokruži na cijeli broj
usage_int=$(printf "%.0f" "$usage")
echo "$usage_int"
