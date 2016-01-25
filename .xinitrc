xrdb ~/.Xresources
feh --bg-scale ~/background.png
xsetroot -cursor_name left_ptr
xmodmap ~/xmodmap.colemak
emacs --daemon &
exec ~/Code/dwmstatus/dwmstatus &
exec dwm
