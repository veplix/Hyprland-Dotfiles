<div align="center">
  
# veplix's hyprland-dotfiles

</div>

<div align="center">
  
  ## Showcase
  
  <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/preview.jpg">
</div>

## Main Features

### Alacritty

Simple, GPU-accelerated terminal emulator written in Rust. It supports scrollback, 24-bit colors, copy/paste, clicking on URLs, and custom key bindings

> [!NOTE]
> In rice used zsh shell and +oh-my-zsh with theme powerlevel10k and plugins: `git` `archlinux` `zsh-syntax-highlighting` `zsh-autosuggestions`

  <details>
    <summary>Screenshot</summary>
    <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/alacritty.jpg">
  </details>


### Waybar

Highly customizable Wayland bar for Sway and Wlroots based compositors.
  <details>
    <summary>Screenshot</summary>
    <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/Waybar.png">
  </details>

### Rofi

Rofi: A window switcher, application launcher and dmenu replacement. On rofi written my custom scripts: "Power Menu", "Wi-fi Menu" and "Wallpaper Changer". All of those scripts are situated in `/Hyprland-dotfiles/.scipts` or
```
~/.scripts
```
after install.

  <details>
    <summary>Screenshots (Rofi, Power Menu, Wi-fi Menu and Wallpaper Changer)</summary>
      <details>
        <summary>Rofi</summary>
        <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/rofi.jpg"></p>
      </details>
      <details>
        <summary>Power Menu</summary>
        <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/Power_Menu.jpg">
      </details>
      <details>
        <summary>Wi-fi Menu</summary>
        <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/Wi-fi_Menu.jpg">
      </details>
      <details>
       <summary>Wallpaper Changer</summary>
       <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/Wallpapers_Changer.jpg">
      </details>
  </details>

> [!IMPORTANT]
> Unfortunately you need to run "Wallpapers Changer" manually because for changing wallpapers for sddm theme needed sudo+password

### Nemo (file manager)

Nemo is a free and open-source software and official file manager of the Cinnamon desktop environment. It is a fork of GNOME Files (formerly named Nautilus). (Im using this instead of Thunar because nemo fixes some issues that i had in Thunar)
  <details>
    <summary>Screenshot</summary>
    <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/nemo.jpg">
  </details>

### Neovim

Neovim is a Vim-based text editor engineered for extensibility and usability, to encourage new applications and contributions with plugin support.
  <details>
    <summary>Screenshot</summary>
    <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/nvim.jpg">
  </details>
  
> [!NOTE]
> Added alias-`sudo -E nvim=nvim`(through oh-my-zsh) now you dont need write everytime sudo, just
> ```
> nvim /path/to/file

> [!TIP]
> Contains also plugins for autosuggestion/autocompletition/highlighting in
>
> ```
> ~/.config.nvim/lua/plugins/
> ```
>`cmp-nvim` - (cmp.lua), `lsp-nvim` - (lsp.lua), `treesitter-nvim` - (trstr.lua) which you can modify by yourself

> [!IMPORTANT]
> Plugin manager for nvim:Lazy

## ⌨ Keybinds ⌨
- Keybinds [`CLICK`](https://github.com/veplix/Hyprland-dotfiles/wiki/Keybinds)

## Installation
First you need install git package for cloning dots in your direcrory
```
sudo pacman -S git
```
Then clone Hyprland-dotfiles in your directory
```
git clone https://github.com/veplix/Hyprland-dotfiles.git
```
Do a cd in Hyprland-dotfiles
```
cd Hyprland-dotfiles
```
Give rights to execute install.sh script
```
chmod +x install.sh
```
And finally you can run install.sh

> [!IMPORTANT]
> Run the script with sudo

```
sudo ./install.sh
```
