#!/bin/bash


			#MULTILIB

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Uncomment the [multilib] repository section and the 'Include' line in pacman.conf
sed -i 's/#\[multilib\]/\[multilib\]/' /etc/pacman.conf
sed -i 's/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf

# Synchronize the package databases to include the multilib repository
pacman -Sy


			#PARU INSTALLATION

pacman -Syu --noconfirm
pacman -S --needed base-devel git --noconfirm

git clone https://aur.archlinux.org/paru.git
cd paru || exit

makepkg -si --noconfirm

cd ..


			#GPU DRIVERS

echo "Choose GPU drivers to install:"
echo "1) AMD"
echo "2) NVIDIA"
read -rp "Enter your choice (1 or 2): " choice

install_amd_drivers() {
    echo "Installing AMD drivers..."
    sudo pacman -S --needed --noconfirm xf86-video-amdgpu mesa
    echo "✅ AMD drivers installed!"
}

install_nvidia_drivers() {
    echo "Installing NVIDIA drivers..."
    sudo pacman -S --needed --noconfirm nvidia nvidia-utils nvidia-settings
    echo "✅ NVIDIA drivers installed!"
}

case "$choice" in
    1)
        install_amd_drivers
        ;;
    2)
        install_nvidia_drivers
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac


			#ZSH INSTALLATION

if ! command -v zsh >/dev/null 2>&1; then
  if [ -x "$(command -v apt)" ]; then
    sudo apt update && sudo apt install -y zsh git curl
  elif [ -x "$(command -v dnf)" ]; then
    sudo dnf install -y zsh git curl
  elif [ -x "$(command -v pacman)" ]; then
    sudo pacman -Sy --noconfirm zsh git curl
  else
    echo "❌ Unknown command."
    exit 1
  fi
else
  echo "✅ Zsh already installed."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
else
  echo "✅ Powerlevel10k already installed."
fi

if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
  sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$HOME/.zshrc"
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
fi

if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi



			#DEPENDENCIES

paru -S firefox telegram-desktop rofi waybar nemo alacritty grim slurp neovim swaync nerd-fonts hyprlock hyprpaper ttf-jetbrains-mono ttf-fira-code qt6-5compat fzf ueberzugpp imagemagick libnotify jq chafa vlc qbittorent wl-clipboard engrampa nwg-look peaclock cava pavucontrol nvtop fastfetch gtk2 gtk3 gtk4 font-manager discord cmake gcc make nodejs bibata-cursor-theme-bin dotnet-sdk


			#GRUB THEME

cd ./grub/
sudo chmod +x install.sh
sudo ./install.sh -t vimix
cd ./../


			#CONFIGS

chmod +x ./.scripts/*
USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
cp -R ./.config/ "$USER_HOME/"
cp -R ./.themes/ "$USER_HOME/"
cp -R ./.icons/ "$USER_HOME/"
cp -R ./.scripts/ "$USER_HOME/"
cp -R ./.oh-my-zsh/ "$USER_HOME/"
cp ./.zshrc "$USER_HOME/"
cp ./.p10k.zsh "$USER_HOME/"
cp -R ./.wallpapers/ "$USER_HOME/"
cp -R ./.qbittorrent-themes/ "$USER_HOME/"
cp -R ./.vlc-skins "$USER_HOME/"
sudo cp ./sddm/sddm.conf /etc/
sudo cp -R ./sddm/blueleaf /usr/share/sddm/themes/
chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME"/.{config,themes,icons,scripts,oh-my-zsh,zshrc,wallpapers,qbittorrent-themes,vlc-skins}
