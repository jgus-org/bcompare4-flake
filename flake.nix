{
  description = "Beyond Compare 4";

  inputs = {
    flake-lib.url = "github:jgus-org/flake-lib/v1";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    {
      self,
      flake-lib,
      nixpkgs,
      ...
    }:
    let
      pin = import ./pin.nix;
    in
    {
      overlays.default = final: _prev: {
        bcompare4 = final.stdenv.mkDerivation {
          inherit (pin) version;
          buildInputs = [
            (final.lib.getLib final.stdenv.cc.cc)
            final.bzip2
            final.cairo
            final.gdk-pixbuf
            final.gtk2
            final.pango
          ];
          dontBuild = true;
          dontConfigure = true;
          dontWrapQtApps = true;
          installPhase = ''
            mkdir -p "''${out}"/{bin,lib,share}
            cp -R usr/{bin,lib,share} "''${out}"/
            rm "''${out}"/lib/beyondcompare/ext/bcompare_ext_kde.amd64.so
            rm "''${out}"/lib/beyondcompare/ext/bcompare_ext_kde5.amd64.so
            substituteInPlace "''${out}"/bin/bcompare \
              --replace "/usr/lib/beyondcompare" "''${out}/lib/beyondcompare" \
              --replace "ldd" "${final.glibc.bin}/bin/ldd" \
              --replace 'if [ "$KDE_SESSION_VERSION" != "4" ] && [ "$KDE_SESSION_VERSION" != "5" ]; then' 'if [ "$KDE_SESSION_VERSION" = "3" ]; then' \
              --replace "/bin/bash" "${final.runtimeShell}"
            ln -s ${final.bzip2.out}/lib/libbz2.so.1 "''${out}"/lib/beyondcompare/libbz2.so.1.0
          '';
          meta = {
            description = "GUI application for comparing files and folders";
            homepage = "https://www.scootersoftware.com";
            license = final.lib.licenses.unfree;
            mainProgram = "bcompare";
            platforms = [ "x86_64-linux" ];
            sourceProvenance = [ final.lib.sourceTypes.binaryNativeCode ];
          };
          nativeBuildInputs = [ final.autoPatchelfHook ];
          pname = "bcompare";
          src = final.fetchurl {
            hash = pin.hash;
            url = "https://www.scootersoftware.com/bcompare-${pin.version}_amd64.deb";
          };
          unpackPhase = ''
            ar x "''${src}"
            tar xfz data.tar.gz
          '';
        };
      };
    }
    // flake-lib.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        orgFormatting = flake-lib.lib.mkFormatting {
          inherit self system;
        };
      in
      {
        checks =
          let
            checkPkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [ self.overlays.default ];
            };
          in
          {
            inherit (checkPkgs) bcompare4;
            formatting = orgFormatting.check;
          };
        formatter = orgFormatting.formatter;
      }
    );
}
