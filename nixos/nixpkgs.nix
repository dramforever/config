args @
{ configFile ? ./config.json
, ...
}:

let
  config = builtins.fromJSON (builtins.readFile configFile);
  config' = config // args;
in builtins.fetchTarball { inherit (config') name url sha256; }
