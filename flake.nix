{
  description = "Official CLI for OpenFaaS ";

  inputs = {
    nixpkgs.follows = "nix/nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix, flake-compat }:
    let
      supportedSystems = [
        "x86_64-linux"
        "i686-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "armv7l-linux"
      ];

      faasPlatform = platform:
        let cpuName = platform.parsed.cpu.name; in
          {
            "aarch64" = "arm64";
            "armv7l" = "armhf";
          }.${cpuName} or cpuName;

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlay = final: prev:
        let
          inherit (final) stdenv buildGoModule fetchFromGitHub;
        in
        {
          faas-cli = buildGoModule rec {
            pname = "faas-cli";
            version = "0.13.13";
            rev = "72816d486cf76c3089b915dfb0b66b85cf096634";
            platform = faasPlatform stdenv.targetPlatform;

            src = fetchFromGitHub {
              owner = "openfaas";
              repo = "faas-cli";
              rev = "${rev}";
              sha256 = "0mmrakyy2qmkldld7pxf5bx6whdadq2r52b68f9p9z7yqrdimix8";
            };

            vendorSha256 = null;

            subPackages = [ "." ];

            CGO_ENABLED = 0;
            buildFlagsArray = [
              ''
                -ldflags=
                -s -w 
                -X github.com/openfaas/faas-cli/version.GitCommit=${rev}
                -X github.com/openfaas/faas-cli/version.Version=${version}
                -X github.com/openfaas/faas-cli/commands.Platform=${platform}
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
