{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
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
  virtualisation.docker.enable = true;
  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
  };
}
