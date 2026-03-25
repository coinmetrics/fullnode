{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "coregeth";
  version = "1.12.21";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-twy9IVmciSlaC1pAb/7VbXjpg4JFQUt0n1NhEsP+vfU=";
  };

  vendorHash = "sha256-CzHhxtZu/7zQ6Wbm+bKkDrQ91FyLTpcJ0u7O0QDaAXQ=";

  proxyVendor = true;

  # Tests require network access.
  doCheck = false;
}
