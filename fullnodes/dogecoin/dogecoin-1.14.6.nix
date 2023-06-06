{ lib, stdenv , fetchFromGitHub
, pkg-config, autoreconfHook
, db5, openssl, boost, zlib, miniupnpc, libevent
, protobuf, util-linux, qt4, qrencode
, withGui, withUpnp ? true, withUtils ? true, withWallet ? true
, withZmq ? true, zeromq }:

with lib;
stdenv.mkDerivation rec {
  name = "dogecoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "dogecoin";
    repo = "dogecoin";
    rev = "v${version}";
    hash = "sha256-PmbmmA2Mq07dwB3cI7A9c/ewtu0I+sWvQT39Yekm/sU=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook util-linux ];
  buildInputs = [ openssl protobuf boost zlib libevent ]
    ++ optionals withGui [ qt4 qrencode ]
    ++ optionals withUpnp [ miniupnpc ]
    ++ optionals withWallet [ db5 ]
    ++ optionals withZmq [ zeromq ];

  configureFlags = [
    "--with-incompatible-bdb"
    "--with-boost-libdir=${boost.out}/lib"
  ] ++ optionals (!withGui) [ "--with-gui=no" ]
    ++ optionals (!withUpnp) [ "--without-miniupnpc" ]
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
