{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    tldr
    gitui
    tree
    termscp
    arp-scan
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
    macchanger
    gdb
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
