{
  description = "Learn You a Haskell";
  inputs = {
    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils, ...}@inputs: {
    overlay = nixpkgs.lib.composeManyExtensions
      [(final: prev:
        {
          haskellPackages = prev.haskellPackages.extend
            (hfinal: hprev: {
              learnyouahaskell = hfinal.callCabal2nix "learnyouahaskell" ./. {};
            });
        }
      )];
  } // flake-utils.lib.eachDefaultSystem
    (system:
    let
      pkgs = import nixpkgs { inherit system; overlays = [self.overlay]; };
    in rec {
      devShells = {
        default = pkgs.haskellPackages.shellFor {
          packages = p:[
            p.learnyouahaskell
          ];
          buildInputs=[
            pkgs.haskellPackages.haskell-language-server
            pkgs.haskellPackages.cabal-install
          ];
        };
      };
      packages = {
        default = pkgs.haskellPackages.learnyouahaskell;
      };
      apps = {
        default = {
          type = "app";
          program = "${packages.default}/bin/hello";
        };
        first = {
          type = "app";
          program = "${packages.default}/bin/first";
        };
      };
    }
  );
}
