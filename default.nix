{ inputs, ... }:
{
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;

  users.users.rtorres.home = "/Users/rtorres";

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = false;
  home-manager.users.rtorres = { pkgs, ... } : {
    nixpkgs.config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
      extra-substituters = "https://devenv.cachix.org";
      extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    };
    nix.settings.experimental-features = ["nix-command" "flakes"];

    home.stateVersion = "24.11";
    home.packages = with pkgs;
    [
      inputs.devenv.packages.${home-manager.system}.devenv
      inputs.neovim.defaultPackage.${home-manager.system}
      ripgrep
      direnv
      any-nix-shell
      go-2fa
      obsidian
      openssh

      nil
      nixpkgs-fmt
      input-fonts
    ];
  
    home.homeDirectory = "/Users/rtorres";
    home.sessionVariables = {
      GIT_EDITOR = "nvim";
      EDITOR = "nvim";
    };
  
    programs.git = {
      enable = true;
      userName = "Rodolfo Torres";
      userEmail = "rtorresware@gmail.com";
    };
    programs.fish = {
      enable = true;
      plugins = [
	{ name = "fenv"; src = pkgs.fishPlugins.foreign-env.src; }
      ];
      interactiveShellInit = ''
	${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
	fenv . /etc/zshenv
      '';
    };

    programs.direnv.enable = true;
    programs.zsh.enable = true;

    programs.kitty = {
      enable = true;
      theme = "Tomorrow";
      settings = {
	font_family = "Input Mono";
	font_size = "12.5";
	adjust_line_height = "115%";
	draw_minimal_borders = false;
	window_margin_width = 10;
      };
      keybindings = {
        "ctrl+shift+equal" = "change_font_size all +0.5";
        "ctrl+shift+minus" = "change_font_size all -0.5";
      };
    };
  };
}
