# copied from nixpkgs 3355e8d1ca1e6e414d5ef64da02fa5728f873e17 pkgs/servers/rippled/default.nix
# with hash fixes
{ stdenv, fetchFromGitHub, fetchgit, fetchurl, runCommand, git, cmake, pkgconfig
, openssl, boost, zlib }:

let
  sqlite3 = fetchurl rec {
    url = "https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip";
    sha256 = "0vh9aa5dyvdwsyd8yp88ss300mv2c2m40z79z569lcxa6fqwlpfy";
    passthru.url = url;
  };

  docca = fetchgit {
    url = "https://github.com/vinniefalco/docca.git";
    rev = "335dbf9c3613e997ed56d540cc8c5ff2e28cab2d";
    sha256 = "1yisdg7q2p9q9gz0c446796p3ggx9s4d6g8w4j1pjff55655805h";
    leaveDotGit = true;
    fetchSubmodules = false;
  };

  rocksdb = fetchgit rec {
    url = "https://github.com/facebook/rocksdb.git";
    rev = "v5.17.2";
    sha256 = "1wjphnjsxa6pnhkxkj27qzd6jgsv6b2dp6b8migkl392s5a26jxh";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
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

  nudb = fetchgit rec {
    url = "https://github.com/CPPAlliance/NuDB.git";
    rev = "2.0.1";
    sha256 = "10hlp2k7pc0c705f8sk0qw6mjfky0k08cjhh262bbjvp9fbdc7r4";
    leaveDotGit = true;
    fetchSubmodules = true; # submodules are needed, rocksdb is dependency
    postFetch = "cd $out && git tag ${rev}";
  };

  protobuf = fetchgit rec {
    url = "https://github.com/protocolbuffers/protobuf.git";
    rev = "v3.6.1";
    sha256 = "1bsslinaydg3yji4jgw7ahppsy057aavs1i5w9ajzgcq4lh7rvpz";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  google-test = fetchgit {
    url = "https://github.com/google/googletest.git";
    rev = "c3bb0ee2a63279a803aaad956b9b26d74bf9e6e2";
    sha256 = "07r1gggv9l8gadl2v5hcxvilk8prhicy7s19abs037fj8x50nvz2";
    fetchSubmodules = false;
    leaveDotGit = true;
  };

  google-benchmark = fetchgit {
    url = "https://github.com/google/benchmark.git";
    rev = "5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8";
    sha256 = "0kcmb83framkncc50h0lyyz7v8nys6g19ja0h2p8x4sfafnnm6ig";
    fetchSubmodules = false;
    leaveDotGit = true;
  };

  # hack to merge rocksdb revisions from rocksdb and nudb, so build process
  # will find both
  rocksdb-merged = runCommand "rocksdb-merged" {
    buildInputs = [ git ];
  } ''
    commit=$(cd ${nudb} && git ls-tree HEAD extras/rocksdb | awk '{ print $3  }')
    git clone ${rocksdb} $out && cd $out
    git fetch ${nudb}/extras/rocksdb $commit
    git checkout $commit
  '';
in stdenv.mkDerivation rec {
  pname = "rippled";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ripple";
    repo = "rippled";
    rev = version;
    sha256 = "1z04378bg8lcyrnn7sl3j2zfxbwwy2biasg1d4fbaq4snxg5d1pq";
  };

  hardeningDisable = ["format"];
  cmakeFlags = [
    "-Dstatic=OFF"
    "-DBOOST_LIBRARYDIR=${boost.out}/lib"
    "-DBOOST_INCLUDEDIR=${boost.dev}/include"
  ];

  nativeBuildInputs = [ pkgconfig cmake git ];
  buildInputs = [ openssl openssl.dev zlib ];

  preConfigure = ''
    export HOME=$PWD

    git config --global url."file://${docca}".insteadOf "${docca.url}"
    git config --global url."file://${rocksdb-merged}".insteadOf "${rocksdb.url}"
    git config --global url."file://${lz4}".insteadOf "${lz4.url}"
    git config --global url."file://${libarchive}".insteadOf "${libarchive.url}"
    git config --global url."file://${soci}".insteadOf "${soci.url}"
    git config --global url."file://${snappy}".insteadOf "${snappy.url}"
    git config --global url."file://${nudb}".insteadOf "${nudb.url}"
    git config --global url."file://${protobuf}".insteadOf "${protobuf.url}"
    git config --global url."file://${google-benchmark}".insteadOf "${google-benchmark.url}"
    git config --global url."file://${google-test}".insteadOf "${google-test.url}"

    substituteInPlace Builds/CMake/deps/Sqlite.cmake --replace "URL ${sqlite3.url}" "URL ${sqlite3}"
  '';

  doCheck = true;
  checkPhase = ''
    ./rippled --unittest
  '';

  meta = with stdenv.lib; {
    description = "Ripple P2P payment network reference server";
    homepage = https://github.com/ripple/rippled;
    maintainers = with maintainers; [ ehmry offline ];
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
  };
}
