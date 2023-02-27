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
    in {
      devShells = {
        default = pkgs.haskellPackages.shellFor {
          packages = p:[
            p.learnyouahaskell
          ];
        };
      };
    }
  );
}
