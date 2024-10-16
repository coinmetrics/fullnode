{ buildGo122Module, fetchFromGitHub }:
buildGo122Module rec {
  pname = "coregeth";
  version = "1.12.20";

  src = fetchFromGitHub {
    owner = "etclabscore";
    repo = "core-geth";
    rev = "refs/tags/v${version}";
    hash = "sha256-+xfV1SNAOSSBRPZuEAFsyIzEMdjsKAyGo1URy9J+e2o=";
  };

  vendorHash = "sha256-CzHhxtZu/7zQ6Wbm+bKkDrQ91FyLTpcJ0u7O0QDaAXQ=";

  proxyVendor = true;

  # Tests require network access.
  doCheck = false;
}
