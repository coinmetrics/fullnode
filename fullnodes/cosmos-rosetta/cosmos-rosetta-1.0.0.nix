{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "cosmos-rosetta";
  version = "1.0.0";

  vendorHash = "sha256-e1O0rJpthFiM6vbidNkV01xs7nkqDdeM6PsS26I6IX4=";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = "cosmos-rosetta-gateway";
    rev = "d7f579c2824be3646cff989e628267a3914ddb86";
    sha256 = "sha256-tTNQxQydVR6q/NsQ3puIho9lpju4oiJa+S/kl7i+zDA=";
  };

  proxyVendor = true;
  doCheck = false;
}
