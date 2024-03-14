{ username, ... }: {
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/home/${username}/DataDrive" = {
    device = "/dev/disk/by-partuuid/11827cc7-ef8d-4a0f-8838-a1bd6c555870";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

  fileSystems."home/${username}/SDCard" = {
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