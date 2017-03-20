xmodmap ~/.xmodmap &
xrdb ~/.Xresources &
xset +fp /usr/local/share/fonts/tewi/ &
exec xsetroot -cursor_name left_ptr &
eval "$(ssh-agent -s)"
exec emacs --daemon &
exec sbcl --load ~/startstump.lisp
