{pkgs, ...}: {
  time.timeZone = "Asia/Singapore";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["leyew"];
    };
  };

  users.users.leyew = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICB1XswrDuoP2JQ799E8Ts7ge6qiENyibTFS93weVO96"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # basics
    bash
    sudo
    cacert
    curl
    wget
    unzip
    rsync

    # monitoring/debugging
    htop
    btop
    iotop
    strace

    # tools
    git
    jq
    ripgrep
    stow
    tree

    # editor
    vim
    neovim
    tmux

    # networking/debugging
    nmap
    traceroute
    tcpdump
    dnsutils

    # containers
    docker
    docker-buildx
    docker-compose

    # python
    python3
    uv

    # node/js
    nodejs

    # compiler fallback
    gcc

    # AI coding
    claude-code
    codex
  ];

  environment.shellAliases = {
    ll = "ls -al";
    dc = "docker compose";
    rebuild = "sudo nixos-rebuild switch --flake";
  };

  system.stateVersion = "26.05";
}
