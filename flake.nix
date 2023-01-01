{
  description = "haskell playground";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    flake-root.url = "github:srid/flake-root";
    mission-control.url = "github:Platonic-Systems/mission-control";
    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";

  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # systems = [ "x86_64-linux" ];
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.haskell-flake.flakeModule
        inputs.flake-root.flakeModule
        inputs.mission-control.flakeModule
        inputs.pre-commit-hooks-nix.flakeModule
      ];
      perSystem = { self', lib, config, pkgs, ... }: {
        haskellProjects.main = {
          packages = {
            # You can add more than one local package here.
            try-effectful.root = ./.; # Assumes ./my-package.cabal
          };
          # buildTools = hp: {
          #      treefmt = config.treefmt.build.wrapper;
          #    } // config.treefmt.build.programs;
          hlsCheck.enable = true;
          hlintCheck.enable = true;
        };
        pre-commit.settings.hooks = {
          nixpkgs-fmt.enable = true;
          cabal-fmt.enable = true;
        };
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.nixpkgs-fmt
            pkgs.pre-commit
          ];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
        #   treefmt.config = {
        #   inherit (config.flake-root) projectRootFile;
        #   package = pkgs.treefmt;

        #   programs.ormolu.enable = true;
        #   programs.nixpkgs-fmt.enable = true;

        #   # We use fourmolu
        #   programs.ormolu.package = pkgs.haskellPackages.fourmolu;
        #   settings.formatter.ormolu = {
        #     options = [
        #       "--ghc-opt"
        #       "-XImportQualifiedPost"
        #     ];
        #   };
        # };
        # Default shell.
        # devShells.default = config.mission-control.installToDevShell self'.devShells.main;
        packages.default = self'.packages.main-try-effectful;
      };
    };
}
