{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    chafa
    pfetch
    playerctl
    cava
    yazi
    p7zip
    ffmpeg
    caligula
    duf
    dust
    eza
    lolcat
    killall
    unzip
    wget
    zsh
    fzf
    file
    jq
    ripgrep
    fd
  ];
  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
  };
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
}
