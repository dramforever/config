{
  boot.blacklistedKernelModules = [ "rds" "rds_tcp" "rds_rdma" ];
  boot.extraModprobeConfig = ''
    install rds /run/current-system/sw/bin/false
    install rds_tcp /run/current-system/sw/bin/false
    install rds_rdma /run/current-system/sw/bin/false
  '';
}
