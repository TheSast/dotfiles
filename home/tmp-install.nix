{
  # a shell alias should be used to set the default profile to nix-tmpinstall
  xdg = {
    systemDirs = {
      config = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/etc/xdg" ];
      data = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/share" ];
    };
  };
  home = {
    sessionPath = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/bin" ];
    sessionSearchVariables = {
      INFOPATH = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/share/info" ];
      XCURSOR_PATH = [
        "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/bin"
      ];
      TERMINFO_DIRS = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/share/terminfo" ];
      GTK_PATH = [
        "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/lib/gtk-2.0"
        "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/lib/gtk-3.0"
        "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/lib/gtk-4.0"
      ];
      LIBEXEC_PATH = [ "\${XDG_RUNTIME_DIR:-/run/user/$EUID}/nix-tmpinstall/profile/libexec" ];
    };
  };
}
