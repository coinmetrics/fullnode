{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "coregeth";
  version = "1.12.15";

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-MtE+a3XykBZg6IybTwMCwMsBQ1Be7OQQe2Ukp0pjawo=";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-u1u4L4GcqIBFyoStBx3JXkrYcingTfKlpQfAwKnz45g=";
  };

  proxyVendor = true;
  doCheck = false;
}
