{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "coregeth";
    inherit version;

    vendorSha256 = {
      "1.11.17" = "059zm6w0v7khaqslfjnfwsb908f6xz999yknhr1ihx1wyzirkkp3";
      "1.11.18" = "059zm6w0v7khaqslfjnfwsb908f6xz999yknhr1ihx1wyzirkkp3";
      "1.11.19" = "059zm6w0v7khaqslfjnfwsb908f6xz999yknhr1ihx1wyzirkkp3";
      "1.11.20" = "0332gw2x0lfxc8x8dnmshid0ar1sxfd3g57zp7mdaqbjib207cvb";
    }.${version} or (builtins.trace "CoreGeth fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/etclabscore/core-geth.git";
      ref = "refs/tags/v${version}";
    };

    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/geth" ];
      User = "1000:1000";
    };
  };
}
