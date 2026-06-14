{pkgs, ...}: {
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
  services.k3s = {
    enable = true;
    role = "server";

    extraFlags = [
      "--write-kubeconfig-mode=0640"
      "--write-kubeconfig-group=wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    kubectl
    k9s
  ];

  environment.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
}
