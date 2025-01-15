#!/bin/bash

# Exit on error
set -e

echo "Starting macOS setup script..."

# Some recommended macOS defaults
echo "Setting up macOS defaults..."

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Restart affected applications
killall Finder

# Create developer directory
mkdir ~/Developer

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
else
    echo "Xcode Command Line Tools already installed"
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install Casks
echo "Installing Cask applications..."
brew install --cask  \
  1password \
  1password-cli \
  cursor \
  cyberduck \
  elgato-control-center \
  firefox \
  google-chrome \
  hiddenbar \
  insomnia \
  iterm2 \
  linear-linear \
  loom \
  messenger \
  microsoft-edge \
  minecraft \
  nordvpn \
  raycast \
  skype \
  slack \
  spotify \
  steam \
  tableplus \
  the-unarchiver \
  transmission \
  vlc \

# Install Formulae
echo "Installing Homebrew formulae..."
brew install \
  mise \
  zsh-autosuggestions \

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed"
fi

# Add zsh-autosuggestions to .zshrc if not already present
if ! grep -q "zsh-autosuggestions.zsh" "$HOME/.zshrc"; then
    echo "Configuring zsh-autosuggestions..."
    echo "\n# Auto-suggestions for oh-my-zsh\nsource $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
fi

echo "Setting up mise..."

# Add mise to shell (if not already present in .zshrc)
if ! grep -q "mise activate" "$HOME/.zshrc"; then
    echo '\n# Initialize mise\neval "$(mise activate zsh)"' >> ~/.zshrc
fi

# Initialize mise (creates config files and adds to shell)
mise install node@lts
mise use -g node@lts

# Enable package managers
echo "Enabling package managers (yarn and pnpm)..."
mise exec node@lts -- corepack enable

echo "✅ macOS setup script completed successfully!"
