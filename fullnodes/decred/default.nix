{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/dcrd-${version}.nix") { };

  imageConfig = {
    config = {
      Entrypoint = [ "dcrd" ];
      User = "1000:1000";
      Env = [
        "PATH=${package}/bin:${pkgs.dcrctl}/bin"
      ];
    };

    contents = with pkgs.dockerTools; [
      caCertificates
    ];
  };
}
