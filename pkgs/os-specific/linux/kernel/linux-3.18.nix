{ stdenv, fetchurl, ... } @ args:

let
  patches = (import ./patches { inherit stdenv fetchurl; });
in
import ./generic.nix (args // rec {
  version = "3.18.11";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "19di7k38adnwimxddd1v6flgdsvxhgf8iswjwfyqi2p2bdcb0p5d";
  };

  # FIXME: remove with the next point release.
  kernelPatches = args.kernelPatches ++
    [ patches.btrfs_fix_deadlock
    ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
