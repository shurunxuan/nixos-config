{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Runxuan Shu";
    userEmail = "shurunxuan@hotmail.com";
    extraConfig = {
      push = { autoSetupRemote = true; };
      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4rh0Ao0c7DDjBavI7NtRfFe+1AmkbL5/AfbVR+tWNo";
      };
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
      commit = {
        gpgsign = true;
      };
    };
  };
}