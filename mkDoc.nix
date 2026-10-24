{ stdenv, lib, pandoc, pkgs, fontconfig }:
{ texlive-combined ? pkgs.texliveMedium
, extraTexInputs ? [ ]
, font ? null
, extraBuildInputs ? [ ]
, ...
}@args:

stdenv.mkDerivation ({
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  nativeBuildInputs =
    [ pandoc texlive-combined ]
    ++ lib.optional (!isNull font) fontconfig
    ++ extraBuildInputs;

  TEXINPUTS = builtins.concatStringsSep ":" ([ "." ] ++ extraTexInputs ++ [ "" ]);
} // lib.optionalAttrs (!isNull font) {
  XDG_DATA_HOME = "${font}/share";
  preBuild = "fc-cache -f -v";
  shellHook = "runHook preBuild";
} // args)
