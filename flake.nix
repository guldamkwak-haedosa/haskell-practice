{
  description = "fmmdosa-json";

  inputs = {
    #fmmdosa.url = "git+ssh://git@github.com/haedosa/fmmdosa";
    #nixpkgs.follows = "fmmdosa/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs =
    inputs@{ self, nixpkgs, flake-utils,  ... }:
    {
      overlay = nixpkgs.lib.composeManyExtensions
        (
          with inputs;[]
        );
    } // flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs {
          inherit system;
          config = {};
          overlays = [ self.overlay ];
        };
      in
      rec {

        devShells.default = import ./develop.nix { inherit pkgs; };

        # packages = {
        #   default = pkgs.haskellPackages.fmmdosa-golden;
        # };

      }
    );

}
