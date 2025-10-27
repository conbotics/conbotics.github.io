#!/bin/bash
set -e

USBGUARD_RULES_FILE="/etc/usbguard/rules.conf"
USBGUARD_CONF_FILE="/etc/usbguard/usbguard-daemon.conf"
BACKUP_DIR="/etc/usbguard"
TIMESTAMP=$(date +%s)
BACKUP_FILE="$BACKUP_DIR/rules.conf.bak.$TIMESTAMP"

# --- Ensure run as root ---
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)."
  exit 1
fi

# --- Parse arguments ---
RESET=0
DEVICE_TYPE=""

for arg in "$@"; do
  case "$arg" in
    --reset)
      RESET=1
      ;;
    *)
      if [ -z "$DEVICE_TYPE" ]; then
        DEVICE_TYPE="$arg"
      else
        echo "Unknown argument: $arg"
        echo "Usage: $0 [--reset] <device_type>"
        exit 1
      fi
      ;;
  esac
done

if [ -z "$DEVICE_TYPE" ]; then
  echo "Usage: $0 [--reset] <device_type>"
  echo "Example: $0 --reset jetson"
  exit 1
fi

# --- Install usbguard ---
echo "Installing usbguard..."
if command -v apt >/dev/null; then
  apt update && apt install -y usbguard
elif command -v dnf >/dev/null; then
  dnf install -y usbguard
elif command -v pacman >/dev/null; then
  pacman -Sy --noconfirm usbguard
else
  echo "Unsupported package manager. Install usbguard manually."
  exit 1
fi

# --- Handle reset ---
if [ "$RESET" -eq 1 ]; then
  echo "Resetting USBGuard configuration..."
  systemctl stop usbguard

  if [ -f "$USBGUARD_RULES_FILE" ]; then
    echo "Backing up current rules to $BACKUP_FILE"
    cp "$USBGUARD_RULES_FILE" "$BACKUP_FILE"
    rm "$USBGUARD_RULES_FILE"
  fi
fi

# --- Enable and start usbguard ---
# echo "Enabling and starting usbguard..."
# systemctl enable --now usbguard

# --- Write new rules ---
echo "Writing USBGuard rules for device type: $DEVICE_TYPE"
if [ "$DEVICE_TYPE" = "jetson" ]; then
  cat >> "$USBGUARD_RULES_FILE" <<EOF
allow id 8086:0b5c name "Intel(R) RealSense(TM) Depth Module 456 "
block id *:*
EOF
  cat >> "$USBGUARD_CONF_FILE" <<EOF
# USBGuard daemon configuration file

RuleFile=/etc/usbguard/rules.conf
ImplicitPolicyTarget=block

IPCAllowedUsers=root
IPCAllowedGroups=usbguard

AuditFilePath=/var/log/usbguard/usbguard-audit.log
EOF
else
  cat >> "$USBGUARD_RULES_FILE" <<EOF
block id *:*
EOF
fi

# --- Restart usbguard to apply new rules ---
echo "Restarting usbguard..."
systemctl restart usbguard

# --- Final status ---
echo "Done!"
echo "View log: journalctl -u usbguard -f"
