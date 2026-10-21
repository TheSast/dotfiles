{
  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    consoleLogLevel = 0; # reduce console logs
    initrd.verbose = false; # reduce initrd output
    initrd.systemd.enable = true; # use initrd, apparently spawning plymouth faster
    kernelParams = [
      "quiet" # ask quiet
      "fbcon=nodefer" # do not use vendor logo
      # "splash"
      # "vga=current"
      "loglevel=3" # only produce errors and worse
      "udev.log_level=3" # same as above
      "rd.udev.log_level=3" # same as above for initrd
      "rd.systemd.show_status=false" # hide systemd messages
      "vt.global_cursor_default=0" # remove cursor blink
    ];
  };
}
