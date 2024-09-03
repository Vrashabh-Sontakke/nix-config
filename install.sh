#!/bin/bash

# Display the script's commands
set -x

# Function to print usage and exit
usage() {
    echo "Usage: $0 --flake <flake> --disk_device <disk_device>"
    echo "  --flake <flake>        URL or reference to the flake (e.g., github:Vrashabh-Sontakke/nix-config#nixos)"
    echo "  --disk_device <disk_device>  Disk device (e.g., /dev/nvme0n1)"
    exit 1
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

# Check if FLAKE and DISK_DEVICE are provided
if [ -z "$FLAKE" ]; then
    echo "Error: Flake is not provided."
    usage
fi

if [ -z "$DISK_DEVICE" ]; then
    echo "Error: Disk device is not provided."
    usage
fi

# Run disko-install with provided parameters
sudo nix \
    --extra-experimental-features 'flakes nix-command' \
    run github:nix-community/disko#disko-install -- \
    --flake "$FLAKE" \
    --write-efi-boot-entries \
    --disk main "$DISK_DEVICE"

echo "Installation complete."
