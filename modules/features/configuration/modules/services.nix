{
  userName,
  deviceID,
  ...
}:
{
  services = {
    # UNCOMMENT THE FOLLOWING IF YOU ARE ON LAPTOP, simply remove the # from the following lines, remove this line afterwrds.
    # power-profiles-daemon.enable = true;
    # upower.enable = true;
    fprintd.enable = true;
    udisks2.enable = true;
    dbus.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;
    libinput.enable = true;
    pcscd.enable = true;
    # ENABLE SYNCTHING (OPTIONAL)
    # syncthing = {
    #   enable = true;
    #   dataDir = "/home/${userName}/";
    #   user = userName;
    #   openDefaultPorts = true;
    #   overrideFolders = true;
    #   group = "users";
    #   settings = {
    #     folders = {
    #       "/home/${userName}/sync" = {
    #         enable = true;
    #         id = "sync";
    #         devices = [ "myphone" ];
    #       };
    #     };
    #     devices = {
    #       myphone.id = deviceID;
    #       myphone.addresses = [ "dynamic" ];
    #     };
    #   };

  };
}
