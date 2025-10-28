#!/bin/bash

# 获取默认声卡的当前音量百分比（静音时会显示 "Mute"）
current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n 1 | tr -d '%')

# 检查是否静音
is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o 'yes\|no')

# 音量操作
case "$1" in
    up)
        if [[ "$is_muted" == "yes" ]]; then
            pactl set-sink-mute @DEFAULT_SINK@ toggle  # 取消静音
        fi
        if [[ "$current_volume" -lt 100 ]]; then
            pactl set-sink-volume @DEFAULT_SINK@ +10%  # 仅当音量 <100% 时增加
        fi
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -10%
        ;;
    toggle)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
esac

# 刷新 i3status
$refresh_i3status
