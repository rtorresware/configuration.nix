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
      anthropic_key = builtins.readFile ./anthropic_key.txt;
      system = "aarch64-darwin";
      aider-chat = nixpkgs-unstable.legacyPackages.${system}.aider-chat;
      neovim = my-neovim.defaultPackage.${system};
    in
    {
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          inherit neovim home-manager anthropic_key aider-chat;
        };
        modules = [
          home-manager.darwinModules.home-manager
          ./default.nix
        ];
      };
    };
}
