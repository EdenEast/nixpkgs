{ stdenv, fetchFromGitHub, cargo, rustc, rustPlatform, pkgconfig, glib, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  version = "0.2.14-dev";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "5c60588e324e3d749c8991b37c76eb7ea82dfd6b";
    sha256 = "19z9fdkn3bnr8q33m66h2by6bs6kmhw3a2lq2n8bywmnhrjwhxpw";
  };

  cargoSha256 = "sha256-fEiq4yMRk8GNdUiJAaF/NJYRB8JFlx1AE7kQ+xrXaXo=";

  cargoBuildFlags = [ "--features=all" ];
  nativeBuildInputs = [
    pkgconfig cargo rustc
  ];
  buildInputs = [
    openssl
  ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  # Tests fail because of client server setup which is not possible inside the pure environment,
  # see https://github.com/mozilla/sccache/issues/460
  checkPhase = null;

  meta = with stdenv.lib; {
    description = "Ccache with Cloud Storage";
    homepage = "https://github.com/mozilla/sccache";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
