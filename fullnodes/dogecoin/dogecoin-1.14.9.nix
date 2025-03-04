{ lib, stdenv, fetchFromGitHub
, pkg-config, autoreconfHook
, db5, openssl, boost177, zlib, miniupnpc, libevent
, protobuf, util-linux
, withUpnp ? true, withUtils ? true, withWallet ? true
, withZmq ? true, zeromq }:

with lib;
stdenv.mkDerivation rec {
  pname = "dogecoin";
  version = "1.14.9";

  src = fetchFromGitHub {
    owner = "dogecoin";
    repo = "dogecoin";
    rev = "v${version}";
    hash = "sha256-aZ1l7Bqoq1SgKPcVuvqWLee01HIn8e2k/Y1vn+/dBT0=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook util-linux ];
  buildInputs = [ openssl protobuf boost177 zlib libevent ]
    ++ optionals withUpnp [ miniupnpc ]
    ++ optionals withWallet [ db5 ]
    ++ optionals withZmq [ zeromq ];

  configureFlags = [
    "--with-incompatible-bdb"
    "--with-boost-libdir=${boost177.out}/lib"
    "--with-gui=no"
  ] ++ optionals (!withUpnp) [ "--without-miniupnpc" ]
    ++ optionals (!withUtils) [ "--without-utils" ]
    ++ optionals (!withWallet) [ "--disable-wallet" ]
    ++ optionals (!withZmq) [ "--disable-zmq" ];

  enableParallelBuilding = true;

  meta = {
    description = "Wow, such coin, much shiba, very rich";
    longDescription = ''
      Dogecoin is a decentralized, peer-to-peer digital currency that
      enables you to easily send money online. Think of it as "the
      internet currency."
      It is named after a famous Internet meme, the "Doge" - a Shiba Inu dog.
    '';
    homepage = "http://www.dogecoin.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo offline ];
    platforms = platforms.linux;
  };
}
