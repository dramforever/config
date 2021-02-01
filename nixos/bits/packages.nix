self: super:

with builtins;

let
  dirContents = readDir ../packages;

  genPackage = name:
    {
      inherit name;
      value = self.callPackage (../packages + "/${name}") {};
    };

  names = attrNames dirContents;

in listToAttrs (map genPackage names)
