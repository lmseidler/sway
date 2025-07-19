#!/bin/bash
echo "$(date): Attempting to open update terminal..."

# DISPLAY and XDG_RUNTIME_DIR should be set by systemd if the service is properly linked to the graphical session.
# If they are not, it indicates a deeper issue with the systemd user session setup.
if [ -z "$DISPLAY" ] || [ -z "$XDG_RUNTIME_DIR" ]; then
  echo "$(date): ERROR: DISPLAY or XDG_RUNTIME_DIR not set in environment. This service must run within an active graphical session."
  echo "$(date): Current DISPLAY: '$DISPLAY'"
  echo "$(date): Current XDG_RUNTIME_DIR: '$XDG_RUNTIME_DIR'"
  exit 1
fi
echo "$(date): Detected DISPLAY: '$DISPLAY'"
echo "$(date): Detected XDG_RUNTIME_DIR: '$XDG_RUNTIME_DIR'"

# Determine preferred terminal emulator
# The script will try to find common terminal emulators. You can adjust this list
# or explicitly set your preferred one (e.g., TERMINAL_EMULATOR="konsole -e").
TERMINAL_EMULATOR=""
if command -v konsole &>/dev/null; then
  TERMINAL_EMULATOR="konsole -e"
elif command -v alacritty &>/dev/null; then
  TERMINAL_EMULATOR="alacritty -e"
elif command -v kitty &>/dev/null; then
  TERMINAL_EMULATOR="kitty -e"
  # NOTE: Removed --hold to ensure it closes after the command finishes.
elif command -v gnome-terminal &>/dev/null; then
  TERMINAL_EMULATOR="gnome-terminal -- "
elif command -v xterm &>/dev/null; then
  TERMINAL_EMULATOR="xterm -e"
else
  echo "$(date): ERROR: No suitable terminal emulator found. Please install one (e.g., xterm) or specify in script."
  exit 1
fi

# Command to execute inside the terminal
# The 'exit' command ensures the terminal closes after yay finishes (or is cancelled).
COMMAND_TO_RUN="bash -c \"trap : INT; yay -Syu; echo -e \\\"\\nUpdate finished. Press Enter to close this terminal.\\\"; read -r; exit\""

echo "$(date): Launching terminal: $TERMINAL_EMULATOR '$COMMAND_TO_RUN'"

# Launch the terminal in the background using nohup to detach it from the service.
# The 'sleep 1' is a small delay to help ensure the terminal has time to open.
systemd-run --user --scope $TERMINAL_EMULATOR "$COMMAND_TO_RUN"

echo "$(date): Terminal launch command sent."

exit 0
