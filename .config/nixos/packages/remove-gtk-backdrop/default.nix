{ pkgs, theme }:
theme.overrideAttrs (old: {
  pname = "${old.pname or "theme"}-no-gtk-backdrop";
  postInstall = (old.postInstall or "") + ''
    NODE_PATH=${pkgs.postcss}/lib/node_modules \
    GRESOURCE=${pkgs.glib.dev}/bin/gresource \
    GTK_LIB=${pkgs.gtk3}/lib/libgtk-3.so.0 \
    ${pkgs.nodejs}/bin/node ${./strip-backdrop.cjs} $out/share/themes
  '';
})
