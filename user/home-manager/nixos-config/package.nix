{ callPackage
, lib
, stdenv
, fetchurl
, bashly
, installShellFiles
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nixos-config";
  version = "0.1";
  phases = [ "unpackPhase" "installPhase" ];

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    bashly
  ];

  src = ./.;

  installPhase = ''
    bashly generate
    install -Dm755 nixos-config $out/bin/nixos-config
    bash $out/bin/nixos-config completions > ./nixos-config.bash
    installShellCompletion --cmd nixos-config \
      --bash ./nixos-config.bash
  '';

  meta = with lib; {
    description = "NixOS configuration alias and utility functions";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "nixos-config";
    platforms = platforms.all;
  };
})
