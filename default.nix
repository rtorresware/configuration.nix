{
  neovim,
  pkgs-unstable,
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
        [ neovim ]
        ++ (with pkgs; [
          ripgrep
          nodejs
          direnv
          any-nix-shell
          go-2fa
          obsidian
          openssh
          input-fonts
        ])
        ++ [ pkgs-unstable.devenv ];

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
      programs.zsh.completionInit = "autoload -U compinit && compinit -i";
    };
}
