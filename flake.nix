{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:rtorresware/nvim.flake/main";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = inputs:
    let 
      hostname = "macbook";
      anthropic_key = builtins.readFile ./anthropic_key.txt;
    in {
      darwinConfigurations.${hostname} = inputs.darwin.lib.darwinSystem {
      	specialArgs = { inherit inputs anthropic_key; };
        system = "aarch64-darwin";
        modules = [
	  inputs.home-manager.darwinModules.home-manager
	  ./default.nix
        ];
      };
    };
}
