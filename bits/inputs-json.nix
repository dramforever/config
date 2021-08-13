rootFlake:

let
  findInputs = flake: {
    path = flake.outPath;
    inputs = builtins.mapAttrs (name: value: findInputs value) flake.inputs;
  };
  inputsText = builtins.toJSON (findInputs rootFlake);
in
  builtins.toFile "inputs" inputsText
