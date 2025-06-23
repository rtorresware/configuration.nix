{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    my-neovim.url = "github:rtorresware/nvim.flake/main";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    {
      home-manager,
      my-neovim,
      darwin,
      nixpkgs-unstable,
      ...
    }:
    let
      hostname = "macbook-2";
      system = "aarch64-darwin";
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      neovim = my-neovim.defaultPackage.${system};
    in
    {
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          inherit neovim home-manager pkgs-unstable;
        };
        modules = [
          home-manager.darwinModules.home-manager
          ./default.nix
        ];
      };
    };
}
