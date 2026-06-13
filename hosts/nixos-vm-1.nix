{
  networking.hostName = "nixos-vm-1";
  networking.useDHCP = true;

  services.qemuGuest.enable = true;
}
