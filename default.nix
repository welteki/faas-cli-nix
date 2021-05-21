with (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/80fcac0b311031657783b721c935d2d9348dffee.tar.gz") {} );

buildGoModule rec {
  pname = "faas-cli";
  version = "0.13.9";
  commit = "2cec97955a254358de5443987bedf8ceee272cf8";

  src = fetchFromGitHub {
    rev = "${version}";
    owner = "openfaas";
    repo = "faas-cli";
    sha256 = "102gsa9v4nvnvrvgm64hkv0ksnz8hhm5y6kqqkcvmij2x65y7ab3";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  CGO_ENABLED = 0;
  buildFlagsArray = [ ''
    -ldflags=
    -s -w 
    -X github.com/openfaas/faas-cli/version.GitCommit=${commit}
    -X github.com/openfaas/faas-cli/version.Version=${version}
    -X github.com/openfaas/faas-cli/commands.Platform=${builtins.currentSystem}
    '' 
    "-a"
  ];

  meta = with lib; {
    description = "Official CLI for OpenFaaS";
    homepage = "https://github.com/openfaas/faas-cli";
    license = licenses.mit;
  };
}