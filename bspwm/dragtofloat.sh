#!/bin/env bash

#I'm not using this right now, it doesn't appear to be working for some reason but I don't need it.
#Actually it looks like this was already built in to bspwm...

: "${BSPWM_DIR:="${XDG_CONFIG_HOME:-$HOME/.config}/bspwm"}"

status_file="$BSPWM_DIR/tmp/drag_to_float"

[[ "$1" = stop ]] && {
    [[ -e "$status_file" ]] \
        && rm -r -- "$status_file"
    exit
}

[[ -e "$status_file" ]] \
    && exit

< <(bspc query -T -n pointed.window | jq -r '"\(.id) \(.client.state)"') read -r node node_state

[[ -z "$node" ]] \
    && exit

case "$node_state" in
    floating)
        ;;
    tiled|pseudo_tiled)
        node_tiled_rect=($(bspc query -T -n "$node" | jq -r '.client.tiledRectangle[]'))
        bspc node "$node" -t floating
        xdo move   -x "${node_tiled_rect[0]}" -y "${node_tiled_rect[1]}" "$node"
        xdo resize -w "${node_tiled_rect[2]}" -h "${node_tiled_rect[3]}" "$node" ;;
    *) # fullscreen
        exit ;;
esac

eval "$(xdotool getmouselocation --shell)"
x="$X" y="$Y"
touch -- "$status_file"
while [[ -e "$status_file" ]]; do
    eval "$(xdotool getmouselocation --shell)"
    (( X != x || Y != y )) && {
        bspc node "$node" -v "$((X - x))" "$((Y - y))"
        x="$X" y="$Y"
    }
done

[[ -e "$status_file" ]] \
    && rm -r -- "$status_file"


