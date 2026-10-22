{
  pkgs,
  lib ? pkgs.lib,
}:
let
  treeSitterPython = pkgs.python3.withPackages (ps: [
    ps.tree-sitter
    ps.tree-sitter-grammars.tree-sitter-fish
  ]);

  replacements = {
    cat = "${pkgs.coreutils}/bin/cat";
    env = "${pkgs.coreutils}/bin/env";
    rm = "${pkgs.coreutils}/bin/rm";
    mktemp = "${pkgs.coreutils}/bin/mktemp";
    mkdir = "${pkgs.coreutils}/bin/mkdir";
    uname = "${pkgs.coreutils}/bin/uname";
    touch = "${pkgs.coreutils}/bin/touch";
    # ls = "${pkgs.coreutils}/bin/ls";
    # head = "${pkgs.coreutils}/bin/head";
    # tail = "${pkgs.coreutils}/bin/tail";
    # wc = "${pkgs.coreutils}/bin/wc";
    # sort = "${pkgs.coreutils}/bin/sort";
    # cut = "${pkgs.coreutils}/bin/cut";
    # tr = "${pkgs.coreutils}/bin/tr";
    # basename = "${pkgs.coreutils}/bin/basename";
    # dirname = "${pkgs.coreutils}/bin/dirname";
    # realpath = "${pkgs.coreutils}/bin/realpath";
    seq = "${pkgs.coreutils}/bin/seq";
    # grep = "${pkgs.gnugrep}/bin/grep";
  };

  rewriteScript =
    pkgs.writeText "rewrite-fish-external-commands.py"
      # py
      ''
        import json
        import os
        import sys
        from pathlib import Path

        import tree_sitter_fish
        from tree_sitter import Language, Parser, Query, QueryCursor

        language = Language(tree_sitter_fish.language())
        parser = Parser(language)

        # Capture each command node so we can handle ordinary commands as well as
        # commands prefixed with `command` or `exec`.
        query = Query(language, "(command) @command_node")

        replacements = {
            name.encode(): os.fsencode(path)
            for name, path in json.loads(sys.argv[1]).items()
        }
        root = Path(sys.argv[2])

        for path in root.rglob("*.fish"):
            if not path.is_file():
                continue

            source = path.read_bytes()
            tree = parser.parse(source)
            captures = QueryCursor(query).captures(tree.root_node)

            edits = []
            for command_node in captures.get("command_node", []):
                name_node = command_node.child_by_field_name("name")
                if name_node is None:
                    continue

                name = source[name_node.start_byte:name_node.end_byte]

                if name in (b"command", b"exec"):
                    # Rewrite only the first argument, not later arguments that
                    # happen to have the same name as a replacement.
                    target_node = next(
                        (
                            child
                            for i, child in enumerate(command_node.children)
                            if command_node.field_name_for_child(i) == "argument"
                        ),
                        None,
                    )
                else:
                    target_node = name_node

                # Only rewrite bare words, such as `cat` in `command cat`.
                if target_node is None or target_node.type != "word":
                    continue

                replacement = replacements.get(
                    source[target_node.start_byte:target_node.end_byte]
                )
                if replacement is not None:
                    edits.append(
                        (target_node.start_byte, target_node.end_byte, replacement)
                    )

            if not edits:
                continue

            updated = bytearray(source)
            for start, end, replacement in sorted(edits, reverse=True):
                updated[start:end] = replacement

            path.write_bytes(updated)
      '';
  replacementJson = builtins.toJSON replacements;

  mkOptional =
    cmd: functionFile:
    # sh
    ''
      mkdir -p share/functions.bak
      sed -i "1a\if not command -sq ${cmd}" share/functions/${functionFile}
      sed -i "2a\  return 1" share/functions/${functionFile}
      sed -i "3a\end" share/functions/${functionFile}
      cp share/functions/${functionFile} share/functions.bak/.
    '';
in
pkgs.fish.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ treeSitterPython ];

  postPatch =
    (old.postPatch or "")
    +
    # sh
    ''
      # issues:
      # - fish has no built-in way to automatically erase a wrapper
      #   when the wrapped command becomes unavailable.

      # goals:
      # - ensure the generated shell does not depend on coreutils at runtime.
      # - prevent wrappers from being defined under coreutils command names when the
      #   corresponding command is unavailable at runtime.

      # fish embeds functions found under share/functions as functions named `embedded:NAME.fish`

      # a "wrapper" is a function that invokes a command that usually shares it's name, with
      # additional arguments or altered default behavior.

      # smart wrappers are defined only when the wrapped command exists. They are to be kept.

      # dumb wrappers are defined unconditionally. They should be turned into smart wrappers.

      # too-smart wrappers are wrappers that check wether or not the wrapped command exists
      # but provide a fallback. They often occupy an unwanted namespace. They are to be removed.

      # smart wrappers
      # man
      # diff
      # kill

      # dumb wrappers
      # grep is the only dependency that is replaced with it's store path
      sed -i 's%/nix/store/[0-9a-z]\{32\}-(gnu)?grep-\d+.\d+/bin/%%' share/functions/grep.fish
      ${mkOptional "grep" "grep.fish"}

      ${mkOptional "ls" "la.fish"}
      ${mkOptional "ls" "ll.fish"}
      ${mkOptional "ls" "ls.fish"}

      # too-smart wrappers
      rm share/functions/seq.fish
      # realpath is also a builtin :(
      sed -i 's/builtin realpath/realpath/g' share/functions/*.fish
      sed -i 's/builtin realpath/realpath/g' tests/checks/*.fish
      rm tests/checks/realpath.fish tests/checks/fish_add_path.fish
      ${mkOptional "realpath" "realpath.fish"}
      rm src/builtins/realpath.rs
      sed -i '/pub mod realpath;/d' src/builtins/mod.rs
      sed -E -i -e ':a;N;$!ba;s/[[:blank:]]*BuiltinData [{]\n[[:blank:]]*name: L!\("realpath"\),\n[[:blank:]]*func: realpath::realpath,\n[[:blank:]]*[}],\n?//g' src/builtins/shared/misc.rs
      sed -i '/.*realpath.*/d' src/builtins/shared/misc.rs
      sed -i '8,10d;36,47d' tests/checks/type.fish # realpath is checked to be a function

      ${treeSitterPython}/bin/python \
        ${rewriteScript} \
        '${replacementJson}' \
        share/functions

      mv share/functions.bak/* share/functions/.
      rmdir share/functions.bak
    '';

  postInstall = (old.postInstall or "") + ''
    rm -f "$out/share/applications/fish.desktop"
  '';
})
# missing:
# completions/pushd.fish # seq
# /run/current-system/sw/share/fish/vendor_completions.d/nix.fish
