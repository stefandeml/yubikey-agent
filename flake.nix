{
  description = "A basic gomod2nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gomod2nix.url = "github:nix-community/gomod2nix";

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
    # (flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems ++ [flake-utils.lib.system.aarch64-darwin])
    #   (system:
        let
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            overlays = [ gomod2nix.overlays.default ];
          };

        in
        {
          packages.aarch64-darwin.default = pkgs.callPackage ./. { };
          devShells.aarch64-darwin.default = import ./shell.nix { inherit pkgs self; };
        };
    # )
}
