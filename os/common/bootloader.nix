{
  boot.loader.limine = {
    enable = true;
    style = {
      wallpapers = [];
      interface = {
        helpHidden = true;
        branding = "";
      };
    };
    extraConfig = ''
      timeout: 0.25
      quiet: yes
    '';
  };
}
