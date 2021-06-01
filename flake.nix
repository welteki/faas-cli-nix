{
  description = "Official CLI for OpenFaaS ";

  inputs =
    {
      nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09;
      faas-cli-src = {
        url = "https://github.com/openfaas/faas-cli/archive/refs/tags/0.13.9.tar.gz";
        flake = false;
      };
    };

  outputs = { self, nixpkgs, faas-cli-src }: {
    defaultPackage.x86_64-linux =
      with import nixpkgs
        {
          system = "x86_64-linux";
        };
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
}
