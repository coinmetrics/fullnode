{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101408.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-kJybcRkm+6sZz3k4S55BjdW8oTHw7+02mf7+0IHlvPM=";
  };

  vendorHash = "sha256-v/uPTTDudtBihcusxvhEECWEADY3Vlfwlfe7BAP+I84=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
