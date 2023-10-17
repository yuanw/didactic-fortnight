{
  description = "haskell playground";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    flake-root.url = "github:srid/flake-root";
    rust-overlay.url = "github:oxalica/rust-overlay";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
      zig.url = "github:mitchellh/zig-overlay";
    pre-commit = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.pre-commit.flakeModule
        inputs.haskell-flake.flakeModule
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
      ];
      perSystem = { self', lib, system, config, pkgs, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          zigpkgs = inputs.zig.packages.${system};
          overlays = [
            inputs.rust-overlay.overlays.default
          ];
        };
        haskellProjects.main = {
          # packages = {
          #   # You can add more than one local package here.
          #   try-effectful.root = ./.; # Assumes ./my-package.cabal
          # };
          devShell = {
            tools = hp:
              {
                treefmt = config.treefmt.build.wrapper;
              } // config.treefmt.build.programs;
            hlsCheck.enable = true;
          };
        };
        treefmt.config = {
          inherit (config.flake-root) projectRootFile;
          package = pkgs.treefmt;

          programs.ormolu.enable = true;
          programs.nixpkgs-fmt.enable = true;
          programs.cabal-fmt.enable = true;
          programs.hlint.enable = true;

          # We use fourmolu
          programs.ormolu.package = pkgs.haskellPackages.fourmolu;
          settings.formatter.ormolu = {
            options = [ "--ghc-opt" "-XImportQualifiedPost" ];
          };
        };
        devShells.default = pkgs.mkShell {
         inputsFrom = [
            config.pre-commit.devShell
            config.treefmt.build.devShell
            config.haskellProjects.main.outputs.devShell
          ];
          buildInputs = [
            pkgs.zigpkgs.master
            pkgs.rust-bin.beta.latest.default
          ];
        };
        packages.default = self'.packages.try-effectful;

      };
    };
}
