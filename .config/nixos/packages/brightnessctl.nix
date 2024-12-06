{ pkgs, flakes }:

pkgs.stdenv.mkDerivation {
  name = "brightnessctl";

  src = "${flakes.brightnessctl}";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  configureFlags = [ "--enable-logind" ];
  makeFlags = [ "PREFIX=" "DESTDIR=$(out)" "config.mk" ];

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ systemd ];
}
