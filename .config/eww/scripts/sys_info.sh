#!/bin/bash

## Files and Data
PREV_TOTAL=0
PREV_IDLE=0
cpuFile="/tmp/.cpu_usage"

## Get CPU usage
get_cpu() {
	if [[ -f "${cpuFile}" ]]; then
		fileCont=$(cat "${cpuFile}")
		PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
		PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
	fi

	CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
	unset CPU[0]                          # Discard the "cpu" prefix.
	IDLE=${CPU[4]}                        # Get the idle CPU time.

	# Calculate the total CPU time.
	TOTAL=0

	for VALUE in "${CPU[@]:0:4}"; do
		let "TOTAL=$TOTAL+$VALUE"
	done

	if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
		# Calculate the CPU usage since we last checked.
		let "DIFF_IDLE=$IDLE-$PREV_IDLE"
		let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
		let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
		echo "${DIFF_USAGE}"
	else
		echo "?"
	fi

	# Remember the total and idle CPU times for the next check.
	echo "${TOTAL}" > "${cpuFile}"
	echo "${IDLE}" >> "${cpuFile}"
}
get_cputemp() {
	temp=$(sensors | grep 'Tctl' | awk '{print $2}' | sed 's/+//' | cut -d. -f1)
	echo "$temp"
}
get_cpufan() {
	fan=$(sensors | grep 'fan5' | awk '{print $2}')
	echo "$fan"
}
# FAN=$(sensors | grep 'fan5' | awk '{print $2}')

## Get GPU usage
get_gpu() {
    usage=$(amdgpu_top -J -n 1 -s 1000 | jq '.devices[0].gpu_activity.GFX.value' 2>/dev/null)
    printf "%.0f" "$usage"
}
get_gputemp() {
    usage=$(amdgpu_top -J -n 1 -s 1000 | jq '.devices[0].Sensors["Junction Temperature"].value' 2>/dev/null)
    printf "%.0f" "$usage"
}
get_gpumaxrpm() {
    usage=$(amdgpu_top -J -n 1 -s 1000 | jq '.devices[0].Sensors["Fan Max"].value' 2>/dev/null)
    printf "%.0f" "$usage"
}
get_gpurpm() {
    usage=$(amdgpu_top -J -n 1 -s 1000 | jq '.devices[0].Sensors.Fan.value' 2>/dev/null)
    printf "%.0f" "$usage"
}
# get_gpu() {
#     gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | awk '{print $1}')
# 	echo "${gpu}"
# }

## Get Used memory
get_mem() {
	printf "%.0f\n" $(free -m | grep Mem | awk '{print ($3/$2)*100}')
}
get_memmax() {
	# all=$(cat /proc/meminfo | grep -E "MemTotal")
	all=$(awk '/MemTotal/ {printf "%.2f\n", $2/1024/1024}' /proc/meminfo)
	echo "$all"
}
get_memused() {
	# used=$(cat /proc/meminfo | grep -E "MemAvailable")
	used=$(free -h | awk '/Mem:/ {printf "%.2f\n", $3}')
	echo "$used"
}

## Get Brightness
get_blight() {
	CARD=`ls /sys/class/backlight | head -n 1`

	if [[ "$CARD" == *"intel_"* ]]; then
		BNESS=`xbacklight -get`
		LIGHT=${BNESS%.*}
	else
		BNESS=`blight -d $CARD get brightness`
		PERC="$(($BNESS*100/255))"
		LIGHT=${PERC%.*}
	fi

	echo "$LIGHT"
}

## Get Battery 
get_battery() {
	BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`
	cat /sys/class/power_supply/${BAT}/capacity
}

## Execute accordingly
if [[ "$1" == "--cpu" ]]; then
	get_cpu
elif [[ "$1" == "--cpu-temp" ]]; then
    get_cputemp
elif [[ "$1" == "--cpu-fan" ]]; then
    get_cpufan
elif [[ "$1" == "--gpu" ]]; then
    get_gpu
elif [[ "$1" == "--gpu-temp" ]]; then
    get_gputemp
elif [[ "$1" == "--gpu-rpm" ]]; then
    get_gpurpm
elif [[ "$1" == "--gpu-maxrpm" ]]; then
    get_gpumaxrpm
elif [[ "$1" == "--mem" ]]; then
	get_mem
elif [[ "$1" == "--mem-max" ]]; then
	get_memmax
elif [[ "$1" == "--mem-used" ]]; then
	get_memused
elif [[ "$1" == "--blight" ]]; then
	get_blight
elif [[ "$1" == "--bat" ]]; then
	get_battery
fi