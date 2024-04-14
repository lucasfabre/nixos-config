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
    # UI
    gnome.gnome-tweaks
    gnome-extension-manager
    colloid-icon-theme
    fluent-icon-theme
    nerdfonts
    gradience

    # Dev Apps
    neovim
    vscode
    github-desktop
    github-cli
    github-copilot-cli
    gitAndTools.gitflow
    lazygit
 
    # Utils
    tldr
    rclone
    unzip
    htop
    distrobox
    gamescope
    wl-clipboard

    # Apps
    wezterm
    dconf

    # Games
    wine
    winetricks
    protontricks
    steamtinkerlaunch

    # Dev env
    vagrant
    kubernetes
    helm
    oh-my-posh
    clang
    clang-tools
    nodejs
    python3
    ripgrep
    silver-searcher
    delta
    du-dust
    fd
    bat
    eza
    fzf
    jq
    zoxide
    thefuck
    neofetch
    nnn
    nixos-config

    lua-language-server
  ];

  # Package overlay
  nixpkgs.overlays = [
    (final: prev: {
      gradience = prev.gradience.overrideAttrs {
        version = "0.8.0-beta1";
        src = fetchGit {
          url = "https://github.com/GradienceTeam/Gradience.git";
          ref = "main";
          rev = "c878099d15a5488c5d6b4bc6dbb1a283a3032da0";
          submodules = true;
        };
        patches = prev.gradience.patches ++ [
          ./gradience/fix-permission-errors.patch
        ];
        propagatedBuildInputs = with pkgs.python3Packages; [
          anyascii
          jinja2
          lxml
          material-color-utilities
          pygobject3
          svglib
          yapsy
          libsass
        ];
      };
      nixos-config = pkgs.callPackage ./nixos-config/package.nix {};
      catppuccin-gtk = prev.catppuccin-gtk.override {
        accents = [ "peach" ]; # You can specify multiple accents here to output multiple themes
        size = "standard";
        tweaks = [ ]; # You can also specify multiple tweaks here
        variant = "macchiato";
      };
    })
  ];

  services.easyeffects.enable = true;

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  services.syncthing = {
    enable = true;
    extraOptions = [
      "--gui-address=127.0.0.1:8384"
    ];
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Peach-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "peach" ];
        size = "standard";
        tweaks = [  ];
        variant = "macchiato";
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

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
