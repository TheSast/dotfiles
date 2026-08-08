{
  config,
  pkgs,
  lib,
  flakeLoc,
}:
# json
''
  {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "modules": [
          "break",
          {
              "type": "custom",
              "format": "\u001b[90m┌──────────────── Hardware Information"
          },
          {
              "type": "host",
              "key": "  󰟀 ",
          },
          {
              "type": "cpu",
              "key": "   ",
          },
          {
              "type": "gpu",
              "key": "  󱄄 ",
          },
          {
              "type": "memory",
              "key": "   ",
              "format": "{total}"
          },
          {
              "type": "disk",
              "key": "   ",
              "format": "{size-total} {filesystem} {mount-from} -> {mountpoint}"
          },
          {
              "type": "display",
              "key": "  󰹑 ",
              "format": "{width}x{height}@{refresh-rate}Hz ({type})"
          },
          {
              "type": "custom",
              "format": "\u001b[90m├──────────────── Software Information"
          },
          {
              "type": "bios",
              "key": "   ",
              "format": "{vendor} {version}"
          },
          {
              "type": "kernel",
              "key": "   ",
          },
          {
              "type": "os",
              "key": "   ",
          },
          {
              "type": "packages",
              "key": "  󰏖 ",
          },
          {
              "type": "command",
              "Key": "   ",
              "text": "echo $(${lib.getExe pkgs.git} --git-dir=${flakeLoc}/.git --work-tree=${flakeLoc} rev-parse HEAD)$(${lib.getExe pkgs.git} --git-dir=${flakeLoc}/.git --work-tree=${flakeLoc} diff-index --quiet HEAD -- || echo '-dirty')"
          },
          {
              "type": "shell",
              "key": "   ",
          },
          {
              "type": "terminal",
              "key": "   ",
          },
          {
              "type": "de",
              "key": "   ",
          },
          {
              "type": "wm",
              "key": "   ",
          },
          {
              "type": "custom",
              "format": "\u001b[90m├──────────────── Appearance Information"
          },
          // info "    " term_font
          {
              "type": "command",
              "Key": "  󰉼 ",
              "text": "echo $(${config.xdg.configHome}/scripts/theme.sh)"
          },
          {
              "type": "command",
              "Key": "   ",
              "text": "echo $(grep 'gtk-theme-name' ${config.xdg.configHome}/gtk-2.0/gtkrc | sed -e 's/.*gtk-theme-name = //' | sed -e 's/\"//g')/$(grep gtk-theme-name ${config.xdg.configHome}/gtk-3.0/settings.ini | sed -e s/gtk-theme-name=//)/$(grep gtk-theme-name ${config.xdg.configHome}/gtk-4.0/settings.ini | sed -e s/gtk-theme-name=//)"
          },
          // {
          //     "type": "custom",
          //     "format": "\u001b[90m└────────────────────── Colors"
          // },
          {
              "type": "colors",
              "paddingLeft": 22,
              "blockWidth": 100,
              "symbol": "circle"
          }

      ]
  }
''
