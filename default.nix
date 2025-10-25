{ neovim, pkgs, ...  }:
let
  home = "/Users/rtorres";
  prefix = "${home}/.npm-packages";
in
{
  programs = {
    zsh.enable = true;
    fish = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;  # Better Nix + direnv integration
    };
  };

  system.stateVersion = 6;
  environment.shells = [ pkgs.fish ];
  users.users.rtorres.home = home;
  nix.settings = {
    experimental-features = "nix-command flakes";
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
      home.stateVersion = "25.11";
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
          devenv
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
      programs.fish.enable = true;
    };
}
