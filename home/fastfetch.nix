{flake}:
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
              "type": "title",
              "key": "  {icon} ",
              "format": "{host-name}",
          },
          {
              "type": "host",
              "key": "  {icon} ",
          },
          {
              "type": "cpu",
              "key": "  {icon} ",
          },
          {
              "type": "gpu",
              "key": "  {icon} ",
          },
          {
              "type": "physicalmemory",
              "key": "  {icon} ",
              "format": "{serial} or?"
          },
          {
              "type": "memory",
              "key": "  {icon} ",
              "format": "{total}"
          },
          {
              "type": "physicaldisk",
              "hideVirtual": true,
              "key": "  {icon} ",
              "format": "{name} {size} {interconnect}"
          },
          //{
          //    "type": "disk",
          //    "key": "   ",
          //    "format": "{size-total} {filesystem} {mountpoint}"
          //},
          {
              "type": "display",
              "key": "  {icon} ",
              "format": "{width}x{height}@{refresh-rate}Hz ({type})"
          },
          {
              "type": "custom",
              "format": "\u001b[90m├──────────────── Software Information"
          },
          {
              "type": "bios",
              "key": "   ",
              //"key": "  {icon} ",
              "format": "{vendor} {version}"
          },
          {
              "type": "bootmgr",
              "key": "   ",
              "format": "Secure-Boot {?secure-boot}ON {/secure-boot}OFF"
          },
          {
              "type": "tpm",
              "key": "   ",
              "format": "{?version}TPM {version}{?}"
          },
          {
              "type": "kernel",
              "key": "  {icon} ",
          },
          {
              "type": "initsystem",
              "key": "  {icon} ",
              "format": "TPM {version}{/version}Absent"
          },
          {
              "type": "os",
              "key": "  {icon} ",
          },
          {
              "type": "packages",
              "key": "  {icon} ",
          },
          {
              "type": "custom",
              "key": "   ",
              "format": "${flake.rev or flake.dirtyRev}"
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
              "type": "lm",
              "key": "  {icon} ",
              "format": "{pretty-name} ({service})",
          },
          {
              "type": "de",
              "key": "  {icon} ",
          },
          {
              "type": "wm",
              "key": "  {icon} ",
          },
          //{
          //    "type": "vulkan",
          //    "key": "  {icon} ",
          //},
          {
              "type": "custom",
              "format": "\u001b[90m├──────────────── Appearance Information"
          },
          {
              "type": "theme",
              "key": "  {icon} ",
          },
          {
              "type": "icons",
              "key": "  {icon} ",
          },
          {
              "type": "font",
              "key": "  {icon} ",
          },
          {
              "type": "terminalfont",
              "key": "  {icon} ",
          },
          {
              "type": "custom",
              "format": "\u001b[90m└───────────────────┐"
          },
          {
              "type": "colors",
              "paddingLeft": 20,
              "blockWidth": 100,
              "symbol": "circle"
          }

      ]
  }
''
