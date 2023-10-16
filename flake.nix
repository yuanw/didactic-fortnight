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
    pre-commit = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # mission-control.url = "github:Platonic-Systems/mission-control";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # systems = [ "x86_64-linux" ];
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
         inputs.pre-commit.flakeModule
        inputs.haskell-flake.flakeModule
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
        # inputs.mission-control.flakeModule
      ];
      perSystem = { self', lib, system, config, pkgs, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
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
          flakeFormatter =
            false; # For https://github.com/numtide/treefmt-nix/issues/55

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
        # mission-control.scripts = {
        #   docs = {
        #     description = "Start Hoogle server for project dependencies";
        #     exec = ''
        #       echo http://127.0.0.1:8888
        #       hoogle serve -p 8888 --local
        #     '';
        #     category = "Dev Tools";
        #   };
        #   repl = {
        #     description = "Start the cabal repl";
        #     exec = ''
        #       cabal repl "$@"
        #     '';
        #     category = "Dev Tools";
        #   };
        #   fmt = {
        #     description = "Format the source tree";
        #     exec = config.treefmt.build.wrapper;
        #     category = "Dev Tools";
        #   };
        # };
        devShells.default = pkgs.mkShell {
           inputsFrom = [
            config.pre-commit.devShell
            config.treefmt.build.devShell
            config.haskellProjects.main.outputs.devShell
          ];
          buildInputs = [
            pkgs.rust-bin.beta.latest.default
          ];
          # inputsFrom = [ config.mission-control.devShell self'.devShells.main ];
        };
        packages.default = self'.packages.try-effectful;

      };
    };
}
