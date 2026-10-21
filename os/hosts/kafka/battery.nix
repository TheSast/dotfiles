{
  # TODO: swapon/swapoff a hinernmation-dedicated swap on system hibernation/resume
  # there is no way to disable non-hibernation swap and to set swappiness per-swap file/partition
  # this also means zram is hard to make use of
  boot.kernel.sysctl."vm.swappiness" = 0;
  # TODO: use boot.zswap.enable instead
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    priority = 100;
  };
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "10m";
    HibernateMode = "shutdown";
  };
  services.upower.enable = true;
}
