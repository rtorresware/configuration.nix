{
  neovim,
  devenv,
  ...
}:
let
  home = "/Users/rtorres";
  prefix = "${home}/.npm-packages";
in
{
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;

  users.users.rtorres.home = home;

  nix.settings = {
    experimental-features = "nix-command flakes";
    extra-substituters = [ "https://devenv.cachix.org" ];
    extra-trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = false;
  home-manager.users.rtorres =
    { pkgs, ... }:
    {
      nixpkgs.config = {
        allowUnfree = true;
        input-fonts.acceptLicense = true;
      };

      home.stateVersion = "24.05";
      home.packages =
        [
          neovim
          devenv
        ]
        ++ (with pkgs; [
          ripgrep
          nodejs
          direnv
          any-nix-shell
          go-2fa
          obsidian
          openssh
          input-fonts
        ]);

      home.homeDirectory = home;
      home.sessionVariables = {
        GIT_EDITOR = "nvim";
        EDITOR = "nvim";
        PREFIX = prefix;
      };
      home.sessionPath = [
        "${prefix}/bin"
      ];

      programs.git = {
        enable = true;
        userName = "Rodolfo Torres";
        userEmail = "rtorresware@gmail.com";
      };
      programs.fish = {
        enable = true;
        plugins = [
          {
            name = "fenv";
            src = pkgs.fishPlugins.foreign-env.src;
          }
        ];
        shellInit = ''
          set -gx PATH ${prefix}/bin $PATH
        '';
        interactiveShellInit = ''
          ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
          fenv . /etc/zshenv
          set -gx PATH ${prefix}/bin $PATH
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
          foreground = "#e0def4";
          background = "#191724";
          selection_foreground = "#e0def4";
          selection_background = "#403d52";

          cursor = "#524f67";
          cursor_text_color = "#e0def4";

          url_color = "#c4a7e7";

          active_tab_foreground = "#e0def4";
          active_tab_background = "#26233a";
          inactive_tab_foreground = "#6e6a86";
          inactive_tab_background = "#191724";

          # black
          color0 = "#26233a";
          color8 = "#6e6a86";

          # red
          color1 = "#eb6f92";
          color9 = "#eb6f92";

          # green
          color2 = "#31748f";
          color10 = "#31748f";

          # yellow
          color3 = "#f6c177";
          color11 = "#f6c177";

          # blue
          color4 = "#9ccfd8";
          color12 = "#9ccfd8";

          # magenta
          color5 = "#c4a7e7";
          color13 = "#c4a7e7";

          # cyan
          color6 = "#ebbcba";
          color14 = "#ebbcba";

          # white
          color7 = "#e0def4";
          color15 = "#e0def4";
          #foreground = "#575279";
          #background = "#faf4ed";
          #selection_foreground = "#575279";
          #selection_background = "#dfdad9";
          #cursor = "#cecacd";
          #cursor_text_color = "#575279";
          #url_color = "#907aa9";
          #active_tab_foreground = "#575279";
          #active_tab_background = "#f2e9e1";
          #inactive_tab_foreground = "#9893a5";
          #inactive_tab_background = "#faf4ed";
          #active_border_color = "#286983";
          #inactive_border_color = "#dfdad9";
          ## black
          #color0 = "#f2e9e1";
          #color8 = "#9893a5";
          ## red
          #color1 = "#b4637a";
          #color9 = "#b4637a";
          ## green
          #color2 = "#286983";
          #color10 = "#286983";
          ## yellow
          #color3 = "#ea9d34";
          #color11 = "#ea9d34";
          ## blue
          #color4 = "#56949f";
          #color12 = "#56949f";
          ## magenta
          #color5 = "#907aa9";
          #color13 = "#907aa9";
          ## cyan
          #color6 = "#d7827e";
          #color14 = "#d7827e";
          ## white
          #color7 = "#575279";
          #color15 = "#575279";
        };
        keybindings = {
          "ctrl+shift+equal" = "change_font_size all +0.5";
          "ctrl+shift+minus" = "change_font_size all -0.5";
        };
      };
    };
}
