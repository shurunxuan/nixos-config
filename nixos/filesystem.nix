{ username, ... }: {
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/home/${username}/Windows" = {
    device = "/dev/disk/by-partuuid/6698b7c2-9675-4a8b-bf99-de7e84aaccc3";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

  fileSystems."/home/${username}/DataDrive" = {
    device = "/dev/nvme1n1p1";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };
}
