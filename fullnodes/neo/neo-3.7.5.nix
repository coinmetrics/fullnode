{ buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, leveldb
, openssl
}:
let
  version = "3.7.5";

  neoModules = buildDotnetModule {
    inherit version;
    pname = "neo-modules";

    src = fetchFromGitHub {
      owner = "neo-project";
      repo = "neo-modules";
      rev = "refs/tags/v${version}";
      hash = "sha256-ROZWArqEhgPyAyN14+/xJ+xvPMi096jrRAWIXNnAIks=";
      fetchSubmodules = true;
    };

    dotnet-sdk = dotnetCorePackages.sdk_8_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
    nugetDeps = ./neo-modules-3.7.5-deps.nix;
    projectFile = [
      "./src/LevelDBStore/LevelDBStore.csproj"
      "./src/RpcServer/RpcServer.csproj"
    ];

    # The process cannot access the file '.../src/MPTTrie/bin/Release/net8.0/MPTTrie.deps.json' because it is being used by another process.
    enableParallelBuilding = false;
  };
in buildDotnetModule {
  inherit version;
  pname = "neo";

  src = fetchFromGitHub {
    owner = "neo-project";
    repo = "neo";
    rev = "refs/tags/v${version}";
    hash = "sha256-4ZwUro5Hk3Ic/VD+kjZGa2fODIkNrNoO+ihBZW/qRjY=";
  };

  runtimeDeps = [
    leveldb
    openssl
  ];

  selfContainedBuild = true;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  nugetDeps = ./neo-3.7.5-deps.nix;
  projectFile = "./src/Neo.CLI/Neo.CLI.csproj";

  postInstall = ''
    plugins=$out/lib/neo/Plugins

    mkdir -p $plugins/{LevelDBStore,RpcServer}
    cp ${neoModules}/lib/neo-modules/LevelDBStore.dll $plugins/LevelDBStore
    cp ${neoModules}/lib/neo-modules/RpcServer.dll $plugins/RpcServer
  '';
}
