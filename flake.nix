{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:rtorresware/nvim.flake/main";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/latest";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    let hostname = "Rodolfos-MacBook-Pro-2"; in {
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
