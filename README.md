# nix-config

Config files for my NixOS machine(s).

Referenced https://git.notthebe.ee/notthebee/nix-config.

# Installation Runbook

From your host, copy the public SSH key to the server:

```sh
export NIXOS_HOST=192.168.2.xxx
ssh-add ~/.ssh/id_ed25519
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@$NIXOS_HOST
```

SSH into the host with agent forwarding enabled:

```sh
ssh -A root@$NIXOS_HOST
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

After reboot, log in as `leyew`:

```sh
ssh leyew@$NIXOS_HOST
```
