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

	  yasunori-slot = pkgs.writeShellApplication {
	  name = "yasunori-slot"; 
	  runtimeInputs = [pkgs.ruby];
	  text = ''
	  ruby -e 'puts "yasunori".split("").shuffle.map{|char| ":alphabet-white-#{char}:"}.join("")'
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
