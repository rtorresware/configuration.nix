{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "/Users/rtorres/rtorresware/rtorres-nvim";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/v0.5.1";
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
