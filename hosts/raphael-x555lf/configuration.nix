# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "raphael-x555lf"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable OpenGL
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    prime = {
      sync.enable = true;
      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:4:0:0";
      # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
    };


    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure auto upgrade
  system.autoUpgrade = {
    enable = true;
    dates = "*-*-* 04:00:00";
    persistent = true;
    allowReboot = true;
  };

  # Enable auto garbace collect
  nix.gc = {
    automatic = true;
    persistent = false;
    dates = "daily";
    options = "--delete-older-than 1w";
  };

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable auto optimise
  nix.settings.auto-optimise-store = true;

  # Configure kernel update
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Prevent system from sleeping
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable i3 Window Manager.
  services.xserver.windowManager.i3.enable = true;
  services.displayManager.defaultSession = "none+i3";
  # services.xserver.desktopManager.xterm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "br";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio =
    {
      enable = true;
      # configFile = pkgs.writeText "default.pa" ''
      #   load-module module-bluetooth-policy
      #   load-module module-bluetooth-discover
      #   ## module fails to load with 
      #   ##   module-bluez5-device.c: Failed to get device path from module arguments
      #   ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
      #   # load-module module-bluez5-device
      #   # load-module module-bluez5-discover
      # '';
      extraConfig = "load-module module-combine-sink";
    };
  # OR
  # services.pipewire = {
  #   enable = true;
  # pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Laptop power management
  services.power-profiles-daemon.enable = false;

  # auto-cpufreq
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "always";
      };
    };
  };

  # tlp service
  #
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;
  #
  #    #Optional helps save long term battery health
  #    # START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #    # STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #
  #   };
  # };

  # gtk.enable = true;

  # Enable steam
  # programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true;
  # programs.gamemode.enable = true;

  # programs.nix-ld =
  #   {
  #     enable = true;
  #     libraries = with pkgs; [
  #       ruff
  #     ];
  #   };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.raphaelac = {
    isNormalUser = true;
    initialPassword = "changeMe";
    description = "raphaelac";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "0xProto" ]; })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # utils
    firefox # web browser built from Firefox source tree
    # librewolf # fork of Firefox, focused on privacy, security and freedom
    git # distributed version control system

    # system tools
    python3 # high-level dynamically-typed programming language
    # erlang # programming language used for massively scalable soft real-time systems
    # gleam # statically typed language for the Erlang VM
    # lua # statically typed language for the Erlang VM
    rustup # rust toolchain installer
    zig # general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software
    gccgo # system C compiler (wrapper script)
    cmake # cross-platform, open-source build system generator
    gnumake # tool to control the generation of non-source files from sources
    i3 # tiling window manager

    # audio
    pulseaudio # sound server for POSIX and Win32 systems
    pulseaudioFull # sound server for POSIX and Win32 systems
    libpulseaudio # sound server for POSIX and Win32 systems
    polybar-pulseaudio-control # polybar module to control PulseAudio devices, also known as Pavolume
    pulseaudio-module-xrdp # xrdp sink/source pulseaudio modules

    # archives
    zip # compressor/archiver for creating and modifying zipfiles
    xz # general-purpose data compression software, successor of LZMA
    unzip # extraction utility for archives compressed in .zip format
    p7zip # new p7zip fork with additional codecs and improvements (forked from https://sourceforge.net/projects/p7zip/)
    unrar # utility for RAR archives

    # graphics
    intel-gpu-tools # tools for development and testing of the Intel DRM driver
    xorg.xf86videonouveau
    xorg.xf86videofbdev
    xorg.xf86videovesa
    nvd # nix/NixOS package version diff tool

  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
