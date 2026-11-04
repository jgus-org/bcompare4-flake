# AGENTS.md

This file provides shared guidance to agents working in this repository. `CLAUDE.md` is a compatibility symlink to this file.

This flake follows the fleet flake standard: [jgus-org/flake-lib `AGENTS.md`](https://github.com/jgus-org/flake-lib/blob/v1/AGENTS.md). It owns what belongs in `flake.nix`, `pin.nix`, and `flake.lock`, how to author a producer, the update workflows, the build gate, and every rule a flake in this fleet follows. Read it before changing this flake, and read the library at the revision this flake's `flake.lock` names for anything a caller passes to it.

Anything specific to this repository belongs here. Anything the standard states belongs to the standard, which this file links rather than restating.

The `follows` edge the standard makes the default is deliberately absent here. This is legacy payload: Beyond Compare 4 links `gtk2`, which current nixpkgs marks broken, so `nixpkgs` stays on `nixos-26.05` — the last release that still evaluates it. Following that pin would resolve flake-lib's formatter tools on a channel carrying no `pedantix`, which is a hard evaluation failure rather than a formatting difference. Treat both the pin and the missing edge as load-bearing; moving the channel means moving Beyond Compare onto gtk3 or gtk4 first.
