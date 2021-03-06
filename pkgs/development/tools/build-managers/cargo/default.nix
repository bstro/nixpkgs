{ stdenv, fetchgit, rustPlatform, file, curl, python, pkgconfig, openssl
, cmake, zlib }:

with ((import ./common.nix) { inherit stdenv; version = "2015-05-13"; });

with rustPlatform;

buildRustPackage rec {
  inherit name version meta;

  src = fetchgit {
    url = "https://github.com/rust-lang/cargo.git";
    rev = "d814fcbf8efda3027d54c09e11aa7eaf0006a83c";
    sha256 = "0sppd3x2cacmbnypcjip44amnh66lrrbwwzsbz8rqf3nq2ah496x";
    leaveDotGit = true;
  };

  depsSha256 = "1b0mpdxmp7inkg59n2phjwzpz5gx22wqg9rfd1s01a5ylara37jw";

  buildInputs = [ file curl pkgconfig python openssl cmake zlib ];

  configurePhase = ''
    ./configure --enable-optimize --prefix=$out --local-cargo=${cargo}/bin/cargo
  '';

  buildPhase = "make";

  # Disable check phase as there are lots of failures (some probably due to
  # trying to access the network).
  doCheck = false;

  installPhase = ''
    make install
    ${postInstall}
  '';
}
