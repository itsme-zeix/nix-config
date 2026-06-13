# nix-config

Config files for my NixOS machine(s).

Referenced https://git.notthebe.ee/notthebee/nix-config.

# Installation Runbook

Boot the official NixOS minimal installer ISO, then prepare temporary SSH from the Proxmox console:

```sh
ip -br addr
passwd nixos
```

From your host, SSH into the installer with agent forwarding enabled:

```sh
export NIXOS_HOST=192.168.xxx.xxx # replace as needed
ssh-add ~/.ssh/id_ed25519
ssh -A nixos@$NIXOS_HOST
```

Become root in the installer:

```sh
sudo -i
```

Enable flakes:

```sh
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Partition and mount the drives using disko:

```sh
DISK='/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0' # replace as needed

curl -L https://raw.githubusercontent.com/itsme-zeix/nix-config/main/disko.nix \
    -o /tmp/disko.nix
sed -i "s|to-be-filled-during-installation|$DISK|" /tmp/disko.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko \
    -- -m destroy,format,mount /tmp/disko.nix
```

Install git:

```sh
nix-env -f '<nixpkgs>' -iA git
```

Clone this repo:

```sh
mkdir -p /mnt/etc
git clone https://github.com/itsme-zeix/nix-config.git /mnt/etc/nixos
sed -i "s|to-be-filled-during-installation|$DISK|" /mnt/etc/nixos/disko.nix
```

Install the system:

```sh
HOSTNAME='nixos-vm-1' # replace as needed

nixos-install \
    --root "/mnt" \
    --no-root-passwd \
    --flake "git+file:///mnt/etc/nixos#$HOSTNAME"
```

Unmount the filesystems:

```sh
umount -Rl "/mnt"
```

Reboot:

```sh
reboot
```

After reboot, log in:

```sh
ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519 leyew@$NIXOS_HOST
```

Add PW for log in:

```sh
sudo passwd leyew
```
