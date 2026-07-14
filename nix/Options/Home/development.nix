{
  config,
  lib,
  ...
}:

let

  cfg = config.development;
in
{
  options.development = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Development.";
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
