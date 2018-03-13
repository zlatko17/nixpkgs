{ stdenv, fetchurl, pkgconfig, meson, ninja, makeFontsConf
, gnome3, glib, json-glib, libarchive, libsoup, gobjectIntrospection }:

let
  pname = "libhttpseverywhere";
  version = "0.8.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1022j79648zmfvngazvrabn09r89h6qg0yykl9yrr4fsjbfmsgps";
  };

  nativeBuildInputs = [ gnome3.vala gobjectIntrospection meson ninja pkgconfig ];
  buildInputs = [ glib gnome3.libgee json-glib libsoup libarchive ];

  mesonFlags = [ "-Denable_valadoc=true" ];

  doInstallCheck = true;

  installCheckPhase = ''
    XDG_DATA_DIRS=$out/share:$XDG_DATA_DIRS ./test/httpseverywhere_test
  '';

  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  outputs = [ "out" "devdoc" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Library to use HTTPSEverywhere in desktop applications";
    homepage = https://git.gnome.org/browse/libhttpseverywhere;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sternenseemann ] ++ gnome3.maintainers;
  };
}
