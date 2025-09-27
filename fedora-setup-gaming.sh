#!/usr/bin/env bash
set -euo pipefail

USER_NAME="${USER}"

echo "===> Updating system..."
sudo dnf upgrade --refresh -y

echo "===> Enable RPM Fusion (Free + Nonfree)..."
sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "===> Installing NVIDIA + Vulkan drivers..."
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda \
  xorg-x11-drv-nvidia-cuda-libs vulkan vulkan-tools libvulkan libva-utils mesa-demos

echo "===> Installing MangoHud + GameMode + Steam + OBS..."
sudo dnf install -y mangohud gamemode lib32-gamemode steam obs-studio

echo "===> Installing lm_sensors..."
sudo dnf install -y lm_sensors
sudo sensors-detect --auto || true
