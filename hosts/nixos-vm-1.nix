{
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];

  networking.hostName = "nixos-vm-1";
  networking.useDHCP = true;

  services.qemuGuest.enable = true;
}
