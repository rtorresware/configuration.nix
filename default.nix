{ pkgs, inputs, ... }:
{
  programs.zsh.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  services.nix-daemon.enable = true;

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = false;
  home-manager.users.rtorres = { pkgs, ... } : {
    home.stateVersion = "22.11";
    home.packages = with pkgs;
    [
      inputs.devenv.defaultPackage.${home-manager.system}
      inputs.neovim.defaultPackage.${home-manager.system}
      ripgrep
      direnv
      any-nix-shell
      go-2fa
      obsidian
    ];
  
    home.sessionVariables = {
      GIT_EDITOR = "nvim";
      EDITOR = "nvim";
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
