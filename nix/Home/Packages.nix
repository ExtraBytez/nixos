{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
    htop
    gh
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-history-substring-search
    zsh-fzf-tab
  ];
}
