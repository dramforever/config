{ pkgs, ... }:

{
  imports = [
    ./rpi4.nix
    ./gravity.nix
  ];

  networking.hostName = "madoka";

  services.radvd = {
    enable = true;
    config = ''
      interface lan0 {
        AdvSendAdvert on;
        prefix 2a0c:b641:69c:baba::/64 {
          AdvOnLink on;
          AdvAutonomous on;
        };
      };
    '';
  };

  environment.systemPackages = with pkgs; [ wpa_supplicant libraspberrypi ];

  programs.vim.defaultEditor = true;

  services.sshd.enable = true;

  users.users.builder = {
    isNormalUser = true;
  };

  security.sudo.extraRules = [
    {
      users = [ "builder" ];
      commands = [
        { command = "ALL"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  # nix.package = pkgs.nixUnstable;
  nix.autoOptimiseStore = true;
  nix.binaryCaches = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  nix.trustedUsers = [ "root" "builder" ];

  nix.extraOptions =
    let flakesEmpty = pkgs.writeText "flakes-empty.json" (builtins.toJSON { flakes = []; version = 2; });
    in ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
      flake-registry = ${flakesEmpty}
      builders-use-substitutes = true
    '';

  nix.gc = {
    automatic = true;
    dates = "sunday";
    options = "--delete-older-than 8d";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
}
