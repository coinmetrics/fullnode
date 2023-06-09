{ buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, leveldb
, openssl
}:
let
  version = "3.5.0";

  neoModules = buildDotnetModule {
    inherit version;
    pname = "neo-modules";

    src = fetchFromGitHub {
      owner = "neo-project";
      repo = "neo-modules";
      rev = "refs/tags/v${version}";
      hash = "sha256-iSikj9xgJftBZI0C5CJIhbCWNsCkpfevCOsmyOUmTn0=";
    };

    dotnet-sdk = dotnetCorePackages.sdk_6_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;
    nugetDeps = ./neo-modules-3.5.0-deps.nix;
  };
in buildDotnetModule {
  inherit version;
  pname = "neo";

  src = fetchFromGitHub {
    owner = "neo-project";
    repo = "neo-node";
    rev = "refs/tags/v${version}";
    hash = "sha256-1rlI2tThFe1gzCtxnHhedlkU33qOPUsUA7I4Ssr9uQs=";
  };

  runtimeDeps = [
    leveldb
    openssl
  ];

  selfContainedBuild = true;

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;
  nugetDeps = ./neo-3.5.0-deps.nix;
  projectFile = "./neo-cli/neo-cli.csproj";

  postInstall = ''
    plugins=$out/lib/neo/Plugins

    mkdir -p $plugins/{LevelDBStore,RpcServer}
    cp ${neoModules}/lib/neo-modules/LevelDBStore.dll $plugins/LevelDBStore
    cp ${neoModules}/lib/neo-modules/RpcServer.dll $plugins/RpcServer
  '';
}
