{pkgs}: {
  deps = [
    pkgs.libffi
    pkgs.zlib
    pkgs.readline
    pkgs.openssl_3_3
    pkgs.libyaml
  ];
}
