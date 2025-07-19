#!/bin/bash

# Ensure the script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with sudo." >&2
  exit 1
fi

# Get the original user who invoked sudo
# SUDO_USER is set by the sudo command itself.
if [ -z "$SUDO_USER" ]; then
  echo "Error: SUDO_USER environment variable not set. This script should be run via sudo." >&2
  exit 1
fi

TARGET_USER="$SUDO_USER"

# Install the custom package list
echo "Installing needed packages..."
sudo -u "${TARGET_USER}" yay -S --noconfirm $(<packages-repository.txt)

# Deploy user configs
echo "Deploying user configs..."
rsync -a .config "/home/${TARGET_USER}/"
rsync -a .local "/home/${TARGET_USER}/"
rsync -a home_config/ "/home/${TARGET_USER}/"
# Restore user ownership
chown -R "${TARGET_USER}:${TARGET_USER}" "/home/${TARGET_USER}"

# Deploy system configs
echo "Deploying system configs..."
rsync -a --chown=root:root etc/ /etc/
rsync -a --chown=root:root usr/ /usr/

# Make sway session wrapper script executable
chmod +x /usr/local/bin/sway-run

# Make pacman hooks executable
chmod +x /usr/local/bin/set-bootloader-resolution.sh
chmod +x /usr/local/bin/set-bootloader-vt-colorscheme.sh

# Make auto-update script executable
chmod +x /usr/local/bin/auto-update.sh

# Change shell to zsh
chsh -s "/usr/bin/zsh" "${TARGET_USER}"

# Check if the script is running in a virtual machine
# if systemd-detect-virt | grep -vq "none"; then
#   echo "Virtual machine detected; enabling WLR_RENDERER_ALLOW_SOFTWARE variable in ReGreet config..."
#   # Uncomment WLR_RENDERER_ALLOW_SOFTWARE variable in ReGreet config
#   sed -i '/^#WLR_RENDERER_ALLOW_SOFTWARE/s/^#//' /etc/greetd/regreet.toml
# fi

# Enable the Greetd service
# NOTE: greetd only installed as fallback
# echo "Enabling the Greetd service..."
# systemctl -f enable greetd.service

# Enable ly as login manager
systemctl -f enable ly.service

# 1. Enable linger for the user
# This ensures the user's systemd instance can run even when they are not logged in.
# This command needs to be run as root.
# If linger is already enabled, this command will succeed without issues.
loginctl enable-linger "$TARGET_USER"
if [ $? -ne 0 ]; then
  echo "Warning: Failed to enable linger for user $TARGET_USER. User services might not run without an active session." >&2
fi

# 2. Get the UID (User ID) of the target user
# The XDG_RUNTIME_DIR path typically includes the UID.
USER_UID=$(id -u "$TARGET_USER")
if [ -z "$USER_UID" ]; then
  echo "Error: Could not get UID for user $TARGET_USER." >&2
  exit 1
fi

# 3. Construct the XDG_RUNTIME_DIR and DBUS_SESSION_BUS_ADDRESS for the target user
# These are crucial for systemctl --user to connect to the user's D-Bus session.
# XDG_RUNTIME_DIR points to a user-specific directory for transient files.
# DBUS_SESSION_BUS_ADDRESS points to the D-Bus socket for the user's session.
export XDG_RUNTIME_DIR="/run/user/$USER_UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

# 4. Execute systemctl --user commands as the target user with explicit environment
# We use 'env' to pass the XDG_RUNTIME_DIR and DBUS_SESSION_BUS_ADDRESS variables
# to the command executed by sudo -u.

# Reload user's systemd daemon to pick up any new or changed service/timer files
# This is important if you've just created or modified the .timer or .service files.
echo "Reloading systemd daemon for user $TARGET_USER..."
sudo -u "$TARGET_USER" env XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" systemctl --user daemon-reload
if [ $? -ne 0 ]; then
  echo "Error: Failed to daemon-reload for user $TARGET_USER. Check service file paths and permissions." >&2
  exit 1
fi

# Enable auto-updates
sudo -u "$TARGET_USER" env XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" systemctl --user enable auto-update.timer
sudo -u "$TARGET_USER" env XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" systemctl --user start auto-update.timer

# Remove the repo
echo "Removing the EOS Community Sway repo..."
rm -rf ../sway

echo "Installation complete."
