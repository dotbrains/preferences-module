# Evaluation harness for the Nix provisioning adapters in this repo.
#
# Evaluating this file forces every adapter module through the real
# option schemas (nix-darwin, home-manager, NixOS), so a mistyped
# option name or a type error fails evaluation. Evaluation is
# platform-independent: the darwin configuration evaluates fine on a
# Linux CI runner.
#
# Run via scripts/validate-nix.sh (requires nix-instantiate and
# network access for the pinned tarballs).

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-25.05-darwin.tar.gz";
  darwin = fetchTarball "https://github.com/nix-darwin/nix-darwin/archive/nix-darwin-25.05.tar.gz";
  homeManager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";

  darwinEval = import darwin {
    inherit nixpkgs;
    system = "aarch64-darwin";
    configuration = { ... }: {
      imports = [ ../../macos/nix-darwin.nix ];
      system.primaryUser = "testuser";
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  };

  hmEval = import "${homeManager}/modules" {
    pkgs = import nixpkgs { system = "aarch64-linux"; };
    configuration = { ... }: {
      imports = [
        ../../universal/home-manager.nix
        ../../arch/home-manager.nix
        ../../debian/home-manager.nix
      ];
      home.username = "testuser";
      home.homeDirectory = "/home/testuser";
      home.stateVersion = "25.05";
    };
  };

  nixosEval = import "${nixpkgs}/nixos/lib/eval-config.nix" {
    system = "aarch64-linux";
    modules = [
      ../../universal/nixos.nix
      ({ ... }: {
        fileSystems."/" = {
          device = "/dev/vda1";
          fsType = "ext4";
        };
        boot.loader.grub.device = "nodev";
        system.stateVersion = "25.05";
      })
    ];
  };
in
{
  # Forcing representative values evaluates the full module fixed
  # point, which asserts that no module defines an undeclared option.
  darwinDockTilesize = darwinEval.config.system.defaults.dock.tilesize;
  darwinTouchId = darwinEval.config.security.pam.services.sudo_local.touchIdAuth;
  darwinActivation = builtins.isString darwinEval.config.system.activationScripts.postActivation.text;
  hmUsername = hmEval.config.home.username;
  nixosStateVersion = nixosEval.config.system.stateVersion;
}
