{
  config,
  lib,
  ...
}:
{
  options.managenet.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Manage NetworkManager profiles automatically";
  };

  config = lib.mkIf config.managenet.enable {
  };
}
