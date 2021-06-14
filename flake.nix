{
  description = "Official CLI for OpenFaaS ";

  inputs =
    {
      nixpkgs.follows = "nix/nixpkgs";
      flake-compat = {
        url = "github:edolstra/flake-compat";
        flake = false;
      };
      faas-cli-src = {
        url = "https://github.com/openfaas/faas-cli/archive/refs/tags/0.13.9.tar.gz";
        flake = false;
      };
    };

  outputs = { self, nixpkgs, nix, flake-compat, faas-cli-src }:
    let
      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" "armv7l-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlay = final: prev: {
        faas-cli = with final;
          buildGoModule rec {
            pname = "faas-cli";
            version = "0.13.9";
            commit = "2cec97955a254358de5443987bedf8ceee272cf8";

            src = "${faas-cli-src}";

            vendorSha256 = null;

            subPackages = [ "." ];

            CGO_ENABLED = 0;
            buildFlagsArray = [
              ''
                -ldflags=
                -s -w 
                -X github.com/openfaas/faas-cli/version.GitCommit=${commit}
                -X github.com/openfaas/faas-cli/version.Version=${version}
                -X github.com/openfaas/faas-cli/commands.Platform=${system}
              ''
              "-a"
            ];
          };
      };

      defaultPackage = forAllSystems (system: (import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      }).faas-cli);
    };
}
