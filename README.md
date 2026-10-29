# bcompare4

A Nix flake that packages [Beyond Compare 4](https://www.scootersoftware.com), Scooter Software's proprietary tool for comparing files, folders and archives.

## Outputs

| Attribute          | What you get                                             |
| ------------------ | -------------------------------------------------------- |
| `overlays.default` | The package in your own package set as `pkgs.bcompare4`. |

The flake publishes no `packages`. Applying the overlay and permitting the licence is the consumer's own declaration:

```nix
nixpkgs.overlays = [ bcompare4.overlays.default ];
nixpkgs.config.allowUnfreePredicate = pkg: pkg.pname == "bcompare";
```

## Requirements and notes

- `x86_64-linux` only. The package is the AMD64 Debian archive upstream publishes for Linux, repacked, so there is nothing to build for another platform.
- It is a GTK2 desktop application. GTK2 speaks X11, so on a Wayland session the window is presented through XWayland.
- Launching `bcompare` starts the GUI on any desktop. The KDE file-manager integration components are not in the output.
- Continued use past the 30-day evaluation period requires a purchased licence key, and the key you buy is scoped to a user, site or enterprise and to a platform.
- The package declares upstream's unfree licence, so nixpkgs refuses to evaluate it in any set that has not said otherwise. An instantiated package published here would have been built under a permit written here, which is why there is none: the set that builds the package is the set whose config answers for the licence. `allowUnfreePredicate` naming `pname bcompare` permits this package and nothing else; `allowUnfree = true` permits everything.

See [LICENSE.md](LICENSE.md) for licensing and copyright, and [NOTICE.md](NOTICE.md) for the terms of upstream and distributed artifacts.
