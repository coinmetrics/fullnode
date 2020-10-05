{ nixpkgs, version }:
with nixpkgs; rec {
  package = buildGoModule {
    pname = "cosmos";
    inherit version;

    vendorSha256 = {
      "2.0.13" = "1d08jx6wv8wr48lk9lwv2rs8ax6dcd1vs30bbhdp2yc104j2cyk8";
    }.${version} or (builtins.trace "Cosmos fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/cosmos/gaia.git";
      ref = "refs/tags/v${version}";
    };

    buildFlagsArray = [ ("-ldflags=" + builtins.concatStringsSep " " [
      "-X github.com/cosmos/cosmos-sdk/version.Name=gaia"
      "-X github.com/cosmos/cosmos-sdk/version.ServerName=gaiad"
      "-X github.com/cosmos/cosmos-sdk/version.ClientName=gaiacli"
      "-X github.com/cosmos/cosmos-sdk/version.Version=${version}"
    ]) ];

    runVend = true;
    doCheck = false;
  };

  # initial home dir
  home = runCommand "cosmos-home" {} ''
    mkdir -p $out/opt
    ${package}/bin/gaiad init --home $out/opt coinmetrics
    ln -sf /genesis.json $out/opt/config/genesis.json
    ln -s ${builtins.fetchurl "https://raw.githubusercontent.com/cosmos/launch/master/genesis.json"} $out/genesis.json
    mv $out/opt/config $out/opt/init-config
    ln -s /tmp/config $out/opt/config
  '';

  # this default entrypoint expects:
  # tmpfs to be mapped to /tmp
  # genesis.json to be mapped to /genesis.json (if different from default cosmos)
  # /opt/data to be mapped to data folder
  # env var SEEDS to be set to comma-separated list of seeds
  entrypoint = writeScript "cosmos-entrypoint" ''
    set -e
    ${busybox}/bin/cp -r /opt/init-config /tmp/config
    ${busybox}/bin/chmod -R u+w /tmp/config
    ${busybox}/bin/sed -i -e "s/seeds = \"\"/seeds = \"$SEEDS\"/" -e 's?laddr = "tcp://127.0.0.1:26657"?laddr = "tcp://0.0.0.0:26657"?' /tmp/config/config.toml
    exec -- gaiad --home /opt $*
  '';

  imageConfig = {
    config = {
      Entrypoint = [ "${bash}/bin/bash" entrypoint ];
      Env = [ "PATH=${package}/bin" ];
      User = "1000:1000";
    };
    contents = [ home ];
  };
}
