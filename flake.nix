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
          hlsCheck.enable = true;
          hlintCheck.enable = true;
        };
        pre-commit.settings.hooks = {
          nixpkgs-fmt.enable = true;
          cabal-fmt.enable = true;
          fourmolu.enable = true;
        };
        mission-control.scripts = {
          docs = {
            description = "Start Hoogle server for project dependencies";
            exec = ''
              echo http://127.0.0.1:8888
              hoogle serve -p 8888 --local
            '';
            category = "Dev Tools";
          };
          repl = {
            description = "Start the cabal repl";
            exec = ''
              cabal repl "$@"
            '';
            category = "Dev Tools";
          };
        };
        devShells.default = config.mission-control.installToDevShell (pkgs.mkShell
          {
            nativeBuildInputs = [
              pkgs.nixpkgs-fmt
              pkgs.pre-commit
            ];
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          } // self'.devShells.main);
        packages.default = self'.packages.main-try-effectful;
      };
    };
}
