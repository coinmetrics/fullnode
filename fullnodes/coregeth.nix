{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "coregeth";
    inherit version;
    vendorSha256 = {
      "1.11.9" = "0ljpl6s48f93x0sc9j7yibs03v2an5m33q34zp7qa42k4qj6k4xn";
      "1.11.10" = "0ljpl6s48f93x0sc9j7yibs03v2an5m33q34zp7qa42k4qj6k4xn";
      "1.11.11" = "0ljpl6s48f93x0sc9j7yibs03v2an5m33q34zp7qa42k4qj6k4xn";
    }.${version} or (builtins.trace "CoreGeth fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");
    src = builtins.fetchGit {
      url = "https://github.com/etclabscore/core-geth.git";
      ref = "refs/tags/v${version}";
    };

    overrideModAttrs = _: let
      usb = fetchFromGitHub {
        owner = "karalabe";
        repo = "usb";
        rev = "911d15fe12a9c411cf5d0dd5635231c759399bed";
        sha256 = "0asd5fz2rhzkjmd8wjgmla5qmqyz4jaa6qf0n2ycia16jsck6wc2";
      };
      in {
      postBuild = ''
        cp -r --reflink=auto ${usb}/libusb vendor/github.com/karalabe/usb
        cp -r --reflink=auto ${usb}/hidapi vendor/github.com/karalabe/usb
      '';
    };

    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/geth" ];
      User = "1000:1000";
    };
  };
}
