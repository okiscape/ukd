{ lib }:
let
  stripComment = line:
    lib.strings.trim (lib.concatStringsSep "" (lib.take 1 (lib.splitString "#" line)));

  ignoredNames = lib.filter
    (name: name != "")
    (map stripComment (lib.splitString "\n" (builtins.readFile ../../../.ukdignore)));
in
rec {
  inherit ignoredNames;

  isIgnored = name: builtins.elem name ignoredNames;
  filterModules = modules: lib.filterAttrs (name: _: !(isIgnored name)) modules;
}
