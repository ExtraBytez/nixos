{ ... }:
{
  boot = {
    consoleLogLevel = 0;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.enable = true;
      verbose = false;
    };
    kernelParams = [
      "quiet"
      "splash"
      "vt.global_cursor_default=0"
    ];
  };
}
