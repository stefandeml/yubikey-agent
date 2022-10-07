{ pkgs, lib, stdenv, darwin, pcsclite, pkg-config, libnotify }:

pkgs.buildGoApplication rec {
  pname = "yubikey-agent";
  version = "0.1.5";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.PCSC);

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  #subPackages = [ "." ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace main.go --replace 'notify-send' ${libnotify}/bin/notify-send
  '';

  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;
}
