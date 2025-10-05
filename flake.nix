{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    my-neovim.url = "github:rtorresware/nvim.flake/main";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs";
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      my-neovim,
      darwin,
      nix-rosetta-builder,
      ...
    }:
    let
      hostname = "macbook-2";
      system = "aarch64-darwin";
      neovim = my-neovim.defaultPackage.${system};
    in
    {
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          inherit neovim home-manager;
        };
        modules = [
          # An existing Linux builder is needed to initially bootstrap `nix-rosetta-builder`.
          # If one isn't already available: comment out the `nix-rosetta-builder` module below,
          # uncomment this `linux-builder` module, and run `darwin-rebuild switch`:
          #{ nix.linux-builder = {enable = true;     ephemeral = true;}; }
          # Then: uncomment `nix-rosetta-builder`, remove `linux-builder`, and `darwin-rebuild switch`
          # a second time. Subsequently, `nix-rosetta-builder` can rebuild itself.
          nix-rosetta-builder.darwinModules.default
          {
            # see available options in module.nix's `options.nix-rosetta-builder`
            nix-rosetta-builder.onDemand = true;
          }
          home-manager.darwinModules.home-manager
          ./default.nix
        ];
      };
    };
}
