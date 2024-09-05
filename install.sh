#!/bin/bash

# Display the script's commands
set -x

# Function to print usage and exit
usage() {
    echo "Usage: $0 --flake <flake> --disk_device <disk_device>"
    echo "  --flake <flake>        URL or reference to the flake (e.g., github:Vrashabh-Sontakke/nixos#nixos)"
    echo "  --disk_device <disk_device>  Disk device (e.g., /dev/nvme0n1)"
    exit 1
}

# Function to prompt for input
prompt_for_input() {
    if [ -z "$FLAKE" ]; then
        read -p "Enter the flake URL or reference (e.g., github:Vrashabh-Sontakke/nixos#nixos): " FLAKE
    fi
    if [ -z "$DISK_DEVICE" ]; then
        read -p "Enter the disk device (e.g., /dev/nvme0n1): " DISK_DEVICE
    fi
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --flake) FLAKE="$2"; shift ;;
        --disk_device) DISK_DEVICE="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

# Check if FLAKE and DISK_DEVICE are provided, if not prompt for them
if [ -z "$FLAKE" ] || [ -z "$DISK_DEVICE" ]; then
    if [ -z "$FLAKE" ]; then
        echo "Flake not provided."
    fi
    if [ -z "$DISK_DEVICE" ]; then
        echo "Disk device not provided."
    fi
    prompt_for_input
fi

# Check if parameters are still missing after prompt
if [ -z "$FLAKE" ] || [ -z "$DISK_DEVICE" ]; then
    echo "Error: Both flake and disk device must be provided."
    usage
fi

# Run disko-install with provided parameters
sudo nix \
    --extra-experimental-features 'flakes nix-command' \
    run github:nix-community/disko#disko-install -- \
    --flake "$FLAKE" \
    --write-efi-boot-entries \
    --disk main "$DISK_DEVICE"

echo "Script run complete."
