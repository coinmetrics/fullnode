{ nixpkgs, version }:
rec {
  package = nixpkgs.callPackage (./. + "/polkadot-${version}.nix") { };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/polkadot" ];
      User = "1000:1000";
    };
  };
}
