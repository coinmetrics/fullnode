{ abseil-cpp
, boost
, buildGo120Module
, catch2
, cli11
, cmake
, fetchFromGitHub
, gbenchmark
, git
, gmp
, grpc
, gtest
, llvmPackages
, magic-enum
, microsoft-gsl
, mimalloc
, ninja
, nlohmann_json
, openssl
, overrideCC
, protobuf
, python3
, snappy
, spdlog
, sqlite
, sqlitecpp
, stdenv
, tl-expected
, tomlplusplus
, writeTextFile
}:

let
  asio-grpc = stdenv.mkDerivation rec {
    pname = "asio-grpc";
    version = "2.4.0";

    src = fetchFromGitHub {
      owner = "Tradias";
      repo = "asio-grpc";
      rev = "v${version}";
      hash = "sha256-/cYJ5AD0gEKlgjoOyy9VArvl+Qn+MQ0Ozu6UMqSufPM=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];
  };

  croaring = stdenv.mkDerivation rec {
    pname = "croaring";
    version = "1.1.2";

    src = fetchFromGitHub {
      owner = "RoaringBitmap";
      repo = "CRoaring";
      rev = "v${version}";
      hash = "sha256-1KxNAnp/TbZFYLE4d62nlTsqnwGnPyuCI64Tp/ewP6g=";
    };

    patches = [
      ./patches/fix-roaring-pkg-config.patch
    ];

    nativeBuildInputs = [
      cmake
      ninja
    ];
  };

  jwt-cpp = stdenv.mkDerivation rec {
    pname = "jwt-cpp";
    version = "0.6.0";

    src = fetchFromGitHub {
      owner = "Thalhammer";
      repo = "jwt-cpp";
      rev = "v${version}";
      hash = "sha256-d1FBDMJv0+E6un/UPknLOOnwfwHhyHh/vqyMM4wGnO0=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    buildInputs = [
      openssl
    ];

    cmakeFlags = [
      "-DJWT_DISABLE_PICOJSON=ON"
      "-DJWT_JSON_TRAITS_OPTIONS=nlohmann-json"
      "-DJWT_BUILD_EXAMPLES=OFF"
    ];
  };

  silkworm = stdenv.mkDerivation rec {
    pname = "silkworm";
    version = "capi-0.12.0";

    src = fetchFromGitHub {
      owner = "erigontech";
      repo = "silkworm";
      rev = "refs/tags/${version}";
      fetchSubmodules = true;
      leaveDotGit = true;
      hash = "sha256-LmJJRkwys4gsU5pwHJEKXG4uKZba2kXEa2VKK3zDE/g=";
    };

    patches = [
      ./patches/fix-silkworm.patch
    ];

    preConfigure = ''
      mkdir ./home
      export HOME=`pwd`/home

      cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="-Wno-unused-command-line-argument -Wno-deprecated-declarations")
    '';

    ninjaFlags = [
      "silkworm_capi"
    ];

    installPhase = ''
      mkdir -p $out/lib
      cp ./silkworm/capi/libsilkworm_capi.so $out/lib
    '';

    nativeBuildInputs = [
      # Header-only libraries
      asio-grpc
      cli11
      jwt-cpp
      spdlog
    ] ++ [
      cmake
      git
      ninja
    ];

    buildInputs = [
      abseil-cpp
      boost
      catch2
      croaring
      gbenchmark
      gmp
      grpc
      gtest
      magic-enum
      microsoft-gsl
      mimalloc
      nlohmann_json
      openssl
      protobuf
      snappy
      sqlite
      sqlitecpp
      tl-expected
      tomlplusplus
    ];

    cmakeFlags = [
      "-DGMP_LIBRARY=${gmp}/lib/libgmp.so"
      "-DGMP_INCLUDE_DIR=${gmp.dev}/include"
      "-DGRPC_CPP_PLUGIN_PROGRAM=${grpc}/bin/grpc_cpp_plugin"
    ];
  };

in buildGo120Module rec {
  pname = "erigon";
  version = "2.58.1";

  src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = "erigon";
    rev = "refs/tags/v${version}";
    hash = "sha256-plQdhci+WUbA9IKjxk/wrprZzzc72w52BnU7joMtCcw=";
  };

  vendorHash = "sha256-YGoCbenIqOm8NAxHEM/OW5hVpf6vcNPeIneM1I4J5tU=";

  silkworm-go-src = fetchFromGitHub {
    owner = "erigontech";
    repo = "silkworm-go";
    rev = "refs/tags/v0.12.0";
    hash = "sha256-25Eokgr1RgEMUuceHu7/HQdylli34OpAG1NCG+15I4Q=";
  };

  libsecp256k1-src = fetchFromGitHub {
    owner = "ledgerwatch";
    repo = "secp256k1";
    rev = "refs/tags/v1.0.0";
    hash = "sha256-Xp2FZSa+e246I8Pvk/ccc/j9JjgfURqa8nT7T9em7Rk=";
  };

  blst-src = fetchFromGitHub {
    owner = "supranational";
    repo = "blst";
    rev = "refs/tags/v0.3.11";
    hash = "sha256-oqljy+ZXJAXEB/fJtmB8rlAr4UXM+Z2OkDa20gpILNA=";
  };

  link-linux-x64 = writeTextFile {
    name = "link-linux-x64";
    executable = false;
    text = ''
      //go:build !nosilkworm && linux && amd64

      package silkworm_go

      // #cgo LDFLAGS: -lsilkworm_capi
      // #cgo LDFLAGS: -Wl,-rpath,$ORIGIN
      import "C"
    '';
  };

  buildInputs = [
    silkworm
  ];

  subPackages = [
    "cmd/erigon"
  ];

  modPostBuild = ''
    pushd vendor/github.com/ledgerwatch
    rm -rf secp256k1
    cp -a ${libsecp256k1-src} secp256k1
    popd

    pushd vendor/github.com/supranational
    rm -rf blst
    cp -a ${blst-src} blst
    popd

    pushd vendor/github.com/erigontech
    rm -rf silkworm-go
    cp -a ${silkworm-go-src} silkworm-go
    cd ./silkworm-go
    chmod 700 link_linux_x64.go
    cp ${link-linux-x64} link_linux_x64.go
    popd
  '';
}
