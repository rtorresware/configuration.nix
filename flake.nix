{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:rtorresware/nvim.flake";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/latest";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    let hostname = "macbook"; in {
      darwinConfigurations.${hostname} = inputs.darwin.lib.darwinSystem {
      	specialArgs = { inherit inputs; };
        system = "aarch64-darwin";
        modules = [
	  inputs.home-manager.darwinModules.home-manager
	  ./default.nix
        ];
      };
    };
}
