{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "coregeth";
  version = "1.12.17";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-FKa3l14wl6pxXwsyTEAymTwJffuneSY26ZYQd0/JVWE=";
  };

  vendorHash = "sha256-oJeftK5bxNRi+1DlyahGlm4iamvjtZV2/J/62l3Jl6s=";

  proxyVendor = true;

  # Tests require network access.
  doCheck = false;
}
