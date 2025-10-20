#!/bin/bash

read -rsp "Enter existing LUKS passphrase: " existing_pass; echo
read -rsp "Enter new LUKS passphrase: " new_pass; echo
read -rsp "Confirm new passphrase: " confirm_pass; echo

if [[ "$new_pass" != "$confirm_pass" ]]; then
    echo "Passwords do not match."
    exit 1
fi


if ! command -v expect &>/dev/null; then
    echo "Installing expect..."
    sudo apt-get update && sudo apt-get install -y expect
fi

expect <<EOF
spawn cryptsetup luksAddKey --key-slot 2 /dev/sda1
expect "Enter any existing passphrase:"
send "$existing_pass\r"
expect "Enter new passphrase for key slot:"
send "$new_pass\r"
expect "Verify passphrase:"
send "$new_pass\r"
expect eof
EOF

echo "$new_pass" | cryptsetup luksKillSlot /dev/sda1 0
echo "$new_pass" | cryptsetup luksKillSlot /dev/sda1 1

echo "$new_pass" | clevis luks bind -f -s 0 -d /dev/sda1 tpm2 '{}'

update-initramfs -c -k all

read -rp "Enter MOK enrollment password (will be required after reboot): " mok_pass; echo

expect <<EOF
spawn mokutil --import /home/conbotics/Kernel/MOK.der
expect "input password:"
send "$mok_pass\r"
expect "input password again:"
send "$mok_pass\r"
expect eof
EOF

echo "Pc is about to reboot - upon seeing the MOK enrollment screen - enroll the key using the before entered password"

reboot now