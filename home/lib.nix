{
  forceExplicitFlatpakPackageUpdate = builtins.map (
    item:
      if builtins.isString item
      then throw "Package entries must use a `commit`, a `sha256` or `allowAutoUpdate`"
      else let
        hasAutoUpdate = item ? allowAutoUpdate;
        autoUpdateEnabled = hasAutoUpdate && item.allowAutoUpdate;
      in
        if autoUpdateEnabled && (item ? commit || item ? flatpakref || item ? sha256)
        then throw "`allowAutoUpdate` cannot be used together with `commit` or `sha256`."
        else builtins.removeAttrs item ["allowAutoUpdate"]
  );
}
