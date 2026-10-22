{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    alacritty
  ];
  xdg.configFile.alacritty-toml = {
    text = /* toml */ ''
      [font]
      size = 12

      [font.bold]
      family = "FiraCode Nerd Font"
      style = "Bold"

      [font.bold_italic]
      family = "FiraCode Nerd Font"
      style = "BoldItalic"

      [font.italic]
      family = "FiraCode Nerd Font"
      style = "MediumItalic"

      [font.normal]
      family = "FiraCode Nerd Font"
      style = "Medium"

      [general]
      import = ["${config.xdg.configHome}/alacritty/themes/noctalia.toml"]
    '';
    target = "alacritty/alacritty.toml";
  };
}
