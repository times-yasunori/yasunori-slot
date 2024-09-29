{
  description = "A very smarp cli app.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs,
      treefmt-nix,
      flake-parts,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ treefmt-nix.flakeModule ];
      systems = import inputs.systems;

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          stdenv = pkgs.stdenv;
          yasunori-slot = stdenv.mkDerivation {
            pname = "yasunori-slot";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [ pkgs.ruby ];

            buildPhase = ''
              cat > yasunori-slot <<EOF
              #!/usr/bin/env bash
              ${pkgs.ruby}/bin/ruby ./yasunori-slot.rb
              EOF
            '';

            installPhase = ''
              install -D yasunori-slot $out/bin/yasunori-slot
              cp yasunori-slot.rb $out/bin/yasunori-slot.rb
            '';
          };
        in
        rec {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
            };

            settings.formatter = { };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nil
            ];
          };

          packages.default = yasunori-slot;
        };
    };
}
