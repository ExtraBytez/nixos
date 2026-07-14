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
    p7zip
    ffmpeg
    caligula
    duf
    dust
    eza
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
}
