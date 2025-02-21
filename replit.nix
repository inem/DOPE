{pkgs}: {
  deps = [
    pkgs.libpqxx_6
    pkgs.libffi
    pkgs.zlib
    pkgs.readline
    pkgs.openssl_3_3
    pkgs.libyaml
  ];
}
