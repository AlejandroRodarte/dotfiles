#!/bin/bash

if pgrep -x "picom" > /dev/null
then
  killall picom
  if [ $? -eq 0 ]; then
    notify-send "Picom disabled" "Picom has been succesfully disabled. You can play games now!"
  fi
else
  picom -b --config ~/.config/picom/picom.conf
  if [ $? -eq 0 ]; then
    notify-send "Picom enabled" "Picom has been succesfully enabled. Don't use it while playing games!"
  fi
fi
