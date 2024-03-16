{ username, ... }: {
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/home/${username}/Windows" = {
    device = "/dev/disk/by-partuuid/083854a2-1467-4c8a-af38-489d1c077633";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

  fileSystems."/home/${username}/SDCard" = {
    device = "/dev/disk/by-partuuid/a16d8284-4e44-41d5-b837-b6e56d208b47";
    fsType = "exfat";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };
}
