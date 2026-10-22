{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
# bash
''
  # is always interactive
  eval "$(${lib.getExe pkgs.starship} init bash)"
  if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] && command -v fish >/dev/null
  then
    export SHELL=$(command -v fish)
    exec fish
  fi
''
