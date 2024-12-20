To start using wallpapers, symlink your favourite wallpapers here. <br>
Instructions:
```
ln -s $HOME/Pictures/wallpapers/*.png $HOME/.config/awesome/themes/luci4/wallpapers/ 
```
Fish shell instruction to link all the png wallpapers from Pictures/wallpapers.
This script is just a startig point, it can be improved to detect image files, and not only png.
```
for item in (ls /home/lucifer/Pictures/wallpapers/*.png)                                                                                            12:43 Fri Dec 20
     ln -s $HOME/Pictures/wallpapers/$item $HOME/.config/awesome/themes/luci4/wallpapers/ 
end

```

