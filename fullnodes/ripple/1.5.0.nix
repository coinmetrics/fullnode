# copied from nixpkgs 8eee3478aed0f86bc63f6b98811c4f117e78bb23 pkgs/servers/rippled/default.nix
# with hash fixes
{ stdenv, fetchFromGitHub, fetchgit, fetchurl, runCommand, git, cmake, pkgconfig
, openssl,  zlib, boost, grpc, c-ares, abseil-cpp, protobuf3_8 }:

let
  sqlite3 = fetchurl rec {
    url = "https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip";
    sha256 = "0vh9aa5dyvdwsyd8yp88ss300mv2c2m40z79z569lcxa6fqwlpfy";
    passthru.url = url;
  };

  boostSharedStatic = boost.override {
    enableShared = true; 
    enabledStatic = true;
  };

  beast = fetchgit {
    url = "https://github.com/boostorg/beast.git";
    rev = "2f9a8440c2432d8a196571d6300404cb76314125";
    sha256 = "1n9ms5cn67b0p0mhldz5psgylds22sm5x22q7knrsf20856vlk5a";
    fetchSubmodules = false;
    leaveDotGit = true;
  };

  docca = fetchgit {
    url = "https://github.com/vinniefalco/docca.git";
    rev = "335dbf9c3613e997ed56d540cc8c5ff2e28cab2d";
    sha256 = "1yisdg7q2p9q9gz0c446796p3ggx9s4d6g8w4j1pjff55655805h";
    fetchSubmodules = false;
    leaveDotGit = true;
  };

  nudb = fetchgit rec {
    url = "https://github.com/CPPAlliance/NuDB.git";
    rev = "2.0.1";
    sha256 = "10hlp2k7pc0c705f8sk0qw6mjfky0k08cjhh262bbjvp9fbdc7r4";
    leaveDotGit = true;
    fetchSubmodules = true;
    postFetch = "cd $out && git tag ${rev}";
  };

  rocksdb = fetchgit rec {
    url = "https://github.com/facebook/rocksdb.git";
    rev = "v6.5.3";
    sha256 = "0bzrvs1gcz6m5py14kgdc7q2ink9wz85q90mdglbj2dsn21vqi7a";
    deepClone = true;
    fetchSubmodules = false;
    leaveDotGit = true;
  };

  lz4 = fetchgit rec {
    url = "https://github.com/lz4/lz4.git";
    rev = "v1.8.2";
    sha256 = "1i3z2r72r1ya31lx5z4k5qyw2j9x03sdxr6yljh34q34gkylk92s";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  libarchive = fetchgit rec {
    url = "https://github.com/libarchive/libarchive.git";
    rev = "v3.3.3";
    sha256 = "0rhzw9rk87asr3naa6g3df1ggnbd24ksl4k8y03p179r940jravm";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  soci = fetchgit {
    url = "https://github.com/SOCI/soci.git";
    rev = "04e1870294918d20761736743bb6136314c42dd5";
    sha256 = "0w3b7qi3bwn8bxh4qbqy6c1fw2bbwh7pxvk8b3qb6h4qgsh6kx89";
    leaveDotGit = true;
    fetchSubmodules = false;
  };

  snappy = fetchgit rec {
    url = "https://github.com/google/snappy.git";
    rev = "1.1.7";
    sha256 = "1f0i0sz5gc8aqd594zn3py6j4w86gi1xry6qaz2vzyl4w7cb4v35";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  cares = fetchgit rec {
    url = "https://github.com/c-ares/c-ares.git";
    rev = "cares-1_15_0";
    sha256 = "1fkzsyhfk5p5hr4dx4r36pg9xzs0md6cyj1q2dni3cjgqj3s518v";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  google-test = fetchgit {
    url = "https://github.com/google/googletest.git";
    rev = "5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081";
    sha256 = "1ch7hq16z20ddhpc08slp9bny29j88x9vr6bi9r4yf5m77xbplja";
    leaveDotGit = true;
    fetchSubmodules = false;
  };

  google-benchmark = fetchgit {
    url = "https://github.com/google/benchmark.git";
    rev = "5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8";
    sha256 = "0kcmb83framkncc50h0lyyz7v8nys6g19ja0h2p8x4sfafnnm6ig";
    leaveDotGit = true;
    fetchSubmodules = false;
  };

  date = fetchgit {
    url = "https://github.com/HowardHinnant/date.git";
    rev = "fc4cf092f9674f2670fb9177edcdee870399b829";
    sha256 = "0w618p64mx2l074b6wd0xfc4h6312mabhvzabxxwsnzj4afpajcm";
    leaveDotGit = true;
    fetchSubmodules = false;
  };
in stdenv.mkDerivation rec {
  pname = "rippled";
  version = "1.5.0";

  src = fetchgit {
    url = "https://github.com/ripple/rippled.git";
    rev = version;
    sha256 = "0nh0x1ygrj3fw558vxbcp0md80qh27yrp3xhdlasrir7h1l2nplv";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  hardeningDisable = ["format"];
  cmakeFlags = ["-Dstatic=OFF" "-DBoost_NO_BOOST_CMAKE=ON"];

  nativeBuildInputs = [ pkgconfig cmake git ];
  buildInputs = [ openssl openssl.dev boostSharedStatic zlib grpc c-ares c-ares.cmake-config abseil-cpp protobuf3_8 ];

  preConfigure = ''
    export HOME=$PWD

    git config --global url."file://${rocksdb}".insteadOf "${rocksdb.url}"
    git config --global url."file://${docca}".insteadOf "${docca.url}"
    git config --global url."file://${lz4}".insteadOf "${lz4.url}"
    git config --global url."file://${libarchive}".insteadOf "${libarchive.url}"
    git config --global url."file://${soci}".insteadOf "${soci.url}"
    git config --global url."file://${snappy}".insteadOf "${snappy.url}"
    git config --global url."file://${nudb}".insteadOf "${nudb.url}"
    git config --global url."file://${google-benchmark}".insteadOf "${google-benchmark.url}"
    git config --global url."file://${google-test}".insteadOf "${google-test.url}"
    git config --global url."file://${date}".insteadOf "${date.url}"

    substituteInPlace Builds/CMake/deps/Sqlite.cmake --replace "URL ${sqlite3.url}" "URL ${sqlite3}"
  '';

  doCheck = true;
  checkPhase = ''
    ./rippled --unittest
  '';

  meta = with stdenv.lib; {
    description = "Ripple P2P payment network reference server";
    homepage = "https://github.com/ripple/rippled";
    maintainers = with maintainers; [ ehmry offline RaghavSood ];
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
  };
}
