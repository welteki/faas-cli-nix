# faas-cli-nix
[faas-cli](https://github.com/openfaas/faas-cli) packaged up in Nix.

> This repository has been archived and wil not receive any updates: faas-cli is now available in [nixpkgs](https://github.com/NixOS/nixpkgs)

## Installing

faas-cli can be installed from source into the user profile like this:

```
$  nix-env -if https://github.com/welteki/faas-cli-nix/archive/main.tar.gz
```

### Enable cache (optional)

Enable [Nix cache](https://app.cachix.org/cache/welteki/) for faas-cli

```
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use welteki
```
