{
  callPackage,
  linuxPackagesFor,
  kernelPatches,
}:

linuxPackagesFor (callPackage ./linux_asahi.nix {
  kernelPatches = with kernelPatches; [
    bridge_stp_helper
    request_key_helper
  ];
})
