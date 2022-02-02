{...}: (builtins.getFlake "git+file://${builtins.toString ./.}").legacyPackages.${builtins.currentSystem}
