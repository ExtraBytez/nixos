{
  config,
  lib,
  ...
}:

let

  cfg = config.hello;
in
{
  options.hello = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Hello World";
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
