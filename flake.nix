{
  description = "A mecha-themed waybar setup, for nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    mechabar = ./mechabar.nix;

  };
}
