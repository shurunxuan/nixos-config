# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e62c9209-bcf7-4950-a206-3bb1b94ca2f2";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A754-C35D";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ac308b48-d74c-4cb2-9dac-9b62caeed6dd"; }
    ];

  fileSystems."/home/shurunxuan/DataDrive" =
    { device = "/dev/disk/by-uuid/6424-D35A";
      fsType = "exfat";
      options = [
        "users"
        "nofail"
        "uid=1000"
        "gid=100"
        "umask=022"
      ];
    };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wwan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}