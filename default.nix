{
  neovim,
  aider-chat,
  anthropic_key,
  ...
}:
{
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;

  users.users.rtorres.home = "/Users/rtorres";

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
          aider-chat
        ]
        ++ (with pkgs; [
          devenv
          ripgrep
          direnv
          any-nix-shell
          go-2fa
          obsidian
          openssh

          (python311.withPackages (ps: [
            llm
            (python311.pkgs.buildPythonPackage rec {
              pname = "llm-claude-3";
              version = "0.4.1";
              format = "wheel";
              src = fetchPypi {
                inherit version format;
                pname = "llm_claude_3";
                dist = "py3";
                python = "py3";
                hash = "sha256-MO5FJECHRFsvry7w+7bf4FsdzDX1ZzZCYX4mScNHcBA=";
              };
              meta = {
                homepage = "https://github.com/simonw/llm-claude-3/tree/main";
                description = "LLM access to Claude 3 by Anthropic";
              };

              propagatedBuildInputs = with python311.pkgs; [
                llm
                anthropic
              ];
            })
          ]))

          input-fonts
        ]);

      home.homeDirectory = "/Users/rtorres";
      home.sessionVariables = {
        GIT_EDITOR = "nvim";
        EDITOR = "nvim";
        ANTHROPIC_API_KEY = anthropic_key;
      };

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
          foreground = "#575279";
          background = "#faf4ed";
          selection_foreground = "#575279";
          selection_background = "#dfdad9";
          cursor = "#cecacd";
          cursor_text_color = "#575279";
          url_color = "#907aa9";
          active_tab_foreground = "#575279";
          active_tab_background = "#f2e9e1";
          inactive_tab_foreground = "#9893a5";
          inactive_tab_background = "#faf4ed";
          active_border_color = "#286983";
          inactive_border_color = "#dfdad9";
          # black
          color0 = "#f2e9e1";
          color8 = "#9893a5";
          # red
          color1 = "#b4637a";
          color9 = "#b4637a";
          # green
          color2 = "#286983";
          color10 = "#286983";
          # yellow
          color3 = "#ea9d34";
          color11 = "#ea9d34";
          # blue
          color4 = "#56949f";
          color12 = "#56949f";
          # magenta
          color5 = "#907aa9";
          color13 = "#907aa9";
          # cyan
          color6 = "#d7827e";
          color14 = "#d7827e";
          # white
          color7 = "#575279";
          color15 = "#575279";
        };
        keybindings = {
          "ctrl+shift+equal" = "change_font_size all +0.5";
          "ctrl+shift+minus" = "change_font_size all -0.5";
        };
      };
    };
}
