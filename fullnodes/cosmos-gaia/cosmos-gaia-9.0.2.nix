{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "cosmos-gaia";
  version = "9.0.2";

  vendorHash = "sha256-4HGl8y9nJSFJH+5AxxJoY6ejzseAcatubUOXndFufqI=";

  src = fetchFromGitHub {
    owner = "cosmos";
    repo = "gaia";
    rev = "refs/tags/v${version}";
    hash = "sha256-ozA2FT1ndUkaByEuu50mk2zIzuW/nbYkGDZC+6HrdZA=";
  };

  subPackages = [
    "cmd/gaiad"
  ];
}
