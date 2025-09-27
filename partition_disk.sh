echo "===> Preparing /data partition..."

# Rescan partitions
sudo partprobe

# Show filesystems
lsblk -f

# Ask user for partition (example: /dev/nvme0n1p4)
read -rp "Enter the partition path for /data (e.g. /dev/nvme0n1p4): " PART

# Get UUID
UUID=$(sudo blkid -s UUID -o value "$PART")
echo "Detected UUID: $UUID"

# Make mountpoint
sudo mkdir -p /data

# Add to fstab (with noatime + commit=120)
echo "UUID=$UUID  /data  ext4  noatime,commit=120  0  2" | sudo tee -a /etc/fstab

# Reload + mount
sudo systemctl daemon-reload
sudo mount -a

# Verify mount
df -h /data || mount | grep ' /data '

# Prepare folders
sudo mkdir -p /data/$USER_NAME/{Documents,Downloads,Pictures,Videos,SteamLibrary,Datasets}
sudo chown -R $USER_NAME:$USER_NAME /data/$USER_NAME

# Copy existing data (Documents, Downloads, etc.)
rsync -aAXH --info=progress2 ~/Documents/  /data/$USER_NAME/Documents/ || true
rsync -aAXH --info=progress2 ~/Downloads/  /data/$USER_NAME/Downloads/ || true
rsync -aAXH --info=progress2 ~/Pictures/   /data/$USER_NAME/Pictures/  || true
rsync -aAXH --info=progress2 ~/Videos/     /data/$USER_NAME/Videos/    || true

echo "===> /data is ready. If Steam is installed, add this path:"
echo "   /data/$USER_NAME/SteamLibrary"
