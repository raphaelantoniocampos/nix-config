{ config, pkgs, ... }:

{
  home.username = "raphaelac";
  home.homeDirectory = "/home/raphaelac";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # command line tools
    neofetch # fast, highly customizable system info script
    discord # all-in-one cross-platform voice and text chat for gamers
    just # handy way to save and run project-specific commands

    # utils
    ripgrep # recursively searches directories for a regex pattern
    wget # tool for retrieving files using HTTP, HTTPS, and FTP
    xdotool # fake keyboard/mouse input, window management, and more
    fd # simple, fast and user-friendly alternative to find
    xclip # tool to access the X clipboard from a console application
    maim # command-line screenshot utility

    # dev tools
    neovim # vim text editor fork focused on extensibility and agility
    kitty # modern, hackable, featureful, OpenGL based terminal emulator
    lua # modern, hackable, featureful, OpenGL based terminal emulator
    vimPlugins.luasnip
    luajitPackages.luarocks # a package manager for Lua modules.
    ruff # extremely fast Python linter

    # networking tools
    networkmanagerapplet # networkManager control applet for GNOME

    # misc
    transmission_4-gtk # fast, easy and free BitTorrent client
    stow # tool for managing the installation of multiple software packages in the same run-time directory tree

    # nix related
    nix-output-monitor # processes output of Nix commands to show helpful and pretty information

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    # system tools
    killall
    lshw # provide detailed information on the hardware configuration of the machine
    lsof # tool to list open files
    gvfs # virtual Filesystem support library

    # customization
    feh # light-weight image viewer
    picom # fork of XCompMgr, a sample compositing manager for X servers
    polybarFull # fast and easy-to-use tool for creating status bars
    rofi # window switcher, run dialog and dmenu replacement
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Raphael Campos";
    userEmail = "raphaelcampos01@proton.me";
  };

  # # starship - an customizable prompt for any shell
  # programs.starship = {
  #   enable = true;
  #   # custom settings
  #   settings = {
  #     add_newline = false;
  #     aws.disabled = true;
  #     gcloud.disabled = true;
  #     line_break.disabled = true;
  #   };
  # };

  # # alacritty - a cross-platform, GPU-accelerated terminal emulator
  # programs.alacritty = {
  #   enable = true;
  #   # custom settings
  #   settings = {
  #     env.TERM = "xterm-256color";
  #     font = {
  #       size = 12;
  #       draw_bold_text_with_bright_colors = true;
  #     };
  #     scrolling.multiplier = 5;
  #     selection.save_to_clipboard = true;
  #   };
  # };
  #
  # programs.bash = {
  #   enable = true;
  #   enableCompletion = true;
  #   # TODO add your custom bashrc here
  #   bashrcExtra = ''
  #     export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
  #   '';
  #
  #   # set some aliases, feel free to add more or remove some
  #   shellAliases = {
  #     k = "kubectl";
  #     urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
  #     urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  #   };
  # };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
