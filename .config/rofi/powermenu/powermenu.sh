#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Power Menu

# Import Current Theme
# source "$HOME/.config/rofi/powermenu/shared/theme.bash"
theme="$HOME/.config/rofi/powermenu/config-powermenu.rasi"

# Theme Elements
prompt="`hostname`"
mesg="Uptime : `uptime -p | sed -e 's/up //g'`"

list_col='3'
list_row='1'

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Lock"
	option_2=" Reboot"
	option_3=" Shutdown"
	yes=' Yes'
	no=' No'
else
	option_1=""
	option_2=""
	option_3=""
	yes=''
	no=''
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3" | rofi_cmd
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${theme}
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Confirm and execute

confirm_run () {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
        "$1"  # 仅执行第一个参数代表的命令
    else
        exit
    fi
}
# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		betterlockscreen -l
		confirm_run "systemctl hibernate"
	elif [[ "$1" == '--opt2' ]]; then
		confirm_run "reboot"
	elif [[ "$1" == '--opt3' ]]; then
		confirm_run "poweroff"
	fi
}

# Actions
chosen="$(run_rofi)"
# 修改 case 语句
case "${chosen}" in
    "${option_1}")
		run_cmd --opt1
        ;;
    "${option_2}")
		run_cmd --opt2
        ;;
    "${option_3}")
		run_cmd --opt3
        ;;
esac

