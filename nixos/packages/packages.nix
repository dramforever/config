self: super:

let
  dirContents = builtins.readDir ./.;
  isSoftware = name: dirContents.${name} == "directory";

  genSoftware = name:
    {
      inherit name;
      value = self.callPackage (./. + "/${name}") {};
    };

  names = builtins.attrNames dirContents;
  softwares = builtins.filter isSoftware names;

in builtins.listToAttrs (builtins.map genSoftware softwares)
