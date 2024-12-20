1 - To start using wallpapers, symlink your favourite wallpapers here. <br>
2 - If not existing, create the following symlinks manually:<br>
```
    link                             original file   
    /usr/share/hyprland/wall0.png -> $HOME/.config/hypr/wallpapers/wall0.png
    /usr/share/hyprland/wall1.png -> $HOME/.config/hypr/wallpapers/wall1.png
    /usr/share/hyprland/wall2.png -> $HOME/.config/hypr/wallpapers/wall2.png
```
Instructions:
```
ln -s $HOME/.config/hypr/wallpapers/wall0.png /usr/share/hyprland/wall0.png
ln -s $HOME/.config/hypr/wallpapers/wall1.png /usr/share/hyprland/wall1.png 
ln -s $HOME/.config/hypr/wallpapers/wall2.png /usr/share/hyprland/wall2.png 
```
Alternative Instruction for Fish shell:
```
for pic in (ls $HOME/.config/hypr/wallpapers/*.png)
    ln -s $HOME/.config/hypr/wallpapers/$pic /usr/share/hyprland/$pic
end
```
