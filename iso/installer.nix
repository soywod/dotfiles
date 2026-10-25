# Live installer for the server: the NixOS minimal installer with the console
# of the signer (dvorak, caps lock and ctrl swapped, root auto-login), wifi
# through nmtui, and SSH for nixos-anywhere with the GPG authentication
# subkey. Nothing persists: writes go to RAM.
{
  lib,
  modulesPath,
  ...
}:

{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  image.baseName = lib.mkForce "installer";
  isoImage.volumeID = "INSTALLER";

  networking.hostName = "installer";

  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
    options = "ctrl:swapcaps";
  };
  time.timeZone = "Europe/Paris";

  services.getty.autologinUser = lib.mkForce "root";
  users.users.root.openssh.authorizedKeys.keys = [ (lib.fileContents ../ssh.pub) ];
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  system.stateVersion = "26.05";
}
