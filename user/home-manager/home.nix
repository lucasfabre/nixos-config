{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05";

  nixpkgs.config.permittedInsecurePackages = [
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "steam-run"
    "steam-original"
    "github-copilot-cli"
  ];


  home.packages = with pkgs; [
    neovim
    vscode
    gnome.gnome-tweaks
    gnome.gnome-terminal
    gnome-extension-manager
    papirus-icon-theme
    unzip
    oh-my-posh
    dconf
    nerdfonts
    clang
    nodejs
    python3
    ripgrep
    rclone
    bat
    zoxide
    distrobox
    gamescope
    wine
    winetricks
    protontricks
    steamtinkerlaunch
    lazygit
    github-desktop
    github-cli
    github-copilot-cli
    gitAndTools.gitflow
  ];

  home.file = {
  };

  services.easyeffects.enable = true;

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lucas/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";

    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    XDG_BIN_HOME    = "$HOME/.local/bin";

    STEAM_EXTRA_COMPAT_TOOL_PATHS = "$HOME/.local/share/Steam/compatibilitytools.d/";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
