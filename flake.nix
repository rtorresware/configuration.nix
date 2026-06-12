{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    herdr.url = "github:ogulcancelik/herdr/v0.6.9";
    herdr.inputs.nixpkgs.follows = "nixpkgs";
    my-neovim.url = "github:rtorresware/nvim.flake/main";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs";
    my-web.url = "github:rtorresware/web/main";
    my-web.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      home-manager,
      herdr,
      my-neovim,
      my-web,
      darwin,
      ...
    }:
    let
      hostname = "macbook-2";
      system = "aarch64-darwin";
      herdrPkg = herdr.packages.${system}.default;
      herdrSrc = herdr.outPath;
      neovim = my-neovim.defaultPackage.${system};
      web = my-web.packages.${system}.default;
    in
    {
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          inherit herdrPkg herdrSrc neovim web home-manager;
        };
        modules = [
          home-manager.darwinModules.home-manager
          ./default.nix
        ];
      };
    };
}
